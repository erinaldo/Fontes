#include "rwmake.ch"
#include "Topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCWKF002   บ Autor ณ Emerson Natali     บ Data ณ  14/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao para noticacao de Documentos via Work-Flow          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบ Autor    ณ Altera็ใo                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบDaniel G.Jณ Nova regra: se pertence aos grupos A,C ou G e unidade for  บฑฑ
ฑฑบ08/10/2013ณ do estado de SP,entใo acrescenta endere็o de email do campoบฑฑ
ฑฑบ          ณ ZU_CC2, cujo conte๚do deve ser telecom@ciee.org.br, confor-บฑฑ
ฑฑบ          ณ me SSI.13/0218                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CWKF002()
Local _cQuery	 := ""
Local _cEmail	 := ""
Local _cTitulo   := ""
Local _cTexto    := ""
Local _cAssunto  := ""
Local _cEst		 := ""				// Alterado em 08/10/2013 - SSI. 13/0218
Local oHtml

Private oProcess
Private oHtml

wfPrepENV( "01", "01")

ChkFile("SZ5")

_xFilSZ5:=xFilial("SZ5")
_xFilSZ7:=xFilial("SZ7")
_xFilCTT:=xFilial("CTT")			// Alterado em 08/10/2013 - SSI. 13/0218

//NIVEL1
//Responsavel
_cQuery	:= "SELECT Z5_UNIDADE "
_cQuery	+= " FROM "
_cQuery += RetSqlName("SZ5")+" SZ5,"
_cQuery += RetSqlName("SZ7")+" SZ7,"
_cQuery += RetSqlName("SA6")+" SA6"
_cQuery += " WHERE '"+ _xFilSZ5 +"' = Z5_FILIAL"
_cQuery += " AND   '"+ _xFilSZ7 +"' = Z7_FILIAL"
_cQuery += " AND    SZ5.D_E_L_E_T_ <> '*'"
_cQuery += " AND    SZ7.D_E_L_E_T_ <> '*'"
_cQuery += " AND    SA6.D_E_L_E_T_ <> '*'"
_cQuery += " AND    Z5_PRESTA   = Z7_PRESTA"
_cQuery += " AND    Z5_BANCO   = A6_COD"
_cQuery += " AND    Z5_CCONTA   = A6_NUMCON"
_cQuery	+= " AND Z5_BAIXA = '' "
_cQuery	+= " AND Z5_CONTA = 'S' "
_cQuery += " AND Z5_NIVEL = ''"
_cQuery += " GROUP BY Z5_UNIDADE"
TCQUERY _cQuery ALIAS "TMPUNI" NEW

DbSelectArea("TMPUNI")
DbGotop()
Do While !EOF()

	_lNivel2	:= .F.
	
	DbSelectArea("SZU")
	DbSetOrder(2) //UNIDADE
	If DbSeek(xFilial("SZU")+TMPUNI->Z5_UNIDADE,.F.)
		_nDias	:= SZU->ZU_PERIOD1
		_cEmail := SZU->ZU_EMAIL1
//		_cCC	:= SZU->ZU_CC1 + ";" + SZU->ZU_CC2			// Alterado em 08/10/2013 - SSI. 13/0218
		_cCC	:= SZU->ZU_CC1 + ";" 						// Alterado em 08/10/2013 - SSI. 13/0218
		_cEst	:= Posicione("CTT",1,_xFilCTT+SZU->ZU_CR,"CTT_EST")				// Alterado em 08/10/2013 - SSI. 13/0218
		If Empty (_cEmail)
			_nDias		:= SZU->ZU_PERIOD2
			_cEmail 	:= SZU->ZU_EMAIL2 
			_lNivel2	:= .T.
		EndIf
	EndIf

	_dData := DataValida(dDatabase-_nDias,.F.) //O parametro .F. e para considerar a data util anterior (se cai no final de semana considera a sexta)
	
	_cQuery	:= "SELECT * "
	_cQuery	+= " FROM "
	_cQuery += RetSqlName("SZ5")+" SZ5,"
	_cQuery += RetSqlName("SZ7")+" SZ7,"
	_cQuery += RetSqlName("SA6")+" SA6"
	_cQuery += " WHERE '"+ _xFilSZ5 +"' = Z5_FILIAL"
	_cQuery += " AND   '"+ _xFilSZ7 +"' = Z7_FILIAL"
	_cQuery += " AND    SZ5.D_E_L_E_T_ <> '*'"
	_cQuery += " AND    SZ7.D_E_L_E_T_ <> '*'"
	_cQuery += " AND    SA6.D_E_L_E_T_ <> '*'"
	_cQuery += " AND    Z5_PRESTA   = Z7_PRESTA"
	_cQuery += " AND    Z5_BANCO   = A6_COD"
	_cQuery += " AND    Z5_CCONTA   = A6_NUMCON"
	_cQuery	+= " AND Z5_BAIXA = '' "
	_cQuery	+= " AND Z5_LANC = '"+dtos(_dData)+"' "
	_cQuery	+= " AND Z5_CONTA = 'S' "
	_cQuery += " AND Z5_NIVEL = ''"
	_cQuery += " AND Z5_UNIDADE = '"+TMPUNI->Z5_UNIDADE+"' "
	_cQuery += " ORDER BY Z5_LANC, Z7_DESCGR, Z5_PRESTA, Z5_VALOR "
	TCQUERY _cQuery ALIAS "TMP" NEW

	DbSelectArea("TMP")
	DbGotop()
	If EOF()
		DbSelectArea("TMP")
		DbCloseArea()
		DbSelectArea("TMPUNI")
		TMPUNI->(DbSkip())
		Loop
	EndIf

	_cValUnid	:= alltrim(GetMV("CI_CRRESP")) //Unidades com responsabilidade de Sao Paulo para conta de Telefone.
	
	If TMP->Z7_GRUPO $ "A|C" .and. (TMP->Z5_CR $ _cValUnid .or. Empty(TMP->Z5_CR))
		_cEmail := alltrim(GetMV("CI_EMAIL1")) //Responsavel pelo Grupo Telefone.
	EndIf
	                                 
	// Alterado em 08/10/2013 - SSI. 13/0218 - INICIO
	If !Empty(SZU->ZU_CC2)
		If TMP->Z7_GRUPO $ "A|C|G" .And. _cEst="SP"
			_cEmail := alltrim(GetMV("CI_EMAIL1")) //Responsavel pelo Grupo Telefone, somente telecom recebe o email. - SSI. 13/0218
			_cCC 	:= SZU->ZU_CC1	//copia para contabilidade - SSI. 13/0218
