#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINC52()

Consulta específica - Bancos da filial indicada

@param		Nenhum
@return		bRet = Retorno lógico, indicando que foi selecionado o banco
@author 	Fabio Cazarini
@since 		09/08/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINC52()
	LOCAL cTexto		:= ALLTRIM(&(READVAR()))
	LOCAL bRet 			:= .F.

	PRIVATE cA6_FILIAL	:= ""
	PRIVATE cA6_COD		:= ""
	PRIVATE cA6_AGENCIA	:= ""
	PRIVATE cA6_NUMCON	:= ""

	DBSelectArea("SA6")
	bRet := FiltraSA6(cFilOri)
	If bRet
		DBSelectArea("SA6")
		DBSetOrder(1) // A6_FILIAL + A6_COD + A6_AGENCIA + A6_NUMCON 
		DBSeek(cA6_FILIAL+cA6_COD+cA6_AGENCIA+cA6_NUMCON)
	Endif

RETURN bRet


//-----------------------------------------------------------------------
/*/{Protheus.doc} FiltraSA6()

Consulta específica - Bancos da filial indicada

@param		cFilPar = Filial para seleção dos bancos
@return		bRet = Retorno lógico, indicando que foi selecionado o banco
@author 	Fabio Cazarini
@since 		09/08/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION FiltraSA6(cFilPar)

	LOCAL cQuery
	LOCAL cAliasTmp

	PRIVATE oDlgSA6
	PRIVATE bRet 		:= .F.
	PRIVATE aDadosSA6	:= {}
	PRIVATE bOpc1 		:= {|| DuploClic(oLstSA6:nAt, @aDadosSA6, @bRet)}

	cQuery := "SELECT A6_FILIAL, A6_COD, A6_AGENCIA, A6_NUMCON, A6_NOME "
	cQuery += "FROM "+RetSQLName("SA6") + " SA6 "
	cQuery += "WHERE SA6.A6_FILIAL = '" + SUBSTR(cFilDes,1,LEN(ALLTRIM(FwXFilial("SA6")))) + "' " 
	cQuery += "	AND SA6.D_E_L_E_T_=' ' "
	cQuery += "ORDER BY A6_FILIAL, A6_COD, A6_AGENCIA, A6_NUMCON "

	cQuery 		:= ChangeQuery(cQuery)
	cAliasTmp 	:= CriaTrab(Nil,.F.)
	
	dbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAliasTmp, .F., .T.)

	DBSelectArea(cAliasTmp)
	DBGoTop()     
	If Eof()
		Alert("Nenhum banco encontrado!")
		RETURN .F.
	Endif
	
	Do While !EOF()     
		AAdd( aDadosSA6, { (cAliasTmp)->A6_FILIAL, (cAliasTmp)->A6_COD, (cAliasTmp)->A6_AGENCIA, (cAliasTmp)->A6_NUMCON, (cAliasTmp)->A6_NOME} )
		DbSkip()
	Enddo
	(cAliasTmp)->( DBCloseArea() )

	//-----------------------------------------------------------------------
	// Montagem da Tela
	//-----------------------------------------------------------------------
	DEFINE MSDIALOG oDlgSA6 TITLE "Busca de bancos" FROM 0,0 TO 420, 710 OF oMainWnd PIXEL

	@ 5,5 LISTBOX oLstSA6 ;
	VAR lVarMat ;
	Fields HEADER "Filial", "Banco", "Agência", "Conta", "Nome banco" ;
	SIZE 350,180 On DblClick ( Eval(bOpc1) ) ;
	OF oDlgSA6 PIXEL 

	oLstSA6:SetArray(aDadosSA6)
	oLstSA6:bLine := { || {aDadosSA6[oLstSA6:nAt,1], aDadosSA6[oLstSA6:nAt,2], aDadosSA6[oLstSA6:nAt,3], aDadosSA6[oLstSA6:nAt,4], aDadosSA6[oLstSA6:nAt,5] } }

	@ 195, 005 BUTTON oButton1 PROMPT "OK" 	SIZE 037, 012 OF oDlgSA6 ACTION {|| Eval(bOpc1) , oDlgSA6:End()} PIXEL

	ACTIVATE MSDialog oDlgSA6 CENTERED
	
RETURN bRet


//-----------------------------------------------------------------------
/*/{Protheus.doc} DuploClic()

Retorno do listbox

@param		nPos = Posicao da coluna
			aDadosSA6 = Array com os bancos
			bRet = Retorno lógico indicando que o usuário selecionou banco
@return		Nenhum
@author 	Fabio Cazarini
@since 		09/08/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION DuploClic(nPos, aDadosSA6, bRet)
	cA6_FILIAL	:= aDadosSA6[nPos, 1]
	cA6_COD		:= aDadosSA6[nPos, 2]
	cA6_AGENCIA	:= aDadosSA6[nPos, 3]
	cA6_NUMCON	:= aDadosSA6[nPos, 4]

	cBcoDest	:= cA6_COD
	cAgenDest	:= cA6_AGENCIA
	cCtaDest	:= cA6_NUMCON

	bRet 		:= .T.

	oDlgSA6:End()
RETURN 