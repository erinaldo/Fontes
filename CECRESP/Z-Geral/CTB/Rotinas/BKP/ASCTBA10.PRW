#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'                                                    
//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTBA10
@Processa os lanÁamentos de eliminaÁ„o
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
Private xEtapa 		:= aEmpOri[1][13]
Private cSemaforo	:= _aParams[5]
Private dDataIni	:= _aParams[3]
Private dDataFim	:= _aParams[4]
Private aRelacaoA 	:= {} // Contas de Partes Relacionadas do Ativo
Private aRelacaoP 	:= {} // Contas de Partes Relacionadas do Passivo                
Private aEstruNiv	:= {}
Private lSub 		:= .T.
PRIVATE nNiv 		:= 1                      
PRIVATE aTiposEli   := {}
PRIVATE cTipoSld	:= aEmpOri[1][6]

// Preparo o ambiente para cosolidadora atual, que ir· receber os lanÁamentos
RpcSetType( 3 )
RpcSetEnv( aEmpOri[1][9], aEmpOri[1][8],,,'CTB')

dDataBase   := dDataFim  // Atualiza database

ProcLogIni( {},"ASCTBA10")
ProcLogAtu("MENSAGEM",OemToAnsi("Inicio das eliminaÁıes."),"","ASCTBA10") 
ProcLogAtu("MENSAGEM",OemToAnsi("Monta nÌveis da estrutura."),"","ASCTBA10") 

aSort(aEmpOri,,,{|x,y| x[11] < y[11] })
FOR nX := 1 TO LEN(aEmpOri)
	lSub := .T.
	ATUNIV(1, aEmpOri[nX][11],  aEmpOri[nX][7],  aEmpOri[nX][8], aEmpOri[nX][9]+aEmpOri[nX][8], aEmpOri[nX][9]+aEmpOri[nX][8], aEmpOri[nX][11], aEmpOri[nX][11], aEmpori[nX][12])
NEXT	   
aSort(aEstruNiv,,,{|x,y| x[1] < y[1] })

// VERIFICA OS TIPOS DE ELIMINA«’ES ENTRE ATIVO E PASSIVO
cQ := "SELECT CT1_XTPELI FROM "+RetSqlName("CT1")
cQ += " WHERE CT1_XTPELI <> ' '"
cQ += " AND D_E_L_E_T_ = ' '"          
cQ += " GROUP BY CT1_XTPELI "
TcQuery ChangeQuery(cQ) ALIAS "XCT1" NEW

WHILE XCT1->(!EOF())
	AADD(aTiposEli,XCT1->CT1_XTPELI)
	XCT1->(DBSKIP())
END
XCT1->(DBCLOSEAREA())

conout(cq)
conout(str(len(atiposeli)))


// PROCESSA A ELIMINA«√O DAS CONTAS PARA CADA TIPO
FOR nX := 1 TO LEN(aTiposEli)
            
   aRelacaoA := {}
   aRelacaoP := {}
   
	// SELECIONA CONTAS DO PLANO DE CONTAS A ELIMINAR PARA O TIPO SELECIONADO
	cQ := "SELECT CT1_CONTA, CT1_XCTPR FROM "+RetSqlName("CT1")
	cQ += " WHERE CT1_XTPELI = '"+aTiposEli[nX]+"' AND CT1_CLASSE = '2'"
	cQ += " AND D_E_L_E_T_ = ' '"          
	cQ += " ORDER BY CT1_CONTA "
	TcQuery ChangeQuery(cQ) ALIAS "XCT1" NEW
	WHILE XCT1->(!EOF())
		IF SUBSTR(XCT1->CT1_CONTA,1,1) == "1"                     
			AADD(aRelacaoA,ALLTRIM(XCT1->CT1_CONTA))  
			AADD(aRelacaoP,ALLTRIM(XCT1->CT1_XCTPR))
		ENDIF	
		XCT1->(DBSKIP())
	END
	XCT1->(DBCLOSEAREA())  
	
	conout(str(len(aRelacaoA)))

    lContinua := ELIPARTES()
    
    IF !lContinua
    	EXIT
    ENDIF

NEXT                  

IF lContinua
	lContinua := ELIPL()
ENDIF

IF !lContinua         
	TCSQLEXEC("UPDATE "+RetSqlName("SZ4")+" SET Z4_STATUS = 'X' WHERE Z4_SEMAF = '"+ALLTRIM(cSemaforo)+"'")
ELSE
	TCSQLEXEC("UPDATE "+RetSqlName("SZ4")+" SET Z4_STATUS = 'B' WHERE Z4_SEMAF = '"+ALLTRIM(cSemaforo)+"'")
ENDIF                                                       

RpcClearEnv()

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

// Verifico se a empresa que estou consolidando tambÈm consolida, portanto possui estrutura, se tiver carrega os sub-niveis
cQ := "SELECT Z6_CODIGO, Z6_EMP FROM "+RetSqlName("SZ6")
cQ += " WHERE Z6_EMP = '"+pConsEmp+"' AND D_E_L_E_T_ = ' '"
TcQuery ChangeQuery(cQ) ALIAS "XSZ6" NEW

