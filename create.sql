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
    gym_id int NOT NULL,
    equipment_id int NOT NULL,
    service_date date NOT NULL,
    PRIMARY KEY (gym_id, equipment_id),
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
    address varchar(255) NOT NULL,
    phone varchar(255) UNIQUE,
    email varchar(255) UNIQUE,
    PRIMARY KEY (id)
);

CREATE TABLE pass_client(
    id_pass int NOT NULL,
    id_client int NOT NULL,
    PRIMARY KEY (id_pass, id_client),
    FOREIGN KEY (id_pass) REFERENCES pass(id),
    FOREIGN KEY (id_client) REFERENCES client(id)
);

CREATE TABLE employee(
    id SERIAL,
    name varchar(255) NOT NULL,
    address varchar(255) NOT NULL,
    phone varchar(255) NOT NULL UNIQUE,
    email varchar(255) NOT NULL UNIQUE,
    PRIMARY KEY (id)
);

CREATE TABLE gym_employee(
    id SERIAL,
    id_gym int,
    id_employee int NOT NULL,
    PRIMARY KEY (id),
    UNIQUE(id_gym, id_employee),
    FOREIGN KEY (id_gym) REFERENCES gym(id),
    FOREIGN KEY (id_employee) REFERENCES employee(id)
);

CREATE TABLE employee_user(
    id SERIAL,
    id_employee int NOT NULL,
    username varchar(128) NOT NULL UNIQUE,
    password varchar(256) NOT NULL,
    permission int NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_employee) REFERENCES gym_employee(id),
    CONSTRAINT check_password CHECK (length(password) >= 8),
    CONSTRAINT check_username CHECK (length(username) >= 4),
    CONSTRAINT check_permission CHECK (permission BETWEEN 0 AND 2)
);

CREATE TABLE instructor (
    id_employee int,
    bio text,
    photo varchar(255),
    PRIMARY KEY (id_employee),
    FOREIGN KEY (id_employee) REFERENCES employee(id)
);

CREATE TABLE schedule (
    id SERIAL,
    id_gym_employee int NOT NULL,
    start_time time NOT NULL,
    end_time time NOT NULL,
    work_date date NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_gym_employee) REFERENCES gym_employee(id),
    CONSTRAINT check_times CHECK (start_time <= end_time)
);


