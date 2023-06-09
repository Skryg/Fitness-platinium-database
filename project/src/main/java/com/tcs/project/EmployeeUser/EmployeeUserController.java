package com.tcs.project.EmployeeUser;

import com.tcs.project.Equipment.EquipmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.AutoConfigureAfter;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@CrossOrigin(origins = "http://localhost:4200")
@RequestMapping("/user")
public class EmployeeUserController {
    private final EmployeeUserService employeeUserService;
    @Autowired
    public EmployeeUserController(EmployeeUserService employeeUserService) {
        this.employeeUserService = employeeUserService;
    }

    @PostMapping(path = "/register")
    public String registerEmployee(@RequestBody EmployeeUserDTO employeeDTO){
        return employeeUserService.registerEmployee(employeeDTO);
    }

    @PostMapping(path = "/login")
    public ResponseEntity<?> loginEmployee(@RequestBody LoginDTO loginDTO){
        LoginResponse response = employeeUserService.loginEmployee(loginDTO);
        return ResponseEntity.ok(response);
    }
}
