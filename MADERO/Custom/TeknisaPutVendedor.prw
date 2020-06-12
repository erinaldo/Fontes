#include 'protheus.ch'
/*-----------------+---------------------------------------------------------+
!Nome              ! TkPutVend                                               !
+------------------+---------------------------------------------------------+
!Descrição         ! Função para chamr o metodo PutVendedor via Menu         !
+------------------+---------------------------------------------------------+
!Autor             ! Mario L. B. Faria                                       !
+------------------+---------------------------------------------------------!
!Data              ! 25/05/2018                                              !
+------------------+--------------------------------------------------------*/
user function TkPutVend(lBatch)
Private cPerg := padr("TPMETODO",10)
Default lBatch:= .F.
	
    // -> Se não for executado por job
    If !lBatch
 		U_CRSX01MD()
		if !Pergunte(cPerg,.T.)
			Return .F.
		EndIf
	
		Do Case
			Case MV_PAR01 = 1
				TkVend("Post")
			Case MV_PAR01 = 2
				TkVend("Put")
			Case MV_PAR01 = 3
				TkVend("Delete")
		EndCase
	EndIf
	
	// -> Se for executado por job
    If lBatch
 		// -> Executa o processo de inclusão de vendedores 
 		TkVend("Post")       
 		// -> Executa o processo de alteração de vendedores 
 		TkVend("Put")
 		// -> Executa o processo de exclusao de vendedores 
		TkVend("Delete")                 		
 	EndIf			

Return



/*-----------------+---------------------------------------------------------+
!Nome              ! TkVend                                                  !
+------------------+---------------------------------------------------------+
!Descrição         ! Função para processar o WS                              !
+------------------+---------------------------------------------------------+
!Autor             ! Mario L. B. Faria                                       !
+------------------+---------------------------------------------------------!
!Data              ! 25/05/2018                                              !
+------------------+--------------------------------------------------------*/
Static Function TkVend(cMetEnv)
Local oIntegra
Local cMethod	:= "PutVendedor"
Local cAlias	:= "Z15"
Local cAlRot	:= "SA3"
Local oEventLog := EventLog():start("Vendedores - "+AllTrim(cMetEnv), Date(), "Iniciando processo de integracao...", cMetEnv, cAlRot) 
	
	//instancia a classe
	oIntegra := TeknisaPutVendedor():new(cMethod, cMetEnv, cAlias, cAlRot, oEventLog)

	//se estiver ativo
	If oIntegra:isEnable()

		//busca os registros e se sequencia em lotes
		oIntegra:prepare()

		oIntegra:send()

	EndIf
	
	oEventLog:Finish()

return



/*-----------------+---------------------------------------------------------+
!Nome              ! TeknisaPutVendedor                                      !
+------------------+---------------------------------------------------------+
!Descrição         ! Classe PutVendedor                                      !
+------------------+---------------------------------------------------------+
!Autor             ! Mario L. B. Faria                                       !
+------------------+---------------------------------------------------------!
!Data              ! 25/05/2018                                              !
+------------------+--------------------------------------------------------*/
class TeknisaPutVendedor from TeknisaMethodAbstract
Data oLog
Data cMetE

	method new() constructor
	method makeXml(aLote,cMetEnv)
	method analise(oXmlItem)
	method fetch()

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
method new(cMethod, cMetEnv, cAlias, cAlRot, oEventLog) class TeknisaPutVendedor

	//inicialisa a classe
	::init(cMethod, cMetEnv, cAlias, cAlRot, oEventLog)
	::oLog :=oEventLog
	::cMetE:=cMetEnv

return



