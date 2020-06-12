#INCLUDE "rwmake.ch"
#Include "PROTHEUS.Ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTGER005  บ Autor ณ Emerson Natali     บ Data ณ  05/11/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio Capa de Lote Diario                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CTGER005()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1 	:= OemToAnsi("Este programa ir  imprimir o Di rio Geral Modelo 1, de acordo")
Local cDesc2 	:= OemToAnsi("com os parmetros sugeridos pelo usuario. Este modelo e ideal")
Local cDesc3	:= OemToAnsi("para Plano de Contas que possuam codigos nao muito extensos")
Local Titulo 	:= OemToAnsi("Emissao do Diario Geral")
Local nLin      := 80
Local Cabec1    := "  C O N T A S  C O N T A B E I S                   H I S T O R I C O                          NUMERO              V  A  L  O  R"
Local Cabec2    := "D E B I T O          C R E D I T O                                                           LOTE/DOC          DEBITO        CREDITO"

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private tamanho      := "M"
Private limite       := 132
Private nomeprog     := "CTGER005"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg1       := "CTG005    "  
Private cPerg2       := "CTGER005  "
Private m_pag        := 01
Private wnrel        := "CTGER005"
Private cString      := "CT2"
Private nTotLotGeD   := 0
Private nTotLotGeC   := 0
Private cPerg		 := ""
IF CARQREL == 'SIGAFIN.REW' .OR. CARQREL == 'SIGAFIN.REL' 
	cPerg	:= cPerg2   
ELSE
	cPerg	:= cPerg1
ENDIF
dbSelectArea("CT2")
dbSetOrder(1)

_fCriaSX1()

