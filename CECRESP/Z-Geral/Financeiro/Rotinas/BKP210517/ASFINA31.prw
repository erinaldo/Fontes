#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

STATIC lF060ASit	:= ExistBlock("F060ASit")

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA31()

Executa a transferência do portador e situação em lote

Chamado pela rotina ASFINA30

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		08/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra 
@releases	05/05/17 - Zema: - Retirar a seleção por borderô
							 - Exibir tela para seleção dos titulos (MarkBrowse)
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA31()
	LOCAL nOpca 	:= 0
	LOCAL lEnd		:= .F.
	LOCAL nProcess	:= 0
	LOCAL lContinua	:= .T.                          

	PRIVATE cSITSE1		:= ALLTRIM(GETNEWPAR( "AS_SITSE1", "8", cFILANT )) // Situações dos títulos a receber securitizados. Sep. p/ '|'. Exemplo: 0|1
	PRIVATE cSITSE9		:= ALLTRIM(GETNEWPAR( "AS_SITSE9", "9", cFILANT )) // Situações dos títulos a receber securitizados vencidos. Sep. p/ '|'. Exemplo: 2
	PRIVATE cSITSEC		:= cSITSE1 + IIF(RIGHT(cSITSE1,1)=="|","","|") + cSITSE9
	PRIVATE cNumBorDe	:= Space(06)
	PRIVATE cNumBorAte	:= "ZZZZZZ"
	PRIVATE oSituacao
	PRIVATE cDescricao	:= ""
	PRIVATE cSituacAtu	:= ""
	PRIVATE cSituacao	:= Space(1)
	PRIVATE cAgen060	:= CriaVar("EF_AGENCIA",.f.)
	PRIVATE cConta060	:= CRIAVAR("EF_CONTA",.F.)
	PRIVATE cPort060	:= CRIAVAR("EF_BANCO",.F.)
	PRIVATE dVencIni	:= dDataBase
	PRIVATE dVencFim	:= dDataBase
	PRIVATE dEmisDe		:= dDataBase
	PRIVATE dEmisAte	:= dDataBase
	PRIVATE cCliDe		:= Space(Len(SE1->E1_CLIENTE))
	PRIVATE cCliAte		:= Replicate("Z",Len(SE1->E1_CLIENTE))
	PRIVATE cPrefDe		:= Space(Len(SE1->E1_PREFIXO))
	PRIVATE cPrefAte	:= Replicate("Z",Len(SE1->E1_PREFIXO))
	PRIVATE cNumDe		:= Space(Len(SE1->E1_NUM))
	PRIVATE cNumAte		:= Replicate("Z",Len(SE1->E1_NUM))
	PRIVATE cNatureza 	:= Space(10)
	PRIVATE cContrato	:= Space(Len(SE1->E1_CONTRAT))
	PRIVATE cNumBco		:= Space(Len(SE1->E1_NUMBCO))
	PRIVATE lDesc 		:= .F.
	PRIVATE oPort060	:= NIL
	PRIVATE nValor		:= 0
	PRIVATE nAbatim		:= 0
	PRIVATE nDescont 	:= 0
	PRIVATE nJuros	 	:= 0
	PRIVATE cPortAnt	:= ""
	PRIVATE cSituant	:= ""
	PRIVATE dDataMov	:= dDataBase
	PRIVATE lTitProIns 	:= .F.
	PRIVATE lRespProIn	:= .F.
	PRIVATE nIof	  	:= 0  
	PRIVATE cContTINI   := SPACE(TAMSX3("E1_XCONTRA")[1])
	PRIVATE cContTINF   := Replicate("Z",Len(E1_XCONTRA))

	//-----------------------------------------------------------------------
	// Carrega as perguntas da rotina
	//-----------------------------------------------------------------------
	pergunte("FIN060",.F.)

	//-----------------------------------------------------------------------
	// Verifica se data do movimento não é menor que data limite de
	// movimentacao no financeiro
	//-----------------------------------------------------------------------
	IF !DtMovFin()
		RETURN
	ENDIF

	M->E1_SITUACA		:= cSituacao

	DEFINE MSDIALOG oDlg TITLE "Transferência em lote" FROM 5,0 To 24,71 OF oMainWnd //26

	oDlg:lMaximized := .F.
	oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,20,20)
	oPanel:Align := CONTROL_ALIGN_ALLCLIENT

/* Release 05/05/17 Zema
	@ 014, 002 Say "Borderô no." SIZE 39, 7 OF oPanel PIXEL
	@ 014, 035 MSGET cNumBorde  Picture "@!" SIZE 37,8 OF oPanel PIXEL
	@ 014, 100 Say "a" 		SIZE 40,7 OF oPanel PIXEL
	@ 014, 117 MSGET cNumBorate Valid cNumBorate >= cNumBorde Picture "@!" SIZE 37,8 OF oPanel PIXEL
*/
	@ 014, 002 Say "Venc Real"		SIZE 40,7 OF oPanel PIXEL
	@ 014, 035 MSGET dVencIni		SIZE 54,8 OF oPanel PIXEL HASBUTTON
	@ 014, 100 Say "a" 				SIZE 40,7 OF oPanel PIXEL
	@ 014, 117 MSGET dVencFim		Valid dVencFim >= dVencIni ;
	SIZE 54,8 OF oPanel PIXEL HASBUTTON

	@ 026, 002 Say "Emissão" 		SIZE 40,7 OF oPanel PIXEL
	@ 026, 035 MSGET dEmisDe 		SIZE 54,8 OF oPanel PIXEL HASBUTTON
	@ 026, 100 Say "a" 				SIZE 40,7 OF oPanel PIXEL  //"a"
	@ 026, 117 MSGET dEmisAte   	Valid dEmisAte >= dEmisDe ;
	SIZE 54,8 OF oPanel PIXEL HASBUTTON

	@ 038, 002 Say "Cliente" 		SIZE 40,7 OF oPanel PIXEL
	@ 038, 035 MSGET cCliDe F3 "CLI" SIZE 54,8 OF oPanel PIXEL HASBUTTON
	@ 038, 100 Say "a" 				SIZE 40,7 OF oPanel PIXEL
	@ 038, 117 MSGet cCliAte F3 "CLI" Valid cCliAte >= cCliDe SIZE 54,8 OF oPanel PIXEL HASBUTTON

	@ 050, 002 Say "Prefixo" 		SIZE 40,7 OF oPanel PIXEL
	@ 050, 035 MSGET cPrefDe 		SIZE 54,8 OF oPanel PIXEL
	@ 050, 100 Say "a" 				SIZE 40,7 OF oPanel PIXEL
	@ 050, 117 MSGET cPrefAte Valid cPrefAte >= cPrefDe SIZE 54,8 OF oPanel PIXEL

	@ 062, 002 Say "Título" 		SIZE 40,7 OF oPanel PIXEL
	@ 062, 035 MSGET cNumDe 		SIZE 54,8 OF oPanel PIXEL
	@ 062, 100 Say "a" 		SIZE 40,7 OF oPanel PIXEL
	@ 062, 117 MSGet cNumAte Valid cNumAte >= cNumDe SIZE 54,8 OF oPanel PIXEL
	
	@ 074, 002 Say "Contrato de" 	SIZE 40,7 OF oPanel PIXEL
	@ 074, 035 MSGET cContTINI		SIZE 54,8 OF oPanel PIXEL
	@ 074, 100 Say "ate" 			SIZE 40,7 OF oPanel PIXEL
	@ 074, 117 MSGET cContTINF Valid cPrefAte >= cPrefDe SIZE 54,8 OF oPanel PIXEL


	//-----------------------------------------------------------------------
	//Parte 2 da tela - Operacao
	//-----------------------------------------------------------------------
	
	//Alteração feita em 05/04/2017 - Fabiano Albuquerque
	/*
	
	@ 098, 002 Say "Portador"		SIZE 40, 7 OF oPanel PIXEL
	@ 098, 035 MSGET oPort060 VAR cPort060  Picture "@!" F3 "SA6" ;
	VALID AS31Por2(cPort060,@cAgen060,@cSituacao,@cContrato,@cNumBco,@cConta060) .AND. CarregaSa6(@cPort060,@cAgen060,@cConta060,.F.) ;
	SIZE 54,8 OF oPanel PIXEL HASBUTTON
	@ 098, 092 Say "Agência" 		SIZE 40, 7 OF oPanel PIXEL
	@ 098, 117 MSGET cAgen060	Picture "@!" ;
	VALID CarregaSa6(@cPort060,@cAgen060,@cConta060,.F.) ;
	SIZE 54,8 OF oPanel PIXEL
	@ 098, 184 Say "Conta" 		SIZE 40, 7 OF oPanel PIXEL // "Conta"
	@ 098, 204 MSGET cConta060	Picture "@!" VALID CarregaSa6(@cPort060,@cAgen060,@cConta060,.F.,,.T.) ;
	SIZE 62,8 OF oPanel PIXEL

	*/    

	@ 098, 002 Say "Situação" 		SIZE 40, 7 OF oPanel PIXEL
	@ 098, 035 MSGET oSituacao VAR M->E1_SITUACA  F3 "AGSFRV" PICTURE "@!" ;
	Valid AS31Sit( M->E1_SITUACA, cPort060,oSituacao,oDescricao,@cNatureza,@cDescricao) ;
	SIZE 35, 10 OF oPanel PIXEL HASBUTTON
	@ 098, 092 MSGET oDescricao VAR cDescricao SIZE 108, 8 OF oPanel PIXEL WHEN .F.
    
	/*
	@ 122, 003 SAY "Contrato" 	SIZE 25, 7 OF oPanel PIXEL
	@ 122, 035 MSGET cContrato	SIZE 45,10 OF oPanel PIXEL
	@ 122, 092 SAY	 "No. Portador"	SIZE 42, 7 OF oPanel PIXEL
	@ 122, 126 MSGET cNumBco 		SIZE 88,10 OF oPanel PIXEL
	*/    

	@ 001, 001 TO 086, 282 LABEL "Posição atual" OF oPanel PIXEL
	@ 086, 001 TO 123, 282 LABEL "Transferir para" OF oPanel PIXEL //137

	DEFINE SBUTTON FROM 129, 217 TYPE 1 ACTION (nOpca:=1, If(DadosOK(), oDlg:End(), nOpca := 0 )) ENABLE OF oPanel
	DEFINE SBUTTON FROM 129, 244 TYPE 2 ACTION (nOpca:=0,oDlg:End()) ENABLE OF oPanel

	ACTIVATE MSDIALOG oDlg CENTERED

	IF nOpca == 1
		PROCESSA({|lEnd| nProcess := Transfere()},"Processando")
		
		MsgInfo("Processo concluído. Foi(ram) transferido(s) " + ALLTRIM(STR(nProcess)) + " registro(s)","Transferência em lote")
	ENDIF

