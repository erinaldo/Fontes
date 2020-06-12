#Include "rwmake.CH"
#Include "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINA40a  ºAutor  ³Emerson Natali      º Data ³  20/02/2008 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Demonstrativo Aplicacoes Financeiras                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CFINA40a(nOp)

Local nCont		:= 0
Local lProc030a	:= .F.  // Carregar dados de Titulos em aberto
Local lProc030b	:= .F.  // Carregar dados de Titulos Pagos

PRIVATE nOpcao := nOp
PRIVATE nRec
PRIVATE oLbx,oLbx1
PRIVATE cCadastro  	:= OemToAnsi("Processar Cotação")
PRIVATE aCampos1 	:= {}
PRIVATE aNomearq[1]
PRIVATE oFolder030
PRIVATE nDest030
PRIVATE aCols   	:= {}
PRIVATE aAlt	   	:= {}

If nOpcao == 6
	If !(ZO_FLAG == "3" .and. Empty(ZO_PROCESS) .and. Empty(ZO_CANCELA))
		MsgBox(OemToAnsi("Cotação não pode ser Processada!"), "Aviso", "ALERT")
		Return
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Historico Cotacao                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCampos1:=		{{"NUMERO" 		, "C", 06, 0, OemToAnsi("Numero")			},;
				{ "FLAG"   		, "C", 01, 0, OemToAnsi("Flag")    			},;
				{ "ITEM"   		, "C", 02, 0, OemToAnsi("Item")  			},;
				{ "RENOVA" 		, "C", 01, 0, OemToAnsi("Renova")  			},;
				{ "BANCO"  		, "C", 03, 0, OemToAnsi("Nr Banco")			},;
				{ "AGENCIA"		, "C", 05, 0, OemToAnsi("Agencia")			},;
				{ "CONTA"		, "C", 10, 0, OemToAnsi("Conta")			},;
				{ "NOMBCO"		, "C", 15, 0, OemToAnsi("Banco")			},;
				{ "NREST"  		, "N", 07, 0, OemToAnsi("Quant Estag.")		},;
				{ "VLAPL"   	, "N", 14, 2, OemToAnsi("Vl. Aplicação")	},;
				{ "VLORI"	  	, "N", 14, 2, OemToAnsi("Origem")			},;
				{ "DTAPL"     	, "D", 08, 0, OemToAnsi("Dt Aplicação")		},;
				{ "TXCDI"     	, "N", 10, 5, OemToAnsi("Tx CDI %")			},;
				{ "TXBRAM"    	, "N", 10, 5, OemToAnsi("Tx Bram %")		},;
				{ "DIAS"  		, "N", 02, 0, OemToAnsi("Dias")				},;
				{ "DU"        	, "N", 02, 0, OemToAnsi("Dias Uteis")		},;
				{ "TXANO"     	, "N", 10, 5, OemToAnsi("Tx Ano")			},;
				{ "TXDIA"    	, "N", 10, 5, OemToAnsi("Tx Dia %")			},;
				{ "XDD"      	, "N", 10, 5, OemToAnsi("30 Dias %")		},;
				{ "TXPER"     	, "N", 10, 5, OemToAnsi("Tx Per %")			},;
				{ "VENCT"     	, "D", 08, 0, OemToAnsi("Vencimento")		},;
				{ "VLNOM"    	, "N", 14, 2, OemToAnsi("Vl Nominal")		},;
				{ "ORIGEM"    	, "C", 14, 0, OemToAnsi("Orig") 			}}
				


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria os arquivos temporarios                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Processa( { |lEnd| Fc030Procri() } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se todos os arquivos foram criados					 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nCont := 1 to 1
	If !File(aNomeArq[nCont]+GetDBExtension())
		Help("",1,"Fc030NOARQ")
		Return
	EndIf
Next nCont

If !lProc030a
	lProc030a := .T.
	Processa( { |lEnd| Fc030Gera(1) } )
EndIf

If !lProc030b
	lProc030b := .T.
	Processa( { |lEnd| Fc030Gera(2) } )
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Exibe tela principal da consulta					 		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FC030Mostr(lProc030a ,lProc030b)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apaga os arquivos temporarios					 		     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nCont := 1 to 1
	If !Empty(aNomeArq[nCont])
		IF Select("cArq"+Str(nCont,1)) > 0
			dbSelectArea("cArq"+Str(nCont,1))
			dbCloseArea()
			FERASE(aNomearq[nCont]+GetDBExtension())
			Ferase(aNomeArq[nCont]+OrdBagExt())
		ENDIF
	EndIf
Next nCont

lProc030a := .F.  // Carregar dados de Titulos em aberto
lProc030b := .F.  // Carregar dados de Titulos Pagos

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fC030Procri ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 15/01/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cria estruturas dos arquivos de Trabalho                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³fC030Procri()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINC030                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static FUNCTION Fc030Procri()

// Seta tamanho da regua
ProcRegua(1)

IncProc(OemToAnsi("Criando Arquivo de Trabalho - Historico Cotação"))
cNomeArq := Fc030Cria(aCampos1,1)

Return Nil

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fC030Cria ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 15/01/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cria estruturas dos arquivos de Trabalho                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³fC030Cria()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nao tem                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINC030                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fc030Cria(aCampos,nCont)

If !Empty(aNomeArq[nCont])
	If (Select("cArq"+Str(nCont,1))<>0)
		dbSelectArea("cArq"+Str(nCont,1))
		dbCloseArea()
	Endif
Endif

aNomeArq[nCont] := CriaTrab(aCampos)
dbUseArea (.T.,,aNomeArq[nCont],"cArq"+Str(nCont,1), NIL, .F.)
IndRegua("cArq"+Str(nCont,1),aNomeArq[nCont],"NUMERO",,,OemToAnsi("Selecionando Registros..."))

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fC030Mostr³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 15/01/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Mostra tela principal da consulta                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³fC030Mostr()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nao tem                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINC030                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FC030Mostr(lProc030a,lProc030b)

Local oDlg
Local aObjects := {}
Local aPosObj  := {}
Local aSize    := MsAdvSize()
Local aInfo    := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}

