#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'

WSRESTFUL pedidos DESCRIPTION 'Manipulacao de pedidos'

	//Criação dos Metodos
	WSMETHOD GET DESCRIPTION 'Listar todos os pedidos' WSSYNTAX '/pedidos' PATH '/'

END WSRESTFUL

//Declaração dos Metodos
WSMETHOD GET WSSERVICE pedidos
	Local aAreaSC5 := SC5->(GetArea())
	Local cResponse := JsonObject():New()
	Local lRet := .T.
	Local aDados := {}

	SC5->(DbSetOrder(1))
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
		SC5->(DbSkip())
	EndDo

	cResponse['items'] := aDados
	cResponse['hasNext'] := .F.

	Self:SetContentType('application/json')
	Self:SetResponse(EncodeUTF8(cResponse:toJson()))
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
