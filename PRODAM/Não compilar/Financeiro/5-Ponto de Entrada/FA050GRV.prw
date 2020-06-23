#Include 'Protheus.ch'
#include "topconn.ch" 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FA050GRV � Autor � Felipe Santos        � Data � 12/09/15 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o � O ponto de entrada FA050GRV sera utilizado apos a gravacao ��
��� de todos os dados (na inclus�o do t�tulo) e antes da sua contabiliza��o��
�����������������������������������������������������������������������������
���Sintaxe   �							            					  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FA050GRV()

Local dDataBloq := SE2->E2_XDTCADI
Local dDataDesb := SE2->E2_XDT1CAD
Local cMotBloqu := SE2->E2_XMOTBLQ
Local lRet 		:= .T.


If dDataBloq > SE2->E2_VENCREA //DATA DE BLOQUEIO N�O PODE SER MAIOR QUE VENCIMENTO REAL
	MSGINFO('Erro: Data de Bloqueio n�o poder� ser superior ao vencimento real do t�tulo')
	lRet := .F.
	Return
EndIf

If dDataBloq > dDataDesb //DATA DE BLOQUEIO N�O PODE SER MAIOR QUE O DESBLOQUEIO
	MSGINFO('Erro: Data de Bloqueio n�o poder� ser superior ao desbloqueio')
	lRet := .F.
	Return
EndIf

If lRet 
	If !Empty(dDataBloq) .and. Empty(dDataDesb)
		If cMotBloqu = "1" //MOTIVO CADIN
			RECLOCK("SE2",.F.)
			SE2->E2_XORDLIB := "BLC"
			SE2->E2_DATALIB := ""
			MSUNLOCK() 
		ElseIf cMotBloqu = "2" //BLOQUEIO SALDO
			RECLOCK("SE2",.F.)
			SE2->E2_XORDLIB := "BLS"
			MSUNLOCK() 	
		EndIf
	Else
		If Empty(SE2->E2_DATALIB) //CASO ESTEJA LIBERADO PARA PAGAMENTO POR�M MOTIVO DE BLOQ. POR CADIN
			SE2->E2_XORDLIB := "LIS"		
		Else
			SE2->E2_XORDLIB := "LIC"
		EndIf
	Endif 
	
EndIf

Return lRet
