#include "rwmake.ch"
#include "TOPCONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINA39   ºAutor  ³Emerson Natali      º Data ³  15/07/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gatilho E2_BCOBOR para E2_MODELO                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function CFINA39(_nSeq)

Private _cBanco	:=	ALLTRIM(IIF(M->E2_BANCO==NIL, CriaVar("E2_BANCO"), M->E2_BANCO))
Private _nValor	:= 	IIF(M->E2_VALOR==NIL, CriaVar("E2_VALOR"), M->E2_VALOR)
Private _cLD	:= 	SUBSTR(ALLTRIM(IIF(M->E2_LD==NIL, CriaVar("E2_LD"), M->E2_LD)),1,3)
Private _cBcoBor:=	ALLTRIM(IIF(M->E2_BCOBOR==NIL, CriaVar("E2_BCOBOR"), M->E2_BCOBOR))
Private _cRegra	:= ""

Do Case
	Case _nSeq == "001"
		_cRegra	:=	IIF(_cBanco==_cBcoBor,"01",IIF(EMPTY(_cBanco),"",IIF(_nValor>=5000,iif(_cBcoBor=="341".OR._cBcoBor=="001".OR._cBcoBor=="104","41","08"),"03")))
	Case _nSeq == "002"
		_cRegra	:=	!EMPTY(_cBanco)
	Case _nSeq == "003"
		If _cLD == "237"
			_cRegra	:=	"31" //alterado dia 31/03/10 pelo analista Emerson. Foi passado a inf. que boletos do bradesco o modelo sempre e 31. antes estava com a regra do ELSE
		Else
			_cRegra	:=	IIF(_cLD==_cBcoBor,"30",IIF(EMPTY(_cLD),"","31"))
		EndIf
	Case _nSeq == "004"
		_cRegra	:=	!EMPTY(_cLD)
EndCase

Return(_cRegra)