#INCLUDE "Fisa022.ch"    
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWIZARD.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "APWEBSRV.CH"        
#DEFINE TAMMAXXML 400000  //- Tamanho maximo do XML em bytes  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Fisa022   ³ Autor ³ Roberto Souza         ³ Data ³21/05/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Programa de controle de Nota Fiscal de Serviço Eletrônica.  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß


/*/
Function Fisa022()  

Local aArea       		:= GetArea()     

Local cCodMun     		:= SM0->M0_CODMUN
Local cUsaColab	  := GetNewPar("MV_SPEDCOL","N")
Local cUSERNEOG	  := GetNewPar("MV_USERCOL","")
Local cPASSWORD	  := GetNewPar("MV_PASSCOL","")
Local cCONFALL	   	:= GetNewPar("MV_CONFALL","N") 
Local cDocsColab  := GetNewPar("MV_DOCSCOL","0")
Local cConteudo   := ""

Local nRetCol	  := GetNewPar("MV_NRETCOL",10)
Local nAmbCTeC	  := GetNewPar("MV_AMBCTEC",2)
Local nAmbNFeC	  := GetNewPar("MV_AMBICOL",2)

Local lRetorno    := .T.
Local lOk         := .F.

Local oWs

Private cURL       := Padr(GetNewPar("MV_SPEDURL","http://localhost:8080/nfse"),250)
Private cInscMun   := Alltrim(SM0->M0_INSCM)
Private cIdEnt     := GetIdEnt()
Private cVerTSS    := ""
Private cTypeaXML  := ""

Private lBtnFiltro := .F.
Private lDirCert   := .T.  
Private cEntSai	   := "1"
Private aUf		   := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Preenchimento do Array de UF                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aadd(aUF,{"RO","11"})
aadd(aUF,{"AC","12"})
aadd(aUF,{"AM","13"})
aadd(aUF,{"RR","14"})
aadd(aUF,{"PA","15"})
aadd(aUF,{"AP","16"})
aadd(aUF,{"TO","17"})
aadd(aUF,{"MA","21"})
aadd(aUF,{"PI","22"})
aadd(aUF,{"CE","23"})
aadd(aUF,{"RN","24"})
aadd(aUF,{"PB","25"})
aadd(aUF,{"PE","26"})
aadd(aUF,{"AL","27"})
aadd(aUF,{"MG","31"})
aadd(aUF,{"ES","32"})
aadd(aUF,{"RJ","33"})
aadd(aUF,{"SP","35"})
aadd(aUF,{"PR","41"})
aadd(aUF,{"SC","42"})
aadd(aUF,{"RS","43"})
aadd(aUF,{"MS","50"})
aadd(aUF,{"MT","51"})
aadd(aUF,{"GO","52"})
aadd(aUF,{"DF","53"})
aadd(aUF,{"SE","28"})
aadd(aUF,{"BA","29"})
aadd(aUF,{"EX","99"})
	  

//Montagem das perguntas
oWs:= WsSpedCfgNFe():New()
oWs:cUSERTOKEN      := "TOTVS"
oWs:cID_ENT         := cIdEnt
oWS:_URL            := AllTrim(cURL)+"/SPEDCFGNFe.apw"
lOk                 := IsReady(cCodMun, cURL, 1) // Mudar o terceiro parâmetro para 2 após o código de município 003 ter sido homologado no método CFGREADYX do serviço NFSE001

If !( lOk )

	If Empty(cIdEnt)
		cVerTss := "1.28"
	EndIf
	
	// Caso não se tenha uma conexão ou certificado configurado corretamente no TSS, chama o wizard de configuração
	Fisa022Cfg()
	lOk	:= IsReady(cCodMun, cURL, 1)
	
EndIf

If lOk
	lOk 	:= oWs:CfgTSSVersao()
	cVerTss := oWs:cCfgTSSVersaoResult
EndIf

	
If lOk .And. oWs:cCfgTssVersaoResult >= "1.35"
	oWS:cUSERTOKEN := "TOTVS"
	oWS:cID_ENT    := cIdEnt			
	oWS:cUSACOLAB  := cUsaColab
	oWS:nNUMRETNF  := nRetCol
	oWS:nAMBIENTE  := 0
	oWS:nMODALIDADE:= 0
	oWS:cVERSAONFE := ""
	oWS:cVERSAONSE := ""
	oWS:cVERSAODPEC:= ""
	oWS:cVERSAOCTE := ""
	oWS:cUSERNEOG  := cUSERNEOG
	oWS:cPASSWORD  := cPASSWORD
	oWS:cCONFALL   := cCONFALL   
	
	IF oWs:cCfgTssVersaoResult >= "1.43"
		If "1" $ Upper(cDocsColab)
    		cConteudo += "1"
   		EndiF
   		If "2" $ Upper(cDocsColab)
   			cConteudo += "2"
   		EndIF
   		If "3" $ Upper(cDocsColab)
   			cConteudo += "3"
   		EndIF                    
   		If "4" $ Upper(cDocsColab)
			cConteudo := "4"
    	EndIF
    	If "0" $ Upper(cDocsColab)
    		cConteudo := "0"
   		EndIF				 
		oWS:cDOCSCOL	:= cConteudo
		oWS:nAMBNFECOLAB:= IIF(nAmbNFeC >= 1 .And. nAmbNFeC <=2,nAmbNFeC,2)
		oWS:nAMBCTECOLAB:= IIF(nAmbCTeC >= 1 .And. nAmbCTeC <=2,nAmbCTeC,2)
	EndIF 
	
	oWS:_URL       := AllTrim(cURL)+"/SPEDCFGNFe.apw"
	ExecWSRet(oWS,"CFGPARAMSPED")		
Else
	lRetorno := .F.
EndIf	

While lRetorno
	lBtnFiltro:= .F.
    lRetorno := Fisa022Brw(cCodMun)
    If !lBtnFiltro
    	Exit
    EndIf
EndDo
RestArea(aArea)
Return Nil

Static Function Fisa022Brw(cCodMun)
Local aPerg     := {}
Local aCores    := {}
Local lRetorno  := .T.
Local aIndArq   := {}
Local cParBrw   := SM0->M0_CODIGO+SM0->M0_CODFIL+"Fisa022"

PRIVATE cCondicao := ""
PRIVATE aRotina   := {}
PRIVATE cCadastro := STR0001 +"Entidade: "+cIdEnt+" - TSS: "+cVerTss //"Monitoramento da NFe-SEFAZ"
PRIVATE bFiltraBrw
  

If Fisa022Ok(cCodMun)

	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem das perguntas                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	aadd(aPerg,{2,STR0075,PadR("",Len("2-Entrada")),{STR0076,STR0077},120,".T.",.T.,".T."}) //"Tipo de NFe"###"1-Saída"###"2-Entrada"
	aadd(aPerg,{2,STR0082,PadR("",Len("5-Não Transmitidas")),{STR0083,STR0084,STR0110,STR0111,STR0112},120,".T.",.T.,".T."}) //"Filtra"###"1-Autorizadas"###"2-Sem filtro"###"3-Não Autorizadas"###"4-Transmitidas"###"5-Não Transmitidas"
	aadd(aPerg,{1,STR0010,PadR("",Len(SF2->F2_SERIE)),"",".T.","",".T.",30,.F.})	//"Serie da Nota Fiscal"

//	aParam[01] := ParamLoad(cParBrw,aPerg,1,aParam[01])
//	aParam[02] := ParamLoad(cParBrw,aPerg,2,aParam[02])
//	aParam[03] := ParamLoad(cParBrw,aPerg,3,aParam[03])

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se o serviço foi configurado - Somente o Adm pode configurar   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If ParamBox(aPerg,"NFS-e",,,,,,,,cParBrw,.T.,.T.)   
		If SubStr(MV_PAR01,1,1) == "1"
		    	cEntSai	  := "1"	
				aCores    := {{"F2_FIMP==' '",'DISABLE' },;	//NF não transmitida
						{"F2_FIMP=='S'",'ENABLE'},;		//NF Autorizada
						{"F2_FIMP=='T'",'BR_AZUL'},;	//NF Transmitida
						{"F2_FIMP=='D'",'BR_CINZA'},;	//NF Uso Denegado
						{"F2_FIMP=='N'",'BR_PRETO'}}	//NF nao autorizada 
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Realiza a Filtragem                                                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
			cCondicao := "F2_FILIAL=='"+xFilial("SF2")+"'"
			If !Empty(MV_PAR03)
				cCondicao += ".AND.F2_SERIE=='"+MV_PAR03+"'"
			EndIf
			If SubStr(MV_PAR02,1,1) == "2" 			//"1-NF Autorizada"
				cCondicao += ".AND. F2_FIMP$'S' "
			ElseIf SubStr(MV_PAR02,1,1) == "3" 		//"3-Não Autorizadas"
				cCondicao += ".AND. F2_FIMP$'N' "
			ElseIf SubStr(MV_PAR02,1,1) == "4" 		//"4-Transmitidas"
				cCondicao +=  ".AND. F2_FIMP$'T' "
			ElseIf SubStr(MV_PAR02,1,1) == "5" 		//"5-Não Transmitidas"
				cCondicao += ".AND. F2_FIMP$' ' " 			
			EndIf
		//	cCondicao += ".AND. F2_ESPECIE$'"+AllTrim(cTipoNfd)+"'"
			
			aRotina   := Fisa022Men(cCodMun)    
		
			bFiltraBrw := {|| FilBrowse("SF2",@aIndArq,@cCondicao) }
			Eval(bFiltraBrw)
			mBrowse( 6, 1,22,75,"SF2",,,,,,aCores,/*cTopFun*/,/*cBotFun*/,/*nFreeze*/,/*bParBloco*/,/*lNoTopFilter*/,.F.,.F.,)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Restaura a integridade da rotina                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
			dbSelectArea("SF2")
			RetIndex("SF2")
			dbClearFilter()
			aEval(aIndArq,{|x| Ferase(x[1]+OrdBagExt())})
			
		ElseIf SubStr(MV_PAR01,1,1) == "2" .And. cVerTss >= "2.02"
			cEntSai	  := "0"
			If SF1->(FieldPos("F1_FIMP"))>0
				aCores    := {{"F1_FIMP==' ' .AND. AllTrim(F1_ESPECIE)=='SPED'",'DISABLE' },;	//NF não transmitida
							  {"F1_FIMP=='S'",'ENABLE'},;									//NF Autorizada
							  {"F1_FIMP=='T'",'BR_AZUL'},;									//NF Transmitida
							  {"F1_FIMP=='D'",'BR_CINZA'},;									//NF Uso Denegado							  
							  {"F1_FIMP=='N'",'BR_PRETO'}}									//NF nao autorizada		
			Else
				aCores := Nil
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Realiza a Filtragem                                                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cCondicao := "F1_FILIAL=='"+xFilial("SF1")+"'"
			If !Empty(MV_PAR03)
				cCondicao += ".AND.F1_SERIE=='"+MV_PAR03+"'"
			EndIf
			If SubStr(MV_PAR02,1,1) == "2" .And. SF1->(FieldPos("F1_FIMP"))>0 //"1-NF Autorizada"
				cCondicao += ".AND. F1_FIMP$'S' "
			ElseIf SubStr(MV_PAR02,1,1) == "3" .And. SF1->(FieldPos("F1_FIMP"))>0 //"3-Não Autorizadas"
				cCondicao += ".AND. F1_FIMP$'N' "
			ElseIf SubStr(MV_PAR02,1,1) == "4" .And. SF1->(FieldPos("F1_FIMP"))>0 //"4-Transmitidas"
				cCondicao += ".AND. F1_FIMP$'T' "        			
			ElseIf SubStr(MV_PAR02,1,1) == "5" .And. SF1->(FieldPos("F1_FIMP"))>0 //"5-Não Transmitidas"
				cCondicao += ".AND. F1_FIMP$' ' "				
			EndIf
			
			aRotina   := Fisa022Men(cCodMun)									
		
			bFiltraBrw := {|| FilBrowse("SF1",@aIndArq,@cCondicao) }
			Eval(bFiltraBrw)
			mBrowse( 6, 1,22,75,"SF1",,,,,,aCores,/*cTopFun*/,/*cBotFun*/,/*nFreeze*/,/*bParBloco*/,/*lNoTopFilter*/,.F.,.F.,)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Restaura a integridade da rotina                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SF1")
			RetIndex("SF1")
			dbClearFilter()
			aEval(aIndArq,{|x| Ferase(x[1]+OrdBagExt())})
		
		EndIf				
	EndIf
	Return(lRetorno)
Else
	MsgAlert("Algumas tabelas utilizadas nesta rotina não foram encontradas. Execute os compatibilizadores UPDFIS.")
	Return()
EndIf

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Fisa022Leg³Autor  ³ Roberto Souza         ³ Data ³21/05/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Legenda para o Browse de Nota Fisca de Serviços Eletônica.  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Fisa022                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Fisa022Leg(cCodMun)

Local aLegenda := {}
				aCores    := {{"F1_FIMP==' ','DISABLE'"  },;									//NF não transmitida
							  {"F1_FIMP=='S','ENABLE'"    },;						  			//NF Autorizada
							  {"F1_FIMP=='T','BR_AZUL'"  },;									//NF Transmitida
							  {"F1_FIMP=='N','BR_PRETO'"}}										//NF nao autorizada

Aadd(aLegenda, {"ENABLE"    ,STR0078}) //"NF autorizada"
Aadd(aLegenda, {"DISABLE"   ,STR0079}) //"NF não transmitida"
Aadd(aLegenda, {"BR_AZUL"   ,STR0080}) //"NF Transmitida"
Aadd(aLegenda, {"BR_PRETO"  ,STR0081}) //"NF nao autorizada" 

BrwLegenda(cCadastro,STR0117,aLegenda) //"Legenda"

Return(.T.)
                        


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Fisa022Men³ Autor ³Roberto Souza          ³ Data ³21/05/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Menu principal                                             ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Array com opcoes da rotina.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Parametros do array a Rotina:                               ³±±
±±³          ³1. Nome a aparecer no cabecalho                             ³±±
±±³          ³2. Nome da Rotina associada                                 ³±±
±±³          ³3. Reservado                                                ³±±
±±³          ³4. Tipo de Transa‡„o a ser efetuada:                        ³±±
±±³          ³	  1 - Pesquisa e Posiciona em um Banco de Dados           ³±±
±±³          ³    2 - Simplesmente Mostra os Campos                       ³±±
±±³          ³    3 - Inclui registros no Bancos de Dados                 ³±±
±±³          ³    4 - Altera o registro corrente                          ³±±
±±³          ³    5 - Remove o registro corrente do Banco de Dados        ³±±
±±³          ³5. Nivel de acesso                                          ³±±
±±³          ³6. Habilita Menu Funcional                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fisa022Men(cCodMun)    

Private aRotina  := {}  

Private cMunCanc := RetMunCanc()

aadd(aRotina,{STR0004,"AxPesqui"      ,0,1,0,.F.})	//"Pesquisar"
aadd(aRotina,{STR0109,"Fisa022Vis"    ,0,2,0 ,NIL})	//"Visualiza Doc."
aadd(aRotina,{STR0005,"Fisa022CFG"    ,0,2,0 ,NIL})	//"Wiz.Config."
aadd(aRotina,{STR0008,"Fisa022Rem"    ,0,2,0 ,NIL}) //"Transmissão."
aadd(aRotina,{STR0009,"Fis022Mnt1()"    ,0,2,0 ,NIL}) //"Monitor."
aadd(aRotina,{STR0117,"Fisa022Leg"    ,0,2,0 ,NIL}) //"Legenda"

If ( cCodMun $ Fisa022Cod("001") .Or. cCodMun $ Fisa022Cod("002") .Or. cCodMun $ Fisa022Cod("003") .Or. cCodMun $ Fisa022Cod("004") .Or. cCodMun $ Fisa022Cod("006") .Or. cCodMun $ Fisa022Cod("007") .Or. cCodMun $ Fisa022Cod("008") .Or. cCodMun $ Fisa022Cod("009") .Or. cCodMun $ Fisa022Cod("010") .Or. cCodMun $ Fisa022Cod("011") .Or. cCodMun $ Fisa022Cod("012")) ;
	.And. !( SubStr(MV_PAR01,1,1) == "2" .And. cCodMun $ GetMunNFT() /* NFTS Sao Paulo e Rio de Janeiro*/) 
	
	If cCodMun $ cMunCanc
		aadd(aRotina,{STR0147,"Fis022MntC()"    ,0,2,0 ,NIL}) //"Trans. Canc."
	EndIf                            
	if cCodMun $ Fisa022Cod("010") .Or. cCodMun $ Fisa022Cod("012") 
		//aadd(aRotina,{"Importar AIDF","Fis022ImpAIDF()"    ,0,2,0 ,NIL})//importacao de arquivo AIDF
		//aadd(aRotina,{"Excluir AIDF","Fis022DelImpAIDF()" ,0,2,0 ,NIL})//Exclusao de importação de arquivo AIDF
		aadd(aRotina,{"Tabela AIDF", "Fis022ViewAIDF()"    ,0,2,0 ,NIL})	
	endif
	if 	MunUsaUrl( cCodMun )
		aadd(aRotina,{"Abrir &URL", "Fis22UrlNfse"    ,0,2,0 ,NIL})
	endif
ElseIf cCodMun $ Fisa022Cod("101") .Or. ( SubStr(MV_PAR01,1,1) == "2" .And. cCodMun $ GetMunNFT() /* Sao Paulo NFTS*/) .Or. cCodMun =='4205407' 
	aadd(aRotina,{STR0150,"Fisa022Imp"     ,0,2,0 ,NIL})//"Imp.Retorno"		
	If cCodMun $ cMunCanc
		aadd(aRotina,{STR0147,"Fisa022Canc()"    ,0,2,0 ,NIL})//"Cancelar"
	EndIf 
	
ElseIf cCodMun $ Fisa022Cod("102") 
	aadd(aRotina,{STR0150,"Fisa022Imp"    ,0,2,0 ,NIL})//"Imp.Retorno"
Else
	Aviso("","Codigo de municipio "+cCodMun+" não homologado na versão do TSS - "+cVerTss+"."+CRLF+"Url: "+cUrl,{"Ok"})
EndIf
	
If ExistBlock("FIRSTNFSE")
	ExecBlock("FIRSTNFSE",.F.,.F.)
EndIf

Return aRotina


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Fisa022Vis³ Autor ³Roberto Souza          ³ Data ³21/05/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Botao para visualizar documentos de saida                   ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Fisa022Vis(cAlias)

If cAlias == "SF2"  
	Mc090Visual("SF2",SF2->(RecNo()),1)
ElseIf cAlias == "SF1"
	A103NFiscal("SF1",SF1->(RecNo()),2)  
EndIf

Return             

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Fisa022Rem³ Autor ³Roberto Souza          ³ Data ³21/05/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de remessa da Nota fiscal eletronica para o Totvs    ³±±
±±³          ³Service SPED - utilizada em personalizacoes                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Serie da NF                                          ³±±
±±³          ³ExpC2: Nota inicial                                         ³±±
±±³          ³ExpC3: Nota final                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Fisa022Rem()

Local aArea		:= GetArea()
Local aPerg		:= {}   
Local aParam	:= {}

Local cAlias	:= "SF2"
Local cParTrans	:= SM0->M0_CODIGO+SM0->M0_CODFIL+"Fisa022Rem"
Local cCodMun	:= SM0->M0_CODMUN
Local cNotasOk	:= ""
Local cForca	:= ""            
Local cDEST		:= Space(10)
Local cMensRet	:= "" 
Local cMvPar06	:= ""
Local cNftMvPar6:= ""
Local cWhen 	:= ".T."
local cMsgAIDF := ""

Local dDataIni	:= CToD('  /  /  ')
Local dDataFim  := CToD('  /  /  ')
LOCAL dData	 	:= Date()

Local lObrig	:= .T.
Local lNFT		:= .F.

Local nForca	:= 1

If cEntSai == "1"
	cAlias	:= "SF2"
	aParam	:= {Space(Len(SF2->F2_SERIE)),Space(Len(SF2->F2_DOC)),Space(Len(SF2->F2_DOC)),"",1,dData,dData,""}
ElseIf cEntSai == "0"   
	cAlias	:= "SF1"                                                                                        
	aParam	:= {Space(Len(SF1->F1_SERIE)),Space(Len(SF1->F1_DOC)),Space(Len(SF1->F1_DOC)),"",1,dData,dData,""}
EndIf

MV_PAR01:=cSerie   := aParam[01] := PadR(ParamLoad(cParTrans,aPerg,1,aParam[01]),Len(SF2->F2_SERIE))
MV_PAR02:=cNotaini := aParam[02] := PadR(ParamLoad(cParTrans,aPerg,2,aParam[02]),Len(SF2->F2_DOC))
MV_PAR03:=cNotaFin := aParam[03] := PadR(ParamLoad(cParTrans,aPerg,3,aParam[03]),Len(SF2->F2_DOC))
MV_PAR05:=""
MV_PAR06:= dData
MV_PAR07:= dData
MV_PAR08:= aParam[08] := PadR(ParamLoad(cParTrans,aPerg,8,aParam[08]),100)
//Montagem das perguntas
aadd(aPerg,{1,STR0010,aParam[01],"",".T.","",".T.",30,.F.})	//"Serie da Nota Fiscal"
aadd(aPerg,{1,STR0011,aParam[02],"",".T.","",".T.",30,.T.})	//"Nota fiscal inicial"
aadd(aPerg,{1,STR0012,aParam[03],"",".T.","",".T.",30,.T.}) //"Nota fiscal final"

//Geracao XML Arquivo Fisico
If ( cCodMun $ Fisa022Cod("101") .or. cCodMun $ Fisa022Cod("102") .Or. ( cCodMun $ GetMunNFT() .And. cEntSai == "0"  ) )
	  	
	MV_PAR04:= cDEST := aParam[04] := PadR(ParamLoad(cParTrans,aPerg,4,aParam[04]),10) 
	MV_PAR05:= nForca := aParam[05] := PadR(ParamLoad(cParTrans,aPerg,5,aParam[05]),1) 
	aadd(aPerg,{1,"Nome arquivo",aParam[04],"",".T.","",cWhen,40,lObrig})					//"Nome do arquivo XML Gerado"
	
	aadd(aPerg,{2,"Força Transmissão",aParam[05],{"1-Sim","2-Não"},40,"",.T.,""})  	   		//"Força Transmissão"
	
	If ( cCodMun $ GetMunNFT() .And. cEntSai == "0"  )
		MV_PAR06:=  dDataIni:= aParam[06] := ParamLoad(cParTrans,aPerg,6,aParam[06]) 
		MV_PAR07:=  dDataFim:= aParam[07] := ParamLoad(cParTrans,aPerg,5,aParam[07])
		aadd(aPerg,{1,"Data de",aParam[06],"",".T.","",".T.",50,.F.})			//"Data de:"
		aadd(aPerg,{1,"Data ate",aParam[07],"",".T.","","",50,.F.})  			//"Data ate:"

		lNFT := .T.
		
	EndIf 
	cMvPar06 := MV_PAR06	
	
	oWs := WsSpedCfgNFe():New()
	oWs:cUSERTOKEN      := "TOTVS"
	oWS:_URL            := AllTrim(cURL)+"/SPEDCFGNFe.apw"	 
	oWS:lftpEnable      := nil
	
	if ( execWSRet( oWS ,"tssCfgFTP" ) )
	
		if ( oWS:lTSSCFGFTPRESULT )
//			aadd(aPerg,{6,"Caminho do arquivo","","","",040,.T.,"","",""})   
			aAdd(aPerg,{6,"Caminho do arquivo",padr('',100),"",,"",90 ,.T.,"",'',GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY})
		endif
		
	endif		
	
EndIf

//Verifica se o serviço foi configurado - Somente o Adm pode configurar
If ParamBox(aPerg,"Transmissão NFS-e",,,,,,,,cParTrans,.T.,.T.)    
	
	MV_PAR05 := Val(Substr(MV_PAR05,1,1))      
	
	if ( lNFT )
		cGravaDest := MV_PAR08
		cNftMvPar6 := MV_PAR06
	else
		cGravaDest := MV_PAR06
	endif

	// Retornando ao valor original ao Mv_PAR06
	if ( lNFT )
		MV_PAR06 := cNftMvPar6
	else
		MV_PAR06 := cMvPar06
	endif

	Processa( {|| Fisa022Trs(cCodMun,MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04,cAlias,@cNotasOk,cDEST,MV_PAR05,@cMensRet,MV_PAR06,MV_PAR07,,,cGravaDest, @cMsgAIDF)}, "Aguarde...","(1/2) Verificando dados...", .T. )
	If Empty(cNotasOk) 	
		Aviso("NFS-e","Nenhuma nota foi transmitida."+CRLF+cMensRet,{STR0114},3)
	Else
		If ( cCodMun $ Fisa022Cod("101") .or. cCodMun $ Fisa022Cod("102") .Or. ( cCodMun $ GetMunNFT() .And. cEntSai == "0"  ) )
			Aviso("NFS-e","Arquivos Gerados:" +CRLF+ cNotasOk,{STR0114},3)
		Else		
			cMensRet := Iif("Uma ou mais notas nao puderam ser transmitidas:"$cNotasOk,"","Notas Transmitidas:"+CRLF)
			Aviso("NFS-e",cMensRet + cNotasOk,{STR0114},3)
		EndIf
	EndIf
EndIf    

RestArea(aArea)

