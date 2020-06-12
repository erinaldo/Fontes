#INCLUDE "PROTHEUS.CH"
#INCLUDE "TopConn.Ch"
#INCLUDE "FONT.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FIFINR01 บ Autor ณ TOTVS              บ Data ณ  23/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Impressao de Boletos Bancarios                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function FIFINR01

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local oDlg 		:= NIL
Local oProcess 	:= NIL
Local cPerg 	:= "FIFINR01"
Local nOpc		:= 0

Private cCodBanco	:= "001"
Private cNomBanco	:= "BANCO DO BRASIL"
Private cDVBanco	:= ""
Private aRadio  	:= {}
Private nRadio 		:= 1
Private oRadio  	:= Nil

aAdd( aRadio, {"Banco do Brasil","001","9"} )
/*
aAdd( aRadio, {"Caixa Economica Federal","104","0"} )
aAdd( aRadio, {"Ita๚","341","7"} )
aAdd( aRadio, {"Santander","033","7"} )
aAdd( aRadio, {"Banrisul","041","8"} )
*/
ValidPerg(cPerg)

DEFINE MSDIALOG oDlg FROM 0,0 TO 125,250 PIXEL TITLE "Selecione o Banco"

@ 001,003 TO 060,085 LABEL "" OF oDlg PIXEL
//@ 008,008 RADIO oRadio VAR nRadio ITEMS aRadio[1][1],aRadio[2][1],aRadio[3][1],aRadio[4][1],aRadio[5][1] SIZE 070,009 PIXEL OF oDlg
@ 008,008 RADIO oRadio VAR nRadio ITEMS aRadio[1][1] SIZE 070,009 PIXEL OF oDlg

DEFINE SBUTTON FROM 003,095 TYPE 1 OF oDlg ENABLE ONSTOP "Confirmar" ACTION (nOpc:=1,oDlg:End())
DEFINE SBUTTON FROM 020,095 TYPE 2 OF oDlg ENABLE ONSTOP "Sair" ACTION (nOpc:=0,oDlg:End())

ACTIVATE MSDIALOG oDlg CENTER

If nOpc == 1
	
	cCodBanco := aRadio[nRadio][2]
	cDVBanco := aRadio[nRadio][3]
	
	If Pergunte(cPerg,.t.).and.U_FINR03VB()
		oProcess := MsNewProcess():New( { | lEnd | Imprime( @lEnd,oProcess ) }, "Atualizando", "Aguarde, atualizando ...", .F. )
		oProcess:Activate()
	Endif
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FIFINR01 บ Autor ณ TOTVS              บ Data ณ  23/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function Imprime(lEnd,oProcess)

Local cQuery 	:= ""
Local cAliasTMP := GetNextAlias()
Local cAliasTRB := GetNextAlias()
Local cNomArqTrb:= ""
Local nTotRegs 	:= 0
Local nProcRegs := 0
Local aEstrut 	:= SE1->(dbStruct())
Local nI, nCntFOr

//--- Objetos da Dialog
Local oDlg
Local oChk
Local oInv
Local oMark
Local nOpc := 0

//--- MarkBrowse
Local aCampos	:= {}
Private lInverte:= .F.
Private cMarca  := GetMark()
Private lTodos  := .T.
Private lChang  := .T.

Private oPrn    	:= NIL

Private oFont1	:= TFont():New("Arial",,13.5,,.T./*Bold*/,,,,,.F./*Underline*/)
Private oFont2 	:= TFont():New("Arial",,13,,.T.,,,,,.F.)
Private oFont3	:= TFont():New("Arial",,6,,.F.,,,,,.F.)
Private oFont4	:= TFont():New("Arial",,8,,.F.,,,,,.F.)
Private oFont5 	:= TFont():New("Courier",,6,,.T.,,,,,.F.)
Private oFont6 	:= TFont():New("Arial",,8,,.T.,,,,,.F.)
Private oFont7 	:= TFont():New("Arial",,18,,.t.,,,,,.f. )
Private oFont8	:= TFont():New("Arial",,14,,.t.,,,,,.f. )
Private oFont9	:= TFont():New("Arial",,9,,.F.,,,,,.F.)
Private oFont10	:= TFont():New("Arial",,9,,.T.,,,,,.F.)
Private oFont11	:= TFont():New("Arial",,7,,.F.,,,,,.F.)
Private oFont12	:= TFont():New("Courier",,6,,.F.,,,,,.F.)
Private oFontCep:= TFont():New("ECTpostnet",,16,,.T.,,,,,.F.)

Private oFont1 		:= TFont():New("Arial"      		,09,08,,.F.,,,,,.F.) //Titulos dos Campos
Private oFont2 		:= TFont():New("Arial"      		,09,10,,.F.,,,,,.F.)//Conteudo dos Campos
Private oFont3Bold 	:= TFont():New("Arial Black"		,09,14,,.T.,,,,,.F.)//Nome do Banco
Private oFont4 		:= TFont():New("Arial"      		,09,12,,.T.,,,,,.F.)//Dados do Recibo de Entrega
Private oFont5 		:= TFont():New("Arial"      		,09,14,,.T.,,,,,.F.)//Codigo de Compensa็ใo do Banco
Private oFont6 		:= TFont():New("Arial"          	,09,14,,.T.,,,,,.F.)//Codigo de Compensa็ใo do Banco
Private oFont7 		:= TFont():New("Arial"           	,09,10,,.T.,,,,,.F.)//Conteudo dos Campos em Negrito
Private oFont8 		:= TFont():New("Arial"           	,09,09,,.F.,,,,,.F.)//Dados do Cliente
Private oFont9 		:= TFont():New("Times New Roman" 	,09,14,,.T.,,,,,.F.)//Linha Digitavel


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Campos visualizados no MarkBrowse ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAdd( aCampos, { "E1_OK"		 ,, "" } )
aAdd( aCampos, { "E1_FILIAL"	 ,, "Filial" } )
aAdd( aCampos, { "E1_PREFIXO"	 ,, "Prefixo" } )
aAdd( aCampos, { "E1_NUM"	 	 ,, "Numero" } )
aAdd( aCampos, { "E1_PARCELA"	,, "Parcela" } )
aAdd( aCampos, { "E1_TIPO"		,, "Tipo" } )
aAdd( aCampos, { "E1_NATUREZ"	,, "Natureza" } )
aAdd( aCampos, { "E1_CLIENTE"	,, "Cliente" } )
aAdd( aCampos, { "E1_LOJA"		,, "Loja" } )
aAdd( aCampos, { "E1_NOMCLI"	,, "Descri็ใo" } )
aAdd( aCampos, { "E1_VALOR"		,, "Valor" ,PesqPict("SE1", "E1_VALOR"	)} )
aAdd( aCampos, { "E1_VENCTO"	,, "Vencimento" } )
aAdd( aCampos, { "E1_VENCREA"	,, "Vencimento Real" } )
aAdd( aCampos, { "E1_PORTADO"	,, "Banco" } )
aAdd( aCampos, { "E1_AGEDEP"	,, "Agencia" } )
aAdd( aCampos, { "E1_CONTA"		,, "Conta" } )
aAdd( aCampos, { "E1_NUMBCO"	,, "Nosso Numero" } )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria o arquivo temporario ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cNomArqTRB := CriaTrab( aEstrut, .T. )
dbUseArea( .T.,,cNomArqTRB, cAliasTRB, .F., .F. )

