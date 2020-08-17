#include 'protheus.ch'
#include 'topconn.ch'
//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTBR03
@Rotina de impressใo do Balancete de Consolida็ใo
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------            
USER FUNCTION ASCTBR03
Local lRet   	    := .T.
Local aParam 		:= {}                
Local aBox   		:= {}      
Local cDataAte		:= SPACE(06)
Local oReport        
Local cQ			:= ""
Private cCadastro  := "Consolida็ใo Contแbil"
Private nColunas   := 0                       

AADD(aBox,	{ 1, "Estrutura de Consolida็ใo", Space(03),"@!","" ,"",".T.",10,.T.	}) 
//AADD(aBox,	{ 1, "Consolidadora", 	Space(LEN(cFilAnt)+2),"@!","" ,"EMP",".T.",30,.T.	}) 
AADD(aBox,	{ 1, "Periodo ",  cDataAte,"@!","" ,"",".T.",20,.T.	}) 
AADD(aBox,	{ 1, "Tipo de Saldo ", Space(1),"@!","" ,"",".T.",05,.T.	}) 
AADD(aBox,	{ 1, "Resultado 1-Acumulado,2-Mes ", Space(1),"@!","" ,"",".T.",05,.T.	}) 

If ParamBox( aBox,cCadastro,aParam,,,,,,,,.F.,.T.)
	MV_PAR01 := ALLTRIM(aParam[1])           
//	MV_PAR02 := ALLTRIM(aParam[2])           
	MV_PAR03 := LASTDAY(CTOD("01/"+SUBSTR(aParam[2],1,2)+"/"+SUBSTR(aParam[2],3,4)))
	MV_PAR04 := aParam[3] 
	MV_PAR05 := aParam[4]
    lRet := .T.      
Else
	lRet := .F.
ENDIF

IF lRet

 	IF SELECT("XSZ6") <> 0
		XSZ6->(DBCLOSEAREA())	
	ENDIF

	// Verifico se existe a estrutura de consolida็ใo informada
	cQ := "SELECT Z6_EMP, Z6_SEQ , Z6_EMPCONS, Z6_TPSALDO"
	cQ += " FROM "+RetSqlName("SZ6")+" SZ6 "   
	cQ += " WHERE Z6_CODIGO = '"+MV_PAR01+"' AND D_E_L_E_T_ <> '*' "
//	cQ += " AND Z6_EMP = '"+MV_PAR02+"' AND D_E_L_E_T_ <> '*' "
	cQ += " ORDER BY Z6_SEQ"
	cQ	:= ChangeQuery(cQ)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),"XSZ6",.T.,.T.)
	IF XSZ6->(EOF())
		ApMsgAlert("Nใo existem dados com os parโmetros informados.")
		lRet := .F.
	ELSE

    	// Verifico a quantidade de colunas
		XSZ6->(DBGOTOP())
		WHILE XSZ6->(!EOF())
			nColunas++
			XSZ6->(DBSKIP())
		END

		oReport := Report()
		oReport:PrintDialog()
	
 	ENDIF    
 	
 	XSZ6->(DBCLOSEAREA())
 	
ENDIF        

RETURN
//-----------------------------------------------------------------------
/*{Protheus.doc} Report
@Monta objeto de impressใo
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------            
Static Function Report
Local oReport 
Local oSection1            
Local nX	:= 0
Local cCampo:= ""
oReport:= TReport():New("ASCTBR03","Consolida็ใo","", {|oReport| Ledados(oReport)},"Consolida็ใo") 

oReport:SetLandscape()
oReport:SetTotalInLine(.F.)

oSection1 := TRSection():New(oReport,"Consolida็ใo",{})
oSection1:SetTotalInLine(.F.)
oSection1:SetHeaderPage()
oSection1:SetEditCell(.F.)                        

TRCell():New(oSection1,"CONTAN1"        ,,""  ,/*Picture*/,05,.F.,)
TRCell():New(oSection1,"CONTAN2"        ,,""  ,/*Picture*/,05,.F.,)
TRCell():New(oSection1,"CONTAN3"        ,,""  ,/*Picture*/,05,.F.,)
TRCell():New(oSection1,"CONTAN4"        ,,""  ,/*Picture*/,05,.F.,)
TRCell():New(oSection1,"CONTAN5"        ,,""  ,/*Picture*/,05,.F.,)
TRCell():New(oSection1,"CONTAN6"        ,,""  ,/*Picture*/,15,.F.,)
TRCell():New(oSection1,"DESCRICAO"    	,,""  ,/*Picture*/,40,.F.,)

FOR nX := 1 TO nColunas 
	cCampo := "BAL"+STRZERO(nX,2)
	TRCell():New(oSection1,"BAL"+STRZERO(nX,2),,""  ,/*Picture*/,25,.F.,)
	                                
	cCampo := "ELIDB"+STRZERO(nX,2)
	TRCell():New(oSection1,"ELIDB"+STRZERO(nX,2),,""  ,/*Picture*/,25,.F.,)
	
	cCampo := "ELICR"+STRZERO(nX,2)
	TRCell():New(oSection1,"ELICR"+STRZERO(nX,2),,""  ,/*Picture*/,25,.F.,)
	                         
	cCampo := "CONSO"+STRZERO(nX,2)
	TRCell():New(oSection1,"CONSO"+STRZERO(nX,2),,""  ,/*Picture*/,25,.F.,)
NEXT	                                                   

nX := 99

cCampo := "BAL"+STRZERO(nX,2)
TRCell():New(oSection1,cCampo,,""  ,/*Picture*/,25,.F.,)
	                                
cCampo := "ELIDB"+STRZERO(nX,2)
TRCell():New(oSection1,cCampo,,""  ,/*Picture*/,25,.F.,)
	
cCampo := "ELICR"+STRZERO(nX,2)
TRCell():New(oSection1,cCampo,,""  ,/*Picture*/,25,.F.,)
	                         
cCampo := "CONSO"+STRZERO(nX,2)
TRCell():New(oSection1,cCampo,,""  ,/*Picture*/,25,.F.,)

