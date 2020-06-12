#Include "Protheus.ch"

Static aEvtRot	:= TAFRotinas(,,.T.,2)
Static aSM0		:= FWLoadSM0()

//-------------------------------------------------------------------
/*/{Protheus.doc} TAFMigr001
Importação de arquivos históricos do eSocial 
para migração de software terceiros para o TAF
@author  Victor A. Barbosa
@since   04/10/2018
@version 1
/*/
//-------------------------------------------------------------------
Function TAFMigr001()

Private lInExec		:= .F. // Private por conta do controle de "click" e enable/disable dos objetos visuais.
Private aSlice		:= {}  // Private para guardar os registros que foram fatiados.
Private aSliced		:= {}  // Private para guardar a nomeclatura dos XMLs que foram "fatiados" e mover para outro diretório posteriormente.
Private aXMLCopy	:= {}  // Private para guardar os XMLs que tiveram êxito na importação e posteriormente mover para outra pasta.

If GetNewPar("MV_TAFAMBE") == "1"
	// Monta o Wizard
	Migr01Wizd()
Else
	MsgAlert("Para utilização do migrador, a empresa deverá estar operando em ambiente de produção.")
EndIf

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} Migr01Wizd
Monta o Wizard com os passos
@author  Victor A. Barbosa
@since   04/10/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function Migr01Wizd()

Local oPanel    := Nil
Local oNewPag   := Nil
Local oStepWiz  := Nil

oStepWiz := FWWizardControl():New()
oStepWiz:ActiveUISteps()
 
oNewPag := oStepWiz:AddStep("1")
oNewPag:SetStepDescription("Observações")
oNewPag:SetConstruction( { |Panel1| Migr01Pag1(Panel1) } )
oNewPag:SetNextAction( {|| .T. } )
oNewPag:SetCancelAction( {|| .T.} )

oNewPag := oStepWiz:AddStep("2")
oNewPag:SetStepDescription("Parâmetros e Processamento")
oNewPag:SetConstruction( { |Panel2| Migr01Pag2(Panel2) } )
oNewPag:SetNextAction( {|| !MigrInExec() } )
oNewPag:SetCancelAction( {|| .T. })

oNewPag:SetPrevWhen({|| !MigrInExec() })
oNewPag:SetCancelWhen({|| !MigrInExec() })

oStepWiz:Activate()

Return
 
//-------------------------------------------------------------------
/*/{Protheus.doc} Migr01Pag1
Painel com os descritivos da solução
@author  Victor A. Babrosa
@since   04/10/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function Migr01Pag1(oPanel)

TSay():New(25, 20, {||  TAFMigrText("BEMVINDO")      }, oPanel,,,,,,.T.,,,300,300,,,,,,.T.)
TSay():New(45, 20, {||  TAFMigrText("ASSIST")        }, oPanel,,,,,,.T.,,,300,300,,,,,,.T.)
TSay():New(95, 20, {||  TAFMigrText("TITETAPAS")     }, oPanel,,,,,,.T.,,,300,300,,,,,,.T.)
TSay():New(120, 25, {|| TAFMigrText("TEXTETAPAS")    }, oPanel,,,,,,.T.,,,300,300,,,,,,.T.)

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} Migr01Pag2
Painel com os parâmetros
@author  Victor A. Babrosa
@since   04/10/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function Migr01Pag2(oPanel)

Local cDirImp   	:= Space(150)
Local aSubDiret		:= {}
Local aItems    	:= {"Somente Importar", "Somente Processar", "Importar e Processar"}
Local oButtonFile   := Nil
Local oButtonProc	:= Nil
Local oSayFile  	:= Nil
Local oSayExec		:= Nil
Local oRadio		:= Nil
Local oGetFile		:= Nil
Local oGetThrd		:= Nil
Local nRadio		:= 1
Local cFilProc		:= ""
Local cNumThrd		:= Space(02)

oSayExec := TSay():New(20, 10, { || "Tipo de Execução" }, oPanel,,,,,, .T.,,, 200,20)

oRadio := TRadMenu():New(30, 10, aItems,, oPanel,,,,,,,, 100, 12,,,, .T.)
oRadio:bSetGet := { |u| Iif( PCount() == 0, nRadio, nRadio := u ) }

oSayExec := TSay():New(65, 10, { || "Nº de Threads: " }, oPanel,,,,,, .T.,,, 60,60)

oGetThrd := TGet():New(62, 55, { | u | If( PCount() == 0, cNumThrd, cNumThrd := u ) }, oPanel, 10, 10, "", { || VldNumThrd( @cNumThrd ) } , 0,,, .F.,, .T.,, .F.,, .F., .F.,, .F., .F.,, cNumThrd,,,,)
oGetThrd:Disable()

oSayFile := TSay():New(80, 10, { || "Diretório" }, oPanel,,,,,, .T.,,, 200,20)

oGetFile := TGet():New(90, 10, { || cDirImp }, oPanel, 160, 009, "",, 0,,, .F.,, .T.,, .F.,, .F., .F.,, .F., .F.,, cDirImp,,,,)
oButtonFile  := TButton():New( 90, 172, OemToAnsi("..."), oPanel, {|| aSubDiret := Migr01File(oButtonProc, @cDirImp) }, 25, 10,,, .F., .T., .F.,, .F.,,, .F.)

oButtonProc  := TButton():New( 120, 105, OemToAnsi("Processar"), oPanel, {|| Migr01Barra(oPanel, aSubDiret, oButtonFile, oButtonProc, oRadio, oGetFile, oGetThrd, nRadio, Val(cNumThrd) ) },; 
																							80, 15,,, .F., .T., .F.,, .F.,,, .F.)

If GetRemoteType() <> 5
	oSayExec:setCSS( TAFMigrCSS("TEXTTITLE") )
	oRadio:setCSS( TAFMigrCSS("RADIO") )
	oSayExec:setCSS( TAFMigrCSS("TEXTTITLE") )
	oButtonFile:setCSS( TAFMigrCSS("BTFILE") )
	oSayFile:setCSS( TAFMigrCSS("TEXTTITLE") )
	oButtonProc:setCSS( TAFMigrCSS("BTPROC") )
EndIf

// Seta ação no radio após definição dos componentes visuais
oRadio:bChange := { || Migr01Radio(nRadio, oButtonProc, oButtonFile, oGetFile, oGetThrd) }

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} Migr01File
Seleção do diretório a ser importado e validação da estrutura de pastas
@author  Victor A. Barbosa
@since   04/10/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function Migr01File(oButtonProc, cDirPai)

Local cDirImp	:= cGetFile('' , 'Diretório', 1, '\', .F., GETF_RETDIRECTORY,.T., .T.)
Local aSubDiret	:= {}
Local aSubOk	:= {}
Local nX		:= 0
Local nPosEmp	:= 0

If ExistDir(cDirImp)
	
	aSubDiret := Directory(cDirImp + "*.*", "D")

	If Len(aSubDiret) > 0
		For nX := 1 To Len(aSubDiret)
			nPosEmp := aScan( aSM0, { |x| x[18] == aSubDiret[nX][1] } )
			If nPosEmp > 0
				aAdd( aSubOk, {;
								cDirImp + aSubDiret[nX][1],;
								aSM0[nPosEmp][1],;
								aSM0[nPosEmp][2],;
								aSM0[nPosEmp][18];
							  };
					)
			EndIf
		Next nX
		
		If Len(aSubOk) > 0
			cDirPai := cDirImp
			oButtonProc:Enable()
		Else
			cDirImp := ""
			MsgAlert("Não foi encontrado nenhuma pasta com CNPJs informados no diretório.", "Atenção")
		EndIf
	Else
		cDirImp := ""
		MsgAlert("Não foram encontrados subdiretórios.")
	EndIf
Else
	cDirImp := ""
	MsgAlert("Diretório inválido", "Atenção")
EndIf

Return(aSubOk)

//-------------------------------------------------------------------
/*/{Protheus.doc} Migr01Barra
Monta a barra de progresso na parte de baixo do painel 2 da wizard
@author  Victor A. Barbosa
@since   04/10/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function Migr01Barra(oPanel, aSubDiret, oButtonFile, oButtonProc, oRadio, oGetFile, oGetThrd, nRadio, nNumThrd)

