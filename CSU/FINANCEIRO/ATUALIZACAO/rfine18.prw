#include "rwmake.ch" 

User Function RFINE18() 

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
���Rotina    � RFINE13.PRW                                                ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � ExecBlock para retornar o CPF/CNPJ do contribuinte para a  ���
���            GPS                                                        ���
���            Posicao 133 147 - CPF/CNPJ do Contribuinte (GPS)           ���
�������������������������������������������������������������������������Ĵ��
���Desenvolvi� Marciane Gennari                                           ���
���mento     � 11/04/2006                                                 ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Cnab a Pagar Bradesco - Tributos                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/             
  _cRetorno := ""               
                                               
  If !Empty(SE2->E2_E_CONTR)
  
     If Empty(SE2->E2_E_CNPJC)
     
        MsgAlert('O titulo de tributo '+alltrim(se2->e2_prefixo)+"-"+alltrim(se2->e2_num)+" "+alltrim(se2->e2_parcela)+' do fornecedor '+alltrim(se2->e2_fornece)+" "+alltrim(se2->e2_loja)+' est� sem o CNPJ/CPF do Contribuinte. Atualize os dados no titulo e execute esta rotina novamente.')

     EndIf
     
     _cRetorno := Strzero(Val(SE2->E2_E_CNPJC),14)
     
  Else

     _cRetorno := Strzero(Val(SM0->M0_CGC),14)
 
  EndIf
  
Return(_cRetorno)  