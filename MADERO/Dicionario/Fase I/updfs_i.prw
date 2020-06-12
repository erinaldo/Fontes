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
/*/{Protheus.doc} UPDFS_I
Função de update de dicionários para compatibilização

@author TOTVS Protheus
@since  22/05/2018
@obs    Gerado por EXPORDIC - V.5.4.1.2 EFS / Upd. V.4.21.17 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
User Function UPDFS_I( cEmpAmb, cFilAmb )

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

		If !FWAuthAdmin()
			Final( "Atualização não Realizada." )
		EndIf

		aMarcadas := EscEmpresa()
	EndIf

	If !Empty( aMarcadas )
		If lAuto .OR. MsgNoYes( "Confirma a atualização dos dicionários ?", cTitulo )
			oProcess := MsNewProcess():New( { | lEnd | lOk := FSTProc( @lEnd, aMarcadas, lAuto ) }, "Atualizando", "Aguarde, atualizando ...", .F. )
			oProcess:Activate()

			If lAuto
				If lOk
					MsgStop( "Atualização Realizada.", "UPDFS_I" )
				Else
					MsgStop( "Atualização não Realizada.", "UPDFS_I" )
				EndIf
				dbCloseAll()
			Else
				If lOk
					Final( "Atualização Realizada." )
				Else
					Final( "Atualização não Realizada." )
				EndIf
			EndIf

		Else
			Final( "Atualização não Realizada." )

		EndIf

	Else
		Final( "Atualização não Realizada." )

	EndIf

EndIf

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSTProc
Função de processamento da gravação dos arquivos

@author TOTVS Protheus
@since  22/05/2018
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


			oProcess:IncRegua1( "Dicionário de arquivos" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSX2()


			FSAtuSX3()


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


			oProcess:IncRegua1( "Dicionário de gatilhos" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSX7()


			oProcess:IncRegua1( "Dicionário de pastas" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSXA()


			oProcess:IncRegua1( "Dicionário de consultas padrão" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
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
@since  22/05/2018
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

aAdd( aSX2, {'Z10',cPath,'Z10'+cEmpr,'CONDICOES PGTO X UNIDADES DE N','CONDICOES PGTO X UNIDADES DE N','CONDICOES PGTO X UNIDADES DE N','E','','','','','','','','','','','E','E',0} )
aAdd( aSX2, {'Z11',cPath,'Z11'+cEmpr,'CLIENTES X UNIDADES DE NEGOCIO','CLIENTES X UNIDADES DE NEGOCIO','CLIENTES X UNIDADES DE NEGOCIO','E','','','','','','','','','','','E','E',0} )
aAdd( aSX2, {'Z13',cPath,'Z13'+cEmpr,'PRODUTOS X UNIDADES DE NEGOCIO','PRODUTOS X UNIDADES DE NEGOCIO','PRODUTOS X UNIDADES DE NEGOCIO','E','','','','','','','','','','','E','E',0} )
aAdd( aSX2, {'Z14',cPath,'Z14'+cEmpr,'ESTRUTURA X UNIDADES DE NEGOCI','ESTRUTURA X UNIDADES DE NEGOCI','ESTRUTURA X UNIDADES DE NEGOCI','E','','','','','','','','','','','E','E',0} )
aAdd( aSX2, {'Z15',cPath,'Z15'+cEmpr,'VENDEDORES X UNIDADES DE NEGOC','VENDEDORES X UNIDADES DE NEGOC','VENDEDORES X UNIDADES DE NEGOC','E','','','','','','','','','','','E','E',0} )
aAdd( aSX2, {'Z16',cPath,'Z16'+cEmpr,'IMPOSTOS X UNIDADES DE NEGOCIO','IMPOSTOS X UNIDADES DE NEGOCIO','IMPOSTOS X UNIDADES DE NEGOCIO','E','','','','','','','','','','','E','E',0} )
aAdd( aSX2, {'Z17',cPath,'Z17'+cEmpr,'ATIVACAO DE PRODUTOS','ATIVACAO DE PRODUTOS','ATIVACAO DE PRODUTOS','E','','','','','','','','','','','E','E',0} )
aAdd( aSX2, {'Z31',cPath,'Z31'+cEmpr,'CREDENCIADORAS DE CARTAO','CREDENCIADORAS DE CARTAO','CREDENCIADORAS DE CARTAO','C','','','','','','','','','','','C','C',0} )
aAdd( aSX2, {'ZWS',cPath,'ZWS'+cEmpr,'LOG DE INTEGRACAO','LOG DE INTEGRACAO','LOG DE INTEGRACAO','E','','','','','','','','','','','E','E',0} )
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
@since  22/05/2018
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

AutoGrLog( "Ínicio da Atualização" + " SX3" + CRLF )

aEstrut := { { "X3_ARQUIVO", 0 }, { "X3_ORDEM"  , 0 }, { "X3_CAMPO"  , 0 }, { "X3_TIPO"   , 0 }, { "X3_TAMANHO", 0 }, { "X3_DECIMAL", 0 }, { "X3_TITULO" , 0 }, ;
             { "X3_TITSPA" , 0 }, { "X3_TITENG" , 0 }, { "X3_DESCRIC", 0 }, { "X3_DESCSPA", 0 }, { "X3_DESCENG", 0 }, { "X3_PICTURE", 0 }, { "X3_VALID"  , 0 }, ;
             { "X3_USADO"  , 0 }, { "X3_RELACAO", 0 }, { "X3_F3"     , 0 }, { "X3_NIVEL"  , 0 }, { "X3_RESERV" , 0 }, { "X3_CHECK"  , 0 }, { "X3_TRIGGER", 0 }, ;
             { "X3_PROPRI" , 0 }, { "X3_BROWSE" , 0 }, { "X3_VISUAL" , 0 }, { "X3_CONTEXT", 0 }, { "X3_OBRIGAT", 0 }, { "X3_VLDUSER", 0 }, { "X3_CBOX"   , 0 }, ;
             { "X3_CBOXSPA", 0 }, { "X3_CBOXENG", 0 }, { "X3_PICTVAR", 0 }, { "X3_WHEN"   , 0 }, { "X3_INIBRW" , 0 }, { "X3_GRPSXG" , 0 }, { "X3_FOLDER" , 0 }, ;
             { "X3_CONDSQL", 0 }, { "X3_CHKSQL" , 0 }, { "X3_IDXSRV" , 0 }, { "X3_ORTOGRA", 0 }, { "X3_TELA"   , 0 }, { "X3_POSLGT" , 0 }, { "X3_IDXFLD" , 0 }, ;
             { "X3_AGRUP"  , 0 }, { "X3_MODAL"  , 0 }, { "X3_PYME"   , 0 } }

aEval( aEstrut, { |x| x[2] := SX3->( FieldPos( x[1] ) ) } )


aAdd( aSX3, {'ADK','32','ADK_XFILI','C',10,0,'Fil. Releac.','Fil. Releac.','Fil. Releac.','Fil. Releac.','Fil. Releac.','Fil. Releac.','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','SM0',0,Chr(254) + Chr(192),'','','U','S','A','R','','FWFilExist(,FWFldGet("ADK_XFILI"))','','','','','','','','2','','','','N','','','N','','',''} )
aAdd( aSX3, {'ADK','33','ADK_XSTINT','C',1,0,'St. Integra','St. Integra','St. Integra','St. Integra','St. Integra','St. Integra','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','P=Pendente;I=Integrado','P=Pendente;I=Integrado','P=Pendente;I=Integrado','','','','','2','','','','N','','','N','','',''} )
aAdd( aSX3, {'ADK','34','ADK_XDINT','D',8,0,'Ult. Integra','Ult. Integra','Ult. Integra','Ult. Integra','Ult. Integra','Ult. Integra','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','2','','','','N','','','N','','',''} )
aAdd( aSX3, {'ADK','35','ADK_XHINT','C',8,0,'Hr. Integra','Hr. Integra','Hr. Integra','Hr. Integra','Hr. Integra','Hr. Integra','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','2','','','','N','','','N','','',''} )
aAdd( aSX3, {'ADK','36','ADK_XEMP','C',2,0,'Cod. Empresa','Cod. Empresa','Cod. Empresa','Cod. Empresa','Cod. Empresa','Cod. Empresa','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','2','','','','N','','','N','','',''} )
aAdd( aSX3, {'ADK','37','ADK_XFIL','C',4,0,'Cod. Filial','Cod. Filial','Cod. Filial','Cod. Filial','Cod. Filial','Cod. Filial','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','2','','','','N','','','N','','',''} )
aAdd( aSX3, {'SA1','R3','A1_XFONE2','C',15,0,'Telefone 2','Telefone 2','Telefone 2','Telefone do Cliente 2','Telefone do Cliente 2','Telefone do Cliente 2','@R 999999999999999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'SA1','R4','A1_XCELULA','C',15,0,'Celular','Celular','Celular','Celular do Cliente','Celular do Cliente','Celular do Cliente','@R 999999999999999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'SAE','35','AE_XCOD','C',3,0,'Cond. Pgto','Cond. Pgto','Cond. Pgto','Cond. Pgto','Cond. Pgto','Cond. Pgto','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','SE4',0,Chr(254) + Chr(192),'','','U','S','A','R','','ExistCpo("SE4")','','','','','','','','1','','','','N','','','N','','',''} )
aAdd( aSX3, {'SAE','36','AE_XNTXADM','C',10,0,'Nat. Tx. Adm','Nat. Tx. Adm','Nat. Tx. Adm','Nat. Tx. Adm.','Nat. Tx. Adm.','Nat. Tx. Adm.','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','SED',0,Chr(254) + Chr(192),'','','U','S','A','R','','ExistCpo("SED")','','','','','','','','1','','','','N','','','N','','',''} )
aAdd( aSX3, {'SAE','37','AE_XCCRED','C',3,0,'Credenciador','Credenciador','Credenciador','Credenciadora','Credenciadora','Credenciadora','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','Z31',0,Chr(254) + Chr(192),'','','U','S','A','R','€','ExistCpo("Z31")','','','','','','','','1','','','','N','','','N','','',''} )
aAdd( aSX3, {'SE4','28','E4_XNATVDA','C',10,0,'Nat. Venda','Nat. Venda','Nat. Venda','Nat. Venda','Nat. Venda','Nat. Venda','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','SED',0,Chr(254) + Chr(192),'','','U','S','A','R','','ExistChav("SED",M->AE_XNATVDA,1,"EXISTNAT")','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z10','01','Z10_FILIAL','C',10,0,'Filial','Sucursal','Branch','Filial do Sistema','Sucursal','Branch of the System','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(254) + Chr(192),'','','U','N','','','','','','','','','','','033','','','','','','','','','','',''} )
aAdd( aSX3, {'Z10','02','Z10_CODIGO','C',3,0,'Codigo','Codigo','Codigo','Codigo','Codigo','Codigo','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','SE4',0,Chr(254) + Chr(192),'','S','U','S','A','R','€','ExistCpo("SE4")','','','','','INCLUI','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z10','03','Z10_DESC','C',40,0,'Desc. Cond.','Desc. Cond.','Desc. Cond.','Desc. Cond.','Desc. Cond.','Desc. Cond.','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z10','04','Z10_CODEXT','C',3,0,'Cod. Externo','Cod. Extern','Cod. Externo','Cod. Externo','Cod. Externo','Cod. Externo','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','INCLUI','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z10','05','Z10_DSEXT','C',15,0,'Des. Externa','Des. Externa','Des. Externa','Des. Externa','Des. Externa','Des. Externa','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z10','06','Z10_FORMA','C',2,0,'Forma Pgto','Forma Pgto','Forma Pgto','Forma Pgto','Forma Pgto','Forma Pgto','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','AV=A vista;CT=Cartao;CM=C. Madero;EV=Evento;CS=Consumidor;CP=C. Presente;OT=Outros','AV=A vista;CT=Cartao;CM=C. Madero;EV=Evento;CS=Consumidor;CP=C. Presente;OT=Outros','AV=A vista;CT=Cartao;CM=C. Madero;EV=Evento;CS=Consumidor;CP=C. Presente;OT=Outros','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z10','07','Z10_XEMP','C',2,0,'Emp. TEKNISA','Emp. TEKNISA','Emp. TEKNISA','Emp. TEKNISA','Emp. TEKNISA','Emp. TEKNISA','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z10','08','Z10_XFIL','C',4,0,'Fil. TEKNISA','Fil. TEKNISA','Fil. TEKNISA','Fil. TEKNISA','Fil. TEKNISA','Fil. TEKNISA','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z10','09','Z10_XSTINT','C',1,0,'St. Integra','St. Integra','St. Integra','St. Integra','St. Integra','St. Integra','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','P=Pendente;I=Integrado','P=Pendente;I=Integrado','P=Pendente;I=Integrado','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z10','10','Z10_XDINT','D',8,0,'Ult. Integra','Ult. Integra','Ult. Integra','Ult. Integra','Ult. Integra','Ult. Integra','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z10','11','Z10_XHINT','C',8,0,'Hr. Integra','Hr. Integra','Hr. Integra','Hr. Integra','Hr. Integra','Hr. Integra','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z10','12','Z10_XEXC','C',1,0,'Excluído?','Excluído?','Excluído?','Excluído?','Excluído?','Excluído?','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','S=Sim;N=Nao','S=Sim;N=Nao','S=Sim;N=Nao','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z10','13','Z10_XTPREC','C',1,0,'Tipo','Tipo','Tipo','Tipo da condicao de pagto','Tipo da condicao de pagto','Tipo da condicao de pagto','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z11','01','Z11_FILIAL','C',10,0,'Filial','Sucursal','Branch','Filial do Sistema','Sucursal','Branch of the System','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(254) + Chr(192),'','','U','N','','','','','','','','','','','033','','','','','','','','','','',''} )
aAdd( aSX3, {'Z11','02','Z11_COD','C',6,0,'Codigo','Codigo','Codigo','Codigo','Codigo','Codigo','','ExistCpo("SA1")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','SA1',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z11','03','Z11_LOJA','C',2,0,'Loja','Loja','Loja','Loja','Loja','Loja','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z11','04','Z11_DESC','C',60,0,'Nome','Nome','Nome','Nome','Nome','Nome','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z11','05','Z11_XCLIEN','C',21,0,'Cod Cliente','Cod Cliente','Cod Cliente','Cod Cliente','Cod Cliente','Cod Cliente','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z11','06','Z11_XCONSU','C',21,0,'Cod. Consumi','Cod. Consumi','Cod. Consumi','Cod. Consumidor','Cod. Consumidor','Cod. Consumidor','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z11','07','Z11_XEMP','C',2,0,'Emp Teknisa','Emp Teknisa','Emp Teknisa','Emp Teknisa','Emp Teknisa','Emp Teknisa','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','€','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z11','08','Z11_XFIL','C',4,0,'Fil. Teknisa','Fil. Teknisa','Fil. Teknisa','Fil. Teknisa','Fil. Teknisa','Fil. Teknisa','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','€','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z11','09','Z11_XSTINT','C',1,0,'St. Integra','St. Integra','St. Integra','St. Integra','St. Integra','St. Integra','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"P"','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','P=Pendente;I=Integrado','P=Pendente;I=Integrado','P=Pendente;I=Integrado','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z11','10','Z11_XDINT','D',8,0,'Ult. Integra','Ult. Integra','Ult. Integra','Ult. Integra','Ult. Integra','Ult. Integra','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z11','11','Z11_XHINT','C',8,0,'Hr. Integra','Hr. Integra','Hr. Integra','Hr. Integra','Hr. Integra','Hr. Integra','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z11','12','Z11_XEXC','C',1,0,'Excluído?','Excluído?','Excluído?','Excluído?','Excluído?','Excluído?','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"N"','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','S=Sm;N=Nao','S=Sm;N=Nao','S=Sm;N=Nao','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z13','01','Z13_FILIAL','C',10,0,'Filial','Sucursal','Branch','Filial do Sistema','Sucursal','Branch of the System','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(254) + Chr(192),'','','U','N','','','','','','','','','','','033','','','','','','','','','','',''} )
aAdd( aSX3, {'Z13','02','Z13_COD','C',15,0,'Cod. Produto','Cod. Produto','Cod. Produto','Cod. Produto','Cod. Produto','Cod. Produto','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','SB1',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','030','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z13','03','Z13_DESC','C',60,0,'Desc. Prod','Desc. Prod','Desc. Prod','Desc. Prod','Desc. Prod','Desc. Prod','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z13','04','Z13_XCODEX','C',20,0,'Cod. Externo','Cod. Externo','Cod. Externo','Cod. Externo','Cod. Externo','Cod. Externo','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z13','05','Z13_XCDARV','C',20,0,'Arv. Prod.','Arv. Prod.','Arv. Prod.','Arv. Prod.','Arv. Prod.','Arv. Prod.','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z13','06','Z13_XEMP','C',2,0,'Emp. TEKNISA','Emp. TEKNISA','Emp. TEKNISA','Emp. TEKNISA','Emp. TEKNISA','Emp. TEKNISA','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z13','07','Z13_XFIL','C',4,0,'Fil. TEKNISA','Fil. TEKNISA','Fil. TEKNISA','Fil. TEKNISA','Fil. TEKNISA','Fil. TEKNISA','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z13','08','Z13_XSTINT','C',1,0,'St. Integra','St. Integra','St. Integra','St. Integra','St. Integra','St. Integra','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','P=Pendente;I=Integrado','P=Pendente;I=Integrado','P=Pendente;I=Integrado','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z13','09','Z13_XDINT','D',8,0,'Ult. Integra','Ult. Integra','Ult. Integra','Ult. Integra','Ult. Integra','Ult. Integra','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z13','10','Z13_XHINT','C',8,0,'Hr. Integra','Hr. Integra','Hr. Integra','Hr. Integra','Hr. Integra','Hr. Integra','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z13','11','Z13_XEXC','C',1,0,'Excluído?','Excluído?','Excluído?','Excluído?','Excluído?','Excluído?','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"N"','',0,Chr(254) + Chr(192),'','','U','N','V','R','','','S=Sim;N=Nao','S=Sim;N=Nao','S=Sim;N=Nao','','','"N"','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z14','01','Z14_FILIAL','C',10,0,'Filial','Sucursal','Branch','Filial do Sistema','Sucursal','Branch of the System','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(254) + Chr(192),'','','U','N','','','','','','','','','','','033','','','','','','','','','','',''} )
aAdd( aSX3, {'Z14','02','Z14_COD','C',15,0,'Cod. Produto','Cod. Produto','Cod. Produto','Cod. Produto','Cod. Produto','Cod. Produto','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','SB1',0,Chr(254) + Chr(192),'','','U','S','A','R','','ExistCpo("SG1")','','','','','','','030','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z14','03','Z14_DESC','C',60,0,'Desc. Prod','Desc. Prod','Desc. Prod','Desc. Prod','Desc. Prod','Desc. Prod','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z14','04','Z14_XCODEX','C',20,0,'Prod. Extern','Prod. Extern','Prod. Extern','Prod. Externo','Prod. Externo','Prod. Externo','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z14','05','Z14_XEMP','C',2,0,'Emp. TEKNISA','Emp. TEKNISA','Emp. TEKNISA','Emp. TEKNISA','Emp. TEKNISA','Emp. TEKNISA','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z14','06','Z14_XFIL','C',4,0,'Fil. TEKNISA','Fil. TEKNISA','Fil. TEKNISA','Fil. TEKNISA','Fil. TEKNISA','Fil. TEKNISA','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z14','07','Z14_XSTINT','C',1,0,'St. Integra','St. Integra','St. Integra','St. Integra','St. Integra','St. Integra','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"P"','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','P=Pendente;I=Integrado','P=Pendente;I=Integrado','P=Pendente;I=Integrado','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z14','08','Z14_XDINT','D',8,0,'Ult. Integra','Ult. Integra','Ult. Integra','Ult. Integra','Ult. Integra','Ult. Integra','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z14','09','Z14_XHINT','C',8,0,'Hr. Integra','Hr. Integra','Hr. Integra','Hr. Integra','Hr. Integra','Hr. Integra','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z14','10','Z14_XEXC','C',1,0,'Excluído?','Excluído?','Excluído?','Excluído?','Excluído?','Excluído?','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"N"','',0,Chr(254) + Chr(192),'','','U','N','V','R','','','S=Sim;N=Nao','S=Sim;N=Nao','S=Sim;N=Nao','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z15','01','Z15_FILIAL','C',10,0,'Filial','Sucursal','Branch','Filial do Sistema','Sucursal','Branch of the System','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(254) + Chr(192),'','','U','N','','','','','','','','','','','033','','','','','','','','','','',''} )
aAdd( aSX3, {'Z15','02','Z15_COD','C',6,0,'Cod. Vend.','Cod. Vend.','Cod. Vend.','Cod. Vendedor','Cod. Vendedor','Cod. Vendedor','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','SA3',0,Chr(254) + Chr(192),'','','U','S','A','R','','ExistCpo("SA3")','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z15','03','Z15_XVEND','C',4,0,'Cod. Externo','Cod. Externo','Cod. Externo','Cod. Externo','Cod. Externo','Cod. Externo','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z15','04','Z15_XEMP','C',2,0,'Emp. Teknisa','Emp. Teknisa','Emp. Teknisa','Emp. Teknisa','Emp. Teknisa','Emp. Teknisa','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z15','05','Z15_XFIL','C',4,0,'Fil. TEKNISA','Fil. TEKNISA','Fil. TEKNISA','Fil. TEKNISA','Fil. TEKNISA','Fil. TEKNISA','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z15','06','Z15_XSTINT','C',1,0,'St. Integra','St. Integra','St. Integra','St. Integra','St. Integra','St. Integra','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','P=Pendente;I=Integrado','P=Pendente;I=Integrado','P=Pendente;I=Integrado','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z15','07','Z15_XDINT','D',8,0,'Ult. Integra','Ult. Integra','Ult. Integra','Ult. Integra','Ult. Integra','Ult. Integra','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z15','08','Z15_XHINT','C',8,0,'Hr. Integra','Hr. Integra','Hr. Integra','Hr. Integra','Hr. Integra','Hr. Integra','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z15','09','Z15_XEXC','C',1,0,'Excluído?','Excluído?','Excluído?','Excluído?','Excluído?','Excluído?','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"N"','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','S=Sim;N=Nao','S=Sim;N=Nao','S=Sim;N=Nao','','','"N"','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z16','01','Z16_FILIAL','C',10,0,'Filial','Sucursal','Branch','Filial do Sistema','Sucursal','Branch of the System','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(254) + Chr(192),'','','U','N','','','','','','','','','','','033','','','','','','','','','','',''} )
aAdd( aSX3, {'Z16','02','Z16_GRPTRI','C',6,0,'Cod. Tributa','Cod. Tributa','Cod. Tributa','Cod. Tributação','Cod. Tributação','Cod. Tributação','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','21',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z16','03','Z16_DESC','C',60,0,'Desc. Grupo','Desc. Grupo','Desc. Grupo','Desc. Grupo','Desc. Grupo','Desc. Grupo','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z16','04','Z16_COD','C',15,0,'Produto','Produto','Produto','Código do Produto','Código do Produto','Código do Produto','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','SB1',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z16','05','Z16_XEMP','C',2,0,'Emp. TEKNISA','Emp. TEKNISA','Emp. TEKNISA','Emp. TEKNISA','Emp. TEKNISA','Emp. TEKNISA','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z16','06','Z16_XFIL','C',4,0,'Fil. TEKNISA','Fil. TEKNISA','Fil. TEKNISA','Fil. TEKNISA','Fil. TEKNISA','Fil. TEKNISA','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z16','07','Z16_XSTINT','C',1,0,'St. Integra','St. Integra','St. Integra','St. Integra','St. Integra','St. Integra','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z16','08','Z16_XDINT','D',8,0,'Ult. Integra','Ult. Integra','Ult. Integra','Ult. Integra','Ult. Integra','Ult. Integra','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z16','09','Z16_XHINT','C',8,0,'Hr. Integra','Hr. Integra','Hr. Integra','Hr. Integra','Hr. Integra','Hr. Integra','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z16','10','Z16_XEXC','C',1,0,'Excluído?','Excluído?','Excluído?','Excluído?','Excluído?','Excluído?','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"N"','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','S=Sim;N=Nao','S=Sim;N=Nao','S=Sim;N=Nao','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z16','11','Z16_XATIVO','C',1,0,'Impos.Ativo?','Impos.Ativo?','Impos.Ativo?','Imposto Ativo?','Imposto Ativo?','Imposto Ativo?','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"S"','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','S=Sim;N=Nao','S=Sim;N=Nao','S=Sim;N=Nao','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z17','01','Z17_FILIAL','C',10,0,'Filial','Sucursal','Branch','Filial do Sistema','Sucursal','Branch of the System','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(254) + Chr(192),'','','U','N','','','','','','','','','','','033','','','','','','','','','','',''} )
aAdd( aSX3, {'Z17','02','Z17_COD','C',15,0,'Cod. Produto','Cod. Produto','Cod. Produto','Codigo so Produto','Codigo so Produto','Codigo so Produto','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','SB1',0,Chr(254) + Chr(192),'','','U','N','A','R','','ExistCpo("SB1")','','','','','','','030','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z17','03','Z17_XSTINT','C',1,0,'St. Integra','St. Integra','St. Integra','Status integracao Teknisa','Status integracao Teknisa','Status integracao Teknisa','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"P"','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','P=Pendente;I=Integrado','P=Pendente;I=Integrado','P=Pendente;I=Integrado','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z17','04','Z17_XDINT','D',8,0,'Ult. Integra','Ult. Integra','Ult. Integra','Data ult.integr.Teknisa','Data ult.integr.Teknisa','Data ult.integr.Teknisa','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z17','05','Z17_XHINT','C',8,0,'Hr. Integra','Hr. Integra','Hr. Integra','Hora ult.intgr. Telnisa','Hora ult.intgr. Telnisa','Hora ult.intgr. Telnisa','99:99:99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z17','06','Z17_XCODEX','C',20,0,'Cod. Externo','Cod. Externo','Cod. Externo','Codigo externo do produto','Codigo externo do produto','Codigo externo do produto','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z17','07','Z17_XCDARV','C',20,0,'Arv. Prod.','Arv. Prod.','Arv. Prod.','Cod. Arv. Produto','Cod. Arv. Produto','Cod. Arv. Produto','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z17','08','Z17_XEMP','C',2,0,'Emp. Teknisa','Emp. Teknisa','Emp. Teknisa','Emp. Teknisa','Emp. Teknisa','Emp. Teknisa','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z17','09','Z17_XFIL','C',4,0,'Fili.Teknisa','Fili.Teknisa','Fili.Teknisa','Cod Filial Teknisa','Cod Filial Teknisa','Cod Filial Teknisa','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z17','10','Z17_XATIVO','C',1,0,'Ativo?','Ativo?','Ativo?','Ativo?','Ativo?','Ativo?','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z31','01','Z31_FILIAL','C',10,0,'Filial','Sucursal','Branch','Filial do Sistema','Sucursal','Branch of the System','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(254) + Chr(192),'','','U','N','','','','','','','','','','','033','','','','','','','','','','',''} )
aAdd( aSX3, {'Z31','02','Z31_CODIGO','C',3,0,'Codigo','Codigo','Codigo','Codigo','Codigo','Codigo','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','€','ExistChav("Z31",M->Z31_CODIGO,1,"EXISTCRE")','','','','','inclui','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z31','03','Z31_NOME','C',40,0,'Nome','Nome','Nome','Nome','Nome','Nome','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','€','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z31','04','Z31_CNPJ','C',14,0,'CNPJ','CNPJ','CNPJ','CNPJ','CNPJ','CNPJ','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','€','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'ZWS','01','ZWS_FILIAL','C',10,0,'Filial','Sucursal','Branch','Filial do Sistema','Sucursal','Branch of the System','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(254) + Chr(192),'','','U','N','','','','','','','','','','','033','','','','','','','','','','',''} )
aAdd( aSX3, {'ZWS','02','ZWS_PROCES','C',60,0,'Processo','Processo','Processo','Processo','Processo','Processo','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','€','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'ZWS','03','ZWS_NINT','N',12,0,'Interações','Interações','Interações','Interações','Interações','Interações','@E 999,999,999,999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'ZWS','04','ZWS_STATUS','C',1,0,'Status','Status','Status','Status','Status','Status','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','E=Erro;A=Aguardando;I=Integrado','E=Erro;A=Aguardando;I=Integrado','E=Erro;A=Aguardando;I=Integrado','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'ZWS','05','ZWS_DTINT','D',8,0,'Ult. Integra','Ult. Integra','Ult. Integra','Ult. Integra','Ult. Integra','Ult. Integra','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'ZWS','06','ZWS_HRINT','C',8,0,'Hr. Integra','Hr. Integra','Hr. Integra','Hr. Integra','Hr. Integra','Hr. Integra','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'ZWS','07','ZWS_INF','C',100,0,'Inf. Process','Inf. Process','Inf. Process','Inf. Processo','Inf. Processo','Inf. Processo','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'ZWS','08','ZWS_XMLE','M',10,0,'XML Enviado','XML Enviado','XML Enviado','XML Enviado','XML Enviado','XML Enviado','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'ZWS','09','ZWS_XMLR','M',10,0,'XML Retorno','XML Retorno','XML Retorno','XML Retorno','XML Retorno','XML Retorno','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'ZWS','10','ZWS_ITENV','N',12,0,'Enviados','Enviados','Enviados','Enviados','Enviados','Enviados','@E 999,999,999,999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'ZWS','11','ZWS_ITCONF','N',12,0,'Conformados','Conformados','Conformados','Conformados','Conformados','Conformados','@E 999,999,999,999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'ZWS','12','ZWS_ERROR','M',10,0,'Error','Error','Error','Error','Error','Error','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )

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
@since  22/05/2018
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

AutoGrLog( "Ínicio da Atualização" + " SIX" + CRLF )

aEstrut := { "INDICE" , "ORDEM" , "CHAVE", "DESCRICAO", "DESCSPA"  , ;
             "DESCENG", "PROPRI", "F3"   , "NICKNAME" , "SHOWPESQ" }

aAdd( aSIX, {'ADK','5','ADK_FILIAL+ADK_XFILI','Fil. Releac.','Fil. Releac.','Fil. Releac.','U','','ADKXFILI','S'} )
aAdd( aSIX, {'Z10','1','Z10_FILIAL+Z10_CODIGO','Codigo','Codigo','Codigo','U','','','S'} )
aAdd( aSIX, {'Z10','2','Z10_FILIAL+Z10_XEMP+Z10_XFIL+Z10_CODEXT','Emp. TEKNISA+Fil. TEKNISA+Cod. Externo','Emp. TEKNISA+Fil. TEKNISA+ Cod. Extern','Emp. TEKNISA+Fil. TEKNISA+ Cod. Extern','U','','','S'} )
aAdd( aSIX, {'Z11','1','Z11_FILIAL+Z11_COD+Z11_LOJA','Codigo+Loja','Codigo+Loja','Codigo+Loja','U','','','S'} )
aAdd( aSIX, {'Z11','2','Z11_FILIAL+Z11_XEMP+Z11_XFIL+Z11_XCLIEN+Z11_XCONSU','Emp Teknisa+Fil. Teknisa+Cod Cliente+Cod. Consumi','Emp Teknisa+Fil. Teknisa+Cod Cliente+Cod. Consumi','Emp Teknisa+Fil. Teknisa+Cod Cliente+Cod. Consumi','U','','','S'} )
aAdd( aSIX, {'Z13','1','Z13_FILIAL+Z13_COD','Cod. Produto','Cod. Produto','Cod. Produto','U','','','S'} )
aAdd( aSIX, {'Z13','2','Z13_FILIAL+Z13_XEMP+Z13_XFIL+Z13_XCODEX','Emp. TEKNISA+Fil. TEKNISA+Cod. Externo','Emp. TEKNISA+Fil. TEKNISA+Cod. Externo','Emp. TEKNISA+Fil. TEKNISA+Cod. Externo','U','','','S'} )
aAdd( aSIX, {'Z13','3','Z13_XDINT+Z13_XHINT','Ult. Integra+Hr. Integra','Ult. Integra+Hr. Integra','Ult. Integra+Hr. Integra','U','','','S'} )
aAdd( aSIX, {'Z14','1','Z14_FILIAL+Z14_COD','Cod. Produto','Cod. Produto','Cod. Produto','U','','','S'} )
aAdd( aSIX, {'Z14','2','Z14_FILIAL+Z14_XEMP+Z14_XFIL+Z14_XCODEX','Emp. TEKNISA+Fil. TEKNISA+Prod. Extern','Emp. TEKNISA+Fil. TEKNISA+Prod. Extern','Emp. TEKNISA+Fil. TEKNISA+Prod. Extern','U','','','S'} )
aAdd( aSIX, {'Z15','1','Z15_FILIAL+Z15_COD','Cod. Vend.','Cod. Vend.','Cod. Vend.','U','','','S'} )
aAdd( aSIX, {'Z15','2','Z15_FILIAL+Z15_XEMP+Z15_XFIL+Z15_XVEND','Emp. Teknisa+Fil. TEKNISA+Cod. Externo','Emp. Teknisa+Fil. TEKNISA+Cod. Externo','Emp. Teknisa+Fil. TEKNISA+Cod. Externo','U','','','S'} )
aAdd( aSIX, {'Z16','1','Z16_FILIAL+Z16_GRPTRI+Z16_COD','Cod. Tributa+Produto','Cod. Tributa+Produto','Cod. Tributa+Produto','U','','','S'} )
aAdd( aSIX, {'Z16','2','Z16_FILIAL+Z16_COD','Produto','Produto','Produto','U','','','S'} )
aAdd( aSIX, {'Z17','1','Z17_FILIAL+Z17_COD','Cod. Produto','Cod. Produto','Cod. Produto','U','','','S'} )
aAdd( aSIX, {'Z31','1','Z31_FILIAL+Z31_CODIGO','Codigo','Codigo','Codigo','U','','','S'} )
aAdd( aSIX, {'Z31','2','Z31_FILIAL+Z31_NOME','Nome','Nome','Nome','U','','','S'} )
aAdd( aSIX, {'Z31','3','Z31_FILIAL+Z31_CNPJ','CNPJ','CNPJ','CNPJ','U','','','S'} )
aAdd( aSIX, {'ZWS','1','ZWS_FILIAL+ZWS_PROCES+DTOS(ZWS_DTINT)','Processo+Ult. Integra','Processo+Ult. Integra','Processo+Data','U','','','S'} )
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
/*/{Protheus.doc} FSAtuSX7
Função de processamento da gravação do SX7 - Gatilhos

