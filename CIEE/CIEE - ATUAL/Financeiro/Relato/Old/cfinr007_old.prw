#INCLUDE "rwmake.ch"
#Include "TopConn.ch"
#include "_FixSX.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CFINR007 º Autor ³ AP6 IDE            º Data ³  06/05/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Impressao de DM                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Relatorio Especifico CIEE / Depto Financeiro               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CFINR007()


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
Private wnrel        := "FINR07" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString      := "SZ5"
Private cPerg        := "FINR07"                            
Private mvFicha

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01 - Ficha de Lancamento                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_aPerg := {}
AADD(_aPerg,{cPerg,"01","DM De              ?","","","mv_cha","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"02","DM Ate             ?","","","mv_chb","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

AjustaSX1(_aPerg)
Pergunte(cPerg, .F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

dbSelectArea("SZ5")
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
For _nFicha:=Val(mv_par01) to Val(mv_par02)            
  mvFicha:=StrZero(_nFicha,6)
  RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin,mvFicha) },Titulo)
Next _nFicha


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

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin,mvFicha)

_xFilSZ5:=xFilial("SZ5")
_xFilSZ7:=xFilial("SZ7")

_cOrdem := " Z5_FILIAL,Z5_BANCO,Z5_AGENCIA,Z5_CCONTA, Z7_GRUPO, Z5_PRESTA, Z5_UNIDADE, Z5_LANC, Z5_DOC"
_cQuery := " SELECT Z5_LANC, Z5_DOC, Z7_GRUPO, Z5_PRESTA, Z5_TEL, Z5_MES, Z5_VALOR, Z5_BAIXA, Z5_CONTA ,Z5_UNIDADE, Z5_CR, Z5_FL,"
_cQuery += " Z5_BANCO ,Z5_AGENCIA ,Z5_CCONTA "
_cQuery += " FROM "
_cQuery += RetSqlName("SZ5")+" SZ5,"
_cQuery += RetSqlName("SZ7")+" SZ7"
_cQuery += " WHERE '"+ _xFilSZ5 +"' = Z5_FILIAL"
_cQuery += " AND   '"+ _xFilSZ7 +"' = Z7_FILIAL"
_cQuery += " AND    Z5_PRESTA   = Z7_PRESTA"
_cQuery += " AND    Z5_UNIDADE  = 'SAO PAULO      '"
_cQuery += " AND    Z5_FL       = '"+mvFicha+"'"

If !Empty(aReturn[7])
	_cQuery += U_TransQuery(aReturn[7])
EndIf

U_EndQuery( @_cQuery,_cOrdem, "QUERY", {"SZ5","SZ7" },,,.T. )
dbSelectArea("QUERY")
dbGoTop()

U_IMP7()


_xFilSZ5:=xFilial("SZ5")
_xFilSZ7:=xFilial("SZ7")

_cOrdem := " Z5_FILIAL,Z5_BANCO,Z5_AGENCIA,Z5_CCONTA, Z7_GRUPO, Z5_PRESTA, Z5_UNIDADE, Z5_LANC, Z5_DOC"
_cQuery := " SELECT Z5_LANC, Z5_DOC, Z7_GRUPO, Z5_PRESTA, Z5_TEL, Z5_MES, Z5_VALOR, Z5_BAIXA, Z5_CONTA ,Z5_UNIDADE, Z5_CR, Z5_FL,"
_cQuery += " Z5_BANCO ,Z5_AGENCIA ,Z5_CCONTA "
_cQuery += " FROM "
_cQuery += RetSqlName("SZ5")+" SZ5,"
_cQuery += RetSqlName("SZ7")+" SZ7"
_cQuery += " WHERE '"+ _xFilSZ5 +"' = Z5_FILIAL"
_cQuery += " AND   '"+ _xFilSZ7 +"' = Z7_FILIAL"
_cQuery += " AND    Z5_PRESTA   = Z7_PRESTA"
_cQuery += " AND    Z5_UNIDADE <> 'SAO PAULO      '"
_cQuery += " AND    Z5_FL       = '"+mvFicha+"'"


If !Empty(aReturn[7])
	_cQuery += U_TransQuery(aReturn[7])
EndIf

U_EndQuery( @_cQuery,_cOrdem, "QUERY", {"SZ5","SZ7" },,,.T. )

dbSelectArea("QUERY")
dbGoTop()

U_IMP7()


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Imp7 ³ Autor ³      Andy                  ³ Data ³08/05/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³CIEE                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION IMP7()



Local _cBanco   
Local _cAgencia 
Local _cConBco  
Local _cGrupo   
Local _cPresta  

_nDevedora := 0
_nTotal    := 0
_nTotalAux := 0
nLin       := 60
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
     While !EOF() .And. _cGrupo == QUERY->Z7_GRUPO
		
		_cUnidade := QUERY->Z5_UNIDADE
		_cCR      := QUERY->Z5_CR
	While !EOF() .And. (QUERY->Z5_BANCO == _cBanco) .And. (QUERY->Z5_AGENCIA == _cAgencia);
			.And. (QUERY->Z5_CCONTA == _cConBco) .And.  (_cGrupo == QUERY->Z7_GRUPO);
			.And. _cUnidade == QUERY->Z5_UNIDADE
				
			
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
			@ nLin, 151 PSay QUERY->Z5_FL
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
				
				_nDevedora:=_nDevedora+Val(_cContaD+_cCR)
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
			@ nLin, 011 PSay "    31801 998"
		ElseIf AllTrim( _cPresta)=="ELETROPAULO"
			@ nLin, 011 PSay "    31803 998"
		ElseIf AllTrim( _cPresta)=="COMGAS"
			@ nLin, 011 PSay "    31806 998"
		Else
			@ nLin, 011 PSay "       212111"
		EndIf
		
		@ nLin, 027 PSay "|"
		@ nLin, 029 PSay "Credora"
		@ nLin, 040 PSay "|"
		@ nLin, 043 PSay _cContaC
		@ nLin, 052 PSay "|"
		@ nLin, 054 PSay "TOTAL  "
		@ nLin, 070 PSay "|"
		@ nLin, 072 PSay _nTotal  Picture "@E 999,999,999,999.99"
		@ nLin, 092 PSay "|"
		@ nLin, 103 PSay "|"
		@ nLin, 115 PSay "|"
		@ nLin, 143 PSay "|"
		@ nLin, 149 PSay "|"
		@ nLin, 158 PSay "|"
	Else
		@ nLin, 000 PSay "Devedora"
		@ nLin, 009 PSay "|"
		@ nLin, 015 PSay _nDevedora  
		@ nLin, 027 PSay "|"
		@ nLin, 029 PSay "Credora"
		@ nLin, 040 PSay "|"
		@ nLin, 043 PSay _cContaC
		@ nLin, 052 PSay "|"
		@ nLin, 054 PSay "TOTAL"
		@ nLin, 070 PSay "|"
		@ nLin, 072 PSay _nTotal  Picture "@E 999,999,999,999.99"
		@ nLin, 092 PSay "|"
		@ nLin, 103 PSay "|"
		@ nLin, 115 PSay "|"
		@ nLin, 143 PSay "|"
		@ nLin, 149 PSay "|"
		@ nLin, 158 PSay "|"
	EndIf
	
	_nDevedora:=0
	_nTotal   := 0
	nLin      := 60
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("QUERY")
dbCloseArea()

Return

