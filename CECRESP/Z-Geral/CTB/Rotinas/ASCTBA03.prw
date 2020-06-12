#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'

Static cRevisao := "000"

//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTBA03
@Cadastro de Investidoras x Investidas x Eventos de Equivalência 
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------
User Function ASCTBA03
Private cTitulo 	:= OEMTOANSI("Estrutura de Participação")    
Private cCadastro 	:= cTitulo
Private aRotina 	:= MenuDef()
Private cDelFunc 	:= ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString  	:= "SZ2"
Private nControl 	:= 0 
Private cFilter    	:= Nil                              
Private cChave 		:= SZ2->(IndexKey())
Private lDefTop 	:= !(TcSrvType() == "AS/400" .Or. TcSrvType() == "iSeries")
Private cRevisao	:= "000"
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

mBrowse( 6, 1,22,75,"SZ2",,,,,,,,,,,,,,Iif(lDefTop,cFilter,Nil))

Return                
//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTB03M
@Manutenção do Cadastro de Investidoras x Investidas x Eventos de Equivalência 
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------
User Function ASCTB03M(cAlias,nReg,nOpc)
Local lOk		:= .F.
Local bOk       := {|| IIf(!TudoOK(),(lOk	:= .F.), (lOk	:= .T., oDlg:End()) ) }
Local bCancel   := {|| (lOk	:= .F., oDlg:End()) }
Local nX    	:= 0
Private oGet_Emp1
Private oGet_Emp2    
Private oSay_Grp    
Private cGet_Emp:= SPACE(TAMSX3("Z0_EMPRESA")[1])
Private cGet_Des:= SPACE(TAMSX3("Z0_RAZAO")[1])
Private dTBase  := CTOD(SPACE(8))
Private oGroup1
Private oGroup2
Private oPanel1           
Private nOpcx := nOpc
Private aHead1 := {}
Private aCols1 := {}
Private oMSNewGe1
Static oDlg        

DEFINE FONT oBold3	NAME "Arial" SIZE 0, -15 BOLD
          
                                              
IF nOpcX <> 3                
	dTBase   := SZ2->Z2_DTBASE 
	cGet_Emp := SZ2->Z2_EMP
	cGet_Des := POSICIONE("SZ0",1,XFILIAL("SZ0")+cRevisao+SZ2->Z2_EMP,"Z0_RAZAO")
ELSE
	dTBase   := FirstDay(dDataBase)
ENDIF	

DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000, 000  TO 600, 1000 COLORS 0, 16777215 PIXEL
@ 032, 003 MSPANEL oPanel1 SIZE 685, 285 OF oDlg COLORS 0, 16777215 RAISED
@ 003, 003 GROUP oGroup1 TO 045, 493 PROMPT "Empresa Investidora" OF oPanel1 COLOR 0, 16777215 PIXEL
@ 014, 007 MSGET oGet_Emp1 VAR cGet_Emp F3 "SZ0" WHEN nOpcx == 3 SIZE 057, 010 OF oPanel1 COLORS 0, 16777215 PIXEL VALID _EMPPAR()
@ 014, 080 MSGET oGet_Emp2 VAR cGet_Des  WHEN .F. SIZE 200, 010 OF oPanel1 COLORS 0, 16777215 PIXEL                        
@ 014, 300 SAY   oSay_Grp PROMPT "Data Base: "+DTOC(dTBase) SIZE 100, 015 OF oPanel1 COLORS 255, 16777215 PIXEL FONT oBold3

