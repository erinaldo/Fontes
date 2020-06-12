#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#Include "TOPCONN.CH"
#include "tbiconn.ch"
#INCLUDE "restful.ch"

WSRESTFUL PutProdutosARequisitar DESCRIPTION "Madero - Requisições de produtos ao estoque"

	WSMETHOD POST DESCRIPTION "Produtos a Inventariar" WSSYNTAX "/PutProdutosARequisitar/"

End WSRESTFUL

/*/{Protheus.doc} GET
//TODO Declaração do Metodo GetAcesso
@author Mario L. B. Faria
@since 12/07/2018
@version 1.0
/*/
WSMETHOD POST WSSERVICE PutProdutosARequisitar
Local cBody := ::GetContent()
Local cXml	:= ""
	
	::SetContentType("application/xml")
	
	cXml := WSEST011(cBody)

	::SetResponse(cXML)	

Return .T.

/*/{Protheus.doc} ProtheusGetProdutosAInventariar
//TODO declaração das classe para gerar o XML
@author Mario L. B. Faria
@since 12/07/2018
@version 1.0
@return ${return}, ${return_description}
/*/
Class ProtheusPutProdutosARequisitar From ProtheusMethodAbstract

	Method new(cMethod) constructor
	Method MakeXml(oXml, cMsg)
	Method AnaliseAce(oXmlAce) 
	//Method AnaliseGrp(oXml)
	//Method AnalisePrd(cGrp)
	//Method VerInvAbe() 

EndClass

/*/{Protheus.doc} New
//TODO Metodo Inicializados da Classe Protheus PutProdutosAInventariar
@author Mario L. B. Faria
@since 12/07/2018
@version 1.0
@return ${return}, ${return_description}
@param cMethod, characters, descricao
/*/
Method New(cMethod) Class ProtheusPutProdutosARequisitar
	::cMethod := cMethod
Return

/*/{Protheus.doc} makeXml
//TODO Metodo para gerar XML do WS PutProdutosAInventariar
@author Mario L. B. Faria
@since 17/07/2018
@version 1.0
@return cXml, Caracter, XML de retorno do WS
@param cAlQry, caracter, Alias com os dados a enviar
/*/
Method MakeXml(oXml, cMsg, oPrdInt) Class ProtheusPutProdutosARequisitar
Local cXml 	:= ''
Local oWs 	:= Nil
Local nI
	
	oWs		:= ProtheusPutProdutosARequisitar():New("Tag")
	
	oXmlId	:= oXml:_MOVIMENTO:_ID

	cXml += '<?xml version="1.0" encoding="ISO-8859-1"?>'
	
	cXml += '<Retorno>'
	
	cXml += '<id' 
	cXml += ::tag('cdempresa'		,oXmlId:_cdempresa:TEXT)	
	cXml += ::tag('cdfilial'		,oXmlId:_cdfilial:TEXT)		
	cXml += ::tag('idusuario'		,oXmlId:_idusuario:TEXT)		
	cXml += ::tag('datamov'			,oXmlId:_datamov:TEXT)
	cXml += '/>'
	 
	cXml += '<retornos>'
	
	If valType(oXml:_MOVIMENTO:_PRODUTOS:_cdproduto) = "O" 
	   XmlNode2Arr (oXml:_MOVIMENTO:_PRODUTOS:_cdproduto, "_cdproduto") // Transforma em array um objeto (nó) da estrutura do XML 
	EndIf
		      
	// Realiza uma copia do mesmo    
	aXML := aClone(oXml:_MOVIMENTO:_PRODUTOS:_cdproduto) 

	cXml += '<produtos>'
	For nI := 1 To Len(oPrdInt) 
		cXml += '<cdproduto'
		cXml += ::tag('cdproduto'		,oPrdInt[nI][1])
		cXml += ::tag('dsproduto'		,oPrdInt[nI][2])
		cXml += ::tag('cdcodmov'		,oPrdInt[nI][3])
		cXml += ::tag('dscodmov'		,oPrdInt[nI][4])
		cXml += ::tag('qtdemovim'		,oPrdInt[nI][5])
		cXml += ::tag('integrado'		,oPrdInt[nI][6])
		cXml += ::tag('mensagem'		,If(Empty(oPrdInt[nI][7]), "Integracao ok.", oPrdInt[nI][7]))
		cXml += ::tag('data'			,Date()	,"DATE") 
		cXml += ::tag('hora'			,Time())	
		cXml +=	'/>'
	Next
	cXml += '</produtos>'
	
	cXml += '</retornos>'
	
	cXml += '</Retorno>'

