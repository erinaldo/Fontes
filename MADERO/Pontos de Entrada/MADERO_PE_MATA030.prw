#include 'protheus.ch'
#include 'parmtype.ch'

#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} M030INC
//TODO Ponto de entrada ap�s a inclus�o cadastro de cliente, utilizado para realizar o cadastro da classe de valor CTH
@author Emerson SMSTI
@since 23/05/2018
@version undefined

@type function
/*/
User Function M030INC()
	
	//Atualiza tabela CTH referente a classe de valor
	IF PARAMIXB != 3 //Confirmou a inclus�o?
		//Chama fun��o pra criar a classe de valor
		ATUACTH()
	EndIF

Return

/*/{Protheus.doc} MALTCLI
//TODO Ponto de entrada ap�s a altera��o do cadastro de cliente, utilizado para realizar o cadastro ou altera��o da classe de valor CTH
@author Emerson
@since 24/05/2018
@version undefined

@type function
/*/
User Function MALTCLI()
	
	//Chama fun��o para atualiza tabela CTH referente a classe de valor
	ATUACTH()

Return

/*/{Protheus.doc} ATUACTH
//TODO Fun��o criada para atualizar tabela CTH referente a classe de valor
@author Emerson SMSTI
@since 24/05/2018
@version undefined

@type function
/*/
Static Function ATUACTH()
	dbSelectArea("CTH")
	dbSetOrder(1) 
	//Se n�o existir incluir, se existir altera
	If !dbSeek(xFilial("CTH") + "C" + SA1->A1_COD + SA1->A1_LOJA) 
		RecLock("CTH", .T.)
		CTH_FILIAL	:= xFilial("CTH")
		CTH_CLVL	:= "C" + SA1->A1_COD + SA1->A1_LOJA
		CTH_DESC01	:= Posicione("SA1", 1, xFilial("SA1") + SA1->A1_COD + SA1->A1_LOJA, "A1_NOME")
		CTH_CLASSE	:= "2"
		//CTH_NORMAL	:= "0"
		CTH_BLOQ    := '2'
		CTH_DTEXIS  := CTOD("01/01/80")
		CTH_CLVLLP  := "C" + SA1->A1_COD + SA1->A1_LOJA
		CTH->(MsUnLock())
	Else
		RecLock("CTH", .F.)
		CTH_FILIAL	:= xFilial("CTH")
		CTH_CLVL	:= "C" + SA1->A1_COD + SA1->A1_LOJA
		CTH_DESC01	:= Posicione("SA1", 1, xFilial("SA1") + SA1->A1_COD + SA1->A1_LOJA, "A1_NOME")
		CTH_CLASSE	:= "2"
		//CTH_NORMAL	:= "0"
		CTH_BLOQ    := '2'
		CTH_DTEXIS  := CTOD("01/01/80")
		CTH_CLVLLP  := "C" + SA1->A1_COD + SA1->A1_LOJA
		CTH->(MsUnLock())
	Endif
Return

/*/{Protheus.doc} M030DEL
//TODO Ponto de entrada utilizado para validar a exclus�o no cadastro do cliente, caso exista movimenta��o com a classe de valor n�o permite a exclus�o.
@author Emerson SMSTI
@since 24/05/2018
@version undefined

@type function
/*/
User Function M030DEL()
	Local lRet := !EXISTCTH() //Existe registros na CTH nos lan�amentos contabeis?
	If !lRet
		Aviso("M030DEL - N�o Permitido!","Existem lan�amentos cont�beis com a classe de valor F" + SA1->A1_COD + SA1->A1_LOJA + " vinculada ao cliente.",{"OK"},1)
	EndIF  
Return lRet

/*/{Protheus.doc} M030EXC
//TODO -Ponto de entrada ap�s concluir a exclus�o do cadastro de cliente, utilizado para excluir classe de valor CTH
@author Emerson SMSTI
@since 24/05/2018
@version undefined

@type function
/*/
User Function M030EXC()
	//Chama a rotina para exclus�o, neste ponto as valida��es j� foram executadas
	EXCLCHT()
Return 

/*/{Protheus.doc} EXISTCTH
//TODO Fun��o criada para validar se existem movimenta��es contabeis com a classe de valor.
@author Emerson SMSTI
@since 24/05/2018
@version undefined

