#include "Protheus.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO7     �Autor  �Microsiga           � Data �  05/28/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT110TEL()
Local xoDlg    := PARAMIXB[1] 
Local xaPosGet := PARAMIXB[2] 
Local nOpcx    := PARAMIXB[3] 
Local nReg     := PARAMIXB[4]

If nOpcx == 8
	INCLUI := .T.
     nOpcx := 3
EndIf

If IsInCallStacks("a110inclui")
	_SetNamedPrvt("nOpcx",3, "A110Inclui") 
EndIf

Return 