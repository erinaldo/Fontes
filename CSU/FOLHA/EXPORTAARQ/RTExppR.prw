#INCLUDE "PROTHEUS.CH"
#INCLUDE 'TBICONN.CH'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RTExppr  บ Autor ณ WM                         บ Data ณ  09/03/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina de exporta็ใo de arquivos Intermedica.                      บฑฑ
ฑฑบ          ณ                                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gestao de Pessoal                               '                   บฑฑ
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
ฑฑบ   TI2388     บ        ณ  pela Intermedica.                                    บฑฑ
ฑฑวฤฤฤฤฤฤฤฤฤฤฤฤฤฤืฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถฑฑ
ฑฑบIsamu K.      บ18/08/09ณ  Codigo Unico Intermedica - OS 2244/09                บฑฑ
ฑฑบMarcos Pereiraบ07/03/12ณ  Adaptacao para utilizacao das novas tabelas de assistบฑฑ
ฑฑบ              บ        ณ  medica do padrใo (RHK, RHL, RHM)                     บฑฑ
ฑฑบIsamu K.      บ21/03/12ณ  Alteracao na linha 1241 a fim de tratar Afastados e  บฑฑ
ฑฑบIsamu K.      บ        ณ  Ferias em caso de nova gera็ใo; alteracao na linha   บฑฑ
ฑฑบIsamu K.      บ        ณ  371, a fim de incluir numeral '8941' antes do codigo บฑฑ
ฑฑศออออออออออออออสออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RTExppr(aParams)
Local	aSay		:= {}
Local	aButton	:= {}
Local	nOpc		:= 0
Local	cTitulo	:= ""
Local	cDesc1	:= "Esta rotina ira fazer a exportacao do cadastro"
Local	cDesc2	:= "de Funcionarios para a Intermedica."
Local	cDesc3	:= ""
Local   cArqInter
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private lManual   := IIf( aParams == NIL, .T.  , aParams[1][1] )
Private cEmpresa  := IIf( lManual, SM0->M0_CODIGO, aParams[1][2] )
Private cFil      := IIf( lManual, SM0->M0_CODFIL, aParams[1][3] )
Private cPerg     := PADR("RTEXPX",LEN(SX1->X1_GRUPO))
Private oGeraTxt
Private cAlias    := "SRA"   //alias do arquivo a exportar
Private cDir      := ''
Private lUsaFTP   := .F.                                                                      
Private cDirFTP   := ''
Private cDtExp    := ""
Private cCpoPlan  := "RA_ASMEDIC"
Private cNivelFun := ""
Private cFuncao   := ""

nHdlInter := 0
nHdlXInte := 0

If !lManual
	// Prepara ambiente se for JOB
	RpcSetType(3)
	RpcSetEnv(cEmpresa, cFil,,,'FIN')
