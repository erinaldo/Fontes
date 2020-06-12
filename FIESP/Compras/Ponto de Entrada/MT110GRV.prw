#include "rwmake.ch"
#include "protheus.ch"
#include "TOPCONN.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT110GRV  �Autor  �L�gia Sarnauskas    � Data �  11/11/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada executado ap�s a grava��o da solicita��o  ���
���          � de compras.                                                ���
�������������������������������������������������������������������������͹��
���Uso       � FIESP                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT110GRV()

lExp1 :=  PARAMIXB[1]//Rotina do Usuario para poder gravar campos especificos ou alterar campos gravados do item da SC.
_cSolic:=SC1->C1_NUM
_cItem:=SC1->C1_ITEM

Dbselectarea("SC1")
Dbsetorder(1)
If Dbseek(xFilial("SC1")+_cSolic+_cItem)
  Reclock("SC1",.F.)
    SC1->C1_APROV:="B" // grava todas as solicita��es de compras como bloqueadas, mesmo que tenha solicitante liberado por grupo de produto.
  MsUnlock()
Endif
Return