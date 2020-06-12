#include 'protheus.ch'                                                         
/*-----------------+---------------------------------------------------------+
!Nome              ! TkPutProds                                              !
+------------------+---------------------------------------------------------+
!Descrição         ! Função para chamr o metodo Putprodutos via Menu         !
+------------------+---------------------------------------------------------+
!Autor             ! Rafael Vieceli                                          !
+------------------+---------------------------------------------------------!
!Data              ! 25/05/2018                                              !
+------------------+--------------------------------------------------------*/
User Function TkPutProds(lBatch)                                      
Private cPerg := padr("TPMETODO",10)                             
Default lBatch:=.F.

    // -> Se não for executado por job
	If! lBatch
		if !Pergunte(cPerg,.T.)
			Return .F.
		EndIf
	
		Do Case
			Case MV_PAR01 = 1
				TkProds("Post")			
			Case MV_PAR01 = 2
				TkProds("Put")			
			Case MV_PAR01 = 3
				TkProds("Delete")	
		EndCase
    EndIf
    
    // -> Se não for executado por job
	If lBatch
 		// -> Executa o processo para inclusão de produtos
 		TkProds("Post")			
 		// -> Executa o processo para alteração de produtos
 		TkProds("Put")			
 		// -> Executa o processo para exclusão de produtos
 		TkProds("Delete")			
    EndIf
    
Return


/*-----------------+---------------------------------------------------------+
!Nome              ! TkProds                                                 !
+------------------+---------------------------------------------------------+
!Descrição         ! Função para processar o WS                              !
+------------------+---------------------------------------------------------+
!Autor             ! Rafael Vieceli                                          !
+------------------+---------------------------------------------------------!
!Data              ! 25/05/2018                                              !
+------------------+--------------------------------------------------------*/
Static Function TkProds(cMetEnv)
Local oIntegra
Local cMethod	:= "PutProdutos"
Local cAlias	:= "Z13"
Local cAlRot	:= "SB1"
Local oEventLog := EventLog():start("Produtos - "+AllTrim(cMetEnv), Date(), "Iniciando processo de integracao...", cMetEnv, cAlias) 

	//instancia a classe
	oIntegra := TeknisaPutProdutos():new(cMethod, cMetEnv, cAlias, cAlRot, oEventLog)

	//se estiver ativo
	If oIntegra:isEnable()

		//busca os registros e se sequencia em lotes
		oIntegra:prepare()

		oIntegra:send()

	EndIF
	
	oEventLog:Finish()

return


/*-----------------+---------------------------------------------------------+
!Nome              ! TeknisaPutProdutos                                      !
+------------------+---------------------------------------------------------+
!Descrição         ! Classe PutProdutos                                      !
+------------------+---------------------------------------------------------+
!Autor             ! Rafael Vieceli                                          !
+------------------+---------------------------------------------------------!
!Data              ! 25/05/2018                                              !
+------------------+--------------------------------------------------------*/
class TeknisaPutProdutos from TeknisaMethodAbstract
Data oLog
Data cMetE

	method new() constructor
	method makeXml(aLote,cMetEnv)
	method analise(oXmlItem)
	
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
method new(cMethod, cMetEnv, cAlias, cAlRot, oEventLog) class TeknisaPutProdutos

	//inicialisa a classe
	::init(cMethod, cMetEnv, cAlias, cAlRot, oEventLog)
	::oLog :=oEventLog
	::cMetE:=cMetEnv

return


