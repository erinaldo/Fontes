#include "rwmake.ch"
#include "protheus.ch"
#include "TOPCONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA16   บAutor  ณEmerson Natali      บ Data ณ  27/07/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio Movimento Cartao Itau                            บฑฑ
ฑฑบ          ณ WORKFLOW (rotina MENSAL dia 01 e 16)                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CFINA16()

Local cQuery	 := ""
Local _cAssunto  := ""
Local _cEmail	 := ""
Local _cCC		 := ""
Local _cTitulo   := ""
Local _cTexto    := ""

Private oProcess
Private oHtml

_Cor		:= 0
_Cor1		:= "#B4BAC6"
_Cor2		:= "#9397A0"

wfPrepENV( "01", "01")

ChkFile("SZK")

Private	_nPerc  := GetMV("CI_PERC") /100
Private	_nValor	:= 0

_nTotLimit	:= 0
_nTotSld	:= 0
_nTotSaid	:= 0
_nTotEnt	:= 0
_nTotPrest	:= 0
_cStatus	:= ""

If day(dDataBase) == 16 //executa a data 16 e o periodo e de 01 a 31 do proprio mes
	_dDtIni		:= strzero(year(dDataBase),4)+strzero(month(dDataBase),2)+"01"
	_dDtFim		:= strzero(year(dDataBase),4)+strzero(month(dDataBase),2)+"31"
ElseIf day(dDataBase) == 01 .and. month(dDataBase) <> 01 //executa a data 01 e o periodo e de 01 a 31 do mes anterior
	_dDtIni		:= strzero(year(dDataBase),4)+strzero((month(dDataBase)-1),2)+"01"
	_dDtFim		:= strzero(year(dDataBase),4)+strzero((month(dDataBase)-1),2)+"31"
ElseIf day(dDataBase) == 01 .and. month(dDataBase) == 01 //executa a data 01 e o periodo e de 01 a 31 do mes anterior
	_dDtIni		:= strzero((year(dDataBase)-1),4)+"1201"
	_dDtFim		:= strzero((year(dDataBase)-1),4)+"1231"
Else
	_dDtIni		:= ""
	_dDtFim		:= ""
EndIf	

dbSelectArea("SZK")
dbSetOrder(1)

cQuery := "SELECT * "
cQuery += "FROM "+RetSQLname('SZK')+" "
cQuery += "WHERE D_E_L_E_T_ = '' "
cQuery += "AND ZK_TIPO = '4' "
cQuery += "AND ZK_STATUS  = 'A' " // Ativo
TcQuery cQuery New Alias "SZKTMP"

