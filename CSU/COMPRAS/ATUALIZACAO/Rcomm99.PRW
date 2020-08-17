#Include 'Rwmake.ch'
#Include 'TopConn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ Rcomm99  บAutor  ณSergio Oliveira     บ Data ณ  Ago/2008   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera a importacao dos grupos de aprovacao e procede com a  บฑฑ
ฑฑบ          ณ alteracao dos Pedidos de Compras.                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SAG.                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function Rcomm99()

Local cArqDBF, nOpc
Private cColExce := 'DATADE'
Private aSays := {}, aButtons := {}, aDiferen := {}, aNotUsr := {}, aAprovs   := {}
Private lProblemas  := .f.
Private cEol      := Chr(13)+Chr(10)
Private nLogStr   := FCreate( '\workflow\ImpSAL'+'-'+Dtos(Date())+'-'+StrTran(Time(),":","_")+'.log',1 )
Private cLogStr   := 'Inicio do log de Importa็ใo de Grupos de Aprova็ใo'

FWrite( nLogStr, cLogStr+cEol )

IIF( Select("SAL") == 0, Chkfile('SAL'), "")

AADD(aSays, "Importa็ao da Planilha de Grupos de aprovacao" )
AADD(aSays, "Esta rotina tem como objetivo processar a importa็ao das Planilhas" )
AADD(aSays, "dos grupos de aprova็ใo conforme dados da planilha" )
AADD(aSays, "Excel."  )

AADD(aButtons, { 1,.T., {|o| nOpc:=1,o:oWnd:End() } } )
AADD(aButtons, { 14,.T.,{|o| cArqDbf := cGetFile("Arquivo de Grupos Dbf|*.DBF","Selecione...",,,.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE) } } )
AADD(aButtons, { 2,.T., {|o| o:oWnd:End() }} )

FormBatch( 'Planilha de Grupos de Aprova็ใo', aSays, aButtons,,240,425 )

If nOpc <> 1
	IIF( Select("Work") > 0, Work->( DbCloseArea() ), "" )
	Return
Else
	If Empty( cArqDbf )
		Aviso('Sem Arquivo Selecionado','Nao houve arquivo selecionado.',{'Voltar'})
	Else
		
		Processa( { || Rcomm99a(cArqDbf) }, 'Processando Dados da Planilha...' )
		
	EndIf
Endif

IIF( Select("Work") > 0, Work->( DbCloseArea() ), "" )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ Rcomm99a บAutor  ณSergio Oliveira     บ Data ณ  Ago/2008   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processamento da importacao.                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rcomm99.prw                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Rcomm99a(pcArqDbf)

Local cForn, cLoja
Local cMens     := "Atualiza็ใo dos grupos"
Local cPriLin   := "Se deseja realmente efetuar esta opera็ใo, "
Local cIdxWork  := CriaTrab(Nil,.f.), cIdxWork2 := Left( cIdxWork,7 )+'a'
Private aVetor    := {}, aStruSAL := SAL->( DbStruct() ), aAltNaMao := {}

/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณ A matriz abaixo devera conter obrigatoriamente todos os campos que a matriz ณ
ณ aVetor:                                                                     ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/

Private aSX3s       := { 'AL_FILIAL', 'AL_COD', 'AL_DESC', 'AL_ITEM', 'AL_APROV',;
'AL_USER', 'AL_NOME', 'AL_NIVEL', 'AL_LIBAPR', 'AL_AUTOLIM', 'AL_TPLIBER' }

/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณ Verifica se o arquivo de rateios esta dentro dos parametros de configuracao ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/

FWrite( nLogStr, "Verificando a estrutura do arquivo do Excel x SAL"+cEol )

If !Rcomm99b('Work', pcArqDbf)
	Return
EndIf

/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณ Efetuar a consistencia das informacoes vindas do arqquivo.                  ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/

SAL->( DbSetOrder(1) )

DbSelectArea("Work")
IndRegua( "Work", cIdxWork, SAL->(IndexKey()),,,"Indexando..." )
DbClearIndex()

SAL->( DbSetOrder(2) )

IndRegua( "Work", cIdxWork2, SAL->(IndexKey()),,,"Indexando..." )
DbClearIndex()

DbSetIndex( cIdxWork + OrdBagExt() )
DbSetIndex( cIdxWork2 + OrdBagExt() )

Work->( DbSetOrder(1) )

FWrite( nLogStr, "Verificar os dados provenientes da planilha"+cEol )

Processa( { || Rcomm99c() }, "Verificando os dados digitados na planilha..." )

//Alert( Len(aDiferen) )

/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณ Caso seja encontrada alguma inconsistencia, efetuar a impressao do log.     ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/

If lProblemas
	Rcomm99e()
	Work->( DbCloseArea() )
	Fclose( nLogStr )
	Return
EndIf

If Len( aDiferen ) == 0
	Aviso(cMens,"Nใo houve alteracoes",{"&Fechar"},3,"Sem Processamento",,"PCOLOCK")
	Fclose( nLogStr )
	Return
EndIf

/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณ Se foi possivel chegar ate aqui, mostrar o antes e o depois das alteracoes: ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/

Processa( { || Rcomm99g() }, "Imprimindo o antes e depois..." )

If Len( aDiferen ) == 0
	
	cTxtMsg := "Nใo houve pedidos a serem alterados. Somente o grupo de aprova็ใo serแ alterado conforme a planilha."
	Aviso("Nao houve alteracoes",cTxtMsg,{"&Fechar"},3,"Nao Confirmado",,"PCOLOCK")
	
	Fclose( nLogStr )
	//Return
	
EndIf

If !U_CodSegur(cMens, cPriLin)
	Aviso(cMens,"Opera็ใo nao Confirmada",{"&Fechar"},3,"Nao Confirmado",,"PCOLOCK")
	Fclose( nLogStr )
	Return
EndIf

TcSqlExec( "TRUNCATE TABLE "+RetSqlName("SAL") )

