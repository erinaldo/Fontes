#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A100TR01  � Autor � Nadia C.Mamude     � Data �  21/06/02   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada executado na rotina Cheque S/Titulos      ���
���          � que grava atraves de campo Memo o Historico e beneficiario ���
���          � do cheque.                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function A100TR01                                                 

If AllTRim(FunName())<>"FINA100"

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Private cString := "SE5", cTexto  := "" , cTexto1 := ""
dbSelectArea("SE5")

//MONTA TELA PARA DIGITACAO DO HISTORICO
@ 116, 090 To 236, 400 Dialog oDlgMemo Title "Historico...."
@ 003, 005 Get cTexto Size 146, 040 MEMO Object oMemo
@ 044, 120 BmpButton Type 1 Action Close(oDlgMemo)
Activate Dialog oDlgMemo

Reclock("SE5",.F.)
Replace SE5->E5_HISTOR WITH cTexto
MsUnlock()

DbSelectArea("SEF")
Reclock("SEF",.F.)
Replace SEF->EF_HIST WITH cTexto
MsUnlock()

// Monta a tela de dialog.
@ 116, 090 To 236, 400 Dialog oDlgMemo Title "Beneficiario....."
@ 003, 005 Get cTexto1 Size 146, 040 MEMO Object oMemo
@ 044, 120 BmpButton Type 1 Action Close(oDlgMemo)
Activate Dialog oDlgMemo

Reclock("SE5",.F.)
Replace SE5->E5_BENEF WITH cTexto1
MsUnlock()

DbSelectArea("SEF")
Reclock("SEF",.F.)
Replace SEF->EF_BENEF WITH cTexto1
MsUnlock()
EndIf

Return