#INCLUDE 'protheus.ch'
#INCLUDE "restful.ch"
/*                                                    
+------------------+-------------------------------------------------------------------------------+
! Nome             ! GetProdutosARequisitar                                                        !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! WS para gerar a lista de produtos a requisitar do usuário                     !
!                  !                                                                               !
+------------------+-------------------------------------------------------------------------------+
! Autor            ! Paulo Gabriel França e Silva                                                  !
+------------------+-------------------------------------------------------------------------------+
! Data             ! 15/08/2018                                                                    !
+------------------+-------------------------------------------------------------------------------+
! Parametros       ! N/A                                                                           !
+------------------+-------------------------------------------------------------------------------+
! Retorno          ! N/A                                                                           !
+------------------+-------------------------------------------------------------------------------+
*/                                                                                
WSRESTFUL GetProdutosARequisitar DESCRIPTION "Madero - Produtos a Requisitar"

	WSDATA cdempresa AS STRING
	WSDATA cdfilial AS STRING
	WSDATA codtipmov AS STRING

	WSMETHOD GET DESCRIPTION "Produtos a Requisitar" WSSYNTAX "/GetProdutosARequisitar || /GetProdutosARequisitar/{id}"

End WSRESTFUL


/*                                                    
+------------------+-------------------------------------------------------------------------------+
! Nome             ! GetProdutosARequisitar                                                        !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! Implementação do método GET do WS para gerar a lista de produtos a requisitar !
!                  ! por usuário                                                                   !
+------------------+-------------------------------------------------------------------------------+
! Autor            ! Paulo Gabriel França e Silva                                                  !
+------------------+-------------------------------------------------------------------------------+
! Data             ! 15/08/2018                                                                    !
+------------------+-------------------------------------------------------------------------------+
! Parametros       ! N/A                                                                           !
+------------------+-------------------------------------------------------------------------------+
! Retorno          ! N/A                                                                           !
+------------------+-------------------------------------------------------------------------------+
*/                                                                                
WSMETHOD GET WSRECEIVE cdempresa, cdfilial, idusuario  WSSERVICE GetProdutosARequisitar

	Local cCodEmpTek 	:= Self:cdempresa
	Local cCodFilTek 	:= Self:cdfilial
	Local cTpMov 		:= PADR(Self:codtipmov,TAMSX3("Z30_ID")[1])
	Local cXml			:= ""
	

	::SetContentType("application/xml")
	
	If Empty(cCodEmpTek) .Or. Empty(cCodFilTek) .Or. Empty(cTpMov)
        cXml := '<confirmacao integrado="False" mensagem="Parametros incorretos na requisicao" data="' + DtoS(Date()) + '" hora="' + Time() + '"/>'
    Else
        cXml := WSEST010(cCodEmpTek, cCodFilTek, cTpMov)
    EndIf

	::SetResponse(cXML)

Return .T.



/*                                                    
+------------------+-------------------------------------------------------------------------------+
! Nome             ! ProtheusGetProdutosARequisitar                                                !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! Implementação dda classe para o WS para gerar a lista de produtos a requisitar!
!                  ! por usuário                                                                   !
+------------------+-------------------------------------------------------------------------------+
! Autor            ! Paulo Gabriel França e Silva                                                  !
+------------------+-------------------------------------------------------------------------------+
! Data             ! 15/08/2018                                                                    !
+------------------+-------------------------------------------------------------------------------+
! Parametros       ! N/A                                                                           !
+------------------+-------------------------------------------------------------------------------+
! Retorno          ! N/A                                                                           !
+------------------+-------------------------------------------------------------------------------+
*/                                                                                

Class ProtheusGetProdutosARequisitar From ProtheusMethodAbstract

	Method new(cMethod) constructor
	Method makeXml(aXMLData)

EndClass



/*  
+------------------+-------------------------------------------------------------------------------+
! Nome             ! ProtheusGetProdutosARequisitar                                                !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! Construtor da classe do WS para gerar a lista de produtos a requisitar        !
!                  ! por usuário                                                                   !
+------------------+-------------------------------------------------------------------------------+
! Autor            ! Paulo Gabriel França e Silva                                                  !
+------------------+-------------------------------------------------------------------------------+
! Data             ! 15/08/2018                                                                    !
+------------------+-------------------------------------------------------------------------------+
! Parametros       ! N/A                                                                           !
+------------------+-------------------------------------------------------------------------------+
! Retorno          ! N/A                                                                           !
+------------------+-------------------------------------------------------------------------------+
*/                                                                                
Method New(cMethod) Class ProtheusGetProdutosARequisitar
	::cMethod := cMethod
