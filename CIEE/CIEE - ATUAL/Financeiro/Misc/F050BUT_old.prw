
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F050BUT   �Autor  �Claudio Barros      � Data �  20/07/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada para visualizacao do rateio financeiro no  ���
���          �SE2                                                         ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAFIN - CIEE - Protheus 8                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function F050BUT()


Local aBut050 := {}

//Private aHeader := {}
//Private aCols := {}
//Private aRegs := {}

If	INCLUI == .F. .and. ALTERA == .F. .AND. SE2->E2_MULNATU == "1"
  Aadd(aBut050, {'S4WB013N',{||	MultNat("SE2",0,M->E2_VALOR,"",.F.,2) },"Rateio das Naturezas do titulo","Rateio"} ) //"Rateio das Naturezas do titulo"###"Rateio das Naturezas do titulo"
ElseIf	ALTERA == .T. .AND. SE2->E2_MULNATU == "1" // Incluido pelo analista Emerson para permitir a alteracao das Naturezas (somente) no processo de Multi Naturezas (17/01/07)
	If FUNNAME() == "CFINA10"
		Aadd(aBut050, {'S4WB013N',{||	MultNat("SE2",0,M->E2_VALOR,"",.F.,4) },"Rateio das Naturezas do titulo","Rateio"} ) //"Rateio das Naturezas do titulo"###"Rateio das Naturezas do titulo"
	EndIf
EndIf

Return(aBut050)