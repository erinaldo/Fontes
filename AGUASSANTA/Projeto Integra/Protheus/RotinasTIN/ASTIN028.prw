#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMBROWSE.CH"
//-------------------------------------------------------------------
/*/{Protheus.doc} ASTIN028
Chamado pelo PE F200ABAT 
Efetiva baixa do aglutinado e origem - CNAB
@return		Nenhum			
@author		Totvs
@since		13/04/2017
@version	12
/*/
//-------------------------------------------------------------------
User Function ASTIN028() //F0102008()
Local lRet				:= .T.
Local aArea				:= GetArea()
Local aAreaSE1			:= SE1->(GetArea())
Local aAreaSE5			:= SE5->(GetArea())
Local nReg				:= 0
Local nReg5				:= 0
Local nReg1				:= 0
Local nValor			:= 0
Local nSaldo			:= 0
Local cSeq   			:= ''   
Local cChaveSE5			:= ''
Local dBaixa			:= ctod("  /  /  ") 
Local dVenci			:= ctod("  /  /  ") 
Local dDisp				:= ctod("  /  /  ")
Local dData				:= ctod("  /  /  ") 
Local dDataBaix			:= ctod("  /  /  ")
Local cMV_PAR6			:= mv_par06
Local cChave 			:= SE1->E1_NUM+SE1->E1_TIPO+SE1->E1_NATUREZ+SE1->E1_CLIENTE+SE1->E1_LOJA 
Local lAglutina			:= .F.
Local lParcial			:= .F.

Private lMsErroAuto 	:= .F.

nReg 		:= SE1->(Recno())	

IF	SE1->E1_XAGLUT == '1' .And. Empty(SE1->E1_XTITAGL) 
	lAglutina	:= .T.
Endif

IF	!Empty(SE1->E1_XVINCP) .And. Empty(SE1->E1_XPARCL) 
	lParcial:= .T.
	nSaldo 	:= SE1->E1_VALOR
	cSeq   	:= SE1->E1_XSEQ
Endif


