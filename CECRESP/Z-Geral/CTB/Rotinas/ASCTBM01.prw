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
Local bOk       	:= {|| (lOk := .T., oDlg:End() )} 
Local bCancel   	:= {|| (lOk	:= .F., oDlg:End()) }                  
Local lOK 		:= .T.
Private nOpLan  := 1                                                   
Private dDataRef:= LastDay(dDataBase)        
Private cInveste:= SPACE(09)
Private cDescIn := SPACE(LEN(SZ0->Z0_RAZAO))
Private cRevSZ0    := "000"
Private dRefSZ2    := FirstDay(dDataRef)
Private cRevisao   := "000"  // Utilizado no filtro da pesquisa
Private oGet1
Private oGet2
Static oDlg
                
// Localiza a ultima revisão da SZ0         
cQ := "SELECT Z0_REVISAO, Z0_DTREVIS FROM "+RetSqlName("SZ0")+" WHERE 
cQ += " Z0_DTREVIS <= '"+DTOS(dDataBase)+"' AND D_E_L_E_T_ = ' '"
cQ += " ORDER BY Z0_REVISAO DESC"
TcQuery ChangeQuery(cQ) ALIAS "XSZ0" NEW
IF !EMPTY(XSZ0->Z0_REVISAO)
	cRevSZ0  := XSZ0->Z0_REVISAO
	cRevisao := XSZ0->Z0_REVISAO
ENDIF
XSZ0->(DBCLOSEAREA())

DEFINE MSDIALOG oDlg TITLE "EMPRESA INVESTIDORA" FROM 000, 000  TO 200, 500 COLORS 0, 16777215 PIXEL

    @ 040, 022 MSGET oGet1 VAR cInveste  F3 "SZ0" VALID _VEREMP() SIZE 083, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 054, 022 MSGET oGet2 VAR cDescIn   WHEN .F. SIZE 186, 010 OF oDlg COLORS 0, 16777215 PIXEL
                                                
ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, bOk, bCancel)
              
IF !lOK
	RETURN
ENDIF              
               
Aadd(aSays, OemToAnsi("Esta rotina gera a contabilização dos eventos relacionados no cadastro de"))
Aadd(aSays, OemToAnsi("estrutura de participação da empresa: "))
Aadd(aSays, OemToAnsi(ALLTRIM(cDescIn)))
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
	cQ += " AND Z3_EMP = '"+cInveste+"' "
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
            
/*
Valida a empresa investidora

*/
STATIC FUNCTION _VEREMP
Local lRet		:= .T.
Local aArea     := GETAREA()

                 
cQ := "SELECT Z0_RAZAO  RAZAO FROM "+RetSqlName("SZ0")+" WHERE Z0_EMPRESA = '"+cInveste+"' AND Z0_REVISAO = '"+cRevSZ0+"' AND D_E_L_E_T_ = ' '"
TcQuery ChangeQuery(cQ) ALIAS "XSZ0" NEW
IF !EMPTY(XSZ0->RAZAO)
	cDescIn := XSZ0->RAZAO
ENDIF
XSZ0->(DBCLOSEAREA())

cQ := "SELECT MAX(Z2_DTBASE) DTBASE FROM "+RetSqlName("SZ2")+" WHERE Z2_EMP = '"+cInveste+"' AND Z2_DTBASE <= '"+DTOS(dDataRef)+"' AND D_E_L_E_T_ = ' '"
TcQuery ChangeQuery(cQ) ALIAS "XSZ2" NEW
dRefSZ2 := XSZ2->DTBASE
XSZ2->(DBCLOSEAREA())

// Verifica se existe a empresa

cQ := "SELECT Z2_EMP INVESTE FROM "+RetSqlName("SZ2")
cQ += " WHERE Z2_EMP = '"+cInveste+"' "
cQ += " AND Z2_DTBASE = '"+dRefSZ2+"'"
cQ += " AND D_E_L_E_T_ = ' '"
TcQuery ChangeQuery(cQ) ALIAS "XSZ2" NEW

