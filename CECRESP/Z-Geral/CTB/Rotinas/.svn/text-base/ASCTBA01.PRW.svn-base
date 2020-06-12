#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'
//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTBA01
@Cadastro de Empresas investidas e quantidade de ações 
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------
user function ASCTBA01()  
Local lAtuAuto := GETNEWPAR("AS_SZ0EMP",.T.) // Informa se atualiza automático a tabela SZ0 apartir do sigamat.emp, somente na implantação
Local aFieldFill	:= {}
Local aFields		:= {}
Local aAlterFields	:= {}
Local aNames		:= {}
Local nX			:= 0                                 
Local lOk			:= .F. 
Local bOk       	:= {|| (lOk := .T., oDlg:End() )} 
Local bCancel   	:= {|| (lOk	:= .F., oDlg:End()) }
Local cRevisao		:= "000" 
Local dRevisao		:= dDataBase
Private cTitulo := OEMTOANSI("Cadastro de Empresas & Quotas")    
Private cCadastro := cTitulo
Private aHeader       := {}
Private aCols         := {}
Static  oMSNewGe
Static  oDlg

cQ := "SELECT Z0_REVISAO, Z0_DTREVIS FROM "+RetSqlName("SZ0")+" WHERE 
cQ += " Z0_DTREVIS <= '"+DTOS(dDataBase)+"' AND D_E_L_E_T_ = ' '"
cQ += " ORDER BY Z0_REVISAO DESC"
TcQuery ChangeQuery(cQ) ALIAS "XSZ0" NEW
IF !EMPTY(XSZ0->Z0_REVISAO)
	cRevisao := XSZ0->Z0_REVISAO
	dRevisao := STOD(XSZ0->Z0_DTREVIS)
ENDIF
XSZ0->(DBCLOSEAREA())

cTitulo+=" Revisão: "+cRevisao+" Data: "+DTOC(dRevisao)

// Verifica se Atualiza a tabela SZ0 a partir do sigamat.emp, somente na implantação
IF lAtuAuto 
	Processa( { || AtuSZ0EMP(cRevisao) }, "Atualizando empresas com sigamat. . .")   
ENDIF
                           
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

ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, bOk, bCancel)

IF lOK

	IF !MsgYesNo("Gera revisão? ")

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

	ELSE

		cQ := "SELECT MAX(Z0_REVISAO) REVISAO FROM "+RetSqlName("SZ0")+" WHERE D_E_L_E_T_ = ' '"
		TcQuery ChangeQuery(cQ) ALIAS "XSZ0" NEW
		cRevisao := Soma1(XSZ0->REVISAO)
		XSZ0->(DBCLOSEAREA())

		FOR nX := 1 TO LEN(oMSNewGe:aCols)
			RECLOCK("SZ0",.T.)
			SZ0->Z0_FILIAL := XFILIAL("SZ0")
			SZ0->Z0_REVISAO:= cRevisao
			SZ0->Z0_DTREVIS:= DATE()
			SZ0->Z0_EMPRESA:= oMSNewGe:aCols[nX][aScan(aHeader,{|x| AllTrim(x[2]) == "Z0_EMPRESA"})]
			SZ0->Z0_RAZAO  := oMSNewGe:aCols[nX][aScan(aHeader,{|x| AllTrim(x[2]) == "Z0_RAZAO"})]
			SZ0->Z0_CNPJ   := oMSNewGe:aCols[nX][aScan(aHeader,{|x| AllTrim(x[2]) == "Z0_CNPJ"})]
			SZ0->Z0_CONTA   := oMSNewGe:aCols[nX][aScan(aHeader,{|x| AllTrim(x[2]) == "Z0_CONTA"})]			
			SZ0->Z0_CTPASS  := oMSNewGe:aCols[nX][aScan(aHeader,{|x| AllTrim(x[2]) == "Z0_CTPASS"})]						
			SZ0->Z0_CTMEPRP := oMSNewGe:aCols[nX][aScan(aHeader,{|x| AllTrim(x[2]) == "Z0_CTMEPRP"})]							
			SZ0->Z0_CTMEPRN := oMSNewGe:aCols[nX][aScan(aHeader,{|x| AllTrim(x[2]) == "Z0_CTMEPRN"})]											
			SZ0->Z0_CTRESN  := oMSNewGe:aCols[nX][aScan(aHeader,{|x| AllTrim(x[2]) == "Z0_CTRESN"})]
			SZ0->Z0_ITEMCTA := oMSNewGe:aCols[nX][aScan(aHeader,{|x| AllTrim(x[2]) == "Z0_ITEMCTA"})]						
			SZ0->Z0_MOEDA   := oMSNewGe:aCols[nX][aScan(aHeader,{|x| AllTrim(x[2]) == "Z0_MOEDA"})]									
			SZ0->Z0_QTACOES := oMSNewGe:aCols[nX][aScan(aHeader,{|x| AllTrim(x[2]) == "Z0_QTACOES"})]
			SZ0->(MsUnlock())
		NEXT nX

	ENDIF
ENDIF	
RETURN

//-----------------------------------------------------------------------
/*{Protheus.doc} AtuSZ0EMP
@Atualiza a tabela SZ0 com os dados da tabela SIGAMAT.EMP
@param		Revisão atual
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------
STATIC FUNCTION AtuSZ0EMP(pRevisao)
Local nRegSM0 := SM0->(RECNO())
Local nRegsSM0:= SM0->(RECCOUNT())
Local cQ	  := ""        
Local cRevisao:= pRevisao

ProcRegua(nRegsSM0)

SM0->(DBGOTOP())   

WHILE SM0->(!EOF())
	IncProc() 
	IF ALLTRIM(SM0->M0_CODIGO) == cEmpAnt

		cQ := "SELECT R_E_C_N_O_ REG FROM "+RetSqlName("SZ0")
		cQ += " WHERE Z0_REVISAO = '"+cRevisao+"' AND Z0_EMPRESA = '"+SUBSTR(SM0->M0_CODIGO,1,2)+SUBSTR(SM0->M0_CODFIL,1,7)+"' "
		cQ += " AND D_E_L_E_T_ = ' '"
		TcQuery ChangeQuery(cQ) ALIAS "XSZ0" NEW

		IF XSZ0->REG == 0    
			cQ := "SELECT MAX(Z0_REVISAO) REVISAO FROM "+RetSqlName("SZ0")+" WHERE D_E_L_E_T_ = ' '"
			TcQuery ChangeQuery(cQ) ALIAS "YSZ0" NEW
			cRevisao := Soma1(YSZ0->REVISAO)
			YSZ0->(DBCLOSEAREA())
		
			RECLOCK("SZ0",.T.)
			SZ0->Z0_FILIAL := XFILIAL("SZ0")
			SZ0->Z0_REVISAO:= cRevisao
			SZ0->Z0_DTREVIS:= DATE()
			SZ0->Z0_EMPRESA:= SUBSTR(SM0->M0_CODIGO,1,2)+SUBSTR(SM0->M0_CODFIL,1,7)
		ELSE
			SZ0->(DBGOTO(XSZ0->REG))
			RECLOCK("SZ0",.F.)
		ENDIF
		SZ0->Z0_RAZAO  := SM0->M0_NOMECOM
		SZ0->Z0_CNPJ   := SM0->M0_CGC
		SZ0->(MsUnlock())
		XSZ0->(DBCLOSEAREA())

	ENDIF
	SM0->(DBSKIP())
END          

SM0->(DBGOTO(nRegSM0))

RETURN