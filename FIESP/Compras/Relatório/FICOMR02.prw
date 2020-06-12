#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "SHELL.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ FICOMR02 บ Ligia Sarnauskas              บ Data ณ 14/11/13 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณ RELATORIO DE IMPRESSรO DE PRษ NOTAS                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function FICOMR02()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local   cDesc1      := "Este programa tem como objetivo imprimir relatorio "
Local   cDesc2      := "de Pr้ Notas"
Local   cDesc3      := ""
Local   cPict       := ""
Local   aOrd        := {}
Local 	aRegs		:= {}
Local   titulo      := "PRษ NOTA"
Local   nLin        := 80
Local   Cabec1      := ""
Local   Cabec2      := ""
Local   lImprime    := .T.
Private cString     := ""
Private CbTxt       := ""
Private cPerg       := "COMR02"
Private lEnd        := .F.
Private lAbortPrint := .F.
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "FICOMR02"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 2, "Administracao", 2, 2, 2, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private nCONTFL     := 01
Private m_pag       := 01
Private wnrel       := "FICOMR02"
Private cString     := "SD1"
_cCodSol:=space(06)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria perguntas utilizada no relat๓rioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Cria1Sx1(aRegs)
Pergunte(cPerg,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

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
RptStatus({|lEnd| R10RunReport(Cabec1,Cabec2,Titulo,nLin,@lEnd) },Titulo)

Return Nil


Static Function R10RunReport(Cabec1,Cabec2,Titulo,nLin,lEnd)

Local nOrdem := 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

MontaQry()

dbSelectArea("QRY")
dbGotop()

SetRegua(QRY->(RecCount()) )

_cDOC:=space(09)
_cSerie:=SPACE(03)

While !Eof()
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica o cancelamento pelo usuario...                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If lEnd
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Impressao do cabecalho do relatorio. . .                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If nLin > 54 // Salto de Pแgina. Neste caso o formulario tem 54 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 05
	Endif
	
	
	dbSelectArea("QRY")
	
	If ALLTRIM(_cDOC) <> ALLTRIM(QRY->F1_DOC)
		
		@nLin,00			Psay	 __PrtThinLine()
		nLin:=nLin+1
		@nLin,00			Psay	 "DADOS DOCUMENTO DE ENTRADA: "+(QRY->F1_DOC)+" - "+ALLTRIM(QRY->F1_SERIE)+" / "+ALLTRIM(QRY->F1_TIPO)+" / Especie: "+(QRY->F1_ESPECIE)
		nLin:=nLin+2
		@nLin,00			Psay	 "Data Emissใo: "+SUBSTR(QRY->F1_EMISSAO,7,2)+"/"+SUBSTR(QRY->F1_EMISSAO,5,2)+"/"+SUBSTR(QRY->F1_EMISSAO,1,4)
		@nLin,30			Psay	 "Data Digita็ใo: "+SUBSTR(QRY->F1_DTDIGIT,7,2)+"/"+SUBSTR(QRY->F1_DTDIGIT,5,2)+"/"+SUBSTR(QRY->F1_DTDIGIT,1,4)
		@nLin,140			Psay	 "Data Vencimento:    ______ / ______ / ________"
		nLin:=nLin+1
		@nLin,00			Psay	 "Fornecedor: "+(QRY->F1_FORNECE)+"/"+(QRY->F1_LOJA)+" - "+(QRY->A2_NOME)+" - CNPJ/CPF: "+(QRY->A2_CGC)+" - ESTADO: "+(QRY->A2_EST)
		nLin:=nLin+1
		@nLin,00			Psay	 "Valor Total: "
		@nLin,20			Psay	 (QRY->F1_VALBRUT) Picture "@E 999,999,999.99"
		nLin:=nLin+1
		@nLin,00			Psay	 __PrtThinLine()
		nLin:=nLin+1
		@nLin,00			Psay	 "--------------------------------------------------------------------- ITENS NOTA FISCAL ------------------------------------------------------------------------------------------------------------------------------------- "
		nLin:=nLin+2
		@nLin,00			Psay	 "| Item |    Codigo     | UM |  Descri็ใo                   |  Quant  |  Vlr.Unitแrio  |   Vlr.Total    | TES | CFOP |   ICMS   |    IPI   |   ISS    |    INS   |    IR    |   CSLL   |    PIS   |   COFINS                 | "
		nLin++
		
		_cCodUNF:=SUBSTR( EMBARALHA(QRY->F1_USERLGI,1),3,6 ) 
		_cDtSF1:=QRY->F1_DTDIGIT   
		
		_cCodSol:=SPACE(06)
		_cDtSC1:=SPACE(08)
		
		If Select("TMP5") > 0     // Verificando se o alias esta em uso
			dbSelectArea("TMP5")
			dbCloseArea()
		EndIf
		_cQry := "SELECT SD1.D1_PEDIDO PEDIDO, SC7.C7_NUMSC NUMSC, SC1.C1_USER USERSOL, SC1.C1_EMISSAO EMISSAO "
		_cQry += "FROM "+RetSqlName("SD1")+" SD1, "+RetSqlName("SC7")+" SC7, "+RetSqlName("SC1")+" SC1 "
		_cQry += "WHERE SD1.D_E_L_E_T_ = '' AND SC7.D_E_L_E_T_ = '' AND SC1.D_E_L_E_T_ = '' "
		_cQry += "AND SD1.D1_PEDIDO = SC7.C7_NUM "
		_cQry += "AND SC7.C7_NUMSC = SC1.C1_NUM "
		_cQry += "AND SD1.D1_DOC = '"+QRY->F1_DOC+"' "
		_cQry += "AND SD1.D1_SERIE = '"+QRY->F1_SERIE+"' "
		_cQry += "AND SD1.D1_FORNECE = '"+QRY->F1_FORNECE+"' "
		_cQry += "AND SD1.D1_LOJA = '"+QRY->F1_LOJA+"' "
		_cQry += "GROUP BY SD1.D1_PEDIDO, SC7.C7_NUMSC, SC1.C1_USER, SC1.C1_EMISSAO "
		TCQUERY _cQry NEW ALIAS "TMP5"
		
		Dbselectarea("TMP5")
		Dbgotop()
		
		If !EOF()
			_cCodSol:=TMP5->USERSOL
			_cDtSC1:=TMP5->EMISSAO
		Endif		
		
	Endif
	
	MontaTMP()
	
	dbSelectArea("TMP")
	dbGotop()
	_aContab:={}
	
	_nTotal :=0
	_nValIcm:=0
	_nValIpi:=0
	_nValIss:=0
	_nValIns:=0
	_nValIrr:=0
	_nValPis:=0
	_nValCsl:=0
	_nValCof:=0
	
	While !Eof()
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Verifica o cancelamento pelo usuario...                             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		If lEnd
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Impressao do cabecalho do relatorio. . .                            ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		If nLin > 54 // Salto de Pแgina. Neste caso o formulario tem 54 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 05
		Endif
		
		@nLin,00			Psay	 "|"
		@nLin,02			Psay    TMP->D1_ITEM
		@nLin,07			Psay	 "|"
		@nLin,08			Psay	TMP->D1_COD
		@nLin,23			Psay	 "|"
		@nLin,25			Psay	TMP->D1_UM
		@nLin,28			Psay	 "|"
		@nLin,29			Psay    TMP->B1_DESC
		@nLin,59			Psay	 "|"
		@nLin,64			Psay    TMP->D1_QUANT
		@nLin,69			Psay	 "|"
		@nLin,71			Psay    TMP->D1_VUNIT Picture "@E 999,999,999.99"
		@nLin,86			Psay	 "|"
		@nLin,88			Psay    TMP->D1_TOTAL Picture "@E 999,999,999.99"
		@nLin,103			Psay	 "|"
		@nLin,105			Psay    TMP->D1_TES
		@nLin,109			Psay	 "|"
		@nLin,111			Psay    TMP->D1_CF
		@nLin,116			Psay	 "|"
		@nLin,117			Psay    TMP->D1_VALICM Picture "@E 999,999.99"
		@nLin,127			Psay	 "|"
		@nLin,128			Psay    TMP->D1_VALIPI Picture "@E 999,999.99"
		@nLin,138			Psay	 "|"
		@nLin,139			Psay    TMP->D1_VALISS Picture "@E 999,999.99"
		@nLin,149			Psay	 "|"
		@nLin,150			Psay    TMP->D1_VALINS Picture "@E 999,999.99"
		@nLin,160			Psay	 "|"
		@nLin,161			Psay    TMP->D1_VALIRR Picture "@E 999,999.99"
		@nLin,171			Psay	 "|"
		@nLin,172			Psay    TMP->D1_VALIMP4 Picture "@E 999,999.99"
		@nLin,182			Psay	 "|"
		@nLin,183			Psay    TMP->D1_VALIMP5 Picture "@E 999,999.99"
		@nLin,193			Psay	 "|"
		@nLin,194			Psay    TMP->D1_VALIMP6 Picture "@E 999,999.99"
		@nLin,204			Psay	 "|"
		
		_nTotal :=_nTotal+TMP->D1_TOTAL
		_nValIcm:=_nValIcm+TMP->D1_VALICM
		_nValIpi:=_nValIpi+TMP->D1_VALIPI
		_nValIss:=_nValIss+TMP->D1_VALISS
		_nValIns:=_nValIns+TMP->D1_VALINS
		_nValIrr:=_nValIrr+TMP->D1_VALIRR
		_nValPis:=_nValPis+TMP->D1_VALIMP5
		_nValCsl:=_nValCsl+TMP->D1_VALIMP4
		_nValCof:=_nValCof+TMP->D1_VALIMP6
		
		
		aAdd( _aContab, {TMP->D1_DOC, TMP->D1_SERIE,TMP->D1_FORNECE, TMP->D1_LOJA, TMP->D1_FILIAL, TMP->D1_ITEM, TMP->D1_TOTAL, TMP->D1_RATEIO, TMP->D1_CONTA, TMP->D1_ITEMCTA, TMP->D1_CC } )
		
		nLin++
		dbSelectArea("TMP")
		dbSkip() // Avanca o ponteiro do registro no arquivo
	Enddo
	@nLin,00			Psay	 "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- "
	nLin++
	If nLin+2 > 54 // Salto de Pแgina. Neste caso o formulario tem 54 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 05
	Endif
	@nLin,00			Psay	 "| TOTAIS: "
	@nLin,88			Psay    _nTotal Picture "@E 999,999,999.99"
	@nLin,103			Psay	 "|"
	@nLin,116			Psay	 "|"
	@nLin,117			Psay    _nValIcm Picture "@E 999,999.99"
	@nLin,127			Psay	 "|"
	@nLin,128			Psay    _nValIpi Picture "@E 999,999.99"
	@nLin,138			Psay	 "|"
	@nLin,139			Psay    _nValIss Picture "@E 999,999.99"
	@nLin,149			Psay	 "|"
	@nLin,150			Psay    _nValIns Picture "@E 999,999.99"
	@nLin,160			Psay	 "|"
	@nLin,161			Psay    _nValIrr Picture "@E 999,999.99"
	@nLin,171			Psay	 "|"
	@nLin,172			Psay    _nValCsl Picture "@E 999,999.99"
	@nLin,182			Psay	 "|"
	@nLin,183			Psay    _nValPis Picture "@E 999,999.99"
	@nLin,193			Psay	 "|"
	@nLin,194			Psay    _nValCof Picture "@E 999,999.99"
	@nLin,204			Psay	 "|"
	nLin++
	@nLin,00			Psay	 "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- "
	nLin:=nLin+3
	If nLin+4 > 54 // Salto de Pแgina. Neste caso o formulario tem 54 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 05
	Endif
	@nLin,00			Psay	 "----------------------------------------------------------------- RATEIO ---------------------------------------------------------------------------------------------------------------------------------------------------- "
	nLin++
	@nLin,00			Psay	 "| ITEM |                     CONTA                         |             ITEM                                   |   C.CUSTO                                         | PERC(%)|     VALOR    | "
	nLin++
	For n:=1 to len(_aContab)
		If _aContab[n,8] <> "1"
			_nPerc:=100
			
			If nLin > 54 // Salto de Pแgina. Neste caso o formulario tem 54 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 05
			Endif
			@nLin,00			Psay	 "|"
			@nLin,02			Psay	 _aContab[n,6]
			@nLin,07			Psay	 "|"
			@nLin,08			Psay	 ALLTRIM(_aContab[n,9])+"-"+Posicione( "CT1", 1, xFilial("CT1") + _aContab[n,9], "CT1_DESC01" )
			@nLin,59			Psay	 "|"
			@nLin,60			Psay	 ALLTRIM(_aContab[n,10])+"-"+Posicione( "CTD", 1, xFilial("CTD") + _aContab[n,10], "CTD_DESC01" )
			@nLin,112			Psay	 "|"
			@nLin,113			Psay	 ALLTRIM(_aContab[n,11])+"-"+Posicione( "CTT", 1, xFilial("CTT") + _aContab[n,11], "CTT_DESC01" )
			@nLin,164			Psay	 "|"
			@nLin,166			Psay	_nPerc Picture "@E 999.99"
			@nLin,173			Psay	 "|"
			@nLin,174			Psay	_aContab[n,7] Picture "@E 999,999,999.99"
			@nLin,188			Psay	 "|"
			nLin++
		Else
			MontaRAT(_aContab[n,1],_aContab[n,2],_aContab[n,3],_aContab[n,4],_aContab[n,5],_aContab[n,6])
			Dbselectarea("RATEIO")
			Dbgotop()
			While !EOF()
				If nLin > 54 // Salto de Pแgina. Neste caso o formulario tem 54 linhas...
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 05
				Endif
				@nLin,00			Psay	 "|"
				@nLin,02			Psay	 _aContab[n,6]
				@nLin,07			Psay	 "|"
				If EMPTY(RATEIO->DE_CONTA)
					@nLin,08			Psay	 ALLTRIM(_aContab[n,9])+"-"+Posicione( "CT1", 1, xFilial("CT1") + _aContab[n,9], "CT1_DESC01" )
				Else
					@nLin,08			Psay	 ALLTRIM(RATEIO->DE_CONTA)+"-"+Posicione( "CT1", 1, xFilial("CT1") + (RATEIO->DE_CONTA), "CT1_DESC01" )
				Endif
				@nLin,59			Psay	 "|"
				If EMPTY(RATEIO->DE_ITEMCTA)
					@nLin,60			Psay	 ALLTRIM(_aContab[n,10])+"-"+Posicione( "CTD", 1, xFilial("CTD") + _aContab[n,10], "CTD_DESC01" )
				eLSE
					@nLin,60			Psay	 ALLTRIM(RATEIO->DE_ITEMCTA)+"-"+Posicione( "CTD", 1, xFilial("CTD") + (RATEIO->DE_ITEMCTA), "CTD_DESC01" )
				Endif
				@nLin,112			Psay	 "|"
				If EMPTY(RATEIO->DE_CC)
					@nLin,113			Psay	 ALLTRIM(_aContab[n,11])+"-"+Posicione( "CTT", 1, xFilial("CTT") + _aContab[n,11], "CTT_DESC01" )
				Else
					@nLin,113			Psay	 ALLTRIM(RATEIO->DE_CC)+"-"+Posicione( "CTT", 1, xFilial("CTT") + (RATEIO->DE_CC), "CTT_DESC01" )
				Endif
				@nLin,164			Psay	 "|"
				@nLin,166			Psay     RATEIO->DE_PERC Picture "@E 999.99"
				@nLin,173			Psay	 "|"
				If RATEIO->DE_CUSTO1 <= 0
					@nLin,174			Psay	((_aContab[n,7]/100)*RATEIO->DE_PERC) Picture "@E 999,999,999.99"
				Else
					@nLin,174			Psay	RATEIO->DE_CUSTO1 Picture "@E 999,999,999.99"
				Endif
				@nLin,188			Psay	 "|"
				
				Dbselectarea("RATEIO")
				DbSkip()
				nLin++
			Enddo
		Endif
	Next n
	@nLin,00			Psay	 "----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- "
	nLin:=nLin+2
	MontaDUPL()
	Dbselectarea("DUPL")
	Dbgotop()
	If !EOF()
		If nLin+4 > 54 // Salto de Pแgina. Neste caso o formulario tem 54 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 05
		Endif
		@nLin,00			Psay	 "|---------------------- DESDOBRAMENTO DE DUPLICATAS ----------------------| "
		nLin++
		@nLin,00			Psay	 "| PREFIXO |  NUMERO  | PARCELA |   VENCTO   | VENCTO REAL |     VALOR     |"
		nLin++
		While !EOF()
			If nLin > 54 // Salto de Pแgina. Neste caso o formulario tem 54 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 05
			Endif
			@nLin,00			Psay	 "|"
			@nLin,06			Psay	 DUPL->E2_PREFIXO
			@nLin,10			Psay	 "|"
			@nLin,12			Psay	 DUPL->E2_NUM
			@nLin,21			Psay	 "|"
			@nLin,26			Psay	 DUPL->E2_PARCELA
			@nLin,31			Psay	 "|"
			@nLin,33			Psay	 SUBSTR(DUPL->E2_VENCTO,7,2)+"/"+SUBSTR(DUPL->E2_VENCTO,5,2)+"/"+SUBSTR(DUPL->E2_VENCTO,1,4)
			@nLin,44			Psay	 "|"
			@nLin,47			Psay	 SUBSTR(DUPL->E2_VENCREA,7,2)+"/"+SUBSTR(DUPL->E2_VENCREA,5,2)+"/"+SUBSTR(DUPL->E2_VENCREA,1,4)
			@nLin,58			Psay	 "|"
			@nLin,60			Psay     DUPL->E2_VALOR Picture "@E 999,999,999.99"
			@nLin,74			Psay	 "|"
			nLin++
			Dbselectarea("DUPL")
			Dbskip()
		Enddo
		@nLin,00			Psay	 "|-------------------------------------------------------------------------| "
	eNDIF
	nLin:=nLin+3
	If nLin+10 > 54 // Salto de Pแgina. Neste caso o formulario tem 54 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 05
	Endif                   
	
	If empty(_cCodSol )
	_cNomSol  :=""     
	else               
	_cNomSol  :=""     
	PswOrder(2)
	If 	PswSeek(ALLTRIM(_cCodSol),.T.)
		
		// Obtenho o resultado conforme vetor
		_aRetUser := PswRet(1)
		
		_cNomSol  := upper(alltrim(_aRetUser[1,4]))
		
	EndIf                       
	Endif              
	_cNomPre  :=""
	PswOrder(2)
	If 	PswSeek(ALLTRIM(_cCodUNF),.T.)
		
		// Obtenho o resultado conforme vetor
		_aRetUser := PswRet(1)
		
		_cNomPre  := upper(alltrim(_aRetUser[1,4]))
		
	EndIf         	
	
	@nLin,00			Psay	 "|========================================================================| "
	nLin++
	@nLin,00			Psay	 "|                             ELABORADORES                               |"
	nLin++
	@nLin,00			Psay	 "|========================================================================| "
	nLin++
	@nLin,00			Psay	 "| SOLICITANTE   |                                             |          |"
	@nLin,20			Psay	 _cNomSol
	@nLin,64			Psay     SUBSTR(_cDtSC1,7,2)+"/"+SUBSTR(_cDtSC1,5,2)+"/"+SUBSTR(_cDtSC1,1,4)
	nLin++
	@nLin,00			Psay	 "| ELAB.PRษ NF   |                                             |          |"
	@nLin,20			Psay    _cNomPre
	@nLin,64			Psay    SUBSTR(_cDtSF1,7,2)+"/"+SUBSTR(_cDtSF1,5,2)+"/"+SUBSTR(_cDtSF1,1,4)
	nLin++
	@nLin,00			Psay	 "|========================================================================| "
	
	MONTAPROV()
	
	nLin:=nLin+3
	If nLin+10 > 54 // Salto de Pแgina. Neste caso o formulario tem 54 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 05
	Endif
	@nLin,00			Psay	 "|========================================================================| "
	nLin++
	@nLin,00			Psay	 "|                              APROVAวีES                                |"
	nLin++
	@nLin,00			Psay	 "|========================================================================| "
	nLin++
	@nLin,00			Psay	 "| PEDIDO  |  DT.LIBERACAO  |               APROVADOR                     |"
	nLin++
	@nLin,00			Psay	 "|========================================================================| "
	nLin++
	Dbselectarea("APROV")
	Dbgotop()
	While !EOF()
		If nLin > 54 // Salto de Pแgina. Neste caso o formulario tem 54 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 05
		Endif
		@nLin,00			Psay	 "|"
		@nLin,02			Psay	 APROV->D1_PEDIDO
		@nLin,10			Psay	 "|"
		@nLin,14			Psay	 SUBSTR(APROV->CR_DATALIB,7,2)+"/"+SUBSTR(APROV->CR_DATALIB,5,2)+"/"+SUBSTR(APROV->CR_DATALIB,1,4)
		@nLin,27			Psay	 "|"
		@nLin,30			Psay	 APROV->CR_LIBAPRO+" - "+Posicione( "SAK", 1, xFilial("SAK") + (APROV->CR_LIBAPRO), "AK_NOME" )
		@nLin,73			Psay	 "|"
		nLin++
		Dbselectarea("APROV")
		Dbskip()
	Enddo
	@nLin,00			Psay	 "|========================================================================| "
	dbSelectArea("QRY")
	dbSkip() // Avanca o ponteiro do registro no arquivo
	nLin:=55
Enddo


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
dbclosearea( "TMP" )

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออัออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ Programa    ณ CriaSx1  ณ Verifica e cria um novo grupo de perguntas com base nos      บฑฑ
ฑฑบ             ณ          ณ parโmetros fornecidos                                        บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Produ็ใo    ณ 99.99.99 ณ Ignorado                                                     บฑฑ
ฑฑฬอออออออออออออุออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Parโmetros  ณ ExpA1 = array com o conte๚do do grupo de perguntas (SX1)                บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Retorno     ณ Nil                                                                     บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Observa็๕es ณ                                                                         บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Altera็๕es  ณ 99/99/99 - Consultor - Descricao da altera็ใo                           บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑศอออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaSx1(aRegs)

Local aAreaAtu	:= GetArea()
Local aAreaSX1	:= SX1->(GetArea())
Local nJ		:= 0
Local nY		:= 0

dbSelectArea("SX1")
dbSetOrder(1)

For nY := 1 To Len(aRegs)
	If !MsSeek(aRegs[nY,1]+aRegs[nY,2])
		RecLock("SX1",.T.)
		For nJ := 1 To FCount()
			If nJ <= Len(aRegs[nY])
				FieldPut(nJ,aRegs[nY,nJ])
			EndIf
		Next nJ
		MsUnlock()
	EndIf
Next nY

RestArea(aAreaSX1)
RestArea(aAreaAtu)

Return(Nil)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณMontaQRY  บ Autor ณ                    บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Query de selecao DAS NOTAS FISCAIS conforme parametriza็ใo บฑฑ
ฑฑบ          ณ 													          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function MontaQRY()
Local cQuery
Local cEnter := Chr(13)

if Select("QRY") > 0
	dbSelectArea("QRY")
	dbCloseArea()
endif

cQuery := " SELECT " + CRLF
cQuery += "	  F1_DOC     " + CRLF
cQuery += "	, F1_FILIAL  " + CRLF
cQuery += "	, F1_SERIE   " + CRLF
cQuery += "	, F1_FORNECE " + CRLF
cQuery += "	, F1_LOJA    " + CRLF
cQuery += "	, F1_TIPO    " + CRLF
cQuery += "	, F1_EMISSAO " + CRLF
cQuery += "	, F1_DTDIGIT " + CRLF
cQuery += "	, A2_CGC     " + CRLF
cQuery += "	, A2_NOME    " + CRLF
cQuery += "	, A2_NREDUZ  " + CRLF
cQuery += "	, A2_EST     " + CRLF
cQuery += "	, F1_VALBRUT " + CRLF
cQuery += "	, F1_ESPECIE " + CRLF
cQuery += "	, F1_USERLGI " + CRLF   
cQuery += "	FROM " + RetSqlName("SF1") + " SF1 " + CRLF
cQuery += "	, " + RetSqlName("SA2") + " SA2 " + CRLF
cQuery += "	WHERE SF1.D_E_L_E_T_ = '  '            " + CRLF
cQuery += "   AND SA2.A2_COD  = SF1.F1_FORNECE     " + CRLF
cQuery += "   AND SA2.A2_LOJA = SF1.F1_LOJA        " + CRLF
cQuery += "   AND SA2.D_E_L_E_T_ = ' '             " + CRLF

// PARAMETROS
cQuery += " 	AND SF1.F1_DOC     BETWEEN '"+mv_par01 + "' AND '" + mv_par02 + "'" + CRLF
cQuery += " 	AND SF1.F1_SERIE   BETWEEN '"+mv_par03 + "' AND '" + mv_par04 + "'" + CRLF
cQuery += " 	AND SF1.F1_FILIAL  BETWEEN '"+mv_par05 + "' AND '" + mv_par06 + "'" + CRLF
cQuery += " 	AND SF1.F1_FORNECE BETWEEN '"+mv_par07 + "' AND '" + mv_par08 + "'" + CRLF
cQuery += " 	AND SF1.F1_EMISSAO BETWEEN '"+DTOS(mv_par09)+ "' AND '" +DTOS(mv_par10)+ "'" + CRLF
cQuery += " 	AND SF1.F1_DTDIGIT BETWEEN '"+DTOS(mv_par11)+ "' AND '" +DTOS(mv_par12)+ "'" + CRLF

// ORDEM
cQuery += " ORDER BY F1_FILIAL, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA "

cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"QRY", .F., .T.)

