#Include 'Protheus.ch'

User Function UPDGERSX3()
#INCLUDE "PROTHEUS.CH"
#INCLUDE "UPSX303H.CH"

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
/*/{Protheus.doc} UPSX303H
Função de update de dicionários para compatibilização

@author TOTVS Protheus
@since  07/04/2015
@obs    Gerado por EXPORDIC - V.4.22.10.7 EFS / Upd. V.4.19.12 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
User Function UPSX303H( cEmpAmb, cFilAmb )

Local   aSay      := {}
Local   aButton   := {}
Local   aMarcadas := {}
Local   cTitulo   := STR0001 //"ATUALIZAÇÃO DE DICIONÁRIOS E TABELAS"
Local   cDesc1    := STR0002 //"Esta rotina tem como função fazer  a atualização  dos dicionários do Sistema ( SX?/SIX )"
Local   cDesc2    := STR0003 //"Este processo deve ser executado em modo EXCLUSIVO, ou seja não podem haver outros"
Local   cDesc3    := STR0004 //"usuários  ou  jobs utilizando  o sistema.  É EXTREMAMENTE recomendavél  que  se  faça um"
Local   cDesc4    := STR0005 //"BACKUP  dos DICIONÁRIOS  e da  BASE DE DADOS antes desta atualização, para que caso "
Local   cDesc5    := STR0006 //"ocorram eventuais falhas, esse backup possa ser restaurado."
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
		If lAuto .OR. MsgNoYes( STR0007, cTitulo ) //"Confirma a atualização dos dicionários ?"
			oProcess := MsNewProcess():New( { | lEnd | lOk := FSTProc( @lEnd, aMarcadas, lAuto ) }, STR0008, STR0009, .F. ) //"Atualizando"###"Aguarde, atualizando ..."
			oProcess:Activate()

			If lAuto
				If lOk
					MsgStop( STR0011, "UPSX303H" ) //"Atualização Realizada."
				Else
					MsgStop( STR0011, "UPSX303H" ) //"Atualização não Realizada."
				EndIf
				dbCloseAll()
			Else
				If lOk
					Final( STR0010 ) //"Atualização Concluída."
				Else
					Final( STR0011 ) //"Atualização não Realizada."
				EndIf
			EndIf

		Else
			MsgStop( STR0011, "UPSX303H" ) //"Atualização não Realizada."

		EndIf

	Else
		MsgStop( STR0011, "UPSX303H" ) //"Atualização não Realizada."

	EndIf

EndIf

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSTProc
Função de processamento da gravação dos arquivos

@author TOTVS Protheus
@since  07/04/2015
@obs    Gerado por EXPORDIC - V.4.22.10.7 EFS / Upd. V.4.19.12 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSTProc( lEnd, aMarcadas, lAuto )
Local   aInfo     := {}
Local   aRecnoSM0 := {}
Local   cAux      := ""
Local   cFile     := ""
Local   cFileLog  := ""
Local   cMask     := STR0012 + "(*.TXT)|*.txt|" //"Arquivos Texto"
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
				MsgStop( STR0013 + aRecnoSM0[nI][2] + STR0014 ) //"Atualização da empresa "###" não efetuada."
				Exit
			EndIf

			SM0->( dbGoTo( aRecnoSM0[nI][1] ) )

			RpcSetType( 3 )
			RpcSetEnv( SM0->M0_CODIGO, SM0->M0_CODFIL )

			lMsFinalAuto := .F.
			lMsHelpAuto  := .F.

			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( Replicate( " ", 128 ) )
			AutoGrLog( STR0032 ) //"LOG DA ATUALIZAÇÃO DOS DICIONÁRIOS"
			AutoGrLog( Replicate( " ", 128 ) )
			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( " " )
			AutoGrLog( STR0033 ) //" Dados Ambiente"
			AutoGrLog( " --------------------" )
			AutoGrLog( STR0034 + cEmpAnt + "/" + cFilAnt ) //" Empresa / Filial...: "
			AutoGrLog( STR0035 + Capital( AllTrim( GetAdvFVal( "SM0", "M0_NOMECOM", cEmpAnt + cFilAnt, 1, "" ) ) ) ) //" Nome Empresa.......: "
			AutoGrLog( STR0036 + Capital( AllTrim( GetAdvFVal( "SM0", "M0_FILIAL" , cEmpAnt + cFilAnt, 1, "" ) ) ) ) //" Nome Filial........: "
			AutoGrLog( STR0037 + DtoC( dDataBase ) ) //" DataBase...........: "
			AutoGrLog( STR0038 + DtoC( Date() )  + " / " + Time() ) //" Data / Hora Ínicio.: "
			AutoGrLog( STR0039 + GetEnvServer()  ) //" Environment........: "
			AutoGrLog( STR0040 + GetSrvProfString( "StartPath", "" ) ) //" StartPath..........: "
			AutoGrLog( STR0041 + GetSrvProfString( "RootPath" , "" ) ) //" RootPath...........: "
			AutoGrLog( STR0042 + GetVersao(.T.) ) //" Versão.............: "
			AutoGrLog( STR0043 + __cUserId + " " +  cUserName ) //" Usuário TOTVS .....: "
			AutoGrLog( STR0044 + GetComputerName() ) //" Computer Name......: "

			aInfo   := GetUserInfo()
			If ( nPos    := aScan( aInfo,{ |x,y| x[3] == ThreadId() } ) ) > 0
				AutoGrLog( " " )
				AutoGrLog( STR0045 ) //" Dados Thread"
				AutoGrLog( " --------------------" )
				AutoGrLog( STR0046 + aInfo[nPos][1] ) //" Usuário da Rede....: "
				AutoGrLog( STR0047 + aInfo[nPos][2] ) //" Estação............: "
				AutoGrLog( STR0048 + aInfo[nPos][5] ) //" Programa Inicial...: "
				AutoGrLog( STR0039 + aInfo[nPos][6] ) //" Environment........: "
				AutoGrLog( STR0049 + AllTrim( StrTran( StrTran( aInfo[nPos][7], Chr( 13 ), "" ), Chr( 10 ), "" ) ) ) //" Conexão............: "
			EndIf
			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( " " )

			If !lAuto
				AutoGrLog( Replicate( "-", 128 ) )
				AutoGrLog( STR0015 + SM0->M0_CODIGO + "/" + SM0->M0_NOME + CRLF ) //"Empresa : "
			EndIf

			oProcess:SetRegua1( 8 )

			//------------------------------------
			// Atualiza o dicionário SX3
			//------------------------------------
			FSAtuSX3()

			oProcess:IncRegua1( STR0018 + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." ) //"Dicionário de dados"
			oProcess:IncRegua2( STR0019 ) //"Atualizando campos/índices"

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
					MsgStop( STR0020 + aArqUpd[nX] + STR0021, STR0022 ) //"Ocorreu um erro desconhecido durante a atualização da tabela : "###". Verifique a integridade do dicionário e da tabela."###"ATENÇÃO"
					AutoGrLog( STR0023 + aArqUpd[nX] ) //"Ocorreu um erro desconhecido durante a atualização da estrutura da tabela : "
				EndIf

				If cTopBuild >= "20090811" .AND. TcInternal( 89 ) == "CLOB_SUPPORTED"
					TcInternal( 25, "OFF" )
				EndIf

			Next nX

			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( STR0050 + DtoC( Date() ) + " / " + Time() ) //" Data / Hora Final.: "
			AutoGrLog( Replicate( "-", 128 ) )

			RpcClearEnv()

		Next nI

		If !lAuto

			cTexto := LeLog()

			Define Font oFont Name "Mono AS" Size 5, 12

			Define MsDialog oDlg Title STR0051 From 3, 0 to 340, 417 Pixel //"Atualização concluida."

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
/*/{Protheus.doc} FSAtuSX3
Função de processamento da gravação do SX3 - Campos

@author TOTVS Protheus
@since  07/04/2015
@obs    Gerado por EXPORDIC - V.4.22.10.7 EFS / Upd. V.4.19.12 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSX3()
Local aEstrut   := {}
Local aSX3      := {}
Local cAlias    := ""
Local cAliasAtu := ""
Local cSeqAtu   := ""
Local cX3Campo  := ""
Local cX3Dado   := ""
Local nI        := 0
Local nJ        := 0
Local nPosArq   := 0
Local nPosCpo   := 0
Local nPosOrd   := 0
Local nPosSXG   := 0
Local nPosTam   := 0
Local nPosVld   := 0
Local nSeqAtu   := 0
Local nTamSeek  := Len( SX3->X3_CAMPO )

AutoGrLog( STR0055 + " SX3" + CRLF ) //"Ínicio da Atualização"

aEstrut := { { "X3_ARQUIVO", 0 }, { "X3_ORDEM"  , 0 }, { "X3_CAMPO"  , 0 }, { "X3_TIPO"   , 0 }, { "X3_TAMANHO", 0 }, { "X3_DECIMAL", 0 }, { "X3_TITULO" , 0 }, ;
             { "X3_TITSPA" , 0 }, { "X3_TITENG" , 0 }, { "X3_DESCRIC", 0 }, { "X3_DESCSPA", 0 }, { "X3_DESCENG", 0 }, { "X3_PICTURE", 0 }, { "X3_VALID"  , 0 }, ;
             { "X3_USADO"  , 0 }, { "X3_RELACAO", 0 }, { "X3_F3"     , 0 }, { "X3_NIVEL"  , 0 }, { "X3_RESERV" , 0 }, { "X3_CHECK"  , 0 }, { "X3_TRIGGER", 0 }, ;
             { "X3_PROPRI" , 0 }, { "X3_BROWSE" , 0 }, { "X3_VISUAL" , 0 }, { "X3_CONTEXT", 0 }, { "X3_OBRIGAT", 0 }, { "X3_VLDUSER", 0 }, { "X3_CBOX"   , 0 }, ;
             { "X3_CBOXSPA", 0 }, { "X3_CBOXENG", 0 }, { "X3_PICTVAR", 0 }, { "X3_WHEN"   , 0 }, { "X3_INIBRW" , 0 }, { "X3_GRPSXG" , 0 }, { "X3_FOLDER" , 0 }, ;
             { "X3_CONDSQL", 0 }, { "X3_CHKSQL" , 0 }, { "X3_IDXSRV" , 0 }, { "X3_ORTOGRA", 0 }, { "X3_TELA"   , 0 }, { "X3_IDXFLD" , 0 }, { "X3_AGRUP"  , 0 }, ;
             { "X3_PYME"   , 0 } }

aEval( aEstrut, { |x| x[2] := SX3->( FieldPos( x[1] ) ) } )

//
// --- ATENÇÃO ---
// Coloque .F. na 2a. posição de cada elemento do array, para os dados do SX3
// que não serão atualizados quando o campo já existir.
//

