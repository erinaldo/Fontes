#INCLUDE "PROTHEUS.CH"
#INCLUDE "UPSIX01H.CH"

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
/*/{Protheus.doc} UPSIX01H
Função de update de dicionários para compatibilização

@author TOTVS Protheus
@since  06/04/2015
@obs    Gerado por EXPORDIC - V.4.22.10.7 EFS / Upd. V.4.19.12 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
User Function UPDGERSIX( cEmpAmb, cFilAmb )

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
					MsgStop( STR0011, "UPSIX01H" ) //"Atualização Realizada."
				Else
					MsgStop( STR0011, "UPSIX01H" ) //"Atualização não Realizada."
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
			MsgStop( STR0011, "UPSIX01H" ) //"Atualização não Realizada."

		EndIf

	Else
		MsgStop( STR0011, "UPSIX01H" ) //"Atualização não Realizada."

	EndIf

EndIf

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSTProc
Função de processamento da gravação dos arquivos

@author TOTVS Protheus
@since  06/04/2015
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
			// Atualiza o dicionário SIX
			//------------------------------------
			oProcess:IncRegua1( STR0017 + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." ) //"Dicionário de índices"
			FSAtuSIX()

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
/*/{Protheus.doc} FSAtuSIX
Função de processamento da gravação do SIX - Indices

@author TOTVS Protheus
@since  06/04/2015
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

AutoGrLog( STR0055 + " SIX" + CRLF ) //"Ínicio da Atualização"

aEstrut := { "INDICE" , "ORDEM" , "CHAVE", "DESCRICAO", "DESCSPA"  , ;
             "DESCENG", "PROPRI", "F3"   , "NICKNAME" , "SHOWPESQ" }

//
// Tabela SA2
//

aAdd( aSIX, { ;
	'SA2'																	, ; //INDICE
	'A'																		, ; //ORDEM
	'A2_FILIAL+A2_NREDUZ'												, ; //CHAVE      // ALTERAR
	'NOME FANTAZIA'														, ; //DESCRICAO
	'NOME FANTAZIA'														, ; //DESCSPA
	'NOME FANTAZIA'														, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	'SA2A'																	, ; //NICKNAME   // ALTERAR
	'S'																		} ) //SHOWPESQ  // ALTERAR

aAdd( aSIX, { ;
	'SA2'																	, ; //INDICE
	'B'																		, ; //ORDEM
	'A2_FILIAL+A2_XGRPO1'												, ; //CHAVE      //ALTERAR
	'GRUPO 1'																, ; //DESCRICAO
	'GRUPO 1'																, ; //DESCSPA
	'GRUPO 1'																, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	'SA2B'																	, ; //NICKNAME  // ALTERAR
	'S'																		} ) //SHOWPESQ  // ALTERAR

aAdd( aSIX, { ;
	'SA2'																	, ; //INDICE
	'C'																		, ; //ORDEM
	'A2_FILIAL+A2_XMATRIC'												, ; //CHAVE    // ALTERAR 
	'Matricula'															, ; //DESCRICAO
	'Matricula'															, ; //DESCSPA
	'Matricula'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	'SA2C'																	, ; //NICKNAME  // ALTERAR
	'S'																		} ) //SHOWPESQ  // ALTERAR
//
// Tabela SA6
//

aAdd( aSIX, { ;
	'SA6'																	, ; //INDICE
	'4'																		, ; //ORDEM
	'A6_FILIAL+A6_CONTABI'													, ; //CHAVE
	'CONTA CONTABIL REDUZIDA'												, ; //DESCRICAO
	'CONTA CONTABIL REDUZIDA'												, ; //DESCSPA
	'CONTA CONTABIL REDUZIDA'												, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	'SA64'																	, ; //NICKNAME  //ALTERAR 
	'S'																		} ) //SHOWPESQ  //ALTERAR

aAdd( aSIX, { ;
	'SA6'																	, ; //INDICE
	'5'																		, ; //ORDEM
	'A6_FILIAL+A6_NUMCON'												, ; //CHAVE  //ALTERAR
	'Nro Conta'															, ; //DESCRICAO
	'Nro.Cuenta'															, ; //DESCSPA
	'Account No.'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	'SA65'																	, ; //NICKNAME  //ALTERAR
	'S'																		} ) //SHOWPESQ  //ALTERAR

