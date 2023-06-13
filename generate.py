import random
from datetime import datetime, timedelta
import sys
sys.path.append('/path/to/psycopg2')
import psycopg2
from faker import Faker

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
    conn = psycopg2.connect("dbname=piotrulo user=piotrulo password=piotrulo")
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
    conn = psycopg2.connect("dbname=piotrulo user=piotrulo password=piotrulo")
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
    conn = psycopg2.connect("dbname=piotrulo user=piotrulo password=piotrulo")
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
    conn = psycopg2.connect("dbname=piotrulo user=piotrulo password=piotrulo")
    cursor = conn.cursor()
    query = f"SELECT id FROM {tab_name}"
    cursor.execute(query)
    result = cursor.fetchall()
    occurring_ids = [row[0] for row in result]
    conn.close()
    return occurring_ids


def generate_relation(rel_name, col1_name, col2_name, tab1_name, tab2_name, des_count):
    ids1 = get_ids(tab1_name)
    ids2 = get_ids(tab2_name)
    cnt = 0
    while cnt < des_count:
        id1 = random.choice(ids1)
        id2 = random.choice(ids2)
        try:
            conn = psycopg2.connect("dbname=piotrulo user=piotrulo password=piotrulo")
            cur = conn.cursor()
            #print(f"trying: {str(id1)}, {str(id2)}")
            cur.execute(f"insert into {rel_name} ({col1_name}, {col2_name}) values ({str(id1)}, {str(id2)})")
            conn.commit()
            cnt+=1
            #print("success")
        except psycopg2.DatabaseError as error:
            continue

    print("inserted " + str(cnt) + " passes")


def get_ids2(tab_name):
    conn = psycopg2.connect("dbname=piotrulo user=piotrulo password=piotrulo")
    cursor = conn.cursor()
    query = f"SELECT id FROM {tab_name}"
    cursor.execute(query)
    result = cursor.fetchall()
    occurring_ids = [row[0] for row in result]
    conn.close()
    return occurring_ids


def generate_gym_entries(des_count):
    client_ids = get_ids2('client')
    gym_ids = get_ids2('gym')
    cnt = 0

    while cnt < des_count:
        id_client = random.choice(client_ids)
        id_gym = random.choice(gym_ids)
        enter_time = fake.date_time_between(start_date='-1y', end_date='+1y')
        exit_time = enter_time + timedelta(hours=random.randint(1, 3))

        try:
            conn = psycopg2.connect("dbname=piotrulo user=piotrulo password=piotrulo")
            cur = conn.cursor()
            cur.execute("INSERT INTO gym_entry (enter_time, exit_time, id_client, id_gym) VALUES (%s, %s, %s, %s)", (enter_time, exit_time, id_client, id_gym))
            conn.commit()
            cnt += 1
            print("Success")
        except psycopg2.DatabaseError as error:
            continue

    print("Inserted " + str(cnt) + " records")

if __name__ == '__main__':
    generate_gym_entries(20)
    print("start")
    person_ids = generate_person(30)
    client_ids = generate_simple(random.sample(person_ids, 25), "client")
    employee_ids = generate_simple(random.sample(person_ids, 5), "employee")
    instructor_ids = generate_simple(random.sample(employee_ids, len(employee_ids) * 5 // 10), "instructor",
                                     "id_employee")
    generate_passes(random.sample(client_ids, int(len(client_ids) * 0.9)), get_ids("pass"))

    generate_relation("class_entry", "id_client", "id_class_schedule", "client", "class_schedule", 10)

