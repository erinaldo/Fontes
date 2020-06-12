#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A390AVU   � Autor � Nadia C. Mamude    � Data �  27/05/02   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada executado na rotina Cheques Avulsos que   ���
���          � abre campo memo para gravacao do Beneficiario e Historico  ���
���          � do cheque.                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function A390AVU

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Private cString := "SEF", cTexto  := "" ,cTexto1 :=""
dbSelectArea("SEF")

// Monta a tela de dialog.
@ 116, 090 To 236, 400 Dialog oDlgMemo Title "Beneficiario"
@ 003, 005 Get cTexto Size 146, 040 MEMO Object oMemo
@ 044, 120 BmpButton Type 1 Action Close(oDlgMemo)
Activate Dialog oDlgMemo

//Grava o Beneficiario do Cheque conforme digitacao
Reclock("SEF",.F.)
Replace SEF->EF_BENEF WITH cTexto
MsUnlock()


dbSelectArea("SEF")
// Monta a tela de dialog.
@ 116, 090 To 236, 400 Dialog oDlgMemo Title "Historico do Cheque"
@ 003, 005 Get cTexto1 Size 146, 040 MEMO Object oMemo
@ 044, 120 BmpButton Type 1 Action Close(oDlgMemo)
Activate Dialog oDlgMemo

//Grava o Historico do cheque conforme digitacao
Reclock("SEF",.F.)
Replace SEF->EF_HIST WITH cTexto1
MsUnlock()         

Return