Work->( DbGoTop() )

Procregua( Work->( RecCount() ) )

While Work->( !Eof() )
	
	IncProc("Importando, aguarde por gentileza...")
	
	SAL->( RecLock("SAL",.t.) )
	For wV := 1 To Len( aStruSAL )
		If Trim(aStruSAL[wV][1]) $ 'AL_COD/AL_ITEM/AL_APROV/AL_USER/AL_NIVEL'
			SAL->&(aStruSAL[wV][1]) := StrZero(Val(Work->&(aStruSAL[wV][1])),TamSX3(Trim(aStruSAL[wV][1]))[1])
		Else
			If ValType( SAL->&(aStruSAL[wV][1]) ) $ 'C'
				SAL->&(aStruSAL[wV][1]) := Upper( Work->&(aStruSAL[wV][1]) )
			Else
				SAL->&(aStruSAL[wV][1]) := Work->&(aStruSAL[wV][1])
			EndIF
		EndIf
	Next
	SAL->( MsUnLock() )
	
	Work->( Dbskip() )
	
Enddo

POSICSC7->( DbGoTop() )

nConta := 20

ProcRegua( nConta )

While !POSICSC7->( Eof() )
	
	IncProc("Alterando os pedidos....")
	
	If nConta > 20
		ProcRegua(nConta)
		nConta := 1
	EndIf
	
	nConta ++
	
	SC7->( DbSetOrder(1), DbSeek( xFilial('SC7')+POSICSC7->C7_NUM ) )
	
	U_Mt120Gok()
	
	POSICSC7->( DbSkip() )
	
EndDo

If Len( aNotUsr ) > 0
	
	If Aviso("Confirma็ใo","Deseja notificar automaticamente os usuแrios destes pedidos?",;
		{"Abandonar","Confirmar"},3,"Nao Confirmado",,"PCOLOCK") == 2
		
		Processa( { || NotifPC() }, "Notificando, aguarde..." ) 
		             
	Else
		Aviso("Nใo Confirmado","Os usuแrios nใo serใo notificados!",{"&Fechar"},3,"Nao Confirmado",,"PCOLOCK")
	EndIf
	
EndIf

Work->( DbCloseArea() )
Fclose( nLogStr )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ Rcomm99c บAutor  ณSergio Oliveira     บ Data ณ  Ago/2008   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao que faz a verificacao dos campos recebidos.         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rcomm99.prw                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Rcomm99c()

Local cArqInd  := CriaTrab(,.f.)
Local cCondSAL := ( SAL->( DbSetOrder(1) ), Trim( SAL->( IndexKey() ) ) )

FWrite( nLogStr, "Ajustar dados da planilha..."+cEol )

Work->( DbGoTop() )
ProcRegua( Work->( LastRec() ) )

While !Work->( Eof() )

      IncProc('Ajustando dados da Planilha')

   	  Work->( RecLock('Work',.f.) )
   	  For wV := 1 To Len( aStruSAL )
	   	  If Trim(aStruSAL[wV][1]) $ 'AL_COD/AL_ITEM/AL_APROV/AL_USER/AL_NIVEL/'+cColExce
			 Work->&(aStruSAL[wV][1]) := StrZero(Val(Work->&(aStruSAL[wV][1])),TamSX3(Trim(aStruSAL[wV][1]))[1])
		  EndIf
	  Next
	  Work->( MsUnLock() )

      Work->( DbSkip() )

EndDo


Work->( DbGoTop() )

ProcRegua( Work->( LastRec() ) )

FWrite( nLogStr, "Buscando dados incorretos"+cEol )

While !Work->( Eof() )
	
	IncProc('Buscando dados incorretos...')
	
	// 'AL_FILIAL', 'AL_COD', 'AL_DESC', 'AL_ITEM', 'AL_APROV',;
	// 'AL_USER', 'AL_NOME', 'AL_NIVEL', 'AL_LIBAPR', 'AL_AUTOLIM', 'AL_TPLIBER'
	
	cxChave := Work->AL_COD
	
	FWrite( nLogStr, "Grupo "+cxChave+cEol )
	
	While !Work->( Eof() ) .And. Work->AL_COD == cxChave
		
		IIF (!Empty(Work->AL_FILIAL) , Rcomm99d('SAL',Work->(Recno()),"Codigo de Filial: "+Work->AL_FILIAL+" devera estar em branco."),)
		IIF (Empty(Work->AL_COD)     , Rcomm99d('SAL',Work->(Recno()),"O codigo do aprovador esta em branco."),)
		IIF (Empty(Work->AL_DESC)    , Rcomm99d('SAL',Work->(Recno()),"A descricao do grupo esta em branco."),)
		IIF (Empty(Work->AL_ITEM)    , Rcomm99d('SAL',Work->(Recno()),"O item do grupo esta em branco.."),)
		IIF (Empty(Work->AL_APROV)   , Rcomm99d('SAL',Work->(Recno()),"O codigo de aprovador esta em branco."),)
		IIF (Empty(Work->AL_USER)    , Rcomm99d('SAL',Work->(Recno()),"O codigo de usuario esta em branco."),)
		IIF (Empty(Work->AL_NOME)    , Rcomm99d('SAL',Work->(Recno()),"O nome de usuario esta em branco."),)
		IIF (Empty(Work->AL_NIVEL)   , Rcomm99d('SAL',Work->(Recno()),"O nivel esta em branco."),)
		IIF (Empty(Work->AL_LIBAPR)  , Rcomm99d('SAL',Work->(Recno()),"O tipo do aprovador esta em branco."),)
		IIF (Empty(Work->AL_AUTOLIM) , Rcomm99d('SAL',Work->(Recno()),"O campo referente a respeitar a faixa de valores estแ em branco."),)
		IIF (Empty(Work->AL_TPLIBER) , Rcomm99d('SAL',Work->(Recno()),"O tipo de liberacao esta em branco."),)
		
		// Valida codigo de aprovador
		SAK->( DbSetOrder(1) )
		If !SAK->( DbSeek(xFilial("SAK")+Work->AL_APROV) ) .And. !Empty( Work->AL_APROV )
			Rcomm99d('SAK',Work->(Recno()),"Codigo de aprovador: "+Work->AL_APROV+" Invalido.")
		Endif
		// Valida Codigo de Usuario
		If Empty( UsrRetName(Work->AL_USER) ) .And. !Empty(Work->AL_USER)
			Rcomm99d('SAL',Work->(Recno()),"Codigo de usuario: "+Work->AL_USER+" Invalido.")
		Endif
		
		Work->( DbSkip() )
		
	EndDo
	
