#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'                                                    
//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTBA10
@Processa os lançamentos de eliminação
@param		aEmpOri
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------
User Function ASCTBA10(_aParams)
Local lContinua		:= .T.
Local nX			:= 0
Private aEmpOri		:= _aParams[1]
Private dDataIni	:= _aParams[2]
Private dDataFim	:= _aParams[3]
Private cCodigo		:= aEmpOri[1][10]
Private aEstruNiv	:= {}
Private lSub 		:= .T.
PRIVATE nNiv 		:= 1                      
PRIVATE aTiposEli   := {}
PRIVATE cTipoSld	:= aEmpOri[1][6]           
                     
dDataBase   := dDataFim  // Atualiza database

ProcLogIni( {},"ASCTBA10")
ProcLogAtu("MENSAGEM",OemToAnsi("Inicio das eliminações."),"","ASCTBA10") 
ProcLogAtu("MENSAGEM",OemToAnsi("Monta níveis da estrutura."),"","ASCTBA10") 

aSort(aEmpOri,,,{|x,y| x[11] < y[11] })
FOR nX := 1 TO LEN(aEmpOri)
	lSub := .T.
	ATUNIV(1, aEmpOri[nX][11],  aEmpOri[nX][7],  aEmpOri[nX][8], aEmpOri[nX][9]+aEmpOri[nX][8], aEmpOri[nX][11], '01'+aEmpOri[nX][1], aEmpOri[nX][11], '01'+aEmpOri[nX][1])
NEXT	   
aSort(aEstruNiv,,,{|x,y| x[1] < y[1] })

ELIPL()