@ 053, 003 GROUP oGroup2 TO 265, 493 PROMPT "Investidas" OF oPanel1 COLOR 0, 16777215 PIXEL
INVESTIDAS()
ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, bOk, bCancel)
IF lOK

	IF nOpcX == 3 .OR. nOpcX == 4
                                                              
		// GARANTO QUE NAO EXISTE UM SZ2
		nRet := TCSQLEXEC("DELETE FROM "+RetSqlName("SZ2")+" WHERE Z2_FILIAL = '"+XFILIAL("SZ2")+"' AND Z2_DTBASE = '"+DTOS(dTBase)+"' AND Z2_EMP = '"+cGet_Emp+"' ")
		TCRefresh(RetSqlName("SZ2"))
	    IF nRet > 0
	    	ApMsgAlert("Erro na manutenção do cadastro atual.")
	   	ENDIF	
             
		IF nRet == 0

			// Atualiza SZ2
			SZ2->(DBSETORDER(1))
			FOR nX := 1 TO LEN(oMSNewGe1:aCols)
				IF !oMSNewGe1:aCols[nX][LEN(oMSNewGe1:aCols[nX])] .AND. !EMPTY(oMSNewGe1:aCols[nX][aScan(aHead1,{|x| AllTrim(x[2]) == "Z2_EMPPAR"})])
					RECLOCK("SZ2",.T.)
					SZ2->Z2_FILIAL:= XFILIAL("SZ2")
					SZ2->Z2_DTBASE:= dTBase 	
					SZ2->Z2_EMP   := ALLTRIM(cGet_Emp)             
					SZ2->Z2_EMPPAR:= oMSNewGe1:aCols[nX][aScan(aHead1,{|x| AllTrim(x[2]) == "Z2_EMPPAR"})]
		            SZ2->Z2_QUANT := oMSNewGe1:aCols[nX][aScan(aHead1,{|x| AllTrim(x[2]) == "Z2_QUANT"})]
		            SZ2->Z2_EVENTOS:= oMSNewGe1:aCols[nX][aScan(aHead1,{|x| AllTrim(x[2]) == "Z2_EVENTOS"})]		            
					SZ2->(MsUnlock())					
				ENDIF
			NEXT nX
		ENDIF
	ENDIF	

	IF nOpcX == 5
			// Atualiza SZ2 
			cQ := "SELECT R_E_C_N_O_ AS REG FROM "+RetSqlName("SZ2")
			cQ += " WHERE Z2_FILIAL = '"+XFILIAL("SZ2")+"'"
			cQ += " AND Z2_EMP    = '"+cGet_Emp+"'"
			cQ == " AND Z2_DTBASE = '"+DTOS(dTBase)+"'"
			cQ += " AND D_E_L_E_T_ = ' '"
			TcQuery ChangeQuery(cQ) ALIAS "XSZ2" NEW
			WHILE XSZ2->(!EOF())
				SZ2->(DBGOTO(XSZ2->REG))
				RECLOCK("SZ2",.F.)
				SZ2->(DBDELETE())
				SZ2->(MsUnlock())
				XSZ2->(DBSKIP())
			END   
			XSZ2->(DBCLOSEAREA())               
	ENDIF	
	
