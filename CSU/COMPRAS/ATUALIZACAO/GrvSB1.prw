#Include 'Rwmake.ch'

User Function GrvSB1()

Processa( { || OkProc() }, 'Efetuando Gravacao no SB1.....' )

Static Function OkProc()

ChkFile('SB1')
DbSelectArea('SB1')
DbSetOrder(1)
DbGoTop()

U_UsarDbf( '\workflow\sb1050.dbf','Work' )

DbSelectArea('Work')
DbGoTop()
ProcRegua(LastRec())
While !Eof()
	IncProc()
	DbSelectArea('SB1')
	If DbSeek( xFilial('SB1')+Work->B1_COD )
		RecLock('SB1',.f.)
		SB1->B1_DESC := WORK->B1_DESC
		MsUnLock()
	EndIf
	DbSelectArea('Work')
	DbSkip()
EndDo

Work->(DbCloseArea())

Return

User Function TstArray()

_aTst := { 1.5, 0,0.01, 0, 3, 3.5, 0 }

a:=1

Return

User Function GrvCTS(pcLigaDesl)

Processa( { || aOkProc(pcLigaDesl) }, 'Efetuando Gravacao dos CTS.....' )

Return

Static Function aOkProc(pcLigaDesl)

Private cAliasNovo := GetNextAlias()

CTT->( DbSetOrder(1) )
CTH->( DbSetOrder(1) )

If pcLigaDesl == Nil  // Ligar
    Alert( 'Voce deve selecionar alguma opcao valida.' )	
    Return
EndIf

If Trim(Upper(pcLigaDesl)) # 'D' .And. Trim(Upper(pcLigaDesl)) # 'L' // Desligar
    Alert( 'Voce deve selecionar alguma opcao valida.' )	
    Return
EndIf

If Trim(Upper(pcLigaDesl)) == 'D' // Desligar
	
	TcSqlExec( "UPDATE CTT050 SET CTT_RGNV3  = ' ' " )
	TcSqlExec( "UPDATE CTH050 SET CTH_CRGNV2 = ' ' " )
	
	cSel := " SELECT COUNT(*) AS REG1 FROM CTT050 WHERE CTT_RGNV3 <> ' ' "
	
	U_MontaView( cSel, 'Work1' )
	
	cSel := " SELECT COUNT(*) AS REG2 FROM CTH050 WHERE CTH_CRGNV2 <> ' ' "
	
	U_MontaView( cSel, 'Work2' )
	
	Work1->( DbGoTop() )
	Work2->( DbGoTop() )
	
	cTxtAviso := "Os bloqueios contabeis foram desativados ate o termino deste processo!"
	cTxtAviso += "Número de registros ainda configurados para bloqueio CC: "+AllTrim(Str(Work1->REG1))+" - CLVL: "+AllTrim(Str(Work2->REG2))

	Aviso("Bloqueios Contabeis",cTxtAviso,;
	{"&Fechar"},3,"Validacao de Bloq. Contabil",,;
	"PMSAPONT")
	
	Return
	
EndIf

If !U_UsarDbf( '\workflow\estrdiv.dbf',cAliasNovo )
    Return
EndIf

DbSelectArea(cAliasNovo)
DbGoTop()
ProcRegua(LastRec())
While !Eof()
	IncProc()
	If CTT->( DbSeek( xFilial('CTT')+AllTrim((cAliasNovo)->CCUSTO) ) ) .And. AllTrim((cAliasNovo)->CCUSTO) # AllTrim(CTT->CTT_RGNV3)
		CTT->( RecLock('CTT',.f.) )
		CTT->CTT_RGNV3 := AllTrim((cAliasNovo)->CCUSTO)
		CTT->( MsUnLock() )
	EndIf
	If CTH->( DbSeek( xFilial('CTH')+AllTrim((cAliasNovo)->CLVALOR) ) ) .And. AllTrim((cAliasNovo)->CCUSTO) # AllTrim(CTH->CTH_CRGNV2)
		CTH->( RecLock('CTH',.f.) )
		CTH->CTH_CRGNV2 := AllTrim((cAliasNovo)->CCUSTO)
		CTH->( MsUnLock() )
	EndIf
	DbSelectArea(cAliasNovo)
	DbSkip()
EndDo

Aviso("Bloqueios Contabeis","Os bloqueios contabeis foram novamente ATIVADOS!",;
{"&Fechar"},3,"Validacao de Bloq. Contabil",,;
"PCOLOCK")

