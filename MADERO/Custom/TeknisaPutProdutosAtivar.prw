#include 'protheus.ch'
/*-----------------+---------------------------------------------------------+
!Nome              ! TkPutPAt                                                !
+------------------+---------------------------------------------------------+
!Descrição         ! Função para chamr o metodo PutProdutosAtivar            !
+------------------+---------------------------------------------------------+
!Autor             ! Rafael Vieceli                                          !
+------------------+---------------------------------------------------------!
!Data              ! 25/05/2018                                              !
+------------------+--------------------------------------------------------*/
User Function TkPutPAt(lBatch)
Private cPerg := padr("TPMETODO",10)
Default lBatch:= .F.

    // -> Se não for executado por job
	If! lBatch
		if !Pergunte(cPerg,.T.)
			Return .F.
		EndIf
	
		Do Case
			Case MV_PAR01 = 1
				TkPAti("Post")			
			Case MV_PAR01 = 2
				Alert("Opção não disponivel para este método")			
			Case MV_PAR01 = 3
				TkPAti("Delete")	
		EndCase
	EndIf
	
    // -> Se não for executado por job
	If lBatch
 		// -> Executa o processo para ativação de produtos
		TkPAti("Post")
 		// -> Executa o processo para desativar produtos
		TkPAti("Delete")
	EndIf	

Return


/*-----------------+---------------------------------------------------------+
!Nome              ! TkImp                                                   !
+------------------+---------------------------------------------------------+
!Descrição         ! Função para processar o WS                              !
+------------------+---------------------------------------------------------+
!Autor             ! Rafael Vieceli                                          !
+------------------+---------------------------------------------------------!
!Data              ! 25/05/2018                                              !
+------------------+--------------------------------------------------------*/
Static Function TkPAti(cMetEnv)
Local oIntegra
Local cMethod	:= "PutProdutosAtivar"
Local cAlias	:= "Z17"
Local cAlRot	:= "SB1" 
Local oEventLog := EventLog():start("Ativar Produto - "+AllTrim(cMetEnv), Date(), "Iniciando processo de integracao...", cMetEnv, cAlRot) 

	//instancia a classe
	oIntegra := TeknisaPutProdutosAtivar():new(cMethod, cMetEnv, cAlias, cAlRot, oEventLog)

	//se estiver ativo
	If oIntegra:isEnable()

		//busca os registros e se sequencia em lotes
		oIntegra:prepare()

		oIntegra:send()

	EndIf
	
	oEventLog:Finish()

return



