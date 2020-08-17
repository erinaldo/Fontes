#INCLUDE "PROTHEUS.CH"
#INCLUDE 'TBICONN.CH'
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  RTExppr     บ Autor ณ WM                บ Data ณ  09/03/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina de exporta็ใo de arquivos                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function ExpDemi1(aParams)
Local 	aSay       := {}
Local 	aButton    := {}
Local 	nOpc       := 0
Local 	cTitulo    := ""
Local	cDesc1     := "Esta rotina ira fazer a exportacao do cadastro"
Local	cDesc2 	   := "de Funcionarios demitidos para a Notredame."
Local	cDesc3 	   := ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private lManual   := IIf( aParams == NIL, .T.  , aParams[1][1] )
Private cEmpresa  := IIf( lManual, SM0->M0_CODIGO, aParams[1][2] )
Private cFil      := IIf( lManual, SM0->M0_CODFIL, aParams[1][3] )
Private lTemPerg  := .T.		// .T. utiliza a pergunta .F. nใo
Private cPerg     := PADR("RTEXP1",LEN(SX1->X1_GRUPO))   // nome do grupo de perguntas, depende do lTemPerg
Private oGeraTxt
Private cAlias    := "SRA"   //alias do arquivo a exportar
Private cDir      := ''
Private lUsaFTP   := .F.                                                                      
Private cDirFTP   := ''
Private cDtExp    := ""

If !lManual
	// Prepara ambiente se for JOB
	RpcSetType(3)
	RpcSetEnv(cEmpresa, cFil,,,'FIN')
EndIf

if lTemPerg
	U_Perg04(cPerg)
Endif

// ROTINA PARA VERIFCAR SE USA FTP
cDir := AllTrim(GetMv("EX_LISPAT",,"C:\temp"))  // Caminho local

lUsaFTP:= GetMV('EX_USAFTP',,.f.)   // Parametro para utilizar ou nใo FTP

If lUsaFTP == .T.
	cDirFTP := GetMV( 'EX_LISFTP',,'/') //caminho do FTP
EndIf

dbSelectArea(cAlias)
dbSetOrder(1)

if lTemPerg                                                                                  
	Pergunte(cPerg, .F.)
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem da tela de processamento.                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lManual
	nOpc := 0
	aAdd( aSay, cDesc1 )
	aAdd( aSay, cDesc2 )
	aAdd( aSay, cDesc3 )
	aAdd( aButton, { 13, .T., { || cDir := SelArq()        } } )
    if lTemPerg
		aAdd( aButton, { 5, .T., { || Pergunte(cPerg, .T.)    } } )
    End
	aAdd( aButton, { 1, .T., { || iif( RTExpp1(@nOpc),  FechaBatch(), ApMsgAlert("Verifique os parametros!!!") ) } } )
	aAdd( aButton, { 2, .T., { || nOpc := 2, FechaBatch()            } } )
	
	FormBatch( cTitulo, aSay, aButton )
	
	If nOpc <> 1
		Return NIL
	EndIf
Endif	

OkGeraTxt()

If !lManual
	RpcClearEnv()
EndIf

Return Nil



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRTEXPPR   บAutor  ณMicrosiga           บ Data ณ  03/09/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static Function RTExpp1(nOpc)
lRet := .T.
if lRet
	nOpc := 1
