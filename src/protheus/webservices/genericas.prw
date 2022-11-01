#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'

WSRESTFUL sx5 DESCRIPTION 'Manipulacao de Clientes'
	Self:SetHeader('Access-Control-Allow-Credentials' , "true")

	// WSDATA numero AS STRING

	//Criação dos Metodos
	WSMETHOD GET tabela DESCRIPTION 'Listar todos os Clientes' WSSYNTAX '/sx5/{tabela}' PATH '/sx5/{tabela}'
	// WSMETHOD GET numero DESCRIPTION 'Buscar pedido selecionado' WSSYNTAX '/pedidos/{numero}' PATH '/pedidos/{numero}'
	// WSMETHOD POST DESCRIPTION 'Incluir novo pedido' WSSYNTAX '/pedidos' PATH '/'
	// WSMETHOD PUT DESCRIPTION 'Alterar pedido selecionado' WSSYNTAX '/pedidos' PATH '/'
	// WSMETHOD DELETE DESCRIPTION 'Deletar pedido selecionado via body' WSSYNTAX '/pedidos' PATH '/pedidos'
	// WSMETHOD DELETE numero DESCRIPTION 'Deletar pedido selecionado via body' WSSYNTAX '/pedidos/{numero}' PATH '/pedidos/{numero}'

END WSRESTFUL

WSMETHOD GET tabela WSSERVICE sx5
	Local aAreaSX5 := SX5->(GetArea())
	Local cResponse := JsonObject():New()
	Local lRet := .T.
	Local aDados := {}
	Local aUrlParams := Self:aUrlParms
	Local cTabela := Upper(AllTrim(aUrlParams[1]))

	SX5->(DbSetOrder(1))
	SX5->(DbGoTop())

	If SX5->(MsSeek(xFilial("SX5")+cTabela))
		While !SX5->(Eof()) .AND. SX5->X5_TABELA == cTabela
			Aadd(aDados, JsonObject():new())
			nPos := Len(aDados)
			aDados[nPos]['tabela' ] := AllTrim(SX5->X5_TABELA)
			aDados[nPos]['chave' ] := AllTrim(SX5->X5_CHAVE)
			aDados[nPos]['descricao' ] := AllTrim(SX5->X5_DESCRI)
			aDados[nPos]['desc_spanish' ] := AllTrim(SX5->X5_DESCSPA)
			aDados[nPos]['desc_english' ] := AllTrim(SX5->X5_DESCENG)

			SX5->(DbSkip())
		EndDo
		cResponse['items'] := aDados
		cResponse['hasNext'] := .F.
	Else
		SetRestFault(204, "Nenhum registro encontrado!")
		lRet := .F.
	EndIf


	Self:SetContentType('application/json')
	Self:SetResponse(EncodeUTF8(cResponse:toJson()))
	SX5->(RestArea(aAreaSX5))
Return lRet
