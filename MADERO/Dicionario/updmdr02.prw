#INCLUDE "PROTHEUS.CH"

#DEFINE SIMPLES Char( 39 )
#DEFINE DUPLAS  Char( 34 )

#DEFINE CSSBOTAO	"QPushButton { color: #024670; "+;
"    border-image: url(rpo:fwstd_btn_nml.png) 3 3 3 3 stretch; "+;
"    border-top-width: 3px; "+;
"    border-left-width: 3px; "+;
"    border-right-width: 3px; "+;
"    border-bottom-width: 3px }"+;
"QPushButton:pressed {	color: #FFFFFF; "+;
"    border-image: url(rpo:fwstd_btn_prd.png) 3 3 3 3 stretch; "+;
"    border-top-width: 3px; "+;
"    border-left-width: 3px; "+;
"    border-right-width: 3px; "+;
"    border-bottom-width: 3px }"

//--------------------------------------------------------------------
/*/{Protheus.doc} UPDMDR02
Fun��o de update de dicion�rios para compatibiliza��o

@author TOTVS Protheus
@since  16/05/2018
@obs    Gerado por EXPORDIC - V.5.4.1.2 EFS / Upd. V.4.21.17 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
User Function UPDMDR02( cEmpAmb, cFilAmb )

Local   aSay      := {}
Local   aButton   := {}
Local   aMarcadas := {}
Local   cTitulo   := "ATUALIZA��O DE DICION�RIOS E TABELAS"
Local   cDesc1    := "Esta rotina tem como fun��o fazer  a atualiza��o  dos dicion�rios do Sistema ( SX?/SIX )"
Local   cDesc2    := "Este processo deve ser executado em modo EXCLUSIVO, ou seja n�o podem haver outros"
Local   cDesc3    := "usu�rios  ou  jobs utilizando  o sistema.  � EXTREMAMENTE recomendav�l  que  se  fa�a um"
Local   cDesc4    := "BACKUP  dos DICION�RIOS  e da  BASE DE DADOS antes desta atualiza��o, para que caso "
Local   cDesc5    := "ocorram eventuais falhas, esse backup possa ser restaurado."
Local   cDesc6    := ""
Local   cDesc7    := ""
Local   lOk       := .F.
Local   lAuto     := ( cEmpAmb <> NIL .or. cFilAmb <> NIL )

Private oMainWnd  := NIL
Private oProcess  := NIL

#IFDEF TOP
    TCInternal( 5, "*OFF" ) // Desliga Refresh no Lock do Top
#ENDIF

__cInterNet := NIL
__lPYME     := .F.

Set Dele On

// Mensagens de Tela Inicial
aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )
aAdd( aSay, cDesc4 )
aAdd( aSay, cDesc5 )
//aAdd( aSay, cDesc6 )
//aAdd( aSay, cDesc7 )

// Botoes Tela Inicial
aAdd(  aButton, {  1, .T., { || lOk := .T., FechaBatch() } } )
aAdd(  aButton, {  2, .T., { || lOk := .F., FechaBatch() } } )

If lAuto
	lOk := .T.
Else
	FormBatch(  cTitulo,  aSay,  aButton )
EndIf

If lOk
	If lAuto
		aMarcadas :={{ cEmpAmb, cFilAmb, "" }}
	Else

		If !FWAuthAdmin()
			Final( "Atualiza��o n�o Realizada." )
		EndIf

		aMarcadas := EscEmpresa()
	EndIf

	If !Empty( aMarcadas )
		If lAuto .OR. MsgNoYes( "Confirma a atualiza��o dos dicion�rios ?", cTitulo )
			oProcess := MsNewProcess():New( { | lEnd | lOk := FSTProc( @lEnd, aMarcadas, lAuto ) }, "Atualizando", "Aguarde, atualizando ...", .F. )
			oProcess:Activate()

			If lAuto
				If lOk
					MsgStop( "Atualiza��o Realizada.", "UPDMDR02" )
				Else
					MsgStop( "Atualiza��o n�o Realizada.", "UPDMDR02" )
				EndIf
				dbCloseAll()
			Else
				If lOk
					Final( "Atualiza��o Realizada." )
				Else
					Final( "Atualiza��o n�o Realizada." )
				EndIf
			EndIf

		Else
			Final( "Atualiza��o n�o Realizada." )

		EndIf

	Else
		Final( "Atualiza��o n�o Realizada." )

	EndIf

EndIf

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSTProc
Fun��o de processamento da grava��o dos arquivos

@author TOTVS Protheus
@since  16/05/2018
@obs    Gerado por EXPORDIC - V.5.4.1.2 EFS / Upd. V.4.21.17 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSTProc( lEnd, aMarcadas, lAuto )
Local   aInfo     := {}
Local   aRecnoSM0 := {}
Local   cAux      := ""
Local   cFile     := ""
Local   cFileLog  := ""
Local   cMask     := "Arquivos Texto" + "(*.TXT)|*.txt|"
Local   cTCBuild  := "TCGetBuild"
Local   cTexto    := ""
Local   cTopBuild := ""
Local   lOpen     := .F.
Local   lRet      := .T.
Local   nI        := 0
Local   nPos      := 0
Local   nRecno    := 0
Local   nX        := 0
Local   oDlg      := NIL
Local   oFont     := NIL
Local   oMemo     := NIL

Private aArqUpd   := {}

If ( lOpen := MyOpenSm0(.T.) )

	dbSelectArea( "SM0" )
	dbGoTop()

	While !SM0->( EOF() )
		// S� adiciona no aRecnoSM0 se a empresa for diferente
		If aScan( aRecnoSM0, { |x| x[2] == SM0->M0_CODIGO } ) == 0 ;
		   .AND. aScan( aMarcadas, { |x| x[1] == SM0->M0_CODIGO } ) > 0
			aAdd( aRecnoSM0, { Recno(), SM0->M0_CODIGO } )
		EndIf
		SM0->( dbSkip() )
	End

	SM0->( dbCloseArea() )

	If lOpen

		For nI := 1 To Len( aRecnoSM0 )

			If !( lOpen := MyOpenSm0(.F.) )
				MsgStop( "Atualiza��o da empresa " + aRecnoSM0[nI][2] + " n�o efetuada." )
				Exit
			EndIf

			SM0->( dbGoTo( aRecnoSM0[nI][1] ) )

			RpcSetType( 3 )
			RpcSetEnv( SM0->M0_CODIGO, SM0->M0_CODFIL )

			lMsFinalAuto := .F.
			lMsHelpAuto  := .F.

			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( Replicate( " ", 128 ) )
			AutoGrLog( "LOG DA ATUALIZA��O DOS DICION�RIOS" )
			AutoGrLog( Replicate( " ", 128 ) )
			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( " " )
			AutoGrLog( " Dados Ambiente" )
			AutoGrLog( " --------------------" )
			AutoGrLog( " Empresa / Filial...: " + cEmpAnt + "/" + cFilAnt )
			AutoGrLog( " Nome Empresa.......: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_NOMECOM", cEmpAnt + cFilAnt, 1, "" ) ) ) )
			AutoGrLog( " Nome Filial........: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_FILIAL" , cEmpAnt + cFilAnt, 1, "" ) ) ) )
			AutoGrLog( " DataBase...........: " + DtoC( dDataBase ) )
			AutoGrLog( " Data / Hora �nicio.: " + DtoC( Date() )  + " / " + Time() )
			AutoGrLog( " Environment........: " + GetEnvServer()  )
			AutoGrLog( " StartPath..........: " + GetSrvProfString( "StartPath", "" ) )
			AutoGrLog( " RootPath...........: " + GetSrvProfString( "RootPath" , "" ) )
			AutoGrLog( " Vers�o.............: " + GetVersao(.T.) )
			AutoGrLog( " Usu�rio TOTVS .....: " + __cUserId + " " +  cUserName )
			AutoGrLog( " Computer Name......: " + GetComputerName() )

			aInfo   := GetUserInfo()
			If ( nPos    := aScan( aInfo,{ |x,y| x[3] == ThreadId() } ) ) > 0
				AutoGrLog( " " )
				AutoGrLog( " Dados Thread" )
				AutoGrLog( " --------------------" )
				AutoGrLog( " Usu�rio da Rede....: " + aInfo[nPos][1] )
				AutoGrLog( " Esta��o............: " + aInfo[nPos][2] )
				AutoGrLog( " Programa Inicial...: " + aInfo[nPos][5] )
				AutoGrLog( " Environment........: " + aInfo[nPos][6] )
				AutoGrLog( " Conex�o............: " + AllTrim( StrTran( StrTran( aInfo[nPos][7], Chr( 13 ), "" ), Chr( 10 ), "" ) ) )
			EndIf
			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( " " )

			If !lAuto
				AutoGrLog( Replicate( "-", 128 ) )
				AutoGrLog( "Empresa : " + SM0->M0_CODIGO + "/" + SM0->M0_NOME + CRLF )
			EndIf

			oProcess:SetRegua1( 8 )


			oProcess:IncRegua1( "Dicion�rio de arquivos" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSX2()


			FSAtuSX3()


			oProcess:IncRegua1( "Dicion�rio de �ndices" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSIX()

			oProcess:IncRegua1( "Dicion�rio de dados" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			oProcess:IncRegua2( "Atualizando campos/�ndices" )

			// Altera��o f�sica dos arquivos
			__SetX31Mode( .F. )

			If FindFunction(cTCBuild)
				cTopBuild := &cTCBuild.()
			EndIf

			For nX := 1 To Len( aArqUpd )

				If cTopBuild >= "20090811" .AND. TcInternal( 89 ) == "CLOB_SUPPORTED"
					If ( ( aArqUpd[nX] >= "NQ " .AND. aArqUpd[nX] <= "NZZ" ) .OR. ( aArqUpd[nX] >= "O0 " .AND. aArqUpd[nX] <= "NZZ" ) ) .AND.;
						!aArqUpd[nX] $ "NQD,NQF,NQP,NQT"
						TcInternal( 25, "CLOB" )
					EndIf
				EndIf

				If Select( aArqUpd[nX] ) > 0
					dbSelectArea( aArqUpd[nX] )
					dbCloseArea()
				EndIf

				X31UpdTable( aArqUpd[nX] )

				If __GetX31Error()
					Alert( __GetX31Trace() )
					MsgStop( "Ocorreu um erro desconhecido durante a atualiza��o da tabela : " + aArqUpd[nX] + ". Verifique a integridade do dicion�rio e da tabela.", "ATEN��O" )
					AutoGrLog( "Ocorreu um erro desconhecido durante a atualiza��o da estrutura da tabela : " + aArqUpd[nX] )
				EndIf

				If cTopBuild >= "20090811" .AND. TcInternal( 89 ) == "CLOB_SUPPORTED"
					TcInternal( 25, "OFF" )
				EndIf

			Next nX


			oProcess:IncRegua1( "Dicion�rio de par�metros" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSX6()

			oProcess:IncRegua1( "Dicion�rio de consultas padr�o" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSXB()

			oProcess:IncRegua1( "Helps de Campo" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuHlp()

			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( " Data / Hora Final.: " + DtoC( Date() ) + " / " + Time() )
			AutoGrLog( Replicate( "-", 128 ) )

			RpcClearEnv()

		Next nI

		If !lAuto

			cTexto := LeLog()

			Define Font oFont Name "Mono AS" Size 5, 12

			Define MsDialog oDlg Title "Atualiza��o concluida." From 3, 0 to 340, 417 Pixel

			@ 5, 5 Get oMemo Var cTexto Memo Size 200, 145 Of oDlg Pixel
			oMemo:bRClicked := { || AllwaysTrue() }
			oMemo:oFont     := oFont

			Define SButton From 153, 175 Type  1 Action oDlg:End() Enable Of oDlg Pixel // Apaga
			Define SButton From 153, 145 Type 13 Action ( cFile := cGetFile( cMask, "" ), If( cFile == "", .T., ;
			MemoWrite( cFile, cTexto ) ) ) Enable Of oDlg Pixel

			Activate MsDialog oDlg Center

		EndIf

	EndIf

Else

	lRet := .F.

EndIf

Return lRet


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSX2
Fun��o de processamento da grava��o do SX2 - Arquivos

@author TOTVS Protheus
@since  16/05/2018
@obs    Gerado por EXPORDIC - V.5.4.1.2 EFS / Upd. V.4.21.17 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSX2()
Local aEstrut   := {}
Local aSX2      := {}
Local cAlias    := ""
Local cCpoUpd   := "X2_ROTINA /X2_UNICO  /X2_DISPLAY/X2_SYSOBJ /X2_USROBJ /X2_POSLGT /"
Local cEmpr     := ""
Local cPath     := ""
Local nI        := 0
Local nJ        := 0

AutoGrLog( "�nicio da Atualiza��o" + " SX2" + CRLF )

aEstrut := { "X2_CHAVE"  , "X2_PATH"   , "X2_ARQUIVO", "X2_NOME"   , "X2_NOMESPA", "X2_NOMEENG", "X2_MODO"   , ;
             "X2_TTS"    , "X2_ROTINA" , "X2_PYME"   , "X2_UNICO"  , "X2_DISPLAY", "X2_SYSOBJ" , "X2_USROBJ" , ;
             "X2_POSLGT" , "X2_CLOB"   , "X2_AUTREC" , "X2_MODOEMP", "X2_MODOUN" , "X2_MODULO" }


dbSelectArea( "SX2" )
SX2->( dbSetOrder( 1 ) )
SX2->( dbGoTop() )
cPath := SX2->X2_PATH
cPath := IIf( Right( AllTrim( cPath ), 1 ) <> "\", PadR( AllTrim( cPath ) + "\", Len( cPath ) ), cPath )
cEmpr := Substr( SX2->X2_ARQUIVO, 4 )

aAdd( aSX2, {'ZI1',cPath,'ZI1'+cEmpr,'PRE INSPECAO DE ENTRADA','PRE INSPECAO DE ENTRADA','PRE INSPECAO DE ENTRADA','E','','','','','','','','','','','E','E',0} )
aAdd( aSX2, {'ZI2',cPath,'ZI2'+cEmpr,'ITENS DA PRE INSPECAO','ITENS DA PRE INSPECAO','ITENS DA PRE INSPECAO','E','','','','','','','','','','','E','E',0} )
aAdd( aSX2, {'ZI3',cPath,'ZI3'+cEmpr,'PALLETS DO ITEM DA PREINSPECAO','PALLETS DO ITEM DA PREINSPECAO','PALLETS DO ITEM DA PREINSPECAO','E','','','','','','','','','','','E','E',0} )
aAdd( aSX2, {'ZI4',cPath,'ZI4'+cEmpr,'REGISTRO SIF, EMBARQUE E LOTE','REGISTRO SIF, EMBARQUE E LOTE','REGISTRO SIF, EMBARQUE E LOTE','E','','','','','','','','','','','E','E',0} )
aAdd( aSX2, {'ZI5',cPath,'ZI5'+cEmpr,'NAO CONFORMIDADES DO PALLET','NAO CONFORMIDADES DO PALLET','NAO CONFORMIDADES DO PALLET','E','','','','','','','','','','','E','E',0} )
aAdd( aSX2, {'ZI6',cPath,'ZI6'+cEmpr,'DIVERG�NCIAS DA INSPE��O','DIVERG�NCIAS DA INSPE��O','DIVERG�NCIAS DA INSPE��O','E','','','','','','','','','','','E','E',0} )
aAdd( aSX2, {'ZI7',cPath,'ZI7'+cEmpr,'EVENTOS DA INSPE��O','EVENTOS DA INSPE��O','EVENTOS DA INSPE��O','E','','','','','','','','','','','E','E',0} )
//
// Atualizando dicion�rio
//
oProcess:SetRegua2( Len( aSX2 ) )

dbSelectArea( "SX2" )
dbSetOrder( 1 )

For nI := 1 To Len( aSX2 )

	oProcess:IncRegua2( "Atualizando Arquivos (SX2)..." )

	If !SX2->( dbSeek( aSX2[nI][1] ) )

		If !( aSX2[nI][1] $ cAlias )
			cAlias += aSX2[nI][1] + "/"
			AutoGrLog( "Foi inclu�da a tabela " + aSX2[nI][1] )
		EndIf

		RecLock( "SX2", .T. )
		For nJ := 1 To Len( aSX2[nI] )
			If FieldPos( aEstrut[nJ] ) > 0
				If AllTrim( aEstrut[nJ] ) == "X2_ARQUIVO"
					FieldPut( FieldPos( aEstrut[nJ] ), SubStr( aSX2[nI][nJ], 1, 3 ) + cEmpAnt +  "0" )
				Else
					FieldPut( FieldPos( aEstrut[nJ] ), aSX2[nI][nJ] )
				EndIf
			EndIf
		Next nJ
		MsUnLock()

	Else

		If  !( StrTran( Upper( AllTrim( SX2->X2_UNICO ) ), " ", "" ) == StrTran( Upper( AllTrim( aSX2[nI][12]  ) ), " ", "" ) )
			RecLock( "SX2", .F. )
			SX2->X2_UNICO := aSX2[nI][12]
			MsUnlock()

			If MSFILE( RetSqlName( aSX2[nI][1] ),RetSqlName( aSX2[nI][1] ) + "_UNQ"  )
				TcInternal( 60, RetSqlName( aSX2[nI][1] ) + "|" + RetSqlName( aSX2[nI][1] ) + "_UNQ" )
			EndIf

			AutoGrLog( "Foi alterada a chave �nica da tabela " + aSX2[nI][1] )
		EndIf

		RecLock( "SX2", .F. )
		For nJ := 1 To Len( aSX2[nI] )
			If FieldPos( aEstrut[nJ] ) > 0
				If PadR( aEstrut[nJ], 10 ) $ cCpoUpd
					FieldPut( FieldPos( aEstrut[nJ] ), aSX2[nI][nJ] )
				EndIf

			EndIf
		Next nJ
		MsUnLock()

	EndIf

Next nI

AutoGrLog( CRLF + "Final da Atualiza��o" + " SX2" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSX3
Fun��o de processamento da grava��o do SX3 - Campos

@author TOTVS Protheus
@since  16/05/2018
@obs    Gerado por EXPORDIC - V.5.4.1.2 EFS / Upd. V.4.21.17 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSX3()
Local aEstrut   := {}
Local aSX3      := {}
Local cAlias    := ""
Local cAliasAtu := ""
Local cMsg      := ""
Local cSeqAtu   := ""
Local cX3Campo  := ""
Local cX3Dado   := ""
Local lTodosNao := .F.
Local lTodosSim := .F.
Local nI        := 0
Local nJ        := 0
Local nOpcA     := 0
Local nPosArq   := 0
Local nPosCpo   := 0
Local nPosOrd   := 0
Local nPosSXG   := 0
Local nPosTam   := 0
Local nPosVld   := 0
Local nSeqAtu   := 0
Local nTamSeek  := Len( SX3->X3_CAMPO )

AutoGrLog( "�nicio da Atualiza��o" + " SX3" + CRLF )

aEstrut := { { "X3_ARQUIVO", 0 }, { "X3_ORDEM"  , 0 }, { "X3_CAMPO"  , 0 }, { "X3_TIPO"   , 0 }, { "X3_TAMANHO", 0 }, { "X3_DECIMAL", 0 }, { "X3_TITULO" , 0 }, ;
             { "X3_TITSPA" , 0 }, { "X3_TITENG" , 0 }, { "X3_DESCRIC", 0 }, { "X3_DESCSPA", 0 }, { "X3_DESCENG", 0 }, { "X3_PICTURE", 0 }, { "X3_VALID"  , 0 }, ;
             { "X3_USADO"  , 0 }, { "X3_RELACAO", 0 }, { "X3_F3"     , 0 }, { "X3_NIVEL"  , 0 }, { "X3_RESERV" , 0 }, { "X3_CHECK"  , 0 }, { "X3_TRIGGER", 0 }, ;
             { "X3_PROPRI" , 0 }, { "X3_BROWSE" , 0 }, { "X3_VISUAL" , 0 }, { "X3_CONTEXT", 0 }, { "X3_OBRIGAT", 0 }, { "X3_VLDUSER", 0 }, { "X3_CBOX"   , 0 }, ;
             { "X3_CBOXSPA", 0 }, { "X3_CBOXENG", 0 }, { "X3_PICTVAR", 0 }, { "X3_WHEN"   , 0 }, { "X3_INIBRW" , 0 }, { "X3_GRPSXG" , 0 }, { "X3_FOLDER" , 0 }, ;
             { "X3_CONDSQL", 0 }, { "X3_CHKSQL" , 0 }, { "X3_IDXSRV" , 0 }, { "X3_ORTOGRA", 0 }, { "X3_TELA"   , 0 }, { "X3_POSLGT" , 0 }, { "X3_IDXFLD" , 0 }, ;
             { "X3_AGRUP"  , 0 }, { "X3_MODAL"  , 0 }, { "X3_PYME"   , 0 } }

aEval( aEstrut, { |x| x[2] := SX3->( FieldPos( x[1] ) ) } )

aAdd( aSX3, {{'SA2',.T.},{'N8',.T.},{'A2_MAILDIV',.T.},{'C',.T.},{100,.T.},{0,.T.},{'Email PreIns',.T.},{'Email PreIns',.T.},{'Email PreIns',.T.},{'Email PreInspecao Entrada',.T.},{'Email PreInspecao Entrada',.T.},{'Email PreInspecao Entrada',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'SD1',.T.},{'X7',.T.},{'D1_PIPSTAT',.T.},{'C',.T.},{1,.T.},{0,.T.},{'Pre Inspe��o',.T.},{'Pre Inspe��o',.T.},{'Pre Inspe��o',.T.},{'Status da Pre Inspe��o',.T.},{'Status da Pre Inspe��o',.T.},{'Status da Pre Inspe��o',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'"N"',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'percente("NBL ")',.T.},{'N=N�o;S=Inspeciona',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'SD7',.T.},{'41',.T.},{'D7_PALLET',.T.},{'C',.T.},{30,.T.},{0,.T.},{'ID Pallet',.T.},{'ID Pallet',.T.},{'ID Pallet',.T.},{'Identifica��o do Pallet',.T.},{'Identifica��o do Pallet',.T.},{'Identifica��o do Pallet',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'068',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'SD7',.T.},{'42',.T.},{'D7_DOCTRF',.T.},{'C',.T.},{6,.T.},{0,.T.},{'Doc. Transf.',.T.},{'Doc. Transf.',.T.},{'Doc. Transf.',.T.},{'DocSeq Transferencia LOTE',.T.},{'DocSeq Transferencia LOTE',.T.},{'DocSeq Transferencia LOTE',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'SF1',.T.},{'J4',.T.},{'F1_PIPSTAT',.T.},{'C',.T.},{1,.T.},{0,.T.},{'Pre Inspe��o',.T.},{'Pre Inspe��o',.T.},{'Pre Inspe��o',.T.},{'Status da Pre Inspe��o',.T.},{'Status da Pre Inspe��o',.T.},{'Status da Pre Inspe��o',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'pertence("BL ")',.T.},{'B=Bloqueado;L=Liberado para Classifica��o',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI1',.T.},{'01',.T.},{'ZI1_FILIAL',.T.},{'C',.T.},{2,.T.},{0,.T.},{'Filial',.T.},{'Sucursal',.T.},{'Branch',.T.},{'Filial do Sistema',.T.},{'Sucursal',.T.},{'Branch of the System',.T.},{'@!',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),.T.},{'',.T.},{'',.T.},{1,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'033',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI1',.T.},{'02',.T.},{'ZI1_DOC',.T.},{'C',.T.},{9,.T.},{0,.T.},{'Numero',.T.},{'Numero',.T.},{'Numero',.T.},{'Numero do documento',.T.},{'Numero do documento',.T.},{'Numero do documento',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'SF1PIN',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'018',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI1',.T.},{'03',.T.},{'ZI1_SERIE',.T.},{'C',.T.},{3,.T.},{0,.T.},{'Serie',.T.},{'Serie',.T.},{'Serie',.T.},{'Serie do Documento',.T.},{'Serie do Documento',.T.},{'Serie do Documento',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'094',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI1',.T.},{'04',.T.},{'ZI1_FORN',.T.},{'C',.T.},{6,.T.},{0,.T.},{'Fornecedor',.T.},{'Fornecedor',.T.},{'Fornecedor',.T.},{'Codigo do fornecedor',.T.},{'Codigo do fornecedor',.T.},{'Codigo do fornecedor',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'001',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI1',.T.},{'05',.T.},{'ZI1_LOJA',.T.},{'C',.T.},{2,.T.},{0,.T.},{'Loja',.T.},{'Loja',.T.},{'Loja',.T.},{'Loja do fornecedor',.T.},{'Loja do fornecedor',.T.},{'Loja do fornecedor',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'002',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI1',.T.},{'06',.T.},{'ZI1_DTINIC',.T.},{'D',.T.},{8,.T.},{0,.T.},{'Data Inicio',.T.},{'Data Inicio',.T.},{'Data Inicio',.T.},{'Data Inicio da Inspe��o',.T.},{'Data Inicio da Inspe��o',.T.},{'Data Inicio da Inspe��o',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI1',.T.},{'07',.T.},{'ZI1_HRINIC',.T.},{'C',.T.},{5,.T.},{0,.T.},{'Hora Inicio',.T.},{'Hora Inicio',.T.},{'Hora Inicio',.T.},{'Hora Inicio da Inspe��o',.T.},{'Hora Inicio da Inspe��o',.T.},{'Hora Inicio da Inspe��o',.T.},{'99:99',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI1',.T.},{'08',.T.},{'ZI1_INSP',.T.},{'C',.T.},{6,.T.},{0,.T.},{'Inspetor',.T.},{'Inspetor',.T.},{'Inspetor',.T.},{'Codigo Usu�rio Inspetor',.T.},{'Codigo Usu�rio Inspetor',.T.},{'Codigo Usu�rio Inspetor',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI1',.T.},{'09',.T.},{'ZI1_INSPN',.T.},{'C',.T.},{30,.T.},{0,.T.},{'Nome Inspet.',.T.},{'Nome Inspet.',.T.},{'Nome Inspet.',.T.},{'Nome do Inspetor',.T.},{'Nome do Inspetor',.T.},{'Nome do Inspetor',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI1',.T.},{'10',.T.},{'ZI1_ID',.T.},{'C',.T.},{6,.T.},{0,.T.},{'ID Inspe��o',.T.},{'ID Inspe��o',.T.},{'ID Inspe��o',.T.},{'Identificador da Inspe��o',.T.},{'Identificador da Inspe��o',.T.},{'Identificador da Inspe��o',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI1',.T.},{'11',.T.},{'ZI1_TIPO',.T.},{'C',.T.},{1,.T.},{0,.T.},{'Tipo',.T.},{'Tipo',.T.},{'Tipo',.T.},{'Tipo de Inspe��o',.T.},{'Tipo de Inspe��o',.T.},{'Tipo de Inspe��o',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'pertence("FHM")',.T.},{'F=FRIGORIFICO;H=HORTIFRUTI;M=MERCEARIA',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI1',.T.},{'12',.T.},{'ZI1_STATUS',.T.},{'C',.T.},{1,.T.},{0,.T.},{'Status',.T.},{'Status',.T.},{'Status',.T.},{'Status da Inspe��o',.T.},{'Status da Inspe��o',.T.},{'Status da Inspe��o',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'I=Iniciado;E=Encerrado;R=Rejeitado',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI2',.T.},{'01',.T.},{'ZI2_FILIAL',.T.},{'C',.T.},{2,.T.},{0,.T.},{'Filial',.T.},{'Sucursal',.T.},{'Branch',.T.},{'Filial do Sistema',.T.},{'Sucursal',.T.},{'Branch of the System',.T.},{'@!',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),.T.},{'',.T.},{'',.T.},{1,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'033',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI2',.T.},{'02',.T.},{'ZI2_ID',.T.},{'C',.T.},{6,.T.},{0,.T.},{'ID Inspe��o',.T.},{'ID Inspe��o',.T.},{'ID Inspe��o',.T.},{'Identificador da Inspe��o',.T.},{'Identificador da Inspe��o',.T.},{'Identificador da Inspe��o',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI2',.T.},{'03',.T.},{'ZI2_PROD',.T.},{'C',.T.},{15,.T.},{0,.T.},{'Produto',.T.},{'Produto',.T.},{'Produto',.T.},{'C�digo do Produto',.T.},{'C�digo do Produto',.T.},{'C�digo do Produto',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'030',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI2',.T.},{'04',.T.},{'ZI2_DESC',.T.},{'C',.T.},{30,.T.},{0,.T.},{'Descri��o',.T.},{'Descri��o',.T.},{'Descri��o',.T.},{'Descri��o do Produto',.T.},{'Descri��o do Produto',.T.},{'Descri��o do Produto',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI2',.T.},{'05',.T.},{'ZI2_UM',.T.},{'C',.T.},{2,.T.},{0,.T.},{'Unidade',.T.},{'Unidade',.T.},{'Unidade',.T.},{'Unidade de Medida',.T.},{'Unidade de Medida',.T.},{'Unidade de Medida',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI2',.T.},{'06',.T.},{'ZI2_QUANT',.T.},{'N',.T.},{14,.T.},{5,.T.},{'Quantidade',.T.},{'Quantidade',.T.},{'Quantidade',.T.},{'Quantidade da Nota',.T.},{'Quantidade da Nota',.T.},{'Quantidade da Nota',.T.},{'@E 99,999,999.99999',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI2',.T.},{'07',.T.},{'ZI2_INSP',.T.},{'N',.T.},{14,.T.},{5,.T.},{'Inspecionada',.T.},{'Inspecionada',.T.},{'Inspecionada',.T.},{'Quantidade Inspecionada',.T.},{'Quantidade Inspecionada',.T.},{'Quantidade Inspecionada',.T.},{'@E 99,999,999.99999',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI2',.T.},{'08',.T.},{'ZI2_STATUS',.T.},{'C',.T.},{1,.T.},{0,.T.},{'Status',.T.},{'Status',.T.},{'Status',.T.},{'Status da Inspe��o Item',.T.},{'Status da Inspe��o Item',.T.},{'Status da Inspe��o Item',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'P=Pendente;I=Inspecionando;C=Concluido',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI3',.T.},{'01',.T.},{'ZI3_FILIAL',.T.},{'C',.T.},{2,.T.},{0,.T.},{'Filial',.T.},{'Sucursal',.T.},{'Branch',.T.},{'Filial do Sistema',.T.},{'Sucursal',.T.},{'Branch of the System',.T.},{'@!',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),.T.},{'',.T.},{'',.T.},{1,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'033',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI3',.T.},{'02',.T.},{'ZI3_ID',.T.},{'C',.T.},{6,.T.},{0,.T.},{'ID Inspe��o',.T.},{'ID Inspe��o',.T.},{'ID Inspe��o',.T.},{'Identificador da Inspe��o',.T.},{'Identificador da Inspe��o',.T.},{'Identificador da Inspe��o',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI3',.T.},{'03',.T.},{'ZI3_PROD',.T.},{'C',.T.},{15,.T.},{0,.T.},{'Produto',.T.},{'Produto',.T.},{'Produto',.T.},{'C�digo do Produto',.T.},{'C�digo do Produto',.T.},{'C�digo do Produto',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'030',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI3',.T.},{'04',.T.},{'ZI3_PALLET',.T.},{'C',.T.},{30,.T.},{0,.T.},{'ID Pallet',.T.},{'ID Pallet',.T.},{'ID Pallet',.T.},{'Identifica��o do Pallet',.T.},{'Identifica��o do Pallet',.T.},{'Identifica��o do Pallet',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'068',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI3',.T.},{'05',.T.},{'ZI3_SIF',.T.},{'C',.T.},{5,.T.},{0,.T.},{'SIF',.T.},{'SIF',.T.},{'SIF',.T.},{'Numero SIF',.T.},{'Numero SIF',.T.},{'Numero SIF',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI3',.T.},{'06',.T.},{'ZI3_QUANT',.T.},{'N',.T.},{10,.T.},{5,.T.},{'Peso/Quant.',.T.},{'Peso/Quant.',.T.},{'Peso/Quant.',.T.},{'Peso Liquido/Quantidade',.T.},{'Peso Liquido/Quantidade',.T.},{'Peso Liquido/Quantidade',.T.},{'@E 9,999.99999',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI3',.T.},{'07',.T.},{'ZI3_CONDIC',.T.},{'C',.T.},{1,.T.},{0,.T.},{'Condi��o',.T.},{'Condi��o',.T.},{'Condi��o',.T.},{'Condi��o do Pallet',.T.},{'Condi��o do Pallet',.T.},{'Condi��o do Pallet',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'A=Aprovado;R=Reprovado;Q=Quarentena',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI3',.T.},{'08',.T.},{'ZI3_STATUS',.T.},{'C',.T.},{2,.T.},{0,.T.},{'Status',.T.},{'Status',.T.},{'Status',.T.},{'Status do Pallet',.T.},{'Status do Pallet',.T.},{'Status do Pallet',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'#u_ZI3StatusComboBox()',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI3',.T.},{'09',.T.},{'ZI3_OBSERV',.T.},{'M',.T.},{10,.T.},{0,.T.},{'Observa��o',.T.},{'Observa��o',.T.},{'Observa��o',.T.},{'Observa��o do Pallet',.T.},{'Observa��o do Pallet',.T.},{'Observa��o do Pallet',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI3',.T.},{'10',.T.},{'ZI3_TARAPL',.T.},{'N',.T.},{9,.T.},{5,.T.},{'Tara Pallet',.T.},{'Tara Pallet',.T.},{'Tara Pallet',.T.},{'Tara do Pallet',.T.},{'Tara do Pallet',.T.},{'Tara do Pallet',.T.},{'@E 999.99999',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI3',.T.},{'11',.T.},{'ZI3_TARAEB',.T.},{'N',.T.},{9,.T.},{5,.T.},{'Tara Embalag',.T.},{'Tara Embalag',.T.},{'Tara Embalag',.T.},{'Tara M�dia da Embalagem',.T.},{'Tara M�dia da Embalagem',.T.},{'Tara M�dia da Embalagem',.T.},{'@E 999.99999',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI3',.T.},{'12',.T.},{'ZI3_QTDCX',.T.},{'N',.T.},{3,.T.},{0,.T.},{'Quant. Caixa',.T.},{'Quant. Caixa',.T.},{'Quant. Caixa',.T.},{'Quantidade de Caixas',.T.},{'Quantidade de Caixas',.T.},{'Quantidade de Caixas',.T.},{'@E 999',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI3',.T.},{'13',.T.},{'ZI3_PESOB',.T.},{'N',.T.},{10,.T.},{5,.T.},{'Peso Bruto',.T.},{'Peso Bruto',.T.},{'Peso Bruto',.T.},{'Peso Bruto do Pallet',.T.},{'Peso Bruto do Pallet',.T.},{'Peso Bruto do Pallet',.T.},{'@E 9,999.99999',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI4',.T.},{'01',.T.},{'ZI4_FILIAL',.T.},{'C',.T.},{2,.T.},{0,.T.},{'Filial',.T.},{'Sucursal',.T.},{'Branch',.T.},{'Filial do Sistema',.T.},{'Sucursal',.T.},{'Branch of the System',.T.},{'@!',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),.T.},{'',.T.},{'',.T.},{1,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'033',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI4',.T.},{'02',.T.},{'ZI4_ID',.T.},{'C',.T.},{6,.T.},{0,.T.},{'ID Inspe��o',.T.},{'ID Inspe��o',.T.},{'ID Inspe��o',.T.},{'Identificador da Inspe��o',.T.},{'Identificador da Inspe��o',.T.},{'Identificador da Inspe��o',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI4',.T.},{'03',.T.},{'ZI4_PROD',.T.},{'C',.T.},{15,.T.},{0,.T.},{'Produto',.T.},{'Produto',.T.},{'Produto',.T.},{'C�digo do Produto',.T.},{'C�digo do Produto',.T.},{'C�digo do Produto',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'030',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI4',.T.},{'04',.T.},{'ZI4_SIF',.T.},{'C',.T.},{5,.T.},{0,.T.},{'S.I.F.',.T.},{'S.I.F.',.T.},{'S.I.F.',.T.},{'Numero SIF',.T.},{'Numero SIF',.T.},{'Numero SIF',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI4',.T.},{'05',.T.},{'ZI4_LTEMB',.T.},{'C',.T.},{20,.T.},{0,.T.},{'Lote/Embarq.',.T.},{'Lote/Embarq.',.T.},{'Lote/Embarq.',.T.},{'Numero Lote ou Embarque',.T.},{'Numero Lote ou Embarque',.T.},{'Numero Lote ou Embarque',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI4',.T.},{'06',.T.},{'ZI4_VALID',.T.},{'D',.T.},{8,.T.},{0,.T.},{'Validade',.T.},{'Validade',.T.},{'Validade',.T.},{'Data da Validade do Lote',.T.},{'Data da Validade do Lote',.T.},{'Data da Validade do Lote',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI5',.T.},{'01',.T.},{'ZI5_FILIAL',.T.},{'C',.T.},{2,.T.},{0,.T.},{'Filial',.T.},{'Sucursal',.T.},{'Branch',.T.},{'Filial do Sistema',.T.},{'Sucursal',.T.},{'Branch of the System',.T.},{'@!',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),.T.},{'',.T.},{'',.T.},{1,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'033',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI5',.T.},{'02',.T.},{'ZI5_ID',.T.},{'C',.T.},{6,.T.},{0,.T.},{'ID Inspe��o',.T.},{'ID Inspe��o',.T.},{'ID Inspe��o',.T.},{'Identificador da Inspe��o',.T.},{'Identificador da Inspe��o',.T.},{'Identificador da Inspe��o',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI5',.T.},{'03',.T.},{'ZI5_PROD',.T.},{'C',.T.},{15,.T.},{0,.T.},{'Produto',.T.},{'Produto',.T.},{'Produto',.T.},{'C�digo do Produto',.T.},{'C�digo do Produto',.T.},{'C�digo do Produto',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'030',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI5',.T.},{'04',.T.},{'ZI5_PALLET',.T.},{'C',.T.},{30,.T.},{0,.T.},{'ID Pallet',.T.},{'ID Pallet',.T.},{'ID Pallet',.T.},{'Identifica��o do Pallet',.T.},{'Identifica��o do Pallet',.T.},{'Identifica��o do Pallet',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'068',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI5',.T.},{'05',.T.},{'ZI5_CODNC',.T.},{'C',.T.},{8,.T.},{0,.T.},{'Cod. N.Conf.',.T.},{'Cod. N.Conf.',.T.},{'Cod. N.Conf.',.T.},{'C�digo N�o Conformidade',.T.},{'C�digo N�o Conformidade',.T.},{'C�digo N�o Conformidade',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI5',.T.},{'06',.T.},{'ZI5_DESCNC',.T.},{'C',.T.},{40,.T.},{0,.T.},{'Descri��o',.T.},{'Descri��o',.T.},{'Descri��o',.T.},{'Descri��o da N�o Conform.',.T.},{'Descri��o da N�o Conform.',.T.},{'Descri��o da N�o Conform.',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI6',.T.},{'01',.T.},{'ZI6_FILIAL',.T.},{'C',.T.},{2,.T.},{0,.T.},{'Filial',.T.},{'Sucursal',.T.},{'Branch',.T.},{'Filial do Sistema',.T.},{'Sucursal',.T.},{'Branch of the System',.T.},{'@!',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),.T.},{'',.T.},{'',.T.},{1,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'033',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI6',.T.},{'02',.T.},{'ZI6_ID',.T.},{'C',.T.},{6,.T.},{0,.T.},{'ID Inspe��o',.T.},{'ID Inspe��o',.T.},{'ID Inspe��o',.T.},{'Identificador da Inspe��o',.T.},{'Identificador da Inspe��o',.T.},{'Identificador da Inspe��o',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI6',.T.},{'03',.T.},{'ZI6_PROD',.T.},{'C',.T.},{15,.T.},{0,.T.},{'Produto',.T.},{'Produto',.T.},{'Produto',.T.},{'C�digo do Produto',.T.},{'C�digo do Produto',.T.},{'C�digo do Produto',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI6',.T.},{'04',.T.},{'ZI6_TIPO',.T.},{'C',.T.},{2,.T.},{0,.T.},{'Tipo',.T.},{'Tipo',.T.},{'Tipo',.T.},{'Tipo da diverg�ncia',.T.},{'Tipo da diverg�ncia',.T.},{'Tipo da diverg�ncia',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'AD=Divergencia de Classifica��o;AI=Inspe��o N�o Concluida;DE=Excedente;DD=D�ficit',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI6',.T.},{'05',.T.},{'ZI6_QUANT',.T.},{'N',.T.},{14,.T.},{5,.T.},{'Diverg�ncia',.T.},{'Diverg�ncia',.T.},{'Diverg�ncia',.T.},{'Quantidade de Diverg�ncia',.T.},{'Quantidade de Diverg�ncia',.T.},{'Quantidade de Diverg�ncia',.T.},{'@E 99,999,999.99999',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI7',.T.},{'01',.T.},{'ZI7_FILIAL',.T.},{'C',.T.},{2,.T.},{0,.T.},{'Filial',.T.},{'Sucursal',.T.},{'Branch',.T.},{'Filial do Sistema',.T.},{'Sucursal',.T.},{'Branch of the System',.T.},{'@!',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),.T.},{'',.T.},{'',.T.},{1,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'033',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI7',.T.},{'02',.T.},{'ZI7_ID',.T.},{'C',.T.},{6,.T.},{0,.T.},{'ID Inspe��o',.T.},{'ID Inspe��o',.T.},{'ID Inspe��o',.T.},{'Identificador da Inspe��o',.T.},{'Identificador da Inspe��o',.T.},{'Identificador da Inspe��o',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI7',.T.},{'03',.T.},{'ZI7_DATA',.T.},{'D',.T.},{8,.T.},{0,.T.},{'Data',.T.},{'Data',.T.},{'Data',.T.},{'Data do Evento',.T.},{'Data do Evento',.T.},{'Data do Evento',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI7',.T.},{'04',.T.},{'ZI7_HORA',.T.},{'C',.T.},{8,.T.},{0,.T.},{'Hora',.T.},{'Hora',.T.},{'Hora',.T.},{'Hora do Evento',.T.},{'Hora do Evento',.T.},{'Hora do Evento',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI7',.T.},{'05',.T.},{'ZI7_USER',.T.},{'C',.T.},{6,.T.},{0,.T.},{'Usu�rio',.T.},{'Usu�rio',.T.},{'Usu�rio',.T.},{'Usu�rio que fez o Evento',.T.},{'Usu�rio que fez o Evento',.T.},{'Usu�rio que fez o Evento',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI7',.T.},{'06',.T.},{'ZI7_EVENTO',.T.},{'C',.T.},{40,.T.},{0,.T.},{'Evento',.T.},{'Evento',.T.},{'Evento',.T.},{'Evento',.T.},{'Evento',.T.},{'Evento',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZI7',.T.},{'07',.T.},{'ZI7_OBSERV',.T.},{'M',.T.},{10,.T.},{0,.T.},{'Observa��o',.T.},{'Observa��o',.T.},{'Observa��o',.T.},{'Observa��o do Evento',.T.},{'Observa��o do Evento',.T.},{'Observa��o do Evento',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )

//
// Atualizando dicion�rio
//
nPosArq := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_ARQUIVO" } )
nPosOrd := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_ORDEM"   } )
nPosCpo := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_CAMPO"   } )
nPosTam := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_TAMANHO" } )
nPosSXG := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_GRPSXG"  } )
nPosVld := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_VALID"   } )

aSort( aSX3,,, { |x,y| x[nPosArq][1]+x[nPosOrd][1]+x[nPosCpo][1] < y[nPosArq][1]+y[nPosOrd][1]+y[nPosCpo][1] } )

oProcess:SetRegua2( Len( aSX3 ) )

dbSelectArea( "SX3" )
dbSetOrder( 2 )
cAliasAtu := ""

For nI := 1 To Len( aSX3 )

	//
	// Verifica se o campo faz parte de um grupo e ajusta tamanho
	//
	If !Empty( aSX3[nI][nPosSXG][1] )
		SXG->( dbSetOrder( 1 ) )
		If SXG->( MSSeek( aSX3[nI][nPosSXG][1] ) )
			If aSX3[nI][nPosTam][1] <> SXG->XG_SIZE
				aSX3[nI][nPosTam][1] := SXG->XG_SIZE
				AutoGrLog( "O tamanho do campo " + aSX3[nI][nPosCpo][1] + " N�O atualizado e foi mantido em [" + ;
				AllTrim( Str( SXG->XG_SIZE ) ) + "]" + CRLF + ;
				" por pertencer ao grupo de campos [" + SXG->XG_GRUPO + "]" + CRLF )
			EndIf
		EndIf
	EndIf

	SX3->( dbSetOrder( 2 ) )

	If !( aSX3[nI][nPosArq][1] $ cAlias )
		cAlias += aSX3[nI][nPosArq][1] + "/"
		aAdd( aArqUpd, aSX3[nI][nPosArq][1] )
	EndIf

	If !SX3->( dbSeek( PadR( aSX3[nI][nPosCpo][1], nTamSeek ) ) )

		//
		// Busca ultima ocorrencia do alias
		//
		If ( aSX3[nI][nPosArq][1] <> cAliasAtu )
			cSeqAtu   := "00"
			cAliasAtu := aSX3[nI][nPosArq][1]

			dbSetOrder( 1 )
			SX3->( dbSeek( cAliasAtu + "ZZ", .T. ) )
			dbSkip( -1 )

			If ( SX3->X3_ARQUIVO == cAliasAtu )
				cSeqAtu := SX3->X3_ORDEM
			EndIf

			nSeqAtu := Val( RetAsc( cSeqAtu, 3, .F. ) )
		EndIf

		nSeqAtu++
		cSeqAtu := RetAsc( Str( nSeqAtu ), 2, .T. )

		RecLock( "SX3", .T. )
		For nJ := 1 To Len( aSX3[nI] )
			If     nJ == nPosOrd  // Ordem
				SX3->( FieldPut( FieldPos( aEstrut[nJ][1] ), cSeqAtu ) )

			ElseIf aEstrut[nJ][2] > 0
				SX3->( FieldPut( FieldPos( aEstrut[nJ][1] ), aSX3[nI][nJ][1] ) )

			EndIf
		Next nJ

		dbCommit()
		MsUnLock()

		AutoGrLog( "Criado campo " + aSX3[nI][nPosCpo][1] )

	Else

		//
		// Verifica se o campo faz parte de um grupo e ajsuta tamanho
		//
		If !Empty( SX3->X3_GRPSXG ) .AND. SX3->X3_GRPSXG <> aSX3[nI][nPosSXG][1]
			SXG->( dbSetOrder( 1 ) )
			If SXG->( MSSeek( SX3->X3_GRPSXG ) )
				If aSX3[nI][nPosTam][1] <> SXG->XG_SIZE
					aSX3[nI][nPosTam][1] := SXG->XG_SIZE
					AutoGrLog( "O tamanho do campo " + aSX3[nI][nPosCpo][1] + " N�O atualizado e foi mantido em [" + ;
					AllTrim( Str( SXG->XG_SIZE ) ) + "]"+ CRLF + ;
					"   por pertencer ao grupo de campos [" + SX3->X3_GRPSXG + "]" + CRLF )
				EndIf
			EndIf
		EndIf

		//
		// Verifica todos os campos
		//
		For nJ := 1 To Len( aSX3[nI] )

			//
			// Se o campo estiver diferente da estrutura
			//
			If aSX3[nI][nJ][2]
				cX3Campo := AllTrim( aEstrut[nJ][1] )
				cX3Dado  := SX3->( FieldGet( aEstrut[nJ][2] ) )

				If  aEstrut[nJ][2] > 0 .AND. ;
					PadR( StrTran( AllToChar( cX3Dado ), " ", "" ), 250 ) <> ;
					PadR( StrTran( AllToChar( aSX3[nI][nJ][1] ), " ", "" ), 250 ) .AND. ;
					!cX3Campo == "X3_ORDEM"

					cMsg := "O campo " + aSX3[nI][nPosCpo][1] + " est� com o " + cX3Campo + ;
					" com o conte�do" + CRLF + ;
					"[" + RTrim( AllToChar( cX3Dado ) ) + "]" + CRLF + ;
					"que ser� substitu�do pelo NOVO conte�do" + CRLF + ;
					"[" + RTrim( AllToChar( aSX3[nI][nJ][1] ) ) + "]" + CRLF + ;
					"Deseja substituir ? "

					If      lTodosSim
						nOpcA := 1
					ElseIf  lTodosNao
						nOpcA := 2
					Else
						nOpcA := Aviso( "ATUALIZA��O DE DICION�RIOS E TABELAS", cMsg, { "Sim", "N�o", "Sim p/Todos", "N�o p/Todos" }, 3, "Diferen�a de conte�do - SX3" )
						lTodosSim := ( nOpcA == 3 )
						lTodosNao := ( nOpcA == 4 )

						If lTodosSim
							nOpcA := 1
							lTodosSim := MsgNoYes( "Foi selecionada a op��o de REALIZAR TODAS altera��es no SX3 e N�O MOSTRAR mais a tela de aviso." + CRLF + "Confirma a a��o [Sim p/Todos] ?" )
						EndIf

						If lTodosNao
							nOpcA := 2
							lTodosNao := MsgNoYes( "Foi selecionada a op��o de N�O REALIZAR nenhuma altera��o no SX3 que esteja diferente da base e N�O MOSTRAR mais a tela de aviso." + CRLF + "Confirma esta a��o [N�o p/Todos]?" )
						EndIf

					EndIf

					If nOpcA == 1
						AutoGrLog( "Alterado campo " + aSX3[nI][nPosCpo][1] + CRLF + ;
						"   " + PadR( cX3Campo, 10 ) + " de [" + AllToChar( cX3Dado ) + "]" + CRLF + ;
						"            para [" + AllToChar( aSX3[nI][nJ][1] )           + "]" + CRLF )

						RecLock( "SX3", .F. )
						FieldPut( FieldPos( aEstrut[nJ][1] ), aSX3[nI][nJ][1] )
						MsUnLock()
					EndIf

				EndIf

			EndIf

		Next

	EndIf

	oProcess:IncRegua2( "Atualizando Campos de Tabelas (SX3)..." )

Next nI

AutoGrLog( CRLF + "Final da Atualiza��o" + " SX3" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSIX
Fun��o de processamento da grava��o do SIX - Indices

@author TOTVS Protheus
@since  16/05/2018
@obs    Gerado por EXPORDIC - V.5.4.1.2 EFS / Upd. V.4.21.17 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSIX()
Local aEstrut   := {}
Local aSIX      := {}
Local lAlt      := .F.
Local lDelInd   := .F.
Local nI        := 0
Local nJ        := 0

AutoGrLog( "�nicio da Atualiza��o" + " SIX" + CRLF )

aEstrut := { "INDICE" , "ORDEM" , "CHAVE", "DESCRICAO", "DESCSPA"  , ;
             "DESCENG", "PROPRI", "F3"   , "NICKNAME" , "SHOWPESQ" }

aAdd( aSIX, {'ZI1','1','ZI1_FILIAL+ZI1_DOC+ZI1_SERIE+ZI1_FORN+ZI1_LOJA','Numero+Serie+Fornecedor+Loja','Numero+Serie+Fornecedor+Loja','Numero+Serie+Fornecedor+Loja','U','','','S'} )
aAdd( aSIX, {'ZI1','2','ZI1_FILIAL+ZI1_ID','ID Inspe��o','ID Inspe��o','ID Inspe��o','U','','','S'} )
aAdd( aSIX, {'ZI2','1','ZI2_FILIAL+ZI2_ID+ZI2_PROD','ID Inspe��o+Produto','ID Inspe��o+Produto','ID Inspe��o+Produto','U','','','N'} )
aAdd( aSIX, {'ZI3','1','ZI3_FILIAL+ZI3_ID+ZI3_PROD+ZI3_SIF+ZI3_PALLET','ID Inspe��o+Produto+SIF+ID Pallet','ID Inspe��o+Produto+SIF+ID Pallet','ID Inspe��o+Produto+SIF+ID Pallet','U','','','N'} )
aAdd( aSIX, {'ZI3','2','ZI3_FILIAL+ZI3_ID+ZI3_PROD+ZI3_CONDIC+ZI3_PALLET','ID Inspe��o+Produto+Condi��o+ID Pallet','ID Inspe��o+Produto+Condi��o+ID Pallet','ID Inspe��o+Produto+Condi��o+ID Pallet','U','','','N'} )
aAdd( aSIX, {'ZI3','3','ZI3_FILIAL+ZI3_PALLET','ID Pallet','ID Pallet','ID Pallet','U','','','N'} )
aAdd( aSIX, {'ZI4','1','ZI4_FILIAL+ZI4_ID+ZI4_PROD+ZI4_SIF+ZI4_LTEMB','ID Inspe��o+Produto+S.I.F.+Lote/Embarq.','ID Inspe��o+Produto+S.I.F.+Lote/Embarq.','ID Inspe��o+Produto+S.I.F.+Lote/Embarq.','U','','','S'} )
aAdd( aSIX, {'ZI5','1','ZI5_FILIAL+ZI5_ID+ZI5_PROD+ZI5_PALLET+ZI5_CODNC','ID Inspe��o+Produto+ID Pallet+Cod. N.Conf.','ID Inspe��o+Produto+ID Pallet+Cod. N.Conf.','ID Inspe��o+Produto+ID Pallet+Cod. N.Conf.','U','','','N'} )
aAdd( aSIX, {'ZI6','1','ZI6_FILIAL+ZI6_ID+ZI6_PROD+ZI6_TIPO','ID Inspe��o+Produto+Tipo','ID Inspe��o+Produto+Tipo','ID Inspe��o+Produto+Tipo','U','','','N'} )
aAdd( aSIX, {'ZI7','1','ZI7_FILIAL+ZI7_ID+DTOS(ZI7_DATA)+ZI7_HORA','ID Inspe��o+Data+Hora','ID Inspe��o+Data+Hora','ID Inspe��o+Data+Hora','U','','','S'} )
//
// Atualizando dicion�rio
//
oProcess:SetRegua2( Len( aSIX ) )

dbSelectArea( "SIX" )
SIX->( dbSetOrder( 1 ) )

For nI := 1 To Len( aSIX )

	lAlt    := .F.
	lDelInd := .F.

	If !SIX->( dbSeek( aSIX[nI][1] + aSIX[nI][2] ) )
		AutoGrLog( "�ndice criado " + aSIX[nI][1] + "/" + aSIX[nI][2] + " - " + aSIX[nI][3] )
	Else
		lAlt := .T.
		aAdd( aArqUpd, aSIX[nI][1] )
		If !StrTran( Upper( AllTrim( CHAVE )       ), " ", "" ) == ;
		    StrTran( Upper( AllTrim( aSIX[nI][3] ) ), " ", "" )
			AutoGrLog( "Chave do �ndice alterado " + aSIX[nI][1] + "/" + aSIX[nI][2] + " - " + aSIX[nI][3] )
			lDelInd := .T. // Se for altera��o precisa apagar o indice do banco
		EndIf
	EndIf

	RecLock( "SIX", !lAlt )
	For nJ := 1 To Len( aSIX[nI] )
		If FieldPos( aEstrut[nJ] ) > 0
			FieldPut( FieldPos( aEstrut[nJ] ), aSIX[nI][nJ] )
		EndIf
	Next nJ
	MsUnLock()

	dbCommit()

	If lDelInd
		TcInternal( 60, RetSqlName( aSIX[nI][1] ) + "|" + RetSqlName( aSIX[nI][1] ) + aSIX[nI][2] )
	EndIf

	oProcess:IncRegua2( "Atualizando �ndices..." )

Next nI

AutoGrLog( CRLF + "Final da Atualiza��o" + " SIX" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSX6
Fun��o de processamento da grava��o do SX6 - Par�metros

@author TOTVS Protheus
@since  16/05/2018
@obs    Gerado por EXPORDIC - V.5.4.1.2 EFS / Upd. V.4.21.17 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSX6()
Local aEstrut   := {}
Local aSX6      := {}
Local cAlias    := ""
Local cMsg      := ""
Local lContinua := .T.
Local lReclock  := .T.
Local lTodosNao := .F.
Local lTodosSim := .F.
Local nI        := 0
Local nJ        := 0
Local nOpcA     := 0
Local nTamFil   := Len( SX6->X6_FIL )
Local nTamVar   := Len( SX6->X6_VAR )

AutoGrLog( "�nicio da Atualiza��o" + " SX6" + CRLF )

aEstrut := { "X6_FIL"    , "X6_VAR"    , "X6_TIPO"   , "X6_DESCRIC", "X6_DSCSPA" , "X6_DSCENG" , "X6_DESC1"  , ;
             "X6_DSCSPA1", "X6_DSCENG1", "X6_DESC2"  , "X6_DSCSPA2", "X6_DSCENG2", "X6_CONTEUD", "X6_CONTSPA", ;
             "X6_CONTENG", "X6_PROPRI" , "X6_VALID"  , "X6_INIT"   , "X6_DEFPOR" , "X6_DEFSPA" , "X6_DEFENG" , ;
             "X6_PYME"   }

aAdd( aSX6, {'','MDR_PREINS','L','Ativa a preinspe��o de entrada do Madero','Ativa a preinspe��o de entrada do Madero','Ativa a preinspe��o de entrada do Madero','','','','','','','.F.','.F.','.F.','U','','','','','',''} )
aAdd( aSX6, {'','MDR_CQ','C','Local(Almoxarifado) Controle de Qualidade Madero','Local(Almoxarifado) Controle de Qualidade Madero','Local(Almoxarifado) Controle de Qualidade Madero','','','','','','','55','55','55','U','','','','','',''} )
//
// Atualizando dicion�rio
//
oProcess:SetRegua2( Len( aSX6 ) )

dbSelectArea( "SX6" )
dbSetOrder( 1 )

For nI := 1 To Len( aSX6 )
	lContinua := .F.
	lReclock  := .F.

	If !SX6->( dbSeek( PadR( aSX6[nI][1], nTamFil ) + PadR( aSX6[nI][2], nTamVar ) ) )
		lContinua := .T.
		lReclock  := .T.
		AutoGrLog( "Foi inclu�do o par�metro " + aSX6[nI][1] + aSX6[nI][2] + " Conte�do [" + AllTrim( aSX6[nI][13] ) + "]" )
	Else
		lContinua := .T.
		lReclock  := .F.
		If !StrTran( SX6->X6_CONTEUD, " ", "" ) == StrTran( aSX6[nI][13], " ", "" )

			cMsg := "O par�metro " + aSX6[nI][2] + " est� com o conte�do" + CRLF + ;
			"[" + RTrim( StrTran( SX6->X6_CONTEUD, " ", "" ) ) + "]" + CRLF + ;
			", que � ser� substituido pelo NOVO conte�do " + CRLF + ;
			"[" + RTrim( StrTran( aSX6[nI][13]   , " ", "" ) ) + "]" + CRLF + ;
			"Deseja substituir ? "

			If      lTodosSim
				nOpcA := 1
			ElseIf  lTodosNao
				nOpcA := 2
			Else
				nOpcA := Aviso( "ATUALIZA��O DE DICION�RIOS E TABELAS", cMsg, { "Sim", "N�o", "Sim p/Todos", "N�o p/Todos" }, 3, "Diferen�a de conte�do - SX6" )
				lTodosSim := ( nOpcA == 3 )
				lTodosNao := ( nOpcA == 4 )

				If lTodosSim
					nOpcA := 1
					lTodosSim := MsgNoYes( "Foi selecionada a op��o de REALIZAR TODAS altera��es no SX6 e N�O MOSTRAR mais a tela de aviso." + CRLF + "Confirma a a��o [Sim p/Todos] ?" )
				EndIf

				If lTodosNao
					nOpcA := 2
					lTodosNao := MsgNoYes( "Foi selecionada a op��o de N�O REALIZAR nenhuma altera��o no SX6 que esteja diferente da base e N�O MOSTRAR mais a tela de aviso." + CRLF + "Confirma esta a��o [N�o p/Todos]?" )
				EndIf

			EndIf

			lContinua := ( nOpcA == 1 )

			If lContinua
				AutoGrLog( "Foi alterado o par�metro " + aSX6[nI][1] + aSX6[nI][2] + " de [" + ;
				AllTrim( SX6->X6_CONTEUD ) + "]" + " para [" + AllTrim( aSX6[nI][13] ) + "]" )
			EndIf

		Else
			lContinua := .F.
		EndIf
	EndIf

	If lContinua
		If !( aSX6[nI][1] $ cAlias )
			cAlias += aSX6[nI][1] + "/"
		EndIf

		RecLock( "SX6", lReclock )
		For nJ := 1 To Len( aSX6[nI] )
			If FieldPos( aEstrut[nJ] ) > 0
				FieldPut( FieldPos( aEstrut[nJ] ), aSX6[nI][nJ] )
			EndIf
		Next nJ
		dbCommit()
		MsUnLock()
	EndIf

	oProcess:IncRegua2( "Atualizando Arquivos (SX6)..." )

Next nI

AutoGrLog( CRLF + "Final da Atualiza��o" + " SX6" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL

//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSXB
Fun��o de processamento da grava��o do SXB - Consultas Padrao

@author TOTVS Protheus
@since  16/05/2018
@obs    Gerado por EXPORDIC - V.5.4.1.2 EFS / Upd. V.4.21.17 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSXB()
Local aEstrut   := {}
Local aSXB      := {}
Local cAlias    := ""
Local cMsg      := ""
Local lTodosNao := .F.
Local lTodosSim := .F.
Local nI        := 0
Local nJ        := 0
Local nOpcA     := 0

AutoGrLog( "�nicio da Atualiza��o" + " SXB" + CRLF )

aEstrut := { "XB_ALIAS"  , "XB_TIPO"   , "XB_SEQ"    , "XB_COLUNA" , "XB_DESCRI" , "XB_DESCSPA", "XB_DESCENG", ;
             "XB_WCONTEM", "XB_CONTEM" }

aAdd( aSXB, {'SF1PIN','1','01','DB','Doc. Pre Inspe��o','Doc. Pre Inspe��o','Doc. Pre Inspe��o','','SF1'} )
aAdd( aSXB, {'SF1PIN','2','01','01','Numero + Serie + For','Num. de Doc. + Serie','Invoice + Series + S','',''} )
aAdd( aSXB, {'SF1PIN','2','02','02','Fornecedor + Loja +','Proveedor + Tienda +','Supplier + Unit + In','',''} )
aAdd( aSXB, {'SF1PIN','4','01','01','Numero','Num. de Doc.','Invoice','','F1_DOC'} )
aAdd( aSXB, {'SF1PIN','4','01','02','Serie','Serie','Series','','F1_SERIE'} )
aAdd( aSXB, {'SF1PIN','4','01','03','Fornecedor','Proveedor','Supplier','','F1_FORNECE'} )
aAdd( aSXB, {'SF1PIN','4','01','04','Loja','Tienda','Unit','','F1_LOJA'} )
aAdd( aSXB, {'SF1PIN','4','02','01','Fornecedor','Proveedor','Supplier','','F1_FORNECE'} )
aAdd( aSXB, {'SF1PIN','4','02','02','Loja','Tienda','Unit','','F1_LOJA'} )
aAdd( aSXB, {'SF1PIN','4','02','03','Numero','Num. de Doc.','Invoice','','F1_DOC'} )
aAdd( aSXB, {'SF1PIN','4','02','04','Serie','Serie','Series','','F1_SERIE'} )
aAdd( aSXB, {'SF1PIN','5','01','','','','','','SF1->F1_DOC'} )
aAdd( aSXB, {'SF1PIN','5','02','','','','','','SF1->F1_SERIE'} )
aAdd( aSXB, {'SF1PIN','5','03','','','','','','SF1->F1_FORNECE'} )
aAdd( aSXB, {'SF1PIN','5','04','','','','','','SF1->F1_LOJA'} )
aAdd( aSXB, {'SF1PIN','6','01','','','','','','SF1->F1_STATUS==" " .And. SF1->F1_PIPSTAT == "B"'} )
//
// Atualizando dicion�rio
//
oProcess:SetRegua2( Len( aSXB ) )

dbSelectArea( "SXB" )
dbSetOrder( 1 )

For nI := 1 To Len( aSXB )

	If !Empty( aSXB[nI][1] )

		If !SXB->( dbSeek( PadR( aSXB[nI][1], Len( SXB->XB_ALIAS ) ) + aSXB[nI][2] + aSXB[nI][3] + aSXB[nI][4] ) )

			If !( aSXB[nI][1] $ cAlias )
				cAlias += aSXB[nI][1] + "/"
				AutoGrLog( "Foi inclu�da a consulta padr�o " + aSXB[nI][1] )
			EndIf

			RecLock( "SXB", .T. )

			For nJ := 1 To Len( aSXB[nI] )
				If FieldPos( aEstrut[nJ] ) > 0
					FieldPut( FieldPos( aEstrut[nJ] ), aSXB[nI][nJ] )
				EndIf
			Next nJ

			dbCommit()
			MsUnLock()

		Else

			//
			// Verifica todos os campos
			//
			For nJ := 1 To Len( aSXB[nI] )

				//
				// Se o campo estiver diferente da estrutura
				//
				If aEstrut[nJ] == SXB->( FieldName( nJ ) ) .AND. ;
					!StrTran( AllToChar( SXB->( FieldGet( nJ ) ) ), " ", "" ) == ;
					 StrTran( AllToChar( aSXB[nI][nJ]            ), " ", "" )

					cMsg := "A consulta padr�o " + aSXB[nI][1] + " est� com o " + SXB->( FieldName( nJ ) ) + ;
					" com o conte�do" + CRLF + ;
					"[" + RTrim( AllToChar( SXB->( FieldGet( nJ ) ) ) ) + "]" + CRLF + ;
					", e este � diferente do conte�do" + CRLF + ;
					"[" + RTrim( AllToChar( aSXB[nI][nJ] ) ) + "]" + CRLF +;
					"Deseja substituir ? "

					If      lTodosSim
						nOpcA := 1
					ElseIf  lTodosNao
						nOpcA := 2
					Else
						nOpcA := Aviso( "ATUALIZA��O DE DICION�RIOS E TABELAS", cMsg, { "Sim", "N�o", "Sim p/Todos", "N�o p/Todos" }, 3, "Diferen�a de conte�do - SXB" )
						lTodosSim := ( nOpcA == 3 )
						lTodosNao := ( nOpcA == 4 )

						If lTodosSim
							nOpcA := 1
							lTodosSim := MsgNoYes( "Foi selecionada a op��o de REALIZAR TODAS altera��es no SXB e N�O MOSTRAR mais a tela de aviso." + CRLF + "Confirma a a��o [Sim p/Todos] ?" )
						EndIf

						If lTodosNao
							nOpcA := 2
							lTodosNao := MsgNoYes( "Foi selecionada a op��o de N�O REALIZAR nenhuma altera��o no SXB que esteja diferente da base e N�O MOSTRAR mais a tela de aviso." + CRLF + "Confirma esta a��o [N�o p/Todos]?" )
						EndIf

					EndIf

					If nOpcA == 1
						RecLock( "SXB", .F. )
						FieldPut( FieldPos( aEstrut[nJ] ), aSXB[nI][nJ] )
						dbCommit()
						MsUnLock()

							If !( aSXB[nI][1] $ cAlias )
								cAlias += aSXB[nI][1] + "/"
								AutoGrLog( "Foi alterada a consulta padr�o " + aSXB[nI][1] )
							EndIf

					EndIf

				EndIf

			Next

		EndIf

	EndIf

	oProcess:IncRegua2( "Atualizando Consultas Padr�es (SXB)..." )

Next nI

AutoGrLog( CRLF + "Final da Atualiza��o" + " SXB" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuHlp
Fun��o de processamento da grava��o dos Helps de Campos

@author TOTVS Protheus
@since  16/05/2018
@obs    Gerado por EXPORDIC - V.5.4.1.2 EFS / Upd. V.4.21.17 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuHlp()
Local aHlpPor   := {}
Local aHlpEng   := {}
Local aHlpSpa   := {}

AutoGrLog( "�nicio da Atualiza��o" + " " + "Helps de Campos" + CRLF )


oProcess:IncRegua2( "Atualizando Helps de Campos ..." )

aHlpPor := {}
aAdd( aHlpPor, 'Email para envio das divergencias da' )
aAdd( aHlpPor, 'PreInspecao Entrada' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PA2_MAILDIV", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "A2_MAILDIV" )

aHlpPor := {}
aAdd( aHlpPor, 'Identifica��o do Pallet' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD7_PALLET ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "D7_PALLET" )

aHlpPor := {}
aAdd( aHlpPor, 'DocSeq Transferencia LOTE' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD7_DOCTRF ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "D7_DOCTRF" )

aHlpPor := {}
aAdd( aHlpPor, 'Status da Pre Inspe��o' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PD1_PIPSTAT", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "D1_PIPSTAT" )

aHlpPor := {}
aAdd( aHlpPor, 'Status da Pre Inspe��o' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PF1_PIPSTAT", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "F1_PIPSTAT" )

aHlpPor := {}
aAdd( aHlpPor, 'Numero do documento de entrada' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI1_DOC   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI1_DOC" )

aHlpPor := {}
aAdd( aHlpPor, 'Serie do Documento de Entrada' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI1_SERIE ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI1_SERIE" )

aHlpPor := {}
aAdd( aHlpPor, 'Codigo do fornecedor' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI1_FORN  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI1_FORN" )

aHlpPor := {}
aAdd( aHlpPor, 'Loja do fornecedor' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI1_LOJA  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI1_LOJA" )

aHlpPor := {}
aAdd( aHlpPor, 'Data Inicio da Inspe��o' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI1_DTINIC", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI1_DTINIC" )

aHlpPor := {}
aAdd( aHlpPor, 'Hora Inicio da Inspe��o' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI1_HRINIC", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI1_HRINIC" )

aHlpPor := {}
aAdd( aHlpPor, 'Codigo Usu�rio Inspetor' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI1_INSP  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI1_INSP" )

aHlpPor := {}
aAdd( aHlpPor, 'Nome do Inspetor' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI1_INSPN ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI1_INSPN" )

aHlpPor := {}
aAdd( aHlpPor, 'Identificador da Inspe��o' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI1_ID    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI1_ID" )

aHlpPor := {}
aAdd( aHlpPor, 'Tipo de Inspe��o' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI1_TIPO  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI1_TIPO" )

aHlpPor := {}
aAdd( aHlpPor, 'Status da Inspe��o' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI1_STATUS", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI1_STATUS" )

aHlpPor := {}
aAdd( aHlpPor, 'Identificador da Inspe��o' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI2_ID    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI2_ID" )

aHlpPor := {}
aAdd( aHlpPor, 'C�digo do Produto' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI2_PROD  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI2_PROD" )

aHlpPor := {}
aAdd( aHlpPor, 'Descri��o do Produto' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI2_DESC  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI2_DESC" )

aHlpPor := {}
aAdd( aHlpPor, 'Unidade de Medida' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI2_UM    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI2_UM" )

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade da Nota' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI2_QUANT ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI2_QUANT" )

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade Inspecionada' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI2_INSP  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI2_INSP" )

aHlpPor := {}
aAdd( aHlpPor, 'Status da Inspe��o do Produto' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI2_STATUS", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI2_STATUS" )

aHlpPor := {}
aAdd( aHlpPor, 'Identificador da Inspe��o' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI3_ID    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI3_ID" )

aHlpPor := {}
aAdd( aHlpPor, 'C�digo do Produto' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI3_PROD  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI3_PROD" )

aHlpPor := {}
aAdd( aHlpPor, 'Numero de Identifica��o do Pallet (para' )
aAdd( aHlpPor, 'FRIGORIFICO tamb�m � o numero do LOTE)' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI3_PALLET", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI3_PALLET" )

aHlpPor := {}
aAdd( aHlpPor, 'Numero SIF (Servi�o de Inspe��o Federal)' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI3_SIF   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI3_SIF" )

aHlpPor := {}
aAdd( aHlpPor, 'Condi��o do Pallet' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI3_CONDIC", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI3_CONDIC" )

aHlpPor := {}
aAdd( aHlpPor, 'Status do Pallet' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI3_STATUS", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI3_STATUS" )

aHlpPor := {}
aAdd( aHlpPor, 'Observa��o do Pallet (obrigat�rio' )
aAdd( aHlpPor, 'quandotiver NC)' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI3_OBSERV", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI3_OBSERV" )

aHlpPor := {}
aAdd( aHlpPor, 'Tara do Pallet' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI3_TARAPL", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI3_TARAPL" )

aHlpPor := {}
aAdd( aHlpPor, 'Tara M�dia da Embalagem' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI3_TARAEB", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI3_TARAEB" )

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade de Caixas no Pallet' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI3_QTDCX ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI3_QTDCX" )

aHlpPor := {}
aAdd( aHlpPor, 'Peso Bruto do Pallet' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI3_PESOB ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI3_PESOB" )

aHlpPor := {}
aAdd( aHlpPor, 'Identificador da Inspe��o' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI4_ID    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI4_ID" )

aHlpPor := {}
aAdd( aHlpPor, 'C�digo do Produto' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI4_PROD  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI4_PROD" )

aHlpPor := {}
aAdd( aHlpPor, 'Numero SIF' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI4_SIF   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI4_SIF" )

aHlpPor := {}
aAdd( aHlpPor, 'Numero do Lote ou do Embarque' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI4_LTEMB ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI4_LTEMB" )

aHlpPor := {}
aAdd( aHlpPor, 'Data da Validade do Lote' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI4_VALID ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI4_VALID" )

aHlpPor := {}
aAdd( aHlpPor, 'Identificador da Inspe��o' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI5_ID    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI5_ID" )

aHlpPor := {}
aAdd( aHlpPor, 'C�digo do Produto' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI5_PROD  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI5_PROD" )

aHlpPor := {}
aAdd( aHlpPor, 'Identifica��o do Pallet' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI5_PALLET", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI5_PALLET" )

aHlpPor := {}
aAdd( aHlpPor, 'C�digo da N�o Conformidade' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI5_CODNC ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI5_CODNC" )

aHlpPor := {}
aAdd( aHlpPor, 'Descri��o da N�o Conformidade' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI5_DESCNC", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI5_DESCNC" )

aHlpPor := {}
aAdd( aHlpPor, 'Identificador da Inspe��o' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI6_ID    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI6_ID" )

aHlpPor := {}
aAdd( aHlpPor, 'C�digo do Produto' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI6_PROD  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI6_PROD" )

aHlpPor := {}
aAdd( aHlpPor, 'Tipo da diverg�ncia' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI6_TIPO  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI6_TIPO" )

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade de Diverg�ncia' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI6_QUANT ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI6_QUANT" )

aHlpPor := {}
aAdd( aHlpPor, 'Identificador da Inspe��o' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI7_ID    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI7_ID" )

aHlpPor := {}
aAdd( aHlpPor, 'Data do Evento' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI7_DATA  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI7_DATA" )

aHlpPor := {}
aAdd( aHlpPor, 'Hora do Evento' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI7_HORA  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI7_HORA" )

aHlpPor := {}
aAdd( aHlpPor, 'Usu�rio que fez o Evento' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI7_USER  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI7_USER" )

aHlpPor := {}
aAdd( aHlpPor, 'Evento' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI7_EVENTO", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI7_EVENTO" )

aHlpPor := {}
aAdd( aHlpPor, 'Observa��o do Evento' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZI7_OBSERV", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZI7_OBSERV" )

AutoGrLog( CRLF + "Final da Atualiza��o" + " " + "Helps de Campos" + CRLF + Replicate( "-", 128 ) + CRLF )

Return {}


//--------------------------------------------------------------------
/*/{Protheus.doc} EscEmpresa
Fun��o gen�rica para escolha de Empresa, montada pelo SM0