IF EMPTY(XSZ2->INVESTE)
	ApMsgAlert("Empresa não cadastrada!")
	lRet := .F.
	cDescIn := SPACE(LEN(SZ0->Z0_RAZAO))
ENDIF

XSZ2->(DBCLOSEAREA())     

oGet2:Refresh()

RestArea(aArea)

RETURN(lRet)

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
Local aEventos   := {} // Matriz dos eventos da Investidora com as investidas
Local aEventosT  := {} // Matriz de eventos com a investida
Local aLisEven	 := {} // Matriz com a lista de eventos
Local nA		 := 0
Local nX         := 0
Local nY		 := 0
Local cQ         := ""                 
Local nReg    	 := 0
Local aTrb       := {} // Matriz da investidora com as investidas
Local Valor      := 0
Local ChaveCt2   := ""                 
Local nRegSZ3	 := 0                                                    

IF EMPTY(dRefSZ2)
	ApMsgAlert("Não localizado registros de equivalência.")
	RETURN
ENDIF

MontaTRB() 

cQ := "SELECT Z2_EMP, Z2_EMPPAR, Z2_QUANT, Z2_EVENTOS "
cQ += " FROM "+RetSqlName("SZ2")+" SZ2 "   
cQ += " WHERE Z2_FILIAL = '"+XFILIAL("SZ2")+"' AND Z2_DTBASE = '"+dRefSZ2+"' AND Z2_EMP = '"+cInveste+"' AND D_E_L_E_T_ = ' '"
cQ += " ORDER BY Z2_EMP, Z2_EMPPAR "
TcQuery ChangeQuery(cQ) ALIAS "XSZ2" NEW
                                            
WHILE XSZ2->(!EOF()) 
	RECLOCK("TRB",.T.)
	TRB->INVESTE   	:= XSZ2->Z2_EMP
	TRB->INVESTIDA 	:= XSZ2->Z2_EMPPAR
	TRB->ACOES     	:= POSICIONE("SZ0",1,XFILIAL("SZ0")+cRevSZ0+XSZ2->Z2_EMPPAR,"Z0_QTACOES")
	TRB->QUOTAS    	:= XSZ2->Z2_QUANT                                                   
	TRB->EVENTOS   	:= XSZ2->Z2_EVENTOS 
	TRB->CONTA		:= SZ0->Z0_CONTA
	TRB->CTPASS 	:= SZ0->Z0_CTPASS
	TRB->CTMEPRP	:= SZ0->Z0_CTMEPRP
	TRB->CTMEPRN	:= SZ0->Z0_CTMEPRN
	TRB->CTRESN		:= SZ0->Z0_CTRESN
	TRB->ITEMCTA    := SZ0->Z0_ITEMCTA
	TRB->MOEDA	    := POSICIONE("SZ0",1,XFILIAL("SZ0")+cRevSZ0+XSZ2->Z2_EMP,"Z0_MOEDA")	
	TRB->(MsUnlock())
	
	XSZ2->(DBSKIP())
END
XSZ2->(DBCLOSEAREA())   

              
// Processa registros
TRB->(DBGOTOP())
lContinua := .T.

// Monto Array do TRB, porque as rotinas chamadas do padrão podem utilizar o mesmo ALIAS
   
WHILE TRB->(!EOF())         
	AADD(aTrb,{TRB->INVESTE,;			// 1 - INVESTIDORA
			   TRB->INVESTIDA,;			// 2 - INVESTIDA
			   TRB->ACOES,;				// 3 - QUANTIDADE DE AÇÕES
			   TRB->QUOTAS,;			// 4 - QUANTIDADE DE QUOTAS
			   TRB->EVENTOS,;			// 5 - EVENTOS
			   TRB->CONTA,;				// 6 - CONTA DE INVESTIMENTO do Ativo
			   TRB->CTPASS,;			// 7 - CONTA DE INVESTIMENTO do Passivo
			   TRB->CTMEPRP,;			// 8 - CONTA DO MEP Resultado Positivo
			   TRB->CTMEPRN,;			// 9 - CONTA DO MEP Resultado Negativo
			   TRB->CTRESN,;			// 10- CONTA DE RESULTADO NACIONAL
			   "",;						// 11- CONTA DE RESULTADO NACIONAL			   
			   TRB->ITEMCTA,;			// 12- ITEM CONTÁBIL
			   TRB->MOEDA})				// 13- MOEDA			   
	nReg++
	TRB->(DBSKIP())
