#Include 'Protheus.ch'


/*/{Protheus.doc} APCP002
//TODO Rotina para cadastrar controle de acesso a Rotina de Apontamento
@author Mario L. B. Faria
@since 02/07/2018
@version 1.0
/*/
User Function APCP002()

	Local oBrowse := Nil

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("ZA2")
	oBrowse:SetDescription("Controle de Acesso a Produção")
	oBrowse:SetMenuDef("MADERO_APCP002")
	oBrowse:Activate()

Return

Static Function MenuDef()

	Local aRotina := {}

	aAdd(aRotina,{'Visualizar'	,'VIEWDEF.MADERO_APCP002'	,0,2,0,NIL})
	aAdd(aRotina,{'Incluir'		,'VIEWDEF.MADERO_APCP002'	,0,3,0,NIL})
	aAdd(aRotina,{'Alterar'		,'VIEWDEF.MADERO_APCP002'	,0,4,0,NIL})
	aAdd(aRotina,{'Excluir'		,'VIEWDEF.MADERO_APCP002'	,0,5,0,NIL})
	aAdd(aRotina,{'Imprimir' 	,'VIEWDEF.MADERO_APCP002'	,0,8,0,NIL})
//	aAdd(aRotina,{'Copiar'		,'VIEWDEF.MADERO_APCP002'	,0,9,0,NIL})

Return( aRotina )

//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do modelo de Dados

@author Mario L. B. Faria

@since 02/07/2018
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function ModelDef()

	Local oModel
	Local oStr1		:= FWFormStruct(1,'ZA2')

	oModel := MPFormModel():New('Acesso')
	oModel:SetDescription('Controle de Acesso')

	oStr1:AddTrigger( 'ZA2_CODUSR', 	'ZA2_NOME'	, { || .T. }, {|oModel| U_APCP02G1() } )

	oModel:addFields('MODEL_ZA2',,oStr1)
	oModel:SetPrimaryKey({ 'ZA2_FILIAL', 'ZA2_CODUSR' })
	oModel:getModel('MODEL_ZA2'):SetDescription('Acesso')

Return oModel

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição do interface

@author Mario L. B. Faria

@since 02/07/2018
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function ViewDef()

	Local oView
	Local oModel	:= ModelDef()
	Local oStr1		:= FWFormStruct(2, 'ZA2')

	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField('VIEW_ZA2' , oStr1,'MODEL_ZA2' )
	oView:CreateHorizontalBox( 'BOX_ZA2', 100)
	oView:SetOwnerView('VIEW_ZA2','BOX_ZA2')

Return oView

/*/{Protheus.doc} APCP02G1
//TODO Gatilho para nome do usuário
@author Mario L. B. Faria
@since 04/07/2018
@version 1.0
@return cRet, caracter, Nome do usuário
/*/
User Function APCP02G1()

	Local cRet	 := ""
	Local oModel := FWModelActive()

	cRet := UsrRetName(oModel:GetModel('MODEL_ZA2'):GetValue("ZA2_CODUSR"))

Return cRet


/*/{Protheus.doc} MDRSc2Filter
Função para criar o filtro de ordens de produção

@author Rafael Ricardo Vieceli
@since 07/09/2018
@version 1.0
@return character, SQL Filter

@type function
/*/
user function MDRSc2Filter()

	//@ define que é filtro SQL
	Local cSQL := "@"

	cSQL +=     "C2_TPOP  = 'F' "
	cSQL += "AND C2_DATRF = '        ' "

	//retirado da função A10001GP (MADERO_A10001.prw) e adaptado para
	cSQL += " AND EXISTS("
	cSQL += " SELECT 1 FROM " + retSqlName("ZA1")
	cSQL += " WHERE"
	cSQL +=     " ZA1_FILIAL = '" +xFilial("ZA1") + "' "
	cSQL += " AND ZA1_OP = CONCAT(CONCAT(CONCAT(C2_NUM,C2_ITEM),C2_SEQUEN),C2_ITEMGRD)"
	cSQL += " AND D_E_L_E_T_ = ' '"
    cSQL += " having SUM(CASE WHEN ZA1_TPMOV = 'R' THEN ZA1_QTDSEP ELSE -ZA1_QTDSEP END) <> 0)"

    IF ZA2->( FieldPOS('ZA2_FILTCC') ) != 0
		ZA2->( dbSetOrder(1) )
		ZA2->( msSeek( xFilial("ZA2") + RetCodUsr() ) )

		IF ZA2->( Found() ) .And. ! empty(ZA2->ZA2_FILTCC)
			cSQL += " AND " + u_MDRMakeRange( ZA2->ZA2_FILTCC, "C2_CC")
	 	EndIF
 	EndIF

