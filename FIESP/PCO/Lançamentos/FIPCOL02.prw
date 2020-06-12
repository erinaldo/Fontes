#include "rwmake.ch"
#include "protheus.ch"
#include "TOPCONN.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FIPCOL02  �Autor  �Ligia Sarnauskas    � Data �  30/07/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Defini��o de valor em lancto PCO 000052                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � FIESP                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FIPCOL02()

_nValor:=0

If(SC7->C7_RATEIO=="1".OR. FUNNAME()=="CNTA120".OR.!EMPTY(SC7->C7_XNUMSV).OR.!EMPTY(SC7->C7_CONTRA).OR.SUBSTR(SC7->C7_CONTA,1,1)<>"4")
				 If (SUBSTR(SC7->C7_CONTA,1,6) == "120299" .OR. SUBSTR(SC7->C7_CONTA,1,6) == "120301" .OR. SUBSTR(SC7->C7_CONTA,1,6) == "120303" .OR. SUBSTR(SC7->C7_CONTA,1,6) == "120399" .OR. SUBSTR(SC7->C7_CONTA,1,6) == "120401" .OR. SUBSTR(SC7->C7_CONTA,1,6) == "120499")
	_nValor:=SC7->C7_TOTAL
	eLSE
	_nValor:=0                                                                       
	Endif
Else
   If substr(ALLTRIM(SC7->C7_CC),1,2)<> "19" 
	_nValor:=SC7->C7_TOTAL
   Endif
Endif

Return(_nValor)