Return cXml


/*/{Protheus.doc} AnaliseAce
//TODO Metodo para validar os acessos
@author Mario L. B. Faria
@since 24/07/2018
@version 1.0
@return cRet, caracter. mensagem de retorno, se retornar vazio não houve erro
@param oXmlAce, object, contem o dados de acesso
/*/
Method AnaliseAce(oXmlAce) class ProtheusPutProdutosARequisitar
Local lErro		:= .F.
Local cRet		:= ""
Local cEmp		:= oXmlAce:_CDEMPRESA:TEXT
Local cFil		:= oXmlAce:_CDFILIAL:TEXT
Local cUser		:= oXmlAce:_IDUSUARIO:TEXT
Local cDat		:= oXmlAce:_DATAMOV:TEXT
Local cQuery	:= ""
Local cAlQry	:= ""
Local xFili		:= ""
Local aArea		:= GetArea()
		
	If !Empty(cEmp) .Or. !Empty(cFil)

		cQuery := "	SELECT R_E_C_N_O_ REGNO_ADK " + CRLF
		cQuery += "	FROM " + RetSqlName("ADK") + " ADK " + CRLF
		cQuery += "	WHERE " + CRLF
		cQuery += "		ADK_XEMP = '" + cEmp + "' " + CRLF
		cQuery += "		AND ADK_XFIL = '" + cFil + "' " + CRLF
		cQuery += "		AND ADK.D_E_L_E_T_ = ' ' " + CRLF

		cQuery := ChangeQuery(cQuery)
		cAlQry := MPSysOpenQuery(cQuery)

		If !(cAlQry)->(Eof())
			
			dbSelectArea("ADK")
			ADK->(dbGoTo((cAlQry)->REGNO_ADK))	
			
			If !Empty(ADK->ADK_XFILI)
			
				OpenSm0("02", .f.)
				SM0->(dbSetOrder(1))
				SM0->(dbSeek("02" + ADK->ADK_XFILI))
				xFili := ADK->ADK_XFILI
				
				//Abertura do ambiente
				dbCloseAll()
				
			     cEmpAnt	:= "02"
			     cFilAnt	:= xFili
			     cNumEmp := cEmpAnt+cFilAnt
			     nModulo := 4
			     OpenSM0(cEmpAnt+cFilAnt)
			     OpenFile(cEmpAnt+cFilAnt) 
				
				VerParam()
				
			Else 
				lErro	:= .T.	
			EndIf
			
		Else			
			lErro := .T.					
		EndIf
		
		If lErro
			cRet := "Ocorreu erro na inicialização do ambiente."
			cEmp	:= ""
			cFil	:= ""
		EndIf
			
	EndIf

	RestArea(aArea)

Return cRet