Return(oReport)
//-----------------------------------------------------------------------
/*{Protheus.doc} Ledados
@Seleciona os dados de impressใo
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------            
Static Function Ledados(oReport)
Local oSection1 := oReport:Section(1) 
Local cQ		:= ""  
Local nSaldo	:= 0     
Local nX 	:= 0
Local cMens	:= ""
Local lPeriodo:= .T.
Local lContinua	:= .T. 
Local aPeriodos := {}
Local cCampo 	:= ""
Local nX 		:= 0
Local nNivContas:= 6
Local nTcons	:= 0
Local nPos		:= 0
Private nConta	:= 0                              
Private cTRB1   := CriaTrab(nil,.F.)
Private cTRB2   := CriaTrab(nil,.F.)
Private aInvest := {}   
Private cLisItem:= ""

// Cria tabela para armazenar elimina็๕es por empresa
CRIATRB1()

// Cria tabela para armazenar o balancete por empresa e consolidado                                                
CRIATRB2()

//*********
oSection1:Init()    

//******* Impressใo do cabe็alho                    

oSection1:Cell("BAL01"):SetBlock( { || "Periodo e Empresas" })
oSection1:PrintLine()

oSection1:Cell("BAL01"):SetBlock( { || "Perํodo: "+DTOC(MV_PAR03) })
oSection1:PrintLine()

XSZ6->(DBGOTOP())
nConta := 0
WHILE XSZ6->(!EOF())
	nConta++   
	cCampo := "BAL"+STRZERO(nConta,2)	
	oSection1:Cell(cCampo):SetBlock( { || EMPCONS(1) })
	cCampo := "ELIDB"+STRZERO(nConta,2)	
	oSection1:Cell(cCampo):SetBlock( { || EMPCONS(2) })

	// Atualizo TRB1 com os valores de elimina็ใo

	IF !ATUTRB1(MV_PAR03, XSZ6->Z6_EMP, XSZ6->Z6_EMPCONS)
		lContinua := .F.               
		EXIT
	ENDIF

	XSZ6->(DBSKIP())
END	                            

XSZ6->(DBGOTOP())

// Atualiza matriz de contas e itens de investimento

CTD->(DBSETORDER(1))

cTab	:= "CQ4"+SUBSTR(XSZ6->Z6_EMPCONS,1,2)+"0"

cQuery		:= "SELECT CQ4_CONTA, CQ4_ITEM FROM "+cTab
cQuery		+= " WHERE " +CRLF 
cQuery		+= " 	D_E_L_E_T_ 		= ' ' " +CRLF 
cQuery		+= " 	AND CQ4_DATA >= '"+STR(YEAR(MV_PAR03),4)+"0101"+"'  AND CQ4_DATA  <= '"+DTOS(MV_PAR03)+"' "
cQuery		+= " GROUP BY CQ4_CONTA, CQ4_ITEM"
cQ	:= ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),"XCQ4",.T.,.T.)    

WHILE XCQ4->(!EOF())
   	IF SUBSTR(XCQ4->CQ4_CONTA,1,3) <> "203"
   		CTD->(DBSEEK(XFILIAL("CTD")+XCQ4->CQ4_ITEM))
 		IF ASCAN(aInvest,{|x| x[1] == XCQ4->CQ4_CONTA .AND. x[2] == XCQ4->CQ4_ITEM }) == 0
			AADD(aInvest,{XCQ4->CQ4_CONTA,XCQ4->CQ4_ITEM,'',CTD->CTD_DESC01})
		ENDIF 
	ENDIF	
   	XCQ4->(DBSKIP())
END
XCQ4->(DBCLOSEAREA())
                              
aSort(aInvest,,,{|x,y| x[1] < y[1] })

IF !lContinua
	RETURN(lContinua)
ENDIF
	
oSection1:Cell("BAL99"):SetBlock( { || "Totais" })	
	
nConta := 0

oSection1:PrintLine()      

oSection1:Cell("CONTAN1"):SetBlock( { || "Nivel 1" })	
oSection1:Cell("CONTAN2"):SetBlock( { || "Nivel 2" })	
oSection1:Cell("CONTAN3"):SetBlock( { || "Nivel 3" })	
oSection1:Cell("CONTAN4"):SetBlock( { || "Nivel 4" })	
oSection1:Cell("CONTAN5"):SetBlock( { || "Nivel 5" })	
oSection1:Cell("CONTAN6"):SetBlock( { || "Cod. Conta" })	
oSection1:Cell("DESCRICAO"):SetBlock( { || "Descri็ใo" })	 

nConta := 0
XSZ6->(DBGOTOP())
WHILE XSZ6->(!EOF())
    
	nConta++   
	cCampo := "BAL"+STRZERO(nConta,2)	
	oSection1:Cell(cCampo):SetBlock( { || "Saldo" })
	
	cCampo := "ELIDB"+STRZERO(nConta,2)	
	oSection1:Cell(cCampo):SetBlock( { || "D้bito" })

	cCampo := "ELICR"+STRZERO(nConta,2)	
	oSection1:Cell(cCampo):SetBlock( { || "Cr้dito" })

	cCampo := "CONSO"+STRZERO(nConta,2)	
	oSection1:Cell(cCampo):SetBlock( { || "Valor Orcado" })

	XSZ6->(DBSKIP())
END	

nConta := 99
cCampo := "BAL"+STRZERO(nConta,2)	
oSection1:Cell(cCampo):SetBlock( { || "Saldo" })
	
cCampo := "ELIDB"+STRZERO(nConta,2)	
oSection1:Cell(cCampo):SetBlock( { || "D้bito" })

cCampo := "ELICR"+STRZERO(nConta,2)	
oSection1:Cell(cCampo):SetBlock( { || "Cr้dito" })

cCampo := "CONSO"+STRZERO(nConta,2)	
oSection1:Cell(cCampo):SetBlock( { || "Consolidado" })

oSection1:PrintLine()                     

//******  Fim Cabe็alho


// Blocos de impressใo


oSection1:Cell("CONTAN1"):SetBlock( { || CONSO->CONTAN1 })	
oSection1:Cell("CONTAN2"):SetBlock( { || CONSO->CONTAN2 })	
oSection1:Cell("CONTAN3"):SetBlock( { || CONSO->CONTAN3 })	
oSection1:Cell("CONTAN4"):SetBlock( { || CONSO->CONTAN4 })	
oSection1:Cell("CONTAN5"):SetBlock( { || CONSO->CONTAN5 })	
oSection1:Cell("CONTAN6"):SetBlock( { || CONSO->CONTAN6 })	
oSection1:Cell("DESCRICAO"):SetBlock( { || CONSO->DESCRICAO })	 

nConta := 0                               
XSZ6->(DBGOTOP())
WHILE XSZ6->(!EOF())
    
	nConta++   
	cCampo := "BAL"+STRZERO(nConta,2)	
	oSection1:Cell(cCampo):SetBlock( { ||  TRANSFORM(VALOR("BAL"),"@E 99,999,999,999,999.99") })
	
	cCampo := "ELIDB"+STRZERO(nConta,2)	
	oSection1:Cell(cCampo):SetBlock( { ||  TRANSFORM(VALOR("ELIDB"),"@E 99,999,999,999,999.99") })

	cCampo := "ELICR"+STRZERO(nConta,2)	
	oSection1:Cell(cCampo):SetBlock( { ||  TRANSFORM(VALOR("ELICR"),"@E 99,999,999,999,999.99") })

	cCampo := "CONSO"+STRZERO(nConta,2)	
	oSection1:Cell(cCampo):SetBlock( { ||  TRANSFORM(VALOR("CONSO"),"@E 99,999,999,999,999.99") })

	XSZ6->(DBSKIP())
END	                                                                                   

oSection1:Cell("BAL99"):SetBlock( {   || TRANSFORM(CONSO->BAL99,"@E 99,999,999,999,999.99") })
oSection1:Cell("ELIDB99"):SetBlock( { || TRANSFORM(CONSO->ELIDB99,"@E 99,999,999,999,999.99") })   
oSection1:Cell("ELICR99"):SetBlock( { || TRANSFORM(CONSO->ELICR99,"@E 99,999,999,999,999.99") })
oSection1:Cell("CONSO99"):SetBlock( { || TRANSFORM(CONSO->CONSO99,"@E 99,999,999,999,999.99") })  

CT1->(DBGOTOP())
WHILE CT1->(!EOF())    

    // Verifica se faz a abertura por item contแbil

	nPos := ASCAN(aInvest,{|x| ALLTRIM(x[1]) == ALLTRIM(CT1->CT1_CONTA)})      
	 	
    IF nPos == 0   // POR CONTA

		RECLOCK("CONSO",.T.)  
		CONSO->CONTA	:= CT1->CT1_CONTA
		CONSO->TIPO  	:= CT1->CT1_CLASSE
		CONSO->CONTASUP	:= CT1->CT1_CTASUP
		
		IF LEN(ALLTRIM(CT1->CT1_CONTA)) == 1
			CONSO->CONTAN1 := CT1->CT1_CONTA
			CONSO->CONTAN6 := "Totais"
		ENDIF	
		IF LEN(ALLTRIM(CT1->CT1_CONTA)) == 3
			CONSO->CONTAN2 := CT1->CT1_CONTA
			CONSO->CONTAN6 := "Totais"		
		ENDIF	
		IF LEN(ALLTRIM(CT1->CT1_CONTA)) == 6
			CONSO->CONTAN3 := CT1->CT1_CONTA
			CONSO->CONTAN6 := "Totais"		
		ENDIF	           
		IF LEN(ALLTRIM(CT1->CT1_CONTA)) == 9
			CONSO->CONTAN4 := CT1->CT1_CONTA
			CONSO->CONTAN6 := "Totais"		
		ENDIF	       
		IF LEN(ALLTRIM(CT1->CT1_CONTA)) == 12
			CONSO->CONTAN5 := CT1->CT1_CONTA
			CONSO->CONTAN6 := "Totais"		
		ENDIF	
		IF LEN(ALLTRIM(CT1->CT1_CONTA)) == 15
			CONSO->CONTAN6 := CT1->CT1_CONTA
		ENDIF	                                                    
		

		CONSO->DESCRICAO := CT1->CT1_DESC01
	
		nConta 	:= 0
		nTcons	:= 0        
		nTDeb	:= 0
		nTCre	:= 0
		nTResul := 0                  
		XSZ6->(DBGOTOP())
	
		WHILE XSZ6->(!EOF())

		    IF CT1->CT1_CLASSE == "2" // Analํtica                                                                                          
		    
		
				nValBaL := U_SaldoCons(CT1->CT1_CONTA, MV_PAR03, SUBSTR(XSZ6->Z6_EMPCONS,1,2), XSZ6->Z6_EMPCONS,MV_PAR04,1,"",IF(SUBSTR(CT1->CT1_CONTA,1,1) >="3" .AND. ALLTRIM(CT1->CT1_CONTA) <> "502001001001001",MV_PAR05,"1"))

				nConta++   
				cCampo := "BAL"+STRZERO(nConta,2)	
				CONSO->&(cCampo) := nValBaL
				nValCons := nValBaL
				nTcons += nValBaL
	        
		        nValEli := {0,0}
	                                          
				nValELI := U_SaldoCons(CT1->CT1_CONTA, MV_PAR03, SUBSTR(XSZ6->Z6_EMP,1,2), XSZ6->Z6_EMPCONS,"E",2,"",IF(SUBSTR(CT1->CT1_CONTA,1,1) >="3" .AND. ALLTRIM(CT1->CT1_CONTA) <> "502001001001001",MV_PAR05,"1"))
			
				cCampo := "ELIDB"+STRZERO(nConta,2)	
				CONSO->&(cCampo) := nValELI[1]
				nTDeb += nValELI[1]
			
				cCampo 	:= "ELICR"+STRZERO(nConta,2)	
				CONSO->&(cCampo) := nValELI[2]
	        	nTCre += nValELI[2] 

				IF SUBSTR(CT1->CT1_CONTA,1,1) < "3"

		        	nValcons := nValcons + nValELI[1] - nValELI[2]               
		        	
				ELSE
		 
		        	nValcons := nValcons - nValELI[1] + nValELI[2]                       
		 
		       	ENDIF
		    
			    nTResul +=nValcons
	        
	   			cCampo := "CONSO"+STRZERO(nConta,2)	
				CONSO->&(cCampo) := nValcons
				
	    	ENDIF                                      
	  
	 		XSZ6->(DBSKIP())
		END	
		CONSO->BAL99   := nTcons
		CONSO->ELIDB99 := nTDeb
		CONSO->ELICR99 := nTCre
		CONSO->CONSO99 := nTResul
	    
		CONSO->(MsUnlock())

    ELSE  // POR ITEM
        
		WHILE ALLTRIM(aInvest[nPos][1]) == ALLTRIM(CT1->CT1_CONTA)
			RECLOCK("CONSO",.T.)  
			CONSO->CONTA	:= CT1->CT1_CONTA
			CONSO->TIPO  	:= CT1->CT1_CLASSE
			CONSO->CONTASUP	:= CT1->CT1_CTASUP
			
			IF LEN(ALLTRIM(CT1->CT1_CONTA)) == 1
				CONSO->CONTAN1 := CT1->CT1_CONTA
				CONSO->CONTAN6 := "Totais"
			ENDIF	
			IF LEN(ALLTRIM(CT1->CT1_CONTA)) == 3
				CONSO->CONTAN2 := CT1->CT1_CONTA
				CONSO->CONTAN6 := "Totais"		
			ENDIF	
			IF LEN(ALLTRIM(CT1->CT1_CONTA)) == 6
				CONSO->CONTAN3 := CT1->CT1_CONTA
				CONSO->CONTAN6 := "Totais"		
			ENDIF	           
			IF LEN(ALLTRIM(CT1->CT1_CONTA)) == 9
				CONSO->CONTAN4 := CT1->CT1_CONTA
				CONSO->CONTAN6 := "Totais"		
			ENDIF	       
			IF LEN(ALLTRIM(CT1->CT1_CONTA)) == 12
				CONSO->CONTAN5 := CT1->CT1_CONTA
				CONSO->CONTAN6 := "Totais"		
			ENDIF	
			IF LEN(ALLTRIM(CT1->CT1_CONTA)) == 15
				CONSO->CONTAN6 := CT1->CT1_CONTA
			ENDIF	                                                    

		
	        CONSO->ITEMCTA	:= aInvest[nPos][2]
			CONSO->DESCRICAO := aInvest[nPos][4]
		
			nConta 	:= 0
			nTcons	:= 0        
			nTDeb	:= 0
			nTCre	:= 0
			nTResul := 0                  
			XSZ6->(DBGOTOP())
		
			WHILE XSZ6->(!EOF())
				
			    IF CT1->CT1_CLASSE == "2" // Analํtica


					nValBaL := U_SaldoCons(CT1->CT1_CONTA, MV_PAR03, SUBSTR(XSZ6->Z6_EMPCONS,1,2), XSZ6->Z6_EMPCONS,MV_PAR04,1,aInvest[nPos][2],IF(SUBSTR(CT1->CT1_CONTA,1,1) >="3" .AND. ALLTRIM(CT1->CT1_CONTA) <> "502001001001001",MV_PAR05,"1"))
					nConta++   
					cCampo := "BAL"+STRZERO(nConta,2)	
					CONSO->&(cCampo) := nValBaL
					nValCons := nValBaL
					nTcons += nValBaL
		        
		        	nValEli := {0,0}   

					nValELI := U_SaldoCons(CT1->CT1_CONTA, MV_PAR03, SUBSTR(XSZ6->Z6_EMP,1,2), XSZ6->Z6_EMPCONS,"E",2,aInvest[nPos][2],IF(SUBSTR(CT1->CT1_CONTA,1,1) >="3" .AND. ALLTRIM(CT1->CT1_CONTA) <> "502001001001001",MV_PAR05,"1"))
				
					cCampo := "ELIDB"+STRZERO(nConta,2)	
					CONSO->&(cCampo) := nValELI[1]
					nTDeb += nValELI[1]
				
					cCampo 	:= "ELICR"+STRZERO(nConta,2)	
					CONSO->&(cCampo) := nValELI[2]
		        	nTCre += nValELI[2] 

					IF SUBSTR(CT1->CT1_CONTA,1,1) < "3"
   	
			        	nValcons := nValcons + nValELI[1] - nValELI[2]               
			        	
					ELSE
		 
			        	nValcons := nValcons - nValELI[1] + nValELI[2]                       
		 
			       	ENDIF

/*
 		   			IF CT1->CT1_NORMAL == "1"
			        	nValcons := nValcons + nValELI[1] - nValELI[2]               
		        	ELSE
			        	nValcons := nValcons - nValELI[1] + nValELI[2]                       
		        	ENDIF
*/		    
				    nTResul +=nValcons
		        
					cCampo := "CONSO"+STRZERO(nConta,2)	
					CONSO->&(cCampo) := nValcons
		        ENDIF				                                          
		  
		 		XSZ6->(DBSKIP())
			END	
			CONSO->BAL99   := nTcons
			CONSO->ELIDB99 := nTDeb
			CONSO->ELICR99 := nTCre
			CONSO->CONSO99 := nTResul
		    
			CONSO->(MsUnlock())
			                                                                    
			nPos++
			IF nPos > LEN(aInvest)
				EXIT
			ENDIF
		END
	ENDIF	
	CT1->(DBSKIP())