Local cTextProc	:= ""
Local nMeter	:= 0
Local oMeter	:= Nil
Local oSaySep	:= Nil
Local oSayProc	:= Nil
Local aFiles	:= {}

lInExec := .T.

// Desabilita os botões
oButtonFile:Disable()
oButtonProc:Disable()
oRadio:Disable()
oGetFile:Disable()
oGetThrd:Disable()

oSaySep := TSay():New(140, 02, { || Replicate("_", 150) }, oPanel,,,,,, .T.,,, 300,20)
oSaySep:setCSS( TAFMigrCSS("LINESEPARADOR") )

cTextProc := "Iniciando Processamento..."

oSayProc := TSay():New(170, 100, { || cTextProc }, oPanel,,,,,, .T.,,, 300,20)
oSayProc:setCSS( TAFMigrCSS("TEXTTITLE") )

oMeter := TMeter():New( 180, 100, { |u| Iif( Pcount() > 0, nMeter := u, nMeter) }, 100, oPanel, 100, 16,, .T.)
oMeter:setCSS("METER")
oMeter:SetTotal(0)
oMeter:Set(0)

// Chama as funções de processamento
Migr01Proc(aSubDiret, oSayProc, oMeter, nRadio, nNumThrd)

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} Migr01Proc
Encapsula as funções de processamento
@author  Victor A. Barbosa
@since   05/10/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function Migr01Proc(aSubDiret, oSay, oMeter, nRadio, nNumThrd)

Local aFilesXML := {}
Local nExec		:= 0
Local nQtdTot	:= 0
Local nX		:= 0

oSay:setText("Verificando diretório")
oSay:CtrlRefresh()

If nRadio == 1 .Or. nRadio == 3

	For nX := 1 To Len(aSubDiret)

		While Len( aFilesXML := Migr01Dir(aSubDiret[nX][1], nExec) ) > 0

			// Processa o lote de XML lido
			Migr01Lote(aFilesXML, oSay, oMeter, aSubDiret[nX][1], aSubDiret[nX][3], @nQtdTot, aSubDiret[nX][4])

			aFilesXML := {}
			aSize(aFilesXML, 0)
			nExec++
		EndDo

	Next nX

	// Se houve registros "fatiados", move o XML "fatiado" para outro diretório e processa os XMLs gerados
	If Len(aSliced) > 0
		
		If Len(aSliced) > 0
			FWMsgRun(, {|| Migr01Copy(aSliced) }, "Aguarde...", "Movendo XMLs consolidados para outro diretório." )
		EndIf

		//Processa os XMLs que foram gerados
		FWMsgRun(, {|oFWRun| Migr01Pend(oFWRun) }, "Aguarde...", "Verificando XMLs gerados através do Lote." )

	EndIf

	If Len(aXMLCopy) > 0
		FWMsgRun(, {|| Migr01Copy(aXMLCopy) }, "Aguarde...", "Movendo XMLs processados para outro diretório." )
	EndIf
	
