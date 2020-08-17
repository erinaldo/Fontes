#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'
//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTBA01
@Cadastro de Empresas investidas e quantidade de ações 
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016                                '
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------
user function ASCTBA01()  
Local aFieldFill	:= {}
Local aFields		:= {}
Local aAlterFields	:= {}
Local aNames		:= {}
Local nX			:= 0                                 
Local lOk			:= .F.       
Local bOk       	:= {|| (lOk := .T., oDlg:End() )} 
Local bCancel   	:= {|| (lOk	:= .F., oDlg:End()) }
Local aParam := {}                
Local aBox   := {}                                 
Local aButtons		:= {}
Local lNovos		:= .F.    
Local lExclui		:= .F.    
Private	cRevisao	:= "" 
Private dRevisao	:= FirstDay(dDataBase)
Private cTitulo 	:= OEMTOANSI("Cadastro de Empresas & Quotas")    
Private cCadastro 	:= cTitulo
Private aHeader     := {}                                           
Private aCols       := {}
Private lAtualiza	:= .F.
Private dRETPER:= ""          
Static  oMSNewGe
Static  oDlg
                      
AADD(aBox,	{ 1, "Data Base", dRevisao,"@D","" ,"AGSSZ0", ".T.",50,.T.	}) 

If !ParamBox( aBox,cCadastro,aParam,,,,,,,,.F.,.T.)      
	RETURN
ENDIF

dRevisao := FirstDay(aParam[1])

IF !U_VLDSZ0(.T.)
	RETURN
ENDIF

Aadd(aButtons,{"PMSCOLOR",{||Copia()},"Copiar estrutura"})
Aadd(aButtons,{"PMSCOLOR",{||lNovos := ApMsgYesNo("Inclui novas empresas ?"), AtuSZ0EMP(lNovos), ApMsgInfo("Atualização concluida."), lOK := .T., oDlg:End()},"Atualizar Empresas"})
Aadd(aButtons,{"PMSCOLOR",{||lExclui:= ApMsgYesNo("Exclui estrutura?"), Exclui(lExclui), ApMsgInfo("Exclusão concluida."), lOK := .T., oDlg:End()},"Exclusão de estrutura"})

cTitulo+=" Revisão: "+cRevisao+" Data: "+DTOC(dRevisao)
                           
DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000, 000  TO 600, 1000 COLORS 0, 16777215 PIXEL
                        
AADD(aFields,"Z0_EMPRESA")
AADD(aNames, "Empresa")
AADD(aFields,"Z0_RAZAO")
AADD(aNames, "Razão Social")                                                                                   
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
AADD(aFields,"Z0_CNPJ")                                                                                    
AADD(aNames, "CNPJ")

         
AADD(aAlterFields,"Z0_CONTA")
AADD(aAlterFields,"Z0_CTPASS")
AADD(aAlterFields,"Z0_CTMEPRP")
AADD(aAlterFields,"Z0_CTMEPRN")
AADD(aAlterFields,"Z0_CTRESN")
AADD(aAlterFields,"Z0_ITEMCTA")
AADD(aAlterFields,"Z0_MOEDA")
AADD(aAlterFields,"Z0_QTACOES")

