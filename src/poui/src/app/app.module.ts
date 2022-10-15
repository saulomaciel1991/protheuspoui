import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { RouterModule } from '@angular/router';
import { PoModule } from '@po-ui/ng-components';
import { PoTemplatesModule } from '@po-ui/ng-templates';
import { ProtheusLibCoreModule } from '@totvs/protheus-lib-core';
import { AppComponent } from './app.component';

//Components
import { PoButtonGroupModule, PoButtonModule, PoContainerModule, PoDropdownModule, PoMenuModule, PoMenuPanelModule, PoNavbarModule, PoTableModule, PoToolbarModule } from '@po-ui/ng-components';
import { PoPageDynamicTableModule } from '@po-ui/ng-templates';
import { TabelaPedidosComponent } from './tabela-pedidos/tabela-pedidos.component';

//Components

//po-ui components
import { PoModalModule } from '@po-ui/ng-components';

@NgModule({
  declarations: [
    AppComponent,
    TabelaPedidosComponent
  ],
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    PoModule,
    RouterModule.forRoot([]),
    PoTemplatesModule,
    PoNavbarModule,
    PoToolbarModule,
    PoTableModule,
    PoButtonModule,
    PoButtonGroupModule,
    PoContainerModule,
    PoDropdownModule,
    PoMenuModule,
    PoMenuPanelModule,
    ProtheusLibCoreModule,
    PoPageDynamicTableModule,
    PoModalModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