/*-----------------+---------------------------------------------------------+
!Nome              ! analise                                                 !
+------------------+---------------------------------------------------------+
!Descrição         ! Metodo para analizar e gravar os dados de retorno do WS !
+------------------+---------------------------------------------------------+
!Autor             ! Rafael Vieceli                                          !
+------------------+---------------------------------------------------------!
!Data              ! 25/05/2018                                              !
+------------------+--------------------------------------------------------*/
method analise(oXmlItem) class TeknisaPutProdutos
Local lIntegrado := .F.
Local cXEmp		:= ""
Local cXFil		:= ""
Local cErrorLog := ""
Local cCodProd  := ""
Local cCodTek   := ""
Local cCodArv   := ""
Local cQuery	:= ""
Private oItem := oXmlItem
                                  
	//verifica se a propriedade integrado existe
	If type("oItem:_CONFIRMACAO:_INTEGRADO:TEXT") == "C"

		cCodProd:=IIF(Type("oItem:_ID:_CODIGOPRODUTO:TEXT") == "C",oItem:_ID:_CODIGOPRODUTO:TEXT,"")
		cCodTek :=IIF(Type("oItem:_ID:_CDPRODUTO:TEXT")     == "C",oItem:_ID:_CDPRODUTO:TEXT    ,"")
		cCodArv :=IIF(Type("oItem:_ID:_CODIGOARVORE:TEXT")  == "C",oItem:_ID:_CODIGOARVORE:TEXT ,"")
		
		//agora testa se o conteudo é true
		lIntegrado := lower(oItem:_CONFIRMACAO:_INTEGRADO:TEXT) == "true"

		//se integrado OK, verifica se tem a chave para entrar o registro
		If lIntegrado

			lIntegrado := lIntegrado .And. !Empty(cCodProd)
			lIntegrado := lIntegrado .And. !Empty(cCodTek)
			
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

			// -> Se o código da árvore do produto do Teknisa não retornou, registra erro no log
			If Empty(cCodArv)
				cErrorLog:="Nao retornou o codigo da arvore do produto do Teknisa apos a chamada no metodo. [_CODIGOARVORE = " + IIF(Empty(cCodProd),"Vazio",cCodProd)+"]" 
				::oLog:broken("Retorno do XML.", cErrorLog, .T.)	
				ConOut(cErrorLog)
			EndIf	

		EndIF

	EndIF

	If lIntegrado
	
		cErrorLog:=": "+AllTrim(oItem:_ID:_CODIGOPRODUTO:TEXT)+": Atualizando status no ERP..." 
		::oLog:SetAddInfo("Retorno dos dados.",cErrorLog)
		ConOut(cErrorLog)

		//tabela de produtos
		dbSelectArea("Z13")
		Z13->( dbSetOrder(1) )
		Z13->( dbGoTop())
		Z13->( dbSeek( xFilial("Z13") + oItem:_ID:_CODIGOPRODUTO:TEXT ))

		lIntegrado := Z13->( Found() )

		If lIntegrado

			RecLock("Z13", .F.)
			Z13->Z13_XSTINT		:= "I" //Integrado
			Z13->Z13_XDINT		:= Date()
			Z13->Z13_XHINT		:= Time()
			Z13->Z13_XCODEX		:= oItem:_ID:_CDPRODUTO:TEXT
			Z13->Z13_XCDARV		:= oItem:_ID:_CODIGOARVORE:TEXT
			Z13->( msUnLock() )
			::oEventLog:setCountInc()
			
			//Grava Z17 - PutProdutosAtivar
			//******************************************
			//Posiciona na Unidade de Negócio
			cXEmp := ""  
			cXFil := "" 				
			dbSelectArea("ADK")
			ADK->( dbOrderNickName("ADKXFILI") )
			ADK->(dbGoTop())
			If ADK->(dbseek(xFilial("ADK")+cFilAnt))
				cXEmp := ADK->ADK_XEMP  
				cXFil := ADK->ADK_XFIL 
			EndIf

			cQuery := "	SELECT B1_FILIAL, B1_COD " + CRLF
			cQuery += "	FROM " + RetSqlName("SB1") + CRLF
			cQuery += "	WHERE B1_COD = '"+ oItem:_ID:_CODIGOPRODUTO:TEXT +"'" + CRLF  
			cQuery += "	AND D_E_L_E_T_ = ' ' " + CRLF
				
			cQuery := ChangeQuery(cQuery)
			cAlQry := MPSysOpenQuery(cQuery)
			
			While !(cAlQry)->( Eof() )
				dbSelectArea("SB1")
				SB1->(dbSetOrder(1))
				SB1->(dbGoTop())
				SB1->(dbSeek((cAlQry)->B1_FILIAL+(cAlQry)->B1_COD))

				If SB1->(found())
					RecLock("SB1",.F.)
					SB1->B1_XCODEXT		:= oItem:_ID:_CDPRODUTO:TEXT
					SB1->( msUnLock() )
				EndIf
				
				dbSelectArea("Z17")
				Z17->(dbSetOrder(1))
				Z17->(dbGoTop())
				Z17->(dbSeek((cAlQry)->B1_FILIAL+(cAlQry)->B1_COD))

				If Z17->(found())
					RecLock("Z17",.F.)
				Else
					RecLock("Z17",.T.)
					Z17->Z17_FILIAL		:= (cAlQry)->B1_FILIAL
					Z17->Z17_COD		:= Z13->Z13_COD
					Z17->Z17_DESC		:= Z13->Z13_DESC
					Z17->Z17_XCDARV		:= Z13->Z13_XCDARV	
					Z17->Z17_XSTINT		:= "P"
					Z17->Z17_XEMP		:= cXEmp
					Z17->Z17_XFIL		:= cXFil
				EndIf
				Z17->Z17_XCODEX		:= Z13->Z13_XCODEX
				Z17->Z17_XATIVO		:= If(SB1->B1_MSBLQL <> "1","S","N")
				Z17->( msUnLock() )

				dbSelectArea("Z14")
				Z14->(dbSetOrder(1))
				Z14->(dbGoTop())
				Z14->(dbSeek((cAlQry)->B1_FILIAL+(cAlQry)->B1_COD))

				If Z14->(found())
					RecLock("Z14",.F.)
					Z14->Z14_XCODEX		:= Z13->Z13_XCODEX
					Z14->( msUnLock() )
				EndIf
			
				(cAlQry)->(DbSkip())
	
			End
			
			(cAlQry)->(dbCloseArea())

			cErrorLog:="Ok." 
			::oLog:SetAddInfo("Retorno dos dados.",cErrorLog)
			ConOut(cErrorLog)
			
		Else

			cErrorLog:="Erro."
			::oLog:SetAddInfo("Retorno dos dados.",cErrorLog)
			ConOut(cErrorLog)		
		
		EndIf
    
    Else
		
		cErrorLog:="Nao foi poivel concluir a integracao do produto, verifique o XML retornado. [_CODIGOPRODUTO="+IIF(Empty(cCodProd),"Vazio",cCodProd)+" e _CDPRODUTO="+IIF(Empty(cCodTek),"Vazio",cCodTek)+"]" 
		::oLog:broken("Erro no processo de integracao.", cErrorLog, .T.)	
		ConOut("Erro: "+cErrorLog)
	
	EndIF

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
method makeXml(aLote,cMetEnv) class TeknisaPutProdutos
Local cXml
Local nC
Local aAlter	:= {}
Local nX		:= 0
Local cTamN1	:= TamSx3("Z18_COD")[1]
Local cTamN2	:= TamSx3("Z19_CODN2")[1]
Local cTamN3	:= TamSx3("Z20_CODN3")[1]
Local cTamN4	:= TamSx3("Z21_CODN4")[1]
Local cN1		:= ""
Local cN2		:= ""
Local cN3		:= ""
Local cN4		:= ""
Local cCodN1	:= ""
Local cDescN1	:= ""
Local cCodN2	:= ""
Local cDescN2	:= ""
Local cCodN3	:= ""
Local cDescN3	:= ""
Local cCodN4	:= ""
Local cDescN4	:= ""
Local cUMP	    := ""
Local cUMS	    := ""
Local cCodCEST  := ""
Local cGrpClie  := GetMv("MV_XGRCLIU",,"")
Local cErrorLog := ""
Local lErroXML  := .F.
	
	dbSelectArea("Z13")
	Z13->( dbSetOrder(1) )
	
	cXml := '<produtos>'   
	
	cErrorLog:=": Gerando XML..." 
	::oLog:SetAddInfo(cErrorLog,"Gerando XML...")
	ConOut(cErrorLog)
	
	lErroXML  := .F.
	For nC := 1 to len(aLote)

		cCodN1	:= ""
		cDescN1	:= ""
		cCodN2	:= ""
		cDescN2	:= ""
		cCodN3	:= ""
		cDescN3	:= ""
		cCodN4	:= ""                              
		cDescN4	:= ""
		cUMP	:= ""
		cUMS	:= ""
		cCodCEST:= ""
		lErroXML:= .F.

		If Lower(cMetEnv) != "delete"
		
			// -> posiciona no produto
			SB1->(DbGoTop())
			SB1->( dbGoTo(aLote[nC,01]) )
			If SB1->(Eof()) 
				lErroXML :=.T.
				cErrorLog:="Erro: Produto com RECNO " + AllTrim(Str(aLote[nC,01])) + " nao encontrado na SB1" 
				::oLog:broken("Erro na geracao do XML.", cErrorLog, .F.)	
				ConOut(cErrorLog)
			EndIf
			
			// -> Posiciona no grupo de tributação
			SF7->(DbGoTop())
			SF7->(DbOrderNickName("SF7GRPEST"))
			If SF7->(DbSeek(xFilial("SF7")+SB1->B1_GRTRIB+cGrpClie+SM0->M0_ESTENT))
				cCodCEST:=SF7->F7_SITTRIB
			Else
				If !Empty(SB1->B1_GRTRIB)
					lErroXML :=.F.
					cErrorLog:="Aviso: Nao encontrado tributacao para o grupo do produto, cliente e UF [B1_GRTRIB="+AllTrim(SB1->B1_GRTRIB)+", F7_GRPCLI="+cGrpClie+" e F7_EST="+SM0->M0_ESTENT+"]" 
					::oLog:SetAddInfo(cErrorLog,"Aviso de tributacao.")
					ConOut(cErrorLog)
				EndIf
			EndIf
			
			// -> Posiciona na tabela de unidades de medida - Principal
			SAH->(DbSetOrder(1))
			If SAH->(DbSeek(xFilial("SAH")+SB1->B1_UM))
			   cUMP := SAH->AH_XCODEX
			Else
				lErroXML :=.F.
				cErrorLog:="Aviso: Nao encontrado da primeira unidade de medida [AH_UNIMED="+SB1->B1_UM+"]" 
				::oLog:SetAddInfo(cErrorLog,"Aviso na geracao do XML.")
				ConOut(cErrorLog)
			EndIf
			
			// -> Posiciona na tabela de unidades de medida - Secundária
			SAH->(DbSetOrder(1))
			If SAH->(DbSeek(xFilial("SAH")+SB1->B1_SEGUM))
				cUMS := SAH->AH_UNIMED
			Else
				If !Empty(SB1->B1_SEGUM)
					lErroXML :=.F.
					cErrorLog:="Aviso: Nao encontrado da segunda unidade de medida [AH_UNIMED="+SB1->B1_SEGUM+"]" 
					::oLog:SetAddInfo(cErrorLog,"Aviso na geracao do XML.")
					ConOut(cErrorLog)
				EndIf				
			EndIf
			
			// -> Posiciona na tabela de produtos x unidades 
			Z13->( dbGoTop() )
			If !Z13->( dbSeek(xFilial("Z13") + SB1->B1_COD))
				lErroXML :=.T.
				cErrorLog:="Erro: Produto nao encontrado na tabela Z13. Verificar o cadastro de relacionamento entre codigo do Protheus e Teknisa. [Z13_COD="+AllTrim(SB1->B1_COD)+"]" 
				::oLog:broken("Erro na geracao do XML.", cErrorLog, .F.)	
				ConOut(cErrorLog)
			ElseIf Empty(Z13->Z13_XCODEX) .and. Lower(cMetEnv) == "put"
				lErroXML :=.T.
				cErrorLog:="Erro: Nao ha codigo de relacionamento do produto com o Teknisa. [Z13_COD="+AllTrim(SB1->B1_COD)+" e Z13_XCODEX=Vazio]" 
				::oLog:broken("Erro na geracao do XML.", cErrorLog, .F.)	
				ConOut(cErrorLog)
			ElseIf Empty(Z13->Z13_XCODEX) .and. !Empty(SB1->B1_XCODEXT)
				RecLock("Z13", .F.)
				Z13->Z13_XSTINT		:= "I" //Integrado
				Z13->Z13_XDINT		:= Date()
				Z13->Z13_XHINT		:= Time()
				Z13->Z13_XCODEX		:= SB1->B1_XCODEXT
				Z13->( msUnLock() )
				ErroXML :=.T.
			EndIf
	
            // -> Posiciona na tabela de produtos alternativos
			SGI->( dbGoTop() ) 
			SGI->( dbSeek(xFilial("SGI") + SB1->B1_COD))
			If SGI->( Found() )
				While !SGI->(Eof())
					aAdd(aAlter,{SGI->GI_PRODALT})
					SGI->(dbSkip())
				EndDo
			EndIf                              
			                   
			// -> Posiciona na tabea de nível 1  do Teknisa
			Z18->(DbSetOrder(1))
			If Z18->(DbSeek(xFilial("Z18")+SB1->B1_XN1))
				cCodN1  := Z18->Z18_COD
				cDescN1 := Z18->Z18_DESCN1
				
				// -> Posiciona na tabea de nível 2  do Teknisa
				Z19->(DbSetOrder(1))
				If Z19->(DbSeek(xFilial("Z19")+Z18->Z18_COD+SB1->B1_XN2))
					cCodN2	:= Z19->Z19_CODN2
					cDescN2	:= Z19->Z19_DESCN2
                Else
					lErroXML :=.F.
					cErrorLog:="Aviso: Nao encontrado cadastro do nivel 2 da estrutura do produto do Teknisa na tabela Z19.  [Z19_CODN1="+AllTrim(Z18->Z18_CODN1)+" e Z19_CODN2="+AllTrim(SB1->B1_XN2)+"]" 
					::oLog:SetAddInfo(cErrorLog,"Aviso na geracao do XML.")
					ConOut(cErrorLog)
                EndIf
                
				// -> Posiciona na tabea de nível 3  do Teknisa
				Z20->(DbSetOrder(1))
				If Z20->(DbSeek(xFilial("Z20")+Z19->Z19_CODN1+Z19->Z19_CODN2+SB1->B1_XN3))
					cCodN3	:= Z20->Z20_CODN3
					cDescN3	:= Z20->Z20_DESCN3
                Else
					lErroXML :=.F.
					cErrorLog:="Aviso: Nao encontrado cadastro do nivel 3 da estrutura do produto do Teknisa na tabela Z20.  [Z20_CODN1="+AllTrim(Z19->Z19_CODN1)+", Z20_CODN2="+AllTrim(Z19->Z19_CODN2)+" e Z20_CODN3="+AllTrim(SB1->B1_XN3)+"]" 
					::oLog:SetAddInfo(cErrorLog,"Aviso na geracao do XML.")
					ConOut(cErrorLog)
                EndIf
					
				// -> Posiciona na tabea de nível 4  do Teknisa
				Z21->(DbSetOrder(1))
				If Z21->(DbSeek(xFilial("Z21")+Z20->Z20_CODN1+Z20->Z20_CODN2+Z20->Z20_CODN3+SB1->B1_XN4))
					cCodN4	:= Z21->Z21_CODN4
					cDescN4	:= Z21->Z21_DESCN4
                Else
					lErroXML :=.F.
					cErrorLog:="Aviso: Nao encontrado cadastro do nivel 4 da estrutura do produto do Teknisa na tabela Z21.  [Z21_CODN1="+AllTrim(Z20->Z20_CODN1)+", Z21_CODN2="+AllTrim(Z20->Z20_CODN2)+", Z21_CODN3="+AllTrim(Z20->Z20_CODN3)+" e Z21_CODN4="+AllTrim(SB1->B1_XN4)+"]" 
					::oLog:SetAddInfo(cErrorLog,"Aviso na geracao do XML.")
					ConOut(cErrorLog)
                EndIf

			Else
				
				lErroXML :=.F.
				cErrorLog:="Aviso: Nao encontrado cadastro do nivel 1 da estrutura do produto do Teknisa na tabela Z18.  [Z18_COD="+AllTrim(SB1->B1_XN1)+"]" 
				::oLog:SetAddInfo(cErrorLog,"Aviso na geracao do XML.")
				ConOut(cErrorLog)

            EndIf                                                                

			// -> Se não ocorreu erro
			If !lErroXML
			
				cXml += '<produto>'

				cXml += '<id'
				cXml += ::tag('cdproduto'		,Z13->Z13_XCODEXT)
				cXml += ::tag('codigoproduto'	,SB1->B1_COD)
				cXml += '/>'
			
				cXml += '<cadastral'
				cXml += ::tag('nivel1'			,cCodN1)
				cXml += ::tag('dsnivel1'		,cDescN1)
				cXml += ::tag('nivel2'			,cCodN2)
				cXml += ::tag('dsnivel2'		,cDescN2)	
				cXml += ::tag('nivel3'			,cCodN3)
				cXml += ::tag('dsnivel3'		,cDescN3)	
				cXml += ::tag('nivel4'			,cCodN4)
				cXml += ::tag('dsnivel4'		,cDescN4)
				cXml += ::tag('grupo'			,SB1->B1_GRUPO)
				cXml += ::tag('nmprodut'		,SB1->B1_DESC)
				cXml += ::tag('tipo'			,SB1->B1_TIPO)
				cXml += ::tag('sunidade'		,cUMP)
				cXml += ::tag('local'			,SB1->B1_LOCPAD)
				cXml += ::tag('segunmedida'		,cUMS)
				cXml += ::tag('fatorconversao'	,SB1->B1_TIPCONV)
				cXml += ::tag('vrfatoconv'		,SB1->B1_CONV		,"decimal")
				cXml += ::tag('vrpreunit'		,SB1->B1_PRV1		,"decimal")
				cXml += ::tag('custostandard'	,SB1->B1_CUSTD		,"decimal")
				cXml += ::tag('pesobruto'		,SB1->B1_PESBRU		,"decimal")
				cXml += ::tag('vrpesounid'		,SB1->B1_PESO		,"decimal")
				cXml += ::tag('cdbarproduto'	,SB1->B1_CODBAR)
				cXml += ::tag('ncm'             ,SB1->B1_POSIPI)
				cXml += ::tag('origem'          ,SB1->B1_ORIGEM)
				cXml += ::tag('cdcest'          ,SB1->B1_CEST)			
				cXml += ::tag('ativo'			,If(SB1->B1_MSBLQL == "1","N","S"))
				cXml += '/>'
			
				cXml += '<alternativos>'
				If Len(aAlter) > 0
					For nX := 1 to Len(aAlter)
						cXml += '<alternativo'
						cXml += ::tag('codigoalternativo'	,aAlter[nX])
						cXml += '/>'
					Next nX
				Else
					cXml += '<alternativo'
					cXml += ::tag('codigoalternativo'	,"")
					cXml += '/>'
				EndIf
				cXml += '</alternativos>'
	
				cXml += '</produto>'
				
			EndIf	
			
		Else
		
			Z13->(dbGoTo(aLote[nC,02]))			
			If Z13->(Eof())
				lErroXML :=.T.
				cErrorLog:="Erro: Produto nao encontrado na tabela Z13. Verificar o cadastro de relacionamento entre codigo do Protheus e Teknisa." 
				::oLog:broken("Erro na geracao do XML.", cErrorLog, .F.)	
				ConOut(cErrorLog)
			ElseIf Empty(Z13->Z13_XCODEX) 
				lErroXML :=.T.
				cErrorLog:="Erro: Nao ha codigo de relacionamento do produto com o Teknisa. [Z13_COD="+AllTrim(Z13->Z13_COD)+" e Z13_XCODEX=Vazio]" 
				::oLog:broken("Erro na geracao do XML.", cErrorLog, .F.)	
				ConOut(cErrorLog)			
			EndIf
			
			cN1 := SubStr(Z13->Z13_XCDARV,1,cTamN1)
			cN2 := SubStr(Z13->Z13_XCDARV,cTamN1 + 1,cTamN2)
			cN3 := SubStr(Z13->Z13_XCDARV,cTamN1 + cTamN2 + 1,cTamN3)
			cN4 := SubStr(Z13->Z13_XCDARV,cTamN1 + cTamN2 + cTamN3 + 1,cTamN4)
		
			// -> Posiciona na tabea de nível 1  do Teknisa
			Z18->(DbSetOrder(1))
			If Z18->(DbSeek(xFilial("Z18")+cN1))
				cCodN1  := Z18->Z18_COD
				cDescN1 := Z18->Z18_DESCN1
				
				// -> Posiciona na tabea de nível 2  do Teknisa
				Z19->(DbSetOrder(1))
				If Z19->(DbSeek(xFilial("Z19")+Z18->Z18_COD+cN2))
					cCodN2	:= Z19->Z19_CODN2
					cDescN2	:= Z19->Z19_DESCN2
                Else
					lErroXML :=.F.
					cErrorLog:="Aviso: Nao encontrado cadastro do nivel 2 da estrutura do produto do Teknisa na tabela Z19.  [Z19_CODN1="+AllTrim(Z18->Z18_COD1)+" e Z19_CODN2="+AllTrim(cN2)+"]" 
					::oLog:SetAddInfo(cErrorLog,"Aviso de cadastro de niveis do codigo do produto no Teknisa.")
					ConOut(cErrorLog)
                EndIf
                
				// -> Posiciona na tabea de nível 3  do Teknisa
				Z20->(DbSetOrder(1))
				If Z20->(DbSeek(xFilial("Z20")+Z19->Z19_CODN1+Z19->Z19_CODN2+cN3))
					cCodN3	:= Z20->Z20_CODN3
					cDescN3	:= Z20->Z20_DESCN3
                Else
					lErroXML :=.F.
					cErrorLog:="Aviso: Nao encontrado cadastro do nivel 3 da estrutura do produto do Teknisa na tabela Z20.  [Z20_CODN1="+AllTrim(Z19->Z19_CODN1)+", Z20_CODN2="+AllTrim(Z19->Z19_CODN2)+" e Z20_CODN3="+AllTrim(cN3)+"]" 
					::oLog:SetAddInfo(cErrorLog,"Aviso de cadastro de niveis do codigo do produto no Teknisa.")
					ConOut(cErrorLog)
				EndIf
					
				// -> Posiciona na tabea de nível 4  do Teknisa
				Z21->(DbSetOrder(1))
				If Z21->(DbSeek(xFilial("Z21")+Z20->Z20_CODN1+Z20->Z20_CODN2+Z20->Z20_CODN3+cN4))
					cCodN4	:= Z21->Z21_CODN4
					cDescN4	:= Z21->Z21_DESCN4
                Else
					lErroXML :=.F.
					cErrorLog:="Aviso: Nao encontrado cadastro do nivel 4 da estrutura do produto do Teknisa na tabela Z21.  [Z21_CODN1="+AllTrim(Z20->Z20_CODN1)+", 	Z21_CODN2="+AllTrim(Z20->Z20_CODN2)+", Z21_CODN3="+AllTrim(Z20->Z20_CODN3)+" e Z21_CODN4="+AllTrim(cN4)+"]" 
					::oLog:SetAddInfo(cErrorLog,"Aviso de cadastro de niveis do codigo do produto no Teknisa.")
					ConOut(cErrorLog)
				EndIf

			Else
				
				lErroXML :=.F.
				cErrorLog:="Aviso: Nao encontrado cadastro do nivel 1 da estrutura do produto do Teknisa na tabela Z18.  [Z18_COD="+AllTrim(cN1)+"]" 
					::oLog:SetAddInfo(cErrorLog,"Aviso de cadastro de niveis do codigo do produto no Teknisa.")
				ConOut(cErrorLog)

            EndIf                                                                

			
			If !lErroXML
			
				cXml += '<produto>'
			
				cXml += '<id'
				cXml += ::tag('cdproduto'		,Z13->Z13_XCODEXT)
				cXml += ::tag('codigoproduto'	,Z13->Z13_COD)
				cXml += '/>'

				cXml += '<cadastral'                                                        
				cXml += ::tag('nivel1'			,cCodN1)
				cXml += ::tag('dsnivel1'		,cDescN1)
				cXml += ::tag('nivel2'			,cCodN2)
				cXml += ::tag('dsnivel2'		,cDescN2)
				cXml += ::tag('nivel3'			,cCodN3)
				cXml += ::tag('dsnivel3'		,cDescN3)
				cXml += ::tag('nivel4'			,cCodN4)
				cXml += ::tag('dsnivel4'		,cDescN4)
				cXml += ::tag('grupo'			,"")
				cXml += ::tag('nmprodut'		,"")
				cXml += ::tag('tipo'			,"")
				cXml += ::tag('sunidade'		,"")
				cXml += ::tag('local'			,"")
				cXml += ::tag('segunmedida'		,"")
				cXml += ::tag('fatorconversao'	,"")
				cXml += ::tag('vrfatoconv'		,"")
				cXml += ::tag('vrpreunit'		,"")
				cXml += ::tag('custostandard'	,"")
				cXml += ::tag('pesobruto'		,"")
				cXml += ::tag('vrpesounid'		,"")
				cXml += ::tag('cdbarproduto'	,"")
				cXml += ::tag('ncm'             ,"")
				cXml += ::tag('origem'          ,"")
				cXml += ::tag('cdcest'          ,"")			
				cXml += ::tag('ativo'			,"")
				cXml += '/>'
			
				cXml += '<alternativos>'
				cXml += '<alternativo'
				cXml += ::tag('codigoalternativo'	,"")
				cXml += '/>'
				cXml += '</alternativos>'
			
				cXml += '</produto>'
				
			EndIf
						
		EndIf

 	Next nC

	cXml += '</produtos>'
	
	If AllTrim(cXml) == "<produtos></produtos>"
		cXml:=""
	EndIf
	
	MemoWrite("C:\TEMP\XML_" + cMetEnv + ".XML",cXml)

return cXml