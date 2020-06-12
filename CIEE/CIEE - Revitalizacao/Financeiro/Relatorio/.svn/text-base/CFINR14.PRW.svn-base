#include "rwmake.ch"
#include "protheus.ch"
#include "TOPCONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINR14   บAutor  ณEmerson Natali      บ Data ณ  23/03/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio Movimento Cartao Itau                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CFINR14()

//ณ Declaracao de Variaveis
Local cDesc1 	:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2 	:= "de acordo com os parametros informados pelo usuario."
Local cDesc3 	:= "Movimentacao Cartao"
Local titulo 	:= OemToAnsi("Relat๓rio Movimenta็ใo Cartใo  -  Perํodo")
Local nLin 		:= 80
Local Cabec1 	:= "Data      Cartao       Unidade         Hist.Extrato                            Saida        Entrada      Sld.Prest.Contas       Perc.(%)    Historico"
Local Cabec2 	:= ""

Private lAbortPrint 	:= .F.
Private limite 			:= 132
Private tamanho 		:= "G"
Private nomeprog 		:= "CFINR14"
Private nTipo 			:= 18
Private aReturn 		:= { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey 		:= 0
Private m_pag 			:= 01
Private wnrel 			:= "CFINR14"
Private cString 		:= "SZK"
Private _cHist			:= ""
Private cPerg			:= "CFIN58    "
Private oProcess 		:= NIL

dbSelectArea("SZK")
dbSetOrder(1)

_fCriaSx1()

//ณ Monta a interface padrao com o usuario...
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,Tamanho,,.F.)

Pergunte(cPerg,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ณ Processamento. RPTSTATUS monta janela com a regua de processamento.
oProcess := MsNewProcess():New({|lEnd| RunReport(Cabec1,Cabec2,Titulo,nLin,lEnd,oProcess)},"Processando","Lendo...",.T.)       // PATRICIA FONTANEZI
oProcess:Activate()

//RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)         PATRICIA FONTANEZI
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  23/03/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

//Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin,lEnd,oObj)       // PATRICIA FONTANEZI
_nTotLimit	:= 0
_nTotSld	:= 0
_nTotSaid	:= 0
_nTotEnt	:= 0
_nTotPrest	:= 0
_cStatus	:= ""

titulo += " " + DTOC(MV_PAR01) + " a " + DTOC(MV_PAR02)+ " "

If mv_par06 == "01"
	_cStatus := "Ativos"
ElseIf mv_par06 == "02"
	_cStatus := "Demitidos"
ElseIf mv_par06 == "03"
	_cStatus := "Ferias"
ElseIf mv_par06 == "04"
	_cStatus := "Subs.Ferias"
ElseIf mv_par06 == "05"
	_cStatus := "Afastados"
ElseIf mv_par06 == "06"
	_cStatus := "Alt.Responsabilidade"
EndIf

If mv_par05 == 1 //analitico
	titulo += " (Analitico - "+_cStatus+")"
	Cabec1 	:= "Data      Cartao       Unidade         Hist.Extrato                            Saida        Entrada      Sld.Prest.Contas       Perc.(%)     Historico"
Else
	titulo += " (Sintetico - "+_cStatus+")"
	Cabec1 	:= "Data      Cartao       Unidade         Nome                              Limite Periodo      Saldo Disp.            Saida        Entrada      Sld.Prest.Contas  Perc.(%)"
EndIf

dbSelectArea(cString)
dbSetOrder(1)
//SetRegua(RecCount())

cQuery := "SELECT ZK_FILIAL, ZK_NOME, ZK_E_LIMIT, ZK_E_SLDAT, ZK_E_SLDPR, ZK_NROCRT, ZK_UNIDADE "
cQuery += "FROM "+RetSQLname('SZK')+" "
cQuery += "WHERE D_E_L_E_T_ = '' "
cQuery += "AND ZK_TIPO = '4' "
If mv_par06 == "01"
	cQuery += "AND ZK_STATUS  = 'A' " // Ativo
ElseIf mv_par06 == "02"
	cQuery += "AND ZK_XTPINAT = '1' " // Demitidos
ElseIf mv_par06 == "03"
	cQuery += "AND ZK_XTPINAT = '2' " // Ferias
ElseIf mv_par06 == "04"
	cQuery += "AND ZK_XTPINAT = '3' " // Subs.Ferias
ElseIf mv_par06 == "05"
	cQuery += "AND ZK_XTPINAT = '4' " // Afastado
ElseIf mv_par06 == "06"
	cQuery += "AND ZK_XTPINAT = '5' " // Alt.Responsabilidade
EndIf
cQuery += "AND ZK_NROCRT BETWEEN '"+ALLTRIM(mv_par03)+"' AND '"+ALLTRIM(mv_par04)+"' " 
IF !EMPTY(MV_PAR07)                                                                  //PATRICIA FONTANEZI - 01/11/2012 INCLUSAO PARAMETRO 07, 08 E 09
cQuery += "AND ZK_UNIDADE = '"+ALLTRIM(mv_par07)+"' "
ENDIF    
IF MV_PAR09 <> 0
cQuery += "AND ZK_E_LIMIT >= "+ALLTRIM(STR(MV_PAR08))+" AND ZK_E_LIMIT <= "+ALLTRIM(STR(MV_PAR09))+" "
ENDIF  
IF !EMPTY(MV_PAR10)
cQuery += "AND ZK_E_DTREC = '"+ALLTRIM(DTOS(mv_par10))+"' "
ENDIF
cQuery += "ORDER BY ZK_NROCRT"
//TcQuery cQuery New Alias "SZKTMP"
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'SZKTMP',.T.,.T.)

