#INCLUDE "rwmake.ch"
#include "_FixSX.ch" // "AddSX1.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFINA08   � Autor � Andy               � Data �  28/04/03   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de Prestadora da Tarifacao Telefonica             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CFINA08

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cArq,cInd,cPerg
Local cString := "SZ7"
Local aStru
Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.


dbSelectArea("SZ7")
dbSetOrder(1)
AxCadastro(cString, "Prestadoras da Tarifacao Telefonica", cVldAlt, cVldExc)
Return
