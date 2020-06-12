#INCLUDE "rwmake.ch"    

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

AxCadastro(cString,"Cadastro de Tratamentos",cVldExc,"u_fVldAlt2()")

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