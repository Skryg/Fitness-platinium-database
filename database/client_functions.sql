DROP FUNCTION IF EXISTS get_client_gym_entries(client int);
CREATE OR REPLACE FUNCTION get_client_gym_entries(client int)
RETURNS setof gym_entry AS $$
    SELECT * FROM gym_entry WHERE id_client = client;
$$ LANGUAGE SQL;

DROP FUNCTION IF EXISTS get_client_gym_entries_d(client int, "from" date, "to" date);
CREATE OR REPLACE FUNCTION get_client_gym_entries_d(client int, "from" date, "to" date)
RETURNS setof gym_entry AS $$
    SELECT * FROM gym_entry WHERE id_client = client AND enter_time BETWEEN "from" AND "to";
$$ LANGUAGE SQL;

DROP FUNCTION IF EXISTS get_client_class_entries(client int);
CREATE OR REPLACE FUNCTION get_client_class_entries(client int)
RETURNS setof class_entry AS $$
    SELECT * FROM class_entry WHERE id_client = client;
$$ LANGUAGE SQL;


DROP FUNCTION IF EXISTS allowed_gyms(des_client_id INT);
CREATE FUNCTION allowed_gyms(des_client_id INT)
RETURNS SETOF gym AS $$
BEGIN
    RETURN QUERY
    SELECT g.*
    FROM pass_client pc
    JOIN client c ON c.id = pc.id_client
    JOIN pass p ON pc.id_pass = p.id
    JOIN pass_gym pg ON p.id = pg.id_pass
    JOIN gym g on pg.id_gym = g.id
    WHERE pc.id_client = des_client_id
      AND current_date BETWEEN pc.date_from AND (pc.date_from + p.duration);
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS allowed_classes(des_client_id INT);
CREATE FUNCTION allowed_classes(des_client_id INT)
RETURNS SETOF class AS $$BEGIN
    RETURN QUERY
    SELECT c.*
    FROM class_client cc
    JOIN class c on cc.id_class = c.id
    WHERE cc.id_client = des_client_id;
end;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS get_passes(des_client_id int);
CREATE FUNCTION get_passes(des_client_id int)
RETURNS SETOF pass AS $$BEGIN
    return query
    select p.*
    from pass_client pc
    join pass p on pc.id_pass = p.id
    where pc.id_client = des_client_id;
    end;
$$ language plpgsql;

DROP FUNCTION IF EXISTS get_active_passes(des_client_id int);
CREATE FUNCTION get_active_passes(des_client_id int)
RETURNS SETOF pass AS $$BEGIN
    return query
    select p.*
    from pass_client pc
    join pass p on pc.id_pass = p.id
    where pc.id_client = des_client_id
    and current_date between pc.date_from and pc.date_from+p.duration;
    end;
$$ language plpgsql;