Endif
Return(lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ OKGERATXTบ Autor ณ AP5 IDE            บ Data ณ  16/02/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao chamada pelo botao OK na tela inicial de processamenบฑฑ
ฑฑบ          ณ to. Executa a geracao do arquivo texto.                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function OkGeraTxt

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria o arquivo texto                                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private choje     := date()
Private cano      := strZero(YEAR(date()),4)
Private cmesdia   := dtoc(choje)
Private cmes      := SUBSTR(Cmesdia,4,2)
Private cdia      := SUBSTR(Cmesdia,1,2)
Private cBaseArq  := aLLTRIM(MV_PAR06)
Private cExtensao := ".TXT"
Private cArqTxt   := cdir+cBaseArq+cExtensao 
Private cArqFTP   := cDirFTP+cBaseArq+cExtensao
Private nHdl      := 0
Private nHdl1     := 0
Private aLog      := {}
Private cCabHtml  := ""
Private cRodHtml  := ""
Private cFileCont := ""
Private cLinFile  := ""

cDtExp := right(Alltrim(MV_PAR05),4) + Left(Alltrim(MV_PAR05),2) + "01"

MakeDir( cDir )
nHdl := fCreate(cArqTxt, 0)
nhdl1 := fCreate(cdir+cBaseArq+".XLS",0)

If nHdl == -1 .OR. nHdl1 == -1
	ApMsgAlert("O arquivo  "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return NIL
Endif

//monta cabe็alho de pagina HTML para posterior utiliza็ใo
cCabHtml := "<!-- Created with AEdiX by Kirys Tech 2000,http://www.kt2k.com --> " + CRLF
cCabHtml += "<!DOCTYPE html PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>" + CRLF
cCabHtml += "<html>" + CRLF
cCabHtml += "<head>" + CRLF
cCabHtml += "  <title>teste</title>" + CRLF
cCabHtml += "  <meta name='GENERATOR' content='AEdiX by Kirys Tech 2000,http://www.kt2k.com'>" + CRLF
cCabHtml += "</head>" + CRLF
cCabHtml += "<body bgcolor='#FFFFFF'>" + CRLF
cCabHtml += "" + CRLF

// Monta Rodape Html para posterior utiliza็ao
cRodHtml := "</body>" + CRLF
cRodHtml += "</html>" + CRLF

//Aqui come็a a montagem da pagina html propriamente dita
// acrescenta o cabe็alho
cFileCont := cCabHtml    

cLinFile := "<Table style='background: #FFFFFF; width: 100%;' border='1' cellpadding='2' cellspacing='2'>"

cLinFile += "<TR><TD style='Background: #FFFFC0; font-style: Bold;'><b>Status</b></TD>"
cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><b>Matricula</b></TD>"
cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>Filial</TD>"
cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>Centro Custo</TD>"
cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>Titular</TD>"
cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>Dependente</TD>"
cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>Motivo Erro</TD></TR>" + CRLF  

cFileCont += cLinFile

If fWrite(nHdl1,cFileCont,Len(cFileCont)) <> Len(cFileCont)
	apMsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
Endif			

cFileCont := ""
cLinFile  := ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicializa a regua de processamento                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lManual
	Processa({|| RunCont() },"Processando...")
Else
	RunCont()
EndIf
Return NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ RUNCONT  บ Autor ณ AP5 IDE            บ Data ณ  16/02/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function RunCont()
Local aArea      := SA1->( GetArea() )
Local nTamLin, cLin, cCpo
Local cprim     := .T.
Local cdata     := ""
Local cdata1    := ""
Local cdata2    := ""
Local cCep      := ""
Local ccgc      := ""
Local horagrava := ""
Local aLayout   := {}
Local cMesg
Local cMovto
Local cQuery    := ""

private ntenta  := 2
Private cPlanos := GetMv("MV_PLANOTR",,"28/29/30/31/32")

if lTemPerg
	Pergunte(cPerg, .F.)
Endif

cDtExp := right(Alltrim(MV_PAR05),4) + Left(Alltrim(MV_PAR05),2) + "01"

dbSelectArea(cAlias)
If lManual
	ProcRegua(RecCount())   // Numero de registros a processar
Endif

cQuery := "SELECT R_E_C_N_O_ as NumReg FROM " + RetSqlName("SRA") + " WHERE "
if lTemPerg
	cQuery += " RA_ASMEDIC IN " + FORMATIN(cPlanos, "/")
	cQuery += " AND RA_ASMEDIC <> ' ' "
    CQuery += " AND RA_SITFOLH = 'D' "
	cQuery += " AND RA_MDDTIN <= '" + cDtExp + "' "
	if !empty(MV_PAR01)
		cQuery += " AND RA_FILIAL >= '" + MV_PAR01 + "'"
	Endif

	if !empty(MV_PAR02)
		cQuery += " AND RA_FILIAL <= '" + MV_PAR02 + "'"
	Endif

    If !empty(MV_PAR01) .or. !empty(MV_PAR02)
		dbSelectArea( "PC6" ) 
		dbGotop()
		cLisCC := ""
		While !eof()
			if !empty(MV_PAR01) .and. !Empty(MV_PAR02)
				if PC6->PC6_FL_PL >= MV_PAR01 .and. PC6->PC6_FL_PL <= MV_PAR02
				    dbSelectArea("SM0")
	    			if !dbSeek( cEmpAnt + PC6->PC6_FL_PL )	//Filial Real
						cLisCC += Alltrim(PC6->PC6_CCUSTO) + "/"
					Endif
					dbSelectArea("PC6")
				Endif
			Elseif !empty(MV_PAR01) .and. Empty(MV_PAR02)
				if PC6->PC6_FL_PL >= MV_PAR01
				    dbSelectArea("SM0")
	    			if !dbSeek( cEmpAnt + PC6->PC6_FL_PL )	//Filial Real
						cLisCC += Alltrim(PC6->PC6_CCUSTO) + "/"
					Endif
					dbSelectArea("PC6")
                Endif 
			Elseif empty(MV_PAR01) .and. !Empty(MV_PAR02)
				if PC6->PC6_FL_PL <= MV_PAR02
				    dbSelectArea("SM0")
	    			if !dbSeek( cEmpAnt + PC6->PC6_FL_PL )	//Filial Real
						cLisCC += Alltrim(PC6->PC6_CCUSTO) + "/"
					Endif
					dbSelectArea("PC6")
                Endif
            Endif 
            dbSelectArea("PC6")
            dbSkip()
        End    

		if !Empty(cLisCC)	
			cQuery += " AND RA_CC IN " + FORMATIN( cLisCC, "/" )
		Endif
    Endif
    
    // Verifica matricula inicial
	if !empty(MV_PAR03)
	    cQuery += " AND RA_MAT >= '" + MV_PAR03 + "'"
	Endif
    
    // Verifica matricula Final
	if !empty(MV_PAR04)
	    cQuery += " AND RA_MAT <= '" + MV_PAR04 + "'"
	Endif

    cQuery += " AND RA_MEDMAT <> ' ' "
	
		
Else	
	cQuery += " RA_FILIAL = '" + cFilAnt + "'"
	cQuery += " RA_ASMEDIC IN " + FORMATIN(cPlanos, "/")
//	cQuery += " AND RA_SITFOLH IN (' ', 'A', 'F') "
	cQuery += " AND RA_MDDTIN <= '" + right(Alltrim(MV_PAR05),4) + Left(Alltrim(MV_PAR05),2) + "01' "
Endif

cQuery := ChangeQuery( cQuery )

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "TRB", .F., .T.)

dbSelectArea('TRB')

aLayout  := RTExpp2()

While TRB->(!EOF())

	if lManual
		Incproc()
	Endif
	
	dbSelectArea("SRA")
	SRA->(dbGoto(TRB->NumReg))

	cMovto := "04"   				// inclusao de titular
	dDataDem := u_RetDemD(1)

	IF MV_PAR07 <> 1
		if !empty(dDataDem) .and. dtos(dDataDem) <= cDtExp 
			cMovto := "03"
		Endif
	Endif			
	

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Incrementa a regua                                                  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lManual
		IncProc()
	EndIf

	if U_Demit(dDataDem, MV_PAR07)
		dbSelectArea("TRB")
		dbSkip()
		Loop
	Endif

	if dtos(u_RetDemD( 1 )) < "20070228"
		dbSelectArea("TRB")
		dbSkip()
		Loop
	Endif

	cFilCerta := SRA->RA_FILIAL
	
	dbselectarea( "PC6" )
	dbSetOrder(1)
	
	If dbSeek( xFilial("PC6") + SRA->RA_CC )
    	cFilCerta := PC6->PC6_FL_PL
	Endif
	dbSelectArea("SRA")
	cMesg := ""
	
	if !u_VerFilOk(cFilCerta) 
		cMesg := "COLABORADOR DA FILIAL " + cFilCerta + ", CADASTRADO NA FILIAL " + SRA->RA_FILIAL
	Else

		nTamLin := retTamLin(aLayout)   //tamanho da extensใo da linha 
		cLin    := ProcLayout(aLayout, nTamLin, @cMesg, cMovto)
		if empty(cMesg)
			GrvSRA()
		Endif

	Endif
	
	if empty(cMesg)
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ณ
		//ณ linha montada.                                                      ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cLin    += CRLF

		If fWrite(nHdl,cLin,Len(cLin)) <> Len(cLin)
			apMsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
			Exit
		Endif

		cLinFile := "<TR><TD style='Background: #FFFFC0; font-style: Bold;'>OK</TD>"
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRA->RA_MAT)+"</TD>"
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRA->RA_FILIAL)+"</TD>"
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRA->RA_CC)+"</TD>"
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRA->RA_NOME)+"</TD>"
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'> </TD>"
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+cMesg+"</TD></TR>" + CRLF  
		If fWrite(nHdl1,cLinFile,Len(cLinFile)) <> Len(cLinFile)
			apMsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
			Exit
		Endif			

	else
		cLinFile := "<TR><TD style='Background: #FFFFC0; font-style: Bold;'>ERRO</TD>"
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRA->RA_MAT)+"</TD>"
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRA->RA_FILIAL)+"</TD>"
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRA->RA_CC)+"</TD>"
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRA->RA_NOME)+"</TD>"
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'> </TD>"
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+cMesg+"</TD></TR>" + CRLF  
		If fWrite(nHdl1,cLinFile,Len(cLinFile)) <> Len(cLinFile)
			apMsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
			Exit
		Endif			
	Endif
	
	// avan็a leitura do arquivo principal
	dbSelectArea("TRB")
	dbSkip()
	
