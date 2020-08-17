#Include 'Rwmake.ch'
#Include 'TopConn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Rcomr07   ºAutor  ³ Sergio Oliveira    º Data ³  Jul/2009   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio de rotinas customizadas atraves dos menus.       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Rcomr07()

Private cEol     := Chr(13)+Chr(10)
Private Titulo      := "Pedidos Pendentes de NF"
Private cDesc1      := "Pedidos Pendentes de NF"
Private cDesc2      := ""
Private cDesc3      := "Pedidos Pendentes de NF"
Private tamanho   := "G"
Private limite    := 220
Private cString   := "SC7"
Private lEnd      := .F.
Private lContinua := .T.
Private aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
Private nomeprog  := "Rcomr06"
Private nLastKey  := 0
Private nomeprog  := "Rcomr07"
Private cPerg     := PADR("RcomR7",LEN(SX1->X1_GRUPO))
Private lAbortPrint := .f.
Private cbtxt   := ""
Private cbcont  := 00
Private nlin    := 80
Private m_pag   := 01
Private aOrd        := {}
Private aRegs     := {}
Private Cabec1      := PADC("EMPRESA: "+SM0->M0_CODIGO+" - "+ALLTRIM(SM0->M0_NOME)+" - FILIAL: "+SM0->M0_CODFIL+" - "+ALLTRIM(SM0->M0_FILIAL)+" -> "+GetEnvServer(),Limite)
Private Cabec2      := "Pedido | Emissao  | Fornecedor                      | Condicao        |    Produto    |          Descricao             | Total do PC  |Total Utilizado|Total do Residuo| Solicitante           | Dt.Ult.NF |   Nr.Ult.NF  |"

