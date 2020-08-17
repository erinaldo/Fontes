#include "rwmake.ch" 

User Function RFINE19() 

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
���Rotina    � RFINE19.PRW                                                ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � ExecBlock para retornar o endereco do contribuinte para a  ���
���            GPS                                                        ���
���            Posicao 042 081 - Endereco                                 ���
���            Mostrar mensagem de alerta se nao encontrar o endereco     ���
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
  
     //--- Pesquisa o endereco do contribuinte pelo CNPJ na tabela SA2.
     _cRetorno := GetAdvFval("SA2","A2_END",xFilial("SA2")+SE2->E2_E_CNPJC,3)
               
     If Empty(_cRetorno)
     
        MsgAlert('N�o foi encontrado endere�o cadastrado para o CNPJ/Contribuinte: '+alltrim(se2->e2_e_cnpjc)+"-"+alltrim(se2->e2_e_contr)+' . Atualize os dados no cadastro do fornecedor e execute esta rotina novamente.')

     EndIf

  Else

     _cRetorno := Subs(SM0->M0_ENDCOB,1,40) 
 
 EndIf
  
Return(_cRetorno)  