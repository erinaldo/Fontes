#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA37()

Mútuo de transferência bancária

Rotina para realizar transferência bancária entre filiais e contas
- Movimento bancário a pagar – débito – na filial e conta origem
- Movimento bancário a receber – crédito – na filial e conta destino

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		14/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
@Releases	05/05/17 Zema: 	- Filial de Origem - Defaut a filial atual
							- Desabilitar o campo beneficiário
							- Natureza Origem/Destino - Sugestão por Parâmetro    
							- Tipo de Movimento - Sugestão por parâmetro
							- Histórico - Sugerir "TRANSF. MÙTUO"    
							- Gerar movimentação no Banco Mutuo

						
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA37()
	LOCAL nA,cMoedaTx
	LOCAL lSpbInUse		:= SpbInUse()
	LOCAL aModalSPB		:=  {"1=TED","2=CIP","3=COMP"}
	LOCAL oModSpb
	LOCAL cModSpb 
	
	PRIVATE cBcoOrig	:= CriaVar("E5_BANCO")
	PRIVATE cBcoDest	:= CriaVar("E5_BANCO")
	PRIVATE cAgenOrig	:= CriaVar("E5_AGENCIA")
	PRIVATE cAgenDest	:= CriaVar("E5_AGENCIA")
	PRIVATE cCtaOrig	:= CriaVar("E5_CONTA")                                    
	PRIVATE cCtaDest	:= CriaVar("E5_CONTA")
	PRIVATE cNaturOri	:= CriaVar("E5_NATUREZ")
	PRIVATE cNaturDes	:= CriaVar("E5_NATUREZ")
	PRIVATE cDocTran	:= CriaVar("E5_NUMCHEQ")
	PRIVATE cHist100	:= CriaVar("E5_HISTOR")
	PRIVATE nValorTran	:= 0
	PRIVATE nOpcA		:= 0
	PRIVATE cBenef100 	:= CriaVar("E5_BENEF")
	PRIVATE cFilOri		:= cFILANT
	PRIVATE cFilDes		:= SPACE(LEN(cFILANT))
	PRIVATE cTipoTran 	:= Space(3)

	PRIVATE cFilAux		:= cFILANT
	
	PRIVATE oFilOri
	PRIVATE oFilDes
	PRIVATE oBcoOrig
	PRIVATE oBcoDest
	PRIVATE oAgenOrig
	PRIVATE oCtaOrig 
	PRIVATE aTxMoedas 	:= {}
	PRIVATE oDlg

	//-----------------------------------------------------------------------
	// A moeda 1 e tambem inclusa como um dummy, nao vai ter uso,
	// mas simplifica todas as chamadas a funcao xMoeda, ja que posso
	// passara a taxa usando a moeda como elemento do Array atxMoedas
	// Exemplo xMoeda(E1_VALOR,E1_MOEDA,1,dDataBase,,aTxMoedas[E1_MOEDA][2])
	// Bruno - Paraguay 22/08/2000
	//-----------------------------------------------------------------------
	aAdd  (aTxMoedas,{"",1,PesqPict("SM2","M2_MOEDA1")})
	For nA   := 2  To MoedFin()
		cMoedaTx := Str(nA,IIf(nA <= 9,1,2))
		If !Empty(GetMv("MV_MOEDA"+cMoedaTx))
			Aadd(aTxMoedas,{GetMv("MV_MOEDA"+cMoedaTx),RecMoeda(dDataBase,nA),PesqPict("SM2","M2_MOEDA"+cMoedaTx) })
		Else
			Exit
		Endif
	Next

	// Release 05/05/17 Zema
	// Sugerir parâmetros
	cNaturOri	:= GETNEWPAR("AS_NMUTORI",cNaturOri)
	cNaturDes	:= GETNEWPAR("AS_NMUTDES",cNaturDes)              
	cTipoTran	:= GETNEWPAR("AS_TPMOVMT",cTipoTran)              
	cHist100	:= PADR("TRANSF. MUTUO ",LEN(cHist100))

	//-----------------------------------------------------------------------
	// Dialog
	//-----------------------------------------------------------------------
	DEFINE MSDIALOG oDlg FROM  32, 113 TO 272,630 TITLE "Transferência Bancária de Mútuo" PIXEL			

	oDlg:lMaximized := .F.
	oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,20,20)
	oPanel:Align := CONTROL_ALIGN_ALLCLIENT    		   

	@ 000,004 TO 025,222 OF oPanel	PIXEL LABEL "Origem" 
	@ 027,004 TO 052,222 OF oPanel	PIXEL LABEL "Destino" 
	@ 054,004 TO 117,222 OF oPanel	PIXEL LABEL "Identificação" 

	//-----------------------------------------------------------------------
	// Primeiro quadro
	//-----------------------------------------------------------------------
	@ 005,008 SAY OemToAnsi("Filial") 		 SIZE 20, 7 OF oPanel PIXEL
	@ 005,058 SAY OemToAnsi("Banco") 		 SIZE 19, 7 OF oPanel PIXEL
	@ 005,092 SAY OemToAnsi("Agência") 		 SIZE 25, 7 OF oPanel PIXEL
	@ 005,122 SAY OemToAnsi("Conta") 		 SIZE 20, 7 OF oPanel PIXEL
	@ 005,172 SAY OemToAnsi("Natureza")		 SIZE 28, 7 OF oPanel PIXEL

	@ 013,008 MSGET oFilOri VAR cFilOri	F3 "SM0_01" SIZE 47, 08 OF oPanel PIXEL hasbutton
	@ 013,058 MSGET oBcoOrig VAR cBcoOrig F3 "SA6ESA" Picture "@S3" ; 
					Valid CarregaSa6(@cBcoOrig,@cAgenOrig,@cCtaOrig,.F.,,,@cNaturOri) 	SIZE 10, 08 OF oPanel PIXEL hasbutton
	@ 013,092 MSGET oAgenOrig VAR cAgenOrig Picture "@S5" ;
					Valid CarregaSa6(@cBcoOrig,@cAgenOrig,@cCtaOrig,.F.,,,@cNaturOri)	SIZE 20, 08 OF oPanel PIXEL
	@ 013,122 MSGET oCtaOrig VAR cCtaOrig Picture "@S10" ;
					Valid If(CarregaSa6(@cBcoOrig,@cAgenOrig,@cCtaOrig,.F.,,.T.,@cNaturOri),.T.,oBcoOrig:SetFocus()) SIZE 45, 08 OF oPanel PIXEL
	@ 013,172 MSGET cNaturOri F3 "SED" ;
					Valid ExistCpo("SED",@cNaturOri) .AND. FinVldNat( .F., cNaturOri, 3 ) SIZE 47, 08 OF oPanel PIXEL hasbutton

	//-----------------------------------------------------------------------
	// Segundo quadro
	//-----------------------------------------------------------------------
	@ 32,008 SAY OemToAnsi("Filial") 		 SIZE 20, 7 OF oPanel PIXEL
	@ 32,058 SAY OemToAnsi("Banco") 		 SIZE 23, 7 OF oPanel PIXEL
	@ 32,092 SAY OemToAnsi("Agência") 		 SIZE 27, 7 OF oPanel PIXEL
	@ 32,122 SAY OemToAnsi("Conta") 		 SIZE 18, 7 OF oPanel PIXEL
	@ 32,172 SAY OemToAnsi("Natureza")		 SIZE 28, 7 OF oPanel PIXEL

	@ 40,008 MSGET oFilDes VAR cFilDes F3 "SM0_01" Valid FILDES() SIZE 47, 08 OF oPanel PIXEL hasbutton
	@ 40,058 MSGET oBcoDest VAR cBcoDest F3 "SA6ESB" Picture "@S3" ; 
					Valid CarregaSa6(@cBcoDest,@cAgenDest,@cCtaDest,.F.,,,@cNaturDes) 	SIZE 10, 08 OF oPanel PIXEL hasbutton
	@ 40,092 MSGET cAgenDest Picture "@S5" SIZE 20, 08 OF oPanel PIXEL
	@ 40,122 MSGET cCtaDest Picture "@S10" ;
					Valid IF(( cBcoDest != cBcoOrig .or. cAgenDest != cAgenOrig .or.	cCtaDest != cCtaOrig),.T.,oBcoDest:SetFocus())	SIZE 45, 08 OF oPanel PIXEL
	@ 40,172 MSGET cNaturDes F3 "SED" ;
					Valid ExistCpo("SED",@cNaturDes)  .AND. FinVldNat( .F., cNaturDes, 3 ) SIZE 47, 08 OF oPanel PIXEL hasbutton

	//-----------------------------------------------------------------------
	//Terceiro Quadro	
	//-----------------------------------------------------------------------
	@ 059,008 SAY OemToAnsi("Tipo Mov.") SIZE 31, 7 OF oPanel PIXEL
	@ 059,042 SAY OemToAnsi("Número Doc.") SIZE 43, 7 OF oPanel PIXEL
	@ 059,099 SAY OemToAnsi("Valor") SIZE 17, 7 OF oPanel PIXEL
	@ 078,009 SAY OemToAnsi("Histórico") SIZE 28, 7 OF oPanel PIXEL
	@ 096,009 SAY OemToAnsi("Baneficiário") SIZE 40, 7 OF oPanel PIXEL

	@ 067,09 MSGET cTipoTran F3 "06" Picture "!!!" Valid (!Empty(cTipoTran) .And. ExistCpo("SX5","06"+cTipoTran)) .and. ; 
					Iif(cTipoTran="CH",fa050Cheque(cBcoOrig,cAgenOrig,cCtaOrig,cDocTran),.T.) .And. ;
					Iif(cTipoTran="CH" .or. cTipoTran="TB",fa100DocTran(cBcoOrig,cAgenOrig,cCtaOrig,cTipoTran,@cDocTran),.T.) SIZE  15, 08 OF oPanel PIXEL hasbutton
	@ 067,042 MSGET cDocTran Picture PesqPict("SE5", "E5_NUMCHEQ")	Valid !Empty(cDocTran).and.fa100doc(cBcoOrig,cAgenOrig,cCtaOrig,cDocTran) SIZE 47, 08 OF oPanel PIXEL
	@ 067,099 MSGET nValorTran PicTure PesqPict("SE5","E5_VALOR",18) Valid nValorTran > 0 .and. If(cPaisLoc=="DOM",FA100V01(nValorTran,cTipoTran),.T.)    SIZE  66, 08 OF oPanel PIXEL hasbutton
	@ 086,009 MSGET cHist100 Picture "@S22" Valid !Empty(cHist100) SIZE 155, 08 OF oPanel PIXEL

	If lSpbInUse	
		@ 104,009 MSGET cBenef100 Picture "@S21" When .F. Valid !Empty(cBenef100) SIZE 95, 08 OF oPanel PIXEL
		@ 096,108 SAY OemToAnsi("Modalidade SPB") 	 SIZE 31, 7 OF oPanel PIXEL
		@ 104,108 MSCOMBOBOX oModSPB VAR cModSpb ITEMS aModalSpb SIZE 56, 47 OF oPanel PIXEL ;
				VALID SpbTipo("SE5",cModSpb,cTipoTran,"TR") 
	Else
		@ 104,009 MSGET cBenef100 Picture "@S21" When .F. Valid !Empty(cBenef100) SIZE 155, 08 OF oPanel PIXEL
	Endif

	DEFINE SBUTTON FROM 10, 230 TYPE 1 ENABLE ACTION (If(FinOkDiaCTB(),nOpca:=1,nOpca:=0),oDLg:End()) OF oPanel
	DEFINE SBUTTON FROM 23, 230 TYPE 2 ENABLE ACTION (nOpca:=0,oDlg:End()) OF oPanel

	ACTIVATE MSDIALOG oDlg CENTERED VALID  (iif(nOpca==1 , ;
			ValidTran(cTipoTran,cBcoDest,cAgenDest,cCtaDest,cBenef100,cDocTran,nValorTran,cNaturOri,cNaturDes,cBcoOrig,cAgenOrig,cCtaOrig,cHist100,cFilOri,cFilDes).and.;
			IIF(lSpbInUse,SpbTipo("SE5",cModSpb,cTipoTran,"TR"),.T.),.T.) )

	IF nOpca == 1
		//-----------------------------------------------------------------------
		// Realiza a transferência via ExecAuto FINA100
		//-----------------------------------------------------------------------
		IF !ExecTransf()
			MSGALERT( "Transferência não efetuada", "Atenção" )
		ELSE
			MSGALERT( "Transferência efetuada com sucesso!", "Ok" )		
			
			// Release 05/05/17 Zema
			PUTMV("AS_NMUTORI",cNaturOri)
			PUTMV("AS_NMUTDES",cNaturDes)
			PUTMV("AS_TPMOVMT",cTipoTran)              			
		ENDIF
	ENDIF
	
