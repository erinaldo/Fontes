#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "SHELL.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ FIGCTR01 บ Ligia Sarnauskas              บ Data ณ 13/11/13 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณ RELATORIO DE IMPRESSรO DE CONTRATOS                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function FIGCTR01()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local   cDesc1      := "Este programa tem como objetivo imprimir relatorio "
Local   cDesc2      := "de contratos"
Local   cDesc3      := ""
Local   cPict       := ""
Local   aOrd        := {}
Local 	aRegs		:= {}
Local   titulo      := "CONTRATOS"
Local   nLin        := 80
Local   Cabec1      := ""
Local   Cabec2      := ""
Local   lImprime    := .T.
Private cString     := ""
Private CbTxt       := ""
Private cPerg       := "GCTR01"
Private lEnd        := .F.
Private lAbortPrint := .F.
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "FIGCTR01"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 2, "Administracao", 2, 2, 2, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private nCONTFL     := 01
Private m_pag       := 01
Private wnrel       := "FIGCTR01"
Private cString     := "CN9"

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

dbSelectArea("TMP")
dbGotop()

SetRegua(TMP->(RecCount()) )

_cContr:=space(15)
_nTotal:=0
_cFornc:=SPACE(08)
_dDtIni:=SPACE(08)
_dDtFim:=SPACE(08)
_cNome:=SPACE(30)
_cCnpj:=SPACE(14)

_cPARC:=space(02)

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
		nLin := 06
	Endif
	
	
	dbSelectArea("TMP")
	
	If ALLTRIM(_cContr) <> ALLTRIM(TMP->CN9_NUMERO)
		
		@nLin,00			Psay	 __PrtThinLine()
		nLin:=nLin+1
		@nLin,00			Psay	 "No CONTRATO: "
		@nLin,15			Psay	 ALLTRIM(TMP->CN9_NUMERO)
		dBSELECTAREA("CNA")
		Dbsetorder(1)
		If Dbseek(xFILIAL("CNA")+TMP->CN9_NUMERO)
		_cFornc:=CNA->CNA_FORNEC+"/"+CNA->CNA_LJFORN
		_dDtIni:=CNA->CNA_DTINI
		_dDtFim:=CNA->CNA_DTFIM
		dBSELECTAREA("SA2")
		Dbsetorder(1)
		If Dbseek(xFILIAL("SA2")+CNA->CNA_FORNEC+CNA->CNA_LJFORN)
		_cNome:=SA2->A2_NOME
		_cCnpj:=SA2->A2_CGC
		Endif
		Endif
		@nLin,50			Psay	 "FORNECEDOR: "
		@nLin,65			Psay	 _cFornc+" - "+_cNome
		@nLin,135			Psay	 "CNPJ: "
		@nLin,145			Psay	 ALLTRIM(_cCnpj)
		nLin:=nLin+2
		@nLin,00			Psay	 "VIGสNCIA: "
		@nLin,15			Psay	 DTOC(_dDtIni)+" a "+DTOC(_dDtFim)
		@nLin,50			Psay	 "QTDE PARCELAS: "
		@nLin,65			Psay	 TMP->CNF_MAXPAR
		nLin:=nLin+2
		_cObj:=""
				
		Dbselectarea("SYP")
		DBsetorder(1)
	    If Dbseek(xFilial("SYP")+TMP->CN9_CODOBJ)
	     While (SYP->YP_FILIAL == xFilial("SYP") .AND. SYP->YP_CHAVE == TMP->CN9_CODOBJ)
         _cObj+=" "+ALLTRIM(SYP->YP_TEXTO)
         replace(_cObj,CHAR(10),', ')
         replace(_cObj,CHAR(13),', ')
	     Dbselectarea("SYP")
	     Dbskip()
	    Enddo
	    Endif                
		
			    
