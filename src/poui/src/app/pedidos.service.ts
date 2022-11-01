import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { map, Observable, take } from 'rxjs';
import { environment } from 'src/environments/environment';
import { Pedido } from './pedido.model';

@Injectable({
  providedIn: 'root'
})
export class PedidosService {

  WEBSERVICE_URL = `${environment.API}pedidos/`
  pedidos: Pedido[]

  constructor(private http: HttpClient) { }

  // não necessario por enquanto
  public list(): Observable<Pedido[]> {
    return this.http.get<Pedido[]>(this.WEBSERVICE_URL).pipe(
      map((resposta: any) => resposta));

  }

  public listPedido(numero: string): Observable<Pedido>{
    console.log(this.WEBSERVICE_URL+numero)
    return this.http.get<Pedido>(this.WEBSERVICE_URL+numero).pipe(
      map((resposta: any) => resposta)
    );
  }

  public delete(numero: string): Observable<string>  {
    console.log(this.WEBSERVICE_URL+numero)
    return this.http.delete<string>(this.WEBSERVICE_URL+numero)

  }

  public create(pedido: Pedido){
    console.log(pedido)
    return this.http.post<Pedido>(this.WEBSERVICE_URL, JSON.stringify(pedido)).pipe(take(1))
  }

  public edit(pedido: Pedido){
    console.log(pedido)
    return this.http.put<Pedido>(this.WEBSERVICE_URL, JSON.stringify(pedido)).pipe(take(1))
  }
}
