import { Component, ɵsetAlternateWeakRefImpl } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.css']
})
export class RegisterComponent {
  error = false;
  errMessage: string = "";

  id_employee: number = 0;
  username: string = "";
  password: string = "";
  permission: number = 0;

  constructor(private http: HttpClient) {

  }

  register() {
    
    let data = {
      idEmployee: this.id_employee,
      username: this.username,
      password: this.password,
      permission: this.permission
    };
    alert(this.id_employee);
    this.http.post('http://localhost:8080/user/register', data).subscribe((result: any) => {
      console.log(result);
      
    });
  }
}