Return




/*  
+------------------+-------------------------------------------------------------------------------+
! Nome             ! makeXml                                                                       !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! Implementação do método makeXml da classe do WS para gerar a lista de produtos!
!                  !  a requisitar por usuário                                                     !
+------------------+-------------------------------------------------------------------------------+
! Autor            ! Paulo Gabriel França e Silva                                                  !
+------------------+-------------------------------------------------------------------------------+
! Data             ! 15/08/2018                                                                    !
+------------------+-------------------------------------------------------------------------------+
! Parametros       ! N/A                                                                           !
+------------------+-------------------------------------------------------------------------------+
! Retorno          ! N/A                                                                           !
+------------------+-------------------------------------------------------------------------------+
*/                                                                                

Method makeXml(axProd) Class ProtheusGetProdutosARequisitar

	Local cXml		:= ""
	Local nPos

	cXml := '<?xml version="1.0" encoding="ISO-8859-1"?>'
	
	cXml += '<retorno>'

	cXml += '<produtos>'
	
	FOR nPos := 1 TO LEN(axProd)

		cXml += '<produto'
		cXml += ::tag('cdproduto'		,axProd[nPos, 1])		
		cXml += ::tag('dsproduto'		,axProd[nPos, 2])	
		cXml += ::tag('cdgrupo'			,axProd[nPos, 3])	
		cXml += ::tag('dsgrupo'			,axProd[nPos, 4])	
		cXml += ::tag('unproduto'		,axProd[nPos, 5])	
		cXml += ::tag('uncompra'		,axProd[nPos, 6])	
		cXml += ::tag('dsfatorconv'		,axProd[nPos, 7])	
		cXml += ::tag('fatorconv'		,axProd[nPos, 8])	
		cXml += ::tag('cdcodfornec'		,axProd[nPos, 9])	
		cXml += ::tag('cdcodbar'		,axProd[nPos, 10])	
		cXml += ::tag('cdcodmov'		,axProd[nPos, 11])	
		cXml += ::tag('dscodmov'		,axProd[nPos, 12])	
		cXml += ::tag('qtdeestoque'		,axProd[nPos, 13])		
		cXml += '/>'

    NEXT nPos

	cXml += '</produtos>'	
	
	cXml += '<confirmacao>'
	
	cXml += '<confirmacao'
	cXml += ::tag('integrado'		,"true")			
	cXml += ::tag('mensagem'		,"Processamento ok.")
	cXml += ::tag('data'			,DtoS(Date()))		
	cXml += ::tag('hora'			,Time())	
	cXml += '/>'
	
	cXml += '</confirmacao>'

	cXml += '</retorno>'	

Return cXml