END    

TRB->(DBCLOSEAREA())                    

PROCREGUA(nReg)

ConOut("ASCTBM01 - INICIO  " + DTOS(DATE())+StrTran(TIME(), ":", "") + " *.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*"  )				                       

SZ1->(DBSETORDER(1))
                    
lContinua := .T.

// Processa todas as investidas
nA := 1
WHILE nA <= LEN(aTrb)
	IncProc()

    aLisEven := STRTOKARR(ALLTRIM(aTrb[nA][5]),"#")  // Matriz com a lista dos eventos
    
	// Gero a Matriz de Eventos com a investida

    aEventosT:={}
	FOR nX := 1 TO LEN(aLisEven)
		IF SZ1->(DBSEEK(XFILIAL("SZ1")+aLisEven[nX])) 			
			AADD(aEventosT,{aTrb[nA][1],; 	 // 1- Empresa Investidora
							aTrb[nA][2],;    // 2- Empresa Investida
							aLisEven[nX],; 	 // 3- Código do evento
							SZ1->Z1_FORMULA,;// 4- Fórmula do valor
							0,;              // 5- Valor resultado da formula
							SZ1->Z1_LP,; 	 // 6- Lançamento Padrão  
							SZ1->Z1_LOTE,;   // 7- Lote
							aTrb[nA][3],; 	 // 8- Acoes
							aTrb[nA][4],;	 // 9- Quotas 
							aTrb[nA][6],;    //10- Conta investimento do ativo
							aTrb[nA][7],;    //11- Conta investimento do passivo
							aTrb[nA][8],;    //12- Conta do MEP resultado positivo
							aTrb[nA][9],;    //13- Conta do MEP resultado negativo
							aTrb[nA][10],;   //14- Conta do resultado nacional
							aTrb[nA][11],;   //15- Conta do resultado estrangeiro
							aTrb[nA][12],;   //16- Item Contábil
							cRevSZ0,;    	 //17- Revisao do SZ0
							dRefSZ2,;   	 //18- Data de referencia da SZ2
							aTrb[nA][13],;   //19- Moeda
							})                              
		ENDIF
		
	NEXT nX
       
	// Executo as formulas dos eventos para obter os valores

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
		aAdd(aParams, aEventosT[nX])
		aAdd(aParams, cSemaforo)
		aAdd(aParams, dDataRef)						
                
//		StartJob('U_ASCTB01E', GetEnvServer(), .F., aParams) 
		U_ASCTB01E(aParams) 
				     
		MsAguarde( { || U_ASCTBA09(aSemaforo) }, "Aguardando evento: "+aEventosT[nX][2]+"/"+aEventosT[nX][3])				   
				
		IF aSemaforo[LEN(aSemaforo)][2] $ "A/X"            
			MSGALERT("Falha na execução da formula"+aEventosT[nX][4]+" do evento: "+aEventosT[nX][3])				
			lContinua := .F.
		ENDIF
        
		IF lContinua        
            
			cQ := "SELECT Z4_RETORNO FROM "+RetSqlName("SZ4")+" WHERE Z4_SEMAF = '"+cSemaforo+"'"
			TcQuery ChangeQuery(cQ) ALIAS "XSZ4" NEW
				        
			Valor	:= ROUND(VAL(ALLTRIM(XSZ4->Z4_RETORNO))/100,2)
			XSZ4->(dbCloseArea())    

			aEventosT[nX][5] :=  Valor

		ENDIF
		
		// limpa semaforo

		FOR _nCont := 1 TO LEN(aSemaforo)
			TCSQLEXEC("DELETE FROM "+RetSqlName("SZ4")+" WHERE Z4_SEMAF = '"+ALLTRIM(aSemaforo[_nCont][1])+"'")
			TCRefresh(RetSqlName("SZ4"))	
		NEXT
		
		IF !lContinua
			EXIT
		ENDIF		 

	NEXT nX
    	
    AADD(aEventos,aEventosT)
  		
  	nA++      
  	IF nA > LEN(aTrb) .OR. !lContinua
  		EXIT
  	ENDIF
  	