Return 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Fisa022Trs³ Autor ³Roberto Souza          ³ Data ³21/05/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de remessa da Nota fiscal de Serviços Eletronica.    ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Serie da NF                                          ³±±
±±³          ³ExpC2: Nota inicial                                         ³±±
±±³          ³ExpC3: Nota final                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Fisa022Trs(cCodMun,cSerie,cNotaini,cNotaFin,cForca,cAlias,cNotasOk,cDEST,nForca,cMensRet,dDataIni,dDataFim,lAuto,nMaxTrans,cGravaDest)

	local aArea		:= GetArea()  
	local aNtXml		:= {}
	local aRemessa	:= {}
	local aTemp		:= {}
	local aArqTxt		:= {}
	local aMVTitNFT	:= &(GetNewPar("MV_TITNFTS","{}"))

	local cRetorno 	:= ""
	local cAliasSF3	:= "SF3"
	local cAliasSE2	:= "SE2"
	local cWhere    	:= ""
	local cNtXml		:= ""      
	local cSerieIni	:= cSerie
	local cSerieFim	:= cSerie
	local cTotal		:= ""		
	local cCodTit	:= ""
	local cAviso		:= ""
	local lOk			:= .F.
	local lRemessa	:= .F. 
	local lQuerySE2	:= .F.
	local lGeraArqimp	:= .F.
	local lContinua	:= .F.
	local lRecibo	:= .F.
	
	local nY        := 0
	local nZ        := 0
	local nW        := 0
	local nTamXml		:= 0	
	local nCount		:= 0
	local nCodIssF3	:= tamSX3("F3_CODISS")[1]

	private oRetorno
	private oWs
	
	Default cAlias 		:= ""
		
	//Restaura a integridade da rotina caso exista filtro	
    If !Empty (cAlias)
		(cAlias)->(dbClearFilter())
		retIndex(cAlias)
	Endif
	if ( ( cCodMun $ Fisa022Cod("101") .or. cCodMun $ Fisa022Cod("102") ) .Or. ( cEntSai == "0" .And. cCodMun $ GetMunNFT() /* Sao Paulo NFTS*/) )
		lGeraArqimp := .T.
	
	endif
	
	#IFDEF TOP
	
		if cEntSai == "1"
			cWhere := "%(SubString(SF3.F3_CFO,1,1) >= '5') "			

		elseIf cEntSai == "0"
			cWhere := "%"
			cWhere += "(SubString(SF3.F3_CFO,1,1) < '5')"

			if cCodMun $ getMunNFT() .And. ( !empty( dDataIni ) .And. !empty( dDataFim ) )
				cWhere += " And ( SF3.F3_EMISSAO >= " +Dtos(dDataIni)+" And SF3.F3_EMISSAO <="+Dtos(dDataFim)+" And SF3.F3_CODISS<>'')"

			endIf                                        

			if ( Empty( cSerie ) ) 		
				cSerieIni :=  "   "
				cSerieFim :=  "ZZZ"

			EndIf

		endif	
		
		if nForca == 2
			cWhere +=" AND (SF3.F3_CODRSEF = '' OR SF3.F3_CODRSEF = 'N') "

		endif

		cWhere += "%"		

		cAliasSF3 := GetNextAlias()
	
		BeginSql Alias cAliasSF3
			
		COLUMN F3_ENTRADA AS DATE
		COLUMN F3_DTCANC AS DATE
					
		SELECT	F3_FILIAL,F3_ENTRADA,F3_NFELETR,F3_CFO,F3_FORMUL,F3_NFISCAL,F3_SERIE,F3_CLIEFOR,F3_LOJA,F3_ESPECIE,F3_DTCANC,F3_CODNFE,SF3.F3_CODISS	
				FROM %Table:SF3% SF3
				WHERE
				SF3.F3_FILIAL		= %xFilial:SF3% AND
				SF3.F3_SERIE		>= %Exp:cSerieIni% AND 
				SF3.F3_SERIE		<= %Exp:cSerieFim% AND 
				SF3.F3_NFISCAL	>= %Exp:cNotaIni% AND 
				SF3.F3_NFISCAL	<= %Exp:cNotaFin% AND 				
				%Exp:cWhere% AND 
				SF3.F3_CODISS		<> %Exp:Space(nCodIssF3)% AND
				SF3.F3_DTCANC 	= %Exp:Space(8)% AND 
				SF3.%notdel%
		EndSql
	
	#ELSE
		SF3->(dbSetOrder(5))	
		
		if cEntSai == "1"
			bCondicao := {||	SF3->F3_FILIAL	== xFilial("SF3") .And.;
								SF3->F3_SERIE		>= cSerieIni .And.;
								SF3->F3_SERIE		<= cSerieFim .And.;
								SF3->F3_NFISCAL	>= cNotaIni .And.;
								SF3->F3_NFISCAL	<= cNotaFin .And.;
								SF3->F3_CFO		>= '5' .And.;
								SF3->F3_DTCANC	== ctod("  /  /  ");	
							}		

		else
			bCondicao := {||	SF3->F3_FILIAL	== xFilial("SF3") .And.;
								SF3->F3_SERIE		>= cSerieIni .And.;
								SF3->F3_SERIE		<= cSerieFim .And.;
								SF3->F3_NFISCAL	>= cNotaIni .And.;
								SF3->F3_NFISCAL	<= cNotaFin .And.;
								SF3->F3_CFO		<	'5' .And.;
								SF3->F3_DTCANC	== ctod("  /  /  ");							
							}			

		endif
	
		SF3->(DbSetFilter(bCondicao,""))

		SF3->(dbGotop())	

	#ENDIF
	
	//Tratamento para NTFS,quando nao existir notas de entrada
	//apenas recibos lançandos no contas a pagar.
	if ( cEntSai == "0" .and. len( aMVTitNFT ) == 2 .And. SE2->( FieldPos("E2_FIMP") ) > 0 ) .And. SE2->( FieldPos("E2_NFELETR") ) > 0
		
		for nz := 1 to 2 
			aAuxTit := aMVTitNFT[nz]
			for nw := 1 to len( aAuxTit )
				cCodTit += "'"+aAuxTit[nW]+"'"+","
			next nW	
		next nz
		
		cCodTit := SUBSTR(cCodTit,1,RAT(",",cCodTit)-1)
					
		lQuerySE2    := .T.	
		
		cAliasSE2 := GetNextAlias()
		
		cWhere := "%"
		cWhere += "SE2.E2_TIPO IN ("+cCodTit+") AND SE2.E2_ISS > 0"	
		cWhere += "%"
		
		#IFDEF TOP
		 	BeginSql Alias cAliasSE2
		 		
		 	COLUMN E2_EMISSAO AS DATE
							
			SELECT E2_FILIAL,E2_EMISSAO,E2_TIPO,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_ISS,E2_FORNECE,E2_LOJA,E2_FIMP,E2_NFELETR
				FROM %Table:SE2% SE2
					WHERE
					SE2.E2_FILIAL = %xFilial:SE2% AND
					SE2.E2_EMISSAO >= %Exp:dtos(dDataIni)% AND 
					SE2.E2_EMISSAO <= %Exp:dtos(dDataFim)% AND 
					%Exp:cWhere% AND
					SE2.%notdel%
			EndSql
		
		#ELSE
			
			SE2->( dbSetOrder(5) )
			
			bCondicao := {||	SE2->E2_FILIAL	== xFilial("SE2") .And.;
								SE2->E2_EMISSAO	>= dDataIni .And.;
								SE2->E2_EMISSAO	<= dDataFim .And.;
								SE2->E2_TIPO $ cCodTit;
						}
						
			SE2->(DbSetFilter(bCondicao,""))

			SE2->(dbGotop())
			
		#ENDIF
				
	elseif len( aMVTitNFT ) <> 2 .And. cEntSai == "0"
		Aviso("","Parâmetro MV_TITNFTS não foi criado ou configurado corretamente, não serão considerados os recibos do financeiro!" ,{"Ok"})
	elseif ( SE2->( FieldPos("E2_FIMP") ) == 0 .Or. SE2->( FieldPos("E2_NFELETR") ) == 0 ) .And. cEntSai == "0"
		Aviso("","O campo E2_FIMP ou E2_NFELETR não existem, veiricar se o compatibilizador NFEP10R1 / update NFE10R136 foi executado corretamente!" ,{"Ok"})
	endif		
		
	cTotal := cValtoChar( Val(cNotaFin)-Val(cNotaIni)+1 )	 
	
	ProcRegua( Val(cNotaFin)- Val(cNotaIni)+ 1 )

	cRDMakeNFSe := getRDMakeNFSe(cCodMun,cEntSai)
	
	While (cAliasSF3)->(!Eof())
		
		nCount++
		
		incProc( "(" + cValTochar(nCount)+ "/"+cTotal + ")" + STR0022 + (cAliasSF3)->F3_NFISCAL ) //"Preparando nota: "
		
		//Retorna Remessa para transmissao
		aTemp := montaRemessaNFSe(cAliasSF3,cRDMakeNFSe, , ,cIdent,,,@cMensRet)

		if len(aTemp) > 0
			nTamXml += len(aTemp[7])
			
			if nTamXml <= TAMMAXXML
				aadd(aRemessa, aTemp)				
			
			else
				lRemessa := .T.
			
			endif			
			
			aadd(aArqTxt,aTemp)
		
		endif		
		If GravaRps(SM0->M0_CODMUN)
			if !C0P->(dbSeek(xFilial("C0P") + padr(cValToChar(val(SF3->F3_NFISCAL)), tamSX3("C0P_RPS")[1] ) ) ) .AND. C0P->(dbSeek(xFilial("C0P") + "0" ) )
				reclock("C0P")
				C0P->C0P_RPS		:= val((cAliasSF3)->F3_NFISCAL)		
				C0P->(msunlock())					
			EndIf
		EndIf
		(cAliasSF3)->(dbSkip())
									
		if ( lRemessa )

			incProc( "(" + cValToChar(nCount) + "/" + cTotal + ")"+STR0023 )//+aTemp[2]+aTemp[6] )	//"Transmitindo XML da nota: "

			lOk := envRemessaNFSe(cIdEnt,cUrl,aRemessa,(nForca == 1),cEntSai,@cNotasOk, , ,cCodMun)
				
			if !lOk
				cMensRet :=(IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)))	

			endif
			
			lRemessa	:= .F.					
			aRemessa	:={}
			
			aadd(aRemessa, aTemp)
			
			nTamXml:= len(aTemp[7])		
			aNtXml	:= {}
			cNtXml	:= ""

		endif
				
	endDo
	
	While (cAliasSE2)->(!Eof()) .and. cEntSai == "0"
		
		nCount++
		
		incProc( "(" + cValTochar(nCount)+ "/"+cTotal + ")" + STR0022 + (cAliasSE2)->E2_NUM ) //"Preparando nota: "
				
		//Retorna Remessa para transmissao
		aTemp := montaRemessaNFSe(cAliasSE2,cRDMakeNFSe, , ,cIdent,,cCodTit,@cMensRet)

		if len(aTemp) > 0
			nTamXml += len(aTemp[7])
			
			if nTamXml <= TAMMAXXML
				aadd(aRemessa, aTemp)				
			
			else
				lRemessa := .T.
			
			endif			
			
			aadd(aArqTxt,aTemp)
			
			lRecibo	:= .T.
			
		
		endif		

		(cAliasSE2)->(dbSkip())
									
		if ( lRemessa )

			incProc( "(" + cValToChar(nCount) + "/" + cTotal + ")"+STR0023 )//+aTemp[2]+aTemp[6] )	//"Transmitindo XML da nota: "

			lOk := envRemessaNFSe(cIdEnt,cUrl,aRemessa,(nForca == 1),cEntSai,@cNotasOk, , ,cCodMun,lRecibo)
				
			if !lOk
				cMensRet :=(IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)))	

			endif
			
			lRemessa	:= .F.					
			aRemessa	:={}
			
			aadd(aRemessa, aTemp)
			
			nTamXml:= len(aTemp[7])		
			aNtXml	:= {}
			cNtXml	:= ""

		endif
				
	endDo
		
	if ( len(aRemessa) > 0 )
		
		incProc("("+cValToChar(nCount)+"/"+cTotal+") "+STR0023)//+aTemp[2]+aTemp[6])	//"Transmitindo XML da nota: "
		
		lOk := envRemessaNFSe(cIdEnt,cUrl,aRemessa,(nForca == 1),cEntSai,@cNotasOk, , ,cCodMun,lRecibo)
				
		if lOk
			if lGeraArqimp
				
				cNotasok := ""
				
				incProc("("+cValToChar(nCount)+"/"+cTotal+") "+"Gerando arquivo das notas")//aTemp[2]+aTemp[6])	//"Transmitindo XML da nota: "
				
				//gera arquivo txt para os modelos 101,102 ou NFTS(São Paulo)
				geraArqNFSe(cIdEnt,cCodMun,cSerie,cNotaini,cNotaFin,cForca,nForca,cSerieIni,cSerieFim,dDataIni,dDataFim,aArqTxt,@cNotasOk,lRecibo,cGravaDest)				

			endIf			

		else
			cMensRet :=(IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)))	

		endif

	endif

	#IFDEF TOP		
		if select(cAliasSF3) > 0
			(cAliasSF3)->(dbCloseArea())

		endif			

	#ENDIF                                                                         		

	restArea(aArea)

	delClassIntF()

return(cRetorno)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Fisa022Con³ Autor ³Roberto Souza          ³ Data ³21/05/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de remessa da Nota fiscal eletronica para o Totvs    ³±±
±±³          ³Service SPED - utilizada em personalizacoes                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Serie da NF                                          ³±±
±±³          ³ExpC2: Nota inicial                                         ³±±
±±³          ³ExpC3: Nota final                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Fisa022Con()

Local aArea       := GetArea()
Local aPerg       := {}
Local cAlias      := "SF2"
Local aParam      := {Space(Len(SF2->F2_SERIE)),Space(Len(SF2->F2_DOC)),Space(Len(SF2->F2_DOC))}
Local cParTrans   := SM0->M0_CODIGO+SM0->M0_CODFIL+"Fisa022Con"
Local cNotasOk    := ""

MV_PAR01:=cSerie   := aParam[01] := PadR(ParamLoad(cParTrans,aPerg,1,aParam[01]),Len(SF2->F2_SERIE))
MV_PAR02:=cNotaini := aParam[02] := PadR(ParamLoad(cParTrans,aPerg,2,aParam[02]),Len(SF2->F2_DOC))
MV_PAR03:=cNotaFin := aParam[03] := PadR(ParamLoad(cParTrans,aPerg,3,aParam[03]),Len(SF2->F2_DOC))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem das perguntas                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aadd(aPerg,{1,STR0010,aParam[01],"",".T.","",".T.",30,.F.})	//"Serie da Nota Fiscal"
aadd(aPerg,{1,STR0011,aParam[02],"",".T.","",".T.",30,.T.})	//"Nota fiscal inicial"
aadd(aPerg,{1,STR0012,aParam[03],"",".T.","",".T.",30,.T.}) //"Nota fiscal final"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o serviço foi configurado - Somente o Adm pode configurar   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If ParamBox(aPerg,"Consulta NFS-E",,,,,,,,cParTrans,.T.,.T.)
	Processa( {|| Fisa022Ret(MV_PAR01,MV_PAR02,MV_PAR03,cAlias,@cNotasOk)}, "Aguarde...","(1/2) Verificando dados...", .T. )
	If Empty(cNotasOk)	
		Aviso("NFD","Nenhuma nota processada.",{STR0114},3)
	Else
		Aviso("NFD","Processamento das Notas" +CRLF+ cNotasOk,{STR0114},3)
	EndIf
EndIf
RestArea(aArea)
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Fisa022XML³ Autor ³Vitor Felipe           ³ Data ³24/11/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de remessa da Nota fiscal eletronica para o Totvs    ³±±
±±³          ³Service SPED - utilizada em personalizacoes                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Serie da NF                                          ³±±
±±³          ³ExpC2: Nota inicial                                         ³±±
±±³          ³ExpC3: Nota final                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Fisa022XML(cIdEnt,cCodMun,cSerie,cNotaini,cNotaFin,dDtxml,cDEST,cNtXml,aNtXml,nForca,cSerieIni,cSerieFim,dDataIni,dDataFim,cGravaDest)