IF XSZ6->(!EOF())
	cChaveSZ6 := XSZ6->Z6_CODIGO+XSZ6->Z6_EMP
ELSE
	cChaveSZ6 := ""
ENDIF

XSZ6->(DBCLOSEAREA())

IF !EMPTY(cChaveSZ6)  // Econtrou estrutura para empresa consolidadora
	SZ6->(DBSETORDER(1))
	IF SZ6->(DBSEEK(XFILIAL("SZ6")+cChaveSZ6)) 
		IF lSub  // Identifica que est· processando sub-niveis
		    nNiv++
		    lSub := .F.
			pEmpPar := SZ6->Z6_EMPPAR
		ENDIF    
		WHILE SZ6->(!EOF()) .AND. SZ6->Z6_CODIGO+SZ6->Z6_EMP == cChaveSZ6
			nReg := SZ6->(RECNO())   

			// Chamada recursiva da atualizaÁ„o da estrutura de niveis
  		  	ATUNIV(nNiv, SZ6->Z6_EMPCONS, pPercCons, SUBSTR(SZ6->Z6_EMP,3,7), SZ6->Z6_EMP, pEmpPrim, pEmpPar, pConsOri, pParEst)

  		  	SZ6->(DBGOTO(nReg))
  		  	SZ6->(DBSKIP())
	  	END
	ENDIF
ELSE      
	AADD(aEstruNiv,{nNiv,;              //1 - Nivel da estrutura 
		 			pConsEmp  ,;      	//2 - Empresa consolidante  - grupo/empresa/unidade/filial 
		 			pPercCons ,;        //3 - Percentual de consolidaÁ„o 
					pDoraEmp  ,;        //4 - Empresa consolidadora - empresa/unidade/filial 
					pDoraComp ,;   		//5 - Codigo completo da consolidadora - grupo/empresa/unidade/filial
					pEmpPrim  ,;        //6 - Empresa principal da estrutura 
					pEmpPar   ,;        //7 - Empresa participante da estrutura 
					pConsOri,;          //8
					pParEst})           //9
ENDIF	

/*
001/010160001/100,00/0010001/500010001/500010001/010160001/010160001/010010001
001/019970001/100,00/0010001/500010001/500010001/019970001/019970001/010010001
001/010150001/100,00/0010001/500010001/500010001/010150001/010150001/010010001
001/010010001/100,00/0010001/500010001/500010001/010010001/010010001/010010001
001/010010002/100,00/0010001/500010001/500010001/010010002/010010002/010010001
*/


