
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FICTBA04  �Autor  �Microsiga           � Data �  07/10/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa utilizado na Consulta Padrao PRJCTD (especifico)  ���
���          � utilizado para filtrar usuario PROJETO                     ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FICTBA04()

Local _cItem := ""
Local _nCont := 1

SZB->(DbSetOrder(2))
If SZB->(DbSeek(xFilial("SZB")+__CUSERID))
	Do While !EOF() .and. SZB->ZB_USERID == __CUSERID
		If _nCont > 1
			_cItem += "|"
		EndIf
		_cItem += SZB->ZB_ITEM
		_nCont++
		SZB->(DbSkip())
	EndDo
	_cFiltro	:= 'CTD_ITEM $ "'+_cItem+'" '
Else
	_cFiltro	:= ''
EndIf

Return(_cFiltro)