return cSQL


/*/{Protheus.doc} MDRVldRange
Função para mostrar o filtro traduzido que sera aplicado

@author Rafael Ricardo Vieceli
@since 07/09/2018
@version 1.0
@return logical, verdadeiro
@param cRange, characters, range
@type function
/*/
user function MDRVldRange(cRange)

	IF ! empty(cRange)
		MSGInfo(toUser(u_MDRMakeRange(cRange,'C2_CC')))
	EndIF

return .T.


/*/{Protheus.doc} toUser
Função para traduzir para o usuario o filtro que será aplicado

@author Rafael Ricardo Vieceli
@since 07/09/2018
@version 1.0
@return character, filtro traduzido
@param cSQL, characters, Consulta SQL
@type function
/*/
static function toUser(cSQL)

	cSQL := strtran(cSQL,'(C2_CC ', 'Centro de Custo ')
	cSQL := strtran(cSQL,' BETWEEN ', ' de ')
	cSQL := strtran(cSQL,' AND ', ' ate ')
	cSQL := strtran(cSQL,' OR ', ' ou ' + CRLF)
	cSQL := strtran(cSQL,' IN (', ' esta contido em (')
	cSQL := strtran(cSQL,'))', ')')

return cSQL


/*/{Protheus.doc} MDRMakeRange
Função para criar a expressão do filtro

@author Rafael Ricardo Vieceli
@since 07/09/2018
@version 1.0
@return character, filtro
@param cRange, characters, Range
@param cField, characters, campo
@type function
/*/
user function MDRMakeRange(cRange, cField)

	Local aRange    := StrTokArr(alltrim(cRange),";")
	Local cRangeExp := ""
	Local cExpIn    := ""
	Local cExp1, cExp2
	Local ni, nAt

	Local cChar := "'"
	Local nCpoSize := TamSX3(cField)[1]

	For ni := 1 To Len(aRange)

		IF ! empty( aRange[ni] )

			aRange[ni] := alltrim(aRange[ni])

			nAt := At("-",aRange[ni])

			If nAt > 0

				cExp1 := Subs(aRange[ni],1,nAt-1)
				cExp2 := Subs(aRange[ni],nAt+1)

				cExp1 := PadR(cExp1+Space(nCpoSize),nCpoSize)
				cExp2 := PadR(cExp2+Space(nCpoSize),nCpoSize)

				IF ! empty(cRangeExp)
					cRangeExp += " OR "
				EndIF

				cRangeExp += cField + " BETWEEN " + cChar + cExp1 + cChar + " AND " + cChar + cExp2 + cChar

			Else

				IF ! empty(cExpIn)
					cExpIn += ","
				EndIF

				IF nCpoSize > 0
					cExp1 := PadR(aRange[ni]+Space(nCpoSize),nCpoSize)
				Else
					cExp1 := aRange[ni]
				EndIF

				cExpIn += cChar + cExp1 + cChar

			EndIf
		EndIf
	Next

	IF ! empty(cExpIn)

		IF ! empty(cRangeExp)
			cRangeExp += " OR "
		EndIF

		cRangeExp += cField + " IN (" + cExpIn + ")"

	EndIF

	IF ! empty(cRangeExp)
		cRangeExp := "("+cRangeExp+")
	EndIF

return cRangeExp