RETURN
//-----------------------------------------------------------------------
/*{Protheus.doc} ELIPARTES
@EliminaÁ„o de Partes Relacionadas Ativo x Passivo
@param		
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------
Static Function ELIPARTES
Local nA 			:= 1
Local nP 			:= 1 
Local aEli1			:= {}     
Local cQ			:= ""
Local cLote			:= "ELIMIN"
Local ItemCtaA		:= ""
Local ItemCtaB		:= ""
Local ContaA		:= ""
Local ContaP		:= ""
Local nNivAtu		:= 0
Local nY			:= 0
Local nX			:= 0
Private VALOR       := 0
Private CREDITO		:= ""
Private DEBITO		:= ""
Private ITEMD		:= ""
Private ITEMC		:= ""
Private ORIGEM		:= ""
Private HISTORICO 	:= ""   

//CONOUT("Quantidade de contas: "+STR(LEN(aRelacaoA)))

FOR nA := 1 TO LEN(aRelacaoA)                            
	nP := nA
	ContaA      := aRelacaoA[nA]
	ContaP      := aRelacaoP[nP]
	lContinua   := .T.  
	aELi1       := {}        
	lHDL 		:= .F.     
	nVlTot  	:= 0
	nHdlPrv     := 0
	cArquivo    := ""
	aFlagCTB    := {}                                                                            
	ItemCtaA    := ""
	ItemCtaB    := ""	


//	CONOUT("Estrutura de EliminaÁ„o: ")
//	FOR nX:= 1 TO LEN(aEstruNiv)
//		CONOUT(STRZERO(aEstruNiv[nX][1],3)+"/"+aEstruNiv[nX][2]+"/"+STR(aEstruNiv[nX][3],5,2)+"/"+aEstruNiv[nX][4]+"/"+aEstruNiv[nX][5]+"/"+aEstruNiv[nX][6]+"/"+aEstruNiv[nX][7]+"/"+aEstruNiv[nX][8]+"/"+aEstruNiv[nX][9])
//	NEXT
	                 
	ProcLogAtu("MENSAGEM",OemToAnsi("Inicio - Eliminacoes partes relacionadas"),"","ELIPARTES") 
	FOR nX := 1 TO LEN(aEstruNiv)            
    	nNivAtu := aEstruNiv[nX][1]                                  
    	cEmpAtu := aEstruNiv[nX][2] // Empresa a eliminar
    	cFilAtu := SUBSTR(aEstruNiv[nX][8],3,7) // Filial de consolidaÁ„o da etapa atual
	
		ProcLogAtu("MENSAGEM",OemToAnsi("Processa eliminaÁıes empresa: "+cEmpAtu),"","ELIPARTES") 
		                    
    	// Pego o Item Cont·bil da empresa posicionada aEstruNiv[nX]
    	cQ := "SELECT Z0_ITEMCTA AS ITEMCTB FROM "+RetSqlName("SZ0")
    	cQ += " WHERE "
		cQ += " Z0_EMPRESA = '"+cEmpAtu+"'"             
		cQ += " AND D_E_L_E_T_ = ' '"		
		TcQuery ChangeQuery(cQ) ALIAS "XSZ0" NEW                          
		IF !EMPTY(XSZ0->ITEMCTB) 
			ItemCtaA := XSZ0->ITEMCTB
		ENDIF
		XSZ0->(DBCLOSEAREA())
          
//CONOUT("Localiza empresa A")
//CONOUT(CQ)
//CONOUT(ItemCtaA)				
					
		IF !EMPTY(ItemCtaA) 

		    // Busco movimento nas demais empresas (B) para eliminar com a empresa (A)
			FOR nY := 1 TO LEN(aEstruNiv)                         
	            lHDL := .F.
				IF aEstruNiv[nX][2] <> aEstruNiv[nY][2] // Pulo empresas iguais                   
				    ItemCtaB := ""
		   	
					// Verifico as repetiÁıes de grupos
					IF _ValidaNiv(aEli1,cEmpAtu,aEstruNiv[nY][2],aEstruNiv[nY][8],aEstruNiv[nX][8]) 
						AADD(aEli1,{cEmpAtu,aEstruNiv[nY][2],aEstruNiv[nY][8]})

						// Localizo o Item Cont·bil da empresa a eliminar (B)
				    	cQ := "SELECT Z0_ITEMCTA AS ITEMCTB FROM "+RetSqlName("SZ0")
				    	cQ += " WHERE "
						cQ += " Z0_EMPRESA = '"+aEstruNiv[nY][2]+"'"             
						cQ += " AND D_E_L_E_T_ = ' '"		
						TcQuery ChangeQuery(cQ) ALIAS "XSZ0" NEW                          
						IF !EMPTY(XSZ0->ITEMCTB) 
							ItemCtaB := XSZ0->ITEMCTB
						ENDIF
						XSZ0->(DBCLOSEAREA())
				
//CONOUT("Localiza empresa B")
//CONOUT(CQ)
//CONOUT(ItemCtaB)				
								
				        IF !EMPTY(ItemCtaB)                    
						    cFilPos := SUBSTR(aEstruNiv[nY][8],3,7)                                               
									    
					        nPer := IF(aEstruNiv[nX][3] > aEstruNiv[nY][3], aEstruNiv[nY][3], aEstruNiv[nX][3]) // Pego o menor percentual de consolidacao
								             
							// Localizo o saldo do movimento do ativo da empresa (B) na empresa (A)
		                                                                                            
					        // DEBITO ItemCtaB Conta do Ativo
					        cQ := "SELECT SUM(CT2_VALOR) AS VALOR FROM "+RetSqlName("CT2")
					        cQ += " WHERE CT2_FILIAL = '"+XFILIAL("CT2")+"'"
						    cQ += " AND CT2_DATA >= '"+DTOS(dDataIni)+"' AND CT2_DATA <= '"+DTOS(dDataFim)+"'"						        
					        cQ += " AND CT2_MOEDLC = '01'"							    
					        cQ += " AND (CT2_XEMP = '"+cEmpAtu+"' OR ( CT2_XEMP = '' AND CT2_ORIGEM LIKE '%"+cEmpAtu+"%'))"
						    cQ += " AND CT2_DC IN('1','3') "       
					        cQ += " AND CT2_DEBITO = '"+ContaA+"'"
					        cQ += " AND CT2_ITEMD = '"+ItemCtaB+"'"                                
					        cQ += " AND CT2_TPSALD = '1'"
							cQ += " AND D_E_L_E_T_ = ' '"							    
							TcQuery ChangeQuery(cQ) ALIAS "XCT2" NEW              
							nDebito := XCT2->VALOR
							XCT2->(DBCLOSEAREA())  
			                                                                                           
//CONOUT(cQ)
				
							        // CREDITO ITEMCTBB Conta do Ativo
					        cQ := "SELECT SUM(CT2_VALOR) AS VALOR FROM "+RetSqlName("CT2")
					        cQ += " WHERE CT2_FILIAL = '"+XFILIAL("CT2")+"'"  
						    cQ += " AND CT2_DATA >= '"+DTOS(dDataIni)+"' AND CT2_DATA <= '"+DTOS(dDataFim)+"'"						        
					        cQ += " AND CT2_MOEDLC = '01'"							    							    
					        cQ += " AND (CT2_XEMP = '"+cEmpAtu+"' OR ( CT2_XEMP = '' AND CT2_ORIGEM LIKE '%"+cEmpAtu+"%'))"
					        cQ += " AND CT2_DC IN('2','3') "
					        cQ += " AND CT2_CREDIT = '"+ContaA+"'"
					        cQ += " AND CT2_ITEMC = '"+ItemCtaB+"'"    
					        cQ += " AND CT2_TPSALD = '1'"				                                    
						    cQ += " AND D_E_L_E_T_ = ' '"   
							TcQuery ChangeQuery(cQ) ALIAS "XCT2" NEW              
							nCredito := XCT2->VALOR
							XCT2->(DBCLOSEAREA())						
	      
//CONOUT(cQ)	
	
	                        // Calcula o saldo
	                        nSaldoA := nDebito - nCredito
		                        
							// Localizo o saldo do movimento do passivo da empresa (A) na empresa (B)
					        // DEBITO ITEMCTBA Conta do Passivo
						 	cQ := "SELECT SUM(CT2_VALOR) AS VALOR FROM "+RetSqlName("CT2")
							cQ += " WHERE CT2_FILIAL = '"+XFILIAL("CT2")+"'"
							cQ += " AND CT2_DATA >= '"+DTOS(dDataIni)+"' AND CT2_DATA <= '"+DTOS(dDataFim)+"'"								  
					        cQ += " AND CT2_MOEDLC = '01'"							    								
					        cQ += " AND (CT2_XEMP = '"+aEstruNiv[nY][2]+"' OR ( CT2_XEMP = '' AND CT2_ORIGEM LIKE '%"+aEstruNiv[nY][2]+"%'))"
						    cQ += " AND CT2_DC IN('1','3') "
						    cQ += " AND CT2_DEBITO = '"+ContaP+"'"
						    cQ += " AND CT2_ITEMD = '"+ItemCtaA+"'"    
						    cQ += " AND CT2_TPSALD = '1'"				                                    
							cQ += " AND D_E_L_E_T_ = ' '"   								
							TcQuery ChangeQuery(cQ) ALIAS "XCT2" NEW              
							nDebito := XCT2->VALOR
							XCT2->(DBCLOSEAREA())
	      
//CONOUT(cQ)	
	
					        // CREDITO ITEMCTBA Conta do Passivo
					        cQ := "SELECT SUM(CT2_VALOR) AS VALOR FROM "+RetSqlName("CT2")
					        cQ += " WHERE CT2_FILIAL = '"+XFILIAL("CT2")+"'"
						    cQ += " AND CT2_DATA >= '"+DTOS(dDataIni)+"' AND CT2_DATA <= '"+DTOS(dDataFim)+"'"						        
					        cQ += " AND CT2_MOEDLC = '01'"							    							    
					        cQ += " AND (CT2_XEMP = '"+aEstruNiv[nY][2]+"' OR ( CT2_XEMP = ''  AND CT2_ORIGEM LIKE '%"+aEstruNiv[nY][2]+"%'))"						        
					        cQ += " AND CT2_DC IN('2','3') "
					        cQ += " AND CT2_CREDIT = '"+ContaP+"'"
					        cQ += " AND CT2_ITEMC = '"+ItemCtaA+"'"    
					        cQ += " AND CT2_TPSALD = '1'"				                                    
					        cQ += " AND D_E_L_E_T_ = ' '"       							    
							TcQuery ChangeQuery(cQ) ALIAS "XCT2" NEW              
							nCredito := XCT2->VALOR
							XCT2->(DBCLOSEAREA())						    
	
//CONOUT(cQ)	      
	      
	                        nSaldoB := nCredito - nDebito
		  
//CONOUT("APURA«√O: ")								
//CONOUT(STR(nSaldoA))				
//CONOUT(STR(nSaldoB))				
														                        
	                        // Verifico se possui eliminacao entre as empresas
	                        IF ABS(nSaldoA) > 0 .AND. ABS(nSaldoB) > 0      
					                        
	                        	IF ABS(nSaldoA) > ABS(nSaldoB)
									VALOR := nSaldoA
								ELSE	                           		
									VALOR := nSaldoB
	                            ENDIF
								
								// Contabilizo a eliminaÁ„o do Ativo e Passivo entre as empresas na consolidara atual
					
								IF !lHDL            
							        cArquivo := ""
									nTotal   := 0                             
									aFlagCTB := {}                                                                                                
									nHdlPrv  := HeadProva( cLote,"ASCTBA10",Substr(cUsuario,7,6),@cArquivo )
									IF nHdlPrv < 0                                   	
										lContinua := .F.	
										EXIT
									EndIf			
									lHDL     := .T.										
                	            ENDIF
					                            
								VALOR     := ABS(VALOR)
					
								ORIGEM    := cEmpAtu+"/"+aEstruNiv[nY][2]

								IF nSaldoA > 0					
									CREDITO := ContaA  
									ITEMD	:= ItemCtaB
									DEBITO  := ContaP
									ITEMC	:= ItemCtaA         
								ELSE                    
									CREDITO   := ContaP         
									ITEMD	:= ItemCtaA
									DEBITO  := ContaA
									ITEMC	:= ItemCtaB         									
								ENDIF										

								HISTORICO := "ELIM. PARTES RELACIONADAS: "+cEmpAtu+"/"+aEstruNiv[nY][2]
					
								ProcLogAtu("MENSAGEM",OemToAnsi("Executa o Detprova"),"","ELIPARTES") 			                               
		   	
							   	nTotal := DetProva(nHdlPrv,"E01","ASCTBA10",cLote)
	
				        		nVlTot += nTotal
						
							ENDIF	
					 	ENDIF
					ELSE             
						AADD(aEli1,{cEmpAtu,aEstruNiv[nY][2],aEstruNiv[nY][8]})							
					ENDIF							    
				ENDIF    
		
				IF lHDL .AND. nVlTot > 0
		
					RodaProva(nHdlPrv,nTotal)                                                                               
					cA100Incl(cArquivo,nHdlPrv,3,cLote,.F.,.F.,,dDataFim,,@aFlagCTB)
					aFlagCTB := {}
		       	ENDIF				
							
			NEXT nY	                
			IF !lContinua
				EXIT
			ENDIF
		ENDIF
	NEXT nX                                     
		

NEXT nA
RETURN(lContinua)	
/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ValidaNiv ∫Autor  ≥Microsiga           ∫ Data ≥  04/03/13   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Verifica se as empresas se repetem entre os grupos.        ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                         ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/                     
//_ValidaNiv(aEli1,cEmpAtu,aEstruNiv[nY][2],aEstruNiv[nY][8],aEstruNiv[nX][8]) 
//Etapa: 160 -   4/020040001/100.00/0250025/500250025/500010001/020040001/500040001/010010001/S
STATIC FUNCTION _ValidaNiv(pEli1,pEmpAtu,pEmpPos,pGrupo,pGrupoX)
Local lRet := .F.    

IF pGrupo <> pGrupoX  // Empresas consolidadoras de etapas anteriores, ja eliminei na etapa
	IF !EMPTY(pEli1)
		IF ASCAN(pEli1,{|x| x[1]+x[2] == pEmpAtu+pEmpPos}) == 0
			lRet := .T.
		ENDIF                                                                       
	ELSE
		lRet := .T.
	ENDIF		
ENDIF	

RETURN(lRet)
//-----------------------------------------------------------------------
/*{Protheus.doc} ELIPL
@EliminaÁ„o do PL
@param		
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------
Static Function ELIPL
Local cContaMEP := ""
Local cGRPL		:= ""
Local cResul	:= ""
Local aContaPL	:= {}
Local lContinua := .T.   
Local nX		:= 0
Local nY		:= 0         
Local cGrpAtu	:= ""
Local cContaI   := ""
Local cItemI	:= ""                                 
Local cEmpAtu	:= ""
Local nAcoes   	:= 0
Local nPerPar	:= 0
Local nPL		:= 0 
Local nPer		:= 0
Local nSaldoC	:= 0
Private cLote   := "ELIMIN"
Private lHDL 	:= .F.     
Private nVlTot  := 0
Private nHdlPrv := 0
Private cArquivo:= ""
Private aFlagCTB:= {}                                                                            


ProcLogAtu("MENSAGEM",OemToAnsi("Inicio - Eliminacoes Investimento"),"","ELIPL") 

cContaMEP   := aEmpOri[1][14]
cGRPL		:= aEmpOri[1][15]
cResul		:= aEmpOri[1][16]
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

cEmpAtu := aEstruNiv[1][9] // Empresa participante da consolidada
             
******************************
// Busco movimento nas demais empresas (B) para eliminar com a empresa (A)
FOR nY := 1 TO LEN(aEstruNiv)                         

	ProcLogAtu("MENSAGEM",OemToAnsi("Investimento empresa: "+aEstruNiv[nY][7]),"","ELIPL") 
			
	IF aEstruNiv[nY][7] <> cGrpAtu // Somente elimino empresas do primeiro nivel, as consolidadora, elimino a consolidadora e n„o as empresas dela
	            
		cGrpAtu := aEstruNiv[nY][7]
				
        // Localiza a conta de investimento da empresa
		cQ := "SELECT Z0_CONTA, Z0_ITEMCTA, Z0_QTACOES FROM "+RetSqlName("SZ0")
		cQ += " WHERE "
		cQ += " Z0_EMPRESA = '"+cGrpAtu+"'"             
		cQ += " AND D_E_L_E_T_ = ' ' "
		TcQuery ChangeQuery(cQ) ALIAS "QrySZ0" NEW                      
				
		cContaI := QrySZ0->Z0_CONTA
		cItemI  := QrySZ0->Z0_ITEMCTA
		nAcoes  := QrySZ0->Z0_QTACOES
			
		QrySZ0->(DBCLOSEAREA())

	    // VERIFICO SE POSSUI PARTICIPACAO
		cQ := "SELECT Z2_EMP, Z2_EMPPAR, Z2_QUANT"
		cQ += " FROM "+RetSqlName("SZ2")+" SZ2 "   
		cQ += " WHERE Z2_FILIAL = '"+XFILIAL("SZ2")+"' AND Z2_DTBASE = '"+DTOS(FirstDay(dDataBase))+"'"
		cQ += " AND Z2_EMP = '"+cEmpAtu+"'"
		cQ += " AND Z2_EMPPAR = '"+cGrpAtu+"'"
		cQ += " AND D_E_L_E_T_ = ' '"
		TcQuery ChangeQuery(cQ) ALIAS "XSZ2" NEW
		
		IF QrySZ2->(!EOF())
			nPerPar := nAcoes / QrySZ2->Z2_QUANT 
		ELSE
			nPerPar := 0
	   	ENDIF
			                               
		QrySZ2->(DBCLOSEAREA())
			        
		lHdl := .F.
		IF nPerPar <> 0             
						
			CONOUT("Eliminacao Investimento - "+cEmpAtu+"/"+aEstruNiv[nY][7]+" - Investimento: "+STR(nPerPar))                      			           
			CONOUT("Eliminacao Investimento - "+cEmpAtu+"/"+aEstruNiv[nY][7]+" - Conta de Investimento: "+cContaI)                      			           
			CONOUT("LEN aContaPL: "+STR(LEN(aContaPL)))                      			                                                  
		
			FOR nPL := 1 TO LEN(aContaPL)
		
				ProcLogAtu("MENSAGEM",OemToAnsi("Investimento conta: "+aContaPL[nPL]),"","ELIPL") 

				CONOUT("Eliminacao - "+aContaPL[nPL]+" - : "+cEmpAtu+"/"+cGrpAtu)
		                             
				// Busco o saldo da conta na empresa posicionada
				nSaldoC := U_SALDOMOV(aEstruNiv[nY][8],aContaPL[nPL], dDataBase, '01',"1","",dDataIni)   // Saldo da conta
		  		nPer   := IF(aEstruNiv[nX][3] > aEstruNiv[nY][3], aEstruNiv[nY][3], aEstruNiv[nX][3])    // pega o menor percentual de consolidaÁ„o
						
				CONOUT("Eliminacao - "+aContaPL[nPL]+" - : "+cEmpAtu+"/"+cGrpAtu+" - VALOR: "+STR(nSaldoC,17,2))                      			           
				CONOUT("Eliminacao - "+aContaPL[nPL]+" - : "+cEmpAtu+"/"+cGrpAtu+" - PERCENTUAL: "+STR(nPer,17,2))                      			           
		
				VALOR     := ABS(nSaldoC)                  // Saldo da conta 
				VALOR1    := ROUND(VALOR * nPer / 100,2)   // Saldo consolidado - contabilizar na conta do PL
				VALOR2    := ROUND(VALOR * nPerPar / 100,2)// Saldo da conta * percentual de investimento - contabilizar na conta do Investimento
						                                                        
				IF VALOR > 0
					IF !lHDL
						ProcLogAtu("MENSAGEM",OemToAnsi("Chamada do Headprova"),"","ELIPL") 	
						CONOUT("Eliminacao - "+aContaPL[nPL]+" - : "+cEmpAtu+"/"+cGrpAtu+" HeadProva")                      		
				        cArquivo := ""
						nTotal := 0                                                 
						aFlagCTB:= {}
						nHdlPrv := HeadProva( cLote,"ASCTBA10",Substr(cUsuario,7,6),@cArquivo )
						IF nHdlPrv < 0                                   	
							CONOUT("Eliminacao - "+aContaPL[nPL]+" - : "+cEmpAtu+"/"+cGrpAtu+" Erro no HeadProva")                      		
							lContinua := .F.	
							EXIT
						EndIf			
						lHDL := .T.
		    		ENDIF
			                         
					HISTORICO := "ELIM. INVEST.: "+ALLTRIM(cContaI)+"/ PL: "+ALLTRIM(aContaPL[nPL])+" - "+ cEmpAtu+"/"+aEstruNiv[nY][7]											        						
					CT1->(DBSEEK(XFILIAL("CT1")+aContaPL[nPL]))        
			                                       
			        // Efetua lancamento da conta do PL x Investimento     
			                    
			        // Saldo da conta credor debita conta do PL com o saldo da conta, aplicado o percentual de consolidaÁ„o e credita a conta de investimento    
			       
					IF nSaldoC < 0 // saldo da conta negativo
						IF CT1->CT1_NORMAL == "2" // Conta do PL Credora 
									
							// CREDITO na conta do PL 
				            CONTA    := aContaPL[nPL]
							VALOR    := VALOR1
			    			nTotal := DetProva(nHdlPrv,"E02","ASCTBA10",cLote)										        

							// - DEBITO Investimento  
					        CONTA := cContaI
					        ITEM  := cItemI
					        VALOR := VALOR2
			    			nTotal := DetProva(nHdlPrv,"E03","ASCTBA10",cLote)						

		            		// DEBITO NA CONTA DE QUOTISTAS MINORITARIOS - DIFERENCA DA PARTICIPA«√O
//							IF (VALOR1 - VALOR2) <> 0
//						        VALOR    := ABS(VALOR1 - VALOR2)
//						        HISTORICO := "ELIM. INVEST.: "+ALLTRIM(ContaI)+"/ MIN.: "+ALLTRIM(ContaMI)+" - "+ cEmpAtu+"/"+aEstruNiv[nY][7]											        						
//						        CONTA     := ContaMI
//								nTotal := DetProva(nHdlPrv,"E03","ASCTBA10",cLote)						
//							ENDIF			

			    		ELSE 		 // Conta do PL Devedora
									// DEBITO na conta do PL 
		            		CONTA    := aContaPL[nPL]
					        VALOR    := VALOR1
			    			nTotal := DetProva(nHdlPrv,"E03","ASCTBA10",cLote)										        

							// - CREDITO Investimento  
			                CONTA := cContaI
			                ITEM  := cItemI
					        VALOR := VALOR2
			    			nTotal := DetProva(nHdlPrv,"E02","ASCTBA10",cLote)						

		            		// CREDITO NA CONTA DE QUOTISTAS MINORITARIOS - DIFERENCA DA PARTICIPA«√O
//							IF (VALOR1 - VALOR2) <> 0
//						        VALOR    := ABS(VALOR1 - VALOR2)
//						        HISTORICO := "ELIM. INVEST.: "+ALLTRIM(ContaI)+"/ MIN.: "+ALLTRIM(ContaMI)+" - "+ cEmpAtu+"/"+aEstruNiv[nY][7]											        						
//						        CONTA     := ContaMI
//								nTotal := DetProva(nHdlPrv,"E02","ASCTBA10",cLote)						
//							ENDIF			
			    		ENDIF	
			     	ELSE  		// saldo da conta positivo
						IF CT1->CT1_NORMAL == "2" // Conta do PL Credora 
							// DEBITO na conta do PL 
				       		CONTA    := aContaPL[nPL]
					        VALOR    := VALOR1
			    			nTotal := DetProva(nHdlPrv,"E03","ASCTBA10",cLote)										        

							// - CREDITO Investimento  
			                CONTA := cContaI
			                ITEM  := cItemI
					        VALOR := VALOR2
			    			nTotal := DetProva(nHdlPrv,"E02","ASCTBA10",cLote)						

		            		// CREDITO NA CONTA DE QUOTISTAS MINORITARIOS - DIFERENCA DA PARTICIPA«√O
//							IF (VALOR1 - VALOR2) <> 0
//						        VALOR    := ABS(VALOR1 - VALOR2)
//						        HISTORICO := "ELIM. INVEST.: "+ALLTRIM(ContaI)+"/ MIN.: "+ALLTRIM(ContaMI)+" - "+ cEmpAtu+"/"+aEstruNiv[nY][7]											        						
//						        CONTA     := ContaMI
//								nTotal := DetProva(nHdlPrv,"E02","ASCTBA10",cLote)						
//							ENDIF			


			    		ELSE 	 // Conta do PL Devedora
								// CREDITO na conta do PL 
		            		CONTA    := aContaPL[nPL]
					        VALOR    := VALOR1
			    			nTotal := DetProva(nHdlPrv,"E02","ASCTBA10",cLote)										        

							// - DEBITO Investimento  
			                CONTA := cContaI
			                ITEM  := cItemI
					        VALOR := VALOR2
			    			nTotal := DetProva(nHdlPrv,"E03","ASCTBA10",cLote)						

		            		// DEBITO NA CONTA DE QUOTISTAS MINORITARIOS - DIFERENCA DA PARTICIPA«√O
//							IF (VALOR1 - VALOR2) <> 0
//						        VALOR    := ABS(VALOR1 - VALOR2)
//						        HISTORICO := "ELIM. INVEST.: "+ALLTRIM(ContaI)+"/ MIN.: "+ALLTRIM(ContaMI)+" - "+ cEmpAtu+"/"+aEstruNiv[nY][7]											        						
//						        CONTA     := ContaMI
//								nTotal := DetProva(nHdlPrv,"E03","ASCTBA10",cLote)						
//							ENDIF			
			    		ENDIF	
					ENDIF
				ELSE
					CONOUT("Eliminacao - "+aContaPL[nPL]+" - : "+cEmpAtu+"/"+cGrpAtu+", SEM SALDO NA CONTA")                      			           											
				ENDIF					

			NEXT    
		    
		    IF lContinua 
			                
				// MEP
				CONOUT("Eliminacao - "+cEmpAtu+"/"+cGrpAtu+", MEP")                      		
				nSaldoC := U_APUR(aEstruNiv[nY][8], cResul, "1", "01")
				nPer := IF(aEstruNiv[nX][3]> aEstruNiv[nY][3], aEstruNiv[nY][3], aEstruNiv[nX][3])
						
				VALOR     := ABS(nSaldoC)                  // Saldo da conta 
				VALOR1    := ROUND(VALOR * nPer / 100,2)   // Saldo consolidado - utilizado para contabilizar os minoritarios
				VALOR2    := ROUND(VALOR * nPerPar / 100,2)// Saldo da conta * percentual de investimento - contabilizar na conta do Investimento e MEP
						                   
				CONOUT("Saldo eliminaÁ„o do MEP: "+TRANSFORM(nSaldoC,"@E 99,999,999,999.99"))
		                                                             
				IF VALOR > 0
			        
					IF !lHDL                                                      

						ProcLogAtu("MENSAGEM",OemToAnsi("Chamada do Headprova MEP"),"","ELIPL") 	
								
						CONOUT("Eliminacao - "+cEmpAtu+"/"+cGrpAtu+", MEP - HeadProva")                      								
						cArquivo := ""
						nTotal := 0                                                 
						aFlagCTB:= {}
						nHdlPrv := HeadProva( cLote,"ASCTBA10",Substr(cUsuario,7,6),@cArquivo )
						IF nHdlPrv < 0                                   	
							CONOUT("Eliminacao - "+cEmpAtu+"/"+cGrpAtu+" Erro no HeadProva")                      		
							lContinua := .F.	
							EXIT
						EndIf			
						lHDL := .T.
					ENDIF

					IF nSaldoC > 0 // Resultado Negativo - Saldo Credor 
							
					 	// DEBITO Investimento
						CONTA := cContaI
						ITEM  := cItemI
				        VALOR := VALOR2
				        HISTORICO := "ELIMINACAO INVESTIMENTO/MEP: "+cEmpAtu+"/"+aEstruNiv[nY][7]											        						
						CONOUT("DEBITO INVESTIMENTO VALOR : "+STR(VALOR,17,2))				        
					    nTotal := DetProva(nHdlPrv,"E03","ASCTBA10",cLote)						
					    		
			    		// - CREDITO MEP
			            CONTA := cContaMEP
						CONOUT("CREDITO NO MEP VALOR : "+STR(VALOR,17,2))				        
				    	nTotal := DetProva(nHdlPrv,"E02","ASCTBA10",cLote)						
                                            

                        /*
						IF (VALOR1 - VALOR2) <> 0
					        VALOR    := ABS(VALOR1 - VALOR2)
					        CONTA    := ContaMI                      				        
					        HISTORICO := "ELIMINACAO INVESTIMENTO/MINORITARIOS: "+cEmpAtu+"/"+aEstruNiv[nY][7]				        
							nTotal := DetProva(nHdlPrv,"E03","CTBA11ED",cLote)
			       
							CONTA := ContaQM
					        // DESPESAS MINORITARIOS
							nTotal := DetProva(nHdlPrv,"E02","CTBA11ED",cLote)						
			
						ENDIF			
                        */
			     	ELSE  // // Resultado Positivo - Saldo Devedor
					 	// CREDITO Investimento
						CONTA := cContaI
						ITEM  := cItemI
					 	VALOR := VALOR2
					  	HISTORICO := "ELIMINACAO INVESTIMENTO/MEP: "+cEmpAtu+"/"+aEstruNiv[nY][7]											        						
						CONOUT("DEBITO INVESTIMENTO VALOR : "+STR(VALOR,17,2))				        
					 	nTotal := DetProva(nHdlPrv,"E02","ASCTBA10",cLote)						
					    		
					  	// - DEBITO MEP
				    	CONTA := cContaMEP                 
						CONOUT("CREDITO NO MEP VALOR : "+STR(VALOR,17,2))				        
				  		nTotal := DetProva(nHdlPrv,"E03","ASCTBA10",cLote)						
				  
						/*
						IF (VALOR1 - VALOR2) <> 0
					        VALOR    := ABS(VALOR1 - VALOR2)
					        CONTA    := ContaMI                      				        
					        HISTORICO := "ELIMINACAO INVESTIMENTO/MINORITARIOS: "+cEmpAtu+"/"+aEstruNiv[nY][7]				        
							nTotal := DetProva(nHdlPrv,"E02","CTBA11ED",cLote)
			       
							CONTA := ContaQM
			                // DESPESAS MINORITARIOS
							nTotal := DetProva(nHdlPrv,"E03","CTBA11ED",cLote)						
			
				  		ENDIF			
                        */
					ENDIF		       
				       
				ELSE
					CONOUT("Eliminacao - Investimento - : "+cEmpAtu+"/"+cGrpAtu+" MEP - SEM SALDO NA CONTA")                      													
				ENDIF
							
			ENDIF
			IF lHDL 
				CONOUT("Eliminacao - "+cEmpAtu+"/"+cGrpAtu+" Rodaprova")                      		
				ProcLogAtu("MENSAGEM",OemToAnsi("Chamada do Rodaprova MEP"),"","ELIPL") 							     							
				RodaProva(nHdlPrv,nTotal)                                                                               

				ProcLogAtu("MENSAGEM",OemToAnsi("Chamada do cA100Incl MEP"),"","ELIPL") 							     							

				cA100Incl(cArquivo,nHdlPrv,3,cLote,.F.,.F.,,dDataBase,,@aFlagCTB)                   
			ENDIF      
		
		ELSE
			CONOUT("Eliminacao Investimento - "+cEmpAtu+"/"+cGrpAtu+" Conta: "+cContaI+", Nao possui participaÁ„o")                      			           					
		ENDIF                                                  
	ENDIF
	IF !lContinua
		EXIT
	ENDIF	
NEXT nY                         

ProcLogAtu("MENSAGEM",OemToAnsi("Fim - Eliminacoes PL"),"","ELIPL") 
	
RETURN(lContinua)