//
// Tabela SB5
//
aAdd( aSIX, { ;
	'SB5'																	, ; //INDICE
	'6'																		, ; //ORDEM
	'B5_FILIAL+B5_ESPECIE'												, ; //CHAVE  // ALTERAR
	'Especie Prod'														, ; //DESCRICAO
	'Especie Prod'														, ; //DESCSPA
	'Specie Prod'															, ; //DESCENG
	'S'																		, ; //PROPRI
	''																		, ; //F3
	'SB56'																	, ; //NICKNAME  //ALTERAR
	'S'																		} ) //SHOWPESQ

//
// Tabela SC8
//

aAdd( aSIX, { ;
	'SC8'																	, ; //INDICE
	'9'																		, ; //ORDEM
	'C8_FILIAL+C8_NUMPED+C8_ITEMPED+C8_COTSTS'						, ; //CHAVE   //ALTERAR
	'Pedido + Item do Pedido + Status da Cotacao'						, ; //DESCRICAO
	'Pedido + Item do Pedido + Status da Cotacao'						, ; //DESCSPA
	'Pedido + Item do Pedido + Status da Cotacao'						, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	'SC89'																	, ; //NICKNAME  // ALTERAR
	'S'																		} ) //SHOWPESQ  // ALTERAR

//
// Tabela SCZ
//

aAdd( aSIX, { ;
	'SCZ'																	, ; //INDICE
	'4'																		, ; //ORDEM
	'CZ_FILIAL+CZ_PEDIDO+CZ_ITEMPED+CZ_SEQUEN'						, ; //CHAVE      //ALTERAR 
	'PEDIDO+ITEM+SEQUENCIA'												, ; //DESCRICAO  //ALTERAR
	'PEDIDO+ITEM+SECUENCIA'												, ; //DESCSPA
	'ORDER+ITEM+SEQUENCE'												, ; //DESCENG
	'U'																		, ; //PROPRI     // ALTERADO  P/ U
	''																		, ; //F3
	'SCZ4'																	, ; //NICKNAME   // ALTERAR
	'S'																		} ) //SHOWPESQ   // ALTERAR

aAdd( aSIX, { ;
	'SCZ'																	, ; //INDICE
	'5'																		, ; //ORDEM
	'CZ_FILIAL+CZ_REMITO+CZ_ITEMREM'									, ; //CHAVE      //ALTERAR
	'REMITO+ITEM'															, ; //DESCRICAO  //ALTERAR 
	'REMITO+ITEM'															, ; //DESCSPA
	'REMITO+ITEM'															, ; //DESCENG
	'U'																		, ; //PROPRI     //ALTERADO P/ U
	''																		, ; //F3
	'SCZ5'																	, ; //NICKNAME   //ALTERAR
	'S'																		} ) //SHOWPESQ   //ALTERAR

aAdd( aSIX, { ;
	'SCZ'																	, ; //INDICE
	'6'																		, ; //ORDEM
	'CZ_FILIAL+CZ_OK+CZ_CLIENTE+CZ_LOJA+CZ_PRODUTO+CZ_TIPOREM'		, ; //CHAVE      //ALTERAR
	'MARCA+CLIENTE+LOJA+PRODUTO+TIPOREM'								, ; //DESCRICAO  //ALTERAR
	'MARCA+CLIENTE+SUCURSAL+PRODUCTO+TIPO DE REMITO'					, ; //DESCSPA
	'BRAND+CUSTOMER+BRANCH+PRODUCT+REMITO TYPE'						, ; //DESCENG
	'U'																		, ; //PROPRI     //ALTERADO P/ U
	''																		, ; //F3
	'SCZ6'																	, ; //NICKNAME   //ALTERAR
	'S'																		} ) //SHOWPESQ   //ALTERAR

//
// Tabela SD1
//

aAdd( aSIX, { ;
	'SD1'																	, ; //INDICE
	'D'																		, ; //ORDEM
	'D1_FILIAL+D1_SERIE+D1_DOC+D1_FORNECE+D1_LOJA'					, ; //CHAVE        // ALTERAR
	'Serie+Documento+Forn/Cliente+Loja'								, ; //DESCRICAO
	'Serie+Documento+Prov/Cliente+Tienda'								, ; //DESCSPA
	'Series+Documento+Prov/Cliente+Tienda'								, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	'SD1D'	 																, ; //NICKNAME    // ANTIGO = SD1LP650
	'S'																		} ) //SHOWPESQ