//		ElseIf _cEst != "SP"
//			_cCC += SZU->ZU_CC2
		EndIf
	EndIf		
	// Alterado em 08/10/2013 - SSI. 13/0218 - FIM

	If !Empty (_cEmail)
		_fEnvia(_cEmail,_cCC) //Chama funcao para disparar o e-mail
	Else
		DbSelectArea("TMP")
		DbCloseArea()
	EndIf

	_cQuery := " UPDATE "
	_cQuery += RetSqlName("SZ5")
	If _lNivel2
		_cQuery += " SET Z5_NIVEL = '2',"
	Else
		_cQuery += " SET Z5_NIVEL = '1',"
	EndIf
	_cQuery += " Z5_DTENVIO = '"+DTOS(dDatabase)+"'"
	_cQuery += " WHERE '"+ _xFilSZ5 +"' = Z5_FILIAL"
	_cQuery += " AND D_E_L_E_T_ <> '*'"
	_cQuery	+= " AND Z5_BAIXA = '' "
	_cQuery	+= " AND Z5_LANC = '"+dtos(_dData)+"' "
	_cQuery	+= " AND Z5_CONTA = 'S' "
	_cQuery += " AND Z5_UNIDADE = '"+TMPUNI->Z5_UNIDADE+"' "
	TcSQLExec(_cQuery)

	DbSelectArea("TMPUNI")
	TMPUNI->(DbSkip())
EndDo

DbSelectArea("TMPUNI")
DbCloseArea()

//NIVEL2
//Supervisor
_cQuery	:= "SELECT Z5_UNIDADE "
_cQuery	+= " FROM "
_cQuery += RetSqlName("SZ5")+" SZ5,"
_cQuery += RetSqlName("SZ7")+" SZ7,"
_cQuery += RetSqlName("SA6")+" SA6"
_cQuery += " WHERE '"+ _xFilSZ5 +"' = Z5_FILIAL"
_cQuery += " AND   '"+ _xFilSZ7 +"' = Z7_FILIAL"
_cQuery += " AND    SZ5.D_E_L_E_T_ <> '*'"
_cQuery += " AND    SZ7.D_E_L_E_T_ <> '*'"
_cQuery += " AND    SA6.D_E_L_E_T_ <> '*'"
_cQuery += " AND    Z5_PRESTA   = Z7_PRESTA"
_cQuery += " AND    Z5_BANCO   = A6_COD"
_cQuery += " AND    Z5_CCONTA   = A6_NUMCON"
_cQuery	+= " AND Z5_BAIXA = '' "
_cQuery	+= " AND Z5_CONTA = 'S' "
_cQuery += " AND Z5_NIVEL = '1'"
_cQuery += " GROUP BY Z5_UNIDADE"
TCQUERY _cQuery ALIAS "TMPUNI" NEW

