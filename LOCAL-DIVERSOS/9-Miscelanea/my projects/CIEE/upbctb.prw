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
/*/{Protheus.doc} UPBCTB
Função de update de dicionários para compatibilização

@author TOTVS Protheus
@since  11/12/2014
@obs    Gerado por EXPORDIC - V.4.22.10.7 EFS / Upd. V.4.19.12 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
User Function UPBCTB( cEmpAmb, cFilAmb )

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
					MsgStop( "Atualização Realizada.", "UPBCOMB1" )
				Else
					MsgStop( "Atualização não Realizada.", "UPBCOMB1" )
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
			MsgStop( "Atualização não Realizada.", "UPBCOMB1" )

		EndIf

	Else
		MsgStop( "Atualização não Realizada.", "UPBCOMB1" )

	EndIf

EndIf

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSTProc
Função de processamento da gravação dos arquivos

@author TOTVS Protheus
@since  11/12/2014
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


			FSAtuSX3()

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
/*/{Protheus.doc} FSAtuSX3
Função de processamento da gravação do SX3 - Campos

@author TOTVS Protheus
@since  11/12/2014
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
             { "X3_CONDSQL", 0 }, { "X3_CHKSQL" , 0 }, { "X3_IDXSRV" , 0 }, { "X3_ORTOGRA", 0 }, { "X3_TELA"   , 0 }, { "X3_POSLGT" , 0 }, { "X3_IDXFLD" , 0 }, ;
             { "X3_AGRUP"  , 0 }, { "X3_PYME"   , 0 } }

aEval( aEstrut, { |x| x[2] := SX3->( FieldPos( x[1] ) ) } )