Local cDxml 		:= ""
Local cNotasOk		:= ""
Local cIDTHREAD	:= ""
Local cBarra		:= If(isSrvUnix(),"/","\")  
Local cPath		:= ""

Local lOk			:= .F.  
Local lDownload	:= .F.

Local nX
Local nY  
Local nCount	:= 0 

Local oWs  

Default cSerieIni	:= ""
Default cSerieFim	:= ""
Default dDataIni	:= Date()
Default dDataFim	:= Date()
DEFAULT nForca		:= 1

cDxml :=SubSTR(dtos(dDtxml),5,2)+"/"+subSTR(dtos(dDtxml),1,4)
	
oWS := WsNFSE001():New()
oWS:cUSERTOKEN            := "TOTVS"
oWS:cID_ENT               := cIdEnt
oWS:cDEST		          := AllTrim(cDEST)
oWS:dDATEDECL			  := dDtxml
oWS:lREPROC				  := If(nForca==1,.T.,.F.)
oWS:_URL                  := AllTrim(cURL)+"/NFSE001.apw"

If cEntSai == "0" .And. !( cCodMun $ GetMunNFT() )
	oWS:dDATAINI		:= dDataIni
	oWS:dDATAFIM		:= dDataFim
	
	oWS:oWSNFSEARR:OWSNOTAS     := NFSE001_ARRAYOFNFSESID1():New()  
    
	For nX:= 1 To Len( aNtXml )
	 
		aadd(oWS:oWSNFSEARR:OWSNOTAS:OWSNFSESID1,NFSE001_NFSESID1():New())		
		oWS:OWSNFSEARR:OWSNOTAS:OWSNFSESID1[nX]:CID      := aNtXml[nX][01]+(aNtXml[nx][02]+aNtXml[nX][05])
	 Next	
	
	lOk 		:= ExecWSRet( oWS ,"GeraArqImpArr" )
	cIDTHREAD	:= oWS:CGERAARQIMPARRRESULT	
Else	
	If !( cCodMun $ GetMunNFT() )
		oWS:cIDINICIAL	 	:= cSerieIni+cNotaini
		oWS:cIDFINAL		    := cSerieFim+cNotafin	
		
		lOk 		:= ExecWSRet( oWS ,"GeraArqImp" )
		cIDTHREAD	:= oWS:CGERAARQIMPRESULT
	Else
	
		oWS:dDATAINI		:= dDataIni
		oWS:dDATAFIM		:= dDataFim
		
		oWS:oWSNFSEARR:OWSNOTAS     := NFSE001_ARRAYOFNFSESID1():New()  
	    
		For nX:= 1 To Len( aNtXml )
		 
			aadd(oWS:oWSNFSEARR:OWSNOTAS:OWSNFSESID1,NFSE001_NFSESID1():New())		
			oWS:OWSNFSEARR:OWSNOTAS:OWSNFSESID1[nX]:CID      := aNtXml[nX][01]+(aNtXml[nx][02]+aNtXml[nX][05])
		 Next	
		
		lOk 		:= ExecWSRet( oWS ,"GeraArqImpArr" )
		cIDTHREAD	:= oWS:CGERAARQIMPARRRESULT	

	EndIf
	
	
	if ( lOk )
	
		oWs := WsSpedCfgNFe():New()
		oWs:cUSERTOKEN      := "TOTVS"
		oWS:_URL            := AllTrim(cURL)+"/SPEDCFGNFe.apw"	 
		oWS:lftpEnable      := nil
		
		if ( execWSRet( oWS ,"tssCfgFTP" ) .And. oWS:lTSSCFGFTPRESULT ) 
		
			cTss := strTran(upper(AllTrim(cURL)),"HTTP://","")
			
			if ( AT( ":" , cTss ) > 0 )
				cTss := substr(cTss,1,AT( ":" , cTss )-1)		
			else
				cTss := substr(cTss,1,AT( "/" , cTss )-1)
			endif  
			
			while nCount < 5
			
				if FTPCONNECT ( cTss , 21 ,"Anonymous", "Anonymous" )    
				        
					if FTPDIRCHANGE ( "/arqger/" + cCodMun ) 
					
						aRetDir := FTPDIRECTORY ( "*.*" , ) 
						
						if ( !empty(aRetDir) )
						
						    for nY := 1 to len(aRetDir)
						    	
						    	If (upper(AllTrim(cDEST)) == Upper( Substr(Alltrim(aRetDir[nY][1]),1,At(".",Alltrim(aRetDir[nY][1]))-1 ) ) )
						    		cPath := getSrvProfString("StartPath","")   
						    
									if ( substr(cPath,len(cPath),1) <> cBarra )
										cPath := cPath + cBarra
									endif 
									
									cGravaDest := allTrim(cGravaDest) 
															
									if ( substr(cGravaDest,len(cGravaDest),1) <> cBarra )
										cGravaDest := cGravaDest + cBarra
									endif 										    
								    
								    if ( len(aRetDir) > 0 .and. nY <= len(aRetDir)  )						 
								    
								    	if FTPDOWNLOAD ( allTrim(cPath) + aRetDir[nY][1], aRetDir[nY][1])
										   	If ( CpyS2T( allTrim(cPath) + aRetDir[nY][1], cGravaDest, .F. ) )
												lDownload := .T.
												FErase(allTrim(cPath) + aRetDir[nY][1])                                 
											else
												FErase(allTrim(cPath) + aRetDir[nY][1])
											EndIf 									   						    	
								   		EndIf   
									   
							    	endif
							    	
						    	endif
						    	
						    next nY
							
						endif
				
					EndIf  
					
					FTPDISCONNECT ()
						   
				EndIf  
				
				if ( !lDownload )
					nCount++
					sleep(10000)
				else
					exit
				endif
				
			end

			if ( !lDownload )		
				alert("Não foi possível salvar o arquivo no local escolhido.")
			else
				msgInfo( "Arquivo salvo com sucesso." ) 
	
			endif
			
		endif
		
	endif
	
EndIf	


If lOk 
	If cSerieIni+cNotaini <> cSerieFim+cNotafin
		cNotasOk += cNtXml
	Else
		cNotasOk += cSerieIni+cNotaini + CRLF
	EndIf
EndIf    
 
If Empty(cNotasOk)
	cNotasOk := "Uma ou mais notas nao puderam ser transmitidas:"+CRLF
	cNotasOk += "Verifique as notas processadas."
EndIf

Return(cNotasOk)

//-----------------------------------------------------------------------
/*/{Protheus.doc} Fisa022Imp
Funcao que executa o metodo de importacao de arquivo de NFSe  retornado 
pela prefeitura para o TSS.
Utilizado para os modelos 101 e 102

@author Henrique Brugugnoli
@since 12.11.2010
@version 1.0 
/*/
//-----------------------------------------------------------------------
Function Fisa022Imp()

Local aPerg     := {}
Local aParam    := {Space(90)} 

Local cCodMun   := SM0->M0_CODMUN
Local cParImp   := SM0->M0_CODIGO+SM0->M0_CODFIL+"Fisa022Imp"
Local cIDThread := ""
Local cStatNfse := ""  
Local cBarra	:= If(isSrvUnix(),"/","\") 

Local lOk       := .F.
Local lFTP		:= .F.  
Local lUpload	:= .F.

Local oWS


aParam[01] := PadR(ParamLoad(cParImp,aPerg,1,aParam[01]),Len(Space(90)))   

oWs := WsSpedCfgNFe():New()
oWs:cUSERTOKEN      := "TOTVS"
oWS:_URL            := AllTrim(cURL)+"/SPEDCFGNFe.apw"	 
oWS:lftpEnable      := nil

if ( execWSRet( oWS ,"tssCfgFTP" ) )

	if ( oWS:lTSSCFGFTPRESULT )
		aAdd(aPerg,{6,"Arquivo a ser importado",padr('',90),"",,"",90 ,.T.,"",'',GETF_LOCALHARD+GETF_NETWORKDRIVE})
		lFTP := .T.
	endif
	
endif

oWs := nil

if ( !lFTP )
	aadd(aPerg,{1,"Arquivo de Retorno",aParam[01],"",".T.","",".T.",100,.F.})	//"Arquivo de retorno
endif

If ParamBox(aPerg,"Transmissão NFS-e",@aParam,,,,,,,cParImp,.T.,.T.) //Monta tela de parâmetros

	if ( lFTP )                     
	
		cPath 	:= cBarra + "ftp"  + cBarra
	
		makeDir(  cPath ) 
	
		cLocal 	:= allTrim(MV_PAR01)		
		cFile 	:= substr(cLocal,rAt(cBarra,cLocal)+1)

		if ( substr(cPath,len(cPath),1) <> cBarra )
			cPath := substr(cPath,1,len(cPath)-1) + cBarra
		endif 		
		
		if cLocal <> cFile	
			if ( cpyT2S(cLocal,cPath) )
			       
				cTss := strTran(upper(AllTrim(cURL)),"HTTP://","")
				
				if ( AT( ":" , cTss ) > 0 )
					cTss := substr(cTss,1,AT( ":" , cTss )-1)		
				else
					cTss := substr(cTss,1,AT( "/" , cTss )-1)
				endif 
				
				if FTPCONNECT ( cTss , 21 ,"Anonymous", "Anonymous" )    
				        
					if FTPDIRCHANGE ( "/arqimp/" + cCodMun )
					
						FTPSETPASV(.F.)					
					      
						if FTPUPLOAD ( cPath+cFile, cFile )
							msgInfo("Arquivo copiado com sucesso.")
					   		lUpload := .T.
					   	EndIf				
					
	
					endif 
					
					FTPDISCONNECT()
					
				endif					
				
				fErase(cPath+cFile)
			
			endif 
		endif
		if ( !lUpload )
			if cLocal == cFile
				alert("Não foi possível copiar o arquivo.Local não especificado.")			
			else
				alert("Não foi possível copiar o arquivo.")
			endif
		endif  
		
	else	
		cFile := Alltrim(aParam[01])
	endif

	oWS             := WsNFSE001():New()
	oWS:cUSERTOKEN  := "TOTVS" 
	oWS:CARQTXT     := cFile
	oWS:CCODMUN     := cCodMun
	oWS:CID_ENT     := cIdEnt
	oWS:_URL        := AllTrim(cURL)+"/NFSE001.apw"
	
	lOk           := ExecWSRet( oWS ,"ProcImpNFSETXT" ) //Chamada do método ProcImpNFSETXT para importar o arquivo retornado pela Prefeitura
	cIDThread     := oWS:CPROCIMPNFSETXTRESULT
	
	If !Empty(cIDThread)
		oWS:cIDTHREAD := cIDThread
	Endif
    
	lOk        := ExecWSRet( oWS ,"StatusNfse" ) //Chamada do método StatusNfse para validar a Thread retornada por ProcImpNFSETXT
	cStatNfse  := oWS:cSTATUSNFSERESULT
Endif

If !Empty(cStatNfse) .Or. lOk
	Aviso("NFS-e","O arquivo de Retorno da Prefeitura foi importado com sucesso.",{STR0114},3)
Else
	Aviso("NFS-e","Nenhum arquivo foi importado.",{STR0114},3)
Endif

Return			

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Fisa022Ret³ Autor ³Roberto Souza          ³ Data ³21/05/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de retorno da Nota fiscal Digital de Serviços        ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Serie da NF                                          ³±±
±±³          ³ExpC2: Nota inicial                                         ³±±
±±³          ³ExpC3: Nota final                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Fisa022Ret(cSerie,cNotaini,cNotaFin,cAlias,cNotasOk)
Local aArea     := GetArea()
Local aNotas    := {}
Local aRetNotas := {}
Local cRetorno  := ""
Local aXml      := {}
Local cAliasSF3 := "SF3"
Local cWhere    := ""
Local cErro     := ""
Local lQuery    := .F.
Local lRetorno  := .T.
Local nX        := 0
Local nY        := 0
Local nNFes     := 0
Local nXmlSize  := 0
Local dDataIni  := Date()
Local cHoraIni  := Time()
Local oWs
Local cPassCpf  := GetNewPar("MV_PSWNFD","")
Local cCpfUser  := GetNewPar("MV_CPFNFD","")
Local cHashSenha:= AllTrim(cPassCpf)
Local cNfd      := ""
Local cNfdEntRet:= ""


ProcRegua(0)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a integridade da rotina caso exista filtro             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAlias)
dbClearFilter()
RetIndex(cAlias)

ProcRegua(Val(cNotaFin)-Val(cNotaIni)+1)
dbSelectArea("SF3")
dbSetOrder(5)
#IFDEF TOP
	If cEntSai == "1"
		cWhere := "%(SubString(SF3.F3_CFO,1,1) >= '5')%"
	ElseIF cEntSai == "0"
		cWhere := "%(SubString(SF3.F3_CFO,1,1) < '5')%"
	EndiF
	cAliasSF3 := GetNextAlias()
	lQuery    := .T.
	BeginSql Alias cAliasSF3
		
	COLUMN F3_ENTRADA AS DATE
	COLUMN F3_DTCANC AS DATE
				
	SELECT	F3_FILIAL,F3_ENTRADA,F3_NFeLETR,F3_CFO,F3_FORMUL,F3_NFISCAL,F3_SERIE,F3_CLIEFOR,F3_LOJA,F3_ESPECIE,F3_DTCANC
			FROM %Table:SF3% SF3
			WHERE
			SF3.F3_FILIAL = %xFilial:SF3% AND
			SF3.F3_SERIE = %Exp:cSerie% AND 
			SF3.F3_NFISCAL >= %Exp:cNotaIni% AND 
			SF3.F3_NFISCAL <= %Exp:cNotaFin% AND 
			%Exp:cWhere% AND 
			SF3.F3_DTCANC = %Exp:Space(8)% AND 
			SF3.%notdel%
	EndSql
	cWhere := ".T."	
#ELSE
	MsSeek(xFilial("SF3")+cSerie+cNotaIni,.T.)
#ENDIF

If cEntSai == "1"
	cWhere := "(SubStr(F3_CFO,1,1) >= '5')"
ElseIF cEntSai == "0"
	cWhere := "(SubStr(F3_CFO,1,1) < '5')"
EndiF	

While !Eof() .And. xFilial("SF3") == (cAliasSF3)->F3_FILIAL .And.;
	(cAliasSF3)->F3_SERIE == cSerie .And.;
	(cAliasSF3)->F3_NFISCAL >= cNotaIni .And.;
	(cAliasSF3)->F3_NFISCAL <= cNotaFin

	dbSelectArea(cAliasSF3)
	If (SubStr((cAliasSF3)->F3_CFO,1,1)>="5" .Or. SubStr((cAliasSF3)->F3_CFO,1,1)<"5" ) .And. aScan(aNotas,{|x| x[3]+x[4]==(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_NFISCAL})==0
		
		IncProc("(1/2) "+STR0022+(cAliasSF3)->F3_NFISCAL) //"Preparando nota: "
		
		If Empty((cAliasSF3)->F3_DTCANC) .And. &cWhere
			aadd(aNotas,{})	
			nX := Len(aNotas)
			aadd(aNotas[nX],IIF((cAliasSF3)->F3_CFO<"5","0","1"))
			aadd(aNotas[nX],(cAliasSF3)->F3_ENTRADA)
			aadd(aNotas[nX],(cAliasSF3)->F3_SERIE)
			aadd(aNotas[nX],(cAliasSF3)->F3_NFISCAL)
			aadd(aNotas[nX],(cAliasSF3)->F3_CLIEFOR)
			aadd(aNotas[nX],(cAliasSF3)->F3_LOJA)
		EndIf
	EndIf		
	dbSelectArea(cAliasSF3)
	dbSkip()	
EndDo
If lQuery
	dbSelectArea(cAliasSF3)
	dbCloseArea()
	dbSelectArea("SF3")
EndIf
ProcRegua(Len(aNotas))


For nX := 1 To Len(aNotas)
	IncProc("(2/2) "+"Verificando nota "+aNotas[nX][4]) //"Transmitindo XML da nota: "
/*	
	dbSelectArea("SF2")
	dbSetOrder(1)
	If DbSeek(xFilial("SF2")+aNotas[nx][4]+aNotas[nx][3]+aNotas[nx][5]+aNotas[nx][6]) .And. SF2->F2_FIMP$"N, "
*/	If cEntSai == "1"
		cStatusNf := Posicione("SF2",1,xFilial("SF2")+aNotas[nx][4]+aNotas[nx][3]+aNotas[nx][5]+aNotas[nx][6],"SF2->F2_FIMP")
	Else
		cStatusNf := Posicione("SF1",1,xFilial("SF1")+aNotas[nx][4]+aNotas[nx][3]+aNotas[nx][5]+aNotas[nx][6],"SF1->F1_FIMP")
	EndIF	
	
	If AllTrim(cStatusNf) == "T"
		DbSelectArea("CDQ")
		DbSetOrder(3)  //"CDQ_FILIAL+CDQ_DOC+CDQ_SERIE+CDQ_CLIENT+CDQ_LOJA+CDQ_CODMSG"
	
		If DbSeek(xFilial("CDQ")+aNotas[nX][4]+aNotas[nX][3]+aNotas[nX][5]+aNotas[nX][6]+"OK")
			cNfd := CDQ->CDQ_XMLRET
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Criptografa a Senha de uso para a transmissão                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		   //	cHashSenha:=sha1(cHashSenha,2)    
		//	cHashSenha:=Encode64(cHashSenha) 
		
		  //  cHashSenha:="cRDtpNCeBiql5KOQsKVyrA0sAiA="
		   
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Chama o WebService para Transmissão                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oWs:= WSWsSaida():New()
			oWs:_URL                       := cURL+"wssaida.asmx"
			oWs:cCpfUsuario                := cCpfUser
			oWs:cHashSenha                 := cHashSenha
			oWs:cRecibo                    := cNfd
			oWs:cInscricaoMunicipal        := cInscMun
		
			lOk         := ExecWSRet(oWs,"NfdSaida")
			IF lOk
				cNfdEntRet	:= oWs:cNfdSaidaResult
			Else
				cNfdEntRet	:= "Falha ao conectar no WebService."	
			EndIf	
			
			GravaRet(nX,aNotas,cNfdEntRet,cNfd,@cNotasOk)
		//	oWs:cConsultarAtividadesResult := cConsultarAtividadesResult
		Else
		
		EndIf

	Else
		cMsg := "Nota não verificada: [" + cStatusNf + "]"    
		cNotasOk += aNotas[nX][3] +" / "+ aNotas[nX][4] + cMsg +CRLF	     
	EndIf
	
Next nX

Eval(bFiltraBrw)
RestArea(aArea)

Return(cRetorno)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ        
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Fisa022CFG³ Autor ³Roberto Souza          ³ Data ³18.06.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Configura o Ambiente para NFD                               ³±±
±±³          ³(Nota Fiscal Digital de Serviços)                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Fisa022CFG() ////

Local oWizard
Local oCombo, oComboAmbs
Local oCbxGrava

Local cCodMun   := SM0->M0_CODMUN
Local cCert     := Space(250)
Local cKey      := Space(250)
Local cModulo   := Space(250)
Local cPassWord := Space(20)
Local cCombo    := STR0097
Local cSlot     := Space(4)
Local cLabel    := Space(250)
Local cUsuario  := Space(250)
Local cSenha    := Space(250)   
Local cCbxGrava	:= ""
Local cAEDFe	:= Space(20)
Local cChaveAut	:= Space(250)

Local aTexto    := {}
Local aPerg     := {}
Local aPerg2    := {}
Local aParam    := {}
Local aParam2   := {}
Local aDadosEmp := {}

Local cAmbienteNFSe := STR0057
Local cModNFSE      := "0"
Local cVersaoNFSe   := "1   "
Local cCodSIAFI     := Space(4)
Local cUso          :="NFSE" 
Local cCnpJAut      := "  .   .   /    -  "

Local nGrava		:= 2
                                         
aDadosEmp    := GetMunSiaf(cCodMun)      
If Len(aDadosEmp)>0
	cCodSIAFI  := aDadosEmp[1][1]
	If cCodMun $ "3518800|3519071|3518701|1302603|3549904|3549805|3548500|3147105|4118204|4125506|3131307|3536505|3518404|3529401|3523909|3143906|2307650|4314407|3106705|3545209" //Guarulhos#Hortolandia#Guaruja#Manaus#São José dos Campos#São José do Rio Preto#Santos#Pará de Minas#Paranaguá#São José dos Pinhais#Ipatinga#Paulínia#Guaratinguetá#Mauá#Itu#Muriaé#Maracanaú #Betim-MG#SALTO-SP#
		cVersaoNFSe := "3.00"
	ElseIf cCodMun $ "5208707-3201209-3205309-4115200-3146107-4304606-1200401"	 //Goiania # Cachoeiro de Itapemirim # Canoas - RS # Rio Branco - AC
		cVersaoNFSe := "2.01"	
	ElseIf  aDadosEmp[1][2] == "002" .Or. aDadosEmp[1][2] == "004" .OR. aDadosEmp[1][2] == "007" .Or. cCodMun $ "3170107|3118601|3156700|3303302|3300407|3300100|4108304|3538709|2910800|4208203|3305505|4216602|3303401|4204608|3136702|4201307|4303905|4307906|3162104|3127107|3148004|4303103|3148103|3541406|4307708" //Curitiba-Contagem-Sabará-Niteroi-Barra Mansa-Angra dos Reis-Foz do Iguacu-Feira de Santana-Itajaí-Saquarema - São José-SC - Nova Friburgo-RJ - Criciúma-SC- Juiz de Fora - MG  - Araquari -SC - Sao Gotardo - Cachoeirinha-RS - Esteio-RS
		if cCodMun =='3201308' // Cariacica - ES 
			cVersaoNFSe := "2.0"
		elseif cCodMun $ '4308508'//Frederico Westphalen-RS
			cVersaoNFSe := "2.00"	 
		else
			cVersaoNFSe := "1.00"
		endif
	ElseIf cCodMun == "4205407"
		cVersaoNFSe := "1.0"	
	ElseIf cCodMun $ "2507507" 
    		cVersaoNFSe := "2.02"			
    ElseIf cCodMun $ "3506003-4315602" 
    		cVersaoNFSe := "1.01"			
	ElseIf aDadosEmp[1][2] == "009"
	 	cVersaoNFSe := "002"	
	Else
		cVersaoNFSe := "1   "
	EndIf
EndIf 

aadd(aParam,PadR(SuperGetMv("MV_RELSERV"),250))

If SuperGetMv("MV_RELAUTH",,.F.)
	aadd(aParam,PadR(SuperGetMv("MV_RELACNT",,""),250))
Else
	aadd(aParam,PadR(SuperGetMv("MV_RELFROM",,""),250))
EndIf
aadd(aParam,PadR(SuperGetMv("MV_RELPSW"),250))
aadd(aParam,PadR(SuperGetMv("MV_RELFROM",,""),250))
aadd(aParam,SuperGetMv("MV_RELAUTH",,.F.))
aadd(aParam,PadR("",250))

aadd(aPerg,{1,STR0085,aParam[1],"",".T.","",".T.",120,.F.})	//"Servidor SMTP"
aadd(aPerg,{1,STR0086,aParam[2],"",".T.","",".T.",120,.F.})	//"Login do e-mail"
aadd(aPerg,{1,STR0087,aParam[3],"",".T.","",".T.",120,.F.})	//"Senha"
aadd(aPerg,{1,STR0090,aParam[4],"",".T.","",".T.",120,.F.})	//"Conta de e-mail"
aadd(aPerg,{4,STR0088,aParam[5],STR0089,040,".T.",.F.})       //"Autenticação"###"Requerida"
aadd(aPerg,{1,STR0128,aParam[6],"",".T.","",".T.",120,.F.})	//"Conta de e-mail de notificação"

aadd(aParam2,PadR(SuperGetMv("MV_RELSERV"),250))
If SuperGetMv("MV_RELAUTH",,.F.)
	aadd(aParam2,PadR(SuperGetMv("MV_RELACNT",,""),250))
Else
	aadd(aParam2,PadR(SuperGetMv("MV_RELFROM",,""),250))
EndIf                                                          	
aadd(aParam2,PadR(SuperGetMv("MV_RELPSW"),250))

aadd(aPerg2,{1,STR0093,aParam[1],"",".T.","",".T.",120,.F.})	//"Servidor POP"
aadd(aPerg2,{1,STR0086,aParam[2],"",".T.","",".T.",120,.F.})	//"Login do e-mail"
aadd(aPerg2,{1,STR0087,aParam[3],"",".T.","",".T.",120,.F.})	//"Senha"


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem da Interface                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aadd(aTexto,{})
	aTexto[1] := STR0038+CRLF //"Esta rotina tem como objetivo ajuda-lo na configuração da integração com o Protheus com o serviço Totvs Services SPED. "
	aTexto[1] += STR0039 //"O primeiro passo é configurar a conexão do Protheus com o serviço."
	
	aadd(aTexto,{})
	aTexto[2] := STR0040
	
	DEFINE WIZARD oWizard ;
		TITLE STR0041; //"Assistente de configuração da Nota Fiscal Eletrônica"
		HEADER STR0019; //"Atenção"
		MESSAGE STR0020; //"Siga atentamente os passos para a configuração da nota fiscal eletrônica."
		TEXT aTexto[1] ;
		NEXT {|| .T.} ;
		FINISH {|| .T.}
	
	CREATE PANEL oWizard  ;
		HEADER STR0041 ; //"Assistente de configuração da Nota Fiscal Eletrônica"
		MESSAGE ""	;
		BACK {|| .F.} ;
		NEXT {|| IsReady(cCodMun, cURL, 1)} ;
		PANEL
	
	@ 010,010 SAY STR0042 SIZE 270,010 PIXEL OF oWizard:oMPanel[2] //"Informe a URL do servidor Totvs Services"
	@ 025,010 GET cURL SIZE 270,010 PIXEL OF oWizard:oMPanel[2]
	

	CREATE PANEL oWizard  ;
		HEADER STR0041 ; //"Assistente de configuração da Nota Fiscal Eletrônica"
		MESSAGE ""	;
		BACK {|| .T.} ;
		NEXT {|| IsCDReady(@oCombo:nAt,@cCert,@cKey,@cPassWord,@cSlot,@cLabel,@cModulo)} ;
		PANEL

	@ 005,010 SAY STR0095 SIZE 270,010 PIXEL OF oWizard:oMPanel[3] //"Informe o tipo de certificado digital"
	@ 005,105 COMBOBOX oCombo VAR cCombo ITEMS {STR0097,""} SIZE 120,010 OF oWizard:oMPanel[3] PIXEL //"Formato Apache(.pem)"###"Formato PFX(.pfx ou .p12)"###"HSM"
	@ 020,010 SAY STR0043 SIZE 270,010 PIXEL OF oWizard:oMPanel[3] //"Informe o nome do arquivo do certificado digital"
	@ 030,010 GET cCert SIZE 240,010 PIXEL OF oWizard:oMPanel[3] WHEN oCombo:nAt <> 3
	TButton():New( 030,250,STR0044,oWizard:oMPanel[3],{||cCert := cGetFile(IIF(oCombo:nAt == 2,STR0045,STR0098),STR0072,0,"",.T.,GETF_LOCALHARD),.T.},29,12,,oWizard:oMPanel[3]:oFont,,.T.,.F.,,.T., ,, .F.) //"Drive:"###"Arquivos .PEM |*.PEM","Selecione o certificado"
	@ 050,010 SAY STR0047 SIZE 270,010 PIXEL OF oWizard:oMPanel[3] //"Informe senha do arquivo digital"
	@ 060,010 GET cPassWord SIZE 060,010 PIXEL OF oWizard:oMPanel[3] PASSWORD
                    

	CREATE PANEL oWizard  ;
		HEADER STR0041 ; //"Assistente de configuração da Nota Fiscal Eletrônica"
		MESSAGE ""	;
		BACK {|| .T.} ;
		NEXT {|| SetParams(cIdEnt,cUrl,cCodMun,AllTrim(cAmbienteNFSe),AllTrim(cModNFSE),AllTrim(cVersaoNFSe),AllTrim(cCodSIAFI),cCnpJAut,cUsuario,cSenha,nGrava,cAEDFe,aDadosEmp[1][2],cChaveAut)} ;
		PANEL
                                                                   


	@ 010,010 SAY "Ambiente" SIZE 270,010 PIXEL OF oWizard:oMPanel[4] 
	@ 020,010 COMBOBOX oComboAmb VAR cAmbienteNFSe ITEMS {STR0056,STR0057} SIZE 060,010 PIXEL OF oWizard:oMPanel[4] 

	@ 040,010 SAY "Modelo dos WebServices" SIZE 270,010 PIXEL OF oWizard:oMPanel[4]
	@ 050,010 GET cModNFSE SIZE 020,010 PIXEL OF oWizard:oMPanel[4]
                                                                    
	@ 070,010 SAY "Versao" SIZE 270,010 PIXEL OF oWizard:oMPanel[4]
	@ 080,010 GET cVersaoNFSe SIZE 020,010 PIXEL OF oWizard:oMPanel[4]                                                                                  

	@ 100,010 SAY "Codigo SIAFI" SIZE 270,010 PIXEL OF oWizard:oMPanel[4]
	@ 110,010 GET cCodSIAFI SIZE 030,010 PIXEL OF oWizard:oMPanel[4]                                                                                  	

	@ 010,110 SAY "CNPJ do Certificado Digital" SIZE 270,010 PIXEL OF oWizard:oMPanel[4]
	@ 020,110 GET cCnpJAut SIZE 080,010 PICTURE "99.999.999/9999-99" PIXEL OF oWizard:oMPanel[4]
	
	If cCodMun $ "3503307-3515004-3538709-3300704-1400100-3156700-4303905-4307906-4314407-3302403-2803500-3506003-3148103-3146107-4308201-3304508-3541406-3171204-2301000-4315602-1100205-3201308-3304904-3200607-3301900-4107652-3104007" .Or. aDadosEmp[1][2] $ "004-006-011" .Or. cCodMun $ Fisa022Cod("012") //SIMPLISS
		If aDadosEmp[1][2] == "006"
			@ 040,110 SAY "CPF do usuario" SIZE 270,010 PIXEL OF oWizard:oMPanel[4]
		ElseIf cCodMun $ "3506003-3304904"
			@ 040,110 SAY "Inscr. Municipal" SIZE 270,010 PIXEL OF oWizard:oMPanel[4]  
		Else
			@ 040,110 SAY "Nome de usuario" SIZE 270,010 PIXEL OF oWizard:oMPanel[4]
		EndIf
		@ 050,110 GET oUsuario VAR cUsuario SIZE 080,010 PIXEL OF oWizard:oMPanel[4]
		if cCodMun == "4315602"
			oUsuario:disable()
		endif
		
		@ 070,110 SAY "Senha" SIZE 270,010 PIXEL OF oWizard:oMPanel[4]
		@ 080,110 GET cSenha SIZE 080,010 PIXEL OF oWizard:oMPanel[4] PASSWORD
	
	elseIf ( cCodMun $ Fisa022Cod( "101" ) .or. cCodMun $ Fisa022Cod( "102" ) .or. ( cCodMun $ GetMunNFT() .And. cEntSai == "0"  ) ) 
	
		oWs := WsSpedCfgNFe():New()
		oWs:cUSERTOKEN      := "TOTVS"
		oWS:_URL            := AllTrim(cURL)+"/SPEDCFGNFe.apw"	 
		oWS:lftpEnable      := nil
		
		if ( execWSRet( oWS ,"tssCfgFTP" ) )
		
			nGrava := if ( oWS:lTSSCFGFTPRESULT, 1, 2 )
		
			@ 040,110 SAY "Grava arquivo em diretório local?" SIZE 270,010 PIXEL OF oWizard:oMPanel[4]
			@ 050,110 COMBOBOX oCbxGrava VAR cCbxGrava ON CHANGE nGrava := oCbxGrava:nAt ITEMS {"1-Sim","2-Não"} SIZE 060, 010 OF oWizard:oMPanel[4] PIXEL
			oCbxGrava:nAt := nGrava  
			
		endif   
		
		oWS := NIL
			
	EndIf

	If cCodMun == "4205407"
		@ 070,110 SAY "Autorização AEDF-e" SIZE 270,010 PIXEL OF oWizard:oMPanel[4]
		@ 080,110 GET cAEDFe SIZE 080,010 PIXEL OF oWizard:oMPanel[4]
	// Tratamento para Osasco - SP
	ElseIf cCodMun $ "3534401-" + Fisa022Cod("009")+Fisa022Cod("010")
		@ 040,110 SAY "Chave de Autenticação" SIZE 270,010 PIXEL OF oWizard:oMPanel[4]
		@ 050,110 GET cChaveAut SIZE 110,010 PIXEL OF oWizard:oMPanel[4]
	ElseIf cCodMun $ Fisa022Cod("012")
		@ 100,110 SAY "Seq. Registro" SIZE 270,010 PIXEL OF oWizard:oMPanel[4]
		@ 110,110 GET cChaveAut SIZE 080,010 PIXEL OF oWizard:oMPanel[4] 
		@ 010,210 SAY "Cod. Validação" SIZE 270,010 PIXEL OF oWizard:oMPanel[4]
		@ 020,210 GET cAEDFe SIZE 080,010 PIXEL OF oWizard:oMPanel[4]
	ElseIf cCodMun $ "4113700" //Londrina
		@ 100,110 SAY "Código CMC" SIZE 270,010 PIXEL OF oWizard:oMPanel[4]
		@ 110,110 GET cAEDFe SIZE 080,010 PIXEL OF oWizard:oMPanel[4]
	ElseIf cCodMun $ "3171204" 
		@ 100,110 SAY "Chave de Autenticação" SIZE 270,010 PIXEL OF oWizard:oMPanel[4]
		@ 110,110 GET cChaveAut SIZE 110,010 PIXEL OF oWizard:oMPanel[4]
	EndIf
			
	CREATE PANEL oWizard  ;
		HEADER STR0041; //"Assistente de configuração da Nota Fiscal Eletrônica"
		MESSAGE "";
		BACK {|| oWizard:SetPanel(2),.T.} ;
		FINISH {|| lOk := .T.} ;
		PANEL
	@ 010,010 GET aTexto[2] MEMO SIZE 270, 115 READONLY PIXEL OF oWizard:oMPanel[5]
	
	ACTIVATE WIZARD oWizard CENTERED

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³IsReady   ³ Autor ³Eduardo Riera          ³ Data ³18.06.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Verifica se a conexao com a Totvs Sped Services pode ser    ³±±
±±³          ³estabelecida                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN2: Código do município                               OPC³±±
±±³          ³ExpC1: URL do Totvs Services SPED                        OPC³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function IsReady(cCodMun, cURL, nTipo)
	
	Local lRetorno := .T.
	Local oWs      := Nil
	
	Default cCodMun := SM0->M0_CODMUN
	
	If !Empty(cURL) .And. !PutMV("MV_SPEDURL",cURL)
		RecLock("SX6",.T.)
		SX6->X6_FIL     := xFilial( "SX6" )
		SX6->X6_VAR     := "MV_SPEDURL"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "URL do WebService Nota Fiscal de Serviços Eletrônica."
		MsUnLock()
		PutMV("MV_SPEDURL",cURL)
	EndIf
	SuperGetMv() //Limpa o cache de parametros - nao retirar
	
	DEFAULT cURL  := PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Default nTipo := 1
	
	// Verifica se o servidor da Totvs esta no ar
	oWs := WsSpedCfgNFe():New()
	oWs:cUserToken := "TOTVS"
	oWS:_URL := AllTrim(cURL)+"/SPEDCFGNFe.apw"
	If ExecWSRet( oWs ,"CFGCONNECT" )
		lRetorno := .T.
	Else
		Aviso("NFS-e",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{STR0114},3)
		lRetorno := .F.
	EndIf
	
	// Verifica se o certificado digital ja foi transferido
	If lRetorno .And. nTipo == 2
		oWs := WsNFSe001():New()
		oWs:cUserToken := "TOTVS"
		oWs:cID_ENT    := GetIdEnt()
		oWs:cCODMUN    := cCodMun
		oWS:_URL       := AllTrim(cURL)+"/NFSe001.apw"
		If ExecWSRet( oWs ,"CFGREADYX" )
			lRetorno := .T.
		Else
			lRetorno := .F.
		EndIf
	EndIf
	
Return lRetorno


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³IsCDReady ³ Autor ³Eduardo Riera          ³ Data ³18.06.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Verifica se o certificado digital foi transferido com suces-³±±
±±³          ³so                                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1: [1] PEM; [2] PFX                                     ³±±
±±³          ³ExpC2: Certificado digital                                  ³±±
±±³          ³ExpC3: Private Key                                          ³±±
±±³          ³ExpC4: Password                                             ³±±
±±³          ³ExpC5: Slot                                                 ³±±
±±³          ³ExpC6: Label                                                ³±±
±±³          ³ExpC7: Modulo                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function IsCDReady(nTipo,cCert,cKey,cPassWord,cSlot,cLabel,cModulo)

Local lRetorno := .T.
Local cMsg     := ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Obtem o codigo da entidade                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( !Empty(cCert) .And. !Empty(cPassWord) .And. nTipo == 1 ) .Or. !IsReady()

	If nTipo <> 3 .And. !File(cCert)
		Aviso("NFS-e",STR0048,{STR0114},3) //"Arquivo não encontrado"
		lRetorno := .F.
	EndIf

	If !Empty(cIdEnt) .And. lRetorno .And. nTipo <> 3
		
		If Fisa022Pfx(cIdEnt,cCert,AllTrim(cPassWord),@cMsg,"NFSE")
			lRetorno := .T.
		Else
			lRetorno := .F.
		EndIf	
	EndIf

EndIf
Return(lRetorno)           
                   

Function Fisa022Pfx(cIdEnt,cCert,cPassWord,cMsg,cUsoCert)
Local oWS
Local lRetorno := .T.    
Local cURL     := AllTrim(GetNewPar("MV_SPEDURL","http://localhost:8080/nfse"))


oWS:= WsNFSE001():New()
oWs:cUSERTOKEN   := "TOTVS"
oWs:cID_ENT      := cIdEnt 
oWs:cCertificate := GENLoadTXT(cCert)
oWs:cPASSWORD    := AllTrim(cPassWord)
oWS:_URL         := AllTrim(cURL)+"/NFSE001.apw"
oWS:CUso         := "NFSE"

	lOk := ExecWSRet( oWS ,"CFGNFSeCertPfx" )
	
	If lOk 
		oRetorno := oWS:CCFGNFSeCertPfxRESULT
		Aviso("NFS-e",oRetorno,{STR0114},3)
    Else
    	cMsg :=(IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)))
		Aviso("NFS-e",cMsg,{STR0114},3)		
    EndIf

Return(lRetorno)     




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Fis022Mnt1³ Autor ³Roberto Souza          ³ Data ³01.02.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de monitoramento da NFS-e                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Fis022Mnt1(lAuto,aMonitor)

Local aPerg    		:= {}
Local aParam 	  	:= {Space(Len(SF2->F2_SERIE)),Space(Len(SF2->F2_DOC)),Space(Len(SF2->F2_DOC)),Space(14),Space(14)}
Local aSize    		:= {}
Local aObjects 		:= {}
Local aListBox 		:= {}
Local aInfo    		:= {}
Local aPosObj  		:= {}
Local oWS
Local oDlg

Local oBtn1
Local oBtn2
Local oBtn3
Local oBtn4
Local cCodMun     	:= SM0->M0_CODMUN
Local cParMnt    	:= SM0->M0_CODIGO+SM0->M0_CODFIL+"Fis022Mnt1"
Local cAliasSF2		:= GetNExtAlias()
Local cParNfseRem	:= SM0->M0_CODIGO+SM0->M0_CODFIL+"AUTONFSEREM"

Private oListBox

Default lAuto		:= .F.
Default aMonitor	:= {}

aadd(aPerg,{1,STR0010,aParam[01],"",".T.","",".T.",30,.F.}) //"Serie da Nota Fiscal"
aadd(aPerg,{1,STR0011,aParam[02],"",".T.","",".T.",30,.T.}) //"Nota fiscal inicial"
aadd(aPerg,{1,STR0012,aParam[03],"",".T.","",".T.",30,.T.}) //"Nota fiscal final"

If cEntSai == "0"
	aadd(aPerg,{1,STR0143,aParam[04],"",".T.","",".T.",45,.F.}) //" CNPJ Inicial"
	aadd(aPerg,{1,STR0144,aParam[05],"",".T.","",".T.",45,.T.}) //" CNPJ Final"  
EndIf

aParam[01] := ParamLoad(cParMnt,aPerg,1,aParam[01])
aParam[02] := ParamLoad(cParMnt,aPerg,2,aParam[02])
aParam[03] := ParamLoad(cParMnt,aPerg,3,aParam[03]) 

If cEntSai == "0"
	aParam[04] := ParamLoad(cParMnt,aPerg,2,aParam[04])
	aParam[05] := ParamLoad(cParMnt,aPerg,3,aParam[05])
EndIf

