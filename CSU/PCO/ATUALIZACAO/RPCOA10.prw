#INCLUDE "PROTHEUS.CH"

#define ACESSO_AVALIA 		!Empty(Substr(ACBROWSE,6,1)) 
#define ACESSO_LIBERA 		!Empty(Substr(ACBROWSE,7,1)) 
#define ACESSO_BLOQUEIA 	!Empty(Substr(ACBROWSE,8,1)) 
#define ACESSO_FECHA 		!Empty(Substr(ACBROWSE,9,1)) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³FUNCAO    ³ RPCOA10  ³ AUTOR ³ Paulo Carnelossi      ³ DATA ³ 01/03/2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³ Programa para manutencao de solicitacao de contingencia  a   ³±±
±±³          ³ partir do bloqueio de lancamentos por processo               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ USO      ³ SIGAPCO                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³_DOCUMEN_ ³ PCOA010                                                      ³±±
±±³_DESCRI_  ³ Programa para manutencao de solicitacao de contingencia a    ³±±
±±³          ³ partir do bloqueio                                           ³±±
±±³_FUNC_    ³ Esta funcao podera ser utilizada com a sua chamada normal    ³±±
±±³          ³ partir do Menu ou a partir de uma funcao pulando assim o     ³±±
±±³          ³ browse principal e executando a chamada direta da rotina     ³±±
±±³          ³ selecionada.                                                 ³±±
±±³          ³ Exemplo: PCOA010(2) - Executa a chamada da funcao de visua-  ³±±
±±³          ³                        zacao da rotina.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³_PARAMETR_³ ExpN1 : Chamada direta sem passar pela mBrowse               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Function PCOA010(nCallOpcx,lAuto,aCposVs)
USER Function RPCOA10(nCallOpcx,lAuto,aCposVs)

Local lRet      := .T.
Local xOldInt
Local lOldAuto
Local bF12	:=	SetKey(VK_F12)

If ValType(lAuto) != "L" 
	lAuto := .F.
EndIf

If lAuto
	If Type('__cInternet') != 'U'
		xOldInt := __cInternet
	EndIf
	If Type('lMsHelpAuto') != 'U'
		lOldAuto := lMsHelpAuto
	EndIf
	lMsHelpAuto := .T.
	__cInternet := 'AUTOMATICO'
EndIf

Private aCposVisual	:= aCposVs
Private cCadastro	:= "Manutenção de Contingencia Orçamentária"
Private aRotina 	:= menudef()
//							{	{ "Pesquisar"		,		"AxPesqui" 		, 0 , 1},;
//							{ "Visualizar"		, 		"U_A010DLG"  		, 0 , 2},;
//							{ "Excluir"			, 		"U_A010DLG"  		, 0 , 5},;
//							{ "Liberar"			, 		"U_A010LIB"  		, 0 , 4},;
//							{ "Cancelar"		, 		"U_A010BLQ"  		, 0 , 4},; 
//							{ "Blq. Vencidas"	, 		"U_A010BlqVen"   	, 0 , 4},; 
//							{ "Fechar"			, 		"U_A010Fechar"   	, 0 , 4},; 
 //							{ "Legenda"			, 		"U_PCOA010Leg"  	, 0 , 1}}

Private cFiltroRot :=	""
SetKey(VK_F12,{|| PergFilter()})
If AMIIn(57) // AMIIn do modulo SIGAPCO ( 57 )
	AjustaSX1()
	If PergFilter() 
		If nCallOpcx <> Nil
			lRet := U_A010DLG("ZU1",ZU1->(RecNo()),nCallOpcx,,,lAuto)
		Else
			mBrowse(6,1,22,75,"ZU1",,,,,,U_PCOA010Leg() )
		EndIf
	Endif
EndIf
dbSelectArea("ZU1")
dbSetOrder(1)
Set Filter to

lMsHelpAuto := lOldAuto
__cInternet := xOldInt
SetKey(VK_F12,bF12)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A010DLG   ºAutor  ³Paulo Carnelossi    º Data ³  01/03/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tratamento da tela de Inclusao/Alteracao/Exclusao/Visuali- º±±
±±º          ³ zacao                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A010DLG(cAlias,nRecnoZU1,nCallOpcx,cR1,cR2,lAuto)
Local oDlg
Local lCancel  := .F.
Local aButtons	:= {}//{{'PMSPESQ',{||PcoA010Pesq() },"Consulta Padrao","Pesquisa"} }
Local aUsButtons := {}
Local oEnchZU1

Local aHeadZU2
Local aColsZU2
Local nLenZU2   := 0 // Numero de campos em uso no ZU2
Local nLinZU2   := 0 // Linha atual do acols
Local aRecZU2   := {} // Recnos dos registros
Local nGetD
Local cCdContigencia
Local aCposEnch
Local aUsField
Local aAreaZU1 := ZU1->(GetArea()) // Salva Area do ZU1
Local aAreaZU2 := ZU2->(GetArea()) // Salva Area do ZU1
Local aEnchAuto  // Array com as informacoes dos campos da enchoice qdo for automatico
Local xOldInt
Local lOldAuto
Local nRecZU1 := nRecnoZU1
Local aCpos_Nao := {}
Local nPosVal1, nPosVal2, nPosVal3, nPosVal4, nPosVal5
Local nPosIDRef, nPosIdent, nPosUM
Local aAuxArea

