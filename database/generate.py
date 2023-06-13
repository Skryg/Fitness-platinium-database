import random
import psycopg2
from faker import Faker
import enum

fake = Faker('pl_PL')


def get_address_in_krakow():
    address = fake.address().replace('\n', ', ')
    while 'Kraków' not in address:
        address = fake.address().replace('\n', ', ')
    return address


def get_phone_number():
    return str(random.randint(100000000, 999999999))


def format(*args):
    formatted_args = [f"'{arg}'" for arg in args]
    formatted_string = ", ".join(formatted_args)
    return formatted_string


def generate_person(num_ppl):
    conn = psycopg2.connect("dbname=postgres user=postgres password=postgres")
    cur = conn.cursor()
    print('generating:')
    person_ids = []
    try:
        sql = """INSERT INTO person (name, surname, address, phone, email) VALUES ("""
        for i in range(num_ppl):
            act = format(fake.first_name(), fake.last_name(), fake.address(), get_phone_number(), fake.email())
            cur.execute(sql + act + ") RETURNING id;")
            person_ids.append(cur.fetchone()[0])
        conn.commit()
        print("inserted " + str(num_ppl) + " people")
        return person_ids
    except psycopg2.DatabaseError as error:
        print(error)
    finally:
        if conn is not None:
            cur.close()
            conn.close()


def generate_passes(client_ids, passes_ids):
    conn = psycopg2.connect("dbname=postgres user=postgres password=postgres")
    cur = conn.cursor()
    try:
        sql = """INSERT INTO pass_client 
        (id_pass, id_client, date_from) VALUES ("""
        passes = 0
        for id_client in client_ids:
            passes += 1
            start_date = fake.date_between(start_date='-1y', end_date='+1y')
            id_pass = random.choice(passes_ids)
            cur.execute(sql + format(id_pass, id_client, start_date) + ");")
        conn.commit()
        print("inserted " + str(passes) + " passes")
    except psycopg2.DatabaseError as error:
        print(error)
    finally:
        if conn is not None:
            cur.close()
            conn.close()


def generate_simple(ids, tab_name, coll_name="id"):
    conn = psycopg2.connect("dbname=postgres user=postgres password=postgres")
    cur = conn.cursor()
    try:
        gen_ids = []
        for act_id in ids:
            cur.execute("insert into " + tab_name + " (" + coll_name + ") values (" + str(act_id) + ")")
            gen_ids.append(act_id)
        conn.commit()
        print("inserted " + str(len(gen_ids)) + " values into " + tab_name)
        return gen_ids
    except psycopg2.DatabaseError as error:
        print(error)
    finally:
        if conn is not None:
            cur.close()
            conn.close()


def get_ids(tab_name):
    conn = psycopg2.connect("dbname=postgres user=postgres password=postgres")
    cursor = conn.cursor()
    query = f"SELECT id FROM {tab_name}"
    cursor.execute(query)
    result = cursor.fetchall()
    occurring_ids = [row[0] for row in result]
    conn.close()
    return occurring_ids


def generate_relation(rel_name, col1_name, col2_name, tab1_name, tab2_name, des_count,
                      debug=False,
                      do_your_job=True):
    ids1 = get_ids(tab1_name)
    ids2 = get_ids(tab2_name)
    cnt = 0
    actual_cnt = 0
    conn = psycopg2.connect("dbname=postgres user=postgres password=postgres")
    cur = conn.cursor()
    while cnt < des_count:
        id1 = random.choice(ids1)
        id2 = random.choice(ids2)
        cnt += 1
        try:
            cur.execute(f"insert into {rel_name} ({col1_name}, {col2_name}) values ({str(id1)}, {str(id2)})")
            conn.commit()
            actual_cnt += 1
            if debug:
                print("success")
        except psycopg2.DatabaseError as error:
            conn.rollback()
            if do_your_job:
                cnt -= 1
            if debug:
                print(error)
            continue
    conn.close()
    print(f"inserted {str(actual_cnt)} simple relations {rel_name}({tab1_name}.{col1_name}, {tab2_name}.{col2_name})")


def fake_any(type):
    if type == "address":
        return fake.address()
    if type == "name":
        return fake.name()
    if type == "surname":
        return fake.surname()
    if type == "date":
        return fake.date_between(start_date='-1y', end_date='+1y').strftime('%Y-%m-%d')


def generate_stupid(tab_name, ref_names, ref_tables, field_names, field_types,
                    des_count,
                    debug=False,
                    do_your_job=False):
    ids = []
    for ref_table in ref_tables:
        print("getting ids for" + ref_table)
        ids.append(get_ids(ref_table))
    cnt = 0
    act_cnt = 0
    conn = psycopg2.connect("dbname=postgres user=postgres password=postgres")
    cur = conn.cursor()
    sql_insert = f"INSERT INTO {tab_name} ("
    for ref_name in ref_names:
        sql_insert += f"{ref_name}, "
    sql_insert += ", ".join(field_names)
    sql_insert += ")"

    if debug:
        print(f"sql: {sql_insert}")

    while cnt < des_count:
        cnt += 1
        try:
            sql2 = sql_insert + " VALUES("
            for act_ids in ids:
                sql2 += f"{random.choice(act_ids)}, "
            sql2 += ", ".join(fake_any(field_type) for field_type in field_types)
            sql2 += ");"
            print(sql2)

        except psycopg2.DatabaseError as error:
            conn.rollback()
            if do_your_job:
                cnt -= 1
            if debug:
                print(error)
            continue
    conn.close()


if __name__ == '__main__':
    # print("start")
    # person_ids = generate_person(30)
    # client_ids = generate_simple(random.sample(person_ids, 25), "client")
    # employee_ids = generate_simple(random.sample(person_ids, 5), "employee")
    # instructor_ids = generate_simple(random.sample(employee_ids, len(employee_ids) * 5 // 10), "instructor",
    #                                  "id_employee")
    # generate_passes(random.sample(client_ids, int(len(client_ids) * 0.9)), get_ids("pass"))
    #
    # generate_relation("class_client", "id_class", "id_client", "class", "client",
    #                   50, debug=False)
    #
    # generate_relation("class_entry", "id_client", "id_class_schedule", "client", "class_schedule",
    #                   100, debug=False, do_your_job=False)
    #
    # generate_relation("gym_employee", "id_gym", "id_employee", "gym", "employee",
    #                   30, debug=True)

    generate_stupid("tab",
                    ["id_1", "id_2"], ["employee", "client"],
                    ["imie1, address1"], ["name", str("date")],
                    5)

