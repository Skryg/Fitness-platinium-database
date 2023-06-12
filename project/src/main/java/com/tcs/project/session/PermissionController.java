package com.tcs.project.session;

import com.tcs.project.EmployeeUser.EmployeeUser;
import com.tcs.project.EmployeeUser.EmployeeUserService;
import com.tcs.project.User.CurrentUserService;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import org.apache.coyote.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.parameters.P;
import org.springframework.web.bind.annotation.*;

import java.net.http.HttpHeaders;
import java.security.Permission;
import java.util.Currency;

@RestController
@RequestMapping("/permission")
@CrossOrigin(origins = "http://localhost:4200")
public class PermissionController {
    CurrentUserService userService;
    InMemorySessionRegistry sessionRegistry;
    @Autowired
    PermissionController(CurrentUserService userService, InMemorySessionRegistry sessionRegistry){
        this.userService = userService;
        this.sessionRegistry = sessionRegistry;
    }
    @GetMapping
    public ResponseEntity<?> getPermission(@RequestHeader("Authorization") String token){
        System.out.println("GOT TOKEN: "+token);
        try {
            int permission = userService.loadUserByUsername(sessionRegistry.getUsernameForSession(token)).getPermission();
            System.out.println("RETURNING FOR: "+token);
            return ResponseEntity.ok(permission);
        }
        catch(Throwable e){
            return ResponseEntity.ok(-1);
        }
    }
}
