#INCLUDE "PROTHEUS.CH"        
#INCLUDE "TOPCONN.CH"
#include "TBICONN.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  XIntResult º Autor ³ Romay Oliveira     º Data ³  01/2015    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Rotina para importacao dos dados de Resultados do Ponto     º±±
±±º			 Eletronico da tabela ZP3 de integracao com o Tephra    	  º±±
±±º																		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico CSU		                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObs		 ³Inova Solution											  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 

User Function XIntResult()

Local aCabec 		:= {}
Local aItens 		:= {}
Local aItensFim		:= {} 
//Local cxEmp 		:= aparams[1]
//Local cxFil 		:= aparams[2]
Private lMsErroAuto := .F.


RpcSetType(3)
RpcSetEnv("05","03",,,"GPE",GetEnvServer(),{"SRC,SRA,SRV,ZP3,SR8"})
//RpcSetEnv(cxEmp,cxFil,,,"GPE",GetEnvServer(),{"SRC,SRA,SRV,ZP3,SR8"})

ConOut("Inicio Job de importacao Tephra de resultados do ponto data: "+DtoC(Date())+" hora: "+Time()+" " )

/*
//Caso exista alguma integracao anterior apaga registro
Begin Transaction

	cUpdate := "	UPDATE 	"+RetSQLName("SRC")+"					"
	cUpdate += "	SET 	D_E_L_E_T_	= '*' 						"
	cUpdate += "	WHERE 	RC_FILIAL 	= '"+xFilial("SRC")+"'	    "
	cUpdate += "	AND		RC_XINTEGR 	= '1' 						"					    
	cUpdate += "	AND 	D_E_L_E_T_ 	= ''						"
	
	TCSQLEXEC(cUpdate) 
        
End Transaction
  */

cQuery := "	SELECT 	* 												" 
cQuery += " FROM   	"+retsqlname("ZP3")+" ZP3				   		"
//cQuery += " WHERE 	ZP3.ZP3_FILIAL 	= '"+xFilial("ZP3")+"'			"  trazer todas as filiais
cQuery += " WHERE 	ZP3.ZP3_STATUS 	= '0' 							" 
cQuery += " AND 	ZP3.D_E_L_E_T_ 	= ''							"
   
TCQUERY cQuery NEW ALIAS "TMPZP3"

