import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { EditResolver } from './edit.resolver';
import { NovoPedidoComponent } from './pedidos/novo-pedido/novo-pedido.component';
import { TabelaPedidosComponent } from './pedidos/tabela-pedidos/tabela-pedidos.component';

const routes: Routes = [
  { path: '', component: TabelaPedidosComponent},
  { path: 'novo-pedido', component: NovoPedidoComponent},
  { path: 'novo-pedido/:numero', component: NovoPedidoComponent, resolve:{pedido: EditResolver}}

];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
