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
/*/{Protheus.doc} compdic
Função de update de dicionários para compatibilização

@author TOTVS Protheus
@since  27/10/2016
@obs    Gerado por COMPADIC - V.4.18.12.10 EFS / Upd. V.4.20.15 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
User Function COMP_SX6( cEmpAmb, cFilAmb )

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
					MsgStop( "Atualização Realizada.", "COMPDIC" )
				Else
					MsgStop( "Atualização não Realizada.", "COMPDIC" )
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
			MsgStop( "Atualização não Realizada.", "COMPDIC" )

		EndIf

	Else
		MsgStop( "Atualização não Realizada.", "COMPDIC" )

	EndIf

EndIf

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSTProc
Função de processamento da gravação dos arquivos

@author TOTVS Protheus
@since  27/10/2016
@obs    Gerado por COMPADIC - V.4.18.12.10 EFS / Upd. V.4.20.15 EFS
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
/*/{Protheus.doc} FSAtuSX6
Função de processamento da gravação do SX6 - Parâmetros

@author TOTVS Protheus
@since  27/10/2016
@obs    Gerado por COMPADIC - V.4.18.12.10 EFS / Upd. V.4.20.15 EFS
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
	'MV_1DUPNAT'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Campo ou dado a ser gravado na natureza do titulo.'					, ; //X6_DESCRIC
	'Campo o dato a ser grabado en la modalidad del ti'						, ; //X6_DSCSPA
	'Field or data to be recorded in the bill class'						, ; //X6_DSCENG
	'Quando o mesmo for gerado automaticamente pelo mo-'					, ; //X6_DESC1
	'tulo, cuando este es emitido automaticamente por'						, ; //X6_DSCSPA1
	'when this is automatically generated by the'							, ; //X6_DSCENG1
	'dulo de faturamento.'													, ; //X6_DESC2
	'el modulo de Facturacion.'												, ; //X6_DSCSPA2
	'invoicing module'														, ; //X6_DSCENG2
	'SC5->C5_NATUREZ'														, ; //X6_CONTEUD
	'SC5->C5_NATUREZ'														, ; //X6_CONTSPA
	'SA1->A1_NATUREZ'														, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	'SA1->A1_NATUREZ'														, ; //X6_DEFPOR
	'SA1->A1_NATUREZ'														, ; //X6_DEFSPA
	'SA1->A1_NATUREZ'														, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_ACENTO'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Utilza acento no Microsiga Protheus.'									, ; //X6_DESCRIC
	'¿Usa tilde en el SIGAADV FOR WINDOWS?'									, ; //X6_DSCSPA
	'Use accent in SIGAADV for windows "N" for'								, ; //X6_DSCENG
	'Preencher N para não utilizar acentos,'								, ; //X6_DESC1
	'<N> para acentuacion compatible con version DOS'						, ; //X6_DSCSPA1
	'compatibilizing with DOS version'										, ; //X6_DSCENG1
	'S para utilizar'														, ; //X6_DESC2
	'S para utilizar'														, ; //X6_DSCSPA2
	'S to use'																, ; //X6_DSCENG2
	'S'																		, ; //X6_CONTEUD
	'N'																		, ; //X6_CONTSPA
	'N'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	'N'																		, ; //X6_DEFPOR
	'N'																		, ; //X6_DEFSPA
	'N'																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_ALTPDOC'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Indica se a aba Documentos no Grupo de Aprovação é'					, ; //X6_DESCRIC
	'Indica si solapa Documentos en Grupo de Aprobacion'					, ; //X6_DSCSPA
	'Indicates if the Documents tab on Approval Group'						, ; //X6_DSCENG
	'exibida (T) ou não (F)'												, ; //X6_DESC1
	'aparece (T) o no (F)'													, ; //X6_DSCSPA1
	'is displayed (T) or not (F)'											, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'T'																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	'F'																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_ALTPEDC'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Pode Alterar o Pedido de Compras ja Atendido ?'						, ; //X6_DESCRIC
	'¿Puede Modificar el Pedido de Compras ya Atendido?'					, ; //X6_DSCSPA
	'Edits Purchase Order already supplied?'								, ; //X6_DSCENG
	'(S) Sim ou (N)Nao.'													, ; //X6_DESC1
	'(S) Si o (N)No.'														, ; //X6_DSCSPA1
	'(Y) Yes or (N) No.'													, ; //X6_DSCENG1
	'OBS: Campos de Quantidade e Preço do Pedido'							, ; //X6_DESC2
	'OBS: Campos de Cantidad y Precio del Pedido'							, ; //X6_DSCSPA2
	'Obs: Orders Amount and Prices Fields'									, ; //X6_DSCENG2
	'S'																		, ; //X6_CONTEUD
	'S'																		, ; //X6_CONTSPA
	'S'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	'S'																		, ; //X6_DEFPOR
	'S'																		, ; //X6_DEFSPA
	'S'																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_APROVTR'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Este parâmetro tem como objetivo indicar se a soli'					, ; //X6_DESCRIC
	'El objetivo de este parametro es indicar si la sol'					, ; //X6_DSCSPA
	'This parameter aims at indicating whether the'							, ; //X6_DSCENG
	'citação de transferência de produto deve ser subme'					, ; //X6_DESC1
	'icitud de transfer. de producto debe ser sometida'						, ; //X6_DSCSPA1
	'product transfer request must be subject to'							, ; //X6_DSCENG1
	'tida a aprovação.'														, ; //X6_DESC2
	'a aprobacion.'															, ; //X6_DSCSPA2
	'approval.'																, ; //X6_DSCENG2
	'.T.'																	, ; //X6_CONTEUD
	'.F.'																	, ; //X6_CONTSPA
	'.F.'																	, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	'.F.'																	, ; //X6_DEFPOR
	'.F.'																	, ; //X6_DEFSPA
	'.F.'																	, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_ARQPROD'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'O parametro configura se os dados de indicadores'						, ; //X6_DESCRIC
	'El  parametro configura si  datos de indicadores'						, ; //X6_DSCSPA
	'The parameter configures if data of product'							, ; //X6_DSCENG
	'de produto serao considerados pela tabela "SB1" ou'					, ; //X6_DESC1
	'de producto seran considerados por tabela "SB1" o'						, ; //X6_DSCSPA1
	'indicators will be considered by the "SB1"table or'					, ; //X6_DSCENG1
	'se serao considerados pela da tabela "SBZ"'							, ; //X6_DESC2
	'si deben ser configurados a traves de tabla "SBZ'						, ; //X6_DSCSPA2
	'if they must be configured through the "SBZ" table'					, ; //X6_DSCENG2
	'SBZ'																	, ; //X6_CONTEUD
	'SBZ'																	, ; //X6_CONTSPA
	'SBZ'																	, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	'SB1'																	, ; //X6_DEFPOR
	'SB1'																	, ; //X6_DEFSPA
	'SB1'																	, ; //X6_DEFENG
	'S'																		} ) //X6_PYME


aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_BR10925'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Define momento do tratamento da retencäo dos impos'					, ; //X6_DESCRIC
	'Define momento de tratamiento de retencion impues'						, ; //X6_DSCSPA
	'It defines moment of deduction of the taxes'							, ; //X6_DSCENG
	'tos Pis Cofins e Csll'													, ; //X6_DESC1
	'tos Pis Cofins y Csll'													, ; //X6_DSCSPA1
	'PIS, Cofins and Csll'													, ; //X6_DSCENG1
	'1 = Na Baixa ou 2 = Na Emissäo (Default)'								, ; //X6_DESC2
	'1 = En la Baja o 2 = En Emision (Default)'								, ; //X6_DSCSPA2
	'1 = Write-off or 2 = Issue (default)'									, ; //X6_DSCENG2
	'1'																		, ; //X6_CONTEUD
	'2'																		, ; //X6_CONTSPA
	'2'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	'2'																		, ; //X6_DEFPOR
	'2'																		, ; //X6_DEFSPA
	'2'																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME


aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CODREG'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Codigo do regime tributario do emitente da Nf-e'						, ; //X6_DESCRIC
	'Codigo del reg. tributario del emitente de e-Fact'						, ; //X6_DSCSPA
	'Tax system code of NF-e issuer'										, ; //X6_DSCENG
	'1-Simples Nacional; 2-Simples Nacional- Excesso de'					, ; //X6_DESC1
	'1-Simples Nacional; 2-Simples Nacional- Exceso de'						, ; //X6_DSCSPA1
	'1-Simples Nacional; 2-Simples Nacional- Excess of'						, ; //X6_DSCENG1
	'sub-limite de receita bruta; 3- Regime Nacional'						, ; //X6_DESC2
	'sublimite de ingreso bruto; 3- Regimen Nacional'						, ; //X6_DSCSPA2
	'gross income sublimit; 3- National System'								, ; //X6_DSCENG2
	'3'																		, ; //X6_CONTEUD
	'3'																		, ; //X6_CONTSPA
	'3'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CRGTRIB'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Define se deverá ser apresentada a mensagem da'						, ; //X6_DESCRIC
	'Define si debe presentarse el mensaje de la'							, ; //X6_DSCSPA
	'Define if the Tax Load - NFSe Transparency Law'						, ; //X6_DSCENG
	'Carga Tributária - Lei da Transparência para NFSe.'					, ; //X6_DESC1
	'Carga tributaria - Ley de transparencia para e-Fac'					, ; //X6_DSCSPA1
	'message will be shown.'												, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.T.'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	'.F.'																	, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME


aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CTBAIXA'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Tipo de Contabilizacao da Baixa (C.Pagar)'								, ; //X6_DESCRIC
	'Opcion de contabilizacion de la baja (C. Pagar)'						, ; //X6_DSCSPA
	'Posting Accounting Type (Account Payable)'								, ; //X6_DSCENG
	'(B)aixa, na geracao do (C)heque ou em (A)mbos os'						, ; //X6_DESC1
	'<B>aja; al emitir el <C>heque; o en <A>mbos'							, ; //X6_DSCSPA1
	'(B) Posting, in the generation of (C)heck, or in'						, ; //X6_DSCENG1
	'casos.'																, ; //X6_DESC2
	'casos.'																, ; //X6_DSCSPA2
	'(A) Both cases.'														, ; //X6_DSCENG2
	'A'																		, ; //X6_CONTEUD
	'C'																		, ; //X6_CONTSPA
	'C'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	'C'																		, ; //X6_DEFPOR
	'C'																		, ; //X6_DEFSPA
	'C'																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CTBAPLA'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Indica se o SigaCTB ira limpar os flags de contabi'					, ; //X6_DESCRIC
	'Indica si el SigaCTB limpiara los flags de conta'						, ; //X6_DSCSPA
	'Indicates if SigaCTB will clear accounting flags'						, ; //X6_DSCENG
	'lização (_LA/_DTLANC) ao excluir lançamentos.'							, ; //X6_DESC1
	'bilizacion (_LA/_DTLANC) al borrar asientos.'							, ; //X6_DSCSPA1
	'(_LA/_DTLANC) when deleting entries. 1=No;'							, ; //X6_DSCENG1
	'1=Nao;2=Perguntar;3=Sim c/alertas;4=Sim s/ alertas'					, ; //X6_DESC2
	'1=No;2=Preguntar;3=Si c/alertas;4=Si s/ alertas'						, ; //X6_DSCSPA2
	'2=Ask;3=Yes with alerts;4=Yes without alerts'							, ; //X6_DSCENG2
	'4'																		, ; //X6_CONTEUD
	'1'																		, ; //X6_CONTSPA
	'1'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	'1'																		, ; //X6_DEFPOR
	'1'																		, ; //X6_DEFSPA
	'1'																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_CTBCUBE'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Utiliza cubo de entidades contábeis?'									, ; //X6_DESCRIC
	'¿Utiliza cubo de entidades contables?'									, ; //X6_DSCSPA
	'Use accounting entity cubes?'											, ; //X6_DSCENG
	'Definicao 0 = Não, 1 = Sim'											, ; //X6_DESC1
	'Definicion 0 = No, 1 = Si'												, ; //X6_DSCSPA1
	'Definition 0 = No, 1 = Yes'											, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'0'																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	'1'																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME


aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_DCHVNFE'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Informa se deverá digitar a chave da Nfe/Cte'							, ; //X6_DESCRIC
	'Informa si debera digitar la clave de e-Fact/Cte'						, ; //X6_DSCSPA
	'Indicate if Nfe/Cte key must be entered'								, ; //X6_DSCENG
	'caso a espécie seja SPED/CTE e Form.Próprio=NÃO'						, ; //X6_DESC1
	'si la especie es SPED/CTE y From Propio=NO'							, ; //X6_DSCSPA1
	'in case type is SPED/CTE and OwnForm=NO'								, ; //X6_DSCENG1
	'.T. = Sim; .F. = Não.'													, ; //X6_DESC2
	'.T. = Si; .F. = No.'													, ; //X6_DSCSPA2
	'.T. = Yes; .F. = No.'													, ; //X6_DSCENG2
	'.T.'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME


aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_DESCNFS'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Indica se será utilizada a rotina de personalizaçã'					, ; //X6_DESCRIC
	'Indica si se utilizará la rutina de personaliza'						, ; //X6_DSCSPA
	'Indicates if customization routine of NFS-e servic'					, ; //X6_DSCENG
	'o de descrições de serviços da NFS-e (FATA910).'						, ; //X6_DESC1
	'ción de descripciones de Serv de e-FactS (FATA910)'					, ; //X6_DSCSPA1
	'description will be used (FATA910).'									, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.T.'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	'.F.'																	, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME


aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_EMCONTA'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Indica qual conta utilizada para envio de e-mails'						, ; //X6_DESCRIC
	'Indica que cuenta es utilizada para envio de'							, ; //X6_DSCSPA
	'Indicate the account the system uses to send'							, ; //X6_DSCENG
	'automaticos pelo sistema.'												, ; //X6_DESC1
	'e-mails automaticos por el sistema.'									, ; //X6_DSCSPA1
	'automatic e-mails.'													, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'protheus@gjphoteis.com'												, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_EMSENHA'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Indica qual a senha da conta utilizada para envio'						, ; //X6_DESCRIC
	'Indica cual es la clave de cuenta utilizada para'						, ; //X6_DSCSPA
	'Indicate the account password the system uses'							, ; //X6_DSCENG
	'de e-mails automaticos pelo sistema.'									, ; //X6_DESC1
	'envio de e-mails automaticos por el sistema'							, ; //X6_DSCSPA1
	'to send automatic e-mails.'											, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'D7WccS5M87cgMJf'														, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME


aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_FORMHT'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Formas de Pgto Hotel'													, ; //X6_DESCRIC
	'Formas de pago hotel'													, ; //X6_DSCSPA
	'Hotel Payment Term'													, ; //X6_DSCENG
	'que nao geram financeiro.'												, ; //X6_DESC1
	'que no generan financiero.'											, ; //X6_DSCSPA1
	'not generating financials.'											, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'CQ|BON'																, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	'CQ|BON'																, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME


aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_HTLBCOM'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Banco das Comissões já descontadas da fatura de'						, ; //X6_DESCRIC
	'Banco comisiones descontadas de factura de'							, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'Hotel. Preencha Banco Agencia e Conta separados'						, ; //X6_DESC1
	'Hotel. Complete Banco Agencia y Cta separados'							, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'por / . Exemplo Banco/Agencia/Conta'									, ; //X6_DESC2
	'por / . Ejemplo Banco/Agencia/Cuenta'									, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'237/3398 /0006178'														, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_HTLCCC'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Centro de custo (crédito) que será utilizado para'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'integração de lançamento contábil na integração co'					, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'contábil na integração com hotelaria'									, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'3030'																	, ; //X6_CONTEUD
	'3030'																	, ; //X6_CONTSPA
	'3030'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_HTLCCD'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Centro de custo (débito) que será utilizado para i'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'integração de lançamento contábil na integração co'					, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'contábil na integração com hotelaria'									, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'3030'																	, ; //X6_CONTEUD
	'3030'																	, ; //X6_CONTSPA
	'3030'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_HTLCCRT'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Centro de Custo Rateio Hotelaria'										, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'3010'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_HTLCONC'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Indica a Conta Contábil que será utilizada por'						, ; //X6_DESCRIC
	'Indica Cta Contable que se utilizará como'								, ; //X6_DSCSPA
	'Indicates Ledger Account that is used by'								, ; //X6_DSCENG
	'padrão para definição nos registros de clientes'						, ; //X6_DESC1
	'estándar para definición en registros de clientes'						, ; //X6_DSCSPA1
	'default for definition in records of customers'						, ; //X6_DSCENG1
	'integrados (A1_CONTA).'												, ; //X6_DESC2
	'integrados (A1_CONTA).'												, ; //X6_DSCSPA2
	'integrated (A1_CONTA).'												, ; //X6_DSCENG2
	'110101002'																, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_HTLCTC'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Conta contábil (crédito) que será utilizada para a'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'integração de lançamento contábil, na integração c'					, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'com hotelaria.'														, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'110201004'																, ; //X6_CONTEUD
	'110201001'																, ; //X6_CONTSPA
	'110201001'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_HTLCTD'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Conta contábil (débito) que será utilizada para a'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'integração de lançamento contábil, na integração c'					, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'com hotelaria.'														, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'310201002'																, ; //X6_CONTEUD
	'310201002'																, ; //X6_CONTSPA
	'310201002'																, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_HTLFT'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Indica o tipo de título que será utilizado para'						, ; //X6_DESCRIC
	'Indica el tipo de título que se utilizará para'						, ; //X6_DSCSPA
	'Indicates type of bill used for'										, ; //X6_DSCENG
	'títulos a receber gerados no processo de faturas'						, ; //X6_DESC1
	'títulos por cobrar generados en el proceso de'							, ; //X6_DSCSPA1
	'bills receivable generated in invoice process'							, ; //X6_DSCENG1
	'de hotel.'																, ; //X6_DESC2
	'facturas de hotel.'													, ; //X6_DSCSPA2
	'of hotel.'																, ; //X6_DSCENG2
	'FT'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	'FT'																	, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_HTLMD5'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Código MD5 da aplicação parceira de integração com'					, ; //X6_DESCRIC
	'Código MD5 de aplicación Asoc. de Integración con'						, ; //X6_DSCSPA
	'MD5 code of application partner of integration'						, ; //X6_DSCENG
	'hotelaria, para uso nos documentos do backoffice'						, ; //X6_DESC1
	'hotelería, para uso en documentos del backoffice'						, ; //X6_DSCSPA1
	'with hotel, for backoffice documents use'								, ; //X6_DSCENG1
	'(nfe)'																	, ; //X6_DESC2
	'(e-fact)'																, ; //X6_DSCSPA2
	'(nfe)'																	, ; //X6_DSCENG2
	''																		, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_HTLNACC'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Indica a natureza que será utilizada para títulos'						, ; //X6_DESCRIC
	'Indica la modadli que se usará para títulos'							, ; //X6_DSCSPA
	'Indicates the class used for receivable bills'							, ; //X6_DSCENG
	'a receber do tipo CC na integração com hotelaria.'						, ; //X6_DESC1
	'por cobrar tipo CC en integración con Newhotel.'						, ; //X6_DSCSPA1
	'of the CC type on integration with Newhotel.'							, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'110201001'																, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_HTLNACD'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Indica a natureza que será utilizada para títulos'						, ; //X6_DESCRIC
	'Indica modalidad que se utilizará para títulos'						, ; //X6_DSCSPA
	'Indicates the class used for receivable bills'							, ; //X6_DSCENG
	'receber do tipo CD na integração com hotelaria.'						, ; //X6_DESC1
	'por cobrar tipo CD en integración con Newhotel'						, ; //X6_DSCSPA1
	'of the CD type on integration with Newhotel.'							, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'110201002'																, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_HTLNADH'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Natureza que será utilizada para títulos a receber'					, ; //X6_DESCRIC
	'Modalidad que se utilizará para títulos por cobrar'					, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'(dinheiro) quando um cupom fiscal (crédito quarto)'					, ; //X6_DESC1
	'(dinero) cuando un Comp. Fiscal (crédito cuarto)'						, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'for pago separado do RPS. Integração c/ hotelaria.'					, ; //X6_DESC2
	'se pague separado del RPS. Integrac. c/ hotelería.'					, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'110201005'																, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_HTLNAFT'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Indica a natureza que será utilizada para títulos'						, ; //X6_DESCRIC
	'Indica la modalidad que se utilizará para títulos'						, ; //X6_DSCSPA
	'Indicates nature used for bills'										, ; //X6_DSCENG
	'a receber gerados no processo de faturas de hotel.'					, ; //X6_DESC1
	'a cobrar generados en proceso de facturas de hotel'					, ; //X6_DSCSPA1
	'receivable generated in invoice process of hotel.'						, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'110614'																, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_HTLNAMB'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Indica a natureza que sera utilizada para moviment'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'movimentacoes bancarias no processo de devolucao,'						, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	', em dinheiro, de adiantamentos realizados com car'					, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'310104002'																, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_HTLNANC'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Indica a natureza que será utilizada para títulos'						, ; //X6_DESCRIC
	'Indica modalidad que se utilizará para títulos'						, ; //X6_DSCSPA
	'Indicates the class used for receivable bills'							, ; //X6_DSCENG
	'a receber do tipo NCC na integração com hotelaria.'					, ; //X6_DESC1
	'por cobrar tipo NCC en integración con Newhotel'						, ; //X6_DSCSPA1
	'of the NCC type on integration with Newhotel.'							, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'110201004'																, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_HTLNAPF'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Indica a natureza que será utilizada para títulos'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'a pagar, referentes a comissões para fornecedor'						, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'Pessoa Física.'														, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'210203002'																, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_HTLNAPJ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Indica a natureza que será utilizada para títulos'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'a pagar, referentes a comissões para fornecedor'						, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'Pessoa Jurídica.'														, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'110211'																, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_HTLNAPR'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Indica a natureza que será utilizada para títulos'						, ; //X6_DESCRIC
	'Indica la modalidad que se usará para títulos'							, ; //X6_DSCSPA
	'Indicates the class used for receivable bills'							, ; //X6_DSCENG
	'a receber do tipo PR na integração com hotelaria.'						, ; //X6_DESC1
	'por cobrar tipo PR en integración con Newhotel.'						, ; //X6_DSCSPA1
	'of the PR type on integration with Newhotel.'							, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'110614'																, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_HTLNARA'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Indica a natureza que será utilizada para títulos'						, ; //X6_DESCRIC
	'Indica la modaliad que se usará para títulos'							, ; //X6_DSCSPA
	'Indicates the class used for receivable bills'							, ; //X6_DSCENG
	'a receber do tipo RA na integração com hotelaria.'						, ; //X6_DESC1
	'por cobrar tipo RA en integración con Newhotel.'						, ; //X6_DSCSPA1
	'of the RA type on integration with Newhotel.'							, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'110211'																, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_HTLNART'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Natureza rateio Hotelaria'												, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'OUTROS'																, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_HTLNATP'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Indica a natureza que será utilizada para títulos'						, ; //X6_DESCRIC
	'Indica la modalidad que se utilizara para titulos'						, ; //X6_DSCSPA
	'Indicates the nature that will be used for'							, ; //X6_DSCENG
	'a pagar na integração com hotelaria.'									, ; //X6_DESC1
	'por pagar en la integracion con el Newhotel.'							, ; //X6_DSCSPA1
	'receivable bills with Newhotel.'										, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'420201004'																, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_HTLNCPF'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Indica a natureza que será utilizada para títulos'						, ; //X6_DESCRIC
	'Indica modalidad que se utilizará para el título'						, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'a pagar, referentes a comissões descontadas em fat'					, ; //X6_DESC1
	'por pagar, referente a Comis. Descont. en facturas'					, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'uras de hotelaria para fornecedor Pessoa Física.'						, ; //X6_DESC2
	'de hotelería para proveedor Persona física.'							, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'310102001'																, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_HTLNCPJ'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Indica a natureza que será utilizada para títulos'						, ; //X6_DESCRIC
	'Indica modalidad que se utilizará para títulos'						, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'a pagar, referentes a comissões descontadas em fat'					, ; //X6_DESC1
	'por pagar, referentes a Comis. Descon. en facturas'					, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'uras de hotelaria para fornecedor Pessoa Jurídica.'					, ; //X6_DESC2
	'de hotelería para proveedor Persona jurídica.'							, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'110614'																, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_HTLPNFE'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Prefixo utilizado nos títulos a receber referentes'					, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'a NFe, na integração com hotelaria'									, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'PED'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_HTLPREC'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Indica o prefixo que será utilizado para títulos a'					, ; //X6_DESCRIC
	'Indica prefijo que se utilizará para títulos por'						, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'pagar, referentes a comissões descontadas em'							, ; //X6_DESC1
	'pagar, referentes a Comis. Descontadas en'								, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'faturas de hotelaria.'													, ; //X6_DESC2
	'facturas de hotelería.'												, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'CDF'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	'CDF'																	, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_HTLPREF'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Indica o prefixo que será utilizado para os'							, ; //X6_DESCRIC
	'Indica prefijo que se utilizara para los'								, ; //X6_DSCSPA
	'Indicates the prefix that will be used for'							, ; //X6_DSCENG
	'títulos a receber na integração com hotelaria.'						, ; //X6_DESC1
	'titulos por cobrar en la integracion con Newhotel.'					, ; //X6_DSCSPA1
	'receivable bills on integration with Newhotel.'						, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'GJP'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_HTLTCDF'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Indica o tipo de título que será utilizado para'						, ; //X6_DESCRIC
	'Indica tipo de título que se utilizará para'							, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'títulos a pagar, referentes a comissões descontada'					, ; //X6_DESC1
	'títulos por pagar, referentes a Comis. Descon.'						, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	'em faturas de hotelaria.'												, ; //X6_DESC2
	'en facturas de hotelería.'												, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'DP'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	'DP'																	, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME



aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_INTHTL'																, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Indica a integração com produto de administração'						, ; //X6_DESCRIC
	'Indica integracion con producto de administracion'						, ; //X6_DSCSPA
	'Indicates integration with hotel administration'						, ; //X6_DSCENG
	'hoteleira.'															, ; //X6_DESC1
	'hotelera.'																, ; //X6_DSCSPA1
	'product.'																, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.T.'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	'.F.'																	, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_LJ130MN'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Permite gerar uma nota para múltiplos cupons'							, ; //X6_DESCRIC
	'Permite generar una factura p/múltiples comprobant'					, ; //X6_DSCSPA
	'Allows generation of invoice for multiple cupons'						, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.T.'																	, ; //X6_CONTEUD
	'.T.'																	, ; //X6_CONTSPA
	'.T.'																	, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME


aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_LJFORHT'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Formas de Pgto Hotel'													, ; //X6_DESCRIC
	'Formas de pago hotel'													, ; //X6_DSCSPA
	'Hotel payment terms'													, ; //X6_DSCENG
	'que nao geram financeiro.'												, ; //X6_DESC1
	'que no generan financiero.'											, ; //X6_DSCSPA1
	'that do not generate finance.'											, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'CQ|CI|;'																, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	'CQ|FAT'																, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME


aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_LJNCUPS'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'TES de servico para nota sobre cupom (F3 OnLine)'						, ; //X6_DESCRIC
	'TES de servico para fact. sobre compro (F3 OnLine)'					, ; //X6_DSCSPA
	'Service TIO for invoice over coupon (F3 OnLine)'						, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'604'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_LOJANF'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Serie da Nota Fiscal - SIGALOJA'										, ; //X6_DESCRIC
	'Serie de la Factura - SIGALOJA.'										, ; //X6_DSCSPA
	'Invoice Series - Point of Sales'										, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'3'																		, ; //X6_CONTEUD
	'UNI'																	, ; //X6_CONTSPA
	'UNI'																	, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	'UNI'																	, ; //X6_DEFPOR
	'UNI'																	, ; //X6_DEFSPA
	'UNI'																	, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_LOJARPS'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Serie da Nota Fiscal de Servico (RPS)'									, ; //X6_DESCRIC
	'Serie de Factura de Servicio (RPS)'									, ; //X6_DSCSPA
	'Service Invoice Series (RPS)'											, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'1'																		, ; //X6_CONTEUD
	'RPS'																	, ; //X6_CONTSPA
	'RPS'																	, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	'RPS'																	, ; //X6_DEFPOR
	'RPS'																	, ; //X6_DEFSPA
	'RPS'																	, ; //X6_DEFENG
	'S'																		} ) //X6_PYME


aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_MULNATR'															, ; //X6_VAR
	'L'																		, ; //X6_TIPO
	'Utilizado para identificar se o tit. utiliza multi'					, ; //X6_DESCRIC
	'Utilizado para identificar si el tit utiliza multi'					, ; //X6_DSCSPA
	'Used to identify if bills use'											, ; //X6_DSCENG
	'plas naturezas no contas a receber'									, ; //X6_DESC1
	'ples modalidades en el cuentas por pagar'								, ; //X6_DSCSPA1
	'multiple classes in accounts receivable'								, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'.T.'																	, ; //X6_CONTEUD
	'.T.'																	, ; //X6_CONTSPA
	'.T.'																	, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	'F'																		, ; //X6_DEFPOR
	'F'																		, ; //X6_DEFSPA
	'F'																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME


aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_NATFATU'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Natureza de Forma de Pagamento FA'										, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'hotel'																	, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'"DINHEIRO"'															, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME


aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_NFESERV'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Indica se a descrição do serviço prestado na Nota'						, ; //X6_DESCRIC
	'Indica si descripcion servicio prestado en la Fact'					, ; //X6_DSCSPA
	'Indicates if service description provided in the'						, ; //X6_DSCENG
	'Fiscal Eletrônica será composta: 1 - pedido de'						, ; //X6_DESC1
	'Electronica se compondra: 1 - pedido de'								, ; //X6_DSCSPA1
	'Electronic Invoice is composed: 1 - sales order'						, ; //X6_DSCENG1
	'vendas + descrição SX5 ou 2 - somente SX5.'							, ; //X6_DESC2
	'ventas + descripcion SX5 o 2 - solamente SX5.'							, ; //X6_DSCSPA2
	'+ SX5 description or 2 - only SX5.'									, ; //X6_DSCENG2
	'1'																		, ; //X6_CONTEUD
	'2'																		, ; //X6_CONTSPA
	'2'																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	'2'																		, ; //X6_DEFPOR
	'2'																		, ; //X6_DEFSPA
	'2'																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_RELACNT'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Conta a ser utilizada no envio de E-Mail para os'						, ; //X6_DESCRIC
	'Cuenta a ser utilizada en el envio de E-Mail para'						, ; //X6_DSCSPA
	'Account to be used to send e-mail to'									, ; //X6_DSCENG
	'relatorios'															, ; //X6_DESC1
	'los informes.'															, ; //X6_DSCSPA1
	'reports.'																, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'protheus@gjphoteis.com'												, ; //X6_CONTEUD
	'protheus@gjphoteis.com'												, ; //X6_CONTSPA
	'protheus@gjphoteis.com'												, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_RELAPSW'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Senha para autenticacäo no servidor de e-mail'							, ; //X6_DESCRIC
	'Contrasena para autenticacion en servidor de e-mai'					, ; //X6_DSCSPA
	'Password used to authenticate the e-mail in server'					, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'D7WccS5M87cgMJf'														, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'N'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_RELAUSR'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Usuario para Autenticacao no Servidor de Email'						, ; //X6_DESCRIC
	'Usuario para Autenticacion en el Servidor de Email'					, ; //X6_DSCSPA
	'User for authentication in e-mail server'								, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'protheus'																, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'N'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_RELFROM'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'E-mail utilizado no campo FROM no envio de'							, ; //X6_DESCRIC
	'E-mail utilizado en el campo FROM para envio de'						, ; //X6_DSCSPA
	'E-mail used in the "FROM" field when sending'							, ; //X6_DSCENG
	'relatorios por e-mail'													, ; //X6_DESC1
	'informes por e-mail.'													, ; //X6_DSCSPA1
	'reports by e-mail.'													, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'protheus@gjphoteis.com'												, ; //X6_CONTEUD
	'protheus@gjphoteis.com'												, ; //X6_CONTSPA
	'protheus@gjphoteis.com'												, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_RELPSW'																, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Senha da Conta de E-Mail para envio de relatorios'						, ; //X6_DESCRIC
	'Contrasena de cta. de E-mail para enviar informes'						, ; //X6_DSCSPA
	'E-mail pasword to send the reports.'									, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'D7WccS5M87cgMJf'														, ; //X6_CONTEUD
	'D7WccS5M87cgMJf'														, ; //X6_CONTSPA
	'D7WccS5M87cgMJf'														, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_RELSERV'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Nome do Servidor de Envio de E-mail utilizado nos'						, ; //X6_DESCRIC
	'Nombre de Servidor de Envio de E-mail utilizado en'					, ; //X6_DSCSPA
	'E-mail Sending Server Name used in'									, ; //X6_DSCENG
	'relatorios'															, ; //X6_DESC1
	'los informes.'															, ; //X6_DSCSPA1
	'reports.'																, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'aspmx.l.google.com'													, ; //X6_CONTEUD
	'aspmx.l.google.com'													, ; //X6_CONTSPA
	'aspmx.l.google.com'													, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME


aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_TESNOTA'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Tipo de Saida para geracao de Nota Fiscal s/Cupom'						, ; //X6_DESCRIC
	'Tipo de salida para geracion del NF s/ comprobante'					, ; //X6_DSCSPA
	'Outflow Type to generate Invoice without Voucher'						, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'850'																	, ; //X6_CONTEUD
	'501'																	, ; //X6_CONTSPA
	'501'																	, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	'501'																	, ; //X6_DEFPOR
	'501'																	, ; //X6_DEFSPA
	'501'																	, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_TESPCNF'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Informe os tipos de entrada e saída (TES) que não'						, ; //X6_DESCRIC
	'Informe los tipos de entrada y salida (TES) que no'					, ; //X6_DSCSPA
	'Enter Types of Inflow and Outflow that do not'							, ; //X6_DSCENG
	'necessitam de amarração com pedido de compras.'						, ; //X6_DESC1
	'necesitan de vinculo con pedido de compras.'							, ; //X6_DSCSPA1
	'need binding with purchase orders.'									, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'499/112'																, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_TESSERV'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Tes para Servico NewHotel'												, ; //X6_DESCRIC
	'TES para servicio NewHotel'											, ; //X6_DSCSPA
	'Tio for NewHotel Service'												, ; //X6_DSCENG
	''																		, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'605'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'MV_TESVEND'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Informe a Tes utilizado para o processamento'							, ; //X6_DESCRIC
	'Informe la Tes utilizada para el procesamiento'						, ; //X6_DSCSPA
	'Enter TIO used for processing'											, ; //X6_DSCENG
	'das Notas fiscais de Venda a Ordem.'									, ; //X6_DESC1
	'de las facturas de venta a Orden.'										, ; //X6_DSCSPA1
	'Sale Invoices to Order.'												, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	'602'																	, ; //X6_CONTEUD
	''																		, ; //X6_CONTSPA
	''																		, ; //X6_CONTENG
	'S'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	'S'																		} ) //X6_PYME

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
		If !StrTran( SX6->X6_CONTEUD, " ", "" ) == StrTran( aSX6[nI][13], " ", "" )

			cMsg := "O parâmetro " + aSX6[nI][2] + " está com o conteúdo" + CRLF + ;
			"[" + RTrim( StrTran( SX6->X6_CONTEUD, " ", "" ) ) + "]" + CRLF + ;
			", que é será substituido pelo NOVO conteúdo " + CRLF + ;
			"[" + RTrim( StrTran( aSX6[nI][13]   , " ", "" ) ) + "]" + CRLF + ;
			"Deseja substituir ? "

			If      lTodosSim
				nOpcA := 1
			ElseIf  lTodosNao
				nOpcA := 2
			Else
				nOpcA := Aviso( "ATUALIZAÇÃO DE DICIONÁRIOS E TABELAS", cMsg, { "Sim", "Não", "Sim p/Todos", "Não p/Todos" }, 3, "Diferença de conteúdo - SX6" )
				lTodosSim := ( nOpcA == 3 )
				lTodosNao := ( nOpcA == 4 )

				If lTodosSim
					nOpcA := 1
					lTodosSim := MsgNoYes( "Foi selecionada a opção de REALIZAR TODAS alterações no SX6 e NÃO MOSTRAR mais a tela de aviso." + CRLF + "Confirma a ação [Sim p/Todos] ?" )
				EndIf

				If lTodosNao
					nOpcA := 2
					lTodosNao := MsgNoYes( "Foi selecionada a opção de NÃO REALIZAR nenhuma alteração no SX6 que esteja diferente da base e NÃO MOSTRAR mais a tela de aviso." + CRLF + "Confirma esta ação [Não p/Todos]?" )
				EndIf

			EndIf

			lContinua := ( nOpcA == 1 )

			If lContinua
				AutoGrLog( "Foi alterado o parâmetro " + aSX6[nI][1] + aSX6[nI][2] + " de [" + ;
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
@since  27/10/2016
@obs    Gerado por COMPADIC - V.4.18.12.10 EFS / Upd. V.4.20.15 EFS
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
@since  27/10/2016
@obs    Gerado por COMPADIC - V.4.18.12.10 EFS / Upd. V.4.20.15 EFS
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