// Define field properties
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFields)
	If SX3->(DbSeek(aFields[nX]))
		Aadd(aHeader, {aNames[nX],SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
  		
    Endif
Next nX

cQ := "SELECT Z0_EMPRESA, Z0_RAZAO, Z0_CONTA, Z0_CTPASS, Z0_CTMEPRP, Z0_CTMEPRN, Z0_CTRESN, Z0_ITEMCTA, Z0_MOEDA, Z0_QTACOES, Z0_CNPJ FROM "+RetSqlName("SZ0")
cQ += " WHERE Z0_REVISAO = '"+cRevisao+"' AND D_E_L_E_T_ = ' '"   
cQ += " ORDER BY Z0_EMPRESA "
TcQuery ChangeQuery(cQ) ALIAS "XSZ0" NEW

WHILE XSZ0->(!EOF())
	aFieldFill := {}
	Aadd(aFieldFill, XSZ0->Z0_EMPRESA)
	AADD(aFieldFill, XSZ0->Z0_RAZAO) 
	AADD(aFieldFill, XSZ0->Z0_CONTA)  	
	AADD(aFieldFill, XSZ0->Z0_CTPASS)  		
	AADD(aFieldFill, XSZ0->Z0_CTMEPRP)  			
	AADD(aFieldFill, XSZ0->Z0_CTMEPRN)  				
	AADD(aFieldFill, XSZ0->Z0_CTRESN)  					
	AADD(aFieldFill, XSZ0->Z0_ITEMCTA)  	
	AADD(aFieldFill, XSZ0->Z0_MOEDA)  		
	AADD(aFieldFill, XSZ0->Z0_QTACOES)  				
	AADD(aFieldFill, XSZ0->Z0_CNPJ)  
	Aadd(aFieldFill, .F.)
	Aadd(aCols, aFieldFill)
    XSZ0->(DBSKIP())
END

XSZ0->(DBCLOSEAREA())

     
IF EMPTY(aCols)     
	For nX := 1 to Len(aFields)
		If SX3->(DbSeek(aFields[nX]))
      		Aadd(aFieldFill, CriaVar(SX3->X3_CAMPO))
    	Endif
  	Next nX
  	Aadd(aFieldFill, .F.)
  	Aadd(aCols, aFieldFill)
ENDIF

oMSNewGe := MsNewGetDados():New( 032, 005, 297, 500, GD_UPDATE,"AllwaysTrue", "AllwaysTrue", , aAlterFields,, 999, "AllwaysTrue", "AllwaysTrue", , , aHeader, aCols)

ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, bOk, bCancel,, aButtons)

IF lOK
    
	FOR nX := 1 TO LEN(oMSNewGe:aCols)
	
		cQ := "SELECT R_E_C_N_O_ REG FROM "+RetSqlName("SZ0")
		cQ += " WHERE Z0_REVISAO = '"+cRevisao+"' AND Z0_EMPRESA = '"+oMSNewGe:aCols[nX][aScan(aHeader,{|x| AllTrim(x[2]) == "Z0_EMPRESA"})]+"' "
		cQ += " AND D_E_L_E_T_ = ' '"
		TcQuery ChangeQuery(cQ) ALIAS "XSZ0" NEW

		IF XSZ0->REG > 0
			SZ0->(DBGOTO(XSZ0->REG))
			RECLOCK("SZ0",.F.)
			SZ0->Z0_CONTA   := oMSNewGe:aCols[nX][aScan(aHeader,{|x| AllTrim(x[2]) == "Z0_CONTA"})]			
			SZ0->Z0_CTPASS  := oMSNewGe:aCols[nX][aScan(aHeader,{|x| AllTrim(x[2]) == "Z0_CTPASS"})]			
			SZ0->Z0_CTMEPRP := oMSNewGe:aCols[nX][aScan(aHeader,{|x| AllTrim(x[2]) == "Z0_CTMEPRP"})]							
			SZ0->Z0_CTMEPRN := oMSNewGe:aCols[nX][aScan(aHeader,{|x| AllTrim(x[2]) == "Z0_CTMEPRN"})]											
			SZ0->Z0_CTRESN  := oMSNewGe:aCols[nX][aScan(aHeader,{|x| AllTrim(x[2]) == "Z0_CTRESN"})]
			SZ0->Z0_ITEMCTA := oMSNewGe:aCols[nX][aScan(aHeader,{|x| AllTrim(x[2]) == "Z0_ITEMCTA"})]						
			SZ0->Z0_MOEDA   := oMSNewGe:aCols[nX][aScan(aHeader,{|x| AllTrim(x[2]) == "Z0_MOEDA"})]										
			SZ0->Z0_QTACOES := oMSNewGe:aCols[nX][aScan(aHeader,{|x| AllTrim(x[2]) == "Z0_QTACOES"})]
			SZ0->(MsUnlock())
		ENDIF       
		XSZ0->(DBCLOSEAREA())
	NEXT nX
ENDIF	
RETURN

//-----------------------------------------------------------------------
/*{Protheus.doc} AtuSZ0EMP
@Atualiza a tabela SZ0 com os dados da tabela SIGAMAT.EMP
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------
STATIC FUNCTION AtuSZ0EMP(pNovos)
Local nRegSM0 := SM0->(RECNO())
Local nRegsSM0:= SM0->(RECCOUNT())
Local cQ	  := ""        

ProcRegua(nRegsSM0)
CTD->(DBSETORDER(1))
SM0->(DBGOTOP())   

WHILE SM0->(!EOF())
	IncProc() 
	cQ := "SELECT R_E_C_N_O_ REG FROM "+RetSqlName("SZ0")
	cQ += " WHERE Z0_REVISAO = '"+cRevisao+"' AND Z0_EMPRESA = '"+SUBSTR(SM0->M0_CODIGO,1,2)+SUBSTR(SM0->M0_CODFIL,1,7)+"' "
	cQ += " AND D_E_L_E_T_ = ' '"
	TcQuery ChangeQuery(cQ) ALIAS "XSZ0" NEW

	IF XSZ0->REG == 0 .AND. pNovos
		RECLOCK("SZ0",.T.)
		SZ0->Z0_FILIAL := XFILIAL("SZ0")
		SZ0->Z0_REVISAO:= cRevisao
		SZ0->Z0_DTREVIS:= dRevisao
		SZ0->Z0_EMPRESA:= SUBSTR(SM0->M0_CODIGO,1,2)+SUBSTR(SM0->M0_CODFIL,1,7)
	ELSE
		SZ0->(DBGOTO(XSZ0->REG))
		RECLOCK("SZ0",.F.)
	ENDIF
	SZ0->Z0_RAZAO  := SM0->M0_NOMECOM
	SZ0->Z0_CNPJ   := SM0->M0_CGC                                            
	SZ0->(MsUnlock())
	XSZ0->(DBCLOSEAREA())
 
	SM0->(DBSKIP())
END          

SM0->(DBGOTO(nRegSM0))
lAtualiza := .T.
RETURN

//-----------------------------------------------------------------------
/*{Protheus.doc} VLDSZ0
@Valida a existência da SZ0 para data base
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		06/11/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------
USER FUNCTION VLDSZ0(pMens)
Local cQ 	:= ""
Local lRet 	:= .T.         
Local lMens := pMens

IF TYPE("cRevisao") == "U" .OR. TYPE("dRevisao") == "U"
	IF(lMens,ApMsgAlert("Falha na chamada da função VLDSZ0."),"")
	RETURN(.F.)
ENDIF

cQ := "SELECT Z0_REVISAO, Z0_DTREVIS FROM "+RetSqlName("SZ0")+" WHERE 
cQ += " Z0_DTREVIS = '"+DTOS(dRevisao)+"' AND D_E_L_E_T_ = ' '"
cQ += " ORDER BY Z0_REVISAO DESC"
TcQuery ChangeQuery(cQ) ALIAS "XSZ0" NEW
IF !EMPTY(XSZ0->Z0_REVISAO)
	cRevisao := XSZ0->Z0_REVISAO
ENDIF
XSZ0->(DBCLOSEAREA())

IF EMPTY(cRevisao) 
	IF FUNNAME() == "ASCTBA01" 

   		IF ApMsgYesNo("Não existe o cadastro para : "+DTOC(dRevisao)+", deseja criar uma cópia?")
			lRet := COPIA()
		ELSE
			lRet := .F.	
		ENDIF	

	ELSE
		IF(lMens,ApMsgAlert("Não existe o cadastro de investidas para : "+DTOC(dRevisao)),"")
	    lRet := .F.

	ENDIF
ENDIF
                  
RETURN(lRet)
//-----------------------------------------------------------------------
/*{Protheus.doc} COPIA
@Efetua cópia de uma revisão
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		06/11/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------
STATIC FUNCTION COPIA
Local cQ 	:= ""
Local lRet 	:= .T.
Local aParam := {}                
Local aBox   := {}    
Local cCadastro := OEMTOANSI("Cadastro de Empresas & Quotas")    
Local dAnterior	:= CTOD(SPACE(8))                                                                                              

cQ := "SELECT MAX(Z0_DTREVIS) AS DREVIS FROM "+RetSqlName("SZ0")+" WHERE D_E_L_E_T_ = ' '"
TcQuery ChangeQuery(cQ) ALIAS "XSZ0" NEW
IF !EMPTY(XSZ0->DREVIS)
	dAnterior := STOD(XSZ0->DREVIS)
ENDIF
XSZ0->(DBCLOSEAREA())
                     
AADD(aBox,	{ 1, "Periodo de origem", dAnterior,"@D","" ,"",".T.",50,.T.	}) 
AADD(aBox,	{ 1, "Periodo destino", dRevisao, 	"@D","" ,"",".T.",50,.T.	}) 

If ParamBox( aBox,cCadastro,aParam,,,,,,,,.F.,.T.)
                           
	dAnterior:= FirstDay(aParam[1])
 	dRevisao := FirstDay(aParam[2])

	// Verifica se existe o periodo destino

	cQ := "SELECT * FROM "+RetSqlName("SZ0")
	cQ += " WHERE Z0_DTREVIS = '"+DTOS(dRevisao)+"'"
	cQ += " AND D_E_L_E_T_ = ' '"
	TcQuery ChangeQuery(cQ) ALIAS "XSZ0" NEW

  	IF XSZ0->(!EOF())
  		ApMsgAlert("Já existe uma estrutura para o periodo destino.")
  		lRet := .F.
  	ENDIF
  	
  	XSZ0->(DBCLOSEAREA())

	IF lRet

		cQ := "SELECT * FROM "+RetSqlName("SZ0")
		cQ += " WHERE Z0_DTREVIS = '"+DTOS(dAnterior)+"'"
		cQ += " AND D_E_L_E_T_ = ' '"
		TcQuery ChangeQuery(cQ) ALIAS "XSZ0" NEW

  		IF XSZ0->(EOF())
  			ApMsgAlert("Não foi localizado o periodo indicado para cópia.")
  			lRet := .F.
  		ELSE

			cQ := "SELECT MAX(Z0_REVISAO) REVISAO FROM "+RetSqlName("SZ0")+" WHERE D_E_L_E_T_ = ' '"
			TcQuery ChangeQuery(cQ) ALIAS "XREV" NEW
			cRevisao := Soma1(XREV->REVISAO)
			XREV->(DBCLOSEAREA())

  			WHILE XSZ0->(!EOF())
				RECLOCK("SZ0",.T.)
				SZ0->Z0_FILIAL 		:= XFILIAL("SZ0")
				SZ0->Z0_REVISAO		:= cRevisao
				SZ0->Z0_DTREVIS		:= dRevisao
				SZ0->Z0_EMPRESA		:= XSZ0->Z0_EMPRESA
				SZ0->Z0_RAZAO  		:= XSZ0->Z0_RAZAO
				SZ0->Z0_CNPJ   		:= XSZ0->Z0_CNPJ
				SZ0->Z0_CONTA   	:= XSZ0->Z0_CONTA
				SZ0->Z0_CTPASS  	:= XSZ0->Z0_CTPASS
				SZ0->Z0_CTMEPRP 	:= XSZ0->Z0_CTMEPRP
				SZ0->Z0_CTMEPRN 	:= XSZ0->Z0_CTMEPRN
				SZ0->Z0_CTRESN  	:= XSZ0->Z0_CTRESN
				SZ0->Z0_ITEMCTA 	:= XSZ0->Z0_ITEMCTA
				SZ0->Z0_MOEDA   	:= XSZ0->Z0_MOEDA
				SZ0->Z0_QTACOES 	:= XSZ0->Z0_QTACOES
				SZ0->(MsUnlock())  		
  				XSZ0->(DBSKIP())
  			END	
  		ENDIF        
  		XSZ0->(DBCLOSEAREA())
	ENDIF 
	          
	AtuSZ0EMP(.T.)
ELSE
	lRet := .F.
ENDIF                 

IF lRet
	ApMsgInfo("Processo concluido.")
ENDIF                  

RETURN(lRet)
//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTB01A
@Seleciona o periodo
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		26/02/2018
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------            
User Function ASCTB01A()
Local oDlga
Private	oMainLst, aMainLst := {}   

dRETPER := dRevisao

Define MsDialog oDlga Title "Periodos" From (100),(100) to (300),(300) Pixel
//@02,05 Say "Periodos" Size 20,12 COLOR CLR_BLACK PIXEL OF oDlg
@10,05 ListBox oMainLst Fields Header "Periodos" Pixel Size 100,070 of oDlga
		
@83,05 Button  "Cancelar" Size 37,12 PIXEL OF oDlg action	(oDlga:end())
@83,50 Button "Confirmar" Size 37,12 PIXEL OF oDlg action	(SetList(aMainLst), (oDlga:end()))

LoadMain()
		
Activate MsDialog oDlga Centered       

dRevisao := dRETPER                   
MV_PAR01 := dRETPER                   
oMainWnd:Refresh()

RETURN(.T.)                    
//-----------------------------------------------------------------------
/*{Protheus.doc} LoadMain
@Carrega a lista dos periodos
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
	              
cQ := "SELECT DISTINCT(Z0_DTREVIS) AS PERIODO FROM "+RetSqlName("SZ0")
cQ += " WHERE D_E_L_E_T_ = ' '"
TcQuery ChangeQuery(cQ) ALIAS "YSZ0" NEW

WHILE YSZ0->(!EOF())             
	aInner := {}                
	AADD(aInner,CTOD(SUBSTR(YSZ0->PERIODO,7,2)+"/"+SUBSTR(YSZ0->PERIODO,5,2)+"/"+SUBSTR(YSZ0->PERIODO,1,4)))         
	AADD(aMainLst,aInner)
	YSZ0->(DBSKIP())
END                 
YSZ0->(DBCLOSEAREA())

oMainLst:SetArray(aMainLst)	                           
	
if Len(aMainLst) >= 1
	oMainLst:nAt := 1
		
	oMainLst:bLine := {||{aMainLst[oMainLst:nAt,1]}}
else    
	oMainLst:bLine := {||{""}}
	ApMsgInfo("Nenhum periodo cadastrado!")
endif                                                        
oMainLst:Refresh()
Return
//-----------------------------------------------------------------------
/*{Protheus.doc} SetList
@Seleção do periodo
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------                                                                                                          
Static Function SetList
dRETPER := aMainLst[oMainLst:nAt][1]
Return                                                     
//-----------------------------------------------------------------------
/*{Protheus.doc} Exclui
@Exclui a estrutura aberta
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		01/03/2018
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------
STATIC FUNCTION Exclui(lExclui)
Local cQ := ""

cQ := "SELECT R_E_C_N_O_ REG FROM "+RetSqlName("SZ0")
cQ += " WHERE Z0_REVISAO = '"+cRevisao+"' AND Z0_DTREVIS = '"+DTOS(dRevisao)+"' "
cQ += " AND D_E_L_E_T_ = ' '"
TcQuery ChangeQuery(cQ) ALIAS "XSZ0" NEW
            
WHILE XSZ0->(!EOF())
	SZ0->(DBGOTO(XSZ0->REG))
	RECLOCK("SZ0",.F.)
	SZ0->(DBDELETE())
	SZ0->(MsUnlock())
	XSZ0->(DBSKIP())
END

XSZ0->(DBCLOSEAREA())
RETURN
