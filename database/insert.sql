
INSERT INTO city (name) VALUES ('Kraków');

-- Gym
INSERT INTO gym (id_city, address) VALUES (1, 'Bratyslawska 3');
INSERT INTO gym (id_city, address) VALUES (1, 'Aleja Pokoju 16');

INSERT INTO person (name, surname, address, phone, email) VALUES ('Dymeg', 'Bonham', 'Powstancow Slomskich', '666666666', 'db@gmail.com');
INSERT INTO person (name, surname, address, phone, email) VALUES ('Ozgar', 'Skryg', 'Czemstochowska', '420420420', 'os@gmail.com');
INSERT INTO person (name, surname, address, phone, email) VALUES ('Sara', 'Johnson', '100 Oak Street', '696969696', 'sara.johnson@example.com');
INSERT INTO person (name, surname, address, phone, email) VALUES ('Mike', 'Brown', '200 Maple Avenue', '101101010', 'mike.brown@example.com');


-- Client
INSERT INTO client (id) VALUES (1);
INSERT INTO client (id) VALUES (2);

-- Pass
INSERT INTO pass (name, price, duration)   VALUES ('Pompuj z pompą', 100, INTERVAL '30' DAY);
INSERT INTO pass (name, price, duration) VALUES ('Open Beer Carnet', 200, INTERVAL '30' DAY);

-- Pass Gym
INSERT INTO pass_gym (id_pass, id_gym) VALUES (1, 2);
INSERT INTO pass_gym (id_pass, id_gym) VALUES (2, 1);
INSERT INTO pass_gym (id_pass, id_gym) VALUES (2, 2);


-- Pass Client
INSERT INTO pass_client (id_pass, id_client, date_from)
VALUES (1, 1, '2023-05-22');
INSERT INTO pass_client (id_pass, id_client, date_from)
VALUES (2, 2, '2023-05-22');
INSERT INTO pass_client (id_pass, id_client, date_from)
VALUES (1, 1, '2019-01-01');
INSERT INTO pass_client (id_pass, id_client, date_from)
VALUES (2, 2, '2019-01-01');

-- Entry
INSERT INTO gym_entry (enter_time, exit_time, id_gym, id_client) VALUES ('2019-01-02 10:00:00', '2019-01-02 11:00:00', 1, 2);
INSERT INTO gym_entry (enter_time, exit_time, id_gym, id_client) VALUES ('2019-01-03 12:00:00', '2019-01-03 13:00:00', 1, 2);
INSERT INTO gym_entry (enter_time, exit_time, id_gym, id_client) VALUES ('2019-01-04 11:00:00', '2019-01-04 12:00:00', 2, 1);
INSERT INTO gym_entry (enter_time, exit_time, id_gym, id_client) VALUES ('2019-01-05 20:00:00', '2019-01-05 22:00:00', 2, 2);

-- Equipment Type
INSERT INTO equipment_type (name) VALUES ('Treadmill');
INSERT INTO equipment_type (name) VALUES ('Elliptical');
INSERT INTO equipment_type (name) VALUES ('Weight Machine');
INSERT INTO equipment_type (name) VALUES ('Zipline');

-- Gym Equipment
INSERT INTO gym_equipment (id_gym, id_equipment_type, service_date) VALUES (1, 1, '2022-01-01');
INSERT INTO gym_equipment (id_gym, id_equipment_type, service_date) VALUES (1, 3, '2022-01-01');
INSERT INTO gym_equipment (id_gym, id_equipment_type, service_date) VALUES (1, 2, '2022-01-01');
INSERT INTO gym_equipment (id_gym, id_equipment_type, service_date) VALUES (2, 3, '2022-01-01');
INSERT INTO gym_equipment (id_gym, id_equipment_type, service_date) VALUES (2, 1, '2022-01-01');
INSERT INTO gym_equipment (id_gym, id_equipment_type, service_date) VALUES (2, 4, '2022-01-01');

-- Employee
INSERT INTO employee (id) VALUES (3);
INSERT INTO employee (id) VALUES (4);

-- Gym Employee
INSERT INTO gym_employee (id_gym, id_employee) VALUES (1, 3);
INSERT INTO gym_employee (id_gym, id_employee) VALUES (2, 4);

-- Employee User
INSERT INTO employee_user (id_employee, username, password, permission) VALUES (3, 'sara', 'zupa_koperkowa', 0);
INSERT INTO employee_user (id_employee, username, password, permission) VALUES (4, 'miki', 'fikumiku', 1);

-- Instructor
INSERT INTO instructor (id_employee, bio) VALUES (3, 'Certified Personal Trainer');
INSERT INTO instructor (id_employee, bio) VALUES (4, 'Certified Yoga Instructor');

-- challenge
INSERT INTO challenge (date_from, date_to, min_entries) VALUES ('2019-01-01', '2019-01-31', 2);
INSERT INTO challenge (date_from, date_to, min_entries) VALUES ('2019-02-01', '2019-02-28', 4);

-- Award
INSERT INTO award (name, description) VALUES ('Bag', 'Best bag ever');
INSERT INTO award (name, description) VALUES ('T-shirt', 'Best t-shirt ever');

-- challenge Award
INSERT INTO challenge_award (id_challenge, id_award) VALUES (1, 1);
INSERT INTO challenge_award (id_challenge, id_award) VALUES (2, 2);

-- Class Type
INSERT INTO class_type (name) VALUES
('Yoga'),
('Zumba'),
('Pilates'),
('Kickboxing');

-- Class
INSERT INTO class (gym, name, description, activity_type, capacity) VALUES (1, 'Yoga', 'Yoga for beginners', 1, 10);
INSERT INTO class (gym, name, description, activity_type, capacity) VALUES (2, 'Zumba', 'Zumba for beginners', 2, 10);
INSERT INTO class (gym, name, description, activity_type, capacity)
VALUES
(1, 'Advanced Pilates', 'Core strengthening and flexibility', 3, 8),
(2, 'Kickboxing beginners', 'High-intensity martial arts workout for beginners', 4, 15),
(2, 'Kickboxing', 'High-intensity martial arts workout', 4, 12);


-- Class Client
INSERT INTO class_client (id_class, id_client) VALUES (1, 1);
INSERT INTO class_client (id_class, id_client) VALUES (2, 2);
INSERT INTO class_client (id_class, id_client) VALUES (2, 1);
INSERT INTO class_client (id_class, id_client) VALUES (1, 2);


INSERT INTO default_employee_schedule (id_employee, id_gym, day_of_week, start_time, end_time)
VALUES
(4, 1, 1, '09:00:00', '10:00:00'),
(3, 1, 2, '14:00:00', '15:30:00'),
(3, 2, 3, '18:00:00', '19:30:00'),
(4, 2, 4, '16:00:00', '17:30:00'),
(3, 1, 5, '10:00:00', '11:30:00');;


INSERT INTO default_class_schedule (id_class, instructor, day_of_week, start_time, end_time)
VALUES
(1, 3, 1, '09:00:00', '10:00:00'),
(2, 3, 2, '14:00:00', '15:30:00'),
(2, 4, 2, '18:00:00', '19:30:00'),
(3, 3, 3, '15:00:00', '16:30:00'),
(4, 3, 4, '11:00:00', '12:30:00');

select generate_employee_schedule_for_next_week();
select generate_class_schedule_for_next_week();

select generate_class_schedule(current_date, '2023-08-01');

select delete_classes_for_gym(2, current_timestamp::timestamp, '2023-07-01 15:00:00'::timestamp);
