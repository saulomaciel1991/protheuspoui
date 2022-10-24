import { Component, OnInit } from '@angular/core';
import { PoDynamicFormField } from '@po-ui/ng-components';
import { PoPageDynamicEditActions} from '@po-ui/ng-templates';
import { Item } from 'src/app/item.model';
import { Pedido } from 'src/app/pedido.model';
import { environment } from 'src/environments/environment';

@Component({
  selector: 'app-novo-pedido',
  templateUrl: './novo-pedido.component.html',
  styleUrls: ['./novo-pedido.component.scss']
})
export class NovoPedidoComponent implements OnInit {

  itens: Item[] = []

  addItem(newItem: any) {
    this.itens.push(newItem);
  }

  public readonly serviceApi = `${environment.API}pedidos`

  public readonly actions: PoPageDynamicEditActions = {
    cancel: '/',
    saveNew: '/',
    save: this.salvarPedido.bind(this)
  };

  public fields: Array<PoDynamicFormField> = [
    { property: 'numero', label: 'Numero', required: true, maxLength: 6, gridColumns: 2 },
    {
      property: 'tipoPed',
      label: 'Tipo',
      offsetLgColumns: 1,
      gridColumns: 4,
      options: ['N', 'C', 'I', 'P','B']},
      //options: ['N - Normal', 'C - Compl.Preço/Quantidade', 'I - Complemento ICMS', 'P - Complemento IPI','B - Utiliza Fornecedor']},
    { property: 'cliente', label: 'Cliente', gridColumns: 4, required: true, offsetLgColumns: 1,},
    { property: 'loja', label: 'loja', gridColumns: 2, required: true },
    { property: 'nomeCliente', label: 'Nome do Cliente', gridColumns: 8, offsetLgColumns: 1,},
    { property: 'natureza', label: 'Natureza', gridColumns: 2 },
    { property: 'condPagto', label: 'Condição de Pagto.', gridColumns: 2, required: true, offsetLgColumns: 1,}
  ];


  constructor(){

  }

  ngOnInit(): void {

  }

  private salvarPedido(pedido: Pedido){
    console.log(this.itens)
  }
}
