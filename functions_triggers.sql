
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

