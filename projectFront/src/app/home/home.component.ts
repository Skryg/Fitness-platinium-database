import { Component } from '@angular/core';
import { AppService } from '../service/app.service';
import { HttpClient } from '@angular/common/http';
import { PermissionService } from '../service/permission.service';
import { Observable } from 'rxjs';
@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent {
  title = 'Baza';
  perm = 0;
  // greeting = { id: '', content: ''};  
  constructor(private http: HttpClient, private permissionService: PermissionService) {
    this.perm = sessionStorage.getItem('perm') as unknown as number;
  }

 
}
