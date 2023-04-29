DROP TABLE IF EXISTS gym_equipment, equipment, 
equipment_type, gym, pass, client, pass_client, 
employee, gym_employee, blacklist, entry, challange, award,
challange_award;

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

CREATE TABLE blacklist (
    id_client int UNIQUE NOT NULL,
    date_from date NOT NULL,
    date_to date NOT NULL,
    FOREIGN KEY (id_client) REFERENCES client(id),
    CONSTRAINT check_dates CHECK (date_from < date_to)
);

CREATE TABLE entry (
    id SERIAL,
    enter_time timestamp NOT NULL,
    exit_time timestamp NOT NULL, 
    id_client int NOT NULL,
    id_gym int NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_client) REFERENCES client(id),
    FOREIGN KEY (id_gym) REFERENCES gym(id),
    CONSTRAINT check_times CHECK (enter_time <= exit_time)
);

CREATE TABLE challange (
    id SERIAL,
    date_from date NOT NULL,
    date_to date NOT NULL,
    min_entries int NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT check_dates CHECK (date_from <= date_to)
);

CREATE TABLE award (
    id SERIAL,
    name varchar(100) UNIQUE NOT NULL,
    description varchar(500),
    PRIMARY KEY (id)
);

CREATE TABLE challange_award (
    id_challange int NOT NULL,
    id_award int NOT NULL,
    quantity int NOT NULL DEFAULT 1,
    FOREIGN KEY (id_challange) REFERENCES challange(id),
    FOREIGN kEY (id_award) REFERENCES award(id),
    UNIQUE (id_challange, id_award)
);

