#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT120BRW � Autor � Carlos A. Queiroz  � Data �  18/12/2014 ���
�������������������������������������������������������������������������͹��
���Desc.     � Nova opcao no menu do Pedido de Compras.                   ���
�������������������������������������������������������������������������͹��
���Uso       � GJP Hotels & Resorts                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT120BRW()
Aadd(aRotina, {"Observa��es PC", 'U_xGCOMR01',0, 6})
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � xGCOMR01 � Autor � Carlos A. Queiroz  � Data �  18/12/2014 ���
�������������������������������������������������������������������������͹��
���Desc.     � Interface para alterar a observacao no Pedido de Compras.  ���
�������������������������������������������������������������������������͹��
���Uso       � GJP Hotels & Resorts                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function xGCOMR01()
Local cNumPC	:= SC7->C7_NUM
Local oDlg      := nil
Local oFont     := nil
Local oMemo     := nil
Local cTexto    := ""
Local nOpcX     := 0

dbSelectArea("SC7")
dbSetOrder(1)
If dbSeek(xFilial("SC7") + cNumPC)
	If SC7->C7_QUJE == SC7->C7_QUANT
		msginfo("Pedido totalmente atendido, n�o � poss�vel efetuar altera��es. Para verificar o conte�do, imprima o Pedido de Compras.")
		Return .t.
	Else
		cTexto  := SC7->C7_XOBS
	EndIf
EndIf

Define FONT oFont NAME "Courier New" SIZE 09,20

Define MsDialog oDlg Title "Observa��o ref. Pedido de Compra "+alltrim(SC7->C7_NUM) From 3, 0 to 340, 617 Pixel

@ 5, 5 Get oMemo Var cTexto Memo Size 300, 145 Of oDlg Pixel
oMemo:bRClicked := { || AllwaysTrue() }
oMemo:oFont     := oFont

Define SButton From 153, 145 Type  1 Action (oDlg:End(), nOpcX := 1)Enable Of oDlg Pixel // Ok
Define SButton From 153, 175 Type  2 Action oDlg:End() Enable Of oDlg Pixel              // Cancela

Activate MsDialog oDlg Center

If nOpcX == 1
	begin transaction
	_aArea := SC7->(GetArea())
	dbSelectArea("SC7")
	dbSetOrder(1)
	If dbSeek(xFilial("SC7") + cNumPC)
		While SC7->(!EOF()) .And. (xFilial("SC7") + cNumPC == SC7->(C7_FILIAL + C7_NUM))
			RecLock("SC7",.F.)
			SC7->C7_XOBS := cTexto
			MsUnLock()
			SC7->(dbSkip())
		EndDo
	EndIf
	RestArea(_aArea)
	end transaction
EndIf

Return