RETURN
//-----------------------------------------------------------------------
/*{Protheus.doc} ATUNIV
@Monta matriz de empresas para eliminar
@param		
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------
STATIC FUNCTION ATUNIV(pNivelEstru, pConsEmp, pPercCons, pDoraEmp, pDoraComp, pEmpPrim, pEmpPar, pConsOri, pParEst)                         

LOCAL nReg 		:= 0 
LOCAL cChaveSZ6 := ""
LOCAL cQ		:= ""

// Verifico se a empresa que estou consolidando também consolida, portanto possui estrutura, se tiver carrega os sub-niveis
cQ := "SELECT Z6_CODIGO, Z6_EMP FROM "+RetSqlName("SZ6")
cQ += " WHERE Z6_EMP = '"+pConsEmp+"' AND Z6_CODIGO = '"+cCodigo+"' AND D_E_L_E_T_ = ' '"
TcQuery ChangeQuery(cQ) ALIAS "XSZ6N" NEW

IF XSZ6N->(!EOF())
	cChaveSZ6 := XSZ6N->Z6_CODIGO+XSZ6N->Z6_EMP
ELSE
	cChaveSZ6 := ""
ENDIF

XSZ6N->(DBCLOSEAREA())

IF !EMPTY(cChaveSZ6)  // Econtrou estrutura para empresa consolidadora
	SZ6->(DBSETORDER(1))
	IF SZ6->(DBSEEK(XFILIAL("SZ6")+cChaveSZ6)) 
		IF lSub  // Identifica que está processando sub-niveis
		    nNiv++
		    lSub := .F.
			pEmpPar := '01'+SUBSTR(SZ6->Z6_EMP,3,7)  // sempre no primeiro subnivel
		ENDIF    
		WHILE SZ6->(!EOF()) .AND. SZ6->Z6_CODIGO+SZ6->Z6_EMP == cChaveSZ6
			nReg := SZ6->(RECNO())   
			// Chamada recursiva da atualização da estrutura de niveis
  		  	ATUNIV(nNiv, SZ6->Z6_EMPCONS, pPercCons, SUBSTR(SZ6->Z6_EMP,3,7), SZ6->Z6_EMP, pEmpPrim, pEmpPar, pConsOri, pParEst)
  		  	SZ6->(DBGOTO(nReg))
  		  	SZ6->(DBSKIP())
	  	END
	ENDIF
ELSE      
	AADD(aEstruNiv,{nNiv,;              //1 - Nivel da estrutura 
		 			pConsEmp  ,;      	//2 - Empresa consolidante  - grupo/empresa/unidade/filial 
		 			pPercCons ,;        //3 - Percentual de consolidação 
					pDoraEmp  ,;        //4 - Empresa consolidadora - empresa/unidade/filial 
					pDoraComp ,;   		//5 - Codigo completo da consolidadora - grupo/empresa/unidade/filial
					pEmpPrim  ,;        //6 - Empresa principal da estrutura 
					pEmpPar   ,;        //7 - Empresa participante da estrutura 
					pConsOri,;          //8
					pParEst})           //9
ENDIF	

RETURN
//-----------------------------------------------------------------------
/*{Protheus.doc} ELIPL
@Eliminação do PL
@param		
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------
Static Function ELIPL
Local cGRPL		:= "203"
Local aContaPL	:= {}
Local lContinua := .T.   
Local nX		:= 0
Local nY		:= 0         
Local cGrpAtu	:= ""
Local cEmpAtu	:= ""
Local nAcoes   	:= 0
Local nPerPar	:= 0
Local nPL		:= 0 
Local nPer		:= 0
Local nSaldoC	:= 0      
Local nTotPar	:= 0
Local aEliPL	:= {}
Private cLote   := "ELIMIN"
Private cSbLote	:= "001"
Private cDoc	:= "000000"
Private cLinha	:= "000"
Private cMepP	:= ""
Private cMepN	:= ""
Private VALOR	:= 0
Private VALOR1	:= 0
Private VALOR2	:= 0   


ProcLogAtu("MENSAGEM",OemToAnsi("Inicio - Eliminacoes Investimento"),"","ELIPL") 

aContaPL    := {}
                      
CT1->(DBSETORDER(1))
CT1->(DBSEEK(XFILIAL("CT1")+cGRPL))

ProcLogAtu("MENSAGEM",OemToAnsi("Seleciona contas de patrimonio"),"","ELIPL") 

WHILE CT1->(!EOF()) .AND. SUBSTR(CT1->CT1_CONTA,1,LEN(ALLTRIM(cGRPL))) == ALLTRIM(cGRPL)
	IF CT1->CT1_CLASSE == "2"
		AADD(aContaPL,CT1->CT1_CONTA)
	ENDIF
	CT1->(DBSKIP())
END	                                                                               
                              
FOR nX := 1 TO LEN(aEstruNiv)  // IDAS
	cEmpAtu := aEstruNiv[nX][7] 
    nTotPar := 0        
    aEliPL	:= {}                                                                              

	ProcLogAtu("MENSAGEM","IDA: "+cEmpAtu,"","ELIPL")     
    
    
	// Busco movimento nas demais empresas (B) para eliminar com a empresa (A)
	FOR nY := 1 TO LEN(aEstruNiv)  // DORAS                       

			
		IF aEstruNiv[nY][7] <> cEmpAtu // Somente elimino empresas do primeiro nivel, as consolidadora, elimino a consolidadora e não as empresas dela
	            
			cGrpAtu := aEstruNiv[nY][7]

	        // Localiza a conta de investimento da empresa
			cQ := "SELECT Z0_CONTA, Z0_ITEMCTA, Z0_QTACOES, Z0_CTMEPRN, Z0_CTMEPRP FROM "+RetSqlName("SZ0")
			cQ += " WHERE "
			cQ += " Z0_EMPRESA = '"+cEmpAtu+"' AND Z0_DTREVIS = '"+DTOS(FirstDay(dDataBase))+"'"            
			cQ += " AND D_E_L_E_T_ = ' ' "
			TcQuery ChangeQuery(cQ) ALIAS "QrySZ0" NEW                      
				
			nAcoes  := QrySZ0->Z0_QTACOES
			cMepP	:= QrySZ0->Z0_CTMEPRP
			cMepN	:= QrySZ0->Z0_CTMEPRN
			
			QrySZ0->(DBCLOSEAREA())
			
			// VERIFICO SE POSSUI PARTICIPACAO
			cQ := "SELECT Z2_EMP, Z2_EMPPAR, Z2_QUANT"
			cQ += " FROM "+RetSqlName("SZ2")+" SZ2 "   
			cQ += " WHERE Z2_FILIAL = '"+XFILIAL("SZ2")+"' AND Z2_DTBASE = '"+DTOS(FirstDay(dDataBase))+"'"
//			cQ += " AND Z2_EMP = '"+cEmpAtu+"'"
//			cQ += " AND Z2_EMPPAR = '"+cGrpAtu+"'"
			cQ += " AND Z2_EMP = '"+cGrpAtu+"'"
			cQ += " AND Z2_EMPPAR = '"+cEmpAtu+"'"
			cQ += " AND D_E_L_E_T_ = ' '"
			TcQuery ChangeQuery(cQ) ALIAS "QrySZ2" NEW
		
			IF QrySZ2->(!EOF())
				nPerPar := QrySZ2->Z2_QUANT / nAcoes  
			ELSE
				nPerPar := 0
	   		ENDIF

			nTotPar += nPerPar                
			                               
			QrySZ2->(DBCLOSEAREA())
			        
			IF nPerPar <> 0             

	    		ProcLogAtu("MENSAGEM",OemToAnsi("PL - IDA: "+cEmpAtu+"/ DORA: "+aEstruNiv[nY][7]+" - % : "+STR(nPerPar)),"","ELIPL")   

				// Eliminação do Investimento
				cDoc	:= Soma1(cDoc)
				cLinha	:= "000"
				
				FOR nPL := 1 TO LEN(aContaPL)
		
					ProcLogAtu("MENSAGEM",OemToAnsi("Conta PL: "+aContaPL[nPL]),"","ELIPL")   

					// Busco o saldo da conta na empresa posicionada
					nSaldoC := U_MvCtCons(aContaPL[nPL], FirstDay(dDataBase), dDataBase, '01', '1', cEmpAtu)

					ProcLogAtu("MENSAGEM",OemToAnsi("Saldo: "+STR(nSaldoC,17,2)),"","ELIPL")
				
					VALOR     := ROUND(ABS(nSaldoC) * nPerPar,2)  // Investimento

					ProcLogAtu("MENSAGEM",OemToAnsi("Elimina: "+STR(VALOR,17,2)),"","ELIPL")

					nPos := 0
					IF (nPos := ASCAN(aEliPL,{|x| x[1] == aContaPL[nPL]})) == 0
					    AADD(aEliPL,{aContaPL[nPL],VALOR})
					ELSE 
						aEliPL[nPos][2] += VALOR
					ENDIF
					                                                        
					IF VALOR > 0    
						GrvCt2Eli(aContaPL[nPL],nSaldoC,VALOR,cEmpAtu,nPerPar) // Elimina a participação no PL
					ENDIF
					
				NEXT  nPL
				
			ENDIF	
				
		ENDIF		
	NEXT nY			
				               
    IF nTotPar > 0 // Teve participação
        
        nPerPar := 1 - nTotPar

		// ELimina não controladores do PL e gera movimento de não controladores no PL
        
		FOR nPL := 1 TO LEN(aContaPL)
			IF (nPos := ASCAN(aEliPL,{|x| x[1] == aContaPL[nPL]})) > 0
		
				ProcLogAtu("MENSAGEM",OemToAnsi("MINORITARIOS - PL: "+aContaPL[nPL]),"","ELIPL")   

				// Busco o saldo da conta na empresa posicionada
				nSaldoC := U_MvCtCons(aContaPL[nPL], FirstDay(dDataBase), dDataBase, '01', '1', cEmpAtu)

				ProcLogAtu("MENSAGEM",OemToAnsi("Saldo: "+STR(nSaldoC,17,2)),"","ELIPL")
				
				VALOR     := ABS(ABS(nSaldoC) - aEliPL[nPos][2]) // Não controladores

				ProcLogAtu("MENSAGEM",OemToAnsi("Valor: "+STR(VALOR,17,2)),"","ELIPL")
					                                                        
				IF VALOR > 0    
					GrvCt2Min(aContaPL[nPL],nSaldoC,VALOR,cEmpAtu,nPerPar) // Elimina não controladores no PL
				ENDIF
			ENDIF
					
		NEXT nPL
        
        IF nPerPar <> 0

			// Resultado
			nSaldoC := U_APUR(cEmpAtu,"3","1","01",dDataBase)

   			VALOR     := ABS(nSaldoC)                  	// Saldo da conta 
			VALOR     := ROUND(VALOR * nPerPar,2)		// Saldo da conta * percentual de investimento - contabilizar na conta do Investimento e MEP
				
			IF VALOR > 0             
				IF nSaldoC < 0 // Resultado Positivo
						
					cLinha := Soma1(cLinha)                         

					// CREDITO Minoritários
				    RECLOCK("CT2",.T.)
					CT2->CT2_FILIAL := XFILIAL("CT2")
				    CT2->CT2_DATA	:= dDataBase
				    CT2->CT2_LOTE	:= cLote            '
				    CT2->CT2_SBLOTE	:= cSbLote
			        CT2->CT2_DOC	:= cDoc
			        CT2->CT2_LINHA	:= cLinha
					CT2->CT2_MOEDLC	:= "01"
					CT2->CT2_DC		:= "2"
					CT2->CT2_CREDIT	:= "502001001001002"
					CT2->CT2_VALOR	:= VALOR
					CT2->CT2_HIST	:= "CLASS/CONTROLADORES: % "+ALLTRIM(STR(nPerPar*100))
					CT2->CT2_EMPORI	:= cEmpAnt
					CT2->CT2_FILORI	:= cFilAnt
					CT2->CT2_INTERC	:= "2"
					CT2->CT2_TPSALD := "1"
					CT2->CT2_MANUAL	:= "1"
					CT2->CT2_ROTINA	:= "ASCTBA10"
					CT2->CT2_AGLUT	:= "2"
					CT2->CT2_SEQHIS	:= "001"
					CT2->CT2_SEQLAN	:= "001"
					CT2->CT2_XEMP	:= cEmpAtu			
					MsUnlock()               
						
					cLinha := Soma1(cLinha)                         
			 		// CREDITO Minoritários
			        RECLOCK("CT2",.T.)
			        CT2->CT2_FILIAL := XFILIAL("CT2")
			        CT2->CT2_DATA	:= dDataBase
			        CT2->CT2_LOTE	:= cLote
			        CT2->CT2_SBLOTE	:= cSbLote
			        CT2->CT2_DOC	:= cDoc
			        CT2->CT2_LINHA	:= cLinha
					CT2->CT2_MOEDLC	:= "01"
					CT2->CT2_DC		:= "2"
					CT2->CT2_CREDIT	:= "502001001001002"
					CT2->CT2_VALOR	:= VALOR
					CT2->CT2_HIST	:= "CLASS/CONTROLADORES: % "+ALLTRIM(STR(nPerPar*100))
					CT2->CT2_EMPORI	:= cEmpAnt
					CT2->CT2_FILORI	:= cFilAnt
					CT2->CT2_INTERC	:= "2"
					CT2->CT2_TPSALD := "E"
					CT2->CT2_MANUAL	:= "1"
					CT2->CT2_ROTINA	:= "ASCTBA10"
					CT2->CT2_AGLUT	:= "2"
					CT2->CT2_SEQHIS	:= "001"
					CT2->CT2_SEQLAN	:= "001"
					CT2->CT2_XEMP	:= cEmpAtu			
					MsUnlock()               							
					
		     	ELSE  // // Resultado Positivo - Saldo Devedor
					// - DIFERENÇA MINORITÁRIOS	
					cLinha := Soma1(cLinha)                         
			 		// DEBITO Minoritários
			        RECLOCK("CT2",.T.)
			        CT2->CT2_FILIAL := XFILIAL("CT2")
			        CT2->CT2_DATA	:= dDataBase
			        CT2->CT2_LOTE	:= cLote
			        CT2->CT2_SBLOTE	:= cSbLote
			        CT2->CT2_DOC	:= cDoc
			        CT2->CT2_LINHA	:= cLinha
					CT2->CT2_MOEDLC	:= "01"
					CT2->CT2_DC		:= "1"
					CT2->CT2_DEBITO	:= "502001001001002"
					CT2->CT2_VALOR	:= VALOR
					CT2->CT2_HIST	:= "CLASS/CONTROLADORES: % "+ALLTRIM(STR(nPerPar*100))
					CT2->CT2_EMPORI	:= cEmpAnt
					CT2->CT2_FILORI	:= cFilAnt
					CT2->CT2_INTERC	:= "2"
					CT2->CT2_TPSALD := "1"
					CT2->CT2_MANUAL	:= "1"
					CT2->CT2_ROTINA	:= "ASCTBA10"
					CT2->CT2_AGLUT	:= "2"
					CT2->CT2_SEQHIS	:= "001"
					CT2->CT2_SEQLAN	:= "001"
					CT2->CT2_XEMP	:= cEmpAtu			
					MsUnlock()               
					
					cLinha := Soma1(cLinha)                         
			 		// CREDITO Minoritários
			        RECLOCK("CT2",.T.)
			        CT2->CT2_FILIAL := XFILIAL("CT2")
			        CT2->CT2_DATA	:= dDataBase
			        CT2->CT2_LOTE	:= cLote
			        CT2->CT2_SBLOTE	:= cSbLote
			        CT2->CT2_DOC	:= cDoc
			        CT2->CT2_LINHA	:= cLinha
					CT2->CT2_MOEDLC	:= "01"
					CT2->CT2_DC		:= "1"
					CT2->CT2_DEBITO	:= "502001001001002"
					CT2->CT2_VALOR	:= VALOR
					CT2->CT2_HIST	:= "CLASS/CONTROLADORES: % "+ALLTRIM(STR(nPerPar*100))
					CT2->CT2_EMPORI	:= cEmpAnt
					CT2->CT2_FILORI	:= cFilAnt
					CT2->CT2_INTERC	:= "2"
					CT2->CT2_TPSALD := "E"
					CT2->CT2_MANUAL	:= "1"
					CT2->CT2_ROTINA	:= "ASCTBA10"
					CT2->CT2_AGLUT	:= "2"
					CT2->CT2_SEQHIS	:= "001"
					CT2->CT2_SEQLAN	:= "001"
					CT2->CT2_XEMP	:= cEmpAtu			
					MsUnlock()               							
		     	ENDIF                                                    
            ENDIF

        ENDIF

    ENDIF

NEXT nX
		        
ProcLogAtu("MENSAGEM",OemToAnsi("Inicio do reprocessamento contabil (CTBA190)"),"","ELIPL")
CTBA190(.T.,FirstDay(dDataBase)-1,LastDay(dDataBase),cEmpAnt,cFilAnt,"*",.T.,"01")                         
ProcLogAtu("MENSAGEM",OemToAnsi("Fim do reprocessamento contabil (CTBA190)"),"","ELIPL")
ProcLogAtu("MENSAGEM",OemToAnsi("Fim - Eliminacoes PL"),"","ELIPL") 
	
RETURN(lContinua)
//-----------------------------------------------------------------------
/*{Protheus.doc} MovLote
@Apura o movimento da conta
@param		conta, data inicial, data final, moeda, tipo de saldo, lote
@return		valor calculado
@author 	Zema
@since 		01/12/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------                                      
User Function MvCtCons(pConta, pDtIni, pDtFim, pMoeda, pSaldo, pEmp)
Local cQuery := ""
Local nSaldo := 0
Local cTab1	 := GetNextAlias()
Local aSaveAnt	:= GetArea()

cTab	:= "CQ0"+SUBSTR(pEmp,1,2)+"0"
cQuery		+= "SELECT SUM(CQ0_DEBITO) AS VALDEB, SUM(CQ0_CREDIT) AS VALCRED FROM "+cTab
cQuery		+= " WHERE " +CRLF 
cQuery		+= " 	CQ0_FILIAL  = '"+SUBSTR(pEmp,3,3)+"' "
cQuery		+= " 	AND D_E_L_E_T_ 		= ' ' " +CRLF 
cQuery		+= " 	AND CQ0_DATA >= '"+DTOS(pDtIni)+"'  AND CQ0_DATA  <= '"+DTOS(pDtFim)+"' "
cQuery		+= " 	AND CQ0_CONTA	= '"+pConta+"' "
cQuery		+= " 	AND CQ0_TPSALD	= '"+pSaldo+"' "
cQuery		+= " 	AND CQ0_MOEDA	= '01' "

/*

cQuery		+= "SELECT SUM(DEBITO) AS VALDEB, SUM(CREDITO) AS VALCRED FROM 
cQuery		+= "( SELECT " + CRLF 
cQuery		+= " 	SUM(CT2_VALOR) 	AS DEBITO, " +CRLF 
cQuery		+= " 	0				AS CREDITO " +CRLF 
cQuery		+= " FROM " + RetSqlName("CT2") +CRLF 
cQuery		+= " WHERE " +CRLF 
cQuery		+= " 	D_E_L_E_T_ 		= '' " +CRLF 
cQuery		+= " 	AND CT2_FILIAL	= '"+xFilial("CT2")+"' " +CRLF 
cQuery		+= " 	AND CT2_DATA	>= '"+DTOS(pDtIni)+"' " +CRLF 
cQuery		+= " 	AND CT2_DATA	<= '"+DTOS(pDtFim)+"' " +CRLF 
cQuery		+= " 	AND CT2_MOEDLC	= '"+pMoeda+"' " +CRLF 
cQuery		+= " 	AND CT2_TPSALD	= '"+pSaldo+"' " +CRLF 
cQuery		+= " 	AND CT2_DC		IN(1,3) " +CRLF 
cQuery		+= " 	AND CT2_DEBITO	= '"+pConta+"' " +CRLF       
cQuery		+= "    AND CT2_XEMP 	= '"+pEmp+"' " +CRLF       
cQuery		+= " UNION ALL " +CRLF 
cQuery		+= " SELECT " +CRLF 
cQuery		+= " 	0			 	AS DEBITO, " +CRLF 
cQuery		+= " 	SUM(CT2_VALOR)	AS CREDITO " +CRLF 
cQuery		+= " FROM " + RetSqlName("CT2") +CRLF 
cQuery		+= " WHERE " +CRLF 
cQuery		+= " 	D_E_L_E_T_ 		= '' " +CRLF 
cQuery		+= " 	AND CT2_FILIAL	= '"+xFilial("CT2")+"' " +CRLF 
cQuery		+= " 	AND CT2_DATA	>= '"+DTOS(pDtIni)+"' " +CRLF 
cQuery		+= " 	AND CT2_DATA	<= '"+DTOS(pDtFim)+"' " +CRLF 
cQuery		+= " 	AND CT2_MOEDLC	= '"+pMoeda+"' " +CRLF 
cQuery		+= " 	AND CT2_TPSALD	= '"+pSaldo+"' " +CRLF 
cQuery		+= " 	AND CT2_DC		IN(2,3) " +CRLF 
cQuery		+= " 	AND CT2_CREDIT	= '"+pConta+"' " +CRLF     
cQuery		+= "    AND CT2_XEMP 	= '"+pEmp+"' " +CRLF       
cQuery		+= ") AS SALDOS " +CRLF
cQuery := ChangeQuery(cQuery)

*/

