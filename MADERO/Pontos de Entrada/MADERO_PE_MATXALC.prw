#include 'protheus.ch'


/*/{Protheus.doc} MTALCALT
Ponto de entrada na criação de cada registro da SCR

@author Rafael Ricardo Vieceli
@since 22/08/2018
@version 1.0

@type function
/*/
user function MTALCALT()

	//grava chave UUID
	//também é gravado no momento antes do envio do e-mail se estiver vazio
	checkKey()

return


/*/{Protheus.doc} MTALCDOC
Ponto de entrada após manipulação da alçada (inclusao, liberação, bloqueio)

	ParamIXB -> Execblock("MTALCDOC",.F.,.F.,{aDocto,dDataRef,nOper})

	Descrição dos parâmetros recebidos pelo Ponto de Entrada:

		* PARAMIXB[1] = Informações do documento, que podem ser:

		  [1] Número do Documento
		  [2] Tipo de Documento
		  [3] Valor do Documento
		  [4] Código do Aprovador
		  [5] Código do Usuário
		  [6] Grupo do Aprovador
		  [7] Aprovador Superior
		  [8] Moeda do Documento
		  [9] Taxa da Moeda
		  [10] Data de Emissão do Documento

		* PARAMIXB[2]  = Data de Referência

		* PARAMIXB[3] = Número da Operação, que pode ser:

		1 = Inclusão de Documento
		2 = Transferência da Alçada para o Superior
		3 = Exclusão do Documento
		4 = Aprovação do Documento
		5 = Estorno da Aprovação
		6 = Bloqueio Manual

@author Rafael Ricardo Vieceli
@since 22/08/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
user function MTALCDOC()

	Local aDocto   := ParamIXB[1]
	Local dDataRef := ParamIXB[2]
	Local nOper    := ParamIXB[3]

	Local cNumeroDocumento := aDocto[1]
	Local cTipoDocumento   := aDocto[2]

	Local nSave := SCR->( recno() )

	//Inclusão de Documento OU aprovação de documento
	IF nOper == 1 .OR. nOper == 4

		SCR->( dbSetOrder(1) )
		SCR->( dbSeek( xFilial("SCR") + cTipoDocumento + cNumeroDocumento ) )

		While ! SCR->( Eof() ) .And. alltrim(SCR->(CR_FILIAL+CR_TIPO+CR_NUM)) == alltrim(xFilial("SCR") + cTipoDocumento + cNumeroDocumento)

			//se o Status for igual a 02=Pendente
			IF SCR->CR_STATUS == '02'

				//envia documento
				sendMail(cTipoDocumento)

			EndIF

			SCR->(dbSkip())
		EndDO

	EndIF

	SCR->( dbGoTo( nSave ) )

return



static function sendMail(cTipoDocumento)

	Local cHtmlMail := ''
	Local cMailTo

	//verifica se possui a chave unica para aprovação
	checkKey()

	//envio o email de Solicitação de Compras
	IF cTipoDocumento == "SC"
		SC1->( dbSetOrder(1) )
		SC1->( msSeek( xFilial("SC1") + PadR(SCR->CR_NUM, tamSX3('C1_NUM')[1]) ) )
		//monta o layout para solitação
		cHtmlMail := PurchaseRequestLayout()
	EndIF

	//envio o email de Pedido de Compras
	IF cTipoDocumento == "PC"
		SC7->( dbSetOrder(1) )
		SC7->( msSeek( xFilial("SC7") + PadR(SCR->CR_NUM, tamSX3('C7_NUM')[1]) ) )
		//monta o layout para pedido
		cHtmlMail := PurchaseOrderLayout()
	EndIF

	//envio o email de Pedido de Compras
	IF cTipoDocumento == "NF"
		SF1->( dbSetOrder(1) )
		SF1->( msSeek( xFilial("SF1") + PadR(SCR->CR_NUM, tamSX3('F1_DOC')[1] + tamSX3('F1_SERIE')[1] + tamSX3('F1_FORNECE')[1] + tamSX3('F1_LOJA')[1] ) ) )
		//monta o layout para documento
		cHtmlMail := InflowInvoiceLayout()
	EndIF

	IF ! empty(cHtmlMail)

		//pega o e-mail do usuario
		cMailTo := UsrRetMail(SCR->CR_USER)

		IF SuperGetMV('MV_SMAILAD',,.F.)
			IF ! ExistDir('\mails\MDRAlcDoc')
				FWMakeDir('\mails\MDRAlcDoc')
			EndIF
			//nome: 20180101_102547_pc000001_nivel01_user000000
			MemoWrite('\mails\MDRAlcDoc\' + DtoS(date()) + '_' + retNum(time()) + '_' + SCR->CR_TIPO + alltrim(SCR->CR_NUM) + '_nivel' + SCR->CR_NIVEL + '_user' + SCR->CR_USER + '_para-' + alltrim(cMailTo) + '.html',cHtmlMail)
		Else
			MTSendMail({cMailTo},'Liberação de Alçadas - Nivel ' + SCR->CR_NIVEL + ' - ' + tipoDoc() + ' ' + alltrim(SCR->CR_NUM), strtran(cHtmlMail,CRLF,""))
		EndIF

	EndIF

return


static function tipoDoc(cTipo)

	default cTipo := SCR->CR_TIPO

	do case
		case cTipo == "IP"
			return 'Pedido de Compras'
		case cTipo == "PC"
			return 'Pedido de Compras'
		case cTipo == "SC"
			return 'Solicitação de Compras'
		case cTipo == "NF"
			return 'Documento de entrada'
	endcase

return ''


static function PurchaseRequestLayout()

	Private oSolicitacao := MaderoSolicitacaoDeCompra():load(SC1->C1_NUM)

	IF FindFunction('l_MDRSolCom')
		return l_MDRSolCom()
	EndIF

return ''


static function PurchaseOrderLayout()

	Private oPedido := MaderoPedidoDeCompra():load(SC7->C7_NUM)

	IF FindFunction('l_MDRPedCom')
		return l_MDRPedCom()
	EndIF

return ''


static function InflowInvoiceLayout()

	Private oDocumento := MaderoDocumentoDeEntrada():load(SF1->F1_DOC, SF1->F1_SERIE, SF1->F1_FORNECE, SF1->F1_LOJA)

	IF FindFunction('l_MDRDocEnt')
		return l_MDRDocEnt()
	EndIF

return ''


/*/{Protheus.doc} checkKey
Função para verificar, e se estiver vazio, gravar o UUID em campo customizado (CR_CHVWF)