dbSelectArea("SZKTMP")
dbGoTop()
//ProcRegua(RecCount()) 
//PATRICIA FONTANEZI
_nContReg := RecCount()
oObj:SetRegua1(_nContReg)

While !EOF()

	//IncRegua()
	//ณ Verifica o cancelamento pelo usuario...
	
	oObj:IncRegua1("Buscando informa็๕es referente ao Cartใo: "+SZKTMP->ZK_NROCRT)
	If lEnd
		Exit
	Endif
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif

	//SAQUE
	cQuery := "SELECT SUM(E5_VALOR) AS SAQUE "
	cQuery += "FROM "+RetSQLname('SE5')+" "
	cQuery += "WHERE D_E_L_E_T_ = '' "
	cQuery += "AND E5_MOEDA IN ('DE','AC') "
	cQuery += "AND SUBSTRING(E5_CARTAO,1,6) = '"+SZKTMP->ZK_NROCRT+"'  "
	cQuery += "AND E5_RECPAG = 'P' "
	cQuery += "AND E5_SITUACA <> 'X' "
	cQuery += "AND E5_DATA < '"+DTOS(mv_par01)+"' "
   //	TcQuery cQuery New Alias "SE5TMP1" 
    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'SE5TMP1',.T.,.T.)
	TcSetField("SE5TMP1","E5_DATA","D",8, 0 )

	If ValType(SE5TMP1->SAQUE) == 'U'
		_nValSaque	:= 0
	Else
		_nValSaque	:= SE5TMP1->SAQUE
	EndIf
   
	_nContReg1 := SE5TMP1->(RecCount())
	oObj:SetRegua2(_nContReg1)
	oObj:IncRegua2("Processando Saldo anterior do Cartใo: "+SZKTMP->ZK_NROCRT)
	
	DbSelectArea("SE5TMP1")
	SE5TMP1->(DbCloseArea())

	//PRESTACAO DE CONTAS
	cQuery := "SELECT SUM(E5_VALOR) AS PRSCTAS "
	cQuery += "FROM "+RetSQLname('SE5')+" "
	cQuery += "WHERE D_E_L_E_T_ = '' "
	cQuery += "AND E5_MOEDA = 'BC' "
	cQuery += "AND SUBSTRING(E5_CARTAO,1,6) = '"+SZKTMP->ZK_NROCRT+"' "
	cQuery += "AND E5_RECPAG = 'R' "
	cQuery += "AND E5_DATA < '"+DTOS(mv_par01)+"' "
	cQuery += "AND (E5_NATUREZ = '2.21.08' OR E5_NATUREZ = '6.08.04' OR "
	cQuery += "     E5_NATUREZ = '02090608' OR E5_NATUREZ = '33080104') "  
   //	TcQuery cQuery New Alias "SE5TMP2" 
    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'SE5TMP2',.T.,.T.)
	TcSetField("SE5TMP2","E5_DATA","D",8, 0 )

	If ValType(SE5TMP2->PRSCTAS) == 'U'
		_nValPrest 	:= 0
	Else
		_nValPrest 	:= SE5TMP2->PRSCTAS
	EndIf

	_nSldAnt := _nValSaque - _nValPrest 
    
	DbSelectArea("SE5TMP2")
	SE5TMP2->(DbCloseArea())

	If mv_par05 == 1 //Analitico
		//SAQUES ANALITICO
		cQuery := "SELECT E5_DATA, E5_CARTAO, E5_VALOR, E5_RECPAG, E5_HISTOR, E5_XTIPO "
		cQuery += "FROM "+RetSQLname('SE5')+" "
		cQuery += "WHERE D_E_L_E_T_ = '' "
		cQuery += "AND SUBSTRING(E5_CARTAO,1,6) = '"+SZKTMP->ZK_NROCRT+"' "
		cQuery += "AND E5_RECPAG = 'P' "
		cQuery += "AND E5_MOEDA IN ('DE','AC') "
		cQuery += "AND E5_SITUACA <> 'X' "
		cQuery += "AND E5_DATA BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' "
	Else
		//SAQUES SINTETICO
		cQuery := "SELECT E5_DATA, E5_CARTAO, SUM(E5_VALOR) AS E5_VALOR, E5_RECPAG, E5_HISTOR, E5_XTIPO "
		cQuery += "FROM "+RetSQLname('SE5')+" "
		cQuery += "WHERE D_E_L_E_T_ = '' "
		cQuery += "AND SUBSTRING(E5_CARTAO,1,6) = '"+SZKTMP->ZK_NROCRT+"' "
		cQuery += "AND E5_RECPAG = 'P' "
		cQuery += "AND E5_MOEDA IN ('DE','AC') "
		cQuery += "AND E5_SITUACA <> 'X' "
