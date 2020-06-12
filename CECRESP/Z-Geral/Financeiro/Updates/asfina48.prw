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
/*/{Protheus.doc} ASFINA48
Função de update de dicionários para compatibilização

@author TOTVS Protheus
@since  18/08/2016
@obs    Gerado por EXPORDIC - V.4.25.11.9 EFS / Upd. V.4.20.13 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
User Function ASFINA48( cEmpAmb, cFilAmb )

Local   aSay      := {}
Local   aButton   := {}
Local   aMarcadas := {}
Local   cTitulo   := "ATUALIZAÇÃO DE DICIONÁRIOS E TABELAS"
Local   cDesc1    := "Esta rotina tem como função fazer  a atualização  dos dicionários do Sistema ( SX?/SIX )"
Local   cDesc2    := "Este processo deve ser executado em modo EXCLUSIVO, ou seja não podem haver outros"
Local   cDesc3    := "usuários  ou  jobs utilizando  o sistema.  É EXTREMAMENTE recomendavél  que  se  faça um"
Local   cDesc4    := "BACKUP  dos DICIONÁRIOS  e da  BASE DE DADOS antes desta atualização, para que caso "
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
		aMarcadas := EscEmpresa()
	EndIf

	If !Empty( aMarcadas )
		If lAuto .OR. MsgNoYes( "Confirma a atualização dos dicionários ?", cTitulo )
			oProcess := MsNewProcess():New( { | lEnd | lOk := FSTProc( @lEnd, aMarcadas, lAuto ) }, "Atualizando", "Aguarde, atualizando ...", .F. )
			oProcess:Activate()

			If lAuto
				If lOk
					MsgStop( "Atualização Realizada.", "ASFINA48" )
				Else
					MsgStop( "Atualização não Realizada.", "ASFINA48" )
				EndIf
				dbCloseAll()
			Else
				If lOk
					Final( "Atualização Concluída." )
				Else
					Final( "Atualização não Realizada." )
				EndIf
			EndIf

		Else
			MsgStop( "Atualização não Realizada.", "ASFINA48" )

		EndIf

	Else
		MsgStop( "Atualização não Realizada.", "ASFINA48" )

	EndIf

EndIf

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSTProc
Função de processamento da gravação dos arquivos

@author TOTVS Protheus
@since  18/08/2016
@obs    Gerado por EXPORDIC - V.4.25.11.9 EFS / Upd. V.4.20.13 EFS
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
		// Só adiciona no aRecnoSM0 se a empresa for diferente
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
				MsgStop( "Atualização da empresa " + aRecnoSM0[nI][2] + " não efetuada." )
				Exit
			EndIf

			SM0->( dbGoTo( aRecnoSM0[nI][1] ) )

			RpcSetType( 3 )
			RpcSetEnv( SM0->M0_CODIGO, SM0->M0_CODFIL )

			lMsFinalAuto := .F.
			lMsHelpAuto  := .F.

			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( Replicate( " ", 128 ) )
			AutoGrLog( "LOG DA ATUALIZAÇÃO DOS DICIONÁRIOS" )
			AutoGrLog( Replicate( " ", 128 ) )
			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( " " )
			AutoGrLog( " Dados Ambiente" )
			AutoGrLog( " --------------------" )
			AutoGrLog( " Empresa / Filial...: " + cEmpAnt + "/" + cFilAnt )
			AutoGrLog( " Nome Empresa.......: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_NOMECOM", cEmpAnt + cFilAnt, 1, "" ) ) ) )
			AutoGrLog( " Nome Filial........: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_FILIAL" , cEmpAnt + cFilAnt, 1, "" ) ) ) )
			AutoGrLog( " DataBase...........: " + DtoC( dDataBase ) )
			AutoGrLog( " Data / Hora Ínicio.: " + DtoC( Date() )  + " / " + Time() )
			AutoGrLog( " Environment........: " + GetEnvServer()  )
			AutoGrLog( " StartPath..........: " + GetSrvProfString( "StartPath", "" ) )
			AutoGrLog( " RootPath...........: " + GetSrvProfString( "RootPath" , "" ) )
			AutoGrLog( " Versão.............: " + GetVersao(.T.) )
			AutoGrLog( " Usuário TOTVS .....: " + __cUserId + " " +  cUserName )
			AutoGrLog( " Computer Name......: " + GetComputerName() )

			aInfo   := GetUserInfo()
			If ( nPos    := aScan( aInfo,{ |x,y| x[3] == ThreadId() } ) ) > 0
				AutoGrLog( " " )
				AutoGrLog( " Dados Thread" )
				AutoGrLog( " --------------------" )
				AutoGrLog( " Usuário da Rede....: " + aInfo[nPos][1] )
				AutoGrLog( " Estação............: " + aInfo[nPos][2] )
				AutoGrLog( " Programa Inicial...: " + aInfo[nPos][5] )
				AutoGrLog( " Environment........: " + aInfo[nPos][6] )
				AutoGrLog( " Conexão............: " + AllTrim( StrTran( StrTran( aInfo[nPos][7], Chr( 13 ), "" ), Chr( 10 ), "" ) ) )
			EndIf
			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( " " )

			If !lAuto
				AutoGrLog( Replicate( "-", 128 ) )
				AutoGrLog( "Empresa : " + SM0->M0_CODIGO + "/" + SM0->M0_NOME + CRLF )
			EndIf

			oProcess:SetRegua1( 8 )

			//------------------------------------
			// Atualiza o dicionário SX2
			//------------------------------------
			oProcess:IncRegua1( "Dicionário de arquivos" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSX2()

			//------------------------------------
			// Atualiza o dicionário SX3
			//------------------------------------
			FSAtuSX3()

			//------------------------------------
			// Atualiza o dicionário SIX
			//------------------------------------
			oProcess:IncRegua1( "Dicionário de índices" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSIX()

			oProcess:IncRegua1( "Dicionário de dados" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			oProcess:IncRegua2( "Atualizando campos/índices" )

			// Alteração física dos arquivos
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
					MsgStop( "Ocorreu um erro desconhecido durante a atualização da tabela : " + aArqUpd[nX] + ". Verifique a integridade do dicionário e da tabela.", "ATENÇÃO" )
					AutoGrLog( "Ocorreu um erro desconhecido durante a atualização da estrutura da tabela : " + aArqUpd[nX] )
				EndIf

				If cTopBuild >= "20090811" .AND. TcInternal( 89 ) == "CLOB_SUPPORTED"
					TcInternal( 25, "OFF" )
				EndIf

			Next nX

			//------------------------------------
			// Atualiza o dicionário SX6
			//------------------------------------
			oProcess:IncRegua1( "Dicionário de parâmetros" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSX6()

			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( " Data / Hora Final.: " + DtoC( Date() ) + " / " + Time() )
			AutoGrLog( Replicate( "-", 128 ) )

			RpcClearEnv()

		Next nI

		If !lAuto

			cTexto := LeLog()

			Define Font oFont Name "Mono AS" Size 5, 12

			Define MsDialog oDlg Title "Atualização concluida." From 3, 0 to 340, 417 Pixel

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
Função de processamento da gravação do SX2 - Arquivos

@author TOTVS Protheus
@since  18/08/2016
@obs    Gerado por EXPORDIC - V.4.25.11.9 EFS / Upd. V.4.20.13 EFS
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

AutoGrLog( "Ínicio da Atualização" + " SX2" + CRLF )

aEstrut := { "X2_CHAVE"  , "X2_PATH"   , "X2_ARQUIVO", "X2_NOME"   , "X2_NOMESPA", "X2_NOMEENG", "X2_MODO"   , ;
             "X2_TTS"    , "X2_ROTINA" , "X2_PYME"   , "X2_UNICO"  , "X2_DISPLAY", "X2_SYSOBJ" , "X2_USROBJ" , ;
             "X2_POSLGT" , "X2_CLOB"   , "X2_AUTREC" , "X2_MODOEMP", "X2_MODOUN" , "X2_MODULO" }


dbSelectArea( "SX2" )
SX2->( dbSetOrder( 1 ) )
SX2->( dbGoTop() )
cPath := SX2->X2_PATH
cPath := IIf( Right( AllTrim( cPath ), 1 ) <> "\", PadR( AllTrim( cPath ) + "\", Len( cPath ) ), cPath )
cEmpr := Substr( SX2->X2_ARQUIVO, 4 )

//
// Tabela SZ8
//
aAdd( aSX2, { ;
	'SZ8'																	, ; //X2_CHAVE
	cPath																	, ; //X2_PATH
	'SZ8'+cEmpr																, ; //X2_ARQUIVO
	'IMPORT. BAIXAS DE PARCEIROS'											, ; //X2_NOME
	'IMPORT. BAIXAS DE PARCEIROS'											, ; //X2_NOMESPA
	'IMPORT. BAIXAS DE PARCEIROS'											, ; //X2_NOMEENG
	'C'																		, ; //X2_MODO
	''																		, ; //X2_TTS
	''																		, ; //X2_ROTINA
	''																		, ; //X2_PYME
	''																		, ; //X2_UNICO
	''																		, ; //X2_DISPLAY
	''																		, ; //X2_SYSOBJ
	''																		, ; //X2_USROBJ
	''																		, ; //X2_POSLGT
	''																		, ; //X2_CLOB
	''																		, ; //X2_AUTREC
	'C'																		, ; //X2_MODOEMP
	'C'																		, ; //X2_MODOUN
	0																		} ) //X2_MODULO

//
// Tabela SZB
//
aAdd( aSX2, { ;
	'SZB'																	, ; //X2_CHAVE
	cPath																	, ; //X2_PATH
	'SZB'+cEmpr																, ; //X2_ARQUIVO
	'ABATIMENTO TIT PARCEIROS FILA'											, ; //X2_NOME
	'ABATIMENTO TIT PARCEIROS FILA'											, ; //X2_NOMESPA
	'ABATIMENTO TIT PARCEIROS FILA'											, ; //X2_NOMEENG
	'C'																		, ; //X2_MODO
	''																		, ; //X2_TTS
	''																		, ; //X2_ROTINA
	''																		, ; //X2_PYME
	''																		, ; //X2_UNICO
	''																		, ; //X2_DISPLAY
	''																		, ; //X2_SYSOBJ
	''																		, ; //X2_USROBJ
	''																		, ; //X2_POSLGT
	''																		, ; //X2_CLOB
	''																		, ; //X2_AUTREC
	'C'																		, ; //X2_MODOEMP
	'C'																		, ; //X2_MODOUN
	0																		} ) //X2_MODULO

//
// Atualizando dicionário
//
oProcess:SetRegua2( Len( aSX2 ) )

dbSelectArea( "SX2" )
dbSetOrder( 1 )

For nI := 1 To Len( aSX2 )

	oProcess:IncRegua2( "Atualizando Arquivos (SX2)..." )

	If !SX2->( dbSeek( aSX2[nI][1] ) )

		If !( aSX2[nI][1] $ cAlias )
			cAlias += aSX2[nI][1] + "/"
			AutoGrLog( "Foi incluída a tabela " + aSX2[nI][1] )
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

			AutoGrLog( "Foi alterada a chave única da tabela " + aSX2[nI][1] )
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

AutoGrLog( CRLF + "Final da Atualização" + " SX2" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSX3
Função de processamento da gravação do SX3 - Campos

@author TOTVS Protheus
@since  18/08/2016
@obs    Gerado por EXPORDIC - V.4.25.11.9 EFS / Upd. V.4.20.13 EFS
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

AutoGrLog( "Ínicio da Atualização" + " SX3" + CRLF )

aEstrut := { { "X3_ARQUIVO", 0 }, { "X3_ORDEM"  , 0 }, { "X3_CAMPO"  , 0 }, { "X3_TIPO"   , 0 }, { "X3_TAMANHO", 0 }, { "X3_DECIMAL", 0 }, { "X3_TITULO" , 0 }, ;
             { "X3_TITSPA" , 0 }, { "X3_TITENG" , 0 }, { "X3_DESCRIC", 0 }, { "X3_DESCSPA", 0 }, { "X3_DESCENG", 0 }, { "X3_PICTURE", 0 }, { "X3_VALID"  , 0 }, ;
             { "X3_USADO"  , 0 }, { "X3_RELACAO", 0 }, { "X3_F3"     , 0 }, { "X3_NIVEL"  , 0 }, { "X3_RESERV" , 0 }, { "X3_CHECK"  , 0 }, { "X3_TRIGGER", 0 }, ;
             { "X3_PROPRI" , 0 }, { "X3_BROWSE" , 0 }, { "X3_VISUAL" , 0 }, { "X3_CONTEXT", 0 }, { "X3_OBRIGAT", 0 }, { "X3_VLDUSER", 0 }, { "X3_CBOX"   , 0 }, ;
             { "X3_CBOXSPA", 0 }, { "X3_CBOXENG", 0 }, { "X3_PICTVAR", 0 }, { "X3_WHEN"   , 0 }, { "X3_INIBRW" , 0 }, { "X3_GRPSXG" , 0 }, { "X3_FOLDER" , 0 }, ;
             { "X3_CONDSQL", 0 }, { "X3_CHKSQL" , 0 }, { "X3_IDXSRV" , 0 }, { "X3_ORTOGRA", 0 }, { "X3_TELA"   , 0 }, { "X3_POSLGT" , 0 }, { "X3_IDXFLD" , 0 }, ;
             { "X3_AGRUP"  , 0 }, { "X3_MODAL"  , 0 }, { "X3_PYME"   , 0 } }

aEval( aEstrut, { |x| x[2] := SX3->( FieldPos( x[1] ) ) } )


//
// Campos Tabela SZ8
//
aAdd( aSX3, { ;
	'SZ8'																	, ; //X3_ARQUIVO
	'01'																	, ; //X3_ORDEM
	'Z8_FILIAL'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	7																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Filial'																, ; //X3_TITULO
	'Filial'																, ; //X3_TITSPA
	'Filial'																, ; //X3_TITENG
	'Filial'																, ; //X3_DESCRIC
	'Filial'																, ; //X3_DESCSPA
	'Filial'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(65)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZ8'																	, ; //X3_ARQUIVO
	'02'																	, ; //X3_ORDEM
	'Z8_EMPREEN'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	30																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Empreendimen'															, ; //X3_TITULO
	'Empreendimen'															, ; //X3_TITSPA
	'Empreendimen'															, ; //X3_TITENG
	'Nome Empreendimento'													, ; //X3_DESCRIC
	'Nome Empreendimento'													, ; //X3_DESCSPA
	'Nome Empreendimento'													, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(65)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZ8'																	, ; //X3_ARQUIVO
	'03'																	, ; //X3_ORDEM
	'Z8_BLOCO'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Bloco'																	, ; //X3_TITULO
	'Bloco'																	, ; //X3_TITSPA
	'Bloco'																	, ; //X3_TITENG
	'Unidade (Quadra)'														, ; //X3_DESCRIC
	'Unidade (Quadra)'														, ; //X3_DESCSPA
	'Unidade (Quadra)'														, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(65)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZ8'																	, ; //X3_ARQUIVO
	'04'																	, ; //X3_ORDEM
	'Z8_UNIDADE'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Unidade'																, ; //X3_TITULO
	'Unidade'																, ; //X3_TITSPA
	'Unidade'																, ; //X3_TITENG
	'Subunidade (Nro. Lote)'												, ; //X3_DESCRIC
	'Subunidade (Nro. Lote)'												, ; //X3_DESCSPA
	'Subunidade (Nro. Lote)'												, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(65)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZ8'																	, ; //X3_ARQUIVO
	'05'																	, ; //X3_ORDEM
	'Z8_CPFCNPJ'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	14																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Cpf/Cnpj Cli'															, ; //X3_TITULO
	'Cpf/Cnpj Cli'															, ; //X3_TITSPA
	'Cpf/Cnpj Cli'															, ; //X3_TITENG
	'Cpf/Cnpj Cliente'														, ; //X3_DESCRIC
	'Cpf/Cnpj Cliente'														, ; //X3_DESCSPA
	'Cpf/Cnpj Cliente'														, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(65)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZ8'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'Z8_PARCELA'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	3																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Parcela'																, ; //X3_TITULO
	'Parcela'																, ; //X3_TITSPA
	'Parcela'																, ; //X3_TITENG
	'Parcela'																, ; //X3_DESCRIC
	'Parcela'																, ; //X3_DESCSPA
	'Parcela'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(65)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZ8'																	, ; //X3_ARQUIVO
	'07'																	, ; //X3_ORDEM
	'Z8_COMPONE'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	2																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Componente'															, ; //X3_TITULO
	'Componente'															, ; //X3_TITSPA
	'Componente'															, ; //X3_TITENG
	'Componente'															, ; //X3_DESCRIC
	'Componente'															, ; //X3_DESCSPA
	'Componente'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(65)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZ8'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'Z8_GRUPO'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	2																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Grupo'																	, ; //X3_TITULO
	'Grupo'																	, ; //X3_TITSPA
	'Grupo'																	, ; //X3_TITENG
	'Grupo'																	, ; //X3_DESCRIC
	'Grupo'																	, ; //X3_DESCSPA
	'Grupo'																	, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(65)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZ8'																	, ; //X3_ARQUIVO
	'09'																	, ; //X3_ORDEM
	'Z8_VLPAGO'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	14																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Valor Pago'															, ; //X3_TITULO
	'Valor Pago'															, ; //X3_TITSPA
	'Valor Pago'															, ; //X3_TITENG
	'Valor Pago'															, ; //X3_DESCRIC
	'Valor Pago'															, ; //X3_DESCSPA
	'Valor Pago'															, ; //X3_DESCENG
	'@E 99,999,999,999.99'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(65)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZ8'																	, ; //X3_ARQUIVO
	'10'																	, ; //X3_ORDEM
	'Z8_PCPART'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	5																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Perc. Partic'															, ; //X3_TITULO
	'Perc. Partic'															, ; //X3_TITSPA
	'Perc. Partic'															, ; //X3_TITENG
	'Perc. participacao parcei'												, ; //X3_DESCRIC
	'Perc. participacao parcei'												, ; //X3_DESCSPA
	'Perc. participacao parcei'												, ; //X3_DESCENG
	'@E 99.99'																, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(65)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZ8'																	, ; //X3_ARQUIVO
	'11'																	, ; //X3_ORDEM
	'Z8_DTBAIXA'															, ; //X3_CAMPO
	'D'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Dt. Baixa'																, ; //X3_TITULO
	'Dt. Baixa'																, ; //X3_TITSPA
	'Dt. Baixa'																, ; //X3_TITENG
	'Dt. Baixa'																, ; //X3_DESCRIC
	'Dt. Baixa'																, ; //X3_DESCSPA
	'Dt. Baixa'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(65)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZ8'																	, ; //X3_ARQUIVO
	'12'																	, ; //X3_ORDEM
	'Z8_VENC'																, ; //X3_CAMPO
	'D'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Vencimento'															, ; //X3_TITULO
	'Vencimento'															, ; //X3_TITSPA
	'Vencimento'															, ; //X3_TITENG
	'Vencimento'															, ; //X3_DESCRIC
	'Vencimento'															, ; //X3_DESCSPA
	'Vencimento'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(65)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZ8'																	, ; //X3_ARQUIVO
	'13'																	, ; //X3_ORDEM
	'Z8_TAXADM'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	14																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Vl. taxa adm'															, ; //X3_TITULO
	'Vl. taxa adm'															, ; //X3_TITSPA
	'Vl. taxa adm'															, ; //X3_TITENG
	'Valor da taxa de administ'												, ; //X3_DESCRIC
	'Valor da taxa de administ'												, ; //X3_DESCSPA
	'Valor da taxa de administ'												, ; //X3_DESCENG
	'@E 99,999,999,999.99'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(65)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZ8'																	, ; //X3_ARQUIVO
	'14'																	, ; //X3_ORDEM
	'Z8_SEGPRES'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	14																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Vl.seg.prest'															, ; //X3_TITULO
	'Vl.seg.prest'															, ; //X3_TITSPA
	'Vl.seg.prest'															, ; //X3_TITENG
	'Valor seguro prestamista'												, ; //X3_DESCRIC
	'Valor seguro prestamista'												, ; //X3_DESCSPA
	'Valor seguro prestamista'												, ; //X3_DESCENG
	'@E 99,999,999,999.99'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(65)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZ8'																	, ; //X3_ARQUIVO
	'15'																	, ; //X3_ORDEM
	'Z8_MULTA'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	14																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Multa'																	, ; //X3_TITULO
	'Multa'																	, ; //X3_TITSPA
	'Multa'																	, ; //X3_TITENG
	'Multa'																	, ; //X3_DESCRIC
	'Multa'																	, ; //X3_DESCSPA
	'Multa'																	, ; //X3_DESCENG
	'@E 99,999,999,999.99'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(65)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZ8'																	, ; //X3_ARQUIVO
	'16'																	, ; //X3_ORDEM
	'Z8_JUROS'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	14																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Juros'																	, ; //X3_TITULO
	'Juros'																	, ; //X3_TITSPA
	'Juros'																	, ; //X3_TITENG
	'Juros de Mora'															, ; //X3_DESCRIC
	'Juros de Mora'															, ; //X3_DESCSPA
	'Juros de Mora'															, ; //X3_DESCENG
	'@E 99,999,999,999.99'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(65)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZ8'																	, ; //X3_ARQUIVO
	'17'																	, ; //X3_ORDEM
	'Z8_DESCON'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	14																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Descontos'																, ; //X3_TITULO
	'Descontos'																, ; //X3_TITSPA
	'Descontos'																, ; //X3_TITENG
	'Descontos'																, ; //X3_DESCRIC
	'Descontos'																, ; //X3_DESCSPA
	'Descontos'																, ; //X3_DESCENG
	'@E 99,999,999,999.99'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(65)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZ8'																	, ; //X3_ARQUIVO
	'18'																	, ; //X3_ORDEM
	'Z8_CONTRAT'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'ID Contrato'															, ; //X3_TITULO
	'ID Contrato'															, ; //X3_TITSPA
	'ID Contrato'															, ; //X3_TITENG
	'Id Contrato'															, ; //X3_DESCRIC
	'Id Contrato'															, ; //X3_DESCSPA
	'Id Contrato'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(65)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZ8'																	, ; //X3_ARQUIVO
	'19'																	, ; //X3_ORDEM
	'Z8_AREATER'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Area Terreno'															, ; //X3_TITULO
	'Area Terreno'															, ; //X3_TITSPA
	'Area Terreno'															, ; //X3_TITENG
	'Area do Terreno'														, ; //X3_DESCRIC
	'Area do Terreno'														, ; //X3_DESCSPA
	'Area do Terreno'														, ; //X3_DESCENG
	'@E 9,999,999.99'														, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(65)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZ8'																	, ; //X3_ARQUIVO
	'20'																	, ; //X3_ORDEM
	'Z8_VLCTJU'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	14																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Par C/J S/In'															, ; //X3_TITULO
	'Par C/J S/In'															, ; //X3_TITSPA
	'Par C/J S/In'															, ; //X3_TITENG
	'Vl Parc. c/jur s/indexado'												, ; //X3_DESCRIC
	'Vl Parc. c/jur s/indexado'												, ; //X3_DESCSPA
	'Vl Parc. c/jur s/indexado'												, ; //X3_DESCENG
	'@E 99,999,999,999.99'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(65)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZ8'																	, ; //X3_ARQUIVO
	'21'																	, ; //X3_ORDEM
	'Z8_VLCTJI'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	14																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Vl corrigido'															, ; //X3_TITULO
	'Vl corrigido'															, ; //X3_TITSPA
	'Vl corrigido'															, ; //X3_TITENG
	'Vl corrigido c/jur c/inde'												, ; //X3_DESCRIC
	'Vl corrigido c/jur c/inde'												, ; //X3_DESCSPA
	'Vl corrigido c/jur c/inde'												, ; //X3_DESCENG
	'@E 99,999,999,999.99'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(65)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZ8'																	, ; //X3_ARQUIVO
	'22'																	, ; //X3_ORDEM
	'Z8_VLCBPAR'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	14																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Vl Cob.Parce'															, ; //X3_TITULO
	'Vl Cob.Parce'															, ; //X3_TITSPA
	'Vl Cob.Parce'															, ; //X3_TITENG
	'Valor cobrado parcela'													, ; //X3_DESCRIC
	'Valor cobrado parcela'													, ; //X3_DESCSPA
	'Valor cobrado parcela'													, ; //X3_DESCENG
	'@E 99,999,999,999.99'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(65)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZ8'																	, ; //X3_ARQUIVO
	'23'																	, ; //X3_ORDEM
	'Z8_DTMOVIM'															, ; //X3_CAMPO
	'D'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Dt. Moviment'															, ; //X3_TITULO
	'Dt. Moviment'															, ; //X3_TITSPA
	'Dt. Moviment'															, ; //X3_TITENG
	'Dt. Movimento'															, ; //X3_DESCRIC
	'Dt. Movimento'															, ; //X3_DESCSPA
	'Dt. Movimento'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(65)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZ8'																	, ; //X3_ARQUIVO
	'24'																	, ; //X3_ORDEM
	'Z8_VLPJCMO'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	14																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Pg sem JCMO'															, ; //X3_TITULO
	'Pg sem JCMO'															, ; //X3_TITSPA
	'Pg sem JCMO'															, ; //X3_TITENG
	'Pg s/jur correc multa out'												, ; //X3_DESCRIC
	'Pg s/jur correc multa out'												, ; //X3_DESCSPA
	'Pg s/jur correc multa out'												, ; //X3_DESCENG
	'@E 99,999,999,999.99'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(65)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZ8'																	, ; //X3_ARQUIVO
	'25'																	, ; //X3_ORDEM
	'Z8_AMORT'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	14																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Amortizacao'															, ; //X3_TITULO
	'Amortizacao'															, ; //X3_TITSPA
	'Amortizacao'															, ; //X3_TITENG
	'Amortizacao (desmemb)'													, ; //X3_DESCRIC
	'Amortizacao (desmemb)'													, ; //X3_DESCSPA
	'Amortizacao (desmemb)'													, ; //X3_DESCENG
	'@E 99,999,999,999.99'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(65)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZ8'																	, ; //X3_ARQUIVO
	'26'																	, ; //X3_ORDEM
	'Z8_TXAMOR'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	14																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Tx Amortizac'															, ; //X3_TITULO
	'Tx Amortizac'															, ; //X3_TITSPA
	'Tx Amortizac'															, ; //X3_TITENG
	'Taxa de Amortizacao'													, ; //X3_DESCRIC
	'Taxa de Amortizacao'													, ; //X3_DESCSPA
	'Taxa de Amortizacao'													, ; //X3_DESCENG
	'@E 99,999,999,999.99'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(65)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZ8'																	, ; //X3_ARQUIVO
	'27'																	, ; //X3_ORDEM
	'Z8_MATRIC'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	20																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Matricula'																, ; //X3_TITULO
	'Matricula'																, ; //X3_TITSPA
	'Matricula'																, ; //X3_TITENG
	'Matricula'																, ; //X3_DESCRIC
	'Matricula'																, ; //X3_DESCSPA
	'Matricula'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(65)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZ8'																	, ; //X3_ARQUIVO
	'28'																	, ; //X3_ORDEM
	'Z8_CHVRM'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	30																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Chave TIN RM'															, ; //X3_TITULO
	'Chave TIN RM'															, ; //X3_TITSPA
	'Chave TIN RM'															, ; //X3_TITENG
	'Chave TIN RM'															, ; //X3_DESCRIC
	'Chave TIN RM'															, ; //X3_DESCSPA
	'Chave TIN RM'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(65)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZ8'																	, ; //X3_ARQUIVO
	'29'																	, ; //X3_ORDEM
	'Z8_CHVPROT'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	30																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Chave Prothe'															, ; //X3_TITULO
	'Chave Prothe'															, ; //X3_TITSPA
	'Chave Prothe'															, ; //X3_TITENG
	'Chave primaria Protheus'												, ; //X3_DESCRIC
	'Chave primaria Protheus'												, ; //X3_DESCSPA
	'Chave primaria Protheus'												, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(65)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZ8'																	, ; //X3_ARQUIVO
	'30'																	, ; //X3_ORDEM
	'Z8_VLATTIN'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	14																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Vl.Atualizad'															, ; //X3_TITULO
	'Vl.Atualizad'															, ; //X3_TITSPA
	'Vl.Atualizad'															, ; //X3_TITENG
	'Valor Atualizado parcela'												, ; //X3_DESCRIC
	'Valor Atualizado parcela'												, ; //X3_DESCSPA
	'Valor Atualizado parcela'												, ; //X3_DESCENG
	'@E 99,999,999,999.99'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(65)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZ8'																	, ; //X3_ARQUIVO
	'31'																	, ; //X3_ORDEM
	'Z8_VLATDES'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	14																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Vl. Parceiro'															, ; //X3_TITULO
	'Vl. Parceiro'															, ; //X3_TITSPA
	'Vl. Parceiro'															, ; //X3_TITENG
	'Vl atualizado do parceiro'												, ; //X3_DESCRIC
	'Vl atualizado do parceiro'												, ; //X3_DESCSPA
	'Vl atualizado do parceiro'												, ; //X3_DESCENG
	'@E 99,999,999,999.99'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(65)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZ8'																	, ; //X3_ARQUIVO
	'32'																	, ; //X3_ORDEM
	'Z8_VALOK'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Vl Consisten'															, ; //X3_TITULO
	'Vl Consisten'															, ; //X3_TITSPA
	'Vl Consisten'															, ; //X3_TITENG
	'Vl pago consistente'													, ; //X3_DESCRIC
	'Vl pago consistente'													, ; //X3_DESCSPA
	'Vl pago consistente'													, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(65)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	'1=SIM;2=NAO'															, ; //X3_CBOX
	'1=SIM;2=NAO'															, ; //X3_CBOXSPA
	'1=SIM;2=NAO'															, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZ8'																	, ; //X3_ARQUIVO
	'33'																	, ; //X3_ORDEM
	'Z8_VLPART'																, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	14																		, ; //X3_TAMANHO
	2																		, ; //X3_DECIMAL
	'Pg-tx.ad-seg'															, ; //X3_TITULO
	'Pg-tx.ad-seg'															, ; //X3_TITSPA
	'Pg-tx.ad-seg'															, ; //X3_TITENG
	'Vl pago-tx.adm-seg.presta'												, ; //X3_DESCRIC
	'Vl pago-tx.adm-seg.presta'												, ; //X3_DESCSPA
	'Vl pago-tx.adm-seg.presta'												, ; //X3_DESCENG
	'@E 99,999,999,999.99'													, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(65)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZ8'																	, ; //X3_ARQUIVO
	'34'																	, ; //X3_ORDEM
	'Z8_DTPROC'																, ; //X3_CAMPO
	'D'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Dt processam'															, ; //X3_TITULO
	'Dt processam'															, ; //X3_TITSPA
	'Dt processam'															, ; //X3_TITENG
	'Dt.processa baixa'														, ; //X3_DESCRIC
	'Dt.processa baixa'														, ; //X3_DESCSPA
	'Dt.processa baixa'														, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(65)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

//
// Campos Tabela SZB
//
aAdd( aSX3, { ;
	'SZB'																	, ; //X3_ARQUIVO
	'01'																	, ; //X3_ORDEM
	'ZB_FILIAL'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	7																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Filial'																, ; //X3_TITULO
	'Sucursal'																, ; //X3_TITSPA
	'Branch'																, ; //X3_TITENG
	'Filial do Sistema'														, ; //X3_DESCRIC
	'Sucursal'																, ; //X3_DESCSPA
	'Branch of the System'													, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	'033'																	, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	''																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	''																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZB'																	, ; //X3_ARQUIVO
	'02'																	, ; //X3_ORDEM
	'ZB_FILTIT'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	7																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Filial Titul'															, ; //X3_TITULO
	'Filial Titul'															, ; //X3_TITSPA
	'Filial Titul'															, ; //X3_TITENG
	'Filial Titulo'															, ; //X3_DESCRIC
	'Filial Titulo'															, ; //X3_DESCSPA
	'Filial Titulo'															, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZB'																	, ; //X3_ARQUIVO
	'03'																	, ; //X3_ORDEM
	'ZB_PREFIXO'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	3																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Prefixo'																, ; //X3_TITULO
	'Prefixo'																, ; //X3_TITSPA
	'Prefixo'																, ; //X3_TITENG
	'Prefixo'																, ; //X3_DESCRIC
	'Prefixo'																, ; //X3_DESCSPA
	'Prefixo'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZB'																	, ; //X3_ARQUIVO
	'04'																	, ; //X3_ORDEM
	'ZB_NUM'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	9																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Numero'																, ; //X3_TITULO
	'Numero'																, ; //X3_TITSPA
	'Numero'																, ; //X3_TITENG
	'Numero'																, ; //X3_DESCRIC
	'Numero'																, ; //X3_DESCSPA
	'Numero'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZB'																	, ; //X3_ARQUIVO
	'05'																	, ; //X3_ORDEM
	'ZB_PARCELA'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	3																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Parcela'																, ; //X3_TITULO
	'Parcela'																, ; //X3_TITSPA
	'Parcela'																, ; //X3_TITENG
	'Parcela'																, ; //X3_DESCRIC
	'Parcela'																, ; //X3_DESCSPA
	'Parcela'																, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZB'																	, ; //X3_ARQUIVO
	'06'																	, ; //X3_ORDEM
	'ZB_TIPO'																, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	3																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Tipo'																	, ; //X3_TITULO
	'Tipo'																	, ; //X3_TITSPA
	'Tipo'																	, ; //X3_TITENG
	'Tipo'																	, ; //X3_DESCRIC
	'Tipo'																	, ; //X3_DESCSPA
	'Tipo'																	, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZB'																	, ; //X3_ARQUIVO
	'07'																	, ; //X3_ORDEM
	'ZB_OPERACA'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	6																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Operacao'																, ; //X3_TITULO
	'Operacao'																, ; //X3_TITSPA
	'Operacao'																, ; //X3_TITENG
	'Operacao UPSERT DELETE'												, ; //X3_DESCRIC
	'Operacao UPSERT DELETE'												, ; //X3_DESCSPA
	'Operacao UPSERT DELETE'												, ; //X3_DESCENG
	''																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'SZB'																	, ; //X3_ARQUIVO
	'08'																	, ; //X3_ORDEM
	'ZB_PROCESS'															, ; //X3_CAMPO
	'N'																		, ; //X3_TIPO
	1																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Processado'															, ; //X3_TITULO
	'Processado'															, ; //X3_TITSPA
	'Processado'															, ; //X3_TITENG
	'Processado  0=Nao,1=Sim'												, ; //X3_DESCRIC
	'Processado  0=Nao,1=Sim'												, ; //X3_DESCSPA
	'Processado  0=Nao,1=Sim'												, ; //X3_DESCENG
	'9'																		, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	0																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		, ; //X3_CONDSQL
	''																		, ; //X3_CHKSQL
	''																		, ; //X3_IDXSRV
	'N'																		, ; //X3_ORTOGRA
	''																		, ; //X3_TELA
	''																		, ; //X3_POSLGT
	'N'																		, ; //X3_IDXFLD
	''																		, ; //X3_AGRUP
	''																		, ; //X3_MODAL
	''																		} ) //X3_PYME


//
// Atualizando dicionário
//
nPosArq := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_ARQUIVO" } )
nPosOrd := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_ORDEM"   } )
nPosCpo := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_CAMPO"   } )
nPosTam := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_TAMANHO" } )
nPosSXG := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_GRPSXG"  } )
nPosVld := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_VALID"   } )

aSort( aSX3,,, { |x,y| x[nPosArq]+x[nPosOrd]+x[nPosCpo] < y[nPosArq]+y[nPosOrd]+y[nPosCpo] } )

oProcess:SetRegua2( Len( aSX3 ) )

dbSelectArea( "SX3" )
dbSetOrder( 2 )
cAliasAtu := ""

For nI := 1 To Len( aSX3 )

	//
	// Verifica se o campo faz parte de um grupo e ajusta tamanho
	//
	If !Empty( aSX3[nI][nPosSXG] )
		SXG->( dbSetOrder( 1 ) )
		If SXG->( MSSeek( aSX3[nI][nPosSXG] ) )
			If aSX3[nI][nPosTam] <> SXG->XG_SIZE
				aSX3[nI][nPosTam] := SXG->XG_SIZE
				AutoGrLog( "O tamanho do campo " + aSX3[nI][nPosCpo] + " NÃO atualizado e foi mantido em [" + ;
				AllTrim( Str( SXG->XG_SIZE ) ) + "]" + CRLF + ;
				" por pertencer ao grupo de campos [" + SXG->XG_GRUPO + "]" + CRLF )
			EndIf
		EndIf
	EndIf

	SX3->( dbSetOrder( 2 ) )

	If !( aSX3[nI][nPosArq] $ cAlias )
		cAlias += aSX3[nI][nPosArq] + "/"
		aAdd( aArqUpd, aSX3[nI][nPosArq] )
	EndIf

	If !SX3->( dbSeek( PadR( aSX3[nI][nPosCpo], nTamSeek ) ) )

		//
		// Busca ultima ocorrencia do alias
		//
		If ( aSX3[nI][nPosArq] <> cAliasAtu )
			cSeqAtu   := "00"
			cAliasAtu := aSX3[nI][nPosArq]

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
				SX3->( FieldPut( FieldPos( aEstrut[nJ][1] ), aSX3[nI][nJ] ) )

			EndIf
		Next nJ

		dbCommit()
		MsUnLock()

		AutoGrLog( "Criado campo " + aSX3[nI][nPosCpo] )

	EndIf

	oProcess:IncRegua2( "Atualizando Campos de Tabelas (SX3)..." )

Next nI

AutoGrLog( CRLF + "Final da Atualização" + " SX3" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSIX
Função de processamento da gravação do SIX - Indices

@author TOTVS Protheus
@since  18/08/2016
@obs    Gerado por EXPORDIC - V.4.25.11.9 EFS / Upd. V.4.20.13 EFS
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

AutoGrLog( "Ínicio da Atualização" + " SIX" + CRLF )

aEstrut := { "INDICE" , "ORDEM" , "CHAVE", "DESCRICAO", "DESCSPA"  , ;
             "DESCENG", "PROPRI", "F3"   , "NICKNAME" , "SHOWPESQ" }

//
// Tabela SZ8
//
aAdd( aSIX, { ;
	'SZ8'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'Z8_FILIAL+Z8_EMPREEN+Z8_BLOCO+Z8_UNIDADE+Z8_CPFCNPJ+Z8_PARCELA+Z8_COMPONE+Z8_GRUPO', ; //CHAVE
	'Empreendimen+Bloco+Unidade+Cpf/Cnpj Cli+Parcela+Componente+Grupo'		, ; //DESCRICAO
	'Empreendimen+Bloco+Unidade+Cpf/Cnpj Cli+Parcela+Componente+Grupo'		, ; //DESCSPA
	'Empreendimen+Bloco+Unidade+Cpf/Cnpj Cli+Parcela+Componente+Grupo'		, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	'SZ8001'																, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SZ8'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'Z8_CHVPROT'															, ; //CHAVE
	'Chave Prothe'															, ; //DESCRICAO
	'Chave Prothe'															, ; //DESCSPA
	'Chave Prothe'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	'SZ8002'																, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SZ8'																	, ; //INDICE
	'3'																		, ; //ORDEM
	'Z8_CHVRM'																, ; //CHAVE
	'Chave TIN RM'															, ; //DESCRICAO
	'Chave TIN RM'															, ; //DESCSPA
	'Chave TIN RM'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	'SZ8003'																, ; //NICKNAME
	'S'																		} ) //SHOWPESQ

//
// Tabela SZB
//
aAdd( aSIX, { ;
	'SZB'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'ZB_FILIAL+ZB_FILTIT+ZB_PREFIXO+ZB_NUM+ZB_PARCELA+ZB_TIPO+ZB_OPERACA'		, ; //CHAVE
	'Filial Titul+Prefixo+Numero+Parcela+Tipo+Operacao'						, ; //DESCRICAO
	'Filial Titul+Prefixo+Numero+Parcela+Tipo+Operacao'						, ; //DESCSPA
	'Filial Titul+Prefixo+Numero+Parcela+Tipo+Operacao'						, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	'SZB001'																, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SZB'																	, ; //INDICE
	'2'																		, ; //ORDEM
	'ZB_PROCESS'															, ; //CHAVE
	'Processado'															, ; //DESCRICAO
	'Processado'															, ; //DESCSPA
	'Processado'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	'SZB002'																, ; //NICKNAME
	'N'																		} ) //SHOWPESQ

//
// Atualizando dicionário
//
oProcess:SetRegua2( Len( aSIX ) )

dbSelectArea( "SIX" )
SIX->( dbSetOrder( 1 ) )

For nI := 1 To Len( aSIX )

	lAlt    := .F.
	lDelInd := .F.

	If !SIX->( dbSeek( aSIX[nI][1] + aSIX[nI][2] ) )
		AutoGrLog( "Índice criado " + aSIX[nI][1] + "/" + aSIX[nI][2] + " - " + aSIX[nI][3] )
	Else
		lAlt := .T.
		aAdd( aArqUpd, aSIX[nI][1] )
		If !StrTran( Upper( AllTrim( CHAVE )       ), " ", "" ) == ;
		    StrTran( Upper( AllTrim( aSIX[nI][3] ) ), " ", "" )
			AutoGrLog( "Chave do índice alterado " + aSIX[nI][1] + "/" + aSIX[nI][2] + " - " + aSIX[nI][3] )
			lDelInd := .T. // Se for alteração precisa apagar o indice do banco
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

	oProcess:IncRegua2( "Atualizando índices..." )

Next nI

AutoGrLog( CRLF + "Final da Atualização" + " SIX" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSX6
Função de processamento da gravação do SX6 - Parâmetros

@author TOTVS Protheus
@since  18/08/2016
@obs    Gerado por EXPORDIC - V.4.25.11.9 EFS / Upd. V.4.20.13 EFS
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

AutoGrLog( "Ínicio da Atualização" + " SX6" + CRLF )

aEstrut := { "X6_FIL"    , "X6_VAR"    , "X6_TIPO"   , "X6_DESCRIC", "X6_DSCSPA" , "X6_DSCENG" , "X6_DESC1"  , ;
             "X6_DSCSPA1", "X6_DSCENG1", "X6_DESC2"  , "X6_DSCSPA2", "X6_DSCENG2", "X6_CONTEUD", "X6_CONTSPA", ;
             "X6_CONTENG", "X6_PROPRI" , "X6_VALID"  , "X6_INIT"   , "X6_DEFPOR" , "X6_DEFSPA" , "X6_DEFENG" , ;
             "X6_PYME"   }

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'AS_FINALTI'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Título a pagar com aprovação iniciada no Fluig'						, ; //X6_DESCRIC
	'Título a pagar com aprovação iniciada no Fluig'						, ; //X6_DSCSPA
	'Título a pagar com aprovação iniciada no Fluig'						, ; //X6_DSCENG
	'pode ser alterado? Indique S ou N'										, ; //X6_DESC1
	'pode ser alterado? Indique S ou N'										, ; //X6_DSCSPA1
	'pode ser alterado? Indique S ou N'										, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'S'																		, ; //X6_CONTEUD
	'S'																		, ; //X6_CONTSPA
	'S'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'AS_MOTDAC'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Motivo da baixa dos títulos a receber baixados'						, ; //X6_DESCRIC
	'Motivo da baixa dos títulos a receber baixados'						, ; //X6_DSCSPA
	'Motivo da baixa dos títulos a receber baixados'						, ; //X6_DSCENG
	'via arquivo de baixas de parceiros. Parte dos'							, ; //X6_DESC1
	'via arquivo de baixas de parceiros. Parte dos'							, ; //X6_DSCSPA1
	'via arquivo de baixas de parceiros. Parte dos'							, ; //X6_DSCENG1
	'parceiros - DAÇÃO. Exemplo: PAR'										, ; //X6_DESC2
	'parceiros - DAÇÃO. Exemplo: PAR'										, ; //X6_DSCSPA2
	'parceiros - DAÇÃO. Exemplo: PAR'										, ; //X6_DSCENG2
	'PAR'																	, ; //X6_CONTEUD
	'PAR'																	, ; //X6_CONTSPA
	'PAR'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'AS_MOTMUT'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Motivo de baixa para títulos de mútuo a receber e'						, ; //X6_DESCRIC
	'Motivo de baixa para títulos de mútuo a receber e'						, ; //X6_DSCSPA
	'Motivo de baixa para títulos de mútuo a receber e'						, ; //X6_DSCENG
	'a pagar de mútuo'														, ; //X6_DESC1
	'a pagar de mútuo'														, ; //X6_DSCSPA1
	'a pagar de mútuo'														, ; //X6_DSCENG1
	'Exemplo: MUT'															, ; //X6_DESC2
	'Exemplo: MUT'															, ; //X6_DSCSPA2
	'Exemplo: MUT'															, ; //X6_DSCENG2
	'MUT'																	, ; //X6_CONTEUD
	'MUT'																	, ; //X6_CONTSPA
	'MUT'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'AS_MOTPAR'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Motivo da baixa dos títulos a receber baixados'						, ; //X6_DESCRIC
	'Motivo da baixa dos títulos a receber baixados'						, ; //X6_DSCSPA
	'Motivo da baixa dos títulos a receber baixados'						, ; //X6_DSCENG
	'via arquivo de baixas de parceiros'									, ; //X6_DESC1
	'via arquivo de baixas de parceiros'									, ; //X6_DSCSPA1
	'via arquivo de baixas de parceiros'									, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'NOR'																	, ; //X6_CONTEUD
	'NOR'																	, ; //X6_CONTSPA
	'NOR'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'AS_MOTSEC'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Motivo da baixa dos títulos a receber baixados'						, ; //X6_DESCRIC
	'Motivo da baixa dos títulos a receber baixados'						, ; //X6_DSCSPA
	'Motivo da baixa dos títulos a receber baixados'						, ; //X6_DSCENG
	'via arquivo de baixas de parceiros quando for'							, ; //X6_DESC1
	'via arquivo de baixas de parceiros quando for'							, ; //X6_DSCSPA1
	'via arquivo de baixas de parceiros quando for'							, ; //X6_DSCENG1
	'título securitizado'													, ; //X6_DESC2
	'título securitizado'													, ; //X6_DSCSPA2
	'título securitizado'													, ; //X6_DSCENG2
	'NOR'																	, ; //X6_CONTEUD
	'NOR'																	, ; //X6_CONTSPA
	'NOR'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'AS_SITSE1'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Situações dos títulos a receber securitizados.'						, ; //X6_DESCRIC
	'Situações dos títulos a receber securitizados.'						, ; //X6_DSCSPA
	'Situações dos títulos a receber securitizados.'						, ; //X6_DSCENG
	"Sep. p/ '|'. Exemplo: 0|1"												, ; //X6_DESC1
	"Sep. p/ '|'. Exemplo: 0|1"												, ; //X6_DSCSPA1
	"Sep. p/ '|'. Exemplo: 0|1"												, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'8'																		, ; //X6_CONTEUD
	'8'																		, ; //X6_CONTSPA
	'8'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'AS_SITSE9'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Situações dos títulos a receber securitizados'							, ; //X6_DESCRIC
	'Situações dos títulos a receber securitizados'							, ; //X6_DSCSPA
	'Situações dos títulos a receber securitizados'							, ; //X6_DSCENG
	"vencidos. Sep. p/ '|'. Exemplo: 2"										, ; //X6_DESC1
	"vencidos. Sep. p/ '|'. Exemplo: 2"										, ; //X6_DSCSPA1
	"vencidos. Sep. p/ '|'. Exemplo: 2"										, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'9'																		, ; //X6_CONTEUD
	'9'																		, ; //X6_CONTSPA
	'9'																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0010001'																, ; //X6_FIL
	'AS_BCOPAR'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DESCRIC
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCSPA
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCENG
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DESC1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCSPA1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCENG1
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DESC2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCSPA2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCENG2
	'001|0001|0000001'														, ; //X6_CONTEUD
	'001|0001|0000001'														, ; //X6_CONTSPA
	'001|0001|0000001'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0010002'																, ; //X6_FIL
	'AS_BCOPAR'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DESCRIC
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCSPA
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCENG
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DESC1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCSPA1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCENG1
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DESC2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCSPA2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCENG2
	'001|0001|0000001'														, ; //X6_CONTEUD
	'001|0001|0000001'														, ; //X6_CONTSPA
	'001|0001|0000001'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0020001'																, ; //X6_FIL
	'AS_BCOPAR'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DESCRIC
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCSPA
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCENG
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DESC1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCSPA1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCENG1
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DESC2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCSPA2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCENG2
	'001|0001|0000001'														, ; //X6_CONTEUD
	'001|0001|0000001'														, ; //X6_CONTSPA
	'001|0001|0000001'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0030001'																, ; //X6_FIL
	'AS_BCOPAR'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DESCRIC
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCSPA
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCENG
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DESC1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCSPA1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCENG1
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DESC2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCSPA2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCENG2
	'001|0001|0000001'														, ; //X6_CONTEUD
	'001|0001|0000001'														, ; //X6_CONTSPA
	'001|0001|0000001'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0040001'																, ; //X6_FIL
	'AS_BCOPAR'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DESCRIC
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCSPA
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCENG
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DESC1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCSPA1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCENG1
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DESC2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCSPA2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCENG2
	'001|0001|0000001'														, ; //X6_CONTEUD
	'001|0001|0000001'														, ; //X6_CONTSPA
	'001|0001|0000001'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0050001'																, ; //X6_FIL
	'AS_BCOPAR'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DESCRIC
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCSPA
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCENG
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DESC1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCSPA1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCENG1
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DESC2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCSPA2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCENG2
	'001|0001|0000001'														, ; //X6_CONTEUD
	'001|0001|0000001'														, ; //X6_CONTSPA
	'001|0001|0000001'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0060001'																, ; //X6_FIL
	'AS_BCOPAR'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DESCRIC
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCSPA
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCENG
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DESC1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCSPA1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCENG1
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DESC2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCSPA2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCENG2
	'001|0001|0000001'														, ; //X6_CONTEUD
	'001|0001|0000001'														, ; //X6_CONTSPA
	'001|0001|0000001'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0070001'																, ; //X6_FIL
	'AS_BCOPAR'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DESCRIC
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCSPA
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCENG
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DESC1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCSPA1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCENG1
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DESC2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCSPA2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCENG2
	'001|0001|0000001'														, ; //X6_CONTEUD
	'001|0001|0000001'														, ; //X6_CONTSPA
	'001|0001|0000001'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0080001'																, ; //X6_FIL
	'AS_BCOPAR'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DESCRIC
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCSPA
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCENG
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DESC1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCSPA1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCENG1
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DESC2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCSPA2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCENG2
	'001|0001|0000001'														, ; //X6_CONTEUD
	'001|0001|0000001'														, ; //X6_CONTSPA
	'001|0001|0000001'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0090001'																, ; //X6_FIL
	'AS_BCOPAR'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DESCRIC
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCSPA
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCENG
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DESC1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCSPA1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCENG1
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DESC2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCSPA2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCENG2
	'001|0001|0000001'														, ; //X6_CONTEUD
	'001|0001|0000001'														, ; //X6_CONTSPA
	'001|0001|0000001'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0100001'																, ; //X6_FIL
	'AS_BCOPAR'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DESCRIC
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCSPA
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCENG
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DESC1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCSPA1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCENG1
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DESC2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCSPA2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCENG2
	'001|0001|0000001'														, ; //X6_CONTEUD
	'001|0001|0000001'														, ; //X6_CONTSPA
	'001|0001|0000001'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0110001'																, ; //X6_FIL
	'AS_BCOPAR'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DESCRIC
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCSPA
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCENG
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DESC1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCSPA1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCENG1
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DESC2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCSPA2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCENG2
	'001|0001|0000001'														, ; //X6_CONTEUD
	'001|0001|0000001'														, ; //X6_CONTSPA
	'001|0001|0000001'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0120001'																, ; //X6_FIL
	'AS_BCOPAR'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DESCRIC
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCSPA
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCENG
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DESC1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCSPA1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCENG1
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DESC2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCSPA2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCENG2
	'001|0001|0000001'														, ; //X6_CONTEUD
	'001|0001|0000001'														, ; //X6_CONTSPA
	'001|0001|0000001'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0130001'																, ; //X6_FIL
	'AS_BCOPAR'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DESCRIC
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCSPA
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCENG
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DESC1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCSPA1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCENG1
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DESC2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCSPA2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCENG2
	'001|0001|0000001'														, ; //X6_CONTEUD
	'001|0001|0000001'														, ; //X6_CONTSPA
	'001|0001|0000001'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0140001'																, ; //X6_FIL
	'AS_BCOPAR'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DESCRIC
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCSPA
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCENG
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DESC1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCSPA1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCENG1
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DESC2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCSPA2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCENG2
	'001|0001|0000001'														, ; //X6_CONTEUD
	'001|0001|0000001'														, ; //X6_CONTSPA
	'001|0001|0000001'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0150001'																, ; //X6_FIL
	'AS_BCOPAR'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DESCRIC
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCSPA
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCENG
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DESC1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCSPA1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCENG1
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DESC2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCSPA2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCENG2
	'001|0001|0000001'														, ; //X6_CONTEUD
	'001|0001|0000001'														, ; //X6_CONTSPA
	'001|0001|0000001'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0160001'																, ; //X6_FIL
	'AS_BCOPAR'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DESCRIC
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCSPA
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCENG
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DESC1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCSPA1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCENG1
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DESC2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCSPA2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCENG2
	'001|0001|0000001'														, ; //X6_CONTEUD
	'001|0001|0000001'														, ; //X6_CONTSPA
	'001|0001|0000001'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0170001'																, ; //X6_FIL
	'AS_BCOPAR'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DESCRIC
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCSPA
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCENG
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DESC1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCSPA1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCENG1
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DESC2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCSPA2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCENG2
	'001|0001|0000001'														, ; //X6_CONTEUD
	'001|0001|0000001'														, ; //X6_CONTSPA
	'001|0001|0000001'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0180001'																, ; //X6_FIL
	'AS_BCOPAR'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DESCRIC
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCSPA
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCENG
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DESC1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCSPA1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCENG1
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DESC2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCSPA2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCENG2
	'001|0001|0000001'														, ; //X6_CONTEUD
	'001|0001|0000001'														, ; //X6_CONTSPA
	'001|0001|0000001'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0180002'																, ; //X6_FIL
	'AS_BCOPAR'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DESCRIC
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCSPA
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCENG
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DESC1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCSPA1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCENG1
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DESC2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCSPA2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCENG2
	'001|0001|0000001'														, ; //X6_CONTEUD
	'001|0001|0000001'														, ; //X6_CONTSPA
	'001|0001|0000001'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0190001'																, ; //X6_FIL
	'AS_BCOPAR'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DESCRIC
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCSPA
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCENG
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DESC1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCSPA1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCENG1
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DESC2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCSPA2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCENG2
	'001|0001|0000001'														, ; //X6_CONTEUD
	'001|0001|0000001'														, ; //X6_CONTSPA
	'001|0001|0000001'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0200001'																, ; //X6_FIL
	'AS_BCOPAR'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DESCRIC
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCSPA
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCENG
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DESC1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCSPA1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCENG1
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DESC2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCSPA2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCENG2
	'001|0001|0000001'														, ; //X6_CONTEUD
	'001|0001|0000001'														, ; //X6_CONTSPA
	'001|0001|0000001'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0210001'																, ; //X6_FIL
	'AS_BCOPAR'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DESCRIC
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCSPA
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCENG
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DESC1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCSPA1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCENG1
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DESC2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCSPA2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCENG2
	'001|0001|0000001'														, ; //X6_CONTEUD
	'001|0001|0000001'														, ; //X6_CONTSPA
	'001|0001|0000001'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0220001'																, ; //X6_FIL
	'AS_BCOPAR'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DESCRIC
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCSPA
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCENG
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DESC1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCSPA1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCENG1
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DESC2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCSPA2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCENG2
	'001|0001|0000001'														, ; //X6_CONTEUD
	'001|0001|0000001'														, ; //X6_CONTSPA
	'001|0001|0000001'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0220002'																, ; //X6_FIL
	'AS_BCOPAR'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DESCRIC
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCSPA
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCENG
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DESC1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCSPA1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCENG1
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DESC2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCSPA2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCENG2
	'001|0001|0000001'														, ; //X6_CONTEUD
	'001|0001|0000001'														, ; //X6_CONTSPA
	'001|0001|0000001'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0230001'																, ; //X6_FIL
	'AS_BCOPAR'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DESCRIC
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCSPA
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCENG
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DESC1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCSPA1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCENG1
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DESC2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCSPA2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCENG2
	'001|0001|0000001'														, ; //X6_CONTEUD
	'001|0001|0000001'														, ; //X6_CONTSPA
	'001|0001|0000001'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0240001'																, ; //X6_FIL
	'AS_BCOPAR'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DESCRIC
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCSPA
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCENG
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DESC1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCSPA1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCENG1
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DESC2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCSPA2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCENG2
	'001|0001|0000001'														, ; //X6_CONTEUD
	'001|0001|0000001'														, ; //X6_CONTSPA
	'001|0001|0000001'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'0250001'																, ; //X6_FIL
	'AS_BCOPAR'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DESCRIC
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCSPA
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCENG
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DESC1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCSPA1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCENG1
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DESC2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCSPA2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCENG2
	'001|0001|0000001'														, ; //X6_CONTEUD
	'001|0001|0000001'														, ; //X6_CONTSPA
	'001|0001|0000001'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'9970001'																, ; //X6_FIL
	'AS_BCOPAR'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DESCRIC
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCSPA
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCENG
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DESC1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCSPA1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCENG1
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DESC2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCSPA2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCENG2
	'001|0001|0000001'														, ; //X6_CONTEUD
	'001|0001|0000001'														, ; //X6_CONTSPA
	'001|0001|0000001'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'9980001'																, ; //X6_FIL
	'AS_BCOPAR'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DESCRIC
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCSPA
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCENG
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DESC1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCSPA1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCENG1
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DESC2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCSPA2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCENG2
	'001|0001|0000001'														, ; //X6_CONTEUD
	'001|0001|0000001'														, ; //X6_CONTSPA
	'001|0001|0000001'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'9990001'																, ; //X6_FIL
	'AS_BCOPAR'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DESCRIC
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCSPA
	'Código do banco, nro da agência e nro da conta p/'						, ; //X6_DSCENG
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DESC1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCSPA1
	'baixa de título a receber de parceiros. Exclusivo'						, ; //X6_DSCENG1
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DESC2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCSPA2
	"p/ filial. Sep.p/'|'. Exemplo: 001|0001|0000001"						, ; //X6_DSCENG2
	'001|0001|0000001'														, ; //X6_CONTEUD
	'001|0001|0000001'														, ; //X6_CONTSPA
	'001|0001|0000001'														, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

//
// Atualizando dicionário
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
		AutoGrLog( "Foi incluído o parâmetro " + aSX6[nI][1] + aSX6[nI][2] + " Conteúdo [" + AllTrim( aSX6[nI][13] ) + "]" )
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

AutoGrLog( CRLF + "Final da Atualização" + " SX6" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} EscEmpresa
Função genérica para escolha de Empresa, montada pelo SM0

@return aRet Vetor contendo as seleções feitas.
             Se não for marcada nenhuma o vetor volta vazio

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function EscEmpresa()

//---------------------------------------------
// Parâmetro  nTipo
// 1 - Monta com Todas Empresas/Filiais
// 2 - Monta só com Empresas
// 3 - Monta só com Filiais de uma Empresa
//
// Parâmetro  aMarcadas
// Vetor com Empresas/Filiais pré marcadas
//
// Parâmetro  cEmpSel
// Empresa que será usada para montar seleção
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

oDlg:cToolTip := "Tela para Múltiplas Seleções de Empresas/Filiais"

oDlg:cTitle   := "Selecione a(s) Empresa(s) para Atualização"

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
Message "Máscara Empresa ( ?? )"  Of oDlg
oSay:cToolTip := oMascEmp:cToolTip

@ 128, 10 Button oButInv    Prompt "&Inverter"  Size 32, 12 Pixel Action ( InvSelecao( @aVetor, oLbx, @lChk, oChkMar ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Inverter Seleção" Of oDlg
oButInv:SetCss( CSSBOTAO )
@ 128, 50 Button oButMarc   Prompt "&Marcar"    Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .T. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Marcar usando" + CRLF + "máscara ( ?? )"    Of oDlg
oButMarc:SetCss( CSSBOTAO )
@ 128, 80 Button oButDMar   Prompt "&Desmarcar" Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .F. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Desmarcar usando" + CRLF + "máscara ( ?? )" Of oDlg
oButDMar:SetCss( CSSBOTAO )
@ 112, 157  Button oButOk   Prompt "Processar"  Size 32, 12 Pixel Action (  RetSelecao( @aRet, aVetor ), oDlg:End()  ) ;
Message "Confirma a seleção e efetua" + CRLF + "o processamento" Of oDlg
oButOk:SetCss( CSSBOTAO )
@ 128, 157  Button oButCanc Prompt "Cancelar"   Size 32, 12 Pixel Action ( IIf( lTeveMarc, aRet :=  aMarcadas, .T. ), oDlg:End() ) ;
Message "Cancela o processamento" + CRLF + "e abandona a aplicação" Of oDlg
oButCanc:SetCss( CSSBOTAO )

Activate MSDialog  oDlg Center

RestArea( aSalvAmb )
dbSelectArea( "SM0" )
dbCloseArea()

Return  aRet


//--------------------------------------------------------------------
/*/{Protheus.doc} MarcaTodos
Função auxiliar para marcar/desmarcar todos os ítens do ListBox ativo

