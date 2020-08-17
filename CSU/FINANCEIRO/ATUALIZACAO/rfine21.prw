#include "rwmake.ch" 

User Function RFINE21() 

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_cRetorno,_cCdRet")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
����������������������������������������������������������������������� �Ŀ��
���Rotina    � RFINE21.PRW                                                ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � ExecBlock para retornar o Nome do Recolhedor para a GPS    ���
���            Posicao 343 382 - Nome do Recolhedor                       ���
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
     
  _cCdRet := If(!Empty(SE2->E2_E_CINSS),SE2->E2_E_CINSS,SE2->E2_CODRET)
                                            
  If _cCdRet == "2631" .or. _cCdRet == "2658" 
  
     _cRetorno := AllTrim(SM0->M0_NOMECOM)+" - "+AllTrim(SM0->M0_NOME)
     
 EndIf
  
Return(_cRetorno)  