END


// Ajusta as contas de nใo controladores

IF CONSO->(DBSEEK("502001001001001"))
	RECLOCK("CONSO",.F.)
	CONSO->CONTASUP:= "203007002001        "
	CONSO->CONTAN6 := ""		
        
	CONSO->(MsUnlock())
ENDIF

// Atualiza contas sint้ticas / DEBITO / CREDITO E CONSOLIDADO                                   
CONSO->(DBGOTOP()) 

WHILE CONSO->(!EOF())
    cConta := CONSO->CONTA 
    nReg := CONSO->(RECNO())
	aLinha := {}        
	nBal   := 0
	nEliDB := 0
	nEliCR := 0
	nTot   := 0
    IF CONSO->TIPO == "2" .AND. CONSO->CONTA <> "502001001001002"  // Analํtica - Atualizar as superiores

		CT1->(DBSEEK(XFILIAL("CT1")+CONSO->CONTA))

		// Pego o valor de todas as colunas 
    	FOR nConta := 1 TO nColunas

			cCampo 	:= "BAL"+STRZERO(nConta,2)
			nBal := CONSO->&(cCampo)	
			
			cCampo 	:= "ELIDB"+STRZERO(nConta,2)	
			nEliDB	:= CONSO->&(cCampo)
			
			cCampo 	:= "ELICR"+STRZERO(nConta,2)	
			nEliCR	:= CONSO->&(cCampo)

			cCampo 	:= "CONSO"+STRZERO(nConta,2)
		    nTot	:= CONSO->&(cCampo)
		    
		    AADD(aLinha,{nBal,nEliDB,nEliCR,nTot,CT1->CT1_NORMAL})
		    
		NEXT
	    AADD(aLinha,{CONSO->BAL99,CONSO->ELIDB99,CONSO->ELICR99,CONSO->CONSO99,CT1->CT1_NORMAL})
	    cSup := CONSO->CONTASUP
	    CONSO->(DBSEEK(cSup))
	    WHILE CONSO->(!EOF())      
    		CT1->(DBSEEK(XFILIAL("CT1")+cSup))
	    	RECLOCK("CONSO",.F.)
	    	
			// Atualizado as contas com as colunas
    		FOR nConta := 1 TO nColunas
			
				IF CT1->CT1_NORMAL == "1"  // Conta devedora
				
				   //	IF aLinha[nConta][5] == "1"	.AND. SUBSTR(CT1->CT1_CONTA,1,1) < "3" // Superior devedora, linha devedora e nใo ้ resultado = SOMA		
		                                         
						cCampo 	:= "BAL"+STRZERO(nConta,2)	
						CONSO->&(cCampo) := CONSO->&(cCampo) += aLinha[nConta][1]

	                    cCampo 	:= "CONSO"+STRZERO(nConta,2)
			    		CONSO->&(cCampo) := CONSO->&(cCampo) += aLinha[nConta][4]
