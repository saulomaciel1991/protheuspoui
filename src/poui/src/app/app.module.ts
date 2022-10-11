import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppComponent } from './app.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { PoModule } from '@po-ui/ng-components';
import { RouterModule } from '@angular/router';
import { PoTemplatesModule } from '@po-ui/ng-templates';
import { PoPageDynamicTableModule } from '@po-ui/ng-templates';
import { AppRoutingModule } from './app-routing.module';

//Components
import { TabelaPedidosComponent } from './tabela-pedidos/tabela-pedidos.component';

//po-ui components
import { PoNavbarModule } from '@po-ui/ng-components';
import { PoToolbarModule } from '@po-ui/ng-components';
import { PoTableModule } from '@po-ui/ng-components';
import { PoButtonModule } from '@po-ui/ng-components';
import { PoButtonGroupModule } from '@po-ui/ng-components';
import { PoContainerModule } from '@po-ui/ng-components';
import { PoDropdownModule } from '@po-ui/ng-components';
import { PoMenuModule } from '@po-ui/ng-components';
import { PoMenuPanelModule } from '@po-ui/ng-components';
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
    PoPageDynamicTableModule,
    AppRoutingModule,
    PoModalModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
