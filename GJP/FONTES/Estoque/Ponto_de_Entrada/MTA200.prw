/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  | MTA200    �Autor  �Felipe Queiroz     � Data �  14/04/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Respons�vel pela valida��o ao Final da Inclus�o/Altera��o   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �GJP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
	User Function MTA200
	Local lRet := .T.
	
	If M->G1_XCUSTO == "1"
		
		DbSelectArea("SBZ")
		DbSetOrder(1)
		IF MsSeek( xFilial("SBZ") + M->G1_COMP,.T.)
			RecLock("SBZ",.F.)
			SBZ->BZ_FANTASM		:= "N"
			MsUnlock()
		EndIf	
	EndIf
		
	If M->G1_XCUSTO == "2"
		
		DbSelectArea("SBZ")
		DbSetOrder(1)
		IF MsSeek( xFilial("SBZ") + M->G1_COMP,.T.)
			RecLock("SBZ",.F.)
			SBZ->BZ_FANTASM		:= "S"
			MsUnlock()
			MsUnlock()
		EndIf
	EndIf	     
		           
	Return(lRet)