EndDo

// Verificar quais foram as alteracoes para alterar somente os pedidos de compras que contenham estes grupos:

Work->( DbGoTop() )

ProcRegua( Work->( LastRec() ) )

SAL->( DbSetOrder(1) )

FWrite( nLogStr, "Verificando o que foi alterado. Chave ativa do SAL => "+Trim(SAL->( IndexKey() ))+cEol )
FWrite( nLogStr, "Verificando o que foi alterado. Chave ativa do WORK => "+Trim(WORK->( IndexKey() ))+cEol )

While !Work->( Eof() )
	
	IncProc('Verificando o que foi alterado...')
	
	cxChave := Work->AL_COD
	
	FWrite( nLogStr, "Verificando o que foi alterado. Grupo "+cxChave+cEol )
	
	// 'AL_FILIAL', 'AL_COD', 'AL_DESC', 'AL_ITEM', 'AL_APROV',|StrZero(Val(Work->AL_APROV),TamSX3("AL_APROV")[1])
	// 'AL_USER', 'AL_NOME', 'AL_NIVEL', 'AL_LIBAPR', 'AL_AUTOLIM', 'AL_TPLIBER'
	
	While !Work->( Eof() ) .And. Work->AL_COD == cxChave
		
		If !SAL->( DbSeek( xFilial('SAL')+Work->(AL_COD+AL_ITEM) ) )
			If Ascan( aDiferen, Work->AL_COD ) == 0
				FWrite( nLogStr, "Grupo nao encontrado "+cxChave+cEol )
				Aadd( aDiferen, Work->AL_COD )
			EndIf
		Else
			For Wr := 1 To Len( aStruSAL )
				If AllTrim(aStruSAL[Wr][1]) $ "AL_NOME/"+cColExce
					Loop
				EndIf
				If SAL->&(aStruSAL[Wr][1]) # Work->&(aStruSAL[Wr][1])
					FWrite( nLogStr, "SAL-> "+aStruSAL[Wr][1]+": "+SAL->&(aStruSAL[Wr][1])+" - Planilha-> "+Work->&(aStruSAL[Wr][1])+cEol )
					If Ascan( aDiferen, Work->AL_COD ) == 0
						Aadd( aDiferen, Work->AL_COD )
					EndIf
				EndIf
			Next
		Endif
		
		Work->( DbSkip() )
		
	EndDo
	
EndDo

ProcRegua( SAL->( LastRec() ) )

SAL->( DbGoTop() )
FWrite( nLogStr, "LINE: "+AllTrim(Str(ProcLine()))+" Batida inversa: SAL x Planilha"+cEol )

While !SAL->( Eof() )
	
	IncProc('Verificando o que foi alterado...')
	
	cxChave := SAL->AL_COD
	
	FWrite( nLogStr, "Verificando o que foi alterado. Grupo "+cxChave+cEol )
	
	// 'AL_FILIAL', 'AL_COD', 'AL_DESC', 'AL_ITEM', 'AL_APROV',|StrZero(Val(Work->AL_APROV),TamSX3("AL_APROV")[1])
	// 'AL_USER', 'AL_NOME', 'AL_NIVEL', 'AL_LIBAPR', 'AL_AUTOLIM', 'AL_TPLIBER'
	
	While !SAL->( Eof() ) .And. SAL->AL_COD == cxChave
		
		If !WORK->( DbSeek( xFilial('SAL')+SAL->(AL_COD+AL_ITEM) ) )
			If Ascan( aDiferen, SAL->AL_COD ) == 0
				FWrite( nLogStr, "Grupo nao encontrado "+cxChave+cEol )
				Aadd( aDiferen, SAL->AL_COD )
			EndIf
		Else
			For Wr := 1 To Len( aStruSAL )
				If AllTrim(aStruSAL[Wr][1]) $ "AL_NOME/"+cColExce
					Loop
				EndIf
				If SAL->&(aStruSAL[Wr][1]) # Work->&(aStruSAL[Wr][1])
					FWrite( nLogStr, "SAL-> "+aStruSAL[Wr][1]+": "+SAL->&(aStruSAL[Wr][1])+" - Planilha-> "+Work->&(aStruSAL[Wr][1])+cEol )
					If Ascan( aDiferen, Work->AL_COD ) == 0
						Aadd( aDiferen, Work->AL_COD )
					EndIf
				EndIf
			Next
		Endif
		
		SAL->( DbSkip() )
		
	EndDo
	
EndDo

FWrite( nLogStr, "Verificar duplicidades digitadas na planilha."+cEol )

Work->( DbSetOrder(1) )
Work->( DbGoTop() )

ProcRegua( Work->( LastRec() ) )

While !Eof()
	
	bChave  := &(cCondSAL)
	_lDupli := .f.
	
	//If '400120' $ Work->AL_COD
	//   Alert('1-) 385 - Grupo 400120 => '+Work->(AL_FILIAL+AL_COD+AL_ITEM) )
	//EndIf
	
	Work->( DbSkip() )
	IncProc()
	
	//If '400120' $ Work->AL_COD
	//   Alert('2-) 385 - Grupo 400120 => '+Work->(AL_FILIAL+AL_COD+AL_ITEM)+Chr(13);
	//        +'Teste do lDupli: '+IIF( !Work->( Eof() ) .And. &(cCondSAL) == bChave, '.t.','.f.' ) )
	//EndIf

	While !Work->( Eof() ) .And. &(cCondSAL) == bChave
		
		// Imprimir a Duplicidade
		
		_lDupli := .t.
		
		Work->( DbSkip() )
		IncProc()		
		
	EndDo
                     
    If _lDupli

		Rcomm99d('SAL',0,"Grupo com dados repetidos: "+Left( bChave,TamSX3("AL_FILIAL")[1]+TamSX3("AL_COD")[1] ))

	EndIf	
	
