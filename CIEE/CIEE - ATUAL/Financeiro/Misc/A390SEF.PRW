#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �  A390SEF  � Autor � Andy               � Data �  11/04/02  ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada executado na rotina Cheque sobre T�tulos  ���
���          � em Contas a Pagar FINA390                                  ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function A390SEF()   

cNatur390:=SE2->E2_NATUREZ

/*cDocto := StrZero(Val(Getmv("MV_NUMCOP")) + 1, 6)
dbSelectArea("SX6")
GetMv("MV_NUMCOP")
RecLock("SX6",.F.)
Replace X6_CONTEUD With cDocto
MsUnlock()
dbSelectArea("SEF")
Reclock ("SEF", .F.)
Replace SEF->EF_NUMAP With cDocto
MsUnlock()

Reclock ("SE2", .F.)
SE2->E2_NUMAP   := cDocto
MsUnlock()     */

Return(.T.)
