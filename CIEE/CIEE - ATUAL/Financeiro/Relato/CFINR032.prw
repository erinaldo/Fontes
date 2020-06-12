#INCLUDE "rwmake.ch"
#Include "TopConn.ch"
#include "_FixSX.ch"
#INCLUDE "DelAlias.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CFINR032 บ Autor ณ Patrcia Fontanezi  บ Data ณ  09/10/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de Consulta de Pagamento SE2- LOG                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Relatorio Especifico Ativado pelo CFINC01                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function CFINR032()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private cDesc1 := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2 := "da Tela de Consulta de Pagamento"
Private cDesc3 := "dos Titulos de Contas a Pagar."

Private titulo := "Consulta de Pagamentos"
Private nLin   := 80

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
Private limite       := 220 //132 //220
Private tamanho      := "G" //"M" //"G"
Private nomeprog     := "CFINR032"
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FINR32" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString      := "SE2"
Private _nFL         := 0
Private _lPode       := .F.

Private _aAliases    := {}
Private _aMatriz     := {}
Private cabec1       :="Titulo          Emissao    Fornecedor                 Valor Tit        Valor Liq   Bordero   AP       Cheque   FL          Usuario           Liberacao       Vencto		    Historico"
Private cabec2       :=""

wnrel := SetPrint(cString,NomeProg,,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

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
		Titulo := Alltrim(Titulo) + "  -  CIEE / SP"				
	Case cEmpant == '03'
		Titulo := Alltrim(Titulo) + "  -  CIEE / RJ"				
	Case cEmpant == '05'
		Titulo := Alltrim(Titulo) + "  -  CIEE / NACIONAL"						
EndCase			

RptStatus({|| ImpTela(Cabec1,Cabec2,Titulo,nLin) },Titulo)

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

Static Function ImpTela(Cabec1,Cabec2,Titulo,nLin)

_nSubTotTit := 0
_nSubTotLiq := 0
_nTotalTit  := 0
_nTotalLiq  := 0
_nTotalReg  := 0

dbSelectArea("SE2TMP")
dbGoTop()

_nConta      := 1

If mv_par01==1
	cCondWhile:="!Eof() .And. SE2TMP->E2_VENCREA==_cE2_VENCREA"
Else
	cCondWhile:="!Eof() .And. SE2TMP->E2_NATUREZ==_cE2_NATUREZ"
EndIf


While !Eof()
	
	If mv_par01==1
		_cE2_VENCREA := SE2TMP->E2_VENCREA
	Else
		_cE2_NATUREZ := SE2TMP->E2_NATUREZ
	EndIf
	
	While &(cCondWhile)

		_dConc    := cTod("  /  /  ")
		_cBanco   := Space(03)
		_cAgencia := Space(05)
		_cConta   := Space(10)
		_cCheque  := Space(06)
		
		SE5->(dbSetOrder(7))
		If SE5->(dbSeek(xFilial("SE5")+SE2TMP->E2_PREFIXO+SE2TMP->E2_NUM+SE2TMP->E2_PARCELA+SE2TMP->E2_TIPO+SE2TMP->E2_FORNECE+SE2TMP->E2_LOJA, .F.))
			While !SE5->(Eof()) .And. SE2TMP->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)==SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
				If SE5->(E5_VALOR)==SE2TMP->(E2_VALLIQ) //(E2_VALOR) ALTERADO POR CG EM 08/06/06 CONF CHAMADO 17108
					_cBanco   := SE5->(E5_BANCO)
					_cAgencia := SE5->(E5_AGENCIA)
					_cConta   := SE5->(E5_CONTA)
					
					If SE5->(E5_RECONC) == "x"
						_dConc:=SE5->(E5_DTDISPO)
					EndIf
					Exit
				EndIf
				SE5->(dbSkip())
			EndDo
		EndIf
		
		If !Empty(SE2TMP->E2_NUMAP)
			dbSelectArea("SEF")