EndIf

If nRadio == 2 .Or. nRadio == 3
	Migr01ToTAF(oSay, oMeter, nNumThrd)
EndIf

MsgAlert("Processamento Finalizado", "Atenção")
lInExec := .F.

If ValType(oMeter) <> "U"
	oSay:setText("Processamento Finalizado.")
	oMeter:Free()
EndIf

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} Migr01Dir
Retorna os XML's do diretório
Controla paginação dos arquivos, pois a função directory retorna 10.000 arquivos por vez
@author  Victor A. Barbosa
@since   04/10/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function Migr01Dir(cDirImp, nExec)

Local cFlagParameters := "N:" + cValToChar( (nExec * 10000) )
Local aFiles		  := {}

If Right(cDirImp, 1) <> "\"
	cDirImp += "\"
EndIf

aFiles := Directory(cDirImp + "*.xml", cFlagParameters)

Return(aFiles)

//-------------------------------------------------------------------
/*/{Protheus.doc} Migr01Lote
Processamento do lote de XML
@author  Victor A. Barbosa
@since   05/10/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function Migr01Lote(aFilesXML, oSay, oMeter, cDirImp, cFilProc, nQtdTot, cCNPJ)

Local nX 		:= 0
Local oVOMigr	:= TAFVOMigr():New()

oMeter:SetTotal( Len(aFilesXML) )

For nX := 1 To Len(aFilesXML)

	nQtdTot ++
	oMeter:Set(nX)
	oSay:setText("XMLs Processados: " + cValToChar(nQtdTot) )
	ProcessMessages() // Força atualização no smartclient

	oVOMigr:SetFileXML(aFilesXML[nX][1])

	//Realiza as valiadações e grava o XML na V2A
	Migr01Grv( oVOMigr, cDirImp, cFilProc, cCNPJ )

	oVOMigr:Clear()

Next nX

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} Migr01Grv
Realiza as validações e grava o XML na V2A
@author  Victor A. Barbosa
@since   05/10/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function Migr01Grv( oVOMigr, cPath, cFilProc, cCNPJ )

Local cMessage		:= ""
Local cV2AEnvio		:= "" // XML "Envio" gravado na V2A
Local cV2AReceipt	:= "" // XML "Recibo" gravado na V2A
Local cXMLESoc		:= "" // XML "Envio" lido do fileSystem
Local cXMLTratado	:= ""
Local cXMLEncode	:= ""
Local lInsert		:= .T.
Local lSuccess		:= .T.
Local oXML 			:= tXMLManager():New()
Local nPosFim		:= 0

V2A->( dbSetOrder(2) )

If Right(cPath, 1) <> "\"
	cPath += "\"
EndIf

cXMLTratado := Migr01Reader( cPath + oVOMigr:GetFileXML() )

If "<?xml" $ cXMLTratado
	nPosFim 	:= At(">", cXMLTratado)
	cXMLTratado := SubStr( cXMLTratado, nPosFim + 1)
	cXMLEncode  := EncodeUTF8(cXMLTratado)
	cXMLTratado := Iif( Empty(cXMLEncode), AllTrim(cXMLTratado), AllTrim(cXMLEncode) )
EndIf

// Se for retorno de XML em lote, transforma o lote em arquivos unitários e processa posteriormente.
If "ConsultarLoteEventosResponse" $ cXMLTratado
	Migr01Slice(cXMLTratado, cPath, cFilProc, cCNPJ)
	aAdd( aSliced, { cPath,; 
					oVOMigr:GetFileXML() } )
Else

	oVOMigr:SetXML( cXMLTratado )

	If oXml:Parse( oVOMigr:GetXML() ) // Faz o parser para garantir que é um válido

		// Valida o XML e retorna o tipo do mesmo
		nTipo := Migr01Type(oXML, oVOMigr, cCNPJ, cFilProc)

		If nTipo == 1 .Or. nTipo == 2
				
			If V2A->( MsSeek( xFilial("V2A") + oVOMigr:GetID() + oVOMigr:GetCNPJ() ) )
				lInsert     := .F.
				cV2AEnvio   := V2A->V2A_XMLERP
				cV2AReceipt := V2A->V2A_RECIBO
			EndIf

			// --> Se for alteração, verifica se o registro já foi integrado
			If !lInsert
				If V2A->V2A_STATUS == "5"
					lSuccess := .F.
					cMessage := "Registro já processado"
				EndIf

				// Validação para não efetuar a sobreposição das informações já existentes na base
				If V2A->V2A_STATUS <> '5' .And. nTipo == 1 .And. !Empty( oVOMigr:GetXML() ) .And. !Empty(cV2AEnvio)
					lSuccess := .F.
					cMessage := "XML de envio já informado, registro ignorado."

					// Guarda os XMLs que já foram processados para mover para o diretório de processado com sucesso
					aAdd( aXMLCopy, { cPath,; 
									oVOMigr:GetFileXML() } )

				EndIf

				If !Empty( oVOMigr:GetReceipt() ) .And. !Empty(cV2AReceipt)
					lSuccess := .F.
					cMessage := "XML de recibo já informado, registro ignorado."

					// Guarda os XMLs que já foram processados para mover para o diretório de processado com sucesso
					aAdd( aXMLCopy, { cPath,; 
									oVOMigr:GetFileXML() } )

				EndIf

			EndIf

			If lSuccess
					
				// Verifica o status do registro
				Migr01Status(oVOMigr, cV2AEnvio, cV2AReceipt, lInsert)
								
				If RecLock("V2A", lInsert)            
					V2A->V2A_FILIAL := xFilial( "V2A" )
					V2A->V2A_CNPJ	:= oVOMigr:GetCNPJ()

					If nTipo == 1
						V2A->V2A_XMLERP := oVOMigr:GetXML()
						V2A->V2A_EVENTO := oVOMigr:GetEvent()
						V2A->V2A_INDEVT	:= oVOMigr:GetTypeEvent()
						V2A->V2A_CHVERP := oVOMigr:GetFileXML()
						V2A->V2A_ALIAS	:= oVOMigr:GetAliasEvent()
						V2A->V2A_FILDES	:= MigrFilTAF(cCNPJ)
							
						If V2A->V2A_EVENTO == "S-3000"
							V2A->V2A_RECEXC	:= oVOMigr:GetDelReceipt()
						EndIf

					ElseIf nTipo == 2
						V2A->V2A_RECIBO := oVOMigr:GetReceipt()
						V2A->V2A_DHPROC	:= oVOMigr:GetTimeProc()

						// Verifica se existe o XML Totalizador
						If V2A->V2A_EVENTO $ "S-1200|S-1210|S-1295|S-1299|S-2299" 
							V2A->V2A_XMLTOT := Migr01Tot(oXML)
						EndIf

					EndIf

					V2A->V2A_CHVGOV := oVOMigr:GetId()
					V2A->V2A_STATUS := oVOMigr:GetStatus()
					V2A->( MsUnlock() )

					// Guarda os XMLs de sucesso para mover para outro diretório.
					aAdd( aXMLCopy, { cPath,; 
									oVOMigr:GetFileXML() } )

				Else
					cMessage := "Falha ao reservar registro para atualização, tente novamente."
					lSuccess := .F.
				EndIf
				
			EndIf

		EndIf
	Else
		ConOut(oVOMigr:GetId(), oVOMigr:GetFileXML(),"Arquivo XML inválido.", oVOMigr:GetEvent(), oVOMigr:GetTypeEvent() )
	EndIf

	If !Empty(cMessage)
		ConOut(oVOMigr:GetId(), oVOMigr:GetFileXML(),cMessage, oVOMigr:GetEvent(), oVOMigr:GetTypeEvent() )
	EndIf

EndIf


// Limpa da memória as classes de interfaces criadas por tXMLManager
DelClassIntF()

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} Migr01Type
Realiza a a validação do arquivo XML e retorna o mesmo por referência
@author  Victor A. Barbosa
@since   05/10/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function Migr01Type(oXML, oVOMigr, cCNPJ, cFilProc)

Local aChildXML		:= oXml:DOMGetChildArray()
Local cTagProt		:= "retornoenvioloteeventos"
Local cTagRetEvt	:= "retornoevento"
Local cTagRetProc	:= "retornoprocessamentoloteeventos"
Local cNameSpace	:= ""
Local cXMLTratado	:= ""
Local cStringXML	:= oVOMigr:GetXML()
Local nPosNS		:= 0
Local nPosNSEnd		:= 0
Local nType			:= 0
Local nPosEmp		:= aScan( aSM0, { |x| x[18] == cCNPJ } )
Local nPosEvt		:= 0
Local lHasReceipt	:= .F.

If Len(aChildXML) > 0
	
	nPosEvt	:= aScan( aEvtRot, {|x| Lower(x[9]) == Lower(aChildXML[1][1]) } )

	// Se não encontrou no nada no nó pai, verifica se no primeiro nível do filho existe algo
	If nPosEvt <= 0
		If Lower(aChildXML[1][1]) <> cTagRetEvt .And. Lower(aChildXML[1][1]) <> cTagRetProc
			oXML:DOMChildNode()
			aChildXML	:= oXml:DOMGetChildArray()

			If Len(aChildXML)
				nPosEvt	:= aScan( aEvtRot, {|x| Lower(x[9]) == Lower(aChildXML[1][1]) } )
			EndIf
		EndIf
	EndIf

	If Len(aChildXML) > 0

		If nPosEmp > 0

			Do Case
				Case nPosEvt > 0
					
					nType := 1

					// Utilizada para registrar o path do XML
					cXMLTratado := StrTran( cStringXML, "'", '"' )
					nPosNS		:= At( "xmlns", cXMLTratado ) + 7
					nPosNSEnd	:= At(">", cXMLTratado) - nPosNS - 1
					cNameSpace 	:= SubStr( cXMLTratado, nPosNS, nPosNSEnd  )

					oXml:XPathRegisterNS( "ns1", cNameSpace )

					oVOMigr:SetTagMain(aEvtRot[nPosEvt][9])
					oVOMigr:SetEvent(aEvtRot[nPosEvt][4])
					oVOMigr:SetAliasEvent( aEvtRot[nPosEvt][3] )
					oVOMigr:SetId( oXml:XPathGetAtt( "/ns1:eSocial/ns1:" + oVOMigr:GetTagMain() ,"Id") )
					
					// Seta o tipo do Evento
					Migr01TpEvt(oXML, cNameSpace, oVOMigr)

					// No evento S-3000 seta o protocolo do evento que está sendo excluído
					If oVOMigr:GetEvent() == "S-3000"
						Migr01Exc(oXML, oVOMigr)
					EndIf

				Case nPosEvt <= 0 .And. Lower(aChildXML[1][1]) == cTagRetProc .Or. Lower(aChildXML[1][1]) == cTagRetEvt
					nType 	:= 2
				Case nPosEvt <= 0 .And. Lower(aChildXML[1][1]) == cTagProt
					nType := 3
			EndCase

			// --> Verifica se obteve o retorno
			If nType == 2
					
				oVOMigr:SetId( Migr01ID( cStringXML, "Id" ) )
				lHasReceipt := Migr01Receipt(oXML, oVOMigr)

				// Se não encontrou o recibo no XML de retorno, devolve zero, para não gravar nada na V2A
				If !lHasReceipt
					nType := 0
				EndIf

			EndIf

			oVOMigr:SetCNPJ(cCNPJ)

		EndIf
	Else
		ConOut( "Nao foi possível obter os nos filhos do XML. Verifique o arquivo: " + oVOMigr:GetFileXML() )
	EndIf

Else
	ConOut( "Nao foi possível obter os nos filhos do XML. Verifique o arquivo: " + oVOMigr:GetFileXML() )
EndIf

Return( nType )

//-------------------------------------------------------------------
/*/{Protheus.doc} Migr01ID
Retorna o ID do XML
@author  Victor A. Barbosa
@since   05/10/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function Migr01ID(cXML,cAttId)

