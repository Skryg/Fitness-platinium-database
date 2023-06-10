package com.tcs.project.User;

import com.tcs.project.EmployeeUser.EmployeeUser;
import com.tcs.project.EmployeeUser.EmployeeUserDTO;
import com.tcs.project.EmployeeUser.EmployeeUserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class CurrentUserService {
    private EmployeeUserRepository repository;
    @Autowired
    CurrentUserService(EmployeeUserRepository repository){
        this.repository = repository;
    }

    public EmployeeUser loadUserByUsername(String username){
         return repository.findByUsername(username);
    }
}
