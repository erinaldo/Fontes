#Include "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT105FIM  �Autor  �TOTVS               � Data �  02/10/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada no final da Rotina de Solicitacao ao      ���
���          � Armazem                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � FIESP                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT105FIM()
Local _aArea := GetArea()          

U_FIESTE01() // Rotina de Gravacao e Geracao de Bloqueio - SCR

RestArea(_aArea)
Return()