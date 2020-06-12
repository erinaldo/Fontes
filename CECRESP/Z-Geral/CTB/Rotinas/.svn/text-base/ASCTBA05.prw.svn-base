#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'
//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTBA05
@Estrutura de consolidação
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------
User Function ASCTBA05
Private cTitulo 	:= OEMTOANSI("Estrutura de Consolidação")    
Private cCadastro 	:= cTitulo
Private aRotina 	:= MenuDef()
Private cDelFunc 	:= ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString  	:= "SZ6"
Private nControl 	:= 0 
Private cFilter    	:= Nil                              
Private cChave 		:= SZ6->(IndexKey())
Private lDefTop := !(TcSrvType() == "AS/400" .Or. TcSrvType() == "iSeries")
Private cRevisao	:= "000"

// Localiza a ultima revisão da SZ0, para compatibilizar com o pergunte
cQ := "SELECT Z0_REVISAO, Z0_DTREVIS FROM "+RetSqlName("SZ0")+" WHERE 
cQ += " Z0_DTREVIS <= '"+DTOS(dDataBase)+"' AND D_E_L_E_T_ = ' '"
cQ += " ORDER BY Z0_REVISAO DESC"
TcQuery ChangeQuery(cQ) ALIAS "XSZ0" NEW
IF !EMPTY(XSZ0->Z0_REVISAO)
	cRevisao := XSZ0->Z0_REVISAO
ENDIF
XSZ0->(DBCLOSEAREA())


dbSelectArea(cString)         
(cString)->(dbSetOrder(1))

mBrowse( 6, 1,22,75,"SZ6",,,,,,,,,,,,,,Iif(lDefTop,cFilter,Nil))

Return    
//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTB05M
@Manutenção da Estrutura de consolidação
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------                                        
User Function ASCTB05M(cAlias,nReg,nOpc)
Local lOk		:= .F.
Local bOk       := {|| (lOk	:= .T., oDlg:End()) }
Local bCancel   := {|| (lOk	:= .F., oDlg:End()) }
Local lAtu1     := .T.
Local lAtu2     := .T.                           
Local aButton 	:= {}
Local nRet      := 0                     
Local nX		:= 0
Local nY		:= 0    
Local nPos      := 0
Private oGroup1
Private oCodCons
Private cCodCons := SPACE(TAMSX3("Z6_CODIGO")[1])
Private oDesCon 
Private cDesCon  := SPACE(TAMSX3("Z6_DESCRI")[1])
Private oGroup2
Private oGroup3
Private oPanel1           
Private nOpcx := nOpc
Private aHead1 := {}
Private aCols1 := {}
Private oMSNewGe1
Private aHead2 := {}
Private aCols2 := {}                                                           
Private aColsx := {}
Private oMSNewGe2
Private cFilSet:= ""            
Static oDlg        
                                              
IF nOpcX <> 3
	cCodCons := SZ6->Z6_CODIGO
	cDesCon  := SZ6->Z6_DESCRI
ENDIF	

DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000, 000  TO 600, 1000 COLORS 0, 16777215 PIXEL
@ 032, 003 MSPANEL oPanel1 SIZE 685, 285 OF oDlg COLORS 0, 16777215 RAISED
@ 003, 003 GROUP oGroup1 TO 031, 493 PROMPT "Estrutura de Consolidação" OF oPanel1 COLOR 0, 16777215 PIXEL
@ 014, 007 MSGET oCodCons VAR cCodCons  PICTURE "@!" WHEN nOpcx == 3 SIZE 037, 010 OF oPanel1 COLORS 0, 16777215 PIXEL VALID _CODCONS()
@ 014, 060 MSGET oDesCon  VAR cDesCon  PICTURE "@!" WHEN nOpcx == 3 SIZE 200, 010 OF oPanel1 COLORS 0, 16777215 PIXEL
@ 035, 003 GROUP oGroup2 TO 155, 493 PROMPT "Consolidadora" OF oPanel1 COLOR 0, 16777215 PIXEL
ASCTB05MA()
@ 160, 004 GROUP oGroup3 TO 260, 493 PROMPT "Consolidações" OF oPanel1 COLOR 0, 16777215 PIXEL
ASCTB05MB()
ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, bOk, bCancel,,aButton)