DbSelectArea("TMPUNI")
DbGotop()
Do While !EOF()

	DbSelectArea("SZU")
	DbSetOrder(2) //UNIDADE
	If DbSeek(xFilial("SZU")+TMPUNI->Z5_UNIDADE,.F.)
		_nDias	:= SZU->ZU_PERIOD2
		_cEmail := SZU->ZU_EMAIL2 + ";" + SZU->ZU_EMAIL1
		//_cCC	:= SZU->ZU_CC1 + ";" + SZU->ZU_CC2	// Alterado em 08/10/2013 - SSI. 13/0218
		_cCC	:= SZU->ZU_CC1 + ";" 				// Alterado em 08/10/2013 - SSI. 13/0218
		_cEst	:= Posicione("CTT",1,_xFilCTT+SZU->ZU_CR,"CTT_EST")				// Alterado em 08/10/2013 - SSI. 13/0218
	EndIf

	_dData := DataValida(dDatabase-_nDias,.F.) //O parametro .F. e para considerar a data util anterior (se cai no final de semana considera a sexta)

	_cQuery	:= "SELECT * "
	_cQuery	+= " FROM "
	_cQuery += RetSqlName("SZ5")+" SZ5,"
	_cQuery += RetSqlName("SZ7")+" SZ7,"
	_cQuery += RetSqlName("SA6")+" SA6"
	_cQuery += " WHERE '"+ _xFilSZ5 +"' = Z5_FILIAL"
	_cQuery += " AND   '"+ _xFilSZ7 +"' = Z7_FILIAL"
	_cQuery += " AND    SZ5.D_E_L_E_T_ <> '*'"
	_cQuery += " AND    SZ7.D_E_L_E_T_ <> '*'"
	_cQuery += " AND    SA6.D_E_L_E_T_ <> '*'"
	_cQuery += " AND    Z5_PRESTA   = Z7_PRESTA"
	_cQuery += " AND    Z5_BANCO   = A6_COD"
	_cQuery += " AND    Z5_CCONTA   = A6_NUMCON"
	_cQuery	+= " AND Z5_BAIXA = '' "
	_cQuery	+= " AND Z5_LANC = '"+dtos(_dData)+"' "
	_cQuery	+= " AND Z5_DTENVIO <> '"+dtos(dDatabase)+"' "
	_cQuery	+= " AND Z5_CONTA = 'S' "
	_cQuery += " AND Z5_NIVEL = '1'"
	_cQuery += " AND Z5_UNIDADE = '"+TMPUNI->Z5_UNIDADE+"' "
	_cQuery += " ORDER BY Z5_LANC, Z7_DESCGR, Z5_PRESTA, Z5_VALOR "
	TCQUERY _cQuery ALIAS "TMP" NEW
		
	DbSelectArea("TMP")
	If EOF()
		DbSelectArea("TMP")
		DbCloseArea()
		DbSelectArea("TMPUNI")
		TMPUNI->(DbSkip())
		Loop
	EndIf
		
	_cValUnid	:= alltrim(GetMV("CI_CRRESP")) //Unidades com responsabilidade de Sao Paulo para conta de Telefone.
	
	If TMP->Z7_GRUPO $ "A|C" .and. (TMP->Z5_CR $ _cValUnid .or. Empty(TMP->Z5_CR))
		_cEmail := alltrim(GetMV("CI_EMAIL2"))+";"+alltrim(GetMV("CI_EMAIL1")) //Responsavel pelo Grupo Telefone.
	EndIf

	// Alterado em 08/10/2013 - SSI. 13/0218 - INICIO
	If !Empty(SZU->ZU_CC2)
		If TMP->Z7_GRUPO $ "A|C|G" .And. _cEst="SP"
			_cEmail := alltrim(GetMV("CI_EMAIL2"))+";"+alltrim(GetMV("CI_EMAIL1")) //Responsavel pelo Grupo Telefone, somente telecom recebe o email. - SSI. 13/0218
			_cCC 	:= SZU->ZU_CC1		//copia para contabilidade - SSI. 13/0218
//		ElseIf _cEst != "SP"
//			_cCC += SZU->ZU_CC2
		EndIf
	EndIf		
	// Alterado em 08/10/2013 - SSI. 13/0218 - FIM

	If !Empty (_cEmail)
		_fEnvia(_cEmail,_cCC) //Chama funcao para disparar o e-mail
	Else
		DbSelectArea("TMP")
		DbCloseArea()
	EndIf

	_cQuery := " UPDATE "
	_cQuery += RetSqlName("SZ5")
	_cQuery += " SET Z5_NIVEL = '2',"
	_cQuery += " Z5_DTENVIO = '"+DTOS(dDatabase)+"'"
	_cQuery += " WHERE '"+ _xFilSZ5 +"' = Z5_FILIAL"
	_cQuery += " AND D_E_L_E_T_ <> '*'"
	_cQuery	+= " AND Z5_BAIXA = '' "
	_cQuery	+= " AND Z5_LANC = '"+dtos(_dData)+"' "
	_cQuery	+= " AND Z5_CONTA = 'S' "
	_cQuery += " AND Z5_UNIDADE = '"+TMPUNI->Z5_UNIDADE+"' "
	TcSQLExec(_cQuery)

	DbSelectArea("TMPUNI")
	TMPUNI->(DbSkip())
EndDo
	
DbSelectArea("TMPUNI")
DbCloseArea()

