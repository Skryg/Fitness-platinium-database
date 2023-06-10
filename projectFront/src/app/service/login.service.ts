import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
@Injectable({
  providedIn: 'root'
})
export class LoginService {

  constructor(private http : HttpClient, private router: Router) { }

  login(username : string, password : string){
    let data = {
      username: username,
      password: password
    };
    return this.http.post('http://localhost:8080/user/login', data);
  }

  logout(){
    sessionStorage.removeItem('token');
    sessionStorage.removeItem('perm');
    this.router.navigateByUrl('/home');
  }

}
