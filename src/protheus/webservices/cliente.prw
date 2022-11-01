#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'

WSRESTFUL clientes DESCRIPTION 'Manipulacao de Clientes'
	Self:SetHeader('Access-Control-Allow-Credentials' , "true")

	// WSDATA numero AS STRING

	//Criação dos Metodos
	WSMETHOD GET DESCRIPTION 'Listar todos os Clientes' WSSYNTAX '/clientes' PATH '/'
	// WSMETHOD GET numero DESCRIPTION 'Buscar pedido selecionado' WSSYNTAX '/pedidos/{numero}' PATH '/pedidos/{numero}'
	// WSMETHOD POST DESCRIPTION 'Incluir novo pedido' WSSYNTAX '/pedidos' PATH '/'
	// WSMETHOD PUT DESCRIPTION 'Alterar pedido selecionado' WSSYNTAX '/pedidos' PATH '/'
	// WSMETHOD DELETE DESCRIPTION 'Deletar pedido selecionado via body' WSSYNTAX '/pedidos' PATH '/pedidos'
	// WSMETHOD DELETE numero DESCRIPTION 'Deletar pedido selecionado via body' WSSYNTAX '/pedidos/{numero}' PATH '/pedidos/{numero}'

END WSRESTFUL

WSMETHOD GET WSSERVICE clientes
	Local aAreaSA1 := SA1->(GetArea())
	Local cResponse := JsonObject():New()
	Local lRet := .T.
	Local aDados := {}
	
	SA1->(DbSetOrder(1))
	SA1->(DbGoTop())

	While !SA1->(Eof())
		Aadd(aDados, JsonObject():new())
		nPos := Len(aDados)
		aDados[nPos]['codigo' ] := AllTrim(SA1->A1_COD)
		aDados[nPos]['loja' ] := AllTrim(SA1->A1_LOJA)
		aDados[nPos]['nome' ] := AllTrim(SA1->A1_NOME)
		aDados[nPos]['cgc' ] := AllTrim(SA1->A1_CGC)
		
		SA1->(DbSkip())
	EndDo

	cResponse['items'] := aDados
	cResponse['hasNext'] := .F.

	Self:SetContentType('application/json')
	Self:SetResponse(EncodeUTF8(cResponse:toJson()))
	SA1->(RestArea(aAreaSA1))
Return lRet
