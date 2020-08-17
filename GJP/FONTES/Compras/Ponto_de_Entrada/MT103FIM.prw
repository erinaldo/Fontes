#INCLUDE "PROTHEUS.CH"
                                    
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT103FIM  �Autor  �Felipe Queiroz      � Data �  01/29/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Responsavel por popular o campo Nome de Usuario, na inclus�o ��
���          �do documento de entrada.                                    ���
�������������������������������������������������������������������������͹��
���Uso       � AP      SIGACOM - Compras                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT103FIM()

Local nOpcao 	:= PARAMIXB[1]   // Op��o Escolhida pelo usuario no aRotina 
Local nConfirma := PARAMIXB[2]   // Se o usuario confirmou a opera��o de grava��o da NFE

If nOpcao == 3
	If nConfirma == 1	
		RecLock("SF1",.F.)
		SF1->F1_XNOMUSR := USRRETNAME(RETCODUSR())
		SF1->(MsUnLock())
	Endif		
Endif

Return



 
 
 