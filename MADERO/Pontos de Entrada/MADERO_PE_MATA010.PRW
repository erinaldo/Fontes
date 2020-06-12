#include 'protheus.ch'
#include 'fwmvcdef.ch'


/*/{Protheus.doc} ITEM
Ponto de entrada da rotina de Cadastro de Produtos

@author Rafael Ricardo Vieceli
@since 02/03/2018
@version 1.0 
@return ${return}, ${return_description}

@type function
/*/
user function ITEM()

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

			//na validação total do formulario
			case cIdPonto == "FORMPOS"

				//validação dos itens
				If cIdModel == 'SB1MASTER'

					//se o produto controla Lote ou Sublote
					IF oModel:getValue('B1_RASTRO') $ "LS"
						IF oModel:getValue('B1_PRVALID') <= 0
							xRetorno := .F.
							Help("",1,"MADERO_PE_MATA010",,"O produto tem controle de Lote, então é obrigatório informar Prazo de Validade (B1_PRVALID).",4,1)
						EndIF
					EndIF

					If IsInCallStack( "U_EST001B" )
						If xRetorno
							U_EST001A( oModel ) 
						EndIf
					ElseIf ( IsInCallStack( "A010Inclui" ) .Or. IsInCallStack( "A010Copia" ) ) .And. !IsInCallStack( "U_EST001Grv" ) 
						xRetorno := U_EST001D( oModel )
					EndIf
				EndIF
				
			case cIdPonto == "MODELCOMMITTTS"
				
				Do Case
					Case oModel:GetOperation() == 3 .Or. oModel:GetOperation() == 4 .Or. oModel:GetOperation() == 5
						INTTEK(oModel)
				
				EndCase
				//*******************************************************
				
			case cIdPonto == "BUTTONBAR"
				xRetorno := {}

		endcase

	EndIF

return xRetorno



/*/{Protheus.doc} MTA010NC
Ponto de entrada para não copiar o campo de flag da integração

@author Rafael Ricardo Vieceli
@since 01/03/2018
@version 1.0
@return array, lista com os campos para não copiar

@type function
/*/
user function MTA010NC()

	Local aNoCopy := {}

	aAdd(aNoCopy, {"B1_XSTINT"})

return aNoCopy