dbGotop()

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณMontaTMP  บ Autor ณ                    บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Query de selecao DOS ITENS de notas fiscais                บฑฑ
ฑฑบ          ณ 													          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function MontaTMP()
Local cQuery
Local cEnter := Chr(13)

if Select("TMP") > 0
	dbSelectArea("TMP")
	dbCloseArea()
endif

cQuery := " SELECT " + CRLF
cQuery += "	  D1_DOC     " + CRLF
cQuery += "	, D1_SERIE   " + CRLF
cQuery += "	, D1_FILIAL  " + CRLF
cQuery += "	, D1_ITEM    " + CRLF
cQuery += "	, D1_FORNECE " + CRLF
cQuery += "	, D1_LOJA    " + CRLF
cQuery += "	, D1_TIPO    " + CRLF
cQuery += "	, D1_EMISSAO " + CRLF
cQuery += "	, D1_DTDIGIT " + CRLF
cQuery += "	, D1_COD     " + CRLF
cQuery += "	, D1_UM      " + CRLF
cQuery += "	, D1_QUANT   " + CRLF
cQuery += "	, D1_VUNIT   " + CRLF
cQuery += "	, D1_TOTAL   " + CRLF
cQuery += "	, D1_CF      " + CRLF
cQuery += "	, D1_TES     " + CRLF
cQuery += "	, D1_CONTA   " + CRLF
cQuery += "	, D1_ITEMCTA " + CRLF
cQuery += "	, D1_CC      " + CRLF
cQuery += "	, D1_RATEIO  " + CRLF
cQuery += "	, B1_DESC    " + CRLF
cQuery += "	, D1_VALICM  " + CRLF
cQuery += "	, D1_VALIPI  " + CRLF
cQuery += "	, D1_VALISS  " + CRLF
cQuery += "	, D1_VALINS  " + CRLF
cQuery += "	, D1_VALIRR  " + CRLF
cQuery += "	, D1_VALIMP4 " + CRLF
cQuery += "	, D1_VALIMP5 " + CRLF
cQuery += "	, D1_VALIMP6 " + CRLF
cQuery += "	FROM " + RetSqlName("SD1") + " SD1 " + CRLF
cQuery += "	, " + RetSqlName("SB1") + " SB1 " + CRLF
cQuery += "	WHERE SD1.D_E_L_E_T_ = '  '            " + CRLF
cQuery += "   AND SB1.B1_COD     = SD1.D1_COD      " + CRLF
cQuery += "   AND SB1.D_E_L_E_T_ = ' '             " + CRLF

