#INCLUDE "rwmake.ch"    

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CBDIA01  � Autor � CRISTIANO GIARDINI � Data �  05/07/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de Categorias  - BDI                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico CIEE - SIGAESP (BDI)                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CBDIA06()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZW"

dbSelectArea("SZW")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Categorias",cVldExc,cVldAlt)

Return
