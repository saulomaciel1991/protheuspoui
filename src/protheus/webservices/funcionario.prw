#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'

WSRESTFUL funcionarios DESCRIPTION 'Manipula��o de funcionarios'
	Self:SetHeader('Access-Control-Allow-Credentials' , "true")

	//Cria��o dos Metodos
	WSMETHOD GET DESCRIPTION 'Buscar funcionario pela matricula' WSSYNTAX '/funcionarios/' ;
		PATH '/funcionarios/'

END WSRESTFUL

WSMETHOD GET WSSERVICE funcionarios
	Local cResponse := JsonObject():New()
	Local lRet := .T.
	Local aDados := {}
	//Local aUrlParams := Self:aUrlParms
	Local aParams := Self:AQueryString
	Local nPosId := aScan(aParams,{|x| x[1] == "CPF"})
	//Local cId := aUrlParams[1]

	If nPosId > 0
		cCpf := aParams[nPosId,2]
	EndIf
	aDados := getArrFun(cvaltochar(cCpf))

	If Len(aDados) == 0		//SetRestFault(204, "Nenhum registro encontrado!")
		cResponse['code'] := 204
		cResponse['message'] := 'Funcion�rio n�o encontrado'
		lRet := .F.
	Else
		//cResponse:set(aDados)
		cResponse['user'] := aDados
	EndIf

	Self:SetContentType('application/json')
	Self:SetResponse(EncodeUTF8(cResponse:toJson()))
Return lRet

Static Function getArrFun(cId)
	Local aArea := GetArea()
	Local aAreaSRA := SRA->(GetArea())
	Local aDados := {}
	Local nSRAreg := 0


	BEGINSQL ALIAS 'TSRA'
		SELECT
			SRA.R_E_C_N_O_
		FROM %Table:SRA% AS SRA
		WHERE
			SRA.%NotDel% AND
			SRA.RA_CIC = %exp:cId% AND
			SRA.RA_SITFOLH = ''
	ENDSQL

	If !TSRA->(Eof())
		nSRAreg := TSRA->R_E_C_N_O_
	EndIf
	TSRA->(DbCloseArea())

	SRA->(DbGoto(nSRAreg))
	While !SRA->(Eof()) .AND. SRA->RA_CIC == cId .AND. AllTrim(SRA->RA_SITFOLH ) == ''
		Aadd(aDados, JsonObject():new())
		nPos := Len(aDados)
		aDados[nPos]['matricula' ] := AllTrim(SRA->RA_MAT)
		aDados[nPos]['nome' ] := AllTrim(SRA->RA_NOME)
		aDados[nPos]['admissao' ] := (SRA->RA_ADMISSA)
		aDados[nPos]['funcao' ] := ALLTRIM(POSICIONE("SRJ", 1, xFilial("SRJ")+SRA->RA_CODFUNC, "RJ_DESC"))
		aDados[nPos]['cc' ] := AllTrim(SRA->RA_CC)
		aDados[nPos]['cpf' ] := AllTrim(SRA->RA_CIC )
		aDados[nPos]['categoria' ] := AllTrim(SRA->RA_CATFUNC )
		aDados[nPos]['situacao' ] := 'NORMAL'
		aDados[nPos]['departamento' ] := ALLTRIM(POSICIONE("SQB", 1, xFilial("SQB")+SRA->RA_DEPTO, "QB_DESCRIC"))
		
		SRA->(DbSkip())
	EndDo

	RestArea(aArea)
	SRA->(RestArea(aAreaSRA))
Return aDados
