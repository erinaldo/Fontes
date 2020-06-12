#include 'protheus.ch'

static saveParcelas

/*/{Protheus.doc} MT103COR
Ponto de entrada para alterar as legendas padroes

@author Rafael Ricardo Vieceli
@since 25/04/2018
@version 1.0
@return array, novas legendas

@type function
/*/
user function MT103COR()

	Local aCores    := ParamIXB[1]
	Local aCoresUsr := {}

	//se a pr� inspe��o n�o estiver habilitada, retorna o array que recebeu
	IF ! /*MADERO_MQIE100*/ u_MDRPreInsp()
		return aCores
	EndIF

	//adiciona as legendas novas
	aAdd( aCoresUsr, { 'Empty(F1_STATUS) .And. F1_PIPSTAT == "B"','QADIMG16'})
	aAdd( aCoresUsr, { 'Empty(F1_STATUS) .And. F1_PIPSTAT == "L"','QIEIMG16'})

	//adiciona as legendas padr�es
	aEval(aCores, {|cor| aAdd(aCoresUsr, cor) })

//e retorno
return aCoresUsr


/*/{Protheus.doc} MT103LEG
Ponto de entrada para alterar as legendas padroes (view)

@author Rafael Ricardo Vieceli
@since 25/04/2018
@version 1.0
@return array, novas legendas

@type function
/*/
user function MT103LEG()

	Local aLegenda    := ParamIXB[1]

	//se a pr� inspe��o n�o estiver habilitada, retorna o array que recebeu
	IF ! /*MADERO_MQIE100*/ u_MDRPreInsp()
		return aLegenda
	EndIF

	//adiciona as legendas novas
	aAdd( aLegenda, { 'QADIMG16', 'Bloqueada para Pr� Inspe��o de Entrada'})
	aAdd( aLegenda, { 'QIEIMG16', 'Liberado na Pr� Inspe��o para Classifica��o'})
	//armimg16

//e retorno
return aLegenda


/*/{Protheus.doc} MT103PN
Fun��o para valida��o na classifica��o da prenota para:
 1. N�o permitir classificar prenota bloqueadas para pr� inspe��o

@author Rafael Ricardo Vieceli
@since 25/04/2018
@version 1.0
@return logical, se permete classificar

@type function
/*/
user function MT103PN()

	Local lContinua := .T.

	//pre inspe��o ativa
	IF /*MADERO_MQIE100*/ u_MDRPreInsp()
		//se for classifica��o e estiver bloqueado
		IF l103Class .And. SF1->F1_PIPSTAT == "B"
			lContinua := .F.
			Help("",1,"MADERO_PE_MT103PN",,"N�o � possivel classificar a prenota, pois ela encontra-se em pr�-inspe��o.",4,1)
		EndIF
	EndIF

return lContinua


/*/{Protheus.doc} MT103EXC
Valida��o do estorno da classifica��o

@author Rafael Ricardo Vieceli
@since 16/05/2018
@version 1.0
@return logical, verifica se existe preinspe��o

@type function
/*/
user function MT103EXC()

	//pre inspe��o ativa
	IF /*MADERO_MQIE100*/ u_MDRPreInsp()

		IF ! IsInCallStack("A140EstCla")

			ZI1->( dbSetOrder(1) )
			ZI1->( dbSeek( xFilial("ZI1") + SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) ) )

			IF ZI1->( Found() )
				Help("",1,"MADERO_PE_MT103EXC",,"N�o � possivel excluir a Nota Fiscal de Entrada pois h� uma pr� inspe��o. Exclua a inspe��o e tente novamente.",4,1)
				return .F.
			EndIF

		EndIF

	EndIF

return .T.


/*/{Protheus.doc} SF1100I
Ponto de de entrada ap�s a grava��o do cabe�alho da nota

@author Rafael Ricardo Vieceli
@since 14/06/2018
@version 1.0

@type function
/*/
user function SF1100I()

	//fun��o para avaliar as divergencias da preinspe��o
	/*MADERO_MQIE100*/ u_QIE100Analize()

return


