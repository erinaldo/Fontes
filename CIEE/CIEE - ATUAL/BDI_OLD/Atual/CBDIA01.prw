#INCLUDE "rwmake.ch"    
#include "TOPCONN.CH"
#Include "Protheus.Ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CBDIA01  � Autor � CRISTIANO GIARDINI � Data �  05/07/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de Tratamentos - BDI                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico CIEE - SIGAESP (BDI)                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CBDIA01()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZN"

dbSelectArea("SZN")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Tratamentos","u_fVldExc2()","u_fVldAlt2()")

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CBDIA09   �Autor  �Microsiga           � Data �  04/04/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function fVldAlt2()

_lRet   := .T.
_aArea  := GetArea()
_cQuery := ""

If SZN->ZN_DESCRI <> M->ZN_DESCRI
	_cQuery := "UPDATE "+RetSQLname('SU5')+" SET U5_DNIVEL = '"+M->ZN_DESCRI+"' "
	_cQuery += "WHERE D_E_L_E_T_ <> '*' "
//	_cQuery += "AND U5_DNIVEL = '"+SZN->ZN_DESCRI+"' "
	_cQuery += "AND U5_NIVEL = '"+SZN->ZN_CODTRAT+"' "
	TcSQLExec(_cQuery)

	_cQuery := "UPDATE "+RetSQLname('SZR')+" SET ZR_DESCRI = '"+M->ZN_DESCRI+"' "
	_cQuery += "WHERE D_E_L_E_T_ <> '*' "
//	_cQuery += "AND ZR_DESCRI = '"+SZN->ZN_DESCRI+"' "
	_cQuery += "AND ZR_CODTRAT = '"+SZN->ZN_CODTRAT+"' "
	TcSQLExec(_cQuery)

/*		
	_cQuery := "UPDATE "+RetSQLname('SZZ')+" SET ZZ_TRAT = '"+M->ZN_DESCRI+"' "
	_cQuery += "WHERE D_E_L_E_T_ <> '*' "
	_cQuery += "AND ZZ_TRAT = '"+SZN->ZN_DESCRI+"' "
	TcSQLExec(_cQuery)
*/
EndIf

RestArea(_aArea)

Return(_lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CBDIA09   �Autor  �Microsiga           � Data �  04/04/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function fVldExc2()

_lRet   := .T.
_aArea  := GetArea()
_cQuery := ""

_cQuery := "SELECT COUNT(U5_NIVEL) AS QTDE "
_cQuery += "FROM "+RetSQLname('SU5')+" "
_cQuery += "WHERE D_E_L_E_T_ <> '*' "
_cQuery += "AND U5_NIVEL = '"+SZN->ZN_CODTRAT+"' "
TcQuery _cQuery New Alias "TMPSU5"

If TMPSU5->QTDE > 0
	_lRet   := .F.
	TMPSU5->(DbCloseArea())
	MsgBox("Nao pode Excluir o Tratamento pois o mesmo tem amarracao com o Contato")
Else
	_cQuery := "SELECT COUNT(ZR_CODTRAT) AS QTDE "
	_cQuery += "FROM "+RetSQLname('SZR')+" "
	_cQuery += "WHERE D_E_L_E_T_ <> '*' "
	_cQuery += "AND ZR_CODTRAT = '"+SZN->ZN_CODTRAT+"' "
	TcQuery _cQuery New Alias "TMPSZR"
	If TMPSZR->QTDE > 0
		_lRet   := .F.
		TMPSZR->(DbCloseArea())
		MsgBox("Nao pode Excluir o Tratamento pois o mesmo tem amarracao com o Perfil")	
	EndIf
EndIf

RestArea(_aArea)

Return(_lRet)