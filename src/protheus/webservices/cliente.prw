#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'

WSRESTFUL clientes DESCRIPTION 'Manipulacao de Clientes'
	Self:SetHeader('Access-Control-Allow-Credentials' , "true")

	// WSDATA numero AS STRING

	//Criação dos Metodos
	WSMETHOD GET DESCRIPTION 'Listar todos os Clientes' WSSYNTAX '/clientes' PATH '/'
	WSMETHOD GET numero DESCRIPTION 'Buscar pedido selecionado' WSSYNTAX '/clientes/{numero}' PATH '/clientes/{numero}'
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

WSMETHOD GET numero WSSERVICE clientes
	Local cResponse := JsonObject():New()
	Local lRet := .T.
	Local aDados := {}
	Local aUrlParams := Self:aUrlParms
	Local cId := aUrlParams[1]

	aDados := getArrCli(cId)
	If Len(aDados) == 0
		SetRestFault(204, "Nenhum registro encontrado!")
		lRet := .F.
	Else
		cResponse:set(aDados)
	EndIf

	Self:SetContentType('application/json')
	Self:SetResponse(EncodeUTF8(cResponse:toJson()))
Return lRet

Static Function getArrCli(cId)
	Local aArea := GetArea()
	Local aAreaSA1 := SA1->(GetArea())
	Local aDados := {}

	SA1->(DbSetOrder(1))
	If SA1->(MsSeek(xFilial("SA1")+cId))
		While !SA1->(Eof()) .AND. SA1->A1_COD == cId
			Aadd(aDados, JsonObject():new())
			nPos := Len(aDados)
			aDados[nPos]['codigo' ] := AllTrim(SA1->A1_COD)
			aDados[nPos]['loja' ] := AllTrim(SA1->A1_LOJA)
			aDados[nPos]['nome' ] := AllTrim(SA1->A1_NOME)
			aDados[nPos]['cgc' ] := AllTrim(SA1->A1_CGC)
			// aDados[nPos]['operacao' ] := 1

			SA1->(DbSkip())
		EndDo
	EndIf

	RestArea(aArea)
	SA1->(RestArea(aAreaSA1))
Return aDados
