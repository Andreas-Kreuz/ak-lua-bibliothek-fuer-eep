import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { PublicTransportComponent } from './public-transport.component';

const routes: Routes = [{ path: '', component: PublicTransportComponent }];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class PublicTransportRoutingModule { }