/*  
+------------------+-------------------------------------------------------------------------------+
! Nome             ! WSEST010                                                                      !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! Função para pesquisar os produtos por tipo de movimentação para o usuário     !
!                  !                                                                               !
+------------------+-------------------------------------------------------------------------------+
! Autor            ! Paulo Gabriel França e Silva                                                  !
+------------------+-------------------------------------------------------------------------------+
! Data             ! 15/08/2018                                                                    !
+------------------+-------------------------------------------------------------------------------+
! Parametros       ! N/A                                                                           !
+------------------+-------------------------------------------------------------------------------+
! Retorno          ! N/A                                                                           !
+------------------+-------------------------------------------------------------------------------+
*/                                                                                
Static Function WSEST010(cCodEmpTek, cCodFilTek, cTpMov)
Local cAux			:= ""
Local cXml			:= ""
Local lCont			:= .T.
Local lEmp			:= .T.
Local cQuery		:= 	""
Local aProd			:= {}
	
	lEmp := VerEmp(cCodEmpTek, cCodFilTek)
	
	If !lEmp
		lCont:= .F.
		cAux := "Filial nao encontrada no ERP Protheus. [ADK_XEMP="+cCodEmpTek+" e ADK_XFIL="+cCodFilTek+"]"
	Else 
		lCont := .T.
		ConOut("Selecionando produtos para requisicao de estoque na filial "+ADK->ADK_XFIL)
	EndIf
	
	// If lCont 
	// 	//Busca acessos
	// 	PswOrder( 1 )
	// 	If !PswSeek( cxUser, .T. ) 
	// 		lCont := .F.
	// 		cAux  := "Usuario nao cadastrado no Protheus. [USR_COD = "+ cxUser + "]"
	// 	EndIf
	// EndIf
		
	If lCont
		DBSelectArea("SBM")
		SBM->(DBSetOrder(1))
		
		cQuery := "SELECT B1_COD FROM "+RetSqlName("SB1")+" SB1												" + CRLF
		cQuery += "WHERE B1_GRUPO IN(SELECT Z30_GRPPRO FROM "+RetSqlName("Z30")+" WHERE Z30_ID ='"+cTpMov+"')" + CRLF
		cQuery += "	AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'												" + CRLF
		cQuery += "	AND SB1.B1_MSBLQL  <> '1'                  												" + CRLF
		cQuery += "	AND SB1.D_E_L_E_T_ <> '*'																" + CRLF
		cQuery += "UNION ALL																				" + CRLF
		cQuery += "SELECT B1_COD FROM "+RetSqlName("SB1")+" SB1												" + CRLF
		cQuery += "WHERE B1_COD IN(SELECT Z30_PROD FROM "+RetSqlName("Z30")+" WHERE Z30_ID ='"+cTpMov+"')	" + CRLF
		cQuery += "	AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'												" + CRLF
		cQuery += "	AND SB1.B1_MSBLQL  <> '1'                  												" + CRLF
		cQuery += "	AND SB1.D_E_L_E_T_ <> '*'																" + CRLF

		
		// cQuery := "SELECT DISTINCT SB1.B1_COD, Z30_ID " + CRLF
		// cQuery += "FROM " + RetSqlName("Z30") + " Z30 INNER JOIN " + RetSqlName("SB1") + " SB1 " + CRLF
		// cQuery += "ON Z30.Z30_FILIAL  = '"+xFilial("Z30") + "'   AND " + CRLF
		// cQuery += "	  Z30.Z30_GRPPRO  = SB1.B1_GRUPO             AND " + CRLF
		// cQuery += "   Z30.Z30_REGRA   = 'R'                      AND " + CRLF
		// cQuery += "   Z30.Z30_ROTINA  = 'MTA240'                 AND " + CRLF
		// cQuery += "   Z30.Z30_PROD    = ' '                      AND " + CRLF
		// cQuery += "   Z30.D_E_L_E_T_ <> '*'                          " + CRLF
		// cQuery += "	WHERE SB1.B1_FILIAL = '"+xFilial("SB1") +"'  AND " + CRLF
		// cQuery += "       SB1.B1_MSBLQL  <> '1'                  AND " + CRLF
		// cQuery += "       SB1.D_E_L_E_T_ <> '*'                      " 
		// cQuery += " UNION ALL  "                             + CRLF
		// cQuery += "SELECT DISTINCT SB1.B1_COD, Z30_ID " + CRLF
		// cQuery += "FROM " + RetSqlName("Z30") + " Z30 INNER JOIN " + RetSqlName("SB1") + " SB1 " + CRLF
		// cQuery += "ON Z30.Z30_FILIAL  = '"+xFilial("Z30") + "'   AND " + CRLF
		// cQuery += "	  Z30.Z30_PROD    = SB1.B1_COD               AND " + CRLF
		// cQuery += "   Z30.Z30_REGRA   = 'R'                      AND " + CRLF
		// cQuery += "   Z30.Z30_ROTINA  = 'MTA240'                 AND " + CRLF
		// cQuery += "   Z30.Z30_GRPPRO  = ' '                      AND " + CRLF
		// cQuery += "   Z30.D_E_L_E_T_ <> '*'                          " + CRLF
		// cQuery += "	WHERE SB1.B1_FILIAL = '"+xFilial("SB1") +"'  AND " + CRLF
		// cQuery += "       SB1.B1_MSBLQL  <> '1'                  AND " + CRLF
		// cQuery += "       SB1.D_E_L_E_T_ <> '*'                      " 
		// cQuery += "ORDER BY Z30_ID, B1_COD " 
		CONOUT(cQuery)
		cQuery := ChangeQuery(cQuery)
		cAlQry := MPSysOpenQuery(cQuery)
		If (cAlQry)->(Eof())
			lCont := .F.
			cAux := "Sem produtos para produtos para baixa."
		Else
			cXml := GeraArray(cTpMov, cAlQry)
		Endif
		
	Else	
		cXml := '<confirmacao integrado="' + If(lCont,"true","false") + '" mensagem="' + cAux + '" data="' + DtoS(Date()) + '" hora="' + Time() + '"/>'
		ConOut("Erro.")
	EndIf
	
	If !lCont
		cXml := '<confirmacao integrado="' + If(lCont,"true","false") + '" mensagem="' + cAux + '" data="' + DtoS(Date()) + '" hora="' + Time() + '"/>'
		ConOut("Erro.")
	Else
		ConOut("Ok.")	
	EndIf	

