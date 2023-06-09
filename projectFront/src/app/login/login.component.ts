import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
import { AppService } from '../app.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent {
  error = false;
  errMessage: string = "";
  
  username: string = "";
  password: string = "";

  constructor(private http: HttpClient, private app: AppService, private router: Router) {

  }

  login() {
    this.error = false;
    let data = {
      username: this.username,
      password: this.password
    };
    this.http.post('http://localhost:8080/user/login', data).subscribe((result: any) => {
      console.log(result);
      if (result.status == true) {
        this.app.authenticated = true;
        this.router.navigateByUrl('/home');
      } else {
        this.error = true;
        this.errMessage = result.message;
      }
    });
  }
}