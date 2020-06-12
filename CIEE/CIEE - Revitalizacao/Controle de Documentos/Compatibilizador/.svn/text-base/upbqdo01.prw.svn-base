#INCLUDE "PROTHEUS.CH"

#DEFINE SIMPLES Char( 39 )
#DEFINE DUPLAS  Char( 34 )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ UPBQDO01 บ Autor ณ TOTVS Protheus     บ Data ณ  17/10/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de update dos dicionแrios para compatibiliza็ใo     ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ UPBQDO01   - Gerado por EXPORDIC / Upd. V.4.10.6 EFS       ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function UPBQDO01( cEmpAmb, cFilAmb )

Local   aSay      := {}
Local   aButton   := {}
Local   aMarcadas := {}
Local   cTitulo   := "ATUALIZAวรO DE DICIONมRIOS E TABELAS"
Local   cDesc1    := "Esta rotina tem como fun็ใo fazer  a atualiza็ใo  dos dicionแrios do Sistema ( SX?/SIX )"
Local   cDesc2    := "Este processo deve ser executado em modo EXCLUSIVO, ou seja nใo podem haver outros"
Local   cDesc3    := "usuแrios  ou  jobs utilizando  o sistema.  ษ extremamente recomendav้l  que  se  fa็a um"
Local   cDesc4    := "BACKUP  dos DICIONมRIOS  e da  BASE DE DADOS antes desta atualiza็ใo, para que caso "
Local   cDesc5    := "ocorra eventuais falhas, esse backup seja ser restaurado."
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
		If lAuto .OR. MsgNoYes( "Confirma a atualiza็ใo dos dicionแrios ?", cTitulo )
			oProcess := MsNewProcess():New( { | lEnd | lOk := FSTProc( @lEnd, aMarcadas ) }, "Atualizando", "Aguarde, atualizando ...", .F. )
			oProcess:Activate()

		If lAuto
			If lOk
				MsgStop( "Atualiza็ใo Realizada.", "UPBQDO01" )
				dbCloseAll()
			Else
				MsgStop( "Atualiza็ใo nใo Realizada.", "UPBQDO01" )
				dbCloseAll()
			EndIf
		Else
			If lOk
				Final( "Atualiza็ใo Concluํda." )
			Else
				Final( "Atualiza็ใo nใo Realizada." )
			EndIf
		EndIf

		Else
			MsgStop( "Atualiza็ใo nใo Realizada.", "UPBQDO01" )

		EndIf

	Else
		MsgStop( "Atualiza็ใo nใo Realizada.", "UPBQDO01" )

	EndIf