RETURN


//-----------------------------------------------------------------------
/*/{Protheus.doc} AS31Sit()

Valida a situação digitada do título

@param 		cSituacao	= Situacao de cobranca a ser validada
			cPort060	= Codigo do portador
			oSituacao	= Objeto da situacao de cobranca
			oDescricao	= Objeto da descrição da situacao de cobranca
			cNatureza	= Natureza para IOF  (referencia)
			oDescricao	= Descrição da situacao de cobranca (referencia)
@return		lRet		= Validado ou nao
@author 	Fabio Cazarini
@since 		11/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION AS31Sit(cSituacao,cPort060,oSituacao,oDescricao,cNatureza,cDescricao)
	LOCAL lRet			:= .T.
	LOCAL lIsCarteira	:= FN022SITCB(cSituacao)[1]

	If lRet
		dbSelectArea("FRV")
		If MsSeek(xFilial("FRV")+cSituacao)
			cDescricao 		:= FRV->FRV_DESCRI
			cNatureza		:= FRV->FRV_NATIOF
		Endif
	Endif

	//oSituacao:Refresh()
	oDescricao:Refresh()

RETURN lRet


//-----------------------------------------------------------------------
/*/{Protheus.doc} AS31Por2()

Verifica o portador digitado

@param 		cPort060	= Codigo do portador
			cAgen060	= Agencia
			cSituacao	= Situa‡„o
			cContrato	= Contrato
			cNumBco		= N£mero do documento no banco
			cConta060	= Conta Corrente
@return 	lRetorna - retorna se válidado ou nao
@author 	Fabio Cazarini
@since 		11/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------

/* Alterado em 05/04/2017 - Fabiano Albuquerque
STATIC FUNCTION AS31Por2( cPort060,cAgen060,cSituacao,cContrato,cNumBco,cConta060 )
	LOCAL lRetorna := .T.

	If Empty(cPort060)
		cNumBco		:= Space(Len(cNumBco))  //Nosso Numero
		cAgen060	:= Space(Len(cAgen060))
		cSituacao	:= Replicate("0",Len(cSituacao))
		cContrato	:= Space(Len(cContrato))
		cConta060	:= Space(Len(cConta060))
	EndIf

RETURN lRetorna
*/

//-----------------------------------------------------------------------
/*/{Protheus.doc} DadosOK()

Valida dados da tela

@param		Nenhum
@return		lRet = Dados ok ou não
@author 	Fabio Cazarini
@since 		11/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION DadosOK()
	LOCAL lRet 			:= .T.
	LOCAL lIsCarteira	:= FN022SITCB(M->E1_SITUACA)[1]
	LOCAL lIsDescont	:= FN022SITCB(M->E1_SITUACA)[3]
	
	//-----------------------------------------------------------------------
	// Valida o portador digitado
	//-----------------------------------------------------------------------
	IF lRet
		If !Empty(cPort060)
			dbSelectArea("SA6")
			If !(dbSeek(cFilial+cPort060))
				Help(" ",1,"E1_PORTADO")
				lRet := .F.
			EndIf
		ENDIF
	ENDIF

	IF lRet
		If !Empty(cPort060)
			dbSelectArea("SA6")
			If !(dbSeek(cFilial+cPort060+cAgen060))
				Help(" ",1,"E1_PORTADO")
				lRet := .F.
			EndIf
			dbSelectArea("SE1")
		EndIf
	ENDIF

	IF lRet
		If !Empty(cPort060)
			dbSelectArea("SA6")
			If !(dbSeek(cFilial+cPort060+cAgen060+cConta060))
				Help(" ",1,"E1_CONTA")
				lRet := .F.
			ElseIf SA6->A6_BLOCKED == "1"
				Help( " ", 1, "CCBLOCKED" )
				lRet := .F.
			EndIf
		ENDIF
	ENDIF

	//-----------------------------------------------------------------------
	// Valida a situacao digitada
	//-----------------------------------------------------------------------
	IF lRet
		IF EMPTY(M->E1_SITUACA)
			Help(" ",1,"SITCOB",,"Digite a situação de cobrança.",1,0)
			lRet := .F.
		ELSE
			dbSelectArea("FRV")
			dbSetOrder(1)
			If MsSeek(xFilial("FRV")+M->E1_SITUACA)
				cSituacAtu		:= M->E1_SITUACA +" ("+ cDescricao +")"
				cNatureza		:= FRV->FRV_NATIOF
			Else
				Help(" ",1,"SITCOB",,"Situação de cobrança não cadastrada. Verifique o cadastro de situações de cobrança.",1,0)
				lRet := .F.
			Endif
		ENDIF
	ENDIF

	IF lRet
		IF !(M->E1_SITUACA $ cSITSEC) .AND. M->E1_SITUACA <> "0" 
			Help(" ",1,"SITCOB",,"A Situação de cobrança não é válida. Digite uma das seguintes situações: " + IIF("0"$cSITSEC,"","0, ") + STRTRAN(cSITSEC,"|",", "),1,0) 
			lRet := .F.
		ENDIF
	ENDIF

	IF lRet
		IF lIsDescont
			Help(" ",1,"SITCOB",,"Não pode ser usada uma situação de transferência para desconto",1,0)
			lRet := .F.
		ENDIF
	ENDIF

	//-----------------------------------------------------------------------
	// Verifica se a situação e banco/agencia/conta estão coerentes
	//-----------------------------------------------------------------------
	IF lRet
		IF lIsCarteira  //Se situacao de cobranca for carteira
			IF !Empty(cPort060) .or. !Empty(cAgen060) .or. !Empty(cConta060)
				Help(" ",1,"CARTEIRA")
				lRet := .F.
			EndIF
		Else
			IF Empty(cPort060) .or. Empty(cAgen060) .or. Empty(cConta060)
				Help(" ",1,"BCOOBRIGAT")
				lRet := .F.
			Endif
		EndIF
	ENDIF


	// Valida o contrato inicial e final
	IF !EMPTY(cContTINF)
		IF !EMPTY(cContTINI)
			IF cContTINF < cContTINI
				ApMsgAlert("Sequencia de contratos inválida.")
				lRet := .F.
			ENDIF
		ENDIF	
	ENDIF

RETURN lRet

//-----------------------------------------------------------------------
/*/{Protheus.doc} Transfere()

Transfere um lote de títulos de um portador para outro

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		11/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION Transfere()
	LOCAL nRet			:= 0
	LOCAL cQuery		:= ""
	LOCAL nReg			:= 0
	LOCAL nLinha		:= 0
	LOCAL aRegs			:= {}
	LOCAL nX			:= 0

	
	cSituacao := M->E1_SITUACA 
	
	//-----------------------------------------------------------------------
	// Monta TRB com títulos em aberto no critério informado
	//-----------------------------------------------------------------------
	cQuery := " SELECT SE1.R_E_C_N_O_  AS REGSE1 "
	cQuery += " FROM " + RetSqlName("SE1") + " SE1 "
	cQuery += " WHERE	SE1.E1_FILIAL = '" + xFILIAL("SE1") + "' "
	cQuery += " 	AND SE1.E1_SALDO > 0 "

	// Release 05/05/17 - Zema
	//cQuery += " 	AND SE1.E1_NUMBOR BETWEEN '" + cNumBorde + "' AND '" + cNumBorate + "' "

	cQuery += " 	AND SE1.E1_VENCREA BETWEEN '" + DTOS(dVencIni) + "' AND '" + DTOS(dVencFim) + "' "
	cQuery += " 	AND SE1.E1_EMISSAO BETWEEN '" + DTOS(dEmisDe) + "' AND '" + DTOS(dEmisAte) + "' "
	cQuery += " 	AND SE1.E1_CLIENTE BETWEEN '" + cCliDe + "' AND '" + cCliAte + "' "
	cQuery += " 	AND SE1.E1_PREFIXO BETWEEN '" + cPrefDe + "' AND '" + cPrefAte + "' "
	cQuery += " 	AND SE1.E1_NUM BETWEEN '" + cNumDe + "' AND '" + cNumAte + "' "
	
	IF !EMPTY(cContTINI+cContTINF)
		cQuery += " 	AND SE1.E1_XCONTRA >=  '" + cContTINI + "' AND SE1.E1_XCONTRA <=  '" + cContTINF + "' "		
	ENDIF
	     
	// Release 05/05/17 Zema
	cQuery += " 	AND SE1.E1_SITUACA <>  '" + cSituacao + "' "		
	
	cQuery += " 	AND SE1.D_E_L_E_T_ = ' ' "

	IF SELECT("TRB") > 0
		TRB->( dbCloseArea() )
	ENDIF
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), "TRB" ,.F.,.T.)

    // Release 05/05/17 - Zema
    
    //  Seleciona os titulos a serem processados
    aRegs := SelTit()

	TRB->(DBCLOSEAREA())
	//-----------------------------------------------------------------------
	// Processa a transferência
	//-----------------------------------------------------------------------
	//TRB->(dbEval({|| nReg++ },,{|| !Eof()}))
	//TRB->(dbGoTop())
    nReg := LEN(aRegs)
	ProcRegua( nReg )
	//DbSelectArea("TRB")
	//DbGoTop()
	//DO WHILE !TRB->( EOF() )

	IF nReg > 0
		IF !MsgYesNo("Confirma dados?","Atenção")
			nReg := 0
		ENDIF
	ENDIF

	FOR nX := 1 TO nReg
		nLinha++
		IncProc( "Aguarde..." + ALLTRIM(STR(nLinha)) )

		DbSelectArea("SE1")
		DbGoTo( aRegs[nX] )
		
		//-----------------------------------------------------------------------
		// Valida o título posicionado
		//-----------------------------------------------------------------------
		nValor := SE1->E1_SALDO
		IF ValidaTit()
			IF TransfTit()
				nRet++
			ENDIF
		ENDIF
		