Return cXml



/*  
+------------------+-------------------------------------------------------------------------------+
! Nome             ! VerEmp                                                                        !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! Verifica os dados da filial de conexão                                        !
!                  !                                                                               !
+------------------+-------------------------------------------------------------------------------+
! Autor            ! Paulo Gabriel França e Silva                                                  !
+------------------+-------------------------------------------------------------------------------+
! Data             ! 15/08/2018                                                                    !
+------------------+-------------------------------------------------------------------------------+
! Parametros       ! N/A                                                                           !
+------------------+-------------------------------------------------------------------------------+
! Retorno          ! N/A                                                                           !
+------------------+-------------------------------------------------------------------------------+
*/                                                                                
Static Function VerEmp(xEmp, xFil)
Local lRet	:= .F.
Local xFili	:= ""
	
	dbSelectArea("ADK")

	cQuery := "	SELECT ADK_XFILI                " + CRLF
	cQuery += "	FROM  " + RetSqlName("ADK")       + CRLF
	cQuery += "	WHERE "                           + CRLF  
	cQuery += " ADK_XEMP   = '" + xEmp + "' AND " + CRLF
	cQuery += " ADK_XFIL   = '" + xFil + "' AND " + CRLF
	cQuery += "	D_E_L_E_T_ = ' '                " + CRLF
		
	cQuery := ChangeQuery(cQuery)
	cAlQry := MPSysOpenQuery(cQuery)
		
	If !(cAlQry)->(Eof())
		xFili := (cAlQry)->ADK_XFILI 
		dbCloseAll()	
		cEmpAnt	:= "02"
		cFilAnt	:= xFili
		cNumEmp := cEmpAnt+cFilAnt
		nModulo := 4
		OpenSM0(cEmpAnt+cFilAnt)
		OpenFile(cEmpAnt+cFilAnt) 
		lRet	:= .T.
	EndIf
Return lRet



/*  
+------------------+-------------------------------------------------------------------------------+
! Nome             ! GeraArray                                                                     !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! Retorna dados para geração do XML dos produtos e TM para o usuário            !
!                  !                                                                               !
+------------------+-------------------------------------------------------------------------------+
! Autor            ! Paulo Gabriel França e Silva                                                  !
+------------------+-------------------------------------------------------------------------------+
! Data             ! 15/08/2018                                                                    !
+------------------+-------------------------------------------------------------------------------+
! Parametros       ! N/A                                                                           !
+------------------+-------------------------------------------------------------------------------+
! Retorno          ! N/A                                                                           !
+------------------+-------------------------------------------------------------------------------+
*/                                                                                

