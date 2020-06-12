#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#Include "TOPCONN.CH"

/*/{Protheus.doc} A10002
Tela de apontamentos de produção.
@type function
@author Funaki
@since 26/04/2018
@version 1.0
/*/
User Function A10002()

	Local _aSizeAut	:= MsAdvSize(.F.,.F.,400)
	Local _aObjects	:= {}
	Local _aInfo	:= {}
	Local _aButtons	:= {}
	Local _nTipo	:= 1
	Local _aTipo	:= {"Requisição","Devolução"}
	Local _oFont18	:= TFont():New('Arial',,-18,.T.)
	Local _oFont18C	:= TFont():New('Courier new',,18,.T.,.T.)
	Local _oFont32	:= TFont():New('Arial',,-32,.T.)
	Local _nTamBt	:= 100
	Local _cCpoEsc	:= SPACE(10)

	Private _nSqSel		:= 1
	Private oSqSim, oSqNao
	Private _nUmAp		:= 1
	Private _aUMProd	:= {}
	Private _cOP		:= CriaVar("D3_OP",.F.)
	Private _cProd		:= CriaVar("B1_COD",.F.)
	Private _cDesPrd	:= CriaVar("B1_DESC",.F.)
	Private _cLocal		:= CriaVar("C2_LOCAL",.F.)
	Private _cLote		:= CriaVar("D3_LOTECTL",.F.)
	Private _nQtdOp		:= CriaVar("C2_QUANT",.F.)
	Private _nQtdAp		:= 1.00
	Private _nQtd1Um	:= 0.00
	Private _dIniAp		:= DDATABASE
	Private _dFimAp		:= DDATABASE
	Private _cHrIAp		:= Substr(TIME(),1,5)	//TEMPAD(60)
	Private _cHrFAp		:= Substr(TIME(),1,5)
	Private cProdSub	:= CriaVar("B1_COD",.F.)
	Private cDescSub	:= CriaVar("B1_DESC",.F.)
	Private _nQtdPerd	:= 0
	Private _cObs		:= CriaVar("H6_OBSERVA",.F.)

	Private cProdPerda	:= CriaVar("B1_COD",.F.)
	Private cDescPerda	:= CriaVar("B1_DESC",.F.)
	Private cMotPerda   := CriaVar("BC_MOTIVO",.F.)
	Private cPerdaLoteCtl    := CriaVar("BC_LOTECTL",.F.)

	Private	nQtdAp1Um	:= 1.00
	Private	nQtdAp2Um	:= 0.00
	Private nSldOp		:= 0
	Private lGaPrd		:= .F.
	Private lConv2		:= .F.
	Private aStatBtn	:= {}

	Private oListSD4	:= Nil
	Private aListSD4	:= {}
	Private nListSD4	:= 1

	Private oListSH6	:= Nil
	Private aListSH6	:= {}
	Private nListSH6	:= 1

	Private oListSBC	:= Nil
	Private aListSBC	:= {}
	Private nListSBC	:= 1

	Private lVerOp		:= .T.

	//Verifica se acessos a rotina
	dbSelectArea("ZA2")
	ZA2->(dbSetOrder(1))
	ZA2->(dbGoTop())
	ZA2->(dbseek(xFilial("ZA2")+RetCodUsr()))

	If !ZA2->(Found())
		ApMsgAlert("Usuário sem acesso cadastrado." + CRLF +;
				   "Entre em contato com o responsável para verificar seu acesso a rotina.","[A10002] - Controle de Acesso")
		Return
	Else
		If ZA2->ZA2_ATIVO == "S"
		 	aStatBtn := {	If(ZA2->ZA2_AP_PRD=="S",.T.,.F.),;
							If(ZA2->ZA2_AP_PRE=="S",.T.,.F.),;
							If(ZA2->ZA2_AP_PNR=="S",.T.,.F.),;
							If(ZA2->ZA2_AP_PNR=="S",.T.,.F.),;
							If(ZA2->ZA2_AP_GAN=="S",.T.,.F.),;
							If(ZA2->ZA2_ENCERR=="S",.T.,.F.),;
							If(ZA2->ZA2_ETIQUE=="S",.T.,.F.),;
							.T.}
		Else
			ApMsgAlert("Usuário não esta ativo." + CRLF +;
					   "Entre em contato com o responsável para verificar seu acesso a rotina.","[A10002] - Controle de Acesso")
			Return
		EndIf

	EndIf

	oTFont := TFont():New('Arial',,16,,.T.)

	// Inicia a construção da tela
	_aObjects := {}
	AADD(_aObjects, { 0, 55, .T., .F. })
	AADD(_aObjects, { 0, 190, .T., .F. })

	_aInfo := {_aSizeAut[1],_aSizeAut[2],_aSizeAut[3],_aSizeAut[4],3,3}

	_aPosObj := MsObjSize(_aInfo,_aObjects)
	_aPosGet := MsObjGetPos(_aSizeAut[3]-_aSizeAut[1],310,;
							{{5,55,105,155,205,255},;
							{5,30,60,70,160,185,205,213},;
							{5,35,50,70},;
							{5,30,55,80,105,130,155,180},;
							{5,30,55,80,105,130,155,180,205,230}})
	If _aSizeAut[4] < 321.5
		_nTamBt := 75
	Endif

	DEFINE MSDIALOG oDlg FROM _aSizeAut[7],0 TO _aSizeAut[6],_aSizeAut[5] TITLE "[A10002] - Apontamentos" Of oMainWnd PIXEL
	@008,010 TO 302,095 LABEL "[ Opções ]" OF oDlg PIXEL
	oBtProd		:= TButton():New(020,015,"Produção"				,oDlg,{|| fBtProd() }	, 075,030,,oTFont,.F.,.T.,.F.,,.F.,,,.F. )
	oBtPerRec	:= TButton():New(054,015,"Sub-Produto"			,oDlg,{|| fBtRec() }	, 075,030,,oTFont,.F.,.T.,.F.,,.F.,,,.F. )
	oBtPerNRec	:= TButton():New(088,015,"Perda PA"				,oDlg,{|| fBtNaoRec() }	, 075,030,,oTFont,.F.,.T.,.F.,,.F.,,,.F. )
	oBtPerMP	:= TButton():New(122,015,"Perda MP"				,oDlg,{|| fBtPrdMP() }	, 075,030,,oTFont,.F.,.T.,.F.,,.F.,,,.F. )
	oBtGaPrd	:= TButton():New(156,015,"Ganho de Produção"	,oDlg,{|| fBtGaPrd() }	, 075,030,,oTFont,.F.,.T.,.F.,,.F.,,,.F. )
	oBtEncerra	:= TButton():New(190,015,"Encerra OP"			,oDlg,{|| fBtEncOp() }	, 075,030,,oTFont,.F.,.T.,.F.,,.F.,,,.F. )
	oBtEtiq 	:= TButton():New(224,015,"Etiqueta"				,oDlg,{|| U_Apcp103() }	, 075,030,,oTFont,.F.,.T.,.F.,,.F.,,,.F. )

	oBtSair 	:= TButton():New(260,015, "Sair", oDlg,{|| oDlg:End() }, 075,035,,oTFont,.F.,.T.,.F.,,.F.,,,.F. )

	// Na entrada da tela, deixa somente o botão Sair habilitado
	fStaBtn(aStatBtn)

	// Área com informações da OP
	@008,105 TO 075,600 LABEL "[ Informações da OP ]" OF oDlg PIXEL
	TSay():New(018,115,{|| "OP: " }, oDlg,,_oFont18,,,,.T.,CLR_BLACK,CLR_WHITE,100,120)
	_oGetOP := TGet():New(018,155,{|u| if(PCount()>0,_cOP:=u,_cOp)}, oDlg,100,11,'@!', { || fOP() },,,_oFont18,,,.T.,,, {|| lVerOp } ,,,,.F.,,"SC2",_cOP)
	TGet():New(-10,-400,{|u| if(PCount()>0,_cCpoEsc:=u,_cCpoEsc)}, oDlg,100,11,'@!', { || .T. },,,_oFont18,,,.T.,,, {|| .F. } ,,,,.F.,,,_cCpoEsc)
	TSay():New(036,115,{|| "Produto: " }, oDlg,,_oFont18,,,,.T.,CLR_BLACK,CLR_WHITE,100,120)
	TGet():New(036,155,{|u| if(PCount()>0,_cProd:=u,_cProd)}, oDlg,100,11,'@!', { || .T. },,,_oFont18,,,.T.,,, {|| .F. } ,,,,.F.,,"SD4SB1",_cProd)
	TGet():New(036,255,{|u| if(PCount()>0,_cDesPrd:=u,_cDesPrd)}, oDlg,250,11,'@!', { || .T. },,,_oFont18,,,.T.,,, {|| .F. } ,,,,.F.,,,_cDesPrd)
	TSay():New(054,115,{|| "Lote: " }, oDlg,,_oFont18,,,,.T.,CLR_BLACK,CLR_WHITE,100,120)
	TGet():New(054,155,{|u| if(PCount()>0,_cLote:=u,_cLote)}, oDlg,80,11,'@!', { || .T. },,,_oFont18,,,.T.,,, {|| .F. } ,,,,.F.,,,_cLote)
	TSay():New(054,240,{|| "Quant. OP: " }, oDlg,,_oFont18,,,,.T.,CLR_BLACK,CLR_WHITE,100,120)
	TGet():New(054,290,{|u| if(PCount()>0,_nQtdOp:=u,_nQtdOp)}, oDlg,80,11,PesqPict("SC2","C2_QUANT"), { || .T. },,,_oFont18,,,.T.,,, {|| .F. } ,,,,.F.,,,CVALTOCHAR(_nQtdOp))
	TSay():New(054,377,{|| "Saldo OP: " }, oDlg,,_oFont18,,,,.T.,CLR_BLACK,CLR_WHITE,100,120)
	TGet():New(054,423,{|u| if(PCount()>0,nSldOp:=u,nSldOp)}, oDlg,80,11,PesqPict("SC2","C2_QUANT"), { || .T. },,,_oFont18,,,.T.,,, {|| .F. } ,,,,.F.,,,CVALTOCHAR(nSldOp))

	_oGetOP:SetFocus()

	// Painel de apontamento de produção
	//******************************************************************************************************
	oProducao := tPanel():New(080,105,"",oDlg,oTFont,.T.,,CLR_WHITE,CLR_WHITE,600,200,.F.,.T.)
	@005,000 TO 200,480 LABEL "[ Apontamento de Produção ]" OF oProducao PIXEL

	oSayQtP := TSay():New(028,010,{|| "Qtde 1ª UM: " }, oProducao,,_oFont18,,,,.T.,CLR_BLACK,CLR_WHITE,100,120)
	oGetQtP := TGet():New(028,090,{|u| if(PCount()>0,nQtdAp1Um:=u,nQtdAp1Um)}, oProducao,100,11,PesqPict("SD3","D3_QUANT"), { || Conv2() },,,_oFont18,,,.T.,,, {|| .T. } ,,,,.F.,,,CVALTOCHAR(nQtdAp1Um))
	oSayQtU := TSay():New(044,010,{|| "Qtde 2ª UM: " }, oProducao,,_oFont18,,,,.T.,CLR_BLACK,CLR_WHITE,100,120)
	oGetQtU := TGet():New(044,090,{|u| if(PCount()>0,nQtdAp2Um:=u,nQtdAp2Um)}, oProducao,100,11,PesqPict("SD3","D3_QUANT"), { || Conv1() },,,_oFont18,,,.T.,,, {|| !Empty(SB1->B1_SEGUM) } ,,,,.F.,,,CVALTOCHAR(nQtdAp2Um))
	oSayDtI := TSay():New(060,010,{|| "Dt Inicial: " }, oProducao,,_oFont18,,,,.T.,CLR_BLACK,CLR_WHITE,100,120)
	oGetDtI := TGet():New(060,090,{|u| if(PCount()>0,_dIniAp:=u,_dIniAp)}, oProducao,60,11,, { || .T. },,,_oFont18,,,.T.,,, {|| .F. } ,,,,.F.,,,DTOC(_dIniAp))
	oSayHrI := TSay():New(060,210,{|| "Hr Inicial: " }, oProducao,,_oFont18,,,,.T.,CLR_BLACK,CLR_WHITE,100,120)
	oGetHrI := TGet():New(060,260,{|u| if(PCount()>0,_cHrIAp:=u,_cHrIAp)}, oProducao,50,11,, { || .T. },,,_oFont18,,,.T.,,, {|| .F. } ,,,,.F.,,,_cHrIAp)
	oSayDtF := TSay():New(076,010,{|| "Dt Final: " }, oProducao,,_oFont18,,,,.T.,CLR_BLACK,CLR_WHITE,100,120)
	oGetDtF := TGet():New(076,090,{|u| if(PCount()>0,_dFimAp:=u,_dFimAp)}, oProducao,60,11,, { || .T. },,,_oFont18,,,.T.,,, {|| .F. } ,,,,.F.,,,DTOC(_dFimAp))
	oSayHrF := TSay():New(076,210,{|| "Hr Final: " }, oProducao,,_oFont18,,,,.T.,CLR_BLACK,CLR_WHITE,100,120)
	oGetHrF := TGet():New(076,260,{|u| if(PCount()>0,_cHrFAp:=u,_cHrFAp)}, oProducao,50,11,, { || .T. },,,_oFont18,,,.T.,,, {|| .F. } ,,,,.F.,,,_cHrFAp)

	oBtConfAP := TButton():New(102,010, "Confirmar", oProducao,{|| fConfProd() }, 70,40,,oTFont,.F.,.T.,.F.,,.F.,,,.F. )
	TButton():New(102,085, "Fechar", oProducao,{ || fStaBtn(aStatBtn), AjustaHR(), oProducao:lVisibleControl:=.F., lVerOp := .T., _oGetOP:CtrlRefresh() }, 70,40,,oTFont,.F.,.T.,.F.,,.F.,,,.F. )

	// Inicia o painel escondido
	oProducao:lVisibleControl := .F.
	//******************************************************************************************************

	// Painel de apontamento de Sub-Produto
	//******************************************************************************************************
	oPerRec := tPanel():New(080,105,"",oDlg,oTFont,.T.,,CLR_WHITE,CLR_WHITE,600,200,.F.,.T.)
	@005,000 TO 200,480 LABEL "[ Sub-Produto ]" OF oPerRec PIXEL
	TSay():New(028,010,{|| "Sub-Produto: " }, oPerRec,,_oFont18,,,,.T.,CLR_BLACK,CLR_WHITE,100,120)
	TSay():New(044,010,{|| "Descrição: "   }, oPerRec,,_oFont18,,,,.T.,CLR_BLACK,CLR_WHITE,100,120)
	TGet():New(028,070,{|u| if(PCount()>0,cProdSub:=u,cProdSub)}, oPerRec,100,11,'@!', { || fPrdDest() },,,_oFont18,,,.T.,,, {|| .T. } ,,,,.F.,,"SD4NEG",cProdSub)
	TGet():New(044,070,{|u| if(PCount()>0,cDescSub:=u,cDescSub)}, oPerRec,250,11,'@!', { || .T. },,,_oFont18,,,.T.,,, {|| .F. } ,,,,.F.,,,cDescSub)

	oSaySB1 := TSay():New(060,010,{|| "Qtde 1ª UM: " }, oPerRec,,_oFont18,,,,.T.,CLR_BLACK,CLR_WHITE,100,120)
	oGetSB1 := TGet():New(060,070,{|u| if(PCount()>0,nQtdAp1Um:=u,nQtdAp1Um)}, oPerRec,100,11,PesqPict("SH6","H6_QTDPERD"), { || ConvMP2(cProdSub) },,,_oFont18,,,.T.,,, {|| ! Empty(cProdSub) } ,,,,.F.,,,CVALTOCHAR(nQtdAp1Um))

	oSaySB2 := TSay():New(076,010,{|| "Qtde 2ª UM: " }, oPerRec,,_oFont18,,,,.T.,CLR_BLACK,CLR_WHITE,100,120)
	oGetSB2 := TGet():New(076,070,{|u| if(PCount()>0,nQtdAp2Um:=u,nQtdAp2Um)}, oPerRec,100,11,PesqPict("SH6","H6_QTDPERD"), { || ConvMP1(cProdSub) },,,_oFont18,,,.T.,,, {|| !Empty(SB1->B1_SEGUM) .And.  ! Empty(cProdSub) } ,,,,.F.,,,CVALTOCHAR(nQtdAp2Um))

	oBtConfPR := TButton():New(121,010, "Confirmar", oPerRec,{|| FwMsgRun(, {|| fConfRec() }, "Processando...", "Gerando movimentos para sub-produto.") }, 70,40,,oTFont,.F.,.T.,.F.,,.F.,,,.F. )
	TButton():New(121,085, "Fechar", oPerRec,{|| fStaBtn(aStatBtn), closeSubProduto(), AjustaHR() ,oPerRec:lVisibleControl:=.F., lVerOp := .T., _oGetOP:CtrlRefresh() }, 70,40,,oTFont,.F.,.T.,.F.,,.F.,,,.F. )

	// Inicia o painel escondido
	oPerRec:lVisibleControl := .F.
	//******************************************************************************************************

	// Painel de apontamento de perda não recuperável
	//******************************************************************************************************
	oPerNRec := tPanel():New(080,105,"",oDlg,oTFont,.T.,,CLR_WHITE,CLR_WHITE,600,200,.F.,.T.)
	@005,000 TO 200,480 LABEL "[ Perda Não Recuperável ]" OF oPerNRec PIXEL