@author Rafael Ricardo Vieceli
@since 22/08/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
static function checkKey()

	//se o campo existir
	IF SCR->( FieldPOS("CR_CHVWF") ) != 0
		//e estiver vazio
		IF empty(SCR->CR_CHVWF)
			//grava o UUID
			Reclock("SCR",.F.)
			SCR->CR_CHVWF := FWUUID("ALCADA")
			SCR->( MsUnlock() )
		EndIF
	EndIF

return


user function MDRmakeUrl(cUUID, cAction)

	Local cURL := alltrim(supergetmv('MDR_URLALC',,'http://localhost:8079/'))

	//coloca o HTTP:// se não foi colocando no parametro
	IF 'http' != lower(left(cURL,4))
		cURL := 'http://'+ cURL
	EndIF

	//coloca barra no final se não foi colocado no parametro
	IF '/' != right(cURL,1)
		cURL += '/'
	EndIF

	//nome do programa de liberação
	cURL += 'u_MDRAlcDoc.apw'
	//Empresa
	cURL += '?cCompany=' + cEmpAnt
	//Filial
	//cURL += '&cBranch=' + cFilAnt
	//ID
	cURL += '&cID=' + cUUID
	//ação
	cURL += '&cAction=' + cAction

return cURL


user function MDRAvDcAtive()
return superGetMV("MV_XESPAPV",,.F.)



user function MDRGetAprov(cUsuario, cTipoDocumento)

	Local cAlias  := getNextAlias()
	Local aGrupos := FWSFUsrGrps(cUsuario)
	Local cGrupos := ''
	Local nGrp

	Local cAprov := ''
	Local cWhereType := '%1=1%'

	IF !empty(cTipoDocumento)
		do case
			case cTipoDocumento = 'SC'
				cWhereType := "%AL_DOCSC='T'%"
			case cTipoDocumento = 'PC'
				cWhereType := "%AL_DOCPC='T'%"
			case cTipoDocumento = 'NF'
				cWhereType := "%AL_DOCNF='T'%"
		endcase
	EndIF
	
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
		and %Exp: cWhereType %
		and exists (
			select 1 from %table:Z33%
			where
				Z33_FILIAL = %xFilial:Z33%
			and Z33_GRUPO  = SAL.AL_COD
			/*
			and exists (
				select 1 from %table:SAJ%
				where
				    AJ_FILIAL  = %xFilial:SAJ%
				and AJ_GRCOM   = Z34_GRPUSU // Z34_GRPCOM
				and AJ_USER    = %Exp: cUsuario %
				and D_E_L_E_T_ = '  '
			)*/
			and D_E_L_E_T_ = ' ' )

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