//Se titulo renegociado - baixa os de origem
IF	ISINCALLSTACK( 'FINA200' ) 
	IF	lAglutina .Or.  lParcial 
		//Begin Transaction
		dbselectarea("SE5")
		dbsetorder(7)
		dbseek(xFilial("SE5")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE+SE1->E1_LOJA)
		
		IF SE5->E5_MOTBX =='NOR'
		
			dBaixa 	:= SE5->E5_DATA
			nValor 	:= SE5->E5_VALOR
			dDisp  	:= SE5->E5_DTDISPO
			cBanco 	:= SE5->E5_BANCO
			cAgencia:= SE5->E5_AGENCIA
			cConta 	:= SE5->E5_CONTA
			nSeqE5  := SE5->E5_SEQ
					
			aBaixa := {}
   			Aadd(aBaixa, {"E1_PREFIXO" , SE1->E1_PREFIXO , nil})
   			Aadd(aBaixa, {"E1_NUM"     , SE1->E1_NUM 	 , nil})
			Aadd(aBaixa, {"E1_PARCELA" , SE1->E1_PARCELA , nil})
			Aadd(aBaixa, {"E1_TIPO"    , SE1->E1_TIPO 	 , nil})                           
			Aadd(aBaixa, {"AUTHIST"    , 'Cancelamento da baixa Cnab', nil})                   
								
			
	    	lMsErroAuto := .F.
	    	//para baixas parciais, utilizar o ponto de entrada "F070BAUT"
			MSExecAuto({|x,y| Fina070(x,y)},aBaixa,5) //5 - Cancelamento de baixa
            IF 	lMsErroAuto 
            	lRet := .F.
				MostraErro()
                //DisarmTransaction()
            	//Break 
			Else
				SE1->(dbGoTo(nReg))
				Reclock("SE1", .F.)
				SE1->E1_SITUACA  := '0' 
				SE1->(msunlock())
	
				aBaixa := {}
   				Aadd(aBaixa, {"E1_PREFIXO" , SE1->E1_PREFIXO , nil})
   				Aadd(aBaixa, {"E1_NUM"     , SE1->E1_NUM 	 , nil})
				Aadd(aBaixa, {"E1_PARCELA" , SE1->E1_PARCELA , nil})
				Aadd(aBaixa, {"E1_TIPO"    , SE1->E1_TIPO 	 , nil})                           
				Aadd(aBaixa, {"AUTMOTBX"   , "REN"           , nil})
				Aadd(aBaixa, {"AUTDTBAIXA" , dBaixa		     , nil})
				Aadd(aBaixa, {"AUTDTCREDITO", dDisp    		 , nil})
				IF	lAglutina
					Aadd(aBaixa, {"AUTHIST" , 'Baixa título renegociado (origem) Cnab', nil}) 
				Else
					Aadd(aBaixa, {"AUTHIST" , 'Baixa título parcializado (origem) Cnab', nil}) 
				EndIf	                 
   				Aadd(aBaixa, {"AUTVALREC"  , nValor          , nil})  
				lMsErroAuto := .F.
	
        		MSExecAuto({|a,b| fina070(a,b)},aBaixa,3) // 3 - Baixa de Título
	            IF 	lMsErroAuto 
	            	lRet := .F.
					MostraErro()
            	    //DisarmTransaction()
                	//Break 
            	Else
					IF	lAglutina
						dVenci := SE1->E1_VENCTO
		 				
						SE1->(DbOrderNickName("RENEGOCIA"))
						//E1_FILIAL+E1_PREFIXO+E1_TIPO+E1_XTITAGL  
						SE1->(msSeek(xFilial("SE1") + cChave ))
			
						While !SE1->(Eof()) .And. xFilial('SE1') == SE1->E1_FILIAL .and.;
			    			cChave == SE1->E1_XTITAGL+SE1->E1_TIPO+SE1->E1_NATUREZ+SE1->E1_CLIENTE+SE1->E1_LOJA
					    
				       		nReg1 := SE1->(Recno())	
							aBaixa := {}
							aBaixa := {	{"E1_PREFIXO"  	,SE1->E1_PREFIXO 	,Nil},;
										{"E1_NUM"	   	,SE1->E1_NUM        ,Nil},; 
										{"E1_PARCELA"	,SE1->E1_PARCELA  	,Nil},;
										{"E1_TIPO"	   	,SE1->E1_TIPO       ,Nil},;
										{"AUTDTBAIXA"  	,dBaixa          	,Nil},;
										{"AUTDTCREDITO"	,dDisp          	,Nil},;
										{"AUTHIST"	   	,"Cancelamento baixa título renegociado (origem)",Nil}}
							
	    					//Para interface com RM
		   					//Altera = .F. Cancela Baixa
							lAteraB	:=  ALTERA
							ALTERA 	:= .F.
								
	    	    			lMsErroAuto := .F.
	    					//para baixas parciais, utilizar o ponto de entrada "F070BAUT"
							MSExecAuto({|x,y| Fina070(x,y)},aBaixa,5) //5 - Cancelamento de baixa
					        ALTERA := lAteraB

            				IF 	lMsErroAuto .Or. !Empty(SE1->E1_BAIXA)
		  						lRet := .F.
  								AutoGrLog( "Problema no Cancelamento de baixa de título renegociado (origem)." )
								MostraErro()
								EXIT
                				//DisarmTransaction()
                				//Break 
							Else
	        					//Baixa titulos de origem, atraves de baixa normal

								dDataBaix :=  DBAIXA 	
								aBaixa := {}
    		        			Aadd(aBaixa, {"E1_PREFIXO" , SE1->E1_PREFIXO , nil})
        		    			Aadd(aBaixa, {"E1_NUM"     , SE1->E1_NUM 	 , nil})
            					Aadd(aBaixa, {"E1_PARCELA" , SE1->E1_PARCELA , nil})
	            				Aadd(aBaixa, {"E1_TIPO"    , SE1->E1_TIPO 	 , nil})                           
    	        				Aadd(aBaixa, {"AUTMOTBX"   , "NOR"           , nil})
            					Aadd(aBaixa, {"AUTBANCO"   , cBanco 		 , nil})
            					Aadd(aBaixa, {"AUTAGENCIA" , cAgencia	 	 , nil})
            					Aadd(aBaixa, {"AUTCONTA"   , cConta	 		 , nil})
            					Aadd(aBaixa, {"AUTDTBAIXA" , dVenci		     , nil})
        	    				Aadd(aBaixa, {"AUTDTCREDITO",dDisp    		 , nil})
            					Aadd(aBaixa, {"AUTHIST"    , "Baixa título renegociado (origem) Cnab" , nil})                   
                				Aadd(aBaixa, {"AUTVALREC"  , SE1->E1_VALOR   , nil})    
        						lMsErroAuto := .F.
		
	            				//Para interface com RM
			    				//Altera = .F. Cancela Baixa
	    						//Altera = .T. Baixa Titulo
        						lAteraB	:=  ALTERA
        						ALTERA 	:= .T.
	
								dData 	  	:= ddatabase
								ddatabase 	:= dVenci
									
								lMsErroAuto := .F.        		
        						MSExecAuto({|a,b| fina070(a,b)},aBaixa,3) // 3 - Baixa de Título
                            	ALTERA 		:= lAteraB	            		
								Ddatabase 	:= dData
								
								SE1->(dbGoTo(nReg1))		
	            				IF 	lMsErroAuto .Or. SE5->E5_MOTBX<>'NOR' .Or. Empty(SE1->E1_BAIXA)
	            					lRet := .F.
  									AutoGrLog( "Problema na Integração com RM, baixa do título não concluido - "+ Alltrim(SE1->E1_NUM) )
									MostraErro()
									Exit
            	    				//DisarmTransaction()
                					//Break 
            				
            					Else
            						RecLock("SE1",.F.)
									SE1->E1_BAIXA  := dDataBaix
									SE1->(MsUnlock())

									nReg5 := SE5->(Recno())								
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
            						SE5->(dbGoTo(nReg5))
            					EndIf
            				Endif	
							SE1->(dbGoTo(nReg1))	
							SE1->(dbSkip())
						EndDo
					EndIf	

					IF	lParcial
						//Busca o titulo origem do titulo parcial para cancelar a baixa parcial			
						SE1->(DbSetOrder(1))
						If 	SE1->(DbSeek(SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_XVINCP+SE1->E1_PARCELA))
							dVenci := SE1->E1_VENCTO

			        		//Cancela baixa titulos de origem
							dbselectarea("SE5")
							dbsetorder(7)
							If 	dbseek(xFilial("SE5")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE+SE1->E1_LOJA+cSeq)
				       
										
	    						aBaixa := {}
	    						aBaixa := {	{"E1_PREFIXO"  	,SE1->E1_PREFIXO 	,Nil},;
										    {"E1_NUM"	   	,SE1->E1_NUM        ,Nil},; 
										    {"E1_PARCELA"	,SE1->E1_PARCELA  	,Nil},;
										    {"E1_TIPO"	   	,SE1->E1_TIPO       ,Nil},;
										    {"AUTDTBAIXA"  	,dBaixa          	,Nil},;
										    {"AUTDTCREDITO"	,dDisp          	,Nil},;
										    {"AUTHIST"	   	,"Cancelamento baixa título parcializado (origem)",Nil},;
										    {"AUTVALREC"	,SE5->E5_VALOR	    ,Nil}}
	    	
	    						//Para interface com RM
	    						//Altera = .F. Cancela Baixa
	    						//Altera = .T. Baixa Titulo
	    						If	valType(ALTERA) <> "U"
									ALTERA := .F.
								EndIf
	    		    	
	    						//para baixas parciais, utilizar o ponto de entrada "F070BAUT"
	    						lMsErroAuto := .F.
	    						MSExecAuto({|x,w,y,z| fina070(x,w,y,z)},aBaixa,5)//5 - Cancelamento de baixa
		    			
	    	   					dbSelectArea("SE5")
        						IF 	lMsErroAuto .Or. !Empty(SE5->E5_NUMERO)
        							lRet := .F.
									AutoGrLog( "Problema no Cancelamento da Baixa." )
									//MostraErro()
           							//DisarmTransaction()
			           				//Break 
								Else
	        						//Baixa titulo de origem, atraves de baixa normal
									aBaixa := {}
    		        				Aadd(aBaixa, {"E1_PREFIXO" , SE1->E1_PREFIXO , nil})
        		    				Aadd(aBaixa, {"E1_NUM"     , SE1->E1_NUM 	 , nil})
            						Aadd(aBaixa, {"E1_PARCELA" , SE1->E1_PARCELA , nil})
	            					Aadd(aBaixa, {"E1_TIPO"    , SE1->E1_TIPO 	 , nil})                           
    	        					Aadd(aBaixa, {"AUTMOTBX"   , "NOR"           , nil})
            						Aadd(aBaixa, {"AUTBANCO"   , cBanco 		 , nil})
            						Aadd(aBaixa, {"AUTAGENCIA" , cAgencia	 	 , nil})
            						Aadd(aBaixa, {"AUTCONTA"   , cConta	 		 , nil})
            						Aadd(aBaixa, {"AUTDTBAIXA" , dBaixa		     , nil})
        	    					Aadd(aBaixa, {"AUTDTCREDITO",dDisp    		 , nil})
            						Aadd(aBaixa, {"AUTHIST"    , "Baixa título parcializado (origem) Cnab", nil})                   
                					Aadd(aBaixa, {"AUTVALREC"  , nSaldo		     , nil})    
		        					lMsErroAuto := .F.
		
				    				//Para interface com RM
				    				//Altera = .F. Cancela Baixa
			    					//Altera = .T. Baixa Titulo
		        					If	valType(ALTERA) <> "U"
										ALTERA := .T.
									EndIf

									dData 	  	:= ddatabase
									ddatabase 	:= dVenci
		        					MSExecAuto({|a,b| fina070(a,b)},aBaixa,3) //3 - Baixa de Título
									ddatabase := dData
		 			       			dbSelectArea("SE5")
		       		
		       						If 	lMsErroAuto .Or. (SE5->E5_NUMERO <> SE1->E1_NUM)
		       							lRET := .F.
										AutoGrLog( 'Problema na baixa do título de origem.')
		            					MostraErro()
		            					//DisarmTransaction()
		            					//Break 
		            				EndIf	
		            			Endif
		            		Endif	
		            	EndIf		
            		EndIf	
            	EndIf	
			EndIf
		EndIf
		//End Transaction		
	EndIf
