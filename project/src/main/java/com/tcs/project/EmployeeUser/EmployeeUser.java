package com.tcs.project.EmployeeUser;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "employee_user")
@NoArgsConstructor
public class EmployeeUser {
    @Id
    @Column(name = "id", length = 45)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Getter
    private int id;

    @Column(name = "id_employee", length = 45)
    @Getter @Setter
    private long idEmployee;

    @Column(name = "username", length = 128)
    @Getter @Setter
    private String username;

    @Column(name = "password", length = 256)
    @Getter @Setter
    private String password;

    @Column(name = "permission", length = 2)
    @Getter @Setter
    private int permission;

    public EmployeeUser(int idEmployee, String username, String password, int permission) {
        this.idEmployee = idEmployee;
        this.username = username;
        this.password = password;
        this.permission = permission;
    }
}
