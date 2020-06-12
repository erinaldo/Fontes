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
/*/{Protheus.doc} UPBFIN03
Função de update de dicionários para compatibilização

@author TOTVS Protheus
@since  30/04/2015
@obs    Gerado por EXPORDIC - V.4.22.10.7 EFS / Upd. V.4.19.12 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
User Function UPBFIN03( cEmpAmb, cFilAmb )

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
					MsgStop( "Atualização Realizada.", "UPBFIN03" )
				Else
					MsgStop( "Atualização não Realizada.", "UPBFIN03" )
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
			MsgStop( "Atualização não Realizada.", "UPBFIN03" )

		EndIf

	Else
		MsgStop( "Atualização não Realizada.", "UPBFIN03" )

	EndIf

EndIf

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSTProc
Função de processamento da gravação dos arquivos

@author TOTVS Protheus
@since  30/04/2015
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


			oProcess:IncRegua1( "Dicionário de parâmetros" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSX6()


			oProcess:IncRegua1( "Dicionário de gatilhos" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSX7()


			oProcess:IncRegua1( "Dicionário de pastas" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSXA()


			oProcess:IncRegua1( "Dicionário de consultas padrão" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSXB()


			oProcess:IncRegua1( "Dicionário de tabelas sistema" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSX5()

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
@since  30/04/2015
@obs    Gerado por EXPORDIC - V.4.22.10.7 EFS / Upd. V.4.19.12 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSX2()
Local aEstrut   := {}
Local aSX2      := {}
Local cAlias    := ""
Local cEmpr     := ""
Local cPath     := ""
Local nI        := 0
Local nJ        := 0

AutoGrLog( "Ínicio da Atualização" + " SX2" + CRLF )

aEstrut := { "X2_CHAVE"  , "X2_PATH"   , "X2_ARQUIVO", "X2_NOME"   , "X2_NOMESPA", "X2_NOMEENG", "X2_MODO"   , ;
             "X2_TTS"    , "X2_ROTINA" , "X2_PYME"   , "X2_UNICO"  , "X2_DISPLAY", "X2_SYSOBJ" , "X2_USROBJ" , ;
             "X2_MODOEMP", "X2_MODOUN" , "X2_MODULO" }


dbSelectArea( "SX2" )
SX2->( dbSetOrder( 1 ) )
SX2->( dbGoTop() )
cPath := SX2->X2_PATH
cPath := IIf( Right( AllTrim( cPath ), 1 ) <> "\", PadR( AllTrim( cPath ) + "\", Len( cPath ) ), cPath )
cEmpr := Substr( SX2->X2_ARQUIVO, 4 )

aAdd( aSX2, {'SZ1',cPath,'SZ1'+cEmpr,'CODIGO DE BANCOS','CODIGO DE BANCOS','CODIGO DE BANCOS','C','N','','','Z1_FILIAL+Z1_CODIGO','','','','E','E',0} )
aAdd( aSX2, {'SZK',cPath,'SZK'+cEmpr,'CADASTRO DE CONTA CORRENTE','CADASTRO DE CONTA CORRENTE','CADASTRO DE CONTA CORRENTE','E','','','N','','','','','E','E',0} )
aAdd( aSX2, {'SZY',cPath,'SZY'+cEmpr,'PREST.CONTAS ITAU','PREST.CONTAS ITAU','PREST.CONTAS ITAU','C','','','','','','','','E','E',0} )
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

	EndIf

Next nI

AutoGrLog( CRLF + "Final da Atualização" + " SX2" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSX3
Função de processamento da gravação do SX3 - Campos

@author TOTVS Protheus
@since  30/04/2015
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

AutoGrLog( "Ínicio da Atualização" + " SX3" + CRLF )

aEstrut := { { "X3_ARQUIVO", 0 }, { "X3_ORDEM"  , 0 }, { "X3_CAMPO"  , 0 }, { "X3_TIPO"   , 0 }, { "X3_TAMANHO", 0 }, { "X3_DECIMAL", 0 }, { "X3_TITULO" , 0 }, ;
             { "X3_TITSPA" , 0 }, { "X3_TITENG" , 0 }, { "X3_DESCRIC", 0 }, { "X3_DESCSPA", 0 }, { "X3_DESCENG", 0 }, { "X3_PICTURE", 0 }, { "X3_VALID"  , 0 }, ;
             { "X3_USADO"  , 0 }, { "X3_RELACAO", 0 }, { "X3_F3"     , 0 }, { "X3_NIVEL"  , 0 }, { "X3_RESERV" , 0 }, { "X3_CHECK"  , 0 }, { "X3_TRIGGER", 0 }, ;
             { "X3_PROPRI" , 0 }, { "X3_BROWSE" , 0 }, { "X3_VISUAL" , 0 }, { "X3_CONTEXT", 0 }, { "X3_OBRIGAT", 0 }, { "X3_VLDUSER", 0 }, { "X3_CBOX"   , 0 }, ;
             { "X3_CBOXSPA", 0 }, { "X3_CBOXENG", 0 }, { "X3_PICTVAR", 0 }, { "X3_WHEN"   , 0 }, { "X3_INIBRW" , 0 }, { "X3_GRPSXG" , 0 }, { "X3_FOLDER" , 0 }, ;
             { "X3_CONDSQL", 0 }, { "X3_CHKSQL" , 0 }, { "X3_IDXSRV" , 0 }, { "X3_ORTOGRA", 0 }, { "X3_TELA"   , 0 }, { "X3_IDXFLD" , 0 }, { "X3_AGRUP"  , 0 }, ;
             { "X3_PYME"   , 0 } }

aEval( aEstrut, { |x| x[2] := SX3->( FieldPos( x[1] ) ) } )

// Padrão
aAdd( aSX3, {'CTT','55','CTT_XDP06','C',11,0,'Cod Identif','Cod Identif','Cod Identif','Codigo Identificado','Codigo Identificado','Codigo Identificado','@R 99999-9','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SE5','87','E5_XCARTAO','C',12,0,'Cartao ITAU','Cartao ITAU','Cartao ITAU','Cartao ITAU','Cartao ITAU','Cartao ITAU','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','SZK001',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','','S'} )

//Especifico
aAdd( aSX3, {'SZ1','01','Z1_FILIAL','C',2,0,'Filial','Sucursal','Branch','Filial do Sistema','Sucursal','Branch of the System','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(254) + Chr(192),'','','U','N','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZ1','02','Z1_CODIGO','C',3,0,'Cod. Banco','Cod. Banco','Cod. Banco','Codigo do Banco','Codigo do Banco','Codigo do Banco','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','€','ExistChav("SZ1")','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZ1','03','Z1_DESCR','C',30,0,'Descricao','Descricao','Descricao','Descricao do banco','Descricao do banco','Descricao do banco','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','€','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZ1','04','Z1_DREDUZ','C',20,0,'Desc. Reduz.','Desc. Reduz.','Desc. Reduz.','Descricao Reduzida','Descricao Reduzida','Descricao Reduzida','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZK','01','ZK_FILIAL','C',2,0,'Filial','Sucursal','Branch','Filial do Sistema','Sucursal','Branch of the System','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(254) + Chr(192),'','','U','N','','','','','','','','','','','033','1','','','','','','','',''} )
aAdd( aSX3, {'SZK','02','ZK_FORNECE','C',6,0,'Cod Fornece','Cod Fornece','Cod Fornece','Codigo Fornecedor','Codigo Fornecedor','Codigo Fornecedor','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','SA2',0,Chr(254) + Chr(192),'','S','U','S','A','R','€','ExistCpo("SA2",M->ZK_FORNECE)','','','','','ALLTRIM(FUNNAME()) <>"MATA020"','','','1','','','','','','','',''} )
aAdd( aSX3, {'SZK','03','ZK_LOJA','C',2,0,'Loja','Loja','Loja','Loja Fornecedor','Loja Fornecedor','Loja Fornecedor','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','ExistCpo("SA2",M->ZK_FORNECE+M->ZK_LOJA)','','','','','ALLTRIM(FUNNAME()) <>"MATA020"','','','1','','','','','','','',''} )
aAdd( aSX3, {'SZK','04','ZK_NOME','C',60,0,'Nome Fornece','Nome Fornece','Nome Fornece','Nome do Fornecedor','Nome do Fornecedor','Nome do Fornecedor','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','1','','','','','','','',''} )
aAdd( aSX3, {'SZK','05','ZK_BANCO','C',3,0,'Num Banco','Num Banco','Num Banco','Numero do Banco','Numero do Banco','Numero do Banco','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','SZ1',0,Chr(254) + Chr(192),'','S','U','S','A','R','€','ExistCpo("SZ1",M->ZK_BANCO)','','','','','','','','1','','','','','','','',''} )
aAdd( aSX3, {'SZK','06','ZK_NOMBCO','C',30,0,'Nome Banco','Nome Banco','Nome Banco','Nome Banco','Nome Banco','Nome Banco','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','1','','','','','','','',''} )
aAdd( aSX3, {'SZK','07','ZK_AGENCIA','C',4,0,'Nro. Agencia','Nro. Agencia','Nro. Agencia','Nro. Agencia','Nro. Agencia','Nro. Agencia','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','€','NaoVazio(M->ZK_AGENCIA)','','','','','','','','1','','','','','','','',''} )
aAdd( aSX3, {'SZK','08','ZK_DVAG','C',1,0,'DV Agencia','DV Agencia','DV Agencia','Dig Verificador Agencia','Dig Verificador Agencia','Dig Verificador Agencia','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','1','','','','','','','',''} )
aAdd( aSX3, {'SZK','09','ZK_TIPO','C',1,0,'Tipo Conta','Tipo Conta','Tipo Conta','Tipo da Conta','Tipo da Conta','Tipo da Conta','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','S','U','S','A','R','','PERTENCE("1234")','1=Conta Corrente;2=Conta Poupanca;3=Conta Cartao Brasil;4=Conta Cartao Itau','1=Conta Corrente;2=Conta Poupanca;3=Conta Cartao Brasil;4=Conta Cartao Itau','1=Conta Corrente;2=Conta Poupanca;3=Conta Cartao Brasil;4=Conta Cartao Itau','','','','','1','','','','','','','',''} )
aAdd( aSX3, {'SZK','10','ZK_NUMCON','C',14,0,'Nro. Conta','Nro. Conta','Nro. Conta','Numero da Conta','Numero da Conta','Numero da Conta','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','EXISTCHAV("SZK",M->ZK_NUMCON+ZK_FORNECE+ZK_LOJA,2)','','','','','M->ZK_TIPO = "1"','','','1','','','','N','','N','',''} )
aAdd( aSX3, {'SZK','11','ZK_NROPOP','C',14,0,'Nro Poupanca','Nro Poupanca','Nro Poupanca','Numero da Poupanca','Numero da Poupanca','Numero da Poupanca','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','EXISTCHAV("SZK",M->ZK_NROPOP+ZK_FORNECE+ZK_LOJA,3)','','','','','M->ZK_TIPO = "2"','','','1','','','','N','','N','',''} )
aAdd( aSX3, {'SZK','12','ZK_NROCRT','C',16,0,'Nro Cartao','Nro Cartao','Nro Cartao','Numero do Cartao','Numero do Cartao','Numero do Cartao','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','EXISTCHAV("SZK",M->ZK_NROCRT+ZK_FORNECE+ZK_LOJA,4)','','','','','M->ZK_TIPO = "3" .OR. M->ZK_TIPO = "4"','','','1','','','','','','','',''} )
aAdd( aSX3, {'SZK','13','ZK_STATUS','C',1,0,'Status','Status','Status','Status Cta Fornecedor','Status Cta Fornecedor','Status Cta Fornecedor','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"A"','',0,Chr(254) + Chr(192),'','S','U','S','A','R','','','A=Ativo;I=Inativo','A=Ativo;I=Inativo','A=Ativo;I=Inativo','','','','','1','','','','','','','',''} )
aAdd( aSX3, {'SZK','14','ZK_XTPINAT','C',1,0,'Tipo Inativo','Tipo Inativo','Tipo Inativo','Tipo Inativo','Tipo Inativo','Tipo Inativo','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','1=Demitido;2=Ferias;3=Subs.Ferias;4=Afastado;5=Alt.Responsabilidade','','','','','','','1','','','','N','','N','',''} )
aAdd( aSX3, {'SZK','15','ZK_XNRCART','C',12,0,'Cartao Subst','Cartao Subst','Cartao Subst','Cartao Subst','Cartao Subst','Cartao Subst','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','iif(M->ZK_STATUS=="I",IIF(M->ZK_XTPINAT$"2|3",.T.,.F.),.F.)','','','1','','','','N','','N','',''} )
aAdd( aSX3, {'SZK','16','ZK_UNIDADE','C',15,0,'Unidade','Unidade','Unidade','Unidade','Unidade','Unidade','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','1','','','','N','','N','',''} )
aAdd( aSX3, {'SZK','17','ZK_E_TIPO','C',1,0,'Tipo Cartao','Tipo Cartao','Tipo Cartao','Tipo Cartao','Tipo Cartao','Tipo Cartao','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','PERTENCE("123")','1=FFC;2=FFQ;3=ADT','','','','M->ZK_TIPO=="4"','','','2','','','','','','','',''} )
aAdd( aSX3, {'SZK','18','ZK_REDUZ','C',20,0,'Cta Reduzida','Cta Reduzida','Cta Reduzida','Cta Reduzida','Cta Reduzida','Cta Reduzida','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CTD',0,Chr(254) + Chr(192),'','','U','N','A','R','','ExistCpo("CTD") .and. ValidItem(M->ZK_REDUZ,"1",,,.T.,)','','','','','M->ZK_TIPO=="4"','','','2','','','','','','','',''} )
aAdd( aSX3, {'SZK','19','ZK_E_EMAIL','C',60,0,'E-mail','E-mail','E-mail','E-mail','E-mail','E-mail','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','M->ZK_TIPO=="4"','','','2','','','','','','','',''} )
aAdd( aSX3, {'SZK','20','ZK_E_SUP','C',60,0,'E-mail Super','E-mail Super','E-mail Super','E-mail Superior','E-mail Superior','E-mail Superior','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','M->ZK_TIPO=="4"','','','2','','','','','','','',''} )
aAdd( aSX3, {'SZK','21','ZK_E_CC1','C',150,0,'Com Copia 1','Com Copia 1','Com Copia 1','Com Copia 1','Com Copia 1','Com Copia 1','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','M->ZK_TIPO=="4"','','','2','','','','N','','N','',''} )
aAdd( aSX3, {'SZK','22','ZK_E_CC2','C',150,0,'Com Copia 2','Com Copia 2','Com Copia 2','Com Copia 2','Com Copia 2','Com Copia 2','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','M->ZK_TIPO=="4"','','','2','','','','N','','N','',''} )
aAdd( aSX3, {'SZK','23','ZK_E_CC3','C',150,0,'Com Copia 3','Com Copia 3','Com Copia 3','Com Copia 3','Com Copia 3','Com Copia 3','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','M->ZK_TIPO=="4"','','','2','','','','N','','N','',''} )
aAdd( aSX3, {'SZK','24','ZK_E_LIMIT','N',14,2,'Lim. Periodo','Lim. Periodo','Lim. Periodo','Lim. Periodo','Lim. Periodo','Lim. Periodo','@E 999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','S','U','S','A','R','','','','','','','M->ZK_TIPO=="4"','','','2','','','','','','','',''} )
aAdd( aSX3, {'SZK','25','ZK_E_SLDIA','N',14,2,'Sld.Disp.Dia','Sld.Disp.Dia','Sld.Disp.Dia','Sld.Disp.Dia','Sld.Disp.Dia','Sld.Disp.Dia','@E 999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','M->ZK_TIPO=="4"','','','2','','','','','','','',''} )
aAdd( aSX3, {'SZK','26','ZK_E_SLDAT','N',14,2,'Disp.p/Saque','Disp.p/Saque','Disp.p/Saque','Disp.p/Saque','Disp.p/Saque','Disp.p/Saque','@E 999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','M->ZK_TIPO=="4"','','','2','','','','','','','',''} )
aAdd( aSX3, {'SZK','27','ZK_E_SLDPR','N',14,2,'Sld Prest.CC','Sld Prest.CC','Sld Prest.CC','Sld Prest.CC','Sld Prest.CC','Sld Prest.CC','@E 999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','M->ZK_TIPO=="4"','','','2','','','','','','','',''} )
aAdd( aSX3, {'SZK','28','ZK_E_DTENV','D',8,0,'Dt Aviso','Dt Aviso','Dt Aviso','Dt Aviso','Dt Aviso','Dt Aviso','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','V','R','','','','','','','','','','2','','','','','','','',''} )
aAdd( aSX3, {'SZK','29','ZK_E_DTBLQ','D',8,0,'Dt Bloqueio','Dt Bloqueio','Dt Bloqueio','Dt Bloqueio','Dt Bloqueio','Dt Bloqueio','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','V','R','','','','','','','','','','2','','','','','','','',''} )
aAdd( aSX3, {'SZK','30','ZK_E_DTREC','D',8,0,'Dt Recompos.','Dt Recompos.','Dt Recompos.','Dt Recompos.','Dt Recompos.','Dt Recompos.','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','2','','','','','','','',''} )
aAdd( aSX3, {'SZK','31','ZK_DIGCONT','C',1,0,'Flag Dig.Con','Flag Dig.Con','Flag Dig.Con','Flag Dig.Con','Flag Dig.Con','Flag Dig.Con','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"N"','',0,Chr(254) + Chr(192),'','','U','N','V','R','','','S=Sim;N=Nao','','','','','','','2','','','','N','','N','',''} )
aAdd( aSX3, {'SZK','32','ZK_PRINCIP','C',1,0,'Conta princi','Conta princi','Conta princi','Conta principal','Conta principal','Conta principal','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','€','','1= Sim; 2= Nao','1= Sim; 2= Nao','1= Sim; 2= Nao','','','','','1','','','','N','','N','',''} )
aAdd( aSX3, {'SZK','33','ZK_VENCTO','C',7,0,'Dt Vencto','Dt Vencto','Dt Vencto','Data Vencimento','Data Vencimento','Data Vencimento','99/9999','U_SZKDATA()',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','1','','','','N','','N','',''} )
aAdd( aSX3, {'SZK','34','ZK_CRESP','C',9,0,'Centro Resp','Centro Resp','Centro Resp','Centro Responsabilidade','Centro Responsabilidade','Centro Responsabilidade','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CTT',0,Chr(254) + Chr(192),'','S','U','N','A','R','','','','','','','','','','1','','','','N','','N','',''} )
aAdd( aSX3, {'SZK','35','ZK_CODID','C',11,0,'Cod Identif','Cod Identif','Cod Identif','Cod Identificacao','Cod Identificacao','Cod Identificacao','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','V','R','','','','','','','','','','1','','','','N','','N','',''} )
aAdd( aSX3, {'SZY','01','ZY_FILIAL','C',2,0,'Filial','Sucursal','Branch','Filial do Sistema','Sucursal','Branch of the System','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(254) + Chr(192),'','','U','N','','','','','','','','','','','033','','','','','','','','',''} )
aAdd( aSX3, {'SZY','02','ZY_CARTAO','C',12,0,'Cartao ITAU','Cartao ITAU','Cartao ITAU','Cartao ITAU','Cartao ITAU','Cartao ITAU','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZY','03','ZY_ITEM','C',20,0,'Cta Debito','Cta Debito','Cta Debito','Cta Debito','Cta Debito','Cta Debito','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CTD',0,Chr(254) + Chr(192),'','S','U','S','A','R','','ExistCpo("CTD") .and. ValidItem(M->ZY_ITEM,"1",,,.T.,)','','','','','U_C6A10VOK("1")','','','','','','','','','','',''} )
aAdd( aSX3, {'SZY','04','ZY_CONTA','C',20,0,'Cta Debito','Cta Debito','Cta Debito','Cta Debito','Cta Debito','Cta Debito','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','CT1',0,Chr(254) + Chr(192),'','','U','N','V','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZY','05','ZY_CC','C',5,0,'CC Debito','CC Debito','CC Debito','CC Debito','CC Debito','CC Debito','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CTT',0,Chr(254) + Chr(192),'','','U','S','A','R','','Vazio() .or. ExistCPO("CTT")','','','','','U_C6A10VOK("1")','','','','','','','','','','',''} )
aAdd( aSX3, {'SZY','06','ZY_ITEMC','C',20,0,'Cta Credito','Cta Credito','Cta Credito','Cta Credito','Cta Credito','Cta Credito','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CTD',0,Chr(254) + Chr(192),'','S','U','S','A','R','','ExistCpo("CTD") .and. ValidItem(M->ZY_ITEMC,"1",,,.T.,)','','','','','U_C6A10VOK("2")','','','','','','','','','','',''} )
aAdd( aSX3, {'SZY','07','ZY_CONTAC','C',20,0,'Cta Credito','Cta Credito','Cta Credito','Cta Credito','Cta Credito','Cta Credito','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','CT1',0,Chr(254) + Chr(192),'','','U','N','V','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZY','08','ZY_CCC','C',5,0,'CC Credito','CC Credito','CC Credito','CC Credito','CC Credito','CC Credito','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CTT',0,Chr(254) + Chr(192),'','','U','S','A','R','','Vazio() .or. ExistCPO("CTT")','','','','','U_C6A10VOK("2")','','','','','','','','','','',''} )
aAdd( aSX3, {'SZY','09','ZY_NATUREZ','C',20,0,'Natureza','Natureza','Natureza','Natureza','Natureza','Natureza','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','SED',0,Chr(254) + Chr(192),'','','U','S','A','R','','Vazio() .or. ExistCPO("SED")','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZY','10','ZY_HIST','C',40,0,'Historico','Historico','Historico','Historico','Historico','Historico','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZY','11','ZY_VALOR','N',14,2,'Valor Total','Valor Total','Valor Total','Valor Total','Valor Total','Valor Total','@E 999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','U_CFINA55Val() .and. positivo()','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZY','12','ZY_ENCARGO','N',14,2,'Encargos','Encargos','Encargos','Encargos','Encargos','Encargos','@E 999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','positivo()','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZY','13','ZY_XCOMPET','C',7,0,'Competencia','Competencia','Competencia','Competencia','Competencia','Competencia','99/9999','U_COMPET55()',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','N','',''} )
aAdd( aSX3, {'SZY','14','ZY_DATA','D',8,0,'Data','Data','Data','Data','Data','Data','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZY','15','ZY_VLDFIN','C',1,0,'Valid Financ','Valid Financ','Valid Financ','Valid Financ','Valid Financ','Valid Financ','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','pertence("12")','1=Sim;2=Nao','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZY','16','ZY_DTVLD','D',8,0,'Data Valid.','Data Valid.','Data Valid.','Data Valid.','Data Valid.','Data Valid.','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )

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
@since  30/04/2015
@obs    Gerado por EXPORDIC - V.4.22.10.7 EFS / Upd. V.4.19.12 EFS
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

aAdd( aSIX, {'SZ1','1','Z1_FILIAL+Z1_CODIGO','CODIGO','CODIGO','CODIGO','U','','',''} )
aAdd( aSIX, {'SZ1','2','Z1_FILIAL+Z1_DESCR','NOME','NOMBRE','NAME','U','','',''} )
aAdd( aSIX, {'SZ1','3','Z1_FILIAL+Z1_DREDUZ','NOME REDUZIDO','NOME REDUZIDO','SHORT NAME','U','','',''} )
aAdd( aSIX, {'SZK','1','ZK_FILIAL+ZK_NOME','Nome Fornece','Nome Fornece','Nome Fornece','U','','',''} )
aAdd( aSIX, {'SZK','2','ZK_FILIAL+ZK_NUMCON+ZK_FORNECE+ZK_LOJA','Nro. Conta+Cod Fornece+Loja','Nro. Conta+Cod Fornece+Loja','Nro. Conta+Cod Fornece+Loja','U','','',''} )
aAdd( aSIX, {'SZK','3','ZK_FILIAL+ZK_NROPOP+ZK_FORNECE+ZK_LOJA','Nro Poupanca+Cod Fornece+Loja','Nro Poupanca+Cod Fornece+Loja','Nro Poupanca+Cod Fornece+Loja','U','','',''} )
aAdd( aSIX, {'SZK','4','ZK_FILIAL+ZK_NROCRT+ZK_FORNECE+ZK_LOJA','Nro Cartao+Cod Fornece+Loja','Nro Cartao+Cod Fornece+Loja','Nro Cartao+Cod Fornece+Loja','U','','',''} )
aAdd( aSIX, {'SZK','5','ZK_FILIAL+ZK_FORNECE+ZK_LOJA','Cod Fornece+Loja','Cod Fornece+Loja','Cod Fornece+Loja','U','','',''} )
aAdd( aSIX, {'SZK','6','ZK_FILIAL+ZK_E_LIMIT+ZK_NROCRT+ZK_FORNECE+ZK_LOJA','Lim. Periodo+Nro Cartao+Cod Fornece+Loja','Lim. Periodo+Nro Cartao+Cod Fornece+Loja','Lim. Periodo+Nro Cartao+Cod Fornece+Loja','U','','','S'} )
aAdd( aSIX, {'SZK','7','ZK_FILIAL+ZK_UNIDADE+ZK_NROCRT+ZK_FORNECE+ZK_LOJA','Unidade+Nro Cartao+Cod Fornece+Loja','Unidade+Nro Cartao+Cod Fornece+Loja','Unidade+Nro Cartao+Cod Fornece+Loja','U','','','S'} )
aAdd( aSIX, {'SZK','8','ZK_FILIAL+ZK_E_DTREC+ZK_NROCRT+ZK_FORNECE+ZK_LOJA','Dt Recompos.+Nro Cartao+Cod Fornece+Loja','Dt Recompos.+Nro Cartao+Cod Fornece+Loja','Dt Recompos.+Nro Cartao+Cod Fornece+Loja','U','','','S'} )
aAdd( aSIX, {'SZY','1','ZY_FILIAL+ZY_CARTAO+DTOS(ZY_DATA)','Cartao ITAU+Data','Cartao ITAU+Data','Cartao ITAU+Data','U','','','S'} )
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
@since  30/04/2015
@obs    Gerado por EXPORDIC - V.4.22.10.7 EFS / Upd. V.4.19.12 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSX6()
Local aEstrut   := {}
Local aSX6      := {}
Local cAlias    := ""
Local lContinua := .T.
Local lReclock  := .T.
Local nI        := 0
Local nJ        := 0
Local nTamFil   := Len( SX6->X6_FIL )
Local nTamVar   := Len( SX6->X6_VAR )

AutoGrLog( "Ínicio da Atualização" + " SX6" + CRLF )

aEstrut := { "X6_FIL"    , "X6_VAR"    , "X6_TIPO"   , "X6_DESCRIC", "X6_DSCSPA" , "X6_DSCENG" , "X6_DESC1"  , ;
             "X6_DSCSPA1", "X6_DSCENG1", "X6_DESC2"  , "X6_DSCSPA2", "X6_DSCENG2", "X6_CONTEUD", "X6_CONTSPA", ;
             "X6_CONTENG", "X6_PROPRI" , "X6_VALID"  , "X6_INIT"   , "X6_DEFPOR" , "X6_DEFSPA" , "X6_DEFENG" , ;
             "X6_PYME"   }

aAdd( aSX6, {'  ','CI_CTAFFC','C','Ctas que nao irao compor valor de Prestacao de Con','','','tas (Controle Cartao ITAU). IMPOSTOS','','','','','','2140211/2130611/2130911/2140111/2140311/2140411/49114','','','U','','','','','',''} )
aAdd( aSX6, {'  ','CI_DIAS','N','DIAS A CONTAR A PARTIR DO E-MAIL DISPARADO ANTERIO','','','RMENTE PARA BLOQUEAR O CARTAO DO COLABORADOR','','','CONTA CARTAO ITAU','','','15','10','10','U','','','','','',''} )
aAdd( aSX6, {'  ','CI_DTVENC','N','Meses de Vencimento do Cartão','Meses de Vencimento do Cartão','Meses de Vencimento do Cartão','Meses de Vencimento do Cartão','Meses de Vencimento do Cartão','Meses de Vencimento do Cartão','Meses de Vencimento do Cartão','Meses de Vencimento do Cartão','Meses de Vencimento do Cartão','90','90','90','U','','','','','',''} )
aAdd( aSX6, {'  ','CI_HRCTFIM','C','Horário final de movimentação financeiro do Cartão','Horário final de movimentação financeiro do Cartão','Horário final de movimentação financeiro do Cartão','de Crédito ITAU','de Crédito ITAU','de Crédito ITAU','','','','16:00:00','16:00:00','16:00:00','U','','','','','',''} )
aAdd( aSX6, {'  ','CI_HRCTINI','C','Horário inicial de movimentação financeiro do Cart','Horário inicial de movimentação financeiro do Cart','Horário inicial de movimentação financeiro do Cart','ão de Crédito ITAU','ão de Crédito ITAU','ão de Crédito ITAU','','','','00:00:01','00:00:01','00:00:01','U','','','','','',''} )
aAdd( aSX6, {'  ','CI_NAT999','C','Natureza a Reclassificar','Natureza a Reclassificar','Natureza a Reclassificar','','','','','','','99999999','9.99.99','9.99.99','U','','','','','',''} )
aAdd( aSX6, {'  ','CI_PERC','N','PERCENTUAL MINIMO A SER ATINGIDO E DISPARADO WORKF','','','LOW PARA OS RESPONSAVEIS PRESTACAO CONTAS','','','CONTA CARTAO ITAU','','','40','40','40','U','','','','','',''} )
aAdd( aSX6, {'  ','CI_PERDISP','N','PERCENTUAL MINIMO A SER ATINGIDO E DISPARADO WORKF','','','LOW PARA OS RESPONSAVEIS SALDO DISPONIVEL','','','CONTA CARTAO ITAU','','','40','40','40','U','','','','','',''} )
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
	Else
		lContinua := .T.
		lReclock  := .F.
		AutoGrLog( "Foi alterado o parâmetro " + aSX6[nI][1] + aSX6[nI][2] + " de [" + ;
		AllTrim( SX6->X6_CONTEUD ) + "]" + " para [" + AllTrim( aSX6[nI][13] ) + "]" )
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
/*/{Protheus.doc} FSAtuSX7
Função de processamento da gravação do SX7 - Gatilhos

