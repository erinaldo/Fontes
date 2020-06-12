#include 'protheus.ch'
/*-----------------+---------------------------------------------------------+
!Nome              ! TkPutCompo                                              !
+------------------+---------------------------------------------------------+
!Descrição         ! Função para chamr o metodo PutComposicao via Menu       !
+------------------+---------------------------------------------------------+
!Autor             ! Mario L. B. Faria                                       !
+------------------+---------------------------------------------------------!
!Data              ! 25/05/2018                                              !
+------------------+--------------------------------------------------------*/
user function TkPutCompo(lBatch)
Private cPerg := padr("TPMETODO",10)
Default lBatch:=.F.	

    // -> Se não for executado por job
	If! lBatch	
		U_CRSX01MD()
		if !Pergunte(cPerg,.T.)
			Return .F.
		EndIf
	
		Do Case
			Case MV_PAR01 = 1
				TkCompo("Post")			
			Case MV_PAR01 = 2
				Alert("Opção não disponivel para este método")			
			Case MV_PAR01 = 3
				TkCompo("Delete")	
		EndCase
    EndIf
    
    // -> Se não for executado por job
	If lBatch
 		// -> Executa o processo para inclusão de estrutura de produtos
	    TkCompo("Post")
 		// -> Executa o processo para exclusao de estrutura de produtos	
	    TkCompo("Delete")  
	EndIf
	    
Return


/*-----------------+---------------------------------------------------------+
!Nome              ! TkCompo                                                 !
+------------------+---------------------------------------------------------+
!Descrição         ! Função para processar o WS                              !
+------------------+---------------------------------------------------------+
!Autor             ! Mario L. B. Faria                                       !
+------------------+---------------------------------------------------------!
!Data              ! 25/05/2018                                              !
+------------------+--------------------------------------------------------*/
Static Function TkCompo(cMetEnv)
Local oIntegra
Local cMethod	:= "PutComposicao"
Local cAlias	:= "Z14"
Local cAlRot	:= "SG1"
Local oEventLog := EventLog():start("Composicao - "+AllTrim(cMetEnv), Date(), "Iniciando processo de integracao...", cMetEnv, cAlRot) 
	
	//instancia a classe
	oIntegra := TeknisaPutComposicao():new(cMethod, cMetEnv, cAlias, cAlRot, oEventLog)

	//se estiver ativo
	If oIntegra:isEnable()

		//busca os registros e se sequencia em lotes
		oIntegra:prepare()

		oIntegra:send()

	EndIf
	
	oEventLog:Finish()

return


/*-----------------+---------------------------------------------------------+
!Nome              ! PutComposicao                                           !
+------------------+---------------------------------------------------------+
!Descrição         ! Classe PutComposicao                                    !
+------------------+---------------------------------------------------------+
!Autor             ! Mario L. B. Faria                                       !
+------------------+---------------------------------------------------------!
!Data              ! 25/05/2018                                              !
+------------------+--------------------------------------------------------*/
class TeknisaPutComposicao from TeknisaMethodAbstract
Data oLog
Data cMetE

	method new() constructor
	method analise(oXmlItem)
	method fetch()
	method makeXml(aLote,cMetEnv) 

endclass


/*-----------------+---------------------------------------------------------+
!Nome              ! new                                                     !
+------------------+---------------------------------------------------------+
!Descrição         ! Metodo inicializador da classe                          !
+------------------+---------------------------------------------------------+
!Autor             ! Mario L. B. Faria                                       !
+------------------+---------------------------------------------------------!
!Data              ! 25/05/2018                                              !
+------------------+--------------------------------------------------------*/
method new(cMethod, cMetEnv, cAlias, cAlRot, oEventLog) class TeknisaPutComposicao

	//inicialisa a classe
	::init(cMethod, cMetEnv, cAlias, cAlRot, oEventLog)
	::oLog :=oEventLog
	::cMetE:=cMetEnv

return



