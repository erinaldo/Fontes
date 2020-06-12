#include "rwmake.ch"
#include "protheus.ch"
#include "TOPCONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FICOMA03  ºAutor  ³Lígia Sarnauskas    º Data ³  13/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa utilizado na Consulta Padrao FILSB1 (especifico)  º±±
±±º          ³ utilizado para filtrar os produtos que o usuário pode      º±±
±±º          ³ solicitar comprar, incluir pedidos, requisitar armazem     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FICOMA03()

Local aArea	     := GetArea()
Local _nCont     := 1
Local cCRLF		 := CRLF
_cCodUser	     :=__CUSERID
_cGrupCom        :=""
// Verifica se o usuário faz parte de algum grupo de compras
If Select("TMP") > 0     // Verificando se o alias esta em uso
	dbSelectArea("TMP")
	dbCloseArea()
EndIf

cQuery := "SELECT SAI.AI_GRUPO GRUPO "
cQuery := cQuery + " FROM "
cQuery := cQuery + RetSQLname("SAI")+" SAI    "
cQuery := cQuery + " WHERE "
cQuery := cQuery + " SAI.D_E_L_E_T_ = ' ' "
cQuery := cQuery + " AND SAI.AI_USER = '"+_cCodUser+"'
TCQuery cQuery NEW ALIAS "TMP"

dbSelectArea("TMP")
dbGotop()

If !EOF()
	While !EOF()
		If TMP->GRUPO == "*"
			_cGrupCom:=""
		Else
			If _nCont > 1
				_cGrupCom += "|"
			EndIf
			_cGrupCom+=ALLTRIM(TMP->GRUPO)
			_nCont++
		Endif
		dbSelectArea("TMP")
		Dbskip()
	Enddo
Else
	_cGrupCom:=""
Endif

If !EMPTY(_cGrupCom)
	_cFiltro := '(B1_GRUPO$"'+_cGrupCom+'"'
	_cFiltro += ' .AND. B1_MSBLQL <> "1" )'
Else
	_cFiltro := 'B1_MSBLQL <> "1" '
EndIf

RestArea(aArea)

Return(_cFiltro)