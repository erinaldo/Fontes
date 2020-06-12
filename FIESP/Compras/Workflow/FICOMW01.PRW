#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FICOMW01 ºAutor  ³ TOTVS              º Data ³ 12/09/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ WORKFLOW de Pedido de Compras atraves do SCHEDULER         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FICOMW01(aParam)

Local lIniciaEmp := .F.
Local cFuncName  := "FICOMW01"
Local _cPc       := Nil
Local cCodEmp    := ""
Local cCodFil    := ""
Local lContinua  := .F.
Local nW                       
_cEmails:=GetMv("FI_EMAPROV",,.F.) // Usuários que poderão receber os emails de aprovação, mesmo não estando no grupo de aprovação.

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
	ConOut(cFuncName+":: Inicializacao do ambiente - Workflow PC Empresa/Filial: "+cCodEmp+"/"+cCodFil)
	WfPrepEnv(cCodEmp,cCodFil)

	_WFSendPC(cCodFil,_cPC) // Processa a rotina para Envio do Workflow de Aprovacao do PC

	Reset Environment 
	ConOut(cFuncName+":: Finalizacao do ambiente - Workflow PC Empresa/Filial: "+cCodEmp+"/"+cCodFil)
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
±±ºPrograma  ³_WFSendPC º Autor ³ Microsiga          º Data ³ 18/11/10    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Envio de Pedido de Compras para aprovacao                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _WFSendPC(_cFil,_cPC)

