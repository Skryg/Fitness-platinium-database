package com.tcs.project.EmployeeUser;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@EnableJpaRepositories
@Repository
public interface EmployeeUserRepository extends JpaRepository<EmployeeUser, Long> {
    Optional<EmployeeUser> findOneByUsernameAndPassword(String username, String password);
    EmployeeUser findByUsername(String username);
}