AADD(aRegs,{cPerg,"01","Dt. Emissao PC de  :","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Dt. Emissao PC ate :","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Nro. Pedidos De....:","","","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Nro. Pedidos Ate...:","","","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

U_ValidPerg( cPerg, aRegs )

Pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

Processa( { || Rcomr07a(Cabec1,Cabec2,Titulo,nLin) }, Titulo )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ Rcomr07c ºAutor  ³Sergio Oliveira     º Data ³  Jul/2009   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao do relatorio.                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rcomr07.prw                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Rcomr07a(Titulo)

Local nLines
Local nLineSize := 50, nTabSize := 2
Local lWrap     := .t., lImpr := .f.
Local cEol      := Chr(13)+Chr(10)
Local aImprs    := {}, aTotGer := {0,0,0}
Private nCntView := 0
//Private cLog     := 'RCOMR07-'+Dtos(Date())+'-'+StrTran(Time(),":","_")+'.log'
//Private nCot     := FCreate( 'c:\transfer\csu\'+cLog,1 )
//Private cEol     := Chr(13)+Chr(10)

//FWrite( nCot, FunName()+" - Line => "+AllTrim(Str(ProcLine()))+cEol )

/*
Pedido | Emissao  | Fornecedor                      | Condicao        |    Produto    |          Descricao             | Total do PC  |Total Utilizado|Total do Residuo| Solicitante           | Dt.Ult.NF |   Nr.Ult.NF  |
999999  99/99/999  000000/00 - xxxxxxxx 20 xxxxxxxx  000 - XXX 10 XXX  XXXXXXXXXXXXXXX  xxxxxxxxxxxx 30 xxxxxxxxxxxxxx  999,999,999.99  999,999,999.99   999,999,999.99 xxxxxxxxxxxxxxxxxxxxxxx  99/99/9999  99-999999/999
|         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |
123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.
10        20        30        40        50        60        70        80        90       100       110       120       130       140       150       160       170       180       190       200       210       220
*/

MontaQuery()

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
	
	/*
Pedido | Emissao  | Fornecedor                      | Condicao        |    Produto    |          Descricao             | Total do PC  |Total Utilizado|Total do Residuo| Solicitante           | Dt.Ult.NF |   Nr.Ult.NF  |
999999  99/99/999  000000/00 - xxxxxxxx 20 xxxxxxxx  000 - XXX 10 XXX  XXXXXXXXXXXXXXX  xxxxxxxxxxxx 30 xxxxxxxxxxxxxx  999,999,999.99  999,999,999.99   999,999,999.99  xxxxxxxxxxxxxxxxxxxxxxx  99/99/9999  99-999999/999
|         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |
123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.
        10        20        30        40        50        60        70        80        90       100       110       120       130       140       150       160       170       180       190       200       210       220
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
		@ nLin,170 Psay Left(BuscaStat(),23)
		aBscNFE := BscNFE(SC7->C7_NUM)
		@ nLin,195 Psay aBscNFE[1]  // Dt. Ult NF
		@ nLin,207 Psay aBscNFE[2]  // Filial+Nro+Serie Ult NF
	EndIf
	
	nLin++
	
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
@ nLin,121 Psay Transform( aTotGer[1], "@E 999,999,999.99" )
@ nLin,137 Psay Transform( aTotGer[2], "@E 999,999,999.99" )
@ nLin,154 Psay Transform( aTotGer[3], "@E 999,999,999.99" )
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³MontaQueryºAutor  ³ Sergio Oliveira    º Data ³  Jul/2009   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Executa a Query.                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rcomr07.prw                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MontaQuery()

Local cQuery := ''

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Montar a query de acordo com o periodo especificado:  ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

cQuery += " SELECT R_E_C_N_O_ AS REGS "+cEol
cQuery += " FROM "+RetSqlName('SC7')+cEol
cQuery += " WHERE C7_FILIAL  = '"+xFilial('SC7')+"' "+cEol
cQuery += " AND   C7_EMISSAO BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' "+cEol
cQuery += " AND   C7_NUM     BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "+cEol
cQuery += " AND   C7_QUANT   > C7_QUJE "+cEol
cQuery += " AND   C7_RESIDUO = ' ' "+cEol
cQuery += " AND   C7_CONAPRO = 'L' "+cEol
cQuery += " AND   D_E_L_E_T_ = ' ' "+cEol

nCntView := U_MontaView( cQuery, 'Work' )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ CalcPed  ºAutor  ³ Sergio Oliveira    º Data ³  Jul/2009   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Obtem o total do pedido de compras posicionado.            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rcomr07.prw                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³BuscaStat ºAutor  ³ Sergio Oliveira    º Data ³  Jul/2009   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Obtem o status atual do pedido.                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rcomr07.prw                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function BuscaStat()

Local cQryPC := '', cDescStat := ''

//FWrite( nCot, "Line => "+AllTrim(Str(ProcLine()))+" - Buscando Solicitante do PC: "+SC7->C7_NUM+" - Ref a SC: "+SC7->C7_NUMSC+cEol )

If SC1->( DbSetOrder(1), DbSeek( xFilial("SC1")+SC7->C7_NUMSC ) ) .And. !Empty( SC7->C7_NUMSC )
	PswOrder(2) // Ordem de nome do usuario
	PswSeek( SC1->C1_SOLICIT )
	cUsrdoPC := UsrFullName( PswId() )	
//FWrite( nCot, "Line => "+AllTrim(Str(ProcLine()))+" - Encontrou a SC: "+SC7->C7_NUMSC+'. SC1->C1_SOLICIT: '+SC1->C1_SOLICIT+" - PswId(): "+PswId()+" - UsrFullName( PswId() ): "+UsrFullName( PswId() )+cEol )

	If Empty(cUsrdoPC)
		cUsrdoPC := "Sem Solicitante na SC"
	EndIf

Else
	cUsrdoPC := UsrFullName( SC7->C7_USER )
EndIf

If Empty(cUsrdoPC)
	cUsrdoPC := "Sem Solicitante na SC"
EndIf

Return( cUsrdoPC )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ BscNFE   ºAutor  ³ Sergio Oliveira    º Data ³  Mai/2009   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Obter os dados da ultima NFE para o Pedido                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rcomr07.prw                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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