If IsReady() 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Obtem o codigo da entidade                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	If !Empty(cIdEnt)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Instancia a classe                                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If lAuto

			aParam[1] 	:= MV_PAR01
			aParam[2] 	:= MV_PAR02
			aParam[3]	:= MV_PAR03
			
			aMonitor	:= WsNFSeMnt( cIdEnt, aParam )

		Else

			If ParamBox(aPerg,"Monitor NFS-e",@aParam,,,,,,,cParMnt,.T.,.T.)

				aListBox := WsNFSeMnt( cIdEnt, aParam )

				If !Empty(aListBox)
					aSize 		:= MsAdvSize()
					aObjects	:= {} 
					
					AAdd( aObjects, { 100, 100, .t., .t. } )
					AAdd( aObjects, { 100, 015, .t., .f. } )
				
					aInfo 	:= { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
					aPosObj	:= MsObjSize( aInfo, aObjects )
											
					DEFINE MSDIALOG oDlg TITLE "NFS-e" From aSize[7],0 to aSize[6],aSize[5] OF oMainWnd PIXEL
					
					@ aPosObj[1,1],aPosObj[1,2] LISTBOX oListBox Fields HEADER "","ID","Ambiente","Modalidade","Protocolo",STR0051,STR0052,STR0053; //"NF"###"Ambiente"###"Modalidade"###"Protocolo"###"Recomendação"###"Tempo decorrido"###"Tempo SEF"
					SIZE aPosObj[1,4]-aPosObj[1,2],aPosObj[1,3]-aPosObj[1,1] PIXEL
					
					oListBox:SetArray( aListBox )
					oListBox:bLine := { || { aListBox[ oListBox:nAT,1 ],aListBox[ oListBox:nAT,2 ],aListBox[ oListBox:nAT,3 ],aListBox[ oListBox:nAT,4 ],aListBox[ oListBox:nAT,5 ],aListBox[ oListBox:nAT,6 ],aListBox[ oListBox:nAT,7 ],aListBox[ oListBox:nAT,8 ]} }
					
					@ aPosObj[2,1],aPosObj[2,4]-040 BUTTON oBtn1 PROMPT STR0114	ACTION (oDlg:End(),aListBox:={}) OF oDlg PIXEL SIZE 035,011 //"OK"
					@ aPosObj[2,1],aPosObj[2,4]-080 BUTTON oBtn2 PROMPT STR0054   	ACTION (Bt2NFSeMnt(aListBox[oListBox:nAT][09])) OF oDlg PIXEL SIZE 035,011 //"Mensagens" 
					@ aPosObj[2,1],aPosObj[2,4]-120 BUTTON oBtn4 PROMPT STR0118 	ACTION (aListBox := WsNFSeMnt(cIdEnt,aParam),oListBox:nAt := 1,IIF(Empty(aListBox),oDlg:End(),RefListBox(oListBox,aListBox))) OF oDlg PIXEL SIZE 035,011 //"Refresh"

					//Opção de so mostrar o botão para padrões que tenham schemas
					If ( cCodMun $ Fisa022Cod("002") .Or. cCodMun $ Fisa022Cod("001") .Or. cCodMun $ Fisa022Cod("007") .Or. cCodMun $ Fisa022Cod("008") .Or. cCodMun $ "4205407-3305505-3506003" ).And. ( cEntSai == "1" )
						@ aPosObj[2,1],aPosObj[2,4]-160 BUTTON oBtn5 PROMPT STR0115	ACTION (DetSchema(cIdEnt,cCodMun,aListBox[ oListBox:nAT,2 ],2),oListBox:Refresh()) OF oDlg PIXEL SIZE 035,011
					EndIf
						
					ACTIVATE MSDIALOG oDlg
				EndIf
				
			EndIf
			
		EndIf
		
	Else
		
		Aviso("NFS-e",STR0021,{STR0114},3)	//"Execute o módulo de configuração do serviço, antes de utilizar esta opção!!!"
	EndIf
	
Else
	
	Aviso("NFS-e",STR0021,{STR0114},3) //"Execute o módulo de configuração do serviço, antes de utilizar esta opção!!!"

EndIf

DelClassIntF()

Return

//-----------------------------------------------------------------------
/*/{Protheus.doc} wsNFSeMnt
Funcao que executa o monitoramento manual

@author Sergio S. Fuzinaka
@since 20.12.2012
@version 1.0      

@param cIdEnt	  		Codigo da entidade
@param aParam			Array de parametros

@return	aListBox		Array - montagem da grid do monitor
/*/
//-----------------------------------------------------------------------
Static Function WsNFSeMnt( cIdEnt, aParam )

Local nMaxLote		:= 20	// Numero maximo de NFS-e por Lote

Local nX			:= 0
Local nY			:= 0
Local aListBox 		:= { .F., "", {} }
Local aRetListBox	:= {}
Local cSerie		:= ""
Local cIdInicial	:= ""
Local cIdFinal		:= ""
Local cCNPJIni		:= ""
Local cCNPJFim		:= ""
Local aLote			:= {}
Local nLote			:= 0
Local aIdNotas		:= {}
Local lProcessou		:= .F.
Local cMod004			:= Fisa022Cod("004")

Default cIdEnt		:= ""
Default aParam		:= {}

If Len( aParam ) > 0

	cSerie 		:= aParam[ 1 ]
	cIdInicial	:= aParam[ 2 ]
	cIdFinal	:= aParam[ 3 ]
		
	If cEntSai == "0"
		cCNPJIni := aParam[ 4 ]
		cCNPJFim := aParam[ 5 ]
	Endif

	For nX := Val( cIdInicial ) To Val( cIdFinal )
		AADD( aIdNotas, StrZero( nX, Len( AllTrim(cIdInicial) ) ) )
	Next

	For nX := 1 To Len( aIdNotas )

		nLote++

		AADD( aLote, aIdNotas[nX] )
	
		If nLote == nMaxLote

			lProcessou := .T.
		
			aRetListBox := MonitorNFSE( cIdEnt, cSerie, aLote, cCNPJIni, cCNPJFim, cMod004 )
			
			For nY := 1 To Len( aRetListBox[3] )
				AADD( aListBox[3], aRetListBox[3,nY] )
			Next

			aListBox[1] := ( Len( aListBox[3] ) > 0 )
			aListBox[2] := IIf( !Empty( aRetListBox[2] ), aRetListBox[2], "" )
			
			lProcessou	:= .F.
			nLote		:= 0
			aLote		:= {}

		Endif
		
	Next
			
	If !lProcessou .And. Len( aLote ) > 0			

		aRetListBox := MonitorNFSE( cIdEnt, cSerie, aLote, cCNPJIni, cCNPJFim, cMod004 )

		For nY := 1 To Len( aRetListBox[3] )
			AADD( aListBox[3], aRetListBox[3,nY] )
		Next

		aListBox[1] := ( Len( aListBox[3] ) > 0 )
		aListBox[2] := IIf( !Empty( aRetListBox[2] ), aRetListBox[2], "" )
		
	Endif
		
	If !aListBox[1]
	
		If !Empty( aListBox[ 2 ] )

			Aviso( "NFS-e", aListBox[ 2 ], { STR0114 }, 3 )

		ElseIf ( Empty( aListBox[ 3 ] ) )

	   		Aviso( "NFS-e", STR0106, { STR0114 } )

		Endif
		
	Endif

Endif

If Len( aListBox[3] ) > 0
	aListBox[3] := aSort( aListBox[3],,,{|x,y| x[2] > y[2]} )
Endif

Return( aListBox[ 3 ] )

//-----------------------------------------------------------------------
/*/{Protheus.doc} MonitorNFSE
Monitoramento manual e automatico da NFS-e

@author Sergio S. Fuzinaka
@since 20.12.2012

@version 1.0      
/*/
//-----------------------------------------------------------------------
Function MonitorNFSE( cIdEnt, cSerie, aLote, cCNPJIni, cCNPJFim, cMod004 )

Local aListBox 		:= { .F., "", {} }
Local nTipoMonitor	:= 1
Local cIdInicial	:= ""
Local cIdFinal		:= ""
Local cIdNotas		:= ""
Local nBytes		:= 0
Local nX			:= 0

Default cIdEnt		:= ""
Default cSerie		:= ""
Default aLote		:= {}
Default cCNPJIni	:= ""
Default cCNPJFim	:= ""

If cEntSai == "1"

	For nX := 1 To Len( aLote )
		
		nBytes += Len( "'" + cSerie + Alltrim( aLote[nX] ) + "', " )
				
		If nBytes <= 950000
			
			cIdNotas += ( "'"  + cSerie + Alltrim( aLote[nX] ) + "'" ) + IIf( nX < Len( aLote ), ", ", "" )
						
		Else
	
			Exit
				
		Endif
				
	Next

Endif
	
If Len( aLote ) > 0

	cIdInicial	:= aLote[ 1 ]
	cIdFinal	:= aLote[ Len( aLote ) ]
	
	aListBox 	:= FisMonitorX( cIdEnt, cSerie, cIdInicial, cIdFinal, cCNPJIni, cCNPJFim, nTipoMonitor, /* dDataDe */, /* dDataAte */, /* cHoraDe */, /* cHoraAte */, /* nTempo */, /* nDiasParaExclusao */, cIdNotas, cMod004 )

Endif
	
Return( aListBox )

//-----------------------------------------------------------------------
/*/{Protheus.doc} FisMonitorX
Funcao executa o metodo MonitorX()

@author Sergio S. Fuzinaka
@since 20.12.2012
@version 1.0      

@param cIdEnt	  		Codigo da entidade
@param aParam			Array de parametros
@param aDados			Dados da Nfs-e

@return	aListBox[1]		Logico   - status processamento
@return	aListBox[2]		Caracter - mensagem de erro
@return	aListBox[3]		Array    - montagem da grid do monitor

@Obs	A rotina de monitoramento da nfs-e eh executado de forma manual e automatica (Auto-Nfse), por este motivo nao dever ser utilizada
		funcoes de alertas como: MsgInfo, MsgAlert, MsgStop, Alert, Aviso, etc.
/*/
//-----------------------------------------------------------------------
Static Function FisMonitorX( cIdEnt, cNumSerie, cIdInicial, cIdFinal, cCNPJIni, cCNPJFim, nTipoMonitor, dDataDe, dDataAte, cHoraDe, cHoraAte, nTempo, nDiasParaExclusao, cIdNotas, cMod004 )

Local aRetorno				:= {}
Local aListBox 				:= {}
Local aMVTitNFT				:= &(GetNewPar("MV_TITNFTS",'{{""},{""}}'))
Local aMsg     				:= {}
Local aDataHora				:= {}

Local dEmiNfe				:= CTOD( "" )
Local cMsgErro				:= ""
Local cHorNFe				:= ""  
Local cNumero				:= ""
Local cSerie				:= ""
Local cRecomendacao			:= ""
Local cNota					:= ""
Local cRPS					:= ""
Local cCnpjForn				:= ""
Local cProtocolo			:= ""
Local cURL     				:= PadR(GetNewPar("MV_SPEDURL","http://"),250)     
Local cCodMun				:= SM0->M0_CODMUN
Local cURLNfse			:= ""
Local lOk      				:= .F.
Local lRetMonit		   		:= .T.	// REVER TRATAMENTO
Local lRetorno				:= .T.

Local nX	 				:= 0
Local nY       				:= 0
Local nTamDoc				:= TamSx3("F2_NFELETR")[1]  
Local nAmbiente				:= 2
Local oOk      				:= LoadBitMap(GetResources(), "ENABLE")
Local oNo      	  			:= LoadBitMap(GetResources(), "DISABLE")
Local cCallName				:= "PROTHEUS"	// Origem da Chamado do WebService

Local oRetorno				:= Nil

Private oWS    				:= Nil
Private oXml				:= Nil  
Private oRetxml				:= Nil  
Private oRetxmlrps	 		:= Nil  

Default cIdEnt				:= ""
Default cNumSerie			:= ""
Default cIdInicial			:= ""
Default cIdFinal			:= ""
Default cCNPJIni			:= ""
Default cCNPJFim			:= ""
Default nTipoMonitor		:= 1
Default dDataDe				:= CTOD( "01/01/1949" )
Default dDataAte			:= CTOD( "31/12/2049" )
Default cHoraDe				:= "00:00:00"
Default cHoraAte			:= "00:00:00"
Default nTempo				:= 0
Default nDiasParaExclusao	:= 0
Default cIdNotas			:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chamada do WebService da NFS-e                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	

oWS := WsNFSE001():New()

oWS:cUSERTOKEN   		:= "TOTVS"
oWS:cID_ENT      		:= cIdEnt 
oWS:_URL         		:= AllTrim(cURL)+"/NFSE001.apw"
oWS:cCODMUN    			:= cCodMun
oWS:dDataDe       		:= dDataDe
oWS:dDataAte     		:= dDataAte
oWS:cHoraDe       		:= cHoraDe
oWS:cHoraAte 			:= cHoraAte
oWS:nTipoMonitor		:= nTipoMonitor
oWS:nTempo   			:= nTempo 

If Type("cVerTss") <> "U" .And. cVerTss >= "2.19"
	oWS:nDiasParaExclusao	:= nDiasParaExclusao
	oWS:cIdNotas	  		:= cIdNotas 
	oWS:cCallName			:= cCallName
Endif

If cEntSai == "0" .And. cCodMun $ "3550308-3304557"
	oWS:cIdInicial := cNumSerie+cIdInicial+cCNPJIni
	oWS:cIdFinal   := cNumSerie+cIdFinal+cCNPJFim+"FIN"
Else 		
	oWS:cIdInicial := cNumSerie+cIdInicial
	oWS:cIdFinal   := cNumSerie+cIdFinal
EndIf

lOk := ExecWSRet(oWS,"MonitorX")

If ( lOk )

	oRetorno := oWS:OWSMONITORXRESULT
	
	SF3->(dbSetOrder(5))
	
	For nX := 1 To Len(oRetorno:OWSMONITORNFSE)
		
		aMsg 			:= {}
		lRegFin 		:= .F.
						
		oXml 			:= oRetorno:OWSMONITORNFSE[nX]
		
		if lRegFin
	 		cNumero			:= PADR(SUBSTR(oXml:Cid,4,Len(oXml:Cid)),TamSX3("E2_NUM")[1])	
	 	else
		 	cNumero			:= PADR(Substr(oXml:cID,4,Len(oXml:cID)),TamSX3("F2_DOC")[1])	
	 	endif
		
		cProtocolo		:= oXml:cPROTOCOLO
		dEmiNfe			:= CTOD( "" )
		cHorNFe			:= ""
		cSerie			:= Substr(oXml:cID,1,3)
		cRecomendacao	:= oXml:cRECOMENDACAO
		cNota			:= oXml:cNota
		cRPS			:= oXml:cRPS
		cCnpjForn		:= padR(Substr(oXml:cid,13,Len(oXml:cid)),14)
		nAmbiente		:= oXml:nAmbiente
		if Type("oXml:cURLNFSE") <> "U"
			cURLNfse := oXml:cURLNFSE
		endif
		
		if RAT( "FIN", oXml:cid ) > 0 .And. SubStr( oXml:cid, RAT( "FIN", oXml:cid ) ) == "FIN" .And. cEntSai == "0"
			lRegFin := .T.			
		endif

		// Retorna a Data e a Hora do arquivo XML
		aDataHora 		:= FisRetDataHora( oRetorno:OWSMONITORNFSE[nX], cMod004 )

		If Len( aDataHora ) > 0
			dEmiNfe	:= aDataHora[ 1 ]	// Data
			cHorNFe	:= aDataHora[ 2 ]	// Hora
		Endif
		
		// Atualiza os dados com as mensagens de transmissao
		If ( Type("oXml:OWSERRO:OWSERROSLOTE") <> "U" )
			
			For nY := 1 To Len(oXml:OWSERRO:OWSERROSLOTE)
				
				If ( oXml:OWSERRO:OWSERROSLOTE[nY]:CCODIGO <> '' )
					aadd(aMsg,{oXml:OWSERRO:OWSERROSLOTE[nY]:CCODIGO,oXml:OWSERRO:OWSERROSLOTE[nY]:CMENSAGEM})
				EndIf
				
			Next nY
			
		EndIf
		
		If ( Empty( aMsg ) )
			AADD( aMsg, { "", "" } )
		EndIf
		
		If ( Empty( cProtocolo ) )
			
			If ( 'Schema Invalido' $ cRecomendacao )
				aMsg := {}
				aAdd(aMsg,{"999",cRecomendacao})
			EndIf
			
			if Len( aMsg ) > 0 .And. !Empty( aMsg[1][1] ) 
				If ( cEntSai == "1" )
					
					SF2->(dbSetOrder(1))
					If ( SF2->(MsSeek(xFilial("SF2")+cNumero+cSerie,.T.)) )
						
						SF2->( RecLock("SF2") )
						SF2->F2_FIMP := "N"
						SF2->( MsUnlock() )
						
						SF3->(dbSetOrder(5))
						If ( SF3->(MsSeek(xFilial("SF3")+SF2->F2_SERIE+SF2->F2_DOC+SF2->F2_CLIENTE+SF2->F2_LOJA)) )
							
							If SF3->( FieldPos("F3_CODRSEF") ) > 0
								SF3->( RecLock("SF3") )
								SF3->F3_CODRSEF := "N"
								
								If SF3->( FieldPos("F3_CODRET") ) > 0 .And. SF3->( FieldPos("F3_DESCRET") ) > 0 .And. Empty( SF3->F3_CODRET )
									
										SF3->F3_CODRET	:= aMsg[1][1]
										SF3->F3_DESCRET	:= aMsg[1][2]
									
								EndIf
								
								SF3->( MsUnlock() )
							EndIf
							
						EndIf
					EndIf
				
				elseif ( lRegFin )
					
					SE2->(dbSetOrder(1))
					
					If ( SE2->(MsSeek(xFilial("SE2")+(cSerie+cNumero),.T.)) ) .And. SE2->( FieldPos("E2_FIMP") ) > 0				
						
						While SE2->(!eof()) .And. xFilial("SE2") == SE2->E2_FILIAL .And. ( PADR(cNumero,LEN(SE2->E2_NUM)) == SE2->E2_NUM) .And. ( cSerie == SE2->E2_PREFIXO )
							
							If cCnpjForn == Posicione("SA2",1,xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA,"SA2->A2_CGC") .And. ;
								aScan(aMVTitNFT,{|x| x[1]==SE2->E2_TIPO}) > 0 .And. SE2->E2_FIMP <> "N"
								
								RecLock("SE2")
								SE2->E2_FIMP := "N"
								SE2->(MsUnlock())
								
							EndIf
						
							SE2->(dbSkip())	
						
						EndDo								
								 	
					EndIf
					
				Else
					
					SF1->(dbSetOrder(1))
					If ( SF1->(MsSeek(xFilial("SF1")+cNumero+cSerie,.T.)) )
						
						SF1->( RecLock("SF1") )
						SF1->F1_FIMP := "N"
						SF1->( MsUnlock() )
						
						SF3->(dbSetOrder(5))
						If SF3->( MsSeek( xFilial("SF3")+SF1->F1_SERIE+SF1->F1_DOC+SF1->F1_FORNECE+SF1->F1_LOJA ) )
							
							If SF3->( FieldPos( "F3_CODRSEF" ) ) > 0
								SF3->( RecLock("SF3") )
								SF3->F3_CODRSEF := "N"
								SF3->( MsUnlock() )
							EndIf
							
						EndIf
						
					EndIf
					
				EndIf

				//Atualização da tabela de AIDF
				if aliasIndic("C0P") 
					C0P->(dbSetOrder(1))
					if C0P->(dbSeek(xFilial() +  padr(cValToChar(val(SF3->F3_NFISCAL)), tamSX3("C0P_RPS")[1] ) ) )
						reclock("C0P")
						C0P->C0P_AUT		:= "N"
						C0P->(msunlock())
					endif
				endif	

			endif
		Else
			
			If ( "Emissao de Nota Autorizada." $ cRecomendacao )
				aMsg := {}
				aAdd(aMsg,{"111",cRecomendacao})
			ElseIf ( 'Nota Fiscal Substituida' $ cRecomendacao )
				aMsg := {}
				aAdd(aMsg,{"222",cRecomendacao})
			ElseIf ( 'Cancelamento do RPS Autorizado' $ cRecomendacao )
				aMsg := {}
				aAdd(aMsg,{"333",cRecomendacao})
			EndIf
			
			If ( cEntSai == "1"	)
				
				SF2->( dbSetOrder(1) )
				If SF2->(MsSeek(xFilial("SF2")+cNumero+cSerie,.T.))
					
					SF2->( RecLock("SF2") )
					SF2->F2_FIMP := "S"
					
					If ( !Empty(cNota) )
						SF2->F2_NFELETR	:= RIGHT(cNota,nTamDoc)
						SF2->F2_EMINFE	:= dEmiNfe
						SF2->F2_HORNFE	:= cHorNFe
						SF2->F2_CODNFE	:= RTrim(cProtocolo)
					EndIf
					
					SF2->( MsUnlock() )
					
					SF3->(dbSetOrder(5))
					If ( SF3->(MsSeek(xFilial("SF3")+SF2->F2_SERIE+SF2->F2_DOC+SF2->F2_CLIENTE+SF2->F2_LOJA)) )
						
						If ( SF3->(FieldPos("F3_CODRSEF")) > 0 )
							
							SF3->( RecLock("SF3") )
							SF3->F3_CODRSEF := "S"
							
							If SF3->(FieldPos("F3_CODRET")) > 0 .And. SF3->(FieldPos("F3_DESCRET")) > 0
								If Len( aMsg ) > 0 .And. !Empty( aMsg[1][1] )
									SF3->F3_CODRET	:= aMsg[1][1]
									SF3->F3_DESCRET	:= aMsg[1][2]
								Endif
							EndIf
							
							If ( !Empty(cNota) )
								SF3->F3_NFELETR	:= RIGHT(cNota,nTamDoc)
								SF3->F3_EMINFE	:= dEmiNfe
								SF3->F3_HORNFE	:= cHorNFe
								SF3->F3_CODNFE	:= RTrim(cProtocolo)
							EndIf
							
							SF3->(MsUnlock())
						EndIf
					EndIf
					
					SE1->(dbSetOrder(2))
					If ( SE1->(MsSeek(xFilial("SE1")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_SERIE+SF2->F2_DOC)) )
						
						If ( Alltrim(SF3->F3_CODRSEF) == "S" )
							If ( !empty(cNota) )
								
								While SE1->(!eof()) .And. xFilial("SE1") == SF2->F2_FILIAL .And. SE1->E1_CLIENTE == SF2->F2_CLIENTE .And. SE1->E1_LOJA == SF2->F2_LOJA .And. SE1->E1_PREFIXO == SF2->F2_SERIE .And. SE1->E1_NUM == SF2->F2_DOC .Or.  ( SE1->(!eof()) .And. SE1->E1_FILORIG == SF2->F2_FILIAL .And. SE1->E1_CLIENTE == SF2->F2_CLIENTE .And. SE1->E1_LOJA == SF2->F2_LOJA .And. SE1->E1_PREFIXO == SF2->F2_SERIE .And. SE1->E1_NUM == SF2->F2_DOC )
									
									SE1->( RecLock("SE1") )
									SE1->E1_NFELETR := RIGHT(cNota,nTamDoc)
									SE1->(MsUnlock())
									
									SE1->( dbSkip() )
								EndDo
								
							EndIf
						EndIf
						
					ElseIf 	( SE1->(MsSeek(xFilial("SE1")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_PREFIXO+SF2->F2_DOC)) )
						
						If ( Alltrim(SF3->F3_CODRSEF) == "S" )
							If ( !empty(cNota) )
								
								While SE1->(!eof()) .And. xFilial("SE1") == SF2->F2_FILIAL .And. SE1->E1_CLIENTE == SF2->F2_CLIENTE .And. SE1->E1_LOJA == SF2->F2_LOJA .And. SE1->E1_PREFIXO == SF2->F2_PREFIXO .And. SE1->E1_NUM == SF2->F2_DOC .Or. ( SE1->(!eof()) .And. SE1->E1_FILORIG == SF2->F2_FILIAL .And. SE1->E1_CLIENTE == SF2->F2_CLIENTE .And. SE1->E1_LOJA == SF2->F2_LOJA .And. SE1->E1_PREFIXO == SF2->F2_PREFIXO .And. SE1->E1_NUM == SF2->F2_DOC )
									
									SE1->( RecLock("SE1") )
									SE1->E1_NFELETR := RIGHT(cNota,nTamDoc)
									SE1->( MsUnlock() )
									
									SE1->( dbSkip() )
								EndDo
								
							EndIf
						EndIf
					EndIf
					
					SFT->(dbSetOrder(1))
					If ( SFT->(MsSeek(xFilial("SFT")+"S"+SF2->F2_SERIE+SF2->F2_DOC+SF2->F2_CLIENTE+SF2->F2_LOJA)) )
						
						If ( Alltrim(SF3->F3_CODRSEF) == "S" )
							
							If ( !Empty(cNota) )
								
								While SFT->(!eof()) .And. xFilial("SFT") == SF2->F2_FILIAL .And. SFT->FT_TIPOMOV == "S" .And. SFT->FT_SERIE == SF2->F2_SERIE .And. SFT->FT_NFISCAL == SF2->F2_DOC .And. SFT->FT_CLIEFOR == SF2->F2_CLIENTE .And. SFT->FT_LOJA == SF2->F2_LOJA
									SFT->( RecLock("SFT") )
									SFT->FT_NFELETR	:= RIGHT(cNota,nTamDoc)
									SFT->FT_EMINFE	:= dEmiNfe
									SFT->FT_HORNFE	:= cHorNFe
									SFT->FT_CODNFE	:= RTrim(cProtocolo)
									SFT->( MsUnlock() )
									
									SFT->( dbSkip() )
								EndDo
								
							EndIf
						EndIf
					EndIf
					
					If IntTms()
						DT6->(DbSetOrder(1))
						If DT6->(DbSeek(xFilial("DT6")+SF2->F2_FILIAL+ SF2->F2_DOC+SF2->F2_SERIE))
							If ( Alltrim(SF3->F3_CODRSEF) == "S" )
								If ( !Empty(cNota) )
									While DT6->(!eof()) .And. DT6->DT6_SERIE == SF2->F2_SERIE .And. DT6->DT6_DOC == SF2->F2_DOC .And. DT6->DT6_CLIDEV == SF2->F2_CLIENTE .And. DT6->DT6_LOJDEV == SF2->F2_LOJA
										
										DT6->( RecLock("DT6") )
										DT6->DT6_NFELET := RIGHT(cNota,nTamDoc)
										DT6->DT6_EMINFE := dEmiNfe
										DT6->DT6_CODNFE := RTrim(cProtocolo)
										DT6->( MsUnlock() )
										
										DT6->(dbSkip())
										
									EndDo
								EndIf
							EndIf
						EndIf
					EndIf
					
				Else
					
					dbSelectArea("SF3")
					SF3->( dbSetOrder(5) )
					If SF3->( MsSeek( xFilial("SF3") + cSerie + cNumero ) )
						If SF3->( FieldPos("F3_CODRSEF") ) > 0
							SF3->( RecLock("SF3") )
							SF3->F3_CODRSEF := "S"
							
							If SF3->(FieldPos("F3_CODRET")) > 0 .And. SF3->(FieldPos("F3_DESCRET")) > 0
								If Len( aMsg ) > 0 .And. !Empty( aMsg[1][1] )
									SF3->F3_CODRET	:= aMsg[1][1]
									SF3->F3_DESCRET	:= aMsg[1][2]
								Endif
							EndIf
							
							If !Empty(oXml:cNota) .And. !Empty(oRetxml) .Or. !Empty(oXml:cNota) .And. !Empty(oRetxmlrps)
								SF3->F3_NFELETR	:= RIGHT(oXml:cNota,nTamDoc)
								SF3->F3_EMINFE	:= dEmiNfe
								SF3->F3_HORNFE	:= cHorNFe
								SF3->F3_CODNFE	:= RTrim(oXml:cProtocolo)
							EndIf
							
							SF3->( MsUnlock() )
						EndIf
					EndIf
					
					lRetMonit := GetMonitRx(cIdEnt,cUrl)
				EndIf
			
			elseif lRegFin
					
					SE2->(dbSetOrder(1))
					
					If ( SE2->(DbSeek(xFilial("SE2")+(cSerie+cNumero))) ) .And. SE2->( FieldPos("E2_FIMP") ) > 0 .And. SE2->( FieldPos("E2_NFELETR") ) > 0
						
						While SE2->(!eof()) .And. xFilial("SE2") == SE2->E2_FILIAL .And. ( PADR(cNumero,LEN(SE2->E2_NUM)) == SE2->E2_NUM) .And. ( cSerie == SE2->E2_PREFIXO )
							
							If cCnpjForn == Posicione("SA2",1,xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA,"SA2->A2_CGC") .And. ;
								aScan(aMVTitNFT,{|x| x[1]==SE2->E2_TIPO}) > 0 .And. SE2->E2_FIMP <> "S"
														
								RecLock("SE2")
								SE2->E2_FIMP := "S"
								SE2->E2_NFELETR := cNota
								SE2->(MsUnlock())
								
							EndIf
						
							SE2->(dbSkip())	
						
						EndDo								
								 	
					EndIf
				
			Else
				
				SF1->(dbSetOrder(1))
				If ( SF1->(MsSeek(xFilial("SF1")+(PADR(cNumero,LEN(SF1->F1_DOC))+cSerie),.T.)) )
					
					While SF1->(!eof()) .And. xFilial("SF1") == SF1->F1_FILIAL .And. ( PADR(cNumero,LEN(SF1->F1_DOC)) == SF1->F1_DOC) .And. ( cSerie == SF1->F1_SERIE )
						
						If cCnpjForn == Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"SA2->A2_CGC")
							
							SF1->( RecLock("SF1") )
							SF1->F1_FIMP := "S"
							
							If ( !Empty(cNota) )
								SF1->F1_NFELETR	:= RIGHT(cNota,nTamDoc)
								SF1->F1_EMINFE	:= dEmiNfe
								SF1->F1_HORNFE	:= cHorNFe
								SF1->F1_CODNFE	:= RTrim(cProtocolo)
							EndIf
							
							SF1->( MsUnlock() )
							
							SF3->( dbSetOrder(5) )
							If ( SF3->(MsSeek(xFilial("SF3")+SF1->F1_SERIE+SF1->F1_DOC+SF1->F1_FORNECE+SF1->F1_LOJA)) )
								
								If ( SF3->(FieldPos("F3_CODRSEF")) > 0 )
									
									SF3->( RecLock("SF3") )
									SF3->F3_CODRSEF := "S"
									
									If ( !Empty( cNota ) )
										SF3->F3_NFELETR	:= RIGHT(cNota,nTamDoc)
										SF3->F3_EMINFE	:= dEmiNfe
										SF3->F3_HORNFE	:= cHorNFe
										SF3->F3_CODNFE	:= RTrim(cProtocolo)
									EndIf
									
									SF3->(MsUnlock())
									
								EndIf
							EndIf
							
							SE2->( dbSetOrder(2) )
							If ( SE2->(MsSeek(xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC)) )
								
								If ( Alltrim(SF3->F3_CODRSEF) == "S" )
									If ( !Empty( cNota ) )
										
										While SE2->(!EOF()) .And. xFilial("SE1") == SF2->F2_FILIAL .And. SE2->E2_CLIENTE == SF1->F1_FORNECE .And. SE2->E2_LOJA == SF1->F1_LOJA .And. SE2->E2_PREFIXO == SF1->F1_SERIE .And. SE2->E2_NUM == SF1->F1_DOC
											
											SE2->( RecLock("SE2") )
											SE2->E2_NFELETR := RIGHT(cNota,nTamDoc)
											SE2->( MsUnlock() )
											
											SE2->( dbSkip() )
										EndDo
										
									EndIf
								EndIf
								
							EndIf
							
							SFT->( dbSetOrder(1) )
							If ( SFT->(MsSeek(xFilial("SFT")+"E"+SF1->F1_SERIE+SF1->F1_DOC+SF1->F1_FORNECE+SF1->F1_LOJA)) )
								
								If ( Alltrim(SF3->F3_CODRSEF) == "S" )
									If ( !Empty( cNota ) )
										
										While SFT->(!EOF()) .And. xFilial("SFT") == SF1->F1_FILIAL .And. SFT->FT_TIPOMOV == "E" .And. SFT->FT_SERIE == SF1->F1_SERIE .And. SFT->FT_NFISCAL == SF1->F1_DOC .And. SFT->FT_CLIEFOR == SF1->F1_FORNECE .And. SFT->FT_LOJA == SF1->F1_LOJA
											
											SFT->( RecLock("SFT") )
											SFT->FT_NFELETR	:= RIGHT(cNota,nTamDoc)
											SFT->FT_EMINFE	:= dEmiNfe
											SFT->FT_HORNFE	:= cHorNFe
											SFT->FT_CODNFE	:= RTrim(cProtocolo)
											SFT->( MsUnlock() )
											
											SFT->(dbSkip())
										EndDo
										
									EndIf
								EndIf
							EndIf
						EndIf
						SF1->(dbSkip())
					EndDo
				EndIf
			EndIf
			
			//atualização da tabela de AIDF
			if aliasIndic("C0P") 
				C0P->(dbSetOrder(1))
				If cCodMun == "3524006" .and. !C0P->(dbSeek(xFilial() +  padr(cValToChar(val(SF3->F3_NFISCAL)), tamSX3("C0P_RPS")[1] ) ) )
					cNotaArq := "0"
				Else
					cNotaArq := cValToChar(val(SF3->F3_NFISCAL))
				EndIf
			
				if C0P->(dbSeek(xFilial() +  padr(cNotaArq, tamSX3("C0P_RPS")[1] ) ) ) .and. Empty(C0P->C0P_AUT)
					reclock("C0P",.F.)
					C0P->C0P_AUT		:= "S"
					If cCodMun == "3524006"
						C0P->C0P_RPS	:= val(SF3->F3_NFISCAL)
					EndIf
					C0P->(msunlock())
				endif
			endif	
		EndIf

		If FindFunction( "autoNfseMsg" )
			autoNfseMsg( "[Monitoramento] Nota Monitorada: " + cSerie + cNumero, .F. )
		Endif

		AADD( aListBox, {	IIf( Empty(cProtocolo), oNo, oOk ),;
							cSerie + cNumero,;
							IIf( nAmbiente == 1, STR0056, STR0057 ),; //"Produção"###"Homologação"
							STR0058,; //"Normal"###"Contingência"
							cProtocolo,;
							PADR( cRecomendacao, 250 ),;
							cRPS,;
							cNota,;
							aMsg,;
							cURLNfse} )
							
	//Ponto de entrada para o cliente customizar a gravação de 
	//campos proprios no SF2/SF1 a partir do refreh no monitor de notas
	If ExistBlock('F022ATUNF')
		ExecBlock('F022ATUNF',.F.,.F.,{cSerie,cNumero,cProtocolo,cRPS})
	EndIf
	
	Next nX
	
	If Empty( aListBox )
		lRetorno	:= .F.
		cMsgErro	:= STR0106
	EndIf
	
