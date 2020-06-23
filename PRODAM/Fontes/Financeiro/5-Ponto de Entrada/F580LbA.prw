#Include 'Protheus.ch'
#include "topconn.ch" 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � F580LbA � Autor � Felipe Santos        � Data � 12/09/15 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o � O ponto de entrada FA580LIB foi desenvolvido para bloquear ��
��� ou n�o a libera��o manual. Necessita de um retorno .T. ou .F.
�����������������������������������������������������������������������������
���Sintaxe   �							            					  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function F580LbA()

Local lRet := .T.

If E2_XORDLIB = "BLC" .or. E2_XORDLIB = "BLS"
	MSGINFO('ATEN��O: T�tulo ' +E2_NUM+ " est� bloqueado por "+ IIF(E2_XORDLIB="BLC","CADIN","SALDO")+ " e n�o poder� ser liberado antes do desbloqueio" )
	lRet := .F.
EndIf

Return lRet                                       