@param lMarca  Contéudo para marca .T./.F.
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
Função auxiliar para inverter a seleção do ListBox ativo

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
Função auxiliar que monta o retorno com as seleções

@param aRet    Array que terá o retorno das seleções (é alterado internamente)
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
Função para marcar/desmarcar usando máscaras

@param oLbx     Objeto do ListBox
@param aVetor   Vetor do ListBox
@param cMascEmp Campo com a máscara (???)
@param lMarDes  Marca a ser atribuída .T./.F.

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
Função auxiliar para verificar se estão todos marcados ou não

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
Função de processamento abertura do SM0 modo exclusivo

@author TOTVS Protheus
@since  18/08/2016
@obs    Gerado por EXPORDIC - V.4.25.11.9 EFS / Upd. V.4.20.13 EFS
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
	MsgStop( "Não foi possível a abertura da tabela " + ;
	IIf( lShared, "de empresas (SM0).", "de empresas (SM0) de forma exclusiva." ), "ATENÇÃO" )
EndIf

Return lOpen


//--------------------------------------------------------------------
/*/{Protheus.doc} LeLog
Função de leitura do LOG gerado com limitacao de string

@author TOTVS Protheus
@since  18/08/2016
@obs    Gerado por EXPORDIC - V.4.25.11.9 EFS / Upd. V.4.20.13 EFS
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
		cRet += "Tamanho de exibição maxima do LOG alcançado." + CRLF
		cRet += "LOG Completo no arquivo " + cFile + CRLF
		cRet += Replicate( "=" , 128 ) + CRLF
		Exit
	EndIf

	FT_FSKIP()
End

FT_FUSE()

Return cRet


/////////////////////////////////////////////////////////////////////////////