@type function
/*/
Static Function EXISTCTH() 
	Local lExst := .F.
	
	DbSelectArea("CT2")
	DbSetORder(8) //CT2_CLVLDB
	//Existe lan�amento contabeis com a classe de valor debito?
	If CT2->(DbSeek(xFilial("CT2")+"C" + SA1->A1_COD + SA1->A1_LOJA))
		lExst := .T.
	EndIF
	DbSelectArea("CT2")
	DbSetORder(9)//CT2_CLVLCL
	//Existe lan�amento contabeis com a classe de valor credito?
	If CT2->(DbSeek(xFilial("CT2")+"C" + SA1->A1_COD + SA1->A1_LOJA))
		lExst := .T.
	EndIF 
	
Return lExst

/*/{Protheus.doc} MA030ROT
//TODO Ponto de entrada utilizado para adicionar fun��es customizada nos a��es relacionadas do cadastro de cliente, para chamar as fun��o de "CARGA" das classes de valor
@author Emerson SMSTI
@since 30/05/2018
@version undefined

@type function
/*/
User Function MA030ROT()
	Local _aRet	:= {}
	
	AADD(_aRet, {"Carregar Classe de Valor" ,"U_XM030CTH(1)",0,6})
	AADD(_aRet, {"Excluir Classe de Valor" ,"U_XM030CTH(2)",0,6})

Return _aRet

/*/{Protheus.doc} XM030CTH
//TODO Fun��o de usu�rio criada para chamar a fun��o de inclus�o ou exclus�o em lote
@author Emerson SMSTI
@since 30/05/2018
@version undefined
@param _nOpc, , descricao
@type function
/*/
User Function XM030CTH(_nOpc)
	If Aviso(IIF (_nOpc==1,"INCLUIR","EXCLUIR") + " classe de valor", "Confirma a analise nos cadastros dos clientes para " + IIF (_nOpc==1,"incluir","excluir") +" a classe de valor?",{"SIM","N�O"},2) == 1
		processa( {|| FACILCTH(_nOpc)  }, IIF (_nOpc==1,"INCLUS�O","EXCLUS�O"), "Atualizando classe de valor aguarde...", .F.)
		MsgInfo("Processo finalizado com sucesso!",IIF (_nOpc==1,"Inclus�o","Exclus�o") + " classe de valor")
	EndIf
Return

/*/{Protheus.doc} FACILCTH
//TODO Fun��o criada para realizar a analise nos cadastros dos clientes na tabela SA1 verificando se existe cadastro na CTH e realiza a exclus�o ou inclus�o conforme parametro recebido
@author Emerson SMSTI
@since 30/05/2018
@version undefined
@param _nOpc, , descricao
@type function
/*/
Static Function FACILCTH(_nOpc)

	 procregua(SA1->(RECCOUNT()))
	 SA1->(DbGoTop())//Posiciona no inicio da tabela SA1
	 //Percorre registros da SA1
	 While SA1->(!EOF())
	 	incproc("Atualizando cliente " + SA1->A1_COD )
	 	dbSelectArea("CTH")
		dbSetOrder(1) 
		//Se for parametro de inclus�o e registro n�o existe, chamado fun��o de inclus�o.
		If _nOpc == 1 .AND. !CTH->(dbSeek(xFilial("CTH") + "C" + SA1->A1_COD + SA1->A1_LOJA))
			//Cadastra na CTH
			ATUACTH()
		//Se for parametro de exclus�o e registro existe na CTH, chamado fun��o de exclus�o.
		ElseIF _nOpc == 2 .AND. CTH->(dbSeek(xFilial("CTH") + "C" + SA1->A1_COD + SA1->A1_LOJA))
			//N�o existe movimenta��o contabil?
			If !EXISTCTH() 
				//Se nao existir exclui da  CTH
				EXCLCHT()	
			EndIf
		EndIF
	 	SA1->(DbSkip())
	 EndDo
	  
Return

/*/{Protheus.doc} EXCLCHT
//TODO Fun��o criada para realizar a exclus�o da classe de valor na CTH
@author Emerson SMSTI
@since 30/05/2018
@version undefined

@type function
/*/
Static Function EXCLCHT()
	dbSelectArea("CTH")
	dbSetOrder(1) 
	If CTH->(dbSeek(xFilial("CTH") + "C" + SA1->A1_COD + SA1->A1_LOJA))
		RecLock("CTH", .F.)
			CTH->(DbDelete())
		CTH->(MsUnLock())
	EndIF
Return 