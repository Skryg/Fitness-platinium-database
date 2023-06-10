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
    @Query(value = "SELECT enter_time, exit_time, (SELECT address FROM gym WHERE entry.id_gym = gym.id) FROM entry WHERE id_client = :id", nativeQuery = true)
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
    @Modifying
    @Query(value = "DELETE FROM gym_entry WHERE id_client = :id", nativeQuery = true)
    void deleteGymEntryByClientId(@Param("id") Long id);

    @Modifying
    @Query(value = "DELETE FROM client WHERE id = :id", nativeQuery = true)
    void deleteClientById(@Param("id") Long id);

    @Modifying
    @Query(value = "DELETE FROM person WHERE id = :id", nativeQuery = true)
    void deletePersonById(@Param("id") Long id);
}