Local _cQrySC7   := ""
Local _nTotal    := 0
Local _nTotICM   := 0
Local _nTotIPI   := 0
Local _nTotFRE   := 0
Local _nTotDSP   := 0
Local _nTotSEG   := 0
Local _cWfDir    := Iif(RTrim(Right(GetNewPar("MV_WFDIR"),1))=="\",GetNewPar("MV_WFDIR"),GetNewPar("MV_WFDIR")+"\")
Local cHtmlModel := ""
Local cFuncName  := "_WFSendPC"
Local cWFHTTP    := Iif(Right(RTrim(GetNewPar("MV_WFDHTTP")),1)=="/",GetNewPar("MV_WFDHTTP"),GetNewPar("MV_WFDHTTP")+"/")
Local aDirHtml   := {}
Local cDirHtml   := "html\"
Local cDirPasta  := "aprovpc\"
Local cDescProd := ""

Local i

Private oHTML
Private cItem,cCod,cDesc,cUM,nQtde,nUprc,nTot,nToler,cUComp,dEnt,cCC,cCCDesc
Private lProcesso := .f.

If Select("TSC7") > 0
	TSC7->(dbCloseArea())
Endif

_cQrySC7:= " SELECT DISTINCT C7_FILIAL,C7_NUM "
_cQrySC7+= " FROM "+RetSqlName("SC7")+" "
_cQrySC7+= " WHERE C7_FILIAL = '"+XFILIAL("SC7")+"' "
// condicao para identificar se trata-se de envio para primeiro ou proximo nivel
If _cPC == Nil	// primeiro nivel executado pelo Scheduler Protheus nao passa Num. do PC
	_cQrySC7+= " AND C7_XWFE    = ' ' " //campo caracter criado para nao trazer o pedido de compras mais de um vez no Scheduler
	_cQrySC7+= " AND C7_FILIAL = '"+_cFil+"' "
Else			// proximos niveis executados via retorno
	_cQrySC7+= " AND C7_FILIAL = '"+_cFil+"' AND C7_NUM = '"+_cPC+"' "
EndIf

//	_cQrySC7+= " AND C7_FILIAL = '"+_cFil+"' AND C7_NUM = '"+_cPC+"' "

_cQrySC7+= " AND D_E_L_E_T_ = ' ' AND C7_CONAPRO = 'B' "
_cQrySC7+= " ORDER BY C7_NUM "
TCQUERY _cQrySC7 NEW ALIAS "TSC7"

TSC7->(dbGoTop())

While TSC7->(!Eof())
	
	lProcesso := .t.
	
	SCR->(dbSetOrder(1))
	SCR->(dbSeek(XFilial("SCR")+"PC"+TSC7->C7_NUM))
	
	_aLogApr  := {}
	
	While SCR->(!Eof()) .and. SCR->CR_FILIAL == XFilial("SCR") .and. Alltrim(SCR->CR_NUM) == Alltrim(TSC7->C7_NUM) .and. SCR->CR_TIPO == "PC"
		
		_cSituaca := ""
		IF SCR->CR_STATUS == "01"
			_cSituaca := OemToAnsi("Aguardando")
		ELSEIF SCR->CR_STATUS == "02"
			_cSituaca := OemToAnsi("Em Aprovacao")
		ELSEIF SCR->CR_STATUS == "03"
			_cSituaca := "Pedido Aprovado"
		ELSEIF SCR->CR_STATUS == "04"
			_cSituaca := "Pedido Bloqueado"
		ELSEIF SCR->CR_STATUS == "05"
			_cSituaca := OemToAnsi("Nivel Liberado ")
		ENDIF
		
		Aadd(_aLogApr,{SCR->CR_NIVEL,UsrRetname(SCR->CR_USER),_cSituaca,Dtoc(SCR->CR_DATALIB),SCR->CR_OBS})
		
		SCR->(dbSkip())
	Enddo
	
	SCR->(DbGoTop())
	SCR->(dbSetOrder(1))
	SCR->(dbSeek(XFilial("SCR")+"PC"+TSC7->C7_NUM))
	
	While SCR->(!Eof()) .and. SCR->CR_FILIAL == XFilial("SCR") .and. Alltrim(SCR->CR_NUM) == Alltrim(TSC7->C7_NUM) .and. SCR->CR_TIPO == "PC"
		
		IF SCR->CR_STATUS <> "02" // nivel 02 indica proxima que recebe e-mail
			SCR->(dbSkip())
			Loop
		ENDIF
		
		SC7->(dbSetOrder(1))
		SC7->(dbSeek(xFilial("SC7")+Alltrim(TSC7->C7_NUM)))
		
		SA2->(dbSetOrder(1))
		SA2->(dbSeek(XFilial("SA2")+SC7->(C7_FORNECE_C7_LOJA)))
		
		SE4->(dbSetOrder(1))
		SE4->(dbSeek(XFilial("SE4")+SC7->C7_COND))
		
		ConOut(cFuncName+":: Processando PC Filial/No.: "+SC7->C7_FILIAL+"/"+SC7->C7_NUM)
		//Abre o HTML
		oProcess := TWFProcess():New( "PEDIDO", "Pedido de Compras" )
		oProcess:NewTask( "000001", _cWfDir+"AprovacaoPC.htm" )
		oProcess:cSubject := "Aprovação do Pedido de Compra Nr. " +TSC7->C7_NUM
		oProcess:bReturn  := "U__fWFRetPC()"
		oProcess:UserSiga := SC7->C7_USER
		oProcess:NewVersion(.T.)
		oHTML   := oProcess:oHTML
		
		oHtml:ValByName( "FILIAL"     , SC7->C7_FILIAL )
		oHtml:ValByName( "NUMPC"      , SC7->C7_NUM )
		oHtml:ValByName( "c7_emissao" , Dtoc(SC7->C7_EMISSAO) )
		oHtml:ValByName( "a2_nome"    , SA2->A2_NOME )
		oHtml:ValByName( "a2_cgc"     , SA2->A2_CGC )
		oHtml:ValByName( "a2_end"     , SA2->A2_END	)
		oHtml:ValByName( "a2_bairro"  , SA2->A2_BAIRRO )
		oHtml:ValByName( "a2_mun"     , SA2->A2_MUN )
		oHtml:ValByName( "a2_est"     , SA2->A2_EST )
		oHtml:ValByName( "c7_filial"  , SC7->C7_FILIAL + " - " + retDesc("FILIAL", SC7->C7_FILIAL) )
		oHtml:ValByName( "c7_user"    , UsrRetname(SC7->C7_USER) + " - " + retDesc("SOLICIT", UsrRetname(SC7->C7_USER)) )
		oHtml:ValByName( "cc"         , SC7->C7_CC )
		oHtml:ValByName( "desccc"     , Posicione("CTT", 1, xFilial("CTT") + SC7->C7_CC, "CTT_DESC01") )
		oHtml:ValByName( "CAPROV"     , SCR->CR_USER )
		oHtml:ValByName( "APROVADOR"  , UsrRetname(SCR->CR_USER) + " - " + retDesc("SOLICIT", UsrRetname(SCR->CR_USER)) )
		oHtml:ValByName( "c7_contato" , SC7->C7_CONTATO )
		oHtml:ValByName( "e4_descri"  , SE4->E4_DESCRI )
//		oHtml:ValByName( "c7_numpr" , SC7->C7_NUMPR )
		
		_nSubTot := 0
		_nFrete  := 0
		_nTotal  := 0
		
		While !SC7->(Eof()) .and. SC7->C7_FILIAL == XFilial("SC7") .and. SC7->C7_NUM == Alltrim(TSC7->C7_NUM)
			
			ConOut(cFuncName+":: Processando Item da PC Filial/No./Item: "+SC7->C7_FILIAL+"/"+SC7->C7_NUM+"/"+SC7->C7_ITEM)
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(XFilial("SB1")+SC7->C7_PRODUTO))
			
			cDescProd  := Posicione("SB5",1,xFilial("SB5")+SB1->B1_COD,"B5_CEME")
			DbSelectArea("SB1")
			
			AAdd( (oHtml:ValByName( "prod.cItem"    )),SC7->C7_ITEM )
			AAdd( (oHtml:ValByName( "prod.cCod"     )),SC7->C7_PRODUTO )
			AAdd( (oHtml:ValByName( "prod.cDesc"    )),Iif(Empty(cDescProd),SB1->B1_DESC,cDescProd) ) //pesquisar sempre pelo SB5 e depois no SB1
			AAdd( (oHtml:ValByName( "prod.cUM"      )),SC7->C7_UM )
			AAdd( (oHtml:ValByName( "prod.nQuant"   )),TRANSFORM( SC7->C7_QUANT,'@E 999,999,999.99' ) )
			AAdd( (oHtml:ValByName( "prod.nVrUnit"  )),TRANSFORM( SC7->C7_PRECO,'@E 999,999,999.99' ) )
			AAdd( (oHtml:ValByName( "prod.nVrTotal" )),TRANSFORM( SC7->C7_TOTAL,'@E 999,999,999.99' ) )
			AAdd( (oHtml:ValByName( "prod.dEntrega" )),Dtoc(SC7->C7_DATPRF) )
			AAdd( (oHtml:ValByName( "prod.cObs" )),SC7->C7_OBS )
