import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ClientListComponent } from './client-list/client-list.component';
import { AddClientComponent } from './add-client/add-client.component';
import { FindClientComponent } from './find-client/find-client.component';
import { EquipmentComponent } from './equipment/equipment.component';

const routes: Routes = [
  {path: 'clients', component: ClientListComponent},
  {path: 'add-client', component: AddClientComponent},
  {path: 'find-client', component: FindClientComponent},
  {path: 'equipment', component: EquipmentComponent}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
