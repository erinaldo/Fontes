#include "rwmake.ch" 

User Function RFINE23() 

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_cRetorno")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
����������������������������������������������������������������������� �Ŀ��
���Rotina    � RFINE23.PRW                                                ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � ExecBlock para retornar o tipo de inscricao do contribuinte���
���            para a GPS.                                                ���
���            Posicao 132 132 - Tipo de Inscricao    1=CPF 2=CNPJ        ���
�������������������������������������������������������������������������Ĵ��
���Desenvolvi� Marciane Gennari                                           ���
���mento     � 03/05/2006                                                 ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Cnab a Pagar Tributos (237gps.cpe)                         ���
��������������������������������������������������������������������������ٱ�
/*/             
  _cRetorno := ""               
                                               
  If !Empty(SE2->E2_E_CONTR)
     _cRetorno := Iif (len(alltrim(SE2->E2_E_CNPJC))>11,"2","1")
  Else               
     _cRetorno := "2"       
  EndIf
  
Return(_cRetorno)  