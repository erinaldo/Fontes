#Include 'Rwmake.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Rctbm01  ºAutor  ³ Sergio Oliveira    º Data ³  Jul/2007   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa provisorio que efetua a chamada das rotinas padraoº±±
±±º          ³ da contabilicoes.                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RctbM01()

// Gerar o "CLONE" do CTT antes de comecar a contabilizacao offline

GeraClone()
        
SetFunName( "CTBANFE" )

CTBANFE()

SetFunName( "RCTBM01" )

// Eliminar os "CLONES" do CTT e CTH

FechaClone()

Return

User Function RctbM02()

// Gerar o "CLONE" do CTT antes de comecar a contabilizacao offline

GeraClone()

SetFunName( "CTBANFS" )

CTBANFS()

SetFunName( "RCTBM02" )

// Eliminar os "CLONES" do CTT e CTH

FechaClone()

Return

User Function RctbM03()

// Gerar o "CLONE" do CTT antes de comecar a contabilizacao offline

GeraClone()

SetFunName( "ATFA370" )

ATFA370()

SetFunName( "RCTBM03" )

// Eliminar os "CLONES" do CTT e CTH

FechaClone()

Return

User Function RctbM04()

// Gerar o "CLONE" do CTT antes de comecar a contabilizacao offline

GeraClone()

SetFunName( "FINA370" )

FINA370()

SetFunName( "RCTBM04" )

// Eliminar os "CLONES" do CTT e CTH

FechaClone()

Return

User Function RctbM05()

// Gerar o "CLONE" do CTT antes de comecar a contabilizacao offline

GeraClone()

SetFunName( "GPEM110" )

GPEM110()

SetFunName( "RCTBM05" )

// Eliminar os "CLONES" do CTT e CTH

FechaClone()

Return

User Function RctbM06()

// Gerar o "CLONE" do CTT antes de comecar a contabilizacao offline

GeraClone()

SetFunName( "ATFA050" )

ATFA050()

SetFunName( "RCTBM06" )

// Eliminar os "CLONES" do CTT e CTH

FechaClone()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ GeraCloneºAutor  ³ Sergio Oliveira    º Data ³  Out/2008   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que faz a chamada da geracao dos clones das tabelas º±±
±±º          ³ CTT e CTH.                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GeraClone()

// Criar o clone das tabelas CTT e CTH:

Processa( { || IndxCTT() }, 'Aguarde...' )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ FechCloneºAutor  ³ Sergio Oliveira    º Data ³  Out/2008   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que fecha os clones das tabelas CTT e CTH.          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function FechaClone()

CTT->( DbCloseArea('CTT') )
CTH->( DbCloseArea('CTH') )

ChkFile( 'CTT' )  // Abrir o CTT Oficial
TCRefresh('CTT')  // Refresh do alias no cache de tabelas do Top

ChkFile( 'CTH' )  // Abrir o CTT Oficial
TCRefresh('CTH')  // Refresh do alias no cache de tabelas do Top

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³IndxCTT   ºAutor  ³ Sergio Oliveira    º Data ³  Out/2008   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que faz uso dos  arquivos templates CTT e CTH para  º±±
±±º          ³ que os mesmos sejam clonados.                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Contabilizacao offline.                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function IndxCTT()

Local aStruCtt := CTT->( DbStruct() )
Local aStruCth := CTH->( DbStruct() )
Local nStrCt
Local _cArqCTT := CriaTrab( Nil,.f. )
Local _cArqCTH := Left( _cArqCTT,7 )+'a'

If Select('CLONECTT') > 0
	CLONECTT->( DbCloseArea() )
EndIf
If Select('CLONECTH') > 0
	CLONECTH->( DbCloseArea() )
EndIf

