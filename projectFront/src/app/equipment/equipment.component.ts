import { Component } from '@angular/core';
import { Observable } from 'rxjs';
import { ClientService } from '../client.service';
import { EquipmentService } from '../equipment.service';

@Component({
  selector: 'app-equipment',
  templateUrl: './equipment.component.html',
  styleUrls: ['./equipment.component.css']
})
export class EquipmentComponent {
    id: number = 0;
    date1: Date = new Date();
    date2: Date = new Date();
    equipment: string = '';

    constructor(private equipmentService: EquipmentService) { }

    onSubmit() {
      this.getEquipment();
    }

    getEquipment(): void {
      this.equipmentService.getEquipment(this.id)
          .subscribe( data => { console.log(data);
            this.equipment = data.toString();
          }, error => console.log(error));
    }

}
