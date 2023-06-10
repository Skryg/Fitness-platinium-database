import { Component } from '@angular/core';
import { Observable } from 'rxjs';
import { ClientService } from '../service/client.service';
import { EquipmentService } from '../service/equipment.service';

@Component({
  selector: 'app-equipment',
  templateUrl: './equipment.component.html',
  styleUrls: ['./equipment.component.css']
})
export class EquipmentComponent {
    date1: Date = new Date();
    date2: Date = new Date();
    equipment: Array<string> = [];

    constructor(private equipmentService: EquipmentService) { }

    onSubmit() {
      this.getEquipment();
    }

    getEquipment(): void {
      this.equipmentService.getEquipment(this.date1, this.date2)
          .subscribe( data => { console.log(data);
            this.equipment = data as Array<string>;
          }, error => console.log(error));
    }

    update() : void {
      this.equipmentService.updateEquipment(this.date1, this.date2)
          .subscribe( data => { console.log(data);
          }, error => console.log(error));
    }

}
