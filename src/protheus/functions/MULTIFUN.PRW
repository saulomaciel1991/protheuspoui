#include 'Protheus.ch'

/*/{Protheus.doc} TESTE
    Funcao criada para ajudar nos testes de novas funcionalidades
    @type  Function
    @author Saulo Maciel
    @since 11/09/2020
    @version undefined
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/

User Function MULTIFUN()
	Local cFunc := ""
	Local lUserFunc := .F.
	Local aResps := {}
	Local aPergs := {}

	aAdd(aPergs,{1,"Nome da Função",Space(15),"","","","",0,.F.})
	aAdd(aPergs,{4,"Função de Usuario?",.F.,"",90,"",.F.})
	aAdd(aPergs, {2, "Lista de Funções", 0, {"1=COLAUTOREAD", "2=SCHEDCOMCOL"},090, ".T.", .F.})

	If Parambox (aPergs,"Informe uma função sem parametros...",aResps)
		cFunc := aResps[1]
		lUserFunc := aResps[2]

		If ValType(aResps[3]) == "C"
			If aResps[3] == "1"
				cFunc := "COLAUTOREAD"
			EndIf
			If aResps[3] == "2"
				cFunc := "SCHEDCOMCOL"
			EndIf
		EndIf
	Else
		Alert("Operação cancelada pelo usuario")
	Endif

	If lUserFunc
		If EXISTBLOCK(cFunc)
			lGravou := EXECBLOCK(cFunc,.F.,.F.,"")
		Else
			Alert("Função não encontrada!")
		Endif
	Else
		cFunc := AllTrim(cFunc)+"()"
		Processa( {|| &cFunc }, "Aguarde...", "Carregando...",.F.)
	EndIf

Return