IF lOK
	IF nOpcX == 3 .OR. nOpcX == 4  
		nRet := TCSQLEXEC("DELETE FROM "+RetSqlName("SZ6")+" WHERE Z6_FILIAL = '"+XFILIAL("SZ6")+"' AND Z6_CODIGO = '"+cCodCons+"' ")
		TcRefresh(RetSqlName("SZ6"))
	    IF nRet > 0
	    	ApMsgAlert("Erro na manutenção do cadastro atual.")
	   	ENDIF	
             
		IF nRet == 0	                          
	    
			// Atualiza SZ6
			FOR nX := 1 TO LEN(oMSNewGe1:aCols)
				IF !oMSNewGe1:aCols[nX][LEN(oMSNewGe1:aCols[nX])]                                      
					nPos := ASCAN(aColsX,{|x| ALLTRIM(x[1]) == ALLTRIM(oMSNewGe1:aCols[nX][aScan(aHead1,{|x| AllTrim(x[2]) == "Z6_EMP"})])})
					IF nPos > 0				     
						aCols2 := aColsX[nPos][2]
						FOR nY := 1 TO LEN(aCols2)
							IF !aCols2[nY][LEN(aCols2[nY])] .AND. !EMPTY(aCols2[nY][aScan(aHead2,{|x| AllTrim(x[2]) == "Z6_EMPCONS"})])
								SZ6->(DBSETORDER(1))
								IF SZ6->(!DBSEEK(XFILIAL("SZ6")+cCodCons+oMSNewGe1:aCols[nX][aScan(aHead1,{|x| AllTrim(x[2]) == "Z6_EMP"})]+aCols2[nY][aScan(aHead2,{|x| AllTrim(x[2]) == "Z6_EMPCONS"})]+aCols2[nY][aScan(aHead2,{|x| AllTrim(x[2]) == "Z6_TPSALDO"})]))
									RECLOCK("SZ6",.T.)
									SZ6->Z6_FILIAL := XFILIAL("SZ6") 	
									SZ6->Z6_CODIGO := cCodCons
									SZ6->Z6_DESCRI := cDesCon									
									SZ6->Z6_EMP    := oMSNewGe1:aCols[nX][aScan(aHead1,{|x| AllTrim(x[2]) == "Z6_EMP"})]
									SZ6->Z6_SEQ    := oMSNewGe1:aCols[nX][aScan(aHead1,{|x| AllTrim(x[2]) == "Z6_SEQ"})]
									SZ6->Z6_EMPCONS:= aCols2[nY][aScan(aHead2,{|x| AllTrim(x[2]) == "Z6_EMPCONS"})]
									SZ6->Z6_TPSALDO:= aCols2[nY][aScan(aHead2,{|x| AllTrim(x[2]) == "Z6_TPSALDO"})]
						            MsUnlock()
						        ENDIF    
					   		ENDIF
						NEXT nY
					ENDIF
				ENDIF	
			NEXT nX
		ENDIF 
	ENDIF
	
	IF nOpcX == 5   // EXCLUSAO
		IF MSGYESNO("*** ATENCAO *** Confirma a exclusão da estrutura?")
			SZ6->(DBSETORDER(1))
			IF SZ6->(DBSEEK(XFILIAL("SZ6")+cCodCons))
				WHILE SZ6->Z6_FILIAL == XFILIAL("SZ6") .AND. SZ6->Z6_CODIGO == cCodCons
					RECLOCK("SZ6",.F.)
					SZ6->(DBDELETE())
					SZ6->(DBSKIP())
				END
			ENDIF	
		ENDIF
	ENDIF									
