#INCLUDE "rwmake.ch"
#include "_FixSX.ch" // "AddSX1.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFINA15   � Autor � Andy               � Data �  08/08/03   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de Unidade da Tarifacao Telefonica                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CFINA15

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cArq,cInd,cPerg
Local cString := "SZU"
Local aStru
Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.


dbSelectArea("SZU")
dbSetOrder(1)
AxCadastro(cString, "Unidades da Tarifacao Telefonica", cVldAlt, cVldExc)
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFINA15   �Autor  �Microsiga           � Data �  08/15/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ValEMail()
Local cLit   := ' {}()<>[]|\/&*$ %?!^~`,;:=#'
Local lRet   := .T.
Local nResto := 0
Local nI 
Local aArea    := GetArea()
Local cEmail := M->ZU_EMAIL1
Local _aEmail := {M->ZU_EMAIL1, M->ZU_EMAIL2, M->ZU_EMAIL3, M->ZU_EMAIL4, M->ZU_CC1, M->ZU_CC2}

For _nX := 1 to Len(_aEmail)

	cEmail := AllTrim( _aEmail[_nX] )

	If !Empty(cEmail)
		For nI := 1 To Len( cLit )
			If At( SubStr( cLit, nI, 1 ), cEmail )  >   0 
				ApMsgStop( 'Existe um caracter invalido para e-mail', 'ATEN��O' )
				lRet   := .F.
				Exit
			EndIf
		Next

		If lRet
			If ( nResto := At( "@", cEmail ) ) > 0 .AND. At( "@", Right( cEmail, Len( cEmail ) - nResto ) ) == 0
				If ( nResto := At( ".", Right( cEmail, nResto ) ) ) == 0
					lRet := .F.
					ApMsgStop( 'Endere�o de e-mail incompleto', 'ATEN��O' )
				EndIf
			Else
				ApMsgStop( 'Endere�o de e-mail invalido', 'ATEN��O' )
				lRet := .F.
			EndIf
		EndIf   
	EndIf   
Next
RestArea( aArea )

Return lRet