Private INCLUI  := (nCallOpcx = 3)
Private oGdZU2
PRIVATE aTELA[0][0],aGETS[0]

If !AMIIn(57) // AMIIn do modulo SIGAPCO ( 57 )
	Return .F.
EndIf

If ValType(lAuto) != "L" 
	lAuto := .F.
EndIf

If lAuto
	If Type('__cInternet') != 'U'
		xOldInt := __cInternet
	EndIf
	If Type('lMsHelpAuto') != 'U'
		lOldAuto := lMsHelpAuto
	EndIf
	lMsHelpAuto := .T.
	__cInternet := 'AUTOMATICO'
EndIf

If lAuto .And. !(nCallOpcx = 4 .Or. nCallOpcx = 6)
	Return .F.
EndIf

If nCallOpcx != 3 .And. ValType(nRecnoZU1) == "N" .And. nRecnoZU1 > 0
	DbSelectArea(cAlias)
	DbGoto(nRecnoZU1)
	If EOF() .Or. BOF()
		HELP("  ",1,"PCOREGINV",,AllTrim(Str(nRecnoZU1)))
		Return .F.
	EndIf
	aAreaZU1 := ZU1->(GetArea()) // Salva Area do ZU1 por causa do Recno e do Indice
EndIf

If nCallOpcx == 5 .And. ZU1->ZU1_STATUS > "01"
	If (ACESSO_LIBERA .OR. RetCodUsr() == "000000") .And. ZU1_STATUS != "03" //Administrador
		Aviso("Atenção", "Exclusao permitida somente para usuario Administrador.", {"Ok"}, 2)
	Else
		Aviso("Atenção", "Exclusao nao permitida. Somente podera ser bloqueada por alcada competente.", {"Ok"}, 2)
		Return .F.
	EndIf	
EndIf

	If (nCallOpcx == 4 .Or. nCallOpcx == 5)
		If ACESSO_LIBERA .OR. RetCodUsr() == "000000" //Administrador
		
		ElseIf Alltrim(ZU1->ZU1_USER) != RetCodUsr()
		   Aviso("Atencao", "A alteraração ou exclusão da solicitação de contingencia somente podera ser efetuada pelo solicitante.",{"Ok"})
		   Return .F.
		ElseIf Alltrim(ZU1->ZU1_STATUS) != "01"
		   Aviso("Atencao", "A alteraração ou exclusão da solicitação de contingencia somente podera ser efetuada por alçada competente.",{"Ok"})
		   Return .F.
		EndIf   
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona botoes do usuario na EnchoiceBar                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock( "PCOA0102" )
	//P_EÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//P_E³ Ponto de entrada utilizado para inclusao de botoes de usuarios         ³
	//P_E³ na tela de configuracao dos lancamentos                                ³
	//P_E³ Parametros : Nenhum                                                    ³
	//P_E³ Retorno    : Array contendo as rotinas a serem adicionados na enchoice ³
	//P_E³  Ex. :  User Function PCOA0102                                         ³
	//P_E³         Return { 'PEDIDO', {|| MyFun() },"Exemplo de Botao" }          ³
	//P_EÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If ValType( aUsButtons := ExecBlock( "PCOA0102", .F., .F. ) ) == "A"
		aButtons := {}
		AEval( aUsButtons, { |x| AAdd( aButtons, x ) } )
	EndIf
EndIf

If !lAuto

	DEFINE MSDIALOG oDlg TITLE "Manutenção de Contingencia Orcamentaria"  FROM 0,0 TO 480,650 PIXEL 
	oDlg:lMaximized := .T.

EndIf

aCposEnch := PcoCpoEnchoice("ZU1", aCpos_Nao)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada para adicionar campos no cabecalho                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock( "PCOA0103" )
	//P_EÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//P_E³ Ponto de entrada utilizado para adicionar campos no cabecalho          ³
	//P_E³ Parametros : Nenhum                                                    ³
	//P_E³ Retorno    : Array contendo as os campos a serem adicionados           ³
	//P_E³               Ex. :  User Function PCOA0103                            ³
	//P_E³                      Return {"ZU1_FIELD1","ZU1_FIELD2"}                ³
	//P_EÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ValType( aUsField := ExecBlock( "PCOA0103", .F., .F. ) ) == "A"
		AEval( aUsField, { |x| AAdd( aCposEnch, x ) } )
	EndIf
EndIf

// Carrega dados do ZU1 para memoria
RegToMemory("ZU1",INCLUI)

If !lAuto
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Enchoice com os dados dos Lancamentos                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oEnchZU1 := MSMGet():New('ZU1',,nCallOpcx,,,,aCposEnch,{0,0,90,23},,,,,,oDlg,,,,,,,,,)
	oEnchZU1:oBox:Align := CONTROL_ALIGN_TOP
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do aHeader do ZU2                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeadZU2 := GetaHeader("ZU2",,aCposEnch,@aEnchAuto,aCposVisual)
nLenZU2  := Len(aHeadZU2) + 1

