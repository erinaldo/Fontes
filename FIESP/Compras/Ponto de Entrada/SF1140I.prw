
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SF1140I   ºAutor  ³TOTVS               º Data ³  09/13/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada que Efetua Bloqueio da Pre-Nota enviando  º±±
±±º          ³ e-mail ao Solicitante que deve desbloquear                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SF1140I
//Gravar o campo F1_XSTATUS como Bloqueado

Local _aArea := GetArea()
Local _cQuery
Local _cQry

_cQuery := "SELECT B1_XTIPGRU "
_cQuery += "FROM "+RetSqlName("SD1")+" SD1, "+RetSqlName("SB1") +" SB1 "
_cQuery += "WHERE SD1.D_E_L_E_T_ = '' AND SB1.D_E_L_E_T_ = '' "
_cQuery += "AND SD1.D1_GRUPO = SB1.B1_GRUPO "
_cQuery += "AND SD1.D1_COD = SB1.B1_COD "
_cQuery += "AND SD1.D1_DOC = '"+SF1->F1_DOC+"' "
_cQuery += "AND SD1.D1_SERIE = '"+SF1->F1_SERIE+"' "
_cQuery += "AND SD1.D1_FORNECE = '"+SF1->F1_FORNECE+"' "
_cQuery += "AND SD1.D1_LOJA = '"+SF1->F1_LOJA+"' "
_cQuery += "AND SB1.B1_XTIPGRU = '1' "
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TRBSD1",.t.,.t.)

DbSelectArea("TRBSD1")
DbGotop()
If ALLTRIM(TRBSD1->B1_XTIPGRU) == "1" //Tipo 1 igual a SERVICO (1-SIM; 2-NAO)

	_cQry := "SELECT SD1.D1_PEDIDO, SC7.C7_NUMSC, SC1.C1_USER "
	_cQry += "FROM "+RetSqlName("SD1")+" SD1, "+RetSqlName("SC7")+" SC7, "+RetSqlName("SC1")+" SC1 "
	_cQry += "WHERE SD1.D_E_L_E_T_ = '' AND SC7.D_E_L_E_T_ = '' AND SC1.D_E_L_E_T_ = '' "
	_cQry += "AND SD1.D1_PEDIDO = SC7.C7_NUM "
	_cQry += "AND SC7.C7_NUMSC = SC1.C1_NUM "
	_cQry += "AND SD1.D1_DOC = '"+SF1->F1_DOC+"' "
	_cQry += "AND SD1.D1_SERIE = '"+SF1->F1_SERIE+"' "
	_cQry += "AND SD1.D1_FORNECE = '"+SF1->F1_FORNECE+"' "
	_cQry += "AND SD1.D1_LOJA = '"+SF1->F1_LOJA+"' "
	_cQry += "GROUP BY SD1.D1_PEDIDO, SC7.C7_NUMSC, SC1.C1_USER "
	_cQry := ChangeQuery(_cQry)
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQry),"TRBPRE",.t.,.t.)
	
	DbSelectArea("TRBPRE")
	DbGotop()
	If !Empty(TRBPRE->C1_USER)

		RecLock("SF1",.F.)
		SF1->F1_XSTATUS := "B"
		MsUnLock()

		// envia email ao solicitante
		_cEMail := Alltrim(UsrRetMail( TRBPRE->C1_USER ))
		_cBody  := "Prezado(a) "+UsrRetName(TRBPRE->C1_USER)+ " - " + Chr(13)+Chr(10)+Chr(13)+Chr(10)
		_cBody  += "Informamos que sua Pre-Nota de Entrada Nr. "+SF1->F1_DOC+" - serie. " + SF1->F1_SERIE + " precisa ser aprovada."
		_cBody  += Chr(13)+Chr(10)+Chr(13)+Chr(10)
		_cBody  += "Favor acessar a Rotina de Pre-Nota e efetuar a Liberação do Documento "
		ACSendMail( ,,,,_cEMail,"Pre-Nota "+SF1->F1_DOC+" NECESSARIO APROVACAO",_cBody)
	EndIf
	DbSelectArea("TRBPRE")
	TRBPRE->(DbCloseArea())

EndIf

DbSelectArea("TRBSD1")
TRBSD1->(DbCloseArea())

RestArea(_aArea)

Return