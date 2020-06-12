#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFINA37   � Autor � CRISTIANO GIARDINI � Data �  25/05/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro Configuracao CNAB                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico CIEE - SIGAFIN                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CFINA37()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZL"

dbSelectArea("SZL")
dbSetOrder(1)

AxCadastro(cString,"Cadastro Configuracao CNAB",cVldExc,cVldAlt)

Return