Local nAt  	:= 0
Local cURI 	:= ""
Local nSoma	:= Len( cAttId ) + 2

nAt := At( cAttId + '=', cXml )

If nAt > 0
	cURI:= SubStr( cXml, nAt + nSoma )
	nAt := At( '"', cURI )
	
	If nAt == 0
		nAt := At( "'", cURI )
	EndIf

	cURI	:= SubStr( cURI, 1, nAt-1 )

EndIf

Return( cUri )

//-------------------------------------------------------------------
/*/{Protheus.doc} Migr01Receipt
Retorna o recibo do arquivo xml
@author  Victor A. Barbosa
@since   03/10/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function Migr01Receipt(oXML, oVOMigr)

Local lFoundNode	:= .F.
Local cCodRet		:= ""

oXml:XPathRegisterNS( "ns1", "http://www.esocial.gov.br/schema/lote/eventos/envio/retornoProcessamento/v1_3_0" )
oXml:XPathRegisterNS( "ns2", "http://www.esocial.gov.br/schema/evt/retornoEvento/v1_2_0" )

// ContMatic
If oXml:XPathHasNode("/ns1:eSocial/ns1:retornoProcessamentoLoteEventos/ns1:retornoEventos")
	
	If oXml:XPathHasNode("/ns1:eSocial/ns1:retornoProcessamentoLoteEventos/ns1:status")
		cCodRet := oXml:XPathGetNodeValue("/ns1:eSocial/ns1:retornoProcessamentoLoteEventos/ns1:status/ns1:cdResposta")
	EndIf

	If cCodRet $ "201|202"
		If oXml:XPathHasNode("/ns1:eSocial/ns1:retornoProcessamentoLoteEventos/ns1:retornoEventos")
			If oXml:XPathHasNode("/ns1:eSocial/ns1:retornoProcessamentoLoteEventos/ns1:retornoEventos/ns1:evento/ns1:retornoEvento/ns2:eSocial/ns2:retornoEvento/ns2:recibo")
				lFoundNode 	:= .T.
				oVOMigr:SetReceipt(oXml:XPathGetNodeValue("/ns1:eSocial/ns1:retornoProcessamentoLoteEventos/ns1:retornoEventos/ns1:evento/ns1:retornoEvento/ns2:eSocial/ns2:retornoEvento/ns2:recibo/ns2:nrRecibo"))
				oVOMigr:SetTimeProc(oXml:XPathGetNodeValue("/ns1:eSocial/ns1:retornoProcessamentoLoteEventos/ns1:retornoEventos/ns1:evento/ns1:retornoEvento/ns2:eSocial/ns2:retornoEvento/ns2:processamento/ns2:dhProcessamento"))
			EndIf
		EndIf
	EndIf

// TSS - TOTVS Service Sped
ElseIf oXml:XPathHasNode("/evento/retornoEvento")

	If oXml:XPathHasNode("/evento/retornoEvento/ns2:eSocial/ns2:retornoEvento/ns2:processamento/ns2:cdResposta")
		cCodRet := oXml:XPathGetNodeValue("/evento/retornoEvento/ns2:eSocial/ns2:retornoEvento/ns2:processamento/ns2:cdResposta")
	EndIf

	If cCodRet $ "201|202"
		If oXml:XPathHasNode("/evento/retornoEvento/ns2:eSocial/ns2:retornoEvento/ns2:recibo")
			lFoundNode 	:= .T.
			oVOMigr:SetReceipt(oXml:XPathGetNodeValue("/evento/retornoEvento/ns2:eSocial/ns2 :retornoEvento/ns2:recibo/ns2:nrRecibo"))
			oVOMigr:SetTimeProc(oXml:XPathGetNodeValue("/evento/retornoEvento/ns2:eSocial/ns2:retornoEvento/ns2:processamento/ns2:dhProcessamento"))
		EndIf
	EndIf

// ProSoft
ElseIf oXml:XPathHasNode("/Prosoft/evento/retornoEvento")

	If oXml:XPathHasNode("/Prosoft/evento/retornoEvento/ns2:eSocial/ns2:retornoEvento/ns2:processamento/ns2:cdResposta")
		cCodRet := oXml:XPathGetNodeValue("/Prosoft/evento/retornoEvento/ns2:eSocial/ns2:retornoEvento/ns2:processamento/ns2:cdResposta")
	EndIf

	If cCodRet $ "201|202"
		If oXml:XPathHasNode("/Prosoft/evento/retornoEvento/ns2:eSocial/ns2:retornoEvento/ns2:recibo")
			lFoundNode 	:= .T.
			oVOMigr:SetReceipt(oXml:XPathGetNodeValue("/Prosoft/evento/retornoEvento/ns2:eSocial/ns2 :retornoEvento/ns2:recibo/ns2:nrRecibo"))
			oVOMigr:SetTimeProc(oXml:XPathGetNodeValue("/Prosoft/evento/retornoEvento/ns2:eSocial/ns2:retornoEvento/ns2:processamento/ns2:dhProcessamento"))
		EndIf
	EndIf

// Dominos
ElseIf oXml:XPathHasNode("/ns2:eSocial/ns2:retornoEvento")

	If oXml:XPathHasNode("/ns2:eSocial/ns2:retornoEvento/ns2:processamento/ns2:cdResposta")
		cCodRet := oXml:XPathGetNodeValue("/ns2:eSocial/ns2:retornoEvento/ns2:processamento/ns2:cdResposta")
	EndIf

	If cCodRet $ "201|202"
		If oXml:XPathHasNode("/ns2:eSocial/ns2:retornoEvento/ns2:recibo")
			lFoundNode := .T.
			oVOMigr:SetReceipt(oXml:XPathGetNodeValue("/ns2:eSocial/ns2:retornoEvento/ns2:recibo"))
			oVOMigr:SetTimeProc(oXml:XPathGetNodeValue("/ns2:eSocial/ns2:retornoEvento/ns2:processamento/ns2:dhProcessamento"))
		EndIf
	EndIf

// Sênior
ElseIf oXml:XPathHasNode("/eSocial/retornoEvento")
	
	If oXml:XPathHasNode("/eSocial/retornoEvento/processamento/cdResposta")
		cCodRet := oXml:XPathGetNodeValue("/eSocial/retornoEvento/processamento/cdResposta")
	EndIf

	If cCodRet $ "201|202"
		If oXml:XPathHasNode("/eSocial/retornoEvento/recibo")
			lFoundNode := .T.
			oVOMigr:SetReceipt(oXml:XPathGetNodeValue("/eSocial/retornoEvento/recibo"))
			oVOMigr:SetTimeProc(oXml:XPathGetNodeValue("/eSocial/retornoEvento/processamento/dhProcessamento"))
		EndIf
	EndIf

EndIf

Return(lFoundNode)

//-------------------------------------------------------------------
/*/{Protheus.doc} Migr01Status
Retorna o status de acordo com regras

