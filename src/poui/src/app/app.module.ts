import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { AppRoutingModule } from './app-routing.module';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { RouterModule } from '@angular/router';


// import { ProtheusLibCoreModule } from '@totvs/protheus-lib-core';

//po-ui components
import { PoTemplatesModule } from '@po-ui/ng-templates';
import { PoModule } from '@po-ui/ng-components';
import { PoModalModule } from '@po-ui/ng-components';
import { PoButtonGroupModule, PoButtonModule, PoContainerModule, PoDropdownModule, PoMenuModule, PoMenuPanelModule, PoNavbarModule, PoTableModule, PoToolbarModule } from '@po-ui/ng-components';
import { PoPageDynamicTableModule, PoPageDynamicEditModule } from '@po-ui/ng-templates';


//Components
import { TabelaPedidosComponent } from './tabela-pedidos/tabela-pedidos.component';
import { AppComponent } from './app.component';
import { NovoPedidoComponent } from './pedidos/novo-pedido/novo-pedido.component';

@NgModule({
  declarations: [
    AppComponent,
    TabelaPedidosComponent,
    NovoPedidoComponent
  ],
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    PoModule,
    RouterModule.forRoot([]),
    AppRoutingModule,
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
    // ProtheusLibCoreModule,
    PoPageDynamicTableModule,
    PoPageDynamicEditModule,
    PoModalModule,
    
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