/*	   		
			   		ELSE  // Superior devedora, linha credora ou devedora ้ resultado = SUBTRAI		
			   		
						cCampo 	:= "BAL"+STRZERO(nConta,2)	
						CONSO->&(cCampo) := CONSO->&(cCampo) -= aLinha[nConta][1]

                        cCampo 	:= "CONSO"+STRZERO(nConta,2)
			    		CONSO->&(cCampo) := CONSO->&(cCampo) -= aLinha[nConta][4]
		   		
                    ENDIF
*/
					cCampo 	:= "ELIDB"+STRZERO(nConta,2)	
					CONSO->&(cCampo) := CONSO->&(cCampo) += aLinha[nConta][2]
					nEliDB	:= CONSO->&(cCampo)
	
					cCampo 	:= "ELICR"+STRZERO(nConta,2)	
					CONSO->&(cCampo) := CONSO->&(cCampo) += aLinha[nConta][3]
					nEliCR	:= CONSO->&(cCampo)
			
				ELSE     
				
					IF aLinha[nConta][5] == "1"	.AND. SUBSTR(CT1->CT1_CONTA,1,1) < "3" // Superior credora, linha devedora e nใo ้ resultado = SUBTRAI

						cCampo 	:= "BAL"+STRZERO(nConta,2)	
						CONSO->&(cCampo) := CONSO->&(cCampo) -= aLinha[nConta][1]

						cCampo 	:= "CONSO"+STRZERO(nConta,2)
			    		CONSO->&(cCampo) := CONSO->&(cCampo) -= aLinha[nConta][4] 
				    	
			    	ELSE // Superior credora, linha credora ou devedora  ้ resultado = SOMA		

						cCampo 	:= "BAL"+STRZERO(nConta,2)	
						CONSO->&(cCampo) := CONSO->&(cCampo) += aLinha[nConta][1]

   						cCampo 	:= "CONSO"+STRZERO(nConta,2)
				    	CONSO->&(cCampo) := CONSO->&(cCampo) += aLinha[nConta][4] 
				    	
			    	ENDIF	
                                                              
					cCampo 	:= "ELIDB"+STRZERO(nConta,2)	
					CONSO->&(cCampo) := CONSO->&(cCampo) += aLinha[nConta][2]
					nEliDB	:= CONSO->&(cCampo)
		
					cCampo 	:= "ELICR"+STRZERO(nConta,2)	
					CONSO->&(cCampo) := CONSO->&(cCampo) += aLinha[nConta][3]
					nEliCR	:= CONSO->&(cCampo)
			
				ENDIF                    
                
			NEXT                 
			                             
			    
			IF CT1->CT1_NORMAL == "1"  // Conta devedora
				
				IF aLinha[Len(aLinha)][5] == "1" .AND. SUBSTR(CT1->CT1_CONTA,1,1) < "3" // Superior devedora, linha devedora e nใo ้ resultado = SOMA		
					CONSO->BAL99   := CONSO->BAL99 += aLinha[Len(aLinha)][1]
					CONSO->CONSO99 := CONSO->CONSO99 += aLinha[Len(aLinha)][4]

			   	ELSE  // Superior devedora, linha credora ou devedora ้ resultado = SUBTRAI		
					CONSO->BAL99   := CONSO->BAL99 -= aLinha[Len(aLinha)][1]  
					CONSO->CONSO99 := CONSO->CONSO99 -= aLinha[Len(aLinha)][4]					
                ENDIF
				
			ELSE     
				
				IF aLinha[Len(aLinha)][5] == "1" .AND. SUBSTR(CT1->CT1_CONTA,1,1) < "3" // Superior credora, linha devedora e nใo ้ resultado = SUBTRAI	
					CONSO->BAL99   := CONSO->BAL99 -= aLinha[Len(aLinha)][1]
					CONSO->CONSO99 := CONSO->CONSO99 -= aLinha[Len(aLinha)][4]					
		   		ELSE  // Superior credora, linha credora ou devedora  ้ resultado = SOMA		
					CONSO->BAL99   := CONSO->BAL99 += aLinha[Len(aLinha)][1]
					CONSO->CONSO99 := CONSO->CONSO99 += aLinha[Len(aLinha)][4]					
                ENDIF				
			ENDIF                    			    
			    
			CONSO->ELIDB99 := CONSO->ELIDB99 += aLinha[Len(aLinha)][2]
			CONSO->ELICR99 := CONSO->ELICR99 += aLinha[Len(aLinha)][3]

			CONSO->(MsUnLock())
	
	        IF !EMPTY(CONSO->CONTASUP)
		    	cSup := CONSO->CONTASUP
		    	CONSO->(DBSEEK(cSup))
		    ELSE
		    	EXIT
		    ENDIF	            

	    END
	    
	ENDIF                       
	CONSO->(DBGOTO(nReg))
	CONSO->(DBSKIP())
