import { Injectable } from '@angular/core';
import {
  Router, Resolve,
  RouterStateSnapshot,
  ActivatedRouteSnapshot
} from '@angular/router';
import { Observable, of } from 'rxjs';
import { Pedido } from './pedido.model';
import { PedidosService } from './pedidos.service';


@Injectable({
  providedIn: 'root'
})
export class EditResolver implements Resolve<Pedido> {
  constructor(private pedidoService: PedidosService) {}

  resolve(route: ActivatedRouteSnapshot): Observable<Pedido> {
    return this.pedidoService.listPedido(String(route.paramMap.get('numero')))
  }
}
