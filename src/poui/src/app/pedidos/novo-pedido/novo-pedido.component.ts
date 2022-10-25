import { Component, OnInit } from '@angular/core';
import { PoDynamicFormField, PoNotificationService, PoPageEditLiterals } from '@po-ui/ng-components';
import { PoPageDynamicEditActions } from '@po-ui/ng-templates';
import { Item } from 'src/app/item.model';
import { Pedido } from 'src/app/pedido.model';
import { environment } from 'src/environments/environment';
import { FormControl, NgForm } from '@angular/forms';
import { Router } from '@angular/router';
import { PedidosService } from 'src/app/pedidos.service';

@Component({
  selector: 'app-novo-pedido',
  templateUrl: './novo-pedido.component.html',
  styleUrls: ['./novo-pedido.component.scss']
})
export class NovoPedidoComponent implements OnInit {

  itens: Item[] = []
  pedido: Pedido = new Pedido()
  valido = false

  addItem(newItem: any) {
    if (this.itens.length > 0) {

      if (this.itens[this.itens.length - 1].item != newItem.item) {
        this.itens.push(newItem)

      }
    } else {
      this.itens.push(newItem)
    }
  }

  public readonly serviceApi = `${environment.API}pedidos`
  /*

  public readonly actions: PoPageDynamicEditActions = {
    cancel: '/',
    saveNew: '/',
    save: this.salvarPedido.bind(this)
  };
*/
  public fields: Array<PoDynamicFormField> = [
    { 
      property: 'numero',
      label: 'Numero',
      required: true,
      maxLength: 6,
      gridColumns: 2,
      type: "string",
      pattern: '^[A-Z0-9]+$',
      errorMessage:"Apenas letras maiúsculas e/ou números",
      gridSmColumns: 6
    },
    {
      property: 'tipoPed',
      label: 'Tipo',
      offsetLgColumns: 1,
      gridColumns: 4,
      gridSmColumns: 6,
      options: ['N', 'C', 'I', 'P', 'B'],
      //help:"N - Normal \n C - Compl.Preço/Quantidade \n I - Complemento ICMS \n P - Complemento IPI \n B - Utiliza Fornecedor"
    },
    //options: ['N - Normal', 'C - Compl.Preço/Quantidade', 'I - Complemento ICMS', 'P - Complemento IPI','B - Utiliza Fornecedor']},
    { 
      property: 'cliente',
      label: 'Cliente',
      gridColumns: 4,
      required: true,
      offsetLgColumns: 1,
      gridSmColumns: 6,
      optionsService: this.serviceApi,
      fieldLabel: 'cliente',
      fieldValue: 'cliente',
    },
    { 
      property: 'loja',
      label: 'loja',
      gridColumns: 2,
      required: true,
      gridSmColumns: 6,
      optionsService: this.serviceApi,
      fieldLabel: 'loja',
      fieldValue: 'loja',
    },
    { 
      property: 'nomeCliente', label: 'Nome do Cliente', gridColumns: 8, 
      offsetLgColumns: 1, gridSmColumns: 12,
      pattern: '^[A-Z0-9\\s]+$',
      errorMessage:"Apenas letras maiúsculas e/ou números",
    },
    {
      property: 'natureza', label: 'Natureza', gridColumns: 2, gridSmColumns: 5,
      maxLength: 6,
      pattern: '^[A-Z0-9]+$',
      errorMessage:"Apenas letras maiúsculas e/ou números",
    },
    {
      property: 'condPagto',
      label: 'Condição de Pagto.',
      gridColumns: 2,
      required: true,
      offsetLgColumns: 1,
      gridSmColumns: 7,
      optionsService: this.serviceApi,
      fieldLabel: 'condPagto',
      fieldValue: 'condPagto',
    }
  ];

  customLiterals: PoPageEditLiterals = {
    cancel: 'Voltar',
    save: 'Confirmar',
    saveNew: 'Confirmar e criar um novo'
  };


  constructor(
    private poNotification: PoNotificationService,
    private router: Router,
    private pedidoService: PedidosService
    ) {

  }

  ngOnInit(): void {
    this.pedido = {
      numero: '',
      loja:'',
      natureza: '',
      cliente: '',
      nomeCliente: '',
      condPagto: '',
      tipoPed:'',
      status:'',
      itens: []
    }

  }

  public save(dynamicForm: NgForm){

    if (this.itens.length < 1){
      this.poNotification.warning("Os itens do pedido precisam ser informados")
    }else{
      if (dynamicForm.valid){
        this.pedido.itens = this.itens
        console.log(this.pedido)
        this.pedidoService.create(this.pedido)
        .subscribe({
          next: (v: any) => {
            if (v.message.includes('sucesso')) {
              this.poNotification.success(v.message)
            } else {
              this.poNotification.error(v.message)
            }
          },
          error: (e: any) => this.poNotification.error("Error"),
          complete: () => {
            dynamicForm.reset()
            this.router.navigate([''])
          }
        })
      }
    }


  }
  cancelar(){
    this.router.navigate([''])
  }


}