_nLinhas := MlCount(_cObj,220)
For _nX := 1 To _nLinhas
@ nLin,000 PSAY MemoLine(_cObj,220,_nX)
++nLin
Next _nXE
		
		nLin:=nLin+1
		@nLin,00			Psay	 __PrtThinLine()
		nLin:=nLin+1
		@nLin,00			Psay	 "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
		nLin:=nLin+1
		@nLin,00			Psay	 "|                                                                  DESDOBRAMENTO DE CONTRATO                                                                                       |"
		nLin:=nLin+1
		@nLin,00			Psay	 "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
		nLin:=nLin+1
		@nLin,00			Psay	 "|   ITEM   |   SERVICO                                                                                          |            VALOR            |    VENCIMENTO    |   COMPETสNCIA   |"
		nLin:=nLin+1
		@nLin,00			Psay	 "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
		nLin:=nLin+1
	Endif
	 
	//If _cPARC<>TMP->CNF_PARCEL
	@nLin,00			Psay	 "|"
	@nLin,05			Psay    TMP->CNF_PARCEL
	@nLin,11			Psay	 "|"
	@nLin,13    		Psay	ALLTRIM(TMP->CNB_PRODUT)+" - "+TMP->CNB_DESCRI
	@nLin,112			Psay	 "|"
	@nLin,120   		Psay 	TMP->CNF_VLPREV Picture "@E 999,999,999.99"
	@nLin,142			Psay	 "|"
	@nLin,147		    Psay	SUBSTR(TMP->CNF_DTVENC,7,2)+"/"+SUBSTR(TMP->CNF_DTVENC,5,2)+"/"+SUBSTR(TMP->CNF_DTVENC,1,4)
	@nLin,161			Psay	 "|"
	@nLin,166		    Psay	TMP->CNF_COMPET
	@nLin,179			Psay	 "|"
	nLin++  // Incrementa variavel de linha	
	_nSmParc:=0
	//Endif
	_cPARC:=TMP->CNF_PARCEL
	_cContr:=TMP->CN9_NUMERO                                                          
	_nTotal:=_nTotal+TMP->CNF_VLPREV
	dbSelectArea("TMP")
	dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo

If nLin+2 > 54 // Salto de Pแgina. Neste caso o formulario tem 54 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 05
Endif

@nLin,00			Psay	 "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
nLin++
@nLin,00			Psay	 "TOTAL:"
@nLin,120   		Psay 	_nTotal Picture "@E 999,999,999.99"

nLin:=nLin+3
If nLin+5 > 54 // Salto de Pแgina. Neste caso o formulario tem 54 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 06
Endif
@nLin,00			Psay	 "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
nLin++
@nLin,00			Psay	 "|                                                                                           CONTABILIZACAO                                                                                |"
nLin++
@nLin,00			Psay	 "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
nLin++
@nLin,00			Psay	 "|IT|                        CONTA                        |    C.CUSTO                                       |    ITEM CONTมBIL                                      | PERC |    VALOR     |"
nLin++
@nLin,00			Psay	 "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
nLin++

_nTotRat:=0
MontaRAT()
dbSelectArea("RAT")
Dbgotop()
If !EOF()
	While !EOF()
		If nLin > 54 // Salto de Pแgina. Neste caso o formulario tem 54 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 06
		Endif
		@nLin,00			Psay	 "|"
		@nLin,01			Psay     RAT->CNF_PARCEL
		@nLin,03			Psay	 "|"
		_cDescCta:=Posicione( "CT1", 1, xFilial("CT1")+RAT->CNZ_CONTA, "CT1_DESC01" )
		@nLin,04		    Psay	ALLTRIM(RAT->CNZ_CONTA)+" - "+_cDescCta
		_cDescC:=Posicione( "CTT", 1, xFilial("CTT")+RAT->CNZ_CC, "CTT_DESC01" )
		@nLin,57			Psay	 "|"
		@nLin,58		    Psay	ALLTRIM(RAT->CNZ_CC)+" - "+_cDescC
		_cDescIt:=Posicione( "CTD", 1, xFilial("CTD")+RAT->CNZ_ITEMCT, "CTD_DESC01" )
		@nLin,108			Psay	 "|"
		@nLin,109		    Psay	ALLTRIM(RAT->CNZ_ITEMCT)+" - "+_cDescIt
		@nLin,164			Psay	 "|"
		@nLin,165		    Psay	RAT->CNZ_PERC Picture "@E 999.99"
		@nLin,171			Psay	 "|"
		@nLin,172		    Psay	((RAT->CNF_VLPREV/100)*RAT->CNZ_PERC) Picture "@E 999,999,999.99"
		@nLin,186			Psay	 "|"
		nLin++  
			_nTotRat:=_nTotRat+((RAT->CNF_VLPREV/100)*RAT->CNZ_PERC)
		dbSelectArea("RAT")
		Dbskip()
	Enddo
	@nLin,00			Psay	 "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
	nLin++
	@nLin,00			Psay	 "TOTAL CONTABILIZADO: "
	@nLin,172		    Psay	_nTotRat Picture "@E 999,999,999.99"
