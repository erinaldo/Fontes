#include "rwmake.ch"
#Include "Protheus.Ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CBDIM02   �Autor  �Emerson Natali      � Data �  04/04/2007 ���
�������������������������������������������������������������������������͹��
���Desc.     � Validacao do Sexo no Cadastro de Contato com relacao ao    ���
���          � Cargo                                                      ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CBDIM02()

_lRet := .T.

SUM->(DbSetOrder(1))
If SUM->(DbSeek(xFilial("SUM")+M->U5_CARGO,.F.))
	If M->U5_SEXO == SUM->UM_SEXO
		_lRet := .T.
	Else
		_lRet := .F.
		MsgBox("Cargo incompativel com o Sexo do Contato")
	EndIf
EndIf

Return(_lRet)