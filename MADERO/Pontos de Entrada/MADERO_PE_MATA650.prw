#Include 'Protheus.ch'

/*/{Protheus.doc} MA650LEG
//TODO LOCALIZA��O : Function MATA650() - Respons�vel pelo cadastramento de Ordens de Produ��o.
EM QUE PONTO : � executado antes da mBrowse no cadastramento de Ordens de Produ��o, e permite adicionar/alterar a 
legenda com a classifica��o do usu�rio. Lembrando que o array passado possui 3 dimenss�es, para contemplar o t�tulo da legenda
@author Mario L. B. Faria
@since 16/07/2018
@version 1.0
@return aCorAux(aNewMenu), Array com a legenda definida pelo operador, lembrando que o mesmo possui tr�s(3) dimenss�es.
/*/
User Function MA650LEG()
Local aMenu		:= ParamIxb
Local aNewMenu	:= {}
Local nX		:= 0
Local aArea     := GetArea()

	// -> Verifica se � industria (n�o pode ser executada para as unidades de neg�cio)
	If !U_IsBusiness()
		aAdd(aNewMenu,{ "U_APCP03LG()", "BR_MARROM", "Totalmentea Aponta/N�o encerrada" } )
	
		For nX := 1 to Len(aMenu)
			aAdd(aNewMenu,aMenu[nX])
		Next nX

	EndIf

	RestArea(aArea)

Return aNewMenu

/*/{Protheus.doc} MA650TOK
//TODO 
LOCALIZA��O : Function A650TudoOk() - Respons�vel por validar a Enchoice em rela��o as datas de in�cio previsto e entrega prevista com prazo de entrega. 
DESCRI��O : Permite executar a valida��o do usu�rio ao confirmar a OP.
@author Mario L. B. Faria
@since 23/07/2018
@version 1.0
@return lRet(logico), O retorno do ponto de entrada deve ser l�gico, validando assim a confirma��o da OP.
/*/
User Function MA650TOK()
Local lRet	:=.T.
Local aArea :=GetArea()
	
	// -> Verifica se � industria e n�o pe do MRP para obrigar o preenchimento do campo Roteiro
	If !U_IsBusiness()
		If !IsInCallStack("MATA712") .And. !IsInCallStack("PCPA107")
			If Empty(M->C2_ROTEIRO)
				Help("",1,"Aten��o",,"Para Fabrica � obrigat�rio a informar o campo Roteiro!!!",4,1)
				lRet := .F.
			EndIf
		EndIf
	EndIf

	RestArea(aArea)

Return lRet


/*/{Protheus.doc} MA650EMP
//TODO 
LOCALIZA��O :  Function MontEstru() - Respons�vel por montar array com estrutura do produto.
DESCRI��O : Ultilizado para atualizar as OP`s intermediarias geradas automaticamente.
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
LOCALIZA��O :  Este P.E. � chamado nas fun��es: A650Inclui (Inclus�o de Op's)A650GeraC2 (Gera Op para Produto/Quantidade Informados nos par�metros)
DESCRI��O : Ultilizado para atualizar as OP`s geradas pelo MRP.
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
DESCRI��O : Atualiza OPS com campo C2_XDESCP em branco.
@author Paulo Gabriel F. e Silva
@since 29/11/2018
@version 1.0
@return Nil(nulo)
/*/
User Function ATUSC2()
Local lRet 		:= .T.  //..customiza��o do cliente

 	DBSelectArea("SB1")
 	SB1->(DBSetOrder(1))
	If SB1->(DBSeek(xFilial("SB1")+SC2->C2_PRODUTO))
		RecLock("SC2", .F.)
 		SC2->C2_XDESCP := SUBSTR(SB1->B1_DESC, 0, TamSx3("C2_XDESCP")[1])
 		SC2->(MsUnlock())
	EndIf

Return lRet