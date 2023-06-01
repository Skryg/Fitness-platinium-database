import { Component } from '@angular/core';
import { OnInit } from '@angular/core';
import { Client } from '../client';
import { ClientService } from '../client.service';
import { Router } from '@angular/router';
import { Observable } from 'rxjs';

@Component({
  selector: 'app-find-client',
  templateUrl: './find-client.component.html',
  styleUrls: ['./find-client.component.css']
})
export class FindClientComponent implements OnInit {
    id: number = 0;
    client: Client = new Client();
    delButton: boolean = false;
    clientShow: boolean = false;


    constructor(private clientService: ClientService, private router: Router) { }
  
    ngOnInit(): void {
    }

    onSubmit() {
      this.findClient();
    }
    findClient(): void {
      this.clientService.getClient(this.id)
          .subscribe( data => { console.log(data);
            this.client = data;
          }, error => console.log(error));
      this.delButton = true;
      this.clientShow = true;

    }

    deleteClient(id: number) {
      this.clientService.deleteClient(id)
        .subscribe( data => { console.log(data);
          this.gotoList();
        }, error => console.log(error));
    }
    gotoList() {
        this.router.navigate(['/clients']);
    }
    
}