IndRegua( cAliasTRB, cNomArqTRB,"E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA",,,"Criando Indice, aguarde..." )
dbClearIndex()
dbSetIndex( cNomArqTRB + OrdBagExt() )

// Query dos Titulos em Aberto
cQuery :=  "SELECT * "
cQuery +=  "FROM "+RetSqlName("SE1")
cQuery +=  " WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND "
cQuery +=  "(E1_PORTADO = '"+MV_PAR01+"' OR E1_PORTADO = '') AND "
cQuery +=  "(E1_AGEDEP = '"+MV_PAR02+"' OR E1_AGEDEP = '') AND "
cQuery +=  "(E1_CONTA = '"+MV_PAR03+"' OR E1_CONTA = '') AND "
cQuery +=  "E1_PREFIXO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND "
cQuery +=  "E1_NUM BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' AND "
cQuery +=  "E1_PARCELA BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' AND "
cQuery +=  "E1_TIPO BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"' AND "
cQuery +=  "E1_CLIENTE BETWEEN '"+MV_PAR13+"' AND '"+MV_PAR14+"' AND "
cQuery +=  "E1_LOJA BETWEEN '"+MV_PAR15+"' AND '"+MV_PAR16+"' AND "
cQuery +=  "E1_VENCREA BETWEEN '"+Dtos(MV_PAR17)+"' AND '"+Dtos(MV_PAR18)+"' AND "
cQuery +=  "E1_SALDO > 0 AND "
cQuery +=  "D_E_L_E_T_ = '' "
cQuery := ChangeQuery(cQuery)

If Select(cAliasTMP) > 0
	dbSelectArea(cAliasTMP)
	dbCloseArea()
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTMP,.T.,.F.)

For nCntFor := 1 To Len(aEstrut)
	If ( aEstrut[nCntFor,2]<>"C" )
		TcSetField(cAliasTMP,aEstrut[nCntFor,1],aEstrut[nCntFor,2],aEstrut[nCntFor,3],aEstrut[nCntFor,4])
	EndIf
Next nCntFor

DbSelectArea(cAliasTMP)
dbGotop()

If !Eof(cAliasTMP)
	
	dbEval( {|x| nTotRegs++ },,{|| (cAliasTMP)->(!EOF())})
	oProcess:SetRegua1(nTotRegs)
	oProcess:IncRegua1("Iniciando processamento...")
	oProcess:SetRegua2(nTotRegs)
	oProcess:IncRegua2()
	
	dbSelectArea(cAliasTMP)
	dbGotop()
	
	// Cria TRB a partir do resultado da Query
	While !Eof(cAliasTMP)
		
		nProcRegs++
		oProcess:IncRegua1("Processando item: "+CValToChar(nProcRegs)+" / "+CValToChar(nTotRegs))
		oProcess:IncRegua2()
		
		(cAliasTRB)->(DbAppend())
		For nI := 1 To Len(aEstrut)//nTotRegs
			If  (cAliasTRB)->(FieldPos((cAliasTMP)->( FieldName( ni )))) > 0
				(cAliasTRB)->(FieldPut(nI ,;
				(cAliasTMP)->(FieldGet( ;
				(cAliasTMP)->(FieldPos( ;
				(cAliasTRB)->(FieldName( ni ))))))))
			EndIf
		Next
		(cAliasTMP)->(DbSkip())
	EndDo
	(cAliasTMP)->(dbCloseArea())
Endif

// MarkBrowse
dbSelectArea(cAliasTRB)
dbGotop()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a Tela com MsSelect e Objetos de Check Box ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DEFINE FONT oFont NAME "Mono AS" SIZE 8,15 BOLD

DEFINE MSDIALOG oDlg TITLE "Sele็ใo de Tํtulos em Aberto" From 7,0 To 29,80

oMark := MsSelect():New(cAliasTRB,"E1_OK",,aCampos, @lInverte, @cMarca, { 13, 0, 140, 318 } )

oMark:oBrowse:lhasMark := .T.
oMark:oBrowse:bAllMark := {|| U_SIFR03In( oMark,cAliasTRB ) }  // Na verdade, esse comando esta desabilitado pela instrucao de cima

@ 145,010 CHECKBOX oChk VAR lTodos PROMPT "Marca/Desmarca Todos" SIZE 80,7 COLOR CLR_HBLUE OF oDlg PIXEL ON CLICK U_SIFR03In( oMark,cAliasTRB ); lTodos := .F.; oChk:oFont := oDlg:oFont
@ 145,110 CHECKBOX oInv VAR lChang PROMPT "Inverte Sele็ใo" SIZE 80,7 COLOR CLR_HBLUE OF oDlg PIXEL ON CLICK U_SIFR03Cg( oMark,cAliasTRB ); lChang := .F.; oChk:oFont := oDlg:oFont

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg, {||( nOpc := 1, oDlg:End() )}, {||(nOpc := 0, oDlg:End())},,) CENTERED

DeleteObject( oMark )
DeleteObject( oDlg )
DeleteObject( oChk )
DeleteObject( oInv )

If nOpc == 1
	
	xGeraBol(cAliasTRB)
	
	DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE "Impressใo" OF oDlg PIXEL
	@ 004,010 TO 082,157 LABEL "" OF oDlg PIXEL
	
	@ 015,017 SAY "Esta rotina tem por objetivo imprimir" OF oDlg PIXEL Size 150,010  COLOR CLR_HBLUE
	@ 030,017 SAY "boletos bancแrios.                   " OF oDlg PIXEL Size 150,010  COLOR CLR_HBLUE
	@ 045,017 SAY "" OF oDlg PIXEL Size 150,010 COLOR CLR_HBLUE
	
	@  6,167 BUTTON "&Imprime" SIZE 036,012 ACTION oPrn:Print()   OF oDlg PIXEL
	@ 28,167 BUTTON "&Setup"   SIZE 036,012 ACTION oPrn:Setup()   OF oDlg PIXEL
	@ 49,167 BUTTON "Pre&view" SIZE 036,012 ACTION oPrn:Preview() OF oDlg PIXEL
	@ 70,167 BUTTON "Sai&r"    SIZE 036,012 ACTION oDlg:End()     OF oDlg PIXEL
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
Endif

If Select(cAliasTRB) != 0
	dbSelectArea(cAliasTRB)
	dbCloseArea()
	FErase(cNomArqTrb+GetDBExtension())
	FErase(cNomArqTrb+OrdBagExt())
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FIFINR01 บ Autor ณ TOTVS              บ Data ณ  23/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/


Static Function xGeraBol(cAliasTRB)

Local cStartPath := GetSrvProfString("StartPath","")
Local cBmp 		:= ""
Local nLin 		:= 0
Local nLinMsg	:= 0
Local nLinDg	:= 0
Local cCodCep 	:= ""
Local cCodBarra := ""
Local cLDigit 	:= ""
Local cCCedente	:= ""  
Local cConvenio := ""
Local aObserv	:= {}
Local nTamMem	:= 12
Private cDigNnum := ""
Private cNossoNum := ""

cBMP  := cStartPath+"BOL_"+cEmpAnt+cFilAnt+".bmp"
If !File(cBMP)
	cBMP := cStartPath+"BOL_"+cEmpAnt+".bmp"
Endif

dbSelectArea(cAliasTRB)
dbGoTop()

oPrn:=TMSPrinter():New("Boleto Bancแrio")
oPrn:SetPortrait() // ou SetLandscape()

