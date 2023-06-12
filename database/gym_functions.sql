CREATE OR REPLACE FUNCTION get_gyms_by_address(des_address varchar)
RETURNS SETOF gym AS $$
BEGIN
    RETURN QUERY
    SELECT g.*
    FROM gym g
    JOIN city c ON g.id_city = c.id
    WHERE LOWER(g.address) LIKE '%' || LOWER(des_address) || '%'
        OR LOWER(c.name) LIKE '%' || LOWER(des_address) || '%';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_gym_id(des_address varchar(64))
RETURNS int AS $$
DECLARE
    gym_count int;
    gym_id int;
BEGIN
    SELECT COUNT(*) INTO gym_count
    FROM get_gyms_by_address(des_address);

    IF gym_count = 0 THEN
        RAISE EXCEPTION 'No matches.';
    ELSIF gym_count > 1 THEN
        RAISE EXCEPTION 'More than one match.';
    END IF;

    SELECT id INTO gym_id
    FROM get_gyms_by_address(des_address);

    RETURN gym_id;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION get_required_equipment_service(des_gym_id int, date_start date, date_end date);
CREATE OR REPLACE FUNCTION get_required_equipment_service(des_gym_id int, date_start date, date_end date)
RETURNS TABLE (service_date date, name varchar) AS $$
BEGIN
    RETURN QUERY
    SELECT ge.service_date, et.name
    FROM gym_equipment ge
    JOIN equipment_type et ON et.id = ge.id_equipment_type
    WHERE ge.id_gym = des_gym_id
        AND ge.service_date BETWEEN date_start AND date_end;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION can_enter_gym(des_id_client int, des_id_gym int, entry_time timestamp with time zone)
RETURNS boolean AS $$
DECLARE
    valid_entry boolean;
BEGIN
    -- Check if the client has an active pass for the gym at the given entry_time
    SELECT EXISTS (
        SELECT 1
        FROM pass_client pc
        JOIN pass_gym pg ON pc.id_pass = pg.id_pass
        JOIN pass ON pc.id_pass = pass.id
        WHERE pc.id_client = des_id_client
          AND pg.id_gym = des_id_gym
          AND pc.date_from <= entry_time
          AND (pc.date_from + pass.duration) >= entry_time
    ) INTO valid_entry;

    RETURN valid_entry;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION validate_entry_function() RETURNS TRIGGER AS $$
BEGIN
    IF NOT can_enter_gym(NEW.id_client, NEW.id_gym, NEW.enter_time) THEN
        RAISE EXCEPTION
            'Invalid entry: Client does not have an active pass for the gym at the specified entry time.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS validate_entry on gym_entry;
CREATE TRIGGER validate_entry
BEFORE INSERT ON gym_entry
FOR EACH ROW
EXECUTE FUNCTION validate_entry_function();

CREATE OR REPLACE FUNCTION check_null_exit_time()
RETURNS TRIGGER AS $$
DECLARE
    null_exit_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO null_exit_count
    FROM gym_entry
    WHERE id_client = NEW.id_client
        AND exit_time IS NULL;

    IF NEW.exit_time is null then null_exit_count := null_exit_count + 1;
    end if;

    IF null_exit_count > 1 THEN
        RAISE EXCEPTION 'Maximum one NULL exit_time allowed per client. Finish the started entry first.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS check_null_exit_time_trigger ON gym_entry;
CREATE TRIGGER check_null_exit_time_trigger
BEFORE INSERT OR UPDATE OF exit_time ON gym_entry
FOR EACH ROW
EXECUTE FUNCTION check_null_exit_time();



--
-- --TODO:
-- CREATE OR REPLACE FUNCTION can_enter_class(des_id_client int, des_id_class_schedule int)
-- RETURNS boolean AS $$
-- DECLARE
--     valid_entry boolean;
-- BEGIN
--     -- Check if the client has an active pass for the gym at the given entry_time
--     SELECT EXISTS (
--         SELECT 1
--         FROM pass_client pc
--         JOIN pass_gym pg ON pc.id_pass = pg.id_pass
--         JOIN pass ON pc.id_pass = pass.id
--         WHERE pc.id_client = des_id_client
--           AND pg.id_gym = des_id_gym
--           AND pc.date_from <= entry_time
--           AND (pc.date_from + pass.duration) >= entry_time
--     ) INTO valid_entry;
--
--     RETURN valid_entry;
-- END;
-- $$ LANGUAGE plpgsql;
--
-- --TODO:
-- --wywalanie ludzi nieaktywnych z klas