EndDo

dbSelectArea("TRB")
dbCloseArea()
dbSelectArea(cAlias)

cQuery := "SELECT RB.R_E_C_N_O_ as NumReg, RA.R_E_C_N_O_ as NumSRA FROM " + RetSqlName("SRB") + " RB, " + RetSqlName("SRA") + " RA WHERE "
if lTemPerg
	cQuery += " RA.RA_MAT = RB.RB_MAT AND RA.RA_FILIAL = RB.RB_FILIAL " 	
	cQuery += " AND RA_ASMEDIC IN " + FORMATIN(cPlanos, "/")
	cQuery += " AND RA_ASMEDIC <> ' ' "
	cQuery += " AND RA_SITFOLH = 'D' "
	cQuery += " AND RA_MDDTIN <= '" + cDtExp + "' "

	if !empty(MV_PAR01)
		cQuery += " AND RA_FILIAL >= '" + MV_PAR01 + "'"
	Endif

	if !empty(MV_PAR02)
		cQuery += " AND RA_FILIAL <= '" + MV_PAR02 + "'"
	Endif

    If !empty(MV_PAR01) .or. !empty(MV_PAR02)
		dbSelectArea( "PC6" ) 
		dbGotop()
		cLisCC := ""
		While !eof()
			if !empty(MV_PAR01) .and. !Empty(MV_PAR02)
				if PC6->PC6_FL_PL >= MV_PAR01 .and. PC6->PC6_FL_PL <= MV_PAR02
				    dbSelectArea("SM0")
	    			if !dbSeek( cEmpAnt + PC6->PC6_FL_PL )	//Filial Real
						cLisCC += Alltrim(PC6->PC6_CCUSTO) + "/"
					Endif
					dbSelectArea("PC6")
				Endif
			Elseif !empty(MV_PAR01) .and. Empty(MV_PAR02)
				if PC6->PC6_FL_PL >= MV_PAR01
				    dbSelectArea("SM0")
	    			if !dbSeek( cEmpAnt + PC6->PC6_FL_PL )	//Filial Real
						cLisCC += Alltrim(PC6->PC6_CCUSTO) + "/"
					Endif
					dbSelectArea("PC6")
                Endif 
			Elseif empty(MV_PAR01) .and. !Empty(MV_PAR02)
				if PC6->PC6_FL_PL <= MV_PAR02
				    dbSelectArea("SM0")
	    			if !dbSeek( cEmpAnt + PC6->PC6_FL_PL )	//Filial Real
						cLisCC += Alltrim(PC6->PC6_CCUSTO) + "/"
					Endif
					dbSelectArea("PC6")
                Endif
            Endif 
            dbSelectArea("PC6")
            dbSkip()
        End    

		if !Empty(cLisCC)	
			cQuery += " AND RA_CC IN " + FORMATIN( cLisCC, "/" )
		Endif
    Endif
    
    // Verifica matricula inicial
	if !empty(MV_PAR03)
	    cQuery += " AND RB_MAT >= '" + MV_PAR03 + "'"
	Endif
    
    // Verifica matricula Final
	if !empty(MV_PAR04)
	    cQuery += " AND RB_MAT <= '" + MV_PAR04 + "'"
	Endif
	
    cQuery += " AND RA_MEDMAT <> ' ' "
	