//NIVEL3
//Gerente
_cQuery	:= "SELECT Z5_UNIDADE "
_cQuery	+= " FROM "
_cQuery += RetSqlName("SZ5")+" SZ5,"
_cQuery += RetSqlName("SZ7")+" SZ7,"
_cQuery += RetSqlName("SA6")+" SA6"
_cQuery += " WHERE '"+ _xFilSZ5 +"' = Z5_FILIAL"
_cQuery += " AND   '"+ _xFilSZ7 +"' = Z7_FILIAL"
_cQuery += " AND    SZ5.D_E_L_E_T_ <> '*'"
_cQuery += " AND    SZ7.D_E_L_E_T_ <> '*'"
_cQuery += " AND    SA6.D_E_L_E_T_ <> '*'"
_cQuery += " AND    Z5_PRESTA   = Z7_PRESTA"
_cQuery += " AND    Z5_BANCO   = A6_COD"
_cQuery += " AND    Z5_CCONTA   = A6_NUMCON"
_cQuery	+= " AND Z5_BAIXA = '' "
_cQuery	+= " AND Z5_CONTA = 'S' "
_cQuery += " AND Z5_NIVEL = '2'"
_cQuery += " GROUP BY Z5_UNIDADE"
TCQUERY _cQuery ALIAS "TMPUNI" NEW

DbSelectArea("TMPUNI")
DbGotop()
Do While !EOF()

	DbSelectArea("SZU")
	DbSetOrder(2) //UNIDADE
	If DbSeek(xFilial("SZU")+TMPUNI->Z5_UNIDADE,.F.)
		_nDias	:= SZU->ZU_PERIOD3
		_cEmail := SZU->ZU_EMAIL3 + ";" + SZU->ZU_EMAIL2 + ";" + SZU->ZU_EMAIL1
		//_cCC	:= SZU->ZU_CC1 + ";" + SZU->ZU_CC2	// Alterado em 08/10/2013 - SSI. 13/0218
		_cCC	:= SZU->ZU_CC1 + ";" 				// Alterado em 08/10/2013 - SSI. 13/0218
		_cEst	:= Posicione("CTT",1,_xFilCTT+SZU->ZU_CR,"CTT_EST")				// Alterado em 08/10/2013 - SSI. 13/0218
	EndIf

	_dData := DataValida(dDatabase-_nDias,.F.) //O parametro .F. e para considerar a data util anterior (se cai no final de semana considera a sexta)

	_cQuery	:= "SELECT * "
	_cQuery	+= " FROM "
	_cQuery += RetSqlName("SZ5")+" SZ5,"
	_cQuery += RetSqlName("SZ7")+" SZ7,"
	_cQuery += RetSqlName("SA6")+" SA6"
	_cQuery += " WHERE '"+ _xFilSZ5 +"' = Z5_FILIAL"
	_cQuery += " AND   '"+ _xFilSZ7 +"' = Z7_FILIAL"
	_cQuery += " AND    SZ5.D_E_L_E_T_ <> '*'"
	_cQuery += " AND    SZ7.D_E_L_E_T_ <> '*'"
	_cQuery += " AND    SA6.D_E_L_E_T_ <> '*'"
	_cQuery += " AND    Z5_PRESTA   = Z7_PRESTA"
	_cQuery += " AND    Z5_BANCO   = A6_COD"
	_cQuery += " AND    Z5_CCONTA   = A6_NUMCON"
	_cQuery	+= " AND Z5_BAIXA = '' "
	_cQuery	+= " AND Z5_LANC = '"+dtos(_dData)+"' "
	_cQuery	+= " AND Z5_DTENVIO <> '"+dtos(dDatabase)+"' "
	_cQuery	+= " AND Z5_CONTA = 'S' "
	_cQuery += " AND Z5_NIVEL = '2'"
	_cQuery += " AND Z5_UNIDADE = '"+TMPUNI->Z5_UNIDADE+"' "
	_cQuery += " ORDER BY Z5_LANC, Z7_DESCGR, Z5_PRESTA, Z5_VALOR "
	TCQUERY _cQuery ALIAS "TMP" NEW

	DbSelectArea("TMP")
	If EOF()
		DbSelectArea("TMP")
		DbCloseArea()
		DbSelectArea("TMPUNI")
		TMPUNI->(DbSkip())
		Loop
	EndIf

	_cValUnid	:= alltrim(GetMV("CI_CRRESP")) //Unidades com responsabilidade de Sao Paulo para conta de Telefone.
	
	If TMP->Z7_GRUPO $ "A|C" .and. (TMP->Z5_CR $ _cValUnid .or. Empty(TMP->Z5_CR))
		_cEmail := alltrim(GetMV("CI_EMAIL3"))+";"+alltrim(GetMV("CI_EMAIL2"))+";"+alltrim(GetMV("CI_EMAIL1")) //Responsavel pelo Grupo Telefone.
	EndIf
		
	// Alterado em 08/10/2013 - SSI. 13/0218 - INICIO
	If !Empty(SZU->ZU_CC2)
		If TMP->Z7_GRUPO $ "A|C|G" .And. _cEst="SP"
			_cEmail := alltrim(GetMV("CI_EMAIL3"))+";"+alltrim(GetMV("CI_EMAIL2"))+";"+alltrim(GetMV("CI_EMAIL1")) //Responsavel pelo Grupo Telefone, somente telecom recebe o email. - SSI. 13/0218
			_cCC 	:= SZU->ZU_CC1		//copia para contabilidade - SSI. 13/0218
