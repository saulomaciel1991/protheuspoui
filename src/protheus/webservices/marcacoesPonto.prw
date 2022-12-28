#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'

WSRESTFUL marcacoes DESCRIPTION 'Manipulacao de Clientes'
	Self:SetHeader('Access-Control-Allow-Credentials' , "true")

	//Criação dos Metodos
	WSMETHOD GET DESCRIPTION 'Listar todas as marcacoes de uma matricula' WSSYNTAX '/marcacoes' PATH '/'

END WSRESTFUL

WSMETHOD GET WSSERVICE marcacoes
	//http://192.168.41.60:8090/rest/marcacoes/?filial=1201&matricula=000028
	//http://localhost:8090/rest/marcacoes/?filial=1201&matricula=000028

	Local aArea := GetArea()
	Local aAreaSP8 := SP8->(GetArea())
	Local cResponse := JsonObject():New()
	Local lRet := .T.
	Local aDados := {}
	Local aPontos := {}
	Local aParams := Self:AQueryString
	Local cFilFunc := ""
	Local cMatricula := ""
	Local nPosFil := aScan(aParams,{|x| x[1] == "FILIAL"})
	Local nPosMatri := aScan(aParams,{|x| x[1] == "MATRICULA"})
	Local dDatAux := CTOD("")

	If nPosFil > 0 .AND. nPosMatri > 0
		cFilFunc := aParams[nPosFil,2]
		cMatricula := aParams[nPosMatri,2]
	Else
		Return lRet
	EndIf

	SP8->(DbSetOrder(1))
	SP8->(MsSeek(cFilFunc+cMatricula))
	While !SP8->(Eof()) .AND. (ALLTRIM(SP8->P8_FILIAL)+ALLTRIM(SP8->P8_MAT) == cFilFunc + cMatricula) .AND. Empty(SP8->P8_TPMCREP)
		Aadd(aDados, JsonObject():new())
		nPos := Len(aDados)
		aDados[nPos]['filial' ] := AllTrim(SP8->P8_FILIAL)
		aDados[nPos]['matricula' ] := AllTrim(SP8->P8_MAT)
		aDados[nPos]['data' ] := AllTrim(DTOC(SP8->P8_DATA))
		aDados[nPos]['dia' ] := ALLTRIM(DiaSemana(SP8->P8_DATA))
		aDados[nPos]['centrocusto'] := AllTrim(SP8->P8_CC)
		aDados[nPos]['ordemClassificacao'] := AllTrim(SP8->P8_CC)
		aDados[nPos]['motivoRegistro'] := AllTrim(SP8->P8_MOTIVRG)
		aDados[nPos]['turno'] := AllTrim(SP8->P8_TURNO)

		dDatAux := DTOC(SP8->P8_DATA)
		While dDatAux == DTOC(SP8->P8_DATA)
			Aadd(aPontos, JsonObject():new())
			nPosPont := Len(aPontos)
			aPontos[nPosPont]['hora' ] := SP8->P8_HORA
			aPontos[nPosPont]['tipoMarcacao'] := AllTrim(SP8->P8_TPMARCA)
			SP8->(DbSkip())
		EndDo
		aDados[nPos]['pontos'] := aPontos
		aPontos := {}
	EndDo

	If Len(aDados) == 0
		SetRestFault(204, "Nenhum registro encontrado!")
		lRet := .F.
	Else
		cResponse['marcacoes'] := aDados
		cResponse['hasContent'] := .T.
	EndIf

	Self:SetContentType('application/json')
	Self:SetResponse(EncodeUTF8(cResponse:toJson()))

	SP8->(RestArea(aAreaSP8))
	RestArea(aArea)
Return lRet
