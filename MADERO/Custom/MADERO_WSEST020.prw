#INCLUDE 'protheus.ch'
#INCLUDE "restful.ch"

/*/{Protheus.doc} GetProdutosAConferir
//TODO Declaração do WebService GetProdutosAConferir
@author Vinicius Moreira
@since 06/08/2018
@version 1.0
/*/
WSRESTFUL GetProdutosAConferir DESCRIPTION "Madero - Produtos a Conferir"
	
	WSDATA cdempresa AS STRING
	WSDATA cdfilial AS STRING
	WSDATA cdusuario AS STRING
	WSDATA chavenfe AS STRING

	WSMETHOD GET DESCRIPTION "Acesso de Usuários" WSSYNTAX "/GetProdutosAConferir || /GetProdutosAConferir/{id}"

End WSRESTFUL

/*/{Protheus.doc} GET
//TODO Declaração do Metodo GetProdutosAConferir
@author Vinicius Moreira
@since 06/08/2018
@version 1.0
/*/
WSMETHOD GET WSRECEIVE cdempresa, cdfilial, cdusuario, chavenfe  WSSERVICE GetProdutosAConferir
Local cXml	:= ""

	::SetContentType("application/xml")
	
	cXml := U_WSEST020(Self:cdempresa, Self:cdfilial, Self:cdusuario, Self:chavenfe)
	
	::SetResponse(cXML)

Return .T.
/*/{Protheus.doc} ProtheusGetProdutosAConferir
//TODO declaração das classe para gerar o XML
@author Vinicius Moreira
@since 06/08/2018
@version 1.0
@return ${return}, ${return_description}
/*/
Class ProtheusGetProdutosAConferir From ProtheusMethodAbstract

	Method new( cMethod ) constructor
	Method makeXml( lIntegrado, cMsg, aProds )
	Method getRegs( cMsgErr )

EndClass
/*/{Protheus.doc} New
//TODO Metodo Inicializados da Classe ProtheusGetProdutosAConferir
@author Vinicius Moreira
@since 06/08/2018
@version 1.0
@return ${return}, ${return_description}
@param cMethod, caracter, descricao
/*/
Method New(cMethod) Class ProtheusGetProdutosAConferir
	::cMethod := cMethod
