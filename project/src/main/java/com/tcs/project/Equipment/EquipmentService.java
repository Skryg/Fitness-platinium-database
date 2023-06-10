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

    public List<Object[]> getEquipmentByGym(LocalDate date1, LocalDate date2) {
        return equipmentRepository.getEquipmentByGym(date1, date2);
    }

    public void updateEquipmentByGym(LocalDate date1, LocalDate date2) {
        equipmentRepository.updateEquipmentByGym(date1, date2);
    }

}