//		ElseIf _cEst != "SP"
//			_cCC += SZU->ZU_CC2
		EndIf
	EndIf		
	// Alterado em 08/10/2013 - SSI. 13/0218 - FIM

	If !Empty (_cEmail)
		_fEnvia(_cEmail,_cCC) //Chama funcao para disparar o e-mail
	Else
		DbSelectArea("TMP")
		DbCloseArea()
	EndIf

	_cQuery := " UPDATE "
	_cQuery += RetSqlName("SZ5")
	_cQuery += " SET Z5_NIVEL = '3', "
	_cQuery += " Z5_DTENVIO = '"+DTOS(dDatabase)+"'"
	_cQuery += " WHERE '"+ _xFilSZ5 +"' = Z5_FILIAL"
	_cQuery += " AND D_E_L_E_T_ <> '*'"
	_cQuery	+= " AND Z5_BAIXA = '' "
	_cQuery	+= " AND Z5_LANC = '"+dtos(_dData)+"' "
	_cQuery	+= " AND Z5_CONTA = 'S' "
	_cQuery += " AND Z5_UNIDADE = '"+TMPUNI->Z5_UNIDADE+"' "
	TcSQLExec(_cQuery)

	DbSelectArea("TMPUNI")
	TMPUNI->(DbSkip())
EndDo

DbSelectArea("TMPUNI")
DbCloseArea()

//NIVEL4
//Auditoria
_cQuery	:= "SELECT Z5_UNIDADE "
_cQuery	+= " FROM "
_cQuery += RetSqlName("SZ5")+" SZ5,"
_cQuery += RetSqlName("SZ7")+" SZ7,"
_cQuery += RetSqlName("SA6")+" SA6"
_cQuery += " WHERE '"+ _xFilSZ5 +"' = Z5_FILIAL"
_cQuery += " AND   '"+ _xFilSZ7 +"' = Z7_FILIAL"
_cQuery += " AND    SZ5.D_E_L_E_T_ <> '*'"
_cQuery += " AND    SZ7.D_E_L_E_T_ <> '*'"
_cQuery += " AND    SA6.D_E_L_E_T_ <> '*'"
_cQuery += " AND    Z5_PRESTA   = Z7_PRESTA"
_cQuery += " AND    Z5_BANCO   = A6_COD"
_cQuery += " AND    Z5_CCONTA   = A6_NUMCON"
_cQuery	+= " AND Z5_BAIXA = '' "
_cQuery	+= " AND Z5_CONTA = 'S' "
_cQuery += " AND Z5_NIVEL = '3'"
_cQuery += " GROUP BY Z5_UNIDADE"
TCQUERY _cQuery ALIAS "TMPUNI" NEW

