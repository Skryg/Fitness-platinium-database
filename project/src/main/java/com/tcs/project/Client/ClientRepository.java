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

}
