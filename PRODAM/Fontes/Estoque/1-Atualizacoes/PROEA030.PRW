#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#include "topconn.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun??o    ³PROEA030  ³ Autor ³ Felipe Santos          ³ Data ³ 26/07/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ³ Rotina de reenvio do workflow pela SOLICITACAO DE COMPRAS  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAEST                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PROEA030()
	Local 	oDlgOBS
	Local 	oGet1
	Local	cTxtResp := ""
	Local 	aAreaAtu
	Local 	aAreaSC1
	Local 	aAreaSD1
	Local  cUsrResp1 := ""
	Local  cUsrResp2 := ""
	
	aAreaAtu 	:= GETAREA()
	
	If IsIncallStatck("MATA110")
		dbSelectArea("SC1")
		aAreaSC1 	:= GETAREA()
		cChvSC1 := SC1->C1_FILIAL+SC1->C1_NUM
		dbSetOrder(1)
		If dbSeek(SC1->C1_FILIAL+SC1->C1_NUM)
			Do While !Eof() .and. SC1->(C1_FILIAL+C1_NUM) == cChvSC1
				cUsrResp1 := AllTrim(SC1->C1_XUSRAMO)
				If !Empty(cUsrResp1) .and. !(cUsrResp1 $ cTxtResp)
					cTxtResp += UsrRetName(cUsrResp1) + CRLF
				EndIf
				cUsrResp2 := AllTrim(SC1->C1_XUSRAM2)
				If !Empty(cUsrResp2) .and. !(cUsrResp2 $ cTxtResp)
					cTxtResp += UsrRetName(cUsrResp2) + CRLF
				EndIf

				dbSkip()
			EndDo
		Else
			ApMsgInfo("Item de solicitação não encontrado!")
		EndIf
		RESTAREA(aAreaSC1)
	EndIf
	
	If IsIncallStatck("MATA140")
		dbSelectArea("SD1")
		aAreaSD1 	:= GETAREA()
		dbSetOrder(1)
		If dbSeek(SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
			Do While !Eof() .and. SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)
				cUsrResp1 := AllTrim(SD1->D1_XUSRAMO)
				If !Empty(cUsrResp1) .and. !(cUsrResp1 $ cTxtResp)
					cTxtResp += UsrRetName(cUsrResp1) + CRLF
				EndIf
				cUsrResp2 := AllTrim(SD1->D1_XUSRAM2)
				If !Empty(cUsrResp2) .and. !(cUsrResp2 $ cTxtResp)
					cTxtResp += UsrRetName(cUsrResp2) + CRLF
				EndIf
				dbSkip()
			EndDo
		Else
			ApMsgInfo("Item de documento não encontrado!")
		EndIf
		RESTAREA(aAreaSD1)
	EndIf
	
	If !Empty(cTxtResp)
		DEFINE FONT oFont NAME "Mono AS" SIZE 8,18
		Define MsDialog oDlgOBS Title "Responsável - Análise de Amostra" From 000, 000 To 340,420 Pixel
		@ 008,010 SAY "Responsáveis pela Análise de Amostra ref. a esse documento:"  Size 180,10 	PIXEL OF oDlgOBS
		@ 020,010 GET oMens VAR cTxtResp MEMO SIZE 190,130 When .F. OF oDlgOBS PIXEL
		oMens:bRClicked := {||AllwaysTrue()}
		oMens:oFont:=oFont
		oSpdBtY := SButton():New(154,175, 2,{|| oDlgOBS:End() }, oDlgOBS,.T.,,)
		Activate MsDialog oDlgOBS Center
	EndIf

	RESTAREA(aAreaAtu)

Return





Static Function UsrRetName(cUserID)

	Local cUsrName	:= ""

	PswOrder(2)
	IF (!Empty( cUserID ) .and. PswSeek(cUserID,.T.)	)
		cUsrName 	:= PswRet(1)[1][4]
	EndIF

Return( cUsrName )

