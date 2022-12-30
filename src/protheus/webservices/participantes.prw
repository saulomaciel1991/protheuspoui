#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'

WSRESTFUL participantes DESCRIPTION 'Manipulacao de Clientes'
	Self:SetHeader('Access-Control-Allow-Credentials' , "true")

	//Criação dos Metodos
	WSMETHOD GET DESCRIPTION 'Listar todos os Participantes' WSSYNTAX '/participantes' PATH '/'
	WSMETHOD PUT DESCRIPTION 'Alterar senha do participante selecionado' WSSYNTAX '/pedidos' PATH '/'

END WSRESTFUL

WSMETHOD GET WSSERVICE participantes
	//http://192.168.41.60:8090/rest/participantes/?cpf=00976379473&senha=123456

	Local aAreaRD0 := RD0->(GetArea())
	Local cResponse := JsonObject():New()
	Local lRet := .T.
	Local aParams := Self:AQueryString
	Local cCpf := ""
	Local cSenha := ""
	Local nRD0Reg := 0
	Local nPosId := aScan(aParams,{|x| x[1] == "CPF"})
	Local nPosSen := aScan(aParams,{|x| x[1] == "SENHA"})

	If nPosId > 0 .AND. nPosSen > 0
		cCpf := aParams[nPosId,2]
		cSenha := aParams[nPosSen,2]
		cSenha := cripSenha(cSenha)
	EndIf

	BEGINSQL ALIAS 'TRD0'
		SELECT
			RD0.R_E_C_N_O_
		FROM %Table:RD0% AS RD0
		WHERE
			RD0.%NotDel%
			AND RD0_CIC = %exp:cCpf%
			// AND RD0_SENHA = %exp:cSenha%
			AND RD0_MSBLQL = '2'
			AND RD0_FUNC = '1'
	ENDSQL

	If !TRD0->(Eof())
		nRD0Reg := TRD0->R_E_C_N_O_
	EndIf
	TRD0->(DbCloseArea())

	RD0->(DbGoTo(nRD0Reg))
	If !RD0->(Eof())
		If ALLTRIM(RD0->RD0_SENHA) == cSenha
			cResponse['filial' ] := AllTrim(RD0->RD0_FILIAL)
			cResponse['codigo' ] := AllTrim(RD0->RD0_CODIGO)
			cResponse['nome' ] := AllTrim(RD0->RD0_NOME)
			cResponse['cpf' ] := AllTrim(RD0->RD0_CIC)
			cResponse['filialAtuacao'] := GetFilial(cCpf)
			cResponse['hasContent'] := .T.
		Else
			cResponse['code'] := 403
			cResponse['message'] := 'Senha Incorreta'
		EndIf
	EndIf

	If nRD0Reg == 0
		cResponse['code'] := 403
		cResponse['message'] := 'Login Incorreto ou Usuario Incorreto'
		lRet := .F.
	EndIf

	Self:SetContentType('application/json')
	Self:SetResponse(EncodeUTF8(cResponse:toJson()))
	RD0->(RestArea(aAreaRD0))
Return lRet

WSMETHOD PUT WSSERVICE participantes
	Local oBody := Self:getContent()
	Local lRet := .T.
	Local oResponse := JsonObject():New()
	Local oParticipante := JsonObject():New()
	Local lErro := .F.
	Local aErro := {}
	Local nRD0Reg := 0
	Local cCpf, cSenhaAntiga, cSenhaNova := ""

	// Parse do conteudo da requisicao.
	cError := oParticipante:fromJson(oBody)

	// Valida erros no parse.
	if !Empty(cError)
		SetRestFault(400, cError)
		lRet := .F.
		return lRet
	endif

	cCpf := oParticipante["cpf"]
	cSenhaAntiga := cripSenha(oParticipante["senhaAtual"])
	cSenhaNova := cripSenha(oParticipante["novaSenha"])

	BEGINSQL ALIAS 'TRD0'
		SELECT
			RD0.R_E_C_N_O_
		FROM %Table:RD0% AS RD0
		WHERE
			RD0.%NotDel%
			AND RD0_CIC = %exp:cCpf%
			AND RD0_SENHA = %exp:cSenhaAntiga%
			AND RD0_MSBLQL = '2'
	ENDSQL

	If !TRD0->(Eof())
		nRD0Reg := TRD0->R_E_C_N_O_
	EndIf
	TRD0->(DbCloseArea())

	RD0->(DbGoTo(nRD0Reg))
	If !RD0->(Eof())
		RecLock("RD0", .F.)
		Replace RD0_SENHA With cSenhaNova
		MsUnlock()
		Aadd(aErro, .F.)
	Else
		Aadd(aErro, .T.)
		Aadd(aErro, "Usuario ou Senha Invalido")
	EndIf

	lErro := aErro[1]

	If lErro
		oResponse ['message'] := aErro[2]
	Else
		oResponse ['message'] := "Senha alterada com sucesso!"
	EndIf

	// Define o tipo de retorno do método.
	Self:SetContentType( 'application/json' )

	// Define a resposta.
	Self:SetResponse(EncodeUTF8(oResponse:toJson()))
Return lRet

Static Function cripSenha(senha)
	Local cSenhaCorr := ''
	Local aTam := Len(senha)
	Local nPosLetra := 0
	Local aLetras := {}

	For nPosLetra := 1 to aTam
		Aadd(aLetras, SubStr(senha, nPosLetra, 1))
	Next

	cSenhaCorr := aLetras[2]+aLetras[4]+aLetras[6]+aLetras[1]+aLetras[3]+aLetras[5]
Return cSenhaCorr

Static Function GetFilial(cId)
	Local aArea := GetArea()
	Local aAreaSRA := SRA->(GetArea())
	Local cFilAtuacao := ""

	BEGINSQL ALIAS 'TSRA'
		SELECT
			SRA.RA_FILIAL
		FROM %Table:SRA% AS SRA
		WHERE
			SRA.%NotDel% AND
			SRA.RA_CIC = %exp:cId% AND
			SRA.RA_SITFOLH = ''
	ENDSQL

	If !TSRA->(Eof())
		cFilAtuacao := TSRA->RA_FILIAL
	EndIf
	TSRA->(DbCloseArea())

	SRA->(RestArea(aAreaSRA))
	RestArea(aArea)
Return cFilAtuacao
