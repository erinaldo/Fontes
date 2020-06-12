#include 'protheus.ch'
/*-----------------+---------------------------------------------------------+
!Nome              ! TkPutReceb                                              !
+------------------+---------------------------------------------------------+
!Descrição         ! Função para chamr o metodo PutRecebimentos via Menu     !
+------------------+---------------------------------------------------------+
!Autor             ! Mario L. B. Faria                                       !
+------------------+---------------------------------------------------------!
!Data              ! 25/05/2018                                              !
+------------------+--------------------------------------------------------*/
user function TkPutReceb(lBatch)
Private cPerg := padr("TPMETODO",10)
Default lBatch:= .F.

    // -> Se não for executado por job
	If! lBatch
		U_CRSX01MD()
		if !Pergunte(cPerg,.T.)
			Return .F.
		EndIf
	
		Do Case
			Case MV_PAR01 = 1
				TkReceb("Post")
			Case MV_PAR01 = 2
				TkReceb("Put")			
			Case MV_PAR01 = 3
				TkReceb("Delete")
		EndCase
    EndIf
    
    // -> Se não for executado por job
	If lBatch
 		// -> Executa o processo para inclusão de recebimentos
		TkReceb("Post")    
 		// -> Executa o processo para alteração de recebimentos
		TkReceb("Put")    
 		// -> Executa o processo oara exclusão de unidades de negócio
		TkReceb("Delete")    
    EndIf
    
Return


/*-----------------+---------------------------------------------------------+
!Nome              ! TkReceb                                                 !
+------------------+---------------------------------------------------------+
!Descrição         ! Função para processar o WS                              !
+------------------+---------------------------------------------------------+
!Autor             ! Mario L. B. Faria                                       !
+------------------+---------------------------------------------------------!
!Data              ! 25/05/2018                                              !
+------------------+--------------------------------------------------------*/
Static Function TkReceb(cMetEnv)
Local oIntegra
Local cMethod	:= "PutRecebimentos"
Local cAlias	:= "Z10"
Local cAlRot	:= "SA3"
Local oEventLog := EventLog():start("Recebimentos - "+AllTrim(cMetEnv), Date(), "Iniciando processo de integracao...", cMetEnv, cAlRot) 

	//instancia a classe
	oIntegra := TeknisaPutRecebimentos():new(cMethod, cMetEnv, cAlias, cAlRot, oEventLog)

	//se estiver ativo
	If oIntegra:isEnable()

		//busca os registros e se sequencia em lotes
		oIntegra:prepare()

		oIntegra:send()

	EndIf
	
	oEventLog:Finish()

return


