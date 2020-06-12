#include 'protheus.ch'
#include 'parmtype.ch'
/*-----------------+---------------------------------------------------------+
!Nome              ! TkPutImp                                                !
+------------------+---------------------------------------------------------+
!Descrição         ! Função para chamr o metodo PutImposto via Menu          !
+------------------+---------------------------------------------------------+
!Autor             ! Mario L. B. Faria                                       !
+------------------+---------------------------------------------------------!
!Data              ! 25/05/2018                                              !
+------------------+--------------------------------------------------------*/
User Function TkPutImp(lBatch)
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
				TkImp("Post")			
			Case MV_PAR01 = 2
				Alert("Opção não disponivel para este método")			
			Case MV_PAR01 = 3
				TkImp("Delete")	
		EndCase    
	EndIf

    // -> Se não for executado por job
	If lBatch
 		// -> Executa o processo para inclusão de impostos
 		TkImp("Post")
 		// -> Executa o processo para exclusão de impostos
 		TkImp("Delete") 		
    EndIf	           	
	
Return


/*-----------------+---------------------------------------------------------+
!Nome              ! TkImp                                                   !
+------------------+---------------------------------------------------------+
!Descrição         ! Função para processar o WS                              !
+------------------+---------------------------------------------------------+
!Autor             ! Mario L. B. Faria                                       !
+------------------+---------------------------------------------------------!
!Data              ! 25/05/2018                                              !
+------------------+--------------------------------------------------------*/
Static Function TkImp(cMetEnv)
Local oIntegra
Local cMethod	:= "PutImposto"
Local cAlias	:= "Z16"
Local cAlRot	:= "SF7"   
Local oEventLog := EventLog():start("Impostos - "+AllTrim(cMetEnv), Date(), "Iniciando processo de integracao...", cMetEnv, cAlRot) 

	//instancia a classe
	oIntegra := TeknisaPutImposto():new(cMethod, cMetEnv, cAlias, cAlRot, oEventLog)

	//se estiver ativo
	If oIntegra:isEnable()

		//busca os registros e se sequencia em lotes
		oIntegra:prepare()

		oIntegra:send()

	EndIf
	
	oEventLog:Finish()

return


