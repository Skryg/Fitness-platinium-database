import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { Client } from '../client';

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

  public addClient(client: Client): Observable<Object> {
    return this.httpClient.post(`${this.baseURL}`, client);
  }
  public getClient(id: number): Observable<Client> {
    return this.httpClient.get<Client>(`${this.baseURL}/${id}`);
  }

  public deleteClient(id: number): Observable<Object> {
    return this.httpClient.delete(`${this.baseURL}/${id}`);
  }

  public getEntriesByClient(id: number): Observable<Object> {
    return this.httpClient.get(`${this.baseURL}/entries/${id}`);
  }

  public getClientsbyGym(id: number): Observable<Client[]> {
    return this.httpClient.get<Client[]>(`${this.baseURL}/gym/${id}`);
  }

  public getEntriesByGym(id: number): Observable<Object> {
    return this.httpClient.get(`${this.baseURL}/entries/gym/${id}`);
  }


}