//		DbSelectArea("TRB")
//		TRB->( DbSkip() )
//	ENDDO
	Next nX	


RETURN nRet


//-----------------------------------------------------------------------
/*/{Protheus.doc} TransfTit()

Transfere o título posicionado

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		11/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION TransfTit()
	LOCAL lRet			:= .F. // indica que foi processado algum registro
	LOCAL nI			:= 0
	LOCAL nJ			:= 0
	LOCAL cChavEA		:= ""
	LOCAL dBase			:= Ctod("//")
	LOCAL bWhile 		:= {||!EOF() .And. E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA == cKeySE1}
	LOCAL cPortAux		:= cPort060 
	LOCAL cAgenAux		:= cAgen060 
	LOCAL cContaAux		:= cConta060 
	LOCAL cSituaAux		:= cSituacao 
	LOCAL cContrAux		:= cContrato 
	LOCAL cNumBcoAux	:= cNumBco 
	LOCAL lMarkAbt 		:= .F.
	LOCAL l060SEA 		:= ExistBlock("F060SEA")
	LOCAL lF060DGV 		:= ExistBlock("F060DGV")
	LOCAL lHead 		:= .F.
	LOCAL nTotal		:= 0
	LOCAL cHistorico	:= ""
	LOCAL lPadrao		:= .F.
	LOCAL lSpbInUse 	:= SpbInuse()
	LOCAL cFilBor		:= ""
	LOCAL nMoedaBco 	:= 1
	LOCAL nValCred		:= 0   
	
	//-----------------------------------------------------------------------
	// Habilita ou não a alteração dos campos:
	// Portador, Agência, Conta, Contrato, Nr Portador
	//-----------------------------------------------------------------------
	IF AltPorRM()
		cPort060	:= cPortAux
		cAgen060	:= cAgenAux
		cConta060	:= cContaAux
		cSituacao	:= cSituaAux
		cContrato	:= cContrAux
		cNumBco		:= cNumBcoAux
	ELSE
		cPort060	:= SE1->E1_PORTADO
		cAgen060	:= SE1->E1_AGEDEP
		cConta060	:= SE1->E1_CONTA
		cSituacao	:= SE1->E1_SITUACA
		cContrato	:= SE1->E1_CONTRAT
		cNumBco		:= SE1->E1_NUMBCO
	ENDIF
	
	PcoIniLan("000003")

	dbSelectArea("SE1")
	If !Empty(SE1->E1_NUMBOR) .And. Fa150PesqBord(SE1->E1_NUMBOR,@cFilBor)
		cChavEA	 := cFilBor+E1_NUMBOR+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	Else
		cChavEA	 := xFilial("SEA")+E1_NUMBOR+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	EndIf
	cSituAnt := SE1->E1_SITUACA
	cPortAnt := SE1->E1_PORTADO
	//-----------------------------------------
	//Transferido para situacao de protesto    
	//-----------------------------------------
	If FN022SITCB(cSituacao)[4] .and. !FN022SITCB(cSituAnt)[4]
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza T¡tulos protestados 					 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SA1")
		If (dbSeek(XFILIAL("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA))
			Reclock("SA1")
			SA1->A1_TITPROT := SA1->A1_TITPROT+1
			SA1->A1_DTULTIT := dDataBase
			MsUnlock()
		Endif
		dbSelectArea("SE1")
		If !Empty(SE1->E1_IDCNAB) 
			IF !lRespProIn
				IF MsgYesNo("Deseja cadastrar instrução de cobrança para posterior envio ao banco?","Títulos protestados")
					lTitProIns 	:= .T.
					lRespProIn	:= .T.
				ENDIF
			ENDIF
			
			IF lTitProIns
				Fa040AltOk({Space(10)}, {""},,.F., .T., .F.)
				F040GrvFI2()
			ENDIF
		Endif	
	Endif
	//---------------------------------------------------------------------------------
	//Atualizo o numero de protestos dos clientes quando
	//Transfiro de uma situacao de protesto para carteira que nao tenha protesto
	//---------------------------------------------------------------------------------
	IF (FN022SITCB(cSituacao)[1] .and. !FN022SITCB(cSituacao)[4]) .and. FN022SITCB(cSituAnt)[4]
		//-------------------------------------------
		// Atualiza T¡tulos protestados 				
		//-------------------------------------------
		dbSelectArea("SA1")
		If (dbSeek(XFILIAL("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA))
			Reclock("SA1")
			SA1->A1_TITPROT := SA1->A1_TITPROT-1
			MsUnlock( )
		Endif
		dbSelectArea("SE1")
		If !Empty(SE1->E1_IDCNAB) 
			IF !lRespProIn
				IF MsgYesNo("Deseja cadastrar instrução de cobrança para posterior envio ao banco?","Títulos protestados")
					lTitProIns 	:= .T.
					lRespProIn	:= .T.
				ENDIF
			ENDIF
			
			IF lTitProIns
				Fa040AltOk({Space(10)}, {""},,.F., .F., .T.)
				F040GrvFI2()
			ENDIF	
		Endif	
	Endif
	//-------------------------------------------
	//Transferido para situacao com portador
	//-------------------------------------------
	IF FN022SITCB(cSituacao)[2] .and. cSituacao != cSituAnt
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza data vencto real c/reten‡„o Banc ria³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		// Se possuir retencao bancaria, grava a data de vencimento
		IF mv_par10 == 1 .And. nRetencao>0
			dBase	:=	SE1->E1_VENCREA
			For nJ := 1 To nRetencao
				dBase := DataValida(dBase+1,.T.)
			Next nJ
			Reclock("SE1")
			SE1->E1_VENCREA := dBase
			MsUnlock()
			
			lRet := .T. // indica que foi processado algum registro
			
			// Atualiza tambem os registros agregados
			F060AtuAgre()
		EndIF

		//DDA - Debito Direto Autorizado
		If SE1->E1_OCORREN $ "53/52"
			Reclock("SE1")
			SE1->E1_OCORREN := "01"
			MsUnlock()
			
			lRet := .T. // indica que foi processado algum registro
			
		Endif

	EndIF
	//-------------------------------------------------------------------------
	//Transferido para carteira (situacao anterior com portador)
	//-------------------------------------------------------------------------
	IF FN022SITCB(cSituacao)[1] .and. FN022SITCB(cSituAnt)[2]
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza data vencto real s/reten‡„o Banc ria³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		// Se considera retencao bancaria
		If mv_par10 == 1
			Reclock("SE1")
			SE1->E1_VENCREA := DataValida(SE1->E1_VENCORI,.T.)
			If SE1->E1_VENCREA < SE1->E1_VENCTO
				SE1->E1_VENCREA := DataValida(SE1->E1_VENCTO,.T.)
			Endif		
			MsUnlock()
			
			lRet := .T. // indica que foi processado algum registro
			
			// Atualiza tambem os registros agregados
			F060AtuAgre()
		EndIF
	Endif	
	//---------------------------------------------
	// Estorno de cobran‡a descontada -> carteira
	//---------------------------------------------
	//If FN022SITCB(cSituAnt)[2] .And. cSituacao != cSituant
	If FN022SITCB(cSituAnt)[3] .And. cSituacao != cSituant
		If ((mv_par03 == 1 .And. FN022SITCB(cSituacao)[1] ) .Or. mv_par03 == 2) .and. GetMv("MV_ESTDESC") == "S"

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³  S¢ dever  ser buscada a baixa no SE5 quando o titulo a ser  ³
			//³transferido para carteira nÆo perten‡a a um bordero descontado³
			//³pois o valor que ‚ informado no momento da transferencia banco³
			//³p/carteira se perde por nÆo se encontrar o movimento no SE5,  ³
			//³pois o movimento no SE5 p/ bord.descontados ‚ o do bordero e  ³
			//³nÆo o do titulo.                                              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Empty (SE1->E1_NUMBOR)
				If !lF060DGV
					aBaixa := Sel070Baixa( "TR /",SE1->E1_PREFIXO,SE1->E1_NUM, SE1->E1_PARCELA,SE1->E1_TIPO,,,SE1->E1_CLIENTE,SE1->E1_LOJA,nValDesc,.t.)
					nValCred := nValDesc
				Else
					nValCred := ExecBlock("F060DGV",.F.,.F.,{nValCred,nValDesc})
				Endif
			Else
				nValCred := nValDesc
			Endif

			// Verifica se a natureza esta cadastrada. Se nao, cria.
			Fa060Nat(2,cNatureza)

			dbSelectArea("SE5")
			dbSetOrder(2)
			RecLock("SE5",.T.)
			SE5->E5_FILIAL	:= xFilial("SE5")
			SE5->E5_BANCO	:= SE1->E1_PORTADO
			SE5->E5_AGENCIA := SE1->E1_AGEDEP
			SE5->E5_CONTA	:= SE1->E1_CONTA
			SE5->E5_DATA	:= dDataMov
			SE5->E5_TIPODOC := "E2"
			SE5->E5_HISTOR  := cHistorico
			SE5->E5_TIPO	:= SE1->E1_TIPO
			SE5->E5_CCUSTO := SE1->E1_CCUSTO

			nMoedaBco := Max( MoedaBco(SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA), 1)
			SE5->E5_MOEDA := StrZero(nMoedaBco,2)

			If cPaisloc <> "BRA"
				nDecs := MsDecimais( nMoedaBco)
				SE5->E5_VALOR   := nValCred
				SE5->E5_VLMOED2 := Round(NoRound( xMoeda( nValCred, nMoedaBco, SE1->E1_MOEDA, dDataMov, nDecs+1), nDecs+1), nDecs)
				nTxMoeda := If( SE1->E1_MOEDA > 1, RecMoeda(dDataMov,SE1->E1_MOEDA), 0 )
				SE5->E5_TXMOEDA:=nTxMoeda 
			Else
				SE5->E5_VALOR	:= nValCred
				SE5->E5_VLMOED2 := Round(NoRound(xMoeda(nValCred,nMoedaBco,SE1->E1_MOEDA,dDataMov,3),3),2)
			EndIf

			SE5->E5_RECPAG  := "P"
			SE5->E5_PREFIXO := SE1->E1_PREFIXO
			SE5->E5_NUMERO  := SE1->E1_NUM
			SE5->E5_PARCELA := SE1->E1_PARCELA
			SE5->E5_LA		:= Iif(lPadrao,"S","N")
			SE5->E5_DTDIGIT := dDataBase
			SE5->E5_DTDISPO := SE5->E5_DATA
			SE5->E5_NATUREZ := cNatureza
			SE5->E5_MOTBX	:= "NOR"
			SE5->E5_SEQ		:= If( Len( aBaixa ) > 0,aBaixaSE5[01,09],"")
			SE5->E5_CLIFOR	:= SE1->E1_CLIENTE
			SE5->E5_CLIENTE := SE1->E1_CLIENTE
			SE5->E5_LOJA 	:= SE1->E1_LOJA

			If lSpbInUse
				SE5->E5_MODSPB := "1"
			Endif

			nRecSe5Trf      := SE5->(RECNO())
			MsUnlock()
			
			// permite manipulacao do SE5 neste momento
			If Existblock("FA60SIT2")
				Execblock("FA60SIT2",.F.,.F.)
			Endif
			
			AtuSalBco(SE1->E1_PORTADO,SE1->E1_AGEDEP,SE1->E1_CONTA,dDataMov,nValCred,"-")
			MsUnlock()
			If nIof>0 .and. cPaisLoc=="BRA"     
				dbSelectArea("SE5")
				dbSetOrder(2)
				RecLock("SE5",.T.)
					SE5->E5_FILIAL  := cFilial
				SE5->E5_BANCO	:= SE1->E1_PORTADO
				SE5->E5_AGENCIA	:= SE1->E1_AGEDEP
				SE5->E5_CONTA	:= SE1->E1_CONTA
				SE5->E5_DATA	:= dDataMov
				SE5->E5_TIPODOC	:= "EI"
				SE5->E5_HISTOR	:= "Cancelamento de cob de IOF"
				SE5->E5_TIPO	:= SE1->E1_TIPO
					SE5->E5_CCUSTO := SE1->E1_CCUSTO
	
				nMoedaBco := Max( MoedaBco(SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA), 1)
				SE5->E5_MOEDA := StrZero(nMoedaBco,2)
	
				SE5->E5_VALOR	:= nIof
				SE5->E5_VLMOED2 := Round(NoRound(xMoeda(nIof,nMoedaBco,SE1->E1_MOEDA,dDataMov,3),3),2)
				SE5->E5_RECPAG  := "R"
				SE5->E5_PREFIXO := SE1->E1_PREFIXO
				SE5->E5_NUMERO  := SE1->E1_NUM
				SE5->E5_PARCELA := SE1->E1_PARCELA
				SE5->E5_LA		:= "S"
				SE5->E5_DTDIGIT := dDataBase
				SE5->E5_DTDISPO := SE5->E5_DATA
				SE5->E5_NATUREZ := cNatureza
				SE5->E5_MOTBX	:= "IOF"
				SE5->E5_SEQ		:= If( Len( aBaixa ) > 0,aBaixaSE5[01,09],"")
				SE5->E5_CLIFOR	:= SE1->E1_CLIENTE
				SE5->E5_CLIENTE := SE1->E1_CLIENTE
				SE5->E5_LOJA	:= SE1->E1_LOJA

				If lSpbInUse
					SE5->E5_MODSPB := "1"
				Endif    
					SE5->E5_FILORIG			:= SE1->E1_FILORIG
				MsUnlock() 
			Endif
		EndIf
	Endif

	//Saldo do titulo para contabilizacao de diferenca
	nValSaldo := Round(NoRound(xMoeda(SE1->E1_SALDO,SE1->E1_MOEDA,nMoedaBco,dDatabase,3),3),2) 

	// Banco vazio, contabiliza anterior	                            
	If Empty(cPort060)		
		dbSelectArea("SA6")
		dbSeek(xFilial()+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA)
	Else
		dbSelectArea("SA6")
		dbSeek(xFilial()+cPort060+cAgen060+cConta060)	
	Endif

	//Retorno para carteira os abatimentos do titulo independente de serem considerados
	If (FN022SITCB(cSituAnt)[3] .Or. lMarkAbt ) .And. cSituacao != cSituant
		If nAbatim > 0 .Or. lMarkAbt
			cKeySE1 := xFilial("SE1")+SE1->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA)
			aAreaSe1 := SE1->(GetArea())	
			dbSelectArea("SE1")
			SE1->(dbSetOrder(2))
			SE1->(dbSeek(cKeySE1))
			While !EOF() .And. E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA == cKeySE1
				IF E1_TIPO $ MVABATIM
					RecLock("SE1")
					SE1->E1_PORTADO := cPort060
					SE1->E1_AGEDEP  := cAgen060
					SE1->E1_SITUACA := cSituacao
					SE1->E1_CONTRAT := cContrato
					SE1->E1_NUMBCO  := cNumBco
					SE1->E1_MOVIMEN := dDataMov
					SE1->E1_CONTA	 := cConta060
					If cSituacao != cSituAnt
						SE1->E1_NUMBOR := " "
						SE1->E1_DATABOR:= Ctod("  /  /  ")
					EndIf
					SE1->( MsUnLock() )
					
					lRet := .T. // indica que foi processado algum registro
					
				EndIF
				dbSkip()
			Enddo
			RestArea(aAreaSe1)
		Endif
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Baixa da cobranca descontada (opcional)		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If FN022SITCB(cSituacao)[3] .and. mv_par04 == 1  .and. cSituacao != cSituant .and. cPaisLoc != "PTG"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza Saldo de Duplicadas do Cliente		 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SA1")
		If (dbSeek(XFILIAL("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA))
			AtuSalDup("-",SE1->E1_SALDO,SE1->E1_MOEDA,SE1->E1_TIPO,,SE1->E1_EMISSAO)
		Endif

		//Baixo todos os abatimentos do titulo independente de serem considerados
		If nAbatim > 0
			cKeySE1 := xFilial("SE1")+SE1->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA)   
			cTitPai	:= SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE+SE1->E1_LOJA
			aAreaSe1 := SE1->(GetArea())	
			dbSelectArea("SE1")
			SE1->(dbSetOrder(2))    
			SE1->(dbSeek(cKeySE1))
			
			If lTitpaiSE1
		 		If (nOrdTitPai:= OrdTitpai()) > 0
					DbSetOrder(nOrdTitPai)				   
					If	DbSeek(xFilial("SE1")+cTitPai)    
		  				bWhile  := {|| !Eof() .And. Alltrim(SE1->E1_TITPAI) == Alltrim(cTitPai)}  
		  			Else
		  				SE1->(dbSetOrder(2))    
		 				SE1->(dbSeek(cKeySE1))
	 	   			Endif
	 	   		EndIf
	  		Endif

			While Eval(bWhile)
				IF E1_TIPO $ MVABATIM
					RecLock("SE1")
					SE1->E1_SALDO		:= 0
					SE1->E1_BAIXA		:= dDataBase
					SE1->E1_MOVIMEN		:= dDataMov
					SE1->E1_STATUS		:= "B"
					SE1->E1_SDACRES		:= 0
					SE1->E1_SDDECRE		:= 0
					SE1->E1_PORTADO		:= cPort060
					SE1->E1_AGEDEP		:= cAgen060
					SE1->E1_CONTA		:= cConta060
					SE1->E1_SITUACA		:= cSituacao
					SE1->E1_CONTRAT		:= cContrato
					SE1->( MsUnLock() )
					
					lRet := .T. // indica que foi processado algum registro
					
				EndIF
				dbSkip()
			Enddo
			RestArea(aAreaSe1)
		Endif

		DbSelectArea("SE1")
		RecLock("SE1")
		nSE1Rec := Recno()
		Replace E1_SALDO	With 0
		Replace E1_BAIXA	With dDataBase
		Replace E1_MOVIMEN	With dDataMov
		Replace E1_VALLIQ	With E1_VALOR 
		Replace E1_STATUS	With "B"
		Replace E1_JUROS	With nJuros
		Replace E1_DESCONT	With nDescont
		
		lRet := .T. // indica que foi processado algum registro
	Endif
	MsUnlock()

	If FN022SITCB(cSituacao)[3] .And. cSituacao != cSituAnt

		//Se nao for adiantamento, verifico os abatimentos
		If !SE1->E1_TIPO $ MVRECANT+ "/"+MV_CRNEG
			SumAbatRec(SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA, SE1->E1_MOEDA,"V",,@nTotAbImp)
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Localiza a sequencia da baixa ( BA )								  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cSequencia := FaNxtSeqBx()  // Sequencia da baixa do titulo + 1++

		//	Verifica se a natureza esta cadastrada. Se nao, cria.
		Fa060Nat(1,cNatureza)

		IF GetMv("MV_SLDBXCR") == "C" .and. cSituacao == "7"
			IF GETMV("MV_VLTRANS") == 1
				RecLock("SE5",.T.)
				SE5->E5_FILIAL  := xFilial("SE5")
				SE5->E5_BANCO   := cPort060
				SE5->E5_AGENCIA := cAgen060
				SE5->E5_CONTA   := cConta060
				SE5->E5_DATA	:= dDataMov
				SE5->E5_TIPODOC := "BA"
				SE5->E5_HISTOR  := cHistorico
				SE5->E5_TIPO	:= SE1->E1_TIPO
				SE5->E5_CCUSTO := SE1->E1_CCUSTO

				nMoedaBco := Max( MoedaBco(SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA), 1)
				SE5->E5_MOEDA := StrZero(nMoedaBco,2)

				If cPaisloc <> "BRA"
					nDecs := MsDecimais( nMoedaBco)
					SE5->E5_VALOR   := Round(NoRound( xMoeda( nValCred, SE1->E1_MOEDA, nMoedaBco, dDataMov, nDecs+1), nDecs+1), nDecs)  
					SE5->E5_VLMOED2 := nValCred
					nTxMoeda := If( SE1->E1_MOEDA > 1, RecMoeda(dDataMov,SE1->E1_MOEDA), 0 )
					SE5->E5_TXMOEDA:=nTxMoeda 
					SE5->E5_VLDESCO	:= nValSaldo - nValCred
				Else
					SE5->E5_VALOR   := Round(NoRound(xMoeda(nValCred,SE1->E1_MOEDA,nMoedaBco,dDataMov,3,nTxMoeda),3),2)
					SE5->E5_VLMOED2 := nValCred
					SE5->E5_VLDESCO := nValSaldo - Round(NoRound( xMoeda( nValCred, SE1->E1_MOEDA, nMoedaBco, dDataMov, 3,nTxMoeda), 3), 2)  
				EndIf
				SE5->E5_RECPAG  := "R"
				SE5->E5_PREFIXO := SE1->E1_PREFIXO
				SE5->E5_NUMERO  := SE1->E1_NUM
				SE5->E5_PARCELA := SE1->E1_PARCELA
				SE5->E5_LA 	    := Iif(lPadrao,"S","N")
				SE5->E5_DTDIGIT := dDataBase
				SE5->E5_DTDISPO := SE5->E5_DATA
				SE5->E5_NATUREZ := cNatureza
				SE5->E5_MOTBX   := "NOR"
				SE5->E5_CLIFOR	:= SE1->E1_CLIENTE
				SE5->E5_CLIENTE := SE1->E1_CLIENTE
				SE5->E5_LOJA	:= SE1->E1_LOJA
				SE5->E5_SEQ		:= cSequencia   
				SE5->E5_FILORIG	:= SE1->E1_FILORIG

				If lSpbInUse
					SE5->E5_MODSPB := "1"
				Endif
		
				nRecSe5Trf      := SE5->(RECNO())
				MsUnlock()
			ELSE	
				RecLock("SE5",.T.)
    			SE5->E5_FILIAL  := xFilial("SE5")
				SE5->E5_BANCO   := cPort060
				SE5->E5_AGENCIA := cAgen060
				SE5->E5_CONTA   := cConta060
				SE5->E5_DATA	:= dDataMov
				SE5->E5_TIPODOC := "TR"
				SE5->E5_HISTOR  := cHistorico
				SE5->E5_TIPO	:= SE1->E1_TIPO
				SE5->E5_CCUSTO := SE1->E1_CCUSTO
				
				If Alltrim(SE1->E1_ORIGEM) == "FINA460" .and. SuperGetMv("MV_GRSEFLQ",,.F.)
					dbSelectArea("SEF")
					DbSetOrder(7)
					If DbSeek(xFilial("SEF")+"R"+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO)
						RecLock("SEF",.F.)
						SEF->EF_DTCOMP := dDataMov
						MsUnlock()
					Endif
				Endif
				
				nMoedaBco := Max( MoedaBco(SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA), 1)
				SE5->E5_MOEDA := StrZero(nMoedaBco,2)
				
				If cPaisloc <> "BRA"
					nDecs := MsDecimais( nMoedaBco)
					SE5->E5_VALOR   := Round(NoRound( xMoeda( nValCred, SE1->E1_MOEDA, nMoedaBco, dDataMov, nDecs+1), nDecs+1), nDecs)  
					SE5->E5_VLMOED2 := nValCred
					nTxMoeda := If( SE1->E1_MOEDA > 1, RecMoeda(dDataMov,SE1->E1_MOEDA), 0 )
					SE5->E5_TXMOEDA:=nTxMoeda
					SE5->E5_VLDESCO	:= nValSaldo - nValCred
				Else
					SE5->E5_VALOR   := Round(NoRound(xMoeda(nValCred,SE1->E1_MOEDA,nMoedaBco,dDataMov,3,nTxMoeda),3),2)
					SE5->E5_VLMOED2 := nValCred
					SE5->E5_VLDESCO := nValSaldo - Round(NoRound( xMoeda( nValCred, SE1->E1_MOEDA, nMoedaBco, dDataMov, 3,nTxMoeda), 3), 2)  
				EndIf  
				
				SE5->E5_RECPAG  := "R"
				SE5->E5_PREFIXO := SE1->E1_PREFIXO
				SE5->E5_NUMERO  := SE1->E1_NUM
				SE5->E5_PARCELA := SE1->E1_PARCELA
				SE5->E5_LA 	    := Iif(lPadrao,"S","N")
				SE5->E5_DTDIGIT := dDataBase
				SE5->E5_DTDISPO := SE5->E5_DATA
				SE5->E5_NATUREZ := cNatureza
				SE5->E5_MOTBX   := "NOR"
				SE5->E5_CLIFOR	:= SE1->E1_CLIENTE
				SE5->E5_CLIENTE := SE1->E1_CLIENTE
				SE5->E5_LOJA 	:= SE1->E1_LOJA
				SE5->E5_SEQ 	:= cSequencia

				If lSpbInUse
					SE5->E5_MODSPB := "1"
				Endif

		        SE5->E5_FILORIG			:= SE1->E1_FILORIG
				nRecSe5Trf      := SE5->(RECNO())
				MsUnlock()
			ENDIF	
        Else
			RecLock("SE5",.T.)
			SE5->E5_FILIAL  := xFilial("SE5")
			SE5->E5_BANCO   := cPort060
			SE5->E5_AGENCIA := cAgen060
			SE5->E5_CONTA   := cConta060
			SE5->E5_DATA	 := dDataMov
			SE5->E5_TIPODOC := "TR"
			SE5->E5_HISTOR  := cHistorico
			SE5->E5_TIPO	 := SE1->E1_TIPO		
			SE5->E5_CCUSTO := SE1->E1_CCUSTO

			nMoedaBco := Max( MoedaBco(SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA), 1)
			SE5->E5_MOEDA := StrZero(nMoedaBco,2)

			If cPaisloc <> "BRA"
				nDecs := MsDecimais( nMoedaBco)
				SE5->E5_VALOR   := Round(NoRound( xMoeda( nValCred, SE1->E1_MOEDA, nMoedaBco, dDataMov, nDecs+1), nDecs+1), nDecs)  
				SE5->E5_VLMOED2 := nValCred
				nTxMoeda := If( SE1->E1_MOEDA > 1, RecMoeda(dDataMov,SE1->E1_MOEDA), 0 )
				SE5->E5_TXMOEDA:=nTxMoeda 
				SE5->E5_VLDESCO	:= nValSaldo - nValCred
			Else
				SE5->E5_VALOR   := Round(NoRound(xMoeda(nValCred,SE1->E1_MOEDA,nMoedaBco,dDataMov,3,nTxMoeda),3),2)
				SE5->E5_VLMOED2 := nValCred
				SE5->E5_VLDESCO := nValSaldo - Round(NoRound( xMoeda( (nValCred+nIof), SE1->E1_MOEDA, nMoedaBco, dDataMov, 3,nTxMoeda), 3), 2)  
			EndIf
			SE5->E5_RECPAG  := "R"
			SE5->E5_PREFIXO := SE1->E1_PREFIXO
			SE5->E5_NUMERO  := SE1->E1_NUM
			SE5->E5_PARCELA := SE1->E1_PARCELA
			SE5->E5_LA 	    := Iif(lPadrao,"S","N")
			SE5->E5_DTDIGIT := dDataBase
			SE5->E5_DTDISPO := SE5->E5_DATA
			SE5->E5_NATUREZ := cNatureza
			SE5->E5_MOTBX   := "NOR"
			SE5->E5_CLIFOR	:= SE1->E1_CLIENTE
			SE5->E5_CLIENTE := SE1->E1_CLIENTE
			SE5->E5_LOJA 	:= SE1->E1_LOJA
			SE5->E5_SEQ 	:= cSequencia  
			SE5->E5_FILORIG	:= SE1->E1_FILORIG

			If lSpbInUse
				SE5->E5_MODSPB := "1"
			Endif
	
			nRecSe5Trf      := SE5->(RECNO())
			MsUnlock()
		ENDIF	

		AtuSalBco(cPort060,cAgen060,cConta060,dDataMov,nValCred,"+")
		
		If nIof > 0 .and. cPaisloc=="BRA"
			RecLock("SE5",.T.)
			SE5->E5_FILIAL  := xFilial("SE5")
			SE5->E5_BANCO   := cPort060
			SE5->E5_AGENCIA := cAgen060
			SE5->E5_CONTA   := cConta060
			SE5->E5_DATA	:= dDataMov
			SE5->E5_TIPODOC := "I2" //TIPODOC PARA IOF
			SE5->E5_HISTOR  := "IOF sobre cob descontada"
			SE5->E5_TIPO	:= SE1->E1_TIPO		
			SE5->E5_CCUSTO := SE1->E1_CCUSTO

			nMoedaBco := Max( MoedaBco(SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA), 1)
			SE5->E5_MOEDA := StrZero(nMoedaBco,2)

			SE5->E5_VALOR   := Round(NoRound(xMoeda(nIof,SE1->E1_MOEDA,nMoedaBco,dDataMov,3,nTxMoeda),3),2)
			SE5->E5_VLMOED2 := nIof
			SE5->E5_RECPAG  := "P"
			SE5->E5_PREFIXO := SE1->E1_PREFIXO
			SE5->E5_NUMERO  := SE1->E1_NUM
			SE5->E5_PARCELA := SE1->E1_PARCELA
			SE5->E5_LA 	    := "S"
			SE5->E5_DTDIGIT := dDataBase
			SE5->E5_DTDISPO := SE5->E5_DATA
			SE5->E5_NATUREZ := cNatureza
			SE5->E5_MOTBX   := "IOF"
			SE5->E5_CLIFOR	:= SE1->E1_CLIENTE
			SE5->E5_CLIENTE := SE1->E1_CLIENTE
			SE5->E5_LOJA 	:= SE1->E1_LOJA
			SE5->E5_SEQ 	:= cSequencia      
			SE5->E5_FILORIG	:= SE1->E1_FILORIG

			If lSpbInUse
				SE5->E5_MODSPB := "1"
			Endif
			MsUnlock()
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava baixa do titulo descontado no SE5 (se optado)			  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par04 == 1   // Baixa Titulo quando da Transferencia

			//O valor da baixa deve considerar o abatimento sempre.
			//Se mv_par08 == 1, nValCred ja tem o valor do abatimento subtraido
			//Se mv_par08 == 2, nValCred nao tem o valor do abatimento subtraido
			nValBaixa := nValCred - IIF(mv_par08 == 2, nAbatim,0)

			For nI := 1 To 3
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Atualiza a Movimenta‡„o Bancaria       					     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If nI == 1
					cCpoTp  := "nDescont"
					cTpDoc  := "D2"
					cHistMov:= "Desconto s/Receb.Titulo"
				Elseif nI == 2
					cCpoTp  := "nJuros"
					cTpDoc  := "J2"
					cHistMov:= "Juros s/Receb.Titulo"
				Elseif nI == 3
					cCpoTp  := "nValBaixa"
					cTpDoc  := "BA"
					cHistMov:= OemToAnsi( "Baixa Titulo por Transferencia" )
				Endif
	
				If &cCpoTp != 0 .or. nI == 3
					dbSelectArea("SE5")
					RecLock("SE5",.T.)
					SE5->E5_FILIAL		:= xFilial("SE5")
					SE5->E5_BANCO		:= cPort060
					SE5->E5_AGENCIA	:= cAgen060
					SE5->E5_CONTA		:= cConta060
					SE5->E5_DATA		:= SE1->E1_BAIXA

					nMoedaBco := Max( MoedaBco(SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA), 1)
					SE5->E5_MOEDA := StrZero(nMoedaBco,2)

					If cPaisloc <> "BRA"
						nDecs := MsDecimais( nMoedaBco)
						SE5->E5_VALOR   := Round(NoRound( xMoeda( &cCpoTp, SE1->E1_MOEDA, nMoedaBco, SE1->E1_BAIXA, nDecs+1), nDecs+1), nDecs)  
						SE5->E5_VLMOED2 := &cCpoTp
						nTxMoeda := If( SE1->E1_MOEDA > 1, RecMoeda(SE1->E1_BAIXA,SE1->E1_MOEDA), 0 )
						SE5->E5_TXMOEDA:=nTxMoeda
        				nDescont:= nValSaldo - &cCpoTp
        			Else
						SE5->E5_VALOR	:= Round(NoRound(xMoeda(&cCpoTp,SE1->E1_MOEDA,nMoedaBco,SE1->E1_BAIXA,3,nTxMoeda),3),2)
						SE5->E5_VLMOED2	:= &cCpoTp
					  	nDescont:= nValSaldo - Round(NoRound(xMoeda(&cCpoTp,SE1->E1_MOEDA,nMoedaBco,SE1->E1_BAIXA,3,nTxMoeda),3),2)
						nDescont-= nTotAbImp //Subtraio os valores dos impostos
					EndIf
					SE5->E5_NATUREZ	:= SE1->E1_NATUREZ
					SE5->E5_RECPAG	:= "R"
					SE5->E5_PREFIXO	:= SE1->E1_PREFIXO
					SE5->E5_NUMERO	:= SE1->E1_NUM
					SE5->E5_PARCELA	:= SE1->E1_PARCELA
					SE5->E5_TIPO	:= SE1->E1_TIPO
					SE5->E5_CLIFOR	:= SE1->E1_CLIENTE
					SE5->E5_CLIENTE	:= SE1->E1_CLIENTE
					SE5->E5_LOJA	:= SE1->E1_LOJA
					SE5->E5_BENEF	:= SE1->E1_NOMCLI
					SE5->E5_DTDIGIT	:= dDataBase
					SE5->E5_MOTBX	:= "NOR"
					SE5->E5_DTDISPO	:= SE5->E5_DATA
					SE5->E5_SEQ		:= cSequencia
					SE5->E5_TIPODOC	:= cTpDoc
					SE5->E5_HISTOR	:= cHistMov
					SE5->E5_SITCOB	 := cSituacao
					SE5->E5_FILORIG		:= SE1->E1_FILORIG
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Grava os valores agregados ao titulo no totalizador ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If nI == 3		// registro totalizador
						SE5->E5_VLJUROS	:= nJuros
						SE5->E5_VLDESCO	:= nDescont
						nRecSe5Bai		:= SE5->(RecNo())
					Endif
					SE5->E5_CCUSTO := SE1->E1_CCUSTO
					MsUnlock()
				EndIf
		   Next
		Endif
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Baixa da cobranca descontada (opcional)			³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If FN022SITCB(cSituacao)[3] .and. mv_par04 == 1  .and. cSituacao != cSituant
		//Caso baixe o titulo por cobranca descontada, gero comissao para o fornecedor      
		aadd(aBaixas,{SE5->E5_MOTBX,SE5->E5_SEQ,SE5->(Recno())})
		
		If GETMV("MV_TPCOMIS") == "O"
			Fa440CalcB(aBaixas,lJuros,lDescont,"FINA060",,,,.T.,nSE1Rec)
		Endif
	Endif
	
	If FN022SITCB(cSituacao)[1]		//cSituacao $ "0FG"
		dbSelectArea("SEA")
		If dbSeek(cChavEA)
			RecLock("SEA",.F.,.T.)
			dbDelete()
			MsUnlock()
			SX2->(MsUnlock())
		EndIf
	Else
		dbSelectArea("SEA")
		If !dbSeek(cChavEA)    
			RecLock("SEA",.T.)
		Else
			RecLock("SEA")
		EndIf
		SEA->EA_FILIAL  := xFilial("SEA")
		SEA->EA_DATABOR := dDataBase
		SEA->EA_PORTADO := cPort060
		SEA->EA_AGEDEP  := cAgen060
		SEA->EA_NUMCON  := cConta060
		SEA->EA_SITUACA := cSituacao
		SEA->EA_NUM 	:= SE1->E1_NUM
		SEA->EA_PARCELA := SE1->E1_PARCELA
		SEA->EA_PREFIXO := SE1->E1_PREFIXO
		SEA->EA_TIPO	:= SE1->E1_TIPO
		SEA->EA_CART	:= "R"
		SEA->EA_SITUANT := cSituant
		SEA->EA_FILORIG := SE1->E1_FILORIG
		If l060SEA
			ExecBlock("F060SEA",.f.,.f.)
		Endif
		SEA->(MsUnlock())	// Destravar SEA apos alteracoes
	Endif
	FKCOMMIT()

	RecLock("SE1")
	VAR_IXB   := SE1->E1_PORTADO // Guardo portador anterior, para possivel utilizacao no LP
	SE1->E1_PORTADO := cPort060
	SE1->E1_AGEDEP  := cAgen060
	SE1->E1_SITUACA := cSituacao
	SE1->E1_CONTRAT := cContrato
	SE1->E1_NUMBCO  := cNumBco
	SE1->E1_MOVIMEN := dDataMov
	SE1->E1_CONTA	:= cConta060
	If cSituacao != cSituAnt .And. !Empty(SE1->E1_NUMBOR)
		SE1->E1_NUMBOR := " "
		SE1->E1_DATABOR:= Ctod("  /  /  ")
	EndIf
	SE1->( MsUnLock() )
	
	lRet := .T. // indica que foi processado algum registro
	
	FKCOMMIT()

	If ExistBlock("F060ACT")  //PE antes da Contabilização da Transferência
		aDadosF060ACT := {M->E1_SITUACA,cPort060,cAgen060,cConta060,lDesc,cCliente,cTitulo,cSituAnt,cContrato,cPortador}
		ExecBlock("F060ACT",.F.,.F.,{aDadosF060ACT})
	EndIf

	If cSituant != SE1->E1_SITUACA .and. mv_par03 == 1 // contabiliza transferencias
		cPadrao:=fA060Pad(cSituacao, .F.)
		lPadrao:=VerPadrao(cPadrao)

		STRLCTPAD := cSituant   // Disponibiliza a situacao anterior para ser utilizada no LP
		VALOR  := nValCred		// para contabilizar o total descontado (PRIVATE)
		IOF	   := nIof
		VALOR2 := nValSaldo 		// Saldo dos titulo para contabilizacao da diferenca
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ A variavel lHead controla se a rotina HeadProva ja' ³
		//³ foi executada, visto que ela s¢ pode ser executada  ³
		//³ uma £nica vez e n„o h  como identificar se a mesma  ³
		//³ j  foi executada ou n„o (T=J  fez , F=N„o fez)      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lPadrao .and. mv_par03 == 1
			If !lHead
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Inicializa Lancamento Contabil                                   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nHdlPrv := HeadProva( cLote,;
					                      "FINA060" /*cPrograma*/,;
					                      Substr( cUsuario, 7, 6 ),;
					                      @cArquivo )
				lHead := .T.
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Prepara Lancamento Contabil                                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lUsaFlag .and. (nRecSe5Trf > 0) // Armazena em aFlagCTB para atualizar no modulo Contabil 
					aAdd( aFlagCTB, {"E5_LA", "S", "SE5", nRecSe5Trf, 0, 0, 0} )
				Endif
				
				nTotal += DetProva( nHdlPrv,;
				                    cPadrao,;
				                    "FINA060" /*cPrograma*/,;
				                    cLote,;
				                    /*nLinha*/,;
				                    /*lExecuta*/,;
				                    /*cCriterio*/,;
				                    /*lRateio*/,;
				                    /*cChaveBusca*/,;
				                    /*aCT5*/,;
				                    /*lPosiciona*/,;
				                    @aFlagCTB,;
				                    /*aTabRecOri*/,;
				                    /*aDadosProva*/ )
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Lancamento 522 - Contabilizacao de Titulos a serem  ³
		//³ descontados                                         ³
		//³ Lancamento 528 - Idem 522 para caucion descontados  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cPadrao :=Iif(cSituacao=="2","522","528")
		lPadrao :=VerPadrao(cPadrao) // Contabilizacao da baixa
		If lPadrao .and. mv_par04 == 1 .and. FN022SITCB(cSituacao)[3]
			If !lHead
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Inicializa Lancamento Contabil                                   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nHdlPrv := HeadProva( cLote,;
					                      "FINA060" /*cPrograma*/,;
					                      Substr( cUsuario, 7, 6 ),;
					                      @cArquivo )
				lHead := .T.
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Prepara Lancamento Contabil                                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lUsaFlag .and. (nRecSe5Bai > 0) // Armazena em aFlagCTB para atualizar no modulo Contabil 
					aAdd( aFlagCTB, {"E5_LA", "S", "SE5", nRecSe5Bai, 0, 0, 0} )
				Endif

				nTotal += DetProva( nHdlPrv,;
				                    cPadrao,;
				                    "FINA060" /*cPrograma*/,;
				                    cLote,;
				                    /*nLinha*/,;
				                    /*lExecuta*/,;
				                    /*cCriterio*/,;
				                    /*lRateio*/,;
				                    /*cChaveBusca*/,;
				                    /*aCT5*/,;
				                    /*lPosiciona*/,;
				                    @aFlagCTB,;
				                    /*aTabRecOri*/,;
				                    /*aDadosProva*/ )
			
		Endif
		If lHead .and. mv_par03 == 1
			lDigita:=IIF(mv_par01==1,.T.,.F.)
			lAglut :=IIF(mv_Par02==1,.T.,.F. )
			If UsaSeqCor()
				aDiario := {{"SE5",SE5->(recno()),cCodDiario,"E5_NODIA","E5_DIACTB"}}
			Else
				aDiario := {} 
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Efetiva Lan‡amento Contabil                                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				RodaProva( nHdlPrv,;
				           nTotal)

				cA100Incl( cArquivo,;
				           nHdlPrv,;
				           3 /*nOpcx*/,;
				           cLote,;
				           lDigita,;
				           lAglut,;
				           /*cOnLine*/,;
				           /*dData*/,;
				           /*dReproc*/,;
				           @aFlagCTB,;
				           /*aDadosProva*/,;
				           aDiario )
				
				aFlagCTB := {}  // Limpa o coteudo apos a efetivacao do lancamento
		EndIF
		If nTotal > 0 .and. nRecSe5Trf > 0
			SE5->(DbGoto(nRecSe5Trf))

			If !lUsaFlag
				RecLock( "SE5" )
				SE5->E5_LA := "S" // Contabilizou o LP
				MsUnlock()
			Endif	
			
		Endif
		If nTotal > 0 .and. nRecSe5Bai > 0
			SE5->(DbGoto(nRecSe5Bai))

			If !lUsaFlag
				RecLock( "SE5" )
				SE5->E5_LA := "S" // Contabilizou o LP
				MsUnlock()
			Endif	
			
		Endif
	EndIf
	
	If cSituacao $ "0FG" 		//Carteira, Carteira Protesto e Carteira Acordo
		PcoDetLan("000003","01","FINA060")
	ElseIf cSituacao $ "1H"		//Simples e Cartorio
		PcoDetLan("000003","02","FINA060")
	ElseIf cSituacao == "2"		//Descontada
		PcoDetLan("000003","03","FINA060")
	ElseIf cSituacao == "3"		//Caucionada
		PcoDetLan("000003","04","FINA060")
	ElseIf cSituacao == "4"		//Vinculada
		PcoDetLan("000003","05","FINA060")
	ElseIf cSituacao == "5"		//Advogado
		PcoDetLan("000003","06","FINA060")
	ElseIf cSituacao == "6"		//Judicial
		PcoDetLan("000003","07","FINA060")
	ElseIf cSituacao == "7"		//Caucionada Descontada
		PcoDetLan("000003","16","FINA060")

	//Para as novas situacoes de cobranca
	//repito os processos padroes existentes de acordo com a categoria de cada uma
	ElseIF FN022SITCB(cSituacao)[1]		//Carteira cSituacao $ "0|F|G"
		PcoDetLan("000003","01","FINA060")
	ElseIf FN022SITCB(cSituacao)[5]	//Simples e Cartorio   cSituacao $ "1|H"
		PcoDetLan("000003","02","FINA060")
	ElseIf FN022SITCB(cSituacao)[3]	//Descontada 	cSituacao $ "2|7"
		PcoDetLan("000003","03","FINA060")
	ElseIf FN022SITCB(cSituacao)[4]	//Cobranca em banco com protesto	
		PcoDetLan("000003","07","FINA060")
	ElseIf FN022SITCB(cSituacao)[2]	//Cobranca em banco sem protesto exceto Simples e Cartorio
		PcoDetLan("000003","05","FINA060")
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Pontos de Entrada 									³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF ExistBlock("FA60TRAN")
		ExecBlock("FA60TRAN",.F.,.F.)
	Endif

	If ExistBlock("F060EXIT")			// Log para Saida
		Execblock("F060EXIT",.F.,.F.)
	Endif
	
	PcoFinLan("000003")

