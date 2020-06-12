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
/*/{Protheus.doc} UPCCOM01
Função de update de dicionários para compatibilização

@author TOTVS Protheus
@since  05/11/2014
@obs    Gerado por EXPORDIC - V.4.22.10.7 EFS / Upd. V.4.19.12 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
User Function UPCCOM01( cEmpAmb, cFilAmb )

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
					MsgStop( "Atualização Realizada.", "UPCCOM01" )
				Else
					MsgStop( "Atualização não Realizada.", "UPCCOM01" )
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
			MsgStop( "Atualização não Realizada.", "UPCCOM01" )

		EndIf

	Else
		MsgStop( "Atualização não Realizada.", "UPCCOM01" )

	EndIf

EndIf

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSTProc
Função de processamento da gravação dos arquivos

@author TOTVS Protheus
@since  05/11/2014
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
			

			oProcess:IncRegua1( "Dicionário de tabelas sistema" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSX5()	
			
			oProcess:IncRegua1( "Dicionário de consultas padrão" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSXB()					

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
@since  05/11/2014
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


//
// Tabela SBM
//
aAdd( aSX2, {'SBM',cPath,'SBM'+cEmpr,'Grupo de Produto','Grupo de Producto','Product Group','E','','a508Grupo()','S','BM_FILIAL+BM_GRUPO','BM_GRUPO+BM_DESC','','','E','E',4} )
  
//
// Tabela SZH
//
aAdd( aSX2, {'SZH',cPath,'SZH'+cEmpr,'ESPECIF CRYSTAL PC','ESPECIF CRYSTAL PC','ESPECIF CRYSTAL PC','E','','','','','','','','E','E',0} )

//
// Tabela SZ3
//
aAdd( aSX2, {'SZ3',cPath,'SZ3'+cEmpr,'COND. PAGTO. COT. COMPRA','COND. PAGTO. COT. COMPRA','COND. PAGTO. COT. COMPRA','E','','','','','','','','E','E',0} )

//
// Tabela SZI
//
aAdd( aSX2, {'SZI',cPath,'SZI'+cEmpr,'TB P/IMPRESSAO COTACAO CRYSTAL','TB P/IMPRESSAO COTACAO CRYSTAL','TB P/IMPRESSAO COTACAO CRYSTAL','E','N','','','','','','','E','E',0} )


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
	
		If !( aSX2[nI][1] $ cAlias )
			cAlias += aSX2[nI][1] + "/"
			AutoGrLog( "Foi alterada a tabela " + aSX2[nI][1] )
		EndIf

		RecLock( "SX2", .f. )
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
@since  05/11/2014
@obs    Gerado por EXPORDIC - V.4.22.10.7 EFS / Upd. V.4.19.12 EFS
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
             { "X3_CONDSQL", 0 }, { "X3_CHKSQL" , 0 }, { "X3_IDXSRV" , 0 }, { "X3_ORTOGRA", 0 }, { "X3_TELA"   , 0 }, { "X3_IDXFLD" , 0 }, { "X3_AGRUP"  , 0 }, ;
             { "X3_PYME"   , 0 } }

aEval( aEstrut, { |x| x[2] := SX3->( FieldPos( x[1] ) ) } )

//
// Tabela SB1
//
aAdd( aSX3, {'SB1','06','B1_XESPEC','M',10,0,'Especific.','Especific.','Especific.','Especificacao','Especificacao','Especificacao','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','1','','','','','','','',''} )
aAdd( aSX3, {'SB1','34','B1_XCONMED','N',11,0,'Med. Consumo','Med. Consumo','Med. Consumo','Media de Consumo Mensal','Media de Consumo Mensal','Media de Consumo Mensal','@E 999,999,999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'POSICIONE("SB3",1,XFILIAL("SB3")+M->B1_COD ,"B3_MEDIA")','',0,Chr(254) + Chr(192),'','','U','N','V','R','','','','','','','','','','3','','','','N','','N','',''} )
aAdd( aSX3, {'SB1','36','B1_XEMIND','N',5,0,'PP em Dias','PP em Dias','PP em Dias','Ponto de Pedido em Dias','Ponto de Pedido em Dias','Ponto de Pedido em Dias','@E 99999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','V','R','','U_CESTE07("B1_EMIND")','','','','','','','','3','','','','','','','',''} )
aAdd( aSX3, {'SB1','39','B1_XPEQ','N',12,2,'TC Quant.','TC Quant.','TC Quant.','Cons. no Tempo Compra','Cons. no Tempo Compra','Cons. no Tempo Comprarega','@E 999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','V','R','','U_CESTE07("B1_PEQ")','','','','','','','','3','','','','','','','',''} )
aAdd( aSX3, {'SB1','40','B1_XDIASEG','N',5,0,'Seg. Dias','Seg. Dias','Seg. Dias','Est. de Seguranca em Dias','Est. de Seguranca em Dias','Est. de Seguranca em Dias','@E 99999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','U_CESTE07("B1_ESTSEGD")','','','','','','','','3','','','','','','','',''} )
aAdd( aSX3, {'SB1','42','B1_XLED','N',5,0,'LE Dias','LE Dias','LE Dias','Lote Economico em Dias','Lote Economico em Dias','Lote Economico em Dias','@E 99999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','U_CESTE07("B1_LED")','','','','','','','','3','','','','','','','',''} )
aAdd( aSX3, {'SB1','F4','B1_XBLQSAI','C',1,0,'Bloq.Saida','Bloq.Saida','Bloq.Saida','Bloqueio de Saida','Bloqueio de Saida','Bloqueio de Saida','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"L"','',0,Chr(254) + Chr(192),'','','U','N','A','R','','pertence("LN")','','','','','','','','1','','','','','','','',''} )
aAdd( aSX3, {'SB1','F5','B1_XBLOENT','C',1,0,'Bloq.Entrada','Bloq.Entrada','Bloq.Entrada','Bloqueia Entrada','Bloqueia Entrada','Bloqueia Entrada','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"L"','',0,Chr(254) + Chr(192),'','','U','N','A','R','','pertence("LN")','','','','','','','','1','','','','','','','',''} )
aAdd( aSX3, {'SB1','F6','B1_XOBSER','M',10,0,'Observacoes','Observacoes','Observacoes','Campo para Observacoes','Campo para Observacoes','Campo para Observacoes','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','1','','','','','','','',''} )
aAdd( aSX3, {'SB1','F9','B1_XSDATU','N',14,2,'Sld. Atual','Sld. Atual','Sld. Atual','Saldo Atual','Saldo Atual','Saldo Atual','@E 999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'POSICIONE("SB2",1,XFILIAL("SB2")+SB1->(B1_COD+B1_LOCPAD),"B2_QATU")','',0,Chr(254) + Chr(192),'','','U','S','V','V','','','','','','','','POSICIONE("SB2",1,XFILIAL("SB2")+SB1->(B1_COD+B1_LOCPAD),"B2_QATU")','','3','','','','','','','',''} )
aAdd( aSX3, {'SB1','G0','B1_XSDPED','N',14,2,'Sld. em PC','Sld. em PC','Sld. em PC','Saldo em Pedido de Compra','Saldo em Pedido de Compra','Saldo em Pedido de Compra','@E 999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'U_CESTE06(SB1->B1_COD, .F., .T.)','',0,Chr(254) + Chr(192),'','','U','S','V','V','','','','','','','','U_CESTE06(SB1->B1_COD, .F., .T.)','','3','','','','','','','',''} )
aAdd( aSX3, {'SB1','G1','B1_XSDSOL','N',14,2,'Sld. Solicit','Sld. Solicit','Sld. Solicit','Saldo em Solicitacoes','Saldo em Solicitacoes','Saldo em Solicitacoes','@E 999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'U_CESTE06(SB1->B1_COD, .T., .F.)','',0,Chr(254) + Chr(192),'','','U','S','V','V','','','','','','','','U_CESTE06(SB1->B1_COD, .T., .F.)','','3','','','','','','','',''} )
aAdd( aSX3, {'SB1','G2','B1_XAUTSC','C',1,0,'SC por PP','SC por PP','SC por PP','Sol. Compras por P.Pedido','Sol. Compras por P.Pedido','Sol. Compras por P.Pedido','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"1"','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','1=Sim;2=Näo','1=Sim;2=Näo','1=Sim;2=Näo','','','','','3','','','','','','','',''} )
aAdd( aSX3, {'SB1','G3','B1_XARRED','C',1,0,'Arredonda SC','Arredonda SC','Arredonda SC','Arredonda a Sol. Compra','Arredonda a Sol. Compra','Arredonda a Sol. Compra','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"1"','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','1=Sim;2=Näo','1=Sim;2=Näo','1=Sim;2=Näo','','','','','3','','','','','','','',''} )
aAdd( aSX3, {'SB1','G4','B1_XFATARR','N',6,0,'Fator Arred.','Fator Arred.','Fator Arred.','Fator de Arredondamento','Fator de Arredondamento','Fator de Arredondamento','@E 999,999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','3','','','','','','','',''} )
aAdd( aSX3, {'SB1','G5','B1_XJAN','N',11,0,'Janeiro','Janeiro','Janeiro','Janeiro','Janeiro','Janeiro','@E 999,999,999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'POSICIONE("SB3",1,XFILIAL("SB3")+SB1->B1_COD ,"B3_Q01")','',0,Chr(254) + Chr(192),'','','U','S','V','V','','','','','','','','POSICIONE("SB3",1,XFILIAL("SB3")+SB1->B1_COD ,"B3_Q01")','','4','','','','','','','',''} )
aAdd( aSX3, {'SB1','G6','B1_XFEV','N',11,0,'Fevereiro','Fevereiro','Fevereiro','Fevereiro','Fevereiro','Fevereiro','@E 999,999,999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'POSICIONE("SB3",1,XFILIAL("SB3")+SB1->B1_COD ,"B3_Q02")','',0,Chr(254) + Chr(192),'','','U','S','V','V','','','','','','','','POSICIONE("SB3",1,XFILIAL("SB3")+SB1->B1_COD ,"B3_Q02")','','4','','','','','','','',''} )
aAdd( aSX3, {'SB1','G7','B1_XMAR','N',11,0,'Marco','Marco','Marco','Marco','Marco','Marco','@E 999,999,999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'POSICIONE("SB3",1,XFILIAL("SB3")+SB1->B1_COD ,"B3_Q03")','',0,Chr(254) + Chr(192),'','','U','S','V','V','','','','','','','','POSICIONE("SB3",1,XFILIAL("SB3")+SB1->B1_COD ,"B3_Q03")','','4','','','','','','','',''} )
aAdd( aSX3, {'SB1','G8','B1_XABR','N',11,0,'Abril','Abril','Abril','Abril','Abril','Abril','@E 999,999,999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'POSICIONE("SB3",1,XFILIAL("SB3")+SB1->B1_COD ,"B3_Q04")','',0,Chr(254) + Chr(192),'','','U','S','V','V','','','','','','','','POSICIONE("SB3",1,XFILIAL("SB3")+SB1->B1_COD ,"B3_Q04")','','4','','','','','','','',''} )
aAdd( aSX3, {'SB1','G9','B1_XMAI','N',11,0,'Maio','Maio','Maio','Maio','Maio','Maio','@E 999,999,999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'POSICIONE("SB3",1,XFILIAL("SB3")+SB1->B1_COD ,"B3_Q05")','',0,Chr(254) + Chr(192),'','','U','S','V','V','','','','','','','','POSICIONE("SB3",1,XFILIAL("SB3")+SB1->B1_COD ,"B3_Q05")','','4','','','','','','','',''} )
aAdd( aSX3, {'SB1','H0','B1_XJUN','N',11,0,'Junho','Junho','Junho','Junho','Junho','Junho','@E 999,999,999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'POSICIONE("SB3",1,XFILIAL("SB3")+SB1->B1_COD ,"B3_Q06")','',0,Chr(254) + Chr(192),'','','U','S','V','V','','','','','','','','POSICIONE("SB3",1,XFILIAL("SB3")+SB1->B1_COD ,"B3_Q06")','','4','','','','','','','',''} )
aAdd( aSX3, {'SB1','H1','B1_XJUL','N',11,0,'Julho','Julho','Julho','Julho','Julho','Julho','@E 999,999,999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'POSICIONE("SB3",1,XFILIAL("SB3")+SB1->B1_COD ,"B3_Q07")','',0,Chr(254) + Chr(192),'','','U','S','V','V','','','','','','','','POSICIONE("SB3",1,XFILIAL("SB3")+SB1->B1_COD ,"B3_Q07")','','4','','','','','','','',''} )
aAdd( aSX3, {'SB1','H2','B1_XAGO','N',11,0,'Agosto','Agosto','Agosto','Agosto','Agosto','Agosto','@E 999,999,999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'POSICIONE("SB3",1,XFILIAL("SB3")+SB1->B1_COD ,"B3_Q08")','',0,Chr(254) + Chr(192),'','','U','S','V','V','','','','','','','','POSICIONE("SB3",1,XFILIAL("SB3")+SB1->B1_COD ,"B3_Q08")','','4','','','','','','','',''} )
aAdd( aSX3, {'SB1','H3','B1_XSET','N',11,0,'Setembro','Setembro','Setembro','Setembro','Setembro','Setembro','@E 999,999,999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'POSICIONE("SB3",1,XFILIAL("SB3")+SB1->B1_COD ,"B3_Q09")','',0,Chr(254) + Chr(192),'','','U','S','V','V','','','','','','','','POSICIONE("SB3",1,XFILIAL("SB3")+SB1->B1_COD ,"B3_Q09")','','4','','','','','','','',''} )
aAdd( aSX3, {'SB1','H4','B1_XOUT','N',11,0,'Outubro','Outubro','Outubro','Outubro','Outubro','Outubro','@E 999,999,999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'POSICIONE("SB3",1,XFILIAL("SB3")+SB1->B1_COD ,"B3_Q10")','',0,Chr(254) + Chr(192),'','','U','S','V','V','','','','','','','','POSICIONE("SB3",1,XFILIAL("SB3")+SB1->B1_COD ,"B3_Q10")','','4','','','','','','','',''} )
aAdd( aSX3, {'SB1','H5','B1_XNOV','N',11,0,'Novembro','Novembro','Novembro','Novembro','Novembro','Novembro','@E 999,999,999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'POSICIONE("SB3",1,XFILIAL("SB3")+SB1->B1_COD ,"B3_Q11")','',0,Chr(254) + Chr(192),'','','U','S','V','V','','','','','','','','POSICIONE("SB3",1,XFILIAL("SB3")+SB1->B1_COD ,"B3_Q11")','','4','','','','','','','',''} )
aAdd( aSX3, {'SB1','H6','B1_XDEZ','N',11,0,'Dezembro','Dezembro','Dezembro','Dezembro','Dezembro','Dezembro','@E 999,999,999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'POSICIONE("SB3",1,XFILIAL("SB3")+SB1->B1_COD ,"B3_Q12")','',0,Chr(254) + Chr(192),'','','U','S','V','V','','','','','','','','POSICIONE("SB3",1,XFILIAL("SB3")+SB1->B1_COD ,"B3_Q12")','','4','','','','','','','',''} )
aAdd( aSX3, {'SB1','H7','B1_XLOCAL','C',1,0,'Localizacao','Localizacao','Localizacao','Localizacao','Localizacao','Localizacao','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','S=Sede;U=Unidade;A=Ambos','S=Sede;U=Unidade;A=Ambos','S=Sede;U=Unidade;A=Ambos','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SB1','K0','B1_XMULTI','C',4,0,'Multiplos','Multiplos','Multiplos','Multiplos','Multiplos','Multiplos','9999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"1"','',0,Chr(254) + Chr(192),'','','U','N','A','R','€','','','','','','','','','1','','','','','','','',''} )
aAdd( aSX3, {'SB1','N2','B1_XATIVO','C',1,0,'Ativo Imob.','Ativo Imob.','Ativo Imob.','Ativo Imob.','Ativo Imob.','Ativo Imob.','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','V','R','','','1=Sim;2=Nao','','','','','','','','','','','N','','N','',''} )
aAdd( aSX3, {'SB1','U3','B1_XUNIFRH','C',1,0,'Uniforme RH','Uniforme RH','Uniforme RH','Uniforme Colaborador RH','Uniforme Colaborador RH','Uniforme Colaborador RH','9','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(254) + Chr(192),'','','U','N','A','R','','Pertence(" SN")','S=Sim;N=Não','','','','','','','1','','','','N','','N','',''} )

//
// Tabela SBM
//
aAdd( aSX3, {'SBM','15','BM_XCONTA1','C',20,0,'Cta. Estoque','Cta. Estoque','Cta. Estoque','Conta de Estoque','Conta de Estoque','Conta de Estoque','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CT1',0,Chr(254) + Chr(192),'','S','U','N','A','R','','vazio() .or. ExistCpo("CT1")','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SBM','16','BM_XCONTA2','C',20,0,'Cta. Despesa','Cta. Despesa','Cta. Despesa','Conta Despesa','Conta Despesa','Conta Despesa','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CT1',0,Chr(254) + Chr(192),'','S','U','N','A','R','','Vazio() .or. ExistCpo("CT1")','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SBM','17','BM_XDIASEG','N',5,0,'Seguranca','Seguranca','Seguranca','Estoque de Seguranca','Estoque de Seguranca','Estoque de Seguranca','@E 99999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SBM','18','BM_XPE','N',5,0,'Entrega','Entrega','Entrega','Prazo de Entrega','Prazo de Entrega','Prazo de Entrega','@E 99999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SBM','21','BM_XCTRED1','C',10,0,'Conta Reduzi','Conta Reduzi','Conta Reduzi','Conta Reduzi','Conta Reduzi','Conta Reduzi','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SBM','22','BM_XCTRED2','C',10,0,'Conta Reduzi','Conta Reduzi','Conta Reduzi','Conta Reduzi','Conta Reduzi','Conta Reduzi','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SBM','26','BM_XTES','C',3,0,'TES','TES','TES','Tipo de Entrada e Sada','Tipo de Entrada e Sada','Tipo de Entrada e Sada','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','Vazio() .or. ExistCpo("SF4", M->BM_XTES)','','','','','','','','','','','','N','','N','',''} )


//
// Tabela SA2
//
aAdd( aSX3, {'SA2','04','A2_XPISNIT','C',11,0,'PIS/NIT','PIS/NIT','PIS/NIT','PIS/NIT','PIS/NIT','PIS/NIT','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','1','','','','N','','N','',''} )
aAdd( aSX3, {'SA2','10','A2_XTPFOR','C',1,0,'Tp Registro','Tp Registro','Tp Registro','Tipo do Registro','Tipo do Registro','Tipo do Registro','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','€','Pertence("129 ")','1=Fornecedor;2=Funcionario;9=Outros','1=Fornecedor;2=Funcionario;9=Outros','1=Fornecedor;2=Funcionario;9=Outros','','','','','1','','','','','','','',''} )
aAdd( aSX3, {'SA2','28','A2_XCEL','C',25,0,'Celular','Celular','Celular','Celular','Celular','Celular','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','1','','','','','','','',''} )
aAdd( aSX3, {'SA2','31','A2_XTELFI','C',25,0,'Tel.Financ.','Tel.Financ.','Tel.Financ.','Telefone Financeiro','Telefone Financeiro','Telefone Financeiro','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','1','','','','','','','',''} )
aAdd( aSX3, {'SA2','32','A2_XCONTFI','C',15,0,'Cont.Financ.','Cont.Financ.','Cont.Financ.','Contato Financeiro','Contato Financeiro','Contato Financeiro','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','1','','','','','','','',''} )
aAdd( aSX3, {'SA2','36','A2_XPROSPE','C',1,0,'Prospect','Prospect','Prospect','Prospect','Prospect','Prospect','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"N"','',0,Chr(254) + Chr(192),'','','U','S','A','R','€','Pertence("SN ")','S=Sim;N=Nao','S=Si;N=No','S=Yes;N=No','','','','','1','','','','','','','',''} )
aAdd( aSX3, {'SA2','39','A2_XDVAG','C',1,0,'Dv. Agencia','Dv. Agencia','Dv. Agencia','Digito Verificador','Digito Verificador','Digito Verificador','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','2','','','','','','','',''} )
aAdd( aSX3, {'SA2','42','A2_XCCPOUP','C',1,0,'Conta Tipo','Conta Tipo','Conta Tipo','Conta Tipo','Conta Tipo','Conta Tipo','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'" "','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','1=C.C.;2=Poupanca','','','','','','','2','','','','','','','',''} )
aAdd( aSX3, {'SA2','49','A2_XFORPGT','C',30,0,'Forma Pagto.','Forma Pagto.','Forma Pagto.','Forma de Pagamento','Forma de Pagamento','Forma de Pagamento','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','1','','','','','','','',''} )
aAdd( aSX3, {'SA2','50','A2_XCONDDE','C',20,0,'Descricao','Descricao','Descricao','Descricao','Descricao','Descricao','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','V','R','','','','','','','','','','1','','','','','','','',''} )
aAdd( aSX3, {'SA2','91','A2_XREDUZ','C',20,0,'Cta Reduzida','Cta Reduzida','Cta Reduzida','Conta Reduzida','Conta Reduzida','Conta Reduzida','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"2110111"','CTD',0,Chr(254) + Chr(192),'','S','U','N','A','R','€','Vazio() .or. ExistCPO("CTD",M->A2_XREDUZ)','','','','','','','','1','','','','N','','N','',''} )
aAdd( aSX3, {'SA2','C1','A2_XOBSERV','M',10,0,'Observacoes','Observacoes','Observacoes','Observacoes','Observacoes','Observacoes','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SA2','C2','A2_XVRACUR','N',18,2,'Vlr.Acum. R$','Vlr.Acum. R$','Vlr.Acum. R$','Vr.Acum.em Reais','Vr.Acum.em Reais','Vr.Acum.em Reais','@E 999,999,999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','V','R','','','','','','','','','','6','','','','','','','',''} )
aAdd( aSX3, {'SA2','C3','A2_XMAXATR','C',21,0,'Maior Atraso','Maior Atraso','Maior Atraso','Maior Atraso','Maior Atraso','Maior Atraso','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','6','','','','','','','',''} )
aAdd( aSX3, {'SA2','C4','A2_XDATREF','D',8,0,'Dt. cadast.','Dt. cadast.','Dt. cadast.','Data de cadastro','Data de cadastro','Data de cadastro','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'DDATABASE','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','1','','','','','','','',''} )
aAdd( aSX3, {'SA2','C5','A2_XMEDATR','N',4,0,'Med. Atraso','Med. Atraso','Med. Atraso','Media Atraso por Pedido','Media Atraso por Pedido','Media Atraso por Pedido','@E 999.9','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',0,Chr(254) + Chr(192),'','','U','N','V','R','','','','','','','','','','4','','','','','','','',''} )
aAdd( aSX3, {'SA2','C6','A2_XVRACUD','N',18,2,'Vlr.Acum.US$','Vlr.Acum.US$','Vlr.Acum.US$','Vlr.Acum.em Dolar','Vlr.Acum.em Dolar','Vlr.Acum.em Dolar','@E 999,999,999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','V','R','','','','','','','','','','6','','','','','','','',''} )
aAdd( aSX3, {'SA2','C7','A2_XATRDIA','N',4,0,'Atr.em Dias','Atr.em Dias','Atr.em Dias','Maior atraso em Dias','Maior atraso em Dias','Maior atraso em Dias','@E 9999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',0,Chr(254) + Chr(192),'','','U','N','V','R','','','','','','','','','','4','','','','','','','',''} )
aAdd( aSX3, {'SA2','C8','A2_XPERDES','N',6,2,'Perc.Descont','Perc.Descont','Perc.Descont','Media Perc.Desconto','Media Perc.Desconto','Media Perc.Desconto','@E 999.99%','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',0,Chr(254) + Chr(192),'','','U','N','V','R','','','','','','','','','','4','','','','','','','',''} )
aAdd( aSX3, {'SA2','C9','A2_XVLRDES','N',18,2,'Vr.Med.Desc','Vr.Med.Desc','Vr.Med.Desc','Valor Medio de Desconto','Valor Medio de Desconto','Valor Medio de Desconto','@E 999,999,999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',0,Chr(254) + Chr(192),'','','U','N','V','R','','','','','','','','','','4','','','','','','','',''} )
aAdd( aSX3, {'SA2','D0','A2_XPERCON','N',6,2,'Perc.Concorr','Perc.Concorr','Perc.Concorr','Perc.de Concor. Atendidas','Perc.de Concor. Atendidas','Perc.de Concor. Atendidas','@E 999.99%','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',0,Chr(254) + Chr(192),'','','U','N','V','R','','','','','','','','','','4','','','','','','','',''} )
aAdd( aSX3, {'SA2','D1','A2_XGRP01','C',4,0,'Grupo 1','Grupo 1','Grupo 1','Grupo de produtos 1','Grupo de produtos 1','Grupo de produtos 1','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','SBM',0,Chr(254) + Chr(192),'','','U','S','A','R','€','AllTrim(M->A2_XGRP01) == "00".or. ExistCPO("SBM")','','','','','','','','1','','','','','','','',''} )
aAdd( aSX3, {'SA2','D2','A2_XGRP02','C',4,0,'Grupo 2','Grupo 2','Grupo 2','Grupo de produtos 2','Grupo de produtos 2','Grupo de produtos 2','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','SBM',0,Chr(254) + Chr(192),'','','U','N','A','R','','Vazio() .or. ExistCPO("SBM")','','','','','','','','1','','','','','','','',''} )
aAdd( aSX3, {'SA2','D3','A2_XGRP03','C',4,0,'Grupo 3','Grupo 3','Grupo 3','Grupo de produtos 3','Grupo de produtos 3','Grupo de produtos 3','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','SBM',0,Chr(254) + Chr(192),'','','U','N','A','R','','Vazio() .or. ExistCPO("SBM")','','','','','','','','1','','','','','','','',''} )
aAdd( aSX3, {'SA2','D4','A2_XPRODUT','C',30,0,'Prod vendido','Prod vendido','Prod vendido','Produto vendido pelo forn','Produto vendido pelo forn','Produto vendido pelo forn','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','1','','','','','','','',''} )
aAdd( aSX3, {'SA2','D5','A2_XQTDCOT','N',5,0,'Qtd.Cotacoes','Qtd.Cotacoes','Qtd.Cotacoes','Quantidade de Cotacoes','Quantidade de Cotacoes','Quantidade de Cotacoes','@E 99999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',0,Chr(254) + Chr(192),'','','U','N','V','R','','','','','','','','','','4','','','','','','','',''} )
aAdd( aSX3, {'SA2','D6','A2_XCONV','C',1,0,'Convenente','Convenente','Convenente','Convenente','Convenente','Convenente','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"N"','',0,Chr(254) + Chr(192),'','S','U','S','A','R','','Pertence("SN ")','S=Sim;N=Nao;I=Irregular','S=Si;N=No;I=Irregular','S=Yes;N=No;I=Irregular','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SA2','D7','A2_XQTCOTV','N',5,0,'Cots. Ganhas','Cots. Ganhas','Cots. Ganhas','Cotacoes Ganhas','Cotacoes Ganhas','Cotacoes Ganhas','@E 99999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',0,Chr(254) + Chr(192),'','','U','N','V','R','','','','','','','','','','4','','','','','','','',''} )
aAdd( aSX3, {'SA2','D8','A2_XESTNUM','N',4,0,'Estagiarios','Estagiarios','Estagiarios','Estagiarios','Estagiarios','Estagiarios','@E 9999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','S','U','S','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SA2','D9','A2_XDTAUC','D',8,0,'Data Ult.Com','Data Ult.Com','Data Ult.Com','Data da Ultima Compra','Data da Ultima Compra','Data da Ultima Compra','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','8','','','','','','','',''} )
aAdd( aSX3, {'SA2','E0','A2_XVLRUC','N',14,2,'Vlr Ult.Com.','Vlr Ult.Com.','Vlr Ult.Com.','Valor da Ultima Compra','Valor da Ultima Compra','Valor da Ultima Compra','@E 999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','8','','','','','','','',''} )
aAdd( aSX3, {'SA2','E1','A2_XMCOMP','C',28,0,'Maior Compra','Maior Compra','Maior Compra','Maior Compra c/ esse forn','Maior Compra c/ esse forn','Maior Compra c/ esse forn','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','6','','','','','','','',''} )
aAdd( aSX3, {'SA2','E2','A2_XCOTVE1','C',7,0,'Cots. Vencid','Cots. Vencid','Cots. Vencid','Cotacoes vencidas','Cotacoes vencidas','Cotacoes vencidas','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','6','','','','','','','',''} )
aAdd( aSX3, {'SA2','E3','A2_XCOTVE2','N',6,2,'Vencedor','Vencedor','Vencedor','Vencedor','Vencedor','Vencedor','@E 999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','V','V','','','','','','','','','','6','','','','','','','',''} )
aAdd( aSX3, {'SA2','E4','A2_XMDESC','C',37,0,'Maior Descon','Maior Descon','Maior Descon','Maior Desconto','Maior Desconto','Maior Desconto','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','6','','','','','','','',''} )
aAdd( aSX3, {'SA2','E5','A2_XDESCUC','C',24,0,'Desc.Ult.Com','Desc.Ult.Com','Desc.Ult.Com','Desconto da Ultima Compra','Desconto da Ultima Compra','Desconto da Ultima Compra','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','8','','','','','','','',''} )
aAdd( aSX3, {'SA2','E6','A2_XATRUC','N',9,0,'Atraso UC','Atraso UC','Atraso UC','Atraso da ultima compra','Atraso da ultima compra','Atraso da ultima compra','@E 999999999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','8','','','','','','','',''} )
aAdd( aSX3, {'SA2','G8','A2_XUNIFAT','N',9,0,'Unid Faturam','Unid Faturam','Unid Faturam','Unidade de Faturamento','Unidade de Faturamento','Unidade de Faturamento','@E 999999999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','2','','','','','','','',''} )
aAdd( aSX3, {'SA2','H0','A2_XMATRIC','C',7,0,'Matricula','Matricula','Matricula','Matricula','Matricula','Matricula','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )


//
// Tabela SC1
//
aAdd( aSX3, {'SC1','24','C1_SOLICIT','C',25,0,'Comprador','Solicitante','Petitioner','Nome do Comprador','Nombre del Solicitante','Name of Petitioner','@S25','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'UsrRetName(RetCodUsr())','USC',1,Chr(145) + Chr(128),'','','','N','A','R','€','U_CCOME09(M->C1_SOLICIT)','','','','','','','','','','','N','N','','N','','S'} )

aAdd( aSX3, {'SC1','03','C1_XNUCIEE','C',6,0,'Num. CIEE SC','Num. CIEE SC','Num. CIEE SC','Num. CIEE SC','Num. CIEE SC','Num. CIEE SC','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(254) + Chr(192),'','','','S','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SC1','09','C1_XESPEC','M',10,0,'Especif.','Especif.','Especif.','Especif.','Especif.','Especif.','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','V','R','','','','','','','','','','','','','','N','','N','',''} )
aAdd( aSX3, {'SC1','13','C1_XQTDCAL','N',12,2,'Calculo Qtde','Calculo Qtde','Calculo Qtde','Quantidade Calculada','Quantidade Calculada','Quantidade Calculada','@E 999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SC1','18','C1_XOBSDET','M',10,0,'Obs. Detalhe','Obs. Detalhe','Obs. Detalhe','Observacäo detalhada','Observacäo detalhada','Observacäo detalhada','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SC1','25','C1_XFORNOM','C',30,0,'Fornecedor','Fornecedor','Fornecedor','Nome do Fornecedor','Nome do Fornecedor','Nome do Fornecedor','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','V','','','','','','','','POSICIONE("SA2",1,XFILIAL("SA2") + SC1->(C1_FORNECE + C1_LOJA),"A2_NOME")','','','','','','','','','',''} )
aAdd( aSX3, {'SC1','50','C1_XSOLAUX','C',15,0,'Comprador','Comprador','Comprador','Comprador','Comprador','Comprador','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','V','','','','','','','','SC1->C1_SOLICIT','','','','','','','','','',''} )
          
//
// Tabela SC8
//

aAdd( aSX3, {'SC8','19','C8_XFORNOM','C',60,0,'Forn. Nome','Forn. Nome','Forn. Nome','Nome do Fornecedor','Nome do Fornecedor','Nome do Fornecedor','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'POSICIONE("SA2",1,XFILIAL("SA2") + SC8->(C8_FORNECE + C8_LOJA),"A2_NOME")','',0,Chr(254) + Chr(192),'','','U','S','V','V','','','','','','','','POSICIONE("SA2",1,XFILIAL("SA2") + SC8->(C8_FORNECE + C8_LOJA),"A2_NOME")','','','','','','','','','',''} )
aAdd( aSX3, {'SC8','33','C8_XACERTO','N',14,2,'Vlr. Acerto','Vlr. Acerto','Vlr. Acerto','Valor de acerto','Valor de acerto','Valor de acerto','@E 999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SC8','65','C8_XCOTSTS','C',1,0,'Status Cot.','Status Cot.','Status Cot.','Status da Cotacao','Status da Cotacao','Status da Cotacao','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SC8','66','C8_XBASISS','N',14,2,'Base ISS','Base ISS','Base ISS','Valor base do ISS','Valor base do ISS','Valor base do ISS','@E 999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SC8','67','C8_XVALISS','N',14,2,'Vlr. ISS','Vlr. ISS','Vlr. ISS','Valor do ISS','Valor do ISS','Valor do ISS','@E 999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SC8','68','C8_XALIISS','N',5,2,'Aliq. ISS','Aliq. ISS','Aliq. ISS','Aliquota ISS','Aliquota ISS','Aliquota ISS','@E 99.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SC8','69','C8_XOBSMEM','M',10,0,'Observacäo','Observacäo','Observacäo','Observacäo','Observacäo','Observacäo','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SC8','82','C8_XSOLICI','C',20,0,'Solicitante','Solicitante','Solicitante','Solicitante','Solicitante','Solicitante','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','N','',''} )

//
// Tabela SZH
//

aAdd( aSX3, {'SZH','01','ZH_FILIAL','C',2,0,'Filial','Sucursal','Branch','Filial do Sistema','Sucursal','Branch of the System','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(254) + Chr(192),'','','U','N','','','','','','','','','','','033','','','','','','','','',''} )
aAdd( aSX3, {'SZH','02','ZH_NUM','C',6,0,'Num PC','Num PC','Num PC','Num PC','Num PC','Num PC','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZH','03','ZH_PESSOA1','C',40,0,'Pessoa 1','Pessoa 1','Pessoa 1','Pessoa 1','Pessoa 1','Pessoa 1','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZH','04','ZH_PESSOA2','C',40,0,'PEssoa 2','PEssoa 2','PEssoa 2','PEssoa 2','PEssoa 2','PEssoa 2','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZH','05','ZH_PESSOA3','C',40,0,'Pessoa 3','Pessoa 3','Pessoa 3','Pessoa 3','Pessoa 3','Pessoa 3','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZH','06','ZH_PESSOA4','C',40,0,'Pessoa 4','Pessoa 4','Pessoa 4','Pessoa 4','Pessoa 4','Pessoa 4','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZH','07','ZH_PESSOA5','C',40,0,'Pessoa 5','Pessoa 5','Pessoa 5','Pessoa 5','Pessoa 5','Pessoa 5','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZH','08','ZH_LOCAL','C',100,0,'Local','Local','Local','Local','Local','Local','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZH','09','ZH_OBS','M',10,0,'Obs','Obs','Obs','Obs','Obs','Obs','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','','','','','','','','',''} )
//
// Tabela SD3
//     
aAdd( aSX3, {'SD3','03','D3_COD','C',15,0,'Produto','Producto','Product','Codigo do Produto','Codigo del Producto','Product Code','@!','A093Prod().And.A241PrdGrd() .And. NGCOQPR()',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','SB1',1,Chr(131) + Chr(128),'','S','','S','A','R','','u_CESTE08()','','','','','','','030','','',"#D3_COD    <>'               '",'S','N','','1','N',''} )
aAdd( aSX3, {'SD3','88','D3_XUSERLG','C',25,0,'Log Usuario','Log Usuario','Log Usuario','Login Usuario','Login Usuario','Login Usuario','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','N','',''} )
aAdd( aSX3, {'SD3','89','D3_XGEROPV','C',1,0,'Gerou PV','Gerou PV','Gerou PV','Gerou Pedido de Vendas','Gerou Pedido de Vendas','Gerou Pedido de Vendas','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','Pertence("SN ")','S=Sim;N=Nao','','','','','','','','','','','N','','N','',''} )


//
// Tabela CTT
// 
aAdd( aSX3, {'CTT','22','CTT_XLOCAL','C',1,0,'Localizacäo','Localizacäo','Localizacäo','Localizacäo','Localizacäo','Localizacäo','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','€','','1=Sede;2=Unidade;3=Näo Gera','1=Sede;2=Unidade;3=Näo Gera','1=Sede;2=Unidade;3=Näo Gera','','','','','','','','','','','','',''} )
aAdd( aSX3, {'CTT','55','CTT_XDP06','C',11,0,'Cod Identif','Cod Identif','Cod Identif','Codigo Identificado','Codigo Identificado','Codigo Identificado','@R 99999-9','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'CTT','58','CTT_XCODAT','C',2,0,'Cod. Ativid.','Cod. Ativid.','Cod. Ativid.','Cod. Ativid.','Cod. Ativid.','Cod. Ativid.','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','€','','','','','','','','','','','','','N','','N','',''} )
aAdd( aSX3, {'CTT','59','CTT_XDESAT','C',50,0,'Desc. Ativid','Desc. Ativid','Desc. Ativid','Desc. Ativid','Desc. Ativid','Desc. Ativid','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','€','','','','','','','','','','','','','N','','N','',''} )
aAdd( aSX3, {'CTT','79','CTT_XKITAP','C',1,0,'Kit Aprendiz','Kit Aprendiz','Kit Aprendiz','Kit Aprendiz','Kit Aprendiz','Kit Aprendiz','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"1"','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','1=CR01;2=CR02','','','','','','','','','','','N','','N','',''} )
aAdd( aSX3, {'CTT','80','CTT_XCDCLI','C',6,0,'Cod.Cliente','Cod.Cliente','Cod.Cliente','Cod.Cliente','Cod.Cliente','Cod.Cliente','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','SA1',0,Chr(254) + Chr(192),'','','U','N','A','R','','Vazio() .or. ExistCPO("SA1", M->CTT_CODCLI)','','','','','','','','','','','','N','','N','',''} )
aAdd( aSX3, {'CTT','81','CTT_XLJCLI','C',2,0,'Loja Cliente','Loja Cliente','Loja Cliente','Loja Cliente','Loja Cliente','Loja Cliente','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','V','R','','','','','','','','','','','','','','N','','N','',''} )
aAdd( aSX3, {'CTT','82','CTT_XCDTRA','C',6,0,'Cod Transpor','Cod Transpor','Cod Transpor','Cod Transpor','Cod Transpor','Cod Transpor','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','SA4',0,Chr(254) + Chr(192),'','','U','N','A','R','','Vazio() .or. ExistCPO("SA4", M->CTT_CODTRA)','','','','','','','','','','','','N','','N','',''} )

//
// Tabela SZ3
// 
aAdd( aSX3, {'SZ3','01','Z3_FILIAL','C',2,0,'Filial','Sucursal','Branch','Filial do Sistema','Sucursal','Branch of the System','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(254) + Chr(192),'','','U','N','','','','','','','','','','','033','','','','','','','','',''} )
aAdd( aSX3, {'SZ3','02','Z3_NUMCOT','C',6,0,'Cotacäo','Cotacäo','Cotacäo','Numero da Cotacäo','Numero da Cotacäo','Numero da Cotacäo','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZ3','03','Z3_FORNECE','C',6,0,'Fornecedor','Fornecedor','Fornecedor','Codigo do Fornecedor','Codigo do Fornecedor','Codigo do Fornecedor','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZ3','04','Z3_LOJA','C',2,0,'Loja','Loja','Loja','Loja do Fornecedor','Loja do Fornecedor','Loja do Fornecedor','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZ3','05','Z3_ITEM','C',2,0,'Item','Item','Item','Item da Cotacao','Item da Cotacao','Item da Cotacao','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZ3','06','Z3_PRODUTO','C',15,0,'Produto','Produto','Produto','Produto Cotado','Produto Cotado','Produto Cotado','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZ3','07','Z3_PARCELA','C',2,0,'Parcela','Parcela','Parcela','Numero da Parcela.','Numero da Parcela.','Numero da Parcela.','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'STRZERO(N, 2)','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZ3','08','Z3_DATA','D',8,0,'Data Pgto','Data Pgto','Data Pgto','Data do Pagamento','Data do Pagamento','Data do Pagamento','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZ3','09','Z3_PERCENT','N',6,2,'Percentual','Percentual','Percentual','Percentual','Percentual','Percentual','@E 999.99%','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'100','',0,Chr(254) + Chr(192),'','S','U','S','A','R','','Entre(0, 100, M->Z3_PERCENT)','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZ3','10','Z3_VALOR','N',14,2,'Valor','Valor','Valor','Valor da Prestacäo','Valor da Prestacäo','Valor da Prestacäo','@E 999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'_NTOTAL','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZ3','11','Z3_OK','C',2,0,'Uso Interno','Uso Interno','Uso Interno','Uso Interno do Sistema','Uso Interno do Sistema','Uso Interno do Sistema','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZ3','12','Z3_DIAS','N',3,0,'Dias p/ Pgto','Dias p/ Pgto','Dias p/ Pgto','Dias para o pagamento','Dias para o pagamento','Dias para o pagamento','@e 999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','S','U','S','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZ3','13','Z3_TIPO','C',1,0,'Tipo Pgto.','Tipo Pgto.','Tipo Pgto.','Tipo de Pagamento','Tipo de Pagamento','Tipo de Pagamento','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"N"','',0,Chr(254) + Chr(192),'','','U','S','A','R','','Pertence("PND ")','','','','','','','','','','','','','','','',''} )

//
// Tabela SZI
// 
aAdd( aSX3, {'SZI','01','ZI_FILIAL','C',2,0,'Filial','Sucursal','Branch','Filial do Sistema','Sucursal','Branch of the System','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',0,Chr(128) + Chr(128),'','','U','N','','','','','','','','','','','033','','','','','','','','',''} )
aAdd( aSX3, {'SZI','02','ZI_NUMSC','C',6,0,'Nro SC','Nro SC','Nro SC','Nro Solicitacao compras','Nro Solicitacao compras','Nro Solicitacao compras','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZI','03','ZI_PRODUTO','C',15,0,'Cod.Produto','Cod.Produto','Cod.Produto','Cod.Produto','Cod.Produto','Cod.Produto','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZI','04','ZI_CODFOR1','C',6,0,'Cod.Fornec.','Cod.Fornec.','Cod.Fornec.','Cod.Fornecedor','Cod.Fornecedor','Cod.Fornecedor','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZI','05','ZI_QTD','N',12,2,'Quantidade','Quantidade','Quantidade','Quantidade','Quantidade','Quantidade','@E 999999999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZI','06','ZI_PRECO','N',16,4,'Pr. Unitario','Pr. Unitario','Pr. Unitario','Preco unitario','Preco unitario','Preco unitario','@E 999,999,999.9999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZI','07','ZI_TOTAL','N',18,2,'Vlr.Total','Vlr.Total','Vlr.Total','Vlr.Total','Vlr.Total','Vlr.Total','@E 999,999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZI','08','ZI_OBS','M',10,0,'Observacao','Observacao','Observacao','Observacao','Observacao','Observacao','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZI','09','ZI_PRAZO','N',4,0,'Prazo','Prazo','Prazo','Prazo','Prazo','Prazo','@E 9999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZI','10','ZI_DESCONT','N',5,2,'Desconto','Desconto','Desconto','Desconto','Desconto','Desconto','@E 999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZI','11','ZI_VLDESC','N',14,2,'Vlr.Descont','Vlr.Descont','Vlr.Descont','Vlr.Descont','Vlr.Descont','Vlr.Descont','@E 999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZI','12','ZI_VALIPI','N',14,2,'Vlr.IPI','Vlr.IPI','Vlr.IPI','Vlr.IPI','Vlr.IPI','Vlr.IPI','@E 999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZI','13','ZI_PERCIPI','N',5,2,'Perc.IPI','Perc.IPI','Perc.IPI','Perc.IPI','Perc.IPI','Perc.IPI','@E 999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZI','14','ZI_PICM','N',5,2,'ICM','ICM','ICM','ICM','ICM','ICM','@E 999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZI','15','ZI_DESCPRO','C',60,0,'Desc.prod','Desc.prod','Desc.prod','Desc.produto','Desc.produto','Desc.produto','@!S30','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZI','16','ZI_NOMFOR','C',20,0,'Nome forn.','Nome forn.','Nome forn.','Nome forn.','Nome forn.','Nome forn.','@S30','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZI','17','ZI_VENCEDO','C',1,0,'Vencedor','Vencedor','Vencedor','Vencedor','Vencedor','Vencedor','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZI','18','ZI_CODFOR2','C',6,0,'Cod.Fornec.','Cod.Fornec.','Cod.Fornec.','Cod.Fornecedor','Cod.Fornecedor','Cod.Fornecedor','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZI','19','ZI_QTD2','N',12,2,'Quantidade','Quantidade','Quantidade','Quantidade','Quantidade','Quantidade','@E 999999999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZI','20','ZI_PRECO2','N',16,4,'Pr. Unitario','Pr. Unitario','Pr. Unitario','Preco unitario','Preco unitario','Preco unitario','@E 999,999,999.9999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZI','21','ZI_TOTAL2','N',18,2,'Vlr.Total','Vlr.Total','Vlr.Total','Vlr.Total','Vlr.Total','Vlr.Total','@E 999,999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZI','22','ZI_PRAZO2','N',4,0,'Prazo','Prazo','Prazo','Prazo','Prazo','Prazo','@E 9999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZI','23','ZI_DESCON2','N',5,2,'Desconto','Desconto','Desconto','Desconto','Desconto','Desconto','@E 999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZI','24','ZI_VLDESC2','N',14,2,'Vlr.Descont','Vlr.Descont','Vlr.Descont','Vlr.Descont','Vlr.Descont','Vlr.Descont','@E 999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZI','25','ZI_VALIPI2','N',14,2,'Vlr.IPI','Vlr.IPI','Vlr.IPI','Vlr.IPI','Vlr.IPI','Vlr.IPI','@E 999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZI','26','ZI_NOMFOR2','C',20,0,'Nome forn.','Nome forn.','Nome forn.','Nome forn.','Nome forn.','Nome forn.','@S30','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZI','27','ZI_CODFOR3','C',6,0,'Cod.Fornec.','Cod.Fornec.','Cod.Fornec.','Cod.Fornecedor','Cod.Fornecedor','Cod.Fornecedor','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZI','28','ZI_QTD3','N',12,2,'Quantidade','Quantidade','Quantidade','Quantidade','Quantidade','Quantidade','@E 999999999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZI','29','ZI_PRECO3','N',16,4,'Pr. Unitario','Pr. Unitario','Pr. Unitario','Preco unitario','Preco unitario','Preco unitario','@E 999,999,999.9999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZI','30','ZI_TOTAL3','N',18,2,'Vlr.Total','Vlr.Total','Vlr.Total','Vlr.Total','Vlr.Total','Vlr.Total','@E 999,999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZI','31','ZI_PRAZO3','N',4,0,'Prazo','Prazo','Prazo','Prazo','Prazo','Prazo','@E 9999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZI','32','ZI_DESCON3','N',5,2,'Desconto','Desconto','Desconto','Desconto','Desconto','Desconto','@E 999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZI','33','ZI_VLDESC3','N',14,2,'Vlr.Descont','Vlr.Descont','Vlr.Descont','Vlr.Descont','Vlr.Descont','Vlr.Descont','@E 999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZI','34','ZI_VALIPI3','N',14,2,'Vlr.IPI','Vlr.IPI','Vlr.IPI','Vlr.IPI','Vlr.IPI','Vlr.IPI','@E 999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZI','35','ZI_NOMFOR3','C',20,0,'Nome forn.','Nome forn.','Nome forn.','Nome forn.','Nome forn.','Nome forn.','@S30','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZI','36','ZI_COND','C',15,0,'Cond. Pagto','Cond. Pago','Payment Term','Codigo da condicao de Pgt','Codigo Condicion de Pago','Code of Terms of Payment','@!','existcpo("SE4")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','SE4',1,Chr(130) + Chr(192),'','','','N','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZI','37','ZI_EMISSAO','D',8,0,'DT Emissao','Fch Emision','Issue Date','Data de Emissao','Fecha de Emision','Date of Issue','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'ddatabase','',1,Chr(130) + Chr(128),'','','','N','V','','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZI','38','ZI_COND2','C',15,0,'Cond. Pagto','Cond. Pago','Payment Term','Codigo da condicao de Pgt','Codigo Condicion de Pago','Code of Terms of Payment','@!','existcpo("SE4")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','SE4',1,Chr(130) + Chr(192),'','','','N','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZI','39','ZI_COND3','C',15,0,'Cond. Pagto','Cond. Pago','Payment Term','Codigo da condicao de Pgt','Codigo Condicion de Pago','Code of Terms of Payment','@!','existcpo("SE4")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','SE4',1,Chr(130) + Chr(192),'','','','N','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZI','40','ZI_PICM2','N',5,2,'ICM','ICM','ICM','ICMS','ICM','ICM','@E 999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(130) + Chr(192),'','','','N','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SZI','41','ZI_PICM3','N',5,2,'ICM','ICM','ICM','ICMS','ICM','ICM','@E 999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(130) + Chr(192),'','','','N','','','','','','','','','','','','','','','','','','','',''} )


//
// Tabela SD1
// 
aAdd( aSX3, {'SD1','06','D1_QUANT','N',11,2,'Quantidade','Cantidad','Quantity','Quantidade do Produto','Cantidad del Producto','Product Quantity','@E 99999999.99','A103TOLER().And.Positivo().And.A100SegUm().And.MaFisRef("IT_QUANT","MT100",M->D1_QUANT)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(158) + Chr(128),'','','','S','','','','U_CESTE13("D1_QUANT")','','','','','','','','','','','N','N','','','','S'} )
aAdd( aSX3, {'SD1','07','D1_VUNIT','N',16,4,'Vlr.Unitario','Valor Unit.','Unit Value','Valor Unitario','Valor Unitario','Unit Value','@E 999,999,999.9999','A103TOLER().And.NaoVazio().AND.Positivo().And.MaFisRef("IT_PRCUNI","MT100",M->D1_VUNIT)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(155) + Chr(128),'','','','S','A','R','','U_CESTE13("D1_VUNIT")','','','','','','','','','','','N','N','','','','S'} )
aAdd( aSX3, {'SD1','09','D1_XDESPRO','C',60,0,'Descricao','Descricao','Descricao','Descricao do Produto','Descricao do Produto','Descricao do Produto','@S20','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','','','','','','','','',''} )
 
//
// Tabela SC7
// 
aAdd( aSX3, {'SC7','07','C7_XESPEC','M',10,0,'Especif.','Especif.','Especif.','Especificação','Especificação','Especificação','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','V','R','','','','','','','','','','','','','','N','','N','',''} )
aAdd( aSX3, {'SC7','96','C7_XTOTCUS','N',14,2,'Total','Total','Total','Total','Total','Total','@E 999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','V','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'SC7','G9','C7_XNPCORI','C',6,0,'Num.PC.ORI','Num.PC.ORI','Num.PC.ORI','','','','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','N','',''} )

//
// Tabela SC7
// 
aAdd( aSX3, {'CT2','67','CT2_XGEARQ','C',1,0,'Arq.Gerado','Arq.Gerado','Arq.Gerado','Arquivo Gerado','Arquivo Gerado','Arquivo Gerado','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','V','R','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'CT2','77','CT2_XUSER','C',60,0,'User Excluir','User Excluir','User Excluir','User Excluir','User Excluir','User Excluir','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','N','',''} )
aAdd( aSX3, {'CT2','78','CT2_XDTEXL','D',8,0,'Dt Exclusão','Dt Exclusão','Dt Exclusão','Dt Exclusão','Dt Exclusão','Dt Exclusão','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','N','',''} )
aAdd( aSX3, {'CT2','79','CT2_XKEY','C',200,0,'X KEY','X KEY','X KEY','X KEY','X KEY','X KEY','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','N','',''} )


//
// Tabela SE2
//
aAdd( aSX3, {'SE2','16','E2_XFORPGT','C',30,0,'Forma Pagto.','Forma Pagto.','Forma Pagto.','Forma de Pagamento','Forma de Pagamento','Forma de Pagamento','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','','S','A','R','','','','','','','','','','1','','','','','','','','U'} )

//
// Tabela SAD
//
aAdd( aSX3, {'SAD','02','AD_FORNECE','C',6,0,'Fornecedor','Proveedor','Supplier','Codigo do Fornecedor','Codigo del Proveedor','Supplier´s Code','@!','ExistCpo("SA2",M->AD_FORNECE,,,,.F.) .And. ExistChav("SAD",M->AD_FORNECE+M->AD_LOJA+M->AD_GRUPO) .And. A065GruFor()',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(168),'','FOR2',1,Chr(131) + Chr(128),'','','','S','','','','','','','','','','','001','','','','N','N','','1','N',''} )

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
	
	Else

		//
		// Verifica se o campo faz parte de um grupo e ajsuta tamanho
		//
		If !Empty( SX3->X3_GRPSXG ) .AND. SX3->X3_GRPSXG <> aSX3[nI][nPosSXG]
			SXG->( dbSetOrder( 1 ) )
			If SXG->( MSSeek( SX3->X3_GRPSXG ) )
				If aSX3[nI][nPosTam] <> SXG->XG_SIZE
					aSX3[nI][nPosTam] := SXG->XG_SIZE
					
					AutoGrLog("O tamanho do campo " + aSX3[nI][nPosCpo] + " nao atualizado e foi mantido em ["+;
								AllTrim( Str( SXG->XG_SIZE ) ) + "]"+ CRLF+;
								"   por pertencer ao grupo de campos [" + SX3->X3_GRPSXG + "]" + CRLF + CRLF )
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
			If aEstrut[nJ][1] == SX3->( FieldName( nJ ) ) .AND. ;
				PadR( StrTran( AllToChar( SX3->( FieldGet( nJ ) ) ), " ", "" ), 250 ) <> ;
				PadR( StrTran( AllToChar( aSX3[nI][nJ] )           , " ", "" ), 250 ) .AND. ;
				AllTrim( SX3->( FieldName( nJ ) ) ) <> "X3_ORDEM"

				cMsg := "O campo " + aSX3[nI][nPosCpo] + " está com o " + SX3->( FieldName( nJ ) ) + ;
				" com o conteúdo" + CRLF + ;
				"[" + RTrim( AllToChar( SX3->( FieldGet( nJ ) ) ) ) + "]" + CRLF + ;
				"que será substituido pelo NOVO conteúdo" + CRLF + ;
				"[" + RTrim( AllToChar( aSX3[nI][nJ] ) ) + "]" + CRLF + ;
				"Deseja substituir ? "

				If      lTodosSim
					nOpcA := 1
				ElseIf  lTodosNao
					nOpcA := 2
				Else
					nOpcA := Aviso( "ATUALIZAÇÃO DE DICIONÁRIOS E TABELAS", cMsg, { "Sim", "Não", "Sim p/Todos", "Não p/Todos" }, 3, "Diferença de conteúdo - SX3" )
					lTodosSim := ( nOpcA == 3 )
					lTodosNao := ( nOpcA == 4 )

					If lTodosSim
						nOpcA := 1
						lTodosSim := MsgNoYes( "Foi selecionada a opção de REALIZAR TODAS alterações no SX3 e NÃO MOSTRAR mais a tela de aviso." + CRLF + "Confirma a ação [Sim p/Todos] ?" )
					EndIf

					If lTodosNao
						nOpcA := 2
						lTodosNao := MsgNoYes( "Foi selecionada a opção de NÃO REALIZAR nenhuma alteração no SX3 que esteja diferente da base e NÃO MOSTRAR mais a tela de aviso." + CRLF + "Confirma esta ação [Não p/Todos]?" )
					EndIf

				EndIf

				If nOpcA == 1
					AutoGrLog("Alterado o campo " + aSX3[nI][nPosCpo] + CRLF +;
							  "   " + PadR( SX3->( FieldName( nJ ) ), 10 ) + " de [" + AllToChar( SX3->( FieldGet( nJ ) ) ) + "]" + CRLF+ ;
							  "            para [" + AllToChar( aSX3[nI][nJ] )          + "]" + CRLF + CRLF )

					RecLock( "SX3", .F. )					
					SX3->( FieldPut( FieldPos( aEstrut[nJ][1] ), aSX3[nI][nJ] ) )					
					dbCommit()
					MsUnLock()
				EndIf

			EndIf

		Next

	EndIf

	oProcess:IncRegua2( "Atualizando Campos de Tabelas (SX3)..." )

Next nI

AutoGrLog( CRLF + "Final da Atualização" + " SX3" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSIX
Função de processamento da gravação do SIX - Indices

@author TOTVS Protheus
@since  05/11/2014
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
             

//
// Tabela SA2
//
aAdd( aSIX, {'SA2','A','A2_FILIAL+A2_NUMCON','Cta Corrente','C. Corriente','Curr. Acct.','U','','A2NUMCON',''} )
aAdd( aSIX, {'SA2','B','A2_FILIAL+A2_NREDUZ','NOME FANTAZIA','NOME FANTAZIA','NOME FANTAZIA','U','','A2NREDUZ',''} )
aAdd( aSIX, {'SA2','C','A2_FILIAL+A2_XGRP01','GRUPO 1','GRUPO 1','GRUPO 1','U','','A2XGRP01',''} )
aAdd( aSIX, {'SA2','D','A2_FILIAL+A2_XMATRIC','Matricula','Matricula','Matricula','U','','A2MATRIC',''} )
             
             
//
// Tabela SZH
//
aAdd( aSIX, {'SZH','1','ZH_FILIAL+ZH_NUM','Numero PC','Numero PC','Numero PC','U','','',''} )

//
// Tabela SZ3
//
aAdd( aSIX, {'SZ3','1','Z3_FILIAL+Z3_NUMCOT+Z3_PRODUTO+Z3_FORNECE+Z3_LOJA+Z3_ITEM+Z3_PARCELA','Cotacäo + Produto + Fornecedor + Loja + Item + Parcela','Cotacäo + Produto + Fornecedor + Loja + Item + Parcela','Cotacäo + Produto + Fornecedor + Loja + Item + Parcela','U','','',''} )

//
// Tabela SZI
//
aAdd( aSIX, {'SZI','1','ZI_FILIAL+ZI_NUMSC','NUMERO COTACAO','','','U','','',''} )  

//
// Tabela SC7
//
aAdd( aSIX, {'SC7','N','C7_FILIAL+C7_NUMSC+C7_NUM+C7_ITEM','Numero da SC+Numero PC+Item','Numero da SC+Numero PC+Item','Numero da SC+Numero PC+Item','U','','NSCNPCIT','S'} )

//
// Tabela CT2
//
aAdd( aSIX, {'CT2','H','CT2_FILIAL+CT2_XKEY','X KEY','X KEY','X KEY','U','','CT2XKEY','N'} )
aAdd( aSIX, {'CT2','I','CT2_FILIAL+STR(CT2_VALOR,14,2)','Valor','Valor','Value','U','','CT2VALOR','S'} )

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
@since  05/11/2014
@obs    Gerado por EXPORDIC - V.4.22.10.7 EFS / Upd. V.4.19.12 EFS
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

//
// Padrão
//
aAdd( aSX6, {'  ','MV_PCOMPRA','C','Nome do programa ou rdmake da opcao "Imprimir" do','Nombre del programa o rdmake de opcion "Imprimir"','Program Name or "Printing" option Rdmake in','menu do "Pedido de Compra"','del menu del "Pedido de Compra"','"Purchase Order" menu.','','','','CCOMR01','MATR110','MATR110','S','','','','','',''} )
aAdd( aSX6, {'  ','MV_PCEXCOT','C','Restaura a cotação ao excluir todos os pedidos de','Restaura cotizacion al borrar todos los pedidos','Restore quotation to delete all purchase orders','compra gerados por ela.','de compra generados por ella.','generated by it.','1= Restaura; 2= Não Restaura;','1= Restaura; 2= No Restaura;','1= Restore; 2= Not Restore;','1','','','S','','','2','','','S'} )
aAdd( aSX6, {'  ','MV_SELFOR','C','Parametro que indica se o Comprador podera fazer','Parametro que muestra si el comprador podra hacer','Parameter indicating whether the buyer can make','selecao dos Fornecedores','la seleccion de los proveedores','the selection of suppliers.','','','','S','S','S','S','','','N','S','S','S'} )

//
// Especifico
//
aAdd( aSX6, {'  ','CI_USRPROD','C','Usuarios que poderao incluir produtos de estoque','Usuarios que poderao incluir produtos de estoque','Usuarios que poderao incluir produtos de estoque','no sistema.','no sistema.','no sistema.','','','','waldir_almeida/Siga/sue_hellen/henrique_jesus','Waldir','Waldir','U','','','','','',''} )
aAdd( aSX6, {'  ','CI_USERSC','C','Usuarios autorizados a alterar o comprador "demand','','','a" para outro comprador e alterar quantidade do pr','','','oduto.','','','Siga/waldir_almeida/sue_hellen/henrique_jesus','Siga/waldir_almeida/sue_hellen/henrique_jesus','Siga/waldir_almeida/sue_hellen/henrique_jesus','U','','','','','',''} )
aAdd( aSX6, {'  ','CI_FATORD1','N','Percentual de aceite entre Pedido de Compra e SD1.','Percentual de aceite entre Pedido de Compra e SD1.','Percentual de aceite entre Pedido de Compra e SD1.','Percentual de aceite entre Pedido de Compra e SD1.','Percentual de aceite entre Pedido de Compra e SD1.','Percentual de aceite entre Pedido de Compra e SD1.','Percentual de aceite entre Pedido de Compra e SD1.','Percentual de aceite entre Pedido de Compra e SD1.','','10','10','10','U','','','','','',''} )


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
	else
		lContinua := .T.
		lReclock  := .F.
		AutoGrLog( "Foi alterado o parâmetro " + aSX6[nI][1] + aSX6[nI][2] + " Conteúdo [" + AllTrim( aSX6[nI][13] ) + "]" )		
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
@since  10/11/2014
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
                   
//
// Tabela SB1
//
//aAdd( aSX7, {'B1_COD','002','ExecBlock("CESTA01", .F., .F.)','B1_COD','P','N','',0,'','U','.F.'} ) Gatilho Desativado
aAdd( aSX7, {'B1_GRUPO','001','ExecBlock("CESTE04", .F., .F.)','B1_COD','P','N','',0,'','U',''} )
aAdd( aSX7, {'B1_GRUPO','002','ExecBlock("CESTE05", .F., .F.)','B1_CONTA','P','N','',0,'','U','EMPTY(M->B1_CONTA)'} )
aAdd( aSX7, {'B1_GRUPO','003','IIF (U_C4E05VEC(M->B1_COD), "ME", "MC")','B1_TIPO','P','N','',0,'','U',''} )
aAdd( aSX7, {'B1_GRUPO','004','IIF(AllTrim(M->B1_TIPO) == "MC", "004", "003")','B1_TE','P','N','',0,'','U',''} )
aAdd( aSX7, {'B1_GRUPO','005','IIF(M->B1_XATIVO == "1", "005", IIF(AllTrim(M->B1_TIPO) == "MC", "004", "003"))','B1_TE','P','N','',0,'','U',''} )

//
// Tabela SA2
//
aAdd( aSX7, {'A2_CGC','009','IF(LEN(alltrim(M->A2_CGC))>11,"R","F")','A2_TIPO','P','N','',0,'','U',''} )
aAdd( aSX7, {'A2_COND','001','SE4->E4_DESCRI','A2_XCONDDE','P','S','SE4',1,'xFilial("SE4") + M->A2_COND','U',''} )
aAdd( aSX7, {'A2_XCONV','001','0','A2_XESTNUM','P','N','',0,'','U','M->A2_XCONV=="N"'} )
aAdd( aSX7, {'A2_XCONV','002','"S"','A2_XPROSPE','P','N','',0,'','U','M->A2_XCONV == "S"'} )
aAdd( aSX7, {'A2_XESTNUM','001','IIF(M->A2_XESTNUM !=0, "S","N")','A2_XCONV','P','N','',0,'','U',''} )
aAdd( aSX7, {'A2_XESTNUM','002','"S"','A2_XPROSPE','P','N','',0,'','U','M->A2_XESTNUM != 0'} )
aAdd( aSX7, {'A2_HPAGE','001','LOWER(M->A2_HPAGE)','A2_HPAGE','P','N','',0,'','U',''} )
aAdd( aSX7, {'A2_INSCRME','001','M->A2_INSCRME','A2_INSCRM','P','N','',0,'','U',''} )
aAdd( aSX7, {'A2_XREDUZ','001','POSICIONE("CT1",2,XFILIAL("CT1")+M->A2_XREDUZ,"CT1_CONTA")','A2_CONTA','P','N','',0,'','U',''} )

//
// Tabela SC1 
//
aAdd( aSX7, {'C1_FORNECE','001','SA2->A2_NOME','C1_XFORNOM','P','S','SA2',1,'xFilial("SA2") + M->C8_FORNECE','U',''} )
aAdd( aSX7, {'C1_PRODUTO','001','SB1->B1_XESPEC','C1_XESPEC','P','S','SB1',1,'xFilial("SB1")+M->C1_PRODUTO','U',''} )

//
// Tabela SC8 
//
aAdd( aSX7, {'C8_DESC','003','M->C8_QUANT * M->C8_PRECO','C8_TOTAL','P','N','',0,'','U',''} )
aAdd( aSX7, {'C8_PRECO','001','M->C8_QUANT * M->C8_PRECO','C8_TOTAL','P','N','',0,'','U',''} )


//
// Tabela SD3 
//
aAdd( aSX7, {'D3_COD','001','IIF(FINDFUNCTION("A240CAT83"),U_CESTE09(),"")','D3_SLDEST','P','S','SB2',1,'xFilial("SB2")+M->D3_COD+POSICIONE("SB1",1,xFilial("SB1")+M->D3_COD,"B1_LOCPAD")','U',''} )

//
// Tabela SZ3
//
aAdd( aSX7, {'Z3_DIAS','001','U_C2A01TPG(M->Z3_DIAS)','Z3_DATA','P','N','',0,'','U',''} )
aAdd( aSX7, {'Z3_PERCENT','001','_nTotal * M->Z3_PERCENT / 100','Z3_VALOR','P','N','',0,'','U',''} )  

//
// Tabela SC7
//
aAdd( aSX7, {'C7_DESC','003','M->C7_TOTAL - M->C7_VLDESC + M->C7_VALIPI','C7_XTOTCUS','P','N','',0,'','U',''} )
aAdd( aSX7, {'C7_PRECO','003','M->C7_PRECO * (M->C7_DESC /100)','C7_VLDESC','P','N','',0,'','U',''} )
aAdd( aSX7, {'C7_PRECO','004','M->C7_TOTAL - M->C7_VLDESC+M->C7_VALIPI','C7_XTOTCUS','P','N','',0,'','U',''} )
aAdd( aSX7, {'C7_PRODUTO','002','SB1->B1_XESPEC','C7_XESPEC','P','S','SB1',1,'xFilial("SB1")+M->C7_PRODUTO','U',''} )
aAdd( aSX7, {'C7_QUANT','004','M->C7_TOTAL - M->C7_VLDESC + M->C7_VALIPI','C7_XTOTCUS','P','N','',0,'','U',''} )
aAdd( aSX7, {'C7_VLDESC','003','M->C7_TOTAL - M->C7_VLDESC + M->C7_VALIPI','C7_XTOTCUS','P','N','',0,'','U',''} )

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
/*/{Protheus.doc} FSAtuSX5
Função de processamento da gravação do SX5 - Indices

