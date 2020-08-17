#include 'fivewin.ch'
#include 'topconn.ch'
#Include 'Protheus.ch'
#Include 'Color.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CSPMSR01 บAutor ณCristian Verneque    บ Data ณ  05/01/07   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atendimento de Chamados ( em formato grafico )             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ PMS/Compras                                                บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CSPMSR01()
Private	lEnd		:= .f.
Private	aAreaZA1	:= SZ1->(GetArea())
Private	cPerg		:= PADR("PMSR02",LEN(SX1->X1_GRUPO))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAjusta os parametros.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
CriaSX1(cPerg)

If	( ! Pergunte(cPerg,.T.) )
	Return
Else
	
	Private	cStatusIni := Str(mv_par01,1)			// Status
	Private	cStatusFin := Str(mv_par02,1)			// Status
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณExecuta a rotina de impressao ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Processa({ |lEnd| xPrintRel(),OemToAnsi('Gerando o relat๓rio.')}, OemToAnsi('Aguarde...'))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRestaura a area anterior ao processamento. !ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RestArea(aAreaZA1)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xPrintRelบAutor ณCristian Verneque    บ Data ณ  05/01/07   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprimir os chamados de acordo com os parametros           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xPrintRel()
Private	oPrint		:= TMSPrinter():New(OemToAnsi('Chamados de Suporte')),;
oBrush		:= TBrush():New(,4),;
oPen		:= TPen():New(0,5,CLR_BLACK),;
cFileLogo	:= GetSrvProfString('Startpath','') + 'LOGOCSU' + '.BMP',;
oFont07		:= TFont():New('Courier New',07,07,,.F.,,,,.T.,.F.),;
oFont08		:= TFont():New('Courier New',08,08,,.F.,,,,.T.,.F.),;
oFont09		:= TFont():New('Tahoma',09,09,,.F.,,,,.T.,.F.),;
oFont10		:= TFont():New('Tahoma',10,10,,.F.,,,,.T.,.F.),;
oFont10n	:= TFont():New('Courier New',10,10,,.T.,,,,.T.,.F.),;
oFont11		:= TFont():New('Tahoma',11,11,,.F.,,,,.T.,.F.),;
oFont12		:= TFont():New('Tahoma',12,12,,.T.,,,,.T.,.F.),;
oFont12n	:= TFont():New('Tahoma',12,12,,.F.,,,,.T.,.F.),;
oFont13		:= TFont():New('Tahoma',13,13,,.T.,,,,.T.,.F.),;
oFont14		:= TFont():New('Tahoma',14,14,,.T.,,,,.T.,.F.),;
oFont15		:= TFont():New('Courier New',15,15,,.T.,,,,.T.,.F.),;
oFont18		:= TFont():New('Arial',18,18,,.T.,,,,.T.,.T.),;
oFont16		:= TFont():New('Arial',16,16,,.T.,,,,.T.,.F.),;
oFont20		:= TFont():New('Arial',20,20,,.F.,,,,.T.,.F.),;
oFont22		:= TFont():New('Arial',22,22,,.T.,,,,.T.,.F.)

Private	nLinha	:= 3000	// Controla a linha por extenso
Private nColD01 := 0100 // coluna 01 do detalhe do chamado
Private nColD02 := 0350 //0430 // coluna 02 do detalhe do chamado
Private nColD03 := 1200 // coluna 03 do detalhe do chamado
Private nColD04 := 1430 //1530 // coluna 04 do detalhe do chamado
Private lFirst  := .t.  // garante que e a primeira pagina ... assim nao imprime folhas desnecessarias

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefine que a impressao deve ser RETRATOณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPrint:SetPortrait()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta query !ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู

_cQuery := "SELECT ZA1.R_E_C_N_O_ [ZA1REC]"+Chr(13)
_cQuery += "FROM "+RetSqlName('ZA1') + " ZA1"+Chr(13)
_cQuery += "WHERE ZA1.D_E_L_E_T_ <> '*' "+Chr(13)
_cQuery += "AND ZA1.ZA1_IDENT BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"'"+Chr(13)
_cQuery += "AND ZA1.ZA1_MODULO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"+Chr(13)
_cQuery += "AND ZA1.ZA1_USER BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"+Chr(13)
_cQuery += "AND ZA1.ZA1_CODTEC BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'"+Chr(13)
_cQuery += "AND ZA1.ZA1_STATUS BETWEEN '"+cStatusIni+"' AND '"+cStatusfIN+"'"+Chr(13)
_cQuery += "ORDER BY ZA1.ZA1_IDENT"+Chr(13)

