import { Component, EventEmitter, OnInit, Output } from '@angular/core';

@Component({
  selector: 'app-itens-pedido',
  templateUrl: './itens-pedido.component.html',
  styleUrls: ['./itens-pedido.component.scss']
})
export class ItensPedidoComponent implements OnInit {

  @Output() itens = new EventEmitter<any>;

  rowActions = {
    beforeSave: this.onBeforeSave.bind(this),
    afterSave: this.onAfterSave.bind(this),
    beforeRemove: this.onBeforeRemove.bind(this),
    afterRemove: this.onAfterRemove.bind(this),
    beforeInsert: this.onBeforeInsert.bind(this)
  };
  columns = [
    { property: 'item', label: 'Item', width: 50},
    { property: 'produto', label: 'Produto', width: 80, required: true},
    { property: 'descricao', label: 'Descrição', width: 200 },
    { property: 'qtd', label: 'Quantidade', width: 80 , required: true },
    { property: 'preco_unitario', label: 'Preço Unitário', width: 80 },
    { property: 'preco_total', label: 'Total', width: 80, required: true },
    { property: 'tes', label: 'TES', align: 'center', width: 80 }
  ];

  data = [
    {}
  ];

  constructor() { }

  ngOnInit(): void {
  }
  onBeforeSave(row: any) {
    console.log('current', row)

    if(row.produto !== undefined){
      this.itens.emit(row);
      return true
    }else {
      return false
    }
  }

  onAfterSave(row: any) {
    console.log('onAfterSave(new): ', row);
  }

  onBeforeRemove(row: any) {
    console.log('onBeforeRemove: ', row);

    return true;
  }

  onAfterRemove() {
    //console.log('onAfterRemove: ');
  }

  onBeforeInsert(row: any) {

    //console.log('onBeforeInsert: ', row);

    return true;
  }

}
