import { Component } from '@angular/core';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
import { finalize } from "rxjs/operators";


@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'Baza';
  selectedOption: string = '1';
  public static gymId: number = 0;

  constructor(private modalService: NgbModal, private http: HttpClient, private router: Router) {

  }

  public open(modal: any): void {
    this.modalService.open(modal);
  }

  public updateGymId() : void {
    AppComponent.gymId = parseInt(this.selectedOption);
  }
}
