#INCLUDE 'PROTHEUS.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � PNA130GRV�Autor  � Isamu Kawakami     � Data �  29/04/2009 ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada antes de confirmar a altera��o/inclus�o   ���
���          � do lan�amento de Apontamentos                              ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CSUVALCID

Local lRet      := .T. 
Local nPosCID	:= GdFieldPos("PC_CID")
Local nPosAbo	:= GdFieldPos("PC_ABONO")
Local cCpoCID   := aCols[n][nPosCID]
//Local cCpoAbo   := aCols[n][nPosAbo] - So e carregado apos o usuario entrar no campo pela segunda vez.

If M->PC_ABONO == "001" .and. Empty(cCpoCID)
   Alert("Abonos por Atestado M�dico, preencher o campo COD.CID (Codigo Internacional de Doencas). Retorne e cadastre esse codigo !!!")
   lRet := .F.
Endif    



Return (lRet)