Else

	lRetorno	:= .F.
	cMsgErro	:= IIf( Empty(GetWscError(3)), GetWscError(1), GetWscError(3) )

EndIf

oWS			:= Nil  
oXml		:= Nil  
oRetxml		:= Nil  
oRetxmlrps  := Nil  

aRetorno 	:= {}

AADD( aRetorno, lRetorno )
AADD( aRetorno, cMsgErro )
AADD( aRetorno, aListBox )
    
Return( aRetorno )

//-----------------------------------------------------------------------
/*/{Protheus.doc} FisRetDataHora
Funcao que retorna Data e Hora do XML

@author Sergio S. Fuzinaka
@since 20.12.2012
@version 1.0      
/*/
//-----------------------------------------------------------------------
Static Function FisRetDataHora( oXml, cMod004 )

Local aRetorno		:= {}
Local aDados		:= {}
local aRet			:= {}
Local nA			:= 0
Local nW	   		:= 0
Local nB			:= 0 
Local cCodMun		:= SM0->M0_CODMUN 
Local cUsaColab		:= UPPER(GetNewPar("MV_SPEDCOL","N"))
Local cRecXml		:= ""
Local cRethora		:= ""
Local cRetdata		:= ""
Local dDataConv		:= CTOD( "" )
Local cAviso		:= ""                                 
Local cErro			:= ""
Local cCID			:= "" 
Local cRetxmlrps	:= ""

Private oWS			:= NIL
Private oRetxml		:= NIL
Private oRetxmlrps  := NIl  

If Type( "oXml" ) <> "U"
	oWS := oXml
Endif
   		
If Type( "oWS:cID" ) <> "U" .And. !Empty( Alltrim( oWS:cID ) )

	cCID := Alltrim( oWS:cID )

	If ( IsTSSModeloUnico() .And. Type( "oWS:XMLRETTSS" ) <> "U" .And. !Empty( oWS:XMLRETTSS ) )
		
		AADD( aDados, RetornaMonitor( cCID, oWS:XMLRETTSS ) )
		
	Else
	
		cRetdata	:= ""
		cRethora	:= ""
		dDataconv 	:= CTOD( "" )
		
		
		if ( ( cCodMun == "3550308" .Or. cCodMun == "2611606" .Or. cCodMun == "4202404" .Or. cCodMun == "4209102") .And. ( cEntSai == "1" ) )  //SAO PAULO, RECIFE, BLUMENAU E JOINVILLE.		
			if Type( "oWS:OWSNFE:CXMLERP" ) <> "U" .And. !Empty( oWS:OWSNFE:CXMLERP )
				cRecxml		:= oWS:OWSNFE:CXMLERP			
			endif
		else
			If Type( "oWS:OWSNFE:CXML" ) <> "U" .And. !Empty( oWS:OWSNFE:CXML )
				cRecxml		:= oWS:OWSNFE:CXML			
			endif
		endif		
		
					
		aRet := retDataXMLNfse(cRecxml,cCodMun)		

		if ( ( ( cCodMun == "3550308" .or. cCodMun == "2611606" .or. cCodMun == "4202404" ) .And. ( cEntSai == "1" ) ) .or.  GetMunSiaf(cCodMun)[1][2] $ "004-006-009"  )  //SAO PAULO E RECIFE E BLUMENAU
			aRet[2] := "00:00:00"
		Elseif GetMunSiaf(cCodMun)[1][2] $ "011" .Or. cCodMun $ "4308201-3524006"
			aRet[1] := ddatabase
			aRet[2] := "00:00:00"	
		endif

		AADD( aDados, { cCID, aRet[1], aRet[2], "" } )
	
	EndIf	

Endif

oWS			:= NIL

aRetorno 	:= {}

If Len( aDados ) > 0

	AADD( aRetorno, aDados[ 1, 2 ] )
	AADD( aRetorno, aDados[ 1, 3 ] )

Endif

Return( aRetorno )

//-----------------------------------------------------------------------
/*/{Protheus.doc} Bt2NFSeMnt


@author
@since
@version
/*/
//-----------------------------------------------------------------------
Static Function Bt2NFSeMnt(aMsg)

Local aSize    := MsAdvSize()
Local aObjects := {}
Local aInfo    := {}
Local aPosObj  := {}
Local oDlg
Local oListBox
Local oBtn1

If !Empty(aMsg)
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 015, .t., .f. } )
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
	
	DEFINE MSDIALOG oDlg TITLE "NFS-e" From aSize[7],0 to aSize[6],aSize[5] OF oMainWnd PIXEL
	@ aPosObj[1,1],aPosObj[1,2] LISTBOX oListBox Fields HEADER "Cod Erro", "Mensagem"; 
						SIZE aPosObj[1,4]-aPosObj[1,2],aPosObj[1,3]-aPosObj[1,1] PIXEL
	oListBox:SetArray( aMsg )
	oListBox:bLine := { || { aMsg[ oListBox:nAT,1 ],aMsg[ oListBox:nAT,2 ]} }
	@ aPosObj[2,1],aPosObj[2,4]-030 BUTTON oBtn1 PROMPT STR0114         ACTION oDlg:End() OF oDlg PIXEL SIZE 028,011
	ACTIVATE MSDIALOG oDlg
EndIf
Return(.T.)


Static Function GENLoadTXT(cFileImp)
Local cTexto     := ""
Local cNewFile   := ""
Local cExt       := "" 
//Local cRootPath  := GetSrvProfString("RootPath","")
Local cStartPath := GetSrvProfString("StartPath","")
Local nHandle    := 0
Local nTamanho   := 0
Local cDrive     := ""
Local cPath		 :=	""
Local lCopied	 :=	.F.                     


