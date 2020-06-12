#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} M020INC
//TODO Ponto de entrada ap�s a inclus�o cadastro de fornecedor, utilizado para realizar o cadastro da classe de valor CTH
@author Emerson
@since 23/05/2018
@version undefined

@type function
/*/
User Function M020INC()
	
	//Atualiza tabela CTH referente a classe de valor
	ATUACTH()

Return

/*/{Protheus.doc} M020ALT
//TODO Ponto de entrada ap�s a altera��o do cadastro de fornecedor, utilizado para realizar o cadastro ou altera��o da classe de valor CTH
@author Emerson
@since 24/05/2018
@version undefined

@type function
/*/
User Function M020ALT()
	
	//Atualiza tabela CTH referente a classe de valor
	ATUACTH()

Return

/*/{Protheus.doc} ATUACTH
//TODO Fun��o criada para atualizar tabela CTH referente a classe de valor
@author Emerson
@since 24/05/2018
@version undefined

@type function
/*/
Static Function ATUACTH()
	dbSelectArea("CTH")
	dbSetOrder(1) 
	//Se n�o existir incluir, se existir altera
	If !dbSeek(xFilial("CTH") + "F" + SA2->A2_COD + SA2->A2_LOJA) 
		RecLock("CTH", .T.)
		CTH_FILIAL	:= xFilial("CTH")
		CTH_CLVL	:= "F" + SA2->A2_COD + SA2->A2_LOJA
		CTH_DESC01	:= Posicione("SA2", 1, xFilial("SA2") + SA2->A2_COD + SA2->A2_LOJA, "A2_NOME")
		CTH_CLASSE	:= "2"
		//CTH_NORMAL	:= "0"
		CTH_BLOQ    := '2'
		CTH_DTEXIS  := CTOD("01/01/80")
		CTH_CLVLLP  := "F" + SA2->A2_COD + SA2->A2_LOJA
		CTH->(MsUnLock())
	Else
		RecLock("CTH", .F.)
		CTH_FILIAL	:= xFilial("CTH")
		CTH_CLVL	:= "F" + SA2->A2_COD + SA2->A2_LOJA
		CTH_DESC01	:= Posicione("SA2", 1, xFilial("SA2") + SA2->A2_COD + SA2->A2_LOJA, "A2_NOME")
		CTH_CLASSE	:= "2"
		//CTH_NORMAL	:= "0"
		CTH_BLOQ    := '2'
		CTH_DTEXIS  := CTOD("01/01/80")
		CTH_CLVLLP  := "F" + SA2->A2_COD + SA2->A2_LOJA
		CTH->(MsUnLock())
	Endif
Return

/*/{Protheus.doc} A020DELE
//TODO Ponto de entrada utilizado para validar a exclus�o no cadastro do fornecedor, caso exista movimenta��o com a classe de valor n�o permite a exclus�o.
@author Emerson
@since 24/05/2018
@version undefined

@type function
/*/
User Function A020DELE()
	Local lRet := !EXISTCTH() //Existe registros na CTH?
	If !lRet
		Aviso("A020DELE - N�o Permitido!","Existem lan�amentos cont�beis com a classe de valor F" + SA2->A2_COD + SA2->A2_LOJA + " vinculada ao fornecedor.",{"OK"},1)
	EndIF  
Return lRet

/*/{Protheus.doc} M020EXC
//TODO Ponto de entrada ap�s concluir a exclus�o do cadastro de fornecedor, utilizado para excluir classe de valor CTH
@author Emerson
@since 24/05/2018
@version undefined

@type function
/*/
User Function M020EXC()
	//Chamado a rotina para exclus�o, neste ponto as valida��es j� foram executadas
	EXCLCHT()
Return 

/*/{Protheus.doc} EXISTCTH
//TODO Fun��o criada para validar se existem movimenta��es contabeis com a classe de valor.
@author Emerson
@since 24/05/2018
@version undefined

