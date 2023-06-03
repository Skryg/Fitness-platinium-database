import { Component, OnInit } from '@angular/core';
import { Client } from '../client';
import { ClientService } from '../client.service';

@Component({
  selector: 'app-client-list',
  templateUrl: './client-list.component.html',
  styleUrls: ['./client-list.component.css']
})
export class ClientListComponent implements OnInit {
  clients: Client[] = [];
  id: number = 0;

  constructor(private clientService: ClientService) { }

  ngOnInit() : void {
    this.getClients();
  }

  getClients(): void {
    this.clientService.getClients()
      .subscribe(clients => this.clients = clients);
  }

  onSubmit() {
    this.clientService.getClientsbyGym(this.id)
    .subscribe(clients => this.clients = clients);
  }




}
