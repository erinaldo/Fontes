/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FICTBA06  ºAutor  ³Microsiga           º Data ³  07/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa utilizado na Consulta Padrao FILCTT (especifico)  º±±
±±º          ³ utilizado para filtrar so centros de custos vinculados ao  º±±
±±º          ³ usuario                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±± Revisao: NOV/2013 - Lígia Sarnauskas - Revisado filtro que estava dando ±±
±± erro e alterada a consulta padrão que chama o filtro                    ±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FICTBA06()

Local cAlias:= "SZF"
Local _cItem := ""
Local _nCont := 1
Local _cFiltro :=""

_cFiltro +="@#" 
(cAlias)->(DbSetOrder(1))
If (cAlias)->(DbSeek(xFilial(cAlias)+__CUSERID))
	Do While !EOF() .and. (cAlias)->ZF_USERID == __CUSERID
		If _nCont > 1
			_cItem += "|"
		EndIf
		_cItem += ((cAlias)->ZF_CUSTO)
		_nCont++
		(cAlias)->(DbSkip())
	EndDo       
	_cFiltro +="CTT->(" 
	_cFiltro += 'CTT_CUSTO $ "'+_cItem+'" '
	_cFiltro += ' .AND. CTT_BLOQ <> "1" '
	_cFiltro +=")" 
	_cFiltro +="@#" 
Else
	_cFiltro +="CTT->("
	_cFiltro += 'CTT_BLOQ <> "1" '
	_cFiltro +=")"
	_cFiltro +="@#"   
EndIf

Return(_cFiltro)