EndIF


IF	!lRet
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
					{"AUTHIST"	   	,"Canc. baixa título-problem na baixa",Nil},; 
					{"AUTVALREC"	,SE5->E5_VALOR	    ,Nil}}
    	
		//Para interface com RM
		//Altera = .F. Cancela Baixa
		ALTERA := .F.

		//para baixas parciais, utilizar o ponto de entrada "F070BAUT"
		lMsErroAuto := .F.
		MSExecAuto({|x,w,y,z| fina070(x,w,y,z)},aCabec,5)//5 - Cancelamento de baixa
	    			
		IF	lMsErroAuto 
       		lRet := .F.
			AutoGrLog( "Problema no Cancelamento da Baixa." )
			MostraErro()
		EndIf

		IF	lAglutina
			dVenci := SE1->E1_VENCTO
		 				
			SE1->(DbOrderNickName("RENEGOCIA"))
			//E1_FILIAL+E1_PREFIXO+E1_TIPO+E1_XTITAGL  
			SE1->(msSeek(xFilial("SE1") + cChave ))
			
			While !SE1->(Eof()) .And. xFilial('SE1') == SE1->E1_FILIAL .and.;
    			cChave == SE1->E1_XTITAGL+SE1->E1_TIPO+SE1->E1_NATUREZ+SE1->E1_CLIENTE+SE1->E1_LOJA
					    
	       		nReg1 := SE1->(Recno())	
				aBaixa := {}
				aBaixa := {	{"E1_PREFIXO"  	,SE1->E1_PREFIXO 	,Nil},;
							{"E1_NUM"	   	,SE1->E1_NUM        ,Nil},; 
							{"E1_PARCELA"	,SE1->E1_PARCELA  	,Nil},;
							{"E1_TIPO"	   	,SE1->E1_TIPO       ,Nil},;
							{"AUTDTBAIXA"  	,dBaixa          	,Nil},;
							{"AUTDTCREDITO"	,dDisp          	,Nil},;
							{"AUTHIST"	   	,"Canc. baixa título-problem na baixa CNAB",Nil}}
							
				//Para interface com RM
				//Altera = .F. Cancela Baixa
				lAteraB	:=  ALTERA
				ALTERA 	:= .F.
								
	   			lMsErroAuto := .F.
				//para baixas parciais, utilizar o ponto de entrada "F070BAUT"
				MSExecAuto({|x,y| Fina070(x,y)},aBaixa,5) //5 - Cancelamento de baixa
		        ALTERA := lAteraB

        		IF 	lMsErroAuto .Or. !Empty(SE1->E1_BAIXA)
  					AutoGrLog( "Problema no Cancelamento de baixa de título renegociado (origem)." )
					MostraErro()
				Else
   					//Baixa titulos de origem, atraves de baixa normal

					aBaixa := {}
        			Aadd(aBaixa, {"E1_PREFIXO" , SE1->E1_PREFIXO , nil})
	    			Aadd(aBaixa, {"E1_NUM"     , SE1->E1_NUM 	 , nil})
   					Aadd(aBaixa, {"E1_PARCELA" , SE1->E1_PARCELA , nil})
       				Aadd(aBaixa, {"E1_TIPO"    , SE1->E1_TIPO 	 , nil})                           
       				Aadd(aBaixa, {"AUTMOTBX"   , "REN"           , nil})
   					Aadd(aBaixa, {"AUTBANCO"   , cBanco 		 , nil})
   					Aadd(aBaixa, {"AUTAGENCIA" , cAgencia	 	 , nil})
            		Aadd(aBaixa, {"AUTCONTA"   , cConta	 		 , nil})
            		Aadd(aBaixa, {"AUTDTBAIXA" , dBaixa		     , nil})
        	    	Aadd(aBaixa, {"AUTDTCREDITO",dDisp    		 , nil})
            		Aadd(aBaixa, {"AUTHIST"    , "Baixa título renegociado (origem) Cnab" , nil})                   
                	Aadd(aBaixa, {"AUTVALREC"  , SE1->E1_VALOR   , nil})    
        			lMsErroAuto := .F.
		
	            	//Para interface com RM
			    	//Altera = .F. Cancela Baixa
	    			//Altera = .T. Baixa Titulo
        			lAteraB	:=  ALTERA
        			ALTERA 	:= .T.
	
					dData 	  	:= ddatabase
					ddatabase 	:= dVenci
									
					lMsErroAuto := .F.        		
        			MSExecAuto({|a,b| fina070(a,b)},aBaixa,3) // 3 - Baixa de Título
                    ALTERA 		:= lAteraB	            		
					Ddatabase 	:= dData
						
					SE1->(dbGoTo(nReg1))		
	            	IF 	lMsErroAuto .Or. SE5->E5_MOTBX<>'NOR' .Or. Empty(SE1->E1_BAIXA)
	            		lRet := .F.
  						AutoGrLog( "Problema na Integração com RM, baixa do título não concluido - "+ Alltrim(SE1->E1_NUM) )
						MostraErro()
						Exit
            		EndIf
         		Endif	

				SE1->(dbGoTo(nReg1))	
				SE1->(dbSkip())
			EndDo
		EndIf
		
		IF	lParcial
			//Busca o titulo origem do titulo parcial para cancelar a baixa parcial			
			SE1->(DbSetOrder(1))
			If 	SE1->(DbSeek(SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_XVINCP+SE1->E1_PARCELA))
				dVenci := SE1->E1_VENCTO

	       		//Cancela baixa titulos de origem
				dbselectarea("SE5")
				dbsetorder(7)
				If 	dbseek(xFilial("SE5")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE+SE1->E1_LOJA+cSeq)
				       
					aBaixa := {}
					aBaixa := {	{"E1_PREFIXO"  	,SE1->E1_PREFIXO 	,Nil},;
							    {"E1_NUM"	   	,SE1->E1_NUM        ,Nil},; 
							    {"E1_PARCELA"	,SE1->E1_PARCELA  	,Nil},;
							    {"E1_TIPO"	   	,SE1->E1_TIPO       ,Nil},;
							    {"AUTDTBAIXA"  	,dBaixa          	,Nil},;
							    {"AUTDTCREDITO"	,dDisp          	,Nil},;
							    {"AUTHIST"	   	,"Canc. baixa título-problem na baixa CNAB",Nil},;
							    {"AUTVALREC"	,SE5->E5_VALOR	    ,Nil}}
	    	
					//Para interface com RM
					//Altera = .F. Cancela Baixa
					//Altera = .T. Baixa Titulo
					If	valType(ALTERA) <> "U"
						ALTERA := .F.
					EndIf
	   		    	
					//para baixas parciais, utilizar o ponto de entrada "F070BAUT"
					lMsErroAuto := .F.
					MSExecAuto({|x,w,y,z| fina070(x,w,y,z)},aBaixa,5)//5 - Cancelamento de baixa
		    			
					dbSelectArea("SE5")
    				IF 	lMsErroAuto .Or. !Empty(SE5->E5_NUMERO)
    					lRet := .F.
						AutoGrLog( "Problema no Cancelamento da Baixa." )
					Else
   						//Baixa titulo de origem, atraves de baixa normal
						aBaixa := {}
        				Aadd(aBaixa, {"E1_PREFIXO" , SE1->E1_PREFIXO , nil})
	    				Aadd(aBaixa, {"E1_NUM"     , SE1->E1_NUM 	 , nil})
   						Aadd(aBaixa, {"E1_PARCELA" , SE1->E1_PARCELA , nil})
       					Aadd(aBaixa, {"E1_TIPO"    , SE1->E1_TIPO 	 , nil})                           
       					Aadd(aBaixa, {"AUTMOTBX"   , "REN"           , nil})
   						Aadd(aBaixa, {"AUTBANCO"   , cBanco 		 , nil})
            			Aadd(aBaixa, {"AUTAGENCIA" , cAgencia	 	 , nil})
            			Aadd(aBaixa, {"AUTCONTA"   , cConta	 		 , nil})
            			Aadd(aBaixa, {"AUTDTBAIXA" , dBaixa		     , nil})
        	    		Aadd(aBaixa, {"AUTDTCREDITO",dDisp    		 , nil})
            			Aadd(aBaixa, {"AUTHIST"    , "Baixa título parcializado (origem) Cnab", nil})                   
                		Aadd(aBaixa, {"AUTVALREC"  , nSaldo		     , nil})    
		        		lMsErroAuto := .F.
		
				    	//Para interface com RM
				    	//Altera = .F. Cancela Baixa
			    		//Altera = .T. Baixa Titulo
		        		If	valType(ALTERA) <> "U"
							ALTERA := .T.
						EndIf
		        		
		        		dData 	  := ddatabase
						ddatabase := dVenci
		        		MSExecAuto({|a,b| fina070(a,b)},aBaixa,3) //3 - Baixa de Título
		 			   	ddatabase := dData
		 			    dbSelectArea("SE5")
		       		
		       			If 	lMsErroAuto .Or. (SE5->E5_NUMERO <> SE1->E1_NUM)
		       				lRET := .F.
							AutoGrLog( 'Problema na baixa do título de origem.')
		            		MostraErro()
		            	EndIf	
		            Endif
		      	Endif	
		    EndIf		
   		EndIf	
	EndIf	
EndIf	

SE1->(dbGoTo(nReg))	
mv_par06	:= cMV_PAR6			

RestArea(aAreaSE1)
RestArea(aAreaSE5)
RestArea(aArea)

Return()






