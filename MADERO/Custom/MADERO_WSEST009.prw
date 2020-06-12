#INCLUDE 'protheus.ch'
#INCLUDE "restful.ch"
/*                                                    
+------------------+-------------------------------------------------------------------------------+
! Nome             ! GetTiposMovimentacao                                                        !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! WS para gerar a lista de Tipos de Movimentacao do usuário                     !
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
WSRESTFUL GetTiposMovimentacao DESCRIPTION "Madero - Tipos de Movimentacao"

	WSDATA cdempresa AS STRING
	WSDATA cdfilial AS STRING


	WSMETHOD GET DESCRIPTION "Tipos de Movimentacao" WSSYNTAX "/GetTiposMovimentacao || /GetTiposMovimentacao/{id}"

End WSRESTFUL


/*                                                    
+------------------+-------------------------------------------------------------------------------+
! Nome             ! GetTiposMovimentacao                                                        !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! Implementação do método GET do WS para gerar a lista de Tipos de Movimentacao !
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
WSMETHOD GET WSRECEIVE cdempresa, cdfilial  WSSERVICE GetTiposMovimentacao

	Local cCodEmpTek 	:= Self:cdempresa
	Local cCodFilTek 	:= Self:cdfilial
	Local cXml			:= ""
	

	::SetContentType("application/xml")
	
    If Empty(cCodEmpTek) .Or. Empty(cCodFilTek)
        cXml := '<confirmacao integrado="False" mensagem="Parametros incorretos na requisicao" data="' + DtoS(Date()) + '" hora="' + Time() + '"/>'
    Else
        cXml := WSEST009(cCodEmpTek, cCodFilTek)
    EndIf

	::SetResponse(cXML)

Return .T.



/*                                                    
+------------------+-------------------------------------------------------------------------------+
! Nome             ! ProtheusGetTiposMovimentacao                                                !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! Implementação dda classe para o WS para gerar a lista de Tipos de Movimentacao!
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

Class ProtheusGetTiposMovimentacao From ProtheusMethodAbstract

	Method new(cMethod) constructor
	Method makeXml(aXMLData)

EndClass



/*  
+------------------+-------------------------------------------------------------------------------+
! Nome             ! ProtheusGetTiposMovimentacao                                                !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! Construtor da classe do WS para gerar a lista de Tipos de Movimentacao        !
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
Method New(cMethod) Class ProtheusGetTiposMovimentacao
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

Method makeXml(axTipo) Class ProtheusGetTiposMovimentacao

	Local cXml		:= ""
    Local nPos

	cXml := '<?xml version="1.0" encoding="ISO-8859-1"?>'
	
	cXml += '<retorno>'

	cXml += '<tipos>'
	
	FOR nPos := 1 TO LEN(axTipo)

		cXml += '<tipo'
		cXml += ::tag('cdmovimentacao'		,axTipo[nPos, 1])		
		cXml += ::tag('dsmovimentacao'		,axTipo[nPos, 2])
		cXml += '/>'

    NEXT nPos

	cXml += '</tipos>'	
	
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
! Nome             ! WSEST009                                                                      !
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
Static Function WSEST009(cCodEmpTek, cCodFilTek)
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
		ConOut("Selecionando tipos de movimentacao da filial "+ADK->ADK_XFIL )
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

        cQuery := "SELECT Z30_ID, F5_TEXTO FROM "+RetSqlName("Z30")+" Z30   "+ CRLF
        cQuery += "INNER JOIN "+RetSqlName("SF5")+" ON                      "+ CRLF
        cQuery += "	  (F5_CODIGO = Z30.Z30_ID)                              "+ CRLF
        cQuery += "	WHERE Z30.Z30_FILIAL = '"+xFilial("Z30") +"'  AND       "+ CRLF
		cQuery += "       Z30.D_E_L_E_T_ <> '*'                             "+ CRLF
        cQuery += "GROUP BY Z30.Z30_ID,F5_TEXTO                             "+ CRLF
		CONOUT(cQuery)
		cQuery := ChangeQuery(cQuery)
		cAlQry := MPSysOpenQuery(cQuery)
		If (cAlQry)->(Eof())
			lCont := .F.
			cAux := "Não há tipos de movimentação para esta filial."
		Else
			cXml := GeraArray(cAlQry)
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

Static Function GeraArray(cAlQry)
Local aTpMv		    :=  {}
Local lVer		    := .F.
Local lErro		    := .F.
Local cXml		    := ""
Local oTag			:= Nil
Local cTipMov		:= ""
Local cDescMov		:= ""
Local cLog			:= ""
Private aHeader   	:={} 
Private aCols     	:={}
Private n    	  	:=1

	oTag := ProtheusGetTiposMovimentacao():New("Tag")
	While !(cAlQry)->(Eof()) 
		
		
		cTipMov		    := (cAlQry)->Z30_ID
		cDescMov		:= (cAlQry)->F5_TEXTO
		
        aAdd(aTpMv,	{;	
			cValToChar(cTipMov),;		//[01] 	Tipo de movimentação Z30
			cValToChar(cDescMov),;		//[02]	Descrição de movimentação SF5
		})
		
		(cAlQry)->(dbSkip())
		
	EndDo
	
	(cAlQry)->(dbCloseArea())

	If Len(aTpMv) > 0 
		ConOut("-> Gerando XML...")
		cXml := oTag:MakeXml(aTpMv)
	Else	
	    lErro:=.T. 
		cXml := '<confirmacao integrado="' + If(!lErro,"true","false") + '" mensagem="' + IIF(lErro,cLog,"Processamento ok.") + '" data="' + DtoS(Date()) + '" hora="' + Time() + '"/>'
	EndIf
	
Return	cXml