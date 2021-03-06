#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �B237TPCTA    � Autor � CLAUDIO BARROS  � Data �  26/05/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para verificar o tipo da conta utilizada. Verifica  ���
���          � se a conta � conta corrente ou poupan�a.                   ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico CIEE - SIGAFIN (CNAB)                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function B237TPCTA()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local _cAlias := GetArea()
Local _lRet := " "
Private cString := "SE2"



dbSelectArea("SZK")
dbSetOrder(5)
SZK->(DbGoTop())
SZK->(DbSeek(xFilial("SZK")+SE2->E2_FORNECE+SE2->E2_LOJA))

While !SZK->(EOF()) .AND. SZK->ZK_FORNECE == SE2->E2_FORNECE .AND. SZK->ZK_LOJA == SE2->E2_LOJA
       
       IF ALLTRIM(SZK->ZK_NUMCON) == ALLTRIM(SE2->E2_CTAFOR)
          _lRet := SZK->ZK_TIPO 
       ENDIF   
       IF ALLTRIM(SZK->ZK_NROPOP) == ALLTRIM(SE2->E2_CTAFOR)
          _lRet := SZK->ZK_TIPO 
       ENDIF   
       IF ALLTRIM(SZK->ZK_NROCRT) == ALLTRIM(SE2->E2_CTAFOR)
          _lRet := SZK->ZK_TIPO 
       ENDIF   
       SZK->(DbSkip())   

End


RestArea(_cAlias)

Return(_lRet)