//	oSayQPN := TSay():New(015,010,{|| "Qtde Perda: " }, oPerNRec,,_oFont18,,,,.T.,CLR_BLACK,CLR_WHITE,100,120)
//	oGetQPN := TGet():New(015,065,{|u| if(PCount()>0,_nQtdPerd:=u,_nQtdPerd)}, oPerNRec,100,11,PesqPict("SH6","H6_QTDPERD"), { || .T. },,,_oFont18,,,.T.,,, {|| .T. } ,,,,.F.,,,CVALTOCHAR(_nQtdPerd))

	oSayQPN := TSay():New(028,010,{|| "Qtde 1ª UM: " }, oPerNRec,,_oFont18,,,,.T.,CLR_BLACK,CLR_WHITE,100,120)
	oGetQPN := TGet():New(028,090,{|u| if(PCount()>0,nQtdAp1Um:=u,nQtdAp1Um)}, oPerNRec,100,11,PesqPict("SH6","H6_QTDPERD"), { || Conv2() },,,_oFont18,,,.T.,,, {|| .T. } ,,,,.F.,,,CVALTOCHAR(nQtdAp1Um))

	oSayQP2 := TSay():New(044,010,{|| "Qtde 2ª UM: " }, oPerNRec,,_oFont18,,,,.T.,CLR_BLACK,CLR_WHITE,100,120)
	oGetQP2 := TGet():New(044,090,{|u| if(PCount()>0,nQtdAp2Um:=u,nQtdAp2Um)}, oPerNRec,100,11,PesqPict("SH6","H6_QTDPERD"), { || Conv1() },,,_oFont18,,,.T.,,, {|| !Empty(SB1->B1_SEGUM) } ,,,,.F.,,,CVALTOCHAR(nQtdAp2Um))

	oSayMPN := TSay():New(060,010,{|| "Motivo: " }, oPerNRec,,_oFont18,,,,.T.,CLR_BLACK,CLR_WHITE,100,120)
	oGetMPN := TGet():New(060,090,{|u| if(PCount()>0,_cObs:=u,_cObs)}, oPerNRec,50,11,"@!", { || .T. },,,_oFont18,,,.T.,,, {|| .T. } ,,,,.F.,,"43",_cObs)


	oBtConfPN := TButton():New(105,010, "Confirmar", oPerNRec,{|| fConfNRec() }, 70,40,,oTFont,.F.,.T.,.F.,,.F.,,,.F. )
	TButton():New(105,085, "Fechar", oPerNRec,{ || fStaBtn(aStatBtn) , AjustaHR() ,oPerNRec:lVisibleControl:=.F., lVerOp := .T., _oGetOP:CtrlRefresh() }, 70,40,,oTFont,.F.,.T.,.F.,,.F.,,,.F. )

	// Inicia o painel escondido
	oPerNRec:lVisibleControl := .F.
	//******************************************************************************************************


	// Painel de apontamento de perda não recuperável
	//******************************************************************************************************
	oPerdaMP := tPanel():New(080,105,"",oDlg,oTFont,.T.,,CLR_WHITE,CLR_WHITE,600,200,.F.,.T.)
	@005,000 TO 200,480 LABEL "[ Perda de Materia Prima ]" OF oPerdaMP PIXEL

	TSay():New(028,010,{|| "Produto: " }, oPerdaMP,,_oFont18,,,,.T.,CLR_BLACK,CLR_WHITE,100,120)
	TSay():New(044,010,{|| "Descrição: " }, oPerdaMP,,_oFont18,,,,.T.,CLR_BLACK,CLR_WHITE,100,120)
	oSayMPP := TGet():New(028,070,{|u| if(PCount()>0,cProdPerda:=u,cProdPerda)}, oPerdaMP,100,11,'@!', { || fProdMP() },,,_oFont18,,,.T.,,, {|| .T. } ,,,,.F.,,"SD4APT",cProdPerda)
	TGet():New(044,070,{|u| if(PCount()>0,cDescPerda:=u,cDescPerda)}, oPerdaMP,250,11,'@!', { || .T. },,,_oFont18,,,.T.,,, {|| .F. } ,,,,.F.,,,cDescPerda)

	oSayMPL := TSay():New(060,010,{|| "Lote" }, oPerdaMP,,_oFont18,,,,.T.,CLR_BLACK,CLR_WHITE,100,120)
	oGetMPL := TGet():New(060,070,{|u| if(PCount()>0,cPerdaLoteCtl:=u,cPerdaLoteCtl)}, oPerdaMP,100,11,, { || .T. },,,_oFont18,,,.T.,,, {|| ! Empty(cProdPerda) .And. SB1->B1_RASTRO == "L" } ,,,,.F.,,,"CPERDALOTECTL")

	TBtnBmp2():New( 60 *2 ,190 *2 ,30,30,'lupa',,,,{|| ShowF4()  },oPerdaMP,"Consulta Lote",{|| ! Empty(cProdPerda) .And. SB1->B1_RASTRO == "L"  },.T.)

	oSayMP1 := TSay():New(076,010,{|| "Qtde 1ª UM: " }, oPerdaMP,,_oFont18,,,,.T.,CLR_BLACK,CLR_WHITE,100,120)
	oGetMP1 := TGet():New(076,070,{|u| if(PCount()>0,nQtdAp1Um:=u,nQtdAp1Um)}, oPerdaMP,100,11,PesqPict("SH6","H6_QTDPERD"), { || ConvMP2(cProdPerda) },,,_oFont18,,,.T.,,, {|| ! Empty(cProdPerda) } ,,,,.F.,,,CVALTOCHAR(nQtdAp1Um))

	oSayMP2 := TSay():New(092,010,{|| "Qtde 2ª UM: " }, oPerdaMP,,_oFont18,,,,.T.,CLR_BLACK,CLR_WHITE,100,120)
	oGetMP2 := TGet():New(092,070,{|u| if(PCount()>0,nQtdAp2Um:=u,nQtdAp2Um)}, oPerdaMP,100,11,PesqPict("SH6","H6_QTDPERD"), { || ConvMP1(cProdPerda) },,,_oFont18,,,.T.,,, {|| !Empty(SB1->B1_SEGUM) .And.  ! Empty(cProdPerda) } ,,,,.F.,,,CVALTOCHAR(nQtdAp2Um))

	oSayMP3 := TSay():New(108,010,{|| "Motivo: " }, oPerdaMP,,_oFont18,,,,.T.,CLR_BLACK,CLR_WHITE,100,120)
	oGetMP3 := TGet():New(108,070,{|u| if(PCount()>0,cMotPerda:=u,cMotPerda)}, oPerdaMP,50,11,"@!", { || .T. },,,_oFont18,,,.T.,,, {||  ! Empty(cProdPerda) } ,,,,.F.,,"43",cMotPerda)

	oBtConfMP := TButton():New(145,010, "Confirmar", oPerdaMP,{|| FwMsgRun(, {|| fConfPerdaMP() }, "Processando...", "Gravando os movimentos") }, 70,40,,oTFont,.F.,.T.,.F.,,.F.,,,.F. )
	TButton():New(145,085, "Fechar", oPerdaMP,{ || fStaBtn(aStatBtn) , closePerdaMP(), AjustaHR() ,oPerdaMP:lVisibleControl:=.F., lVerOp := .T., _oGetOP:CtrlRefresh() }, 70,40,,oTFont,.F.,.T.,.F.,,.F.,,,.F. )

	// Inicia o painel escondido
	oPerdaMP:lVisibleControl := .F.
	//******************************************************************************************************


	// Painel de Ganho de Produção
	//******************************************************************************************************
	oGanhoPr := tPanel():New(080,105,"",oDlg,oTFont,.T.,,CLR_WHITE,CLR_WHITE,600,200,.F.,.T.)
	@005,000 TO 200,480 LABEL "[ Ganho de Produção ]" OF oGanhoPr PIXEL

	oSayQtPGa := TSay():New(028,010,{|| "Qtde 1ª UM: " }, oGanhoPr,,_oFont18,,,,.T.,CLR_BLACK,CLR_WHITE,100,120)
	oGetQtPGa := TGet():New(028,090,{|u| if(PCount()>0,nQtdAp1Um:=u,nQtdAp1Um)}, oGanhoPr,100,11,PesqPict("SD3","D3_QUANT"), { || Conv2() },,,_oFont18,,,.T.,,, {|| .T. } ,,,,.F.,,,CVALTOCHAR(nQtdAp1Um))
	oSayQtUGa := TSay():New(044,010,{|| "Qtde 2ª UM: " }, oGanhoPr,,_oFont18,,,,.T.,CLR_BLACK,CLR_WHITE,100,120)
	oGetQtUGa := TGet():New(044,090,{|u| if(PCount()>0,nQtdAp2Um:=u,nQtdAp2Um)}, oGanhoPr,100,11,PesqPict("SD3","D3_QUANT"), { || Conv1() },,,_oFont18,,,.T.,,, {|| .T. } ,,,,.F.,,,CVALTOCHAR(nQtdAp2Um))
	oSayDtIGa := TSay():New(060,010,{|| "Dt Inicial: " }, oGanhoPr,,_oFont18,,,,.T.,CLR_BLACK,CLR_WHITE,100,120)
	oGetDtIGa := TGet():New(060,090,{|u| if(PCount()>0,_dIniAp:=u,_dIniAp)}, oGanhoPr,60,11,, { || .T. },,,_oFont18,,,.T.,,, {|| .F. } ,,,,.F.,,,DTOC(_dIniAp))
	oSayHrIGa := TSay():New(060,210,{|| "Hr Inicial: " }, oGanhoPr,,_oFont18,,,,.T.,CLR_BLACK,CLR_WHITE,100,120)
	oGetHrIGa := TGet():New(060,260,{|u| if(PCount()>0,_cHrIAp:=u,_cHrIAp)}, oGanhoPr,50,11,, { || .T. },,,_oFont18,,,.T.,,, {|| .F. } ,,,,.F.,,,_cHrIAp)
	oSayDtFGa := TSay():New(076,010,{|| "Dt Final: " }, oGanhoPr,,_oFont18,,,,.T.,CLR_BLACK,CLR_WHITE,100,120)
	oGetDtFGa := TGet():New(076,090,{|u| if(PCount()>0,_dFimAp:=u,_dFimAp)}, oGanhoPr,60,11,, { || .T. },,,_oFont18,,,.T.,,, {|| .F. } ,,,,.F.,,,DTOC(_dFimAp))
	oSayHrFGa := TSay():New(076,210,{|| "Hr Final: " }, oGanhoPr,,_oFont18,,,,.T.,CLR_BLACK,CLR_WHITE,100,120)
	oGetHrFGa := TGet():New(076,260,{|u| if(PCount()>0,_cHrFAp:=u,_cHrFAp)}, oGanhoPr,50,11,, { || .T. },,,_oFont18,,,.T.,,, {|| .F. } ,,,,.F.,,,_cHrFAp)

	oBtConfAPG := TButton():New(102,010, "Confirmar", oGanhoPr,{|| fConfGprod() }, 70,40,,oTFont,.F.,.T.,.F.,,.F.,,,.F. )
	TButton():New(102,085, "Fechar", oGanhoPr,{ || fStaBtn(aStatBtn), AjustaHR() ,oGanhoPr:lVisibleControl:=.F., lVerOp := .T., _oGetOP:CtrlRefresh() }, 70,40,,oTFont,.F.,.T.,.F.,,.F.,,,.F. )

	// Inicia o painel escondido
	oGanhoPr:lVisibleControl := .F.
	//******************************************************************************************************

	// Painel de Encerramento da OP
	//******************************************************************************************************
	oEncOp := tPanel():New(080,105,"",oDlg,oTFont,.T.,,CLR_WHITE,CLR_WHITE,600,200,.F.,.T.)
	@005,000 TO 200,496 LABEL "[ Encerramento da OP ]" OF oEncOp PIXEL

	TSay():New(018,010,{|| "Empenho" }, oEncOp,,_oFont18,,,,.T.,CLR_BLACK,CLR_WHITE,100,120)
	TSay():New(018,165,{|| "Perda"   }, oEncOp,,_oFont18,,,,.T.,CLR_BLACK,CLR_WHITE,100,120)
	TSay():New(018,282,{|| "Destino" }, oEncOp,,_oFont18,,,,.T.,CLR_BLACK,CLR_WHITE,100,120)

	oListSD4 := TListBox():New(030,010,{|u|if(Pcount()>0,nListSD4:=u,nListSD4)},aListSD4,150,110, /*{||Alert("Mudou de linha")}*/,oEncOp,,,,.T.,,,_oFont18C)
    oListSH6 := TListBox():New(030,165,{|u|if(Pcount()>0,nListSH6:=u,nListSH6)},aListSH6,113,110, /*{||Alert("Mudou de linha")}*/,oEncOp,,,,.T.,,,_oFont18C)
    oListSBC := TListBox():New(030,282,{|u|if(Pcount()>0,nListSBC:=u,nListSBC)},aListSBC,113,110, /*{||Alert("Mudou de linha")}*/,oEncOp,,,,.T.,,,_oFont18C)
	oBtConfAPG := TButton():New(152,010, "Confirmar", oEncOp,{|| fEncerra() }, 70,40,,oTFont,.F.,.T.,.F.,,.F.,,,.F. )
	TButton():New(152,085, "Fechar", oEncOp,{ || fStaBtn(aStatBtn), AjustaHR(), oEncOp:lVisibleControl:=.F., lVerOp := .T., _oGetOP:CtrlRefresh() }, 70,40,,oTFont,.F.,.T.,.F.,,.F.,,,.F. )

	// Inicia o painel escondido
	oEncOp:lVisibleControl := .F.
	//******************************************************************************************************

	ACTIVATE MSDIALOG oDlg CENTERED

