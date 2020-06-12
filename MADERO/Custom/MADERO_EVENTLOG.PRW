#include 'protheus.ch'

/*                                                    
+------------------+-------------------------------------------------------------------------------+
! Nome             ! EVENTLOG                                                                      !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! Processo de geração de log                                                    !
!                  !                                                                               !
+------------------+-------------------------------------------------------------------------------+
! Autor            ! Márcio Zaguetti                                                               !
+------------------+-------------------------------------------------------------------------------+
! Data             ! 25/05/2018                                                                    !
+------------------+-------------------------------------------------------------------------------+
! Alterador por Márcio A. Zaguetti em 12/06/2018 para contemplar todos os prcessos de log das roti-!
! nas de integração do MADERO e para ajustar os log do processo de integração que não form tratados!
! no processo, conforme MIT044                                                                     !
+--------------------------------------------------------------------------------------------------+
*/                                                                                
class EventLog from LongClassName
data nReg
data cFili
data cPasso

	method start(cProcess, dDate, cInfo, cMetEnv, cRot) constructor
	method restart(nrecno) constructor 

	method broken(cEventError, cReturn, lAddInfo)
	method newOrUpdate(cProcess, dDate, cMetEnv, cRot)
	method finish()  
	method setXmlEnv(cXml, nItnes)
	method setXmlRet(cXml)
	method setAddXmlRet(cXml)         
	method setItensRet()
	method setInfo(cErro, cInfo)
	method setStep(cPasso)
	method setAddInfo(cErro, cInfo)
	method setCountInc()
	method setCountOk()
	method setCountTot(nxTot)
	method setDetail(cId, cEnt, cTp, nVr, cErro, lShow, cZWE_DOCUM, dZWEDTPROC, cZWECHAVE, cZWEDESCP, cZWEPROD, cZWEDETAIL, lSum, nxThrd)
	method pos()
	method GetStep()    
	method GetRecno()    
	method GetUnit()

endclass


/*                                                    
+------------------+-------------------------------------------------------------------------------+
! Nome             ! start                                                                         !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! Construttor da classe                                                         !
!                  !                                                                               !
+------------------+-------------------------------------------------------------------------------+
*/                                                                                
method start(cProcess, dDate, cInfo, cMetEnv, cRot) class EventLog

	::newOrUpdate(cProcess, dDate, cMetEnv, cRot)

	ZWS->ZWS_PROCES := cProcess
	ZWS->ZWS_DTPROC := dDate
	ZWS->ZWS_STATUS := "A"
	ZWS->ZWS_INF    := cInfo
	ZWS->ZWS_NINT   ++
	ZWS->( msUnLock() )

	// -> salva o registro
	::nReg  :=ZWS->(Recno())
    ::cFili :=ZWS->ZWS_XFILIA
	::cPasso:=ZWS->ZWS_XPASSO

return


/*                                                    
+------------------+-------------------------------------------------------------------------------+
! Nome             ! restart                                                                       !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! continuidade do processo													   !
!                  !                                                                               !
+------------------+-------------------------------------------------------------------------------+
*/                                                                                
method restart(nrecno) class EventLog

	dbSelectArea("ZWS")
	ZWS->(DbGoTo(nrecno))
	If ZWS->(Eof())
		Conout("Processo com ID "+AllTrim(Str(nrecno))+" nao encontrado na tabela ZWS.")
		UserException("Processo com ID "+AllTrim(Str(nrecno))+" nao encontrado na tabela ZWS.")
	Else
		// -> salva o registro
		::nReg  :=ZWS->(Recno())
		::cFili :=ZWS->ZWS_XFILIA
		::cPasso:=ZWS->ZWS_XPASSO
	EndIf	

return


/*                                                    
+------------------+-------------------------------------------------------------------------------+
! Nome             ! broken                                                                        !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! Construttor da classe                                                         !
!                  !                                                                               !
+------------------+-------------------------------------------------------------------------------+
*/                                                                                
method broken(cInfoBroken, cReturn, lAddInfo, lShowInfo) class EventLog
Default lAddInfo  := .F.
Default lShowInfo := .T.

	::Pos()
                       
    recLock("ZWS",.F.)
	ZWS->ZWS_STATUS := "E"
	ZWS->ZWS_INF    := cInfoBroken
	ZWS->ZWS_ERROR  := IIF(lAddInfo,ZWS->ZWS_ERROR + Chr(13) + Chr(10) + AllTrim(cReturn), AllTrim(cReturn))
	ZWS->( msUnLock() )

	If lShowInfo
	   ConOut("Erro: " + cInfoBroken)
	EndIf   