CREATE TABLE class_type (
    id SERIAL,
    name varchar(255) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE class (
    id SERIAL,
    gym int NOT NULL,
    name varchar(255) NOT NULL,
    description text,
    activity_type int NOT NULL,
    instructor int NOT NULL,
    capacity int,
    PRIMARY KEY (id),
    FOREIGN KEY (instructor) REFERENCES instructor(id_employee),
    FOREIGN KEY (gym) REFERENCES gym(id),
    FOREIGN KEY (activity_type) REFERENCES class_type(id),
    CONSTRAINT check_capacity CHECK (capacity > 0)
);


CREATE TABLE class_client (
    class_id int NOT NULL,
    client_id int NOT NULL,
    PRIMARY KEY (class_id, client_id),
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
    FOREIGN KEY (class_id) REFERENCES class(id),
    CONSTRAINT check_times CHECK (start_time <= end_time),
    CONSTRAINT check_day CHECK (day_of_week BETWEEN 0 AND 6)
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

CREATE TABLE gym_challange (
    id_gym int NOT NULL,
    id_challange int NOT NULL,
    FOREIGN KEY (id_gym) REFERENCES gym(id),
    FOREIGN KEY (id_challange) REFERENCES challange(id),
    UNIQUE (id_gym, id_challange)
);

CREATE TABLE award (
    id SERIAL,
    name varchar(100) UNIQUE NOT NULL,
    description varchar(500),
    PRIMARY KEY (id)
);

CREATE TABLE challange_award (
    id_challange int,
    id_award int,
    quantity int NOT NULL DEFAULT 1,
    FOREIGN KEY (id_challange) REFERENCES challange(id),
    FOREIGN KEY (id_award) REFERENCES award(id),
    PRIMARY KEY (id_challange, id_award)
);



-- Gym
INSERT INTO gym (address) VALUES ('Bratyslawska 3');
INSERT INTO gym (address) VALUES ('Aleja Pokoju 16');

-- Client
INSERT INTO client (id_pass, name, address, phone, email) VALUES (1, 'Dymeg Bonham', 'Powstancow Slomskich', '666666666', 'db@gmail.com');
INSERT INTO client (id_pass, name, address, phone, email) VALUES (2, 'Ozgar Skryg', 'Czemstochowska', '420420420', 'os@gmail.com');

-- Pass
INSERT INTO pass (id_gym) VALUES (1);
INSERT INTO pass (id_gym) VALUES (2);

-- Pass Client
INSERT INTO pass_client (id_pass, id_client) VALUES (1, 1);
INSERT INTO pass_client (id_pass, id_client) VALUES (2, 2);

-- Entry
INSERT INTO entry (enter_time, exit_time, id_gym, id_client) VALUES ('2019-01-01 10:00:00', '2019-01-01 11:00:00', 1, 1);
INSERT INTO entry (enter_time, exit_time, id_gym, id_client) VALUES ('2019-01-03 12:00:00', '2019-01-03 13:00:00', 1, 1);
INSERT INTO entry (enter_time, exit_time, id_gym, id_client) VALUES ('2019-01-04 11:00:00', '2019-01-04 12:00:00', 2, 2);
INSERT INTO entry (enter_time, exit_time, id_gym, id_client) VALUES ('2019-01-05 20:00:00', '2019-01-05 22:00:00', 2, 2);

-- Equipment Type
INSERT INTO equipment_type (name) VALUES ('Treadmill');
INSERT INTO equipment_type (name) VALUES ('Elliptical');
INSERT INTO equipment_type (name) VALUES ('Weight Machine');

-- Equipment
INSERT INTO equipment (id_type) VALUES (1);
INSERT INTO equipment (id_type) VALUES (1);
INSERT INTO equipment (id_type) VALUES (2);
INSERT INTO equipment (id_type) VALUES (2);
INSERT INTO equipment (id_type) VALUES (3);
INSERT INTO equipment (id_type) VALUES (3);

-- Gym Equipment
INSERT INTO gym_equipment (gym_id, equipment_id, service_date) VALUES (1, 1, '2022-01-01');
INSERT INTO gym_equipment (gym_id, equipment_id, service_date) VALUES (1, 3, '2022-01-01');
INSERT INTO gym_equipment (gym_id, equipment_id, service_date) VALUES (1, 5, '2022-01-01');
INSERT INTO gym_equipment (gym_id, equipment_id, service_date) VALUES (2, 2, '2022-01-01');
INSERT INTO gym_equipment (gym_id, equipment_id, service_date) VALUES (2, 4, '2022-01-01');
INSERT INTO gym_equipment (gym_id, equipment_id, service_date) VALUES (2, 6, '2022-01-01');

-- Employee
INSERT INTO employee (name, address, phone, email) VALUES ('Sara Johnson', '100 Oak Street', '555-1111', 'sara.johnson@example.com');
INSERT INTO employee (name, address, phone, email) VALUES ('Mike Brown', '200 Maple Avenue', '555-2222', 'mike.brown@example.com');

-- Gym Employee
INSERT INTO gym_employee (id_gym, id_employee) VALUES (1, 1);
INSERT INTO gym_employee (id_gym, id_employee) VALUES (2, 2);

-- Employee User
INSERT INTO employee_user (id_employee, username, password, permission) VALUES (1, 'sara', 'zupa_koperkowa', 0);
INSERT INTO employee_user (id_employee, username, password, permission) VALUES (2, 'miki', 'fikumiku', 1);

-- Instructor
INSERT INTO instructor (id_employee, bio, photo) VALUES (1, 'Certified Personal Trainer', 'sara.jpg');
INSERT INTO instructor (id_employee, bio, photo) VALUES (2, 'Certified Yoga Instructor', 'mike.jpg');

-- Challange
INSERT INTO challange (date_from, date_to, min_entries) VALUES ('2019-01-01', '2019-01-31', 2);
INSERT INTO challange (date_from, date_to, min_entries) VALUES ('2019-02-01', '2019-02-28', 4);

-- Award
INSERT INTO award (name, description) VALUES ('Bag', 'Best bag ever');
INSERT INTO award (name, description) VALUES ('T-shirt', 'Best t-shirt ever');

-- Challange Award
INSERT INTO challange_award (id_challange, id_award) VALUES (1, 1);
INSERT INTO challange_award (id_challange, id_award) VALUES (2, 2);

-- Gym Challange
INSERT INTO gym_challange (id_gym, id_challange) VALUES (1, 1);
INSERT INTO gym_challange (id_gym, id_challange) VALUES (2, 2);

-- Class Type
INSERT INTO class_type (name) VALUES ('Yoga');
INSERT INTO class_type (name) VALUES ('Zumba');

-- Class
INSERT INTO class (gym, name, description, activity_type, instructor, capacity) VALUES (1, 'Yoga', 'Yoga for beginners', 1, 1, 10);
INSERT INTO class (gym, name, description, activity_type, instructor, capacity) VALUES (2, 'Zumba', 'Zumba for beginners', 2, 2, 10);

-- Class Client
INSERT INTO class_client (class_id, client_id) VALUES (1, 1);
INSERT INTO class_client (class_id, client_id) VALUES (2, 2);
INSERT INTO class_client (class_id, client_id) VALUES (2, 1);
INSERT INTO class_client (class_id, client_id) VALUES (1, 2);

-- Class Schedule
INSERT INTO class_schedule (class_id, start_time, end_time, day_of_week) VALUES (1, '2019-01-01 10:00:00', '2019-01-01 11:00:00', 1);
INSERT INTO class_schedule (class_id, start_time, end_time, day_of_week) VALUES (2, '2019-01-03 12:00:00', '2019-01-03 13:00:00', 3);