Return


static function AtuSayQuants(oSayUm1, oSayUm2, lBack)

	default lBack := .F.

	IF lBack
		oSayUm1:SetText("Qtde 1ª UM: ")
		oSayUm2:SetText("Qtde 2ª UM: ")

		return .T.
	EndIF

	oSayUm1:SetText("Qtde 1ª UM ("+SB1->B1_UM+"): ")
	IF ! empty(SB1->B1_SEGUM)
		oSayUm2:SetText("Qtde 2ª UM ("+SB1->B1_SEGUM+"): ")
	Else
		oSayUm2:SetText("---------------------")
	EndIF

return .T.

/*/{Protheus.doc} fBtProd
Função de tratamento do botão Produção
@type function
@author Funaki
@since 26/04/2018
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function fBtProd()

	Local nSetup := 0.01
	Local _cHrAux := Substr(TIME(),1,5)

	// Verifica o tempo de setup para calcular o horário inicial
	dbSelectArea("SG2")
	SG2->(dbSetOrder(1))
	SG2->(dbGoTop())
	If SG2->(dbSeek(xFilial("SG2")+_cProd))
		nSetup := SG2->G2_SETUP
	Endif

	nQtdAp1Um	:= 1.00
	Conv2()

	_cHrAux := StrZero((SubHoras(_cHrIAp,nSetup)) * 100,4)
	_cHrIAp := Substr(_cHrAux,1,2) + ":" + Substr(_cHrAux,3,2)

	_cHrFAp := StrTran(_cHrFAp,".",":")

	lVerOp := .F.
	_oGetOP:CtrlRefresh()

	// Habilita o painel de apontamento de produção
	oProducao:lVisibleControl := .T.

	// Desabilita os botões
	fStaBtn()

Return

/*/{Protheus.doc} fBtRec
Função de tratamento do botão Sub-Produto
@type function
@author Funaki
@since 26/04/2018
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function fBtRec()

	Local nSetup	:= 0.01
	Local _cHrAux	:= Substr(TIME(),1,5)

	Local aSubProdutos

	// Verifica o tempo de setup para calcular o horário inicial
	dbSelectArea("SG2")
	SG2->(dbSetOrder(1))
	SG2->(dbGoTop())
	If SG2->(dbSeek(xFilial("SG2")+_cProd))
		nSetup := SG2->G2_SETUP
	Endif

	nQtdAp1Um	:= 0.00
	nQtdAp2Um	:= 0.00

	_cHrAux := StrZero((SubHoras(_cHrIAp,nSetup)) * 100,4)
	_cHrIAp := Substr(_cHrAux,1,2) + ":" + Substr(_cHrAux,3,2)

	_cHrFAp := StrTran(_cHrFAp,".",":")

	lVerOp := .F.
	_oGetOP:CtrlRefresh()

	// Habilita o painel de apontamento de Sub-Produto
	oPerRec:lVisibleControl := .T.

	// Desabilita os botões
	fStaBtn()

Return

