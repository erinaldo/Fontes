#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#include "TBICONN.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  XIntTurno  º Autor ³ Romay Oliveira     º Data ³  01/2015    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Rotina para importacao dos dados de Troca de Turno do Ponto º±±
±±º			 Eletronico da tabela ZP4 de integracao com o Tephra    	  º±±
±±º																		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico CSU		                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObs		 ³Inova Solution											  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 

User Function XIntTurno() 
 
RpcSetType(3)
//RpcSetEnv(cxEmp,cxFil,,,"GPE",GetEnvServer(),{"SPF,SRA,ZP4"})  
RpcSetEnv("05","03",,,"GPE",GetEnvServer(),{"SPF,SRA,ZP4"})  

ConOut("Inicio Job de importacao Tephra de turnos de trabalho data: "+DtoC(Date())+" hora: "+Time()+" " )

cQuery := "	SELECT 	* 												" 
cQuery += " FROM   	"+retsqlname("ZP4")+" ZP4				   		"
cQuery += " WHERE 	" //ZP4.ZP4_FILIAL 	= '"+xFilial("ZP4")+"'			" retirado filial
cQuery += " 	ZP4.ZP4_STATUS 	= '0' 							" 
cQuery += " AND 	ZP4.D_E_L_E_T_ 	= ''							"
   
TCQUERY cQuery NEW ALIAS "TMPZP4"

dbSelectArea("TMPZP4")
TMPZP4->(dbGoTop())
            
	While TMPZP4->(!EOF())
 		
 		DbSelectArea("SRA")
		DbSetOrder(1)
		dbgotop() 
				
		If !DbSeek( TMPZP4->ZP4_FILIAL + TMPZP4->ZP4_MAT ) //	!DbSeek( xFilial("SRA") + TMPZP4->ZP4_MAT )
	   	    
	   		conout(" Imp Turno / funcionario "+TMPZP4->ZP4_FILIAL+"/"+TMPZP4->ZP4_MAT+" nao existe no cadastro ")
	   		TMPZP4->(dbSkip())
	   		
		EndIf
		/*
		DbSelectArea("SPF")
		DbSetOrder(1)
		dbgotop() 
		
		If !DbSeek( TMPZP4->ZP4_FILIAL + TMPZP4->ZP4_MAT + TMPZP4->ZP4_DTALT ) //	!DbSeek( xFilial("SPF") + TMPZP4->ZP4_MAT )       
	  */	                                 
		cQuery2 := ""
	   	cQuery2 := " SELECT *   	"
		cQuery2 += " FROM "+retsqlname("SPF")+" SPF                   	"
		cQuery2 += " WHERE	SPF.PF_FILIAL	= '"+TMPZP4->ZP4_FILIAL+"'  "// '"+xFilial("ZP4")+"'    " 
		cQuery2 += " AND 	SPF.PF_MAT		= '"+TMPZP4->ZP4_MAT+"'   	"
		cQuery2 += " AND 	SPF.PF_DATA		>= '"+TMPZP4->ZP4_DTALT+"'  	"
		cQuery2 += " AND 	SPF.D_E_L_E_T_	= ''		              	"
			
		TCQUERY cQuery2 NEW ALIAS "TMPSPF1"
	
		dbSelectArea("TMPSPF1")
		TMPSPF1->(dbGoTop())
		
		If !TMPSPF1->(!EOF())
		  
			cQuery3 := ""
	   		cQuery3 := " SELECT MAX(SPF.PF_DATA) PF_DATA, SPF.PF_TURNOPA   	"
			cQuery3 += " FROM "+retsqlname("SPF")+" SPF                   	"
			cQuery3 += " WHERE	SPF.PF_FILIAL	= '"+TMPZP4->ZP4_FILIAL+"'  "// '"+xFilial("ZP4")+"'    " 
			cQuery3 += " AND 	SPF.PF_MAT		= '"+TMPZP4->ZP4_MAT+"'   	"
			cQuery3 += " AND 	SPF.D_E_L_E_T_	= ''		              	"
			cQuery3 += " GROUP BY PF_DATA, PF_TURNOPA  						"
			cQuery3 += " ORDER BY PF_DATA									"
			
			TCQUERY cQuery3 NEW ALIAS "TMPSPF2"
	
			dbSelectArea("TMPSPF2")
			TMPSPF2->(dbGoTop())
			
		        If TMPSPF2->(!EOF()) 
		        
					While TMPSPF2->(!EOF())
						cTurnoDe	:= ""
						cTurnoDe	:= TMPSPF2->PF_TURNOPA
					TMPSPF2->(dbSkip())
					End	
				
				Else
					cTurnoDe	:= ""
					cTurnoDe 	:= SRA->RA_TNOTRAB	
			    EndIf
			
			TMPSPF2->(DbCloseArea())
		    
			DbSelectArea("SPF")
			DbSetOrder(1)
			dbgotop() 
		    
			Begin Transaction  
			
			    Reclock("SPF",.T.)
					SPF->PF_FILIAL	:= TMPZP4->ZP4_FILIAL //xFilial("SPF")
					SPF->PF_MAT		:= TMPZP4->ZP4_MAT
					SPF->PF_DATA	:= StoD(TMPZP4->ZP4_DTALT)
					SPF->PF_TURNODE	:= cTurnoDe//TMPZP4->ZP4_TNDE
					SPF->PF_SEQUEDE	:= "01"
					SPF->PF_REGRADE	:= "01"
					SPF->PF_TURNOPA	:= TMPZP4->ZP4_TNPARA
					SPF->PF_SEQUEPA	:= "01"
					SPF->PF_REGRAPA	:= "01"
				MsUnlock()
		    
			
				cUpdate1 := "	UPDATE 	"+RetSQLName("ZP4")+"						"
				cUpdate1 += "	SET 	ZP4_STATUS 	= '1' ,							"
			 	cUpdate1 += "			ZP4_DATA	= '"+DtoS(dDataBase)+"' ,		"
			 	cUpdate1 += "			ZP4_HORA	= '"+Time()+"'					"
				cUpdate1 += "	WHERE 	ZP4_FILIAL 	= '"+TMPZP4->ZP4_FILIAL+"'  	" //'"+xFilial("ZP4")+"'	   		"
				cUpdate1 += "	AND  	ZP4_MAT 	= '"+TMPZP4->ZP4_MAT+"'		 	"
				cUpdate1 += "	AND 	ZP4_DTALT	= '"+TMPZP4->ZP4_DTALT+"'		"
				cUpdate1 += "	AND 	ZP4_TNPARA	= '"+TMPZP4->ZP4_TNPARA+"'		"
				cUpdate1 += "	AND 	D_E_L_E_T_ 	= '' 							"
			
				TCSQLEXEC(cUpdate1)

			End Transaction
		
