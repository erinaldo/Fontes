/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RPCOA06  �Autor  �Fernando Garrigos    � Data �  02/03/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Hist�rico - NF Entrada								      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RPCOA06()

Local _Hist		:= ""
Local cQuery	:= ""
Local cFornece	:= SD1->D1_FORNECE
Local cLoja		:= SD1->D1_LOJA

_Hist := "NF ENT. :"+SD1->D1_DOC+" - "+SD1->D1_ITEM +" - "+"Pedido: "+SD1->D1_PEDIDO+" - "+SD1->D1_ITEMPC

cQuery	:=	" SELECT A2_NOME AS NOME FROM "+RetSqlName("SA2")+ " SA2 "
cQuery	+=	" WHERE A2_FILIAL = '"+xFilial('SA2')+"' AND "
cQuery	+=	" A2_COD ='"+cFornece+"'
cQuery	+=	" AND A2_LOJA ='"+cLoja+"'
cQuery	+=	" AND SA2.D_E_L_E_T_<> '*' "
cQuery	:=	ChangeQuery(cQuery)

dbUseArea( .T., "TopConn", TCGenQry(,,cQuery),"TRB", .F., .F. )
DbSelectArea("TRB")

IF !EMPTY(TRB->NOME)
	_Hist := _Hist+" - "+TRB->NOME
ENDIF

DbCloseArea("TRB")

Return(_Hist)