/*/{Protheus.doc} fBtNaoRec
Função de tratamento do botão Perda Não Recuperável
@type function
@author Funaki
@since 26/04/2018
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function fBtNaoRec()

	Local nSetup	:= 0.01
	Local _cHrAux	:= Substr(TIME(),1,5)

	// Verifica o tempo de setup para calcular o horário inicial
	dbSelectArea("SG2")
	SG2->(dbSetOrder(1))
	SG2->(dbGoTop())
	If SG2->(dbSeek(xFilial("SG2")+_cProd))
		nSetup := SG2->G2_SETUP
	Endif

	nQtdAp1Um	:= 0.00
	nQtdAp2Um	:= 0.00

	_cHrAux := StrZero((SubHoras(_cHrIAp,nSetup)) * 100,4)
	_cHrIAp := Substr(_cHrAux,1,2) + ":" + Substr(_cHrAux,3,2)

	_cHrFAp := StrTran(_cHrFAp,".",":")

	lVerOp := .F.
	_oGetOP:CtrlRefresh()

	// Habilita o painel de apontamento de perda não recuperável
	oPerNRec:lVisibleControl := .T.

	// Desabilita os botões
	fStaBtn()

Return


static function fBtPrdMP()

	Local nSetup	:= 0.01
	Local _cHrAux	:= Substr(TIME(),1,5)

	Local aEmpenhos := {}

	// Verifica o tempo de setup para calcular o horário inicial
	dbSelectArea("SG2")
	SG2->(dbSetOrder(1))
	SG2->(dbGoTop())
	If SG2->(dbSeek(xFilial("SG2")+_cProd))
		nSetup := SG2->G2_SETUP
	Endif

	nQtdAp1Um	:= 0.00
	nQtdAp2Um	:= 0.00

	_cHrAux := StrZero((SubHoras(_cHrIAp,nSetup)) * 100,4)
	_cHrIAp := Substr(_cHrAux,1,2) + ":" + Substr(_cHrAux,3,2)

	_cHrFAp := StrTran(_cHrFAp,".",":")

	lVerOp := .F.
	_oGetOP:CtrlRefresh()

	// Habilita o painel de apontamento de perda não recuperável
	oPerdaMP:lVisibleControl := .T.


	//verifica se quantos produtos que geram subproduto existe empenhados
	aEmpenhos := getEmpenhoAptos()
	IF len(aEmpenhos) == 1
		cProdPerda := aEmpenhos[1][1]
	EndIF

	// Desabilita os botões
	fStaBtn()

	Set Key VK_F4 TO ShowF4()

	oSayMPP:setFocus()

return


/*/{Protheus.doc} fBtGaPrd
//TODO Função executada noi botão Ganho de produção
@author Mario L. B. Faria
@since 28/06/2018
@version 1.0
/*/
Static Function fBtGaPrd()

	Local nSetup := 0.01
	Local _cHrAux := Substr(TIME(),1,5)

	// Verifica o tempo de setup para calcular o horário inicial
	dbSelectArea("SG2")
	SG2->(dbSetOrder(1))
	SG2->(dbGoTop())
	If SG2->(dbSeek(xFilial("SG2")+_cProd))
		nSetup := SG2->G2_SETUP
	Endif

	_cHrAux := StrZero(SubHoras(_cHrIAp,nSetup) * 100,4)
	_cHrIAp := Substr(_cHrAux,1,2) + ":" + Substr(_cHrAux,3,2)

	_cHrFAp := StrTran(_cHrFAp,".",":")

	lVerOp := .F.
	_oGetOP:CtrlRefresh()

	// Habilita o painel de apontamento de produção
	oGanhoPr:lVisibleControl := .T.

	// Desabilita os botões
	fStaBtn()

Return

/*/{Protheus.doc} fBtEncOp
//TODO Função executada no botal Enxerra OP
@author Mario L. B. Faria
@since 16/07/2018
@version 1.0
/*/
Static Function fBtEncOp()

	Local cQuery	:= ""
	Local aAlAux	:= ""
	Local lCont		:= .T.

	dbSelectArea("SC2")
	SC2->(dbSetOrder(1))
	SC2->(dbGoTop())
	If SC2->(dbSeek(xFilial("SC2")+_cOP))
		If !Empty(SC2->C2_DATRF)
			ApMSgInfo("Esta OP já esta encerrada!","[A10002] - Encerra OP")
			lCont := .F.
		EndIf
	EndIf

	If lCont

		aListSD4 := {}
		aListSH6 := {}
		aListSBC := {}

		aAdd(aListSD4,"Produto            Saldo    Quantid") 
		aAdd(aListSH6,"Produto            Quantid") 
		aAdd(aListSBC,"Produto Destino    Quantid") 

		//Busca SD4
		//*******************************************
		cQuery := "	SELECT " + CRLF
		cQuery += "	    D4_COD, D4_QUANT, D4_QTDEORI " + CRLF
		cQuery += "	FROM " + RetSqlName("SD4") + " SD4 " + CRLF
		cQuery += "	WHERE " + CRLF
		cQuery += "	        D4_FILIAL = '" + xFilial("SD4") + "' " + CRLF
		cQuery += "	    AND D4_OP = '" + _cOp + "' " + CRLF
		cQuery += "	    AND SD4.D_E_L_E_T_ = ' ' " + CRLF

		cQuery := ChangeQuery(cQuery)
		aAlAux := MPSysOpenQuery(cQuery)

		If !(aAlAux)->(Eof())
			While !(aAlAux)->(Eof())
				aAdd(aListSD4,(aAlAux)->D4_COD + " " + Transform((aAlAux)->D4_QUANT,"@E 9,999.99") + Space(3) + Transform((aAlAux)->D4_QTDEORI,"@E 9,999.99"))
				(aAlAux)->(dbSkip())
			EndDo
		Else
			aAdd(aListSD4,"Sem informações p/ exibir !")
		EndIf

		(aAlAux)->(dbCloseArea())
		//*******************************************

		//Busca SH6
		//*******************************************
		cQuery := "	SELECT H6_PRODUTO, SUM(H6_QTDPERD) QTDPERD " + CRLF
		cQuery += "	FROM " + RetSqlName("SH6") + " SH6 " + CRLF
		cQuery += "	WHERE " + CRLF
		cQuery += "	        H6_FILIAL = '" + xFilial("SH6") + "' " + CRLF
		cQuery += "	    AND H6_OP = '" + _cOp + "' " + CRLF
		cQuery += "	    AND SH6.D_E_L_E_T_ = ' ' " + CRLF
		cQuery += "	GROUP BY H6_PRODUTO " + CRLF

		cQuery := ChangeQuery(cQuery)
		aAlAux := MPSysOpenQuery(cQuery)

		If !(aAlAux)->(Eof())
			While !(aAlAux)->(Eof())
				aAdd(aListSH6,(aAlAux)->H6_PRODUTO + Space(3) + Transform((aAlAux)->QTDPERD,"@E 9,999.99"))
				(aAlAux)->(dbSkip())
			EndDo
		Else
			aAdd(aListSH6,"Sem informações p/ exibir!")
		EndIf

		(aAlAux)->(dbCloseArea())
		//*******************************************

		//Busca SBC
		//*******************************************
		cQuery := "	SELECT " + CRLF
		cQuery += "		BC_CODDEST, SUM(BC_QTDDEST) QTDDEST " + CRLF
		cQuery += "	FROM " + RetSqlName("SBC") + " SBC " + CRLF
		cQuery += "	WHERE " + CRLF
		cQuery += "	        BC_FILIAL = '" + xFilial("SH6") + "' " + CRLF
		cQuery += "	    AND BC_OP = '" + _cOp + "' " + CRLF
		cQuery += "	    AND SBC.D_E_L_E_T_ = ' ' " + CRLF
		cQuery += "	GROUP BY BC_CODDEST " + CRLF

		cQuery := ChangeQuery(cQuery)
		aAlAux := MPSysOpenQuery(cQuery)

		If !(aAlAux)->(Eof())
			While !(aAlAux)->(Eof())
				aAdd(aListSBC,(aAlAux)->BC_CODDEST + Space(3)+ Transform((aAlAux)->QTDDEST,"@E 9,999.99"))
				(aAlAux)->(dbSkip())
			EndDo
		Else
			aAdd(aListSBC,"Sem informações p/ exibir !")
		EndIf

		(aAlAux)->(dbCloseArea())
		//*******************************************

		oListSD4:SetItems(aListSD4)
		oListSH6:SetItems(aListSH6)
		oListSBC:SetItems(aListSBC)

		lVerOp := .F.
		_oGetOP:CtrlRefresh()

		// Habilita o painel de apontamento de produção
		oEncOp:lVisibleControl := .T.

		// Desabilita os botões
		fStaBtn()

	Else
		lVerOp := .T.
		_oGetOP:CtrlRefresh()

		// Desabilita o painel de apontamento de produção
		oEncOp:lVisibleControl := .F.

		// habiliata os botões
		fStaBtn(aStatBtn)
	EndIf



Return

/*/{Protheus.doc} fStaBtn
Função para habilitar/desabilitar os botões
@type function
@author Funaki
@since 13/05/2018
@version 1.0
@param _pStaBtn, ${Array}, (Array com os status dos botões)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function fStaBtn(aStBotao)

	Default aStBotao := {.F.,.F.,.F.,.F.,.F.,.F.,.F.,.T.}

	// Habilita ou desabilita os botões
	IIF(aStBotao[1]	,oBtProd:Enable()		,oBtProd:Disable())
	IIF(aStBotao[2]	,oBtPerRec:Enable()		,oBtPerRec:Disable())
	IIF(aStBotao[3]	,oBtPerNRec:Enable()	,oBtPerNRec:Disable())
	IIF(aStBotao[4]	,oBtPerMP:Enable()		,oBtPerMP:Disable())
	IIF(aStBotao[5]	,oBtGaPrd:Enable()		,oBtGaPrd:Disable())
	IIF(aStBotao[6]	,oBtEncerra:Enable()	,oBtEncerra:Disable())
	IIF(aStBotao[7]	,oBtEtiq:Enable()		,oBtEtiq:Disable())
	IIF(aStBotao[8]	,oBtSair:Enable()		,oBtSair:Disable())

Return

/*/{Protheus.doc} fOP
Função para validação do campo OP
@type function
@author Funaki
@since 26/04/2018
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function fOP()

	Local cAux2Um	:= ""

	If !Empty(_cOP)

		// Verifica se a OP existe
		If ExistCpo("SC2",_cOP)

			// Se encontrar a OP, preenche os campos e habilita os escondidos
			dbSelectArea("SC2")
			SC2->(dbSetOrder(1))
			SC2->(dbGoTop())
			If SC2->(dbSeek(xFilial("SC2")+_cOP))

				If !Empty(SC2->C2_DATRF)
					ApMsgAlert("A OP informada já está encerrada!","[A10002] - Apontamento Produção")
					Return(.F.)
				Endif

				dbSelectArea("SB1")
				SB1->(dbSetOrder(1))
				SB1->(dbGoTop())
				SB1->(dbSeek(xFilial("SB1")+SC2->C2_PRODUTO))

				lConv2 := .T.
				If Empty(SB1->B1_SEGUM)
					lConv2 := .F.
				ElseIf SB1->B1_CONV	== 0
					ApMsgAlert("O fator de conversão está zerado para o produto:"  + CRLF +;
								AllTrim(SB1->B1_COD) + "-" + AllTrim(SB1->B1_DESC),"[A10002] - Apontamento Produção")
					Return(.F.)
				EndIf

				_cProd		:= SC2->C2_PRODUTO
				_cDesPrd	:= SB1->B1_DESC
				nSldOp		:= aSC2Sld()


				// Verifica o lote no campo C2_XLOTE
				If SC2->(FieldPos("C2_XLOTE"))
					_cLote := SC2->C2_XLOTE
				Endif

				_nQtdOp := SC2->C2_QUANT
				_cLocal := SC2->C2_LOCAL

				//muda o titulo dos campos, para informar qual é a unidade de medida (primeira)
				//perda PA
				oSayQPN:SetText("Qtde 1ª UM ("+SB1->B1_UM+"): ")
				//Ganho de produção
				oSayQtPGa:SetText("Qtde 1ª UM ("+SB1->B1_UM+"): ")

				oSayQtP:cCaption 	:= "Qtde 1ª UM ("  + Alltrim(SB1->B1_UM) + "): "
				If Empty(SB1->B1_SEGUM)
					cAux2Um := "----------"
				Else
					cAux2Um := "Qtde 2ª UM ("  + Alltrim(SB1->B1_SEGUM) + "): "
				EndIf
				oSayQtU:cCaption 	:= cAux2Um

				//muda o titulo dos campos, para informar qual é a unidade de medida (segunda)
				//perda PA
				oSayQP2:SetText(cAux2Um)
				//Ganho de produção
				oSayQtUGa:SetText(cAux2Um)

				//Converte na 2ª UM
				Conv2()

				// Habilita os botões
				fStaBtn(aStatBtn)
				oBtProd:SetFocus()

				_nQtd1Um := ConvUm(SC2->C2_PRODUTO,0,1,1)

			Endif

		Else
			Return(.F.)
		Endif

	Else
		// Se está em branco, desabilita os botões
		fStaBtn()
	Endif

Return(.T.)


/*/{Protheus.doc} fProdMP
Atualiza campos relacionados ao produto (descrição e unidades)

@author Rafael Ricardo Vieceli
@since 03/09/2018
@version 1.0
@return logical, verdadeiro

