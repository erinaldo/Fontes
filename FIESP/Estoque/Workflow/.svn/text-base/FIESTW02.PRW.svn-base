#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FIESTW02 ºAutor  ³ TOTVS              º Data ³ 12/09/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ WORKFLOW de Solicita ao Armazem atraves do SCHEDULER       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FIESTW02(aParam)

Local lIniciaEmp := .F.
Local cFuncName  := "FIESTW02"
Local _cSA       := Nil
Local cCodEmp    := ""
Local cCodFil    := ""
Local lContinua  := .F.
Local nW

aParam := {}
aadd(aParam,"99")
aadd(aParam,"01")

If ValType(aParam) == "A" .and. Len(aParam) >= 2
	If ValType(aParam[1]) =="C" .and. ValType(aParam[2]) =="C"
		cCodEmp   := aParam[1]
		cCodFil   := aParam[2] 
		ConOut(cFuncName+":: Parametros Recebidos => Empresa/Filial: "+cCodEmp+"/"+cCodFil)
		lContinua := .T.	
	Else
		lContinua := .F.	
	EndIf
Else
		lContinua := .F.
EndIf

If lContinua
	ConOut(cFuncName+":: Inicializacao do ambiente - Workflow SA Empresa/Filial: "+cCodEmp+"/"+cCodFil)
	WfPrepEnv(cCodEmp,cCodFil)

	_WFSendSA(cCodFil,_cSA) // Processa a rotina para Envio do Workflow de Aprovacao do SA

	//Reset Environment 
	ConOut(cFuncName+":: Finalizacao do ambiente - Workflow SA Empresa/Filial: "+cCodEmp+"/"+cCodFil)
Else
	ConOut(cFuncName+":: ERRO no recebimento dos Paramentros (Empresa/Filial)!!")
	ConOut(cFuncName+"::     Tipo esperado: A |    Tipo Recebido: " + ValType(aParam))
	ConOut(cFuncName+"::  Tamanho esperado: 2 | Tamanho Recebido: " + LTrim(Str(Len(aParam))))
	If ValType(aParam) == "A"
		For nW := 1 to Len(aParam)
			ConOut(cFuncName+"::  Param["+LTrim(Str(nW))+"] -     Tipo Recebido: " + ValType(aParam[nW]))
			ConOut(cFuncName+"::  Param["+LTrim(Str(nW))+"] -  Tamanho Recebido: " + LTrim(Str(Len(aParam[nW]))))	
			If ValType(aParam[nW]) ==  "C"
				ConOut(cFuncName+"::  Param["+LTrim(Str(nW))+"] - Conteudo Recebido: " + aParam[nW])
			EndIf
		Next nW
	EndIf
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³_WFSendSA º Autor ³ Microsiga          º Data ³ 18/11/10    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Envio de Solicita ao Armazem para aprovacao                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _WFSendSA(_cFil,_cSA)

