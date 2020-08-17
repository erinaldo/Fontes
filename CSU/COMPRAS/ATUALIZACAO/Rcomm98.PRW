#Include 'Rwmake.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ Rcomm98  บAutor  ณSergio Oliveira     บ Data ณ  Ago/2008   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Gera a exportacao dos grupos de aprovacao para que a manu- บฑฑ
ฑฑบ          ณ tencao seja feita via excel.                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU.                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function Rcomm98()

Local cArqDBF, nOpc
Private aSays := {}, aButtons := {}

If Select("SAL") == 0
   ChkFile("SAL")
EndIf

AADD(aSays, "Exportacao do cadastro de Grupos de Aprovacao" )
AADD(aSays, "Esta rotina tem como objetivo processar a exporta็ใo do cadastro" )
AADD(aSays, "de grupos de aprova็ใo para manipula็ใo via excel." )

AADD(aButtons, { 1,.T., {|o| nOpc:=1,o:oWnd:End() } } )
AADD(aButtons, { 14,.T.,{|o| cArqDbf := cGetFile("Informe o arquivo a ser gerado Dbf|*.DBF","Selecione...",,,.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE) } } )
AADD(aButtons, { 2,.T., {|o| o:oWnd:End() }} )

FormBatch( 'Manuten็ใo do grupo de aprovadores', aSays, aButtons,,240,425 )

If nOpc <> 1
	Return
Else
	If Empty( cArqDbf )
		Aviso('Sem Arquivo Selecionado','Nao houve arquivo selecionado.',{'Voltar'})
	Else
		Processa( { || Rcomm98a(cArqDbf) }, 'Efetuando a exporta็ใo dos grupos...' )

		Aviso("Exporta็ใo dos grupos","T้rmino de execu็ใo.",;
		{"&Fechar"},3,"Grupos via Excel",,;
		"PMSAPONT")

	EndIf
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ Rcomm98a บAutor  ณSergio Oliveira     บ Data ณ  Ago/2008   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processamento da exportacao.                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rcomm98.prw                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Rcomm98a(pcArqDbf)

Local aStruSAL := SAL->( DbStruct() )
Local cArqSAL

If AllTrim( Upper( Right( pcArqDbf,4 ) ) ) # '.DBF'
    pcArqDBF := AllTrim( pcArqDbf )+".DBF"
EndIf

cArqSAL := U_CriaTMP( aStruSAL, "Work" )

SAL->( DbGoTop(), DbSetOrder(2) ) // AL_FILIAL+AL_COD+AL_NIVEL

ProcRegua( SAL->( LastRec() ) )

While !SAL->( Eof() )

     IncProc()

     Work->( RecLock("Work",.t.) )
     For xp := 1 To Len( aStruSAL )
	     Work->&(aStruSAL[xp][1]) := SAL->&(aStruSAL[xp][1])
     Next
     Work->( MsUnLock() )

     SAL->( DbSkip() )

EndDo

Work->( DbCloseArea() )

If !__CopyFile( GetSrvProfString("StartPath","")+cArqSAL, pcArqDbf )
    MsgBox("Nao esta sendo possivel copiar o arquivo para o diretorio "+pcArqDbf,"Problema na Copia","Alert")
EndIf

Return