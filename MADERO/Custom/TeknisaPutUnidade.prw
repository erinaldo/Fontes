#include 'protheus.ch'
/*-----------------+---------------------------------------------------------+
!Nome              ! TkPutUnid                                               !
+------------------+---------------------------------------------------------+
!Descrição         ! Função para chamr o metodo PutUnidade via Menu          !
+------------------+---------------------------------------------------------+
!Autor             ! Mario L. B. Faria                                       !
+------------------+---------------------------------------------------------!
!Data              ! 25/05/2018                                              !
+------------------+--------------------------------------------------------*/
User Function TkPutUnid(lBatch)
Private cPerg := padr("TPMETODO",10)
Default lBatch:= .F.

    // -> Se nào for executado por job
	If! lBatch

		U_CRSX01MD()
		if !Pergunte(cPerg,.T.)
			Return .F.
		EndIf
	
		Do Case
			Case MV_PAR01 = 1
				TkUnid("Post")
			
			Case MV_PAR01 = 2
				TkUnid("Put")
			
			Case MV_PAR01 = 3
				TkUnid("Delete")
	
		EndCase

	EndIf	

    // -> Se nào for executado por job
	If lBatch
 		// -> Executa o processo de inclusão de unidadesde negócio
		TkUnid("Post")
 		// -> Executa o processo de alteração de unidades de negócio
 		TkUnid("Put")
 		// -> Executa o processo de exclusao de unidades de negócio
 		TkUnid("Delete")
	EndIf	

Return


/*-----------------+---------------------------------------------------------+
!Nome              ! TkUnid                                                  !
+------------------+---------------------------------------------------------+
!Descrição         ! Função para processar o WS                              !
+------------------+---------------------------------------------------------+
!Autor             ! Mario L. B. Faria                                       !
+------------------+---------------------------------------------------------!
!Data              ! 25/05/2018                                              !
+------------------+--------------------------------------------------------*/
Static function TkUnid(cMetEnv)
Local oIntegra
Local cMethod	:= "PutUnidade"
Local cAlias	:= ""
Local cAlRot	:= "ADK" 
Local oEventLog := EventLog():start("Unidades - "+AllTrim(cMetEnv), Date(), "Iniciando processo de integracao...", cMetEnv, cAlRot) 

	//instancia a classe
	oIntegra := TeknisaPutUnidade():new(cMethod, cMetEnv, cAlias, cAlRot, oEventLog)

	//se estiver ativo
	If oIntegra:isEnable()

		//busca os registros e se sequencia em lotes
		oIntegra:prepare()

		oIntegra:send()

	EndIf

	oEventLog:Finish()

return