While !EOF(cAliasTRB)
	
	If (cAliasTRB)->E1_OK == cMarca
		
		//Posicionamento de Arquivos
		dbSelectArea("SE1")
		dbSetOrder(1)
		dbSeek((cAliasTRB)->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO))
		
		If Empty(SE1->E1_PORTADO)
			RecLock("SE1",.F.)
			SE1->E1_PORTADO := MV_PAR01
			SE1->E1_AGEDEP	:= MV_PAR02
			SE1->E1_CONTA	:= MV_PAR03
			MsUnLock()
		Endif
		
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA))
		
		dbSelectArea("SA6")
		dbSetOrder(1)
		dbSeek(xFilial("SA6")+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA))
		
		dbSelectArea("SEE")
		dbSetOrder()                                                              
		dbSeek(xFilial("SEE")+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA+mv_par04))
		
		cCCedente 	:= SE1->E1_CONTA

		If Empty(SE1->E1_NUMBCO)
			If dbSeek(xFilial("SEE")+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA+mv_par04))
				//Trata Nosso Numero
				NossoNum()
				cNossoNum := ALLTRIM(STR(VAL(SE1->E1_NUMBCO)))
			Endif
		
			If cCodBanco == '001' // Banco do Brasil						
				cDigNNum := DigMod11(cNossoNum,20,90)
			Else
				cNossoNum := SE1->E1_NUMBCO  
				cDigNNum  := DigMod10(cNossoNum)
			Endif
			
			// Atualiza Nosso Numero com Digito
			dbSelectArea("SE1")
			RecLock("SE1",.F.)            
				SE1->E1_NUMBCO := cNossoNum+Alltrim(cDigNNum)
				SE1->E1_IDCNAB := SUBSTR(SE1->E1_NUMBCO,7,6)
			MsUnLock()
		Else                                           
			cNossoNum := Substr(SE1->E1_NUMBCO,1, Len(Alltrim(SE1->E1_NUMBCO))-1)
			cDigNNum  := Substr(SE1->E1_NUMBCO,Len(Alltrim(SE1->E1_NUMBCO)), Len(Alltrim(SE1->E1_NUMBCO)))
		Endif	
		
	oprn:startpage()
//-----------------------------------------------------------------------------------------------//
//Primeira Parte
//-----------------------------------------------------------------------------------------------//
	oPrn:Say(050,0100,Substr(cNomBanco,1,35)			,oFont3Bold,100)
	oprn:say(050,0700,"| "+cCodBanco+"-"+cDVBanco+" |"	,oFont5,100)
	oPrn:Say(060,1550,"RECIBO SACADO"					,oFont4,100)
//-----------------------------------------------------------------------------------------------//
	oPrn:Box(130,0100,0210,1500)
	oprn:say(130,0120,"Local de Pagamento"				,oFont1,100)
	oPrn:Box(130,1500,0210,2200)
	oprn:say(130,1520,"Vencimento"						,oFont1,100)
	oprn:say(160,0120,"PAGมVEL EM QUALQUER BANCO ATE O VENCIMENTO"	,oFont1,100)
	oprn:say(160,2000,DtoC(SE1->E1_VENCTO)				,oFont7,100)
//-----------------------------------------------------------------------------------------------//
	oPrn:Box(210,0100,0290,1500)
	oprn:say(210,0120,"Cedente"					,oFont1,100)
	oPrn:Box(210,1500,0290,2200)
	oprn:say(210,1520,"Ag๊ncia/C๓digo Cedente"	,oFont1,100)
	oprn:say(240,0120,SM0->M0_NOMECOM+" "+transform(SM0->M0_CGC,"@R 99.999.999/9999-99")	,oFont1,100)
	_cAgCC := SE1->E1_AGEDEP+" "+SA6->A6_DVAGE+"/"+Alltrim(cCCedente)+"-"+SA6->A6_DVCTA
	oprn:say(240,1700,_cAgCC					,oFont7,100)
//-----------------------------------------------------------------------------------------------//	
	oPrn:Box(290,0100,0370,0350)
	oprn:say(290,0120,"Dt Documento"		   	   			,oFont1,100)
	oPrn:Box(290,0350,0370,0700)
	oprn:say(290,0370,"N๚mero do Documento"	   				,oFont1,100)
	oPrn:Box(290,0700,0370,0850)
	oprn:say(290,0720,"Esp.Doc."			  	  			,oFont1,100)
	oPrn:Box(290,0850,0370,1060)
	oprn:say(290,0870,"Aceite"				  	  			,oFont1,100)
	oPrn:Box(290,1060,0370,1500)
	oprn:say(290,1080,"Data Processamento"	   	 			,oFont1,100)
	oPrn:Box(290,1500,0370,2200)
	oprn:say(290,1520,"Nosso N๚mero"		  				,oFont1,100)
	oprn:say(320,0120,DtoC(SE1->E1_EMISSAO)					,oFont2,100)
	oprn:say(320,0370,SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA)	,oFont2,100)
	oprn:say(320,0720,SE1->E1_TIPO							,oFont2,100)
	oprn:say(320,0870,"N"									,oFont2,100)
	oprn:say(320,1090,Dtoc(DDATABASE)						,oFont2,100)
	oPrn:say(320,1700,Alltrim(cNossoNum)+"-"+cDigNNum		,oFont7,100)
//-----------------------------------------------------------------------------------------------//	
	oPrn:Box(370,0100,0450,0350)
	oprn:say(370,0120,"Uso do Banco"										,oFont1,100)
	oPrn:Box(370,0350,0450,0500)
	oprn:say(370,0370,"Carteira"											,oFont1,100)
	oPrn:Box(370,0500,0450,0650)
	oprn:say(370,0520,"Esp้cie"												,oFont1,100)
	oPrn:Box(370,0650,0450,1060)
	oprn:say(370,0670,"Quantidade"											,oFont1,100)
	oPrn:Box(370,1060,0450,1500)
	oprn:say(370,1090,"Valor"												,oFont1,100)
	oPrn:Box(370,1500,0450,2200)
	oprn:say(370,1520,"(=) Valor do Documento"								,oFont1,100)
	oprn:say(400,370,SEE->EE_XCART											,oFont2,100)
	oprn:say(400,520,"R$"													,oFont2,100)
	oprn:say(400,1750,transform(SE1->E1_SALDO,PesqPict("SE1","E1_SALDO"))	,oFont7,100)
//-----------------------------------------------------------------------------------------------//	
/*
	oprn:say(530,0200,"NOME DO RECEBEDOR (legivel)"	,oFont4,100)
	oprn:say(530,0900,Repl("_",50)					,oFont4,100)
	oprn:say(630,0200,"ASSINATURA DO RECEBEDOR"		,oFont4,100)
	oprn:say(630,0900,Repl("_",50)					,oFont4,100)
	oprn:say(730,0200,"DATA DO RECEBIMENTO"			,oFont4,100)
	oprn:say(730,0900,Repl("_",50)					,oFont4,100)
*/
//-----------------------------------------------------------------------------------------------//	
	oPrn:Box(0450,0100,850,1500)
	oprn:say(0450,0120,"Instru็๕es",oFont1,100)
	oPrn:Box(0450,1500,530,2200)
	oprn:say(0450,1520,"(-) Desconto/Abatimento",oFont1,100)
//-----------------------------------------------------------------------------------------------//	
	oPrn:Box(0530,1500,610,2200)
	oprn:say(0530,1520,"(-) Outras Dedu็๕es",oFont1,100)
