
#include "rwmake.ch"

//Exemplo para utilizacao de consulta padrao com arquivo temporario.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F3ESP     ºAutor  ³Claudio Barros      º Data ³  20/08/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Consulta Padrao especifica para popular a conta contabil    º±±
±±º          ³a partir da conta reduzida.                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³SIGACTB - Lancamento dos Movimentos Automaticos             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function F3ESP()


Local _aItens := {}
Local aCboList
Private cOpe
Private _cPesq := SPACE(40)
Private _lRET := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Interface                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


@ 65,0 To 280,400 Dialog mkwdlg Title OemToAnsi("Consulta Padrão com Arquivo Especifico")



DbSelectArea("CTD")
CTD->(DbSetOrder(1))
CTD->(DbGotop())


aCampos := {}
aCampos	:= { { "CTD_ITEM  "   ,"Reduzida"      ,"@!"},;
{ "CTD_DESC01"   ,"Descricao"    ,"@!"}}
//             { "CT1_CONTA"    ,"Conta   "     ,"@!"}}


DbSelectArea("CTD")
DbGotop()
@ 11,7 TO 73,170 BROWSE "CTD" FIELDS acampos object oColbRW

aCboList := {"Conta Reduzida","Descricao Conta"}

cOpe  := "Conta Reduzida"

@ 80,010 SAY "Pesquisa Por "
@ 80,045 COMBOBOX cOpe ITEMS aCboList SIZE 090,10
@ 095,010 SAY "Localizar "
@ 095,045 GET _cPesq Valid LOCALIZA() Picture "@!" SIZE 090,10
@ 80,144 BmpButton Type 1 Action Atualiza()
Activate Dialog mkwdlg

Return(_lRet)



Static Function Atualiza()

If Empty(TMP->CT2_DC)
	MsgAlert("Nao foi Definido o Tipo do Lancamento!!")
	_lRet := .F.
EndIf

lRefresh := .T.
Reclock("TMP",.F.)

IF TMP->CT2_DC == "1"
	TMP->CT2_DEBITO :=  CT1->CT1_CONTA
ELSE
	TMP->CT2_CREDIT := CT1->CT1_CONTA
ENDIF

TMP->(MsUnlock())
lRefresh := .T.
Close(mkwdlg)
Return




//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Localiza Conta Contabil Selecionada no Browse.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Localiza()


If !Empty(_cPesq) .AND. cOpe == "Conta Reduzida"
	DbSelectarea("CTD")
	CTD->(DbSetOrder(1))
	DbSeek(xFilial("CTD")+Subs(_cPesq,1,10),.T.)
	lRefresh := .T.
Else
	DbSelectarea("CTD")
	CTD->(DbSetOrder(2))
	DbSeek(xFilial("CTD")+Subs(_cPesq,1,40),.T.)
	lRefresh := .T.
EndIF

DBSELECTAREA("CT1")
CT1->(DBSETORDER(2))
CT1->(DBSEEK(xFilial("CT1")+Subs(_cPesq,1,10)))

cReg := CT1->(RECNO())
CT1->(DBGOTO(cReg))

oColBrw:oBROWSE:REFRESH()
oColBrw:oBROWSE:SETFOCUS()

Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Validação da Conta Contabil                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function CTBCPOESP(pConta)

Local Ret:= .T.

If Select("CT1") > 0
	DbSelectarea("CT1")
	CT1->(DbSetorder(1))
	IF !CT1->(DbSeek(xFilial("CT1")+pConta,.T.))
		MsgBox("Conta nao Encontrada no Cadastro!!")
		Ret:=.F.
	ENDIF
EndIf

Return(Ret)


User Function PosCt1(pPar01,pPar02)


Local _lRet := .T.
Local _cAlias := GetArea()


If !Empty(pPar01)
	DbSelectArea("CT1")
	CT1->(DbSetOrder(2))
	CT1->(DbGotop())
	IF CT1->(DbSeek(xFilial("CT1")+pPar01))
		If Alltrim(pPar02) == "CT2_ITEMD"
			RecLock("TMP",.F.)
			TMP->CT2_DEBITO := CT1->CT1_CONTA
			TMP->(MsUnlock())
            CTB105CTA(TMP->CT2_DEBITO,"1") .And. CtbAmarra(TMP->CT2_DEBITO,TMP->CT2_CCD,TMP->CT2_ITEMD,TMP->CT2_CLVLDB, .T.)                                    
		EndIf
		If Alltrim(pPar02) == "CT2_ITEMC"
			RecLock("TMP",.F.)
			TMP->CT2_CREDIT := CT1->CT1_CONTA
			TMP->(MsUnlock())
			CTB105CTA(TMP->CT2_CREDIT,"2") .And. CtbAmarra(TMP->CT2_CREDITO,TMP->CT2_CCC,TMP->CT2_ITEMC,TMP->CT2_CLVLCR,.T.)
		EndIf
	EndIf
EndIf



Return(_lRet)
