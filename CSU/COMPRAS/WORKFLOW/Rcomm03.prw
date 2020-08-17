#Include 'Rwmake.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRcomm03   บAutor  ณSergio Oliveira     บ Data ณ  Dez/2007   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Efetua o de-para de compradores entre os pedidos de comprasบฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU - Suprimentos.                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function Rcomm03()

Local cPerg   := PADR("RCOM03",LEN(SX1->X1_GRUPO))
Local aRegs   := {}
Local cMens   := "Troca de Grupos"
Local cPriLin := "Se deseja realmente efetuar esta opera็ใo, "
Local cExec

aAdd(aRegs,{cPerg,"01","Numero da SC..........:","","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Grupo de Destino......:","","","mv_ch2","C",06,0,0,"G","ExistCpo('SAJ')","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

U_ValidPerg( cPerg, aRegs ) 

If !Pergunte( cPerg,.t. )
    Return
EndIf

If !SC1->( DbSetOrder(1), DbSeek( xFilial('SC1')+MV_PAR01 ) )
    MsgBox("Solicita็ใo de Compras nใo encontrada!","Numero Incorreto","Alert")
    Return
EndIf

If !U_CodSegur(cMens, cPriLin)
	Return
EndIf

cExec := " UPDATE "+RetSqlName("SC1")+" SET C1_GRUPCOM = '"+MV_PAR02+"' "
cExec += " WHERE C1_FILIAL  = '"+xFilial("SC1")+"' "
cExec += " AND   C1_NUM     = '"+MV_PAR01+"' "
cExec += " AND   D_E_L_E_T_ = ' ' "

TcSqlExec( cExec )

MsgBox("Procedimento executado!","Termino de Execucao","Info")

Return

User Function Rcomm03x()

Local cCombo     := "Concluํdos"
Local aCombo     := {"Em Aberto","Concluํdos","Todos"}
Private cGrupoAnt  := Space(TamSX3("AJ_GRCOM")[1])
Private cDescAnt   := Space(30) // Nome do comprador do grupo de origem
Private cGrupoDest := Space(TamSX3("AJ_GRCOM")[1])
Private cDescDest  := Space(30) // Nome do comprador do grupo de destino
Private aCombo   := {"A-Em Aberto","E-Encerrados","T-Todos"}
Private aStru    := {}, aCampos := {}
Private oObj, cCombo

Aadd( aStru, {'DOCUMENTO' ,'C',11,0} )
Aadd( aStru, {'NUMERO'    ,'C',TamSX3("C1_NUM")[1],0} )
Aadd( aStru, {'GRUPATU'   ,'C',TamSX3("AJ_GRCOM")[1],0} )
Aadd( aStru, {'COMPRATU'  ,'C',30,0} )
Aadd( aStru, {'GRUPDES'   ,'C',TamSX3("AJ_GRCOM")[1],0} )
Aadd( aStru, {'COMPDES'   ,'C',30,0} )

U_CriaTmp( aStru, 'Work' )

aCampos   := {}
Aadd( aCampos, {'DOCUMENTO' ,'Tipo de Documento'     ,'@!','11','0'} )
Aadd( aCampos, {'NUMERO'    ,'Numero'                ,''  ,TamSX3("C1_NUM")[1],'0'} )
Aadd( aCampos, {'GRUPATU'   ,'Grupo Atual'           ,'@!',TamSX3("AJ_GRCOM")[1],'0'} )
Aadd( aCampos, {'COMPRATU'  ,'Comprador Atual'       ,'@!','30','0'} )
Aadd( aCampos, {'GRUPDES'   ,'Grupo Destino'         ,'@!',TamSX3("AJ_GRCOM")[1],'0'} )
Aadd( aCampos, {'COMPDES'   ,'Comprador Destino'     ,'@!','30','0'} )

Define MsDialog MkwDlg Title  "Troca de Grupos de Compras nos Movimentos" From 105,082 To 556,797 of oMainWnd Pixel

@ 001,002 To 049,352 Title  "Informa็๕es da Origem e Destino"
@ 050,002 To 227,352 Title  "Painel de Confer๊ncia -| Clique nas op็๕es desejadas Abaixo |-"
@ 001,263 To 049,352 // Moldura do botao confirmar transacao

@ 012,009 Say  "C๓digo do Grupo Anterior" Size 65,8
@ 024,009 Say  "C๓digo do Grupo Atual"    Size 65,8
@ 035,009 Say  "Situa็ใo dos Movimentos a Serem Trocados" Size 109,8
@ 012,110 Say  "/" Size 3,8
@ 024,110 Say  "/" Size 3,8
@ 011,077 Get cGrupoAnt  Size 30,10 F3 "SAJ" Valid( Vazio() .Or. ( ExistCpo("SAJ") .And. Rcomm03c(1) ) )
@ 011,113 Get cDescAnt   Size 91,10 When .f.
@ 023,077 Get cGrupoDest Size 30,10 F3 "SAJ" Valid( Vazio() .Or. ( ExistCpo("SAJ") .And. Rcomm03c(2) ) )
@ 022,113 Get cDescDest  Size 91,10 When .f.
@ 035,124 ComboBox cCombo Items aCombo Size 76,21

@ 084,002 To 226,352 Browse "Work" Field aCampos Object oObj

@ 062,103 Button  "_Solicita็๕es" Size 36,16 Action( Processa( { || Rcomm03a("SC", Left(cCombo,1)) }, "Obtendo Solicita็๕es de Compras" ) )
@ 062,150 Button  "_Cota็๕es"     Size 36,16 Action( Processa( { || Rcomm03a("CO", Left(cCombo,1)) }, "Obtendo Cota็๕es de Compras" ) )
@ 062,197 Button  "_Pedidos"      Size 36,16 Action( Processa( { || Rcomm03a("PC", Left(cCombo,1)) }, "Obtendo Pedidos de Compras" ) )
@ 018,279 Button "_Confirmar Transa็ใo" Size 59,16 Action( Processa( { || Rcomm03b(Left(cCombo,1)) }, "Efetuando Transacao..." ) )

Activate Dialog mkwdlg Centered

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ Rcomm03a บAutor  ณSergio Oliveira     บ Data ณ  Ago/2008   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Obter os documentos conforme o botao escolhido.            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rcomm03.prw                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Rcomm03a(cTipoDoc, cCombo)

Local cSelect

ProcRegua(Work->( LastRec() ))

Work->( DbGoTop() )

While !Work->( Eof() )
	IncProc("Limpando pesquisa anterior...")
	Work->( RecLock('Work',.f.) )
	Work->( DbDelete() )
	Work->( MsUnLock() )
	Work->( DbSkip() )
EndDo

If cTipoDoc $ "SC"
	cSelect := " SELECT 'SOLICITACAO' DOCUMENTO, C1_NUM NUMERO, C1_GRUPCOM GRUPATU "
	cSelect += " FROM "+RetSqlName("SC1")
	cSelect += " WHERE C1_FILIAL = '"+xFilial("SC1")+"' "
	If cCombo $ "A" // Somente os em Aberto
		cSelect += " AND   ( C1_QUANT > C1_QUJE AND C1_RESIDUO = ' ' ) "
	ElseIf cCombo $ "E" // Somente os Encerrados(os eliminados por residuos tambem sao tratados aqui)
		cSelect += " AND   ( C1_QUJE >= C1_QUANT OR C1_RESIDUO <> ' ' ) "
	EndIf
	cSelect += " AND   C1_GRUPCOM = '"+cGrupoAnt+"' "
ElseIf cTipoDoc $ "PC"
	cSelect := " SELECT 'PEDIDOS' DOCUMENTO, C7_NUM NUMERO, C7_GRUPCOM GRUPATU "
	cSelect += " FROM "+RetSqlName("SC7")
	cSelect += " WHERE C7_FILIAL = '"+xFilial("SC7")+"' "
	If cCombo $ "A" // Somente os em Aberto
		cSelect += " AND   ( C7_QUANT > C7_QUJE AND C7_RESIDUO = ' ' AND C7_ENCER = ' ' ) "
	ElseIf cCombo $ "E" // Somente os Encerrados(os eliminados por residuos tambem sao tratados aqui)
		cSelect += " AND   ( C7_QUJE >= C7_QUANT OR C7_RESIDUO <> ' ' OR C7_ENCER <> ' ' ) "
	EndIf
	cSelect += " AND   C7_GRUPCOM = '"+cGrupoAnt+"' "
Else
	cSelect := " SELECT 'COTACOES' DOCUMENTO, C8_NUM NUMERO, C8_GRUPCOM GRUPATU "
	cSelect += " FROM "+RetSqlName("SC8")
	cSelect += " WHERE C8_FILIAL = '"+xFilial("SC8")+"' "
	If cCombo $ "A" // Somente os em Aberto
		cSelect += " AND   C8_NUMPED = '      ' "
	ElseIf cCombo $ "E" // Somente os Encerrados(os eliminados por residuos tambem sao tratados aqui)
		cSelect += " AND   C8_NUMPED <> '      ' "
	EndIf
	cSelect += " AND   C8_GRUPCOM = '"+cGrupoAnt+"' "
EndIf
cSelect += " AND D_E_L_E_T_ = ' ' "

nCntView := U_MontaView( cSelect, "Work2" )

Work2->( DbGoTop() )

ProcRegua( nCntView )

While !Work2->( Eof() )
	
	IncProc( "Preenchendo a nova consulta..." )
	
	DbSelectArea('Work')
	Work->( RecLock('Work',.t.) )
	Work->DOCUMENTO := Work2->DOCUMENTO
	Work->NUMERO    := Work2->NUMERO
	Work->GRUPATU   := Work2->GRUPATU
	Work->COMPRATU  := cDescAnt
	Work->GRUPDES   := cGrupoDest
	Work->COMPDES   := cDescDest
	Work->( MsUnLock() )
	
	Work2->( DbSkip() )
	
EndDo

Work->( DbGoTop() )

If Work->( Eof() )
	Aviso("Sem Dados","Nao existe dados para este grupo de origem!",{"&Fechar"},3,"Grupo de Origem",,"PMSAPONT")
EndIf

oObj:oBrowse:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ Rcomm03b บAutor  ณSergio Oliveira     บ Data ณ  Out/2008   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza o comprador destino.                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rcomm03.prw                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Rcomm03b(cCombo)

Local cMens   := "Troca de Grupos"
Local cPriLin := "Se deseja realmente efetuar esta opera็ใo, "
Local cExec

If cGrupoAnt == cGrupoDest
	Aviso("GRUPOS IGUAIS","Origem e destino iguais. Selecione outra origem e destino.",;
		{"&Voltar"},3,"Troca de Grupos",,"PCOLOCK")   
   Return
EndIf

If !U_CodSegur(cMens, cPriLin)
	Return
EndIf

Work->( DbGoTop() )

ProcRegua(4)

IncProc("Procedimento 1 de 4")

While !Work->( Eof() )
	
	Work->( RecLock("Work",.f.) )
	work->( DbDelete() )
	Work->( MsUnLock() )
	
	Work->( DbSkip() )
	
EndDo

Work->( DbGoTop() )

// Atualizar a base de dados:

IncProc("Procedimento 2 de 4")

cExec := " UPDATE "+RetSqlName("SC1")+" SET C1_GRUPCOM = '"+cGrupoDest+"' "
cExec += " WHERE C1_FILIAL = '"+xFilial("SC1")+"' "
If cCombo $ "A" // Somente os em Aberto
	cExec += " AND   ( C1_QUANT > C1_QUJE AND C1_RESIDUO = ' ' ) "
ElseIf cCombo $ "E" // Somente os Encerrados(os eliminados por residuos tambem sao tratados aqui)
	cExec += " AND   ( C1_QUJE >= C1_QUANT OR C1_RESIDUO <> ' ' ) "
EndIf
cExec += " AND   C1_GRUPCOM = '"+cGrupoAnt+"' "
cExec += " AND   D_E_L_E_T_ = ' ' "

TcSqlExec( cExec )

IncProc("Procedimento 3 de 4")

cExec := " UPDATE "+RetSqlName("SC7")+" SET C7_GRUPCOM = '"+cGrupoDest+"' "
cExec += " WHERE C7_FILIAL = '"+xFilial("SC7")+"' "
If cCombo $ "A" // Somente os em Aberto
	cExec += " AND   ( C7_QUANT > C7_QUJE AND C7_RESIDUO = ' ' AND C7_ENCER = ' ' ) "
ElseIf cCombo $ "E" // Somente os Encerrados(os eliminados por residuos tambem sao tratados aqui)
	cExec += " AND   ( C7_QUJE >= C7_QUANT OR C7_RESIDUO <> ' ' OR C7_ENCER <> ' ' ) "
EndIf
cExec += " AND   C7_GRUPCOM = '"+cGrupoAnt+"' "
cExec += " AND   D_E_L_E_T_ = ' ' "

TcSqlExec( cExec )

IncProc("Procedimento 4 de 4")

cExec := " UPDATE "+RetSqlName("SC8")+" SET C8_GRUPCOM = '"+cGrupoDest+"' "
cExec += " WHERE C8_FILIAL = '"+xFilial("SC8")+"' "
If cCombo $ "A" // Somente os em Aberto
	cExec += " AND   C8_NUMPED = '      ' "
ElseIf cCombo $ "E" // Somente os Encerrados(os eliminados por residuos tambem sao tratados aqui)
	cExec += " AND   C8_NUMPED <> '      ' "
EndIf
cExec += " AND   C8_GRUPCOM = '"+cGrupoAnt+"' "
cExec += " AND   D_E_L_E_T_ = ' ' "

TcSqlExec( cExec )

oObj:oBrowse:Refresh()

MsgBox("Procedimento executado!","Termino de Execucao","Info")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ Rcomm03c บAutor  ณ Sergio Oliveira    บ Data ณ  Ago/2008   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao que retorna o nome do comprador principal do grupo  บฑฑ
ฑฑบ          ณ de compras.                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rcomm03.prw                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Rcomm03c(nParam)

If nParam == 1
	cDescAnt   := UsrFullName( Posicione("SAJ",1,xFilial("SAJ")+cGrupoAnt, "AJ_USER") )
Else
	cDescDest  := UsrFullName( Posicione("SAJ",1,xFilial("SAJ")+cGrupoDest, "AJ_USER") )
EndIf

Return( .t. )