//		If mv_par05 == 1 //Analitico 
			cQuery += "AND E5_DATA BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' "
//		EndIf
		cQuery += "GROUP BY E5_DATA, E5_CARTAO, E5_RECPAG, E5_HISTOR, E5_XTIPO "
	EndIf

	//PRESTACAO DE CONTAS - ENTRADA
	cQuery += "UNION ALL "
	cQuery += "SELECT E5_DATA, E5_CARTAO, E5_VALOR, E5_RECPAG, E5_HISTOR, E5_XTIPO "
	cQuery += "FROM "+RetSQLname('SE5')+" "
	cQuery += "WHERE D_E_L_E_T_ = '' "
	cQuery += "AND SUBSTRING(E5_CARTAO,1,6) = '"+SZKTMP->ZK_NROCRT+"' "
	cQuery += "AND E5_RECPAG = 'R' "
	cQuery += "AND (E5_NATUREZ = '2.21.08' OR E5_NATUREZ = '6.08.04' OR "
	cQuery += "     E5_NATUREZ = '02090608' OR E5_NATUREZ = '33080104') "
//	If mv_par05 == 1 //Analitico
		cQuery += "AND E5_DATA BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' "
//	EndIf
	cQuery += "ORDER BY E5_DATA, E5_CARTAO, E5_RECPAG, E5_HISTOR, E5_XTIPO "
	//TcQuery cQuery New Alias "SE5TRB" 
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'SE5TRB',.T.,.T.)
	TcSetField("SE5TRB","E5_DATA","D",8, 0 )

	DbSelectArea("SE5TRB")
	DbGotop()
   
	If EOF()
		DbSelectArea("SE5TRB")
		SE5TRB->(DbCloseArea())
		DbSelectArea("SZKTMP")
		SZKTMP->(dbSkip())	
		Loop
	Else
		//ณ Impressao do cabecalho do relatorio. . .
		If mv_par05 == 1 //Analitico
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Else
			If nLin > 58
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			EndIf
		EndIf
	EndIf

	If mv_par05 == 1 //Analitico
		@nLin,00 PSAY SUBSTR(SZKTMP->ZK_NOME,1,30)+ "         LIMITE ---->"
		@nLin,53 PSAY SZKTMP->ZK_E_LIMIT picture "@E 999,999,999.99"

		@nLin,071 PSAY "        DISPONIVEL ---->"
		@nLin,107 PSAY SZKTMP->ZK_E_SLDAT picture "@E 999,999,999.99"

		@nLin,129 PSAY (SZKTMP->ZK_E_SLDAT/SZKTMP->ZK_E_LIMIT)*100 picture "999.99"+"%"
		
		nLin++
		nLin++

		@nLin,071 PSAY "        SALDO ANTERIOR ---->" 
		@nLin,107 PSAY _nSldAnt picture "@E 999,999,999.99"	//SALDO ANTERIOR
		nLin++
		nLin++
	EndIf
	
	_nSldAtu 	:= _nSldAnt
	_nSldEnt	:= 0
	_nSldSai	:= 0
	If mv_par05 == 1 //Analitico
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

			If nLin > 58
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif
			/*
			          1         2         3         4         5         6         7         8         9         10        11        12        13       14
			012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
			Data      Cartao       Unidade         Nome Portador                           Saida        Entrada      Sld.Prest.Contas       Perc.(%)     Historico
			XX/XX/XX  XXXXXXX      XXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXX    999,999,999.99 999,999,999.99        999,999,999.99        999.99      XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
			*/
			@nLin,00 PSAY SE5TRB->E5_DATA
			@nLin,10 PSAY SUBSTR(SE5TRB->E5_CARTAO,1,6)
			@nLin,23 PSAY SZKTMP->ZK_UNIDADE
			@nLin,39 PSAY SUBSTR(SE5TRB->E5_HISTOR,1,30) //SUBSTR(SZKTMP->ZK_NOME,1,30)
			If SE5TRB->E5_RECPAG == "P"
				@nLin,70 PSAY SE5TRB->E5_VALOR picture "@E 999,999,999.99"	//SAIDA
				_nSldSai += SE5TRB->E5_VALOR
			Else
				@nLin,85 PSAY SE5TRB->E5_VALOR picture "@E 999,999,999.99"	//ENTRADA
				_nSldEnt += SE5TRB->E5_VALOR
			EndIf

			//SALDO PRESTAR CONTAS
			If SE5TRB->E5_RECPAG == "P"
				_nSldAtu+=SE5TRB->E5_VALOR
			Else
				_nSldAtu-=SE5TRB->E5_VALOR
			EndIf

			@nLin,107 PSAY _nSldAtu picture "@E 999,999,999.99"	//SALDO PRESTAR CONTAS
		
			@nLin,129 PSAY (_nSldAtu/SZKTMP->ZK_E_LIMIT)*100 picture "999.99"+"%"
		
			If ALLTRIM(SE5TRB->E5_XTIPO) == "A12" // ACERTO CARTAO
				@nLin,141 PSAY _cHist
			Else
				If SE5TRB->E5_RECPAG == "R"
					@nLin,141 PSAY _cHist
				EndIf
			EndIf

			nLin++
			DbSelectArea("SE5TRB")
			SE5TRB->(DbSkip())
		EndDo
	Else	//Sintetico

		_cData		:= SE5TRB->E5_DATA
		_cCartao	:= SUBSTR(SE5TRB->E5_CARTAO,1,6)
		_cUnid		:= SZKTMP->ZK_UNIDADE
		_cNome		:= SUBSTR(SZKTMP->ZK_NOME,1,30) //SUBSTR(SE5TRB->E5_HISTOR,1,30)
		_cValorSaid	:= 0
		_cValorEnt	:= 0

		Do While !EOF()

			If nLin > 58
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif
			/*
			          1         2         3         4         5         6         7         8         9         10        11        12        13        14       15        16
			01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
			Data      Cartao       Unidade         Nome Portador                  Limite Periodo  Saldo Disponivel           Saida         Entrada  Sld.Prest.Contas  Perc.(%)
			XX/XX/XX  XXXXXXX      XXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXX    999,999,999.99    999,999,999.99  999,999,999.99  999,999,999.99    999,999,999.99  999.99
			*/
			_cData		:= SE5TRB->E5_DATA
			_cCartao	:= SUBSTR(SE5TRB->E5_CARTAO,1,6)
			_cUnid		:= SZKTMP->ZK_UNIDADE
			_cNome		:= SUBSTR(SZKTMP->ZK_NOME,1,30) //SUBSTR(SE5TRB->E5_HISTOR,1,30)

			If SE5TRB->E5_RECPAG == "P"
				_cValorSaid += SE5TRB->E5_VALOR
				_nSldAtu	+= SE5TRB->E5_VALOR
			Else
				_cValorEnt	+= SE5TRB->E5_VALOR
				_nSldAtu	-= SE5TRB->E5_VALOR
			EndIf

			DbSelectArea("SE5TRB")
			SE5TRB->(DbSkip())
		EndDo

		@nLin,000 PSAY _cData
		@nLin,010 PSAY _cCartao
		@nLin,023 PSAY _cUnid
		@nLin,039 PSAY _cNome
		@nLin,073 PSAY SZKTMP->ZK_E_LIMIT picture "@E 999,999,999.99"	//Limite
		@nLin,089 PSAY SZKTMP->ZK_E_SLDAT picture "@E 999,999,999.99"	//Disponivel
		@nLin,107 PSAY _cValorSaid picture "@E 999,999,999.99"	//SAIDA
		@nLin,122 PSAY _cValorEnt picture "@E 999,999,999.99"	//ENTRADA
		@nLin,144 PSAY _nSldAtu picture "@E 999,999,999.99"	//SALDO PRESTAR CONTAS
		@nLin,160 PSAY (_nSldAtu/SZKTMP->ZK_E_LIMIT)*100 picture "999.99"+"%"