// PARAMETROS
cQuery += " 	AND SD1.D1_DOC     = '"+(QRY->F1_DOC)+"'     " + CRLF
cQuery += " 	AND SD1.D1_SERIE   = '"+(QRY->F1_SERIE)+"'   " + CRLF
cQuery += " 	AND SD1.D1_FILIAL  = '"+(QRY->F1_FILIAL)+"'  " + CRLF
cQuery += " 	AND SD1.D1_FORNECE = '"+(QRY->F1_FORNECE)+"' " + CRLF
cQuery += " 	AND SD1.D1_LOJA    = '"+(QRY->F1_LOJA)+"'    " + CRLF

// ORDEM
cQuery += " ORDER BY D1_DOC, D1_SERIE, D1_ITEM "

cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TMP", .F., .T.)

dbGotop()

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณMontaRAT  บ Autor ณ                    บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Query de selecao DOS MOVTOS DE RATEIO por item             บฑฑ
ฑฑบ          ณ 													          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function MontaRAT(_cDoc,_cSerie,_cFornece,_cLoja,_cFilial,_cItem)
Local cQuery
Local cEnter := Chr(13)

if Select("RATEIO") > 0
	dbSelectArea("RATEIO")
	dbCloseArea()
endif

cQuery := " SELECT " + CRLF
cQuery += "	  DE_PERC    " + CRLF
cQuery += "	, DE_CUSTO1  " + CRLF
cQuery += "	, DE_CONTA   " + CRLF
cQuery += "	, DE_ITEMCTA " + CRLF
cQuery += "	, DE_CC      " + CRLF
cQuery += "	FROM " + RetSqlName("SDE") + " SDE " + CRLF
cQuery += "	WHERE SDE.D_E_L_E_T_ = '  '            " + CRLF