nPosVal1  := AScan(aHeadZU2,{|x| Upper(AllTrim(x[2])) == "ZU2_VAL1"})
nPosVal2  := AScan(aHeadZU2,{|x| Upper(AllTrim(x[2])) == "ZU2_VAL2"})
nPosVal3  := AScan(aHeadZU2,{|x| Upper(AllTrim(x[2])) == "ZU2_VAL3"})
nPosVal4  := AScan(aHeadZU2,{|x| Upper(AllTrim(x[2])) == "ZU2_VAL4"})
nPosVal5  := AScan(aHeadZU2,{|x| Upper(AllTrim(x[2])) == "ZU2_VAL5"})
nPosIDRef := AScan(aHeadZU2,{|x| Upper(AllTrim(x[2])) == "ZU2_IDREF"})
nPosIdent := AScan(aHeadZU2,{|x| Upper(AllTrim(x[2])) == "ZU2_IDENT"})
nPosUM    := AScan(aHeadZU2,{|x| Upper(AllTrim(x[2])) == "ZU2_UM"})

If nPosIDRef > 0
	aHeadZU2[nPosIDRef][4] := 0
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do aCols do ZU2                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aColsZU2 := {}

If !INCLUI                         
	DbSelectArea("ZU2")
	DbSetOrder(1)
	SET FILTER TO
	DbSeek(xFilial()+M->ZU1_CDCNTG)
	
	cCdContigencia := M->ZU1_FILIAL + M->ZU1_CDCNTG
	While nCallOpcx != 3 .And. !Eof() .And. ZU2->ZU2_FILIAL + ZU2->ZU2_CDCNTG == cCdContigencia
		AAdd(aColsZU2,Array( nLenZU2 ))
		nLinZU2++
		// Varre o aHeader para preencher o acols
		AEval(aHeadZU2, {|x,y| aColsZU2[nLinZU2][y] := IIf(x[10] == "V", CriaVar(AllTrim(x[2])), FieldGet(FieldPos(x[2])) ) })

		If nPosVal1 > 0
			aColsZU2[nLinZU2][nPosVal1] := PCOPlanCel(ZU2->ZU2_VALOR1,ZU2->ZU2_CLASSE)
		EndIf
	
		If nPosVal2 > 0
			aColsZU2[nLinZU2][nPosVal2] := PCOPlanCel(ZU2->ZU2_VALOR2,ZU2->ZU2_CLASSE)
		EndIf
		
		If nPosVal3 > 0
			aColsZU2[nLinZU2][nPosVal3] := PCOPlanCel(ZU2->ZU2_VALOR3,ZU2->ZU2_CLASSE)
		EndIf
	
		If nPosVal4 > 0
			aColsZU2[nLinZU2][nPosVal4] := PCOPlanCel(ZU2->ZU2_VALOR4,ZU2->ZU2_CLASSE)
		EndIf
	
		If nPosVal5 > 0
			aColsZU2[nLinZU2][nPosVal5] := PCOPlanCel(ZU2->ZU2_VALOR5,ZU2->ZU2_CLASSE)
		EndIf
		
		If nPosIdent > 0 .And. !Empty(ZU2->ZU2_IDREF)
			aAuxArea := GetArea()
			AK6->(dbSetOrder(1))
			AK6->(dbSeek(xFilial()+ZU2->ZU2_CLASSE))
			If !Empty(AK6->AK6_VISUAL)
				dbSelectArea(Substr(ZU2->ZU2_IDREF,1,3))
				dbSetOrder(Val(Substr(ZU2->ZU2_IDREF,4,2)))
				dbSeek(Substr(ZU2->ZU2_IDREF,6,Len(ZU2->ZU2_IDREF)))
				aColsZU2[nLinZU2][nPosIdent] := &(AK6->AK6_VISUAL)
			EndIf
			RestArea(aAuxArea)
		EndIf
		If nPosUM > 0
			AK6->(dbSetOrder(1))
			AK6->(dbSeek(xFilial()+AK2->AK2_CLASSE))
			aAuxArea := GetArea()
			If !Empty(AK6->AK6_UM)
				If !Empty(AK2->AK2_CHAVE)
					dbSelectArea(Substr(AK2->AK2_CHAVE,1,3))
					dbSetOrder(Val(Substr(AK2->AK2_CHAVE,4,2)))
					dbSeek(Substr(AK2->AK2_CHAVE,6,Len(AK2->AK2_CHAVE)))
				EndIf
				aColsZU2[nLinZU2][nPosUM] := &(AK6->AK6_UM)
			EndIf
			RestArea(aAuxArea)
		EndIf
	
		// Deleted
		aColsZU2[nLinZU2][nLenZU2] := .F.
		
		// Adiciona o Recno no aRec
		AAdd( aRecZU2, ZU2->( Recno() ) )
		
		ZU2->(DbSkip())
		
	EndDo
EndIf

// Verifica se não foi criada nenhuma linha para o aCols
If Len(aColsZU2) = 0
	AAdd(aColsZU2,Array( nLenZU2 ))
	nLinZU2++
    ZU2->( DBSEEK(cCdContigencia) )
	// Varre o aHeader para preencher o acols
	AEval(aHeadZU2, {|x,y| aColsZU2[nLinZU2][y] := IIf(Upper(AllTrim(x[2])) == "ZU2_ID", StrZero(1,Len(ZU2->ZU2_ID)),CriaVar(AllTrim(x[2])) ) })	
	// Deleted
	aColsZU2[nLinZU2][nLenZU2] := .F.
EndIf