@return aRet Vetor contendo as sele��es feitas.
             Se n�o for marcada nenhuma o vetor volta vazio

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function EscEmpresa()

//---------------------------------------------
// Par�metro  nTipo
// 1 - Monta com Todas Empresas/Filiais
// 2 - Monta s� com Empresas
// 3 - Monta s� com Filiais de uma Empresa
//
// Par�metro  aMarcadas
// Vetor com Empresas/Filiais pr� marcadas
//
// Par�metro  cEmpSel
// Empresa que ser� usada para montar sele��o
//---------------------------------------------
Local   aRet      := {}
Local   aSalvAmb  := GetArea()
Local   aSalvSM0  := {}
Local   aVetor    := {}
Local   cMascEmp  := "??"
Local   cVar      := ""
Local   lChk      := .F.
Local   lOk       := .F.
Local   lTeveMarc := .F.
Local   oNo       := LoadBitmap( GetResources(), "LBNO" )
Local   oOk       := LoadBitmap( GetResources(), "LBOK" )
Local   oDlg, oChkMar, oLbx, oMascEmp, oSay
Local   oButDMar, oButInv, oButMarc, oButOk, oButCanc

Local   aMarcadas := {}


If !MyOpenSm0(.F.)
	Return aRet
EndIf


dbSelectArea( "SM0" )
aSalvSM0 := SM0->( GetArea() )
dbSetOrder( 1 )
dbGoTop()

