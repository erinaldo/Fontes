#include "RWmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ValLiq    �Autor  �Cesar Moura         � Data �  15/03/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna Valor Liquido para montagem do Bordero de pagamento ���
���          �nos arquivos Cnabs                                          ���
�������������������������������������������������������������������������͹��
���Uso       � MP8.11                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ValLiq()

Local cValLiq := ""                                 
Local nAbat     := 0
Local nDecres := 0
Local nAcresc := 0

nAbat	:= SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",SE2->E2_MOEDA,,SE2->E2_FORNECE)
nDecres := SE2->E2_DECRESC                  
nAcresc := SE2->E2_ACRESC                 

cValLiq:=PADL(Alltrim(str((SE2->E2_SALDO - nAbat + nAcresc - nDecres ) * 100 )), 15 , "0")


Return(cValLiq)
