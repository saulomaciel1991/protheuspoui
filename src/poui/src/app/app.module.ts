import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { RouterModule } from '@angular/router';
import { AppRoutingModule } from './app-routing.module';
//import { HttpClientModule } from '@angular/common/http';


// import { ProtheusLibCoreModule } from '@totvs/protheus-lib-core';

//po-ui components
import { PoGridModule, PoButtonGroupModule, PoButtonModule, PoContainerModule, PoDropdownModule, PoMenuModule, PoMenuPanelModule, PoModalModule, PoModule, PoNavbarModule, PoTableModule, PoToolbarModule } from '@po-ui/ng-components';
import { PoPageDynamicEditModule, PoPageDynamicTableModule, PoTemplatesModule } from '@po-ui/ng-templates';


//Components
import { AppComponent } from './app.component';
import { NovoPedidoComponent } from './pedidos/novo-pedido/novo-pedido.component';
import { TabelaPedidosComponent } from './pedidos/tabela-pedidos/tabela-pedidos.component';
import { ItensPedidoComponent } from './pedidos/itens-pedido/itens-pedido.component';

@NgModule({
  declarations: [
    AppComponent,
    TabelaPedidosComponent,
    NovoPedidoComponent,
    ItensPedidoComponent
  ],
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    PoModule,
    RouterModule.forRoot([]),
    AppRoutingModule,
    //HttpClientModule,
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
    PoGridModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
