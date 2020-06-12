#include 'protheus.ch'


/*/{Protheus.doc} MT680VAL
Validação no apontamento de produção modelo 2 (SH6)

@author Rafael Ricardo Vieceli
@since 15/04/2018
@version 1.0
@return logical, se continua o apontamento

@type function
/*/
user function MT680VAL()

	Local lContinua := .T.

	//posiciona no produto
	SB1->( dbSetOrder(1) )
	SB1->( dbSeek( xFilial("SB1") + SC2->C2_PRODUTO ) )

	//e se a validade não estiver definida
	IF SB1->B1_PRVALID <= 0 .And. Rastro(SB1->B1_COD)
		lContinua := .F.
		Help("",1,"MADERO_PE_MT680VAL",,"Não é possivel apontar a produção, pois não foi definido Prazo de Validade (B1_PRVALID) do Lote no cadastro do produto.",4,1)
	EndIF

return lContinua

/*/{Protheus.doc} MA680TMP
//TODO Ponto de entrada para alterar o tipo de movimento
@author Mario L. B. Faria
@since 26/06/2018
@version 1.0
@return cRet, caracter, Tipo do movimento
/*/
User Function MA680TMP()

	Local cRet		:= ""

	If IsInCallStack("U_A10002") .And. lGaPrd	//lGaPrd - Informa se é Ganho de Produção pela rotina MADERO_A10002.PRW
		cRet := SuperGetMv("MD_TMPAD",.F.,"011")
	Else
		cRet := GetMV("MV_TMPAD")
	EndIf

Return cRet