If !lAuto
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ GetDados com os Lancamentos                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nCallOpcx = 3 .Or. nCallOpcx = 4
		nGetD:= GD_INSERT+GD_UPDATE+GD_DELETE
	Else
		nGetD := 0
	EndIf
	oGdZU2:= MsNewGetDados():New(0,0,100,100,nGetd,"U_ZU2LinOK",,"+ZU2_ID",,,9999,,,,oDlg,aHeadZU2,aColsZU2)
	oGdZU2:AddAction("ZU2_IDENT",{||PCOIdentF3("ZU2")})
	oGdZU2:AddAction("ZU2_VAL1",{||PCOEditCell(oGdZU2)})
	oGdZU2:AddAction("ZU2_VAL2",{||PCOEditCell(oGdZU2)})
	oGdZU2:AddAction("ZU2_VAL3",{||PCOEditCell(oGdZU2)})
	oGdZU2:AddAction("ZU2_VAL4",{||PCOEditCell(oGdZU2)})
	oGdZU2:AddAction("ZU2_VAL5",{||PCOEditCell(oGdZU2)})
	
	oGdZU2:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	oGdZU2:CARGO := AClone(aRecZU2)

	// Quando nao for MDI chama centralizada.
	If SetMDIChild()
		ACTIVATE MSDIALOG oDlg ON INIT (oGdZU2:oBrowse:Refresh(),EnchoiceBar(oDlg,{|| If(obrigatorio(aGets,aTela).And.A010Ok(nCallOpcx,nRecZU1,oGdZU2:Cargo,aEnchAuto,oGdZU2:aCols,oGdZU2:aHeader),oDlg:End(),) },{|| lCancel := .T., oDlg:End() },,aButtons))
	Else
		ACTIVATE MSDIALOG oDlg CENTERED ON INIT (oGdZU2:oBrowse:Refresh(),EnchoiceBar(oDlg,{|| If(obrigatorio(aGets,aTela).And.A010Ok(nCallOpcx,nRecZU1,oGdZU2:Cargo,aEnchAuto,oGdZU2:aCols,oGdZU2:aHeader),oDlg:End(),) },{|| lCancel := .T., oDlg:End() },,aButtons) )
	EndIf
Else
	lCancel := !A010Ok(nCallOpcx,nRecZU1,aRecZU2,aEnchAuto,aColsZU2,aHeadZU2,lAuto)
EndIf

If lCancel
	RollBackSX8()
EndIf

lMsHelpAuto := lOldAuto
__cInternet := xOldInt

RestArea(aAreaZU2)
RestArea(aAreaZU1)
Return !lCancel

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ A010Ok   ºAutor  ³Guilherme C. Leal   º Data ³  11/26/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao do botao OK da enchoice bar, valida e faz o         º±±
±±º          ³ tratamento adequado das informacoes.                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A010Ok(nCallOpcx,nRecZU1,aRecZU2,aEnchAuto,aColsZU2,aHeadZU2,lAuto)
Local nI
Local nX
Local aArea		:= GetArea()
Local aAreaZU2	:= ZU2->(GetArea())
Local aAreaZU1	:= ZU1->(GetArea())
Local aRecAux   := aClone(aRecZU2)
Local bCampo 	:= {|n| FieldName(n) }
Local nPosVal1	:= AScan(aHeadZU2,{|x| Upper(AllTrim(x[2])) == "ZU2_VAL1"})
Local nPosVal2  := AScan(aHeadZU2,{|x| Upper(AllTrim(x[2])) == "ZU2_VAL2"})
Local nPosVal3  := AScan(aHeadZU2,{|x| Upper(AllTrim(x[2])) == "ZU2_VAL3"})
Local nPosVal4  := AScan(aHeadZU2,{|x| Upper(AllTrim(x[2])) == "ZU2_VAL4"})
Local nPosVal5  := AScan(aHeadZU2,{|x| Upper(AllTrim(x[2])) == "ZU2_VAL5"})

If nCallOpcx = 1 .Or. nCallOpcx = 2 // Pesquisar e Visualizar
	Return .T.
EndIf

If !A010Vld(nCallOpcx,aRecZU2,aEnchAuto,aColsZU2,aHeadZU2)
	Return .F.
EndIf

ZU1->(DbSetOrder(1))
ZU2->(DbSetOrder(1))

If nCallOpcx = 3 // Inclusao
	dbSelectArea("ZU1")
	Reclock("ZU1",.T.)
	// Grava Campos do Cabecalho
	If lAuto
		For nX := 1 To Len(aEnchAuto)
			FieldPut(FieldPos(aEnchAuto[nX][2]),&( "M->" + aEnchAuto[nX][2] ))
		Next nX
    Else
		For nx := 1 TO FCount()
			FieldPut(nx,M->&(EVAL(bCampo,nx)))
		Next nx
	EndIf
	ZU1->ZU1_FILIAL := xFilial("ZU1")
	MsUnlock()	

	// Grava Lancamentos
	For nI := 1 To Len(aColsZU2)
		If aColsZU2[nI][Len(aColsZU2[nI])] // Verifica se a linha esta deletada
			Loop
		Else
			Reclock("ZU2",.T.)
		EndIf

		// Varre o aHeader e grava com base no acols
		AEval(aHeadZU2,{|x,y| If(x[10] != "V",( FieldPut(FieldPos(x[2]), aColsZU2[nI][y])), ) })

		// Grava campos que nao estao disponiveis na tela
		Replace ZU2_FILIAL With xFilial()
		Replace ZU2_CDCNTG With ZU1->ZU1_CDCNTG
		Replace ZU2_VALOR1  With PcoPlanVal(aColsZU2[nI][nPosVal1],ZU2->ZU2_CLASSE)
		Replace ZU2_VALOR2  With PcoPlanVal(aColsZU2[nI][nPosVal2],ZU2->ZU2_CLASSE)
		Replace ZU2_VALOR3  With PcoPlanVal(aColsZU2[nI][nPosVal3],ZU2->ZU2_CLASSE)
		Replace ZU2_VALOR4  With PcoPlanVal(aColsZU2[nI][nPosVal4],ZU2->ZU2_CLASSE)		
		Replace ZU2_VALOR5  With PcoPlanVal(aColsZU2[nI][nPosVal5],ZU2->ZU2_CLASSE)
		MsUnlock()
		
	Next nI
	
