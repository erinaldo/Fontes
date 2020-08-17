#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TBICONN.CH'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RTExppn  บ Autor ณ WM                         บ Data ณ  09/03/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina de exporta็ใo de arquivos Notre Dame.                       บฑฑ
ฑฑบ          ณ                                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gestao de Pessoal                                                  บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ >>>>>>>>>>>>>>>>>  ALTERACOES DESDE A CONSTRUCAO INICIAL  <<<<<<<<<<<<<<<<<<< บฑฑ
ฑฑฬออออออออออออออหออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista Resp.บ  Data  ณ Manutencao Efetuada                                   บฑฑ
ฑฑวฤฤฤฤฤฤฤฤฤฤฤฤฤฤืฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถฑฑ
ฑฑบ              บ31/01/08ณ- Incluido tratamento para exclusใo do funcionแrio  de บฑฑ
ฑฑบ              บ        ณ  um plano, em caso de transfer๊ncia de plano.         บฑฑ
ฑฑบ              บ        ณ  (Rotina AltPlano())                                  บฑฑ
ฑฑบ              บ        ณ- Alterado o codigo de "49" para "11" nas  Transferen- บฑฑ
ฑฑบ              บ        ณ  cias.                                                บฑฑ
ฑฑวฤฤฤฤฤฤฤฤฤฤฤฤฤฤืฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถฑฑ
ฑฑบWilliam Camposบ09/04/08ณ- Ajustes no lay-out, conforme  documento  apresentado บฑฑ
ฑฑบ   TI2388     บ        ณ  pela Notre Dame.                                     บฑฑ
ฑฑวฤฤฤฤฤฤฤฤฤฤฤฤฤฤืฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถฑฑ
ฑฑบ              บ        ณ MV_PLANOTR = "28/29/30/31/32"                         บฑฑ
ฑฑศออออออออออออออสออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RTExppN(aParams)

Local		aSay		:= {}
Local		aButton	:= {}
Local		nOpc		:= 0
Local		cTitulo	:= "Notredame"
Local		cDesc1	:= "Esta rotina ira fazer a exportacao do cadastro"
Local		cDesc2	:= "de Funcionarios para a Notredame."
Local		cDesc3	:= ""
Local       cArqNotre
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private	lManual		:= IIf( aParams == NIL, .T.		, aParams[1][1] )
Private	cEmpresa	:= IIf( lManual, SM0->M0_CODIGO	, aParams[1][2] )
Private	cFil		:= IIf( lManual, SM0->M0_CODFIL	, aParams[1][3] )
Private	cPerg		:= PADR("RTEXPX",LEN(SX1->X1_GRUPO))
Private	oGeraTxt
Private	cAlias		:= "SRA"			//alias do arquivo a exportar
Private	cDir		:= ''
Private	lUsaFTP		:= .F.
Private	cDirFTP		:= ''
Private cCpoPlan 	:= "RA_ASMEDIC"
Private cNivelFun 	:= ""
Private cFuncao   	:= ""
Private nSeq		:= 1
Private cMotExc		:= ''
Private cDescPla	:= ''
Private cEndereco   := ''
Private cNumero     := ''

nHdlNotre := 0
nHdlXNotr := 0

If !lManual
	// Prepara ambiente se for JOB
	RpcSetType(3)
	RpcSetEnv(cEmpresa, cFil,,,'FIN')
