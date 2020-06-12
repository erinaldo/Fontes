#Include 'Protheus.ch'

/*/{Protheus.doc} MA650LEG
//TODO LOCALIZAÇÃO : Function MATA650() - Responsável pelo cadastramento de Ordens de Produção.
EM QUE PONTO : É executado antes da mBrowse no cadastramento de Ordens de Produção, e permite adicionar/alterar a 
legenda com a classificação do usuário. Lembrando que o array passado possui 3 dimenssões, para contemplar o título da legenda
@author Mario L. B. Faria
@since 16/07/2018
@version 1.0
@return aCorAux(aNewMenu), Array com a legenda definida pelo operador, lembrando que o mesmo possui três(3) dimenssões.
/*/
User Function MA650LEG()
Local aMenu		:= ParamIxb
Local aNewMenu	:= {}
Local nX		:= 0
Local aArea     := GetArea()

	// -> Verifica se é industria (não pode ser executada para as unidades de negócio)
	If !U_IsBusiness()
		aAdd(aNewMenu,{ "U_APCP03LG()", "BR_MARROM", "Totalmentea Aponta/Não encerrada" } )
	
		For nX := 1 to Len(aMenu)
			aAdd(aNewMenu,aMenu[nX])
		Next nX

	EndIf

	RestArea(aArea)

Return aNewMenu

/*/{Protheus.doc} MA650TOK
//TODO 
LOCALIZAÇÃO : Function A650TudoOk() - Responsável por validar a Enchoice em relação as datas de início previsto e entrega prevista com prazo de entrega. 
DESCRIÇÃO : Permite executar a validação do usuário ao confirmar a OP.
@author Mario L. B. Faria
@since 23/07/2018
@version 1.0
@return lRet(logico), O retorno do ponto de entrada deve ser lógico, validando assim a confirmação da OP.
/*/
User Function MA650TOK()
Local lRet	:=.T.
Local aArea :=GetArea()
	
	// -> Verifica se é industria e não pe do MRP para obrigar o preenchimento do campo Roteiro
	If !U_IsBusiness()
		If !IsInCallStack("MATA712") .And. !IsInCallStack("PCPA107")
			If Empty(M->C2_ROTEIRO)
				Help("",1,"Atenção",,"Para Fabrica é obrigatório a informar o campo Roteiro!!!",4,1)
				lRet := .F.
			EndIf
		EndIf
	EndIf

	RestArea(aArea)

Return lRet


/*/{Protheus.doc} MA650EMP
//TODO 
LOCALIZAÇÃO :  Function MontEstru() - Responsável por montar array com estrutura do produto.
DESCRIÇÃO : Ultilizado para atualizar as OP`s intermediarias geradas automaticamente.
@author Paulo Gabriel F. e Silva
@since 28/11/2018
@version 1.0
@return Nil(nulo)
/*/
User Function MA650EMP()
Local aArea :=GetArea()

	U_ATUSC2()
	RestArea(aArea)	

Return Nil


/*/{Protheus.doc} MA650EMP
//TODO 
LOCALIZAÇÃO :  Este P.E. é chamado nas funções: A650Inclui (Inclusão de Op's)A650GeraC2 (Gera Op para Produto/Quantidade Informados nos parâmetros)
DESCRIÇÃO : Ultilizado para atualizar as OP`s geradas pelo MRP.
@author Paulo Gabriel F. e Silva
@since 29/11/2018
@version 1.0
@return Nil(nulo)
/*/
User Function MTA650I()
Local aArea :=GetArea()

	U_ATUSC2()
	RestArea(aArea)

Return Nil


/*/{Protheus.doc}
//TODO 
DESCRIÇÃO : Atualiza OPS com campo C2_XDESCP em branco.
@author Paulo Gabriel F. e Silva
@since 29/11/2018
@version 1.0
@return Nil(nulo)
/*/
User Function ATUSC2()
Local lRet 		:= .T.  //..customização do cliente

 	DBSelectArea("SB1")
 	SB1->(DBSetOrder(1))
	If SB1->(DBSeek(xFilial("SB1")+SC2->C2_PRODUTO))
		RecLock("SC2", .F.)
 		SC2->C2_XDESCP := SUBSTR(SB1->B1_DESC, 0, TamSx3("C2_XDESCP")[1])
 		SC2->(MsUnlock())
	EndIf

Return lRet