@type function
/*/
Static Function fProdMP()

	// Verifica se o produto informado existe
	IF ! Empty(cProdPerda) .And. ExistCpo("SB1",cProdPerda)
		cDescPerda := Posicione("SB1",1,xFilial("SB1")+cProdPerda,"B1_DESC")
		AtuSayQuants(oSayMP1,oSayMP2)
	Else
		cDescPerda := CriaVar("B1_DESC",.F.)
		AtuSayQuants(oSayMP1,oSayMP2, .T.)
	Endif

Return .T.


Static Function fPrdDest()
	// Verifica se o produto destino existe
	If ! Empty(cProdSub) .And. ExistCpo("SB1",cProdSub)
		cDescSub := Posicione("SB1",1,xFilial("SB1")+cProdSub,"B1_DESC")
		AtuSayQuants(oSaySB1,oSaySB2)
	Else
		cDescSub := CriaVar("B1_DESC",.F.)
		AtuSayQuants(oSaySB1,oSaySB2, .T.)
		return Empty(cProdSub)
	Endif

Return(.T.)

/*/{Protheus.doc} Conv1
//TODO Converte para a 1ª Unidade de Medida na validação do campo
@author Mario L. B. Faria
@since 28/06/2018
@version 1.0
/*/
Static Function Conv1()
	nQtdAp1Um := ConvUm(_cProd,0,nQtdAp2Um,1)
Return .T.

//igual de cima, para para produto generico
Static Function ConvMP1(cProduto)
	nQtdAp1Um := ConvUm(cProduto,0,nQtdAp2Um,1)
Return .T.

/*/{Protheus.doc} Conv2
//TODO Converte para a 2ª Unidade de Medida na validação do campo
@author Mario L. B. Faria
@since 28/06/2018
@version 1.0
/*/
Static Function Conv2()
	If lConv2
		nQtdAp2Um := ConvUm(_cProd,nQtdAp1Um,0,2)
	EndIf
Return .T.

//igual de cima, para para produto generico
Static Function ConvMP2(cProduto)
	If lConv2
		nQtdAp2Um := ConvUm(cProduto,nQtdAp1Um,0,2)
	EndIf
Return .T.

/*/{Protheus.doc} fConfProd
Função de confirmação do apontamento de produção
@type function
@author Funaki
@since 26/04/2018
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function fConfProd()

	Local _aApont	:= {}
	Local aVerTol	:= {}
	Local lCont		:= .F.

	// Verifica se foram preenchidos os campos
	If Empty(_cOP)
		ApMsgAlert("O número da OP deve ser informado!","[A10002] - Apontamento Produção")
		Return(.F.)
	Endif

	If nQtdAp1Um <= 0
		ApMsgAlert("A quantidade na 1ª UM inválida. Verifique o cadastro do produto!","[A10002] - Apontamento Produção")
		Return(.F.)
	Endif

	If lConv2
		If nQtdAp2Um <= 0
			ApMsgAlert("A quantidade na 2ª UM inválida. Verifique o cadastro do produto!","[A10002] - Apontamento Produção")
			Return(.F.)
		EndIf
	Endif

	If temPesagem(_cOP) .And. U_A10001GP(_cOP,"","") == 0
		ApMsgAlert("Não existe nenhuma pesagem para esta OP. Por favor favor efetue ao menos uma pesagem!","[A10002] - Apontamento Produção")
		Return(.F.)
	EndIf

	aVerTol := VerTol()

	If !aVerTol[01]
		ApMsgAlert("A quantidade informada é superior ao permitido!" + CRLF + CRLF +;
				   "Tolerância: " + Transform(aVerTol[02,03]			,AllTrim(PesqPict("SC2","C2_QUANT"))) + CRLF +;
				   "Saldo OP + Toler: " + Transform(aVerTol[02,03] + nSldOp	,AllTrim(PesqPict("SC2","C2_QUANT")));
				   ,"[A10002] - Apontamento Produção")
		Return(.F.)
	EndIf

	// Recupera a operação
	_cOper		:= CriaVar("G2_OPERAC"	,.F.)
	_cRecurso	:= CriaVar("G2_RECURSO"	,.F.)
	_cFerram	:= CriaVar("G2_FERRAM"	,.F.)

	dbSelectArea("SG2")
	SG2->(dbSetOrder(1))
	SG2->(dbGoTop())
	If SG2->(dbSeek(xFilial("SG2")+_cProd+Posicione("SC2",1,xFilial("SC2")+_cOP,"C2_ROTEIRO")))
		_cOper := SG2->G2_OPERAC
		_cRecurso := SG2->G2_RECURSO
		_cFerram := SG2->G2_FERRAM
	Endif

	Begin Transaction

		// Realiza o apontamento da produção
		_aApont := {}
		AADD(_aApont, {"H6_OP"	   , _cOP, Nil})
		AADD(_aApont, {"H6_PRODUTO", _cProd, Nil})

		If !Empty(_cOper)
			AADD(_aApont, {"H6_OPERAC"	,_cOper		,Nil})
			AADD(_aApont, {"H6_RECURSO"	,_cRecurso	,Nil})
			AADD(_aApont, {"H6_FERRAM"	,_cFerram	,Nil})
		Endif

		AADD(_aApont, {"H6_DATAINI"	,_dIniAp	,Nil})
		AADD(_aApont, {"H6_HORAINI"	,_cHrIAp	,Nil})
		AADD(_aApont, {"H6_DATAFIN"	,_dFimAp	,Nil})
		AADD(_aApont, {"H6_HORAFIN"	,_cHrFAp	,Nil})
		AADD(_aApont, {"H6_QTDPROD"	,nQtdAp1Um	,Nil})
		AADD(_aApont, {"H6_QTDPRO2"	,nQtdAp2Um	,Nil})
		AADD(_aApont, {"H6_PT"		,"P"		,Nil})

		_cTempo := "00:00"
		If EXISTBLOCK("MDRCalcH")
			_cTempo := u_MDRCalcHoraApto(_cOP, _cOper, nQtdAp1Um)
		Endif
		AADD(_aApont, {"H6_TEMPO"	,_cTempo	,Nil})

		AADD(_aApont, {"H6_DTAPONT"	,DDATABASE	,Nil})
		AADD(_aApont, {"H6_LOTECTL"	,_cLote		,Nil})
		AADD(_aApont, {"H6_LOCAL"	,_cLocal	,Nil})


		lMsErroAuto := .F.

		// Chama Excauto para inclusão do apontamento
		MsExecAuto({|x,y| MATA681(x,y)}, _aApont, 3)
		If lMsErroAuto
			MostraErro()
			DisarmTransaction()
		Else

			lCont := .T.

			ApMSgInfo("Apontamento realizado!","[A10002] - Apontamento Produção")
			_dIniAp := _dFimAp
			_cHrIAp := _cHrFAp

			_dFimAp := DDATABASE
			_cHrAux := StrZero(SomaHoras(_cHrIAp,0.01) * 100,4)
			_cHrFAp := Substr(_cHrAux,1,2) + ":" + Substr(_cHrAux,3,2)

			_cHrIAp := StrTran(_cHrIAp,".",":")

			nSldOp		:= aSC2Sld()

		EndIf


	End Transaction

	//imprime fora da transação para fazer o flush
	IF lCont .And. ! lMsErroAuto
		//imprime etiquetas
		printLabels( _cOP, _cProd, _cLote, nQtdAp1Um)
	EndIF

Return

/*/{Protheus.doc} fConfRec
Função de confirmação do apontamento de Sub-Produto
@type function
@author Funaki
@since 26/04/2018
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function fConfRec()

	Local aPrint := {}
	Local cLoteSub := ''

	// Verifica se foram preenchidos os campos
	If Empty(_cOP)
		ApMsgAlert("O número da OP deve ser informado!","[A10002] - Sub-Produto")
		Return(.F.)
	Endif

	If Empty(cProdSub)
		ApMsgAlert("O produto deve ser informados!","[A10002] - Sub-Produto")
		Return(.F.)
	Endif

	If nQtdAp1Um == 0
		ApMsgAlert("A quantidade destino deve ser informada!","[A10002] - Sub-Produto")
		Return(.F.)
	Endif

	SD4->( dbSetOrder(1) )
	SD4->( msSeek( xFilial("SD4") + cProdSub + _cOP ) )

	IF ! SD4->( Found() ) .And. SD4->D4_QTDEORI >= 0
		ApMsgAlert("O Produto não encontrado no Empenho com quantidade negativa!","[A10002] - Sub-Produto")
		Return(.F.)
	EndIF

	IF (abs(SD4->D4_QUANT) + ( abs(SD4->D4_QTDEORI) * SuperGetMV("MV_PERCPRM",,0) / 100)) <= nQtdAp1Um
		ApMsgAlert("Quantidade é superior ao saldo empenhado, mesmo considerando o percentual para apontamento maior.","[A10002] - Sub-Produto")
		Return(.F.)
	EndIF

	// Recupera a operação
	_cOper := CriaVar("G2_OPERAC",.F.)
	_cRecurso := CriaVar("G2_RECURSO",.F.)
	_cFerram := CriaVar("G2_FERRAM",.F.)

	dbSelectArea("SG2")
	SG2->(dbSetOrder(1))
	SG2->(dbGoTop())
	If SG2->(dbSeek(xFilial("SG2")+_cProd+Posicione("SC2",1,xFilial("SC2")+_cOP,"C2_ROTEIRO")))
		_cOper    := SG2->G2_OPERAC
		_cRecurso := SG2->G2_RECURSO
		_cFerram  := SG2->G2_FERRAM
	Endif

	Begin Transaction

		IF ! devolveSubProduto(cProdSub, nQtdAp1Um, @cLoteSub) .Or. ! consomeIndiretos(cProdSub, nQtdAp1Um)
			MostraErro()
			DisarmTransaction()
		Else

			SD3->( dbSetOrder(4) )
			SD3->( msSeek( xFilial("SD3") + SBC->BC_SEQSD3 ) )

			//informação para impressão das etiquetas
			aPrint := { _cOP, cProdSub, cLoteSub, nQtdAp1Um}

		EndIf

	End Transaction


	closeSubProduto()

	nSldOp		:= aSC2Sld()

	//imprime fora da transação para fazer o flush
	IF len(aPrint) != 0

		APMSGInfo("Apontamento realizado!","[A10002] - Sub-Produto")

		//imprime etiquetas
		printLabels( aPrint[1], aPrint[2], aPrint[3], aPrint[4])
	EndIF

Return


static function devolveSubProduto(cProduto, nQuantidade, cLote)

	Local aMata241Cab   := {}
	Local aMata241Itens := {}
	Local cTipoMovimento := SuperGetMv("MD_TMEDEV",.F.,"401")

	SB1->( dbSetOrder(1) )
	SB1->( msSeek( xFilial("SB1") + cProduto ) )

	//cabeçalho do movimento
	aAdd(aMata241Cab, {"D3_DOC"    , NextNumero("SD3",2,"D3_DOC",.T.)	,Nil})
	aAdd(aMata241Cab, {"D3_TM"     , cTipoMovimento , Nil})
	aAdd(aMata241Cab, {"D3_EMISSAO", dDataBase      , Nil})

	aAdd(aMata241Itens, {})
	aAdd(aTail(aMata241Itens), {"D3_COD"     , cProduto , Nil })
	aAdd(aTail(aMata241Itens), {"D3_UM"      , SB1->B1_UM , Nil })
	aAdd(aTail(aMata241Itens), {"D3_CONTA"   , SB1->B1_CONTA , Nil })
//	aAdd(aTail(aMata241Itens), {"D3_LOCAL"   , SB1->B1_LOCPAD , Nil })
	aAdd(aTail(aMata241Itens), {"D3_LOCAL"   , GetMvNNR('MV_CQ','98') , Nil })
	IF SB1->B1_RASTRO == "L"
		cLote := getLoteSubProduto(cProduto, _cOP)
		aAdd(aTail(aMata241Itens), {"D3_LOTECTL" , cLote , Nil })
	EndIF
	IF ! empty(SD4->D4_TRT)
		aAdd(aTail(aMata241Itens), {"D3_TRT" , SD4->D4_TRT, Nil })
	EndIF
	aAdd(aTail(aMata241Itens), {"D3_OP"      , _cOP , Nil })
	//calcula conforme a esturtura
	// quantidade na estrutura / quantidade base da estrutura * quantidade produzida
	aAdd(aTail(aMata241Itens), {"D3_QUANT"   , nQuantidade , Nil })

	Private lMsErroAuto := .F.

	//executa o movimento
	MSExecAuto( { |x, y| MATA241(x, y) }, aMata241Cab, aMata241Itens, 3 )


//retorna o resultado
return ! lMsErroAuto


static function getLoteSubProduto(cProduto, cOrdemProducao)

	Local cLote
	Local cAlias := getNextAlias()

	BeginSQL Alias cAlias
		%noparser%

		select max(D3_LOTECTL) as D3_LOTECTL
		from %table:SD3%
		where
			D3_FILIAL  = %xFilial:SD3%
		and D3_OP      = %Exp: cOrdemProducao%
		and D3_COD     = %Exp: cProduto %
		and D3_TM     <= '499'
		and D_E_L_E_T_ = ' '
	EndSQL

	cLote := (cAlias)->D3_LOTECTL

	(cAlias)->( dbCloseArea() )

	IF empty(cLote)
		dbSelectArea('SB1')
		cLote := NextLote(cProduto,"L")
	EndIF

return cLote


/*/{Protheus.doc} consomeIndiretos
Função para consumir os produtos indiretos no apontamento do subproduto

