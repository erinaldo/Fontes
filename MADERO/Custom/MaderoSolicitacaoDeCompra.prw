#include 'protheus.ch'

user function _MDRC1PS()
return


/*/{Protheus.doc} MaderoSolicitacaoDeCompra
Classe para montar informações da solicitação de compra para montar o e-mail de alçadas

@author Rafael Ricardo Vieceli
@since 12/09/2018
@version 1.0

@type class
/*/
class MaderoSolicitacaoDeCompra from longClassName

	data cNumero
	data dEmissao

	data cSolicitante

	data nVlrProdutos

	data aItems

	data nNext

	method load(cNumero) constructor
	method Numero()
	method Emissao()
	method Solicitante()

	method ValorProdutos()

	method proximo()
	method item()
	method temMaisItens()

	method clear()

endclass


/*/{Protheus.doc} load
Carrega todas as informações da solicitação de compras

@author Rafael Ricardo Vieceli
@since 12/09/2018
@version 1.0
@param cNumero, characters, Numero da solicitação de compras
@type function
/*/
method load(cNumero) class MaderoSolicitacaoDeCompra

	Local cAlias := getNextAlias()

	::clear()

	IF ! empty(cNumero) .And. SC1->C1_NUM != cNumero
		SC1->( dbSetOrder(1) )
		SC1->( msSeek( xFilial("SC1") + cNumero ) )
	EndIF

	::cNumero  := SC1->C1_NUM
	::dEmissao := SC1->C1_EMISSAO

	//solicitante
	::cSolicitante := UsrFullName(SC1->C1_USER)

	BeginSQL Alias cAlias
		%noparser%

		select
			C1_ITEM, C1_PRODUTO, C1_DESCRI, C1_UM, C1_QUANT, C1_PRECO, C1_TOTAL, C1_CC, C1_ITEMCTA, C1_OBS, C1_VUNIT

		from %table:SC1% SC1

		where
		    SC1.C1_FILIAL  = %xFilial:SC1%
		and SC1.C1_NUM     = %Exp: self:cNumero %
		and SC1.D_E_L_E_T_ = ' '

	EndSQL

	While ! (cAlias)->( Eof() )

		::nVlrProdutos += IIF((cAlias)->C1_TOTAL > 0, (cAlias)->C1_TOTAL, (cAlias)->C1_QUANT * Iif((cAlias)->C1_VUNIT > 0,(cAlias)->C1_VUNIT,MTGetVProd((cAlias)->C1_PRODUTO)))

		aAdd( ::aItems, MaderoSolicitacaoDeCompraItem():load(cAlias) )

		(cAlias)->(dbSkip())
	EndDO

	//fecha alias
	(cAlias)->( dbCloseArea() )

return


/*/{Protheus.doc} clear
Limpa o objeto

@author Rafael Ricardo Vieceli
@since 12/09/2018
@version 1.0

@type function
/*/
method clear() class MaderoSolicitacaoDeCompra

	::cNumero := ''
	::dEmissao := stod('')
	::cSolicitante := ''
	::nVlrProdutos := 0
	::aItems       := {}

return

//retorna o numero do pedido
method Numero() class MaderoSolicitacaoDeCompra
return ::cNumero

//retorna a data de emissão
method Emissao(lString) class MaderoSolicitacaoDeCompra
default lString := .F.
return IIF(lString,FormDate(::dEmissao),::dEmissao)

//retorna o numero do solicitante
method Solicitante() class MaderoSolicitacaoDeCompra
return alltrim(::cSolicitante)

//retorna o valor total dos produtos
method ValorProdutos() class MaderoSolicitacaoDeCompra
return alltrim(transForm( ::nVlrProdutos, pesqPict('SC7','C7_TOTAL')))

//controle para percorer os itens
method proximo() class MaderoSolicitacaoDeCompra
	default ::nNext := 0
	::nNext ++
	IF (::nNext <= len(::aItems) )
		return .T.
	EndIF
	::nNext := nil
return .F.

//controle para retornar o item
method item(nItem) class MaderoSolicitacaoDeCompra
	default nItem := ::nNext
return ::aItems[nItem]

//controle para verificar se tem mais itens
method temMaisItens() class MaderoSolicitacaoDeCompra
	IF ::nNext == nil
		return .F.
	EndIF
return (::nNext + 1) <= len(::aItems)


/*/{Protheus.doc} MaderoSolicitacaoDeCompraItem
Carrega as informações do item da solicitação

@author Rafael Ricardo Vieceli
@since 12/09/2018
@version 1.0

@type class
/*/
class MaderoSolicitacaoDeCompraItem from MaderoPedidoDeCompraItem

	method load(cAlias) constructor
	method Quantidade()
	method ValorUnitario()
	method ValorTotal()

endclass


/*/{Protheus.doc} load
Correga as informação no objeto conforme o alias

@author Rafael Ricardo Vieceli
@since 12/09/2018
@version 1.0
@param cAlias, characters, Alias da consulta SQL ou tabela
@type function
/*/
method load(cAlias) class MaderoSolicitacaoDeCompraItem

	default cAlias := 'SC7'

	::cItem          := (cAlias)->C1_ITEM
	::cProduto       := (cAlias)->C1_PRODUTO
	::cDescricao     := (cAlias)->C1_DESCRI
	::cUnidadeMedida := (cAlias)->C1_UM
	::nQuantidade    := (cAlias)->C1_QUANT
	::nValorUnitario := (cAlias)->C1_PRECO
	::nValorTotal    := (cAlias)->C1_TOTAL
	::cCentroDeCusto := (cAlias)->C1_CC
	::cItemContabil  := (cAlias)->C1_ITEMCTA
	::cObservacao    := (cAlias)->C1_OBS

return

//retorna quantidade formatada conforme o campo
method Quantidade() class MaderoSolicitacaoDeCompraItem
return alltrim(transForm( ::nQuantidade, pesqPict('SC7','C7_QUANT')))

//retorna valor unitario formatado conforme o campo
method ValorUnitario() class MaderoSolicitacaoDeCompraItem
return alltrim(transForm( ::nValorUnitario, pesqPict('SC7','C7_PRECO')))

//retorna valor total formatado conforme o campo
method ValorTotal() class MaderoSolicitacaoDeCompraItem
return alltrim(transForm( ::nValorTotal, pesqPict('SC7','C7_TOTAL')))