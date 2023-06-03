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
    entries: string = '';
    entriesShow: boolean = false;


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
    getEntriesByClient(id: number) {
      this.entriesShow = true;
      this.clientService.getEntriesByClient(id)
        .subscribe( data => { console.log(data);
          this.entries = data.toString();
        }, error => console.log(error));
    }
    gotoList() {
        this.router.navigate(['/clients']);
    }
    
    formatEntries(entries: string): Array<string> {
      let entriesArray: Array<string> = [];
    for (let i = 0; i < entries.length; i++) {
      if (entries.charAt(i) == ',') {
        entriesArray.push(entries.substring(0, i));
        entries = entries.substring(i+1);
        i = 0;
      }
    }
    entriesArray.push(entries);
    return entriesArray;
  }
}