@author Rafael Ricardo Vieceli
@since 30/08/2018
@version 1.0
@return logical, se consumiu
@param cProduto, characters, Sub-Produto
@param nQuantidade, numeric, Quantidade
@type function
/*/
static function consomeIndiretos(cProduto, nQuantidade)

	Local nQtdeBase
	//busca os produtos indiretos na estrutura do subproduto
	Local aEstruturaIndiretos := getIndiretos(cProduto)

	Local nCont

	Local aMata241Cab   := {}
	Local aMata241Itens := {}

	Local cTipoMovimento := SuperGetMv("MD_TMESUB",.F.,"801")

	Local nDecimais := TamSX3('D4_QUANT')[2]

	Local aArea := getArea("SB1")

	//se não tiver produtos indiretos, não processa
	IF len(aEstruturaIndiretos) == 0
		//mas retorna verdadeiro
		return .T.
	EndIF

	IF cProduto != SB1->B1_COD
		SB1->( dbSetOrder(1) )
		SB1->( msSeek( xFilial("SB1") + cProduto ) )
	EndIF

	//quantidade base do produto para a estrutura
	nQtdeBase := RetFldProd(SB1->B1_COD,"B1_QB")

	//se for zero, padrão é 1
	IF nQtdeBase == 0
		nQtdeBase := 1
	EndIF

	//cabeçalho do movimento
	aAdd(aMata241Cab, {"D3_DOC"    , NextNumero("SD3",2,"D3_DOC",.T.)	,Nil})
	aAdd(aMata241Cab, {"D3_TM"     , cTipoMovimento , Nil})
	aAdd(aMata241Cab, {"D3_EMISSAO", dDataBase      , Nil})

	For nCont := 1 to len(aEstruturaIndiretos)

		aAdd(aMata241Itens, {})
		aAdd(aTail(aMata241Itens), {"D3_COD"     , aEstruturaIndiretos[nCont][1] , Nil })
		aAdd(aTail(aMata241Itens), {"D3_UM"      , aEstruturaIndiretos[nCont][2] , Nil })
		aAdd(aTail(aMata241Itens), {"D3_LOCAL"   , aEstruturaIndiretos[nCont][3] , Nil })
		aAdd(aTail(aMata241Itens), {"D3_OP"      , _cOP , Nil })
		//calcula conforme a esturtura
		// quantidade na estrutura / quantidade base da estrutura * quantidade produzida
		aAdd(aTail(aMata241Itens), {"D3_QUANT"   , Round( aEstruturaIndiretos[nCont][4] / nQtdeBase * nQuantidade, nDecimais) , Nil })

	Next nCont

	Private lMsErroAuto := .F.

	//executa o movimento
	MSExecAuto( { |x, y| MATA241(x, y) }, aMata241Cab, aMata241Itens, 3 )

	restArea(aArea)

//retorna o resultado
return ! lMsErroAuto



/*/{Protheus.doc} getIndiretos
Busca na estrutura do produto por componentes de apropriação indireta (B1_APROPR = SIM) do primeiro nivel

@author Rafael Ricardo Vieceli
@since 30/08/2018
@version 1.0
@return array, lista da estrutura
@param cProduto, characters, Produto pai
@type function
/*/
static function getIndiretos(cProduto)

	Local cAlias := getNextAlias()
	Local aEstrutura := {}

	BeginSQL Alias cAlias
		%noparser%

		select G1_COMP , G1_QUANT, B1_UM, B1_LOCPAD

		from %table:SG1% SG1

			inner join %table:SB1% SB1
				on  SB1.B1_FILIAL  = %xFilial:SB1%
				and SB1.B1_COD     = SG1.G1_COMP
				and SB1.B1_APROPRI = 'I'
				and SB1.D_E_L_E_T_ = ' '

		where
			SG1.G1_FILIAL  = %xFilial:SG1%
		and SG1.G1_COD     = %Exp: cProduto %
		and SG1.G1_INI    <= %Exp: dDataBase %
		and SG1.G1_FIM    >= %Exp: dDataBase %
		and SG1.D_E_L_E_T_ = ' '

	EndSQL

	While ! (cAlias)->( Eof() )

		aAdd(aEstrutura, { ;
			(cAlias)->G1_COMP ,;
			(cAlias)->B1_UM ,;
			(cAlias)->B1_LOCPAD ,;
			(cAlias)->G1_QUANT ;
		})

		(cAlias)->(dbSkip())
	EndDO

return aEstrutura


/*/{Protheus.doc} fConfNRec
Função de confirmação do apontamento de perda não recuperável
@type function
@author Funaki
@since 26/04/2018
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function fConfNRec()
	// Verifica se foram preenchidos os campos
	If Empty(_cOP)
		ApMsgAlert("O número da OP deve ser informado!","[A10002] - Perda Não Recuperável")
		Return(.F.)
	Endif

	If nQtdAp1Um == 0
		ApMsgAlert("A quantidade de perda deve ser informada!","[A10002] - Perda Não Recuperável")
		Return(.F.)
	Endif

	If Empty(_cObs)
		ApMsgAlert("O motivo da perda deve ser informada!","[A10002] - Perda Não Recuperável")
		Return(.F.)
	Endif

	// Recupera a operação
	_cOper		:= CriaVar("G2_OPERAC",.F.)
	_cRecurso	:= CriaVar("G2_RECURSO",.F.)
	_cFerram	:= CriaVar("G2_FERRAM",.F.)

	dbSelectArea("SG2")
	SG2->(dbSetOrder(1))
	SG2->(dbGoTop())
	If SG2->(dbSeek(xFilial("SG2")+_cProd+Posicione("SC2",1,xFilial("SC2")+_cOP,"C2_ROTEIRO")))
		_cOper		:= SG2->G2_OPERAC
		_cRecurso	:= SG2->G2_RECURSO
		_cFerram	:= SG2->G2_FERRAM
	Endif

	// Realiza o apontamento da produção
	_aApont := {}
	AADD(_aApont, {"H6_OP"	   	,_cOP	,Nil})
	AADD(_aApont, {"H6_PRODUTO"	,_cProd	,Nil})


	AADD(_aApont, {"H6_DATAINI"	,_dIniAp	,Nil})
	AADD(_aApont, {"H6_HORAINI"	,_cHrIAp	,Nil})
	AADD(_aApont, {"H6_DATAFIN"	,_dFimAp	,Nil})
	AADD(_aApont, {"H6_HORAFIN"	,_cHrFAp	,Nil})

	If !Empty(_cOper)
		AADD(_aApont, {"H6_OPERAC"	,_cOper		,Nil})
		AADD(_aApont, {"H6_RECURSO"	,_cRecurso	,Nil})
		AADD(_aApont, {"H6_FERRAM"	,_cFerram	,Nil})
	Endif

	AADD(_aApont, {"H6_QTDPERD"	,nQtdAp1Um	,Nil})
	AADD(_aApont, {"H6_DTAPONT"	,DDATABASE	,Nil})
	AADD(_aApont, {"H6_OBSERVA"	,_cObs		,Nil})
	AADD(_aApont, {"H6_LOCAL"	,_cLocal	,Nil})

	Begin Transaction
	lMsErroAuto := .F.

	// Chama Excauto para inclusão do apontamento
	MsExecAuto({|x,y| MATA681(x,y)}, _aApont, 3)
	If lMsErroAuto
		MostraErro()
		DisarmTransaction()
	Else

		ApMSgInfo("Apontamento realizado!","[A10002] - Perda Não Recuperável")

		nQtdAp1Um := 0
		_cObs := CriaVar("H6_OBSERVA",.F.)

		nSldOp		:= aSC2Sld()

	EndIf
	End Transaction
Return

/*/{Protheus.doc} fConfGprod
Função de confirmação do ganho de produção
@type function
@author Funaki
@since 26/04/2018
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function fConfGprod()

	Local _aApont := {}

	// Verifica se foram preenchidos os campos
	If Empty(_cOP)
		ApMsgAlert("O número da OP deve ser informado!","[A10002] - Ganho Produção")
		Return(.F.)
	Endif

	If nQtdAp1Um <= 0
		ApMsgAlert("A quantidade na 1ª UM inválida. Verifique o cadastro do produto!","[A10002] - Apontamento Produção")
		Return(.F.)
	Endif

	If lConv2
		If nQtdAp2Um <= 0
			ApMsgAlert("A quantidade na 2ª UM inválida. Verifique o cadastro do produto!","[A10002] - Apontamento Produção")
			Return(.F.)
		EndIf
	Endif

	// Recupera a operação
	_cOper		:= CriaVar("G2_OPERAC",.F.)
	_cRecurso	:= CriaVar("G2_RECURSO",.F.)
	_cFerram	:= CriaVar("G2_FERRAM",.F.)

	dbSelectArea("SG2")
	SG2->(dbSetOrder(1))
	SG2->(dbGoTop())
	If SG2->(dbSeek(xFilial("SG2")+_cProd+Posicione("SC2",1,xFilial("SC2")+_cOP,"C2_ROTEIRO")))
		_cOper		:= SG2->G2_OPERAC
		_cRecurso	:= SG2->G2_RECURSO
		_cFerram	:= SG2->G2_FERRAM
	Endif

	// Realiza o apontamento da produção
	_aApont := {}
	AADD(_aApont, {"H6_OP"	   , _cOP	,Nil})
	AADD(_aApont, {"H6_PRODUTO", _cProd	,Nil})

	If !Empty(_cOper)
		AADD(_aApont, {"H6_OPERAC"	,_cOper		,Nil})
		AADD(_aApont, {"H6_RECURSO"	,_cRecurso	,Nil})
		AADD(_aApont, {"H6_FERRAM"	,_cFerram	,Nil})
	Endif

	AADD(_aApont, {"H6_DATAINI"	,_dIniAp	,Nil})
	AADD(_aApont, {"H6_HORAINI"	,_cHrIAp	,Nil})
	AADD(_aApont, {"H6_DATAFIN"	,_dFimAp	,Nil})
	AADD(_aApont, {"H6_HORAFIN"	,_cHrFAp	,Nil})
	AADD(_aApont, {"H6_QTDPROD"	,nQtdAp1Um	,Nil})
	AADD(_aApont, {"H6_QTDPRO2"	,nQtdAp2Um	,Nil})
	AADD(_aApont, {"H6_QTGANHO"	,nQtdAp1Um	,Nil})
	AADD(_aApont, {"H6_PT"		,"P"		,Nil})

	_cTempo := "00:00"
	If EXISTBLOCK("MDRCalcH")
		_cTempo := u_MDRCalcHoraApto(_cOP, _cOper, nQtdAp1Um)
	Endif
	AADD(_aApont, {"H6_TEMPO"	,_cTempo	,Nil})

	AADD(_aApont, {"H6_DTAPONT"	,DDATABASE	,Nil})
	AADD(_aApont, {"H6_LOTECTL"	,_cLote		,Nil})
	AADD(_aApont, {"H6_LOCAL"	,_cLocal	,Nil})

	Begin Transaction

	lMsErroAuto := .F.

	// Chama Excauto para inclusão do apontamento de ganho
	lGaPrd := .T.
	MsExecAuto({|x,y| MATA681(x,y)}, _aApont, 3)
	lGaPrd := .F.
	If lMsErroAuto
		MostraErro()
		DisarmTransaction()
	Else

		ApMSgInfo("Apontamento realizado!","[A10002] - Ganho Produção")
		_dIniAp := _dFimAp
		_cHrIAp := _cHrFAp

		_dFimAp := DDATABASE
		_cHrAux := StrZero(SomaHoras(_cHrIAp,0.01) * 100,4)
		_cHrFAp := Substr(_cHrAux,1,2) + ":" + Substr(_cHrAux,3,2)

		_cHrIAp := StrTran(_cHrIAp,".",":")

		nSldOp		:= aSC2Sld()

	EndIf

	End Transaction

	//imprime fora da transação para fazer o flush
	IF ! lMsErroAuto
		//imprime etiquetas
		printLabels( _cOP, _cProd, _cLote, nQtdAp1Um)
	EndIF

Return

/*/{Protheus.doc} fEncerra
Função de confirmação do encerramento de OP
@type function
@author Funaki
@since 26/04/2018
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function fEncerra()

//	Local _cUsrEnc := GetMv("MV_XENCOP",,"")

	If Empty(_cOP)
		ApMSgInfo("O número da OP deve ser informado!","[A10002] - Encerra OP")
		Return(.F.)
	Endif

	dbSelectArea("SC2")
	SC2->(dbSetOrder(1))
	SC2->(dbGoTop())
	If SC2->(dbSeek(xFilial("SC2")+_cOP))
		If Empty(SC2->C2_DATRF)
			If ApMSgYesNo("Confirma o encerramento da OP?","[A10002] - Encerra OP")

				oEncOp:lVisibleControl:=.F.

				RecLock("SC2",.F.)
				SC2->C2_DATRF := DDATABASE
				MsUnlock("SC2")

				ApMSgInfo("OP encerrada com sucesso!","[A10002] - Encerra OP")

				fStaBtn(aStatBtn)

				lVerOp := .T.
				_oGetOP:CtrlRefresh()

			Endif
		Endif
	Endif

Return