dbSelectArea("SZKTMP")
dbGoTop()
While !EOF()

	_cAssunto  	:= "Cartใo Empresa Ita๚ - Relatorio Movimenta็ใo"

	_cEmail		:= IIF(!Empty(Alltrim(SZKTMP->ZK_E_SUP)),Alltrim(SZKTMP->ZK_E_SUP)+";"+Alltrim(SZKTMP->ZK_E_CC1),Alltrim(SZKTMP->ZK_E_CC1))

	_cCC		:= 'cristiano@cieesp.org.br'
	
	//SAQUE
	cQuery := "SELECT SUM(E5_VALOR) AS SAQUE "
	cQuery += "FROM "+RetSQLname('SE5')+" "
	cQuery += "WHERE D_E_L_E_T_ = '' "
	cQuery += "AND E5_MOEDA IN ('DE','AC') "
	cQuery += "AND SUBSTRING(E5_CARTAO,1,6) = '"+SZKTMP->ZK_NROCRT+"'  "
	cQuery += "AND E5_RECPAG = 'P' "
	cQuery += "AND E5_SITUACA <> 'X' "
	cQuery += "AND E5_DATA < '"+_dDtIni+"' "
	TcQuery cQuery New Alias "SE5TMP1"
	TcSetField("SE5TMP1","E5_DATA","D",8, 0 )

	If ValType(SE5TMP1->SAQUE) == 'U'
		_nValSaque	:= 0
	Else
		_nValSaque	:= SE5TMP1->SAQUE
	EndIf

	DbSelectArea("SE5TMP1")
	SE5TMP1->(DbCloseArea())

	//PRESTACAO DE CONTAS
	cQuery := "SELECT SUM(E5_VALOR) AS PRSCTAS "
	cQuery += "FROM "+RetSQLname('SE5')+" "
	cQuery += "WHERE D_E_L_E_T_ = '' "
	cQuery += "AND E5_MOEDA = 'BC' "
	cQuery += "AND SUBSTRING(E5_CARTAO,1,6) = '"+SZKTMP->ZK_NROCRT+"' "
	cQuery += "AND E5_RECPAG = 'R' "
	cQuery += "AND E5_DATA < '"+_dDtIni+"' "
	cQuery += "AND (E5_NATUREZ = '2.21.08' OR E5_NATUREZ = '6.08.04' OR "
	cQuery += "     E5_NATUREZ = '02090608' OR E5_NATUREZ = '33080104') "
	TcQuery cQuery New Alias "SE5TMP2"
	TcSetField("SE5TMP2","E5_DATA","D",8, 0 )

	If ValType(SE5TMP2->PRSCTAS) == 'U'
		_nValPrest 	:= 0
	Else
		_nValPrest 	:= SE5TMP2->PRSCTAS
	EndIf

	_nSldAnt := _nValSaque - _nValPrest

	DbSelectArea("SE5TMP2")
	SE5TMP2->(DbCloseArea())

	//SAQUES ANALITICO
	cQuery := "SELECT E5_DATA, E5_CARTAO, E5_VALOR, E5_RECPAG, E5_HISTOR, E5_XTIPO  "
	cQuery += "FROM "+RetSQLname('SE5')+" "
	cQuery += "WHERE D_E_L_E_T_ = '' "
	cQuery += "AND SUBSTRING(E5_CARTAO,1,6) = '"+SZKTMP->ZK_NROCRT+"' "
	cQuery += "AND E5_RECPAG = 'P' "
	cQuery += "AND E5_MOEDA IN ('DE','AC') "
	cQuery += "AND E5_SITUACA <> 'X' "
	cQuery += "AND E5_DATA BETWEEN '"+_dDtIni+"' AND '"+_dDtFim+"' "

	//PRESTACAO DE CONTAS - ENTRADA
	cQuery += "UNION ALL "
	cQuery += "SELECT E5_DATA, E5_CARTAO, E5_VALOR, E5_RECPAG, E5_HISTOR, E5_XTIPO  "
	cQuery += "FROM "+RetSQLname('SE5')+" "
	cQuery += "WHERE D_E_L_E_T_ = '' "
	cQuery += "AND SUBSTRING(E5_CARTAO,1,6) = '"+SZKTMP->ZK_NROCRT+"' "
	cQuery += "AND E5_RECPAG = 'R' "
	cQuery += "AND (E5_NATUREZ = '2.21.08' OR E5_NATUREZ = '6.08.04' OR "
	cQuery += "     E5_NATUREZ = '02090608' OR E5_NATUREZ = '33080104') "
	cQuery += "AND E5_DATA BETWEEN '"+_dDtIni+"' AND '"+_dDtFim+"' "

	cQuery += "ORDER BY E5_DATA "
	TcQuery cQuery New Alias "SE5TRB"
	TcSetField("SE5TRB","E5_DATA","D",8, 0 )

	DbSelectArea("SE5TRB")
	DbGotop()

	If EOF()
		DbSelectArea("SE5TRB")
		SE5TRB->(DbCloseArea())
		DbSelectArea("SZKTMP")
		SZKTMP->(dbSkip())	
		Loop
	EndIf

// Inicio Geracao do HTML
	If !Empty (_cEmail)
		_EnvMail(_cEmail,_cCC,_cAssunto) //Chama funcao para disparar o e-mail
		oHtml	:= oProcess:oHTML
	Else
		DbSelectArea("SZKTMP")
		SZKTMP->(dbSkip())	
		Loop
	EndIf

// Inicio CABECALHO da geracao do HTML
	oHtml:ValByName("portador"		, SUBSTR(SZKTMP->ZK_NOME,1,30))											// portador
	oHtml:ValByName("limite"		, Transform(SZKTMP->ZK_E_LIMIT, "@E 999,999,999.99")) 					// limite
	oHtml:ValByName("disponivel"	, Transform(SZKTMP->ZK_E_SLDAT, "@E 999,999,999.99"))					// disponivel
	oHtml:ValByName("perc"			, Transform(((SZKTMP->ZK_E_SLDAT/SZKTMP->ZK_E_LIMIT)*100),"999.99")) 	// perc