aAdd( aSX3, {'CT1','01','CT1_FILIAL','C',4,0,'Filial','Sucursal','Branch','Filial do Sistema','Sucursal del Sistema','System Branch','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(128) + Chr(128),'','','','N','','','','','','','','','','','033','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','02','CT1_CONTA','C',20,0,'Cod Conta','Cod Cuenta','Account Code','Codigo da Conta','Codigo de la Cuenta','Account Code','@!','Ctb020cta()',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(176),'','',1,Chr(131) + Chr(128),'','S','','S','','','','','','','','','','','003','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','03','CT1_DESC01','C',45,0,'Desc Moeda 1','Desc Moned 1','Curr.1 Desc.','Descricao na Moeda 1','Descripcion en Moneda 1','Currency 1 Description','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(151) + Chr(128),'','','','S','A','R','','','','','','','','','','','','','S','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','04','CT1_DESC02','C',40,0,'Desc Moeda 2','Desc Moned 2','Curr.2 Desc.','Descricao na Moeda 2','Descripcion en Moneda 2','Currency 2 Description','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(214) + Chr(192),'','','','N','','','','','','','','','','','','','','','S','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','05','CT1_DESC03','C',40,0,'Desc Moeda 3','Desc Moned 3','Curr.3 Desc.','Descricao na Moeda 3','Descripcion en Moneda 3','Currency 3 Description','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(214) + Chr(192),'','','','N','','','','','','','','','','','','','','','S','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','06','CT1_DESC04','C',40,0,'Desc Moeda 4','Desc Moned 4','Curr.4 Desc.','Descricao na Moeda 4','Descripcion en Moneda 4','Currency 4 Description','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(214) + Chr(192),'','','','N','','','','','','','','','','','','','','','S','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','07','CT1_DESC05','C',40,0,'Desc Moeda 5','Desc Moned 5','Curr.5 Desc.','Descricao na Moeda 5','Descripcion en Moneda 5','Currency 5 Description','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(214) + Chr(192),'','','','N','','','','','','','','','','','','','','','S','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','08','CT1_CLASSE','C',1,0,'Classe Conta','Clase Cuenta','Accnt.Cat.','Classe da Conta','Clase de la Cuenta','Account Category','@!','Pertence("12").And.Ctb020Prox(.f.).And.Ctb020Var().And.Ctb020LP()',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(131) + Chr(128),'','','','S','','','','','1=Sintetica;2=Analitica','1=Sintetica;2=Analitica','1=Summarized;2=Detailed','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','09','CT1_NORMAL','C',1,0,'Cond Normal','Cond Normal','Regul.Cond.','Condicao Normal','Condicion Normal','Regular Condition','@!','Pertence("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(131) + Chr(128),'','','','S','','','','','1=Devedora;2=Credora','1=Deudora;2=Acreedora','1=Debtor;2=Creditor','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','10','CT1_RES','C',10,0,'Cod Reduzido','Cod Reducido','Reduced Code','Codigo Reduzido','Codigo Reducido','Reduced Code','@!','Ctb020NoRe().and.(Vazio() .or. ExistChav("CT1",,2,"CODRESUM"))',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(146) + Chr(192),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','11','CT1_BLOQ','C',1,0,'Cta Bloq','Cta. Bloq.','Lock.Account','Conta Bloqueada','Cuenta Bloqueada','Locked Account','!','Pertence("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"2"','',1,Chr(130) + Chr(192),'','','','N','','','','','1=Bloqueada;2=Nao Bloqueada','1=Bloqueada;2=No Bloqueada','1=Locked;2=Unlocked','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','12','CT1_DTBLIN','D',8,0,'Dt Ini Bloq','Fch Ini Bloq','Blck.Ini.Dt.','Data Inicio Bloqueio','Fecha Inicio Bloqueo','Blocking Initial Date','99/99/9999','CTB020DTIN()',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(134) + Chr(192),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','13','CT1_DTBLFI','D',8,0,'Dt Fim Bloq','Fch Fin Bloq','Blck.Fin.Dt.','Data Fim Bloqueio','Fecha Fin Bloqueo','Blocking Final Date','99/99/9999','CTB020DTFI()',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(134) + Chr(192),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','14','CT1_DC','C',1,0,'Dig Controle','Dig Control','Cont.Digit','Digito de Controle','Digitac de Control','Control Digit','!','Entre("1","9").And.Ctb020Dc()',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(168),'','',1,Chr(130) + Chr(192),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','15','CT1_NCUSTO','N',2,0,'Dig C. Custo','Dig C. Costo','C.C.No.Dig.','NrDigitos Centro de Custo','Nr.Digit. Centro de Costo','Cost Center Digit Number','@!','Ctb020Cust()',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(134) + Chr(192),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','16','CT1_CC','C',9,0,'Cod CC Cont','Cod. CC Cont','Led.Acc.Code','Codigo CC Contabil','Codigo CC Contable','Ledger Account Code','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(130) + Chr(192),'','','','N','','','','','','','','','','','004','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','17','CT1_CVD02','C',1,0,'Conv M2 Deb','Conv M2 Deb','Deb C2 Conv','Crit Conv Moeda 2 Debito','Crit Conv Moneda 2 Debito','Debit Crncy 2 Conv Crit','@!',"Pertence('123456789A')",Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"1"','',1,Chr(130) + Chr(192),'','','','N','A','R','','','1=Diaria;2=Media;3=Mensal;4=Informada;5=Nao tem Conversao;6=Fixo;7=Mensal Historica;8=Media Historica;9=Vencimento;A=Nao Ajusta','1=Diaria;2=Promedio;3=Mensual;4=Informada;5=No tiene conversion;6=Fijo;7=Mensual Histor.;8=Promedio Histor.;9=Vencim.;A=No ajust','1=Daily;2=Average;3=Monthly;4=Informed;5=No Conversion;6=Fixed;7=HIstory Monthly;8=HIstory Average;9=Expiration;A=Do not Adj','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','18','CT1_CVD03','C',1,0,'Conv M3 Deb','Conv M3 Deb','Deb C3 Conv','Crit Conv Moeda 3 Debito','Crit Conv Moneda 3 Debito','Debit Crncy 3 Conv Crit','!','Pertence("123456789")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"1"','',1,Chr(130) + Chr(192),'','','','N','','','','','1=Diaria;2=Media;3=Mensal;4=Informada;5=Nao tem Conversao;6=Fixo;7=Mensal Historica;8=Media Historica;9=Vencimento','1=Diaria;2=Promedio;3=Mensual;4=Informada;5=No tiene Conversion;6=Fijo;7=Mensual Hist.;8=Promedio Hist.;9=Vencimiento','1=Daily;2=Averg;3=Mthly.;4=Informed;5=No Conversion;6=Fixed;7=Monthly History;8=Average History;9=Due Date','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','19','CT1_CVD04','C',1,0,'Conv M4 Deb','Conv M4 Deb','Deb C4 Conv','Crit Conv Moeda 4 Debito','Crit Conv Moneda 4 Debito','Debit Crncy 4 Conv Crit','!','Pertence("123456789")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"1"','',1,Chr(130) + Chr(192),'','','','N','','','','','1=Diaria;2=Media;3=Mensal;4=Informada;5=Nao tem Conversao;6=Fixo;7=Mensal Historica;8=Media Historica;9=Vencimento','1=Diaria;2=Promedio;3=Mensual;4=Informada;5=No tiene Conversion;6=Fijo;7=Mensual Hist.;8=Promedio Hist.;9=Vencimiento','1=Daily;2=Averg;3=Mthly.;4=Informed;5=No Conversion;6=Fixed;7=Monthly History;8=Average History;9=Due Date','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','20','CT1_CVD05','C',1,0,'Conv M5 Deb','Conv M5 Deb','Deb C5 Conv','Crit Conv Moeda 5 Debito','Crit Conv Moneda 5 Debito','Debit Crncy 5 Conv Crit','!','Pertence("123456789")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"1"','',1,Chr(130) + Chr(192),'','','','N','','','','','1=Diaria;2=Media;3=Mensal;4=Informada;5=Nao tem Conversao;6=Fixo;7=Mensal Historica;8=Media Historica;9=Vencimento','1=Diaria;2=Promedio;3=Mensual;4=Informada;5=No tiene Conversion;6=Fijo;7=Mensual Hist.;8=Promedio Hist.;9=Vencimiento','1=Daily;2=Averg;3=Mthly.;4=Informed;5=No Conversion;6=Fixed;7=Monthly History;8=Average History;9=Due Date','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','21','CT1_CVC02','C',1,0,'Conv M2 Crd','Conv M2 Crd','Crd C2 Conv','Crit Conv Moeda 2 Credito','Crit Conv Moneda 2 Credit','Credit Crncy 2 Conv Crit','!',"Pertence('123456789A')",Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"1"','',1,Chr(130) + Chr(192),'','','','N','A','R','','','1=Diaria;2=Media;3=Mensal;4=Informada;5=Nao tem Conversao;6=Fixo;7=Mensal Historica;8=Media Historica;9=Vencimento;A=Nao Ajusta','1=Diaria;2=Promedio;3=Mensual;4=Informada;5=No tiene conversion;6=Fijo;7=Mensual Histor.;8=Promedio Histor.;9=Vencim.;A=No ajust','1=Daily;2=Average;3=Monthly;4=Informed;5=No Conversion;6=Fixed;7=HIstory Monthly;8=HIstory Average;9=Expiration;A=Do not Adj','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','22','CT1_CVC03','C',1,0,'Conv M3 Crd','Conv M3 Crd','Crd C3 Conv','Crit Conv Moeda 3 Credito','Crit Conv Moneda 3 Credit','Credit Crncy 3 Conv Crit','!','Pertence("123456789")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"1"','',1,Chr(130) + Chr(192),'','','','N','','','','','1=Diaria;2=Media;3=Mensal;4=Informada;5=Nao tem Conversao;6=Fixo;7=Mensal Historica;8=Media Historica;9=Vencimento','1=Diaria;2=Promedio;3=Mensual;4=Informada;5=No tiene Conversion;6=Fijo;7=Mensual Hist.;8=Promedio Hist.;9=Vencimiento','1=Daily;2=Averg;3=Mthly.;4=Informed;5=No Conversion;6=Fixed;7=Monthly History;8=Average History;9=Due Date','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','23','CT1_CVC04','C',1,0,'Conv M4 Crd','Conv M4 Crd','Crd C4 Conv','Crit Conv Moeda 4 Credito','Crit Conv Moneda 4 Credit','Credit Crncy 4 Conv Crit','!','Pertence("123456789")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"1"','',1,Chr(130) + Chr(192),'','','','N','','','','','1=Diaria;2=Media;3=Mensal;4=Informada;5=Nao tem Conversao;6=Fixo;7=Mensal Historica;8=Media Historica;9=Vencimento','1=Diaria;2=Promedio;3=Mensual;4=Informada;5=No tiene Conversion;6=Fijo;7=Mensual Hist.;8=Promedio Hist.;9=Vencimiento','1=Daily;2=Averg;3=Mthly.;4=Informed;5=No Conversion;6=Fixed;7=Monthly History;8=Average History;9=Due Date','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','24','CT1_CVC05','C',1,0,'Conv M5 Crd','Conv M5 Crd','Crd C5 Conv','Crit Conv Moeda 5 Credito','Crit Conv Moneda 5 Credit','Credit Crncy 5 Conv Crit','!','Pertence("123456789")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"1"','',1,Chr(130) + Chr(192),'','','','N','','','','','1=Diaria;2=Media;3=Mensal;4=Informada;5=Nao tem Conversao;6=Fixo;7=Mensal Historica;8=Media Historica;9=Vencimento','1=Diaria;2=Promedio;3=Mensual;4=Informada;5=No tiene Conversion;6=Fijo;7=Mensual Hist.;8=Promedio Hist.;9=Vencimiento','1=Daily;2=Averg;3=Mthly.;4=Informed;5=No Conversion;6=Fixed;7=Monthly History;8=Average History;9=Due Date','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','25','CT1_CTASUP','C',20,0,'Cta Superior','Cta. Superio','Superior Acc','Conta Superior','Cuenta Superior','Superior Account','@!','ValCtaSup(M->CT1_CTASUP,M->CT1_CONTA)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CT1',1,Chr(130) + Chr(128),'','','','N','','','','','','','','','','','003','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','26','CT1_HP','C',3,0,'Hist Padrao','Hist Estand.','Stand.Hist.','Historico Padrao','Historial Estandar','Standard History','@!','Vazio().Or.ExistCpo("CT8",,1)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CT8',1,Chr(198) + Chr(192),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','27','CT1_ACITEM','C',1,0,'Aceita Item','+Acept Item?','Accept Item?','Aceita Item no Lcto Cont?','+Acepta Item  Asto.Cont.?','Accep.Item in Acc. Entry?','!','Pertence("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"1"','',1,Chr(134) + Chr(192),'','','','N','','','','','1=Sim;2=Nao','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','28','CT1_ACCUST','C',1,0,'Aceita CC','+Acepta CC ?','Accept CC','Aceita CC no Lcto Cont?','+Acepta CC en Asto.Cont.?','Accep. CC in Acc. Entry','!','Pertence("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"1"','',1,Chr(134) + Chr(192),'','','','N','','','','','1=Sim;2=Nao','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','29','CT1_ACCLVL','C',1,0,'Aceita CLVL','+Acept CLVL?','Accept VlCl?','Aceita Cl Vl no Lcto ?','+Acepta Cl Vl en Asto.  ?','Accep.Val.Clas.in Entry','!','Pertence("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"1"','',1,Chr(134) + Chr(192),'','','','N','','','','','1=Sim;2=Nao','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','30','CT1_DTEXIS','D',8,0,'Dt Ini Exist','Fch Ini Exis','Exst.Ini.Dt.','Data Inicio Existencia','Fecha Inicio Existencia','Existence Initial Date','99/99/9999','CTB20DEXIN()',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'CTOD("01/01/80")','',1,Chr(128) + Chr(128),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','31','CT1_DTEXSF','D',8,0,'Dt Fim Exist','Fch Fin Exis','Fin.Exist.Dt','Data Final de Existencia','Fecha Final de Existencia','Final Existence Date','','CTB20DEXFI()',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(134) + Chr(65),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','32','CT1_CTAVM','C',20,0,'Var Monet','Var Monet','Monet.Var.','Conta Var Monetaria','Cuenta Var Monetaria','Monetary Variat. Account','@!','Vazio().Or.ValidaConta(M->CT1_CTAVM)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'GetMv("MV_CTAVM")','CT1',1,Chr(198) + Chr(192),'','','','N','','','','','','','','','','','003','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','33','CT1_CTARED','C',20,0,'Red Variacao','Red Variac.','Variat.Red.','Conta Redutora Var Monet','Cuenta Reductor.Var Monet','Monet.Var. Reduc.Account','@!','Vazio().Or.ValidaConta(M->CT1_CTARED)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CT1',1,Chr(198) + Chr(192),'','','','N','','','','','','','','','','','003','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','34','CT1_CTALP','C',20,0,'Lucr/Perd','Gananc/Perd','Profit/Loss','Conta Lucros/Perdas','Cuenta Ganancias/Perdidas','Profit/Loss Account','@!',"Vazio() .Or. ValidaConta(M->CT1_CTALP) .Or. (M->CT1_CTALP = '*')",Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CT1',1,Chr(198) + Chr(192),'','','','N','','','','','','','','','','','003','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','35','CT1_CTAPON','C',20,0,'Ponte LP','Puente LP','P/L Bridge','Conta Ponte Lucros/Perdas','Cuenta Puente Gananc/Perd','Profit/Loss Bridge Accoun','@!',"Vazio() .Or. ValidaConta(M->CT1_CTAPON) .Or. (M->CT1_CTAPON = '*')",Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CT1',1,Chr(198) + Chr(192),'','','','N','','','','','','','','','','','003','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','36','CT1_BOOK','C',20,0,'Conf. Livros','Conf. Libros','T.Rec.Conf.','Configuracao de Livros','Configuracion de Libros','Tax Records Config.','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(150) + Chr(192),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','37','CT1_GRUPO','C',8,0,'Grupo','Grupo','Group','Grupo Contabil','Grupo Contable','Accounting Group','@!','Vazio() .Or. ExistCpo("CTR",,1)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CTR',1,Chr(130) + Chr(192),'','','','S','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','38','CT1_AGLSLD','C',1,0,'Aglut.Saldo','+Aglut.Sdo.?','Group Bal. ?','Aglutina Saldos         ?','+Aglomera Saldos        ?','Group Balances','!','Pertence("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'"2"','',1,Chr(130) + Chr(192),'','','','N','','','','','1=Sim;2=Nao','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','39','CT1_RGNV1','C',12,0,'Regra Nivel1','Regl.Nivel 1','Level 1 Rule','Regra de Ligacao Nivel 1','Regla de Vinculo Nivel 1','Level 1 Linking Rule','@!','Vazio() .Or. CtbValLig(M->CT1_CLASSE)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(150) + Chr(192),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','40','CT1_RGNV2','C',12,0,'Regra Nivel2','Regl.Nivel 2','Level 2 Rule','Regra de Ligacao Nivel 2','Regla de Vinculo Nivel 2','Level 2 Linking Rule','@!','Vazio() .Or.  CtbValLig(M->CT1_CLASSE)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(150) + Chr(192),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','41','CT1_RGNV3','C',12,0,'Regra Nivel3','Regl.Nivel 3','Level 3 Rule','Regra de Ligacao Nivel 3','Regla de Vinculo Nivel 3','Level 3 Linking Rule','@!','Vazio() .Or. CtbValLig(M->CT1_CLASSE)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(150) + Chr(192),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','42','CT1_CCOBRG','C',1,0,'CC Obrigat.','+CC Oblig. ?','Mand.CC.','CC Obrigatorio Lcto Cont?','+CC Oblig. en Asto.Cont.?','Accnt.Entry Mand.CC.','!','Pertence("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"2"','',1,Chr(134) + Chr(192),'','','','N','','','','','1=Sim;2=Nao','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','43','CT1_ITOBRG','C',1,0,'Item Obrig.','+Item Obl. ?','Item Comp. ?','Item Obrig. Lcto Cont?','+Item Oblig. Asto.Cont.?','Compulsory Item Ac.Entry?','!','Pertence("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"2"','',1,Chr(134) + Chr(192),'','','','N','','','','','1=Sim;2=Nao','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','44','CT1_CLOBRG','C',1,0,'CLVL Obrig.','+CLVL Obl. ?','M.Vl.Cl.Ent.','Cl Vl Obrigatorio Lcto ?','+Cl Vl Oblig. en Asto.?','Mandat.Value Class Entry','!','Pertence("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"2"','',1,Chr(134) + Chr(192),'','','','N','','','','','1=Sim;2=Nao','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','45','CT1_TRNSEF','C',20,0,'Ajuste Conv','Ajuste Conv','Conv. Adj.','Conta de Ajuste da Conver','Cuenta de Ajuste de Conv.','Conv. Adjust. Account','@!','Vazio() .Or.  ValidaConta(M->CT1_TRNSEF)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CT1',1,Chr(150) + Chr(192),'','','','N','','','','','','','','','','','003','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','46','CT1_AGLUT','C',1,0,'Aglutina','Aglomera','Group','Aglutina','Aglomera','Group','!','Vazio() .Or. Pertence("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(134) + Chr(192),'','','','N','','','','','1=Sim; 2=Nao','1=Si; 2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','47','CT1_LALUR','C',1,0,'Tipo Lalur','Tipo Lalur','Lalur Type','Tipo de Conta Lalur','Tipo de Cuenta Lalur','Lalur Account Type','!','Pertence(" 012345")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"0"','',1,Chr(214) + Chr(192),'','','','N','','R','','','0=Nao pertence;1=Adicao dedutivel;2=Adicao Indedutivel;3=Exclusao Dedutivel;4=Exclusao Indedutivel;5=Lucro Liq. antes da C.S.','0=No pertenece;1=Suma deductible;2=Suma Indeductible;3=Exclusión Deductible;4=Exclusión Indeductible;5=Gananc.Liq. antes de C.S','0=Not Belong;1=Deductible Addition;2=NonDeductible Addition;3=Deductible Deletion;4=NonDeductible Deletion;5=NetProfit before CS','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','48','CT1_CTLALU','C',20,0,'Conta Lalur','Cuenta Lalur','LalurAccount','Conta Lalur','Cuenta Lalur','Lalur Account','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CT1',1,Chr(150) + Chr(192),'','','','N','','','','','','','','','','','003','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','49','CT1_TPLALU','C',2,0,'Class.Lalur','Clas.Lalur','Lalur Class.','Classificação no Lalur','Clasificación en el Lalur','Classification in Lalur','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','LL',1,Chr(214) + Chr(192),'','','','N','','R','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','50','CT1_LALHIR','C',1,0,'Hist.Lalur ?','¿Hist.Lalur?','LalurHistry?','Historico no Lalur ?','¿Historial en el Lalur?','History in Lalur?','@9','Pertence("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"2"','',1,Chr(214) + Chr(192),'','','','','','R','','','1=Sim;2=Não','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','51','CT1_RATEIO','C',6,0,'Cod. Rateio','Cod.Prorrat.','Prorat. Code','Codigo de Rateio','Codigo de Prorrateo','Proration Code','@!','Vazio() .Or. ExistCpo("CT9")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CT9',1,Chr(132) + Chr(128),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','52','CT1_ESTOUR','C',1,0,'Conta Estour','Cuenta Exced','Revers. Act.','Conta Estourada','Cuenta Excedida','Reversed Account','@!','Pertence(" 12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(128) + Chr(128),'','','','N','','','','','1=Sim;2=Nao','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','53','CT1_CODIMP','C',20,0,'Cod Impress','Cod Impres','Print. Code','Codigo de Impressao','Codigo de Impresion','Printing Code','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(198) + Chr(192),'','','','','','','','','','','','','','','003','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','54','CT1_AJ_INF','C',1,0,'Ajusta Inf?','Ajusta Inf','InflationAdj','Ajusta por inflacao','Ajusta por Inflacion','Inflation Adjustment','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(134) + Chr(192),'','','','N','A','R','',"PERTENCE('12')",'1=Sim;2=Nao','1=Si;2=No','1=Yes;2=No','',"M->CT1_CLASSE=='2'",'','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','55','CT1_NATCTA','C',2,0,'Nat. Conta','Mod. Cuenta','Account Char','Natureza da conta Contabi','Modalidad Cuenta Contable','Ledger Account Character','@!',"Pertence('01,02,03,04,05,09')",Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(132) + Chr(192),'','','','N','A','R','','','01=Conta de Ativo;02=Conta de Passivo;03=Patrimônio Líquido;04=Conta de Resultado;05=Conta de Compensação;09=Outras','01=Cuenta de Activo;02=Cuenta de Pasivo;03=Patrimonio Neto;04=Cuenta de Resultado;05=Cuenta de Compensacion;09=Otras','01=Assets Acc.;02=Liabilities Acc.;03=Net Equity;04=Retained Earnings;05=Revaluation Reserve;09=Others','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','56','CT1_ACATIV','C',1,0,'Ac.Outra At?','¿Ac.Otra Ac?','Acc Oth Act?','Aceita Outra Atividade?','¿Acepta Otra Actividad?','Accept Other Activity?','@!',"pertence('12')",Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),"'2'",'',1,Chr(198) + Chr(192),'','','','N','A','R','','','1=Sim;2=Nao','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','57','CT1_ATOBRG','C',1,0,'Outr.At.Ob?','¿Otr.Act.Ob?','Ot Comp Act?','Outra ativ. obrigatoria?','¿Otra activ. obligatoria?','Other compuls. acti.?','@!',"pertence('12')",Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),"'2'",'',1,Chr(198) + Chr(192),'','','','N','A','R','','','1=Sim;2=Nao','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','58','CT1_ACET05','C',1,0,'Aceita Ent05','Acepta Ent05','Accept Ent05','Aceita entidade 05?','Acepta ente 05?','Accept Entity 05?','@!',"Pertence('12')",Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),"'2'",'',1,Chr(134) + Chr(192),'','','S','N','A','R','','','1=Sim;2=Nao','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','59','CT1_05OBRG','C',1,0,'Obrg.Ent.05?','Oblig.Ent.05','Mand.Ent.05?','Obrigatória entidade 05?','Obligatória ente 05?','Mandatory Entity 05?','@!',"Pertence('12')",Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),"'2'",'',1,Chr(134) + Chr(192),'','','S','N','A','R','','','1=Sim;2=Nao','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','60','CT1_INDNAT','C',1,0,'Class. Manad','Clas. Manad','Manad Class.','Class. Manad','Clas. Manad','Manad Class.','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(198) + Chr(192),'','','','','','','','','1=Ativo; 2=Passivo; 3=Patrimônio Líquido; 4=Despesa/Custo; 5=Receita; 9=Outros','1=Activo; 2=Pasivo; 3=Patrimonio Neto; 4=Gasto/Costo; 5=Ingreso; 9=Otros','1=Assets; 2=Liabilities; 3=Net Equity; 4=Expense/Cost; 5=Income; 9=Others','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','61','CT1_SPEDST','C',1,0,'SPED Sint.','SPED Sint.','Sint. SPED','SPED Sint.','SPED Sint.','Sint. SPED','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(254) + Chr(192),'','','','N','A','R','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','62','CT1_NTSPED','C',2,0,'Nat Cta SPED','Mod Cta SPED','SPED AcctCla','Natureza conta para SPED','Modalidad ccuenta p SPED','SPED Account Class','@!',"Pertence('01,02,03,04,05,09')",Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(150) + Chr(192),'','','','S','','','','','01=Conta de Ativo;02=Conta de Passivo;03=Patrimônio Líquido;04=Conta de Resultado;05=Conta de Compensação;09=Outras','01=Cuenta de Activo;02=Cuenta de Pasivo;03=Patrimonio Neto;04=Cuenta de Resultado;05=Cuenta de Compensacion;09=Otras','01=Asset Account;02=Liability Account;03=Net Equity;04=Statement Account;05=Clearing Account;09=Others','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','63','CT1_ACAT01','C',1,0,'Ativ.01 Ac.','Activ.01 Ac.','Acc.Activ.01','Aceita Atividade 01','Acepta Actividad 01','Accept Activity 01','@!','PERTENCE("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(198) + Chr(192),'','','','N','A','R','','','1=Sim;2=Não','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','64','CT1_AT01OB','C',1,0,'Ativ.01 Ob.','Activ.01 Ob.','Req.Activ.01','Obrigatório Ativ.01','Obligatorio Activ.01','Required Activ.01','@!','PERTENCE("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(198) + Chr(192),'','','','N','A','R','','','1=Sim;2=Não','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','65','CT1_ACAT02','C',1,0,'Ativ.02 Ac.','Activ.02 Ac.','Acc.Activ.02','Aceita Atividade 02','Acepta Actividad 02','Accept Activity 02','@!','PERTENCE("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(198) + Chr(192),'','','','N','A','R','','','1=Sim;2=Não','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','66','CT1_AT02OB','C',1,0,'Ativ.02 Ob.','Activ.02 Ob.','Req.Activ.02','Obrigatório Ativ.02','Obligatorio Activ.02','Required Activ.02','@!','PERTENCE("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(198) + Chr(192),'','','','N','A','R','','','1=Sim;2=Não','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','67','CT1_ACAT03','C',1,0,'Ativ.03 Ac.','Activ.03 Ac.','Acc.Activ.03','Aceita Atividade 03','Acepta Actividad 03','Accept Activity 03','@!','PERTENCE("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(198) + Chr(192),'','','','N','A','R','','','1=Sim;2=Não','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','68','CT1_AT03OB','C',1,0,'Ativ.03 Ob.','Activ.03 Ob.','Req.Activ.03','Obrigatório Ativ.03','Obligatorio Activ.03','Required Activ.03','@!','PERTENCE("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(198) + Chr(192),'','','','N','A','R','','','1=Sim;2=Não','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','69','CT1_ACAT04','C',1,0,'Ativ.04 Ac.','Activ.04 Ac.','Acc.Activ.04','Aceita Atividade 04','Acepta Actividad 04','Accept Activity 04','@!','PERTENCE("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(198) + Chr(192),'','','','N','A','R','','','1=Sim;2=Não','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','70','CT1_AT04OB','C',1,0,'Ativ.04 Ob.','Activ.04 Ob.','Req.Activ.04','Obrigatório Ativ.04','Obligatorio Activ.04','Required Activ.04','@!','PERTENCE("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(198) + Chr(192),'','','','N','A','R','','','1=Sim;2=Não','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','71','CT1_TPO01','C',2,0,'Tipo Ctb 01','Tipo Ctb 01','Ctb Type 01','Tipo Ctb 01','Tipo Ctb 01','Ctb Type 01','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(222) + Chr(192),'','','','','V','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','72','CT1_TPO02','C',2,0,'Tipo Ctb 02','Tipo Ctb 02','Ctb Type 02','Tipo Ctb 02','Tipo Ctb 02','Ctb Type 02','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(222) + Chr(192),'','','','','V','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','73','CT1_TPO03','C',2,0,'Tipo Ctb 03','Tipo Ctb 03','Ctb Type 03','Tipo Ctb 03','Tipo Ctb 03','Ctb Type 03','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(222) + Chr(192),'','','','','V','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','74','CT1_TPO04','C',2,0,'Tipo Ctb 04','Tipo Ctb 04','Ctb Type 04','Tipo Ctb 04','Tipo Ctb 04','Ctb Type 04','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(222) + Chr(192),'','','','','V','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CT1','75','CT1_INTP','C',1,0,'Int. PIMS','Int. PIMS','PIMS Int.','Integraçao com o PIMS','Integracion con PMIS','Integration with PIMS','@!',"Pertence('12')",Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),"'1'",'',1,Chr(132) + Chr(128),'','','','N','A','R','','','1=Sim;2=Não','1=Si;2=No','1=Yes;2=No','','','','','','','','N','','','1','N','','S'} )
aAdd( aSX3, {'CT1','76','CT1_XENVWS','C',1,0,'Enviado EAI?','Enviado EAI?','Enviado EAI?','Enviado EAI','Enviado EAI','Enviado EAI','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"1"','',0,Chr(254) + Chr(192),'','','U','N','V','R','','','1=Nao;2=Sim','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'CT1','77','CT1_XNIVEL','C',1,0,'Nivel Conta','Nivel Conta','Nivel Conta','Nivel da Conta','Nivel da Conta','Nivel da Conta','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','€','','','','','','','','','','','','','N','','','N','',''} )
aAdd( aSX3, {'CT1','78','CT1_XATPDR','C',9,0,'At. Pad. Con','At. Pad. Con','At. Pad. Con','Ativid. Padrao para Conta','Ativid. Padrao para Conta','Ativid. Padrao para Conta','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CTH',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','',''} )
aAdd( aSX3, {'CT1','79','CT1_XATBLQ','C',9,0,'At. Bloq.Cta','At. Bloq.Cta','At. Bloq.Cta','Ativ. Bloqueada para Cta','Ativ. Bloqueada para Cta','Ativ. Bloqueada para Cta','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CTH',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','',''} )
aAdd( aSX3, {'CT1','80','CT1_XCCPDR','C',9,0,'CC Pad. Cta','CC Pad. Cta','CC Pad. Cta','CC Padrao para Conta','CC Padrao para Conta','CC Padrao para Conta','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CTT',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','',''} )
aAdd( aSX3, {'CT1','81','CT1_XRATEI','C',1,0,'Trat. Rat. G','Trat. Rat. G','Trat. Rat. G','Trat. Espec. Rateio Geral','Trat. Espec. Rateio Geral','Trat. Espec. Rateio Geral','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','N= Nao faz Rateio;T=Transf.Atv.Espec;S=Sem Trat. Espec.','','','','','','','','','','','N','','','N','',''} )
aAdd( aSX3, {'CT1','82','CT1_XATFRA','C',9,0,'At. Fixa Trf','At. Fixa Trf','At. Fixa Trf','Atividade Fixa de Transf.','Atividade Fixa de Transf.','Atividade Fixa de Transf.','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CTH',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','',''} )
aAdd( aSX3, {'CT1','83','CT1_XMARGE','C',1,0,'Cta.En.Marge','Cta.En.Marge','Cta.En.Marge','Conta Entra na Margem','Conta Entra na Margem','Conta Entra na Margem','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','N=Nao Tratar na Margem;S=Sem Tratamento Especial','','','','','','','','','','','N','','','N','',''} )
aAdd( aSX3, {'CT1','84','CT1_XREDUZ','C',10,0,'Cta Red.CIEE','Cta Red.CIEE','Cta Red.CIEE','Conta Reduzida CIEE','Conta Reduzida CIEE','Conta Reduzida CIEE','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','',''} )
aAdd( aSX3, {'CTD','01','CTD_FILIAL','C',4,0,'Filial','Sucursal','Branch','Filial do Sistema','Sucursal del Sistema','System Branch','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(128) + Chr(128),'','','','N','','','','','','','','','','','033','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTD','02','CTD_ITEM','C',9,0,'Item Conta','Item Contab.','Acctn.Item','Item Contabil','Item Contable','Accounting Item','@!','Ctb040Item()',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(176),'','',1,Chr(131) + Chr(128),'','','','S','','','','','','','','','','','005','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTD','03','CTD_CLASSE','C',1,0,'Classe','Clase','Class','Classe','Clase','Class','@!','Pertence("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"2"','',1,Chr(131) + Chr(128),'','','','S','','','','','1=Sintetico;2=Analitico','1=Sintetico;2=Analitico','1=Summarized;2=Detailed','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTD','04','CTD_NORMAL','C',1,0,'Cond Normal','Cond Normal','Regul.Cond.','Condicao Normal','Condicion Normal','Regular Condition','@!','Pertence("012")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(134) + Chr(128),'','','','S','','','','','0=Nenhum;1=Despesa;2=Receita','0=Ninguno;1=Gasto;2=Ingreso','0=None;1=Expense;2=Revenue','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTD','05','CTD_DESC01','C',40,0,'Desc Moeda 1','Desc Moned 1','Curr.1 Desc.','Descricao na Moeda 1','Descripcion en Moneda 1','Currency 1 Description','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(147) + Chr(128),'','','','S','','','','','','','','','','','','','','','S','N','','1','N','','S'} )
aAdd( aSX3, {'CTD','06','CTD_DESC02','C',40,0,'Desc Moeda 2','Desc Moned 2','Curr.2 Desc.','Descricao na Moeda 2','Descripcion en Moneda 2','Currency 2 Description','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(146) + Chr(192),'','','','N','','','','','','','','','','','','','','','S','N','','1','N','','S'} )
aAdd( aSX3, {'CTD','07','CTD_DESC03','C',40,0,'Desc Moeda 3','Desc Moned 3','Curr.3 Desc.','Descricao na Moeda 3','Descripcion en Moneda 3','Currency 3 Description','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(146) + Chr(192),'','','','N','','','','','','','','','','','','','','','S','N','','1','N','','S'} )
aAdd( aSX3, {'CTD','08','CTD_DESC04','C',40,0,'Desc Moeda 4','Desc Moned 4','Curr.4 Desc.','Descricao na Moeda 4','Descripcion en Moneda 4','Currency 4 Description','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(146) + Chr(192),'','','','N','','','','','','','','','','','','','','','S','N','','1','N','','S'} )
aAdd( aSX3, {'CTD','09','CTD_DESC05','C',40,0,'Desc Moeda 5','Desc Moned 5','Curr.5 Desc.','Descricao na Moeda 5','Descripcion en Moneda 5','Currency 5 Description','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(146) + Chr(192),'','','','N','','','','','','','','','','','','','','','S','N','','1','N','','S'} )
aAdd( aSX3, {'CTD','10','CTD_BLOQ','C',1,0,'Item Bloq','Item Bloq.','Locked Item','Item Bloqueado','Item Bloqueado','Locked Item','!','Pertence("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"2"','',1,Chr(130) + Chr(192),'','','','N','','','','','1=Bloqueado;2=Nao Bloqueado','1=Bloqueado;2=No Bloqueado','1=Locked;2=Unlocked','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTD','11','CTD_DTBLIN','D',8,0,'Dt Ini Bloq','Fch Ini Bloq','Lock.Ini.Dt.','Data Inicio Bloqueio','Fecha Inicio Bloqueo','Lockage Initial Date','99/99/9999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(130) + Chr(192),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTD','12','CTD_DTBLFI','D',8,0,'Dt Fim Bloq','Fch Fin Bloq','Lock.Fin.Dt.','Data Final Bloqueio','Fecha Final Bloqueo','Lockage Final Date','99/99/9999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(130) + Chr(192),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTD','13','CTD_DTEXIS','D',8,0,'Dt Ini Exist','Fch Ini Exis','Exst.Ini.Dt.','Data Inicio Existencia','Fecha Inicio Existencia','Existence Initial Date','99/99/9999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'CTOD("01/01/80")','',1,Chr(130) + Chr(192),'','','','S','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTD','14','CTD_DTEXSF','D',8,0,'Dt Fim Exist','Fch Fin Exis','Fin.Exist.Dt','Data Final de Existencia','Fecha final de Existencia','Final Existence Date','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(134) + Chr(65),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTD','15','CTD_ITLP','C',9,0,'Item L/P','Item L/P','P/L Item','Item Lucros/Perdas','Item Ganancias/Perdidas','Gains/Losses Items','@!','Vazio() .Or. ValidItem(M->CTD_ITLP) .Or. (M->CTD_ITLP = "*")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'M->CTD_ITEM','CTD',1,Chr(130) + Chr(192),'','','','N','','','','','','','','','','','005','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTD','16','CTD_ITPON','C',9,0,'Item Ponte','Item Puente','Bdg.Item','Item Ponte Lucros/Perdas','Item Puente Gananc./Perd.','Profit/Loss Bridge Item','@!','Vazio() .Or. ValidItem(M->CTD_ITPON) .Or. (M->CTD_ITPON = "*")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CTD',1,Chr(130) + Chr(192),'','','','N','','','','','','','','','','','005','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTD','17','CTD_BOOK','C',20,0,'Conf. Livros','Conf. Libros','T.Rec.Conf.','Configuracao de Livros','Configuracion de Libros','Tax Records Configuration','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(150) + Chr(192),'','','','S','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTD','18','CTD_ITSUP','C',9,0,'Item Superi','Item Super.','Super.Item','Item Superior','Item Superior','Superior Item','@!','Vazio() .Or. ExistCpo("CTD",,1) .AND. ValEntSup(M->CTD_ITSUP,"CTD",M->CTD_ITEM)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CTD',1,Chr(130) + Chr(192),'','','','N','','','','','','','','','','','005','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTD','19','CTD_RES','C',10,0,'Cod Red.Item','Cod.Red.Item','Item Red.Cd.','Codigo Red. Item Contabil','Codigo Red. Item Contable','Accounting Item Red. Code','@!','Ctb040NoRe().and.(Vazio() .or. ExistChav("CTD",,3,"CODRESUM"))',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(146) + Chr(192),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTD','20','CTD_CRGNV1','C',12,0,'Cnt Reg Niv1','Cnt Reg Niv1','Cntrl.Lev.1','Contra Regra Nivel 1','Contrarregla Nivel 1','Counterrule 1','@!','Vazio() .Or. CtbValLig(M->CTD_CLASSE)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(150) + Chr(192),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTD','21','CTD_CRGNV2','C',12,0,'Cnt Reg Niv2','Cnt Reg Niv2','Cntrl.Lev.2','Contra Regra Nivel 2','Contrarregla Nivel 2','Counterrule 2','@!','Vazio() .Or. CtbValLig(M->CTD_CLASSE)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(150) + Chr(192),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTD','22','CTD_RGNV3','C',12,0,'Regra Nivel3','Regla Nivel3','Level 3 Rule','Regra Nivel 3','Regla Nivel 3','Level 3 Rule','@!','Vazio() .Or. CtbValLig(M->CTD_CLASSE)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(150) + Chr(192),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTD','23','CTD_CLOBRG','C',1,0,'Cl.Vlr Obrig','Cl.Vlr Oblig','Mand.Vl.Cat.','Classe de Valor Obrigat.','Clase de Valor Obligat.','Mandatory Value Category','','Pertence("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"2"','',1,Chr(132) + Chr(128),'','','','','','','','','1=Sim;2=Näo','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTD','24','CTD_ACCLVL','C',1,0,'Ac.Cl.Valor','Ac.Cl.Valor','Accp.Vl.Cat.','Aceita Classe de Valor','Aceta Clase de Valor','Accept Value Category','','Pertence("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"1"','',1,Chr(132) + Chr(128),'','','','','','','','','1=Sim;2=Näo','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTD','25','CTD_ITVM','C',9,0,'It.Var.Monet','It.Var.Monet','Index.Item','Item de Var. Monetaria','Item de Var. Monetaria','Indexation Item','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CTD',1,Chr(214) + Chr(65),'','','','','','','','','','','','','','','005','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTD','26','CTD_ITRED','C',9,0,'It.Red.V.Mon','It.Red.V.Mon','Index.Red.It','Item Redutor Var.Monet.','Item Reductor Var.Monet.','Indexation Red.Item','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CTD',1,Chr(214) + Chr(65),'','','','','','','','','','','','','','','005','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTD','27','CTD_ACATIV','C',1,0,'Ac.Outra At?','¿Ac.Otr.Act?','Ac.Oth. Act?','Aceita Outra Atividade?','¿Acepta otra actividad?','Accept Another Activity?','@!','PERTENCE("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(198) + Chr(192),'','','','N','A','R','','','1=Sim;2=Não','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTD','28','CTD_ATOBRG','C',1,0,'Outr.At.Ob?','¿Otr.Act.Ob?','Oth.Man.Act?','Outra ativ. obrigatoria?','¿Otra activ. obligatoria?','Other mandatory activity?','@!','PERTENCE("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(198) + Chr(192),'','','','N','A','R','','','1=Sim;2=Não','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTD','29','CTD_ACAT01','C',1,0,'Ativ.01 Ac.','Activ.01 Ac.','Activ.01 Ac.','Aceita Atividade 01','Acepta Actividad 01','Accept Activity 01','@!','PERTENCE("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(198) + Chr(192),'','','','N','A','R','','','1=Sim;2=Não','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTD','30','CTD_AT01OB','C',1,0,'Ativ.01 Ob.','Activ.01 Ob.','Activ.01 Mn.','Obrigatório Ativ.01','Obligatorio Activ.01','Mandatory Activ.01','@!','PERTENCE("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(198) + Chr(192),'','','','N','A','R','','','1=Sim;2=Não','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTD','31','CTD_ACAT02','C',1,0,'Ativ.02 Ac.','Activ.02 Ac.','Activ.02 Ac.','Aceita Atividade 02','Acepta Actividad 02','Accept Activity 02','@!','PERTENCE("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(198) + Chr(192),'','','','N','A','R','','','1=Sim;2=Não','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTD','32','CTD_AT02OB','C',1,0,'Ativ.02 Ob.','Activ.02 Ob.','Activ.02 Mn.','Obrigatório Ativ.02','Obligatorio Activ.02','Mandatory Activ.02','@!','PERTENCE("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(198) + Chr(192),'','','','N','A','R','','','1=Sim;2=Não','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTD','33','CTD_ACAT03','C',1,0,'Ativ.03 Ac.','Activ.03 Ac.','Activ.03 Ac.','Aceita Atividade 03','Acepta Actividad 03','Accept Activity 03','@!','PERTENCE("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(198) + Chr(192),'','','','N','A','R','','','1=Sim;2=Não','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTD','34','CTD_AT03OB','C',1,0,'Ativ.03 Ob.','Activ.03 Ob.','Activ.03 Mn.','Obrigatório Ativ.03','Obligatorio Activ.03','Mandatory Activ.03','@!','PERTENCE("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(198) + Chr(192),'','','','N','A','R','','','1=Sim;2=Não','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTD','35','CTD_ACAT04','C',1,0,'Ativ.04 Ac.','Activ.04 Ac.','Activ.04 Ac.','Aceita Atividade 04','Acepta Actividad 04','Accept Activity 04','@!','PERTENCE("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(212) + Chr(192),'','','','N','A','R','','','1=Sim;2=Não','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTD','36','CTD_AT04OB','C',1,0,'Ativ.04 Ob.','Activ.04 Ob.','Activ.04 Mn.','Obrigatório Ativ.04','Obligatorio Activ.04','Mandatory Activ.04','@!','PERTENCE("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(212) + Chr(192),'','','','N','A','R','','','1=Sim;2=Não','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTD','37','CTD_TPO04','C',2,0,'Tipo Ctb 04','Tipo Ctb. 04','Ctb Type 04','Tipo Ctb 04','Tipo Ctb. 04','Ctb Type 04','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(222) + Chr(192),'','','','','V','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTD','38','CTD_TPO03','C',2,0,'Tipo Ctb 03','Tipo Ctb. 03','Ctb Type 03','Tipo Ctb 03','Tipo Ctb. 03','Ctb Type 03','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(222) + Chr(192),'','','','','V','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTD','39','CTD_TPO02','C',2,0,'Tipo Ctb 02','Tipo Ctb. 02','Ctb Type 02','Tipo Ctb 02','Tipo Ctb. 02','Ctb Type 02','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(222) + Chr(192),'','','','','V','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTD','40','CTD_TPO01','C',2,0,'Tipo Ctb 01','Tipo Ctb. 01','Ctb Type 01','Tipo Ctb 01','Tipo Ctb. 01','Ctb Type 01','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(222) + Chr(192),'','','','','V','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTD','41','CTD_XTPUNI','C',1,0,'Tipo de Unid','Tipo de Unid','Tipo de Unid','Tipo de Unidade','Tipo de Unidade','Tipo de Unidade','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','€','','O=Operacional;G=Gerencial=I=Superintendencia;S=Sede','','','','','','','','','','','N','','','N','',''} )
aAdd( aSX3, {'CTD','42','CTD_XGERUN','C',3,0,'Sigla da Ger','Sigla da Ger','Sigla da Ger','Sigla da Gerencia','Sigla da Gerencia','Sigla da Gerencia','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','',''} )
aAdd( aSX3, {'CTD','43','CTD_XSPUNI','C',8,0,'Sigla de Sup','Sigla de Sup','Sigla de Sup','Sigla de Superintendencia','Sigla de Superintendencia','Sigla de Superintendencia','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','€','','','','','','','','','','','','','N','','','N','',''} )
aAdd( aSX3, {'CTH','01','CTH_FILIAL','C',4,0,'Filial','Sucursal','Branch','Filial do Sistema','Sucursal del Sistema','System Branch','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(128) + Chr(128),'','','','N','','','','','','','','','','','033','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTH','02','CTH_CLVL','C',9,0,'Cod Cl Val','Cod.Cl Valor','Vl.Cat.Code','Codigo Classe de Valor','Codigo Clase de Valor','Value Cat.Code','@!','Ctb040ClVl()',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(176),'','',1,Chr(131) + Chr(128),'','','','S','','','','','','','','','','','006','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTH','03','CTH_CLASSE','C',1,0,'Classe','Clase','Class','Classe','Clase','Class','@!','Pertence("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"2"','',1,Chr(131) + Chr(128),'','','','S','','','','','1=Sintetico;2=Analitico','1=Sintetico;2=Analitico','1=Summarized;2=Detailed','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTH','04','CTH_NORMAL','C',1,0,'Cond Normal','Cond Normal','Regul.Cond.','Condicao Normal','Condicion Normal','Regular Condition','@!','Pertence("012")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(134) + Chr(128),'','','','S','','','','','0=Nenhum;1=Despesa;2=Receita','0=Ninguno;1=Gasto;2=Ingreso','0=None;1=Expense;2=Revenue','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTH','05','CTH_DESC01','C',40,0,'Desc Moeda 1','Desc Moned 1','Desc.Curr.1','Descricao na Moeda 1','Descripcion en Moneda 1','Currency 1 Description','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(147) + Chr(128),'','','','S','','','','','','','','','','','','','','','S','N','','1','N','','S'} )
aAdd( aSX3, {'CTH','06','CTH_DESC02','C',40,0,'Desc Moeda 2','Desc Moned 2','Desc.Curr.2','Descricao na Moeda 2','Descripcion en Moneda 2','Currency 2 Description','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(146) + Chr(192),'','','','N','','','','','','','','','','','','','','','S','N','','1','N','','S'} )
aAdd( aSX3, {'CTH','07','CTH_DESC03','C',40,0,'Desc Moeda 3','Desc Moned 3','Desc.Curr.3','Descricao na Moeda 3','Descripcion en Moneda 3','Currency 3 Description','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(146) + Chr(192),'','','','N','','','','','','','','','','','','','','','S','N','','1','N','','S'} )
aAdd( aSX3, {'CTH','08','CTH_DESC04','C',40,0,'Desc Moeda 4','Desc Moned 4','Desc.Curr.4','Descricao na Moeda 4','Descripcion en Moneda 4','Currency 4 Description','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(146) + Chr(192),'','','','N','','','','','','','','','','','','','','','S','N','','1','N','','S'} )
aAdd( aSX3, {'CTH','09','CTH_DESC05','C',40,0,'Desc Moeda 5','Desc Moned 5','Desc.Curr.5','Descricao na Moeda 5','Descripcion en Moneda 5','Currency 5 Description','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(146) + Chr(192),'','','','N','','','','','','','','','','','','','','','S','N','','1','N','','S'} )
aAdd( aSX3, {'CTH','10','CTH_BLOQ','C',1,0,'Cl Vlr Bloq','Cl Vlr Bloq.','Lock.V.Cat.','Classe Valor Bloqueada','Clase Valor Bloqueada','Locked Value Category','!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"2"','',1,Chr(130) + Chr(192),'','','','N','','','','','1=Bloqueado;2=Nao Bloqueado','1=Bloqueado;2=No Bloqueado','1=Locked;2=Unlocked','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTH','11','CTH_DTBLIN','D',8,0,'Dt Ini Bloq','Fch Ini Bloq','Lock.Ini.Dt.','Data Inicio Bloqueio','Fecha Inicio Bloqueo','Locking Initial Date','99/99/9999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(130) + Chr(192),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTH','12','CTH_DTBLFI','D',8,0,'Dt Fim Bloq','Fch Fin Bloq','Blck.Fin.Dt.','Data Final Bloqueio','Fecha Final Bloqueo','Final Locking Date','99/99/9999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(130) + Chr(192),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTH','13','CTH_DTEXIS','D',8,0,'Ini Exist','Ini Exist.','Exst.Ini.Dt.','Data Inicio Existencia','Fecha Inicio Existencia','Exist. Initial Date','99/99/9999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'CTOD("01/01/80")','',1,Chr(130) + Chr(192),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTH','14','CTH_DTEXSF','D',8,0,'Dt Fim Exist','Fch Fin Exis','Fin.Exist.Dt','Data Final de Existencia','Fecha final de Existencia','Final Existence Date','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(134) + Chr(65),'','','','S','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTH','15','CTH_CLVLLP','C',9,0,'Cl Valor LP','Cl. Valor LP','P/L Vl.Class','Classe Valor Lucro/Perda','Clase Valor Gananc./Perd.','P&L Value Class','@!','Vazio() .Or. ValidaCLVL(M->CTH_CLVLLP) .Or. (M->CTH_CLVLLP = "*")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'M->CTH_CLVL','CTH',1,Chr(130) + Chr(192),'','','','N','','','','','','','','','','','006','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTH','16','CTH_CLPON','C',9,0,'Cl Vlr Ponte','Cl Vlr Puent','Aux.Vl.Class','Classe Vlr Ponte L/P','Clase Vlr Puente L/P','Auxiliary LP Class Value','@!','Vazio() .Or. ValidaCLVL(M->CTH_CLPON) .Or. (M->CTH_CLPON = "*")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CTH',1,Chr(130) + Chr(192),'','','','N','','','','','','','','','','','006','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTH','17','CTH_BOOK','C',20,0,'Conf. Livros','Conf. Libros','Tax Rec.Con.','Configuracao de Livros','Configuracion de Libros','Tax Record Config.','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(150) + Chr(192),'','','','S','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTH','18','CTH_CLSUP','C',9,0,'Cl Superior','Cl. Superior','Superior Cl.','Classe Valor Superior','Clase Valor Superior','Superior Value Class','@!','(Vazio() .Or. ExistCpo("CTH",,1)) .AND. ValEntSup(M->CTH_CLSUP,"CTH",M->CTH_CLVL)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CTH',1,Chr(130) + Chr(192),'','','','N','','','','','','','','','','','006','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTH','19','CTH_RES','C',10,0,'Cod Red.ClVl','Cod Red.ClVl','VlCl.Red.Cd.','Codigo Red. Classe Valor','Codigo Red. Clase Valor','Value Class Reduced Code','@!','Ctb060NoRe().and.(Vazio() .or. ExistChav("CTH",,3,"CODRESUM"))',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(146) + Chr(192),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTH','20','CTH_CRGNV1','C',12,0,'Cnt Reg Niv1','Cnt Reg Niv1','Cntrl.Lev.1','Contra Regra Nivel 1','Contrarregla Nivel 1','Counterrule 1','@!','Vazio() .Or.  CtbValLig(M->CTH_CLASSE)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(150) + Chr(192),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTH','21','CTH_CRGNV2','C',12,0,'Cnt Reg Niv2','Cnt Reg Niv2','Cntrl.Lev.2','Contra Regra Nivel 2','Contrarregla Nivel 2','Counterrule 2','@!','Vazio() .Or. CtbValLig(M->CTH_CLASSE)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(150) + Chr(192),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTH','22','CTH_CRGNV3','C',12,0,'Cnt Reg Niv3','Cnt Reg Niv3','Cntrl.Lev.3','Contra Regra Nivel 3','Contrarregla Nivel 3','Counterrule 3','@!','Vazio() .Or. CtbValLig(M->CTH_CLASSE)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(150) + Chr(192),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTH','23','CTH_CLVM','C',9,0,'Cl.Var.Monet','Cl.Var.Monet','Indexat.Cat.','Classe Var. Monetaria','Clase Var. Monetaria','','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CTH',1,Chr(214) + Chr(65),'','','','','','','','','','','','','','','006','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTH','24','CTH_CLRED','C',9,0,'Cl.Red.Var.','Cl.Red.Var.','Red.Cl.Var.','Classe Redutora Var. Mon.','Clase Reductora Var. Mon.','Red.Class MonetaryVariat.','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CTH',1,Chr(214) + Chr(65),'','','','','','','','','','','','','','','006','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTH','25','CTH_ACATIV','C',1,0,'Ac.Outra At?','¿Ac.Otr.Act?','Ac.Oth. Act?','Aceita Outra Atividade?','¿Acepta otra actividad?','Accept Another Activity?','@!','PERTENCE("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(212) + Chr(192),'','','','N','A','R','','','1=Sim;2=Não','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTH','26','CTH_ATOBRG','C',1,0,'Outr.At.Ob?','¿Otr.Act.Ob?','Oth.Man.Act?','Outra ativ. obrigatoria?','¿Otra activ. obligatoria?','Other mandatory activity?','@!','PERTENCE("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(198) + Chr(192),'','','','N','A','R','','','1=Sim;2=Não','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTH','27','CTH_ACAT01','C',1,0,'Ativ.01 Ac.','Activ.01 Ac.','Activ.01 Ac.','Aceita Atividade 01','Acepta Actividad 01','Accept Activity 01','@!','PERTENCE("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(198) + Chr(192),'','','','N','A','R','','','1=Sim;2=Não','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTH','28','CTH_AT01OB','C',1,0,'Ativ.01 Ob.','Activ.01 Ob.','Activ.01 Mn.','Obrigatório Ativ.01','Obligatorio Activ.01','Mandatory Activ.01','@!','PERTENCE("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(198) + Chr(192),'','','','N','A','R','','','1=Sim;2=Não','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTH','29','CTH_ACAT02','C',1,0,'Ativ.02 Ac.','Activ.02 Ac.','Activ.02 Ac.','Aceita Atividade 02','Acepta Actividad 02','Accept Activity 02','@!','PERTENCE("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(198) + Chr(192),'','','','N','A','R','','','1=Sim;2=Não','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTH','30','CTH_AT02OB','C',1,0,'Ativ.02 Ob.','Activ.02 Ob.','Activ.02 Mn.','Obrigatório Ativ.02','Obligatorio Activ.02','Mandatory Activ.02','@!','PERTENCE("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(198) + Chr(192),'','','','N','A','R','','','1=Sim;2=Não','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTH','31','CTH_ACAT03','C',1,0,'Ativ.03 Ac.','Activ.03 Ac.','Activ.03 Ac.','Aceita Atividade 03','Acepta Actividad 03','Accept Activity 03','@!','PERTENCE("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(198) + Chr(192),'','','','N','A','R','','','1=Sim;2=Não','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTH','32','CTH_AT03OB','C',1,0,'Ativ.03 Ob.','Activ.03 Ob.','Activ.03 Mn.','Obrigatório Ativ.03','Obligatorio Activ.03','Mandatory Activ.03','@!','PERTENCE("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(198) + Chr(192),'','','','N','A','R','','','1=Sim;2=Não','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTH','33','CTH_ACAT04','C',1,0,'Ativ.04 Ac.','Activ.04 Ac.','Activ.04 Ac.','Aceita Atividade 04','Acepta Actividad 04','Accept Activity 04','@!','PERTENCE("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(198) + Chr(192),'','','','N','A','R','','','1=Sim;2=Não','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTH','34','CTH_AT04OB','C',1,0,'Ativ.04 Ob.','Activ.04 Ob.','Activ.04 Mn.','Obrigatório Ativ.04','Obligatorio Activ.04','Mandatory Activ.04','@!','PERTENCE("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(198) + Chr(192),'','','','N','A','R','','','1=Sim;2=Não','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTH','35','CTH_TPO01','C',2,0,'Tipo Ctb 01','Tipo Ctb. 01','Ctb Type 01','Tipo Ctb 01','Tipo Ctb. 01','Ctb Type 01','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(222) + Chr(192),'','','','','V','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTH','36','CTH_TPO02','C',2,0,'Tipo Ctb 02','Tipo Ctb. 02','Ctb Type 02','Tipo Ctb 02','Tipo Ctb. 02','Ctb Type 02','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(222) + Chr(192),'','','','','V','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTH','37','CTH_TPO04','C',2,0,'Tipo Ctb 04','Tipo Ctb. 04','Ctb Type 04','Tipo Ctb 04','Tipo Ctb. 04','Ctb Type 04','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(222) + Chr(192),'','','','','V','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTH','38','CTH_TPO03','C',2,0,'Tipo Ctb 03','Tipo Ctb. 03','Ctb Type 03','Tipo Ctb 03','Tipo Ctb. 03','Ctb Type 03','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(222) + Chr(192),'','','','','V','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTH','39','CTH_XGERAT','C',1,0,'Gera Rat Atv','Gera Rat Atv','Gera Rat Atv','Gera Rateio da Atividade','Gera Rateio da Atividade','Gera Rateio da Atividade','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','€','','S=Sim;N=Nao','','','','','','','','','','','N','','','N','',''} )
aAdd( aSX3, {'CTH','40','CTH_XRATEI','C',1,0,'Ex.Res.Ratei','Ex.Res.Ratei','Ex.Res.Ratei','Exclusivo Result. Rateio','Exclusivo Result. Rateio','Exclusivo Result. Rateio','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','€','','S=Sim;N=Nao','','','','','','','','','','','N','','','N','',''} )
aAdd( aSX3, {'CTH','41','CTH_XATORA','C',9,0,'Ativ Orig Ra','Ativ Orig Ra','Ativ Orig Ra','Atividade Origem Rateio','Atividade Origem Rateio','Atividade Origem Rateio','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CTH',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','',''} )
aAdd( aSX3, {'CTH','43','CTH_XATICO','C',9,0,'Ativ Corr Ra','Ativ Corr Ra','Ativ Corr Ra','Ativ Correlacionada ao Ra','Ativ Correlacionada ao Ra','Ativ Correlacionada ao Ra','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','€','','','','','','','','','','','','','N','','','N','',''} )
aAdd( aSX3, {'CTT','01','CTT_FILIAL','C',4,0,'Filial','Sucursal','Branch','Filial do Sistema','Sucursal del Sistema','System Branch','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(128) + Chr(128),'','','','N','','','','','','','','','','','033','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','02','CTT_CUSTO','C',9,0,'C Custo','C.Costo','C.Center','Centro de Custo','Centro de Costo','Cost Center','@!','Ctb030Cus()',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(176),'','',1,Chr(131) + Chr(128),'','','','S','','','','','','','','','','','004','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','03','CTT_CLASSE','C',1,0,'Classe','Clase','Class','Classe','Clase','Class','@!','Pertence("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"2"','',1,Chr(131) + Chr(128),'','','','S','','','','','1=Sintetico;2=Analitico','1=Sintetico;2=Analitico','1=Summarized;2=Detailed','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','04','CTT_NORMAL','C',1,0,'Cond Normal','Cond Normal','Regul.Cond.','Condicao Normal','Condicion Normal','Regular Condition','@!','Pertence("012")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(134) + Chr(128),'','','','S','','','','','0=Nenhum;1=Despesa;2=Receita','0=Ninguno;1=Gasto;2=Ingreso','0=None;1=Expense;2=Income','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','05','CTT_DESC01','C',45,0,'Desc Moeda 1','Desc.Moned.1','Curr 1 Desc','Descricao Moeda 1','Descripcion Moneda 1','Currency 1 Description','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(147) + Chr(128),'','','','S','A','R','','','','','','','','','','','','','S','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','06','CTT_DESC02','C',40,0,'Desc Moeda 2','Desc.Moned.2','Curr 2 Desc','Descricao Moeda 2','Descripcion Moneda 2','Currency 2 Description','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(146) + Chr(192),'','','','N','','','','','','','','','','','','','','','S','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','07','CTT_DESC03','C',40,0,'Desc Moeda 3','Desc.Moned.3','Curr 3 Desc','Descricao Moeda 3','Descripcion Moneda 3','Currency 3 Description','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(146) + Chr(192),'','','','N','','','','','','','','','','','','','','','S','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','08','CTT_DESC04','C',40,0,'Desc Moeda 4','Desc.Moned.4','Curr 4 Desc.','Descricao Moeda 4','Descripcion Moneda 4','Currency 4 Description','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(146) + Chr(192),'','','','N','','','','','','','','','','','','','','','S','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','09','CTT_DESC05','C',40,0,'Desc Moeda 5','Desc.Moned.5','Curr 5 Desc.','Descricao Moeda 5','Descripcion Moneda 5','Currency 5 Description','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(146) + Chr(192),'','','','N','','','','','','','','','','','','','','','S','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','10','CTT_BLOQ','C',1,0,'CC Bloq','CC Bloq.','Locked C.C.','C.C. Bloqueado?','+C.C. Bloqueado?','Locked C.C.','!','Pertence("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"2"','',1,Chr(130) + Chr(192),'','','','N','','','','','1=Bloqueado;2=Nao Bloqueado','1=Bloqueado;2=No Bloqueado','1=Locked;2=Unlocked','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','11','CTT_DTBLIN','D',8,0,'Dt Ini Bloq','Fch.Ini.Bloq','Lock.Ini.Dt.','Data Inicio Bloqueio','Fecha Inicio Bloqueo','Locking Initial Date','99/99/9999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(130) + Chr(192),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','12','CTT_DTBLFI','D',8,0,'Dt Fim Bloq','Fch.Fin Bloq','Freez.Fin.Dt','Data Fim Bloqueio','Fecha Fin Bloqueo','Freeze Final Date','99/99/9999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(130) + Chr(192),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','13','CTT_DTEXIS','D',8,0,'Dt Ini Exist','Fch.Ini.Exis','Exst.Ini.Dt.','Data Inicio Existencia','Fecha Inicio Existencia','Existence Initial Date','99/99/9999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'CTOD("01/01/80")','',1,Chr(130) + Chr(192),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','14','CTT_DTEXSF','D',8,0,'Dt Fim Exist','Fch Fin Exis','Fin.Exist.Dt','Data Final de Existencia','Fecha final de Existencia','Final Existence Date','99/99/9999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(214) + Chr(65),'','','','S','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','15','CTT_CCLP','C',9,0,'CC Lucr/Perd','CC Gan/Perd','P/L C.Center','C. Custo Lucros/Perdas','C. Costo Gananc/Perdidas','Profits/Losses C.Center','@!','Vazio() .Or. ValidaCusto(M->CTT_CCLP) .Or. (M->CTT_CCLP = "*")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'M->CTT_CUSTO','CTT',1,Chr(130) + Chr(192),'','','','N','','','','','','','','','','','004','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','16','CTT_CCPON','C',9,0,'CC Ponte LP','CC Puente LP','P/L Aux.C.C.','C. Custo Ponte L/P','C. Costo Puente L/P','EL Aux. Cost Center','@!','Vazio() .Or. ValidaCusto(M->CTT_CCPON)  .Or. (M->CTT_CCPON = "*")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CTT',1,Chr(130) + Chr(192),'','','','N','','','','','','','','','','','004','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','17','CTT_TIPO00','C',2,0,'Tipo Terc.','Tipo Terc.','3rdParty Tp.','Tipo de Terceiro','Tipo de tercero','Third party type','@!','Pertence("01|02|03")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(198) + Chr(128),'','','','N','A','R','','','01=Cliente;02=Fornecedor;03=Funcionarios','01=Cliente;02=Proveedor;03=Empleados','01=Customer;02=Supplier;03=Employees','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','18','CTT_BOOK','C',20,0,'Conf. Livros','Conf. Libros','T.Rec.Conf.','Configuracao de Livros','Configuracion de Libros','Tax Records Configuration','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(150) + Chr(192),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','19','CTT_TIPO01','C',2,0,'Tp Doc Ter.','Tp.Doc.Ter.','Th.P. Doc. T','Tipo Documento Terceiros','Tipo Documento Terceros','Third Party Doc Type','@!','Pertence("01|02|03|04")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(128) + Chr(128),'','','','N','A','R','','','01=RG;02=CPF/CNPJ;03=PASSAPORTE;04=CED. ESTRANGEIRO','01=RG;02=CPF/CNPJ;03=PASAPORTE;04=CED. EXTRANJERO','01=RG;02=CPF/CNPJ;03=PASSPORT;04=PERMAN. RESIDENT CARD','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','20','CTT_CCSUP','C',9,0,'CC Superior','CC Superior','Superior C.C','C.C. Superior','C.C. Superior','Superior C.C.','@!','(Vazio() .Or. ExistCpo("CTT",,1)) .and. ValEntSup(M->CTT_CCSUP,"CTT",M->CTT_CUSTO)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CTT',1,Chr(130) + Chr(192),'','','','N','','','','','','','','','','','004','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','21','CTT_RES','C',10,0,'Cod Red. CC.','Cod Red. CC.','C.C.Red.Code','Codigo Red. C.Custo','Codigo Red. C.Costo','Cost Center Red.Code','@!','Ctb030NoRe().and.(Vazio() .or. ExistChav("CTT",,3,"CODRESUM"))',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(146) + Chr(192),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','22','CTT_CRGNV1','C',12,0,'Cnt Reg Niv1','Cnt Reg Niv1','Cntrl.Lev.1','Contra Regra Nivel 1','Contrarregla Nivel 1','Counterrule 1','@!','Vazio() .Or. CtbValLig(M->CTT_CLASSE)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(150) + Chr(192),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','23','CTT_RGNV2','C',12,0,'Regra Nivel2','Regla Nivel2','Rule Level 2','Regra Nivel 2','Regla Nivel 2','Rule Level 2','@!','Vazio() .Or. CtbValLig(M->CTT_CLASSE)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(150) + Chr(192),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','24','CTT_RGNV3','C',12,0,'Regra Nivel3','Regla Nivel3','Level 3 Rule','Regra Nivel 3','Regla Nivel 3','Level 3 Rule','@!','Vazio() .Or. CtbValLig(M->CTT_CLASSE)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(150) + Chr(192),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','25','CTT_STATUS','C',1,0,'Status','Estatus','Status','Status','Estatus','Status','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(132) + Chr(128),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','26','CTT_FILMAT','C',4,0,'Fil.Respons.','Suc.Respons.','Respon.Bran.','Cod.Filial Resp. C.Custo','Cod. Sucurs.Resp.C.Costo','C.Cost Respons.Branch Cd.','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(132) + Chr(128),'','','','N','','','','','','','','','','','033','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','27','CTT_MAT','C',6,0,'Cod.Respons.','Responsable','Code Respons','Cod. Responsavel C.Custo','Cod. Responsable C.Costo','C.Cost Responsible Code','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(132) + Chr(128),'','','','','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','28','CTT_PERCAC','N',7,3,'% Acid.Trab.','% Accid.Trab','Labor Accid%','Percentual Acid. Trabalho','Porc. Accid. de Trabajo','Labour Accident %','@E 999.999','',Chr(129) + Chr(128) + Chr(160) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(132) + Chr(192),'','','','N','','','','positivo()','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','29','CTT_PERFPA','N',7,3,'% Terceiros','% Terceros','% 3rd Party','Percentual de Terceiros','Porcentaje de Terceros','Percentage 3rd. Parties','@E 999.999','',Chr(129) + Chr(128) + Chr(160) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(132) + Chr(192),'','','','N','','','','positivo()','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','30','CTT_NOME','C',40,0,'Nome Tomador','Nomb Tomador','Taker Name','Nome do Tomador Servico','Nombre Tomador Servicio','Service Taker Name','@!','',Chr(129) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(150) + Chr(128),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','31','CTT_ENDER','C',40,0,'End.Tomador','Dir.Tomador','Taker Addr.','Endereco Tomador Servico','Direccion Tomador Servic.','Service Taker Address','@!','',Chr(129) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(150) + Chr(128),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','32','CTT_BAIRRO','C',20,0,'Bair.Tomador','Bar. Tomador','Contr. Dist.','Bairro do Tomador Servico','Barrio del Tomad. Servic.','Service Contr. District','@!','',Chr(129) + Chr(128) + Chr(160) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(150) + Chr(128),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','33','CTT_CEP','C',8,0,'Cep Tomador','CP Tomador','Srv.C.Zip Cd','Cep do Tomador Servico','CP del Tomador Servicio','Service Contr. Zip Code','@R 99999-999','',Chr(129) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(150) + Chr(128),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','34','CTT_ESTADO','C',2,0,'Estado','Estado','State','Estado','Estado','State','@!','EXISTCPO("SX5","12"+M->CTT_ESTADO)',Chr(129) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','12',1,Chr(134) + Chr(128),'','','','N','','','','','','','','','','','010','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','35','CTT_MUNIC','C',20,0,'Mun.Tomador','Mun.Tomador','Serv.C.City','Municipio do Tomador','Municipio del Tomador','Service Contractor City','@!','',Chr(129) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(150) + Chr(128),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','36','CTT_TIPO','C',1,0,'T.Insc.Tomad','T.Insc.Contr','Tk.Insc.Tp.','Tipo Inscricao Tomador','Tipo Inscripcion Contrat.','Taker Insc.Type','!','Vazio() .Or. Pertence ("12")',Chr(129) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(134) + Chr(128),'','','','N','','','','','1=CNPJ;2=CEI','1=CNPJ;2=CEI','1=CNPJ;2=CEI','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','37','CTT_CEI','C',14,0,'CNPJ/CEI Tom','CNPJ/CEI Con','Pch.CNPJ/CEI','CNPJ/CEI Tomador','CNPJ/CEI de Contratante','Pch.CNPJ/CEI','','',Chr(129) + Chr(128) + Chr(160) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(134) + Chr(128),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','38','CTT_VALFAT','N',12,2,'Vlr.Fatura','Vlr.Factura','Invoice Vl.','Valor da fatura Tomador','Valor factura Contratante','Purchaser Invoice Value','@E 999,999,999.99','',Chr(129) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(158) + Chr(128),'','','','','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','39','CTT_RETIDO','N',12,2,'Vlr.Retido','Vlr.Retenido','Withheld Vl.','Valor Inss Retido Tomador','Valor Inss Reten. Contrat','Purch.Withheld INSS Value','@E 999,999,999.99','',Chr(129) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(158) + Chr(128),'','','','N','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','40','CTT_LOCAL','C',2,0,'Almoxarifado','Deposito','Warehouse','Almoxarifado Manutencao','Deposito mantenimiento','Maintenance Warehouse','@!','ExistCpo("NNR")',Chr(128) + Chr(128) + Chr(132) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','NNR',1,Chr(134) + Chr(192),'','','','N','','','','','','','','','','','024','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','41','CTT_OCORRE','C',2,0,'Ocorrencia','Ocurrencia','Occurrence','Ocorrencia de Ag. Nocivo','Ocurrencia de Ag. Nocivo','Harmful Agent Occurrence','@!','',Chr(129) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(134) + Chr(192),'','','','','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','42','CTT_ITOBRG','C',1,0,'Item Obrigat','Item Obligat','Mand. Item','Item Contab. Obrigatorio','Item Contab. Obligatorio','Mandatory Accounting Item','','Pertence("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"2"','',1,Chr(132) + Chr(128),'','','','','','','','','1=Sim;2=Nao','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','43','CTT_CLOBRG','C',1,0,'Cl.Vlr Obrig','Cl.Vlr Oblig','Mand.Vl. Cl.','Classe de Vlr Obrigatoria','Clase de Vlr Obligatoria','Mandatory Value Class','','Pertence("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"2"','',1,Chr(132) + Chr(128),'','','','','','','','','1=Sim;2=Nao','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','44','CTT_ACITEM','C',1,0,'Aceita Item','Acepta Item','Accept Item','Aceita Item Contabil','Acepta Item Contable','Accept Accounting Item','','Pertence("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"1"','',1,Chr(132) + Chr(128),'','','','','','','','','1=Sim;2=Näo','1=Sim;2=Näo','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','44','CTT_CCVM','C',9,0,'C.C.Var.Mon.','C.C.Var.Mon.','Index.C.C.','CCusto Variacao Monetaria','CCosto Variac. Monetaria','Indexation Cost Center','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CTT',1,Chr(214) + Chr(65),'','','','','','','','','','','','','','','004','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','45','CTT_ACCLVL','C',1,0,'Aceita Cl.Vl','Acepta Cl.Vl','Accept Vl.Cl','Aceita Classe de Valor','Acepta Clase de Valor','Accept Value Class','','Pertence("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"1"','',1,Chr(132) + Chr(128),'','','','','','','','','1=Sim;2=Nao','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','45','CTT_CCRED','C',9,0,'CC.Red. Var.','CC.Red. Var.','Index.R.CC','C.Custo Redutor Var.Monet','C.Costo Reductor Var.Mon.','Indexation Red.C.Center','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CTT',1,Chr(214) + Chr(65),'','','','','','','','','','','','','','','004','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','48','CTT_CSINCO','C',1,0,'C. Sinco','C. Sinco','SINCO C.','Classificacao Sinco','Clasificacion Sinco','SINCO Classification','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(228) + Chr(192),'','','','','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','49','CTT_OPERAC','C',3,0,'Operacao','Operacion','Operation','Operacao realizadao','Operacion realizado','Operation performed','@!',"EXISTCPO('TSZ',M->CTT_OPERAC)",Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','TSZ',1,Chr(150) + Chr(192),'','','','S','','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','50','CTT_PEREMP','N',8,4,'% Empresa','% Empresa','Company %','Percentual Empresa','Porcentaje Empresa','Company %','@E 999.9999','Positivo()',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(134) + Chr(192),'','','','S','','R','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','51','CTT_RECFAT','C',1,0,'Rec.Fatur.','Paga Fact.','Collect Invo','Recolhe s/ faturamento','Paga s/ facturacion','Collect without Invoicing','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(198) + Chr(192),'','','','','A','R','','','1=Sim;2=Não','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','52','CTT_CODMUN','C',7,0,'Cod.Munic.','Cod.Munic.','City Code','Codigo do Municipio','Codigo del Municipio','City Code','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(134) + Chr(128),'','','','','','R','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','53','CTT_ACATIV','C',1,0,'Ac.Outra At?','¿Ac.Otr.Act?','Ac.Oth. Act?','Aceita Outra Atividade?','¿Acepta otra actividade?','Accept Another Activity?','@!','PERTENCE("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(198) + Chr(192),'','','','N','A','R','','','1=Sim;2=Não','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','54','CTT_ATOBRG','C',1,0,'Outr.At.Ob?','¿Otr.Act.Ob?','Oth.Man.Act?','Outra ativ. obrigatoria?','¿Otra activ. obligatoria?','Other mandatory activity?','@!','PERTENCE("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(198) + Chr(192),'','','','N','A','R','','','1=Sim;2=Não','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','55','CTT_ACAT01','C',1,0,'Ativ.01 Ac.','Activ.01 Ac.','Activ.01 Ac.','Aceita Atividade 01','Acepta Actividad 01','Accept Activity 01','@!','PERTENCE("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(198) + Chr(192),'','','','N','A','R','','','1=Sim;2=Não','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','56','CTT_AT01OB','C',1,0,'Ativ.01 Ob.','Activ.01 Ob.','Activ.01 Mn.','Obrigatório Ativ.01','Obligatorio Activ.01','Mandatory Activ.01','@!','PERTENCE("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(198) + Chr(192),'','','','N','A','R','','','1=Sim;2=Não','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','57','CTT_ACAT02','C',1,0,'Ativ.02 Ac.','Activ.02 Ac.','Activ.02 Ac.','Aceita Atividade 02','Acepta Actividad 02','Accept Activity 02','@!','PERTENCE("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(198) + Chr(192),'','','','N','A','R','','','1=Sim;2=Não','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','58','CTT_AT02OB','C',1,0,'Ativ.02 Ob.','Activ.02 Ob.','Activ.02 Mn.','Obrigatório Ativ.02','Obligatorio Activ.02','Mandatory Activ.02','@!','PERTENCE("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(198) + Chr(192),'','','','N','A','R','','','1=Sim;2=Não','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','59','CTT_ACAT03','C',1,0,'Ativ.03 Ac.','Activ.03 Ac.','Activ.03 Ac.','Aceita Atividade 03','Acepta Actividad 03','Accept Activity 03','@!','PERTENCE("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(198) + Chr(192),'','','','N','A','R','','','1=Sim;2=Não','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','60','CTT_AT03OB','C',1,0,'Ativ.03 Ob.','Activ.03 Ob.','Activ.03 Mn.','Obrigatório Ativ.03','Obligatorio Activ.03','Mandatory Activ.03','@!','PERTENCE("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(198) + Chr(192),'','','','N','A','R','','','1=Sim;2=Não','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','61','CTT_ACAT04','C',1,0,'Ativ.04 Ac.','Activ.04 Ac.','Activ.04 Ac.','Aceita Atividade 04','Acepta Actividad 04','Accept Activity 04','@!','PERTENCE("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(198) + Chr(192),'','','','N','A','R','','','1=Sim;2=Não','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','62','CTT_AT04OB','C',1,0,'Ativ.04 Ob.','Activ.04 Ob.','Activ.04 Mn.','Obrigatório Ativ.04','Obligatorio Activ.04','Mandatory Activ.04','@!','PERTENCE("12")',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(198) + Chr(192),'','','','N','A','R','','','1=Sim;2=Não','1=Si;2=No','1=Yes;2=No','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','63','CTT_TPO01','C',2,0,'Tipo Ctb 01','Tipo Ctb. 01','Ctb Type 01','Tipo Ctb 01','Tipo Ctb. 01','Ctb Type 01','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(222) + Chr(192),'','','','','V','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','64','CTT_TPO02','C',2,0,'Tipo Ctb 02','Tipo Ctb. 02','Ctb Type 02','Tipo Ctb 02','Tipo Ctb. 02','Ctb Type 02','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(222) + Chr(192),'','','','','V','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','65','CTT_TPO03','C',2,0,'Tipo Ctb 03','Tipo Ctb. 03','Ctb Type 03','Tipo Ctb 03','Tipo Ctb. 03','Ctb Type 03','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(222) + Chr(192),'','','','','V','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','66','CTT_TPO04','C',2,0,'Tipo Ctb 04','Tipo Ctb. 04','Ctb Type 04','Tipo Ctb 04','Tipo Ctb. 04','Ctb Type 04','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(222) + Chr(192),'','','','','V','','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','67','CTT_RHEXP','C',6,0,'Contr.Exp.RH','Contr.Exp.RH','HR Exp Ctrl','Controle de Exportacao RH','Control de exportacion RH','HR Export Control','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(132) + Chr(128),'','','','N','V','R','','','','','','','','','','','','','N','N','','1','N','','S'} )
aAdd( aSX3, {'CTT','68','CTT_XEMAIL','C',50,0,'E-mail Resp.','E-mail Resp.','E-mail Resp.','E-mail do Responsavel','E-mail do Responsavel','E-mail do Responsavel','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'CTT','69','CTT_XUSER','C',6,0,'Usuario Resp','Usuario Resp','Usuario Resp','Usuario Responsavel C.C.','Usuario Responsavel C.C.','Usuario Responsavel C.C.','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','USR',0,Chr(254) + Chr(192),'','S','U','N','A','R','','Vazio().Or. (UsrExist (M->CTT_XUSER))','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'CTT','70','CTT_XTEL','C',15,0,'Tel.Respons','Tel.Respons','Tel.Respons','Tel.do Responsavel CC','Tel.do Responsavel CC','Tel.do Responsavel CC','@R (99) 9999-9999','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'CTT','71','CTT_XLOCAL','C',1,0,'Localizacäo','Localizacäo','Localizacäo','Localizacäo','Localizacäo','Localizacäo','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','A','R','','','1=Sede;2=Unidade;3=Näo Gera','1=Sede;2=Unidade;3=Näo Gera','1=Sede;2=Unidade;3=Näo Gera','','','','','','','','','N','','','N','',''} )
aAdd( aSX3, {'CTT','72','CTT_XDP06','C',11,0,'Cod Identif','Cod Identif','Cod Identif','Codigo Identificado','Codigo Identificado','Codigo Identificado','@R 99999-9','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','S','V','R','','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX3, {'CTT','73','CTT_XCODAT','C',2,0,'Cod. Ativid.','Cod. Ativid.','Cod. Ativid.','Cod. Ativid.','Cod. Ativid.','Cod. Ativid.','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','',''} )
aAdd( aSX3, {'CTT','74','CTT_XDESAT','C',50,0,'Desc. Ativid','Desc. Ativid','Desc. Ativid','Desc. Ativid','Desc. Ativid','Desc. Ativid','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','',''} )
aAdd( aSX3, {'CTT','75','CTT_XKITAP','C',1,0,'Kit Aprendiz','Kit Aprendiz','Kit Aprendiz','Kit Aprendiz','Kit Aprendiz','Kit Aprendiz','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"1"','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','1=CR01;2=CR02','','','','','','','','','','','N','','','N','',''} )
aAdd( aSX3, {'CTT','76','CTT_XCDCLI','C',6,0,'Cod.Cliente','Cod.Cliente','Cod.Cliente','Cod.Cliente','Cod.Cliente','Cod.Cliente','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','SA1',0,Chr(254) + Chr(192),'','','U','N','A','R','','Vazio() .or. ExistCPO("SA1", M->CTT_CODCLI)','','','','','','','','','','','','N','','','N','',''} )
aAdd( aSX3, {'CTT','77','CTT_XLJCLI','C',2,0,'Loja Cliente','Loja Cliente','Loja Cliente','Loja Cliente','Loja Cliente','Loja Cliente','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','V','R','','','','','','','','','','','','','','N','','','N','',''} )
aAdd( aSX3, {'CTT','78','CTT_XCDTRA','C',6,0,'Cod Transpor','Cod Transpor','Cod Transpor','Cod Transpor','Cod Transpor','Cod Transpor','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','SA4',0,Chr(254) + Chr(192),'','','U','N','A','R','','Vazio() .or. ExistCPO("SA4", M->CTT_CODTRA)','','','','','','','','','','','','N','','','N','',''} )
aAdd( aSX3, {'CTT','79','CTT_XENVWS','C',1,0,'Enviado EAI?','Enviado EAI?','Enviado EAI?','Enviado EAI?','Enviado EAI?','Enviado EAI?','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"1"','',0,Chr(254) + Chr(192),'','','U','N','V','R','','','1=Nao;2=Sim','','','','','','','','','','','N','','','N','',''} )
aAdd( aSX3, {'CTT','80','CTT_XNOME','C',60,0,'Nome Resp.','Nome Resp.','Nome Resp.','Nome do responsavel','Nome do responsavel','Nome do responsavel','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','V','R','','','','','','','','','','','','','','N','','','N','',''} )
aAdd( aSX3, {'CTT','81','CTT_XESTRU','C',50,0,'Est.Val.Pai','Est.Val.Pai','Est.Val.Pai','Estrutura Pai CR','Estrutura Pai CR','Estrutura Pai CR','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','',''} )
aAdd( aSX3, {'CTT','82','CTT_XUNIPD','C',9,0,'Unidade Padr','Unidade Padr','Unidade Padr','Unidade Padrao de Lcto','Unidade Padrao de Lcto','Unidade Padrao de Lcto','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CTD',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','',''} )
aAdd( aSX3, {'CTT','83','CTT_XATIPD','C',9,0,'Ativid. Padr','Ativid. Padr','Ativid. Padr','Atividade Padrao de Lacto','Atividade Padrao de Lacto','Atividade Padrao de Lacto','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CTH',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','',''} )
aAdd( aSX3, {'CTT','84','CTT_XTPGAS','C',1,0,'Tipo Gasto','Tipo Gasto','Tipo Gasto','Tipo de Gasto','Tipo de Gasto','Tipo de Gasto','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','D=Direto;I=Indireto;C=Consolidador','','','','','','','','','','','N','','','N','',''} )
aAdd( aSX3, {'CTT','85','CTT_XRATEI','C',1,0,'Trat.Esp.Rat','Trat.Esp.Rat','Trat.Esp.Rat','Trat.Esp.Rat Geral','Trat.Esp.Rat Geral','Trat.Esp.Rat Geral','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','A=Somente Criterio Atendimento;S=Sem Rateio;N=Sem Tratamento Especifico','','','','','','','','','','','N','','','N','',''} )
aAdd( aSX3, {'CV0','01','CV0_FILIAL','C',4,0,'Filial','Sucursal','Branch','Filial','Sucursal','Branch','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',1,Chr(132) + Chr(128),'','','','S','','','','','','','','','','','033','','','','N','N','','1','N','','N'} )
aAdd( aSX3, {'CV0','02','CV0_PLANO','C',2,0,'Plano Contáb','Plan Contabl','Accoun. Plan','Código do plano contábil.','Codigo del plan contable','Accounting Plan code','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(67) + Chr(128),'','','','S','','','','','','','','',"CTB050SX3('CV0_PLANO')",'INCLUI','','','','','N','N','','1','N','','N'} )
aAdd( aSX3, {'CV0','03','CV0_ITEM','C',6,0,'Item','Item','Item','Item do Plano Contábil','Item del Plan Contable','Accounting Plan Item','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(67) + Chr(128),'','','','','V','','','','','','','',"CTB050SX3('CV0_ITEM')",'','','','','','N','N','','1','N','','N'} )
aAdd( aSX3, {'CV0','04','CV0_CODIGO','C',6,0,'Codigo','Codigo','Code','Código da entidade','Codigo del ente','Company code','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(215) + Chr(128),'','','','','','','','','','','','',"CTB050WHEN() .And. CTB050SX3('CV0_CODIGO')",'','','','','','N','N','','1','N','','N'} )
aAdd( aSX3, {'CV0','05','CV0_DESC','C',30,0,'Descrição','Descripcion','Description','Descrição','Descripcion','Description','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(67) + Chr(128),'','','','S','','','','','','','','','','','','','','','N','N','','1','N','','N'} )
aAdd( aSX3, {'CV0','06','CV0_CLASSE','C',1,0,'Classe','Clase','Class','Classe','Clase','Class','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(67) + Chr(128),'','','','','','','','','1=Sintetica;2=Analitica','1=Sintetica;2=Analitica','1=Synthetic; 2= Analytical','','CTB050WHEN()','','','','','','N','N','','1','N','','N'} )
aAdd( aSX3, {'CV0','07','CV0_NORMAL','C',1,0,'Cond.Normal','Cond.Normal','Reg Term','Condição Normal','Condicion Normal','Regular Term','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(67) + Chr(128),'','','','','','','','','1=Devedora;2=Credora','1=Debedora;2=Acreedora','1=Debtor; 2=Creditor','','CTB050WHEN()','','','','','','N','N','','1','N','','N'} )
aAdd( aSX3, {'CV0','08','CV0_ENTSUP','C',6,0,'Entid.Sup.','Entid.Sup.','Higher Ent.','Entidade Superior','Entidad Superior','Higher Entity','@!','CTB050ESup(,M->CV0_ENTSUP)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CV0',1,Chr(198) + Chr(128),'','','','','','','','','','','','',"CTB050SX3('CV0_ENTSUP')",'','','','','','N','N','','1','N','','N'} )
aAdd( aSX3, {'CV0','09','CV0_BLOQUE','C',1,0,'Bloqueada','Bloqueada','Blocked','Bloqueia código da Entida','Bloquea codigo de Entidad','Blocks Company Code','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(198) + Chr(128),'','','','','','','','','1=Sim;2=Nao','1=Si;2=No','1=Yes; 2=No','','','','','','','','N','N','','1','N','','N'} )
aAdd( aSX3, {'CV0','10','CV0_DTIBLQ','D',8,0,'Dt.Inic.Blq','Fc.Inic.Blq','Bl. Init. Dt','Data Inicial do Bloqueio','Fecha Inicial del Bloqueo','Blockage Initial Date','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'CTOD("")','',1,Chr(198) + Chr(128),'','','','','','','','','','','','','','','','','','','N','N','','1','N','','N'} )
aAdd( aSX3, {'CV0','11','CV0_DTFBLQ','D',8,0,'Dt.Final Blq','Fc.Final Blq','Bl.Fin.Dt.','Data Final do Bloqueio','Fecha Final del Bloqueo','Blockage Final Date','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'CTOD("")','',1,Chr(198) + Chr(128),'','','','','','','','','','','','','','','','','','','N','N','','1','N','','N'} )
aAdd( aSX3, {'CV0','12','CV0_DTIEXI','D',8,0,'Data Inicial','Fecha Inicia','Init date','Data Inicial de existênc.','Fecha Inicial de existenc','Existance Initial Date','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'dDatabase','',1,Chr(198) + Chr(128),'','','','','','','','','','','','','','','','','','','N','N','','1','N','','N'} )
aAdd( aSX3, {'CV0','13','CV0_DTFEXI','D',8,0,'Data Final','Fecha Final','Final date','Data Final de existência.','Fecha Final de existencia','Final existance date','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'CTOD("")','',1,Chr(198) + Chr(128),'','','','','','','','','','','','','','','','','','','N','N','','1','N','','N'} )
aAdd( aSX3, {'CV0','14','CV0_CFGLIV','C',3,0,'Cod.Livros','Cod.Libros','Books Code','Código da Conf.de livros','Codigo de Conf. de libros','Code of Books Conf','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CTN',1,Chr(198) + Chr(128),'','','','','','','','','','','','','','','','','','','N','N','','1','N','','N'} )
aAdd( aSX3, {'CV0','15','CV0_LUCPER','C',15,0,'Lucros/Perda','Ganan/Perdid','Profit/Loss','Lucros e Perdas.','Ganancias y Perdidas','Profit/Losses','@!','CTB105EntC(,M->CV0_LUCPER,,M->CV0_PLANO)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CV0',1,Chr(214) + Chr(128),'','','','','','','','','','','','','','','','','','','N','N','','1','N','','N'} )
aAdd( aSX3, {'CV0','16','CV0_PONTE','C',15,0,'Conta Ponte.','Cta. Ponte.','Bridge Acc','Conta Ponte.','Cuenta Ponte.','Bridge Account','@!','CTB105EntC(,M->CV0_PONTE,,M->CV0_PLANO)',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CV0',1,Chr(214) + Chr(128),'','','','','','','','','','','','','','','','','','','N','N','','1','N','','N'} )
aAdd( aSX3, {'CV0','19','CV0_ECVM','C',6,0,'Var.Monet.','Var.Monet.','Var.Monet.','Entid.Variacao Monetaria','Entid.Variacao Monetaria','Entid.Variacao Monetaria','@!','Ctb050VM()',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CV0',1,Chr(198) + Chr(128),'','','','','','','','','','','','','','','','','','','','','','','','','N'} )
aAdd( aSX3, {'CV0','20','CV0_ECRED','C',6,0,'Red.Var.M.','Red.Var.M.','Red.Var.M.','Redutora Var.Monetaria','Redutora Var.Monetaria','Redutora Var.Monetaria','@!','Ctb050Red()',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CV0',1,Chr(198) + Chr(128),'','','','','','','','','','','','','','','','','','','','','','','','','N'} )
aAdd( aSX3, {'CV0','21','CV0_XTPSET','C',2,0,'Tipo Setor','Tipo Setor','Tipo Setor','Classificacao Tipo Setor','Classificacao Tipo Setor','Classificacao Tipo Setor','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','€','','SI;AE;AC;PA;CS;SC;PC;XX','','','','','','','','','','','N','','','N','',''} )
aAdd( aSX3, {'CV0','22','CV0_XCCPDR','C',9,0,'CC Padrao','CC Padrao','CC Padrao','Centro de Custo Padrao','Centro de Custo Padrao','Centro de Custo Padrao','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CTT',0,Chr(254) + Chr(192),'','','U','N','A','R','€','','','','','','','','','','','','','N','','','N','',''} )
aAdd( aSX3, {'CV0','23','CV0_XATPDR','C',9,0,'Atv. Padrao','Atv. Padrao','Atv. Padrao','Atividade Padrao','Atividade Padrao','Atividade Padrao','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CTH',0,Chr(254) + Chr(192),'','','U','N','A','R','€','','','','','','','','','','','','','N','','','N','',''} )
aAdd( aSX3, {'CV0','24','CV0_XESTRU','C',50,0,'Estrut. CR','Estrut. CR','Estrut. CR','Estrutura','Estrutura','Estrutura','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','€','','','','','','','','','','','','','N','','','N','',''} )

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
@since  11/12/2014
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
@since  11/12/2014
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
