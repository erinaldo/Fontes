#INCLUDE "rwmake.ch"    

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CBDIA02  � Autor � CRISTIANO GIARDINI � Data �  05/07/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de Eventos - BDI                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico CIEE - SIGAESP (BDI)                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CBDIA02()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZO"

dbSelectArea("SZO")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Eventos",cVldExc,cVldAlt)

Return