Status Possíveis:
    1-Somente Envio
    2-Somente Término
    3-Completo sem Processar
    4-Envio Processado
    5-Completo Processado

**************************************************************************************
Regra para lInsert == false

(Obrigatoriamente o registro deve possuir ou "Recibo" ou "Envio" )
1 - Verifica se foi informado o XML de "Envio" de um "Recibo" informado anteriormente
2 - Verifica se foi informado o XML de "Recibo" de um "Envio" informado anteriormente
**************************************************************************************

@author  Victor A. Barbosa
@since   03/10/2018
@version 1
/*/
//-------------------------------------------------------------------
Function Migr01Status(oVOMigr, cV2AEnvio, cV2ARecibo, lInsert)

Local cStatusRet := ""
Local cXMLESoc	 := oVOMigr:GetXML()
Local cRecibo	 := oVOMigr:GetReceipt()

If lInsert // --> Persiste as regras de inclusão
    If !Empty(cXMLESoc) .And. Empty(cRecibo)
        cStatusRet := "1"
    ElseIf ( Empty(cXMLESoc) .Or. "retornoEvento" $ cXMLESoc) .And. !Empty(cRecibo)
        cStatusRet := "2"
    ElseIf !Empty(cXMLESoc) .And. !Empty(cRecibo)
        cStatusRet := "3"
    EndIf

Else // --> Persiste as regras de alteração
    If 	Empty(cV2AEnvio) .And. !Empty(cXMLESoc) .And. !Empty(cV2ARecibo) .Or.; 
		Empty(cV2ARecibo) .And. !Empty(cRecibo) .And. !Empty(cV2AEnvio) .Or.;
		Empty(cXMLESoc) .And. !Empty(cRecibo) .And. !Empty(cV2AEnvio) .And. !Empty(cV2ARecibo)
        cStatusRet := "3"
    EndIf
EndIf

oVOMigr:SetStatus(cStatusRet)

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} Migr01Reader
Leitura do arquivo XML
@author  Victor A. Barbosa
@since   09/10/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function Migr01Reader(cFileXML)

Local cBuffer	:= ""
Local aFileXML	:= TAFReadFl(cFileXML)

If aFileXML[2]
	cBuffer := aFileXML[3]
EndIf

Return(cBuffer)

//-------------------------------------------------------------------
/*/{Protheus.doc} Migr01Tot
Verifica se existe o XML Totalizador e seta o conteúdo no atributo
@author  Victor A. Barbosa
@since   23/10/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function Migr01Tot(oXML)

