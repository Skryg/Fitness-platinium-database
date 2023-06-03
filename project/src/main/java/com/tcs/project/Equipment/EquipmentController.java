package com.tcs.project.Equipment;

import org.springframework.web.bind.annotation.*;

import java.util.Date;
import java.util.List;

@RestController
@RequestMapping("/equipment")
@CrossOrigin(origins = "http://localhost:4200")
public class EquipmentController {

    private final EquipmentSrevice equipmentSrevice;

    public EquipmentController(EquipmentSrevice equipmentSrevice) {
        this.equipmentSrevice = equipmentSrevice;
    }

    @GetMapping("/{id}/{date1}/{date2}")
    public List<Object[]> getEquipmentByGym(@PathVariable Long id, @PathVariable Date date1, @PathVariable Date date2) {
        return equipmentSrevice.getEquipmentByGym(id, date1, date2);
    }
}