(cAliasNovo)->(DbCloseArea())

Return

User Function Tsttmp()

Processa( { || tsttmp2() },'Processando.....' )

Return

Static Function tsttmp2()

nConta := 1
ProcRegua(10000)
For nk := 1 To 10000
	If nConta == 500
		nConta := 1
		ProcRegua(500)
	EndIf
	IncProc('Atualizando a base de dados....')
	nConta ++
Next

Return

User Function GrveSC7()

If !U_UsarDbf( '\workflow\pedidos.dbf', 'Work' )
    Return
EndIf

If Aviso("Atualizacoes de Pedidos","Deseja executar o ajuste dos Pedidos de Compras?",;
   {"Abandonar","Confirmar"},3,"Ajuste na base historica",,;
   "PCOLOCK") == 1
    Return
EndIf

Processa( { || GrveSC7b() },'Processando as correcoes...' )

Return

Static Function GrveSC7b()

Local _lLockCC, _lLockUNI, _lLockOPER, _lLockar
Local _lMsg := .t., _lDebug := .f.
Local nLockads := 0, nEncontr := 0
Local _cDePara   := ''

ProcRegua( WORK->( RecCount() ) )

Work->( DbGoTop() )
While !Work->( Eof() )

     _lLockCC   := .f.
     _lLockUNI  := .f. 
     _lLockOPER := .f.
     _lLockar   := .f.
     
     IncProc()
     
     SC7->( DbSeek( xFilial('SC7')+AllTrim(Work->PEDIDO) ) )
     While !SC7->( Eof() ) .And. SC7->C7_NUM == AllTrim(Work->PEDIDO)

     	_cDePara   := ''
	
        If AllTrim(WORK->CCUSTO)+AllTrim(WORK->UNIDADE)+AllTrim(WORK->OPERACAO) == AllTrim( SC7->C7_CC )+AllTrim( SC7->C7_ITEMCTA )+AllTrim( SC7->C7_CLVL )
           If !Empty( WORK->CCDEST ) .And. AllTrim( SC7->C7_CC ) # AllTrim( WORK->CCDEST )
              _lLockCC   := .t.
              _lLockar   := .t.
           EndIf
           If !Empty( WORK->UNIDEST ) .And. AllTrim( SC7->C7_ITEMCTA ) # AllTrim( WORK->UNIDEST )
              _lLockUNI  := .t.
              _lLockar   := .t.
           EndIf
           If !Empty( WORK->OPERDEST ) .And. AllTrim( SC7->C7_CLVL ) # AllTrim( WORK->OPERDEST )
              _lLockOPER := .t.
              _lLockar   := .t.
           EndIf
           If _lLockar
              SC7->( RecLock('SC7',.f.) ) 
              If _lLockCC
	              _cDePara += "CC De: "+Trim(SC7->C7_CC)+" - Para: "+AllTrim(Work->CCDEST)+Chr(13)
	              SC7->C7_CC      := AllTrim( Work->CCDEST )
              EndIf
              If _lLockUNI
	              _cDePara += "Unidade De: "+Trim(SC7->C7_ITEMCTA)+" - Para: "+AllTrim(Work->UNIDEST)+Chr(13)
	              SC7->C7_ITEMCTA := AllTrim( Work->UNIDEST )
              EndIf
              If _lLockOPER
	              _cDePara += "Operacao De: "+Trim(SC7->C7_CLVL)+" - Para: "+AllTrim(Work->OPERDEST)+Chr(13)
	              SC7->C7_CLVL    := AllTrim( Work->OPERDEST )
              EndIf
              SC7->( MsUnLock() )
              nLockads ++ 
			  
			  If _lMsg
	              If !MsgBox('Alterando o Pedido: '+AllTrim(Work->PEDIDO)+Chr(13);
	                    +_cDePara+". Deseja continuar a ler esta mensagem?",'Ajuste automatico de PC','YesNo')
	                 _lMsg := .f.
	              EndIf
              EndIf
                    
           EndIf
	        nEncontr ++
        EndIf
        
        SC7->( DbSkip() )
     
     EndDo
     
     Work->( DbSkip() )

EndDo

MsgBox( 'Pedidos Lidos: '+Str( Work->( RecCount() ) )+Chr(13);
       +'Encontrados..: '+Str( nEncontr )+Chr(13);
       +'Alterados....: '+Str( nLockads ),'Correcao de Pedidos','Info' )

Return