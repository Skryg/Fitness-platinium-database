import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class EquipmentService {

  constructor(private httpEquipment: HttpClient) { }

  
  private eqURL = "http://localhost:8080/equipment";
  public getEquipment(id: number): Observable<Object> {
    return this.httpEquipment.get(`${this.eqURL}/${id}`);
  }
}