@author TOTVS Protheus
@since  22/05/2018
@obs    Gerado por EXPORDIC - V.5.4.1.2 EFS / Upd. V.4.21.17 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSX7()
Local aEstrut   := {}
Local aAreaSX3  := SX3->( GetArea() )
Local aSX7      := {}
Local cAlias    := ""
Local nI        := 0
Local nJ        := 0
Local nTamSeek  := Len( SX7->X7_CAMPO )

AutoGrLog( "Ínicio da Atualização" + " SX7" + CRLF )

aEstrut := { "X7_CAMPO", "X7_SEQUENC", "X7_REGRA", "X7_CDOMIN", "X7_TIPO", "X7_SEEK", ;
             "X7_ALIAS", "X7_ORDEM"  , "X7_CHAVE", "X7_PROPRI", "X7_CONDIC" }

aAdd( aSX7, {'Z10_CODIGO','001','Posicione("SE4",1,xFilial("SE4")+M->Z10_CODIGO,"E4_DESCRI")','Z10_DESC','P','N','',0,'','U',''} )
//
// Atualizando dicionário
//
oProcess:SetRegua2( Len( aSX7 ) )

dbSelectArea( "SX3" )
dbSetOrder( 2 )

dbSelectArea( "SX7" )
dbSetOrder( 1 )