EndIf
// ROTINA PARA VERIFCAR SE USA FTP
//cDir := AllTrim(GetMv("EX_LISPAT",,"C:\temp"))  // Caminho local
cDir := AllTrim(GetMv("EX_LISPAT",,"C:\temp\CSU"))  // Caminho local
cDir += If(Right(Alltrim(cDir),1) # "\","\","")
cArqInter := cDir + "INTERMEDICA_" + Dtos(dDataBase)

nHdlInter := fOpen(cArqInter + ".TXT",2)
nHdlXInte := fOpen(cArqInter + ".XLS",2)
If nHdlInter == -1 .OR. nHdlXInte == -1
	ApMsgAlert("O arquivo  "+cArqInter+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return
Endif
// Posiciona o Final dos Arquivos
fSeek(nHdlInter,0,2)
fSeek(nHdlXInte,0,2)

lUsaFTP:= GetMV('EX_USAFTP',,.f.)   // Parametro para utilizar ou nใo FTP
If lUsaFTP == .T.
	cDirFTP := GetMV( 'EX_LISFTP',,'/') //caminho do FTP
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
//Private cBaseArq  := alltrim(MV_PAR96)
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
Private cFilExc   := GetMv("MV_FILEXC",,"04/08/93/91")
//cDtExp := right(Alltrim(MV_PAR05),4) + Left(Alltrim(MV_PAR05),2) + "01"
/*
MakeDir( cDir )
nHdl	:=	fCreate(cArqTxt, 0)
nhdl1	:=	fCreate(cdir+cBaseArq+".XLS",0)
If nHdl == -1
	ApMsgAlert("O arquivo texto  "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return NIL
Endif
If nHdl1 == -1
	ApMsgAlert("O arquivo excel "+cBaseArq+".XLS nao pode ser executado! Verifique os parametros.","Atencao!")
	Return NIL
Endif
*/
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
cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>Data Admissao</TD>"
cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>Data Demissao</TD>"
cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>CPF</TD>"
cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>Sit. Folha</TD>"
cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>Cod.Movimentacao</TD>"
cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>Funcao</TD>"
cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>Nivel Funcao</TD>"
cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>Carga Horaria</TD>"
cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>Motivo Erro</TD></TR>" + CRLF  
cFileCont += cLinFile
If fWrite(nHdlXInte,cFileCont,Len(cFileCont)) <> Len(cFileCont)
	apMsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
Endif			
cFileCont := ""
cLinFile  := ""
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicializa a regua de processamento                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//If lManual
//	Processa({|| RunCont() },"Processando...")
//Else
	RunCont()
//EndIf
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
Local aArea         := GetArea()
Private nTamLin, cLin, cCpo
Private cprim       := .T.
Private cdata       := ""
Private cdata1      := ""
Private cdata2      := ""
Private cCep        := ""
Private ccgc        := ""
Private horagrava   := ""
Private aLayout     := {}
Private cMesg
Private cMovto
Private cQuery      := ""
Private cInicio	    := ""
Private atransf     := {}
Private aExcTit     := {}
private ntenta		:= 2
Private cPlanos	    := Alltrim(GetMv("MV_PLAINT",,"27/35/36"))				// Planos Intermedica
Private cPlanTransf := Alltrim(GetMv("MV_PLANOTR",,"28/29/30/31/32"))	// Planos Notre Dame
cPlanos := strtran(cPlanos,'*','/')
Pergunte(cPerg, .F.)
cIniVig := dTos(Mv_par06)
cFimVig := dTos(Mv_Par07)
cIniVigA:= Subs(dTos(Mv_Par06-1),1,6)+"01"
cFimVigA:= Subs(dTos(Mv_Par06-1),1,6)+StrZero(f_UltDia(Mv_Par06-1),2) 
//cDtExp := right(Alltrim(MV_PAR05),4) + Left(Alltrim(MV_PAR05),2) + "01"  OS 4422/09
dbSelectArea(cAlias)
If lManual
	//ProcRegua(RecCount())   // Numero de registros a processar
Endif
// Novo Processo
// Transferencia Entre Planos (Intermedica x Notre Dame)
//TransfPlan()
// Exclusao titulares
ExcTit()
// Altera็ใo de plano
//AltPlan()
// Inclusao titulares
IncTit()
// Altera็ใo titulares
//AltTit()
// Inclusao de dependentes com titular ja cadastrado
IncDep1()
// altera็ใo de dependentes exclusiva
//AltDep1()

/*
If mv_par06 = 3
	U_verTR01()
Endif
*/

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ณ
//ณ cao anterior.                                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cFileCount := "</Table>"+CRLF
//Acrescenta o rodap้ html
cFileCont += cRodHtml+CRLF
If fWrite(nHdlXInte,cFileCont,Len(cFileCont)) <> Len(cFileCont)
	apMsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
Endif			
fClose(nHdlInter)
fClose(nHdlXInte)
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
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RTExpp2()
Local aRet := {}
//           1                                                       2     3     4     5   				 6    															 7   8    9    10
//           Descricao do campo                                      Obrig Inic  fim   Pad  				 EXEC 														 Val Pic, alin tip
aadd(aRet, {"IDENTIFICAวรO DO REGISTRO FUNCIONมRIO"						,"O","001","001","'1'"				,""															,"",""	,"D","N" } )
aadd(aRet, {"NฺMERO SEQUENCIAL DO FUNCIONมRIO"							,"O","002","008","'0000000'"		,""															,"",""	,"D","N" } )
aadd(aRet, {"NOME DO FUNCIONมRIO"										,"O","009","048",""					,"PadR(SRA->RA_NOME,40)"									,"",""	,"E","T" } )
aadd(aRet, {"CARGO DO FUNCIONมRIO"										,"N","049","073",""					,"PadR(U_RETCAR(SRA->RA_CODFUNC),25)"						,"",""	,"E","T" } )
aadd(aRet, {"ENDEREวO RESIDENCIAL"										,"O","074","103",""					,"PadR(U_RetEnd(SRA->RA_ENDEREC),30)"						,"",""	,"E","T" } )
aadd(aRet, {"NฺMERO DO ENDEREวO"										,"N","104","113",""					,"Space(10)"												,"",""	,"E","T" } )
aadd(aRet, {"NฺMERO CASA OU APARTAMENTO"								,"N","114","119",""					,"PadR(SRA->RA_COMPLEM,6)"									,"",""	,"E","T" } )
aadd(aRet, {"BAIRRO DO ENDEREวO"										,"N","120","139",""					,"PadR(SRA->RA_BAIRRO,20)"									,"",""	,"E","T" } )
aadd(aRet, {"CIDADE DO ENDEREวO"										,"O","140","159",""					,"PadR(SRA->RA_MUNICIP,20)"									,"",""	,"E","T" } )
aadd(aRet, {"ESTADO DO ENDEREวO"										,"N","160","161",""					,"PadR(SRA->RA_ESTADO,2)"									,"",""	,"E","T" } )
aadd(aRet, {"TELEFONE RESIDENCIAL"										,"N","162","170",""					,"PadR(SRA->RA_TELEFON,9)"									,"",""	,"E","T" } )
aadd(aRet, {"CEP DA RESIDสNCIA"											,"N","171","178",""					,"PadR(SRA->RA_CEP,8)"										,"",""	,"D","N" } )
aadd(aRet, {"ZONA RESIDENCIAL"											,"N","179","180","'00'"				,""															,"",""	,"D","N" } ) //WM
aadd(aRet, {"DATA DE NASCIMENTO DDMMYYYY"								,"O","181","188",""					,"PadR(U_Retdata(SRA->RA_NASC),8)"							,"",""	,"D","N" } )
aadd(aRet, {"SEXO"														,"O","189","189",""					,"PadR(U_RETSEX(SRA->RA_SEXO),1)"							,"",""	,"D","N" } )
aadd(aRet, {"ESTADO CIVIL"												,"O","190","190",""					,"PadR(U_RETESC(SRA->RA_ESTCIVI),1)"						,"",""	,"D","N" } )
aadd(aRet, {"Nบ. DA CARTEIRA PROFISSIONAL"								,"N","191","204",""					,"PadR(SRA->RA_NUMCP,14)"									,"",""	,"E","T" } )
aadd(aRet, {"Nบ DO  REG. GERAL (RG)"									,"O","205","218",""					,"PadR(SRA->RA_RG,14)"										,"",""	,"E","T" } )
aadd(aRet, {"Nบ PROG. INT. SOCIAL.(PIS)"								,"N","219","232",""					,"PadR(SRA->RA_PIS,14)"										,"",""	,"E","T" } )
aadd(aRet, {"CำDIGO DO PLANO"											,"O","233","236",""					,"PadR(U_RETCPL('1'),4)"									,"",""	,"D","N" } )
aadd(aRet, {"TIPO DO PLANO"												,"O","237","237","'0'"				,""															,"",""	,"D","N" } )
aadd(aRet, {"CLASSIFICAวรO DO PLANO"									,"O","238","239","'00'"				,""															,"",""	,"D","N" } )
aadd(aRet, {"CำDIGO DE CARสNCIA DO PLANO"								,"N","240","242","'000'"			,""															,"",""	,"D","N" } )
aadd(aRet, {"DATA DE ADMISSรO DO FUNCIONมRIO"							,"O","243","250",""					,"PadR(U_RetData(SRA->RA_ADMISSA),8)"						,"",""	,"D","N" } )
aadd(aRet, {"DATA DE INอCIO NO CONVสNIO"								,"O","251","258",""					,"PadR(U_RetInic(1),8)"										,"",""	,"D","N" } )
aadd(aRet, {"NฺMERO DE MATRอCULA DO FUNCIONมRIO NA EMPRESA"				,"N","259","273",""					,"PadR(SRA->RA_MAT,15)"										,"",""	,"E","T" } )
aadd(aRet, {"LOCALIZAวรO DO FUNCIONมRIO"								,"N","274","283",""					,"PadR(U_RetCCD(),10)"										,"",""	,"E","T" } )
aadd(aRet, {"CำDIGO DE IDENTIFICAวรO DA EMPRESA JUNTO A INTERMษDICA"	,"O","284","291",""					,"PadR(U_RetPla('1'),8)"									,"",""	,"D","N" } )
aadd(aRet, {"CำDIGO DE MOVIMENTAวรO"									,"O","292","293",""					,"PadR(M->cTipMov,2)"										,"",""	,"D","N" } )
aadd(aRet, {"DATA  DEMISSรO/DESLIGAMENTO"								,"N","294","301",""					,"PadR(u_RetDem(1),8)"										,"",""	,"D","N" } )
aadd(aRet, {"Nบ CำDIGO DO FUNCIONมRIO NA  INTERMษDICA"					,"N","302","308","'0000000'"		,""															,"",""	,"D","N" } )
aadd(aRet, {"Nบ CำDIGO DA EMPRESA NA INTERMษDICA"						,"N","309","316",""					,"PadR(U_RetPla('1'),8)"									,"",""	,"D","N" } )
aadd(aRet, {"Nบ DO CPF"													,"O","317","327",""					,"PadR(SRA->RA_CIC,11)"										,"",""	,"D","N" } )
aadd(aRet, {"CำD. DDD DO TELEFONE RESIDENCIAL"							,"N","328","331","'0000'"			,""															,"",""	,"E","T" } )
//aadd(aRet, {"CำDIGO IDENTIFICAวรO BENEFICIมRIO DO CLIENTE"				,"O","332","361",""					,"RA_MATINTE"  	,"",""	,"E","T" } )  //"U_RETID(SRA->RA_FILIAL, SRA->RA_MAT,1,'RA_MATINTE')"					,"",""	,"E","T" } ) //WM
//aadd(aRet, {"NOME DA MรE DO BENEFICIมRIO"								,"N","362","401",""					,"SRA->RA_MAE"												,"",""	,"E","T" } )
//aadd(aRet, {"CำDIGO IDENTIFICAวรO BENEFICIมRIO DO CLIENTE"			,"O","332","351",""					,"PadR(U_RETID(SRA->RA_FILIAL, SRA->RA_MAT,1,'RA_MATINTE'),20)"	,"",""	,"E","T" } ) //WM
//aadd(aRet, {"CENTRO DE CUSTO"											,"O","352","361",""					,"PadR(SRA->RA_CC,10)" 										,"",""	,"E","T" } )
aadd(aRet, {"CำDIGO IDENTIFICAวรO BENEFICIมRIO DO CLIENTE"				,"O","332","361",""					,"PadR('8941'+RHK->RHK_MATIN_,30)"  	,"",""	,"E","T" } )  //"U_RETID(SRA->RA_FILIAL, SRA->RA_MAT,1,'RA_MATINTE')"					,"",""	,"E","T" } ) //WM
aadd(aRet, {"NOME DA MรE DO BENEFICIมRIO"								,"N","362","401",""					,"PadR(SRA->RA_MAE,40)"										,"",""	,"E","T" } )
aadd(aRet, {"NUMERO DO CARTรO NACIONAL DE SAฺDE"						,"N","402","412","'00000000000'"	,""															,"",""	,"D","N" } )
aadd(aRet, {"MOTIVO PARA A 2ช VIA DE CARTEIRINHA"						,"N","413","414",""					,"Space(2)"													,"",""	,"D","N" } )
aadd(aRet, {"DATA DE VALIDADE"											,"N","415","422",""					,"Space(8)"													,"",""	,"D","N" } )
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
//           1                                                       2     3    4     5  				 	 6    															 7   8    9    10
//           Descricao do campo                                      Obrig Inic fim   Pad 			 	 EXEC 															 Val Pic, alin tip
aadd(aRet, {"IDENTIFICAวรO DO REGISTRO DO DEPENDENTE"					,"O","001","001","'2'"				,""																,"",""	,"D","N" } )
aadd(aRet, {"NฺMERO SEQUENCIAL DO DEPENDENTE POR TITULAR"				,"O","002","003",""					,"PadR(SRB->RB_COD,2)"										,"",""	,"D","N" } )
aadd(aRet, {"NOME DO DEPENDENTE"										,"O","004","043",""					,"PadR(SRB->RB_NOME,40)"									,"",""	,"E","T" } )
aadd(aRet, {"PARENTESCO DO DEPENDENTE EM RELAวรO AO TITULAR"			,"O","044","045",""					,"PadR(U_RETPAR(2),2)"										,"",""	,"D","N" } )
aadd(aRet, {"DATA DE NASCIMENTO DDMMYYYY"								,"O","046","053",""					,"PadR(U_Retdata(SRB->RB_DTNASC),8)"					,"",""	,"D","N" } )
aadd(aRet, {"SEXO"														,"O","054","054",""					,"PadR(U_RETSEX(SRB->RB_SEXO),1)"						,"",""	,"D","N" } )
aadd(aRet, {"ESTADO CIVIL"												,"O","055","055","'1'"				,""																,"",""	,"D","N" } )
aadd(aRet, {"DATA DE INอCIO NO CONVสNIO"								,"O","056","063",""					,"PadR(U_RetInic(2),8)"										,"",""	,"D","N" } )
aadd(aRet, {"CำDIGO DE IDENTIFICAวรO DA EMPRESA JUNTO A INTERMษDICA"	,"O","064","071",""					,"PadR(U_RetPla('2'),8)"									,"",""	,"D","N" } )
aadd(aRet, {"NฺMERO SEQUENCIAL DO FUNCIONมRIO"							,"N","072","078","'0000000'"		,""																,"",""	,"D","N" } )
aadd(aRet, {"CำDIGO DE MOVIMENTAวรO"									,"O","079","080",""					,"PadR(M->cTipMov,2)"										,"",""	,"D","N" } )
aadd(aRet, {"DATA  DEMISSรO/DESLIGAMENTO"								,"N","081","088",""					,"PadR(u_RetDem(2),8)"										,"",""	,"D","N" } )
aadd(aRet, {"NฺMERO DE MATRอCULA DO FUNCIONมRIO NA EMPRESA"				,"N","089","098",""					,"PadR(SRB->RB_MAT,10)"										,"",""	,"D","N" } )
aadd(aRet, {"DATA DE CASAMENTO (ESPOSA OU MARIDO)"						,"N","099","106",""					,"PadR(U_RETDCAS(),8)"										,"",""	,"D","N" } )
aadd(aRet, {"CำDIGO DO PLANO"											,"O","107","110",""					,"PadR(U_RETCPL('2'),4)"									,"",""	,"D","N" } )
aadd(aRet, {"TIPO DO PLANO"												,"O","111","111","'0'"				,""																,"",""	,"D","N" } )
aadd(aRet, {"CLASSIFICAวรO DO PLANO"									,"O","112","113","'00'"				,""																,"",""	,"D","N" } )
aadd(aRet, {"DATA DE INอCIO NO PLANO"									,"O","114","121",""					,"PadR(U_RetInic(2),8)"										,"",""	,"D","N" } )
aadd(aRet, {"CำDIGO DE CARสNCIA DO PLANO"								,"O","122","124","'000'"			,""																,"",""	,"D","N" } )
//aadd(aRet, {"CำDIGO IDENTIFICAวรO BENEFICIมRIO DO CLIENTE (DEPEND)"		,"O","125","154",""					,"PadR(U_RETID(SRA->RA_FILIAL, SRA->RA_MAT,2,'RB_MATINTE'),30)"	,"",""	,"E","T" } ) //WM
aadd(aRet, {"CำDIGO IDENTIFICAวรO BENEFICIมRIO DO CLIENTE (DEPEND)"		,"O","125","154",""					,"PadR(RHL->RHL_MATIN_,30)"	,"",""	,"E","T" } ) //WM
aadd(aRet, {"CำDIGO IDENTIFICAวรO BENEFICIมRIO DO CLIENTE (TITULAR)"	,"N","155","184",""					,"PadR(RHK->RHK_MATIN_,30)"									,"",""	,"E","T" } ) //WM
aadd(aRet, {"NOME DA MรE DO BENEFICIมRIO"								,"N","185","224",""					,"PadR(SRB->RB_MAE,40)"										,"",""	,"E","T" } )
aadd(aRet, {"MOTIVO PARA A 2ช VIA DE CARTEIRINHA"						,"N","225","226",	"  "			,""																,"",""	,"D","N" } )
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
*/
Static Function RTExpp4()
Local aRet := {}
//           1                                                        2     3      4   5  			 6   																	 7   8     9    10
//           Descricao do campo                                       Obr Inic   fim   Pad 			 EXEC																	 Val Pic, alin tip
aadd(aRet, {"IDENTIFICAวรO DO REGISTRO DO AGREGADO"						,"O","001","001","'3'"			,""																	,"",""	,"D","N" } )
aadd(aRet, {"NฺMERO SEQUENCIAL DO AGREGADO POR TITULAR"					,"O","002","003",""				,"PadR(SRB->RB_COD,2)"											,"",""	,"D","N" } )
aadd(aRet, {"NOME DO AGREGADO"											,"O","004","043",""				,"PadR(SRB->RB_NOME,40)"										,"",""	,"E","T" } )
aadd(aRet, {"PARENTESCO DO AGREGADO EM RELAวรO AO TITULAR"				,"O","044","045",""				,"PadR(U_RETPAR(3),2)"											,"",""	,"D","N" } )
aadd(aRet, {"DATA DE NASCIMENTO DDMMYYYY"								,"O","046","053",""				,"PadR(U_Retdata(SRB->RB_DTNASC),8)"						,"",""	,"D","N" } )
//aadd(aRet, {"SEXO"														,"O","054","054",""				,"PadR(U_RETSEX(SRB->RB_SEXO),1)"							,"",""	,"D","N" } )
aadd(aRet, {"SEXO"														,"O","054","054",""				,""												,"",""	,"D","N" } )
aadd(aRet, {"ESTADO CIVIL"												,"O","055","055","'1'"			,""																	,"",""	,"D","N" } )
aadd(aRet, {"CำDIGO DO PLANO"											,"O","056","059",""				,"PadR(U_RETCPL('3'),4)"										,"",""	,"D","N" } )
aadd(aRet, {"TIPO DO PLANO"												,"O","060","060","'0'"			,""																	,"",""	,"D","N" } )
aadd(aRet, {"CLASSIFICAวรO DO PLANO"									,"O","061","062","'00'"			,""																	,"",""	,"D","N" } )
aadd(aRet, {"DATA DE INอCIO NO PLANO"									,"O","063","070",""				,"PadR(U_RetInic(3),8)"											,"",""	,"D","N" } )
aadd(aRet, {"CำDIGO DE CARสNCIA DO PLANO"								,"O","071","073","'000'"		,""																	,"",""	,"D","N" } )
aadd(aRet, {"CำDIGO DE IDENTIFICAวรO DA EMPRESA JUNTO A INTERMษDICA"	,"O","074","081",""				,"PadR(U_RetPla('3'),8)"										,"",""	,"D","N" } )
aadd(aRet, {"NฺMERO SEQUENCIAL DO FUNCIONมRIO"							,"O","082","088","'0000000'"	,""																	,"",""	,"D","N" } )
aadd(aRet, {"CำDIGO DE MOVIMENTAวรO"									,"O","089","090",""				,"PadR(M->cTipMov,2)"											,"",""	,"D","N" } )
aadd(aRet, {"DATA  DEMISSรO/DESLIGAMENTO"								,"N","091","098",""				,"PadR(u_RetDem(3),8)"											,"",""	,"D","N" } )
aadd(aRet, {"Nบ DO CPF"													,"O","099","109",""				,"PadR(SRA->RA_CIC,11)"											,"",""	,"D","N" } )
//aadd(aRet, {"CำDIGO IDENTIFICAวรO BENEFICIมRIO DO CLIENTE (DEPEND)"		,"O","110","139",""				,"PadR(U_RETID(SRA->RA_FILIAL, SRA->RA_MAT,2,'RB_MATINTE'),30)"		,"",""	,"E","T" } ) //WM
aadd(aRet, {"CำDIGO IDENTIFICAวรO BENEFICIมRIO DO CLIENTE (DEPEND)"		,"O","110","139",""				,"PadR('0',30)"		,"",""	,"E","T" } ) // A CSU nao aceita agregados na Intermedica 
aadd(aRet, {"CำDIGO IDENTIFICAวรO BENEFICIมRIO DO CLIENTE (TITULAR)"	,"N","140","169",""				,"PadR(RHK->RHK_MATIN_,30)"										,"",""	,"E","T" } ) //WM
aadd(aRet, {"NOME DA MรE DO BENEFICIมRIO"								,"N","170","209",""				,""																,"",""	,"E","T" } )
aadd(aRet, {"MOTIVO PARA A 2ช VIA DE CARTEIRINHA"						,"N","210","211","  "			,""																	,"",""	,"D","N" } )
Return(aRet)
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
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetEnd    บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User function RetEnd(cEnd)
Local cRet := cEnd
Return(cRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetData   บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User function RetData(dData)
Local cRet := ""
cRet := StrZero(day(dData),2) + strZero(Month(dData),2) + StrZero(Year(dData),4)
Return(cRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetSex    บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RETSEX(cSexo)
Local cRet := ""
If Upper(alltrim(cSexo)) == "M"
	cRet := "1"
Else
	cRet := "2"
Endif
Return(cRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetEsc    บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RETESC(cEstCiv)
Local cRet := cEstCiv
Local aArea := GetArea()
dbSelectArea("PC2")
dbGotop()
While !eof()
	if Alltrim(upper(cEstCiv)) $ PC2->PC2_DEPARA
		cRet := PC2->PC2_CODIGO
		Exit
	Endif
	dbSkip()
End
RestArea(aArea)
Return(cRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetCpl    บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user Function RETCPL(cTipo)
Local cRet    := ""
Local aArea   := GetArea()
Local cFilPes := SRA->RA_FILIAL
Local cEmpresa := U_RetEmpr(SRA->RA_FILIAL, SRA->RA_MAT)
dbselectarea( "PC6" )
dbSetOrder(1)
If dbSeek( xFilial("PC6") + SRA->RA_CC )
	cFilPes := PC6->PC6_FL_PL
Endif
dbSelectArea("PC5")
dbSetOrder(2)
dbSeek( xFilial("PC5") + cEmpresa + cFilPes )
if found()
	While !eof() .and. PC5->PC5_FIL_PL == cFilPes .and. PC5->PC5_EMP_PL == cEmpresa
		if pc5->PC5_ATIVO == "S"
			if cTipo == "1"
				cRet := PC5->PC5_PLTIT
			ElseIF cTipo == "2"
				cRet := PC5->PC5_PLTIT
			Else				
				cRet := PC5->PC5_PLAGR
			Endif
		Endif
		PC5->(dbSkip())
	End
Endif
RestArea(aArea)
Return(cRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetInic   บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RetInic(nTipo)
local cRet 		:= ""
Local aArea 	:= GetArea()
Local dDtAdms 	:= u_CalInic(nTipo)

If nTipo == 1
   RecLock("RHK", .F.)
   RHK->RHK_PERINI := strzero(month(dDtAdms),2)+strzero(year(dDtAdms),4)
   RHK->(msUnlock())
ElseIf nTipo == 2
   RecLock("RHL", .F.)
   RHL->RHL_PERINI := strzero(month(dDtAdms),2)+strzero(year(dDtAdms),4)
   RHL->(msUnlock())
ElseIf nTipo == 3
   RecLock("RHM", .F.)
   RHM->RHM_PERINI := strzero(month(dDtAdms),2)+strzero(year(dDtAdms),4)
   RHM->(msUnlock())
Endif

cRet := u_retData(dDtAdms)
RestArea(aArea)

Return(cRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetDem    บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                  
user Function RetDem( nTipo )
Local cRet := space(8)
Local dData := ctod(' ')
if nTipo == 1
	if !Empty( SRA->RA_DEMISSA )
		dData := SRA->RA_DEMISSA
		if !empty(SRA->RA_MDDTEX)
			dData := SRA->RA_MDDTEX
		Endif
	Endif
Else
	if !Empty( SRA->RA_DEMISSA )
		dData := SRA->RA_DEMISSA
		if !empty(SRA->RA_MDDTEX)
			dData := SRA->RA_MDDTEX
		Endif
	Else
		if !empty(SRB->RB_MDDTEX)
			dData := SRB->RB_MDDTEX
		Endif
	Endif
Endif


if !empty(dData) 
	cRet := u_retdata(dData)
Endif
Return(cRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetCar    บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RETCAR(cCARGO)
Local cRet := ""
Local aArea := GetArea()
dbSelectArea("SRJ")
dbSetOrder(1)
if dbSeek( xFilial("SRJ") + cCARGO )
	cRet := SRJ->RJ_DESC
Endif
RestArea(aArea)
Return(cRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetPar    บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RetPar(nTipo)
cRet := ""
If nTipo == 2
	if SRB->RB_GRAUPAR == "C"
		if SRB->RB_SEXO == "M"
			cRet := "17"
		Else
			cRet := "01"
		Endif
	Elseif SRB->RB_GRAUPAR == "F"
		if SRB->RB_SEXO == "M"
			cRet := "02"
		Else
			cRet := "03"
		Endif
	Elseif SRB->RB_GRAUPAR == "O"
		if SRB->RB_SEXO == "M"
			cRet := "40"
		Else
			cRet := "06"
		Endif
	Endif
Else
	if RHM->RHM_SEXO == "M"
		cRet := "40"
	Else
		cRet := "06"
	Endif
EndIf

Return(cRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetccD    บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RetccD()
/*Local cRet := ""
cRet := fDesc("SI3",SRA->RA_CC,"I3_DESC")
cRet := left(cRet, 15)
Return(cRet)
*/
Local cRet := ""
cRet := fDesc("CTT",SRA->RA_CC,"CTT_DESC01")
cRet := left(cRet, 15)
Return(cRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetPla    บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RetPla(cTipo)
Local cRet    := ""
Local aArea   := GetArea()
Local cFilPes := SRA->RA_FILIAL
Local cEmpresa := U_RetEmpr(SRA->RA_FILIAL, SRA->RA_MAT)

dbselectarea( "PC6" )
dbSetOrder(1)
If dbSeek( xFilial("PC6") + SRA->RA_CC )
	cFilPes := PC6->PC6_FL_PL
Endif
	
dbSelectArea("PC5")
dbSetOrder(2)
dbSeek( xFilial("PC5") + cEmpresa + cFilPes )
if found()
	While !eof() .and. PC5->PC5_FIL_PL == cFilPes .and. PC5->PC5_EMP_PL == cEmpresa
		if pc5->PC5_ATIVO == "S"
			if cTipo == "1"
				cRet := PC5->PC5_TITULA
			ElseIf cTipo == "2"
				cRet := PC5->PC5_TITULA
			Else
				cRet := PC5->PC5_AGREG
			Endif
		Endif
		PC5->(dbSkip())
	End
Endif
RestArea(aArea)
Return(cRet) 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetDcas   บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RetDCas()
Local cRet := ""
Local dData := SRA->RA_CSDTCAS
if !Empty( dData )
	if SRB->RB_GRAUPAR == "C"
		cRet := U_retdata(dData)
	Endif
Endif
Return(cRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetEmpr   บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RetEmpr(cFilpes,cMatr) 
Local cRet := ""
Local aArea := GetArea()
Local aAreaSRA := SRA->(GetArea())
Local cCadPla :=  ""

/*   DESABILITADO EM 07/03/2012, pois a rotina somente sera utilizada para a Intermedica - Empresa 01
dbSelectArea("SRA")
dbSetOrder(1) // ra_filial+ra_mat

if dbSeek( cFilpes + cMatr )
	cCadPla := SRA->RA_ASMEDIC
	If cCpoPlan == "RA_ASMANT"
	   cCadPla := SRA->RA_ASMANT
	EndIf

	Do case
		Case cCadPla $ "28/31/29/30/32"
			cRet := "02"
		Case cCadPla $ "27/35/36"
			cRet := "01"
	EndCase
Endif	
RestArea(aAreaSRA)
RestArea(aArea)
*/
cRet := "01"

Return(cRet)   
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCriaIdPL  บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*
User Function CriaIdPL(cFilPes, cMatr )
local cRet := ""
Local cTemp := ""
Local cTemp1 := ""
Local aArea := getarea()

cTemp := U_RetEmpr(cFilPes, cmatr)
if cTemp == "01"
	cTemp1 := GetMV("MV_EMP01",,"7261") 	//Intermedica
Else
	cTemp1 := GetMV("MV_EMP02",,"9803") 	//Notredame
endif

cTemp := padl(u_nextNum(1), 10, "0" )

cRet := cTemp1+cTemp
RestArea(aArea)
Return(cRet)
*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetId     บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RETId( cFilPes, cMatr, nTipo, cCpoMedic )
Local cRet := ""
Local cTemp := ""
Local cTemp1 := ""
Local cCpoTmp := ""
Local aArea := getarea()

cTemp := U_RetEmpr(cFilPes, cmatr)
if cTemp == "01"
	cTemp1 := GetMV("MV_EMP01",,"8941") 	//Intermedica
Else
	cTemp1 := GetMV("MV_EMP02",,"9803") 	//Notredame
endif

if nTipo == 1  	// Titular
    cCpoTmp := "SRA->" + cCpoMedic
	if Empty( &cCpoTmp )
		//cRet := cTemp1 + "0" + SRA->RA_FILIAL + Right(strZero(VAL(SRA->RA_MSIDENT),11),7)
		//os 2244/09
		cRet := cTemp1 + SRA->RA_CIC + "00"
		dbSelectArea("SRA")
		RecLock("SRA", .F. )
		&cCpoTmp := cRet
		msUnlock()
	Else
		cRet := &cCpoTmp
	Endif	
Else			// dependente
    cCpoTmp := "SRB->" + cCpoMedic
	if Empty( &cCpoTmp )
		//cRet := cTemp1 + "0" + SRB->RB_FILIAL + Right(strZero(VAL(SRB->RB_MSIDENT),11),7)
		//OS 2244/09
		cRet := cTemp1 + SRA->RA_CIC + "00"
		dbSelectArea("SRB")
		RecLock("SRB", .F. )
		&cCpoTmp := cRet
		msUnlock()
	Else
		cRet := &cCpoTmp
	Endif	
Endif
cRet := padr(GetMV("MV_EMP01",,"8941"),4) + right(cRet,17)
RestArea(aArea)
Return(cRet)  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGatId     บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

/*  DESATIVADO em 07/03/2012, pois nao estava em uso

User Function GATId( cFilPes, cMatr, nTipo )
Local cRet := ""
Local cTemp := ""
Local cTemp1 := ""
Local aArea := getarea()

cTemp := U_RetEmpr(cFilPes, cmatr)
if cTemp == "01"
	cTemp1 := GetMV("MV_EMP01",,"8941") 	//Intermedica
Else
	cTemp1 := GetMV("MV_EMP02",,"9803") 	//Notredame
endif

if nTipo == 1  	// Titular
	cRet := cTemp1 + "0" + SRA->RA_FILIAL + Right(strZero(VAL(SRA->RA_MSIDENT),11),7)
Else			// dependente
	cRet := cTemp1 + "0" + SRB->RB_FILIAL + Right(strZero(VAL(SRB->RB_MSIDENT),11),7)
Endif
RestArea(aArea)
Return(cRet)                                        
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCalInic   บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CalInic(nTipo)
local dRet := ctod( " " )
Local aArea := GetArea()
Local dDtAdms := SRA->RA_ADMISSA


//OS 2244/09
dDtAdms := STOD(ANOMES(SRA->RA_ADMISSA+120)+"01")
  
/*DESABILITADO PELA OS 2244/09
dbSelectArea("SRJ")
dbSetOrder(1)

if dbSeek( xFilial("SRJ") + SRA->RA_CODFUNC )
    if aLLTRIM(SRJ->RJ_NIVEL) == "O"  
    	dDtAdms := SRA->RA_ADMISSA + GetMv("ES_PRZINI",,90)
    	dDtAdms := cTod( "01/" + strZero(month(dDtAdms),2) + "/" + strZero(Year(dDtAdms),4) )
    Endif
Endif
*/

If nTipo == 2 .and. SRB->RB_DTNASC > dDtAdms
		dDtAdms := SRB->RB_DTNASC

ElseIf nTipo == 3 .and. RHM->RHM_DTNASC > dDtAdms
		dDtAdms := RHM->RHM_DTNASC

Endif

dRet := dDtAdms

RestArea(aArea)

Return(dRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณACB001    บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ACB001()
dbSelectArea("SRA")
dbGotop()
While !eof() 
	if Empty(SRA->RA_MDDTIN)
		dRet := U_CalInic(1)
		RecLock("SRA", .F.)
		SRA->RA_MDDTIN := dRet
		msUnlock()
	Endif
	dbSelectArea("SRB")
	dbSetOrder(1)
	dbSeek( SRA->RA_FILIAL + SRA->RA_MAT ) 
	While !eof() .and. SRB->RB_FILIAL == SRA->RA_FILIAL .and. SRB->RB_MAT == SRA->RA_MAT
		if Empty(SRB->RB_MDDTIN)
			dRet := U_CalInic(2)
			RecLock("SRB", .F.)
			SRB->RB_MDDTIN := dRet
			msUnlock()
		Endif
		dbSkip()
	End
	dbSelectArea("SRA")
	dbSkip()
End
Return nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetDemD   บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user Function RetDemD( nTipo )
Local dRet := ctod(' ')
Local dData := ctod(' ')
if nTipo == 1
	if !Empty( SRA->RA_DEMISSA )
		dData := SRA->RA_DEMISSA
//		if !empty(SRA->RA_MDDTEX)
//			dData := SRA->RA_MDDTEX
//		Endif
	Endif
Else
	if !Empty( SRA->RA_DEMISSA )
		dData := SRA->RA_DEMISSA
//		if !empty(SRA->RA_MDDTEX)
//			dData := SRA->RA_MDDTEX
//		Endif
	Else
		if !empty(SRB->RB_MDDTEX)
			dData := SRB->RB_MDDTEX
		Endif
	Endif
Endif

if !empty(dData) 
	dRet := dData
Endif
Return(dRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNextNum   บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function nextNum(nTipo)
Local cRet := ""
Local aArea := GetArea()
Local cSql := ""
Local cQuery := ""
Local cMax1  := ""
Local cMax2  := ""
Local nRet := 0

IF nTipo = 2
	cSql := "Select Max(substring(RA_MEDMAT,4)) as MAIOR FROM " + RetSqlName("SRA") + " WHERE D_E_L_E_T_ = ' ' "
	cQuery := ChangeQuery( cSql )
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "TTRB1", .F., .T.)
	dbSelectArea("TTRB1")
	if !eof()
		cMax1 := Right(TTRB1->MAIOR, 10)
	Endif
	dbCloseArea()
	
	
	cSql := "Select Max(substring(RB_MEDMAT,4)) as MAIOR FROM " + RetSqlName("SRB") + " WHERE D_E_L_E_T_ = ' ' "
	cQuery := ChangeQuery( cSql )
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "TTRB1", .F., .T.)
	dbSelectArea("TTRB1")
	if !eof()
		cMax2 := right(TTRB1->MAIOR, 10)
	Endif
	dbCloseArea()
	
	nRet := Max( Val(cMax1), Val(cMax2) )
	cRet := strZero(nRet+1, 10, 0)
Else
	cRet := right(GetSx8Num("SRA","RA_MEDMAT"),10)
	ConfirmSx8()
Endif

RestArea(aArea)
Return(cRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPrcRetSRA บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PrcRegSra(cMotivo)
	dbSelectArea("SRJ")
	dbSetorder(1)
	
	// Desabilitado conforme o chamado 4300 - Adilson Silva - 04/07/2008
	//if dbSeek( xFilial("SRJ") + SRA->RA_CODFUNC ) .and. cMovto == "04"
	    //if aLLTRIM(SRJ->RJ_NIVEL) == "O"  
			//cMovto := "49"
	//		cMovto := "11"
	//		//cMovto := "CC"
	//    Endif
	//Endif
			
	//Habilitado conforme o chamado 0508/09 - Isamu 04/03/09
	If Sra->Ra_SitFolh $ " *F*A*"
	   
	   If dbSeek( xFilial("SRJ") + SRA->RA_CODFUNC ) 
	       cNivelFun := Alltrim(Srj->Rj_Nivel)
	       cFuncao   := Alltrim(Srj->Rj_Desc)
	       if aLLTRIM(SRJ->RJ_NIVEL) == "O"  
			   cMovto := "49"
	       Else
	           cMOvto := "04"
	       Endif 
	   Endif 
	
	Endif
	    
	If Sra->Ra_SitFolh == "D" 
	   
	   If Sra->Ra_RescRai $ "31/32"
	      cMovto := "11"
	   ElseIf !(Sra->Ra_RescRai $ "31/32")
	      cMovto := "03"
	   Endif
    
    Endif   
	
	cFilCerta := SRA->RA_FILIAL

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

		If fWrite(nHdlInter,cLin,Len(cLin)) <> Len(cLin)
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
		
		If fWrite(nHdlXInte,cLinFile,Len(cLinFile)) <> Len(cLinFile)
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
		
		If fWrite(nHdlXInte,cLinFile,Len(cLinFile)) <> Len(cLinFile)
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

cQuery := "SELECT 	SRA.R_E_C_N_O_ as NumRegSRA, "
cQuery += "			RHK.R_E_C_N_O_ as NumRegRHK "
cQuery += "FROM " + RetSqlName("SRA") + " SRA, " + RetSqlName("RHK") + " RHK "
cQuery += " WHERE "
cQuery += "    SRA.D_E_L_E_T_ <> '*'  AND "
cQuery += "    RHK.D_E_L_E_T_ <> '*'  AND "
cQuery += "    RA_FILIAL = RHK_FILIAL AND "
cQuery += "    RA_MAT    = RHK_MAT    AND "
cQuery += "    RA_SITFOLH <> 'D' AND "
cQuery += "    RA_FILIAL NOT IN " + FORMATIN(cFilExc, "/") + " AND "
cQuery += "    RHK_TPFORN = '1' AND "
cQuery += "    RHK_PLANO IN " + FORMATIN(cPlanos, "/") + " AND "
cQuery += "    RHK_PERINI <> '' AND "
cQuery += "    right(RHK_PERINI,4)+left(RHK_PERINI,2)+'01' BETWEEN '"+cIniVig+"' AND '"+cFimVig+"' AND "
cQuery += "    RHK_PERFIM = '' AND "
cTemp  := "    ( ("

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


/*
// Verifica o Tipo da Rotina
if !empty(mv_par05)
	if mv_par05 == 3 //normal
		cQuery += " AND SUBSTRING(RA_CTRINTE,1,1) IN (' ','N','1') "
	Elseif mv_par05 == 2 //reenvio
		cQuery += " AND SUBSTRING(RA_CTRINTE,1,1) IN (' ','N') "
	Elseif mv_par05 == 1 //carga
		cQuery += " AND SUBSTRING(RA_CTRINTE,1,1) IN ('1') "
		cSql := "UPDATE " + RetSqlName("SRA") + " SET RA_CTRINTE = 'N'+SUBSTRING(RA_CTRINTE,2,2) WHERE SUBSTRING(RA_CTRINTE,1,1) = '1' "
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
*/

if mv_par05 == 3 .or. mv_par05 == 1 //normal ou carga
	cQuery += " AND SUBSTRING(RHK_CRTIN_,1,1) IN (' ','N') "
Elseif mv_par05 == 2 //reenvio
	cQuery += " AND SUBSTRING(RHK_CRTIN_,1,1) IN (' ','N','1') "
EndIf

cQuery += " ORDER BY RA_FILIAL, RA_MAT "

//memowrite("C:\ASR\INTER.TXT",cQuery)

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "TRB", .F., .T.)

dbSelectArea('TRB')
aLayout  := RTExpp2()

While TRB->(!EOF())
	//cMovto  := "04"

	dbSelectArea("SRA")
	//dbSetOrder(1)
	SRA->(dbGoto(TRB->NumRegSRA))
	RHK->(dbGoto(TRB->NumRegRHK))
    
/*    
    If SRA->RA_ASMANT <> "  " .And. (SRA->RA_ASMEDIC <> SRA->RA_ASMANT)
		RecLock("SRA", .F.)
		 SRA->RA_MDDTIN := Ctod( "" )
		MsUnlock()
	EndIf
*/

	//cInicio := U_RetInic(1)

	//os 0508-09
	//cInicio := right(cInicio,4) + substr(cInicio, 3,2) 
	
/* desabilitado pela os 4422/09
	if cInicio > left(cDtExp,6) //.Or. cInicio < left(cDtExp,6)
		dbSelectArea("TRB")
		dbSkip()
		Loop
	Endif
*/
    
	cMesg := "" 
	PrCRegSRA(cMovto)
	If Empty(cMesg) .and. left(RHK->RHK_CRTIN_,1) <> '1'
		//dbSelectArea("SRA")
		//RecLock("SRA", .F.)
		// SRA->RA_CTRINTE := "1" + Right(SRA->RA_CTRINTE,2)
		//MsUnlock()
		RecLock("RHK", .F.)
		RHK->RHK_CRTIN_ := "1" + Right(RHK->RHK_CRTIN_,2)
		RHK->(MsUnlock())
		
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ'ÜÜÜÜ
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

aLayout1 := RTExpp3()
aLayout2 := RTExpp4()

//Dependentes
cQuery := "SELECT RB.R_E_C_N_O_  as NumReg, 
cQuery += "       RA.R_E_C_N_O_  as NumSRA, 
cQuery += "       RHL.R_E_C_N_O_ as NumRHL
cQuery += " FROM " + RetSqlName("SRB") + " RB, " + RetSqlName("SRA") + " RA, " + RetSqlName("RHL") + " RHL "
cQuery += " WHERE "
cQuery += "   RA_MAT = RB_MAT  AND RA_FILIAL = RB_FILIAL  AND "
cQuery += "   RA_MAT = RHL_MAT AND RA_FILIAL = RHL_FILIAL AND "
cQuery += "   RB_COD = RHL_CODIGO "
cQuery += "   AND RA_MAT = '"+SRA->RA_MAT+"' "
cQuery += "   AND RA_FILIAL = '"+SRA->RA_FILIAL+"' "
cQuery += "   AND RHL_PERINI <> '' "
cQuery += "   AND right(RHL_PERINI,4)+left(RHL_PERINI,2)+'01' BETWEEN '"+cIniVig+"' AND '"+cFimVig+"' "
cQuery += "   AND RHL_PERFIM = '' "                             
cQuery += "   AND RA.D_E_L_E_T_  = ' ' "
cQuery += "   AND RB.D_E_L_E_T_  = ' ' "
cQuery += "   AND RHL.D_E_L_E_T_ = ' ' "
cQuery += "   AND RHL_PLANO IN " + FORMATIN(cPlanos, "/") + " "

if mv_par05 == 3 .or. mv_par05 == 1 //normal ou carga
	cQuery += " AND SUBSTRING(RHL_CRTIN_,1,1) IN (' ','N') "
Elseif mv_par05 == 2 //reenvio
	cQuery += " AND SUBSTRING(RHL_CRTIN_,1,1) IN (' ','N','1') "
EndIf


dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "TRB2", .F., .T.)
dbSelectArea('TRB2')

While TRB2->(!EOF())
	cMovto := "14"
	
	dbSelectArea("SRA")
    SRA->(dbGoto(TRB2->NUMSRA))
	dbSelectArea("SRB")
	SRB->(dbGoto(TRB2->NumReg)) 
	RHL->(dbGoto(TRB2->NumRHL)) 
    
	//cInicio := u_RetInic(1)
	//cInicio := right(cInicio,4) + substr(cInicio, 3,2) 
	//desabilitado pela os 4422/09
	/*
	if cInicio >= left(cDtExp,6)
		dbSelectArea("TRB2")
		dbSkip()
		Loop
	Endif
    */
	cMesg := "" 
	PrcRegSRB(cMovto,2)
	If Empty(cMesg) .and. left(RHL->RHL_CRTIN_,1) <> '1'
		dbSelectArea("SRB")
		//RecLock("SRB", .F.)
		//SRB->RB_CTRINTE := "1" + Right(SRB->RB_CTRINTE,2)
		//MsUnlock()
		RecLock("RHL",.f.)
		RHL->RHL_CRTIN_ := "1" + Right(RHL->RHL_CRTIN_,2) 
		RHL->(MsUnlock())
	Endif
	// avan็a leitura do arquivo principal
	dbSelectArea("TRB2")
	dbSkip()
EndDo
dbSelectArea("TRB2")
dbCloseArea()

//A CSU nao aceita agregados na Intermedica
/*
//Agregados
cQuery := "SELECT RA.R_E_C_N_O_  as NumSRA, 
cQuery += "       RHM.R_E_C_N_O_ as NumRHM
cQuery += " FROM " + RetSqlName("SRA") + " RA, " + RetSqlName("RHM") + " RHM "
cQuery += " WHERE "
cQuery += "   RA_MAT = RHM_MAT AND RA_FILIAL = RHM_FILIAL "
cQuery += "   AND RA_MAT = '"+SRA->RA_MAT+"' "
cQuery += "   AND RA_FILIAL = '"+SRA->RA_FILIAL+"' "
cQuery += "   AND RHM_PERINI <> '' "
cQuery += "   AND right(RHM_PERINI,4)+left(RHM_PERINI,2)+'01' BETWEEN '"+cIniVig+"' AND '"+cFimVig+"' "
cQuery += "   AND RHM_PERFIM = '' "                             
cQuery += "   AND RA.D_E_L_E_T_  = ' ' "
cQuery += "   AND RHM.D_E_L_E_T_ = ' ' "
cQuery += "   AND RHM_PLANO IN " + FORMATIN(cPlanos, "/") + " "

if mv_par05 == 3 .or. mv_par05 == 1 //normal ou carga
	cQuery += " AND SUBSTRING(RHM_CRTIN_,1,1) IN (' ','N') "
Elseif mv_par05 == 2 //reenvio
	cQuery += " AND SUBSTRING(RHM_CRTIN_,1,1) IN (' ','N','1') "
EndIf


dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "TRB2", .F., .T.)
dbSelectArea('TRB2')

While TRB2->(!EOF())
	cMovto := "14"
	
	dbSelectArea("SRA")
    SRA->(dbGoto(TRB2->NUMSRA))
	RHM->(dbGoto(TRB2->NumRHM)) 
    
	//cInicio := u_RetInic(1)
	//cInicio := right(cInicio,4) + substr(cInicio, 3,2) 

	//desabilitado pela os 4422/09
	
	//if cInicio >= left(cDtExp,6)
	//	dbSelectArea("TRB2")
	//	dbSkip()
	//	Loop
	//Endif
    
	cMesg := "" 
	PrcRegSRB(cMovto,3)
	If Empty(cMesg) .and. left(RHM->RHM_CRTIN_,1) <> '1'
		dbSelectArea("SRB")
		//RecLock("SRB", .F.)
		//SRB->RB_CTRINTE := "1" + Right(SRB->RB_CTRINTE,2)
		//MsUnlock()
		RecLock("RHM",.f.)
		RHM->RHM_CRTIN_ := "1" + Right(RHM->RHM_CRTIN_,2) 
		RHM->(MsUnlock())
	Endif
	// avan็a leitura do arquivo principal
	dbSelectArea("TRB2")
	dbSkip()
EndDo
dbSelectArea("TRB2")
dbCloseArea()
*/

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
Static Function PrcRegSRB(cMovimento,nTipo)
	cMovto := cMovimento
	cFilCerta := SRB->RB_FILIAL

	If nTipo == 3 //Agregados
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
		cFilCerta := RHM->RHM_FILIAL
	Endif

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
			If nTipo == 2 //Dependentes
				nTamLin := retTamLin(aLayout1)   //tamanho da extensใo da linha
				cLin    := ProcLayout(aLayout1, nTamLin, @cMesg, cMovto)

			Else 
				nTamLin := retTamLin(aLayout2)   //tamanho da extensใo da linha
				cLin    := ProcLayout(aLayout2, nTamLin, @cMesg, cMovto)
			Endif			
			if empty(cMesg)
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ณ
				//ณ linha montada.                                                      ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				cLin    += CRLF
				If fWrite(nHdlInter,cLin,Len(cLin)) <> Len(cLin)
					apMsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
				Endif

				Set Century On
				cLinFile := "<TR><TD style='Background: #FFFFC0; font-style: Bold;'>OK</TD>"
				cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRA->RA_MAT)+"</TD>"
				cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRA->RA_FILIAL)+"</TD>"
				cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRA->RA_CC)+"</TD>"
				cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRA->RA_NOME)+"</TD>"
				If nTipo == 2
					cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRB->RB_NOME)+"</TD>"
				Else
					cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(RHM->RHM_NOME)+"</TD>"
				EndIf
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
				
				If fWrite(nHdlXInte,cLinFile,Len(cLinFile)) <> Len(cLinFile)
					apMsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
				Endif			
	
			else
				Set Century On
				cLinFile := "<TR><TD style='Background: #FFFFC0; font-style: Bold;'>ERRO</TD>"
				cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRA->RA_MAT)+"</TD>"
				cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRA->RA_FILIAL)+"</TD>"
				cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRA->RA_CC)+"</TD>"
				cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRA->RA_NOME)+"</TD>"
				If nTipo == 2
					cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(SRB->RB_NOME)+"</TD>"
				Else
					cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"+Alltrim(RHM->RHM_NOME)+"</TD>"
				EndIf
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
				
				If fWrite(nHdlXInte,cLinFile,Len(cLinFile)) <> Len(cLinFile)
					apMsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
				Endif			
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
cQuery += " AND RA_SITFOLH IN (' ', 'A', 'F') "
cQuery += " AND RA_FILIAL NOT IN " + FORMATIN(cFilExc, "/") + " "
cQuery += " AND RA_ALTAMED = 'S' "
cQuery += " AND RA_MDDTIN BETWEEN '" + cIniVig + "' AND '" + cFimVig + "' "
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
	cMovto := "16"

	dbSelectArea("SRA")
	SRA->(dbGoto(TRB->NumReg))

	cInicio := U_RetInic(1)
	cInicio := right(cInicio,4) + substr(cInicio, 3,2) 
	//desabilitado pela os 4244/09
	/*
	if cInicio >= left(cDtExp,6)
		dbSelectArea("TRB")
		dbSkip()
		Loop
	Endif
    */
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
cQuery += " AND RA.RA_MDDTIN BETWEEN '" + cIniVig + "' AND '" + cFimVig + "' "
cQuery += " AND RB.RB_ALTAMED = 'S' "
cQuery += " AND RB.RB_ASSIMED = 'S' "
cQuery += " AND RA.D_E_L_E_T_ = ' ' "
cQuery += " AND RB.D_E_L_E_T_ = ' ' "

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "TRB2", .F., .T.)
dbSelectArea('TRB2')
aLayout1 := RTExpp3()
aLayout2 := RTExpp4()
While TRB2->(!EOF())
	cMovto := "18" //Altera็ใo de dependente com titular ja cadastrado
	
	dbSelectArea("SRA")
    SRA->(dbGoto(TRB2->NUMSRA))
	dbSelectArea("SRB")
	SRB->(dbGoto(TRB2->NumReg)) 
    
	cInicio := u_RetInic(1)
	cInicio := right(cInicio,4) + substr(cInicio, 3,2) 
	//desabilitado pela os 4422/09
	/*
	if cInicio >= left(cDtExp,6)
		dbSelectArea("TRB2")
		dbSkip()
		Loop
	Endif
    */
	cMesg := ""
	PrcRegSRB(cMovto,2)
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

Local dDtCortef:= Stod(Subs(Dtos(dDataBase),1,6)+StrZero(f_ultDia(dDataBase),2))
Local dDtCorte := Stod(Subs(Dtos(dDataBase),1,6)+"01")
Local cDtCortef:= Dtos(dDtCortef)
Local cDtCorte := Dtos(dDtCorte)
Local cNewFil, cNewMat

cQuery := "SELECT 	SRA.R_E_C_N_O_ as NumRegSRA, "
cQuery += "			RHK.R_E_C_N_O_ as NumRegRHK "
cQuery += "FROM " + RetSqlName("SRA") + " SRA, " + RetSqlName("RHK") + " RHK "
cQuery += "  WHERE "
cQuery += "    SRA.D_E_L_E_T_ <> '*'  AND "
cQuery += "    RHK.D_E_L_E_T_ <> '*'  AND "
cQuery += "    RA_FILIAL = RHK_FILIAL AND "
cQuery += "    RA_MAT    = RHK_MAT    AND "
cQuery += "    RA_SITFOLH = 'D' AND "
cQuery += "    RA_FILIAL NOT IN " + FORMATIN(cFilExc, "/") + " AND "
cQuery += "    RHK_TPFORN = '1' AND "
cQuery += "    RHK_PLANO IN " + FORMATIN(cPlanos, "/") + " AND "

if mv_par05 == 3 .or. mv_par05 == 1 //normal ou carga
	cQuery += " SUBSTRING(RHK_CRTIN_,2,1) IN (' ','N') "
Elseif mv_par05 == 2 //reenvio
	cQuery += " SUBSTRING(RHK_CRTIN_,2,1) IN (' ','N','1') "
EndIf

cQuery += " AND SUBSTRING(RHK_CRTIN_,1,1) = '1' "  //so pode enviar exclusao se ja estiver com status de incluido

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
//cQuery += " AND RA_DEMISSA BETWEEN '" + cDtCorte  + "' AND '"+cDtCortef+"' "
cQuery += " AND RA_DEMISSA BETWEEN '" + cIniVig  + "' AND '"+cFimVig+"' "

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "TRB", .F., .T.)
dbSelectArea('TRB')

aLayout  := RTExpp2()

While TRB->(!EOF())
	cMovto := "03"

	dbSelectArea("SRA")
	SRA->(dbGoto(TRB->NumRegSRA))
	RHK->(dbGoto(TRB->NumRegRHK))
	
	dDataDem := u_RetDemD(1)
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Incrementa a regua                                                  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//	if dtos(dDataDem) < cDtCorte
//		dbSelectArea("TRB")
//		dbSkip()
//		Loop
//	Endif

	// Se for transferencia efetua a baixa somente no SRA
	If SRA->RA_RESCRAI $ '30/31'
	   cNewFil  := "@@"		; cNewMat  := "@@"
	   U_fNewReg( SRA->RA_FILIAL, SRA->RA_MAT, SRA->RA_DEMISSA, @cNewFil, @cNewMat )
	   If cNewFil <> "@@" .And. cNewMat <> "@@"
	      dbSelectArea("RHK")
	      nRHKRec := RHK->(Recno())
	      If dbSeek( cNewFil + cNewMat )
		  	While RHK->(!eof()) .and. RHK->(RHK_FILIAL+RHK_MAT) == cNewFil + cNewMat
			 	If RHK->RHK_TPFORN == '1'
			 		If empty(RHK->RHK_PERFIM)
						 RecLock("RHK", .F.)
						 RHK->RHK_CRTIN_ := Left(RHK->RHK_CRTIN_,2) + "1"	// Transferencia de Funcionario
					 	 RHK->(MsUnlock())
					 	 exit
					EndIf
				EndIF
				RHK->(dbskip())
			EndDo	
	      EndIf
	      RHK->(dbGoTo( nRHKRec ))
       EndIf

		If substr(RHK->RHK_CRTIN_,2,1) <> '1'
		   RecLock("RHK", .F.)
		    RHK->RHK_CRTIN_ := Left(RHK->RHK_CRTIN_,1) + "1" + Right(RHK->RHK_CRTIN_,1)
		   MsUnlock()
		EndIf
	
	   dbSelectArea("TRB")
	   dbSkip()
	   Loop
	Endif

	cMesg := "" 
	PrCRegSRA(cMovto)
	if empty(cMesg)
		dbSelectArea("RHK")
		RecLock("RHK", .F.)
	     RHK->RHK_CRTIN_ := Left(RHK->RHK_CRTIN_,1) + "1" + Right(RHK->RHK_CRTIN_,1)
		 RHK->RHK_PERFIM := strzero(month(dDataDem),2)+strzero(year(dDataDem),4)
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
ฑฑบPrograma  ณAltDep    บAutor  ณMicrosiga           บ Data ณ   /  /      บฑฑ
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

aLayout1 := RTExpp3()
aLayout2 := RTExpp4()

//Dependentes
cQuery := "SELECT RB.R_E_C_N_O_  as NumReg, 
cQuery += "       RA.R_E_C_N_O_  as NumSRA, 
cQuery += "       RHL.R_E_C_N_O_ as NumRHL
cQuery += " FROM " + RetSqlName("SRB") + " RB, " + RetSqlName("SRA") + " RA, " + RetSqlName("RHL") + " RHL "
cQuery += " WHERE "
cQuery += "   RA_MAT = RB_MAT  AND RA_FILIAL = RB_FILIAL  AND "
cQuery += "   RA_MAT = RHL_MAT AND RA_FILIAL = RHL_FILIAL AND "
cQuery += "   RB_COD = RHL_CODIGO "
cQuery += "   AND RA_MAT = '"+SRA->RA_MAT+"' "
cQuery += "   AND RA_FILIAL = '"+SRA->RA_FILIAL+"' "
cQuery += "   AND (RHL_PERFIM = '' or RHL_PERFIM = '" + RHK->RHK_PERFIM + "') "
cQuery += "   AND RA.D_E_L_E_T_ = ' ' "
cQuery += "   AND RB.D_E_L_E_T_ = ' ' "
cQuery += "   AND RHL.D_E_L_E_T_ = ' ' "
cQuery += "   AND RHL_PLANO IN " + FORMATIN(cPlanos, "/") + " "

if mv_par05 == 3 .or. mv_par05 == 1 //normal ou carga
	cQuery += " AND SUBSTRING(RHL_CRTIN_,2,1) IN (' ','N') "
Elseif mv_par05 == 2 //reenvio
	cQuery += " AND SUBSTRING(RHL_CRTIN_,2,1) IN (' ','N','1') "
EndIf

cQuery += " AND SUBSTRING(RHL_CRTIN_,1,1) = '1' "  //so pode enviar exclusao se ja estiver com status de incluido

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "TRB2", .F., .T.)
dbSelectArea('TRB2')
While TRB2->(!EOF())
	cMovto := "12" //Desligamento de dependentes
	
	dbSelectArea("SRA")
	SRA->(dbGoto(TRB2->NumSra))
	dbSelectArea("SRB")
	SRB->(dbGoto(TRB2->NumReg))
	RHL->(dbGoto(TRB2->NumRHL))

	cMesg := ""
	PrcRegSRB(cMovto,2)
	If Empty(cMesg) .and. substr(RHL->RHL_CRTIN_,2,1) <> '1'
		dbSelectArea("RHL")
		RecLock("RHL", .F.)
	     RHL->RHL_CRTIN_ := Left(RHL->RHL_CRTIN_,1) + "1" + Right(RHL->RHL_CRTIN_,1)
		 If lTroca
		    RHL->RHL_MATIN_ := ""
		 Else
		    RHL->RHL_PERFIM := substr(cIniVig,5,2)+substr(cIniVig,1,4)
		 EndIf
		MsUnlock()
	Endif
	// avan็a leitura do arquivo principal
	dbSelectArea("TRB2")
	dbSkip()
