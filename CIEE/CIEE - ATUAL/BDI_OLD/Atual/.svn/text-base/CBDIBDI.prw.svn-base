#include "Rwmake.ch" 
#include "TOPCONN.CH"
#Include "Protheus.Ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CBDIBDI   ºAutor  ³Microsiga           º Data ³  11/29/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CBDIBDI()

Private lInverte := .F.
Private cMarca
Private _nNRREG := 0

_aArea := GetArea()

cParams := SZO->ZO_CODEVEN
DbSelectArea("PAB") //Limpa conteudo da Tabela PAA (Contatos por Evento)
cTabela := RetArq("TOPCONN","PAB020",.T.)
cQuery  := "DELETE FROM "+alltrim(cTabela)
cQuery  += " WHERE PAB_CODEVE = '"+ALLTRIM(cParams)+"' "
TcSQLExec(cQuery)

If M->ZO_BDI == "1"
	DbSelectArea("SA2")
	DbGotop()
	
	cMarca  := GetMark()
	nOpcA	:= 0
	aCampos := {}
	
	aAdd(aCampos,{"A2_OK"    ,"", ""          })
	aAdd(aCampos,{"A2_COD"   ,"", "Codigo"    })
	aAdd(aCampos,{"A2_NOME"  ,"", "Descricao" })
	
	aBotao := {{"S4WB011N",{||PesqBdi(oMark,"SA2")},"Pesquisar..", "Pesquisar" }}
	bSet16 := SetKey(16,{||PesqBdi(oMark,"SA2")})
	
	Define MsDialog oDlg1 Title OemToAnsi("BDI") From 01, 01 to 30, 060 of oMainWnd
	oMark := MsSelect():New("SA2","A2_OK",,aCampos,@lInverte,@cMarca	,{015, 006, 205, 220})
	oMark:oBrowse:lhasMark    := .T.
//	oMark:oBrowse:lCanAllmark := .T.
//	oMark:oBrowse:bAllMark    := { || u_fInvCont(cMarca) }
	
	Activate MsDialog oDlg1 on init EnchoiceBar(oDlg1,{|| nOpcA := 1,oDlg1:End()},{|| nOpcA := 9, ODlg1:End()},,aBotao) Center

	SetKey(16,bSet16)
		
	If nOpcA == 1 //Grava Selecao de Contatos
		cQuery  := "SELECT * "
		cQuery  += "FROM "+RetSQLname('SA2')+" "
		cQuery  += "WHERE D_E_L_E_T_ <> '*' "
		cQuery  += "AND A2_OK = '"+cMarca+"' "
		TcQuery cQuery New Alias "SA2TMP"
		
		DbSelectArea("SA2TMP")
		DbGoTop()
		_lRet := .F.
		Do While !EOF()
			GravaPAB()
			_lRet := .T.
			DbSelectArea("SA2TMP") 
			DbSkip()
		EndDo

		If !_lRet
			msgbox("E necessario marcar ao menos um Contato BDI!!!")
			u_CBDIBDI()
		EndIf
	ElseIf nOpcA == 9 //Cancela Selecao de Categorias
		M->ZO_BDI := "2"
	EndIf
EndIf

DbCloseArea("SA2TMP")

RestArea(_aArea)

Return

Static Function GravaPAB() //Contato por evento
Begin Transaction
RecLock("PAB",.T.)
PAB->PAB_FILIAL 	:= xFilial("PAB")
PAB->PAB_CODEVE		:= SZO->ZO_CODEVEN
PAB->PAB_DESCRI		:= SZO->ZO_DESCR
PAB->PAB_DTEVEN		:= SZO->ZO_DTEVENT
PAB->PAB_CODBDI		:= SA2TMP->A2_COD
PAB->PAB_NOME		:= SA2TMP->A2_NOME
MsUnLock()
End Transaction
Return

Return

Static Function PesqBdi()

Local cAliasAnt := Alias()
Local nRecno
Local nOrdInd := IndexOrd()

dbSelectarea("SA2")
nRecno := Recno()
AxPesqui()

DbSelectArea(cAliasAnt)
DbSetOrder(nOrdInd)

oMark:oBrowse:Refresh(.T.)

Return Nil