ElseIf nCallOpcx = 4 // Alteracao

	dbSelectArea("ZU1")
	dbGoto(nRecZU1)
	Reclock("ZU1",.F.)

	// Grava Campos do Cabecalho
	If lAuto
		For nX := 1 To Len(aEnchAuto)
			FieldPut(FieldPos(aEnchAuto[nX][2]),&( "M->" + aEnchAuto[nX][2] ))
		Next nX
    Else
		For nx := 1 TO FCount()
			FieldPut(nx,M->&(EVAL(bCampo,nx)))
		Next nx
	EndIf	
	MsUnlock()	

	// Grava Lancamentos
	dbSelectArea("ZU2")
	//primeiro exclui os registros
	For nI := 1 TO Len(aRecAux)
		dbGoto(aRecAux[nI])
		Reclock("ZU2",.F.)
		dbDelete()
		MsUnlock()
    Next
	//depois grava novos registros	
	For nI := 1 To Len(aColsZU2)
		If aColsZU2[nI][Len(aColsZU2[nI])] // Verifica se a linha esta deletada
			Loop
		Else
			Reclock("ZU2",.T.)
		EndIf

		// Varre o aHeader e grava com base no acols
		AEval(aHeadZU2,{|x,y| If(x[10] != "V",( FieldPut(FieldPos(x[2]), aColsZU2[nI][y])), ) })

		// Grava campos que nao estao disponiveis na tela
		Replace ZU2_FILIAL With xFilial()
		Replace ZU2_CDCNTG With ZU1->ZU1_CDCNTG
		Replace ZU2_VALOR1  With PcoPlanVal(aColsZU2[nI][nPosVal1],ZU2->ZU2_CLASSE)
		Replace ZU2_VALOR2  With PcoPlanVal(aColsZU2[nI][nPosVal2],ZU2->ZU2_CLASSE)
		Replace ZU2_VALOR3  With PcoPlanVal(aColsZU2[nI][nPosVal3],ZU2->ZU2_CLASSE)
		Replace ZU2_VALOR4  With PcoPlanVal(aColsZU2[nI][nPosVal4],ZU2->ZU2_CLASSE)		
		Replace ZU2_VALOR5  With PcoPlanVal(aColsZU2[nI][nPosVal5],ZU2->ZU2_CLASSE)
		MsUnlock()
		
	Next nI

ElseIf nCallOpcx = 5 // Exclusao

	// Grava Lancamentos
	For nI := 1 To Len(aRecZU2)
		dbGoto(aRecZU2[nI])
		Reclock("ZU2",.F.)
		dbDelete()
		MsUnlock()
	Next nI
	
	dbSelectArea("ZU1")
	dbGoto(nRecZU1)
	Reclock("ZU1",.F.)
	dbDelete()
	MsUnlock()

EndIf

If __lSX8
	ConfirmSX8()
EndIf

ZU2->(RestArea(aAreaZU2))
ZU1->(RestArea(aAreaZU1))
RestArea(aArea)

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ A010Vld  ºAutor  ³Guilherme C. Leal   º Data ³  11/26/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao de validacao dos campos.                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A010Vld(nCallOpcx,aRecZU2,aEnchAuto,aColsZU2,aHeadZU2)
Local nI
Local nPosTipo
If !(nCallOpcx = 3 .Or. nCallOpcx = 4 .Or. nCallOpcx = 6)
	Return .T.
EndIf


If ( AScan(aEnchAuto,{|x| x[17] .And. Empty( &( "M->" + x[2] ) ) } ) > 0 )
	HELP("  ",1,"OBRIGAT")
	Return .F.
EndIf

For nI := 1 To Len(aColsZU2)
	// Busca por campos obrigatorios que nao estejam preenchidos
	nPosField := AScanx(aHeadZU2,{|x,y| x[17] .And. Empty(aColsZU2[nI][y]) })
	If nPosField > 0
		SX2->(dbSetOrder(1))
		SX2->(MsSeek("ZU2"))
		HELP("  ",1,"OBRIGAT2",,X2NOME()+CHR(10)+CHR(13)+"Campo: "+ AllTrim(aHeadZU2[nPosField][1])+CHR(10)+CHR(13)+"Linha: "+Str(nI,3,0),3,1)
		Return .F.
	EndIf
Next nI

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ZU2LinOK    ³ Autor ³ Paulo Carnelossi    ³ Data ³ 25/08/05   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Validacao da LinOK da Getdados                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PCOXFUN                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ZU2LinOK()
Local lRet			:= .T.

If !aCols[n][Len(aCols[n])]
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica os campos obrigatorios do SX3.              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRet
		lRet := MaCheckCols(aHeader,aCols,n) 
	EndIf
