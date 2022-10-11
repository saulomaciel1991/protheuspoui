import { Component, OnInit, ViewChild } from '@angular/core';
import { PoDynamicViewField, PoModalComponent } from '@po-ui/ng-components';
import {
  PoPageDynamicTableActions,
  PoPageDynamicTableCustomAction,
  PoPageDynamicTableCustomTableAction,
  PoPageDynamicTableOptions
} from '@po-ui/ng-templates';

@Component({
  selector: 'app-tabela-pedidos',
  templateUrl: './tabela-pedidos.component.html',
  styleUrls: ['./tabela-pedidos.component.scss']
})
export class TabelaPedidosComponent implements OnInit {
  @ViewChild('pedidoDetailModal') pedidoDetailModal!: PoModalComponent;
  @ViewChild('legendaModal') legendaModal!: PoModalComponent;

  detailedPedido: any

  readonly serviceApi = 'http://localhost:8090/rest/pedidos'

  readonly actions: PoPageDynamicTableActions = {
    new: '/documentation/po-page-dynamic-edit',
    remove: true,
    edit: 'edit/:id',
    removeAll: true
  };
  readonly statusOptions: Array<object> = [
    { value: 'E', label: 'Encerrado' },
    { value: 'A', label: 'Aberto' },
    { value: 'L', label: 'Liberado' }
  ];

  readonly fields: Array<any> = [
    { property: 'legenda', label:'Legenda', icon:'po-icon po-icon-message'},
    { property: 'status', label: 'Status', filter: true, options: this.statusOptions, gridColumns: 8},
    { property: 'numero', label: 'Numero' },
    { property: 'cliente', label: 'Cliente', filter: true, gridColumns: 6},
    { property: 'nomeCliente', label: 'Nome do Cliente', filter: true, gridColumns: 6},
    { property: 'loja', label: 'loja' },
    { property: 'tipoPed', label: 'Tipo' },
    { property: 'natureza', label: 'Natureza' },
    { property: 'condPagto', label: 'Condição de Pagto.', filter: true, gridColumns: 4}
  ];

  readonly detailFields: Array<PoDynamicViewField> = [
    { property: 'numero', label: 'Número', gridLgColumns: 4, divider: 'Info' },
    { property: 'cliente', gridLgColumns: 4 },
    { property: 'nomeCliente', label:'Nome do Cliente', gridLgColumns: 4 },
    { property: 'condPagto', label:'Condição de Pagto.', gridLgColumns: 4 },
  
  ];

 

  pageCustomActions: Array<PoPageDynamicTableCustomAction> = [
    {
      label: 'Legenda',
      icon: 'po-icon po-icon-message',
      action: this.onClickLegendaOpen.bind(this)
    },

    { label: 'Print', action: this.printPage.bind(this), icon: 'po-icon-print' },

  ];

  tableCustomActions: Array<PoPageDynamicTableCustomTableAction> = [
    {
      label: 'Details',
      action: this.onClickPedidoDetail.bind(this),
      icon: 'po-icon-user'
    }
  ];
  

  constructor() { }

  ngOnInit(): void {
  }

  printPage() {
    window.print();
  }

  private teste(row: any){
    console.log(row)
  }

  private onClickPedidoDetail(pedido: any) {
    this.detailedPedido = pedido;
    console.log(pedido)

    this.pedidoDetailModal.open();
  }

  private onClickLegendaOpen(){
    this.legendaModal.open()
  }


}