AADD(aObjects,{100,030,.T.,.F.,.F.})
AADD(aObjects,{100,100,.T.,.T.,.F.})

aPosObj:=MsObjSize(aInfo,aObjects)

dbSelectArea("SZO")
dbSetOrder(1)

DEFINE MSDIALOG oDlg TITLE cCadastro OF oMainWnd PIXEL FROM aSize[7],0 TO aSize[6],aSize[5]

@ 001,aPosObj[1,2] TO aPosObj[1,3],aPosObj[1,4] OF oDlg PIXEL
@ 004,008 SAY OemToAnsi("Numero da Cotaçãp")	SIZE 021,07 OF oDlg PIXEL
@ 012,007 MSGET SZO->ZO_NUMERO					SIZE 020,09 OF oDlg PIXEL When .F.
@ 012,215 BUTTON OemToAnsi("Sair")				SIZE 042,13 FONT oDlg:oFont ACTION oDlg:End() OF oDlg PIXEL
If nOpcao == 6
	@ 028,215 BUTTON OemToAnsi("Processar")			SIZE 042,13 FONT oDlg:oFont ACTION _fProc(oDlg) OF oDlg PIXEL
EndIf

cFolder1 := OemToAnsi("Processar Cotação")
cFolder2 := OemToAnsi("Histórico Cotação")

aFolder  := {cFolder1,cFolder2}

oFolder030:=TFolder():New(aPosObj[2,1],aPosObj[2,2],aFolder,{},oDlg,,,, .T., .F.,aPosObj[2,4]-5,aPosObj[2,3]-55,)
oFolder030:bSetOption:={|nDest030| Fc030ChFol(nDest030,oFolder030:nOption,@lProc030a,@lProc030b,oLbx,oLbx1)}
oFolder030:aDialogs[1]:oFont :=oDlg:oFont
oFolder030:aDialogs[2]:oFont :=oDlg:oFont

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Informacoes do Folder 1                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lDeleta := .F.
aHeader := {}
aHeader := MontAhead("SZO")
nUsado  := Len(aHeader)
N       := 1 
nOpc	:= nOpcao
oLbx	:= MSGetDados():New(aPosObj[2,1]-48,aPosObj[2,2]-2,aPosObj[2,4]-9,aPosObj[2,3]-82,nOpc,"AllwaysTrue","AllwaysTrue",,lDeleta,,,,,,,,,oFolder030:aDialogs[1])