Return
/*/{Protheus.doc} getRegs
//TODO Metodo de busca dos dados que serão processados.
@author Vinicius Moreira
@since 17/07/2018
@version 1.0
@return aRet, Array, Array com produtos que serão enviados ao aplicativo.
@param cMsgErr, caracter, Variavel onde serão carregados os erros encontrados.
/*/
Method getRegs( cMsgErr ) Class ProtheusGetProdutosAConferir
	Local aRet 		:= { }
	Local cQuery 	:= ""
	Local cAliasQry	:= GetNextAlias( )
	
	cQuery += "  SELECT " + CRLF 
	cQuery += "    SD1.D1_FILIAL " + CRLF 
	cQuery += "   ,SD1.D1_ITEM " + CRLF 
	cQuery += "   ,SD1.D1_DOC " + CRLF 
	cQuery += "   ,SD1.D1_SERIE " + CRLF 
	cQuery += "   ,SD1.D1_FORNECE " + CRLF 
	cQuery += "   ,SD1.D1_LOJA " + CRLF 
	cQuery += "   ,SD1.D1_ITEM " + CRLF 
	cQuery += "   ,SD1.D1_COD " + CRLF
	cQuery += "   ,SB1.B1_GRUPO " + CRLF
	cQuery += "   ,SB1.B1_DESC " + CRLF
	cQuery += "   ,SB1.B1_UM " + CRLF
	cQuery += "   ,SBM.BM_DESC " + CRLF 
	cQuery += "   ,SD1.D1_QUANT " + CRLF 
	cQuery += "   ,SD1.D1_VUNIT " + CRLF 
	cQuery += "   ,SD1.D1_TOTAL " + CRLF
	cQuery += "   ,CASE WHEN SA5.A5_UNID = ' ' " + CRLF
	cQuery += "      THEN SB1.B1_UM " + CRLF
	cQuery += "      ELSE SA5.A5_UNID " + CRLF
	cQuery += "    END A5_UNID " + CRLF
	cQuery += "   ,CASE WHEN SA5.A5_XTPCUNF = ' ' " + CRLF
	cQuery += "      THEN 'M' " + CRLF
	cQuery += "      ELSE SA5.A5_XTPCUNF " + CRLF
	cQuery += "    END A5_XTPCUNF " + CRLF
	cQuery += "   ,CASE WHEN SA5.A5_XCVUNF = 0 " + CRLF
	cQuery += "      THEN 1 " + CRLF
	cQuery += "      ELSE SA5.A5_XCVUNF " + CRLF
	cQuery += "    END A5_XCVUNF " + CRLF
	cQuery += "   ,SA5.A5_CODPRF " + CRLF
	cQuery += "   ,CASE WHEN SA5.A5_CODBAR = ' ' " + CRLF
	cQuery += "      THEN SB1.B1_CODBAR " + CRLF
	cQuery += "      ELSE SA5.A5_CODBAR " + CRLF
	cQuery += "    END A5_CODBAR " + CRLF	
	cQuery += "   FROM " + RetSQLName( "SF1" ) + " SF1 " + CRLF 
	cQuery += " INNER JOIN " + RetSQLName( "SD1" ) + " SD1 ON " + CRLF 
	cQuery += "        SD1.D1_FILIAL  = SF1.F1_FILIAL " + CRLF 
	cQuery += "    AND SD1.D1_DOC     = SF1.F1_DOC " + CRLF 
	cQuery += "    AND SD1.D1_SERIE   = SF1.F1_SERIE " + CRLF 
	cQuery += "    AND SD1.D1_FORNECE = SF1.F1_FORNECE " + CRLF 
	cQuery += "    AND SD1.D1_LOJA    = SF1.F1_LOJA " + CRLF 
	cQuery += "    AND SD1.D1_TIPO    = SF1.F1_TIPO " + CRLF 
	cQuery += "    AND SD1.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " INNER JOIN " + RetSQLName( "SB1" ) + " SB1 ON " + CRLF 
	cQuery += "        SB1.B1_FILIAL  = '" + xFilial( "SB1" ) + "' " + CRLF 
	cQuery += "    AND SB1.B1_COD     = SD1.D1_COD " + CRLF 
	cQuery += "    AND SB1.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " LEFT OUTER JOIN " + RetSQLName( "SBM" ) + " SBM ON " + CRLF 
	cQuery += "        SBM.BM_FILIAL  = '" + xFilial( "SBM" ) + "' " + CRLF 
	cQuery += "    AND SBM.BM_GRUPO   = SB1.B1_GRUPO " + CRLF 
	cQuery += "    AND SBM.D_E_L_E_T_ = ' ' " + CRLF  
	cQuery += " LEFT OUTER JOIN " + RetSQLName( "SA5" ) + " SA5 ON " + CRLF 
	cQuery += "        SA5.A5_FILIAL  = '" + xFilial( "SA5" ) + "' " + CRLF 
	cQuery += "    AND SA5.A5_FORNECE = SF1.F1_FORNECE " + CRLF 
	cQuery += "    AND SA5.A5_LOJA    = SF1.F1_LOJA " + CRLF 
	cQuery += "    AND SA5.A5_PRODUTO = SD1.D1_COD " + CRLF 
	cQuery += "    AND SA5.A5_XATIVO  = 'S' " + CRLF 
	cQuery += "    AND SA5.D_E_L_E_T_ = ' ' " + CRLF 
	cQuery += "  WHERE SF1.F1_FILIAL  = '" + SF1->F1_FILIAL + "' " + CRLF 
	cQuery += "    AND SF1.F1_DOC     = '" + SF1->F1_DOC + "' " + CRLF 
	cQuery += "    AND SF1.F1_SERIE   = '" + SF1->F1_SERIE + "' " + CRLF 
	cQuery += "    AND SF1.F1_FORNECE = '" + SF1->F1_FORNECE + "' " + CRLF 
	cQuery += "    AND SF1.F1_LOJA    = '" + SF1->F1_LOJA + "' " + CRLF 
	cQuery += "    AND SF1.F1_STATUS  = ' ' " + CRLF 
	cQuery += "    AND SF1.D_E_L_E_T_ = ' '  " + CRLF 
	cQuery += "  ORDER BY " + CRLF 
	cQuery += "    SD1.D1_ITEM " + CRLF
	cQuery := ChangeQuery(cQuery)
	cAliasQry := MPSysOpenQuery(cQuery)
	If ( cAliasQry )->( !Eof( ) )
		dbSelectArea( "Z13" )
		Z13->( dbSetOrder( 1 ) )//Z13_FILIAL+Z13_COD
		While ( cAliasQry )->( !Eof( ) )
			If !Z13->( dbSeek( xFilial( "Z13" ) + ( cAliasQry )->D1_COD ) )
				cMsgErr := "Produto " + AllTrim( ( cAliasQry )->D1_COD ) + " não relacionado como código do Teknisa."
				Exit
			Else
				AAdd( aRet, {	( cAliasQry )->D1_ITEM,;		//01
								Z13->Z13_XCODEX,;				//02
								( cAliasQry )->B1_DESC,;		//03
								( cAliasQry )->B1_GRUPO,;		//04
								( cAliasQry )->BM_DESC,;		//05
								( cAliasQry )->B1_UM,;			//06
								( cAliasQry )->D1_QUANT,;		//07
								( cAliasQry )->D1_VUNIT,;		//08
								( cAliasQry )->D1_TOTAL,;		//09
								( cAliasQry )->A5_UNID,;		//10
								( cAliasQry )->A5_XTPCUNF,;		//11
								( cAliasQry )->A5_XCVUNF,;		//12
								( cAliasQry )->A5_CODPRF,;		//13
								( cAliasQry )->A5_CODBAR } )	//14
			EndIf
			( cAliasQry )->( dbSkip( ) )
		EndDo
	EndIf
	( cAliasQry )->( dbCloseArea( ) )
	
