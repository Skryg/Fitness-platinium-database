package com.tcs.project.Equipment;

import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.List;
import java.util.Locale;

@RestController
@RequestMapping("/equipment")
@CrossOrigin(origins = "http://localhost:4200")
public class EquipmentController {
    private final EquipmentSrevice equipmentSrevice;

    public EquipmentController(EquipmentSrevice equipmentSrevice) {
        this.equipmentSrevice = equipmentSrevice;
    }

    @GetMapping("/{id}/{date1}/{date2}")
    public List<Object[]> getEquipmentByGym(@PathVariable Long id, @PathVariable String date1, @PathVariable String date2) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd", Locale.ENGLISH);
        return equipmentSrevice.getEquipmentByGym(id, LocalDate.parse(date1, formatter), LocalDate.parse(date2, formatter));
    }
}