// PARAMETROS
cQuery += " 	AND SDE.DE_DOC     = '"+(_cDoc)+"'     " + CRLF
cQuery += " 	AND SDE.DE_SERIE   = '"+(_cSerie)+"'   " + CRLF
cQuery += " 	AND SDE.DE_FILIAL  = '"+(_cFilial)+"'  " + CRLF
cQuery += " 	AND SDE.DE_FORNECE = '"+(_cFornece)+"' " + CRLF
cQuery += " 	AND SDE.DE_LOJA    = '"+(_cLoja)+"'    " + CRLF
cQuery += " 	AND SDE.DE_ITEMNF  = '"+(_cItem)+"'    " + CRLF

// ORDEM
cQuery += " ORDER BY DE_CC "

cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"RATEIO", .F., .T.)

dbGotop()

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณMontaDUPL บ Autor ณ                    บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Query de selecao AS DUPLICATAS geradas pela NF             บฑฑ
ฑฑบ          ณ 													          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function MontaDUPL()
Local cQuery
Local cEnter := Chr(13)

if Select("DUPL") > 0
	dbSelectArea("DUPL")
	dbCloseArea()
endif

cQuery := " SELECT " + CRLF
cQuery += "	  E2_NUM     " + CRLF
cQuery += "	, E2_PREFIXO " + CRLF
cQuery += "	, E2_PARCELA " + CRLF
cQuery += "	, E2_FORNECE " + CRLF
cQuery += "	, E2_LOJA    " + CRLF
cQuery += "	, E2_FILIAL  " + CRLF
cQuery += "	, E2_VALOR   " + CRLF
cQuery += "	, E2_VENCTO  " + CRLF
cQuery += "	, E2_VENCREA " + CRLF
cQuery += "	FROM " + RetSqlName("SE2") + " SE2 " + CRLF
cQuery += "	WHERE SE2.D_E_L_E_T_ = '  '            " + CRLF

