#include "TOTVS.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*----------------------+--------------------------------+------------------+
|   Programa: FIFINW01  | Autor: Kley@TOTVS              | Data: 18/10/2013 |
+-----------------------+--------------------------------+------------------+
|  Descricao:  Workflow de Aprovação da Requisição de Numerário
+---------------------------------------------------------------------------+
|    Projeto:  FIESP
+---------------------------------------------------------------------------+
| Parâmetros:  aParam = Array com 2 elementos: aParam[1] - Empresa / aParam[2] - Filial
+----------------------------------------------------------------------------
|    Exemplo:  FIFINW01("01","01SP0001")
+----------------------------------------------------------------------------
|    Retorno:  Nulo                                                               
+--------------------------------------------------------------------------*/

User Function FIFINW01(aParam)

Local lIniciaEmp := .F.
Local cFunc      := "U_FIFINW01"
Local cRN        := Nil
Local cCodEmp    := ""
Local cCodFil    := ""
Local lContinua  := .F.
Local nW

If ValType(aParam) == "A" .and. Len(aParam) >= 2
	If ValType(aParam[1]) =="C" .and. ValType(aParam[2]) =="C"
		cCodEmp   := aParam[1]
		cCodFil   := aParam[2] 
		ConOut("["+DtoC(Date())+" "+Time()+"] ["+cFunc+"] Parametros Recebidos => Empresa/Filial: "+cCodEmp+"/"+cCodFil)
		lContinua := .T.	
	Else
		lContinua := .F.	
	EndIf
Else
		lContinua := .F.
EndIf

If lContinua
	ConOut("["+DtoC(Date())+" "+Time()+"] ["+cFunc+"] Inicializacao do ambiente - Workflow RN Empresa/Filial: "+cCodEmp+"/"+cCodFil)
	WfPrepEnv(cCodEmp,cCodFil)

	WFSendRN(cCodFil,cRN) // Processa a rotina para Envio do Workflow de Aprovacao do RN

	Reset Environment 
	ConOut("["+DtoC(Date())+" "+Time()+"] ["+cFunc+"] Finalizacao do ambiente - Workflow RN Empresa/Filial: "+cCodEmp+"/"+cCodFil)
Else
	ConOut("["+DtoC(Date())+" "+Time()+"] ["+cFunc+"] ERRO no recebimento dos Paramentros (Empresa/Filial)!!")
	ConOut("["+DtoC(Date())+" "+Time()+"] ["+cFunc+"]     Tipo esperado: A |    Tipo Recebido: " + ValType(aParam))
	ConOut("["+DtoC(Date())+" "+Time()+"] ["+cFunc+"]  Tamanho esperado: 2 | Tamanho Recebido: " + LTrim(Str(Len(aParam))))
	If ValType(aParam) == "A"
		For nW := 1 to Len(aParam)
			ConOut("["+DtoC(Date())+" "+Time()+"] ["+cFunc+"]  Param["+LTrim(Str(nW))+"] -     Tipo Recebido: " + ValType(aParam[nW]))
			ConOut("["+DtoC(Date())+" "+Time()+"] ["+cFunc+"]  Param["+LTrim(Str(nW))+"] -  Tamanho Recebido: " + LTrim(Str(Len(aParam[nW]))))	
			If ValType(aParam[nW]) ==  "C"
				ConOut("["+DtoC(Date())+" "+Time()+"] ["+cFunc+"]  Param["+LTrim(Str(nW))+"] - Conteudo Recebido: " + aParam[nW])
			EndIf
		Next nW
	EndIf
EndIf

Return

/*----------------------+--------------------------------+------------------+
|   Programa: WFSendRN  | Autor: Kley@TOTVS              | Data: 18/10/2013 |
+-----------------------+--------------------------------+------------------+
|  Descricao:  Envio da Requisição de Numerário para Aprovação
+---------------------------------------------------------------------------+
|    Projeto:  FIESP
+--------------------------------------------------------------------------*/