/*-----------------+---------------------------------------------------------+
!Nome              ! fetch                                                   !
+------------------+---------------------------------------------------------+
!Descrição         ! Metodo para aseleção dos dados a enviar                 !
+------------------+---------------------------------------------------------+
!Autor             ! Mario L. B. Faria                                       !
+------------------+---------------------------------------------------------!
!Data              ! 25/05/2018                                              !
+------------------+--------------------------------------------------------*/
method fetch() class TeknisaPutComposicao
Local cQuery	:= ''
Local cPreRot	:= If(Len(PrefixoCpo(::cAlRot)) == 2,"S" + PrefixoCpo(::cAlRot), PrefixoCpo(::cAlRot))
Local cPreAli	:= If(Len(PrefixoCpo(::cAlias)) == 2,"S" + PrefixoCpo(::cAlias), PrefixoCpo(::cAlias))
Local cErrorLog := ""

	cErrorLog:=": Selecionando dados da estrutura do produto..." 
	::oLog:SetAddInfo(cErrorLog,"Gerando XML...")
	ConOut(cErrorLog)

	cQuery += "	SELECT " + CRLF
	cQuery += "		0 ROT_REG, " + CRLF	//Recno da tabela Principal
	cQuery += "		" + cPreAli + ".R_E_C_N_O_ ALI_REG " + CRLF		//Recno da tabela Auxiliar
	
	cQuery += "	FROM " + RetSqlName(::cAlias) + " " + cPreAli + " " + CRLF
	
	cQuery += "	WHERE  " + CRLF
	cQuery += "			" + PrefixoCpo(::cAlias) + "_FILIAL = '" + xFilial(::cAlias) + "' " + CRLF
	
	If Upper(::cMetEnv) == "POST"
		cQuery += "		AND " + PrefixoCpo(::cAlias) + "_XSTINT = 'P' " + CRLF
		cQuery += "		AND " + PrefixoCpo(::cAlias) + "_XEXC != 'S' " + CRLF
	ElseIf Upper(::cMetEnv) == "DELETE"
		cQuery += "		AND " + PrefixoCpo(::cAlias) + "_XSTINT = 'P' " + CRLF
		cQuery += "		AND " + PrefixoCpo(::cAlias) + "_XEXC = 'S' " + CRLF
	EndIf	
	
	cQuery += "		AND " + cPreAli + ".D_E_L_E_T_ = ' ' " + CRLF

	MemoWrite("C:\TEMP\" + ::cMethod + "_" + ::cMetEnv + ".sql",cQuery)

	cQuery := ChangeQuery(cQuery)

return MPSysOpenQuery(cQuery)


/*-----------------+---------------------------------------------------------+
!Nome              ! analise                                                 !
+------------------+---------------------------------------------------------+
!Descrição         ! Metodo para analizar e gravar os dados de retorno do WS !
+------------------+---------------------------------------------------------+
!Autor             ! Mario L. B. Faria                                       !
+------------------+---------------------------------------------------------!
!Data              ! 25/05/2018                                              !
+------------------+--------------------------------------------------------*/
method analise(oXmlItem) class TeknisaPutComposicao
Local lIntegrado := .F.
Local cCodEx	 := ""
Local cErrorLog  := ""
Local cCodEmp 	 := ""
Local cCodFil 	 := ""
Local cCodProd   := ""
Local cCodTek    := ""
Private oItem 	 := oXmlItem

	//verifica se a propriedade integrado existe
	If type("oItem:_CONFIRMACAO:_INTEGRADO:TEXT") == "C"

		cCodEmp :=IIF(Type("oItem:_FILIAL:_CDEMPRESA:TEXT") == "C",oItem:_FILIAL:_CDEMPRESA:TEXT,"")
		cCodFil :=IIF(Type("oItem:_FILIAL:_CDFILIAL:TEXT")  == "C",oItem:_FILIAL:_CDFILIAL:TEXT ,"")
		cCodProd:=IIF(Type("oItem:_ID:_CODIGOPRODUTO:TEXT") == "C",oItem:_ID:_CODIGOPRODUTO:TEXT,"")
		cCodTek :=IIF(Type("oItem:_ID:_CDPRODUTO:TEXT")     == "C",oItem:_ID:_CDPRODUTO:TEXT    ,"")

		//agora testa se o conteudo é true
		lIntegrado := lower(oItem:_CONFIRMACAO:_INTEGRADO:TEXT) == "true"

		//se integrado OK, verifica se tem a chave para entrar o registro. se não encontrado... não marca como integrado OK
		If lIntegrado
			
			lIntegrado := lIntegrado .And. !Empty(cCodEmp)
			lIntegrado := lIntegrado .And. !Empty(cCodFil)
			lIntegrado := lIntegrado .And. !Empty(cCodProd)
			lIntegrado := lIntegrado .And. !Empty(cCodTek)

			// -> Se o código da empresa do Teknisa não retornou, registra erro no log
			If Empty(cCodEmp)
				cErrorLog:="Nao retornou o codigo da empresa no Teknisa apos a chamada no metodo. [_CDEMPRESA = " + IIF(Empty(cCodEmp),"Vazio",cCodEmp)+"]" 
				::oLog:broken("Retorno do XML.", cErrorLog, .T.)	
				ConOut(cErrorLog)
			EndIf	

			// -> Se o código da filial do Teknisa não retornou, registra erro no log
			If Empty(cCodFil)
				cErrorLog:="Nao retornou o codigo da filial no Teknisa apos a chamada no metodo. [_CDFILIAL = " + IIF(Empty(cCodFil),"Vazio",cCodFil)+"]" 
				::oLog:broken("Retorno do XML.", cErrorLog, .T.)	
				ConOut(cErrorLog)
			EndIf	

			// -> Se o código do produto do Teknisa não retornou, registra erro no log
			If Empty(cCodTek)
				cErrorLog:="Nao retornou o codigo produto no Teknisa apos a chamada no metodo. [_CODIGOPRODUTO = " + IIF(Empty(cCodTek),"Vazio",cCodTek)+"]" 
				::oLog:broken("Retorno do XML.", cErrorLog, .T.)	
				ConOut(cErrorLog)
			EndIf	
			
			// -> Se o código do produto do Protheus não retornou, registra erro no log
			If Empty(cCodProd)
				cErrorLog:="Nao retornou o codigo do produto no Protheus apos a chamada no metodo. [_CDPRODUTO = " + IIF(Empty(cCodProd),"Vazio",cCodProd)+"]" 
				::oLog:broken("Retorno do XML.", cErrorLog, .T.)	
				ConOut(cErrorLog)
			EndIf	
		
		EndIf
	
	EndIf

	If lIntegrado

		cErrorLog:=": "+AllTrim(oItem:_ID:_CODIGOPRODUTO:TEXT)+": Atualizando status no ERP..." 
		::oLog:SetAddInfo("Retorno dos dados.",cErrorLog)
		ConOut(cErrorLog)

		dbSelectArea("Z14")
		Z14->( dbSetOrder(1) )
		Z14->( dbSeek( xFilial("Z14") + oItem:_ID:_CODIGOPRODUTO:TEXT ))

		lIntegrado := Z14->( Found() )

		If lIntegrado

			recLock("Z14", .F.)
			Z14->Z14_XCODEX := oItem:_ID:_CDPRODUTO:TEXT 
			Z14->Z14_XEMP   := oItem:_FILIAL:_CDEMPRESA:TEXT
			Z14->Z14_XFIL   := oItem:_FILIAL:_CDFILIAL:TEXT
			Z14->Z14_XSTINT := "I" 
			Z14->Z14_XDINT  := Date()
			Z14->Z14_XHINT  := Time()
			Z14->( msUnLock() )
			::oEventLog:setCountInc()

			cErrorLog:="Ok." 
			::oLog:SetAddInfo("Retorno dos dados.",cErrorLog)
			ConOut(cErrorLog)

		Else

			cErrorLog:="Erro."
			::oLog:SetAddInfo("Retorno dos dados.",cErrorLog)
			ConOut(cErrorLog)
				
		EndIf

	Else

		cErrorLog:="Nao foi posivel concluir a integracao da composicao, verifique o XML retornado. [_CODIGOPRODUTO="+IIF(Empty(cCodProd),"Vazio",cCodProd)+" e _CDPRODUTO="+IIF(Empty(cCodTek),"Vazio",cCodTek)+"]" 
		::oLog:broken("Erro no processo de integracao.", cErrorLog, .T.)	
		ConOut("Erro: "+cErrorLog)
		
	EndIf

return


/*-----------------+---------------------------------------------------------+
!Nome              ! makeXml                                                 !
+------------------+---------------------------------------------------------+
!Descrição         ! Metodo para gerar o XML de envio                        !
+------------------+---------------------------------------------------------+
!Autor             ! Mario L. B. Faria                                       !
+------------------+---------------------------------------------------------!
!Data              ! 25/05/2018                                              !
+------------------+--------------------------------------------------------*/
method makeXml(aLote,cMetEnv) class TeknisaPutComposicao
Local cXml
Local nC
Local cCodExt	:= ""    
Local cCodEx 	:= "" 
Local cCodEmp	:= ""
Local cCodExtAux:= ""    
Local cErrorLog := ""
Local lErroXML  := .F.
Local cFilSG1	:= xFilial("SG1")
	
	cErrorLog:=": Gerando XML..." 
	::oLog:SetAddInfo(cErrorLog,"Gerando XML...")
	ConOut(cErrorLog)
	
	dbSelectArea("SG1")
	SG1->( dbSetOrder(1) )

	dbSelectArea("SB1")
	SB1->( dbSetOrder(1) )
	
	dbSelectArea("Z14")
	Z14->( dbSetOrder(1) )
	
	dbSelectArea("Z13")
	Z13->( dbSetOrder(1) )
	
	cXml := '<estruturas>'

	For nC := 1 to len(aLote)
	
		lErroXML :=.F.
		If Lower(cMetEnv) != "delete"
		
			// -> Posiciona na tabela de composições a integrar
			Z14->( dbGoTo(aLote[nC,02]) )
			If Z14->(Eof()) 
				lErroXML :=.T.
				cErrorLog:="Erro: Produto com RECNO " + AllTrim(Str(aLote[nC,02])) + " nao encontrado na Z14." 
				::oLog:broken("Erro na geracao do XML.", cErrorLog, .F.)	
				ConOut(cErrorLog)						
			Else
				// -> Posiciona no cadastro do produto
				cCodExtAux:=Z14->Z14_XCODEX
				SB1->(DbGoTop())
				SB1->(dbSeek(xFilial("SB1") + Z14->Z14_COD))
				If !SB1->(Found()) 
					lErroXML :=.T.
					cErrorLog:="Erro: Codigo do produto  " + AllTrim(Z14->Z14_COD) + " nao encontrado na tabela SB1." 
					::oLog:broken("Erro na geracao do XML.", cErrorLog, .F.)	
					ConOut(cErrorLog)
				Else
					// -> Posiciona no cadastro da estrutura do produto
					SG1->(DbGoTop())
					SG1->(dbSeek(xFilial("SG1") + Z14->Z14_COD))
					If !SG1->(Found()) 
						lErroXML :=.T.
						cErrorLog:="Erro: Codigo do produto  " + AllTrim(Z14->Z14_COD) + " nao encontrado na tabela SG1." 
						::oLog:broken("Erro na geracao do XML.", cErrorLog, .F.)	
						ConOut(cErrorLog)
					Else
						// -> Verifica dados da estrutura do produto
						While !SG1->(Eof()) .and. SG1->G1_FILIAL == cFilSG1 .and. SG1->G1_COD == Z14->Z14_COD
							// -> Posiciona no produto da composição
							SB1->(DbGoTop())
							SB1->(DbSeek(xFilial("SB1")+SG1->G1_COMP))
							If !SB1->(Found())
								lErroXML :=.T.
								cErrorLog:="Erro: Codigo do produto  " + AllTrim(SG1->G1_COD) + " nao encontrado na tabela SB1." 
								::oLog:broken("Erro na geracao do XML.", cErrorLog, .F.)	
								ConOut(cErrorLog)
							Else
								// -> Posiciona no relacionamento do produto do Protheus x Teknisa
								Z13->(DbGoTop())
								Z13->(dbSeek(xFilial("Z13")+SG1->G1_COMP))
								If !Z13->(Found())
									If !Empty(SB1->B1_XCODEXT)
										Reclock("Z13",.T.)
										Z13->Z13_FILIAL		:= xFilial("Z13")
										Z13->Z13_XFILI		:= SB1->B1_FILIAL
										Z13->Z13_COD		:= SB1->B1_COD
										Z13->Z13_DESC       := SB1->B1_DESC
										Z13->Z13_XSTINT		:= "I"
										Z13->Z13_XEXC		:= "N"
										Z13->Z13_XCDARV		:= SB1->B1_XN1 + SB1->B1_XN2 + SB1->B1_XN3 + SB1->B1_XN4
										Z13->Z13_XEMP		:= ""
										Z13->Z13_XFIL		:= ""
										Z13->Z13_XDINT		:= Date()
										Z13->Z13_XHINT		:= Time()
										Z13->Z13_XCODEX		:= SB1->B1_XCODEXT
										Z13->(MsUnlock())
									Else
										Reclock("Z13",.T.)
										Z13->Z13_FILIAL		:= xFilial("Z13")
										Z13->Z13_XFILI		:= SB1->B1_FILIAL
										Z13->Z13_COD		:= SB1->B1_COD
										Z13->Z13_DESC       := SB1->B1_DESC
										Z13->Z13_XSTINT		:= "P"
										Z13->Z13_XEXC		:= "N"
										Z13->Z13_XCDARV		:= SB1->B1_XN1 + SB1->B1_XN2 + SB1->B1_XN3 + SB1->B1_XN4
										Z13->Z13_XEMP		:= ""
										Z13->Z13_XFIL		:= ""
										Z13->(MsUnlock())
										lErroXML :=.T.
										cErrorLog:="Erro: Codigo de relacionamento entre o produto do Teknisa e Protheus invalido. Verifique se o produto foi integrado ja foi integrdo com o Teknisa. [Z13_COD="+AllTrim(Z13->Z13_COD)+" e Z13_XCODEX=Vazio]" 
										::oLog:broken("Erro na geracao do XML.", cErrorLog, .F.)	
										ConOut(cErrorLog)
									EndIf
									// lErroXML :=.T.
									// cErrorLog:="Erro: Produto nao encontrado no cadastro de relacionamento de produtos do Teknisa e Protheus. [Z13_COD="+AllTrim(SG1->G1_COMP)+"]" 
									// ::oLog:broken("Erro na geracao do XML.", cErrorLog, .F.)	
									// ConOut(cErrorLog)
								ElseIf AllTrim(Z13->Z13_XCODEX) == ""
									lErroXML :=.T.
									cErrorLog:="Erro: Codigo de relacionamento entre o produto do Teknisa e Protheus invalido. Verifique se o produto foi integrado ja foi integrdo com o Teknisa. [Z13_COD="+AllTrim(Z13->Z13_COD)+" e Z13_XCODEX=Vazio]" 
									::oLog:broken("Erro na geracao do XML.", cErrorLog, .F.)	
									ConOut(cErrorLog)
								EndIf							
							EndIf
							SG1->(DbSkip())
						EndDo
					EndIf
				EndIf
				// -> Verifica se a empresa e filial do Teknsa foram preenchidos
				If Empty(Z14->Z14_XEMP) .or. Empty(Z14->Z14_XFIL)
					// -> Pesquisa no cadastro de empresas
					ADK->(DbOrderNickName("ADKXFILI"))
					ADK->(DbSeek(xFilial("ADK")+cFilAnt))
					If !ADK->(Found())
						lErroXML :=.T.
						cErrorLog:="Erro: Empresa e/ou filial do Teknisa nao encontrado(s) no cadastro de unidades de negocio. [ADK_XEMP="+IIF(Empty(Z14->Z14_XEMP),"Vazio",Z14->Z14_XEMP)+" e ADK_XFIL="+IIF(Empty(Z14->Z14_XFIL),"Vazio",Z14->Z14_XFIL)+"]" 
						::oLog:broken("Erro na geracao do XML.", cErrorLog, .F.)	
						ConOut(cErrorLog)
					ElseIf Empty(ADK->ADK_XEMP) .or. Empty(ADK->ADK_XFIL)
						lErroXML :=.T.
						cErrorLog:="Erro: Empresa e/ou filial do Teknisa nao foram preenchidos no cadastro de unidades de negocio. [ADK_XEMP="+IIF(Empty(ADK->ADK_XEMP),"Vazio",ADK->ADK_XEMP)+" e ADK_XFIL="+IIF(Empty(ADK->ADK_XFIL),"Vazio",ADK->ADK_XFIL)+"]" 
						::oLog:broken("Erro na geracao do XML.", cErrorLog, .F.)	
						ConOut(cErrorLog)
					Else
						cCodEmp:=ADK->ADK_XEMP
						cCodFil:=ADK->ADK_XFIL		
					EndIf			
				EndIf			
				cCodEmp	  :=Z14->Z14_XEMP
				cCodFil   :=Z14->Z14_XFIL
			EndIf
		
			// -> Se nao ocorreu erro, gera o XML
			If !lErroXML

				// -> Reposiciona no cadastro de produtos x fornecedor
				SB1->(DbGoTop())
				SB1->(dbSeek(xFilial("SB1") + Z14->Z14_COD))
				
				// -> Reposiciona no cadastro de estrutura de produtos 
				SG1->(DbGoTop())
				SG1->(dbSeek(xFilial("SG1") + Z14->Z14_COD))
				
				cXml += '<estrutura>'
	
				cXml += '<id'
				cXml +=	::tag('cdproduto'		,cCodExtAux) 								
				cXml += ::tag('nmprodut'		,SB1->B1_DESC)						
				cXml += ::tag('codigoproduto'	,SB1->B1_COD)						
				cXml += '/>'
	
				cXml += '<insumos>'
			
				While !SG1->(Eof()) .and. SG1->G1_FILIAL == cFilSG1 .and. SG1->G1_COD == Z14->Z14_COD
			
					cCodExt := ""
					Z13->(dbSeek(xFilial("Z13") + SG1->G1_COMP))	
					cCodExt := Z13->Z13_XCODEX
			
					SB1->(dbSeek(xFilial("SB1") + SG1->G1_COMP))
			
					cXml += '<insumo'
					cXml += ::tag('cdsubproduto'	,cCodExt)
					cXml += ::tag('codigoproduto'	,SG1->G1_COMP)
					cXml += ::tag('nmprodut'		,SB1->B1_DESC)
					cXml += ::tag('tipo'			,SB1->B1_TIPO)
					cXml += ::tag('sunidade'		,SB1->B1_UM)
					cXml += ::tag('quantidade'		,SG1->G1_QUANT		,"decimal")
					cXml += '/>'
			
					SG1->(DbSkip())
				
				EndDo
	
				cXml += '</insumos>'
	
				cXml += '<empresas>'
			
				cXml += '<filial' 
				cXml += ::tag('cdempresa'	,cCodEx)
				cXml += ::tag('cdfilial'	,cCodFil)
				cXml += ::tag('filial'		,Z14->Z14_FILIAL) 
				cXml += ::tag('nmfilial'	,SM0->M0_FILIAL)
				cXml += '/>'
			
				cXml += '</empresas>'
	
				cXml += '</estrutura>'
				
			EndIf	
		
		Else
			Z14->( dbGoTo(aLote[nC,02]) )
			
			// -> Reposiciona no cadastro de produtos x fornecedor
			SB1->(DbGoTop())
			SB1->(dbSeek(xFilial("SB1") + Z14->Z14_COD))
			
			
			cXml += '<estrutura>'
	
			cXml += '<id'
			cXml +=	::tag('cdproduto'		,Z14->Z14_XCODEX) 								
			cXml += ::tag('nmprodut'		,SB1->B1_DESC)						
			cXml += ::tag('codigoproduto'	,SB1->B1_COD)						
			cXml += '/>'
	
			cXml += '<insumos>'
			
			cXml += '<insumo'
			cXml += ::tag('cdsubproduto'	,"")
			cXml += ::tag('codigoproduto'	,"")
			cXml += ::tag('nmprodut'		,"")
			cXml += ::tag('tipo'			,"")
			cXml += ::tag('sunidade'		,"")
			cXml += ::tag('quantidade'		,0		,"decimal")
			cXml += '/>'
	
			cXml += '</insumos>'
	
			cXml += '<empresas>'
			
			cXml += '<filial' 
			cXml += ::tag('cdempresa'	,Z14->Z14_XEMP)
			cXml += ::tag('cdfilial'	,Z14->Z14_XFIL)
			cXml += ::tag('filial'		,Z14->Z14_FILIAL) 
			cXml += ::tag('nmfilial'	,SM0->M0_FILIAL)
			cXml += '/>'
			
			cXml += '</empresas>'
	
			cXml += '</estrutura>'
			
		EndIf

 	Next nC

	cXml += '</estruturas>'
	
	If AllTrim(cXml) == "<estruturas></estruturas>"
		cXml:=""
	EndIf
	
	MemoWrite("C:\TEMP\XML_" + cMetEnv + ".XML",cXml)

return cXml