oLbx:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
oFolder030:SetOption(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Informacoes do Folder 2 - Historico Cotacao                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("cArq1")
dbGoTop()

@ aPosObj[2,1]-48,aPosObj[2,2]-2 LISTBOX oLbx1 FIELDS	cArq1->ITEM,;
														cArq1->BANCO,;
														cArq1->AGENCIA,;
														cArq1->CONTA,;
														cArq1->NOMBCO,;
														Transform(cArq1->NREST,PesqPict("SZO","ZO_NREST")),;
														Transform(cArq1->VLAPL,PesqPict("SZO","ZO_VLAPL")),;
														Transform(cArq1->VLORI,PesqPict("SZO","ZO_VLORI")),;
														cArq1->DTAPL,;
														Transform(cArq1->TXCDI,PesqPict("SZO","ZO_TXCDI")),;
														Transform(cArq1->TXBRAM,PesqPict("SZO","ZO_TXBRAM")),;
														Transform(cArq1->DIAS,PesqPict("SZO","ZO_DIAS")),;
														Transform(cArq1->DU,PesqPict("SZO","ZO_DU")),;
														Transform(cArq1->TXANO,PesqPict("SZO","ZO_TXANO")),;
														Transform(cArq1->TXDIA,PesqPict("SZO","ZO_TXDIA")),;
														Transform(cArq1->XDD,PesqPict("SZO","ZO_30DD")),;
														Transform(cArq1->TXPER,PesqPict("SZO","ZO_TXPER")),;
														cArq1->VENCT,;
														Transform(cArq1->VLNOM,PesqPict("SZO","ZO_VLNOM")),;
HEADER "Item","Nr Banco","Agencia","Conta","Banco","Quant Estag.","Vl. Aplicação","Vl. Origem","Dt Aplicação","Tx CDI %","Tx Bram %","Dias","Dias Uteis","Tx Ano","Tx Dia %","30 Dias %","Tx Per %","Vencimento","Vl Nominal";
SIZE aPosObj[2,4]-9,aPosObj[2,3]-82 OF oFolder030:aDialogs[2] PIXEL

oFolder030:aDialogs[2]:Refresh()

ACTIVATE MSDIALOG oDlg

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³FC030ChFol³ Autor ³ Mauricio Pequim Jr    ³ Data ³ 13/11/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Direcionamento da criacao dos arquivos                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINC030                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fc030ChFol(nDest030,nAtual,lProc030a,lProc030b,oLbx,oLbx1)

If nDest030 != nAtual
	// Carregar dados Primeira Folder
	If nDest030 == 1
		oLbx:Refresh()
	Endif
	// Carregar dados Segunda Folder
	If nDest030 == 2
		oLbx1:Refresh()
		oLbx1:SetFocus()
	Endif
Endif
Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fC030Gera ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 15/01/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gera registros dos arquivos de trabalho                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³fC030Gera()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nao tem                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINC030                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fc030Gera(nProcess)

Local _nNrReg := 0
Local _aArea := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FOLDER 1                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nProcess == 1
	IncProc(OemToAnsi("Selecionando Dados - Cotação"))
	
	_aArea := GetArea()
	
	DbSelectArea("SZO")
	dbSeek(SZO->(ZO_FILIAL+ZO_NUMERO))
	nRec	:= SZO->(RecNo())
	_cKey 	:= SZO->(ZO_FILIAL+ZO_NUMERO)
	While SZO->(ZO_FILIAL+ZO_NUMERO) == _cKey
		aaDD(aCols, {	SZO->ZO_ITEM,;
						SZO->ZO_COD,;
						SZO->ZO_RENOVA,;
						SZO->ZO_BANCO,;
						SZO->ZO_AGENCIA,;
						SZO->ZO_CONTA,;
						SZO->ZO_NOMBCO,;
						SZO->ZO_NREST,;
						SZO->ZO_VLAPL,;
						SZO->ZO_DTAPL,;
						SZO->ZO_TXCDI,;
						SZO->ZO_TXBRAM,;
						SZO->ZO_DIAS,;
						SZO->ZO_DU,;
						SZO->ZO_TXANO,;
						SZO->ZO_TXDIA,;
						SZO->ZO_30DD,;
						SZO->ZO_TXPER,;
						SZO->ZO_VENCT,;
						SZO->ZO_VLNOM})

		aaDD(aAlt, SZO->(Recno()))
		
		_nNrReg++
		dbSelectArea("SZO")
		dbSkip()
	EndDO
	dbSelectArea("SZO")
	dbGoto(nRec)
	RestArea(_aArea)

	//Ordena aCols por Item
	aSort(aCols,,, { |x, y| x[1] < y[1] })

Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FOLDER 2                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nProcess == 2
	IncProc(OemToAnsi("Selecionando Dados - Historico Cotação"))
	
	_aArea := GetArea()
	
	DbSelectArea("SZO")
	dbSeek(SZO->(ZO_FILIAL+ZO_NUMERO))
	nRec	:= SZO->(RecNo())
	_cKey 	:= SZO->(ZO_FILIAL+ZO_NUMERO)
	While SZO->(ZO_FILIAL+ZO_NUMERO) == _cKey
		
		// Grava registros no arquivo temporario
		dbSelectArea("cArq1")
		RecLock("cArq1",.T.)
		cArq1->NUMERO	:= SZO->ZO_NUMERO
		cArq1->FLAG  	:= SZO->ZO_FLAG
		cArq1->ITEM  	:= SZO->ZO_ITEM
		cArq1->RENOVA	:= SZO->ZO_RENOVA
		cArq1->BANCO 	:= SZO->ZO_BANCO
		cArq1->AGENCIA 	:= SZO->ZO_AGENCIA
		cArq1->CONTA 	:= SZO->ZO_CONTA
		cArq1->NOMBCO 	:= SZO->ZO_NOMBCO
		cArq1->NREST 	:= SZO->ZO_NREST
		cArq1->VLAPL 	:= SZO->ZO_VLAPL
		cArq1->VLORI 	:= SZO->ZO_VLORI
		cArq1->DTAPL 	:= SZO->ZO_DTAPL
		cArq1->TXCDI 	:= SZO->ZO_TXCDI
		cArq1->TXBRAM	:= SZO->ZO_TXBRAM
		cArq1->DIAS 	:= SZO->ZO_DIAS
		cArq1->DU 		:= SZO->ZO_DU
		cArq1->TXANO 	:= SZO->ZO_TXANO
		cArq1->TXDIA 	:= SZO->ZO_TXDIA
		cArq1->XDD	 	:= SZO->ZO_30DD
		cArq1->TXPER 	:= SZO->ZO_TXPER
		cArq1->VENCT 	:= SZO->ZO_VENCT
		cArq1->VLNOM 	:= SZO->ZO_VLNOM
		cArq1->ORIGEM 	:= SZO->ZO_ORIGEM
		MsUnLock()
		
		_nNrReg++
		dbSelectArea("SZO")
		dbSkip()
	EndDO
	dbSelectArea("cArq1")
	dbGoTop()
	dbSelectArea("SZO")
	dbGoto(nRec)
	RestArea(_aArea)
EndIf
Return (.T.)

User Function CF40LIOK()

Return(.T.)

User Function CF40TDOK()

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINA40A  ºAutor  ³Microsiga           º Data ³  03/11/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _fProc(oDlg)

Local _aArea := GetArea()

_cTpApl		:= ""
_nValTX		:= 0
_aAplicacao	:= {}
_dAplicacao	:= dDataBase

_aResgate	:= {}
_dResgate	:= dDataBase

_nValRenov	:= 0
_lValIgual	:= .F.
_aValIgual	:= {}
//Ordena aCols por Valor
aSort(aCols,,, { |x, y| Str(x[8],14,2) < Str(y[8],14,2) })

For i := 1 To Len(aCols)
	If aCols[i,2] == "S" //Renova Sim
		If _nValRenov == aCols[i,8]
			_lValIgual	:= .T.
			Aadd(_aValIgual,{aCols[i,3],aCols[i,4],aCols[i,5],aCols[i,6],Str(aCols[i,8],14,2)})
		Else
			_nValRenov	:= aCols[i,8] //Valor Aplicado
		EndIf
	EndIf
Next i
	
_cMsg	:= ""
_cTit	:= "Informações"
If !Empty(_aValIgual)
	_cMsg += "Existem valores de Aplicação Iguais para Bancos Diferentes"+CHR(10)+CHR(13)
	_cMsg += "As informções estao Corretas?"
	If !MsgYesNo(OemToAnsi(_cMsg), OemToAnsi(_cTit))
		Return
	EndIf
EndIf

//Ordena aCols por Item
aSort(aCols,,, { |x, y| x[1] < y[1] })

If MsgYesNo("Confirma o processamento dos dados?", OemToAnsi("Liberação da Cotação"))
	If MsgYesNo(OemToAnsi("Este processamento finaliza a Contação. Deseja Finalizar a Cotação?"), OemToAnsi("Liberação da Cotação"))
		DbSelectArea("cArq1")
		DbGotop()
		_dResgate	:= cArq1->DTAPL
		While !EOF()
			// Grava registros na Tabela Historico
			dbSelectArea("SZQ")
			RecLock("SZQ",.T.)
			SZQ->ZQ_NUMERO	:=	cArq1->NUMERO
			SZQ->ZQ_FLAG  	:=	cArq1->FLAG
			SZQ->ZQ_ITEM  	:= 	cArq1->ITEM
			SZQ->ZQ_RENOVA	:= 	cArq1->RENOVA
			SZQ->ZQ_BANCO 	:=	cArq1->BANCO
			SZQ->ZQ_AGENCIA	:=	cArq1->AGENCIA
			SZQ->ZQ_CONTA 	:=	cArq1->CONTA
			SZQ->ZQ_NOMBCO 	:=	cArq1->NOMBCO
			SZQ->ZQ_NREST 	:=	cArq1->NREST
			SZQ->ZQ_VLAPL 	:=	cArq1->VLAPL
			SZQ->ZQ_VLORI 	:=	cArq1->VLORI
			SZQ->ZQ_DTAPL 	:=	cArq1->DTAPL
			SZQ->ZQ_TXCDI 	:= 	cArq1->TXCDI
			SZQ->ZQ_TXBRAM	:=	cArq1->TXBRAM
			SZQ->ZQ_DIAS 	:=	cArq1->DIAS
			SZQ->ZQ_TXANO 	:=	cArq1->TXANO
			SZQ->ZQ_TXDIA 	:=	cArq1->TXDIA
			SZQ->ZQ_30DD 	:=	cArq1->XDD
			SZQ->ZQ_TXPER	:=	cArq1->TXPER
			SZQ->ZQ_VENCT 	:=	cArq1->VENCT
			SZQ->ZQ_DU 		:=	cArq1->DU
			SZQ->ZQ_VLNOM 	:=	cArq1->VLNOM
			MsUnLock()

			If ALLTRIM(cArq1->ORIGEM) 	== "DEMONS"
				aadd(_aResgate,{cArq1->BANCO,cArq1->CONTA,cArq1->VLAPL})
			EndIf

			dbSelectArea("cArq1")
			dbSkip()
		EndDO

		//Este bloco e para realizar a Alteracao no registro SZO. (Nao pode incluir nem deletar linha)
		dbSelectArea("SZO")
		DbSetOrder(1)
		For i := 1 To Len(aCols)
			If i <= Len(aAlt)
				dbGoTo(aAlt[i])
				RecLock("SZO", .F.)
				For y := 1 To Len(aHeader)
					FieldPut(FieldPos(Trim(aHeader[y][2])), aCols[i][y])
				Next
				SZO->ZO_FLAG    := "3"
				SZO->ZO_PROCESS := "S"
				MSUnlock()
			EndIf
		Next i

		// Gravacao na tabela de Demonstrativo de Aplicacoes Financeiras
		_cKey 	:= SZO->(ZO_FILIAL+ZO_NUMERO)
		DbSetOrder(1)
		dbseek(_cKey)
		//Primeiro Verifica somente os que NAO (RENOVA)
		Do While SZO->(ZO_FILIAL+ZO_NUMERO) == _cKey
			If SZO->ZO_RENOVA == "N"
				DbSelectArea("SZS")
				DbSetOrder(1)
				If DbSeek(xFilial("SZS")+SZO->ZO_NOMBCO+SZO->ZO_CONTA+STR(SZO->ZO_VLORI,14,2))
					RecLock("SZS",.F.)
					DbDelete()
					MsUnLock()
				EndIf
			EndIf
			SZO->(DbSkip())
		EndDo
		//Segundo Verifica somente os que SIM (RENOVA)
		DbSelectArea("SZO")
		DbSetOrder(1)
		dbseek(_cKey)
		_dAplicacao 	:= SZO->ZO_DTAPL
		Do While SZO->(ZO_FILIAL+ZO_NUMERO) == _cKey
			If SZO->ZO_RENOVA == "S"
				DbSelectArea("SZS")
				DbSetOrder(1)
				Do Case
					Case SZO->ZO_TXCDI==0 .and. SZO->ZO_TXBRAM == 0
						_cTpApl	:= "PRE"
						_nValTX	:= SZO->ZO_30DD
					Case SZO->ZO_TXCDI<>0 .and. SZO->ZO_TXBRAM == 0
						_cTpApl	:= "POS"
						_nValTX	:= SZO->ZO_TXCDI
					Case SZO->ZO_TXBRAM<>0
						_cTpApl	:= "BRA"
						_nValTX	:= SZO->ZO_TXBRAM
				EndCase

				If DbSeek(xFilial("SZS")+SZO->ZO_NOMBCO+SZO->ZO_CONTA+STR(SZO->ZO_VLORI,14,2))
					RecLock("SZS",.F.)
					SZS->ZS_FILIAL	:= xFilial("SZS")
					SZS->ZS_TPAPL	:= _cTpApl
					SZS->ZS_COD		:= SZO->ZO_COD
					SZS->ZS_NOMBCO	:= SZO->ZO_NOMBCO
					SZS->ZS_CONTA	:= SZO->ZO_CONTA // Numero da Conta do Banco
					SZS->ZS_DTAPL	:= SZO->ZO_DTAPL
					SZS->ZS_RESGAT	:= SZO->ZO_VENCT // Vencimento para Resgate
					SZS->ZS_VLAPL	:= SZO->ZO_VLAPL
					SZS->ZS_VLNOM	:= iif(SZO->ZO_TXCDI==0 .and. SZO->ZO_TXBRAM==0,SZO->ZO_VLNOM,0)
					SZS->ZS_252		:= SZO->ZO_TXANO
					SZS->ZS_360		:= (((SZO->ZO_VLNOM/SZO->ZO_VLAPL)^(360/SZO->ZO_DIAS))-1)*100
					SZS->ZS_TXPER	:= SZO->ZO_TXPER
					SZS->ZS_30DD	:= _nValTX
					SZS->ZS_DIAS	:= SZO->ZO_DIAS
					SZS->ZS_DDECOR	:= 0
					SZS->ZS_DU		:= SZO->ZO_DU
					SZS->ZS_REND	:= 0
					SZS->ZS_VLATU	:= 0
					SZS->ZS_COTAC	:= ""
					MsUnLock()
				Else
					RecLock("SZS",.T.)
					SZS->ZS_FILIAL	:= xFilial("SZS")
					SZS->ZS_TPAPL	:= _cTpApl
					SZS->ZS_COD		:= SZO->ZO_COD
					SZS->ZS_NOMBCO	:= SZO->ZO_NOMBCO
					SZS->ZS_CONTA	:= SZO->ZO_CONTA // Numero da Conta do Banco
					SZS->ZS_DTAPL	:= SZO->ZO_DTAPL
					SZS->ZS_RESGAT	:= SZO->ZO_VENCT // Vencimento para Resgate
					SZS->ZS_VLAPL	:= SZO->ZO_VLAPL
					SZS->ZS_VLNOM	:= iif(SZO->ZO_TXCDI==0 .and. SZO->ZO_TXBRAM==0,SZO->ZO_VLNOM,0)
					SZS->ZS_252		:= SZO->ZO_TXANO
					SZS->ZS_360		:= (((SZO->ZO_VLNOM/SZO->ZO_VLAPL)^(360/SZO->ZO_DIAS))-1)*100
					SZS->ZS_TXPER	:= SZO->ZO_TXPER
					SZS->ZS_30DD	:= _nValTX
					SZS->ZS_DIAS	:= SZO->ZO_DIAS
					SZS->ZS_DDECOR	:= 0
					SZS->ZS_DU		:= SZO->ZO_DU
					SZS->ZS_REND	:= 0
					SZS->ZS_VLATU	:= 0
					SZS->ZS_COTAC	:= ""
					MsUnLock()

					/*---------------------------------------------------------------------------------------
					|  PARA NOVAS APLICACOES (INCLUSOES NO DEMONSTRATIVO) IRA INCLUIR AUTOMATICAMENTE UM    |
					|  MOVIMENTO BANCARIO A RECEBER.														|
					----------------------------------------------------------------------------------------*/
					/*--------------------------------------------------------------------------------------
					PROCESSO DE INCLUSAO DO MOVIMENTO BANCARIO (APLICACAO) SERA REALIZADO MANUALMENTE PELO USUARIO
					NAO IREMOS GERAR MAIS AUTOMATICAMENTE PELO SISTEMA
					06/10/2008 - ALTERADO PELO ANALISTA EMERSON
					--------------------------------------------------------------------------------------
					_aAreaSZS := GetArea()
					DbSelectArea("SA6")
					DbSetOrder(5) //FILIAL + NUMERO DA CONTA
					If DbSeek(xFilial("SA6")+SZO->ZO_CONTA)
						_cBanco 	:= SA6->A6_COD
						_cAgencia 	:= SA6->A6_AGENCIA
						_cNumConta	:= SA6->A6_NUMCON
					Else
						_cBanco 	:= ""
						_cAgencia 	:= ""
						_cNumConta	:= ""
					EndIf					
					DbSelectArea("SE5")
					RecLock("SE5", .T.)
					SE5->E5_FILIAL  := xFilial("SE5")
					SE5->E5_DATA    := SZO->ZO_DTAPL
					SE5->E5_MOEDA   := "RS" //Cadastro de Moeda (Tabela - 06) RS=RESERVA FINANCEIRA
					SE5->E5_VALOR   := SZO->ZO_VLAPL
					SE5->E5_NATUREZ := "5.01.01"
					SE5->E5_BANCO   := _cBanco
					SE5->E5_AGENCIA := _cAgencia
					SE5->E5_CONTA   := _cNumConta
					SE5->E5_DOCUMEN := Strzero(MONTH(SZO->ZO_DTAPL),2)+Str(YEAR(SZO->ZO_DTAPL),4)
					SE5->E5_HISTOR  := _cTpApl+" APL "+Strzero(MONTH(SZO->ZO_DTAPL),2)+Str(YEAR(SZO->ZO_DTAPL),4)
					SE5->E5_BENEF   := "APL "+Strzero(MONTH(SZO->ZO_DTAPL),2)+Str(YEAR(SZO->ZO_DTAPL),4)
					SE5->E5_VENCTO  := SZO->ZO_DTAPL
					SE5->E5_RECPAG  := "P" //aplicacao (esta saindo dinheiro do banco para o conta de aplicacao
					SE5->E5_LA      := "S"
					SE5->E5_DTDIGIT := SZO->ZO_DTAPL
					SE5->E5_TIPOLAN := "X"
					SE5->E5_ITEMD   := "49112"
					SE5->E5_DEBITO  := "401090010002"
					SE5->E5_CCD     := "00026"
					SE5->E5_RATEIO  := "N"
					SE5->E5_RECONC  := "x"  // Já reconciliado
					SE5->E5_DTDISPO := SZO->ZO_DTAPL
					SE5->E5_FILORIG := "01"
					SE5->E5_MODSPB  := "1"
					SE5->E5_CODORCA := "PADRAOPR"
					SE5->(msUnLock())
					RestArea(_aAreaSZS)
*/
				EndIf
				aadd(_aAplicacao,{SZO->ZO_NOMBCO,SZO->ZO_CONTA,SZO->ZO_VLAPL})
			EndIf
			SZO->(DbSkip())
		EndDo

		// Posiciona na tela de Cotacao no primeiro registro da mesma.
		dbGoto(nRec)

		oDlg:End()
	EndIf
EndIf

_fContabA(_aResgate, _dResgate)

// _fContabB(_aAplicacao, _dAplicacao) // Solicitacao pelo email em 03/07/2013.

MsgBox("Finalizado Processo de Fechamento", "Aviso", "ALERT")

RestArea(_aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINA40A  ºAutor  ³Microsiga           º Data ³  05/26/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _fContabA(_aResgate, _dResgate)

aCab		:= {}
aItem		:= {}
aTotItem	:=	{}
lMsErroAuto := .f.

aCab := {	{"dDataLanc", _dResgate	,NIL},;
			{"cLote"	, "009400"	,NIL},;
			{"cSubLote"	, "001"		,NIL}}

For _nI := 1 to Len(_aResgate)

	DbSelectArea("SA6")
	DbSetOrder(5) //FILIAL + NUMERO DA CONTA
	If DbSeek(xFilial("SA6")+_aResgate[_nI,2])
		_cCtaRed	:= SA6->A6_CONTABI		//Item Contabil (Conta Reduzida)
	Else
		_cCtaRed	:= ""
	EndIf

	AADD(aItem,{	{"CT2_FILIAL"	, xFilial("CT2")								, NIL},;
					{"CT2_LINHA"	, StrZero(_nI,3)								, NIL},;
					{"CT2_DC"		, "3"	 										, NIL},;
					{"CT2_ITEMD"	, _cCtaRed										, NIL},;
					{"CT2_ITEMC"	, "1221111"										, NIL},;
					{"CT2_CCD"		, ""											, NIL},;
					{"CT2_CCC"		, ""											, NIL},;
					{"CT2_VALOR"	, Round(_aResgate[_nI,3],2)						, NIL},;
					{"CT2_HP"		, ""											, NIL},;
					{"CT2_HIST"		, "RESGATE RESERVA FINANCEIRA"					, NIL},;
					{"CT2_TPSALD"	, "9"											, NIL},;
					{"CT2_ORIGEM"	, "RESGATE"										, NIL},;
					{"CT2_MOEDLC"	, "01"											, NIL},;
					{"CT2_EMPORI"	, ""											, NIL},;
					{"CT2_ROTINA"	, ""											, NIL},;
					{"CT2_LP"		, ""											, NIL},;
					{"CT2_KEY"		, ""											, NIL}})
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

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINA40A  ºAutor  ³Microsiga           º Data ³  05/26/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _fContabB(_aAplicacao, _dAplicacao)

aCab		:= {}
aItem		:= {}
aTotItem	:=	{}
lMsErroAuto := .f.

aCab := {	{"dDataLanc", _dAplicacao ,NIL},;
			{"cLote"	, "009400"	,NIL},;
			{"cSubLote"	, "001"		,NIL}}

For _nI := 1 to Len(_aAplicacao)

	DbSelectArea("SA6")
	DbSetOrder(5) //FILIAL + NUMERO DA CONTA
	If DbSeek(xFilial("SA6")+_aAplicacao[_nI,2])
		_cCtaRed	:= SA6->A6_CONTABI		//Item Contabil (Conta Reduzida)
	Else
		_cCtaRed	:= ""
	EndIf

	AADD(aItem,{	{"CT2_FILIAL"	, xFilial("CT2")								, NIL},;
					{"CT2_LINHA"	, StrZero(_nI,3)								, NIL},;
					{"CT2_DC"		, "3"	 										, NIL},;
					{"CT2_ITEMD"	, "1221111"										, NIL},;
					{"CT2_ITEMC"	, _cCtaRed										, NIL},;
					{"CT2_CCD"		, ""											, NIL},;
					{"CT2_CCC"		, ""											, NIL},;
					{"CT2_VALOR"	, Round(_aAplicacao[_nI,3],2)					, NIL},;
					{"CT2_HP"		, ""											, NIL},;
					{"CT2_HIST"		, "APLICACAO RESERVA FINANCEIRA"				, NIL},;
					{"CT2_TPSALD"	, "9"											, NIL},;
					{"CT2_ORIGEM"	, "APLICACAO"									, NIL},;
					{"CT2_MOEDLC"	, "01"											, NIL},;
					{"CT2_EMPORI"	, ""											, NIL},;
					{"CT2_ROTINA"	, ""											, NIL},;
					{"CT2_LP"		, ""											, NIL},;
					{"CT2_KEY"		, ""											, NIL}})
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

Return