END  	
  	
IF lContinua 
	           
	PROCREGUA(LEN(aEventos))
	
	// Na empresa investidora, efetuo a contabilização dos eventos
	FOR nX := 1 TO LEN(aEventos)  
		IncProc()
		FOR nY := 1 TO LEN(aEventos[nX])
			IF ABS(aEventos[nX][nY][5]) > 0  // Possui valor a contabilizar
				cSemaforo := "EQV_C"+ALLTRIM(aEventos[nX][nY][1])+ALLTRIM(aEventos[nX][nY][2])+ALLTRIM(aEventos[nX][nY][3])+DTOS(DATE())+StrTran(TIME(), ":", "")
				aSemaforo := {}
				AADD(aSemaforo,{cSemaforo,"A"})				

				RECLOCK("SZ4",.T.)
				SZ4->Z4_FILIAL := XFILIAL("SZ4")
				SZ4->Z4_SEMAF  := cSemaforo
				SZ4->Z4_STATUS := "A"
				MsUnlock()

			    RECLOCK("SZ3",.T.)
			    SZ3->Z3_FILIAL := XFILIAL("SZ3")
			    SZ3->Z3_DTBASE := dDataRef
			    SZ3->Z3_EMP	   := aEventos[nX][nY][1]
			    SZ3->Z3_EMPPAR := aEventos[nX][nY][2]
			    SZ3->Z3_EVENTO := aEventos[nX][nY][3]
			    SZ3->Z3_FORMULA:= aEventos[nX][nY][4]			    
			    SZ3->Z3_VALOR  := aEventos[nX][nY][5]      
			    SZ3->Z3_LP	   := aEventos[nX][nY][6]      
			    SZ3->Z3_LOTE   := aEventos[nX][nY][7]      			    
			    SZ3->Z3_ACOES  := aEventos[nX][nY][8]
			    SZ3->Z3_QUOTAS := aEventos[nX][nY][9]			    
			    SZ3->Z3_CONTA  := aEventos[nX][nY][10]			    			    
			    SZ3->Z3_CTPASS := aEventos[nX][nY][11]			    			    
			    SZ3->Z3_CTMEPRP:= aEventos[nX][nY][12]			    
			    SZ3->Z3_CTMEPRN:= aEventos[nX][nY][13]			    			    
			    SZ3->Z3_CTRESN := aEventos[nX][nY][14]			    			    			    
			    SZ3->Z3_ITEMCTA:= aEventos[nX][nY][16]			    			    			    
			    SZ3->Z3_REVSZ0 := aEventos[nX][nY][17]
			    SZ3->Z3_REFSZ2 := aEventos[nX][nY][18]	
			    SZ3->Z3_MOEDA  := aEventos[nX][nY][19]				    
			    SZ3->Z3_VALCTB := ABS(ROUND(aEventos[nX][nY][5] * (aEventos[nX][nY][9] / aEventos[nX][nY][8]),2))  // Valor do lançamento - aplica o percentual de equivalência    
           		MsUnlock()

             	nRegSZ3 := SZ3->(RECNO())

				aParams := {}                                                          
				aAdd(aParams, nRegSZ3)
				aAdd(aParams, cSemaforo)
				aAdd(aParams, aEventos[nX][nY][1])
					                                             
