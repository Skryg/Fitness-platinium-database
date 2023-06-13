
CREATE OR REPLACE FUNCTION add_country_code()
RETURNS TRIGGER AS $$
BEGIN
    NEW.phone = '+48' || NEW.phone;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS add_country_code ON person;
CREATE TRIGGER add_country_code
BEFORE INSERT OR UPDATE ON person
    FOR EACH ROW
    WHEN (NEW.phone ~ '^[0-9]{9}$')
    EXECUTE FUNCTION add_country_code();


CREATE OR REPLACE FUNCTION check_default_working_hours_overlap()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM default_employee_schedule
        WHERE id_employee = NEW.id_employee
        AND (start_time, end_time) OVERLAPS (NEW.start_time, NEW.end_time)
        AND (NEW.id IS NULL OR id <> NEW.id)
    ) THEN
        RAISE EXCEPTION 'Godziny pracy nachodzą na siebie';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
DROP TRIGGER IF EXISTS check_default_working_hours_overlap on default_employee_schedule;
CREATE TRIGGER check_default_working_hours_overlap
BEFORE INSERT OR UPDATE ON default_employee_schedule
    FOR EACH ROW EXECUTE FUNCTION check_default_working_hours_overlap();


CREATE OR REPLACE FUNCTION check_working_hours_overlap()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM employee_schedule 
        WHERE id_employee = NEW.id_employee
        AND start_date = NEW.start_date
        AND (start_time, end_time) OVERLAPS (NEW.start_time, NEW.end_time)
    ) THEN
        RAISE EXCEPTION 'Godziny pracy nachodzą na siebie';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
DROP TRIGGER IF EXISTS check_working_hours_overlap on employee_schedule;
CREATE TRIGGER check_working_hours_overlap
BEFORE INSERT OR UPDATE ON employee_schedule
    FOR EACH ROW EXECUTE FUNCTION check_working_hours_overlap();


CREATE OR REPLACE FUNCTION check_class_default_hours_overlap()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM default_class_schedule
        WHERE instructor = NEW.instructor
        AND day_of_week = NEW.day_of_week
        AND (start_time, end_time) OVERLAPS (NEW.start_time, NEW.end_time)
    ) THEN
        RAISE EXCEPTION 'Godziny zajęć nachodzą na siebie';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER  IF EXISTS check_class_default_hours_overlap on default_class_schedule;
CREATE TRIGGER check_class_default_hours_overlap
BEFORE INSERT OR UPDATE ON default_class_schedule
    FOR EACH ROW EXECUTE FUNCTION check_class_default_hours_overlap();


CREATE OR REPLACE FUNCTION check_class_hours_overlap()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM class_schedule 
        WHERE instructor = NEW.instructor
        AND start_date = NEW.start_date
        AND (start_time, end_time) OVERLAPS (NEW.start_time, NEW.end_time)
    ) THEN
        RAISE EXCEPTION 'Zajęcia nachodzą na siebie godzinami';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
DROP TRIGGER IF EXISTS check_class_hours_overlap on class_schedule;
CREATE TRIGGER check_class_hours_overlap
BEFORE INSERT OR UPDATE ON class_schedule
    FOR EACH ROW EXECUTE FUNCTION check_class_hours_overlap();



-- get schedules for given date (week)
CREATE OR REPLACE FUNCTION get_class_schedule(des_gym int, "from" date, "to" date)
    RETURNS class_schedule AS $$
        SELECT cs.* FROM class_schedule cs JOIN class c ON cs.id_class = c.id 
        WHERE cs.start_date BETWEEN "from" AND "to"
        AND c.gym = des_gym;
$$ LANGUAGE SQL;

    
CREATE OR REPLACE FUNCTION get_class_week_schedule(gym int, "date" date) RETURNS class_schedule AS $$
    SELECT * from get_class_schedule(gym, date_trunc('week', "date")::date, (date_trunc('week', "date")+ interval '6 days')::date)
$$ LANGUAGE SQL;


CREATE OR REPLACE FUNCTION get_employee_schedule(gym int,"from" date, "to" date)
    RETURNS employee_schedule AS $$
        SELECT * FROM employee_schedule 
        WHERE start_date BETWEEN "from" AND "to"
        AND gym = id_gym;
$$ LANGUAGE SQL;


CREATE OR REPLACE FUNCTION get_employee_week_schedule(gym int, "date" date)
    RETURNS employee_schedule AS $$
    SELECT * from get_employee_schedule(gym, date_trunc('week', "date")::date, (date_trunc('week', "date")+interval '6 days')::date)
$$ LANGUAGE SQL;

-- get class schedules in given period for given instructor and gym
CREATE OR REPLACE FUNCTION get_class_instructor_schedule(des_gym int, des_instructor int, "from" date, "to" date)
    RETURNS class_schedule AS $$
    SELECT cs.* FROM class_schedule cs JOIN class c ON cs.id_class = c.id 
        WHERE cs.start_date BETWEEN "from" AND "to"
        AND c.gym = des_gym
        AND cs.instructor = des_instructor
$$ LANGUAGE SQL;

-- get class schedules on all gyms
CREATE OR REPLACE FUNCTION get_class_schedule_all("from" date, "to" date)
    RETURNS class_schedule AS
  $$
    SELECT * FROM class_schedule cs
        WHERE cs.start_date BETWEEN "from" AND "to"
$$ LANGUAGE SQL;

-- ENTRIES
CREATE OR REPLACE FUNCTION get_gym_entries(des_id int)
    RETURNS setof gym_entry AS
$$
    SELECT * FROM gym_entry
    WHERE gym_entry.id_gym=des_id;
$$ LANGUAGE SQL;

-- for specific class (for example pilates 06-09-2004 16:00)
CREATE OR REPLACE FUNCTION get_class_s_entries(des_id int)
    RETURNS setof class_entry AS
$$
    SELECT * FROM class_entry
    WHERE class_entry.id_class_schedule=des_id;
$$ LANGUAGE SQL;

-- for type of class (for example pilates)
CREATE OR REPLACE FUNCTION get_class_entries(des_id int)
    RETURNS setof class_entry AS
$$
    SELECT ce.* FROM class_entry ce
                JOIN class_schedule cs on ce.id_class_schedule = cs.id
                JOIN class c on c.id = cs.id_class
    WHERE c.id=des_id;
$$ LANGUAGE SQL;


CREATE OR REPLACE FUNCTION check_gym_entry_overlap()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM gym_entry
        WHERE id_client = NEW.id_client
          AND id_gym = NEW.id_gym
          AND enter_time < NEW.exit_time
          AND exit_time > NEW.enter_time
    ) THEN
        RAISE EXCEPTION 'Entry overlaps with an existing entry.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER gym_entry_overlap_trigger
BEFORE INSERT OR UPDATE ON gym_entry
FOR EACH ROW
EXECUTE FUNCTION check_gym_entry_overlap();

CREATE OR REPLACE FUNCTION get_gym_entries_d(gym int, "from" date, "to" date) RETURNS bigint AS $$
    SELECT count(*) FROM gym_entry WHERE gym = id_gym AND enter_time BETWEEN "from" AND "to";
$$ LANGUAGE SQL;