//			dbSetOrder(3)
//			If dbSeek(xFilial("SEF")+SE2TMP->E2_PREFIXO+SE2TMP->E2_NUM+SE2TMP->E2_PARCELA+SE2TMP->E2_TIPO,.F.)
			dbSetOrder(8)
			If dbSeek(xFilial("SEF")+SE2TMP->E2_PREFIXO+SE2TMP->E2_NUM+SE2TMP->E2_PARCELA+SE2TMP->E2_TIPO+SE2TMP->E2_FORNECE+SE2TMP->E2_LOJA,.F.)
				_cCheque  := LEFT(SEF->EF_NUM,6)
				_cBanco   := SEF->EF_BANCO
				_cAgencia := SEF->EF_AGENCIA
				_cConta   := SEF->EF_CONTA
				SE5->(dbSetOrder(1))
				If SE5->(dbSeek(xFilial("SE5")+DTOS(SEF->EF_DATA)+SEF->EF_BANCO+SEF->EF_AGENCIA+SEF->EF_CONTA+SEF->EF_NUM, .F.))
					If SE5->(E5_RECONC) == "x"
						_dConc := SE5->(E5_DTDISPO)
					EndIf
				EndIf
			EndIf
		Else
			_cCheque := Space(06)
		EndIf
		
		dbSelectArea("SE2TMP")
		If (mv_par06==2 .Or. mv_par06==3)
			If _dConc<mv_par09 .Or. _dConc>mv_par10 .Or. Empty(_dConc)
				dbSelectArea("SE2TMP")
				DbSkip()
				Loop
			EndIf
		EndIf
		
		If !Empty(SE2TMP->F1_DOC)
			_cUserLG    := FWLeUserlg("SE2TMP->F1_USERLGI")//Embaralha(SE2TMP->F1_USERLGI,1)
			_cUsuario1  := Subs(_cUserLG,1,15)
		Else
			_cUserLG    := FWLeUserlg("SE2TMP->E2_USERLGI")//Embaralha(SE2TMP->E2_USERLGI,1)
			_cUsuario1  := Subs(_cUserLG,1,15)
		EndIf
		
		If SE2TMP->E2_TIPO == "FL "
			_cFL:=SE2TMP->E2_NUM
		Else
			_cFL:=Space(9)
		EndIf
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		If nLin > 55
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
/*
          1         2         3         4         5         6         7         8         9         10        11        12        13       14        15        16        17        18
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
Titulo          Emissao    Fornecedor                 Valor Tit        Valor Liq   Bordero   AP       Cheque   FL          Conta        Natureza   Vencto.    Baixa      Concilacao   Historico
XXX/999999999   99/99/99   XXXXXXXXXXXXXXXXXXX   999,999,999.99   999,999,999.99   999999    999999   999999   999999999   99999999-9   9.99.99    99/99/99   99/99/99   99/99/99     XXXXXXXXXXX
*/

		@ nLin, 000 PSay  SE2TMP->E2_TIPO+"/"+SE2TMP->E2_NUM
		@ nLin, 016 PSay  SE2TMP->E2_EMISSAO
		@ nLin, 027 PSay  SUBSTR(SE2TMP->E2_RAZSOC,1,20)	//Alterado dia 06/10/11 analista Emerson. Aumetamos o campo de 20 para 60 caracteres no relatorio mantem 20
		@ nLin, 049 PSay  SE2TMP->E2_VALOR   Picture "@E 999,999,999.99"
		@ nLin, 066 PSay  SE2TMP->E2_VALLIQ  Picture "@E 999,999,999.99"		
		@ nLin, 083 PSay  SE2TMP->E2_NUMBOR
		@ nLin, 093 PSay  SE2TMP->E2_NUMAP        
		@ nLin, 102 PSay  _cCheque
        @ nLin, 111 PSay  _cFL                    
		@ nLin, 123 PSay  _cUsuario1 //CONTA                
		@ nLin, 141 PSay  SE2TMP->E2_USUALIB //NATUREZA     
		@ nLin, 158 PSay  SE2TMP->E2_VENCREA      
	   //	@ nLin, 158 PSay  SE2TMP->E2_BAIXA        
		//@ nLin, 169 PSay  _dConc                  
		@ nLin, 169 PSay  SE2TMP->E2_HIST         
		
		_nSubTotTit:=_nSubTotTit+SE2TMP->E2_VALOR
		_nSubTotLiq:=_nSubTotLiq+SE2TMP->E2_VALLIQ
		_nTotalTit :=_nTotalTit +SE2TMP->E2_VALOR
		_nTotalLiq :=_nTotalLiq +SE2TMP->E2_VALLIQ
		_nTotalReg++
		
		nLin ++
		
		dbSelectArea("SE2TMP")
		DbSkip()
	EndDo
	If nLin > 55
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	@ nLin, 049 PSay Replicate("-", 14)
	@ nLin, 066 PSay Replicate("-", 14)
	nLin++
	@ nLin, 000 PSay  "SubTotal"
	@ nLin, 049 PSay  _nSubTotTit  Picture "@E 999,999,999.99"
	@ nLin, 066 PSay  _nSubTotLiq  Picture "@E 999,999,999.99"
	_nSubTotTit := 0
	_nSubTotLiq := 0
	nLin ++
	nLin ++

EndDo

nLin ++
nLin ++
If nLin > 55
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 8
Endif
@ nLin, 000 PSay Replicate("-", 73)
nLin++
@ nLin, 000 PSay  "Total"
@ nLin, 049 PSay  _nTotalTit  Picture "@E 999,999,999.99"
@ nLin, 066 PSay  _nTotalLiq  Picture "@E 999,999,999.99"

nLin ++
nLin ++
@ nLin, 000 PSay Replicate("-", 73)
nLin++
@ nLin, 000 PSay  "Total de Registros"
@ nLin, 049 PSay  _nTotalReg  Picture "@E 999,999,999"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

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