/*-----------------+---------------------------------------------------------+
!Nome              ! TeknisaPutUnidade                                       !
+------------------+---------------------------------------------------------+
!Descrição         ! Classe PutUnidade                                       !
+------------------+---------------------------------------------------------+
!Autor             ! Mario L. B. Faria                                       !
+------------------+---------------------------------------------------------!
!Data              ! 25/05/2018                                              !
+------------------+--------------------------------------------------------*/
class TeknisaPutUnidade from TeknisaMethodAbstract
Data oLog
Data cMetE

	method new() constructor
	method makeXml(aLote)
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
method new(cMethod, cMetEnv, cAlias, cAlRot, oEventLog) class TeknisaPutUnidade

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
method fetch() class TeknisaPutUnidade
Local cQuery := ''  
Local cErrorLog := ""

	cErrorLog:=": Selecionando unidades de negocio..." 
	::oLog:SetAddInfo(cErrorLog,"Selecionando dados...")
	ConOut(cErrorLog)
	
	cQuery += "	SELECT " + CRLF 
	cQuery += "		R_E_C_N_O_ as ROT_REG, " + CRLF 
	cQuery += "		0 as ALI_REG " + CRLF 
	cQuery += "	FROM " + RetSqlName(::cAlRot) + " " + CRLF
	cQuery += "	WHERE " + CRLF 
	If xFilial(::cAlRot) == "          "
		cQuery += "			ADK_XFILI = '" + cFilAnt + "' " + CRLF
	Else
		cQuery += "			ADK_FILIAL = '" + xFilial(::cAlRot) + "' " + CRLF
	EndIf
	cQuery += "		AND ADK_XSTINT = 'P' " + CRLF
	
	If Upper(::cMetEnv) == "PUT"
		cQuery += "		AND ADK_XDINT  <> ' ' "  + CRLF
		cQuery += "		AND ADK_MSBLQL  != '1' " + CRLF
	ElseIf Upper(::cMetEnv) == "POST"
		cQuery += "		AND ADK_XDINT   = ' ' " + CRLF
		cQuery += "		AND ADK_MSBLQL != '1' " + CRLF
	ElseIf Upper(::cMetEnv) == "DELETE"
		cQuery += "		AND ADK_MSBLQL  = '1' "  + CRLF
	EndIf

	cQuery += "		AND D_E_L_E_T_ = ' ' " + CRLF 

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
method analise(oXmlItem) class TeknisaPutUnidade
Local lIntegrado := .F.
Local cCodEmp 	:= ""
Local cCodFil 	:= ""
Private oItem    := oXmlItem

	//verifica se a propriedade integrado existe
	If type("oItem:_CONFIRMACAO:_INTEGRADO:TEXT") == "C"
		
		cCodEmp:=IIF(type("oItem:_FILIAL:_CDEMPRESA:TEXT") == "C",oItem:_FILIAL:_CDEMPRESA:TEXT,"")
		cCodFil:=IIF(type("oItem:_FILIAL:_CDFILIAL:TEXT" ) == "C",oItem:_FILIAL:_CDFILIAL:TEXT,"" )

		//agora testa se o conteudo é true
		lIntegrado := lower(oItem:_CONFIRMACAO:_INTEGRADO:TEXT) == "true"

		//se integrado OK, verifica se tem a chave para entrar o registro. Se não encontrado... não marca como integrado OK
		If lIntegrado

			lIntegrado := lIntegrado .And. !Empty(cCodEmp)
			lIntegrado := lIntegrado .And. !Empty(cCodFil)

			If UPPER(Self:cMetEnv) == "POST"

				cErrorLog:=": "+AllTrim(oItem:_FILIAL:_FILIAL:TEXT)+": Atualizando status no ERP..." 
				::oLog:SetAddInfo("Retorno dos dados.",cErrorLog)
				ConOut(cErrorLog)

				//tabela de unidades
				dbSelectArea("ADK")

				//busca pelo indice customizado
				ADK->( DBSetOrder(5) )
				ADK->( dbSeek( xFilial("ADK") + oItem:_FILIAL:_FILIAL:TEXT))

				If ADK->(Found())

					RecLock("ADK", .F.)
					ADK->ADK_XSTINT := "I" //Integrado
					ADK->ADK_XDINT  := Date()
					ADK->ADK_XHINT  := Time()
					ADK->ADK_XEMP	:= oItem:_ID:_CDEMPRESA:TEXT
					ADK->ADK_XFIL	:= oItem:_ID:_CDFILIAL:TEXT
					ADK->( msUnLock() )
					::oEventLog:setCountInc()

					cErrorLog:="Ok." 
					::oLog:SetAddInfo("Retorno dos dados.",cErrorLog)
					ConOut(cErrorLog)

				Else
				
					cErrorLog:="Erro."
					::oLog:SetAddInfo("Retorno dos dados.",cErrorLog)
					ConOut(cErrorLog)
						
				EndIf
			// -> Se o código da empresa do Teknisa não retornou, registra erro no log
			ElseIf Empty(cCodEmp)
				cErrorLog:="Nao retornou o codigo da empresa no Teknisa apos a chamada no metodo. [_CDEMPRESA = " + IIF(Empty(cCodEmp),"Vazio",cCodEmp)+"]" 
				::oLog:broken("Retorno do XML.", cErrorLog, .T.)	
				ConOut(cErrorLog)

			// -> Se o código da filial do Teknisa não retornou, registra erro no log
			ElseIf Empty(cCodFil)
				cErrorLog:="Nao retornou o codigo da filial no Teknisa apos a chamada no metodo. [_CDFILIAL = " + IIF(Empty(cCodFil),"Vazio",cCodFil)+"]" 
				::oLog:broken("Retorno do XML.", cErrorLog, .T.)	
				ConOut(cErrorLog)
			EndIf	

		EndIf
	
	EndIf

	If lIntegrado

		cErrorLog:=": "+AllTrim(oItem:_FILIAL:_CDEMPRESA:TEXT)+": "+AllTrim(oItem:_FILIAL:_CDFILIAL:TEXT)+": Atualizando status no ERP..." 
		::oLog:SetAddInfo("Retorno dos dados.",cErrorLog)
		ConOut(cErrorLog)

		//tabela de unidades
		dbSelectArea("ADK")

		//busca pelo indice customizado
		ADK->( dbOrderNickName("ADKXFIL") )
		ADK->( dbSeek( xFilial("ADK") + oItem:_FILIAL:_CDEMPRESA:TEXT + oItem:_FILIAL:_CDFILIAL:TEXT))
		lIntegrado := ADK->(Found())

		If lIntegrado

			RecLock("ADK", .F.)
			ADK->ADK_XSTINT := "I" //Integrado
			ADK->ADK_XDINT  := Date()
			ADK->ADK_XHINT  := Time()
			ADK->ADK_XEMP	:= oItem:_ID:_CDEMPRESA:TEXT
			ADK->ADK_XFIL	:= oItem:_ID:_CDFILIAL:TEXT
			ADK->( msUnLock() )
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
	
		cErrorLog:="Nao foi posivel concluir a integracao da unidade de negocio, verifique o XML retornado. [_CDEMPRESA="+IIF(Empty(oItem:_ID:_CDEMPRESA:TEXT),"Vazio",oItem:_ID:_CDEMPRESA:TEXT)+" e _CDFILIAL="+IIF(Empty(oItem:_ID:_CDFILIAL:TEXT),"Vazio",oItem:_ID:_CDFILIAL:TEXT)+"]" 
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
method makeXml(aLote) class TeknisaPutUnidade
Local cXml
Local nC
Local cTpInsc	:= ""
Local aAreaSM0	:= SM0->(Getarea())
Local cErrorLog := ""
Local lErroXML  := .F.
Local lFoundSM0 := .F.
	
	cErrorLog:=": Gerando XML..." 
	::oLog:SetAddInfo(cErrorLog,"Gerando XML...")
	ConOut(cErrorLog)

	cXml := '<empresas>'
	
	For nC := 1 to len(aLote)

		lErroXML := .F.
		lFoundSM0:= .F.
		
		//posiciona na unidade de negocio
		ADK->(dbGoTo(aLote[nC,01]))
		
		// -> Se for alteração
		If UPPER(Self:cMetEnv) == "POST"

			SM0->(dbGoTop())
			SM0->(dbSeek((cEmpAnt)))
			While !(SM0->(Eof())) .AND. SM0->M0_CODIGO == cEmpAnt
				If Padr(SM0->M0_CODFIL,TamSx3("ADK_FILIAL")[01]) == Padr(ADK->ADK_XFILI,TamSx3("ADK_FILIAL")[01])
					lFoundSM0:=.T.
					Exit
				EndIf
				SM0->(dbSkip())
			EndDo
			
			// -> Se nao encontrou a filial relacionada a ADK, exibe log de erro
			If !lFoundSM0
				lErroXML:=.T.
				cErrorLog:="Filial nao relacionada com no cadastro de unidades de negocio. Favor verificar o codigo da filial no cadastro de unidades de negocio. [ADK_XFILI="+AllTrim(ADK->ADK_XFILI)+"]" 
				::oLog:broken("Erro na geracao do XML.", cErrorLog, .T.)	
				ConOut("Erro: "+cErrorLog)	
			EndIf

		// -> Se for inclusao
		ElseIf ::cMetEnv $ "PUT/DELETE"

			SM0->(dbGoTop())
			SM0->(dbSeek((cEmpAnt)))
			While !(SM0->(Eof())) .AND. SM0->M0_CODIGO == cEmpAnt
				If Padr(SM0->M0_CODFIL,TamSx3("ADK_FILIAL")[01]) == Padr(ADK->ADK_XFILI,TamSx3("ADK_FILIAL")[01])
					lFoundSM0:=.T.
					Exit
				EndIf
				SM0->(dbSkip())
			EndDo
			
			// -> Se nao encontrou a filial relacionada a ADK, exibe log de erro
			If !lFoundSM0
				lErroXML:=.T.
				cErrorLog:="Filial nao relacionada com no cadastro de unidades de negocio. Favor verificar o codigo da filial no cadastro de unidades de negocio. [ADK_XFILI="+AllTrim(ADK->ADK_XFILI)+"]" 
				::oLog:broken("Erro na geracao do XML.", cErrorLog, .T.)	
				ConOut("Erro: "+cErrorLog)	
			EndIf

			// -> Se nao encontrou o codigo da empresa e filial do Teknisa na unidade de negocio
			If Empty(ADK->ADK_XEMP) .or. Empty(ADK->ADK_XFIL)
				lErroXML:=.T.
				cErrorLog:="Empresa e/ou filial do Teknisa nao encontrada no cadastro de unidades de negocio. [ADK_XEMP="+AllTrim(ADK->ADK_XEMP)+" e ADK_XFIL="+AllTrim(ADK->ADK_XFIL)+"]" 
				::oLog:broken("Erro na geracao do XML.", cErrorLog, .T.)	
				ConOut("Erro: "+cErrorLog)	
			EndIf
		
		EndIf
		
		// -> Se nao ocorreu erro, gera o XML
		If !lErroXML

			cXml += '<empresa>'
		
			cXml += '<id'
			cXml += ::tag('cdempresa'		,ADK->ADK_XEMP)
			cXml += ::tag('cdfilial'		,ADK->ADK_XFIL)
			cXml += '/>'
		
			cXml += '<empresa'
			cXml += ::tag('filial'			,ADK->ADK_XFILI)
			cXml += ::tag('nmfilial'		,SubStr(SM0->M0_FILIAL,1,30))
			cXml += '/>'
	
			cXml += '<fiscal'
			cXml += ::tag('idtpijurfili'	,cValToChar(SM0->M0_TPINSC))
			cXml += ::tag('nrinsjurfili'	,SM0->M0_CGC) 
			cXml += ::tag('cdinscmuni'		,IIF(AllTrim(SM0->M0_INSCM)=="","ISENTO",SM0->M0_INSCM))
			cXml += ::tag('cdinscesta'		,SM0->M0_INSC) 
			cXml += ::tag('nmrazsocfili'	,SM0->M0_FILIAL) 
			cXml += ::tag('cnae'			,SM0->M0_CNAE)
			cXml += ::tag('nire'			,SM0->M0_NIRE) 
			cXml += ::tag('datanire'		,Dtos(SM0->M0_DTRE))
			cXml += '/>'
	
			cXml += '<estabelecimento'
			cXml += ::tag('sgestado'		,SM0->M0_ESTENT)
			cXml += ::tag('codmunicipio'	,SM0->M0_CODMUN)
			cXml += ::tag('nmmunicipio'		,SM0->M0_CIDENT)
			cXml += ::tag('endereco'		,SM0->M0_ENDENT) 
			cXml += ::tag('nmbairfili'		,SM0->M0_BAIRENT)
			cXml += ::tag('nrcepfili'		,SM0->M0_CEPENT) 
			cXml += ::tag('nrtelefili'		,SM0->M0_TEL)
			cXml += ::tag('nrfaxfili'		,SM0->M0_FAX )
			cXml += ::tag('dscompendfil'	,SM0->M0_COMPENT) 
			cXml += '/>'		

			cXml += '</empresa>'
			
		EndIf	

 	Next nC

	cXml += '</empresas>'

	If AllTrim(cXml) == "<empresas></empresas>"
		cXml:=""
	EndIf	

	RestArea(aAreaSM0)

return cXml