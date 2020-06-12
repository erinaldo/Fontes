#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINR028  บ Autor ณEmerson Natali      บ Data ณ  25/05/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio para analise do Borderos X PAGFOR                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CFINR028(nBorDe, nBorAte)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1	:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2	:= "de acordo com os parametros informados pelo usuario."
Local cDesc3	:= "Analise PAGFOR"
Local titulo	:= "Analise PAGFOR"
Local nLin		:= 80
Local Cabec1	:= "Vencto   Bordero C/C               Valor Modalidade                    Nome Arq."
Local Cabec2	:= ""

Private nBorDe		:= iif(nBorDe==Nil,"",nBorDe)
Private nBorAte		:= iif(nBorAte==Nil,"",nBorAte)

Private lAbortPrint		:= .F.
Private limite			:= 80
Private tamanho			:= "P"
Private nomeprog		:= "CFINR028"
Private nTipo			:= 18
Private aReturn			:= { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey		:= 0
Private m_pag			:= 01
Private wnrel			:= "CFINR028"
Private cString			:= "SEA"

Private _cQuery			:= ""

Private cPerg			:= "CFIR28    "



dbSelectArea("SEA")
dbSetOrder(1)

_fCriaSx1()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Pergunte(cPerg,.F.)

_xGetArea	:= GetArea()
DbSelectArea("SX1")
DbSetOrder(1)
If DbSeek(cPerg+"01")
	RecLock("SX1",.F.)
	SX1->X1_CNT01	:= nBorDe
	MsUnLock()
EndIf
If DbSeek(cPerg+"02")
	RecLock("SX1",.F.)
	SX1->X1_CNT01	:= nBorAte
	MsUnLock()
EndIf

RestArea(_xGetArea)

mv_par01 := nBorDe
mv_par02 := nBorAte

Pergunte(cPerg,.T.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,Tamanho,,.F.)

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

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  25/05/09   บฑฑ
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

_lAnalit := iIf(mv_par08==1,.T.,.F.)

If _lAnalit
	_cQuery := " SELECT EA_NUMBOR, EA_NUMCON, EA_MODELO, E2_VENCREA, E2_VALLIQ as E2_VALOR, E2_PAGFOR "
	_cQuery += " FROM "+RetSqlName("SEA")+" SEA, "+RetSqlName("SE2")+" SE2 "
	_cQuery += " WHERE SEA.D_E_L_E_T_ = '' AND SE2.D_E_L_E_T_ = '' "
	_cQuery += " AND EA_FILIAL = '"+xFilial("SEA")+"' "
	_cQuery += " AND EA_NUMBOR 		= E2_NUMBOR "
	_cQuery += " AND EA_PREFIXO 	= E2_PREFIXO "
	_cQuery += " AND EA_NUM 		= E2_NUM "
	_cQuery += " AND EA_PARCELA 	= E2_PARCELA "
	_cQuery += " AND EA_TIPO 		= E2_TIPO "
	_cQuery += " AND EA_FORNECE 	= E2_FORNECE "
	_cQuery += " AND EA_LOJA 		= E2_LOJA "
	_cQuery += " AND EA_NUMBOR BETWEEN  '"+mv_par01+"' AND '"+mv_par02+"' "
	_cQuery += " AND E2_VENCREA BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"' "
	Do Case
		Case mv_par05 == 1 // Sim - Gerou arquivo. Pega todos os registros que geraram arquivo
			_cQuery += " AND E2_PAGFOR <> '' "
		Case mv_par05 == 2 // Nao - Nao Gerou arquivo. Pega todos os registros que nao geraram arquivo
			_cQuery += " AND E2_PAGFOR = '' "
	EndCase
	Do Case
		Case !Empty(mv_par06)
			_cQuery += " AND E2_PAGFOR = '"+UPPER(mv_par06)+"' "
	EndCase
	Do Case
		Case !Empty(mv_par07)
			_cQuery += " AND EA_MODELO = '"+mv_par07+"' "
	EndCase
	_cQuery += " ORDER BY SEA.EA_NUMCON, SEA.EA_NUMBOR, SEA.EA_MODELO "
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'SEATMP',.T.,.T.)
	TcSetField("SEATMP","E2_VENCREA","D",8, 0 )
