package com.tcs.project.Equipment;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

@Repository
public interface EquipmentRepository extends JpaRepository<Equipment, Long>{
    @Query(value = "SELECT e.service_date, et.name FROM gym_equipment e" +
            " JOIN equipment_type et ON id = id_equipment_type WHERE" +
            " e.service_date BETWEEN :date1 AND :date2", nativeQuery = true)
    List<Object[]> getEquipmentByGym(@Param("date1") LocalDate date1, @Param("date2") LocalDate date2);

    // update service to current date
    @Query(value = "UPDATE gym_equipment SET service_date = current_date + INTERVAL '6 months' WHERE" +
            " gym_equipment.service_date BETWEEN :date1 AND :date2", nativeQuery = true)
    void updateEquipmentByGym(@Param("date1") LocalDate date1, @Param("date2") LocalDate date2);
}