RETURN
//-----------------------------------------------------------------------
/*/{Protheus.doc} FILDES()
Valida a filial destino
@param		
@return		lRet = .T. ou .F.
@author 	Zema
@since 		28/10/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION FILDES
Local lRet := .T.
Local nRegSM0 := SM0->(RECNO())
SM0->(DBSETORDER(1))
IF SM0->(!DBSEEK(cEmpAnt+cFilDes))
 	ApMsgAlert("Empresa/Filial não cadastrada.")
	cBenef100 := ""	
 	lRet := .F.
ELSE
	cBenef100 := SM0->M0_NOMECOM
ENDIF	
                            
oDlg:Refresh()

SM0->(DBGOTO(nRegSM0))
Return(lRet)

//-----------------------------------------------------------------------
/*/{Protheus.doc} ValidTran()

Valida os dados da transferência de mútuo

@param		cTipoTran,cBcoDest,cAgenDest,cCtaDest,cBenef100,cDocTran,
			nValorTran,cNaturOri,cNaturDes,cBcoOrig,cAgenOrig,cCtaOrig,
			cHist100,cFilOri,cFilDes
@return		lRet = .T. ou .F.
@author 	Fabio Cazarini
@since 		18/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION ValidTran(cTipoTran,cBcoDest,cAgenDest,cCtaDest,cBenef100,cDocTran,nValorTran,cNaturOri,cNaturDes,cBcoOrig,cAgenOrig,cCtaOrig,cHist100,cFilOri,cFilDes)
	LOCAL lRet 		:= .T.
	LOCAL cFILSED	:= ""
	LOCAL cFILSE5	:= ""
	LOCAL aFilAce	:= {}
	
	IF lRet
		//-----------------------------------------------------------------------
		// Função para retornar as filiais que o usuário corrente tem acesso
		//-----------------------------------------------------------------------
		aFilAce := U_ASCADA02( RetCodUsr() ) 
	ENDIF
	
	IF lRet
		IF aSCAN( aFilAce, cEmpAnt+cFilOri ) == 0
			MSGALERT( "Usuário sem permissão de acesso à filial origem " + cFilOri + " !", "Atenção" )
			lRet := .F.
		ENDIF
	ENDIF

	IF lRet
		IF aSCAN( aFilAce, cEmpAnt+cFilDes ) == 0
			MSGALERT( "Usuário sem permissão de acesso à filial destino " + cFilDes + " !", "Atenção" )
			lRet := .F.
		ENDIF
	ENDIF
	
	IF lRet
		IF EMPTY(cFilOri) .OR. EMPTY(cBcoOrig)  .OR. EMPTY(cAgenOrig)  .OR. EMPTY(cCtaOrig)  
			MSGALERT( "Informe os dados da conta origem da transferência!", "Atenção" )
			lRet := .F.
		ELSE
			IF !EMPTY(xFILIAL("SE5"))
				cFILSE5 := LEFT(cFilOri, LEN(ALLTRIM(xFILIAL("SE5"))) )
				cFILSE5 := PADR(cFILSE5, LEN(xFILIAL("SE5")) ) 
			ELSE
				cFILSE5 := xFILIAL("SE5")
			ENDIF
		
			DbSelectArea("SA6")
			DbSetOrder(1) // A6_FILIAL+A6_COD+A6_AGENCIA+A6_NUMCON
			IF !DbSEEK( cFILSE5 + cBcoOrig + cAgenOrig + cCtaOrig )
				MSGALERT( "Dados da conta origem transferência inválidos!", "Atenção" )
				lRet := .F.
			ENDIF
		ENDIF
	ENDIF

	IF lRet
		IF EMPTY(cNaturOri)
			MSGALERT( "Informe a natureza origem da transferência!", "Atenção" )
			lRet := .F.
		ELSE
			IF !EMPTY(xFILIAL("SED"))
				cFILSED := LEFT(cFilOri, LEN(ALLTRIM(xFILIAL("SED"))) )
				cFILSED := PADR(cFILSED, LEN(xFILIAL("SED")) ) 
			ELSE
				cFILSED := xFILIAL("SED")
			ENDIF

			DbSelectArea("SED")
			DbSetOrder(1) // ED_FILIAL+ED_CODIGO
			IF !DbSEEK( cFILSED + cNaturOri )
				MSGALERT( "Natureza origem da transferência inválida!", "Atenção" )
				lRet := .F.
			ENDIF
		ENDIF
	ENDIF

	IF lRet
		IF EMPTY(cFilDes) .OR. EMPTY(cBcoDest)  .OR. EMPTY(cAgenDest)  .OR. EMPTY(cCtaDest)  
			MSGALERT( "Informe os dados da conta destino da transferência!", "Atenção" )
			lRet := .F.
		ELSE
			IF !EMPTY(xFILIAL("SE5"))
				cFILSE5 := LEFT(cFilDes, LEN(ALLTRIM(xFILIAL("SE5"))) )
				cFILSE5 := PADR(cFILSE5, LEN(xFILIAL("SE5")) ) 
			ELSE
				cFILSE5 := xFILIAL("SE5")
			ENDIF
		
			DbSelectArea("SA6")
			DbSetOrder(1) // A6_FILIAL+A6_COD+A6_AGENCIA+A6_NUMCON
			IF !DbSEEK( cFILSE5 + cBcoDest + cAgenDest + cCtaDest )
				MSGALERT( "Dados da conta destino transferência inválidos!", "Atenção" )
				lRet := .F.
			ENDIF
		ENDIF
	ENDIF

	IF lRet
		IF EMPTY(cNaturDes)
			MSGALERT( "Informe a natureza destino da transferência!", "Atenção" )
			lRet := .F.
		ELSE
			IF !EMPTY(xFILIAL("SED"))
				cFILSED := LEFT(cFilDes, LEN(ALLTRIM(xFILIAL("SED"))) )
				cFILSED := PADR(cFILSED, LEN(xFILIAL("SED")) ) 
			ELSE
				cFILSED := xFILIAL("SED")
			ENDIF

			DbSelectArea("SED")
			DbSetOrder(1) // ED_FILIAL+ED_CODIGO
			IF !DbSEEK( cFILSED + cNaturDes )
				MSGALERT( "Natureza destino da transferência inválida!", "Atenção" )
				lRet := .F.
			ENDIF
		ENDIF
	ENDIF

	IF lRet
		IF cFilOri == cFilDes
			MSGALERT( "Na transferência de mútuo devem ser selecionadas filiais diferentes!", "Atenção" )
			lRet := .F.
		ENDIF
	ENDIF
	
	IF lRet
		IF EMPTY(cTipoTran)
			MSGALERT( "Informe o tipo da movimentação de transferência!", "Atenção" )
			lRet := .F.
		ENDIF
	ENDIF

	IF lRet
		IF EMPTY(cDocTran)
			MSGALERT( "Informe o número da movimentação da transferência!", "Atenção" )
			lRet := .F.
		ENDIF
	ENDIF

	IF lRet
		IF EMPTY(nValorTran)
			MSGALERT( "Informe o valor da transferência!", "Atenção" )
			lRet := .F.
		ENDIF
	ENDIF

	IF lRet
		IF EMPTY(cHist100)
			MSGALERT( "Informe o histórico da transferência!", "Atenção" )
			lRet := .F.
		ENDIF
	ENDIF

	IF lRet
		IF EMPTY(cBenef100)
			MSGALERT( "Informe o beneficiário da transferência!", "Atenção" )
			lRet := .F.
		ENDIF
	ENDIF

	//-----------------------------------------------------------------------
	// Verifica se data do movimento não pode ser menor que data limite de 
	// movimentacao no financeiro
	//-----------------------------------------------------------------------
	IF lRet 
		IF !DtMovFin()
			lRet := .F.
		ENDIF	
	ENDIF

