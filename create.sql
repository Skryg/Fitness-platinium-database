CREATE TABLE gym (
    id SERIAL,
    city varchar(64) NOT NULL,
    address varchar(128) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE equipment_type (
    id SERIAL,
    name varchar(64) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE gym_equipment(
    id_gym int NOT NULL,
    id_equipment_type int NOT NULL,
    service_date date NOT NULL,
    PRIMARY KEY (id_gym, id_equipment_type),
    FOREIGN KEY (id_gym) REFERENCES gym(id),
    FOREIGN KEY (id_equipment_type) REFERENCES equipment_type(id)
);

CREATE TABLE pass (
    id SERIAL,
    name varchar(64) NOT NULL,
    price numeric(6, 2) NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT price_check CHECK (price>=0)
);

CREATE TABLE pass_gym (
    id_pass int NOT NULL,
    id_gym int NOT NULL,
    FOREIGN KEY (id_pass) REFERENCES pass(id),
    FOREIGN KEY (id_gym) REFERENCES gym(id),
    UNIQUE (id_pass, id_gym)
);

CREATE TABLE client(
    id SERIAL,
    name varchar(32) NOT NULL,
    surname varchar(32) NOT NULL,
    address varchar(128) NOT NULL,
    phone text UNIQUE,
    email varchar(64) UNIQUE,
    PRIMARY KEY (id),
    CONSTRAINT valid_email CHECK (email ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    CONSTRAINT valid_phone_number CHECK (
        phone ~ '^\+?[0-9]{1,3}-?[0-9]{3}-?[0-9]{3}-?[0-9]{4}$' OR
        phone ~ '^[0-9]{9}$'
    )
);


CREATE TABLE pass_client(
    id_pass int NOT NULL,
    id_client int NOT NULL,
    date_from date NOT NULL,
    date_to date NOT NULL,
    PRIMARY KEY (id_pass, id_client),
    FOREIGN KEY (id_pass) REFERENCES pass(id),
    FOREIGN KEY (id_client) REFERENCES client(id)
);

CREATE TABLE employee(
    id SERIAL,
    name varchar(32) NOT NULL,
    surname  varchar(32) NOT NULL,
    address varchar(128) NOT NULL,
    phone text NOT NULL UNIQUE,
    email varchar(320) NOT NULL UNIQUE,
    PRIMARY KEY (id),
    CONSTRAINT valid_email CHECK (email ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    CONSTRAINT valid_phone_number CHECK (
        phone ~ '^\+?[0-9]{1,3}-?[0-9]{3}-?[0-9]{3}-?[0-9]{4}$' OR
        phone ~ '^[0-9]{9}$'
    )
);


CREATE TABLE gym_employee (
    id_gym int,
    id_employee int NOT NULL,
    PRIMARY KEY (id_gym, id_employee),
    UNIQUE(id_gym, id_employee),
    FOREIGN KEY (id_gym) REFERENCES gym(id),
    FOREIGN KEY (id_employee) REFERENCES employee(id)
);

CREATE TABLE employee_user (
    id SERIAL,
    id_employee int NOT NULL,
    username varchar(32) NOT NULL UNIQUE,
    password varchar(64) NOT NULL,
    permission int NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_employee) REFERENCES employee(id),
    CONSTRAINT check_password CHECK (length(password) >= 8),
    CONSTRAINT check_username CHECK (length(username) >= 4),
    CONSTRAINT check_permission CHECK (permission BETWEEN 0 AND 2)
);

CREATE TABLE instructor (
    id_employee int,
    bio text,
    PRIMARY KEY (id_employee),
    FOREIGN KEY (id_employee) REFERENCES employee(id)
);

CREATE TABLE default_employee_schedule (
    id_employee int NOT NULL,
    day_of_week int NOT NULL,
    start_time time NOT NULL,
    end_time time NOT NULL,
    FOREIGN KEY (id_employee) REFERENCES employee(id),
    CONSTRAINT day_check CHECK(day_of_week BETWEEN 1 AND 7),
    CONSTRAINT time_check CHECK(start_time < end_time)
);

CREATE TABLE employee_schedule (
    id SERIAL,
    id_employee int NOT NULL,
    start_time time NOT NULL,
    end_time time NOT NULL,
    start_date date NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_employee) REFERENCES employee(id),
    CONSTRAINT check_times CHECK (start_time <= end_time)
);


CREATE TABLE class_type (
    id SERIAL,
    name varchar(64) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE class (
    id SERIAL,
    gym int NOT NULL,
    name varchar(64) NOT NULL,
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
    id_class int NOT NULL,
    id_client int NOT NULL,
    PRIMARY KEY (id_class, id_client),
    FOREIGN KEY (id_class) REFERENCES class(id),
    FOREIGN KEY (id_client) REFERENCES client(id)
);

CREATE TABLE default_class_schedule (
    id SERIAL,
    id_class int NOT NULL,
    day_of_week int NOT NULL,
    start_time time NOT NULL,
    end_time time NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_class) REFERENCES class(id),
    CONSTRAINT day_check CHECK(day_of_week BETWEEN 1 AND 7),
    CONSTRAINT time_check CHECK(start_time < end_time)
);

CREATE TABLE class_schedule (
    id SERIAL,
    id_class int NOT NULL,
    start_time time NOT NULL,
    end_time time NOT NULL,
    start_date date NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_class) REFERENCES class(id),
    CONSTRAINT check_times CHECK (start_time <= end_time)
);


CREATE TABLE blacklist (
    id_client int UNIQUE NOT NULL,
    date_from date NOT NULL,
    date_to date NOT NULL,
    reason text NOT NULL,
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

CREATE TABLE challenge (
    id SERIAL,
    date_from date NOT NULL,
    date_to date NOT NULL,
    min_entries int NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT check_dates CHECK (date_from <= date_to)
);

CREATE TABLE gym_challenge (
    id_gym int NOT NULL,
    id_challenge int NOT NULL,
    FOREIGN KEY (id_gym) REFERENCES gym(id),
    FOREIGN KEY (id_challenge) REFERENCES challenge(id),
    UNIQUE (id_gym, id_challenge)
);

CREATE TABLE award (
    id SERIAL,
    name varchar(64) UNIQUE NOT NULL,
    description varchar(512),
    PRIMARY KEY (id)
);

CREATE TABLE challenge_award (
    id_challenge int,
    id_award int,
    quantity int NOT NULL DEFAULT 1,
    FOREIGN KEY (id_challenge) REFERENCES challenge(id),
    FOREIGN KEY (id_award) REFERENCES award(id),
    PRIMARY KEY (id_challenge, id_award)
);