/*/{Protheus.doc} SF1100E
Ponto de entrada ap�s a exclus�o do cabe�alho da nota

@author Rafael Ricardo Vieceli
@since 14/06/2018
@version 1.0

@type function
/*/
user function SF1100E()

	//fun��o para estorno das divergencias da preinspe��o
	/*MADERO_MQIE100*/ u_QIE100Estorna()


	//dias minimos
	IF u_MDRAvDcAtive() .And. AliasInDic("Z35")
		//exclui parcelamento na exclus�o e no estorno da classifica��o
		excluiParcelas()
	EndIF

return


/*/{Protheus.doc} MTA103OK
Ponto de entrada na valida��o da linha da pre nota

@author Rafael Ricardo Vieceli
@since 28/06/2018
@version 1.0
@return logical, se valida a linha

@type function
/*/
user function MTA103OK()

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
			GDFieldGET("D1_QUANT")+SC7->C7_QUJE+SC7->C7_QTDACLA - getLastQuant()  ,; //Quantidade
			SC7->C7_QUANT ,; //Quantidade Original
			nVlrItem ,; //Valor
			xMoeda(SC7->C7_PRECO,SC7->C7_MOEDA,,dDEmissao,TamSX3("C7_PRECO")[2], SC7->C7_TXMOEDA,) ,; //Valor Original
			.T. ) //Help

	EndIF

return lContinua


/*/{Protheus.doc} getLastQuant
Fun��o para pegar quantidade salva antes da altera��o

@author Rafael Ricardo Vieceli
@since 28/06/2018
@version 1.0
@return numeric, quantidade salva anteriormente

@type function
/*/
static function getLastQuant()

	IF l103Class .And. GDFieldGET('D1_REC_WT') > 0
		SD1->( DBGoTo( GDFieldGET('D1_REC_WT') ) )
		return SD1->D1_QUANT
	EndIF

return 0


/*/{Protheus.doc} MT100TOK
Na valida��o da nota, para avisar ao usuario que o documento ser� bloqueado

@author Rafael Ricardo Vieceli
@since 18/09/2018
@version 1.0
@return logical, valida��o da nota

@type function
/*/
user function MT100TOK()

	Local lContinua := ParamIXB[1]

	IF UPPER(SF4->F4_DUPLIC) == "S"
		IF lContinua
			IF u_MDRAvDcAtive()
				IF valType(saveParcelas) == "A" .And. avaliaParcelas()
					IF avaliaVencimento()
						IF Empty(SF1->F1_STATUS) .And. l103Class
							lContinua := Aviso('Bloqueio','Documento de entrada ser� bloqueado, pois cont�m parcelas com n�mero m�nimo de dias para vencimento abaixo do tolerado, caso j� tenha sido liberado, o parcelamento est� diferente do original.',{'Continua','Voltar'},2,,1) == 1
						Else
							lContinua := Aviso('Bloqueio','Documento de entrada ser� bloqueado, pois cont�m parcelas com n�mero m�nimo de dias para vencimento abaixo do tolerado.',{'Continua','Voltar'},2,,1) == 1
						EndIF
					EndIF
				EndIF
			EndIF
		EndIF
	Else
		Return .T.
	EndIf

return lContinua



/*/{Protheus.doc} MTCOLSE2
Na manuten��o das parcelas, para salvar o parcelamento, pois n�o esta acessivel na grava��o

@author Rafael Ricardo Vieceli
@since 18/09/2018
@version 1.0

@type function
/*/
user function MTCOLSE2()

	IF u_MDRAvDcAtive()
		saveParcelas := aClone(ParamIXB[1])
	EndIF

return



/*/{Protheus.doc} A103BLOQ
Fun��o que verifica se o documento ser� bloqueado

@author Rafael Ricardo Vieceli
@since 18/09/2018
@version 1.0
@return logical, bloquear documento

@type function
/*/
user function A103BLOQ()

	Local lBloqueio := ParamIXB[1]

	IF u_MDRAvDcAtive()

		IF valType(saveParcelas) == "A" .And. avaliaParcelas()
			IF avaliaVencimento()
				lBloqueio := .T.
			EndIF
		EndIF

	EndIF