MemoWrite( "c:\cspmsr01.sql", _cQuery )
//_cQuery := ChangeQuery(_cQuery)

If Select('PMSR01') <> 0
	dbSelectArea("PMSR01")
	TRBR02->(DbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery),"PMSR01", .F., .T.)

While PMSR01->( ! Eof() )
	dbSelectArea("ZA1")
	ZA1->(dbGoTo(PMSR01->ZA1REC))
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPosiciona nos arquivos necessarios. !ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_cClassOcor := Posicione("ZA3", 1, xFilial("ZA3")+ZA1->ZA1_CLASS, "ZA3_DESC" )
	_cArea      := Posicione("ZA2", 1, xFilial("ZA2")+ZA1->ZA1_SISTEM, "ZA2_DESC" )
	_cModul     := Posicione("ZA4", 1, xFilial("ZA4")+ZA1->ZA1_MODULO, "ZA4_DESC" )
	
	xVerPag()
	
	oPrint:Say(0230,nColD01,OemToAnsi('Chamado:'),oFont10)
	oPrint:Say(0220,nColD02,AllTrim(ZA1->ZA1_IDENT),oFont13)
	oPrint:Say(0280,nColD01,OemToAnsi('Titulo:'),oFont10)
	oPrint:Say(0280,nColD02,ZA1->ZA1_DESREM,oFont11)
	oPrint:Say(0330,nColD01,OemToAnsi('Solicitante:'),oFont10)
	oPrint:Say(0330,nColD02,AllTrim(ZA1->ZA1_CODUSE),oFont11)
	//	oPrint:Say(0630,nColD03,OemToAnsi('Nome:'),oFont10)
	oPrint:Say(0330,nColD03,AllTrim(ZA1->ZA1_NOME),oFont11)
	oPrint:Say(0380,nColD01,OemToAnsi('Class Ocorr:'),oFont10)
	oPrint:Say(0380,nColD02,AllTrim(ZA1->ZA1_CLASS),oFont11)
	oPrint:Say(0380,nColD03,AllTrim(_cClassOcor),oFont11)
	oPrint:Say(0430,nColD01,OemToAnsi('Area:'),oFont10)
	oPrint:Say(0430,nColD02,AllTrim(ZA1->ZA1_SISTEM),oFont11)
	oPrint:Say(0430,nColD03,AllTrim(_cArea),oFont11)
	oPrint:Say(0480,nColD01,OemToAnsi('Modulo:'),oFont10)
	oPrint:Say(0480,nColD02,AllTrim(ZA1->ZA1_MODULO),oFont11)
	oPrint:Say(0480,nColD03,AllTrim(_cModul),oFont11)
	oPrint:Line(0530,100,0530,2300)
	
	nLinha := 580
	oPrint:Say(nLinha,nColD01,OemToAnsi('Ocorrencia:'),oFont10)
	//Imprimir a ocorrencia
	_cLinha  := Alltrim(ZA1->ZA1_OCOR)
	_nLinhas := mlcount(_cLinha,85)
	for _nVezLinha:=1 to _nLinhas
		oPrint:Say(nLinha,nColD02,memoline(_cLinha,85,_nVezLinha,,.T.),oFont11)
		nLinha += 60
		xVerPag()
	next
	
	//	nLinha += 60
	xVerPag()
	// Imprimindo data da abertura do chamado + hora
	oPrint:Say(nLinha,nColD01,OemToAnsi('Abertura:'),oFont10)
	oPrint:Say(nLinha,nColD02,DtoC(ZA1->ZA1_DATAI),oFont11)
	oPrint:Say(nLinha,nColD03,OemToAnsi('Hora:'),oFont10)
	oPrint:Say(nLinha,nColD04,AllTrim(ZA1->ZA1_HORAI),oFont11)
	nLinha += 60
	oPrint:Line(nLinha,100,nLinha,2300)
	
	nLinha += 60
	xVerPag()
	
	oPrint:Say(nLinha,nColD01,OemToAnsi('Solucao:'),oFont10)
	//Imprimir a ocorrencia
	_cLinha  := Alltrim(ZA1->ZA1_SOLUC)
	_nLinhas := mlcount(_cLinha,85)
	for _nVezLinha:=1 to _nLinhas
		oPrint:Say(nLinha,nColD02,memoline(_cLinha,85,_nVezLinha,,.T.),oFont11)
		nLinha += 60
		xVerPag()
	next
	
	nLinha += 60
	xVerPag()
	// Imprimindo atendente
	oPrint:Say(nLinha,nColD01,OemToAnsi('Cod Atenden.:'),oFont10)
	oPrint:Say(nLinha,nColD02,ZA1->ZA1_CODTEC,oFont11)
	oPrint:Say(nLinha,nColD03,OemToAnsi('Atendente:'),oFont10)
	oPrint:Say(nLinha,nColD04,AllTrim(ZA1->ZA1_TECNIC),oFont16)
	
	nLinha += 60
	xVerPag()
	// Imprimindo data do atendimento + hora
	oPrint:Say(nLinha,nColD01,OemToAnsi('Atendimento:'),oFont10)
	oPrint:Say(nLinha,nColD02,DtoC(ZA1->ZA1_DATAI),oFont11)
	oPrint:Say(nLinha,nColD03,OemToAnsi('HR Atend.:'),oFont10)
	oPrint:Say(nLinha,nColD04,AllTrim(ZA1->ZA1_HORAI),oFont11)
	
	nLinha += 60
	xVerPag()
	// Imprimindo data do atendimento + hora
	oPrint:Say(nLinha,nColD01,OemToAnsi('Encerramento:'),oFont10)
	oPrint:Say(nLinha,nColD02,DtoC(ZA1->ZA1_DATAF),oFont11)
	oPrint:Say(nLinha,nColD03,OemToAnsi('HR Encer.:'),oFont10)
	oPrint:Say(nLinha,nColD04,AllTrim(ZA1->ZA1_HORAF),oFont11)
	
	IncProc()
	PMSR01->(DbSkip())
	nLinha		:= 3000	// Controla a linha por extenso
	