//-----------------------------------------------------------------------------------------------//	
	oPrn:Box(0610,1500,690,2200)
	oprn:say(0610,1520,"(+) Mora/Multa",oFont1,100)
//-----------------------------------------------------------------------------------------------//	
	oPrn:Box(0690,1500,770,2200)
	oprn:say(0690,1520,"(+) Outros Acr้scimos",oFont1,100)
//-----------------------------------------------------------------------------------------------//	
	oPrn:Box(0770,1500,850,2200)
	oprn:say(0770,1520,"(=) Valor Cobrado",oFont1,100)
//-----------------------------------------------------------------------------------------------//		
	oprn:say(0600,0120,"Texto de Responsabilidade do Cedente"	,oFont2,100)
	oprn:say(0640,0120,"                                    " ,oFont2,100)
	oprn:say(0680,0120,"APำS VENCTO COBRAR MULTA DE"+Transform(SEE->EE_XMULTA,PesqPict("SEE","EE_XMULTA")),oFont2,100)
	oprn:say(0720,0120,"                                    " ,oFont2,100)
	oprn:say(0760,0120,"                                    " ,oFont2,100)
//-----------------------------------------------------------------------------------------------//	
	oPrn:Box(0850,0100,1020,2200)
	oprn:say(0850,0120,"Sacado"							,oFont1,100)
	_cSacado := Alltrim(SA1->A1_NOME)+" - CNPJ:"+Iif(SA1->A1_PESSOA=="J",transform(SA1->A1_CGC,"@R 99.999.999/9999-99"),transform(SA1->A1_CGC,"@R 999.999.999-99"))
	oprn:say(0870,0250,_cSacado							,oFont8,100)
	_cEnd := IF(EMPTY(SA1->A1_ENDCOB),SA1->A1_END,SA1->A1_ENDCOB)+" "+IF(EMPTY(SA1->A1_BAIRROC),SA1->A1_BAIRRO,SA1->A1_BAIRROC)
	oprn:say(0910,0250,_cEnd							,oFont8,100)
	_cCep := IF(EMPTY(SA1->A1_CEPC),Transform(SA1->A1_CEP,"@R 99999-999"),Transform(SA1->A1_CEPC,"@R 99999-999"))+" - "+IF(EMPTY(SA1->A1_MUNC),AllTrim(SA1->A1_MUN),AllTrim(SA1->A1_MUNC))+"/"+IF(EMPTY(SA1->A1_ESTC),SA1->A1_EST,SA1->A1_ESTC)
	oprn:say(0950,0250,_cCep							,oFont8,100)
	oprn:say(0990,0120,"Sacador/Avalista",oFont1,100)
	oprn:say(1010,0010,Repl("-",1800),oFont1,100)
//-----------------------------------------------------------------------------------------------//
//Segunda Parte
//-----------------------------------------------------------------------------------------------//
	oPrn:Say(001030,0100,Substr(cNomBanco,1,35)			,oFont3Bold,100)
	oprn:say(001030,0700,"| "+cCodBanco+"-"+cDVBanco+" |"	,oFont5,100)
	oPrn:Say(001050,1700,"FICHA DE CAIXA"					,oFont4,100)
//-----------------------------------------------------------------------------------------------//	
	oPrn:Box(001110,0100,1190,1500)
	oprn:say(001110,0120,"Local de Pagamento"				,oFont1,100)
	oPrn:Box(001110,1500,1190,2200)
	oprn:say(001110,1520,"Vencimento"						,oFont1,100)
	oprn:say(001140,0120,"PAGมVEL EM QUALQUER BANCO ATE O VENCIMENTO",oFont1,100)
	oprn:say(001140,2000,DtoC(SE1->E1_VENCTO)				,oFont7,100)
//-----------------------------------------------------------------------------------------------//	
	oPrn:Box(001190,0100,1270,1500)
	oprn:say(001190,0120,"Cedente"						,oFont1,100)
	oPrn:Box(001190,1500,1270,2200)
	oprn:say(001190,1520,"Ag๊ncia/C๓digo Cedente"		,oFont1,100)
	oprn:say(001220,0120,SM0->M0_NOMECOM+" "+transform(SM0->M0_CGC,"@R 99.999.999/9999-99")				,oFont1,100)
//	_cAgCC := SE1->E1_AGEDEP+" "+SA6->A6_DVAGE+"/"+Alltrim(cCCedente)+" "+SA6->A6_DVCTA
	oprn:say(001220,1700,_cAgCC							,oFont7,100)
//-----------------------------------------------------------------------------------------------//		
	oPrn:Box(001270,0100,1350,0350)
	oprn:say(001270,0120,"Dt Documento"				 			,oFont1,100)
	oPrn:Box(001270,0350,1350,0700)
	oprn:say(001270,0370,"N๚mero do Documento"		 			,oFont1,100)
	oPrn:Box(001270,0700,1350,0850)
	oprn:say(001270,0720,"Esp.Doc."					 			,oFont1,100)
	oprn:say(001270,0870,"Aceite"					 			,oFont1,100)
	oPrn:Box(001270,0850,1350,1060)
	oprn:say(001270,1080,"Data Processamento"		  			,oFont1,100)
	oPrn:Box(001270,1060,1350,1500)
	oprn:say(001270,1520,"Nosso N๚mero"					   		,oFont1,100)
	oPrn:Box(001270,1500,1350,2200)
	oprn:say(001300,0120,DtoC(SE1->E1_EMISSAO)					,oFont2,100)
	oprn:say(001300,0370,SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA)	,oFont2,100)
	oprn:say(001300,0720,SE1->E1_TIPO							,oFont2,100)
	oprn:say(001300,0870,"N"									,oFont2,100)
	oprn:say(001300,1090,Dtoc(DDATABASE)						,oFont2,100)
	If Len(Alltrim(SEE->EE_CODEMP)) == 7
		oPrn:say(001300,1700,Alltrim(SEE->EE_CODEMP)+ Alltrim(cNossoNum)	,oFont7,100)
	Else                                                               
		oPrn:say(001300,1700,Alltrim(cNossoNum)+"-"+cDigNNum				,oFont7,100)
	Endif	
//-----------------------------------------------------------------------------------------------//		
	oPrn:Box(001350,0100,1430,0350)
	oprn:say(001350,0120,"Uso do Banco"				,oFont1,100)
	oPrn:Box(001350,0350,1430,0500)
	oprn:say(001350,0370,"Carteira"					,oFont1,100)
	oPrn:Box(001350,0500,1430,0650)
	oprn:say(001350,0520,"Esp้cie"					,oFont1,100)
	oPrn:Box(001350,0650,1430,1060)
	oprn:say(001350,0670,"Quantidade"				,oFont1,100)
	oPrn:Box(001350,1060,1430,1500)
	oprn:say(001350,1090,"Valor"					,oFont1,100)
	oPrn:Box(001350,1500,1430,2200)
	oprn:say(001350,1520,"(=) Valor do Documento"	,oFont1,100)
	oprn:say(001380,370,SEE->EE_XCART										,oFont2,100)
	oprn:say(001380,520,"R$"												,oFont2,100)
	oprn:say(001380,1750,transform(SE1->E1_SALDO,PesqPict("SE1","E1_SALDO")),oFont7,100)