Else	
	cQuery += " RB_FILIAL = '" + cFilAnt + "'"
	cQuery += " RA_ASMEDIC IN " + FORMATIN(cPlanos, "/")
//	cQuery += " AND RA_SITFOLH IN (' ', 'A', 'F') "
	cQuery += " AND RA_MDDTIN <= '" + right(Alltrim(MV_PAR05),4) + Left(Alltrim(MV_PAR05),2) + "01' "
Endif

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "TRB", .F., .T.)

dbSelectArea('TRB')

aLayout1 := RTExpp3()
aLayout2 := RTExpp4()

While TRB->(!EOF())

	if lManual
		Incproc()
	Endif
	
	dbSelectArea("SRA")
    SRA->(dbGoto(TRB->NUMSRA))

	dbSelectArea("SRB")
	SRB->(dbGoto(TRB->NumReg)) 
    
	
	dDataDem := u_RetDemD(1)

	cMovto := "14" //Inclusao de dependente com titular ja cadastrado
	
	dDataDem := u_RetDemD(1)

	iF MV_PAR07 <> 1
		cMovto := "07" //Inclusao de dependente com titular ja cadastrado

		if !empty(dDataDem) .and. dtos(dDataDem) <= cDtExp 
			cMovto := "12"
		Endif 
		
	Endif

	If SRB->RB_GRAUPAR == "O"
		Do case
			Case cMovto == "07"
				cMovto := "08"
			case cMovto == "14"
				cMovto := "15"			
			Case cMovto == "18"
				cMovto := "17"			
			Case cMovto == "12"
				cMovto := "13"			
		EndCase
	Endif

	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Incrementa a regua                                                  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lManual
		IncProc()
	EndIf
	
	if U_Demit(dDataDem, MV_PAR07)
		dbSelectArea("TRB")
		dbSkip()
		Loop
	Endif

	if dtos(u_RetDemD( 2 )) < "20070228"
		dbSelectArea("TRB")
		dbSkip()
		Loop
	Endif


	cFilCerta := SRB->RB_FILIAL
	
	dbselectarea( "PC6" )
	dbSetOrder(1)
	
	If dbSeek( xFilial("PC6") + SRA->RA_CC )
    	cFilCerta := PC6->PC6_FL_PL
	Endif
	dbSelectArea("SRB")
	cMesg := ""
	
	if !u_VerFilOk(cFilCerta)
		cMesg := "COLABORADOR DA FILIAL " + cFilCerta + ", CADASTRADO NA FILIAL " + MV_PAR01
	Else
		IF SRB->RB_ASSIMED == "S"
			If SRB->RB_GRAUPAR $ "CF"
				nTamLin := retTamLin(aLayout1)   //tamanho da extensใo da linha
				cLin    := ProcLayout(aLayout1, nTamLin, @cMesg, cMovto)
				if empty(cMesg)
					GrvSRB()
				Endif
	
			Else 
				nTamLin := retTamLin(aLayout2)   //tamanho da extensใo da linha
				cLin    := ProcLayout(aLayout2, nTamLin, @cMesg, cMovto)
				if empty(cMesg)
					GrvSRB()
				Endif
			Endif			
			if empty(cMesg)
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ณ
				//ณ linha montada.                                                      ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				cLin    += CRLF
				If fWrite(nHdl,cLin,Len(cLin)) <> Len(cLin)
					apMsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
					Exit
				Endif

				cLinFile := "<TR><TD style='Background: #FFFFC0; font-style: Bold;'>OK</TD>"
				cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRA->RA_MAT)+"</TD>"
				cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRA->RA_FILIAL)+"</TD>"
				cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRA->RA_CC)+"</TD>"
				cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRA->RA_NOME)+"</TD>"
				cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRB->RB_NOME)+"</TD>"
				cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+cMesg+"</TD></TR>" + CRLF  
				If fWrite(nHdl1,cLinFile,Len(cLinFile)) <> Len(cLinFile)
					apMsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
					Exit
				Endif			
	
			else
				cLinFile := "<TR><TD style='Background: #FFFFC0; font-style: Bold;'>ERRO</TD>"
				cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRA->RA_MAT)+"</TD>"
				cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRA->RA_FILIAL)+"</TD>"
				cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRA->RA_CC)+"</TD>"
				cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRA->RA_NOME)+"</TD>"
				cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRB->RB_NOME)+"</TD>"
				cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+cMesg+"</TD></TR>" + CRLF  
				If fWrite(nHdl1,cLinFile,Len(cLinFile)) <> Len(cLinFile)
					apMsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
					Exit
				Endif			
			Endif
		Endif

	Endif

	// avan็a leitura do arquivo principal
	dbSelectArea("TRB")
	dbSkip()
	
EndDo

dbSelectArea("TRB")
dbCloseArea()
dbSelectArea(cAlias)




//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ณ
//ณ cao anterior.                                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cFileCount := "</Table>"+CRLF

