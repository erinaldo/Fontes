#include "Rwmake.ch" 
#include "TOPCONN.CH"
#Include "Protheus.Ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CBDICARG  ºAutor  ³Microsiga           º Data ³  11/29/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CBDICARG()

Private lInverte := .F.
Private cMarca
Private _nNRREG := 0

_aArea := GetArea()

cParams := SZO->ZO_CODEVEN
DbSelectArea("PAC") //Limpa conteudo da Tabela PAC (Cargo por Evento)
cTabela := RetArq("TOPCONN","PAC020",.T.)
cQuery  := "DELETE FROM "+alltrim(cTabela)
cQuery  += " WHERE PAC_CODEVE = '"+ALLTRIM(cParams)+"' "
TcSQLExec(cQuery)

If M->ZO_CARGO == "1"
	DbSelectArea("SUM")
	DbGotop()
	
	cMarca  := GetMark()
	nOpcA	:= 0
	aCampos := {}
	
	aAdd(aCampos,{"UM_OK"    ,"", ""          })
	aAdd(aCampos,{"UM_CARGO" ,"", "Codigo"    })
	aAdd(aCampos,{"UM_DESC"  ,"", "Descricao" })
	
	aBotao := {{"S4WB011N",{||PesqCarg(oMark,"SUM")},"Pesquisar..", "Pesquisar" }}
	bSet16 := SetKey(16,{||PesqCarg(oMark,"SUM")})
	
	Define MsDialog oDlg1 Title OemToAnsi("Cargo") From 01, 01 to 30, 060 of oMainWnd
	oMark := MsSelect():New("SUM","UM_OK",,aCampos,@lInverte,@cMarca	,{015, 006, 205, 220})
	oMark:oBrowse:lhasMark    := .T.
//	oMark:oBrowse:lCanAllmark := .T.
//	oMark:oBrowse:bAllMark    := { || u_fInvCont(cMarca) }
	
	Activate MsDialog oDlg1 on init EnchoiceBar(oDlg1,{|| nOpcA := 1,oDlg1:End()},{|| nOpcA := 9, ODlg1:End()},,aBotao) Center

	SetKey(16,bSet16)
	
	If nOpcA == 1 //Grava Selecao de Contatos
		cQuery  := "SELECT * "
		cQuery  += "FROM "+RetSQLname('SUM')+" "
		cQuery  += "WHERE D_E_L_E_T_ <> '*' "
		cQuery  += "AND UM_OK = '"+cMarca+"' "
		TcQuery cQuery New Alias "SUMTMP"
		
		DbSelectArea("SUMTMP")
		DbGoTop()
		_lRet := .F.
		Do While !EOF()
			GravaPAC()
			_lRet := .T.
			DbSelectArea("SUMTMP") 
			DbSkip()
		EndDo

		If !_lRet
			msgbox("E necessario marcar ao menos um Cargo!!!")
			u_CBDICARG()
		EndIf

	ElseIf nOpcA == 9 //Cancela Selecao de Categorias
		M->ZO_CARGO := "2"
	EndIf
EndIf

DbCloseArea("SUMTMP")

RestArea(_aArea)

Return

Static Function GravaPAC() //Contato por evento
Begin Transaction
RecLock("PAC",.T.)
PAC->PAC_FILIAL 	:= xFilial("PAC")
PAC->PAC_CODEVE		:= SZO->ZO_CODEVEN
PAC->PAC_DESCRI		:= SZO->ZO_DESCR
PAC->PAC_DTEVEN		:= SZO->ZO_DTEVENT
PAC->PAC_CODCAR		:= SUMTMP->UM_CARGO
PAC->PAC_NOME		:= SUMTMP->UM_DESC
MsUnLock()
End Transaction
Return

Return

Static Function PesqCarg()

Local cAliasAnt := Alias()
Local nRecno
Local nOrdInd := IndexOrd()

dbSelectarea("SUM")
nRecno := Recno()
AxPesqui()

DbSelectArea(cAliasAnt)
DbSetOrder(nOrdInd)

oMark:oBrowse:Refresh(.T.)

Return Nil