RETURN lRet


//-----------------------------------------------------------------------
/*/{Protheus.doc} ValidaTit()

Valida o título posicionado

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		11/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION ValidaTit()
	LOCAL lRet 			:= .T.
	LOCAL lIsCarteira	:= FN022SITCB(SE1->E1_SITUACA)[1]
	LOCAL lIsDescont	:= FN022SITCB(SE1->E1_SITUACA)[3]

	//-----------------------------------------------------------------------
	// Valida o portador do título
	//-----------------------------------------------------------------------
	//If !Empty(SE1->E1_PORTADO)
	//	If cPort060 != SE1->E1_PORTADO .and. (GetNewPar("MV_TRFBCO","2") == "2" .or. FN022SITCB(SE1->E1_SITUACA)[3]) 		// se Permite TRF entre bancos
	//		RETURN .F.
	//	ENDIF
	//EndIf

	If lF060ASit .AND. !Empty(SE1->E1_NUMBOR)
		lF060ASit := ExecBlock("F060ASit")
	EndIf

	If (!Empty(SE1->E1_NUMBOR) .And. ((cConta060 <> SE1->E1_CONTA .And. !Empty(cConta060)) .Or.;
	(cAgen060 != SE1->E1_AGEDEP .And. !Empty(cAgen060)))) .and. !lF060ASit
		RETURN .F.
	EndIF

	If (!Empty(SE1->E1_NUMBOR) .And. ((cConta060 != SE1->E1_CONTA .And. !Empty(cConta060)) .Or.;
	(cAgen060 != SE1->E1_AGEDEP .And. !Empty(cAgen060)))) .and. !lF060ASit
		RETURN .F.
	EndIf

	//-----------------------------------------------------------------------
	// Para o Brasil, apresenta somente os titulos cuja moeda e' a mesma do banco
	// selecionado para baixa.
	// Caso a moeda do banco estiver vazia ou caso o motivo de baixa nao movimente banco, considero apenas a moeda forte
	//-----------------------------------------------------------------------
	If FXMultSld()
		If MoedaBco(cPort060,cAgen060,cConta060) > 1
			If cPaisLoc=="BRA" .and. !FXVldBxBco(cPort060,cAgen060,cConta060,SE1->E1_NATUREZ, SE1->E1_MOEDA)
				RETURN .F.
			Endif
		Endif
	EndIf

	//-----------------------------------------------------------------------
	// Valida o tipo do título
	//-----------------------------------------------------------------------
	If SE1->E1_TIPO $ MVPROVIS
		RETURN .F.
	Endif

	If SE1->E1_TIPO $ MVENVBCOR
		RETURN .F.
	Endif

	If SE1->E1_TIPO $ MVRECANT
		RETURN .F.
	Endif

	If SE1->E1_TIPO $ MV_CRNEG
		RETURN .F.
	Endif

	If SE1->E1_TIPO $ MVABATIM
		RETURN .F.
	Endif

	If SE1->E1_SALDO = 0
		RETURN .F.
	EndIf

	If Existblock("FA060TRF")
		If !(Execblock("FA060TRF",.F.,.F.))		// Permite travar um titulo
			RETURN .F.							// para nao ser transferido
		Endif
	Endif

	//--------------------------------------------------------------
	//Caso titulos originados pelo SIGALOJA estejam nas carteiras:
	// I = Carteira Caixa Loja
	// J = Carteira Caixa Geral
	// Nao permitir esta operacao, pois ele precisa ser transferido
	// antes pelas rotinas do SIGALOJA.
	//---------------------------------------------------------------
	If Upper(AllTrim(SE1->E1_SITUACA)) $ "I|J" .AND. Upper(AllTrim(SE1->E1_ORIGEM)) $ "LOJA010|LOJA701|FATA701"
		RETURN .F.
	Endif

	//---------------------------------------------------------------
	//Verifico se o codigo da situacao de cobranca está cadastrado
	//---------------------------------------------------------------
	//If ( FN022SITCB(SE1->E1_SITUACA)[1] .Or. lIsCarteira .Or. SE1->E1_SITUACA == cSituacao ) .And.;
	//( (lIsCarteira .And. Empty(cPort060)) .Or. (!lIsCarteira .And. !Empty(cPort060)))
	//	RETURN .F.
	//
	//Elseif mv_par03 == 1
	//	RETURN .F.
	//
	//ElseIf !Empty(cPort060) .And. cPort060 != SE1->E1_PORTADO .and. (GetNewPar("MV_TRFBCO","2") == "2" .or. FN022SITCB(SE1->E1_SITUACA)[3]) 	// se Permite TRF entre bancos
	//	RETURN .F.
	//Endif

	//Verifico se a situação de cobrança é descontada
	If FN022SITCB(cSituacao)[2] .and. SE1->E1_TIPO $ MVABATIM
		RETURN .F.
	Endif

	//---------------------------------------------
	// Não executar o estorno de cobran‡a descontada -> carteira
	//---------------------------------------------
	//IF FN022SITCB(cSituAnt)[2] .And. cSituacao != cSituant
	IF FN022SITCB(cSituAnt)[3] .And. cSituacao != cSituant
		IF ((mv_par03 == 1 .And. FN022SITCB(cSituacao)[1] ) .Or. mv_par03 == 2) .and. GetMv("MV_ESTDESC") == "S"
			RETURN .F.
		ENDIF
	ENDIF
		
	If	FN022SITCB(cSituacao)[3] .or. ;	//Transferência p/ descontada
		FN022SITCB(SE1->E1_SITUACA)[3] 	//Transferencia de descontada p/ carteira

		nAbatim := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",SE1->E1_MOEDA,dDataBase,SE1->E1_CLIENTE,SE1->E1_LOJA,,,SE1->E1_TIPO)
		If mv_par08 == 1 //Abatimentos
			nValor -= nAbatim
		Endif
		If mv_par09 == 1 //Acrescimos e Decrescimos
			nDescont := SE1->E1_SDDECRES
			nJuros	 := SE1->E1_SDACRESC
			nValor	 += SE1->E1_SDACRESC - SE1->E1_SDDECRES
		Endif
	Endif

RETURN .T.


//-----------------------------------------------------------------------
/*/{Protheus.doc} AltPorRM()

