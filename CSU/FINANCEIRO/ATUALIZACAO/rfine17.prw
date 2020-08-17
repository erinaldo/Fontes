#include "rwmake.ch" 

User Function RFINE17() 

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
���Rotina    � RFINE17.PRW                                                ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � ExecBlock para retornar o nome do contribuinte da GPS     ���
���            Posicao 002 041 - Nome do Contribuinte                     ���
�������������������������������������������������������������������������Ĵ��
���Desenvolvi� Marciane Gennari                                           ���
���mento     � 11/04/2006                                                 ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Cnab Pagar Tributos                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/             
  _cRetorno := ""               
                                               
  If !Empty(SE2->E2_E_CONTR)
     _cRetorno := Subs(SE2->E2_E_CONTR,1,40)
  Else
     _cRetorno := Subs((Alltrim(SM0->M0_NOMECOM)+" - "+SM0->M0_NOME),1,40)
  EndIf
  
Return(_cRetorno)  