// PARAMETROS
cQuery += " 	AND SE2.E2_NUM     = '"+(QRY->F1_DOC)+"'     " + CRLF
cQuery += " 	AND SE2.E2_PREFIXO = '"+(QRY->F1_SERIE)+"'   " + CRLF
cQuery += " 	AND SE2.E2_FILIAL  = '"+(QRY->F1_FILIAL)+"'  " + CRLF
cQuery += " 	AND SE2.E2_FORNECE = '"+(QRY->F1_FORNECE)+"' " + CRLF
cQuery += " 	AND SE2.E2_LOJA    = '"+(QRY->F1_LOJA)+"'    " + CRLF
// ORDEM
cQuery += " ORDER BY E2_PARCELA "

cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"DUPL", .F., .T.)

dbGotop()

Return Nil


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณMONTAPROV() บ Autor ณ                    บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Query de selecao DAS APROVAวีES vinculadas a NF            บฑฑ
ฑฑบ          ณ 													          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function MONTAPROV()
Local cQuery
Local cEnter := Chr(13)

if Select("APROV") > 0
	dbSelectArea("APROV")
	dbCloseArea()
endif

cQuery := " SELECT " + CRLF
cQuery += "	  D1_PEDIDO  " + CRLF
cQuery += "	, CR_NIVEL   " + CRLF
cQuery += "	, CR_STATUS  " + CRLF
cQuery += "	, CR_DATALIB " + CRLF
cQuery += "	, CR_USERLIB " + CRLF
cQuery += "	, CR_LIBAPRO " + CRLF
cQuery += "	FROM " + RetSqlName("SF1") + " SF1,    " + CRLF
cQuery += "	     " + RetSqlName("SD1") + " SD1,    " + CRLF
cQuery += "	     " + RetSqlName("SCR") + " SCR,    " + CRLF
cQuery += "	WHERE SF1.D_E_L_E_T_ = '  '            " + CRLF
cQuery += "	  AND SD1.D1_FILIAL = SF1.F1_FILIAL    " + CRLF
cQuery += "	  AND SD1.D1_DOC = SF1.F1_DOC          " + CRLF
cQuery += "	  AND SD1.D1_SERIE = SF1.F1_SERIE      " + CRLF
cQuery += "	  AND SD1.D1_FORNECE = SF1.F1_FORNECE  " + CRLF
cQuery += "	  AND SD1.D1_LOJA = SF1.F1_LOJA        " + CRLF
cQuery += "	  AND SD1.D_E_L_E_T_ = '  '            " + CRLF
cQuery += "	  AND SCR.CR_FILIAL = SD1.D1_FILIAL    " + CRLF
cQuery += "	  AND SCR.CR_NUM = SD1.D1_PEDIDO       " + CRLF
cQuery += "	  AND (SCR.CR_STATUS = '03' OR SCR.CR_STATUS = '04')              " + CRLF
cQuery += "	  AND SCR.D_E_L_E_T_ = ' '             " + CRLF

