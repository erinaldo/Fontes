#include "rwmake.ch"
#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA080TIT  �Autor  �TOTVS   a           � Data �  07/22/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Emite mensagem de alert no momento da Baixa do Titulo a    ���
���          � Pagar para analisar o Banco/Agencia/Conta do Projeto       ���
�������������������������������������������������������������������������͹��
���Uso       � FIESP                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FA080TIT()

Local _lRet 	:= .T.
Local _aArea 	:= GetArea()

//Fun��o para analisar o Item Contabil (PROJETO) e emitir Mensagem de Aviso ao usuario
_lRet := U_FIFINE02(alltrim(SE2->E2_XOBS))

RestArea(_aArea)

Return(_lRet)