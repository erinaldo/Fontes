#INCLUDE "Protheus.ch"    
#INCLUDE "TbiConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �  MSD2520   �Autor  �  Eduardo Dias    � Data �  08/09/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Altera Flag do registro Calculo sobre Faturamento para 	  ���
���          � Deletado.										          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MSD2520
Local _aArea := GetArea()     

dbSelectArea("ZV2") //ZV2_FILIAL+ZV2_NOTA+ZV2_SERIE
DbSetOrder(1)                                                                                                          

If (dbSeek(xFilial("ZV2")+SF2->F2_DOC+SF2->F2_SERIE) .And. ZV2->ZV2_FLAG != "2" .And. xFilial("SF2") == '03')

	While ZV2->(!Eof()) .And. ZV2->ZV2_NOTA == SF2->F2_DOC .And. ZV2->ZV2_SERIE == SF2->F2_SERIE
	
		RecLock("ZV2",.F.)  
		ZV2->ZV2_FLAG := "2"
		ZV2->(MsUnlock())   
		
	ZV2->(dbSkip()) 
	
	EndDo

EndIf	

//nFlag := Posicione("ZV2",1,xFilial("ZV2")+(cAliasQry)->NOTA+(cAliasQry)->SERIE, "ZV2_FLAG")
    
RestArea(_aArea)

Return(.T.)
