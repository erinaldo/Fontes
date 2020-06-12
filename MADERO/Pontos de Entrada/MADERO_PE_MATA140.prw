#include 'protheus.ch'

static lPreInsp


/*/{Protheus.doc} MT140COR
Ponto de entrada para alterar as legendas padroes

@author Rafael Ricardo Vieceli
@since 25/04/2018
@version 1.0
@return array, novas legendas

@type function
/*/
user function MT140COR()

	Local aCores    := ParamIXB[1]
	Local aCoresUsr := {}

	//se a pré inspeção não estiver habilitada, retorna o array que recebeu
	IF ! /*MADERO_MQIE100*/ u_MDRPreInsp()
		return aCores
	EndIF

	//adiciona as legendas novas
	aAdd( aCoresUsr, { 'Empty(F1_STATUS) .And. F1_PIPSTAT == "B"','QADIMG16'})
	aAdd( aCoresUsr, { 'Empty(F1_STATUS) .And. F1_PIPSTAT == "L"','QIEIMG16'})

	//adiciona as legendas padrões
	aEval(aCores, {|cor| aAdd(aCoresUsr, cor) })

//e retorno
return aCoresUsr



/*/{Protheus.doc} SD1140I
Ponto de entrada na gravação dos itens da prenota para:
 1. verificar se o produto terá preinspeção

@author Rafael Ricardo Vieceli
@since 25/04/2018
@version 1.0

@type function
/*/
user function SD1140I()

	//pre inspeção ativa
	IF /*MADERO_MQIE100*/ u_MDRPreInsp()

		default lPreInsp := .F.

		SA5->( dbSetOrder(2) )
		SA5->( dbSeek( xFilial("SA5") + SD1->(D1_COD+D1_FORNECE) ) )

		IF SA5->( Found() )

			SB1->( dbSetOrder(1) )
			SB1->( msSeek( xFilial("SB1") + SD1->D1_COD ) )

			IF SB1->B1_TIPOCQ == "M" .And. SA5->A5_NOTA < SB1->B1_NOTAMIN
				Reclock("SD1",.F.)
				SD1->D1_PIPSTAT := "S" //inspeciona
				SD1->( MsUnlock() )
				//seta que a nota tem preInspecao
				lPreInsp := .T.
			EndIF

		EndIF

	EndIF

return


/*/{Protheus.doc} SF1140I
Ponto de entrada na gravação do cabeçalho da prenota para
 1. Se alguns item tiver preinspeção, bloquear a nota

@author Rafael Ricardo Vieceli
@since 25/04/2018
@version 1.0

@type function
/*/
user function SF1140I()

	Local lInclui := ParamIXB[1]
	Local lAltera := ParamIXB[2]

	//pre inspeção ativa
	IF /*MADERO_MQIE100*/ u_MDRPreInsp()

		default lPreInsp := .F.

		//não muda nada na alteração
		IF lInclui .And. lPreInsp
			Reclock("SF1",.F.)
			//altera para bloqueado
			SF1->F1_PIPSTAT := "B"
			SF1->( MsUnlock() )
		EndIF

		//limpa variavel para proxima nota (na mesma sessão)
		lPreInsp := nil

	EndIF

return



/*/{Protheus.doc} A140ALT
Ponto de entrada na alteração para validar preinspecao iniciada

@author Rafael Ricardo Vieceli
@since 16/05/2018
@version 1.0
@return logical, se permite alterar

@type function
/*/
user function A140ALT()

return valPreInsp('alterar')


/*/{Protheus.doc} A140EXC
Ponto de entrada na exclusão para validar preinspecao iniciada

@author Rafael Ricardo Vieceli
@since 16/05/2018
@version 1.0
@return logical, se permite excluir

@type function
/*/
user function A140EXC()

return valPreInsp('excluir')


/*/{Protheus.doc} valPreInsp
Função para validar se existe preinspecao

@author Rafael Ricardo Vieceli
@since 16/05/2018
@version 1.0
@return logical, validação
@param cLocal, characters, alteração ou exclusão
@type function
/*/
static function valPreInsp(cLocal)

	//pre inspeção ativa
	IF /*MADERO_MQIE100*/ u_MDRPreInsp()

		ZI1->( dbSetOrder(1) )
		ZI1->( dbSeek( xFilial("ZI1") + SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) ) )

		IF ZI1->( Found() )
			Help("",1,"MADERO_PE_" + upper(cLocal),,"Não é possivel "+cLocal+" a Pre Nota de Entrada pois há uma pré inspeção. Exclua a inspeção e tente novamente.",4,1)
			return .F.
		EndIF

	EndIF

return .T.



/*/{Protheus.doc} MT140LOK
Ponto de entrada na validação da linha da pre nota

@author Rafael Ricardo Vieceli
@since 28/06/2018
@version 1.0
@return logical, se valida a linha

@type function
/*/
user function MT140LOK()

	Local cPedido  := GDFieldGET("D1_PEDIDO")
	Local cItem    := GDFieldGET("D1_ITEMPC")
	Local nVlrItem := GDFieldGET("D1_VUNIT")

	Local lContinua := .T.

	IF ! Empty(cPedido + cItem)

		SC7->( dbSetOrder(1) )
		SC7->( dbSeek( xFilial("SC7") + cPedido + cItem ) )

		IF SuperGetMV("MV_DESCTOL",.F.,.F.)
			IF GDFieldGET("D1_QUANT") > 0
				nVlrItem -= ( GDFieldGET("D1_VALDESC") / GDFieldGET("D1_QUANT") )
			Else
				nVlrItem -= GDFieldGET("D1_VALDESC")
			EndIF
		EndIF

		lContinua := ! u_MDRAvalToler( ;
			SC7->C7_FORNECE ,; //Fornecedor
			SC7->C7_LOJA ,; //Loja
			GDFieldGET("D1_COD") ,; //Produto
			GDFieldGET("D1_QUANT") + SC7->C7_QUJE + SC7->C7_QTDACLA - getLastQuant() ,; //Quantidade
			SC7->C7_QUANT ,; //Quantidade Original
			nVlrItem ,; //Valor
			xMoeda(SC7->C7_PRECO,SC7->C7_MOEDA,,dDEmissao,TamSX3("C7_PRECO")[2], SC7->C7_TXMOEDA,) ,; //Valor Original
			.T. ) //Help

	EndIF

return lContinua


/*/{Protheus.doc} getLastQuant
Função para pegar quantidade salva antes da alteração

@author Rafael Ricardo Vieceli
@since 28/06/2018
@version 1.0
@return numeric, quantidade salva anteriormente

@type function
/*/
static function getLastQuant()

	IF GDFieldGET('D1_REC_WT') > 0
		SD1->( DBGoTo( GDFieldGET('D1_REC_WT') ) )
		return SD1->D1_QUANT
	EndIF

return 0


/*/{Protheus.doc} SD1140E
Ponto de entrada executado antes da deleção do cabeçalho e itens da pré-nota.

Retorna o Status do DocFis para 'Aguardando Processamento'

@author Leandro Favero
@since 19/10/2018
@version 1.0
@type function
/*/
user function SD1140E()	
	U_NFEChangeStatus(SF1->F1_ESPECIE,SF1->F1_CHVNFE,'A') //A=Aguardando ser processada
Return 