//-----------------------------------------------------------------------------------------------//	
	oPrn:Box(001430,0100,1830,1500)
	oprn:say(001430,0120,"Instru็๕es",oFont1,100)
	oPrn:Box(001430,1500,1510,2200)
	oprn:say(001430,1520,"(-) Desconto/Abatimento",oFont1,100)
//-----------------------------------------------------------------------------------------------//	
	oPrn:Box(001510,1500,1590,2200)
	oprn:say(001510,1520,"(-) Outras Dedu็๕es",oFont1,100)
//-----------------------------------------------------------------------------------------------//	
	oPrn:Box(001590,1500,1670,2200)
	oprn:say(001600,1520,"(+) Mora/Multa",oFont1,100)
//-----------------------------------------------------------------------------------------------//	
	oPrn:Box(001670,1500,1750,2200)
	oprn:say(001670,1520,"(+) Outros Acr้scimos",oFont1,100)
//-----------------------------------------------------------------------------------------------//	
	oPrn:Box(001750,1500,1830,2200)
	oprn:say(001750,1520,"(=) Valor Cobrado",oFont1,100)
//-----------------------------------------------------------------------------------------------//		
	oprn:say(001580,0120,"Texto de Responsabilidade do Cedente"	,oFont2,100)
	oprn:say(001620,0120,"                                    " ,oFont2,100)
	oprn:say(001660,0120,"APำS VENCTO COBRAR MULTA DE"+Transform(SEE->EE_XMULTA,PesqPict("SEE","EE_XMULTA")),oFont2,100)
	oprn:say(001700,0120,"                                    " ,oFont2,100)
	oprn:say(001740,0120,"                                    " ,oFont2,100)
//-----------------------------------------------------------------------------------------------//		
	oPrn:Box(001830,0100,2020,2200)
	oprn:say(001830,0120,"Sacado",oFont1,100)
	_cSacado := Alltrim(SA1->A1_NOME)+" - CNPJ:"+Iif(SA1->A1_PESSOA=="J",transform(SA1->A1_CGC,"@R 99.999.999/9999-99"),transform(SA1->A1_CGC,"@R 999.999.999-99"))
	oprn:say(001830,0250,_cSacado,oFont8,100)
	oprn:say(001870,1500,transform(SA1->A1_INSCR,"@R 999.999.999-99"),oFont8,100)
	_cEnd := IF(EMPTY(SA1->A1_ENDCOB),SA1->A1_END,SA1->A1_ENDCOB)+" "+IF(EMPTY(SA1->A1_BAIRROC),SA1->A1_BAIRRO,SA1->A1_BAIRROC)
	oprn:say(001870,0250,_cEnd,oFont8,100)
	_cCep := IF(EMPTY(SA1->A1_CEPC),Transform(SA1->A1_CEP,"@R 99999-999"),Transform(SA1->A1_CEPC,"@R 99999-999"))+" - "+IF(EMPTY(SA1->A1_MUNC),AllTrim(SA1->A1_MUN),AllTrim(SA1->A1_MUNC))+"/"+IF(EMPTY(SA1->A1_ESTC),SA1->A1_EST,SA1->A1_ESTC)
	oprn:say(001910,0250,_cCep,oFont8,100)
	oprn:say(001980,0120,"Sacador/Avalista",oFont1,100)
	oprn:say(001980,1520,"C๓d.Baixa",oFont1,100)
	oprn:say(001980,1720,"Autentica็ใo Mecโnica",oFont1,100)
	oprn:say(002030,0010,replicate("-",1800),oFont1,100)
//-----------------------------------------------------------------------------------------------//		
//Terceira Parte
//-----------------------------------------------------------------------------------------------//	
	oPrn:Say(002080,0100,Substr(cNomBanco,1,35)			,oFont3Bold,100)
	oprn:say(002080,0700,"| "+cCodBanco+"-"+cDVBanco+" |"	,oFont5,100)

	//Codigo de Barras
	cCodBarra := CodBarra()
	// Monta Linha Digitavel
	cLDigit := LinhaDgt(cCodBarra)
	//Impressใo da Linha Digitavel
	oPrn:Say(002085,0910,cLDigit,oFont9,100)
//-----------------------------------------------------------------------------------------------//		
	oPrn:Box(002160,0100,2240,1500)
	oprn:say(002160,0120,"Local de Pagamento",oFont1,100)
	oPrn:Box(002160,1500,2240,2200)
	oprn:say(002160,1520,"Vencimento",oFont1,100)
	oprn:say(002190,0120,"PAGมVEL EM QUALQUER BANCO ATE O VENCIMENTO",oFont1,100)
	oprn:say(002190,2000,DtoC(SE1->E1_VENCTO),oFont7,100)
//-----------------------------------------------------------------------------------------------//		
	oPrn:Box(002240,0100,2320,1500)
	oprn:say(002240,0120,"Cedente"						,oFont1,100)
	oPrn:Box(002240,1500,2320,2200)
	oprn:say(002240,1520,"Ag๊ncia/C๓digo Cedente"		,oFont1,100)
	oprn:say(002270,0120,SM0->M0_NOMECOM+" "+transform(SM0->M0_CGC,"@R 99.999.999/9999-99")				,oFont1,100)
//	_cAgCC := SE1->E1_AGEDEP+" "+SA6->A6_DVAGE+"/"+Alltrim(cCCedente)+" "+SA6->A6_DVCTA
	oprn:say(002270,1700,_cAgCC							,oFont7,100)
//-----------------------------------------------------------------------------------------------//		
	oPrn:Box(002320,0100,2400,0350)
	oprn:say(002320,0120,"Dt Documento"						   		,oFont1,100)
	oPrn:Box(002320,0350,2400,0700)
	oprn:say(002320,0370,"N๚mero do Documento"		   		   		,oFont1,100)
	oPrn:Box(002320,0700,2400,0850)
	oprn:say(002320,0720,"Esp.Doc."									,oFont1,100)
	oPrn:Box(002320,0850,2400,1060)
	oprn:say(002320,0870,"Aceite"									,oFont1,100)
	oPrn:Box(002320,1060,2400,1500)
	oprn:say(002320,1080,"Data Processamento"						,oFont1,100)
	oPrn:Box(002320,1500,2400,2200)
	oprn:say(002320,1520,"Nosso N๚mero"								,oFont1,100)
	oprn:say(002350,0120,DtoC(SE1->E1_EMISSAO)						,oFont2,100)
	oprn:say(002350,0370,SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA)		,oFont2,100)
	oprn:say(002350,0720,SE1->E1_TIPO								,oFont2,100)
	oprn:say(002350,0870,"N"										,oFont2,100)
	oprn:say(002350,1090,Dtoc(DDATABASE)							,oFont2,100)
	If Len(Alltrim(SEE->EE_CODEMP)) == 7
		oPrn:say(002350,1700,Alltrim(SEE->EE_CODEMP)+ Alltrim(cNossoNum),oFont7,100)
	Else                                                               
		oPrn:say(002350,1700,Alltrim(cNossoNum)+"-"+cDigNNum,oFont7,100)
	Endif	