Static Function WFSendRN(cCodFil,cRN)

Local cWfDir     := Iif(RTrim(Right(GetNewPar("MV_WFDIR"),1))=="\",GetNewPar("MV_WFDIR"),GetNewPar("MV_WFDIR")+"\")
Local cHtmlModel := ""
Local cFunc      := "WFSendRN"
Local cWFHTTP    := Iif(Right(RTrim(GetNewPar("MV_WFDHTTP")),1)=="/",GetNewPar("MV_WFDHTTP"),GetNewPar("MV_WFDHTTP")+"/")
Local aDirHtml   := {}
Local cDirHtml   := "html\"
Local cDirPasta  := "aprovrn\"
Local cDescProd  := ""
Local cAlias     := GetNextAlias()
Local cQuery     := ""

Local i

Private oHTML
Private cItem,cCod,cDesc,cUM,nQtde,nUprc,nTot,nToler,cUComp,dEnt,cCC,cCCDesc
Private lProcesso := .f.

If Select(cAlias) > 0
	(cAlias)->(dbCloseArea())
Endif

// Se cRN for nulo é executado pelo Scheduler, caso contrario é executado pelo retorno de Aprovação
If cRN == Nil	// primeiro nivel executado pelo Scheduler Protheus nao passa Num. do RN
	BeginSQL Alias cAlias
		select
			ZL_FILIAL,  ZL_NUM,     ZL_USER,  ZL_SOLICIT, ZL_CC,      ZL_DESC, ZL_DTSOL, 
			ZL_FORNECE, ZL_LOJA,    ZL_NOME,  ZL_VALOR,   ZL_EXTENSO, ZL_OBS,  ZL_ITEMCTB, 
			ZL_CONTAB,  ZL_NATUREZ, ZL_APROV, ZL_STATUS,  ZL_WFENV, ZL_DTSOL
		from %Table:SZL% SZL
		where SZL.%NotDel%  and ZL_FILIAL = %xFilial:SZL%
		  and ZL_WFENV       = ' ' and ZL_STATUS = '2'
		order by ZL_FILIAL,  ZL_NUM
	EndSQL
Else			// proximos niveis executados via retorno
	BeginSQL Alias cAlias
		select
			ZL_FILIAL,  ZL_NUM,     ZL_USER,  ZL_SOLICIT, ZL_CC,      ZL_DESC, ZL_DTSOL, 
			ZL_FORNECE, ZL_LOJA,    ZL_NOME,  ZL_VALOR,   ZL_EXTENSO, ZL_OBS,  ZL_ITEMCTB, 
			ZL_CONTAB,  ZL_NATUREZ, ZL_APROV, ZL_STATUS,  ZL_WFENV, ZL_DTSOL
		from %Table:SZL% SZL
		where SZL.%NotDel%  and ZL_FILIAL = %xFilial:SZL%
		  and ZL_WFENV       = ' ' and ZL_STATUS = '2'           and ZL_NUM =%Exp:cRN% 
		order by ZL_FILIAL,  ZL_NUM
	EndSQL
EndIf

dbSelectArea(cAlias)                                                                                                	

While (cAlias)->(!Eof())
	
	lProcesso := .t.
	
	SCR->(dbSetOrder(1))
	SCR->(dbSeek(xFilial("SCR")+"RN"+(cAlias)->ZL_NUM))
	
	_aLogApr  := {}
	
	While SCR->(!Eof()) .and. SCR->CR_FILIAL == xFilial("SCR") .and. Alltrim(SCR->CR_NUM) == Alltrim((cAlias)->ZL_NUM) .and. SCR->CR_TIPO == "RN"
		
		_cSituaca := ""
		IF SCR->CR_STATUS == "01"
			_cSituaca := OemToAnsi("Aguardando")
		ELSEIF SCR->CR_STATUS == "02"
			_cSituaca := OemToAnsi("Em Aprovacao")
		ELSEIF SCR->CR_STATUS == "03"
			_cSituaca := OemToAnsi("Requis.Numerário Aprovado")
		ELSEIF SCR->CR_STATUS == "04"
			_cSituaca := OemToAnsi("Requis.Numerário Bloqueado")
		ELSEIF SCR->CR_STATUS == "05"
			_cSituaca := OemToAnsi("Nivel Liberado ")
		ENDIF
		
		Aadd(_aLogApr,{SCR->CR_NIVEL,UsrRetname(SCR->CR_USER),_cSituaca,Dtoc(SCR->CR_DATALIB),SCR->CR_OBS})
		
		SCR->(dbSkip())
	Enddo
	
	SCR->(DbGoTop())
	SCR->(dbSetOrder(1))
	SCR->(dbSeek(xFilial("SCR")+"RN"+(cAlias)->ZL_NUM))
	
	While SCR->(!Eof()) .and. SCR->CR_FILIAL == xFilial("SCR") .and. Alltrim(SCR->CR_NUM) == Alltrim((cAlias)->ZL_NUM) .and. SCR->CR_TIPO == "RN"
		
		IF SCR->CR_STATUS <> "02" // nivel 02 indica proxima que recebe e-mail
			SCR->(dbSkip())
			Loop
		ENDIF
		
		SZL->(dbSetOrder(1))
		SZL->(dbSeek(xFilial("SZL")+Alltrim((cAlias)->ZL_NUM)))
		
		SA2->(dbSetOrder(1))
		SA2->(dbSeek(xFilial("SA2")+SZL->(ZL_FORNECE+ZL_LOJA)))
		
		ConOut("["+DtoC(Date())+" "+Time()+"] ["+cFunc+"] Processando RN Filial/No.: "+SZL->ZL_FILIAL+"/"+SZL->ZL_NUM)
		//Abre o HTML
		oProcess := TWFProcess():New( "REQNUMER", "Requisição de Numerário" )
		oProcess:NewTask( "000201", cWfDir+"AprovacaoRN.htm" )
		oProcess:cSubject := "Aprovação do Requisição de Numerário Nr. " +(cAlias)->ZL_NUM
		oProcess:bReturn  := "U_WFReturRN()"
		oProcess:UserSiga := SZL->ZL_USER
		oProcess:NewVersion(.T.)
		oHTML   := oProcess:oHTML
		
		oHtml:ValByName( "FILIAL"     , SZL->ZL_FILIAL )
		oHtml:ValByName( "NUMRN"      , SZL->ZL_NUM )
		oHtml:ValByName( "SOLICITANTE", UsrRetname(SZL->ZL_USER) + " - " + retDesc("SOLICIT", UsrRetname(SZL->ZL_USER)) )
		oHtml:ValByName( "ZL_CC"      , SZL->ZL_CC )
		oHtml:ValByName( "ZL_DESC"    , SZL->ZL_DESC )
		oHtml:ValByName( "ZL_DTEMIS"  , DtoC(SZL->ZL_DTSOL) )
		oHtml:ValByName( "ZL_DESC"    , SZL->ZL_DESC )
		oHtml:ValByName( "ZL_FILIAL"  , SZL->ZL_FILIAL + " - " + retDesc("FILIAL", SZL->ZL_FILIAL) )
		oHtml:ValByName( "ZL_NOME"    , SZL->ZL_NOME )
		oHtml:ValByName( "ZL_FORNECE" , SZL->ZL_FORNECE )
		oHtml:ValByName( "ZL_LOJA"    , SZL->ZL_LOJA )
		oHtml:ValByName( "ZL_VALOR"   , LTrim(Str(SZL->ZL_VALOR)) )
		oHtml:ValByName( "ZL_EXTENSO" , SZL->ZL_EXTENSO )
		oHtml:ValByName( "ZL_OBS"     , SZL->ZL_OBS )
		oHtml:ValByName( "ZL_ITEMCTB" , RTrim(SZL->ZL_ITEMCTB) + " - " + Posicione("CTD",1,xFilial("CTD")+SZL->ZL_ITEMCTB,"CTD_DESC01") )
		oHtml:ValByName( "ZL_CONTAB"  , RTrim(SZL->ZL_CONTAB) + " - " + Posicione("CT1",1,xFilial("CT1")+SZL->ZL_CONTAB,"CT1_DESC01") )
		oHtml:ValByName( "ZL_NATUREZ" , RTrim(SZL->ZL_NATUREZ) + " - " + Posicione("SED",1,xFilial("SED")+SZL->ZL_NATUREZ,"ED_DESCRIC") )
		oHtml:ValByName( "CAPROV"     , SCR->CR_USER )

		For i := 1 to Len(_aLogApr)
			AAdd( (oHtml:ValByName( "proc.nivel"   )),_aLogApr[i,1] )
			AAdd( (oHtml:ValByName( "proc.cApov"   )),_aLogApr[i,2] )
			AAdd( (oHtml:ValByName( "proc.cSit"    )),_aLogApr[i,3] )
			AAdd( (oHtml:ValByName( "proc.dDtLib"  )),_aLogApr[i,4] )
			AAdd( (oHtml:ValByName( "proc.cObs"    )),_aLogApr[i,5] )
		Next
		
		oProcess:cTo := Nil
		
		// Verifica e cria, se necessario, o diretorio para gravacao do HTML
		aDirHtml   := Directory(cWfDir+"emp"+cEmpAnt+"\*.*", "D",Nil,.T.)		
		If aScan( aDirHtml, {|aDir| aDir[1] == Upper( Iif(Right(cDirHtml,1)=="\", Left(cDirHtml,Len(cDirHtml)-1), cDirHtml) ) } ) == 0
			If MakeDir(cWfDir+"emp"+cEmpAnt+"\"+cDirHtml)	 == 0
				ConOut("["+DtoC(Date())+" "+Time()+"] ["+cFunc+"] Diretorio dos HTML's criado com sucesso. -> "+cWfDir+"emp"+cEmpAnt+"\"+cDirHtml )		
			Else
				ConOut("["+DtoC(Date())+" "+Time()+"] ["+cFunc+"] Erro na criacao do diretorio dos HTML's! -> "+cWfDir+"emp"+cEmpAnt+"\"+cDirHtml )
				cDirHtml := "temp\"
			EndIf
		EndIf
		
		// Verifica e cria, se necessario, a pasta especifica do Workflow para gravacao do HTML
		aDirHtml   := Directory(cWfDir+"emp"+cEmpAnt+"\"+cDirHtml+"*.*", "D",Nil,.T.)
		If aScan( aDirHtml, {|aDir| aDir[1] == Upper(Iif(Right(cDirPasta,1)=="\", Left(cDirPasta,Len(cDirPasta)-1), cDirPasta) ) } ) == 0
			If MakeDir(cWfDir+"emp"+cEmpAnt+"\"+cDirHtml+cDirPasta) == 0
				ConOut("["+DtoC(Date())+" "+Time()+"] ["+cFunc+"] Diretorio de Pasta dos HTML's criado com sucesso. -> "+cWfDir+"emp"+cEmpAnt+"\"+cDirHtml+cDirPasta )		
			Else
				ConOut("["+DtoC(Date())+" "+Time()+"] ["+cFunc+"] Erro na criacao do diretorio dos HTML's! -> "+cWfDir+"emp"+cEmpAnt+"\"+cDirHtml+cDirPasta )
				cDirPasta := ""
			EndIf
		EndIf
		
		cDirHtml2  := "emp"+cEmpAnt+"\" + cDirHtml + cDirPasta
		cMailID    := oProcess:Start(cWfDir+cDirHtml2,.T.)
		
		If File(cWfDir+cDirHtml2+cMailID+".htm")
			ConOut("["+DtoC(Date())+" "+Time()+"] ["+cFunc+"] Arquivo HTML copiado com sucesso: "+cWfDir+cDirHtml2+cMailID+".htm" )
		Else
			ConOut("["+DtoC(Date())+" "+Time()+"] ["+cFunc+"] ATENCAO! Arquivo HTML NAO copiado: "+cWfDir+cDirHtml2+cMailID+".htm")
		EndIf

		cHtmlModel := cWfDir+"LinkRN.htm"
		cAssunto   := "Requisição de Numerário Nr. " +(cAlias)->ZL_NUM

		oProcess:NewTask(cAssunto, cHtmlModel)
		ConOut("["+DtoC(Date())+" "+Time()+"] ["+cFunc+"] (INICIO|WFLINK)Processo: " + oProcess:fProcessID + " / Task: " + oProcess:fTaskID )
		oProcess:cSubject := cAssunto
		oProcess:cTo := Alltrim(UsrRetMail( SCR->CR_USER ))
		
		oProcess:ohtml:ValByName("CAPROVADOR",UsrRetname(SCR->CR_USER))
		oProcess:ohtml:ValByName("CNUMRN",(cAlias)->ZL_NUM)
		
		oProcess:ohtml:ValByName("proc_link",StrTran(cWFHTTP+cDirHtml2+cMailID+".htm","\","/"))
		oProcess:Start()
		
		SCR->(dbSkip())
	Enddo

	If !lProcesso
		ConOut("["+DtoC(Date())+" "+Time()+"] ["+cFunc+"] Nao Houve Processamento (Envio)")
	Else
		ConOut("["+DtoC(Date())+" "+Time()+"] ["+cFunc+"] Processamento (Envio) finalizado")
		ConOut(cCodFil)
		ConOut((cAlias)->(ZL_NUM))
		cQuery := "update "+ RetSqlName("SZL")+" set ZL_WFENV = 'T' "
		cQuery += "where D_E_L_E_T_ = ' ' and ZL_FILIAL = '"+cCodFil+"' "
  		cQuery += "and ZL_WFENV       = ' ' and ZL_NUM    = '"+(cAlias)->(ZL_NUM)+"' "
  		ConOut(cQuery)
		TcSQLExec(cQuery)
	EndIf

	(cAlias)->(dbSkip())
Enddo

(cAlias)->(dbCloseArea())

Return

/*----------------------+--------------------------------+------------------+
|   Programa: WFReturRN | Autor: Kley@TOTVS              | Data: 18/10/2013 |
+-----------------------+--------------------------------+------------------+
|  Descricao:  Processa o Retorno da Aprovação da Requisição de Numerário
+---------------------------------------------------------------------------+
|    Projeto:  FIESP
+--------------------------------------------------------------------------*/

User Function WFReturRN(oProcess)

Local cCodFil := Alltrim(oProcess:oHtml:RetByName("FILIAL"))
Local cNumRN  := alltrim(oProcess:oHtml:RetByName("NUMRN"))
Local cObs    := alltrim(oProcess:oHtml:RetByName("OBS"))
Local cAprov  := alltrim(oProcess:oHtml:RetByName("CAPROV"))
Local cOpc	  := alltrim(oProcess:oHtml:RetByName("OPC"))

cCodFil  := Iif(Empty(cCodFil),xFilial("SZL"),cCodFil)


oProcess:Finish() // FINALIZA O PROCESSO
lLiberou := .f.

SZL->(dbSetOrder(1))
SZL->(dbSeek(cCodFil+cNumRN))

SCR->(dbSetOrder(2))
IF SCR->(dbSeek(xFilial("SCR")+"RN"+cNumRN+Space(TamSx3("CR_NUM")[1]-Len(cNumRN))+cAprov))
	lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,SCR->CR_TOTAL,SCR->CR_APROV,,cAprov,,,,,cObs},dDataBase,IIF(cOpc == "APROVAR",4,6))
ELSE
	ConOut('Alcada nao encontrada!!!')
ENDIF

IF cOpc == "APROVAR"
	WFVerifRN(cCodFil,cNumRN,cObs,,cAprov)
ELSE
	SZL->(dbSetOrder(1))
	SZL->(dbSeek(cCodFil+cNumRN))
	
	_cEMail := Alltrim(UsrRetMail( SZL->ZL_USER ))
	_cBody  := "Prezado(a) Solicitante,"+ " - " + retDesc("SOLICIT", UsrRetname(SZL->ZL_USER)) + Chr(13)+Chr(10)+Chr(13)+Chr(10)
	_cBody  += "Informamos que sua Requisição de Numerário Nr. "+cNumRN+" - " + SZL->ZL_FILIAL + " foi reprovada."
	_cBody  += Chr(13)+Chr(10)+Chr(13)+Chr(10)
	_cBody  += "Obs: "+cObs
	ACSendMail( ,,,,_cEMail,"RN "+cNumRN+" REPROVADO",_cBody)
	
	While SZL->(!Eof()) .and. SZL->(ZL_FILIAL+ZL_NUM) == cCodFil+cNumRN
		RecLock("SZL",.F.)
		SZL->ZL_STATUS := "4"
		SZL->(msUnlock())
		          
		aArea := SZL->(GetArea())
		RestArea(aArea)
		
		SZL->(dbSkip())
	EndDo

ENDIF

Return()

/*----------------------+--------------------------------+------------------+
|   Programa: WFVerifRN | Autor: Kley@TOTVS              | Data: 18/10/2013 |
+-----------------------+--------------------------------+------------------+
|  Descricao:  Verifica a Liberação da Requisição de Numerário
+---------------------------------------------------------------------------+
|    Projeto:  FIESP
+--------------------------------------------------------------------------*/

Static Function WFVerifRN(cCodFil,cNumRN,cObs,_cNiv,cAprov)
Local cQuery   := ""
Local _cArqSCR := CriaTrab(nil,.f.)
Local _cNome   := "" 
Local aArea    := {}

Default cAprov := ""

_cNome := UsrRetName(cAprov)

// verifica se o Requis.Numer. foi totalmente liberada
cQuery := "SELECT * FROM "+RetSqlName("SCR")+" "
cQuery += "WHERE D_E_L_E_T_ = ' ' AND CR_FILIAL = '"+xFilial("SCR")+"' AND CR_NUM = '"+cNumRN+"' AND CR_STATUS NOT IN ('03','05') AND CR_TIPO = 'RN' "
cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),_cArqSCR,.t.,.t.)

IF (_cArqSCR)->(Eof())
	
	SZL->(dbSetOrder(1))
	SZL->(dbSeek(cCodFil+cNumRN))
	
	// envia email ao solicitante
	_cEMail := Alltrim(UsrRetMail( SZL->ZL_USER ))
	_cBody  := "Prezado(a) "+UsrRetName(SZL->ZL_USER)+ " - " + retDesc("SOLICIT", UsrRetname(SZL->ZL_USER)) + Chr(13)+Chr(10)+Chr(13)+Chr(10)
	_cBody  += "Informamos que sua Requisição de Numerário Nr. "+cNumRN+" - " + SZL->ZL_FILIAL + " foi aprovada."
	_cBody  += Chr(13)+Chr(10)+Chr(13)+Chr(10)
	_cBody  += "Obs: "+cObs
	ACSendMail( ,,,,_cEMail,"RN "+cNumRN+" APROVADO",_cBody)
	
	While SZL->(!Eof()) .and. SZL->(ZL_FILIAL+ZL_NUM) == cCodFil+cNumRN
		RecLock("SZL",.F.)
		SZL->ZL_STATUS := "3"
		SZL->(msUnlock())
		          
		aArea := SZL->(GetArea())
		RestArea(aArea)
		
		SZL->(dbSkip())
	EndDo
ELSE
	WFSendRN(cCodFil,cNumRN) // envia e-mail para o proximo aprovador
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