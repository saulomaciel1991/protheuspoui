#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'

WSRESTFUL funcionarios DESCRIPTION 'Manipulação de funcionarios'
	Self:SetHeader('Access-Control-Allow-Credentials' , "true")

	//Criação dos Metodos
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
		cResponse['message'] := 'Funcionário não encontrado'
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

	SRA->(DbSetOrder(5))  //RA_FILIAL + RA_CIC 	CPF
	If SRA->(MsSeek(xFilial("SRA")+cId))
		While !SRA->(Eof()) .AND. SRA->RA_CIC == cId .AND. AllTrim(SRA->RA_SITFOLH ) == ''
			Aadd(aDados, JsonObject():new())
			nPos := Len(aDados)
			aDados[nPos]['matricula' ] := AllTrim(SRA->RA_MAT)
			aDados[nPos]['nome' ] := AllTrim(SRA->RA_NOME)
			aDados[nPos]['admissao' ] := (SRA->RA_ADMISSA)
			//aDados[nPos]['funcao' ] := AllTrim(SRA->RA_DESCFUN)
			aDados[nPos]['cc' ] := AllTrim(SRA->RA_CC)
			aDados[nPos]['cpf' ] := AllTrim(SRA->RA_CIC )
			aDados[nPos]['categoria' ] := AllTrim(SRA->RA_CATFUNC )
			aDados[nPos]['situacao' ] := 'NORMAL'

			SRA->(DbSkip())
		EndDo
	EndIf

	RestArea(aArea)
	SRA->(RestArea(aAreaSRA))
Return aDados