__CopyFile( GetNewPar('MV_X_DRCTT','\templates\')+'ctt9902.dbf', GetSrvProfString('StartPath','')+_cArqCTT+'.dbf' )
__CopyFile( GetNewPar('MV_X_DRCTT','\templates\')+'ctt9902.fpt', GetSrvProfString('StartPath','')+_cArqCTT+'.fpt' )
__CopyFile( GetNewPar('MV_X_DRCTT','\templates\')+'ctt9902.cdx', GetSrvProfString('StartPath','')+_cArqCTT+'.cdx' )

__CopyFile( GetNewPar('MV_X_DRCTT','\templates\')+'cth9902.dbf', GetSrvProfString('StartPath','')+_cArqCTH+'.dbf' )
__CopyFile( GetNewPar('MV_X_DRCTT','\templates\')+'cth9902.fpt', GetSrvProfString('StartPath','')+_cArqCTH+'.fpt' )
__CopyFile( GetNewPar('MV_X_DRCTT','\templates\')+'cth9902.cdx', GetSrvProfString('StartPath','')+_cArqCTH+'.cdx' )

DbUseArea(.t.,"DBFCDX",_cArqCTT+'.dbf','CLONECTT',.f.,.f.)
CLONECTT->( DbSetIndex( GetSrvProfString('StartPath','')+_cArqCTT ) )

DbUseArea(.t.,"DBFCDX",_cArqCTH+'.dbf','CLONECTH',.f.,.f.)
CLONECTH->( DbSetIndex( GetSrvProfString('StartPath','')+_cArqCTH ) )

DbSelectArea('CLONECTT')
RecLock('CLONECTT',.f.)  // Nao havera problema de zap em funcao de este arquivo ser exclusivo por Thread
Zap
MsUnLock()

DbSelectArea('CLONECTH')
RecLock('CLONECTH',.f.)  // Nao havera problema de zap em funcao de este arquivo ser exclusivo por Thread
Zap
MsUnLock()

ChkFile('CTT')
ChkFile('CTH')

CTT->( DbGoTop() )

ProcRegua( CTT->( LastRec() ) )

While !CTT->( Eof() )

    IncProc('Obtendo os Centros de Custo...')
	
	CLONECTT->( RecLock('CLONECTT',.t.) )
	For nStrCT := 1 To Len( aStruCTT )
		If CLONECTT->(FieldPos(aStruCTT[nStrCT][1])) > 0
			CLONECTT->&(aStruCTT[nStrCT][1]) := CTT->&(aStruCTT[nStrCT][1])
		EndIf
	Next
	CLONECTT->CTT_RGNV2 := ' '
	CLONECTT->CTT_RGNV3 := ' '
	CLONECTT->( MsUnLock() )
	
	CTT->(DbSkip())
	
EndDo

CTH->( DbGoTop() )

ProcRegua( CTH->( LastRec() ) )

While !CTH->( Eof() )

    IncProc('Obtendo as Operacoes...')
	
	CLONECTH->( RecLock('CLONECTH',.t.) )
	For nStrCT := 1 To Len( aStruCTH )
		If CLONECTH->(FieldPos(aStruCTH[nStrCT][1])) > 0
			CLONECTH->&(aStruCTH[nStrCT][1]) := CTH->&(aStruCTH[nStrCT][1])
		EndIf
	Next
	CLONECTH->CTH_CRGNV2 := ' '
	CLONECTH->( MsUnLock() )
	
	CTH->(DbSkip())
	
EndDo

// Fechar o CTT e CTH oficiais:

CTT->( DbCloseArea("CTT") )
CTH->( DbCloseArea("CTH") )

CLONECTT->( DbCloseArea() )
CLONECTH->( DbCloseArea() )

DbUseArea(.t.,"DBFCDX",_cArqCTT+'.dbf','CTT',.f.,.f.)
CTT->( DbSetIndex( GetSrvProfString('StartPath','')+_cArqCTT ) )

DbUseArea(.t.,"DBFCDX",_cArqCTH+'.dbf','CTH',.f.,.f.)
CTH->( DbSetIndex( GetSrvProfString('StartPath','')+_cArqCTH ) )

Return