return lBloqueio


/*/{Protheus.doc} MT103APV
Fun��o durante a grava��o do cabe�alho (SF1 - depois do reclock, antes do unlock) para salvar as parcelas
 e selecionar o grupo de aprova��o (se chama se for bloqueado)

@author Rafael Ricardo Vieceli
@since 18/09/2018
@version 1.0
@return character, grupo de aprova��o

@type function
/*/
user function MT103APV

	Local cGrupo

	IF u_MDRAvDcAtive()

		//salva as parcelas para compara��o futura e WF
		incluiParcelas()

		//se encontrar um grupo conforme o usuario
		IF ! empty(cGrupo := MYGetAprov( retCodUsr()))
			//retorna o grupo
			//Alert(cGrupo)
			return cGrupo
		EndIF
		//caso contrario, retorna o grupo padr�o
		return SuperGetMv("MV_NFAPROV")
	EndIF

return


Static function MyGetAprov(cUsuario)

	Local cAlias  := getNextAlias()
	Local aGrupos := FWSFUsrGrps(cUsuario)
	Local cGrupos := ''
	Local nGrp

	Local cAprov := ''
		
	For nGrp := 1 to len(aGrupos)
		IF ! empty(cGrupos)
			cGrupos += "','"
		EndIF
		cGrupos += aGrupos[nGrp]
	Next nGrp

	BeginSQL Alias cAlias
		%noparser%

		select
			SAL.AL_COD,
			sum(case when Z34_USUAR <> ' ' then 1 else 0 end) as RKG

		from %table:SAL% SAL

			inner join %table:Z34% Z34
			on  Z34.Z34_FILIAL = %xFilial:Z34%
			and Z34.Z34_GRUPO = SAL.AL_COD
			and ( Z34.Z34_USUAR = %Exp: cUsuario % or Z34.Z34_GRPUSU <> ' ' and Z34.Z34_GRPUSU in ( %Exp: cGrupos % ) )
			and Z34.D_E_L_E_T_ = ' '

		where
			SAL.AL_FILIAL = %xFilial:SAL%
		//and SAL.AL_MSBLQL <> '1' // Solicitar ao Rafael para validar se o campo existe para utilizar.
		and AL_DOCNF='T'

		and SAL.D_E_L_E_T_ = ' '

		group by AL_COD

		order by RKG desc

	EndSQL
	//memowrite("C:\TEMP\QUERY"+cValtochar(seconds())+".sql",GetLastQuery()[2])
	IF ! (cAlias)->( Eof() )
		cAprov := (cAlias)->AL_COD
	EndIF

	//fecha o alias
	(cAlias)->( dbCloseArea() )

return cAprov


/*/{Protheus.doc} avaliaParcelas
Fun��o para avaliar se caso tenha sido liberado, verificar se o parcelamento � igual ao parcelamento aprovado

@author Rafael Ricardo Vieceli
@since 18/09/2018
@version 1.0
@return logical, se avaliar� novamente

@type function
/*/
static function avaliaParcelas()

	Local aVerified := {}
	Local nParcela

	Local nSaved := 0

	IF ! l103Class
		return .T.
	EndIF

	IF SF1->F1_STATUS == "B"
		return .T.
	EndIF

	Z35->( dbSetOrder(1) )
	Z35->( dbSeek( SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) ) )

	While ! Z35->( Eof() ) .And. Z35->(Z35_FILIAL+Z35_DOC+Z35_SERIE+Z35_FORNEC+Z35_LOJA) == SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)
		//percore o array de parcelas
		For nParcela := 1 to len(saveParcelas)
			//verifica se o numero da parcela e a data de vencimeto s�o iguais
			IF alltrim(saveParcelas[nParcela][1]) == alltrim(Z35->Z35_PARCEL) .And. saveParcelas[nParcela][2] == Z35->Z35_VENCTO
				IF aScan(aVerified, Z35->Z35_PARCEL) == 0
					aAdd(aVerified, Z35->Z35_PARCEL )
				EndIF
			EndIF
		Next nParcela

		//conta quantas parcelas foram salvar anteriormente
		nSaved ++

		//proximo
		Z35->(dbSkip())
	EndDO

	//quantidade de parcelas diferentes
	IF len(saveParcelas) != nSaved
		return .T.
	EndIF

	//avalia se as parcelas s�o iguais
	IF len(aVerified) != len(saveParcelas)
		return .T.
	EndIF