// Consulta padrão da estrutura para o apontamento
User Function A10002A()

	Local _aArea := GetArea()
	Local _lRet := .F.
	Local _nOpcao := 0
	Local _aButtons := {}
	Local _cAlAux := GetNextAlias()
	Local _aRegs := {}
	Local _nLinSel := 0

	CursorWait()

	BeginSql Alias _cAlAux
		SELECT SG1.G1_COD, SG1.G1_TRT, SG1.G1_COMP, SB1.B1_DESC, SG1.G1_QUANT, SG1.R_E_C_N_O_ RECNUM
		  FROM %table:SG1% SG1
		  JOIN %table:SB1% SB1 ON (SB1.B1_FILIAL = %xFilial:SB1% AND SB1.B1_COD = SG1.G1_COMP AND SB1.%NotDel%)
		 WHERE SG1.G1_FILIAL = %xFilial:SG1%
		   AND SG1.G1_COD = %Exp:_cProd%
		   AND SG1.G1_XPRDR = 'S'
		   AND SG1.%NotDel%
	EndSql

	While !(_cAlAux)->(EOF())
		AADD(_aRegs,{(_cAlAux)->G1_COD,;
					 (_cAlAux)->G1_TRT,;
					 (_cAlAux)->G1_COMP,;
					 (_cAlAux)->B1_DESC,;
					 (_cAlAux)->G1_QUANT,;
					 (_cAlAux)->RECNUM})

		(_cAlAux)->(dbSkip())
	Enddo
	(_cAlAux)->(dbCloseArea())

	If (Len(_aRegs) == 0)
		AADD(_aRegs,{"", "", "", "", 0} )
	Endif

	CursorArrow()

	RestArea(_aArea)

	DEFINE MSDIALOG _oDlgEst TITLE "Componentes da Estrutura" FROM 0,0 To 340,800 PIXEL
	@ 30,05 Listbox _oEstrut Fields;
			HEADER	"Produto",;
					"Revisão",;
					"Componente",;
					"Descrição",;
					"Qtde Base" Size 390,115 Of _oDlgEst Pixel NoScroll

	_oEstrut:SetArray(_aRegs)
	_oEstrut:bLine:={||{_aRegs[_oEstrut:nAt,1],;
					   _aRegs[_oEstrut:nAt,2],;
					   _aRegs[_oEstrut:nAt,3],;
					   _aRegs[_oEstrut:nAt,4],;
					   Transform(_aRegs[_oEstrut:nAt,5],"@E 99999.999999")}}
	_oEstrut:Refresh()
	ACTIVATE MSDIALOG _oDlgEst CENTERED ON INIT EnchoiceBar(_oDlgEst, {|| (_nOpcao:= 1,_nLinSel:=_oEstrut:nAt,_oDlgEst:End())}, {|| _oDlgEst:End() },,_aButtons )

	If (_nOpcao == 1)
		// Posiciona no registro da SG1
		dbSelectArea("SG1")
		SG1->(dbSetOrder(1))
		SG1->(dbGoTop())
		SG1->(dbGoTo(_aRegs[_nLinSel,6]))

		_lRet := .T.
	Endif
Return(_lRet)

// Consulta padrão do empenho para o apontamento
User Function A10002B()

	Local _aArea := GetArea()
	Local _lRet := .F.
	Local _nOpcao := 0
	Local _aButtons := {}
	Local _aRegs := {}
	Local _nLinSel := 0

	CursorWait()

		//busca os empenhos aptos
		_aRegs := getEmpenhoAptos()

		If (Len(_aRegs) == 0)
			AADD(_aRegs,{"", "", "", 0, 0, 0} )
		Endif

	CursorArrow()

	RestArea(_aArea)

	DEFINE MSDIALOG _oDlgEmp TITLE "Produtos do Empenho" FROM 0,0 To 340,800 PIXEL
	@ 30,05 Listbox _oEmpenho Fields;
			HEADER	"Produto",;
					"Revisão",;
					"Descrição",;
					"Qtde Original",;
					"Saldo Empenho" Size 390,115 Of _oDlgEmp Pixel NoScroll

	_oEmpenho:SetArray(_aRegs)
	_oEmpenho:bLine:={||{_aRegs[_oEmpenho:nAt,1],;
					   _aRegs[_oEmpenho:nAt,2],;
					   _aRegs[_oEmpenho:nAt,3],;
					   Transform(_aRegs[_oEmpenho:nAt,4],"@E 99999.999999") ,;
					   Transform(_aRegs[_oEmpenho:nAt,5],"@E 99999.999999")}}
	_oEmpenho:Refresh()
	ACTIVATE MSDIALOG _oDlgEmp CENTERED ON INIT EnchoiceBar(_oDlgEmp, {|| (_nOpcao:= 1,_nLinSel:=_oEmpenho:nAt,_oDlgEmp:End())}, {|| _oDlgEmp:End() },,_aButtons )

	If (_nOpcao == 1) .And. _aRegs[_nLinSel][6] > 0
		// Posiciona no registro da SD4
		SD4->( dbGoTo( _aRegs[_nLinSel][6] ) )

		_lRet := .T.
	Endif
Return(_lRet)



/*/{Protheus.doc} getEmpenhoAptos
Busca os empenhos aptos para geração de subprodutos da OP

@author Rafael Ricardo Vieceli
@since 24/08/2018
@version 1.0
@return array, lista de empenhos agrupado pro produto
@param cOrdemProducao, characters, descricao
@param cProduto, characters, descricao
@type function
/*/
static function getEmpenhoAptos(cOrdemProducao, cProduto)

	Local aEmpenhos := {}
	Local cAlias := GetNextAlias()

	default cOrdemProducao := _cOP
	default cProduto       := _cProd

	BeginSql Alias cAlias

		select D4_COD, B1_DESC , D4_TRT, SUM(D4_QTDEORI) as D4_QTDEORI, SUM(D4_QUANT) as D4_QUANT, min(SD4.R_E_C_N_O_) as RECNUM

		//consulta sobre os empenhos
		from %table:SD4% SD4

			//produto para pegar a descrição
		    inner join %table:SB1% SB1
		        on  SB1.B1_FILIAL  = %xFilial:SB1%
		        and SB1.B1_COD     = SD4.D4_COD
		        and SB1.B1_APROPRI <> 'I'
		        and SB1.D_E_L_E_T_ = ' '


		where
		    SD4.D4_FILIAL  = %xFilial:SD4%
		and SD4.D4_OP      = %Exp: cOrdemProducao %
		and SD4.D4_QTDEORI > 0
		and SD4.D_E_L_E_T_ = ' '

		group by D4_COD, B1_DESC, D4_TRT

	EndSql

	While !(cAlias)->( Eof() )

		aAdd( aEmpenhos,{ ;
			(cAlias)->D4_COD,;
			(cAlias)->D4_TRT,;
			(cAlias)->B1_DESC,;
			(cAlias)->D4_QTDEORI,;
			(cAlias)->D4_QUANT,;
			(cAlias)->RECNUM } )

		(cAlias)->(dbSkip())
	EndDO

	(cAlias)->(dbCloseArea())

return aEmpenhos


/*/{Protheus.doc} convProds
Função para converter a quantidade de um produto para outro produto através do peso

@author Rafael Ricardo Vieceli
@since 24/08/2018
@version 1.0
@return numeric, Quantidade convertida
@param cProdutoOrigem, characters, Produto Origem
@param cProdutoDestino, characters, Produto Destino
@param nQuantidade, numeric, Quantidade para conversão
@type function
/*/
static function convProds(cProdutoOrigem, cProdutoDestino, nQuantidade)

	Local nPesoOrigem := 0
	Local nConvertida := 0

	Local aArea := getArea("SB1")

	//primeiro olhamos o produto origem
	SB1->( dbSetOrder(1) )
	SB1->( msSeek( xFilial("SB1") + cProdutoOrigem ) )

	//exemplo: MIGNON KIDS 125 GR  72 UN - CX  // 0,125 gr * 72 un = 9KG // B1_PESO = 9KG
	//quantidade = 10 CX * 9 KG = 90 kg
	nPesoOrigem := SB1->B1_PESO * nQuantidade

	//primeiro olhamos o produto destino
	SB1->( dbSetOrder(1) )
	SB1->( msSeek( xFilial("SB1") + cProdutoDestino ) )

	//exemplo: FILE MIGNON SEM CORDAO PECA - KG // unidade QUILO // KG B1_PESO = 1KG  // 90 kg div 1kg = 90 kg
	//exemplo: CARNE/CHEESE MIGNON 130 GR 84 UN - CX // 0,130gr * 84 = 10.92 kg // B1_PESO = 10.92KG  // 90 kg div 10.92kg = 8,2417 kg
	nConvertida := round(nPesoOrigem / SB1->B1_PESO, tamSX3('D3_QUANT')[2])

	restArea(aArea)

return nConvertida


/*/{Protheus.doc} TEMPAD
//TODO Definie e Hora de inicio
@author Mario L. B. Faria
@since 26/06/2018
@version 1.0
@return ${return}, ${return_description}
@param nTempo, Numerico, descricao
/*/
Static Function TEMPAD(nTempo)

	Local nSec := 0

	nSec := TimeToSecs(Time(0)) - nTempo
	cHora := SecsToTime(nSec)

Return SubStr(cHora,1,5)

/*/{Protheus.doc} AjustaHR
//TODO Função para ajustar a hora inicial no botão cancelar
@author Mario L. B. Faria
@since 28/06/2018
@version 1.0
/*/
Static Function AjustaHR()
	_cHrIAp := SubStr(Time(),1,5)
	_cHrFAp := _cHrIAp
Return

/*/{Protheus.doc} VerTol
//TODO Função para verificar se a quantidade informada esta dentro da tolerancia
@author Mario L. B. Faria
@since 28/06/2018
@version 1.0
/*/
Static Function VerTol()

	Local nPerTol	:= Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_XTOOP")
	Local nToler	:= 0
	Local aRet		:= {.T.,{0,0,0}}

	nToler := _nQtdOp * (nPerTol / 100)
	If nQtdAp1Um > (nSldOp + nToler)
		aRet[01]	:= .F.
		aRet[02,01] := nQtdAp1Um
		aRet[02,02] := _nQtdOp
		aRet[02,03] := nToler
	EndIf

Return aRet

/*/{Protheus.doc} VerEtEmb
//TODO Rotina para fazer movimentação interna de Embalagens e etiquetas.
@author Mario L. B. Faria
@since 10/08/2018
@version 1.0
@return lRet, Lógico, .T. ou .F.
@param cCodPrd, characters, Código do Produto
@param nQtdApon, numeric, Quantidade apontada
@param cOp, characters, NUmero da OP
/*/
Static Function VerEtEmb(cCodPrd, nQtdApon, cOp)

	Local aArea		:= GetArea()
	Local aAreaSB1	:= SB1->(GetArea())
	Local aAreaSC2	:= SC2->(GetArea())
	Local nQtdOp	:= Posicione("SC2",1,xFilial("SC2")+cOp,"C2_QUANT")
	Local cGrpEtEm	:= StrTran(SuperGetMv("MD_GRPETEM",.F.,""),";","','")	//Grupos de produtos para Etiquetas e Emabalagens.
	Local cQuery	:= ""
	Local cAlQry	:= ""
	Local cTrt		:= ""
	Local aCabSD3	:= {}
	Local aIteSD3	:= {}
	Local aItem		:= {}
	Local cTm		:= SuperGetMv("MD_TMETEM",.F.,"")
	Local cLocal	:= SuperGetMv("MD_LCETEM",.F.,"")
	Local lRet		:= .T.

	cQuery := "	SELECT D4_COD, D4_QTDEORI, D4_TRT, D4_LOTECTL, B1_UM, B1_LOCPAD " + CRLF
	cQuery += "	FROM " + RetSqlName("SD4") + " SD4 " + CRLF
	cQuery += "	INNER JOIN " + RetSqlName("SB1") + " SB1 ON " + CRLF
	cQuery += "	        B1_FILIAL = D4_FILIAL " + CRLF
	cQuery += "	    AND B1_COD    = D4_COD " + CRLF
	cQuery += "	    AND B1_GRUPO IN ('" + cGrpEtEm + "') " + CRLF
	cQuery += "	    AND SB1.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "	WHERE " + CRLF
	cQuery += "	        D4_FILIAL = '" + xFilial("SD4") + "' " + CRLF
	cQuery += "	    AND D4_OP     = '" + cOp + "' " + CRLF
	cQuery += "	    AND SD4.D_E_L_E_T_ = ' ' " + CRLF

	cQuery := ChangeQuery(cQuery)
	cAlQry := MPSysOpenQuery(cQuery)

	If !(cAlQry)->(Eof())

		AADD(aCabSD3, {"D3_FILIAL"		, xFilial("SD3")		,Nil})
		AADD(aCabSD3, {"D3_TM"			, cTm				,Nil})
		AADD(aCabSD3, {"D3_EMISSAO"		, DDATABASE	   		,Nil})

		While !(cAlQry)->(Eof())

			nQtdMov := ((cAlQry)->D4_QTDEORI / nQtdOp) * nQtdApon

			If Empty(cLocal)
				cLocal := (cAlQry)->B1_LOCPAD
			EndIf

			aItem := {}
			AADD(aItem, {"D3_COD"		, (cAlQry)->D4_COD					,Nil})
			AADD(aItem, {"D3_UM"		, (cAlQry)->B1_UM					,Nil})
			AADD(aItem, {"D3_LOCAL"		, cLocal							,Nil})
			AADD(aItem, {"D3_OP"		, cOp								,Nil})
			AADD(aItem, {"D3_QUANT"		, nQtdMov							,Nil})
			AADD(aItem, {"D3_DOC"		, NextNumero("SD3",2,"D3_DOC",.T.)	,Nil})
			AADD(aItem, {"D3_TRT"		, (cAlQry)->D4_TRT					,Nil})
			AADD(aItem, {"D3_LOTECTL"	, (cAlQry)->D4_LOTECTL				,Nil})

			AADD(aIteSD3,aItem)

			(cAlQry)->(dbSkip())

		EndDo

		lMsErroAuto := .F.
		msExecAuto( { |x, y| MATA241(x, y) }, aCabSD3, aIteSD3, 3 )

		If lMsErroAuto
			MostraErro()
			DisarmTransaction()
			lRet := .F.
		EndIf

	Else
		ApMsgAlert("Não foram encontrados produtos de Embalagens e/ou etiquetas para a extrutura.","[A10002] - Apontamento de embalagens")
	EndIf

	(cAlQry)->(dbCloseArea())

	RestArea(aAreaSC2)
	RestArea(aAreaSB1)
	RestArea(aArea)

