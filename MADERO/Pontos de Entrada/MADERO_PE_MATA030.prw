#include 'protheus.ch'
#include 'parmtype.ch'

#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} M030INC
//TODO Ponto de entrada após a inclusão cadastro de cliente, utilizado para realizar o cadastro da classe de valor CTH
@author Emerson SMSTI
@since 23/05/2018
@version undefined

@type function
/*/
User Function M030INC()
	
	//Atualiza tabela CTH referente a classe de valor
	IF PARAMIXB != 3 //Confirmou a inclusão?
		//Chama função pra criar a classe de valor
		ATUACTH()
	EndIF

Return

/*/{Protheus.doc} MALTCLI
//TODO Ponto de entrada após a alteração do cadastro de cliente, utilizado para realizar o cadastro ou alteração da classe de valor CTH
@author Emerson
@since 24/05/2018
@version undefined

@type function
/*/
User Function MALTCLI()
	
	//Chama função para atualiza tabela CTH referente a classe de valor
	ATUACTH()

Return

/*/{Protheus.doc} ATUACTH
//TODO Função criada para atualizar tabela CTH referente a classe de valor
@author Emerson SMSTI
@since 24/05/2018
@version undefined

@type function
/*/
Static Function ATUACTH()
	dbSelectArea("CTH")
	dbSetOrder(1) 
	//Se não existir incluir, se existir altera
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
//TODO Ponto de entrada utilizado para validar a exclusão no cadastro do cliente, caso exista movimentação com a classe de valor não permite a exclusão.
@author Emerson SMSTI
@since 24/05/2018
@version undefined

@type function
/*/
User Function M030DEL()
	Local lRet := !EXISTCTH() //Existe registros na CTH nos lançamentos contabeis?
	If !lRet
		Aviso("M030DEL - Não Permitido!","Existem lançamentos contábeis com a classe de valor F" + SA1->A1_COD + SA1->A1_LOJA + " vinculada ao cliente.",{"OK"},1)
	EndIF  
Return lRet

/*/{Protheus.doc} M030EXC
//TODO -Ponto de entrada após concluir a exclusão do cadastro de cliente, utilizado para excluir classe de valor CTH
@author Emerson SMSTI
@since 24/05/2018
@version undefined

@type function
/*/
User Function M030EXC()
	//Chama a rotina para exclusão, neste ponto as validações já foram executadas
	EXCLCHT()
Return 

/*/{Protheus.doc} EXISTCTH
//TODO Função criada para validar se existem movimentações contabeis com a classe de valor.
@author Emerson SMSTI
@since 24/05/2018
@version undefined

@type function
/*/
Static Function EXISTCTH() 
	Local lExst := .F.
	
	DbSelectArea("CT2")
	DbSetORder(8) //CT2_CLVLDB
	//Existe lançamento contabeis com a classe de valor debito?
	If CT2->(DbSeek(xFilial("CT2")+"C" + SA1->A1_COD + SA1->A1_LOJA))
		lExst := .T.
	EndIF
	DbSelectArea("CT2")
	DbSetORder(9)//CT2_CLVLCL
	//Existe lançamento contabeis com a classe de valor credito?
	If CT2->(DbSeek(xFilial("CT2")+"C" + SA1->A1_COD + SA1->A1_LOJA))
		lExst := .T.
	EndIF 
	
Return lExst

/*/{Protheus.doc} MA030ROT
//TODO Ponto de entrada utilizado para adicionar funções customizada nos ações relacionadas do cadastro de cliente, para chamar as função de "CARGA" das classes de valor
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
//TODO Função de usuário criada para chamar a função de inclusão ou exclusão em lote
@author Emerson SMSTI
@since 30/05/2018
@version undefined
@param _nOpc, , descricao
@type function
/*/
User Function XM030CTH(_nOpc)
	If Aviso(IIF (_nOpc==1,"INCLUIR","EXCLUIR") + " classe de valor", "Confirma a analise nos cadastros dos clientes para " + IIF (_nOpc==1,"incluir","excluir") +" a classe de valor?",{"SIM","NÃO"},2) == 1
		processa( {|| FACILCTH(_nOpc)  }, IIF (_nOpc==1,"INCLUSÃO","EXCLUSÃO"), "Atualizando classe de valor aguarde...", .F.)
		MsgInfo("Processo finalizado com sucesso!",IIF (_nOpc==1,"Inclusão","Exclusão") + " classe de valor")
	EndIf
Return

/*/{Protheus.doc} FACILCTH
//TODO Função criada para realizar a analise nos cadastros dos clientes na tabela SA1 verificando se existe cadastro na CTH e realiza a exclusão ou inclusão conforme parametro recebido
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
		//Se for parametro de inclusão e registro não existe, chamado função de inclusão.
		If _nOpc == 1 .AND. !CTH->(dbSeek(xFilial("CTH") + "C" + SA1->A1_COD + SA1->A1_LOJA))
			//Cadastra na CTH
			ATUACTH()
		//Se for parametro de exclusão e registro existe na CTH, chamado função de exclusão.
		ElseIF _nOpc == 2 .AND. CTH->(dbSeek(xFilial("CTH") + "C" + SA1->A1_COD + SA1->A1_LOJA))
			//Não existe movimentação contabil?
			If !EXISTCTH() 
				//Se nao existir exclui da  CTH
				EXCLCHT()	
			EndIf
		EndIF
	 	SA1->(DbSkip())
	 EndDo
	  
Return

/*/{Protheus.doc} EXCLCHT
//TODO Função criada para realizar a exclusão da classe de valor na CTH
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