EndIf
	
Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³PCOA010Leg³ Autor ³ Paulo Carnelossi      ³ Data ³ 01/03/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Monta as legendas da mBrowse.                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³PCOA010Leg                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PCOA010Leg(cAlias)
Local aLegenda := 	{ 	{"BR_AZUL"    	, "Bloqueado p/ sistema (aguardando outros niveis)" },;
								{"DISABLE" 		, "Aguardando Liberacao do usuario"   	},; 
								{"ENABLE"   	, "Liberado pelo usuario"       			},; 
								{"BR_PRETO"   	, "Cancelado"				 		      	},; 
								{"BR_CINZA"		, "Liberado por outro usuario"	      },;
								{"BR_AMARELO"  , "Remanejada"				 		      	}} 
Local aRet := {}
aRet := {}
	                           
If cAlias == Nil
	Aadd(aRet, { 'ZU1->ZU1_STATUS == "01"', aLegenda[1][1] } )
	Aadd(aRet, { 'ZU1->ZU1_STATUS == "02"', aLegenda[2][1] } )
	Aadd(aRet, { 'ZU1->ZU1_STATUS == "03"', aLegenda[3][1] } )
	Aadd(aRet, { 'ZU1->ZU1_STATUS == "04"', aLegenda[4][1] } )
	Aadd(aRet, { 'ZU1->ZU1_STATUS == "05"', aLegenda[5][1] } )
	Aadd(aRet, { 'ZU1->ZU1_STATUS == "06"', aLegenda[6][1] } )
Else
	BrwLegenda(cCadastro,"Legenda", aLegenda)
Endif

Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PcoCpoEnchoiceºAutor ³Paulo Carnelossi º Data ³  01/03/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna array com nomes dos campos referente ao alias       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PcoCpoEnchoice(cAlias, aCpos_Nao)
Local aCampos := {}
Local aArea := GetArea()
Local aAreaSX3 := SX3->(GetArea())

SX3->(DbSetOrder(1))
SX3->(MsSeek(cAlias))

While ! SX3->(Eof()) .And. SX3->x3_arquivo == cAlias
    If X3USO(SX3->x3_usado) .And. cNivel >= SX3->x3_nivel .And. ;
       aScan(aCpos_Nao, AllTrim(SX3->x3_campo))==0
	    aAdd(aCampos, AllTrim(SX3->x3_campo))
	EndIf    
	SX3->(DbSkip())
EndDo

RestArea(aArea)
RestArea(aAreaSX3)

Return aCampos


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³PcoPlanEdt³ Autor ³ Edson Maricate        ³ Data ³23.12.2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cria um Get para edicao da celula da planilha de itens      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³SIGAPCO                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function PCOEditCell(oGd)
Local aDim
Local oDlg
Local oGet1
Local oBtn
Local cMacro := ''
Local cPict	:= ''
Local nRow   := oGD:oBrowse:nAt
Local oOwner := oGD:oBrowse:oWnd
Local cClasse	:= oGD:aCols[oGD:oBrowse:nAt][aScan(oGD:aHeader,{|x| AllTrim(x[2]) == "ZU2_CLASSE"})]
Local nValor	:= PcoPlanVal(oGD:aCols[oGD:oBrowse:nAt][oGD:oBrowse:nColPos],cClasse)
Local bChange := { ||  nValor := &cMacro,.T. }
Local oRect := tRect():New(0,0,0,0)            // obtem as coordenadas da celula (lugar onde
Local cVlrFinal := ""

If Empty(cClasse)
   Return(cVlrFinal)
EndIf   

oGD:oBrowse:GetCellRect(oGD:oBrowse:nColPos,,oRect)   // a janela de edicao deve ficar)

aDim  := {oRect:nTop,oRect:nLeft,oRect:nBottom,oRect:nRight}

DEFINE MSDIALOG oDlg OF oOwner  FROM 0, 0 TO 0, 0 STYLE nOR( WS_VISIBLE, WS_POPUP ) PIXEL

PcoPlanCel(0,cClasse,,@cPict)
cMacro := "M->CELL"
&cMacro:= nValor

@ 0,0 MSGET oGet1 VAR &(cMacro) SIZE 0,0 OF oDlg FONT oOwner:oFont PICTURE cPict PIXEL HASBUTTON VALID Eval(bChange)
oGet1:Move(-2,-2, (aDim[ 4 ] - aDim[ 2 ]) + 4, aDim[ 3 ] - aDim[ 1 ] + 4 )

@ 0,0 BUTTON oBtn PROMPT "ze" SIZE 0,0 OF oDlg
oBtn:bGotFocus := {|| oDlg:nLastKey := VK_RETURN, oDlg:End(0)}

oGet1:cReadVar  := cMacro

ACTIVATE MSDIALOG oDlg ON INIT oDlg:Move(aDim[1],aDim[2],aDim[4]-aDim[2], aDim[3]-aDim[1])

cVlrFinal := PcoPlanCel(nValor,cClasse)
oGD:aCols[oGD:oBrowse:nAt][oGD:oBrowse:nColPos]	:= cVlrFinal
oGD:oBrowse:nAt := nRow
SetFocus(oGD:oBrowse:hWnd)
oGD:oBrowse:Refresh()

Return(cVlrFinal)