//-----------------------------------------------------------------------------------------------//		
	oPrn:Box(002400,0100,2480,0350)
	oprn:say(002400,0120,"Uso do Banco"					,oFont1,100)
	oPrn:Box(002400,0350,2480,0500)
	oprn:say(002400,0370,"Carteira"						,oFont1,100)
	oPrn:Box(002400,0500,2480,0650)
	oprn:say(002400,0520,"Esp้cie"						,oFont1,100)
	oPrn:Box(002400,0650,2480,1060)
	oprn:say(002400,0670,"Quantidade"					,oFont1,100)
	oPrn:Box(002400,1060,2480,1500)
	oprn:say(002400,1090,"Valor"						,oFont1,100)
	oPrn:Box(002400,1500,2480,2200)
	oprn:say(002400,1520,"(=) Valor do Documento"		,oFont1,100)
	oprn:say(002430,0370,SEE->EE_XCART					,oFont2,100)
	oprn:say(002430,0520,"R$"							,oFont2,100)
	oprn:say(002430,1750,transform(SE1->E1_SALDO,PesqPict("SE1","E1_SALDO")),oFont7,100)
//-----------------------------------------------------------------------------------------------//		
	oPrn:Box(002480,0100,2880,1500)
	oprn:say(002480,0120,"Instru็๕es",oFont1,100)
	oPrn:Box(002480,1500,2560,2200)
	oprn:say(002480,1520,"(-) Desconto/Abatimento",oFont1,100)
//-----------------------------------------------------------------------------------------------//		
	oPrn:Box(002560,1500,2640,2200)
	oprn:say(002560,1520,"(-) Outras Dedu็๕es",oFont1,100)
//-----------------------------------------------------------------------------------------------//		
	oPrn:Box(002640,1500,2720,2200)
	oprn:say(002640,1520,"(+) Mora/Multa",oFont1,100)
//-----------------------------------------------------------------------------------------------//		
	oPrn:Box(002720,1500,2800,2200)
	oprn:say(002720,1520,"(+) Outros Acr้scimos",oFont1,100)
//-----------------------------------------------------------------------------------------------//		
	oPrn:Box(002800,1500,2880,2200)
	oprn:say(002800,1520,"(=) Valor Cobrado",oFont1,100)
//-----------------------------------------------------------------------------------------------//		
	oprn:say(002620,0120,"Texto de Responsabilidade do Cedente",oFont2,100)
	oprn:say(002660,0120,"                                    ",oFont2,100)
	oprn:say(002700,0120,"APำS VENCTO COBRAR MULTA DE"+Transform(SEE->EE_XMULTA,PesqPict("SEE","EE_XMULTA")),oFont2,100)
	oprn:say(002740,0120,"                                    ",oFont2,100)
	oprn:say(002780,0120,"                                    ",oFont2,100)
//-----------------------------------------------------------------------------------------------//		
	oPrn:Box(002880,0100,3070,2200)
	oprn:say(002880,0120,"Sacado"					,oFont1,100)
	_cSacado := Alltrim(SA1->A1_NOME)+" - CNPJ:"+Iif(SA1->A1_PESSOA=="J",transform(SA1->A1_CGC,"@R 99.999.999/9999-99"),transform(SA1->A1_CGC,"@R 999.999.999-99"))
	oprn:say(002880,0250,_cSacado					,oFont8,100)
	oprn:say(002920,1500,transform(SA1->A1_INSCR,"@R 999.999.999-99"),oFont8,100)
	_cEnd := IF(EMPTY(SA1->A1_ENDCOB),SA1->A1_END,SA1->A1_ENDCOB)+" "+IF(EMPTY(SA1->A1_BAIRROC),SA1->A1_BAIRRO,SA1->A1_BAIRROC)
	oprn:say(002920,0250,_cEnd						,oFont8,100)
	_cCep := IF(EMPTY(SA1->A1_CEPC),Transform(SA1->A1_CEP,"@R 99999-999"),Transform(SA1->A1_CEPC,"@R 99999-999"))+" - "+IF(EMPTY(SA1->A1_MUNC),AllTrim(SA1->A1_MUN),AllTrim(SA1->A1_MUNC))+"/"+IF(EMPTY(SA1->A1_ESTC),SA1->A1_EST,SA1->A1_ESTC)
	oprn:say(002960,0250,_cCep						,oFont8,100)
	oprn:say(003020,0120,"Sacador/Avalista"			,oFont1,100)
	oprn:say(003020,1520,"C๓d.Baixa"				,oFont1,100)
	oprn:say(003020,1750,"Autentica็ใo Mecโnica"	,oFont1,100)
	oprn:say(003080,1730,"FICHA DE COMPENSAวรO"		,oFont2,100)
//-----------------------------------------------------------------------------------------------//		
//Impressao do Codigo de Barras
//-----------------------------------------------------------------------------------------------//		
//  MSBAR("INT25",13.8,0.9,cCodBarra  ,oprn,.F.,,.T.,0.013,0.64, NIL,NIL,NIL,.F.)
	MSBAR("INT25",26.5,1.3,cCodBarra  ,oprn,.F.,,.T.,0.023,1.20, NIL,NIL,NIL,.F.)
	
	oprn:endpage()

/*		
		//Imprime Verso
		oPrn:StartPage()
		
		If File(cBmp)
			oPrn:SayBitmap(0010,0020,cBmp,2700,3200)
		EndIf
		
		//Destinatario
		cCodCep := CalcCep(SA1->A1_CEPC)
		oPrn:say(1150,0550,cCodCep,oFontCep,100)
		oPrn:say(1210,0550,"DESTINATมRIO:",oFont9,100)
		oPrn:say(1270,0550,SA1->A1_NOME,oFont9,100)
		oPrn:say(1350,0550,SA1->A1_ENDCOB,oFont9,100)
		oPrn:say(1400,0550,SA1->A1_BAIRROC,oFont9,100)
		oPrn:say(1450,0550,Transform(SA1->A1_CEPC,PesqPict("SA1","A1_CEPC"))+" "+SA1->(A1_MUNC+" "+A1_ESTC),oFont9,100)
		
		oPrn:EndPage()
*/
	EndIf
	
	dbSelectArea(cAliasTRB)
	dbSkip()
EndDo

//oPrn:setup()
//oPrn:Preview()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑบPrograma  ณ FIFINR01 บ Autor ณ TOTVS              บ Data ณ  23/01/12   บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Cria as Perguntas para Fatura para locacao de Bens Moveis  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ValidPerg(cPerg)

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05