While !SM0->( EOF() )

	If aScan( aVetor, {|x| x[2] == SM0->M0_CODIGO} ) == 0
		aAdd(  aVetor, { aScan( aMarcadas, {|x| x[1] == SM0->M0_CODIGO .and. x[2] == SM0->M0_CODFIL} ) > 0, SM0->M0_CODIGO, SM0->M0_CODFIL, SM0->M0_NOME, SM0->M0_FILIAL } )
	EndIf

	dbSkip()
End

RestArea( aSalvSM0 )

Define MSDialog  oDlg Title "" From 0, 0 To 280, 395 Pixel

oDlg:cToolTip := "Tela para M�ltiplas Sele��es de Empresas/Filiais"

oDlg:cTitle   := "Selecione a(s) Empresa(s) para Atualiza��o"

@ 10, 10 Listbox  oLbx Var  cVar Fields Header " ", " ", "Empresa" Size 178, 095 Of oDlg Pixel
oLbx:SetArray(  aVetor )
oLbx:bLine := {|| {IIf( aVetor[oLbx:nAt, 1], oOk, oNo ), ;
aVetor[oLbx:nAt, 2], ;
aVetor[oLbx:nAt, 4]}}
oLbx:BlDblClick := { || aVetor[oLbx:nAt, 1] := !aVetor[oLbx:nAt, 1], VerTodos( aVetor, @lChk, oChkMar ), oChkMar:Refresh(), oLbx:Refresh()}
oLbx:cToolTip   :=  oDlg:cTitle
oLbx:lHScroll   := .F. // NoScroll