//				StartJob('U_ASCTB01C', GetEnvServer(), .F., aParams) 					
				U_ASCTB01C(aParams) 					

				MsAguarde( { || U_ASCTBA09(aSemaforo) }, "Aguardando contabilização do evento "+aEventos[nX][nY][2]+"/"+aEventos[nX][nY][3])				   
				
				IF aSemaforo[LEN(aSemaforo)][2] $ "A/X"            
					MSGALERT("Falha na contabilização da formula"+aEventos[nX][nY][4]+" do evento: "+aEventos[nX][nY][3])				
					lContinua := .F. 
				ENDIF
		
				SZ3->(DBGOTO(nRegSZ3))
			    RECLOCK("SZ3",.F.)
				
				IF lContinua

					cQ := "SELECT Z4_RETORNO FROM "+RetSqlName("SZ4")+" WHERE Z4_SEMAF = '"+cSemaforo+"'"
					TcQuery ChangeQuery(cQ) ALIAS "XSZ4" NEW
				        
					ChaveCt2 := ALLTRIM(XSZ4->Z4_RETORNO)
					XSZ4->(dbCloseArea())

				    SZ3->Z3_CT2    := ChaveCt2
				    SZ3->Z3_STATUS := "ATIVO"
				ELSE
				    SZ3->Z3_STATUS := "FALHA"	
				ENDIF
			    MsUNlock()    			    

		  		// limpa semaforo
				FOR _nCont := 1 TO LEN(aSemaforo)
					TCSQLEXEC("DELETE FROM "+RetSqlName("SZ4")+" WHERE Z4_SEMAF = '"+ALLTRIM(aSemaforo[_nCont][1])+"'")
					TCRefresh(RetSqlName("SZ4"))
				NEXT
				
			ENDIF
			
			IF !lContinua
				EXIT
			ENDIF
			
		NEXT nY				

		IF !lContinua
			EXIT
		ENDIF
		
	NEXT nX              

ENDIF

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
Static Function MontaTRB
Local aStru := {}          
Aadd( aStru,{ "INVESTE"    ,  "C",09,0})
Aadd( aStru,{ "INVESTIDA"  ,  "C",09,0})
Aadd( aStru,{ "ACOES"      ,  "N",17,7})
Aadd( aStru,{ "QUOTAS"     ,  "N",17,7})
Aadd( aStru,{ "EVENTOS"    ,  "C",200,0})
Aadd( aStru,{ "CONTA"      ,  "C",TAMSX3("Z0_CONTA")[1],0})
Aadd( aStru,{ "CTPASS"     ,  "C",TAMSX3("Z0_CTPASS")[1],0})
Aadd( aStru,{ "CTMEPRP"    ,  "C",TAMSX3("Z0_CTMEPRP")[1],0})
Aadd( aStru,{ "CTMEPRN"    ,  "C",TAMSX3("Z0_CTMEPRN")[1],0})
Aadd( aStru,{ "CTRESN"     ,  "C",TAMSX3("Z0_CTRESN")[1],0})
Aadd( aStru,{ "ITEMCTA"    ,  "C",TAMSX3("Z0_ITEMCTA")[1],0})       
Aadd( aStru,{ "MOEDA"     ,  "C",TAMSX3("Z0_MOEDA")[1],0})       

cArqTrab := CriaTrab(aStru)

IF SELECT("TRB") <> 0
	TRB->(DBCLOSEAREA())
ENDIF

dbUseArea(.T.,,cArqTrab,"TRB",.F.,.F.)

RETURN
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
Local cEmpTrb  := SUBSTR(aParams[1][2],1,2)
Local cFilTrb  := SUBSTR(aParams[1][2],3,7)
Local cFormula := aParams[1][4]
Local cSemaforo:= aParams[2] 
Local cEvento  := aParams[1][3]       
Local Valor    := 0
Local lRetForm := .T.                                                           
Local cRetorno := ""
Local cEmpOld := cEmpAnt
Local cFilOld := cFilAnt
PRIVATE CMOEDA := aParams[1][19]