Local cString	:= ""

If oXML:XPathDelNode( "/evento/retornoEvento" )
	cString := oXML:Save2String()
EndIf

cString	:= StrTran(cString, '<?xml version="1.0">', '' )
cString	:= StrTran(cString, '<?xml version="1.0"?>', '' )

Return( cString )

//-------------------------------------------------------------------
/*/{Protheus.doc} Migr01Radio
Habilita/Desabilita as opções para pesquisar diretório de processamento
@author  Victor A. Barbosa
@since   04/10/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function Migr01Radio(nRadio, oButton, oButtonSrc, oGetDir, oGetThrd)

If nRadio == 1 .Or. nRadio == 3
	oGetDir:Enable()
	oButtonSrc:Enable()
Else
	oButtonSrc:Disable()
	oGetDir:Disable()
EndIf

If nRadio == 2 .Or. nRadio == 3
	oGetThrd:Enable()
Else
	oGetThrd:Disable()
EndIf

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} Migr01ToTAF
Chama a função de migração dos dados da tabela V2A para o TAF
@author  Victor A. Barbosa
@since   15/10/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function Migr01ToTAF(oSay, oMeter, nNumThrd)

TAFMigr002(oSay, oMeter, nNumThrd)

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} Migr01TpEVT
Seta o tipo do Evento
@author  Victor A. Barbosa
@since   24/10/2018
@version 1
/*/
//-------------------------------------------------------------------
Function Migr01TpEVT(oXML, cNameSpace, oVOMigr)