//			WFSalvaID('SC7','SC7->C7_WFE', .T.)
			
			_nSubTot += SC7->C7_TOTAL
			_nFrete  += SC7->C7_VALFRE
			_nTotal  += SC7->(C7_TOTAL+C7_VALFRE)
			
			SC7->(DbSkip())
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

		cHtmlModel := _cWfDir+"LinkPC.htm"
		cAssunto   := "Pedido de Compras Nr. " +TSC7->C7_NUM

		oProcess:NewTask(cAssunto, cHtmlModel)
		ConOut(cFuncName+":: (INICIO|WFLINK)Processo: " + oProcess:fProcessID + " / Task: " + oProcess:fTaskID )
		oProcess:cSubject := cAssunto
		oProcess:cTo := Alltrim(UsrRetMail( SCR->CR_USER ))+";"+_cEmails
		
		oProcess:ohtml:ValByName("CAPROVADOR",UsrRetname(SCR->CR_USER))
		oProcess:ohtml:ValByName("CNUMPC",TSC7->C7_NUM)
		
		oProcess:ohtml:ValByName("proc_link",StrTran(cWFHTTP+cDirHtml2+cMailID+".htm","\","/"))
		oProcess:Start()
		
		SCR->(dbSkip())
	Enddo

	If !lProcesso
		ConOut(cFuncName+":: Nao Houve Processamento (Envio)")
	Else
		ConOut(cFuncName+":: Processamento (Envio) finalizado")
		_cQuery	:= "UPDATE "+ RetSqlName("SC7")+" SET C7_XWFE = 'T' "
		_cQuery += "WHERE D_E_L_E_T_ = '' "
		_cQuery += "AND C7_FILIAL = '"+_cFil+"' AND C7_NUM = '"+TSC7->(C7_NUM)+"' "
		_cQuery += "AND C7_XWFE = ' ' "
		TcSQLExec(_cQuery)
	EndIf

	TSC7->(dbSkip())
Enddo

TSC7->(dbCloseArea())



Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³_fWFRetPC ºAutor  ³Microsiga           º Data ³  18/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorno da Solicitação                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function _fWFRetPC(oProcess)

_cFilial  := alltrim(oProcess:oHtml:RetByName("FILIAL"))
_cFilial  := IIF(Alltrim(_cFilial)=="",Xfilial("SC7"),_cFilial)
_cNumPC	  := alltrim(oProcess:oHtml:RetByName("NUMPC"))
_cObs     := alltrim(oProcess:oHtml:RetByName("OBS"))
_cAprov	  := alltrim(oProcess:oHtml:RetByName("CAPROV"))
cOpc	  := alltrim(oProcess:oHtml:RetByName("OPC"))

oProcess:Finish() // FINALIZA O PROCESSO
lLiberou := .f.

SC7->(dbSetOrder(1))
SC7->(dbSeek(_cFilial+_cNumPC))

SCR->(dbSetOrder(2))
IF SCR->(dbSeek(XFilial("SCR")+"PC"+_cNumPC+Space(TamSx3("CR_NUM")[1]-Len(_cNumPC))+_cAprov))
	lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,SCR->CR_TOTAL,SCR->CR_APROV,,SC7->C7_APROV,,,,,_cObs},dDataBase,IIF(cOpc == "APROVAR",4,6))
