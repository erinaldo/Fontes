#Include 'Protheus.ch'
#include "topconn.ch" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FA050GRV ³ Autor ³ Felipe Santos        ³ Data ³ 12/09/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ O ponto de entrada FA050GRV sera utilizado apos a gravacao ±±
±±³ de todos os dados (na inclusão do título) e antes da sua contabilização±±
±±³±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
±±³Sintaxe   ³							            					  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FA050GRV()

Local dDataBloq := SE2->E2_XDTCADI
Local dDataDesb := SE2->E2_XDT1CAD
Local cMotBloqu := SE2->E2_XMOTBLQ
Local lRet 		:= .T.


If dDataBloq > SE2->E2_VENCREA //DATA DE BLOQUEIO NÃO PODE SER MAIOR QUE VENCIMENTO REAL
	MSGINFO('Erro: Data de Bloqueio não poderá ser superior ao vencimento real do título')
	lRet := .F.
	Return
EndIf

If dDataBloq > dDataDesb //DATA DE BLOQUEIO NÃO PODE SER MAIOR QUE O DESBLOQUEIO
	MSGINFO('Erro: Data de Bloqueio não poderá ser superior ao desbloqueio')
	lRet := .F.
	Return
EndIf

If lRet 
	If !Empty(dDataBloq) .and. Empty(dDataDesb)
		If cMotBloqu = "1" //MOTIVO CADIN
			RECLOCK("SE2",.F.)
			SE2->E2_XORDLIB := "BLC"
			SE2->E2_DATALIB := ""
			MSUNLOCK() 
		ElseIf cMotBloqu = "2" //BLOQUEIO SALDO
			RECLOCK("SE2",.F.)
			SE2->E2_XORDLIB := "BLS"
			MSUNLOCK() 	
		EndIf
	Else
		If Empty(SE2->E2_DATALIB) //CASO ESTEJA LIBERADO PARA PAGAMENTO PORÉM MOTIVO DE BLOQ. POR CADIN
			SE2->E2_XORDLIB := "LIS"		
		Else
			SE2->E2_XORDLIB := "LIC"
		EndIf
	Endif 
	
EndIf

Return lRet
