#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PCOA5001  �Autor  �Microsiga           � Data �  23/04/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � PE para bloquear exclusao quando CTG for de Solic. Contrato���
�������������������������������������������������������������������������͹��
���Uso       � P11 - FIESP                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function PCOA5001()
Local _lRet := .T.

// Verifica se � lan�amento de Solicita��o de Contrato
IF (!INCLUI .and. !ALTERA) .and. ALI->ALI_PROCESS == "900001"
	Aviso("Aten��o", "Conting�ncias geradas via Solicita��o de Contrato n�o podem ser exclu�das", {"Sair"} )
	_lRet := .f.
ENDIF

IF (!INCLUI .and. !ALTERA) .and. ALI->ALI_PROCESS == "900002"
	Aviso("Aten��o", "Conting�ncias geradas via Solicita��o de Viagem n�o podem ser exclu�das", {"Sair"} )
	_lRet := .f.
ENDIF

Return(_lRet)
