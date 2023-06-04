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
    @Query(value = "SELECT e.id, et.name, ge.service_date FROM equipment e" +
            " JOIN equipment_type et ON e.id_type = et.id" +
            " JOIN gym_equipment ge ON e.id = ge.equipment_id" +
            " WHERE ge.gym_id = :id AND ge.service_date >= :date1 AND ge.service_date <= :date2", nativeQuery = true)
    List<Object[]> getEquipmentByGym(@Param("id") Long id, @Param("date1") LocalDate date1, @Param("date2") LocalDate date2);

}
