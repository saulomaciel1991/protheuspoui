import { Component, EventEmitter, OnInit, Output, Input } from '@angular/core';
import { Item } from 'src/app/item.model';

@Component({
  selector: 'app-itens-pedido',
  templateUrl: './itens-pedido.component.html',
  styleUrls: ['./itens-pedido.component.scss']
})
export class ItensPedidoComponent implements OnInit {

  @Output() itens = new EventEmitter<Item[]>;
  @Input() item: Item[] = []


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

  data: Item[] = [
    {
      item:'',
      produto:'',
      qtd:0,
      preco_unitario:0,
      preco_total:0,
      TES:''
    }
  ];

  constructor() { }

  ngOnInit(): void {
    if (this.item.length > 0){
      this.data.pop()
      for(var i=0; i< this.item.length; i++){
        this.data.push(this.item[i])
      }

    }
  }
  onBeforeSave(row: Item) {
   // console.log(this.data)
    if((row.produto || row.qtd || row.preco_unitario || row.preco_total) !== undefined){
      row.qtd = Number(row.qtd).valueOf()
      row.preco_unitario = Number(row.preco_unitario).valueOf()
      row.preco_total = row.qtd * row.preco_unitario
      this.itens.emit(this.data);
      return true
    }else {
      return false
    }
  }

  onAfterSave(row: any) {
    //console.log("onAfterSave: ", row)
  }

  onBeforeRemove(row: any) {
    this.itens.emit(this.data.slice(0,-1))
    return true;
  }

  onAfterRemove() {
    console.log('onAfterRemove: ');

  }

  onBeforeInsert(row: any) {
    return true;
  }

}