//
// Tabela SD2
//

aAdd( aSIX, { ;
	'SD2'																	, ; //INDICE
	'D'																		, ; //ORDEM
	'D2_FILIAL+D2_ORDSEP'												, ; //CHAVE      //ALTERAR
	'Ordem de Separacao'													, ; //DESCRICAO
	'Orden de Separacion'												, ; //DESCSPA
	'Ordem de Separacao'													, ; //DESCENG
	'U'																		, ; //PROPRI     // ALTERAR  -  ERA U
	''																		, ; //F3
	'SD2D'		 															, ; //NICKNAME   //ANTIGO = ACDSD201
	'S'																		} ) //SHOWPESQ

//
// Tabela SE1
//


aAdd( aSIX, { ;
	'SE1'																	, ; //INDICE
	'T'																		, ; //ORDEM
	'E1_FILIAL+E1_HIST'														, ; //CHAVE  // ALTERAR  
	'Historico'																, ; //DESCRICAO
	'Historial'																, ; //DESCSPA
	'History'																, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	'SE1T'																	, ; //NICKNAME   // ALTERAR // ANTIGO SE1HIS
	'S'																		} ) //SHOWPESQ   

aAdd( aSIX, { ;
	'SE1'																	, ; //INDICE
	'U'																		, ; //ORDEM      // ORDEM NA ORIGIN IGUAL A T
	'E1_FILIAL+E1_FCB'													, ; //CHAVE      // ALTERAR -  
	'CODIGO FCB'															, ; //DESCRICAO
	'CODIGO FCB'															, ; //DESCSPA
	'CODIGO FCB'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	'SE1U'																	, ; //NICKNAME   // ALTERAR // ANTIGO SE1FCB
	'S'																		} ) //SHOWPESQ   // ALTERAR  // ANTIGO = 'N'

//
// Tabela SE2
//
aAdd( aSIX, { ;
	'SE2'																	, ; //INDICE
	'H'																		, ; //ORDEM   // ORDEM NO ORIGIN ERA IGUAL A G
	'E2_FILIAL+DTOS(E2_EMISSAO)+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM'		, ; //CHAVE  // ALTERAR
	'EMISSAO + FORNECEDOR + LOJA + PREFIXO + NUMERO'						, ; //DESCRICAO
	'EMISSAO + FORNECEDOR + LOJA + PREFIXO + NUMERO'						, ; //DESCSPA
	'EMISSAO + FORNECEDOR + LOJA + PREFIXO + NUMERO'						, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	'SE2H'																	, ; //NICKNAME  // ALTERAR
	'S'																		} ) //SHOWPESQ  //ALTERAR

aAdd( aSIX, { ;
	'SE2'																	, ; //INDICE
	'I'																		, ; //ORDEM      //ORDEM NO ORIGIN ERA IGUAL H
	'E2_FILIAL+E2_PEDIDO'												, ; //CHAVE      //ALTERAR
	'PEDIDO'																, ; //DESCRICAO
	'PEDIDO'																, ; //DESCSPA
	'PEDIDO'																, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	'SE2I'																	, ; //NICKNAME   //ALTERAR
	'S'																		} ) //SHOWPESQ   //ALTERAR

aAdd( aSIX, { ;
	'SE2'																	, ; //INDICE
	'J'																		, ; //ORDEM        //ORDEM NO ORIGIN ERA IGUAL I
	'E2_FILIAL+E2_NUMBCO+E2_FORNECE'										, ; //CHAVE     //ALTERAR
	'N§ do Cheque+Fornecedor'												, ; //DESCRICAO
	'Nro. Cheque+Proveedor'													, ; //DESCSPA
	'Check No.+Proveedor'													, ; //DESCENG
	'U'																		, ; //PROPRI    
	''																		, ; //F3
	'SE2J'																	, ; //NICKNAME    //ALTERAR
	'S'																		} ) //SHOWPESQ    //ALTERAR