Else
	dbSelectArea("TMP")
	Dbgotop()
	While !Eof()
		If nLin > 54 // Salto de Pแgina. Neste caso o formulario tem 54 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 06
		Endif
		_nPerc:=100
		@nLin,00			Psay	 "|"
		@nLin,01			Psay    TMP->CNF_PARCEL
		@nLin,03			Psay	 "|"
		_cDescCta:=Posicione( "CT1", 1, xFilial("CT1")+TMP->CNB_CONTA, "CT1_DESC01" )
		@nLin,04		    Psay	ALLTRIM(TMP->CNB_CONTA)+" - "+_cDescCta
		_cDescC:=Posicione( "CTT", 1, xFilial("CTT")+TMP->CNB_CC, "CTT_DESC01" )
		@nLin,57			Psay	 "|"
		@nLin,58		    Psay	ALLTRIM(TMP->CNB_CC)+" - "+_cDescC
		_cDescIt:=Posicione( "CTD", 1, xFilial("CTD")+TMP->CNB_ITEMCT, "CTD_DESC01" )
		@nLin,108			Psay	 "|"
		@nLin,109		    Psay	ALLTRIM(TMP->CNB_ITEMCT)+" - "+_cDescIt
		@nLin,164			Psay	 "|"
		@nLin,165		    Psay	_nPerc Picture "@E 999.99"
		@nLin,171			Psay	 "|"
		@nLin,172		    Psay	TMP->CNF_VLPREV Picture "@E 999,999,999.99"
		@nLin,186			Psay	 "|"
		nLin++
		_nTotRat:=_nTotRat+	TMP->CNF_VLPREV
		dbSelectArea("TMP")
		dbSkip() // Avanca o ponteiro do registro no arquivo
	Enddo
	@nLin,00			Psay	 "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
	nLin++
	@nLin,00			Psay	 "TOTAL CONTABILIZADO: "
	@nLin,172		    Psay	_nTotRat Picture "@E 999,999,999.99"
Endif
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
ฑฑบFuno    ณMontaQry  บ Autor ณ                    บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Query de selecao DOS CONTRATOS                             บฑฑ
ฑฑบ          ณ 													          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function MontaQry()
Local cQuery
Local cEnter := Chr(13)

if Select("TMP") > 0
	dbSelectArea("TMP")
	dbCloseArea()
endif

cQuery := " SELECT " + CRLF
cQuery += "	  CNF_PARCEL        CNF_PARCEL " + CRLF
cQuery += "	, (CNF_VLPREV)   CNF_VLPREV " + CRLF
cQuery += "	, CNF_COMPET    CNF_COMPET " + CRLF
cQuery += "	, CNF_MAXPAR    CNF_MAXPAR " + CRLF
cQuery += "	, CNF_DTVENC    CNF_DTVENC " + CRLF
cQuery += "	, NV.CN9_FILIAL CN9_FILIAL " + CRLF
cQuery += "	, NV.CN9_NUMERO CN9_NUMERO " + CRLF
cQuery += "	, NV.CN9_REVISA CN9_REVISA " + CRLF
cQuery += "	, NV.CN9_CODOBJ CN9_CODOBJ " + CRLF
cQuery += "	, NV.CNB_PRODUT CNB_PRODUT " + CRLF
cQuery += "	, NV.CNB_DESCRI CNB_DESCRI " + CRLF
cQuery += "	, NV.CNB_CONTA  CNB_CONTA  " + CRLF
cQuery += "	, NV.CNB_CC     CNB_CC     " + CRLF
cQuery += "	, NV.CNB_ITEMCT CNB_ITEMCT " + CRLF
cQuery += "	, NV.CNB_RATEIO CNB_RATEIO " + CRLF
cQuery += "	FROM " + RetSqlName("CNF") + " CNF " + CRLF
cQuery += "	, (SELECT SUM(CNB_VLUNIT) CNB_VLUNIT,CN9_FILIAL CN9_FILIAL,CN9_NUMERO CN9_NUMERO,CN9_REVISA CN9_REVISA, CN9_CODOBJ CN9_CODOBJ, CNB_PRODUT CNB_PRODUT, CNB_DESCRI CNB_DESCRI, CNB_CONTA CNB_CONTA, CNB_CC CNB_CC, CNB_ITEMCT CNB_ITEMCT, CNB_RATEIO CNB_RATEIO " + CRLF
cQuery += "	   FROM " + RetSqlName("CN9") + " CN9                                " + CRLF
cQuery += "	   ,    " + RetSqlName("CNB") + " CNB                                " + CRLF
cQuery += "	   WHERE CN9.D_E_L_E_T_ = '  '                                       " + CRLF
cQuery += "    AND CN9.CN9_NUMERO BETWEEN '"+mv_par01 + "' AND '" + mv_par02 + "'" + CRLF
cQuery += "    AND CNB.CNB_FILIAL = CN9.CN9_FILIAL                               " + CRLF
cQuery += "    AND CNB.CNB_CONTRA = CN9.CN9_NUMERO                               " + CRLF
cQuery += "    AND CNB.CNB_REVISA = CN9.CN9_REVISA                               " + CRLF
cQuery += "    AND CNB.D_E_L_E_T_ = ' '                                          " + CRLF
cQuery += "    GROUP BY CN9_FILIAL,CN9_NUMERO,CN9_REVISA,CN9_CODOBJ,CNB_PRODUT,CNB_DESCRI,CNB_CONTA,CNB_CC,CNB_ITEMCT,CNB_RATEIO " + CRLF
cQuery += "    ) NV " + CRLF
cQuery += "   WHERE CNF.CNF_FILIAL = NV.CN9_FILIAL  " + CRLF
cQuery += "   AND CNF.CNF_CONTRA = NV.CN9_NUMERO    " + CRLF
cQuery += "   AND CNF.CNF_REVISA = NV.CN9_REVISA    " + CRLF
cQuery += "   AND CNF.D_E_L_E_T_ = ' '              " + CRLF