EndDo

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ Rcomm99d บAutor  ณ Sergio Oliveira    บ Data ณ  Ago/2008   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera a gravacao dos logs.                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rcomm99.prw                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Rcomm99d(cArq,nRegi,cDesc,cCampo)

Local aArea := GetArea()

If Select( 'LOG' ) == 0
	
	aCampos := {}
	AADD(aCampos,{"ARQU"      ,"C",007,0})
	AADD(aCampos,{"REGI"      ,"N",009,0})
	AADD(aCampos,{"DESC"      ,"C",110,0})
	AADD(aCampos,{"CAMPO"     ,"C",001,0})
	
	U_CriaTmp(aCampos,'LOG')
	
EndIf

FWrite( nLogStr, cDesc+cEol )

DbSelectArea("LOG")
RecLock("LOG",.T.)
LOG->ARQU  := cArq
LOG->REGI  := nRegi
LOG->DESC  := cDesc
LOG->CAMPO := cCampo
MsUnlock()

lProblemas := .t.

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณRcomm99e  บAutor  ณ Sergio Oliveira    บ Data ณ  Ago/2008   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Efetua a impressao do Log.                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rcomm99.prw                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Rcomm99e()

Local   Titulo      := "RELATORIO DE INCONSISTENCIA"
Local   cDesc1      := "Este programa tem como objetivo imprimir relatorio "
Local   cDesc2      := "de acordo com os parametros informados pelo usuario."
Local   cDesc3      := ""
Local   cPict       := ""
Private aOrd        := ""
Private Tamanho     := "M"  // P - 80, M - 132, G - 220
Private Limite      := 132
Private wNrel       := "RCOMM99"
Private cPerg       := PADR("RCOMM99",LEN(SX1->X1_GRUPO))
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