//			TMPZP4->(dbSkip())
			
		Else    // se ja existir spf com mesma data ou maior
			
			cQuery4 := ""
	   		cQuery4 := " SELECT *   	"
			cQuery4 += " FROM "+retsqlname("SPF")+" SPF                   	"
			cQuery4 += " WHERE	SPF.PF_FILIAL	= '"+TMPZP4->ZP4_FILIAL+"'  "// '"+xFilial("ZP4")+"'    " 
			cQuery4 += " AND 	SPF.PF_MAT		= '"+TMPZP4->ZP4_MAT+"'   	"
			cQuery4 += " AND 	SPF.PF_DATA		= '"+TMPZP4->ZP4_DTALT+"'  	"
			cQuery4 += " AND 	SPF.D_E_L_E_T_	= ''		              	"
			
			TCQUERY cQuery4 NEW ALIAS "TMPSPF3"
	
			dbSelectArea("TMPSPF3")
			TMPSPF3->(dbGoTop())
			
			If TMPSPF3->(!EOF()) // se ja existir spf com mesma data
				
				cQuery1 := ""
	   			cQuery1 := " SELECT MAX(SPF.PF_DATA) PF_DATA, SPF.PF_TURNODE   	"
				cQuery1 += " FROM "+retsqlname("SPF")+" SPF                		"
				cQuery1 += " WHERE	SPF.PF_FILIAL	= '"+TMPZP4->ZP4_FILIAL+"'  " //'"+xFilial("ZP4")+"'    "
				cQuery1 += " AND 	SPF.PF_MAT		= '"+TMPZP4->ZP4_MAT+"'   	"
				cQuery1 += " AND 	SPF.D_E_L_E_T_	= ''		              	"
				cQuery1 += " GROUP BY PF_DATA, PF_TURNODE  						"
				cQuery1 += " ORDER BY PF_DATA									"
			
				TCQUERY cQuery1 NEW ALIAS "TMPSPF"
	
				dbSelectArea("TMPSPF")
				TMPSPF->(dbGoTop())

		        If TMPSPF->(!EOF()) 
		        
					While TMPSPF->(!EOF())
						cTurnoDe	:= ""
						cTurnoDe	:= TMPSPF->PF_TURNODE
					TMPSPF->(dbSkip())
					End	
				
				Else
					cTurnoDe	:= ""
					cTurnoDe 	:= SRA->RA_TNOTRAB	
			    EndIf   
			    
			    TMPSPF->(DbCloseArea())
			    
			    Begin Transaction 
		

		 				cUpdate8 := "	UPDATE 	"+RetSQLName("SPF")+"						"
						cUpdate8 += "	SET 	PF_TURNODE 	= '"+cTurnoDe+"' ,				"
					 	cUpdate8 += "			PF_SEQUEDE	= '01' ,  						"
					 	cUpdate8 += "			PF_REGRADE	= '01'							" 
					 	cUpdate8 += "			PF_TURNOPA	= '"+TMPZP4->ZP4_TNPARA+"' ,	" 
					 	cUpdate8 += "			PF_SEQUEPA	= '01' ,  						"
					 	cUpdate8 += "			PF_REGRAPA	= '01'							"					 	
						cUpdate8 += "	WHERE 	PF_FILIAL 	= '"+TMPZP4->ZP4_FILIAL+"'  	" //'"+xFilial("ZP4")+"'	   		"
						cUpdate8 += "	AND  	PF_MAT 	= '"+TMPZP4->ZP4_MAT+"'			 	"
						cUpdate8 += "	AND 	PF_DATA	= '"+TMPZP4->ZP4_DTALT+"'			"
						cUpdate8 += "	AND 	D_E_L_E_T_ 	= '' 							"
					
						TCSQLEXEC(cUpdate8)                 
		 		
						cUpdate3 := "	UPDATE 	"+RetSQLName("ZP4")+"						"
						cUpdate3 += "	SET 	ZP4_STATUS 	= '1' ,							"
					 	cUpdate3 += "			ZP4_DATA	= '"+DtoS(dDataBase)+"' ,		"
					 	cUpdate3 += "			ZP4_HORA	= '"+Time()+"'					"
						cUpdate3 += "	WHERE 	ZP4_FILIAL 	= '"+TMPZP4->ZP4_FILIAL+"'  	" //'"+xFilial("ZP4")+"'	   		"
						cUpdate3 += "	AND  	ZP4_MAT 	= '"+TMPZP4->ZP4_MAT+"'		 	"
						cUpdate3 += "	AND 	ZP4_DTALT	= '"+TMPZP4->ZP4_DTALT+"'		"
						cUpdate3 += "	AND 	D_E_L_E_T_ 	= '' 							"
					
						TCSQLEXEC(cUpdate3) 	
				
				End Transaction



			Else // se ja existir spf com data maoir
			
				conout(" Imp Turno / Funcionario "+TMPZP4->ZP4_MAT+" data "+TMPZP4->ZP4_DTALT+" menor a ja cadastrada ")
			
				Begin Transaction 
			
			   		cUpdate6 := "	UPDATE 	"+RetSQLName("ZP4")+"						"
					cUpdate6 += "	SET 	D_E_L_E_T_ 	= '*' ,							"
			 		cUpdate6 += "			ZP4_DATA	= '"+DtoS(dDataBase)+"' ,		"
			 		cUpdate6 += "			ZP4_HORA	= '"+Time()+"'					"
					cUpdate6 += "	WHERE 	ZP4_FILIAL 	= '"+xFilial("ZP4")+"'	   		"
					cUpdate6 += "	AND  	ZP4_MAT 	= '"+TMPZP4->ZP4_MAT+"'		 	"
					cUpdate6 += "	AND 	ZP4_DTALT	= '"+TMPZP4->ZP4_DTALT+"'		"
					cUpdate6 += "	AND 	ZP4_TNPARA	= '"+TMPZP4->ZP4_TNPARA+"'		"
					cUpdate6 += "	AND 	D_E_L_E_T_ 	= '' 							"
			
					TCSQLEXEC(cUpdate6) 
			
				End Transaction
						
			EndIf
			
			TMPSPF3->(DbCloseArea())
			
		EndIf
	    TMPSPF1->(DbCloseArea())
	
	TMPZP4->(dbSkip())
	End	

TMPZP4->(DbCloseArea())

ConOut("Fim Job de importacao Tephra de turnos de trabalho data: "+DtoC(Date())+" hora: "+Time()+" " )

RpcClearEnv()

Return()