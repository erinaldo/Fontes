#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A020DELE  � Autor � CLAUDIO BARROS     � Data �  12/05/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada para validar a exclus�o do cad. fornecedor���
���          � verificando se existe conta corrente cadastrada.           ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAFIN - CFINA34                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function A020DELE()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������


Local cString := "SZK"
Local lRet := .T.
dbSelectArea("SZK")
dbSetOrder(5)
SZK->(DbGotop())

IF SZK->(DbSeek(xFilial("SZK")+SA2->A2_COD+SA2->A2_LOJA))
   MSGSTOP("Existe Conta Corrente pra Esse Fornecedor, Favor Entrar na Rotina e Excluir!!!")
   lRet := .F.  
ENDIF   

Return(lRet)