cStartPath := StrTran(cStartPath,"/","\")
cStartPath +=If(Right(cStartPath,1)=="\","","\")

cFileOrig:= Alltrim(cFileImp)
If Substr(cFileImp,1,1) == "\"
//	cFileImp := AllTrim(cRootPath)+Alltrim(cFileImp)
EndIf    

SplitPath(cFileOrig,@cDrive,@cPath, @cNewFile,@cExt)

cNewFile	:=	cNewFile+cExt
If Empty(cDrive)
	lCopied := __CopyFile(cFileImp, cStartPath+cNewFile) 
Else
	lCopied := CpyT2S(cFileImp,cStartPath)
EndIf		

If lCopied
	nHandle 	:= 	FOpen(cNewFile)
	If nHandle > 0
		nTamanho := Fseek(nHandle,0,FS_END)
		FSeek(nHandle,0,FS_SET)
		FRead(nHandle,@cTexto,nTamanho)
		FClose(nHandle)
		FErase(cNewFile)
	Else
	   	cAviso := "Falha ao tentar obter acesso ao arquivo "+cNewFile
	   	Aviso("NFS-e",cAviso,{"OK"},3)
	EndIf

Else                                         
   	cAviso := "Falha ao tentar copiar o arquivo "+cNewFile +CRLF
   	cAviso += "para o diretorio raiz do Protheus."
  	Aviso("NFS-e",cAviso,{"OK"},3)	
EndIf	

If lCopied
	FErase(cNewFile)
EndIf

Return(cTexto)





/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³GetIdEnt  ³ Autor ³Eduardo Riera          ³ Data ³18.06.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Obtem o codigo da entidade apos enviar o post para o Totvs  ³±±
±±³          ³Service                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpC1: Codigo da entidade no Totvs Services                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GetIdEnt()

Local aArea  := GetArea()
Local cIdEnt := ""
Local cURL   := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local oWs
Local lUsaGesEmp := IIF(FindFunction("FWFilialName") .And. FindFunction("FWSizeFilial") .And. FWSizeFilial() > 2,.T.,.F.)
Local lEnvCodEmp := GetNewPar("MV_ENVCDGE",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Obtem o codigo da entidade                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oWS := WsSPEDAdm():New()
oWS:cUSERTOKEN := "TOTVS"
	
oWS:oWSEMPRESA:cCNPJ       := IIF(SM0->M0_TPINSC==2 .Or. Empty(SM0->M0_TPINSC),SM0->M0_CGC,"")	
oWS:oWSEMPRESA:cCPF        := IIF(SM0->M0_TPINSC==3,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cIE         := SM0->M0_INSC
oWS:oWSEMPRESA:cIM         := SM0->M0_INSCM		
oWS:oWSEMPRESA:cNOME       := SM0->M0_NOMECOM
oWS:oWSEMPRESA:cFANTASIA   := IIF(lUsaGesEmp,FWFilialName(),Alltrim(SM0->M0_NOME))
oWS:oWSEMPRESA:cENDERECO   := FisGetEnd(SM0->M0_ENDENT)[1]
oWS:oWSEMPRESA:cNUM        := FisGetEnd(SM0->M0_ENDENT)[3]
oWS:oWSEMPRESA:cCOMPL      := FisGetEnd(SM0->M0_ENDENT)[4]
oWS:oWSEMPRESA:cUF         := SM0->M0_ESTENT
oWS:oWSEMPRESA:cCEP        := SM0->M0_CEPENT
oWS:oWSEMPRESA:cCOD_MUN    := SM0->M0_CODMUN
oWS:oWSEMPRESA:cCOD_PAIS   := "1058"
oWS:oWSEMPRESA:cBAIRRO     := SM0->M0_BAIRENT
oWS:oWSEMPRESA:cMUN        := SM0->M0_CIDENT
oWS:oWSEMPRESA:cCEP_CP     := Nil
oWS:oWSEMPRESA:cCP         := Nil
oWS:oWSEMPRESA:cDDD        := Str(FisGetTel(SM0->M0_TEL)[2],3)
oWS:oWSEMPRESA:cFONE       := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
oWS:oWSEMPRESA:cFAX        := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
oWS:oWSEMPRESA:cEMAIL      := UsrRetMail(RetCodUsr())
oWS:oWSEMPRESA:cNIRE       := SM0->M0_NIRE
oWS:oWSEMPRESA:dDTRE       := SM0->M0_DTRE
oWS:oWSEMPRESA:cNIT        := IIF(SM0->M0_TPINSC==1,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cINDSITESP  := ""
oWS:oWSEMPRESA:cID_MATRIZ  := ""

If lUsaGesEmp .And. lEnvCodEmp
	oWS:oWSEMPRESA:CIDEMPRESA:= FwGrpCompany()+FwCodFil()
EndIf
oWS:oWSOUTRASINSCRICOES:oWSInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
oWS:_URL := AllTrim(cURL)+"/SPEDADM.apw"
If ExecWSRet(oWs,"ADMEMPRESAS")
	cIdEnt  := oWs:cADMEMPRESASRESULT
Else
	Aviso("NFS-e",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{STR0114},3)
EndIf

RestArea(aArea)
Return(cIdEnt)


Function Fisa022Cod(cCodServ, cVerTss, cEntidade , cIdEnt )

Local cRet := "" 
Local cURL := ""              

Local oWs

default cEntidade	:= ""
default cIdEnt		:= GetIdEnt()

if ( empty(cEntidade) )
	cEntidade := cIdEnt 
endif

cURL	:= Padr( GetNewPar("MV_SPEDURL","http://localhost:8080/nfse"),250 )

oWS:= WsNFSE001():New()
oWs:cUSERTOKEN   := "TOTVS"
oWs:cID_ENT      := cEntidade 
oWs:cCSERVICO    := cCodServ 
oWS:_URL         := AllTrim(cURL)+"/NFSE001.apw"   

If ExecWSRet(oWs,"RETMUNSERV")
	cRet := oWs:CRETMUNSERVRESULT            
EndIf   

oWs := Nil	

Return cRet

                 
Function Fisa022Ok( cCodMun )
Return .T.
             
Static Function SetParams(cIdEnt, cUrl, cCodMun, cAmbienteNFSe, cModNFSE, cVersaoNFSe, cCodSIAFI, cCnpJAut, cUsuario, cSenha, nGrava,cAEDFe,cModelo,cChaveAut)
	
	Local lRet       	:= .T.
	Local oWs        	:= Nil     
	Local oWS2		 	:= Nil
	Local lOk        	:= .F.
	Local cMetodServ	:= GetNewPar("MV_ENVSINC","N")
	Local cMaxLote		:= GetNewPar("MV_MAXLOTE","1")//Por padrão, o sistema utiliza 1 para MV_MAXLOTE no TSS
	
	Default cUsuario	:= ""
	Default cSenha		:= ""  
	
	Default nGrava		:= 2
	Default cAEDFe		:= ""
	Default cModelo		:= ""
	// Tratamento para Osasco - SP
	Default cChaveAut	:= ""
	
	Private oWsTMP
	
	oWS                       := WsNFSE001():New()
	oWS:cUSERTOKEN            := "TOTVS"
	oWS:cID_ENT               := cIdEnt
	oWS:_URL                  := AllTrim(cURL)+"/NFSE001.apw"
	oWS:cCODMUN               := cCodMun
	oWS:nAmbienteNFSe         := Val(Substr(cAmbienteNFSe,1,1))
	oWS:nModNFSE	            := Val(cModNFSE)
	oWS:cVersaoNFSe           := cVersaoNFSe
	oWS:cCodMun               := cCodMun
	oWS:cCodSIAFI             := cCodSIAFI
	oWS:cUso                  := "NFSE"
	oWS:cMaxLote              := cMaxLote
	If cCodMun $ "3106200-3136702-3205309-4307005" //Tratamento para Belo Horizonte - MG e Juiz de Fora - MG  - Erechim -RS
		oWS:cEnvSinc              := cMetodServ
	Endif
	
	oWsTMP := oWs
	
	If ( cCodMun $ "3503307-3515004-3538709-3300704-1400100-3156700-4303905-4307906-4314407-3302403-2803500-3148103-3146107-4308201-3304508-3541406-2301000-3201308" .Or. cModelo $ "004-011") .And. cVerTSS >= "1.33" // Osasco - Campo Bom-RS - Farroupilha-RS e SIMPLISS
		oWS:cLogin := AllTrim(cUsuario)
		oWS:cPass  := AllTrim(cSenha)
	ElseIf cCodMun == "4205407"    
		oWS:cAutorizacao := Alltrim(cAEDFe)
	//Tratamento para Osasco - SP
	ElseIf cCodMun $ "3534401-"+Fisa022Cod("009")+Fisa022Cod("010")
		oWS:cChaveAutenticacao := Alltrim(cChaveAut)		
	ElseIf cCodMun $ "4113700-3506003-4315602-3304904" 
		oWS:cLogin := AllTrim(cUsuario)
		oWS:cPass  := AllTrim(cSenha)		
		If !cCodMun $ "3506003-3304904"
			oWS:cAutorizacao := Alltrim(cAEDFe)
		EndIf	
	ElseIf cCodMun $ Fisa022Cod("012") .Or. cCodMun $ "3171204"
		oWS:cChaveAutenticacao := Encode64(Alltrim(cChaveAut))
	 	oWS:cLogin := AllTrim(cUsuario)
		oWS:cPass  := AllTrim(cSenha)	
		oWS:cAutorizacao := Alltrim(cAEDFe)		
	Endif

	If cVerTss >= "1.22"
		cCnpJAut := StrTran(cCnpJAut,".","")
		cCnpJAut := StrTran(cCnpJAut,"/","")
		cCnpJAut := StrTran(cCnpJAut,"-","")						
		oWS:nCNPJAut := Val(cCnpJAut)
	EndIf
	
	lOk := oWS:CFGambNFSE001()
	
	If lOk 
		oRetorno := oWS:cCFGambNFSE001RESULT
		Aviso("NFS-e",Capital(oRetorno),{STR0114},3)
    Else
    	cMsg :=(IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)))
		Aviso("NFS-e",cMsg,{STR0114},3)		
    EndIf

	if ( cCodMun $ Fisa022Cod( "101" ) .or. cCodMun $ Fisa022Cod( "102" ) .or. ( cCodMun $ GetMunNFT() .And. cEntSai == "0"  ) ) 
	
		oWs2 := WsSpedCfgNFe():New()
		oWs2:cUSERTOKEN      := "TOTVS"
		oWS2:_URL            := AllTrim(cURL)+"/SPEDCFGNFe.apw"	
		oWS2:lftpEnable      := if(nGrava==2,.F.,.T.)
		
		if !( execWSRet( oWS2 ,"tssCfgFTP" ) )
	    	cMsg := (IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)))
			Aviso("NFS-e",cMsg,{STR0114},3)		
		endif
		
	endif           
       
Return(lRet)

//Funcao para retornar o Codigo SIAFI a partir do Cod IBGE
//Substituir futuramente por consulta na tabela CC2

Function GetMunSiaf(cCodMun)

Local aDados 	:= {}

Local cSiafi 	:= "" 
Local cCodServ	:= ""

DEFAULT cCodMun	:= ""  
              
Do Case
    Case cCodMun =="3509502"    //Campinas - SP
   		cSiafi   := "6291" 
		cCodServ := "001"      		
   	Case cCodMun =="3170206"   //Uberlandia - MG  	
		cSiafi   := "5403" 
		cCodServ := "001"   
   	Case cCodMun =="2927408"   //Salvador - BA
		cSiafi   := "3849"    
		cCodServ := "002"
   	Case cCodMun =="4106902"   //Curitiba  - PR
		cSiafi   := "7535"	
		cCodServ := "002"	
   	Case cCodMun =="3303500"   //Nova Iguaçu  - RJ
		cSiafi   := "5869"	
		cCodServ := "001"	
	Case cCodMun =="3115300"   //Cataguases- MG
		cSiafi   := "4305"
		cCodServ := "002"		                                   
	Case cCodMun =="3304557"   //Rio de Janeiro  - RJ
		cSiafi   := "6001"
		cCodServ := "002"			
	Case cCodMun =="3170107"   //Uberaba- MG
		cSiafi   := "5401"
		cCodServ := "002"					
	Case cCodMun =="2704302"   //MAceio- AL
		cSiafi   := Space(4)
		cCodServ := "002"  
	Case cCodMun =="3547809"   //Sto André  - SP
		cSiafi   := "7057"
		cCodServ := "002"										
	Case cCodMun =="2111300"   //Sâo Luiz - MA
		cSiafi   := "0921"
		cCodServ := "001"
	Case cCodMun =="2611606"   //Recife  - PE
		cSiafi   := "2531"
		cCodServ := "002"              
	Case cCodMun =="3501608"   //Americana-SP
		cSiafi   := "6131"
		cCodServ := "002" 
 	Case cCodMun =="3136207"  // Joao Monlevade - MG
   		cSiafi   := "4723" 
		cCodServ := "002"
	Case cCodMun =="3550308"  // Sao Paulo - Sp
   		cSiafi   := "7107" 
		cCodServ := "002"
	Case cCodMun =="3132404"  // Itajuba - MG
   		cSiafi   := "4647" 
		cCodServ := "102"
	Case cCodMun == "5002704"  // Campo Grande - MS                  
		cSiafi   := "9051" 
		cCodServ := "001"
	Case cCodMun =="3106200"  //Belo Horizonte - MG
		cSiafi   := "4123"
		cCodServ := "002"
	Case cCodMun =="2304400"  // Fortaleza- CE
   		cSiafi   := "1389" 
		cCodServ := "002"  
	Case cCodMun =="3552205"  //Sorocaba - SP
		cSiafi   := "7145"
		cCodServ := "001"
	Case cCodMun =="4209102"  // Joinville / SC
   		cSiafi   := "8179" 
		cCodServ := "102"
	Case cCodMun =="3543402"  //Ribeirão Preto - SP
		cSiafi   := "6969"
		cCodServ := "002"
	Case cCodMun == "3301702" //Duque de Caxias - RJ
		cSiafi   := "5833"
		cCodServ := "002" 
	Case cCodMun == "2604106" // Caruaru - PE
		cSiafi := "2381"
		cCodServ := "002"		     			                  	                   
	Case cCodMun == "3513009" //Cotia - SP
		cSiafi   := "6361"
		cCodServ := "002"		     			    
	Case cCodMun =="2607208"  // Ipojuca - PE
   		cSiafi   := "2443" 
		cCodServ := "102"		                  	                   
	Case cCodMun =="5201108"  // Anapolis - GO
   		cSiafi   := "9221" 
		cCodServ := "002"		             
	Case cCodMun =="3548708"  // Sao Bernardo do Campo - SP
   		cSiafi   := "7075" 
		cCodServ := "002"
	Case cCodMun == "3513801" // Diadema - SP
		cSiafi   := "6377"
		cCodServ := "002"
    Case cCodMun == "3525904" // Jundiai - SP
      	cSiafi   := "6619"
		cCodServ := "002"	 
	Case cCodMun == "4104808" // Cascavel - PR
		cSiafi   := "7493"
		cCodServ := "002"  
	Case cCodMun == "2800308" 	 // Aracaju - SE
		cSiafi	 :=	"3107"
		cCodServ := "002"                                                                                                                                                                                                                                                      		
	Case  cCodMun == "3168705"	  // Timoteo - MG
		cSiafi	 := "5373"
		cCodServ := "101" 
	Case  cCodMun == "4106407"	  // Cornélio Procópio - PR
		cSiafi	 := "7525"
		cCodServ := "002" 		
	Case  cCodMun == "5103403"	  // Cuiabá - MT
		cSiafi	 := "9067"
		cCodServ := "002"	
	Case  cCodMun == "3518701"	  // Guarujá - SP
		cSiafi	 := "6475"
		cCodServ := "002"
	Case  cCodMun == "1302603"	  // Manaus - AM
		cSiafi	 := "0255"
		cCodServ := "002"	
	Case  cCodMun == "3156700"	  // Sabará - MG
		cSiafi	 := "5133"
		cCodServ := "002"
	Case  cCodMun == "4318002"	  // São Borja - RS
		cSiafi	 := "8863"
		cCodServ := "002" 
	Case  cCodMun == "3549904"	  // São José dos Campos - SP
		cSiafi	 := "7099"
		cCodServ := "002"
	Case  cCodMun == "3503307"	  // Araras -SP
		cSiafi	 := "6401"
		cCodServ := "002" 			
	Case  cCodMun == "3515004"	  // Embu das Artes -SP
		cSiafi	 := "6401"
		cCodServ := "002" 			
	Case  cCodMun == "3303302"	  // Niteroi - RJ
		cSiafi	 := "5865"					
	Case  cCodMun == "3549805"    // São José do Rio Preto - SP
		cSiafi   := "7097"  
	Case  cCodMun == "3548500"    // Santos - SP
		cSiafi   := "7071"
	Case  cCodMun == "3300407"    // Barra Mansa - RJ
		cSiafi   := "5807"	
	Case  cCodMun == "3147105"    // Pará de Minas - MG
		cSiafi   := "4941" 		
	Case  cCodMun == "4118204"    // Paranaguá - PR
		cSiafi   := "7745" 
	Case  cCodMun == "3300100"    // Angra dos Reis - RJ
		cSiafi   := "5801"			
	Case  cCodMun == "4318705"	  // Sao Leopoldo - RS
		cSiafi	 := "8877"			
		cCodServ := "002" 
	Case  cCodMun == "4125506"    // São José dos Pinhais - PR
		cSiafi   := "7885"
		cCodServ := "002"  			
	Case  cCodMun == "4108304"    // Foz do Iguaçu-PR
		cSiafi   := "7563"	
		cCodServ := "002"
	Case  cCodMun == "3131307"    // Ipatinga - MG
		cSiafi   := "4625"
		cCodServ := "002"					
	Case  cCodMun == "3538709"    // Piracicaba - SP
		cSiafi   := "6875"
		cCodServ := "002"		
	Case  cCodMun == "3524709"    // Jaguariuna - SP		
		cSiafi   := "6595"
		cCodServ := "002" 
	Case  cCodMun == "3502507"    // Aparecida - SP
		cSiafi   := "6149"
		cCodServ := "002" 
	Case  cCodMun == "3525102"    // Jardinópolis - SP
		cSiafi   := "6603"
		cCodServ := "002" 
	Case  cCodMun == "2910800"	  // Feira de Santana
		cSiafi	 := "3515"		
		cCodServ := "002" 
	Case  cCodMun == "4202305"	  // Biguacu - SC
		cSiafi	 := "8045"
		cCodServ := "002"
	Case  cCodMun == "3300704"	  // Cabo Frio - RJ
		cSiafi	 := "5813"			
		cCodServ := "002"
	Case  cCodMun == "4208203"	  // Itajaí - SC
		cSiafi	 := "8161" 
		cCodServ := "002"
	Case  cCodMun == "3536505"    // Paulínia - SP
		cSiafi   := "6831" 
		cCodServ := "002"
	Case cCodMun == "4119905"	// PR-Ponta Grossa	 			
		cSiaFi	 := "7777"
		cCodServ := "002"
	Case  cCodMun == "3518404"	  // Guaratinguetá - SP
		cSiafi	 := "6469"
		cCodServ := "002"
	Case  cCodMun == "4205407"	  // Florianopolis-SC
		cSiafi	 := "0000"			 			
		cCodServ := "102" 			
	Case  cCodMun == "5208707"	  // Goiania - GO
		cSiafi	 := "9373"
		cCodServ := "002"
	Case  cCodMun == "3529401"	  // Mauá - SP
		cSiafi	 := "6689"
		cCodServ := "002"
	Case  cCodMun == "3305505"	  // Saquarema - RJ
		cSiafi	 := "5909"			 			
		cCodServ := "102"
	Case cCodMun == "3523909"	  // Itu - SP
		cSiafi	 := "6579"
		cCodServ := "002"
	Case cCodMun == "4216602"	  // São José - SC
		cSiafi	 := "8327"
		cCodServ := "002"
	Case cCodMun == "4202404"	  // Blumenau - SC
		cSiafi	 := "8047"
		cCodServ := "002"    
	Case cCodMun == "3205002"	  // SERRA - ES
		cSiafi	 := "5699"
		cCodServ := "004"
	Case cCodMun == "3303401"     // Nova Friburgo - RJ
		cSiafi	 := "5867"
		cCodServ := "002"
	Case cCodMun == "1400100"	 // Boa Vista - RR
		cSiafi	 := "0301"
		cCodServ := "002"
	Case cCodMun == "3534401"	 // Osasco - SP
		cSiafi	 := "6789"
		cCodServ := "003"
	Case cCodMun == "4204608"    // Criciúma - SC
		cSiafi	 := "8089"
		cCodServ := "002"
	Case cCodMun == "4203006"	 // Caçador - SC
		cSiafi	 := "8057"
		cCodServ := "002" 
	Case cCodMun == "2802106"    // Estância - SE
		cSiafi   := "3141"
		cCodServ := "002"
	Case  cCodMun == "3143906"	  // Muriaé - MG
		cSiafi	 := "4877"
		cCodServ := "002"
	Case  cCodMun == "2307650"	  // Maracanaú - CE
		cSiafi	 := "1585"
		cCodServ := "002"
	Case cCodMun =="3136702"     // Juiz de Fora - MG
		cSiafi   := "4733"
		cCodServ := "002"
	Case cCodMun == "4113700"	 // Londrina - PR
		cSiafi	 := "7667"
		cCodServ := "006"
	Case  cCodMun == "4313409"    // Novo Hamburgo
		cCodServ := "002" 
		cSiafi   := "8771"
	Case  cCodMun == "4127700"    // TOLEDO - PR
		cCodServ := "007" 
		cSiafi   := "5381"
	Case  cCodMun == "4111506"    // Ivaiporã - PR
		cCodServ := "101" 
		cSiafi   := "7623"
	Case  cCodMun == "4111803"    // Jacarezinho - PR
		cCodServ := "101" 
		cSiafi   := "7629"                           
	Case  cCodMun == "4108403"    // Francisco Beltrão
		cCodServ := "007" 
		cSiafi   := "7565" 
	Case cCodMun == "3152501"  	 // Pouso Alegre - MG
   		cSiafi   := "5049" 
		cCodServ := "102"
	Case  cCodMun == "3201209"    // Cachoeiro de Itapemirim - ES
		cSiafi   := "5623" 
		cCodServ := "002"
	Case cCodMun == "3513504"	  // Cubatão - SP
		cSiafi	 := "6371"
		cCodServ := "004"
	Case cCodMun == "4101507"	  // Arapongas - PR
		cSiafi	 := "7427"
		cCodServ := "002"		
	Case cCodMun == "4303905"	// Campo Bom - RS
		cSiafi	 := "8577"
		cCodServ := "008"  
	Case cCodMun == "4307906"	// Farroupilha - RS
		cSiafi	 := "8655"
		cCodServ := "008"	
	Case cCodMun == "4201307"	  // Araquari - SC
		cSiafi  := "8025"
		cCodServ := "002"
	Case cCodMun == "4314407"	// Pelotas - RS
		cSiafi := "8791"
		cCodServ := "002"				
	Case cCodMun == "3546801"	// Santa Isabel - SP
		cSiafi := "7037"
		cCodServ := "009"	
	Case cCodMun == "3302403"	// Macaé - RJ
		cSiafi := "5847"
		cCodServ := "002"
	Case cCodMun == "2803500"	// Lagarto - SE
		cSiafi := "3169"
		cCodServ := "002"
	Case cCodMun == "3205309"	// Vitória - ES
		cSiafi := "5705"
	Case cCodMun == "4115200"	// Maringá-PR
		cSiafi := "7691" 	
	Case cCodMun =="2507507" 	//Joao Pessoa-PB
		cSiafi   := "2051"	
	Case  cCodMun == "3106705"    // Betim - MG	
		cSiafi	 := "4133"	
	Case cCodMun == "3162104"	//São Gotardo
		cSiafi	:= "5241"
	Case  cCodMun == "3506003"    // Bauru - SP	
		cSiafi	 := "6219"
	Case  cCodMun == "3127107"    // Frutal - MG	
		cSiafi	 := "4541"	
	Case  cCodMun == "3148004"    // Patos de Minas - MG	
		cSiafi	 := "4133"	
	Case  cCodMun == "3545209"    // Salto - SP
		cSiafi	 := "7005"		
	Case cCodMun == "5218508"    // Quirinópolis - GO
		cSiafi	 := "9563"
		cCodServ := "002"	
	Case cCodMun == "4215802"    // São Bento do Sul - SC
		cSiafi	 := "8311"
		cCodServ := "002"
	Case cCodMun == "3510500"    // Caraguatatuba - SP
		cSiafi	 := "6311"
		cCodServ := "102"	
	Case cCodMun == "3143302"	  // Montes Claros - MG
		cSiafi	 := "1846"
		cCodServ := "002"		
	Case cCodMun == "4303103"	  // Cachoeirinha - RS
		cSiafi	 := "8561"
		cCodServ := "002"
	Case  cCodMun == "5209101"    // Goiatuba - GO
		cSiafi	 := "9379"
		cCodServ := "101" 
	Case cCodMun == "4208450"	  // Itapoá - SC
		cSiafi	 := "9985"
		cCodServ := "011"
	Case  cCodMun == "3148103"    // Patrocínio - MG
		cSiafi   := "4961"
		cCodServ := "002"
	Case  cCodMun == "3146107"    // Patrocínio - MG
		cSiafi   := "4921"
		cCodServ := "002"
	Case  cCodMun == "4308201"    // Flores da Cunha - RS
		cSiafi   := "8661"
		cCodServ := "002"
	Case  cCodMun == "4311403"	  // Lajeado - RS
		cSiafi	 := "8729"			
		cCodServ := "002" 
	Case  cCodMun == "3304508"	  // Rio das Flores - RJ
		cSiafi	 := "5889"
		cCodServ := "002" 
	Case  cCodMun == "3158953"    // Santana do Paraiso - MG
		cSiafi	 := "2673"
		cCodServ := "102"
	Case  cCodMun == "3541406"    // Presidente Prudente - SP
		cSiafi   := "6929"
		cCodServ := "002"	
	Case cCodMun == "4304606"    // Canoas - RS
		cSiafi   := "8589"
		cCodServ := "002"
	Case cCodMun == "3171204"    // Vespasiano - MG
		cSiafi   := "5425"
		cCodServ := "002"
	Case cCodMun == "2301000"    // Aquiraz - CE
		cSiafi   := "1319"
		cCodServ := "002"
	Case cCodMun == "4207304"	 // Imbituba - SC
		cSiafi	 := "8143"
		cCodServ := "002" 
	Case  cCodMun == "3507605"    // Bragança Paulista - SP
		cSiafi	 := "6251"
		cCodServ := "102"
	Case  cCodMun == "4211306"    // Navegantes - SC
		cSiafi	 := "8221"
		cCodServ := "002"
	Case  cCodMun == "3552502"    // Suzano - SP
		cSiafi	 := "7151"
		cCodServ := "002"
	Case cCodMun == "4315602"    // Rio Grande - RS
		cSiafi   := "8815"
	Case cCodMun == "4315602"    // Porto Velho - RO
		cSiafi   := "0003"
		cCodServ := "002"
	Case cCodMun == "4307005"    // Erechim - RS
		cSiafi   := "8637"
		cCodServ := "002"		
	Case cCodMun == "4309209"	  // Gravatai - RS
		cSiafi	 := "9985"
		cCodServ := "011"
	Case cCodMun == "4216206"	  // São Francisco do Sul - SC
		cSiafi	 := "8319"
		cCodServ := "011"
	Case cCodMun	== "3524006"	 // Itupeva - SP
		cSiafi		:= "6581"
		cCodServ	:= "012"
	Case cCodMun == "3302007"	// Itaguaí - RJ
		cSiafi := "5847"
		cCodServ := "002"
	Case cCodMun == "3508504"	  // Caçapava - SP
		cSiafi	 := "6271"
		cCodServ := "101"
	Case cCodMun == "3201308"		// Cariacica - ES
		cSiafi	 := "5625"
		cCodServ := "004"
	Case cCodMun == "4307708"	  // Esteio - RS
		cSiafi	 := "8561"
		cCodServ := "002"
	Case cCodMun == "4308508"	// Frederico Westphalen - RS
		cSiafi	 := "8667"
		cCodServ := "002"
	Case  cCodMun == "3304904"    // Sao Goncalo - RJ	
		cSiafi	 := "5897"
	Case  cCodMun == "1200401"    // Rio Branco - AC
		cSiafi   := "5623" 
		cCodServ := "002"
	Case cCodMun == "3200607"		// Aracruz - ES
		cSiafi	 := "5611"
		cCodServ := "002"
	Case  cCodMun == "3550704"    // São Sebastião - SP
		cSiafi	 := "7151"
		cCodServ := "002"	
	Case  cCodMun == "3301900"    // Itaboraí - RJ
		cSiafi	 := "5837"
		cCodServ := "002"
	Case cCodMun == "4107652"		// Fazenda Rio Grande - PR
		cSiafi	 := "9983"
		cCodServ := "002"		
	Case cCodMun == "3104007"	// Araxá - MG
		cSiafi   := "4079"
		cCodServ := "002"
	OtherWise 
		cSiafi := Space(4)
		cCodServ := Space(3)
		
EndCase  
aadd(aDados,{cSiafi,cCodServ})

Return(aDados)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    |DetSchema ³ Autor ³ Roberto Souza         ³ Data ³11/05/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Exibe detalhe de schema.                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function DetSchema(cIdEnt,cCodMun,cIdNFe,nTipo)

Local cURL     := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local oWS
Local cMsg     := ""
DEFAULT nTipo  := 1

	oWS := WsNFSE001():New()
	oWS:cUSERTOKEN            := "TOTVS"
	oWS:cID_ENT               := cIdEnt
	oWS:cCodMun               := cCodMun
	oWS:_URL                  := AllTrim(cURL)+"/NFSE001.apw"
	oWS:nDIASPARAEXCLUSAO     := 0
    oWS:OWSNFSEID:OWSNOTAS    := NFSe001_ARRAYOFNFSESID1():New()
      
		aadd(oWS:OWSNFSEID:OWSNOTAS:OWSNFSESID1,NFSE001_NFSES1():New())
		oWS:OWSNFSEID:OWSNOTAS:OWSNFSESID1[1]:CCODMUN  := cCodMun
		oWS:OWSNFSEID:OWSNOTAS:OWSNFSESID1[1]:cID      := cIdNFe
		oWS:OWSNFSEID:OWSNOTAS:OWSNFSESID1[1]:cXML     := " "
		oWS:OWSNFSEID:OWSNOTAS:OWSNFSESID1[1]:CNFSECANCELADA := " "               

If ExecWSRet(oWS,"RETORNANFSE")

	If Len(oWs:oWsRetornaNfseResult:OWSNOTAS:OWSNFSES5) > 0
		If nTipo == 1
			Do Case
				Case oWs:oWsRetornaNfseResult:OWSNOTAS:OWSNFSES5[1]:oWSNFECANCELADA <> Nil
					Aviso("NFSE",oWs:oWsRetornaNfseResult:OWSNOTAS:OWSNFSES5[1]:oWSNFECANCELADA:cXML,{STR0114},3)
				OtherWise
					Aviso("NFSE",oWs:oWsRetornaNfseResult:OWSNOTAS:OWSNFSES5[1]:oWSNFE:cXMLERP,{STR0114},3)	
			EndCase
		Else
			cMsg := AllTrim(oWs:oWsRetornaNfseResult:OWSNOTAS:OWSNFSES5[1]:oWSNFE:cXMLERP)
			If !Empty(cMsg)
				Aviso("NFSE",@cMsg,{STR0114},3,/*cCaption2*/,/*nRotAutDefault*/,/*cBitmap*/,.T.)		
				oWS := WsNFSE001():New()
				oWS:cUSERTOKEN     := "TOTVS"
				oWS:cID_ENT        := cIdEnt
				oWS:cCodMun        := cCodMun

				oWs:oWsNF:oWSNOTAS:=  NFSE001_ARRAYOFNF001():New()
				aadd(oWs:oWsNF:oWSNOTAS:OWSNF001,NFSE001_NF001():New())

				oWs:oWsNF:oWSNOTAS:oWSNF001[1]:CID := cIdNfe
				oWs:oWsNF:oWSNOTAS:oWSNF001[1]:Cxml:= EncodeUtf8(cMsg)
				oWS:_URL                             := AllTrim(cURL)+"/NFSE001.apw"
				If ExecWSRet(oWS,"SchemaX")
					If Empty(oWS:OWSSCHEMAXRESULT:OWSNFSES4[1]:cMENSAGEM)
						Aviso("NFSE",STR0091,{STR0114})
					Else
						Aviso("NFSE",IIF(Empty(oWS:OWSSCHEMAXRESULT:OWSNFSES4[1]:cMENSAGEM),STR0091,oWS:OWSSCHEMAXRESULT:OWSNFSES4[1]:cMENSAGEM),{STR0114},3)
					EndIf
				Else
					Aviso("NFSE",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{STR0114},3)
				EndIf
			EndIf
		EndIf
	EndIf
Else
	Aviso("NFSE",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{STR0114},3)
EndIf


Return
  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FISA022   ºAutor  ³Microsiga           º Data ³  05/14/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */

Function Fisa022Canc(lAuto,cNotasOk)

Local aArea     	:= GetArea()
Local aPerg     	:= {}
Local aParam		:= {Space(Len(SF2->F2_SERIE)),Space(Len(SF2->F2_DOC)),Space(Len(SF2->F2_DOC)),"",1}

Local cAlias    	:= "SF2"
Local cCodMun  	 	:= SM0->M0_CODMUN
Local cParTrans		:= SM0->M0_CODIGO+SM0->M0_CODFIL+"Fisa022Canc"
Local cParNfseRem  	:= SM0->M0_CODIGO+SM0->M0_CODFIL+"AUTONFSEREM"
Local cForca   		:= ""            
Local cDEST			:= Space(10)
Local cWhen 		:= ".T."
Local cMensRet		:= ""   

//Local cNotasOk 	:= ""  

Local lProcessa		:= .T. 
Local lObrig		:= .T.

Local nForca   		:= 1   

Default lAuto		:= .F.
Default cNotasOk	:= ""

//Geracao XML Arquivo Fisico
If ( cCodMun $ Fisa022Cod("101") .or. cCodMun $ Fisa022Cod("102")  .Or. ( cCodMun $ GetMunNFT() .And. cEntSai == "0"  )  )       

	MV_PAR01 := ""
	MV_PAR02 := ""
	MV_PAR03 := ""
	MV_PAR04 := ""
	MV_PAR05 := ""

	If !lAuto
		MV_PAR01:=cSerie   	:= aParam[01] := PadR(ParamLoad(cParTrans,aPerg,1,aParam[01]),Len(SF2->F2_SERIE))
		MV_PAR02:=cNotaini 	:= aParam[02] := PadR(ParamLoad(cParTrans,aPerg,2,aParam[02]),Len(SF2->F2_DOC))
		MV_PAR03:=cNotaFin 	:= aParam[03] := PadR(ParamLoad(cParTrans,aPerg,3,aParam[03]),Len(SF2->F2_DOC))
	Else
		MV_PAR01 := aParam[01] := PadR(ParamLoad(cParNfseRem,aPerg,1,aParam[01]),Len(SF2->F2_SERIE))
		MV_PAR02 := aParam[02] := PadR(ParamLoad(cParNfseRem,aPerg,2,aParam[02]),Len(SF2->F2_DOC))
		MV_PAR03 := aParam[03] := PadR(ParamLoad(cParNfseRem,aPerg,3,aParam[03]),Len(SF2->F2_DOC))
	EndIf		

	//Montagem das perguntas
	aadd(aPerg,{1,STR0010,aParam[01],"",".T.","",".T.",30,.F.})			//"Serie da Nota Fiscal"
	aadd(aPerg,{1,STR0011,aParam[02],"",".T.","",".T.",30,.T.})			//"Nota fiscal inicial"
	aadd(aPerg,{1,STR0012,aParam[03],"",".T.","",".T.",30,.T.}) 			//"Nota fiscal final" 
	If !cCodMun $ "3201308-4205407"
		aadd(aPerg,{1,"Nome arquivo",aParam[04],"",".T.","",cWhen,40,lObrig})	//"Nome do arquivo XML Gerado"	
	EndIf   
   


	If ( cCodMun == "3168705" )
	    cWhen 	:= ".F."
	    MV_PAR04:= cDEST := aParam[04] := ""
	    lObrig	:= .F.
	ElseIf !cCodMun $  "3201308"
		if !cCodMun $  "4205407"
	    	MV_PAR04:= cDEST := aParam[04] := PadR(ParamLoad(cParTrans,aPerg,4,aParam[04]),10)
	    else
	    	MV_PAR04:= cDEST   := aParam[04] := PadR(ParamLoad(cParTrans,aPerg,4,aParam[04]),10) 
			MV_PAR05:= nForca := aParam[05] := PadR(ParamLoad(cParTrans,aPerg,5,aParam[05]),1) 
			aadd(aPerg,{1,"Nome arquivo",aParam[04],"",".T.","",cWhen,40,lObrig})					//"Nome do arquivo XML Gerado"
			aadd(aPerg,{2,"Força Transmissão",aParam[05],{"1-Sim","2-Não"},40,"",.T.,""})  	   		//"Força Transmissão"
	    endif
	EndIf

	oWs := WsSpedCfgNFe():New()
	oWs:cUSERTOKEN      := "TOTVS"
	oWS:_URL            := AllTrim(cURL)+"/SPEDCFGNFe.apw"	 
	oWS:lftpEnable      := nil
	
	if ( execWSRet( oWS ,"tssCfgFTP" ) )
	
		if ( oWS:lTSSCFGFTPRESULT )
//			aadd(aPerg,{6,"Caminho do arquivo","","","",040,.T.,"","",""})   
			aAdd(aPerg,{6,"Caminho do arquivo",padr('',100),"",,"",90 ,.T.,"",'',GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY})
		endif
		
	endif		

	//Verifica se o serviço foi configurado - Somente o Adm pode configurar
	if !lAuto
		If !ParamBox(aPerg,"Transmissão NFS-e",,,,,,,,cParTrans,.T.,.T.)    
			
			lProcessa := .F.
	
		EndIf
	endif
	
EndIf	

If ( lProcessa )
	Processa( {|| FisaCanc(cCodMun,cAlias,@cNotasOk,MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04,lAuto,MV_PAR06 )}, "Aguarde...","(1/2) Verificando dados...", .T. )
EndIf

If Empty(cNotasOk)	
	Aviso("NFS-e","Nenhuma Nota foi Cancelada.",{STR0114},3)
Else
	Aviso("NFS-e","Notas Canceladas:" +CRLF+ cNotasOk,{STR0114},3)
EndIf
If !lAuto
Eval(bFiltraBrw2)
RestArea(aArea)  
EndIF
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FISA022   ºAutor  ³Microsiga           º Data ³  05/17/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function Fis022MntC(lAuto)
Local aPerg     := {}
Local cCodMun     := SM0->M0_CODMUN
Local cParMnt    := SM0->M0_CODIGO+SM0->M0_CODFIL+"Fis022MntC"
Local aParam    := {ctod("//"),ctod("//"),.F.}

aadd(aPerg,{1,STR0148,aParam[01],"99/99/99",".T.","",".T.",50,.T.}) //"DATA INICIAL"
aadd(aPerg,{1,STR0149,aParam[02],"99/99/99",".T.","",".T.",50,.T.}) //"DATA FINAL"
aadd(aPerg,{4,"Trazer Notas Não Autorizadas",.F.,"",50,".T.",.F.}) 	//"Notas Fiscais que não foram visualizadas no Monitor"

aParam[01] := ParamLoad(cParMnt,aPerg,1,aParam[01])
aParam[02] := ParamLoad(cParMnt,aPerg,2,aParam[02])
aParam[03] := ParamLoad(cParMnt,aPerg,3,aParam[03])

If ParamBox(aPerg," Cancelamento NFS-e",@aParam,,,,,,,cParMnt,.T.,.T.) 
	Processa({ || Fis022MtC() },"Espere...","Processando Dados...")
EndIf  

Return()  
                                                                                                                                 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FISA022   ºAutor  ³Microsiga           º Data ³  05/18/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Fis022MtC()

Local cCadastro 	:= ""
Local cQuery 		:= ""
Local dDatIni  	:= Iif(Valtype(MV_PAR01) =="C",ctod(MV_PAR01),Dtos(MV_PAR01))
Local dDatFim  	:= Iif(Valtype(MV_PAR02) =="C",ctod(MV_PAR02),Dtos(MV_PAR02))

Local lSemAut  	:= MV_PAR03
Local aIndexSF3	:= {} 

Local cFiltro	 	:= ""

Private bFiltraBrw2 := {|| Nil }

Private cMarca 
Private aRotina := {}

If lSemAut
	cQuery := ".And. ( SUBSTR(F3_CODRSEF,1,1) == 'S' .OR. SUBSTR(F3_CODRSEF,1,1) == 'T' ) "
Else
	cQuery := ".And. SUBSTR(F3_CODRSEF,1,1) == 'S' "
EndIf	

If SF3->(FieldPos("F3_CODRET")) > 0
	cQuery += ".AND. F3_CODRET <> '333' " 
	cQuery += ".AND. F3_CODRET <> '222' "
EndIf
	
If Valtype(MV_PAR01) =="C"
	cFiltro := "F3_FILIAL== xFilial('SF3') .AND. F3_DTCANC >= ctod(MV_PAR01) .AND. F3_DTCANC <= ctod(MV_PAR02) " + cQuery 
Else
	cFiltro := "F3_FILIAL== xFilial('SF3') .AND. F3_DTCANC >= MV_PAR01 .AND. F3_DTCANC <= MV_PAR02 " + cQuery 
EndIf
aRotina   := {{STR0004,"AxPesqui"    ,0,1,0,.F.},; //"Pesquisar"
			  {STR0146,"Fisa022Can()"    ,0,2,0 ,NIL}} //"Trans. Canc."     --Fisa022Can
					
If !Empty(cFiltro)
	bFiltraBrw2 := {||FilBrowse("SF3",@aIndexSF3,@cFiltro)}
	Eval(bFiltraBrw2)                                                                                		
EndIf

SF3->(DBSelectArea("SF3"))
cMarca	 := GetMark()
cCadastro := 'Notas Fiscais Canceladas'
MarkBrowse('SF3', 'F3_OK',,,, cMarca,'MarcaT()',,,,'Marca1()',,,,)                

If ( Len(aIndexSF3)>0 )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Finaliza o uso da funcao FilBrowse e retorna os indices padroes.       ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   EndFilBrw("SF3",aIndexSF3)
EndIf  

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FISA022   ºAutor  ³Microsiga           º Data ³  05/17/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/    

Function MarcaT()

Local nRecno := SF3->(Recno())

SF3->(DBSelectArea("SF3"))
SF3->(DBGotop())

While !SF3->(EOF())
If SF3->(FieldPos("F3_OK")) > 0
	If (Empty(SF3->F3_OK) .or. SF3->F3_OK <> cMarca)
		Reclock("SF3",.F.)
		SF3->F3_OK := cMarca
		MsUnlock()
	else
		Reclock("SF3",.F.)
		SF3->F3_OK := "  "
		MsUnlock()
	EndIf                 
EndIf
	SF3->(DbSkip())
EndDo
SF3->(DBGoto(nRecno))    

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FISA022   ºAutor  ³Microsiga           º Data ³  05/17/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Function Marca1()

SF3->(DBSelectArea("SF3"))
If SF3->(FieldPos("F3_OK")) > 0
	If (Empty(SF3->F3_OK) .or. SF3->F3_OK <> cMarca)
		Reclock("SF3",.F.)
		SF3->F3_OK  := cMarca
		MsUnlock()
	else
		Reclock("SF3",.F.)
		SF3->F3_OK  := "  "
		MsUnlock()
	EndIf                                            
EndIf  

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FISA022   ºAutor  ³Microsiga           º Data ³  05/17/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function FisaCanc(cCodMun,cAlias,cNotasOk,cSerie,cNotaIni,cNotaFim,cDest,lAuto,cGravaDest)
 
	local aArea     	:= GetArea() 
	local aRemessa 	:= {}
	local cAliasSF3 	:= "SF3"
	local cRetorno   	:= ""      
	local cMotCancela	:= "cancelamento automatico"  
	local cXjust		:= ""
	local cCodCanc		:= ""
	local cRdMakeNFSe	:= ""
	local cSerieIni	:= cSerie
	local cSerieFim	:= cSerie
	local cGravaDest	:= cGravaDest
		   
	local lXjust    	:= GetNewPar("MV_INFXJUS","") == "S"
	local lHabCanc		:= GetNewPar("MV_CODCANC",.F.) //Habilita a tela de seleção dos códigos de cancelamento (#Piloto Itajaí - SC)
	local lOk			:= .T.
	local lReproc		:= .F.	
	local lCanc		:= .T.
	local lMontaXML	:= .F.
	
	local nCount		:= 0
		
	default cSerie		:= ""
	default cNotaIni	:= ""
	default cNotaFim	:= ""
	default cDest		:= ""
 		
	Procregua((cAliasSF3)->(reccount()))

	cCondQry:="%"
		
	If cEntSai == "1"
		
		cCondQry +="F3_CFO >= '5' "	
	
	ElseIF cEntSai == "0"	
	
		cCondQry +="F3_CFO < '5' "
	
	EndiF	
	
	If ( ( !Empty(cSerie) .And. !Empty(cNotaIni) .And. !Empty(cNotaFim) .And. ( cCodMun $ Fisa022Cod("101") .or. cCodMun $ Fisa022Cod("102") ) .Or. ( cCodMun $ GetMunNFT() .And. cEntSai == "0"  )  .or. lAuto ) )   

		cCondQry += " AND SF3.F3_SERIE		=  '" + cSerie		+ "'" 
		cCondQry += " AND SF3.F3_NFISCAL	>= '" + cNotaIni	+ "'"	
		cCondQry += " AND SF3.F3_NFISCAL	<= '" + cNotaFim	+ "'"

	else	
	
		If lHabCanc //Codigo de Cancelamento apenas para Itajaí
	
			cCodCanc:= GetCodCanc(@lOk) 		
	
		EndIf
		
		if lOk
			
			If (cAliasSF3)->(FieldPos("F3_OK")) > 0
			
				cCondQry += " AND SF3.F3_OK = '" + cMarca + "'"
			
			else
			
				lOk := .F.			
			
			endif
		
		endif
	
	endif	
	
	cCondQry +="%"
	
	cRdMakeNFSe		:= getRDMakeNFSe(cCodMun,cEntSai)
	lMontaXML		:= lMontaXML(cIdEnt,cCodMun,cEntSai)
	
	if lOk
	
		cAliasSF3 := GetNextAlias()
	
		BeginSql Alias cAliasSF3
				
		COLUMN F3_ENTRADA AS DATE
		COLUMN F3_DTCANC AS DATE
						
		SELECT	F3_FILIAL,F3_ENTRADA,F3_NFELETR,F3_CFO,F3_FORMUL,F3_NFISCAL,F3_SERIE,F3_CLIEFOR,F3_LOJA,F3_ESPECIE,F3_DTCANC
				FROM %Table:SF3% SF3
				WHERE
				SF3.F3_FILIAL = %xFilial:SF3% AND 
				SF3.F3_DTCANC <> %Exp:Space(8)% 
				AND %Exp:cCondQry% AND 				
				SF3.%notdel%
		EndSql     
								
		
		cTotal := cValToChar((cAliasSF3)->(reccount()))
		
		While !(cAliasSF3)->(EOF()) .and. lOk
			
			nCount++
			
			IncProc("("+cValToChar(nCount)+"/"+cTotal+") "+STR0022+(cAliasSF3)->F3_NFISCAL) //"Preparando nota: "
				
			If lXjust
			
				Aviso("Motivo de cancelamento para a nota "+(cAliasSF3)->F3_SERIE+"-"+(cAliasSF3)->F3_NFISCAL,@cXjust,{"Confirmar","Cancelar"},3,,,,.T.)
				
				If ( !Empty(cXjust) )
					
					cMotCancela := cXjust
			
				EndIf
						
			EndIf
			
			aadd(aRemessa, montaRemessaNFSE(cAliasSF3,cRdMakeNFSe,lCanc,cMotCancela,cIdent,lMontaXML))
				
			(cAliasSF3)->(DbSkip())	
	
		EndDo	
				 
		lOk := envRemessaNFSe(cIdEnt,cUrl,aRemessa,lReproc,cEntSai,@cNotasOk,lcanc,cCodCanc, cCodMun) 
	    
		If lOk 	
			
			If ( (cCodMun $ Fisa022Cod("101") .And. !cCodMun $ "3201308") .or. cCodMun $ Fisa022Cod("102") .Or. ( cCodMun $ GetMunNFT() .And. cEntSai == "0"  ))
				
				cNotasOk := ""
				
				//gera arquivo txt para os modelos 101,102 ou NFTS(São Paulo)
				geraArqNFSe(cIdEnt,cCodMun,cSerie,cNotaini,cNotaFim,cDEST,,cSerieIni,cSerieFim,,,aRemessa,@cNotasOk,,cGravaDest)
		
			EndIf
	
	    Else
	    	
	    	cMsg :=(IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)))
	    	
	    EndIf 
	    
		(cAliasSF3)->(dbCloseArea())
		
		SF3->(DbCloseArea())
		
		RestArea(aArea)   
	
	endif

Return(cRetorno)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    |RetMunCanc³ Autor ³ Roberto Souza         ³ Data ³21/10/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Retorna os municipios que utilizam cancelamento por WS.     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RetMunCanc()
Local cRetMunCanc := ""
Local cPipe        := "-"


