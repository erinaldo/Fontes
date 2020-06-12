#INCLUDE "rwmake.ch"
#Include "TopConn.ch"
#include "_FixSX.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CFINR006 º Autor ³ AP6 IDE            º Data ³  08/08/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio Contabil da  Tarifacao Telefonica                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Relatorio Especifico CIEE / Depto Contabil/Financeiro      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CFINR006()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cDesc1 := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2 := "sobre Contas de Consumo"
Private cDesc3 := "de acordo com os parametros informados pelo usuario."

Private titulo := "Relatorio de Contas de Consumo"
Private nLin   := 60

Private Cabec1 := "Data     | Prestadora      | Documento  | Telefone  | Mes Ref.        |              Valor  | Baixa    | Sem Conta | Unidade                   | CR    | DM     |"
Private Cabec2 := ""
****           := "dd/mm/aa | ppppppppppppppp | dddddddddd | tttt-tttt | mmmmmmmmmmmmmmm | 999,999,999,999.99  | dd/mm/aa |    SIM    | uuuuuuuuuuuuuuuuuuuuuuuuu | ccccc | ffffff |"
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
Private wnrel        := "FINR06" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString      := "SZ5"
Private cPerg        := "FINR06    "


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01 - Data de                                     ³
//³ mv_par02 - Data de ate                                 ³
//³ mv_par03 - Prestadora de                               ³
//³ mv_par04 - Prestadora ate                              ³
//³ mv_par05 - Unidade de                                  ³
//³ mv_par06 - Unidade ate                                 ³
//³ mv_par07 - Referencia de                               ³
//³ mv_par08 - Referencia ate                              ³
//³ mv_par09 - DM de                                       ³
//³ mv_par10 - DM ate                                      ³
//³ mv_par11 - SP/Outros/Todos                             ³
//³ mv_par12 - Status                                      ³
//³ mv_par13 - Ordem                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_aPerg := {}
AADD(_aPerg,{cPerg,"01","Data Lanca. de     ?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"02","Data Lanca. ate    ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"03","Grupo de           ?","","","mv_ch3","C",03,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","BZV","",""})
AADD(_aPerg,{cPerg,"04","Grupo Ate          ?","","","mv_ch4","C",03,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","BZV","",""})
AADD(_aPerg,{cPerg,"05","Prestadora de      ?","","","mv_ch5","C",15,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","BZ7","",""})
AADD(_aPerg,{cPerg,"06","Prestadora ate     ?","","","mv_ch6","C",15,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","BZ7","",""})
AADD(_aPerg,{cPerg,"07","Unidade de         ?","","","mv_ch7","C",25,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","SZU","",""})
AADD(_aPerg,{cPerg,"08","Unidade ate        ?","","","mv_ch8","C",25,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","SZU","",""})
AADD(_aPerg,{cPerg,"09","Referencia de      ?","","","mv_ch9","C",15,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"10","Referencia ate     ?","","","mv_cha","C",15,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"11","DM de              ?","","","mv_chb","C",06,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"12","DM ate             ?","","","mv_chc","C",06,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"13","SP/Outros/Todos    ?","","","mv_chd","N",01,0,0,"C","","mv_par13","SP","","","","","Outros","","","","","Todos","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"14","Status             ?","","","mv_che","N",01,0,0,"C","","mv_par14","Bx Com e Sem Conta","","","","","Baixado","","","","","Aberto","","","","","Bx Sem Conta","","","","","Todos","","","","","",""})
AADD(_aPerg,{cPerg,"15","Ordem de Impressao ?","","","mv_chf","N",01,0,0,"C","","mv_par15","Data","","","","","CR","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"16","Data Baixa de      ?","","","mv_chg","D",08,0,0,"G","","mv_par16","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"17","Data Baixa ate     ?","","","mv_chh","D",08,0,0,"G","","mv_par17","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

AjustaSX1(_aPerg)

Pergunte(cPerg, .T.)


//wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.T.)

IF MV_PAR15 == 1
	_cExtTit := "   ( Por Ordem Data )"
ELSE
	_cExtTit := "   ( Por Ordem CR )"
ENDIF  

IF MV_PAR13 == 1
	_cExtTit1 := "   ( SP )"
ELSEIF MV_PAR13 == 2
	   _cExtTit1 := "   ( Unidades )"
ELSE
    _cExtTit1 := "   ( Todos )"    
ENDIF  

Do case
   case MV_PAR14 == 1
     	_cExtTit2 := "   ( Bx Com e Sem Conta )"        
   case MV_PAR14 == 2
     	_cExtTit2 := "   ( Baixado )"        
   case MV_PAR14 == 3
     	_cExtTit2 := "   ( Aberto )"        
   case MV_PAR14 == 4
     	_cExtTit2 := "   ( Bx Sem Conta )"        
   case MV_PAR14 == 5
     	_cExtTit2 := "   ( Todos )"             	
Endcase

Do Case
	Case cEmpant == '01'
		titulo := Alltrim(Titulo) + " CIEE / SP - Periodo de "+ DTOC(MV_PAR01)+" ate "+DTOC(MV_PAR02)+"  -"+_cExtTit +_cExtTit1 +_cExtTit2
	Case cEmpant == '03'
		titulo := Alltrim(Titulo) + " CIEE / RJ - Periodo de "+ DTOC(MV_PAR01)+" ate "+DTOC(MV_PAR02)+"  -"+_cExtTit +_cExtTit1 +_cExtTit2
	Case cEmpant == '05'
		titulo := Alltrim(Titulo) + " CIEE / NACIONAL - Periodo de "+ DTOC(MV_PAR01)+" ate "+DTOC(MV_PAR02)+"  -"+_cExtTit +_cExtTit1 +_cExtTit2
EndCase		

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

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

If Subs(mv_par07,1,9)>"SAO PAULO" .Or. Subs(mv_par08,1,9)<"SAO PAULO"
	_lSo_SP:=.F.
EndIf

If Subs(mv_par07,1,9)=="SAO PAULO" .And. Subs(mv_par08,1,9)=="SAO PAULO"
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


_xFilSZ5:=xFilial("SZ5")
_xFilSZ7:=xFilial("SZ7")

If mv_par15 == 1
	_cOrdem := " Z5_FILIAL, Z5_LANC, Z5_UNIDADE, Z5_PRESTA,  Z5_DOC"
ELSE
	_cOrdem := " Z5_FILIAL, Z5_CR, Z5_LANC, Z5_PRESTA, Z5_DOC"
ENDIF


_cQuery := " SELECT Z5_LANC, Z5_DOC, Z7_GRUPO, Z5_PRESTA, Z5_TEL, Z5_MES, Z5_VALOR, Z5_BAIXA, Z5_CONTA ,Z5_UNIDADE, Z5_CR, Z5_FL"
_cQuery += " FROM "
_cQuery += RetSqlName("SZ5")+" SZ5,"
_cQuery += RetSqlName("SZ7")+" SZ7"
_cQuery += " WHERE '"+ _xFilSZ5 +"' = Z5_FILIAL"
_cQuery += " AND   '"+ _xFilSZ7 +"' = Z7_FILIAL"
_cQuery += " AND    Z5_PRESTA   = Z7_PRESTA"
IF _lSo_SP
	_cQuery += " AND    Z5_UNIDADE  = 'SAO PAULO      '"
ELSEIF _lSo_Outros
	_cQuery += " AND    Z5_UNIDADE <> 'SAO PAULO      '"
ENDIF

_cQuery += " AND    Z5_LANC    >= '"+DTOS(mv_par01)+"'"
_cQuery += " AND    Z5_LANC    <= '"+DTOS(mv_par02)+"'"
_cQuery += " AND    Z5_PRESTA  >= '"+mv_par05+"'"
_cQuery += " AND    Z5_PRESTA  <= '"+mv_par06+"'"
_cQuery += " AND    Z5_UNIDADE >= '"+mv_par07+"'"
_cQuery += " AND    Z5_UNIDADE <= '"+mv_par08+"'"
_cQuery += " AND    Z5_MES     >= '"+mv_par09+"'"
_cQuery += " AND    Z5_MES     <= '"+mv_par10+"'"
_cQuery += " AND    Z5_FL      >= '"+mv_par11+"'"
_cQuery += " AND    Z5_FL      <= '"+mv_par12+"'" 
_cQuery += " AND    Z5_BAIXA BETWEEN '"+Dtos(mv_par16)+"' AND '"+Dtos(mv_par17)+"' "   // Alterado Conf. Chamado 11322
_cQuery += " AND    Z7_GRUPO BETWEEN '"+mv_par03+"'  AND '"+mv_par04+"' "  // CLAUDIO 12/05/05
If mv_par14 == 1
	_cQuery += " AND (Z5_BAIXA <> '' OR Z5_CONTA = 'S')"
elseIf mv_par14 == 2
	_cQuery += " AND  Z5_BAIXA <> '' "
ElseIf mv_par14 == 3
	_cQuery += " AND  Z5_BAIXA  = '' AND Z5_FL   =  ''"  // ANDY
ElseIf mv_par14 == 4
	_cQuery += " AND  Z5_CONTA = 'S' "
EndIf

//_cQuery += "ORDER BY "+_cOrdem+" "


If !Empty(aReturn[7])
	_cQuery += U_TransQuery(aReturn[7])
EndIf

U_EndQuery( @_cQuery,_cOrdem, "QUERY", {"SZ5","SZ7" },,,.T. )

/*

_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'QUERY',.T.,.T.)

TcSetField("Query","Z5_LANC","D",8, 0 )		
*/

dbSelectArea("QUERY")
dbGoTop()

U_IMP_R006()



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

USER FUNCTION IMP_R006()


Local _cCR
Local _cVrLoop 
Local _StrLoop 

_nDevedora := 0
_nTotal    := 0
_nTotalAux := 0
nLin       := 60

If mv_par15 == 1
	_cVrLoop := "QUERY->Z5_LANC"
ELSE
	_cVrLoop := "QUERY->Z5_CR"
ENDIF

SetRegua(RecCount())

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
	
	_cVrRet := &(_cVrLoop)
	
	While !EOF() .And. _cVrRet == &(_cVrLoop)
		
		dbSelectArea("SZ5")
		DbSetOrder(1)
		dbSeek(xFilial("SZ5")+QUERY->(DTOS(Z5_LANC)+Z5_PRESTA+Z5_UNIDADE+Z5_DOC), .F.)
		
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
		@ nLin, 151 PSay "|"
		@ nLin, 153 PSay SZ5->Z5_FL
		@ nLin, 160 PSay "|"
		
		_nTotal    += QUERY->Z5_VALOR
		_nTotalAux += QUERY->Z5_VALOR
		
		nLin ++
		dbSelectArea("QUERY")
		dbSkip()
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
	@ nLin, 151 PSay "|"
	@ nLin, 160 PSay "|"
	
	nLin ++
	
	@ nLin, 009 PSay "|"
	@ nLin, 027 PSay "|"
	@ nLin, 040 PSay "|"
	@ nLin, 052 PSay "|"
	@ nLin, 054 PSay "SUB-TOTAL"
	@ nLin, 070 PSay "|"
	@ nLin, 072 PSay _nTotalAux  Picture "@E 999,999,999,999.99"
	@ nLin, 092 PSay "|"
	@ nLin, 103 PSay "|"
	@ nLin, 115 PSay "|"
	@ nLin, 143 PSay "|"
	@ nLin, 151 PSay "|"
	@ nLin, 160 PSay "|"
	
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
	@ nLin, 151 PSay "|"
	@ nLin, 160 PSay "|"
	
	nLin ++
	
	_nTotalAux:=0
	
EndDo


IF !Empty(_nTotal) 

@ nLin, 009 PSay "|"
@ nLin, 027 PSay "|"
@ nLin, 040 PSay "|"
@ nLin, 052 PSay "|"
@ nLin, 070 PSay "|"
@ nLin, 092 PSay "|"
@ nLin, 103 PSay "|"
@ nLin, 115 PSay "|"
@ nLin, 143 PSay "|"
@ nLin, 151 PSay "|"
@ nLin, 160 PSay "|"

nLin ++

@ nLin, 009 PSay "|"
@ nLin, 027 PSay "|"
@ nLin, 040 PSay "|"
@ nLin, 052 PSay "|"
@ nLin, 054 PSay "TOTAL"
@ nLin, 070 PSay "|"
@ nLin, 072 PSay _nTotal  Picture "@E 999,999,999,999.99"
@ nLin, 092 PSay "|"
@ nLin, 103 PSay "|"
@ nLin, 115 PSay "|"
@ nLin, 143 PSay "|"
@ nLin, 151 PSay "|"
@ nLin, 160 PSay "|"

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
@ nLin, 151 PSay "|"
@ nLin, 160 PSay "|"
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("QUERY")
dbCloseArea()

Return
