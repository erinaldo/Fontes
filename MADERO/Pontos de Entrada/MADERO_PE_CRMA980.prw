#include 'protheus.ch'



/*/{Protheus.doc} MATA980
Ponto de entrada da rotina nova (MVC) de Cadastro de Clientes

#1 Atualiza A1_XSTINT como P=Pendente na Inclusão e Alteração
 
@author Rafael Ricardo Vieceli
@since 06/03/2018
@version 1.0

@type function
/*/
user function CRMA980()
Local oModel  //ParamIXB[1]
Local cIdPonto //ParamIXB[2]
Local cIdModel //ParamIXB[3]
Local xRetorno  := .T.
Local lOpcao	:= .T.
Local lGeraZ11  := .F.
Local cXEmp		:= ""
Local cXFil		:= ""

	If ! Empty(ParamIXB)

		oModel   := ParamIXB[1]
		cIdPonto := ParamIXB[2]
		cIdModel := ParamIXB[3]

		do case

			//na validação total do formulario
			case cIdPonto == "FORMPOS"

			case cIdPonto == "MODELCOMMITTTS"
			
				// -> Apenas executar o processo a baixo, se a filial 'é um restaurante'
				If u_IsBusiness()  
				
					//Chama rotina para tratar integração com Teknisa
					//*******************************************************
					If oModel:GetValue('SA1MASTER','A1_TIPO') == "F"
				
						dbSelectArea("Z11")
						Z11->(dbGoTop())
						Z11->(dbSetOrder(1))
						If Z11->(dbSeek(xFilial("Z11") + oModel:GetValue('SA1MASTER','A1_COD') + oModel:GetValue('SA1MASTER','A1_LOJA') ))
							lOpcao := .F.
							// -> Verifica se o registro na tabela Z11 está pendente para alteração, caso contrário marca para alteração
							lGeraZ11:=IIF(Z11->Z11_XSTINT == "I",.T.,.F.)
						Else
							lOpcao 	:=.T.
							lGeraZ11:=.T.
						EndIf
					
						//Posiciona na Unidade de Negócio
						dbSelectArea("ADK")
						ADK->( dbOrderNickName("ADKXFILI") )
						ADK->(dbseek(xFilial("ADK")+cFilAnt))
						
						cXEmp := IIF(Empty(xFilial("Z11")),"",ADK->ADK_XEMP)  
						cXFil := IIF(Empty(xFilial("Z11")),"",ADK->ADK_XFIL) 
					
						// -> Se for inclusão e/ou alteração
						If (oModel:GetOperation() == 3 .Or. oModel:GetOperation() == 4) .and. lGeraZ11
						
							dbSelectArea("Z12")
							Z12->(dbGoTop())
							Z12->(dbSetOrder(2))
							If Z12->(dbSeek(xFilial("Z12") + oModel:GetValue('SA1MASTER','A1_CGC') )) .And. oModel:GetOperation() == 3
								Reclock("Z11",lOpcao)
								Z11->Z11_FILIAL		:= xFilial("Z11")
								Z11->Z11_XFILI		:= cFilAnt
								Z11->Z11_COD		:= oModel:GetValue('SA1MASTER','A1_COD')
								Z11->Z11_LOJA		:= oModel:GetValue('SA1MASTER','A1_LOJA')
								Z11->Z11_DESC       := oModel:GetValue('SA1MASTER','A1_NOME')
								Z11->Z11_XSTINT		:= "I"
								Z11->Z11_XEMP		:= cXEmp
								Z11->Z11_XFIL		:= cXFil
								Z11->Z11_XEXC		:= "N"
								Z11->Z11_XCLIEN		:= Z12->Z12_CLIEN
								Z11->Z11_XCONSU		:= Z12->Z12_CONSU
								Z11->(MsUnlock())
							Else
								dbSelectArea("ADK")
								ADK->(dbSetOrder(3))
								ADK->(dbseek(xFilial("ADK")+oModel:GetValue('SA1MASTER','A1_CGC')))
								If !ADK->(Found())
									Reclock("Z11",lOpcao)
										Z11->Z11_FILIAL		:= xFilial("Z11")
										Z11->Z11_XFILI		:= cFilAnt
										Z11->Z11_COD		:= oModel:GetValue('SA1MASTER','A1_COD')
										Z11->Z11_LOJA		:= oModel:GetValue('SA1MASTER','A1_LOJA')
										Z11->Z11_DESC       := oModel:GetValue('SA1MASTER','A1_NOME')
										Z11->Z11_XSTINT		:= "P"
										Z11->Z11_XEMP		:= cXEmp
										Z11->Z11_XFIL		:= cXFil
										Z11->Z11_XEXC		:= "N"
									Z11->(MsUnlock())
								EndIf
							EndIf
						ElseIf oModel:GetOperation() == 5 .and. !lOpcao .and. lGeraZ11
							Reclock("Z11",lOpcao)
							Z11->Z11_XSTINT		:= "P"
							Z11->Z11_XEXC		:= "S"
							Z11->(MsUnlock())	
						EndIf	
					
					EndIf
				
				EndIf
					
				//*******************************************************				
				//Customização feits por Emerson - SMS
				//*******************************************************
				
				//Chama função para atualiza tabela CTH referente a classe de valor
				If INCLUI .Or. ALTERA
					ATUACTH()
				ElseIf oModel:NOPERATION == 5 //Exclusão
					//Chama a rotina para exclusão, neste ponto as validações já foram executadas
					EXCLCHT()
				EndIf
				//*******************************************************

			case cIdPonto == "MODELPRE"
				
				//Customização feits por Emerson - SMS
				//*******************************************************
				 If oModel:NOPERATION == 5 //Exclusão
					xRet := !EXISTCTH() //Existe registros na CTH nos lançamentos contabeis?
					If !xRet
						 Help( ,, 'CRMA980 - Não Permitido!',, "Existem lançamentos contábeis com a classe de valor C" + SA1->A1_COD + SA1->A1_LOJA + " vinculada ao cliente.", 1, 0 )
					EndIf
				EndIf
				//*******************************************************

				
			case cIdPonto == "BUTTONBAR"

				xRetorno := {}

		endcase

	EndIf