cRetMunCanc += "1302603" + cPipe  // AM-Manaus
cRetMunCanc += "1400100" + cPipe  // RR-Boa Vista
cRetMunCanc += "2111300" + cPipe  // MA-São Luiz
cRetMunCanc += "2304400" + cPipe  // CE-Fortaleza
cRetMunCanc += "2307650" + cPipe  // CE-Maracanaú
cRetMunCanc += "2507507" + cPipe  // PB-Joao Pessoa
cRetMunCanc += "2610707" + cPipe  // PE-PAULISTA	
cRetMunCanc += "2611606" + cPipe  // PE-Recife
cRetMunCanc += "2704302" + cPipe  // AL-Maceio
cRetMunCanc += "2800308" + cPipe  // SE-Aracaju
cRetMunCanc += "2802106" + cPipe  // SE-Estância
cRetMunCanc += "2910800" + cPipe  // BA-Feira de Santana
cRetMunCanc += "2927408" + cPipe  // BA-Salvador
cRetMunCanc += "4299599" + cPipe  // BA-Teixera de Freitas  já estava com este codigo
cRetMunCanc += "3106200" + cPipe  // MG-Belo Horizonte
cRetMunCanc += "3106705" + cPipe  // MG-Betim
cRetMunCanc += "3115300" + cPipe  // MG-Cataguases
cRetMunCanc += "3118601" + cPipe  // MG-Contagem
cRetMunCanc += "3136207" + cPipe  // MG-João Monlevade
cRetMunCanc += "3136702" + cPipe  // MG-Juiz de Fora
cRetMunCanc += "3143906" + cPipe  // MG-Muriaé
cRetMunCanc += "3147105" + cPipe  // MG-Pará de Minas
cRetMunCanc += "3156700" + cPipe  // MG-Sabará
cRetMunCanc += "3168705" + cPipe  // MG-Timoteo	
cRetMunCanc += "3170107" + cPipe  // MG-Uberaba
cRetMunCanc += "3170206" + cPipe  // MG-Uberlandia
cRetMunCanc += "3201209" + cPipe  // ES-Cachoeiro de Itapemirim
cRetMunCanc += "3201308" + cPipe  // ES-Cariacica
cRetMunCanc += "3300100" + cPipe  // RJ-Angra dos Reis
cRetMunCanc += "3300407" + cPipe  // RJ-Barra Mansa
cRetMunCanc += "3300704" + cPipe  // RJ-Cabo Frio
cRetMunCanc += "3301702" + cPipe  // RJ-Duque de Caxias
cRetMunCanc += "3303302" + cPipe  // RJ-Niteroi
cRetMunCanc += "3303401" + cPipe  // RJ-Nova Friburgo
cRetMunCanc += "3303500" + cPipe  // RJ-Nova Iguaçu
cRetMunCanc += "3304557" + cPipe  // RJ-Rio de Janeiro
cRetMunCanc += "3304904" + cPipe  // RJ-São Gonçalo		
cRetMunCanc += "3501608" + cPipe  // SP-Americana
cRetMunCanc += "3503307" + cPipe  // SP-Araras
cRetMunCanc += "3505708" + cPipe  // SP-Barueri
cRetMunCanc += "3509502" + cPipe  // SP-Campinas
cRetMunCanc += "3513009" + cPipe  // SP-Cotia
cRetMunCanc += "3513801" + cPipe  // SP-Diadema
cRetMunCanc += "3515004" + cPipe  // SP-Embu das Artes
cRetMunCanc += "3518404" + cPipe  // SP-Guaratinguetá
cRetMunCanc += "3518701" + cPipe  // SP-Guaruja
cRetMunCanc += "3518800" + cPipe  // SP-Guarulhos
cRetMunCanc += "3519071" + cPipe  // SP-Hortolândia
cRetMunCanc += "3523404" + cPipe  // SP-Itatiba
cRetMunCanc += "3523909" + cPipe  // SP-Itu
cRetMunCanc += "3524709" + cPipe  // SP-Jaguariuna
cRetMunCanc += "3502507" + cPipe  // SP-Aparecida
cRetMunCanc += "3525102" + cPipe  // SP-Jardinópolis
cRetMunCanc += "3525904" + cPipe  // SP-Jundiai
cRetMunCanc += "3529401" + cPipe  // SP-Mauá
cRetMunCanc += "3534401" + cPipe  // SP-Osasco
cRetMunCanc += "3536505" + cPipe  // SP-Paulínia
cRetMunCanc += "3538709" + cPipe  // SP-Piracicaba
cRetMunCanc += "3541406" + cPipe  // SP-Presidente Prudente
cRetMunCanc += "3547809" + cPipe  // SP-Sto André
cRetMunCanc += "3548500" + cPipe  // SP-Santos
cRetMunCanc += "3548708" + cPipe  // SP-Sao Bernardo do Campo
cRetMunCanc += "3549904" + cPipe  // SP-São José dos Campos
cRetMunCanc += "3549805" + cPipe  // SP-São José do Rio Preto
cRetMunCanc += "3550308" + cPipe  // SP-Sao Paulo
cRetMunCanc += "3552205" + cPipe  // SP-Sorocaba
cRetMunCanc += "3543402" + cPipe  // SP-Ribeirão Preto
cRetMunCanc += "3554102" + cPipe  // SP-Taubaté
cRetMunCanc += "4101507" + cPipe  // PR-Arapongas
cRetMunCanc += "4104808" + cPipe  // PR-Cascavel
cRetMunCanc += "4106407" + cPipe  // PR-Cornélio Procópio
cRetMunCanc += "4106902" + cPipe  // PR-Curitiba
cRetMunCanc += "4108304" + cPipe  // PR-Foz do Iguaçu
cRetMunCanc += "4108403" + cPipe  // PR-Francisco Beltrão
cRetMunCanc += "4118204" + cPipe  // PR-Paranaguá
cRetMunCanc += "4119905" + cPipe  // PR-Ponta Grossa
cRetMunCanc += "4125506" + cPipe  // PR-São José dos Pinhais
cRetMunCanc += "4127700" + cPipe  // PR-Toledo
cRetMunCanc += "4201307" + cPipe  // SC-Araquari
cRetMunCanc += "4202305" + cPipe  // SC-Biguacu
cRetMunCanc += "4202404" + cPipe  // SC-Blumenau
cRetMunCanc += "4203006" + cPipe  // SC-Caçador
cRetMunCanc += "4204608" + cPipe  // SC-Criciúma
cRetMunCanc += "4208203" + cPipe  // SC-Itajaí
cRetMunCanc += "4216602" + cPipe  // SC-São José	 
cRetMunCanc += "4313409" + cPipe  // RS-Novo Hamburgo
cRetMunCanc += "4318002" + cPipe  // RS-São Borja
cRetMunCanc += "4318705" + cPipe  // RS-Sao Leopoldo
cRetMunCanc += "4314407" + cPipe  // RS-Pelotas
cRetMunCanc += "5002704" + cPipe  // MS-Campo Grande
cRetMunCanc += "5103403" + cPipe  // MT-Cuiabá
cRetMunCanc += "5201108" + cPipe  // GO-Anapolis
cRetMunCanc += "3302403" + cPipe  // RJ-Macaé
cRetMunCanc += "2803500" + cPipe  // SE-Lagarto
cRetMunCanc += "3205309" + cPipe  // ES-Vitoria
cRetMunCanc += "4115200" + cPipe  // PR-Maringá
cRetMunCanc += "3162104" + cPipe  // MG-São Gotardo
cRetMunCanc += "3127107" + cPipe  // MG-Frutal
cRetMunCanc += "3148004" + cPipe  // MG-Patos de Minas
cRetMunCanc += "3143302" + cPipe  // MG-Montes Claros
cRetMunCanc += "3545209" + cPipe  // SP-Salto
cRetMunCanc += "5218508" + cPipe  // GO-Quirinópolis
cRetMunCanc += "3134202" + cPipe  // MG-Ituiutaba
cRetMunCanc += "3548807" + cPipe  // SP-Sao Caetano do Sul
cRetMunCanc += "4303103" + cPipe  // RS-Cachoeirinha
cRetMunCanc += "3148103" + cPipe  // MG-Patrocínio
cRetMunCanc += "3146107" + cPipe  // MG-Ouro Preto
cRetMunCanc += "4308201" + cPipe  // RS-Flores da Cunha
cRetMunCanc += "4311403" + cPipe  // RS-Lajeado
cRetMunCanc += "3304508" + cPipe  // RJ-Rio das Flores
cRetMunCanc += "4304606" + cPipe  // RS-Canoas
cRetMunCanc += "2301000" + cPipe  // CE-Aquiraz
cRetMunCanc += "4207304" + cPipe  // SC-Imbituba
cRetMunCanc += "4211306" + cPipe  // SC-Navegantes
cRetMunCanc += "3552502" + cPipe  // SP-Suzano
cRetMunCanc += "3302007" + cPipe  // RJ-Itaguaí
cRetMunCanc += "4307708" + cPipe  // RS-Esteio
cRetMunCanc += "4308508" + cPipe  // RS-Frederico Westphalen
cRetMunCanc += "1200401" + cPipe  // AC-Rio Branco 
cRetMunCanc += "3200607" + cPipe  // ES-Aracruz
cRetMunCanc += "3550704" + cPipe  // SP-São Sebastião
cRetMunCanc += "4307005" + cPipe  // RS-Erechim
cRetMunCanc += "4215802" + cPipe  // SC-São Bento do Sul  
cRetMunCanc += "3301900" + cPipe  // RJ-Itaboraí
cRetMunCanc += "4107652" + cPipe  // PR-Fazenda Rio Grande
cRetMunCanc += "3104007" + cPipe  // MG-Araxá

// Municípios do Modelo "101" Geração de arquivo TXT
cRetMunCanc += "2610707" + cPipe  // PE-Paulista 
cRetMunCanc += "3168705" + cPipe  // MG-Timoteo
cRetMunCanc += "3205200" + cPipe  // ES-Vila Velha
cRetMunCanc += "3505708" + cPipe  // SP-Barueri
cRetMunCanc += "1501402" + cPipe  // PA-Belem
		
// Municípios do Modelo "102" Geração de arquivo XML 
cRetMunCanc += "3132404" + cPipe  // MG-Itajuba
cRetMunCanc += "4205407" + cPipe  // SC-Florianopolis
cRetMunCanc += "4209102" + cPipe  // SC-Joinville
cRetMunCanc += "3158953" + cPipe  // MG-Santana do Paraiso
cRetMunCanc += "3507605" + cPipe  // SP-Bragança Paulista

// Municípios do Modelo "006"
cRetMunCanc += "3506003" + cPipe  // SP-Bauru
cRetMunCanc += "4113700" + cPipe  // PR-Londrina
cRetMunCanc += "4315602" + cPipe  // RS-Rio Grande

// Municípios do Modelo "009" 
cRetMunCanc += "3546801" + cPipe  // SP-Santa Isabel

// Municípios do Modelo "011" 
cRetMunCanc += "4208450" + cPipe  // SC-Itapoá
cRetMunCanc += "4309209" + cPipe  // RS-Gravatai
cRetMunCanc += "4216206" + cPipe  // São Francisco do Sul - SC

// Municípios do Modelo "012"
cRetMunCanc += "3524006" + cPipe  // SP-Itupeva

Return(cRetMunCanc)

Static Function ExecWSRet( oWS, cMetodo )

Local bBloco	:= {||}

Local lRetorno	:= .F.    

Private oWS2 

DEFAULT oWS		:= NIL
DEFAULT cMetodo	:= ""

If ( ValType(oWS) <> "U" .And. !Empty(cMetodo) )

	oWS2 := oWS

	If ( Type("oWS2") <> "U" )
		bBloco 	:= &("{|| oWS2:"+cMetodo+"() }") 
		lRetorno:= eval(bBloco)
		
		If ( lRetorno == NIL )
			lRetorno := .F.			
		EndIf
		
	EndIf
	
EndIf

Return lRetorno

Function CleanSpecChar(cString)
	
	Local cRetorno:=""
	Local nChar:=0
	Local cChar:='<>´"'+"'"
                   
	cRetorno:=cString	                       
 
	For nChar:=1 To len(cChar)
		cRetorno:=StrTran(cRetorno,Substr(cChar,nChar,1),"")
	 Next
	
Return cRetorno

//-----------------------------------------------------------------------
/*/{Protheus.doc} GetMunNFT
Funcao retorna os municipios que trabalham com NFTS - Nota Fiscal
Tomador de Serviço.

@author Sergio Sueo Fuzinaka
@since 12.11.2010
@version 1.0 

@param		Nil

@return		Nil
@obs		A tabela SPED051 deve estar posicionada
/*/
//-----------------------------------------------------------------------
Function GetMunNFT()
	
	Local cCodMun := "3550308" //Sao Paulo
	Local cCodMun += SuperGetMV("MV_NFTOMSE", ," ")   //Parametro para informar quais os municipios que estão configurado para o envio da "NFTS"
	                   
	cRetorno := cCodMun
 		
Return cRetorno

//-----------------------------------------------------------------------
/*/{Protheus.doc} retornaMonitor
Funcao que executa o retornanfse e retorna a data e hora de transmissão do documento.

@author Henrique Brugugnoli
@since 30/01/2012
@version 1.0 

@param cXmlRet	XML unico de retorno do TSS

@return		Nil
/*/
//-----------------------------------------------------------------------
Static Function retornaMonitor( cCID, cXmlRet )

Local aDados	:= {}

Local cHora		:= ""
Local cData		:= "" 
Local cAviso	:= "" 
Local cErro		:= ""
Local cCodVer	:= ""
Local dDataConv	:= CTOD( "" )
           
Private oXml	:= NIL

If ( !Empty(cXmlRet) )
 	
 	oXml := XmlParser( cXmlRet, "_", @cAviso, @cErro )  
 		
	cHora		:= ""
	cData		:= ""
	dDataConv	:= CTOD( "" )
 		
 	If ( empty(cErro) .And. empty(cAviso) ) .And. Type( "oXml:_nfseretorno:_identificacao:_tipo:TEXT" ) <> "U"
 		
 		If ( oXml:_nfseretorno:_identificacao:_tipo:TEXT == "1" ) .And. Type( "oXml:_nfseretorno:_identificacao:_dthremisrps:TEXT" ) <> "U"
 			
			cHora := SubStr( oXml:_nfseretorno:_identificacao:_dthremisrps:TEXT,12,8 )
			cData := SubStr( oXml:_nfseretorno:_identificacao:_dthremisrps:TEXT,1,10 )  
						
 		ElseIf ( oXml:_nfseretorno:_identificacao:_tipo:TEXT == "2" ) .And. Type( "oXml:_nfseretorno:_cancelamento:_datahora:TEXT" ) <> "U"
 			
			cHora := SubStr( oXml:_nfseretorno:_cancelamento:_datahora:TEXT,12,8 )
			cData := SubStr( oXml:_nfseretorno:_cancelamento:_datahora:TEXT,1,10 )
			
 		EndIf
 		 
		If !Empty( cData )
			dDataConv := cToD(SubStr(cData,9,2) + "/" + SubStr(cData,6,2)  + "/" + SubStr(cData,1,4)) 
		Endif
		
		If Type( "oXml:_nfseretorno:_identificacao:_codver:TEXT" ) <> "U"
			cCodVer := oXml:_nfseretorno:_identificacao:_codver:TEXT
		Endif
		
		aDados := { cCID, dDataConv, cHora, cCodVer }
		
 	EndIf		
 	
 EndIf
 		
oXml := Nil

Return( aDados )

//-----------------------------------------------------------------------
/*/{Protheus.doc} isModeloUnico
Funcao que verifica se e modelo unico de retorno que esta valendo.

@author Henrique Brugugnoli
@since 30/01/2012
@version 1.0 

@return	lModeloUnico	Se verdadeiro esta execuntando o modelo unico
/*/
//-----------------------------------------------------------------------
Function isTSSModeloUnico()

Local lModeloUnico	:= .F.

If ( GetVersao(.F.) > "11" )
	lModeloUnico := .T.	
Else
	If ( GetMV("MV_NFSEMOD",,.F.) )
		lModeloUnico := .T.
	EndIf
EndIf

Return lModeloUnico      


//-----------------------------------------------------------------------
/*/{Protheus.doc} GetMonitRx
Funcao que retorna informações referente ao Monitoramento da NFS-e do TSS

@author Simone dos Santos Oliveira
@since 12.03.2012
@version 1.0 

@param		Nil

@return		Nil
/*/
//-----------------------------------------------------------------------
Static Function GetMonitRx(cIdEnt,cUrl)

Local aArea	:= GetArea()
Local aNotas	:= {}  
Local cAliasSF3 := GetNextAlias()
Local cCodMun   := SM0->M0_CODMUN 
Local cNumAte	:= "" 
Local cNumDe  	:= ""
Local lOk       := .F.
local nAt		:= 0
Local nX        := 0  
Local oWS		:= Nil
Local oXmlMonit	:= Nil


BeginSql Alias cAliasSF3
	COLUMN F3_ENTRADA AS DATE
	COLUMN F3_DTCANC AS DATE
	
	SELECT	F3_FILIAL,F3_ENTRADA,F3_NFeLETR,F3_CFO,F3_FORMUL,F3_NFISCAL,F3_SERIE,F3_CLIEFOR,F3_LOJA,F3_ESPECIE,F3_DTCANC,F3_CODRSEF,R_E_C_N_O_
			FROM %Table:SF3% SF3
			WHERE
			SF3.F3_FILIAL = %xFilial:SF3% AND
			SF3.F3_DTCANC <> ' ' AND
			SF3.F3_CODRSEF = 'C' AND
			SF3.%notdel%
EndSql

If ( cAliasSF3 )->( Eof() )
	Return .F.
EndIf

While !( cAliasSF3 )->( Eof() )
	
	aAdd( aNotas, { allTrim( ( cAliasSF3 )->F3_SERIE ) + allTrim( ( cAliasSF3 )->F3_NFISCAL ), ( cAliasSF3 )->R_E_C_N_O_ } )
	
  	If (( cAliasSF3 )->F3_SERIE + ( cAliasSF3 )->F3_NFISCAL) < cNumDe .Or. Empty( cNumDe )
		cNumDe	:= ( cAliasSF3 )->F3_SERIE + allTrim( ( cAliasSF3 )->F3_NFISCAL )
	EndIf
	
	If (( cAliasSF3 )->F3_SERIE + ( cAliasSF3 )->F3_NFISCAL) > cNumAte .Or. Empty( cNumAte )
		cNumAte	:=  ( cAliasSF3 )->F3_SERIE + allTrim( ( cAliasSF3 )->F3_NFISCAL )
	EndIf
	
	( cAliasSF3 )->( DbSkip() )
	
EndDo  

oWS := WsNFSE001():New()
oWS:cUSERTOKEN             := "TOTVS"
oWS:cID_ENT                := cIdEnt 
oWS:_URL                   := AllTrim(cURL)+"/NFSE001.apw"
oWS:cCODMUN                := cCodMun
oWS:dDataDe                := cTod("01/01/1949")
oWS:dDataAte               := cTod("31/12/2049")
oWS:cHoraDe                := "00:00:00"
oWS:cHoraAte               := "00:00:00"
oWS:nTipoMonitor           := 1
oWS:cIdInicial             := cNumDe 
oWS:cIdFinal               := cNumAte 
oWS:nTempo                 := 0

lOk := ExecWSRet(oWS,"MonitorX")

If lOk
	
	oRetorno := oWS:OWSMONITORXRESULT
	
  	For nX := 1 To Len(oRetorno:OWSMONITORNFSE)
		
		oXmlMonit := oRetorno:OWSMONITORNFSE[nX]
					
		nAt	:= aScan( aNotas, { | x | x[1] == allTrim( SubStr( oXmlMonit:CID, 1, 3 ) ) + allTrim( SubStr( oXmlMonit:CID, 4, 9 ) ) } )
					
		If nAt > 0   
		
			If oXmlMonit:NSTATUSCANC == 3
				
				SF3->( DbGoTo( aNotas[nAt][2] ) )
				
				If SF3->(FieldPos("F3_CODRSEF")) > 0
					SF3->( RecLock("SF3",.F.) )
					SF3->F3_CODRSEF	:= "S"
					SF3->( MsUnlock() ) 
				EndIf 
				
			EndIf 
			
		EndIf 
		
	Next nX

EndIf

( cAliasSF3 )->( dbCloseArea() )

RestArea( aArea )
 		
Return .T.    

//-----------------------------------------------------------------------
/*/{Protheus.doc} GetCodCanc
Interface com os codigos de Cancelamento

@author Natalia Sartori
@since 14.05.2012
@version 1.0 

@param		

@Return			
/*/
//-----------------------------------------------------------------------   

Static Function GetCodCanc(lContinua)

Local aItCpo := {}

Local oCombo
Local oTButton2
Local oTButton
   
Local cCbCpo := ""  

Default lContinua := .F.

//======================= Adicionando dados no Array do Combo ===========================
aadd(aItCpo,"C001 - Dados do tomador incorretos")
aadd(aItCpo,"C002 - Erro na descrição do serviço")
aadd(aItCpo,"C003 - Erro no valor do serviço")
aadd(aItCpo,"C004 - Natureza da Operação e/ou Código do Item da Lista incorreto")
aadd(aItCpo,"C005 - Informações de descontos/outros tributos incorretas")
aadd(aItCpo,"C999 - Outros")

DEFINE MSDIALOG oDlg TITLE "Código de Cancelamento" FROM 0,0 TO  120, 400 PIXEL

DEFINE FONT oFont BOLD

//======================= Inicializa uma linha com SAY e COMBO ===========================
@ 5,5 SAY oSay PROMPT "Informe um código de cancelamento para as notas selecionadas:" OF oDlg FONT oFont PIXEL SIZE 230, 030

@ 20,5 COMBOBOX oCombo VAR cCbCpo ITEMS aItCpo SIZE 190,30 PIXEL OF oDlg   

//======================= Buttons ===========================
oTButton1 := TButton():New( 045, 060, "OK",oDlg,{|| (lContinua := .T.,oDlg:End())},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )

oTButton2 := TButton():New( 045, 105, "Cancelar",oDlg,{||(lContinua :=.F.,oDlg:End())},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )

ACTIVATE MSDIALOG oDlg CENTERED

Return (SubStr(cCbCpo,1,4))
static function geraArqNFSe(cIdEnt,cCodMun,cSerie,cNotaini,cNotaFin,cDEST,nForca,cSerieIni,cSerieFim,dDataIni,dDataFim,aRemessa,cNotasOk,lRecibo,cGravaDest)				
    
	local aNtXml	:= {}
	local cNtXml	:= ""
	local cCnpj	:= ""
	local cFin		:= ""
	local nX		:= 0
	local dDtxml
  
    default dDataIni := dDataFim:= date()
    default lRecibo	:= .f.
    default nForca	:= 1
    				
	for nX := 1 to len(aRemessa)
		if cEntSai == "0"
			cCnpj := alltrim(Posicione("SA2",1,xFilial("SA2")+aRemessa[nX][3]+aRemessa[nX][4],"SA2->A2_CGC"))
			if lRecibo
		   		cFin := "FIN"					
			endif 			
		endIf
		
		cNtXml+= aRemessa[nX][1]+aRemessa[nX][2]+cCnpj+cFin+CRLF					
		aadd(aNtXml, {})		
		aadd(aTail(aNtXml), aRemessa[nX][1])
		aadd(aTail(aNtXml), aRemessa[nX][2])
		aadd(aTail(aNtXml), aRemessa[nX][3])
		aadd(aTail(aNtXml), aRemessa[nX][4])
		aadd(aTail(aNtXml), cCnpj+cFin)
	next
   		
	dDtxml:= aRemessa[1][5]
	cNotasOk += Fisa022XML(cIdEnt,cCodMun,cSerie,cNotaini,cNotaFin,dDtxml,cDEST,cNtXml,aNtXml,nForca,cSerieIni,cSerieFim,dDataIni,dDataFim,cGravaDest)

return nil
//-----------------------------------------------------------------------
/*/{Protheus.doc} retDataXMLNFSe
retorna a data e a hora contida no XML da NFSe

@author Renato Nagib
@since 18.03.2013
@version 1.0 

@param cXML	XML da NFSe 		

@Return aRet	array contendo a data e a hora
				aRet[1] - data
				aRet[2] - hora
/*/
//-----------------------------------------------------------------------   

static function retDataXMLNFSe(cXML,cCodMun)


	local aTiposData	:= {}
	local aTiposHora	:= {}
	local aTiposDia		:= {}
	local aTiposMes		:= {}
	local aTiposAno		:= {}
	local aRet			:= {"", ""}
	local cAviso		:= ""
	local cErro		:= ""	
	local cRetData	:= ""	 
	local cRetHora	:= ""
	local cConteudo	:= ""
	local cConteuDia:= ""
	local cConteuMes:= ""
	local cConteuAno:= ""
	local lDataHora	:= .T.
	local nPosData	:= 0
	local nPosHora	:= 0
	local nPosDia	:= 0
	local nPosMes	:= 0
	local nPosAno	:= 0
	
	private oXML 
	         
	default cXML	:= "" 
	
	cXML := StrTran(cXML,"tipos:","")
	cXML := StrTran(cXML,"tc:","")				    		   
	cXML := StrTran(cXML,"es:","")
	cXML := StrTran(cXML,"nfse:","")				    		   								
	cXML := StrTran(cXML,"sis:","")	
	cXML := StrTran(cXML,'xsi:type="xsd:int"',"")	
	cXML := StrTran(cXML,'xsi:type="xsd:string"',"")	
	
	//colaboracao                       
	aadd( aTiposData, "_RPS:_DATAEMISSAORPS" )
	
	aadd( aTiposData, "_ENVIARLOTERPSENVIO:_LOTERPS:_LISTARPS:_RPS:_INFRPS:_DATAEMISSAO" )
	aadd( aTiposData, "_ENVIARLOTERPSENVIO:_LOTERPS:_LISTARPS:_RPS[1]:_INFRPS:_DATAEMISSAO" )
	aadd( aTiposData, "_P_ENVIARLOTERPSENVIO:_P_LOTERPS:_P1_LISTARPS:_P1_RPS:_P1_INFRPS:_P1_DATAEMISSAO" )

	//"3550308(SAO PAULO)-2611606(RECIFE)-4202404(BLUMENAU)
	aadd( aTiposData, "_RPS:_DATAEMISSAO" ) 

	//4318002(RS-São Borja)-4203006(SC-Caçador)-5218508(GO-Quirinópolis)-4207304(SC-Imbituba)-4211306(SC-Navegantes)
	aadd( aTiposData, "_E_ENVIARLOTERPSENVIO:_LOTERPS:_LISTARPS:_RPS[1]:_INFRPS:_DATAEMISSAO" )

	//4318002(RS-São Borja)-4203006(SC-Caçador)-5218508(GO-Quirinópolis)
	aadd( aTiposData, "_E_ENVIARLOTERPSENVIO:_LOTERPS:_LISTARPS:_RPS:_INFRPS:_DATAEMISSAO" )

	//3503307(SP-Araras)-3515004(SP-Embu das artes)-3538709(SP-Piracicaba)-3148103(MG-Patrocínio)
	aadd( aTiposData, "_ENVIARLOTERPSENVIO:_NFSE_LOTERPS:_NFSE_LISTARPS:_NFSE_RPS:_NFSE_INFRPS:_NFSE_DATAEMISSAO" )

	//"3106200|2927408|3170107|4106902|3501608|3301702|3136207|2304400|3543402|2704302|3115300|2507507|3547809|3513009|2604106|5201108|4104808|2800308|3548708|3513801|5103403|3525904|3518800|3118601|3519071|3518701|1302603|3156700|3549904|3303302|3549805|3548500|3300407|3147105|4118204|3300100|4125506|4108304|3131307|2910800|4208203|3536505|3518404|3529401|3523909|4216602|3303401|4204608|2802106|3143906|2307650|3136702|3106705" // |Belo Horizonte-MG|Salvador-BA|Uberaba-MG|Curitiba-PR|Americana-SP|Duque de Caxias-RJ|João Monlevade-MG|Fortaleza-CE|Ribeirão Preto-SP|Maceió-AL|Cataguases-MG|João Pessoa-PB|Santo André-SP|Cotia-SP|Caruaru-PE|Anápolis-GO|Cascavel-PR|Aracaju-SE|São Bernardo do Campo-SP| 
	//Diadema-SP|Cuiabá-MT|Jundiai-SP|Guarulhos-SP|Contagem-MG|Hortolandia-SP|Guaruja-SP|Manaus-AM|Sabará-MG|São Borja-RS|São José dos Campos-SP|Niteroi|São José do Rio Preto-SP|Barra Mansa-RJ|Pará de Minas-MG|Paranaguá-PR|Angra dos Reis-RJ|São José dos Pinhais||Foz do Iguaçu-PR|Ipatinga-MG|Feira de Santana|Itajaí-SC|Paulinia|Guaratinguetá|Mauá|Itu|São José|Nova Friburgo|Criciúma|Estância-SE|Muriaé-MG|Maracanaú-CE|Juiz de Fora-MG|Betim-MG|Araquari-SC|
	aadd( aTiposData, "_CONSULTARLOTERPSRESPOSTA:_LISTANFSE:_COMPNFSE[1]:_NFSE:_INFNFSE:_DATAEMISSAO" )
	aadd( aTiposData, "_CONSULTARLOTERPSRESPOSTA:_LISTANFSE:_COMPNFSE:_NFSE:_INFNFSE:_DATAEMISSAO" )
	aadd( aTiposData, "_GERARNFSEENVIO:_LOTERPS:_LISTARPS:_RPS:_INFRPS:_DATAEMISSAO" )
	aadd( aTiposData, "_GERARNFSEENVIO:_RPS:_INFDECLARACAOPRESTACAOSERVICO:_RPS:_DATAEMISSAO" )
	aadd( aTiposData, "_ENVIARLOTERPSENVIO:_LOTERPS:_LISTARPS:_RPS:_INFDECLARACAOPRESTACAOSERVICO:_RPS:_DATAEMISSAO" )
	aadd( aTiposData, "_ENVIARLOTERPSENVIO:_LOTERPS:_LISTARPS:_RPS[1]:_INFDECLARACAOPRESTACAOSERVICO:_RPS:_DATAEMISSAO" )
	aadd( aTiposData, "_ENVIARLOTERPSSINCRONOENVIO:_LOTERPS:_LISTARPS:_RPS:_INFDECLARACAOPRESTACAOSERVICO:_RPS:_DATAEMISSAO" )
	aadd( aTiposData, "_ENVIARLOTERPSSINCRONOENVIO:_LOTERPS:_LISTARPS:_RPS[1]:_INFDECLARACAOPRESTACAOSERVICO:_RPS:_DATAEMISSAO" )

	//"2111300|5002704|3170206|1501402|2211001|3303500|3509502|3552205" //Sao Luis|Campo Grande|Uberlandia|Belem|Teresina|Nova Iguaçu|Campinas|Sorocaba - Modelo DSFNET
	aadd( aTiposData, "_NS1_REQENVIOLOTERPS:_LOTE:_RPS[1]:_DATAEMISSAORPS" )
	aadd( aTiposData, "_NS1_REQENVIOLOTERPS:_LOTE:_RPS:_DATAEMISSAORPS" )
	
	//3300704(Cabo Frio)-1400100(RR-Boa Vista)
	aadd( aTiposData, "_SubstituirNfseEnvio:_SubstituicaoNfse:_Rps:_InfDeclaracaoPrestacaoServico:_Rps:_DataEmissao" ) 
	//3158953 //Santana do Paraiso-MG
	aadd( aTiposData, "_NOTAS:_NOTA_DATA_EMISSAO" )
	
	//Modelo 004
	aadd( aTiposData, "_TBNFD:_NFD:_DATAEMISSAO" )
	
	//Modelo 007                                                                  
	aadd( aTiposData, "_ENVIARLOTERPSENVIO:_LOTE:_LISTARPS:_RPS:_DTEMISSAORPS")
	aadd( aTiposData, "_ENVIARLOTERPSENVIO:_LOTE:_LISTARPS:_RPS[1]:_DTEMISSAORPS")
	
	//Modelo 008
	aadd( aTiposData, "_ENVIOLOTE:_DHTRANS")
	//Modelo 009
	aadd( aTiposData, "_NFEELETRONICA:_DADOSNOTAFISCAL:_EMISSAO")
	aadd( aTiposData, "_NFEELETRONICA:_DADOSNOTAFISCAL[1]:_EMISSAO")
	//Definir os tipos,caso exista Municipio que contenha a informação da hora em uma tag especifica
	aadd( aTiposHora, "" )   
	
	//Definir os tipos, caso exista Municipio que contenha as informações do dia, mês e ano de emissão do RPS em uma tag especifica 
	aadd( aTiposDia, "_DESCRICAORPS:_RPS_DIA") 
	
	aadd( aTiposMes, "_DESCRICAORPS:_RPS_MES")
	
	aadd( aTiposAno, "_DESCRICAORPS:_RPS_ANO")
				

	oXML := XmlParser(cXML,"_",@cAviso,@cErro)
	
   	If oXML == Nil
		oXML := XmlParser(EncodeUtf8(cXML),"_",@cAviso,@cErro) 
	EndIf 
	
	//verifica se a data é separada
	nPosDia := aScan(aTiposDia,{|X| type("oXML:"+X) <> "U" }) 
	nPosMes := aScan(aTiposMes,{|X| type("oXML:"+X) <> "U" })
	nPosAno := aScan(aTiposAno,{|X| type("oXML:"+X) <> "U" })
	
	if nPosDia > 0 .and. nPosMes > 0 .and. nPosAno > 0 
		cConteuDia := "oXML:"+aTiposDia[nPosDia]+":TEXT" 
		cConteuMes := "oXML:"+aTiposMes[nPosMes]+":TEXT" 
		cConteuAno := "oXML:"+aTiposAno[nPosAno]+":TEXT"
	else
		//pega a data 
		nPosData := aScan(aTiposData,{|X| type("oXML:"+X) <> "U" })
	
		if nPosData > 0
			cConteudo := "oXML:"+aTiposData[nPosData]+":TEXT"
		endif 
		
	endif
	
	if !Empty(cConteuDia) .And. !Empty(cConteuMes) .And. !Empty(cConteuAno)
		cConteudo := (&(cConteuAno)+"/"+&(cConteuMes)+"/"+&(cConteuDia))
	else
		cConteudo :=&(cConteudo)
	endif
	
	if cConteudo == nil
		cConteudo := ""
	endif

	cRetData	:= substr(cConteudo,1,10)

	if lDataHora 
		cRetHora	:= substr(cConteudo,12,8) 

	else	 //busca a hora na tag especifica para hora
 
		nPosHora := aScan(aTiposHora,{|X| type("oXML:"+X) <> "U" })
	
		if nPosHora > 0
			cRetHora := "oXML:"+aTiposHora[nPosData]+":TEXT"
		endif 
		
		cRetHora :=&(cRetHora)
					
		if cRetHora == nil
			cRetHora := ""
		endif
	endif	

	If cCodMun <> "3205002"
		cRetData 	:= CTOD(SubStr(cRetData,9,2) + "/" + SubStr(cRetData,6,2)  + "/" + SubStr(cRetData,1,4))
	Else
		cRetData 	:= CTOD(cRetData)
	EndIf
		
	aRet[1]	:= cRetData
	aRet[2]	:= cRetHora
	
	oXML		:= NIL
			
