#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'

WSRESTFUL naturezas DESCRIPTION 'Manipulacao de Clientes'
	Self:SetHeader('Access-Control-Allow-Credentials' , "true")

	//Criação dos Metodos
	WSMETHOD GET DESCRIPTION 'Listar todas as naturezas' WSSYNTAX '/naturezas' PATH '/'

END WSRESTFUL

WSMETHOD GET WSSERVICE naturezas
	Local aAreaSED := SED->(GetArea())
	Local cResponse := JsonObject():New()
	Local lRet := .T.
	Local aDados := {}
	
	SED->(DbSetOrder(1))
	SED->(DbGoTop())

	While !SED->(Eof())
		Aadd(aDados, JsonObject():new())
		nPos := Len(aDados)
		aDados[nPos]['codigo' ] := AllTrim(SED->ED_CODIGO)
		aDados[nPos]['descricao' ] := AllTrim(SED->ED_DESCRIC)
	
		SED->(DbSkip())
	EndDo

	cResponse['items'] := aDados
	cResponse['hasNext'] := .F.

	Self:SetContentType('application/json')
	Self:SetResponse(EncodeUTF8(cResponse:toJson()))
	SED->(RestArea(aAreaSED))
Return lRet