END    

// Ajusta as contas de nใo controladores

IF CONSO->(DBSEEK("502001001001001"))
	RECLOCK("CONSO",.F.)
	CONSO->CONTA :=   "203007002001999     "  
	CONSO->CONTAN6 := "**********"
	CONSO->(MsUnlock())
ENDIF

// Ajusta sequencia de impressใo
CONSO->(DBGOTOP())
cSeq	:= "0000"
cSupAnt	:= ""               
cSup	:= "" 
cConta	:= ""
WHILE CONSO->(!EOF())
    IF CONSO->TIPO == "2" .AND. CONSO->CONTA <> "502001001001002"
        cConta := CONSO->CONTA
        nReg := CONSO->(RECNO())
        IF EMPTY(cSupAnt)
	        cSupAnt := CONSO->CONTASUP
		ENDIF

		// Nivel 6        
    	IF CONSO->CONTASUP == cSupAnt   // 1.01.001.001.001.001
			cSeq := Soma1(cSeq)    
			RECLOCK("CONSO",.F.)
			CONSO->ORDEM := cSeq
			MsUnlock()
		ELSE         
			// Nivel 5
			CONSO->(DBSEEK(cSupAnt))	// 1.01.001.001.001
			cSeq := Soma1(cSeq)    			
			RECLOCK("CONSO",.F.)
			CONSO->ORDEM := cSeq
			MsUnlock()

		    // Nivel 4					// 1.01.001.001
			IF SUBSTR(ALLTRIM(cConta),1,9) <> SUBSTR(ALLTRIM(cSupAnt),1,9).AND. !EMPTY(CONSO->CONTASUP)
				cSup := CONSO->CONTASUP
				CONSO->(DBSEEK(cSup)) 
				cSeq := Soma1(cSeq)    			
				RECLOCK("CONSO",.F.)
				CONSO->ORDEM := cSeq
				MsUnlock()
				
				// Nivel 3				// 1.01.001
				IF SUBSTR(ALLTRIM(cConta),1,6) <> SUBSTR(ALLTRIM(cSupAnt),1,6).AND. !EMPTY(CONSO->CONTASUP)
					cSup := CONSO->CONTASUP
					CONSO->(DBSEEK(cSup)) 
					cSeq := Soma1(cSeq)    			
					RECLOCK("CONSO",.F.)
					CONSO->ORDEM := cSeq
					MsUnlock()
					
					// Nivel 2			// 1.01
					IF SUBSTR(ALLTRIM(cConta),1,3) <> SUBSTR(ALLTRIM(cSupAnt),1,3)
						cSup := CONSO->CONTASUP
						CONSO->(DBSEEK(cSup)) 
						cSeq := Soma1(cSeq)    			
						RECLOCK("CONSO",.F.)
						CONSO->ORDEM := cSeq
						MsUnlock()
					
						// Nivel 1			// 1
						IF SUBSTR(ALLTRIM(cConta),1,1) <> SUBSTR(ALLTRIM(cSupAnt),1,1)
							cSup := CONSO->CONTASUP
							CONSO->(DBSEEK(cSup)) 
							cSeq := Soma1(cSeq)    			
							RECLOCK("CONSO",.F.)
							CONSO->ORDEM := cSeq
							MsUnlock()       
						ENDIF
					ENDIF
				ENDIF
			ENDIF      
			CONSO->(DBGOTO(nReg))
			cSupAnt := CONSO->CONTASUP	
			cSeq := Soma1(cSeq)    
			RECLOCK("CONSO",.F.)
			CONSO->ORDEM := cSeq
			MsUnlock()
		ENDIF			
	ENDIF				
	CONSO->(DBSKIP())
END


cSeq := Soma1(cSeq)    
CONSO->(DBSEEK("502001001001002"))
RECLOCK("CONSO",.F.)
CONSO->ORDEM := cSeq 
CONSO->CONTAN6 := "**********"
CONSO->(MsUnlock())

// Valores do resultado de nใo controladores
aResunct := {}
FOR nX := 1 TO nColunas         
	cCampo 	:= "BAL"+STRZERO(nX,2)	
	nBal	:= CONSO->&(cCampo)

	cCampo 	:= "ELIDB"+STRZERO(nX,2)	
	nEliDB	:= CONSO->&(cCampo)
		
	cCampo 	:= "ELICR"+STRZERO(nX,2)	
	nEliCR	:= CONSO->&(cCampo)

	cCampo 	:= "CONSO"+STRZERO(nX,2)
	nConso	:= 	CONSO->&(cCampo)

	AADD(aResunct,{nBal,nEliDB, nEliCR, nConso})
NEXT                                           

nX := 99
cCampo 	:= "BAL"+STRZERO(nX,2)	
nBal	:= CONSO->&(cCampo)

cCampo 	:= "ELIDB"+STRZERO(nX,2)	
nEliDB	:= CONSO->&(cCampo)
		
cCampo 	:= "ELICR"+STRZERO(nX,2)	
nEliCR	:= CONSO->&(cCampo)

cCampo 	:= "CONSO"+STRZERO(nX,2)
nConso	:= 	CONSO->&(cCampo)

AADD(aResunct,{nBal,nEliDB, nEliCR, nConso})


CONSO->(DBSEEK("3"))
FOR nX := 1 TO nColunas 

	cCampo 	:= "BAL"+STRZERO(nX,2)	
	nBal	:= CONSO->&(cCampo)

	aResunct[nX][1] +=nBal


	cCampo 	:= "ELIDB"+STRZERO(nX,2)	
	nEliDB	:= CONSO->&(cCampo)

	aResunct[nX][2] +=nEliDB
		
	cCampo 	:= "ELICR"+STRZERO(nX,2)	
	nEliCR	:= CONSO->&(cCampo)
                  
	aResunct[nX][3] +=nEliCR

	cCampo 	:= "CONSO"+STRZERO(nX,2)
	nConso	:= 	CONSO->&(cCampo)
                            
	aResunct[nX][4] +=nConso

