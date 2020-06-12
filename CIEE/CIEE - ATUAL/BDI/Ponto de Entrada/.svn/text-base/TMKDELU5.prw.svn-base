#include "rwmake.ch"
#include "TOPCONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TMKDELU5  ºAutor  ³Emerson Natali      º Data ³  06/06/2007 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada para verificar no momento da Exclusao do   º±±
±±º          ³contato se o mesmo ja possue movimento                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³CIEE                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TMKDELU5(cAlias,nReg)

_lRet := .T.

DbSelectArea("AC8")
DbSetOrder(1)
DBSEEK(XFILIAL("AC8")+SU5->U5_CODCONT)
If Found()
	_lRet := .F.
	help('',1,'X','','Contato possue amarracao!',3,0)
	Return(_lRet)
EndIf

DbSelectArea("SZQ")
DbSetOrder(2)
DBSEEK(XFILIAL("SZQ")+SU5->U5_CODCONT)
If Found()
	_lRet := .F.
	help('',1,'X','','Contato possue amarracao!',3,0)
	Return(_lRet)
EndIf

cQuery  := "SELECT COUNT(*) AS RECSU5"
cQuery  += " FROM "+RetSQLname('SZZ')+" SZZ "
cQuery  += " WHERE SZZ.D_E_L_E_T_ <> '*' "
cQuery  += " AND ZZ_CODCONT = '"+SU5->U5_CODCONT+'"
cQuery  += "ORDER BY ZZ_CODCONT,ZZ_CODEVEN"
TcQuery cQuery New Alias "TMP"
TcSetField("TMP","ZZ_DTEVENT","D",8, 0 )

If RECSU5 > 0
	_lRet := .F.
	help('',1,'X','','Contato possue amarracao!',3,0)
	Return(_lRet)
EndIf

Return(_lRet)