return aRet

//-----------------------------------------------------------------------
/*/{Protheus.doc} RefListBox
Função de atualização do aListBox relacionado ao monitor ao selecionar o 
refresh

@author Natalia Sartori
@since 02/01/2014
@version 1.0 

@param  oListBox, aListBox		

@Return
/*/
//-----------------------------------------------------------------------   
Function RefListBox(oListBox,aListBox)

oListBox:SetArray( aListBox )
oListBox:bLine := { || { aListBox[ oListBox:nAT,1 ],aListBox[ oListBox:nAT,2 ],aListBox[ oListBox:nAT,3 ],aListBox[ oListBox:nAT,4 ],aListBox[ oListBox:nAT,5 ],aListBox[ oListBox:nAT,6 ],aListBox[ oListBox:nAT,7 ],aListBox[ oListBox:nAT,8 ]} }
oListBox:Refresh()


Return
/*/{Protheus.doc} Fis022ImpAIDF
Importação de arquivos  AIDF

@author Renato Nagib
@since 26.12.2013
@version 1.0 

@Return nil
				
/*/
//-----------------------------------------------------------------------
function Fis022ImpAIDF()

	local cTexto		:= STR0151	//"Este assistente tem por objetivo auxiliá-lo na importação de arquivos AIDF para emissão de RPS"	
	local cTexto2		:= STR0040
	local cArq			:= ""
	local cRetorno	:= ""
	
	DEFINE WIZARD oWizard ;
		TITLE STR0152;		//"Importação de arquivo AIDF"
		HEADER STR0153;	//"Assistente para importação de aquivo AIDF"
		MESSAGE "";
		TEXT cTexto ;
		NEXT {|| .T.} ;
		FINISH {|| .T.}
	
	CREATE PANEL oWizard  ;
		HEADER STR0153;	//"Assistente para importação de arquivo de AIDF"
		MESSAGE STR0154;	//"selecione o arquivo de AIDF a ser importado."
		BACK {|| .T.} ;
		NEXT {|| geraAIDF(cArq,@cRetorno)};
		FINISH {|| .T.};
		PANEL
				
		TButton():New( 090,020,STR0044,oWizard:oMPanel[2],{||cArq := cGetFile("Arquivos .AIDF|*.AIDF","Selecione o arquivo",0,"",.T.,GETF_LOCALHARD),.T.},29,12,,oWizard:oMPanel[2]:oFont,,.T.,.F.,,.T., ,, .F.)
		@ 090,050 GET cArq SIZE 220,010 PIXEL OF oWizard:oMPanel[2]	
		
	CREATE PANEL oWizard  ;
		HEADER STR0153;	//"Assistente para importação de arquivo de AIDF"
		MESSAGE STR0155;	//"Importacao finalizada."
		BACK {|| .T.} ;		
		FINISH {|| .T.};
		PANEL
		@ 010,010 GET cRetorno MEMO SIZE 270, 115 READONLY PIXEL OF oWizard:oMPanel[3]
	ACTIVATE WIZARD oWizard CENTERED
	
return nil

//-----------------------------------------------------------------------
/*/{Protheus.doc} geraAIDF
gera tabela AIDF

@author Renato Nagib
@since 26.12.2013
@version 1.0 

@param cFile	nome do arquivo a ser importado 		
@param cRetorno	resultado da importacao

@Return .T.
				
/*/
//-----------------------------------------------------------------------
static function geraAIDF(cFile,cRetorno)
	
	local aAuxiliar	:= {}
	local aRegistro	:= {}
	local aTabela		:= {}	
	local aTemp		:= {}
	local cLinha	:= ""
	local cDel		:= ""
	local cCodMun	:= SM0->M0_CODMUN
	local cChave	:= ""
	local cNomeArquivo:= cFile
	local cBarra		:= if( !IsSrvUnix(), "\", "/")
	
	local lRecLock	:= .F.
	
	local nX := 0
	
	local cBloco := ""	
	//obtem o nome do arquivo para gravação 		
	while cBarra $ cNomeArquivo
		cNomeArquivo:= substr(cNomeArquivo,At(cBarra,cNomeArquivo)+1)
	end 
	//Estrutura da tabela
	aStruct := getStructAIDF(cCodMun)
	
	if AliasIndic("C0P")
		dbSelectArea("C0P")	
		C0P->(dbSetOrder(aStruct[1]))
		
		//monta chave de indice
		cIndice := C0P->(indexkey(aStruct[1]))	
		aChave:= StrTokArr(cIndice,"+")
		
		//Delimitador do arquivo txt a ser importado,implementar caso necessario 
		//cDel := getDel(cCodMun)
	
		if file(cFile)
			if FT_FUse(cFile) <> -1 .and. len(aStruct[2]) > 0
				FT_FGotop()
				begin Transaction
					While ( !FT_FEof() )
		
						cLinha := FT_FREADLN()
						if !validReg(cCodMun,cLinha)
							FT_FSkip()
							loop
						endif

						If cCodMun $ "3524006"
							aRegistro := StrTokArr(cLinha,"|")
							If 	aRegistro[1] == "H" 
								cBloco := aRegistro[3]
							EndIf
						elseif empty(cDel) 
							nX:= 1
							while !empty(cLinha) .and. nX <= len(aStruct[2])  
								aadd(aRegistro, subst(cLinha,1,aStruct[2][nX][3]) )
								cLinha := subst( cLinha,aStruct[2][nX][3] + 1)
								nX++ 
							end
	 
						else				
							aRegistro := StrTokArr(cLinha,cDel)										
						endif
			
						//Monta chave de indice para busaca do registro na tabela 	
						If	cCodMun $ "3524006"
							C0P->(DbSetOrder(2))
							cChave := xFilial("C0P")+cBloco+aRegistro[2]
						Else										
							for nX := 1 to len(aChave) 
								if "FILIAL" $ aChave[nX] 
									cChave += xFilial("C0P")
								else
									nPos := aScan(aStruct[2], {|X| alltrim(X[1]) $ aChave[nX] })
									if nPos > 0  .and. nPos <= len(aChave) 
										cChave += padr(aRegistro[nPos],TamSx3(aStruct[2][nPos][1])[1])
									endif	
								endif		
							next	
						EndIf	
			 			
						if !(C0P->(dbSeek(cChave)))	
							If cCodMun $ "3524006"
								If 	aRegistro[1] == "D" 
									reclock("C0P",.T.)
									lRecLock:=.T.
								Else
									lRecLock:=.F.									
								EndIf
							Else		
								reclock("C0P",.T.)
								lRecLock:=.T.
							EndIf
						elseif !C0P->C0P_AUT $ 'TS'
							reclock("C0P",.F.)								
						else
							lReclock := .F.								
						endif
						
						if lRecLock
							
							//Atualização da tabela
							C0P->C0P_FILIAL	:= xFilial("C0P")
							C0P->C0P_ARQ		:= strTran(upper(cNomeArquivo), ".AIDF", "")
							for nX := 1 to len(aRegistro)
								If nX <= len(aStruct[2])
									if valtype( C0P->&(aStruct[2][nX][1]) ) == "N"
										C0P->&(aStruct[2][nX][1]) := val(aRegistro[nX])
									elseif valtype( C0P->&(aStruct[2][nX][1]) ) == "D"
										C0P->&(aStruct[2][nX][1]) := stod(aRegistro[nX])										
									else
										C0P->&(aStruct[2][nX][1]) := aRegistro[nX]
										If cCodMun $ "3524006"
											C0P->&(aStruct[2][5][1])  := cBloco
										EndIf
									endif		
								EndIf
							next					
							
							C0P->(msunlock())
						endif
						
						FT_FSkip()
						cChave:= ""
						aRegistro:= {}
					EndDo
				end transaction	
	
				FT_FUse()
	
				cRetorno := STR0156	//"Arquivo importado com sucesso."
			else
				cRetorno:= STR0157	//"Erro na leitura do arquivo: " + STR(FERROR())	
			endif
	
		else		
			cRetorno:= STR0158	//"Arquivo não encontrado "
		endIf
		C0P->(dbGotop())
	else	
		cRetorno:= STR0159 + STR0160	//"Não foi possível realizar a importação do arquivo. + O compatibilizador para importação de arquivo AIDF não foi executado."		
	endif	
return .T.

//-----------------------------------------------------------------------
/*/{Protheus.doc} getStructAIDF
valida registro para importação

@author Renato Nagib
@since 26.12.2013
@version 1.0 

@param cCodMun		codigo do Municipio 		

@Return aStruct	Estrutura da tabela para a importação
			aStruct[1]			indice da tabela
			aStruct[2]			campos da tabela
			aStruct[2][nX][1]	nome do campo
			aStruct[2][nX][2]	Tipo do campo
			aStruct[2][nX][3]	tamanho do campo para preenchimento
				
/*/
//-----------------------------------------------------------------------
Function getStructAIDF(cCodMun)

	local aStruct	:= {}
	
	do Case
		case cCodMun $ "3134202"
			aadd(aStruct, 1)//numero do indice da tabela
			aadd(aStruct, {})
			aadd(aTail(aStruct), { "C0P_TIPO"	, "C", 05, "Tipo" })
			aadd(aTail(aStruct), { "C0P_SEQ"	, "C", 06, "Sequncia" })			
			aadd(aTail(aStruct), { "C0P_RPS"	, "C", 10, "RPS" })
			aadd(aTail(aStruct), { "C0P_CHAVE"	, "C", 10, "Chave" })		
		case cCodMun $ "3524006" // Itupeva - SP
			aadd(aStruct, 1)//numero do indice da tabela
			aadd(aStruct, {})
			aadd(aTail(aStruct), { "C0P_TIPO"	, "C", 01, "Tipo" })
			aadd(aTail(aStruct), { "C0P_SEQ"	, "C", 08, "Sequencia" })
			aadd(aTail(aStruct), { "C0P_CHAVE"	, "C", 10, "Chave" })	
			aadd(aTail(aStruct), { "C0P_RPS"	, "C", 10, "RPS" })
			aadd(aTail(aStruct), { "C0P_BLOCO"	, "C", 08, "Bloco" })			
					
	endCase	
			
return aStruct
//-----------------------------------------------------------------------
/*/{Protheus.doc} validReg
valida registro para importação

@author Renato Nagib
@since 26.12.2013
@version 1.0 

@param cCodMun		codigo do Municipio 		
@param cLinha		linha do arquivo a ser validado

@Return lRet	validação da linha
				
/*/
//----------------------------------------------------------------------- 
static function validReg(cCodMun,cLinha)
	
	local lRet := .F.
	
	default cCodMun	:= ""
	default cLinha	:= ""
	
	if cCodMun == '3134202'
		lRet := len(cLinha) == 31//registro valido para importacao
	ElseIf cCodMun == '3524006'
		lRet := len(cLinha) == 94//registro valido para importacao
	endif

return lRet

//-----------------------------------------------------------------------
/*/{Protheus.doc} Fis022DelImpAIDF
realiza a exclusão dos registros importado

@author Renato Nagib
@since 27.12.2013
@version 1.0 

@Return lRet	validação da linha
				
/*/
//----------------------------------------------------------------------- 
function Fis022DelImpAIDF()

	local aFiles := getFilesAIDF()
	
	local cTexto		:= STR0161	//"Este assistente tem por objetivo auxiliá-lo na Exclusão de importação de arquivos AIDF para emissão de RPS"	
	local cTexto2		:= STR0040
	local cArq			:= ""
	local cRetorno	:= ""
	local cCombo		:= ""
	
	local oCombo		:= nil
		
	DEFINE WIZARD oWizard ;
		TITLE STR0162;	//"Exclusão de importação de arquivo de AIDF"
		HEADER STR0163;	//"Assistente para Exclusão de importação de aquivo AIDF"
		MESSAGE "";
		TEXT cTexto ;
		NEXT {|| .T.} ;
		FINISH {|| .T.}
	
	CREATE PANEL oWizard  ;
		HEADER STR0163;	//"Assistente para exclusão de importação de arquivo de AIDF"
		MESSAGE STR0164;	//"selecione o arquivo de AIDF a ser excluído da importação."
		BACK {|| .T.} ;
		NEXT {|| delArqAIDF(cCombo,@cRetorno)};
		FINISH {|| .T.};
		PANEL
				
 		@ 090,050 COMBOBOX oCombo VAR cCombo ITEMS aFiles SIZE 120,010 OF oWizard:oMPanel[2] PIXEL 
	
	CREATE PANEL oWizard  ;
		HEADER STR0163;	//"Assistente para exclusão de importação de arquivo de AIDF"
		MESSAGE STR0165;	//"exclusão finalizada."
		BACK {|| .T.} ;		
		FINISH {|| .T.};
		PANEL		
		@ 010,010 GET cRetorno MEMO SIZE 270, 115 READONLY PIXEL OF oWizard:oMPanel[3]
	ACTIVATE WIZARD oWizard CENTERED
	
return

//-----------------------------------------------------------------------
/*/{Protheus.doc} delArqAIDF
realiza a exclusão dos registros importado

@author Renato Nagib
@since 27.12.2013
@version 1.0 

@param cCodMun		codigo do Municipio 		
@param cRetorno	mensagem de retorno do processamento

@Return lRet	retorno da rotina
				
/*/
//-----------------------------------------------------------------------
static function delArqAIDF(cFile, cRetorno)

	local cAlias := getNextAlias()
	
	local lOk := .F.
	
	local nCount := 0
	
	if AliasIndic("C0P")

		BeginSql Alias cAlias			
			SELECT R_E_C_N_O_ REC FROM %table:C0P% C0P	  
			WHERE C0P_ARQ = %exp:cFile% AND			 
			C0P.%notdel%
		EndSql
	
		if (cAlias)->(!eof())	
			Begin Transaction
				while (cAlias)->(!eof()) 
					C0P->(dbGoTo((cAlias)->REC))
					if C0P->C0P_AUT $ "TS" .and. !lOk
						if !msgYesNo(STR0166)	//"Um ou mais registros já foram utilizados para a emissão de RPS e não poderão ser excluídos.Deseja excluir os registros disponíveis para utilização? "
							disarmTransaction()
							exit
						endif
						lOk := .T.					
					else 
						if !C0P->C0P_AUT $ "TS"
							reclock("C0P")
							C0P->(dbDelete())
							C0P->(msUnlock())
							nCount++
						endif	
					endif	
					(cAlias)->(dbSkip())
				end		
				 
			end Transaction					
			
			cRetorno := STR0165 + CRLF + STR0167	+ cValtoChar(nCount) //"Exclusão finalizada."+CRLF+" Registros excluídos: " 
		else
			cRetorno := STR0168	//"Não há arquivos para exclusão."
		endif	
	
		(cAlias)->(dbCloseArea())
		C0P->(dbGotop())
	endif	
		
return .T.

//-----------------------------------------------------------------------
/*/{Protheus.doc} GetFilesAIDF
retorna o nome dos arquivos importados para a tabla AIDF

@author Renato Nagib
@since 27.12.2013
@version 1.0 

 		
@param cRetorno	mensagem de retorno do processamento

@Return aArq	arquivos
				
/*/
//-----------------------------------------------------------------------
static function GetFilesAIDF()

	local aArq := {}
	
	local cAlias := getNextAlias()

	BeginSql Alias cAlias			
		SELECT DISTINCT(C0P_ARQ) ARQ FROM %table:C0P% C0P	  
		WHERE C0P.%notdel%
	EndSql
	
	if (cAlias)->(!eof())	
		while (cAlias)->(!eof()) 
			aadd(aArq, (cAlias)->ARQ)
			(cAlias)->(dbSkip())
		end						
	endif		
	(cAlias)->(dbCloseArea())
return aArq

//-----------------------------------------------------------------------
/*/{Protheus.doc} getAidfRps
retorna o proximo AIDF a ser emitido

@author Renato Nagib
@since 06.01.2014
@version 1.0 

@param cCodMun		codigo do Municipio 		



@Return aAIDF	informações do AIDF
				
/*/
//-----------------------------------------------------------------------
function getAidfRps(cCodmun, cSerie, cNota, cAviso)

	local aAIDF	:= {""}
	local aStruct	:= {}
	local cNItu	:= cNota
	local lTrans	:= .F.
	
	
	local nNota	:= 0
	
	aStruct := getStructAIDF(cCodMun)	 
	
	cAviso := ""
		
	if AliasIndic("C0P") 
		cNota := cValToChar(val(cNota))
		C0P->(dbSetOrder(aStruct[1]))
		
		If cCodMun == "3524006"
			cNota := "0"
			aAIDF	:= {}
			lTrans := C0P->(dbSeek(xFilial() + cNItu)) .OR. (!C0P->(dbSeek(xFilial() + cNItu)) .AND. C0P->(dbSeek(xFilial() + cNota)))
		Else
			lTrans := C0P->(dbSeek(xFilial() + cNota))
		EndIf
	
		if lTrans
			
			if !C0P->C0P_AUT $ "T|S"				 
				If cCodMun == "3524006"   
					aadd(aAIDF,C0P->C0P_CHAVE)
					aadd(aAIDF,C0P->C0P_BLOCO)
					aadd(aAIDF,C0P->C0P_SEQ)					
				Else
					aAIDF[1] := C0P->C0P_CHAVE		
				EndIf			
			Else
				cAviso := CRLF + "Uma ou mais notas não transmitidas.AIDF já emitido."
			endif		
		else
			cAviso := CRLF + "Uma ou mais notas não transmitidas.AIDF não encontrado."
		endif
	endif		
return aAIDF

//-----------------------------------------------------------------------
/*/{Protheus.doc} UsaAidfRps
retorna se utiliza AIDF 

@author Karyna Rainho
@since 05.02.2014
@version 1.0 

@param cCodMun		codigo do Municipio 		


@Return lRet	
				
/*/
//-----------------------------------------------------------------------
function UsaAidfRps(cCodmun)

Local lRet := .F.
 
If cCodmun $ "3134202-3524006"
	lRet := .T. 
EndIf 
 
Return lRet


//-----------------------------------------------------------------------
/*/{Protheus.doc} GravaRps
retorna se utiliza AIDF 

@author Karyna Rainho
@since 05.02.2014
@version 1.0 

@param cCodMun		codigo do Municipio 		


@Return lRet	
				
/*/
//-----------------------------------------------------------------------
function GravaRps(cCodmun)

Local lRet := .F.
 
If cCodmun $ "3524006"
	lRet := .T. 
EndIf 
 
Return lRet

//-----------------------------------------------------------------------
/*/{Protheus.doc} Fis022viewAIDF
visualização e manutenção da tabela de AIDF

@author Renato Nagib
@since 17.01.2014
@version 1.0 

@param 	

@Return nil
				

/*/
//-----------------------------------------------------------------------
Function Fis022viewAIDF( )

Local oBrow 
Local cPict  := ""   
local cFile := "C0P"
local cCombo := ""
local cChave := space(tamSX3("C0P_FILIAL")[1] + tamSX3("C0P_RPS")[1])
Local i    
Local aTables


DEFINE MSDIALOG oDlg FROM 0,0 TO 456,900 PIXEL

oBrow := TCBrowse():New(014,001,450,190,,,,oDlg,,,,{||},,,,,,,,.F.,cFile,.T.,,.F.,,)

oBrow := oBrow:GetBrowse()

aStruBkp := (cFile)->(dbStruct())
SX3->(dbSetOrder(2))
For i:= 1 to Len(aStruBkp)
	SX3->(dbSeek(aStruBkp[i][1]))
	
	//If aStruBkp[i][1] <> "C0P_AUT"
		cPict := ""
		If aStruBkp[i][2] == "N"
			cPict  := Replicate("9",aStruBkp[i][3])
			If aStruBkp[i][4] >0
				cPict := Left(cPict,aStruBkp[i][3]-aStruBkp[i][4]) + "." + Right(cPict,aStruBkp[i][4])
			EndIf
		EndIf
		oBrow:AddColumn(TCColumn():New( X3Titulo(), &("{ || "+cFile+"->"+aStruBkp[i][1]+"}"),cPict ,,, , , .F., .F.,,,, .F.,))
	/*	
	Else
		oBrow:AddColumn(TCColumn():New( X3Titulo(), { || if((cFile)->&(aStruBkp[i][1])$ "TS", "Emitido","Disponivel")}, ,,, , , .F., .F.,,,, .F.,))
	EndIf*/
Next
i:=1

oBrow:lColDrag   := .T.
oBrow:lLineDrag  := .T.
oBrow:lJustific  := .T.
oBrow:nfreeze    := 1
//oBrow:blDblClick := {||SduEdit(.F.)}
oBrow:nColPos    := 1

oBrow:Refresh()
//SduShowMsg(oTabs:nOption) 

@ 002,001 COMBOBOX oCombo VAR cCombo ITEMS {"Filial+Rps"} SIZE 080,010 OF oDlg PIXEL //"Formato Apache(.pem)"###"Formato PFX(.pfx ou .p12)"###"HSM"
@ 002,084 MSGET oChave VAR cChave SIZE 100,008 OF oDlg PIXEL 
@ 002,184 BITMAP RESNAME "PARAMETROS" OF oDlg SIZE 024,018 NOBORDER  PIXEL
oBtPesquisar := TButton():New( 002, 198, "Pesquisar",oDlg,{|| (lContinua := .T.,C0P->(dbSeek(cChave)))},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
oBtImportar := TButton():New( 210, 309, "Importar",oDlg,{|| (lContinua := .T.,Fis022ImpAidf())},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
oBtExcluir := TButton():New( 210, 356, "Excluir",oDlg,{|| (lContinua := .T.,Fis022DelImpAidf())},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
oBtSair := TButton():New( 210, 403, "Sair",oDlg,{|| (lContinua := .T.,oDlg:End())},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
ACTIVATE MSDIALOG oDlg CENTERED

Return nil

//-------------------------------------------------------------------
/*/{Protheus.doc} MunUsaUrl
Funcao que verifica se o municipio retorna a URL da NFs-e.

@param		cCodmun	Código do Municipio.
						
@Return 	lUsaUrl	.T. quando municipio utilizar URL.

@author	Rafael Iauquinto
@since		23/05/2014
@version	12
/*/
//-------------------------------------------------------------------
function MunUsaUrl( cCodmun )

local lUsaUrl := .F.

if GetMunSiaf(cCodMun)[1][2] $ "012"
	lUsaUrl	:= .T.
endif

return lUsaUrl

//-------------------------------------------------------------------
/*/{Protheus.doc} Fis22UrlNfse
Funcao que verifica se o municipio retorna a URL da NFs-e.

@param		cCodmun	Código do Municipio.
						
@Return 	lUsaUrl	.T. quando municipio utilizar URL.

@author	Rafael Iauquinto
@since		23/05/2014
@version	12
/*/
//-------------------------------------------------------------------
Function Fis22UrlNfse( cAlias )

local cSerie
local cIdInicial
local cIdFinal
local nTipoMonitor := 2
local aMonitor	:= {}

If cAlias == "SF2"  
	cSerie 	:= SF2->F2_SERIE
	cIdInicial	:= SF2->F2_DOC
	cIdFinal 	:= SF2->F2_DOC		
ElseIf cAlias == "SF1"
	cSerie 	:= SF1->F1_SERIE
	cIdInicial	:= SF1->F1_DOC
	cIdFinal 	:= SF1->F2_DOC  
EndIf

Processa( {|| aMonitor 	:= FisMonitorX( cIdEnt, cSerie, cIdInicial, cIdFinal, /*cCNPJIni*/, /*cCNPJFim*/, /*nTipoMonitor*/, /* dDataDe */, /* dDataAte */, /* cHoraDe */, /* cHoraAte */, /* nTempo */, /* nDiasParaExclusao */, /* cIdNotas */, "" )}, "Aguarde...","(1/2) Buscando URL...", .T. )

if Len( aMonitor[3] ) > 0 .And. !Empty( aMonitor[3][1][10] )
	ShellExecute( "Open", Alltrim( aMonitor[3][1][10] ), "", "", 1 )	
else
	MsgAlert("URL para o documento não foi encontrada, verifique se o documento está autorizado!")
endif


Return Nil