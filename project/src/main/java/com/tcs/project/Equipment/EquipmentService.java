package com.tcs.project.Equipment;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public class EquipmentService {
    private final EquipmentRepository equipmentRepository;

    @Autowired
    public EquipmentService(EquipmentRepository equipmentRepository) {
        this.equipmentRepository = equipmentRepository;
    }

    public List<Object[]> getEquipmentByGym(Long id, LocalDate date1, LocalDate date2) {
        return equipmentRepository.getEquipmentByGym(id, date1, date2);
    }

}