@author TOTVS Protheus
@since  05/11/2014
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

aAdd( aSX5, {'  ','00','Z2','TIPOS DE VIAS IMPRESSAO REL CRYSTAL CRYAF.RPT','TIPOS DE VIAS IMPRESSAO REL CRYSTAL CRYAF.RPT','TIPOS DE VIAS IMPRESSAO REL CRYSTAL CRYAF.RPT'} )
aAdd( aSX5, {'  ','Z2','01','1 VIA - FORNECEDOR','1 VIA - FORNECEDOR','1 VIA - FORNECEDOR'} )
aAdd( aSX5, {'  ','Z2','02','2 VIA - CONTABILIDADE','2 VIA - CONTABILIDADE','2 VIA - CONTABILIDADE'} )
aAdd( aSX5, {'  ','Z2','03','3 VIA - TESOURARIA','3 VIA - TESOURARIA','3 VIA - TESOURARIA'} )
aAdd( aSX5, {'  ','Z2','04','4 VIA - COMPRAS','4 VIA - COMPRAS','4 VIA - COMPRAS'} )
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
/*/{Protheus.doc} FSAtuSXB
Função de processamento da gravação do SXB - Consultas Padrao

@author TOTVS Protheus
@since  10/12/2014
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


aAdd( aSXB, {'FOR2','1','01','DB','Fornecedor','Fornecedor','Fornecedor','','SA2'} )
aAdd( aSXB, {'FOR2','2','01','01','Codigo','Codigo','Code','',''} )
aAdd( aSXB, {'FOR2','2','02','02','Nome','Nombre','Name','',''} )
aAdd( aSXB, {'FOR2','2','03','03','CNPJ','CNPJ','CNPJ','',''} )
aAdd( aSXB, {'FOR2','3','01','01','Cadastra Novo','Incluye Nuevo','Add New','','01'} )
aAdd( aSXB, {'FOR2','4','01','01','Codigo','Codigo','Code','','A2_COD'} )
aAdd( aSXB, {'FOR2','4','01','02','Loja','Tienda','Unit','','A2_LOJA'} )
aAdd( aSXB, {'FOR2','4','01','03','Nome','Nombre','Name','','SUBSTR(A2_NOME,1,30)'} )
aAdd( aSXB, {'FOR2','4','02','01','Codigo','Codigo','Code','','A2_COD'} )
aAdd( aSXB, {'FOR2','4','02','02','Loja','Tienda','Unit','','A2_LOJA'} )
aAdd( aSXB, {'FOR2','4','02','03','Nome','Nombre','Name','','SUBSTR(A2_NOME,1,30)'} )
aAdd( aSXB, {'FOR2','4','03','01','CNPJ','CNPJ','CNPJ','','A2_CGC'} )
aAdd( aSXB, {'FOR2','4','03','02','Nome','Nombre','Name','','SUBSTR(A2_NOME,1,30)'} )
aAdd( aSXB, {'FOR2','5','01','','','','','','SA2->A2_COD'} )
aAdd( aSXB, {'FOR2','5','02','','','','','','SA2->A2_LOJA'} )
aAdd( aSXB, {'FOR2','6','01','','','','','','SA2->A2_MSBLQL!="1"'} )
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
/*/{Protheus.doc} EscEmpresa
Função genérica para escolha de Empresa, montada pelo SM0

@return aRet Vetor contendo as seleções feitas.
@return Se não for marcada nenhuma o vetor volta vazio

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
@since  05/11/2014
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
@since  05/11/2014
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