EndDo
dbSelectArea("TRB2")
dbCloseArea()

//A CSU nao aceita agregados na Intermedica
/*
//Agregados
cQuery := "SELECT RA.R_E_C_N_O_  as NumSRA, 
cQuery += "       RHM.R_E_C_N_O_ as NumRHM
cQuery += " FROM " + RetSqlName("SRA") + " RA, " + RetSqlName("RHM") + " RHM "
cQuery += " WHERE "
cQuery += "   RA_MAT = RHM_MAT AND RA_FILIAL = RHM_FILIAL "
cQuery += "   AND RA_MAT = '"+SRA->RA_MAT+"' "
cQuery += "   AND RA_FILIAL = '"+SRA->RA_FILIAL+"' "
cQuery += "   AND (RHM_PERFIM = '' or RHM_PERFIM = '" + RHK->RHK_PERFIM + "') "
cQuery += "   AND RA.D_E_L_E_T_ = ' ' "
cQuery += "   AND RHM.D_E_L_E_T_ = ' ' "
cQuery += "   AND RHM_PLANO IN " + FORMATIN(cPlanos, "/") + " "

if mv_par05 == 3 .or. mv_par05 == 1 //normal ou carga
	cQuery += " AND SUBSTRING(RHM_CRTIN_,2,1) IN (' ','N') "
Elseif mv_par05 == 2 //reenvio
	cQuery += " AND SUBSTRING(RHM_CRTIN_,2,1) IN (' ','N','1') "
EndIf

cQuery += " AND SUBSTRING(RHM_CRTIN_,1,1) = '1' "  //so pode enviar exclusao se ja estiver com status de incluido

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "TRB2", .F., .T.)
dbSelectArea('TRB2')
While TRB2->(!EOF())
	cMovto := "12" //Desligamento de dependentes
	
	dbSelectArea("SRA")
	SRA->(dbGoto(TRB2->NumSra))
	RHM->(dbGoto(TRB2->NumRHM))

	cMesg := ""
	PrcRegSRB(cMovto,3)
	If Empty(cMesg) .and. substr(RHM->RHM_CRTIN_,2,1) <> '1'
		dbSelectArea("RHM")
		RecLock("RHM", .F.)
	     RHM->RHM_CRTIN_ := Left(RHM->RHM_CRTIN_,1) + "1" + Right(RHM->RHM_CRTIN_,1)
		 If lTroca
		    RHM->RHM_MATIN_ := ""
		 Else
		    RHM->RHM_PERFIM := substr(cIniVig,5,2)+substr(cIniVig,1,4)
		 EndIf
		MsUnlock()
	Endif
	// avan็a leitura do arquivo principal
	dbSelectArea("TRB2")
	dbSkip()
EndDo
dbSelectArea("TRB2")
dbCloseArea()
*/

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

