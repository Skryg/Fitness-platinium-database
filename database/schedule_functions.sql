--per gym
DROP FUNCTION IF EXISTS get_class_schedule_for_this_week_gym(des_gym int);
CREATE OR REPLACE FUNCTION get_class_schedule_for_this_week_gym(des_gym int)
RETURNS SETOF class_schedule AS $$
BEGIN
    RETURN QUERY
    SELECT cs.*
    FROM class_schedule cs
    JOIN class c on c.id = cs.id_class
    WHERE start_date >= date_trunc('week', current_date)
        AND start_date < date_trunc('week', current_date) + INTERVAL '1 week'
        AND gym = des_gym;
END;
$$ LANGUAGE plpgsql;

--per instructor
DROP FUNCTION IF EXISTS get_class_schedule_for_this_week_instructor(des_instructor int);
CREATE OR REPLACE FUNCTION get_class_schedule_for_this_week_instructor(des_instructor int)
RETURNS SETOF class_schedule AS $$
BEGIN
    RETURN QUERY
    SELECT cs.*
    FROM class_schedule cs
    JOIN class c on c.id = cs.id_class
    WHERE start_date >= date_trunc('week', current_date)
        AND start_date < date_trunc('week', current_date) + INTERVAL '1 week'
        AND class_schedule.instructor = des_instructor;
END;
$$ LANGUAGE plpgsql;


DROP FUNCTION IF EXISTS get_employee_schedule_for_this_week(des_employee int);
CREATE OR REPLACE FUNCTION get_employee_schedule_for_this_week(des_employee int)
RETURNS SETOF employee_schedule AS $$
BEGIN
    RETURN QUERY
    SELECT es.*
    FROM employee_schedule es
    WHERE start_date >= date_trunc('week', current_date)
        AND start_date < date_trunc('week', current_date) + INTERVAL '1 week'
        AND es.id_employee = des_employee;
END;
$$ LANGUAGE plpgsql;

--generating:

DROP FUNCTION IF EXISTS generate_employee_schedule(des_start_date date, des_end_date date);
CREATE OR REPLACE FUNCTION generate_employee_schedule(des_start_date date, des_end_date date)
RETURNS void AS $$
BEGIN
    DELETE FROM employee_schedule
    WHERE start_date >= des_start_date
      AND start_date <= des_end_date;

    INSERT INTO employee_schedule (id_gym, id_employee, start_time, end_time, start_date)
        SELECT des.id_gym, des.id_employee, des.start_time, des.end_time, act_date
        FROM default_employee_schedule des
        CROSS JOIN generate_series(des_start_date, des_end_date, '1 day'::interval) act_date
        WHERE EXTRACT(ISODOW FROM act_date) = des.day_of_week;

END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS generate_employee_schedule(des_start_date date, des_end_date date);
CREATE OR REPLACE FUNCTION generate_employee_schedule(des_start_date date, des_end_date date)
RETURNS void AS $$
BEGIN
    DELETE FROM employee_schedule
    WHERE start_date >= des_start_date
      AND start_date <= des_end_date;

    INSERT INTO employee_schedule (id_gym, id_employee, start_time, end_time, start_date)
        SELECT des.id_gym, des.id_employee, des.start_time, des.end_time, act_date
        FROM default_employee_schedule des
        CROSS JOIN generate_series(des_start_date, des_end_date, '1 day'::interval) act_date
        WHERE EXTRACT(ISODOW FROM act_date) = des.day_of_week;

END;
$$ LANGUAGE plpgsql;


DROP FUNCTION IF EXISTS generate_class_schedule(des_start_date date, des_end_date date);
CREATE OR REPLACE FUNCTION generate_class_schedule(des_start_date date, des_end_date date)
RETURNS void AS $$
BEGIN
    DELETE FROM class_schedule
    WHERE start_date >= des_start_date
      AND start_date <= des_end_date;

    INSERT INTO class_schedule (id_class, instructor, start_time, end_time, start_date)
        SELECT des.id_class, des.instructor, des.start_time, des.end_time, act_date
        FROM default_class_schedule des
        CROSS JOIN generate_series(des_start_date, des_end_date, '1 day'::interval) act_date
        WHERE EXTRACT(ISODOW FROM act_date) = des.day_of_week;

END;
$$ LANGUAGE plpgsql;


DROP FUNCTION IF EXISTS generate_employee_schedule_for_next_week();
CREATE OR REPLACE FUNCTION generate_employee_schedule_for_next_week()
RETURNS void AS $$
DECLARE
    next_week_start_date date;
    next_week_end_date date;
BEGIN
    next_week_start_date := date_trunc('week', current_date) + INTERVAL '1 week';
    next_week_end_date := next_week_start_date + INTERVAL '6 days';
    execute generate_employee_schedule(next_week_start_date, next_week_end_date);
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS generate_class_schedule_for_next_week();
CREATE OR REPLACE FUNCTION generate_class_schedule_for_next_week()
RETURNS void AS $$
DECLARE
    next_week_start_date date;
    next_week_end_date date;
BEGIN
    next_week_start_date := date_trunc('week', current_date) + INTERVAL '1 week';
    next_week_end_date := next_week_start_date + INTERVAL '6 days';
    execute generate_class_schedule(next_week_start_date, next_week_end_date);
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS delete_classes_for_instructor(des_instructor int, des_start_time timestamp, des_end_time timestamp);
CREATE OR REPLACE FUNCTION delete_classes_for_instructor(
    des_instructor int,
    des_start_time timestamp,
    des_end_time timestamp
)
RETURNS void AS $$
BEGIN
    DELETE FROM class_schedule
    WHERE instructor = des_instructor
        AND (start_date || ' ' || start_time)::timestamp >= des_start_time
        AND (start_date || ' ' || end_time)::timestamp <= des_end_time;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS delete_classes_for_gym(des_gym int, des_start_time timestamp, des_end_time timestamp);
CREATE OR REPLACE FUNCTION delete_classes_for_gym(
    des_gym int,
    des_start_time timestamp,
    des_end_time timestamp
)
RETURNS void AS $$
BEGIN
    DELETE FROM class_schedule
    WHERE id_class IN (
        SELECT id
        FROM class
        WHERE gym = des_gym
    )
    AND (start_date || ' ' || start_time)::timestamp >= des_start_time
    AND (start_date || ' ' || end_time)::timestamp <= des_end_time;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS delete_employee_sch_for_gym(des_gym int, des_start_time timestamp, des_end_time timestamp);
CREATE OR REPLACE FUNCTION delete_employee_sch_for_gym(
    des_gym int,
    des_start_time timestamp,
    des_end_time timestamp
)
RETURNS void AS $$
BEGIN
    DELETE FROM employee_schedule
    WHERE id_gym = des_gym
    AND (start_date || ' ' || start_time)::timestamp >= des_start_time
    AND (start_date || ' ' || end_time)::timestamp <= des_end_time;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS delete_employee_sch_for_emp(des_emp int, des_start_time timestamp, des_end_time timestamp);
CREATE OR REPLACE FUNCTION delete_employee_sch_for_emp(
    des_emp int,
    des_start_time timestamp,
    des_end_time timestamp
)
RETURNS void AS $$
BEGIN
    DELETE FROM employee_schedule
    WHERE id_employee = des_emp
    AND (start_date || ' ' || start_time)::timestamp >= des_start_time
    AND (start_date || ' ' || end_time)::timestamp <= des_end_time;
END;
$$ LANGUAGE plpgsql;





