#Include "Protheus.ch"

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  � MT160FIL  � Autor � Carlos A. Queiroz  � Data �  19/05/15   ���
��������������������������������������������������������������������������͹��
���Desc.     � Utilizado para filtrar as propostas de um item especifico   ���
���          � no processo de geracao de pedido de compras.                ���
��������������������������������������������������������������������������͹��
���Uso       � GJP Hotels & Resorts                                        ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
User Function MT160FIL()
Local cReturn := ".T."

If IsInCallStack("U_GJP130COT")
	cReturn := 'MAMONTACOT->C8_ITEM == "'+alltrim(_cItemFinCot)+'"'
EndIf 

Return cReturn