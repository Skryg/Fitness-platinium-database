import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
@Injectable({
  providedIn: 'root'
})
export class PermissionService {
  constructor(private http: HttpClient) { }

  private URL = "http://localhost:8080/permission";
  public getPermission(): Observable<Object> {
    return this.http.get(this.URL, {responseType: 'text'});
  }

  permission() : Promise<any> {
    return new Promise(resolve=>{
      this.getPermission().subscribe((data: any) => {
        sessionStorage.setItem("perm", data);
        resolve(true);
     });
    });
  }
  
  proceed(){
    this.permission().then(value=>{});
  }  
  
}
