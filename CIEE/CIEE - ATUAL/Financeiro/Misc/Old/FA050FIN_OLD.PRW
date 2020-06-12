#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FA050FIN º Autor ³ Andy               º Data ³  11/04/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada executado na rotina Inclusao Títulos de   º±±
±±º          ³ Contas a Pagar FINA050, que verifica se o titulo sera      º±±
±±º          ³ gravado somente se houver registros em SEV p/ E2_MUTNATU==1º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA050FIN  ºAutor  ³Nelson Breanza      º Data ³  06/09/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera a tabela SV3, a partir da inclusao do contas a pagar  º±±
±±º          ³ com rateio, iguala a natureza com o plano de contas.       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PROTHEUS 8.11 - Exclusivo CIEE                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FA050FIN()

LOCAL _aStru := {}
Local _cAlias := GetArea()

/*
If M->E2_MULTNAT == "1"
	SEV->(dbSetOrder(1))
	If !SEV->(dbSeek(xFilial("SEV")+M->E2_PREFIXO+M->E2_NUM+M->E2_PARCELA+M->E2_TIPO+M->E2_FORNECE+M->E2_LOJA, .F.))
		Reclock("SE2",.F.)
		dbDelete()
	EndIf
EndIf
*/
/*
If SE2->E2_PREFIXO == "FFC" //.OR. SE2->E2_PREFIXO $ "FFQ"
	Reclock("SE2",.F.)
	SE2->E2_NATUREZ := "9.99.99"
	SE2->(MsUnlock())
	Return
Endif
*/

/*
dbSelectArea("CV4")
CV4->(dbsetorder(1))
CV4->(DbGotop())

MSGINFO("ANTES CV4!!!")

IF CV4->(Dbseek(SE2->E2_ARQRAT)) // Monta arquivo de trabalho
*/

If SE2->E2_RATEIO == "N"
	Return
Endif

dbSelectArea("CV4")
dbSetOrder(1)
If CV4->(MsSeek(Alltrim(SE2->E2_ARQRAT)))
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
	
	/*alteracao Emerson*/
	DbSelectArea("TMP1")
	TMP1->(DbGotop())

	DbSelectArea("CV4")
	CV4->(DbSetOrder(1))
	
	While ALLTRIM(CV4->CV4_FILIAL+DTOS(CV4_DTSEQ)+CV4_SEQUEN) == ALLTRIM(SE2->E2_ARQRAT)

		/*alteracao Emerson*/
		RecLock("CV4",.F.)
		CV4->CV4_ENCARG := TMP1->CTJ_ENCARG
		MsUnLock()

		DBSELECTAREA("CT1")
		CT1->(DBSETORDER(2))
		CT1->(DBGOTOP())
		IF CT1->(DBSEEK(xFILIAL("CT1")+ALLTRIM(CV4->CV4_ITEMD)))
			DBSELECTAREA("TRT")
			TRT->(DBSETORDER(1))
			TRT->(DBGOTOP())
			IF TRT->(DBSEEK(xFILIAL("SE2")+ALLTRIM(CT1->CT1_NATURE)))
				RECLOCK("TRT",.F.)
			ELSE
				RECLOCK("TRT",.T.)
			ENDIF
			TRT->xFILIAL   := SE2->E2_FILIAL
			TRT->xPREFIXO  := SE2->E2_PREFIXO
			TRT->xTITULO   := SE2->E2_NUM
			TRT->xPARCELA  := SE2->E2_PARCELA
			TRT->xFORNEC   := SE2->E2_FORNECE
			TRT->xLOJA     := SE2->E2_LOJA
			TRT->xTIPO     := SE2->E2_TIPO
			TRT->xVALOR    := TRT->xVALOR+(CV4->CV4_VALOR-TMP1->CTJ_ENCARG)
			TRT->xNATUREZ  := ALLTRIM(CT1->CT1_NATURE)
			TRT->xRECPAG   := "P"
			TRT->xPERRAT   := TRT->XPERRAT+(TRT->xVALOR/SE2->E2_VALOR)
			TRT->xRATCC    := "2"
			TRT->xIDENT    := "1"
        	MSUNLOCK()
		ENDIF
		CV4->(DBSKIP())
		TMP1->(DBSKIP())
	END
	
	DbSelectArea("TRT")
	
	TRT->(DBGOTOP())
	

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
	    TRT->(DBSKIP())
	END 
	Reclock("SE2",.F.)
//	SE2->E2_MULTNAT := "1" 
	SE2->E2_MULNATU := "1" 	
	SE2->(MsUnlock())
ENDIF

If Select("TRT") > 0
	TRT->(DbCloseArea())
EndIf

RestArea(_cAlias)

RETURN
