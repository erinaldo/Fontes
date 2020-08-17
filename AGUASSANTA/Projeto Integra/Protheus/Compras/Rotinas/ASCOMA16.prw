#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCOMA16()
Inclusão de documento de entrada
Busca o CONTRATO para cada item do projeto - integracao TOP
Chamado pelo PE MT103IPC

@param		nLinha	= 	Contém o número do item do aCols do Documento de
						Entrada e da Pré Nota de Entrada
			lRet	= 	O parâmetro lRet, somente é tratado na rotina Localizada. "LocxNF2".
						Em outros ambientes, este parâmetro não possui aplicação.
						.T. = Indica que a TES carregada no Acols, será mantida.
						Se não for passado TES no Acols, será substituída pela TEs do Pedido de Compras / Cadastro de Produtos.
						.F. = Indica que a TES do aCols, poderá ser substituída pela TEs do Pedido de Compras / Cadastro de Produtos. 
						(Este é o funcionamento padrão mesmo quando não existe o Ponto de Entrada)
@return		lRet
@author 	Fabio Cazarini
@since 		25/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASCOMA16(nLinha, lRet)
	LOCAL aArea		:= GetArea()
	LOCAL aAreaAFG	:= AFG->( GetArea() ) 	// tabela de projetos da solicitacao de compras
	LOCAL aAreaAJ7	:= AJ7->( GetArea() )	// tabela de projetos do pedido de compras
	LOCAL cPROJET	:= "" 
	LOCAL cREVISA	:= ""
	LOCAL cTAREFA	:= ""
	LOCAL cNUMSC	:= SC7->C7_NUMSC
	LOCAL cITEMSC	:= SC7->C7_ITEMSC
	LOCAL aHdrAFN 	:= FilHdrAFN()
	LOCAL nPosPROJ	:= ASCAN(aHdrAFN,{|x|AllTrim(x[2])=="AFN_PROJET"})
	LOCAL nPosREVI	:= ASCAN(aHdrAFN,{|x|AllTrim(x[2])=="AFN_REVISA"})
	LOCAL nPosTARE	:= ASCAN(aHdrAFN,{|x|AllTrim(x[2])=="AFN_TAREFA"})
	LOCAL nPosCONT	:= ASCAN(aHdrAFN,{|x|AllTrim(x[2])=="AFN_CONTRA"})
	LOCAL nX		:= 0
	LOCAL cD1ITEM	:= ""

	IF nLinha > 0
		cD1ITEM	:= GDFIELDGET( "D1_ITEM", nLinha, .F., aHeader, aCols )

		IF EMPTY(ALLTRIM(cD1ITEM))
			cD1ITEM := STRZERO(nLinha, TAMSX3("D1_ITEM")[01])
		ENDIF
	ENDIF	

	// Busca o CONTRATO para cada item do projeto - integracao TOP
	IF nPosPROJ > 0 .AND. nPosREVI > 0 .AND. nPosTARE > 0 .AND. nPosCONT > 0
		IF LEN(aRatAFN) > 0 .AND. LEN(aRatAFN[nLinha]) > 0
			IF aRatAFN[nLinha][01] == cD1ITEM
				FOR nX := 1 TO LEN(aRatAFN[nLinha][02])
					cPROJET	:= aRatAFN[nLinha][02][nX][nPosPROJ]
					cREVISA	:= aRatAFN[nLinha][02][nX][nPosREVI]
					cTAREFA	:= aRatAFN[nLinha][02][nX][nPosTARE]

					DbSelectArea("AJ7")
					DbSetOrder(1) // AJ7_FILIAL+AJ7_PROJET+AJ7_REVISA+AJ7_TAREFA+AJ7_NUMPC+AJ7_ITEMPC
					IF DbSEEK(xFILIAL("AJ7") + cPROJET + cREVISA + cTAREFA + SC7->C7_NUM + SC7->C7_ITEM)
						aRatAFN[nLinha][02][nX][nPosCONT] := AJ7->AJ7_XCONTR
					ELSE
						DbSelectArea("SC1")
						DbSetOrder(1) //C1_FILIAL + C1_NUM + C1_ITEM
						If DbSeek(xFilial('SC1')+cNUMSC+cITEMSC)
							DbSelectArea("AFG")
							DbSetOrder(1) // AFG_FILIAL+AFG_PROJET+AFG_REVISA+AFG_TAREFA+AFG_NUMSC+AFG_ITEMSC
							IF DbSEEK(xFILIAL("AFG") + cPROJET + cREVISA + cTAREFA + cNUMSC + cITEMSC )
								aRatAFN[nLinha][02][nX][nPosCONT] := AFG->AFG_XCONTR
							ENDIF
						ENDIF
					ENDIF
				NEXT nX
			ENDIF
		ENDIF
	ENDIF

	AJ7->( RestArea(aAreaAJ7) )
	AFG->( RestArea(aAreaAFG) )
	RestArea(aArea)

RETURN lRet