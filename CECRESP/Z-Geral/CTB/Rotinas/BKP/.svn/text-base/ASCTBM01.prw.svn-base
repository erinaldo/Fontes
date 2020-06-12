#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'
//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTBM01
@Contabilização da Equivalência Patrimonial
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------
User Function ASCTBM01                     
Local aSays     := {}                              
Local aButtons  := {}
Local nOpca     := 0          
Local lContinua := .T.
Private nOpLan  := 1                          
Private dDataRef:= LastDay(dDataBase)
               
Aadd(aSays, OemToAnsi("Esta rotina gera a contabilização dos eventos relacionados no cadastro de"))
Aadd(aSays, OemToAnsi("estrutura de participação."))
Aadd(aSays, OemToAnsi(PADC("Data Base: "+DTOC(dDataRef)+".",100)))

Aadd(aButtons, { 1, .T., { || nOpca := 1, FechaBatch()  }})
Aadd(aButtons, { 2, .T., { || FechaBatch() }})

FormBatch("Contabilização Equivalência", aSays, aButtons)

If nOpca == 1         

	// Verifica se já existe lançamento para o período
	cQ := "SELECT R_E_C_N_O_ AS REG, Z3_STATUS FROM "+RetSqlName("SZ3")
	cQ += " WHERE Z3_FILIAL = '"+XFILIAL("SZ3")+"'"
	cQ += " AND Z3_DTBASE   = '"+DTOS(dDataRef)+"'"
	cQ += " AND Z3_STATUS   = 'ATIVO'"	
	cQ += " AND D_E_L_E_T_  = ' '"
	TcQuery ChangeQuery(cQ) ALIAS "XSZ3" NEW
	
	IF XSZ3->REG > 0 
		ApMsgInfo("Já existem movimentos para o periodo.")
		XSZ3->(DBCLOSEAREA())
    ELSE
		XSZ3->(DBCLOSEAREA())    
		Processa( { || Contabiliza() }, "Processando lançamentos . . .")   
		ApMsgInfo("Processamento concluído.")    
	ENDIF
EndIf