End

//xVerPag()

PMSR01->(DbCloseArea())

xRodape()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime em Video, e finaliza a impressao. !ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPrint:Preview()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xCabec() บAutor ณLuis Henrique Robustoบ Data ณ  25/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime o Cabecalho do relatorio...                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xCabec()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime o cabecalho da empresa. !ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPrint:SayBitmap(050,100,cFileLogo,1050,260)
oPrint:Say(050,900,AllTrim(Upper(SM0->M0_NOMECOM)),oFont16)
//oPrint:Say(135,1300,AllTrim(SM0->M0_ENDCOB),oFont11)
//oPrint:Say(180,1300,Capital(AllTrim(SM0->M0_CIDCOB))+'/'+AllTrim(SM0->M0_ESTCOB)+ '  -  ' + AllTrim(TransForm(SM0->M0_CEPCOB,'@R 99.999-999')) + '  -  ' + AllTrim(SM0->M0_TEL),oFont11)
//oPrint:Say(225,1300,AllTrim('www.csu.com.br'),oFont11)
//oPrint:Line(285,1300,285,2270)
//oPrint:Say(300,1300,TransForm(SM0->M0_CGC,'@R 99.999.999/9999-99'),oFont12)
//oPrint:Say(300,1850,SM0->M0_INSC,oFont12)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTitulo do Relatorioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPrint:Say(0135,0600,OemToAnsi('Chamado de Suporte: '+ZA1->ZA1_IDENT),oFont22)
oPrint:Line(0215,nColD01,0215,2270)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xRodape()บAutor ณLuis Henrique Robustoบ Data ณ  25/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime o Rodape do Relatorio....                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xRodape()
Local _cDescStatus := 'Indefinido'

oPrint:Line(3100,nColD01,3100,2300)
do Case
	Case ZA1->ZA1_STATUS == '1' // em Aberto
		_cDescStatus := 'em Aberto'
		
	Case ZA1->ZA1_STATUS == '2' // em Atendimento
		_cDescStatus := 'em Atendimento'
		
	Case ZA1->ZA1_STATUS == '3' // Cancelado
		_cDescStatus := 'Cancelado'
		
	Case ZA1->ZA1_STATUS == '4' // Encerrado
		_cDescStatus := 'Encerrado'
		
	Case ZA1->ZA1_STATUS == '5' // Encerrado
		_cDescStatus := 'Transferido para PMS'
		