Static Function INTTEK(oModel)
Local lOpcao	:= .T.
Local cXEmp		:= ""
Local cXFil		:= ""
Local cQuery	:= ""
Local lNovo		:= .T.        
Local lEnvia    := .T.        
Local aAreaSB1  := GetArea()  
Local cFilADK   := Space(TamSx3("ADK_FILIAL")[1])
Local cTpPdImp  := SUPERGETMV("MV_XTPDIMP",.F.,"PA/MP/ME/PI")
Local cTpIpImp  := SUPERGETMV("MV_XTIPIMP",.F.,"PA/PI/ME" )
	
	// -> Apenas executar o processo a baixo, se a filial 'é um restaurante'
	If !u_IsBusiness()  
		RestArea(aAreaSB1)
		Return
	Endif

	// -> Posiciona na unidade de negócio
	dbSelectArea("ADK")
	ADK->( dbOrderNickName("ADKXFILI") )
	ADK->(dbGoTop())
	ADK->(dbseek(cFilADK+cFilAnt)) 

	cXEmp := ADK->ADK_XEMP  
	cXFil := ADK->ADK_XFIL
	lEnvia:= .T. 
    
	dbSelectArea("Z13")
	Z13->(dbSetOrder(1))
	If Z13->(dbSeek(xFilial("Z13") + oModel:GetValue('SB1MASTER','B1_COD')))
		lOpcao := .F.
		lEnvia := IIF(Z13->Z13_XSTINT == "P",.F.,.T.)
	EndIf
		
	If oModel:GetOperation() == 3 .Or. oModel:GetOperation() == 4

		//Grava Z13
		//******************************************
		
		// -> Apenas marcar o cadastro de produto para integração, se o mesmo nao está pendente (item 124 da lista dependências)
		
		If oModel:GetValue('SB1MASTER','B1_TIPO') $ cTpPdImp
		
			If lEnvia
			
				If Empty( oModel:GetValue('SB1MASTER','B1_XCODEXT') ) .Or. !lOpcao
					Reclock("Z13",lOpcao)
					Z13->Z13_FILIAL		:= xFilial("Z13")
					Z13->Z13_XFILI		:= xFilial("SB1")
					Z13->Z13_COD		:= oModel:GetValue('SB1MASTER','B1_COD')
					Z13->Z13_DESC       := oModel:GetValue('SB1MASTER','B1_DESC')
					Z13->Z13_XSTINT		:= "P"
					Z13->Z13_XEXC		:= "N"
					Z13->Z13_XCDARV		:= IIF(!lOpcao,Z13->Z13_XCDARV,oModel:GetValue('SB1MASTER','B1_XN1') + oModel:GetValue('SB1MASTER','B1_XN2') + oModel:GetValue('SB1MASTER','B1_XN3') + oModel:GetValue('SB1MASTER','B1_XN4'))
					Z13->Z13_XEMP		:= ""
					Z13->Z13_XFIL		:= ""
					Z13->( MsUnlock() )
				Else
					Reclock("Z13",lOpcao)
					Z13->Z13_FILIAL		:= xFilial("Z13")
					Z13->Z13_XFILI		:= xFilial("SB1")
					Z13->Z13_COD		:= oModel:GetValue('SB1MASTER','B1_COD')  
					Z13->Z13_DESC       := oModel:GetValue('SB1MASTER','B1_DESC')
					Z13->Z13_XSTINT		:= "I"
					Z13->Z13_XEXC		:= "N"
					Z13->Z13_XCDARV		:= IIF(!lOpcao,Z13->Z13_XCDARV,oModel:GetValue('SB1MASTER','B1_XN1') + oModel:GetValue('SB1MASTER','B1_XN2') + oModel:GetValue('SB1MASTER','B1_XN3') + oModel:GetValue('SB1MASTER','B1_XN4'))
					Z13->Z13_XEMP		:= ""
					Z13->Z13_XFIL		:= ""
					Z13->Z13_XDINT		:= Date()
					Z13->Z13_XHINT		:= Time()
					Z13->Z13_XCODEX		:= oModel:GetValue('SB1MASTER','B1_XCODEXT')
					Z13->(MsUnlock())
				EndIf
			EndIf
			//******************************************
									
			//Grava Z17 - PutProdutosAtivar
			//******************************************
			dbSelectArea("Z17")
			Z17->(dbSetOrder(1))
			Z17->(dbSeek(xFilial("Z17")+Z13->Z13_COD))	
			If !Z17->(found())
				If Empty( oModel:GetValue('SB1MASTER','B1_XCODEXT') )
					RecLock("Z17",.T.)
					Z17->Z17_FILIAL		:= xFilial("Z17")
					Z17->Z17_COD		:= Z13->Z13_COD
					// Z17->Z17_DESC       := Z13->Z13_DESC
					Z17->Z17_XCODEX     := IIF(!lOpcao,Z13->Z13_XCODEX,"")
					Z17->Z17_XSTINT		:= "P"
					Z17->Z17_XCDARV		:= Z13->Z13_XCDARV
					Z17->Z17_XEMP		:= cXEmp
					Z17->Z17_XFIL		:= cXFil
					Z17->Z17_XATIVO		:= If(oModel:GetValue('SB1MASTER','B1_MSBLQL')<>"1","S","N")
					Z17->( msUnLock())
				Else
					If ProcName(13) == "U_EST001GRV" // Verificar se e replica
						RecLock("Z17",.T.)
						Z17->Z17_FILIAL		:= xFilial("Z17")
						Z17->Z17_COD		:= Z13->Z13_COD
						// Z17->Z17_DESC       := Z13->Z13_DESC
						Z17->Z17_XCODEX     := oModel:GetValue('SB1MASTER','B1_XCODEXT')
						Z17->Z17_XSTINT		:= "P"
						Z17->Z17_XCDARV		:= Z13->Z13_XCDARV 
						Z17->Z17_XEMP		:= cXEmp
						Z17->Z17_XFIL		:= cXFil
						Z17->Z17_XATIVO		:= If(oModel:GetValue('SB1MASTER','B1_MSBLQL')<>"1","S","N")
						Z17->( msUnLock())
					Else
						RecLock("Z17",.T.)
						Z17->Z17_FILIAL		:= xFilial("Z17")
						Z17->Z17_COD		:= Z13->Z13_COD
						// Z17->Z17_DESC       := Z13->Z13_DESC
						Z17->Z17_XCODEX     := oModel:GetValue('SB1MASTER','B1_XCODEXT')
						Z17->Z17_XSTINT		:= "I"
						Z17->Z17_XCDARV		:= Z13->Z13_XCDARV 
						Z17->Z17_XDINT		:= Date()
						Z17->Z17_XHINT		:= Time()
						Z17->Z17_XEMP		:= cXEmp
						Z17->Z17_XFIL		:= cXFil
						Z17->Z17_XATIVO		:= If(oModel:GetValue('SB1MASTER','B1_MSBLQL')<>"1","S","N")
						Z17->( msUnLock())
					EndIf
				EndIf
			Else
				RecLock("Z17",.F.)
				Z17->Z17_XSTINT		:= "P"
				Z17->Z17_XATIVO		:= If(oModel:GetValue('SB1MASTER','B1_MSBLQL')<>"1","S","N")
				Z17->( msUnLock())
			EndIf
			//******************************************
			//Marca Z16 - PutImpostos para 
			//******************************************
			
			// -> Gera dados para integração, apenas se o produto for para revenda (PA/PI/ME), conforme item 122 da lista de pendências
			If oModel:GetValue('SB1MASTER','B1_TIPO') $ cTpIpImp
	
				dbSelectArea("Z16")
				Z16->(dbSetOrder(2))
				Z16->(dbSeek(xFilial("Z16") + oModel:GetValue('SB1MASTER','B1_COD') ))
			
				If Z16->(found())
					lNovo := .F.
				EndIf
			
				If !Empty(oModel:GetValue('SB1MASTER','B1_GRTRIB')) .Or. !lNovo
	
					RecLock("Z16",lNovo)
				
					Z16->Z16_FILIAL		:= xFilial("Z16")
					If !Empty(oModel:GetValue('SB1MASTER','B1_GRTRIB'))
						Z16->Z16_GRPTRI		:= oModel:GetValue('SB1MASTER','B1_GRTRIB')
					EndIf
					Z16->Z16_COD 		:= oModel:GetValue('SB1MASTER','B1_COD')
					Z16->Z16_DESC       := oModel:GetValue('SB1MASTER','B1_DESC')
					Z16->Z16_XSTINT		:= "P"
					Z16->Z16_XEXC		:= "N"
					Z16->Z16_XEMP		:= cXEmp
					Z16->Z16_XFIL		:= cXFil
					Z16->Z16_XATIVO		:= If(oModel:GetValue('SB1MASTER','B1_MSBLQL')<>"1","S","N")
					Z16->( msUnLock())	
				
					If !Empty(oModel:GetValue('SB1MASTER','B1_GRTRIB'))					
				
						//Marca todos os Produtos do Grupo para reenviar
						cQuery += "	SELECT R_E_C_N_O_ AS REGNO " + CRLF
						cQuery += "	FROM " + RetSqlName("Z16") + " Z16 " + CRLF 
						cQuery += "	WHERE " + CRLF 
						cQuery += "			Z16_FILIAL = '" + xFilial("Z16") + "' " + CRLF 
						cQuery += "		AND Z16_GRPTRI = '" + oModel:GetValue('SB1MASTER','B1_GRTRIB') + "' " + CRLF
						cQuery += "		AND Z16.D_E_L_E_T_ = ' ' " + CRLF 
					
						cQuery := ChangeQuery(cQuery)
						//cAlZ16 := MPSysOpenQuery(cQuery)
						cAlZ16 := "Z16Qry"
						dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery), cAlZ16,.F.,.T.)		
					
						While  !(cAlZ16)->(Eof())	
						
							Z16->(dbGoTo((cAlZ16)->REGNO))
						
							RecLock("Z16",.F.)
							Z16->Z16_XSTINT		:= "P"
							Z16->( msUnLock())	
						
							(cAlZ16)->(dbSkip())
					
						EndDo
					
						(cAlZ16)->(dbCloseArea())
				
					EndIf
			
				EndIf
			Else
				dbSelectArea("Z16")
				Z16->(dbSetOrder(2))
				Z16->(dbSeek(xFilial("Z16")+oModel:GetValue('SB1MASTER','B1_COD')))	
				If Z16->(found()) .And. Z16->Z16_XSTINT == 'P'
					Reclock("Z16",.F.)
						Z16->(dbDelete())
					Z16->(MsUnlock())
				EndIf
			EndIf
			//******************************************
		Else
			// If !lOpcao .And. !lEnvia
			// 	Reclock("Z13",.F.)
			// 		Z13->(dbDelete())
			// 	Z13->(MsUnlock())
			// EndIf

			dbSelectArea("Z17")
			Z17->(dbSetOrder(1))
			Z17->(dbSeek(xFilial("Z17")+oModel:GetValue('SB1MASTER','B1_COD')))	
			If Z17->(found()) .And. Z17->Z17_XSTINT == 'P'
				Reclock("Z17",.F.)
					Z17->(dbDelete())
				Z17->(MsUnlock())
			EndIf

			dbSelectArea("Z16")
			Z16->(dbSetOrder(2))
			Z16->(dbSeek(xFilial("Z16")+oModel:GetValue('SB1MASTER','B1_COD')))	
			If Z16->(found()) .And. Z16->Z16_XSTINT == 'P'
				Reclock("Z16",.F.)
					Z16->(dbDelete())
				Z16->(MsUnlock())
			EndIf
		EndIf
		



	ElseIf oModel:GetOperation() == 5
	
		// //Marca Z13 como deletado
		// //******************************************
		// If !lOpcao .and. lEnvia
		// 	Reclock("Z13",lOpcao)
		// 	Z13->Z13_XSTINT		:= "P"
		// 	Z13->Z13_XEXC		:= "S"
		// 	Z13->(MsUnlock())	
		// EndIf	
		// //******************************************
		
		//Exclui Z17 - PutProdutosAtivar
		//******************************************
		dbSelectArea("Z17")
		Z17->(dbSetOrder(1))
		Z17->(dbGoTop())
		Z17->(dbSeek(xFilial("Z17")+Z13->Z13_COD))
		
		If Z17->(found())
			RecLock("Z17",.F.)
			Z17->(dbDelete())
			Z17->(msUnLock())
		EndIf
		//******************************************
		//Marca Z16 - PutImpostos para 
		//integrar novamente
		//******************************************

		// -> Gera dados para integração, apenas se o produto for para revenda (PA/PI/ME), conforme item 122 da lista de pendências
		dbSelectArea("Z16")
		Z16->(dbSetOrder(2))
		Z16->(dbGoTop())
		Z16->(dbSeek(xFilial("Z16")+Z13->Z13_COD))
		
		If Z16->(found())
			RecLock("Z16",.F.)
			Z16->(dbDelete())
			Z16->(msUnLock())
		EndIf
		
	EndIf	             
		
    RestArea(aAreaSB1)