User Function A010AVL(cAlias,nRecnoZU1,nCallOpcx,cR1,cR2,lAuto)

If ZU1->ZU1_STATUS == "03"
	Aviso("Atencao", "Solicitação de contingencia ja liberada!",{"Ok"})

ElseIf ZU1->ZU1_STATUS == "04"
	Aviso("Atencao", "Solicitação de contingencia cancelada!",{"Ok"})

ElseIf ACESSO_AVALIA .And. U_A010DLG(cAlias,nRecnoZU1,2,cR1,cR2,lAuto)  //visualizar

	If ZU1_STATUS $ "01/02" .And. dDataBase > ZU1->ZU1_DTVALI
		If Aviso("Atencao", "Solicitação de contingencia com validade vencida! Bloqueia ?",{"Sim", "Nao"}, 2) == 1
			RecLock("ZU1", .F.)
			ZU1->ZU1_STATUS := "04"  // Bloqueado
			MsUnLock()
		EndIf
	EndIf
EndIf

Return

User Function A010Fechar(cAlias,nRecnoZU1,nCallOpcx,cR1,cR2,lAuto)

If ZU1->ZU1_STATUS $ "03/05" .And. ACESSO_FECHAR .And. U_A010DLG(cAlias,nRecnoZU1,2,cR1,cR2,lAuto)  //visualizar
	RecLock("ZU1", .F.)
	ZU1->ZU1_STATUS := "06"  //
	MsUnLock()
	PcoIniLan('999001')
	SET FILTER TO 
	Begin Transaction                                                 
	nRec	:=	ZU1->(Recno())
	SET FILTER TO
	U_MaAlcPCO(5) 
	ZU1->(MsGoTo(nRec))
	If ZU2->(dbSeek(xFilial("ZU2")+ZU1->ZU1_CDCNTG))
		While !ZU2->(Eof()) .And. ZU2->(ZU2_FILIAL+ZU2_CDCNTG) ==  xFilial("ZU2")+ZU1->ZU1_CDCNTG 	
			PcoDetLan('999001','01','RPCOA10',.T.)
			ZU2->(dbSkip())
		EndDo	
	EndIf           
	End Transaction
	PcoFinLan('999001')
	SET FILTER TO &cFiltroRot.
EndIf

Return

User Function A010BLQ(cAlias,nRecnoZU1,nCallOpcx,cR1,cR2,lAuto)

If ZU1->ZU1_STATUS == "03"
	Aviso("Atencao", "Solicitação de contingencia ja liberada, portanto não poderá ser bloqueada!",{"Ok"})
ElseIf ZU1->ZU1_STATUS == "04"
	Aviso("Atencao", "Solicitação de contingencia canceladaa!",{"Ok"})
ElseIf ACESSO_BLOQUEIA .And. ;
	U_A010DLG(cAlias,nRecnoZU1,2,cR1,cR2,lAuto)  //visualizar
	If Aviso("Atencao", "Cancelar a solicitação de contingencia ?",{"Sim", "Nao"}, 2) == 1
		SET FILTER TO
		U_MaAlcPCO(6) 
		SET FILTER TO &cFiltroRot.
	EndIf
EndIf

Return
                            


User Function A010LIB(cAlias,nRecnoZU1,nCallOpcx,cR1,cR2,lAuto)

If ZU1->ZU1_STATUS $ "03/05"
	Aviso("Atencao", "Solicitação de contingencia ja liberada!",{"Ok"})
ElseIf ZU1->ZU1_STATUS == "01"
	Aviso("Atencao", "Solicitação de contingencia aguardando liberacao de nivel anterior!",{"Ok"})
ElseIf ZU1->ZU1_STATUS == "04"
	Aviso("Atencao", "Solicitação de contingencia cancelada!",{"Ok"})
	//ElseIf ACESSO_LIBERA .And. ;
ElseIf	U_A010DLG(cAlias,nRecnoZU1,4,cR1,cR2,lAuto)  //alterar
	If Aviso("Atencao", "Liberar a solicitação de contingencia ?",{"Sim", "Nao"}, 2) == 1
		PcoIniLan('999001')
		SET FILTER TO
		Begin Transaction
		nRec	:=	ZU1->(Recno())
		If U_MaAlcPCO(4) //Se liberou ate o ultimo nivel gera os lancamentos
			ZU1->(MsGoTo(nRec))
			//LINHAS ABAIXO INSERIDAS PARA POSIONAR CORRETAMENTE NA TABELA ZU2
			DBSELECTAREA("ZU2")
			DBSETORDER(1)
			
			If ZU2->(dbSeek(xFilial("ZU2")+ZU1->ZU1_CDCNTG))
				While !ZU2->(Eof()) .And. ZU2->(ZU2_FILIAL+ZU2_CDCNTG) ==  xFilial("ZU2")+ZU1->ZU1_CDCNTG
					//					PcoDetLan('999001','01','PCOA010')
					PcoDetLan('999001','01','RPCOA10')
					ZU2->(dbSkip())
				EndDo
			EndIf
		Endif
		End Transaction
		PcoFinLan('999001')
		SET FILTER TO &cFiltroRot.
	EndIf
EndIf

Return


