#INCLUDE 'protheus.ch'
#INCLUDE "restful.ch"

/*/{Protheus.doc} PutClassificacaoNF
//TODO Declaração do WebService PutClassificacaoNF
@author Vinicius Moreira
@since 06/08/2018
@version 1.0
/*/
WSRESTFUL PutClassificacaoNF DESCRIPTION "Madero - Classificação da NF"
	
	WSDATA cdempresa AS STRING
	WSDATA cdfilial AS STRING
	WSDATA cdusuario AS STRING
	WSDATA chavenfe AS STRING

	WSMETHOD PUT DESCRIPTION "Acesso de Usuários" WSSYNTAX "/PutClassificacaoNF || /PutClassificacaoNF/{id}"

End WSRESTFUL

/*/{Protheus.doc} GET
//TODO Declaração do Metodo PutClassificacaoNF
@author Vinicius Moreira
@since 06/08/2018
@version 1.0

/*/
WSMETHOD PUT WSRECEIVE cdempresa, cdfilial, cdusuario, chavenfe  WSSERVICE PutClassificacaoNF

	Local cXml	:= ""

	::SetContentType("application/xml")
	
	cXml := U_WSEST022(Self:cdempresa, Self:cdfilial, Self:cdusuario, Self:chavenfe)

	::SetResponse(cXML)

Return .T.
/*/{Protheus.doc} WSEST022
//TODO Função principal de processamento
@author Vinicius Moreira
@since 06/08/2018
@version 1.0
@return cXml, Caracter, XML de retorno do WS
@param cCodEmp, caracter, Código da Empresa
@param cCodFil, caracter, Código da Filial
@param cIdUser, caracter, Usuário
@param chavenfe, caracter, Chave da NFe
/*/
User Function WSEST022(cCodEmp, cCodFil, cIdUser, chavenfe)

Local cXml			:= ""
Local cMsg			:= ""
Local oTag			:= ProtheusPutClassificacaoNF():New( "Tag" )
Local aProds		:= { }
Private cCNPJ		:= ""
Private cSerNFe		:= ""
Private cCodNfe		:= ""
Private dEmisNFe	:= CToD( "" )
Private cNomFor		:= ""

	If !VerEmp(cCodEmp, cCodFil)
		cMsg := "Empresa / Filial nao encontrados no ERP. [ADK_FILIAL + ADK_XEMP + ADK_XFIL = " + xFilial("ADK") + cCodEmp + cCodFil + "]"
	ElseIf !VldUser( cIdUser )
		cMsg := "Usuario nao encontrado no ERP."
	Else
		nModulo 	:= 4
		cUSRLogin	:= PSWRet()[1][2]
		__cUserId	:= cIDUsuario := cIdUser
		cCNPJ 	:= SubStr(chavenfe,07,14)
		cSerNFe := SubStr(chavenfe,23,03)
		cCodNfe := SubStr(chavenfe,26,09)
		
		ConOut("--> Classificando NF/Serie " + cCodNfe + "/" + cSerNFe + " para filial " + cFilAnt)
	
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
					cMsg := oTag:procRegs( )
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

	cXml := oTag:MakeXml( Empty( cMsg ), cMsg )

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

	cQuery := "	SELECT R_E_C_N_O_ REGNO_ADK "        + CRLF
	cQuery += "	FROM " + RetSqlName("ADK") + " ADK " + CRLF
	cQuery += "	WHERE ADK_FILIAL     = '" + xFilial("ADK") + "' " + CRLF
	cQuery += "	  AND ADK_XEMP       = '" + cCodEmp + "' "        + CRLF
	cQuery += "	  AND ADK_XFIL       = '" + cCodFil + "' "        + CRLF
	cQuery += "	  AND ADK_XFILI     <> ' ' " + CRLF
	cQuery += "	  AND ADK_MSBLQL     = '2' " + CRLF	
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
/*/{Protheus.doc} ProtheusPutClassificacaoNF
//TODO declaração das classe para gerar o XML
@author Vinicius Moreira
@since 06/08/2018
@version 1.0
@return ${return}, ${return_description}
/*/
Class ProtheusPutClassificacaoNF From ProtheusMethodAbstract

	Method new( cMethod ) constructor
	Method makeXml( lIntegrado, cMsg )
	Method procRegs( )

EndClass
/*/{Protheus.doc} New
//TODO Metodo Inicializados da Classe ProtheusPutClassificacaoNF
@author Vinicius Moreira
@since 06/08/2018
@version 1.0
@return ${return}, ${return_description}
@param cMethod, caracter, descricao
/*/
Method New(cMethod) Class ProtheusPutClassificacaoNF
	::cMethod := cMethod