DbSelectArea("TMPUNI")
DbGotop()
Do While !EOF()

	DbSelectArea("SZU")
	DbSetOrder(2) //UNIDADE
	If DbSeek(xFilial("SZU")+TMPUNI->Z5_UNIDADE,.F.)
		//Acrescentado +5 conforme solicitado pelo Cristiano para que o e-mail do auditor seja com um criterio
		//diferente do gerente. Alteracao dia 07/11/07 pelo analista Emerson
		_nDias	:= SZU->ZU_PERIOD3+5 
		_cEmail := SZU->ZU_EMAIL4 + ";" + SZU->ZU_EMAIL3 + ";" + SZU->ZU_EMAIL2 + ";" + SZU->ZU_EMAIL1
		//_cCC	:= SZU->ZU_CC1 + ";" + SZU->ZU_CC2	// Alterado em 08/10/2013 - SSI. 13/0218
		_cCC	:= SZU->ZU_CC1 + ";" 				// Alterado em 08/10/2013 - SSI. 13/0218
		_cEst	:= Posicione("CTT",1,_xFilCTT+SZU->ZU_CR,"CTT_EST")				// Alterado em 08/10/2013 - SSI. 13/0218
	EndIf

	_dData := DataValida(dDatabase-_nDias,.F.) //O parametro .F. e para considerar a data util anterior (se cai no final de semana considera a sexta)

	_cQuery	:= "SELECT * "
	_cQuery	+= " FROM "
	_cQuery += RetSqlName("SZ5")+" SZ5,"
	_cQuery += RetSqlName("SZ7")+" SZ7,"
	_cQuery += RetSqlName("SA6")+" SA6"
	_cQuery += " WHERE '"+ _xFilSZ5 +"' = Z5_FILIAL"
	_cQuery += " AND   '"+ _xFilSZ7 +"' = Z7_FILIAL"
	_cQuery += " AND SZ5.D_E_L_E_T_ <> '*'"
	_cQuery += " AND SZ7.D_E_L_E_T_ <> '*'"
	_cQuery += " AND SA6.D_E_L_E_T_ <> '*'"
	_cQuery += " AND Z5_PRESTA = Z7_PRESTA"
	_cQuery += " AND Z5_BANCO  = A6_COD"
	_cQuery += " AND Z5_CCONTA = A6_NUMCON"
	_cQuery	+= " AND Z5_BAIXA  = '' "
	_cQuery	+= " AND Z5_LANC <= '"+dtos(_dData)+"' " // Alteracao dia 07/11 pelo analista Emerson. No criterio do Z5_LANC antes estava diferente a database.
	_cQuery	+= " AND Z5_CONTA  = 'S' "
	_cQuery += " AND Z5_NIVEL  = '3'"
	_cQuery += " AND Z5_UNIDADE = '"+TMPUNI->Z5_UNIDADE+"' "
	_cQuery += " ORDER BY Z5_LANC, Z7_DESCGR, Z5_PRESTA, Z5_VALOR "
	TCQUERY _cQuery ALIAS "TMP" NEW

	DbSelectArea("TMP")
	If EOF()
		DbSelectArea("TMP")
		DbCloseArea()
		DbSelectArea("TMPUNI")
		TMPUNI->(DbSkip())
		Loop
	EndIf
		
	_cValUnid	:= alltrim(GetMV("CI_CRRESP")) //Unidades com responsabilidade de Sao Paulo para conta de Telefone.
	
	If TMP->Z7_GRUPO $ "A|C" .and. (TMP->Z5_CR $ _cValUnid .or. Empty(TMP->Z5_CR))
		_cEmail := alltrim(GetMV("CI_EMAIL4"))+";"+alltrim(GetMV("CI_EMAIL3"))+";"+alltrim(GetMV("CI_EMAIL2"))+";"+alltrim(GetMV("CI_EMAIL1")) 
	EndIf

	// Alterado em 08/10/2013 - SSI. 13/0218 - INICIO
	If !Empty(SZU->ZU_CC2)
		If TMP->Z7_GRUPO $ "A|C|G" .And. _cEst="SP"
			_cEmail := alltrim(GetMV("CI_EMAIL4"))+";"+alltrim(GetMV("CI_EMAIL3"))+";"+alltrim(GetMV("CI_EMAIL2"))+";"+alltrim(GetMV("CI_EMAIL1")) //Responsavel pelo Grupo Telefone, somente telecom recebe o email. - SSI. 13/0218
			_cCC 	:= SZU->ZU_CC1		//copia para contabilidade - SSI. 13/0218
//		ElseIf _cEst != "SP"
//			_cCC += SZU->ZU_CC2
		EndIf
	EndIf		
	// Alterado em 08/10/2013 - SSI. 13/0218 - FIM

	If !Empty (_cEmail)
		_fEnvia(_cEmail,_cCC) //Chama funcao para disparar o e-mail
	Else
		DbSelectArea("TMP")
		DbCloseArea()
	EndIf

	_cQuery := " UPDATE "
	_cQuery += RetSqlName("SZ5")
	_cQuery += " SET Z5_NIVEL = '4', "
	_cQuery += " Z5_DTENVIO = '"+DTOS(dDatabase)+"'"
	_cQuery += " WHERE '"+ _xFilSZ5 +"' = Z5_FILIAL"
	_cQuery += " AND D_E_L_E_T_ <> '*'"
	_cQuery	+= " AND Z5_BAIXA = '' "
	_cQuery	+= " AND Z5_LANC <= '"+dtos(_dData)+"' "
	_cQuery	+= " AND Z5_CONTA = 'S' "
	_cQuery += " AND Z5_NIVEL  = '3'"
	_cQuery += " AND Z5_UNIDADE = '"+TMPUNI->Z5_UNIDADE+"' "
	TcSQLExec(_cQuery)

	DbSelectArea("TMPUNI")
	TMPUNI->(DbSkip())

EndDo

DbSelectArea("TMPUNI")
DbCloseArea()

//NIVEL5
//Periodicidade
_cQuery	:= "SELECT Z5_UNIDADE "
_cQuery	+= " FROM "
_cQuery += RetSqlName("SZ5")+" SZ5,"
_cQuery += RetSqlName("SZ7")+" SZ7,"
_cQuery += RetSqlName("SA6")+" SA6"
_cQuery += " WHERE '"+ _xFilSZ5 +"' = Z5_FILIAL"
_cQuery += " AND   '"+ _xFilSZ7 +"' = Z7_FILIAL"
_cQuery += " AND    SZ5.D_E_L_E_T_ <> '*'"
_cQuery += " AND    SZ7.D_E_L_E_T_ <> '*'"
_cQuery += " AND    SA6.D_E_L_E_T_ <> '*'"
_cQuery += " AND    Z5_PRESTA   = Z7_PRESTA"
_cQuery += " AND    Z5_BANCO   = A6_COD"
_cQuery += " AND    Z5_CCONTA   = A6_NUMCON"
_cQuery	+= " AND Z5_BAIXA = '' "
_cQuery	+= " AND Z5_CONTA = 'S' "
_cQuery += " AND Z5_NIVEL = '4'"
_cQuery += " GROUP BY Z5_UNIDADE"
TCQUERY _cQuery ALIAS "TMPUNI" NEW

