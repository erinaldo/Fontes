#include 'protheus.ch'
/*-----------------+---------------------------------------------------------+
!Nome              ! TkPutClie                                               !
+------------------+---------------------------------------------------------+
!Descrição         ! Função para chamr o metodo PutCliente via Menu          !
+------------------+---------------------------------------------------------+
!Autor             ! Mario L. B. Faria                                       !
+------------------+---------------------------------------------------------!
!Data              ! 25/05/2018                                              !
+------------------+--------------------------------------------------------*/
User Function TkPutClie(lBatch)
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
				TkClie("Post")			
			Case MV_PAR01 = 2
				TkClie("Put")			
			Case MV_PAR01 = 3
				TkClie("Delete")	
		EndCase
    EndIf
    
    // -> Se não for executado por job
	If lBatch
 		// -> Executa o processo para inclusão de clientes
 		TkClie("Post")			 		
 		// -> Executa o processo para alteração de clientes
 		TkClie("Put")			
 		// -> Executa o processo para exclusão de clientes
 		TkClie("Delete")	    
	EndIf
	    
Return


/*-----------------+---------------------------------------------------------+
!Nome              ! TkClie                                                  !
+------------------+---------------------------------------------------------+
!Descrição         ! Função para processar o WS                              !
+------------------+---------------------------------------------------------+
!Autor             ! Mario L. B. Faria                                       !
+------------------+---------------------------------------------------------!
!Data              ! 25/05/2018                                              !
+------------------+--------------------------------------------------------*/
Static Function TkClie(cMetEnv)
Local oIntegra
Local cMethod	:= "PutCliente"
Local cAlias	:= "Z11"
Local cAlRot	:= "SA1"
Local oEventLog := EventLog():start("Clientes - "+AllTrim(cMetEnv), Date(), "Iniciando processo de integracao...", cMetEnv, cAlRot) 
	
	//instancia a classe
	oIntegra := TeknisaPutCliente():new(cMethod, cMetEnv, cAlias, cAlRot, oEventLog)

	//se estiver ativo
	If oIntegra:isEnable()

		//busca os registros e se sequencia em lotes
		oIntegra:prepare()

		oIntegra:send()

	EndIf
	
	oEventLog:Finish()

return


