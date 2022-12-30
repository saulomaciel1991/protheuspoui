#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'

WSRESTFUL marcacoes DESCRIPTION 'Manipulacao de Clientes'
	Self:SetHeader('Access-Control-Allow-Credentials' , "true")

	//Cria��o dos Metodos
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
	Local nPosDtIni := aScan(aParams,{|x| x[1] == "DTINICIAL"})
	Local nPosDtFin := aScan(aParams,{|x| x[1] == "DTFINAL"})
	Local dDatAux := CTOD("")
	Local nMes := 0
	Local cHorasAbonadas := cMotivoAbono := ""
	Local cHoras1T := cHoras2T := cTotalHoras := ""
	Local cTurno := "09:00:00"

	Default cDataIni := cDataFin := "19000101"

	If nPosFil > 0 .AND. nPosMatri > 0
		cFilFunc := aParams[nPosFil,2]
		cMatricula := aParams[nPosMatri,2]
		If nPosDtIni > 0 .AND. nPosDtFin > 0
			cDataIni := aParams[nPosDtIni,2]
			cDataFin := aParams[nPosDtFin,2]
		EndIf
	Else
		Return lRet
	EndIf

	If cDataIni == '19000101'
		nMes := MONTH(Date())-1

		BEGINSQL ALIAS 'TSP8'
		SELECT
			SP8.R_E_C_N_O_, SP8.P8_DATA, SP8.P8_TPMARCA, SP8.P8_FILIAL, SP8.P8_MAT,
			SP8.P8_CC, SP8.P8_MOTIVRG, SP8.P8_TURNO, SP8.P8_HORA
		FROM %Table:SP8% AS SP8
		WHERE
			SP8.%NotDel%
			AND SP8.P8_FILIAL = %exp:cFilFunc%
			AND SP8.P8_MAT = %exp:cMatricula%
			AND MONTH(SP8.P8_DATA) = %exp:nMes%
			ORDER BY SP8.P8_DATA
		ENDSQL
	Else
		BEGINSQL ALIAS 'TSP8'
		SELECT
			SP8.R_E_C_N_O_, SP8.P8_DATA, SP8.P8_TPMARCA, SP8.P8_FILIAL, SP8.P8_MAT,
			SP8.P8_CC, SP8.P8_MOTIVRG, SP8.P8_TURNO, SP8.P8_HORA
		FROM %Table:SP8% AS SP8
		WHERE
			SP8.%NotDel%
			AND SP8.P8_FILIAL = %exp:cFilFunc%
			AND SP8.P8_MAT = %exp:cMatricula%
			AND SP8.P8_DATA BETWEEN %exp:cDataIni% AND %exp:cDataFin%
			ORDER BY SP8.P8_DATA
		ENDSQL
	EndIf

	While !TSP8->(Eof())
		Aadd(aDados, JsonObject():new())
		nPos := Len(aDados)
		GetAbono(AllTrim(TSP8->P8_MAT), TSP8->P8_DATA, @cHorasAbonadas, @cMotivoAbono)
		aDados[nPos]['filial' ] := AllTrim(TSP8->P8_FILIAL)
		aDados[nPos]['matricula' ] := AllTrim(TSP8->P8_MAT)
		aDados[nPos]['data' ] := ConvertData(AllTrim(TSP8->P8_DATA))
		aDados[nPos]['dia' ] := DiaSemana(STOD(TSP8->P8_DATA))
		aDados[nPos]['centrocusto'] := AllTrim(TSP8->P8_CC)
		aDados[nPos]['ordemClassificacao'] := AllTrim(TSP8->P8_CC)
		aDados[nPos]['motivoRegistro'] := AllTrim(TSP8->P8_MOTIVRG)
		aDados[nPos]['turno'] := AllTrim(TSP8->P8_TURNO)
		aDados[nPos]['abono'] := cHorasAbonadas
		aDados[nPos]['observacoes'] := cMotivoAbono

		dDatAux := TSP8->P8_DATA
		While dDatAux == TSP8->P8_DATA
			Aadd(aPontos, JsonObject():new())
			nPosPont := Len(aPontos)
			If AllTrim(TSP8->P8_TPMARCA) == "1E"
				aDados[nPos]['1E'] := ConvertHora(TSP8->P8_HORA)
			EndIf
			If AllTrim(TSP8->P8_TPMARCA) == "1S"
				aDados[nPos]['1S'] := ConvertHora(TSP8->P8_HORA)
			EndIf

			If AllTrim(TSP8->P8_TPMARCA) == "2E"
				aDados[nPos]['2E'] := ConvertHora(TSP8->P8_HORA)
			EndIf
			If AllTrim(TSP8->P8_TPMARCA) == "2S"
				aDados[nPos]['2S'] := ConvertHora(TSP8->P8_HORA)
			EndIf
			If AllTrim(TSP8->P8_TPMARCA) == "3E"
				aDados[nPos]['3E'] := ConvertHora(TSP8->P8_HORA)
			EndIf
			If AllTrim(TSP8->P8_TPMARCA) == "3S"
				aDados[nPos]['3S'] := ConvertHora(TSP8->P8_HORA)
			EndIf
			If AllTrim(TSP8->P8_TPMARCA) == "4E"
				aDados[nPos]['4E'] := ConvertHora(TSP8->P8_HORA)
			EndIf
			If AllTrim(TSP8->P8_TPMARCA) == "4S"
				aDados[nPos]['4S'] := ConvertHora(TSP8->P8_HORA)
			EndIf

			TSP8->(DbSkip())
		EndDo
		cHoras1T := SomaHoras(aDados[nPos]['1E'], aDados[nPos]['1S'])
		cHoras2T := SomaHoras(aDados[nPos]['2E'], aDados[nPos]['2S'])
		cTotalHoras := SomaHoras(cHoras1T, cHoras2T, "S")
		aDados[nPos]['jornada'] := cTotalHoras
		aDados[nPos]['horasExtras'] := SomaHoras(cTurno, cTotalHoras, "E")
		aDados[nPos]['abstencao'] := SomaHoras(cTurno, cTotalHoras, "A")
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

	If Len(cHora) == 1
		cHora := "0"+cHora+".00"
	EndIf

	If Len(cHora) == 2
		cHora := cHora+".00"
	EndIf

	If Len(cHora) == 3
		cHora := "0"+cHora+"0"
	EndIf

	If Len(cHora) == 4
		If SubStr(cHora, 2, 1) == "."
			cHora := "0"+cHora
		Else
			cHora := cHora+"0"
		EndIf
	EndIf

	If Len(cHora) == 5
		cHora := STRTRAN(cHora,".",":") + ":00"
	Else
		cHora := "00:00:00"
	EndIf
