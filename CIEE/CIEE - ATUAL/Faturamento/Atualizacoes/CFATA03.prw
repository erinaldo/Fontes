#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*
������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Fun��o    � CFATA03  � Autor � Daniel G.Jr.TI1239       � Data � Abr/2013 ���
����������������������������������������������������������������������������Ĵ��
���Descri��o � Execblock chamado na gera��o da tag de observa��es das NF Ele-���
���          � tronica. A chamada � feita nos registros da tabela de Formula-���
����������������������������������������������������������������������������Ĵ��
���Sintaxe e � CFATA03(void)                                                 ���
����������������������������������������������������������������������������Ĵ��
���Parametros�                                                               ���
����������������������������������������������������������������������������Ĵ��
��� Uso      � CIEE                                                          ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
User Function CFATA03()

Local cRet 		:= ""
Local cQuery 	:= ""
Local aArea		:= GetArea()
Local aAreaSC6	:= SC6->(GetArea())
Local aAreaSF2	:= SF2->(GetArea())
Local lFirst	:= .T.

If IsInCallStack("SPEDNFE")

	cQuery := "SELECT DISTINCT C6_XPATRIM "
	cQuery +=   "FROM "+RetSqlName("SC6")+" SC6 "
	cQuery +=  "WHERE C6_FILIAL = '"+xFilial("SC6")+"' "
	cQuery +=    "AND C6_NOTA = '"+SF2->F2_DOC+"' "
	cQuery +=    "AND C6_SERIE = '"+SF2->F2_SERIE+"' "
	cQuery +=    "AND C6_CLI = '"+SF2->F2_CLIENTE+"' "
	cQuery +=    "AND C6_LOJA = '"+SF2->F2_LOJA+"' "
	cQuery +=    "AND C6_XPATRIM <> '' "
	cQuery := ChangeQuery(cQuery)
	
	If Select("C6NF")>0
		C6NF->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'C6NF',.T.,.T.)

	DbSelectarea("C6NF")
	C6NF->(dbGoTop())

	If C6NF->(!Eof().And.!Bof())
		cRet := " - Cod.Patrim.:"
		While C6NF->(!Eof())
			cRet += Iif(!lFirst,",","")+AllTrim(C6NF->C6_XPATRIM) 
			lFirst := .F.
			C6NF->(dbSkip())
		End
	EndIf
	C6NF->(dbCloseArea())   
	
EndIf
	
RestArea(aAreaSF2)
RestArea(aAreaSC6)
RestArea(aArea)

Return(cRet)