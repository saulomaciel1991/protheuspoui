#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'

WSRESTFUL pedidos DESCRIPTION 'Manipulacao de pedidos'
	Self:SetHeader('Access-Control-Allow-Credentials' , "true")

	WSDATA numero AS STRING

	//Criação dos Metodos
	WSMETHOD GET DESCRIPTION 'Listar todos os pedidos' WSSYNTAX '/pedidos' PATH '/'
	WSMETHOD GET numero DESCRIPTION 'Buscar pedido selecionado' WSSYNTAX '/pedidos/{numero}' PATH '/pedidos/{numero}'
	WSMETHOD POST DESCRIPTION 'Incluir novo pedido' WSSYNTAX '/pedidos' PATH '/'
	WSMETHOD PUT DESCRIPTION 'Alterar pedido selecionado' WSSYNTAX '/pedidos' PATH '/'
	WSMETHOD DELETE DESCRIPTION 'Deletar pedido selecionado via body' WSSYNTAX '/pedidos' PATH '/pedidos'
	WSMETHOD DELETE numero DESCRIPTION 'Deletar pedido selecionado via body' WSSYNTAX '/pedidos/{numero}' PATH '/pedidos/{numero}'

END WSRESTFUL

//Declaração dos Metodos
WSMETHOD GET WSSERVICE pedidos
	Local aAreaSC5 := SC5->(GetArea())
	Local cResponse := JsonObject():New()
	Local lRet := .T.
	Local aDados := {}
	Local aItens := {}

	SC5->(DbSetOrder(1))
	SC5->(DbGoTop())

	While !SC5->(Eof())
		Aadd(aDados, JsonObject():new())
		nPos := Len(aDados)
		aDados[nPos]['numero' ] := AllTrim(SC5->C5_NUM)
		aDados[nPos]['cliente' ] := AllTrim(SC5->C5_CLIENTE)
		aDados[nPos]['loja' ] := AllTrim(SC5->C5_LOJACLI)
		aDados[nPos]['nomeCliente' ] := AllTrim(SC5->C5_XNOME)
		aDados[nPos]['status' ] := GetStatus(AllTrim(SC5->C5_NUM), AllTrim(SC5->C5_NOTA))
		aDados[nPos]['tipoPed' ] := AllTrim(SC5->C5_TIPO)
		aDados[nPos]['condPagto' ] := AllTrim(SC5->C5_CONDPAG)
		aDados[nPos]['natureza' ] := AllTrim(SC5->C5_NATUREZ)

		SC6->(DbSetOrder(1))
		If SC6->(MsSeek(xFilial("SC6")+SC5->C5_NUM))
			While !SC6->(Eof()) .AND. SC5->C5_NUM == SC6->C6_NUM
				Aadd(aItens, JsonObject():new())
				nPosIT := Len(aItens)
				aItens[nPosIT]['item' ] := AllTrim(SC6->C6_ITEM)
				aItens[nPosIT]['produto' ] := AllTrim(SC6->C6_PRODUTO)
				aItens[nPosIT]['qtd' ] := SC6->C6_QTDVEN
				aItens[nPosIT]['preco_unitario' ] := SC6->C6_PRCVEN
				aItens[nPosIT]['preco_total' ] := SC6->C6_VALOR
				aItens[nPosIT]['TES' ] := AllTrim(SC6->C6_TES)
				SC6->(DbSkip())
			EndDo
		EndIf

		aDados[nPos]['itens' ] := aItens
		aItens := {}
		SC5->(DbSkip())
	EndDo

	cResponse['items'] := aDados
	cResponse['hasNext'] := .F.

	Self:SetContentType('application/json')
	Self:SetResponse(EncodeUTF8(cResponse:toJson()))
	SC5->(RestArea(aAreaSC5))
Return lRet