User Function A010BlqVen()
Local aRecVenc := {}
Local nX 
Local aArea
If  ACESSO_BLOQUEIA  .OR. RetCodUsr() == "000000"
	SET FILTER TO
	aArea	:=	GetArea()
	dbSelectArea("ZU1")
	dbSetOrder(1)
	dbSeek(xFilial("ZU1"))
	
	While ZU1->(!Eof() .And. ZU1_FILIAL == xFilial("ZU1"))
	    //verifica as solicitacoes de contingencia em aberto ou em avaliacao
		If ZU1->ZU1_STATUS $ "01;02" .And. dDataBase > ZU1->ZU1_DTVALI
			aAdd(aRecVenc, ZU1->(Recno()))
		EndIf
		ZU1->(dbSkip())
	End
	If Len(aRecVenc) > 0 
		If Aviso("Atencao", "Bloqueia as solicitações de contingencia vencidas ?", {"Sim", "Nao"}, 2) == 1
		 	For nX := 1 TO Len(aRecVenc)
		    	dbSelectArea("ZU1")
		   	dbGoto(aRecVenc[nX])
				U_MaAlcPCO(6) 
			 Next // nX
		Endif			 
	Else
		Aviso("Atencao", "Nao foi achada nenhuma contingencia vencida.", {"Fechar"})
	EndIf                
	RestArea(aArea)
	SET FILTER TO &cFiltroRot.
EndIf

Return

Static Function AjustaSX1()
Local aHelpP01	:= {}
Local aHelpE01	:= {}
Local aHelpS01	:= {}

Aadd( aHelpP01, "Filtro para as contingencias            " )

Aadd( aHelpE01, "Filtro para as contingencias            " )
Aadd( aHelpS01, "Filtro para las contingencias           " )

PutSx1('UPCO23','01','Mostrar ?','Mostrar?','Show?','mv_ch1','N', 1, 0, 0,'C','',''   ,'','','mv_par01','Pendentes','Pendentes','Pendentes','','Aprovados','Aprovados','Aprovados','Bloqueados','Bloqueados','Bloqueados','Todos','Todos','Todos','','','',aHelpP01,aHelpE01,aHelpS01)


Return .T.
Static Function PergFilter()
Local lRet	:=	.F.
If	Pergunte("UPCO23",.T.)
	lRet	:=	.T.	
	cFiltroRot :=	If(__cUserID <> "000000","('"+__cUserID+"' == ZU1->ZU1_USER)","")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Controle de Aprovacao : CR_STATUS -->                ³
	//³ 01 - Bloqueado p/ sistema (aguardando outros niveis) ³
	//³ 02 - Aguardando Liberacao do usuario                 ³
	//³ 03 - Liberado pelo usuario                    		 ³
	//³ 04 - Bloqueado pelo usuario                   		 ³
	//³ 05 - Liberado por outro usuario              		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicaliza a funcao FilBrowse para filtrar a mBrowse          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("ZU1")
	dbSetOrder(1)
	Do Case
	Case mv_par01 == 1
		cFiltroRot += IIf(Empty(cFiltroRot),"",".And.")+"ZU1->ZU1_STATUS=='02'"
	Case mv_par01 == 2
		cFiltroRot +=  IIf(Empty(cFiltroRot),"",".And.")+"(ZU1->ZU1_STATUS=='03'.OR.ZU1->ZU1_STATUS=='05')"
	Case mv_par01 == 3
		cFiltroRot +=  IIf(Empty(cFiltroRot),"",".And.")+"(ZU1->ZU1_STATUS=='01'.OR.ZU1->ZU1_STATUS=='04')"
	OtherWise
		cFiltroRot +=  IIf(Empty(cFiltroRot),"",".And.")+"ZU1->ZU1_STATUS!='01'"
	EndCase

	dbSelectArea("ZU1")
	dbSetOrder(1)
	If !Empty(cFiltroRot)
		SET FILTER TO &cFiltroRot.
	Endif
Endif
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MenuDEF  º Autor ³Eduardo de Souza    º Data ³12/Jan/2007  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Implementa menu funcional                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Menus                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo as Rotinas a executar do programa      ³
//³ ----------- Elementos contidos por dimensao ------------     ³
//³ 1. Nome a aparecer no cabecalho                              ³
//³ 2. Nome da Rotina associada                                  ³
//³ 3. Usado pela rotina                                         ³
//³ 4. Tipo de Transa‡„o a ser efetuada                          ³
//³    1 - Pesquisa e Posiciona em um Banco de Dados             ³
//³    2 - Simplesmente Mostra os Campos                         ³
//³    3 - Inclui registros no Bancos de Dados                   ³
//³    4 - Altera o registro corrente                            ³
//³    5 - Remove o registro corrente do Banco de Dados          ³
//³    3 - Duplica o registro corrente do Banco de Dados         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function MenuDef()
Local aRotina 	:= {	{ "Pesquisar"		,		"AxPesqui" 		, 0 , 1},;
							{ "Visualizar"		, 		"U_A010DLG"  		, 0 , 2},;
							{ "Excluir"			, 		"U_A010DLG"  		, 0 , 5},;
							{ "Liberar"			, 		"U_A010LIB"  		, 0 , 4},;
							{ "Cancelar"		, 		"U_A010BLQ"  		, 0 , 4},; 
							{ "Blq. Vencidas"	, 		"U_A010BlqVen"   	, 0 , 4},; 
							{ "Fechar"			, 		"U_A010Fechar"   	, 0 , 4},; 
							{ "Legenda"			, 		"U_PCOA010Leg"  	, 0 , 1}}
Return aRotina