RETURN lRet


//-----------------------------------------------------------------------
/*/{Protheus.doc} ExecTransf()

Realiza a transferência via ExecAuto FINA100

Variábeis PRIVATE:
	cBcoOrig
	cBcoDest
	cAgenOrig
	cAgenDest
	cCtaOrig                                    
	cCtaDest
	cNaturOri
	cNaturDes
	cDocTran
	cHist100
	nValorTran
	cBenef100
	cFilOri
	cFilDes
	cTipoTran

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		18/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION ExecTransf()
	LOCAL lRet 			:= .F.
	LOCAL cFilAux		:= cFilAnt
	LOCAL aFINP100		:= {}
	LOCAL aFINR100		:= {}	
	LOCAL nOpcPag		:= 3
	LOCAL nOpcRec		:= 4	
	LOCAL nOpcExc		:= 5
	LOCAL nRegSE5		:= 0

	PRIVATE lMsErroAuto := .F.
	PRIVATE cLoteMut	:= U_ASFINA56()

	//-----------------------------------------------------------------------
	// Movimento bancário na filial origem - MOV. BANCÁRIO PAGAR
	//-----------------------------------------------------------------------
	cFilAnt := cFilOri

	aFINP100 := {;
					{"E5_DATA"		, dDataBase		, NIL},;
					{"E5_DOCUMEN" 	, cDocTran		, NIL},;
					{"E5_MOEDA"		, cTipoTran		, NIL},;
					{"E5_VALOR"		, nValorTran	, NIL},;
					{"E5_NATUREZ"	, cNaturOri		, NIL},;
					{"E5_BANCO"		, cBcoOrig		, NIL},;
					{"E5_AGENCIA"	, cAgenOrig		, NIL},;
					{"E5_CONTA"		, cCtaOrig		, NIL},;
					{"E5_BENEF"		, cBenef100		, NIL},;
					{"E5_HISTOR"	, cHist100		, NIL},;                            
					{"E5_XBCOFIL"	, cFilDes		, NIL},;					
					{"E5_XLOTMUT"	, cLoteMut		, NIL};										
					}

	MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINP100,nOpcPag)

	IF lMsErroAuto
		MostraErro()
		lRet := .F.
	ELSE
		lRet 	:= .T.
		nRegSE5	:= SE5->( Recno() ) // guarda o numero de registro, se for necessária a exclusão do movimento
	ENDIF     

	//-----------------------------------------------------------------------
	// Movimento bancário na filial destino - MOV. BANCÁRIO RECEBER
	//-----------------------------------------------------------------------
	IF lRet
		cFilAnt := cFilDes

		aFINR100 := {;
						{"E5_DATA"		, dDataBase		, NIL},;
						{"E5_DOCUMEN" 	, cDocTran		, NIL},;
						{"E5_MOEDA"		, cTipoTran		, NIL},;
						{"E5_VALOR"		, nValorTran	, NIL},;
						{"E5_NATUREZ"	, cNaturDes		, NIL},;
						{"E5_BANCO"		, cBcoDest		, NIL},;
						{"E5_AGENCIA"	, cAgenDest		, NIL},;
						{"E5_CONTA"		, cCtaDest		, NIL},;
						{"E5_BENEF"		, cBenef100		, NIL},;
						{"E5_HISTOR"	, cHist100		, NIL},;
						{"E5_XBCOFIL"	, cFilOri		, NIL},;						
						{"E5_XLOTMUT"	, cLoteMut		, NIL};																
						}
	
		MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINR100,nOpcRec)
	
		IF lMsErroAuto
			MostraErro()
			lRet := .F.
			
			//-----------------------------------------------------------------------
			// Exclui movimento bancário na filial origem - MOV. BANCÁRIO PAGAR
			//-----------------------------------------------------------------------
			cFilAnt := cFilOri
			
			DbSelectArea("SE5")
			SE5->( DbGoTo( nRegSE5 ) )  // restaura a posição do numero de registro
			
			MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINP100,nOpcExc)
			
			IF lMsErroAuto
				MostraErro()
				MsgAlert("Não foi possível excluir o movimento bancário a pagar gerado na transferência. Exclua o movimento manualmente!","Atenção") // não deve ocorrer, mas como eu tenho TOC
			ENDIF
		ELSE
			lRet := .T.
		ENDIF     
	ENDIF
	
	//-----------------------------------------------------------------------
	// Retorna a filial
	//-----------------------------------------------------------------------
	cFilAnt := cFilAux                                                                                       
	
	// Atualiza movimentação do mutuo
	IF lRet
		U_ASFINA58(cFilOri,cFilDes,cLoteMut,"P#R" ) 
	ENDIF	
	

RETURN lRet