NEXT

nX := 99
cCampo 	:= "BAL"+STRZERO(nX,2)	
nBal	:= CONSO->&(cCampo)

aResunct[LEN(aResunct)][1] +=nBal


cCampo 	:= "ELIDB"+STRZERO(nX,2)	
nEliDB	:= CONSO->&(cCampo)

aResunct[LEN(aResunct)][2] +=nEliDB
		
cCampo 	:= "ELICR"+STRZERO(nX,2)	
nEliCR	:= CONSO->&(cCampo)
                  
aResunct[LEN(aResunct)][3] +=nEliCR

cCampo 	:= "CONSO"+STRZERO(nX,2)
nConso	:= 	CONSO->&(cCampo)
                            
aResunct[LEN(aResunct)][4] +=nConso


RECLOCK("CONSO",.T.)
CONSO->CONTA := "502001001001003" 
cSeq := Soma1(cSeq)    
CONSO->ORDEM := cSeq
CONSO->DESCRICAO := "RESULTADO COM NรO CONTROLADORES"
CONSO->CONTAN6   := "**********"
FOR nX := 1 TO nColunas 

	cCampo 	:= "BAL"+STRZERO(nX,2)	
	CONSO->&(cCampo) := aResunct[nX][1] 

	cCampo 	:= "ELIDB"+STRZERO(nX,2)	
	CONSO->&(cCampo) := aResunct[nX][2] 

	cCampo 	:= "ELICR"+STRZERO(nX,2)	
	CONSO->&(cCampo) := aResunct[nX][3] 
                  
	cCampo 	:= "CONSO"+STRZERO(nX,2)
	CONSO->&(cCampo) := aResunct[nX][4]

NEXT

nX := 99                               
cCampo 	:= "BAL"+STRZERO(nX,2)	
CONSO->&(cCampo) := aResunct[LEN(aResunct)][1] 

cCampo 	:= "ELIDB"+STRZERO(nX,2)	
CONSO->&(cCampo) := aResunct[LEN(aResunct)][2] 

cCampo 	:= "ELICR"+STRZERO(nX,2)	
CONSO->&(cCampo) := aResunct[LEN(aResunct)][3] 
                  
cCampo 	:= "CONSO"+STRZERO(nX,2)
CONSO->&(cCampo) := aResunct[LEN(aResunct)][4]

CONSO->(MsUnlock())

DBSELECTAREA("CONSO")
CONSO->(DBCLEARINDEX())
cArqTmp := CriaTrab(nil,.F.)

IndRegua("CONSO", cArqTmp, "ORDEM" ,,,,)
CONSO->(DBSETORDER(1))      

CONSO->(DBGOTOP())
WHILE CONSO->(!EOF())                        
    nConta := 0     
 	lImp := .F. 
    // Verifica se a linha estแ zerada, nใo imprime
    FOR nX := 1 TO nColunas
		cCampo 	:= "BAL"+STRZERO(nX,2)
		IF CONSO->&(cCampo)	<> 0
			lImp := .T.
		ENDIF
	
		cCampo 	:= "ELIDB"+STRZERO(nX,2)	
		IF CONSO->&(cCampo)	<> 0
			lImp := .T.
		ENDIF
			
		cCampo 	:= "ELICR"+STRZERO(nX,2)	
		IF CONSO->&(cCampo)	<> 0
			lImp := .T.
		ENDIF

		cCampo 	:= "CONSO"+STRZERO(nX,2)
		IF CONSO->&(cCampo)	<> 0
			lImp := .T.
		ENDIF

    NEXT

    IF lImp
    
		IF SUBSTR(CONSO->CONTA,1,1) > "3"        
	
			IF ALLTRIM(CONSO->CONTA) $ "502001001001001#502001001001002#502001001001003"
	   			lImp := .T.
	        ELSE
	        	lImp := .F.
	        ENDIF
	        
    	ENDIF
    
	ENDIF

	IF lImp
		oSection1:PrintLine()                     
	ENDIF


	CONSO->(DBSKIP())

END

CONSO->(DBCLOSEAREA())                                                 
ELIM->(DBCLOSEAREA())
oSection1:Finish()                    
RETURN