/*-----------------+---------------------------------------------------------+
!Nome              ! TeknisaPutCliente                                       !
+------------------+---------------------------------------------------------+
!Descrição         ! Classe PutCliente                                       !
+------------------+---------------------------------------------------------+
!Autor             ! Mario L. B. Faria                                       !
+------------------+---------------------------------------------------------!
!Data              ! 25/05/2018                                              !
+------------------+--------------------------------------------------------*/
class TeknisaPutCliente from TeknisaMethodAbstract
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
method new(cMethod, cMetEnv, cAlias, cAlRot, oEventLog) class TeknisaPutCliente

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
method fetch() class TeknisaPutCliente
Local cQuery	:= ''
Local cPreRot	:= If(Len(PrefixoCpo(::cAlRot)) == 2,"S" + PrefixoCpo(::cAlRot), PrefixoCpo(::cAlRot))
Local cPreAli	:= If(Len(PrefixoCpo(::cAlias)) == 2,"S" + PrefixoCpo(::cAlias), PrefixoCpo(::cAlias))
Local cErrorLog := ""

	cErrorLog:=": Selecionando clientes..." 
	::oLog:SetAddInfo(cErrorLog,"Selecionando dados...")
	ConOut(cErrorLog)

	cQuery += "	SELECT " + CRLF
	cQuery += "		" + cPreRot + ".R_E_C_N_O_ ROT_REG, " + CRLF	//Recno da tabela Principal
	cQuery += "		" + cPreAli + ".R_E_C_N_O_ ALI_REG  " + CRLF    //Recno da tabela Auxiliar
	
	cQuery += "	FROM " + RetSqlName(::cAlias) + " " + cPreAli + " " + CRLF
	
	cQuery += "	LEFT JOIN " + RetSqlName(::cAlRot) + " " + cPreRot + " ON "                          + CRLF
	cQuery += "			  " + PrefixoCpo(::cAlRot) + "_FILIAL = '" + xFilial("SA1")       + "'     " + CRLF
	cQuery += "		  AND " + PrefixoCpo(::cAlRot) + "_COD    =  " + PrefixoCpo(::cAlias) + "_COD  " + CRLF
	cQuery += "		  AND " + PrefixoCpo(::cAlRot) + "_LOJA   =  " + PrefixoCpo(::cAlias) + "_LOJA " + CRLF
	cQuery += "		  AND " + cPreRot + ".D_E_L_E_T_ = ' ' " + CRLF
	
	cQuery += "	WHERE  " + CRLF
	
	If xFilial(::cAlias) == '          '
		cQuery += "			" + PrefixoCpo(::cAlias) + "_XFILI = '" + cFilAnt + "' " 			+ CRLF
	Else
		cQuery += "			" + PrefixoCpo(::cAlias) + "_FILIAL = '" + xFilial(::cAlias) + "' " + CRLF
	EndIf
	
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
method analise(oXmlItem) class TeknisaPutCliente
Local lIntegrado := .F.
Local cCdCliente := ""
Local cCdConsum  := ""
Local cErrorLog  := ""
Private oItem := oXmlItem

	//verifica se a propriedade integrado existe
	If type("oItem:_CONFIRMACAO:_INTEGRADO:TEXT") == "C"
	
		cCdCliente:=IIF(type("oItem:_ID:_CDCLIENTE:TEXT"   ) == "C",oItem:_ID:_CDCLIENTE:TEXT   ,"")
		cCdConsum :=IIF(type("oItem:_ID:_CDCONSUMIDOR:TEXT") == "C",oItem:_ID:_CDCONSUMIDOR:TEXT,"")

		// agora testa se o conteudo é true
		lIntegrado := lower(oItem:_CONFIRMACAO:_INTEGRADO:TEXT) == "true"

		If lIntegrado

			lIntegrado := lIntegrado .And. !Empty(cCdCliente)
			lIntegrado := lIntegrado .And. !Empty(cCdConsum)

			// -> Se o código do cliente no Teknisa não retornou, registra erro no log
			If Empty(cCdCliente)
				cErrorLog:="Nao retornou o codigo da empresa no Teknisa apos a chamada no metodo. [_CDCLIENTE = " + IIF(Empty(cCdCliente),"Vazio",cCdCliente)+"]" 
				::oLog:broken("Retorno do XML.", cErrorLog, .T.)	
				ConOut(cErrorLog)
			EndIf	

			// -> Se o código do consumidor no Teknisa não retornou, registra erro no log
			If Empty(cCdConsum)
				cErrorLog:="Nao retornou o codigo da filial no Teknisa apos a chamada no metodo. [_CDCONSUMIDOR = " + IIF(Empty(cCdConsum),"Vazio",cCdConsum)+"]" 
				::oLog:broken("Retorno do XML.", cErrorLog, .T.)	
				ConOut(cErrorLog)
			EndIf	

		EndIf

	EndIf

	If lIntegrado

		cErrorLog:=": "+AllTrim(oItem:_ID:_CDCLIENTE:TEXT)+": "+AllTrim(oItem:_ID:_CDCONSUMIDOR:TEXT)+": Atualizando status no ERP..." 
		::oLog:SetAddInfo("Retorno dos dados.",cErrorLog)
		ConOut(cErrorLog)

		//tabela de unidades
		dbSelectArea("Z11")
		
		//busca pelo indice customizado
		Z11->( dbSetOrder(1) )
		Z11->( dbSeek( xFilial("Z11") + oItem:_ID:_CODIGO:TEXT + oItem:_ID:_LOJA:TEXT ) )
		lIntegrado := Z11->(Found())

		If lIntegrado

			RecLock("Z11", .F.)
			Z11->Z11_XCLIEN	:= oItem:_ID:_CDCLIENTE:TEXT
			Z11->Z11_XCONSU := oItem:_ID:_CDCONSUMIDOR:TEXT
			Z11->Z11_XSTINT := "I" //Integrado
			Z11->Z11_XDINT  := Date()
			Z11->Z11_XHINT  := Time()
			Z11->( msUnLock() )
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
	
		cErrorLog:="Nao foi posivel concluir a integracao do cliente, verifique o XML retornado. [_CDCLIENTE="+IIF(Empty(cCdCliente),"Vazio",cCdCliente)+" e _CDCONSUMIDOR="+IIF(Empty(cCdConsum),"Vazio",cCdConsum)+"]" 
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
method makeXml(aLote,cMetEnv) class TeknisaPutCliente
Local cXml
Local nC
Local cErrorLog := ""
	
	cErrorLog:=": Gerando XML..." 
	::oLog:SetAddInfo(cErrorLog,"Gerando XML...")
	ConOut(cErrorLog)

	dbSelectArea("Z11")
	Z11->( dbSetOrder(1) )

	cXml := '<clientes>'                                    

	For nC := 1 to len(aLote)

		If Lower(cMetEnv) != "delete"

			//posiciona no cliente
			IF valtype(aLote[nC]) == "C"
				SA1->( dbSetOrder(1) )
				SA1->( dbSeek( xFilial("SB1") + aLote[nC,01] ) )
			Else
				SA1->( dbGoTo(aLote[nC,01]) )
			EndIF
			
			Z11->( dbGoTo(aLote[nC,02]) )
	
			cXml += '<cliente>'
	
			cXml += '<id'
			cXml += ::tag('loja'			,SA1->A1_LOJA)
			cXml += ::tag('codigo'			,SA1->A1_COD)
			cXml += ::tag('cdconsumidor'	,Z11->Z11_XCONSU)
			cXml += ::tag('cdcliente'		,Z11->Z11_XCLIEN)						
			cXml += '/>'
			
			cXml += '<fiscal'
			cXml += ::tag('nrinsestcli'		,SA1->A1_INSCR)
			cXml += ::tag('nrinsjurcli'		,SA1->A1_CGC)
			cXml += ::tag('sgestado'		,SA1->A1_EST)
			cXml += ::tag('cdpais'			,SA1->A1_CODPAIS)
			cXml += '/>'
	
			cXml += '<cadastral'
			cXml += ::tag('nmrazsocclie'	,SA1->A1_NOME)
			cXml += ::tag('nmfantcli'		,SA1->A1_NREDUZ)
			cXml += ::tag('enderprinc'		,"S")
			cXml += ::tag('codmunicipio'	,SA1->A1_COD_MUN)
			cXml += ::tag('dsmunicipio'		,SA1->A1_MUN)
			cXml += ::tag('dsendcons'		,SA1->A1_END)
			cXml += ::tag('nrendecons'		,FisGetEnd(SA1->A1_END, SA1->A1_EST)[03])
			cXml += ::tag('dscomplendecons'	,SA1->A1_COMPLEM)
			cXml += ::tag('nrcepcons'		,SA1->A1_CEP)
			cXml += ::tag('nmbaircons'		,SA1->A1_BAIRRO)
			cXml += ::tag('ddi'				,SA1->A1_DDI)
			cXml += ::tag('ddd'				,SA1->A1_DDD)
			cXml += ::tag('nrtelecons'		,SA1->A1_TEL)
			cXml += ::tag('nrtele2cons'		,SA1->A1_XFONE2)
			cXml += ::tag('nrcelularcons'	,SA1->A1_XCELULA)
			cXml += ::tag('nmrespcons'		,SA1->A1_CONTATO)
			cXml += ::tag('dsemailcons'		,SA1->A1_EMAIL)
			cXml += ::tag('dtnasccons'		,DtoS(SA1->A1_DTNASC))
			cXml += ::tag('rgcliente'		,SA1->A1_PFISICA)
			cXml += ::tag('dtcadaclie'		,DtoS(SA1->A1_DTCAD))
			cXml += ::tag('hrcadclie'		,SA1->A1_HRCAD)	
			cXml += ::tag('ativo'			,If(SA1->A1_MSBLQL == "1","N","S"))
			
			cXml += '/>'
	