dbSelectArea("TMPZP3")
TMPZP3->(dbGoTop())
            
	While TMPZP3->(!EOF())
	                           
		DbSelectArea("SRV")
		DbSetOrder(1)
		dbgotop() 
		
		If 	DbSeek( xFilial("SRV") + TMPZP3->ZP3_PD )
	
			cTipo := SRV->RV_TIPO 
		
		ELSE                                                                     
		
			cTipo := "V"
	
		EndIf            
		
		DbSelectArea("SRA")
		DbSetOrder(1)
		dbgotop()
		
		If 	DbSeek( TMPZP3->ZP3_FILIAL + TMPZP3->ZP3_MAT )//( xFilial("SRA") + TMPZP3->ZP3_MAT )
	                                                                                
			cCC := SRA->RA_CC 
		
		ELSE                                                                     
		
			cCC := TMPZP3->ZP3_CC
	
		EndIf 
		
		DbSelectArea("SRC")
		DbSetOrder(1)
		dbgotop() 
		
	    aCabec := {} 
        	AADD(aCabec, {"RA_FILIAL"     	, TMPZP3->ZP3_FILIAL		, Nil})// xFilial("SRA")          , Nil}) 
        	AADD(aCabec, {"RA_MAT"          , TMPZP3->ZP3_MAT    	    , Nil}) 
					
		aItens := {}           
	  		Aadd(aItens, {"RC_FILIAL"    , TMPZP3->ZP3_FILIAL	, Nil})//xFilial("SRC")       , Nil }) 
	        Aadd(aItens, {"RC_MAT"       , TMPZP3->ZP3_MAT      , Nil }) 
	        Aadd(aItens, {"RC_PD"        , TMPZP3->ZP3_PD       , Nil }) 
	        Aadd(aItens, {"RC_TIPO1"     , cTipo                , Nil }) 
	        Aadd(aItens, {"RC_HORAS"     , TMPZP3->ZP3_HORAS    , Nil }) 
	        Aadd(aItens, {"RC_VALOR"     , TMPZP3->ZP3_VALOR    , Nil }) 
	        Aadd(aItens, {"RC_DATA"      , dDatabase            , Nil }) 
	        Aadd(aItens, {"RC_CC"        , cCC			        , Nil }) 
	        Aadd(aItens, {"RC_PARCELA"   , 0                    , Nil })
	        Aadd(aItens, {"RC_XINTEGR" 	 , "1"					, Nil })  
	        Aadd(aItens, {"RC_DTINTG" 	 , dDatabase			, Nil })
   	        Aadd(aItens, {"RC_HRINTG" 	 , Time()				, Nil })	        
   	        
		aItensFim := {}							                          						                          
		aadd(aItensFim, aItens)
        
  		
  		cQuery1 := " SELECT 	* 											" 
		cQuery1 += " FROM  	"+retsqlname("SR8")+" SR8				   		"
		cQuery1 += " WHERE 	SR8.R8_FILIAL 	= '"+TMPZP3->ZP3_FILIAL+"'		" //'"+xFilial("SR8")+"'			"
		cQuery1 += " AND 	SR8.R8_MAT 	= '"+TMPZP3->ZP3_MAT+"'				" 
		cQuery1 += " AND 	SR8.R8_TIPO <> ''								"
		cQuery1 += " AND 	(	SR8.R8_DATAFIM >= '"+DtoS(dDatabase)+"'		"
		cQuery1 += " OR		SR8.R8_DATAFIM = ''	)							"
		cQuery1 += " AND 	SR8.D_E_L_E_T_ 	= ''							"
   
		TCQUERY cQuery1 NEW ALIAS "TMPSR8"

		dbSelectArea("TMPSR8")
		TMPSR8->(dbGoTop())
       
 		If TMPSR8->(!EOF()) // se funcionario estiver afastado
 			
			Begin Transaction  
				DbSelectArea("SRC")
				DbSetOrder(1)
				dbgotop()                                                    
				
				If !DbSeek(TMPZP3->ZP3_FILIAL+TMPZP3->ZP3_MAT+TMPZP3->ZP3_PD)
			    	Reclock("SRC",.T.)
						SRC->RC_FILIAL	:= TMPZP3->ZP3_FILIAL //xFilial("SRC")
						SRC->RC_MAT		:= TMPZP3->ZP3_MAT
						SRC->RC_PD		:= TMPZP3->ZP3_PD  
						SRC->RC_TIPO1	:= cTipo
						SRC->RC_HORAS	:= TMPZP3->ZP3_HORAS
						SRC->RC_VALOR	:= TMPZP3->ZP3_VALOR 
						SRC->RC_DATA	:= dDatabase
						SRC->RC_CC		:= cCC
						SRC->RC_PARCELA	:= 0
						SRC->RC_XINTEGR	:= "1"  
						SRC->RC_DTINTG	:= dDataBase
						SRC->RC_HRINTG  := Time()
						SRC->RC_TIPO2	:= "I"
					MsUnlock()
	            EndIf
	            
			End Transaction
 		
 		Else // se funcionario nao estiver afastado
			 	   /*		                  
			//Caso exista alguma integracao anterior apaga registro
			Begin Transaction
			
				cUpdate := "	UPDATE 	"+RetSQLName("SRC")+"					"
				cUpdate += "	SET 	D_E_L_E_T_	= '*' 						"
				cUpdate += "	WHERE 	RC_FILIAL 	= '"+xFilial("SRC")+"'	    "
				cUpdate += "	AND		RC_MAT		= '"+TMPZP3->ZP3_MAT+"'		"				
				cUpdate += "	AND		RC_PD		= '"+TMPZP3->ZP3_PD+"'		"
				cUpdate += "	AND		RC_XINTEGR 	= '1' 						"					    
				cUpdate += "	AND 	D_E_L_E_T_ 	= ''						"
				
				TCSQLEXEC(cUpdate) 
			        
			End Transaction
 			      */
			cQuery4 := " SELECT 	* 											" 
			cQuery4 += " FROM  	"+retsqlname("SRC")+" SRC				   		"
			cQuery4 += " WHERE 	SRC.RC_FILIAL 	= '"+TMPZP3->ZP3_FILIAL+"'		" //'"+xFilial("SRC")+"'			"
			cQuery4 += " AND 	SRC.RC_MAT 	= '"+TMPZP3->ZP3_MAT+"'				" 
			cQuery4 += " AND 	SRC.RC_PD = '"+TMPZP3->ZP3_PD+"'				"
			cQuery4 += " AND 	SRC.D_E_L_E_T_ 	= ''							"
	   
			TCQUERY cQuery4 NEW ALIAS "TMPSRC"
	
			dbSelectArea("TMPSRC")
			TMPSRC->(dbGoTop())
	       
	 		If TMPSRC->(!EOF())
				/*
				cUpdate4 := "	UPDATE 	"+RetSQLName("SRC")+"						"
				cUpdate4 += "	SET 	D_E_L_E_T_ 	= '*' 							"
				cUpdate4 += "	WHERE 	RC_FILIAL 	= '"+xFilial("SRC")+"'			"
				cUpdate4 += "	AND  	RC_MAT 	= '"+TMPZP3->ZP3_MAT+"'				"
				cUpdate4 += "	AND 	RC_PD = '"+TMPZP3->ZP3_PD+"'				"
				cUpdate4 += "	AND 	D_E_L_E_T_ 	= '' 							"
			
				TCSQLEXEC(cUpdate4)
				*/     
				
				DbSelectArea("SRC")
				DbSetOrder(1) //filial matricula pd
				dbgotop() 
				
				If DbSeek(TMPZP3->ZP3_FILIAL+TMPZP3->ZP3_MAT+TMPZP3->ZP3_PD)						
				    Reclock("SRC",.F.)
						SRC->RC_FILIAL	:= TMPZP3->ZP3_FILIAL //xFilial("SRC")
						SRC->RC_MAT		:= TMPZP3->ZP3_MAT
						SRC->RC_PD		:= TMPZP3->ZP3_PD  
						SRC->RC_TIPO1	:= cTipo
						SRC->RC_HORAS	:= TMPZP3->ZP3_HORAS
						SRC->RC_VALOR	:= TMPZP3->ZP3_VALOR 
						SRC->RC_DATA	:= dDatabase
						SRC->RC_CC		:= cCC
						SRC->RC_PARCELA	:= 0
						SRC->RC_XINTEGR	:= "1"  
						SRC->RC_DTINTG	:= dDataBase
						SRC->RC_HRINTG  := Time()
						SRC->RC_TIPO2	:= "I"
					MsUnlock()      
				EndIf               
				
				
				cUpdate := "	UPDATE 	"+RetSQLName("ZP3")+"						"
				cUpdate += "	SET 	ZP3_STATUS 	= '1' ,							"
			 	cUpdate += "			ZP3_DATA	= '"+DtoS(dDataBase)+"' ,		"
			 	cUpdate += "			ZP3_HORA	= '"+Time()+"'					"
				cUpdate += "	WHERE 	ZP3_FILIAL 	= '"+TMPZP3->ZP3_FILIAL+"'	   	" //'"+xFilial("ZP3")+"'	   		"
				cUpdate += "	AND  	ZP3_MAT 	= '"+TMPZP3->ZP3_MAT+"'		 	"
				cUpdate += "	AND 	ZP3_PD 		= '"+TMPZP3->ZP3_PD+"'			"
				cUpdate += "	AND 	ZP3_STATUS 	= '"+TMPZP3->ZP3_STATUS+"'		"
				cUpdate += "	AND 	D_E_L_E_T_ 	= '' 							"
			
				TCSQLEXEC(cUpdate) 	
				
				 /*         				
						MsExecAuto({|w,x,y,z| GPEA090(w,x,y,z)},4,aCabec,aItensFim,5)//4)// 3-Inclusao 4-Alteracao 5-Exclusao
						
						If lMsErroAuto
		
		    				MostraErro("\system\","LOGEXCLUSAORESULTADOS.LOG")			
		    				cErro := Memoread( "\system\LOGEXCLUSAORESULTADOS.LOG")  
		   					conout(" Erro na exclusao do Resultado do funcionario "+TMPZP3->ZP3_MAT+" verba "+TMPZP3->ZP3_PD+"  ")
		   					
		    			EndIf
		    					
				DbSelectArea("SRC")
				DbSetOrder(1) //filial matricula pd
				dbgotop() 
				          				
						MsExecAuto({|w,x,y,z| GPEA090(w,x,y,z)},4,aCabec,aItensFim,3)//4)// 3-Inclusao 4-Alteracao 5-Exclusao
			   */	    
			Else   
		      /*
				DbSelectArea("SRC")
				DbSetOrder(1) //filial matricula pd
				dbgotop() 
				          
			 	   		MsExecAuto({|w,x,y,z| GPEA090(w,x,y,z)},4,aCabec,aItensFim,3)// 3-Inclusao 4-Alteracao 5-Exclusao
		        */
		        
				DbSelectArea("SRC")
				DbSetOrder(1) //filial matricula pd
				dbgotop() 
				
				If !DbSeek(TMPZP3->ZP3_FILIAL+TMPZP3->ZP3_MAT+TMPZP3->ZP3_PD)						
				    Reclock("SRC",.T.)
						SRC->RC_FILIAL	:= TMPZP3->ZP3_FILIAL //xFilial("SRC")
						SRC->RC_MAT		:= TMPZP3->ZP3_MAT
						SRC->RC_PD		:= TMPZP3->ZP3_PD  
						SRC->RC_TIPO1	:= cTipo
						SRC->RC_HORAS	:= TMPZP3->ZP3_HORAS
						SRC->RC_VALOR	:= TMPZP3->ZP3_VALOR 
						SRC->RC_DATA	:= dDatabase
						SRC->RC_CC		:= cCC
						SRC->RC_PARCELA	:= 0
						SRC->RC_XINTEGR	:= "1"  
						SRC->RC_DTINTG	:= dDataBase
						SRC->RC_HRINTG  := Time()
						SRC->RC_TIPO2	:= "I"
					MsUnlock()      
				EndIf
		                            
		        
				cUpdate := "	UPDATE 	"+RetSQLName("ZP3")+"						"
				cUpdate += "	SET 	ZP3_STATUS 	= '1' ,							"
			 	cUpdate += "			ZP3_DATA	= '"+DtoS(dDataBase)+"' ,		"
			 	cUpdate += "			ZP3_HORA	= '"+Time()+"'					"
				cUpdate += "	WHERE 	ZP3_FILIAL 	= '"+TMPZP3->ZP3_FILIAL+"'	   	" //'"+xFilial("ZP3")+"'	   		"
				cUpdate += "	AND  	ZP3_MAT 	= '"+TMPZP3->ZP3_MAT+"'		 	"
				cUpdate += "	AND 	ZP3_PD 		= '"+TMPZP3->ZP3_PD+"'			"
				cUpdate += "	AND 	ZP3_STATUS 	= '"+TMPZP3->ZP3_STATUS+"'		"
				cUpdate += "	AND 	D_E_L_E_T_ 	= '' 							"
			
				TCSQLEXEC(cUpdate) 	
		        
			EndIf    
			TMPSRC->(DbCloseArea())
			
		EndIf
		
		TMPSR8->(DbCloseArea())
		
		If lMsErroAuto
		
		    MostraErro("\system\","LOGIMPRESULTADOS.LOG")			
		    cErro := Memoread( "\system\LOGIMPRESULTADOS.LOG")  
		    conout(" Imp Resultado do funcionario "+TMPZP3->ZP3_MAT+" filial "+TMPZP3->ZP3_FILIAL+" verba "+TMPZP3->ZP3_PD+" nao importado ")
		    
			/*
			Begin Transaction
			
				cUpdate := "	UPDATE 	"+RetSQLName("ZP3")+"						"
				cUpdate += "	SET 	D_E_L_E_T_ 	= '*' ,							"
			 	cUpdate += "			ZP3_DATA	= '"+DtoS(dDataBase)+"' ,		"
			 	cUpdate += "			ZP3_HORA	= '"+Time()+"'					"
				cUpdate += "	WHERE 	ZP3_FILIAL 	= '"+xFilial("ZP3")+"'	   		"
				cUpdate += "	AND  	ZP3_MAT 	= '"+TMPZP3->ZP3_MAT+"'		 	"
				cUpdate += "	AND 	ZP3_PD 		= '"+TMPZP3->ZP3_PD+"'			"
				cUpdate += "	AND 	ZP3_STATUS 	= '"+TMPZP3->ZP3_STATUS+"'		"
				cUpdate += "	AND 	D_E_L_E_T_ 	= '' 							"
			
				TCSQLEXEC(cUpdate)                                                                                                      
			
			End Transaction
			  */
		Else
		    
		    Begin Transaction
			           
				cUpdate := "	UPDATE 	"+RetSQLName("ZP3")+"						"
				cUpdate += "	SET 	ZP3_STATUS 	= '1' ,							"
			 	cUpdate += "			ZP3_DATA	= '"+DtoS(dDataBase)+"' ,		"
			 	cUpdate += "			ZP3_HORA	= '"+Time()+"'					"
				cUpdate += "	WHERE 	ZP3_FILIAL 	= '"+TMPZP3->ZP3_FILIAL+"'	   	" //'"+xFilial("ZP3")+"'	   		"
				cUpdate += "	AND  	ZP3_MAT 	= '"+TMPZP3->ZP3_MAT+"'		 	"
				cUpdate += "	AND 	ZP3_PD 		= '"+TMPZP3->ZP3_PD+"'			"
				cUpdate += "	AND 	ZP3_STATUS 	= '"+TMPZP3->ZP3_STATUS+"'		"
				cUpdate += "	AND 	D_E_L_E_T_ 	= '' 							"
			
				TCSQLEXEC(cUpdate) 	
			
			End Transaction
				
		EndIf
	
	  	
	  					
	TMPZP3->(dbSkip())
	End
	
TMPZP3->(DbCloseArea())

ConOut("Fim Job de importacao Tephra de resultados do ponto data: "+DtoC(Date())+" hora: "+Time()+" " )

RpcClearEnv()

Return()