//Acrescenta o rodap้ html
cFileCont += cRodHtml+CRLF
If fWrite(nHdl1,cFileCont,Len(cFileCont)) <> Len(cFileCont)
	apMsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
Endif			


fClose(nHdl)
fClose(nHdl1)

If lManual
	apMsgAlert("O arquivo foi gerado  no diretorio "+cdir)
EndIf

If lUsaFTP
	// Conexao FTP
	If !U_ConexFTP( ,,,, nTenta )
		ApMsgAlert( 'Nao foi possivel fazer conexao com FTP' )
	EndIf
EndIf

RestArea( aArea )
Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSelArq    บAutor  ณ Ernani Forastieri  บ Data ณ  20/04/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina auxiliar de Selecao do arquivo texto a ser importadoบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function SelArq()
Private _cExtens   := "Arquivo Texto ( *.TXT ) |*.TXT|"
_cRet := cGetFile( _cExtens, "Selecione o Arquivo",,, .F., GETF_NETWORKDRIVE + GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_RETDIRECTORY )
_cRet := ALLTRIM( _cRet )
Return( _cRet )



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRTExpp2   บAutor  ณMicrosiga           บ Data ณ  03/09/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RTExpp2()
Local aRet := {}
//           1                                                        2     3      4       5   6    7   8     9    10
//           Descricao do campo                                       Obrig Inic   fim    Pad  EXEC Val Pic, alin tip
aadd(aRet, {"IDENTIFICAวรO DO REGISTRO FUNCIONมRIO",                  "O",  "001", "001", "'1'",   "",  "", "", "D", "N" } )
aadd(aRet, {"NฺMERO SEQUENCIAL DO FUNCIONมRIO",                       "O",  "002", "008", "",    "Right(U_RETID(SRA->RA_FILIAL,SRA->RA_MAT,1),7)",  "", "" , "D", "N" } )
aadd(aRet, {"NOME DO FUNCIONมRIO",                                    "O",  "009", "048", "",    "SRA->RA_NOME",  "", "" , "E", "T" } )
aadd(aRet, {"CARGO DO FUNCIONมRIO",                                   "N",  "049", "073", "",    "U_RETCAR(SRA->RA_CODFUNC)",  "", "" , "E", "T" } )
aadd(aRet, {"ENDEREวO RESIDENCIAL",                                   "O",  "074", "103", "",    "U_RetEnd(SRA->RA_ENDEREC)",  "", "" , "E", "T" } )
aadd(aRet, {"NฺMERO DO ENDEREวO",                                     "N",  "104", "113", "",    "",  "", "" , "E", "T" } )
aadd(aRet, {"NฺMERO CASA OU APARTAMENTO",                             "N",  "114", "119", "",    "SRA->RA_COMPLEM",  "", "" , "E", "T" } )
aadd(aRet, {"BAIRRO DO ENDEREวO",                                     "N",  "120", "139", "",    "SRA->RA_BAIRRO",  "", "" , "E", "T" } )
aadd(aRet, {"CIDADE DO ENDEREวO",                                     "O",  "140", "159", "",    "SRA->RA_MUNICIP",  "", "" , "E", "T" } )
aadd(aRet, {"ESTADO DO ENDEREวO",                                     "N",  "160", "161", "",    "SRA->RA_ESTADO",  "", "" , "E", "T" } )
aadd(aRet, {"TELEFONE RESIDENCIAL",                                   "N",  "162", "170", "",    "SRA->RA_TELEFON",  "", "" , "E", "T" } )
aadd(aRet, {"CEP DA RESIDสNCIA",                                      "N",  "171", "178", "",    "SRA->RA_CEP",  "", "" , "D", "N" } )
aadd(aRet, {"ZONA RESIDENCIAL",                                       "N",  "179", "180", "'00'",    "",  "", "" , "D", "N" } ) //WM
aadd(aRet, {"DATA DE NASCIMENTO DDMMYYYY",                            "O",  "181", "188", "",    "U_Retdata(SRA->RA_NASC)",  "", "" , "D", "N" } )
aadd(aRet, {"SEXO",                                                   "O",  "189", "189", "",    "U_RETSEX(SRA->RA_SEXO)",  "", "" , "D", "N" } )
aadd(aRet, {"ESTADO CIVIL",                                           "O",  "190", "190", "",    "U_RETESC1(SRA->RA_ESTCIVI)",  "", "" , "D", "N" } )
aadd(aRet, {"Nบ. DA CARTEIRA PROFISSIONAL",                           "N",  "191", "204", "",    "SRA->RA_NUMCP",  "", "" , "E", "T" } )
aadd(aRet, {"Nบ DO  REG. GERAL (RG)",                                 "O",  "205", "218", "",    "SRA->RA_RG",  "", "" , "E", "T" } )
aadd(aRet, {"Nบ PROG. INT. SOCIAL.(PIS)",                             "N",  "219", "232", "",    "SRA->RA_PIS",  "", "" , "E", "T" } )
aadd(aRet, {"CำDIGO DO PLANO",                                        "O",  "233", "236", "",    "U_RETCPL1()",  "", "" , "D", "N" } )
aadd(aRet, {"TIPO DO PLANO",                                          "O",  "237", "237", "'0'",   "",  "", "" , "D", "N" } )
aadd(aRet, {"CLASSIFICAวรO DO PLANO",                                 "O",  "238", "239", "'00'",  "",  "", "" , "D", "N" } )
aadd(aRet, {"CำDIGO DE CARสNCIA DO PLANO",                            "N",  "240", "242", "'000'", "",  "", "" , "D", "N" } )
aadd(aRet, {"DATA DE ADMISSรO DO FUNCIONมRIO",                        "O",  "243", "250", "",    "U_RetInic(1)",  "", "" , "D", "N" } )
aadd(aRet, {"DATA DE INอCIO NO CONVสNIO",                             "O",  "251", "258", "",    "U_RetInic(1)",  "", "" , "D", "N" } )
aadd(aRet, {"NฺMERO DE MATRอCULA DO FUNCIONมRIO NA EMPRESA",          "N",  "259", "273", "",    "U_RetCCD()",  "", "" , "E", "T" } )
aadd(aRet, {"LOCALIZAวรO DO FUNCIONมRIO",                             "N",  "274", "283", "",    "SRA->RA_EQUIPE",  "", "" , "E", "T" } )
aadd(aRet, {"CำDIGO DE IDENTIFICAวรO DA EMPRESA JUNTO A NOTREDAME",   "O",  "284", "291", "",    "LEFT(U_RetPla('1'),4)",  "", "" , "D", "N" } )
aadd(aRet, {"CำDIGO DE MOVIMENTAวรO",                                 "O",  "292", "293", "",    "M->cTipMov",  "", "" , "D", "N" } )
aadd(aRet, {"DATA  DEMISSรO/DESLIGAMENTO",                            "N",  "294", "301", "",    "u_RetDem(1)",  "", "" , "D", "N" } )
aadd(aRet, {"Nบ CำDIGO DO FUNCIONมRIO NA NOTREDAME",                  "N",  "302", "308", "'0000000'",    "",  "", "" , "D", "N" } )
aadd(aRet, {"Nบ CำDIGO DA EMPRESA NA NOTREDAME",                      "N",  "309", "316", "",    "U_RetPla('1')",  "", "" , "D", "N" } )
aadd(aRet, {"Nบ DO CPF",                                              "O",  "317", "327", "",    "SRA->RA_CIC",  "", "" , "D", "N" } )
aadd(aRet, {"CำD. DDD DO TELEFONE RESIDENCIAL",                       "N",  "328", "331", "'0000'",    "",  "", "" , "E", "T" } )
aadd(aRet, {"CำDIGO IDENTIFICAวรO BENEFICIมRIO DO CLIENTE",           "O",  "332", "361", "",    "U_RETID(SRA->RA_FILIAL, SRA->RA_MAT,1)",  "", "" , "E", "T" } ) //WM
aadd(aRet, {"NOME DA MรE DO BENEFICIมRIO",                            "O",  "362", "401", "",    "U_RetMaeA()",  "", "" , "E", "T" } )
aadd(aRet, {"NUMERO DO CARTรO NACIONAL DE SAฺDE",                     "N",  "402", "412", "'00000000000'",    "",  "", "" , "D", "N" } )
aadd(aRet, {"MOTIVO PARA A 2ช VIA DE CARTEIRINHA",                    "N",  "413", "414", "'  '",    "",  "", "" , "D", "N" } )
aadd(aRet, {"ORGAO EMISSOR DO R.G.",                                  "N",  "415", "419", "",    "",  "", "" , "D", "N" } )
aadd(aRet, {"CODIGO DO PAIS EMISSOR do PAIS RG",                      "N",  "420", "422", "",    "",  "", "" , "D", "N" } )
aadd(aRet, {"COMPLEMENTO DO ENDERECO",                                "N",  "423", "437", "",    "",  "", "" , "D", "N" } )
aadd(aRet, {"CODIGO ESPECIFICO DO INSS (CEI)",                        "N",  "438", "452", "",    "",  "", "" , "D", "N" } )
aadd(aRet, {"IDENTIFICADOR DE RESULTADO NO PROCESSAMENTO",            "N",  "453", "453", "",    "",  "", "" , "D", "N" } )
aadd(aRet, {"RESULTADO DO PROCESSAMENTO",                             "N",  "454", "500", "",    "",  "", "" , "D", "N" } )

