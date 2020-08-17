#Include 'Rwmake.ch'
#Include 'TopConn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRcomm97   บAutor  ณ Sergio Oliveira    บ Data ณ  Mar/2009   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de rotinas customizadas atraves dos menus.       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function Rcomm97()

Private cEol     := Chr(13)+Chr(10)
Private cCadastro   := "Elimina็ใo Especial de Resํduos"
Private aRegs := {}, aSays := {}, aButtons := {}
Private cPerg       := PADR("RCom97",LEN(SX1->X1_GRUPO))
Private cFuncao     := " Processa( { || Rcomm97a() }, 'Processando Parametriza็ใo...' ) "
Private lSair       := .f.
Private lMT235G1	:= ExistBlock("MT235G1",.F.,.F.)

aAdd(aRegs,{cPerg,"01","Status dos Pedidos....:","","","mv_ch1","N",01,0,0,"C","","mv_par01","Aprovados","","","","","NAO Aprovados","","","","","Nao Especificar","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Selecionar Periodo....:","","","mv_ch2","N",01,0,0,"C","","mv_par02","Dias","","","","","Meses","","","","","Anos","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Numero de Periodos....:","","","mv_ch3","N",05,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","@E 9,999",""})
aAdd(aRegs,{cPerg,"04","Data para Referencia..:","","","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Definir Per. Emissao..:","","","mv_ch5","N",01,0,0,"C","","mv_par05","Nao","","","","","DEFINIR","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Periodo de Emis.Inicio:","","","mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Periodo de Emis.Fim...:","","","mv_ch7","D",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"08","Intervalo de PC inicio:","","","mv_ch8","C",06,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"09","Intervalo de PC final.:","","","mv_ch9","C",06,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"10","(%) Eliminacao........:","","","mv_cha","N",05,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","","","","","@E 9,999",""})

U_ValidPerg( cPerg, aRegs )

If SX1->( DbSetOrder(1), DbSeek(PadR(cPerg,Len(SX1->X1_GRUPO))+'04') )
	SX1->( RecLock('SX1',.f.) )
	SX1->X1_CNT01 := Dtoc( Date() )
	SX1->( MsUnLock() )
EndIf

aHelpP01 := { "Informe a situacao dos Pedidos para pro","cessar o Filtro" } // Portuga
//                     10        20        30        40          10        20        30        40        10        20        30        40           10        20        30        40
//             123456789.123456789.123456789.123456789.  123456789.123456789.123456789.123456789.  123456789.123456789.123456789.123456789. 123456789.123456789.123456789.123456789.
aHelpP02 := { "Se desejar selecionar Perํodos, escolha"," UMA DAS TRสS PRIMEIRAS op็๕es combinad","as com a pergunta abaixo." } // Portuga
aHelpP03 := { "Informe o numero de Periodos de acordo" ," com a regra estabelecida no parametro" ," anterior. Este parametro somente tera"," efeito caso o anterior seja diferente"," de Nao Especificar" } // Portuga
aHelpP04 := { "Informe aqui a data para refer๊ncia p/" ," o ponto de partida caso desejar sele-" ,"cionar perํodos." } // Portuga
aHelpP05 := { "Se desejar informar o periodo de emiss" ," ao dos Pedidos e nao utilizar perio- " ,'dos, escolha a op็ใo "DEFINIR".' } // Portuga
aHelpP06 := { "Informe a data de emissao inicial dos " ," Pedidos de Compras" } // Portuga
aHelpP07 := { "Informe a data de emissao final dos "   ," Pedidos de Compras" } // Portuga
aHelpP08 := { "Informe o intervalo de Pedidos inici"   ,"al desejado.       " } // Portuga
aHelpP09 := { "Informe o intervalo de Pedidos final"   ,"desejado.          " } // Portuga
aHelpP10 := { "(%) Maximo de eliminacao de residuos  " ,"de acordo com o funcionamento da rotin" , "a padrใo de elimina็ใo." } // Portuga

For wXP := 1 To Len( aRegs )
	PutHelp("P."+cPerg+StrZero(wXP,2)+".",&("aHelpP"+StrZero(wXP,2)),{},{},.T.)
Next

Pergunte(cPerg,.f.)

Define MsDialog _MkwDlg Title cCadastro From 298,302 To 500,721 Of oMainWnd Pixel
@ 002,003 To 100,165
@ 012,170 To 087,203
@ 035,015 Say "Esta eliminara os resํduos de pedidos de compras nao uti-" Size 141,8
@ 045,015 Say "zados em Notas Fiscais de acordo com os parametros."       Size 142,8
@ 020,173 Button "_Parametros" Size 28,16 Action( Pergunte(cPerg,.t.) )
@ 042,173 Button "_Gerar"      Size 28,16 Action( &( cFuncao ) )
@ 064,173 Button "_Sair"       Size 28,16 Action( lSair := .t., _MkwDlg:End() )

Activate Dialog _Mkwdlg Centered Valid lSair

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ Rcomm97a บAutor  ณ Sergio Oliveira    บ Data ณ  Mar/2009   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Processamento da rotina.                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rcomm97.prw                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Rcomm97a()

Local cMens    := "Eliminacao de Residuos"
Local cPriLin  := "Se deseja realmente efetuar esta opera็ใo, "
Local cTxtMsg  := ""
Local cTxtAlrt := "Nใo hแ dados a serem exibidos dentro dos parโmetros escolhidos:"+cEol+cEol
Private dDtRef
If MV_PAR02 == 1     // Dias
	dDtRef := MV_PAR04 - MV_PAR03
ElseIf MV_PAR02 == 2 // Meses
	dDtRef := MV_PAR04 - ( MV_PAR03 * 30 )
Else                 // Anos
	dDtRef := MV_PAR04 - ( MV_PAR03 * 365 )
EndIf
Private cQuery   := ""
Private nCntView := 0, nPerc := MV_PAR10
Private cTxtMsg  += "Status dos Pedidos: "+IIf( MV_PAR01 == 3, "Sem Especificacao",IIF( MV_PAR01 == 1,"Aprovados","NAO Aprovados" ) )+cEol

If MV_PAR05 == 1 // Nใo Definir Periodos
	cTxtMsg += "Tipo de Periodo: "+IIf( MV_PAR02 == 3, "Anos",IIF( MV_PAR02 == 1,"Dias","Meses" ) )+cEol
	cTxtMsg += "Numero de Periodos: "+Transform(MV_PAR03, "@E 9,999" )+cEol
	cTxtMsg += "Pedidos Emitidos At้ a Data de : "+Dtoc(dDtRef)+cEol
	cTxtMsg += "Caso estes Pedidos nใo tenham Notas Fiscais Digitadas Entre: "+Dtoc(dDtRef)+" - "+Dtoc(MV_PAR04)+cEol
Else
	cTxtMsg += "Pedidos Emitidos Entre: "+Dtoc(MV_PAR06)+" - "+Dtoc(MV_PAR07)+"."+cEol
EndIf
cTxtMsg += "(%) Eliminacao: "+Transform(MV_PAR10, "@E 9,999" )+" - Conforme o funcionamento da rotina de elmina็ใo de resํduos padrใo. "+cEol

If Aviso("Dados para Confirmacao",cTxtMsg,;
	{"&Desistir","Confirmar"},3,"Verificacao dos Parametros",,;
	"PCOLOCK") == 1
	MsgBox('Operacao nao Confirmada','Sem Confirmacao','Info')
	Return
EndIf

Processa( { || MontaQuery() }, "Executando o Filtro..." )

Work->( DbGoTop() )

If Work->REGS == 0
	Aviso("Sem Dados",cTxtAlrt+cTxtMsg,;
	{"&Fechar"},3,"Vazio",,;
	"PCOLOCK")
	Return
EndIf

Processa( { || Rcomm97b() }, "Listando Pedidos para Conferencia..." )

cTxtMsg := "Os pedidos listados no relatorio serao eliminados por residuo. Deseja Prosseguir?"
If Aviso("Confirmacao do Processo",cTxtMsg,;
	{"&Desistir","Confirmar"},3,"Dados Verificados",,;
	"PCOLOCK") == 2
	If !U_CodSegur(cMens, cPriLin)
		Aviso(cMens,"Opera็ใo nao Confirmada",{"&Fechar"},3,"Nao Confirmado",,"PCOLOCK")
		Return
	EndIf
Else
	Return
EndIf

Processa( { || Rcomm97d() }, "Eliminando residuos dos Pedidos Conferidos" )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ Rcomm97b บAutor  ณ Sergio Oliveira    บ Data ณ  Mar/2009   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Exibe a listagem dos pedidos para verificacao.             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rcomm97.prw                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Rcomm97b()

Local   Titulo      := "RELATORIO DE CONFERENCIA"
Local   cDesc1      := "Este programa tem como objetivo imprimir relatorio "
Local   cDesc2      := "de acordo com os parametros informados pelo usuario."
Local   cDesc3      := ""
Local   cPict       := ""
Private aOrd        := ""
Private Tamanho     := "G"  // P - 80, M - 132, G - 220
Private Limite      := 220
Private wNrel       := "RCOMM97"
Private cPerg       := PADR("RCOMM97",LEN(SX1->X1_GRUPO))
Private cString     := ""
Private nLastKey    := 00
Private nTipo       := 18
Private nLin        := 80
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private Imprime     := .T.
Private lEnd        := .F.
Private lAbortPrint := .F.
Private cbtxt       := Space(10)
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private Cabec1      := PADC("EMPRESA: "+SM0->M0_CODIGO+" - "+ALLTRIM(SM0->M0_NOME)+" - FILIAL: "+SM0->M0_CODFIL+" - "+ALLTRIM(SM0->M0_FILIAL)+" -> "+GetEnvServer(),Limite)
Private Cabec2      := "Pedido | Emissao  | Fornecedor                      | Condicao        |    Produto    |          Descricao             | Total do PC  |Total Utilizado|Total do Residuo|   Status     | Dt.Ult.NF |  Nr.Ult.NF   |"

wNrel := SetPrint(cString,wNrel,'',@titulo,cDesc1,cDesc2,cDesc3,.F., aOrd ,.T. ,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

Processa( { || Rcomm97c(Titulo) },Titulo )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ Rcomm97c บAutor  ณSergio Oliveira     บ Data ณ  Mar/2009   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressao do relatorio.                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rcomm97.prw                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Rcomm97c(Titulo)

Local nLines
Local nLineSize := 50, nTabSize := 2
Local lWrap     := .t., lImpr := .f.
Local cEol      := Chr(13)+Chr(10)
Local aImprs    := {}, aTotGer := {0,0,0}

/*
Pedido | Emissao  | Fornecedor                      | Condicao        |    Produto    |          Descricao             | Total do PC  |Total Utilizado|Total do Residuo|   Status     | Dt.Ult.NF |  Nr.Ult.NF   |
999999  99/99/999  000000/00 - xxxxxxxx 20 xxxxxxxx  000 - XXX 10 XXX  XXXXXXXXXXXXXXX  xxxxxxxxxxxx 30 xxxxxxxxxxxxxx  999,999,999.99  999,999,999.99   999,999,999.99 xxxxxxxxxxxxxx  99/99/9999  999999/999
|        |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |
123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.
10        20        30        40        50        60        70        80        90       100       110       120       130       140       150       160       170       180       190       200       210
*/
ProcRegua( nCntView )

Work->( DbGoTop() )

While !Work->( Eof() )
	
	IncProc("Imprimindo relatorio...")
	
	If nLin > 58
		nLin := Cabec(Titulo,Cabec1,Cabec2,wNrel,Tamanho,nTipo)
		nLin++
	Endif
	
	SC7->( DbGoTo( Work->REGS ) )
	
	aTotPed := CalcPed()
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Calcular o Residuo maximo da Compra.                         ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nRes := (SC7->C7_QUANT * nPerc) / 100
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica se o Pedido deve ser Encerrado.                     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If (SC7->C7_QUANT - SC7->C7_QUJE <= nRes .And. SC7->C7_QUANT > SC7->C7_QUJE)
		
		/*
		Pedido | Emissao  | Fornecedor                      | Condicao        |    Produto    |          Descricao             | Total do PC  |Total Utilizado|Total do Residuo|   Status     | Dt.Ult.NF |  Nr.Ult.NF   |
		999999  99/99/999  000000/00 - xxxxxxxx 20 xxxxxxxx  000 - XXX 10 XXX  XXXXXXXXXXXXXXX  xxxxxxxxxxxx 30 xxxxxxxxxxxxxx  999,999,999.99  999,999,999.99   999,999,999.99 xxxxxxxxxxxxxx  99/99/9999  99-999999/999
		|        |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |
		123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.
		10        20        30        40        50        60        70        80        90       100       110       120       130       140       150       160       170       180       190       200       210
		*/
		If Ascan( aImprs, SC7->C7_NUM ) == 0
			nLin ++
			Aadd( aImprs, SC7->C7_NUM )
			@ nLin,001 Psay SC7->C7_NUM
			@ nLin,009 Psay SC7->C7_EMISSAO
			@ nLin,020 Psay SC7->(C7_FORNECE+"/"+C7_LOJA)+" - "
			@ nLin,032 Psay Left( Posicione( "SA2",1,xFilial('SA2')+SC7->(C7_FORNECE+C7_LOJA),"A2_NOME" ),20 )
			@ nLin,054 Psay SC7->C7_COND+" - "
			@ nLin,060 Psay Left( Posicione( "SE4",1,xFilial('SE4')+SC7->C7_COND,"E4_DESCRI" ),10 )
			lImpr := .t.
		Else
			lImpr := .f.
		EndIf
		@ nLin,072 Psay SC7->C7_PRODUTO
		@ nLin,089 Psay Left(SC7->C7_DESCRI, 30)
		If lImpr
			aTotGer[1] += aTotPed[1]
			aTotGer[2] += aTotPed[2]
			aTotGer[3] += ( aTotPed[1] - aTotPed[2] )
			@ nLin,121 Psay Transform( aTotPed[1], "@E 999,999,999.99" )
			@ nLin,137 Psay Transform( aTotPed[2], "@E 999,999,999.99" )
			@ nLin,154 Psay Transform( aTotPed[1] - aTotPed[2], "@E 999,999,999.99" )
			@ nLin,169 Psay BuscaStat()
			aBscNFE := BscNFE(SC7->C7_NUM)
			@ nLin,185 Psay aBscNFE[1]  // Dt. Ult NF
			@ nLin,197 Psay aBscNFE[2]  // Filial+Nro+Serie Ult NF
		EndIf
		
		nLin++
		
	EndIf
	
	Work->( DbSkip() )
	
Enddo

If nLin >= 57
	nLin := Cabec(Titulo,Cabec1,Cabec2,wNrel,Tamanho,nTipo)
	nLin++
EndIf
nLin++
@ nLin, 001 Psay __PrtThinLine()
nLin++
@ nLin,001 Psay "TOTAL GERAL --> "
@ nLin,134 Psay Transform( aTotGer[1], "@E 999,999,999.99" )
@ nLin,152 Psay Transform( aTotGer[2], "@E 999,999,999.99" )
@ nLin,171 Psay Transform( aTotGer[3], "@E 999,999,999.99" )
nLin++
@ nLin, 001 Psay __PrtThinLine()

Set Device To Screen

If aReturn[5]==1
	DBCommitAll()
	Set Printer To
	OurSpool(wNrel)
Endif

Ms_Flush()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ Rcomm97d บAutor  ณ Sergio Oliveira    บ Data ณ  Mar/2009   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Processa a eliminacao dos residuos.                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rcomm97.prw                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Rcomm97d()

If SX1->( DbSeek(PadR('MTA235',Len(SX1->X1_GRUPO))+'16') )
	_nValAnt := SX1->X1_PRESEL
	SX1->( RecLock('SX1',.f.) )
	SX1->X1_PRESEL := 2    // CTB?   1 = Sim / 2 = Nao
	SX1->( MsUnLock() )
EndIf

If SX1->( DbSeek(PadR('MTA235',Len(SX1->X1_GRUPO))+'17') )
	_nValAnt := SX1->X1_PRESEL
	SX1->( RecLock('SX1',.f.) )
	SX1->X1_PRESEL := 2    // Mostra CTB?   1 = Sim / 2 = Nao
	SX1->( MsUnLock() )
EndIf

Pergunte("MTA235",.f.)
MV_PAR16 := 2
MV_PAR17 := 2

ProcRegua( nCntView )

Work->( DbGoTop() )

While !Work->( Eof() )
	
	IncProc("Eliminando Residuos...")
	
	SC7->( DbGoTo( Work->REGS ) )
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Calcular o Residuo maximo da Compra.                         ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nRes := (SC7->C7_QUANT * nPerc) / 100
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica se o Pedido deve ser Encerrado.                     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If (SC7->C7_QUANT - SC7->C7_QUJE <= nRes .And. SC7->C7_QUANT > SC7->C7_QUJE)
		MA235PC(100, 1, SC7->C7_EMISSAO, SC7->C7_EMISSAO, SC7->C7_NUM, SC7->C7_NUM, SC7->C7_PRODUTO, SC7->C7_PRODUTO, SC7->C7_FORNECE, SC7->C7_FORNECE, SC7->C7_DATPRF, SC7->C7_DATPRF, SC7->C7_ITEM, SC7->C7_ITEM)
	EndIf
	
	Work->( DbSkip() )
	
EndDo

Work->( DbCloseArea() )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณMontaQueryบAutor  ณ Sergio Oliveira    บ Data ณ  Mar/2009   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Executa a Query.                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rcomm97.prw                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MontaQuery()

/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณ Montar a query de acordo com o periodo especificado:  ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/

cQuery += " SELECT R_E_C_N_O_ AS REGS "+cEol
cQuery += " FROM "+RetSqlName('SC7')+cEol
cQuery += " WHERE C7_FILIAL  = '"+xFilial('SC7')+"' "+cEol
If MV_PAR05 == 1 // NAO Definir periodos de EMISSAO
	cQuery += " AND   C7_EMISSAO <= '"+Dtos(dDtRef)+"' "
Else             // DEFINIR periodos de EMISSAO
	cQuery += " AND   C7_EMISSAO BETWEEN '"+Dtos(MV_PAR06)+"' AND '"+Dtos(MV_PAR07)+"' "+cEol
	cQuery += " AND   C7_NUM     BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"' "+cEol
EndIf
cQuery += " AND   C7_QUANT   > C7_QUJE "+cEol
cQuery += " AND   C7_RESIDUO = ' ' "+cEol
If MV_PAR01 == 1     // Aprovados
	cQuery += " AND C7_CONAPRO = 'L' "+cEol
ElseIf MV_PAR01 == 2 // NAO Aprovados
	cQuery += " AND C7_CONAPRO = 'B' "+cEol
EndIf
cQuery += " AND   D_E_L_E_T_ = ' ' "+cEol
If MV_PAR05 == 1 // NAO DEFINIR periodos de EMISSAO - Montagem automatica dos periodos (DD/MM/AAAA)
	cQuery += " AND   C7_NUM NOT IN( SELECT DISTINCT D1_PEDIDO "+cEol
	cQuery += "                      FROM "+RetSqlName('SD1')+cEol
	cQuery += "                      WHERE D1_FILIAL  BETWEEN '00' AND 'ZZ' "+cEol
	cQuery += "                      AND   D1_DTDIGIT BETWEEN '"+Dtos(dDtRef)+"' AND '"+Dtos(MV_PAR04)+"' "+cEol
	cQuery += "                      AND   D_E_L_E_T_ = ' ' ) "+cEol
EndIf
/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณ Os pedidos que possuirem PAs em Aberto nao deverao ser eliminados. ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
cQuery += " AND   C7_NUM NOT IN( SELECT DISTINCT E2_NUMPC "+cEol
cQuery += "                      FROM "+RetSqlName('SE2')+cEol
cQuery += "                      WHERE E2_FILIAL BETWEEN '  ' AND 'ZZ' "+cEol
cQuery += "                      AND   E2_TIPO  = 'PA' "+cEol
cQuery += "                      AND   E2_SALDO > 0 "+cEol
cQuery += "                      AND   E2_NUM  BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"' "+cEol
cQuery += "                      AND   D_E_L_E_T_ = ' ' ) "+cEol
cQuery += " ORDER BY C7_EMISSAO DESC "

nCntView := U_MontaView( cQuery, 'Work' )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ CalcPed  บAutor  ณ Sergio Oliveira    บ Data ณ  Mar/2009   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Obtem o total do pedido de compras posicionado.            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rcomm97.prw                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CalcPed()

Local cQryPC := ''

cQryPC += " SELECT SUM(C7_QUANT*C7_PRECO) AS TOTPED, "
cQryPC += " SUM(C7_QUJE*C7_PRECO) AS TOTENT "
cQryPC += " FROM "+RetSqlName('SC7')
cQryPC += " WHERE C7_FILIAL  = '"+xFilial('SC7')+"' "
cQryPC += " AND   C7_NUM     = '"+SC7->C7_NUM+"'
cQryPC += " AND   D_E_L_E_T_ = ' '

U_MontaView( cQryPC, 'TotalPed' )

TotalPed->( DbGoTop() )

Return( { TotalPed->TOTPED, TotalPed->TOTENT } )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณBuscaStat บAutor  ณ Sergio Oliveira    บ Data ณ  Mar/2009   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Obtem o status atual do pedido.                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rcomm97.prw                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function BuscaStat()

Local lBloq
Local cQryPC := '', cDescStat := ''

cQryPC += " SELECT AGUARD_APROV.QTOS AS AGUARDANDO, APROVADOS.QTOS AS APROVADOSS, BLOQUEADOS.QTOS AS BLOQUEADOS "
cQryPC += " FROM "
cQryPC += "  ( SELECT COUNT(*) AS QTOS "
cQryPC += "        FROM "+RetSqlName('SCR')
cQryPC += "        WHERE CR_FILIAL = '"+xFilial('SCR')+"' "
cQryPC += "        AND   CR_TIPO   = 'PC' "
cQryPC += "        AND   CR_NUM    = '"+SC7->C7_NUM+"' "
cQryPC += "        AND   CR_STATUS IN('01','02') "
cQryPC += "        AND   D_E_L_E_T_ = ' ' ) AS AGUARD_APROV, "
cQryPC += "  ( SELECT COUNT(*) AS QTOS "
cQryPC += "        FROM "+RetSqlName('SCR')
cQryPC += "        WHERE CR_FILIAL = '"+xFilial('SCR')+"' "
cQryPC += "        AND   CR_TIPO   = 'PC' "
cQryPC += "        AND   CR_NUM    = '"+SC7->C7_NUM+"' "
cQryPC += "        AND   CR_STATUS IN('03','05') "
cQryPC += "        AND   D_E_L_E_T_ = ' ' ) AS APROVADOS, "
cQryPC += "  ( SELECT COUNT(*) AS QTOS "
cQryPC += "        FROM "+RetSqlName('SCR')
cQryPC += "        WHERE CR_FILIAL = '"+xFilial('SCR')+"' "
cQryPC += "        AND   CR_TIPO   = 'PC' "
cQryPC += "        AND   CR_NUM    = '"+SC7->C7_NUM+"' "
cQryPC += "        AND   CR_STATUS IN('04') "
cQryPC += "        AND   D_E_L_E_T_ = ' ' ) AS BLOQUEADOS "

U_MontaView( cQryPC, 'StatPed' )

StatPed->( DbGoTop() )

lBloq := StatPed->BLOQUEADOS > 0

If lBloq
	cDescStat := "Bloqueado"
Else
	If StatPed->AGUARDANDO == 0
		cDescStat := "Aprovado"
	Else
		cDescStat := "Em Aprova็ใo"
	EndIf
EndIf

Return( cDescStat )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ BscNFE   บAutor  ณ Sergio Oliveira    บ Data ณ  Mai/2009   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Obter os dados da ultima NFE para o Pedido                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rcomm97.prw                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function BscNFE(pcPedido)

Local cBusca
Local aRetNFE := { Ctod(''), "  " }

cBusca := " SELECT NFSDOSPCS.D1_FILIAL, NFSDOSPCS.D1_DOC, NFSDOSPCS.D1_SERIE, NFSDOSPCS.D1_EMISSAO "+cEol
cBusca += " FROM "+RetSqlName('SC7')+", ( SELECT TOP 1 D1_FILIAL, D1_DOC, D1_SERIE, D1_EMISSAO "+cEol
cBusca += "                               FROM "+RetSqlName('SD1')+cEol
cBusca += "                               WHERE D1_PEDIDO  = '"+pcPedido+"' "+cEol
cBusca += "                               AND   D_E_L_E_T_ = ' ' "+cEol
cBusca += "                               ORDER BY D1_EMISSAO DESC ) AS NFSDOSPCS "+cEol
cBusca += " WHERE C7_FILIAL  = '"+xFilial('SC7')+"' "+cEol
cBusca += " AND   C7_NUM     = '"+pcPedido+"' "+cEol
cBusca += " AND   D_E_L_E_T_ = ' ' "+cEol

U_MontaView( cBusca, 'BUSCANFE' )

BUSCANFE->( DbGotop() )

If !Empty( BUSCANFE->D1_FILIAL )
	aRetNFE[1] := Stod( BUSCANFE->D1_EMISSAO )
	aRetNFE[2] := BUSCANFE->D1_FILIAL+"-"+BUSCANFE->D1_DOC+"/"+BUSCANFE->D1_SERIE
	// Filial+Doc+Serie Ult NF
EndIf

Return( aRetNFE )