//		@nLin,144 PSAY SZKTMP->ZK_E_SLDPR picture "@E 999,999,999.99"	//SALDO PRESTAR CONTAS
//		@nLin,160 PSAY (SZKTMP->ZK_E_SLDPR/SZKTMP->ZK_E_LIMIT)*100 picture "999.99"+"%"

		nLin++
		@ nLin,00 PSAY __PrtFatLine()
		nLin++

		_nTotLimit	+= SZKTMP->ZK_E_LIMIT
		_nTotSld	+= SZKTMP->ZK_E_SLDAT
		_nTotSaid	+= _cValorSaid
		_nTotEnt	+= _cValorEnt
		_nTotPrest	+= _nSldAtu
//		_nTotPrest	+= SZKTMP->ZK_E_SLDPR

	EndIf

	nLin++

	If mv_par05 == 1 //Analitico
		@nLin,039 PSAY "   TOTAL GERAL ----->"
		@nLin,070 PSAY _nSldSai 		picture "@E 999,999,999.99"	//SAIDA
		@nLin,085 PSAY _nSldEnt 		picture "@E 999,999,999.99"	//ENTRADA
		@nLin,107 PSAY _nSldAtu 		picture "@E 999,999,999.99"	//SALDO PRESTAR CONTAS
		@nLin,129 PSAY (_nSldAtu/SZKTMP->ZK_E_LIMIT)*100 picture "999.99"+"%"
	EndIf

	DbSelectArea("SE5TRB")
	SE5TRB->(DbCloseArea())

	DbSelectArea("SZKTMP")
	SZKTMP->(dbSkip())
