DROP TABLE IF EXISTS instructor, class, class_client, class_schedule;

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