//-----------------------------------------------------------------------
/*{Protheus.doc} CRIATRB1
@Tabela para armazenar os valores a debito e credito de elimina็ใo
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------            
STATIC FUNCTION CRIATRB1
Local aCampos	:={}
Local cArqTmp 	:= ""
Local nX 		:= 0       
Local cOrdem	:= "EMPCONS+CONTA+ITEMCTA"

IF SELECT("ELIM") > 0
	ELIM->(DBCLOSEAREA())
ENDIF

aAdd(aCampos,{"EMPCONS"	 , "C" , 09,0})  
aAdd(aCampos,{"CONTA"    , "C" , 20,0})  
aAdd(aCampos,{"ITEMCTA"  , "C" , 14,0})  
aAdd(aCampos,{"VALORDB"  , "N" , 20,2})  
aAdd(aCampos,{"VALORCR"	 , "N" , 20,2})  
cArqTmp := CriaTrab(aCampos)
dbUseArea( .T.,, cArqTmp, "ELIM", .F., .F. )
IndRegua("ELIM", cArqTmp, cOrdem ,,,,)
ELIM->(DBSETORDER(1))      

RETURN(.T.)
//-----------------------------------------------------------------------
/*{Protheus.doc} CRIATRB2
@Tabela para armazenar os movimentos e saldos do plano de contas consolidado
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------            
STATIC FUNCTION CRIATRB2 
Local aCampos	:={}
Local cArqTmp 	:= ""
Local nX 		:= 0       
Local cOrdem	:= "CONTA+ITEMCTA"

IF SELECT("CONSO") > 0
	CONSO->(DBCLOSEAREA())
ENDIF

aAdd(aCampos,{"CONTA"	 , "C" , 20,0})  
aAdd(aCampos,{"ORDEM"	 , "C" , 04,0})  
aAdd(aCampos,{"TIPO"     , "C" , 01,0})  
aAdd(aCampos,{"CONTASUP" , "C" , 20,0})  
aAdd(aCampos,{"ITEMCTA"  , "C" , 14,0})  
aAdd(aCampos,{"CONTAN1"	 , "C" , 01,0})  
aAdd(aCampos,{"CONTAN2"	 , "C" , 03,0})  
aAdd(aCampos,{"CONTAN3"	 , "C" , 06,0})  
aAdd(aCampos,{"CONTAN4"	 , "C" , 09,0})  
aAdd(aCampos,{"CONTAN5"	 , "C" , 12,0})  
aAdd(aCampos,{"CONTAN6"	 , "C" , 15,0})  
aAdd(aCampos,{"DESCRICAO", "C" , 40,0})  


FOR nX := 1 TO nColunas
	aAdd(aCampos,{"BAL"+STRZERO(nX,2)    , "N" , 20,2})
	aAdd(aCampos,{"ELIDB"+STRZERO(nX,2)  , "N" , 20,2})	
	aAdd(aCampos,{"ELICR"+STRZERO(nX,2)  , "N" , 20,2})	
	aAdd(aCampos,{"CONSO"+STRZERO(nX,2)  , "N" , 20,2})	
NEXT nX                                          
  
aAdd(aCampos,{"BAL99"    , "N" , 20,2})
aAdd(aCampos,{"ELIDB99"  , "N" , 20,2})	
aAdd(aCampos,{"ELICR99"  , "N" , 20,2})	
aAdd(aCampos,{"CONSO99"  , "N" , 20,2})	
cArqTmp := CriaTrab(aCampos)
dbUseArea( .T.,, cArqTmp, "CONSO", .F., .F. )
IndRegua("CONSO", cArqTmp, cOrdem ,,,,)
CONSO->(DBSETORDER(1))      

RETURN(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณATUTRB1  บAutor  ณJos้ Mauricio        บ Data ณ  16/11/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza tabela de elimina็๕es TRB1                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 			                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION ATUTRB1(pData, pEmpresa,pEmp)
Local cSQL      := ""
Local lRet      := .T.                  
Local cTabCT2	:= ""

cTabCT2 := "CT2"+SUBSTR(pEmpresa,1,2)+"0"


cSQL:= "SELECT " + CRLF 
cSQL+= " 	CT2_VALOR   	AS DEBITO, " +CRLF 
cSQL+= " 	0				AS CREDITO, " +CRLF 
cSQL+= " 	CT2_DEBITO, " +CRLF 
cSQL+= " 	CT2_ITEMD, " +CRLF 
cSQL+= " 	' ' AS CT2_CREDIT, " +CRLF 
cSQL+= " 	' ' AS CT2_ITEMC, " +CRLF  
cSQL+= " 	CT2_DATA
cSQL+= " FROM "+cTabCT2 
cSQL+= " WHERE " +CRLF 
cSQL+= " 	D_E_L_E_T_ 		= ' ' " +CRLF 
cSQL+= " 	AND CT2_FILIAL	= '"+SUBSTR(pEmpresa,3,3)+"' " +CRLF 
cSQL+= " 	AND CT2_XEMP	= '"+pEmp+"' " +CRLF 
cSQL+= " 	AND CT2_DATA	<= '"+DTOS(pData)+"' " +CRLF 
cSQL+= " 	AND CT2_MOEDLC	= '01' " +CRLF 
cSQL+= " 	AND CT2_TPSALD	= 'E' " +CRLF 
cSQL+= " 	AND CT2_DC		IN(1,3) " +CRLF 
cSQL+= " UNION ALL " +CRLF 
cSQL+= " SELECT " +CRLF 
cSQL+= " 	0			 	AS DEBITO, " +CRLF 
cSQL+= " 	CT2_VALOR   	AS CREDITO, " +CRLF 
cSQL+= " 	' ' AS CT2_DEBITO, " +CRLF 
cSQL+= " 	' ' AS CT2_ITEMD, " +CRLF 
cSQL+= " 	CT2_CREDIT, " +CRLF 
cSQL+= " 	CT2_ITEMC, " +CRLF 
cSQL+= " 	CT2_DATA
cSQL+= " FROM "+cTabCT2
cSQL+= " WHERE " +CRLF 
cSQL+= " 	D_E_L_E_T_ 		= '' " +CRLF 
cSQL+= " 	AND CT2_FILIAL	= '"+SUBSTR(pEmpresa,3,3)+"' " +CRLF 
cSQL+= " 	AND CT2_XEMP	= '"+pEmp+"' " +CRLF 
cSQL+= " 	AND CT2_DATA	<= '"+DTOS(pData)+"' " +CRLF 
cSQL+= " 	AND CT2_MOEDLC	= '01' " +CRLF 
cSQL+= " 	AND CT2_TPSALD	= 'E' " +CRLF 
cSQL+= " 	AND CT2_DC		IN(2,3) " +CRLF 
cSQL	:= ChangeQuery(cSQL)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"XCT2",.T.,.T.)                           
                                                                                                                                      
lAtu := .F.

WHILE XCT2->(!EOF()) 

	IF !EMPTY(XCT2->CT2_DEBITO) .AND. XCT2->DEBITO <> 0
		lAtu := .F.                              
		
		IF ALLTRIM(XCT2->CT2_DEBITO) == "502001001001001" // PL Minoritarios - acumulado
			lAtu := .T.
		ENDIF
		
		IF !lAtu
		  	IF SUBSTR(XCT2->CT2_DEBITO,1,1) < "3"    // Ativo e Passivo - acumulado
				lAtu := .T.
		    ENDIF
		ENDIF	  	 
	  	
	  	IF !lAtu
	  		IF SUBSTR(XCT2->CT2_DEBITO,1,1) >="3"
				IF MV_PAR05 == "2"
					IF XCT2->CT2_DATA >= DTOS(FirstDay(pData)) 
						lAtu := .T.
					ENDIF
				ELSE
					lAtu := .T.
				ENDIF
			ENDIF
		ENDIF
	 
		IF	lAtu
			IF ELIM->(DBSEEK(pEmp+XCT2->CT2_DEBITO+XCT2->CT2_ITEMD))
				RECLOCK("ELIM",.F.)
				ELIM->VALORDB := ELIM->VALORDB + XCT2->DEBITO
				ELIM->(MsUnlock())               '
			ELSE
				RECLOCK("ELIM",.T.)
				ELIM->EMPCONS 	:= pEmp
				ELIM->CONTA 	:= XCT2->CT2_DEBITO
				ELIM->ITEMCTA   := XCT2->CT2_ITEMD
				ELIM->VALORDB	:= XCT2->DEBITO
				ELIM->(MsUnlock())
			ENDIF
		ENDIF
	ENDIF                                             
	         
	IF !EMPTY(XCT2->CT2_CREDIT)	.AND. XCT2->CREDITO <> 0	
		lAtu := .F.                              
		
		IF ALLTRIM(XCT2->CT2_CREDIT) == "502001001001001" // PL Minoritarios - acumulado
			lAtu := .T.
		ENDIF
		
		IF !lAtu
		  	IF SUBSTR(XCT2->CT2_CREDIT,1,1) < "3"    // Ativo e Passivo - acumulado
				lAtu := .T.
		    ENDIF
		ENDIF	  	 
	  	
	  	IF !lAtu
	  		IF SUBSTR(XCT2->CT2_CREDIT,1,1) >="3"
				IF MV_PAR05 == "2"
					IF XCT2->CT2_DATA >= DTOS(FirstDay(pData)) 
						lAtu := .T.
					ENDIF
				ELSE
					lAtu := .T.
				ENDIF
			ENDIF
		ENDIF	

		IF	lAtu	
			IF ELIM->(DBSEEK(pEmp+XCT2->CT2_CREDIT+XCT2->CT2_ITEMC))
				RECLOCK("ELIM",.F.)
				ELIM->VALORCR := ELIM->VALORCR + XCT2->CREDITO
				ELIM->(MsUnlock())
			ELSE
				RECLOCK("ELIM",.T.)
				ELIM->EMPCONS 	:= pEmp
				ELIM->CONTA 	:= XCT2->CT2_CREDIT
				ELIM->ITEMCTA   := XCT2->CT2_ITEMC			
				ELIM->VALORCR	:= XCT2->CREDITO
				ELIM->(MsUnlock())
			ENDIF
		ENDIF
	ENDIF
    XCT2->(DBSKIP())
END
XCT2->(DBCLOSEAREA())

RETURN(.T.)

//-----------------------------------------------------------------------
/*{Protheus.doc} SaldoCons
@Apura o saldo de uma conta em uma data para um grupo de empresa e empresa
@param		conta, data , grupo de empresas, empresa, tipo de saldo, op็ใo de sele็ใo, item contแbil
@return		valor calculado
@author 	Zema
@since 		01/12/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------                         
User Function SaldoCons(pConta, pData, pGrupo, pEmpresa,pSaldo, nOP, pItemCta,pTipoRes)
Local cQuery := ""
Local cTab	 := ""
Local cConta := pConta
Local aSaveAnt	:= GetArea()                                   
Local nDebito	:= 0
Local nCredito	:= 0   
Local cTipoRes	:= pTipoRes
IF nOP == 1  
  	IF EMPTY(pItemCta)
		cTab	:= "CQ0"+pGrupo+"0"
	ELSE
		cTab	:= "CQ4"+pGrupo+"0"
	ENDIF
ENDIF

IF nOP == 2
	cTab	:= "CT2"+pGrupo+"0"
ENDIF
                    
nRegCT1 := CT1->(RECNO())

IF nOP == 1           
  	IF EMPTY(pItemCta)
		cTab	:= "CQ0"+pGrupo+"0"

		cQuery		+= "SELECT SUM(CQ0_DEBITO) AS DEBITO, SUM(CQ0_CREDIT) AS CREDITO FROM "+cTab
		cQuery		+= " WHERE " +CRLF 
		cQuery		+= " 	CQ0_FILIAL  = '"+SUBSTR(pEmpresa,3,3)+"' "
		cQuery		+= " 	AND D_E_L_E_T_ 		= ' ' " +CRLF 
	
		IF cTipoRes == "2"  // Resultado do m๊s
			cQuery		+= " 	AND CQ0_DATA >= '"+DTOS(FirstDay(pData))+"'  AND CQ0_DATA  <= '"+DTOS(pData)+"' "
		ELSE
			cQuery		+= " 	AND CQ0_DATA	<= '"+DTOS(pData)+"' "				
		ENDIF

		cQuery		+= " 	AND CQ0_CONTA	= '"+cConta+"' "
		cQuery		+= " 	AND CQ0_TPSALD	= '"+pSaldo+"' "
		cQuery		+= " 	AND CQ0_MOEDA	= '01' "
	
    ELSE

		cTab	:= "CQ4"+pGrupo+"0"

		cQuery		+= "SELECT SUM(CQ4_DEBITO) AS DEBITO, SUM(CQ4_CREDIT) AS CREDITO FROM "+cTab
		cQuery		+= " WHERE " +CRLF 
		cQuery		+= " 	CQ4_FILIAL  = '"+SUBSTR(pEmpresa,3,3)+"' "
		cQuery		+= " 	AND D_E_L_E_T_ 		= ' ' " +CRLF 

		IF cTipoRes == "2"  // Resultado do m๊s
			cQuery		+= " 	AND CQ4_DATA >= '"+DTOS(FirstDay(pData))+"'  AND CQ4_DATA  <= '"+DTOS(pData)+"' "
		ELSE
			cQuery		+= " 	AND CQ4_DATA	<= '"+DTOS(pData)+"' "				
		ENDIF

		cQuery		+= " 	AND CQ4_CONTA	= '"+cConta+"' "
 		cQuery		+= " 	AND CQ4_ITEM = '"+ALLTRIM(pItemCta)+"' "
		cQuery		+= " 	AND CQ4_TPSALD	= '"+pSaldo+"' "
		cQuery		+= " 	AND CQ4_MOEDA	= '01' "
	
  
    ENDIF   

	If Select("XSALDO") > 0
		dbSelectArea("XSALDO")
		dbCloseArea()
	EndIf
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"XSALDO",.T.,.F.)
	 
	Saldo := 0
	
	CT1->(DBSEEK(XFILIAL("CT1")+cConta))
		
	IF SUBSTR(CT1->CT1_CONTA,1,1) < "3"

		IF CT1->CT1_NORMAL == "1"
			Saldo	:= XSALDO->DEBITO - XSALDO->CREDITO
		ELSE
			Saldo	:= (XSALDO->CREDITO - XSALDO->DEBITO) * (-1)
		ENDIF
		
    ELSE 

		IF CT1->CT1_NORMAL == "1"
			Saldo	:= (XSALDO->DEBITO - XSALDO->CREDITO) * (-1)
		ELSE
			Saldo	:= (XSALDO->CREDITO - XSALDO->DEBITO)
		ENDIF
    
    ENDIF
	XSALDO->(DBCLOSEAREA())

ENDIF

IF nOP == 2     

	IF EMPTY(pItemcta)

		ELIM->(DBGOTOP())
		WHILE ELIM->(!EOF())
			IF ALLTRIM(ELIM->EMPCONS) == ALLTRIM(pEmpresa) .AND. ALLTRIM(ELIM->CONTA) == ALLTRIM(cConta)
			   nDebito += ELIM->VALORDB
		   	   nCredito+= ELIM->VALORCR
	   	 	ENDIF
   		 	ELIM->(DBSKIP())
		END
	ELSE
		ELIM->(DBGOTOP())
		WHILE ELIM->(!EOF())
			IF ALLTRIM(ELIM->EMPCONS) == ALLTRIM(pEmpresa) .AND. ALLTRIM(ELIM->CONTA) == ALLTRIM(cConta) .AND. ALLTRIM(ELIM->ITEMCTA) == ALLTRIM(pItemCta)
			   nDebito += ELIM->VALORDB
		   	   nCredito+= ELIM->VALORCR
	   	 	ENDIF
   		 	ELIM->(DBSKIP())
		END	
	ENDIF
	
	If nDebito+nCredito <> 0
	   	Saldo := {nDebito,nCredito}	
	ELSE
		Saldo := {0,0}
	ENDIF	

ENDIF

RestArea(aSaveAnt)     

CT1->(DBGOTO(nRegCT1))

Return(Saldo)

//-----------------------------------------------------------------------
/*{Protheus.doc} Empcons
@Retorna o codigo ou o nome da empresa
@param		pTipo - 1 = C๓digo, 2 = Nome
@return		C๓digo ou Nome
@author 	Zema
@since 		01/12/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------                         
STATIC FUNCTION EMPCONS(pTipo)                           
Local cRet  := ""    
Local nX	:= 0                                                    
Local nRegSM0 := SM0->(RECNO())

IF pTipo == 1
	nConta++
ENDIF

XSZ6->(DBGOTOP())   
WHILE XSZ6->(!EOF())
    
	nX++   
	IF nX == nConta       
	
		IF pTipo == 1
			cRet := ALLTRIM(XSZ6->Z6_EMPCONS)
		ENDIF
		
		IF pTipo == 2
			cRet := POSICIONE("SM0",1,XSZ6->Z6_EMPCONS,"M0_FILIAL")
			SM0->(DBGOTO(nRegSM0))
		ENDIF
		
 		EXIT
    ENDIF
	XSZ6->(DBSKIP())
END	
RETURN(cRet)

STATIC FUNCTION VALOR(pPar)
Local nVal   := 0        
Local cCampo := ""

IF pPar == "BAL"
   nConta++
ENDIF
cCampo := pPar+STRZERO(nConta,2) 
nVal := CONSO->&(cCampo)
RETURN(nVal)
