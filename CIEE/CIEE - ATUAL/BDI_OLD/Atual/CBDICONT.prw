#include "Rwmake.ch" 
#include "TOPCONN.CH"
#Include "Protheus.Ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CBDICONT  ºAutor  ³Microsiga           º Data ³  11/29/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CBDICONT()

Private lInverte := .F.
Private cMarca
Private _nNRREG := 0

_aArea := GetArea()

cParams := SZO->ZO_CODEVEN
DbSelectArea("PAA") //Limpa conteudo da Tabela PAA (Contatos por Evento)
cTabela := RetArq("TOPCONN","PAA020",.T.)
cQuery  := "DELETE FROM "+alltrim(cTabela)
cQuery  += " WHERE PAA_CODEVE = '"+ALLTRIM(cParams)+"' "
TcSQLExec(cQuery)

If M->ZO_CONTATO == "1"
	DbSelectArea("SU5")
	DbGotop()
	
	cMarca  := GetMark()
	nOpcA	:= 0
	aCampos := {}
	
	aAdd(aCampos,{"U5_OK"       ,"", ""          })
	aAdd(aCampos,{"U5_CODCONT"  ,"", "Codigo"    })
	aAdd(aCampos,{"U5_CONTAT"   ,"", "Descricao" })
	
	aBotao := {{"S4WB011N",{||PesqCont(oMark,"SU5")},"Pesquisar..", "Pesquisar" }}
	bSet16 := SetKey(16,{||PesqCont(oMark,"SU5")})
	
	Define MsDialog oDlg1 Title OemToAnsi("Contato") From 01, 01 to 30, 060 of oMainWnd
	oMark := MsSelect():New("SU5","U5_OK",,aCampos,@lInverte,@cMarca	,{015, 006, 205, 220})
	oMark:oBrowse:lhasMark    := .T.
//	oMark:oBrowse:lCanAllmark := .T.
//	oMark:oBrowse:bAllMark    := { || u_fInvCont(cMarca) }
	
	Activate MsDialog oDlg1 on init EnchoiceBar(oDlg1,{|| nOpcA := 1,oDlg1:End()},{|| nOpcA := 9, ODlg1:End()},,aBotao) Center

	SetKey(16,bSet16)
		
	If nOpcA == 1 //Grava Selecao de Contatos
		cQuery  := "SELECT * "
		cQuery  += "FROM "+RetSQLname('SU5')+" "
		cQuery  += "WHERE D_E_L_E_T_ <> '*' "
		cQuery  += "AND U5_OK = '"+cMarca+"' "
		TcQuery cQuery New Alias "SU5TMP"
		
		DbSelectArea("SU5TMP")
		DbGoTop()
		_lRet := .F.
		Do While !EOF()
			GravaPAA()
			_lRet := .T.
			DbSelectArea("SU5TMP") 
			DbSkip()
		EndDo

		If !_lRet
			msgbox("E necessario marcar ao menos um Contato!!!")
			u_CBDICONT()
		EndIf

	ElseIf nOpcA == 9 //Cancela Selecao de Categorias
		M->ZO_CONTATO := "2"
	EndIf
EndIf

DbCloseArea("SU5TMP")

RestArea(_aArea)

Return

Static Function GravaPAA() //Contato por evento
Begin Transaction
RecLock("PAA",.T.)
PAA->PAA_FILIAL 	:= xFilial("PAA")
PAA->PAA_CODEVE		:= SZO->ZO_CODEVEN
PAA->PAA_DESCRI		:= SZO->ZO_DESCR
PAA->PAA_DTEVEN		:= SZO->ZO_DTEVENT
PAA->PAA_CODCON		:= SU5TMP->U5_CODCONT
PAA->PAA_NOME		:= SU5TMP->U5_CONTAT
MsUnLock()
End Transaction
Return

Return

Static Function PesqCont()

Local cAliasAnt := Alias()
Local nRecno
Local nOrdInd := IndexOrd()

dbSelectarea("SU5")
nRecno := Recno()
AxPesqui()

DbSelectArea(cAliasAnt)
DbSetOrder(nOrdInd)

oMark:oBrowse:Refresh(.T.)

Return Nil