Static Function GeraArray(cTpMov, cAlQry)
Local cRot 		    := "MTA240 "
Local cxProd 	    := "" 
Local cxGrupoP	    := "" 
Local cxID 		    := ""
Local aProd		    :=  {}
Local lVer		    := .T.
Local lErro		    := .F.
Local cXml		    := ""
Local oTag			:= Nil
Local cCodProd		:= ""
Local cDescProd		:= ""
Local cCodGrpProd	:= ""
Local cDescGrpProd	:= ""
Local cUMProd		:= ""
Local cUMCompProd	:= ""
Local cTipConv		:= ""
Local cFatConv		:= ""
Local cCodPrF		:= ""
Local cCodBar		:= ""
Local cTipMov		:= ""
Local cDescTipMov	:= ""
Local cQtdEst		:= ""
Local cLog			:= ""
Local nx
Private aHeader   	:={} 
Private aCols     	:={}
Private n    	  	:=1
	
	// -> Abre os arquivos
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	
	DbSelectArea("Z13")
	Z13->(DbSetOrder(1))	

	DbSelectArea("SBM")
	SBM->(DbSetOrder(1))
	
	DbSelectArea("SF5")
	SF5->(DbSetOrder(1))	
	
	DbSelectArea("SB2")
	SB2->(DbSetOrder(1))
	
	// for nx:=1 to len(axGrupoU)
	//    conout(axGrupoU[nx])
	// Next nx

	oTag := ProtheusGetProdutosARequisitar():New("Tag")
	While !(cAlQry)->(Eof()) 
		
		SB1->(DbSeek(xFilial("SB1")+(cAlQry)->B1_COD))
		
		cxProd 			:= SB1->B1_COD
		cxGrupoP		:= SB1->B1_GRUPO
		cxID 			:= cTpMov
		cCodProd		:= SB1->B1_XCODEXT
		cDescProd 		:= SB1->B1_DESC
		cCodGrpProd		:= SB1->B1_GRUPO
		cDescGrpProd	:= ""
		cUMProd			:= SB1->B1_UM
		cUMCompProd		:= ""
		cTipConv		:= ""
		cFatConv		:= ""
		cCodPrF			:= ""
		cCodBar			:= ""
		cTipMov			:= ""
		cDescTipMov		:= ""
		cQtdEst			:= ""
		
		// -> Valida se o usuário possui permissão para movimentar o produto
		//ConOut("-> "+AllTrim((cAlQry)->Z30_ID)+":"+AllTrim(SB1->B1_COD)+" - "+SB1->B1_DESC)
		//lVer :=	u_EST200RL(cRot,cxProd,cxGrupoP,cxUser,axGrupoU,cxID)
		If lVer

				
				// -> Posiciona no grupo do prouto
				If SBM->(DbSeek(xFilial("SBM")+SB1->B1_GRUPO))
					cDescGrpProd := SBM->BM_DESC
				Else
				   cLog +=AllTrim(cCodGrpProd)+": Grupo nao encontrado no Protheus " + Chr(13) + Chr(10)
					ConOut("   Grupo Produto: Erro.")
				EndIf
				
				// Declara variável utiliza em u_xSB1SC1
                aHeader   :={{,"C1_PRODUTO"       }} 
                aCols     :={{cxProd              }}
                n    	  :=1
				
				// -> Chama função para verificar se enontrou item na SA5 e se é valido (ativo).
				// -> Se não encontrou, considera os dados do produto da SB1
                If !u_xSB1SC1("C1_PRODUTO","F",.T.) 			
                	cUMCompProd	:= 	SB1->B1_UM
					cTipConv	:=	"M"
					cFatConv	:=	1
					cCodPrF		:=	""
					cCodBar		:=	SB1->B1_CODBAR
                Else
                	cUMCompProd	:=	SA5->A5_UNID
					cTipConv	:=	SA5->A5_XTPCUNF
					cFatConv	:=	SA5->A5_XCVUNF
					cCodPrF		:=	SA5->A5_CODPRF
					cCodBar		:= 	SA5->A5_CODBAR
				Endif

				If SF5->(DbSeek(xFilial("SF5")+cTpMov))
					cTipMov		:=	SF5->F5_CODIGO
					cDescTipMov	:=	SF5->F5_TEXTO				
				Else
					cLog +=cTpMov+": Tipo de movimentação não encontrada no Protheus. " + Chr(13) + Chr(10)	
				   ConOut("   TM: Erro.")				   				
				EndIF
				
				If SB2->(DbSeek(xFilial("SB2")+SB1->B1_COD+SB1->B1_LOCPAD))
					cQtdEst := SaldoSB2()
				Else
					cQtdEst := 0
				EndIf
				
				aAdd(aProd,	{;	
						cValToChar(cCodProd),;		//[01] 	Código do Produto
						cValToChar(cDescProd),;		//[02]	Descrição do Produto
						cValToChar(cCodGrpProd),;	//[03]	Código do grupo do produto
						cValToChar(cDescGrpProd),;	//[04]	Descrição do grupo do produto
						cValToChar(cUMProd),;		//[05]	Unidade de medida do produto
						cValToChar(cUMCompProd),;	//[06]	Unidade de medida de compra
						cValToChar(cTipConv),;		//[07]	Tipo de conversão
						cValToChar(cFatConv),;		//[08]	Fator de conversão
						cValToChar(cCodPrF),;		//[09]	Código do produto no fornecedor
						cValToChar(cCodBar),;		//[10]	Código de barras do produto no fornecedor
						cValToChar(cTipMov),;		//[11]	Tipo de movimentação
						cValToChar(cDescTipMov),;	//[12]	Descrição do tipo de movimentação
						cValToChar(cQtdEst);		//[13]	Quantitade atual em estoque
		    		})				
					
		EndIf
		
		(cAlQry)->(dbSkip())
		
	EndDo
	
	(cAlQry)->(dbCloseArea())

	If Len(aProd) > 0 
		ConOut("-> Gerando XML...")
		cXml := oTag:MakeXml(aProd)
	Else	
	    lErro:=.T. 
		cXml := '<confirmacao integrado="' + If(!lErro,"true","false") + '" mensagem="' + IIF(lErro,cLog,"Processamento ok.") + '" data="' + DtoS(Date()) + '" hora="' + Time() + '"/>'
	EndIf
	
Return	cXml