For nI := 1 To Len( aSX7 )

	If !SX7->( dbSeek( PadR( aSX7[nI][1], nTamSeek ) + aSX7[nI][2] ) )

		If !( aSX7[nI][1] $ cAlias )
			cAlias += aSX7[nI][1] + "/"
			AutoGrLog( "Foi incluído o gatilho " + aSX7[nI][1] + "/" + aSX7[nI][2] )
		EndIf

		RecLock( "SX7", .T. )
		For nJ := 1 To Len( aSX7[nI] )
			If FieldPos( aEstrut[nJ] ) > 0
				FieldPut( FieldPos( aEstrut[nJ] ), aSX7[nI][nJ] )
			EndIf
		Next nJ

		dbCommit()
		MsUnLock()

		If SX3->( dbSeek( SX7->X7_CAMPO ) )
			RecLock( "SX3", .F. )
			SX3->X3_TRIGGER := "S"
			MsUnLock()
		EndIf

	EndIf
	oProcess:IncRegua2( "Atualizando Arquivos (SX7)..." )

Next nI

RestArea( aAreaSX3 )

AutoGrLog( CRLF + "Final da Atualização" + " SX7" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSXA
Função de processamento da gravação do SXA - Pastas

@author TOTVS Protheus
@since  22/05/2018
@obs    Gerado por EXPORDIC - V.5.4.1.2 EFS / Upd. V.4.21.17 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSXA()
Local aEstrut   := {}
Local aSXA      := {}
Local cAlias    := ""
Local nI        := 0
Local nJ        := 0
Local nPosAgr   := 0
Local lAlterou  := .F.

AutoGrLog( "Ínicio da Atualização" + " SXA" + CRLF )

aEstrut := { "XA_ALIAS"  , "XA_ORDEM"  , "XA_DESCRIC", "XA_DESCSPA", "XA_DESCENG", "XA_AGRUP"  , "XA_TIPO"   , ;
             "XA_PROPRI" }


aAdd( aSXA, {'ADK','1','Cadastral','Cadastral','Cadastral','','','U'} )
aAdd( aSXA, {'ADK','2','Unidades de Negocio','Unidades de Negocio','Unidades de Negocio','','','U'} )
aAdd( aSXA, {'SAE','1','Cadastrais','Cadastrais','Cadastrais','','','U'} )
nPosAgr := aScan( aEstrut, { |x| AllTrim( x ) == "XA_AGRUP" } )

//
// Atualizando dicionário
//
oProcess:SetRegua2( Len( aSXA ) )

dbSelectArea( "SXA" )
dbSetOrder( 1 )

For nI := 1 To Len( aSXA )

	If SXA->( dbSeek( aSXA[nI][1] + aSXA[nI][2] ) )

		lAlterou := .F.

		While !SXA->( EOF() ).AND.  SXA->( XA_ALIAS + XA_ORDEM ) == aSXA[nI][1] + aSXA[nI][2]

			If SXA->XA_AGRUP == aSXA[nI][nPosAgr]
				RecLock( "SXA", .F. )
				For nJ := 1 To Len( aSXA[nI] )
					If FieldPos( aEstrut[nJ] ) > 0 .AND. Alltrim(AllToChar(SXA->( FieldGet( nJ ) ))) <> Alltrim(AllToChar(aSXA[nI][nJ]))
						FieldPut( FieldPos( aEstrut[nJ] ), aSXA[nI][nJ] )
						lAlterou := .T.
					EndIf
				Next nJ
				dbCommit()
				MsUnLock()
			EndIf

			SXA->( dbSkip() )

		End

		If lAlterou
			AutoGrLog( "Foi alterada a pasta " + aSXA[nI][1] + "/" + aSXA[nI][2] + "  " + aSXA[nI][3] )
		EndIf

	Else

		RecLock( "SXA", .T. )
		For nJ := 1 To Len( aSXA[nI] )
			If FieldPos( aEstrut[nJ] ) > 0
				FieldPut( FieldPos( aEstrut[nJ] ), aSXA[nI][nJ] )
			EndIf
		Next nJ
		dbCommit()
		MsUnLock()

		AutoGrLog( "Foi incluída a pasta " + aSXA[nI][1] + "/" + aSXA[nI][2] + "  " + aSXA[nI][3] )

	EndIf

oProcess:IncRegua2( "Atualizando Arquivos (SXA)..." )

Next nI

AutoGrLog( CRLF + "Final da Atualização" + " SXA" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSXB
Função de processamento da gravação do SXB - Consultas Padrao

@author TOTVS Protheus
@since  22/05/2018
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

AutoGrLog( "Ínicio da Atualização" + " SXB" + CRLF )

aEstrut := { "XB_ALIAS"  , "XB_TIPO"   , "XB_SEQ"    , "XB_COLUNA" , "XB_DESCRI" , "XB_DESCSPA", "XB_DESCENG", ;
             "XB_WCONTEM", "XB_CONTEM" }


aAdd( aSXB, {'SA1','1','01','DB','Cliente','Cliente','Customer','','SA1'} )
aAdd( aSXB, {'SA1','2','01','01','Codigo','Código','Code','',''} )
aAdd( aSXB, {'SA1','2','02','02','Nome','Nombre','Name','',''} )
aAdd( aSXB, {'SA1','2','03','03','CNPJ/CPF','CNPJ/CPF','CNPJ/CPF','',''} )
aAdd( aSXB, {'SA1','3','01','01','Cadastra Novo','Incluye Nuevo','Add New','','01#A030INCLUI#A030VISUAL'} )
aAdd( aSXB, {'SA1','4','01','01','Codigo','Código','Code','','A1_COD'} )
aAdd( aSXB, {'SA1','4','01','02','Loja','Tienda','Store','','A1_LOJA'} )
aAdd( aSXB, {'SA1','4','01','03','Nome','Nombre','Name','','A1_NOME'} )
aAdd( aSXB, {'SA1','4','02','04','Codigo','Código','Code','','A1_COD'} )
aAdd( aSXB, {'SA1','4','02','05','Loja','Tienda','Store','','A1_LOJA'} )
aAdd( aSXB, {'SA1','4','02','06','Nome','Nombre','Name','','A1_NOME'} )
aAdd( aSXB, {'SA1','4','03','07','CNPJ/CPF','CNPJ/CPF','CNPJ/CPF','','A1_CGC'} )
aAdd( aSXB, {'SA1','4','03','08','Nome','Nombre','Name','','A1_NOME'} )
aAdd( aSXB, {'SA1','5','01','','','','','','SA1->A1_COD'} )
aAdd( aSXB, {'SA1','5','02','','','','','','SA1->A1_LOJA'} )
aAdd( aSXB, {'SA1','6','01','','','','','','#CRMXFilSXB("SA1")'} )
aAdd( aSXB, {'SE4','1','01','DB','Cond. de Pagamento','Cond. de pago','Payment Term','','SE4'} )
aAdd( aSXB, {'SE4','2','01','01','Código','Código','Code','',''} )
aAdd( aSXB, {'SE4','2','02','02','Descrição + Código','Descripción + Código','Description + Code','',''} )
aAdd( aSXB, {'SE4','3','01','01','Cadastra Novo','Incluye Nuevo','Add New','','01#A360F3(3)#A360F3(1)'} )
aAdd( aSXB, {'SE4','4','01','01','Tipo','Tipo','Type','','E4_TIPO'} )
aAdd( aSXB, {'SE4','4','01','02','Condição','Condición','Term','','E4_DESCRI'} )
aAdd( aSXB, {'SE4','4','01','03','Código','Código','Code','','E4_CODIGO'} )
aAdd( aSXB, {'SE4','4','02','04','Tipo','Tipo','Type','','E4_TIPO'} )
aAdd( aSXB, {'SE4','4','02','05','Condição','Condición','Term','','E4_DESCRI'} )
aAdd( aSXB, {'SE4','4','02','06','Código','Código','Code','','E4_CODIGO'} )
aAdd( aSXB, {'SE4','5','01','','','','','','SE4->E4_CODIGO'} )
aAdd( aSXB, {'SE4','6','01','','','','','','J070F3GRUPO()'} )
aAdd( aSXB, {'Z31','1','01','DB','CRED DE CARTAO','CRED DE CARTAO','CRED DE CARTAO','','Z31'} )
aAdd( aSXB, {'Z31','2','01','01','Codigo','Codigo','Codigo','',''} )
aAdd( aSXB, {'Z31','2','02','02','Nome','Nome','Nome','',''} )
aAdd( aSXB, {'Z31','2','03','03','Cnpj','Cnpj','Cnpj','',''} )
aAdd( aSXB, {'Z31','3','01','01','Cadastra Novo','Incluye Nuevo','Add New','','01'} )
aAdd( aSXB, {'Z31','4','01','01','Codigo','Codigo','Codigo','','Z31_CODIGO'} )
aAdd( aSXB, {'Z31','4','01','02','Nome','Nome','Nome','','Z31_NOME'} )
aAdd( aSXB, {'Z31','4','01','03','CNPJ','CNPJ','CNPJ','','Z31_CNPJ'} )
aAdd( aSXB, {'Z31','4','02','01','Nome','Nome','Nome','','Z31_NOME'} )
aAdd( aSXB, {'Z31','4','02','02','Codigo','Codigo','Codigo','','Z31_CODIGO'} )
aAdd( aSXB, {'Z31','4','02','03','CNPJ','CNPJ','CNPJ','','Z31_CNPJ'} )
aAdd( aSXB, {'Z31','4','03','01','CNPJ','CNPJ','CNPJ','','Z31_CNPJ'} )
aAdd( aSXB, {'Z31','4','03','02','Nome','Nome','Nome','','Z31_NOME'} )
aAdd( aSXB, {'Z31','4','03','03','Codigo','Codigo','Codigo','','Z31_CODIGO'} )
aAdd( aSXB, {'Z31','5','01','','','','','','Z31->Z31_CODIGO'} )
//
// Atualizando dicionário
//
oProcess:SetRegua2( Len( aSXB ) )

dbSelectArea( "SXB" )
dbSetOrder( 1 )

For nI := 1 To Len( aSXB )

	If !Empty( aSXB[nI][1] )

		If !SXB->( dbSeek( PadR( aSXB[nI][1], Len( SXB->XB_ALIAS ) ) + aSXB[nI][2] + aSXB[nI][3] + aSXB[nI][4] ) )

			If !( aSXB[nI][1] $ cAlias )
				cAlias += aSXB[nI][1] + "/"
				AutoGrLog( "Foi incluída a consulta padrão " + aSXB[nI][1] )
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

					cMsg := "A consulta padrão " + aSXB[nI][1] + " está com o " + SXB->( FieldName( nJ ) ) + ;
					" com o conteúdo" + CRLF + ;
					"[" + RTrim( AllToChar( SXB->( FieldGet( nJ ) ) ) ) + "]" + CRLF + ;
					", e este é diferente do conteúdo" + CRLF + ;
					"[" + RTrim( AllToChar( aSXB[nI][nJ] ) ) + "]" + CRLF +;
					"Deseja substituir ? "

					If      lTodosSim
						nOpcA := 1
					ElseIf  lTodosNao
						nOpcA := 2
					Else
						nOpcA := Aviso( "ATUALIZAÇÃO DE DICIONÁRIOS E TABELAS", cMsg, { "Sim", "Não", "Sim p/Todos", "Não p/Todos" }, 3, "Diferença de conteúdo - SXB" )
						lTodosSim := ( nOpcA == 3 )
						lTodosNao := ( nOpcA == 4 )

						If lTodosSim
							nOpcA := 1
							lTodosSim := MsgNoYes( "Foi selecionada a opção de REALIZAR TODAS alterações no SXB e NÃO MOSTRAR mais a tela de aviso." + CRLF + "Confirma a ação [Sim p/Todos] ?" )
						EndIf

						If lTodosNao
							nOpcA := 2
							lTodosNao := MsgNoYes( "Foi selecionada a opção de NÃO REALIZAR nenhuma alteração no SXB que esteja diferente da base e NÃO MOSTRAR mais a tela de aviso." + CRLF + "Confirma esta ação [Não p/Todos]?" )
						EndIf

					EndIf

					If nOpcA == 1
						RecLock( "SXB", .F. )
						FieldPut( FieldPos( aEstrut[nJ] ), aSXB[nI][nJ] )
						dbCommit()
						MsUnLock()

							If !( aSXB[nI][1] $ cAlias )
								cAlias += aSXB[nI][1] + "/"
								AutoGrLog( "Foi alterada a consulta padrão " + aSXB[nI][1] )
							EndIf

					EndIf

				EndIf

			Next

		EndIf

	EndIf

	oProcess:IncRegua2( "Atualizando Consultas Padrões (SXB)..." )

Next nI

AutoGrLog( CRLF + "Final da Atualização" + " SXB" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuHlp
Função de processamento da gravação dos Helps de Campos

@author TOTVS Protheus
@since  22/05/2018
@obs    Gerado por EXPORDIC - V.5.4.1.2 EFS / Upd. V.4.21.17 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuHlp()
Local aHlpPor   := {}
Local aHlpEng   := {}
Local aHlpSpa   := {}

AutoGrLog( "Ínicio da Atualização" + " " + "Helps de Campos" + CRLF )


oProcess:IncRegua2( "Atualizando Helps de Campos ..." )

aHlpPor := {}
aAdd( aHlpPor, 'Filial relacionada a unidade de negócio' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PADK_XFILI ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ADK_XFILI" )

aHlpPor := {}
aAdd( aHlpPor, 'Status da integração com o TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PADK_XSTINT", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ADK_XSTINT" )

aHlpPor := {}
aAdd( aHlpPor, 'Data da última integração com o TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PADK_XDINT ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ADK_XDINT" )

aHlpPor := {}
aAdd( aHlpPor, 'Hora da última integração com o TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PADK_XHINT ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ADK_XHINT" )

aHlpPor := {}
aAdd( aHlpPor, 'Código da empresa no TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PADK_XEMP  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ADK_XEMP" )

aHlpPor := {}
aAdd( aHlpPor, 'Código da filial no TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PADK_XFIL  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ADK_XFIL" )

aHlpPor := {}
aAdd( aHlpPor, 'Telefone do Cliente 2' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PA1_XFONE2 ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "A1_XFONE2" )

aHlpPor := {}
aAdd( aHlpPor, 'Celular do Cliente' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PA1_XCELULA", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "A1_XCELULA" )

aHlpPor := {}
aAdd( aHlpPor, 'Condição de pagamento relacionada a' )
aAdd( aHlpPor, 'administradora' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PAE_XCOD   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "AE_XCOD" )

aHlpPor := {}
aAdd( aHlpPor, 'Natureza utilizada para gerar taxa de' )
aAdd( aHlpPor, 'administração das vendas com cartão' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PAE_XNTXADM", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "AE_XNTXADM" )

aHlpPor := {}
aAdd( aHlpPor, 'Código da credenciadora' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PAE_XCCRED ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "AE_XCCRED" )

aHlpPor := {}
aAdd( aHlpPor, 'Natureza que será utilizada para gerar' )
aAdd( aHlpPor, 'os títulos a receber das vendas nas' )
aAdd( aHlpPor, 'unidades de negócio' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PE4_XNATVDA", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "E4_XNATVDA" )

aHlpPor := {}
aAdd( aHlpPor, 'Código da condição relacionada' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ10_CODIGO", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z10_CODIGO" )

aHlpPor := {}
aAdd( aHlpPor, 'Descricao da condicao de pagamento' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ10_DESC  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z10_DESC" )

aHlpPor := {}
aAdd( aHlpPor, 'Código da condição no TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ10_CODEXT", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z10_CODEXT" )

aHlpPor := {}
aAdd( aHlpPor, 'Descrição da condição no TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ10_DSEXT ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z10_DSEXT" )

aHlpPor := {}
aAdd( aHlpPor, 'Forma de pagamento utilizada na venda' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ10_FORMA ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z10_FORMA" )

aHlpPor := {}
aAdd( aHlpPor, 'Código da empresa no TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ10_XEMP  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z10_XEMP" )

aHlpPor := {}
aAdd( aHlpPor, 'Código da filial no TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ10_XFIL  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z10_XFIL" )

aHlpPor := {}
aAdd( aHlpPor, 'Status da integração com o TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ10_XSTINT", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z10_XSTINT" )

aHlpPor := {}
aAdd( aHlpPor, 'Data da última integração com o TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ10_XDINT ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z10_XDINT" )

aHlpPor := {}
aAdd( aHlpPor, 'Hora da última integração com o TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ10_XHINT ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z10_XHINT" )

aHlpPor := {}
aAdd( aHlpPor, 'Se o produto foi excluído ou não da' )
aAdd( aHlpPor, 'basede dados do Protheus' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ10_XEXC  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z10_XEXC" )

aHlpPor := {}
aAdd( aHlpPor, 'Tipo da condicao de pagto' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ10_XTPREC", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z10_XTPREC" )

aHlpPor := {}
aAdd( aHlpPor, 'Código do ciente conforme cadastro' )
aAdd( aHlpPor, 'Protheus' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ11_COD   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z11_COD" )

aHlpPor := {}
aAdd( aHlpPor, 'Loja do cliente conforme cadastro' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ11_LOJA  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z11_LOJA" )

aHlpPor := {}
aAdd( aHlpPor, 'Nome do cliente' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ11_DESC  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z11_DESC" )

aHlpPor := {}
aAdd( aHlpPor, 'Código externo do cliente' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ11_XCLIEN", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z11_XCLIEN" )

aHlpPor := {}
aAdd( aHlpPor, 'Código externo do consumidor' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ11_XCONSU", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z11_XCONSU" )

aHlpPor := {}
aAdd( aHlpPor, 'Código da empresa no TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ11_XEMP  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z11_XEMP" )

aHlpPor := {}
aAdd( aHlpPor, 'Código da filial no TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ11_XFIL  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z11_XFIL" )

aHlpPor := {}
aAdd( aHlpPor, 'Status da integração com o TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ11_XSTINT", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z11_XSTINT" )

aHlpPor := {}
aAdd( aHlpPor, 'Data da última integração com o TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ11_XDINT ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z11_XDINT" )

aHlpPor := {}
aAdd( aHlpPor, 'Hora da última integração com o TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ11_XHINT ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z11_XHINT" )

aHlpPor := {}
aAdd( aHlpPor, 'Se o produto foi excluído ou não da' )
aAdd( aHlpPor, 'basede dados do Protheus' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ11_XEXC  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z11_XEXC" )

aHlpPor := {}
aAdd( aHlpPor, 'Código do produto conforme cadastro' )
aAdd( aHlpPor, 'Protheus' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ13_COD   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z13_COD" )

aHlpPor := {}
aAdd( aHlpPor, 'Descrição do produto' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ13_DESC  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z13_DESC" )

aHlpPor := {}
aAdd( aHlpPor, 'Código externo do produto' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ13_XCODEX", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z13_XCODEX" )

aHlpPor := {}
aAdd( aHlpPor, 'Código externo relacionado a árvore do' )
aAdd( aHlpPor, 'produto' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ13_XCDARV", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z13_XCDARV" )

aHlpPor := {}
aAdd( aHlpPor, 'Código da empresa no TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ13_XEMP  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z13_XEMP" )

aHlpPor := {}
aAdd( aHlpPor, 'Código da filial no TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ13_XFIL  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z13_XFIL" )

aHlpPor := {}
aAdd( aHlpPor, 'Status da integração com o TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ13_XSTINT", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z13_XSTINT" )

aHlpPor := {}
aAdd( aHlpPor, 'Data da última integração com o TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ13_XDINT ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z13_XDINT" )

aHlpPor := {}
aAdd( aHlpPor, 'Hora da última integração com o TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ13_XHINT ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z13_XHINT" )

aHlpPor := {}
aAdd( aHlpPor, 'Se o produto foi excluído ou não da' )
aAdd( aHlpPor, 'basede dados do Protheus' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ13_XEXC  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z13_XEXC" )

aHlpPor := {}
aAdd( aHlpPor, 'Código do produto no qual a estrutura' )
aAdd( aHlpPor, 'serefere' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ14_COD   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z14_COD" )

aHlpPor := {}
aAdd( aHlpPor, 'Descrição do produto' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ14_DESC  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z14_DESC" )

aHlpPor := {}
aAdd( aHlpPor, 'Código do produto externo' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ14_XCODEX", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z14_XCODEX" )

aHlpPor := {}
aAdd( aHlpPor, 'Código da empresa no TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ14_XEMP  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z14_XEMP" )

aHlpPor := {}
aAdd( aHlpPor, 'Código da filial no TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ14_XFIL  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z14_XFIL" )

aHlpPor := {}
aAdd( aHlpPor, 'Status da integração com o TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ14_XSTINT", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z14_XSTINT" )

aHlpPor := {}
aAdd( aHlpPor, 'Data da última integração com o TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ14_XDINT ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z14_XDINT" )

aHlpPor := {}
aAdd( aHlpPor, 'Hora da última integração com o TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ14_XHINT ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z14_XHINT" )

aHlpPor := {}
aAdd( aHlpPor, 'Se o produto foi excluído ou não da' )
aAdd( aHlpPor, 'basede dados do Protheus' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ14_XEXC  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z14_XEXC" )

aHlpPor := {}
aAdd( aHlpPor, 'Código do vendedor' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ15_COD   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z15_COD" )

aHlpPor := {}
aAdd( aHlpPor, 'Código externo do  vendedor' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ15_XVEND ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z15_XVEND" )

aHlpPor := {}
aAdd( aHlpPor, 'Código da empresa no TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ15_XEMP  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z15_XEMP" )

aHlpPor := {}
aAdd( aHlpPor, 'Código da filial no TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ15_XFIL  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z15_XFIL" )

aHlpPor := {}
aAdd( aHlpPor, 'Status da integração com o TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ15_XSTINT", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z15_XSTINT" )

aHlpPor := {}
aAdd( aHlpPor, 'Data da última integração com o TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ15_XDINT ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z15_XDINT" )

aHlpPor := {}
aAdd( aHlpPor, 'Hora da última integração com o TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ15_XHINT ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z15_XHINT" )

aHlpPor := {}
aAdd( aHlpPor, 'Se o produto foi excluído ou não da' )
aAdd( aHlpPor, 'basede dados do Protheus' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ15_XEXC  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z15_XEXC" )

aHlpPor := {}
aAdd( aHlpPor, 'Código de tributação' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ16_GRPTRI", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z16_GRPTRI" )

aHlpPor := {}
aAdd( aHlpPor, 'Descrição do grupo de tributação' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ16_DESC  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z16_DESC" )

aHlpPor := {}
aAdd( aHlpPor, 'Código do Produto' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ16_COD   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z16_COD" )

aHlpPor := {}
aAdd( aHlpPor, 'Código da empresa no TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ16_XEMP  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z16_XEMP" )

aHlpPor := {}
aAdd( aHlpPor, 'Código da filial no TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ16_XFIL  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z16_XFIL" )

aHlpPor := {}
aAdd( aHlpPor, 'Status da integração com o TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ16_XSTINT", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z16_XSTINT" )

aHlpPor := {}
aAdd( aHlpPor, 'Data da última integração com o TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ16_XDINT ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z16_XDINT" )

aHlpPor := {}
aAdd( aHlpPor, 'Hora da última integração com o TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ16_XHINT ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z16_XHINT" )

aHlpPor := {}
aAdd( aHlpPor, 'Se o produto foi excluído ou não da' )
aAdd( aHlpPor, 'basede dados do Protheus' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ16_XEXC  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z16_XEXC" )

aHlpPor := {}
aAdd( aHlpPor, 'Código da credenciadorea de cartão' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ31_CODIGO", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z31_CODIGO" )

aHlpPor := {}
aAdd( aHlpPor, 'Nome da credenciadora' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ31_NOME  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z31_NOME" )

aHlpPor := {}
aAdd( aHlpPor, 'CNPJ da credeniadora' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ31_CNPJ  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z31_CNPJ" )

aHlpPor := {}
aAdd( aHlpPor, 'Processo de integração' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZWS_PROCES", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZWS_PROCES" )

aHlpPor := {}
aAdd( aHlpPor, 'Número de integrações do processo' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZWS_NINT  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZWS_NINT" )

aHlpPor := {}
aAdd( aHlpPor, 'Status da integração' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZWS_STATUS", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZWS_STATUS" )

aHlpPor := {}
aAdd( aHlpPor, 'Data da última integração com o TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZWS_DTINT ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZWS_DTINT" )

aHlpPor := {}
aAdd( aHlpPor, 'Hora da última integração com o TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZWS_HRINT ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZWS_HRINT" )

aHlpPor := {}
aAdd( aHlpPor, 'Informações adicionais do processo' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZWS_INF   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZWS_INF" )

aHlpPor := {}
aAdd( aHlpPor, 'XML enviado pelo processo' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZWS_XMLE  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZWS_XMLE" )

aHlpPor := {}
aAdd( aHlpPor, 'XML recebido pelo processo' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZWS_XMLR  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZWS_XMLR" )

aHlpPor := {}
aAdd( aHlpPor, 'Número de itens enviados no XML' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZWS_ITENV ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZWS_ITENV" )

aHlpPor := {}
aAdd( aHlpPor, 'Número de item integrados' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZWS_ITCONF", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZWS_ITCONF" )

aHlpPor := {}
aAdd( aHlpPor, 'Error' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZWS_ERROR ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "ZWS_ERROR" )

AutoGrLog( CRLF + "Final da Atualização" + " " + "Helps de Campos" + CRLF + Replicate( "-", 128 ) + CRLF )

Return {}


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
@ 112, 157  Button oButOk   Prompt "Processar"  Size 32, 12 Pixel Action (  RetSelecao( @aRet, aVetor ), IIf( Len( aRet ) > 0, oDlg:End(), MsgStop( "Ao menos um grupo deve ser selecionado", "UPDFS_I" ) ) ) ;
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
@since  22/05/2018
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
	MsgStop( "Não foi possível a abertura da tabela " + ;
	IIf( lShared, "de empresas (SM0).", "de empresas (SM0) de forma exclusiva." ), "ATENÇÃO" )
EndIf

Return lOpen


//--------------------------------------------------------------------
/*/{Protheus.doc} LeLog
Função de leitura do LOG gerado com limitacao de string

@author TOTVS Protheus
@since  22/05/2018
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
