#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA050GRV  ºAutor  ³Nelson Breanza      º Data ³  06/09/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera a tabela SV3, a partir da inclusao do contas a pagar  º±±
±±º          ³ com rateio, iguala a natureza com o plano de contas.       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PROTHEUS 8.11 - Exclusivo CIEE                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function FA050GRV()

LOCAL _aStru := {}
Local _cAlias := GetArea()

If SE2->E2_PREFIXO <> "FFC" // .OR. SE2->E2_PREFIXO <> "FFQ"
	Return
Endif

MSGINFO("PASSOU PELO SE2!!!")

/*
dbSelectArea("CV4")
CV4->(dbsetorder(1))
CV4->(DbGotop())

MSGINFO("ANTES CV4!!!")

IF CV4->(Dbseek(SE2->E2_ARQRAT)) // Monta arquivo de trabalho
*/

dbSelectArea("CV4")
dbSetOrder(1)
If MsSeek(Alltrim(SE2->E2_ARQRAT))
	
	MSGINFO("DENTRO DO IF CV4!!!")
	
	AADD(_aStru,{"xFILIAL",  "C",  2,0})
	AADD(_aStru,{"xPREFIXO", "C",  3,0})
	AADD(_aStru,{"xTITULO",  "C",  6,0})
	AADD(_aStru,{"xPARCELA", "C",  1,0})
	AADD(_aStru,{"xFORNEC",  "C",  6,0})
	AADD(_aStru,{"xLOJA",    "C",  3,0})
	AADD(_aStru,{"xTIPO",    "C",  3,0})
	AADD(_aStru,{"xVALOR",   "N", 17,2})
	AADD(_aStru,{"xNATUREZ", "C", 10,0})
	AADD(_aStru,{"xRECPAG",  "C",  1,0})
	AADD(_aStru,{"xPERRAT",  "N",  11,7})
	AADD(_aStru,{"xRATCC",   "C",  1,0})
	AADD(_aStru,{"xIDENT",   "C",  1,0})
	dArqTrb := CriaTrab(_aStru,.T.)
	dbUseArea(.T.,,dArqTrb,"TRT",.T.)
	IndRegua("TRT",dArqTrb,"xFILIAL+xNATUREZ",,,"Criando Arquivo...")
	
	MSGINFO("ANTES WHILE CV4!!!")
	
	DbSelectArea("CV4")
	CV4->(DbSetOrder(1))
	
	MSGINFO("TABELA CV4")
	
	While ALLTRIM(CV4->CV4_FILIAL+DTOS(CV4_DTSEQ)+CV4_SEQUEN) == ALLTRIM(SE2->E2_ARQRAT)
	MSGINFO("PASSOU PELO WHILE CV4")
		DBSELECTAREA("SED")
		SED->(DBSETORDER(2))
		SED->(DBGOTOP())
		IF SED->(DBSEEK(xFILIAL("SED")+ALLTRIM(CV4->CV4_ITEMD)))
			MSGINFO("DBSEEK SED!!!")
			DBSELECTAREA("TRT")
			TRT->(DBSETORDER(1))
			IF TRT->(DBSEEK(xFILIAL("TRT")+ALLTRIM(SED->ED_CODIGO)))
				RECLOCK("TRT",.F.)
			ELSE
				RECLOCK("TRT",.T.)
			ENDIF
			TRT->xFILIAL   := SE2->E2_FILIAL
			TRT->xPREFIXO  := SE2->E2_PREFIXO
			TRT->xTITULO   := SE2->E2_NUMERO
			TRT->xPARCELA  := SE2->E2_PARCELA
			TRT->xFORNEC   := SE2->E2_FORNECE
			TRT->xLOJA     := SE2->E2_LOJA
			TRT->xTIPO     := SE2->E2_TIPO
			TRT->xVALOR    := TRT->xVALOR+CV4->CV4_VALOR
			TRT->xNATUREZ  := ALLTRIM(SED->ED_CODIGO)
			TRT->xRECPAG   := "P"
			TRT->xPERRAT   := TRT->XPERRAT+(TRT->xVALOR/SE2->E2_TOTAL)
			TRT->xRATCC    := "2"
			TRT->xIDENT    := "1"
        	MSGINFO("GRAVANDO TRT!!!")			
			MSUNLOCK()
		ENDIF
		CV4->(DBSKIP())
	END
	
	DbSelectArea("TRT")
	
	TRT->(DBGOTOP())
	
	MSGINFO("ANTES WHILE TRT!!!")
	
	WHILE !TRT->(EOF())
		dbselectarea("SEV")
		DBSETORDER(1)
		RECLOCK("SEV",.T.)
		SEV->EV_FILIAL  := TRT->xFILIAL
		SEV->EV_PREFIXO := TRT->xPREFIXO
		SEV->EV_NUM     := TRT->xTITULO
		SEV->EV_PARCELA := TRT->xPARCELA
		SEV->EV_CLIFOR  := TRT->xFORNEC
		SEV->EV_LOJA    := TRT->xLOJA
		SEV->EV_TIPO    := TRT->xTIPO
		SEV->EV_VALOR   := TRT->xVALOR
		SEV->EV_NATUREZ := TRT->xNATUREZ
		SEV->EV_RECPAG  := TRT->xRECPAG
		SEV->EV_PERC    := TRT->xPERRAT
		SEV->EV_RATEICC := TRT->xRATCC
		SEV->EV_IDENT   := TRT->xIDENT
		SEV->(MSUNLOCK())
		
		MSGINFO("PASSOU PELO SEV!!!")
		
	END
	
ENDIF

If Select("TRT") > 0
	TRT->(DbCloseArea())
EndIf

RestArea(_cAlias)

RETURN
