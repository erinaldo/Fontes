#INCLUDE "rwmake.ch"
#Include "TopConn.ch"
#include "_FixSX.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CFINR005 บ Autor ณ AP6 IDE            บ Data ณ  06/05/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de Controle de Creditos Nao Identificados        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Relatorio Especifico CIEE / Depto Financeiro               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CFINR005()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private cDesc1 := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2 := "sobre Controle de Creditos Nao Identificados"
Private cDesc3 := "de acordo com os parametros informados pelo usuario."

Private titulo := "Controle de Creditos Nao Identificados"
Private nLin   := 80

Private Cabec2:= "Data     | Tipo/Documento     | Depositante                    |          Valor | Documento       | No.  | Agencia                        | Identificacao |           B.A. |           C.I. |      Irregularidade | RDR          "
Private Cabec1:= "Banco Agencia Conta"
****          := "dd/mm/aa | tt-ttttttttttttttt | dddddddddddddddddddddddddddddd | vvvvvvvvvvvvvv | nnnnnnnnnnnnnnn | aaaa | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa | ii-iiiiiiiiii | bbbbbbbbbbbbbb | cccccccccccccc | iiiiiiiiiiiiii s | rrrrrrrrrrr  "
****          := "0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789"
****          := "0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21         "
****          := "0          11                   32                               65               82                100    107                              140             156              173              190            205 209
****          := "0        09                   30                               63               80                98     105                              138             154              171              188                207
****          := "00 09 11 30 32 63 65 80 82 98 100 105 107 138 140 154 156 171 173 188 190 205 207

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
Private wnrel        := "FINR05" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString      := "SZ5"
Private cPerg        := "FINR05"
Private _nFL         := 0


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ mv_par01 - Conta de                                    ณ
//ณ mv_par02 - Conta ate                                   ณ
//ณ mv_par03 - Emissao de                                  ณ
//ณ mv_par04 - Emissao ate                                 ณ
//ณ mv_par05 - Depositante Sim/Nao/Todos                   ณ chamado 22123 alterado por CG em 23/01/07
//ณ mv_par08 - Identificacao de                            ณ
//ณ mv_par09 - Identificacao ate                           ณ
//ณ mv_par08 - RDR de                                      ณ
//ณ mv_par09 - RDR ate                                     ณ
//ณ mv_par10 - Status Aberto/Fechado/Todos                 ณ
//ณ mv_par11 - Irregularidade Com/Sem/Todos                ณ
//ณ mv_par12 - Status Aberto/Fechado/Todos                 ณ
//ณ mv_par13 - Tipo Irregular de                           ณ
//ณ mv_par14 - Tipo Irregular ate                          ณ
//ณ mv_par15 - Fluxo                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