ConOut("ASCTB01E - Executa Formula - Inicio do Processamento Empresa/Filial: "+cEmpTrb+"/"+cFilTrb+" - Evento: "+cEvento)

//RpcSetType( 3 )
//RpcSetEnv( cEmpTrb, cFilTrb,,,'CTB')
cEmpAnt := cEmpTrb
cFilAnt := cFilTrb 

dDataBase:= aParams[3] 

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
	cRetorno := ALLTRIM(STR(Valor*100))
	TCSQLEXEC("UPDATE "+RetSqlName("SZ4")+" SET Z4_STATUS = 'B', Z4_RETORNO = '"+cRetorno+ "' WHERE Z4_SEMAF = '"+ALLTRIM(cSemaforo)+"'")		
	TCRefresh(RetSqlName("SZ4"))
ENDIF                                       
                      
//RpcClearEnv()                    
cEmpAnt := cEmpOld
cFilAnt := cFilOld


RETURN
//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTB01C
@Contabiliza evento
@param:aParams{nRegSZ3, cSemaforo}
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
User Function ASCTB01C(aParams)
Local cEmpTrb	:= SUBSTR(aParams[3],1,2)
Local cFilTrb	:= SUBSTR(aParams[3],3,7)
Local cSemaforo	:= aParams[2]
Local cRetorno	:= ""                                                                 
Local nRegSZ3	:= aParams[1]
Local nVal1		:= 0  
Local cGrpPL	:= ""
Local cEmpOld := cEmpAnt
Local cFilOld := cFilAnt    
Private cArquivo:= ""
Private nTotal 	:= 0                                               

//RpcSetType( 3 )
//RpcSetEnv( cEmpTrb, cFilTrb,,,'CTB')
cEmpAnt := cEmpTrb
cFilAnt := cFilTrb 

cGrpPL := ALLTRIM(GETNEWPAR("AS_GRUPL","203"))
                  
DBSELECTAREA("SZ3")
DBGOTO(nRegSZ3)

dDataBase:= SZ3->Z3_DTBASE 

RECLOCK("SZ3",.F.)

                                                        
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//* MovConta, MovItem                                 ³
//³ Retorno:                                          ³
//³ [1] Movimento Devedor                             ³
//³ [2] Movimento Credor                              ³
//³ [3] Movimento do Mes                              ³
//³ [4] Saldo Final                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Investimento Ativo
nVal := MovItem(SZ3->Z3_CONTA,"",SZ3->Z3_ITEMCTA,FirstDay(dDataBase),LastDay(dDataBase),SZ3->Z3_MOEDA,"1",4)
SZ3->Z3_VALINVA := nVal
                     
// Investimento Passivo
nVal := MovItem(SZ3->Z3_CTPASS,"",SZ3->Z3_ITEMCTA,FirstDay(dDataBase),LastDay(dDataBase),SZ3->Z3_MOEDA,"1",4)
SZ3->Z3_VALINVP := nVal

// Saldo do Grupo do PL Mês anterior
nVal := APUR(SZ3->Z3_EMPPAR, cGrpPL, "1", SZ3->Z3_MOEDA, FirstDay(dDataBase)-1)
SZ3->Z3_VPLANT := nVal

// Saldo do Grupo do PL Mês mês atual
nVal := APUR(SZ3->Z3_EMPPAR, cGrpPL, "1", SZ3->Z3_MOEDA, LastDay(dDataBase))
SZ3->Z3_VPLATU := nVal

// Ajusta o valor contábil, caso o PL tenha virado  
//IF SZ3->Z3_VPLATU>0  .AND. SZ3->Z3_VPLANT <= 0
//	SZ3->Z3_VALCTB := SZ3->Z3_VALCTB - ABS(SZ3->Z3_VALINVA)
//ELSEIF 	SZ3->Z3_VPLATU<=0  .AND. SZ3->Z3_VPLANT > 0
//	SZ3->Z3_VALCTB := SZ3->Z3_VALCTB - ABS(SZ3->Z3_VALINVP)
//ENDIF	

MsUnlock()
	
