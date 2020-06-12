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
@since  01/06/2018
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
@since  01/06/2018
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
@since  01/06/2018
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

aAdd( aSX2, {'Z01',cPath,'Z01'+cEmpr,'VENDA','VENDA','VENDA','E','','','','','','','','','','','E','E',0} )
aAdd( aSX2, {'Z02',cPath,'Z02'+cEmpr,'ITENS DA VENDA','ITENS DA VENDA','ITENS DA VENDA','E','','','','','','','','','','','E','E',0} )
aAdd( aSX2, {'Z03',cPath,'Z03'+cEmpr,'CONDICOES DE PAGAMENTO VENDAS','CONDICOES DE PAGAMENTO VENDAS','CONDICOES DE PAGAMENTO VENDAS','E','','','','','','','','','','','E','E',0} )
aAdd( aSX2, {'Z04',cPath,'Z04'+cEmpr,'PRODUCAO','PRODUCAO','PRODUCAO','E','','','','','','','','','','','E','E',0} )
aAdd( aSX2, {'Z12',cPath,'Z12'+cEmpr,'CADASTRO DE CONSUMIDORES','CADASTRO DE CONSUMIDORES','CADASTRO DE CONSUMIDORES','C','','','','','','','','','','','C','C',0} )
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
@since  01/06/2018
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


