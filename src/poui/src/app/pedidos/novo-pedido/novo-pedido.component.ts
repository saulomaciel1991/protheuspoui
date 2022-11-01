import { Component, OnChanges, OnInit, SimpleChanges } from '@angular/core';
import { PoDynamicFormField, PoNotificationService, PoPageEditLiterals } from '@po-ui/ng-components';
import { PoPageDynamicEditActions } from '@po-ui/ng-templates';
import { Item } from 'src/app/item.model';
import { Pedido } from 'src/app/pedido.model';
import { environment } from 'src/environments/environment';
import { FormControl, NgForm } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { PedidosService } from 'src/app/pedidos.service';

@Component({
  selector: 'app-novo-pedido',
  templateUrl: './novo-pedido.component.html',
  styleUrls: ['./novo-pedido.component.scss']
})
export class NovoPedidoComponent implements OnInit {

  data: any
  edit: boolean = false
  itens: Item[] = []
  pedido: Pedido = new Pedido()

  addItem(newItem: Item[]) {
    if (newItem[newItem.length-1].produto !== undefined){
      this.pedido.itens = newItem
    }else{
      this.pedido.itens = newItem.slice(0,-1)
    }

  }


  public readonly serviceApi = `${environment.API}pedidos`

  public fields: Array<PoDynamicFormField> = [
    {
      property: 'numero',
      label: 'Numero',
      required: true,
      maxLength: 6,
      gridColumns: 2,
      type: "string",
      pattern: '^[A-Z0-9]+$',
      errorMessage: "Apenas letras maiúsculas e/ou números",
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
      errorMessage: "Apenas letras maiúsculas e/ou números",
    },
    {
      property: 'natureza', label: 'Natureza', gridColumns: 2, gridSmColumns: 5,
      maxLength: 6,
      pattern: '^[A-Z0-9]+$',
      errorMessage: "Apenas letras maiúsculas e/ou números",
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
    private route: ActivatedRoute,
    private pedidoService: PedidosService
  ) {

  }

  ngOnInit(): void {
    this.pedido.itens = [] // Para não ser undefined
    this.pedido.nomeCliente = ''
    this.pedido.natureza = ''

    /*Se a rota indicar o número do pedido, os dados do pedido serão recuperados pelo
      edit.resolver, como indicado na definição da rota no app.routing.module.
      this.route.snapshot.data pega essas informações e os campos no formulário são preenchidos
      com os dados do pedido a ser editado.
      A razão para isso é que usando um resolver os dados do pedido são recuperados antes
      da inicialização do componente e evita que os campos do formulário não sejam preenchidos.
    */
    this.data = this.route.snapshot.data
    if (this.data.pedido != undefined) {
      this.pedido = {
        numero: this.data.pedido[0].numero,
        loja: this.data.pedido[0].loja,
        natureza: this.data.pedido[0].natureza,
        cliente: this.data.pedido[0].cliente,
        nomeCliente: this.data.pedido[0].nomeCliente,
        condPagto: this.data.pedido[0].condPagto,
        tipoPed: this.data.pedido[0].tipoPed,
        status: this.data.pedido[0].status,
        itens: this.data.pedido[0].itens
      }
      this.edit = true
    }
    console.log(this.edit)

  }


  public save(dynamicForm: NgForm) {

    if (this.itens.length < 1 && this.pedido.itens.length < 1) {
      this.poNotification.warning("Os itens do pedido precisam ser informados")
    } else {
      if (dynamicForm.valid) {
        if (!this.edit) {
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
        }else{
          console.log('edit')
          this.pedidoService.edit(this.pedido)
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


  }
  cancelar() {
    this.router.navigate([''])
  }


}
