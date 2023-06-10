import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class EquipmentService {

  constructor(private httpEquipment: HttpClient) { }

  
  private eqURL = "http://localhost:8080/equipment";
  public getEquipment(date1: Date, date2: Date): Observable<Object> {
    return this.httpEquipment.get(`${this.eqURL}/${date1}/${date2}`);
  }

  public updateEquipment(date1: Date, date2: Date): Observable<Object> {
    return this.httpEquipment.put(`${this.eqURL}/${date1}/${date2}`, null);
  }

}
