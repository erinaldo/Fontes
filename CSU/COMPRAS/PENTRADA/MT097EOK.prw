#Include "Rwmake.ch" 

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �MT097EOK  � Autor �  Renato Carlos        � Data � Jun/2010  ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de entrada para bloquear as funcionalidades do bot�o  ���
���          � estornar na libera��o de pedidos. - OS 1457/10              ���
��������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                      ���
��������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                    ���
��������������������������������������������������������������������������Ĵ��
���              �        �      �                                         ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/


User Function MT097EOK()

Local l_Ret := .F.

MsgAlert("N�o � permitido estornar pedido.Esta op��o encontra-se desabilitada!","Aten��o")

Return(l_Ret)
