#include "rwmake.ch"
#include "protheus.ch"
#include "TOPCONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT150FIL  ºAutor  ³Lígia Sarnauskas    º Data ³  25/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada executado para aplicar filtro nas         º±±
±±º          ³ Cotações carregadas no browse.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user Function MT150FIL()

Local cFiltraSC8
Local cCRLF			:= CRLF

_cCodUser	:=__CUSERID

// Verifica se o usuário faz parte de algum grupo de compras
If Select("TMP") > 0     // Verificando se o alias esta em uso
	dbSelectArea("TMP")
	dbCloseArea()
EndIf

cQuery := "SELECT SAJ.AJ_GRCOM GRCOM "
cQuery := cQuery + " FROM "
cQuery := cQuery + RetSQLname("SAJ")+" SAJ    "
cQuery := cQuery + " WHERE "
cQuery := cQuery + " SAJ.D_E_L_E_T_ = ' ' "
cQuery := cQuery + " AND SAJ.AJ_USER = '"+_cCodUser+"'
TCQuery cQuery NEW ALIAS "TMP"

dbSelectArea("TMP")
dbGotop()

If !EOF()
 _cGrupCom:=TMP->GRCOM
Else
_cGrupCom:=""
Endif

cFiltraSC8	:= " C8_GRUPCOM = '"+_cGrupCom+"' " 

return (cFiltraSC8)