return xRetorno


/*/{Protheus.doc} CRM980MDef
@author Emerson SMSTI
@since 02/07/2018
/*/
User Function CRM980MDef()
	Local aRotina := {}
	//----------------------------------------------------------------------------------------------------------
	// [n][1] - Nome da Funcionalidade
	// [n][2] - Função de Usuário
	// [n][3] - Operação (1-Pesquisa; 2-Visualização; 3-Inclusão; 4-Alteração; 5-Exclusão)
	// [n][4] - Acesso relacionado a rotina, se esta posição não for informada nenhum acesso será validado
	//----------------------------------------------------------------------------------------------------------
	aAdd(aRotina,{"Carregar Classe de Valor" ,"U_XM030CTH(1)",0,6})
	aAdd(aRotina,{"Excluir Classe de Valor" ,"U_XM030CTH(2)",0,6})
	aAdd(aRotina,{"Importar" ,"U_IMPORT03()",0,3})
Return( aRotina )

/*/{Protheus.doc} FACILCTH
//TODO Função criada para realizar a analise nos cadastros dos clientes na tabela SA1 verificando se existe cadastro na CTH e realiza a exclusão ou inclusão conforme parametro recebido
@author Emerson SMSTI
@since 02/07/2018
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

/*/{Protheus.doc} ATUACTH
//TODO Função criada para atualizar tabela CTH referente a classe de valor
@author Emerson SMSTI
@since 02/07/2018
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

/*/{Protheus.doc} EXCLCHT
//TODO Função criada para realizar a exclusão da classe de valor na CTH
@author Emerson SMSTI
@since 02/07/2018
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

/*/{Protheus.doc} EXISTCTH
//TODO Função criada para validar se existem movimentações contabeis com a classe de valor.
@author Emerson SMSTI
@since 02/07/2018
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