EndIf
// ROTINA PARA VERIFICAR SE USA FTP
//cDir := AllTrim(GetMv("EX_LISPAT",,"C:\temp"))	// Caminho local
cDir := AllTrim(GetMv("EX_LISPAT",,"C:\Asr\Lixo"))  // Caminho local
cDir += If(Right(Alltrim(cDir),1) # "\","\","")
cArqNotre := cDir + "NOTRE_DAME_"  + Dtos(dDataBase)

nHdlNotre := fOpen(cArqNotre + ".TXT",2)
nHdlXNotr := fOpen(cArqNotre + ".XLS",2)
If nHdlNotre == -1 .OR. nHdlXNotr == -1
	ApMsgAlert("O arquivo  "+cArqNotre+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return
Endif
// Posiciona o Final dos Arquivos
fSeek(nHdlNotre,0,2)
fSeek(nHdlXNotr,0,2)

lUsaFTP		:= GetMV('EX_USAFTP',,.f.)						// Parametro para utilizar ou nใo FTP
If lUsaFTP == .T.
	cDirFTP	:= GetMV( 'EX_LISFTP',,'/')						//caminho do FTP
EndIf
dbSelectArea(cAlias)
dbSetOrder(1)

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
ฑฑบUso       ณ                                                            บฑฑ
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
//Private cBaseArq  := aLLTRIM(MV_PAR96)
//Private cExtensao := ".TXT"
//Private cArqTxt   := cdir+If(RighT(cdir,1)=="\","","\")+cBaseArq+cExtensao
//Private cArqFTP   := cDirFTP+cBaseArq+cExtensao
//Private nHdl      := 0
//Private nHdl1     := 0
Private aLog      := {}
Private cCabHtml  := ""
Private cRodHtml  := ""
Private cFileCont := ""
Private cLinFile  := ""
Private cDescPla  := ""
Private aTransf   := {}
Private aExcTit   := {}
Private cFilExc   := GetMv("MV_FILEXC",,"04/08/93/91")	// Define as empresas que ficarao fora na geracao do arquivo de Assistencia Medica
Private cDtExp			  := MV_PAR06
Private cDtExpAte		  := MV_PAR07
//cDtExp	:= right(Alltrim(MV_PAR05),4) + Left(Alltrim(MV_PAR05),2) + "01"


/*
MakeDir( cDir )
nHdl		:= fCreate(cArqTxt, 0)
nhdl1		:= fCreate(cdir+cBaseArq+".XLS",0)
If nHdl == -1 .OR. nHdl1 == -1
ApMsgAlert("O arquivo  "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
Return NIL
Endif
*/
//monta cabe็alho de pagina HTML para posterior utiliza็ใo
cCabHtml	:= "<!-- Created with AEdiX by Kirys Tech 2000,http://www.kt2k.com --> " + CRLF
cCabHtml	+= "<!DOCTYPE html PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>" + CRLF
cCabHtml	+= "<html>" + CRLF
cCabHtml	+= "<head>" + CRLF
cCabHtml	+= "  <title>teste</title>" + CRLF
cCabHtml	+= "  <meta name='GENERATOR' content='AEdiX by Kirys Tech 2000,http://www.kt2k.com'>" + CRLF
cCabHtml	+= "</head>" + CRLF
cCabHtml	+= "<body bgcolor='#FFFFFF'>" + CRLF
cCabHtml	+= "" + CRLF
// Monta Rodape Html para posterior utiliza็ao
cRodHtml	:= "</body>" + CRLF
cRodHtml	+= "</html>" + CRLF
// Aqui come็a a montagem da pagina html propriamente dita
// acrescenta o cabe็alho
cFileCont	:= cCabHtml
cLinFile		:= "<Table style='background: #FFFFFF; width: 100%;' border='1' cellpadding='2' cellspacing='2'>"
cLinFile		+= "<TR><TD style='Background: #FFFFC0; font-style: Bold;'><b>Status</b></TD>"
cLinFile		+= "<TD style='Background: #FFFFC0; font-style: Bold;'><b>Matricula</b></TD>"
cLinFile		+= "<TD style='Background: #FFFFC0; font-style: Bold;'>Filial</TD>"
cLinFile		+= "<TD style='Background: #FFFFC0; font-style: Bold;'>Centro Custo</TD>"
cLinFile		+= "<TD style='Background: #FFFFC0; font-style: Bold;'>Titular</TD>"
cLinFile		+= "<TD style='Background: #FFFFC0; font-style: Bold;'>Dependente</TD>"
cLinFile 		+= "<TD style='Background: #FFFFC0; font-style: Bold;'>Data Admissao</TD>"
cLinFile		+= "<TD style='Background: #FFFFC0; font-style: Bold;'>Data Demissao</TD>"
cLinFile 		+= "<TD style='Background: #FFFFC0; font-style: Bold;'>CPF</TD>"
cLinFile 		+= "<TD style='Background: #FFFFC0; font-style: Bold;'>Sit. Folha</TD>"
cLinFile 		+= "<TD style='Background: #FFFFC0; font-style: Bold;'>Cod.Movimentacao</TD>"
cLinFile 		+= "<TD style='Background: #FFFFC0; font-style: Bold;'>Funcao</TD>"
cLinFile 		+= "<TD style='Background: #FFFFC0; font-style: Bold;'>Nivel Funcao</TD>"
cLinFile 		+= "<TD style='Background: #FFFFC0; font-style: Bold;'>Carga Horaria</TD>"
cLinFile		+= "<TD style='Background: #FFFFC0; font-style: Bold;'>Motivo Erro</TD></TR>" + CRLF
cFileCont	+= cLinFile
If fWrite(nHdlXNotr,cFileCont,Len(cFileCont)) <> Len(cFileCont)
	apMsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
Endif
cFileCont	:= ""
cLinFile		:= ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicializa a regua de processamento                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RunCont()

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

Local	aArea			:= SA1->( GetArea() )
Private	nTamLin, cLin, cCpo
Private	cprim			:= .T.
Private	cdata			:= ""
Private	cdata1		:= ""
Private	cdata2		:= ""
Private	cCep			:= ""
Private	ccgc			:= ""
Private	horagrava	:= ""
Private	aLayout		:= {}
Private	cMesg
Private	cMovto
Private	cQuery		:= ""
Private	cInicio		:= ""
private	ntenta		:= 2
Private	cPlanos		:= Alltrim(GetMv("MV_PLANOTR",,"28/29/30/31/32"))	// Planos Notre Dame
Private cPlanTransf := Alltrim(GetMv("MV_PLAINT",,"27"))				// Planos Intermedica

Pergunte(cPerg, .F.)

cDtExp := MV_PAR06
//cDtExp := right(Alltrim(MV_PAR05),4) + Left(Alltrim(MV_PAR05),2) + "01"
dbSelectArea(cAlias)
If lManual
	//ProcRegua(RecCount())   // Numero de registros a processar
Endif

// Transferencia Entre Planos (Intermedica x Notre Dame)
TransfPlan()
// Exclusao titulares
ExcTit()
// Altera็ใo de plano
//AltPlan()
// Inclusao titulares
IncTit()
// Altera็ใo titulares
AltTit()
// Inclusao de dependentes com titular ja cadastrado
IncDep1()
// altera็ใo de dependentes exclusiva
AltDep1()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ณ
//ณ cao anterior.                                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cFileCount := "</Table>"+CRLF
//Acrescenta o rodap้ html
cFileCont += cRodHtml+CRLF
If fWrite(nHdlXNotr,cFileCont,Len(cFileCont)) <> Len(cFileCont)
	apMsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
Endif
fClose(nHdlNotre)
fClose(nHdlXNotr)
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
ฑฑบPrograma  ณRTExpp2   บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RTExpp2()

Local aRet := {}
Local cDescPla := ''

//           1                                          2     	3      4       5   					 6    															7   8    9    10
//           Descricao do campo                         Obrig 	Inic  	fim    Pad  				 EXEC 					Val Pic alin tip
aadd(aRet, {"01-NUMERO SEQUENCIAL DA LINHA NO ARQUIVO"	,"O"	,"006"	,"000",""	,"Padr(Strzero(nSeq++,6),6)"			,""	,""	,"D" ,"N" } )
aadd(aRet, {"02-CำDIGO DE MOVIMENTAวรO"					,"O"	,"002"	,"000",""	,"PadR(M->cTipMov,2)"					,""	,""	,"D" ,"N" } )
aadd(aRet, {"03-CำDIGO UNICO DA FAMILIA"				,"O"	,"015"	,"000",""	,"PadR(SRA->RA_CIC,11)"					,""	,""	,"D" ,"N" } ) //VERIFICAR SE E CODIGO UNICO DA FAMILIA
aadd(aRet, {"04-GRAU DE PARENTESCO"                  	,"N"	,"002"	,"000","00"	,""										,""	,""	,"D" ,"N" } )
aadd(aRet, {"05-NOME DO FUNCIONมRIO"					,"O"	,"100"	,"000",""	,"PadR(SRA->RA_NOME,100)"				,""	,""	,"E" ,"T" } )
aadd(aRet, {"06-NOME DA MรE"							,"O"	,"100"	,"000",""	,"PadR(U_RetMaeA(),100)"				,""	,""	,"E" ,"T" } )
aadd(aRet, {"07-DOENวA CRONICA"							,"N"	,"001"	,"000",""	,"Space(1)"								,""	,""	,"E" ,"T" } )
aadd(aRet, {"08-FILHO UNIVERSITมRIO"					,"N"	,"001"	,"000",""	,"Space(1)"								,""	,""	,"E" ,"T" } )
aadd(aRet, {"09-CARGO DO FUNCIONมRIO"					,"O"	,"025"	,"000",""	,"PadR(U_RETCAR(SRA->RA_CODFUNC),25)"	,""	,""	,"E" ,"T" } )
aadd(aRet, {"10-LOGRADOURO"          					,"N"	,"100"	,"000",""	,"PadR(cEndereco,100)"					,"" ,""	,"E" ,"T" } )
aadd(aRet, {"11-NฺMERO DO ENDEREวO"						,"N"	,"005"	,"000",""	,"PadR(cNumero,05)"						,"" ,""	,"E" ,"T" } )
aadd(aRet, {"12-COMPLEMENTO DO ENDEREวO"				,"N"	,"050"	,"000",""	,"PadR(SRA->RA_COMPLEM,50)"				,"" ,""	,"E" ,"T" } )
aadd(aRet, {"13-BAIRRO DO ENDEREวO"						,"N"	,"030"	,"000",""	,"PadR(SRA->RA_BAIRRO,30)"				,"" ,""	,"E" ,"T" } )
aadd(aRet, {"14-CIDADE DO ENDEREวO"						,"N"	,"030"	,"000",""	,"PadR(SRA->RA_MUNICIP,30)"				,"" ,""	,"E" ,"T" } )
aadd(aRet, {"15-ESTADO DO ENDEREวO"						,"N"	,"002"	,"000",""	,"PadR(SRA->RA_ESTADO,2)"				,"" ,""	,"E" ,"T" } )
aadd(aRet, {"16-CEP DA RESIDสNCIA"						,"O"	,"008"	,"000",""	,"PadR(SRA->RA_CEP,8)"					,""	,""	,"D" ,"N" } )
aadd(aRet, {"17-DDD TELEFONE RESIDENCIAL"				,"N"	,"003"	,"000",""	,"Space(3)"								,"" ,""	,"D" ,"N" } )
aadd(aRet, {"18-TELEFONE RESIDENCIAL"					,"N"	,"010"	,"000",""	,"PadR(SRA->RA_TELEFON,10)"				,"" ,""	,"D" ,"N" } )
aadd(aRet, {"19-DATA DE NASCIMENTO DDMMYYYY"			,"O"	,"008"	,"000",""	,"PadR(U_Retdata(SRA->RA_NASC),8)"		,""	,""	,"D" ,"N" } )
aadd(aRet, {"20-SEXO"									,"O"	,"001"	,"000",""	,"PadR(SRA->RA_SEXO,1)"					,""	,""	,"E" ,"T" } )
aadd(aRet, {"21-ESTADO CIVIL"							,"O"	,"001"	,"000",""	,"PadR(U_RETESC1(SRA->RA_ESTCIVI),1)"	,""	,""	,"D" ,"N" } )
aadd(aRet, {"22-Nบ DO CPF"								,"O"	,"014"	,"000",""	,"PadR(SRA->RA_CIC,11)"					,""	,""	,"D" ,"N" } )
aadd(aRet, {"23-Nบ DO  REG. GERAL (RG)"					,"O"	,"020"	,"000",""	,"PadR(SRA->RA_RG,20)"					,""	,""	,"D" ,"N" } )
aadd(aRet, {"24-DATA DE EXPEDIวรO DO RG"				,"O"	,"008"	,"000",""	,"PadR(U_RetData(SRA->RA_RGDTEMI),8)"	,"" ,""	,"D" ,"N" } )
aadd(aRet, {"25-ORGAO EMISSOR DO R.G."					,"N"	,"005"	,"000",""	,"PadR(SRA->RA_RGORG,5)"				,"" ,""	,"D" ,"N" } )
aadd(aRet, {"26-UF EMISSOR DO RG"     					,"O"	,"002"	,"000",""	,"PadR(SRA->RA_RGUF,2)"					,"" ,""	,"E" ,"T" } )
aadd(aRet, {"27-CODIGO DO PAIS EMISSOR do PAIS RG"		,"O"	,"002"	,"000","32"	,""										,"" ,""	,"D" ,"N" } )
aadd(aRet, {"28-CำDIGO DO BANCO DO TITULAR"       		,"N"	,"003"	,"000",""	,"Space(3)"								,"" ,""	,"D" ,"N" } )
aadd(aRet, {"29-NฺMERO DA AGENCIA DO TITULAR"     		,"N"	,"010"	,"000",""	,"Space(10)"							,"" ,""	,"D" ,"N" } )
aadd(aRet, {"30-DIGITO VERIF. DA AGENCIA DO TITULAR"	,"N"	,"005"	,"000",""	,"Space(5)"								,"" ,""	,"E" ,"T" } )
aadd(aRet, {"31-NUMERO DA CONTA DO TITULAR"    			,"N"	,"015"	,"000",""	,"Space(15)"							,"" ,""	,"E" ,"T" } )
aadd(aRet, {"32-DIGITO VERIFICADOR DA CONTA DO TITULAR"	,"N"	,"005"	,"000",""	,"Space(5)"								,"" ,""	,"E" ,"T" } )
aadd(aRet, {"33-DATA DO EVENTO (ELEGIBILIDADE"  		,"O"	,"008"	,"000",""	,"PadR(u_retdata(SRA->RA_ADMISSA),8)"	,"" ,""	,"D" ,"N" } )
aadd(aRet, {"34-DATA DE INอCIO NO CONVสNIO"				,"O"	,"008"	,"000",""	,"PadR(U_RetInic(1),8)"					,"" ,""	,"D" ,"N" } )
aadd(aRet, {"35-DESCRICAO DO PLANO"						,"O"	,"050"	,"000",""	,"PadR(cDescPla,50)"					,""	,""	,"E" ,"T" } )
aadd(aRet, {"36-CำDIGO DA EMPRESA CLIENTE"				,"O"	,"010"	,"000",""	,"PadR(LEFT( U_RetPla('1'),4),10)"		,"" ,""	,"D" ,"N" } ) // VERIFICAR SE ษ ISSO MESMO
aadd(aRet, {"37-CำDIGO DA EMPRESA PARA TRANSFERENCIA"	,"N"	,"004"	,"000",""	,"Space(4)"								,"" ,""	,"D" ,"N" } ) //SOMENTE TRANSFERENCIA
aadd(aRet, {"38-CำDIGO DO LOCAL"						,"O"	,"010"	,"000",""	,"PadR(SRA->RA_FILIAL,02)"	  			,"" ,""	,"D" ,"N" } )
aadd(aRet, {"39-CENTRO DE CUSTO DO FUNCIONARIO"			,"O"	,"010"	,"000",""	,"PadR(SRA->RA_CC,10)"					,"" ,""	,"D" ,"N" } )
aadd(aRet, {"40-DDD DO TELEFONE CELULAR"       			,"N"	,"003"	,"000",""	,"Space(3)"								,"" ,""	,"D" ,"N" } )
aadd(aRet, {"41-TELEFONE CELULAR"               		,"N"	,"010"	,"000",""	,"Space(10)"							,"" ,""	,"D" ,"N" } )
aadd(aRet, {"42-E-MAIL DO TITULAR"						,"N"	,"100"	,"000",""	,"Space(100)"							,"" ,""	,"E" ,"T" } )
aadd(aRet, {"43-NUMERO DO PIS"							,"N"	,"015"	,"000",""	,"PadR(SRA->RA_PIS,15)"					,"" ,""	,"D" ,"N" } )
aadd(aRet, {"44-NUMERO Da CARTEIRA NACIONAL DE SAUDE"	,"N"	,"015"	,"000",""	,"Space(15)"							,"" ,""	,"D" ,"N" } )
aadd(aRet, {"45-DATA  EXCLUSรO DO PLANO"				,"N"	,"008"	,"000",""	,"PadR(u_RetDem(1),8)"					,"" ,""	,"D" ,"N" } ) // DATA DE DEMISSAO?
aadd(aRet, {"46-CODIGO DO MOTIVO DE EXCLUSAO"			,"N"	,"001"	,"000",""	,"PadR(cMotExc,1)"						,"" ,""	,"D" ,"N" } )

Return(aRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRTExpp3   บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RTExpp3()

Local aRet := {}
Local cDescPla := ''

//           1                                          2     	3      4       5   	6    															7   8    9    10
//           Descricao do campo                         Obrig 	Inic  	fim    Pad  EXEC 							Val Pic alin tipaadd(aRet, {"1-NUMERO SEQUENCIAL DA LINHA NO ARQUIVO"	,"O"	,"000"	,"000",""	,"Padr(Strzero(nSeq++,6))"		,""	,""	,"D" ,"N" } )
aadd(aRet, {"01-NUMERO SEQUENCIAL DA LINHA NO ARQUIVO"		,"O"	,"006"	,"000",""	,"Padr(Strzero(nSeq++,6),6)"	,""	,""	,"D" ,"N" } )
aadd(aRet, {"02-CำDIGO DE MOVIMENTAวรO"						,"O"	,"002"	,"000",""	,"PadR(M->cTipMov,2)"			,""	,""	,"D" ,"N" } )
aadd(aRet, {"03-CำDIGO UNICO DA FAMILIA"					,"O"	,"015"	,"000",""	,"PadR(SRA->RA_CIC,11)"			,""	,""	,"D" ,"N" } ) //VERIFICAR SE E CODIGO UNICO DA FAMILIA
aadd(aRet, {"04-GRAU DE PARENTESCO"                  		,"O"	,"002"	,"000",""	,"PadR(U_RETPAR1(),2)"			,""	,""	,"D" ,"N" } )
aadd(aRet, {"05-NOME DO FUNCIONมRIO"						,"O"	,"100"	,"000",""	,"PadR(SRB->RB_NOME,100)"		,""	,""	,"D" ,"N" } )
aadd(aRet, {"06-NOME DA MรE"								,"O"	,"100"	,"000",""	,"PadR(U_RetMaeB(),100)"		,""	,""	,"E" ,"T" } )
aadd(aRet, {"07-DOENวA CRONICA"								,"N"	,"001"	,"000",""	,"Space(1)"						,""	,""	,"E" ,"T" } )
aadd(aRet, {"08-FILHO UNIVERSITมRIO"						,"N"	,"001"	,"000",""	,"Space(1)"						,""	,""	,"E" ,"T" } )
aadd(aRet, {"09-CARGO DO FUNCIONมRIO"						,"N"	,"025"	,"000",""	,"Space(25)"					,""	,""	,"E" ,"T" } )
aadd(aRet, {"10-LOGRADOURO"          						,"N"	,"100"	,"000",""	,"Space(100)"					,"",""	,"E" ,"T" } )
aadd(aRet, {"11-NฺMERO DO ENDEREวO"							,"N"	,"005"	,"000",""	,"Space(5)"						,"",""	,"E" ,"T" } )
aadd(aRet, {"12-COMPLEMENTO DO ENDEREวO"					,"N"	,"050"	,"000",""	,"Space(50)"					,"",""	,"E" ,"T" } )
aadd(aRet, {"13-BAIRRO DO ENDEREวO"							,"N"	,"030"	,"000",""	,"Space(30)"					,"",""	,"E" ,"T" } )
aadd(aRet, {"14-CIDADE DO ENDEREวO"							,"N"	,"030"	,"000",""	,"Space(30)"					,"",""	,"E" ,"T" } )
aadd(aRet, {"15-ESTADO DO ENDEREวO"							,"N"	,"002"	,"000",""	,"Space(2)"						,"",""	,"E" ,"T" } )
aadd(aRet, {"16-CEP DA RESIDสNCIA"							,"N"	,"008"	,"000",""	,"Space(8)"						,""	,""	,"D" ,"N" } )
aadd(aRet, {"17-DDD TELEFONE RESIDENCIAL"					,"N"	,"003"	,"000",""	,"Space(3)"						,"",""	,"D" ,"N" } )
aadd(aRet, {"18-TELEFONE RESIDENCIAL"						,"N"	,"010"	,"000",""	,"Space(10)"					,"",""	,"D" ,"N" } )
aadd(aRet, {"19-DATA DE NASCIMENTO DDMMYYYY"				,"O"	,"008"	,"000",""	,"PadR(U_Retdata(SRB->RB_DTNASC),8)"	,""	,""	,"D" ,"N" } )
aadd(aRet, {"20-SEXO"										,"O"	,"001"	,"000",""	,"PadR(SRB->RB_SEXO,1)"			,""	,""	,"E" ,"T" } )
aadd(aRet, {"21-ESTADO CIVIL"								,"N"	,"001"	,"000",""	,"Space(1)"						,""	,""	,"D" ,"N" } )
aadd(aRet, {"22-Nบ DO CPF"									,"N"	,"014"	,"000",""	,"Space(11)"					,""	,""	,"D" ,"N" } )
aadd(aRet, {"23-Nบ DO  REG. GERAL (RG)"						,"N"	,"020"	,"000",""	,"Space(20)"					,""	,""	,"E" ,"T" } )
aadd(aRet, {"24-DATA DE EXPEDIวรO DO RG"					,"N"	,"008"	,"000",""	,"Space(8)"						,"" ,""	,"D" ,"N" } )
aadd(aRet, {"25-ORGAO EMISSOR DO R.G."						,"N"	,"005"	,"000",""	,"Space(5)"						,"" ,""	,"E" ,"T" } ) //VERIFICAR SE PRECISA INFORMAR O ORGAO EMISSOR
aadd(aRet, {"26-UF EMISSOR DO RG"     						,"N"	,"002"	,"000",""	,"Space(2)"						,"" ,""	,"E" ,"T" } ) //VERIFICAR SE PRECISA INFORMAR A UF DO ORGAO EMISSOR
aadd(aRet, {"27-CODIGO DO PAIS EMISSOR do PAIS RG"			,"O"	,"002"	,"000","32"	,""								,"" ,""	,"D" ,"N" } )
aadd(aRet, {"28-CำDIGO DO BANCO DO TITULAR"       			,"N"	,"003"	,"000",""	,"Space(3)"						,"" ,""	,"D" ,"N" } )
aadd(aRet, {"29-NฺMERO DA AGENCIA DO TITULAR"     			,"N"	,"010"	,"000",""	,"Space(10)"					,"" ,""	,"D" ,"N" } )
aadd(aRet, {"30-DIGITO VERIFICADOR DA AGENCIA DO TITULAR"	,"N"	,"005"	,"000",""	,"Space(5)"						,"" ,""	,"E" ,"T" } )
aadd(aRet, {"31-NUMERO DA CONTA DO TITULAR"       			,"N"	,"015"	,"000",""	,"Space(15)"					,"" ,""	,"E" ,"T" } )
aadd(aRet, {"32-DIGITO VERIFICADOR DA CONTA DO TITULAR"		,"N"	,"005"	,"000",""	,"Space(5)"						,"" ,""	,"E" ,"T" } )
aadd(aRet, {"33-DATA DO EVENTO (ELEGIBILIDADE"  			,"O"	,"008"	,"000",""	,"PadR(u_retdata(SRA->RA_ADMISSA),8)"	,"" ,""	,"D" ,"N" } )
aadd(aRet, {"34-DATA DE INอCIO NO CONVสNIO"					,"O"	,"008"	,"000",""	,"PadR(U_RetInic(2),8)"			,"" ,""	,"D" ,"N" } )
aadd(aRet, {"35-DESCRICAO DO PLANO"							,"O"	,"050"	,"000",""	,"Padr(cDescPla,50)"			,""	,""	,"E" ,"T" } )
aadd(aRet, {"36-CำDIGO DA EMPRESA CLIENTE"					,"O"	,"010"	,"000",""	,"PadR(LEFT( U_RetPla('2'),4),10)"	,"" ,""	,"D" ,"N" } ) // VERIFICAR SE ษ ISSO MESMO
aadd(aRet, {"37-CำDIGO DA EMPRESA PARA TRANSFERENCIA"		,"N"	,"004"	,"000",""	,"Space(4)"						,"" ,""	,"D" ,"N" } ) //SOMENTE TRANSFERENCIA
aadd(aRet, {"38-CำDIGO DO LOCAL"							,"O"	,"010"	,"000",""	,"PadR(SRA->RA_FILIAL,02)"		,"" ,""	,"D" ,"N" } )
aadd(aRet, {"39-CENTRO DE CUSTO DO FUNCIONARIO"				,"N"	,"010"	,"000",""	,"Space(10)"					,"" ,""	,"D" ,"N" } )
aadd(aRet, {"40-DDD DO TELEFONE CELULAR"       				,"N"	,"003"	,"000",""	,"Space(3)"						,"" ,""	,"D" ,"N" } )
aadd(aRet, {"41-TELEFONE CELULAR"               			,"N"	,"010"	,"000",""	,"Space(10)"					,"" ,""	,"D" ,"N" } )
aadd(aRet, {"42-E-MAIL DO TITULAR"							,"N"	,"100"	,"000",""	,"Space(100)"					,"" ,""	,"E" ,"T" } )
aadd(aRet, {"43-NUMERO DO PIS"								,"N"	,"015"	,"000",""	,"Space(15)"					,"" ,""	,"D" ,"N" } )
aadd(aRet, {"44-NUMERO Da CARTEIRA NACIONAL DE SAUDE"		,"N"	,"015"	,"000",""	,"Space(15)"					,"" ,""	,"D" ,"N" } )
aadd(aRet, {"45-DATA  EXCLUSรO DO PLANO"					,"N"	,"008"	,"000",""	,"PadR(u_RetDem(2),8)"			,"" ,""	,"D" ,"N" } )
aadd(aRet, {"46-CODIGO DO MOTIVO DE EXCLUSAO"				,"N"	,"001"	,"000",""	,"PadR(cMotExc,2)"				,"" ,""	,"D" ,"N" } )

Return(aRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRTExpp4   บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

Static Function RTExpp4()

Local aRet := {}
//           1                                                       	2     3    4      5   			 	 6    												 			7   8    9    10
//           Descricao do campo                                      	Obrig Inic fim    Pad  			 	 EXEC 												 			Val Pic, alin tip
aadd(aRet, {"IDENTIFICAวรO DO REGISTRO DO AGREGADO"						,"O","001","001","'3'"				,""																,"",""	,"D","N" } )
aadd(aRet, {"NฺMERO SEQUENCIAL DO AGREGADO POR TITULAR"					,"O","002","003",""					,"PadR(SRB->RB_COD,2)"										,"",""	,"D","N" } )
aadd(aRet, {"NOME DO AGREGADO"											,"O","004","043",""					,"PadR(SRB->RB_NOME,40)"									,"",""	,"E","T" } )
aadd(aRet, {"PARENTESCO DO AGREGADO EM RELAวรO AO TITULAR"				,"O","044","045",""					,"PadR(U_RETPAR1(),2)"										,"",""	,"D","N" } )
aadd(aRet, {"DATA DE NASCIMENTO DDMMYYYY"								,"O","046","053",""					,"PadR(U_Retdata(SRB->RB_DTNASC),8)"					,"",""	,"D","N" } )
aadd(aRet, {"SEXO"														,"O","054","054",""					,"PadR(U_RETSEX(SRB->RB_SEXO),1)"						,"",""	,"D","N" } )
aadd(aRet, {"ESTADO CIVIL"												,"O","055","055","'1'"				,""																,"",""	,"D","N" } )
aadd(aRet, {"CำDIGO DO PLANO"											,"O","056","059",""					,"PadR(U_RETCPL1(),4)"										,"",""	,"D","N" } )
aadd(aRet, {"TIPO DO PLANO"												,"O","060","060","'0'"				,""																,"",""	,"D","N" } )
aadd(aRet, {"CLASSIFICAวรO DO PLANO"									,"O","061","062","'00'"				,""																,"",""	,"D","N" } )
aadd(aRet, {"DATA DE INอCIO NO PLANO"									,"O","063","070",""					,"PadR(U_RetInic(2),8)"										,"",""	,"D","N" } )
aadd(aRet, {"CำDIGO DE CARสNCIA DO PLANO"								,"O","071","073","'000'"			,""																,"",""	,"D","N" } )
aadd(aRet, {"CำDIGO DE IDENTIFICAวรO DA EMPRESA JUNTO A INTERMษDICA"	,"O","074","081",""					,"PadR(U_RetPla('2'),8)"									,"",""	,"D","N" } )
aadd(aRet, {"NฺMERO SEQUENCIAL DO FUNCIONมRIO"							,"O","082","088","'0000000'"		,""																,"",""	,"D","N" } )
aadd(aRet, {"CำDIGO DE MOVIMENTAวรO"									,"O","089","090",""					,"PadR(M->cTipMov,2)"										,"",""	,"D","N" } )
aadd(aRet, {"DATA  DEMISSรO/DESLIGAMENTO"								,"N","091","098",""					,"PadR(u_RetDem(2),8)"										,"",""	,"D","N" } )
aadd(aRet, {"Nบ DO CPF"													,"O","099","109",""					,"PadR(SRA->RA_CIC,11)"										,"",""	,"D","N" } )
aadd(aRet, {"CำDIGO IDENTIFICAวรO BENEFICIมRIO DO CLIENTE (DEPEND)"		,"O","110","139",""					,"PadR(U_RETID(SRA->RA_FILIAL, SRA->RA_MAT,2,'RB_MATNOTR'),20)"	,"",""	,"E","T" } ) //WM
aadd(aRet, {"CำDIGO IDENTIFICAวรO BENEFICIมRIO DO CLIENTE (TITULAR)"	,"N","140","169",""					,"PadR(SRA->RA_MATNOTR,30)"									,"",""	,"E","T" } ) //WM
aadd(aRet, {"NOME DA MรE DO BENEFICIมRIO"								,"O","170","209",""					,"PadR(U_REtMaeB(),40)"										,"",""	,"E","T" } )
aadd(aRet, {"MOTIVO PARA A 2ช VIA DE CARTEIRINHA"						,"N","210","211","  "				,"Space(2)"														,"",""	,"D","N" } )
aadd(aRet, {"IDENTIFICADOR DE RESULTADO NO PROCESSAMENTO"				,"N","212","212",""					,"Space(1)"														,"",""	,"D","N" } )
aadd(aRet, {"RESULTADO DO PROCESSAMENTO"								,"N","213","500",""					,"Space(288)"													,"",""	,"D","N" } )
Return(aRet)
*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณretTamLin บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function retTamLin(aLayout)

Local nRet := 0
aeval(alayout, {|x,y| nRet += ((val(x[4])-Val(x[3]))+1)} )
Return(nRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProcLayOutบAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
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
	nTam := (Val(aLayout[nt,3]))
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
	If nt < Len(aLayout)
		cRet +=';'
	Endif
Next nt
Return(cRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetCPL1   บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user Function RETCPL1()

Local cRet := ""
Local cCadPla := SRA->RA_ASMEDIC

If cCpoPlan == "RA_ASMANT"
	cCadPla := SRA->RA_ASMANT
EndIf

Do case
	Case cCadPla $ "28/31"
		cRet := "6067"
	Case cCadPla $ "29/30/32"
		cRet := "6102"
EndCase
Return(cRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetPar1   บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RetPar1()

cRet := ""
if SRB->RB_GRAUPAR == "C"
	cRet := "01"
Elseif SRB->RB_GRAUPAR == "F"
	cRet := "03"
Elseif SRB->RB_GRAUPAR == "O"
	cRet := "02"
Endif
Return(cRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPerg04    บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*
User Function PERG04(cPerg)

Local aArea := GetArea()
Local aHelp	:= {}
Aadd(aHelp,{{"Periodo de referencia.(mmaaaa)"	},	{"Reference period.(mmyyyy)"  },{"Periodo de referencia.(mmaaaa)" 		}})
Aadd(aHelp,{{"Informe o numero da filial."		},	{"Inform the branch  number."	},{"Informe el numero de la sucursal.	"	}})
Aadd(aHelp,{{"Informe a matricula."					},	{"Inform the registration."	},{"Infome el matricula."						}})
Aadd(aHelp,{{"Informe o nome."						},	{"Inform the name"         	},{"Infome el nombre."   						}})
Aadd(aHelp,{{"Informe o Cento de Custo."			},	{"Inform the Cost Center."		},{"Infome el Centro Costo."					}})
PutSx1(cPerg, "01","Filial De                     ?","จDe Sucursal    ?","From Branch        ?","mv_ch1","C",02,0,0,"G","NaoVazio"	, "SM0","","","mv_par01"	," "		," "		," "		,"",""			,""			,""			,""		,""		,""			,"","","","",""," ",aHelp[2][1],aHelp[2][2],aHelp[2][3])
PutSx1(cPerg, "02","Filial Ate                    ?","จate Sucursal   ?","to   Branch        ?","mv_ch2","C",02,0,0,"G","NaoVazio"	, "SM0","","","mv_par02"	," "		," "		," "		,"",""			,""			,""			,""		,""		,""			,"","","","",""," ",aHelp[2][1],aHelp[2][2],aHelp[2][3])
PutSx1(cPerg, "03","Matricula de                  ?","จDe Matricula   ?","From Registration  ?","mv_ch3","C",06,0,0,"G",""  		   , "SRA","","","mv_par03"	," "		," "		," "		,"",""			,""			,""			,""		,""		,""			,"","","","",""," ",aHelp[3][1],aHelp[3][2],aHelp[3][3])
PutSx1(cPerg, "04","Matricula ate                 ?","จA Matricula    ?","To Registration    ?","mv_ch4","C",06,0,0,"G",""			, "SRA","","","mv_par04"	," "		," "		," "		,"",""			,""			,""			,""		,""		,""			,"","","","",""," ",aHelp[3][1],aHelp[3][2],aHelp[3][3])
PutSx1(cPerg, "05","Gerar Mes e Ano               ?","จMes Y Ano      ?","Month and Year     ?","mv_ch5","C",06,0,0,"G","NaoVazio"	, "   ","","","mv_par05"	," "		," "		," "		,"",""			,""			,""			,""		,""		,""			,"","","","",""," ",aHelp[1][1],aHelp[1][2],aHelp[1][3])
PutSx1(cPerg, "06","Nome do Arquivo               ?","จIgnora C/C     ?","Ignora C/C         ?","mv_ch6","C",60,0,0,"G",""			, "   ","","",""				," "		," "		," "		,"",""			,""			,""			,""		,""		,""			,"","","","",""," ",aHelp[5][1],aHelp[5][2],aHelp[5][3])
PutSx1(cPerg, "07","Carga Inicial/reenvio/normal  ?","จMes Y Ano      ?","Month and Year     ?","mv_ch7","N",01,0,0,"C","NaoVazio"	, "   ","","","mv_par07"	,"Carga"	,"Carga"	,"Carga"	,"","Reenvio"	,"Reenvio"	,"Reenvio"	,"Normal","Normal","Normal"	,"","","","",""," ",aHelp[1][1],aHelp[1][2],aHelp[1][3])
RestArea(aArea)
Return NIL
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetEsc1   บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RETESC1(cEstCiv)

Local cEstcivi := " "
Local aArea := GetArea()

do case
	case SRA->RA_ESTCIVI == "C" ; cEstcivi := "2" // CASADO
	case SRA->RA_ESTCIVI == "D" ; cEstcivi := "4" // DIVORCIADO
	case SRA->RA_ESTCIVI == "M" ; cEstcivi := "5" // MARITAL
	case SRA->RA_ESTCIVI == "Q" ; cEstcivi := "4" // DESQUITADO
	case SRA->RA_ESTCIVI == "S" ; cEstcivi := "1" // SOLTEIRO
	case SRA->RA_ESTCIVI == "V" ; cEstcivi := "3" // VIUVO
EndCase

RestArea(aArea)

Return(cEstcivi)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetMaeB   บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RetMaeB()

Local cRet := ""
Local aArea := GetArea()
dbSelectArea("SRB")
if !Empty(aLLTRIM(SRB->RB_MAE))
	cRet := SRB->RB_MAE
Else
	cRet := U_FicMae(SRB->RB_FILIAL, SRB->RB_MAT)
Endif
RestArea(aArea)
Return(cRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetmaeA   บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RetMaeA()

Local cRet := ""
Local aArea := GetArea()
dbSelectArea("SRA")
if !Empty(aLLTRIM(SRA->RA_MAE))
	cRet := SRA->RA_MAE
Else
	cRet := U_FicMae(SRA->RA_FILIAL, SRA->RA_MAT)
Endif
RestArea(aArea)
Return(cRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFicMae    บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FicMae(cFilPes, cMatPes)

Local cRet1  := ""
Local aArea1 := GetArea()
Local aArea2 := SRA->(GetArea())
Local nPos   := 0
dbSelectArea("SRA")
dbSetOrder(1)
if dbSeek( cFilPes + cMatPes)
	nPos := rat(" ", Alltrim(SRA->RA_NOME))
	if nPos > 0
		cRet1 := "JOSEFA " + Substr(Alltrim(SRA->RA_NOME), nPos+1)
	Endif
Endif
RestArea(aArea2)
RestArea(aArea1)
Return(cRet1)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVerFilOk  บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function VerFilOk(cFilCerta)

Local lRet := .T.
If !Empty(MV_PAR01) .and. !Empty(MV_PAR02)
	if cFilCerta < MV_PAR01 .OR. cFilCerta > MV_PAR02
		lRet := .F.
	Endif
Elseif !Empty(MV_PAR01) .and. Empty(MV_PAR02)
	if cFilCerta < MV_PAR01
		lRet := .F.
	Endif
Elseif Empty(MV_PAR01) .and. !Empty(MV_PAR02)
	if cFilCerta > MV_PAR02
		lRet := .F.
	Endif
Endif
Return(lRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDemit     บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Demit(dDemit, nTipo)

Local lRet := .F.
Local cVar := ""
Local cComp := Month(cDtExp)+Year(cDtExp) //left(CDtExp,6)
//Local cComp := left(CDtExp,6)
IF !SRA->RA_SITFOLH $ " AF"
	if nTipo <> 1 .and. !empty(dDemit)
		cVar := Alltrim(str(Year(dDemit))) + Alltrim(strzero(month(dDemit),2))
		if cVar > cComp
			lRet := .T.
		Endif
	Elseif nTipo == 1 .and. !empty(dDemit) .and. SRA->RA_SITFOLH == "D"
		lRet := .T.
	Endif
Endif
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPrcRegSRA บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PrcRegSra(cMotivo)

cFilCerta := SRA->RA_FILIAL

If SRJ->(dbSeek( xFilial("SRJ") + SRA->RA_CODFUNC ) )
	cNivelFun := Alltrim(Srj->Rj_Nivel)
	cFuncao   := Alltrim(Srj->Rj_Desc)
Endif

dbselectarea( "PC6" )
dbSetOrder(1)
If dbSeek( xFilial("PC6") + SRA->RA_CC )
	cFilCerta := PC6->PC6_FL_PL
Endif
dbSelectArea("SRA")
cMesg := ""
if !U_VerFilOk(cFilCerta)
	cMesg := "COLABORADOR DA FILIAL " + cFilCerta + ", CADASTRADO NA FILIAL " + SRA->RA_FILIAL
Else
	nTamLin := retTamLin(aLayout)   //tamanho da extensใo da linha
	cLin    := ProcLayout(aLayout, nTamLin, @cMesg, cMovto)
Endif
if empty(cMesg)
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ณ
	//ณ linha montada.                                                      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cLin    += CRLF
	If fWrite(nHdlNotre,cLin,Len(cLin)) <> Len(cLin)
		apMsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
	Endif
	
	Set Century On
	cLinFile := "<TR><TD style='Background: #FFFFC0; font-style: Bold;'>OK</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRA->RA_MAT)+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRA->RA_FILIAL)+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRA->RA_CC)+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRA->RA_NOME)+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'> </TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Dtoc(Sra->Ra_Admissa)+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Dtoc(Sra->Ra_Demissa)+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(Sra->Ra_Cic)+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Sra->Ra_SitFolh+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+cMovto+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+cFuncao+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+cNivelFun+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Str(Sra->Ra_HrsMes)+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+cMesg+"</TD></TR>" + CRLF
	Set Century Off
	
	If fWrite(nHdlXNotr,cLinFile,Len(cLinFile)) <> Len(cLinFile)
		apMsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
	Endif
else
	Set Century On
	cLinFile := "<TR><TD style='Background: #FFFFC0; font-style: Bold;'>ERRO</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRA->RA_MAT)+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRA->RA_FILIAL)+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRA->RA_CC)+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRA->RA_NOME)+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'> </TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Dtoc(Sra->Ra_Admissa)+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Dtoc(Sra->Ra_Demissa)+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(Sra->Ra_Cic)+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Sra->Ra_SitFolh+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+cMovto+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+cFuncao+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+cNivelFun+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Str(Sra->Ra_HrsMes)+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+cMesg+"</TD></TR>" + CRLF
	Set Century Off
	
	If fWrite(nHdlXNotr,cLinFile,Len(cLinFile)) <> Len(cLinFile)
		apMsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
	Endif
Endif
Return nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIncTit    บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IncTit()

cQuery := "SELECT R_E_C_N_O_ as NumReg FROM " + RetSqlName("SRA") + " WHERE "
cQuery += " RA_ASMEDIC IN " + FORMATIN(cPlanos, "/")
cQuery += " AND RA_ASMEDIC <> ' ' "
CQuery += " AND RA_SITFOLH IN (' ', 'A', 'F') "
cQuery += " AND RA_FILIAL NOT IN " + FORMATIN(cFilExc, "/") + " "
cQuery += " AND RA_ADMISSA >= '" + DtoC(cDtExp)  + "' "
cQuery += " AND RA_ADMISSA <= '" + DtoC(cDtExpAte) + "' "
//cQuery += " AND RA_ADMISSA <= '" + cDtExp + "' "
cTemp := " AND ( ("
If !empty(MV_PAR01) .or. !empty(MV_PAR02)
	if !empty(MV_PAR01)
		cQuery += cTemp + "RA_FILIAL >= '" + MV_PAR01 + "'"
		cTemp := " AND "
	Endif
	if !empty(MV_PAR02)
		cQuery += cTemp + " RA_FILIAL <= '" + MV_PAR02 + "'"
		cTemp := " OR "
	Endif
	If cTemp == " AND "
		cTemp := " OR "
	Endif
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
	Enddo
	
	if !Empty(cLisCC)
		cQuery += ") " + cTemp + " ( RA_CC IN " + FORMATIN( cLisCC, "/" ) + " ) "
		cTemp := " OR "
	Else
		cQuery += " ) "
	Endif
	IF cTemp == " OR "
		cQuery += " ) "
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
// Verifica o Tipo da Rotina
if !empty(mv_par05)
	if mv_par05 == 3
		cQuery += " AND SUBSTRING(RA_CTRNOTR,1,1) IN ('N', ' ') "
	Elseif mv_par05 == 2
		cQuery += " AND SUBSTRING(RA_CTRNOTR,1,1) IN ('N', ' ') "
		cSql := "UPDATE " + RetSqlName("SRA") + " SET RA_CTRNOTR = 'N'+SUBSTRING(RA_CTRNOTR,2,2) WHERE SUBSTRING(RA_CTRNOTR,1,1) = '1' "
		if !Empty(MV_PAR01)
			cSql += " AND RA_FILIAL >= '" + MV_PAR01 + "' "
		Endif
		if !Empty(MV_PAR02)
			cSql += " AND RA_FILIAL <= '" + MV_PAR02 + "' "
		Endif
		cSql += " AND RA_ASMEDIC IN " + FORMATIN(cPlanos, "/") + " AND RA_ASMEDIC <> ' ' "
		tcSqlExec(cSql)
	Endif
Endif
cQuery += " AND D_E_L_E_T_ = ' ' "

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "TRB", .F., .T.)
dbSelectArea('TRB')
aLayout  := RTExpp2()
While TRB->(!EOF())
	cMovto	:= "01"
	
	dbSelectArea("SRA")
	SRA->(dbGoto(TRB->NumReg))
	
	// Busca o endereco do funcionario e separa o numero do endereco.
	fEndereco(SRA->RA_ENDEREC)
	cDescPla:= SubStr(Posicione("SRX", 1, xFilial("SRX")+"22  "+SRA->RA_ASMEDIC,"RX_TXT"),1,20)
	
	If SRA->RA_ASMANT <> "  " .And. (SRA->RA_ASMEDIC <> SRA->RA_ASMANT)
		RecLock("SRA", .F.)
		SRA->RA_MDDTIN := Ctod( "" )
		MsUnlock()
	EndIf
	
	cInicio := U_RetInic(1)
	cInicio := right(cInicio,4) + substr(cInicio, 3,2)
	if cInicio >= Alltrim(Str(Year(cDtExp))) + Alltrim(Str(Month(cDtExp)))
		//	if cInicio >= left(cDtExp,6)
		dbSelectArea("TRB")
		dbSkip()
		Loop
	Endif
	
	cMesg := ""
	PrCRegSRA(cMovto)
	if empty(cMesg)
		dbSelectArea("SRA")
		RecLock("SRA", .F.)
		SRA->RA_CTRNOTR := "1" + Right(SRA->RA_CTRNOTR,2)
		MsUnlock()
	Endif
	IncDep()
	// avan็a leitura do arquivo principal
	dbSelectArea("TRB")
	dbSkip()
EndDo
dbSelectArea("TRB")
dbCloseArea()
dbSelectArea(cAlias)
Return nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIncDep    บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IncDep()

Local nRegSRA := SRA->(Recno())

cQuery := "SELECT RB.R_E_C_N_O_ as NumReg, RA.R_E_C_N_O_ as NumSRA FROM " + RetSqlName("SRB") + " RB, " + RetSqlName("SRA") + " RA WHERE "
cQuery += " RA.RA_MAT = RB.RB_MAT AND RA.RA_FILIAL = RB.RB_FILIAL "
cQuery += " AND RA.RA_MAT = '"+SRA->RA_MAT+"' "
cQuery += " AND RA.RA_FILIAL = '"+SRA->RA_FILIAL+"' "
cQuery += " AND SUBSTRING(RB.RB_CTRNOTR,1,1) IN ('N', ' ') "
cQuery += " AND RB.RB_ASSIMED = 'S' "
cQuery += " AND RB.RB_GRAUPAR IN('C','F') "
cQuery += " AND RA.D_E_L_E_T_ = ' ' "
cQuery += " AND RB.D_E_L_E_T_ = ' ' "

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "TRB2", .F., .T.)
dbSelectArea('TRB2')
aLayout1 := RTExpp3()
//aLayout2 := RTExpp4()
While TRB2->(!EOF())
	cMovto := "02"
	
	dbSelectArea("SRA")
	SRA->(dbGoto(TRB2->NUMSRA))
	dbSelectArea("SRB")
	SRB->(dbGoto(TRB2->NumReg))
	
	cDescPla:= SubStr(Posicione("SRX", 1, xFilial("SRX")+"22  "+SRA->RA_ASMEDIC,"RX_TXT"),1,20)
	cInicio := u_RetInic(1)
	cInicio := right(cInicio,4) + substr(cInicio, 3,2)
	if cInicio >= Alltrim(Str(Year(cDtExp))) + Alltrim(Str(Month(cDtExp)))
		//	if cInicio >= left(cDtExp,6)
		dbSelectArea("TRB2")
		dbSkip()
		Loop
	Endif
	
	cMesg := ""
	PrcRegSRB(cMovto)
	If Empty(cMesg)
		dbSelectArea("SRB")
		RecLock("SRB", .F.)
		SRB->RB_CTRNOTR := "1" + Right(SRB->RB_CTRNOTR,2)
		MsUnlock()
	Endif
	// avan็a leitura do arquivo principal
	dbSelectArea("TRB2")
	dbSkip()
EndDo
dbSelectArea("TRB2")
dbCloseArea()
dbSelectArea(cAlias)
dbSelectArea("SRA")
dbGoto(nRegSRA)
Return nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPrcRegSRB บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PrcRegSRB(cMovimento)

cMovto := cMovimento
/*
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
*/

cFilCerta := SRB->RB_FILIAL
dbselectarea( "PC6" )
dbSetOrder(1)
If dbSeek( xFilial("PC6") + SRA->RA_CC )
	cFilCerta := PC6->PC6_FL_PL
Endif
dbSelectArea("SRB")
cMesg := ""
if !U_VerFilOk(cFilCerta)
	cMesg := "COLABORADOR DA FILIAL " + cFilCerta + ", CADASTRADO NA FILIAL " + MV_PAR01
Else
	//If SRB->RB_GRAUPAR $ "C*F"
	nTamLin := retTamLin(aLayout1)   //tamanho da extensใo da linha
	cLin    := ProcLayout(aLayout1, nTamLin, @cMesg, cMovto)
	
	//DESABILITADO POR ISAMU, POIS SEGUNDO A CARLA NESSES CASOS N'AO DEVE CARREGAR DEPENDENTES
	//Else
	//nTamLin := retTamLin(aLayout2)   //tamanho da extensใo da linha
	//cLin    := ProcLayout(aLayout2, nTamLin, @cMesg, cMovto)
	//Endif
Endif

if empty(cMesg)
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ณ
	//ณ linha montada.                                                      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cLin    += CRLF
	If fWrite(nHdlNotre,cLin,Len(cLin)) <> Len(cLin)
		apMsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
	Endif
	
	Set Century On
	cLinFile := "<TR><TD style='Background: #FFFFC0; font-style: Bold;'>OK</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRA->RA_MAT)+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRA->RA_FILIAL)+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRA->RA_CC)+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRA->RA_NOME)+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRB->RB_NOME)+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Dtoc(Sra->Ra_Admissa)+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Dtoc(Sra->Ra_Demissa)+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(Sra->Ra_Cic)+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Sra->Ra_SitFolh+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+cMovto+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+cFuncao+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+cNivelFun+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Str(Sra->Ra_HrsMes)+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+cMesg+"</TD></TR>" + CRLF
	Set Century Off
	
	If fWrite(nHdlXNotr,cLinFile,Len(cLinFile)) <> Len(cLinFile)
		apMsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
	Endif
else
	
	Set Century On
	cLinFile := "<TR><TD style='Background: #FFFFC0; font-style: Bold;'>ERRO</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRA->RA_MAT)+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRA->RA_FILIAL)+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRA->RA_CC)+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRA->RA_NOME)+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRB->RB_NOME)+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Dtoc(Sra->Ra_Admissa)+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Dtoc(Sra->Ra_Demissa)+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(Sra->Ra_Cic)+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Sra->Ra_SitFolh+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+cMovto+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+cFuncao+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+cNivelFun+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Str(Sra->Ra_HrsMes)+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+cMesg+"</TD></TR>" + CRLF
	Set Century Off
	
	If fWrite(nHdlXNotr,cLinFile,Len(cLinFile)) <> Len(cLinFile)
		apMsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
	Endif
Endif

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAltTit    บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AltTit()

cQuery := "SELECT R_E_C_N_O_ as NumReg FROM " + RetSqlName("SRA") + " WHERE "
cQuery += " RA_ASMEDIC IN " + FORMATIN(cPlanos, "/")
cQuery += " AND RA_ASMEDIC <> ' ' "
CQuery += " AND RA_SITFOLH IN (' ', 'A', 'F') "
cQuery += " AND RA_FILIAL NOT IN " + FORMATIN(cFilExc, "/") + " "
cQuery += " AND RA_ALTAMED = 'S' "
cTemp := " AND ( ("
If !empty(MV_PAR01) .or. !empty(MV_PAR02)
	if !empty(MV_PAR01)
		cQuery += cTemp + "RA_FILIAL >= '" + MV_PAR01 + "'"
		cTemp := " AND "
	Endif
	if !empty(MV_PAR02)
		cQuery += cTemp + " RA_FILIAL <= '" + MV_PAR02 + "'"
		cTemp := " OR "
	Endif
	If cTemp == " AND "
		cTemp := " OR "
	Endif
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
		cQuery += ") " + cTemp + " ( RA_CC IN " + FORMATIN( cLisCC, "/" ) + " ) "
		cTemp := " OR "
	Else
		cQuery += " ) "
	Endif
	IF cTemp == " OR "
		cQuery += " ) "
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
cQuery += " AND D_E_L_E_T_ = ' ' "

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "TRB", .F., .T.)
dbSelectArea('TRB')
aLayout  := RTExpp2()
While TRB->(!EOF())
	cMovto := "03"
	
	dbSelectArea("SRA")
	SRA->(dbGoto(TRB->NumReg))
	
	
	// Busca o endereco do funcionario e separa o numero do endereco.
	fEndereco(SRA->RA_ENDEREC)
	
	cInicio := U_RetInic(1)
	cInicio := right(cInicio,4) + substr(cInicio, 3,2)
	if cInicio >= Alltrim(Str(Year(cDtExp))) + Alltrim(Str(Month(cDtExp)))
		//	if cInicio >= left(cDtExp,6)
		dbSelectArea("TRB")
		dbSkip()
		Loop
	Endif
	
	cMesg := ""
	PrCRegSRA(cMovto)
	if empty(cMesg)
		dbSelectArea("SRA")
		RecLock("SRA", .F.)
		SRA->RA_ALTAMED := "N"
		MsUnlock()
	Endif
	ALTDep()
	// avan็a leitura do arquivo principal
	dbSelectArea("TRB")
	dbSkip()
EndDo
dbSelectArea("TRB")
dbCloseArea()
dbSelectArea(cAlias)
Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAltDep    บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ALTDep()

Local nRegSRA := SRA->(Recno())

cQuery := "SELECT RB.R_E_C_N_O_ as NumReg, RA.R_E_C_N_O_ as NumSRA FROM " + RetSqlName("SRB") + " RB, " + RetSqlName("SRA") + " RA WHERE "
cQuery += " RA.RA_MAT = RB.RB_MAT AND RA.RA_FILIAL = RB.RB_FILIAL "
cQuery += " AND RA.RA_MAT = '"+SRA->RA_MAT+"' "
cQuery += " AND RA.RA_FILIAL = '"+SRA->RA_FILIAL+"' "
cQuery += " AND RB.RB_ALTAMED = 'S' "
cQuery += " AND RB.RB_ASSIMED = 'S' "
cQuery += " AND RA.D_E_L_E_T_ = ' ' "
cQuery += " AND RB.D_E_L_E_T_ = ' ' "

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "TRB2", .F., .T.)
dbSelectArea('TRB2')
aLayout1 := RTExpp3()
//aLayout2 := RTExpp4()
While TRB2->(!EOF())
	cMovto := "03" //Altera็ใo de dependente com titular ja cadastrado
	
	dbSelectArea("SRA")
	SRA->(dbGoto(TRB2->NumSra))
	dbSelectArea("SRB")
	SRB->(dbGoto(TRB2->NumReg))
	
	cInicio := u_RetInic(1)
	cInicio := right(cInicio,4) + substr(cInicio, 3,2)
	if cInicio >= Alltrim(Str(Year(cDtExp))) + Alltrim(Str(Month(cDtExp)))
		//	if cInicio >= left(cDtExp,6)
		dbSelectArea("TRB2")
		dbSkip()
		Loop
	Endif
	
	cMesg := ""
	PrcRegSRB(cMovto)
	If Empty(cMesg)
		dbSelectArea("SRB")
		RecLock("SRB", .F.)
		SRB->RB_ALTAMED := "N"
		MsUnlock()
	Endif
	// avan็a leitura do arquivo principal
	dbSelectArea("TRB2")
	dbSkip()
EndDo
dbSelectArea("TRB2")
dbCloseArea()
dbSelectArea(cAlias)
dbSelectArea("SRA")
dbGoto(nRegSRA)

Return nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณExcTit    บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ExcTit()

Local dDtCorte := cDtExp
Local cDtCorte := Dtos(dDtCorte - 30)
Local cNewFil, cNewMat

cQuery := "SELECT R_E_C_N_O_ as NumReg FROM " + RetSqlName("SRA") + " WHERE "
cQuery += " RA_ASMEDIC IN " + FORMATIN(cPlanos, "/")
cQuery += " AND RA_ASMEDIC <> ' ' "
cQuery += " AND RA_SITFOLH = 'D' "
cQuery += " AND RA_FILIAL NOT IN " + FORMATIN(cFilExc, "/") + " "
cQuery += " AND SUBSTRING(RA_CTRNOTR,2,1) IN ('N', ' ') "
cTemp := " AND ( ("
If !empty(MV_PAR01) .or. !empty(MV_PAR02)
	if !empty(MV_PAR01)
		cQuery += cTemp + "RA_FILIAL >= '" + MV_PAR01 + "'"
		cTemp := " AND "
	Endif
	if !empty(MV_PAR02)
		cQuery += cTemp + " RA_FILIAL <= '" + MV_PAR02 + "'"
		cTemp := " OR "
	Endif
	If cTemp == " AND "
		cTemp := " OR "
	Endif
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
		cQuery += ") " + cTemp + " ( RA_CC IN " + FORMATIN( cLisCC, "/" ) + " ) "
		cTemp := " OR "
	Else
		cQuery += " ) "
	Endif
	IF cTemp == " OR "
		cQuery += " ) "
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
cQuery += " AND RA_DEMISSA >= '" + cDtCorte + "'"
cQuery += " AND D_E_L_E_T_ = ' ' "

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "TRB", .F., .T.)
dbSelectArea('TRB')
aLayout  := RTExpp2()
While TRB->(!EOF())
	cMovto := "06"
	
	dbSelectArea("SRA")
	SRA->(dbGoto(TRB->NumReg))
	dDataDem := u_RetDemD(1)
	cMotExc  := '2'
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Incrementa a regua                                                  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if dtos(dDataDem) < cDtCorte
		dbSelectArea("TRB")
		dbSkip()
		Loop
	Endif
	
	// Busca o endereco do funcionario e separa o numero do endereco.
	fEndereco(SRA->RA_ENDEREC)
	
	// Se for transferencia efetua a baixa somente no SRA
	If SRA->RA_RESCRAI $ '30/31'
		cNewFil  := "@@"		; cNewMat  := "@@"
		U_fNewReg( SRA->RA_FILIAL, SRA->RA_MAT, SRA->RA_DEMISSA, @cNewFil, @cNewMat )
		If cNewFil <> "@@" .And. cNewMat <> "@@"
			dbSelectArea("SRA")
			nSraRec := SRA->(Recno())
			If dbSeek( cNewFil + cNewMat )
				RecLock("SRA", .F.)
				SRA->RA_CTRNOTR := Left(SRA->RA_CTRNOTR,2) + "1"	// Transferencia de Funcionario
				MsUnlock()
			EndIf
			SRA->(dbGoTo( nSraRec ))
		EndIf
		RecLock("SRA", .F.)
		SRA->RA_CTRNOTR := Left(SRA->RA_CTRNOTR,1) + "1" + Right(SRA->RA_CTRNOTR,1)
		MsUnlock()
		dbSelectArea("TRB")
		dbSkip()
		Loop
	Endif
	
	cMesg := ""
	PrCRegSRA(cMovto)
	if empty(cMesg)
		dbSelectArea("SRA")
		RecLock("SRA", .F.)
		SRA->RA_CTRNOTR := Left(SRA->RA_CTRNOTR,1) + "1" + Right(SRA->RA_CTRNOTR,1)
		SRA->RA_MDDTEX  := dDataDem
		MsUnlock()
	Endif
	EXCDep(dDataDem)
	
	// avan็a leitura do arquivo principal
	dbSelectArea("TRB")
	dbSkip()
EndDo
dbSelectArea("TRB")
dbCloseArea()
dbSelectArea(cAlias)
Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEXCDep    บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function EXCDep(dDataDem,lTroca)

Local nRegSRA := SRA->(Recno())

DEFAULT lTroca := .F.

cQuery := "SELECT RB.R_E_C_N_O_ as NumReg, RA.R_E_C_N_O_ as NumSRA FROM " + RetSqlName("SRB") + " RB, " + RetSqlName("SRA") + " RA WHERE "
cQuery += " RA.RA_MAT = RB.RB_MAT AND RA.RA_FILIAL = RB.RB_FILIAL "
cQuery += " AND RA.RA_MAT = '"+SRA->RA_MAT+"' "
cQuery += " AND RA.RA_FILIAL = '"+SRA->RA_FILIAL+"' "
cQuery += " AND RB.RB_ASSIMED = 'S' "
cQuery += " AND SUBSTRING(RB.RB_CTRNOTR,2,1) IN (' ','N')"
cQuery += " AND RA.D_E_L_E_T_ = ' ' "
cQuery += " AND RB.D_E_L_E_T_ = ' ' "

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "TRB2", .F., .T.)
dbSelectArea('TRB2')
aLayout1 := RTExpp3()
//aLayout2 := RTExpp4()
While TRB2->(!EOF())
	cMovto := "06" //Desligamento de dependentes
	
	dbSelectArea("SRA")
	SRA->(dbGoto(TRB2->NumSra))
	dbSelectArea("SRB")
	SRB->(dbGoto(TRB2->NumReg))
	
	
	cMotExc := '2'
	cInicio := u_RetInic(1)
	cInicio := right(cInicio,4) + substr(cInicio, 3,2)
	if cInicio >= Alltrim(Str(Year(cDtExp))) + Alltrim(Str(Month(cDtExp)))
		//	if cInicio >= left(cDtExp,6)
		dbSelectArea("TRB2")
		dbSkip()
		Loop
	Endif
	
	cMesg := ""
	PrcRegSRB(cMovto)
	If Empty(cMesg)
		dbSelectArea("SRB")
		RecLock("SRB", .F.)
		SRB->RB_CTRNOTR := Left(SRB->RB_CTRNOTR,1) + "1" + Right(SRB->RB_CTRNOTR,1)
		If lTroca
			SRB->RB_MATNOTR := ""
		Else
			SRB->RB_MDDTEX  := dDataDem
		EndIf
		MsUnlock()
	Endif
	// avan็a leitura do arquivo principal
	dbSelectArea("TRB2")
	dbSkip()
EndDo
dbSelectArea("TRB2")
dbCloseArea()
dbSelectArea(cAlias)
dbSelectArea("SRA")
dbGoto(nRegSRA)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIncDep1   บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IncDep1()

cQuery := "SELECT RB.R_E_C_N_O_ as NumReg, RA.R_E_C_N_O_ as NumSRA FROM " + RetSqlName("SRB") + " RB, " + RetSqlName("SRA") + " RA WHERE "
cQuery += " RA.RA_MAT = RB.RB_MAT AND RA.RA_FILIAL = RB.RB_FILIAL "
cQuery += " AND SUBSTRING(RB.RB_CTRNOTR,1,1) IN ('N', ' ') "
cQuery += " AND RB_FILIAL NOT IN " + FORMATIN(cFilExc, "/") + " "
cQuery += " AND RB.RB_ASSIMED = 'S' "
cQuery += " AND RA_ASMEDIC IN " + FORMATIN(cPlanos, "/")
cQuery += " AND RA_ASMEDIC <> ' ' "
CQuery += " AND RA_SITFOLH IN (' ', 'A', 'F') "
cQuery += " AND RA.D_E_L_E_T_ = ' ' "
cQuery += " AND RB.D_E_L_E_T_ = ' ' "

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "TRB2", .F., .T.)
dbSelectArea('TRB2')
aLayout1 := RTExpp3()
//aLayout2 := RTExpp4()
While TRB2->(!EOF())
	cMovto := "02" //Inclusao de dependente com titular ja cadastrado
	
	dbSelectArea("SRA")
	SRA->(dbGoto(TRB2->NUMSRA))
	dbSelectArea("SRB")
	SRB->(dbGoto(TRB2->NumReg))
	
	cInicio := u_RetInic(1)
	cInicio := right(cInicio,4) + substr(cInicio, 3,2)
	if cInicio >= Alltrim(Str(Year(cDtExp))) + Alltrim(Str(Month(cDtExp)))
		//	if cInicio >= left(cDtExp,6)
		dbSelectArea("TRB2")
		dbSkip()
		Loop
	Endif
	
	cMesg := ""
	PrcRegSRB(cMovto)
	If Empty(cMesg)
		dbSelectArea("SRB")
		RecLock("SRB", .F.)
		SRB->RB_CTRNOTR := "1" + Right(SRB->RB_CTRNOTR,2)
		MsUnlock()
	Endif
	// avan็a leitura do arquivo principal
	dbSelectArea("TRB2")
	dbSkip()
EndDo
dbSelectArea("TRB2")
dbCloseArea()
dbSelectArea(cAlias)
Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAltDep1   บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ALTDep1()

cQuery := "SELECT RB.R_E_C_N_O_ as NumReg, RA.R_E_C_N_O_ as NumSRA FROM " + RetSqlName("SRB") + " RB, " + RetSqlName("SRA") + " RA WHERE "
cQuery += " RA.RA_MAT = RB.RB_MAT AND RA.RA_FILIAL = RB.RB_FILIAL "
cQuery += " AND RB.RB_ALTAMED = 'S'"
cQuery += " AND SUBSTRING(RB.RB_CTRNOTR,2,1) <> '1'"
cQuery += " AND RB_FILIAL NOT IN " + FORMATIN(cFilExc, "/") + " "
cQuery += " AND RB.RB_ASSIMED = 'S' "
cQuery += " AND RA_ASMEDIC IN " + FORMATIN(cPlanos, "/")
cQuery += " AND RA_ASMEDIC <> ' ' "
CQuery += " AND RA_SITFOLH IN (' ', 'A', 'F') "
cQuery += " AND RA.D_E_L_E_T_ = ' ' "
cQuery += " AND RB.D_E_L_E_T_ = ' ' "

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "TRB2", .F., .T.)
dbSelectArea('TRB2')
aLayout1 := RTExpp3()
//aLayout2 := RTExpp4()
While TRB2->(!EOF())
	cMovto := "03" //Altera็ใo de dependente com titular ja cadastrado
	
	dbSelectArea("SRA")
	SRA->(dbGoto(TRB2->NUMSRA))
	dbSelectArea("SRB")
	SRB->(dbGoto(TRB2->NumReg))
	
	// Verifica Exclusao do Plano
	If !Empty( SRB->RB_MDDTEX )
		cMovto := "06" //Exclusao de dependente com titular ativo
	EndIf
	
	cInicio := u_RetInic(1)
	cInicio := right(cInicio,4) + substr(cInicio, 3,2)
	if cInicio >= Alltrim(Str(Year(cDtExp))) + Alltrim(Str(Month(cDtExp)))
		//	if cInicio >= left(cDtExp,6)
		dbSelectArea("TRB2")
		dbSkip()
		Loop
	Endif
	
	cMesg := ""
	PrcRegSRB(cMovto)
	If Empty(cMesg)
		dbSelectArea("SRB")
		RecLock("SRB", .F.)
		If cMovto == "06"
			SRB->RB_CTRNOTR := Left(SRB->RB_CTRNOTR,1) + "1" + Right(SRB->RB_CTRNOTR,1)
			SRB->RB_ALTAMED := "N"
		Else
			SRB->RB_ALTAMED := "N"
		EndIf
		MsUnlock()
	Endif
	// avan็a leitura do arquivo principal
	dbSelectArea("TRB2")
	dbSkip()
EndDo
dbSelectArea("TRB2")
dbCloseArea()
dbSelectArea(cAlias)
Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออหออออออออหอออออออออออออออออออออออหออออออหออออออออออออปฑฑ
ฑฑบPrograma  ณ AltPlan()      บ Autor  บ Tania Bronzeri        บ Data บ 30/01/2008 บฑฑ
ฑฑฬออออออออออุออออออออออออออออสออออออออสอออออออออออออออออออออออสออออออสออออออออออออนฑฑ
ฑฑบDesc.     ณ Busca no SRA os funcionแrios ativos que tenham sido transferidos de บฑฑ
ฑฑบ          ณ plano, e que estejam com os flags inclusใo e exclusใo em branco.    บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU - Assist๊ncia M้dica                                            บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AltPlan()

Local cQuery

cQuery := "SELECT R_E_C_N_O_ as NumReg FROM " + RetSqlName("SRA") + " WHERE "
cQuery += " RA_ASMEDIC IN " + FORMATIN(cPlanos, "/")
cQuery += " AND RA_ASMEDIC <> '  '"
cQuery += " AND ( (RA_ASMANT IN " + FORMATIN(cPlanos, "/")
cQuery += "        AND RA_ASMANT <> '  '"
cQuery += "        AND RA_ASMEDIC <> RA_ASMANT) OR SUBSTRING(RA_CTRNOTR,3,1) = '1' )"
cQuery += " AND RA_SITFOLH IN (' ', 'A', 'F') "
cQuery += " AND RA_FILIAL NOT IN " + FORMATIN(cFilExc, "/") + " "
cQuery += " AND SUBSTRING(RA_CTRNOTR,2,1) IN ('N', ' ') "
cTemp := " AND ( ("
If !empty(MV_PAR01) .or. !empty(MV_PAR02)
	if !empty(MV_PAR01)
		cQuery += cTemp + "RA_FILIAL >= '" + MV_PAR01 + "'"
		cTemp := " AND "
	Endif
	if !empty(MV_PAR02)
		cQuery += cTemp + " RA_FILIAL <= '" + MV_PAR02 + "'"
		cTemp := " OR "
	Endif
	If cTemp == " AND "
		cTemp := " OR "
	Endif
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
		cQuery += ") " + cTemp + " ( RA_CC IN " + FORMATIN( cLisCC, "/" ) + " ) "
		cTemp := " OR "
	Else
		cQuery += " ) "
	Endif
	IF cTemp == " OR "
		cQuery += " ) "
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
cQuery += " AND D_E_L_E_T_ = ' ' "

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "TRB", .F., .T.)
dbSelectArea('TRB')
dbGoTop()
aLayout  := RTExpp2()
While TRB->(!EOF())
	cMovto := "09"
	
	dbSelectArea("SRA")
	SRA->(dbGoto(TRB->NumReg))
	
	// Verifica se eh Transferencia
	cMovto := If(SubStr(RA_CTRNOTR,3,1) = '1',"11",cMovto)
	
	cMesg := ""
	PrCRegSRA(cMovto)
	if empty(cMesg)
		dbSelectArea("SRA")
		RecLock("SRA", .F.)
		SRA->RA_ASMANT  := SRA->RA_ASMEDIC
		SRA->RA_CTRNOTR := "1" + SubStr(SRA->RA_CTRNOTR,2,1) + " "
		MsUnlock()
	Endif
	// avan็a leitura do arquivo principal
	dbSelectArea("TRB")
	dbSkip()
EndDo
dbSelectArea("TRB")
dbCloseArea()
dbSelectArea(cAlias)
Return nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetLocFun บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RetLocFun()

Local cFilOri := "03,14,11,02,15,06,10,01,13,07"
Local cIdtEmp := "0001,0002,0003,0004,0005,0006,0007,0008,0009,0010"
cRet := At(SRA->RA_FILIAL,cFilOri)
cRet := Subs(cIdtEmp,At(SRA->RA_FILIAL,cFilOri),4)+cDepois
Return(cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRTEXPPN   บAutor  ณMicrosiga           บ Data ณ  07/18/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
User Function fNewReg( xFil, xMat, xDemissa, cNewFil, cNewMat )

Local aOldAtu := GETAREA()
Local aTransf := {}
Local cMesDem := MesAno( xDemissa )
Local nX

fTransf( @aTransf, cMesDem,,,,,,.T. )

If Len( aTransf ) > 0
	For nX := 1 To Len( aTransf )
		If aTransf[nX,12] # cMesDem
			Loop
		EndIf
		
		If aTransf[nX,01] == aTransf[nX,04]	// Transferencia na Mesma Empresa
			If aTransf[nX,08] # aTransf[nX,10]	// Transferencia entre Filiais
				cNewFil := aTransf[nX,10]
				cNewMat := aTransf[nX,11]
			EndIf
		EndIf
	Next nX
EndIf

RESTAREA( aOldAtu )

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออหออออออออหอออออออออออออออออออออออหออออออหออออออออออออปฑฑ
ฑฑบPrograma  ณ TransfPlan()   บ Autor  บ Tania Bronzeri        บ Data บ 30/01/2008 บฑฑ
ฑฑฬออออออออออุออออออออออออออออสออออออออสอออออออออออออออออออออออสออออออสออออออออออออนฑฑ
ฑฑบDesc.     ณ Busca no SRA os funcionแrios ativos que tenham sido transferidos de บฑฑ
ฑฑบ          ณ plano, e que estejam com os flags inclusใo e exclusใo em branco.    บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU - Assist๊ncia M้dica                                            บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TransfPlan()

Local cQuery

cQuery := "SELECT R_E_C_N_O_ as NumReg FROM " + RetSqlName("SRA") + " WHERE "
cQuery += " RA_ASMEDIC IN " + FORMATIN(cPlanTransf, "/")
cQuery += " AND RA_ASMEDIC <> '  '"
cQuery += " AND RA_ASMANT IN " + FORMATIN(cPlanos, "/")
cQuery += " AND RA_ASMANT <> '  '"
cQuery += " AND RA_SITFOLH IN (' ', 'A', 'F') "
cQuery += " AND RA_FILIAL NOT IN " + FORMATIN(cFilExc, "/") + " "
cQuery += " AND SUBSTRING(RA_CTRNOTR,2,1) IN ('N', ' ') "
cTemp := " AND ( ("
If !empty(MV_PAR01) .or. !empty(MV_PAR02)
	if !empty(MV_PAR01)
		cQuery += cTemp + "RA_FILIAL >= '" + MV_PAR01 + "'"
		cTemp := " AND "
	Endif
	if !empty(MV_PAR02)
		cQuery += cTemp + " RA_FILIAL <= '" + MV_PAR02 + "'"
		cTemp := " OR "
	Endif
	If cTemp == " AND "
		cTemp := " OR "
	Endif
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
		cQuery += ") " + cTemp + " ( RA_CC IN " + FORMATIN( cLisCC, "/" ) + " ) "
		cTemp := " OR "
	Else
		cQuery += " ) "
	Endif
	IF cTemp == " OR "
		cQuery += " ) "
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
cQuery += " AND D_E_L_E_T_ = ' ' "

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "TRB", .F., .T.)
dbSelectArea('TRB')
dbGoTop()
cCpoPlan := "RA_ASMANT"
aLayout  := RTExpp2()
While TRB->(!EOF())
	cMovto := "03"
	
	dbSelectArea("SRA")
	SRA->(dbGoto(TRB->NumReg))
	
	cMesg := ""
	PrCRegSRA(cMovto)
	if empty(cMesg)
		dbSelectArea("SRA")
		RecLock("SRA", .F.)
		SRA->RA_CTRNOTR := ""
		SRA->RA_MATNOTR := ""
		MsUnlock()
	Endif
	EXCDep(dDataBase,.T.)
	RecLock("SRA", .F.)
	SRA->RA_ASMANT  := SRA->RA_ASMEDIC
	MsUnlock()
	
	// avan็a leitura do arquivo principal
	dbSelectArea("TRB")
	dbSkip()
EndDo
cCpoPlan := "RA_ASMEDIC"
dbSelectArea("TRB")
dbCloseArea()
dbSelectArea(cAlias)
Return nil

// Regra do Campo RA_CTRNOTR
// 1 = Inclusao
// 2 = Exclusao
// 3 = Transferencia


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfEndereco บAutor  ณAdalberto Althoff   บ Data ณ  04/08/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณDivide uma String de endereco e numero em duas, uma com o   บฑฑ
ฑฑบ          ณendereco e a outr com o numero.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */

static function fEndereco(cEnd)

cEndereco := cEnd

nUM     := AT("1",cEndereco)
nDOIS   := AT("2",cEndereco)
nTRES   := AT("3",cEndereco)
nQUATRO := AT("4",cEndereco)
nCINCO  := AT("5",cEndereco)
nSEIS   := AT("6",cEndereco)
nSETE   := AT("7",cEndereco)
nOITO   := AT("8",cEndereco)
nNOVE   := AT("9",cEndereco)
nZERO   := AT("0",cEndereco)

IF nUm == 0
	nUm := 100
ENDIF
IF nDois == 0
	nDois := 100
ENDIF
IF nTres == 0
	nTres := 100
ENDIF
IF nQuatro == 0
	nQuatro := 100
ENDIF
IF nCinco == 0
	nCinco := 100
ENDIF
IF nSeis == 0
	nSeis := 100
ENDIF
IF nSete == 0
	nSete := 100
ENDIF
IF nOito == 0
	nOito := 100
ENDIF
IF nNove == 0
	nNove := 100
ENDIF
IF nZero == 0
	nZero := 100
ENDIF

nQuebra := min(nUm,nDois)
nQuebra := min(nQuebra,nTres)
nQuebra := min(nQuebra,nQuatro)
nQuebra := min(nQuebra,nCinco)
nQuebra := min(nQuebra,nSeis)
nQuebra := min(nQuebra,nSete)
nQuebra := min(nQuebra,nOito)
nQuebra := min(nQuebra,nNove)
nQuebra := min(nQuebra,nZero)

cNumero := subs(cEndereco,nQuebra)
cEndereco := LEFT(cEndereco,nQuebra-1)

nQuebra := at(" ",cNumero)
cNumero := LEFT(cNumero,nQuebra-1)
cNumero := StrTran(cNumero,",","")
cNumero := StrTran(cNumero,"/","")
cNumero := StrTran(cNumero,":","")
cNumero := StrTran(cNumero,"-","")
cNumero := StrTran(cNumero,CHR(172),"")

if empty(cNumero)
	cNumero := "00"
endif

nQuebra := at(",",cEndereco)

IF NQUEBRA>0
	cEndereco := LEFT(cEndereco,nQuebra-1)
ENDIF

cEndereco := StrTran(cEndereco,".","")
cEndereco := StrTran(cEndereco,"-","")
cEndereco := StrTran(cEndereco,"  ","")
cEndereco := StrTran(cEndereco,"   ","")
cEndereco := StrTran(cEndereco,"/","")
cEndereco := StrTran(cEndereco,CHR(172),"")

return