/*-----------------+---------------------------------------------------------+
!Nome              ! fetch                                                   !
+------------------+---------------------------------------------------------+
!Descrição         ! Metodo para a seleção dos dados a enviar                !
+------------------+---------------------------------------------------------+
!Autor             ! Mario L. B. Faria                                       !
+------------------+---------------------------------------------------------!
!Data              ! 25/05/2018                                              !
+------------------+--------------------------------------------------------*/
method fetch() class TeknisaPutVendedor
Local cQuery	:= ''
Local cPreRot	:= If(Len(PrefixoCpo(::cAlRot)) == 2,"S" + PrefixoCpo(::cAlRot), PrefixoCpo(::cAlRot))
Local cPreAli	:= If(Len(PrefixoCpo(::cAlias)) == 2,"S" + PrefixoCpo(::cAlias), PrefixoCpo(::cAlias))
Local cErrorLog := ""

	cErrorLog:=": Selecionando vendedores..." 
	::oLog:SetAddInfo(cErrorLog,"Selecionando dados...")
	ConOut(cErrorLog)

	cQuery += "	SELECT " + CRLF
	cQuery += "		" + cPreRot + ".R_E_C_N_O_ ROT_REG, " + CRLF	//Recno da tabela Principal
	cQuery += "		" + cPreAli + ".R_E_C_N_O_ ALI_REG " + CRLF		//Recno da tabela Auxiliar
	
	cQuery += "	FROM " + RetSqlName(::cAlias) + " " + cPreAli + " " + CRLF
	
	cQuery += "	LEFT JOIN " + RetSqlName(::cAlRot) + " " + cPreRot + " ON "                         + CRLF
	cQuery += "	 		  " + PrefixoCpo(::cAlRot) + "_FILIAL = '" + xFilial(::cAlRot)    + "' "    + CRLF
	cQuery += "		  AND " + PrefixoCpo(::cAlRot) + "_COD    = "  + PrefixoCpo(::cAlias) + "_COD " + CRLF
	cQuery += "		  AND " + cPreRot + ".D_E_L_E_T_ = ' ' " + CRLF
	
	cQuery += "	WHERE  " + CRLF
	cQuery += "			" + PrefixoCpo(::cAlias) + "_FILIAL = '" + xFilial(::cAlias) + "' " + CRLF
	
	If Upper(::cMetEnv) == "POST"
		cQuery += "		AND " + PrefixoCpo(::cAlias) + "_XSTINT = 'P' " + CRLF
		cQuery += "		AND " + PrefixoCpo(::cAlias) + "_XDINT  = ' ' " + CRLF
		cQuery += "		AND " + PrefixoCpo(::cAlias) + "_XEXC  != 'S' " + CRLF
	ElseIf Upper(::cMetEnv) == "PUT"
		cQuery += "		AND " + PrefixoCpo(::cAlias) + "_XSTINT = 'P' " + CRLF
		cQuery += "		AND " + PrefixoCpo(::cAlias) + "_XDINT != ' ' " + CRLF
		cQuery += "		AND " + PrefixoCpo(::cAlias) + "_XEXC  != 'S' " + CRLF
	ElseIf Upper(::cMetEnv) == "DELETE"
		cQuery += "		AND " + PrefixoCpo(::cAlias) + "_XSTINT = 'P' " + CRLF
		cQuery += "		AND " + PrefixoCpo(::cAlias) + "_XEXC   = 'S' " + CRLF
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
method analise(oXmlItem) class TeknisaPutVendedor

