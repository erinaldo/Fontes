#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMBROWSE.CH"
//-------------------------------------------------------------------
/*/{Protheus.doc} ASTIN025
Chamado pelo PE SACI008
Efetiva baixa do aglutinado e origem
@return		Nenhum			
@author		Nivia Ferreira
@since		24/02/2017
@version	12
/*/
//-------------------------------------------------------------------
User Function ASTIN025() //F0102005()

Local aAreas 			:= { SE1->(GetArea()), GetArea() }
Local aBaixa 			:= {}
Local cChavBor			:= ''
Local nSeqE5    		:= ''
Local cQuery			:= ''
Local lRet				:= .T.
Local lBor				:= .T.
Local lAchou			:= .F.
Local nJuros			:= 0
Local nMulta	    	:= 0
Local nValor			:= 0
Local nValorAbatimentos	:= 0
Local nValorDocumento	:= 0
Local dVenci			:= ctod("  /  /  ") 
Local dData				:= ctod("  /  /  ") 
Local dDataBaix			:= ctod("  /  /  ") 
Local cAliasSE5 		:= getNextAlias()
Local cMotivC			:= "Cancelamento baixa título renegociado (origem)"
Local cMotivB			:= "Baixa título renegociado (origem)"
Local cChave 			:= SE1->E1_NUM+SE1->E1_TIPO+SE1->E1_NATUREZ+SE1->E1_CLIENTE+SE1->E1_LOJA 
Local cChaveSE5			:= ''

Private lMsErroAuto 	:= .F.


