package com.tcs.project.session;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.AnyKeyJavaClass;

@AllArgsConstructor
public class SessionData {
    @Getter
    private String token;
    @Getter
    private String username;
    @Getter
    private int permission;

}
