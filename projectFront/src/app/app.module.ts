import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { HttpClientModule } from '@angular/common/http'; 
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { ClientListComponent } from './client-list/client-list.component';
import { AddClientComponent } from './add-client/add-client.component';
import { FormsModule } from '@angular/forms';
import { FindClientComponent } from './find-client/find-client.component';
import { EquipmentComponent } from './equipment/equipment.component';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
import { LoginComponent } from './login/login.component';
import { HomeComponent } from './home/home.component';
import { AppService } from './app.service';

@NgModule({
  declarations: [
    AppComponent,
    ClientListComponent,
    AddClientComponent,
    FindClientComponent,
    EquipmentComponent,
    LoginComponent,
    HomeComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    HttpClientModule,
    FormsModule,
    NgbModule
  ],
  providers: [AppService],
  bootstrap: [AppComponent]
})
export class AppModule { }