/*-----------------+---------------------------------------------------------+
!Nome              ! PutProdutosAtivar                                       !
+------------------+---------------------------------------------------------+
!Descrição         ! Classe PutProdutosAtivar                                !
+------------------+---------------------------------------------------------+
!Autor             ! Rafael Vieceli                                          !
+------------------+---------------------------------------------------------!
!Data              ! 25/05/2018                                              !
+------------------+--------------------------------------------------------*/
class TeknisaPutProdutosAtivar from TeknisaMethodAbstract
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
!Autor             ! Rafael Vieceli                                          !
+------------------+---------------------------------------------------------!
!Data              ! 25/05/2018                                              !
+------------------+--------------------------------------------------------*/
method new(cMethod, cMetEnv, cAlias, cAlRot, oEventLog) class TeknisaPutProdutosAtivar

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
!Autor             ! Rafael Vieceli                                          !
+------------------+---------------------------------------------------------!
!Data              ! 25/05/2018                                              !
+------------------+--------------------------------------------------------*/
method fetch() class TeknisaPutProdutosAtivar
Local cQuery	:= ''

	cQuery += "	SELECT " + CRLF
	cQuery += "		SB1.R_E_C_N_O_ ROT_REG, " + CRLF 
	cQuery += "		Z17.R_E_C_N_O_ ALI_REG  " + CRLF
	cQuery += "	FROM " + RetSqlName("Z17") + " Z17 " + CRLF 
	cQuery += "	LEFT JOIN " + RetSqlName("SB1") + " SB1 ON " + CRLF  
	cQuery += "			B1_FILIAL = '" + xFilial("SB1") + "' " + CRLF  
	cQuery += "		AND B1_COD    = Z17_COD  " + CRLF 
	cQuery += "		AND SB1.D_E_L_E_T_ = ' ' " + CRLF  
	cQuery += "	WHERE  " + CRLF 
	cQuery += "			Z17_FILIAL = '" + xFilial(::cAlias) + "' " + CRLF 
	cQuery += "		AND Z17_XSTINT = 'P' " + CRLF
	
	If Upper(::cMetEnv) == "POST"
		cQuery += "		AND Z17_XATIVO <> 'N' " + CRLF
		cQuery += "		AND B1_MSBLQL  <> '1' " + CRLF
		
	ElseIf Upper(::cMetEnv) == "DELETE"
		cQuery += "		AND Z17_XATIVO <> 'S' " + CRLF
		cQuery += "		AND B1_MSBLQL   = '1' " + CRLF
	EndIf
	
	cQuery += "		AND Z17.D_E_L_E_T_ = ' '  " + CRLF

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
method analise(oXmlItem) class TeknisaPutProdutosAtivar
Local lIntegrado := .F.
Local cErrorLog  := ""
Local cCodEmp    := ""
Local cCodFil    := ""
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

		//se integrado OK, verifica se tem a chave para entrar o registro. Se não encontrado... não marca como integrado OK
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
		
		//tabela de produtos
		dbSelectArea("Z17")
		
		//busca pelo indice customizado
		Z17->( dbSetOrder(1) )
		Z17->( dbSeek( xFilial("Z17") + oItem:_ID:_CODIGOPRODUTO:TEXT ))

		lIntegrado := Z17->(Found())

		If lIntegrado

			RecLock("Z17", .F.)
			Z17->Z17_XEMP       := oItem:_FILIAL:_CDEMPRESA:TEXT
			Z17->Z17_XFIL       := oItem:_FILIAL:_CDFILIAL:TEXT
			Z17->Z17_XCODEX		:= oItem:_ID:_CDPRODUTO:TEXT
			Z17->Z17_XSTINT		:= "I" //Integrado
			Z17->Z17_XDINT		:= Date()
			Z17->Z17_XHINT		:= Time()
			Z17->(msUnLock())
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
	
		cErrorLog:="Nao foi poivel "+IIF(Upper(::cMetEnv) == "POST","ativar","desativar")+" o(s) produto(s), verifique o XML retornado. [_CODIGOPRODUTO="+IIF(Empty(cCodProd),"Vazio",cCodProd)+" e _CDPRODUTO="+IIF(Empty(cCodTek),"Vazio",cCodTek)+"]" 
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
method makeXml(aLote,cMetEnv) class TeknisaPutProdutosAtivar
Local cXml
Local nC
Local cCodEx	:= ""
Local cCodEmp   := ""
Local cCodFil   := ""
Local cErrorLog := ""
Local lErroXML  := .F.

	cErrorLog:=": Gerando XML..." 
	::oLog:SetAddInfo(cErrorLog,"Gerando XML...")
	ConOut(cErrorLog)

	dbSelectArea("Z17")
	Z17->(dbSetOrder(1))
	
	cXml 	:= '<produtos>'    	
	lErroXML:= .F.
	For nC := 1 to len(aLote)
		
		lErroXML:= .F.		
		Z17->(dbGoTo(aLote[nC,02]))
		If Z17->(Eof()) 
			lErroXML :=.T.
			cErrorLog:="Erro: Produto com RECNO " + AllTrim(Str(aLote[nC,01])) + " nao encontrado na Z17." 
			::oLog:broken("Erro na geracao do XML.", cErrorLog, .F.)	
			ConOut(cErrorLog)
		ElseIf AllTrim(Z17->Z17_XCODEX) == "" 
			// -> Posiciona no cadastro de relacionamento Protheus x Teknisa
			Z13->(DbSetOrder(1))
			If Z13->(DbSeek(xFilial("Z13")+Z17->Z17_COD))
				cCodEx:=Z13->Z13_XCODEX
			Else
				cCodEx	 :=""
				lErroXML :=.T.
				cErrorLog:="Erro: Nao ha codigo de relacionamento do produto com o Teknisa. Verifique se o projeto ja foi integrado. [Z17_COD="+AllTrim(Z17->Z17_COD)+" e Z17_XCODEX=Vazio]" 
				::oLog:broken("Erro na geracao do XML.", cErrorLog, .F.)	
				ConOut(cErrorLog)			
			EndIf
			// -> Posiciona no cadastro de produtos
			SB1->(DbSetOrder(1))
			SB1->(DbSeek(xFilial("SB1")+Z17->Z17_COD))
			If !SB1->(Found()) 
				lErroXML :=.T.
				cErrorLog:="Erro: Produto com código " + IIF(Empty(Z17->Z17_COD),"Vazio",Z17->Z17_COD)+ " nao encontrado na SB1." 
				::oLog:broken("Erro na geracao do XML.", cErrorLog, .F.)	
				ConOut(cErrorLog)
			EndIf
		Else
			// -> Verifica se a empresa e filial do Teknsa foram preenchidos
			cCodEx :=Z17->Z17_XCODEX
			cCodEmp:=Z17->Z17_XEMP
			cCodFil:=Z17->Z17_XFIL					
			If Empty(Z17->Z17_XEMP) .or. Empty(Z17->Z17_XFIL)
				// -> Pesquisa no cadastro de empresas
				ADK->(DbOrderNickName("ADKXFILI"))
				ADK->(DbSeek(xFilial("ADK")+cFilAnt))
				If !ADK->(Found())
					lErroXML :=.T.
					cErrorLog:="Erro: Empresa e/ou filial do Teknisa nao encontrado(s) no cadastro de unidades de negocio. [ADK_XEMP="+IIF(Empty(Z17->Z17_XEMP),"Vazio",Z17->Z17_XEMP)+" e ADK_XFIL="+IIF(Empty(Z17->Z17_XFIL),"Vazio",Z17->Z17_XFIL)+"]" 
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
		EndIf	
		If Empty(cCodEx)
			lErroXML :=.T.
		EndIf
		If !lErroXML 

			cXml += '<produto>'
		
			cXml += '<id'
			cXml += ::tag('cdproduto'		,cCodEx)
			cXml += ::tag('codigoproduto'	,Z17->Z17_COD)
			cXml += '/>'
		
			cXml += '<empresas>'
		
			cXml += '<filial'
			cXml += ::tag('cdempresa'	,cCodEmp)
			cXml += ::tag('cdfilial'	,cCodFil)
			cXml += ::tag('filial'		,Z17->Z17_FILIAL)
			cXml += ::tag('nmfilial'	,SM0->M0_FILIAL)	
			cXml += '/>'

			cXml += '</empresas>'

			cXml += '</produto>'
		
		EndIf	

 	Next nC

	cXml += '</produtos>'
	
	If AllTrim(cXml) == "<produtos></produtos>"
		cXml:=""
	EndIf
		
	MemoWrite("C:\TEMP\XML_" + cMetEnv + ".XML",cXml)

return cXml