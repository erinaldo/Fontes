#include "rwmake.ch"
#include "protheus.ch"
#include "TOPCONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT105FIL  ºAutor  ³Lígia Sarnauskas    º Data ³  02/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada executado para aplicar filtro nas         º±±
±±º          ³ requisições ao armazem.                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT105FIL()

Local cFiltro := ''
Local _cAprov := "" 
_nCont:=1

_cCodUser	:=__CUSERID

// Verifica se o usuário faz parte de algum grupo de aprovação se fizer lista todas as requisições em que ele seja o aprovador
If Select("TMP1") > 0     // Verificando se o alias esta em uso
	dbSelectArea("TMP1")
	dbCloseArea()
EndIf
          
cQuery := "SELECT SAL.AL_COD GRUPAPROV "
cQuery := cQuery + " FROM "
cQuery := cQuery + RetSQLname("SAL")+" SAL    "
cQuery := cQuery + " WHERE "
cQuery := cQuery + " SAL.AL_USER    = '"+_cCodUser+"' "
cQuery := cQuery + " AND SAL.D_E_L_E_T_ = ' ' "
TCQuery cQuery NEW ALIAS "TMP1"

dbSelectArea("TMP1")
dbGotop()

While !EOF()
	If _nCont > 1
		_cAprov += "|"
	EndIf
	_cAprov += (TMP1->GRUPAPROV)
	_nCont++
	dbSelectArea("TMP1")
	DbSkip()
Enddo

// Para carregar as requisições na tela em que o usuário seja o requisitante ou ele seja o aprovador
cFiltro :=  '  CP_XUSER  == "'+_cCodUser+'"  '
cFiltro += '   .OR. CP_XAPROV $ "'+_cAprov+'" '


Return (cFiltro)