ENDIF
RETURN                                                                   
//-----------------------------------------------------------------------
/*{Protheus.doc} _EMPPAR
@Valida o codigo da investidora
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------
STATIC FUNCTION _EMPPAR()
Local lRet		:= .T.
Local aArea     := GETAREA()

// Verifica se existe a empresa

SZ0->(DBSETORDER(1))         
IF !SZ0->(DBSEEK(XFILIAL("SZ0")+cRevisao+ALLTRIM(cGet_Emp)))
	ApMsgAlert("Empresa não cadastrada!")
	lRet := .F.
	cGet_Des := SPACE(LEN(SZ0->Z0_RAZAO))
ELSE
	cGet_Des := SZ0->Z0_RAZAO
ENDIF
oGet_Emp2:Refresh()
                               
// Verifica se já existe uma estrutura de participação para este investidor                   
cQ := "SELECT R_E_C_N_O_ AS REG FROM "+RetSqlName("SZ2")
cQ += " WHERE Z2_FILIAL = '"+XFILIAL("SZ2")+"'"
cQ += " AND Z2_EMP    = '"+cGet_Emp+"'"
cQ == " AND Z2_DTBASE = '"+DTOS(dTBase)+"'"
cQ += " AND D_E_L_E_T_ = ' '"
TcQuery ChangeQuery(cQ) ALIAS "XSZ2" NEW
IF XSZ2->REG > 0 .AND. nOpcX == 3
	ApMsgAlert("Ja existe estrutura de participacao para esta empresa.")
	lRet := .F.
ENDIF
XSZ2->(DBCLOSEAREA())                       

RESTAREA(aArea)

RETURN(lRet)
//-----------------------------------------------------------------------
/*{Protheus.doc} Investidas
@Manutenção do cadastro de investidasValida a conta contábil da investidora
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------
Static Function Investidas
Local nX
Local aFieldFill := {}
Local aFields := {}
Local aAlterFields := {}
Local aNames	:= {}

AADD(aFields,"Z2_EMPPAR")                                          
AADD(aNames,"Investida")
AADD(aFields,"Z2_NMTIDA")
AADD(aNames,"Razão Social")
AADD(aFields,"Z0_CONTA")  
AADD(aNames, "Cta. Invest. Ativo")
AADD(aFields,"Z0_CTPASS")         
AADD(aNames, "Cta. Invest. Passivo")
AADD(aFields,"Z0_CTMEPRP")   
AADD(aNames, "Cta. MEP Resultado +")                                                                                   
AADD(aFields,"Z0_CTMEPRN")   
AADD(aNames, "Cta. MEP Resultado -")                                                                                   
AADD(aFields,"Z0_CTRESN")   
AADD(aNames, "Cta. Result. PL (-) Nac./Ext.")                                                                                  
AADD(aFields,"Z0_ITEMCTA")        
AADD(aNames, "Item Contábil")                                  
AADD(aFields,"Z0_MOEDA")        
AADD(aNames, "Moeda")                                  
AADD(aFields,"Z0_QTACOES")   
AADD(aNames, "Qt. Ações")
AADD(aFields,"Z2_QUANT") 
AADD(aNames, "Participação")
AADD(aFields,"Z2_EVENTOS")
AADD(aNames, "Eventos")
                                                                                 
IF nOpcX == 3 .OR. nOpcX == 4
	AADD(aAlterFields,"Z2_EMPPAR")
	AADD(aAlterFields,"Z2_QUANT")
	AADD(aAlterFields,"Z2_EVENTOS")
ENDIF

// Define field properties
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFields)
	IF SX3->(DbSeek(aFields[nX]))
		Aadd(aHead1, {aNames[nX],SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
    Endif
Next nX

IF nOpcX == 3 // Gera o Acols vazio
	For nX := 1 to Len(aFields)
		If SX3->(DbSeek(aFields[nX]))
			Aadd(aFieldFill, CriaVar(SX3->X3_CAMPO))
		Endif
	Next nX
	Aadd(aFieldFill, .F.)
	Aadd(aCols1, aFieldFill)
ELSE // Atualiza o Acols com os dados existentes
	cQ := "SELECT Z2_EMPPAR, Z2_QUANT, Z2_EVENTOS"
	cQ += " FROM "+RetSqlName("SZ2") 
	cQ += " WHERE Z2_FILIAL = '"+XFILIAL("SZ2")+"'"
	cQ += " AND Z2_EMP    = '"+ALLTRIM(cGet_Emp)+"'"
	cQ += " AND Z2_DTBASE = '"+DTOS(dTBase)+"'"
	cQ += " AND D_E_L_E_T_ = ' '"
	TcQuery ChangeQuery(cQ) ALIAS "XSZ2" NEW

	WHILE XSZ2->(!EOF())                          
		Aadd(aFieldFill, XSZ2->Z2_EMPPAR)
		Aadd(aFieldFill, POSICIONE("SZ0",1,XFILIAL("SZ0")+cRevisao+XSZ2->Z2_EMPPAR,"Z0_RAZAO"))
		Aadd(aFieldFill, SZ0->Z0_CONTA)
		Aadd(aFieldFill, SZ0->Z0_CTPASS)
		AADD(aFieldFill, SZ0->Z0_CTMEPRP)  			
		AADD(aFieldFill, SZ0->Z0_CTMEPRN)  				
		AADD(aFieldFill, SZ0->Z0_CTRESN)  					
		Aadd(aFieldFill, SZ0->Z0_ITEMCTA)		
		Aadd(aFieldFill, SZ0->Z0_MOEDA)				
		Aadd(aFieldFill, SZ0->Z0_QTACOES)
		Aadd(aFieldFill, XSZ2->Z2_QUANT)		
		Aadd(aFieldFill, XSZ2->Z2_EVENTOS)
		Aadd(aFieldFill, .F.)
		Aadd(aCols1, aFieldFill)		
		XSZ2->(DBSKIP())  
		aFieldFill := {}
	END
	XSZ2->(DBCLOSEAREA())
ENDIF               
	
oMSNewGe1 := MsNewGetDados():New( 065, 008, 260, 490, IF(nOpcX == 3 .OR. nOpcX == 4,GD_INSERT+GD_DELETE+GD_UPDATE,0), "AllwaysTrue", "AllwaysTrue",, aAlterFields,, 999, "U_ASCTB03V()", "","AllwaysTrue", oPanel1, aHead1, aCols1)
oMSNewGe1:oBrowse:bChange	:= {|| lRetorno := .T.,U_ASCTB03V(),lRetorno }                              

Return                                                                                        
//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTB03V
@Valida as informações da getdados
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------
USER FUNCTION ASCTB03V
Local nPos := 0                                           
Local lRet := .T.

IF READVAR() == "M->Z2_EMPPAR" .AND. TYPE("M->Z2_EMPPAR") <> "U"      
	IF EMPTY(M->Z2_EMPPAR)
		MSGALERT("Informe um código de empresa válido.")
		lRet := .F.
	ENDIF	                                                                                                                   
	
	IF (nPos := ASCAN(oMSNewGe1:aCols,{|x| ALLTRIM(x[1]) == ALLTRIM(M->Z2_EMPPAR)})) > 0 .AND. nPos <> oMSNewGe1:NAT .AND. lRet
		MSGALERT("Empresa ja informada.")
		lRet := .F.              
		oMSNewGe1:aCols[oMSNewGe1:nAT][aScan(aHead1,{|x| AllTrim(x[2]) == "Z0_CONTA"})] := SPACE(TAMSX3("Z0_CONTA")[1])		
		oMSNewGe1:aCols[oMSNewGe1:nAT][aScan(aHead1,{|x| AllTrim(x[2]) == "Z0_CTPASS"})] := SPACE(TAMSX3("Z0_CTPASS")[1])				
		oMSNewGe1:aCols[oMSNewGe1:nAT][aScan(aHead1,{|x| AllTrim(x[2]) == "Z0_CTMEPRP"})] := SPACE(TAMSX3("Z0_CTMEPRP")[1])						
		oMSNewGe1:aCols[oMSNewGe1:nAT][aScan(aHead1,{|x| AllTrim(x[2]) == "Z0_CTMEPRN"})] := SPACE(TAMSX3("Z0_CTMEPRN")[1])								
		oMSNewGe1:aCols[oMSNewGe1:nAT][aScan(aHead1,{|x| AllTrim(x[2]) == "Z0_CTRESN"})] := SPACE(TAMSX3("Z0_CTRESN")[1])										
		oMSNewGe1:aCols[oMSNewGe1:nAT][aScan(aHead1,{|x| AllTrim(x[2]) == "Z0_ITEMCTA"})] := SPACE(TAMSX3("Z0_ITEMCTA")[1])				
		oMSNewGe1:aCols[oMSNewGe1:nAT][aScan(aHead1,{|x| AllTrim(x[2]) == "Z0_MOEDA"})] := SPACE(TAMSX3("Z0_MOEDA")[1])						
		oMSNewGe1:aCols[oMSNewGe1:nAT][aScan(aHead1,{|x| AllTrim(x[2]) == "Z2_NMTIDA"})] := SPACE(TAMSX3("Z2_NMTIDA")[1])
		oMSNewGe1:aCols[oMSNewGe1:nAT][aScan(aHead1,{|x| AllTrim(x[2]) == "Z0_QTACOES"})] := 0
	ELSE   
		IF EMPTY(POSICIONE("SZ0",1,XFILIAL("SZ0")+cRevisao+ALLTRIM(M->Z2_EMPPAR),"Z0_RAZAO"))
			MSGALERT("Empresa não cadastrada.")
			lRet := .F.
		ELSE
			IF ALLTRIM(M->Z2_EMPPAR) == ALLTRIM(cGet_Emp)
				MSGALERT("A Empresa investida não pode ser igual a investidora.")
				lRet := .F.			
            ELSE                                                                                                 
				oMSNewGe1:aCols[oMSNewGe1:nAT][aScan(aHead1,{|x| AllTrim(x[2]) == "Z2_NMTIDA"})]  := SZ0->Z0_RAZAO            
				oMSNewGe1:aCols[oMSNewGe1:nAT][aScan(aHead1,{|x| AllTrim(x[2]) == "Z0_CONTA"})]   := SZ0->Z0_CONTA
				oMSNewGe1:aCols[oMSNewGe1:nAT][aScan(aHead1,{|x| AllTrim(x[2]) == "Z0_CTPASS"})]  := SZ0->Z0_CTPASS				
				oMSNewGe1:aCols[oMSNewGe1:nAT][aScan(aHead1,{|x| AllTrim(x[2]) == "Z0_CTMEPRP"})] := SZ0->Z0_CTMEPRP
				oMSNewGe1:aCols[oMSNewGe1:nAT][aScan(aHead1,{|x| AllTrim(x[2]) == "Z0_CTMEPRN"})] := SZ0->Z0_CTMEPRN
				oMSNewGe1:aCols[oMSNewGe1:nAT][aScan(aHead1,{|x| AllTrim(x[2]) == "Z0_CTRESN"})]  := SZ0->Z0_CTRESN
				oMSNewGe1:aCols[oMSNewGe1:nAT][aScan(aHead1,{|x| AllTrim(x[2]) == "Z0_ITEMCTA"})] := SZ0->Z0_ITEMCTA
				oMSNewGe1:aCols[oMSNewGe1:nAT][aScan(aHead1,{|x| AllTrim(x[2]) == "Z0_MOEDA"})]   := SZ0->Z0_MOEDA				
				oMSNewGe1:aCols[oMSNewGe1:nAT][aScan(aHead1,{|x| AllTrim(x[2]) == "Z0_QTACOES"})] := SZ0->Z0_QTACOES

			ENDIF				
		ENDIF	
	ENDIF			
ENDIF	                                                        

IF lRet .AND. READVAR() == "M->Z2_QUANT" .AND. TYPE("M->Z2_QUANT") <> "U" 
	cQ := "SELECT Z0_QTACOES FROM "+RetSqlName("SZ0")
	cQ += " WHERE Z0_FILIAL = '"+XFILIAL("SZ0")+"'"
	cQ += " AND Z0_REVISAO = '"+cRevisao+"' "
	cQ += " AND Z0_EMPRESA  = '"+oMSNewGe1:aCols[oMSNewGe1:nAT][aScan(aHead1,{|x| AllTrim(x[2]) == "Z2_EMPPAR"})]+"'"
	cQ += " AND D_E_L_E_T_ = ' '"
	TcQuery ChangeQuery(cQ) ALIAS "XSZ0" NEW

	IF XSZ0->Z0_QTACOES < M->Z2_QUANT
		ApMsgAlert("Quantidade de ações informada é maior que a quantidade disponível.")
		lRet := .F.
	ENDIF                             
	XSZ0->(DBCLOSEAREA())

ENDIF

IF lRet
	IF READVAR() == "M->Z2_EVENTOS"
		oMSNewGe1:aCols[oMSNewGe1:nAT][aScan(aHead1,{|x| AllTrim(x[2]) == "Z2_EVENTOS"})] := Eventos(M->Z2_EVENTOS)
		oMSNewGe1:Refresh()
	ENDIF
ENDIF
RETURN(lRet)
//-----------------------------------------------------------------------
/*{Protheus.doc} TudoOK
@Validação geral na confirmação da tela
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------                                           
Static Function TudoOK
Local lRet := .T.

DO CASE
	// Valida o codigo da Investidora
	CASE EMPTY(cGet_Emp)                                                                  
		ApMsgAlert("Informe o código da investidora.")
		lRet := .F.
	CASE !_EMPPAR()
		lRet := .F.
END
RETURN(lRet)                               
//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTB03C
@Efetua cópia da estrutura para o periodo atual
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------                                                                                                 
USER FUNCTION ASCTB03C
Local aParam := {}                
Local aBox   := {}    
Local cCadastro := "Cópia da Estrutura de Participação"
Local cMesOri   := ""
Local cMesDes   := ""
Local lContinua := .T.    
                      
AADD(aBox,	{ 1, "Mes e ano de origem", Space(6),"@!","" ,"",".T.",20,.T.	}) 
AADD(aBox,	{ 1, "Mes e ano destino",   Space(6),"@!","" ,"",".T.",20,.T.	}) 

If ParamBox( aBox,cCadastro,aParam,,,,,,,,.F.,.T.)

    IF LEN(ALLTRIM(aParam[1])) < 6 .OR. LEN(ALLTRIM(aParam[2])) < 6
    	ApMsgAlert("Mes e ano incorretos.")
    ELSE

		cMesOri := SUBSTR(ALLTRIM(aParam[1]),3,4)+SUBSTR(ALLTRIM(aParam[1]),1,2)+"01"
		cMesDes := CTOD("01/"+SUBSTR(ALLTRIM(aParam[2]),1,2)+"/"+SUBSTR(ALLTRIM(aParam[2]),3,4))
	
	    // Verifico se destino já existe
		cQ := "SELECT R_E_C_N_O_ AS REG FROM "+RetSqlName("SZ2")
		cQ += " WHERE Z2_FILIAL = '"+XFILIAL("SZ2")+"' "
		cQ += " AND Z2_DTBASE = '"+DTOS(cMesDes)+"'"
		cQ += " AND D_E_L_E_T_ = ' '"
		TcQuery ChangeQuery(cQ) ALIAS "XSZ2" NEW
		IF XSZ2->REG <> 0                                
			ApMsgAlert("Mes destino já existe!")
			lContinua := .F.
		ENDIF
		XSZ2->(DBCLOSEAREA())
		
		IF lContinua
	
			cQ := "SELECT Z2_EMP, Z2_EMPPAR, Z2_QUANT, Z2_EVENTOS, R_E_C_N_O_ AS REG FROM "+RetSqlName("SZ2")
			cQ += " WHERE Z2_FILIAL = '"+XFILIAL("SZ2")+"' "
			cQ += " AND Z2_DTBASE = '"+cMesOri+"'"
			cQ += " AND D_E_L_E_T_ = ' '"
			TcQuery ChangeQuery(cQ) ALIAS "XSZ2" NEW
	
			IF XSZ2->REG == 0
				ApMsgAlert("Não localizado dados de origem!")
			ELSE
				WHILE XSZ2->(!EOF())
					RECLOCK("SZ2",.T.)
					SZ2->Z2_FILIAL := XFILIAL("SZ2")			          
					SZ2->Z2_DTBASE:= cMesDes
					SZ2->Z2_EMP   := XSZ2->Z2_EMP
					SZ2->Z2_EMPPAR:= XSZ2->Z2_EMPPAR
   			        SZ2->Z2_QUANT := XSZ2->Z2_QUANT
    		        SZ2->Z2_EVENTOS:= XSZ2->Z2_EVENTOS
					MsUnlock()	 
					XSZ2->(DBSKIP())
				END 
				ApMsgInfo("Cópia concluida!")
			ENDIF
			XSZ2->(DBCLOSEAREA())				
		ENDIF
	ENDIF
ENDIF
Return
//-----------------------------------------------------------------------
/*{Protheus.doc} EVENTOS
@Seleciona os eventos
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------            
Static Function Eventos(pEventos)
Local oDlg
Private	oOk := LoadBitmap(GetResources(),"LBOK")
Private	oNo := LoadBitmap(GetResources(),"LBNO")
Private	oMainLst, aMainLst := {}   
Private cRet:= ""          
Private cEventos := pEventos

Define MsDialog oDlg Title "Eventos de Equivalência" From (100),(100) to (300),(800) Pixel
@02,05 Say "Eventos" Size 20,12 COLOR CLR_BLACK PIXEL OF oDlg
@10,05 ListBox oMainLst Fields Header "","Codigo","Descrição","Formula" Pixel Size 350,070 of oDlg ;
		on dblClick(aMainLst[oMainLst:nAt,1] := !aMainLst[oMainLst:nAt,1], oMainLst:Refresh())
		
@83,05 Button  "Cancelar" Size 37,12 PIXEL OF oDlg action	(oDlg:end())
@83,50 Button "Confirmar" Size 37,12 PIXEL OF oDlg action	(SetList(aMainLst), (oDlg:end()))

LoadMain()
		
Activate MsDialog oDlg Centered

RETURN(cRet)                                                                         
//-----------------------------------------------------------------------
/*{Protheus.doc} LoadMain
@Carrega a lista de eventos para seleção
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------                                             
Static Function LoadMain()              
Local aInner := {}
aMainLst := {}	    
	              
cQ := "SELECT Z1_EVENTO, Z1_DESC, Z1_FORMULA FROM "+RetSqlName("SZ1")
cQ += " WHERE Z1_FILIAL = '"+XFILIAL("SZ1")+"'"
cQ += " AND D_E_L_E_T_ = ' '"
TcQuery ChangeQuery(cQ) ALIAS "XSZ1" NEW

WHILE XSZ1->(!EOF())             
	aInner := {}                
	AADD(aInner,IF(XSZ1->Z1_EVENTO$cEventos .OR.EMPTY(cEventos),.T.,.F.))  // No inicio seleciona todos os eventos
	AADD(aInner,XSZ1->Z1_EVENTO)
	AADD(aInner,XSZ1->Z1_DESC)
	AADD(aInner,XSZ1->Z1_FORMULA)
	AADD(aMainLst,aInner)
	XSZ1->(DBSKIP())
END                 
XSZ1->(DBCLOSEAREA())

oMainLst:SetArray(aMainLst)	                           
	
if Len(aMainLst) >= 1
	oMainLst:nAt := 1
		
	oMainLst:bLine := {||{iif(aMainLst[oMainLst:nAt,1],oOk,oNo),;
			aMainLst[oMainLst:nAt,2],aMainLst[oMainLst:nAt,3],aMainLst[oMainLst:nAt,4]}}
else    
	oMainLst:bLine := {||{oNo,;
		"","",""}}
	ApMsgInfo("Nenhum Evento cadastrado!")
endif                                                        
oMainLst:Refresh()
Return
//-----------------------------------------------------------------------
/*{Protheus.doc} SetList
@Seleção dos eventos marcados
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------                                                                                                          
Static Function SetList
Local nX   := 1
FOR nX := 1 TO LEN(aMainLst)
	IF aMainLst[nX,1]
		cRet += aMainLst[nX,2]+"#"
	ENDIF	
NEXT
Return
//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTB03I
@Rotina de impressão da estrutura de equivalência
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------            
USER Function ASCTB03I
Local oReport        
Local aParam := {}                
Local aBox   := {}    
Private dRef := CTOD(SPACE(8))

AADD(aBox,	{ 1, "Mes e ano de referência", Space(6),"@!","" ,"",".T.",20,.T.	}) 

If ParamBox( aBox,cCadastro,aParam,,,,,,,,.F.,.T.)
	dRef := CTOD("01/"+SUBSTR(ALLTRIM(aParam[1]),1,2)+"/"+SUBSTR(ALLTRIM(aParam[1]),3,4))
	oReport := Report()
	oReport:PrintDialog()
ENDIF

RETURN 
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
Static Function Report
Local oReport 
Local oSection1
Local oCell         
Local aOrdem   := {}                             

oReport:= TReport():New("ASCTB03I","Estrutura de Participação","", {|oReport| Ledados(oReport)},"Estrutura de Participação") 

oReport:SetLandscape()
oReport:SetTotalInLine(.F.)

oSection1 := TRSection():New(oReport,"Estrutura de Participação",{})
oSection1:SetTotalInLine(.F.)
oSection1:SetHeaderPage()
oSection1:SetEditCell(.F.)                        
                                                                                          
TRCell():New(oSection1,"PARTICI"  ,,"Participacao"  ,/*Picture*/,15,.F., {|| TRB->INVESTIDA})
TRCell():New(oSection1,"NOME"     ,,"Nome"          ,/*Picture*/,50,.F., {|| TRB->NOMEA})
TRCell():New(oSection1,"CONTA"    ,,"Cta. Invest. Ativo",/*Picture*/,50,.F., {|| TRB->CONTA})
TRCell():New(oSection1,"CONTA2"   ,,"Cta. Invest. Passivo",/*Picture*/,50,.F., {|| TRB->CTPASS})
TRCell():New(oSection1,"ITEM"     ,,"Item Contábil",/*Picture*/,50,.F.,  {|| TRB->ITEMCTA})
TRCell():New(oSection1,"ACOES"    ,,"Qt. Ações",/*Picture*/,15,.F., {|| cAcoes  := TRANSFORM(TRB->ACOES, "@E 999,999,999,999")})
TRCell():New(oSection1,"QUOTAS"   ,,"Qt. Quotas",/*Picture*/,15,.F., {|| cQuotas := TRANSFORM(TRB->QUOTAS,"@E 999,999,999,999")})
TRCell():New(oSection1,"EVENTOS"  ,,"Eventos",/*Picture*/,15,.F., {|| TRB->EVENTOS})
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
Local cEtapa    := ""  
Local cFiltro   := "Z2_DTBASE = dRef"
Private nZema    := 1
                                             