/*/{Protheus.doc} GRPAPEC
Ponto de entrada dentro da função MaGrpApEC (MATXALC.prw)

o conteudo da função é cópia da função MaGrpApEC adicionando filtro de usuario.


@author Rafael Ricardo Vieceli
@since 19/09/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
user function GRPAPEC()

	Local aEntCtb := ParamIXB[1]
	Local lEntCtb := ParamIXB[2]
	Local cTpDoc  := ParamIXB[3]

	Local aArea	  		:= GetArea()
	Local aApv			:= {}
	Local aApvPE		:= {}
	Local aAuxEnt		:= {}
	Local aCondEC		:= MtGetFEC("DBL", "DBL", { "DBL_CC","DBL_CONTA","DBL_ITEMCT","DBL_CLVL" })
	Local aAuxGrp		:= {}
	Local cGrupo		:= ""
	Local cItGrp		:= ""
	Local cQuery		:= ""
	Local cAls			:= GetNextAlias()
	Local cCpoDBL	 	:= ""
	Local cContDBL		:= ""
	Local cBkTpDoc	    := cTpDoc
	Local cGrpDfl		:= SuperGetMv("MV_APGRDFL",.F.,"")
	Local lAltpdoc	    := SuperGetMv("MV_ALTPDOC",.F.,.F.)
	Local lOK			:= .T.
	Local lAchou 		:= .F.
	Local nForEnt		:= 0
	Local lFilEntCtb	:= .F.
	Local aPeso		    := {'15','7','3','1'}
	Local nX

	For nX :=  Len(aPeso) To Len(aEntCtb)
		aAdd(aPeso,'1')
	Next nX

	IF len(aEntCtb) == 0
		lEntCtb := .F.
		lOK := .F.
	EndIF

	IF lAltpdoc
		Do Case
			Case cTpDoc == "AE"
				cTpDoc := 'SAL.AL_DOCAE'
			Case cTpDoc == "CO"
				cTpDoc := 'SAL.AL_DOCCO'
			Case cTpDoc == "CP"
				cTpDoc := 'SAL.AL_DOCCP'
			Case cTpDoc == "NF"
				cTpDoc := 'SAL.AL_DOCNF'
			Case cTpDoc == "PC"
				cTpDoc := 'SAL.AL_DOCPC'
			Case cTpDoc == "SA"
				cTpDoc := 'SAL.AL_DOCSA'
			Case cTpDoc == "SC"
				cTpDoc := 'SAL.AL_DOCSC'
			Case cTpDoc == "ST"
				cTpDoc := 'SAL.AL_DOCST'
			Case cTpDoc == "IP"
				cTpDoc := 'SAL.AL_DOCIP'
			Case cTpDoc $ "CT|IC"
				cTpDoc := 'SAL.AL_DOCCT'
			Case cTpDoc $ "RV|IR"
				cTpDoc := 'SAL.AL_DOCCT'
			Case cTpDoc $ "MD|IM"
				cTpDoc := 'SAL.AL_DOCMD'
			Case cTpDoc == "GA"
				cTpDoc := 'SAL.AL_DOCGA'
		End Case
	EndIF

	IF lOK
	 	cQuery := " SELECT "
		cQuery += " DBL.DBL_GRUPO AS GRPAPV, "
		cQuery += " DBL.DBL_ITEM  AS ITEMGRP "

		//-- Adiciona verificação de proximidade das entidades ctb. dinamicamente
		IF Len(aEntCtb) > 0
			cQuery += " , ( "
			For nForEnt := 1 to Len(aEntCtb)
				If nForEnt > 1
					cQuery += " + "
				EndIf
				cQuery += " CASE WHEN DBL." + aCondEC[nForEnt] + " = '" +  aEntCtb[nForEnt] + "'THEN " + aPeso[nForEnt] + " ELSE "
				cQuery += " CASE WHEN DBL." + aCondEC[nForEnt] + " = '' THEN 0 ELSE -30 END END"
			Next nForEnt
			cQuery += " ) AS MATCH "
			lFilEntCtb		:= .T.
		EndIF

		cQuery += " FROM " + RetSQLName("DBL") + " DBL "

		IF lAltpdoc
			cQuery += " INNER JOIN " + RetSQLName("SAL") + " SAL "

			cQuery += " ON SAL.AL_FILIAL = DBL.DBL_FILIAL "
			cQuery += " AND SAL.AL_COD = DBL.DBL_GRUPO "
			cQuery += " AND SAL.D_E_L_E_T_ = ' ' "
		EndIF

		cQuery += " WHERE "
		cQuery += " DBL.DBL_FILIAL = '" + FWXFilial("DBL") + "' "

		//-- Somente é necessário a verificação do Centro de Custo (Primario)
		For nForEnt := 1 to Len(aEntCtb)
			IF aCondEC[nForEnt] == 'DBL_CC'
				cQuery += " AND DBL." + aCondEC[nForEnt] + " = '" +  aEntCtb[nForEnt] + "' "
				lFilEntCtb		:= .T.
			EndIF
		Next nForEnt

		For nForEnt :=Len(aEntCtb)+1  to Len(aCondEC)
			cQuery += " AND DBL." + aCondEC[nForEnt] + " = ' ' "
		Next nForEnt

		If lAltpdoc
			cQuery += " AND " + cTpDoc + " = 'T' "
		EndIf
		cQuery += " 	AND DBL.D_E_L_E_T_ = ' ' "
		//-- Somente executa a query se tiver where de entidade contabil
		IF lFilEntCtb
			//- Para compatibilidade com Oracle não é possivel utilizar LIMIT 1.
			cQuery += " ORDER BY MATCH DESC "

			cQuery  := ChangeQuery( cQuery )

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAls,.T.,.T.)
            
			While !(cAls)->(EOF())

				varInfo('infos', {(cAls)->MATCH, cTpDoc,  (cAls)->GRPAPV })

				IF ( (cAls)->MATCH >= 15 .And. ! right(cTpDoc,2) $ "SC,IP" ) .Or. ( right(cTpDoc,2) $ "SC,IP"  .And. avaliaUsuario( (cAls)->GRPAPV ) .and. avaliaGrupo( (cAls)->GRPAPV ) )
					lAchou	:= .T.
					cGrupo 	:= (cAls)->GRPAPV
					cItGrp	:= (cAls)->ITEMGRP
					Exit
				EndIF

				(cAls)->(dbSkip())
			EndDO

			(cAls)->( dbCloseArea() )
		EndIF

	EndIF

	IF ! lAchou .And.  Empty(cGrupo) .AND. ! Empty(cGrpDfl)
		aAuxGrp := Separa(cGrpDfl,';',.F.)
		Aadd(aApv,aAuxGrp[1])
		Aadd(aApv,IIF(len(aAuxGrp)>=2,aAuxGrp[2],""))
	Else
		Aadd(aApv,cGrupo)
		Aadd(aApv,cItGrp)
	EndIF

	RestArea(aArea)

Return aApv


static function avaliaGrupo(cGrupoAprovacao)

	Z33->( dbSetOrder(1) )
	Z33->( msSeek( xFilial("Z33") + cGrupoAprovacao ) )

	//percore os grupo de compras vinculados ao grupo de aprovação
	While ! Z33->( Eof() ) .And. Z33->(Z33_FILIAL+Z33_GRUPO) == xFilial("Z33") + cGrupoAprovacao

		SAJ->( dbSetOrder(1) )
		SAJ->( msSeek( xFilial("SAJ") + Z33->Z33_GRPCOM ) )

		//depois percore os usuarios do grupo de compras
		While ! SAJ->( Eof() ) .And. SAJ->(AJ_FILIAL+AJ_GRCOM) == xFilial("SAJ") + Z33->Z33_GRPCOM
			//se encontrar usuario vinculado
			IF SAJ->AJ_USER == RetCodUsr()
				return .T.
			EndIF
			SAJ->(dbSkip())
		EndDO

		Z33->(dbSkip())
	EndDO

return .F.


static function avaliaUsuario(cGrupoAprovacao)

	//pega o codido do usuario
	Local cCodigo := RetCodUsr()

	Local aGrupos
	Local nGrupo

	//primeiro busca por grupo de aprovação + usuario
	Z34->( dbSetOrder(2) )
	Z34->( msSeek( xFilial("Z34") + cGrupoAprovacao + cCodigo ) )

	IF Z34->( Found() )
		return .T.
	EndIF

	//carrega os grupos apenas se não encontrar por usuario
	//segundo documentação da função, ele retorna o grupo priorizado na primeira posição
	aGrupos := FWSFUsrGrps(cCodigo)

	//depois busca por grupo de aprovação + grupo de usuario
	For nGrupo := 1 to len(aGrupos)
		Z34->( dbSetOrder(3) )
		Z34->( msSeek( xFilial("Z34") + aGrupos[nGrupo] ) )

		IF Z34->( Found() )
			return .T.
		EndIF
	Next nGrupo

return .F.