Return lRet


/*/{Protheus.doc} printLabels
Função para impressão de etiquetas padronizadas por produto

@author Rafael Ricardo Vieceli
@since 30/08/2018
@version 1.0
@param cOrdemProducao, characters, Numero da ordem de produção
@param cProduto, characters, Produto
@param cLote, characters, Lote
@param nQuantidade, numeric, Quantidade
@type function
/*/
static function printLabels(cOrdemProducao, cProduto, cLote, nQuantidade)

	Local cFuncao
	Local aLabels := {}
	Local nLabel

	IF ! MSGYesNo("Deseja imprimir as etiquetas termicas?")
		return
	EndIF

	ZIB->( dbSetOrder(1) )
	ZIB->( dbGoTop() )
	ZIB->( dbSeek( xFilial("ZIB") + cProduto ) )

	While ! ZIB->( Eof() ) .And. ZIB->(ZIB_FILIAL+ZIB_PRODUT) == xFilial("ZIB") + cProduto

		ZIA->( dbSetOrder(1) )
		ZIA->( msSeek( xFilial("ZIA") + ZIB->ZIB_TPETQ ) )

		IF ZIA->( Found() )
			aAdd(aLabels, {;
				"U_ETQ" + alltrim(ZIB->ZIB_TPETQ) ,;
				ZIA->ZIA_DESC,;
				{ 	cOrdemProducao, ;
					cProduto, ;
					cLote, ;
					getInteiro(nQuantidade) * ZIB->ZIB_QTDE , ;
					ZIA->ZIA_IMPPAD, .T. ;
				} ;
			 })

		EndIF

		ZIB->(dbSkip())
	EndDO

	For nLabel := 1 to len(aLabels)
		//função a função
		cFuncao := aLabels[nLabel][1]
		//chama função
		FwMsgRun(, {|| &cFuncao.( { aLabels[nLabel][3] } ) }, "Imprimindo...", "Imprimindo " + aLabels[nLabel][2])
	Next nLabel

return


/*/{Protheus.doc} getInteiro
função para pegar numero inteiro da produção
	se passar 1 = retorna 1
	se passar 1.2 = retorna 2

@author Rafael Ricardo Vieceli
@since 31/08/2018
@version 1.0
@return numeric, numero inteiro
@param nQuantidade, numeric, numero decimal
@type function
/*/
static function getInteiro(nQuantidade)

	IF round(nQuantidade,0) == nQuantidade
		return round(nQuantidade,0)
	EndIF

return round(nQuantidade,0) + 1


/*/{Protheus.doc} ShowF4
Função para mostrar o saldo de lotes

@author Rafael Ricardo Vieceli
@since 03/09/2018
@version 1.0

@type function
/*/
static function ShowF4()

	IF ! empty(cProdPerda) .And. SB1->B1_RASTRO == "L"
		F4Lote(/*a*/,/*b*/,/*c*/,"MDR",cProdPerda,SB1->B1_LOCPAD,/*lParam*/,/*cLocaliz*/,/*nLoteCtl*/,/*cOP*/,/*lLoja*/,/*lAtNumLote*/,@cPerdaLoteCtl)
	EndIF

return


/*/{Protheus.doc} closePerdaMP
Função para limpar tudo no fechamento do papel de perda

@author Rafael Ricardo Vieceli
@since 03/09/2018
@version 1.0
@return logical, verdadeiro

@type function
/*/
static function closePerdaMP()

	SET KEY VK_F4 TO

	cProdPerda	:= CriaVar("B1_COD",.F.)
	cDescPerda	:= CriaVar("B1_DESC",.F.)
	cMotPerda   := CriaVar("BC_MOTIVO",.F.)
	cPerdaLoteCtl    := CriaVar("BC_LOTECTL",.F.)

	nQtdAp1Um	:= 0.00
	nQtdAp2Um	:= 0.00

	AtuSayQuants(oSayMP1,oSayMP2, .T.)

	SB1->( dbSetOrder(1) )
	SB1->( msSeek( xFilial("SB1") + _cProd ) )

return .T.


static function closeSubProduto()

	cProdSub := CriaVar("B1_COD",.F.)
	cDescSub := CriaVar("B1_DESC",.F.)

	nQtdAp1Um	:= 0.00
	nQtdAp2Um	:= 0.00

	AtuSayQuants(oSaySB1,oSaySB2, .T.)

	SB1->( dbSetOrder(1) )
	SB1->( msSeek( xFilial("SB1") + _cProd ) )

return .T.

/*/{Protheus.doc} fConfPerdaMP
Função para confirmar a perda de materia-prima e consumo da reposição

@author Rafael Ricardo Vieceli
@since 03/09/2018
@version 1.0

@type function
/*/
static function fConfPerdaMP()

	// Verifica se foram preenchidos os campos
	If Empty(_cOP)
		ApMsgAlert("O número da OP deve ser informado!","[A10002] - Perda MP")
		Return(.F.)
	Endif

	If Empty(cProdPerda)
		ApMsgAlert("O produto perdido devem ser informado!","[A10002] - Perda MP")
		Return(.F.)
	Endif

	SB1->( dbSetOrder(1) )
	SB1->( msSeek( xFilial("SB1") + cProdPerda ) )

	IF SB1->B1_RASTRO == "L" .And. Empty(cPerdaLoteCtl)
		ApMsgAlert("O Lote do produto reposto devem ser informado!","[A10002] - Perda MP")
		Return(.F.)
	Endif

	IF nQtdAp1Um <= 0
		ApMsgAlert("A quantidade de perda deve ser informada!","[A10002] - Perda MP")
		Return(.F.)
	Endif

	IF Empty(cMotPerda)
		ApMsgAlert("O motivo da perda deve ser informada!","[A10002] - Perda MP")
		Return(.F.)
	Endif

	// Recupera a operação
	_cOper    := CriaVar("G2_OPERAC",.F.)
	_cRecurso := CriaVar("G2_RECURSO",.F.)
	_cFerram  := CriaVar("G2_FERRAM",.F.)

	dbSelectArea("SG2")
	SG2->(dbSetOrder(1))
	SG2->(dbGoTop())
	If SG2->(dbSeek(xFilial("SG2")+_cProd+Posicione("SC2",1,xFilial("SC2")+_cOP,"C2_ROTEIRO")))
		_cOper := SG2->G2_OPERAC
		_cRecurso := SG2->G2_RECURSO
		_cFerram := SG2->G2_FERRAM
	Endif

	// Realiza o apontamento da Sub-Produto
	_aCab := {}
	AADD(_aCab,{"BC_OP"			,PADR(Alltrim(_cOP),13)	,Nil})
	AADD(_aCab,{"BC_OPERAC"		,_cOper					,Nil})
	AADD(_aCab,{"BC_RECURSO"	,_cRecurso				,Nil})

	_aItem := {}
	AADD(_aItem,{{"BC_OP"		, Alltrim(_cOP)	, NIL},;
				 {"BC_PRODUTO"	, cProdPerda		, NIL},;
				 {"BC_LOCORIG"	, Posicione("SB1",1,xFilial("SB1")+cProdPerda,"B1_LOCPAD")	, NIL},;
				 {"BC_QUANT"	, nQtdAp1Um		, NIL},;
				 {"BC_TIPO"		, "R"			, NIL},;
				 {"BC_MOTIVO"	, cMotPerda		, NIL},;
				 {"BC_DATA"		, DDATABASE		, NIL}})

	Begin Transaction

		lMsErroAuto := .F.

		// Chama Excauto para inclusão do apontamento
		MSExecAuto({|x,y,z| Mata685(x,y,z)},_aCab,_aItem,3 ) //3-Inclusao;

		If lMsErroAuto .Or. ! reposicao(cProdPerda, cPerdaLoteCrl, nQtdAp1Um)
			MostraErro()
			DisarmTransaction()
		Else

			ApMSgInfo("Apontamento realizado!","[A10002] - Perda MP")

			closePerdaMP()

			nSldOp		:= aSC2Sld()

		EndIF

	End Transaction

return


/*/{Protheus.doc} reposicao
Função para consumir produto e lote (se controlar) contra OP

@author Rafael Ricardo Vieceli
@since 03/09/2018
@version 1.0
@return logical, se fez o movimento
@param cProduto, characters, Produto
@param cLote, characters, Lote
@param nQuantidade, numeric, Quantidade
@type function
/*/
static function reposicao(cProduto, cLote, nQuantidade)

	Local cTipoMovimento := SuperGetMv("MD_TMESUB",.F.,"801")

	Local aMata241Cab := {}
	Local aMata241Itens := {}

	SB1->( dbSetOrder(1) )
	SB1->( msSeek( xFilial("SB1") + cProduto ) )

	//cabeçalho do movimento
	aAdd(aMata241Cab, {"D3_DOC"    , NextNumero("SD3",2,"D3_DOC",.T.)	,Nil})
	aAdd(aMata241Cab, {"D3_TM"     , cTipoMovimento , Nil})
	aAdd(aMata241Cab, {"D3_EMISSAO", dDataBase      , Nil})

	aAdd(aMata241Itens, {})
	aAdd(aTail(aMata241Itens), {"D3_COD"     , cProduto , Nil })
	aAdd(aTail(aMata241Itens), {"D3_UM"      , SB1->B1_UM , Nil })
	aAdd(aTail(aMata241Itens), {"D3_LOCAL"   , SB1->B1_LOCPAD , Nil })
	IF ! empty(cLote)
		aAdd(aTail(aMata241Itens), {"D3_LOTECTL" , cLote , Nil })
	EndIF
	aAdd(aTail(aMata241Itens), {"D3_OP"      , _cOP , Nil })
	//calcula conforme a esturtura
	// quantidade na estrutura / quantidade base da estrutura * quantidade produzida
	aAdd(aTail(aMata241Itens), {"D3_QUANT"   , nQuantidade , Nil })

	Private lMsErroAuto := .F.

	//executa o movimento
	MSExecAuto( { |x, y| MATA241(x, y) }, aMata241Cab, aMata241Itens, 3 )

//retorna o resultado
return ! lMsErroAuto


/*/{Protheus.doc} temPesagem
Função para verificar se possui produtos DIRETOS, pois indiretos não são pesados

@author Rafael Ricardo Vieceli
@since 25/09/2018
@version 1.0
@return logical, se possui itens pesados
@param cOrdemProducao, characters, Numero da ordem de produção
@type function
/*/
static function temPesagem(cOrdemProducao)

	Local cAlias := getNextAlias()
	Local nDiretos

	BeginSql Alias cAlias

		select count(1) DIRETOS

		//consulta sobre os empenhos
		from %table:SD4% SD4

		where
		    SD4.D4_FILIAL  = %xFilial:SD4%
		and SD4.D4_OP      = %Exp: cOrdemProducao %
		and SD4.D4_LOCAL  <> %Exp: GetMvNNR('MV_LOCPROC','99') %
		and SD4.D_E_L_E_T_ = ' '

	EndSQL

	nDiretos := (cAlias)->DIRETOS

	(cAlias)->( dbCloseArea() )

return nDiretos > 0