aLayout1 := RTExpp3()
aLayout2 := RTExpp4()

//Dependentes
cQuery := "SELECT RB.R_E_C_N_O_  as NumReg, 
cQuery += "       RA.R_E_C_N_O_  as NumSRA, 
cQuery += "       RHK.R_E_C_N_O_ as NumRHK,
cQuery += "       RHL.R_E_C_N_O_ as NumRHL
cQuery += " FROM " + RetSqlName("SRB") + " RB, " + RetSqlName("SRA") + " RA, " + RetSqlName("RHK") + " RHK, " + RetSqlName("RHL") + " RHL "
cQuery += " WHERE "
cQuery += "   RB_FILIAL NOT IN " + FORMATIN(cFilExc, "/") + " AND "
cQuery += "   RA_MAT = RB_MAT  AND RA_FILIAL = RB_FILIAL  AND "
cQuery += "   RA_MAT = RHK_MAT AND RA_FILIAL = RHK_FILIAL AND "
cQuery += "   RA_MAT = RHL_MAT AND RA_FILIAL = RHL_FILIAL AND "
cQuery += "   RB_COD = RHL_CODIGO "
CQuery += "   AND RA_SITFOLH IN (' ', 'A', 'F') "
cQuery += "   AND RA_MAT = '"+SRA->RA_MAT+"' "
cQuery += "   AND RA_FILIAL = '"+SRA->RA_FILIAL+"' "
cQuery += "   AND RHK_PERINI <> '' "
cQuery += "   AND right(RHK_PERINI,4)+left(RHK_PERINI,2)+'01' <= '"+cIniVig+"' "
cQuery += "   AND RHK_PERFIM = '' "
cQuery += "   AND RHL_PERINI <> '' "
cQuery += "   AND right(RHL_PERINI,4)+left(RHL_PERINI,2)+'01' BETWEEN '"+cIniVig+"' AND '"+cFimVig+"' "
cQuery += "   AND RHL_PERFIM = '' "                             
cQuery += "   AND RA.D_E_L_E_T_  = ' ' "
cQuery += "   AND RB.D_E_L_E_T_  = ' ' "
cQuery += "   AND RHL.D_E_L_E_T_ = ' ' "
cQuery += "   AND RHL_PLANO IN " + FORMATIN(cPlanos, "/") + " "