wNrel := SetPrint(cString,wNrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F., aOrd ,.T. ,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

Processa( {|| Rcomm99f(Titulo) },Titulo )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ Rcomm99f บAutor  ณSergio Oliveira     บ Data ณ  Ago/2008   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressao das inconsistencias.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rcomm99.prw                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Rcomm99f(Titulo)

Cabec1 := PADC("EMPRESA: "+SM0->M0_CODIGO+" - "+ALLTRIM(SM0->M0_NOME)+" - FILIAL: "+SM0->M0_CODFIL+" - "+ALLTRIM(SM0->M0_FILIAL)+" -> "+GetEnvServer(),Limite)
Cabec2 := "ARQUIVO  LINHA     DESCRICAO"
cEol := Chr(13)+Chr(10)

/*
ARQUIVO  REGISTRO  DESCRICAO
XXXXXXX  99999999  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
09        19
*/

ProcRegua( Log->( LastRec() ) )

DbSelectArea("LOG")
DbGotop()

While !Eof()
	
	IncProc("Imprimindo inconsistencias...")
	
	If nLin > 58
		nLin := Cabec(Titulo,Cabec1,Cabec2,wNrel,Tamanho,nTipo)
		nLin++
	Endif
	
	@ nLin,00  PSAY LOG->ARQU
	@ nLin,09  PSAY LOG->REGI+IIF( LOG->REGI > 0,6,0 ) PICTURE "@E 99999999"
	@ nLin,19  PSAY LOG->DESC
	nLin++
	
	DbSelectArea("LOG")
	DbSkip()
	
Enddo

Set Device To Screen

If aReturn[5]==1
	DBCommitAll()
	Set Printer To
	OurSpool(wNrel)
Endif

Ms_Flush()

LOG->( DbCloseArea() )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณRcomm99b  บAutor  ณ Sergio Oliveira    บ Data ณ  Ago/2008   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida o arquivo DBF recebido para importacao.             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rcomm99.prw                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Rcomm99b(pcNextAlias, pcArqDbf)

Local cNxtAlias  := GetNextAlias()
Local lContinua  := .t.
Local nCompara   := 0, nExiste := 0, nPosIni := 0
Local aStruModel := {}
Local cNomArq
Local cBlqMsg    := ' "Campo nao encontrado: "+aSX3[xp]+" - Contate o administrador do sistema." '
Local cTxtMsg    := 'A estrutura do arquivo modelo nao esta compativel com a estrutura importada.'
cTxtMsg    += 'Selecione o arquivo correto ou contate o administrador do sistema.'

nPosIni := At( '.', pcArqDbf )

For xp := nPosIni To 1 Step -1
	If '\' $ SubStr( pcArqDbf, xp, 1 ) .Or. xp == 1 // Se nao tiver a barra inicial
		cNomArq := SubStr( pcArqDbf, xp + 1, nPosIni -1 )
		Exit
	EndIf
Next

SX3->( DbSetOrder(2) )

For xp := 1 To Len( aSX3s )
	If SX3->( DbSeek( aSX3s[xp] ) )
		Aadd( aStruModel, { aSX3s[xp], SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_DECIMAL } )
	EndIf
Next

Private cTxtMsg2 := 'Nao esta sendo possivel copiar o arquivo '+pcArqDbf+' para o destino '
cTxtMsg2 += '\Workflow\Import\'+cNomArq+'. Entre em contato com o Administrador do sistema. '

// Verificar se o arquivo de destino existe:

MakeDir('\Workflow\Import') // Caso o diretorio nao exista, sera criado automaticamente

If !__CopyFile( pcArqDbf,'\Workflow\Import\'+cNomArq )
	FWrite( nLogStr, cTxtMsg2+cEol )
	Aviso("Erro-Copia",cTxtMsg2,{"&Voltar"},3,"Copia",,"PCOLOCK")
	Return(.f.)
EndIf

If !U_UsarDbf( '\Workflow\Import\'+cNomArq,pcNextAlias )
	FWrite( nLogStr, "Nao foi possivel abrir o arquivo "+cNomArq+cEol )
	Return(.f.)
EndIf

// Verificar se o arquivo modelo existe e caso nao exista, sera criado automaticamente:

If !U_UsarDbf( '\Workflow\Import\StruSAL'+GetDbExtension(),cNxtAlias )
	FWrite( nLogStr, "O arquivo Strusal.dbf devera estar no diretorio \workflow\Import\"+cEol )
	Aviso("Erro-Modelo","O arquivo Strusal.dbf devera estar no diretorio \workflow\Import\",{"&Voltar"},3,"Copia",,"PCOLOCK")
	Return(.f.)
EndIf

Private aStruTmp := (pcNextAlias)->(DbStruct())

For nCompara := 1 To Len( aStruTmp )
	If AllTrim(aStruTmp[nCompara][1]) $ "DATADE/DATAATE"
		Loop
	EndIf
	For nColunas := 2 To 4 // Comparar os atributos dos campos
		If aStruTmp[nCompara][nColunas] # aStruModel[nCompara][nColunas]
			lContinua := .f.
			Exit
		EndIf
	Next
	If !lContinua
		FWrite( nLogStr, cTxtMsg+' |=> Campo: '+aStruModel[nCompara][1]+cEol )
		Aviso("Estrutura",cTxtMsg+' |=> Campo: '+aStruModel[nCompara][1],{"&Fechar"},3,"Estrutura Invalida",,"PCOLOCK")
		Exit
	EndIf
Next

(cNxtAlias)->(DbCloseArea())

Return( lContinua )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณRcomm99g  บAutor  ณ Sergio Oliveira    บ Data ณ  Ago/2008   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Efetua a impressao do antes e depois.                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rcomm99.prw                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Rcomm99g()

Local   Titulo      := "RELATORIO COMPARATIVO"
Local   cDesc1      := "Este programa tem como objetivo imprimir relatorio "
Local   cDesc2      := "de acordo com os parametros informados pelo usuario."
Local   cDesc3      := ""
Local   cPict       := ""
Private aOrd        := ""
Private Tamanho     := "G"
Private Limite      := 220
Private wNrel       := "RCOMM99"
Private cPerg       := PADR("RCOMM99",LEN(SX1->X1_GRUPO))
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

wNrel := SetPrint(cString,wNrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F., aOrd ,.T. ,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

Rcomm99h(Titulo)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ Rcomm99h บAutor  ณSergio Oliveira     บ Data ณ  Ago/2008   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressao das inconsistencias.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rcomm99.prw                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Rcomm99h(Titulo)

Local nCntView, wGr
Local cQuery := "", cStrGr := "", cEol := Chr(13)+Chr(10)
Local aStruSCR := SCR->( DbStruct() )
Public cArqPre := CriaTrab(Nil,.f.)
Private Cabec1 := "                                                                          |----------------------| Aprovacao Atual |---------------------\ /----------------------| Nova Aorovacao |----------------------|"
Private Cabec2 := " Pedido -   Emissao  -  Valor do Pedido -           Usuario               |Grupo -Nv- Cd.Aprov - Cd.Usr. -              Nome              | Grupo -Nv- Cd.Aprov - Cd.Usr. -              Nome             |"

DBCreate(cArqPre,aStruSCR,"TOPCONN") // Cria um clone do SCR no banco de dados

DbUseArea(.t.,"TOPCONN",cArqPre,"SCRCLONE",.F.,.F.)

/*
Este eh o trecho que efetua o tratamento chamando a funcao MT120Gok.prw. Portanto, deve-se obter os
Pedidos de Compras em aberto e que estejam em processo de aprovacao, ou seja, CR_STATUS igual a
02 e 01 sem que no mesmo processo de aprovacao esteja presente o status 04
Deverao ser processados somente os grupos que sofreram alteracoes:
*/

For wGr := 1 To Len( aDiferen )
	
	cStrGr += "'"+aDiferen[wGr]+"'"
	
	If wGr < Len( aDiferen )
		cStrGr += ","
	EndIf
	
Next
/*
cQuery := " SELECT DISTINCT C7_NUM "+cEol
cQuery += " FROM "+RetSqlName('SC7')+" SC7, "+RetSqlName('SCR')+" SCR "+cEol
cQuery += " WHERE C7_FILIAL  = '"+xFilial('SC7')+"' "+cEol
cQuery += " AND   C7_QUJE    = 0 "+cEol
cQuery += " AND   C7_CONAPRO = 'B' "+cEol
cQuery += " AND   C7_ENCER   = ' ' "+cEol
cQuery += " AND   C7_RESIDUO = ' ' "+cEol
cQuery += " AND   C7_TIPO    = 1 "+cEol
cQuery += " AND   C7_CONTRA  = ' ' "+cEol
cQuery += " AND   C7_APROV  IN("+cStrGr+") "+cEol
cQuery += " AND   SC7.D_E_L_E_T_ = ' ' "+cEol
cQuery += " AND   CR_FILIAL = '"+xFilial('SCR')+"' "+cEol
cQuery += " AND   CR_TIPO   = 'PC' "+cEol
cQuery += " AND   CR_NUM    = C7_NUM "+cEol
cQuery += " AND   CR_STATUS IN('01','02') "+cEol
cQuery += " AND   CR_STATUS NOT IN('03','05') "+cEol
cQuery += " AND   SCR.D_E_L_E_T_ = ' ' "+cEol
*/

Work->( DbgoTop() )

cQuery := " SELECT DISTINCT C7_NUM "+cEol
cQuery += " FROM "+RetSqlName('SC7')+" SC7, "+RetSqlName('SCR')+" SCR "+cEol
cQuery += " WHERE C7_FILIAL  = '"+xFilial('SC7')+"' "+cEol
If !Empty( Work->DATADE ) .And. !Empty( Work->DATAATE )
	cQuery += " AND   C7_EMISSAO BETWEEN '"+Dtos(Work->DATADE)+"' AND '"+Dtos(Work->DATAATE)+"' "+cEol
EndIf
cQuery += " AND   C7_QUJE    = 0  "+cEol
cQuery += " AND   C7_CONAPRO = 'B'  "+cEol
cQuery += " AND   C7_ENCER   = ' '  "+cEol
cQuery += " AND   C7_RESIDUO = ' '  "+cEol
cQuery += " AND   C7_TIPO    = 1  "+cEol
cQuery += " AND   C7_CONTRA  = ' '  "+cEol
cQuery += " AND   C7_APROV  IN("+cStrGr+") "+cEol+cEol
cQuery += " AND   SC7.D_E_L_E_T_ = ' '  "+cEol
cQuery += " AND   CR_FILIAL = '"+xFilial('SCR')+"'  "+cEol
cQuery += " AND   CR_TIPO   = 'PC'  "+cEol
cQuery += " AND   CR_NUM    = C7_NUM  "+cEol
cQuery += " AND   CR_STATUS IN('01','02')  "+cEol
cQuery += " AND   SCR.D_E_L_E_T_ = ' '  "+cEol
cQuery += " AND   CR_NUM NOT IN( SELECT CR_NUM FROM "+RetSqlName('SCR')+cEol
cQuery += "                      WHERE CR_FILIAL  = '"+xFilial('SAL')+"' "+cEol
cQuery += "                      AND   CR_TIPO    = 'PC' " +cEol
cQuery += "                      AND   CR_STATUS IN('03','05') "+cEol
cQuery += "                      AND   D_E_L_E_T_ = ' ' ) "+cEol
cQuery += " AND   CR_NUM NOT IN( SELECT CR_NUM FROM "+RetSqlName('SCR')+cEol
cQuery += "                      WHERE CR_FILIAL  = '"+xFilial('SAL')+"' "+cEol
cQuery += "                      AND   CR_TIPO    = 'PC' " +cEol
cQuery += "                      AND   CR_STATUS IN('04') "+cEol
cQuery += "                      AND   D_E_L_E_T_ = ' ' ) "+cEol

FWrite( nLogStr, "Line: "+Alltrim(Str(ProcLine()))+" - Processar somente Pedidos do Grupo: "+cStrGR+cEol )

//Alert("Processar somente Pedidos do Grupo: "+cStrGR)

nCntView := U_MontaView( cQuery, "POSICSC7" )

MemoWrite("C:\TRANSFER\PCS.TXT",cQuery)

//Return

POSICSC7->( DbGotop() )

ProcRegua( nCntView )

While !POSICSC7->( Eof() )
	
	IncProc( 'Obtendo o Antes e Depois...' )
	
	SC7->( DbSetOrder(1), DbSeek( xFilial('SC7')+POSICSC7->C7_NUM ) )
	
	U_Mt120Gok()
	
	POSICSC7->( DbSkip() )
	
EndDo

POSICSC7->( DbGotop() )

ProcRegua( nCntView )

While !POSICSC7->( Eof() )
	
	IncProc( 'IMPRIMINDO o Antes e Depois...' )
	
	SC7->( DbSetOrder(1), DbSeek( xFilial('SC7')+POSICSC7->C7_NUM ) )
	
	If nLin > 58
		nLin := Cabec(Titulo,Cabec1,Cabec2,wNrel,Tamanho,nTipo)
		nLin++
	Endif
	
	cSelClone := " SELECT * FROM "+cArqPre
	cSelClone += " WHERE CR_NUM = '"+SC7->C7_NUM+"' "
	
	U_MontaView( cSelClone, "SELCLONE" )
	
	SELCLONE->( DbGoTop() )
	
	If SC1->( DbSetOrder(1), DbSeek( xFilial("SC1")+SC7->C7_NUMSC ) )
		PswOrder(2) // Ordem de nome do usuario
		PswSeek( SC1->C1_SOLICIT )
		cUsrdoPC := UsrFullName( PswId() )
		
		If Ascan( aNotUsr, { |y| y[2] == SC7->(C7_FILIAL+C7_NUM) } ) == 0
			Aadd( aNotUsr, { UsrRetMail(PswId()), SC7->(C7_FILIAL+C7_NUM),"" } )
			cUsrdoPC := UsrFullName( SC7->C7_USER )
			If !Empty(cUsrdoPC)
				aNotUsr[Len(aNotUsr)][1] += ";"+cUsrdoPC
				FWrite( nLogStr, "Line: "+Alltrim(Str(ProcLine()))+cEol )
			EndIf
		EndIf
		
	Else
		cUsrdoPC := UsrFullName( SC7->C7_USER )

		If Ascan( aNotUsr, { |y| y[2] == SC7->(C7_FILIAL+C7_NUM) } ) == 0
			Aadd( aNotUsr, { UsrRetMail( SC7->C7_USER ), SC7->(C7_FILIAL+C7_NUM),"X" } )
			FWrite( nLogStr, "Line: "+Alltrim(Str(ProcLine()))+cEol )
		EndIf
		
	EndIf
	
	If Empty(cUsrdoPC)
		cUsrdoPC := "Usuario nao localizado"
	EndIf
	
	If SELCLONE->CR_TOTAL == 0 // Nao foi possivel concluir o processo de forma automatica
		
		cUsrdoPC := UsrFullName( SC7->C7_USER )

		If Empty(cUsrdoPC)
			cUsrdoPC := "Usuario nao localizado"
		EndIf
		nSeek := Ascan( aNotUsr, { |y| y[2] == SC7->(C7_FILIAL+C7_NUM) } )
		If nSeek == 0
			Aadd( aNotUsr, { UsrRetMail( SC7->C7_USER ), SC7->(C7_FILIAL+C7_NUM),"X" } )
			FWrite( nLogStr, "Line: "+Alltrim(Str(ProcLine()))+cEol )
		Else
		    aNotUsr[Len(aNotUsr)][1] += ";"+cUsrdoPC
			FWrite( nLogStr, "Line: "+Alltrim(Str(ProcLine()))+cEol )
		EndIf
		Aadd( aAltNaMao, { SC7->C7_NUM, SC7->C7_EMISSAO, cUsrdoPC } )
		
		POSICSC7->( DbSkip() )
		
		Loop
		
	EnDIf
	
	@ nLin,001 Psay SC7->C7_NUM
	@ nLin,010 Psay SC7->C7_EMISSAO
	@ nLin,026 Psay Transform(SELCLONE->CR_TOTAL, "99,999,999.99")
	@ nLin,042 Psay cUsrdoPC
	
	SCR->( DbSetOrder(1), DbSeek( xFilial('SCR')+"PC"+POSICSC7->C7_NUM ) )
	
	While !SCR->( Eof() ) .And. SCR->( CR_FILIAL+CR_TIPO+Trim(CR_NUM) ) == xFilial('SCR')+"PC"+Trim(POSICSC7->C7_NUM)
		
		If nLin > 58
			nLin := Cabec(Titulo,Cabec1,Cabec2,wNrel,Tamanho,nTipo)
			nLin++
		Endif
		//                                                                          |----------------------| Aprovacao Atual |---------------------\ /----------------------| Aprovacao Atual |---------------------|
		// Pedido -   Emissao  -  Valor do Pedido -           Usuario               |Grupo -Nv- Cd.Aprov - Cd.Usr. -              Nome              | Grupo -Nv- Cd.Aprov - Cd.Usr. -              Nome             |
		// 999999   99/99/9999      99,999,999.99   xxxxxxxxxxxxx 30 xxxxxxxxxxxxx   999999 99   999999    999999    XXXXXXXXXXXXX 30 XXXXXXXXXXXXX | 999999 99   999999    999999    XXXXXXXXXXXXX 30 XXXXXXXXXXXXX
		//          |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |
		// 123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.
		//         10        20        30        40        50        60        70        80        90       100       110       120       130       140       150       160       170       180       190       200       210       220
		
		// Antes
		@ nLin,075 PSAY SC7->C7_APROV
		@ nLin,082 PSAY SCR->CR_NIVEL
		@ nLin,087 PSAY SCR->CR_APROV
		@ nLin,097 PSAY SCR->CR_USER
		@ nLin,107 PSAY Left( UsrFullName(SCR->CR_USER), 30 )
		
		// Depois
		If !SELCLONE->( Eof() )
			
			@ nLin,138 PSAY "|"
			@ nLin,140 PSAY SC7->C7_APROV
			@ nLin,147 PSAY SELCLONE->CR_NIVEL
			@ nLin,152 PSAY SELCLONE->CR_APROV
			@ nLin,162 PSAY SELCLONE->CR_USER
			@ nLin,172 PSAY Left( UsrFullName(SELCLONE->CR_USER), 30 )
			
			SELCLONE->( DbSkip() )
			
		EndIf
		
		SCR->( DbSkip() )
		
		nLin ++
		
	EndDo
	
	// Depois - Caso tenha mais niveis no novo formato.
	
	While !SELCLONE->( Eof() )
		
		If nLin > 58
			nLin := Cabec(Titulo,Cabec1,Cabec2,wNrel,Tamanho,nTipo)
			nLin++
		Endif
		
		@ nLin,138 PSAY "|"
		@ nLin,140 PSAY SC7->C7_APROV
		@ nLin,147 PSAY SELCLONE->CR_NIVEL
		@ nLin,152 PSAY SELCLONE->CR_APROV
		@ nLin,162 PSAY SELCLONE->CR_USER
		@ nLin,172 PSAY Left( UsrFullName(SELCLONE->CR_USER), 30 )
		
		nLin ++
		
		SELCLONE->( DbSkip() )
		
	EndDo
	
	@ nLin, 001 Psay __PrtThinLine()
	
	nLin ++
	
	POSICSC7->( DbSkip() )
	
EndDo

// Dar uma relacao dos Pedidos que nao puderam ser alterados automaticamente para que o usuario
// possa interferir manualmente:

If Len( aAltNaMao ) > 0
	nLin := Cabec(Titulo,Cabec1,Cabec2,wNrel,Tamanho,nTipo)
	nLin++
	
	cComQuem := AllTrim( UsrFullName( __cUserId ) )
	cStrQuem := ''
	
	For wXp := 1 To Len(cComQuem)
		
		If SubStr( cComQuem, wXp,1 ) # " "
			cStrQuem += SubStr( cComQuem, wXp,1 )
		Else
			Exit
		EndIf
		
	Next
	
	@ nLin,001 PSAY cStrQuem+","
	
	nLin += 2
	
	@ nLin,001 Psay "Segue abaixo a relacao dos Pedidos de Compras que nao puderam ser alterados automaticamente."
	                                  
	nLin ++
	
	@ nLin,001 Psay "Para estes casos, um e-mail sera enviado para cada SOLICITANTE(apenas informativo), com copia"
	
	nLin ++
	
	@ nLin,001 Psay "para o COMPRADOR RESPONSAVEL(solicitando a alteracao)."

	nLin +=2
	
EndIf

For wV := 1 To Len(aAltNaMao)
	
	If nLin > 58
		nLin := Cabec(Titulo,Cabec1,Cabec2,wNrel,Tamanho,nTipo)
		nLin++
	Endif
	
	//                                                                          |----------------------| Aprovacao Atual |---------------------\ /----------------------| Aprovacao Atual |---------------------|
	// Pedido -   Emissao  -  Valor do Pedido -           Usuario               |Grupo -Nv- Cd.Aprov - Cd.Usr. -              Nome              | Grupo -Nv- Cd.Aprov - Cd.Usr. -              Nome             |
	// 999999   99/99/9999      99,999,999.99   xxxxxxxxxxxxx 30 xxxxxxxxxxxxx   999999 99   999999    999999    XXXXXXXXXXXXX 30 XXXXXXXXXXXXX | 999999 99   999999    999999    XXXXXXXXXXXXX 30 XXXXXXXXXXXXX
	//          |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |         |
	// 123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.
	//         10        20        30        40        50        60        70        80        90       100       110       120       130       140       150       160       170       180       190       200       210       220
	                       
// Imprimir o responsavel pelo pedido. Emitir tambem a notificacao por e-mail(somente os que nao foram automaticos).
// 100040 - 100770
	
	@ nLin,001 PSAY aAltnaMao[wV][1]
	@ nLin,010 PSAY aAltnaMao[wV][2]
	@ nLin,042 PSAY Left( aAltnaMao[wV][3], 30 )
	
	nLin ++
	
Next

Set Device To Screen

If aReturn[5]==1
	DBCommitAll()
	Set Printer To
	OurSpool(wNrel)
Endif

Ms_Flush()

If Select("LOG") > 0
	LOG->( DbCloseArea() )
EndIf

SCRCLONE->( DbCloseArea() )

TcSqlExec("TRUNCATE TABLE "+cArqPre)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ NotifPC  บAutor  ณSergio Oliveira     บ Data ณ  Set/2008   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Notifica automaticamente aos usuarios quanto aos seus PC's บฑฑ
ฑฑบ          ณ alterados em funcao de ajuste no grupo de aprovacao.       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rcomm99.prw                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function NotifPC()

FWrite( nLogStr, "Inicio das notificacoes"+cEol )

Asort( aNotUsr ,,,{ |x,y| x[2] < y[2] } ) // Mandar um so email contendo todos os pedidos do usuario:

SC7->( DbSetOrder(1) )

For xp := 1 To Len( aNotUsr )

	oProcess:= TWFProcess():New( "000001", "Notificacao Avulsa" )
	oProcess:NewTask( "Notificacao Avulsa", "\workflow\HTML\PCAltGrupo.htm" )
	oProcess:UserSiga:= '000000'  // Fixo Administrador
	oProcess:NewVersion(.T.)
	oHtml   := oProcess:oHTML
	xComplm := ""

    xChave  := aNotUsr[xp][1] // Quebra por usuario
    
FWrite( nLogStr, "Notificando "+xChave+cEol )

    While aNotUsr[xp][1] == xChave
	
		SC7->( DbSeek( aNotUsr[xp][2] ) )
		
		If !(Upper( AllTrim( xChave ) ) $ Upper( AllTrim( UsrRetMail(SC7->C7_USER) ) ))
		    xComplm += IIF( !Empty( xComplm ), ";"+Upper( AllTrim( UsrRetMail(SC7->C7_USER) ) ),"" )
		EndIf

		FWrite( nLogStr, "Notificando o PC "+aNotUsr[xp][2]+" -> "+aNotUsr[xp][1]+cEol )

		While !SC7->( Eof() ) .And. SC7->( C7_FILIAL+C7_NUM ) == aNotUsr[xp][2]
		
		    If Ascan( aAltNaMao, { |y| y[1] == SC7->C7_NUM } ) > 0
				FWrite( nLogStr, "ProcLine(): "+Str(ProcLine())+cEol )
				AAdd( (oHtml:ValByName( "t1.0"  )), "A ser alterado por "+UsrFullName(SC7->C7_USER) )
		    Else
				FWrite( nLogStr, "ProcLine(): "+Str(ProcLine())+cEol )
				AAdd( (oHtml:ValByName( "t1.0"  )), "Alterado Automaticamente" )
		    EndIf
	
			AAdd( (oHtml:ValByName( "t1.1"  )), SC7->C7_NUM )
			AAdd( (oHtml:ValByName( "t1.2"  )), SC7->C7_PRODUTO )
			AAdd( (oHtml:ValByName( "t1.3"  )), SC7->C7_DESCRI )
		
			FWrite( nLogStr, "ProcLine(): "+Str(ProcLine())+cEol )
			SC7->( DbSkip() )
		
		EndDo
	
		If xp < Len( aNotUsr )
			FWrite( nLogStr, "ProcLine(): "+Str(ProcLine())+cEol )
			AAdd( (oHtml:ValByName( "t1.0"  )), "--" )
			AAdd( (oHtml:ValByName( "t1.1"  )), "------" )
			AAdd( (oHtml:ValByName( "t1.2"  )), Replicate('-',TamSX3('B1_COD')[1] ) )
			AAdd( (oHtml:ValByName( "t1.3"  )), Replicate('-',TamSX3('C7_DESCRI')[1] ) )
		Else
			FWrite( nLogStr, "ProcLine(): "+Str(ProcLine())+cEol )
		    xp ++
		    Exit
		EndIf
		
		xp ++
	
	EndDo
	
	oHtml:valbyname("contasapagar", UsrFullName( __cUserId ) )
	oHtml:valbyname("emailcp"     , UsrRetMail( __cUserId )  )
	oHtml:valbyname("emailorigem" , IIF( "PRODUCAO"$Upper(GetEnvServer()),"","No ambiente de producao, este email seria enviado para ==> "+xChave+xComplm ) )

	FWrite( nLogStr, "ProcLine(): "+Str(ProcLine())+" - xChave+xComplm: "+xChave+xComplm+cEol )

	oProcess:cTo      := IIF( "PRODUCAO"$Upper(GetEnvServer()),xChave+xComplm,UsrRetMail(__cUserId) )
	oProcess:csubject := IIF( "PRODUCAO"$Upper(GetEnvServer()),"","(Teste de Homologa็ใo)-" )+"Aprova็ใo dos Pedidos de Compras Modificada!!!"
    
	FWrite( nLogStr, "ProcLine(): "+Str(ProcLine())+cEol )
	oProcess:Start()

	xp --
	
Next

Return