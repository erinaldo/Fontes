#include 'protheus.ch'

/*/{Protheus.doc} MA040DIN
//TODO Será executado após a gravação do cadastro do vendedor.
@author Mario L. B. Faria
@since 10/05/2018
@version 1.0
/*/
User Function MA040DIN()

	//Chama integração com Teknisa
	//****************************
	GVRINT(3)
	//****************************
	
Return

/*/{Protheus.doc} MA040DAL
//TODO Este ponto de entrada pertence à rotina de manutenção do cadastro de vendedores, MATA040. 
Ele é executado na rotina de alteração (MA040ALT), após a gravação dos dados do vendedor.
@author Mario L. B. Faria
@since 10/05/2018
@version 1.0
/*/
User Function MA040DAL()

	//Chama integração com Teknisa
	//****************************
	GVRINT(4)
	//****************************

Return

/*/{Protheus.doc} MT040DEL
//TODO APÓS EXCLUSÃO DE VENDEDORES 
Este P.E. é chamado logo após a exclusão dos dados do vendedor
no arquivo. Pode ser utilizado para atualizar algum campo/arquivo após a
exclusão..
@author Mario L. B. Faria
@since 10/05/2018
@version 1.0
/*/
User Function MT040DEL()

	//Chama integração com Teknisa
	//****************************
	GVRINT(5)
	//****************************

Return


/*/{Protheus.doc} GVRINT
//TODO Função para gravar integração com Telnisa
@author Mario L. B. Faria
@since 10/05/2018
@version 1.0
@param nOpcx, numeric, Operação executada
/*/
Static Function GVRINT(nOpcx)
Local lOpcao	:= .T.
Local cXEmp		:= ""
Local cXFil		:= ""
Local cCodVen	:= ""        
Local cNomVen	:= ""        
Local aAreaSA3  := GetArea()  
Local cFilADK   := Space(TamSx3("ADK_FILIAL")[1])
	
	// -> Apenas executar o processo a baixo, se a filial 'é um restaurante'
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