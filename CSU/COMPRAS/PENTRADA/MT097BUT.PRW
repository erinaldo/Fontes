#INCLUDE "Rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MT097BUT � Autor � Leonardo Soncin       � Data � 07/12/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Adiciona botao especifico na liberacao de PCs              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Mata097                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
@ 045,118 To 104,206 Title "Aprova��o Financeira"
@ 020,030 Say "Selecione a Op��o Desejada"  Color 8388608 Object oMens1 SIZE 178,20
@ 057,012 Button "_Consultar Laudos de Negocia��o" Size 94,16 Action( U_xPosic("SC7",SC7->( Recno() ),2,"PC") ) 
@ 077,012 Button "_Manuten��o do seu Laudo"        Size 94,16 Action( U_DigitLdo(nReg) ) 
@ 057,122 Button "_Resumo de Compras"              Size 80,16 Action( U_DlgMT097() ) 
@ 077,122 Button "Conhecimento_"                   Size 80,16 Action( MsDocument("SC7",ExecBlock("CSFINDPED",.F.,.F.),2,,,,.T.) )


oMens1:ofont:=ofont

Activate Dialog mkwdlg Centered

RestArea(aArea)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � DigitLDO � Autor � Sergio Oliveira       � Data � Fev/2008 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Proceder com o preenchimento do laudo de negociacao.       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MT097But.prw                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
@ 069,212 To 149,256 Title "Op��es"
@ 008,008 To 057,208
@ 019,051 Say "Laudo de Negocia��o"                    Color 8388608 Object oMens1 Size 186,13
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