//	oHtml:ValByName("sldanterior"	, Transform(_nSldAnt,"@E 999,999,999.99"))								// sldanterior	
	oHtml:ValByName("unidade"		, SZKTMP->ZK_UNIDADE)													// unidade
// Fim CABECALHO

	_nSldAtu 	:= _nSldAnt
	_nSldEnt	:= 0
	_nSldSai	:= 0


// Inicio DETALHE (ITENS) SALDO ANTERIOR da geracao do HTML
			If _Cor % 2 == 0
				_Cor3 := _Cor1
			Else
				_Cor3 := _Cor2
			EndIf

			AAdd( (oHtml:ValByName( "t.1"    )), (STOD(_dDtIni)-1) )								// t.1
			AAdd( (oHtml:ValByName( "t.2"    )), SUBSTR(SE5TRB->E5_CARTAO,1,6))				// t.2
			AAdd( (oHtml:ValByName( "t.3"    )), "SALDO ANTERIOR"				)				// t.3
			AAdd( (oHtml:ValByName( "t.4"    )), Transform(0,"@E 999,999,999.99"))				// t.4
			AAdd( (oHtml:ValByName( "t.5"    )), Transform(0,"@E 999,999,999.99"))		   		// t.5
			AAdd( (oHtml:ValByName( "t.7"    )), Transform(_nSldAnt,"@E 999,999,999.99"))				// t.7
			AAdd( (oHtml:ValByName( "t.8"    )), Transform(((_nSldAnt/SZKTMP->ZK_E_LIMIT)*100),"999.99"))						// t.8
			AAdd( (oHtml:ValByName( "t.9"    )), "" 			)								//t.9
			AAdd( (oHtml:ValByName( "t.6"    )), _Cor3 )
			_Cor++	
// Fim DETALHE SALDO ANTERIOR (ITENS)


	Do While !EOF()

			If ALLTRIM(SE5TRB->E5_XTIPO) == "A12" // ACERTO CARTAO
				_xcQuery := "SELECT E5_DOCUMEN AS HISTOR "
				_xcQuery += "FROM "+RetSQLname('SE5')+" "
				_xcQuery += "WHERE D_E_L_E_T_ = '' "
				_xcQuery += "AND SUBSTRING(E5_CARTAO,1,6) = '"+SZKTMP->ZK_NROCRT+"' "
				_xcQuery += "AND E5_DATA BETWEEN '"+DTOS(SE5TRB->E5_DATA)+"' AND '"+DTOS(SE5TRB->E5_DATA)+"' "
				_xcQuery += "AND E5_XTIPO = 'A12' "
				_xcQuery += "ORDER BY E5_DATA "
				TcQuery _xcQuery New Alias "TRBHIST"
				DbSelectArea("TRBHIST")
			Else
				_xcQuery := "SELECT E5_HISTOR AS HISTOR "
				_xcQuery += "FROM "+RetSQLname('SE5')+" "
				_xcQuery += "WHERE D_E_L_E_T_ = '' "
				_xcQuery += "AND SUBSTRING(E5_CARTAO,1,6) = '"+SZKTMP->ZK_NROCRT+"' "
				_xcQuery += "AND E5_DATA BETWEEN '"+DTOS(SE5TRB->E5_DATA)+"' AND '"+DTOS(SE5TRB->E5_DATA)+"' "
				_xcQuery += "AND E5_RECPAG = 'P' "
				_xcQuery += "AND E5_MOEDA = 'BC' "
				_xcQuery += "ORDER BY E5_DATA "
				TcQuery _xcQuery New Alias "TRBHIST"
				DbSelectArea("TRBHIST")
			EndIf	
			_cHist	:= TRBHIST->HISTOR

			DbSelectArea("TRBHIST")
			TRBHIST->(DbCloseArea())

