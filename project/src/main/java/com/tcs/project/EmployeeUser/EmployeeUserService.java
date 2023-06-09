package com.tcs.project.EmployeeUser;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class EmployeeUserService {

    private EmployeeUserRepository repository;
    private final PasswordEncoder passwordEncoder;
    @Autowired
    public EmployeeUserService(EmployeeUserRepository repository, PasswordEncoder passwordEncoder){
        this.repository = repository;
        this.passwordEncoder = passwordEncoder;
    }

    public String registerEmployee(EmployeeUserDTO employeeUserDTO){
        EmployeeUser employeeUser = new EmployeeUser(
                employeeUserDTO.getIdEmployee(),
                employeeUserDTO.getUsername(),
                this.passwordEncoder.encode(employeeUserDTO.getPassword()),
                employeeUserDTO.getPermission()
        );
        System.out.println(employeeUserDTO);
        repository.save(employeeUser);

        return employeeUser.getUsername();
    }

    public LoginResponse loginEmployee(LoginDTO loginDTO) {
        String msg = "";
        EmployeeUser employee1 = repository.findByUsername(loginDTO.getUsername());
        if (employee1 != null) {
            String password = loginDTO.getPassword();
            String encodedPassword = employee1.getPassword();
            Boolean isPwdRight = passwordEncoder.matches(password, encodedPassword);
            if (isPwdRight) {
                Optional<EmployeeUser> employee = repository.findOneByUsernameAndPassword(loginDTO.getUsername(), encodedPassword);
                if (employee.isPresent()) {
                    return new LoginResponse("Login Success", true);
                } else {
                    return new LoginResponse("Login Failed", false);
                }
            } else {

                return new LoginResponse("Password does not match", false);
            }
        }else {
            return new LoginResponse("Username does not exit", false);
        }


    }
}
