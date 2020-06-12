#INCLUDE "rwmake.ch"
#Include "TopConn.ch"
//#include "_FixSX.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CFINR004 º Autor ³ AP6 IDE            º Data ³  06/05/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Demonstrativo Mensal de Contas de Consumo                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Relatorio Especifico CIEE / Depto Financeiro               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CFINR004()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cDesc1 := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2 := "sobre Contas de Consumo"
Private cDesc3 := "de acordo com os parametros informados pelo usuario."

Private titulo := "Demonstrativo Mensal de Contas de Consumo"
Private nLin   := 60

Private Cabec1 := "Data     | Prestadora      | Documento  | Telefone  | Mes Ref.        |              Valor  | Baixa    | Sem Conta | Unidade                   | CR  | DM     |"
Private Cabec2 := ""
****           := "dd/mm/aa | ppppppppppppppp | dddddddddd | tttt-tttt | mmmmmmmmmmmmmmm | 999,999,999,999.99  | dd/mm/aa |    SIM    | uuuuuuuuuuuuuuuuuuuuuuuuu | ccc | ffffff |"
****           := "0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789"
****           := "0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21         "
****           := "0          11                29           42          54                72                    94            108      117                         145   151
****           := "0        09                27           40          52                70                    92         103         115                         143   149     158
Private imprime      := .T.
Private aOrd         := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := StrTran(FunName(), "#", "")
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FINR04" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString      := "SZ5"
Private cPerg        := "FINR04"
Private _nFL         := 0
Private _aConCon := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01 - Data de                                     ³
//³ mv_par02 - Data de ate                                 ³
//³ mv_par03 - Prestadora de                               ³
//³ mv_par04 - Prestadora ate                              ³
//³ mv_par05 - Unidade de                                  ³
//³ mv_par06 - Unidade ate                                 ³
//³ mv_par07 - Referencia de                               ³
//³ mv_par08 - Referencia ate                              ³
//³ mv_par09 - Baixa de                                    ³
//³ mv_par10 - Baixa ate                                   ³
//³ mv_par11 - Grupo de                                    ³
//³ mv_par12 - Grupo ate                                   ³
//³ mv_par13 - SP/Outros/Todos                             ³
//³ mv_par14 - Status                                      ³
//³ mv_par15 - D M                                         ³
//³ mv_par16 - Gera DM                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nSX1Order := SX1->(IndexOrd())
SX1->(dbSetOrder(1))

