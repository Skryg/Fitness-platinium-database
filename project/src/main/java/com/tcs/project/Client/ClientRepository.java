package com.tcs.project.Client;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Objects;

@Repository
public interface ClientRepository extends JpaRepository<Client, Long> {
    @Query(value = "SELECT enter_time, exit_time, (SELECT address FROM gym WHERE entry.id_gym = gym.id) FROM entry WHERE id_client = :id", nativeQuery = true)
    List<Object[]> getEntriesByClient(@Param("id") Long id);

    @Query(value = "SELECT * FROM client JOIN pass_client ON" +
            " client.id = pass_client.id_client JOIN pass_gym ON pass_client.id_pass = pass_gym.id_pass" +
            " WHERE pass_gym.id_gym = :id", nativeQuery = true)
    List<Client> getClientsByGym(@Param("id") Long id);

}