Habilita ou não a alteração dos campos:
Portador, Agência, Conta, Contrato, Nr Portador

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		11/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION AltPorRM()
	LOCAL lEnabled 	:= .T.
	LOCAL lRMClass	:= GetMV("MV_RMCLASS")

	//-----------------------------------------------------------------------
	// Validação RMClassis x Protheus (Mensagem Única)
	//-----------------------------------------------------------------------
	If lRMClass .And. SE1->E1_IDLAN != 0
		lEnabled := .F.
	EndIf

RETURN lEnabled
//-----------------------------------------------------------------------
/*{Protheus.doc} SELTIT
@Seleciona os titulos a serem transferidos
@param		
@return		Nenhum
@author 	Zema
@since 		05/05/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------            
Static Function SelTit
Local oDlgTit
Private	oOk 	:= LoadBitmap(GetResources(),"LBOK")
Private	oNo 	:= LoadBitmap(GetResources(),"LBNO")
Private	oMainLst, aMainLst := {}
Private aRet	:= {}
Private lTodos	:= .F.   
                     
                                                                
Define MsDialog oDlgTit Title "Titulos a Traferir" From 000,000 to 550,1210 COLORS 0, 16777215 PIXEL
@002,005 Button "Cancelar " Size 40,12 PIXEL OF oDlgTit action	(oDlgTit:end())
@002,055 Button "Confirmar" Size 40,12 PIXEL OF oDlgTit action	(SetList(aMainLst), oDlgTit:end())
@002,105 Button "Marcar/Demarcar Todos" Size 80,12 PIXEL OF oDlgTit action	(SetMark(aMainLst), oMainLst:Refresh())
@020,005 ListBox oMainLst Fields Header "","Contrato","Prefixo","Numero","Parcela","Tipo","Natureza","Cliente","Nome","Dt. Emissão","Vencimento", "Valor Titulo", "Carteira" PIXEL Size 600,250 of oDlgTit ;
		on dblClick(aMainLst[oMainLst:nAt,1] := !aMainLst[oMainLst:nAt,1], oMainLst:Refresh())
Processa({ || LoadMain()},"Selecionando titulos")
		
Activate MsDialog oDlgTit Centered

RETURN(aRet)                                                                         
//-----------------------------------------------------------------------
/*{Protheus.doc} LoadMain
@Carrega as titulos para seleção
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		05/05/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------                                             
Static Function LoadMain()              
Local aInner := {}
aMainLst := {}	    
	              
TRB->(DBGOTOP())
WHILE TRB->(!EOF())
	SE1->(DbGoTo( TRB->REGSE1 ))
	aInner := {}                
	AADD(aInner,.T.)  // No inicio seleciona todos os eventos
	AADD(aInner,SE1->E1_XCONTRA)
	AADD(aInner,SE1->E1_PREFIXO)
	AADD(aInner,SE1->E1_NUM)
	AADD(aInner,SE1->E1_PARCELA)
	AADD(aInner,SE1->E1_TIPO)
	AADD(aInner,SE1->E1_NATUREZ)	
	AADD(aInner,SE1->E1_CLIENTE)
	AADD(aInner,SE1->E1_NOMCLI)	
	AADD(aInner,SE1->E1_EMISSAO)	
	AADD(aInner,SE1->E1_VENCREA)
	AADD(aInner,TRANSFORM(SE1->E1_SALDO,"@E 99,999,999,999.99"))	
	AADD(aInner,SE1->E1_SITUACA)	
	AADD(aInner,TRB->REGSE1)				
	AADD(aMainLst,aInner)
	TRB->(DBSKIP())
END                 

oMainLst:SetArray(aMainLst)	                           
	
if Len(aMainLst) >= 1
	oMainLst:nAt := 1
		
	oMainLst:bLine := {||{iif(aMainLst[oMainLst:nAt,1],oOk,oNo),;
			aMainLst[oMainLst:nAt,2],aMainLst[oMainLst:nAt,3],aMainLst[oMainLst:nAt,4],aMainLst[oMainLst:nAt,5],aMainLst[oMainLst:nAt,6],aMainLst[oMainLst:nAt,7],aMainLst[oMainLst:nAt,8],aMainLst[oMainLst:nAt,9],aMainLst[oMainLst:nAt,10],aMainLst[oMainLst:nAt,11],aMainLst[oMainLst:nAt,12],aMainLst[oMainLst:nAt,13]}}
else    
	oMainLst:bLine := {||{oNo,;
		"","","","","","","","","","","",""}}
	ApMsgInfo("Nenhum Titulo encontrado!")
endif                                                        
oMainLst:Refresh()
Return
//-----------------------------------------------------------------------
/*{Protheus.doc} SetList
@Seleção dos Titulos marcados
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		05/05/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------                                                                                                          
Static Function SetList
Local nX   := 1
FOR nX := 1 TO LEN(aMainLst)
	IF aMainLst[nX,1]
		AADD(aRet,aMainLst[nX,14])
	ENDIF	
NEXT
Return
//-----------------------------------------------------------------------
/*{Protheus.doc} SetMark
@Marca ou dermarca todos
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		05/05/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------                                                                                                          
Static Function SetMark
Local nX   := 1  
FOR nX := 1 TO LEN(aMainLst)
	IF lTodos
		aMainLst[nX,1] := .T.
	ELSE                     
		aMainLst[nX,1] := .F.	
	ENDIF	
NEXT        

IF lTodos
	lTodos := .F.
ELSE
	lTodos := .T.
ENDIF

Return