EndCase
oPrint:Say(3120,1050,"Status: "+AllTrim(_cDescStatus),oFont16)
oPrint:Line(3200,nColD01,3200,2300)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xVerPag()บAutor ณCristian Verneque    บ Data ณ  05/01/07   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se deve ou nao saltar pagina...                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xVerPag()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณInicia a montagem da impressao.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If	( nLinha >= 3000 )
	
	If !lFirst
		xRodape()
		oPrint:EndPage()
	EndIf
	nLinha:= 600
	
	oPrint:StartPage()
	xCabec()
	lFirst  := .f. // desligando o semaforo
	
EndIf


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CriaSx1  บ Autor ณ Cristian Verneque  บ Data ณ  03/01/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Cria as perguntas no SX1 caso nao existam.                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico - CSU                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function CriaSx1()
Local nX := 0
Local nY := 0
Local aAreaAnt := GetArea()
Local aAreaSX1 := SX1->(GetArea())
Local aReg := {}

aAdd(aReg,{cPerg,"01","Status do Chamado de: ","mv_ch1","N", 1,0,0,"C","","mv_par01","Aberto","","","em Atendimento","","","Cancelado","","","Encerrado","","","Trf PMS","",""})
aAdd(aReg,{cPerg,"02","Status do Chamado de: ","mv_ch2","N", 1,0,0,"C","","mv_par02","Aberto","","","em Atendimento","","","Cancelado","","","Encerrado","","","Trf PMS","",""})
aAdd(aReg,{cPerg,"03","M๓dulos de:      	 ","mv_ch3","C", 3,0,0,"G","","mv_par03","","","","","","","","","","","","","","","ZA4USR"})
aAdd(aReg,{cPerg,"04","M๓dulos ate:          ","mv_ch4","C", 3,0,0,"G","","mv_par04","","","","","","","","","","","","","","","ZA4USR"})
aAdd(aReg,{cPerg,"05","Solicitante de:       ","mv_ch5","C", 6,0,0,"G","","mv_par05","","","","","","","","","","","","","","","US1"})
aAdd(aReg,{cPerg,"06","Solicitante ate:      ","mv_ch6","C", 6,0,0,"G","","mv_par06","","","","","","","","","","","","","","","US1"})
aAdd(aReg,{cPerg,"07","Atendente de:         ","mv_ch7","C", 6,0,0,"G","","mv_par07","","","","","","","","","","","","","","","US1"})
aAdd(aReg,{cPerg,"08","Atendente ate:        ","mv_ch8","C", 6,0,0,"G","","mv_par08","","","","","","","","","","","","","","","US1"})
aAdd(aReg,{cPerg,"09","Chamado de:           ","mv_ch9","C",12,0,0,"G","","mv_par09","","","","","","","","","","","","","","","ZA1"})
aAdd(aReg,{cPerg,"10","Chamado Ate:          ","mv_chA","C",12,0,0,"G","","mv_par10","","","","","","","","","","","","","","","ZA1"})
aAdd(aReg,{"X1_GRUPO","X1_ORDEM","X1_PERGUNT","X1_VARIAVL","X1_TIPO","X1_TAMANHO","X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID","X1_VAR01","X1_DEF01","X1_CNT01","X1_VAR02","X1_DEF02","X1_CNT02","X1_VAR03","X1_DEF03","X1_CNT03","X1_VAR04","X1_DEF04","X1_CNT04","X1_VAR05","X1_DEF05","X1_CNT05","X1_F3"})

dbSelectArea("SX1")
dbSetOrder(1)
For ny:=1 to Len(aReg)-1
	If !dbSeek(aReg[ny,1]+aReg[ny,2])
		RecLock("SX1",.T.)
		For j:=1 to Len(aReg[ny])
			FieldPut(FieldPos(aReg[Len(aReg)][j]),aReg[ny,j])
		Next j
		MsUnlock()
	EndIf
Next ny
RestArea(aAreaSX1)
RestArea(aAreaAnt)
Return Nil

