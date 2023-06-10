import { Component, OnInit } from '@angular/core';
import { Client } from '../client';
import { ClientService } from '../client.service';
import { AppComponent } from '../app.component';


@Component({
  selector: 'app-client-list',
  templateUrl: './client-list.component.html',
  styleUrls: ['./client-list.component.css']
})
export class ClientListComponent implements OnInit {
  clients: Client[] = [];
  id: number = 0;
  entries: Array<string> = [];

  constructor(private clientService: ClientService) { }

  ngOnInit() : void {
    this.getClients();
  }

  getClients(): void {
    this.clientService.getClients()
      .subscribe(clients => this.clients = clients);
  }

  s: string = '';
  onSubmit() {
    this.entries = [];
    this.clientService.getEntriesByGym(AppComponent.gymId).subscribe(data => {
      this.s = data.toString();
      console.log(this.s);
    }
    , error => console.log(error));
    
    this.format();

  }
  format() : void {
    let cnt  = 0;
    let tmp = '';
    for(let i = 0; i < this.s.length; i++) {
      if(this.s[i] == ',')
        cnt++;
      tmp+= this.s[i];
      if(cnt == 3){
        cnt = 0;
        this.entries.push(tmp);
        console.log(tmp);
        tmp = '  ';
      }
    }
    this.entries.push(tmp);
  }



}