return .F.


/*/{Protheus.doc} avaliaVencimento
Fun��o que avalia as parcelas buscando dias minimos toleravel

@author Rafael Ricardo Vieceli
@since 18/09/2018
@version 1.0
@return logical, verdadeiro se bloquear�

@type function
/*/
static function avaliaVencimento()

	Local nParcela

	//percorre as parcelas
	For nParcela := 1 to len(saveParcelas)
		IF SuperGetMV("MV_XDMVCT",,0) > (saveParcelas[nParcela][2] - date())
			return .T.
		EndIF
	Next nParcela

return .F.


/*/{Protheus.doc} incluiParcelas
Fun��o para incluir parcelas em tabelas customizada, para usar no WF e na classifica��o para comparar que o parcelamento ser� igual ao aprovado

@author Rafael Ricardo Vieceli
@since 18/09/2018
@version 1.0

@type function
/*/
static function incluiParcelas()

	Local nParcela

	IF l103Class
		//exclui antes de incluir novo parcelamento
		excluiParcelas()
	EndIF

	For nParcela := 1 to len(saveParcelas)
		Reclock("Z35",.T.)
		Z35->Z35_FILIAL := SF1->F1_FILIAL
		Z35->Z35_DOC    := SF1->F1_DOC
		Z35->Z35_SERIE  := SF1->F1_SERIE
		Z35->Z35_FORNEC := SF1->F1_FORNECE
		Z35->Z35_LOJA   := SF1->F1_LOJA
		Z35->Z35_PARCEL := saveParcelas[nParcela][1]
		Z35->Z35_VENCTO := saveParcelas[nParcela][2]
		Z35->Z35_VALOR  := saveParcelas[nParcela][3]
		Z35->( MsUnlock() )
	Next nParcela

	saveParcelas := nil

return


/*/{Protheus.doc} excluiParcelas
Exclui as parcelas, na exclus�o e na inclus�o

@author Rafael Ricardo Vieceli
@since 18/09/2018
@version 1.0

@type function
/*/
static function excluiParcelas()

	Z35->( dbSetOrder(1) )
	Z35->( dbSeek( SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) ) )

	While ! Z35->( Eof() ) .And. Z35->(Z35_FILIAL+Z35_DOC+Z35_SERIE+Z35_FORNEC+Z35_LOJA) == SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)
		//exclui o registros
		Reclock("Z35",.F.)
		Z35->( dbDelete() )
		Z35->( MsUnlock() )
		//proximo
		Z35->(dbSkip())
	EndDo

return


/*/{Protheus.doc} MA103OPC
Ponto de entrada para adicionar itens no menu do documento de entrada

@author Paulo Gabriel Fran�a e Silva
@since 31/10/2018
@version 1.0
@return array, itens adiconados

@type function
/*/
User Function MA103OPC()
Local aRet := {}
	aAdd(aRet,{'Importar', 'u_IMPORT10', 0, 3, 0, Nil})	
Return aRet



/*
+------------------+---------------------------------------------------------+
!Nome              ! MT103IPC                                                !
+------------------+---------------------------------------------------------+
!Descricao         ! PE para atualizar o aCols da rotina MATA103 no momento  !
!                  ! da sele��o do Pedido de compra                          !
+------------------+---------------------------------------------------------+
!Autor             ! Alexandre Contim                                        !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 10/12/2018                                              !
+------------------+---------------------------------------------------------+
*/
User Function MT103IPC()
Local nItem       := PARAMIXB[1]
Local nPosXDESCP  := aScan(aHeader,{ |x| ALLTRIM(x[2]) == "D1_XDESCP"})

	aCols[nItem,nPosXDESCP] := SC7->C7_DESCRI 

Return Nil
