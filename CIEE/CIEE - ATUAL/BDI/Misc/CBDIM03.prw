#include "rwmake.ch"
#include "TOPCONN.ch"
#Include "Protheus.Ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CBDIM03   �Autor  �Emerson Natali      � Data �  04/04/2007 ���
�������������������������������������������������������������������������͹��
���Desc.     � Validacao do Sexo no Cadastro de Contato com relacao ao    ���
���          � Tratamento                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CBDIM03()

_lRet := .T.

SZN->(DbSetOrder(1))
If SZN->(DbSeek(xFilial("SZN")+M->U5_NIVEL,.F.))
	If M->U5_SEXO == SZN->ZN_SEXO
		_lRet := .T.
	Else
		_lRet := .F.
		MsgBox("Tratamento incompativel com o Sexo do Contato")
	EndIf
EndIf

Return(_lRet)