Local cXMLEvento    := oVOMigr:GetXML()

// Verifica o tipo de envio ao governo
If oXml:XPathHasNode("/ns1:eSocial/ns1:" + oVOMigr:GetTagMain() + "/ns1:ideEvento/ns1:indRetif")
    oVOMigr:SetTypeEvent(oXml:XPathGetNodeValue("/ns1:eSocial/ns1:" + oVOMigr:GetTagMain() + "/ns1:ideEvento/ns1:indRetif"))
EndIf

// Se está vazio é sinal que é evento de tabela ou totalizador que será analisado abaixo
If Empty( oVOMigr:GetTypeEvent() )
    If At( "<inclusao>", cXMLEvento ) > 0
        oVOMigr:SetTypeEvent("3")
    ElseIf At( "<alteracao>", cXMLEvento ) > 0
        oVOMigr:SetTypeEvent("4")
    ElseIf At( "<exclusao>", cXMLEvento ) > 0
        oVOMigr:SetTypeEvent("5")
    EndIf
EndIf

// Verifica se é evento totalizador ou evento de exclusão
If Empty( oVOMigr:GetTypeEvent() ) .And. oVOMigr:GetEvent() $ "S-1295|S-1299|S-1298|S-2190|S-3000|S-5001|S-5002|S-5011|S-5012"
    oVOMigr:SetTypeEvent("1")
EndIf

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} Migr01Exc
Seta o recibo de exclusão, no qual o S-3000 está excluindo.
@author  Victor A. Barbosa
@since   29/10/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function Migr01Exc(oXML, oVOMigr)

Local cRet := ""

oXml:XPathRegisterNS( "ns1", "http://www.esocial.gov.br/schema/evt/evtExclusao/v02_04_02" )

If oXml:XPathHasNode("/ns1:eSocial/ns1:evtExclusao/ns1:infoExclusao")
	oVOMigr:SetDelReceipt( oXml:XPathGetNodeValue("/ns1:eSocial/ns1:evtExclusao/ns1:infoExclusao/ns1:nrRecEvt") )
EndIf

Return(cRet)

//-------------------------------------------------------------------
/*/{Protheus.doc} MigrInExec
Retorna se o migrador está em execução de acordo com o semáforo
@author  Victor A. Barbosa
@since   04/10/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function MigrInExec()
Return( lInExec )

//-------------------------------------------------------------------
/*/{Protheus.doc} Migr01Slice
Transforma o lote de XMLs em arquivos XMLs unitários
@author  Victor A. Barbosa
@since   27/11/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function Migr01Slice(cXML, cPath, cFilProc, cCNPJ)

Local oXMLSlice := Nil
Local xTotaliz	:= Nil
Local xEvt		:= Nil
Local nPosIni	:= 0
Local nPosFim	:= 0
Local nX		:= 0
Local nY		:= 0
Local nQtdTot	:= 0
Local cWarning	:= ""
Local cError	:= ""

// Remove as informações de cabeçalho do lote e as tags de fechamento.
nPosIni	:= At( "<eSocial", cXML )
cXML 	:= SubStr(cXML, nPosIni )
nPosFim := rAt( "</eSocial>", cXML )
cXml 	:= SubStr(cXML, 1, nPosFim + 9 )

//Parser do XML para geração do outros arquivos
oXMLSlice 	:= XMLParser(cXML, "", @cError, @cWarning)

If Empty(cError) .And. Empty(cWarning)
	
	If XmlChildEx( oXMLSlice:_eSocial:_RetornoProcessamentoLoteEventos, "_RETORNOEVENTOS" ) <> Nil

		xEvt := oXMLSlice:_eSocial:_RetornoProcessamentoLoteEventos:_RetornoEventos:_Evento

		If ValType(xEvt) == "A"

			For nX := 1 To Len(xEvt)

				// Criação do "subxml" do retorno do recibo
				Migr01Create(xEvt[nX], cPath, cFilProc, cCNPJ, "rec", "")
				
				// Criação do "subxmls" dos totalizadores
				xTotaliz := XMLChildEx(xEvt[nX], "_TOT")

				If xTotaliz <> Nil
					If ValType(xTotaliz) == "A"
						For nY := 1 To Len(xTotaliz)
							Migr01Create(xTotaliz[nY], cPath, cFilProc, cCNPJ, "tot", xTotaliz[nY]:_TIPO:TEXT)
						Next nY
					ElseIf ValType(xTotaliz) == "O"
						Migr01Create(xTotaliz, cPath, cFilProc, cCNPJ, "tot", xTotaliz:_TIPO:TEXT)
					EndIf
				EndIf
			Next nX

		ElseIf ValType(xEvt) == "O"
			Migr01Create(xEvt, cPath, cFilProc, cCNPJ, "rec", "")
		EndIf
	Else
		ConOut( "Nó de Retorno não encontrado." )
	EndIf
Else
	ConOut( "Error: " + cError )
	ConOut( "Warning: " + cWarning )
