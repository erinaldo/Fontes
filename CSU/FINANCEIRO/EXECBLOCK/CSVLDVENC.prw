#INCLUDE "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSVLDVENC � Autor � Renato Carlos      � Data �  20/03/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Valida��o especifica CSU para nao permitir a alteracao     ���
���          � da data de vencimento do titulo na inclus�o da nota        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CSVLDVENC()

Local _dVencto := CTOD("//")
Local _lRet     := .T.

/*����������������������������������������������������������������������������Ŀ
� OS 3301/11 - n�o permitir a altera��o via documento de entrada               �
��������������������������������������������������������������������������������*/

If Funname() $ "MATA103"  
   _dVencto  := Condicao(10,cCondicao,,ddEmissao)[1][1]    
   
   IF M->E2_VENCTO < _dVencto
      MsgAlert( " O vencimento do titulo n�o pode ser alterado via documento de entrada. O sistema manter� o vencimento original.")
	  Return(_dVencto)
   ELSE
	  Return(M->E2_VENCTO)
   ENDIF   
Else
	Return(M->E2_VENCTO)
EndIf
	 
	  