#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMBROWSE.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} ASTIN034
Ponto de entrada no final da exclusao de um titulo a receber para realizar
o tratamento de exclusao dos titulos parciais gerados a partir do titulo
posicionado
@return	Nenhum			
@author	Carlos Gorgulho
@since		03/03/2017
@version	12.1.7
/*/
//-------------------------------------------------------------------

User Function ASTIN034() //F0103004()

Local lMsHelpAuto	:= .T.
Local nRecTitPar 	:= 0
Local lRet			:= .T.
Local aBaixa		:= {}
Local nValor        := 0

Private lMsErroAuto := .F.            

//Verifica se posicionado o titulo é parcial
If !Empty(SE1->E1_XVINCP)
	//Verifica se o titulo possui alguma baixa, caso possua não pode ser excluido 
	If Empty(SE1->E1_BAIXA)

		nRecTitPar 	:= Recno()
		nSaldo		:= SE1->E1_VALOR		
		
		BEGIN TRANSACTION
		
		//Busca o titulo origem do titulo parcial para cancelar a baixa parcial			
		SE1->(DbSetOrder(1))
		If SE1->(DbSeek(SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_XVINCP+SE1->E1_PARCELA))
		   //Cancela baixa titulos de origem
			dbselectarea("SE5")
			dbsetorder(7)
			If 	dbseek(xFilial("SE5")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE+SE1->E1_LOJA)					                                                                                        
				aBaixa := {}
				aBaixa := {{"E1_PREFIXO"		, SE5->E5_PREFIXO 					,Nil},;
					      	{"E1_NUM"			, SE5->E5_NUMERO     				,Nil},;
					        {"E1_PARCELA"		, SE5->E5_PARCELA  					,Nil},;
					        {"E1_TIPO"	    	, SE5->E5_TIPO     					,Nil},;
							{"AUTMOTBX"		    , SE5->E5_MOTBX					   	,Nil},;
							{"AUTDTBAIXA"		, SE5->E5_DATA						,Nil},;
							{"AUTDTCREDITO" 	, SE5->E5_DTDISPO					,Nil},;
							{"AUTHIST"	    	, "Titulo parcial foi excluido" 	,Nil},; 
							{"AUTVALREC"		, nSaldo							,Nil}}				


		    	//Para interface com RM
		    	//Altera = .F. Cancela Baixa
	    		//Altera = .T. Baixa Titulo

				If	valType(ALTERA) <> "U"
					ALTERA := .F.
				EndIf
	    	
				lMsErroAuto := .F.		
				MSExecAuto({|x,y| Fina070(x,y)},aBaixa,5) // 5 - Cancelamento de baixa
		    	If 	lMsErroAuto .Or. !Empty(SE5->E5_NUMERO)
       				lRet := .F.
					AutoGrLog( "Problema no Cancelamento da Baixa." )
					MostraErro()
       				DisarmTransaction()
		           	Break 
				Else
					Reclock("SE1")
					SE1->E1_XPARCL := ""
					SE1->E1_XVINCP := ""
					SE1->(MsUnlock())		
				EndIf			
			Else
				lRet := .F.
				MsgAlert("Registro de baixa não foi localizado na tabela de baixas.(SE5)","Titulo Parcial")
			EndIf
		Else	
			lRet := .F.
			MsgAlert("Titulo origem não localizado.","Titulo Parcial")				
		EndIf

		If lRet
			//Limpo o vinculo do titulo com o titulo origem
			If nRecTitPar > 0
				dbGoTo( nRecTitPar )
				Reclock("SE1")
				SE1->E1_XPARCL := ""
				SE1->E1_XVINCP := ""
				SE1->(MsUnlock())				
			EndIf				
		EndIf
	
		END TRANSACTION	
	
	Else
		MsgAlert("Titulo Nr.: "+SE1->E1_NUMERO+" ja possui baixa. Não é permitida a exclusão de titulos parciais que já sofreram baixas.","Titulo Parcial")
	EndIf
		
EndIf

Return()