ENDIF
Return                                                                            
//-----------------------------------------------------------------------
/*{Protheus.doc} _CODCONS
@Valida empresa consolidadora digitada
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------                                    
STATIC FUNCTION _CODCONS
Local lRet		:= .T.
SZ6->(DBSETORDER(1))
IF SZ6->(DBSEEK(XFILIAL("SZ6")+cCodCons))
	ApMsgAlert("Já existe uma estrutura cadastrada com este código.")
	lRet := .F.
	cDesCon := SPACE(LEN(SZ6->Z6_DESCRI))		
ENDIF
oDesCon:Refresh()
RETURN(lRet)
//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTB05MA
@Empresa Consolidadora
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------         
Static Function ASCTB05MA
Local nX
Local aFieldFill := {}
Local aFields := {}
Local aAlterFields := {}

AADD(aFields,"Z6_SEQ")                                          
AADD(aFields,"Z6_EMP")                                          
AADD(aFields,"Z6_NMEMP")                                                            

IF nOpcX == 4 .OR. nOpcX == 3
	AADD(aAlterFields,"Z6_SEQ")
	AADD(aAlterFields,"Z6_EMP")
ENDIF

// Define field properties
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFields)
	IF SX3->(DbSeek(aFields[nX]))
		Aadd(aHead1, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
    Endif
Next nX

IF nOpcX == 3 // Gera o Acols vazio
	For nX := 1 to Len(aFields)
		If DbSeek(aFields[nX])
			Aadd(aFieldFill, CriaVar(SX3->X3_CAMPO))
		Endif
	Next nX
	Aadd(aFieldFill, .F.)
	Aadd(aCols1, aFieldFill)
ELSE // Atualiza o Acols com os dados existentes
	cQ := "SELECT DISTINCT(Z6_CODIGO), Z6_EMP, Z6_SEQ"
	cQ += " FROM "+RetSqlName("SZ6")+" WHERE "      
	cQ += " Z6_CODIGO = '"+ALLTRIM(cCodCons)+"'"	
	cQ += " AND  D_E_L_E_T_ <> '*'"
	cQ += " ORDER BY Z6_SEQ,Z6_EMP "
	TcQuery ChangeQuery(cQ) ALIAS "QrySZ6" NEW
                                                   
    
	// Informa qual a empresa e filial que está no registro atual de consolidada na SZ6 para posicionar na SZ6 a consolildar
	cFilSet := ALLTRIM(QrySZ6->Z6_EMP)
    
	nRegSZ6 := SZ6->(RECNO())
	WHILE QrySZ6->(!EOF())                          

	    SZ6->(DBSETORDER(1))
  	    SZ6->(DBSEEK(XFILIAL("SZ6")+QrySZ6->Z6_CODIGO+QrySZ6->Z6_EMP))

		Aadd(aFieldFill, QrySZ6->Z6_SEQ)
		Aadd(aFieldFill, QrySZ6->Z6_EMP)		
		Aadd(aFieldFill, POSICIONE("SZ0",1,XFILIAL("SZ0")+cRevisao+ALLTRIM(QrySZ6->Z6_EMP),"Z0_RAZAO"))
		Aadd(aFieldFill, .F.)
		Aadd(aCols1, aFieldFill)		
		QrySZ6->(DBSKIP())  
		aFieldFill := {}
	END
	QrySZ6->(DBCLOSEAREA())  
	SZ6->(DBGOTO(nRegSZ6))
ENDIF               
	
oMSNewGe1 := MsNewGetDados():New( 045, 006, 150, 486, IF(nOpcX == 3 .OR. nOpcX == 4,GD_INSERT+GD_DELETE+GD_UPDATE,0), "AllwaysTrue", "AllwaysTrue",, aAlterFields,, 999, "U_CTB05MVA()", "","AllwaysTrue", oPanel1, aHead1, aCols1)
oMSNewGe1:oBrowse:bLostFocus	:= {|| lRetorno := oMSNewGe1:TudoOK(),aCols1:=IIf(lRetorno,oMSNewGe1:aCols,aCols1),lRetorno }                              
oMSNewGe1:oBrowse:bChange	    := {|| lRetorno := .T.,U_CTB05MVA(), lRetorno }                              

Return                                                                                        
//-----------------------------------------------------------------------
/*{Protheus.doc} CTB05MVA
@Validação da Getdados 1
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------         
USER FUNCTION CTB05MVA
Local nPos := 0                                           
Local lRet := .T.
                                                                
IF READVAR() == "M->Z6_SEQ" .AND. TYPE("M->Z6_SEQ") <> "U"      
	IF EMPTY(M->Z6_SEQ)
		ApMsgAlert("Informe uma sequencia válida.")
		lRet := .F.
	ENDIF	                                                                                                                   
	IF (nPos := ASCAN(oMSNewGe1:aCols,{|x| ALLTRIM(x[aScan(aHead1,{|x| AllTrim(x[2]) == "Z6_SEQ"})]) == ALLTRIM(M->Z6_SEQ)})) > 0 .AND. nPos <> oMSNewGe1:NAT .AND. lRet
		ApMsgAlert("Sequencia ja informada.")
		lRet := .F.
	ENDIF			
ENDIF	             

IF lRet

	IF READVAR() == "M->Z6_EMP" .AND. TYPE("M->Z6_EMP") <> "U"
		IF EMPTY(M->Z6_EMP)
			ApMsgAlert("Informe um código de empresa válida.")
			lRet := .F.
		ENDIF
	
		IF (nPos := ASCAN(oMSNewGe1:aCols,{|x| ALLTRIM(x[aScan(aHead1,{|x| AllTrim(x[2]) == "Z6_EMP"})]) == ALLTRIM(M->Z6_EMP)})) > 0 .AND. nPos <> oMSNewGe1:NAT .AND. lRet
			ApMsgAlert("Empresa ja informada.")
			lRet := .F.
			cFilSet := SPACE(LEN(SZ6->Z6_EMP))
			oMSNewGe1:aCols[oMSNewGe1:nAT][aScan(aHead1,{|x| AllTrim(x[2]) == "Z6_NMEMP"})] := SPACE(30)
		ELSE                                
			IF EMPTY(POSICIONE("SZ0",1,XFILIAL("SZ0")+cRevisao+ALLTRIM(M->Z6_EMP),"Z0_RAZAO"))
				ApMsgAlert("Empresa não cadastrada.")
				lRet := .F.
			ELSE
				oMSNewGe1:aCols[oMSNewGe1:nAT][aScan(aHead1,{|x| AllTrim(x[2]) == "Z6_NMEMP"})] := SZ0->Z0_RAZAO
				cFilSet := M->Z6_EMP
			ENDIF	
		ENDIF			
	ENDIF	             

ENDIF                                                         


IF lRet
	// BCHANGE
	IF EMPTY(oMSNewGe1:aCols[oMSNewGe1:NAT][aScan(aHead1,{|x| AllTrim(x[2]) == "Z6_EMP"})]) // CONTEUDO DA LINHA VAZIA, LIMPA O ACOLS DE CONSOLIDADAS
		oMSNewGe2:aCols := _COLS()
		oMSNewGe2:Refresh()	
	ELSE                       
	    cFilSet := ALLTRIM(oMSNewGe1:aCols[oMSNewGe1:NAT][aScan(aHead1,{|x| AllTrim(x[2]) == "Z6_EMP"})])
		IF (nPos := ASCAN(aColsX,{|x| ALLTRIM(x[1]) == cFilSet})) == 0
			AADD(aColsX,{cFilSet,_COLS()})    
			oMSNewGe2:aCols := _COLS()
			nPos := LEN(aColsX)
		ELSE
			oMSNewGe2:aCols := aColsX[nPos][2]	
		ENDIF                  
		oMSNewGe2:Refresh()
	ENDIF	
ENDIF                                                                         
RETURN(lRet)       
//-----------------------------------------------------------------------
/*{Protheus.doc} _COLS
@Gera aCols vazia
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------            
Static Function _COLS()
Local nX
Local aFieldFill := {}
Local aFields := {}
Local aX3     := {}
                       
AADD(aFields,"Z6_EMPCONS")
AADD(aFields,"Z6_NMCONS")
AADD(aFields,"Z6_TPSALDO")                                                                                    

DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFields)
    If DbSeek(aFields[nX])
      Aadd(aFieldFill, CriaVar(SX3->X3_CAMPO))
    Endif
Next nX
Aadd(aFieldFill, .F.)
Aadd(aX3, aFieldFill)
Return(aX3)             
//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTB05MB
@Getdados das consolidadas
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------                         
Static Function ASCTB05MB()
Local nX
Local aFieldFill := {}
Local aFields := {}
Local aAlterFields := {} 

AADD(aFields,"Z6_EMPCONS")
AADD(aFields,"Z6_NMCONS")
AADD(aFields,"Z6_TPSALDO")                                                                                    

IF nOpcX == 3 .OR. nOpcx == 4                                                                            
	AADD(aAlterFields,"Z6_EMPCONS")
	AADD(aAlterFields,"Z6_TPSALDO")                                                                                         
ENDIF	

// Define field properties
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFields)
	If SX3->(DbSeek(aFields[nX]))
		Aadd(aHead2, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
    Endif
Next nX

IF nOpcX <> 3
	cQ := "SELECT Z6_CODIGO, Z6_EMP, Z6_SEQ, Z6_EMPCONS, Z6_TPSALDO"
	cQ += " FROM "+RetSqlName("SZ6")+" WHERE "
	cQ += " Z6_CODIGO = '"+ALLTRIM(cCodCons)+"'"
	cQ += " AND D_E_L_E_T_ = ' '"
	cQ += " ORDER BY Z6_SEQ, Z6_EMPCONS "
	TcQuery ChangeQuery(cQ) ALIAS "QrySZ6" NEW
    
	// Informa qual a empresa e filial que está no registro atual de consolidada na SZL para posicionar na SZL a consolildar
	cFilSet := ALLTRIM(QrySZ6->Z6_EMP)

	WHILE QrySZ6->(!EOF())                          
		aCols2 := {}                                     
		cFilSet := QrySZ6->Z6_EMP
		WHILE QrySZ6->(!EOF()) .AND. ALLTRIM(QrySZ6->Z6_EMP)==ALLTRIM(cFilSet)
			Aadd(aFieldFill, QrySZ6->Z6_EMPCONS)
			AADD(aFieldFill, POSICIONE("SZ0",1,XFILIAL("SZ0")+cRevisao+QrySZ6->Z6_EMPCONS,"Z0_RAZAO"))
			AADD(aFieldFill,QrySZ6->Z6_TPSALDO)  
			Aadd(aFieldFill, .F.)
			Aadd(aCols2, aFieldFill)
		    QrySZ6->(DBSKIP())
		    aFieldFill := {}
			AADD(aColsx,{cFilSet,Acols2})
		END
		Acols2 := aColsx[1][2]			
	END
	QrySZ6->(DBCLOSEAREA())
ENDIF
     
IF EMPTY(aCols2)     
	For nX := 1 to Len(aFields)
		DbSelectArea("SX3")
		SX3->(DbSetOrder(2))
    	If DbSeek(aFields[nX])         
			Aadd(aFieldFill, CriaVar(SX3->X3_CAMPO))
    	Endif
  	Next nX
  	Aadd(aFieldFill, .F.)
  	Aadd(aCols2, aFieldFill)
  	AADD(aColsX,{SPACE(LEN(SZ6->Z6_EMP)),Acols2})
ENDIF

oMSNewGe2 := MsNewGetDados():New( 170, 007, 255, 486, IF(nOpcX == 3 .OR. nOpcX == 4,GD_INSERT+GD_DELETE+GD_UPDATE,0), "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "U_CTB05MVB()", "", "AllwaysTrue", oPanel1, aHead2, aCols2)
oMSNewGe2:oBrowse:bLostFocus	:= {|| lRetorno := oMSNewGe2:TudoOk(),lRetorno := U_CTB05MVB(),aCols2:=IIf(lRetorno,oMSNewGe2:aCols,aCols2),lRetorno }                              

Return
//-----------------------------------------------------------------------
/*{Protheus.doc} CTB05MVB
@Validação da Getdados 2
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------         
USER FUNCTION CTB05MVB
Local lRet := .T.  
Local nJ   := 0
                                           
IF nOpcX <> 3 .AND. nOpcx <> 4
	RETURN(lRet)
ENDIF
                   
IF lRet	 
	IF READVAR() == "M->Z6_EMPCONS" .AND. TYPE("M->Z6_EMPCONS") <> "U"
		IF EMPTY(M->Z6_EMPCONS) .OR. LEN(ALLTRIM(M->Z6_EMPCONS)) < LEN(cEmpAnt+cFilAnt)
			ApMsgAlert("Informe um código de empresa válida.")
			lRet := .F.
		ENDIF

		IF lRet 
			// Valida se a empresa a consolidar é a mesma que a consolidada, e se é o tipo de saldo 1
			IF M->Z6_EMPCONS ==  oMSNewGe1:aCols[oMSNewGe1:NAT][aScan(aHead1,{|x| AllTrim(x[2]) == "Z6_EMP"})]
				ApMsgAlert("Consolidada e consolidadora devem ser diferentes.")
				lRet := .F.
			ENDIF
        ENDIF
		
		IF lRet		
			IF EMPTY(POSICIONE("SZ0",1,XFILIAL("SZ0")+cRevisao+ALLTRIM(M->Z6_EMPCONS),"Z0_RAZAO"))
				ApMsgAlert("Empresa não cadastrada.")
				lRet := .F.
			ELSE
				oMSNewGe2:aCols[oMSNewGe2:nAT][aScan(aHead2,{|x| AllTrim(x[2]) == "Z6_NMCONS"})] := SZ0->Z0_RAZAO
			ENDIF	             	
		ENDIF
	ENDIF	                     
ENDIF	                     
             
             
IF lRet
	IF READVAR() == "M->Z6_TPSALDO" .AND. TYPE("M->Z6_TPSALDO") <> "U"
	
		IF M->Z6_TPSALDO <> "*"
			IF !ExistCpo("SX5","SL"+M->Z6_TPSALDO)                                                                                              
				lRet := .F.
				M->Z6_TPSALD := " "
			ENDIF
		ENDIF               

        IF lRet

			// Só posso repetir a consolidadora se for outro tipo de saldo
			cTesta := oMSNewGe2:aCols[oMSNewGe2:nAT][aScan(aHead2,{|x| AllTrim(x[2]) == "Z6_EMPCONS"})]           
			FOR nJ := 1 TO LEN(oMSNewGe2:aCols)
				IF nJ <> oMSNewGe2:NAT
					IF oMSNewGe2:aCols[nJ][aScan(aHead2,{|x| AllTrim(x[2]) == "Z6_EMPCONS"})] == cTesta .AND. oMSNewGe2:aCols[nJ][aScan(aHead2,{|x| AllTrim(x[2]) == "Z6_TPSALDO"})] == M->Z6_TPSALDO
						ApMsgAlert("Empresa e tipo de saldo incorreto.")
						lRet := .F.				
					ENDIF	
				ENDIF
			NEXT
		ENDIF				
	ENDIF	
ENDIF
                                    
IF lRet                      
	IF (nPos := ASCAN(aColsX,{|x| ALLTRIM(x[1]) == ALLTRIM(cFilSet)})) == 0
		AADD(aColsX,{cFilSet,oMSNewGe2:aCols})      
	ELSE
		aColsX[nPos][2] := oMSNewGe2:aCols
	ENDIF 
ENDIF
	
RETURN(lRet)          
//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTB05C
@Efetua cópia da estrutura 
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------                                                                                                 
USER FUNCTION ASCTB05C
Local aParam := {}                
Local aBox   := {}    
Local cCadastro := "Cópia da Estrutura de Consolidação"
Local cEstOri   := ""
Local cEstDes   := ""
Local cDescDes  := ""
Local lContinua := .T.

                      
AADD(aBox,	{ 1, "Estrutura de Origem", Space(3),"@!","" ,"",".T.",20,.T.	}) 
AADD(aBox,	{ 1, "Estrutura de Destino",Space(3),"@!","" ,"",".T.",20,.T.	}) 
AADD(aBox,	{ 1, "Descrição",Space(TAMSX3("Z6_DESCRI")[1]),"@!","" ,"",".T.",50,.T.	}) 

If ParamBox( aBox,cCadastro,aParam,,,,,,,,.F.,.T.)

    IF LEN(ALLTRIM(aParam[1])) < 3 .OR. LEN(ALLTRIM(aParam[2])) < 3
    	ApMsgAlert("Codigo de Estrutura incorreto.")
    ELSE

		cEstOri := ALLTRIM(aParam[1])
		cEstDes := ALLTRIM(aParam[2])
		cDescDes:= ALLTRIM(aParam[3])		

	    // Verifico se destino já existe
		cQ := "SELECT Z6_CODIGO, R_E_C_N_O_ AS REG FROM "+RetSqlName("SZ6")
		cQ += " WHERE Z6_FILIAL = '"+XFILIAL("SZ6")+"' "
		cQ += " AND Z6_CODIGO = '"+cEstDes+"'"
		cQ += " AND D_E_L_E_T_ = ' '"
		TcQuery ChangeQuery(cQ) ALIAS "XSZ6" NEW
		IF XSZ6->REG <> 0                                
			ApMsgAlert("Estrutura destino já existe!")
			lContinua := .F.
		ENDIF
		XSZ6->(DBCLOSEAREA())   

		IF lContinua       
		    // Localizo origem
			cQ := "SELECT Z6_CODIGO, Z6_DESCRI, Z6_EMP, Z6_SEQ, Z6_EMPCONS, Z6_TPSALDO, R_E_C_N_O_ AS REG  FROM "+RetSqlName("SZ6")
			cQ += " WHERE Z6_FILIAL = '"+XFILIAL("SZ6")+"' "
			cQ += " AND Z6_CODIGO = '"+cEstOri+"'"
			cQ += " AND D_E_L_E_T_ = ' '"
			TcQuery ChangeQuery(cQ) ALIAS "XSZ6" NEW
			IF XSZ6->REG == 0                                
				ApMsgAlert("Não localizado a Estrutura de origem!")
			ELSE
				WHILE XSZ6->(!EOF())
					RECLOCK("SZ6",.T.)
					SZ6->Z6_FILIAL := XFILIAL("SZ6")
					SZ6->Z6_CODIGO := cEstDes
					SZ6->Z6_DESCRI := cDescDes
					SZ6->Z6_EMP    := XSZ6->Z6_EMP
					SZ6->Z6_SEQ    := XSZ6->Z6_SEQ
					SZ6->Z6_EMPCONS:= XSZ6->Z6_EMPCONS
					SZ6->Z6_TPSALDO:= XSZ6->Z6_TPSALDO
					MsUnlock()	 
					XSZ6->(DBSKIP())
				END
				ApMsgInfo("Cópia concluida!")
			ENDIF	 
			XSZ6->(DBCLOSEAREA())
		ENDIF	
	ENDIF
ENDIF
Return  
//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTB05I
@Impressão da estrutura de consolidação 
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------            
USER Function ASCTB05I
Local oReport        
Local aParam := {}                
Local aBox   := {}    
Private cCod := SPACE(3)

AADD(aBox,	{ 1, "Codigo da estrutura", Space(3),"@!","" ,"",".T.",20,.T.	}) 

If ParamBox( aBox,"Cópia da Estrutura",aParam,,,,,,,,.F.,.T.)
	cCod := ALLTRIM(aParam[1])
	oReport := Report()
	oReport:PrintDialog()
ENDIF
RETURN()
//-----------------------------------------------------------------------
/*{Protheus.doc} Report
@Monta objeto de impressão
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------            
Static Function Report()
Local oReport 
Local oSection1
Local oCell         
Local aOrdem   := {}                                                                

oReport:= TReport():New("ASCTB05I","Estrutura de Consolidação","", {|oReport| Ledados(oReport)},"Estrutura de Consolidação") 

oReport:SetLandscape()
oReport:SetTotalInLine(.F.)

oSection1 := TRSection():New(oReport,"Estrutura de Consolidação",{})
oSection1:SetTotalInLine(.F.)
oSection1:SetHeaderPage()
oSection1:SetEditCell(.F.)                        
                                                                                          
TRCell():New(oSection1,"EMPCONS"  ,,"Consolidante"  ,/*Picture*/,15,.F., {|| IMPCONS->Z6_EMPCONS})
TRCell():New(oSection1,"NOME2"    ,,""              ,/*Picture*/,50,.F., {|| POSICIONE("SZ0",1,XFILIAL("SZ0")+cRevisao+ALLTRIM(IMPCONS->Z6_EMPCONS),"Z0_RAZAO")})
TRCell():New(oSection1,"TPSALDO"  ,,"Tipo de Saldo" ,/*Picture*/,15,.F., {|| IMPCONS->Z6_TPSALDO})
Return(oReport)
//-----------------------------------------------------------------------
/*{Protheus.doc} Ledados
@Seleciona os dados de impressão
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
Local nReg      := 0
Local nOrdem    := 1
Local cEtapa    := ""

IF SELECT("IMPCONS") <> 0
	IMPCONS->(DBCLOSEAREA())                        
ENDIF	

cQ := "SELECT Z6_EMP, Z6_SEQ , Z6_EMPCONS, Z6_TPSALDO"
cQ += " FROM "+RetSqlName("SZ6")+" SZ6 "   
cQ += " WHERE Z6_CODIGO = '"+cCod+"' AND D_E_L_E_T_ <> '*' "
cQ += " ORDER BY Z6_SEQ"
cQ	:= ChangeQuery(cQ)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),"IMPCONS",.T.,.T.)
                                                    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

IMPCONS->(dbEval({|| nReg++ },,{|| !Eof()}))
IMPCONS->(dbGoTop())  
oReport:SetMeter(nReg)

oSection1:Init()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("IMPCONS")  
While !oReport:Cancel() .and. !IMPCONS->(Eof())

	If oReport:Cancel()
		Exit
	EndIf
                  
	IF cEtapa <> IMPCONS->Z6_EMP
		cEtapa := IMPCONS->Z6_EMP
		oReport:SkipLine()   
		oReport:PrintText("ETAPA: "+IMPCONS->Z6_SEQ+" - "+IMPCONS->Z6_EMP+" - "+POSICIONE("SZ0",1,XFILIAL("SZ0")+cRevisao+ALLTRIM(IMPCONS->Z6_EMP),"Z0_RAZAO") )
		oReport:SkipLine()   
	ENDIF

	oSection1:PrintLine()
	    
   	dbSelectArea("IMPCONS")
   	dbSkip()

	oReport:IncMeter()
EndDo

oReport:SkipLine()

IMPCONS->(DbCloseArea())

oSection1:Finish()

Return()
//-----------------------------------------------------------------------
/*{Protheus.doc} MenuDef
@Definição de aRotina 
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------            
Static Function MenuDef()
Local aRotina :=  { {"Pesquisar" ,"AxPesqui" ,0,1},;
					{"Visualizar","U_ASCTB05M",0,2},;
					{"Incluir"   ,"U_ASCTB05M",0,3},;
					{"Alterar"   ,"U_ASCTB05M",0,4},;
					{"Excluir"   ,"U_ASCTB05M",0,5},;
					{"Copiar"    ,"U_ASCTB05C",0,4},;
					{"Impressão" ,"U_ASCTB05I",0,4},;
					{"Consolida" ,"U_ASCTBA06",0,4},;
					{"Monitor Cons." ,"U_ASCTBA08",0,4}}
Return aRotina        