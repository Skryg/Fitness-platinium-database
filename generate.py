import random
from datetime import datetime, timedelta
import psycopg2
from faker import Faker

fake = Faker('pl_PL')


def get_name():
    return fake.first_name() + " " + fake.last_name()


def get_address():
    return fake.address()


def get_address_in_krakow():
    address = fake.address().replace('\n', ', ')
    while 'Kraków' not in address:
        address = fake.address().replace('\n', ', ')
    return address


def get_phone_number():
    return str(random.randint(100000000, 999999999))


def get_email():
    return fake.email()


def format(*args):
    formatted_args = [f"'{arg}'" for arg in args]
    formatted_string = ", ".join(formatted_args)
    return formatted_string


def generate(num_clients):
    conn = psycopg2.connect("dbname=postgres user=postgres password=p")
    cur = conn.cursor()
    print('generating:')
    client_ids = []
    try:
        sql = """INSERT INTO client (name, address, phone, email) VALUES ("""
        for i in range(num_clients):
            act = format(get_name(), get_address(), get_phone_number(), get_email())
            cur.execute(sql + act + ") RETURNING id;")
            client_ids.append(cur.fetchone()[0])
        conn.commit()
        print("inserted " + str(num_clients) + " clients")

        sql = """INSERT INTO pass_client 
        (id_pass, id_client, date_from, date_to) VALUES ("""
        passes = 0
        for id_client in client_ids:
            if random.uniform(0, 1) < 0.9:
                passes += 1
                start_date = fake.date_between(start_date='-1y', end_date='+1y')
                end_date = start_date + timedelta(days=30)
                id_pass = random.randint(1, 2)
                cur.execute(sql + format(id_pass, id_client, start_date, end_date) + ");")
        conn.commit()
        print("inserted " + str(passes) + " passes")

        
    except psycopg2.DatabaseError as error:
        print(error)
    finally:
        if conn is not None:
            cur.close()
            conn.close()


if __name__ == '__main__':
    print("start")
    generate(10)
