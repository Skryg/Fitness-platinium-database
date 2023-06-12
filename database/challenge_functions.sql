
DROP FUNCTION IF EXISTS update_awards(des_client_id int);
CREATE FUNCTION update_awards(des_client_id int)
RETURNS void AS $$
BEGIN
    INSERT INTO challenge_client_completed (id_challenge, id_client, got_award)
    SELECT c.id, des_client_id, 0::bool
    FROM challenge c
    WHERE (
        SELECT COUNT(*)
        FROM gym_entry ge
        WHERE ge.id_client = des_client_id
          AND ge.enter_time BETWEEN c.date_from AND c.date_to
          AND (c.id, des_client_id) NOT IN (
            SELECT id_challenge, id_client
            FROM challenge_client_completed
          )
        ) >= c.min_entries;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS update_awards();
CREATE FUNCTION update_awards()
RETURNS void AS $$
DECLARE
    cl RECORD;
BEGIN
    FOR cl IN SELECT id FROM client
    LOOP
        PERFORM update_awards(cl.id);
    END LOOP;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION give_awards(des_id_client int)
RETURNS SETOF award AS $$
DECLARE
    temp_table_name text := 'temp_awards_' || des_id_client;
BEGIN
    EXECUTE 'CREATE TEMP TABLE ' || temp_table_name || ' (LIKE award INCLUDING CONSTRAINTS) ON COMMIT DROP';

    -- Insert the awards into the temporary table
    EXECUTE 'INSERT INTO ' || temp_table_name || ' ' ||
        'SELECT a.* ' ||
        'FROM challenge_client_completed ccc ' ||
        'JOIN challenge c ON c.id = ccc.id_challenge ' ||
        'JOIN challenge_award ca ON c.id = ca.id_challenge ' ||
        'JOIN award a ON ca.id_award = a.id ' ||
        'WHERE ccc.id_client = ' || des_id_client || ' ' ||
        'AND ccc.got_award = false';

    -- Update the got_award flag to true for the returned rows
    UPDATE challenge_client_completed
    SET got_award = true
    WHERE id_client = des_id_client
      AND id_challenge IN (
        SELECT c.id
        FROM challenge_client_completed ccc
        JOIN challenge c ON c.id = ccc.id_challenge
        JOIN challenge_award ca ON c.id = ca.id_challenge
        WHERE ccc.id_client = des_id_client
          AND ccc.got_award = false
      );
    RETURN QUERY EXECUTE 'SELECT * FROM ' || temp_table_name;

    RETURN;
END;
$$ LANGUAGE plpgsql;