/*-----------------+---------------------------------------------------------+
!Nome              ! TeknisaPutImposto                                       !
+------------------+---------------------------------------------------------+
!Descrição         ! Classe PutImposto                                       !
+------------------+---------------------------------------------------------+
!Autor             ! Mario L. B. Faria                                       !
+------------------+---------------------------------------------------------!
!Data              ! 25/05/2018                                              !
+------------------+--------------------------------------------------------*/
class TeknisaPutImposto from TeknisaMethodAbstract
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
method new(cMethod, cMetEnv, cAlias, cAlRot, oEventLog) class TeknisaPutImposto

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
method fetch() class TeknisaPutImposto
Local cQuery	:= ''
Local cGrpClie  := GetMv("MV_XGRCLIU",,"")
Local cErrorLog := ""

	cErrorLog:=": Selecionando dados de impostos..." 
	::oLog:SetAddInfo(cErrorLog,"Selecionando dados...")
	ConOut(cErrorLog)
	
	cQuery += "	SELECT " + CRLF 
	cQuery += "	    SB1.R_E_C_N_O_ SB1_REC, " + CRLF
	cQuery += "	    Z13.R_E_C_N_O_ Z13_REC, " + CRLF
	cQuery += "	    SF7.R_E_C_N_O_ SF7_REC, " + CRLF
	cQuery += "		Z16.R_E_C_N_O_ Z16_REC  " + CRLF
	cQuery += "	FROM " + RetSqlName("Z16") + " Z16 " + CRLF 
	cQuery += "	LEFT JOIN " + RetSqlName("SF7") + " SF7 ON "  + CRLF 
	cQuery += "			F7_FILIAL = Z16_FILIAL "              + CRLF 
	cQuery += "		AND F7_GRTRIB = Z16_GRPTRI "              + CRLF 
	cQuery += "		AND SF7.D_E_L_E_T_ = ' ' "                + CRLF 
	cQuery += "	INNER JOIN " + RetSqlName("SB1") + " SB1 ON " + CRLF
	cQuery += "	        B1_FILIAL = Z16_FILIAL "              + CRLF	
	If Upper(::cMetEnv) == "POST"
		cQuery += "	    AND B1_GRTRIB = Z16_GRPTRI " + CRLF
	EndIf
	cQuery += "	    AND B1_COD    = Z16_COD  "                  + CRLF
	cQuery += "	    AND SB1.D_E_L_E_T_ = ' '                  " + CRLF 
	cQuery += "	INNER JOIN " + RetSqlName("Z13") + " Z13 ON   " + CRLF
	cQuery += "	        Z13_FILIAL = '" + xFilial("Z13") + "' " + CRLF
	cQuery += "	    AND Z13_COD = B1_COD "                      + CRLF
	cQuery += "	    AND Z13.D_E_L_E_T_ = ' ' "                  + CRLF
	cQuery += "	WHERE "                                         + CRLF  
	cQuery += "			Z16_FILIAL = '" + xFilial("Z16") + "' " + CRLF 
	cQuery += "		AND Z16_XSTINT = 'P' "                      + CRLF 
	
	If Upper(::cMetEnv) == "POST"
		cQuery += "		AND Z16.Z16_XEXC = 'N' "              + CRLF 
	ElseIf Upper(::cMetEnv) == "DELETE"
		cQuery += "		AND Z16.Z16_XEXC = 'S' "              + CRLF 
	EndIf
	
	// cQuery += "		AND F7_EST    = '" + SM0->M0_ESTENT + "' "  + CRLF 
	cQuery += "		AND F7_GRPCLI = '" + cGrpClie       + "' "  + CRLF
	cQuery += "		AND Z16.D_E_L_E_T_ = ' ' "                  + CRLF 
	cQuery += "	ORDER BY B1_GRTRIB, B1_COD "                    + CRLF	

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
method analise(oXmlItem) class TeknisaPutImposto
Local lIntegrado := .F.
Local cCodEmp 	 := ""
Local cCodFil 	 := ""
Local cCodTrib   := ""
Local cCodProd   := ""
Local cCodTek    := ""
Private oItem 	 := oXmlItem

	//verifica se a propriedade integrado existe
	IF type("oItem:_CONFIRMACAO:_INTEGRADO:TEXT") == "C"

		cCodEmp :=IIF(Type("oItem:_FILIAL:_CDEMPRESA:TEXT") == "C",oItem:_FILIAL:_CDEMPRESA:TEXT,"")
		cCodFil :=IIF(Type("oItem:_FILIAL:_CDFILIAL:TEXT")  == "C",oItem:_FILIAL:_CDFILIAL:TEXT ,"")
		cCodTrib:=IIF(Type("oItem:_PRODUTO:_GRUPOPRODUTO:TEXT")     == "C",oItem:_PRODUTO:_GRUPOPRODUTO:TEXT    ,"")
		cCodProd:=IIF(Type("oItem:_PRODUTO:_CODIGOPRODUTO:TEXT") == "C",oItem:_PRODUTO:_CODIGOPRODUTO:TEXT,"")
		cCodTek :=IIF(Type("oItem:_PRODUTO:_CDPRODUTO:TEXT")     == "C",oItem:_PRODUTO:_CDPRODUTO:TEXT    ,"")


		//agora testa se o conteudo é true
		lIntegrado := lower(oItem:_CONFIRMACAO:_INTEGRADO:TEXT) == "true"

		If lIntegrado
			
			lIntegrado := lIntegrado .And. !Empty(cCodEmp)
			lIntegrado := lIntegrado .And. !Empty(cCodFil)
			lIntegrado := lIntegrado .And. !Empty(cCodTrib)
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

			// -> Se o codigo do grupo de tributacao do produto nao retornou no XML, registra erro no log
			If Empty(cCodTrib)
				cErrorLog:="Nao retornou o codigo produto no Teknisa apos a chamada no metodo. [_GRUPOPRODUTO = " + IIF(Empty(cCodTrib),"Vazio",cCodTrib)+"]" 
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

		cErrorLog:=": "+AllTrim(oItem:_PRODUTO:_CODIGOPRODUTO:TEXT)+": Atualizando status no ERP..." 
		::oLog:SetAddInfo("Retorno dos dados.",cErrorLog)
		ConOut(cErrorLog)

		//tabela de produtos
		dbSelectArea("Z16")
		
		//busca pelo indice customizado
		Z16->( dbSetOrder(1) )
		Z16->( dbSeek( xFilial("Z16") + PadR(oItem:_PRODUTO:_GRUPOPRODUTO:TEXT,TamSx3("Z16_GRPTRI")[01]) + PadR(oItem:_PRODUTO:_CODIGOPRODUTO:TEXT,TamSx3("Z16_COD")[01]) ))
		lIntegrado := Z16->( Found() )

		If lIntegrado
		
			RecLock("Z16", .F.)
			If Z16->Z16_XATIVO == "S"
				Z16->Z16_XEMP	:= oItem:_FILIAL:_CDEMPRESA:TEXT				
				Z16->Z16_XFIL	:= oItem:_FILIAL:_CDFILIAL:TEXT
				Z16->Z16_XSTINT	:= "I" //Integrado
				Z16->Z16_XDINT	:= Date()
				Z16->Z16_XHINT	:= Time()
			Else
				Z16->(dbDelete())
			EndIf
			Z16->( msUnLock() )
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
	
		cErrorLog:="Nao foi posivel concluir a integracao do imposto, verifique o XML retornado. [_CODIGOPRODUTO="+IIF(Empty(cCodProd),"Vazio",cCodProd)+" e _CDPRODUTO="+IIF(Empty(cCodTek),"Vazio",cCodTek)+"]" 
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
method makeXml(aLote,cMetEnv) class TeknisaPutImposto
Local cXml      := ""
Local cXmlItem  := ""
Local nC		:= 0
Local nInc		:= 0
Local aRecZ16	:= 0
Local cGTribAux	:= ""
Local cCodEmp   := ""
Local cCodFil   := ""
Local cErrorLog := ""
Local lErroXML  := .F.
Local cGrpClie  := GetMv("MV_XGRCLIU",,"")
	
	cErrorLog:=": Gerando XML..." 
	::oLog:SetAddInfo(cErrorLog,"Gerando XML...")
	ConOut(cErrorLog)
	
	SB1->( dbGoTo(aLote[01,01]) )
	Z13->( dbGoTo(aLote[01,02]) )
	//SF7->( dbGoTo(aLote[01,03]) )
	Z16->( dbGoTo(aLote[01,04]) )

	cXml := '<impostos>'   
	
	For nC := 1 to len(aLote)
	
		cGTribAux := Z16->Z16_GRPTRI
		nInc	  := 0	
		cXmlItem  := ""
		While cGTribAux == Z16->Z16_GRPTRI .And. nC <= len(aLote)

			// -> Verifica se o código do produto relacionado ao Teknisa
			lErroXML :=.F. 
			If !Z13->(dbSeek(xFilial("Z13") + SB1->B1_COD))
				If AllTrim(SB1->B1_XCODEXT) != ""
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
					lErroXML :=.T.
					cErrorLog:="Erro: Codigo de relacionamento entre o produto do Teknisa e Protheus invalido. Verifique se o produto foi integrado co o Teknisa. [Z13_COD="+AllTrim(Z13->Z13_COD)+" e Z13_XCODEX="+AllTrim(Z13->Z13_XCODEX)+"]" 
					::oLog:broken("Erro na geracao do XML.", cErrorLog, .F.)	
					ConOut(cErrorLog)
				EndIf
			ElseIf Alltrim(Z13->Z13_XCODEX) == ""
				lErroXML :=.T.
				cErrorLog:="Erro: Codigo de relacionamento entre o produto do Teknisa e Protheus invalido. Verifique se o produto foi integrado co o Teknisa. [Z13_COD="+AllTrim(Z13->Z13_COD)+" e Z13_XCODEX="+AllTrim(Z13->Z13_XCODEX)+"]" 
				::oLog:broken("Erro na geracao do XML.", cErrorLog, .F.)	
				ConOut(cErrorLog)
			EndIf
			
			// -> Verifica se o código da empresa e filial do Teknisa 
			If Empty(Z16->Z16_XEMP) .or. Empty(Z16->Z16_XFIL)
				// ->Posiciona no cadastrto de unidades de negocio
				ADK->(DbOrderNickName("ADKXFILI"))
				ADK->(DbSeek(xFilial("ADK")+cFilAnt))
				If !ADK->(Found())
					lErroXML :=.T.
					cErrorLog:="Erro: Empresa e/ou filial do Teknisa nao encontrado(s) no cadastro de unidades de negocio. [ADK_XEMP="+IIF(Empty(Z16->Z16_XEMP),"Vazio",Z16->Z16_XEMP)+" e ADK_XFIL="+IIF(Empty(Z16->Z16_XFIL),"Vazio",Z16->Z16_XFIL)+"]" 
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
			Else
				cCodEmp:=Z16->Z16_XEMP
				cCodFil:=Z16->Z16_XFIL
			EndIf	

			dbSelectArea("SF7")
			SF7->(DbOrderNickName("SF7GRPEST"))
			SF7->(dbGoTop())
			SF7->(dbSeek(xFilial("SF7")+Z16->Z16_GRPTRI+cGrpClie+ADK->ADK_EST))

			If !SF7->(found())
				lErroXML :=.T.
				cErrorLog:="Erro: Não foram encontrados grupos tributários para esta filial e estado. [ADK_FILIAL="+ADK->ADK_XFILI+" e ADK_EST="+ADK->ADK_EST+"]" 
				::oLog:broken("Erro na geracao do XML.", cErrorLog, .F.)	
				ConOut(cErrorLog)
			EndIf

			// -> Se não ocorreu erro, gera XML
			If !lErroXML
				
				nInc:=nInc+1
				
				cXmlItem += '<item'
			
				cXmlItem += ::tag('cdproduto'			,Z13->Z13_XCODEX)
				cXmlItem += ::tag('codigoproduto'		,SB1->B1_COD)
				cXmlItem += ::tag('nmprodut'			,SB1->B1_DESC)
				cXmlItem += ::tag('situacaotributaria'	,SF7->F7_SITTRIB)
				cXmlItem += ::tag('uf'					,SF7->F7_EST)
				cXmlItem += ::tag('grupocliente'		,SF7->F7_GRPCLI)
				cXmlItem += ::tag('grupoproduto'		,SB1->B1_GRTRIB)
				cXmlItem += ::tag('aliquota'			,StrTran(Transform(SF7->F7_ALIQDST	,"@E 99.99"),",","."))
				cXmlItem += ::tag('reducaopis'			,StrTran(Transform(SF7->F7_REDPIS	,"@E 99.99"),",","."))
				cXmlItem += ::tag('aliqutapis'			,StrTran(Transform(SF7->F7_ALIQPIS	,"@E 99.99"),",","."))
				cXmlItem += ::tag('reducao'				,StrTran(Transform(SF7->F7_REDCOF	,"@E 99.99"),",","."))
				cXmlItem += ::tag('aliquotacofins'		,StrTran(Transform(SF7->F7_ALIQCOF	,"@E 99.99"),",","."))
				cXmlItem += ::tag('origem'				,SF7->F7_ORIGEM)

				cXmlItem += '/>'
			
			EndIf
			
			// -> Guarda dados da Empresa/filial
			aRecZ16 := aLote[nC,04]
			
			nC++
			If nC <= len(aLote)
				SB1->( dbGoTo(aLote[nC,01]) )
				Z13->( dbGoTo(aLote[nC,02]) )
				SF7->( dbGoTo(aLote[nC,03]) )
				Z16->( dbGoTo(aLote[nC,04]) )
			EndIf
			
		EndDo
		nC--
		
		// -> Se encontrou itens relacionados ao impostos
		If nInc > 0
			cXml += '<imposto>'

			cXml += '<id'
			cXml += ::tag('grupotrib'		,cGTribAux)
			cXml += '/>'
			
			cXml += '<fiscais>'
			cXml += cXmlItem
			cXml += '</fiscais>'
		
			cXml += '<empresas>'
		
			cXml += '<filial'
			cXml += ::tag('cdempresa'	,cCodEmp)
			cXml += ::tag('cdfilial'	,cCodFil)
			cXml += ::tag('filial'		,Z16->Z16_FILIAL)
			cXml += ::tag('nmfilial'	,SM0->M0_FILIAL)
			cXml += '/>'
		
			cXml += '</empresas>'
		
			cXml += '</imposto>'
		
		EndIf
		
 	Next nC

	cXml += '</impostos>'
	
	If AllTrim(cXml) == "<impostos></impostos>"
		cXml:=""
	EndIf
	
	MemoWrite("C:\TEMP\XML_" + cMetEnv + ".XML",cXml)