Return(aRet)

Static Function RTExpp3()
Local aRet := {}
//           1                                                        2     3      4       5   6    7   8     9    10
//           Descricao do campo                                       Obrig Inic   fim    Pad  EXEC Val Pic, alin tip
aadd(aRet, {"IDENTIFICAวรO DO REGISTRO DO DEPENDENTE",                "O",  "001", "001", "'2'",   "",  "", "", "D", "N" } )
aadd(aRet, {"NฺMERO SEQUENCIAL DO DEPENDENTE POR TITULAR",            "O",  "002", "003", "",      "SRB->RB_COD",  "", "" , "D", "N" } )
aadd(aRet, {"NOME DO DEPENDENTE",                                     "O",  "004", "043", "",      "SRB->RB_NOME",  "", "" , "E", "T" } )
aadd(aRet, {"PARENTESCO DO DEPENDENTE EM RELAวรO AO TITULAR",         "O",  "044", "045", "",      "U_RETPAR1()",  "", "" , "D", "N" } )
aadd(aRet, {"DATA DE NASCIMENTO DDMMYYYY",                            "O",  "046", "053", "",      "U_Retdata(SRB->RB_DTNASC)",  "", "" , "D", "N" } )
aadd(aRet, {"SEXO",                                                   "O",  "054", "054", "",      "U_RETSEX(SRB->RB_SEXO)",  "", "" , "D", "N" } )
aadd(aRet, {"ESTADO CIVIL",                                           "O",  "055", "055", "'1'",   "",  "", "" , "D", "N" } )
aadd(aRet, {"DATA DE INอCIO NO CONVสNIO",                             "O",  "056", "063", "",      "U_RetInic(2)",  "", "" , "D", "N" } )
aadd(aRet, {"CำDIGO DE IDENTIFICAวรO DA EMPRESA JUNTO A INTERMษDICA", "O",  "064", "071", "",      "U_RetPla('2')",  "", "" , "D", "N" } )
aadd(aRet, {"NฺMERO SEQUENCIAL DO FUNCIONมRIO",                       "N",  "072", "078", "'0000000'",    "",  "", "" , "D", "N" } )
aadd(aRet, {"CำDIGO DE MOVIMENTAวรO",                                 "O",  "079", "080", "",      "M->cTipMov",  "", "" , "D", "N" } )
aadd(aRet, {"DATA  DEMISSรO/DESLIGAMENTO",                            "N",  "081", "088", "",      "u_RetDem(2)",  "", "" , "D", "N" } )
aadd(aRet, {"NฺMERO DE MATRอCULA DO FUNCIONมRIO NA EMPRESA",          "N",  "089", "098", "",      "SRB->RB_MAT",  "", "" , "D", "N" } )
aadd(aRet, {"DATA DE CASAMENTO (ESPOSA OU MARIDO)",                   "N",  "099", "106", "",      "U_RETDCAS()",  "", "" , "D", "N" } )
aadd(aRet, {"CำDIGO DO PLANO",                                        "O",  "107", "110", "",      "U_RETCPL1()",  "", "" , "D", "N" } )
aadd(aRet, {"TIPO DO PLANO",                                          "O",  "111", "111", "'0'",   "",  "", "" , "D", "N" } )
aadd(aRet, {"CLASSIFICAวรO DO PLANO",                                 "O",  "112", "113", "'00'",  "",  "", "" , "D", "N" } )
aadd(aRet, {"DATA DE INอCIO NO PLANO",                                "O",  "114", "121", "",      "U_RetInic(2)",  "", "" , "D", "N" } )
aadd(aRet, {"CำDIGO DE CARสNCIA DO PLANO",                            "O",  "122", "124", "'000'", "",  "", "" , "D", "N" } )
aadd(aRet, {"CำDIGO IDENTIFICAวรO BENEFICIมRIO DO CLIENTE (DEPEND)",  "O",  "125", "154", "",      "U_RETID(SRA->RA_FILIAL, SRA->RA_MAT,2)",  "", "" , "E", "T" } ) //WM
aadd(aRet, {"CำDIGO IDENTIFICAวรO BENEFICIมRIO DO CLIENTE (TITULAR)", "N",  "155", "184", "",      "SRA->RA_MEDMAT",  "", "" , "E", "T" } ) //WM
aadd(aRet, {"NOME DA MรE DO BENEFICIมRIO",                            "O",  "185", "224", "",      "U_RetMaeB()",  "", "" , "E", "T" } )
aadd(aRet, {"MOTIVO PARA A 2ช VIA DE CARTEIRINHA",                    "N",  "225", "226", "  ",    "",  "", "" , "D", "N" } )
aadd(aRet, {"NUMERO DO CARTรO NACIONAL DE SAฺDE",                     "N",  "227", "237", "'00000000000'",    "",  "", "" , "D", "N" } )
aadd(aRet, {"NUMERO DO RG",                                           "N",  "238", "251", "'  '",    "",  "", "" , "D", "N" } )
aadd(aRet, {"ORGAO EMISSOR DO R.G.",                                  "N",  "252", "259", "",    "",  "", "" , "D", "N" } )
aadd(aRet, {"CODIGO DO PAIS EMISSOR do PAIS RG",                      "N",  "257", "274", "001",    "",  "", "" , "D", "N" } )
aadd(aRet, {"CODIGO ESPECIFICO DO INSS (CEI)",                        "N",  "260", "276", "",    "",  "", "" , "D", "N" } )
aadd(aRet, {"IDENTIFICADOR DE RESULTADO NO PROCESSAMENTO",            "N",  "277", "277", "",    "",  "", "" , "D", "N" } )
aadd(aRet, {"RESULTADO DO PROCESSAMENTO",                             "N",  "278", "500", "",    "",  "", "" , "D", "N" } )