Return
/*/{Protheus.doc} getRegs
//TODO Metodo de processamento de registros
@author Vinicius Moreira
@since 07/08/2018
@version 1.0
@return cRet, caracter, Mensagem de erro durante o processamento
/*/
Method procRegs( ) Class ProtheusPutClassificacaoNF
Local cxRet 	:= ""
Local aSF1		:= { }
Local aSD1		:= { }
Local lErroTes	:= .F.
Local cAuxTes   := ""
Private lMsHelpAuto := .T.
Private lMsErroAuto := .F.
	
	dbSelectArea( "SB1" )
	SB1->( dbSetOrder( 1 ) )//B1_FILIAL+B1_COD
	dbSelectArea( "SF4" )
	SF4->( dbSetOrder( 1 ) )//F4_FILIAL+F4_TES
	dbSelectArea( "SC7" )
	SC7->( dbSetOrder( 1 ) ) // C7_FILIAL+C7_NUM+C7_ITEM
	dbSelectArea( "SD1" )
	SD1->( dbSetOrder( 1 ) )//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
	If SD1->( dbSeek( SF1->( F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA ) ) )
		AAdd( aSF1, { "F1_FILIAL"	, SF1->F1_FILIAL	, Nil } )
		AAdd( aSF1, { "F1_DOC"		, SF1->F1_DOC		, Nil } )
		AAdd( aSF1, { "F1_SERIE"	, SF1->F1_SERIE		, Nil } )
		AAdd( aSF1, { "F1_FORNECE"	, SF1->F1_FORNECE	, Nil } )
		AAdd( aSF1, { "F1_LOJA"		, SF1->F1_LOJA		, Nil } )
		AAdd( aSF1, { "F1_TIPO"		, SF1->F1_TIPO		, Nil } )
		While SD1->( !Eof( ) ) .And. SD1->( D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA ) == SF1->( F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA )
			// -> Se o documento de entrada possui pedido, verifica a TES do pedido 
			lErroTes:=.F.
			cAuxTes :=""
			If !Empty( SD1->D1_PEDIDO )
			 	// -> Posiciona no pedido de compra
			 	If SC7->( dbSeek( SD1->( D1_FILIAL + D1_PEDIDO + D1_ITEMPC ) ) ) 
			 		// -> Verifica se o pedido possui TES
			 		If !Empty( SC7->C7_TES )
			 			// -> Posiciona na TES
			 			If SF4->( dbSeek( xFilial( "SF4" ) + SC7->C7_TES ) ) 
			 				// -> verifica se a ES está bloqueada
			 				If SF4->F4_MSBLQL <> "1"
			 				 	cAuxTes:=SF4->F4_CODIGO
			 					AAdd( aSD1, {	{"D1_COD"		, SC7->C7_PRODUTO	, Nil },;
			 									{"D1_ITEM"		, SC7->C7_ITEM		, Nil },;
			 									{"D1_FORNECE"	, SC7->C7_FORNECE	, Nil },;
			 									{"D1_LOJA"		, SC7->C7_LOJA		, Nil },;
			 									{"D1_PEDIDO"	, SC7->C7_NUM		, Nil },;
			 									{"D1_ITEMPC"	, SC7->C7_ITEM		, Nil },;
			 									{"D1_TES"		, cAuxTes     		, Nil }	} )
			 				Else
			 					lErroTes:=.T.
			 				EndIf
			 			Else
			 				lErroTes:=.T.
			 			EndIf
			 		Else
			 			lErroTes:=.T.
			 		EndIf
			 	Else
			 		lErroTes:=.T.
			 	EndIf
			Else
				lErroTes:=.T.
			EndIf
			
			// -> Verifica erro na TES
			If lErroTes	
				If Empty( cxRet )
					cxRet += "TES e/ou pedido de compra invalido(s) para os seguintes itens no pedido de compra:" + CRLF 
					cxRet += "Item Pedido    Codigo           Descricao                                                      Cod. TES  " + CRLF  
					cxRet += "---- --------- ---------------- -------------------------------------------------------------- ----------" + CRLF 
				 EndIf 
				 cxRet += PadR( SD1->D1_ITEMPC	, 04, " " )
				 cxRet += " "
				 cxRet += PadR( SD1->D1_PEDIDO	, 09, " " )
				 cxRet += " "
				 cxRet += PadR( SD1->D1_COD		, 16, " " )
				 cxRet += " "
				 SB1->( dbSeek( xFilial( "SB1" ) + SD1->D1_COD ) )
				 cxRet += PadR( SB1->B1_DESC		, 62, " " )
				 cxRet += " "
				 cxRet += PadR( cAuxTes  		, 10, " " )
				 cxRet += " " + CRLF
			EndIf			
			
			SD1->( dbSkip( ) )
		
		EndDo		
		
		If Empty( cxRet )
			SD1->( dbSeek( SF1->( F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA ) ) )
			aSF1 := fChkCpos( aSF1 )
			AEval( aSD1, {|x,y| aSD1[y] := fChkCpos( aSD1[y] ) } )
			l103Class	:= .T.
			l103TolRec	:= .T.
			INCLUI		:= .F.
			ALTERA		:= .F.
			MsExecAuto( { |x,y,z,w| MATA103( x/*xAutoCab*/, y/*xAutoItens*/, z/*nOpcAuto*/, /*lWhenGet*/, /*xAutoImp*/, /*xAutoAFN*/, /*xParamAuto*/, /*xRateioCC*/, w/*lGravaAuto*/, /*xCodRSef*/ ) }, aSF1, aSD1, 4, .T. )
			If lMsErroAuto
				DisarmTransaction( )
				cxRet := fGetErro( "MATA103" )
			EndIf
		EndIf
	EndIf
	
	