If Select(cTab1) > 0
	dbSelectArea(cTab1)
	(cTab1)->( dbCloseArea() )
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTab1,.T.,.F.)

If (cTab1)->(!EOF())
	nSaldo	:= (cTab1)->VALCRED - (cTab1)->VALDEB
EndIf

dbSelectArea(cTab1)
(cTab1)->( dbCloseArea() )


RestArea(aSaveAnt)

Return(nSaldo)
//-----------------------------------------------------------------------
/*{Protheus.doc} GrvCt2Eli
@Elimina o percentual do investimento do PL
@param		conta, saldo do PL, valor investimento, empresa que estou eliminando o Pl
@return		valor calculado
@author 	Zema
@since 		01/12/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------                                      
Static Function GrvCt2Eli(pConta,pSaldoC,pValorCTB,pGrpAtu,pPer)         
Local cTipo := "1"                                          
pPer := pPer * 100

CT1->(DBSETORDER(1))
CT1->(DBSEEK(XFILIAL("CT1")+pConta))
IF pSaldoC < 0 // saldo da conta negativo
	IF CT1->CT1_NORMAL == "2" // Conta do PL Credora
		cLinha := Soma1(cLinha)
 		// CREDITO na conta do PL
        RECLOCK("CT2",.T.)
        CT2->CT2_FILIAL := XFILIAL("CT2")
        CT2->CT2_DATA	:= dDataBase
        CT2->CT2_LOTE	:= cLote
        CT2->CT2_SBLOTE	:= cSbLote
        CT2->CT2_DOC	:= cDoc
        CT2->CT2_LINHA	:= cLinha
		CT2->CT2_MOEDLC	:= "01"
		CT2->CT2_DC		:= "2"
		CT2->CT2_CREDIT	:= CT1->CT1_CONTA
		CT2->CT2_VALOR	:= pValorCTB
		CT2->CT2_HIST	:= "ELIMINACAO INVESTIMENTO: % "+ALLTRIM(STR(pPer))
		CT2->CT2_EMPORI	:= cEmpAnt
		CT2->CT2_FILORI	:= cFilAnt
		CT2->CT2_INTERC	:= "2"
		CT2->CT2_TPSALD := "1"
		CT2->CT2_MANUAL	:= "1"
		CT2->CT2_ROTINA	:= "ASCTBA10"
		CT2->CT2_AGLUT	:= "2"
		CT2->CT2_SEQHIS	:= "001"
		CT2->CT2_SEQLAN	:= "001"
		CT2->CT2_XEMP	:= pGrpAtu
		MsUnlock()                                          

		cLinha := Soma1(cLinha)
 		// CREDITO na conta do PL
        RECLOCK("CT2",.T.)
        CT2->CT2_FILIAL := XFILIAL("CT2")
        CT2->CT2_DATA	:= dDataBase
        CT2->CT2_LOTE	:= cLote
        CT2->CT2_SBLOTE	:= cSbLote
        CT2->CT2_DOC	:= cDoc
        CT2->CT2_LINHA	:= cLinha
		CT2->CT2_MOEDLC	:= "01"
		CT2->CT2_DC		:= "2"
		CT2->CT2_CREDIT	:= CT1->CT1_CONTA
		CT2->CT2_VALOR	:= pValorCTB
		CT2->CT2_HIST	:= "ELIMINACAO INVESTIMENTO: % "+ALLTRIM(STR(pPer))
		CT2->CT2_EMPORI	:= cEmpAnt
		CT2->CT2_FILORI	:= cFilAnt
		CT2->CT2_INTERC	:= "2"
		CT2->CT2_TPSALD := "E"
		CT2->CT2_MANUAL	:= "1"
		CT2->CT2_ROTINA	:= "ASCTBA10"
		CT2->CT2_AGLUT	:= "2"
		CT2->CT2_SEQHIS	:= "001"
		CT2->CT2_SEQLAN	:= "001"
		CT2->CT2_XEMP	:= pGrpAtu
		MsUnlock()                                          
        
 	ELSE                             

		cLinha := Soma1(cLinha)
 		// DEBITO na conta do PL
        RECLOCK("CT2",.T.)
        CT2->CT2_FILIAL := XFILIAL("CT2")
        CT2->CT2_DATA	:= dDataBase
        CT2->CT2_LOTE	:= cLote
        CT2->CT2_SBLOTE	:= cSbLote
        CT2->CT2_DOC	:= cDoc
        CT2->CT2_LINHA	:= cLinha
		CT2->CT2_MOEDLC	:= "01"
		CT2->CT2_DC		:= "1"
		CT2->CT2_DEBITO	:= CT1->CT1_CONTA
		CT2->CT2_VALOR	:= pValorCTB
		CT2->CT2_HIST	:= "ELIMINACAO INVESTIMENTO: % "+ALLTRIM(STR(pPer))
		CT2->CT2_EMPORI	:= cEmpAnt
		CT2->CT2_FILORI	:= cFilAnt
		CT2->CT2_INTERC	:= "2"
		CT2->CT2_TPSALD := "1"
		CT2->CT2_MANUAL	:= "1"
		CT2->CT2_ROTINA	:= "ASCTBA10"
		CT2->CT2_AGLUT	:= "2"
		CT2->CT2_SEQHIS	:= "001"
		CT2->CT2_SEQLAN	:= "001"
		CT2->CT2_XEMP	:= pGrpAtu
		MsUnlock()                                          

		cLinha := Soma1(cLinha)
 		// DEBITO na conta do PL
        RECLOCK("CT2",.T.)
        CT2->CT2_FILIAL := XFILIAL("CT2")
        CT2->CT2_DATA	:= dDataBase
        CT2->CT2_LOTE	:= cLote
        CT2->CT2_SBLOTE	:= cSbLote
        CT2->CT2_DOC	:= cDoc
        CT2->CT2_LINHA	:= cLinha
		CT2->CT2_MOEDLC	:= "01"
		CT2->CT2_DC		:= "1"
		CT2->CT2_DEBITO	:= CT1->CT1_CONTA
		CT2->CT2_VALOR	:= pValorCTB
		CT2->CT2_HIST	:= "ELIMINACAO INVESTIMENTO: % "+ALLTRIM(STR(pPer))
		CT2->CT2_EMPORI	:= cEmpAnt
		CT2->CT2_FILORI	:= cFilAnt
		CT2->CT2_INTERC	:= "2"
		CT2->CT2_TPSALD := "E"
		CT2->CT2_MANUAL	:= "1"
		CT2->CT2_ROTINA	:= "ASCTBA10"
		CT2->CT2_AGLUT	:= "2"
		CT2->CT2_SEQHIS	:= "001"
		CT2->CT2_SEQLAN	:= "001"
		CT2->CT2_XEMP	:= pGrpAtu
		MsUnlock()                                          

 	ENDIF	
ELSE        
	IF CT1->CT1_NORMAL == "1" // Conta do PL Devedora
		cLinha := Soma1(cLinha)
 		// CREDITO na conta do PL
        RECLOCK("CT2",.T.)
        CT2->CT2_FILIAL := XFILIAL("CT2")
        CT2->CT2_DATA	:= dDataBase
        CT2->CT2_LOTE	:= cLote
        CT2->CT2_SBLOTE	:= cSbLote
        CT2->CT2_DOC	:= cDoc
        CT2->CT2_LINHA	:= cLinha
		CT2->CT2_MOEDLC	:= "01"
		CT2->CT2_DC		:= "2"
		CT2->CT2_CREDIT	:= CT1->CT1_CONTA
		CT2->CT2_VALOR	:= pValorCTB
		CT2->CT2_HIST	:= "ELIMINACAO INVESTIMENTO: % "+ALLTRIM(STR(pPer))
		CT2->CT2_EMPORI	:= cEmpAnt
		CT2->CT2_FILORI	:= cFilAnt
		CT2->CT2_INTERC	:= "2"
		CT2->CT2_TPSALD := "1"
		CT2->CT2_MANUAL	:= "1"
		CT2->CT2_ROTINA	:= "ASCTBA10"
		CT2->CT2_AGLUT	:= "2"
		CT2->CT2_SEQHIS	:= "001"
		CT2->CT2_SEQLAN	:= "001"
		CT2->CT2_XEMP	:= pGrpAtu	
		MsUnlock()                                          
		
		cLinha := Soma1(cLinha)
 		// CREDITO na conta do PL
        RECLOCK("CT2",.T.)
        CT2->CT2_FILIAL := XFILIAL("CT2")
        CT2->CT2_DATA	:= dDataBase
        CT2->CT2_LOTE	:= cLote
        CT2->CT2_SBLOTE	:= cSbLote
        CT2->CT2_DOC	:= cDoc
        CT2->CT2_LINHA	:= cLinha
		CT2->CT2_MOEDLC	:= "01"
		CT2->CT2_DC		:= "2"
		CT2->CT2_CREDIT	:= CT1->CT1_CONTA
		CT2->CT2_VALOR	:= pValorCTB
		CT2->CT2_HIST	:= "ELIMINACAO INVESTIMENTO: % "+ALLTRIM(STR(pPer))
		CT2->CT2_EMPORI	:= cEmpAnt
		CT2->CT2_FILORI	:= cFilAnt
		CT2->CT2_INTERC	:= "2"
		CT2->CT2_TPSALD := "E"
		CT2->CT2_MANUAL	:= "1"
		CT2->CT2_ROTINA	:= "ASCTBA10"
		CT2->CT2_AGLUT	:= "2"
		CT2->CT2_SEQHIS	:= "001"
		CT2->CT2_SEQLAN	:= "001"
		CT2->CT2_XEMP	:= pGrpAtu	
		MsUnlock()                                          
        
 	ELSE                             
		cLinha := Soma1(cLinha)
 		// DEBITO na conta do PL
        RECLOCK("CT2",.T.)
        CT2->CT2_FILIAL := XFILIAL("CT2")
        CT2->CT2_DATA	:= dDataBase
        CT2->CT2_LOTE	:= cLote
        CT2->CT2_SBLOTE	:= cSbLote
        CT2->CT2_DOC	:= cDoc
        CT2->CT2_LINHA	:= cLinha
		CT2->CT2_MOEDLC	:= "01"
		CT2->CT2_DC		:= "1"
		CT2->CT2_DEBITO	:= CT1->CT1_CONTA
		CT2->CT2_VALOR	:= pValorCTB
		CT2->CT2_HIST	:= "ELIMINACAO INVESTIMENTO: % "+ALLTRIM(STR(pPer))
		CT2->CT2_EMPORI	:= cEmpAnt
		CT2->CT2_FILORI	:= cFilAnt
		CT2->CT2_INTERC	:= "2"
		CT2->CT2_TPSALD := "1"
		CT2->CT2_MANUAL	:= "1"
		CT2->CT2_ROTINA	:= "ASCTBA10"
		CT2->CT2_AGLUT	:= "2"
		CT2->CT2_SEQHIS	:= "001"
		CT2->CT2_SEQLAN	:= "001"
		CT2->CT2_XEMP	:= pGrpAtu
		MsUnlock()                                          
		
		cLinha := Soma1(cLinha)
 		// DEBITO na conta do PL
        RECLOCK("CT2",.T.)
        CT2->CT2_FILIAL := XFILIAL("CT2")
        CT2->CT2_DATA	:= dDataBase
        CT2->CT2_LOTE	:= cLote
        CT2->CT2_SBLOTE	:= cSbLote
        CT2->CT2_DOC	:= cDoc
        CT2->CT2_LINHA	:= cLinha
		CT2->CT2_MOEDLC	:= "01"
		CT2->CT2_DC		:= "1"
		CT2->CT2_DEBITO	:= CT1->CT1_CONTA
		CT2->CT2_VALOR	:= pValorCTB
		CT2->CT2_HIST	:= "ELIMINACAO INVESTIMENTO: % "+ALLTRIM(STR(pPer))
		CT2->CT2_EMPORI	:= cEmpAnt
		CT2->CT2_FILORI	:= cFilAnt
		CT2->CT2_INTERC	:= "2"
		CT2->CT2_TPSALD := "E"
		CT2->CT2_MANUAL	:= "1"
		CT2->CT2_ROTINA	:= "ASCTBA10"
		CT2->CT2_AGLUT	:= "2"
		CT2->CT2_SEQHIS	:= "001"
		CT2->CT2_SEQLAN	:= "001"
		CT2->CT2_XEMP	:= pGrpAtu
		MsUnlock()                                          

 	ENDIF	

ENDIF

RETURN
//-----------------------------------------------------------------------
/*{Protheus.doc} GrvCt2Min
@Elimina o percentual do investimento do PL
@param		conta, saldo do PL, valor investimento, empresa que estou eliminando o Pl
@return		valor calculado
@author 	Zema
@since 		01/12/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------                                      
Static Function GrvCt2Min(pConta,pSaldoC,pValorCTB,pGrpAtu,pPer)         
Local cTipo := "1"
pPer := pPer * 100

CT1->(DBSETORDER(1))
CT1->(DBSEEK(XFILIAL("CT1")+pConta))
IF pSaldoC < 0 // saldo da conta negativo
	IF CT1->CT1_NORMAL == "2" // Conta do PL Credora
		cLinha := Soma1(cLinha)
 		// CREDITO na conta do PL
        RECLOCK("CT2",.T.)
        CT2->CT2_FILIAL := XFILIAL("CT2")
        CT2->CT2_DATA	:= dDataBase
        CT2->CT2_LOTE	:= cLote
        CT2->CT2_SBLOTE	:= cSbLote
        CT2->CT2_DOC	:= cDoc
        CT2->CT2_LINHA	:= cLinha
		CT2->CT2_MOEDLC	:= "01"
		CT2->CT2_DC		:= "2"
		CT2->CT2_CREDIT	:= CT1->CT1_CONTA
		CT2->CT2_VALOR	:= pValorCTB
		CT2->CT2_HIST	:= "ELIMINACAO INVESTIMENTO: % "+ALLTRIM(STR(pPer))
		CT2->CT2_EMPORI	:= cEmpAnt
		CT2->CT2_FILORI	:= cFilAnt
		CT2->CT2_INTERC	:= "2"
		CT2->CT2_TPSALD := "1"
		CT2->CT2_MANUAL	:= "1"
		CT2->CT2_ROTINA	:= "ASCTBA10"
		CT2->CT2_AGLUT	:= "2"
		CT2->CT2_SEQHIS	:= "001"
		CT2->CT2_SEQLAN	:= "001"
		CT2->CT2_XEMP	:= pGrpAtu
		MsUnlock()                                          

		cLinha := Soma1(cLinha)
 		// CREDITO na conta do PL
        RECLOCK("CT2",.T.)
        CT2->CT2_FILIAL := XFILIAL("CT2")
        CT2->CT2_DATA	:= dDataBase
        CT2->CT2_LOTE	:= cLote
        CT2->CT2_SBLOTE	:= cSbLote
        CT2->CT2_DOC	:= cDoc
        CT2->CT2_LINHA	:= cLinha
		CT2->CT2_MOEDLC	:= "01"
		CT2->CT2_DC		:= "2"
		CT2->CT2_CREDIT	:= CT1->CT1_CONTA
		CT2->CT2_VALOR	:= pValorCTB
		CT2->CT2_HIST	:= "ELIMINACAO INVESTIMENTO: % "+ALLTRIM(STR(pPer))
		CT2->CT2_EMPORI	:= cEmpAnt
		CT2->CT2_FILORI	:= cFilAnt
		CT2->CT2_INTERC	:= "2"
		CT2->CT2_TPSALD := "E"
		CT2->CT2_MANUAL	:= "1"
		CT2->CT2_ROTINA	:= "ASCTBA10"
		CT2->CT2_AGLUT	:= "2"
		CT2->CT2_SEQHIS	:= "001"
		CT2->CT2_SEQLAN	:= "001"
		CT2->CT2_XEMP	:= pGrpAtu
		MsUnlock()                                          

		cLinha := Soma1(cLinha)
		// DEBITO MINORITARIOS
   	   	RECLOCK("CT2",.T.)
   	   	CT2->CT2_FILIAL := XFILIAL("CT2")
   	   	CT2->CT2_DATA	:= dDataBase
       	CT2->CT2_LOTE	:= cLote
       	CT2->CT2_SBLOTE	:= cSbLote
       	CT2->CT2_DOC	:= cDoc
       	CT2->CT2_LINHA	:= cLinha
		CT2->CT2_MOEDLC	:= "01"
		CT2->CT2_DC		:= "1"
		CT2->CT2_DEBITO	:= "502001001001001"
		CT2->CT2_VALOR	:= pValorCTB
		CT2->CT2_HIST	:= "CLASSIFICACAO NAO CONTROLADORES: % "+ALLTRIM(STR(pPer))
		CT2->CT2_EMPORI	:= cEmpAnt
		CT2->CT2_FILORI	:= cFilAnt
		CT2->CT2_INTERC	:= "2"
		CT2->CT2_TPSALD := "1"
		CT2->CT2_MANUAL	:= "1"
		CT2->CT2_ROTINA	:= "ASCTBA10"
		CT2->CT2_AGLUT	:= "2"
		CT2->CT2_SEQHIS	:= "001"
		CT2->CT2_SEQLAN	:= "001"
		CT2->CT2_XEMP	:= pGrpAtu
		MsUnlock()                                          
                                                                
		cLinha := Soma1(cLinha)
 		// DEBITO MINORITARIOS
   	   	RECLOCK("CT2",.T.)
   	   	CT2->CT2_FILIAL := XFILIAL("CT2")
   	   	CT2->CT2_DATA	:= dDataBase
       	CT2->CT2_LOTE	:= cLote
       	CT2->CT2_SBLOTE	:= cSbLote
       	CT2->CT2_DOC	:= cDoc
       	CT2->CT2_LINHA	:= cLinha
		CT2->CT2_MOEDLC	:= "01"
		CT2->CT2_DC		:= "1"
		CT2->CT2_DEBITO	:= "502001001001001"
		CT2->CT2_VALOR	:= pValorCTB
		CT2->CT2_HIST	:= "CLASSIFICACAO NAO CONTROLADORES: % "+ALLTRIM(STR(pPer))
		CT2->CT2_EMPORI	:= cEmpAnt
		CT2->CT2_FILORI	:= cFilAnt
		CT2->CT2_INTERC	:= "2"
		CT2->CT2_TPSALD := "E"
		CT2->CT2_MANUAL	:= "1"
		CT2->CT2_ROTINA	:= "ASCTBA10"
		CT2->CT2_AGLUT	:= "2"
		CT2->CT2_SEQHIS	:= "001"
		CT2->CT2_SEQLAN	:= "001"
		CT2->CT2_XEMP	:= pGrpAtu
		MsUnlock()                                          
            
 	ELSE                             
		cLinha := Soma1(cLinha)
 		// DEBITO na conta do PL
        RECLOCK("CT2",.T.)
        CT2->CT2_FILIAL := XFILIAL("CT2")
        CT2->CT2_DATA	:= dDataBase
        CT2->CT2_LOTE	:= cLote
        CT2->CT2_SBLOTE	:= cSbLote
        CT2->CT2_DOC	:= cDoc
        CT2->CT2_LINHA	:= cLinha
		CT2->CT2_MOEDLC	:= "01"
		CT2->CT2_DC		:= "1"
		CT2->CT2_DEBITO	:= CT1->CT1_CONTA
		CT2->CT2_VALOR	:= pValorCTB
		CT2->CT2_HIST	:= "ELIMINACAO INVESTIMENTO: % "+ALLTRIM(STR(pPer))
		CT2->CT2_EMPORI	:= cEmpAnt
		CT2->CT2_FILORI	:= cFilAnt
		CT2->CT2_INTERC	:= "2"
		CT2->CT2_TPSALD := "1"
		CT2->CT2_MANUAL	:= "1"
		CT2->CT2_ROTINA	:= "ASCTBA10"
		CT2->CT2_AGLUT	:= "2"
		CT2->CT2_SEQHIS	:= "001"
		CT2->CT2_SEQLAN	:= "001"
		CT2->CT2_XEMP	:= pGrpAtu
		MsUnlock()                                          

		cLinha := Soma1(cLinha)
 		// DEBITO na conta do PL
        RECLOCK("CT2",.T.)
        CT2->CT2_FILIAL := XFILIAL("CT2")
        CT2->CT2_DATA	:= dDataBase
        CT2->CT2_LOTE	:= cLote
        CT2->CT2_SBLOTE	:= cSbLote
        CT2->CT2_DOC	:= cDoc
        CT2->CT2_LINHA	:= cLinha
		CT2->CT2_MOEDLC	:= "01"
		CT2->CT2_DC		:= "1"
		CT2->CT2_DEBITO	:= CT1->CT1_CONTA
		CT2->CT2_VALOR	:= pValorCTB
		CT2->CT2_HIST	:= "ELIMINACAO INVESTIMENTO: % "+ALLTRIM(STR(pPer))
		CT2->CT2_EMPORI	:= cEmpAnt
		CT2->CT2_FILORI	:= cFilAnt
		CT2->CT2_INTERC	:= "2"
		CT2->CT2_TPSALD := "E"
		CT2->CT2_MANUAL	:= "1"
		CT2->CT2_ROTINA	:= "ASCTBA10"
		CT2->CT2_AGLUT	:= "2"
		CT2->CT2_SEQHIS	:= "001"
		CT2->CT2_SEQLAN	:= "001"
		CT2->CT2_XEMP	:= pGrpAtu
		MsUnlock()                                          

		cLinha := Soma1(cLinha)
		// CREDITO MINORITARIOS
	    RECLOCK("CT2",.T.)
	    CT2->CT2_FILIAL := XFILIAL("CT2")
	    CT2->CT2_DATA	:= dDataBase
	    CT2->CT2_LOTE	:= cLote
	    CT2->CT2_SBLOTE	:= cSbLote
	    CT2->CT2_DOC	:= cDoc
	    CT2->CT2_LINHA	:= cLinha
		CT2->CT2_MOEDLC	:= "01"
		CT2->CT2_DC		:= "1"
		CT2->CT2_DEBITO := "502001001001001"
		CT2->CT2_VALOR	:= pValorCTB
		CT2->CT2_HIST	:= "CLASSIFICACAO NAO CONTROLADORES: % "+ALLTRIM(STR(pPer))
		CT2->CT2_EMPORI	:= cEmpAnt
		CT2->CT2_FILORI	:= cFilAnt
		CT2->CT2_INTERC	:= "2"
		CT2->CT2_TPSALD := "1"
		CT2->CT2_MANUAL	:= "1"
		CT2->CT2_ROTINA	:= "ASCTBA10"
		CT2->CT2_AGLUT	:= "2"
		CT2->CT2_SEQHIS	:= "001"
		CT2->CT2_SEQLAN	:= "001"
		CT2->CT2_XEMP	:= pGrpAtu
		MsUnlock()                                          
                                                                
		cLinha := Soma1(cLinha)
 		// DEBITO na conta do PL
        RECLOCK("CT2",.T.)
        CT2->CT2_FILIAL := XFILIAL("CT2")
        CT2->CT2_DATA	:= dDataBase
        CT2->CT2_LOTE	:= cLote
        CT2->CT2_SBLOTE	:= cSbLote
        CT2->CT2_DOC	:= cDoc
        CT2->CT2_LINHA	:= cLinha
		CT2->CT2_MOEDLC	:= "01"
		CT2->CT2_DC		:= "1"
		CT2->CT2_DEBITO	:= "502001001001001"
		CT2->CT2_VALOR	:= pValorCTB
		CT2->CT2_HIST	:= "CLASSIFICACAO NAO CONTROLADORES: % "+ALLTRIM(STR(pPer))
		CT2->CT2_EMPORI	:= cEmpAnt
		CT2->CT2_FILORI	:= cFilAnt
		CT2->CT2_INTERC	:= "2"
		CT2->CT2_TPSALD := "E"
		CT2->CT2_MANUAL	:= "1"
		CT2->CT2_ROTINA	:= "ASCTBA10"
		CT2->CT2_AGLUT	:= "2"
		CT2->CT2_SEQHIS	:= "001"
		CT2->CT2_SEQLAN	:= "001"
		CT2->CT2_XEMP	:= pGrpAtu
		MsUnlock()                                          

 	ENDIF	
ELSE        
	IF CT1->CT1_NORMAL == "1" // Conta do PL Devedora
		cLinha := Soma1(cLinha)
 		// CREDITO na conta do PL
        RECLOCK("CT2",.T.)
        CT2->CT2_FILIAL := XFILIAL("CT2")
        CT2->CT2_DATA	:= dDataBase
        CT2->CT2_LOTE	:= cLote
        CT2->CT2_SBLOTE	:= cSbLote
        CT2->CT2_DOC	:= cDoc
        CT2->CT2_LINHA	:= cLinha
		CT2->CT2_MOEDLC	:= "01"
		CT2->CT2_DC		:= "2"
		CT2->CT2_CREDIT	:= CT1->CT1_CONTA
		CT2->CT2_VALOR	:= pValorCTB
		CT2->CT2_HIST	:= "ELIMINACAO INVESTIMENTO: % "+ALLTRIM(STR(pPer))
		CT2->CT2_EMPORI	:= cEmpAnt
		CT2->CT2_FILORI	:= cFilAnt
		CT2->CT2_INTERC	:= "2"
		CT2->CT2_TPSALD := "1"
		CT2->CT2_MANUAL	:= "1"
		CT2->CT2_ROTINA	:= "ASCTBA10"
		CT2->CT2_AGLUT	:= "2"
		CT2->CT2_SEQHIS	:= "001"
		CT2->CT2_SEQLAN	:= "001"
		CT2->CT2_XEMP	:= pGrpAtu	
		MsUnlock()                                          
		
		cLinha := Soma1(cLinha)
 		// CREDITO na conta do PL
        RECLOCK("CT2",.T.)
        CT2->CT2_FILIAL := XFILIAL("CT2")
        CT2->CT2_DATA	:= dDataBase
        CT2->CT2_LOTE	:= cLote
        CT2->CT2_SBLOTE	:= cSbLote
        CT2->CT2_DOC	:= cDoc
        CT2->CT2_LINHA	:= cLinha
		CT2->CT2_MOEDLC	:= "01"
		CT2->CT2_DC		:= "2"
		CT2->CT2_CREDIT	:= CT1->CT1_CONTA
		CT2->CT2_VALOR	:= pValorCTB
		CT2->CT2_HIST	:= "ELIMINACAO INVESTIMENTO: % "+ALLTRIM(STR(pPer))
		CT2->CT2_EMPORI	:= cEmpAnt
		CT2->CT2_FILORI	:= cFilAnt
		CT2->CT2_INTERC	:= "2"
		CT2->CT2_TPSALD := "E"
		CT2->CT2_MANUAL	:= "1"
		CT2->CT2_ROTINA	:= "ASCTBA10"
		CT2->CT2_AGLUT	:= "2"
		CT2->CT2_SEQHIS	:= "001"
		CT2->CT2_SEQLAN	:= "001"
		CT2->CT2_XEMP	:= pGrpAtu	
		MsUnlock()                                          

		cLinha := Soma1(cLinha)
		// CREDITO na conta do PL
	    RECLOCK("CT2",.T.)
	    CT2->CT2_FILIAL := XFILIAL("CT2")
	    CT2->CT2_DATA	:= dDataBase
	    CT2->CT2_LOTE	:= cLote
	    CT2->CT2_SBLOTE	:= cSbLote
	    CT2->CT2_DOC	:= cDoc
	    CT2->CT2_LINHA	:= cLinha
		CT2->CT2_MOEDLC	:= "01"
		CT2->CT2_DC		:= "2"
		CT2->CT2_CREDIT	:= "502001001001001"
		CT2->CT2_VALOR	:= pValorCTB
		CT2->CT2_HIST	:= "CLASSIFICACAO NAO CONTROLADORES: % "+ALLTRIM(STR(pPer))
		CT2->CT2_EMPORI	:= cEmpAnt
		CT2->CT2_FILORI	:= cFilAnt
		CT2->CT2_INTERC	:= "2"
		CT2->CT2_TPSALD := "1"
		CT2->CT2_MANUAL	:= "1"
		CT2->CT2_ROTINA	:= "ASCTBA10"
		CT2->CT2_AGLUT	:= "2"
		CT2->CT2_SEQHIS	:= "001"
		CT2->CT2_SEQLAN	:= "001"
		CT2->CT2_XEMP	:= pGrpAtu	
		MsUnlock()                                          
	
		cLinha := Soma1(cLinha)
 		// CREDITO na conta do PL
        RECLOCK("CT2",.T.)
        CT2->CT2_FILIAL := XFILIAL("CT2")
        CT2->CT2_DATA	:= dDataBase
        CT2->CT2_LOTE	:= cLote
        CT2->CT2_SBLOTE	:= cSbLote
        CT2->CT2_DOC	:= cDoc
        CT2->CT2_LINHA	:= cLinha
		CT2->CT2_MOEDLC	:= "01"
		CT2->CT2_DC		:= "2"
		CT2->CT2_CREDIT	:= "502001001001001"
		CT2->CT2_VALOR	:= pValorCTB
		CT2->CT2_HIST	:= "CLASSIFICACAO NAO CONTROLADORES: % "+ALLTRIM(STR(pPer))
		CT2->CT2_EMPORI	:= cEmpAnt
		CT2->CT2_FILORI	:= cFilAnt
		CT2->CT2_INTERC	:= "2"
		CT2->CT2_TPSALD := "E"
		CT2->CT2_MANUAL	:= "1"
		CT2->CT2_ROTINA	:= "ASCTBA10"
		CT2->CT2_AGLUT	:= "2"
		CT2->CT2_SEQHIS	:= "001"
		CT2->CT2_SEQLAN	:= "001"
		CT2->CT2_XEMP	:= pGrpAtu	
		MsUnlock()                                          
      
 	ELSE                             
		cLinha := Soma1(cLinha)
 		// DEBITO na conta do PL
        RECLOCK("CT2",.T.)
        CT2->CT2_FILIAL := XFILIAL("CT2")
        CT2->CT2_DATA	:= dDataBase
        CT2->CT2_LOTE	:= cLote
        CT2->CT2_SBLOTE	:= cSbLote
        CT2->CT2_DOC	:= cDoc
        CT2->CT2_LINHA	:= cLinha
		CT2->CT2_MOEDLC	:= "01"
		CT2->CT2_DC		:= "1"
		CT2->CT2_DEBITO	:= CT1->CT1_CONTA
		CT2->CT2_VALOR	:= pValorCTB
		CT2->CT2_HIST	:= "ELIMINACAO INVESTIMENTO: % "+ALLTRIM(STR(pPer))
		CT2->CT2_EMPORI	:= cEmpAnt
		CT2->CT2_FILORI	:= cFilAnt
		CT2->CT2_INTERC	:= "2"
		CT2->CT2_TPSALD := "1"
		CT2->CT2_MANUAL	:= "1"
		CT2->CT2_ROTINA	:= "ASCTBA10"
		CT2->CT2_AGLUT	:= "2"
		CT2->CT2_SEQHIS	:= "001"
		CT2->CT2_SEQLAN	:= "001"
		CT2->CT2_XEMP	:= pGrpAtu
		MsUnlock()                                          
		
		cLinha := Soma1(cLinha)
 		// DEBITO na conta do PL
        RECLOCK("CT2",.T.)
        CT2->CT2_FILIAL := XFILIAL("CT2")
        CT2->CT2_DATA	:= dDataBase
        CT2->CT2_LOTE	:= cLote
        CT2->CT2_SBLOTE	:= cSbLote
        CT2->CT2_DOC	:= cDoc
        CT2->CT2_LINHA	:= cLinha
		CT2->CT2_MOEDLC	:= "01"
		CT2->CT2_DC		:= "1"
		CT2->CT2_DEBITO	:= CT1->CT1_CONTA
		CT2->CT2_VALOR	:= pValorCTB
		CT2->CT2_HIST	:= "ELIMINACAO INVESTIMENTO: % "+ALLTRIM(STR(pPer))
		CT2->CT2_EMPORI	:= cEmpAnt
		CT2->CT2_FILORI	:= cFilAnt
		CT2->CT2_INTERC	:= "2"
		CT2->CT2_TPSALD := "E"
		CT2->CT2_MANUAL	:= "1"
		CT2->CT2_ROTINA	:= "ASCTBA10"
		CT2->CT2_AGLUT	:= "2"
		CT2->CT2_SEQHIS	:= "001"
		CT2->CT2_SEQLAN	:= "001"
		CT2->CT2_XEMP	:= pGrpAtu
		MsUnlock()                                          

		cLinha := Soma1(cLinha)
 		// DEBITO na conta do PL
        RECLOCK("CT2",.T.)
        CT2->CT2_FILIAL := XFILIAL("CT2")
        CT2->CT2_DATA	:= dDataBase
        CT2->CT2_LOTE	:= cLote
        CT2->CT2_SBLOTE	:= cSbLote
        CT2->CT2_DOC	:= cDoc
        CT2->CT2_LINHA	:= cLinha
		CT2->CT2_MOEDLC	:= "01"
		CT2->CT2_DC		:= "2"
		CT2->CT2_CREDIT	:= "502001001001001"
		CT2->CT2_VALOR	:= pValorCTB
		CT2->CT2_HIST	:= "CLASSIFICACAO NAO CONTROLADORES: % "+ALLTRIM(STR(pPer))
		CT2->CT2_EMPORI	:= cEmpAnt
		CT2->CT2_FILORI	:= cFilAnt
		CT2->CT2_INTERC	:= "2"
		CT2->CT2_TPSALD := "1"
		CT2->CT2_MANUAL	:= "1"
		CT2->CT2_ROTINA	:= "ASCTBA10"
		CT2->CT2_AGLUT	:= "2"
		CT2->CT2_SEQHIS	:= "001"
		CT2->CT2_SEQLAN	:= "001"
		CT2->CT2_XEMP	:= pGrpAtu
		MsUnlock()                                          
                                                               
		cLinha := Soma1(cLinha)
 		// DEBITO na conta do PL
        RECLOCK("CT2",.T.)
        CT2->CT2_FILIAL := XFILIAL("CT2")
        CT2->CT2_DATA	:= dDataBase
        CT2->CT2_LOTE	:= cLote
        CT2->CT2_SBLOTE	:= cSbLote
        CT2->CT2_DOC	:= cDoc
        CT2->CT2_LINHA	:= cLinha
		CT2->CT2_MOEDLC	:= "01"
		CT2->CT2_DC		:= "2"
		CT2->CT2_CREDIT	:= "502001001001001"
		CT2->CT2_VALOR	:= pValorCTB
		CT2->CT2_HIST	:= "CLASSIFICACAO NAO CONTROLADORES: % "+ALLTRIM(STR(pPer))
		CT2->CT2_EMPORI	:= cEmpAnt
		CT2->CT2_FILORI	:= cFilAnt
		CT2->CT2_INTERC	:= "2"
		CT2->CT2_TPSALD := "E"
		CT2->CT2_MANUAL	:= "1"
		CT2->CT2_ROTINA	:= "ASCTBA10"
		CT2->CT2_AGLUT	:= "2"
		CT2->CT2_SEQHIS	:= "001"
		CT2->CT2_SEQLAN	:= "001"
		CT2->CT2_XEMP	:= pGrpAtu
		MsUnlock()           

 	ENDIF	

ENDIF

RETURN




//-----------------------------------------------------------------------
/*{Protheus.doc} APUR
@Apura o saldo de um grupo de contas
@param		grupo+empresa+unidade+filial, grupo de contas (2, 3, 203, ...) , tipo de saldo, moeda, data
@return		valor calculado
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------                                      
USER Function APUR(pEmpresa, pGrpCon, pTpSld, pMoeda, pData)
Local cProc		:= 'POPUTRB_'+CriaTrab(nil,.F.)                            
Local cSQL      := ""
Local aResult   := {}
Local cGrpEmp	:= SUBSTR(pEmpresa,1,2)
Local cEmpresa  := SUBSTR(RIGHT(pEmpresa,TAMSX3("CQ4_FILIAL")[1]),1,LEN(ALLTRIM(XFILIAL("CT2"))))
Local cGrpCon   := ALLTRIM(pGrpCon)
Local cTpSld	:= pTpSld
Local cMoeda    := pMoeda
Local cData     := DTOS(pData) 
Local cDataIni	:= DTOS(FirstDay(pData))
Local cTabCQ0 	:= U_RtTab("CQ0",cGrpEmp)       
Local nValAp    := 0                     
Local cTamGRP   := ALLTRIM(STR(LEN(ALLTRIM(cGrpCon))))
Local cNatGrp   := POSICIONE("CT1",1,XFILIAL("CT1")+cGrpCon,"CT1_NORMAL")
Local lRet		:= .T.

cSQL:="create procedure "+cProc+" (@OUT_RET numeric(17,2) output) as"+CRLF
cSQL+="Declare @credito     numeric(17,2)"+CRLF                            
cSQL+="Declare @debito      numeric(17,2)"+CRLF                           
cSQL+="Declare @conta       varchar("+alltrim(str(TamSX3('CQ4_CONTA')[1]))+")"+CRLF                            
cSQL+="Declare @natureza    varchar(1)"+CRLF      
cSQL+="Declare @saldoap     numeric(17,2)"+CRLF
cSQL+="Begin "+CRLF
cSQL+=" "+CRLF
cSQL+="		select @saldoap = 0 "+CRLF 
cSQL+=" "+CRLF
cSQL+="		declare CQ0CUR01 cursor for"+CRLF
cSQL+="		select "+CRLF
cSQL+="     SUM(CQ0_CREDIT) AS CREDITO,"+CRLF
cSQL+="     SUM(CQ0_DEBITO) AS DEBITO,"+CRLF
cSQL+="     CQ0_CONTA "+CRLF
cSQL+= " 	from "+cTabCQ0
cSQL += "   where CQ0_FILIAL = '"+cEmpresa+"' AND SUBSTRING(CQ0_CONTA,1,"+cTamGRP+") = "+cGrpCon+" "+CRLF  
cSQL += "         and CQ0_MOEDA= '"+cMoeda+"' and CQ0_TPSALD = '"+cTpSld+"' and CQ0_DATA >= '"+cDataIni+"' and CQ0_DATA <= '"+cData+"' and D_E_L_E_T_ = ' '"+CRLF

cSQL += " 	group by CQ0_CONTA "+CRLF

cSQL+="		open CQ0CUR01 "+CRLF
cSQL+=" 	fetch next from CQ0CUR01 into "+CRLF
cSQL+=" 	@credito,"+CRLF  
cSQL+=" 	@debito,"+CRLF 
cSQL+=" 	@conta"+CRLF 
cSQL+=" "+CRLF
cSQL+="		while @@FETCH_STATUS = 0 "+CRLF                         
cSQL+="			begin"+CRLF                  
cSQL+=" 			Select @natureza = CT1_NORMAL from "+RetSqlName("CT1")+" where CT1_FILIAL = '"+XFILIAL("CT1")+"' and CT1_CONTA = @conta and D_E_L_E_T_ = ' ' "+CRLF
cSQL+=" "+CRLF   
cSQL+="             If @natureza = '1' Begin "+CRLF     // Natureza credora, subtrai  do  resultado o saldo da conta
cSQL+="             	Select @saldoap = @saldoap - (@credito - @debito) end "+CRLF
cSQL+="             Else Begin"+CRLF					// Natureza devedora,  adiciona no  resultado o saldo da conta 
cSQL+="               	Select @saldoap = @saldoap + (@debito - @credito ) "+CRLF
cSQL+=" 		 	end"+CRLF                     
cSQL+=" "+CRLF
cSQL+=" 		fetch next from CQ0CUR01 into "+CRLF
cSQL+=" 		@credito,"+CRLF  
cSQL+=" 		@debito,"+CRLF 
cSQL+=" 		@conta"+CRLF 
cSQL+=" "+CRLF
cSQL+=" 	end"+CRLF   
cSQL+=" 	close CQ0CUR01"+CRLF
cSQL+=" 	deallocate CQ0CUR01"+CRLF
cSQL+=" 	commit"+CRLF
cSQL+=" 	Select @OUT_RET = @saldoap"+CRLF
cSQL+=" "+CRLF
cSQL+="end"+CRLF

//MemoWrite("APURA.SQL",cSQL)	     		
		
// Ajusta a expressão para o Banco de Dados
cSQL:=MsParse(cSQL,Alltrim(TcGetDB()))
                                            
IF EMPTY(cSQL)                                                                      
	ApMsgAlert("Erro ao criar a stored procedure - PARSE.")
	lRet := .F.
ELSE                                  
//	MemoWrite("APURP.SQL",cSQL)	
	cSQL:=StrTran(cSQL, " numeric", " numeric("+alltrim(str(TamSX3('CT2_VALOR')[1]))+","+alltrim(str(TamSX3('CT2_VALOR')[2]))+")")
	cRet:=TcSqlExec(cSQL)
	IF cRet <> 0
		ApMsgAlert("Erro ao criar a stored procedure - TCSQLEXEC.")
		lRet := .F.
	ELSE
		aResult := TCSPExec( cProc, '' )	
		
		if empty(aResult)                                                                                   
			ApMsgAlert("Erro ao executar a stored procedure.")
			lRet := .F.    
		endif      
	
	ENDIF
ENDIF                     

IF TCSPExist( cProc ) 
	TcSqlExec('DROP PROCEDURE '+cProc)
endif                

IF lRet

	nValAp := aResult[1]   
	
	IF cNatGrp == "1"  // Grupo Credor
		nValAp	:= nValAp * (-1)
	ENDIF		

ENDIF

RETURN(nValAp)                                                          