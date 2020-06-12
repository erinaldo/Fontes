#include 'protheus.ch'
/*                                                    
+------------------+-------------------------------------------------------------------------------+
! Nome             ! MATA200                                                                       !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! Ponto de entrada no cadastro de estruturas de produtos                        !
!                  !                                                                               !
+------------------+-------------------------------------------------------------------------------+
! Autor            ! Vários                                                                        !
+------------------+-------------------------------------------------------------------------------+
! Data             ! 24/05/2018                                                                    !
+------------------+-------------------------------------------------------------------------------+
! Parametros       ! N/A                                                                           !
+------------------+-------------------------------------------------------------------------------+
! Retorno          ! N/A                                                                           !
+------------------+-------------------------------------------------------------------------------+
*/ 

User Function A200GrvE()

	//Grava PutComposicao
	//*********************************************
	INTTEC()
	//*********************************************

Return

/*/{Protheus.doc} INTTEC
//TODO Fun~]ao para gravar integração com telnisa
@author Mario L. B. Faria
@since 09/05/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
Static Function INTTEC()
Local lOpcao	:= .F.
Local cXEmp		:= ""
Local cXFil		:= ""
Local cCodExt	:= ""
Local cAlDel	:= ""
Local cCodAux	:= ""
Local aAreaSG1  := GetArea()  
Local cFilADK   := Space(TamSx3("ADK_FILIAL")[1])
	
	// -> Apenas executar o processo a baixo, se a filial 'é um restaurante'
	If !u_IsBusiness()  
		RestArea(aAreaSG1)
		Return
	Endif
	
	// -> posiciona na unidade de negócio	
	dbSelectArea("ADK")
	ADK->( dbOrderNickName("ADKXFILI") )
	ADK->(dbseek(cFilADK+cFilAnt)) 
	
	cXEmp:=ADK->ADK_XEMP  
	cXFil:=ADK->ADK_XFIL 
                        
	Do Case
		Case ParamIxb[01] == 3 .Or. ParamIxb[01] == 4
			cCodAux := SG1->G1_COD
			
		Case ParamIxb[01] == 5
			//Busca código do produto após deletar a estrutura
			cAlDel := MPSysOpenQuery("SELECT G1_COD FROM " + RetSqlname("SG1") + " WHERE R_E_C_N_O_ = " + cValToChar(ParamIxb[03,01]))
			
			If !(cAlDel)->(Eof())
				cCodAux := (cAlDel)->G1_COD
			EndIf
	
	EndCase
	
	// -> Posiciona no cadastro de produtos
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+cCodAux))	
	
	dbSelectArea("Z14")
	Z14->(dbGoTop())
	Z14->(dbSetOrder(1))
	If !Z14->(dbSeek(xFilial("Z14") + cCodAux))
		lOpcao := .T.
	Else
	    lOpcao := .F.
	EndIf	
	
	cCodExt := ""
	dbSelectArea("Z13")
	Z13->(DbSetOrder(1))
	If Z13->(dbSeek(xFilial("Z13") + cCodAux))	
		cCodExt := Z13->Z13_XCODEX
		
		Do Case
			Case ParamIxb[01] == 3 .Or. ParamIxb[01] == 4
	
				Reclock("Z14",lOpcao)
				Z14->Z14_FILIAL		:= xFilial("Z14")
				Z14->Z14_COD		:= cCodAux
				Z14->Z14_DESC       := SB1->B1_DESC
				Z14->Z14_XSTINT		:= "P"
				Z14->Z14_XCODEX		:= cCodExt
				Z14->Z14_XEMP		:= cXEmp
				Z14->Z14_XFIL		:= cXFil
				Z14->Z14_XEXC		:= "N"
				Z14->(MsUnlock())
			
			Case ParamIxb[01] == 5
		
				If lOpcao
					Reclock("Z14",.T.)
					Z14->Z14_FILIAL		:= xFilial("Z14")
					Z14->Z14_COD		:= cCodAux
					Z14->Z14_DESC       := SB1->B1_DESC
					Z14->Z14_XCODEX		:= cCodExt
					Z14->Z14_XEMP		:= cXEmp
					Z14->Z14_XFIL		:= cXFil
				Else
					Reclock("Z14",.F.)
				EndIf
				Z14->Z14_XSTINT		:= "P"
				Z14->Z14_XEXC		:= "S"
				Z14->(MsUnlock())
	
		EndCase

	EndIf
    RestArea(aAreaSG1)
	
Return 




/*                                                    
+------------------+-------------------------------------------------------------------------------+
! Nome             ! MTA200MNU                                                                     !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! Inclusão de menus no MBrowse da rotima                                        !
!                  !                                                                               !
+------------------+-------------------------------------------------------------------------------+
*/ 
User Function MTA200MNU( )

   AAdd( aRotina, { "Replicar", "U_EST002", 0 , 2 } )

Return 
