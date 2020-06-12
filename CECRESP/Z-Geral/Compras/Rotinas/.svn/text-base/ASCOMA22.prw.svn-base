#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

#DEFINE VALMERC	1	// Valor total do mercadoria 
#DEFINE VALDESP	4	// Valor total da despesa
#DEFINE SEGURO	7	// Valor total do seguro

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCOMA22()
		
CONTRATO TOP:
- Se contrato TOP, deve ser informado o projeto e tarefa
- Retorna array com os projetos do PC

Chamado pelas rotinas ASCOMA010 (MT120OK - validação do PC) e ASCOMA15 
(análise da cotação), quanto é contrato TOP (C7_XEHCT == '1')

@param		lInclui		= 	É inclusão
			lAltera		= 	É alteração
			lAnCotacao	= 	PC foi gerado por análise de cotação
			cFilPed		=	Filial do pedido (se gerado por análise da cotação)
			cPedido		=	Númedo do PC de compras (se gerado por análise da cotação)
			aProjeto	= 	Passado como REFERÊNCIA, para ser populado conforme:
			 				{FILIAL, PROJET, CONTR, QUANTAJ7, nQUANTITC7, nTOTALITC7, nTOTAJ7}
			aTarefa		=	Passado como referência, para ser populado conforme:
			 				{FILIAL, PROJET, TAREFA, QUANTAJ7, nQUANTITC7, nTOTALITC7, nTOTAJ7}			
