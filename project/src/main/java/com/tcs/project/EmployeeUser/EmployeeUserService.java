package com.tcs.project.EmployeeUser;

import com.tcs.project.session.InMemorySessionRegistry;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.handler.WebRequestHandlerInterceptorAdapter;

import java.util.Optional;

@Service
public class EmployeeUserService {

    private EmployeeUserRepository repository;
    private InMemorySessionRegistry sessionRegistry;
    private final PasswordEncoder passwordEncoder;
    @Autowired
    public EmployeeUserService(EmployeeUserRepository repository, PasswordEncoder passwordEncoder, InMemorySessionRegistry sessionRegistry){
        this.repository = repository;
        this.passwordEncoder = passwordEncoder;
        this.sessionRegistry = sessionRegistry;
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
                    return new LoginResponse(true, sessionRegistry.registerSession(loginDTO.getUsername()), employee.get().getPermission());
                } else {
                    return new LoginResponse(false, "Login Failed", 0);
                }
            } else {

                return new LoginResponse(false, "Password does not match", 0);
            }
        }else {
            return new LoginResponse(false, "Username does not exit", 0);
        }


    }
}
