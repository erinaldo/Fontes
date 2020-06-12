#include "rwmake.ch"
#include "protheus.ch"
#include "TOPCONN.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA130C8  �Autor  �L�gia Sarnauskas    � Data �  06/12/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada acionado pela rotina Gera Cota��o         ���
�������������������������������������������������������������������������͹��
���06/12/2013� Tratamento para gravar as observa��es do campo memo da     ���
���          � solicita��o para o campo memo da cota��o, assim poder� ser ���
���          � visto pelo comprador.                                      ���
�������������������������������������������������������������������������͹��
���Uso       � FIESP                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                                                                           

User Function MTA130C8() 

Local _cSolita := SC8->C8_NUMSC
Local _cItem   := SC8->C8_ITEMSC

Dbselectarea("SC1")
Dbsetorder(1)
If Dbseek(xFilial("SC1")+_cSolita+_cItem)
SC8->C8_XOBSSOL:=SC1->C1_XOBSSOL
Endif
Return Nil