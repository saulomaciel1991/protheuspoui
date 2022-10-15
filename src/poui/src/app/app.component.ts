import { Component } from '@angular/core';

import { PoButtonGroupItem, PoDropdownAction, PoToolbarAction } from '@po-ui/ng-components';

// import { ProAppConfigService } from '@totvs/protheus-lib-core';


@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {

  // constructor(private proAppConfigService: ProAppConfigService) {
  //   if (!this.proAppConfigService.insideProtheus()) {
  //     this.proAppConfigService.loadAppConfig();
  //   }
  // }

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

  // private closeApp() {
  //   if (this.proAppConfigService.insideProtheus()) {
  //     this.proAppConfigService.callAppClose();
  //   } else {
  //     alert('O App não está sendo executado dentro do Protheus.');
  //   }
  // }


}
