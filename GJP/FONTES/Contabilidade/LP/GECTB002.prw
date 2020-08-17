#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GECTB002  ºAutor  ³TOTVS               º Data ³  05/06/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funçao executada nos LP 610 e 620                          º±±
±±º          ³ Tratamento para contabilização com Formas de pagamento     º±±
±±º          ³ diferentes                                                 º±±
±±º          ³ G   - GJP                                                  º±±
±±º          ³ E   - Execblock                                            º±±
±±º          ³ CTB - CONTABILIDADE                                        º±±
±±º          ³ 999 - Sequencia                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GJP                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GECTB002()

Local _cConta := "210203001"
Local _xArea := GetArea()
Local _nChave := SA1->(Recno())
Local _nIdSA1 := SA1->(IndexOrd())

IF ALLTRIM(SE1->E1_ORIGEM) == "FINI040"
	IF SUBSTR(Upper(ALLTRIM(SE1->E1_HIST)),3,6) = "ADIANT"
		DbSelectArea("XXF")
		DbSetOrder(1) //XXF_REFER + XXF_TABLE + XXF_ALIAS + XXF_FIELD + XXF_EXTVAL
		If DbSeek("BEMATECH       SA1010SA1A1_COD    "+SUBSTR(SE1->E1_HIST,10,20)) //E-Adiant#61|61|756614
			_cCliente:= SUBSTR(XXF->XXF_INTVAL,5,6)
			
			DbSelectArea("SA1")
			DbSetOrder(1)
			If DbSeek(xFilial("SA1")+_cCliente)
				IF SUBSTR(SE1->E1_HIST,1,1)=="E" //Evento
					_cConta := SA1->A1_XCNTAEV
				Else
					_cConta := SA1->A1_XCNTADT
				EndIf
			EndIf

		EndIf 
		
	Else
		_cConta := "110201004"
	EndIf

EndIf

RestArea(_xArea)

SA1->(DbGoto(_nChave))
SA1->(DbSetOrder(_nIdSA1))

Return(_cConta)