cQ := "SELECT Z2_EMP, Z2_EMPPAR, Z2_QUANT, Z2_EVENTOS"
cQ += " FROM "+RetSqlName("SZ2")+" SZ2 "   
cQ += " WHERE Z2_FILIAL = '"+XFILIAL("SZ2")+"' AND Z2_DTBASE = '"+DTOS(dRef)+"' AND D_E_L_E_T_ = ' '"
cQ += " ORDER BY Z2_EMP, Z2_EMPPAR "
TcQuery ChangeQuery(cQ) ALIAS "XSZ2" NEW
                        
MontaTRB("ORD+INVESTE+INVESTIDA") 

DBSELECTAREA("SZ2")
SET FILTER TO &(cFiltro)

WHILE XSZ2->(!EOF())    
	nControl := 0
	GravaTRB(XSZ2->Z2_EMP,XSZ2->Z2_EMPPAR,1)
	XSZ2->(DBSKIP())
END
XSZ2->(DBCLOSEAREA())   

DBSELECTAREA("SZ2")
SET FILTER TO

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

TRB->(dbEval({|| nReg++ },,{|| !Eof()}))
TRB->(dbGoTop())  
oReport:SetMeter(nReg)

oSection1:Init()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TRB")  
While !oReport:Cancel() .and. !TRB->(Eof())

	If oReport:Cancel()
		Exit
	EndIf
                  
	IF cEtapa <> TRB->ORD
		cEtapa := TRB->ORD
		oReport:SkipLine()   
		oReport:PrintText("NIVEL: "+TRB->ORD+" - "+TRB->INVESTE+" - "+TRB->NOMEE +" - Referência: "+DTOC(dRef))
		oReport:SkipLine()   
	ENDIF

	oSection1:PrintLine()
	    
   	dbSelectArea("TRB")
   	TRB->(dbSkip())

	oReport:IncMeter()
