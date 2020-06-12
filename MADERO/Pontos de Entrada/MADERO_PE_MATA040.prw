#include 'protheus.ch'

/*/{Protheus.doc} MA040DIN
//TODO Ser� executado ap�s a grava��o do cadastro do vendedor.
@author Mario L. B. Faria
@since 10/05/2018
@version 1.0
/*/
User Function MA040DIN()

	//Chama integra��o com Teknisa
	//****************************
	GVRINT(3)
	//****************************
	
Return

/*/{Protheus.doc} MA040DAL
//TODO Este ponto de entrada pertence � rotina de manuten��o do cadastro de vendedores, MATA040. 
Ele � executado na rotina de altera��o (MA040ALT), ap�s a grava��o dos dados do vendedor.
@author Mario L. B. Faria
@since 10/05/2018
@version 1.0
/*/
User Function MA040DAL()

	//Chama integra��o com Teknisa
	//****************************
	GVRINT(4)
	//****************************

Return

/*/{Protheus.doc} MT040DEL
//TODO AP�S EXCLUS�O DE VENDEDORES 
Este P.E. � chamado logo ap�s a exclus�o dos dados do vendedor
no arquivo. Pode ser utilizado para atualizar algum campo/arquivo ap�s a
exclus�o..
@author Mario L. B. Faria
@since 10/05/2018
@version 1.0
/*/
User Function MT040DEL()

	//Chama integra��o com Teknisa
	//****************************
	GVRINT(5)
	//****************************

Return


/*/{Protheus.doc} GVRINT
//TODO Fun��o para gravar integra��o com Telnisa
@author Mario L. B. Faria
@since 10/05/2018
@version 1.0
@param nOpcx, numeric, Opera��o executada
/*/
Static Function GVRINT(nOpcx)
Local lOpcao	:= .T.
Local cXEmp		:= ""
Local cXFil		:= ""
Local cCodVen	:= ""        
Local cNomVen	:= ""        
Local aAreaSA3  := GetArea()  
Local cFilADK   := Space(TamSx3("ADK_FILIAL")[1])
	
	// -> Apenas executar o processo a baixo, se a filial '� um restaurante'
	If !u_IsBusiness()  
		RestArea(aAreaSA3)
		Return
	Endif

	dbSelectArea("ADK")
	ADK->( dbOrderNickName("ADKXFILI") )
	ADK->(dbseek(cFilADK+cFilAnt)) 
	cXEmp :=IIF(Empty(xFilial("Z15")),"",ADK->ADK_XEMP)  
	cXFil :=IIF(Empty(xFilial("Z15")),"",ADK->ADK_XFIL) 
	
	If nOpcx == 3 .Or. nOpcx == 4
		cCodVen := M->A3_COD
		cNomVen	:= M->A3_NOME
	ElseIf nOpcx == 5
		cCodVen := SA3->A3_COD
		cNomVen	:= SA3->A3_NOME
	EndIf
	
	dbSelectArea("Z15")
	Z15->(dbGoTop())
	Z15->(dbSetOrder(1))
	If Z15->( dbSeek(xFilial("Z15") + cCodVen) )
		lOpcao := .F.
	EndIf				
		
	If nOpcx == 3 .Or. nOpcx == 4
	
		Reclock("Z15",lOpcao)
		Z15->Z15_FILIAL		:= xFilial("Z15")
		Z15->Z15_COD		:= cCodVen
		Z15->Z15_NOME       := cNomVen
		Z15->Z15_XSTINT		:= "P"
		Z15->Z15_XEMP		:= cXEmp
		Z15->Z15_XFIL		:= cXFil
		Z15->Z15_XEXC		:= "N"
		Z15->(MsUnlock())
		
	ElseIf nOpcx == 5
	
		Reclock("Z15",lOpcao)
		If lOpcao
			Z15->Z15_FILIAL		:= xFilial("Z15")
			Z15->Z15_COD		:= cCodVen
			Z15->Z15_XEMP		:= cXEmp
			Z15->Z15_XFIL		:= cXFil				
		EndIf
		Z15->Z15_XSTINT		:= "P"
		Z15->Z15_XEXC		:= "S"
		Z15->(MsUnlock())				
	
	EndIf     
		
	RestArea(aAreaSA3)	

Return