Else
	_cQuery := " SELECT EA_NUMBOR, EA_NUMCON, EA_MODELO, E2_VENCREA, SUM(E2_VALLIQ) as E2_VALOR, E2_PAGFOR  "
	_cQuery += " FROM "+RetSqlName("SEA")+" SEA, "+RetSqlName("SE2")+" SE2 "
	_cQuery += " WHERE SEA.D_E_L_E_T_ = '' AND SE2.D_E_L_E_T_ = '' "
	_cQuery += " AND EA_FILIAL = '"+xFilial("SEA")+"' "
	_cQuery += " AND EA_NUMBOR 		= E2_NUMBOR "
	_cQuery += " AND EA_PREFIXO 	= E2_PREFIXO "
	_cQuery += " AND EA_NUM 		= E2_NUM "
	_cQuery += " AND EA_PARCELA 	= E2_PARCELA "
	_cQuery += " AND EA_TIPO 		= E2_TIPO "
	_cQuery += " AND EA_FORNECE 	= E2_FORNECE "
	_cQuery += " AND EA_LOJA 		= E2_LOJA "
	_cQuery += " AND EA_NUMBOR BETWEEN  '"+mv_par01+"' AND '"+mv_par02+"' "
	_cQuery += " AND E2_VENCREA BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"' "
	Do Case
		Case mv_par05 == 1 // Sim - Gerou arquivo. Pega todos os registros que geraram arquivo
			_cQuery += " AND E2_PAGFOR <> '' "
		Case mv_par05 == 2 // Nao - Nao Gerou arquivo. Pega todos os registros que nao geraram arquivo
			_cQuery += " AND E2_PAGFOR = '' "
	EndCase
	Do Case
		Case !Empty(mv_par06)
			_cQuery += " AND E2_PAGFOR = '"+UPPER(mv_par06)+"' "
	EndCase
	Do Case
		Case !Empty(mv_par07)
			_cQuery += " AND EA_MODELO = '"+mv_par07+"' "
	EndCase
	_cQuery += " GROUP BY EA_NUMBOR, EA_NUMCON, EA_MODELO, E2_VENCREA, E2_PAGFOR "
	_cQuery += " ORDER BY SEA.EA_NUMCON, SEA.EA_NUMBOR, SEA.EA_MODELO "
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'SEATMP',.T.,.T.)
	TcSetField("SEATMP","E2_VENCREA","D",8, 0 )
EndIf

dbSelectArea("SEATMP")
SetRegua(RecCount())
dbGoTop()

_aModalid	:= {}

_cCC		:= SEATMP->EA_NUMCON
_cNrBord	:= SEATMP->EA_NUMBOR
_nValCC		:= 0
_nValBord	:= 0

If EOF()
	SEATMP->(DbCloseArea())
	MsgBox("Nao ha registros!!!!","ALERTA")
	Return()
EndIf

While !EOF()

	IncRegua()
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica o cancelamento pelo usuario...                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Impressao do cabecalho do relatorio. . .                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If nLin > 58
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif

/*
          1         2         3         4         5         6         7         8
012345678901234567890123456789012345678901234567890123456789012345678901234567890
Vencto   Bordero C/C               Valor Modalidade                    Nome Arq.
XX/XX/XX XXXXXX  XXXXXXXXXX 9,999,999.99 XX-XXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXX
*/

	If _cCC <> SEATMP->EA_NUMCON
		_cCC		:= SEATMP->EA_NUMCON
		nLin++
		@ nLin,000 PSAY "TOTAL CONTA CORRENTE"
		@ nLin,028 PSAY _nValCC PICTURE "@E 999,999,999.99"
		nLin++
		@ nLin,000 PSAY __PrtThinLine()
		nLin++
		_nValCC	:= 0
	EndIf
	
	@ nLin,000 PSAY SEATMP->E2_VENCREA
	@ nLin,009 PSAY SEATMP->EA_NUMBOR
	@ nLin,017 PSAY SEATMP->EA_NUMCON
	@ nLin,028 PSAY SEATMP->E2_VALOR PICTURE "@E 9,999,999.99"

	_aArea := GetArea()
	DbSelectArea("SX5")
	DbSetOrder(1)
	If DbSeek(xFilial("SX5")+"58"+SEATMP->EA_MODELO,.F.)
		_cDescri := Substr(SX5->X5_DESCRI,1,25)
	Else
		_cDescri := ""
	EndIf
	RestArea(_aArea)

	@ nLin,041 PSAY SEATMP->EA_MODELO+"-"+Alltrim(_cDescri)
	
	_nPos := ascan(_aModalid, {|x| x[1] == SEATMP->EA_MODELO })
	If _nPos > 0
		_aModalid[_nPos, 3] +=SEATMP->E2_VALOR
	Else
		AADD(_aModalid, {SEATMP->EA_MODELO, Alltrim(_cDescri), SEATMP->E2_VALOR })
	EndIf
	
	@ nLin,071 PSAY SEATMP->E2_PAGFOR

	nLin++

	_nValCC 	+= SEATMP->E2_VALOR
	
	SEATMP->(dbSkip())
EndDo

nLin++
@ nLin,000 PSAY "TOTAL CONTA CORRENTE"
@ nLin,028 PSAY _nValCC PICTURE "@E 999,999,999.99"
nLin++
@ nLin,000 PSAY __PrtThinLine()
nLin++
_nValCC	:= 0

