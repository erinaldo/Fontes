#INCLUDE "rwmake.ch"
#include "_FixSX.ch" // "AddSX1.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFINA13   � Autor � Andy               � Data �  06/05/03   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de CNI - Agencia                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CFINA13

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cArq,cInd,cPerg
Local cString := "SZA"
Local aStru
Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.


dbSelectArea("SZA")
dbSetOrder(1)
AxCadastro(cString, "CNI - Agencia", cVldAlt, cVldExc)
Return
