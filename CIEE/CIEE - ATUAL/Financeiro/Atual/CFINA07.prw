#INCLUDE "rwmake.ch"
#include "_FixSX.ch" // "AddSX1.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFINA07   � Autor � Andy               � Data �  28/04/03   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de Documentos da Tarifacao Telefonica             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CFINA07

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cArq,cInd,cPerg
Local cString := "SZ6"
Local aStru
Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.


dbSelectArea("SZ6")
dbSetOrder(1)
AxCadastro(cString, "Documentos da Tarifacao Telefonica", cVldAlt, cVldExc)
Return
