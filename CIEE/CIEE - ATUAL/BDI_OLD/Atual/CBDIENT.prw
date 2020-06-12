#include "Rwmake.ch" 
#include "TOPCONN.CH"
#Include "Protheus.Ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CBDIENT   ºAutor  ³Microsiga           º Data ³  11/29/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CBDIENT()

Private lInverte := .F.
Private cMarca
Private _nNRREG := 0

_aArea := GetArea()

cParams := SZO->ZO_CODEVEN
DbSelectArea("PAD") //Limpa conteudo da Tabela PAC (Cargo por Evento)
cTabela := RetArq("TOPCONN","PAD020",.T.)
cQuery  := "DELETE FROM "+alltrim(cTabela)
cQuery  += " WHERE PAD_CODEVE = '"+ALLTRIM(cParams)+"' "
TcSQLExec(cQuery)

If M->ZO_ENTID == "1"
	DbSelectArea("SZM")
	DbGotop()
	
	cMarca  := GetMark()
	nOpcA	:= 0
	aCampos := {}
	
	aAdd(aCampos,{"ZM_OK"     ,"", ""          })
	aAdd(aCampos,{"ZM_CODENT" ,"", "Codigo"    })
	aAdd(aCampos,{"ZM_NOME"   ,"", "Descricao" })
	
	aBotao := {{"S4WB011N",{||PesqEnt(oMark,"SZM")},"Pesquisar..", "Pesquisar" }}
	bSet16 := SetKey(16,{||PesqEnt(oMark,"SZM")})
	
	Define MsDialog oDlg1 Title OemToAnsi("Entidade") From 01, 01 to 30, 060 of oMainWnd
	oMark := MsSelect():New("SZM","ZM_OK",,aCampos,@lInverte,@cMarca	,{015, 006, 205, 220})
	oMark:oBrowse:lhasMark    := .T.
//	oMark:oBrowse:lCanAllmark := .T.
//	oMark:oBrowse:bAllMark    := { || u_fInvCont(cMarca) }
	
	Activate MsDialog oDlg1 on init EnchoiceBar(oDlg1,{|| nOpcA := 1,oDlg1:End()},{|| nOpcA := 9, ODlg1:End()},,aBotao) Center

	SetKey(16,bSet16)
	
	If nOpcA == 1 //Grava Selecao de Contatos
		cQuery  := "SELECT * "
		cQuery  += "FROM "+RetSQLname('SZM')+" "
		cQuery  += "WHERE D_E_L_E_T_ <> '*' "
		cQuery  += "AND ZM_OK = '"+cMarca+"' "
		TcQuery cQuery New Alias "SZMTMP"
		
		DbSelectArea("SZMTMP")
		DbGoTop()
		_lRet := .F.
		Do While !EOF()
			GravaPAD()
			_lRet := .T.
			DbSelectArea("SZMTMP") 
			DbSkip()
		EndDo

		If !_lRet
			msgbox("E necessario marcar ao menos uma Entidade!!!")
			u_CBDIENT()
		EndIf

	ElseIf nOpcA == 9 //Cancela Selecao de Categorias
		M->ZO_ENTID := "2"
	EndIf
EndIf

DbCloseArea("SZMTMP")

RestArea(_aArea)

Return

Static Function GravaPAD() //Contato por evento
Begin Transaction
RecLock("PAD",.T.)
PAD->PAD_FILIAL 	:= xFilial("PAD")
PAD->PAD_CODEVE		:= SZO->ZO_CODEVEN
PAD->PAD_DESCRI		:= SZO->ZO_DESCR
PAD->PAD_DTEVEN		:= SZO->ZO_DTEVENT
PAD->PAD_CODENT		:= SZMTMP->ZM_CODENT
PAD->PAD_NOME		:= SZMTMP->ZM_NOME
MsUnLock()
End Transaction
Return

Return

Static Function PesqEnt()

Local cAliasAnt := Alias()
Local nRecno
Local nOrdInd := IndexOrd()

dbSelectarea("SZM")
nRecno := Recno()
AxPesqui()

DbSelectArea(cAliasAnt)
DbSetOrder(nOrdInd)

oMark:oBrowse:Refresh(.T.)

Return Nil