@return		lRet		=	.T. = Informado Contrato e projeto, .F. = Não informado 
@author 	Fabio Cazarini
@since 		25/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASCOMA22(lInclui, lAltera, lAnCotacao, cFilPed, cPedido, aProjeto, aTarefa )
	LOCAL aArea			:= GetArea()
	LOCAL aAreaSC7		:= SC7->( GetArea() )
	LOCAL aAreaAFG		:= AFG->( GetArea() )
	LOCAL aAreaAJ7		:= AJ7->( GetArea() )
	LOCAL lRet			:= .T.
	LOCAL aPCCols		:= {}
	LOCAL aPCHeader		:= {}
	LOCAL aPCRatAJ7		:= {}
	LOCAL nPOSITEM 		:= 0
	LOCAL nPOSQUANT		:= 0 
	LOCAL nPOSTOTAL		:= 0
	LOCAL nPOSVALIPI	:= 0
	LOCAL nPOSVLDESC	:= 0
	LOCAL nY			:= 0
	LOCAL nX			:= 0
	LOCAL nZ			:= 0
	LOCAL nW			:= 0
	LOCAL cITEMPC		:= ""
	LOCAL nQUANT		:= 0
	LOCAL nTOTAL		:= 0
	LOCAL nVALIPI		:= 0
	LOCAL nVLDESC		:= 0
	LOCAL nSEGURO		:= 0
	LOCAL nDESPESA		:= 0
	LOCAL cNUMSC 		:= ""
	LOCAL cITEMSC		:= ""
	LOCAL nTOTAJ7		:= 0
	LOCAL nPosPROJET 	:= 0
	LOCAL nPosTAREFA	:= 0
	LOCAL nPOSITAJ7 	:= 0
	LOCAL aPCHeaAJ7		:= {}
	LOCAL nPOSPRAJ7 	:= 0  
	LOCAL nPOSCOAJ7 	:= 0
	LOCAL nPOSTAAJ7		:= 0  
	LOCAL nPOSQUAJ7 	:= 0
	LOCAL cAJ7PROJ		:= ""
	LOCAL cAJ7CONT		:= ""
	LOCAL nAJ7QUAN		:= 0
	LOCAL aTempCols		:= {}
	LOCAL nPOSSOL		:= 0
	LOCAL nPOSITS		:= 0
	LOCAL lTemAFG 		:= .F.
	LOCAL nTOTMERC		:= 0
	LOCAL nTOTSEGU		:= 0
	LOCAL nTOTDESP		:= 0
	LOCAL cFILPROJ		:= cEMPANT + cFILANT
	
	//-----------------------------------------------------------------------
	// Projeto = Cria o aheader da tabela AJ7
	//-----------------------------------------------------------------------
	aPCHeaAJ7		:= aFilHAj7() 

	//-----------------------------------------------------------------------
	// Se originado por análise de cotação, monta:
	// 	PC = aPCHeader, aPCCols (falso)
	// 	Projeto = aPCRatAJ7
	//-----------------------------------------------------------------------
	IF lAnCotacao
		//-----------------------------------------------------------------------
		// 	PC = aPCHeader
		//-----------------------------------------------------------------------
		AADD(aPCHeader,{"","C7_ITEM"} )
		AADD(aPCHeader,{"","C7_QUANT"} )
		AADD(aPCHeader,{"","C7_TOTAL"} )
		AADD(aPCHeader,{"","C7_VALIPI"} )
		AADD(aPCHeader,{"","C7_VLDESC"} )
		AADD(aPCHeader,{"","C7_NUMSC"} )
		AADD(aPCHeader,{"","C7_ITEMSC"} )
		
		//-----------------------------------------------------------------------
		// 	PC = aPCCols
		//-----------------------------------------------------------------------
		SC7->( DbSetOrder(1) )
		SC7->( MsSeek(cFilPed + cPedido) )
		DO WHILE !EOF() .AND. ;
		(SC7->C7_FILIAL + SC7->C7_NUM == cFilPed + cPedido)

			nTOTMERC	+= SC7->C7_TOTAL
			nTOTSEGU	+= SC7->C7_SEGURO
			nTOTDESP	+= SC7->C7_DESPESA

			Aadd(aPCCols,Array(Len(aPCHeader)+1))
	
			aPCCols[Len(aPCCols)][01] := SC7->C7_ITEM
			aPCCols[Len(aPCCols)][02] := SC7->C7_QUANT
			aPCCols[Len(aPCCols)][03] := SC7->C7_TOTAL
			aPCCols[Len(aPCCols)][04] := SC7->C7_VALIPI 
			aPCCols[Len(aPCCols)][05] := SC7->C7_VLDESC 
			aPCCols[Len(aPCCols)][06] := SC7->C7_NUMSC 
			aPCCols[Len(aPCCols)][07] := SC7->C7_ITEMSC 
	
			aPCCols[Len(aPCCols)][Len(aPCHeader)+1] := .F.

			//-----------------------------------------------------------------------
			// 	Projeto = Cria o acols da tabela AJ7 (do item do PC)
			//-----------------------------------------------------------------------
			dbSelectArea("AJ7")
			dbSetOrder(2)
			IF MsSeek(xFilial("AJ7")+SC7->C7_NUM+SC7->C7_ITEM)
				aTempCols := {}
				DO WHILE !AJ7->( EOF() ) .AND. xFilial("AJ7")+SC7->(C7_NUM+C7_ITEM) == AJ7->(AJ7_FILIAL+AJ7_NUMPC+AJ7_ITEMPC)
					IF AJ7->AJ7_REVISA==PmsAF8Ver(AJ7->AJ7_PROJET)
						aADD(aTempCols,Array(Len(aPCHeaAJ7)+1))
						FOR nZ := 1 to Len(aPCHeaAJ7)
							IF ( aPCHeaAJ7[nZ][10] != "V")
								aTempCols[Len(aTempCols)][nZ] := FieldGet(FieldPos(aPCHeaAJ7[nZ][2]))
							ELSE
								aTempCols[Len(aTempCols)][nZ] := CriaVar(aPCHeaAJ7[nZ][2])
							ENDIF
							aTempCols[Len(aTempCols)][Len(aPCHeaAJ7)+1] := .F.
						NEXT nZ
					ENDIF
					AJ7->( dbSkip() )
				ENDDO
				aAdd(aPCRatAJ7,{SC7->C7_ITEM,aClone(aTempCols)})
			ENDIF

			DbSelectArea("SC7")
			DbSkip()
		ENDDO
	ELSE
		aPCCols 	:= aClone( aCols )
		aPCHeader	:= aClone( aHeader )

		//-----------------------------------------------------------------------
		// Se alteração e a array de projetos não foi populada (usuário não 
		// acessou a tela de projeto)
		//-----------------------------------------------------------------------
		IF (lAltera .AND. LEN(aRatAJ7) = 0)
			FOR nW := 1 TO LEN(aCols)
				IF !GDDELETED(nW, aHeader, aCols) // se o item não está deletado
					cITEMPC 	:= GDFIELDGET( "C7_ITEM", nW, .F., aHeader, aCols )
					
					//-----------------------------------------------------------------------
					// 	Projeto = Cria o acols da tabela AJ7 (do item do PC)
					//-----------------------------------------------------------------------
					dbSelectArea("AJ7")
					dbSetOrder(2)
					IF MsSeek(xFilial("AJ7")+cPedido+cITEMPC) 
						aTempCols := {}
						DO WHILE !AJ7->( EOF() ) .AND. xFilial("AJ7")+cPedido+cITEMPC == AJ7->(AJ7_FILIAL+AJ7_NUMPC+AJ7_ITEMPC)
							IF AJ7->AJ7_REVISA==PmsAF8Ver(AJ7->AJ7_PROJET)
								aADD(aTempCols,Array(Len(aPCHeaAJ7)+1))
								FOR nZ := 1 to Len(aPCHeaAJ7)
									IF ( aPCHeaAJ7[nZ][10] != "V")
										aTempCols[Len(aTempCols)][nZ] := FieldGet(FieldPos(aPCHeaAJ7[nZ][2]))
									ELSE
										aTempCols[Len(aTempCols)][nZ] := CriaVar(aPCHeaAJ7[nZ][2])
									ENDIF
									aTempCols[Len(aTempCols)][Len(aPCHeaAJ7)+1] := .F.
								NEXT nZ
							ENDIF
							AJ7->( dbSkip() )
						ENDDO
						aAdd(aPCRatAJ7,{cITEMPC,aClone(aTempCols)})
					ENDIF
				ENDIF
			NEXT nW
		ELSE 
			aPCRatAJ7	:= aClone( aRatAJ7 )
		ENDIF	
	ENDIF

	nPOSITEM 		:= ASCAN(aPCHeader, {|x| ALLTRIM(x[2]) == "C7_ITEM"})
	nPOSQUANT		:= ASCAN(aPCHeader, {|x| ALLTRIM(x[2]) == "C7_QUANT"}) 
	nPOSTOTAL		:= ASCAN(aPCHeader, {|x| ALLTRIM(x[2]) == "C7_TOTAL"})
	nPOSVALIPI		:= ASCAN(aPCHeader, {|x| ALLTRIM(x[2]) == "C7_VALIPI"})
	nPOSVLDESC		:= ASCAN(aPCHeader, {|x| ALLTRIM(x[2]) == "C7_VLDESC"})
	nPOSSOL			:= ASCAN(aPCHeader, {|x| ALLTRIM(x[2]) == "C7_NUMSC"}) 
	nPOSITS			:= ASCAN(aPCHeader, {|x| ALLTRIM(x[2]) == "C7_ITEMSC"})

	aProjeto		:= {}
	aTarefa			:= {}

	FOR nY := 1 TO LEN(aPCCols) // para cada item
		IF !aPCCols[nY,LEN(aPCHeader)+1] // se o item nao estiver deletado
			cITEMPC		:= aPCCols[nY][nPOSITEM]
			nQUANT		:= aPCCols[nY][nPOSQUANT]
			nTOTAL		:= aPCCols[nY][nPOSTOTAL]
			nVALIPI		:= aPCCols[nY][nPOSVALIPI]

			nVLDESC		:= aPCCols[nY][nPOSVLDESC]
			IF lAnCotacao
				nSEGURO		:= NOROUND(nTOTAL / nTOTMERC * nTOTSEGU, TAMSX3("C7_SEGURO")[2])
				nDESPESA	:= NOROUND(nTOTAL / nTOTMERC * nTOTDESP, TAMSX3("C7_DESPESA")[2])
			ELSE
				nSEGURO		:= NOROUND(nTOTAL / aVALORES[VALMERC] * aVALORES[SEGURO], TAMSX3("C7_SEGURO")[2])
				nDESPESA	:= NOROUND(nTOTAL / aVALORES[VALMERC] * aVALORES[VALDESP], TAMSX3("C7_DESPESA")[2])
			ENDIF	

			cNUMSC 		:= ""
			cITEMSC		:= ""
			IF nPOSSOL > 0 .AND. nPOSITS > 0
				cNUMSC 	:= aPCCols[nY, nPOSSOL]
				cITEMSC	:= aPCCols[nY, nPOSITS]
			ENDIF

			lTemAFG := .F.
			IF !EMPTY(cNUMSC) .AND. !EMPTY(cITEMSC)
				DbSelectArea("AFG")
				DbSetOrder(2) // AFG_FILIAL+AFG_NUMSC+AFG_ITEMSC+AFG_PROJET+AFG_REVISA+AFG_TAREFA
				IF MsSeek(xFilial("AFG")+cNUMSC+cITEMSC)
					lTemAFG := .T. // Projeto foi lançado na SC
					
					//-----------------------------------------------------------------------
					// Adiciona na array com projetos - para validar o valor disponivel para 
					// contrato TOP
					//-----------------------------------------------------------------------
					DO WHILE !AFG->( EOF() ) .AND. AFG->(AFG_FILIAL+AFG_NUMSC+AFG_ITEMSC) == xFilial("AFG")+cNUMSC+cITEMSC
						nTOTAJ7 	:= (nTOTAL + nVALIPI - nVLDESC + nSEGURO + nDESPESA) / nQUANT * AFG->AFG_QUANT

						//-----------------------------------------------------------------------
						// Adiciona na array para validar o projeto e contrato por PC
						//-----------------------------------------------------------------------
						IF !EMPTY(AFG->AFG_XCONTR) 
							nPosPROJET := aSCAN( aProjeto, {|x| x[01]+x[02]+x[03] == cFILPROJ+AFG->AFG_PROJET+AFG->AFG_XCONTR })
							IF nPosPROJET == 0
								AADD( aProjeto, {cFILPROJ, AFG->AFG_PROJET, AFG->AFG_XCONTR, AFG->AFG_QUANT, nQUANT, nTOTAL, nTOTAJ7} )
							ELSE
								aProjeto[nPosPROJET][4] += AFG->AFG_QUANT
								aProjeto[nPosPROJET][5] += nQUANT
								aProjeto[nPosPROJET][6] += nTOTAL
								aProjeto[nPosPROJET][7] += nTOTAJ7
							ENDIF	
						ENDIF
						
						//-----------------------------------------------------------------------
						// Adiciona na array para validar o saldo do projeto e tarefa
						//-----------------------------------------------------------------------
						nPosTAREFA := aSCAN( aTarefa, {|x| x[01]+x[02]+x[03] == cFILPROJ+AFG->AFG_PROJET+AFG->AFG_TAREFA })
						IF nPosTAREFA == 0
							AADD( aTarefa, {cFILPROJ, AFG->AFG_PROJET, AFG->AFG_TAREFA, AFG->AFG_QUANT, nQUANT, nTOTAL, nTOTAJ7} )
						ELSE
							aTarefa[nPosTAREFA][4] += AFG->AFG_QUANT
							aTarefa[nPosTAREFA][5] += nQUANT
							aTarefa[nPosTAREFA][6] += nTOTAL
							aTarefa[nPosTAREFA][7] += nTOTAJ7
						ENDIF	

						AFG->( DbSkip() )
					ENDDO
				ENDIF
			ENDIF
			
			IF !lTemAFG // Se o projeto não foi lançado na SC
				nPOSITAJ7 := ASCAN(aPCRatAJ7,{|x|AllTrim(x[1])==cITEMPC}) // localiza o projeto do item do PC 
				IF  nPOSITAJ7 == 0
					//Help('',1,'Inconsistência - ' + PROCNAME(),,"O item " + cITEMPC + " do pedido de compras não tem projeto (AJ7) vinculado",4,1)
					//lRet := .F.
					//EXIT
				ELSE
					nPOSPRAJ7 	:= ASCAN(aPCHeaAJ7, {|x| ALLTRIM(x[2]) == "AJ7_PROJET"})
					nPOSCOAJ7 	:= ASCAN(aPCHeaAJ7, {|x| ALLTRIM(x[2]) == "AJ7_XCONTR"})
					nPOSTAAJ7	:= ASCAN(aPCHeaAJ7, {|x| ALLTRIM(x[2]) == "AJ7_TAREFA"})
					nPOSQUAJ7 	:= ASCAN(aPCHeaAJ7, {|x| ALLTRIM(x[2]) == "AJ7_QUANT"})

					//-----------------------------------------------------------------------
					// Adiciona na array com projetos - para validar o valor disponivel para 
					// contrato TOP
					//-----------------------------------------------------------------------																					
					IF nPOSPRAJ7 > 0 .AND. nPOSCOAJ7 > 0 .AND. nPOSQUAJ7 > 0 .AND. nPOSTAAJ7 > 0
						cAJ7PROJ	:= ""
						cAJ7CONT	:= ""
						nAJ7QUAN	:= 0
						FOR nX := 1 TO LEN(aPCRatAJ7[nPOSITAJ7][2])
							IF !aPCRatAJ7[nPOSITAJ7][2][nX][ LEN( aPCRatAJ7[nPOSITAJ7][2][nX] ) ] // se o item nao estiver deletado
								cAJ7PROJ	:= aPCRatAJ7[nPOSITAJ7][2][nX][nPOSPRAJ7]
								cAJ7CONT	:= aPCRatAJ7[nPOSITAJ7][2][nX][nPOSCOAJ7]
								cAJ7TARE	:= aPCRatAJ7[nPOSITAJ7][2][nX][nPOSTAAJ7]
								nAJ7QUAN	:= aPCRatAJ7[nPOSITAJ7][2][nX][nPOSQUAJ7]
								IF nQUANT * nAJ7QUAN > 0
									nTOTAJ7 	:= (nTOTAL + nVALIPI - nVLDESC + nSEGURO + nDESPESA) / nQUANT * nAJ7QUAN
								ELSE
									nTOTAJ7 	:= 0								
								ENDIF	

								//-----------------------------------------------------------------------
								// Adiciona na array para validar o projeto e contrato por PC 
								//-----------------------------------------------------------------------
								IF !EMPTY(cAJ7CONT)
									nPosPROJET := aSCAN( aProjeto, {|x| x[01]+x[02]+x[03] == cFILPROJ+cAJ7PROJ+cAJ7CONT })
									IF nPosPROJET == 0
										AADD( aProjeto, {cFILPROJ, cAJ7PROJ, cAJ7CONT, nAJ7QUAN, nQUANT, nTOTAL, nTOTAJ7} )
									ELSE
										aProjeto[nPosPROJET][4] += nAJ7QUAN
										aProjeto[nPosPROJET][5] += nQUANT
										aProjeto[nPosPROJET][6] += nTOTAL
										aProjeto[nPosPROJET][7] += nTOTAJ7
									ENDIF	
								ENDIF

								//-----------------------------------------------------------------------
								// Adiciona na array para validar o saldo do projeto e tarefa
								//-----------------------------------------------------------------------
								nPosTAREFA := aSCAN( aTarefa, {|x| x[01]+x[02]+x[03] == cFILPROJ+cAJ7PROJ+cAJ7TARE })
								IF nPosTAREFA == 0
									AADD( aTarefa, {cFILPROJ, cAJ7PROJ, cAJ7TARE, nAJ7QUAN, nQUANT, nTOTAL, nTOTAJ7} )
								ELSE
									aTarefa[nPosTAREFA][4] += nAJ7QUAN
									aTarefa[nPosTAREFA][5] += nQUANT
									aTarefa[nPosTAREFA][6] += nTOTAL
									aTarefa[nPosTAREFA][7] += nTOTAJ7
								ENDIF	
							ENDIF
						NEXT nX
					ENDIF
				ENDIF
			ENDIF
		ENDIF
	NEXT nY			

	AJ7->( RestArea(aAreaAJ7) )
	AFG->( RestArea(aAreaAFG) )
	SC7->( RestArea(aAreaSC7) )
	RestArea(aArea)

RETURN lRet


//-----------------------------------------------------------------------
/*/{Protheus.doc} aFilHAj7()

Cria o aheader da tabela AJ7

@param		Nenhum 
@return		Array = Header da tabela AJ7
@author 	Fabio Cazarini
@since 		25/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION aFilHAj7()
LOCAL aArea		:= GetArea()
LOCAL aAreaSX3 	:= SX3->( GetArea() )
LOCAL aPCHeaAJ7	:= {}

//-----------------------------------------------------------------------
// Montagem do aHeader
//-----------------------------------------------------------------------
dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("AJ7")
While !EOF() .And. (x3_arquivo == "AJ7")
	IF X3USO(x3_usado) .AND. cNivel >= x3_nivel
		AADD(aPCHeaAJ7,{ TRIM(x3titulo()), x3_campo, x3_picture,;
			x3_tamanho, x3_decimal, x3_valid,;
			x3_usado, x3_tipo, x3_arquivo,x3_context } )
	Endif
	dbSkip()
EndDo

SX3->( RestArea(aAreaSX3) )
RestArea(aArea)

RETURN aPCHeaAJ7