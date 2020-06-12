#include "PROTHEUS.CH"
#include 'parmtype.ch'
#include "topconn.ch"
//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA53()

Cálculo da dedução do IRPJ - Rotina FINA960
Excutado na validação do campo FR5_ENTID 
@param		Nenhum
@return		.T.
@author 	Zema
@since 		22/11/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA53
Local bOk       	:= {|| (lOk := .T., oDlg:End() )} 
Local bCancel   	:= {|| (lOk	:= .F., oDlg:End()) }                  
Local lOK 		:= .T.
Local cUser        := RetCodUsr()
Local cNome        := Left(Alltrim(UsrRetName(cUser)) , TamSX3("FR5_NOMEUS")[1] )
Private oDlg
Private oGet1
Private oGet2
Private oGet3
Private oSay1
Private oSay2
Private oSay3
Private oSay4
Private oSay5    
Private oSay6
Private nPerComp      := 0                            
Private nValComp		:= 0                      
Private cContaComp	:= GETNEWPAR("AS_CTACOMP","203006001001009")
Private nSaldoComp	:= 0

IF FR4->FR4_STATUS $  "34"
	MsgAlert("O status desta apuração não permite alterações!")
	RETURN(.T.)
ENDIF

                                                                            
DEFINE MSDIALOG oDlg TITLE "COMPESAÇÕES" FROM 000, 000  TO 300, 500 COLORS 0, 16777215 PIXEL
    @ 020, 022 SAY oSay1 PROMPT "Apuração     :  "+FR4->FR4_CODAPU SIZE 100, 015 OF oDlg COLORS 0, 16777215 PIXEL
    @ 040, 022 SAY oSay3 PROMPT "Base Comp.   :  "+TRANSFORM(FR4->FR4_BACOMP,"@E 99,999,999,999.99") SIZE 100, 015 OF oDlg COLORS 0, 16777215 PIXEL 

    @ 060, 022 SAY oSay6 PROMPT "Conta de Compensação  : " SIZE 050, 015 OF oDlg COLORS 255, 16777215 PIXEL 
    @ 060, 070 MSGET oGet3 VAR cContaComp  F3 "CT1" WHEN CONTACOMP() VALID CONTACOMP() SIZE 100, 010 OF oDlg COLORS 255, 16777215 PIXEL


    @ 080, 022 SAY oSay4 PROMPT "Saldo Comp.  :  "+TRANSFORM(nSaldoComp,"@E 99,999,999,999.99") SIZE 130, 015 OF oDlg COLORS 0, 16777215 PIXEL 

    @ 100, 022 SAY oSay5 PROMPT "% Compensação:  " SIZE 100, 015 OF oDlg COLORS 0, 16777215 PIXEL 
    @ 100, 070 MSGET oGet1 VAR nPerComp PICTURE "@E 99.99" VALID _PERCOMP() SIZE 50, 010 OF oDlg COLORS 0, 16777215 PIXEL

    @ 120, 022 SAY oSay6 PROMPT "Compensação  : " SIZE 50, 015 OF oDlg COLORS 255, 16777215 PIXEL 
    @ 120, 070 MSGET oGet2 VAR nValComp PICTURE "@E 99,999,999,999.99" WHEN .F. SIZE 50, 010 OF oDlg COLORS 255, 16777215 PIXEL
                                                
ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, bOk, bCancel)
            
IF lOK                           

	IF MsgYesNo("Confirma o valor de compensação na base de IR de : "+TRANSFORM(nValComp,"@E 99,999,999,999.99"))
	
		RECLOCK("FR4",.F.)
		FR4->FR4_COMP := nValComp   
		FR4->FR4_RECTRI := FR4->FR4_BACOMP - nValComp
		MsUnlock()       
		
		cQ := "SELECT R_E_C_N_O_ AS REG FROM "+RetSqlName("FR5")
		cQ += " WHERE FR5_FILIAL = '"+FR4->FR4_FILIAL+"' "
		cQ += " AND FR5_CODAPU   = '"+FR4->FR4_CODAPU+"' "
		cQ += " AND FR5_TIPO = '4' "
		cQ += " AND FR5_ITEM = '9999' "
		cQ += " AND D_E_L_E_T_ = ' '"
		TcQuery ChangeQuery(cQ) ALIAS "XFR5" NEW
		
		IF XFR5->REG == 0
			RECLOCK("FR5",.T.)
			FR5->FR5_FILIAL := XFILIAL("FR5")
			FR5->FR5_CODAPU := FR4->FR4_CODAPU
			FR5->FR5_TIPO   := "4"
			FR5->FR5_ITEM   := "9999"
		ELSE       
			FR5->(DBGOTO(XFR5->REG))
			RECLOCK("FR5",.F.)
		ENDIF
		XFR5->(DBCLOSEAREA())

		FR5->FR5_VALOR  := nValComp
		FR5->FR5_DC     := "1"
		FR5->FR5_TPREG  := "2"
		FR5->FR5_USER   := cUser
		FR5->FR5_NOMEUS := cNome
		FR5->FR5_DTALT	:= dDataBase
		MsUnlock()
		
	ENDIF
ENDIF

RETURN(.T.)

STATIC FUNCTION _PERCOMP
Local nBase := FR4->FR4_BACOMP
Local nDisp	:= nSaldoComp

IF nDisp > 0
	nValComp := nBase * nPerComp / 100
	IF nValComp > nDisp
		nValComp := nDisp
	ENDIF
ELSE 
	nValComp := 0
ENDIF	

oGet2:Refresh()
RETURN(.T.)

STATIC FUNCTION CONTACOMP
Local cTpSaldo := GETNEWPAR("AS_SLDCOMP","1")
Local nDisp	:= 0
nDisp	:= SaldoConta(cContaComp,dDataBase,"01",cTpSaldo,1)

CT1->(DBSEEK(XFILIAL("CT1")+cContaComp))

IF CT1->CT1_NORMAL == "1"
	nDisp := nDisp * -1
ENDIF

nSaldoComp := nDisp
oSay4:Refresh()
RETURN(.T.)
