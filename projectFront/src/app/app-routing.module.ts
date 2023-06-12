import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ClientListComponent } from './client-list/client-list.component';
import { AddClientComponent } from './add-client/add-client.component';
import { FindClientComponent } from './find-client/find-client.component';
import { EquipmentComponent } from './equipment/equipment.component';
import { LoginComponent } from './login/login.component';
import { HomeComponent } from './home/home.component';
import { RegisterComponent } from './register/register.component';
import { authenticationGuard } from './authentication.guard';
import { ChallengesComponent } from './challenges/challenges.component';

const routes: Routes = [
  {path: '', pathMatch: 'full', redirectTo: 'home'},
  {path: 'register', component: RegisterComponent, canActivate: [authenticationGuard]},
  {path: 'login', component: LoginComponent, canActivate: [authenticationGuard]},
  {path: 'home', component: HomeComponent},
  {path: 'clients', component: ClientListComponent, canActivate: [authenticationGuard]},
  {path: 'add-client', component: AddClientComponent, canActivate: [authenticationGuard]},
  {path: 'find-client', component: FindClientComponent, canActivate: [authenticationGuard]},
  {path: 'equipment', component: EquipmentComponent, canActivate: [authenticationGuard]},
  {path: 'challenges', component: ChallengesComponent, canActivate: [authenticationGuard]},
  {path: '**', redirectTo: 'home'}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