RETURN                                                                   
//-----------------------------------------------------------------------
/*{Protheus.doc} CONTABILIZA
@Contabilização da Equivalência Patrimonial
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------
Static Function Contabiliza
Local _nCont     := 0                                
Local aParams    := {}
Local cSemaforo  := ""                           
Local cEmpAtu    := ""                     
Local aEventos   := {}
Local aEventosT  := {}
Local aLisEven	 := {}
Local nA		 := 0
Local nX         := 0
Local nY		 := 0
Local cQ         := ""                 
Local nReg    	 := 0
Local aTrb       := {}                    
Local lRetTRB    := .T.
Local cFiltro    := "Z2_DTBASE = CTOD('"+DTOC(FirstDay(dDataRef))+"')"
Local Valor      := 0
Local ChaveCt2   := ""
Private nControl := 0
Private nZema    := 1         

cQ := "SELECT Z2_EMP, Z2_EMPPAR, Z2_QUANT, Z2_EVENTOS"
cQ += " FROM "+RetSqlName("SZ2")+" SZ2 "   
cQ += " WHERE Z2_FILIAL = '"+XFILIAL("SZ2")+"' AND Z2_DTBASE = '"+DTOS(FirstDay(dDataRef))+"' AND D_E_L_E_T_ = ' '"
cQ += " ORDER BY Z2_EMP, Z2_EMPPAR "
TcQuery ChangeQuery(cQ) ALIAS "XSZ2" NEW
                        
MontaTRB("DESCEND(ORD)+INVESTE") 

DBSELECTAREA("SZ2")
SET FILTER TO &(cFiltro)

WHILE XSZ2->(!EOF()) .AND. lRetTRB
	nControl := 0
	lRetTRB := GravaTRB(XSZ2->Z2_EMP,XSZ2->Z2_EMPPAR,1)
	XSZ2->(DBSKIP())
END
XSZ2->(DBCLOSEAREA())   

DBSELECTAREA("SZ2")
SET FILTER TO
      
IF !lRetTRB
	ApMsgAlert("Erro na estrutura de participação, verificar.")
	RETURN
ENDIF
               
// Processa registros
TRB->(DBGOTOP())
lContinua := .T.
   
WHILE TRB->(!EOF())         
	AADD(aTrb,{TRB->INVESTE, TRB->INVESTIDA, TRB->ACOES, TRB->QUOTAS , TRB->EVENTOS, TRB->ORD, TRB->CONTA, TRB->ITEMCTA})
	nReg++
	TRB->(DBSKIP())
END    

TRB->(DBCLOSEAREA())                    

PROCREGUA(nReg)

ConOut("ASCTBM01 - INICIO  " + DTOS(DATE())+StrTran(TIME(), ":", "") + " *.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*"  )				                       

SZ1->(DBSETORDER(1))
                    
lContinua := .T.

nA := 1
WHILE nA <= LEN(aTrb)
	IncProc()
               
	cEmpAtu   := aTrb[nA][1]
    aEventos := {}        
    aLisEven := STRTOKARR(ALLTRIM(aTrb[nA][5]),"#")
    
	WHILE nA <= LEN(aTrb) .AND. aTrb[nA][1] == cEmpAtu .AND. lContinua
	    aEventosT:={}
		FOR nX := 1 TO LEN(aLisEven)
			IF SZ1->(DBSEEK(XFILIAL("SZ1")+aLisEven[nX])) 			
				AADD(aEventosT,{aTrb[nA][1],; 	 // 1- Empresa Investidora
								aTrb[nA][2],;    // 2- Empresa Investida
								aLisEven[nX],; 	 // 3- Código do evento
								SZ1->Z1_FORMULA,;// 4- Fórmula do valor
								0,;              // 5- Valor 
								SZ1->Z1_LP,; 	 // 6- Lançamento Padrão  
								SZ1->Z1_LOTE,;   // 7- Lote
								aTrb[nA][7],;    // 8- Conta								
								aTrb[nA][3],; 	 // 9- Acoes
								aTrb[nA][4],;	 //10- Quotas 
								aTrb[nA][8]})    //11- Item Contábil
			ENDIF
		
		NEXT nX

	    FOR nX := 1 TO LEN(aEventosT)                   
				
			cSemaforo := "EQV_F"+ALLTRIM(aEventosT[nX][1])+ALLTRIM(aEventosT[nX][2])+ALLTRIM(aEventosT[nX][3])+DTOS(DATE())+StrTran(TIME(), ":", "")
			aSemaforo := {}
			AADD(aSemaforo,{cSemaforo,"A"})				
                
			RECLOCK("SZ4",.T.)
			SZ4->Z4_FILIAL := XFILIAL("SZ4")
			SZ4->Z4_SEMAF  := cSemaforo
			SZ4->Z4_STATUS := "A"
			MsUnlock()

			aParams := {}                                                          
			aAdd(aParams, aEventosT)
			aAdd(aParams, cSemaforo)
			aAdd(aParams, nX)			
			aAdd(aParams, dDataRef)						
                
			StartJob('U_ASCTB01E', GetEnvServer(), .F., aParams) 
				     
			MsAguarde( { || U_ASCTBA09(aSemaforo) }, "Aguardando formula do evento "+aEventosT[nX][3])				   
				
			IF aSemaforo[LEN(aSemaforo)][2] $ "A/X"            
				MSGALERT("Falha na execução da formula"+aEventosT[nX][4]+" do evento: "+aEventosT[nX][3])				
				lContinua := .F.
			ENDIF
            
			IF !lContinua
				EXIT
			ENDIF

			cQ := "SELECT Z4_RETORNO FROM "+RetSqlName("SZ4")+" WHERE Z4_SEMAF = '"+cSemaforo+"'"
			TcQuery ChangeQuery(cQ) ALIAS "XSZ4" NEW
				        
			Valor	:= VAL(ALLTRIM(XSZ4->Z4_RETORNO))
			XSZ4->(dbCloseArea())    

			aEventosT[nX][5] :=  Valor

			// limpa semaforo

			FOR _nCont := 1 TO LEN(aSemaforo)
				TCSQLEXEC("DELETE FROM "+RetSqlName("SZ4")+" WHERE Z4_SEMAF = '"+ALLTRIM(aSemaforo[_nCont][1])+"'")
				TCRefresh(RetSqlName("SZ4"))	
			NEXT 

		NEXT nX
    	
       	AADD(aEventos,aEventosT)
  		
  		nA++      
  		IF nA > LEN(aTrb) .OR. !lContinua
  			EXIT
  		ENDIF
  	END   
  	
	IF !lContinua
		EXIT
	ENDIF  	

	// Na empresa investidora, efetuo a contabilização dos eventos

	FOR nX := 1 TO LEN(aEventos)  
		FOR nY := 1 TO LEN(aEventos[nX])
			IF ABS(aEventos[nX][nY][5]) > 0
				cSemaforo := "EQV_C"+ALLTRIM(aEventos[nX][nY][1])+ALLTRIM(aEventos[nX][nY][2])+ALLTRIM(aEventos[nX][nY][3])+DTOS(DATE())+StrTran(TIME(), ":", "")
				aSemaforo := {}
				AADD(aSemaforo,{cSemaforo,"A"})				

				RECLOCK("SZ4",.T.)
				SZ4->Z4_FILIAL := XFILIAL("SZ4")
				SZ4->Z4_SEMAF  := cSemaforo
				SZ4->Z4_STATUS := "A"
				MsUnlock()

				aParams := {}                                                          
				aAdd(aParams, aEventos[nX])
				aAdd(aParams, cSemaforo)
				aAdd(aParams, nY)						
				aAdd(aParams, dDataRef)											
					                                             
				StartJob('U_ASCTB01C', GetEnvServer(), .F., aParams) 					

				MsAguarde( { || U_ASCTBA09(aSemaforo) }, "Aguardando contabilização do evento "+aEventos[nX][nY][3])				   
				
				IF aSemaforo[LEN(aSemaforo)][2] $ "A/X"            
					MSGALERT("Falha na contabilização da formula"+aEventos[nX][nY][4]+" do evento: "+aEventos[nX][nY][3])				
					lContinua := .F.
				ENDIF
            
   				IF !lContinua
					EXIT
				ENDIF              
				
				cQ := "SELECT Z4_RETORNO FROM "+RetSqlName("SZ4")+" WHERE Z4_SEMAF = '"+cSemaforo+"'"
				TcQuery ChangeQuery(cQ) ALIAS "XSZ4" NEW
				        
				ChaveCt2 := ALLTRIM(XSZ4->Z4_RETORNO)
				XSZ4->(dbCloseArea())
			
			    RECLOCK("SZ3",.T.)
			    SZ3->Z3_FILIAL := XFILIAL("SZ3")
			    SZ3->Z3_DTBASE := dDataRef
			    SZ3->Z3_EMP	   := aEventos[nX][nY][1]
			    SZ3->Z3_EMPPAR := aEventos[nX][nY][2]
			    SZ3->Z3_EVENTO := aEventos[nX][nY][3]
			    SZ3->Z3_VALOR  := aEventos[nX][nY][5]      
			    SZ3->Z3_ACOES  := aEventos[nX][nY][9]
			    SZ3->Z3_QUOTAS := aEventos[nX][nY][10]			    
			    SZ3->Z3_CT2    := ChaveCt2
			    SZ3->Z3_STATUS := "ATIVO"
			    MsUNlock()

		  		// limpa semaforo
				FOR _nCont := 1 TO LEN(aSemaforo)
					TCSQLEXEC("DELETE FROM "+RetSqlName("SZ4")+" WHERE Z4_SEMAF = '"+ALLTRIM(aSemaforo[_nCont][1])+"'")
					TCRefresh(RetSqlName("SZ4"))
				NEXT
				
			ENDIF
			
		NEXT nY				
	NEXT nX              
    
    IF !lContinua
    	EXIT
    ENDIF

END

ConOut("ASCTBM01 - FIM " + DTOS(DATE())+StrTran(TIME(), ":", "") +"*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.* " )	

RETURN
//-----------------------------------------------------------------------
/*{Protheus.doc} MontaTRB
@Monta arquivo de trabalho
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//
Static Function MontaTRB(pOrdem)
Local aStru := {}          
Local cOrdem := pOrdem
Aadd( aStru,{ "INVESTE"    ,  "C",09,0})
Aadd( aStru,{ "INVESTIDA"  ,  "C",09,0})
Aadd( aStru,{ "ORD"        ,  "C",03,0})
Aadd( aStru,{ "ACOES"      ,  "N",17,7})
Aadd( aStru,{ "QUOTAS"     ,  "N",17,7})
Aadd( aStru,{ "EVENTOS"    ,  "C",40,0})
Aadd( aStru,{ "CONTA"      ,  "C",TAMSX3("Z0_CONTA")[1],0})
Aadd( aStru,{ "ITEMCTA"    ,  "C",TAMSX3("Z0_ITEMCTA")[1],0})

cArqTrab := CriaTrab(aStru)

IF SELECT("TRB") <> 0
	TRB->(DBCLOSEAREA())
ENDIF

dbUseArea(.T.,,cArqTrab,"TRB",.F.,.F.)
IndRegua("TRB", cArqTrab, cOrdem ,,,,)
TRB->(DBSETORDER(1))      
RETURN
//-----------------------------------------------------------------------
/*{Protheus.doc} GravaTrb
@Grava os dados no arqui temporário
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
STATIC FUNCTION GravaTrb(pPante, pParti,pOrdem)
Local lRet := .T.
Local nReg := 0       
Local nOrd := pOrdem
Local lFound:= .F.

TRB->(DBGOTOP())
WHILE TRB->(!EOF())
	IF TRB->INVESTE == pPante .AND. TRB->INVESTIDA == pParti
		lFound := .T.
		EXIT
	ENDIF   
	TRB->(DBSKIP())
END

IF lFound
	RETURN(lRet)
ENDIF
                 
SZ2->(DBSETORDER(1))
IF SZ2->(DBSEEK(XFILIAL("SZ2")+SUBSTR(pPante,1,9)+SUBSTR(pParti,1,9)+DTOS(FirstDay(dDataRef))))
	RECLOCK("TRB",.T.)
	TRB->INVESTE   := pPante
	TRB->INVESTIDA := pParti                                             
	TRB->ORD       := STRZERO(pOrdem,3)
	TRB->ACOES     := POSICIONE("SZ0",1,XFILIAL("SZ0")+pParti,"Z0_QTACOES")
	TRB->QUOTAS    := SZ2->Z2_QUANT                                                   
	TRB->EVENTOS   := SZ2->Z2_EVENTOS 
	TRB->CONTA     := SZ0->Z0_CONTA
	TRB->ITEMCTA   := SZ0->Z0_ITEMCTA
	TRB->(MsUnlock())
ENDIF

IF SZ2->(DBSEEK(XFILIAL("SZ2")+SUBSTR(pParti,1,9))) // Verifica se a investida também possui participações
	nControl++
	IF nControl < 100 // Controle de limite de recursividade da função
		nZema++                                 
		nOrd := nZema
		WHILE SZ2->(!EOF()) .AND. ALLTRIM(SZ2->Z2_EMP) == ALLTRIM(pParti)
			nReg := SZ2->(RECNO())
			GRAVATRB(SZ2->Z2_EMP,SZ2->Z2_EMPPAR,nOrd)
			SZ2->(DBGOTO(nReg))
			SZ2->(DBSKIP())
		END	
	ELSE
		RECLOCK("TRB",.T.)
		TRB->INVESTE   := "ERRO"
		TRB->INVESTIDA := "ERRO"
		TRB->ORD   := STRZERO(pOrdem,3)
		TRB->(MsUnlock())
		lRet := .F.
	ENDIF	
ELSE
	nControl := 1	
ENDIF
RETURN(lRet)	
//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTB01E
@Executa fórmula do evento
@param:aParams{aEventosT, cSemaforo, nX}
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
User Function ASCTB01E(aParams)    
Local nPos     := aParams[3]
Local cEmpTrb  := SUBSTR(aParams[1][nPos][2],1,2)
Local cFilTrb  := SUBSTR(aParams[1][nPos][2],3,7)
Local cFormula := aParams[1][nPos][4]
Local cSemaforo:= aParams[2] 
Local cEvento  := aParams[1][nPos][3]       
Local Valor    := 0
Local lRetForm := .T.                                                           
Local cRetorno := ""
ConOut("ASCTB01E - Executa Formula - Inicio do Processamento Empresa/Filial: "+cEmpTrb+"/"+cFilTrb+" - Evento: "+cEvento)

RpcSetType( 3 )
RpcSetEnv( cEmpTrb, cFilTrb,,,'CTB')
cEmpAnt := cEmpTrb
cFilAnt := cFilTrb 

dDataBase:= aParams[4] 

BEGIN SEQUENCE
Valor := &(cFormula)
Recover
lRetForm := .F.
END SEQUENCE
IF !lRetForm
	ConOut("ASCTB01E - Ocorreu um erro de processamento, 'Erro na formula'.")
	TCSQLEXEC("UPDATE "+RetSqlName("SZ4")+" SET Z4_STATUS = 'X' WHERE Z4_SEMAF = '"+ALLTRIM(cSemaforo)+"'")	
	TCRefresh(RetSqlName("SZ4"))
ELSE
	ConOut("ASCTB01E - Valor do evento: "+STR(Valor,17,2))
	cRetorno := STR(Valor,17,2)
	TCSQLEXEC("UPDATE "+RetSqlName("SZ4")+" SET Z4_STATUS = 'B', Z4_RETORNO = '"+cRetorno+ "' WHERE Z4_SEMAF = '"+ALLTRIM(cSemaforo)+"'")		
	TCRefresh(RetSqlName("SZ4"))
ENDIF                                       
                      
RpcClearEnv()                    

RETURN
//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTB01C
@Contabiliza evento
@param:aParams{aEventosT, cSemaforo, nX}
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
User Function ASCTB01C(aParams)
Local nPos     := aParams[3]
Local cEmpTrb  := SUBSTR(aParams[1][nPos][1],1,2)
Local cFilTrb  := SUBSTR(aParams[1][nPos][1],3,7)
Local cSemaforo:= aParams[2] 
Local cEvento  := aParams[1][nPos][3]       
Local cLP      := aParams[1][nPos][6]
Local cLote	   := aParams[1][nPos][7]    
Local nQuotas  := aParams[1][nPos][10]
Local cRetorno := ""
Private CONTA  := aParams[1][nPos][8] 
Private ITEM   := aParams[1][nPos][11] 
Private VALOR  := ROUND(aParams[1][nPos][5] * (aParams[1][nPos][10] / aParams[1][nPos][9]),2)  // Aplica o percentual de equivalência    
Private STRLCTPAD := aParams[1][nPos][2] // Empresa investida, para utilizar no histórico do LP
Private cArquivo := ""
Private nTotal := 0                                               

ConOut("ASCTB01C - Contabiliza na investidora - Inicio do Processamento Empresa/Filial: "+cEmpTrb+"/"+cFilTrb+" - Evento: "+cEvento)

RpcSetType( 3 )
RpcSetEnv( cEmpTrb, cFilTrb,,,'CTB')
cEmpAnt := cEmpTrb
cFilAnt := cFilTrb 

dDataBase:= aParams[4] 
	
ConOut("ASCTB01C - Chamada do HeadProva."+cEmpAnt+"/"+cFilAnt)	
	  
nHdlPrv := HeadProva( cLote,"ASCTB01C",Substr(cUsuario,7,6),@cArquivo )
If nHdlPrv < 0                              
	ConOut("ASCTB01C - Erro na criação do arquivo de contra prova!")		
	TCSQLEXEC("UPDATE "+RetSqlName("SZ4")+" SET Z4_STATUS = 'X' WHERE Z4_SEMAF = '"+ALLTRIM(cSemaforo)+"'")		
	TCRefresh(RetSqlName("SZ4"))
ELSE		
	HISTORICO := "EQUIVALÊNCIA PATRIMONIAL EMPRESA: "+ALLTRIM(POSICIONE("SZ0",1,XFILIAL("SZ0")+STRLCTPAD,"Z0_RAZAO")) + ", REF.: "+ALLTRIM(STRTRAN(STR(nQuotas,17,7),".",",")) + " Quotas."
	nTotal := DetProva(nHdlPrv,cLP,"ASCTB01C",cLote)
	ConOut("ASCTB01C - Saida do DetProva.")				
	RodaProva(nHdlPrv,nTotal)
	cA100Incl(cArquivo,nHdlPrv,3,cLote,.F.,.F.,,dDataBase)
	cRetorno := CT2->(DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC)
	TCSQLEXEC("UPDATE "+RetSqlName("SZ4")+" SET Z4_STATUS = 'B', Z4_RETORNO = '"+cRetorno+"' WHERE Z4_SEMAF = '"+ALLTRIM(cSemaforo)+"'")		    
	TCRefresh(RetSqlName("SZ4"))
ENDIF	
RpcClearEnv()                    
ConOut("Fim ASCTB01C.")                                                                                                                                
Return