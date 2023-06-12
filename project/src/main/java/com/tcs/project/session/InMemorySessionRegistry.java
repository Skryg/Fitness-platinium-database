package com.tcs.project.session;

import com.tcs.project.EmployeeUser.EmployeeUser;
import com.tcs.project.EmployeeUser.EmployeeUserService;
import com.tcs.project.User.CurrentUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.HashMap;
import java.util.UUID;

@Component
public class InMemorySessionRegistry {
    private static final HashMap<String, SessionData> SESSIONS = new HashMap<>();
    @Autowired
    private CurrentUserService currentUserService;
    public String registerSession(final String username){
        if(username  == null){
            throw new RuntimeException("Username needs to be specified");
        }
        final String sessionId = generateSessionId();
        SESSIONS.put(sessionId,
                new SessionData(sessionId,
                        username,
                        currentUserService.loadUserByUsername(username).getPermission()
                ));
        return sessionId;
    }

    public String getUsernameForSession(final String session){
        return SESSIONS.get(session).getUsername();
    }

    private String generateSessionId(){
        return new String(
                Base64.getEncoder().encode(
                        UUID.randomUUID().toString().getBytes(StandardCharsets.UTF_8)
                )
        );
    }
}

