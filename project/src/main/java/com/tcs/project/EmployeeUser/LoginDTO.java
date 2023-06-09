package com.tcs.project.EmployeeUser;

import lombok.*;

@NoArgsConstructor
@AllArgsConstructor
@ToString
public class LoginDTO {
    @Getter @Setter
    public String username;
    @Getter @Setter
    public String password;
}