SEATMP->(DbCloseArea())

nLin++
nLin++
@ nLin,000 PSAY "TOTAIS POR MODALIDADE"
nLin++
nLin++
For _nY := 1 to Len(_aModalid)
	@ nLin,000 PSAY _aModalid[_nY, 1]+"-"+_aModalid[_nY, 2]
	@ nLin,028 PSAY _aModalid[_nY, 3] PICTURE "@E 999,999,999.99"
	nLin++
Next

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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINR028  บAutor  ณMicrosiga           บ Data ณ  05/27/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
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
             grupo ,ordem ,pergunt          ,perg spa ,perg eng , variav ,tipo,tam,dec,pres,gsc,valid ,var01  ,def01         ,defspa01,defeng01,cnt01,var02,def02         ,defspa02,defeng02 ,cnt02 ,var03 ,def03 ,defspa03 ,defeng03 ,cnt03 ,var04 ,def04 ,defspa04 ,defeng04 ,cnt04 ,var05 ,def05 ,defspa05 ,defeng05,cnt05 ,f3   ,"","","",""
*/
aAdd(aRegs,{cPerg,"01"   ,"Bordero De    ?",""       ,""       ,"mv_ch1","C" ,06 ,0  ,0   ,"G","","mv_par01",""            ,""      ,""      ,""   ,""   ,""            ,""     ,""       ,""    ,""    ,""     ,""       ,""       ,""    ,""    ,""    ,""       ,""       ,""    ,""    ,""    ,""      ,""      ,""   ,""   ,"",""})
aAdd(aRegs,{cPerg,"02"   ,"Bordero Ate   ?",""       ,""       ,"mv_ch2","C" ,06 ,0  ,0   ,"G","","mv_par02",""            ,""      ,""      ,""   ,""   ,""            ,""     ,""       ,""    ,""    ,""     ,""       ,""       ,""    ,""    ,""    ,""       ,""       ,""    ,""    ,""    ,""      ,""      ,""   ,""   ,"",""})
aAdd(aRegs,{cPerg,"03"   ,"Vencto  De    ?",""       ,""       ,"mv_ch3","D" ,08 ,0  ,0   ,"G","","mv_par03",""            ,""      ,""      ,""   ,""   ,""            ,""     ,""       ,""    ,""    ,""     ,""       ,""       ,""    ,""    ,""    ,""       ,""       ,""    ,""    ,""    ,""      ,""      ,""   ,""   ,"",""})
aAdd(aRegs,{cPerg,"04"   ,"Vencto  Ate   ?",""       ,""       ,"mv_ch4","D" ,08 ,0  ,0   ,"G","","mv_par04",""            ,""      ,""      ,""   ,""   ,""            ,""     ,""       ,""    ,""    ,""     ,""       ,""       ,""    ,""    ,""    ,""       ,""       ,""    ,""    ,""    ,""      ,""      ,""   ,""   ,"",""})
aAdd(aRegs,{cPerg,"05"   ,"Gerou Arq.    ?",""       ,""       ,"mv_ch5","C" ,01 ,0  ,0   ,"C","","mv_par05","Sim"         ,""      ,""      ,""   ,""   ,"Nao"         ,""     ,""       ,""    ,""    ,"Todos",""       ,""       ,""    ,""    ,""    ,""       ,""       ,""    ,""    ,""    ,""      ,""      ,""   ,""   ,"",""})
aAdd(aRegs,{cPerg,"06"   ,"Nome  Arq.    ?",""       ,""       ,"mv_ch6","C" ,10 ,0  ,0   ,"G","","mv_par06",""            ,""      ,""      ,""   ,""   ,""            ,""     ,""       ,""    ,""    ,""     ,""       ,""       ,""    ,""    ,""    ,""       ,""       ,""    ,""    ,""    ,""      ,""      ,""   ,""   ,"",""})
aAdd(aRegs,{cPerg,"07"   ,"Modelo        ?",""       ,""       ,"mv_ch7","C" ,02 ,0  ,0   ,"G","","mv_par07",""            ,""      ,""      ,""   ,""   ,""            ,""     ,""       ,""    ,""    ,""     ,""       ,""       ,""    ,""    ,""    ,""       ,""       ,""    ,""    ,""    ,""      ,""      ,""   ,""   ,"",""})
aAdd(aRegs,{cPerg,"08"   ,"Tipo Impressao?",""       ,""       ,"mv_ch8","C" ,01 ,0  ,0   ,"C","","mv_par08","Analitico"   ,""      ,""      ,""   ,""   ,"Sintetico"   ,""     ,""       ,""    ,""    ,""     ,""       ,""       ,""    ,""    ,""    ,""       ,""       ,""    ,""    ,""    ,""      ,""      ,""   ,""   ,"",""})

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