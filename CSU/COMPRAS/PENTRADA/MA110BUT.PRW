#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA110BUT�Autor � Marcos Rocha-Oficina1  � Data � 08/10/2010 ���
�������������������������������������������������������������������������͹��
���Desc.     � Bloqueia a execussao do Tracker para pedidos em cotacao.   ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MA110BUT

Local aBotoes := PARAMIXB[2]

//MsgStop("Teste - Ponto de Entrada MA110BUT")

For nX := 1 To Len(aBotoes)
	If "Tracker" $ aBotoes[nX,3]
		aBotoes[nX,2] :=  {|| U_A110TRACK() }
	EndIf
Next

Return(aBotoes)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � A110Track� Autor � Aline Correa do Vale  � Data �16/06/2003���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Faz o tratamento da chamada do System Tracker              ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � .T.                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//Static Function A110Track()
User Function A110Track()

Local aEnt     := {}
Local cKey     := "" 
Local nPosItem := GDFieldPos( "C1_ITEM" )
Local nLoop    := 0
Local aArea    := GetArea()

DbSelectArea("SY1")
DbSetOrder(3)
//If U_ECOMA01(SC1->C1_PEDIDO,2)
If !DbSeek(xFilial("SY1")+__cUserId)
	If U_ECOMA01(SC1->C1_PEDIDO)
		Aviso(OemToAnsi("Aviso"),OemToAnsi("Solicita��o em Processo de Cota��o !"), {"Ok"},1,OemToAnsi("N�o permitido"))
		Return(.T.)
	EndIf
EndIf	
/*
If Empty(xFilial("SC1")) .And. Empty(xFilial("SC7")) .And. Empty(xFilial("SC8"))
	cKey:= cA110Num
Else
	cKey:= xFilial("SC1") + cA110Num
EndIf
*/
cKey:= xFilial("SC1") + cA110Num
//���������������������������������������������Ŀ
//� Carrega os itens para rastreamento          �
//�����������������������������������������������
For nLoop := 1 To Len( aCols )
	AAdd( aEnt, { "SC1", cKey + aCols[ nLoop, nPosItem ] } )
Next nLoop

MaTrkShow( aEnt )

RestArea(aArea)

Return( .T. )