// Inicio DETALHE (ITENS) da geracao do HTML

			If _Cor % 2 == 0
				_Cor3 := _Cor1
			Else
				_Cor3 := _Cor2
			EndIf

			AAdd( (oHtml:ValByName( "t.1"    )), SE5TRB->E5_DATA) 												// t.1
			AAdd( (oHtml:ValByName( "t.2"    )), SUBSTR(SE5TRB->E5_CARTAO,1,6))								// t.2
			AAdd( (oHtml:ValByName( "t.3"    )), SUBSTR(SE5TRB->E5_HISTOR,1,30))								// t.3
			If SE5TRB->E5_RECPAG == "P"
				AAdd( (oHtml:ValByName( "t.4"    )), Transform(SE5TRB->E5_VALOR,"@E 999,999,999.99"))			// t.4
				AAdd( (oHtml:ValByName( "t.5"    )), Transform(0,"@E 999,999,999.99"))	   						// t.5
				_nSldSai += SE5TRB->E5_VALOR
			Else
				AAdd( (oHtml:ValByName( "t.4"    )), Transform(0,"@E 999,999,999.99"))							// t.4
				AAdd( (oHtml:ValByName( "t.5"    )), Transform(SE5TRB->E5_VALOR,"@E 999,999,999.99"))	   		// t.5
				_nSldEnt += SE5TRB->E5_VALOR
			EndIf

			//SALDO PRESTAR CONTAS
			If SE5TRB->E5_RECPAG == "P"
				_nSldAtu+=SE5TRB->E5_VALOR
			Else
				_nSldAtu-=SE5TRB->E5_VALOR
			EndIf

			AAdd( (oHtml:ValByName( "t.7"    )), Transform(_nSldAtu,"@E 999,999,999.99"))						// t.7
			AAdd( (oHtml:ValByName( "t.8"    )), Transform(((_nSldAtu/SZKTMP->ZK_E_LIMIT)*100),"999.99"))		// t.8
		
			If ALLTRIM(SE5TRB->E5_XTIPO) == "A12"
				AAdd( (oHtml:ValByName( "t.9"    )), _cHist)													//t.9
			Else
				If SE5TRB->E5_RECPAG == "R"
					AAdd( (oHtml:ValByName( "t.9"    )), _cHist)													//t.9
				Else
					AAdd( (oHtml:ValByName( "t.9"    )), Space(40))													//t.9
				EndIf
			EndIf

			AAdd( (oHtml:ValByName( "t.6"    )), _Cor3 )

			_Cor++	
// Fim DETALHE (ITENS)

			DbSelectArea("SE5TRB")
			SE5TRB->(DbSkip())
	EndDo

// Inicio RODAPE geracao HTML


	oHtml:ValByName( "totsaida"		, Transform(_nSldSai,"@E 999,999,999.99"))						// totsaida
	oHtml:ValByName( "totentrada"	, Transform(_nSldEnt,"@E 999,999,999.99"))						// totentrada
	oHtml:ValByName( "totsldprest"	, Transform(_nSldAtu,"@E 999,999,999.99"))						// totsldprest
	oHtml:ValByName( "totperc"		, Transform(((_nSldAtu/SZKTMP->ZK_E_LIMIT)*100),"999.99"))		// totperc

	_nValor		:= SZKTMP->ZK_E_LIMIT * _nPerc
	oHtml:ValByName("sldprest"		, Transform(_nValor,"@E 999,999,999.99"))						// sldprest
	oHtml:ValByName("slddisp"		, Transform(_nValor,"@E 999,999,999.99"))						// slddesp

// FIM RODAPE 

	oProcess:Start()

	DbSelectArea("SE5TRB")
	SE5TRB->(DbCloseArea())

	DbSelectArea("SZKTMP")
	SZKTMP->(dbSkip())

EndDo

DbSelectArea("SZKTMP")
SZKTMP->(DbCloseArea())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_EnvMail  บAutor  ณEmerson             บ Data ณ  11/03/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao carrega workflow aviso bloqueio cartao empresa itau บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _EnvMail (_cEmail,_cCC,_cAssunto )

Private oHtml

oProcess:= TWFProcess():New("000001", "Workflow Movimento Cartao")
oProcess:NewVersion(.T.)
oProcess:NewTask( "Workflow Movimento Cartao", "\Workflow\WFRelMovCartao.htm")
oProcess:bReturn	:= ""
oProcess:cSubject	:= _cAssunto
oProcess:cTo  		:= _cEmail
oProcess:cCC  		:= _cCC

Return(.T.)