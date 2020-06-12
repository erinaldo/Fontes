#include "rwmake.ch"
#include "protheus.ch"
#include "TOPCONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINA58   ºAutor  ³Emerson Natali      º Data ³  23/03/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio Movimento Cartao Itau                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CFINA58()

//³ Declaracao de Variaveis
Local cDesc1 	:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2 	:= "de acordo com os parametros informados pelo usuario."
Local cDesc3 	:= "Movimentacao Cartao"
Local titulo 	:= OemToAnsi("Relatório Movimentação Cartão  -  Período")
Local nLin 		:= 80
//Local Cabec1 	:= "Data      Cartao  Nome Portador                        Entrada          Saida           Saldo"
Local Cabec1 	:= "Data      Cartao  Nome Portador                          Saida        Entrada           Saldo Prest.Contas"
Local Cabec2 	:= ""

Private lAbortPrint 	:= .F.
Private limite 			:= 132
Private tamanho 		:= "M"
Private nomeprog 		:= "CFINA58"
Private nTipo 			:= 18
Private aReturn 		:= { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey 		:= 0
Private m_pag 			:= 01
Private wnrel 			:= "CFINA58"
Private cString 		:= "SZK"

Private cPerg			:= "CFIN58"

dbSelectArea("SZK")
dbSetOrder(1)

_fCriaSx1()

//³ Monta a interface padrao com o usuario...
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

//³ Processamento. RPTSTATUS monta janela com a regua de processamento.

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  23/03/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

titulo += " " + DTOC(MV_PAR01) + " a " + DTOC(MV_PAR02)+ " "

If mv_par05 == 1 //analitico
	titulo += " (Analitico)"
Else
	titulo += " (Sintetico)"
EndIf

dbSelectArea(cString)
dbSetOrder(1)
SetRegua(RecCount())

cQuery := "SELECT ZK_FILIAL, ZK_NOME, ZK_E_LIMIT, ZK_E_SLDAT, ZK_E_SLDPR, ZK_NROCRT "
cQuery += "FROM "+RetSQLname('SZK')+" "
cQuery += "WHERE D_E_L_E_T_ = '' "
cQuery += "AND ZK_TIPO = '4' "
cQuery += "AND ZK_NROCRT BETWEEN '"+ALLTRIM(mv_par03)+"' AND '"+ALLTRIM(mv_par04)+"' "
TcQuery cQuery New Alias "SZKTMP"

dbSelectArea("SZKTMP")
dbGoTop()
While !EOF()

	//³ Verifica o cancelamento pelo usuario...

	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif

	//SAQUE
	cQuery := "SELECT SUM(E5_VALOR) AS SAQUE "
	cQuery += "FROM "+RetSQLname('SE5')+" "
	cQuery += "WHERE D_E_L_E_T_ = '' "
	cQuery += "AND E5_MOEDA = 'DE' "
	cQuery += "AND SUBSTRING(E5_CARTAO,1,6) = '"+SZKTMP->ZK_NROCRT+"'  "
	cQuery += "AND E5_RECPAG = 'P' "
	cQuery += "AND E5_DATA < '"+DTOS(mv_par01)+"' "
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
	cQuery += "AND E5_DATA < '"+DTOS(mv_par01)+"' "
	cQuery += "AND E5_NATUREZ = '2.21.08' "
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

	If mv_par05 == 1 //Analitico
		//SAQUES ANALITICO
		cQuery := "SELECT E5_DATA, E5_CARTAO, E5_VALOR, E5_RECPAG "
		cQuery += "FROM "+RetSQLname('SE5')+" "
		cQuery += "WHERE D_E_L_E_T_ = '' "
		cQuery += "AND SUBSTRING(E5_CARTAO,1,6) = '"+SZKTMP->ZK_NROCRT+"' "
		cQuery += "AND E5_RECPAG = 'P' "
		cQuery += "AND E5_MOEDA = 'DE' "
		cQuery += "AND E5_DATA BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' "
	Else
		//SAQUES SINTETICO
		cQuery := "SELECT E5_DATA, E5_CARTAO, SUM(E5_VALOR) AS E5_VALOR, E5_RECPAG "
		cQuery += "FROM "+RetSQLname('SE5')+" "
		cQuery += "WHERE D_E_L_E_T_ = '' "
		cQuery += "AND SUBSTRING(E5_CARTAO,1,6) = '"+SZKTMP->ZK_NROCRT+"' "
		cQuery += "AND E5_RECPAG = 'P' "
		cQuery += "AND E5_MOEDA = 'DE' "
		cQuery += "AND E5_DATA BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' "
		cQuery += "GROUP BY E5_DATA, E5_CARTAO, E5_RECPAG "
	EndIf

	//PRESTACAO DE CONTAS
	cQuery += "UNION ALL "
	cQuery += "SELECT E5_DATA, E5_CARTAO, E5_VALOR, E5_RECPAG "
	cQuery += "FROM "+RetSQLname('SE5')+" "
	cQuery += "WHERE D_E_L_E_T_ = '' "
	cQuery += "AND SUBSTRING(E5_CARTAO,1,6) = '"+SZKTMP->ZK_NROCRT+"' "
	cQuery += "AND E5_RECPAG = 'R' "
	cQuery += "AND E5_NATUREZ = '2.21.08' "
	cQuery += "AND E5_DATA BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' "
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
	Else
		//³ Impressao do cabecalho do relatorio. . .
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	EndIf

	@nLin,00 PSAY SUBSTR(SZKTMP->ZK_NOME,1,30)+ " --- LIMITE ---->"
	@nLin,48 PSAY SZKTMP->ZK_E_LIMIT picture "@E 999,999,999.99"
	nLin++
	nLin++

	@nLin,71 PSAY "Saldo Anterior " 
	@nLin,92 PSAY _nSldAnt picture "@E 999,999,999.99"	//SALDO ANTERIOR
	nLin++
	nLin++
	
	_nSldAtu 	:= _nSldAnt
	Do While !EOF()

		If nLin > 58
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
/*
         1         2         3         4         5         6         7         8         9         1         2         3
123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
Data     Cartao  Nome                               Entrada          Saida          Saldo
XX/XX/XX XXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXX 999,999,999.99 999,999,999.99 999,999,999.99
*/
		@nLin,00 PSAY SE5TRB->E5_DATA
		@nLin,10 PSAY SUBSTR(SE5TRB->E5_CARTAO,1,6)
		@nLin,18 PSAY SUBSTR(SZKTMP->ZK_NOME,1,30)
		If SE5TRB->E5_RECPAG == "P"
			@nLin,48 PSAY SE5TRB->E5_VALOR picture "@E 999,999,999.99"	//ENTRADA
		Else
			@nLin,63 PSAY SE5TRB->E5_VALOR picture "@E 999,999,999.99"	//SAIDA
		EndIf

		//SALDO
		If SE5TRB->E5_RECPAG == "P"
			_nSldAtu+=SE5TRB->E5_VALOR
		Else
			_nSldAtu-=SE5TRB->E5_VALOR
		EndIf

		@nLin,92 PSAY _nSldAtu picture "@E 999,999,999.99"	//ENTRADA
		
		nLin++
		DbSelectArea("SE5TRB")
		SE5TRB->(DbSkip())
	EndDo

	nLin++

	DbSelectArea("SE5TRB")
	SE5TRB->(DbCloseArea())

	DbSelectArea("SZKTMP")
	SZKTMP->(dbSkip())
EndDo

//³ Finaliza a execucao do relatorio...

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINA57   ºAutor  ³Microsiga           º Data ³  03/23/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function _fCriaSx1()

aRegs     := {}
nSX1Order := SX1->(IndexOrd())

SX1->(dbSetOrder(1))

cPerg := Left(cPerg,6)

/*
             grupo ,ordem ,pergunt      ,perg spa ,perg eng , variav ,tipo,tam,dec,pres,gsc,valid ,var01  ,def01       ,defspa01,defeng01,cnt01,var02,def02       ,defspa02,defeng02 ,cnt02 ,var03 ,def03  ,defspa03 ,defeng03 ,cnt03 ,var04 ,def04 ,defspa04 ,defeng04 ,cnt04 ,var05 ,def05 ,defspa05 ,defeng05,cnt05 ,f3 ,"","","",""
*/
aAdd(aRegs,{cPerg,"01"   ,"Data de   ?",""       ,""       ,"mv_ch1","D" ,08 ,0  ,0   ,"G","","mv_par01",""          ,""      ,""      ,""   ,""   ,""          ,""     ,""       ,""    ,""    ,""    ,""       ,""       ,""    ,""    ,""    ,""       ,""       ,""    ,""    ,""    ,""      ,""      ,""    ,"" ,"",""})
aAdd(aRegs,{cPerg,"02"   ,"Data ate  ?",""       ,""       ,"mv_ch2","D" ,08 ,0  ,0   ,"G","","mv_par02",""          ,""      ,""      ,""   ,""   ,""          ,""     ,""       ,""    ,""    ,""    ,""       ,""       ,""    ,""    ,""    ,""       ,""       ,""    ,""    ,""    ,""      ,""      ,""    ,"" ,"",""})
aAdd(aRegs,{cPerg,"03"   ,"Cartao de ?",""       ,""       ,"mv_ch3","C" ,06 ,0  ,0   ,"G","","mv_par03",""          ,""      ,""      ,""   ,""   ,""          ,""     ,""       ,""    ,""    ,""    ,""       ,""       ,""    ,""    ,""    ,""       ,""       ,""    ,""    ,""    ,""      ,""      ,""    ,"" ,"",""})
aAdd(aRegs,{cPerg,"04"   ,"Cartao ate?",""       ,""       ,"mv_ch4","C" ,06 ,0  ,0   ,"G","","mv_par04",""          ,""      ,""      ,""   ,""   ,""          ,""     ,""       ,""    ,""    ,""    ,""       ,""       ,""    ,""    ,""    ,""       ,""       ,""    ,""    ,""    ,""      ,""      ,""    ,"" ,"",""})
aAdd(aRegs,{cPerg,"05"   ,"Tipo      ?",""       ,""       ,"mv_ch5","C" ,01 ,0  ,0   ,"C","","mv_par05","Analitico" ,""      ,""      ,""   ,""   ,"Sintetico" ,""     ,""       ,""    ,""    ,""    ,""       ,""       ,""    ,""    ,""    ,""       ,""       ,""    ,""    ,""    ,""      ,""      ,""    ,"" ,"",""})

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