// PARAMETROS

cQuery += "	  AND SF1.F1_DOC     = '"+(QRY->F1_DOC)+"'     " + CRLF
cQuery += "	  AND SF1.F1_SERIE   = '"+(QRY->F1_SERIE)+"'   " + CRLF
cQuery += "	  AND SF1.F1_FILIAL  = '"+(QRY->F1_FILIAL)+"'  " + CRLF
cQuery += "	  AND SF1.F1_FORNECE = '"+(QRY->F1_FORNECE)+"' " + CRLF
cQuery += "	  AND SF1.F1_LOJA    = '"+(QRY->F1_LOJA)+"'    " + CRLF
//AGRUPAMENTO
cQuery += "	  GROUP BY D1_PEDIDO, CR_NIVEL, CR_STATUS,CR_DATALIB, CR_USERLIB, CR_LIBAPRO " + CRLF

// ORDEM
cQuery += " ORDER BY CR_NIVEL "

cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"APROV", .F., .T.)

dbGotop()

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณCriaSX1   บ Autor ณ Ligia Sarnauskas   บ Data ณ  13/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Monta as perguntas no SX1.								  บฑฑ
ฑฑบ          ณ 													          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico - FIESP                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function Cria1Sx1(cPerg)
PutSx1(cPerg,"01","NF De         ?     "     ,"NF De         ?     "  		,"NF De         ?     " 		,"mv_ch1" ,"C",09,0,0,"G","" ,      ,,,"MV_PAR01")
PutSx1(cPerg,"02","NF Ate        ?     "     ,"NF Ate        ?     "  		,"NF Ate        ?     "  		,"mv_ch2" ,"C",09,0,0,"G","" ,      ,,,"MV_PAR02")
PutSx1(cPerg,"03","Serie de      ?     "     ,"Serie de      ?     "  		,"Serie de      ?     " 		,"mv_ch3" ,"C",03,0,0,"G","" ,      ,,,"MV_PAR03")
PutSx1(cPerg,"04","Serie Ate     ?     "     ,"Serie Ate     ?     "  		,"Serie Ate     ?     "  		,"mv_ch4" ,"C",03,0,0,"G","" ,      ,,,"MV_PAR04")
PutSx1(cPerg,"05","Filial de     ?     "     ,"Filial de     ?     "  		,"Filial de     ?     " 		,"mv_ch5" ,"C",02,0,0,"G","" ,      ,,,"MV_PAR05")
PutSx1(cPerg,"06","Filial Ate    ?     "     ,"Filial Ate    ?     "  		,"Filial Ate    ?     "  		,"mv_ch6" ,"C",02,0,0,"G","" ,      ,,,"MV_PAR06")
PutSx1(cPerg,"07","Fornecedor de ?     "     ,"Fornecedor de ?     "  		,"Fornecedor de ?     " 		,"mv_ch7" ,"C",09,0,0,"G","" ,      ,,,"MV_PAR07")
PutSx1(cPerg,"08","Fornecedor Ate?     "     ,"Fornecedor Ate?     "  		,"Fornecedor Ate?     "  		,"mv_ch8" ,"C",09,0,0,"G","" ,      ,,,"MV_PAR08")
PutSx1(cPerg,"09","Emissใo de    ?     "     ,"Emissใo de    ?     "  		,"Emissใo de    ?     " 		,"mv_ch9" ,"D",08,0,0,"G","" ,      ,,,"MV_PAR09")
PutSx1(cPerg,"10","Emissใo Ate   ?     "     ,"Emissใo Ate   ?     " 		,"Emissใo Ate   ?     "  		,"mv_chA" ,"D",08,0,0,"G","" ,      ,,,"MV_PAR10")
PutSx1(cPerg,"11","Digitacao de  ?     "     ,"Digitacao de  ?     "  		,"Digitacao de  ?     " 		,"mv_chB" ,"D",08,0,0,"G","" ,      ,,,"MV_PAR11")
PutSx1(cPerg,"12","Digitacao Ate ?     "     ,"Digitacao Ate ?     "  		,"Digitacao Ate ?     "  		,"mv_chC" ,"D",08,0,0,"G","" ,      ,,,"MV_PAR12")
Return Nil