Local _cQrySCP   := ""
Local _nTotal    := 0
Local _nTotICM   := 0
Local _nTotIPI   := 0
Local _nTotFRE   := 0
Local _nTotDSP   := 0
Local _nTotSEG   := 0
Local _cWfDir    := Iif ( Right(RTrim(GetNewPar("MV_WFDIRWF","workflow\")),1)=="\",;
                          GetNewPar("MV_WFDIRWF","workflow\"),;
                          GetNewPar("MV_WFDIRWF","workflow\") + "\" )
Local cHtmlModel := ""
Local cFuncName  := "_WFSendSA"
Local cWFHTTP    := Iif ( Right(RTrim(GetNewPar("MV_XWFHTTP","http://localhost:8081/workflow/")),1)=="/",;
                          GetNewPar("MV_XWFHTTP","http://localhost:8081/workflow/"),;
                          GetNewPar("MV_XWFHTTP","http://localhost:8081/workflow/") + "/" )
Local aDirHtml   := {}
Local cDirHtml   := "html\"
Local cDirPasta  := "aprovsa\"
Local cDescProd := ""

Local i

Private oHTML
Private cItem,cCod,cDesc,cUM,nQtde,nUprc,nTot,nToler,cUComp,dEnt,cCC,cCCDesc
Private lProcesso := .f.

If Select("TSCP") > 0
	TSCP->(dbCloseArea())
Endif

_cQrySCP:= " SELECT DISTINCT CP_FILIAL,CP_NUM "
_cQrySCP+= " FROM "+RetSqlName("SCP")+" "
_cQrySCP+= " WHERE CP_FILIAL = '"+XFILIAL("SCP")+"' "
// condicao para identificar se trata-se de envio para primeiro ou proximo nivel
If _cSA == Nil	// primeiro nivel executado pelo Scheduler Protheus nao passa Num. do SA
	_cQrySCP+= " AND CP_XWFE    = 'F' " //campo caracter criado para nao trazer o solicitacao ao armazem mais de um vez no Scheduler
	_cQrySCP+= " AND CP_FILIAL = '"+_cFil+"' "
Else			// proximos niveis executados via retorno
	_cQrySCP+= " AND CP_FILIAL = '"+_cFil+"' AND CP_NUM = '"+_cSA+"' "
EndIf

_cQrySCP+= " AND D_E_L_E_T_ = ' ' AND CP_STATSA = 'E' "
_cQrySCP+= " ORDER BY CP_NUM "
TCQUERY _cQrySCP NEW ALIAS "TSCP"

TSCP->(dbGoTop())

While TSCP->(!Eof())
	
	lProcesso := .t.
	
	SCR->(dbSetOrder(1))
	SCR->(dbSeek(XFilial("SCR")+"SA"+TSCP->CP_NUM))
	
	_aLogApr  := {}
	
	While SCR->(!Eof()) .and. SCR->CR_FILIAL == XFilial("SCR") .and. Alltrim(SCR->CR_NUM) == Alltrim(TSCP->CP_NUM) .and. SCR->CR_TIPO == "SA"
		
		_cSituaca := ""
		IF SCR->CR_STATUS == "01"
			_cSituaca := OemToAnsi("Aguardando")
		ELSEIF SCR->CR_STATUS == "02"
			_cSituaca := OemToAnsi("Em Aprovacao")
		ELSEIF SCR->CR_STATUS == "03"
			_cSituaca := "Solicitacao Aprovado"
		ELSEIF SCR->CR_STATUS == "04"
			_cSituaca := "Solicitacao Bloqueado"
		ELSEIF SCR->CR_STATUS == "05"
			_cSituaca := OemToAnsi("Nivel Liberado ")
		ENDIF
		
		Aadd(_aLogApr,{SCR->CR_NIVEL,UsrRetname(SCR->CR_USER),_cSituaca,Dtoc(SCR->CR_DATALIB),SCR->CR_OBS})
		
		SCR->(dbSkip())
	Enddo
	
	SCR->(DbGoTop())
	SCR->(dbSetOrder(1))
	SCR->(dbSeek(XFilial("SCR")+"SA"+TSCP->CP_NUM))
	
	While SCR->(!Eof()) .and. SCR->CR_FILIAL == XFilial("SCR") .and. Alltrim(SCR->CR_NUM) == Alltrim(TSCP->CP_NUM) .and. SCR->CR_TIPO == "SA"
		
		IF SCR->CR_STATUS <> "02" // nivel 02 indica proxima que recebe e-mail
			SCR->(dbSkip())
			Loop
		ENDIF
		
		SCP->(dbSetOrder(1))
		SCP->(dbSeek(xFilial("SCP")+Alltrim(TSCP->CP_NUM)))
		
		ConOut(cFuncName+":: Processando SA Filial/No.: "+SCP->CP_FILIAL+"/"+SCP->CP_NUM)
		//Abre o HTML
		oProcess := TWFProcess():New( "ARMAZEM", "Solicitacao ao Armazem" )
		oProcess:NewTask( "000001", _cWfDir+"AprovacaoSA.htm" )
		oProcess:cSubject := "Aprovação da Solicitacao ao Armazem Nr. " +TSCP->CP_NUM
		oProcess:bReturn  := "U__fWFRetALM()"
		oProcess:UserSiga := SCP->CP_XUSER
		oProcess:NewVersion(.T.)
		oHTML   := oProcess:oHTML
		
		oProcess:oHtml:ValByName("CSOLICIT"		, SCP->CP_NUM )
		oProcess:oHtml:ValByName("FILIAL"		, SCP->CP_FILIAL )
		oProcess:oHtml:ValByName("DESCFIL"		, retDesc("FILIAL", SCP->CP_FILIAL) )
		oProcess:oHtml:ValByName("SOLICIT"		, SCP->CP_SOLICIT)
		oProcess:oHtml:ValByName("NOMSOLICIT"	, retDesc("SOLICIT", SCP->CP_SOLICIT))
		oProcess:oHtml:ValByName("CAPROV"		, SCR->CR_USER )
		oProcess:oHtml:ValByName("CC"           , SCP->CP_CC )
		oProcess:oHtml:ValByName("DESCCC"       , Posicione("CTT", 1, xFilial("CTT") + SCP->CP_CC, "CTT_DESC01") )
		oProcess:oHtml:ValByName("APROVADOR"	, UsrRetname(SCR->CR_USER) )
		oProcess:oHtml:ValByName("OBS" 			, "" )
		
		_nSubTot := 0
		_nFrete  := 0
		_nTotal  := 0
		
		While !SCP->(Eof()) .and. SCP->CP_FILIAL == XFilial("SCP") .and. SCP->CP_NUM == Alltrim(TSCP->CP_NUM)
			
			ConOut(cFuncName+":: Processando Item da SA Filial/No./Item: "+SCP->CP_FILIAL+"/"+SCP->CP_NUM+"/"+SCP->CP_ITEM)
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(XFilial("SB1")+SCP->CP_PRODUTO))
			
			cDescProd  := Posicione("SB5",1,xFilial("SB5")+SB1->B1_COD,"B5_CEME")
			DbSelectArea("SB1")
			
			AAdd(oProcess:oHtml:ValByName("prod.cItem")		, SCP->CP_ITEM)
			AAdd(oProcess:oHtml:ValByName("prod.cCod")		, SCP->CP_PRODUTO)
			AAdd(oProcess:oHtml:ValByName("prod.cDesc")		, Iif(Empty(cDescProd),SB1->B1_DESC,cDescProd) )
			AAdd(oProcess:oHtml:ValByName("prod.cUM")		, SB1->B1_UM)
			AAdd(oProcess:oHtml:ValByName("prod.nQuant")	, Transform(SCP->CP_QUANT,'@E 99,999,999.99'))
			AAdd(oProcess:oHtml:ValByName("prod.nVrUnit")	, Transform(SCP->CP_XVUNIT,'@E 999,999,999.99'))
			AAdd(oProcess:oHtml:ValByName("prod.nVrTotal")	, Transform(SCP->CP_XVLRTOT,'@E 999,999,999.99'))
			AAdd(oProcess:oHtml:ValByName("prod.dEntrega")	, SCP->CP_DATPRF)
			AAdd(oProcess:oHtml:ValByName("prod.cObs")		, SCP->CP_OBS)
			
			_nSubTot += SCP->CP_XVLRTOT
			_nTotal  += SCP->CP_XVLRTOT
			
			SCP->(DbSkip())
		Enddo
		
		oHtml:ValByName( "vlrtotal" , TRANSFORM( _nSubTot,'@E 999,999,999.99' ) )
		oHtml:ValByName( "vlrfrete" , TRANSFORM( _nFrete ,'@E 999,999,999.99' ) )
		oHtml:ValByName( "totgeral" , TRANSFORM( _nTotal ,'@E 999,999,999.99' ) )
		
		For i := 1 to Len(_aLogApr)
			AAdd( (oHtml:ValByName( "proc.nivel"   )),_aLogApr[i,1] )
			AAdd( (oHtml:ValByName( "proc.cApov"   )),_aLogApr[i,2] )
			AAdd( (oHtml:ValByName( "proc.cSit"    )),_aLogApr[i,3] )
			AAdd( (oHtml:ValByName( "proc.dDtLib"  )),_aLogApr[i,4] )
			AAdd( (oHtml:ValByName( "proc.cObs"    )),_aLogApr[i,5] )
		Next
		
		oProcess:cTo := Nil
		
		// Verifica e cria, se necessario, o diretorio para gravacao do HTML
		aDirHtml   := Directory(_cWfDir+"emp"+cEmpAnt+"\*.*", "D",Nil,.T.)		
		If aScan( aDirHtml, {|aDir| aDir[1] == Upper( Iif(Right(cDirHtml,1)=="\", Left(cDirHtml,Len(cDirHtml)-1), cDirHtml) ) } ) == 0
			If MakeDir(_cWfDir+"emp"+cEmpAnt+"\"+cDirHtml)	 == 0
				ConOut(cFuncName+":: Diretorio dos HTML's criado com sucesso. -> "+_cWfDir+"emp"+cEmpAnt+"\"+cDirHtml )		
			Else
				ConOut(cFuncName+":: Erro na criacao do diretorio dos HTML's! -> "+_cWfDir+"emp"+cEmpAnt+"\"+cDirHtml )
				cDirHtml := "temp\"
			EndIf
		EndIf
		
		// Verifica e cria, se necessario, a pasta especifica do Workflow para gravacao do HTML
		aDirHtml   := Directory(_cWfDir+"emp"+cEmpAnt+"\"+cDirHtml+"*.*", "D",Nil,.T.)
		If aScan( aDirHtml, {|aDir| aDir[1] == Upper(Iif(Right(cDirPasta,1)=="\", Left(cDirPasta,Len(cDirPasta)-1), cDirPasta) ) } ) == 0
			If MakeDir(_cWfDir+"emp"+cEmpAnt+"\"+cDirHtml+cDirPasta) == 0
				ConOut(cFuncName+":: Diretorio de Pasta dos HTML's criado com sucesso. -> "+_cWfDir+"emp"+cEmpAnt+"\"+cDirHtml+cDirPasta )		
			Else
				ConOut(cFuncName+":: Erro na criacao do diretorio dos HTML's! -> "+_cWfDir+"emp"+cEmpAnt+"\"+cDirHtml+cDirPasta )
				cDirPasta := ""
			EndIf
		EndIf
		
		cDirHtml2  := "emp"+cEmpAnt+"\" + cDirHtml + cDirPasta
		cMailID    := oProcess:Start(_cWfDir+cDirHtml2,.T.)
		
		If File(_cWfDir+cDirHtml2+cMailID+".htm")
			ConOut(cFuncName+":: Arquivo HTML copiado com sucesso: "+_cWfDir+cDirHtml2+cMailID+".htm" )
		Else
			ConOut(cFuncName+":: ATENCAO! Arquivo HTML NAO copiado: "+_cWfDir+cDirHtml2+cMailID+".htm")
		EndIf

		cHtmlModel := _cWfDir+"LinkSA.htm"
		cAssunto   := "Solicitacao ao Armazem Nr. " +TSCP->CP_NUM

		oProcess:NewTask(cAssunto, cHtmlModel)
		ConOut(cFuncName+":: (INICIO|WFLINK)Processo: " + oProcess:fProcessID + " / Task: " + oProcess:fTaskID )
		oProcess:cSubject := cAssunto
		oProcess:cTo := Alltrim(UsrRetMail( SCR->CR_USER ))
		
		oProcess:ohtml:ValByName("CAPROVADOR",UsrRetname(SCR->CR_USER))
		oProcess:ohtml:ValByName("CSOLICIT",TSCP->CP_NUM)
		
		oProcess:ohtml:ValByName("proc_link",StrTran(cWFHTTP+cDirHtml2+cMailID+".htm","\","/"))
		oProcess:Start()
		
		SCR->(dbSkip())
	Enddo

	If !lProcesso
		ConOut(cFuncName+":: Nao Houve Processamento (Envio)")
	Else
		ConOut(cFuncName+":: Processamento (Envio) finalizado")
		_cQuery	:= "UPDATE "+ RetSqlName("SCP")+" SET CP_XWFE = 'T' "
		_cQuery += "WHERE D_E_L_E_T_ = '' "
		_cQuery += "AND CP_FILIAL = '"+_cFil+"' AND CP_NUM = '"+TSCP->(CP_NUM)+"' "
		_cQuery += "AND CP_XWFE = 'F' "
		TcSQLExec(_cQuery)
	EndIf

	TSCP->(dbSkip())

Enddo

TSCP->(dbCloseArea())


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³_fWFRetSA ºAutor  ³Microsiga           º Data ³  18/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorno da Solicitação                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function _fWFRetALM(oProcess)

_cFilial  := alltrim(oProcess:oHtml:RetByName("FILIAL"))
_cFilial  := IIF(Alltrim(_cFilial)=="",Xfilial("SCP"),_cFilial)
_cNumSA	  := alltrim(oProcess:oHtml:RetByName("CSOLICIT"))
_cObs     := alltrim(oProcess:oHtml:RetByName("OBS"))
_cAprov	  := alltrim(oProcess:oHtml:RetByName("CAPROV"))
cOpc	  := alltrim(oProcess:oHtml:RetByName("OPC"))

oProcess:Finish() // FINALIZA O PROCESSO
lLiberou := .f.

SCP->(dbSetOrder(1))
SCP->(dbSeek(_cFilial+_cNumSA))

SCR->(dbSetOrder(2))
IF SCR->(dbSeek(XFilial("SCR")+"SA"+_cNumSA+Space(TamSx3("CR_NUM")[1]-Len(_cNumSA))+_cAprov))
	lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,SCR->CR_TOTAL,SCR->CR_APROV,,SCP->CP_XAPROV,,,,,_cObs},dDataBase,IIF(cOpc == "APROVAR",4,6))
ELSE
	ConOut('Alcada nao encontrada!!!')
	ConOut(XFilial("SCR")+"SA"+_cNumSA+Space(TamSx3("CR_NUM")[1]-Len(_cNumSA))+_cAprov)
ENDIF

IF cOpc == "APROVAR"
	_fVerifSA(_cFilial,_cNumSA,_cObs,,_cAprov)
ELSE
	SCP->(dbSetOrder(1))
	SCP->(dbSeek(_cFilial+_cNumSA))
	
	_cEMail := Alltrim(UsrRetMail( SCP->CP_XUSER ))
	_cBody  := "Prezado(a) Solicitante,"+ " - " + retDesc("SOLICIT", UsrRetname(SCP->CP_XUSER)) + Chr(13)+Chr(10)+Chr(13)+Chr(10)
	_cBody  += "Informamos que seu Solicitacao ao Armazem Nr. "+_cNumSA+" - " + SCP->CP_FILIAL + " foi reprovado."
	_cBody  += Chr(13)+Chr(10)+Chr(13)+Chr(10)
	_cBody  += "Obs: "+_cObs
	ACSendMail( ,,,,_cEMail,"SA "+_cNumSA+" REPROVADO",_cBody)
	
ENDIF

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³_fVerifSA ºAutor  ³Microsiga           º Data ³  18/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica liberação do Solicitacao                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _fVerifSA(_cFil,_cNumSA,_cObs,_cNiv,_cAprov)
Local _cQuery  := ""
Local _cArqSCR := CriaTrab(nil,.f.)
Local _cNome := "" 
Local aArea  := {}

Default _cAprov := ""

_cNome := UsrRetName(_cAprov)

// verifica se o solicitacao foi totalmente liberado
_cQuery := "SELECT * FROM "+RetSqlName("SCR")+" "
_cQuery += "WHERE D_E_L_E_T_ = ' ' AND CR_FILIAL = '"+XFilial("SCR")+"' AND CR_NUM = '"+_cNumSA+"' AND CR_STATUS NOT IN ('03','05') AND CR_TIPO = 'SA' "
_cQuery := ChangeQuery(_cQuery)

dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),_cArqSCR,.t.,.t.)

IF (_cArqSCR)->(Eof())
	
	SCP->(dbSetOrder(1))
	SCP->(dbSeek(_cFil+_cNumSA))
	
	// envia email ao solicitante
	_cEMail := Alltrim(UsrRetMail( SCP->CP_XUSER ))
	_cBody  := "Prezado(a) "+UsrRetName(SCP->CP_XUSER)+ " - " + retDesc("SOLICIT", UsrRetname(SCP->CP_XUSER)) + Chr(13)+Chr(10)+Chr(13)+Chr(10)
	_cBody  += "Informamos que seu Solicitacao ao Armazem Nr. "+_cNumSA+" - " + SCP->CP_FILIAL + " foi aprovado."
	_cBody  += Chr(13)+Chr(10)+Chr(13)+Chr(10)
	_cBody  += "Obs: "+_cObs
	ACSendMail( ,,,,_cEMail,"SA "+_cNumSA+" APROVADO",_cBody)
	
	While SCP->(!Eof()) .and. SCP->(CP_FILIAL+CP_NUM) == _cFil+_cNumSA
		RecLock("SCP",.F.)
		SCP->CP_STATSA	:= "L"
		SCP->(msUnlock())
		          
		aArea := SCP->(GetArea())
		RestArea(aArea)                        
		
		SCP->(dbSkip())
	EndDo
ELSE
	_WFSendSA(_cFil,_cNumSA) // envia e-mail para o proximo aprovador
ENDIF

Return

Static Function retDesc(cTipo, cCodigo)
  Local cDesc := ""
  Local aArea := {GetArea(), SM0->(GetArea())}
  Local nRecSM0 := SM0->(Recno())
  Local aUsuario := {}
  
  If (cTipo == "FILIAL")
    DbSelectArea("SM0")
    SM0->(DbGoTop())
    While (SM0->(!Eof()))
      If (AllTrim(cCodigo) == AllTrim(SM0->M0_CODFIL))
        cDesc := SM0->M0_NOME
      Endif
      
      SM0->(DbSkip())
    Enddo
    
    SM0->(DbGoTo(nRecSM0))
  Elseif (cTipo == "SOLICIT")
    PswOrder(2)
    If PswSeek(cCodigo)
	  aUsuario := PswRet()
	  cDesc := PswRet(1)[1][4]
    EndIf
  Endif
  
  aEval(aArea, {|x| RestArea(x)})
Return(cDesc)