/*-----------------+---------------------------------------------------------+
!Nome              ! TeknisaPutRecebimentos                                  !
+------------------+---------------------------------------------------------+
!Descrição         ! Classe PutRecebimentos                                  !
+------------------+---------------------------------------------------------+
!Autor             ! Mario L. B. Faria                                       !
+------------------+---------------------------------------------------------!
!Data              ! 25/05/2018                                              !
+------------------+--------------------------------------------------------*/
class TeknisaPutRecebimentos from TeknisaMethodAbstract
Data oLog
Data cMetE

	method new() constructor
	method makeXml(aLote,cMetEnv)
	method analise(oXmlItem)
	method fetch() 
	method prepare()

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
method new(cMethod, cMetEnv, cAlias, cAlRot, oEventLog) class TeknisaPutRecebimentos

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
method fetch() class TeknisaPutRecebimentos
Local cQuery := ''
Local cErrorLog := ""

	cErrorLog:=": Selecionando recebimentos..." 
	::oLog:SetAddInfo(cErrorLog,"Selecionando dados...")
	ConOut(cErrorLog)

	cQuery := "	SELECT " + CRLF
	cQuery += "		Z10.R_E_C_N_O_ Z10_REG, " + CRLF
	If Upper(::cMetEnv) != "DELETE"
		cQuery += "		SE4.R_E_C_N_O_ SE4_REG " + CRLF
	Else
		cQuery += "		0 SE4_REG " + CRLF
	EndIf
	cQuery += "	FROM " + RetSqlName("Z10") + " Z10 " + CRLF 
	If Upper(::cMetEnv) != "DELETE"
		cQuery += "	INNER JOIN " + RetSqlName("SE4") + " SE4 ON      " + CRLF
		cQuery += "			SE4.E4_FILIAL  = '" + xFilial("SE4") + "'" + CRLF
		cQuery += "		AND SE4.E4_CODIGO  = Z10.Z10_CODIGO          " + CRLF
		cQuery += "		AND SE4.D_E_L_E_T_ = ' '                     " + CRLF
 	EndIf
	cQuery += "	WHERE "                                                + CRLF  
	cQuery += "			Z10.Z10_FILIAL = '" + xFilial("Z10") + "' "    + CRLF
	If Upper(::cMetEnv) == "POST"
		cQuery += "		AND Z10.Z10_XSTINT = 'P' " + CRLF 
		cQuery += "		AND Z10.Z10_XDINT  = ' ' " + CRLF
		cQuery += "		AND Z10.Z10_XEXC  != 'S' " + CRLF
	ElseIf Upper(::cMetEnv) == "PUT"
		cQuery += "		AND Z10.Z10_XSTINT = 'P' " + CRLF 
		cQuery += "		AND Z10.Z10_XDINT != ' ' " + CRLF
		cQuery += "		AND Z10.Z10_XEXC  != 'S' " + CRLF	
	ElseIf Upper(::cMetEnv) == "DELETE"
		cQuery += "		AND Z10.Z10_XSTINT = 'P' " + CRLF 
		cQuery += "		AND Z10.Z10_XEXC   = 'S' " + CRLF
	EndIf
	cQuery += "		AND Z10.Z10_XFILI  = '"+cFilAnt+"' "     + CRLF 
	cQuery += "		AND Z10.D_E_L_E_T_ = ' ' "     + CRLF 

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
method analise(oXmlItem) class TeknisaPutRecebimentos
Local lIntegrado:= .F.
Local cCodRec 	:= ""
Local cErrorLog := ""
Private oItem 	:= oXmlItem

	//verifica se a propriedade integrado existe
	If type("oItem:_CONFIRMACAO:_INTEGRADO:TEXT") == "C"
		
		cCodRec:=IIF(type("oItem:_ID:_CDTIPOREC:TEXT"    ) == "C",oItem:_ID:_CDTIPOREC:TEXT,""    )
		
		//agora testa se o conteudo é true
		lIntegrado := lower(oItem:_CONFIRMACAO:_INTEGRADO:TEXT) == "true"

		If lIntegrado
			lIntegrado := lIntegrado .And. !Empty(cCodRec)

			// -> Se o codigo do recebimento nao retornou no XML, registra erro no log
			If Empty(cCodRec)
				cErrorLog:="Nao retornou o codigo de recebimento no Teknisa apos a chamada no metodo. [_CDTIPOREC = " + IIF(Empty(cCodRec),"Vazio",cCodRec)+"]" 
				::oLog:broken("Retorno do XML.", cErrorLog, .T.)	
				ConOut(cErrorLog)
			EndIf	

		EndIf
	
	EndIf

	If lIntegrado
		
		cErrorLog:=": "+AllTrim(oItem:_ID:_CDTIPOREC:TEXT)+": Atualizando status no ERP..." 
		::oLog:SetAddInfo("Retorno dos dados.",cErrorLog)
		ConOut(cErrorLog)
		
		//tabela de unidades
		dbSelectArea("Z10")
		
		//busca pelo indice customizado
		Z10->( dbSetOrder(1) )
		Z10->( dbSeek( xFilial("Z10") + oItem:_ID:_CODIGO:TEXT ))
		lIntegrado := Z10->( Found() )

		If lIntegrado

			recLock("Z10", .F.)
			Z10->Z10_CODEXT := oItem:_ID:_CDTIPOREC:TEXT
			Z10->Z10_XSTINT := "I" //Integrado
			Z10->Z10_XDINT  := Date()
			Z10->Z10_XHINT  := Time()
			Z10->( msUnLock() )
			::oEventLog:setCountInc()
		
			cErrorLog:="Ok." 
			::oLog:SetAddInfo("Retorno dos dados.",cErrorLog)
			ConOut(cErrorLog)

			dbSelectArea("SE4")
			SE4->(DbSetOrder(1))
			If SE4->(DbSeek(xFilial("SE4")+ oItem:_ID:_CODIGO:TEXT))
				recLock("SE4", .F.)
				SE4->E4_CODEXT := oItem:_ID:_CDTIPOREC:TEXT
				SE4->( msUnLock() )
			EndIf

		Else
		
			cErrorLog:="Erro."
			::oLog:SetAddInfo("Retorno dos dados.",cErrorLog)
			ConOut(cErrorLog)
				
		EndIf

	Else
	
		cErrorLog:="Nao foi posivel concluir a integracao da condicao de recebimento, verifique o XML retornado. [_CDTIPOREC="+IIF(Empty(cCodRec),"Vazio",cCodRec)+"]" 
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
method makeXml(aLote,cMetEnv) class TeknisaPutRecebimentos
Local cXml
Local nC
Local cAETIPO     := ""
Local nAETAXA	  := 0
Local nAEVENCFIN  := 0
Local cZ11XCLIEN  := ""
Local cZ11XCONSU  := ""
Local cAECODCLI   := ""
Local cA1LOJA     := ""
Local cAEXCCRED   := ""
Local cAEREDE     := "" 
Local cA1CGC      := ""
Local cAEADMCART  := ""
Local cAEMSBLQL   := ""                      
Local cSE4XTPREC  := ""
Local cErrorLog   := ""
Local cTefPos	  := ""
Local lErroXML    := .F.
	
	cErrorLog:=": Gerando XML..." 
	::oLog:SetAddInfo(cErrorLog,"Gerando XML...")
	ConOut(cErrorLog)

	cXml := '<recebimentos>'
	
	For nC := 1 to len(aLote)

		cAETIPO    := ""
		nAETAXA	   := 0
		nAEVENCFIN := 0
		cZ11XCLIEN := ""
		cZ11XCONSU := ""
		cAECODCLI  := ""
		cA1LOJA    := ""
		cAEXCCRED  := ""
		cAEREDE    := "" 
		cA1CGC     := ""
		cAEADMCART := ""
		cAEMSBLQL  := "1"
		lErroXML   := .F.

		If UPPER(cMetEnv) != "DELETE"

			Z10->( dbGoTo(aLote[nC,01]) )
			SE4->( dbGoTo(aLote[nC,02]) )

			cSE4XTPREC := SE4->E4_XTPREC
			
			If !Empty(cSE4XTPREC)
			
				// -> Posiciona na administradora
				SAE->(dbOrderNickName("AEXCOD"))
				If SAE->(DbSeek(xFilial("SE4")+SE4->E4_CODIGO))
					cAETIPO    := SAE->AE_TIPO
					nAETAXA	   := SAE->AE_TAXA
					nAEVENCFIN := SAE->AE_VENCFIN
					cAECODCLI  := SAE->AE_CODCLI
					cAEXCCRED  := SAE->AE_XCCRED
					cAEREDE    := SAE->AE_REDE
					cAEADMCART := SAE->AE_ADMCART
					cTefPos	   := SAE->AE_XTEFPO
					cAEMSBLQL  := IIF(FieldPos("AE_MSBLQL") > 0,IIF(SAE->AE_MSBLQL == "1","N","S"),"S")
					
					// -> Posiciona na tabela de Clientes, para 'pegar' o cliente relacionado a administrdora
					SA1->(DbSetOrder(1))
					If SA1->(DbSeek(xFilial("SA1")+SAE->AE_CODCLI))
						cA1LOJA := SA1->A1_LOJA
						cA1CGC  := SA1->A1_CGC			    
					Else
						// -> Se o cliente relacionado a administradora não estiver cadastrado no Protheus, gera log
						lErroXML:=.T.
						cErrorLog:="Cliente relacionado a administradora de cartao nao cadastrado no Protheus. [AE_CODCLI = " + IIF(Empty(SAE->AE_CODCLI),"Vazio",SAE->AE_CODCLI)+"]" 
						::oLog:broken("Retorno do XML.", cErrorLog, .T.)	
						ConOut(cErrorLog)
					EndIf

				Else 
					If !(cSE4XTPREC == cValToChar(3)) .And. !(cSE4XTPREC == cValToChar(4))
						lErroXML:=.T.
						dbSelectArea("SX5")
						dbSetOrder(1)
						If(dbSeek(xFilial("SX5")+"Z8"+cSE4XTPREC))
							cErrorLog:="Tipo de recebimento ["+SX5->X5_DESCRI+"], nao possui adminstradora financeira cadastrada." 
						Else
							cErrorLog:="Tipo de recebimento ["+cSE4XTPREC+"], nao possui adminstradora financeira cadastrada." 
						EndIf
						::oLog:broken("Retorno do XML.", cErrorLog, .T.)	
						ConOut(cErrorLog)
					EndIf
				EndIf	
			Else
				lErroXML:=.T.
				cErrorLog:="Campo E4_XTPREC[IdTipRec] esta em branco." 
				::oLog:broken("Retorno do XML.", cErrorLog, .T.)	
				ConOut(cErrorLog)
			EndIf
	                                  
			// -> Apenas gera o XML se nao ocorreu erro
			If !lErroXML
			
				cXml += '<recebimento>'
			
				cXml += '<id'
				cXml += ::tag('cdtiporec'		,Z10->Z10_CODEXT)
				cXml += ::tag('idtiporec'		,cSE4XTPREC)
				cXml += ::tag('codigo'			,Z10->Z10_CODIGO)
				cXml += '/>'
			
				cXml += '<cadastral'
				cXml += ::tag('tefpos'			,cTefPos)
				cXml +=	::tag('nmtiporec'		,Z10->Z10_DESC)
				cXml +=	::tag('formapgto'		,cAETIPO)
				cXml +=	::tag('vrtaxaadmi'		,nAETAXA   ,"DECIMAL")
				cXml +=	::tag('nrdiasadmi'		,nAEVENCFIN,"DECIMAL")
				cXml +=	::tag('cdcliente'		,cZ11XCLIEN)
				cXml +=	::tag('cdconsumidor'	,cZ11XCONSU)
				cXml +=	::tag('cliente'			,cAECODCLI)
				cXml +=	::tag('loja'			,cA1LOJA)
				cXml +=	::tag('ativa'			,cAEMSBLQL)
				cXml +=	::tag('codcredenciadora',cAEXCCRED)
				cXml +=	::tag('bandeira'		,cAEREDE)
				cXml +=	::tag('cnpjadm'			,cA1CGC)
				cXml +=	::tag('codbandeira'		,cAEADMCART)
				cXml += '/>'	
				cXml += '</recebimento>'
				
			EndIf	
		
		Else

			Z10->( dbGoTo(aLote[nC,01]) )
			// -> Apenas gera o XML se nao ocorreu erro
			If !lErroXML

				cXml += '<recebimento>'
			
				cXml += '<id'
				cXml += ::tag('cdtiporec'		,Z10->Z10_CODEXT)
				cXml += ::tag('idtiporec'		,)
				cXml += ::tag('codigo'			,Z10->Z10_CODIGO)
				cXml += '/>'
			
				cXml += '<cadastral'
				cXml +=	::tag('nmtiporec'		,Z10->Z10_DESC)
				cXml +=	::tag('formapgto'		,)
				cXml +=	::tag('vrtaxaadmi'		,0	,"DECIMAL")
				cXml +=	::tag('nrdiasadmi'		,0	,"DECIMAL")
				cXml +=	::tag('cdcliente'		,,)
				cXml +=	::tag('cdconsumidor'	,,)
				cXml +=	::tag('cliente'			,,)
				cXml +=	::tag('loja'			,,)
				cXml +=	::tag('ativa'			,,)
				cXml +=	::tag('codcredenciadora',,)
				cXml +=	::tag('bandeira'		,,)
				cXml +=	::tag('cnpjadm'			,,)
				cXml += '/>'	
			
				cXml += '</recebimento>'
		
			EndIf
			
		EndIf
		
 	Next nC

	cXml += '</recebimentos>'
	
	If AllTrim(cXml) == "<recebimentos></recebimentos>"
		cXml:=""
	EndIf	
	
	MemoWrite("C:\TEMP\XML_" + cMetEnv + ".XML",cXml)

return cXml


/*/{Protheus.doc} prepare
//TODO Metoto para preparar os lotes a enviar
@author Mario L. B. Faria
@since 25/05/2018
@version 1.0
/*/
method prepare() class TeknisaPutRecebimentos
Local cAlias	:= ::fetch()
Local nCont		:= 0
Local cErrorLog	:= ""
	
	::aLotes := {}

	While !(cAlias)->(Eof())
	
		nCont:=nCont+1

		IF Len(::aLotes) == 0 .Or. len(::aLotes[len(::aLotes)]) >= ::nLimite
			aAdd(::aLotes, {})
		EndIF

		aAdd( ::aLotes[len(::aLotes)],	{;
											(cAlias)->Z10_REG,;
											(cAlias)->SE4_REG,;
										} )	
		
		(cAlias)->( dbSkip() )
	
	EndDo

	(cAlias)->( dbCloseArea() )
	
	cErrorLog:=": "+AllTrim(Str(nCont))+" item(ns) selecionado(s)."
	::oLog:SetAddInfo("Pesquisando dados.",cErrorLog)
	ConOut(cErrorLog)

return len(::aLotes) > 0