aAdd( aSX3, {'Z01','01','Z01_FILIAL','C',10,0,'Filial','Sucursal','Branch','Filial do Sistema','Sucursal','Branch of the System','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(254) + Chr(192),'','','U','N','','','','','','','','','','','033','','','','','','','','','','',''} )
aAdd( aSX3, {'Z01','02','Z01_CDEMP','C',2,0,'Emp Teknisa','Emp Teknisa','Emp Teknisa','Código empresa Teknisa','Código empresa Teknisa','Código empresa Teknisa','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','03','Z01_CDFIL','C',4,0,'Fil. Teknisa','Fil. Teknisa','Fil. Teknisa','Código Filial Teknisa','Código Filial Teknisa','Código Filial Teknisa','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','04','Z01_SEQVDA','C',10,0,'ID Venda','ID Venda','ID Venda','Identificação da venda','Identificação da venda','Identificação da venda','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','05','Z01_CAIXA','C',3,0,'Caixa','Caixa','Caixa','Número do caixa','Número do caixa','Número do caixa','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','06','Z01_COMAND','C',250,0,'No. Comanda','No. Comanda','No. Comanda','Nro.Comanda Vendas','Nro.Comanda Vendas','Nro.Comanda Vendas','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','07','Z01_CDCLI','C',21,0,'Cod. Ciente','Cod. Ciente','Cod. Ciente','Código do cliente','Código do cliente','Código do cliente','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','08','Z01_CDCONS','C',21,0,'Cod. Consu.','Cod. Consu.','Cod. Consu.','Código do consumidor','Código do consumidor','Código do consumidor','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','09','Z01_NOME','C',80,0,'Nome','Nome','Nome','Niome do Consumidor','Niome do Consumidor','Niome do Consumidor','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','10','Z01_DATA','D',8,0,'Dt. Venda','Dt. Venda','Dt. Venda','Data da venda','Data da venda','Data da venda','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','11','Z01_ENTREG','D',8,0,'Dt. Entrega','Dt. Entrega','Dt. Entrega','Data da entrega','Data da entrega','Data da entrega','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','12','Z01_HORA','C',8,0,'Hr. Emissao','Hr. Emissao','Hr. Emissao','Hr. Emis.Cupon Fiscal','Hr. Emis.Cupon Fiscal','Hr. Emis.Cupon Fiscal','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','13','Z01_OPERAD','C',12,0,'Cod. Oper.','Cod. Oper.','Cod. Oper.','Código do Operador','Código do Operador','Código do Operador','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','14','Z01_VEND','C',4,0,'Cod.Vendedor','Cod.Vendedor','Cod.Vendedor','Código do vendedor','Código do vendedor','Código do vendedor','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','15','Z01_VRGORJ','N',12,2,'Vr. Gorjeta','Vr. Gorjeta','Vr. Gorjeta','Valor da Gorjeta','Valor da Gorjeta','Valor da Gorjeta','@E 999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','16','Z01_CGC','C',14,0,'CPF/CNPJ','CPF/CNPJ','CPF/CNPJ','CPF/CNPJ Cliente na Venda','CPF/CNPJ Cliente na Venda','CPF/CNPJ Cliente na Venda','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','17','Z01_SERIE','C',5,0,'Série','Série','Série','Série do documento fiscal','Série do documento fiscal','Série do documento fiscal','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','18','Z01_CUPOM','C',10,0,'Cupom Fis.','Cupom Fis.','Cupom Fis.','Número do cupom fiscal','Número do cupom fiscal','Número do cupom fiscal','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','19','Z01_CUPOMC','C',1,0,'Canc. Cupom?','Canc. Cupom?','Canc. Cupom?','Cupom fiscal cancelado?','Cupom fiscal cancelado?','Cupom fiscal cancelado?','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"N"','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','S=Sim;N=Nao','S=Sim;N=Nao','S=Sim;N=Nao','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','20','Z01_NFCE','C',10,0,'NFCe','NFCe','NFCe','Numero da NFC-e','Numero da NFC-e','Numero da NFC-e','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','21','Z01_UF','C',2,0,'UF Venda','UF Venda','UF Venda','UF da venda','UF da venda','UF da venda','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','22','Z01_ANFCE','C',10,0,'Aut. NFC-e','Aut. NFC-e','Aut. NFC-e','Autorização NFC-e','Autorização NFC-e','Autorização NFC-e','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','23','Z01_CHVNFC','C',50,0,'Chave NFCe','Chave NFCe','Chave NFCe','Chave da NFCe','Chave da NFCe','Chave da NFCe','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','24','Z01_DTENV','D',8,0,'Envio XML','Envio XML','Envio XML','Dt.Env XML no Teknisa','Dt.Env XML no Teknisa','Dt.Env XML no Teknisa','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','25','Z01_NPROT','C',15,0,'Protocolo','Protocolo','Protocolo','Protocolo Envio NFCe Tekn','Protocolo Envio NFCe Tekn','Protocolo Envio NFCe Tekn','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','26','Z01_DTRPRO','D',8,0,'Rec. Prot.','Rec. Prot.','Rec. Prot.','Dt.Rec.prot. Teknisa','Dt.Rec.prot. Teknisa','Dt.Rec.prot. Teknisa','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','27','Z01_HRRPRO','C',8,0,'Hr. Prot.','Hr. Prot.','Hr. Prot.','Hr.Retorno Prot.','Hr.Retorno Prot.','Hr.Retorno Prot.','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','28','Z01_SNFCE','C',1,0,'Status NFCe','Status NFCe','Status NFCe','Status NFCe','Status NFCe','Status NFCe','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','29','Z01_OBSNFC','C',100,0,'Desc. Status','Desc. Status','Desc. Status','Desc. Status','Desc. Status','Desc. Status','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','30','Z01_ARQXML','M',10,0,'XML NFCe','XML NFCe','XML NFCe','XML NFCe','XML NFCe','XML NFCe','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','31','Z01_PROCAN','C',15,0,'Prot. Canc.','Prot. Canc.','Prot. Canc.','Prot. Cancelamento','Prot. Cancelamento','Prot. Cancelamento','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','32','Z01_DPROCA','D',8,0,'Dt.Prot.Canc','Dt.Prot.Canc','Dt.Prot.Canc','Dt.Prot.Cancelamento','Dt.Prot.Cancelamento','Dt.Prot.Cancelamento','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','33','Z01_HPROCA','C',8,0,'Hr.Prot.Canc','Hr.Prot.Canc','Hr.Prot.Canc','Hr.Prot.Cancelamento','Hr.Prot.Cancelamento','Hr.Prot.Cancelamento','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','34','Z01_OPERA','C',12,0,'Op. Canc.','Op. Canc.','Op. Canc.','Op. Cancelamento','Op. Cancelamento','Op. Cancelamento','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','35','Z01_MOTCAN','C',125,0,'Mot. Canc.','Mot. Canc.','Mot. Canc.','Mot. Cancelamento','Mot. Cancelamento','Mot. Cancelamento','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','36','Z01_CHVCAN','C',250,0,'Chave Canc.','Chave Canc.','Chave Canc.','Chave Cancelamento','Chave Cancelamento','Chave Cancelamento','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','37','Z01_QRCODE','M',10,0,'Acesso NFCe','Acesso NFCe','Acesso NFCe','Acesso NFCe','Acesso NFCe','Acesso NFCe','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','38','Z01_TIPO','C',1,0,'Tipo Impr.','Tipo Impr.','Tipo Impr.','Tipo Impressora','Tipo Impressora','Tipo Impressora','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','N=NFCE;E=ECF;S=SAT','N=NFCE;E=ECF;S=SAT','N=NFCE;E=ECF;S=SAT','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','39','Z01_CONTNG','C',1,0,'Contingencia','Contingencia','Contingencia','Contingencia?','Contingencia?','Contingencia?','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'N','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','S=Sim;N=Nao','S=Sim;N=Nao','S=Sim;N=Nao','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','40','Z01_XSTINT','C',1,0,'St. Integra','St. Integra','St. Integra','Status Integração','Status Integração','Status Integração','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"P"','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','P=Pendente;I=Integrado','P=Pendente;I=Integrado','P=Pendente;I=Integrado','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','41','Z01_XDINT','D',8,0,'Ult. Integra','Ult. Integra','Ult. Integra','Ult. Integra','Ult. Integra','Ult. Integra','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','42','Z01_XHINT','C',8,0,'Hr. Integra','Hr. Integra','Hr. Integra','Hr. Integra','Hr. Integra','Hr. Integra','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','43','Z01_XDTERP','D',8,0,'Data da inte','Data da inte','Data da inte','','','','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','44','Z01_XHRERP','C',8,0,'Hora int','Hora int','Hora int','','','','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','45','Z01_XINERP','C',1,0,'Status','Status','Status','','','','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z01','46','Z01_XIIERP','M',10,0,'Mensagem Err','o','Mensagem Err','','','','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z02','01','Z02_FILIAL','C',10,0,'Filial','Sucursal','Branch','Filial do Sistema','Sucursal','Branch of the System','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(254) + Chr(192),'','','U','N','','','','','','','','','','','033','','','','','','','','','','',''} )
aAdd( aSX3, {'Z02','02','Z02_CDEMP','C',2,0,'Emp. Teknisa','Emp. Teknisa','Emp. Teknisa','Emp. Teknisa','Emp. Teknisa','Emp. Teknisa','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z02','03','Z02_CDFIL','C',4,0,'Fil. Teknisa','Fil. Teknisa','Fil. Teknisa','Código Filial no TEKNISA','Código Filial no TEKNISA','Código Filial no TEKNISA','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z02','04','Z02_SEQVDA','C',10,0,'ID Venda','ID Venda','ID Venda','Identificação da venda','Identificação da venda','Identificação da venda','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z02','05','Z02_CAIXA','C',3,0,'Caixa','Caixa','Caixa','Número do caixa','Número do caixa','Número do caixa','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z02','06','Z02_SEQIT','C',3,0,'Item','Item','Item','Número sequencial do item','Número sequencial do item','Número sequencial do item','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z02','07','Z02_PROD','C',15,0,'Cod. Prod.','Cod. Prod.','Cod. Prod.','Código do produto','Código do produto','Código do produto','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z02','08','Z02_QTDE','N',12,6,'Quantidade','Quantidade','Quantidade','Quantidade do produto','Quantidade do produto','Quantidade do produto','@E 99,999.999999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z02','09','Z02_VRITEM','N',14,6,'Vr. Item','Vr. Item','Vr. Item','Valor unitário de venda','Valor unitário de venda','Valor unitário de venda','@E 9,999,999.999999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z02','10','Z02_VRDESC','N',12,2,'Vr. Desconto','Vr. Desconto','Vr. Desconto','Valor de desconto do item','Valor de desconto do item','Valor de desconto do item','@E 999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z02','11','Z02_PERDES','N',5,2,'% Desconto','% Desconto','% Desconto','Percentual desconto item','Percentual desconto item','Percentual desconto item','@E 99.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z02','12','Z02_VRTOT','N',14,2,'Vr. Total','Vr. Total','Vr. Total','Valor Total do item','Valor Total do item','Valor Total do item','@E 99,999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z02','13','Z02_CODCST','C',2,0,'CST ICMS','CST ICMS','CST ICMS','Código CST do ICMS item','Código CST do ICMS item','Código CST do ICMS item','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z02','14','Z02_VRIMP','N',12,2,'Vr. Imposto','Vr. Imposto','Vr. Imposto','Valor do imposto','Valor do imposto','Valor do imposto','@E 999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z02','15','Z02_CFOP','C',5,0,'CFOP','CFOP','CFOP','Numero do CFOP','Numero do CFOP','Numero do CFOP','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z02','16','Z02_PCOFIN','N',5,2,'% Cofins','% Cofins','% Cofins','Percentual do Cofins','Percentual do Cofins','Percentual do Cofins','@E 99.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z02','17','Z02_PPIS','N',5,2,'% PIS','% PIS','% PIS','Percentual do PIS','Percentual do PIS','Percentual do PIS','@E 99.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z02','18','Z02_PREDIM','N',5,2,'% Reducao','% Reducao','% Reducao','Percentual red. Imposto','Percentual red. Imposto','Percentual red. Imposto','@E 99.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z02','19','Z02_BASCAL','N',12,2,'Base Cálculo','Base Cálculo','Base Cálculo','Base Cálculo','Base Cálculo','Base Cálculo','@E 999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z02','20','Z02_VRREDU','N',12,2,'Vr. Redução','Vr. Redução','Vr. Redução','Vr. Redução','Vr. Redução','Vr. Redução','@E 999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z02','21','Z02_VRPIS','N',12,2,'Vr. PIS','Vr. PIS','Vr. PIS','Valor do PIS','Valor do PIS','Valor do PIS','@E 999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z02','22','Z02_VRCOFI','N',12,2,'Vr. COFINS','Vr. COFINS','Vr. COFINS','Valor do COFINS','Valor do COFINS','Valor do COFINS','@E 999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z02','23','Z02_OBS','M',10,0,'Inf. Integ.','Inf. Integ.','Inf. Integ.','Inf. Integ.','Inf. Integ.','Inf. Integ.','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z02','24','Z02_FINTE','C',1,0,'Força?','Força?','Força?','Força?','Força?','Força?','9','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"N"','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','S=Sim;N=Nao','S=Sim;N=Nao','S=Sim;N=Nao','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z02','25','Z02_OK','C',1,0,'Val. OK?','Val. OK?','Val. OK?','Val. OK?','Val. OK?','Val. OK?','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"N"','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','S=Sim;W=Com resalva;N=Não','S=Sim;W=Com resalva;N=Não','S=Sim;W=Com resalva;N=Não','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z02','26','Z02_XDINT','D',8,0,'Ult. Integra','Ult. Integra','Ult. Integra','Ult. Integra','Ult. Integra','Ult. Integra','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z02','27','Z02_XHINT','C',8,0,'Hr. Integra','Hr. Integra','Hr. Integra','Hr. Integra','Hr. Integra','Hr. Integra','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z03','01','Z03_FILIAL','C',10,0,'Filial','Sucursal','Branch','Filial do Sistema','Sucursal','Branch of the System','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(254) + Chr(192),'','','U','N','','','','','','','','','','','033','','','','','','','','','','',''} )
aAdd( aSX3, {'Z03','02','Z03_CDEMP','C',2,0,'Emp. Teknisa','Emp. Teknisa','Emp. Teknisa','Emp. Teknisa','Emp. Teknisa','Emp. Teknisa','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z03','03','Z03_CDFIL','C',4,0,'Fil. Teknisa','Fil. Teknisa','Fil. Teknisa','Fil. Teknisa','Fil. Teknisa','Fil. Teknisa','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z03','04','Z03_SEQVDA','C',10,0,'ID Venda','ID Venda','ID Venda','Identificação da venda','Identificação da venda','Identificação da venda','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z03','05','Z03_CAIXA','C',3,0,'Caixa','Caixa','Caixa','Número do caixa','Número do caixa','Número do caixa','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z03','06','Z03_COND','C',3,0,'Cond. Pagto','Cond. Pagto','Cond. Pagto','Cond. Pagto','Cond. Pagto','Cond. Pagto','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z03','07','Z03_DATA','D',8,0,'Data Recbto','Data Recbto','Data Recbto','Data Recbto','Data Recbto','Data Recbto','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z03','08','Z03_DTABER','D',8,0,'Abet. Caixa','Abet. Caixa','Abet. Caixa','Abet. Caixa','Abet. Caixa','Abet. Caixa','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z03','09','Z03_NCHEQU','C',6,0,'Num. Cheque','Num. Cheque','Num. Cheque','Num. Cheque','Num. Cheque','Num. Cheque','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z03','10','Z03_BCCHEQ','C',3,0,'Bco Cheque','Bco Cheque','Bco Cheque','Bco Cheque','Bco Cheque','Bco Cheque','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z03','11','Z03_AGCHEQ','C',5,0,'Agen. Cheque','Agen. Cheque','Agen. Cheque','Agen. Cheque','Agen. Cheque','Agen. Cheque','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z03','12','Z03_CTCHEQ','C',16,0,'Cta Cheque','Cta Cheque','Cta Cheque','Cta Cheque','Cta Cheque','Cta Cheque','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z03','13','Z03_INSCHE','C',20,0,'Insc. Cheque','Insc. Cheque','Insc. Cheque','Insc. Cheque','Insc. Cheque','Insc. Cheque','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z03','14','Z03_NCART','C',10,0,'Num. Cartão','Num. Cartão','Num. Cartão','Num. Cartão','Num. Cartão','Num. Cartão','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z03','15','Z03_NSU','C',100,0,'Num. NSU','Num. NSU','Num. NSU','Num. NSU','Num. NSU','Num. NSU','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z03','16','Z03_PARC','N',4,0,'Num.Parcelas','Num.Parcelas','Num.Parcelas','Num.Parcelas','Num.Parcelas','Num.Parcelas','@E 9,999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z03','17','Z03_VRREC','N',12,2,'Vr. Recebime','Vr. Recebime','Vr. Recebime','Vr. Recebimento','Vr. Recebimento','Vr. Recebimento','@E 999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z03','18','Z03_NUMVP','C',20,0,'Cartão Prese','Cartão Prese','Cartão Prese','Cartão Presente','Cartão Presente','Cartão Presente','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z03','19','Z03_XSTINT','C',1,0,'St. Integra','St. Integra','St. Integra','St. Integra','St. Integra','St. Integra','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"P"','',0,Chr(254) + Chr(192),'','','U','N','V','R','','','P=Pendente;I=Integrado','P=Pendente;I=Integrado','P=Pendente;I=Integrado','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z03','20','Z03_XDINT','D',8,0,'Ult. Integra','Ult. Integra','Ult. Integra','Ult. Integra','Ult. Integra','Ult. Integra','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z03','21','Z03_XHINT','C',8,0,'Hr. Integra','Hr. Integra','Hr. Integra','Hora da última integração','Hora da última integração','Hora da última integração','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z04','01','Z04_FILIAL','C',10,0,'Filial','Sucursal','Branch','Filial do Sistema','Sucursal','Branch of the System','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(254) + Chr(192),'','','U','N','','','','','','','','','','','033','','','','','','','','','','',''} )
aAdd( aSX3, {'Z04','02','Z04_CDEMP','C',2,0,'Emp. Teknisa','Emp. Teknisa','Emp. Teknisa','Emp. Teknisa','Emp. Teknisa','Emp. Teknisa','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z04','03','Z04_CDFIL','C',4,0,'Fil. Teknisa','Fil. Teknisa','Fil. Teknisa','Fil. Teknisa','Fil. Teknisa','Fil. Teknisa','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z04','04','Z04_SEQVDA','C',10,0,'Seq. Venda','Seq. Venda','Seq. Venda','Sequencia de vendas','Sequencia de vendas','Sequencia de vendas','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z04','05','Z04_SEQIT','C',6,0,'Item PV','Item PV','Item PV','Item PV','Item PV','Item PV','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z04','06','Z04_COMAND','C',250,0,'Nr. Comanda','Nr. Comanda','Nr. Comanda','Nr. Comanda','Nr. Comanda','Nr. Comanda','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z04','07','Z04_PEDFOS','C',10,0,'Ped. KDS','Ped. KDS','Ped. KDS','Ped. KDS','Ped. KDS','Ped. KDS','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z04','08','Z04_ITPFOS','C',10,0,'Item KDS','Item KDS','Item KDS','Item KDS','Item KDS','Item KDS','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z04','09','Z04_CODMP','C',15,0,'Cod. Compone','Cod. Compone','Cod. Compone','Cod. Componente','Cod. Componente','Cod. Componente','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z04','10','Z04_QTDE','N',16,6,'Qtde','Qtde','Qtde','Qtde','Qtde','Qtde','@E 999,999,999.999999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z04','11','Z04_DTINIP','D',8,0,'Inic. Produç','Inic. Produç','Inic. Produç','Data de início da produçã','Data de início da produçã','Data de início da produçã','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z04','12','Z04_HRINIP','C',8,0,'Hr. In. Prod','Hr. In. Prod','Hr. In. Prod','Hora de início da produçã','Hora de início da produçã','Hora de início da produçã','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z04','13','Z04_DTFIMP','D',8,0,'Fim Produção','Fim Produção','Fim Produção','Data de fim da produção','Data de fim da produção','Data de fim da produção','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z04','14','Z04_HRFIMP','C',8,0,'Hr. Fim Prod','Hr. Fim Prod','Hr. Fim Prod','Hora de fim da produção','Hora de fim da produção','Hora de fim da produção','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z04','15','Z04_XSTINT','C',1,0,'St. Integra','St. Integra','St. Integra','St. Integra','St. Integra','St. Integra','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"P"','',0,Chr(254) + Chr(192),'','','U','N','V','R','','','P=Pendente;I=Integrado','P=Pendente;I=Integrado','P=Pendente;I=Integrado','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z04','16','Z04_XDINT','D',8,0,'Ult. Integra','Ult. Integra','Ult. Integra','Ult. Integra','Ult. Integra','Ult. Integra','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z04','17','Z04_XHINT','C',5,0,'Hr. Integra','Hr. Integra','Hr. Integra','Hr. Integra','Hr. Integra','Hr. Integra','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z12','01','Z12_FILIAL','C',10,0,'Filial','Sucursal','Branch','Filial do Sistema','Sucursal','Branch of the System','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(254) + Chr(192),'','','U','N','','','','','','','','','','','033','','','','','','','','','','',''} )
aAdd( aSX3, {'Z12','02','Z12_XEMP','C',2,0,'Emp Teknisa','Emp Teknisa','Emp Teknisa','Emp Teknisa','Emp Teknisa','Emp Teknisa','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','€','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z12','03','Z12_XFIL','C',4,0,'Fil Teknisa','Fil Teknisa','Fil Teknisa','Fil Teknisa','Fil Teknisa','Fil Teknisa','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','€','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z12','04','Z12_CLIEN','C',21,0,'Cod. cliente','Cod. cliente','Cod. cliente','Cod. cliente','Cod. cliente','Cod. cliente','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','€','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z12','05','Z12_CONSU','C',21,0,'Cod. consum.','Cod. consum.','Cod. consum.','Cod. consum.','Cod. consum.','Cod. consum.','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','€','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z12','06','Z12_CGC','C',14,0,'CPF / CNPJ','CPF / CNPJ','CPF / CNPJ','CPF / CNPJ','CPF / CNPJ','CPF / CNPJ','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z12','07','Z12_INSCR','C',18,0,'Incrição','Incrição','Incrição','Incrição','Incrição','Incrição','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z12','08','Z12_EST','C',2,0,'UF','UF','UF','UF do consumidor','UF do consumidor','UF do consumidor','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','ExistCpp("CC2")','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z12','09','Z12_NOME','C',40,0,'Nome Consum.','Nome Consum.','Nome Consum.','Nome Consumidor','Nome Consumidor','Nome Consumidor','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z12','10','Z12_NREDUZ','C',20,0,'Fantasia','Fantasia','Fantasia','Nome Fantasia','Nome Fantasia','Nome Fantasia','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z12','11','Z12_END','C',80,0,'Endereço','Endereço','Endereço','Endereço','Endereço','Endereço','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z12','12','Z12_COMPLE','C',30,0,'Comp. Endere','Comp. Endere','Comp. Endere','Comp. Endereço','Comp. Endereço','Comp. Endereço','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z12','13','Z12_CEP','C',9,0,'CEP','CEP','CEP','CEP do consumidor','CEP do consumidor','CEP do consumidor','99999-999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z12','14','Z12_CODM','C',5,0,'Cod. IBGE','Cod. IBGE','Cod. IBGE','Cod. IBGE','Cod. IBGE','Cod. IBGE','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z12','15','Z12_MUN','C',60,0,'Município','Município','Município','Descrição do município','Descrição do município','Descrição do município','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z12','16','Z12_BAIRRO','C',40,0,'Bairro','Bairro','Bairro','Bairro do consumidor','Bairro do consumidor','Bairro do consumidor','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z12','17','Z12_DDI','C',6,0,'DDI','DDI','DDI','Código DDI do consumidor','Código DDI do consumidor','Código DDI do consumidor','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','ExistCpo("ACJ")','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z12','18','Z12_DDD','C',3,0,'DDD','DDD','DDD','Código DDD do consumidor','Código DDD do consumidor','Código DDD do consumidor','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','!Vazio()','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z12','19','Z12_TEL','C',15,0,'Tefefone','Tefefone','Tefefone','Telefone principal','Telefone principal','Telefone principal','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z12','20','Z12_TEL2','C',15,0,'Tefefone 2','Tefefone 2','Tefefone 2','Telefone secundário','Telefone secundário','Telefone secundário','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z12','21','Z12_CONTAT','C',15,0,'Contato','Contato','Contato','Contato','Contato','Contato','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z12','22','Z12_EMAIL','C',30,0,'e-mail','e-mail','e-mail','e-mail','e-mail','e-mail','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z12','23','Z12_DTNASC','D',8,0,'Data','Data','Data','Dt. Nasc.','Dt. Nasc.','Dt. Nasc.','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z12','24','Z12_DTCAD','D',8,0,'Dt. Cadastro','Dt. Cadastro','Dt. Cadastro','Data de cadastro','Data de cadastro','Data de cadastro','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'DATE()','',0,Chr(254) + Chr(192),'','','U','N','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z12','25','Z12_HRCAD','C',8,0,'Hora Cad.','Hora Cad.','Hora Cad.','Hora de cadastro','Hora de cadastro','Hora de cadastro','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'TIME()','',0,Chr(254) + Chr(192),'','','U','N','V','R','','','','','','','','','','','','','','N','','','N','','',''} )
aAdd( aSX3, {'Z12','26','Z12_ATIVO','C',1,0,'Ativo?','Ativo?','Ativo?','Ativo?','Ativo?','Ativo?','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','S=Sim;N=Nao','S=Sim;N=Nao','S=Sim;N=Nao','','','','','','','','','N','','','N','','',''} )

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
@since  01/06/2018
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

aAdd( aSIX, {'Z01','1','Z01_FILIAL+Z01_CDEMP+Z01_CDFIL+Z01_CAIXA+Z01_SEQVDA','Emp Teknisa+Fil. Teknisa+Caixa+ID Venda','Emp Teknisa+Fil. Teknisa+Caixa+ID Venda','Emp Teknisa+Fil. Teknisa+Caixa+ID Venda','U','','','S'} )
aAdd( aSIX, {'Z02','1','Z02_FILIAL+Z02_CDEMP+Z02_CDFIL+Z02_CAIXA+Z02_SEQVDA+Z02_SEQIT','Emp. Teknisa+Fil. Teknisa+Caixa+ID Venda+Item','Emp. Teknisa+Fil. Teknisa+Caixa+ID Venda+Item','Emp. Teknisa+Fil. Teknisa+Caixa+ID Venda+Item','U','','','S'} )
aAdd( aSIX, {'Z03','1','Z03_FILIAL+Z03_CDEMP+Z03_CDFIL+Z03_CAIXA+Z03_SEQVDA+Z03_COND','Emp. Teknisa+Fil. Teknisa+Caixa+ID Venda+Cond. Pagto','Emp. Teknisa+Fil. Teknisa+Caixa+ID Venda+Cond. Pagto','Emp. Teknisa+Fil. Teknisa+Caixa+ID Venda+Cond. Pagto','U','','','S'} )
aAdd( aSIX, {'Z04','1','Z04_FILIAL+Z04_CDEMP+Z04_CDFIL+Z04_SEQIT','Emp. Teknisa+Fil. Teknisa+Item PV','Emp. Teknisa+Fil. Teknisa+Item PV','Emp. Teknisa+Fil. Teknisa+Item PV','U','','','S'} )
aAdd( aSIX, {'Z12','1','Z12_FILIAL+Z12_XEMP+Z12_XFIL+Z12_CLIEN+Z12_CONSU','Emp Teknisa+Fil Teknisa+Cod. cliente+Cod. consum.','Emp Teknisa+Fil Teknisa+Cod. cliente+Cod. consum.','Emp Teknisa+Fil Teknisa+Cod. cliente+Cod. consum.','U','','','S'} )
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
/*/{Protheus.doc} FSAtuHlp
Função de processamento da gravação dos Helps de Campos

@author TOTVS Protheus
@since  01/06/2018
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
aAdd( aHlpPor, 'Código empresa Teknisa' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_CDEMP ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_CDEMP" )

aHlpPor := {}
aAdd( aHlpPor, 'Código Filial Teknisa' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_CDFIL ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_CDFIL" )

aHlpPor := {}
aAdd( aHlpPor, 'Identificação da venda' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_SEQVDA", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_SEQVDA" )

aHlpPor := {}
aAdd( aHlpPor, 'Número do caixa' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_CAIXA ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_CAIXA" )

aHlpPor := {}
aAdd( aHlpPor, 'Nro.Comanda Vendas' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_COMAND", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_COMAND" )

aHlpPor := {}
aAdd( aHlpPor, 'Código do cliente' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_CDCLI ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_CDCLI" )

aHlpPor := {}
aAdd( aHlpPor, 'Código do consumidor' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_CDCONS", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_CDCONS" )

aHlpPor := {}
aAdd( aHlpPor, 'Niome do Consumidor' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_NOME  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_NOME" )

aHlpPor := {}
aAdd( aHlpPor, 'Data da venda' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_DATA  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_DATA" )

aHlpPor := {}
aAdd( aHlpPor, 'Data da entrega' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_ENTREG", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_ENTREG" )

aHlpPor := {}
aAdd( aHlpPor, 'Hr. Emis.Cupon Fiscal' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_HORA  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_HORA" )

aHlpPor := {}
aAdd( aHlpPor, 'Código do Operador' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_OPERAD", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_OPERAD" )

aHlpPor := {}
aAdd( aHlpPor, 'Código do vendedor' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_VEND  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_VEND" )

aHlpPor := {}
aAdd( aHlpPor, 'Valor da Gorjeta' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_VRGORJ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_VRGORJ" )

aHlpPor := {}
aAdd( aHlpPor, 'CPF/CNPJ Cliente na Venda' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_CGC   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_CGC" )

aHlpPor := {}
aAdd( aHlpPor, 'Série do documento fiscal' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_SERIE ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_SERIE" )

aHlpPor := {}
aAdd( aHlpPor, 'Número do cupom fiscal' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_CUPOM ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_CUPOM" )

aHlpPor := {}
aAdd( aHlpPor, 'Cupom fiscal cancelado?' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_CUPOMC", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_CUPOMC" )

aHlpPor := {}
aAdd( aHlpPor, 'Numero da NFC-e' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_NFCE  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_NFCE" )

aHlpPor := {}
aAdd( aHlpPor, 'UF da venda' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_UF    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_UF" )

aHlpPor := {}
aAdd( aHlpPor, 'Autorização NFC-e' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_ANFCE ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_ANFCE" )

aHlpPor := {}
aAdd( aHlpPor, 'Chave da NFCe' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_CHVNFC", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_CHVNFC" )

aHlpPor := {}
aAdd( aHlpPor, 'Dt.Env XML no Teknisa' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_DTENV ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_DTENV" )

aHlpPor := {}
aAdd( aHlpPor, 'Número do protocolo de' )
aAdd( aHlpPor, 'envio da NFC-e do' )
aAdd( aHlpPor, 'TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_NPROT ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_NPROT" )

aHlpPor := {}
aAdd( aHlpPor, 'Data e recebimento do' )
aAdd( aHlpPor, 'protocolo da NFC-e do' )
aAdd( aHlpPor, 'TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_DTRPRO", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_DTRPRO" )

aHlpPor := {}
aAdd( aHlpPor, 'Hora de retorno do' )
aAdd( aHlpPor, 'protocolo da NFC-e do' )
aAdd( aHlpPor, 'TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_HRRPRO", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_HRRPRO" )

aHlpPor := {}
aAdd( aHlpPor, 'Status da NFC-e' )
aAdd( aHlpPor, 'transmitida no TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_SNFCE ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_SNFCE" )

aHlpPor := {}
aAdd( aHlpPor, 'Observação da NFC-e do' )
aAdd( aHlpPor, 'TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_OBSNFC", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_OBSNFC" )

aHlpPor := {}
aAdd( aHlpPor, 'XML da NFC-e do' )
aAdd( aHlpPor, 'TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_ARQXML", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_ARQXML" )

aHlpPor := {}
aAdd( aHlpPor, 'Numero do protocolo de cancelamento da' )
aAdd( aHlpPor, 'NFCe no' )
aAdd( aHlpPor, 'TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_PROCAN", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_PROCAN" )

aHlpPor := {}
aAdd( aHlpPor, 'Dara de recebimento do protocolo de' )
aAdd( aHlpPor, 'cancelamento' )
aAdd( aHlpPor, 'da NFCe no TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_DPROCA", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_DPROCA" )

aHlpPor := {}
aAdd( aHlpPor, 'Hora de recebimento do protocolo de' )
aAdd( aHlpPor, 'cancelamento' )
aAdd( aHlpPor, 'da NFCe no TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_HPROCA", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_HPROCA" )

aHlpPor := {}
aAdd( aHlpPor, 'Operador que efetuou o cancelamento no' )
aAdd( aHlpPor, 'TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_OPERA ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_OPERA" )

aHlpPor := {}
aAdd( aHlpPor, 'Motivo de cancelamento da NFCe no' )
aAdd( aHlpPor, 'TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_MOTCAN", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_MOTCAN" )

aHlpPor := {}
aAdd( aHlpPor, 'Chave de acesso do cancelamento da' )
aAdd( aHlpPor, 'NFC-eno' )
aAdd( aHlpPor, 'TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_CHVCAN", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_CHVCAN" )

aHlpPor := {}
aAdd( aHlpPor, 'Acesso da NFCe no TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_QRCODE", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_QRCODE" )

aHlpPor := {}
aAdd( aHlpPor, 'Tipo Impressora' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_TIPO  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_TIPO" )

aHlpPor := {}
aAdd( aHlpPor, 'Contingencia?' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_CONTNG", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_CONTNG" )

aHlpPor := {}
aAdd( aHlpPor, 'Status da integração com o' )
aAdd( aHlpPor, 'TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_XSTINT", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_XSTINT" )

aHlpPor := {}
aAdd( aHlpPor, 'Data da última integração com o TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_XDINT ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_XDINT" )

aHlpPor := {}
aAdd( aHlpPor, 'Hora da última integração com o TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_XHINT ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_XHINT" )

aHlpPor := {}
aAdd( aHlpPor, 'Data da integração com o' )
aAdd( aHlpPor, 'ERP' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_XDTERP", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_XDTERP" )

aHlpPor := {}
aAdd( aHlpPor, 'Hora de integração com o' )
aAdd( aHlpPor, 'ERP' )
aAdd( aHlpPor, 'Utilizar função Time()' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_XHRERP", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_XHRERP" )

aHlpPor := {}
aAdd( aHlpPor, 'Status da integração com o' )
aAdd( aHlpPor, 'ERP' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_XINERP", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_XINERP" )

aHlpPor := {}
aAdd( aHlpPor, 'Mensagem de confirmação' )
aAdd( aHlpPor, 'e/ou erro na integração' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ01_XIIERP", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z01_XIIERP" )

aHlpPor := {}
aAdd( aHlpPor, 'Código da empresa no TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ02_CDEMP ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z02_CDEMP" )

aHlpPor := {}
aAdd( aHlpPor, 'Código Filial no TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ02_CDFIL ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z02_CDFIL" )

aHlpPor := {}
aAdd( aHlpPor, 'Identificação da venda' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ02_SEQVDA", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z02_SEQVDA" )

aHlpPor := {}
aAdd( aHlpPor, 'Número do caixa' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ02_CAIXA ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z02_CAIXA" )

aHlpPor := {}
aAdd( aHlpPor, 'Número sequencial do item' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ02_SEQIT ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z02_SEQIT" )

aHlpPor := {}
aAdd( aHlpPor, 'Código do produto' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ02_PROD  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z02_PROD" )

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade do produto' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ02_QTDE  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z02_QTDE" )

aHlpPor := {}
aAdd( aHlpPor, 'Valor unitário de venda' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ02_VRITEM", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z02_VRITEM" )

aHlpPor := {}
aAdd( aHlpPor, 'Valor de desconto do item' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ02_VRDESC", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z02_VRDESC" )

aHlpPor := {}
aAdd( aHlpPor, 'Percentual desconto item' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ02_PERDES", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z02_PERDES" )

aHlpPor := {}
aAdd( aHlpPor, 'Valor Total do item' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ02_VRTOT ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z02_VRTOT" )

aHlpPor := {}
aAdd( aHlpPor, 'Código CST do ICMS item' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ02_CODCST", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z02_CODCST" )

aHlpPor := {}
aAdd( aHlpPor, 'Valor do imposto' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ02_VRIMP ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z02_VRIMP" )

aHlpPor := {}
aAdd( aHlpPor, 'Numero do CFOP' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ02_CFOP  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z02_CFOP" )

aHlpPor := {}
aAdd( aHlpPor, 'Percentual do Cofins' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ02_PCOFIN", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z02_PCOFIN" )

aHlpPor := {}
aAdd( aHlpPor, 'Percentual do PIS' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ02_PPIS  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z02_PPIS" )

aHlpPor := {}
aAdd( aHlpPor, 'Percentual red. Imposto' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ02_PREDIM", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z02_PREDIM" )

aHlpPor := {}
aAdd( aHlpPor, 'Valor da base de cálculo do imposto' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ02_BASCAL", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z02_BASCAL" )

aHlpPor := {}
aAdd( aHlpPor, 'Valor da redução do imposto' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ02_VRREDU", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z02_VRREDU" )

aHlpPor := {}
aAdd( aHlpPor, 'Valor do PIS' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ02_VRPIS ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z02_VRPIS" )

aHlpPor := {}
aAdd( aHlpPor, 'Valor do COFINS' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ02_VRCOFI", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z02_VRCOFI" )

aHlpPor := {}
aAdd( aHlpPor, 'Informações relacionadas a integração' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ02_OBS   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z02_OBS" )

aHlpPor := {}
aAdd( aHlpPor, 'Forçar integração com o ERP quando há' )
aAdd( aHlpPor, 'diferenças tributárias entre o Cupom' )
aAdd( aHlpPor, 'fiscal e as' )
aAdd( aHlpPor, 'parametrizações fiscais do Protheus' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ02_FINTE ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z02_FINTE" )

aHlpPor := {}
aAdd( aHlpPor, 'Se o item passou por todas as' )
aAdd( aHlpPor, 'validaçõesdescritas no processo de' )
aAdd( aHlpPor, 'integração' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ02_OK    ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z02_OK" )

aHlpPor := {}
aAdd( aHlpPor, 'Data da última integração com o' )
aAdd( aHlpPor, 'TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ02_XDINT ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z02_XDINT" )

aHlpPor := {}
aAdd( aHlpPor, 'Hora da última integração com o TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ02_XHINT ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z02_XHINT" )

aHlpPor := {}
aAdd( aHlpPor, 'Código da empresa no TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ03_CDEMP ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z03_CDEMP" )

aHlpPor := {}
aAdd( aHlpPor, 'Código da Filial no TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ03_CDFIL ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z03_CDFIL" )

aHlpPor := {}
aAdd( aHlpPor, 'Identificação da venda' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ03_SEQVDA", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z03_SEQVDA" )

aHlpPor := {}
aAdd( aHlpPor, 'Número do caixa' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ03_CAIXA ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z03_CAIXA" )

aHlpPor := {}
aAdd( aHlpPor, 'Pagto Condição de pagamento' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ03_COND  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z03_COND" )

aHlpPor := {}
aAdd( aHlpPor, 'Data do recebimento da venda' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ03_DATA  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z03_DATA" )

aHlpPor := {}
aAdd( aHlpPor, 'Data de abertura do caixa' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ03_DTABER", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z03_DTABER" )

aHlpPor := {}
aAdd( aHlpPor, 'Número do cheque recebido na venda' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ03_NCHEQU", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z03_NCHEQU" )

aHlpPor := {}
aAdd( aHlpPor, 'Número do banco do cheque recebido' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ03_BCCHEQ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z03_BCCHEQ" )

aHlpPor := {}
aAdd( aHlpPor, 'Número da agencia do cheque recebido' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ03_AGCHEQ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z03_AGCHEQ" )

aHlpPor := {}
aAdd( aHlpPor, 'Número da conta do cheque recebido' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ03_CTCHEQ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z03_CTCHEQ" )

aHlpPor := {}
aAdd( aHlpPor, 'Número do documento (CNPJ e/ou CPF)' )
aAdd( aHlpPor, 'utilizado do' )
aAdd( aHlpPor, 'proprietário do cheque' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ03_INSCHE", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z03_INSCHE" )

aHlpPor := {}
aAdd( aHlpPor, 'Número do cartão utilizado no' )
aAdd( aHlpPor, 'recebimento' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ03_NCART ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z03_NCART" )

aHlpPor := {}
aAdd( aHlpPor, 'Número do NSU da transação com cartão' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ03_NSU   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z03_NSU" )

aHlpPor := {}
aAdd( aHlpPor, 'Numero de parcelas que a venda foi paga' )
aAdd( aHlpPor, 'na condição de pagamento' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ03_PARC  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z03_PARC" )

aHlpPor := {}
aAdd( aHlpPor, 'Valor recebido na condição de pagamento' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ03_VRREC ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z03_VRREC" )

aHlpPor := {}
aAdd( aHlpPor, 'Numero do cartão presente' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ03_NUMVP ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z03_NUMVP" )

aHlpPor := {}
aAdd( aHlpPor, 'Status da integração com o TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ03_XSTINT", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z03_XSTINT" )

aHlpPor := {}
aAdd( aHlpPor, 'Data da última integração com o TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ03_XDINT ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z03_XDINT" )

aHlpPor := {}
aAdd( aHlpPor, 'Hora da última integração com o TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ03_XHINT ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z03_XHINT" )

aHlpPor := {}
aAdd( aHlpPor, 'Código da empresa no' )
aAdd( aHlpPor, 'TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ04_CDEMP ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z04_CDEMP" )

aHlpPor := {}
aAdd( aHlpPor, 'Código da Filial no TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ04_CDFIL ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z04_CDFIL" )

aHlpPor := {}
aAdd( aHlpPor, 'Número da sequencia devendas' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ04_SEQVDA", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z04_SEQVDA" )

aHlpPor := {}
aAdd( aHlpPor, 'Número sequencial do item no pedido de' )
aAdd( aHlpPor, 'venda' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ04_SEQIT ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z04_SEQIT" )

aHlpPor := {}
aAdd( aHlpPor, 'Número da comanda de vendas' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ04_COMAND", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z04_COMAND" )

aHlpPor := {}
aAdd( aHlpPor, 'Número no pedido gerado para produção' )
aAdd( aHlpPor, 'noKDS do' )
aAdd( aHlpPor, 'TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ04_PEDFOS", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z04_PEDFOS" )

aHlpPor := {}
aAdd( aHlpPor, 'Item no pedido gerado para produção no' )
aAdd( aHlpPor, 'KDS do' )
aAdd( aHlpPor, 'TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ04_ITPFOS", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z04_ITPFOS" )

aHlpPor := {}
aAdd( aHlpPor, 'Código do produto relacionado a matéria' )
aAdd( aHlpPor, 'prima' )
aAdd( aHlpPor, 'utilizada na composição (receita) do' )
aAdd( aHlpPor, 'produto' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ04_CODMP ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z04_CODMP" )

aHlpPor := {}
aAdd( aHlpPor, 'Quantidade do produto utilizada na' )
aAdd( aHlpPor, 'produção' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ04_QTDE  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z04_QTDE" )

aHlpPor := {}
aAdd( aHlpPor, 'Data de início da produção' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ04_DTINIP", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z04_DTINIP" )

aHlpPor := {}
aAdd( aHlpPor, 'Hora de início da produção' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ04_HRINIP", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z04_HRINIP" )

aHlpPor := {}
aAdd( aHlpPor, 'Data de fim da produção' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ04_DTFIMP", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z04_DTFIMP" )

aHlpPor := {}
aAdd( aHlpPor, 'Hora de fim da produção' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ04_HRFIMP", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z04_HRFIMP" )

aHlpPor := {}
aAdd( aHlpPor, 'Status da integração com o TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ04_XSTINT", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z04_XSTINT" )

aHlpPor := {}
aAdd( aHlpPor, 'Data da última integração com o TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ04_XDINT ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z04_XDINT" )

aHlpPor := {}
aAdd( aHlpPor, 'Hora da última integração com o TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ04_XHINT ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z04_XHINT" )

aHlpPor := {}
aAdd( aHlpPor, 'Código da empresa correspondente no' )
aAdd( aHlpPor, 'TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ12_XEMP  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z12_XEMP" )

aHlpPor := {}
aAdd( aHlpPor, 'Código da filial correspondente no' )
aAdd( aHlpPor, 'TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ12_XFIL  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z12_XFIL" )

aHlpPor := {}
aAdd( aHlpPor, 'Código do cliente no TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ12_CLIEN ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z12_CLIEN" )

aHlpPor := {}
aAdd( aHlpPor, 'Código do consumidor no TEKNISA' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ12_CONSU ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z12_CONSU" )

aHlpPor := {}
aAdd( aHlpPor, 'Código do CPF ou CNPJ do consumidor' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ12_CGC   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z12_CGC" )

aHlpPor := {}
aAdd( aHlpPor, 'Código da inscrição estadual ou RG do' )
aAdd( aHlpPor, 'consumidor' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ12_INSCR ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z12_INSCR" )

aHlpPor := {}
aAdd( aHlpPor, 'UF do consumidor' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ12_EST   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z12_EST" )

aHlpPor := {}
aAdd( aHlpPor, 'Nome ou razão social do consumidor' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ12_NOME  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z12_NOME" )

aHlpPor := {}
aAdd( aHlpPor, 'Nome fantasia do consumidor' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ12_NREDUZ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z12_NREDUZ" )

aHlpPor := {}
aAdd( aHlpPor, 'Complemento de endereço' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ12_END   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z12_END" )

aHlpPor := {}
aAdd( aHlpPor, 'Complemento de endereço' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ12_COMPLE", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z12_COMPLE" )

aHlpPor := {}
aAdd( aHlpPor, 'CEP do consumidor' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ12_CEP   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z12_CEP" )

aHlpPor := {}
aAdd( aHlpPor, 'Código do município no cadastro o IBGE' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ12_CODM  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z12_CODM" )

aHlpPor := {}
aAdd( aHlpPor, 'Descrição do município' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ12_MUN   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z12_MUN" )

aHlpPor := {}
aAdd( aHlpPor, 'Bairro do consumidor' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ12_BAIRRO", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z12_BAIRRO" )

aHlpPor := {}
aAdd( aHlpPor, 'Código DDI do consumidor' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ12_DDI   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z12_DDI" )

aHlpPor := {}
aAdd( aHlpPor, 'Código DDD do consumidor' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ12_DDD   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z12_DDD" )

aHlpPor := {}
aAdd( aHlpPor, 'Telefone principal do consumidor' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ12_TEL   ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z12_TEL" )

aHlpPor := {}
aAdd( aHlpPor, 'Telefone secundário do' )
aAdd( aHlpPor, 'consumidor' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ12_TEL2  ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z12_TEL2" )

aHlpPor := {}
aAdd( aHlpPor, 'Nome do contato para o cadastro do' )
aAdd( aHlpPor, 'consumidor.' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ12_CONTAT", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z12_CONTAT" )

aHlpPor := {}
aAdd( aHlpPor, 'Endereço de e-mail do consumidor' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ12_EMAIL ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z12_EMAIL" )

aHlpPor := {}
aAdd( aHlpPor, 'Data de nascimento e/ou abertura da' )
aAdd( aHlpPor, 'empresa' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ12_DTNASC", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z12_DTNASC" )

aHlpPor := {}
aAdd( aHlpPor, 'Data de cadastro' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ12_DTCAD ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z12_DTCAD" )

aHlpPor := {}
aAdd( aHlpPor, 'Hora de cadastro' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ12_HRCAD ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z12_HRCAD" )

aHlpPor := {}
aAdd( aHlpPor, 'Ativo?' )
aHlpEng := {}
aHlpSpa := {}

PutHelp( "PZ12_ATIVO ", aHlpPor, aHlpEng, aHlpSpa, .T. )
AutoGrLog( "Atualizado o Help do campo " + "Z12_ATIVO" )

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
@since  01/06/2018
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
@since  01/06/2018
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