return nil


/*                                                    
+------------------+-------------------------------------------------------------------------------+
! Nome             ! newOrUpdate                                                                   !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! Método para verificar se é inclusão ou update do log                          !
!                  !                                                                               !
+------------------+-------------------------------------------------------------------------------+
*/                                                                                
method newOrUpdate(cProcess, dDate, cMetEnv, cRot) class EventLog
Local lnew

	Conout("============================================================================================")
	Conout("Filial..: " + SM0->M0_CODFIL + " - " + SM0->M0_FILIAL)
	Conout("Processo: " + cProcess + " - " + cMetEnv + ' de ' + DtoC(dDate))
	Conout("Iniciado em " + DtoC(Date()) + " as " + Time())
	Conout("--------------------------------------------------------------------------------------------")

	// -> Verifica Verifica se o log existe
	dbSelectArea("ZWS")
	ZWS->( dbSetOrder(1) )
	ZWS->( dbGoTop() )
	ZWS->( dbSeek( xFilial("ZWS") + xFilial(cRot) + PadR(cProcess,TamSX3("ZWS_PROCES")[1]) + DtoS(dDate) ) )
	lnew := ! ZWS->( Found() )

	recLock("ZWS",lnew)

	IF lnew
		ZWS->ZWS_FILIAL := xFilial("ZWS")           
		ZWS->ZWS_XFILIA := xFilial(cRot)
		ZWS->ZWS_XPASSO := ""		
	EndIF
	
	// -> limpa numero de itens
	ZWS->ZWS_DTINT  := Date()
	ZWS->ZWS_HRINT  := Time()
	ZWS->ZWS_XMLE   := ""
	ZWS->ZWS_XMLR   := "" 
	ZWS->ZWS_ERROR  := ""
	ZWS->ZWS_ITENV  := 0	
	ZWS->ZWS_ITCONF := 0
    
	ConOut("-> Iniciando processamento...")

return


/*                                                    
+------------------+-------------------------------------------------------------------------------+
! Nome             ! finish                                                                        !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! Finaliza o processo de log                                                    !
!                  !                                                                               !
+------------------+-------------------------------------------------------------------------------+
*/                                                                                
method finish() class EventLog
Local lErro:=.F.
   
	::Pos()

	recLock("ZWS",.F.)
    lErro:=(ZWS->ZWS_STATUS == "E") .or. (ZWS->ZWS_ITENV <> ZWS->ZWS_ITCONF)
	ZWS->ZWS_STATUS := IIF(!lErro,"I","E")
	ZWS->ZWS_INF    := IIF(!lErro,"Processo ok.","Erro no processo. Ver detalhe no log.")
	ZWS->ZWS_DTINT  := Date()
	ZWS->ZWS_HRINT  := Time()
	ZWS->( msUnLock() )
                                           
    ConOut(IIF(!lErro,"Fim: Processo finalizado com sucesso.","Fim: Processo finalizado com erro."))
	
	::nReg  := nil
    ::cFili := nil
	::cPasso:= nil

	Conout("--------------------------------------------------------------------------------------------")
	Conout("Finalizado em " + DtoC(Date()) + " as " + Time())

return


/*                                                    
+------------------+-------------------------------------------------------------------------------+
! Nome             ! setXmlEnv                                                                     !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! Atualiza dados enviados                                                       !
!                  !                                                                               !
+------------------+-------------------------------------------------------------------------------+
*/                                                                                
method setXmlEnv(cXml,nItens) class EventLog

	::pos()

	recLock("ZWS",.F.)   
	ZWS->ZWS_XMLE   := cXml
	ZWS->ZWS_ITENV  := nItens
	ZWS->ZWS_DTINT  := Date()
	ZWS->ZWS_HRINT  := Time()	
	ZWS->( msUnLock() )

return


/*                                                    
+------------------+-------------------------------------------------------------------------------+
! Nome             ! setXmlRet                                                                     !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! Atualiza dados recebidos                                                      !
!                  !                                                                               !
+------------------+-------------------------------------------------------------------------------+
*/                                                                                
method setXmlRet(cXml) class EventLog

	::pos()

	recLock("ZWS",.F.)
	ZWS->ZWS_XMLR  := cXml   
	ZWS->ZWS_DTINT  := Date()
	ZWS->ZWS_HRINT  := Time()	
	ZWS->( msUnLock() )

return