ELSE
	ConOut('Alcada nao encontrada!!!')
ENDIF

IF cOpc == "APROVAR"
	_fVerifPC(_cFilial,_cNumPC,_cObs,,_cAprov)
ELSE
	SC7->(dbSetOrder(1))
	SC7->(dbSeek(_cFilial+_cNumPC))
	
	_cEMail := Alltrim(UsrRetMail( SC7->C7_USER ))
	_cBody  := "Prezado(a) Comprador,"+ " - " + retDesc("SOLICIT", UsrRetname(SC7->C7_USER)) + Chr(13)+Chr(10)+Chr(13)+Chr(10)
	_cBody  += "Informamos que seu Pedido de Compras Nr. "+_cNumPC+" - " + SC7->C7_FILIAL + " foi reprovado."
	_cBody  += Chr(13)+Chr(10)+Chr(13)+Chr(10)
	_cBody  += "Obs: "+_cObs
	ACSendMail( ,,,,_cEMail,"PC "+_cNumPC+" REPROVADO",_cBody)
	
/*
	While !SC7->(Eof()) .and. SC7->C7_FILIAL == XFilial("SC7") .and. SC7->C7_NUM == Alltrim(_cNumPC)
		WFSalvaID('SC7','SC7->C7_WFE', .F.)                                                         
		SC7->(dbSkip())
	End
*/

ENDIF

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³_fVerifPC ºAutor  ³Microsiga           º Data ³  18/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica liberação do pedido                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _fVerifPC(_cFil,_cNumPC,_cObs,_cNiv,_cAprov)
Local _cQuery  := ""
Local _cArqSCR := CriaTrab(nil,.f.)
Local _cNome := "" 
Local aArea  := {}

Default _cAprov := ""

_cNome := UsrRetName(_cAprov)

// verifica se o pedido foi totalmente liberado
_cQuery := "SELECT * FROM "+RetSqlName("SCR")+" "
_cQuery += "WHERE D_E_L_E_T_ = ' ' AND CR_FILIAL = '"+XFilial("SCR")+"' AND CR_NUM = '"+_cNumPC+"' AND CR_STATUS NOT IN ('03','05') AND CR_TIPO = 'PC' "
_cQuery := ChangeQuery(_cQuery)

dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),_cArqSCR,.t.,.t.)

IF (_cArqSCR)->(Eof())
	
	SC7->(dbSetOrder(1))
	SC7->(dbSeek(_cFil+_cNumPC))
	
	// envia email ao solicitante
	_cEMail := Alltrim(UsrRetMail( SC7->C7_USER ))
	_cBody  := "Prezado(a) "+UsrRetName(SC7->C7_USER)+ " - " + retDesc("SOLICIT", UsrRetname(SC7->C7_USER)) + Chr(13)+Chr(10)+Chr(13)+Chr(10)
	_cBody  += "Informamos que seu Pedido de Compras Nr. "+_cNumPC+" - " + SC7->C7_FILIAL + " foi aprovado."
	_cBody  += Chr(13)+Chr(10)+Chr(13)+Chr(10)
	_cBody  += "Obs: "+_cObs
	ACSendMail( ,,,,_cEMail,"PC "+_cNumPC+" APROVADO",_cBody)
	
	While SC7->(!Eof()) .and. SC7->(C7_FILIAL+C7_NUM) == _cFil+_cNumPC
		RecLock("SC7",.F.)
		SC7->C7_CONAPRO	:= "L"
		SC7->(msUnlock())
		          
		aArea := SC7->(GetArea())
//		COMA080(SC7->C7_NUMSC,SC7->C7_ITEMSC,"COI_DTHLIB","COI_ULIB",/*lEstorno*/,_cNome,"COI_DOCLIB",SC7->C7_NUM) //Geracao de log aprovacao PC via WF
		RestArea(aArea)                        
		
		SC7->(dbSkip())
	EndDo
ELSE
	_WFSendPC(_cFil,_cNumPC) // envia e-mail para o proximo aprovador
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