@author TOTVS Protheus
@since  30/04/2015
@obs    Gerado por EXPORDIC - V.4.22.10.7 EFS / Upd. V.4.19.12 EFS
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

aAdd( aSX7, {'ZK_BANCO','001','M->A2_COD','ZK_FORNECE','P','N','SA2',1,'','U','ALLTRIM(FUNNAME()) == "MATA020"'} )
aAdd( aSX7, {'ZK_BANCO','002','M->A2_LOJA','ZK_LOJA','P','N','SA2',1,'','U','ALLTRIM(FUNNAME()) <> "CFINA34"'} )
aAdd( aSX7, {'ZK_BANCO','003','M->A2_NOME','ZK_NOME','P','N','SA2',1,'','U','ALLTRIM(FUNNAME()) <> "CFINA34"'} )
aAdd( aSX7, {'ZK_BANCO','004','SZ1->Z1_DESCR','ZK_NOMBCO','P','S','SZ1',1,'xFILIAL("SZ1")+M->ZK_BANCO','U',''} )
aAdd( aSX7, {'ZK_BANCO','005','M->A2_MUN','ZK_UNIDADE','P','N','',0,'','U','ALLTRIM(FUNNAME()) == "MATA020"'} )
aAdd( aSX7, {'ZK_CRESP','001','CTT->CTT_DESC01','ZK_UNIDADE','P','S','CTT',1,'xFilial("CTT")+M->ZK_CRESP','U',''} )
aAdd( aSX7, {'ZK_CRESP','002','CTT->CTT_XDP06','ZK_CODID','P','S','CTT',1,'xFilial("CTT")+M->ZK_CRESP','U',''} )
aAdd( aSX7, {'ZK_E_LIMIT','001','IIF(ALTERA,M->ZK_E_LIMIT-M->ZK_E_SLDPR,M->ZK_E_LIMIT)','ZK_E_SLDAT','P','N','',0,'','U',''} )
aAdd( aSX7, {'ZK_FORNECE','001','SA2->A2_NOME','ZK_NOME','P','S','SA2',1,'xFilial("SA2")+M->ZK_FORNECE','U',''} )
aAdd( aSX7, {'ZK_FORNECE','002','SA2->A2_LOJA','ZK_LOJA','P','S','SA2',1,'xFilial("SA2")+M->ZK_FORNECE','U',''} )
aAdd( aSX7, {'ZK_FORNECE','003','SA2->A2_MUN','ZK_UNIDADE','P','S','SA2',1,'xFilial("SA2")+M->ZK_FORNECE','U',''} )
aAdd( aSX7, {'ZK_STATUS','001','" "','ZK_XTPINAT','P','N','',0,'','U',''} )
aAdd( aSX7, {'ZK_TIPO','001','M->ZK_NUMCON:= " "','ZK_NUMCON','P','N','',0,'','U','M->ZK_TIPO <> "1"'} )
aAdd( aSX7, {'ZK_TIPO','002','M->ZK_NROPOP:= " "','ZK_NROPOP','P','N','',0,'','U','M->ZK_TIPO <> "2"'} )
aAdd( aSX7, {'ZK_TIPO','003','M->ZK_NROCRT','ZK_NROCRT','P','N','',0,'','U','M->ZK_TIPO <> "3"'} )
aAdd( aSX7, {'ZY_ITEM','001','Posicione("CT1",2,xFilial("CT1")+M->ZY_ITEM,"CT1_CONTA")','ZY_CONTA','P','N','',0,'','U',''} )
aAdd( aSX7, {'ZY_ITEM','002','Posicione("CT1",2,xFilial("CT1")+M->ZY_ITEM,"CT1_NATURE")','ZY_NATUREZ','P','N','',0,'','U',''} )
aAdd( aSX7, {'ZY_ITEMC','001','Posicione("CT1",2,xFilial("CT1")+M->ZY_ITEMC,"CT1_CONTA")','ZY_CONTAC','P','N','',0,'','U',''} )
aAdd( aSX7, {'ZY_ITEMC','002','Posicione("CT1",2,xFilial("CT1")+M->ZY_ITEMC,"CT1_NATURE")','ZY_NATUREZ','P','N','',0,'','U',''} )
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
	Else

		If !( aSX7[nI][1] $ cAlias )
			cAlias += aSX7[nI][1] + "/"
			AutoGrLog( "Foi alterado o gatilho " + aSX7[nI][1] + "/" + aSX7[nI][2] )
		EndIf

		RecLock( "SX7", .F. )
	EndIf

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

	oProcess:IncRegua2( "Atualizando Arquivos (SX7)..." )