Return(aRet)


Static Function RTExpp4()
Local aRet := {}
//           1                                                        2     3      4       5   6    7   8     9    10
//           Descricao do campo                                       Obrig Inic   fim    Pad  EXEC Val Pic, alin tip
aadd(aRet, {"IDENTIFICAวรO DO REGISTRO DO AGREGADO",                  "O",  "001", "001", "'3'",   "",  "", "", "D", "N" } )
aadd(aRet, {"NฺMERO SEQUENCIAL DO AGREGADO POR TITULAR",              "O",  "002", "003", "",      "SRB->RB_COD",  "", "" , "D", "N" } )
aadd(aRet, {"NOME DO AGREGADO",                                       "O",  "004", "043", "",      "SRB->RB_NOME",  "", "" , "E", "T" } )
aadd(aRet, {"PARENTESCO DO AGREGADO EM RELAวรO AO TITULAR",           "O",  "044", "045", "",      "U_RETPAR1()",  "", "" , "D", "N" } )
aadd(aRet, {"DATA DE NASCIMENTO DDMMYYYY",                            "O",  "046", "053", "",      "U_Retdata(SRB->RB_DTNASC)",  "", "" , "D", "N" } )
aadd(aRet, {"SEXO",                                                   "O",  "054", "054", "",      "U_RETSEX(SRB->RB_SEXO)",  "", "" , "D", "N" } )
aadd(aRet, {"ESTADO CIVIL",                                           "O",  "055", "055", "'1'",   "",  "", "" , "D", "N" } )
aadd(aRet, {"CำDIGO DO PLANO",                                        "O",  "056", "059", "",      "U_RETCPL1()",  "", "" , "D", "N" } )
aadd(aRet, {"TIPO DO PLANO",                                          "O",  "060", "060", "'0'",   "",  "", "" , "D", "N" } )
aadd(aRet, {"CLASSIFICAวรO DO PLANO",                                 "O",  "061", "062", "'00'",  "",  "", "" , "D", "N" } )
aadd(aRet, {"DATA DE INอCIO NO PLANO",                                "O",  "063", "070", "",      "U_RetInic(2)",  "", "" , "D", "N" } )
aadd(aRet, {"CำDIGO DE CARสNCIA DO PLANO",                            "O",  "071", "073", "'000'", "",  "", "" , "D", "N" } )
aadd(aRet, {"CำDIGO DE IDENTIFICAวรO DA EMPRESA JUNTO A INTERMษDICA", "O",  "074", "081", "",      "U_RetPla('2')",  "", "" , "D", "N" } )
aadd(aRet, {"NฺMERO SEQUENCIAL DO FUNCIONมRIO",                       "O",  "082", "088", "'0000000'",    "",  "", "" , "D", "N" } )
aadd(aRet, {"CำDIGO DE MOVIMENTAวรO",                                 "O",  "089", "090", "",      "M->cTipMov",  "", "" , "D", "N" } )
aadd(aRet, {"DATA  DEMISSรO/DESLIGAMENTO",                            "N",  "091", "098", "",      "u_RetDem(2)",  "", "" , "D", "N" } )
aadd(aRet, {"Nบ DO CPF",                                              "O",  "099", "109", "",      "SRA->RA_CIC",  "", "" , "D", "N" } )
aadd(aRet, {"CำDIGO IDENTIFICAวรO BENEFICIมRIO DO CLIENTE (DEPEND)",  "O",  "110", "139", "",      "U_RETID(SRA->RA_FILIAL, SRA->RA_MAT,2)",  "", "" , "E", "T" } ) //WM
aadd(aRet, {"CำDIGO IDENTIFICAวรO BENEFICIมRIO DO CLIENTE (TITULAR)", "N",  "140", "169", "",      "SRA->RA_MEDMAT",  "", "" , "E", "T" } ) //WM
aadd(aRet, {"NOME DA MรE DO BENEFICIมRIO",                            "O",  "170", "209", "",      "U_REtMaeB()",  "", "" , "E", "T" } )
aadd(aRet, {"MOTIVO PARA A 2ช VIA DE CARTEIRINHA",                    "N",  "210", "211", "  ",    "",  "", "" , "D", "N" } )
aadd(aRet, {"IDENTIFICADOR DE RESULTADO NO PROCESSAMENTO",            "N",  "212", "212", "",    "",  "", "" , "D", "N" } )
aadd(aRet, {"RESULTADO DO PROCESSAMENTO",                             "N",  "213", "500", "",    "",  "", "" , "D", "N" } )