aAdd( aSIX, { ;
	'SE2'																	, ; //INDICE
	'K'																		, ; //ORDEM                //ORDEM NO ORIGIN ERA IGUAL J
	'E2_FILIAL+E2_RAZSOC+DTOS(E2_VENCREA)+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO'	, ; //CHAVE     //ALTERAR
	'Razao Social+Vencto Real+Prefixo+No. Titulo+Parcela+Tipo'				, ; //DESCRICAO       
	'Razao Social+Vencto. Real+Prefijo+Num. Titulo+Cuota+Tipo'				, ; //DESCSPA
	'Razao Social+Vencto. Real+Prefijo+Num. Titulo+Cuota+Tipo'				, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	'SE2K'																	, ; //NICKNAME            //ALTERAR
	'S'																		} ) //SHOWPESQ            //ALTERAR    

aAdd( aSIX, { ;
	'SE2'																	, ; //INDICE
	'L'																		, ; //ORDEM          //ORDEM NO ORIGIN ERA IGUAL K
	'E2_FILIAL+E2_NUMAP'													, ; //CHAVE
	'NUMAP'																	, ; //DESCRICAO
	'NUMAP'																	, ; //DESCSPA
	'NUMAP'																	, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	'SE2L'																	, ; //NICKNAME    // ALTERAR
	'S'																		} ) //SHOWPESQ    // ALTERAR

aAdd( aSIX, { ;
	'SE2'																	, ; //INDICE
	'M'																		, ; //ORDEM
	'E2_FILIAL+STR(E2_VALOR)+E2_NOMFOR+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO'	, ; //CHAVE  //ALTERAR
	'VALOR+NOME FORNECEDOR+PREFIXO+NUMERO+PARCELA+TIPO'						, ; //DESCRICAO
	'VALOR+NOME FORNECEDOR+PREFIXO+NUMERO+PARCELA+TIPO'						, ; //DESCSPA
	'VALOR+NOME FORNECEDOR+PREFIXO+NUMERO+PARCELA+TIPO'						, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	'SE2M'																		, ; //NICKNAME     //ALTERAR
	'S'																		} ) //SHOWPESQ

aAdd( aSIX, { ;
	'SE2'																	, ; //INDICE
	'N'																		, ; //ORDEM
	'E2_FILIAL+E2_NOMFOR+DTOS(E2_VENCREA)+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO'	, ; //CHAVE   //ALTERAR
	'NOME FORNECEDOR+DATA VENCIMENTO+PREFIXO+NUMERO+PARCELA+TIPO'			, ; //DESCRICAO
	'NOME FORNECEDOR+DATA VENCIMENTO+PREFIXO+NUMERO+PARCELA+TIPO'			, ; //DESCSPA
	'NOME FORNECEDOR+DATA VENCIMENTO+PREFIXO+NUMERO+PARCELA+TIPO'			, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	'SE2N'																	, ; //NICKNAME     //ALTERAR
	'S'																		} ) //SHOWPESQ     

aAdd( aSIX, { ;
	'SE2'																	, ; //INDICE
	'O'																		, ; //ORDEM
	'E2_FILIAL+STR(E2_VALLIQ)+E2_NOMFOR+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO'	, ; //CHAVE    //ALTERAR
	'VALOR LIQ BAIXA+NOME FORNECEDOR+PREFIXO+NUMERO+PARCELA+TIPO'			, ; //DESCRICAO
	'VALOR LIQ BAIXA+NOME FORNECEDOR+PREFIXO+NUMERO+PARCELA+TIPO'			, ; //DESCSPA
	'VALOR LIQ BAIXA+NOME FORNECEDOR+PREFIXO+NUMERO+PARCELA+TIPO'			, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	'SE2O'																		, ; //NICKNAME     //ALTERAR
	'S'																		} ) //SHOWPESQ


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
		AutoGrLog( STR0083 + aSIX[nI][1] + "/" + aSIX[nI][2] + " - " + aSIX[nI][3] ) //"Índice criado "
	Else
		lAlt := .T.
		aAdd( aArqUpd, aSIX[nI][1] )
		If !StrTran( Upper( AllTrim( CHAVE )       ), " ", "" ) == ;
		    StrTran( Upper( AllTrim( aSIX[nI][3] ) ), " ", "" )
			AutoGrLog( STR0143 + aSIX[nI][1] + "/" + aSIX[nI][2] + " - " + aSIX[nI][3] ) //"Chave do índice alterado "
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

	oProcess:IncRegua2( STR0085 ) //"Atualizando índices..."

Next nI

AutoGrLog( CRLF + STR0060 + " SIX" + CRLF + Replicate( "-", 128 ) + CRLF ) //"Final da Atualização"

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
@since  06/04/2015
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
@since  06/04/2015
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
