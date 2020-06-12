#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FIGCTW01 ºAutor  ³ TOTVS              º Data ³ 12/09/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ WORKFLOW de Solic de Contratos atraves do SCHEDULER        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FIGCTW01(aParam)

Local lIniciaEmp := .F.
Local cFuncName  := "FIGCTW01"
Local _cGc       := Nil
Local cCodEmp    := ""
Local cCodFil    := ""
Local lContinua  := .F.
Local nW

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
	ConOut(cFuncName+":: Inicializacao do ambiente - Workflow GC Empresa/Filial: "+cCodEmp+"/"+cCodFil)
	WfPrepEnv(cCodEmp,cCodFil)

	_WFSendGC(cCodFil,_cGc)

	Reset Environment 
	ConOut(cFuncName+":: Finalizacao do ambiente - Workflow GC Empresa/Filial: "+cCodEmp+"/"+cCodFil)
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
±±ºPrograma  ³_WFSendGC º Autor ³ Microsiga          º Data ³ 18/11/10    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Envio de Pedido de Compras para aprovacao                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _WFSendGC(_cFil,_cGc)
Local _cQrySZ7   := ""
Local nI         := 0
Local _cQuery    := ""
Local _cWfDir    := Iif(RTrim(Right(GetNewPar("MV_WFDIR"),1))=="\",GetNewPar("MV_WFDIR"),GetNewPar("MV_WFDIR")+"\")
Local cHtmlModel := ""
Local cFuncName  := "_WFSendGC"
Local cWFHTTP    := Iif(Right(RTrim(GetNewPar("MV_WFDHTTP")),1)=="/",GetNewPar("MV_WFDHTTP"),GetNewPar("MV_WFDHTTP")+"/")
Local aDirHtml   := {}
Local cDirHtml   := "html\"
Local cDirPasta  := "aprovgc\"
Local cDescProd := ""

Local i

Private oHTML
Private lProcesso := .f.

If (Select("TSZ7") > 0)
	TSZ7->(DbCloseArea())
Endif

_cQrySZ7 := "SELECT" + CRLF
_cQrySZ7 += "DISTINCT" + CRLF
_cQrySZ7 += "Z7_FILIAL," + CRLF
_cQrySZ7 += "Z7_NUM" + CRLF
_cQrySZ7 += "FROM " + RetSQLName("SZ7") + "" + CRLF
_cQrySZ7 += "WHERE Z7_FILIAL = '" + xFilial("SZ7") + "'" + CRLF
If (_cGc == Nil)
	_cQrySZ7 += "AND Z7_WFE = '1'" + CRLF
Else
	_cQrySZ7 += "AND Z7_NUM = '" + AllTrim(_cGc) + "'" + CRLF
Endif
_cQrySZ7 += "AND D_E_L_E_T_ = ''" + CRLF
_cQrySZ7 += "ORDER BY Z7_NUM"

TcQuery _cQrySZ7 NEW ALIAS "TSZ7"

TSZ7->(DbGoTop())

While (TSZ7->(!Eof()))
	lProcesso := .T.
	
	SCR->(DbGoTop())
	SCR->(DbSetOrder(1))
	SCR->(DbSeek(xFilial("SCR") + "GC" + TSZ7->Z7_NUM))
	
	_aLogApr := {}
	
	While ((SCR->(!Eof())) .And. ;
			(SCR->CR_FILIAL == xFilial("SCR")) .And. ;
			(AllTrim(SCR->CR_NUM) == AllTrim(TSZ7->Z7_NUM)) .And. ;
			(SCR->CR_TIPO == "GC"))
		_cSituaca := ""
		
		If (SCR->CR_STATUS == "01")
			_cSituaca := OemToAnsi("Aguardando")
		Elseif (SCR->CR_STATUS == "02")
			_cSituaca := OemToAnsi("Em Aprovacao")
		Elseif (SCR->CR_STATUS == "03")
			_cSituaca := OemToAnsi("Pedido Aprovado")
		Elseif (SCR->CR_STATUS == "04")
			_cSituaca := OemToAnsi("Pedido Bloqueado")
		Elseif (SCR->CR_STATUS == "05")
			_cSituaca := OemToAnsi("Nivel Liberado")
		Endif
		
		aAdd(_aLogApr, {SCR->CR_NIVEL, UsrRetName(SCR->CR_USER), _cSituaca, DToC(SCR->CR_DATALIB), SCR->CR_OBS})
		
		SCR->(DbSkip())
	Enddo
	
	SCR->(DbGoTop())
	SCR->(DbSetOrder(1))
	SCR->(DbSeek(xFilial("SCR") + "GC" + TSZ7->Z7_NUM))
	
	While ((SCR->(!Eof())) .And. ;
			(SCR->CR_FILIAL == xFilial("SCR")) .And. ;
			(AllTrim(SCR->CR_NUM) == AllTrim(TSZ7->Z7_NUM)) .And. ;
			(SCR->CR_TIPO == "GC"))
		If (SCR->CR_STATUS <> "02")
			SCR->(DbSkip())
			Loop
		Endif
		
		SZ7->(DbSetOrder(1))
		SZ7->(DbSeek(xFilial("SZ7") + AllTrim(TSZ7->Z7_NUM)))
		
		SA2->(DbSetOrder(1))
		SA2->(DbSeek(xFilial("SA2") + SZ7->Z7_FORNECE + SZ7->Z7_LOJA))
		
		ConOut(cFuncName+":: Processando GC Filial/No.: "+SZ7->Z7_FILIAL+"/"+SZ7->Z7_NUM)
		
		oProcess := TWFProcess():New("CONTRATO", "Solicitacao de Contrato")
		oProcess:NewTask("000001", _cWfDir+"AprovacaoGC.htm")
		oProcess:cSubject := "Aprovação de Solicitação de Contrato Nr. " + TSZ7->Z7_NUM
		oProcess:bReturn := "U__fWFRetGC()"
		oProcess:UserSiga := SZ7->Z7_USUSOL
		oProcess:NewVersion(.T.)
		
		oHTML := oProcess:oHTML
		
		oHTML:ValByName("NUMGC", SZ7->Z7_NUM)
		oHTML:ValByName("FILIAL", SZ7->Z7_FILIAL)
		oHTML:ValByName("SOLICITANTE", UsrRetname(SZ7->Z7_USUSOL) + " - " + retDesc("SOLICIT", UsrRetname(SZ7->Z7_USUSOL)))
		oHTML:ValByName("Z7_DTSOL", DToC(SZ7->Z7_DTSOL))
		oHTML:ValByName("A2_NOME", SA2->A2_NOME)
		oHTML:ValByName("Z7_VLINI", AllTrim(Transform(SZ7->Z7_VLINI, PesqPict("SZ7", "Z7_VLINI"))))
		oHTML:ValByName("Z7_ITEMCTB", AllTrim(SZ7->Z7_ITEMCTB) + " - " + AllTrim(Posicione("CTD", 1, xFilial("CTD") + AllTrim(SZ7->Z7_ITEMCTB), "CTD_DESC01")))
		oHTML:ValByName("Z7_CLVL", AllTrim(SZ7->Z7_CLVL) + " - " + AllTrim(Posicione("CTH", 1, xFilial("CTH") + AllTrim(SZ7->Z7_CLVL), "CTH_DESC01")))
		oHTML:ValByName("Z7_CONTRAT", SZ7->Z7_CONTRAT)
		oHTML:ValByName("Z7_OBSPCO", SZ7->Z7_OBSPCO)
		oHTML:ValByName("Z7_CUSTO", AllTrim(SZ7->Z7_CUSTO) + " - " + AllTrim(Posicione("CTT", 1, xFilial("CTT") + AllTrim(SZ7->Z7_CUSTO), "CTT_DESC01")))
		oHTML:ValByName("Z7_FILIAL", SZ7->Z7_FILIAL)
		oHTML:ValByName("Z7_FORNECE", SZ7->Z7_FORNECE)
		oHTML:ValByName("Z7_LOJA", SZ7->Z7_LOJA)
		oHTML:ValByName("Z7_PAGTO", SZ7->Z7_PAGTO)
		oHTML:ValByName("Z7_CONTA", AllTrim(SZ7->Z7_CONTA) + " - " + AllTrim(Posicione("CT1", 1, xFilial("CT1") + AllTrim(SZ7->Z7_CONTA), "CT1_DESC01")))
		oHTML:ValByName("Z7_REVISAO", SZ7->Z7_REVISAO)
		
		For nI := 1 To Len(_aLogApr)
			AAdd( (oHtml:ValByName( "proc.nivel"   )),_aLogApr[nI,1] )
			AAdd( (oHtml:ValByName( "proc.cApov"   )),_aLogApr[nI,2] )
			AAdd( (oHtml:ValByName( "proc.cSit"    )),_aLogApr[nI,3] )
			AAdd( (oHtml:ValByName( "proc.dDtLib"  )),_aLogApr[nI,4] )
			AAdd( (oHtml:ValByName( "proc.cObs"    )),_aLogApr[nI,5] )
		Next

		oProcess:cTo := Nil

		aDirHtml   := Directory(_cWfDir+"emp"+cEmpAnt+"\*.*", "D",Nil,.T.)		
		If aScan( aDirHtml, {|aDir| aDir[1] == Upper( Iif(Right(cDirHtml,1)=="\", Left(cDirHtml,Len(cDirHtml)-1), cDirHtml) ) } ) == 0
			If MakeDir(_cWfDir+"emp"+cEmpAnt+"\"+cDirHtml)	 == 0
				ConOut(cFuncName+":: Diretorio dos HTML's criado com sucesso. -> "+_cWfDir+"emp"+cEmpAnt+"\"+cDirHtml )		
			Else
				ConOut(cFuncName+":: Erro na criacao do diretorio dos HTML's! -> "+_cWfDir+"emp"+cEmpAnt+"\"+cDirHtml )
				cDirHtml := "temp\"
			EndIf
		EndIf

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

		cHtmlModel := _cWfDir+"LinkGC.htm"
		cAssunto   := "Solicitação de Contrato Nr. " + TSZ7->Z7_NUM

		oProcess:NewTask(cAssunto, cHtmlModel)
		ConOut(cFuncName+":: (INICIO|WFLINK)Processo: " + oProcess:fProcessID + " / Task: " + oProcess:fTaskID )
		oProcess:cSubject := cAssunto
		oProcess:cTo := Alltrim(UsrRetMail( SCR->CR_USER ))
		
		oProcess:ohtml:ValByName("CAPROVADOR",UsrRetname(SCR->CR_USER))
		oProcess:ohtml:ValByName("CNUMGC",TSZ7->Z7_NUM)
		
		oProcess:ohtml:ValByName("proc_link",StrTran(cWFHTTP+cDirHtml2+cMailID+".htm","\","/"))
		oProcess:Start()
		
		SCR->(DbSkip())
	Enddo
	
	If !lProcesso
		ConOut(cFuncName+":: Nao Houve Processamento (Envio)")
	Else
		ConOut(cFuncName+":: Processamento (Envio) finalizado")
		_cQuery := "UPDATE " + RetSQLName("SZ7") + " SET Z7_WFE = '2'" + CRLF
		_cQuery += "WHERE D_E_L_E_T_ = ''" + CRLF
		_cQuery += "AND Z7_FILIAL = '" + _cFil + "'" + CRLF
		_cQuery += "AND Z7_NUM = '" + TSZ7->Z7_NUM + "'" + CRLF
		_cQuery += "AND Z7_WFE = '1'" + CRLF
		TcSQLExec(_cQuery)
	EndIf

	TSZ7->(DbSkip())
Enddo

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³_fWFRetGC ºAutor  ³Microsiga           º Data ³  18/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorno da Solicitação                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function _fWFRetGC(oProcess)

_cFilial  := alltrim(oProcess:oHtml:RetByName("FILIAL"))
_cFilial  := IIF(Alltrim(_cFilial)=="",xFilial("SZ7"),_cFilial)
_cNumGC	  := alltrim(oProcess:oHtml:RetByName("NUMGC"))
_cObs     := alltrim(oProcess:oHtml:RetByName("OBS"))
_cAprov	  := alltrim(oProcess:oHtml:RetByName("CAPROV"))
cOpc	  := alltrim(oProcess:oHtml:RetByName("OPC"))

oProcess:Finish()
lLiberou := .f.

SZ7->(DbSetOrder(1))
SZ7->(DbSeek(_cFilial + _cNumGC))

SCR->(dbSetOrder(2))
IF SCR->(dbSeek(XFilial("SCR")+"GC"+_cNumGC+Space(TamSx3("CR_NUM")[1]-Len(_cNumGC))+_cAprov))
	lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,SCR->CR_TOTAL,SCR->CR_APROV,,SC7->C7_APROV,,,,,_cObs},dDataBase,IIF(cOpc == "APROVAR",4,6))
ELSE
	ConOut('Alcada nao encontrada!!!')
ENDIF

IF cOpc == "APROVAR"
	_fVerifGC(_cFilial,_cNumGC,_cObs,,_cAprov)
ELSE
	SZ7->(dbSetOrder(1))
	SZ7->(dbSeek(_cFilial+_cNumGC))
	
	_cEMail := Alltrim(UsrRetMail( SZ7->Z7_USUSOL ))
	_cBody  := "Prezado(a) Comprador,"+ " - " + retDesc("SOLICIT", UsrRetname(SZ7->Z7_USUSOL)) + Chr(13)+Chr(10)+Chr(13)+Chr(10)
	_cBody  += "Informamos que sua Solicitação de Contrato Nr. "+_cNumGC+" - " + SZ7->Z7_FILIAL + " foi reprovada."
	_cBody  += Chr(13)+Chr(10)+Chr(13)+Chr(10)
	_cBody  += "Obs: "+_cObs
	ACSendMail( ,,,,_cEMail,"GC "+_cNumGC+" REPROVADO",_cBody)
	
	RecLock("SZ7", .F.)
	SZ7->Z7_STATUS := "5"
	SZ7->(MsUnlock())
ENDIF

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³_fVerifGC ºAutor  ³Microsiga           º Data ³  18/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica liberação do pedido                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _fVerifGC(_cFil,_cNumGC,_cObs,_cNiv,_cAprov)
Local _cQuery  := ""
Local _cArqSCR := CriaTrab(nil,.f.)
Local _cNome := "" 
Local aArea  := {}

Default _cAprov := ""

_cNome := UsrRetName(_cAprov)

_cQuery := "SELECT * FROM "+RetSqlName("SCR")+" "
_cQuery += "WHERE D_E_L_E_T_ = ' ' AND CR_FILIAL = '"+XFilial("SCR")+"' AND CR_NUM = '"+_cNumGC+"' AND CR_STATUS NOT IN ('03','05') AND CR_TIPO = 'GC' "
_cQuery := ChangeQuery(_cQuery)

dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),_cArqSCR,.t.,.t.)

IF (_cArqSCR)->(Eof())
	
	SZ7->(dbSetOrder(1))
	SZ7->(dbSeek(_cFil+_cNumGC))

	_cEMail := Alltrim(UsrRetMail( SZ7->Z7_USUSOL ))
	_cBody  := "Prezado(a) "+UsrRetName(SZ7->Z7_USUSOL)+ " - " + retDesc("SOLICIT", UsrRetname(SZ7->Z7_USUSOL)) + Chr(13)+Chr(10)+Chr(13)+Chr(10)
	_cBody  += "Informamos que sua Solicitação de Contrato Nr. "+_cNumGC+" - " + SZ7->Z7_FILIAL + " foi aprovado."
	_cBody  += Chr(13)+Chr(10)+Chr(13)+Chr(10)
	_cBody  += "Obs: "+_cObs
	ACSendMail( ,,,,_cEMail,"GC "+_cNumGC+" APROVADO",_cBody)
	
	RecLock("SZ7", .F.)
	SZ7->Z7_STATUS := "6"
	SZ7->(MsUnlock())
ELSE
	_WFSendGC(_cFil,_cNumGC)
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