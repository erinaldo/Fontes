#include 'protheus.ch'
#include 'fwmvcdef.ch'


/*---------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                          !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! PONTO DE ENTRADA                                        !
+------------------+---------------------------------------------------------+
!Modulo            ! FIN - FINANCEIRO                                        !
+------------------+---------------------------------------------------------+
!Nome              ! MADERO_PE_LOJA070.prw                                   !
+------------------+---------------------------------------------------------+
!Descricao         ! PONTO DE ENTRADA CADASTRO ADMINISTRADORAS FINANCEIRAS   !
+------------------+---------------------------------------------------------+
!Atualizado por    ! Paulo Gabriel F. Silva              			 		 !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 15/05/2018                                              !
+------------------+--------------------------------------------------------*/   
//Vai receber como parametro a empresa e Filial que vai ser executada.
user function LOJA070()

	//Objeto do formulário ou do modelo, conforme o caso.
	Local oModel  //ParamIXB[1]
	//ID do local de execução do ponto de entrada
	Local cIdPonto //ParamIXB[2]
	//ID do formulário
	Local cIdModel //ParamIXB[3]

	Local xRetorno := .T.

	Local lOpcao	:= .T.
	Local cXEmp		:= ""
	Local cXFil		:= ""

	IF ! Empty(ParamIXB)

		oModel   := ParamIXB[1]
		cIdPonto := ParamIXB[2]
		cIdModel := ParamIXB[3]

		do case
				
			case cIdPonto == "MODELCOMMITTTS"
				
				Do Case
					Case oModel:GetOperation() == 3 .Or. oModel:GetOperation() == 4 .Or. oModel:GetOperation() == 5
                        If !Empty( oModel:GetValue('SAEMASTER','AE_XCOD'))
						    LJA070PE(oModel)
                        EndIf
				
				EndCase
				//*******************************************************
				
			case cIdPonto == "BUTTONBAR"
				xRetorno := {}

		endcase

	EndIF

return xRetorno



/*---------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                          !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! PONTO DE ENTRADA                                        !
+------------------+---------------------------------------------------------+
!Modulo            ! FIN - FINANCEIRO                                        !
+------------------+---------------------------------------------------------+
!Nome              ! MADERO_PE_LOJA070.prw                                   !
+------------------+---------------------------------------------------------+
!Descricao         ! PONTO DE ENTRADA CADASTRO ADMINISTRADORAS FINANCEIRAS   !
+------------------+---------------------------------------------------------+
!Atualizado por    ! Paulo Gabriel F. Silva              			 		 !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 15/05/2018                                              !
+------------------+--------------------------------------------------------*/  


//Vai receber como parametro a empresa e Filial que vai ser executada.
Static Function LJA070PE(oModel)
Local lOpcao	:= .T.
Local cXEmp		:= ""
Local cXFil		:= ""
Local cQuery	:= ""
Local lNovo		:= .T.        
Local lEnvia    := .T.        
Local aAreaSAE  := GetArea()  
Local cFilADK   := Space(TamSx3("ADK_FILIAL")[1])

	// -> Posiciona na unidade de negócio
	dbSelectArea("ADK")
	ADK->( dbOrderNickName("ADKXFILI") )
	ADK->(dbGoTop())
	ADK->(dbseek(cFilADK+cFilAnt)) 

	cXEmp := ADK->ADK_XEMP  
	cXFil := ADK->ADK_XFIL
	lEnvia:= .T. 
    
	dbSelectArea("SE4")
	SE4->(dbSetOrder(1))
	SE4->(dbSeek(xFilial("SE4") + oModel:GetValue('SAEMASTER','AE_XCOD')))

    dbSelectArea("Z10")
	Z10->(dbSetOrder(1))
	If Z10->(dbSeek(xFilial("Z10") + oModel:GetValue('SAEMASTER','AE_XCOD')))
		lOpcao := .F.
		lEnvia := IIF(Z10->Z10_XSTINT == "P",.F.,.T.)
	EndIf


	If oModel:GetOperation() == 3 .Or. oModel:GetOperation() == 4
			Reclock("Z10",lOpcao)
				Z10->Z10_XFILI		:= cFilAnt
				Z10->Z10_CODIGO		:= SE4->E4_CODIGO  
				Z10->Z10_DESC       := SE4->E4_DESCRI
				Z10->Z10_XSTINT		:= "P"
				Z10->Z10_XEXC		:= "N"
			Z10->( MsUnlock() )
	ElseIf oModel:GetOperation() == 5
		//Marca Z10 como deletado
		//******************************************
		If !lOpcao .and. lEnvia
			Reclock("Z10",lOpcao)
			Z10->Z10_XSTINT		:= "P"
			Z10->Z10_XEXC		:= "S"
			Z10->(MsUnlock())	
		EndIf
	EndIf	             
		
    RestArea(aAreaSAE)

Return


/*---------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                          !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! PONTO DE ENTRADA                                        !
+------------------+---------------------------------------------------------+
!Modulo            ! FIN - FINANCEIRO                                        !
+------------------+---------------------------------------------------------+
!Nome              ! MADERO_PE_LOJA070.prw                                   !
+------------------+---------------------------------------------------------+
!Descricao         ! Valida se já existe administradora atrelada cond de pag !
+------------------+---------------------------------------------------------+
!Atualizado por    ! Paulo Gabriel F. Silva              			 		 !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 15/05/2018                                              !
+------------------+--------------------------------------------------------*/  
//Vai receber como parametro a empresa e Filial que vai ser executada.
User function VLDSAESE4()
Local lRet := .F.
Local cCodSE4 := M->AE_XCOD
Local aAreaSAE  := GetArea()  

	dbSelectArea("SAE")
	SAE->(dbSetOrder(4))
	SAE->(dbSeek(xFilial("SAE") + cCodSE4))
	
	If SAE->(Found())
		lRet := .T.
	Else
		lRet := .F.
	EndIf
    RestArea(aAreaSAE)
Return lRet

                        