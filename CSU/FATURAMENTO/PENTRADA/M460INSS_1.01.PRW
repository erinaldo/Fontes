#include "rwmake.ch"

/*MTDO - NOV./2004 ADEQUADO PARA NOVA VIS�O (SZ2) POR AREA DE NEGOCIO
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M460INSS  �Autor  �Daniel Paiva        � Data �  07/24/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Ponto de entrada para atender necessidade especifica de   ���
���          �calculo de INSS. Cliente CSU - CardSystem                   ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function M460INSS

_TotINSS:= 0
_CodArea:=" "
_aArea := GetArea()     

IF	SC5->C5_AREA=="CARD"
	_CodArea:="02"
ElseIf SC5->C5_AREA=="CRED"
	_CodArea:="03" 
ElseIf SC5->C5_AREA=="CONT"  // OS 1928/15 By Douglas David
	_CodArea:="04"	
ElseIf SC5->C5_AREA=="MARK"
	_CodArea:="07"	
Else
	_CodArea:="  "
EndIf


DBSelectArea("SZ2")
DBSetOrder(1)
 
If DBSeek(xFilial("SZ2")+SA1->A1_COD+SA1->A1_LOJA+_CodArea,.F.)
	
	IF!Empty(SZ2->Z2_BASINSS)
//		_TotINSS := (SZ2->Z2_BASINSS*((SF2->F2_VALBRUT*SB1->B1_PERINSS)/100)/100)
		_TotINSS := (SZ2->Z2_BASINSS*SF2->F2_VALINSS*0.01)
	else
//		_TotINSS := (SB1->B1_PERINSS*(SF2->F2_VALBRUT)/100)
		_TotINSS := SF2->F2_VALINSS
	endif
	
EndIf
RestArea(_aArea)

Return(_TotINSS)
