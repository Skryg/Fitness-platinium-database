DROP TABLE IF EXISTS gym_equipment, equipment, equipment_type, gym;

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