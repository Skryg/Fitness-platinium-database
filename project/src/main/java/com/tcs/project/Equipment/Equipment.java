package com.tcs.project.Equipment;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "client")
public class Equipment {

        @Id
        private Long id;

}
