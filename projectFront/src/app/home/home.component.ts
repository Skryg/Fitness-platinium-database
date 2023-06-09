import { Component } from '@angular/core';
import { AppService } from '../app.service';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent {
  title = 'Baza';
  // greeting = { id: '', content: ''};
  
  constructor(private http: HttpClient) {
    // http.get('resource').subscribe((data: {}) => this.greeting = data);
  }
  
}
