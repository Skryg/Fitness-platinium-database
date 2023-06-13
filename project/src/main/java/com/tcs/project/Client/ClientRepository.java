package com.tcs.project.Client;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Objects;

@Repository
public interface ClientRepository extends JpaRepository<Client, Long> {
    @Query(value = "SELECT enter_time, exit_time, address FROM gym_entry JOIN gym ON gym.id = gym_entry.id_gym WHERE id_client = :id", nativeQuery = true)
    List<Object[]> getEntriesByClient(@Param("id") Long id);

    @Query(value = "SELECT * FROM person JOIN" +
            " client ON client.id = person.id JOIN" +
            " pass_client ON" +
            " client.id = pass_client.id_client JOIN pass_gym ON pass_client.id_pass = pass_gym.id_pass" +
            " WHERE pass_gym.id_gym = :idd", nativeQuery = true)
    List<Client> getClientsByGym(@Param("idd") Long id);

    @Query(value = "SELECT * FROM person WHERE id IN (SELECT * FROM client)", nativeQuery = true)
    List<Client> getClients();

    @Query(value = "SELECT * FROM person WHERE id IN (SELECT * FROM client) AND id = :id", nativeQuery = true)
    Client getClient(@Param("id") Long id);

    @Query(value = "SELECT enter_time, exit_time, id_client FROM gym_entry WHERE id_gym = :id", nativeQuery = true)
    List<Object[]> getEntriesByGym(@Param("id") Long id);

    @Query(value = "INSERT INTO person (name, surname, address, phone, email) VALUES (:name, :surname, :address, :phone, :email);" +
            " INSERT INTO client (id) VALUES ((SELECT id FROM person WHERE name = :name AND surname = :surname));", nativeQuery = true)
    void addNewClient(@Param("name") String name, @Param("surname") String surname, @Param("address") String address, @Param("phone") String phone, @Param("email") String email);

    // delete client
    @Query(value = "DELETE FROM client WHERE id = :id", nativeQuery = true)
    void deleteClientById(@Param("id") Long id);

    @Query(value = "SELECT date_from, date_to, min_entries, a.name FROM challenge " +
            " JOIN challenge_award ON challenge.id = challenge_award.id_challenge" +
            " JOIN award a on challenge_award.id_award = a.id", nativeQuery = true)
    List<Object[]> getChallenges();

    @Query(value = "SELECT get_person_by_name(cast(:name as varchar(64)))", nativeQuery = true)
    List<Object[]> getPersonByName(@Param("name") String name);

    @Query(value = "SELECT give_awards(:id)", nativeQuery = true)
    List<Object[]> giveAwards(@Param("id") int id);

    @Query(value = "SELECT can_enter_gym(:id_client, :id_gym, current_timestamp)", nativeQuery = true)
    List<Object[]> canEnterGym(@Param("id_client") int id_client, @Param("id_gym") int id_gym);

    @Query(value = "INSERT into gym_entry (enter_time, exit_time, id_client, id_gym) " +
            "VALUES (current_timestamp, null, :id_client, :id_gym)", nativeQuery = true)
    void enterGym(@Param("id_client") int id_client, @Param("id_gym") int id_gym);

    @Query(value = "UPDATE gym_entry" +
            " SET exit_time = current_timestamp" +
            " WHERE id_client = :id_client" +
            " AND exit_time IS NULL", nativeQuery = true)
    void exitGym(@Param("id_client") int id_client);


}
