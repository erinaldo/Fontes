#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMBROWSE.CH"
//-------------------------------------------------------------------
/*/{Protheus.doc} ASTIN033
Chamado pelo PE SACI008 
Cancela a baixa por Renegociacao do titulo origem e efetiva a baixa do
titulo origem
@return	Nenhum			
@author	Carlos Gorgulho
@since		03/03/2017
@version	12.1.7
/*/
//-------------------------------------------------------------------
User Function ASTIN033 //F0103003()

Local aAreas 	:= { SF3->(GetArea()), GetArea() }
Local aBaixa 	:= {}     
Local nSaldo 	:= 0
Local nTotal 	:= 0   
Local nXY		:= 0  
Local lRet		:= .T.
Local lBor      := .T.
Local nSeqE5	:= ''
Local cChvBor	:= ''
Local cSeq   	:= ''       
Local nReg		:= ''
Local nX		:= 0
Local cMotivC	:= "Exc Baixa Tit Parcial"
Local cMotivB   := "Baixa titulo de origem"

Private lMsErroAuto := .F.

//verifica se é um titulo parcializado
//IF	!ISINCALLSTACK( 'U_F0102008' ) .And. !ISINCALLSTACK( 'FINA200' )  
IF	!ISINCALLSTACK( 'U_ASTIN028' ) .And. !ISINCALLSTACK( 'FINA200' )  
	If 	!Empty(SE1->E1_XVINCP)
	
		nSaldo 	:= SE1->E1_VALOR
		cSeq   	:= SE1->E1_XSEQ
	
		cChvBor := SE1->E1_NUMBOR+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO //+SE1->E1_CLIENTE+SE1->E1_LOJA
		nReg 	:= SE1->(Recno())	
		nSeqE5  := SE5->E5_SEQ
	
		//Busca o titulo origem do titulo parcial para cancelar a baixa parcial			
		SE1->(DbSetOrder(1))
		If 	SE1->(DbSeek(SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_XVINCP+SE1->E1_PARCELA))
			nTotal	:= SE1->E1_VALOR
	
	
			Begin Transaction
	
		    	//Localiza Bordero do titulo de origem
				dbselectarea("SEA")
				dbsetorder(1)
				If 	dbseek(xFilial("SEA")+ cChvBor  )
	
			
	        		//Cancela baixa titulos de origem
					dbselectarea("SE5")
					dbsetorder(7)
					If 	dbseek(xFilial("SE5")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE+SE1->E1_LOJA+cSeq)
					       
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
		    			//Altera = .T. Baixa Titulo
		    			If	valType(ALTERA) <> "U"
							ALTERA := .F.
						EndIf
		    		    	
		    			//para baixas parciais, utilizar o ponto de entrada "F070BAUT"
		    			lMsErroAuto := .F.
		    			MSExecAuto({|x,w,y,z| fina070(x,w,y,z)},aCabec,5)//5 - Cancelamento de baixa
		    			
		    	   		dbSelectArea("SE5")
	        			IF 	lMsErroAuto .Or. !Empty(SE5->E5_NUMERO)
	        				lRet := .F.
							AutoGrLog( "Problema no Cancelamento da Baixa." )
							MostraErro()
	           				DisarmTransaction()
				           	Break 
						Else
		        			//Baixa titulo de origem, atraves de baixa normal
		        			aBaixa := {}
	        				Aadd(aBaixa, {"E1_PREFIXO" , SE1->E1_PREFIXO , nil})
	        				Aadd(aBaixa, {"E1_NUM"     , SE1->E1_NUM 	 , nil})
	        				Aadd(aBaixa, {"E1_PARCELA" , SE1->E1_PARCELA , nil})
	        				Aadd(aBaixa, {"E1_TIPO"    , SE1->E1_TIPO 	 , nil})                           
	        				Aadd(aBaixa, {"E1_CLIENTE" , SE1->E1_CLIENTE , nil})
	        				Aadd(aBaixa, {"E1_LOJA"    , SE1->E1_LOJA 	 , nil})
	            			Aadd(aBaixa, {"AUTBANCO"   , SEA->EA_PORTADO , nil})
	            			Aadd(aBaixa, {"AUTAGENCIA" , SEA->EA_AGEDEP	 , nil})
	            			Aadd(aBaixa, {"AUTCONTA"   , SEA->EA_NUMCON	 , nil})
	        				Aadd(aBaixa, {"AUTMOTBX"   , "NOR"      	 , nil})
	        				Aadd(aBaixa, {"AUTDTBAIXA" , DBAIXA		  	 , nil})
	        				Aadd(aBaixa, {"AUTDTCREDITO",DDTCREDITO		 , nil})
	        				Aadd(aBaixa, {"AUTHIST"    , cMotivB		 , nil})
	        				Aadd(aBaixa, {"AUTVALREC"  , nSaldo		 	 , nil})          
	
	        				lMsErroAuto := .F.
	
			    			//Para interface com RM
			    			//Altera = .F. Cancela Baixa
		    				//Altera = .T. Baixa Titulo
	        				If	valType(ALTERA) <> "U"
								ALTERA := .T.
							EndIf
	        		
	        				MSExecAuto({|a,b| fina070(a,b)},aBaixa,3) //3 - Baixa de Título
	 			       		dbSelectArea("SE5")
	       		
	       					If 	lMsErroAuto .Or. (SE5->E5_NUMERO <> SE1->E1_NUM)
	       						lRET := .F.
								AutoGrLog( 'Problema na baixa do título de origem.')
	            				MostraErro()
	            				DisarmTransaction()
	            				Break 
	            			EndIf	
	            		EndIf	
	            	EndIf	
	        	Else
		        	lRet := .F.
		        	lBor := .F.
	       			DisarmTransaction()
	       			Break 
	        	EndIf	
	       End Transaction 
		EndIf
		
		If	!lBor
			MsgAlert("Bordero náo localizado, processo cancelado.")
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

