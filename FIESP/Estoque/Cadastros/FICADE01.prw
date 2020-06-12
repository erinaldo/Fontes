#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FICADE01  ºAutor  ³Ligia Sarnauskas    º Data ³  08/11/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao chamada pelos gatilhos B1_XIDPROD/001 B1_GRUPO/003  º±±
±±º          ³ Rotina para definir o codigo de produto no momento do      º±±
±±º          ³ cadastro                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FICADE01

_cID:=M->B1_XIDPROD
_cGrupo:=M->B1_GRUPO
_cCod:=space(15)
_cSeq:=space(04)
_nSeq:=0
If !EMPTY(_cID) .AND. EMPTY(_cGrupo)
	_cCod:=_cID
ElseIf EMPTY(_cID) .AND. !EMPTY(_cGrupo)
	_cCod:=_cGrupo
ElseIf !EMPTY(_cID) .AND. !EMPTY(_cGrupo)
	If Select("TMP1") > 0     // Verificando se o alias esta em uso
		dbSelectArea("TMP1")
		dbCloseArea()
	EndIf
	
	cQuery := " SELECT MAX(B1_COD) CODMAX                                  "
	cQuery += "	FROM " + RetSqlName("SB1") + " SB1                         " + CRLF
	cQuery += "	WHERE SB1.D_E_L_E_T_ = '  '                                "
	cQuery += "     AND (SB1.B1_FILIAL   = '"+xFilial("SB1")+"')           "
	cQuery += "     AND (SB1.B1_XIDPROD  = '"+_cID+"')                     "
	cQuery += "     AND (SB1.B1_GRUPO    = '"+_cGrupo+"')                  "
	TCQUERY cQuery NEW ALIAS "TMP1"
	
	Dbselectarea("TMP1")
	Dbgotop()
	
	If !EOF()
		_cSeq:=SUBSTR(TMP1->CODMAX,6,4)
		_nSeq:=VAL(_cSeq)+1
		_cSeq:=STRZERO(_nSeq,4)
	Else
		_cSeq:="0001"
	Endif
Endif

_cCod:=_cID+""+_cGrupo+""+_cSeq

Return(_cCod)
