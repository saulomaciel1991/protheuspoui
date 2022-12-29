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
	Local cDataIni := cDataFin := ""
	Local nPosFil := aScan(aParams,{|x| x[1] == "FILIAL"})
	Local nPosMatri := aScan(aParams,{|x| x[1] == "MATRICULA"})
	Local nPosDtIni := aScan(aParams,{|x| x[1] == "DTINICIAL"})
	Local nPosDtFin := aScan(aParams,{|x| x[1] == "DTFINAL"})
	Local dDatAux := CTOD("")

	If nPosFil > 0 .AND. nPosMatri > 0 .AND. nPosDtIni > 0 .AND. nPosDtFin > 0
		cFilFunc := aParams[nPosFil,2]
		cMatricula := aParams[nPosMatri,2]
		cDataIni := aParams[nPosDtIni,2]
		cDataFin := aParams[nPosDtFin,2]
	Else
		Return lRet
	EndIf

	BEGINSQL ALIAS 'TSP8'
		SELECT
			SP8.R_E_C_N_O_, SP8.P8_DATA
		FROM %Table:SP8% AS SP8
		WHERE
			SP8.%NotDel%
			AND SP8.P8_FILIAL = %exp:cFilFunc%
			AND SP8.P8_MAT = %exp:cMatricula%
			AND SP8.P8_DATA BETWEEN %exp:cDataIni% AND %exp:cDataFin%
			ORDER BY SP8.P8_DATA
	ENDSQL

	While !TSP8->(Eof())
		SP8->(DbGoto(TSP8->R_E_C_N_O_))
		Aadd(aDados, JsonObject():new())
		nPos := Len(aDados)
		aDados[nPos]['filial' ] := AllTrim(SP8->P8_FILIAL)
		aDados[nPos]['matricula' ] := AllTrim(SP8->P8_MAT)
		aDados[nPos]['data' ] := ConvertData(AllTrim(TSP8->P8_DATA))
		aDados[nPos]['dia' ] := DiaSemana(STOD(TSP8->P8_DATA))
		aDados[nPos]['centrocusto'] := AllTrim(SP8->P8_CC)
		aDados[nPos]['ordemClassificacao'] := AllTrim(SP8->P8_CC)
		aDados[nPos]['motivoRegistro'] := AllTrim(SP8->P8_MOTIVRG)
		aDados[nPos]['turno'] := AllTrim(SP8->P8_TURNO)
		aDados[nPos]['abono'] := GetAbono(AllTrim(SP8->P8_MAT), SP8->P8_DATA)

		dDatAux := TSP8->P8_DATA
		While dDatAux == TSP8->P8_DATA
			Aadd(aPontos, JsonObject():new())
			nPosPont := Len(aPontos)
			If AllTrim(SP8->P8_TPMARCA) == "1E"
				aDados[nPos]['1E'] := ConvertHora(SP8->P8_HORA)
			EndIf
			If AllTrim(SP8->P8_TPMARCA) == "1S"
				aDados[nPos]['1S'] := ConvertHora(SP8->P8_HORA)
			EndIf
			If AllTrim(SP8->P8_TPMARCA) == "2E"
				aDados[nPos]['2E'] := ConvertHora(SP8->P8_HORA)
			EndIf
			If AllTrim(SP8->P8_TPMARCA) == "2S"
				aDados[nPos]['2S'] := ConvertHora(SP8->P8_HORA)
			EndIf
			If AllTrim(SP8->P8_TPMARCA) == "3E"
				aDados[nPos]['3E'] := ConvertHora(SP8->P8_HORA)
			EndIf
			If AllTrim(SP8->P8_TPMARCA) == "3S"
				aDados[nPos]['3S'] := ConvertHora(SP8->P8_HORA)
			EndIf
			If AllTrim(SP8->P8_TPMARCA) == "4E"
				aDados[nPos]['4E'] := ConvertHora(SP8->P8_HORA)
			EndIf
			If AllTrim(SP8->P8_TPMARCA) == "4S"
				aDados[nPos]['4S'] := ConvertHora(SP8->P8_HORA)
			EndIf

			TSP8->(DbSkip())
		EndDo
	EndDo

	TSP8->(DbCloseArea())

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

Static Function ConvertHora(nHora)
	Local cHora := CValToChar(nHora)

	If Len(cHora) < 5 .AND. SubStr(cHora, 2, 1) == "."
		cHora := "0"+cHora
	ElseIf Len(cHora) < 5 .AND. SubStr(cHora, 3, 1) == "."
		cHora := cHora+"0"
	EndIf
	cHora := STRTRAN(cHora,".",":") + ":00"
Return cHora

Static Function ConvertData(cData)
	Local cDtCorrigida := ""
	Local cAno := SubStr(cData, 1, 4)
	Local cMes := SubStr(cData, 5, 2)
	Local cDia := SubStr(cData, 7, 2)

	cDtCorrigida := cAno+"-"+cMes+"-"+cDia
Return cDtCorrigida

Static Function GetAbono(cMatricula, dDataAbono)
	Local cDescAbono := ""
	Local aAreaSPK := SPK->(GetArea())

	SPK->(DbSetOrder(1))
	If SPK->(MsSeek(xFilial("SPK")+cMatricula+DTOS(dDataAbono)))
		cDescAbono := ALLTRIM(POSICIONE("SP6", 1, xFilial("SP6")+SPK->PK_CODABO, "P6_DESC"))
	EndIf

	SPK->(RestArea(aAreaSPK))
Return cDescAbono
