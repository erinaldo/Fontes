#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCOMA21()
Inclusão de documento de entrada
Busca o CONTRATO para cada item do projeto 
Chamado pelo PE MT103PN

@param		Nenhum  
@return		lRet(logico) .T. executar a inclusão, .F. não executar.
@author 	Fabio Cazarini
@since 		24/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASCOMA21()
	LOCAL aAreaAFN	:= AFN->( GetArea() )
	LOCAL lRet		:= .T.
	LOCAL cPROJET	:= "" 
	LOCAL cREVISA	:= ""
	LOCAL cTAREFA	:= ""
	LOCAL cDOC		:= ""
	LOCAL cSERIE	:= ""
	LOCAL cFORNEC	:= ""
	LOCAL cLOJA		:= ""
	LOCAL cITEM		:= ""
	LOCAL aHdrAFN 	:= FilHdrAFN()
	LOCAL nPosPROJ	:= ASCAN(aHdrAFN,{|x|AllTrim(x[2])=="AFN_PROJET"})
	LOCAL nPosREVI	:= ASCAN(aHdrAFN,{|x|AllTrim(x[2])=="AFN_REVISA"})
	LOCAL nPosTARE	:= ASCAN(aHdrAFN,{|x|AllTrim(x[2])=="AFN_TAREFA"})
	LOCAL nPosCONT	:= ASCAN(aHdrAFN,{|x|AllTrim(x[2])=="AFN_CONTRA"})
	LOCAL nX		:= 0
	LOCAL nY		:= 0

	//-----------------------------------------------------------------------
	// Se for na classificacao do documento de entrada
	//-----------------------------------------------------------------------
	IF l103Class 
		cDOC	:= SF1->F1_DOC
		cSERIE	:= SF1->F1_SERIE
		cFORNEC	:= SF1->F1_FORNECE
		cLOJA	:= SF1->F1_LOJA

		//-----------------------------------------------------------------------
		// Se tem rateio por projeto
		//-----------------------------------------------------------------------
		IF LEN(aRatAFN) > 0 
			FOR nY := 1 TO LEN(aRatAFN)
				//-----------------------------------------------------------------------
				// Se o item tem rateio por projeto
				//-----------------------------------------------------------------------
				IF LEN(aRatAFN[nY]) > 0
					cITEM	:= aRatAFN[nY][01]

					FOR nX := 1 TO LEN(aRatAFN[nY][02])
						cPROJET	:= aRatAFN[nY][02][nX][nPosPROJ]
						cREVISA	:= aRatAFN[nY][02][nX][nPosREVI]
						cTAREFA	:= aRatAFN[nY][02][nX][nPosTARE]

						DbSelectArea("AFN")
						DbSetOrder(1) // AFN_FILIAL+AFN_PROJET+AFN_REVISA+AFN_TAREFA+AFN_DOC+AFN_SERIE+AFN_FORNEC+AFN_LOJA+AFN_ITEM
						IF MsSeek(xFILIAL("AFN") + cPROJET + cREVISA + cTAREFA + cDOC + cSERIE + cFORNEC + cLOJA + cITEM)
							aRatAFN[nY][02][nX][nPosCONT] := AFN->AFN_CONTRA
						ENDIF
					NEXT nX
				ENDIF
			NEXT nY
		ENDIF
	ENDIF

	AFN->( RestArea(aAreaAFN) )

RETURN lRet