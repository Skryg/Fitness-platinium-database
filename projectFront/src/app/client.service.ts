import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { Client } from './client';

@Injectable({
  providedIn: 'root'
})
export class ClientService {
  private baseURL = "http://localhost:8080/client";
  
  constructor(private httpClient: HttpClient) { }

  public getClients(): Observable<Client[]> {
    console.log(this.httpClient.get<Client[]>(`${this.baseURL}`));
    return this.httpClient.get<Client[]>(`${this.baseURL}`);
  }
}