aAdd(aRegs,{cPerg,"01","Banco:  "				,"mv_ch1","C",03,0,0,"G","naoVazio().and.U_FINR03VB()","mv_par01","","","","","","","","","","","","","","","SA6","007",{"C๓digo do Banco"},{"C๓digo do Banco"},{"C๓digo do Banco"}})
aAdd(aRegs,{cPerg,"02","Agencia: "				,"mv_ch2","C",05,0,0,"G","naovazio()","mv_par02","","","","","","","","","","","","","","","","008",{"C๓digo da agencia do banco"},{"C๓digo da Agencia do banco"},{"C๓digo da Agencia do banco"}})
aAdd(aRegs,{cPerg,"03","Conta: "				,"mv_ch3","C",10,0,0,"G","naovazio()","mv_par03","","","","","","","","","","","","","","","","009",{"Conta corrente"},{"Conta corrente"},{"Conta corrente"}})
aAdd(aRegs,{cPerg,"04","SubConta:  "			,"mv_ch4","C",03,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","",{"C๓digo da SubConta"},{"C๓digo da SubConta"},{"C๓digo da SubConta"}})
aAdd(aRegs,{cPerg,"05","Prefixo de:  "			,"mv_ch5","C",03,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","",{"Prefixo do tํtulo a receber inicial"},{"Prefixo do tํtulo a receber inicial"},{"Prefixo do tํtulo a receber"}})
aAdd(aRegs,{cPerg,"06","Prefixo at้: "			,"mv_ch6","C",03,0,0,"G","naovazio()","mv_par06","","","","","","","","","","","","","","","","",{"Prefixo do tํtulo a receber final"},{"Prefixo do tํtulo a receber final"},{"Prefixo do tํtulo a receber"}})
aAdd(aRegs,{cPerg,"07","Tํtulo inicial: "		,"mv_ch7","C",09,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","018",{"Numero do titulo inicial"},{"Numero do titulo inicial"},{"Numero do titulo de"}})
aAdd(aRegs,{cPerg,"08","Tํtulo final: "			,"mv_ch8","C",09,0,0,"G","naovazio()","mv_par08","","","","","","","","","","","","","","","","018",{"Numero do titulo final"},{"Numero do titulo final"},{"Numero do titulo de"}})
aAdd(aRegs,{cPerg,"09","Parcela inicial: "		,"mv_ch9","C",TamSx3("E1_PARCELA")[1],0,0,"G","","mv_par09","","","","","","","","","","","","","","","","011",{"Parcela inicial"},{"Parcela inicial"},{"Parcela de"}})
aAdd(aRegs,{cPerg,"10","Parcela final: "		,"mv_cha","C",TamSx3("E1_PARCELA")[1],0,0,"G","naovazio()","mv_par10","","","","","","","","","","","","","","","","011",{"Parcela final"},{"Parcela final"},{"Parcela ate"}})
aAdd(aRegs,{cPerg,"11","Tipo inicial: "			,"mv_chb","C",03,0,0,"G","","mv_par11","","","","","","","","","","","","","","","05","",{"Tipo do titulo inicial"},{"Tipo do titulo inicial"},{"Tipo do titulo de"}})
aAdd(aRegs,{cPerg,"12","Tipo final: "			,"mv_chc","C",03,0,0,"G","naovazio()","mv_par12","","","","","","","","","","","","","","","05","",{"Tipo do titulo final"},{"Tipo do titulo final"},{"Tipo do titulo ate"}})
aAdd(aRegs,{cPerg,"13","Cliente inicial: "		,"mv_chd","C",06,0,0,"G","","mv_par13","","","","","","","","","","","","","","","SA1","001",{"Cliente inicial"},{"Cliente inicial"},{"Cliente inicial"}})
aAdd(aRegs,{cPerg,"14","Cliente final: "		,"mv_che","C",06,0,0,"G","NaoVazio()","mv_par14","","","","","","","","","","","","","","","SA1","001",{"Cliente final"},{"Cliente final"},{"Cliente ate"}})
aAdd(aRegs,{cPerg,"15","Loja inicial: "			,"mv_chf","C",02,0,0,"G","","mv_par15","","","","","","","","","","","","","","","","002",{"Loja inicial"},{"Loja inicial"},{"Loja de"}})
aAdd(aRegs,{cPerg,"16","Loja final: "			,"mv_chg","C",02,0,0,"G","NaoVazio()","mv_par16","","","","","","","","","","","","","","","","002",{"Loja final"},{"Loja final"},{"Loja ate"}})
aAdd(aRegs,{cPerg,"17","Vencimento de: "		,"mv_chh","D",08,0,0,"G","NaoVazio()","mv_par17","","","","","","","","","","","","","","","","",{"Data de vencimento real do titulo de"},{"Data de vencimento real do titulo de"},{"Data de vencimento real do titulo de"}})
aAdd(aRegs,{cPerg,"18","Vencimento at้: "		,"mv_chi","D",08,0,0,"G","NaoVazio()","mv_par18","","","","","","","","","","","","","","","","",{"Data de vencimento real do titulo ate"},{"Data de vencimento real do titulo ate"},{"Data de vencimento real do titulo ate"}})

For i := 1 to Len(aRegs)
	PutSX1(aRegs[i,1],aRegs[i,2],aRegs[i,3],aRegs[i,3],aRegs[i,3],aRegs[i,4],aRegs[i,5],aRegs[i,6],aRegs[i,7],;
	aRegs[i,8],aRegs[i,9],aRegs[i,10],iif(len(aRegs[i])>=26,aRegs[i,26],""),aRegs[i,27],"",aRegs[i,11],aRegs[i,12],;
	aRegs[i,12],aRegs[i,12],aRegs[i,13],aRegs[i,15],aRegs[i,15],aRegs[i,15],aRegs[i,18],aRegs[i,18],aRegs[i,18],;
	aRegs[i,21],aRegs[i,21],aRegs[i,21],aRegs[i,24],aRegs[i,24],aRegs[i,24],aRegs[i,29],aRegs[i,29],aRegs[i,30])
Next i

dbSelectArea(_sAlias)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑบPrograma  ณ FIFINR01 บ Autor ณ TOTVS              บ Data ณ  23/01/12   บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescriao ณ Marca / Desmarca todas as Filiais                          ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function SIFR03In( oMark,cAliasTRB )

Local nRec := (cAliasTRB)->( Recno() )

dbSelectArea(cAliasTRB)
dbGoTop()

While !EOF(cAliasTRB)
	
	RecLock(cAliasTRB, .F. )
	(cAliasTRB)->E1_OK := If( (cAliasTRB)->E1_OK == cMarca, "", cMarca )
	MsUnlock()
	
	dbSkip()
EndDo

(cAliasTRB)->( DbGoTo( nRec ) )

lInverte := !lInverte

oMark:oBrowse:Refresh()

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑบPrograma  ณ FIFINR01 บ Autor ณ TOTVS              บ Data ณ  23/01/12   บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescriao ณ Inverte Selecao                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function SIFR03Cg( oMark,cAliasTRB )

Local nRec  := (cAliasTRB)->( Recno() )
Local cFlag := " "

dbSelectArea(cAliasTRB)
dbGoTop()

While !EOF(cAliasTRB)
	
	If IsMark( "E1_OK" , cMarca , lInverte )
		cFlag := " "
	Else
		cFlag := cMarca
	EndIf
	
	RecLock(cAliasTRB, .F. )
	(cAliasTRB)->E1_OK := cFlag
	MsUnlock()
	
	dbSkip()
EndDo

(cAliasTRB)->( DbGoTo( nRec ) )

oMark:oBrowse:Refresh()

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FIFINR01 บ Autor ณ TOTVS              บ Data ณ  23/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Calculo do Digito Verificador do CEP (PostNet)             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CalcCep(cCep)
Local cRet := ""
Local nDig := 0
Local nX

For nX:=1 to Len(cCep)
	nDig:=nDig+Val(SUBSTR(cCep,nX,1))
Next nX

nDig := Iif(nDig>9,Val(SUBSTR(Str(nDig),Len(Str(nDig)),1)),nDig)
nDig := Abs(Iif(nDig==0,nDig,10-nDig))
cRet := "/"+cCep+Alltrim(Str(nDig))+"\"

Return(cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FIFINR01 บ Autor ณ TOTVS              บ Data ณ  23/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao que monta o codigo de barra no modelo INT25.         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CodBarra()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ A variavel cCodBar define o Codigo de Barras para COB,sendo  ณ
//ณ formada da sequinte forma:                                   ณ
//ณ                                                              ณ
//ณ Posicao    Quantidade       Descricao                        ณ
//ณ  - POSICOES FIXAS PADRAO BANCO CENTRAL                       ณ
//ณ  01 a 03   03   Codigo de Compensacao do Banco		         ณ
//ณ  04 a 04   01   Codigo da Moeda(9-R$)                        ณ
//ณ  05 a 05   01   D.V. (digito verificador do codigo de barras)ณ
//ณ  06 a 09   04   Fator de Vencimento                          ณ
//ณ  10 a 19   10   Valor Nominal do Documento sem ponto         ณ
//ณ																 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local nDig 	  := 0
//Local cFator  := ALLTRIM(STR(SE1->E1_VENCREA - CTOD("07/10/1997")))  // Fator de Vencimento
Local cFator  := ALLTRIM(STR(SE1->E1_VENCTO - CTOD("07/10/1997")))  // Fator de Vencimento
Local cCampoLivre := CampoLivre(cCodBanco)
Local cCodBar := ""
Local lMais10 := Iif(SE1->E1_SALDO>9999999.99,.T.,.F.)
Local nSaldo  := SE1->E1_SALDO*100

If lMais10
	cCodBar := cCodBanco+"9"+StrZero(Int(nSaldo),14)+cCampoLivre
Else
	cCodBar := cCodBanco+"9"+cFator+StrZero(Int(NoRound(nSaldo,0)),10)+cCampoLivre  
Endif

nDig 	:= DigCodBar(cCodBar)
cCodBar := Substr(cCodBar,1,4)+nDig+Substr(cCodBar,5,39)

Return(cCodBar)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FIFINR01 บ Autor ณ TOTVS              บ Data ณ  23/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao que gera o Digito Verificador do Codigo de barra.    บฑฑ
ฑฑบ          ณMOD(11) Pesos (2 a 9).                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function DigCodBar(cCodBar)

Local nCont	:= 0
Local nPeso	:= 2
Local nResto:= 0
Local nRet 	:= 0

For i:=Len(cCodBar) To 1 Step -1
	nCont:=nCont+(Val(SUBSTR(cCodBar,i,1))*nPeso)
	nPeso:=nPeso+1
	if nPeso>9
		nPeso:=2
	endif
Next i

nResto:=(nCont%11)

nResto:=11-nResto

If nResto==0 .or. nResto==1 .or. nResto > 9
	nRet:='1'
Else
	nRet:=Str(nResto,1)
Endif

Return(nRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FIFINR01 บ Autor ณ TOTVS              บ Data ณ  23/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao que gera o Campo Livre para Cada Banco               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CampoLivre(cCodBanco)

Local cRet := ""
Local cAux := ""

Do Case
	Case cCodBanco == '001' // Banco do Brasil
		/*  BB
			10-19	0000233010 	- valor
			20-25	823911 		- convenio
			26-30	71513 		- complemento
			31-34	3221 		- agencia
			35-42	00105913	- conta
			43-44	18			- carteira
		*/
		If  Len(Alltrim(SEE->EE_CODEMP)) < 7
			If Alltrim(SEE->EE_XCART) $ "16|18" .and.  Len(Alltrim(SEE->EE_CODEMP))== 6  //.And. !(Empty(SEE->EE_xNOSNUM))
				cRet := substr(SE1->E1_NUMBCO,1,11)+StrZero(Val(MV_PAR02),4)+StrZero(Val(substr(MV_PAR03,1,6)),8)+Substr(SEE->EE_XCART,1,2)
			Else
				cRet := Substr(SEE->EE_CODEMP,1,6)+strzero(val(SE1->E1_NUMBCO),17)
			Endif
		Else
			cRet := "000000"+Substr(SEE->EE_CODEMP,1,7)+Substr(SE1->E1_NUMBCO,1,10)+Substr(SEE->EE_XCART,1,2) //Ana - Verificar
		Endif
	Otherwise
		cRet := Space(24)
EndCase

Return cRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FIFINR01 บ Autor ณ TOTVS              บ Data ณ  23/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao que gera digito verificador.                         บฑฑ
ฑฑบ          ณMod(10) Pesos (1 e 2)                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function DigMod10(cString)

Local nCont:=0
Local cRet := ""
Local nDigito := 0
Local nX
Local nPeso := 2

cString:= Alltrim(cString)

For nX:=Len(cString) to 1 Step -1
	
	If nPeso == 2
		If Val(SUBSTR(cString,nX,1))*nPeso >= 10
			nVal:=Val(SUBSTR(cString,nX,1))*nPeso
			nCont:=nCont+(Val(SUBSTR(Str(nVal,2),1,1))+Val(SUBSTR(Str(nVal,2),2,1)))
		Else
			nCont:=nCont+(Val(SUBSTR(cString,nX,1))*nPeso)
		Endif
	Else
		nCont:=nCont+(Val(SUBSTR(cString,nX,1))*nPeso)
	Endif
	
	If nPeso == 1
		nPeso := 2
	Else
		nPeso := nPeso-1
	Endif
	
Next nX

nDigito:=Abs(If((nCont%10)==0,0,10-(nCont%10)))
cRet := Str(nDigito,1)

Return(cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FIFINR01 บ Autor ณ TOTVS              บ Data ณ  23/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao que gera o Digito Verificador do "Nosso Numero".     บฑฑ
ฑฑบ          ณMOD(11) Pesos (2 a 9).                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function DigMod11(cString,nPeso,nAte)

Local nCont	:= 0
Local cRet 	:= ""
Local nX
Local nResto:= 0
Local nAux	:= nPeso

cString := Alltrim(cString)

For nX:=Len(cString) to 1 Step -1
	nCont:=nCont+(Val(SUBSTR(cString,nX,1))*nAux)
	nAux:=nAux+10
	If nAux>nAte
		nAux:=nPeso
	Endif
Next nX

nResto:=Mod(nCont,11)

If nResto==10
	cRet:='0'
Else
	cRet:=Str(nResto,1)
Endif

Return(cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FIFINR01 บ Autor ณ TOTVS              บ Data ณ  23/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao que monta a linha digitavel do boleto.               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function LinhaDgt(cCodBar)

Local cRet		:= ""
Local cDig 		:= ""
Local cAux		:= ""

//Calculo do Primeiro Campo
cRet := Substr(cCodBar,1,4)+Substr(cCodBar,20,5)
cDig := DigMod10(cRet) // Gera o digito

cRet := Substr(cRet,1,5)+"."+Substr(cRet,6,4)+cDig+Space(2)

// Calculo do Segundo Campo
cAux := Substr(cCodBar,25,10)
nDig :=	DigMod10(cAux)
cRet := cRet + Substr(cAux,1,5) +"."+Substr(cAux,6,5) +nDig + Space(2)

// Calculo do Terceiro Campo
cAux := Substr(cCodBar,35,10)
nDig := DigMod10(cAux)
cRet := cRet + Substr(cAux,1,5)+"."+Substr(cAux,6,5) + nDig + Space(2)

// Calculo do Quarto Campo
// Digito Verificador Geral
cRet := cRet +Substr(cCodBar,5,1)+Space(2)

// Calculo do Quinto Campo
cRet := cRet + Substr(cCodBar,6,14)

Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FIFINR01 บ Autor ณ TOTVS              บ Data ณ  23/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida Banco no SX1                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FINR03VB()

Local lRet := .T.

If Alltrim(MV_PAR01) <> Alltrim(cCodBanco)
	MsgStop("O Banco deve ser o mesmo que foi selecionado na tela anterior.","Aten็ใo")
	lRet := .F.
Endif

Return lRet
