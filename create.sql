DROP TABLE IF EXISTS gym_equipment, equipment, equipment_type, gym, pass, client, pass_client, employee, gym_employee;
DROP TABLE IF EXISTS instructor, class, class_client, class_schedule;

CREATE TABLE gym (
    id SERIAL,
    address varchar(255) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE equipment_type(
    id SERIAL,
    name varchar(255) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE equipment (
    id SERIAL,
    id_type int NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_type) REFERENCES equipment_type(id)
);


CREATE TABLE gym_equipment(
    id SERIAL,
    gym_id int NOT NULL,
    equipment_id int NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (gym_id) REFERENCES gym(id),
    FOREIGN KEY (equipment_id) REFERENCES equipment(id)
);

CREATE TABLE pass (
    id SERIAL,
    id_gym int NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_gym) REFERENCES gym(id)
);

CREATE TABLE client(
    id SERIAL,
    id_pass int NOT NULL,
    name varchar(255) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE pass_client(
    id SERIAL,
    id_pass int NOT NULL,
    id_client int NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_pass) REFERENCES pass(id),
    FOREIGN KEY (id_client) REFERENCES client(id)
);

CREATE TABLE employee(
    id SERIAL,
    name varchar(255) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE gym_employee(
    id SERIAL,
    id_gym int NOT NULL,
    id_employee int NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_gym) REFERENCES gym(id),
    FOREIGN KEY (id_employee) REFERENCES employee(id)
);

CREATE TABLE instructor (
    id SERIAL,
    name varchar(255) NOT NULL,
    bio text,
    photo varchar(255),
    PRIMARY KEY (id)
);

CREATE TABLE class (
    id SERIAL,
    gym int NOT NULL,
    name varchar(255) NOT NULL,
    instructor int NOT NULL,
    description text,
    capacity int,
    PRIMARY KEY (id),
    FOREIGN KEY (instructor) REFERENCES instructor(id),
    FOREIGN KEY (gym) REFERENCES gym(id)
);

CREATE TABLE class_client (
    id SERIAL,
    class_id int NOT NULL,
    client_id int NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (class_id) REFERENCES class(id),
    FOREIGN KEY (client_id) REFERENCES client(id)
);

CREATE TABLE class_schedule (
    id SERIAL,
    class_id int NOT NULL,
    start_time time NOT NULL,
    end_time time NOT NULL,
    day_of_week int NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (class_id) REFERENCES class(id)
);