//		 	cXml += '<empresas>'
//		 	
//			cXml += '<filial'
//			cXml += ::tag('cdempresa'	,Z11->Z11_XEMP)
//			cXml += ::tag('cdfilial'	,Z11->Z11_XFIL)
//			cXml += ::tag('filial'		,SM0->M0_CODFIL)
//			cXml += ::tag('nmfilial'	,SM0->M0_FILIAL)
//			cXml += '/>'
//		
//			cXml += '</empresas>'	
		 	
			cXml += '</cliente>'	
			
		Else
		
			Z11->( dbGoTo(aLote[nC,02]) )
	
			cXml += '<cliente>'
	
			cXml += '<id'
			cXml += ::tag('loja'			,Z11->Z11_LOJA)
			cXml += ::tag('codigo'			,Z11->Z11_COD)
			cXml += ::tag('cdconsumidor'	,Z11->Z11_XCONSU)
			cXml += ::tag('cdcliente'		,Z11->Z11_XCLIEN)						
			cXml += '/>'
			
			cXml += '<fiscal'
			cXml += ::tag('nrinsestcli'		,"")
			cXml += ::tag('nrinsjurcli'		,"")
			cXml += ::tag('sgestado'		,"")
			cXml += ::tag('cdpais'			,"")
			cXml += '/>'
	
			cXml += '<cadastral'
			cXml += ::tag('nmrazsocclie'	,"")
			cXml += ::tag('nmfantcli'		,"")
			cXml += ::tag('enderprinc'		,"")
			cXml += ::tag('codmunicipio'	,"")
			cXml += ::tag('dsmunicipio'		,"")
			cXml += ::tag('dsendcons'		,"")
			cXml += ::tag('nrendecons'		,"")
			cXml += ::tag('dscomplendecons'	,"")
			cXml += ::tag('nrcepcons'		,"")
			cXml += ::tag('nmbaircons'		,"")
			cXml += ::tag('ddi'				,"")
			cXml += ::tag('ddd'				,"")
			cXml += ::tag('nrtelecons'		,"")
			cXml += ::tag('nrtele2cons'		,"")
			cXml += ::tag('nrcelularcons'	,"")
			cXml += ::tag('nmrespcons'		,"")
			cXml += ::tag('dsemailcons'		,"")
			cXml += ::tag('dtnasccons'		,"")
			cXml += ::tag('rgcliente'		,"")
			cXml += ::tag('dtcadaclie'		,"")
			cXml += ::tag('hrcadclie'		,"")
			cXml += ::tag('ativo'			,"")
			
			cXml += '/>'
	
//		 	cXml += '<empresas>'
//		 	
//			cXml += '<filial'
//			cXml += ::tag('cdempresa'	,Z11->Z11_XEMP)
//			cXml += ::tag('cdfilial'	,Z11->Z11_XFIL)
//			cXml += ::tag('filial'		,SM0->M0_CODFIL)
//			cXml += ::tag('nmfilial'	,SM0->M0_FILIAL)
//			cXml += '/>'
//		
//			cXml += '</empresas>'	
		 	
			cXml += '</cliente>'		
		
		EndIf
	
 	Next nC

	cXml += '</clientes>'
	
	If AllTrim(cXml) == "<clientes></clientes>"
		cXml:=""
	EndIf
	
	MemoWrite("C:\TEMP\XML_" + cMetEnv + ".XML",cXml)

return cXml