Return aRet
/*/{Protheus.doc} makeXml
//TODO Metodo para gerar XML do WS GetProdutosAConferir
@author Vinicius Moreira
@since 17/07/2018
@version 1.0
@return cXml, Caracter, XML de retorno do WS
@param lOk, logico, Indica se houve sucesso durante processamento dos dados
@param cMsg, caracter, Mensagem indicativa do erro ocorrido.
@param aProds, caracter, Array com os produtos que seram retornados
/*/
Method makeXml(lOk, cMsg, aProds) Class ProtheusGetProdutosAConferir

	Local cXml 		:= ''
	Local nX		:= 0
	Default lOk		:= .T.
	Default cMsg	:= ""

	cXml += '<?xml version="1.0" encoding="ISO-8859-1"?>'
	cXml += '<retorno>'
	cXml += '<id '
	cXml += ::tag('cdempresa'	, AllTrim( ADK->ADK_XEMP ) )
	cXml += ::tag('cdfilial'	, AllTrim( ADK->ADK_XFIL ) )
	cXml += ::tag('dsfilial'	, AllTrim( SM0->M0_FILIAL) )
	cXml += ::tag('numeronf'	, cCodNfe )
	cXml += ::tag('serienf'		, cSerNfe )
	cXml += ::tag('emissaonf'	, DToS( dEmisNFe ) )
	cXml += ::tag('cnpj'		, cCNPJ )
	cXml += ::tag('nomfornec'	, cNomFor )
	If Type( "__cUserId" ) == "C"
		cXml += ::tag('idusuario'	, __cUserId )
	Else
		cXml += ::tag('idusuario'	, "" )
	EndIf
	If Type( "cUserName" ) == "C"
		cXml += ::tag('usrlogin'	, cUserName )
	Else
		cXml += ::tag('usrlogin'	, "" )
	EndIf
	cXml += '/>'		
	cXml += '<produtos>'
	If lOk
		For nX := 1 to Len( aProds )
			cXml += '<produto'			
			cXml += ::tag('cditem'		, aProds[nX,01] )	//01
			cXml += ::tag('cdproduto'	, aProds[nX,02] )	//02
			cXml += ::tag('dsproduto'	, aProds[nX,03] )	//03
			cXml += ::tag('cdgrupo'		, aProds[nX,04] )	//04
			cXml += ::tag('dsgrupo'		, aProds[nX,05] )	//05
			cXml += ::tag('unprodtupo'	, aProds[nX,06] )	//06
			cXml += ::tag('quantidade'	, CValToChar( aProds[nX,07] ) )	//07
			cXml += ::tag('vrunitario'	, CValToChar( aProds[nX,08] ) )	//08
			cXml += ::tag('vrtotal'		, CValToChar( aProds[nX,09] ) )	//09
			cXml += ::tag('uncompra'	, aProds[nX,10] )	//10
			cXml += ::tag('dsfatorconv'	, aProds[nX,11] )	//11
			cXml += ::tag('fatorconv'	, CValToChar( aProds[nX,12] ) )	//12
			cXml += ::tag('cdcodfornec'	, aProds[nX,13] )	//13
			cXml += ::tag('cdcodbar'	, aProds[nX,14] )	//14
			cXml += '/>'
		Next nX
	EndIf	
	cXml += '</produtos>'	
	cXml += '<confirmacao>'
	cXml += '<confirmacao'
	If lOk
		cXml += ::tag('integrado'		,"true")
		If Empty( cMsg )
			cMsg := "Integracao ok."
		EndIf
	Else
		cXml += ::tag('integrado'		,"false")
	EndIf
	cXml += ::tag('mensagem'		,cMsg)
	cXml += ::tag('data'			,DtoS(Date()))		
	cXml += ::tag('hora'			,Time())	
	cXml += '/>'
	cXml += '</confirmacao>'
	cXml += '</retorno>'

