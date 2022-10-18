import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { NovoPedidoComponent } from './pedidos/novo-pedido/novo-pedido.component';
import { TabelaPedidosComponent } from './tabela-pedidos/tabela-pedidos.component';

const routes: Routes = [
  { path: '', component: TabelaPedidosComponent},
  { path: 'novo-pedido', component: NovoPedidoComponent},
  
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