ConOut("ASCTB01C - Chamada do HeadProva."+cEmpAnt+"/"+cFilAnt)	
	  
nHdlPrv := HeadProva( SZ3->Z3_LOTE,"ASCTB01C",Substr(cUsuario,7,6),@cArquivo )
If nHdlPrv < 0                              
	//ConOut("ASCTB01C - Erro na criação do arquivo de contra prova!")
	Alert("ASCTB01C - Erro na criação do arquivo de contra prova!")		
	TCSQLEXEC("UPDATE "+RetSqlName("SZ4")+" SET Z4_STATUS = 'X' WHERE Z4_SEMAF = '"+ALLTRIM(cSemaforo)+"'")		
	TCRefresh(RetSqlName("SZ4"))
ELSE		                                          
//	HISTORICO := "EQUIVALÊNCIA PATRIMONIAL EMPRESA: "+ALLTRIM(POSICIONE("SZ0",1,XFILIAL("SZ0")+cRevisao+STRLCTPAD,"Z0_RAZAO")) + ", REF.: "+ALLTRIM(STRTRAN(STR(nQuotas,17,7),".",",")) + " Quotas."
	nTotal := DetProva(nHdlPrv,SZ3->Z3_LP,"ASCTB01C",SZ3->Z3_LOTE)
	ConOut("ASCTB01C - Saida do DetProva.")				
	RodaProva(nHdlPrv,nTotal)
	cA100Incl(cArquivo,nHdlPrv,3,SZ3->Z3_LOTE,.F.,.F.,,dDataBase)
	cRetorno := CT2->(CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC)
	TCSQLEXEC("UPDATE "+RetSqlName("SZ4")+" SET Z4_STATUS = 'B', Z4_RETORNO = '"+cRetorno+"' WHERE Z4_SEMAF = '"+ALLTRIM(cSemaforo)+"'")		    
	TCRefresh(RetSqlName("SZ4"))
ENDIF	
//RpcClearEnv()                    
cEmpAnt := cEmpOld
cFilAnt := cFilOld
ConOut("Fim ASCTB01C.")                                                                                                                                
Return
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
Static Function APUR(pEmpresa, pGrpCon, pTpSld, pMoeda, pData)
Local cProc		:= 'POPUTRB_'+CriaTrab(nil,.F.)                            
Local cSQL      := ""
Local aResult   := {}
Local cGrpEmp	:= SUBSTR(pEmpresa,1,2)
Local cEmpresa  := SUBSTR(RIGHT(pEmpresa,TAMSX3("CQ4_FILIAL")[1]),1,LEN(ALLTRIM(XFILIAL("CT2"))))
Local cGrpCon   := ALLTRIM(pGrpCon)
Local cTpSld	:= pTpSld
Local cMoeda    := pMoeda
Local cData     := DTOS(pData)
Local cTabCQ0 	:= U_RtTab("CQ0",cGrpEmp)       
Local nValAp    := 0                     
Local cTamGRP   := ALLTRIM(STR(LEN(ALLTRIM(cGrpCon))))
Local cNatGrp   := POSICIONE("CT1",1,XFILIAL("CT1")+cGrpCon,"CT1_NORMAL")
Local lRet		:= .T.

cSQL:="create procedure "+cProc+" (@OUT_RET int output) as"+CRLF
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
cSQL += "         and CQ0_MOEDA= '"+cMoeda+"' and CQ0_TPSALD = '"+cTpSld+"' and CQ0_DATA <= '"+cData+"' and D_E_L_E_T_ = ' '"+CRLF

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

MemoWrite("APURA.SQL",cSQL)	     		
		
// Ajusta a expressão para o Banco de Dados
cSQL:=MsParse(cSQL,Alltrim(TcGetDB()))
                                            
IF EMPTY(cSQL)                                                                      
	ApMsgAlert("Erro ao criar a stored procedure - PARSE.")
	lRet := .F.
ELSE                                  
	MemoWrite("APURP.SQL",cSQL)	
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
