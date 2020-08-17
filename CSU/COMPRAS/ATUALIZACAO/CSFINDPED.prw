#Include "Rwmake.ch" 

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �CSFINDPED � Autor �  Renato Carlos        � Data � Mai/2010  ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Programa para encontrar o Ped de Compras quando chamado pelo���
���          � botao de Conhecimento na rotina de libera��o de pedidos.    ���
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

User Function CSFINDPED()

Local a_AreaAnt := GetArea()
Local c_PedScr := Alltrim(SCR->CR_NUM)
Local c_Query  := ""
Local n_SC7Rec := 0

c_Query := " SELECT TOP 1 * "
c_Query += " FROM "+RetSqlName("SCR")               "
c_Query += " WHERE CR_NUM  = '"+c_PedScr+"'          "
c_Query += " AND CR_TIPO  != 'SC'          "
c_Query += " AND D_E_L_E_T_  = ''          "

U_MontaView( c_Query, "TMP" )

dbSelectArea("TMP")
TMP->( DbGoTop() )

DbSelectArea("SC7")
DbSetOrder(1)

If DbSeek(xFilial("SC7")+Alltrim(TMP->CR_NUM))
	n_SC7Rec := SC7->(Recno())
EndIf

RestArea(a_AreaAnt)
	
Return(n_SC7Rec) 

