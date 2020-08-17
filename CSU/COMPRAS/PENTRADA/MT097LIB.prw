#Include "Rwmake.ch" 

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    � MT097LIB � Autor �  Renato Carlos        � Data � Dez/2009  ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de entrada ap�s clique no bot�o liberar da rotina de  ���
���          � Libera��o de pedidos. Trazer Base Line se for um comprador  ���
��������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                      ���
��������������������������������������������������������������������������Ĵ��
���              �        �      �                                         ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/

User Function MT097LIB()
   
Local a_AreaAnt := GetArea()
Local c_Eol     := Chr(13)+Chr(10)
Local c_Query   := ""
Local c_Id      := __cUserId
Local l_Found   := .F.
Local c_NotVal  := "001505" // N�o acessa o base line se for o superintendente de Procurement.
Local aAreaSAK  := SAK->( GetArea() )

// Usando grupo de compradores para filtro, pois restringe somente pessoas de Procurement.

c_Query := " SELECT DISTINCT(AJ_USER)FROM "+RetSqlName('SAJ')+" "+c_Eol
c_Query += " WHERE D_E_L_E_T_ = ''" +c_Eol

U_MontaView(c_Query, "TMPSAJ")
                                
TMPSAJ->(DbGotop())

While !TMPSAJ->(Eof())
	If TMPSAJ->AJ_USER <> c_Id .Or. TMPSAJ->AJ_USER == c_NotVal
   		TMPSAJ->(DbSkip())
   	Else		 
		l_Found   := .T.
		Exit
	EndIf	
EndDo

TMPSAJ->(DbCloseArea())

If SAK->AK_COD <> SCR->CR_APROV
   SAK->( SAK->( DbSetOrder(1) ), DbSeek( xFilial('SAK')+SCR->CR_APROV ) )
Else   
   SAK->(RestArea( aAreaSAK ))
EndIf

RestArea(a_AreaAnt)

If l_Found
	U_BaseLine()
EndIf

Return		