#Include "Rwmake.ch"

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    � MT235G2  � Autor �  Antonio Cordeiro     � Data � NOV/2009  ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de entrada grava a data da elimina�ao por residuo     ���
��������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                      ���
��������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                    ���
��������������������������������������������������������������������������Ĵ��
���              �        �      �                                         ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/

User Function MT235G2()
_aArea:=GetArea()
DBSELECTAREA('SC7')
RECLOCK('SC7',.F.)
SC7->C7_X_DTELI:=DDATABASE
MSUNLOCK('SC7') 
RestArea(_aArea)
Return()