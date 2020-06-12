#include 'protheus.ch'


/*/{Protheus.doc} MA651GRV
Ponto de entrada para definir LOTE para a OP no momento da efetivação da ordem de produção

@author Rafael Ricardo Vieceli
@since 15/04/2018
@version 1.0

@type function
/*/
user function MA651GRV()
Local aArea:={}

	// -> Verifica se é industria (não pode ser executada para as unidades de negócio)
	If !U_IsBusiness()

		// -> posiciona no produto
		SB1->( dbSetOrder(1) )
		SB1->( dbSeek( xFilial("SB1") + SC2->C2_PRODUTO ) )

		// -> se o produto controla LOTE
		IF Rastro(SB1->B1_COD)
			Reclock("SC2",.F.)
			SC2->C2_XLOTE  := NextLote(SB1->B1_COD,"L")
			SC2->C2_XDTFIR := SC2->C2_DATPRI
			IF SB1->B1_PRVALID > 0
				SC2->C2_XDTVAL := (SC2->C2_DATPRI + SB1->B1_PRVALID)
			EndIF
			SC2->( MsUnlock() )
		EndIF
	EndIf

	RestArea(aArea)

return



/*/{Protheus.doc} MDRNextLote
	Função para gerar numeração de lote por produto

	1. Cadastrar formula com conteudo do campo M4_FORMULA = u_MDRNextLote()
	2. Cadastrar no produto a formula para geração do Lote (campo B1_FORMLOT = M4_CODIGO)
	3. Caso deseja deixar como padrão a geração de lote por produto pode informar a formula no parametro MV_FORMLOT (X6_CONTEUD = M4_CODIGO)

@author Rafael Ricardo Vieceli
@since 15/04/2018
@version 1.0
@return character, proximo lote do produto

@type function
/*/
user function MDRNextLote()
Local cKey
Local cNextLote
Local aArea  := GetArea()
Local lIndust:= !U_IsBusiness() // -> Verifica se é industria (não pode ser executada para as unidades de negócio)

	//tabela para controle de lote por produto
	IF aliasInDic("ZDL") .and. lIndust

		//produto esta posicionado
		//monta a chave baseado no produto e filial, repetir o lote só se for digitado manualmente
		cKey :=  "MADERO_NEXT_LOTE_" + alltrim( xFilial("ZDL") ) + "_" + alltrim(SB1->B1_COD)

		//para não gerar o mesmo numero para dois apontamentos que acontecem exatamente ao mesmo tempo
		While ! lockByName(cKey,.T.,.F.,.T.) ; sleep(100) ; EndDO

		ZDL->( dbSetOrder(1) )
		ZDL->( dbSeek( xFilial("ZDL") + SB1->B1_COD ) )

		IF ! ZDL->( Found() )
			Reclock("ZDL",.T.)
			ZDL->ZDL_FILIAL := xFilial("ZDL")
			ZDL->ZDL_PRODUT := SB1->B1_COD
			ZDL->ZDL_NXTLOT := StrZero(1,min(10,TamSX3("ZDL_NXTLOT")[1]))
			ZDL->( MsUnlock() )
		EndIF

		cNextLote := alltrim(ZDL->ZDL_NXTLOT)

		Reclock("ZDL",.F.)
		ZDL->ZDL_NXTLOT := soma1(cNextLote)
		ZDL->( MsUnlock() )

		//libera para nova chamada
		unlockByName(cKey,.T.,.F.,.T.)
	EndIF

	RestArea(aArea)

return cNextLote


user function mdrFilter()

return "@B1_COD IN ( SELECT DISTINCT G1_COD FROM "+retSqlName("SG1")+" WHERE G1_FILIAL = '" + xFilial("SG1")+ "' AND D_E_L_E_T_ = ' ' )"
return "@EXISTS ( SELECT 1 FROM "+retSqlName("SG1")+" WHERE G1_FILIAL = '" + xFilial("SG1")+ "' AND G1_COD = B1_COD AND D_E_L_E_T_ = ' ' )"