// ORDEM
cQuery += " ORDER BY CNF_PARCEL, CNF_VLPREV "

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
ฑฑบDescrio ณ Query de selecao DO RATEIO de contrato                     บฑฑ
ฑฑบ          ณ 													          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function MontaRAT()
Local cQuery
Local cEnter := Chr(13)

if Select("RAT") > 0
	dbSelectArea("RAT")
	dbCloseArea()
endif

cQuery := " SELECT " + CRLF
cQuery += "	  CNZ_CONTRA " + CRLF
cQuery += "	, CNZ_FORNEC " + CRLF
cQuery += "	, CNZ_LJFORN " + CRLF
cQuery += "	, CNZ_PERC   " + CRLF
cQuery += "	, CNZ_CC     " + CRLF
cQuery += "	, CNZ_CONTA  " + CRLF
cQuery += "	, CNZ_ITEMCT " + CRLF
cQuery += "	, CNF_PARCEL " + CRLF
cQuery += "	, (CNF_VLPREV) CNF_VLPREV " + CRLF
cQuery += "	FROM " + RetSqlName("CNZ") + " CNZ " + CRLF
cQuery += "	   , " + RetSqlName("CNF") + " CNF " + CRLF
cQuery += "	WHERE CNZ.D_E_L_E_T_ = '  '            " + CRLF
cQuery += "   AND CNZ.CNZ_NUMMED = ' '             " + CRLF
cQuery += "   AND CNZ.CNZ_PERC <> 0                " + CRLF
cQuery += "   AND CNF.CNF_FILIAL = CNZ.CNZ_FILIAL  " + CRLF
cQuery += "   AND CNF.CNF_CONTRA = CNZ.CNZ_CONTRA  " + CRLF
cQuery += "   AND CNF.CNF_REVISA = CNZ.CNZ_REVISA  " + CRLF
cQuery += "   AND CNF.D_E_L_E_T_ = ' '             " + CRLF

// PARAMETROS
cQuery += " 	AND CNZ.CNZ_CONTRA BETWEEN '"+mv_par01 + "' AND '" + mv_par02 + "'" + CRLF
cQuery += " 	AND CNZ.CNZ_FORNEC BETWEEN '"+mv_par03 + "' AND '" + mv_par04 + "'" + CRLF

// AGRUPAMENTO
cQuery += " GROUP BY CNZ_CONTRA, CNZ_FORNEC, CNZ_LJFORN, CNZ_PERC, CNZ_CC, CNZ_CONTA, CNZ_ITEMCT, CNF_PARCEL, CNF_VLPREV " + CRLF 


// ORDEM
cQuery += " ORDER BY CNF_PARCEL "

cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"RAT", .F., .T.)

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
PutSx1(cPerg,"01","Contrato De   ?     "     ,"Contrato De   ?     "  		,"Contrato De   ?     " 		,"mv_ch1" ,"C",15,0,0,"G","" ,      ,,,"MV_PAR01")
PutSx1(cPerg,"02","Contrato Ate  ?     "     ,"Contrato Ate  ?     "  		,"Contrato Ate  ?     "  		,"mv_ch2" ,"C",15,0,0,"G","" ,      ,,,"MV_PAR02")
PutSx1(cPerg,"03","Fornecedor de ?     "     ,"Fornecedor de ?     "  		,"Fornecedor de ?     " 		,"mv_ch3" ,"C",09,0,0,"G","" ,      ,,,"MV_PAR03")
PutSx1(cPerg,"04","Fornecedor Ate?     "     ,"Fornecedor Ate?     "  		,"Fornecedor Ate?     "  		,"mv_ch4" ,"C",09,0,0,"G","" ,      ,,,"MV_PAR04")
Return Nil
