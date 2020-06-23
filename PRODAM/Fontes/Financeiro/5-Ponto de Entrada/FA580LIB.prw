#Include 'Protheus.ch'
#include "topconn.ch" 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FA580LIB � Autor � Felipe Santos        � Data � 12/09/15 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o � O ponto de entrada FA580LIB foi desenvolvido para bloquear ��
��� ou n�o a libera��o manual. Necessita de um retorno .T. ou .F.
�����������������������������������������������������������������������������
���Sintaxe   �							            					  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FA580LIB()

Local lRet := .T.

If SE2->E2_XORDLIB = "BLC" .or. SE2->E2_XORDLIB = "BLS"
	MSGINFO('ATEN��O: T�tulo ' +SE2->E2_NUM+ " est� bloqueado por "+ IIF(SE2->E2_XORDLIB="BLC","CADIN","SALDO")+ " e n�o poder� ser liberado antes do desbloqueio" )
	lRet := .F.
EndIf

Return lRet                                       