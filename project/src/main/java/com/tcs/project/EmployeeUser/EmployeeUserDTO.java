package com.tcs.project.EmployeeUser;

import jakarta.persistence.Column;
import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@ToString
public class EmployeeUserDTO {
    @Getter @Setter
    public int idEmployee;
    @Getter @Setter
    public String username;
    @Getter @Setter
    public String password;
    @Getter @Setter
    public int permission;


}
