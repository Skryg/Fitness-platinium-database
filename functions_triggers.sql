
CREATE OR REPLACE FUNCTION add_country_code()
RETURNS TRIGGER AS $$
BEGIN
    NEW.phone = '+48' || NEW.phone;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER add_country_code
BEFORE INSERT OR UPDATE ON client
    FOR EACH ROW
    WHEN (NEW.phone ~ '^[0-9]{9}$')
    EXECUTE FUNCTION add_country_code();

CREATE TRIGGER add_country_code
BEFORE INSERT OR UPDATE ON employee
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
CREATE TRIGGER check_working_hours_overlap
BEFORE INSERT OR UPDATE ON employee_schedule
    FOR EACH ROW EXECUTE FUNCTION check_working_hours_overlap();


CREATE OR REPLACE FUNCTION check_class_default_hours_overlap()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM default_class_schedule
        WHERE id_class = NEW.id_class
        AND day_of_week = NEW.day_of_week
        AND (start_time, end_time) OVERLAPS (NEW.start_time, NEW.end_time)
    ) THEN
        RAISE EXCEPTION 'Godziny zajęć nachodzą na siebie';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_class_default_hours_overlap
BEFORE INSERT OR UPDATE ON default_class_schedule
    FOR EACH ROW EXECUTE FUNCTION check_class_default_hours_overlap();


CREATE OR REPLACE FUNCTION check_class_hours_overlap()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM class_schedule 
        WHERE id_class = NEW.id_class
        AND start_date = NEW.start_date
        AND (start_time, end_time) OVERLAPS (NEW.start_time, NEW.end_time)
    ) THEN
        RAISE EXCEPTION 'Zajęcia nachodzą na siebie godzinami';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER check_class_hours_overlap
BEFORE INSERT OR UPDATE ON class_schedule
    FOR EACH ROW EXECUTE FUNCTION check_class_hours_overlap();



-- get schedules for given date (week)
CREATE OR REPLACE FUNCTION get_class_schedule(gym int, "from" date, "to" date)
    RETURNS class_schedule AS $$
        SELECT cs.* FROM class_schedule cs JOIN class c ON cs.id_class = c.id 
        WHERE cs.start_date BETWEEN "from" AND "to"
        AND c.gym = gym;
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

-- get class schedules in given period for given instructor
CREATE OR REPLACE FUNCTION get_class_instructor_schedule(gym int, instructor int, "from" date, "to" date)
    RETURNS class_schedule AS $$
    SELECT cs.* FROM class_schedule cs JOIN class c ON cs.id_class = c.id 
        WHERE cs.start_date BETWEEN "from" AND "to"
        AND c.gym = gym
        AND c.instructor = instructor
$$ LANGUAGE SQL;

-- get class schedules on all gyms
CREATE OR REPLACE FUNCTION get_class_schedule_all("from" date, "to" date)
    RETURNS class_schedule AS
    SELECT * FROM class_schedule 
        WHERE cs.start_date BETWEEN "from" AND "to"
$$ LANGUAGE SQL;

-- ENTRIES
CREATE OR REPLACE FUNCTION get_entries_num()
    RETURNS bigint AS
$$
    SELECT count(*) FROM entry;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION get_client_entries_d(client int, "from" date, "to" date) RETURNS bigint AS $$
    SELECT count(*) FROM entry WHERE id_client = client AND enter_time BETWEEN "from" AND "to";
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION get_gym_entries_d(gym int, "from" date, "to" date) RETUNRS bigint AS
    SELECT count(*) FROM entry WHERE gym = id_gym AND enter_time BETWEEN "from" AND "to";
$$ LANGUAGE SQL;
