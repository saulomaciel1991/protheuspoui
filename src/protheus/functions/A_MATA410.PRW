#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} User Function A_MATA410
  (long_description)
  @type  Function
  @author user
  @since 14/10/2022
  @version version
  @param param_name, param_type, param_descr
  @return return_var, return_type, return_description
  @example
  (examples)
  @see (links_or_references)
  /*/
User Function A_MATA410(oJson)
	Local aErro := {}
	Default oJson := GetData()

	aErro := Processa(oJson)
Return aErro

Static Function Processa(oJson)
	Local aCabec := {}
	Local aItens := {}
	Local nX := {}
	Local aErro := {}
	Local aRet := {}
	Private lMsErroAuto := .F.

	aCabec := {}
	aItens := {}

	nOpc := oJson['operacao'] //1-Pesquisar 2-Visualizar 3-Incluir 4-Alterar 5-Excluir

	If nOpc == 3
		If ValType(oJson['numero']) != "C"
			oJson['numero'] := ""
		EndIf
	EndIf

	If ValType(oJson['numero']) == "C"

		If nOpc == 3
			aadd(aCabec,{"C5_TIPO",   oJson['tipoPed'],Nil})
			aadd(aCabec,{"C5_CLIENTE",oJson['cliente'],Nil})
			aadd(aCabec,{"C5_LOJACLI",oJson['loja'],Nil})
			aadd(aCabec,{"C5_LOJAENT",oJson['loja'],Nil})
			aadd(aCabec,{"C5_CONDPAG",oJson['condPagto'],Nil})
			aadd(aCabec,{"C5_NATUREZ",oJson['natureza'],Nil})
		Else
			aadd(aCabec,{"C5_NUM",    oJson['numero'],Nil})
			aadd(aCabec,{"C5_TIPO",   oJson['tipoPed'],Nil})
			aadd(aCabec,{"C5_CLIENTE",oJson['cliente'],Nil})
			aadd(aCabec,{"C5_LOJACLI",oJson['loja'],Nil})
			aadd(aCabec,{"C5_LOJAENT",oJson['loja'],Nil})
			aadd(aCabec,{"C5_CONDPAG",oJson['condPagto'],Nil})
			aadd(aCabec,{"C5_NATUREZ",oJson['natureza'],Nil})
		EndIf


		For nX := 1 To Len(oJson['itens'])
			aLinha := {}

			aadd(aLinha,{"AUTDELETA","N",Nil})
			aadd(aLinha,{"C6_ITEM",StrZero(nX,2),Nil})
			aadd(aLinha,{"C6_PRODUTO",  oJson['itens',nX]['produto'],Nil})
			aadd(aLinha,{"C6_QTDVEN",   oJson['itens',nX]['qtd'],Nil})
			aadd(aLinha,{"C6_PRCVEN",   oJson['itens',nX]['preco_unitario'],Nil})
			aadd(aLinha,{"C6_PRUNIT",   oJson['itens',nX]['preco_unitario'],Nil})
			aadd(aLinha,{"C6_VALOR",    oJson['itens',nX]['preco_total'],Nil})
			aadd(aLinha,{"C6_TES",      oJson['itens',nX]['TES'],Nil})

			aadd(aItens,aLinha)
		Next nX

		MSExecAuto({|x,y,z|mata410(x,y,z)},aCabec,aItens,nOpc)

		If !lMsErroAuto
			FwAlertInfo("Processo realizado com sucesso!")
			aRet := {.F.,""}
		Else
			ConOut("Erro no processamento!")
			aErro := Mostraerro("C:/Temp", "A_MATA410.log")
			Aadd(aRet, lMsErroAuto)
			Aadd(aRet, aErro)
		EndIf
	Else
		aRet := {.T.,"Arquivo Json invalido"}
	EndIf
Return aRet

Static Function ReadFile(cFile)
	Local cBuffer := ''
	Local nH , nTam
	nH := Fopen(cFile)
	IF nH != -1
		nTam := fSeek(nH,0,2)
		fSeek(nH,0)
		cBuffer := space(nTam)
		fRead(nH,@cBuffer,nTam)
		fClose(nH)
	Else
		MsgStop("Falha na abertura do arquivo ["+cFile+"]","FERROR "+cValToChar(Ferror()))
	Endif
Return cBuffer

Static Function GetData()
	Local cFile := ""
	Local cMascara := "Arquivos Json|*.json"
	Local cJsonStr, oJson

	cFile := cGetFile(cMascara,"Escolha um arquivo",0,"C:\Temp",.T.)

	// Le a string JSON do arquivo do disco
	cJsonStr := readfile(cFile)

	// Cria o objeto JSON e popula ele a partir da string
	oJson := JSonObject():New()
	cErr  := oJSon:fromJson(cJsonStr)

	If !empty(cErr)
		MsgStop(cErr,"JSON PARSE ERROR")
		Return
	Endif
Return oJson
