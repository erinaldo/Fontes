#Include "Protheus.ch"

Static aEvtRot	:= TAFRotinas(,,.T.,2)

//-------------------------------------------------------------------
/*/{Protheus.doc} TAFMigr002
Integração dos dados da V2A para as tabelas de negócio do TAF
@author  Victor A. Barbosa
@since   15/10/2018
@version 1
/*/
//-------------------------------------------------------------------
Function TAFMigr002(oSay, oMeter, nNumThrd)

Default nNumThrd := 1

oSay:setText("Consultando dados...")
oSay:CtrlRefresh()

// Integração dos Eventos de Tabela
Migr02Eventos(oSay, oMeter, nNumThrd) // Chamada para realizar as alterações dos eventos de tabelas

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} Migr02Eventos
Efetua a consulta dos eventos pendentes processamento e realiza a integração com o TAF
@author  Victor A. Barbosa
@since   16/10/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function Migr02Eventos(oSay, oMeter, nNumThrd)

Local nInc      := 0
Local nTotal    := 0
Local nX        := 0
Local oGrid     := Nil
Local aEvtPen   := Migr02Pend() // Consulta os Eventos pendentes processamentos

// Só disponibiliza as threads se for informado mais que uma
If nNumThrd > 1
    // Sobe as Threads e deixa em estado de espera
    oGrid := Migr02MThreads(oSay, nNumThrd)
EndIf

For nX := 1 To Len(aEvtPen)

    oSay:setText("Verificando se existe dados para o " + aEvtPen[nX][4] + "." )
    oSay:CtrlRefresh()
    
    Migr02ProcEvt( aEvtPen[nX][4], aEvtPen[nX][3], aEvtPen[nX][12], oSay, oMeter, .T., oGrid ) // Chamada para inclusão
    Migr02ProcEvt( aEvtPen[nX][4], aEvtPen[nX][3], aEvtPen[nX][12], oSay, oMeter, .F., Nil ) // Chamada para alteração/exclusão/retificação

Next nX

If nNumThrd > 1
    oGrid:Stop()
    FreeObj(oGrid)
EndIf

// Chama a rotina de ajuste de status dos eventos excluídos.
oSay:setText("Realizando ajustes de status dos eventos S-3000")
TAF269Ajust()

oSay:setText("Processamento concluído")
oMeter:Free()

Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} Migr02ProcEvt
Efetua a query do evento e a chamada da função de processamento
@author  Victor A. Barbosa
@since   15/10/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function Migr02ProcEvt(cEvento, cAliasEVT, cTipoEvt, oSay, oMeter, lInclusao, oGrid)

Local cIndEvt       := ""
Local cMsgPrint     := ""
Local cAliasQry     := GetNextAlias()
Local nTotal        := 0
Local nInc          := 0
Local lMultThread   := oGrid <> Nil

If cTipoEvt == "C"
    If lInclusao
        cIndEvt := "%('3')%"
    Else
        cIndEvt := "%('4','5')%"
    EndIf
Else
    If lInclusao
        cIndEvt := "%('1')%"
    Else
        cIndEvt := "%('2')%"
    EndIf
EndIf

If Select(cAliasQry) > 0
    (cAliasQry)->(dbCloseArea())
EndIf

BeginSQL Alias cAliasQry
    SELECT V2A_STATUS, V2A_RECIBO, V2A.R_E_C_N_O_ V2ARECNO
    FROM %table:V2A% V2A
    WHERE V2A_FILIAL = %xFilial:V2A% 
    AND V2A_STATUS IN ('1', '3')
    AND V2A_INDEVT IN %exp:cIndEVT%
    AND V2A_EVENTO = %exp:cEvento%
    AND V2A.%notdel%
    ORDER BY V2A_DHPROC
EndSQL

(cAliasQry)->( dbEval( {|| nTotal++ } ) )
oMeter:SetTotal( nTotal )

(cAliasQry)->( dbGoTop() )

While (cAliasQry)->( !Eof() )

    nInc++
    oMeter:Set(nInc)
    ProcessMessages() // Força atualização no smartclient

    cMsgPrint := "Processando " + Iif(lInclusao, "inclusões", "refiticações/alterações") + " (" + cEvento + "). Andamento: " + cValToChar(nInc) + " de " + cValToChar(nTotal)

    oSay:setText( cMsgPrint )
    oSay:CtrlRefresh()

    If lMultThread
        oGrid:Go( (cAliasQry)->V2A_STATUS, (cAliasQry)->V2A_RECIBO, (cAliasQry)->V2ARECNO, cAliasEVT )
    Else
        Migr02Integ( (cAliasQry)->V2A_STATUS, (cAliasQry)->V2A_RECIBO, (cAliasQry)->V2ARECNO, cAliasEVT )
    EndIf
    
    (cAliasQry)->( dbSkip() )

