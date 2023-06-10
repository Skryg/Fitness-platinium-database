import { Component } from '@angular/core';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
import { finalize } from "rxjs/operators";
import { ChangeDetectionStrategy } from '@angular/core';
import { LoginService } from './service/login.service';
import { PermissionService } from './service/permission.service';


@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css'],
  // changeDetection: ChangeDetectionStrategy.OnPush
})
export class AppComponent {
  title = 'Baza';
<<<<<<< HEAD
  perm = 0;
  constructor(private modalService: NgbModal,
      private http: HttpClient, private router: Router,
      public loginService: LoginService, 
      private permissionService: PermissionService) {}
=======
  selectedOption: string = '1';
  public static gymId: number = 0;

  constructor(private modalService: NgbModal, private http: HttpClient, private router: Router) {

  }
>>>>>>> 7a43a7b19a9486dda02210eeb786a49c9a0f1279

  public open(modal: any): void {
    this.modalService.open(modal);
  }

<<<<<<< HEAD
  public hasToken(){
    return sessionStorage.getItem('token') != null;
  }

  permission() : Promise<any> {
    return new Promise(resolve=>{
      this.permissionService.getPermission().subscribe((data: any) => {
        this.perm = data;
        resolve(true);
     });
    });
  }
  
  proceed(){
    this.permission().then(value=>{alert("proceed");});
  }

  
=======
  public updateGymId() : void {
    AppComponent.gymId = parseInt(this.selectedOption);
  }
>>>>>>> 7a43a7b19a9486dda02210eeb786a49c9a0f1279
}
