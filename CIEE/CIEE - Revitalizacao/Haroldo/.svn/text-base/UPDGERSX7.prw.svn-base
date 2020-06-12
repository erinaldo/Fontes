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
/*/{Protheus.doc} UPSX705H
Função de update de dicionários para compatibilização

@author TOTVS Protheus
@since  07/04/2015
@obs    Gerado por EXPORDIC - V.4.22.10.7 EFS / Upd. V.4.19.12 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
User Function UPDGERSX7( cEmpAmb, cFilAmb )

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
					MsgStop( "Atualização Realizada.", "UPSX705H" )
				Else
					MsgStop( "Atualização não Realizada.", "UPSX705H" )
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
			MsgStop( "Atualização não Realizada.", "UPSX705H" )

		EndIf

	Else
		MsgStop( "Atualização não Realizada.", "UPSX705H" )

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
			// Atualiza o dicionário SX7
			//------------------------------------
			oProcess:IncRegua1( "Dicionário de gatilhos" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSX7()

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
/*/{Protheus.doc} FSAtuSX7
Função de processamento da gravação do SX7 - Gatilhos

@author TOTVS Protheus
@since  07/04/2015
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
// Campo A2_CGC
//

aAdd( aSX7, { ;
	'A2_CGC'																, ; //X7_CAMPO   // ALTERAR
	'009'																	, ; //X7_SEQUENC
	'IF(LEN(alltrim(M->A2_CGC))>11,"R","F")'							, ; //X7_REGRA
	'A2_TIPO'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo A2_COND
//
aAdd( aSX7, { ;
	'A2_COND'																, ; //X7_CAMPO  // ALTERAR
	'001'																	, ; //X7_SEQUENC
	'SE4->E4_DESCRI'														, ; //X7_REGRA
	'A2_XCONDDE'															, ; //X7_CDOMIN    // ALTERAR
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SE4'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'xFilial("SE4") + M->A2_COND'										, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo A2_CONV
//
aAdd( aSX7, { ;
	'A2_XCONV'																, ; //X7_CAMPO  //ALTERAR CAMPO
	'001'																	, ; //X7_SEQUENC
	'0'																		, ; //X7_REGRA
	'A2_XESTNUM'															, ; //X7_CDOMIN  // ALTERAR
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	'M->A2_XCONV=="N"'													} ) //X7_CONDIC  // ALTERAR CAMPO

aAdd( aSX7, { ;
	'A2_XCONV'																, ; //X7_CAMPO  // ALTERAR CAMPO
	'002'																	, ; //X7_SEQUENC
	'"S"'																	, ; //X7_REGRA
	'A2_XPROSPE'															, ; //X7_CDOMIN   //ALTERAR
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	'M->A2_XCONV == "S"'														} ) //X7_CONDIC  //ALTERAR 

//
// Campo A2_ESTNUM
//
aAdd( aSX7, { ;
	'A2_XESTNUM'															, ; //X7_CAMPO         //ALTERAR  
	'001'																	, ; //X7_SEQUENC
	'IIF(M->A2_XESTNUM !=0, "S","N")'									, ; //X7_REGRA       //ALTERAR
	'A2_XCONV'																, ; //X7_CDOMIN      //ALTERAR
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'A2_XESTNUM'															, ; //X7_CAMPO       //ALTERAR
	'002'																	, ; //X7_SEQUENC
	'"S"'																	, ; //X7_REGRA
	'A2_XPROSPE'															, ; //X7_CDOMIN      //ALTERAR
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	'M->A2_XESTNUM != 0'														} ) //X7_CONDIC    //ALTERAR

//
// Campo A2_HPAGE
//
aAdd( aSX7, { ;
	'A2_HPAGE'																, ; //X7_CAMPO   //ok
	'001'																	, ; //X7_SEQUENC
	'LOWER(M->A2_HPAGE)'													, ; //X7_REGRA
	'A2_HPAGE'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo A2_INSCRE
//
aAdd( aSX7, { ;
	'A2_XINSCRE'															, ; //X7_CAMPO   // ALTERAR
	'001'																	, ; //X7_SEQUENC
	'M->A2_XINSCRE'														, ; //X7_REGRA    // ALTERAR
	'A2_INSCR'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo A2_INSCRME
//
aAdd( aSX7, { ;
	'A2_XINSCME'															, ; //X7_CAMPO  // ALTERAR
	'001'																	, ; //X7_SEQUENC
	'M->A2_XINSCME'														, ; //X7_REGRA   //alterar
	'A2_XINSCRM'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo A2_REDUZ
//
aAdd( aSX7, { ;
	'A2_XREDUZ'															, ; //X7_CAMPO   //ALTERAR
	'001'																	, ; //X7_SEQUENC  
	'Posicione("ct1",2,xFilial("ct1")+M->A2_XREDUZ,"ct1_conta")'	, ; //X7_REGRA    //ALTERA
	'A2_CONTA'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo A2_SUBCOD
//
aAdd( aSX7, { ;
	'A2_SUBCOD'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'GSPFNVCOD1("SA2","A2_COD",1,M->A2_SUBCOD)'								, ; //X7_REGRA
	'A2_COD'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	''																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'S'																		, ; //X7_PROPRI
	'INCLUI'																} ) //X7_CONDIC

//
// Campo A4_COD_MUN
//
aAdd( aSX7, { ;
	'A4_COD_MUN'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'CC2->CC2_MUN'															, ; //X7_REGRA
	'A4_MUN'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'CC2'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	"xFilial('CC2')+M->A4_EST+M->A4_COD_MUN"								, ; //X7_CHAVE
	'S'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo A4_EST
//
aAdd( aSX7, { ;
	'A4_EST'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	"CriaVar('A4_COD_MUN',.F.)"												, ; //X7_REGRA
	'A4_COD_MUN'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'S'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo A6_BLOCKED
//
aAdd( aSX7, { ;
	'A6_BLOCKED'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'CTOD("//")'															, ; //X7_REGRA
	'A6_DTBLOQ'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'S'																		, ; //X7_PROPRI
	'M->A6_BLOCKED == "2"'													} ) //X7_CONDIC

aAdd( aSX7, { ;
	'A6_BLOCKED'															, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	'M->A6_DTBLOQ := DDATABASE'												, ; //X7_REGRA
	'A6_DTBLOQ'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	'M->A6_BLOCKED == "1"'													} ) //X7_CONDIC

aAdd( aSX7, { ;
	'A6_BLOCKED'															, ; //X7_CAMPO
	'003'																	, ; //X7_SEQUENC
	'M->DTBLOQ := CTOD("//")'												, ; //X7_REGRA
	'A6_DTBLOQ'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	'M->A6_BLOCKED == "2"'													} ) //X7_CONDIC

//
// Campo A6_COD
//
aAdd( aSX7, { ;
	'A6_COD'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'SZ1->Z1_DESCR'															, ; //X7_REGRA
	'A6_NOME'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SZ1'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'xFilial("SZ1") + M->A6_COD'											, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'A6_COD'																, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	'SZ1->Z1_DREDUZ'														, ; //X7_REGRA
	'A6_NREDUZ'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo A6_CONTABI
//
aAdd( aSX7, { ;
	'A6_CONTABI'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'M->A6_CONTA:= CT1->CT1_CONTA'											, ; //X7_REGRA
	'A6_CONTA'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'CT1'																	, ; //X7_ALIAS
	2																		, ; //X7_ORDEM
	'xFilial("CT1")+M->A6_CONTABI'											, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo B1_COD
//
aAdd( aSX7, { ;
	'B1_COD'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'"00"'																	, ; //X7_REGRA
	'B1_CODBAR'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'S'																		, ; //X7_PROPRI
	'INCLUI'																} ) //X7_CONDIC

aAdd( aSX7, { ;
	'B1_COD'																, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	'ExecBlock("CESTA01", .F., .F.)'										, ; //X7_REGRA
	'B1_COD'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	'.F.'																	} ) //X7_CONDIC

//
// Campo BM_CCONTA1
//
aAdd( aSX7, { ;
	'BM_CCONTA1'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'CT1->CT1_RES'															, ; //X7_REGRA
	'BM_CREDUZ1'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo C5_CLIENTE
//
aAdd( aSX7, { ;
	'C5_CLIENTE'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE,"A1_NREDUZ")'			, ; //X7_REGRA
	'C5_XNREDUZ'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'C5_CLIENTE'															, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	'CTT->CTT_CODTRA'														, ; //X7_REGRA
	'C5_TRANSP'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'CTT'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'XFILIAL("CTT")+M->C5_XCR'												, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	'INCLUI'																} ) //X7_CONDIC

//
// Campo C5_XCR
//
aAdd( aSX7, { ;
	'C5_XCR'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'CTT->CTT_DESC01'														, ; //X7_REGRA
	'C5_XDESCCR'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'CTT'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'XFILIAL("CTT")+M->C5_XCR'												, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	'INCLUI'																} ) //X7_CONDIC

aAdd( aSX7, { ;
	'C5_XCR'																, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	'CTT->CTT_CODCLI'														, ; //X7_REGRA
	'C5_CLIENTE'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'CTT'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'XFILIAL("CTT")+M->C5_XCR'												, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	'INCLUI'																} ) //X7_CONDIC

aAdd( aSX7, { ;
	'C5_XCR'																, ; //X7_CAMPO
	'003'																	, ; //X7_SEQUENC
	'CTT->CTT_LOJCLI'														, ; //X7_REGRA
	'C5_LOJACLI'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'CTT'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'XFILIAL("CTT")+M->C5_XCR'												, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	'INCLUI'																} ) //X7_CONDIC

aAdd( aSX7, { ;
	'C5_XCR'																, ; //X7_CAMPO
	'004'																	, ; //X7_SEQUENC
	'CTT->CTT_CODTRA'														, ; //X7_REGRA
	'C5_TRANSP'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'CTT'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'XFILIAL("CTT")+M->C5_XCR'												, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	'INCLUI'																} ) //X7_CONDIC

//
// Campo C6_PRODUTO
//
aAdd( aSX7, { ;
	'C6_PRODUTO'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'Subs(SB1->B1_ORIGEM,1,1)+SF4->F4_SITTRIB'								, ; //X7_REGRA
	'C6_CLASFIS'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SF4'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'IIf(!Empty(SB1->B1_TS),xFilial("SF4")+SB1->B1_TS,xFilial("SF4")+M->C6_TES)', ; //X7_CHAVE
	'S'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'C6_PRODUTO'															, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	'SF4->F4_CODLAN'														, ; //X7_REGRA
	'C6_CODLAN'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'S'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'C6_PRODUTO'															, ; //X7_CAMPO
	'003'																	, ; //X7_SEQUENC
	'SBM->BM_XTES'															, ; //X7_REGRA
	'C6_TES'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SBM'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'XFILIAL("SBM")+ALLTRIM(SUBSTR(M->C6_PRODUTO,1,2))'						, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'C6_PRODUTO'															, ; //X7_CAMPO
	'004'																	, ; //X7_SEQUENC
	'IIF(A410MULTT("C6_TES",SBM->BM_XTES),SBM->BM_XTES,"")'					, ; //X7_REGRA
	'C6_TES'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SBM'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'XFILIAL("SBM")+ALLTRIM(SUBSTR(M->C6_PRODUTO,1,2))'						, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo D1_COD
//
aAdd( aSX7, { ;
	'D1_COD'																, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'Subs(SB1->B1_ORIGEM,1,1)+SF4->F4_SITTRIB'								, ; //X7_REGRA
	'D1_CLASFIS'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SF4'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'xFilial()+SB1->B1_TE'													, ; //X7_CHAVE
	'S'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'D1_COD'																, ; //X7_CAMPO
	'002'																	, ; //X7_SEQUENC
	'IIF(FINDFUNCTION("A103CAT83"),A103CAT83(),"")'							, ; //X7_REGRA
	'D1_CODLAN'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'S'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'D1_COD'																, ; //X7_CAMPO
	'003'																	, ; //X7_SEQUENC
	'SB1->B1_DESC'															, ; //X7_REGRA
	'D1_DESCPRO'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'S'																		, ; //X7_SEEK
	'SA1'																	, ; //X7_ALIAS
	1																		, ; //X7_ORDEM
	'xFilial("SB1") + m->D1_COD'											, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'D1_COD'																, ; //X7_CAMPO
	'004'																	, ; //X7_SEQUENC
	'U_LP650Deb(.T.)[1]'													, ; //X7_REGRA
	'D1_CONTA'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

aAdd( aSX7, { ;
	'D1_COD'																, ; //X7_CAMPO
	'005'																	, ; //X7_SEQUENC
	'U_LP650Deb(.T.)[2]'													, ; //X7_REGRA
	'D1_ITEMCTA'															, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

//
// Campo D1_ITEMCTA
//
aAdd( aSX7, { ;
	'D1_ITEMCTA'															, ; //X7_CAMPO
	'001'																	, ; //X7_SEQUENC
	'Posicione("CT1",2,xFilial("CT1")+M->D1_ITEMCTA,"CT1_CONTA")'			, ; //X7_REGRA
	'D1_CONTA'																, ; //X7_CDOMIN
	'P'																		, ; //X7_TIPO
	'N'																		, ; //X7_SEEK
	''																		, ; //X7_ALIAS
	0																		, ; //X7_ORDEM
	''																		, ; //X7_CHAVE
	'U'																		, ; //X7_PROPRI
	''																		} ) //X7_CONDIC

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
	MsgStop( "Não foi possível a abertura da tabela " + ;
	IIf( lShared, "de empresas (SM0).", "de empresas (SM0) de forma exclusiva." ), "ATENÇÃO" )
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