Return cHora

Static Function ConvertData(cData)
	Local cDtCorrigida := ""
	Local cAno := SubStr(cData, 1, 4)
	Local cMes := SubStr(cData, 5, 2)
	Local cDia := SubStr(cData, 7, 2)

	cDtCorrigida := cAno+"-"+cMes+"-"+cDia
Return cDtCorrigida

Static Function GetAbono(cMatricula, cDataAbono, cHorasAbonadas, cMotivoAbono)
	Local aAreaSPK := SPK->(GetArea())

	SPK->(DbSetOrder(1))
	If SPK->(MsSeek(xFilial("SPK")+cMatricula+cDataAbono))
		cMotivoAbono := ALLTRIM(POSICIONE("SP6", 1, xFilial("SP6")+SPK->PK_CODABO, "P6_DESC"))
		cHorasAbonadas := ConvertHora(SPK->PK_HRSABO)
	EndIf

	SPK->(RestArea(aAreaSPK))
Return

Static Function SomaHoras(cHoraIni, cHoraFin, cTipo)
	Local cHoraSomada := "00:00"
	Local lHorasValidas := .F.

	Default cTipo := "D"

	If ValType(cHoraIni) == "C" .AND. ValType(cHoraFin) == "C"
		lHorasValidas := .T.
	EndIf

	If cTipo == "D" .AND. lHorasValidas
		inicial := HTOM(cHoraIni)
		final := HTOM(cHoraFin)

		If final > inicial
			cHoraSomada := MTOH(final - inicial)
		Else
			cHoraSomada := "00:00"
		EndIf
	EndIf

	If cTipo == "E" .AND. lHorasValidas
		esperado := HTOM(cHoraIni)
		trabalhado := HTOM(cHoraFin)

		If trabalhado > esperado
			cHoraSomada := MTOH(trabalhado - esperado)
		Else
			cHoraSomada := "00:00"
		EndIf
	EndIf

	If cTipo == "A" .AND. lHorasValidas
		esperado := HTOM(cHoraIni)
		trabalhado := HTOM(cHoraFin)

		If trabalhado < esperado
			cHoraSomada := MTOH(esperado - trabalhado)
		Else
			cHoraSomada := "00:00"
		EndIf
	EndIf

	If cTipo == "S" .AND. lHorasValidas
		nSoma := HTOM(cHoraIni) + HTOM(cHoraFin)
		cHoraSomada := MTOH(nSoma)
	EndIf

Return ConvertHora(cHoraSomada)

Static Function HTOM(cHora)
	Local nMinutos := 0
	Local nHo := Val(SUBSTR(cHora,1,2))
	Local nMi := Val(SUBSTR(cHora,4,2))

	nMinutos := (nHo * 60) + nMi

Return nMinutos

Static Function MTOH(nMinutos)
	Local nResto := 0

	nResto := Mod(nMinutos, 60)
	nMinutos -= nResto
	nMinutos /= 60
	nMinutos += (nResto / 100)

Return nMinutos