Local lIntegrado:= .F.
Local cCodVend 	:= ""
Local cErrorLog := ""
Private oItem   := oXmlItem

	//verifica se a propriedade integrado existe
	If type("oItem:_CONFIRMACAO:_INTEGRADO:TEXT") == "C"
		
		cCodVend:=IIF(type("oItem:_ID:_CDVENDEDOR:TEXT"   ) == "C",oItem:_ID:_CDVENDEDOR:TEXT,""   )

		//agora testa se o conteudo é true
		lIntegrado := lower(oItem:_CONFIRMACAO:_INTEGRADO:TEXT) == "true"

		//se integrado OK, verifica se tem a chave para entrar o registro. Se não encontrado... não marca como integrado OK
		If lIntegrado

			lIntegrado := lIntegrado .And. !Empty(cCodVend)

			// -> Se o codigo do recebimento nao retornou no XML, registra erro no log
			If Empty(cCodVend)
				cErrorLog:="Nao retornou o codigo de vendedor no Teknisa apos a chamada no metodo. [_CDVENDEDOR = " + IIF(Empty(cCodVend),"Vazio",cCodVend)+"]" 
				::oLog:broken("Retorno do XML.", cErrorLog, .T.)	
				ConOut(cErrorLog)
			EndIf	

		EndIf

	EndIf

	If lIntegrado

		cErrorLog:=": "+AllTrim(oItem:_ID:_CDVENDEDOR:TEXT)+": Atualizando status no ERP..." 
		::oLog:SetAddInfo("Retorno dos dados.",cErrorLog)
		ConOut(cErrorLog)

		//tabela de vendedores
		dbSelectArea("Z15")
		Z15->( dbSetOrder(1) )
		Z15->( dbSeek( xFilial("Z15") + oItem:_ID:_CODIGO:TEXT ))
		lIntegrado := Z15->( Found() )

		If lIntegrado

			recLock("Z15", .F.)
			Z15->Z15_XSTINT := "I" //Integrado
			Z15->Z15_XVEND	:= oItem:_ID:_CDVENDEDOR:TEXT
			Z15->Z15_XDINT  := Date()
			Z15->Z15_XHINT  := Time()
			Z15->( msUnLock() )
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
	
		cErrorLog:="Nao foi posivel concluir a integracao do vendedor, verifique o XML retornado. [_CDVENDEDOR="+IIF(Empty(cCodVend),"Vazio",cCodVend)+"]" 
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
method makeXml(aLote,cMetEnv) class TeknisaPutVendedor
Local cXml
Local nC
Local cErrorLog := ""
Local lErroXML  := .F.
	
	cErrorLog:=": Gerando XML..." 
	::oLog:SetAddInfo(cErrorLog,"Gerando XML...")
	ConOut(cErrorLog)
	
	cXml := '<vendedores>'
	
	For nC := 1 to len(aLote)

		lErroXML:=.F.
		// posiciona no produto
		SA3->(dbGoTo(aLote[nC,01]))
		
		Z15->( dbGoTo(aLote[nC,02]) )
		
		If cMetEnv != "DELETE"

			cXml += '<vendedor>'

			cXml += '<id'
			cXml += ::tag('codigo'			,Z15->Z15_COD)
			cXml += ::tag('cdvendedor'		,Z15->Z15_XVEND)
			cXml += '/>'

			cXml += '<cadastral'
			cXml += ::tag('nmrazsocial'		,SA3->A3_NOME) 
			cXml += ::tag('nmfanven'		,SA3->A3_NREDUZ)  
			cXml += ::tag('endereco'		,SA3->A3_END)  
			cXml += ::tag('bairro'			,SA3->A3_BAIRRO)
			cXml += ::tag('municipio'		,SA3->A3_MUN) 
			cXml += ::tag('uf'				,SA3->A3_EST) 
			cXml += ::tag('cep'				,SA3->A3_CEP)
			cXml += ::tag('ddd'				,SA3->A3_DDDTEL)
			cXml += ::tag('telefone'		,SA3->A3_TEL)  
			cXml += ::tag('tipo'			,SA3->A3_TIPO) 
			cXml += ::tag('cgc'				,SA3->A3_CGC)
			cXml += ::tag('increst'			,SA3->A3_INSCR)
			cXml += ::tag('email'			,SA3->A3_EMAIL)  
			cXml += ::tag('codigousr'		,SA3->A3_CODUSR) 
			cXml += ::tag('supervisor'		,SA3->A3_SUPER)
			cXml += ::tag('gerente'			,SA3->A3_GEREN) 
			cXml += ::tag('codfunc'			,SA3->A3_NUMRA) 
			cXml += ::tag('codforn'			,SA3->A3_FORNECE) 
			cXml += ::tag('lojaforn'		,SA3->A3_LOJA) 
			cXml += ::tag('ativo'			,If(SA3->A3_MSBLQL == "1","N","S")) 
			cXml += '/>'

			cXml += '</vendedor>'
			
		Else
		
			// -> Verifica se o vendedor já foi integrado no Teknisa
			If Empty(Z15->Z15_XVEND) 
				lErroXML:=.T.
				cErrorLog:="Vendedor ainda nao integrado com o Teknisa. Favor verificar o codigo do vendedor relacionado ao Tknisa na tabela Z15. [Z15_XVEND=Vazio]" 
				::oLog:broken("Erro na geracao do XML.", cErrorLog, .T.)	
				ConOut("Erro: "+cErrorLog)	
			EndIf

			// -> Se não ocorreu erro, gera o XML
			If !lErroXML
			
				cXml += '<vendedor>'

				cXml += '<id'
				cXml += ::tag('codigo'			,Z15->Z15_COD)
				cXml += ::tag('cdvendedor'		,Z15->Z15_XVEND)
				cXml += '/>'

				cXml += '<cadastral'
				cXml += ::tag('nmrazsocial'		,SA3->A3_NOME) 
				cXml += ::tag('nmfanven'		,SA3->A3_NREDUZ)  
				cXml += ::tag('endereco'		,SA3->A3_END)  
				cXml += ::tag('bairro'			,SA3->A3_BAIRRO)
				cXml += ::tag('municipio'		,SA3->A3_MUN) 
				cXml += ::tag('uf'				,SA3->A3_EST) 
				cXml += ::tag('cep'				,SA3->A3_CEP)
				cXml += ::tag('ddd'				,SA3->A3_DDDTEL)
				cXml += ::tag('telefone'		,SA3->A3_TEL)  
				cXml += ::tag('tipo'			,SA3->A3_TIPO) 
				cXml += ::tag('cgc'				,SA3->A3_CGC)
				cXml += ::tag('increst'			,SA3->A3_INSCR)
				cXml += ::tag('email'			,SA3->A3_EMAIL)  
				cXml += ::tag('codigousr'		,SA3->A3_CODUSR) 
				cXml += ::tag('supervisor'		,SA3->A3_SUPER)
				cXml += ::tag('gerente'			,SA3->A3_GEREN) 
				cXml += ::tag('codfunc'			,SA3->A3_NUMRA) 
				cXml += ::tag('codforn'			,SA3->A3_FORNECE) 
				cXml += ::tag('lojaforn'		,SA3->A3_LOJA) 
				cXml += ::tag('ativo'			,If(SA3->A3_MSBLQL == "1","N","S")) 
				cXml += '/>'
			
			EndIf	
				
		EndIf	

 	Next nC

	cXml += '</vendedores>'                            

	If AllTrim(cXml) == "<vendedores></vendedores>"
		cXml:=""
	EndIf	
		
	MemoWrite("C:\TEMP\XML_" + cMetEnv + ".XML",cXml)

return cXml