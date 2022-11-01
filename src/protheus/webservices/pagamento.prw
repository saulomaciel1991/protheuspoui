#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'

WSRESTFUL pagamentos DESCRIPTION 'Manipulacao de Clientes'
	Self:SetHeader('Access-Control-Allow-Credentials' , "true")

	//Criação dos Metodos
	WSMETHOD GET DESCRIPTION 'Listar todas as condicoes de pagamento' WSSYNTAX '/pagamentos' PATH '/'

END WSRESTFUL

WSMETHOD GET WSSERVICE pagamentos
	Local aAreaSE4 := SE4->(GetArea())
	Local cResponse := JsonObject():New()
	Local lRet := .T.
	Local aDados := {}
	
	SE4->(DbSetOrder(1))
	SE4->(DbGoTop())

	While !SE4->(Eof())
		Aadd(aDados, JsonObject():new())
		nPos := Len(aDados)
		aDados[nPos]['codigo' ] := AllTrim(SE4->E4_CODIGO)
		aDados[nPos]['descricao' ] := AllTrim(SE4->E4_DESCRI)
	
		SE4->(DbSkip())
	EndDo

	cResponse['items'] := aDados
	cResponse['hasNext'] := .F.

	Self:SetContentType('application/json')
	Self:SetResponse(EncodeUTF8(cResponse:toJson()))
	SE4->(RestArea(aAreaSE4))
Return lRet
