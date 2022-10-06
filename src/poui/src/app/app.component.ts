import { Component } from '@angular/core';

import { PoToolbarAction, PoButtonGroupItem, PoDropdownAction} from '@po-ui/ng-components';


@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {

  buttons: Array<PoButtonGroupItem> = [
    { label: 'Button 1', icon: '', action: this.action.bind(this) },
    { label: 'Button 2', action: this.action.bind(this) }
  ];

  

  actions: Array<PoToolbarAction> = [
    { label: 'Exibir Todos', action: (item: PoToolbarAction) => this.showAction(item) },
    { label: 'Pedidos Abertos', action: (item: PoToolbarAction) => this.showAction(item) },
    { label: 'Pedidos Bloqueados por Regra', action: (item: PoToolbarAction)  => this.showAction(item) },
    { label: 'Pedidos Bloqueados por Verba', action: (item: PoToolbarAction)  => this.showAction(item) },
    { label: 'Pedidos Encerrados', action: (item: PoToolbarAction)  => this.showAction(item) },
    { label: 'Pedidos Liberados', action: (item: PoToolbarAction)  => this.showAction(item) }
  ];

  public readonly actions_dropdown: Array<PoDropdownAction> = [
    { label: 'Pesquisar', url: '/'},
    { label: 'Excluir', url: '/'},
    { label: 'Legenda', url: '/'},
  ]

  

  showAction(item: PoToolbarAction): void {
    console.log('teste')
  }

  action(button: PoButtonGroupItem) {
    alert(`${button.label}`);
  }


}