return cXml


/*-----------------+---------------------------------------------------------+
!Nome              ! prepare                                                 !
+------------------+---------------------------------------------------------+
!Descrição         ! Metoto para preparar os lotes a enviar                  !
+------------------+---------------------------------------------------------+
!Autor             ! Mario L. B. Faria                                       !
+------------------+---------------------------------------------------------!
!Data              ! 25/05/2018                                              !
+------------------+--------------------------------------------------------*/
method prepare() class TeknisaPutImposto
Local cAlias   := ::fetch()

	::aLotes := {}

	While ! (cAlias)->( Eof() )

		IF Len(::aLotes) == 0 .Or. len(::aLotes[len(::aLotes)]) >= ::nLimite
			aAdd(::aLotes, {})
		EndIF

		aAdd( ::aLotes[len(::aLotes)],	{;
											(cAlias)->SB1_REC,;
											(cAlias)->Z13_REC,;
											(cAlias)->SF7_REC,;
											(cAlias)->Z16_REC;
										} )	
		
		(cAlias)->( dbSkip() )
	EndDO

	(cAlias)->( dbCloseArea() ) 
	
	cErrorLog:=": "+AllTrim(Str(Len(::aLotes)))+" itens selecionados." 
	::oLog:SetAddInfo(cErrorLog,"Selecionando dados...")
	ConOut(cErrorLog)

return len(::aLotes) > 0