Return
                                                        


/*                                                    
+------------------+-------------------------------------------------------------------------------+
! Nome             ! MTA010MNU                                                                     !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! PE para adicionar botões a rotina de cadastro de produtos                     !
!                  !                                                                               !
+------------------+-------------------------------------------------------------------------------+
*/ 

//User Function MTA010MNU( )
//Local nX := 0

//For nX := 1 to Len(aRotina)
//	If Upper( aRotina[nX, 2] ) == "A010WIZFAC" .And. aRotina[nX, 4] == 4
//		aRotina[nX, 2] := "U_EST001B"
//	 	Exit
//	EndIf
//Next nX
//Return



/*
+----------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                          !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Atualização                                             !
+------------------+---------------------------------------------------------+
!Modulo            ! PCP - PLANEJAMENTO E CONTROLE DE PRODUÇÃO               !
+------------------+---------------------------------------------------------+
!Nome              ! MA010BRW                                                !
+------------------+---------------------------------------------------------+
!Descricao         ! P.E. que irá chamar o Cadastro de Produtos X Etiquetas  !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 17/06/2018                                              !
+------------------+---------------------------------------------------------+
*/
User Function MT010BRW()
Local nX := 0

AAdd(aRotina,{"Replicar" , "U_EST001"    , 0, 2 } )
AAdd(aRotina,{"Etiquetas", "U_APCP105(2)", 0, 4 } )
AAdd(aRotina,{"Importar" , "U_IMPORT01", 0, 3 } )

For nX := 1 to Len(aRotina)
	If Upper( aRotina[nX, 2] ) == "A010WIZFAC" .And. aRotina[nX, 4] == 4
		aRotina[nX, 2] := "U_EST001B"
	 	Exit
	EndIf
Next nX

Return(aRotina)

