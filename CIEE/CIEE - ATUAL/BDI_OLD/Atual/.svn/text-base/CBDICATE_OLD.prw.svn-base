#include "Rwmake.ch" 
#include "TOPCONN.CH"
#Include "Protheus.Ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CBDICATE  ºAutor  ³Microsiga           º Data ³  11/29/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CBDICATE()

Private lInverte := .F.
Private cMarca
Private _nNRREG := 0

_aArea := GetArea()

cParams := SZO->ZO_CODEVEN
DbSelectArea("SZP") //Limpa conteudo da Tabela SZP (Evento X Categorias)
cTabela := RetArq("TOPCONN","SZP020",.T.)
cQuery  := "DELETE FROM "+alltrim(cTabela)
cQuery  += " WHERE ZP_CODEVEN = '"+ALLTRIM(cParams)+"' "
TcSQLExec(cQuery)

If M->ZO_CATEG == "1"
	DbSelectArea("SZW")
	DbGotop()
	
	cMarca  := GetMark()
	nOpcA	:= 0
	aCampos := {}
	
	aAdd(aCampos,{"ZW_OK"   ,"", ""          })
	aAdd(aCampos,{"ZW_COD"  ,"", "Codigo"    })
	aAdd(aCampos,{"ZW_DESC" ,"", "Descricao" })
	
	aBotao := {}
	
	Define MsDialog oDlg1 Title OemToAnsi("Categoria") From 01, 01 to 30, 060 of oMainWnd //30, 124 of oMainWnd
	oMark := MsSelect():New("SZW","ZW_OK",,aCampos,@lInverte,@cMarca	,{015, 006, 205, 220}) //{020, 002, 195, 480})
	oMark:oBrowse:lhasMark    := .T.
	oMark:oBrowse:lCanAllmark := .T.
	oMark:oBrowse:bAllMark    := { || u_fInvCate(cMarca) }
	
	Activate MsDialog oDlg1 on init EnchoiceBar(oDlg1,{|| nOpcA := 1,oDlg1:End()},{|| nOpcA := 9, ODlg1:End()},,aBotao) Center
	
	If nOpcA == 1 //Grava Selecao de Categorias
		
		DbSelectArea("SZW")
		DbGoTop()
		_lRet := .F.
		Do While !EOF()
			Do Case
				Case marked(SZW->ZW_OK)
					If Empty(SZW->ZW_OK)
						GravaSZP()
						_lRet := .T.
					EndIf
				Case SZW->ZW_OK == cMarca
					GravaSZP()
					_lRet := .T.
			EndCase
			DbSelectArea("SZW")
			DbSkip()
		EndDo
		
		If !_lRet
			msgbox("E necessario marcar ao menos uma categorias!!!")
			u_CBDICATE()
		EndIf
	ElseIf nOpcA == 9 //Cancela Selecao de Categorias
		M->ZO_CATEG := "2"
	EndIf
EndIf
RestArea(_aArea)

Return

Static Function GravaSZP()
Begin Transaction
RecLock("SZP",.T.)
SZP->ZP_FILIAL 		:= xFilial("SZP")
SZP->ZP_CODEVEN		:= SZO->ZO_CODEVEN
SZP->ZP_DESCRI		:= SZO->ZO_DESCR
SZP->ZP_DTEVENT		:= SZO->ZO_DTEVENT
SZP->ZP_COD			:= SZW->ZW_COD
SZP->ZP_DESC		:= SZW->ZW_DESC
MsUnLock()
End Transaction
Return


User Function fInvCate(cMarca)

DbSelectArea("SZW")
DbGotop()
Do While !Eof()
	If RecLock("SZW",.F.)
		If SZW->ZW_OK == cMarca
			SZW->ZW_OK := "  "
		Else
			SZW->ZW_OK := cMarca
		EndIf
		MsUnLock()
	EndIf
	DbSelectArea("SZW")
	DbSkip()
EndDo
DbGotop()
oMark:oBrowse:Refresh(.t.)

Return