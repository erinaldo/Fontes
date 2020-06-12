#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO6     º Autor ³ AP6 IDE            º Data ³  23/02/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function F090TOK()


_aAreaSEA := SEA->(GetArea())
_aAreaSE2 := SE2->(GetArea())
_lRet:=.T.
_nReg  := SE2->(RECNO())



/*
dbSelectArea("SEA")
dbSetOrder(1)
If dbSeek(xFilial("SEA") + cBordero)
	dbSelectArea("SE2")
	dbSetOrder(1)
	If dbSeek( xFilial("SE2")+SEA->EA_PREFIXO+SEA->EA_NUM+SEA->EA_PARCELA+SEA->EA_TIPO+SEA->EA_FORNECE+SEA->EA_LOJA)
		While !Eof() .And. ;
			SEA->EA_PREFIXO == SE2->E2_PREFIXO .and. ;
			SEA->EA_NUM    	== SE2->E2_NUM 	   .and. ;
			SEA->EA_PARCELA	== SE2->E2_PARCELA .and. ;
			SEA->EA_TIPO	== SE2->E2_TIPO	   .and. ;
			SEA->EA_FORNECE	== SE2->E2_FORNECE .and. ;
			SEA->EA_LOJA    == SE2->E2_LOJA
			If 	SEA->EA_PREFIXO == SE2->E2_PREFIXO .and. ;
				SEA->EA_NUM    	== SE2->E2_NUM 	   .and. ;
				SEA->EA_PARCELA	== SE2->E2_PARCELA .and. ;
				SEA->EA_TIPO	== SE2->E2_TIPO	   .and. ;
				SEA->EA_FORNECE	== SE2->E2_FORNECE .and. ;
				SEA->EA_LOJA    == SE2->E2_LOJA
				If SE2->E2_VENCREA<>dDataBase
					_lRet    :=.F.
					_cMsg    := "Data Base Diferente com as datas de Vencimento dos Títulos"
					MsgAlert(_cMsg, "Atenção")
					Exit
				EndIf
			EndIf
			
			dbSelectArea("SE2")
			dbSkip( )
			
		EndDo
	Else
		_lRet    :=.F.
		_cMsg    := "Erro nos Títulos, entre na rotina  e tente novamente"
		MsgAlert(_cMsg, "Atenção")
	EndIf
EndIf

SE2->(DBGOTO(_nReg))
SEA->(RestArea(_aAreaSEA))
SE2->(RestArea(_aAreaSE2))

*/

Return(_lRet)
