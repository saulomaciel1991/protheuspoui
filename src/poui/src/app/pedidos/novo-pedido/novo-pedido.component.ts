import { Component, OnInit } from '@angular/core';
import { PoDynamicFormField } from '@po-ui/ng-components';
import { PoPageDynamicEditActions } from '@po-ui/ng-templates';
import { environment } from 'src/environments/environment';

@Component({
  selector: 'app-novo-pedido',
  templateUrl: './novo-pedido.component.html',
  styleUrls: ['./novo-pedido.component.scss']
})
export class NovoPedidoComponent implements OnInit {


  public readonly serviceApi = `${environment.API}pedidos`

  public readonly actions: PoPageDynamicEditActions = {
    save: '/documentation/po-page-dynamic-detail',
    saveNew: '/documentation/po-page-dynamic-edit'
  };



  public readonly fields: Array<PoDynamicFormField> = [
    { property: 'numero', label: 'Numero' },
    { property: 'cliente', label: 'Cliente', gridColumns: 6},
    { property: 'nomeCliente', label: 'Nome do Cliente', gridColumns: 6},
    { property: 'loja', label: 'loja' },
    { property: 'tipoPed', label: 'Tipo' },
    { property: 'natureza', label: 'Natureza' },
    { property: 'condPagto', label: 'Condição de Pagto.', gridColumns: 4}
  ];

  ngOnInit(): void {

  }
}