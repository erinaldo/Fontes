#Include 'Rwmake.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    � Rcomm98  �Autor  �Sergio Oliveira     � Data �  Ago/2008   ���
�������������������������������������������������������������������������͹��
���Descricao � Gera a exportacao dos grupos de aprovacao para que a manu- ���
���          � tencao seja feita via excel.                               ���
�������������������������������������������������������������������������͹��
���Uso       � CSU.                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function Rcomm98()

Local cArqDBF, nOpc
Private aSays := {}, aButtons := {}

If Select("SAL") == 0
   ChkFile("SAL")
EndIf

AADD(aSays, "Exportacao do cadastro de Grupos de Aprovacao" )
AADD(aSays, "Esta rotina tem como objetivo processar a exporta��o do cadastro" )
AADD(aSays, "de grupos de aprova��o para manipula��o via excel." )

AADD(aButtons, { 1,.T., {|o| nOpc:=1,o:oWnd:End() } } )
AADD(aButtons, { 14,.T.,{|o| cArqDbf := cGetFile("Informe o arquivo a ser gerado Dbf|*.DBF","Selecione...",,,.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE) } } )
AADD(aButtons, { 2,.T., {|o| o:oWnd:End() }} )

FormBatch( 'Manuten��o do grupo de aprovadores', aSays, aButtons,,240,425 )

If nOpc <> 1
	Return
Else
	If Empty( cArqDbf )
		Aviso('Sem Arquivo Selecionado','Nao houve arquivo selecionado.',{'Voltar'})
	Else
		Processa( { || Rcomm98a(cArqDbf) }, 'Efetuando a exporta��o dos grupos...' )

		Aviso("Exporta��o dos grupos","T�rmino de execu��o.",;
		{"&Fechar"},3,"Grupos via Excel",,;
		"PMSAPONT")

	EndIf
Endif

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    � Rcomm98a �Autor  �Sergio Oliveira     � Data �  Ago/2008   ���
�������������������������������������������������������������������������͹��
���Desc.     � Processamento da exportacao.                               ���
�������������������������������������������������������������������������͹��
���Uso       � Rcomm98.prw                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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