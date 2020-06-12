#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCOMA38()

Tela para alterar o contrato do pedido de compras na AFG

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		01/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASCOMA38()
	LOCAL oFont1 		:= TFont():New("MS Sans Serif",,028,,.F.,,,,,.F.,.F.)
	LOCAL oButton1
	LOCAL oNewDialog
	LOCAL aButtons 		:= {}
	LOCAL cNUMSC		:= ""
	LOCAL cITEMSC		:= ""
	LOCAL nX			:= 0
	LOCAL lRet			:= .F.
	
	PRIVATE cCadastro  	:= "Projeto vs Contrato"
	PRIVATE cCONTR		:= AFG->AFG_XCONTR 

	//-----------------------------------------------------------------------
	// Dialog: Contrato 
	//-----------------------------------------------------------------------
	oNewDialog := TDialog():New(000,000,150,400,OemToAnsi(cCadastro),,,,,,,,oMainWnd,.T.)

	//-----------------------------------------------------------------------
	// Cabeçalho do PC
	//-----------------------------------------------------------------------
	SX3->( dbSetOrder(2) )
	SX3->( MsSeek("C7_XEHCT") )

	@ 40,08 SAY RetTitle("AFG_XCONTR") OF oNewDialog PIXEL SIZE 80,10 // Num. contrato
	@ 40,70 MSGET cCONTR WHEN _cEHCT=="1" PICTURE PESQPICT("AFG","AFG_XCONTR") PIXEL SIZE 60,06 OF oNewDialog PIXEL

	//Aadd( aButtons, {"Projeto", {|| InfProjet()}, "Projeto...", "Projeto" , {|| .T.}} ) 

	oNewDialog:bInit := {|| EnchoiceBar(oNewDialog, ;
							{||lRet := .T., oNewDialog:End() },;	// Ok
							{||lRet := .F., oNewDialog:End() },;	// Cancela
							,,aButtons,,,.F.,.F.,.T.,.T.,.F.)}
	oNewDialog:lCentered := .T.
	oNewDialog:Activate()

	IF lRet
		//-----------------------------------------------------------------------
		// Grava o número do contrato
		//-----------------------------------------------------------------------
		AFG->(DBCOMMIT())
		FOR nX := 1 TO LEN(aCols)
			IF !GdDeleted(nX, aHeader, aCols)
				cNUMSC	:= GDFieldGet( "C7_NUMSC", nX, .F., aHeader, aCols )
				cITEMSC	:= GDFieldGet( "C7_ITEMSC", nX, .F., aHeader, aCols )
				
				IF !EMPTY(cNUMSC) .AND. !EMPTY(cITEMSC)	
					cQuery := "UPDATE " + RetSqlname("AFG") + " "
					cQuery += "SET 	AFG_XCONTR = '" + cCONTR + "' "
					cQuery += "WHERE 	AFG_FILIAL = '" + xFILIAL("AFG") + "' "
					cQuery += "		AND AFG_NUMSC = '" + cNUMSC + "' "
					cQuery += "		AND AFG_ITEMSC = '" + cITEMSC + "' "
					cQuery += "		AND D_E_L_E_T_ = ' ' "
						
					TcSqlExec(cQuery)
				ENDIF
			ENDIF
		NEXT nX
		AFG->(MsGoto(RecNo()))
	ENDIF

RETURN 