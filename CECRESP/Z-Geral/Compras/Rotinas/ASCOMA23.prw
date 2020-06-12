#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCOMA23()

CONTRATO TOP:
Valida se o valor maximo liberado no RM (TOP) tem saldo disponivel

Chamado pela rotina ASCOMA010 

@param		cPedido		=	Númedo do pedido que está sendo alterado
			lAltera		=	Se é alteração
			aTarefa 	= 	{FILIAL, PROJET, TAREFA, QUANTAJ7, nQUANTITC7, nTOTALITC7, nTOTAJ7} 
@return		Lógico		=	.T. = Tem saldo, .F. = Não tem saldo 
@author 	Fabio Cazarini
@since 		25/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASCOMA23(cPedido, lAltera, aTarefa)
	LOCAL aArea		:= GetArea()
	LOCAL lRET			:= .T.

	LOCAL cQryAJ7		:= ""
	LOCAL cQryAFG		:= ""
	LOCAL nX			:= 0
	LOCAL nY			:= 0
	LOCAL cFILPROJ		:= ""	
	LOCAL cAJ7PROJ		:= ""
	LOCAL cAJ7TARE		:= 0
	LOCAL cCODCOLIRM	:= ""
	LOCAL cCODEMPde		:= ""
	LOCAL cCODFILde		:= ""
	LOCAL nSALDO		:= 0
	LOCAL nPEDAFG		:= 0
	LOCAL nPEDAJ7		:= 0
	LOCAL nPEDTOT		:= 0
		
	LOCAL cAliasTOP 	:= GetNextAlias()

	//------------------------------------------------------------------------------
	// Consulta saldo orçado e realizado no RM (para cada projeto e tarefa)
	//------------------------------------------------------------------------------
	FOR nX := 1 TO LEN(aTarefa)
		cFILPROJ	:= ALLTRIM(aTarefa[nX][01])
		cAJ7PROJ	:= ALLTRIM(aTarefa[nX][02])
		cAJ7TARE	:= ALLTRIM(aTarefa[nX][03])
		nPEDTOT		:= aTarefa[nX][07]

		//------------------------------------------------------------------------------
		// Retorna o código da filial (aRET[1]) e o código da coligada (aRET[2]) no RM
		//------------------------------------------------------------------------------
		cCODEMPde	:= LEFT(cFILPROJ, LEN(cEMPANT) ) 
		cCODFILde	:= RIGHT(cFILPROJ, LEN(cFILANT) )
		
		cCODCOLIRM	:= U_ASCOMA34( cCODEMPde, cCODFILde )[2] // código da coligada no RM
		
		//------------------------------------------------------------------------------
		// Retorna, via WS RealizarConsultaSQL, o valor ORÇADO - REALIZADO
		//------------------------------------------------------------------------------
		nSALDO := U_ASCOMA33( cCODCOLIRM, cAJ7TARE, cAJ7PROJ )

		//------------------------------------------------------------------------------
		// PEDIDOS EM ABERTO - AFG
		//------------------------------------------------------------------------------
		cQryAFG := "SELECT  SUM((AFG.AFG_QUANT * (AFG.AFG_QUANT/SC7.C7_QUANT) - SC7.C7_QUJE * (AFG.AFG_QUANT/SC7.C7_QUANT)) * SC7.C7_PRECO) AS TOTAAFG " // quantidade proporcional - quantidade proporcional entregue
		cQryAFG += "FROM " + RETSQLNAME("AFG") + " AFG "
		cQryAFG += "INNER JOIN " + RETSQLNAME("SC7") + " SC7 ON "
		cQryAFG += "				(SC7.C7_FILIAL = AFG.AFG_FILIAL AND SC7.C7_NUMSC = AFG.AFG_NUMSC AND SC7.C7_ITEMSC = AFG.AFG_ITEMSC AND SC7.D_E_L_E_T_ = ' ') "
		cQryAFG += "WHERE AFG.AFG_FILIAL = '" + xFILIAL("AFG") + "' "
		cQryAFG += "	AND AFG.AFG_PROJET = '" + cAJ7PROJ + "' "
		cQryAFG += "	AND AFG.AFG_TAREFA = '" + cAJ7TARE + "' "
		cQryAFG += "	AND AFG.D_E_L_E_T_ = ' ' "
		cQryAFG += "	AND SC7.C7_RESIDUO = ' ' " 
		cQryAFG += "	AND SC7.C7_QUANT - SC7.C7_QUJE > 0 "
		cQryAFG += "	AND SC7.C7_QUANT > 0 "

		IF lAltera
			cQryAFG += "AND SC7.C7_NUM <> '" + cPedido + "' "
		ENDIF

		IF SELECT("TRBAFG") > 0
			TRBAFG->(dbCloseArea())
		ENDIF
		DbUseArea(.T., "TOPCONN", TcGenQry(,, cQryAFG), "TRBAFG", .F., .F.)

		nPEDAFG 	:= 0
		DO WHILE TRBAFG->( !EOF() )
			nPEDAFG 	+= TRBAFG->TOTAAFG

			TRBAFG->( dbSkip() )
		ENDDO
		TRBAFG->( dbCloseArea() )

		//------------------------------------------------------------------------------
		// PEDIDOS EM ABERTO - AJ7
		//------------------------------------------------------------------------------
		cQryAJ7 := "SELECT  SUM((AJ7.AJ7_QUANT * (AJ7.AJ7_QUANT/SC7.C7_QUANT) - SC7.C7_QUJE * (AJ7.AJ7_QUANT/SC7.C7_QUANT)) * SC7.C7_PRECO) AS TOTAJ7 " // quantidade proporcional - quantidade proporcional entregue
		cQryAJ7 += "FROM " + RETSQLNAME("AJ7") + " AJ7 "
		cQryAJ7 += "INNER JOIN " + RETSQLNAME("SC7") + " SC7 ON "
		cQryAJ7 += "				(SC7.C7_FILIAL = AJ7.AJ7_FILIAL AND SC7.C7_NUM = AJ7.AJ7_NUMPC AND SC7.C7_ITEM = AJ7.AJ7_ITEMPC AND SC7.D_E_L_E_T_ = ' ') "
		cQryAJ7 += "WHERE AJ7.AJ7_FILIAL = '" + xFILIAL("AJ7") + "' "
		cQryAJ7 += "	AND AJ7.AJ7_PROJET = '" + cAJ7PROJ + "' "
		cQryAFG += "	AND AJ7.AJ7_TAREFA = '" + cAJ7TARE + "' "
		cQryAJ7 += "	AND AJ7.D_E_L_E_T_ = ' ' "
		cQryAJ7 += "	AND SC7.C7_RESIDUO = ' ' " 
		cQryAJ7 += "	AND SC7.C7_QUANT - SC7.C7_QUJE > 0 "
		cQryAJ7 += "	AND SC7.C7_QUANT > 0 "

		IF lAltera
			cQryAJ7 += "AND SC7.C7_NUM <> '" + cPedido + "' "
		ENDIF

		IF SELECT("TRBAJ7") > 0
			TRBAJ7->(dbCloseArea())
		ENDIF
		DbUseArea(.T., "TOPCONN", TcGenQry(,, cQryAJ7), "TRBAJ7", .F., .F.)

		nPEDAJ7 	:= 0
		DO WHILE TRBAJ7->( !EOF() )
			nPEDAJ7 	+= TRBAJ7->TOTAJ7

			TRBAJ7->( dbSkip() )
		ENDDO
		TRBAJ7->( dbCloseArea() )

		//-----------------------------------------------------------------------------------
		// Projeto e tarefa tem saldo disponível
		//-----------------------------------------------------------------------------------
		//ALERT("Projeto / tarefa: " + cAJ7PROJ + " / " + cAJ7TARE )
		//ALERT("nSALDO: " + STR(nSALDO,15,2) )
		//ALERT("nPEDAFG: " + STR(nPEDAFG,15,2) )
		//ALERT("nPEDAJ7: " + STR(nPEDAJ7,15,2) )
		//ALERT("nPEDTOT: " + STR(nPEDTOT,15,2) )
								
		IF nSALDO - nPEDAFG - nPEDAJ7 - nPEDTOT < 0
			lRET := .F.
			EXIT
		ENDIF
	NEXT

	RestArea(aArea)

RETURN lRET