if mv_par05 == 3 .or. mv_par05 == 1 //normal ou carga
	cQuery += " AND SUBSTRING(RHL_CRTIN_,1,1) IN (' ','N') "
Elseif mv_par05 == 2 //reenvio
	cQuery += " AND SUBSTRING(RHL_CRTIN_,1,1) IN (' ','N','1') "
EndIf

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "TRB2", .F., .T.)
dbSelectArea('TRB2')

While TRB2->(!EOF())
	cMovto := "07" //Inclusao de dependente com titular ja cadastrado
	
	dbSelectArea("SRA")
    SRA->(dbGoto(TRB2->NUMSRA))
	dbSelectArea("SRB")
	SRB->(dbGoto(TRB2->NumReg)) 
	RHK->(dbGoto(TRB2->NumRHK)) 
	RHL->(dbGoto(TRB2->NumRHL)) 
    
	//cInicio := u_RetInic(1)
	//cInicio := right(cInicio,4) + substr(cInicio, 3,2)
	//desabilitado pela os 4422/09
	/*
	if cInicio >= left(cDtExp,6)
		dbSelectArea("TRB2")
		dbSkip()
		Loop
	Endif
    */
	cMesg := "" 
	PrcRegSRB(cMovto,2)
	If Empty(cMesg) .and. left(RHL->RHL_CRTIN_,1) <> '1'
		//dbSelectArea("SRB")
		//RecLock("SRB", .F.)
		// SRB->RB_CTRINTE := "1" + Right(SRB->RB_CTRINTE,2)
		//MsUnlock()
		RecLock("RHL", .F.)
		RHL->RHL_CRTIN_ := "1" + Right(RHL->RHL_CRTIN_,2)
		RHL->(MsUnlock())
	Endif
	// avan็a leitura do arquivo principal
	dbSelectArea("TRB2")
	dbSkip()