Return(aRet)


static function retTamLin(aLayout)
Local nRet := 0
aeval(alayout, {|x,y| nRet += ((val(x[4])-Val(x[3]))+1)} )
Return(nRet)


Static Function ProcLayout(aLayout, nTamLin, cMesg, cMovto)
Local cRet := ""
Local nT := 0
Private cVar
Private cTemp
Private nTam
Private cTipMov := cMovto
//           1                                                        2     3      4       5   6    7   8     9    10
//           Descricao do campo                                       Obrig Inic   fim    Pad  EXEC Val Pic, alin tip

For nT := 1 to len(aLayout)
	nTam := (Val(aLayout[nt,4])-Val(aLayout[nt,3]))+1
	cVar := ""
	if !empty(aLayout[nT,5])
		cTemp := aLayout[nT,5]
		cVar := eval( { || &cTemp } )
	Endif
	if !empty(aLayout[nT,6])
		cTemp := aLayout[nT,6]
		cVar := eval( { || &cTemp } )
	Endif
	if Empty(cVar) .and. upper(aLayout[nT,2]) == "O"
		cMesg := "Campo " + aLayout[nT,1] + " obrigatorio nใo preenchido!!"
		Return Nil
	Endif
	if Empty(cVar)
		if aLayout[nT,10] == "T"
			cVar := space(nTam)
		Else
			cVar := Replicate("0",nTam)
		Endif
	Endif
	if Upper(aLayout[nT,10]) == "T"
		cTemp := " "
	Else
		cTemp := "0"
	Endif
	if Upper(aLayout[nt,9]) == "E"
		cVar := padr(cVar, nTam, cTemp)
	Else
		cVar := padl(cVar, nTam, cTemp)
	Endif
	cRet += cVar
Next nt
Return(cRet)

Static Function GrvSRA()
Local aArea := GetArea()

dbSelectArea("SRA")

if FieldPos("RA_MSEXP") > 0 .and. FieldPos("RA_ENVAS") > 0
	RecLock("SRA", .F.)
	SRA->RA_MSEXP := cDtExp
	SRA->RA_ENVAS := "S"
	MsUnlock()
Endif

Restarea(aArea)
Return nil


Static Function GrvSRB()
Local aArea := GetArea()

dbSelectArea("SRB")

if FieldPos("RB_MSEXP") > 0 .and. FieldPos("RB_ENVAS") > 0
	RecLock("SRB", .F.)
	SRB->RB_MSEXP := cDtExp
	SRB->RB_ENVAS := "S"
	MsUnlock()
Endif

Restarea(aArea)
Return nil


