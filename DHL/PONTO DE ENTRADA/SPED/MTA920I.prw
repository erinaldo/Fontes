

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA920I   �Autor  �Microsiga           � Data �  07/03/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada na NF Saida Manual Fiscal apos as         ���
���          � grava�oes. Tratativa para NFST alterar o CFOP              ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MTA920I

lRet      := .T.
_aAreaSD2 := GetArea()

//If IsInCallStack("CFGA600") //Rotina de Processamento do arquivo MILE
	If alltrim(SF2->F2_ESPECIE) == "NFST"
	
		_xCFOP	:= SF4->F4_CF //"7"+SUBSTR(SD2->D2_CF,2,3)
	
		RecLock("SD2",.F.)
		SD2->D2_CF := _xCFOP
		MsUnLock()
	
		RecLock("SF3",.F.)
		SF3->F3_CFO := _xCFOP
		MsUnLock()
	
		RecLock("SFT",.F.)
		SFT->FT_CFOP := _xCFOP
		MsUnLock()
	EndIf
//EndIf

RestArea(_aAreaSD2)
Return(lRet)