EndIf

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} Migr01Create
Cria os arquivos XMLs
@author  Victor A. Barbosa
@since   27/11/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function Migr01Create(oEvento, cPath, cFilProc, cCNPJ, cPrefixo, cTotaliz)

Local cStrSlice  := XMLSaveStr(oEvento)
Local cDirNewXml := cPath + "slice_" + DTOS(Date()) + "\"
Local cIdXML	 := ""
Local cNomeXML	 := ""
Local nQtdFile	 := 2
Local nPosFim	 := 0
Local nPosIni	 := 0

If !ExistDir(cDirNewXml)
	MakeDir(cDirNewXml)
EndIf

If cPrefixo <> 'tot'
	cIdXML	:= oEvento:_ID:TEXT
Else
	// Verifica qual o tipo do totalizador
	Do Case 
		Case cTotaliz == "S5001"
			cIdXML	:= oEvento:_ESOCIAL:_EVTBASESTRAB:_ID:TEXT
		Case cTotaliz == "S5002"
			cIdXML	:= oEvento:_ESOCIAL:_EVTIRRFBENEF:_ID:TEXT
		Case cTotaliz == "S5011"
			cIdXML	:= oEvento:_ESOCIAL:_EVTCS:_ID:TEXT
		Case cTotaliz == "S5012"
			cIdXML	:= oEvento:_ESOCIAL:_EVTIRRF:_ID:TEXT
	EndCase
EndIf

cNomeXML := cIdXML + "_" + cPrefixo + "_" + cTotaliz + "_R1.xml"

// Remove as informações de cabeçalho do lote e as tags de fechamento.
nPosIni		:= At( "<eSocial", cStrSlice )
cStrSlice 	:= SubStr(cStrSlice, nPosIni )
nPosFim 	:= At( "</eSocial>", cStrSlice )
cStrSlice 	:= SubStr(cStrSlice, 1, nPosFim + 9 )
cStrSlice	:= FwNoAccent(cStrSlice)

//Se existir XML com o mesmo nome, não sobrepõe ... "Acumula" ...
While File(cDirNewXml + cNomeXML)
	cNomeXML := cIdXML + "_" + cPrefixo + "_" + cTotaliz + "_R" + cValToChar(nQtdFile) + ".xml"
	nQtdFile++
EndDo

If MemoWrite(cDirNewXml + cNomeXML , cStrSlice)
	aAdd( aSlice, {	cPath,;
					cDirNewXml,;
					cNomeXML,;
					cFilProc,;
					cCNPJ})
EndIf

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} Migr01Move
Move o arquivo passado por parâmetro para outro diretório
@author  Victor A. Barbosa
@since   27/11/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function Migr01Move(aFileXML, nCopy)

Local cPath		:= aFileXML[1]
Local cNomeFile := aFileXML[2]
Local cNewDir	:= cPath + "sliced_" + DTOS(Date()) + "\"

If nCopy == 1
	cNewDir	:= cPath + "sliced_" + DTOS(Date()) + "\"
ElseIf nCopy == 2
	cNewDir	:= cPath + "success_" + DTOS(Date()) + "\"
EndIf

If !ExistDir(cNewDir)
	MakeDir(cNewDir)
EndIf

__CopyFile(cPath + cNomeFile, cNewDir + cNomeFile)

FErase(cPath + cNomeFile)

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} Migr01Pend
Processa os arquivos pendentes (Gerados na hora de "fatiar")
@author  Victor A. Barbosa
@since   28/11/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function Migr01Pend(oFWRun)

Local nX 		:= 0
Local nQtdTot	:= Len(aSlice)
Local oVOMigr	:= TAFVOMigr():New()

For nX := 1 To nQtdTot
	
	SetIncPerc( oFWRun, "3", nQtdTot, nX )

	oVOMigr:SetFileXML( aSlice[nX][3] )
	
	Migr01Grv( oVOMigr, aSlice[nX][2], aSlice[nX][4], aSlice[nX][5] )

	oVOMigr:Clear()
Next nX

Return

/*/{Protheus.doc} VldNumThrd
Validação do número de threads
@type  Static Function
@author Diego Santos
@since 28-11-2018
@version version
@param param, param_type, param_descr
@return return, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function VldNumThrd( cNumThrd )

Local lRet := .T.

If !Empty(cNumThrd)
	If Val(cNumThrd) < 1 .Or. Val(cNumThrd) > 10
		lRet := .F.
		MsgInfo("O número de threads para este processo de ser um valor entre 1 e 10.", "Aviso")
	EndIf
EndIf

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} Migr01Copy
Encapsula a copia de arquivos em lote
@author  Victor A. Barbosa
@since   07/12/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function Migr01Copy(aXMLCopy)

Local nX := 0

For nX := 1 To Len(aXMLCopy)
	Migr01Move(aXMLCopy[nX], 2)
Next nX

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} MigrFilTAF
Retorna a Filial do TAF conforme CNPJ
@author  Victor A. Barbosa
@since   06/12/2018
@version 1
/*/
//-------------------------------------------------------------------
Function MigrFilTAF(cCNPJ)

Local aArea 	:= GetArea()
Local nPosEmp	:= 0
Local cFilSM0	:= ""
Local cFilTAF	:= ""

nPosEmp := aScan( aSM0, { |x| x[18] == cCNPJ } )

If nPosEmp > 0
	cFilSM0 := aSM0[nPosEmp][1] + aSM0[nPosEmp][2]
	cFilTAF := fTafGetFil(cFilSM0)
EndIf

RestArea(aArea)

Return(cFilTAF)