@ 112, 10 CheckBox oChkMar Var  lChk Prompt "Todos" Message "Marca / Desmarca"+ CRLF + "Todos" Size 40, 007 Pixel Of oDlg;
on Click MarcaTodos( lChk, @aVetor, oLbx )

// Marca/Desmarca por mascara
@ 113, 51 Say   oSay Prompt "Empresa" Size  40, 08 Of oDlg Pixel
@ 112, 80 MSGet oMascEmp Var  cMascEmp Size  05, 05 Pixel Picture "@!"  Valid (  cMascEmp := StrTran( cMascEmp, " ", "?" ), oMascEmp:Refresh(), .T. ) ;
Message "M�scara Empresa ( ?? )"  Of oDlg
oSay:cToolTip := oMascEmp:cToolTip

@ 128, 10 Button oButInv    Prompt "&Inverter"  Size 32, 12 Pixel Action ( InvSelecao( @aVetor, oLbx, @lChk, oChkMar ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Inverter Sele��o" Of oDlg
oButInv:SetCss( CSSBOTAO )
@ 128, 50 Button oButMarc   Prompt "&Marcar"    Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .T. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Marcar usando" + CRLF + "m�scara ( ?? )"    Of oDlg
oButMarc:SetCss( CSSBOTAO )
@ 128, 80 Button oButDMar   Prompt "&Desmarcar" Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .F. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Desmarcar usando" + CRLF + "m�scara ( ?? )" Of oDlg
oButDMar:SetCss( CSSBOTAO )
@ 112, 157  Button oButOk   Prompt "Processar"  Size 32, 12 Pixel Action (  RetSelecao( @aRet, aVetor ), IIf( Len( aRet ) > 0, oDlg:End(), MsgStop( "Ao menos um grupo deve ser selecionado", "UPDMDR02" ) ) ) ;
Message "Confirma a sele��o e efetua" + CRLF + "o processamento" Of oDlg
oButOk:SetCss( CSSBOTAO )
@ 128, 157  Button oButCanc Prompt "Cancelar"   Size 32, 12 Pixel Action ( IIf( lTeveMarc, aRet :=  aMarcadas, .T. ), oDlg:End() ) ;
Message "Cancela o processamento" + CRLF + "e abandona a aplica��o" Of oDlg
oButCanc:SetCss( CSSBOTAO )

Activate MSDialog  oDlg Center

RestArea( aSalvAmb )
dbSelectArea( "SM0" )
dbCloseArea()

Return  aRet


//--------------------------------------------------------------------
/*/{Protheus.doc} MarcaTodos
Fun��o auxiliar para marcar/desmarcar todos os �tens do ListBox ativo

@param lMarca  Cont�udo para marca .T./.F.
@param aVetor  Vetor do ListBox
@param oLbx    Objeto do ListBox

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function MarcaTodos( lMarca, aVetor, oLbx )
Local  nI := 0

For nI := 1 To Len( aVetor )
	aVetor[nI][1] := lMarca
Next nI

oLbx:Refresh()

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} InvSelecao
Fun��o auxiliar para inverter a sele��o do ListBox ativo

@param aVetor  Vetor do ListBox
@param oLbx    Objeto do ListBox

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function InvSelecao( aVetor, oLbx )
Local  nI := 0

For nI := 1 To Len( aVetor )
	aVetor[nI][1] := !aVetor[nI][1]
Next nI

oLbx:Refresh()

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} RetSelecao
Fun��o auxiliar que monta o retorno com as sele��es

@param aRet    Array que ter� o retorno das sele��es (� alterado internamente)
@param aVetor  Vetor do ListBox

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function RetSelecao( aRet, aVetor )
Local  nI    := 0

aRet := {}
For nI := 1 To Len( aVetor )
	If aVetor[nI][1]
		aAdd( aRet, { aVetor[nI][2] , aVetor[nI][3], aVetor[nI][2] +  aVetor[nI][3] } )
	EndIf
Next nI

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} MarcaMas
Fun��o para marcar/desmarcar usando m�scaras

@param oLbx     Objeto do ListBox
@param aVetor   Vetor do ListBox
@param cMascEmp Campo com a m�scara (???)
@param lMarDes  Marca a ser atribu�da .T./.F.

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function MarcaMas( oLbx, aVetor, cMascEmp, lMarDes )
Local cPos1 := SubStr( cMascEmp, 1, 1 )
Local cPos2 := SubStr( cMascEmp, 2, 1 )
Local nPos  := oLbx:nAt
Local nZ    := 0

For nZ := 1 To Len( aVetor )
	If cPos1 == "?" .or. SubStr( aVetor[nZ][2], 1, 1 ) == cPos1
		If cPos2 == "?" .or. SubStr( aVetor[nZ][2], 2, 1 ) == cPos2
			aVetor[nZ][1] := lMarDes
		EndIf
	EndIf
Next

oLbx:nAt := nPos
oLbx:Refresh()

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} VerTodos
Fun��o auxiliar para verificar se est�o todos marcados ou n�o

@param aVetor   Vetor do ListBox
@param lChk     Marca do CheckBox do marca todos (referncia)
@param oChkMar  Objeto de CheckBox do marca todos

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function VerTodos( aVetor, lChk, oChkMar )
Local lTTrue := .T.
Local nI     := 0

For nI := 1 To Len( aVetor )
	lTTrue := IIf( !aVetor[nI][1], .F., lTTrue )
Next nI

lChk := IIf( lTTrue, .T., .F. )
oChkMar:Refresh()

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} MyOpenSM0
Fun��o de processamento abertura do SM0 modo exclusivo

@author TOTVS Protheus
@since  16/05/2018
@obs    Gerado por EXPORDIC - V.5.4.1.2 EFS / Upd. V.4.21.17 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function MyOpenSM0(lShared)
Local lOpen := .F.
Local nLoop := 0

For nLoop := 1 To 20
	dbUseArea( .T., , "SIGAMAT.EMP", "SM0", lShared, .F. )

	If !Empty( Select( "SM0" ) )
		lOpen := .T.
		dbSetIndex( "SIGAMAT.IND" )
		Exit
	EndIf

	Sleep( 500 )

Next nLoop

If !lOpen
	MsgStop( "N�o foi poss�vel a abertura da tabela " + ;
	IIf( lShared, "de empresas (SM0).", "de empresas (SM0) de forma exclusiva." ), "ATEN��O" )
EndIf

Return lOpen


//--------------------------------------------------------------------
/*/{Protheus.doc} LeLog
Fun��o de leitura do LOG gerado com limitacao de string

@author TOTVS Protheus
@since  16/05/2018
@obs    Gerado por EXPORDIC - V.5.4.1.2 EFS / Upd. V.4.21.17 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function LeLog()
Local cRet  := ""
Local cFile := NomeAutoLog()
Local cAux  := ""

FT_FUSE( cFile )
FT_FGOTOP()

While !FT_FEOF()

	cAux := FT_FREADLN()

	If Len( cRet ) + Len( cAux ) < 1048000
		cRet += cAux + CRLF
	Else
		cRet += CRLF
		cRet += Replicate( "=" , 128 ) + CRLF
		cRet += "Tamanho de exibi��o maxima do LOG alcan�ado." + CRLF
		cRet += "LOG Completo no arquivo " + cFile + CRLF
		cRet += Replicate( "=" , 128 ) + CRLF
		Exit
	EndIf

	FT_FSKIP()
End

FT_FUSE()

Return cRet