WSMETHOD GET numero WSSERVICE pedidos
	Local aAreaSC5 := SC5->(GetArea())
	Local cResponse := JsonObject():New()
	Local lRet := .T.
	Local aDados := {}
	Local aItens := {}
	Local aUrlParams := Self:aUrlParms
	Local cId := aUrlParams[1]

	SC5->(DbSetOrder(1))
	If SC5->(MsSeek(xFilial("SC5")+cId))
		While !SC5->(Eof()) .AND. SC5->C5_NUM == cId
			Aadd(aDados, JsonObject():new())
			nPos := Len(aDados)
			aDados[nPos]['numero' ] := AllTrim(SC5->C5_NUM)
			aDados[nPos]['cliente' ] := AllTrim(SC5->C5_CLIENTE)
			aDados[nPos]['loja' ] := AllTrim(SC5->C5_LOJACLI)
			aDados[nPos]['nomeCliente' ] := AllTrim(SC5->C5_XNOME)
			aDados[nPos]['status' ] := GetStatus(AllTrim(SC5->C5_NUM), AllTrim(SC5->C5_NOTA))
			aDados[nPos]['tipoPed' ] := AllTrim(SC5->C5_TIPO)
			aDados[nPos]['condPagto' ] := AllTrim(SC5->C5_CONDPAG)
			aDados[nPos]['natureza' ] := AllTrim(SC5->C5_NATUREZ)

			SC6->(DbSetOrder(1))
			If SC6->(MsSeek(xFilial("SC6")+SC5->C5_NUM))
				While !SC6->(Eof()) .AND. SC5->C5_NUM == SC6->C6_NUM
					Aadd(aItens, JsonObject():new())
					nPosIT := Len(aItens)
					aItens[nPosIT]['item' ] := AllTrim(SC6->C6_ITEM)
					aItens[nPosIT]['produto' ] := AllTrim(SC6->C6_PRODUTO)
					aItens[nPosIT]['qtd' ] := SC6->C6_QTDVEN
					aItens[nPosIT]['preco_unitario' ] := SC6->C6_PRCVEN
					aItens[nPosIT]['preco_total' ] := SC6->C6_VALOR
					aItens[nPosIT]['TES' ] := AllTrim(SC6->C6_TES)
					SC6->(DbSkip())
				EndDo
			EndIf

			aDados[nPos]['itens' ] := aItens
			aItens := {}
			SC5->(DbSkip())
		EndDo

		cResponse:set(aDados)

		Self:SetContentType('application/json')
		Self:SetResponse(EncodeUTF8(cResponse:toJson()))
	EndIf
	SC5->(RestArea(aAreaSC5))
Return lRet

WSMETHOD POST WSSERVICE pedidos
	Local xContent := Self:getContent()
	Local lRet := .T.
	Local oResponse := JsonObject():New()
	Local oPedido := JsonObject():New()
	Local lErro := .F.
	Local aErro := {}

	// Parse do conteudo da requisicao.
	cError := oPedido:fromJson(xContent)

	// Valida erros no parse.
	if !Empty(cError)
		SetRestFault(400, cError)
		lRet := .F.
		return lRet
	endif

	aErro := U_A_MATA410(oPedido)
	lErro := aErro[1]

	If lErro
		oResponse ['message'] := aErro[2]
	Else
		oResponse ['message'] := "Processado com sucesso!"
	EndIf

	// Define o tipo de retorno do método.
	Self:SetContentType( 'application/json' )

	// Define a resposta.
	Self:SetResponse(EncodeUTF8(oResponse:toJson()))
Return lRet

WSMETHOD PUT WSSERVICE pedidos
	Local xContent := Self:getContent()
	Local lRet := .T.
	Local oResponse := JsonObject():New()
	Local oPedido := JsonObject():New()
	Local lErro := .F.
	Local aErro := {}

	// Parse do conteudo da requisicao.
	cError := oPedido:fromJson(xContent)

	// Valida erros no parse.
	if !Empty(cError)
		SetRestFault(400, cError)
		lRet := .F.
		return lRet
	endif

	aErro := U_A_MATA410(oPedido)
	lErro := aErro[1]

	If lErro
		oResponse ['message'] := aErro[2]
	Else
		oResponse ['message'] := "Processado com sucesso!"
	EndIf

	// Define o tipo de retorno do método.
	Self:SetContentType( 'application/json' )

	// Define a resposta.
	Self:SetResponse(EncodeUTF8(oResponse:toJson()))
Return lRet

WSMETHOD DELETE WSSERVICE pedidos
	Local xContent := Self:getContent()
	Local lRet := .T.
	Local oResponse := JsonObject():New()
	Local oPedido := JsonObject():New()
	Local lErro := .F.
	Local aErro := {}

	// Parse do conteudo da requisicao.
	cError := oPedido:fromJson(xContent)

	// Valida erros no parse.
	if !Empty(cError)
		SetRestFault(400, cError)
		lRet := .F.
		return lRet
	endif

	aErro := U_A_MATA410(oPedido)
	lErro := aErro[1]

	If lErro
		oResponse ['message'] := aErro[2]
		SetRestFault(400, aErro[2])
		lRet := .F.
	Else
		oResponse ['message'] := "Processado com sucesso!"
	EndIf

	// Define o tipo de retorno do método.
	Self:SetContentType( 'application/json' )

	// Define a resposta.
	Self:SetResponse(EncodeUTF8(oResponse:toJson()))
