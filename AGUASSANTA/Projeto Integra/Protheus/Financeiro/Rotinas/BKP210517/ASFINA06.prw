#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA06()

Visualiza aprovadores do título posicionado

Chamada pela rotina ASFINA05

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		06/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA06()
	LOCAL aArea		:= GetArea()
	LOCAL aButtons	:= {}
	LOCAL aCols     := {}
	LOCAL aDesPesq	:= {}
	LOCAL aHeader   := {}
	LOCAL cTitulo	:= "Visualiza aprovadores do título"
	LOCAL oDlgSZ5
	LOCAL oGD
	
	PRIVATE aCoord	:= FwGetDialogSize(oMainWnd)

	aAdd(aHeader,{""				,"_SEMAFARO"	,"@BMP"						,10,0,,,"C",,"V",,,"Enable","V","S"} )
	Aadd(aHeader,{"Nível"			,"Z5_NIVEL"		,""							,TAMSX3("Z5_NIVEL")[1]		,0,"","","C","","V","",""})
	Aadd(aHeader,{"Status"			,"STATUS"		,""							,28							,0,"","","C","","V","",""})
	Aadd(aHeader,{"Usuário"			,"Z5_USER"		,""							,TAMSX3("Z5_USER")[1]		,0,"","","C","","V","",""})
	Aadd(aHeader,{"Cód.Aprovador"	,"Z5_APROV"		,""							,TAMSX3("Z5_APROV")[1]		,0,"","","C","","V","",""})
	Aadd(aHeader,{"Nome"			,"E2_XAPROVA"	,""							,TAMSX3("E2_XAPROVA")[1]	,0,"","","C","","V","",""})
	Aadd(aHeader,{"Grupo Aprov."	,"Z5_GRUPO"		,""							,TAMSX3("Z5_GRUPO")[1]		,0,"","","C","","V","",""})
	Aadd(aHeader,{"Data"			,"Z5_EMISSAO"	,""							,10							,0,"","","D","","V","",""})

	//-----------------------------------------------------------------------
	// Popula com os aprovadores do título
	//-----------------------------------------------------------------------
	MntaCols(aHeader,@aCols)
	
	//-----------------------------------------------------------------------
	// Monta tela
	//-----------------------------------------------------------------------
	oDlgSZ5 := MSDIALOG():New(aCoord[1],aCoord[2],aCoord[3]/2,(aCoord[4]/2)+100,cTitulo,,,,,,,,,.T.)    
			
	oGD := MsNewGetDados():New(0,0,50,100,,,,,,0,Len(aCols),,,,oDlgSZ5,aHeader,aCols,.T.)
	oGD:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

	//EnchoiceBar - Criação de barras de botões padrão ( oDlg bOkb Cancel [ lMsgDel ] [ aButtons ] [ nRecno ] [ cAlias ] [lMashups] [lImpCad] [lPadrao] [lHasOk] [lWalkThru] [cProfileID] ) --> Nil

	oDlgSZ5:bInit := {|| EnchoiceBar(oDlgSZ5, {||oDlgSZ5:End()},{||oDlgSZ5:End()},,aButtons,,,.F.,.F.,.T.,.F.,.F.)}
	
	oDlgSZ5:lCentered := .T.
	oDlgSZ5:Activate()

	RestArea( aArea )
RETURN


//-----------------------------------------------------------------------
/*/{Protheus.doc} MntaCols()

Popula com os aprovadores do título

@param		aHeader	=	Header do dialog
			aCols	=	Colunas do dialog (passada como referência)
@return		Nenhum
@author 	Fabio Cazarini
@since 		06/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION MntaCols(aHeader,aCols)
	LOCAL cQuery	:= ""

	cQuery := " SELECT SZ5.R_E_C_N_O_  AS REGSZ5 "
	cQuery += " FROM " + RetSqlName("SZ5") + " SZ5 "
	cQuery += " WHERE	SZ5.Z5_FILIAL = '" + xFILIAL("SZ5") + "' " 
	cQuery += " 	AND SZ5.Z5_NUM = '" + SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA) + "' "
	cQuery += " 	AND SZ5.D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY SZ5.Z5_NIVEL, SZ5.Z5_USER "
	
	IF SELECT("TRBSZ5") > 0
		TRBSZ5->( dbCloseArea() )
	ENDIF    
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), "TRBSZ5" ,.F.,.T.)
	
	DbSelectArea("TRBSZ5")
	TRBSZ5->( DbGoTop() )
	DO WHILE !TRBSZ5->( EOF() )
		DbSelectArea("SZ5")
		SZ5->( DbGoTo( TRBSZ5->REGSZ5 ) )

		Aadd(aCols,Array(Len(aHeader)+1))
		
		aCols[Len(aCols)][1]	:= IIF(SZ5->Z5_STATUS == "03", 'ENABLE', 'DISABLE' )
		aCols[Len(aCols)][2]	:= SZ5->Z5_NIVEL
		IF SZ5->Z5_STATUS == "01"
			aCols[Len(aCols)][3]	:= "01=Aguardando nivel anterior"
		ELSEIF SZ5->Z5_STATUS == "03"
			aCols[Len(aCols)][3]	:= "03=Liberado"
		ELSEIF SZ5->Z5_STATUS == "04"
			aCols[Len(aCols)][3]	:= "04=Bloqueado"
		ELSEIF SZ5->Z5_STATUS == "05"
			aCols[Len(aCols)][3]	:= "05=Liberado outro usuario"
		ELSE
			aCols[Len(aCols)][3]	:= "02=Pendente"
		ENDIF
		aCols[Len(aCols)][4]	:= SZ5->Z5_USER
		aCols[Len(aCols)][5]	:= SZ5->Z5_APROV
		aCols[Len(aCols)][6]	:= UsrRetName(SZ5->Z5_USER)
		aCols[Len(aCols)][7]	:= SZ5->Z5_GRUPO
		aCols[Len(aCols)][8]	:= SZ5->Z5_EMISSAO
		aCols[Len(aCols),Len(aHeader)+1] := .F.
	
		DbSelectArea("TRBSZ5")
		TRBSZ5->( DbSkip() )
	ENDDO
	TRBSZ5->( dbCloseArea() )

RETURN