EndDo

DbSelectArea("SZKTMP")
SZKTMP->(DbCloseArea())
	
If mv_par05 == 2 //Sintetico
	@nLin,039 PSAY "   TOTAL GERAL ----->"
	@nLin,073 PSAY _nTotLimit 	picture "@E 999,999,999.99"	//Total Limite
	@nLin,089 PSAY _nTotSld 	picture "@E 999,999,999.99"	//Total Disponivel
	@nLin,107 PSAY _nTotSaid 	picture "@E 999,999,999.99"	//Total SAIDA
	@nLin,122 PSAY _nTotEnt 	picture "@E 999,999,999.99"	//Total ENTRADA
	@nLin,144 PSAY _nTotPrest 	picture "@E 999,999,999.99"	//Total SALDO PRESTAR CONTAS
EndIf


//ณ Finaliza a execucao do relatorio...

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
	SET PRINTER TO
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

u_CFINR14()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA57   บAutor  ณMicrosiga           บ Data ณ  03/23/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _fCriaSx1()

aRegs     := {}
nSX1Order := SX1->(IndexOrd())

SX1->(dbSetOrder(1))

cPerg := Left(cPerg,10)

/*
             grupo ,ordem ,pergunt      ,perg spa ,perg eng , variav ,tipo,tam,dec,pres,gsc,valid ,var01  ,def01       ,defspa01,defeng01,cnt01,var02,def02       ,defspa02,defeng02 ,cnt02 ,var03 ,def03       ,defspa03 ,defeng03 ,cnt03 ,var04 ,def04            ,defspa04 ,defeng04 ,cnt04 ,var05 ,def05         ,defspa05 ,defeng05,cnt05 ,f3       ,"","","",""
*/
aAdd(aRegs,{cPerg,"01"   ,"Data de   ?",""       ,""       ,"mv_ch1","D" ,08 ,0  ,0   ,"G","","mv_par01",""          ,""      ,""      ,""   ,""   ,""          ,""     ,""       ,""    ,""    ,""          ,""       ,""       ,""    ,""    ,""              ,""       ,""       ,""    ,""    ,""            ,""      ,""      ,""    ,""       ,"",""})
aAdd(aRegs,{cPerg,"02"   ,"Data ate  ?",""       ,""       ,"mv_ch2","D" ,08 ,0  ,0   ,"G","","mv_par02",""          ,""      ,""      ,""   ,""   ,""          ,""     ,""       ,""    ,""    ,""          ,""       ,""       ,""    ,""    ,""              ,""       ,""       ,""    ,""    ,""            ,""      ,""      ,""    ,""       ,"",""})
aAdd(aRegs,{cPerg,"03"   ,"Cartao de ?",""       ,""       ,"mv_ch3","C" ,06 ,0  ,0   ,"G","","mv_par03",""          ,""      ,""      ,""   ,""   ,""          ,""     ,""       ,""    ,""    ,""          ,""       ,""       ,""    ,""    ,""              ,""       ,""       ,""    ,""    ,""            ,""      ,""      ,""    ,"SZK001" ,"",""})
aAdd(aRegs,{cPerg,"04"   ,"Cartao ate?",""       ,""       ,"mv_ch4","C" ,06 ,0  ,0   ,"G","","mv_par04",""          ,""      ,""      ,""   ,""   ,""          ,""     ,""       ,""    ,""    ,""          ,""       ,""       ,""    ,""    ,""              ,""       ,""       ,""    ,""    ,""            ,""      ,""      ,""    ,"SZK001" ,"",""})
aAdd(aRegs,{cPerg,"05"   ,"Tipo      ?",""       ,""       ,"mv_ch5","C" ,01 ,0  ,0   ,"C","","mv_par05","Analitico" ,""      ,""      ,""   ,""   ,"Sintetico" ,""     ,""       ,""    ,""    ,""          ,""       ,""       ,""    ,""    ,""              ,""       ,""       ,""    ,""    ,""            ,""      ,""      ,""    ,""       ,"",""})
aAdd(aRegs,{cPerg,"06"   ,"Status    ?",""       ,""       ,"mv_ch6","C" ,02 ,0  ,0   ,"G","","mv_par06",""          ,""      ,""      ,""   ,""   ,""          ,""     ,""       ,""    ,""    ,""          ,""       ,""       ,""    ,""    ,""              ,""       ,""       ,""    ,""    ,""            ,""      ,""      ,""    ,"96"     ,"",""})
aAdd(aRegs,{cPerg,"07"   ,"Unidade   ?",""       ,""       ,"mv_ch7","C" ,15 ,0  ,0   ,"G","","mv_par07",""          ,""      ,""      ,""   ,""   ,""          ,""     ,""       ,""    ,""    ,""          ,""       ,""       ,""    ,""    ,""              ,""       ,""       ,""    ,""    ,""            ,""      ,""      ,""    ,""       ,"",""})  //PATRICIA FONTANEZI - 01/11/2012
aAdd(aRegs,{cPerg,"08"   ,"Do Lim Periodo?",""   ,""       ,"mv_ch8","N" ,14 ,2  ,0   ,"G","","mv_par08",""          ,""      ,""      ,""   ,""   ,""          ,""     ,""       ,""    ,""    ,""          ,""       ,""       ,""    ,""    ,""              ,""       ,""       ,""    ,""    ,""            ,""      ,""      ,""    ,""       ,"",""}) //PATRICIA FONTANEZI - 01/11/2012
aAdd(aRegs,{cPerg,"09"   ,"Ate Lim Periodo?",""  ,""       ,"mv_ch09","N" ,14 ,2  ,0   ,"G","","mv_par09",""         ,""      ,""      ,""   ,""   ,""          ,""     ,""       ,""    ,""    ,""          ,""       ,""       ,""    ,""    ,""              ,""       ,""       ,""    ,""    ,""            ,""      ,""      ,""    ,""       ,"",""}) //PATRICIA FONTANEZI - 01/11/2012
aAdd(aRegs,{cPerg,"10"   ,"Dt Recomp ?",""       ,""       ,"mv_ch10","D" ,08 ,0  ,0   ,"G","","mv_par10",""          ,""      ,""      ,""   ,""   ,""          ,""     ,""       ,""    ,""    ,""          ,""       ,""       ,""    ,""    ,""              ,""       ,""       ,""    ,""    ,""            ,""      ,""      ,""    ,""       ,"",""}) //PATRICIA FONTANEZI - 01/11/2012
For nX := 1 to Len(aRegs)
	If !SX1->(dbSeek(cPerg+aRegs[nX,2]))
		RecLock('SX1',.T.)
		For nY:=1 to FCount()
			If nY <= Len(aRegs[nX])
				SX1->(FieldPut(nY,aRegs[nX,nY]))
			Endif
		Next nY
		MsUnlock()
	Endif
Next nX

SX1->(dbSetOrder(nSX1Order))

Return