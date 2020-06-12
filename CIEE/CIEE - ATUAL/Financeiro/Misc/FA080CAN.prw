#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �  FA080CAN � Autor � Andy               � Data �  17/03/04  ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada executado no Cancelamento de Baixa FINA080���
���          � de Titulo de Contas a Pagar, para que a movimentacao       ���
���          � original de baixa esteja com status cancelado              ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function FA080CAN()

// No programa de cancelamento de baixa qdo o E2_TIPODOC<> de "VL" e "BA" ent�o E5_SITUACA:="C"

Local _aAreaSE5
Local _aAux
Local _cChave


_aAux     := {"VL"}  //,"CM","CX","DC","MT","JR","BA"}
_aAreaSE5 := SE5->(GetArea())
_cChave   := SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+DTOS(SE2->E2_MOVIMEN)+SE2->E2_FORNECE+SE2->E2_LOJA

SE5->(dbSetOrder(2))
For nI := 1 to len(_aAux)
	If SE5->( dbSeek(xFilial("SE5")+_aAux[ni]+_cChave))
		Reclock("SE5",.F.,.T.)
		dbDelete()
		MsUnlock()
	Endif
Next

SE5->(RestArea(_aAreaSE5))

Return()

