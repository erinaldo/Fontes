#INCLUDE "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MT097BUT ³ Autor ³ Leonardo Soncin       ³ Data ³ 07/12/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Adiciona botao especifico na liberacao de PCs              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Mata097                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT097BUT()

Local aArea := GetArea() 
Local nOpcx := 2
Local cAlias := "SCR"
Local nReg := SCR->(Recno())
Local oMens1
Local oFont  := TFont():New("Tahoma",13,,,.T.,,,,,.F.) // Com Negrito

If 'MATA097'$FunName()
   SC7->( DbSetOrder(1), DbSeek( xFilial('SC7')+AllTrim(SCR->CR_NUM) ) )
Else
   SC7->( DbSetOrder(1), DbSeek( xFilial('SC7')+cA120Num ) )
EndIf

/*
If MsgYesNo("Entrar na tela de Resumo de compras para este fornecedor da APROVACAO?")
	U_DlgMT097()
Else
	A097Visual(cAlias,nReg,nOpcx) // Chama Consulta do Pedido
EndIf	
*/

DEFINE MSDIALOG mkwdlg TITLE "Procurement" From 155,086 To 378,532 Of oMainWnd PIXEL
@ 002,002 To 112,214 Title ""
@ 045,007 To 104,111 Title "Procurement"
@ 045,118 To 104,206 Title "Aprovação Financeira"
@ 020,030 Say "Selecione a Opção Desejada"  Color 8388608 Object oMens1 SIZE 178,20
@ 057,012 Button "_Consultar Laudos de Negociação" Size 94,16 Action( U_xPosic("SC7",SC7->( Recno() ),2,"PC") ) 
@ 077,012 Button "_Manutenção do seu Laudo"        Size 94,16 Action( U_DigitLdo(nReg) ) 
@ 057,122 Button "_Resumo de Compras"              Size 80,16 Action( U_DlgMT097() ) 
@ 077,122 Button "Conhecimento_"                   Size 80,16 Action( MsDocument("SC7",ExecBlock("CSFINDPED",.F.,.F.),2,,,,.T.) )


oMens1:ofont:=ofont

Activate Dialog mkwdlg Centered

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ DigitLDO ³ Autor ³ Sergio Oliveira       ³ Data ³ Fev/2008 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Proceder com o preenchimento do laudo de negociacao.       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MT097But.prw                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DigitLDO(pnReg)

SCR->( DbGoTo( pnReg ) )

Private oMens1, oMens2
Private oFont  := TFont():New("Tahoma",12,,,.T.,,,,,.F.) // Com Negrito
Private oFont2 := TFont():New("Tahoma",09,,,.T.,,,,,.F.) // Com Negrito
Private oMemo    
Private cTxtLaudo  := SCR->CR_X_LAUDO

Define MSDialog xDlg From 165,225 TO 610,785 Title "Procurement" Of oMainWnd Pixel

@ 002,004 To 220,258
@ 002,210 To 220,258
@ 058,008 To 216,208
@ 069,212 To 149,256 Title "Opções"
@ 008,008 To 057,208
@ 019,051 Say "Laudo de Negociação"                    Color 8388608 Object oMens1 Size 186,13
@ 040,015 Say "Comprador: "+UsrFullName(SC7->C7_USER) Color 8388608 Object oMens2 Size 186,13
@ 064,012 Get cTxtLaudo MEMO Object oMemo Size 192,149

@ 089,215 Button "_Confirmar" Size 36,16 Action( AtuMemo(cTxtLaudo), Close( xDlg ) )
@ 112,216 Button "_Abandonar" Size 36,16 Action( Close( xDlg ) )

oMens1:ofont:=ofont
oMens2:ofont:=ofont2

Activate Dialog xDlg Centered

Return

Static Function AtuMemo(pcTxtLaudo)
                    
SCR->( RecLock('SCR',.f.) )
SCR->CR_X_LAUDO := pcTxtLaudo
SCR->( MsUnLock() )

oMemo:Refresh()

Return