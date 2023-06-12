import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
import { AppService } from '../service/app.service';
import { LoginService } from '../service/login.service';
import { PermissionService } from '../service/permission.service';
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

  constructor(private http: HttpClient, private app: AppService, private router: Router, private loginService: LoginService, private permissionService: PermissionService) {
  }

  login() {
    this.error = false;
    
    this.loginService.login(this.username, this.password).subscribe((result: any) => {
      console.log(result);
      if (result.status == true) {
        sessionStorage.setItem('token', result.message);
        sessionStorage.setItem('perm', result.permission);
        this.app.authenticated = true;
        
        this.router.navigateByUrl('/home');
      } else {
        this.error = true;
        this.errMessage = result.message;
      }
    });
  }
}