Next nI

RestArea( aAreaSX3 )

AutoGrLog( CRLF + "Final da Atualização" + " SX7" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSXA
Função de processamento da gravação do SXA - Pastas

@author TOTVS Protheus
@since  30/04/2015
@obs    Gerado por EXPORDIC - V.4.22.10.7 EFS / Upd. V.4.19.12 EFS
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


aAdd( aSXA, {'SZK','1','Conta Corrente','Conta Corrente','Conta Corrente','','','U'} )
aAdd( aSXA, {'SZK','2','Conta Corrente ITAU','Conta Corrente ITAU','Conta Corrente ITAU','','','U'} )
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

oProcess:IncRegua2( "Atualizando Arquivos (SXA)..." ) //

Next nI

AutoGrLog( CRLF + "Final da Atualização" + " SXA" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSXB
Função de processamento da gravação do SXB - Consultas Padrao

@author TOTVS Protheus
@since  30/04/2015
@obs    Gerado por EXPORDIC - V.4.22.10.7 EFS / Upd. V.4.19.12 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSXB()
Local aEstrut   := {}
Local aSXB      := {}
Local cAlias    := ""
Local nI        := 0
Local nJ        := 0

AutoGrLog( "Ínicio da Atualização" + " SXB" + CRLF )

aEstrut := { "XB_ALIAS"  , "XB_TIPO"   , "XB_SEQ"    , "XB_COLUNA" , "XB_DESCRI" , "XB_DESCSPA", "XB_DESCENG", ;
             "XB_WCONTEM", "XB_CONTEM" }


aAdd( aSXB, {'SZ1','1','01','DB','Codigo Banco','Codigo Banco','Codigo Banco','','SZ1'} )
aAdd( aSXB, {'SZ1','2','01','01','Codigo','Codigo','Codigo','',''} )
aAdd( aSXB, {'SZ1','2','02','02','Nome','Nombre','Name','','SZ1->Z1_DESCR'} )
aAdd( aSXB, {'SZ1','2','03','03','Nome Reduzido','Nome Reduzido','Nome Reduzido','',''} )
aAdd( aSXB, {'SZ1','3','01','01','Cadastra Novo','Incluye Nuevo','Add New','','01'} )
aAdd( aSXB, {'SZ1','4','01','01','Codigo','Codigo','Codigo','','SZ1->Z1_CODIGO'} )
aAdd( aSXB, {'SZ1','4','01','02','Descricao','Descricao','Descricao','','SZ1->Z1_DESCR'} )
aAdd( aSXB, {'SZ1','4','02','01','Codigo','Codigo','Code','','SZ1->Z1_CODIGO'} )
aAdd( aSXB, {'SZ1','4','02','02','Nome','Nombre','Name','','SZ1->Z1_DESCR'} )
aAdd( aSXB, {'SZ1','4','03','01','Codigo','Codigo','Code','','SZ1->Z1_CODIGO'} )
aAdd( aSXB, {'SZ1','4','03','02','Nome reduzido','Nome reduzido','Short Name','','SZ1->Z1_DREDUZ'} )
aAdd( aSXB, {'SZ1','5','01','','','','','','SZ1->Z1_CODIGO'} )
aAdd( aSXB, {'SZK','1','01','DB','Contas Correntes','Contas Correntes','Contas Correntes','','SZK'} )
aAdd( aSXB, {'SZK','2','01','01','Nome Fornece','Nome Fornece','Nome Fornece','',''} )
aAdd( aSXB, {'SZK','4','01','01','Nome Fornece','Nome Fornece','Nome Fornece','','ZK_NOME'} )
aAdd( aSXB, {'SZK','4','01','02','Num Banco','Num Banco','Num Banco','','ZK_BANCO'} )
aAdd( aSXB, {'SZK','4','01','03','Nro. Agencia','Nro. Agencia','Nro. Agencia','','ZK_AGENCIA'} )
aAdd( aSXB, {'SZK','4','01','04','Nro. Conta','Nro. Conta','Nro. Conta','','ZK_NUMCON'} )
aAdd( aSXB, {'SZK','4','01','05','Nro Poupanca','Nro Poupanca','Nro Poupanca','','ZK_NROPOP'} )
aAdd( aSXB, {'SZK','4','01','06','Nro Cartao','Nro Cartao','Nro Cartao','','ZK_NROCRT'} )
aAdd( aSXB, {'SZK','5','01','','','','','','SZK->ZK_BANCO'} )
aAdd( aSXB, {'SZK','5','02','','','','','','SZK->ZK_AGENCIA'} )
aAdd( aSXB, {'SZK','5','03','','','','','','SZK->ZK_DVAG'} )
aAdd( aSXB, {'SZK','5','04','','','','','','ALLTRIM(SZK->ZK_NUMCON+SZK->ZK_NROPOP+SZK->ZK_NROCRT)'} )
aAdd( aSXB, {'SZK','6','01','','','','','',"M->E2_FORNECE = SZK->ZK_FORNECE .AND. ZK_STATUS = 'A'"} )
aAdd( aSXB, {'SZK001','1','01','DB','Contas Correntes','Contas Correntes','Contas Correntes','','SZK'} )
aAdd( aSXB, {'SZK001','2','01','01','Nome Fornece','Nome Fornece','Nome Fornece','',''} )
aAdd( aSXB, {'SZK001','4','01','01','Nome Fornece','Nome Fornece','Nome Fornece','','ZK_NOME'} )
aAdd( aSXB, {'SZK001','4','01','02','Nro Cartao','Nro Cartao','Nro Cartao','','ZK_NROCRT'} )
aAdd( aSXB, {'SZK001','5','01','','','','','','SZK->ZK_NROCRT'} )
aAdd( aSXB, {'SZK001','6','01','','','','','','SZK->ZK_TIPO == "4"'} )
aAdd( aSXB, {'SZK20','1','01','DB','BANCO FORNECEDOR','BANCO FORNECEDOR','BANCO FORNECEDOR','','SZK'} )
aAdd( aSXB, {'SZK20','2','01','05','Cod Fornece+loja','Cod Fornece+loja','Cod Fornece+loja','',''} )
aAdd( aSXB, {'SZK20','4','01','01','Nome Fornece','Nome Fornece','Nome Fornece','','ZK_NOME'} )
aAdd( aSXB, {'SZK20','4','01','02','Num Banco','Num Banco','Num Banco','','ZK_BANCO'} )
aAdd( aSXB, {'SZK20','4','01','03','Nro. Agencia','Nro. Agencia','Nro. Agencia','','ZK_AGENCIA'} )
aAdd( aSXB, {'SZK20','4','01','04','Nro. Conta','Nro. Conta','Nro. Conta','','ZK_NUMCON'} )
aAdd( aSXB, {'SZK20','4','01','05','Nro Poupanca','Nro Poupanca','Nro Poupanca','','ZK_NROPOP'} )
aAdd( aSXB, {'SZK20','4','01','06','Nro Cartao','Nro Cartao','Nro Cartao','','ZK_NROCRT'} )
aAdd( aSXB, {'SZK20','5','01','','','','','','SZK->ZK_BANCO'} )
aAdd( aSXB, {'SZK20','6','01','','','','','',"ZK_STATUS = 'A'"} )
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

					RecLock( "SXB", .F. )
					FieldPut( FieldPos( aEstrut[nJ] ), aSXB[nI][nJ] )
					dbCommit()
					MsUnLock()

					If !( aSXB[nI][1] $ cAlias )
						cAlias += aSXB[nI][1] + "/"
						AutoGrLog( "Foi alterada a consulta padrão " + aSXB[nI][1] )
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
/*/{Protheus.doc} FSAtuSX5
Função de processamento da gravação do SX5 - Indices

@author TOTVS Protheus
@since  30/04/2015
@obs    Gerado por EXPORDIC - V.4.22.10.7 EFS / Upd. V.4.19.12 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSX5()
Local aEstrut   := {}
Local aSX5      := {}
Local cAlias    := ""
Local nI        := 0
Local nJ        := 0
Local nTamFil   := Len( SX5->X5_FILIAL )

AutoGrLog( "Ínicio da Atualização SX5" + CRLF )

aEstrut := { "X5_FILIAL", "X5_TABELA", "X5_CHAVE", "X5_DESCRI", "X5_DESCSPA", "X5_DESCENG" }

aAdd( aSX5, {'  ','00','06','TIPOS DE CHEQUES','TIPOS DE CHEQUES','CHECKS TYPES'} )
aAdd( aSX5, {'  ','06','01','*USO VER ARGENTINA*','PESOS','PESOS'} )
aAdd( aSX5, {'  ','06','02','*USO VER ARGENTINA*','DOLAR','DOLLAR'} )
aAdd( aSX5, {'  ','06','AC','ACERTO SALDD PREST CTAS CARTAO ITAU S/MOV.CTA CORRENTE','ACERTO SALDD PREST CTAS CARTAO ITAU S/MOV.CTA CORRENTE','ACERTO SALDD PREST CTAS CARTAO ITAU S/MOV.CTA CORRENTE'} )
aAdd( aSX5, {'  ','06','AP','APLICACAO','APLICACAO','APLICACAO'} )
aAdd( aSX5, {'  ','06','BA','BOLSA AUXILIO','BOLSA AUXILIO','BOLSA AUXILIO'} )
aAdd( aSX5, {'  ','06','C1','Praca 24 HS','Compensacion de cheques locales, 24 horas','24 Hour Locality'} )
aAdd( aSX5, {'  ','06','C2','Praca 48 HS','Compensacion de cheques locales, 48 horas','48 Hour Locality'} )
aAdd( aSX5, {'  ','06','C3','Inter. Estado 72 HS','Compensacion de cheques entre provincias, 72 horas','72 Hour Interstate Locality'} )
aAdd( aSX5, {'  ','06','C4','Outros Estados 72 HS','Otras provincias, 72 horas','Other States - 72 Hours'} )
aAdd( aSX5, {'  ','06','C5','Praca dificil acesso','Localidad de dificil acceso','Difficult Access Locality'} )
aAdd( aSX5, {'  ','06','CC','Cartao Credito','Tarjeta de Credito','Credit Card'} )
aAdd( aSX5, {'  ','06','CD','CHEQUE DEVOLVIDO','CHEQUE DEVOLVIDO','CHEQUE DEVOLVIDO'} )
aAdd( aSX5, {'  ','06','CH','Cheque','Cheque','Check'} )
aAdd( aSX5, {'  ','06','DD','DOC DEVOLVIDO','DOC DEVOLVIDO','DOC DEVOLVIDO'} )
aAdd( aSX5, {'  ','06','DE','DEBITOS CARTAO ITAU','DEBITOS CARTAO ITAU','DEBITOS CARTAO ITAU'} )
aAdd( aSX5, {'  ','06','ES','ESTORNO','ESTORNO','ESTORNO'} )
aAdd( aSX5, {'  ','06','FL','FICHA DE LANCAMENTO','FICHA DE LANCAMENTO','FICHA DE LANCAMENTO'} )
aAdd( aSX5, {'  ','06','GE','GENERICO','GENERICO','GENERICO'} )
aAdd( aSX5, {'  ','06','M1','Moeda 1','Moneda 1','Currency 1'} )
aAdd( aSX5, {'  ','06','M2','Moeda 2','Moneda 2','Currency 2'} )
aAdd( aSX5, {'  ','06','M3','Moeda 3','Moneda 3','Currency 3'} )
aAdd( aSX5, {'  ','06','M4','Moeda 4','Moneda 4','Currency 4'} )
aAdd( aSX5, {'  ','06','MC','Mercadorias','Mercaderias','Goods'} )
aAdd( aSX5, {'  ','06','MN','Moeda Nacional','Moneda nacional','National Currency'} )
aAdd( aSX5, {'  ','06','MP','Metais Preciosos','Metales preciosos','Precious Metals'} )
aAdd( aSX5, {'  ','06','NI','NAO IDENTIFICADOS','NAO IDENTIFICADOS','NAO IDENTIFICADOS'} )
aAdd( aSX5, {'  ','06','PN','Papeis Negociaveis','Papeles negociables','Negotiable Papers'} )
aAdd( aSX5, {'  ','06','R$','Dinheiro','Dinero','Cash'} )
aAdd( aSX5, {'  ','06','RC','REGULARIZACAO (N.I.)','REGULARIZACAO (N.I.)','REGULARIZACAO (N.I.)'} )
aAdd( aSX5, {'  ','06','RE','RENDIMENTO','RENDIMENTO','RENDIMENTO'} )
aAdd( aSX5, {'  ','06','RF','RESERVA FINANCEIRA SEM MOV CONTA CORRENTE','RESERVA FINANCEIRA SEM MOV CONTA CORRENTE','RESERVA FINANCEIRA SEM MOV CONTA CORRENTE'} )
aAdd( aSX5, {'  ','06','RG','RESGATE','RESGATE','RESGATE'} )
aAdd( aSX5, {'  ','06','RS','RESERVA FINANCEIRA','RESERVA FINANCEIRA','RESERVA FINANCEIRA'} )
aAdd( aSX5, {'  ','06','TB','TARIFA BANCARIA','TARIFA BANCARIA','TARIFA BANCARIA'} )
aAdd( aSX5, {'  ','06','TR','TRANSFERENCIA','TRANSFERENCIA','TRANSFERENCIA'} )
aAdd( aSX5, {'  ','06','TT','Titulo','Titulo','Bill'} )
aAdd( aSX5, {'  ','06','VL','Vales','Vales','Vouchers'} )
//
// Atualizando dicionário
//
oProcess:SetRegua2( Len( aSX5 ) )

dbSelectArea( "SX5" )
SX5->( dbSetOrder( 1 ) )

For nI := 1 To Len( aSX5 )

	oProcess:IncRegua2( "Atualizando tabelas..." )

	If !SX5->( dbSeek( PadR( aSX5[nI][1], nTamFil ) + aSX5[nI][2] + aSX5[nI][3] ) )
		AutoGrLog( "Item da tabela criado. Tabela " + AllTrim( aSX5[nI][1] ) + aSX5[nI][2] + "/" + aSX5[nI][3] )
		RecLock( "SX5", .T. )
	Else
		AutoGrLog( "Item da tabela alterado. Tabela " + AllTrim( aSX5[nI][1] ) + aSX5[nI][2] + "/" + aSX5[nI][3] )
		RecLock( "SX5", .F. )
	EndIf

	For nJ := 1 To Len( aSX5[nI] )
		If FieldPos( aEstrut[nJ] ) > 0
			FieldPut( FieldPos( aEstrut[nJ] ), aSX5[nI][nJ] )
		EndIf
	Next nJ

	MsUnLock()

	aAdd( aArqUpd, aSX5[nI][1] )

	If !( aSX5[nI][1] $ cAlias )
		cAlias += aSX5[nI][1] + "/"
	EndIf

Next nI

AutoGrLog( CRLF + "Final da Atualização" + " SX5" + CRLF + Replicate( "-", 128 ) + CRLF )

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
@since  30/04/2015
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
	MsgStop( "Não foi possível a abertura da tabela " + ;
	IIf( lShared, "de empresas (SM0).", "de empresas (SM0) de forma exclusiva." ), "ATENÇÃO" )
EndIf

Return lOpen


//--------------------------------------------------------------------
/*/{Protheus.doc} LeLog
Função de leitura do LOG gerado com limitacao de string

@author TOTVS Protheus
@since  30/04/2015
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
