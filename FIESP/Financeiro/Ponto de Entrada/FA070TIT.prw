#include "rwmake.ch"
#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA070TIT  �Autor  �TOTVS               � Data �  07/23/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Emite mensagem de alert no momento da Baixa do Titulo a    ���
���          � Receber para analisar o Banco/Agencia/Conta do Projeto      ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FA070TIT()

Local _lRet 	:= .T.
Local _aArea 	:= GetArea()

//Fun��o para analisar o Item Contabil (PROJETO) e emitir Mensagem de Aviso ao usuario
_lRet := U_FIFINE02(alltrim(SE1->E1_XOBS))

RestArea(_aArea)

Return(_lRet)