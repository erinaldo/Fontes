#include "rwmake.ch"
#include "protheus.ch"
#include "TOPCONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FIPCOL01  ºAutor  ³Ligia Sarnauskas    º Data ³  29/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Definição de valor em lancto PCO 000376                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FIPCOL01()

_nValor:=0
_nTotPed:=0
_cFilial:=SCH->CH_FILIAL
_cPedido:=SCH->CH_PEDIDO
_cItempc:=SCH->CH_ITEMPD
_cCusto :=SCH->CH_CC

If substr(ALLTRIM(_cCusto),1,2)<> "19"
Dbselectarea("SC7")
Dbsetorder(1)
If Dbseek(_cFilial+_cPedido+_cItempc)
	_nTotPed:=SC7->C7_TOTAL	
	
	IF(ALLTRIM(SC1->C1_ORIGEM)=='MATA106'.OR.!EMPTY(SC7->C7_XNUMSV))
		_nValor:=0
	Else
		IF(FUNNAME()=="CNTA120")
			_nValor:=0
		Else
			IF(SUBSTR(SCH->CH_CONTA,1,1)<>'4')
			 If (SUBSTR(SCH->CH_CONTA,1,6) == "120299" .OR. SUBSTR(SCH->CH_CONTA,1,6) == "120301" .OR. SUBSTR(SCH->CH_CONTA,1,6) == "120303" .OR. SUBSTR(SCH->CH_CONTA,1,6) == "120399" .OR. SUBSTR(SCH->CH_CONTA,1,6) == "120401")
			 _nValor:=_nTotPed*(SCH->CH_PERC/100)
			 Else
				_nValor:=0
			 Endif
			Else
				_nValor:=_nTotPed*(SCH->CH_PERC/100)
			Endif
		Endif
	Endif
Endif                                
Endif
Return(_nValor)