@type function
/*/
Static Function EXISTCTH() 
	Local lExst := .F.
	
	DbSelectArea("CT2")
	DbSetORder(8) //CT2_CLVLDB
	If CT2->(DbSeek(xFilial("CT2")+"F" + SA2->A2_COD + SA2->A2_LOJA))
		lExst := .T.
	EndIF
	DbSelectArea("CT2")
	DbSetORder(9)//CT2_CLVLCL
	If CT2->(DbSeek(xFilial("CT2")+"F" + SA2->A2_COD + SA2->A2_LOJA))
		lExst := .T.
	EndIF 
	
Return lExst

/*/{Protheus.doc} MA020ROT
//TODO Ponto de entrada utilizado para adicionar fun��es customizada nos a��es relacionadas do cadastro de fornecedor, para chamar as fun��o de "CARGA" das classes de valor
@author Emerson
@since 30/05/2018
@version undefined

@type function
/*/
User Function MA020ROT()
	Local _aRet	:= {}
	
	AADD(_aRet, {"Carregar Classe de Valor" ,"U_XM020CTH(1)",0,6})
	AADD(_aRet, {"Excluir Classe de Valor" ,"U_XM020CTH(2)",0,6})
	AADD(_aRet, {"Importar" ,"U_IMPORT02()",0,3})

Return _aRet

/*/{Protheus.doc} XM020CTH
//TODO Fun��o de usu�rio criada para chamar a fun��o de inclus�o ou exclus�o em lote
@author Emerson
@since 30/05/2018
@version undefined
@param _nOpc, , descricao
@type function
/*/

User Function XM020CTH(_nOpc)
	If Aviso(IIF (_nOpc==1,"INCLUIR","EXCLUIR") + " classe de valor", "Confirma a analise nos cadastros dos fornecedores para " + IIF (_nOpc==1,"incluir","excluir") +" a classe de valor?",{"SIM","N�O"},2) == 1
		processa( {|| FACILCTH(_nOpc)  }, IIF (_nOpc==1,"INCLUS�O","EXCLUS�O"), "Atualizando classe de valor aguarde...", .F.)
		MsgInfo("Processo finalizado com sucesso!",IIF (_nOpc==1,"Inclus�o","Exclus�o") + " classe de valor")
	EndIf
Return

/*/{Protheus.doc} FACILCTH
//TODO Fun��o criada para realizar a analise nos cadastros dos fornecedores na tabela SA2 verificando se existe cadastro na CTH e realiza a exclus�o ou inclus�o conforme parametro recebido
@author Emerson
@since 30/05/2018
@version undefined
@param _nOpc, , descricao
@type function
/*/
Static Function FACILCTH(_nOpc)

	 procregua(SA2->(RECCOUNT()))
	 SA2->(DbGoTop())
	 While SA2->(!EOF())
	 	incproc("Atualizando fornecedor " + SA2->A2_COD )
	 	dbSelectArea("CTH")
		dbSetOrder(1) 
		//Se n�o existir incluir, se existir altera
		If _nOpc == 1 .AND. !CTH->(dbSeek(xFilial("CTH") + "F" + SA2->A2_COD + SA2->A2_LOJA))
			//Cadastra na CTH
			ATUACTH()
		ElseIF _nOpc == 2 .AND. CTH->(dbSeek(xFilial("CTH") + "F" + SA2->A2_COD + SA2->A2_LOJA))
			//N�o existe movimenta��o?
			If !EXISTCTH() 
				//Se nao existir exclui da  CTH
				EXCLCHT()	
			EndIf
		EndIF
	 	SA2->(DbSkip())
	 EndDo
	  
Return

/*/{Protheus.doc} EXCLCHT
//TODO Fun��o criada para realizar a exclus�o da classe de valor na CTH
@author Emerson
@since 30/05/2018
@version undefined

@type function
/*/
Static Function EXCLCHT()
	dbSelectArea("CTH")
	dbSetOrder(1) 
	If CTH->(dbSeek(xFilial("CTH") + "F" + SA2->A2_COD + SA2->A2_LOJA))
		RecLock("CTH", .F.)
			CTH->(DbDelete())
		CTH->(MsUnLock())
	EndIF
Return 