EndDo

oReport:SkipLine()

TRB->(DbCloseArea())

oSection1:Finish()

Return()                
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
Aadd( aStru,{ "NOMEE"      ,  "C",40,0})
Aadd( aStru,{ "INVESTIDA"  ,  "C",09,0})
Aadd( aStru,{ "NOMEA"      ,  "C",40,0}) 
Aadd( aStru,{ "CONTA"      ,  "C",TAMSX3("Z0_CONTA")[1],0}) 
Aadd( aStru,{ "CTPASS"     ,  "C",TAMSX3("Z0_CTPASS")[1],0}) 
Aadd( aStru,{ "ITEMCTA"    ,  "C",TAMSX3("Z0_ITEMCTA")[1],0}) 
Aadd( aStru,{ "MOEDA"      ,  "C",TAMSX3("Z0_MOEDA")[1],0}) 
Aadd( aStru,{ "ORD"        ,  "C",03,0})
Aadd( aStru,{ "ACOES"      ,  "N",17,0})
Aadd( aStru,{ "QUOTAS"     ,  "N",17,0})
Aadd( aStru,{ "EVENTOS"    ,  "C",40,0})

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
Local nReg := 0       
Local lRet := .T.    
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
	RETURN(.T.)
ENDIF
                 
SZ2->(DBSETORDER(1))
IF SZ2->(DBSEEK(XFILIAL("SZ2")+SUBSTR(pPante,1,9)+SUBSTR(pParti,1,9)+DTOS(dRef)))

	RECLOCK("TRB",.T.)
	TRB->INVESTE   := pPante
	TRB->NOMEE     := POSICIONE("SZ0",1,XFILIAL("SZ0")+cRevisao+pPante,"Z0_RAZAO")
	TRB->INVESTIDA := pParti                                             
	TRB->NOMEA     := POSICIONE("SZ0",1,XFILIAL("SZ0")+cRevisao+pParti,"Z0_RAZAO")
	TRB->CONTA     := SZ0->Z0_CONTA           
	TRB->CTPASS	   := SZ0->Z0_CTPASS
	TRB->ITEMCTA   := SZ0->Z0_ITEMCTA
	TRB->MOEDA 	   := SZ0->Z0_MOEDA
	TRB->ORD       := STRZERO(pOrdem,3)
	TRB->ACOES     := SZ0->Z0_QTACOES
	TRB->QUOTAS    := SZ2->Z2_QUANT                                                   
	TRB->EVENTOS   := SZ2->Z2_EVENTOS
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
Local aRotina :=  { {"Pesquisar","AxPesqui" ,0,1},;
					{"Visualizar","U_ASCTB03M",0,2},;
					{"Incluir"   ,"U_ASCTB03M",0,3},;
					{"Alterar"   ,"U_ASCTB03M",0,4},;
					{"Excluir"   ,"U_ASCTB03M",0,5},;
					{"Copiar"    ,"U_ASCTB03C",0,4},;
					{"Imprime"   ,"U_ASCTB03I",0,4},;
					{"Contabiliza","U_ASCTBM01",0,4}}
Return aRotina        

