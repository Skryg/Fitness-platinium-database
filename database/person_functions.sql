DROP FUNCTION IF EXISTS get_data(des_person_id int);
CREATE FUNCTION get_data(des_person_id int)
RETURNS setof person AS $$BEGIN
    return query select p.* from person p where p.id = des_person_id;
end;
$$ language plpgsql;

DROP FUNCTION IF EXISTS get_person_by_name(des_name varchar(64));
CREATE FUNCTION get_person_by_name(des_name varchar(64))
RETURNS SETOF person AS $$
DECLARE
    des_first_name varchar(32);
    des_last_name varchar(32);
BEGIN
    des_first_name := TRIM(SPLIT_PART(des_name, ' ', 1));
    des_last_name := TRIM(SPLIT_PART(des_name, ' ', 2));

    RETURN QUERY
    SELECT *
    FROM person
    WHERE (LOWER(name) LIKE LOWER(des_first_name || '%') AND LOWER(surname) LIKE LOWER(des_last_name || '%'))
        OR (LOWER(surname) LIKE LOWER(des_first_name || '%') AND LOWER(name) LIKE LOWER(des_last_name || '%'));
END;
$$ LANGUAGE plpgsql;


DROP FUNCTION IF EXISTS get_person_by_name_exact(des_name varchar(32), des_surname varchar(32));
CREATE FUNCTION get_person_by_name_exact(des_name varchar(32), des_surname varchar(32))
RETURNS SETOF person AS $$
BEGIN
    RETURN QUERY
    SELECT *
    FROM person
    WHERE LOWER(name) = LOWER(des_name) and LOWER(surname) = LOWER(des_surname);
END;
$$ LANGUAGE plpgsql;

