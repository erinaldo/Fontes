#include "rwmake.ch"
#include "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FICOME04  �Autor  �TOTVS               � Data �  08/27/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao chamado pelo ponto de Entrada MT140ROT              ���
���          � Tratamento de Liberacao da Pre-Nota de Entrada             ���
�������������������������������������������������������������������������͹��
���Uso       � FIESP                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FICOME04

Local _aArea := GetArea()

_cQry := "SELECT SD1.D1_PEDIDO, SC7.C7_NUMSC, SC1.C1_USER "
_cQry += "FROM "+RetSqlName("SD1")+" SD1, "+RetSqlName("SC7")+" SC7, "+RetSqlName("SC1")+" SC1 "
_cQry += "WHERE SD1.D_E_L_E_T_ = '' AND SC7.D_E_L_E_T_ = '' AND SC1.D_E_L_E_T_ = '' "
_cQry += "AND SD1.D1_PEDIDO = SC7.C7_NUM "
_cQry += "AND SC7.C7_NUMSC = SC1.C1_NUM "
_cQry += "AND SD1.D1_DOC = '"+SF1->F1_DOC+"' "
_cQry += "AND SD1.D1_SERIE = '"+SF1->F1_SERIE+"' "
_cQry += "AND SD1.D1_FORNECE = '"+SF1->F1_FORNECE+"' "
_cQry += "AND SD1.D1_LOJA = '"+SF1->F1_LOJA+"' "
_cQry += "GROUP BY SD1.D1_PEDIDO, SC7.C7_NUMSC, SC1.C1_USER "
_cQry := ChangeQuery(_cQry)
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQry),"TRBPRE",.t.,.t.)
	
DbSelectArea("TRBPRE")
DbGotop()
If TRBPRE->C1_USER == __CUSERID
	If RecLock("SF1",.F.)
		SF1->F1_XSTATUS := "L" //Liberado
		MsUnLock()
		msgbox("Pre-Nota Liberada!!!")
	EndIf
Else
	msgbox("Usuario Nao Autorizado ha Liberar Pre-Nota!!!")
EndIf
DbSelectArea("TRBPRE")
TRBPRE->(DbCloseArea())

RestArea(_aArea)

Return