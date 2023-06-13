import { Component } from '@angular/core';
import { OnInit } from '@angular/core';
import { Client } from '../client';
import { ClientService } from '../service/client.service';
import { Router } from '@angular/router';
import { Observable } from 'rxjs';
import { AppComponent } from '../app.component';

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
    canEnter: string = '';

    name: string = '';


    constructor(private clientService: ClientService, private router: Router) { }
  
    ngOnInit(): void {
    }

    onSubmit() {
      this.findClient();
      this.canEnter = 'Can Enter:'
      this.clientService.canEnterGym(this.id, AppComponent.gymId).subscribe(data => {
        this.canEnter += data.toString();
        console.log(this.canEnter);
      }
      , error => console.log(error));
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
        this.gotoList();
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

  byName() {
    this.canEnter = 'Can Enter:'
    this.clientService.canEnterGym(this.id, AppComponent.gymId).subscribe(data => {
      this.canEnter += data.toString();
      console.log(this.canEnter);
    }
    , error => console.log(error));
    this.clientService.getPersonByName(this.name)
      .subscribe( data => {
        let id = 0;
        let name = '';
        let surname = '';
        let address = '';
        let phone = '';
        let email = '';
        let tmp = '';
        let cnt = 0;
        console.log(data.toString());
        for (let i = 0; i < data.toString().length; i++) {
          if(data.toString()[i]!=',')
              tmp += data.toString()[i];
          else{
              if(cnt == 0)
                id = parseInt(tmp);
              else if(cnt == 1)
                name = tmp;
              else if(cnt == 2)
                surname = tmp;
              else if(cnt == 3)
                address = tmp;
              else if(cnt == 4)
                phone = tmp;
              else if(cnt == 5)
                email = tmp;
              tmp = '';
              cnt++;
          }
        }
        if(email == '')
          email = tmp;
        console.log(id);
        console.log(name);
        console.log(surname);
        this.client.id = id;
        this.client.name = name;
        this.client.surname = surname;
        this.client.address = address;
        this.client.phone = phone;
        this.client.email = email;
        this.clientShow = true;
        this.delButton = true;

      }, error => console.log(error));
  }

  Enter() {
    this.clientService.enter(this.client.id, AppComponent.gymId).subscribe(data => {
      console.log(data);
    }
    , error => console.log(error));

  }

  Exit() {
    this.clientService.exit(this.client.id).subscribe(data => {
      console.log(data);
    }
    , error => console.log(error));

  }



}
