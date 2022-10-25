import { Component, EventEmitter, OnInit, Output } from '@angular/core';
import { Item } from 'src/app/item.model';

@Component({
  selector: 'app-itens-pedido',
  templateUrl: './itens-pedido.component.html',
  styleUrls: ['./itens-pedido.component.scss']
})
export class ItensPedidoComponent implements OnInit {

  @Output() itens = new EventEmitter<Item>;

  itemCount = 1

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
    //{ property: 'descricao', label: 'Descrição', width: 200 },
    { property: 'qtd', label: 'Quantidade', width: 80 , required: true },
    { property: 'preco_unitario', label: 'Preço Unitário', width: 80, required: true },
    { property: 'preco_total', label: 'Total', width: 80, required: true },
    { property: 'TES', label: 'TES', align: 'center', width: 80 }
  ];

  data = [
    {item: 1}
  ];

  constructor() { }

  ngOnInit(): void {
  }
  onBeforeSave(row: Item, old: any) {
    
    if((row.produto || row.qtd || row.preco_unitario || row.preco_total) !== undefined){
      row.qtd = Number(row.qtd).valueOf()
      row.preco_unitario = Number(row.preco_unitario).valueOf()
      row.preco_total = row.qtd * row.preco_unitario

      this.itens.emit(row);
      return true
    }else {
      return false
    }
  }

  onAfterSave(row: any) {
    console.log("onAfterSave: ", row)
  }

  onBeforeRemove(row: any) {
    row = undefined
    this.itemCount--
    return true;
  }

  onAfterRemove() {
    //console.log('onAfterRemove: ');

  }

  onBeforeInsert(row: any) {
    console.log(this.itemCount)
    row.item = ++this.itemCount
    console.log('onBeforeInsert: ', row);

    return true;
  }

}