_aPerg := {}
AADD(_aPerg,{cPerg,"01","Data Lanca. de     ?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"02","Data Lanca. ate    ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"03","Prestadora de      ?","","","mv_ch3","C",15,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","BZ7","",""})
AADD(_aPerg,{cPerg,"04","Prestadora ate     ?","","","mv_ch4","C",15,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","BZ7","",""})
AADD(_aPerg,{cPerg,"05","Unidade de         ?","","","mv_ch5","C",15,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","BZU","",""})
AADD(_aPerg,{cPerg,"06","Unidade ate        ?","","","mv_ch6","C",15,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","BZU","",""})
AADD(_aPerg,{cPerg,"07","Referencia de      ?","","","mv_ch7","C",15,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"08","Referencia ate     ?","","","mv_ch8","C",15,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"09","Baixa de           ?","","","mv_ch9","D",08,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"10","Baixa ate          ?","","","mv_cha","D",08,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"11","Grupo de           ?","","","mv_chb","C",01,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"12","Grupo ate          ?","","","mv_chc","C",01,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"13","SP/Outros/Todos    ?","","","mv_chd","N",01,0,0,"C","","mv_par13","SP","","","","","Outros","","","","","Todos","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"14","Status             ?","","","mv_che","N",01,0,0,"C","","mv_par14","Baixado+Sem Conta","","","","","Baixado","","","","","Aberto","","","","","Sem Conta","","","","","Todos","","","","","",""})
AADD(_aPerg,{cPerg,"15","DM                 ?","","","mv_chf","C",06,0,0,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"16","Grava DM           ?","","","mv_chg","N",01,0,0,"C","","mv_par16","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","",""})

//AjustaSX1(_aPerg)

For nX := 1 to Len(_aPerg)
	If !SX1->(dbSeek(cPerg+_aPerg[nX,2]))
		RecLock('SX1',.T.)
		For nY:=1 to FCount()
			If nY <= Len(_aPerg[nX])
				SX1->(FieldPut(nY,_aPerg[nX,nY]))
			Endif
		Next nY
		MsUnlock()
	Endif
Next nX

SX1->(dbSetOrder(nSX1Order))

// Atualiza o campo data de referencia (mv_par03)
// para a daba base do sistema (dDataBase).

Pergunte(cPerg, .F.)

//wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.T.)
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)
_nFL  := VAL(mv_par15)

dbSelectArea("SZ5")
DbSetOrder(2)
If dbSeek(xFilial("SZ5")+mv_par15, .F.) .And. mv_par16==1 .And. !Empty(mv_par15)
	MsgAlert("Demonstrativo Mensal: "+mv_par15+" já Contabilizado... ", OemToAnsi("Atenção"))
	Return
EndIf
DbSetOrder(1)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  06/05/03   º±±
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

_nFaz         := 1
_lTodos       := .T.
_lSo_SP       := .F.
_lSo_Outros   := .F.
_nDevedora    := 0
_nCredora     := 0
_nFL          := VAL(mv_par15)

If Subs(mv_par05,1,9)>"SAO PAULO" .Or. Subs(mv_par06,1,9)<"SAO PAULO"
	_lSo_SP:=.F.
EndIf

If Subs(mv_par05,1,9)=="SAO PAULO" .And. Subs(mv_par06,1,9)=="SAO PAULO"
	_lSo_SP   :=.T.
EndIf

If mv_par13==1
	_lSo_SP       :=.T.
	_lSo_Outros   :=.F.
	_lTodos       :=.F.
ElseIf mv_par13==2
	_lSo_SP       :=.F.
	_lSo_Outros   :=.T.
	_lTodos       :=.F.
ElseIf mv_par13==3
	_lTodos       :=.T.
EndIf

If _lSo_SP .Or. _lTodos
	
	_nFaz      := 2
	_xFilSZ5:=xFilial("SZ5")
	_xFilSZ7:=xFilial("SZ7")
	
	//	_cOrdem := " Z5_FILIAL, Z5_LANC, Z7_GRUPO, Z5_PRESTA, Z5_UNIDADE, Z5_DOC"
	_cOrdem := " Z5_FILIAL,Z5_BANCO,Z5_AGENCIA,Z5_CCONTA, Z7_GRUPO, Z5_PRESTA, Z5_UNIDADE, Z5_LANC, Z5_DOC"
	_cQuery := " SELECT Z5_LANC, Z5_DOC, Z7_GRUPO, Z5_PRESTA, Z5_TEL, Z5_MES, Z5_VALOR, Z5_BAIXA, Z5_CONTA ,Z5_UNIDADE,"
	_cQuery += " Z5_BANCO ,Z5_AGENCIA ,Z5_CCONTA,Z5_CR, Z5_FL, Z5_FECHA"
	_cQuery += " FROM "
	_cQuery += RetSqlName("SZ5")+" SZ5,"
	_cQuery += RetSqlName("SZ7")+" SZ7"
	_cQuery += " WHERE '"+ _xFilSZ5 +"' = Z5_FILIAL"
	_cQuery += " AND   '"+ _xFilSZ7 +"' = Z7_FILIAL"
	_cQuery += " AND    Z5_PRESTA   = Z7_PRESTA"
	_cQuery += " AND    Z5_UNIDADE  = 'SAO PAULO      '"
	_cQuery += " AND    Z5_LANC    >= '"+DTOS(mv_par01)+"'"
	_cQuery += " AND    Z5_LANC    <= '"+DTOS(mv_par02)+"'"
	_cQuery += " AND    Z5_PRESTA  >= '"+mv_par03+"'"
	_cQuery += " AND    Z5_PRESTA  <= '"+mv_par04+"'"
	_cQuery += " AND    Z5_UNIDADE >= '"+mv_par05+"'"
	_cQuery += " AND    Z5_UNIDADE <= '"+mv_par06+"'"
	_cQuery += " AND    Z5_MES     >= '"+mv_par07+"'"
	_cQuery += " AND    Z5_MES     <= '"+mv_par08+"'"
	_cQuery += " AND    Z5_BAIXA   >= '"+DTOS(mv_par09)+"'"
	_cQuery += " AND    Z5_BAIXA   <= '"+DTOS(mv_par10)+"'"
	_cQuery += " AND    Z7_GRUPO   >= '"+mv_par11+"'"
	_cQuery += " AND    Z7_GRUPO   <= '"+mv_par12+"'"
	
	If mv_par14 == 1
		_cQuery += " AND (Z5_BAIXA <> '' OR Z5_CONTA = 'S')"
	elseIf mv_par14 == 2
		_cQuery += " AND  Z5_BAIXA <> '' "
	ElseIf mv_par14 == 3
		_cQuery += " AND  Z5_BAIXA  = '' "
	ElseIf mv_par14 == 4
		_cQuery += " AND  Z5_CONTA = 'S' "
	EndIf
	
	_cQuery += " AND  Z5_FL =  '' "
	
	If !Empty(aReturn[7])
		_cQuery += U_TransQuery(aReturn[7])
	EndIf
	
	U_EndQuery( @_cQuery,_cOrdem, "QUERY", {"SZ5","SZ7" },,,.T. )
	dbSelectArea("QUERY")
	dbGoTop()
	
	U_IMP_QUERY()
	
EndIf

If _lTodos .Or. _lSo_Outros
	_xFilSZ5:=xFilial("SZ5")
	_xFilSZ7:=xFilial("SZ7")
	
	//	_cOrdem := " Z5_FILIAL, Z5_LANC, Z7_GRUPO, Z5_PRESTA, Z5_UNIDADE, Z5_DOC"
	_cOrdem := " Z5_FILIAL,Z5_BANCO,Z5_AGENCIA,Z5_CCONTA,Z7_GRUPO, Z5_PRESTA, Z5_UNIDADE, Z5_LANC, Z5_DOC"
	
	_cQuery := " SELECT Z5_LANC, Z5_DOC, Z7_GRUPO, Z5_PRESTA, Z5_TEL, Z5_MES, Z5_VALOR, Z5_BAIXA, Z5_UNIDADE, Z5_CONTA, "
	_cQuery += " Z5_BANCO,Z5_AGENCIA ,Z5_CCONTA, Z5_CR, Z5_FL, Z5_FECHA"
	_cQuery += " FROM "
	_cQuery += RetSqlName("SZ5")+" SZ5,"
	_cQuery += RetSqlName("SZ7")+" SZ7"
	_cQuery += " WHERE '"+ _xFilSZ5 +"' = Z5_FILIAL"
	_cQuery += " AND   '"+ _xFilSZ7 +"' = Z7_FILIAL"
	_cQuery += " AND    Z5_PRESTA   = Z7_PRESTA"
	_cQuery += " AND    Z5_UNIDADE <> 'SAO PAULO      '"
	_cQuery += " AND    Z5_LANC    >= '"+DTOS(mv_par01)+"'"
	_cQuery += " AND    Z5_LANC    <= '"+DTOS(mv_par02)+"'"
	_cQuery += " AND    Z5_PRESTA  >= '"+mv_par03+"'"
	_cQuery += " AND    Z5_PRESTA  <= '"+mv_par04+"'"
	_cQuery += " AND    Z5_UNIDADE >= '"+mv_par05+"'"
	_cQuery += " AND    Z5_UNIDADE <= '"+mv_par06+"'"
	_cQuery += " AND    Z5_MES     >= '"+mv_par07+"'"
	_cQuery += " AND    Z5_MES     <= '"+mv_par08+"'"
	_cQuery += " AND    Z5_BAIXA   >= '"+DTOS(mv_par09)+"'"
	_cQuery += " AND    Z5_BAIXA   <= '"+DTOS(mv_par10)+"'"
	_cQuery += " AND    Z7_GRUPO   >= '"+mv_par11+"'"
	_cQuery += " AND    Z7_GRUPO   <= '"+mv_par12+"'"
	
	If mv_par14 == 1
		_cQuery += " AND (Z5_BAIXA <> '' OR Z5_CONTA = 'S')"
	elseIf mv_par14 == 2
		_cQuery += " AND  Z5_BAIXA <> '' "
	ElseIf mv_par14 == 3
		_cQuery += " AND  Z5_BAIXA  = '' "
	ElseIf mv_par14 == 4
		_cQuery += " AND  Z5_CONTA = 'S' "
	EndIf
	
	_cQuery += " AND  Z5_FL =  '' "
	
	If !Empty(aReturn[7])
		_cQuery += U_TransQuery(aReturn[7])
	EndIf
	
	U_EndQuery( @_cQuery,_cOrdem, "QUERY", {"SZ5","SZ7" },,,.T. )
	
	dbSelectArea("QUERY")
	dbGoTop()
	
	U_IMP_QUERY()
	IF MV_PAR16 == 1
		GRVPRELAN(_aConCon) // Grava Lancamentos contabeis
	ENDIF
	
EndIf

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
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Imp_Query ³ Autor ³      Andy             ³ Data ³08/05/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³CIEE                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION IMP_QUERY()

Local _cBanco   
Local _cAgencia 
Local _cConBco  
Local _cGrupo   
Local _cPresta  

_nDevedora := 0
_nTotal    := 0
_nTotalAux := 0
nLin       := 60
//_aConCon   := {}
_cDeved   := SPACE(10)
_cCred    := SPACE(10)
_cContaD  := " "
_cContaC  := " "

While !EOF()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	_cBanco   := QUERY->Z5_BANCO
	_cAgencia := QUERY->Z5_AGENCIA
	_cConBco  := QUERY->Z5_CCONTA
	_cGrupo   := QUERY->Z7_GRUPO
	_cPresta  := QUERY->Z5_PRESTA
	SA6->(DbSeek(xFilial("SA6")+QUERY->Z5_BANCO+QUERY->Z5_AGENCIA+QUERY->Z5_CCONTA))
	_cContaC := ALLTRIM(SA6->A6_CONTABI)
	While !EOF().And. (QUERY->Z5_BANCO == _cBanco) .And. (QUERY->Z5_AGENCIA == _cAgencia);
		.And. (QUERY->Z5_CCONTA == _cConBco) .And.  (_cGrupo == QUERY->Z7_GRUPO)
		
		_cUnidade := QUERY->Z5_UNIDADE
		_cCR      := QUERY->Z5_CR
		
		While !EOF() .And. (QUERY->Z5_BANCO == _cBanco) .And. (QUERY->Z5_AGENCIA == _cAgencia);
			.And. (QUERY->Z5_CCONTA == _cConBco) .And.  (_cGrupo == QUERY->Z7_GRUPO);
			.And. _cUnidade == QUERY->Z5_UNIDADE
			
			If mv_par16 == 1
				dbSelectArea("SZ5")
				DbSetOrder(1)
				If dbSeek(xFilial("SZ5")+QUERY->(DTOS(Z5_LANC)+Z5_PRESTA+Z5_UNIDADE+Z5_DOC), .F.)
					If Empty(SZ5->Z5_FL) .Or. _nFL==0
						RecLock("SZ5",.F.)
						SZ5->Z5_FL:=IF(_nFL==0,SPACE(6),STRZERO(_nFL,6))
						msUnLock()
					EndIf
				EndIf
			EndIf
			_cFicha:=IF(_nFL==0,SPACE(6),STRZERO(_nFL,6))
			If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif
			
			@ nLin, 000 PSay QUERY->Z5_LANC
			@ nLin, 009 PSay "|"
			@ nLin, 011 PSay QUERY->Z5_PRESTA
			@ nLin, 027 PSay "|"
			@ nLin, 029 PSay QUERY->Z5_DOC
			@ nLin, 040 PSay "|"
			@ nLin, 042 PSay QUERY->Z5_TEL
			@ nLin, 052 PSay "|"
			@ nLin, 054 PSay QUERY->Z5_MES
			@ nLin, 070 PSay "|"
			@ nLin, 072 PSay QUERY->Z5_VALOR  Picture "@E 999,999,999,999.99"
			@ nLin, 092 PSay "|"
			@ nLin, 094 PSay QUERY->Z5_BAIXA
			@ nLin, 103 PSay "|"
			@ nLin, 108 PSay IF(QUERY->Z5_CONTA=="N","Nao","Sim")
			@ nLin, 115 PSay "|"
			@ nLin, 117 PSay QUERY->Z5_UNIDADE
			@ nLin, 143 PSay "|"
			@ nLin, 145 PSay QUERY->Z5_CR
			@ nLin, 149 PSay "|"
			@ nLin, 151 PSay _cFicha
			@ nLin, 158 PSay "|"
			
			_nTotal    += QUERY->Z5_VALOR
			_nTotalAux += QUERY->Z5_VALOR
			
			nLin ++
			dbSelectArea("QUERY")
			dbSkip()
		EndDo
		
		If AllTrim(_cUnidade)<>"SAO PAULO"
			Do Case
				Case _cGrupo == "C"
					_cContaD   :="    31808"
				Case  _cGrupo == "D"
					_cContaD   :="    31803"
				Case  _cGrupo == "E"
					_cContaD   :="    31806"
				Case  _cGrupo == "F"
					_cContaD   :="    31801"					
				OtherWise
					_cContaD   :="    31805"
			EndCase
			
			@ nLin, 009 PSay "|"
			@ nLin, 027 PSay "|"
			@ nLin, 040 PSay "|"
			@ nLin, 052 PSay "|"
			@ nLin, 070 PSay "|"
			@ nLin, 092 PSay "|"
			@ nLin, 103 PSay "|"
			@ nLin, 115 PSay "|"
			@ nLin, 143 PSay "|"
			@ nLin, 149 PSay "|"
			@ nLin, 158 PSay "|"
			
			nLin ++
			
			@ nLin, 009 PSay "|"
			@ nLin, 011 PSay _cContaD+" "+_cCR
			@ nLin, 027 PSay "|"
			@ nLin, 040 PSay "|"
			@ nLin, 052 PSay "|"
			@ nLin, 070 PSay "|"
			@ nLin, 072 PSay _nTotalAux  Picture "@E 999,999,999,999.99"  
			@ nLin, 092 PSay "|"
			@ nLin, 103 PSay "|"
			@ nLin, 115 PSay "|"
			@ nLin, 143 PSay "|"
			@ nLin, 149 PSay "|"
			@ nLin, 158 PSay "|"
			
			_nDevedora:=_nDevedora+Val(Alltrim(_cContaD)+_cCR)
			_cDeved := Alltrim(_cContaD)
			aadd(_aConCon,{_cDeved," ",_nTotalAux,_cFicha,_cUnidade,_cCR,MV_PAR02,"DM "+_cFicha})
			_nTotalAux:=0
			
			nLin ++
			@ nLin, 009 PSay "|"
			@ nLin, 027 PSay "|"
			@ nLin, 040 PSay "|"
			@ nLin, 052 PSay "|"
			@ nLin, 070 PSay "|"
			@ nLin, 092 PSay "|"
			@ nLin, 103 PSay "|"
			@ nLin, 115 PSay "|"
			@ nLin, 143 PSay "|"
			@ nLin, 149 PSay "|"
			@ nLin, 158 PSay "|"
			
			nLin ++
			
		EndIf
	EndDo
	
	@ nLin, 009 PSay "|"
	@ nLin, 027 PSay "|"
	@ nLin, 040 PSay "|"
	@ nLin, 052 PSay "|"
	@ nLin, 070 PSay "|"
	@ nLin, 092 PSay "|"
	@ nLin, 103 PSay "|"
	@ nLin, 115 PSay "|"
	@ nLin, 143 PSay "|"
	@ nLin, 149 PSay "|"
	@ nLin, 158 PSay "|"
	
	nLin ++
	
	If	_nDevedora == 0  // SAO PAULO
		@ nLin, 000 PSay "Devedora"
		@ nLin, 009 PSay "|"
		If AllTrim( _cPresta)=="SABESP"
			@ nLin, 011 PSay "    31801 914"
			_cDeved := "31801"
			_cCR := "914"
		ElseIf AllTrim( _cPresta)=="ELETROPAULO"
			@ nLin, 011 PSay "    31803 914"
			_cDeved := "31803"
			_cCR := "914"
		ElseIf AllTrim( _cPresta)=="COMGAS"
			@ nLin, 011 PSay "    31806 914"
			_cDeved := "31806"
			_cCR := "914"
		Else
			@ nLin, 011 PSay "       212111"
			_nDevedora:=_nDevedora+Val("212111")
			_cDeved := "212111"
		EndIf
		
		@ nLin, 027 PSay "|"
		@ nLin, 029 PSay "Credora"
		@ nLin, 040 PSay "|"
		@ nLin, 043 PSay Alltrim(_cContaC)
		@ nLin, 052 PSay "|"
		@ nLin, 054 PSay "TOTAL  "
		@ nLin, 070 PSay "|"
		@ nLin, 072 PSay _nTotal Picture "@E 999,999,999,999.99" 
		@ nLin, 092 PSay "|"
		@ nLin, 103 PSay "|"
		@ nLin, 115 PSay "|"
		@ nLin, 143 PSay "|"
		@ nLin, 149 PSay "|"
		@ nLin, 158 PSay "|"
		_cCred := Alltrim(_cContaC)
		aadd(_aConCon,{_cDeved,_cCred,_nTotal,_cFicha,_cUnidade,_cCR,MV_PAR02,"DM "})
	Else
		@ nLin, 000 PSay "Devedora"
		@ nLin, 009 PSay "|"
		@ nLin, 013 PSay _nDevedora Picture "99999999999" 
		@ nLin, 027 PSay "|"
		@ nLin, 029 PSay "Credora"
		@ nLin, 040 PSay "|"
		@ nLin, 043 PSay Alltrim(_cContaC)
		@ nLin, 052 PSay "|"
		@ nLin, 054 PSay "TOTAL"
		@ nLin, 070 PSay "|"
		@ nLin, 072 PSay _nTotal Picture "@E 999,999,999,999.99"  
		@ nLin, 092 PSay "|"
		@ nLin, 103 PSay "|"
		@ nLin, 115 PSay "|"
		@ nLin, 143 PSay "|"
		@ nLin, 149 PSay "|"
		@ nLin, 158 PSay "|"
		_cCred := Alltrim(_cContaC)
		_cDeved := ""
		aadd(_aConCon,{" ",_cCred,_nTotal,_cFicha,_cUnidade," "," ","DM "})
	EndIf
	_nDevedora:=0
	_nTotal   := 0
	nLin      := 60
	If _nFL==0
		_nFL:=0
	Else
		_nFL+=1
	EndIf
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("QUERY")
dbCloseArea()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ EndQuery ³ Autor ³      MMN - 0990       ³ Data ³05/12/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Termina Query com Padrao do TOP 		               		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±

±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION EndQuery( cQuery, cOrderBy, cAlias, aAlias, cGroupBy, cHaving, lRecCount, cWhere )

LOCAL nI         := 0
LOCAL nLen       := 0
LOCAL aStru      := {}
LOCAL aDBFStru   := {}
LOCAL cAliasStru := ""
LOCAL nPosAlias  := 0
LOCAL nPosField  := 0
Local cQCount    := ''
Local _RecCount  := 0

If Empty( aAlias )
	aAlias := { cAlias }
EndIf

For nI := 1 To Len( aAlias )
    DbSelectArea(aAlias[nI])
	cQuery += ' AND '+aAlias[nI]+".D_E_L_E_T_ <> '*'"
	If Select( aAlias[nI] ) > 0
		Aadd( aDbfStru, (aAlias[nI])->(DbStruct()) )
	EndIf
Next

cQuery := StrTran( cQuery, "AND AND", "AND " )
cQuery := StrTran( cQuery, "AND  AND", "AND " )
cQuery := StrTran( cQuery, ".AND.", "AND " )
cQuery := StrTran( cQuery, ".OR.", "OR " )
If 'ORACLE' $ TcGetDb()
	If !Empty(cQuery)
		cQuery   := StrTran( cQuery,   "SUBSTRING", "SUBSTR" )
		cQuery   := StrTran( cQuery,   "ISNULL", "NVL")
	EndIf
	If !Empty(cGroupBy)
		cGroupBy := StrTran( cGroupBy, "SUBSTRING", "SUBSTR" )
		cGroupBy := StrTran( cGroupBy, "ISNULL", "NVL")
	EndIf
	If !Empty(cHaving)
		cHaving  := StrTran( cHaving,  "SUBSTRING", "SUBSTR" )
		cHaving  := StrTran( cHaving,  "ISNULL", "NVL")
	EndIf
EndIf

If !Empty( cGroupBy )
	cQuery += ' GROUP BY '+cGroupBy
EndIf

If !Empty( cHaving )
	cQuery += ' HAVING '+cHaving
EndIf

IF ! Empty( cOrderBy )
	IF ( nPos := AT( " DESC", Upper( cOrderBy ) ) ) > 0
		cQuery += ' ORDER BY '+SqlOrder( LEFT( cOrderBy, nPos ) ) + " DESC"
	ELSE
		cQuery += ' ORDER BY '+SqlOrder( cOrderBy )
	ENDIF
ENDIF

If Select( cAlias ) > 0
	DbCloseArea()
EndIf

IF lRecCount .AND. 'ORACLE' $ TcGetDb() //Somente foi testado em SQL Server ...
	cQCount := 'SELECT COUNT(*) AS RECCOUNT FROM '
	For nI := 1 To Len( aAlias )
		cQCount += RetSqlName(aAlias[nI])+" "+aAlias[nI]
		If nI <> Len( aAlias )
			cQCount += ","
		EndIf
		
	Next
	cWhere := StrTran( cWhere, "AND AND", "AND " )
	cWhere := StrTran( cWhere, "AND  AND", "AND " )
	cWhere := StrTran( cWhere, ".AND.", "AND " )
	cWhere := StrTran( cWhere, ".OR.", "OR " )
	cQCount += cWhere
	If !Empty( cGroupBy )
		cQCount += ' GROUP BY '+cGroupBy
	EndIf
	
	If !Empty( cHaving )
		cQCount += ' HAVING '+cHaving
	EndIf
	
	TCQUERY cQCount NEW ALIAS "_Cont"
	_RecCount := _Cont->RecCount
	dbCloseArea("_Cont")
ENDIF

cQuery := ChangeQuery(cQuery)
MEMOWRIT( FunName(1)+".SQL", cQuery )

TCQUERY cQuery NEW ALIAS (cAlias)

IF lRecCount  .AND. !'ORACLE' $ TcGetDb() //Somente foi testado em SQL Server ...
	U_V_RECCOUNT( Padr( cAlias, 10 ) , Val( Substr( SX5->X5_DESCRI, 12, 7 ) ) )
ENDIF

aStru  := DbStruct()
nLen   := Len( aStru )

For nI := 1 To nLen
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Pesquisa nome do Alias a partir da estrutura da Query                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAliasStru := Right( "S"+Left( aStru[nI,1], At( "_", aStru[nI,1] ) - 1 ), 3 )
	If Len( cAliasStru ) < 3
		Loop
	EndIf
	
	nPosAlias  := Ascan( aAlias, cAliasStru )
	IF nPosAlias = 0
		LOOP
	ENDIF
	
	nPosField  := Ascan( aDbfStru[nPosAlias], { | e | e[1] == aStru[nI,1] } )
	IF nPosField = 0
		LOOP
	ENDIF
	If aDbfStru[nPosAlias,nPosField,2] != "C"
		TcSetField( cAlias,aDbfStru[nPosAlias,nPosField,1], aDbfStru[nPosAlias,nPosField,2], ;
		aDbfStru[nPosAlias,nPosField,3], aDbfStru[nPosAlias,nPosField,4] )
	EndIf
Next nI

Return _RecCount

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³TransQuery³ Autor ³ 		MMN - 0990       ³ Data ³05/12/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Traduz Query do Padrao Xbase para SQL                		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³VIDEOLAR                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION TransQuery( cOldQuery )

Local cNewQuery := ""

If Empty( cOldQuery )
	Return ""
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quando traduz a Query Completa nao adiciona o AND                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

MEMOWRIT( FunName(1)+".QRY", cOldQuery )

cNewQuery := AllTrim( Upper( cOldQuery ) )
cNewQuery := U_InSql( cNewQuery )
cNewQuery := StrTran( cNewQuery , ".AND."   , " AND " )
cNewQuery := StrTran( cNewQuery , ".OR."    , " OR "  )
cNewQuery := StrTran( cNewQuery , "SUBSTR(" , "SUBSTRING("  )
cNewQuery := StrTran( cNewQuery , "SUBST("  , "SUBSTRING("  )
cNewQuery := StrTran( cNewQuery , "SUBS("   , "SUBSTRING("  )
cNewQuery := StrTran( cNewQuery , "=="      , " = "         )
cNewQuery := StrTran( cNewQuery , "!="      , " <> "        )
cNewQuery := StrTran( cNewQuery , "!("      , " NOT ("      )
cNewQuery := StrTran( cNewQuery , "! ("     , " NOT ("      )
cNewQuery := StrTran( cNewQuery , "!"       , " NOT "       )
cNewQuery := StrTran( cNewQuery , ".NOT."   , " ! "         )
cNewQuery := StrTran( cNewQuery , "ALLTRIM(", "RTRIM("  	)
cNewQuery := StrTran( cNewQuery , "->"      , "."           )
cNewQuery := StrTran( cNewQuery , "#"       , "<>"          )
cNewQuery := U_RemoveFunc( cNewQuery, "DTOS(" )
cNewQuery := U_RemoveFunc( cNewQuery, "!EMPTY(" , " <> ' ' " )
cNewQuery := U_RemoveFunc( cNewQuery, "! EMPTY(", " <> ' ' " )
cNewQuery := U_RemoveFunc( cNewQuery, "EMPTY("  , " = ' ' "  )

If ! ("SELECT" $ cNewQuery)
	cNewQuery := " AND ( "+cNewQuery + " )"
EndIf

Return (  cNewQuery+" " )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FoundTab  ³ Autor ³ 		MMN - 0990	    ³ Data ³ 8/4/1999 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Retorna True ou False se a Tabela/Chave existe no SX5		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³VIDEOLAR										              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION FoundTab( cTable, cKey )

LOCAL nSx5Order := SX5->( IndexOrd() )
LOCAL lFound	:= .F.

SX5->( DbSetOrder( 1 ) )
lFound := SX5->( DbSeek( xFilial() + cTable + cKey ) )
SX5->( DbSetOrder( nSX5Order ) )

Return( lFound )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³V_RecCount³ Autor ³ 		MMN - 0990      ³ Data ³ 05.02.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna o Numero de Registros afetados por uma Query       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function V_RecCount( cAlias, nRecCount )

Local cLastAlias := SPACE( 10 ), nLastRecCount := 0

IF ValType( cAlias ) = "C"
	cLastAlias := cAlias
ENDIF

IF ValType( nRecCount ) = "N"
	nLastRecCount := nRecCount
ENDIF

RETURN( IF( RecCount() == 1 .AND. cLastAlias == PADR( ALIAS(), 10 ), nLastRecCount, RecCount() ) )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ InSql    ³ Autor ³ 		MMN - 0990       ³ Data ³05/12/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Troca '$' por 'IN ( cPesq1, cPesq2 )'                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³VIDEOLAR                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION InSql( cString )

LOCAL nPosAnd, nPosOr, nI, cStr := "", nJ, nK
LOCAL cSeparator := "/;,-.*"
LOCAL lSeparator := .F.
LOCAL aString    := {}, cAux := "", cAux1 := "", cFim := "", cSep := ""

Private cVar

If "$" $ cString
	Do While .T.
		nPosAnd  := At( ".AND.",cString)
		nPosOr   := At( ".OR.",cString)
		
		If nPosAnd == 0 .And. nPosOr == 0
			Aadd( aString, cString )
			Exit
		EndIf
		
		If ( nPosAnd < nPosOr .AND.  nPosAnd != 0 ) .OR. nPosOr == 0
			Aadd( aString, Left( cString, nPosAnd+4 ) )
			cString := Substr( cString, nPosAnd+5 )
		Else
			Aadd( aString, Left( cString, nPosOr+3 ) )
			cString := Substr( cString, nPosOr+4 )
		EndIf
	EndDo
	
	If Empty( aString )
		Aadd( aString, cString )
	EndIf
	
	For nI  := 1 To Len( aString )
		cStr := aString[nI]
		nPos := AT( "$", cStr )
		If nPos = 0
			Loop
		Else
			cVar := Left( cStr, nPos - 1 )
			IF ( nJ := Rat( "(", cVar ) ) <> 0
				cVar := Subst( cVar, nJ + 1 )
			ENDIF
			cAux := cVar
			nLen := Len( IF( Type( "&cVar" )== "U", Space(01), &cVar. ) )
			cStr := StrTran( cStr, "$", " IN ( " )
			nPos += 5
		Endif
		
		For nJ := nPos TO Len( cStr )
			cSep := Substr( cStr, nJ, 1 )
			IF cSep == "'" .Or. cSep == '"'
				cAux := LEFT( cStr, nJ - 1 )
				cStr := Substr( cStr, nJ )
				nPos := At( Substr( cStr, 1,1 ), Substr( cStr, 2 ) )
				cFim := Substr( cStr, nPos + 2 )
				cStr := Left( cStr, nPos + 1 )
				Exit
			EndIf
		Next
		
		lSeparator := .F.
		
		For nJ := 1 To Len( cSeparator )
			If Substr( cSeparator, nJ, 1) $ cStr
				cStr := StrTran( cStr, Substr( cSeparator, nJ, 1), cSep+','+cSep )
				lSeparator := .T.
				cStr += " ) "
				Exit
			Endif
		Next
		
		If cStr == "''" .Or. cStr == '""'
			cStr += " )"
		ElseIf !lSeparator
			cAux1 := ""
			FOR nJ := 2 TO Len( cStr )
				cAux1+= '"' + Subst( cStr, nJ, nLen ) + '", '
				IF Len( Subst( cStr, nJ ) ) <= nLen
					EXIT
				ENDIF
			NEXT nJ
			cAux1 := Left( cAux1, Len( cAux1 ) - 3 )
			cStr  := cAux1 + '" ) '
		EndIf
		aString[nI] := cAux + cStr + cFim
	Next
	
	cString := ""
	
	Aeval( aString, { | e | cString += e } )
	
EndIf

Return AllTrim( cString )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RemoveFunc³ Autor ³ 		MMN - 0990      ³ Data ³05/12/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Remove Funcao de Uma String que inicia e fecha com "("	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³VIDEOLAR                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION RemoveFunc( cString, cRemove, cAdd )

LOCAL nPos, nI, cStr

cString := Upper( cString )
cRemove := Upper( cRemove )

While (nPos := AT( cRemove, cString ) ) > 0
	cStr    := ""
	cString := Subs(cString,1,nPos-1)+Subs(cString,nPos+Len(cRemove))
	For nI  := nPos to Len(cString)
		If Substr(cString,nI,1) == ")"
			Exit
		Else
			cStr += Subs(cString,nI,1)
		EndIf
	Next
	If AT(")",cString) == 0
		MsgAlerta("ERRO DE TOKEN na RemoveFunc")
	EndIf
	cString := Substr(cString,1,nPos-1)+cStr+If( !Empty( cAdd ),cAdd,"" )+Substr(cString,nI+1)
EndDo

Return( cString )

/*
STATIC FUNCTION GRVPRELAN(pMatriz)

Local nLanSeq
Private _cLoteCie := ALLTRIM(GETMV("CI_LOTEDM"))  // Lote Determinado pelo usuario no parametro
Private _cSubLCie := "001"
Private _cDocCie  := STRZERO((VAL(CTGERDOC(_cLoteCie,_cSubLCie,MV_PAR02))+1),6)
Private _cLinCie  := 0


IF MV_PAR16 == 1    //.AND. TMQ->TM_LC <> "S" // (1=Sim , 2 = Nao)
	
	dbSelectArea("CT2")
	dbSetOrder(1)
	
	If Len(pMatriz) > 0
		_nNroDM := pMatriz[1][4]
		
		For Ic := 1 To Len(pMatriz)
			
			_cLinCie++
			RecLock("CT2",.T.)
			CT2->CT2_FILIAL := xFILIAL("CT2")
			CT2->CT2_DATA   := MV_PAR02   //dDATABASE
			CT2->CT2_LOTE   :=_cLoteCie
			CT2->CT2_SBLOTE :=_cSubLCie
			
			IF pMatriz[Ic][4]<> _nNroDM
				_cDocCie :=   StrZero(Val(_cDocCie)+1,6)
				_nNroDM := pMatriz[Ic][4]
				_cLinCie := 1
			ENDIF
			CT2->CT2_LINHA  :=StrZero(_cLinCie,3)
			CT2->CT2_DOC    := _cDocCie
			
			IF !Empty(pMatriz[Ic][1]) .and. Empty(pMatriz[Ic][2])
				CT2->CT2_DC  := "1"
				DBSELECTAREA("CT1")
				CT1->(DBSETORDER(2))
				CT1->(DBSEEK(xFilial("CT1")+SUBS(pMatriz[Ic][1],1,6)))
				CT2->CT2_DEBITO := CT1->CT1_CONTA
			ELSEIF Empty(pMatriz[Ic][1]) .and. !Empty(pMatriz[Ic][2])
				CT2->CT2_DC  := "2"
				DBSELECTAREA("CT1")
				CT1->(DBSETORDER(2))
				CT1->(DBSEEK(xFilial("CT1")+SUBS(pMatriz[Ic][2],1,6)))
				CT2->CT2_CREDIT := CT1->CT1_CONTA
			ELSE
				CT2->CT2_DC  := "3"
				DBSELECTAREA("CT1")
				CT1->(DBSETORDER(2))
				CT1->(DBSEEK(xFilial("CT1")+SUBS(pMatriz[Ic][1],1,6)))
				CT2->CT2_DEBITO := CT1->CT1_CONTA
				CT1->(DBSEEK(xFilial("CT1")+SUBS(pMatriz[Ic][2],1,6)))
				CT2->CT2_CREDIT := CT1->CT1_CONTA
			ENDIF
			CT2->CT2_DCD:= ""
			CT2->CT2_DCC:= ""
			CT2->CT2_MOEDLC:="01"
//			CT2->CT2_VLR01:=pMatriz[Ic][3]
			CT2->CT2_VALOR:=pMatriz[Ic][3]
			CT2->CT2_MOEDAS:="1"
			CT2->CT2_HP:= ""
			CT2->CT2_HIST:= pMatriz[Ic][4]+SPACE(2)+Dtoc(MV_PAR02)     //Dtoc(dDataBase)
			CT2->CT2_CRITER:="1"
			CT2->CT2_CCD:= pMatriz[Ic][6]
			CT2->CT2_CCC:= ""
			CT2->CT2_ITEMD  := pMatriz[Ic][1]
			CT2->CT2_ITEMC  := pMatriz[Ic][2]
			CT2->CT2_CLVLDB:= ""
			CT2->CT2_CLVLCR:= ""
			CT2->CT2_VLR02:= 0
			CT2->CT2_VLR03:= 0
			CT2->CT2_VLR04:= 0
			CT2->CT2_VLR05:= 0
			CT2->CT2_ATIVDE:= ""
			CT2->CT2_ATIVCR:= ""
			CT2->CT2_EMPORI:=Substr(cNumEmp,1,2)
			CT2->CT2_FILORI:=xFilial("CT2")
			CT2->CT2_INTERC:="2"
			CT2->CT2_IDENTC:= ""
			CT2->CT2_TPSALD:= "9"
			CT2->CT2_SEQUEN:=StrZero(_cLinCie,3)
			CT2->CT2_MANUAL:="1"
			CT2->CT2_ORIGEM:="932 CFINR004"
			CT2->CT2_ROTINA:="CFINR004"
			CT2->CT2_AGLUT:= "2"
			CT2->CT2_LP:=""
			CT2->CT2_SEQHIS:=StrZero(_cLinCie,3)
			nLanSeq := (VAL(CTGERLA(_cLoteCie,_cSubLCie,MV_PAR02,_cDocCie,6))+1)
			CT2->CT2_SEQLAN:=StrZero(nLanSeq,3)
			CT2->CT2_DTVENC:= Ctod("//")
			CT2->CT2_KEY   := "DM "+pMatriz[Ic][4]
			CT2->(MSUNLOCK())
		Next
	ENDIF
ENDIF

Return
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINR004  ºAutor  ³Emerson Natali      º Data ³  07/17/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC FUNCTION GRVPRELAN(pMatriz)

Local nDecs			:=	TamSX3('CT2_VALOR')[2]
Local nX			:=	1
Local nBase			:=	1
Local nMaxLanc		:=	99
Local aCab			:= {}
Local aItem			:= {}
Local aTotItem 		:= {}
Local dDataLanc 	:= CTOD("") 

Private lMsErroAuto := .F.
Private _cLoteCie	:= ALLTRIM(GETMV("CI_LOTEDM"))  // Lote Determinado pelo usuario no parametro
Private _cSubLCie 	:= "001"

_cLinCie := 1
If Len(pMatriz) > 0
	_aDM 	 := {}
	For Ix := 1 To Len(pMatriz)
		nPos := ascan(_aDM, pMatriz[Ix][4])
		If Empty(nPos)
			AADD(_aDM,pMatriz[Ix][4])
		EndIf
	Next
EndIf

IF MV_PAR16 == 1
	If Len(pMatriz) > 0
		_nNroDM := pMatriz[1][4]
		For _nI := 1 to Len(_aDM)
			aCab := {;
					{"dDataLanc", MV_PAR02,NIL},;
					{"cLote"	, _cLoteCie,NIL},;
					{"cSubLote"	, _cSubLCie,NIL}}
			nPos1 := ascan(pMatriz,{|x| x[4] == _aDM[_nI]})
			For Ic := nPos1 To Len(pMatriz)
				IF pMatriz[Ic][4]<> _nNroDM
					_nNroDM := pMatriz[Ic][4]
					_cLinCie := 1
					Exit
				ENDIF

				IF !Empty(pMatriz[Ic][1]) .and. Empty(pMatriz[Ic][2])
					_cDC 	:= "1"
					_cITEMD	:= pMatriz[Ic][1]
					_cITEMC := ""
				ELSEIF Empty(pMatriz[Ic][1]) .and. !Empty(pMatriz[Ic][2])
					_cDC 	:= "2"
					_cITEMD := ""
					_cITEMC := pMatriz[Ic][2]
				ELSE
					_cDC 	:= "3"
					_cITEMD := pMatriz[Ic][1]
					_cITEMC := pMatriz[Ic][2]
				ENDIF

				AADD(aItem,{	{"CT2_FILIAL"	,xFilial("CT2")									, NIL},;
								{"CT2_LINHA"	,StrZero(_cLinCie,3)							, NIL},;
								{"CT2_DC"		,_cDC	 										, NIL},;
								{"CT2_ITEMD"	,_cITEMD										, NIL},;
								{"CT2_ITEMC"	,_cITEMC										, NIL},;
								{"CT2_CCD"		, pMatriz[Ic][6]								, NIL},;
								{"CT2_CCC"		, "" 											, NIL},;
								{"CT2_DCD"		, "" 											, NIL},;
								{"CT2_DCC"		, "" 											, NIL},;
								{"CT2_VALOR"	, Round(pMatriz[Ic][3],nDecs)					, NIL},;
								{"CT2_HP"		, ""											, NIL},;
								{"CT2_HIST"		, pMatriz[Ic][4]+SPACE(2)+Dtoc(MV_PAR02)		, NIL},;
								{"CT2_TPSALD"	, "9"											, NIL},;
								{"CT2_ORIGEM"	, "932 "+pMatriz[Ic][4]							, NIL},;
								{"CT2_MOEDLC"	, "01"											, NIL},;
								{"CT2_EMPORI"	, Substr(cNumEmp,1,2)							, NIL},;
								{"CT2_ROTINA"	, "CFINR004"									, NIL},;
								{"CT2_LP"		, ""											, NIL},;
								{"CT2_KEY"		, ""											, NIL}})

//								{"CT2_ORIGEM"	, "932 CFINR004"								, NIL},;
//								{"CT2_KEY"		, "DM "+pMatriz[Ic][4]							, NIL}})								

				_cLinCie++
			Next
			aadd(aTotItem,aItem)
			MSExecAuto({|a,b,C| Ctba102(a,b,C)},aCab,aItem,3)
			aTotItem	:=	{}
			
			If lMsErroAuto
				DisarmTransaction()
				MostraErro()
				Return .F.
			Endif
			
			aCab	:= {}
			aItem	:= {}
			
		Next
	ENDIF
ENDIF

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINR004  ºAutor  ³Microsiga           º Data ³  07/17/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static  Function CTGERLA(pLote,pSbLote,pData,pDoc)

Local _cQuery := " "
Local _cFl := CHR(13)+CHR(10)
Local _lRet := 0

_cQuery := " SELECT MAX(CT2_SEQLAN) AS SEQMOV FROM " + RetSQLName("CT2") + "  "+_cFl
_cQuery += " WHERE D_E_L_E_T_ = ' '  AND CT2_LOTE = '"+pLote+"'  "+_cFl
_cQuery += " AND CT2_SBLOTE = '"+pSbLote+"' "+_cFl
_cQuery += " AND CT2_DATA = '"+Dtos(pData)+"' AND CT2_DOC = '"+pDoc+"' "+_cFl
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'TRT',.T.,.T.)

_lRet := TRT->SEQMOV

If Select("TRT") > 0
	TRT->(DBCLOSEAREA())
EndIf

Return(_lRet)

Static  Function CTGERDOC(pLote,pSbLote,pData)

Local _cQuery := " "
Local _cFl := CHR(13)+CHR(10)
Local _lRet := 0

_cQuery := " SELECT MAX(CT2_DOC) AS DOCMOV FROM " + RetSQLName("CT2") + "  "+_cFl
_cQuery += " WHERE D_E_L_E_T_ = ' '  AND CT2_LOTE = '"+pLote+"'  "+_cFl
_cQuery += " AND CT2_SBLOTE = '"+pSbLote+"' "+_cFl
_cQuery += " AND CT2_DATA = '"+Dtos(pData)+"' "+_cFl
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'TRS',.T.,.T.)

_lRet := TRS->DOCMOV

If Select("TRS") > 0
	TRS->(DBCLOSEAREA())
EndIf

Return(_lRet)