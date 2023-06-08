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

