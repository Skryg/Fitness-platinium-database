

-- Gym
INSERT INTO gym (city, address) VALUES ('Kraków', 'Bratyslawska 3');
INSERT INTO gym (city, address) VALUES ('Kraków', 'Aleja Pokoju 16');

-- Client
INSERT INTO client (name, address, phone, email) VALUES ('Dymeg Bonham', 'Powstancow Slomskich', '666666666', 'db@gmail.com');
INSERT INTO client (name, address, phone, email) VALUES ('Ozgar Skryg', 'Czemstochowska', '420420420', 'os@gmail.com');

-- Pass
INSERT INTO pass (name, price) VALUES ('Pompuj z pompą', 100);
INSERT INTO pass (name, price) VALUES ('Open Beer Carnet', 200);

-- Pass Gym
INSERT INTO pass_gym (id_pass, id_gym) VALUES (1, 2);
INSERT INTO pass_gym (id_pass, id_gym) VALUES (2, 1);
INSERT INTO pass_gym (id_pass, id_gym) VALUES (2, 2);


-- Pass Client
INSERT INTO pass_client (id_pass, id_client, date_from, date_to) 
VALUES (1, 1, '2023-05-22', '2023-06-22');
INSERT INTO pass_client (id_pass, id_client, date_from, date_to)
VALUES (2, 2, '2023-05-22', '2023-06-22');

-- Entry
INSERT INTO entry (enter_time, exit_time, id_gym, id_client) VALUES ('2019-01-01 10:00:00', '2019-01-01 11:00:00', 1, 1);
INSERT INTO entry (enter_time, exit_time, id_gym, id_client) VALUES ('2019-01-03 12:00:00', '2019-01-03 13:00:00', 1, 1);
INSERT INTO entry (enter_time, exit_time, id_gym, id_client) VALUES ('2019-01-04 11:00:00', '2019-01-04 12:00:00', 2, 2);
INSERT INTO entry (enter_time, exit_time, id_gym, id_client) VALUES ('2019-01-05 20:00:00', '2019-01-05 22:00:00', 2, 2);

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
INSERT INTO employee (name, surname, address, phone, email) VALUES ('Sara','Johnson', '100 Oak Street', '696969696', 'sara.johnson@example.com');
INSERT INTO employee (name, surname, address, phone, email) VALUES ('Mike','Brown', '200 Maple Avenue', '101101010', 'mike.brown@example.com');

-- Gym Employee
INSERT INTO gym_employee (id_gym, id_employee) VALUES (1, 1);
INSERT INTO gym_employee (id_gym, id_employee) VALUES (2, 2);

-- Employee User
INSERT INTO employee_user (id_employee, username, password, permission) VALUES (1, 'sara', 'zupa_koperkowa', 0);
INSERT INTO employee_user (id_employee, username, password, permission) VALUES (2, 'miki', 'fikumiku', 1);

-- Instructor
INSERT INTO instructor (id_employee, bio) VALUES (1, 'Certified Personal Trainer');
INSERT INTO instructor (id_employee, bio) VALUES (2, 'Certified Yoga Instructor');

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
INSERT INTO class_type (name) VALUES ('Yoga');
INSERT INTO class_type (name) VALUES ('Zumba');

-- Class
INSERT INTO class (gym, name, description, activity_type, instructor, capacity) VALUES (1, 'Yoga', 'Yoga for beginners', 1, 1, 10);
INSERT INTO class (gym, name, description, activity_type, instructor, capacity) VALUES (2, 'Zumba', 'Zumba for beginners', 2, 2, 10);

-- Class Client
INSERT INTO class_client (id_class, id_client) VALUES (1, 1);
INSERT INTO class_client (id_class, id_client) VALUES (2, 2);
INSERT INTO class_client (id_class, id_client) VALUES (2, 1);
INSERT INTO class_client (id_class, id_client) VALUES (1, 2);

-- Class Schedule
INSERT INTO class_schedule (id_class, start_time, end_time, start_date) VALUES (1, '10:00:00', '11:00:00', '2019-02-03');
INSERT INTO class_schedule (id_class, start_time, end_time, start_date) VALUES (2, '12:00:00', '13:00:00', '2019-01-03');