Return lRet

WSMETHOD DELETE numero WSSERVICE pedidos
	Local aAreaSC5 := SC5->(GetArea())
	Local cResponse := JsonObject():New()
	Local lRet := .T.
	Local aDados := {}
	Local aItens := {}
	Local aUrlParams := Self:aUrlParms
	Local cId := aUrlParams[1]

	SC5->(DbSetOrder(1))
	If SC5->(MsSeek(xFilial("SC5")+cId))
		While !SC5->(Eof()) .AND. SC5->C5_NUM == cId
			Aadd(aDados, JsonObject():new())
			nPos := Len(aDados)
			aDados[nPos]['numero' ] := AllTrim(SC5->C5_NUM)
			aDados[nPos]['cliente' ] := AllTrim(SC5->C5_CLIENTE)
			aDados[nPos]['loja' ] := AllTrim(SC5->C5_LOJACLI)
			aDados[nPos]['nomeCliente' ] := AllTrim(SC5->C5_XNOME)
			aDados[nPos]['status' ] := GetStatus(AllTrim(SC5->C5_NUM), AllTrim(SC5->C5_NOTA))
			aDados[nPos]['tipoPed' ] := AllTrim(SC5->C5_TIPO)
			aDados[nPos]['condPagto' ] := AllTrim(SC5->C5_CONDPAG)
			aDados[nPos]['natureza' ] := AllTrim(SC5->C5_NATUREZ)
			aDados[nPos]['operacao' ] := 5

			SC6->(DbSetOrder(1))
			If SC6->(MsSeek(xFilial("SC6")+SC5->C5_NUM))
				While !SC6->(Eof()) .AND. SC5->C5_NUM == SC6->C6_NUM
					Aadd(aItens, JsonObject():new())
					nPosIT := Len(aItens)
					aItens[nPosIT]['item' ] := AllTrim(SC6->C6_ITEM)
					aItens[nPosIT]['produto' ] := AllTrim(SC6->C6_PRODUTO)
					aItens[nPosIT]['qtd' ] := SC6->C6_QTDVEN
					aItens[nPosIT]['preco_unitario' ] := SC6->C6_PRCVEN
					aItens[nPosIT]['preco_total' ] := SC6->C6_VALOR
					aItens[nPosIT]['TES' ] := AllTrim(SC6->C6_TES)
					SC6->(DbSkip())
				EndDo
			EndIf

			aDados[nPos]['itens' ] := aItens
			aItens := {}
			SC5->(DbSkip())
		EndDo

		If Len(aDados) == 1
			aErro := U_A_MATA410(aDados[1])
			lErro := aErro[1]
		Else
			lErro := .F.
		EndIf

		If lErro
			cResponse ['message'] := aErro[2]
			SetRestFault(400, aErro[2])
			lRet := .F.
		Else
			cResponse ['message'] := "Processado com sucesso!"
		EndIf

		Self:SetContentType('application/json')
		Self:SetResponse(EncodeUTF8(cResponse:toJson()))
	EndIf
	SC5->(RestArea(aAreaSC5))
Return lRet

Static Function GetStatus(cNum, cNota)
	Local cStatus := ""
	Local aArea := GetArea()
	Local aAreaSC6 := SC6->(GetArea())
	Local nSomaQtd := 0
	Local nSomaLib := 0
	Local nSomaEnt := 0

	SC6->(DbSetOrder(1))
	If SC6->(MsSeek(xFilial("SC6")+cNum))
		While !SC6->(Eof()) .AND. ALLTRIM(SC6->C6_NUM) == cNum
			nSomaQtd += SC6->C6_QTDVEN
			nSomaEnt += SC6->C6_QTDENT
			SC6->(DbSkip())
		EndDo
	EndIf

	SC9->(DbSetOrder(1))
	If SC9->(MsSeek(xFilial("SC9")+cNum))
		While !SC9->(Eof()) .AND. ALLTRIM(SC9->C9_PEDIDO) == cNum
			nSomaLib += SC9->C9_QTDLIB
			SC9->(DbSkip())
		EndDo
	EndIf

	If nSomaQtd == nSomaLib .AND. nSomaEnt < nSomaQtd
		cStatus := "L"
	Else
		If nSomaEnt == nSomaQtd .OR. cNota == 'XXXXXXXXX'
			cStatus := "E"
		Else
			cStatus := "A"
		EndIf
	EndIf

	RestArea(aArea)
	SC6->(RestArea(aAreaSC6))
Return cStatus