_aPerg := {}
AADD(_aPerg,{cPerg,"01","Conta de           ?","","","mv_ch1","C",10,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","BZC","",""})
AADD(_aPerg,{cPerg,"02","Conta ate          ?","","","mv_ch2","C",10,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","BZC","",""})
AADD(_aPerg,{cPerg,"03","Data de            ?","","","mv_ch3","D",08,0,0,"G","","mv_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"04","Data ate           ?","","","mv_ch4","D",08,0,0,"G","","mv_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"05","Depositante        ?","","","mv_ch5","N",01,0,0,"C","","mv_par05","Sim","","","","","Nao","","","","","Todos","","","","","","","","","","","","","","","",""}) // chamado 22123 alterado por CG em 23/01/07
AADD(_aPerg,{cPerg,"06","Identificacao de   ?","","","mv_ch6","C",02,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","BZB","",""})
AADD(_aPerg,{cPerg,"07","Identificacao ate  ?","","","mv_ch7","C",02,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","BZB","",""})
AADD(_aPerg,{cPerg,"08","RDR de             ?","","","mv_ch8","C",15,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"09","RDR ate            ?","","","mv_ch9","C",15,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"10","Status             ?","","","mv_chA","N",01,0,0,"C","","mv_par10","Aberto s/RDR","","","","","Fechado c/RDR","","","","","Todos","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"11","Irregularidade     ?","","","mv_chB","N",01,0,0,"C","","mv_par11","Sim","","","","","Nao","","","","","Todos","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"12","Status Irregular.  ?","","","mv_chC","N",01,0,0,"C","","mv_par12","Aberto s/RDR","","","","","Fechado c/RDR","","","","","Todos","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"13","Tipo Irregular. de ?","","","mv_chD","C",01,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"14","Tipo Irregular. ate?","","","mv_chE","C",01,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"15","Fluxo              ?","","","mv_chF","N",01,0,0,"C","","mv_par15","Sim","","","","","Nao","","","","","Todos","","","","","","","","","","","","","","","",""})

AjustaSX1(_aPerg)

Pergunte(cPerg, .F.)

//wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.T.)
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Do Case
	Case cEmpant == '01'
		Titulo := Alltrim(Titulo) + " CIEE / SP"				
		If mv_par15 == 1
			titulo := titulo + " - Fluxo"
		ElseIf mv_par15 == 2
			titulo := titulo + " - Nใo Fluxo"
		EndIf  		
	Case cEmpant == '03'
		Titulo := Alltrim(Titulo) + " CIEE / RJ"				
		If mv_par15 == 1
			titulo := titulo + " - Fluxo"
		ElseIf mv_par15 == 2
			titulo := titulo + " - Nใo Fluxo"
		EndIf  				
	Case cEmpant == '05'
		Titulo := Alltrim(Titulo) + " CIEE / NACIONAL"						
		If mv_par15 == 1
			titulo := titulo + " - Fluxo"
		ElseIf mv_par15 == 2
			titulo := titulo + " - Nใo Fluxo"
		EndIf  				
EndCase	

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  06/05/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)


Local _nBcoG_V := 0
Local _nBcoG_B := 0
Local _nBcoG_C := 0
Local _nBcoG_I := 0
Local _nContCre := 0

_xFilSZ8:=xFilial("SZ8")

//_cOrdem := " Z8_FILIAL, Z8_BANCO, Z8_AGENCIA, Z8_CONTA, Z8_EMISSAO, Z8_VALOR"
_cOrdem := " Z8_FILIAL, Z8_CONTA, Z8_BANCO, Z8_AGENCIA, Z8_EMISSAO, Z8_VALOR"
_cQuery := " SELECT Z8_BANCO, Z8_AGENCIA, Z8_CONTA, Z8_EMISSAO, Z8_TIPO, Z8_DEPOS, Z8_VALOR, "
_cQuery += " Z8_NDOC, Z8_NAGE, Z8_IDENT, Z8_BA, Z8_CI, Z8_RDR, Z8_IR, Z8_IRTIP, Z8_IRRDR, Z8_HIST, Z8_IMPFLAG "
_cQuery += " FROM "
_cQuery += RetSqlName("SZ8")+" SZ8"
_cQuery += " WHERE '"+ _xFilSZ8 +"' = Z8_FILIAL"
_cQuery += " AND    Z8_CONTA   >= '"+mv_par01+"'"
_cQuery += " AND    Z8_CONTA   <= '"+mv_par02+"'"
_cQuery += " AND    Z8_EMISSAO >= '"+DTOS(mv_par03)+"'"
_cQuery += " AND    Z8_EMISSAO <= '"+DTOS(mv_par04)+"'"
/*
If !Empty(mv_par05)
	_cQuery += " AND Z8_DEPOS   = '"+mv_par05+"'"
EndIf
*/

If mv_par05 == 1										// chamado 22123 alterado por CG em 23/01/07
	_cQuery += " AND Z8_DEPOS <> '' "
ElseIf mv_par05 == 2
	_cQuery += " AND Z8_DEPOS = '' "	
EndIf	
_cQuery += " AND    Z8_IDENT   >= '"+mv_par06+"'"
_cQuery += " AND    Z8_IDENT   <= '"+mv_par07+"'"
_cQuery += " AND    Z8_RDR     >= '"+mv_par08+"'"
_cQuery += " AND    Z8_RDR     <= '"+mv_par09+"'"
If mv_par10 == 1
	_cQuery += " AND Z8_RDR     = '' "
ElseIf mv_par10 == 2
	_cQuery += " AND Z8_RDR    <> '' "
EndIf
If mv_par11 == 1
	_cQuery += " AND Z8_IR     <> 0 "
ElseIf mv_par11 == 2
	_cQuery += " AND Z8_IR      = 0 "
EndIf
If mv_par12 == 1
	_cQuery += " AND Z8_IRRDR   = '' "
ElseIf mv_par12 == 2
	_cQuery += " AND Z8_IRRDR  <> '' "
EndIf
_cQuery += " AND    Z8_IRTIP   >= '"+mv_par13+"'"
_cQuery += " AND    Z8_IRTIP   <= '"+mv_par14+"'"
If mv_par15 == 1
	_cQuery += " AND Z8_FLUXO   = 'S' "
ElseIf mv_par15 == 2
	_cQuery += " AND Z8_FLUXO   = ''  "
EndIf
If !Empty(aReturn[7])
	_cQuery += U_TransQuery(aReturn[7])
EndIf

U_EndQuery( @_cQuery,_cOrdem, "QUERY", {"SZ8"},,,.T. )

dbSelectArea("QUERY")
dbGoTop()

nLin       := 80






While !EOF()
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	Cabec1:= "Banco: "+ QUERY->Z8_BANCO + " - Agencia: "+ QUERY->Z8_AGENCIA + " / Conta: " +QUERY->Z8_CONTA
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 9
	
	_cBanco      := QUERY->Z8_BANCO
	_cAgencia    := QUERY->Z8_AGENCIA
	_cConta      := QUERY->Z8_CONTA
	
	_nDia_V := 0
	_nDia_B := 0
	_nDia_C := 0
	_nDia_I := 0
	
	_nBco_V    := 0
	_nBco_B    := 0
	_nBco_C    := 0
	_nBco_I    := 0
	_nContCre  := 0
	While !EOF() .And. 	_cConta+_cBanco+_cAgencia == QUERY->Z8_CONTA+QUERY->Z8_BANCO+QUERY->Z8_AGENCIA
		
		If nLin > 65 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
			Cabec1:= "Banco: "+ QUERY->Z8_BANCO + " - Agencia: "+ QUERY->Z8_AGENCIA + " / Conta: " +QUERY->Z8_CONTA
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
		_dEmissao   := DTOS(QUERY->Z8_EMISSAO)
		_dEmis      := QUERY->Z8_EMISSAO
		
		_nDia_V := 0
		_nDia_B := 0
		_nDia_C := 0
		_nDia_I := 0
		
		While !EOF() .And. 	_cConta+_cBanco+_cAgencia+_dEmissao == QUERY->Z8_CONTA+QUERY->Z8_BANCO+QUERY->Z8_AGENCIA+DTOS(QUERY->Z8_EMISSAO)
			
			If nLin > 65 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
				Cabec1:= "Banco: "+ QUERY->Z8_BANCO + " - Agencia: "+ QUERY->Z8_AGENCIA + " / Conta: " +QUERY->Z8_CONTA
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif

			@ nLin, 000 PSay QUERY->Z8_EMISSAO
			@ nLin, 009 PSay "|"
			
			If	!Empty(QUERY->Z8_HIST) .and. QUERY->Z8_IMPFLAG == "S"
				_cHist	:=	Substr(Alltrim(QUERY->Z8_HIST),1,20)
			Else
//				_cHist	:= QUERY->Z8_TIPO+"-"+LEFT(POSICIONE("SZ9",2,xFilial("SZ9")+QUERY->Z8_TIPO,"Z9_TIPO_D"),15)
				_cHist	:= LEFT(POSICIONE("SZ9",2,xFilial("SZ9")+QUERY->Z8_TIPO,"Z9_TIPO_D"),15)
			EndIf
			
			@ nLin, 011 PSay _cHist
			@ nLin, 030 PSay "|"
			@ nLin, 032 PSay LEFT(QUERY->Z8_DEPOS,25)
			@ nLin, 063 PSay "|"
			@ nLin, 065 PSay QUERY->Z8_VALOR Picture "@E 999,999,999.99"
			@ nLin, 080 PSay "|"
			@ nLin, 082 PSay QUERY->Z8_NDOC
			@ nLin, 098 PSay "|"
			@ nLin, 100 PSay QUERY->Z8_NAGE
			@ nLin, 105 PSay "|"
			@ nLin, 107 PSay POSICIONE("SZA",1,xFilial("SZA")+QUERY->Z8_NAGE,"ZA_NAGE_D")
			@ nLin, 138 PSay "|"
			@ nLin, 140 PSay QUERY->Z8_IDENT+"-"+LEFT(POSICIONE("SZB",1,xFilial("SZB")+QUERY->Z8_IDENT,"ZB_IDENT_D"),10)
			@ nLin, 154 PSay "|"
			@ nLin, 156 PSay QUERY->Z8_BA Picture "@E 999,999,999.99"
			@ nLin, 171 PSay "|"
			@ nLin, 173 PSay QUERY->Z8_CI Picture "@E 999,999,999.99"
			@ nLin, 188 PSay "|"
			@ nLin, 190 PSay QUERY->Z8_IR Picture "@E 999,999,999.99"
			//			@ nLin, 205 PSay QUERY->Z8_IRTIP
			@ nLin, 210 PSay "|"
			@ nLin, 212 PSay QUERY->Z8_RDR
			
			If mv_par11<>2 .And. QUERY->Z8_IR<>0
				nLin ++
				@ nLin, 188 PSay "|"
				@ nLin, 190 PSay QUERY->Z8_IR Picture "@E 999,999,999.99"
				If QUERY->Z8_IRTIP == "B"
					@ nLin, 205 PSay "B.A."
				ElseIf QUERY->Z8_IRTIP == "C"
					@ nLin, 205 PSay "C.I."
				ElseIf QUERY->Z8_IRTIP == "D"
					@ nLin, 205 PSay "Dev."
				EndIf
				@ nLin, 210 PSay "|"
				@ nLin, 212 PSay QUERY->Z8_IRRDR
				
				//		    	@ nLin, 205 PSay QUERY->Z8_IRTIP
				//     			@ nLin, 207 PSay "|"
				//	    		@ nLin, 209 PSay QUERY->Z8_IRRDR
				nLin ++
			EndIf
			_nContCre++
			_nDia_V := _nDia_V + QUERY->Z8_VALOR
			_nDia_B := _nDia_B + QUERY->Z8_BA
			_nDia_C := _nDia_C + QUERY->Z8_CI
			_nDia_I := _nDia_I + QUERY->Z8_IR
			
			_nBco_V := _nBco_V + QUERY->Z8_VALOR
			_nBco_B := _nBco_B + QUERY->Z8_BA
			_nBco_C := _nBco_C + QUERY->Z8_CI
			_nBco_I := _nBco_I + QUERY->Z8_IR
			
			_nBcoG_V := _nBcoG_V + QUERY->Z8_VALOR
			_nBcoG_B := _nBcoG_B + QUERY->Z8_BA
			_nBcoG_C := _nBcoG_C + QUERY->Z8_CI
			_nBcoG_I := _nBcoG_I + QUERY->Z8_IR
			
			
			
			dbSelectArea("QUERY")
			dbSkip()
			nLin ++
		EndDo
		
		nLin ++
		@ nLin, 000 PSay "T o t a l  D i a ==> "
//		@ nLin, 011 PSay _dEmis
		@ nLin, 063 PSay "|"
		@ nLin, 065 PSay _nDia_V Picture "@E 999,999,999.99"
		@ nLin, 080 PSay "|"
		@ nLin, 154 PSay "|"
		@ nLin, 156 PSay _nDia_B Picture "@E 999,999,999.99"
		@ nLin, 171 PSay "|"
		@ nLin, 173 PSay _nDia_C Picture "@E 999,999,999.99"
		@ nLin, 188 PSay "|"
		@ nLin, 190 PSay _nDia_I Picture "@E 999,999,999.99"
		@ nLin, 210 PSay "|"
		
		nLin ++
		nLin ++
//		nLin ++
	EndDo
	
	nLin ++
	@ nLin, 000 PSay "T o t a l  B a n c o  ==> "  //+_cBanco+"-"+_cAgencia+"/"+_cConta
	@ nLin, 063 PSay "|"
	@ nLin, 065 PSay _nBco_V Picture "@E 999,999,999.99"
	@ nLin, 080 PSay "|"
	@ nLin, 154 PSay "|"
	@ nLin, 156 PSay _nBco_B Picture "@E 999,999,999.99"
	@ nLin, 171 PSay "|"
	@ nLin, 173 PSay _nBco_C Picture "@E 999,999,999.99"
	@ nLin, 188 PSay "|"
	@ nLin, 190 PSay _nBco_I Picture "@E 999,999,999.99"
	@ nLin, 210 PSay "|"
	nLin ++
	nLin ++
	nLin ++
	@ nLin, 000 PSay "T o t a l  d e  C r e d i t o (s)  ==> " 
	@ nLin, 063 PSay "|"
	@ nLin, 065 PSay _nContCre Picture "@E 999,999,999"
	@ nLin, 080 PSay "|"
    nLin ++
	nLin ++
	
EndDo

If nLin > 65 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
	Cabec1:= "Banco: "+ QUERY->Z8_BANCO + " - Agencia: "+ QUERY->Z8_AGENCIA + " / Conta: " +QUERY->Z8_CONTA
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 9
Endif

nLin ++ 
@ nLin, 000 PSay Replicate("-",220)
nLin ++  
@ nLin, 000 PSay "T O T A L   G E R A L   B A N C O (S)  ==> " //+_cBanco+"-"+_cAgencia+"/"+_cConta
@ nLin, 063 PSay "|"
@ nLin, 065 PSay _nBcoG_V Picture "@E 999,999,999.99"
@ nLin, 080 PSay "|"
@ nLin, 154 PSay "|"
@ nLin, 156 PSay _nBcoG_B Picture "@E 999,999,999.99"
@ nLin, 171 PSay "|"
@ nLin, 173 PSay _nBcoG_C Picture "@E 999,999,999.99"
@ nLin, 188 PSay "|"
@ nLin, 190 PSay _nBcoG_I Picture "@E 999,999,999.99"
@ nLin, 210 PSay "|"
nLin ++
@ nLin, 000 PSay Replicate("-",220)
nLin ++  







//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("QUERY")
dbCloseArea()

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()


Return