pergunte(cPerg,.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

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
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  05/11/08   บฑฑ
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

Local dDataFim		:= mv_par02
Local nColDeb		:= 104			// Coluna de impressao do DEBITO
Local nColCrd		:= 119			// Coluna de impressao do CREDITO
Local nTamDeb		:= 13			// Tamanho da coluna de DEBITO
Local nTamCrd		:= 13			// Tamanho da coluna de CREDITO
Local _nValContD	:= 0
Local _nValContC	:= 0
Local nTotLotD		:= 0
Local nTotLotC		:= 0
Local nTotDeb		:= 0
Local nTotCred	 	:= 0
Local nTotDiaD		:= 0
Local nTotDiaC		:= 0
Local nTotMesD		:= 0
Local nTotMesC		:= 0

cMascara := GetMv("MV_MASCARA")

If Alltrim(Str(mv_par03)) == "1"
	cTit1 :="-  EFETIVADO "
ElseIf Alltrim(Str(mv_par03)) == "2"
	cTit1 :="-  PRE-LANCAMENTO " 
Else  
	cTit1 :="-  EFETIVADO / PRE-LANCAMENTO"
EndIf 

Titulo	:= 	OemToAnsi("MOVIMENTACAO DE ") + DTOC(mv_par01) + OemToAnsi(" ATE ") + DTOC(mv_par02) + OemToAnsi(" EM REAIS" ) + OemToAnsi(cTit1)

_cQuery	:= " SELECT * "
_cQuery	+= " FROM " + RetSqlName( "CT2" ) + " "
_cQuery	+= " WHERE D_E_L_E_T_ = '' AND "
_cQuery	+= " CT2_FILIAL = '" + xFilial("CTS") + "' AND "
_cQuery	+= " CT2_LOTE BETWEEN '"+mv_par04+"' AND '"+mv_par05+"' AND "
_cQuery	+= " CT2_DOC  BETWEEN '"+mv_par06+"' AND '"+mv_par07+"' AND "
_cQuery	+= " CT2_DATA BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' "
If Alltrim(Str(mv_par03)) <> "3"
	_cQuery	+= "AND CT2_TPSALD = '"+iif(Alltrim(Str(mv_par03))=="1","1","9")+"' "
EndIf

//PATRICIA FONTANEZI - 21/02/2013
IF CARQREL == 'SIGAFIN.REW' .OR. CARQREL == 'SIGAFIN.REL' 
	If mv_par08 == 1 
		_cQuery	+= " AND CT2_ITEMC <> ' '"
		_cQuery	+= " ORDER BY CT2_HIST "
	Else 
		_cQuery	+= " ORDER BY "+SqlOrder(CT2->(IndexKey(10))) 
	Endif  
ELSE
	_cQuery	+= " ORDER BY "+SqlOrder(CT2->(IndexKey(10))) 
ENDIF
_cQuery := ChangeQuery(_cQuery)
		
dbUseArea( .T. , "TOPCONN" , TcGenQry( , , _cQuery ) , 'CT2TMP' , .F. , .T. )

TcSetField("CT2TMP", "CT2_DATA", "D", 8, 0)

dbSelectArea( "CT2TMP" )
dbGoTop()

SetRegua(RecCount())

_dDataLote	:= DTOS(CT2TMP->CT2_DATA) + CT2TMP->CT2_LOTE
_lFirst		:= .T.

While !EOF()

	IncRegua()
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif

	If nLin > 70

		If nTotDiaD <> 0 .or. nTotDiaC <> 0
			nLin++
			@nLin,055 PSAY OemToAnsi("A Transportar =======>")
			If nTotDiaD <> 0
				ValorCTB(nTotDiaD,nLin,nColDeb,nTamDeb,2,.F.,"@E 999,999,999.99","1")
			EndIf
			If nTotDiaC <> 0
				ValorCTB(nTotDiaC,nLin,nColCrd,nTamCrd,2,.F.,"@E 999,999,999.99","2")
			EndIf
		EndIf

		CtCGCCabec(,,,Cabec1,Cabec2,dDataFim,Titulo,,"2",Tamanho)

		nLin := 11

		If nTotDiaD <> 0 .or. nTotDiaC <> 0
			@ nLin, 000 PSAY STOD(Substr(_dDataLote,1,8))
			@ nLin, 055 PSAY OemToAnsi("De Transporte =======>")
			If nTotDiaD <> 0
				ValorCTB(nTotDiaD,nLin,nColDeb,nTamDeb,2,.F.,"@E 999,999,999.99","1")
			EndIf
			If nTotDiaC <> 0
				ValorCTB(nTotDiaC,nLin,nColCrd,nTamCrd,2,.F.,"@E 999,999,999.99","2")
			EndIf
			nLin++
			nLin++
		EndIf

	Endif

	If _dDataLote <> DTOS(CT2TMP->CT2_DATA) + CT2TMP->CT2_LOTE
		nLin++
		//PATRICIA FONTANEZI - 21/02/2013 - NAO IMPRIMIR COLUNA DE DEBITO QUANDO MV_PAR08 FOR = 1 (SIM)
		@ nLin ,00 		PSAY _nValContD
		@ nLin ,21 		PSAY _nValContC
		@ nLin ,nColDeb	PSAY nTotLotD Picture "@E 999,999,999.99"
		@ nLin ,nColCrd	PSAY nTotLotC Picture "@E 999,999,999.99"
		nLin++
		nLin++
		nTotLotGeD+= _nValContD
		nTotLotGeC+= _nValContC
		If Substr(_dDataLote,1,8) <> DTOS(CT2TMP->CT2_DATA)
			_lFirst	:= .T.
		EndIf
		_dDataLote	:= DTOS(CT2TMP->CT2_DATA) + CT2TMP->CT2_LOTE
		nTotLotD	:= 0
		nTotLotC	:= 0
		_nValContD	:= 0
		_nValContC	:= 0
	EndIf

	If _lFirst
		@ nLin, 000 PSAY DTOC(STOD(Substr(_dDataLote,1,8)))
		nLin++
		_lFirst	:= .F.
	EndIf

	If !Empty(CT2TMP->CT2_DEBITO)
		dbSelectArea("CT1")
		dbSetOrder(1)
		If MsSeek(xFilial("CT1")+CT2TMP->CT2_DEBITO,.F.)
			EntidadeCTB(CT1->CT1_RES,nLin,00,6,.F.,cMascara,"")
			EntidadeCTB(CT2TMP->CT2_CCD,nLin,08,6,.F.,cMascara,"","CTT",1,.F.)
		Else
			EntidadeCTB(CT2TMP->CT2_DEBITO,nLin,00,20,.F.,cMascara,"")
		Endif
	Endif
				
	_nValContD += Val(Alltrim(CT2TMP->CT2_ITEMD)+Alltrim(CT2TMP->CT2_CCD))
	_nValContC += Val(Alltrim(CT2TMP->CT2_ITEMC)+Alltrim(CT2TMP->CT2_CCC))
				
	If !Empty(CT2TMP->CT2_CREDIT)
		dbSelectArea("CT1")
		dbSetOrder(1)
		If MsSeek(xFilial("CT1")+CT2TMP->CT2_CREDIT,.F.)
			EntidadeCTB(CT1->CT1_RES,nLin,21,6,.F.,cMascara,"")
			EntidadeCTB(CT2TMP->CT2_CCC,nLin,28,6,.F.,cMascara,"","CTT",1,.F.)
		Else
			EntidadeCTB(CT2TMP->CT2_CREDIT,nLin,21,20,.F.,cMascara,"")
		Endif
	Endif

	@ nLin, 045 PSAY Substr(CT2TMP->CT2_ORIGEM,1,3)
	@ nLin, 050 PSAY Substr(CT2TMP->CT2_HIST,1,40)
	If CT2TMP->CT2_DC == "1" .Or. CT2TMP->CT2_DC == "2" .Or. CT2TMP->CT2_DC == "3"
		@ nLin, 091 PSAY CT2TMP->CT2_LOTE+"/"+CT2TMP->CT2_DOC
	EndIf

	nValor := &('CT2TMP->CT2_VALOR')
	If CT2TMP->CT2_DC == "1" .Or. CT2TMP->CT2_DC == "3"
		ValorCTB(nValor,nLin,nColDeb,nTamDeb,2,.F.,"@E 999,999,999.99","1")
	EndIf

	If CT2TMP->CT2_DC == "2" .Or. CT2TMP->CT2_DC == "3"
		ValorCTB(nValor,nLin,nColCrd,nTamCrd,2,.F.,"@E 999,999,999.99","2")
	EndIf
				
	If CT2TMP->CT2_DC == "1" .Or. CT2TMP->CT2_DC == "3"
		nTotDeb 	+= &('CT2TMP->CT2_VALOR')
		nTotDiaD	+= &('CT2TMP->CT2_VALOR')
		nTotMesD	+= &('CT2TMP->CT2_VALOR')
		nTotLotD	+= &('CT2TMP->CT2_VALOR')
	EndIf

	If CT2TMP->CT2_DC == "2" .Or. CT2TMP->CT2_DC == "3"
		nTotCred  += &('CT2TMP->CT2_VALOR' )
		nTotdiaC  += &('CT2TMP->CT2_VALOR' )
		nTotMesC  += &('CT2TMP->CT2_VALOR' )
		nTotLotC  += &('CT2TMP->CT2_VALOR' )
	EndIf

	nLin++

	DbSelectArea("CT2TMP")
	CT2TMP->(dbSkip())
EndDo

nTotLotGeD+= _nValContD
nTotLotGeC+= _nValContC

@ nLin ,00 		PSAY _nValContD
@ nLin ,21 		PSAY _nValContC
@ nLin ,nColDeb	PSAY nTotLotD Picture "@E 999,999,999.99"
@ nLin ,nColCrd	PSAY nTotLotC Picture "@E 999,999,999.99"
nLin++
nLin++
// Total Geral impresso
@ nLin ,00 PSAY nTotLotGeD
@ nLin ,21 PSAY nTotLotGeC
IF (nTotDeb + nTotCred) > 0 .And. !lEnd
	@nLin,055 PSAY OemToAnsi("Total Movimentacao  ============>")
	ValorCTB(nTotDeb ,nLin,nColDeb,nTamDeb,2,.F.,"@E 999,999,999.99","1")
	ValorCTB(nTotCred,nLin,nColCrd,nTamCrd,2,.F.,"@E 999,999,999.99","2")
EndIF

DbSelectArea("CT2TMP")
CT2TMP->(dbCloseArea())

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
ฑฑบPrograma  ณNOVO3     บAutor  ณMicrosiga           บ Data ณ  11/05/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _fCriaSX1()

aRegs     := {}  

nSX1Order := SX1->(IndexOrd())
SX1->(dbSetOrder(1))
cPerg := Left(cPerg,10) 

IF CARQREL == 'SIGAFIN.REW' .OR. CARQREL == 'SIGAFIN.REL'
	aAdd(aRegs,{cPerg  ,"01" ,"Data De          ","      ","       ","mv_ch1","D" ,08 ,00 ,0  ,"G",""   ,"mv_par01",""      ,""      ,""      ,""     ,""   ,""               ,""      ,""      ,""    ,""   ,""         ,""      ,""     ,""      ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,"","","",""})
	aAdd(aRegs,{cPerg  ,"02" ,"Data Ate         ","      ","       ","mv_ch2","D" ,08 ,00 ,0  ,"G",""   ,"mv_par02",""      ,""      ,""      ,""     ,""   ,""               ,""      ,""      ,""    ,""   ,""         ,""      ,""     ,""      ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,"","","",""})
	aAdd(aRegs,{cPerg  ,"03" ,"Tipo de Saldo    ","      ","       ","mv_ch3","C" ,01 ,00 ,0  ,"C",""   ,"mv_par03","Real"  ,""      ,""      ,""     ,""   ,"Pre-Lancamento" ,""      ,""      ,""    ,""   ,"Ambos"    ,""      ,""     ,""      ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,"","","",""})
	aAdd(aRegs,{cPerg  ,"04" ,"Lote De          ","      ","       ","mv_ch4","C" ,06 ,00 ,0  ,"G",""   ,"mv_par04",""      ,""      ,""      ,""     ,""   ,""               ,""      ,""      ,""    ,""   ,""         ,""      ,""     ,""      ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,"","","",""})
	aAdd(aRegs,{cPerg  ,"05" ,"Lote Ate         ","      ","       ","mv_ch5","C" ,06 ,00 ,0  ,"G",""   ,"mv_par05",""      ,""      ,""      ,""     ,""   ,""               ,""      ,""      ,""    ,""   ,""         ,""      ,""     ,""      ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,"","","",""})
	aAdd(aRegs,{cPerg  ,"06" ,"Doc. De          ","      ","       ","mv_ch6","C" ,06 ,00 ,0  ,"G",""   ,"mv_par06",""      ,""      ,""      ,""     ,""   ,""               ,""      ,""      ,""    ,""   ,""         ,""      ,""     ,""      ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,"","","",""})
	aAdd(aRegs,{cPerg  ,"07" ,"Doc. Ate         ","      ","       ","mv_ch7","C" ,06 ,00 ,0  ,"G",""   ,"mv_par07",""      ,""      ,""      ,""     ,""   ,""               ,""      ,""      ,""    ,""   ,""         ,""      ,""     ,""      ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,"","","",""})
	aAdd(aRegs,{cPerg  ,"08" ,"Ordenar Hist.    ","      ","       ","mv_ch7","C" ,01 ,00 ,0  ,"C",""   ,"mv_par07","Sim"    ,""      ,""      ,""     ,""   ,"Nใo"               ,""      ,""      ,""    ,""   ,""         ,""      ,""     ,""      ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,"","","",""})
ELSE 
	aAdd(aRegs,{cPerg  ,"01" ,"Data De          ","      ","       ","mv_ch1","D" ,08 ,00 ,0  ,"G",""   ,"mv_par01",""      ,""      ,""      ,""     ,""   ,""               ,""      ,""      ,""    ,""   ,""         ,""      ,""     ,""      ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,"","","",""})
	aAdd(aRegs,{cPerg  ,"02" ,"Data Ate         ","      ","       ","mv_ch2","D" ,08 ,00 ,0  ,"G",""   ,"mv_par02",""      ,""      ,""      ,""     ,""   ,""               ,""      ,""      ,""    ,""   ,""         ,""      ,""     ,""      ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,"","","",""})
	aAdd(aRegs,{cPerg  ,"03" ,"Tipo de Saldo    ","      ","       ","mv_ch3","C" ,01 ,00 ,0  ,"C",""   ,"mv_par03","Real"  ,""      ,""      ,""     ,""   ,"Pre-Lancamento" ,""      ,""      ,""    ,""   ,"Ambos"    ,""      ,""     ,""      ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,"","","",""})
	aAdd(aRegs,{cPerg  ,"04" ,"Lote De          ","      ","       ","mv_ch4","C" ,06 ,00 ,0  ,"G",""   ,"mv_par04",""      ,""      ,""      ,""     ,""   ,""               ,""      ,""      ,""    ,""   ,""         ,""      ,""     ,""      ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,"","","",""})
	aAdd(aRegs,{cPerg  ,"05" ,"Lote Ate         ","      ","       ","mv_ch5","C" ,06 ,00 ,0  ,"G",""   ,"mv_par05",""      ,""      ,""      ,""     ,""   ,""               ,""      ,""      ,""    ,""   ,""         ,""      ,""     ,""      ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,"","","",""})
	aAdd(aRegs,{cPerg  ,"06" ,"Doc. De          ","      ","       ","mv_ch6","C" ,06 ,00 ,0  ,"G",""   ,"mv_par06",""      ,""      ,""      ,""     ,""   ,""               ,""      ,""      ,""    ,""   ,""         ,""      ,""     ,""      ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,"","","",""})
	aAdd(aRegs,{cPerg  ,"07" ,"Doc. Ate         ","      ","       ","mv_ch7","C" ,06 ,00 ,0  ,"G",""   ,"mv_par07",""      ,""      ,""      ,""     ,""   ,""               ,""      ,""      ,""    ,""   ,""         ,""      ,""     ,""      ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,"","","",""})
Endif

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