EndDo
dbSelectArea("TRB2")
dbCloseArea()  

//A CSU nao aceita agregados na Intermedica
/*
//Agregados
cQuery := "SELECT RA.R_E_C_N_O_  as NumSRA, 
cQuery += "       RHK.R_E_C_N_O_ as NumRHK,
cQuery += "       RHM.R_E_C_N_O_ as NumRHM
cQuery += " FROM " + RetSqlName("SRA") + " RA, " + RetSqlName("RHK") + " RHK, " + RetSqlName("RHM") + " RHM "
cQuery += " WHERE "
cQuery += "   RA_FILIAL NOT IN " + FORMATIN(cFilExc, "/") + " AND "
cQuery += "   RA_MAT = RHK_MAT AND RA_FILIAL = RHK_FILIAL AND "
cQuery += "   RA_MAT = RHM_MAT AND RA_FILIAL = RHM_FILIAL AND "
CQuery += "   RA_SITFOLH IN (' ', 'A', 'F') "
cQuery += "   AND RA_MAT = '"+SRA->RA_MAT+"' "
cQuery += "   AND RA_FILIAL = '"+SRA->RA_FILIAL+"' "
cQuery += "   AND RHK_PERINI <> '' "
cQuery += "   AND right(RHK_PERINI,4)+left(RHK_PERINI,2)+'01' <= '"+cIniVig+"' "
cQuery += "   AND RHK_PERFIM = '' "
cQuery += "   AND RHM_PERINI <> '' "
cQuery += "   AND right(RHM_PERINI,4)+left(RHM_PERINI,2)+'01' BETWEEN '"+cIniVig+"' AND '"+cFimVig+"' "
cQuery += "   AND RHM_PERFIM = '' "                             
cQuery += "   AND RA.D_E_L_E_T_  = ' ' "
cQuery += "   AND RHM.D_E_L_E_T_ = ' ' "
cQuery += "   AND RHM_PLANO IN " + FORMATIN(cPlanos, "/") + " "

if mv_par05 == 3 .or. mv_par05 == 1 //normal ou carga
	cQuery += " AND SUBSTRING(RHM_CRTIN_,1,1) IN (' ','N') "
Elseif mv_par05 == 2 //reenvio
	cQuery += " AND SUBSTRING(RHM_CRTIN_,1,1) IN (' ','N','1') "
EndIf

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "TRB2", .F., .T.)
dbSelectArea('TRB2')

While TRB2->(!EOF())
	cMovto := "07" //Inclusao de dependente com titular ja cadastrado
	
	dbSelectArea("SRA")
    SRA->(dbGoto(TRB2->NUMSRA))
	RHK->(dbGoto(TRB2->NumRHK)) 
	RHM->(dbGoto(TRB2->NumRHM)) 
    
	//cInicio := u_RetInic(1)
	//cInicio := right(cInicio,4) + substr(cInicio, 3,2)

	//desabilitado pela os 4422/09
	//if cInicio >= left(cDtExp,6)
	//	dbSelectArea("TRB2")
	//	dbSkip()
	//	Loop
	//Endif
    
	cMesg := "" 
	PrcRegSRB(cMovto,3)
	If Empty(cMesg) .and. left(RHM->RHM_CRTIN_,1) <> '1'
		//dbSelectArea("SRB")
		//RecLock("SRB", .F.)
		// SRB->RB_CTRINTE := "1" + Right(SRB->RB_CTRINTE,2)
		//MsUnlock()
		RecLock("RHM", .F.)
		RHM->RHM_CRTIN_ := "1" + Right(RHM->RHM_CRTIN_,2)
		RHM->(MsUnlock())
	Endif
	// avan็a leitura do arquivo principal
	dbSelectArea("TRB2")
	dbSkip()
EndDo
dbSelectArea("TRB2")
dbCloseArea()  
*/

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
cQuery += " AND SUBSTRING(RB.RB_CTRINTE,2,1) <> '1'"
cQuery += " AND RB_FILIAL NOT IN " + FORMATIN(cFilExc, "/") + " "
cQuery += " AND RB.RB_ASSIMED = 'S' "
cQuery += " AND RA_ASMEDIC IN " + FORMATIN(cPlanos, "/")
cQuery += " AND RA_ASMEDIC <> ' ' "
CQuery += " AND RA_SITFOLH IN (' ', 'A', 'F') "
cQuery += " AND RA_MDDTIN BETWEEN '" + cIniVig + "' AND '" + cFimVig + "' "
cQuery += " AND RA.D_E_L_E_T_ = ' ' "
cQuery += " AND RB.D_E_L_E_T_ = ' ' "

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "TRB2", .F., .T.)
dbSelectArea('TRB2')
aLayout1 := RTExpp3()
aLayout2 := RTExpp4()
While TRB2->(!EOF())
	cMovto := "18" //Altera็ใo de dependente com titular ja cadastrado
	
	dbSelectArea("SRA")
    SRA->(dbGoto(TRB2->NUMSRA))
	dbSelectArea("SRB")
	SRB->(dbGoto(TRB2->NumReg)) 
    
	// Verifica Exclusao do Plano
	If !Empty( SRB->RB_MDDTEX )
	   cMovto := "12" //Exclusao de dependente com titular ativo
	EndIf
	
	cInicio := u_RetInic(1)
	cInicio := right(cInicio,4) + substr(cInicio, 3,2) 
	//desabilitado pela os 4422/09
	/*
	if cInicio >= left(cDtExp,6)
		dbSelectArea("TRB2")
		dbSkip()
		Loop
	Endif
    */
	cMesg := ""
	PrcRegSRB(cMovto,2)
	If Empty(cMesg)
		dbSelectArea("SRB")
		RecLock("SRB", .F.)
		If cMovto == "12"
   		   SRB->RB_CTRINTE := Left(SRB->RB_CTRINTE,1) + "1" + Right(SRB->RB_CTRINTE,1)
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
cQuery += " AND RA_ASMANT <> '  '"
cQuery += "        AND RA_ASMEDIC <> RA_ASMANT) OR SUBSTRING(RA_CTRINTE,3,1) = '1' )"
CQuery += " AND RA_SITFOLH IN (' ', 'A', 'F') "
cQuery += " AND RA_FILIAL NOT IN " + FORMATIN(cFilExc, "/") + " "
cQuery += " AND SUBSTRING(RA_CTRINTE,2,1) IN ('N', ' ') "
cQuery += " AND RA_MDDTIN BETWEEN '" + cIniVig + "' AND '" + cFimVig + "' "  //Silvano 19/02/2010
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
	cMovto := If(SubStr(RA_CTRINTE,3,1) = '1',"11",cMovto)
	
	cMesg := "" 
	PrCRegSRA(cMovto)
	if empty(cMesg)
		dbSelectArea("SRA")
		RecLock("SRA", .F.)
		 SRA->RA_ASMANT  := SRA->RA_ASMEDIC
	     SRA->RA_CTRINTE := "1" + SubStr(SRA->RA_CTRINTE,2,1) + " "
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
CQuery += " AND RA_SITFOLH IN (' ', 'A', 'F') "
cQuery += " AND RA_FILIAL NOT IN " + FORMATIN(cFilExc, "/") + " "
cQuery += " AND SUBSTRING(RA_CTRINTE,2,1) IN ('N', ' ') "        
cQuery += " AND RA_MDDTIN BETWEEN '" + cIniVig + "' AND '" + cFimVig + "' "  //Silvano 19/02/2010
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
		 SRA->RA_CTRINTE := ""
		 SRA->RA_MATINTE := ""
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

// Regra do Campo RA_CTRINTE
// 1 = Inclusao
// 2 = Exclusao
// 3 = Transferencia