//
// Campos Tabela SA1
//
aAdd( aSX3, { ;
	{ 'SA1'																	, .F. }, ; //X3_ARQUIVO
	{ '08'																	, .F. }, ; //X3_ORDEM
	{ 'A1_XTPCLI'															, .F. }, ; //X3_CAMPO  //ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Tp.Registro'															, .F. }, ; //X3_TITULO
	{ 'Tp.Registro'															, .F. }, ; //X3_TITSPA
	{ 'Tp.Registro'															, .F. }, ; //X3_TITENG
	{ 'Tipo Registro'														, .F. }, ; //X3_DESCRIC
	{ 'Tipo Registro'														, .F. }, ; //X3_DESCSPA
	{ 'Tipo Registro'														, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)												, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ '€'																	, .F. }, ; //X3_OBRIGAT
	{ 'Pertence("19")'														, .F. }, ; //X3_VLDUSER
	{ '1=Cliente;9=Outros'													, .F. }, ; //X3_CBOX
	{ '1=Cliente;9=Outros'													, .F. }, ; //X3_CBOXSPA
	{ '1=Cliente;9=Outros'													, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '1'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA1'																	, .F. }, ; //X3_ARQUIVO
	{ 'F7'																	, .F. }, ; //X3_ORDEM
	{ 'A1_XCODMOB'														, .F. }, ; //X3_CAMPO  //ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 8																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'P.K. Roteir.'														, .F. }, ; //X3_TITULO
	{ 'P.K. Orient.'														, .F. }, ; //X3_TITSPA
	{ 'P.K. Roteir.'														, .F. }, ; //X3_TITENG
	{ 'Codigo roteirizador'													, .F. }, ; //X3_DESCRIC
	{ 'Codigo del orientador'												, .F. }, ; //X3_DESCSPA
	{ 'Router Code'															, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(140) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(137) + Chr(176) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(130) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ ''																	, .F. }, ; //X3_BROWSE
	{ ''																	, .F. }, ; //X3_VISUAL
	{ ''																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

//
// Campos Tabela SA2
//
aAdd( aSX3, { ;
	{ 'SA2'																, .F. }, ; //X3_ARQUIVO
	{ '03'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XINSCRE'														, .F. }, ; //X3_CAMPO  //ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 18																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Inscr. Estad'														, .F. }, ; //X3_TITULO
	{ 'Inscr. Estad'														, .F. }, ; //X3_TITSPA
	{ 'Inscr. Estad'														, .F. }, ; //X3_TITENG
	{ 'Inscricao Estadual'													, .F. }, ; //X3_DESCRIC
	{ 'Inscricao Estadual'													, .F. }, ; //X3_DESCSPA
	{ 'Inscricao Estadual'													, .F. }, ; //X3_DESCENG
	{ '@! 999.999.999.999'													, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ 'S'																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '1'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ '04'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XPISNIT'														, .F. }, ; //X3_CAMPO  //NAO ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 11																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'PIS/NIT'																, .F. }, ; //X3_TITULO
	{ 'PIS/NIT'																, .F. }, ; //X3_TITSPA
	{ 'PIS/NIT'																, .F. }, ; //X3_TITENG
	{ 'PIS/NIT'																, .F. }, ; //X3_DESCRIC
	{ 'PIS/NIT'																, .F. }, ; //X3_DESCSPA
	{ 'PIS/NIT'																, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '1'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ '05'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XINSCME'														, .F. }, ; //X3_CAMPO  //ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 18																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Inscr. Munic'														, .F. }, ; //X3_TITULO
	{ 'Inscr. Munic'														, .F. }, ; //X3_TITSPA
	{ 'Inscr. Munic'														, .F. }, ; //X3_TITENG
	{ 'Inscricao Municipal'													, .F. }, ; //X3_DESCRIC
	{ 'Inscricao Municipal'													, .F. }, ; //X3_DESCSPA
	{ 'Inscricao Municipal'													, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ 'S'																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '1'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ '10'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XTPFOR'															, .F. }, ; //X3_CAMPO  // ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Tp Registro'															, .F. }, ; //X3_TITULO
	{ 'Tp Registro'															, .F. }, ; //X3_TITSPA
	{ 'Tp Registro'															, .F. }, ; //X3_TITENG
	{ 'Tipo do Registro'													, .F. }, ; //X3_DESCRIC
	{ 'Tipo do Registro'													, .F. }, ; //X3_DESCSPA
	{ 'Tipo do Registro'													, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ '€'																	, .F. }, ; //X3_OBRIGAT
	{ 'Pertence("129 ")'													, .F. }, ; //X3_VLDUSER
	{ '1=Fornecedor;2=Funcionario;9=Outros'									, .F. }, ; //X3_CBOX
	{ '1=Fornecedor;2=Funcionario;9=Outros'									, .F. }, ; //X3_CBOXSPA
	{ '1=Fornecedor;2=Funcionario;9=Outros'									, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '1'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ '28'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XCELULA'														, .F. }, ; //X3_CAMPO   // ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 25																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Celular'																, .F. }, ; //X3_TITULO
	{ 'Celular'																, .F. }, ; //X3_TITSPA
	{ 'Celular'																, .F. }, ; //X3_TITENG
	{ 'Celular'																, .F. }, ; //X3_DESCRIC
	{ 'Celular'																, .F. }, ; //X3_DESCSPA
	{ 'Celular'																, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '1'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ '31'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XTELFIN'														, .F. }, ; //X3_CAMPO   //ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 25																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Tel.Financ.'															, .F. }, ; //X3_TITULO
	{ 'Tel.Financ.'															, .F. }, ; //X3_TITSPA
	{ 'Tel.Financ.'															, .F. }, ; //X3_TITENG
	{ 'Telefone Financeiro'													, .F. }, ; //X3_DESCRIC
	{ 'Telefone Financeiro'													, .F. }, ; //X3_DESCSPA
	{ 'Telefone Financeiro'													, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '1'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ '32'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XCONFIN'														, .F. }, ; //X3_CAMPO   //ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 15																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Cont.Financ.'														, .F. }, ; //X3_TITULO
	{ 'Cont.Financ.'														, .F. }, ; //X3_TITSPA
	{ 'Cont.Financ.'														, .F. }, ; //X3_TITENG
	{ 'Contato Financeiro'													, .F. }, ; //X3_DESCRIC
	{ 'Contato Financeiro'													, .F. }, ; //X3_DESCSPA
	{ 'Contato Financeiro'													, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '1'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ '36'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XPROSPE'														, .F. }, ; //X3_CAMPO   //ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Prospect'															, .F. }, ; //X3_TITULO
	{ 'Prospect'															, .F. }, ; //X3_TITSPA
	{ 'Prospect'															, .F. }, ; //X3_TITENG
	{ 'Prospect'															, .F. }, ; //X3_DESCRIC
	{ 'Prospect'															, .F. }, ; //X3_DESCSPA
	{ 'Prospect'															, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ '"N"'																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ '€'																	, .F. }, ; //X3_OBRIGAT
	{ 'Pertence("SN ")'														, .F. }, ; //X3_VLDUSER
	{ 'S=Sim;N=Nao'															, .F. }, ; //X3_CBOX
	{ 'S=Si;N=No'															, .F. }, ; //X3_CBOXSPA
	{ 'S=Yes;N=No'															, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '1'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ '39'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XDVAG'															, .F. }, ; //X3_CAMPO   //ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Dv. Agencia'															, .F. }, ; //X3_TITULO
	{ 'Dv. Agencia'															, .F. }, ; //X3_TITSPA
	{ 'Dv. Agencia'															, .F. }, ; //X3_TITENG
	{ 'Digito Verificador'													, .F. }, ; //X3_DESCRIC
	{ 'Digito Verificador'													, .F. }, ; //X3_DESCSPA
	{ 'Digito Verificador'													, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '2'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ '42'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XCCPOUP'														, .F. }, ; //X3_CAMPO  // ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Conta Tipo'															, .F. }, ; //X3_TITULO
	{ 'Conta Tipo'															, .F. }, ; //X3_TITSPA
	{ 'Conta Tipo'															, .F. }, ; //X3_TITENG
	{ 'Conta Tipo'															, .F. }, ; //X3_DESCRIC
	{ 'Conta Tipo'															, .F. }, ; //X3_DESCSPA
	{ 'Conta Tipo'															, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ '" "'																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ '1=C.C.;2=Poupanca'													, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '2'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

/*aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ '49'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XFORPGT'														, .F. }, ; //X3_CAMPO  //JA EXISTE
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 30																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Forma Pagto.'														, .F. }, ; //X3_TITULO
	{ 'Forma Pagto.'														, .F. }, ; //X3_TITSPA
	{ 'Forma Pagto.'														, .F. }, ; //X3_TITENG
	{ 'Forma de Pagamento'													, .F. }, ; //X3_DESCRIC
	{ 'Forma de Pagamento'													, .F. }, ; //X3_DESCSPA
	{ 'Forma de Pagamento'													, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '1'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME
*/
aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ '50'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XCONDDE'														, .F. }, ; //X3_CAMPO  //ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 20																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Descricao'															, .F. }, ; //X3_TITULO
	{ 'Descricao'															, .F. }, ; //X3_TITSPA
	{ 'Descricao'															, .F. }, ; //X3_TITENG
	{ 'Descricao'															, .F. }, ; //X3_DESCRIC
	{ 'Descricao'															, .F. }, ; //X3_DESCSPA
	{ 'Descricao'															, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '1'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ '91'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XREDUZ'															, .F. }, ; //X3_CAMPO  //ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 20																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Cta Reduzida'														, .F. }, ; //X3_TITULO
	{ 'Cta Reduzida'														, .F. }, ; //X3_TITSPA
	{ 'Cta Reduzida'														, .F. }, ; //X3_TITENG
	{ 'Conta Reduzida'														, .F. }, ; //X3_DESCRIC
	{ 'Conta Reduzida'														, .F. }, ; //X3_DESCSPA
	{ 'Conta Reduzida'														, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ '"2110111"'															, .F. }, ; //X3_RELACAO
	{ 'CTD'																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ 'S'																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ '€'																	, .F. }, ; //X3_OBRIGAT
	{ 'Vazio() .or. ExistCPO("CTD",M->A2_REDUZ)'							, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '1'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ 'C0'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XNUMPED'														, .F. }, ; //X3_CAMPO  //ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 5																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Num.Pedidos'															, .F. }, ; //X3_TITULO
	{ 'Num.Pedidos'															, .F. }, ; //X3_TITSPA
	{ 'Num.Pedidos'															, .F. }, ; //X3_TITENG
	{ 'Num. de Pedidos Atentidos'											, .F. }, ; //X3_DESCRIC
	{ 'Num. de Pedidos Atentidos'											, .F. }, ; //X3_DESCSPA
	{ 'Num. de Pedidos Atentidos'											, .F. }, ; //X3_DESCENG
	{ '@E 99999'															, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '6'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ 'C1'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XOBSERV'														, .F. }, ; //X3_CAMPO  //ALTERADO
	{ 'M'																	, .F. }, ; //X3_TIPO
	{ 10																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Observacoes'															, .F. }, ; //X3_TITULO
	{ 'Observacoes'															, .F. }, ; //X3_TITSPA
	{ 'Observacoes'															, .F. }, ; //X3_TITENG
	{ 'Observacoes'															, .F. }, ; //X3_DESCRIC
	{ 'Observacoes'															, .F. }, ; //X3_DESCSPA
	{ 'Observacoes'															, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ 'C2'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XVRACMR'														, .F. }, ; //X3_CAMPO  //ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 18																	, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'Vlr.Acum. R$'														, .F. }, ; //X3_TITULO
	{ 'Vlr.Acum. R$'														, .F. }, ; //X3_TITSPA
	{ 'Vlr.Acum. R$'														, .F. }, ; //X3_TITENG
	{ 'Vr.Acum.em Reais'													, .F. }, ; //X3_DESCRIC
	{ 'Vr.Acum.em Reais'													, .F. }, ; //X3_DESCSPA
	{ 'Vr.Acum.em Reais'													, .F. }, ; //X3_DESCENG
	{ '@E 999,999,999,999,999.99'											, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '6'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ 'C3'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XMATRAS'														, .F. }, ; //X3_CAMPO  //ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 21																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Maior Atraso'														, .F. }, ; //X3_TITULO
	{ 'Maior Atraso'														, .F. }, ; //X3_TITSPA
	{ 'Maior Atraso'														, .F. }, ; //X3_TITENG
	{ 'Maior Atraso'														, .F. }, ; //X3_DESCRIC
	{ 'Maior Atraso'														, .F. }, ; //X3_DESCSPA
	{ 'Maior Atraso'														, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '6'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ 'C4'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XDATREF'														, .F. }, ; //X3_CAMPO  //ALTERADO
	{ 'D'																	, .F. }, ; //X3_TIPO
	{ 8																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Dt. cadast.'															, .F. }, ; //X3_TITULO
	{ 'Dt. cadast.'															, .F. }, ; //X3_TITSPA
	{ 'Dt. cadast.'															, .F. }, ; //X3_TITENG
	{ 'Data de cadastro'													, .F. }, ; //X3_DESCRIC
	{ 'Data de cadastro'													, .F. }, ; //X3_DESCSPA
	{ 'Data de cadastro'													, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ 'DDATABASE'															, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '1'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ 'C5'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XMEDATR'   														, .F. }, ; //X3_CAMPO  //ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 4																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Med. Atraso'															, .F. }, ; //X3_TITULO
	{ 'Med. Atraso'															, .F. }, ; //X3_TITSPA
	{ 'Med. Atraso'															, .F. }, ; //X3_TITENG
	{ 'Media Atraso por Pedido'												, .F. }, ; //X3_DESCRIC
	{ 'Media Atraso por Pedido'												, .F. }, ; //X3_DESCSPA
	{ 'Media Atraso por Pedido'												, .F. }, ; //X3_DESCENG
	{ '@E 999.9'															, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '4'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ 'C6'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XVRACMD'														, .F. }, ; //X3_CAMPO  //ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 18																	, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'Vlr.Acum.US$'														, .F. }, ; //X3_TITULO
	{ 'Vlr.Acum.US$'														, .F. }, ; //X3_TITSPA
	{ 'Vlr.Acum.US$'														, .F. }, ; //X3_TITENG
	{ 'Vlr.Acum.em Dolar'													, .F. }, ; //X3_DESCRIC
	{ 'Vlr.Acum.em Dolar'													, .F. }, ; //X3_DESCSPA
	{ 'Vlr.Acum.em Dolar'													, .F. }, ; //X3_DESCENG
	{ '@E 999,999,999,999,999.99'											, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '6'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ 'C7'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XATRDIA'														, .F. }, ; //X3_CAMPO  //ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 4																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Atr.em Dias'															, .F. }, ; //X3_TITULO
	{ 'Atr.em Dias'															, .F. }, ; //X3_TITSPA
	{ 'Atr.em Dias'															, .F. }, ; //X3_TITENG
	{ 'Maior atraso em Dias'												, .F. }, ; //X3_DESCRIC
	{ 'Maior atraso em Dias'												, .F. }, ; //X3_DESCSPA
	{ 'Maior atraso em Dias'												, .F. }, ; //X3_DESCENG
	{ '@E 9999'																, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '4'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ 'C8'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XPERCDE'														, .F. }, ; //X3_CAMPO  //ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 6																		, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'Perc.Descont'														, .F. }, ; //X3_TITULO
	{ 'Perc.Descont'														, .F. }, ; //X3_TITSPA
	{ 'Perc.Descont'														, .F. }, ; //X3_TITENG
	{ 'Media Perc.Desconto'													, .F. }, ; //X3_DESCRIC
	{ 'Media Perc.Desconto'													, .F. }, ; //X3_DESCSPA
	{ 'Media Perc.Desconto'													, .F. }, ; //X3_DESCENG
	{ '@E 999.99%'															, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '4'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ 'C9'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XVLRDES'														, .F. }, ; //X3_CAMPO  //ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 18																	, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'Vr.Med.Desc'															, .F. }, ; //X3_TITULO
	{ 'Vr.Med.Desc'															, .F. }, ; //X3_TITSPA
	{ 'Vr.Med.Desc'															, .F. }, ; //X3_TITENG
	{ 'Valor Medio de Desconto'												, .F. }, ; //X3_DESCRIC
	{ 'Valor Medio de Desconto'												, .F. }, ; //X3_DESCSPA
	{ 'Valor Medio de Desconto'												, .F. }, ; //X3_DESCENG
	{ '@E 999,999,999,999,999.99'											, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '4'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ 'D0'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XPERCON'														, .F. }, ; //X3_CAMPO  //ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 6																		, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'Perc.Concorr'														, .F. }, ; //X3_TITULO
	{ 'Perc.Concorr'														, .F. }, ; //X3_TITSPA
	{ 'Perc.Concorr'														, .F. }, ; //X3_TITENG
	{ 'Perc.de Concor. Atendidas'											, .F. }, ; //X3_DESCRIC
	{ 'Perc.de Concor. Atendidas'											, .F. }, ; //X3_DESCSPA
	{ 'Perc.de Concor. Atendidas'											, .F. }, ; //X3_DESCENG
	{ '@E 999.99%'															, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '4'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

/*aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ 'D1'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XGRPO1'															, .F. }, ; //X3_CAMPO  //JÁ EXISTE 
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 4																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Grupo 1'																, .F. }, ; //X3_TITULO
	{ 'Grupo 1'																, .F. }, ; //X3_TITSPA
	{ 'Grupo 1'																, .F. }, ; //X3_TITENG
	{ 'Grupo de produtos 1'													, .F. }, ; //X3_DESCRIC
	{ 'Grupo de produtos 1'													, .F. }, ; //X3_DESCSPA
	{ 'Grupo de produtos 1'													, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ 'SBM'																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ '€'																	, .F. }, ; //X3_OBRIGAT
	{ 'AllTrim(M->A2_GRUPO1) == "00".or. ExistCPO("SBM")'					, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '1'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ 'D2'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XGRPO2'															, .F. }, ; //X3_CAMPO  // JA EXISTE
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 4																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Grupo 2'																, .F. }, ; //X3_TITULO
	{ 'Grupo 2'																, .F. }, ; //X3_TITSPA
	{ 'Grupo 2'																, .F. }, ; //X3_TITENG
	{ 'Grupo de produtos 2'													, .F. }, ; //X3_DESCRIC
	{ 'Grupo de produtos 2'													, .F. }, ; //X3_DESCSPA
	{ 'Grupo de produtos 2'													, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ 'SBM'																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ 'Vazio() .or. ExistCPO("SBM")'										, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '1'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ 'D3'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XGRPO3'															, .F. }, ; //X3_CAMPO  // JA EXISTE
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 4																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Grupo 3'																, .F. }, ; //X3_TITULO
	{ 'Grupo 3'																, .F. }, ; //X3_TITSPA
	{ 'Grupo 3'																, .F. }, ; //X3_TITENG
	{ 'Grupo de produtos 3'													, .F. }, ; //X3_DESCRIC
	{ 'Grupo de produtos 3'													, .F. }, ; //X3_DESCSPA
	{ 'Grupo de produtos 3'													, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ 'SBM'																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ 'Vazio() .or. ExistCPO("SBM")'										, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '1'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME
*/
aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ 'D4'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XPRODUT'														, .F. }, ; //X3_CAMPO  //ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 30																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Prod vendido'														, .F. }, ; //X3_TITULO
	{ 'Prod vendido'														, .F. }, ; //X3_TITSPA
	{ 'Prod vendido'														, .F. }, ; //X3_TITENG
	{ 'Produto vendido pelo forn'											, .F. }, ; //X3_DESCRIC
	{ 'Produto vendido pelo forn'											, .F. }, ; //X3_DESCSPA
	{ 'Produto vendido pelo forn'											, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '1'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ 'D5'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XQTDCOT'														, .F. }, ; //X3_CAMPO //ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 5																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Qtd.Cotacoes'														, .F. }, ; //X3_TITULO
	{ 'Qtd.Cotacoes'														, .F. }, ; //X3_TITSPA
	{ 'Qtd.Cotacoes'														, .F. }, ; //X3_TITENG
	{ 'Quantidade de Cotacoes'												, .F. }, ; //X3_DESCRIC
	{ 'Quantidade de Cotacoes'												, .F. }, ; //X3_DESCSPA
	{ 'Quantidade de Cotacoes'												, .F. }, ; //X3_DESCENG
	{ '@E 99999'															, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '4'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ 'D6'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XCONV'															, .F. }, ; //X3_CAMPO  //ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Convenente'															, .F. }, ; //X3_TITULO
	{ 'Convenente'															, .F. }, ; //X3_TITSPA
	{ 'Convenente'															, .F. }, ; //X3_TITENG
	{ 'Convenente'															, .F. }, ; //X3_DESCRIC
	{ 'Convenente'															, .F. }, ; //X3_DESCSPA
	{ 'Convenente'															, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ '"N"'																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ 'S'																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ 'Pertence("SN ")'														, .F. }, ; //X3_VLDUSER
	{ 'S=Sim;N=Nao;I=Irregular'												, .F. }, ; //X3_CBOX
	{ 'S=Si;N=No;I=Irregular'												, .F. }, ; //X3_CBOXSPA
	{ 'S=Yes;N=No;I=Irregular'												, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ 'D7'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XQTCOTV'														, .F. }, ; //X3_CAMPO  //ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 5																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Cots. Ganhas'														, .F. }, ; //X3_TITULO
	{ 'Cots. Ganhas'														, .F. }, ; //X3_TITSPA
	{ 'Cots. Ganhas'														, .F. }, ; //X3_TITENG
	{ 'Cotacoes Ganhas'														, .F. }, ; //X3_DESCRIC
	{ 'Cotacoes Ganhas'														, .F. }, ; //X3_DESCSPA
	{ 'Cotacoes Ganhas'														, .F. }, ; //X3_DESCENG
	{ '@E 99999'															, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '4'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ 'D8'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XESTNUM'														, .F. }, ; //X3_CAMPO  //ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 4																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Estagiarios'															, .F. }, ; //X3_TITULO
	{ 'Estagiarios'															, .F. }, ; //X3_TITSPA
	{ 'Estagiarios'															, .F. }, ; //X3_TITENG
	{ 'Estagiarios'															, .F. }, ; //X3_DESCRIC
	{ 'Estagiarios'															, .F. }, ; //X3_DESCSPA
	{ 'Estagiarios'															, .F. }, ; //X3_DESCENG
	{ '@E 9999'																, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ 'S'																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ 'D9'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XDATAUC'														, .F. }, ; //X3_CAMPO  //ALTERADO
	{ 'D'																	, .F. }, ; //X3_TIPO
	{ 8																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Data Ult.Com'														, .F. }, ; //X3_TITULO
	{ 'Data Ult.Com'														, .F. }, ; //X3_TITSPA
	{ 'Data Ult.Com'														, .F. }, ; //X3_TITENG
	{ 'Data da Ultima Compra'												, .F. }, ; //X3_DESCRIC
	{ 'Data da Ultima Compra'												, .F. }, ; //X3_DESCSPA
	{ 'Data da Ultima Compra'												, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '8'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ 'E0'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XVALRUC'														, .F. }, ; //X3_CAMPO  //ALTERADO 
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 14																	, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'Vlr Ult.Com.'														, .F. }, ; //X3_TITULO
	{ 'Vlr Ult.Com.'														, .F. }, ; //X3_TITSPA
	{ 'Vlr Ult.Com.'														, .F. }, ; //X3_TITENG
	{ 'Valor da Ultima Compra'												, .F. }, ; //X3_DESCRIC
	{ 'Valor da Ultima Compra'												, .F. }, ; //X3_DESCSPA
	{ 'Valor da Ultima Compra'												, .F. }, ; //X3_DESCENG
	{ '@E 999,999,999.99'													, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '8'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ 'E1'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XMCOMP'															, .F. }, ; //X3_CAMPO  //ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 28																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Maior Compra'														, .F. }, ; //X3_TITULO
	{ 'Maior Compra'														, .F. }, ; //X3_TITSPA
	{ 'Maior Compra'														, .F. }, ; //X3_TITENG
	{ 'Maior Compra c/ esse forn'											, .F. }, ; //X3_DESCRIC
	{ 'Maior Compra c/ esse forn'											, .F. }, ; //X3_DESCSPA
	{ 'Maior Compra c/ esse forn'											, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '6'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME
/*
aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ 'E2'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XCOTVE1'														, .F. }, ; //X3_CAMPO  //JA EXISTE
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 7																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Cots. Vencid'														, .F. }, ; //X3_TITULO
	{ 'Cots. Vencid'														, .F. }, ; //X3_TITSPA
	{ 'Cots. Vencid'														, .F. }, ; //X3_TITENG
	{ 'Cotacoes vencidas'													, .F. }, ; //X3_DESCRIC
	{ 'Cotacoes vencidas'													, .F. }, ; //X3_DESCSPA
	{ 'Cotacoes vencidas'													, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '6'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME
*/
aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ 'E3'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XCOTVE2'														, .F. }, ; //X3_CAMPO  //ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 6																		, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'Vencedor'															, .F. }, ; //X3_TITULO
	{ 'Vencedor'															, .F. }, ; //X3_TITSPA
	{ 'Vencedor'															, .F. }, ; //X3_TITENG
	{ 'Vencedor'															, .F. }, ; //X3_DESCRIC
	{ 'Vencedor'															, .F. }, ; //X3_DESCSPA
	{ 'Vencedor'															, .F. }, ; //X3_DESCENG
	{ '@E 999.99'															, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'V'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '6'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ 'E4'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XMDESC'															, .F. }, ; //X3_CAMPO  //ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 37																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Maior Descon'														, .F. }, ; //X3_TITULO
	{ 'Maior Descon'														, .F. }, ; //X3_TITSPA
	{ 'Maior Descon'														, .F. }, ; //X3_TITENG
	{ 'Maior Desconto'														, .F. }, ; //X3_DESCRIC
	{ 'Maior Desconto'														, .F. }, ; //X3_DESCSPA
	{ 'Maior Desconto'														, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '6'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ 'E5'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XDESCUC'														, .F. }, ; //X3_CAMPO  //ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 24																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Desc.Ult.Com'														, .F. }, ; //X3_TITULO
	{ 'Desc.Ult.Com'														, .F. }, ; //X3_TITSPA
	{ 'Desc.Ult.Com'														, .F. }, ; //X3_TITENG
	{ 'Desconto da Ultima Compra'											, .F. }, ; //X3_DESCRIC
	{ 'Desconto da Ultima Compra'											, .F. }, ; //X3_DESCSPA
	{ 'Desconto da Ultima Compra'											, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '8'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ 'E6'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XATRAUC'														, .F. }, ; //X3_CAMPO  //ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 9																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Atraso UC'															, .F. }, ; //X3_TITULO
	{ 'Atraso UC'															, .F. }, ; //X3_TITSPA
	{ 'Atraso UC'															, .F. }, ; //X3_TITENG
	{ 'Atraso da ultima compra'												, .F. }, ; //X3_DESCRIC
	{ 'Atraso da ultima compra'												, .F. }, ; //X3_DESCSPA
	{ 'Atraso da ultima compra'												, .F. }, ; //X3_DESCENG
	{ '@E 999999999'														, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '8'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ 'G8'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XUNIFAT'														, .F. }, ; //X3_CAMPO  //ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 9																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Unid Faturam'														, .F. }, ; //X3_TITULO
	{ 'Unid Faturam'														, .F. }, ; //X3_TITSPA
	{ 'Unid Faturam'														, .F. }, ; //X3_TITENG
	{ 'Unidade de Faturamento'												, .F. }, ; //X3_DESCRIC
	{ 'Unidade de Faturamento'												, .F. }, ; //X3_DESCSPA
	{ 'Unidade de Faturamento'												, .F. }, ; //X3_DESCENG
	{ '@E 999999999'														, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '2'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA2'																	, .F. }, ; //X3_ARQUIVO
	{ 'H0'																	, .F. }, ; //X3_ORDEM
	{ 'A2_XMATRIC'														, .F. }, ; //X3_CAMPO   //NAO ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 7																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Matricula'															, .F. }, ; //X3_TITULO
	{ 'Matricula'															, .F. }, ; //X3_TITSPA
	{ 'Matricula'															, .F. }, ; //X3_TITENG
	{ 'Matricula'															, .F. }, ; //X3_DESCRIC
	{ 'Matricula'															, .F. }, ; //X3_DESCSPA
	{ 'Matricula'															, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SA3
//
aAdd( aSX3, { ;
	{ 'SA3'																	, .F. }, ; //X3_ARQUIVO
	{ '39'																	, .F. }, ; //X3_ORDEM
	{ 'A3_XLOCARQ'														, .F. }, ; //X3_CAMPO  //ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 50																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Loc.Arq.'															, .F. }, ; //X3_TITULO
	{ 'Local.Arch.'															, .F. }, ; //X3_TITSPA
	{ 'File Local.'															, .F. }, ; //X3_TITENG
	{ 'Localizacao Arquivo'													, .F. }, ; //X3_DESCRIC
	{ 'Localizacion del Archivo'											, .F. }, ; //X3_DESCSPA
	{ 'File Localization'													, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(136) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(130) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ ''																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ ''																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '1'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA3'																	, .F. }, ; //X3_ARQUIVO
	{ '41'																	, .F. }, ; //X3_ORDEM
	{ 'A3_XMENS1'															, .F. }, ; //X3_CAMPO  //ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 60																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Mensagem 1'															, .F. }, ; //X3_TITULO
	{ 'Mensaje 1'															, .F. }, ; //X3_TITSPA
	{ 'Message 1'															, .F. }, ; //X3_TITENG
	{ 'Mens. Empresa -> Vendedor'											, .F. }, ; //X3_DESCRIC
	{ 'Mens. Empresa -> Vendedor'											, .F. }, ; //X3_DESCSPA
	{ 'Company Message to Seller'											, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(186) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ ''																	, .F. }, ; //X3_VISUAL
	{ ''																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '2'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA3'																	, .F. }, ; //X3_ARQUIVO
	{ '42'																	, .F. }, ; //X3_ORDEM
	{ 'A3_XMENS2'															, .F. }, ; //X3_CAMPO  //ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 60																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Mensagem 2'															, .F. }, ; //X3_TITULO
	{ 'Mensaje 2'															, .F. }, ; //X3_TITSPA
	{ 'Message 2'															, .F. }, ; //X3_TITENG
	{ 'Mens. Vendedor -> Empresa'											, .F. }, ; //X3_DESCRIC
	{ 'Mens. Vendedor -> Empresa'											, .F. }, ; //X3_DESCSPA
	{ 'Seller Message to Company'											, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(186) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ ''																	, .F. }, ; //X3_VISUAL
	{ ''																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '2'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA3'																	, .F. }, ; //X3_ARQUIVO
	{ '51'																	, .F. }, ; //X3_ORDEM
	{ 'A3_XGRPCOM'														, .F. }, ; //X3_CAMPO  //ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 6																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Grp.Comissao'														, .F. }, ; //X3_TITULO
	{ 'Grp.Comision'														, .F. }, ; //X3_TITSPA
	{ 'Com. group'															, .F. }, ; //X3_TITENG
	{ 'Grupo de comissao'													, .F. }, ; //X3_DESCRIC
	{ 'Grupo de comision'													, .F. }, ; //X3_DESCSPA
	{ 'Commission group'													, .F. }, ; //X3_DESCENG
	{ '!'																	, .F. }, ; //X3_PICTURE
	{ 'Vazio() .Or. ExistCpo("AI1")'										, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ 'AI1'																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(130) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ ''																	, .F. }, ; //X3_VISUAL
	{ ''																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '1'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

//
// Campos Tabela SA6
//
aAdd( aSX3, { ;
	{ 'SA6'																	, .F. }, ; //X3_ARQUIVO
	{ '06'																	, .F. }, ; //X3_ORDEM
	{ 'A6_XCONV'															, .F. }, ; //X3_CAMPO  //ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 25																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Convenio'															, .F. }, ; //X3_TITULO
	{ 'Convenio'															, .F. }, ; //X3_TITSPA
	{ 'Convenio'															, .F. }, ; //X3_TITENG
	{ 'Nome Convenio'														, .F. }, ; //X3_DESCRIC
	{ 'Nome Convenio'														, .F. }, ; //X3_DESCSPA
	{ 'Nome Convenio'														, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SA6'																	, .F. }, ; //X3_ARQUIVO
	{ '11'																	, .F. }, ; //X3_ORDEM
	{ 'A6_XCIDADE'														, .F. }, ; //X3_CAMPO  //ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 15																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Municipio'															, .F. }, ; //X3_TITULO
	{ 'Municipio'															, .F. }, ; //X3_TITSPA
	{ 'District'															, .F. }, ; //X3_TITENG
	{ 'Municipio do banco'													, .F. }, ; //X3_DESCRIC
	{ 'Municipio del Banco'													, .F. }, ; //X3_DESCSPA
	{ 'Bank District'														, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(146) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ ''																	, .F. }, ; //X3_VISUAL
	{ ''																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ 'texto()'																, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

//
// Campos Tabela SAK
//
aAdd( aSX3, { ;
	{ 'SAK'																	, .F. }, ; //X3_ARQUIVO
	{ '11'																	, .F. }, ; //X3_ORDEM
	{ 'AK_XNIVEL'															, .F. }, ; //X3_CAMPO  //ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Nivel'																, .F. }, ; //X3_TITULO
	{ 'Nivel'																, .F. }, ; //X3_TITSPA
	{ 'Nivel'																, .F. }, ; //X3_TITENG
	{ 'Nivel'																, .F. }, ; //X3_DESCRIC
	{ 'Nivel'																, .F. }, ; //X3_DESCSPA
	{ 'Nivel'																, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ '€'																	, .F. }, ; //X3_OBRIGAT
	{ 'Pertence("AB ")'														, .F. }, ; //X3_VLDUSER
	{ 'A=Nivel A;B=Nivel B'													, .F. }, ; //X3_CBOX
	{ 'A=Nivel A;B=Nivel B'													, .F. }, ; //X3_CBOXSPA
	{ 'A=Nivel A;B=Nivel B'													, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SB1
//
/*
aAdd( aSX3, { ;
	{ 'SB1'																	, .F. }, ; //X3_ARQUIVO
	{ '06'																	, .F. }, ; //X3_ORDEM
	{ 'B1_XESPEC'															, .F. }, ; //X3_CAMPO  // JA ALTERADO
	{ 'M'																	, .F. }, ; //X3_TIPO
	{ 10																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Especific.'															, .F. }, ; //X3_TITULO
	{ 'Especific.'															, .F. }, ; //X3_TITSPA
	{ 'Especific.'															, .F. }, ; //X3_TITENG
	{ 'Especificacao'														, .F. }, ; //X3_DESCRIC
	{ 'Especificacao'														, .F. }, ; //X3_DESCSPA
	{ 'Especificacao'														, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '1'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SB1'																	, .F. }, ; //X3_ARQUIVO
	{ '34'																	, .F. }, ; //X3_ORDEM
	{ 'B1_XCONMED'												  		, .F. }, ; //X3_CAMPO  //JA ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 11																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Med. Consumo'														, .F. }, ; //X3_TITULO
	{ 'Med. Consumo'														, .F. }, ; //X3_TITSPA
	{ 'Med. Consumo'														, .F. }, ; //X3_TITENG
	{ 'Media de Consumo Mensal'												, .F. }, ; //X3_DESCRIC
	{ 'Media de Consumo Mensal'												, .F. }, ; //X3_DESCSPA
	{ 'Media de Consumo Mensal'												, .F. }, ; //X3_DESCENG
	{ '@E 999,999,999'														, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ 'U_GETCONSMED(M->B1_COD)'												, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '3'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SB1'																	, .F. }, ; //X3_ARQUIVO
	{ '36'																	, .F. }, ; //X3_ORDEM
	{ 'B1_XEMIND'															, .F. }, ; //X3_CAMPO  //JA ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 5																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'PP em Dias'															, .F. }, ; //X3_TITULO
	{ 'PP em Dias'															, .F. }, ; //X3_TITSPA
	{ 'PP em Dias'															, .F. }, ; //X3_TITENG
	{ 'Ponto de Pedido em Dias'												, .F. }, ; //X3_DESCRIC
	{ 'Ponto de Pedido em Dias'												, .F. }, ; //X3_DESCSPA
	{ 'Ponto de Pedido em Dias'												, .F. }, ; //X3_DESCENG
	{ '@E 99999'															, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ 'U_cesta03("B1_EMIND")'												, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '3'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SB1'																	, .F. }, ; //X3_ARQUIVO
	{ '39'																	, .F. }, ; //X3_ORDEM
	{ 'B1_XPEQ'															, .F. }, ; //X3_CAMPO  //JA ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 12																	, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'TC Quant.'															, .F. }, ; //X3_TITULO
	{ 'TC Quant.'															, .F. }, ; //X3_TITSPA
	{ 'TC Quant.'															, .F. }, ; //X3_TITENG
	{ 'Cons. no Tempo Compra'												, .F. }, ; //X3_DESCRIC
	{ 'Cons. no Tempo Compra'												, .F. }, ; //X3_DESCSPA
	{ 'Cons. no Tempo Comprarega'											, .F. }, ; //X3_DESCENG
	{ '@E 999,999,999.99'													, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ 'U_cesta03("B1_XPEQ")'													, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '3'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME
*/
aAdd( aSX3, { ;
	{ 'SB1'																	, .F. }, ; //X3_ARQUIVO
	{ '40'																	, .F. }, ; //X3_ORDEM
	{ 'B1_XESTSED'														, .F. }, ; //X3_CAMPO  //ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 5																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Seg. Dias'															, .F. }, ; //X3_TITULO
	{ 'Seg. Dias'															, .F. }, ; //X3_TITSPA
	{ 'Seg. Dias'															, .F. }, ; //X3_TITENG
	{ 'Est. de Seguranca em Dias'											, .F. }, ; //X3_DESCRIC
	{ 'Est. de Seguranca em Dias'											, .F. }, ; //X3_DESCSPA
	{ 'Est. de Seguranca em Dias'											, .F. }, ; //X3_DESCENG
	{ '@E 99999'															, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ 'U_cesta03("B1_ESTSEGD")'												, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '3'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME
/*
aAdd( aSX3, { ;
	{ 'SB1'																	, .F. }, ; //X3_ARQUIVO
	{ '42'																	, .F. }, ; //X3_ORDEM
	{ 'B1_XLED'															, .F. }, ; //X3_CAMPO  // JA ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 5																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'LE Dias'																, .F. }, ; //X3_TITULO
	{ 'LE Dias'																, .F. }, ; //X3_TITSPA
	{ 'LE Dias'																, .F. }, ; //X3_TITENG
	{ 'Lote Economico em Dias'												, .F. }, ; //X3_DESCRIC
	{ 'Lote Economico em Dias'												, .F. }, ; //X3_DESCSPA
	{ 'Lote Economico em Dias'												, .F. }, ; //X3_DESCENG
	{ '@E 99999'															, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ 'U_cesta03("B1_LED")'													, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '3'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME
*/
aAdd( aSX3, { ;
	{ 'SB1'																	, .F. }, ; //X3_ARQUIVO
	{ '69'																	, .F. }, ; //X3_ORDEM
	{ 'B1_XINTRAN'														, .F. }, ; //X3_CAMPO  // ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Intranet'															, .F. }, ; //X3_TITULO
	{ 'Intranet'															, .F. }, ; //X3_TITSPA
	{ 'Intranet'															, .F. }, ; //X3_TITENG
	{ 'Intranet'															, .F. }, ; //X3_DESCRIC
	{ 'Intranet'															, .F. }, ; //X3_DESCSPA
	{ 'Intranet'															, .F. }, ; //X3_DESCENG
	{ '!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ 'pertence("SN")'														, .F. }, ; //X3_VLDUSER
	{ 'S=Sim;N=Nao'															, .F. }, ; //X3_CBOX
	{ 'S=Si;N=No'															, .F. }, ; //X3_CBOXSPA
	{ 'S=Yes;N=No'															, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '1'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SB1'																	, .F. }, ; //X3_ARQUIVO
	{ '70'																	, .F. }, ; //X3_ORDEM
	{ 'B1_XCLIENT'														, .F. }, ; //X3_CAMPO  // ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Clientes'															, .F. }, ; //X3_TITULO
	{ 'Clientes'															, .F. }, ; //X3_TITSPA
	{ 'Clientes'															, .F. }, ; //X3_TITENG
	{ 'Clientes'															, .F. }, ; //X3_DESCRIC
	{ 'Clientes'															, .F. }, ; //X3_DESCSPA
	{ 'Clientes'															, .F. }, ; //X3_DESCENG
	{ '!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ 'pertence("ST")'														, .F. }, ; //X3_VLDUSER
	{ 'S=Sede;T=Todos'														, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '1'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME
/*
aAdd( aSX3, { ;
	{ 'SB1'																	, .F. }, ; //X3_ARQUIVO
	{ 'F4'																	, .F. }, ; //X3_ORDEM
	{ 'B1_XBLQSAI'														, .F. }, ; //X3_CAMPO  // JA ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Bloq.Saida'															, .F. }, ; //X3_TITULO
	{ 'Bloq.Saida'															, .F. }, ; //X3_TITSPA
	{ 'Bloq.Saida'															, .F. }, ; //X3_TITENG
	{ 'Bloqueio de Saida'													, .F. }, ; //X3_DESCRIC
	{ 'Bloqueio de Saida'													, .F. }, ; //X3_DESCSPA
	{ 'Bloqueio de Saida'													, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ '"L"'																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ 'pertence("LN")'														, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '1'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SB1'																	, .F. }, ; //X3_ARQUIVO
	{ 'F5'																	, .F. }, ; //X3_ORDEM
	{ 'B1_XBLOENT'														, .F. }, ; //X3_CAMPO  // JA ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Bloq.Entrada'														, .F. }, ; //X3_TITULO
	{ 'Bloq.Entrada'														, .F. }, ; //X3_TITSPA
	{ 'Bloq.Entrada'														, .F. }, ; //X3_TITENG
	{ 'Bloqueia Entrada'													, .F. }, ; //X3_DESCRIC
	{ 'Bloqueia Entrada'													, .F. }, ; //X3_DESCSPA
	{ 'Bloqueia Entrada'													, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ '"L"'																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ 'pertence("LN")'														, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '1'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SB1'																	, .F. }, ; //X3_ARQUIVO
	{ 'F6'																	, .F. }, ; //X3_ORDEM
	{ 'B1_XOBSER'															, .F. }, ; //X3_CAMPO  // JA ALTERADO
	{ 'M'																	, .F. }, ; //X3_TIPO
	{ 10																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Observacoes'															, .F. }, ; //X3_TITULO
	{ 'Observacoes'															, .F. }, ; //X3_TITSPA
	{ 'Observacoes'															, .F. }, ; //X3_TITENG
	{ 'Campo para Observacoes'												, .F. }, ; //X3_DESCRIC
	{ 'Campo para Observacoes'												, .F. }, ; //X3_DESCSPA
	{ 'Campo para Observacoes'												, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '1'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SB1'																	, .F. }, ; //X3_ARQUIVO
	{ 'F7'																	, .F. }, ; //X3_ORDEM
	{ 'B1_USERLGI'														, .F. }, ; //X3_CAMPO  /JA ALTERADO - PADRAO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 17																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Log de Inclu'														, .F. }, ; //X3_TITULO
	{ ''																	, .F. }, ; //X3_TITSPA
	{ ''																	, .F. }, ; //X3_TITENG
	{ 'Log de Inclusao'														, .F. }, ; //X3_DESCRIC
	{ ''																	, .F. }, ; //X3_DESCSPA
	{ ''																	, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 9																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'L'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SB1'																	, .F. }, ; //X3_ARQUIVO
	{ 'F8'																	, .F. }, ; //X3_ORDEM
	{ 'B1_USERLGA'														, .F. }, ; //X3_CAMPO  // JA ALTERADO = PADRAO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 17																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Log de Alter'														, .F. }, ; //X3_TITULO
	{ ''																	, .F. }, ; //X3_TITSPA
	{ ''																	, .F. }, ; //X3_TITENG
	{ 'Log de Alteracao'													, .F. }, ; //X3_DESCRIC
	{ ''																	, .F. }, ; //X3_DESCSPA
	{ ''																	, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 9																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'L'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SB1'																	, .F. }, ; //X3_ARQUIVO
	{ 'F9'																	, .F. }, ; //X3_ORDEM
	{ 'B1_XSDATU'								 			 			   , .F. }, ; //X3_CAMPO  // JA ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 14																	, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'Sld. Atual'															, .F. }, ; //X3_TITULO
	{ 'Sld. Atual'															, .F. }, ; //X3_TITSPA
	{ 'Sld. Atual'															, .F. }, ; //X3_TITENG
	{ 'Saldo Atual'															, .F. }, ; //X3_DESCRIC
	{ 'Saldo Atual'															, .F. }, ; //X3_DESCSPA
	{ 'Saldo Atual'															, .F. }, ; //X3_DESCENG
	{ '@E 999,999,999.99'													, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ 'U_GETCPOVAL("B2_QATU", 1, XFILIAL("SB2") + SB1->(B1_COD + B1_LOCPAD), .F.)', .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'V'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ 'U_GETCPOVAL("B2_QATU", 1, XFILIAL("SB2") + SB1->(B1_COD + B1_LOCPAD), .F.)', .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '3'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SB1'																	, .F. }, ; //X3_ARQUIVO
	{ 'G0'																	, .F. }, ; //X3_ORDEM
	{ 'B1_XSDPED'															, .F. }, ; //X3_CAMPO  // JA ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 14																	, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'Sld. em PC'															, .F. }, ; //X3_TITULO
	{ 'Sld. em PC'															, .F. }, ; //X3_TITSPA
	{ 'Sld. em PC'															, .F. }, ; //X3_TITENG
	{ 'Saldo em Pedido de Compra'											, .F. }, ; //X3_DESCRIC
	{ 'Saldo em Pedido de Compra'											, .F. }, ; //X3_DESCSPA
	{ 'Saldo em Pedido de Compra'											, .F. }, ; //X3_DESCENG
	{ '@E 999,999,999.99'													, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ 'U_GETSLD(SB1->B1_COD, .F., .T.)'										, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'V'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ 'U_GETSLD(SB1->B1_COD, .F., .T.)'										, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '3'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SB1'																	, .F. }, ; //X3_ARQUIVO
	{ 'G1'																	, .F. }, ; //X3_ORDEM
	{ 'B1_XSDSOL'															, .F. }, ; //X3_CAMPO  // JA ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 14																	, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'Sld. Solicit'														, .F. }, ; //X3_TITULO
	{ 'Sld. Solicit'														, .F. }, ; //X3_TITSPA
	{ 'Sld. Solicit'														, .F. }, ; //X3_TITENG
	{ 'Saldo em Solicitacoes'												, .F. }, ; //X3_DESCRIC
	{ 'Saldo em Solicitacoes'												, .F. }, ; //X3_DESCSPA
	{ 'Saldo em Solicitacoes'												, .F. }, ; //X3_DESCENG
	{ '@E 999,999,999.99'													, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ 'U_GETSLD(SB1->B1_COD, .T., .F.)'										, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'V'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ 'U_GETSLD(SB1->B1_COD, .T., .F.)'										, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '3'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SB1'																	, .F. }, ; //X3_ARQUIVO
	{ 'G2'																	, .F. }, ; //X3_ORDEM
	{ 'B1_XAUTSC'															, .F. }, ; //X3_CAMPO  // JA EXISTE
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'SC por PP'															, .F. }, ; //X3_TITULO
	{ 'SC por PP'															, .F. }, ; //X3_TITSPA
	{ 'SC por PP'															, .F. }, ; //X3_TITENG
	{ 'Sol. Compras por P.Pedido'											, .F. }, ; //X3_DESCRIC
	{ 'Sol. Compras por P.Pedido'											, .F. }, ; //X3_DESCSPA
	{ 'Sol. Compras por P.Pedido'											, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ '"1"'																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ '1=Sim;2=Näo'															, .F. }, ; //X3_CBOX
	{ '1=Sim;2=Näo'															, .F. }, ; //X3_CBOXSPA
	{ '1=Sim;2=Näo'															, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '3'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SB1'																	, .F. }, ; //X3_ARQUIVO
	{ 'G3'																	, .F. }, ; //X3_ORDEM
	{ 'B1_XARRED'															, .F. }, ; //X3_CAMPO  // JA ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Arredonda SC'														, .F. }, ; //X3_TITULO
	{ 'Arredonda SC'														, .F. }, ; //X3_TITSPA
	{ 'Arredonda SC'														, .F. }, ; //X3_TITENG
	{ 'Arredonda a Sol. Compra'												, .F. }, ; //X3_DESCRIC
	{ 'Arredonda a Sol. Compra'												, .F. }, ; //X3_DESCSPA
	{ 'Arredonda a Sol. Compra'												, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ '"1"'																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ '1=Sim;2=Näo'															, .F. }, ; //X3_CBOX
	{ '1=Sim;2=Näo'															, .F. }, ; //X3_CBOXSPA
	{ '1=Sim;2=Näo'															, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '3'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SB1'																	, .F. }, ; //X3_ARQUIVO
	{ 'G4'																	, .F. }, ; //X3_ORDEM
	{ 'B1_XFATARR'														, .F. }, ; //X3_CAMPO  // JA ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 6																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Fator Arred.'														, .F. }, ; //X3_TITULO
	{ 'Fator Arred.'														, .F. }, ; //X3_TITSPA
	{ 'Fator Arred.'														, .F. }, ; //X3_TITENG
	{ 'Fator de Arredondamento'												, .F. }, ; //X3_DESCRIC
	{ 'Fator de Arredondamento'												, .F. }, ; //X3_DESCSPA
	{ 'Fator de Arredondamento'												, .F. }, ; //X3_DESCENG
	{ '@E 999,999'															, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '3'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SB1'																	, .F. }, ; //X3_ARQUIVO
	{ 'G5'																	, .F. }, ; //X3_ORDEM
	{ 'B1_XJAN'		  													, .F. }, ; //X3_CAMPO  // JA ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 11																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Janeiro'																, .F. }, ; //X3_TITULO
	{ 'Janeiro'																, .F. }, ; //X3_TITSPA
	{ 'Janeiro'																, .F. }, ; //X3_TITENG
	{ 'Janeiro'																, .F. }, ; //X3_DESCRIC
	{ 'Janeiro'																, .F. }, ; //X3_DESCSPA
	{ 'Janeiro'																, .F. }, ; //X3_DESCENG
	{ '@E 999,999,999'														, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ 'U_GETCPOVAL("B3_Q01", 1, XFILIAL("SB3") + SB1->B1_COD, .F.)'			, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'V'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ 'U_GETCPOVAL("B3_Q01", 1, XFILIAL("SB3") + SB1->B1_COD, .F.)'			, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '4'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SB1'																	, .F. }, ; //X3_ARQUIVO
	{ 'G6'																	, .F. }, ; //X3_ORDEM
	{ 'B1_XFEV'															, .F. }, ; //X3_CAMPO  // JA ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 11																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Fevereiro'															, .F. }, ; //X3_TITULO
	{ 'Fevereiro'															, .F. }, ; //X3_TITSPA
	{ 'Fevereiro'															, .F. }, ; //X3_TITENG
	{ 'Fevereiro'															, .F. }, ; //X3_DESCRIC
	{ 'Fevereiro'															, .F. }, ; //X3_DESCSPA
	{ 'Fevereiro'															, .F. }, ; //X3_DESCENG
	{ '@E 999,999,999'														, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ 'U_GETCPOVAL("B3_Q02", 1, XFILIAL("SB3") + SB1->B1_COD, .F.)'			, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'V'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ 'U_GETCPOVAL("B3_Q02", 1, XFILIAL("SB3") + SB1->B1_COD, .F.)'			, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '4'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SB1'																	, .F. }, ; //X3_ARQUIVO
	{ 'G7'																	, .F. }, ; //X3_ORDEM
	{ 'B1_XMAR'															, .F. }, ; //X3_CAMPO  // JA ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 11																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Marco'																, .F. }, ; //X3_TITULO
	{ 'Marco'																, .F. }, ; //X3_TITSPA
	{ 'Marco'																, .F. }, ; //X3_TITENG
	{ 'Marco'																, .F. }, ; //X3_DESCRIC
	{ 'Marco'																, .F. }, ; //X3_DESCSPA
	{ 'Marco'																, .F. }, ; //X3_DESCENG
	{ '@E 999,999,999'														, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ 'U_GETCPOVAL("B3_Q03", 1, XFILIAL("SB3") + SB1->B1_COD, .F.)'			, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'V'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ 'U_GETCPOVAL("B3_Q03", 1, XFILIAL("SB3") + SB1->B1_COD, .F.)'			, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '4'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SB1'																	, .F. }, ; //X3_ARQUIVO
	{ 'G8'																	, .F. }, ; //X3_ORDEM
	{ 'B1_XABR'															, .F. }, ; //X3_CAMPO  // JA ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 11																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Abril'																, .F. }, ; //X3_TITULO
	{ 'Abril'																, .F. }, ; //X3_TITSPA
	{ 'Abril'																, .F. }, ; //X3_TITENG
	{ 'Abril'																, .F. }, ; //X3_DESCRIC
	{ 'Abril'																, .F. }, ; //X3_DESCSPA
	{ 'Abril'																, .F. }, ; //X3_DESCENG
	{ '@E 999,999,999'														, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ 'U_GETCPOVAL("B3_Q04", 1, XFILIAL("SB3") + SB1->B1_COD, .F.)'			, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'V'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ 'U_GETCPOVAL("B3_Q04", 1, XFILIAL("SB3") + SB1->B1_COD, .F.)'			, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '4'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SB1'																	, .F. }, ; //X3_ARQUIVO
	{ 'G9'																	, .F. }, ; //X3_ORDEM
	{ 'B1_XMAI'															, .F. }, ; //X3_CAMPO  // JA ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 11																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Maio'																, .F. }, ; //X3_TITULO
	{ 'Maio'																, .F. }, ; //X3_TITSPA
	{ 'Maio'																, .F. }, ; //X3_TITENG
	{ 'Maio'																, .F. }, ; //X3_DESCRIC
	{ 'Maio'																, .F. }, ; //X3_DESCSPA
	{ 'Maio'																, .F. }, ; //X3_DESCENG
	{ '@E 999,999,999'														, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ 'U_GETCPOVAL("B3_Q05", 1, XFILIAL("SB3") + SB1->B1_COD, .F.)'			, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'V'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ 'U_GETCPOVAL("B3_Q05", 1, XFILIAL("SB3") + SB1->B1_COD, .F.)'			, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '4'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SB1'																	, .F. }, ; //X3_ARQUIVO
	{ 'H0'																	, .F. }, ; //X3_ORDEM
	{ 'B1_XJUN'															, .F. }, ; //X3_CAMPO  // JA ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 11																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Junho'																, .F. }, ; //X3_TITULO
	{ 'Junho'																, .F. }, ; //X3_TITSPA
	{ 'Junho'																, .F. }, ; //X3_TITENG
	{ 'Junho'																, .F. }, ; //X3_DESCRIC
	{ 'Junho'																, .F. }, ; //X3_DESCSPA
	{ 'Junho'																, .F. }, ; //X3_DESCENG
	{ '@E 999,999,999'														, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ 'U_GETCPOVAL("B3_Q06", 1, XFILIAL("SB3") + SB1->B1_COD, .F.)'			, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'V'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ 'U_GETCPOVAL("B3_Q06", 1, XFILIAL("SB3") + SB1->B1_COD, .F.)'			, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '4'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SB1'																	, .F. }, ; //X3_ARQUIVO
	{ 'H1'																	, .F. }, ; //X3_ORDEM
	{ 'B1_XJUL'															, .F. }, ; //X3_CAMPO  // JA ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 11																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Julho'																, .F. }, ; //X3_TITULO
	{ 'Julho'																, .F. }, ; //X3_TITSPA
	{ 'Julho'																, .F. }, ; //X3_TITENG
	{ 'Julho'																, .F. }, ; //X3_DESCRIC
	{ 'Julho'																, .F. }, ; //X3_DESCSPA
	{ 'Julho'																, .F. }, ; //X3_DESCENG
	{ '@E 999,999,999'														, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ 'U_GETCPOVAL("B3_Q07", 1, XFILIAL("SB3") + SB1->B1_COD, .F.)'			, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'V'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ 'U_GETCPOVAL("B3_Q07", 1, XFILIAL("SB3") + SB1->B1_COD, .F.)'			, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '4'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SB1'																	, .F. }, ; //X3_ARQUIVO
	{ 'H2'																	, .F. }, ; //X3_ORDEM
	{ 'B1_XAGO'															, .F. }, ; //X3_CAMPO  // JA ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 11																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Agosto'																, .F. }, ; //X3_TITULO
	{ 'Agosto'																, .F. }, ; //X3_TITSPA
	{ 'Agosto'																, .F. }, ; //X3_TITENG
	{ 'Agosto'																, .F. }, ; //X3_DESCRIC
	{ 'Agosto'																, .F. }, ; //X3_DESCSPA
	{ 'Agosto'																, .F. }, ; //X3_DESCENG
	{ '@E 999,999,999'														, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ 'U_GETCPOVAL("B3_Q08", 1, XFILIAL("SB3") + SB1->B1_COD, .F.)'			, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'V'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ 'U_GETCPOVAL("B3_Q08", 1, XFILIAL("SB3") + SB1->B1_COD, .F.)'			, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '4'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SB1'																	, .F. }, ; //X3_ARQUIVO
	{ 'H3'																	, .F. }, ; //X3_ORDEM
	{ 'B1_XSET'			 												, .F. }, ; //X3_CAMPO  // JA ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 11																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Setembro'															, .F. }, ; //X3_TITULO
	{ 'Setembro'															, .F. }, ; //X3_TITSPA
	{ 'Setembro'															, .F. }, ; //X3_TITENG
	{ 'Setembro'															, .F. }, ; //X3_DESCRIC
	{ 'Setembro'															, .F. }, ; //X3_DESCSPA
	{ 'Setembro'															, .F. }, ; //X3_DESCENG
	{ '@E 999,999,999'														, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ 'U_GETCPOVAL("B3_Q09", 1, XFILIAL("SB3") + SB1->B1_COD, .F.)'			, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'V'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ 'U_GETCPOVAL("B3_Q09", 1, XFILIAL("SB3") + SB1->B1_COD, .F.)'			, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '4'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SB1'																	, .F. }, ; //X3_ARQUIVO
	{ 'H4'																	, .F. }, ; //X3_ORDEM
	{ 'B1_XOUT'															, .F. }, ; //X3_CAMPO  //JA ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 11																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Outubro'																, .F. }, ; //X3_TITULO
	{ 'Outubro'																, .F. }, ; //X3_TITSPA
	{ 'Outubro'																, .F. }, ; //X3_TITENG
	{ 'Outubro'																, .F. }, ; //X3_DESCRIC
	{ 'Outubro'																, .F. }, ; //X3_DESCSPA
	{ 'Outubro'																, .F. }, ; //X3_DESCENG
	{ '@E 999,999,999'														, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ 'U_GETCPOVAL("B3_Q10", 1, XFILIAL("SB3") + SB1->B1_COD, .F.)'			, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'V'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ 'U_GETCPOVAL("B3_Q10", 1, XFILIAL("SB3") + SB1->B1_COD, .F.)'			, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '4'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SB1'																	, .F. }, ; //X3_ARQUIVO
	{ 'H5'																	, .F. }, ; //X3_ORDEM
	{ 'B1_XNOV'															, .F. }, ; //X3_CAMPO  // JA ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 11																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Novembro'															, .F. }, ; //X3_TITULO
	{ 'Novembro'															, .F. }, ; //X3_TITSPA
	{ 'Novembro'															, .F. }, ; //X3_TITENG
	{ 'Novembro'															, .F. }, ; //X3_DESCRIC
	{ 'Novembro'															, .F. }, ; //X3_DESCSPA
	{ 'Novembro'															, .F. }, ; //X3_DESCENG
	{ '@E 999,999,999'														, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ 'U_GETCPOVAL("B3_Q11", 1, XFILIAL("SB3") + SB1->B1_COD, .F.)'			, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'V'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ 'U_GETCPOVAL("B3_Q11", 1, XFILIAL("SB3") + SB1->B1_COD, .F.)'			, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '4'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SB1'																	, .F. }, ; //X3_ARQUIVO
	{ 'H6'																	, .F. }, ; //X3_ORDEM
	{ 'B1_XDEZ'															, .F. }, ; //X3_CAMPO  //JA ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 11																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Dezembro'															, .F. }, ; //X3_TITULO
	{ 'Dezembro'															, .F. }, ; //X3_TITSPA
	{ 'Dezembro'															, .F. }, ; //X3_TITENG
	{ 'Dezembro'															, .F. }, ; //X3_DESCRIC
	{ 'Dezembro'															, .F. }, ; //X3_DESCSPA
	{ 'Dezembro'															, .F. }, ; //X3_DESCENG
	{ '@E 999,999,999'														, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ 'U_GETCPOVAL("B3_Q12", 1, XFILIAL("SB3") + SB1->B1_COD, .F.)'			, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'V'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ 'U_GETCPOVAL("B3_Q12", 1, XFILIAL("SB3") + SB1->B1_COD, .F.)'			, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '4'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SB1'																	, .F. }, ; //X3_ARQUIVO
	{ 'H7'																	, .F. }, ; //X3_ORDEM
	{ 'B1_XLOCAL'															, .F. }, ; //X3_CAMPO  // JA ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Localizacao'															, .F. }, ; //X3_TITULO
	{ 'Localizacao'															, .F. }, ; //X3_TITSPA
	{ 'Localizacao'															, .F. }, ; //X3_TITENG
	{ 'Localizacao'															, .F. }, ; //X3_DESCRIC
	{ 'Localizacao'															, .F. }, ; //X3_DESCSPA
	{ 'Localizacao'															, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ 'S=Sede;U=Unidade;A=Ambos'											, .F. }, ; //X3_CBOX
	{ 'S=Sede;U=Unidade;A=Ambos'											, .F. }, ; //X3_CBOXSPA
	{ 'S=Sede;U=Unidade;A=Ambos'											, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SB1'																	, .F. }, ; //X3_ARQUIVO
	{ 'K0'																	, .F. }, ; //X3_ORDEM
	{ 'B1_XMULTI'															, .F. }, ; //X3_CAMPO  // JA ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 4																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Multiplos'															, .F. }, ; //X3_TITULO
	{ 'Multiplos'															, .F. }, ; //X3_TITSPA
	{ 'Multiplos'															, .F. }, ; //X3_TITENG
	{ 'Multiplos'															, .F. }, ; //X3_DESCRIC
	{ 'Multiplos'															, .F. }, ; //X3_DESCSPA
	{ 'Multiplos'															, .F. }, ; //X3_DESCENG
	{ '9999'																, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ '"1"'																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ '€'																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '1'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME
*/
//
// Campos Tabela SB3
//
aAdd( aSX3, { ;
	{ 'SB3'																	, .F. }, ; //X3_ARQUIVO
	{ '03'																	, .F. }, ; //X3_ORDEM
	{ 'B3_XDESCRI'														, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 60																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Descricao'															, .F. }, ; //X3_TITULO
	{ 'Descricao'															, .F. }, ; //X3_TITSPA
	{ 'Descricao'															, .F. }, ; //X3_TITENG
	{ 'Descricao do produto'												, .F. }, ; //X3_DESCRIC
	{ 'Descricao do produto'												, .F. }, ; //X3_DESCSPA
	{ 'Descricao do produto'												, .F. }, ; //X3_DESCENG
	{ '@S30'																, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ 'IIF(INCLUI .OR. ALTERA,U_GETCPOVAL("B1_DESC", 1, XFILIAL("SB1") + B3_COD, .F.),"")', .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'V'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ 'U_GETCPOVAL("B1_DESC", 1, XFILIAL("SB1") + B3_COD, .F.)'				, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SB5
//
aAdd( aSX3, { ;
	{ 'SB5'																	, .F. }, ; //X3_ARQUIVO
	{ '21'																	, .F. }, ; //X3_ORDEM
	{ 'B5_XQUAL'															, .F. }, ; //X3_CAMPO  // JA ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 17																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Qualidade'															, .F. }, ; //X3_TITULO
	{ 'Calidad'																, .F. }, ; //X3_TITSPA
	{ 'Quality'																, .F. }, ; //X3_TITENG
	{ 'Qualidade do material'												, .F. }, ; //X3_DESCRIC
	{ 'Calidad del Material'												, .F. }, ; //X3_DESCSPA
	{ 'Material Quality'													, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(146) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ ''																	, .F. }, ; //X3_VISUAL
	{ ''																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '1'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SB5'																	, .F. }, ; //X3_ARQUIVO
	{ '42'																	, .F. }, ; //X3_ORDEM
	{ 'B5_XQPA'															, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 8																		, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'Qtd padrao'															, .F. }, ; //X3_TITULO
	{ 'Ctd estandar'														, .F. }, ; //X3_TITSPA
	{ 'Std.Quantity'														, .F. }, ; //X3_TITENG
	{ 'Qtd padrao de apontamento'											, .F. }, ; //X3_DESCRIC
	{ 'Cantidad Estandar'													, .F. }, ; //X3_DESCSPA
	{ 'Standard Quantity'													, .F. }, ; //X3_DESCENG
	{ '@E 99,999.99'														, .F. }, ; //X3_PICTURE
	{ 'positivo()'															, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(154) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ ''																	, .F. }, ; //X3_BROWSE
	{ ''																	, .F. }, ; //X3_VISUAL
	{ ''																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SB5'																	, .F. }, ; //X3_ARQUIVO
	{ '75'																	, .F. }, ; //X3_ORDEM
	{ 'B5_XCRICMS'														, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Cred. ICMS'															, .F. }, ; //X3_TITULO
	{ 'Cred. ICMS'															, .F. }, ; //X3_TITSPA
	{ 'Cred. ICMS'															, .F. }, ; //X3_TITENG
	{ 'Credito ICMS-Art. 271 RIC'											, .F. }, ; //X3_DESCRIC
	{ 'Credito ICMS-Art. 271 RIC'											, .F. }, ; //X3_DESCSPA
	{ 'Credito ICMS-Art. 271 RIC'											, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ 'Pertence(" 01")'														, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'S'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ '0=Nao;1=Sim'															, .F. }, ; //X3_CBOX
	{ '0=Nao;1=Sim'															, .F. }, ; //X3_CBOXSPA
	{ '0=Nao;1=Sim'															, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SBM
//
/*
aAdd( aSX3, { ;
	{ 'SBM'																	, .F. }, ; //X3_ARQUIVO
	{ '15'																	, .F. }, ; //X3_ORDEM
	{ 'BM_XCONTA1'														, .F. }, ; //X3_CAMPO  // JA ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 20																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Cta. Estoque'														, .F. }, ; //X3_TITULO
	{ 'Cta. Estoque'														, .F. }, ; //X3_TITSPA
	{ 'Cta. Estoque'														, .F. }, ; //X3_TITENG
	{ 'Conta de Estoque'													, .F. }, ; //X3_DESCRIC
	{ 'Conta de Estoque'													, .F. }, ; //X3_DESCSPA
	{ 'Conta de Estoque'													, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ 'CT1'																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ 'S'																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ 'vazio() .or. ExistCpo("CT1")'										, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SBM'																	, .F. }, ; //X3_ARQUIVO
	{ '16'																	, .F. }, ; //X3_ORDEM
	{ 'BM_XCONTA2'														, .F. }, ; //X3_CAMPO  //JA ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 20																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Cta. Despesa'														, .F. }, ; //X3_TITULO
	{ 'Cta. Despesa'														, .F. }, ; //X3_TITSPA
	{ 'Cta. Despesa'														, .F. }, ; //X3_TITENG
	{ 'Conta Despesa'														, .F. }, ; //X3_DESCRIC
	{ 'Conta Despesa'														, .F. }, ; //X3_DESCSPA
	{ 'Conta Despesa'														, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ 'CT1'																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ 'S'																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ 'Vazio() .or. ExistCpo("CT1")'										, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SBM'																	, .F. }, ; //X3_ARQUIVO
	{ '17'																	, .F. }, ; //X3_ORDEM
	{ 'BM_XDIASEG'														, .F. }, ; //X3_CAMPO // JA ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 5																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Seguranca'															, .F. }, ; //X3_TITULO
	{ 'Seguranca'															, .F. }, ; //X3_TITSPA
	{ 'Seguranca'															, .F. }, ; //X3_TITENG
	{ 'Estoque de Seguranca'												, .F. }, ; //X3_DESCRIC
	{ 'Estoque de Seguranca'												, .F. }, ; //X3_DESCSPA
	{ 'Estoque de Seguranca'												, .F. }, ; //X3_DESCENG
	{ '@E 99999'															, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SBM'																	, .F. }, ; //X3_ARQUIVO
	{ '18'																	, .F. }, ; //X3_ORDEM
	{ 'BM_XPE'																, .F. }, ; //X3_CAMPO  // JA ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 5																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Entrega'																, .F. }, ; //X3_TITULO
	{ 'Entrega'																, .F. }, ; //X3_TITSPA
	{ 'Entrega'																, .F. }, ; //X3_TITENG
	{ 'Prazo de Entrega'													, .F. }, ; //X3_DESCRIC
	{ 'Prazo de Entrega'													, .F. }, ; //X3_DESCSPA
	{ 'Prazo de Entrega'													, .F. }, ; //X3_DESCENG
	{ '@E 99999'															, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME
*/
aAdd( aSX3, { ;
	{ 'SBM'																	, .F. }, ; //X3_ARQUIVO
	{ '19'																	, .F. }, ; //X3_ORDEM
	{ 'BM_USERLGI'														, .F. }, ; //X3_CAMPO  // ALTERAR - PADRAO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 17																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Log de Inclu'														, .F. }, ; //X3_TITULO
	{ ''																	, .F. }, ; //X3_TITSPA
	{ ''																	, .F. }, ; //X3_TITENG
	{ 'Log de Inclusao'														, .F. }, ; //X3_DESCRIC
	{ ''																	, .F. }, ; //X3_DESCSPA
	{ ''																	, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 9																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'L'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SBM'																	, .F. }, ; //X3_ARQUIVO
	{ '20'																	, .F. }, ; //X3_ORDEM
	{ 'BM_USERLGA'														, .F. }, ; //X3_CAMPO  // ALTERAR -  PADRAO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 17																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Log de Alter'														, .F. }, ; //X3_TITULO
	{ ''																	, .F. }, ; //X3_TITSPA
	{ ''																	, .F. }, ; //X3_TITENG
	{ 'Log de Alteracao'													, .F. }, ; //X3_DESCRIC
	{ ''																	, .F. }, ; //X3_DESCSPA
	{ ''																	, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 9																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'L'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME
/*
aAdd( aSX3, { ;
	{ 'SBM'																	, .F. }, ; //X3_ARQUIVO
	{ '21'																	, .F. }, ; //X3_ORDEM
	{ 'BM_XCTRED1'														, .F. }, ; //X3_CAMPO  // JA ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 10																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Conta Reduzi'														, .F. }, ; //X3_TITULO
	{ 'Conta Reduzi'														, .F. }, ; //X3_TITSPA
	{ 'Conta Reduzi'														, .F. }, ; //X3_TITENG
	{ 'Conta Reduzi'														, .F. }, ; //X3_DESCRIC
	{ 'Conta Reduzi'														, .F. }, ; //X3_DESCSPA
	{ 'Conta Reduzi'														, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SBM'																	, .F. }, ; //X3_ARQUIVO
	{ '22'																	, .F. }, ; //X3_ORDEM
	{ 'BM_XCTRED2'														, .F. }, ; //X3_CAMPO  //JA ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 10																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Conta Reduzi'														, .F. }, ; //X3_TITULO
	{ 'Conta Reduzi'														, .F. }, ; //X3_TITSPA
	{ 'Conta Reduzi'														, .F. }, ; //X3_TITENG
	{ 'Conta Reduzi'														, .F. }, ; //X3_DESCRIC
	{ 'Conta Reduzi'														, .F. }, ; //X3_DESCSPA
	{ 'Conta Reduzi'														, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SC1
//
aAdd( aSX3, { ;
	{ 'SC1'																	, .F. }, ; //X3_ARQUIVO
	{ '09'																	, .F. }, ; //X3_ORDEM
	{ 'C1_XESPEC'															, .F. }, ; //X3_CAMPO  // JA ALTERADO
	{ 'M'																	, .F. }, ; //X3_TIPO
	{ 10																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Especif.'															, .F. }, ; //X3_TITULO
	{ 'Especif.'															, .F. }, ; //X3_TITSPA
	{ 'Especif.'															, .F. }, ; //X3_TITENG
	{ 'Especif.'															, .F. }, ; //X3_DESCRIC
	{ 'Especif.'															, .F. }, ; //X3_DESCSPA
	{ 'Especif.'															, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SC1'																	, .F. }, ; //X3_ARQUIVO
	{ '13'																	, .F. }, ; //X3_ORDEM
	{ 'C1_XQTDCAL'														, .F. }, ; //X3_CAMPO  // JA ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 12																	, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'Calculo Qtde'														, .F. }, ; //X3_TITULO
	{ 'Calculo Qtde'														, .F. }, ; //X3_TITSPA
	{ 'Calculo Qtde'														, .F. }, ; //X3_TITENG
	{ 'Quantidade Calculada'												, .F. }, ; //X3_DESCRIC
	{ 'Quantidade Calculada'												, .F. }, ; //X3_DESCSPA
	{ 'Quantidade Calculada'												, .F. }, ; //X3_DESCENG
	{ '@E 999,999,999.99'													, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SC1'																	, .F. }, ; //X3_ARQUIVO
	{ '18'																	, .F. }, ; //X3_ORDEM
	{ 'C1_XOBSDET'														, .F. }, ; //X3_CAMPO  // JA ALTERADO
	{ 'M'																	, .F. }, ; //X3_TIPO
	{ 10																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Obs. Detalhe'														, .F. }, ; //X3_TITULO
	{ 'Obs. Detalhe'														, .F. }, ; //X3_TITSPA
	{ 'Obs. Detalhe'														, .F. }, ; //X3_TITENG
	{ 'Observacäo detalhada'												, .F. }, ; //X3_DESCRIC
	{ 'Observacäo detalhada'												, .F. }, ; //X3_DESCSPA
	{ 'Observacäo detalhada'												, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SC1'																	, .F. }, ; //X3_ARQUIVO
	{ '25'																	, .F. }, ; //X3_ORDEM
	{ 'C1_XFORNOM'														, .F. }, ; //X3_CAMPO  // JA ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 30																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Fornecedor'															, .F. }, ; //X3_TITULO
	{ 'Fornecedor'															, .F. }, ; //X3_TITSPA
	{ 'Fornecedor'															, .F. }, ; //X3_TITENG
	{ 'Nome do Fornecedor'													, .F. }, ; //X3_DESCRIC
	{ 'Nome do Fornecedor'													, .F. }, ; //X3_DESCSPA
	{ 'Nome do Fornecedor'													, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'V'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ 'U_GETCPOVAL("A2_NOME", 1, XFILIAL("SA2") + SC1->(C1_FORNECE + C1_LOJA), .F.)', .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SC1'																	, .F. }, ; //X3_ARQUIVO
	{ '50'																	, .F. }, ; //X3_ORDEM
	{ 'C1_XSOLAUX'														, .F. }, ; //X3_CAMPO  // JA ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 15																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Comprador'															, .F. }, ; //X3_TITULO
	{ 'Comprador'															, .F. }, ; //X3_TITSPA
	{ 'Comprador'															, .F. }, ; //X3_TITENG
	{ 'Comprador'															, .F. }, ; //X3_DESCRIC
	{ 'Comprador'															, .F. }, ; //X3_DESCSPA
	{ 'Comprador'															, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'V'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ 'SC1->C1_SOLICIT'														, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SC5
//
*/
aAdd( aSX3, { ;
	{ 'SC5'																	, .F. }, ; //X3_ARQUIVO
	{ '04'																	, .F. }, ; //X3_ORDEM
	{ 'C5_XCR'																, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 9																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'C.R.'																, .F. }, ; //X3_TITULO
	{ 'C.R.'																, .F. }, ; //X3_TITSPA
	{ 'C.R.'																, .F. }, ; //X3_TITENG
	{ 'C.R.'																, .F. }, ; //X3_DESCRIC
	{ 'C.R.'																, .F. }, ; //X3_DESCSPA
	{ 'C.R.'																, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ 'CTT'																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ 'S'																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ 'Vazio() .or. ExistCPO("CTT", M->C5_XCR)'								, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ 'IIF(M->C5_TIPO=="B",.F.,.T.)'										, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '1'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SC5'																	, .F. }, ; //X3_ARQUIVO
	{ '06'																	, .F. }, ; //X3_ORDEM
	{ 'C5_XDESCCR'														, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 40																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Desc.CR'																, .F. }, ; //X3_TITULO
	{ 'Desc.CR'																, .F. }, ; //X3_TITSPA
	{ 'Desc.CR'																, .F. }, ; //X3_TITENG
	{ 'Desc.CR'																, .F. }, ; //X3_DESCRIC
	{ 'Desc.CR'																, .F. }, ; //X3_DESCSPA
	{ 'Desc.CR'																, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '1'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SC5'																	, .F. }, ; //X3_ARQUIVO
	{ '09'																	, .F. }, ; //X3_ORDEM
	{ 'C5_XNREDUZ'														, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 15																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Nom.Cliente'															, .F. }, ; //X3_TITULO
	{ 'Nom.Cliente'															, .F. }, ; //X3_TITSPA
	{ 'Nom.Cliente'															, .F. }, ; //X3_TITENG
	{ 'Nom.Cliente'															, .F. }, ; //X3_DESCRIC
	{ 'Nom.Cliente'															, .F. }, ; //X3_DESCSPA
	{ 'Nom.Cliente'															, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'V'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ 'POSICIONE("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE,"A1_NREDUZ")'		, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '1'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SC5'																	, .F. }, ; //X3_ARQUIVO
	{ '65'																	, .F. }, ; //X3_ORDEM
	{ 'C5_XVENDA'															, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 2																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Tipo Venda'															, .F. }, ; //X3_TITULO
	{ 'Tipo Venta'															, .F. }, ; //X3_TITSPA
	{ 'Sales Type'															, .F. }, ; //X3_TITENG
	{ 'Tipo da Venda'														, .F. }, ; //X3_DESCRIC
	{ 'Tipo de Venta'														, .F. }, ; //X3_DESCSPA
	{ 'Type of Sale'														, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(137) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(130) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(131) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(130) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ ''																	, .F. }, ; //X3_VISUAL
	{ ''																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '2'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SC5'																	, .F. }, ; //X3_ARQUIVO
	{ 'A2'																	, .F. }, ; //X3_ORDEM
	{ 'C5_USERLGI'														, .F. }, ; //X3_CAMPO  //// ALTERAR - PADRAO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 17																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Log de Inclu'														, .F. }, ; //X3_TITULO
	{ 'Log de Inclu'														, .F. }, ; //X3_TITSPA
	{ 'Log de Inclu'														, .F. }, ; //X3_TITENG
	{ 'Log de Inclusao'														, .F. }, ; //X3_DESCRIC
	{ 'Log de Inclusao'														, .F. }, ; //X3_DESCSPA
	{ 'Log de Inclusao'														, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 9																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'L'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SC5'																	, .F. }, ; //X3_ARQUIVO
	{ 'A3'																	, .F. }, ; //X3_ORDEM
	{ 'C5_USERLGA'														, .F. }, ; //X3_CAMPO  /// ALTERAR PADRAO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 17																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Log de Alter'														, .F. }, ; //X3_TITULO
	{ 'Log de Alter'														, .F. }, ; //X3_TITSPA
	{ 'Log de Alter'														, .F. }, ; //X3_TITENG
	{ 'Log de Alteracao'													, .F. }, ; //X3_DESCRIC
	{ 'Log de Alteracao'													, .F. }, ; //X3_DESCSPA
	{ 'Log de Alteracao'													, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 9																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'L'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SC5'																	, .F. }, ; //X3_ARQUIVO
	{ 'A4'																	, .F. }, ; //X3_ORDEM
	{ 'C5_XUSERLG'														, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 25																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Log Usuario'															, .F. }, ; //X3_TITULO
	{ 'Log Usuario'															, .F. }, ; //X3_TITSPA
	{ 'Log Usuario'															, .F. }, ; //X3_TITENG
	{ 'Login Usuario'														, .F. }, ; //X3_DESCRIC
	{ 'Login Usuario'														, .F. }, ; //X3_DESCSPA
	{ 'Login Usuario'														, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SC6
//
aAdd( aSX3, { ;
	{ 'SC6'																	, .F. }, ; //X3_ARQUIVO
	{ '03'																	, .F. }, ; //X3_ORDEM
	{ 'C6_XPATRIM'														, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 5																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Nr.Patrimo.'															, .F. }, ; //X3_TITULO
	{ 'Nr.Patrimo.'															, .F. }, ; //X3_TITSPA
	{ 'Nr.Patrimo.'															, .F. }, ; //X3_TITENG
	{ 'Nr.Patrimo.'															, .F. }, ; //X3_DESCRIC
	{ 'Nr.Patrimo.'															, .F. }, ; //X3_DESCSPA
	{ 'Nr.Patrimo.'															, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ 'PAD'																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ 'S'																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ 'u_CFATG01()'															, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SC6'																	, .F. }, ; //X3_ARQUIVO
	{ 'C5'																	, .F. }, ; //X3_ORDEM
	{ 'C6_XDOC'															, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 9																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Doc SD3'																, .F. }, ; //X3_TITULO
	{ 'Doc SD3'																, .F. }, ; //X3_TITSPA
	{ 'Doc SD3'																, .F. }, ; //X3_TITENG
	{ 'Doc SD3'																, .F. }, ; //X3_DESCRIC
	{ 'Doc SD3'																, .F. }, ; //X3_DESCSPA
	{ 'Doc SD3'																, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SC7
//
/*
aAdd( aSX3, { ;
	{ 'SC7'																	, .F. }, ; //X3_ARQUIVO
	{ '07'																	, .F. }, ; //X3_ORDEM
	{ 'C7_XESPEC'															, .F. }, ; //X3_CAMPO  // JA ALTERADO
	{ 'M'																	, .F. }, ; //X3_TIPO
	{ 10																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Especif.'															, .F. }, ; //X3_TITULO
	{ 'Especif.'															, .F. }, ; //X3_TITSPA
	{ 'Especif.'															, .F. }, ; //X3_TITENG
	{ 'Especificação'														, .F. }, ; //X3_DESCRIC
	{ 'Especificação'														, .F. }, ; //X3_DESCSPA
	{ 'Especificação'														, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SC7'																	, .F. }, ; //X3_ARQUIVO
	{ '96'																	, .F. }, ; //X3_ORDEM
	{ 'C7_XTOTCUS'														, .F. }, ; //X3_CAMPO  // JA ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 14																	, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'Total'																, .F. }, ; //X3_TITULO
	{ 'Total'																, .F. }, ; //X3_TITSPA
	{ 'Total'																, .F. }, ; //X3_TITENG
	{ 'Total'																, .F. }, ; //X3_DESCRIC
	{ 'Total'																, .F. }, ; //X3_DESCSPA
	{ 'Total'																, .F. }, ; //X3_DESCENG
	{ '@E 999,999,999.99'													, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SC8
//
aAdd( aSX3, { ;
	{ 'SC8'																	, .F. }, ; //X3_ARQUIVO
	{ '19'																	, .F. }, ; //X3_ORDEM
	{ 'C8_XFORNOM'															, .F. }, ; //X3_CAMPO  // JA ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 60																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Forn. Nome'															, .F. }, ; //X3_TITULO
	{ 'Forn. Nome'															, .F. }, ; //X3_TITSPA
	{ 'Forn. Nome'															, .F. }, ; //X3_TITENG
	{ 'Nome do Fornecedor'													, .F. }, ; //X3_DESCRIC
	{ 'Nome do Fornecedor'													, .F. }, ; //X3_DESCSPA
	{ 'Nome do Fornecedor'													, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ 'U_GETCPOVAL("A2_NOME", 1, XFILIAL("SA2") + SC8->(C8_FORNECE + C8_LOJA), .F.)', .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'V'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ 'U_GETCPOVAL("A2_NOME", 1, XFILIAL("SA2") + SC8->(C8_FORNECE + C8_LOJA), .F.)', .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SC8'																	, .F. }, ; //X3_ARQUIVO
	{ '33'																	, .F. }, ; //X3_ORDEM
	{ 'C8_XACERTO'														, .F. }, ; //X3_CAMPO  // JA ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 14																	, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'Vlr. Acerto'															, .F. }, ; //X3_TITULO
	{ 'Vlr. Acerto'															, .F. }, ; //X3_TITSPA
	{ 'Vlr. Acerto'															, .F. }, ; //X3_TITENG
	{ 'Valor de acerto'														, .F. }, ; //X3_DESCRIC
	{ 'Valor de acerto'														, .F. }, ; //X3_DESCSPA
	{ 'Valor de acerto'														, .F. }, ; //X3_DESCENG
	{ '@E 999,999,999.99'													, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SC8'																	, .F. }, ; //X3_ARQUIVO
	{ '65'																	, .F. }, ; //X3_ORDEM
	{ 'C8_XCOTSTS'														, .F. }, ; //X3_CAMPO  // JA ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Status Cot.'															, .F. }, ; //X3_TITULO
	{ 'Status Cot.'															, .F. }, ; //X3_TITSPA
	{ 'Status Cot.'															, .F. }, ; //X3_TITENG
	{ 'Status da Cotacao'													, .F. }, ; //X3_DESCRIC
	{ 'Status da Cotacao'													, .F. }, ; //X3_DESCSPA
	{ 'Status da Cotacao'													, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SC8'																	, .F. }, ; //X3_ARQUIVO
	{ '66'																	, .F. }, ; //X3_ORDEM
	{ 'C8_XBASISS'														, .F. }, ; //X3_CAMPO  // JA ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 14																	, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'Base ISS'															, .F. }, ; //X3_TITULO
	{ 'Base ISS'															, .F. }, ; //X3_TITSPA
	{ 'Base ISS'															, .F. }, ; //X3_TITENG
	{ 'Valor base do ISS'													, .F. }, ; //X3_DESCRIC
	{ 'Valor base do ISS'													, .F. }, ; //X3_DESCSPA
	{ 'Valor base do ISS'													, .F. }, ; //X3_DESCENG
	{ '@E 999,999,999.99'													, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SC8'																	, .F. }, ; //X3_ARQUIVO
	{ '67'																	, .F. }, ; //X3_ORDEM
	{ 'C8_XVALISS'														, .F. }, ; //X3_CAMPO   // JA ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 14																	, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'Vlr. ISS'															, .F. }, ; //X3_TITULO
	{ 'Vlr. ISS'															, .F. }, ; //X3_TITSPA
	{ 'Vlr. ISS'															, .F. }, ; //X3_TITENG
	{ 'Valor do ISS'														, .F. }, ; //X3_DESCRIC
	{ 'Valor do ISS'														, .F. }, ; //X3_DESCSPA
	{ 'Valor do ISS'														, .F. }, ; //X3_DESCENG
	{ '@E 999,999,999.99'													, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SC8'																	, .F. }, ; //X3_ARQUIVO
	{ '68'																	, .F. }, ; //X3_ORDEM
	{ 'C8_XALIISS'														, .F. }, ; //X3_CAMPO  // JA ALTERADO
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 5																		, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'Aliq. ISS'															, .F. }, ; //X3_TITULO
	{ 'Aliq. ISS'															, .F. }, ; //X3_TITSPA
	{ 'Aliq. ISS'															, .F. }, ; //X3_TITENG
	{ 'Aliquota ISS'														, .F. }, ; //X3_DESCRIC
	{ 'Aliquota ISS'														, .F. }, ; //X3_DESCSPA
	{ 'Aliquota ISS'														, .F. }, ; //X3_DESCENG
	{ '@E 99.99'															, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SC8'																	, .F. }, ; //X3_ARQUIVO
	{ '69'																	, .F. }, ; //X3_ORDEM
	{ 'C8_XOBSMEM'														, .F. }, ; //X3_CAMPO  // JA ALTERADO
	{ 'M'																	, .F. }, ; //X3_TIPO
	{ 10																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Observacäo'															, .F. }, ; //X3_TITULO
	{ 'Observacäo'															, .F. }, ; //X3_TITSPA
	{ 'Observacäo'															, .F. }, ; //X3_TITENG
	{ 'Observacäo'															, .F. }, ; //X3_DESCRIC
	{ 'Observacäo'															, .F. }, ; //X3_DESCSPA
	{ 'Observacäo'															, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SC8'																	, .F. }, ; //X3_ARQUIVO
	{ '82'																	, .F. }, ; //X3_ORDEM
	{ 'C8_XSOLICI'														, .F. }, ; //X3_CAMPO  // JA ALTERADO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 20																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Solicitante'															, .F. }, ; //X3_TITULO
	{ 'Solicitante'															, .F. }, ; //X3_TITSPA
	{ 'Solicitante'															, .F. }, ; //X3_TITENG
	{ 'Solicitante'															, .F. }, ; //X3_DESCRIC
	{ 'Solicitante'															, .F. }, ; //X3_DESCSPA
	{ 'Solicitante'															, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SC9
//
*/
aAdd( aSX3, { ;
	{ 'SC9'																	, .F. }, ; //X3_ARQUIVO
	{ '41'																	, .F. }, ; //X3_ORDEM
	{ 'C9_XSTATUS'														, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 20																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Status'																, .F. }, ; //X3_TITULO
	{ 'Status'																, .F. }, ; //X3_TITSPA
	{ 'Status'																, .F. }, ; //X3_TITENG
	{ 'Status'																, .F. }, ; //X3_DESCRIC
	{ 'Estatus'																, .F. }, ; //X3_DESCSPA
	{ 'Status'																, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(136) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(250) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'V'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ 'If(SC9->C9_BLEST=' + SIMPLES + '10' + SIMPLES + ',' + DUPLAS  + 'Faturado' + DUPLAS  + ',Formula(' + DUPLAS  + 'D01' + DUPLAS  + '))', .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SD1
//
aAdd( aSX3, { ;
	{ 'SD1'																	, .F. }, ; //X3_ARQUIVO
	{ '03'																	, .F. }, ; //X3_ORDEM
	{ 'D1_XDESCPR'														, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 60																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Descricao'															, .F. }, ; //X3_TITULO
	{ 'Descricao'															, .F. }, ; //X3_TITSPA
	{ 'Descricao'															, .F. }, ; //X3_TITENG
	{ 'Descricao do Produto'												, .F. }, ; //X3_DESCRIC
	{ 'Descricao do Produto'												, .F. }, ; //X3_DESCSPA
	{ 'Descricao do Produto'												, .F. }, ; //X3_DESCENG
	{ '@S20'																, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SD2
//
aAdd( aSX3, { ;
	{ 'SD2'																	, .F. }, ; //X3_ARQUIVO
	{ 'C2'																	, .F. }, ; //X3_ORDEM
	{ 'D2_XENDER'															, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 15																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Endereco Ini'														, .F. }, ; //X3_TITULO
	{ 'Ubicacion In'														, .F. }, ; //X3_TITSPA
	{ 'Ini.Location'														, .F. }, ; //X3_TITENG
	{ 'Endereco Inicial'													, .F. }, ; //X3_DESCRIC
	{ 'Ubicacion inicial'													, .F. }, ; //X3_DESCSPA
	{ 'Initial Location'													, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ 'ExistCpo("SBE")'														, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ 'SBE'																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(158) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ ''																	, .F. }, ; //X3_VISUAL
	{ ''																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'N'																	, .F. }} ) //X3_PYME

//
// Campos Tabela SD3
//
aAdd( aSX3, { ;
	{ 'SD3'																	, .F. }, ; //X3_ARQUIVO
	{ '07'																	, .F. }, ; //X3_ORDEM
	{ 'D3_XSLDEST'														, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 14																	, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'Sld Estoque'															, .F. }, ; //X3_TITULO
	{ 'Sld Estoque'															, .F. }, ; //X3_TITSPA
	{ 'Sld Estoque'															, .F. }, ; //X3_TITENG
	{ 'Saldo em Estoque'													, .F. }, ; //X3_DESCRIC
	{ 'Saldo em Estoque'													, .F. }, ; //X3_DESCSPA
	{ 'Saldo em Estoque'													, .F. }, ; //X3_DESCENG
	{ '@E 999,999,999.99'													, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'V'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SD3'																	, .F. }, ; //X3_ARQUIVO
	{ '54'																	, .F. }, ; //X3_ORDEM
	{ 'D3_USERLGI'														, .F. }, ; //X3_CAMPO  // ALTERAR -  PADRAO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 17																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Log de Inclu'														, .F. }, ; //X3_TITULO
	{ ''																	, .F. }, ; //X3_TITSPA
	{ ''																	, .F. }, ; //X3_TITENG
	{ 'Log de Inclusao'														, .F. }, ; //X3_DESCRIC
	{ ''																	, .F. }, ; //X3_DESCSPA
	{ ''																	, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 9																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'L'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SD3'																	, .F. }, ; //X3_ARQUIVO
	{ '55'																	, .F. }, ; //X3_ORDEM
	{ 'D3_USERLGA'														, .F. }, ; //X3_CAMPO  // ALTERAR - PADRAO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 17																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Log de Alter'														, .F. }, ; //X3_TITULO
	{ ''																	, .F. }, ; //X3_TITSPA
	{ ''																	, .F. }, ; //X3_TITENG
	{ 'Log de Alteracao'													, .F. }, ; //X3_DESCRIC
	{ ''																	, .F. }, ; //X3_DESCSPA
	{ ''																	, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 9																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'L'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SDS
//

aAdd( aSX3, { ;
	{ 'SDS'																	, .F. }, ; //X3_ARQUIVO
	{ '23'																	, .F. }, ; //X3_ORDEM
	{ 'DS_XCFESP'															, .F. }, ; //X3_CAMPO  //ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'CF Especial?'														, .F. }, ; //X3_TITULO
	{ '¿CFEspecial?'														, .F. }, ; //X3_TITSPA
	{ ''																	, .F. }, ; //X3_TITENG
	{ 'Cod. Fiscal especial?'												, .F. }, ; //X3_DESCRIC
	{ '¿Cod. Fiscal Especial?'												, .F. }, ; //X3_DESCSPA
	{ ''																	, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ '2'																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(132) + Chr(128)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ '1=Sim;2=Não'															, .F. }, ; //X3_CBOX
	{ '1=Si;2=No'															, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME


//
// Campos Tabela SE1
//
aAdd( aSX3, { ;
	{ 'SE1'																	, .F. }, ; //X3_ARQUIVO
	{ '07'																	, .F. }, ; //X3_ORDEM
	{ 'E1_XNATDES'														, .F. }, ; //X3_CAMPO  // ALTERA
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 30																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Nat. Descr.'															, .F. }, ; //X3_TITULO
	{ 'Nat. Descr.'															, .F. }, ; //X3_TITSPA
	{ 'Nat. Descr.'															, .F. }, ; //X3_TITENG
	{ 'Natureza - Descricao'												, .F. }, ; //X3_DESCRIC
	{ 'Natureza - Descricao'												, .F. }, ; //X3_DESCSPA
	{ 'Natureza - Descricao'												, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ 'U_GETCPOVAL("ED_DESCRIC", 1, XFILIAL("SED") + SE1->E1_NATUREZ, .F.)'		, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'C'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'V'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ 'U_GETCPOVAL("ED_DESCRIC", 1, XFILIAL("SED") + SE1->E1_NATUREZ, .F.)'		, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE1'																	, .F. }, ; //X3_ARQUIVO
	{ 'C0'																	, .F. }, ; //X3_ORDEM
	{ 'E1_XFCB'															, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 25																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Codigo FCB'															, .F. }, ; //X3_TITULO
	{ 'Codigo FCB'															, .F. }, ; //X3_TITSPA
	{ 'Codigo FCB'															, .F. }, ; //X3_TITENG
	{ 'Codigo FCB'															, .F. }, ; //X3_DESCRIC
	{ 'Codigo FCB'															, .F. }, ; //X3_DESCSPA
	{ 'Codigo FCB'															, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE1'																	, .F. }, ; //X3_ARQUIVO
	{ 'C1'																	, .F. }, ; //X3_ORDEM
	{ 'E1_XBOLETO'														, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 20																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Boleto'																, .F. }, ; //X3_TITULO
	{ 'Boleto'																, .F. }, ; //X3_TITSPA
	{ 'Boleto'																, .F. }, ; //X3_TITENG
	{ 'Boleto Bancario'														, .F. }, ; //X3_DESCRIC
	{ 'Boleto Bancario'														, .F. }, ; //X3_DESCSPA
	{ 'Boleto Bancario'														, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE1'																	, .F. }, ; //X3_ARQUIVO
	{ 'E2'																	, .F. }, ; //X3_ORDEM
	{ 'E1_XDMOTNE'														, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 60																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Motivo Negoc'														, .F. }, ; //X3_TITULO
	{ 'Motivo Negoc'														, .F. }, ; //X3_TITSPA
	{ 'Motivo Negoc'														, .F. }, ; //X3_TITENG
	{ 'Desc. Motivo da Negociac'											, .F. }, ; //X3_DESCRIC
	{ 'Desc. Motivo da Negociac'											, .F. }, ; //X3_DESCSPA
	{ 'Desc. Motivo da Negociac'											, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(129) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(166) + Chr(171)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'V'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ 'Tabela("FU",SE1->E1_MOTNEG,.f.)'										, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE1'																	, .F. }, ; //X3_ARQUIVO
	{ 'F7'																	, .F. }, ; //X3_ORDEM
	{ 'E1_XDATEDI'														, .F. }, ; //X3_CAMPO   // ALTERAR
	{ 'D'																	, .F. }, ; //X3_TIPO
	{ 8																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Data EDI'															, .F. }, ; //X3_TITULO
	{ ''																	, .F. }, ; //X3_TITSPA
	{ ''																	, .F. }, ; //X3_TITENG
	{ 'Data Geracao do EDI'													, .F. }, ; //X3_DESCRIC
	{ ''																	, .F. }, ; //X3_DESCSPA
	{ ''																	, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(192) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(132) + Chr(128)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ ''																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

//
// Campos Tabela SE2
//
aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ '07'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XRAZSOC'														, .F. }, ; //X3_CAMPO // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 60																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Razao Social'														, .F. }, ; //X3_TITULO
	{ 'Razao Social'														, .F. }, ; //X3_TITSPA
	{ 'Razao Social'														, .F. }, ; //X3_TITENG
	{ 'Razao Social'														, .F. }, ; //X3_DESCRIC
	{ 'Razao Social'														, .F. }, ; //X3_DESCSPA
	{ 'Razao Social'														, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '1'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ '11'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XNATDES'														, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 30																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Nat. Descr.'															, .F. }, ; //X3_TITULO
	{ 'Nat. Descr.'															, .F. }, ; //X3_TITSPA
	{ 'Nat. Descr.'															, .F. }, ; //X3_TITENG
	{ 'Natureza - Descricao'												, .F. }, ; //X3_DESCRIC
	{ 'Natureza - Descricao'												, .F. }, ; //X3_DESCSPA
	{ 'Natureza - Descricao'												, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ 'U_GETCPOVAL("ED_DESCRIC", 1, XFILIAL("SED") + SE2->E2_NATUREZ, .F.)'		, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'V'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ 'U_GETCPOVAL("ED_DESCRIC", 1, XFILIAL("SED") + SE2->E2_NATUREZ, .F.)'		, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '2'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ '18'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XREDUZ'															, .F. }, ; //X3_CAMPO  //  ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 20																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Cta Red. Deb'														, .F. }, ; //X3_TITULO
	{ 'Cta Red. Deb'														, .F. }, ; //X3_TITSPA
	{ 'Cta Red. Deb'														, .F. }, ; //X3_TITENG
	{ 'Cta Red. Debito'														, .F. }, ; //X3_DESCRIC
	{ 'Cta Red. Debito'														, .F. }, ; //X3_DESCSPA
	{ 'Cta Red. Debito'														, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ 'EXISTCPO("CTD",M->E2_REDUZ)'											, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ 'CTD'																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ 'S'																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ 'Vazio() .or. ExistCPO("CTD")'										, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '1'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ '19'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XDESCT1'														, .F. }, ; //X3_CAMPO  // ALTERAR - PADRAO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 40																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Desc.Cta.Deb'														, .F. }, ; //X3_TITULO
	{ 'Desc.Cta.Deb'														, .F. }, ; //X3_TITSPA
	{ 'Desc.Cta.Deb'														, .F. }, ; //X3_TITENG
	{ 'Desc.Cta.Deb'														, .F. }, ; //X3_DESCRIC
	{ 'Desc.Cta.Deb'														, .F. }, ; //X3_DESCSPA
	{ 'Desc.Cta.Deb'														, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'V'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '1'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ '20'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XCCUSTO'														, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 9																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'C.Responsab.'														, .F. }, ; //X3_TITULO
	{ 'C.Responsab.'														, .F. }, ; //X3_TITSPA
	{ 'C.Responsab.'														, .F. }, ; //X3_TITENG
	{ 'Centro de Custo'														, .F. }, ; //X3_DESCRIC
	{ 'Centro de Custo'														, .F. }, ; //X3_DESCSPA
	{ 'Centro de Custo'														, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ 'CTT'																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ 'S'																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ 'Vazio() .or. ExistCPO("CTT", M->E2_CCUSTO)'							, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '1'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ '22'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XREDCRE'														, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 20																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Cta Red.Cred'														, .F. }, ; //X3_TITULO
	{ 'Cta Red.Cred'														, .F. }, ; //X3_TITSPA
	{ 'Cta Red.Cred'														, .F. }, ; //X3_TITENG
	{ 'Cta Red.Cred'														, .F. }, ; //X3_DESCRIC
	{ 'Cta Red.Cred'														, .F. }, ; //X3_DESCSPA
	{ 'Cta Red.Cred'														, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ 'CTD'																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(130) + Chr(65)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ 'S'																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ 'Vazio().or.ExistCPO("CTD")'											, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '1'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ '23'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XCONTAB'														, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 20																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Cta Debito'															, .F. }, ; //X3_TITULO
	{ 'Cta Debito'															, .F. }, ; //X3_TITSPA
	{ 'Cta Debito'															, .F. }, ; //X3_TITENG
	{ 'Cta Debito'															, .F. }, ; //X3_DESCRIC
	{ 'Cta Debito'															, .F. }, ; //X3_DESCSPA
	{ 'Cta Debito'															, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ 'CT1'																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '4'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ '24'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XCONTCR'														, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 20																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Cta Credito'															, .F. }, ; //X3_TITULO
	{ 'Cta Credito'															, .F. }, ; //X3_TITSPA
	{ 'Cta Credito'															, .F. }, ; //X3_TITENG
	{ 'Cta Credito'															, .F. }, ; //X3_DESCRIC
	{ 'Cta Credito'															, .F. }, ; //X3_DESCSPA
	{ 'Cta Credito'															, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ 'CT1'																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '4'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ '61'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XPEDIDO'														, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 6																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Ped. Compra'															, .F. }, ; //X3_TITULO
	{ 'Ped. Compra'															, .F. }, ; //X3_TITSPA
	{ 'Ped. Compra'															, .F. }, ; //X3_TITENG
	{ 'Pedido de Compra'													, .F. }, ; //X3_DESCRIC
	{ 'Pedido de Compra'													, .F. }, ; //X3_DESCSPA
	{ 'Pedido de Compra'													, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ 'SC7'																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '4'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ '83'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XMULNAT'														, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Mult. Natur.'														, .F. }, ; //X3_TITULO
	{ 'Mult. Natur.'														, .F. }, ; //X3_TITSPA
	{ 'Mult. Natur.'														, .F. }, ; //X3_TITENG
	{ 'Multiplas Naturezas'													, .F. }, ; //X3_DESCRIC
	{ 'Multiplas Naturezas'													, .F. }, ; //X3_DESCSPA
	{ 'Multiplas Naturezas'													, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ 'pertence("12") .And. Fa050MultNat()'									, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ '"2"'																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ 'S'																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ 'IIF(M->E2_MULNATU == "1",U_E2MULNAT(),.T.)'							, .F. }, ; //X3_VLDUSER
	{ '1=Sim;2=Nao'															, .F. }, ; //X3_CBOX
	{ '1=Sim;2=Nao'															, .F. }, ; //X3_CBOXSPA
	{ '1=Sim;2=Nao'															, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '2'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ '88'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XLD'																, .F. }, ; //X3_CAMPO   //ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 47																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'L.Digitavel'															, .F. }, ; //X3_TITULO
	{ 'L.Digitavel'															, .F. }, ; //X3_TITSPA
	{ 'L.Digitavel'															, .F. }, ; //X3_TITENG
	{ 'Linha Digitavel'														, .F. }, ; //X3_DESCRIC
	{ 'Linha Digitavel'														, .F. }, ; //X3_DESCSPA
	{ 'Linha Digitavel'														, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ 'S'																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ 'IIF(EMPTY(ALLTRIM(M->E2_BANCO)),.T.,.F.)'							, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '2'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ '90'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XDTLIB1'														, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'D'																	, .F. }, ; //X3_TIPO
	{ 8																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Dt. Liber. 1'														, .F. }, ; //X3_TITULO
	{ 'Dt. Liber. 1'														, .F. }, ; //X3_TITSPA
	{ 'Dt. Liber. 1'														, .F. }, ; //X3_TITENG
	{ 'Data Liiberacao 1'													, .F. }, ; //X3_DESCRIC
	{ 'Data Liiberacao 1'													, .F. }, ; //X3_DESCSPA
	{ 'Data Liiberacao 1'													, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '2'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ '92'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XDTLIB2'														, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'D'																	, .F. }, ; //X3_TIPO
	{ 8																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Dt. Liber. 2'														, .F. }, ; //X3_TITULO
	{ 'Dt. Liber. 2'														, .F. }, ; //X3_TITSPA
	{ 'Dt. Liber. 2'														, .F. }, ; //X3_TITENG
	{ 'Data Liiberacao 2'													, .F. }, ; //X3_DESCRIC
	{ 'Data Liiberacao 2'													, .F. }, ; //X3_DESCSPA
	{ 'Data Liiberacao 2'													, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '4'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ '93'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XUSLIB2'														, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 15																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Usr. Liber.2'														, .F. }, ; //X3_TITULO
	{ 'Usr. Liber.2'														, .F. }, ; //X3_TITSPA
	{ 'Usr. Liber.2'														, .F. }, ; //X3_TITENG
	{ 'Usuario Liberador 2'													, .F. }, ; //X3_DESCRIC
	{ 'Usuario Liberador 2'													, .F. }, ; //X3_DESCSPA
	{ 'Usuario Liberador 2'													, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '4'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ '94'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XNIVUS1'														, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Nivel Usr. 1'														, .F. }, ; //X3_TITULO
	{ 'Nivel Usr. 1'														, .F. }, ; //X3_TITSPA
	{ 'Nivel Usr. 1'														, .F. }, ; //X3_TITENG
	{ 'Nivel Usuario 1'														, .F. }, ; //X3_DESCRIC
	{ 'Nivel Usuario 1'														, .F. }, ; //X3_DESCSPA
	{ 'Nivel Usuario 1'														, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '4'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ '95'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XNIVUS2'														, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Nivel Usr. 2'														, .F. }, ; //X3_TITULO
	{ 'Nivel Usr. 2'														, .F. }, ; //X3_TITSPA
	{ 'Nivel Usr. 2'														, .F. }, ; //X3_TITENG
	{ 'Nivel Usuario 2'														, .F. }, ; //X3_DESCRIC
	{ 'Nivel Usuario 2'														, .F. }, ; //X3_DESCSPA
	{ 'Nivel Usuario 2'														, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '4'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ '96'																	, .F. }, ; //X3_ORDEM
	{ 'E2_USERLGI'														, .F. }, ; //X3_CAMPO   // ALTERAR - PADRAO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 17																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Log de Inclu'														, .F. }, ; //X3_TITULO
	{ ''																	, .F. }, ; //X3_TITSPA
	{ ''																	, .F. }, ; //X3_TITENG
	{ 'Log de Inclusao'														, .F. }, ; //X3_DESCRIC
	{ ''																	, .F. }, ; //X3_DESCSPA
	{ ''																	, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 9																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '4'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ 'A0'																	, .F. }, ; //X3_ORDEM
	{ 'E2_USERLGA'														, .F. }, ; //X3_CAMPO  // ALTERAR -  PADRAO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 17																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Log de Alter'														, .F. }, ; //X3_TITULO
	{ ''																	, .F. }, ; //X3_TITSPA
	{ ''																	, .F. }, ; //X3_TITENG
	{ 'Log de Alteracao'													, .F. }, ; //X3_DESCRIC
	{ ''																	, .F. }, ; //X3_DESCSPA
	{ ''																	, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 9																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '4'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ 'A1'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XADF'															, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 6																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Prestacao'															, .F. }, ; //X3_TITULO
	{ 'Prestacao'															, .F. }, ; //X3_TITSPA
	{ 'Prestacao'															, .F. }, ; //X3_TITENG
	{ 'No. da Prestacao'													, .F. }, ; //X3_DESCRIC
	{ 'No. da Prestacao'													, .F. }, ; //X3_DESCSPA
	{ 'No. da Prestacao'													, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '2'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ 'A2'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XNUMAP'															, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 6																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Aut.Pagto'															, .F. }, ; //X3_TITULO
	{ 'Aut.Pagto'															, .F. }, ; //X3_TITSPA
	{ 'Aut.Pagto'															, .F. }, ; //X3_TITENG
	{ 'Autorizacao Pagamento'												, .F. }, ; //X3_DESCRIC
	{ 'Autorizacao Pagamento'												, .F. }, ; //X3_DESCSPA
	{ 'Autorizacao Pagamento'												, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '2'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ 'A3'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XFL'																, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 6																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'FL'																	, .F. }, ; //X3_TITULO
	{ 'FL'																	, .F. }, ; //X3_TITSPA
	{ 'FL'																	, .F. }, ; //X3_TITENG
	{ 'Ficha de Lancamento'													, .F. }, ; //X3_DESCRIC
	{ 'Ficha de Lancamento'													, .F. }, ; //X3_DESCSPA
	{ 'Ficha de Lancamento'													, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '2'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME
aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ 'A8'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XTICSLL'														, .F. }, ; //X3_CAMPO  //ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 25																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'TIT.CSLL OFF'														, .F. }, ; //X3_TITULO
	{ ''																	, .F. }, ; //X3_TITSPA
	{ ''																	, .F. }, ; //X3_TITENG
	{ 'TIT. CSLL OFF'														, .F. }, ; //X3_DESCRIC
	{ ''																	, .F. }, ; //X3_DESCSPA
	{ ''																	, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '4'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ 'B9'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XDTCOMP'														, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'D'																	, .F. }, ; //X3_TIPO
	{ 8																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Comprovante'															, .F. }, ; //X3_TITULO
	{ 'Comprovante'															, .F. }, ; //X3_TITSPA
	{ 'Comprovante'															, .F. }, ; //X3_TITENG
	{ 'Data do Comprovante'													, .F. }, ; //X3_DESCRIC
	{ 'Data do Comprovante'													, .F. }, ; //X3_DESCSPA
	{ 'Data do Comprovante'													, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '2'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ 'C0'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XOBS'															, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 40																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Observacao'															, .F. }, ; //X3_TITULO
	{ 'Observacao'															, .F. }, ; //X3_TITSPA
	{ 'Observacao'															, .F. }, ; //X3_TITENG
	{ 'Observacao do documento'												, .F. }, ; //X3_DESCRIC
	{ 'Observacao do documento'												, .F. }, ; //X3_DESCSPA
	{ 'Observacao do documento'												, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '2'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ 'E6'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XBANCO'															, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 3																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Bco.Fornece'															, .F. }, ; //X3_TITULO
	{ 'Bco.Fornece'															, .F. }, ; //X3_TITSPA
	{ 'Bco.Fornece'															, .F. }, ; //X3_TITENG
	{ 'Banco Fornecedor'													, .F. }, ; //X3_DESCRIC
	{ 'Banco Fornecedor'													, .F. }, ; //X3_DESCSPA
	{ 'Banco Fornecedor'													, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ 'SZK'																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ 'IIF(EMPTY(ALLTRIM(M->E2_LD)),.T.,.F.)'								, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '2'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ 'E9'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XAGEFOR'														, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 4																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Ag.Fornece'															, .F. }, ; //X3_TITULO
	{ 'Ag.Fornece'															, .F. }, ; //X3_TITSPA
	{ 'Ag.Fornece'															, .F. }, ; //X3_TITENG
	{ 'Agencia Fornecedor'													, .F. }, ; //X3_DESCRIC
	{ 'Agencia Fornecedor'													, .F. }, ; //X3_DESCSPA
	{ 'Agencia Fornecedor'													, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '2'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ 'F0'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XDVFOR'															, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Dv. Agencia'															, .F. }, ; //X3_TITULO
	{ 'Dv. Agencia'															, .F. }, ; //X3_TITSPA
	{ 'Dv. Agencia'															, .F. }, ; //X3_TITENG
	{ 'Digito Verif. Agencia'												, .F. }, ; //X3_DESCRIC
	{ 'Digito Verif. Agencia'												, .F. }, ; //X3_DESCSPA
	{ 'Digito Verif. Agencia'												, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '2'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ 'F1'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XCTAFOR'														, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 16																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Cta.Fornece'															, .F. }, ; //X3_TITULO
	{ 'Cta.Fornece'															, .F. }, ; //X3_TITSPA
	{ 'Cta.Fornece'															, .F. }, ; //X3_TITENG
	{ 'Conta Corrente Fornece'												, .F. }, ; //X3_DESCRIC
	{ 'Conta Corrente Fornece'												, .F. }, ; //X3_DESCSPA
	{ 'Conta Corrente Fornece'												, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '2'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ 'F3'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XPAGFOR'														, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 10																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Arq. PAGFOR'															, .F. }, ; //X3_TITULO
	{ 'Arq. PAGFOR'															, .F. }, ; //X3_TITSPA
	{ 'Arq. PAGFOR'															, .F. }, ; //X3_TITENG
	{ 'Arq. PAGFOR'															, .F. }, ; //X3_DESCRIC
	{ 'Arq. PAGFOR'															, .F. }, ; //X3_DESCSPA
	{ 'Arq. PAGFOR'															, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '4'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ 'K5'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XBCOBOR'														, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 3																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Banco.Border'														, .F. }, ; //X3_TITULO
	{ 'Banco.Border'														, .F. }, ; //X3_TITSPA
	{ 'Banco.Border'														, .F. }, ; //X3_TITENG
	{ 'Banco.Border'														, .F. }, ; //X3_DESCRIC
	{ 'Banco.Border'														, .F. }, ; //X3_DESCSPA
	{ 'Banco.Border'														, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(32)						, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ 'SA6'																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ 'S'																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '2'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ 'K6'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XAGBOR'															, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 5																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Agenc.Border'														, .F. }, ; //X3_TITULO
	{ 'Agenc.Border'														, .F. }, ; //X3_TITSPA
	{ 'Agenc.Border'														, .F. }, ; //X3_TITENG
	{ 'Agenc.Border'														, .F. }, ; //X3_DESCRIC
	{ 'Agenc.Border'														, .F. }, ; //X3_DESCSPA
	{ 'Agenc.Border'														, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '2'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ 'K9'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XCCBOR'															, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 10																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'C/C Border'															, .F. }, ; //X3_TITULO
	{ 'C/C Border'															, .F. }, ; //X3_TITSPA
	{ 'C/C Border'															, .F. }, ; //X3_TITENG
	{ 'C/C Border'															, .F. }, ; //X3_DESCRIC
	{ 'C/C Border'															, .F. }, ; //X3_DESCSPA
	{ 'C/C Border'															, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '2'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ 'L1'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XMODELO'														, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 2																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Modelo'																, .F. }, ; //X3_TITULO
	{ 'Modelo'																, .F. }, ; //X3_TITSPA
	{ 'Modelo'																, .F. }, ; //X3_TITENG
	{ 'Modelo'																, .F. }, ; //X3_DESCRIC
	{ 'Modelo'																, .F. }, ; //X3_DESCSPA
	{ 'Modelo'																, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ '58'																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '2'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ 'L3'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XOBSADT'														, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 50																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Obs. Adiant.'														, .F. }, ; //X3_TITULO
	{ 'Obs. Adiant.'														, .F. }, ; //X3_TITSPA
	{ 'Obs. Adiant.'														, .F. }, ; //X3_TITENG
	{ 'Obs. Adiant.'														, .F. }, ; //X3_DESCRIC
	{ 'Obs. Adiant.'														, .F. }, ; //X3_DESCSPA
	{ 'Obs. Adiant.'														, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '4'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ 'L4'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XCOMPET'														, .F. }, ; //X3_CAMPO  // ALTERAR  -  PADRAO ESPEC
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 7																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Competencia'															, .F. }, ; //X3_TITULO
	{ 'Competencia'															, .F. }, ; //X3_TITSPA
	{ 'Competencia'															, .F. }, ; //X3_TITENG
	{ 'Competencia'															, .F. }, ; //X3_DESCRIC
	{ 'Competencia'															, .F. }, ; //X3_DESCSPA
	{ 'Competencia'															, .F. }, ; //X3_DESCENG
	{ '99/9999'																, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ 'IIF(M->E2_MULNATU=="1",.F.,.T.)'										, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '2'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ 'M9'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XTPAMOR'														, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Amortizacao'															, .F. }, ; //X3_TITULO
	{ 'Amortizacao'															, .F. }, ; //X3_TITSPA
	{ 'Amortizacao'															, .F. }, ; //X3_TITENG
	{ 'Amortizacao'															, .F. }, ; //X3_DESCRIC
	{ 'Amortizacao'															, .F. }, ; //X3_DESCSPA
	{ 'Amortizacao'															, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ '"N"'																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'S'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ 'S=Sim;N=Nao'															, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '1'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ 'N0'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XCNTDAM'														, .F. }, ; //X3_CAMPO  //ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 10																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Conta Debito'														, .F. }, ; //X3_TITULO
	{ 'Conta Debito'														, .F. }, ; //X3_TITSPA
	{ 'Conta Debito'														, .F. }, ; //X3_TITENG
	{ 'Conta Debito'														, .F. }, ; //X3_DESCRIC
	{ 'Conta Debito'														, .F. }, ; //X3_DESCSPA
	{ 'Conta Debito'														, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ 'CTD'																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'S'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ 'Vazio() .or. ExistCPO("CTD")'										, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ 'IIF(M->E2_TPAMORT=="S",.T.,.F.)'										, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '3'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ 'N1'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XCCDAM'															, .F. }, ; //X3_CAMPO  // ALTERAR
 	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 10																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'CC debito'															, .F. }, ; //X3_TITULO
	{ 'CC debito'															, .F. }, ; //X3_TITSPA
	{ 'CC debito'															, .F. }, ; //X3_TITENG
	{ 'CC debito'															, .F. }, ; //X3_DESCRIC
	{ 'CC debito'															, .F. }, ; //X3_DESCSPA
	{ 'CC debito'															, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ 'CTT'																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'S'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ '(Vazio() .or. ExistCPO("CTT", M->E2_CCD_AM)) .and. ValidaBloq(M->E2_CCD_AM,DDATABASE,"CTT")', .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ 'IIF(M->E2_TPAMORT=="S",.T.,.F.)'										, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '3'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ 'N2'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XPARCAM'														, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 3																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'N.Parc.Amort'														, .F. }, ; //X3_TITULO
	{ 'N.Parc.Amort'														, .F. }, ; //X3_TITSPA
	{ 'N.Parc.Amort'														, .F. }, ; //X3_TITENG
	{ 'N.Parc.Amort'														, .F. }, ; //X3_DESCRIC
	{ 'N.Parc.Amort'														, .F. }, ; //X3_DESCSPA
	{ 'N.Parc.Amort'														, .F. }, ; //X3_DESCENG
	{ '@E 999'																, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'S'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ 'IIF(M->E2_TPAMORT=="S",.T.,.F.)'										, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '3'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ 'N3'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XHISTAM'														, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 40																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Hist. Amort'															, .F. }, ; //X3_TITULO
	{ 'Hist. Amort'															, .F. }, ; //X3_TITSPA
	{ 'Hist. Amort'															, .F. }, ; //X3_TITENG
	{ 'Hist. Amort'															, .F. }, ; //X3_DESCRIC
	{ 'Hist. Amort'															, .F. }, ; //X3_DESCSPA
	{ 'Hist. Amort'															, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'S'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ 'IIF(M->E2_TPAMORT=="S",.T.,.F.)'										, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '3'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ 'N4'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XCNTCAM'														, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 10																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Conta Credit'														, .F. }, ; //X3_TITULO
	{ 'Conta Credit'														, .F. }, ; //X3_TITSPA
	{ 'Conta Credit'														, .F. }, ; //X3_TITENG
	{ 'Conta Credit'														, .F. }, ; //X3_DESCRIC
	{ 'Conta Credit'														, .F. }, ; //X3_DESCSPA
	{ 'Conta Credit'														, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ 'CTD'																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'S'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ 'Vazio() .or. ExistCPO("CTD")'										, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ 'IIF(M->E2_TPAMORT=="S",.T.,.F.)'										, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '3'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE2'																	, .F. }, ; //X3_ARQUIVO
	{ 'N5'																	, .F. }, ; //X3_ORDEM
	{ 'E2_XCCCAM'															, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 10																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'CC credito'															, .F. }, ; //X3_TITULO
	{ 'CC credito'															, .F. }, ; //X3_TITSPA
	{ 'CC credito'															, .F. }, ; //X3_TITENG
	{ 'CC credito'															, .F. }, ; //X3_DESCRIC
	{ 'CC credito'															, .F. }, ; //X3_DESCSPA
	{ 'CC credito'															, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ 'CTT'																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'S'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ '(Vazio() .or. ExistCPO("CTT", M->E2_CCC_AM)) .and. ValidaBloq(M->E2_CCC_AM,DDATABASE,"CTT")', .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ 'IIF(M->E2_TPAMORT=="S",.T.,.F.)'										, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '3'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SE5
//
aAdd( aSX3, { ;
	{ 'SE5'																	, .F. }, ; //X3_ARQUIVO
	{ '04'																	, .F. }, ; //X3_ORDEM
	{ 'E5_XTIPO'															, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 5																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Pre Cadast.'															, .F. }, ; //X3_TITULO
	{ 'Pre Cadast.'															, .F. }, ; //X3_TITSPA
	{ 'Pre Cadast.'															, .F. }, ; //X3_TITENG
	{ 'Pre Cadast.'															, .F. }, ; //X3_DESCRIC
	{ 'Pre Cadast.'															, .F. }, ; //X3_DESCSPA
	{ 'Pre Cadast.'															, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ 'SZM'																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ 'S'																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE5'																	, .F. }, ; //X3_ARQUIVO
	{ '61'																	, .F. }, ; //X3_ORDEM
	{ 'E5_XNATREC'														, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 10																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Nat. Reclass'														, .F. }, ; //X3_TITULO
	{ 'Nat. Reclass'														, .F. }, ; //X3_TITSPA
	{ 'Nat. Reclass'														, .F. }, ; //X3_TITENG
	{ 'Natureza Reclassificada'												, .F. }, ; //X3_DESCRIC
	{ 'Natureza Reclassificada'												, .F. }, ; //X3_DESCSPA
	{ 'Natureza Reclassificada'												, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ 'existcpo("SED")'														, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ 'SED'																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(130) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ 'S'																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ ''																	, .F. }, ; //X3_VISUAL
	{ ''																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE5'																	, .F. }, ; //X3_ARQUIVO
	{ '62'																	, .F. }, ; //X3_ORDEM
	{ 'E5_XNATDES'														, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 30																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Nat. Descr.'															, .F. }, ; //X3_TITULO
	{ 'Nat. Descr.'															, .F. }, ; //X3_TITSPA
	{ 'Nat. Descr.'															, .F. }, ; //X3_TITENG
	{ 'Natureza - Descricao'												, .F. }, ; //X3_DESCRIC
	{ 'Natureza - Descricao'												, .F. }, ; //X3_DESCSPA
	{ 'Natureza - Descricao'												, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ 'U_GETCPOVAL("ED_DESCRIC", 1, XFILIAL("SED") + SE5->E5_NATREC, .F.)'		, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(65)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'V'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ 'U_GETCPOVAL("ED_DESCRIC", 1, XFILIAL("SED") + SE5->E5_NATREC, .F.)'		, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE5'																	, .F. }, ; //X3_ARQUIVO
	{ '63'																	, .F. }, ; //X3_ORDEM
	{ 'E5_XCUSTO'															, .F. }, ; //X3_CAMPO  //ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 9																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'C.Custo'																, .F. }, ; //X3_TITULO
	{ 'C.Custo'																, .F. }, ; //X3_TITSPA
	{ 'C.Custo'																, .F. }, ; //X3_TITENG
	{ 'C.Custo'																, .F. }, ; //X3_DESCRIC
	{ 'C.Custo'																, .F. }, ; //X3_DESCSPA
	{ 'C.Custo'																, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ 'CTT'																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE5'																	, .F. }, ; //X3_ARQUIVO
	{ '64'																	, .F. }, ; //X3_ORDEM
	{ 'E5_XFLUXO'															, .F. }, ; //X3_CAMPO  //ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Fluxo'																, .F. }, ; //X3_TITULO
	{ 'Rateio'																, .F. }, ; //X3_TITSPA
	{ 'Rateio'																, .F. }, ; //X3_TITENG
	{ 'Rateio'																, .F. }, ; //X3_DESCRIC
	{ 'Rateio'																, .F. }, ; //X3_DESCSPA
	{ 'Rateio'																, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'C'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE5'																	, .F. }, ; //X3_ARQUIVO
	{ '65'																	, .F. }, ; //X3_ORDEM
	{ 'E5_XMOTIVO'														, .F. }, ; //X3_CAMPO  //ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 40																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Motivo'																, .F. }, ; //X3_TITULO
	{ 'Motivo'																, .F. }, ; //X3_TITSPA
	{ 'Motivo'																, .F. }, ; //X3_TITENG
	{ 'Motivo Exclusao'														, .F. }, ; //X3_DESCRIC
	{ 'Motivo Exclusao'														, .F. }, ; //X3_DESCSPA
	{ 'Motivo Exclusao'														, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE5'																	, .F. }, ; //X3_ARQUIVO
	{ '86'																	, .F. }, ; //X3_ORDEM
	{ 'E5_XNUMAP'															, .F. }, ; //X3_CAMPO  //ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 6																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Aut. Pgto'															, .F. }, ; //X3_TITULO
	{ 'Aut. Pgto'															, .F. }, ; //X3_TITSPA
	{ 'Aut. Pgto'															, .F. }, ; //X3_TITENG
	{ 'Autorizacao Pagamento'												, .F. }, ; //X3_DESCRIC
	{ 'Autorizacao Pagamento'												, .F. }, ; //X3_DESCSPA
	{ 'Autorizacao Pagamento'												, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'C'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE5'																	, .F. }, ; //X3_ARQUIVO
	{ '87'																	, .F. }, ; //X3_ORDEM
	{ 'E5_XCARTAO'														, .F. }, ; //X3_CAMPO  //ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 12																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Cartao ITAU'															, .F. }, ; //X3_TITULO
	{ 'Cartao ITAU'															, .F. }, ; //X3_TITSPA
	{ 'Cartao ITAU'															, .F. }, ; //X3_TITENG
	{ 'Cartao ITAU'															, .F. }, ; //X3_DESCRIC
	{ 'Cartao ITAU'															, .F. }, ; //X3_DESCSPA
	{ 'Cartao ITAU'															, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ 'SZK001'																, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE5'																	, .F. }, ; //X3_ARQUIVO
	{ '97'																	, .F. }, ; //X3_ORDEM
	{ 'E5_XCOMPET'														, .F. }, ; //X3_CAMPO  //ALTERAR - PADRAO ESP
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 7																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Competencia'															, .F. }, ; //X3_TITULO
	{ 'Competencia'															, .F. }, ; //X3_TITSPA
	{ 'Competencia'															, .F. }, ; //X3_TITENG
	{ 'Competencia'															, .F. }, ; //X3_DESCRIC
	{ 'Competencia'															, .F. }, ; //X3_DESCSPA
	{ 'Competencia'															, .F. }, ; //X3_DESCENG
	{ '99/9999'																, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE5'																	, .F. }, ; //X3_ARQUIVO
	{ 'A0'																	, .F. }, ; //X3_ORDEM
	{ 'E5_XREFFLC'														, .F. }, ; //X3_CAMPO  //ALTERAR - PADRAO ESP
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 40																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Cod.Refer.FL'														, .F. }, ; //X3_TITULO
	{ 'Cod.Refer.FL'														, .F. }, ; //X3_TITSPA
	{ 'Cod.Refer.FL'														, .F. }, ; //X3_TITENG
	{ 'Codigo Referencia FL CP'												, .F. }, ; //X3_DESCRIC
	{ 'Codigo Referencia FL CP'												, .F. }, ; //X3_DESCSPA
	{ 'Codigo Referencia FL CP'												, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SE6
//
aAdd( aSX3, { ;
	{ 'SE6'																	, .F. }, ; //X3_ARQUIVO
	{ '16'																	, .F. }, ; //X3_ORDEM
	{ 'E6_XNOMSOL'														, .F. }, ; //X3_CAMPO  //ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 15																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Solicitante'															, .F. }, ; //X3_TITULO
	{ ''																	, .F. }, ; //X3_TITSPA
	{ ''																	, .F. }, ; //X3_TITENG
	{ 'Nome de quem solicitou'												, .F. }, ; //X3_DESCRIC
	{ ''																	, .F. }, ; //X3_DESCSPA
	{ ''																	, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(168)					, .F. }, ; //X3_USADO
	{ 'UsrFullName(SE6->E6_USRSOL)'											, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(134) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'V'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ 'UsrFullName(SE6->E6_USRSOL)'											, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE6'																	, .F. }, ; //X3_ARQUIVO
	{ '18'																	, .F. }, ; //X3_ORDEM
	{ 'E6_XNOMAPV'														, .F. }, ; //X3_CAMPO  //ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 15																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Apr/Rej. por'														, .F. }, ; //X3_TITULO
	{ ''																	, .F. }, ; //X3_TITSPA
	{ ''																	, .F. }, ; //X3_TITENG
	{ 'Quem aprovou ou rejeitou'											, .F. }, ; //X3_DESCRIC
	{ ''																	, .F. }, ; //X3_DESCSPA
	{ ''																	, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(168)					, .F. }, ; //X3_USADO
	{ 'UsrFullName(SE6->E6_USRAPV)'											, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(134) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'V'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ 'UsrFullName(SE6->E6_USRAPV)'											, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

//
// Campos Tabela SE8
//
aAdd( aSX3, { ;
	{ 'SE8'																	, .F. }, ; //X3_ARQUIVO
	{ '10'																	, .F. }, ; //X3_ORDEM
	{ 'E8_XSALCIE'														, .F. }, ; //X3_CAMPO  //ALTERAR
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 17																	, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'Saldo CIEE'															, .F. }, ; //X3_TITULO
	{ 'Saldo CIEE'															, .F. }, ; //X3_TITSPA
	{ 'Saldo CIEE'															, .F. }, ; //X3_TITENG
	{ 'Saldo CIEE'															, .F. }, ; //X3_DESCRIC
	{ 'Saldo CIEE'															, .F. }, ; //X3_DESCSPA
	{ 'Saldo CIEE'															, .F. }, ; //X3_DESCENG
	{ '@E 999,999,999,999.99'												, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(154) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ ''																	, .F. }, ; //X3_VISUAL
	{ ''																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SE8'																	, .F. }, ; //X3_ARQUIVO
	{ '12'																	, .F. }, ; //X3_ORDEM
	{ 'E8_XFLAG'															, .F. }, ; //X3_CAMPO  //ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Flag'																, .F. }, ; //X3_TITULO
	{ 'Flag'																, .F. }, ; //X3_TITSPA
	{ 'Flag'																, .F. }, ; //X3_TITENG
	{ 'Flag'																, .F. }, ; //X3_DESCRIC
	{ 'Flag'																, .F. }, ; //X3_DESCSPA
	{ 'Flag'																, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SED
//
aAdd( aSX3, { ;
	{ 'SED'																	, .F. }, ; //X3_ARQUIVO
	{ '15'																	, .F. }, ; //X3_ORDEM
	{ 'ED_XFECHA'															, .F. }, ; //X3_CAMPO  //ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 100																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Fechamento'															, .F. }, ; //X3_TITULO
	{ 'Fechamento'															, .F. }, ; //X3_TITSPA
	{ 'Fechamento'															, .F. }, ; //X3_TITENG
	{ 'Fechamento'															, .F. }, ; //X3_DESCRIC
	{ 'Fechamento'															, .F. }, ; //X3_DESCSPA
	{ 'Fechamento'															, .F. }, ; //X3_DESCENG
	{ '@S15!'																, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(152) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SED'																	, .F. }, ; //X3_ARQUIVO
	{ '16'																	, .F. }, ; //X3_ORDEM
	{ 'ED_XFECHAB'														, .F. }, ; //X3_CAMPO  //ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 200																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Fecham.Mod.B'														, .F. }, ; //X3_TITULO
	{ 'Fecham.Mod.B'														, .F. }, ; //X3_TITSPA
	{ 'Fecham.Mod.B'														, .F. }, ; //X3_TITENG
	{ 'Fecham.Mod.B'														, .F. }, ; //X3_DESCRIC
	{ 'Fecham.Mod.B'														, .F. }, ; //X3_DESCSPA
	{ 'Fecham.Mod.B'														, .F. }, ; //X3_DESCENG
	{ '@S15!'																, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SED'																	, .F. }, ; //X3_ARQUIVO
	{ '17'																	, .F. }, ; //X3_ORDEM
	{ 'ED_XNATEST'														, .F. }, ; //X3_CAMPO  //ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 10																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Nat.Estorno'															, .F. }, ; //X3_TITULO
	{ 'Nat.Estorno'															, .F. }, ; //X3_TITSPA
	{ 'Nat.Estorno'															, .F. }, ; //X3_TITENG
	{ 'Natureza de Estorno'													, .F. }, ; //X3_DESCRIC
	{ 'Natureza de Estorno'													, .F. }, ; //X3_DESCSPA
	{ 'Natureza de Estorno'													, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ 'SED'																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SED'																	, .F. }, ; //X3_ARQUIVO
	{ '37'																	, .F. }, ; //X3_ORDEM
	{ 'ED_XCLASSE'														, .F. }, ; //X3_CAMPO  //ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Classe'																, .F. }, ; //X3_TITULO
	{ 'Classe'																, .F. }, ; //X3_TITSPA
	{ 'Classe'																, .F. }, ; //X3_TITENG
	{ 'Classe'																, .F. }, ; //X3_DESCRIC
	{ 'Classe'																, .F. }, ; //X3_DESCSPA
	{ 'Classe'																, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ 'pertence("12") .and. naovazio()'										, .F. }, ; //X3_VLDUSER
	{ '1=Analitica;2=Sintetica'												, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SED'																	, .F. }, ; //X3_ARQUIVO
	{ '38'																	, .F. }, ; //X3_ORDEM
	{ 'ED_XSUP'															, .F. }, ; //X3_CAMPO  //ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 10																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Nat.Totaliza'														, .F. }, ; //X3_TITULO
	{ 'Nat.Totaliza'														, .F. }, ; //X3_TITSPA
	{ 'Nat.Totaliza'														, .F. }, ; //X3_TITENG
	{ 'Natureza Totalizadora'												, .F. }, ; //X3_DESCRIC
	{ 'Natureza Totalizadora'												, .F. }, ; //X3_DESCSPA
	{ 'Natureza Totalizadora'												, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ 'SED'																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ 'ExistCpo("SED",M->ED_SUP)  .And. IIF(Len(AllTrim(M->ED_SUP))==4,.T.,M->ED_SUP<>M->ED_CODIGO)', .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SED'																	, .F. }, ; //X3_ARQUIVO
	{ '39'																	, .F. }, ; //X3_ORDEM
	{ 'ED_XTPMOV'															, .F. }, ; //X3_CAMPO  //ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Sinal.N.Tot'															, .F. }, ; //X3_TITULO
	{ 'Sinal.N.Tot'															, .F. }, ; //X3_TITSPA
	{ 'Sinal.N.Tot'															, .F. }, ; //X3_TITENG
	{ 'Sinal Nat. Totalizadora'												, .F. }, ; //X3_DESCRIC
	{ 'Sinal Nat. Totalizadora'												, .F. }, ; //X3_DESCSPA
	{ 'Sinal Nat. Totalizadora'												, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ 'pertence("PN")'														, .F. }, ; //X3_VLDUSER
	{ 'P=Positivo;N=Negativo'												, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SED'																	, .F. }, ; //X3_ARQUIVO
	{ '40'																	, .F. }, ; //X3_ORDEM
	{ 'ED_XSUPORC'														, .F. }, ; //X3_CAMPO  //ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 10																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Nat De Para'															, .F. }, ; //X3_TITULO
	{ 'Nat De Para'															, .F. }, ; //X3_TITSPA
	{ 'Nat De Para'															, .F. }, ; //X3_TITENG
	{ 'Natureza De Para'													, .F. }, ; //X3_DESCRIC
	{ 'Natureza De Para'													, .F. }, ; //X3_DESCSPA
	{ 'Natureza De Para'													, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ 'ExistCpo("SED",M->ED_SUPORC) .And.  M->ED_SUPORC <> M->ED_CODIGO'	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SED'																	, .F. }, ; //X3_ARQUIVO
	{ '41'																	, .F. }, ; //X3_ORDEM
	{ 'ED_XDESORC'														, .F. }, ; //X3_CAMPO  //ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 40																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Desc Rel Flx'														, .F. }, ; //X3_TITULO
	{ 'Desc Rel Flx'														, .F. }, ; //X3_TITSPA
	{ 'Desc Rel Flx'														, .F. }, ; //X3_TITENG
	{ 'Desc Relatorio Fluxo Sint'											, .F. }, ; //X3_DESCRIC
	{ 'Desc Relatorio Fluxo Sint'											, .F. }, ; //X3_DESCSPA
	{ 'Desc Relatorio Fluxo Sint'											, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SED'																	, .F. }, ; //X3_ARQUIVO
	{ '46'																	, .F. }, ; //X3_ORDEM
	{ 'ED_XCODMAS'														, .F. }, ; //X3_CAMPO  //ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 19																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Mascara'																, .F. }, ; //X3_TITULO
	{ 'Mascara'																, .F. }, ; //X3_TITSPA
	{ 'Mask'																, .F. }, ; //X3_TITENG
	{ 'Mascara'																, .F. }, ; //X3_DESCRIC
	{ 'Mascara'																, .F. }, ; //X3_DESCSPA
	{ 'Mask'																, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(128) + Chr(128)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'V'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SED'																	, .F. }, ; //X3_ARQUIVO
	{ '47'																	, .F. }, ; //X3_ORDEM
	{ 'ED_XUSAMAS'														, .F. }, ; //X3_CAMPO  //ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Usa Mascara?'														, .F. }, ; //X3_TITULO
	{ 'Usa Mascara?'														, .F. }, ; //X3_TITSPA
	{ 'Use Mask'															, .F. }, ; //X3_TITENG
	{ 'Natureza usa máscara?'												, .F. }, ; //X3_DESCRIC
	{ '¿Modalidad usa mascara?'												, .F. }, ; //X3_DESCSPA
	{ 'Class uses mask'														, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ 'Pertente("12")'														, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ '"1"'																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(128) + Chr(128)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ '1=Sim;1=Não'															, .F. }, ; //X3_CBOX
	{ '1=Si;1=No'															, .F. }, ; //X3_CBOXSPA
	{ '1=Yes;1=No'															, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ 'N'																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SED'																	, .F. }, ; //X3_ARQUIVO
	{ '67'																	, .F. }, ; //X3_ORDEM
	{ 'ED_XFLUXO'															, .F. }, ; //X3_CAMPO  //ALTERAR  - PADRAO ESP
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Gera Fluxo'															, .F. }, ; //X3_TITULO
	{ 'Gera Fluxo'															, .F. }, ; //X3_TITSPA
	{ 'Gera Fluxo'															, .F. }, ; //X3_TITENG
	{ 'Gera Fluxo'															, .F. }, ; //X3_DESCRIC
	{ 'Gera Fluxo'															, .F. }, ; //X3_DESCSPA
	{ 'Gera Fluxo'															, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ '"S"'																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ 'S=Sim;N=Nao'															, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

//
// Campos Tabela SEF
//
aAdd( aSX3, { ;
	{ 'SEF'																	, .F. }, ; //X3_ARQUIVO
	{ '40'																	, .F. }, ; //X3_ORDEM
	{ 'EF_XNUMAP'															, .F. }, ; //X3_CAMPO  //ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 6																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Aut.Pagto'															, .F. }, ; //X3_TITULO
	{ 'Aut.Pagto'															, .F. }, ; //X3_TITSPA
	{ 'Aut.Pagto'															, .F. }, ; //X3_TITENG
	{ 'Autorizacao Pagamento'												, .F. }, ; //X3_DESCRIC
	{ 'Autorizacao Pagamento'												, .F. }, ; //X3_DESCSPA
	{ 'Autorizacao Pagamento'												, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SEV
//
aAdd( aSX3, { ;
	{ 'SEV'																	, .F. }, ; //X3_ARQUIVO
	{ '17'																	, .F. }, ; //X3_ORDEM
	{ 'EV_XCOMPET'														, .F. }, ; //X3_CAMPO  //ALTERAR -  PADRAO ESP
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 7																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Competencia'															, .F. }, ; //X3_TITULO
	{ 'Competencia'															, .F. }, ; //X3_TITSPA
	{ 'Competencia'															, .F. }, ; //X3_TITENG
	{ 'Competencia'															, .F. }, ; //X3_DESCRIC
	{ 'Competencia'															, .F. }, ; //X3_DESCSPA
	{ 'Competencia'															, .F. }, ; //X3_DESCENG
	{ '99/9999'																, .F. }, ; //X3_PICTURE
	{ 'U_COMPET3()'															, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME


//
// Campos Tabela SF1
//
aAdd( aSX3, { ;
	{ 'SF1'																	, .F. }, ; //X3_ARQUIVO
	{ '06'																	, .F. }, ; //X3_ORDEM
	{ 'F1_XNOMFOR'														, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 60																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Nome Fornec.'														, .F. }, ; //X3_TITULO
	{ 'Nome Fornec.'														, .F. }, ; //X3_TITSPA
	{ 'Nome Fornec.'														, .F. }, ; //X3_TITENG
	{ 'Nome do Fornecedor'													, .F. }, ; //X3_DESCRIC
	{ 'Nome do Fornecedor'													, .F. }, ; //X3_DESCSPA
	{ 'Nome do Fornecedor'													, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'V'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ 'U_GetCpoVal("A2_NOME", 1, xFilial("SA2") + SF1->(F1_FORNECE + F1_LOJA), .F.)', .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SF1'																	, .F. }, ; //X3_ARQUIVO
	{ '66'																	, .F. }, ; //X3_ORDEM
	{ 'F1_XBASEIR'														, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 14																	, .F. }, ; //X3_TAMANHO
	{ 2																		, .F. }, ; //X3_DECIMAL
	{ 'Base do IR'															, .F. }, ; //X3_TITULO
	{ 'Base de IR'															, .F. }, ; //X3_TITSPA
	{ 'IT Basis'															, .F. }, ; //X3_TITENG
	{ 'Base de calculo do IR'												, .F. }, ; //X3_DESCRIC
	{ 'Base de calculo de IR'												, .F. }, ; //X3_DESCSPA
	{ 'IT Calculation Basis'												, .F. }, ; //X3_DESCENG
	{ '@E 99,999,999.99'													, .F. }, ; //X3_PICTURE
	{ 'MaFisRef("NF_BASEIRR","MT100",M->F1_BASEIR)'							, .F. }, ; //X3_VALID
	{ Chr(160) + Chr(160) + Chr(160) + Chr(160) + Chr(160) + ;
	Chr(160) + Chr(160) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(130) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(160) + Chr(128)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ ''																	, .F. }, ; //X3_VISUAL
	{ ''																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SF1'																	, .F. }, ; //X3_ARQUIVO
	{ '74'																	, .F. }, ; //X3_ORDEM
	{ 'F1_USERLGI'														, .F. }, ; //X3_CAMPO  // ALTERAR - PADRAO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 17																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Log de Inclu'														, .F. }, ; //X3_TITULO
	{ ''																	, .F. }, ; //X3_TITSPA
	{ ''																	, .F. }, ; //X3_TITENG
	{ 'Log de Inclusao'														, .F. }, ; //X3_DESCRIC
	{ ''																	, .F. }, ; //X3_DESCSPA
	{ ''																	, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 9																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'L'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SF1'																	, .F. }, ; //X3_ARQUIVO
	{ '75'																	, .F. }, ; //X3_ORDEM
	{ 'F1_USERLGA'														, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 17																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Log de Alter'														, .F. }, ; //X3_TITULO
	{ ''																	, .F. }, ; //X3_TITSPA
	{ ''																	, .F. }, ; //X3_TITENG
	{ 'Log de Alteracao'													, .F. }, ; //X3_DESCRIC
	{ ''																	, .F. }, ; //X3_DESCSPA
	{ ''																	, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 9																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'L'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SF1'																	, .F. }, ; //X3_ARQUIVO
	{ '81'																	, .F. }, ; //X3_ORDEM
	{ 'F1_XPROVEN'														, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 3																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Origem Imp.'															, .F. }, ; //X3_TITULO
	{ 'Origen Imp.'															, .F. }, ; //X3_TITSPA
	{ 'Imp. Origin'															, .F. }, ; //X3_TITENG
	{ 'Origem da Importacäo'												, .F. }, ; //X3_DESCRIC
	{ 'Origen de la Importacion'											, .F. }, ; //X3_DESCSPA
	{ 'Importing Origin'													, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(151) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ ''																	, .F. }, ; //X3_BROWSE
	{ ''																	, .F. }, ; //X3_VISUAL
	{ ''																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME

//
// Campos Tabela SF2
//
aAdd( aSX3, { ;
	{ 'SF2'																	, .F. }, ; //X3_ARQUIVO
	{ '05'																	, .F. }, ; //X3_ORDEM
	{ 'F2_XNOMCLI'														, .F. }, ; //X3_CAMPO  // ALTERAR - PADRAO ESP
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 40																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Nome'																, .F. }, ; //X3_TITULO
	{ 'Nome'																, .F. }, ; //X3_TITSPA
	{ 'Nome'																, .F. }, ; //X3_TITENG
	{ 'Nome CLiente'														, .F. }, ; //X3_DESCRIC
	{ 'Nome CLiente'														, .F. }, ; //X3_DESCSPA
	{ 'Nome CLiente'														, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 0																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'U'																	, .F. }, ; //X3_PROPRI
	{ 'S'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'V'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ 'Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_NOME")', .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ 'N'																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ 'N'																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SF4
//
aAdd( aSX3, { ;
	{ 'SF4'																	, .F. }, ; //X3_ARQUIVO
	{ '44'																	, .F. }, ; //X3_ORDEM
	{ 'F4_XTPMOV'															, .F. }, ; //X3_CAMPO  //ALTERAR
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 1																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Tipo Movim.'															, .F. }, ; //X3_TITULO
	{ 'Tipo Movim.'															, .F. }, ; //X3_TITSPA
	{ 'Movem.Type'															, .F. }, ; //X3_TITENG
	{ 'Tipo de Movimentacao'												, .F. }, ; //X3_DESCRIC
	{ 'Tipo de Movimiento'													, .F. }, ; //X3_DESCSPA
	{ 'Movement Type'														, .F. }, ; //X3_DESCENG
	{ '@!'																	, .F. }, ; //X3_PICTURE
	{ 'EXISTCPO("SX5","DJ"+M->F4_TPMOV)'									, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ 'DJ'																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(130) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ ''																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ '2'																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SF4'																	, .F. }, ; //X3_ARQUIVO
	{ '46'																	, .F. }, ; //X3_ORDEM
	{ 'F4_USERLGI'														, .F. }, ; //X3_CAMPO  // ALTERAR - PADRAO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 17																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Log de Inclu'														, .F. }, ; //X3_TITULO
	{ ''																	, .F. }, ; //X3_TITSPA
	{ ''																	, .F. }, ; //X3_TITENG
	{ 'Log de Inclusao'														, .F. }, ; //X3_DESCRIC
	{ ''																	, .F. }, ; //X3_DESCSPA
	{ ''																	, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 9																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'L'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

aAdd( aSX3, { ;
	{ 'SF4'																	, .F. }, ; //X3_ARQUIVO
	{ '47'																	, .F. }, ; //X3_ORDEM
	{ 'F4_USERLGA'														, .F. }, ; //X3_CAMPO  // ALTERAR - PADRAO
	{ 'C'																	, .F. }, ; //X3_TIPO
	{ 17																	, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Log de Alter'														, .F. }, ; //X3_TITULO
	{ ''																	, .F. }, ; //X3_TITSPA
	{ ''																	, .F. }, ; //X3_TITENG
	{ 'Log de Alteracao'													, .F. }, ; //X3_DESCRIC
	{ ''																	, .F. }, ; //X3_DESCSPA
	{ ''																	, .F. }, ; //X3_DESCENG
	{ ''																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 9																		, .F. }, ; //X3_NIVEL
	{ Chr(254) + Chr(192)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ 'L'																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'V'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ ''																	, .F. }} ) //X3_PYME

//
// Campos Tabela SF6
//
aAdd( aSX3, { ;
	{ 'SF6'																	, .F. }, ; //X3_ARQUIVO
	{ '31'																	, .F. }, ; //X3_ORDEM
	{ 'F6_XCODPRO'														, .F. }, ; //X3_CAMPO  // ALTERAR
	{ 'N'																	, .F. }, ; //X3_TIPO
	{ 2																		, .F. }, ; //X3_TAMANHO
	{ 0																		, .F. }, ; //X3_DECIMAL
	{ 'Produto'																, .F. }, ; //X3_TITULO
	{ 'Producto'															, .F. }, ; //X3_TITSPA
	{ 'Product'																, .F. }, ; //X3_TITENG
	{ 'Codigo do Produto'													, .F. }, ; //X3_DESCRIC
	{ 'Codigo de Producto'													, .F. }, ; //X3_DESCSPA
	{ 'Product Code'														, .F. }, ; //X3_DESCENG
	{ '99'																	, .F. }, ; //X3_PICTURE
	{ ''																	, .F. }, ; //X3_VALID
	{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, .F. }, ; //X3_USADO
	{ ''																	, .F. }, ; //X3_RELACAO
	{ ''																	, .F. }, ; //X3_F3
	{ 1																		, .F. }, ; //X3_NIVEL
	{ Chr(134) + Chr(128)													, .F. }, ; //X3_RESERV
	{ ''																	, .F. }, ; //X3_CHECK
	{ ''																	, .F. }, ; //X3_TRIGGER
	{ ''																	, .F. }, ; //X3_PROPRI
	{ 'N'																	, .F. }, ; //X3_BROWSE
	{ 'A'																	, .F. }, ; //X3_VISUAL
	{ 'R'																	, .F. }, ; //X3_CONTEXT
	{ ''																	, .F. }, ; //X3_OBRIGAT
	{ ''																	, .F. }, ; //X3_VLDUSER
	{ ''																	, .F. }, ; //X3_CBOX
	{ ''																	, .F. }, ; //X3_CBOXSPA
	{ ''																	, .F. }, ; //X3_CBOXENG
	{ ''																	, .F. }, ; //X3_PICTVAR
	{ ''																	, .F. }, ; //X3_WHEN
	{ ''																	, .F. }, ; //X3_INIBRW
	{ ''																	, .F. }, ; //X3_GRPSXG
	{ ''																	, .F. }, ; //X3_FOLDER
	{ ''																	, .F. }, ; //X3_CONDSQL
	{ ''																	, .F. }, ; //X3_CHKSQL
	{ ''																	, .F. }, ; //X3_IDXSRV
	{ ''																	, .F. }, ; //X3_ORTOGRA
	{ ''																	, .F. }, ; //X3_TELA
	{ ''																	, .F. }, ; //X3_IDXFLD
	{ ''																	, .F. }, ; //X3_AGRUP
	{ 'S'																	, .F. }} ) //X3_PYME



//
// Atualizando dicionário
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
				AutoGrLog( STR0061 + aSX3[nI][nPosCpo][1] + STR0062 + ; //"O tamanho do campo "###" NÃO atualizado e foi mantido em ["
				AllTrim( Str( SXG->XG_SIZE ) ) + "]" + CRLF + ;
				STR0063 + SXG->XG_GRUPO + "]" + CRLF ) //" por pertencer ao grupo de campos ["
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

		AutoGrLog( STR0064 + aSX3[nI][nPosCpo][1] ) //"Criado campo "

	Else

		//
		// Verifica se o campo faz parte de um grupo e ajsuta tamanho
		//
		If !Empty( SX3->X3_GRPSXG ) .AND. SX3->X3_GRPSXG <> aSX3[nI][nPosSXG][1]
			SXG->( dbSetOrder( 1 ) )
			If SXG->( MSSeek( SX3->X3_GRPSXG ) )
				If aSX3[nI][nPosTam][1] <> SXG->XG_SIZE
					aSX3[nI][nPosTam][1] := SXG->XG_SIZE
					AutoGrLog( STR0061 + aSX3[nI][nPosCpo][1] + STR0062 + ; //"O tamanho do campo "###" NÃO atualizado e foi mantido em ["
					AllTrim( Str( SXG->XG_SIZE ) ) + "]"+ CRLF + ;
					STR0063 + SX3->X3_GRPSXG + "]" + CRLF ) //"   por pertencer ao grupo de campos ["
				EndIf
			EndIf
		EndIf

		//
		// Verifica todos os campos
		//
		For nJ := 1 To Len( aSX3[nI] )

			If aSX3[nI][nJ][2]
				cX3Campo := AllTrim( aEstrut[nJ][1] )
				cX3Dado  := SX3->( FieldGet( aEstrut[nJ][2] ) )

				If  aEstrut[nJ][2] > 0 .AND. ;
					PadR( StrTran( AllToChar( cX3Dado ), " ", "" ), 250 ) <> ;
					PadR( StrTran( AllToChar( aSX3[nI][nJ][1] ), " ", "" ), 250 ) .AND. ;
					( cX3Campo <>  "X3_WHEN"    .OR. ( cX3Campo == "X3_WHEN"    .AND. Empty( cX3Dado ) ) ) .AND. ;
					!cX3Campo  == "X3_ORDEM"

					AutoGrLog( STR0079 + aSX3[nI][nPosCpo][1] + CRLF + ; //"Alterado campo "
					"   " + PadR( cX3Campo, 10 ) + STR0080 + AllToChar( cX3Dado ) + "]" + CRLF + ; //" de ["
					STR0081 + AllToChar( aSX3[nI][nJ][1] )           + "]" + CRLF ) //"            para ["

					RecLock( "SX3", .F. )
					FieldPut( FieldPos( aEstrut[nJ][1] ), aSX3[nI][nJ][1] )
					MsUnLock()
				EndIf
			EndIf
		Next

	EndIf

	oProcess:IncRegua2( STR0082 ) //"Atualizando Campos de Tabelas (SX3)..."

Next nI

AutoGrLog( CRLF + STR0060 + " SX3" + CRLF + Replicate( "-", 128 ) + CRLF ) //"Final da Atualização"

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

oDlg:cToolTip := STR0117 //"Tela para Múltiplas Seleções de Empresas/Filiais"

oDlg:cTitle   := STR0118 //"Selecione a(s) Empresa(s) para Atualização"

@ 10, 10 Listbox  oLbx Var  cVar Fields Header " ", " ", STR0119 Size 178, 095 Of oDlg Pixel //"Empresa"
oLbx:SetArray(  aVetor )
oLbx:bLine := {|| {IIf( aVetor[oLbx:nAt, 1], oOk, oNo ), ;
aVetor[oLbx:nAt, 2], ;
aVetor[oLbx:nAt, 4]}}
oLbx:BlDblClick := { || aVetor[oLbx:nAt, 1] := !aVetor[oLbx:nAt, 1], VerTodos( aVetor, @lChk, oChkMar ), oChkMar:Refresh(), oLbx:Refresh()}
oLbx:cToolTip   :=  oDlg:cTitle
oLbx:lHScroll   := .F. // NoScroll

@ 112, 10 CheckBox oChkMar Var  lChk Prompt STR0120 Message STR0121 Size 40, 007 Pixel Of oDlg; //"Todos"###"Marca / Desmarca"+ CRLF + "Todos"
on Click MarcaTodos( lChk, @aVetor, oLbx )

// Marca/Desmarca por mascara
@ 113, 51 Say   oSay Prompt STR0119 Size  40, 08 Of oDlg Pixel //"Empresa"
@ 112, 80 MSGet oMascEmp Var  cMascEmp Size  05, 05 Pixel Picture "@!"  Valid (  cMascEmp := StrTran( cMascEmp, " ", "?" ), oMascEmp:Refresh(), .T. ) ;
Message STR0124  Of oDlg //"Máscara Empresa ( ?? )"
oSay:cToolTip := oMascEmp:cToolTip

@ 128, 10 Button oButInv    Prompt STR0122  Size 32, 12 Pixel Action ( InvSelecao( @aVetor, oLbx, @lChk, oChkMar ), VerTodos( aVetor, @lChk, oChkMar ) ) ; //"&Inverter"
Message STR0123 Of oDlg //"Inverter Seleção"
oButInv:SetCss( CSSBOTAO )
@ 128, 50 Button oButMarc   Prompt STR0125    Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .T. ), VerTodos( aVetor, @lChk, oChkMar ) ) ; //"&Marcar"
Message STR0126    Of oDlg //"Marcar usando" + CRLF + "máscara ( ?? )"
oButMarc:SetCss( CSSBOTAO )
@ 128, 80 Button oButDMar   Prompt STR0127 Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .F. ), VerTodos( aVetor, @lChk, oChkMar ) ) ; //"&Desmarcar"
Message STR0128 Of oDlg //"Desmarcar usando" + CRLF + "máscara ( ?? )"
oButDMar:SetCss( CSSBOTAO )
@ 112, 157  Button oButOk   Prompt STR0147  Size 32, 12 Pixel Action (  RetSelecao( @aRet, aVetor ), oDlg:End()  ) ; //"Processar"
Message STR0145 Of oDlg //"Confirma a seleção e efetua" + CRLF + "o processamento"
oButOk:SetCss( CSSBOTAO )
@ 128, 157  Button oButCanc Prompt STR0148   Size 32, 12 Pixel Action ( IIf( lTeveMarc, aRet :=  aMarcadas, .T. ), oDlg:End() ) ; //"Cancelar"
Message STR0146 Of oDlg //"Cancela o processamento" + CRLF + "e abandona a aplicação"
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
@since  07/04/2015
@obs    Gerado por EXPORDIC - V.4.22.10.7 EFS / Upd. V.4.19.12 EFS
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
	MsgStop( STR0052 + ; //"Não foi possível a abertura da tabela "
	IIf( lShared, STR0053, STR0054 ), STR0022 ) //"de empresas (SM0)."###"de empresas (SM0) de forma exclusiva."###"ATENÇÃO"
EndIf

Return lOpen


//--------------------------------------------------------------------
/*/{Protheus.doc} LeLog
Função de leitura do LOG gerado com limitacao de string

@author TOTVS Protheus
@since  07/04/2015
@obs    Gerado por EXPORDIC - V.4.22.10.7 EFS / Upd. V.4.19.12 EFS
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



Return

