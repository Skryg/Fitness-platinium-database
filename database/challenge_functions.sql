
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