Return cxRet
/*/{Protheus.doc} makeXml
//TODO Metodo para gerar XML do WS ProtheusPutClassificacaoNF
@author Vinicius Moreira
@since 07/08/2018
@version 1.0
@return cXml, Caracter, XML de retorno do WS
@param lOk, logico, Indica se os dados foram processados com sucesso
@param cMsg, caracter, Mensagem que sera retornada para o client web service
/*/
Method makeXml(lOk, cMsg) Class ProtheusPutClassificacaoNF

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
	cXml += ::tag('serienf'		, cSerNFe )
	cXml += ::tag('emissaonf'	, DToS( dEmisNFe ) )
	cXml += ::tag('cnpj'		, cCNPJ )
	cXml += ::tag('nomfornec'	, cNomFor )
	cXml += ::tag('idusuario'	, cIDUsuario )
	cXml += ::tag('usrlogin'	, cUSRLogin )
	cXml += '/>'		
	cXml += '<produtos>'
	cXml += '</produtos>'	
	cXml += '<confirmacao>'
	cXml += '<confirmacao'
	If lOk
		cXml += ::tag('integrado'		,"true")
		If Empty( cMsg )
			cMsg := "Classificacao da NF ok."
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
/*/{Protheus.doc} fChkCpos
//TODO Ordena campos para processamento do MSExecAuto
@author Vinicius Moreira
@since 07/08/2018
@version 1.0
@return aRet, array, Array com os campos ja ordenados
@param aCpos, array, Forca ordenacao dos campos sempre com base na ordem do SX3 para execucao do MSExecAuto
/*/
Static Function fChkCpos(aCpos)

Local aCposAux := {}
Local aRet     := {}
Local nCpo     := 0
Local nTamCpo  := Len(SX3->X3_CAMPO)

dbSelectArea("SX3")
SX3->(dbSetOrder(2))//X3_CAMPO

For nCpo := 1 to Len(aCpos)
	If SX3->(dbSeek(PadR(aCpos[nCpo, 1], nTamCpo, " ")))
		aAdd(aCposAux, {SX3->X3_ORDEM, aCpos[nCpo]})
	Else
		aAdd(aCposAux, {"999", aCpos[nCpo]})
	EndIf
Next nCpo
ASort(aCposAux,,,{|x,y| x[1] < y[1] })
For nCpo := 1 to Len(aCposAux)
	aAdd(aRet, aCposAux[nCpo,2])
Next nCpo

Return aRet
/*/{Protheus.doc} fGetErro
//TODO Retorna mensagem de erro do MSExecAuto
@author Vinicius Moreira
@since 07/08/2018
@version 1.0
@return cRet, caracter, Mensagem do erro do MSExecAuto
@param cPrefix, caracter, Prefixo para salvar o arquivo temporario de erro.
/*/
Static Function fGetErro( cPrefix )

Local cDirLogs	:= "\temp\"
Local cArqLog	:= cPrefix + "_" + DToS( Date( ) ) + "_" + StrTran( Time( ), ":", "" ) + ".log"
Local cRet		:= ""

MostraErro( cDirLogs, cArqLog )
cRet := MemoRead( cDirLogs + cArqLog )
FErase( cDirLogs + cArqLog )
If Empty( cRet )
	cRet := "Erro"
EndIf

Return cRet