/*                                                    
+------------------+-------------------------------------------------------------------------------+
! Nome             ! setAddXmlRet                                                                     !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! Atualiza dados recebidos                                                      !
!                  !                                                                               !
+------------------+-------------------------------------------------------------------------------+
*/                                                                                
method setAddXmlRet(cXml) class EventLog

	::pos()

	recLock("ZWS",.F.)
	ZWS->ZWS_XMLR  := ZWS->ZWS_XMLR + cXml + Chr(13) + Chr(10)
	ZWS->ZWS_DTINT  := Date()
	ZWS->ZWS_HRINT  := Time()	
	ZWS->( msUnLock() )

return


/*                                                    
+------------------+-------------------------------------------------------------------------------+
! Nome             ! GetStep                                                                       !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! Retorna o status da execução                                                  !
!                  !                                                                               !
+------------------+-------------------------------------------------------------------------------+
*/                                                                                
method GetStep() class EventLog

	::pos()

return(::cPasso)


/*                                                    
+------------------+-------------------------------------------------------------------------------+
! Nome             ! GetRecno                                                                      !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! Retorna o recno do processo                                                   !
!                  !                                                                               !
+------------------+-------------------------------------------------------------------------------+
*/                                                                                
method GetRecno() class EventLog
Local nRec 
	
	If ::nReg == nil
		Conout("Classe nao instancia para method Start")
		UserException("Classe nao instancia para method Start.")
	Else
		nRec:=::nReg
	EndIf

return(nRec)


/*                                                    
+------------------+-------------------------------------------------------------------------------+
! Nome             ! setItensRet                                                                   !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! Atualiza itens recebidos                                                      !
!                  !                                                                               !
+------------------+-------------------------------------------------------------------------------+
*/                                                                                
method setItensRet() class EventLog

	::pos()

	recLock("ZWS",.F.)
	ZWS->ZWS_ITENV := ZWS->ZWS_ITENV + 1
	ZWS->ZWS_DTINT  := Date()
	ZWS->ZWS_HRINT  := Time()
	ZWS->( msUnLock() )

return




/*                                                    
+------------------+-------------------------------------------------------------------------------+
! Nome             ! setCountInc                                                                   !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! Itens Incluidos                                                               !
!                  !                                                                               !
+------------------+-------------------------------------------------------------------------------+
*/                                                                                
method setCountInc() class EventLog

	::pos()

	recLock("ZWS",.F.)
	ZWS->ZWS_ITCONF ++       
	ZWS->ZWS_DTINT  := Date()
	ZWS->ZWS_HRINT  := Time()

	ZWS->( msUnLock() )

return


/*                                                    
+------------------+-------------------------------------------------------------------------------+
! Nome             ! setCountOk                                                                    !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! Itens processados                                                             !
!                  !                                                                               !
+------------------+-------------------------------------------------------------------------------+
*/                                                                                
method setCountOk() class EventLog

	::pos()

	recLock("ZWS",.F.)
	ZWS->ZWS_ITENV ++
	ZWS->ZWS_DTINT  := Date()
	ZWS->ZWS_HRINT  := Time()	
	ZWS->( msUnLock() )

return



/*                                                    
+------------------+-------------------------------------------------------------------------------+
! Nome             ! setCountTot                                                                   !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! Itens totais a serem processados                                              !
!                  !                                                                               !
+------------------+-------------------------------------------------------------------------------+
*/                                                                                
method setCountTot(nxTot) class EventLog

	::pos()

	recLock("ZWS",.F.)
	ZWS->ZWS_ITENV  := nxTot
	ZWS->ZWS_DTINT  := Date()
	ZWS->ZWS_HRINT  := Time()	
	ZWS->( msUnLock() )

return


/*                                                    
+------------------+-------------------------------------------------------------------------------+
! Nome             ! setInfo                                                                       !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! Grava informações no log                                                      !
!                  !                                                                               !
+------------------+-------------------------------------------------------------------------------+
*/                                                                                
method setInfo(cError, cInfo) class EventLog

	::pos()

	recLock("ZWS",.F.)
	ZWS->ZWS_ERROR := cError 
	ZWS->ZWS_INF   := AllTrim(cInfo)
	ZWS->ZWS_DTINT  := Date()
	ZWS->ZWS_HRINT  := Time()	
	ZWS->( msUnLock() )

return



/*                                                    
+------------------+-------------------------------------------------------------------------------+
! Nome             ! setStep                                                                       !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! Grava o 'passo' do log                                                        !
!                  !                                                                               !
+------------------+-------------------------------------------------------------------------------+
*/                                                                                
method setStep(cPasso) class EventLog

	::pos()

	recLock("ZWS",.F.)
	ZWS->ZWS_XPASSO := cPasso	
	ZWS->( msUnLock() )