EndDo

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} Migr02Integ
Realiza a integração dos registros com o TAF
@author  Victor A. Barbosa
@since   15/10/2018
@version 1
/*/
//-------------------------------------------------------------------
Function Migr02Integ( cStatus, cRecibo, nRecnoV2A, cAliasEvt )

Local aRetInt   := {}
Local aErrosTot := {}
Local cErros    := ""
Local cFilEvt   := ""
Local nX        := 0
Local lSuccess  := .F.

dbSelectArea("V2A")

V2A->( dbGoTo(nRecnoV2A) )

If !Empty(V2A->V2A_FILDES)
    cFilEvt := V2A->V2A_FILDES
Else
    cFilEvt := cFilAnt
EndIf

PtInternal( 1, "Processando Evento: " + V2A->V2A_EVENTO + " - Recno: " + cValToChar(nRecnoV2A) )

TafPrepInt( cEmpAnt, cFilEvt, V2A->V2A_XMLERP,,"1", StrTran(V2A->V2A_EVENTO, "-", ""),,,,@aRetInt,,,,,,,,,V2A->V2A_CHVGOV )

ConOut( "Processando Recibo: " + cRecibo )

If aRetInt[1] .And. V2A->V2A_EVENTO $ "S-1200|S-1210|S-1295|S-1299|S-2299" .And. V2A->V2A_STATUS == '3' .And. !Empty( V2A->V2A_XMLTOT )
    aErrosTot := Migr02Tot( V2A->V2A_XMLTOT, V2A->V2A_EVENTO )
EndIf

lSuccess := aRetInt[1] .And. Len(aErrosTot) == 0

If !lSuccess
    cErros += aRetInt[4]
    
    If Len(aErrosTot) > 0
        For nX := 1 To Len(aErrosTot)
            cErros += aErrosTot[nX] + Chr(10) + Chr(13)
        Next nX
    EndIf
EndIf

If RecLock("V2A", .F.)
    V2A->V2A_ERRO   := cErros
    V2A->V2A_STATUS := Iif( !lSuccess, "6", "5" )
    V2A->(MsUnlock())
EndIf

If lSuccess .And. !Empty(V2A->V2A_RECIBO)

    // Garante que o Aliás do evento está aberto
    If Select(cAliasEVT) > 0
        RecLock(cAliasEVT, .F.)
        &(cAliasEVT + "-> " + cAliasEVT + "_STATUS") := '4'
        &(cAliasEVT + "-> " + cAliasEVT + "_PROTUL") := V2A->V2A_RECIBO
        (cAliasEVT)->( MsUnlock() )
    EndIf

    // Verifica se existe um evento S-3000 para aquele recibo, se tiver já inclui ele
    If V2A->V2A_EVENTO <> "S-3000"
        
        V2A->( dbSetOrder(3) )
        If V2A->( MsSeek( xFilial("V2A") + "S-3000" + V2A->( V2A_RECIBO + V2A_CNPJ ) ) )
            Return Migr02Integ( V2A->V2A_STATUS, V2A->V2A_RECIBO, V2A->( Recno() ), "CMJ" )
        EndIf

    EndIf

EndIf

V2A->( dbCloseArea() )

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} Migr02Pend
Consulta os eventos pendetes processamento e retorna em um array na ordem que 
deverá ser processado
@author  Victor A. Barbosa
@since   19/10/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function Migr02Pend()

Local aArea      := GetArea()
Local cAliasPend := "rsTemp"
Local aEvtPend   := {}
Local aRet       := {}
Local aBkpEvt    := {}
Local nPos1070   := 0
Local nPos1000   := 0
Local nPos2300   := 0
Local nPos2200   := 0
Local nPos3000   := 0
Local nX         := 0

If Select(cAliasPend) > 0
    (cAliasPend)->( dbCloseArea() )
EndIf

BeginSQL Alias cAliasPend
    SELECT V2A_EVENTO FROM %table:V2A% V2A
    WHERE V2A_FILIAL = %xFilial:V2A%
    AND V2A_STATUS IN ( '1', '3' )
    AND V2A.%notdel%
    GROUP BY V2A_EVENTO
EndSQL

(cAliasPend)->( dbGoTop() )

While (cAliasPend)->( !Eof() )
    aAdd( aEvtPend, aEvtRot[ aScan(aEvtRot, {|x| x[4] == (cAliasPend)->V2A_EVENTO } ) ] )
    (cAliasPend)->( dbSkip() )
EndDo

nPos1000 := aScan( aEvtPend, {|x| AllTrim(x[4]) == "S-1000" } )

// Ignora o S-1000
If nPos1000 > 0 
    //aAdd( aRet, aEvtPend[nPos1000] )
    aDel(aEvtPend, nPos1000)
    aSize(aEvtPend, Len(aEvtPend) - 1 )
EndIf

nPos1070 := aScan( aEvtPend, {|x| AllTrim(x[4]) == "S-1070" } )

If nPos1070 > 0
    aAdd( aRet, aClone(aEvtPend[nPos1070]) )
    aDel(aEvtPend, nPos1070)
    aSize(aEvtPend, Len(aEvtPend) - 1 )
EndIf

aSort(aEvtPend, , , {|x,y|x[12] + x[4] < y[12] + y[4] })

nPos2300 := aScan( aEvtPend, {|x| x[4] == "S-2300" } )
nPos2200 := aScan( aEvtPend, {|x| x[4] == "S-2200" } )

// Coloca o 2300 logo na sequencia do 2200
If nPos2300 > 0 .And. nPos2200 > 0
    aBkpEvt                 := aClone( aEvtPend[nPos2200+1] ) // Faz um backup do próximo registro que está na fila (na sequência do S-2200)
    aEvtPend[nPos2200+1]    := aClone( aEvtPend[nPos2300] )   // Coloca o evento S-2300 logo na sequência do S-2200
    aEvtPend[nPos2300]      := aClone( aBkpEvt )              // Coloca o evento backup no antigo local do S-2300
EndIf

// Coloca o 3000 para a última posição se ele não estiver ...
nPos3000 := aScan( aEvtPend, {|x| x[4] == "S-3000" } )

If nPos3000 > 0 .And. nPos3000 <> Len(aEvtPend)
    aBkpEvt                     := aClone( aEvtPend[ Len(aEvtPend) ] ) // Faz o backup do registro que está na última posição
    aEvtPend[ Len(aEvtPend) ]   := aClone( aEvtPend[nPos3000] )        // Copia o S-3000 para a última posição
    aEvtPend[nPos3000]          := aClone( aBkpEvt )                   // Coloca o registro que estava na última posição na antiga posição do S-3000 (que foi migrador para a última)
EndIf

For nX := 1 To Len(aEvtPend)
    aAdd( aRet, aClone( aEvtPend[nX] ) )
Next nX

RestArea(aArea)

Return(aRet)

//-------------------------------------------------------------------
/*/{Protheus.doc} Migr02Tot
Geração dos eventos totalizadores
@author  Victor A. Barbosa
@since   24/10/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function Migr02Tot(cXmlTot, cEvento)