/*/{Protheus.doc} WSEST011
//TODO Função Princiapal do WS
@author Mario L. B. Faria
@since 24/07/2018
@version 1.0
@return cXml, carcater, XMl de RETORNO
@param cXml, characters, XML recebido
/*/
Static Function WSEST011(cXml)
Local lCont		:= .T.
Local cAux		:= ""
Local cxMsg		:= ""
Local oWs		:= Nil
Local oXml		:= Nil
Local oXmlAce	:= Nil
Local oXmlId	:= Nil
Local lRet		:= .F.
Local lErroProd	:= .F.
Local cxEmp     := ""
Local cxFil`    := ""
Local axGrupoU	:= {}
Local cRot      := "MTA240 "
Local lErroProd := .F.
Local cProdMsg	:= ""
Local oPrdInt	:= {}
Local oPrdErro	:= {}
Local nI
Local cPathTmp  := "\temp\"
Local cFileErr  := ""

	ConOut("-> Iniciando processo de requisicao de itens ao estoque...")

	// -> Seleciona tabelas
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))

	DbSelectArea("Z13")
	Z13->(DbSetOrder(1))

	DbSelectArea("SF5")
	SF5->(DbSetOrder(1))

	If Empty(cXml)
		cAux := "XML invalido ou vazio!!!"
		ConOut(cAux)
		lCont := .F.
	EndIf
	
	If lCont
				
		oWs		:= ProtheusPutProdutosARequisitar():New("Tag")
		oXmlAce	:= oWs:xmlParser(cXml)
		cxMsg	:= oWs:AnaliseAce(oXmlAce:_MOVIMENTO:_ID)		
		oXml	:= oWs:xmlParser(cXml)
		oXmlId	:= oXml:_MOVIMENTO:_ID
		oXmlPrds:= oXml:_MOVIMENTO:_PRODUTOS:_cdproduto	
		cxEmp   := IIF(Empty(xFilial("Z13")),Space(TamSx3("ADK_XEMP")[1]),oXmlId:_CDEMPRESA:TEXT)
		cxFil`  := IIF(Empty(xFilial("Z13")),Space(TamSx3("ADK_XFIL")[1]),oXmlId:_CDFILIAL:TEXT)
		axGrupoU:= UsrRetGrp(,AllTrim(oXmlId:_idusuario:TEXT))
		
		If Empty(cxMsg)
		
			If valType(oXml:_MOVIMENTO:_PRODUTOS:_cdproduto) = "O" 
		         XmlNode2Arr (oXml:_MOVIMENTO:_PRODUTOS:_cdproduto, "_cdproduto") // Transforma em array um objeto (nó) da estrutura do XML 
		    EndIf
		      
		    // Realiza uma copia do mesmo    
		    aXML := aClone(oXml:_MOVIMENTO:_PRODUTOS:_cdproduto) 
			If Len(aXML) > 0 
				
				// -> Atualizaparâmetros
				U_WSEST011PR()
				
				For nI := 1 To Len(aXML) 
					lErroProd	:= .F.
					cdproduto:=aXML[nI]:_cdproduto:TEXT
					dsproduto:=aXML[nI]:_dsproduto:TEXT
					cdcodmov :=aXML[nI]:_cdcodmov:TEXT
					dscodmov :=aXML[nI]:_dscodmov:TEXT
					qtdemovim:=aXML[nI]:_qtdemovim:TEXT
					idusuario:=oXml:_MOVIMENTO:_ID:_idusuario:TEXT
					cdatamov :=oXml:_MOVIMENTO:_ID:_datamov:TEXT
					cCC		 :=VerZA0()
					aMata240 :={}

					// -> Pesquisa produto
					Z13->(DbSeek(xFilial("Z13")+cxEmp+cxFil+cdproduto))
					If Z13->(Found())
						cdproduto:=Z13->Z13_COD
					Else
						SB1->(DbOrderNickName("B1XCODEXT"))
						SB1->(DbSeek(xFilial("SB1")+cdproduto))
						If SB1->(Found())
						   cdproduto:=SB1->B1_COD
						EndIf   
					EndIf	
					
					// -> Verifica se encontrou o produto no Protheus
					SB1->(DbSetOrder(1))
					SB1->(DbSeek(xFilial("SB1")+cdproduto))
					If SB1->(Found())

						ConOut(":"+AllTrim(SB1->B1_COD)+" - "+SB1->B1_DESC)

						// -> Verifica se encontrou o produto no Protheus
						If SF5->(DbSeek(xFilial("SF5")+AllTrim(cdcodmov)))

							// -> Verifica se o usuario possui acesso para fazer a baixa
							If u_EST200RL(cRot,SB1->B1_COD,SB1->B1_GRUPO,idusuario,axGrupoU,SF5->F5_CODIGO)

								aAdd( aMata240, { "D3_TM"     , SF5->F5_CODIGO,})
								aAdd( aMata240, { "D3_COD"    , SB1->B1_COD   ,})
								aAdd( aMata240, { "D3_CC"     , ALLTRIM(cCC)  ,})
								aAdd( aMata240, { "D3_USUARIO", idusuario     ,})
								aAdd( aMata240, { "D3_QUANT"  , VAL(qtdemovim),})
								aAdd( aMata240, { "D3_EMISSAO", stod(cdatamov),})
					
								Begin Transaction 
					
									lMsErroAuto := .F.
									MSExecAuto({|x,y| mata240(x,y)},aMata240,3)		
		
									If !lMsErroAuto		
										lRet	:=	.T.		
									Else	
										lRet := .F.
										lErroProd := .T.
										cFileErr := "log_"+cFilAnt+"_"+strtran(time(),":","")
										MostraErro(cPathTmp, cFileErr)
										cxMsg := memoread(cPathTmp+cFileErr)
										DisarmTransaction()	
										Break									
									EndIf	
								
								End Transaction
						
							Else
							
								cxMsg+= AllTrim(cRot)+":"+idusuario+":"+SB1->B1_COD+": Usuario sem permissao para requisitar o produto."
								lRet := .F.
								lErroProd := .T.
							EndIf
						
						Else
							
							cxMsg+= AllTrim(cdcodmov)+": TM nao cadastrada no Protheus."
							lRet := .F.
							lErroProd := .T.
						EndIf
					
					Else
						
						cxMsg+= AllTrim(cdproduto)+": Produto nao cadastrado no Protheus."
						lRet := .F.
						lErroProd := .T.
					EndIf

					If lErroProd
						AAdd(oPrdInt,{cdproduto, dsproduto, cdcodmov, dscodmov, qtdemovim, "false", cxMsg})
					Else
						AAdd(oPrdInt,{cdproduto, dsproduto, cdcodmov, dscodmov, qtdemovim, "true", cxMsg})
					EndIf
				Next 
	         
	         EndIf 	
		
		Else
		
			cAux	:= cxMsg
			lCont	:= .F.
		
		EndIf
	
	EndIf	
	
	//If lRet
		cXml := oWs:MakeXml(oXml, cAux, oPrdInt)
		ConOut("Ok.")		
	//Else
		//cAux := cxMsg
		//cXml := '<confirmacao integrado="' + If(lRet,"true","false") + '" mensagem="' + cAux + '" data="' + DtoS(Date()) + '" hora="' + Time() + '"/>'
		//ConOut("Erro.")		
	//EndIF
	