Return cXml
/*/{Protheus.doc} WSEST020
//TODO Função principal de processamento
@author Vinicius Moreira
@since 06/08/2018
@version 1.0
@return cXml, Caracter, XML de retorno do WS
@param cCodEmp, caracter, Código da Empresa
@param cCodFil, caracter, Código da Filial
@param cIdUser, caracter, Usuário
@param ChaveNFe, caracter, Chave da NFe
/*/
User Function WSEST020(cCodEmp, cCodFil, cIdUser, ChaveNFe)

Local cXml			:= ""
Local cMsg			:= ""
Local cMetEnv		:= "Get"
Local cMethod		:= "GetProdutosAConferir"
Local oTag			:= ProtheusGetProdutosAConferir():New( "Tag" )
Local aProds		:= { }
Private cCNPJ		:= ""
Private cSerNFe		:= ""
Private cCodNfe		:= ""
Private dEmisNFe	:= CToD( "" )
Private cNomFor		:= ""
Default ChaveNFe    := ""

	If !VerEmp(cCodEmp, cCodFil)
		cMsg := "Empresa / Filial nao encontrados no ERP. [ADK_FILIAL + ADK_XEMP + ADK_XFIL = " + xFilial("ADK") + cCodEmp + cCodFil + "]"
	ElseIf !VldUser( cIdUser )
		cMsg := "Usuario encontrado no ERP."
	Else
		nModulo 	:= 4
		__cUserId	:= cIdUser
		cCNPJ 	:= SubStr(ChaveNFe,07,14)
		cSerNFe := SubStr(ChaveNFe,23,03)
		cCodNfe := SubStr(ChaveNFe,26,09)

		ConOut("--> Gerando itens para conferencia para filial " + cFilAnt + " e NF/Serie " + cCodNfe + "/" + cSerNFe )

		//       cnpj                    serie numero
		//0000000385389600022000001090909999 
		//CONOUT(cCNPJ)
		//CONOUT(cSerNFe)
		//CONOUT(cCodNfe)
		
		// -> Verifica se as informações de cnpj, serie e numero da nfe estão preenchidos
		If Empty(cCNPJ) .or. Empty(cSerNFe) .or. Empty(cCodNfe)
			cMsg := "Não encontrados o CNPJ, Numero e Série do documento de entrada na chave da DANFE informada para conferência.
		Else
			// Pesquisar fornecedor
			SA2->(DbSetOrder(3))
			If !SA2->(DbSeek(xFilial("SA2")+cCNPJ))
				cMsg := "Fornecedor não encontrado no ERP Protheus.."
			Else
				cNomFor := AllTrim( SA2->A2_NOME )
				// Pesquisar Pré-nota
				SF1->(DbSetOrder(1))
				If !SF1->( dbSeek( xFilial( "SF1" ) + cCodNfe + cSerNFe + SA2->A2_COD + SA2->A2_LOJA ) )
					cMsg := "Nota fiscal não encontrado no ERP Protheus."
				Else
					dEmisNFe := SF1->F1_EMISSAO
					If !Empty( SF1->F1_STATUS )
						cMsg := "Nota fiscal já confirmada ERP Protheus."
					Else
						aProds := oTag:GetRegs( @cMsg )
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
	
	// -> Se Ok, retorna 
	If Empty(cMsg)
		ConOut("Ok.")
	Else
		ConOut("Erro.")		
	EndIf
	
	cXml := oTag:MakeXml( Empty( cMsg ), cMsg, aProds )