DbSelectArea("TMPUNI")
DbGotop()
Do While !EOF()

	DbSelectArea("SZU")
	DbSetOrder(2) //UNIDADE
	If DbSeek(xFilial("SZU")+TMPUNI->Z5_UNIDADE,.F.)
		_nDias	:= 10
		_cEmail := SZU->ZU_EMAIL4 + ";" + SZU->ZU_EMAIL3 + ";" + SZU->ZU_EMAIL2 + ";" + SZU->ZU_EMAIL1
		//_cCC	:= SZU->ZU_CC1 + ";" + SZU->ZU_CC2	// Alterado em 08/10/2013 - SSI. 13/0218
		_cCC	:= SZU->ZU_CC1 + ";" 				// Alterado em 08/10/2013 - SSI. 13/0218
		_cEst	:= Posicione("CTT",1,_xFilCTT+SZU->ZU_CR,"CTT_EST")				// Alterado em 08/10/2013 - SSI. 13/0218
	EndIf

	_dData := DataValida(dDatabase-_nDias,.F.) //O parametro .F. e para considerar a data util anterior (se cai no final de semana considera a sexta)

	_cQuery	:= "SELECT * "
	_cQuery	+= " FROM "
	_cQuery += RetSqlName("SZ5")+" SZ5,"
	_cQuery += RetSqlName("SZ7")+" SZ7,"
	_cQuery += RetSqlName("SA6")+" SA6"
	_cQuery += " WHERE '"+ _xFilSZ5 +"' = Z5_FILIAL"
	_cQuery += " AND   '"+ _xFilSZ7 +"' = Z7_FILIAL"
	_cQuery += " AND SZ5.D_E_L_E_T_ <> '*'"
	_cQuery += " AND SZ7.D_E_L_E_T_ <> '*'"
	_cQuery += " AND SA6.D_E_L_E_T_ <> '*'"
	_cQuery += " AND Z5_PRESTA = Z7_PRESTA"
	_cQuery += " AND Z5_BANCO  = A6_COD"
	_cQuery += " AND Z5_CCONTA = A6_NUMCON"
	_cQuery	+= " AND Z5_BAIXA  = '' "
	_cQuery	+= " AND Z5_DTENVIO = '"+dtos(_dData)+"' "
	_cQuery	+= " AND Z5_CONTA  = 'S' "
	_cQuery += " AND Z5_NIVEL  = '4'"
	_cQuery += " AND Z5_UNIDADE = '"+TMPUNI->Z5_UNIDADE+"' "
	_cQuery += " ORDER BY Z5_LANC, Z7_DESCGR, Z5_PRESTA, Z5_VALOR "
	TCQUERY _cQuery ALIAS "TMP" NEW

	DbSelectArea("TMP")
	If EOF()
		DbSelectArea("TMP")
		DbCloseArea()
		DbSelectArea("TMPUNI")
		TMPUNI->(DbSkip())
		Loop
	EndIf
		
	_cValUnid	:= alltrim(GetMV("CI_CRRESP")) //Unidades com responsabilidade de Sao Paulo para conta de Telefone.
	
	If TMP->Z7_GRUPO $ "A|C" .and. (TMP->Z5_CR $ _cValUnid .or. Empty(TMP->Z5_CR))
		_cEmail := alltrim(GetMV("CI_EMAIL4"))+";"+alltrim(GetMV("CI_EMAIL3"))+";"+alltrim(GetMV("CI_EMAIL2"))+";"+alltrim(GetMV("CI_EMAIL1")) //Responsavel pelo Grupo Telefone.
	EndIf

	// Alterado em 08/10/2013 - SSI. 13/0218 - INICIO
	If !Empty(SZU->ZU_CC2)
		If TMP->Z7_GRUPO $ "A|C|G" .And. _cEst="SP"
			_cEmail := alltrim(GetMV("CI_EMAIL4"))+";"+alltrim(GetMV("CI_EMAIL3"))+";"+alltrim(GetMV("CI_EMAIL2"))+";"+alltrim(GetMV("CI_EMAIL1")) //Responsavel pelo Grupo Telefone, somente telecom recebe o email. - SSI. 13/0218
			_cCC 	:= SZU->ZU_CC1		//copia para contabilidade - SSI. 13/0218