Return cXml


/*/{Protheus.doc} SetParam
//TODO Função para setar parametros no execauto MATA240
@author Paulo Gabriel França e Silva
@since 17/08/2018
@version 1.0
/*/
User Function WSEST011PR()
Local cPergunta := "MTA240"

	Pergunte(cPergunta,.F.)

	mv_par01 := ""
	mv_par02 := ""
	mv_par03 := ""
	mv_par04 := ""
	mv_par05 := 1
	mv_par06 := dDataBase
Return

/*/{Protheus.doc} VerZA0
//TODO Verifica se possui cadastrado para filial
@author Paulo Gabriel França e Silva
@since 17/08/2018
@version 1.0
/*/
Static Function VerZA0()
	Local nRet		:= 0
	Local cQuery	:= ""
	Local cAlQry	:= ""	

	cQuery := "	SELECT ZA0_CUSTO " + CRLF
	cQuery += "	FROM ZA0020 ZA0 " + CRLF
	cQuery += "	WHERE " + CRLF
	cQuery += "		ZA0_FILCC  = '" + cFilAnt +  "' " + CRLF 
	cQuery += "		AND ZA0.D_E_L_E_T_ = ' ' " + CRLF

	cQuery := ChangeQuery(cQuery)
	cAlQry := MPSysOpenQuery(cQuery)
	If !(cAlQry)->(Eof())
		nRet := ALLTRIM((cAlQry)->ZA0_CUSTO)
	EndIf
	(cAlQry)->(dbCloseArea())
Return nRet


/*/{Protheus.doc} VerParam
//TODO Verifica se possui Parametro MV_ULMES na filial posicionada
@author Paulo Gabriel França e Silva
@since 20/08/2018
@version 1.0
/*/
Static Function VerParam()
	DbSelectArea("SX6") //Abre a tabela SX6
	DbSetOrder(1) //Se posiciona no primeiro indice
	If !DbSeek(xFilial("SX6")+"MV_ULMES") //Verifique se o parametro existe
	      RecLock("SX6",.T.) //Se nao existe, criar o registro
	      SX6->X6_VAR     := "MV_ULMES"
	      SX6->X6_TIPO    := "D"
	      SX6->X6_DESCRIC := "Data ultimo fechamento do estoque."
	      SX6->X6_CONTEUD := "20180731"
	      MsUnLock() //salva o registro com as informações passada
	EndIf
Return