EndIf

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSTProc  บ Autor ณ TOTVS Protheus     บ Data ณ  17/10/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da grava็ใo dos arquivos           ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSTProc    - Gerado por EXPORDIC / Upd. V.4.10.6 EFS       ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FSTProc( lEnd, aMarcadas )
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
		// So adiciona no aRecnoSM0 se a empresa for diferente
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
				MsgStop( "Atualiza็ใo da empresa " + aRecnoSM0[nI][2] + " nใo efetuada." )
				Exit
			EndIf

			SM0->( dbGoTo( aRecnoSM0[nI][1] ) )

			RpcSetType( 3 )
			RpcSetEnv( SM0->M0_CODIGO, SM0->M0_CODFIL )

			lMsFinalAuto := .F.
			lMsHelpAuto  := .F.

			cTexto += Replicate( "-", 128 ) + CRLF
			cTexto += "Empresa : " + SM0->M0_CODIGO + "/" + SM0->M0_NOME + CRLF + CRLF

			oProcess:SetRegua1( 8 )

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAtualiza o dicionแrio SX2         ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			oProcess:IncRegua1( "Dicionแrio de arquivos" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSX2( @cTexto )

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAtualiza o dicionแrio SX3         ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			FSAtuSX3( @cTexto )

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAtualiza o dicionแrio SIX         ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			oProcess:IncRegua1( "Dicionแrio de ํndices" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSIX( @cTexto )

			oProcess:IncRegua1( "Dicionแrio de dados" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			oProcess:IncRegua2( "Atualizando campos/ํndices" )

			// Alteracao fisica dos arquivos
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
					MsgStop( "Ocorreu um erro desconhecido durante a atualiza็ใo da tabela : " + aArqUpd[nX] + ". Verifique a integridade do dicionแrio e da tabela.", "ATENวรO" )
					cTexto += "Ocorreu um erro desconhecido durante a atualiza็ใo da estrutura da tabela : " + aArqUpd[nX] + CRLF
				EndIf

				If cTopBuild >= "20090811" .AND. TcInternal( 89 ) == "CLOB_SUPPORTED"
					TcInternal( 25, "OFF" )
				EndIf

			Next nX

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAtualiza o dicionแrio SX6         ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			oProcess:IncRegua1( "Dicionแrio de parโmetros" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSX6( @cTexto )

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAtualiza o dicionแrio SX7         ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			oProcess:IncRegua1( "Dicionแrio de gatilhos" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSX7( @cTexto )

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAtualiza o dicionแrio SXA         ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			oProcess:IncRegua1( "Dicionแrio de pastas" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSXA( @cTexto )

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAtualiza o dicionแrio SXB         ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			oProcess:IncRegua1( "Dicionแrio de consultas padrใo" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSXB( @cTexto )

			RpcClearEnv()

		Next nI

		If MyOpenSm0(.T.)

			cAux += Replicate( "-", 128 ) + CRLF
			cAux += Replicate( " ", 128 ) + CRLF
			cAux += "LOG DA ATUALIZACAO DOS DICIONมRIOS" + CRLF
			cAux += Replicate( " ", 128 ) + CRLF
			cAux += Replicate( "-", 128 ) + CRLF
			cAux += CRLF
			cAux += " Dados Ambiente" + CRLF
			cAux += " --------------------"  + CRLF
			cAux += " Empresa / Filial...: " + cEmpAnt + "/" + cFilAnt  + CRLF
			cAux += " Nome Empresa.......: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_NOMECOM", cEmpAnt + cFilAnt, 1, "" ) ) ) + CRLF
			cAux += " Nome Filial........: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_FILIAL" , cEmpAnt + cFilAnt, 1, "" ) ) ) + CRLF
			cAux += " DataBase...........: " + DtoC( dDataBase )  + CRLF
			cAux += " Data / Hora Inicio.: " + DtoC( Date() )  + " / " + Time()  + CRLF
			cAux += " Environment........: " + GetEnvServer()  + CRLF
			cAux += " StartPath..........: " + GetSrvProfString( "StartPath", "" )  + CRLF
			cAux += " RootPath...........: " + GetSrvProfString( "RootPath" , "" )  + CRLF
			cAux += " Versao.............: " + GetVersao(.T.)  + CRLF
			cAux += " Usuario TOTVS .....: " + __cUserId + " " +  cUserName + CRLF
			cAux += " Computer Name......: " + GetComputerName() + CRLF

			aInfo   := GetUserInfo()
			If ( nPos    := aScan( aInfo,{ |x,y| x[3] == ThreadId() } ) ) > 0
				cAux += " "  + CRLF
				cAux += " Dados Thread" + CRLF
				cAux += " --------------------"  + CRLF
				cAux += " Usuario da Rede....: " + aInfo[nPos][1] + CRLF
				cAux += " Estacao............: " + aInfo[nPos][2] + CRLF
				cAux += " Programa Inicial...: " + aInfo[nPos][5] + CRLF
				cAux += " Environment........: " + aInfo[nPos][6] + CRLF
				cAux += " Conexao............: " + AllTrim( StrTran( StrTran( aInfo[nPos][7], Chr( 13 ), "" ), Chr( 10 ), "" ) )  + CRLF
			EndIf
			cAux += Replicate( "-", 128 ) + CRLF
			cAux += CRLF

			cTexto := cAux + cTexto + CRLF

			cTexto += Replicate( "-", 128 ) + CRLF
			cTexto += " Data / Hora Final.: " + DtoC( Date() ) + " / " + Time()  + CRLF
			cTexto += Replicate( "-", 128 ) + CRLF

			cFileLog := MemoWrite( CriaTrab( , .F. ) + ".log", cTexto )

			Define Font oFont Name "Mono AS" Size 5, 12

			Define MsDialog oDlg Title "Atualizacao concluida." From 3, 0 to 340, 417 Pixel

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


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSAtuSX2 บ Autor ณ TOTVS Protheus     บ Data ณ  17/10/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da gravacao do SX2 - Arquivos      ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSAtuSX2   - Gerado por EXPORDIC / Upd. V.4.10.6 EFS       ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FSAtuSX2( cTexto )
Local aEstrut   := {}
Local aSX2      := {}
Local cAlias    := ""
Local cEmpr     := ""
Local cPath     := ""
Local nI        := 0
Local nJ        := 0

cTexto  += "Inicio da Atualizacao" + " SX2" + CRLF + CRLF

aEstrut := { "X2_CHAVE"  , "X2_PATH"   , "X2_ARQUIVO", "X2_NOME"  , "X2_NOMESPA", "X2_NOMEENG", ;
             "X2_DELET"  , "X2_MODO"   , "X2_TTS"    , "X2_ROTINA", "X2_PYME"   , "X2_UNICO"  , ;
             "X2_MODOEMP", "X2_MODOUN" , "X2_MODULO" }

dbSelectArea( "SX2" )
SX2->( dbSetOrder( 1 ) )
SX2->( dbGoTop() )
cPath := SX2->X2_PATH
cPath := IIf( Right( AllTrim( cPath ), 1 ) <> "\", PadR( AllTrim( cPath ) + "\", Len( cPath ) ), cPath )
cEmpr := Substr( SX2->X2_ARQUIVO, 4 )

//
// Tabela PA1
//
aAdd( aSX2, {'PA1',cPath,'PA1'+cEmpr,'DOCUMENTOS','DOCUMENTOS','DOCUMENTOS',0,'C','','','','','E','E',0} )
//
// Tabela PA2
//
aAdd( aSX2, {'PA2',cPath,'PA2'+cEmpr,'CADASTRO DE UNIDADES','CADASTRO DE UNIDADES','CADASTRO DE UNIDADES',0,'C','','','','','C','C',0} )
//
// Tabela PA3
//
aAdd( aSX2, {'PA3',cPath,'PA3'+cEmpr,'USUARIOS','USUARIOS','USUARIOS',0,'C','','','','','E','E',0} )
//
// Tabela PA4
//
aAdd( aSX2, {'PA4',cPath,'PA4'+cEmpr,'CONTROLE DE VIGENCIA','CONTROLE DE VIGENCIA','CONTROLE DE VIGENCIA',0,'C','','','','','E','E',0} )
//
// Tabela PA5
//
aAdd( aSX2, {'PA5',cPath,'PA5'+cEmpr,'CADASTRO DE GERENCIAS','CADASTRO DE GERENCIAS','CADASTRO DE GERENCIAS',0,'C','','','','','E','E',0} )
//
// Tabela PA6
//
aAdd( aSX2, {'PA6',cPath,'PA6'+cEmpr,'WORKFLOW','WORKFLOW','WORKFLOW',0,'C','','','','','E','E',0} )
//
// Tabela PA7
//
aAdd( aSX2, {'PA7',cPath,'PA7'+cEmpr,'USUARIOS X UNIDADES','USUARIOS X UNIDADES','USUARIOS X UNIDADES',0,'C','','','','','E','E',0} )
//
// Tabela PA8
//
aAdd( aSX2, {'PA8',cPath,'PA8'+cEmpr,'RESPONSAVEIS X VIGENCENCIA','RESPONSAVEIS X VIGENCENCIA','RESPONSAVEIS X VIGENCENCIA',0,'C','','','','','E','E',0} )
//
// Atualizando dicionแrio
//
oProcess:SetRegua2( Len( aSX2 ) )

dbSelectArea( "SX2" )
dbSetOrder( 1 )

For nI := 1 To Len( aSX2 )

	oProcess:IncRegua2( "Atualizando Arquivos (SX2)..." )

	If !SX2->( dbSeek( aSX2[nI][1] ) )

		If !( aSX2[nI][1] $ cAlias )
			cAlias += aSX2[nI][1] + "/"
			cTexto += "Foi incluํda a tabela " + aSX2[nI][1] + CRLF
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
		dbCommit()
		MsUnLock()

	Else

		If  !( StrTran( Upper( AllTrim( SX2->X2_UNICO ) ), " ", "" ) == StrTran( Upper( AllTrim( aSX2[nI][12]  ) ), " ", "" ) )
			If MSFILE( RetSqlName( aSX2[nI][1] ),RetSqlName( aSX2[nI][1] ) + "_UNQ"  )
				TcInternal( 60, RetSqlName( aSX2[nI][1] ) + "|" + RetSqlName( aSX2[nI][1] ) + "_UNQ" )
				cTexto += "Foi alterada chave unica da tabela " + aSX2[nI][1] + CRLF
			Else
				cTexto += "Foi criada   chave unica da tabela " + aSX2[nI][1] + CRLF
			EndIf
		EndIf

	EndIf

Next nI

cTexto += CRLF + "Final da Atualizacao" + " SX2" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSAtuSX3 บ Autor ณ TOTVS Protheus     บ Data ณ  17/10/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da gravacao do SX3 - Campos        ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSAtuSX3   - Gerado por EXPORDIC / Upd. V.4.10.6 EFS       ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FSAtuSX3( cTexto )
Local aEstrut   := {}
Local aSX3      := {}
Local cAlias    := ""
Local cAliasAtu := ""
Local cMsg      := ""
Local cSeqAtu   := ""
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
Local nSeqAtu   := 0
Local nTamSeek  := Len( SX3->X3_CAMPO )

cTexto  += "Inicio da Atualizacao" + " SX3" + CRLF + CRLF

aEstrut := { "X3_ARQUIVO", "X3_ORDEM"  , "X3_CAMPO"  , "X3_TIPO"   , "X3_TAMANHO", "X3_DECIMAL", ;
             "X3_TITULO" , "X3_TITSPA" , "X3_TITENG" , "X3_DESCRIC", "X3_DESCSPA", "X3_DESCENG", ;
             "X3_PICTURE", "X3_VALID"  , "X3_USADO"  , "X3_RELACAO", "X3_F3"     , "X3_NIVEL"  , ;
             "X3_RESERV" , "X3_CHECK"  , "X3_TRIGGER", "X3_PROPRI" , "X3_BROWSE" , "X3_VISUAL" , ;
             "X3_CONTEXT", "X3_OBRIGAT", "X3_VLDUSER", "X3_CBOX"   , "X3_CBOXSPA", "X3_CBOXENG", ;
             "X3_PICTVAR", "X3_WHEN"   , "X3_INIBRW" , "X3_GRPSXG" , "X3_FOLDER" , "X3_PYME"   }

//
// Tabela PA1
//
aAdd( aSX3, {'PA1','01','PA1_FILIAL','C',2,0,'Filial','Sucursal','Branch','Filial do Sistema','Sucursal','Branch of the System','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,	Chr(254) + Chr(192),'','','U','N','','','','','','','','','','','','8',''} )
aAdd( aSX3, {'PA1','02','PA1_COD','C',6,0,'Codigo','Codigo','Codigo','Codigo de cadastro do Doc','Codigo de cadastro do Doc','Codigo de cadastro do Doc','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'GETSXENUM("PA1","PA1_COD")','',0,	Chr(254) + Chr(192),'','','U','S','V','R','€','ExistChav("PA1")','','','','','inclui','','','1',''} )
aAdd( aSX3, {'PA1','03','PA1_TPDOC','C',2,0,'Tipo Docto','Tipo Docto','Tipo Docto','Tipo de documento','Tipo de documento','Tipo de documento','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','P1',0,	Chr(254) + Chr(192),'','S','U','S','A','R','€','ExistCpo("SX5","P1"+M->PA1_TPDOC)','','','','','inclui','','','1',''} )
aAdd( aSX3, {'PA1','04','PA1_DESC','C',20,0,'Descricao','Descricao','Descricao','Descricao do documento','Descricao do documento','Descricao do documento','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','1',''} )
aAdd( aSX3, {'PA1','05','PA1_OBS','M',10,0,'Observacao','Observacao','Observacao','Observacoes do Documento','Observacoes do Documento','Observacoes do Documento','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','1',''} )
aAdd( aSX3, {'PA1','06','PA1_CNPJ','C',14,0,'CNPJ','CNPJ','CNPJ','Registro CNPJ','Registro CNPJ','Registro CNPJ','@r 99.999.999/9999-99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','CGC(M->PA1_CNPJ).or. empty(PA1->PA1_CNPJ)','','','','','','','','2',''} )
aAdd( aSX3, {'PA1','07','PA1_ALCCM','C',15,0,'CCM','CCM','CCM','Numero do CCM','Numero do CCM','Numero do CCM','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','3',''} )
aAdd( aSX3, {'PA1','08','PA1_ALVA','C',15,0,'Alvara','Alvara','Alvara','Numero de alvara','Numero de alvara','Numero de alvara','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','3',''} )
aAdd( aSX3, {'PA1','09','PA1_ALIND','C',1,0,'Indicacao','Indicacao','Indicacao','Indicacao','Indicacao','Indicacao','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','A=Alvara;T=Taxa','','','','','','','3',''} )
aAdd( aSX3, {'PA1','10','PA1_ISIND','C',2,0,'Indicacao','Indicacao','Indicacao','Indicacao','Indicacao','Indicacao','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','IM=Imunidade;IS=Isencao','','','','','','','4',''} )
aAdd( aSX3, {'PA1','11','PA1_PROCES','C',15,0,'Parecer','Parecer','Parecer','Parecer do processo','Parecer do processo','Parecer do processo','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','4',''} )
aAdd( aSX3, {'PA1','12','PA1_ATEST','C',15,0,'Atest Funcio','Atest Funcio','Atest Funcio','Atestado de funcionamento','Atestado de funcionamento','Atestado de funcionamento','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','5',''} )
aAdd( aSX3, {'PA1','13','PA1_UTIL','C',15,0,'Util Publica','Util Publica','Util Publica','Utilidade Publica','Utilidade Publica','Utilidade Publica','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','6',''} )
aAdd( aSX3, {'PA1','14','PA1_CMDCA','C',15,0,'NFe','NFe','NFe','NFe','NFe','NFe','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','7',''} )
aAdd( aSX3, {'PA1','15','PA1_DOCDIV','C',15,0,'Nr Docto','Nr Docto','Nr Docto','Numero do Documento','Numero do Documento','Numero do Documento','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','8',''} )
aAdd( aSX3, {'PA1','16','PA1_STATUS','C',1,0,'Status','Status','Status','Status do Docto','Status do Docto','Status do Docto','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"A"','',0,	Chr(254) + Chr(192),'','','U','S','A','R','€','','A=Ativo;I=Inativo','','','',"'A'",'','','1',''} )
aAdd( aSX3, {'PA1','17','PA1_BITMAP','C',8,0,'Imagem','Imagem','Imagem','Imagem','Imagem','Imagem','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,	Chr(254) + Chr(192),'','','B','N','A','R','','','','','','','','','','9',''} )
aAdd( aSX3, {'PA1','18','PA1_TITUL1','C',60,0,'WF Titulo','WF Titulo','WF Titulo','Titulo E-mail WF CNPJ','Titulo E-mail WF CNPJ','Titulo E-mail WF CNPJ','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','N','A','R','','!Vazio()','','','','','','','','2',''} )
aAdd( aSX3, {'PA1','19','PA1_TITUL2','C',60,0,'WF Titulo','WF Titulo','WF Titulo','Titulo E-mail WF Alvara','Titulo E-mail WF Alvara','Titulo E-mail WF Alvara','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','N','A','R','','!Vazio()','','','','','','','','3',''} )
aAdd( aSX3, {'PA1','20','PA1_TITUL3','C',60,0,'WF Titulo','WF Titulo','WF Titulo','Titulo E-mail WF ISS QN','Titulo E-mail WF ISS QN','Titulo E-mail WF ISS QN','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','N','A','R','','!Vazio()','','','','','','','','4',''} )
aAdd( aSX3, {'PA1','21','PA1_TITUL4','C',60,0,'WF Titulo','WF Titulo','WF Titulo','Titulo E-mail WF CMAS/CEA','Titulo E-mail WF CMAS/CEA','Titulo E-mail WF CMAS/CEA','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','N','A','R','','!Vazio()','','','','','','','','5',''} )
aAdd( aSX3, {'PA1','22','PA1_TITUL6','C',60,0,'WF Titulo','WF Titulo','WF Titulo','Titulo E-mail WF CMDCA','Titulo E-mail WF CMDCA','Titulo E-mail WF CMDCA','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','N','A','R','','!Vazio()','','','','','','','','7',''} )
aAdd( aSX3, {'PA1','23','PA1_TITUL7','C',60,0,'WF Titulo','WF Titulo','WF Titulo','Titulo email Wf Diversos','Titulo email Wf Diversos','Titulo email Wf Diversos','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','N','A','R','','!Vazio()','','','','','','','','8',''} )
aAdd( aSX3, {'PA1','24','PA1_MSGAG1','C',300,0,'WF Msg Aguar','WF Msg Aguar','WF Msg Aguar','Msg WF CNPJ Aguardando','Msg WF CNPJ Aguardando','Msg WF CNPJ Aguardando','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','N','A','R','','!Vazio()','','','','','','','','2',''} )
aAdd( aSX3, {'PA1','25','PA1_MSGVG1','C',300,0,'WF Msg Vigen','WF Msg Vigen','WF Msg Vigen','Msg WF CNPJ Vigente','Msg WF CNPJ Vigente','Msg WF CNPJ Vigente','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','N','A','R','','!Vazio()','','','','','','','','2',''} )
aAdd( aSX3, {'PA1','26','PA1_MSGVC1','C',300,0,'WF Msg Vcdo','WF Msg Vcdo','WF Msg Vcdo','Msg WF CNPJ Vencido','Msg WF CNPJ Vencido','Msg WF CNPJ Vencido','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','N','A','R','','!Vazio()','','','','','','','','2',''} )
aAdd( aSX3, {'PA1','27','PA1_MSGAG2','C',300,0,'WF Msg Aguar','WF Msg Aguar','WF Msg Aguar','Msg WF ALVARA Aguardando','Msg WF ALVARA Aguardando','Msg WF ALVARA Aguardando','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','N','A','R','','!Vazio()','','','','','','','','3',''} )
aAdd( aSX3, {'PA1','28','PA1_MSGVG2','C',300,0,'WF Msg Vigen','WF Msg Vigen','WF Msg Vigen','Msg WF ALVARA Vigente','Msg WF ALVARA Vigente','Msg WF ALVARA Vigente','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','N','A','R','','!Vazio()','','','','','','','','3',''} )
aAdd( aSX3, {'PA1','29','PA1_MSGVC2','C',300,0,'WF Msg Vcdo','WF Msg Vcdo','WF Msg Vcdo','Msg WF ALVARA Vencido','Msg WF ALVARA Vencido','Msg WF ALVARA Vencido','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','N','A','R','','!Vazio()','','','','','','','','3',''} )
aAdd( aSX3, {'PA1','30','PA1_MSGAG3','C',300,0,'WF Msg Aguar','WF Msg Aguar','WF Msg Aguar','Msg WF ISS QN Aguardando','Msg WF ISS QN Aguardando','Msg WF ISS QN Aguardando','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','N','A','R','','!Vazio()','','','','','','','','4',''} )
aAdd( aSX3, {'PA1','31','PA1_MSGVG3','C',300,0,'WF Msg Vigen','WF Msg Vigen','WF Msg Vigen','Msg WF ISS QN Vigente','Msg WF ISS QN Vigente','Msg WF ISS QN Vigente','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','N','A','R','','!Vazio()','','','','','','','','4',''} )
aAdd( aSX3, {'PA1','32','PA1_MSGVC3','C',300,0,'WF Msg Vcdo','WF Msg Vcdo','WF Msg Vcdo','Msg WF ISS QN Vencido','Msg WF ISS QN Vencido','Msg WF ISS QN Vencido','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','N','A','R','','!Vazio()','','','','','','','','4',''} )
aAdd( aSX3, {'PA1','33','PA1_MSGAG4','C',300,0,'WF Msg Aguar','WF Msg Aguar','WF Msg Aguar','Msg WF CMAS/CEAS Aguardan','Msg WF CMAS/CEAS Aguardan','Msg WF CMAS/CEAS Aguardan','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','N','A','R','','!Vazio()','','','','','','','','5',''} )
aAdd( aSX3, {'PA1','34','PA1_MSGVG4','C',300,0,'WF Msg Vigen','WF Msg Vigen','WF Msg Vigen','Msg WF CMAS/CEAS Vigente','Msg WF CMAS/CEAS Vigente','Msg WF CMAS/CEAS Vigente','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','N','A','R','','!Vazio()','','','','','','','','5',''} )
aAdd( aSX3, {'PA1','35','PA1_MSGVC4','C',300,0,'WF Msg Vcdo','WF Msg Vcdo','WF Msg Vcdo','Msg WF CMAS/CEAS Vencido','Msg WF CMAS/CEAS Vencido','Msg WF CMAS/CEAS Vencido','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','N','A','R','','!Vazio()','','','','','','','','5',''} )
aAdd( aSX3, {'PA1','36','PA1_MSGAG6','C',300,0,'WF Msg Aguar','WF Msg Aguar','WF Msg Aguar','Msg WF CMDCA Aguardando','Msg WF CMDCA Aguardando','Msg WF CMDCA Aguardando','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','N','A','R','','!Vazio()','','','','','','','','7',''} )
aAdd( aSX3, {'PA1','37','PA1_MSGVG6','C',300,0,'WF Msg Vigen','WF Msg Vigen','WF Msg Vigen','Msg WF CMDCA Vigente','Msg WF CMDCA Vigente','Msg WF CMDCA Vigente','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','N','A','R','','!Vazio()','','','','','','','','7',''} )
aAdd( aSX3, {'PA1','38','PA1_MSGVC6','C',300,0,'WF Msg Vcdo','WF Msg Vcdo','WF Msg Vcdo','Msg WF CMDCA Vencido','Msg WF CMDCA Vencido','Msg WF CMDCA Vencido','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','N','A','R','','!Vazio()','','','','','','','','7',''} )
aAdd( aSX3, {'PA1','39','PA1_MSGAG7','C',250,0,'WF Msg Aguar','WF Msg Aguar','WF Msg Aguar','Msg Wf diversos Aguardand','Msg Wf diversos Aguardand','Msg Wf diversos Aguardand','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','N','A','R','','!Vazio()','','','','','','','','8',''} )
aAdd( aSX3, {'PA1','40','PA1_MSGVG7','C',250,0,'WF Msg Vigen','WF Msg Vigen','WF Msg Vigen','Msg Wf diversos Vigente','Msg Wf diversos Vigente','Msg Wf diversos Vigente','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','N','A','R','','!Vazio()','','','','','','','','8',''} )
aAdd( aSX3, {'PA1','41','PA1_MSGVC7','C',250,0,'WF Msg Vcdo','WF Msg Vcdo','WF Msg Vcdo','Msg Wf Vencidos','Msg Wf Vencidos','Msg Wf Vencidos','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','N','A','R','','!Vazio()','','','','','','','','8',''} )
aAdd( aSX3, {'PA1','42','PA1_TITUL5','C',60,0,'WF Titulo','WF Titulo','WF Titulo','Titulo E-mail WF Util.Pub','Titulo E-mail WF Util.Pub','Titulo E-mail WF Util.Pub','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','N','A','R','','!Vazio()','','','','','','','','6',''} )
aAdd( aSX3, {'PA1','43','PA1_MSGAG5','C',300,0,'WF Msg Aguar','WF Msg Aguar','WF Msg Aguar','Msg WF Util.Publica Aguar','Msg WF Util.Publica Aguar','Msg WF Util.Publica Aguar','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','N','A','R','','!Vazio()','','','','','','','','6',''} )
aAdd( aSX3, {'PA1','44','PA1_MSGVG5','C',300,0,'WF Msg Vigen','WF Msg Vigen','WF Msg Vigen','Msg WF Utild.Publica Vige','Msg WF Utild.Publica Vige','Msg WF Utild.Publica Vige','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','N','A','R','','!Vazio()','','','','','','','','6',''} )
aAdd( aSX3, {'PA1','45','PA1_MSGVC5','C',300,0,'WF Msg Vcdo','WF Msg Vcdo','WF Msg Vcdo','Msg WF Utild.Publica Venc','Msg WF Utild.Publica Venc','Msg WF Utild.Publica Venc','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','N','A','R','','!Vazio()','','','','','','','','6',''} )
//
// Tabela PA2
//
aAdd( aSX3, {'PA2','01','PA2_FILIAL','C',2,0,'Filial','Sucursal','Branch','Filial do Sistema','Sucursal','Branch of the System','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,	Chr(254) + Chr(192),'','','U','N','','','','','','','','','','','033','',''} )
aAdd( aSX3, {'PA2','02','PA2_COD','C',4,0,'Codigo','Codigo','Codigo','Codigo da Unidade','Codigo da Unidade','Codigo da Unidade','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','€','ExistChav("PA2")','','','','','inclui','','','',''} )
aAdd( aSX3, {'PA2','03','PA2_DESC','C',40,0,'Descricao','Descricao','Descricao','Descricao da Unidade','Descricao da Unidade','Descricao da Unidade','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','€','','','','','','','','','',''} )
aAdd( aSX3, {'PA2','04','PA2_END','C',75,0,'Endereco','Endereco','Endereco','Endereco da Unidade','Endereco da Unidade','Endereco da Unidade','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','€','','','','','','','','','',''} )
aAdd( aSX3, {'PA2','05','PA2_BAIRRO','C',25,0,'Bairro','Bairro','Bairro','Bairro da unidade','Bairro da unidade','Bairro da unidade','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','',''} )
aAdd( aSX3, {'PA2','06','PA2_CID','C',25,0,'Cidade','Cidade','Cidade','Cidade da unidade','Cidade da unidade','Cidade da unidade','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','€','','','','','','','','','',''} )
aAdd( aSX3, {'PA2','07','PA2_EST','C',2,0,'Estado','Estado','Estado','Estado da unidade','Estado da unidade','Estado da unidade','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','12',0,	Chr(254) + Chr(192),'','','U','S','A','R','€','ExistCpo("SX5","12"+M->PA2_EST)','','','','','','','','',''} )
aAdd( aSX3, {'PA2','08','PA2_CEP','C',8,0,'CEP','CEP','CEP','CEP da unidade','CEP da unidade','CEP da unidade','@R 99999-999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','',''} )
aAdd( aSX3, {'PA2','09','PA2_FONE','C',15,0,'Telefone','Telefone','Telefone','Telefone da unidade','Telefone da unidade','Telefone da unidade','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','',''} )
aAdd( aSX3, {'PA2','10','PA2_FAX','C',15,0,'Fax','Fax','Fax','Numero de Fax','Numero de Fax','Numero de Fax','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','',''} )
aAdd( aSX3, {'PA2','11','PA2_STATUS','C',1,0,'Status','Status','Status','Status da Unidade','Status da Unidade','Status da Unidade','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"A"','',0,	Chr(254) + Chr(192),'','','U','S','A','R','€','','A=Ativo;I=Inativo','','','',"'A'",'','','',''} )
aAdd( aSX3, {'PA2','12','PA2_IMAGEM','C',8,0,'Imagem','Imagem','Imagem','Imagem','Imagem','Imagem','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',0,	Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','',''} )
aAdd( aSX3, {'PA2','13','PA2_GER','C',2,0,'Gerencia','Gerencia','Gerencia','Descricao da Gerencia','Descricao da Gerencia','Descricao da Gerencia','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','PA5',0,	Chr(254) + Chr(192),'','S','U','S','A','R','€',"EXISTCPO('PA5')",'','','','','','','','',''} )
aAdd( aSX3, {'PA2','14','PA2_DESCGE','C',40,0,'Descricao','Descricao','Descricao','Descricao da Gerencia','Descricao da Gerencia','Descricao da Gerencia','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','',''} )
aAdd( aSX3, {'PA2','15','PA2_VOICE','C',4,0,'Voice','Voice','Voice','Voice','Voice','Voice','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','',''} )
aAdd( aSX3, {'PA2','16','PA2_BITMAP','C',8,0,'Imagem','Imagem','Imagem','Imagem','Imagem','Imagem','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,	Chr(254) + Chr(192),'','','B','N','A','R','','','','','','','','','','',''} )
aAdd( aSX3, {'PA2','17','PA2_TPUNID','C',1,0,'Tipo Unidade','Tipo Unidade','Tipo Unidade','Tipo Unidade','Tipo Unidade','Tipo Unidade','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','N','A','R','','pertence("123")','1=Unidade de Operacao;2=Posto Atendimento;3=Sala Aula Aprendiz','','','','','','','',''} )
aAdd( aSX3, {'PA2','18','PA2_OBS','C',40,0,'Observacao','Observacao','Observacao','Observacao','Observacao','Observacao','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','',''} )
//
// Tabela PA3
//
aAdd( aSX3, {'PA3','01','PA3_FILIAL','C',2,0,'Filial','Sucursal','Branch','Filial do Sistema','Sucursal','Branch of the System','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,	Chr(254) + Chr(192),'','','U','N','','','','','','','','','','','','',''} )
aAdd( aSX3, {'PA3','02','PA3_MAT','C',5,0,'Matricula','Matricula','Matricula','Matricula do responsavel','Matricula do responsavel','Matricula do responsavel','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','€','ExistChav("PA3")','','','','','INCLUI','','','',''} )
aAdd( aSX3, {'PA3','03','PA3_RESP','C',45,0,'Nome','Nome','Nome','Nome do responsavel','Nome do responsavel','Nome do responsavel','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','€','','','','','','','','','',''} )
aAdd( aSX3, {'PA3','04','PA3_EMAIL','C',35,0,'E-mail','E-mail','E-mail','E-mail do responsavel','E-mail do responsavel','E-mail do responsavel','!@','U_VALMAIL()',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','€','','','','','','','','','',''} )
aAdd( aSX3, {'PA3','05','PA3_NIVEL','C',2,0,'Nivel','Nivel','Nivel','Nivel do responsavel','Nivel do responsavel','Nivel do responsavel','@!','U_CIE03NIV()',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','€','','01=Operacional;02=Supervisor;03=Gerente;04=Superintendente;05=Auditoria;06=Gerente Adjunto','01=Operacional;02=Supervisor;03=Gerente;04=Superintendente;05=Auditoria;06=Gerente Adjunto','01=Operacional;02=Supervisor;03=Gerente;04=Superintendente;05=Auditoria;06=Gerente Adjunto','','','','','',''} )
aAdd( aSX3, {'PA3','06','PA3_STATUS','C',1,0,'Status','Status','Status','Status do Responsavel','Status do Responsavel','Status do Responsavel','@!','IIF(PA3_STATUS=="A", U_CIE03STS(M->PA3_MAT),.T.)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"A"','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','A=Ativo;I=Inativo','A=Ativo;I=Inativo','A=Ativo;I=Inativo','','','','','',''} )
aAdd( aSX3, {'PA3','07','PA3_CELUL','C',8,0,'Celular','Celular','Celular','Celular do Responsavel','Celular do Responsavel','Celular do Responsavel','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','',''} )
//
// Tabela PA4
//
aAdd( aSX3, {'PA4','01','PA4_FILIAL','C',2,0,'Filial','Sucursal','Branch','Filial do Sistema','Sucursal','Branch of the System','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,	Chr(254) + Chr(192),'','','U','N','','','','','','','','','','','','',''} )
aAdd( aSX3, {'PA4','02','PA4_COD','C',6,0,'Codigo','Codigo','Codigo','Codigo de vigencia','Codigo de vigencia','Codigo de vigencia','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'GETSXENUM("PA1","PA1_COD")','',0,	Chr(254) + Chr(192),'','S','U','S','V','R','€','','','','','','inclui','','','',''} )
aAdd( aSX3, {'PA4','03','PA4_CODUNI','C',4,0,'Unidade','Unidade','Unidade','Codigo da Unidade','Codigo da Unidade','Codigo da Unidade','@!','U_LOADIMGUN("unidade")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','PA2',0,	Chr(254) + Chr(192),'','S','U','S','A','R','€',"EXISTCPO('PA2') .AND. U_CIE04A()",'','','','','','','','',''} )
aAdd( aSX3, {'PA4','04','PA4_DESCUN','C',40,0,'Descricao','Descriccao','Descriccao','Descricao da unidade','Descricao da unidade','Descricao da unidade','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','',''} )
aAdd( aSX3, {'PA4','05','PA4_CODDOC','C',6,0,'Documento','Documento','Documento','Codigo do Documento','Codigo do Documento','Codigo do Documento','@!','U_LOADIMGUN("documento")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','PA1',0,	Chr(254) + Chr(192),'','S','U','S','A','R','€',"EXISTCPO('PA1')",'','','','','','','','',''} )
aAdd( aSX3, {'PA4','06','PA4_DESCDO','C',20,0,'Desc. Doc.','Desc. Doc.','Desc. Doc.','Descricao do Documento','Descricao do Documento','Descricao do Documento','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','',''} )
aAdd( aSX3, {'PA4','07','PA4_NUMDOC','C',20,0,'Num Docto','Num Docto','Num Docto','Numero Documento','Numero Documento','Numero Documento','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','V','R','','','','','','U_MAK(M->PA4_CODDOC)','','','','',''} )
aAdd( aSX3, {'PA4','08','PA4_CTVCTO','C',1,0,'Cont Vencto','Cont Vencto','Cont Vencto','Controle do vencimento','Controle do vencimento','Controle do vencimento','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"S"','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','S=Sim;N=Nao','','','','','','','',''} )
aAdd( aSX3, {'PA4','09','PA4_DTABER','D',8,0,'Abertura','Abertura','Abertura','Data da Abertura','Data da Abertura','Data da Abertura','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','',''} )
aAdd( aSX3, {'PA4','10','PA4_DTVCTO','D',8,0,'Vencimento','Vencimento','Vencimento','Data do vencimento','Data do vencimento','Data do vencimento','','IIF(PA4_DTABER>PA4_DTVCTO, U_PA4DATA(M->PA4_DTABER,M->PA4_DTVCTO),.T.)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','',''} )
aAdd( aSX3, {'PA4','11','PA4_DTREG','D',8,0,'DT Regulariz','Dt Regulariz','Dt Regulariz','Data de Regularizacao','Data de Regularizacao','Data de Regularizacao','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','',''} )
aAdd( aSX3, {'PA4','12','PA4_DTENCE','D',8,0,'Encerramento','Encerramento','Encerramento','Data do encerramento','Data do encerramento','Data do encerramento','@!','IIF(PA4_DTABER>PA4_DTENCE, U_PA4DATA1(M->PA4_DTABER,M->PA4_DTENCE),.T.)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','',''} )
aAdd( aSX3, {'PA4','13','PA4_INDEFE','C',1,0,'Indeferido','Indeferido','Indeferido','Indeferido','Indeferido','Indeferido','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"N"','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','S=Sim;N=Nao','','','','','','','',''} )
aAdd( aSX3, {'PA4','14','PA4_ENCE','C',1,0,'Encerrado','Encerrado','Encerrado','Encerrado','Encerrado','Encerrado','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"N"','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','S=Sim;N=Nao','','','',"PA4->PA4_ENCE == 'N'",'','','',''} )
aAdd( aSX3, {'PA4','15','PA4_STATUS','C',15,0,'Status','Status','Status','Status da Vigencia','Status da Vigencia','Status da Vigencia','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','N','V','R','','','','','','','','','','',''} )
aAdd( aSX3, {'PA4','16','PA4_DTENVI','D',8,0,'Dt Envio WF','Dt Envio WF','Dt Envio WF','Data de Envio do Workflow','Data de Envio do Workflow','Data de Envio do Workflow','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','',''} )
aAdd( aSX3, {'PA4','17','PA4_OBS','M',10,0,'Observacao','Observacao','Observacao','Observacao','Observacao','Observacao','@S40','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','',''} )
//
// Tabela PA5
//
aAdd( aSX3, {'PA5','01','PA5_FILIAL','C',2,0,'Filial','Sucursal','Branch','Filial do Sistema','Sucursal','Branch of the System','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,	Chr(254) + Chr(192),'','','U','N','','','','','','','','','','','','',''} )
aAdd( aSX3, {'PA5','02','PA5_COD','C',2,0,'Codigo','Codigo','Codigo','Codigo da gerencia','Codigo da gerencia','Codigo da gerencia','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','€','ExistChav("PA5")','','','','','INCLUI','','','',''} )
aAdd( aSX3, {'PA5','03','PA5_DESC','C',40,0,'Descricao','Descricao','Descricao','Descricao da gerencia','Descricao da gerencia','Descricao da gerencia','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','€','','','','','','','','','',''} )
//
// Tabela PA6
//
aAdd( aSX3, {'PA6','01','PA6_FILIAL','C',2,0,'Filial','Sucursal','Branch','Filial do Sistema','Sucursal','Branch of the System','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,	Chr(254) + Chr(192),'','','U','N','','','','','','','','','','','','',''} )
aAdd( aSX3, {'PA6','02','PA6_STATUS','C',1,0,'Status','Status','Status','Status do documento','Status do documento','Status do documento','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','€','IIF(!EMPTY(M->PA6_SEQ),EXISTchav("PA6",M->PA6_STATUS+M->PA6_SEQ),.T.)','1=Aguardando;2=Vigente;3=Vencido','1=Aguardando;2=Vigente;3=Vencido','1=Aguardando;2=Vigente;3=Vencido','','','','','',''} )
aAdd( aSX3, {'PA6','03','PA6_SEQ','C',3,0,'Sequencia','Sequencia','Sequencia','Sequencia para envio','Sequencia para envio','Sequencia para envio','999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','€','existchav("PA6",M->PA6_STATUS+M->PA6_SEQ)','','','','','','','','',''} )
aAdd( aSX3, {'PA6','04','PA6_ASSUN','C',40,0,'Assunto','Assunto','Assunto','Assunto do workflow','Assunto do workflow','Assunto do workflow','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','€','','','','','','','','','',''} )
aAdd( aSX3, {'PA6','05','PA6_QTD','N',3,0,'Qtd Dias','Qtd Dias','Qtd Dias','Quantidade de dias','Quantidade de dias','Quantidade de dias','999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','€','','','','','','','','','',''} )
aAdd( aSX3, {'PA6','06','PA6_NIV1','C',2,0,'Nivel 1','Nivel 1','Nivel 1','Nivel enviado','Nivel enviado','Nivel enviado','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','€',"!M->PA6_NIV1$(M->PA6_NIV2+'/'+M->PA6_NIV3+'/'+M->PA6_NIV4+'/'+M->PA6_NIV5+'/'+M->PA6_NIV6)",'01=Operacional;02=Supervisor;03=Gerente;04=Superintendente;05=Auditoria;06=Gerente Adjunto','01=Operacional;02=Supervisor;03=Gerente;04=Superintendente;05=Auditoria;06=Gerente Adjunto','01=Operacional;02=Supervisor;03=Gerente;04=Superintendente;05=Auditoria;06=Gerente Adjunto','','','','','',''} )
aAdd( aSX3, {'PA6','07','PA6_NIV2','C',2,0,'Nivel 2','Nivel 2','Nivel 2','Nivel 2','Nivel 2','Nivel 2','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','',"EMPTY(M->PA6_NIV2).OR.!M->PA6_NIV2$(M->PA6_NIV1+'/'+M->PA6_NIV3+'/'+M->PA6_NIV4+'/'+M->PA6_NIV5+'/'+M->PA6_NIV6)",'01=Operacional;02=Supervisor;03=Gerente;04=Superintendente;05=Auditoria;06=Gerente Adjunto','01=Operacional;02=Supervisor;03=Gerente;04=Superintendente;05=Auditoria;06=Gerente Adjunto','01=Operacional;02=Supervisor;03=Gerente;04=Superintendente;05=Auditoria;06=Gerente Adjunto','','','','','',''} )
aAdd( aSX3, {'PA6','08','PA6_NIV3','C',2,0,'Nivel 3','Nivel 3','Nivel 3','Nivel 3','Nivel 3','Nivel 3','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','',"EMPTY(M->PA6_NIV3).OR.!M->PA6_NIV3$(M->PA6_NIV1+'/'+M->PA6_NIV2+'/'+M->PA6_NIV4+'/'+M->PA6_NIV5+'/'+M->PA6_NIV6)",'01=Operacional;02=Supervisor;03=Gerente;04=Superintendente;05=Auditoria;06=Gerente Adjunto','01=Operacional;02=Supervisor;03=Gerente;04=Superintendente;05=Auditoria;06=Gerente Adjunto','01=Operacional;02=Supervisor;03=Gerente;04=Superintendente;05=Auditoria;06=Gerente Adjunto','','','','','',''} )
aAdd( aSX3, {'PA6','09','PA6_NIV4','C',2,0,'Nivel 4','Nivel 4','Nivel 4','Nivel 4','Nivel 4','Nivel 4','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','',"EMPTY(M->PA6_NIV4).OR.!M->PA6_NIV4$(M->PA6_NIV1+'/'+M->PA6_NIV2+'/'+M->PA6_NIV3+'/'+M->PA6_NIV5+'/'+M->PA6_NIV6)",'01=Operacional;02=Supervisor;03=Gerente;04=Superintendente;05=Auditoria;06=Gerente Adjunto','01=Operacional;02=Supervisor;03=Gerente;04=Superintendente;05=Auditoria;06=Gerente Adjunto','01=Operacional;02=Supervisor;03=Gerente;04=Superintendente;05=Auditoria;06=Gerente Adjunto','','','','','',''} )
aAdd( aSX3, {'PA6','10','PA6_NIV5','C',2,0,'Nivel 5','Nivel 5','Nivel 5','Nivel 5','Nivel 5','Nivel 5','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','',"EMPTY(M->PA6_NIV5).OR.!M->PA6_NIV5$(M->PA6_NIV1+'/'+M->PA6_NIV2+'/'+M->PA6_NIV3+'/'+M->PA6_NIV4+'/'+M->PA6_NIV6)",'01=Operacional;02=Supervisor;03=Gerente;04=Superintendente;05=Auditoria;06=Gerente Adjunto','01=Operacional;02=Supervisor;03=Gerente;04=Superintendente;05=Auditoria;06=Gerente Adjunto','01=Operacional;02=Supervisor;03=Gerente;04=Superintendente;05=Auditoria;06=Gerente Adjunto','','','','','',''} )
aAdd( aSX3, {'PA6','11','PA6_NIV6','C',2,0,'Nivel 6','Nivel 6','Nivel 6','Nivel 6','Nivel 6','Nivel 6','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','',"EMPTY(M->PA6_NIV6).OR.!M->PA6_NIV6$(M->PA6_NIV1+'/'+M->PA6_NIV2+'/'+M->PA6_NIV3+'/'+M->PA6_NIV4+'/'+M->PA6_NIV5)",'01=Operacional;02=Supervisor;03=Gerente;04=Superintendente;05=Auditoria;06=Gerente Adjunto','01=Operacional;02=Supervisor;03=Gerente;04=Superintendente;05=Auditoria;06=Gerente Adjunto','01=Operacional;02=Supervisor;03=Gerente;04=Superintendente;05=Auditoria;06=Gerente Adjunto','','','','','',''} )
aAdd( aSX3, {'PA6','12','PA6_PERI','C',10,0,'Periodicidad','Periodicidad','Periodicidad','Periodicidade','Periodicidade','Periodicidade','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','S','A','R','','','','','','','','','','',''} )
//
// Tabela PA7
//
aAdd( aSX3, {'PA7','01','PA7_FILIAL','C',2,0,'Filial','Sucursal','Branch','Filial do Sistema','Sucursal','Branch of the System','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,	Chr(254) + Chr(192),'','','U','N','','','','','','','','','','','','',''} )
aAdd( aSX3, {'PA7','02','PA7_COD','C',4,0,'Codigo','Codigo','Codigo','Codigo da Unidade','Codigo da Unidade','Codigo da Unidade','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',0,	Chr(254) + Chr(192),'','','U','N','A','R','€','ExistCpo("PA2")','','','','','','','','',''} )
aAdd( aSX3, {'PA7','03','PA7_RESP','C',6,0,'Matricula','Matricula','Matricula','Codigo da Gerencia','Codigo da Gerencia','Codigo da Gerencia','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','PA3',0,	Chr(254) + Chr(192),'','S','U','S','A','R','','ExistCpo("PA3")','','','','','','','','',''} )
aAdd( aSX3, {'PA7','04','PA7_DESRES','C',45,0,'Nome','Nome','Nome','Nome','Nome','Nome','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'IIF(!INCLUI,Posicione(' + DUPLAS  + 'PA3' + DUPLAS  + ', 1, xFilial(' + DUPLAS  + 'PA3' + DUPLAS  + ')+PA7->PA7_RESP,' + DUPLAS  + 'PA3_RESP' + DUPLAS  + ' ),' + SIMPLES + '' + SIMPLES + ')','',0,	Chr(254) + Chr(192),'','','U','S','V','V','','','','','','','','Posicione("PA3", 1, xFilial("PA3")+PA7->PA7_RESP,"PA3_RESP")','','',''} )
aAdd( aSX3, {'PA7','05','PA7_NIVEL','C',2,0,'Nivel','Nivel','Nivel','Nivel','Nivel','Nivel','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'IIF(!INCLUI,POSICIONE(' + DUPLAS  + 'PA3' + DUPLAS  + ', 1, XFILIAL(' + DUPLAS  + 'PA3' + DUPLAS  + ')+PA7->PA7_RESP,' + DUPLAS  + 'PA3_NIVEL' + DUPLAS  + '),' + SIMPLES + '' + SIMPLES + ')','',0,	Chr(254) + Chr(192),'','','U','S','V','V','','','','','','','','Posicione("PA3", 1, xFilial("PA3")+PA7->PA7_NIVEL,"PA3_NIVEL")','','',''} )
aAdd( aSX3, {'PA7','06','PA7_DESNIV','C',15,0,'Desc.Nivel','Desc.Nivel','Desc.Nivel','Desc.Nivel','Desc.Nivel','Desc.Nivel','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),"IIF(!inclui,X3COMBO('PA3_NIVEL',PA3->PA3_NIVEL),'')",'',0,	Chr(254) + Chr(192),'','','U','S','V','V','','','','','','','',"X3COMBO('PA3_NIVEL',PA3->PA3_NIVEL)",'','',''} )
//
// Tabela PA8
//
aAdd( aSX3, {'PA8','01','PA8_FILIAL','C',2,0,'Filial','Sucursal','Branch','Filial do Sistema','Sucursal','Branch of the System','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,	Chr(254) + Chr(192),'','','U','N','','','','','','','','','','','','',''} )
aAdd( aSX3, {'PA8','02','PA8_MAT','C',6,0,'Matricula','Matricula','Matricula','Matricula do responsavel','Matricula do responsavel','Matricula do responsavel','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','S','U','S','A','R','€','','','','','','.F.','','','',''} )
aAdd( aSX3, {'PA8','03','PA8_RESP','C',40,0,'Responsavel','Responsavel','Responsavel','Nome do responsavel','Nome do responsavel','Nome do responsavel','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'IIF(!INCLUI,Posicione(' + DUPLAS  + 'PA3' + DUPLAS  + ', 1, xFilial(' + DUPLAS  + 'PA3' + DUPLAS  + ')+PA8->PA8_MAT,' + DUPLAS  + 'PA3_RESP' + DUPLAS  + '),' + SIMPLES + '' + SIMPLES + ')','',0,	Chr(254) + Chr(192),'','','U','S','V','V','','','','','','','','Posicione("PA3", 1, xFilial("PA3")+PA8->PA8_MAT,"PA3_RESP")','','',''} )
aAdd( aSX3, {'PA8','04','PA8_NIVEL','C',2,0,'Nivel','Nivel','Nivel','Nivel do responsavel','Nivel do responsavel','Nivel do responsavel','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'IIF(!INCLUI,Posicione(' + DUPLAS  + 'PA3' + DUPLAS  + ', 1, xFilial(' + DUPLAS  + 'PA3' + DUPLAS  + ')+PA8->PA8_NIVEL,' + DUPLAS  + 'PA3_NIVEL' + DUPLAS  + '),' + SIMPLES + '' + SIMPLES + ')','',0,	Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','Posicione("PA3", 1, xFilial("PA3")+PA8->PA8_NIVEL,"PA3_NIVEL")','','',''} )
aAdd( aSX3, {'PA8','05','PA8_DESNIV','C',15,0,'Desc.Nivel','Desc.Nivel','Desc.Nivel','Desc.Nivel','Desc.Nivel','Desc.Nivel','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),"IIF(!inclui,X3COMBO('PA3_NIVEL',PA3->PA3_NIVEL),'')",'',0,	Chr(254) + Chr(192),'','','U','S','V','V','','','','','','','',"X3COMBO('PA3_NIVEL',PA3->PA3_NIVEL)",'','',''} )
aAdd( aSX3, {'PA8','06','PA8_ORIGEM','C',3,0,'Origem','Origem','Origem','Origem','Origem','Origem','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,	Chr(254) + Chr(192),'','','U','N','V','R','','','','','','','','','','',''} )
aAdd( aSX3, {'PA8','07','PA8_COD','C',6,0,'Codigo','Codigo','Codigo','Codigo de vigencia','Codigo de vigencia','Codigo de vigencia','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',0,	Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','',''} )
//
// Atualizando dicionแrio
//

nPosArq := aScan( aEstrut, { |x| AllTrim( x ) == "X3_ARQUIVO" } )
nPosOrd := aScan( aEstrut, { |x| AllTrim( x ) == "X3_ORDEM"   } )
nPosCpo := aScan( aEstrut, { |x| AllTrim( x ) == "X3_CAMPO"   } )
nPosTam := aScan( aEstrut, { |x| AllTrim( x ) == "X3_TAMANHO" } )
nPosSXG := aScan( aEstrut, { |x| AllTrim( x ) == "X3_GRPSXG"  } )

aSort( aSX3,,, { |x,y| x[nPosArq]+x[nPosOrd]+x[nPosCpo] < y[nPosArq]+y[nPosOrd]+y[nPosCpo] } )

oProcess:SetRegua2( Len( aSX3 ) )

dbSelectArea( "SX3" )
dbSetOrder( 2 )
cAliasAtu := ""

For nI := 1 To Len( aSX3 )

	//
	// Verifica se o campo faz parte de um grupo e ajsuta tamanho
	//
	If !Empty( aSX3[nI][nPosSXG] )
		SXG->( dbSetOrder( 1 ) )
		If SXG->( MSSeek( aSX3[nI][nPosSXG] ) )
			If aSX3[nI][nPosTam] <> SXG->XG_SIZE
				aSX3[nI][nPosTam] := SXG->XG_SIZE
				cTexto += "O tamanho do campo " + aSX3[nI][nPosCpo] + " nao atualizado e foi mantido em ["
				cTexto += AllTrim( Str( SXG->XG_SIZE ) ) + "]" + CRLF
				cTexto += "   por pertencer ao grupo de campos [" + SX3->X3_GRPSXG + "]" + CRLF + CRLF
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
				FieldPut( FieldPos( aEstrut[nJ] ), cSeqAtu )

			ElseIf FieldPos( aEstrut[nJ] ) > 0
				FieldPut( FieldPos( aEstrut[nJ] ), aSX3[nI][nJ] )

			EndIf
		Next nJ

		dbCommit()
		MsUnLock()

		cTexto += "Criado o campo " + aSX3[nI][nPosCpo] + CRLF

	Else

		//
		// Verifica se o campo faz parte de um grupo e ajsuta tamanho
		//
		If !Empty( SX3->X3_GRPSXG ) .AND. SX3->X3_GRPSXG <> aSX3[nI][nPosSXG]
			SXG->( dbSetOrder( 1 ) )
			If SXG->( MSSeek( SX3->X3_GRPSXG ) )
				If aSX3[nI][nPosTam] <> SXG->XG_SIZE
					aSX3[nI][nPosTam] := SXG->XG_SIZE
					cTexto +=  "O tamanho do campo " + aSX3[nI][nPosCpo] + " nao atualizado e foi mantido em ["
					cTexto += AllTrim( Str( SXG->XG_SIZE ) ) + "]"+ CRLF
					cTexto +=  "   por pertencer ao grupo de campos [" + SX3->X3_GRPSXG + "]" + CRLF + CRLF
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
			If aEstrut[nJ] == SX3->( FieldName( nJ ) ) .AND. ;
				PadR( StrTran( AllToChar( SX3->( FieldGet( nJ ) ) ), " ", "" ), 250 ) <> ;
				PadR( StrTran( AllToChar( aSX3[nI][nJ] )           , " ", "" ), 250 ) .AND. ;
				AllTrim( SX3->( FieldName( nJ ) ) ) <> "X3_ORDEM"

				cMsg := "O campo " + aSX3[nI][nPosCpo] + " estแ com o " + SX3->( FieldName( nJ ) ) + ;
				" com o conte๚do" + CRLF + ;
				"[" + RTrim( AllToChar( SX3->( FieldGet( nJ ) ) ) ) + "]" + CRLF + ;
				"que serแ substituido pelo NOVO conte๚do" + CRLF + ;
				"[" + RTrim( AllToChar( aSX3[nI][nJ] ) ) + "]" + CRLF + ;
				"Deseja substituir ? "

				If      lTodosSim
					nOpcA := 1
				ElseIf  lTodosNao
					nOpcA := 2
				Else
					nOpcA := Aviso( "ATUALIZAวรO DE DICIONมRIOS E TABELAS", cMsg, { "Sim", "Nใo", "Sim p/Todos", "Nใo p/Todos" }, 3, "Diferen็a de conte๚do - SX3" )
					lTodosSim := ( nOpcA == 3 )
					lTodosNao := ( nOpcA == 4 )

					If lTodosSim
						nOpcA := 1
						lTodosSim := MsgNoYes( "Foi selecionada a op็ใo de REALIZAR TODAS altera็๕es no SX3 e NรO MOSTRAR mais a tela de aviso." + CRLF + "Confirma a a็ใo [Sim p/Todos] ?" )
					EndIf

					If lTodosNao
						nOpcA := 2
						lTodosNao := MsgNoYes( "Foi selecionada a op็ใo de NรO REALIZAR nenhuma altera็ใo no SX3 que esteja diferente da base e NรO MOSTRAR mais a tela de aviso." + CRLF + "Confirma esta a็ใo [Nใo p/Todos]?" )
					EndIf

				EndIf

				If nOpcA == 1
					cTexto += "Alterado o campo " + aSX3[nI][nPosCpo] + CRLF
					cTexto += "   " + PadR( SX3->( FieldName( nJ ) ), 10 ) + " de [" + AllToChar( SX3->( FieldGet( nJ ) ) ) + "]" + CRLF
					cTexto += "            para [" + AllToChar( aSX3[nI][nJ] )          + "]" + CRLF + CRLF

					RecLock( "SX3", .F. )
					FieldPut( FieldPos( aEstrut[nJ] ), aSX3[nI][nJ] )
					dbCommit()
					MsUnLock()
				EndIf

			EndIf

		Next

	EndIf

	oProcess:IncRegua2( "Atualizando Campos de Tabelas (SX3)..." )

Next nI

cTexto += CRLF + "Final da Atualizacao" + " SX3" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSAtuSIX บ Autor ณ TOTVS Protheus     บ Data ณ  17/10/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da gravacao do SIX - Indices       ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSAtuSIX   - Gerado por EXPORDIC / Upd. V.4.10.6 EFS       ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FSAtuSIX( cTexto )
Local aEstrut   := {}
Local aSIX      := {}
Local lAlt      := .F.
Local lDelInd   := .F.
Local nI        := 0
Local nJ        := 0

cTexto  += "Inicio da Atualizacao" + " SIX" + CRLF + CRLF

aEstrut := { "INDICE" , "ORDEM" , "CHAVE", "DESCRICAO", "DESCSPA"  , ;
             "DESCENG", "PROPRI", "F3"   , "NICKNAME" , "SHOWPESQ" }

//
// Tabela PA1
//
aAdd( aSIX, {'PA1','1','PA1_FILIAL+PA1_COD','Codigo','Codigo','Codigo','U','','',''} )
aAdd( aSIX, {'PA1','2','PA1_FILIAL+PA1_DESC','Descricao Documento','Descricao Documento','Descricao Documento','U','','',''} )
aAdd( aSIX, {'PA1','3','PA1_FILIAL+PA1_TPDOC','Tipo Docto','Tipo Docto','Tipo Docto','U','','',''} )
//
// Tabela PA2
//
aAdd( aSIX, {'PA2','1','PA2_FILIAL+PA2_COD','Codigo','Codigo','Codigo','U','','',''} )
aAdd( aSIX, {'PA2','2','PA2_FILIAL+PA2_DESC','Descricao','Descricao','Descricao','U','','',''} )
aAdd( aSIX, {'PA2','3','PA2_FILIAL+PA2_GER','Gerente','Gerente','Gerente','U','','',''} )
//
// Tabela PA3
//
aAdd( aSIX, {'PA3','1','PA3_FILIAL+PA3_MAT','Matricula','Matricula','Matricula','U','','',''} )
aAdd( aSIX, {'PA3','2','PA3_FILIAL+PA3_RESP','Responsavel','Responsavel','Responsavel','U','','',''} )
aAdd( aSIX, {'PA3','3','PA3_FILIAL+PA3_NIVEL+PA3_MAT','Nivel + Matricula','Nivel+Matricula','Nivel+Matricula','U','','',''} )
//
// Tabela PA4
//
aAdd( aSIX, {'PA4','1','PA4_FILIAL+PA4_COD','Codigo','Codigo','Codigo','U','','',''} )
aAdd( aSIX, {'PA4','2','PA4_FILIAL+PA4_CODUNI+PA4_CODDOC','Cod. Unidade+Documento','Cod. Unidade+Documento','Cod. Unidade+Documento','U','','',''} )
aAdd( aSIX, {'PA4','3','PA4_FILIAL+PA4_DESCUN+PA4_CODDOC','Desc. Unidade+Documento','Desc. Unidade+Documento','Desc. Unidade+Documento','U','','',''} )
aAdd( aSIX, {'PA4','4','PA4_FILIAL+PA4_CODDOC+PA4_CODUNI','Documento+Cod Unidade','Documento+Cod Unidade','Documento+Cod Unidade','U','','',''} )
aAdd( aSIX, {'PA4','5','PA4_FILIAL+PA4_CODDOC+PA4_DESCUN','Documento+Desc. Unidade','Documento+Desc. Unidade','Documento+Desc. Unidade','U','','',''} )
aAdd( aSIX, {'PA4','6','PA4_FILIAL+PA4_STATUS+PA4_DESCUN','Status+Descricao','Status+Descriccao','Status+Descriccao','U','','','S'} )
aAdd( aSIX, {'PA4','8','PA4_FILIAL+PA4_DTVCTO','Vencimento','Vencimento','Vencimento','U','','',''} )
aAdd( aSIX, {'PA4','9','PA4_FILIAL+PA4_DTABER','Abertura','Abertura','Abertura','U','','',''} )
aAdd( aSIX, {'PA4','A','PA4_FILIAL+PA4_DTENVI+PA4_DESCUN+PA4_DESCDO','Dt Envio WF+Descricao+Desc. Doc.','Dt Envio WF+Descriccao+Desc. Doc.','Dt Envio WF+Descriccao+Desc. Doc.','U','','','S'} )
//
// Tabela PA5
//
aAdd( aSIX, {'PA5','1','PA5_FILIAL+PA5_COD','Codigo','Codigo','Codigo','U','','',''} )
aAdd( aSIX, {'PA5','2','PA5_FILIAL+PA5_DESC','Descricao','Descricao','Descricao','U','','',''} )
//
// Tabela PA6
//
aAdd( aSIX, {'PA6','1','PA6_FILIAL+PA6_STATUS+PA6_SEQ','Status+Sequencia','Status+Sequencia','Status+Sequencia','U','','',''} )
aAdd( aSIX, {'PA6','2','PA6_FILIAL+PA6_STATUS+PA6_QTD','Status+Qtd Dias','Status+Qtd Dias','Status+Qtd Dias','U','','',''} )
aAdd( aSIX, {'PA6','3','PA6_FILIAL+PA6_STATUS+PA6_PERI','Status+Periodicidad','Sucursal+Status+Periodicidad','Branch+Status+Periodicidad','U','','',''} )
//
// Tabela PA7
//
aAdd( aSIX, {'PA7','1','PA7_FILIAL+PA7_COD+PA7_RESP','Unidade + Responsavel','Unidade + Responsavel','Unidade + Responsavel','U','','',''} )
aAdd( aSIX, {'PA7','2','PA7_FILIAL+PA7_RESP+PA7_COD','Responsavel + Unidade','Responsavel + Unidade','Responsavel + Unidade','U','','',''} )
//
// Tabela PA8
//
aAdd( aSIX, {'PA8','1','PA8_FILIAL+PA8_COD+PA8_MAT','Unidade + Responsavel','Unidade + Responsavel','Unidade + Responsavel','U','','',''} )
aAdd( aSIX, {'PA8','2','PA8_FILIAL+PA8_MAT+PA8_COD','Responsavel + Unidade','Responsavel + Unidade','Responsavel + Unidade','U','','',''} )
//
// Atualizando dicionแrio
//
oProcess:SetRegua2( Len( aSIX ) )

dbSelectArea( "SIX" )
SIX->( dbSetOrder( 1 ) )

For nI := 1 To Len( aSIX )

	lAlt    := .F.
	lDelInd := .F.

	If !SIX->( dbSeek( aSIX[nI][1] + aSIX[nI][2] ) )
		cTexto += "อndice criado " + aSIX[nI][1] + "/" + aSIX[nI][2] + " - " + aSIX[nI][3] + CRLF
	Else
		lAlt := .T.
		aAdd( aArqUpd, aSIX[nI][1] )
		If !StrTran( Upper( AllTrim( CHAVE )       ), " ", "") == ;
		    StrTran( Upper( AllTrim( aSIX[nI][3] ) ), " ", "" )
			cTexto += "Chave do ํndice alterado " + aSIX[nI][1] + "/" + aSIX[nI][2] + " - " + aSIX[nI][3] + CRLF
			lDelInd := .T. // Se for alteracao precisa apagar o indice do banco
		Else
			cTexto += "Indice alterado " + aSIX[nI][1] + "/" + aSIX[nI][2] + " - " + aSIX[nI][3] + CRLF
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

	oProcess:IncRegua2( "Atualizando ํndices..." )

Next nI

cTexto += CRLF + "Final da Atualizacao" + " SIX" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSAtuSX6 บ Autor ณ TOTVS Protheus     บ Data ณ  17/10/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da gravacao do SX6 - Parโmetros    ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSAtuSX6   - Gerado por EXPORDIC / Upd. V.4.10.6 EFS       ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FSAtuSX6( cTexto )
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

cTexto  += "Inicio da Atualizacao" + " SX6" + CRLF + CRLF

aEstrut := { "X6_FIL"    , "X6_VAR"  , "X6_TIPO"   , "X6_DESCRIC", "X6_DSCSPA" , "X6_DSCENG" , "X6_DESC1"  , "X6_DSCSPA1",;
             "X6_DSCENG1", "X6_DESC2", "X6_DSCSPA2", "X6_DSCENG2", "X6_CONTEUD", "X6_CONTSPA", "X6_CONTENG", "X6_PROPRI" , "X6_PYME" }

aAdd( aSX6, {'  ','CI_CRRESP','C','Unidade sob responsabilidade de Sao Paulo com rela','','','cao a contas de Telefone','','','','','','055/061/062/063/064/065/066/067/068/069/070/071/119/129/147/151/154/155/156/166/168/169/170/172/186/188/189/190/194/229/260/266/268/271/286/289/803/813/816/824/828/829/830/831/832/837/851/856/871/884/914/924','','','U',''} )
aAdd( aSX6, {'  ','CI_CTAFFC','C','Ctas que nao irao compor valor de Prestacao de Con','','','tas (Controle Cartao ITAU). IMPOSTOS','','','','','','2140211/2130611/2130911/2140111/2140311/2140411/49114','','','U',''} )
aAdd( aSX6, {'  ','CI_DATAJOB','D','Ultimo processamento do Job de controle das SSIs','','','','','','','','','20140909','20140909','20140909','U',''} )
aAdd( aSX6, {'  ','CI_DIAS','N','DIAS A CONTAR A PARTIR DO E-MAIL DISPARADO ANTERIO','','','RMENTE PARA BLOQUEAR O CARTAO DO COLABORADOR','','','CONTA CARTAO ITAU','','','15','10','10','U',''} )
aAdd( aSX6, {'  ','CI_DTAJUS','C','Dia em que foi realizado um ajuste','','','','','','','','','20140425','20071231','20071231','U',''} )
aAdd( aSX6, {'  ','CI_DTFECH','C','Mes e Ano do Fechamento do Processo Reserva Financ','','','eira','','','','','','20140430','20080531','20080531','U',''} )
aAdd( aSX6, {'  ','CI_DTVENC','N','Meses de Vencimento do Cartใo','Meses de Vencimento do Cartใo','Meses de Vencimento do Cartใo','Meses de Vencimento do Cartใo','Meses de Vencimento do Cartใo','Meses de Vencimento do Cartใo','Meses de Vencimento do Cartใo','Meses de Vencimento do Cartใo','Meses de Vencimento do Cartใo','90','90','90','U',''} )
aAdd( aSX6, {'  ','CI_EMAIL1','C','E-mail Responsavel pelas contas de Telefone','','','','','','','','','telecom@ciee.org.br','telecom@ciee.org.br','telecom@ciee.org.br','U',''} )
aAdd( aSX6, {'  ','CI_EMAIL2','C','E-mail Supervisor pelas contas de Telefone','','','','','','','','','jairo@cieesp.org.br','jairo@cieesp.org.br','jairo@cieesp.org.br','U',''} )
aAdd( aSX6, {'  ','CI_EMAIL3','C','E-mail Gerente pelas contas de Telefone','','','','','','','','','silvio@cieesp.org.br','silvio@cieesp.org.br','silvio@cieesp.org.br','U',''} )
aAdd( aSX6, {'  ','CI_EMAIL4','C','E-mail Auditoria pelas contas de Telefone','','','','','','','','','auditoria@cieesp.org.br','auditoria@cieesp.org.br','auditoria@cieesp.org.br','U',''} )
aAdd( aSX6, {'  ','CI_FLIREG','C','Conta transitora utilizada para SOBRA das pagament','','','os parciais e para a inclusao das REEMISSOES','','','','','','1220611','','','U',''} )
aAdd( aSX6, {'  ','CI_HRCTFIM','C','Horแrio final de movimenta็ใo financeiro do Cartใo','Horแrio final de movimenta็ใo financeiro do Cartใo','Horแrio final de movimenta็ใo financeiro do Cartใo','de Cr้dito ITAU','de Cr้dito ITAU','de Cr้dito ITAU','','','','16:00:00','16:00:00','16:00:00','U',''} )
aAdd( aSX6, {'  ','CI_HRCTINI','C','Horแrio inicial de movimenta็ใo financeiro do Cart','Horแrio inicial de movimenta็ใo financeiro do Cart','Horแrio inicial de movimenta็ใo financeiro do Cart','ใo de Cr้dito ITAU','ใo de Cr้dito ITAU','ใo de Cr้dito ITAU','','','','00:00:01','00:00:01','00:00:01','U',''} )
aAdd( aSX6, {'  ','CI_LOTEAP','C','Numero de lote para exportar os dados  da copia de','','','cheque.','','','','','','009700','009700','009700','U',''} )
aAdd( aSX6, {'  ','CI_LOTEDM','C','Numero de lote utilizado para exportar os dados','','','dos documentos de consumo.','','','','','','009500','009500','009500','U',''} )
aAdd( aSX6, {'  ','CI_LOTEPRV','C','Numero do Lote para Lancamentos da Provisao/Estorn','Numero do Lote para Lancamentos da Provisao/Estorn','Numero do Lote para Lancamentos da Provisao/Estorn','o Contas de Consumo','o Contas de Consumo','o Contas de Consumo','','','','009300','009300','009300','U',''} )
aAdd( aSX6, {'  ','CI_LOTERDR','C','Numero de lote utilizado para exportar os dados do','','','financeiro.','','','','','','009000','009000','009000','U',''} )
aAdd( aSX6, {'  ','CI_NAT888','C','Natureza para as FLs com Rateio','Natureza para as FLs com Rateio','Natureza para as FLs com Rateio','','','','','','','88888888','8.88.88','8.88.88','U',''} )
aAdd( aSX6, {'  ','CI_NAT999','C','Natureza a Reclassificar','Natureza a Reclassificar','Natureza a Reclassificar','','','','','','','99999999','9.99.99','9.99.99','U',''} )
aAdd( aSX6, {'  ','CI_NATAPR1','C','','','','','','','','','','','','','U',''} )
aAdd( aSX6, {'  ','CI_PERC','N','PERCENTUAL MINIMO A SER ATINGIDO E DISPARADO WORKF','','','LOW PARA OS RESPONSAVEIS PRESTACAO CONTAS','','','CONTA CARTAO ITAU','','','40','40','40','U',''} )
aAdd( aSX6, {'  ','CI_PERDISP','N','PERCENTUAL MINIMO A SER ATINGIDO E DISPARADO WORKF','','','LOW PARA OS RESPONSAVEIS SALDO DISPONIVEL','','','CONTA CARTAO ITAU','','','40','40','40','U',''} )
aAdd( aSX6, {'  ','CI_REFFLCP','C','C๓digo sequencial utilizado na rotina de FL Contas','C๓digo sequencial utilizado na rotina de FL Contas','C๓digo sequencial utilizado na rotina de FL Contas','a Pagar. Sequencia ้ gravada no campo E5_XREFFLC p','a Pagar. Sequencia ้ gravada no campo E5_XREFFLC p','a Pagar. Sequencia ้ gravada no campo E5_XREFFLC p','ara identificar os movimento que compoem a baixa.','ara identificar os movimento que compoem a baixa.','ara identificar os movimento que compoem a baixa.','0000079','0000079','0000079','U',''} )
aAdd( aSX6, {'  ','CI_ROMNF','C','E-mail para LOG de ERRO no ROMANEIO','','','','','','','','','assuntosfiscais@cieesp.org.br;almoxarifado@cieesp.org.br','','','U',''} )
aAdd( aSX6, {'  ','CI_USECADM','C','Usuarios autorizados a efetuarem cancelamento das','Usuarios autorizados a efetuarem cancelamento das','Usuarios autorizados a efetuarem cancelamento das','DMs geradas.','DMs geradas.','DMs geradas.','','','','Siga/adilson/israel_r','Siga/adilson/israel_r','Siga/adilson/israel_r','U',''} )
aAdd( aSX6, {'  ','CI_USEFECH','C','Usuarios autorizados a efetuarem estornos do fecha','Usuarios autorizados a efetuarem estornos do fecha','Usuarios autorizados a efetuarem estornos do fecha','mento.','mento.','mento.','','','','Siga/jurandir/luis/adilson/leandro_oliveira/Leandro/leonardo','Siga/Jurandir/Luis Carlos/Adilson/Leandro','Siga/Jurandir/Luis Carlos/Adilson/Leandro/Leonardo','U',''} )
aAdd( aSX6, {'  ','CI_USEPRES','C','Usuarios com permissao de validar os lancamentos','','','de prestacao de contas, para apos gerar os lancame','','','ntos no mov bancario (SE5) CONTA CARTAO ITAU','','','adilson/israel_r/leonardo/jurandir/flavia_borini','Administrador/Siga','Adilson/Israel/Denise/Jurandir/Flavia','U',''} )
aAdd( aSX6, {'  ','CI_USERAUT','C','Usuario autorizado a trocar o tipo do lancamento','','','contabil de efetivado (tipo 1) para pre-lancamento','','','(tipo 9)','','','Siga/paulo/mauricio_p/silvana/fabiano/luis_a/catia_lima/roberta_l/fabiano_rodrigues/joao_valfogo/thiago_furtado/luciene_o/arquimedes_lopes/vinicius_teixeira/emmanuely_barros/marcos_reis','Siga/Ruy (CON)/Paulo (CON)/Mauricio (CON)/Silvana (CON)/Fabiano (CON)/Luis (CON)/Camila (CON)/Catia (CON)/Roberta (CON)','Siga/Ruy (CON)/Paulo (CON)/Mauricio (CON)/Silvana (CON)/Fabiano (CON)/Luis (CON)/Camila (CON)/Catia (CON)/Roberta (CON)','U',''} )
aAdd( aSX6, {'  ','CI_USERLOT','C','Impressao de Lotes Contabeis (Estorno) CFINR012','Impressao de Lotes Contabeis (Estorno) CFINR012','Impressao de Lotes Contabeis (Estorno) CFINR012','','','','','','','Siga/luis/adilson/leandro_oliveira/leonardo','Siga/Luis Carlos/Adilson/Leandro','Siga/Luis Carlos/Adilson/Leandro','U',''} )
aAdd( aSX6, {'  ','CI_USERSC','C','Usuarios autorizados a alterar o comprador "demand','','','a" para outro comprador e alterar quantidade do pr','','','oduto.','','','Siga/waldir_almeida/sue_hellen/henrique_jesus','Siga/waldir_almeida/sue_hellen/henrique_jesus','Siga/waldir_almeida/sue_hellen/henrique_jesus','U',''} )
aAdd( aSX6, {'  ','CI_VLMXBOR','N','Valor Maximo para Filtro do Bordero de Pagamento','Valor Maximo para Filtro do Bordero de Pagamento','Valor Maximo para Filtro do Bordero de Pagamento','','','','','','','3000','3000','3000','U',''} )
aAdd( aSX6, {'  ','CI_WFAPRA','C','Aprovador nivel 1 (Supervisor) processo de Reserva','','','Financeira','','','','','','adilson@cieesp.org.br;luiscarlos@cieesp.org.br;cristiano@cieesp.org.br','','adilson@cieesp.org.br;luiscarlos@cieesp.org.br;cristiano@cieesp.org.br','U',''} )
aAdd( aSX6, {'  ','CI_WFAPRB','C','Aprovador nivel 2 (Superintendente) processo de','','','Reserva Financeira','','','','','','adilson@cieesp.org.br;luiscarlos@cieesp.org.br','','adilson@cieesp.org.br;luiscarlos@cieesp.org.br','U',''} )
aAdd( aSX6, {'  ','MV_AUTOSC','C','Gera automaticamente uma SC no momento do consumo','','','do produto, assim que atingir o ponto de pedido?','','','','','','N','N','N','U',''} )
aAdd( aSX6, {'  ','MV_BACONTA','C','Conta contabil reduzida para classificar os tipos','Conta contabil reduzida para classificar os tipos','Conta contabil reduzida para classificar os tipos','de Contribuicไo Institucional.','de Contribuicไo Institucional.','de Contribuicไo Institucional.','','','','1160111','116011','116011','U',''} )
aAdd( aSX6, {'  ','MV_DCHVNFE','L','Ativa verifica็ใo da digita็ใo da Chave da NF-e','Ativa verifica็ใo da digita็ใo da Chave da NF-e','Ativa verifica็ใo da digita็ใo da Chave da NF-e','','','','','','','.T.','.T.','.T.','U',''} )
aAdd( aSX6, {'  ','MV_FATORD1','N','Percentual de aceite entre Pedido de Compra e SD1.','Percentual de aceite entre Pedido de Compra e SD1.','Percentual de aceite entre Pedido de Compra e SD1.','Percentual de aceite entre Pedido de Compra e SD1.','Percentual de aceite entre Pedido de Compra e SD1.','Percentual de aceite entre Pedido de Compra e SD1.','Percentual de aceite entre Pedido de Compra e SD1.','Percentual de aceite entre Pedido de Compra e SD1.','','10','10','10','U',''} )
aAdd( aSX6, {'  ','MV_FINATFN','C','"1" = Fluxo Caixa On-Line,"2" = Fluxo Caixa Off-Li','','','ne','','','','','','1','1','1','U',''} )
aAdd( aSX6, {'  ','MV_MINCOF','N','Valor base para geracไo de titulos de COFINS pela','Valor base para generacion de titulos COFINS por','Base amount for generation of COFINS bills through','rotina de apuracไo do PIS/COFINS. Lei 9.430/96,','rutina de calculo de PIS/COFINS. Lei 9.430/96,','PIS/COFINS calculation routine. Law Nbr. 9,430/96,','Art. 68.','Art. 68.','section 68.','0','','','U',''} )
aAdd( aSX6, {'  ','MV_MINPIS','N','Valor base para geracao de titulos de PIS pela','Valor base para generacion de titulos PIS por la','Base amount for generation of PIS bills through','rotina de apuracไo do PIS/COFINS. Lei 9.430/96,','rutina de calculo de PIS/COFINS. Ley 9.430/96,','the PIS/COFINS calculation routine. Law Nbr.','Art. 68.','Art. 68.','9,430/96, section 68.','0','','','U',''} )
aAdd( aSX6, {'  ','MV_MUDATRT','L','Indica se devera alterar o nome fํsico das tabelas','Indica si se modifica el nombre fisico de tablas','It indicates if physical name of temporary tables','temporarias utilizadas nas SPs T=Alterar F=Nใo','temporarias utilizadas en las SP T=Modifica F=No','used in SPs must be changed.  T=Change F=Do Not','Alterar','Modificar','Change','.T.','.T.','.T.','U',''} )
aAdd( aSX6, {'  ','MV_PATCNAB','C','Caminho para onde sera gravado o arquivo de envio','','','do CNAB a  pagar.','','','','','','\\FENIX\ARQ_TXT\TESOURARIA\PAGFOR\PG','\\FENIX\ARQ_TXT\TESOURARIA\PAGFOR\PG','\\FENIX\ARQ_TXT\TESOURARIA\PAGFOR\PG','U',''} )
aAdd( aSX6, {'  ','MV_PROCSP','L','Indica se a manutencao de stored procedures sera r','','','ealizada por processo (.T. = Sim / .F. = Nao)','','','','','','.T.','','','U',''} )
aAdd( aSX6, {'  ','MV_RF10925','D','Data de referencia inicial para que os novos proce','Fecha de referencia inicial para que nuevos proce-','Initial reference date for new procedures about','dimentos quanto a retencao de PIS/COFINS/CSLL seja','dimientos referentes retencion de PIS/COFINS/CSLL','wittholding concerning  PIS/COFINS/CSLL to be','m aplicados.','se apliquen.','applied.','26/07/2004','','','U',''} )
aAdd( aSX6, {'  ','MV_TPALCOF','C','Indica como deve ser obtida a aliquota do COFINS','Indica como debe obtenerse la alicuota del COFINS','Inform how the COFINS will be calculated for reten','para retencao:1-apenas do cadastro de naturezas;2-','para retencion:1-solo del archivo de modalidades;','-tion : 1-only from the class file; 2-MV_TXCOFIN','cadastro de produtos ou de naturezas ou MV_TXCOFIN','2-archivo de productos, modalidades o MV_TXCOFIN','or class or products record.','1','','','U',''} )
aAdd( aSX6, {'  ','MV_TPALPIS','C','Indica como deve ser obtida a aliquota do PIS para','Indica como debe obenerse alicuota de PIS para','Inform how the PIS will be calculated for reten-','retencao : 1-apenas do cadastro de naturezas;','retencion: 1-solo del archivo de modalidades','tion : 1-only from the class file; 2-MV_TXPIS or','2-cadastro de produtos ou de naturezas ou MV_TXPIS','2-archivo de productos, modalidades o MV_TXPIS','2-cadastro de produtos ou de naturezas ou MV_TXPIS','1','','','U',''} )
aAdd( aSX6, {'  ','MV_TPTITCP','C','Tipos de titulo a pagar aceitos pelo sistema no','Tipos de titulo a pagar aceitos pelo sistema no','Tipos de titulo a pagar aceitos pelo sistema no','CIEE.','CIEE.','CIEE.','','','','NF /DP /CH /ADF/ACF/FFC/FFQ/PC /AB-/FL /DIV/PA /CL /CM /CE','NF /DP /CH /ADF/ACF/FFC/FFQ/PC /AB-/FL /DIV/PA /CL /CM /CE','NF /DP /CH /ADF/ACF/FFC/FFQ/PC /AB-/FL /DIV/PA /CL /CM /CE','U',''} )
aAdd( aSX6, {'  ','MV_TPTITCR','C','Tipos de titulo a receber aceitos pelo sistema no','Tipos de titulo a receber aceitos pelo sistema no','Tipos de titulo a receber aceitos pelo sistema no','CIEE.','CIEE.','CIEE.','','','','ACF','ACF','ACF','U',''} )
aAdd( aSX6, {'  ','MV_USERRES','C','Usuarios autorizados a eliminar os residuos das so','','','licitac๖es de Compras.','','','','','','waldir_almeida/sue_hellen/henrique_jesus/mariana_severino/Siga','Waldir/Sue Hellen/Luzia/Juliana','Waldir/Sue Hellen/Luzia/Juliana','U',''} )
aAdd( aSX6, {'  ','MV_USRPROD','C','Usuarios que poderao incluir produtos de estoque','Usuarios que poderao incluir produtos de estoque','Usuarios que poderao incluir produtos de estoque','no sistema.','no sistema.','no sistema.','','','','waldir_almeida/Siga/sue_hellen','Waldir','Waldir','U',''} )
aAdd( aSX6, {'  ','MV_VL10925','N','Valor maximo de pagamentos no periodo para dispen-','Valor maximo de pagos en el periodo para dispensa','Maximum value of payments within the period for','sa da retencao de PIS/COFINS/CSLL','de retencion de PIS/COFINS/CSLL','releasing withholding of PIS/COFINS/CSLL.','','','','5000','','','U',''} )
aAdd( aSX6, {'  ','MV_XCONSOC','C','Cond pagamento para integra็ใo com SOC','','','','','','','','','01','','','U',''} )
aAdd( aSX6, {'  ','MV_XMSGSOC','C','Envio de erro de processamento da integracao SOC','','','','','','','','','assuntosfiscais@cieesp.org.br','','','U',''} )
aAdd( aSX6, {'  ','MV_XPRDSOC','C','Produto a ser utilizado na integracao SOC','','','','','','','','','12.3.066','','','U',''} )
aAdd( aSX6, {'  ','MV_XTESSOC','C','TES a ser utilizada na integra็ใo SOC','','','','','','','','','999','','','U',''} )
//
// Atualizando dicionแrio
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
		cTexto += "Foi incluํdo o parโmetro " + aSX6[nI][1] + aSX6[nI][2] + " Conte๚do [" + AllTrim( aSX6[nI][13] ) + "]"+ CRLF
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

cTexto += CRLF + "Final da Atualizacao" + " SX6" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSAtuSX7 บ Autor ณ TOTVS Protheus     บ Data ณ  17/10/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da gravacao do SX7 - Gatilhos      ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSAtuSX7   - Gerado por EXPORDIC / Upd. V.4.10.6 EFS       ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FSAtuSX7( cTexto )
Local aEstrut   := {}
Local aSX7      := {}
Local cAlias    := ""
Local nI        := 0
Local nJ        := 0
Local nTamSeek  := Len( SX7->X7_CAMPO )

cTexto  += "Inicio da Atualizacao" + " SX7" + CRLF + CRLF

aEstrut := { "X7_CAMPO", "X7_SEQUENC", "X7_REGRA", "X7_CDOMIN", "X7_TIPO", "X7_SEEK", ;
             "X7_ALIAS", "X7_ORDEM"  , "X7_CHAVE", "X7_PROPRI", "X7_CONDIC" }

//
// Campo PA1_TPDOC
//
aAdd( aSX7, {'PA1_TPDOC','001','SX5->X5_DESCRI','PA1_DESC','P','S','SX5',1,'xFilial("SX5")+"P1"+M->PA1_TPDOC','U',''} )
//
// Campo PA2_GER
//
aAdd( aSX7, {'PA2_GER','001','M->PA2_DESCGE := Posicione("PA5", 1, xFilial("PA5")+M->PA2_GER,"PA5_DESC")','PA2_DESCGE','P','N','',0,'','U',''} )
//
// Campo PA3_MAT
//
aAdd( aSX7, {'PA3_MAT','001','Posicione("PA3", 1, xFilial("PA3")+M->PA3_MAT,"PA3_RESP")','PA3_RESP','P','N','',0,'','U',''} )
aAdd( aSX7, {'PA3_MAT','002','Posicione("PA3", 1, xFilial("PA3")+M->PA3_MAT,"PA3_NIVEL")','PA3_NIVEL','P','N','',0,'','U',''} )
aAdd( aSX7, {'PA3_MAT','003','Posicione("PA3", 1, xFilial("PA3")+M->PA3_MAT,"PA3_EMAIL")','PA3_EMAIL','P','N','',0,'','U',''} )
aAdd( aSX7, {'PA3_MAT','004','Posicione("PA3", 1, xFilial("PA3")+M->PA3_MAT,"PA3_STATUS")','PA3_STATUS','P','N','',0,'','U',''} )
//
// Campo PA4_CODDOC
//
aAdd( aSX7, {'PA4_CODDOC','001','POSICIONE("PA1",1,XFILIAL("PA1")+M->PA4_CODDOC,"PA1_DESC")','PA4_DESCDO','P','N','',0,'','U',''} )
aAdd( aSX7, {'PA4_CODDOC','002','POSICIONE("PA1",1,XFILIAL("PA1")+M->PA4_CODDOC,"PA1_CNPJ")','PA4_NUMDOC','P','N','',0,'','U','PA1->PA1_TPDOC=="01"'} )
aAdd( aSX7, {'PA4_CODDOC','003','POSICIONE("PA1",1,XFILIAL("PA1")+M->PA4_CODDOC,"PA1_ALVA")','PA4_NUMDOC','P','N','',0,'','U','PA1->PA1_TPDOC=="02"'} )
aAdd( aSX7, {'PA4_CODDOC','004','POSICIONE("PA1",1,XFILIAL("PA1")+M->PA4_CODDOC,"PA1_PROCES")','PA4_NUMDOC','P','N','',0,'','U','PA1->PA1_TPDOC=="03"'} )
aAdd( aSX7, {'PA4_CODDOC','005','POSICIONE("PA1",1,XFILIAL("PA1")+M->PA4_CODDOC,"PA1_ATEST")','PA4_NUMDOC','P','N','',0,'','U','PA1->PA1_TPDOC=="04"'} )
aAdd( aSX7, {'PA4_CODDOC','006','POSICIONE("PA1",1,XFILIAL("PA1")+M->PA4_CODDOC,"PA1_UTIL")','PA4_NUMDOC','P','N','',0,'','U','PA1->PA1_TPDOC=="05"'} )
aAdd( aSX7, {'PA4_CODDOC','007','POSICIONE("PA1",1,XFILIAL("PA1")+M->PA4_CODDOC,"PA1_CMDCA")','PA4_NUMDOC','P','N','',0,'','U','PA1->PA1_TPDOC=="06"'} )
aAdd( aSX7, {'PA4_CODDOC','008','POSICIONE("PA1",1,XFILIAL("PA1")+M->PA4_CODDOC,"PA1_DOCDIV")','PA4_NUMDOC','P','N','',0,'','U','PA1->PA1_TPDOC=="07"'} )
//
// Campo PA4_CODUNI
//
aAdd( aSX7, {'PA4_CODUNI','001','Posicione("PA2", 1, xFilial("PA2")+M->PA4_CODUNI,"PA2_DESC")','PA4_DESCUN','P','N','',0,'','U',''} )
aAdd( aSX7, {'PA4_CODUNI','002','M->PA4_IMAGEM := PA2->PA2_IMAGEM','PA4_BITMAP','P','N','',0,'','U',''} )
//
// Campo PA4_MAT
//
aAdd( aSX7, {'PA4_MAT','001','Posicione("PA3", 1, xFilial("PA3")+M->PA4_MAT,"PA3_MAT")','PA3_MAT','P','N','',0,'','U',''} )
//
// Campo PA7_RESP
//
aAdd( aSX7, {'PA7_RESP','001','M->PA7_DESRES := Posicione("PA3", 1, xFilial("PA3")+M->PA7_RESP,"PA3_RESP")','PA7_DESRES','P','N','',0,'','U',''} )
aAdd( aSX7, {'PA7_RESP','002','M->PA7_NIVEL := Posicione("PA3", 1, xFilial("PA3")+M->PA7_RESP,"PA3_NIVEL")','PA7_NIVEL','P','N','',0,'','U',''} )
aAdd( aSX7, {'PA7_RESP','003',"X3COMBO('PA3_NIVEL',M->PA7_NIVEL)",'PA7_DESNIV','P','N','',0,'','U',''} )
//
// Campo PA8_MAT
//
aAdd( aSX7, {'PA8_MAT','001','M->PA8_RESP:= Posicione("PA3", 1, xFilial("PA3")+M->PA8_MAT,"PA3_RESP")','PA8_RESP','P','N','',0,'','U',''} )
aAdd( aSX7, {'PA8_MAT','002','M->PA8_NIVEL := Posicione("PA3", 1, xFilial("PA3")+M->PA8_MAT,"PA3_NIVEL")','PA8_NIVEL','P','N','',0,'','U',''} )
aAdd( aSX7, {'PA8_MAT','003',"X3COMBO('PA3_NIVEL',PA3->PA3_NIVEL)",'PA8_DESNIV','P','N','',0,'','U',''} )
//
// Atualizando dicionแrio
//
oProcess:SetRegua2( Len( aSX7 ) )

dbSelectArea( "SX7" )
dbSetOrder( 1 )

For nI := 1 To Len( aSX7 )

	If !SX7->( dbSeek( PadR( aSX7[nI][1], nTamSeek ) + aSX7[nI][2] ) )

		If !( aSX7[nI][1] $ cAlias )
			cAlias += aSX7[nI][1] + "/"
			cTexto += "Foi incluํdo o gatilho " + aSX7[nI][1] + "/" + aSX7[nI][2] + CRLF
		EndIf

		RecLock( "SX7", .T. )
		For nJ := 1 To Len( aSX7[nI] )
			If FieldPos( aEstrut[nJ] ) > 0
				FieldPut( FieldPos( aEstrut[nJ] ), aSX7[nI][nJ] )
			EndIf
		Next nJ

		dbCommit()
		MsUnLock()

	EndIf
	oProcess:IncRegua2( "Atualizando Arquivos (SX7)..." )

Next nI

cTexto += CRLF + "Final da Atualizacao" + " SX7" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSAtuSXA บ Autor ณ TOTVS Protheus     บ Data ณ  17/10/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da gravacao do SXA - Pastas        ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSAtuSXA   - Gerado por EXPORDIC / Upd. V.4.10.6 EFS       ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FSAtuSXA( cTexto )
Local aEstrut   := {}
Local aSXA      := {}
Local cAlias    := ""
Local nI        := 0
Local nJ        := 0

cTexto  += "Inicio da Atualizacao" + " SXA" + CRLF + CRLF

aEstrut := { "XA_ALIAS", "XA_ORDEM", "XA_DESCRIC", "XA_DESCSPA", "XA_DESCENG", "XA_PROPRI" }

//
// Tabela PA1
//
aAdd( aSXA, {'PA1','1','Cadastrais','Cadastrais','Cadastrais','U'} )
aAdd( aSXA, {'PA1','2','CNPJ','CNPJ','CNPJ','U'} )
aAdd( aSXA, {'PA1','3','Alvara','Alvara','Alvara','U'} )
aAdd( aSXA, {'PA1','4','ISS QN','ISS QN','ISS QN','U'} )
aAdd( aSXA, {'PA1','5','CMAS/CEAS','CMAS/CEAS','CMAS/CEAS','U'} )
aAdd( aSXA, {'PA1','6','Util. Publica','Util. Publica','Util. Publica','U'} )
aAdd( aSXA, {'PA1','7','NFe','NFe','NFe','U'} )
aAdd( aSXA, {'PA1','8','Docto Diversos','Docto Diversos','Docto Diversos','U'} )
aAdd( aSXA, {'PA1','9','Imagem','Imagem','Imagem','U'} )
//
// Atualizando dicionแrio
//
oProcess:SetRegua2( Len( aSXA ) )

dbSelectArea( "SXA" )
dbSetOrder( 1 )

For nI := 1 To Len( aSXA )

	If !SXA->( dbSeek( aSXA[nI][1] + aSXA[nI][2] ) )

		If !( aSXA[nI][1] $ cAlias )
			cAlias += aSXA[nI][1] + "/"
		EndIf

		RecLock( "SXA", .T. )
		For nJ := 1 To Len( aSXA[nI] )
			If FieldPos( aEstrut[nJ] ) > 0
			FieldPut( FieldPos( aEstrut[nJ] ), aSXA[nI][nJ] )
			EndIf
		Next nJ
		dbCommit()
		MsUnLock()

		cTexto += "Foi incluํda a pasta " + aSXA[nI][1] + "/" + aSXA[nI][2]  + CRLF

		oProcess:IncRegua2( "Atualizando Arquivos (SXA)..." )

	EndIf

Next nI

cTexto += CRLF + "Final da Atualizacao" + " SXA" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSAtuSXB บ Autor ณ TOTVS Protheus     บ Data ณ  17/10/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da gravacao do SXB - Consultas Pad ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSAtuSXB   - Gerado por EXPORDIC / Upd. V.4.10.6 EFS       ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FSAtuSXB( cTexto )
Local aEstrut   := {}
Local aSXB      := {}
Local cAlias    := ""
Local cMsg      := ""
Local lTodosNao := .F.
Local lTodosSim := .F.
Local nI        := 0
Local nJ        := 0
Local nOpcA     := 0

cTexto  += "Inicio da Atualizacao" + " SXB" + CRLF + CRLF

aEstrut := { "XB_ALIAS",  "XB_TIPO"   , "XB_SEQ"    , "XB_COLUNA" , ;
             "XB_DESCRI", "XB_DESCSPA", "XB_DESCENG", "XB_CONTEM" }

//
// Consulta PA1
//
aAdd( aSXB, {'PA1','1','01','DB','Documento','Documento','Documento','PA1'} )
aAdd( aSXB, {'PA1','2','01','02','Descricao','Descricao','Descricao',''} )
aAdd( aSXB, {'PA1','2','02','01','Codigo','Codigo','Codigo',''} )
aAdd( aSXB, {'PA1','3','01','01','Cadastra Novo','Incluye Nuevo','Add New','01'} )
aAdd( aSXB, {'PA1','4','01','01','Descricao','Descricao','Descricao','PA1_DESC'} )
aAdd( aSXB, {'PA1','4','01','02','Codigo','Codigo','Codigo','PA1_COD'} )
aAdd( aSXB, {'PA1','4','01','03','CNPJ','CNPJ','CNPJ','PA1_CNPJ'} )
aAdd( aSXB, {'PA1','4','01','04','Alvara','Alvara','Alvara','PA1_ALVA'} )
aAdd( aSXB, {'PA1','4','01','05','ISS QN','ISS QN','ISS QN','PA1_PROCES'} )
aAdd( aSXB, {'PA1','4','01','06','Cmas/Ceas','Cmas/Ceas','Cmas/Ceas','PA1_ATEST'} )
aAdd( aSXB, {'PA1','4','01','07','Util.Publica','Util.Publica','Util.Publica','PA1_UTIL'} )
aAdd( aSXB, {'PA1','4','01','08','Cmdca','Cmdca','Cmdca','PA1_CMDCA'} )
aAdd( aSXB, {'PA1','4','02','01','Codigo','Codigo','Codigo','PA1_COD'} )
aAdd( aSXB, {'PA1','4','02','02','Descricao','Descricao','Descricao','PA1_DESC'} )
aAdd( aSXB, {'PA1','4','02','03','CNPJ','CNPJ','CNPJ','PA1_CNPJ'} )
aAdd( aSXB, {'PA1','4','02','04','Alvara','Alvara','Alvara','PA1_ALVA'} )
aAdd( aSXB, {'PA1','4','02','05','ISS QN','ISS QN','ISS QN','PA1_PROCES'} )
aAdd( aSXB, {'PA1','4','02','06','Cmas/Ceas','Cmas/Ceas','Cmas/Ceas','PA1_ATEST'} )
aAdd( aSXB, {'PA1','4','02','07','Util Publica','Util Publica','Util Publica','PA1_UTIL'} )
aAdd( aSXB, {'PA1','4','02','08','CMDCA','CMDCA','CMDCA','PA1_CMDCA'} )
aAdd( aSXB, {'PA1','5','01','','','','','PA1->PA1_COD'} )
//
// Consulta PA1B
//
aAdd( aSXB, {'PA1b','1','01','DB','Tipo de Documento','Tipo de Documento','Tipo de Documento','PA1'} )
aAdd( aSXB, {'PA1b','2','01','02','Descricao documento','Descricao documento','Descricao documento',''} )
aAdd( aSXB, {'PA1b','2','02','03','Tipo docto','Tipo docto','Tipo docto',''} )
aAdd( aSXB, {'PA1b','4','01','01','Descricao','Descricao','Descricao','PA1_DESC'} )
aAdd( aSXB, {'PA1b','4','01','02','Tipo Docto','Tipo Docto','Tipo Docto','PA1_TPDOC'} )
aAdd( aSXB, {'PA1b','4','02','01','Tipo Docto','Tipo Docto','Tipo Docto','PA1_TPDOC'} )
aAdd( aSXB, {'PA1b','4','02','02','Descricao','Descricao','Descricao','PA1_DESC'} )
aAdd( aSXB, {'PA1b','5','01','','','','','PA1->PA1_TPDOC'} )
//
// Consulta PA2
//
aAdd( aSXB, {'PA2','1','01','DB','Unidade','Unidade','Unidade','PA2'} )
aAdd( aSXB, {'PA2','2','01','02','Descricao','Descricao','Descricao',''} )
aAdd( aSXB, {'PA2','2','02','01','Codigo','Codigo','Codigo',''} )
aAdd( aSXB, {'PA2','3','01','01','Cadastra Novo','Incluye Nuevo','Add New','01'} )
aAdd( aSXB, {'PA2','4','01','01','Descricao','Descricao','Descricao','PA2_DESC'} )
aAdd( aSXB, {'PA2','4','01','02','Codigo','Codigo','Codigo','PA2_COD'} )
aAdd( aSXB, {'PA2','4','02','01','Codigo','Codigo','Codigo','PA2_COD'} )
aAdd( aSXB, {'PA2','4','02','02','Descricao','Descricao','Descricao','PA2_DESC'} )
aAdd( aSXB, {'PA2','5','01','','','','','PA2->PA2_COD'} )
//
// Consulta PA2A
//
aAdd( aSXB, {'PA2a','1','01','DB','Unidade','Unidade','Unidade','PA2'} )
aAdd( aSXB, {'PA2a','2','01','02','Descricao','Descricao','Descricao',''} )
aAdd( aSXB, {'PA2a','2','02','01','Codigo','Codigo','Codigo',''} )
aAdd( aSXB, {'PA2a','4','01','01','Descricao','Descricao','Descricao','PA2_DESC'} )
aAdd( aSXB, {'PA2a','4','01','02','Codigo','Codigo','Codigo','PA2_COD'} )
aAdd( aSXB, {'PA2a','4','02','01','Codigo','Codigo','Codigo','PA2_COD'} )
aAdd( aSXB, {'PA2a','4','02','02','Descricao','Descricao','Descricao','PA2_DESC'} )
aAdd( aSXB, {'PA2a','5','01','','','','','PA2->PA2_DESC'} )
//
// Consulta PA3
//
aAdd( aSXB, {'PA3','1','01','DB','Responsaveis','Responsaveis','Responsaveis','PA3'} )
aAdd( aSXB, {'PA3','2','01','02','Responsavel','Responsavel','Responsavel',''} )
aAdd( aSXB, {'PA3','2','02','01','Matricula','Matricula','Matricula',''} )
aAdd( aSXB, {'PA3','3','01','01','Cadastra Novo','Incluye Nuevo','Add New','01'} )
aAdd( aSXB, {'PA3','4','01','01','Nome','Nome','Nome','PA3_RESP'} )
aAdd( aSXB, {'PA3','4','01','02','Matricula','Matricula','Matricula','PA3_MAT'} )
aAdd( aSXB, {'PA3','4','01','03','Nivel','Nivel','Nivel','PA3_NIVEL'} )
aAdd( aSXB, {'PA3','4','02','01','Matricula','Matricula','Matricula','PA3_MAT'} )
aAdd( aSXB, {'PA3','4','02','02','Responsavel','Responsavel','Responsavel','PA3_RESP'} )
aAdd( aSXB, {'PA3','4','02','03','Nivel','Nivel','Nivel','PA3_NIVEL'} )
aAdd( aSXB, {'PA3','5','01','','','','','PA3->PA3_MAT'} )
aAdd( aSXB, {'PA3','5','02','','','','','PA3->PA3_NIVEL'} )
aAdd( aSXB, {'PA3','6','01','','','','',"PA3->PA3_STATUS == 'A'"} )
//
// Consulta PA4
//
aAdd( aSXB, {'PA4','1','01','DB','Status do documento','Status do documento','Status do documento','PA4'} )
aAdd( aSXB, {'PA4','2','01','06','Status','Status','Status',''} )
aAdd( aSXB, {'PA4','4','01','01','Codigo','Codigo','Codigo','PA4_COD'} )
aAdd( aSXB, {'PA4','4','01','02','Status','Status','Status','PA4_STATUS'} )
aAdd( aSXB, {'PA4','5','01','','','','','PA4->PA4_STATUS'} )
//
// Consulta PA5
//
aAdd( aSXB, {'PA5','1','01','DB','Gerencias','Gerencias','Gerencias','PA5'} )
aAdd( aSXB, {'PA5','2','01','02','Descricao','Descricao','Descricao',''} )
aAdd( aSXB, {'PA5','2','02','01','Codigo','Codigo','Codigo',''} )
aAdd( aSXB, {'PA5','3','01','01','Cadastra Novo','Incluye Nuevo','Add New','01'} )
aAdd( aSXB, {'PA5','4','01','01','Descricao','Descricao','Descricao','PA5_DESC'} )
aAdd( aSXB, {'PA5','4','01','02','Codigo','Codigo','Codigo','PA5_COD'} )
aAdd( aSXB, {'PA5','4','02','01','Codigo','Codigo','Codigo','PA5_COD'} )
aAdd( aSXB, {'PA5','4','02','02','Descricao','Descricao','Descricao','PA5_DESC'} )
aAdd( aSXB, {'PA5','5','01','','','','','PA5->PA5_COD'} )
aAdd( aSXB, {'PA5','5','02','','','','','PA5->PA5_DESC'} )
//
// Consulta PA5A
//
aAdd( aSXB, {'PA5a','1','01','DB','Gerencia','Gerencia','Gerencia','PA5'} )
aAdd( aSXB, {'PA5a','2','01','02','Descricao','Descricao','Descricao',''} )
aAdd( aSXB, {'PA5a','2','02','01','Codigo','Codigo','Codigo',''} )
aAdd( aSXB, {'PA5a','4','01','01','Descricao','Descricao','Descricao','PA5_DESC'} )
aAdd( aSXB, {'PA5a','4','01','02','Codigo','Codigo','Codigo','PA5_COD'} )
aAdd( aSXB, {'PA5a','4','02','01','Codigo','Codigo','Codigo','PA5_COD'} )
aAdd( aSXB, {'PA5a','4','02','02','Descricao','Descricao','Descricao','PA5_DESC'} )
aAdd( aSXB, {'PA5a','5','01','','','','','PA5->PA5_DESC'} )
//
// Atualizando dicionแrio
//
oProcess:SetRegua2( Len( aSXB ) )

dbSelectArea( "SXB" )
dbSetOrder( 1 )

For nI := 1 To Len( aSXB )

	If !Empty( aSXB[nI][1] )

		If !SXB->( dbSeek( PadR( aSXB[nI][1], Len( SXB->XB_ALIAS ) ) + aSXB[nI][2] + aSXB[nI][3] + aSXB[nI][4] ) )

			If !( aSXB[nI][1] $ cAlias )
				cAlias += aSXB[nI][1] + "/"
				cTexto += "Foi incluํda a consulta padrใo " + aSXB[nI][1] + CRLF
			EndIf

			RecLock( "SXB", .T. )

			For nJ := 1 To Len( aSXB[nI] )
				If !Empty( FieldName( FieldPos( aEstrut[nJ] ) ) )
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

					cMsg := "A consulta padrao " + aSXB[nI][1] + " estแ com o " + SXB->( FieldName( nJ ) ) + ;
					" com o conte๚do" + CRLF + ;
					"[" + RTrim( AllToChar( SXB->( FieldGet( nJ ) ) ) ) + "]" + CRLF + ;
					", e este ้ diferente do conte๚do" + CRLF + ;
					"[" + RTrim( AllToChar( aSXB[nI][nJ] ) ) + "]" + CRLF +;
					"Deseja substituir ? "

					If      lTodosSim
						nOpcA := 1
					ElseIf  lTodosNao
						nOpcA := 2
					Else
						nOpcA := Aviso( "ATUALIZAวรO DE DICIONมRIOS E TABELAS", cMsg, { "Sim", "Nใo", "Sim p/Todos", "Nใo p/Todos" }, 3, "Diferen็a de conte๚do - SXB" )
						lTodosSim := ( nOpcA == 3 )
						lTodosNao := ( nOpcA == 4 )

						If lTodosSim
							nOpcA := 1
							lTodosSim := MsgNoYes( "Foi selecionada a op็ใo de REALIZAR TODAS altera็๕es no SXB e NรO MOSTRAR mais a tela de aviso." + CRLF + "Confirma a a็ใo [Sim p/Todos] ?" )
						EndIf

						If lTodosNao
							nOpcA := 2
							lTodosNao := MsgNoYes( "Foi selecionada a op็ใo de NรO REALIZAR nenhuma altera็ใo no SXB que esteja diferente da base e NรO MOSTRAR mais a tela de aviso." + CRLF + "Confirma esta a็ใo [Nใo p/Todos]?" )
						EndIf

					EndIf

					If nOpcA == 1
						RecLock( "SXB", .F. )
						FieldPut( FieldPos( aEstrut[nJ] ), aSXB[nI][nJ] )
						dbCommit()
						MsUnLock()

						If !( aSXB[nI][1] $ cAlias )
							cAlias += aSXB[nI][1] + "/"
							cTexto += "Foi Alterada a consulta padrao " + aSXB[nI][1] + CRLF
						EndIf

					EndIf

				EndIf

			Next

		EndIf

	EndIf

	oProcess:IncRegua2( "Atualizando Consultas Padroes (SXB)..." )

Next nI

cTexto += CRLF + "Final da Atualizacao" + " SXB" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณESCEMPRESAบAutor  ณ Ernani Forastieri  บ Data ณ  27/09/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao Generica para escolha de Empresa, montado pelo SM0_ บฑฑ
ฑฑบ          ณ Retorna vetor contendo as selecoes feitas.                 บฑฑ
ฑฑบ          ณ Se nao For marcada nenhuma o vetor volta vazio.            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function EscEmpresa()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Parametro  nTipo                           ณ
//ณ 1  - Monta com Todas Empresas/Filiais      ณ
//ณ 2  - Monta so com Empresas                 ณ
//ณ 3  - Monta so com Filiais de uma Empresa   ณ
//ณ                                            ณ
//ณ Parametro  aMarcadas                       ณ
//ณ Vetor com Empresas/Filiais pre marcadas    ณ
//ณ                                            ณ
//ณ Parametro  cEmpSel                         ณ
//ณ Empresa que sera usada para montar selecao ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local   aSalvAmb := GetArea()
Local   aSalvSM0 := {}
Local   aRet     := {}
Local   aVetor   := {}
Local   oDlg     := NIL
Local   oChkMar  := NIL
Local   oLbx     := NIL
Local   oMascEmp := NIL
Local   oMascFil := NIL
Local   oButMarc := NIL
Local   oButDMar := NIL
Local   oButInv  := NIL
Local   oSay     := NIL
Local   oOk      := LoadBitmap( GetResources(), "LBOK" )
Local   oNo      := LoadBitmap( GetResources(), "LBNO" )
Local   lChk     := .F.
Local   lOk      := .F.
Local   lTeveMarc:= .F.
Local   cVar     := ""
Local   cNomEmp  := ""
Local   cMascEmp := "??"
Local   cMascFil := "??"

Local   aMarcadas  := {}


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

Define MSDialog  oDlg Title "" From 0, 0 To 270, 396 Pixel

oDlg:cToolTip := "Tela para M๚ltiplas Sele็๕es de Empresas/Filiais"

oDlg:cTitle   := "Selecione a(s) Empresa(s) para Atualiza็ใo"

@ 10, 10 Listbox  oLbx Var  cVar Fields Header " ", " ", "Empresa" Size 178, 095 Of oDlg Pixel
oLbx:SetArray(  aVetor )
oLbx:bLine := {|| {IIf( aVetor[oLbx:nAt, 1], oOk, oNo ), ;
aVetor[oLbx:nAt, 2], ;
aVetor[oLbx:nAt, 4]}}
oLbx:BlDblClick := { || aVetor[oLbx:nAt, 1] := !aVetor[oLbx:nAt, 1], VerTodos( aVetor, @lChk, oChkMar ), oChkMar:Refresh(), oLbx:Refresh()}
oLbx:cToolTip   :=  oDlg:cTitle
oLbx:lHScroll   := .F. // NoScroll

@ 112, 10 CheckBox oChkMar Var  lChk Prompt "Todos"   Message  Size 40, 007 Pixel Of oDlg;
on Click MarcaTodos( lChk, @aVetor, oLbx )

@ 123, 10 Button oButInv Prompt "&Inverter"  Size 32, 12 Pixel Action ( InvSelecao( @aVetor, oLbx, @lChk, oChkMar ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Inverter Sele็ใo" Of oDlg

// Marca/Desmarca por mascara
@ 113, 51 Say  oSay Prompt "Empresa" Size  40, 08 Of oDlg Pixel
@ 112, 80 MSGet  oMascEmp Var  cMascEmp Size  05, 05 Pixel Picture "@!"  Valid (  cMascEmp := StrTran( cMascEmp, " ", "?" ), cMascFil := StrTran( cMascFil, " ", "?" ), oMascEmp:Refresh(), .T. ) ;
Message "Mแscara Empresa ( ?? )"  Of oDlg
@ 123, 50 Button oButMarc Prompt "&Marcar"    Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .T. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Marcar usando mแscara ( ?? )"    Of oDlg
@ 123, 80 Button oButDMar Prompt "&Desmarcar" Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .F. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Desmarcar usando mแscara ( ?? )" Of oDlg

Define SButton From 111, 125 Type 1 Action ( RetSelecao( @aRet, aVetor ), oDlg:End() ) OnStop "Confirma a Sele็ใo"  Enable Of oDlg
Define SButton From 111, 158 Type 2 Action ( IIf( lTeveMarc, aRet :=  aMarcadas, .T. ), oDlg:End() ) OnStop "Abandona a Sele็ใo" Enable Of oDlg
Activate MSDialog  oDlg Center

RestArea( aSalvAmb )
dbSelectArea( "SM0" )
dbCloseArea()

Return  aRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณMARCATODOSบAutor  ณ Ernani Forastieri  บ Data ณ  27/09/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao Auxiliar para marcar/desmarcar todos os itens do    บฑฑ
ฑฑบ          ณ ListBox ativo                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MarcaTodos( lMarca, aVetor, oLbx )
Local  nI := 0

For nI := 1 To Len( aVetor )
	aVetor[nI][1] := lMarca
Next nI

oLbx:Refresh()

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณINVSELECAOบAutor  ณ Ernani Forastieri  บ Data ณ  27/09/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao Auxiliar para inverter selecao do ListBox Ativo     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function InvSelecao( aVetor, oLbx )
Local  nI := 0

For nI := 1 To Len( aVetor )
	aVetor[nI][1] := !aVetor[nI][1]
Next nI

oLbx:Refresh()

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณRETSELECAOบAutor  ณ Ernani Forastieri  บ Data ณ  27/09/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao Auxiliar que monta o retorno com as selecoes        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RetSelecao( aRet, aVetor )
Local  nI    := 0

aRet := {}
For nI := 1 To Len( aVetor )
	If aVetor[nI][1]
		aAdd( aRet, { aVetor[nI][2] , aVetor[nI][3], aVetor[nI][2] +  aVetor[nI][3] } )
	EndIf
Next nI

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ MARCAMAS บAutor  ณ Ernani Forastieri  บ Data ณ  20/11/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao para marcar/desmarcar usando mascaras               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MarcaMas( oLbx, aVetor, cMascEmp, lMarDes )
Local cPos1 := SubStr( cMascEmp, 1, 1 )
Local cPos2 := SubStr( cMascEmp, 2, 1 )
Local nPos  := oLbx:nAt
Local nZ    := 0

For nZ := 1 To Len( aVetor )
	If cPos1 == "?" .or. SubStr( aVetor[nZ][2], 1, 1 ) == cPos1
		If cPos2 == "?" .or. SubStr( aVetor[nZ][2], 2, 1 ) == cPos2
			aVetor[nZ][1] :=  lMarDes
		EndIf
	EndIf
Next

oLbx:nAt := nPos
oLbx:Refresh()

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ VERTODOS บAutor  ณ Ernani Forastieri  บ Data ณ  20/11/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao auxiliar para verificar se estao todos marcardos    บฑฑ
ฑฑบ          ณ ou nao                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VerTodos( aVetor, lChk, oChkMar )
Local lTTrue := .T.
Local nI     := 0

For nI := 1 To Len( aVetor )
	lTTrue := IIf( !aVetor[nI][1], .F., lTTrue )
Next nI

lChk := IIf( lTTrue, .T., .F. )
oChkMar:Refresh()

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ MyOpenSM0บ Autor ณ TOTVS Protheus     บ Data ณ  17/10/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento abertura do SM0 modo exclusivo     ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ MyOpenSM0  - Gerado por EXPORDIC / Upd. V.4.10.6 EFS       ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
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
	MsgStop( "Nใo foi possํvel a abertura da tabela " + ;
	IIf( lShared, "de empresas (SM0).", "de empresas (SM0) de forma exclusiva." ), "ATENวรO" )
EndIf

Return lOpen


/////////////////////////////////////////////////////////////////////////////