Local aArea     := GetArea()
Local aErros    := {}
Local aRetInt   := {}
Local nX        := 0
Local nPosIni   := 0
Local oXmlTot   := Nil
Local xEvtTot   := Nil
Local cEvtTot   := ""
Local cError    := ""
Local cWarning  := ""
Local cXmlConv  := ""

// Gravação dos 2 XMLs totalizadores
oXmlTot := XMLParser(cXmlTot, "_", @cError, @cWarning)

If Empty(cError) .And. Empty(cWarning)

    xEvtTot := XMLChildEX(oXmlTot:_EVENTO, "_TOT")

    If cEvento $ "S-1200|S-1210|S-2299"

        cXMLConv := XMLSaveStr(xEvtTot)
        
        nPosIni  := (At("eSocial", cXMLConv) - 1)
        cXmlConv := SubStr( cXMLConv, nPosIni )
        cEvtTot := xEvtTot:_TIPO:TEXT

        aErros := TafPrepInt( cEmpAnt, cFilAnt, cXmlConv,,"1", cEvtTot,,,,@aRetInt,.F.)

        If !aRetInt[1]
            aAdd( aErros, aRetInt[4] )
        EndIf

    Else

        For nX := 1 To Len(xEvtTot)
            
            aRetInt  := {}
            cXMLConv := XMLSaveStr(xEvtTot[nX])

            nPosIni := (At("eSocial", cXMLConv) - 1)
            cXmlConv := SubStr( cXMLConv, nPosIni )

	        cEvtTot := xEvtTot[nX]:_TIPO:TEXT

	        aErros := TafPrepInt(cEmpAnt,cFilAnt, cXmlConv, , "1", cEvtTot,,,,@aRetInt,.F.)

            If !aRetInt[1]
                aAdd( aErros, aRetInt[4] )
            EndIf

        Next nX

    EndIf

EndIf

// Limpa da memória as classes de interfaces criadas por XMLParser
DelClassIntF()

RestArea(aArea)

Return(aErros)

//-------------------------------------------------------------------
/*/{Protheus.doc} Migr02MThreads
Disponibiliza o pool de Threads
@author  Victor A. Barbosa
@since   19/10/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function Migr02MThreads(oSay, nNumThrd)

Local cFunExec  := "Migr02Integ"
Local oGrid     := Nil
Local nThreads  := nNumThrd //GetNewPar("MV_TAFMGTH")

oSay:setText("Alocando agentes secundários")
oSay:CtrlRefresh()

oGrid := FWIPCWait():New( cFunExec , 10000 )
oGrid:SetThreads(nThreads)
oGrid:SetEnvironment( cEmpAnt, cFilAnt )
oGrid:Start(cFunExec)

Sleep( 1000 * nThreads )

Return(oGrid)