return

/*                                                    
+------------------+-------------------------------------------------------------------------------+
! Nome             ! GetUnit                                                                       !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! Pega código da filial                                                         !
!                  !                                                                               !
+------------------+-------------------------------------------------------------------------------+
*/                                                                                
method GetUnit() class EventLog

	::pos()

return(::cFili)


/*                                                    
+------------------+-------------------------------------------------------------------------------+
! Nome             ! setAddInfo                                                                    !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! Adiciona informações no log                                                   !
!                  !                                                                               !
+------------------+-------------------------------------------------------------------------------+
*/                                                                                
method setAddInfo(cError, cInfo) class EventLog

	::pos()

	recLock("ZWS",.F.)
	ZWS->ZWS_ERROR := ZWS->ZWS_ERROR + AllTrim(cError) + Chr(13) + Chr(10)
	ZWS->ZWS_INF   := IIF(AllTrim(cInfo)<>"",AllTrim(cInfo),ZWS->ZWS_INF)
	ZWS->ZWS_DTINT  := Date()
	ZWS->ZWS_HRINT  := Time()	
	ZWS->( msUnLock() )

return


/*                                                    
+------------------+-------------------------------------------------------------------------------+
! Nome             ! setCountOk                                                                    !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! Prosiciona no registro do log                                                 !
!                  !                                                                               !
+------------------+-------------------------------------------------------------------------------+
*/                                                                                
method pos() class EventLog

	IF ::nReg == nil
		Conout("Classe nao instancia para method Start")
		UserException("Classe nao instancia para method Start.")
	EndIf

	IF ZWS->( Recno() ) != ::nReg
		ZWS->( dbGoTo( ::nReg ) )
	EndIF
	
	::cFili :=ZWS->ZWS_XFILIA
	::cPasso:=ZWS->ZWS_XPASSO
	
return





/*                                                    
+------------------+-------------------------------------------------------------------------------+
! Nome             ! setDetail                                                                     !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! Adiciona detalhamento no log                                                  !
!                  !                                                                               !
+------------------+-------------------------------------------------------------------------------+
*/                                                                                
method setDetail(cID, cEnt, cTp, cZWECHAVE, cErro, lShow, cZWE_DOCUM, dZWEDTPROC, nZWEVALOR, cZWEDESCP, cZWEPROD, cZWEDETAIL, lSum, nxThrd) class EventLog
Local nTamID  := TamSx3("ZWE_ID")[1]
Local cAuxID  := ""
Default lShow := .T.
Default lSum  := .F.
	
	::pos()

	// -> So o registro for "somado", verifica se já existe. Se não existir inclui e se existir soma o valor
	cAuxID:=cID+Space(nTamID-Len(cID))
	If lSum
		ZWE->(DbSetOrder(1))
		lSum:=ZWE->(DbSeek(ZWS->ZWS_XFILIA+ZWS->ZWS_PROCES+DtoS(ZWS->ZWS_DTINT)+cAuxID+cEnt))
	EndIF

	// -> So o registro for detalhado, inclui no log
	If !lSum
		recLock("ZWE",.T.)
		ZWE_FILIAL	:= ZWS->ZWS_XFILIA
		ZWE_DATA	:= ZWS->ZWS_DTINT
		ZWE_PROCES	:= ZWS->ZWS_PROCES
		ZWE_DOCUM   := cZWE_DOCUM
		ZWE_DTPROC  := dZWEDTPROC
		ZWE_ID		:= cID
		ZWE_ENTID	:= cEnt
		ZWE_CHAVE   := IIF(ValType(cZWECHAVE)=="N",AllTrim(Str(cZWECHAVE)),cZWECHAVE)
		ZWE_DESCP   := cZWEDESCP
		ZWE_PROD    := cZWEPROD
		ZWE_TIPO	:= cTp
		ZWE_VALOR	:= nZWEVALOR
		ZWE_DESC	:= cErro
		ZWE_DETAIL  := cZWEDETAIL
		ZWE_THRID   := StrZero(nxThrd,10)
		ZWE->(msUnLock())
	Else
		recLock("ZWE",.F.)
		ZWE_VALOR	+= nZWEVALOR
		ZWE_DESC	:= cErro
		ZWE_DETAIL  := cZWEDETAIL
		ZWE->(msUnLock())
	EndIF
	
	If lShow
		ConOut(StrZero(nxThrd,10)+": "+cEnt+": "+AllTrim(cID)+": "+IIF(cTp="E","Erro",IIF(cTp="W","Avertencia","Log"))+": "+AllTrim(cErro))
	EndIf	

return
