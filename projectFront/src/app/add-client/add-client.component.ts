import { Component } from '@angular/core';
import { OnInit } from '@angular/core';
import { Client } from '../client';
import { ClientService } from '../service/client.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-add-client',
  templateUrl: './add-client.component.html',
  styleUrls: ['./add-client.component.css'],

})
export class AddClientComponent implements OnInit{
  client: Client = new Client();

  constructor(private clientService: ClientService, private router: Router) { }

  ngOnInit() {
  }

  onSubmit() {
    this.addClient();
  }
  addClient(): void {
    this.clientService.addClient(this.client)
        .subscribe( data => { console.log(data);
          this.gotoList();
        }, error => console.log(error));
    
    
  }
  gotoList() {
      this.router.navigate(['/clients']);
  }

}
