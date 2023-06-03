package com.tcs.project.Equipment;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class EquipmentSrevice{
    private final EquipmentRepository equipmentRepository;

    @Autowired
    public EquipmentSrevice(EquipmentRepository equipmentRepository) {
        this.equipmentRepository = equipmentRepository;
    }

    public List<Object[]> getEquipmentByGym(Long id, Date date1, Date date2) {
        return equipmentRepository.getEquipmentByGym(id, date1, date2);
    }
}