//		ElseIf _cEst != "SP"
//			_cCC += SZU->ZU_CC2
		EndIf
	EndIf		
	// Alterado em 08/10/2013 - SSI. 13/0218 - FIM

	If !Empty (_cEmail)
		_fEnvia(_cEmail,_cCC) //Chama funcao para disparar o e-mail
	Else
		DbSelectArea("TMP")
		DbCloseArea()
	EndIf

	_cQuery := " UPDATE "
	_cQuery += RetSqlName("SZ5")
	_cQuery += " Z5_DTENVIO = '"+DTOS(dDatabase)+"'"
	_cQuery += " WHERE '"+ _xFilSZ5 +"' = Z5_FILIAL"
	_cQuery += " AND D_E_L_E_T_ <> '*'"
	_cQuery	+= " AND Z5_BAIXA = '' "
	_cQuery	+= " AND Z5_DTENVIO = '"+dtos(_dData)+"' "
	_cQuery	+= " AND Z5_CONTA = 'S' "
	_cQuery += " AND Z5_NIVEL  = '4'"
	_cQuery += " AND Z5_UNIDADE = '"+TMPUNI->Z5_UNIDADE+"' "
	TcSQLExec(_cQuery)

	DbSelectArea("TMPUNI")
	TMPUNI->(DbSkip())

EndDo

DbSelectArea("TMPUNI")
DbCloseArea()

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCWKF002   บAutor  ณMicrosiga           บ Data ณ  08/14/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _fEnvia(_cEmail,_cCC)

DbSelectArea("TMP")
DbGoTop()

_cAssunto  	:= "Pend๊ncias - Contas de Consumo"
//_cTitulo   	:= OemToAnsi("PENDสNCIAS  -  CONTAS DE CONSUMO")
_cTexto 	:= ""
_cEOL     	:= CHR(13) + CHR(10)
_lFirst		:= .T.
_nCont		:= 0
_Cor		:= 0
_Cor1		:= "#B4BAC6"
_Cor2		:= "#9397A0"

While !TMP->(Eof())
	
	_nCont++
	
	If !Empty(_cEmail) .and. _lFirst
//		_EnvMail(_cEmail, _cAssunto, _cTitulo, _cTexto, _cCC)
		_EnvMail(_cEmail, _cAssunto, _cCC)
		_lFirst		:= .F.
		oHtml  		:= oProcess:oHTML
//		oHtml:ValByName("titulo"	, _cTitulo)
		oHtml:ValByName("email"		, '<a href=mailto:contabilidade@cieesp.org.br>contabilidade@cieesp.org.br</a>')
	EndIf
	
	If _Cor % 2 == 0
		_Cor3 := _Cor1
	Else
		_Cor3 := _Cor2
	EndIf	
	
	AAdd( (oHtml:ValByName( "t.1"    )), 'bgcolor="'+_Cor3+'" width="10%" class="TableRowWhiteMini2" align="left"   height="14">'+ALLTRIM(TMP->A6_NREDUZ))
	AAdd( (oHtml:ValByName( "t.2"    )), 'bgcolor="'+_Cor3+'" width="08%" class="TableRowWhiteMini2" align="left"   height="14">'+ALLTRIM(TMP->Z5_DOC))
	AAdd( (oHtml:ValByName( "t.3"    )), 'bgcolor="'+_Cor3+'" width="08%" class="TableRowWhiteMini2" align="left"   height="14">'+ALLTRIM(TMP->Z5_MES))
	AAdd( (oHtml:ValByName( "t.4"    )), 'bgcolor="'+_Cor3+'" width="10%" class="TableRowWhiteMini2" align="right"  height="14">'+TRANSFORM(TMP->Z5_VALOR,'@E 99,999.99' ))
	AAdd( (oHtml:ValByName( "t.5"    )), 'bgcolor="'+_Cor3+'" width="16%" class="TableRowWhiteMini2" align="left"   height="14">'+ALLTRIM(TMP->Z5_PRESTA))
	AAdd( (oHtml:ValByName( "t.6"    )), 'bgcolor="'+_Cor3+'" width="20%" class="TableRowWhiteMini2" align="left"   height="14">'+ALLTRIM(TMP->Z7_DESCGR))
	AAdd( (oHtml:ValByName( "t.7"    )), 'bgcolor="'+_Cor3+'" width="10%" class="TableRowWhiteMini2" align="center" height="14">'+DTOC(STOD(TMP->Z5_LANC)))
	AAdd( (oHtml:ValByName( "t.8"    )), 'bgcolor="'+_Cor3+'" width="19%" class="TableRowWhiteMini2" align="center" height="14">'+ALLTRIM(TMP->Z5_UNIDADE))

	_Cor++

	DbSelectArea("TMP")
	DbSkip()
End

If _nCont > 0
	oProcess:Start()
EndIf

DbSelectArea("TMP")
DbCloseArea()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCWKF002   บAutor  ณMicrosiga           บ Data ณ  05/29/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _EnvMail (_cEmail, _cAssunto, _cCC) //(_cEmail, _cAssunto, _cTitulo, _cTexto, _cCC)

Private oHtml

oProcess:= TWFProcess():New("000001", "Workflow Contas de Consumo")
oProcess:NewVersion(.T.)
oProcess:NewTask( "Workflow Contas de Consumo", "\Workflow\CWKF002.htm")
oProcess:bReturn	:= ""
oProcess:cSubject	:= _cAssunto
oProcess:cTo  		:= _cEmail
oProcess:cCC  		:= _cCC

Return(.T.)