//Se titulo renegociado (aglutinado)
//IF	!ISINCALLSTACK( 'U_F0102008' ) .And. !ISINCALLSTACK( 'FINA200' )  
IF	!ISINCALLSTACK( 'U_ASTIN028' ) .And. !ISINCALLSTACK( 'FINA200' )  
	IF	SE1->E1_XAGLUT == '1' .And. Empty(SE1->E1_XTITAGL) 
		
		cChavBor 	:= SE1->E1_NUMBOR+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO //+SE1->E1_CLIENTE+SE1->E1_LOJA
	    dVenci      := SE1->E1_VENCTO
		nReg 		:= SE1->(Recno())	
		nSeqE5  	:= SE5->E5_SEQ
	 	
		SE1->(DbOrderNickName("RENEGOCIA"))
		//E1_FILIAL+E1_PREFIXO+E1_TIPO+E1_XTITAGL  
		SE1->(msSeek(xFilial("SE1") + cChave ))
		
		Begin Transaction
		
		While !SE1->(Eof()) .And. xFilial('SE1') == SE1->E1_FILIAL .and.;
		    cChave == SE1->E1_XTITAGL+SE1->E1_TIPO+SE1->E1_NATUREZ+SE1->E1_CLIENTE+SE1->E1_LOJA
		    
	
	        //Localiza Bordero do titulo de origem
			dbselectarea("SEA")
			dbsetorder(1)
			If 	dbseek(xFilial("SEA")+ cChavBor)
	
		        //Cancela baixa titulos de origem
				dbselectarea("SE5")
				dbsetorder(7)
				If 	dbseek(xFilial("SE5")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE+SE1->E1_LOJA)
				
					cQuery := "SELECT E5_MOTBX "
	    			cQuery += " FROM "
	    			cQuery +=  RetSqlName("SE5")+ " SE5 "
					cQuery += " WHERE "
					cQuery += " SE5.E5_FILIAL = '"+FWXFILIAL("SE5") +"'"	
					cQuery += " And E5_CLIENTE='" + SE5->E5_CLIENTE +"'"
					cQuery += " And E5_LOJA='" + SE5->E5_LOJA +"'"
					cQuery += " And E5_NUMERO='" + SE5->E5_NUMERO +"'"
					cQuery += " And E5_PARCELA='" + SE5->E5_PARCELA +"'"
					cQuery += " And E5_PREFIXO='" + SE5->E5_PREFIXO +"'"
					cQuery += " And E5_TIPO='" +    SE5->E5_TIPO +"'"
					//cQuery += " And E5_MOTBX='NOR'"
					cQuery += " And SE5.D_E_L_E_T_ = ' ' " 	 
					cQuery := ChangeQuery(cQuery)
					dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAliasSE5,.F.,.T.)
					IF	(cAliasSE5)->( EOF() ) 
						lACHOU := .F.
					Else
						IF	(cAliasSE5)->E5_MOTBX == 'NOR'		
							lACHOU := .T.
						Else
							lACHOU := .F.
						EndIf
					EndIf	
					(cAliasSE5)->(DbCloseArea())
					
					IF	!lAchou                                                                                         
						aBaixa := {}
						aBaixa := {	{"E1_PREFIXO"  	,SE5->E5_PREFIXO 	,Nil},;
									{"E1_NUM"	   	,SE5->E5_NUMERO  	,Nil},; 
									{"E1_TIPO"	   	,SE5->E5_TIPO       ,Nil},;
									{"E1_CLIENTE"	,SE5->E5_CLIENTE	,Nil},;
									{"AUTMOTBX"	   	,SE5->E5_MOTBX		,Nil},;
									{"AUTDTBAIXA"  	,dDataBase          ,Nil},;
									{"AUTDTCREDITO"	,dDataBase          ,Nil},;
									{"AUTHIST"	   	,cMotivC			,Nil},; 
									{"AUTBANCO"    	,SE5->E5_BANCO      ,Nil},;
									{"AUTAGENCIA"  	,SE5->E5_AGENCIA    ,Nil},;
									{"AUTCONTA"    	,SE5->E5_CONTA      ,Nil},;
									{"AUTVALREC"	,SE5->E5_VALOR	    ,Nil,.f. } }
									
			    		//Para interface com RM
				   		//Altera = .F. Cancela Baixa
			    		//Altera = .T. Baixa Titulo
			
						If	valType(ALTERA) <> "U"
							ALTERA := .F.
						EndIf
			    	
			    		lMsErroAuto := .F.
			    		//para baixas parciais, utilizar o ponto de entrada "F070BAUT"
						MSExecAuto({|x,y| Fina070(x,y)},aBaixa,5) //5 - Cancelamento de baixa
						
		            	IF 	lMsErroAuto .Or. !Empty(SE1->E1_BAIXA)
		  					lRet := .F.
		  					AutoGrLog( "Problema no Cancelamento de baixa de título renegociado (origem)." )
							MostraErro()
		                	DisarmTransaction()
		                	Break 
						Else
			        		//Baixa titulos de origem, atraves de baixa normal
			        		
			        		nValorAbatimentos :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
							//calculo valor total
							nValorDocumento := Round((((SE1->E1_SALDO+SE1->E1_ACRESC)-SE1->E1_DECRESC)*100)-(nValorAbatimentos*100),0)/100
					
							IF 	SE1->E1_VENCREA < dVenci //.And. Type('lBolVencido') == 'L' .And. lBolVencido
					
								//multa VALOR * 2.00 / 100
								nMulta := Round(nValorDocumento * SE1->E1_PORCJUR / 100,2)
				
								//juros VALOR * 0.033 / 100 * DIAS VENCIDO
								nJuros := Round((nValorDocumento * (SE1->E1_VALJUR / 100)) * (dVenci - SE1->E1_VENCREA),2)
		
							EndIF
					
							//atualiza valor total
					        nValor := 0
							nValor := nMulta + nJuros + SE1->E1_VALOR
							nMulta := 0
							nJuros := 0
			   
			   				dDataBaix :=  DBAIXA    		
							aBaixa := {}
		    	        	Aadd(aBaixa, {"E1_PREFIXO" , SE1->E1_PREFIXO , nil})
		        	    	Aadd(aBaixa, {"E1_NUM"     , SE1->E1_NUM 	 , nil})
		            		Aadd(aBaixa, {"E1_PARCELA" , SE1->E1_PARCELA , nil})
		            		Aadd(aBaixa, {"E1_TIPO"    , SE1->E1_TIPO  	 , nil})                           
		            		Aadd(aBaixa, {"E1_CLIENTE" , SE1->E1_CLIENTE , nil})
		            		Aadd(aBaixa, {"E1_LOJA"    , SE1->E1_LOJA 	 , nil})
		            		Aadd(aBaixa, {"AUTBANCO"   , SEA->EA_PORTADO , nil})
		            		Aadd(aBaixa, {"AUTAGENCIA" , SEA->EA_AGEDEP	 , nil})
		            		Aadd(aBaixa, {"AUTCONTA"   , SEA->EA_NUMCON	 , nil})
		            		Aadd(aBaixa, {"AUTMOTBX"   , "NOR"           , nil})
		            		Aadd(aBaixa, {"AUTDTBAIXA" , dVenci		     , nil})
		            		//Aadd(aBaixa, {"AUTDTBAIXA" , DBAIXA		     , nil})
		            		Aadd(aBaixa, {"AUTDTCREDITO",DDTCREDITO		 , nil})
		            		Aadd(aBaixa, {"AUTHIST"    , cMotivB	     , nil})                   
		                	Aadd(aBaixa, {"AUTVALREC"  , nValor          , nil})    
		        			lMsErroAuto := .F.
		        
		            		//Para interface com RM
				    		//Altera = .F. Cancela Baixa
			    			//Altera = .T. Baixa Titulo
		        		
		        			If	valType(ALTERA) <> "U"
								ALTERA := .T.
							EndIf
		
							dData 	  	:= ddatabase
							ddatabase 	:= dVenci
							lMsErroAuto := .F.        		
		        			MSExecAuto({|a,b| fina070(a,b)},aBaixa,3) // 3 - Baixa de Título
		        			ddatabase := dData
			            	
			            	IF 	lMsErroAuto .Or. Empty(SE1->E1_BAIXA)
			            		lRet := .F.
		  						AutoGrLog( "Problema na Integração com RM, baixa do título não concluido." )
								MostraErro()
		            	    	DisarmTransaction()
		                		Break 
							Else
								RecLock("SE1",.F.)
								SE1->E1_BAIXA  := dDataBaix
								SE1->(MsUnlock())
								
								cChaveSE5 := SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE+SE1->E1_LOJA
								dbselectarea("SE5")
								dbsetorder(7)
								dbseek(xFilial("SE5")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE+SE1->E1_LOJA)
								
								While !SE5->(Eof()) .And. xFilial('SE5') == SE5->E5_FILIAL .and.;
		    						cChaveSE5 == SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA
								
									IF	Empty(SE5->E5_SITUACA) .And. SE5->E5_MOTBX == 'NOR'
										RecLock("SE5",.F.)
										SE5->E5_DATA  := dDataBaix
										SE5->(MsUnlock())
									EndIf
									SE5->(dbSkip())
								Enddo	 
		            		EndIf
		            	EndIf
		            	
	            	EndIf	
				EndIf 
			Else	
				lRet := .F.   
				lBor := .F.
				DisarmTransaction()
	       		Break 
	        Endif
	
			SE1->(dbSkip())
		EndDo
		End Transaction
	
		If	!lBor
			MsgAlert("Bordero não localizado, processo cancelado.")
		Else
	
			//Verifica se Titulo foi baixado "NOR"
			SE1->(dbGoTo(nReg))
			cQuery := "SELECT E1_NUM,E5_SEQ "
	    	cQuery += " FROM "
	    	cQuery += RetSqlName("SE1")+ " SE1, " + RetSqlName("SE5")+ " SE5 "
			cQuery += " WHERE "
			cQuery += " SE1.E1_FILIAL = '"+FWXFILIAL("SE1") +"'"
			cQuery += " And SE5.E5_FILIAL = '"+FWXFILIAL("SE5") +"'"	
			cQuery += " And E1_XTITAGL='" + SE1->E1_NUM +"'"
			cQuery += " And E1_CLIENTE='" + SE1->E1_CLIENTE +"'"
			cQuery += " And E1_LOJA='" + SE1->E1_LOJA +"'"
			cQuery += " And E1_PREFIXO='" + SE1->E1_PREFIXO +"'"
			cQuery += " And E1_TIPO='" + SE1->E1_TIPO +"'"
			cQuery += " And E1_CLIENTE=E5_CLIENTE "
			cQuery += " And E1_LOJA=E5_LOJA"
			cQuery += " And E1_NUM=E5_NUMERO"
			cQuery += " And E1_TIPO=E5_TIPO"
			cQuery += " And E1_PREFIXO=E5_PREFIXO"
			cQuery += " And E5_MOTBX='NOR'"
			cQuery += " And SE1.D_E_L_E_T_ = ' '" 
			cQuery += " And SE5.D_E_L_E_T_ = ' ' " 	 
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAliasSE5,.F.,.T.)
	                                                             
			IF	(cAliasSE5)->( EOF() ) .OR. Empty((cAliasSE5)->E1_NUM)
				lRet	:= .F.
				MsgAlert("Titulo não foi baixado, processo cancelado.")
			EndIf	
			(cAliasSE5)->(DbCloseArea())
		EndIf
		
			
		If	!lRet
			SE1->(dbGoTo(nReg))	
	
			dbselectarea("SE5")
			dbsetorder(7)
			If 	dbseek(xFilial("SE5")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE+SE1->E1_LOJA+nSeqE5)
					       
				aCabec := {}
				aCabec := {	{"E1_PREFIXO"  	,SE5->E5_PREFIXO 	,Nil},;
							{"E1_NUM"	   	,SE5->E5_NUMERO  	,Nil},; 
							{"E1_TIPO"	   	,SE5->E5_TIPO       ,Nil},;
							{"E1_CLIENTE"	,SE5->E5_CLIENTE	,Nil},;
							{"AUTMOTBX"	   	,SE5->E5_MOTBX		,Nil},;
							{"AUTBANCO"    	,SE5->E5_BANCO      ,Nil},;
							{"AUTAGENCIA"  	,SE5->E5_AGENCIA    ,Nil},;
							{"AUTCONTA"    	,SE5->E5_CONTA      ,Nil},;
							{"AUTDTBAIXA"  	,dDataBase          ,Nil},;
							{"AUTDTCREDITO"	,dDataBase          ,Nil},;
							{"AUTHIST"	   	,cMotivC			,Nil},; 
							{"AUTVALREC"	,SE5->E5_VALOR	    ,Nil,.f. } }
	    	
	   			//Para interface com RM
	   			//Altera = .F. Cancela Baixa
	   			If	valType(ALTERA) <> "U"
					ALTERA := .F.
				EndIf
		    		    	
	   			//para baixas parciais, utilizar o ponto de entrada "F070BAUT"
	   			lMsErroAuto := .F.
	   			MSExecAuto({|x,w,y,z| fina070(x,w,y,z)},aCabec,5)//5 - Cancelamento de baixa
		    			
	   			IF	lMsErroAuto 
	        		lRet := .F.
					AutoGrLog( "Problema no Cancelamento da Baixa." )
					MostraErro()
				EndIf
			EndIf	
		EndIf	
	EndIf		
EndIf	
			
AEval(aAreas,{|x| RestArea(x) })			
Return()