Return cXml
/*/{Protheus.doc} VerEmp
//TODO Função para validar e posicionar na Empresa/Filial informada
@author Vinicius Moreira
@since 06/08/2018
@version 1.0
@return lRet. Lógico, .T. OU .F.
@param cCodEmp, caracter, Código da Empresa
@param cCodFil, caracter, Código da Filial
/*/
Static Function VerEmp(cCodEmp, cCodFil)

	Local lRet		:= .T.
	Local cQuery	:= ""
	Local cAlEmp	:= ""

	cQuery := "	SELECT R_E_C_N_O_ REGNO_ADK " + CRLF
	cQuery += "	FROM " + RetSqlName("ADK") + " ADK " + CRLF
	cQuery += "	WHERE ADK_FILIAL = '" + xFilial("ADK") + "' " + CRLF
	cQuery += "	  AND ADK_XEMP = '" + cCodEmp + "' " + CRLF
	cQuery += "	  AND ADK_XFIL = '" + cCodFil + "' " + CRLF
	cQuery += "	  AND ADK_XFILI <> ' ' " + CRLF
	cQuery += "	  AND ADK_MSBLQL = '2' " + CRLF	
	cQuery += "	  AND ADK.D_E_L_E_T_ = ' ' " + CRLF

	cQuery := ChangeQuery(cQuery)
	cAlEmp := MPSysOpenQuery(cQuery)
	
	If (cAlEmp)->(Eof())
		lRet := .F.
	Else

		dbSelectArea("ADK")
		ADK->(dbGoTo((cAlEmp)->REGNO_ADK))
		
		OpenSm0("02", .f.)

		SM0->(dbSetOrder(1))
		SM0->(dbSeek("02" + ADK->ADK_XFILI))
		
		cEmpAnt := "02"		//Será criado um campo na ADK com esta informação. Precisa substituir 
		cFilAnt	:= ADK->ADK_XFILI

	EndIf
	
	(cAlEmp)->(dbCloseArea())

Return lRet
/*/{Protheus.doc} VldUser
//TODO Checa se usuario informado existe 
@author Vinicius Moreira
@since 06/08/2018
@version 1.0
@return lRet. Lógico, .T. OU .F.
@param cIdUser, caracter, Codigo do usuario
/*/
Static Function VldUser( cIdUser )

PswOrder( 1 )

Return PswSeek( cIdUser, .T. ) 