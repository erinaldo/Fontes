#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "TryException.ch"
#Include "rwmake.ch"
#Include "TBICONN.CH"

/*-----------------+---------------------------------------------------------+
!Nome              ! COM103 - Cliente: Madero                                !
+------------------+---------------------------------------------------------+
!Descrição         ! Gerar pedidos de venda na central                       !
+------------------+---------------------------------------------------------+
!Autor             ! Pedro A. de Souza                                       !
+------------------+---------------------------------------------------------!
!Data              ! 28/05/2018                                              !
+------------------+--------------------------------------------------------*/
User Function COM103(paramixb)
// Parametros recebidos da rotina "pai"
Local _cEmpresa := paramixb[1,1] // Empresa destino (da fábrica)
Local _cFilial  := paramixb[1,2] // Filial destino (da fábrica)
Local cGrupoEmp := paramixb[1,3] // Grupo de Empresas originais (de onde buscar os PCs - obtido a partir do cEmpAnt) 
Local cFilOri   := paramixb[1,4] // Filial Original do Pedido
Local cCNPJCli  := paramixb[1,5] // CNPJ do cliente do Pedido
Local dDataInc  := paramixb[1,7] // Data de inclusao do pedido
Local cUsrincl  := paramixb[1,8] // Usuario de inclusao do pedido
Local cNumPed   := "" 
Local cAliTmp0  := GetNextAlias()
Local cOpVdaUN  := ""
Local cQuery    := ""
Local aLinha    := {}
Local aItens    := {}
Local aCabec    := {}
Local aRetCM103 := {}
Local cPathTmp  := "\temp\"
Local cFileErr  := ""
Local cTes      := ""
Local nk        := 0 
Local nY        := 0
Local nPos      := 0
Local cItemSC6  := "01"
Local aQuery    := {}
Local cNumPedAux:= ""
Local aTables := {"SA1","SA2","SA3","SA4","SB1","SB2","SC2","SC3","SC4","SC6","SED","SE4","SX5","SBM"}
Private lMsErroAuto := .f. 

    // -> Agura numero de pedidos de compra
    cNumPed:=""
    AADD(aRetCM103,{})
    AADD(aRetCM103,{})
    For nk:=1 to Len(paramixb)
        cNumPed:=cNumPed+"'"+paramixb[nk,6]+"',"
    Next nk 
    cNumPed:=IIF(Empty(cNumPed),"'ZZZZZZ'",SubStr(cNumPed,1,Len(cNumPed)-1))
    ConOut(cNumPed)
    // Composicao do nome das tabelas dos restaurantes
    //  ConOut("Chamada do pedido venda ")
    //  varinfo('paramixb', paramixb)
    If len(cGrupoEmp) = 2
        cGrupoEmp += "0"
    Endif
    ConOut(cGrupoEmp)
    //PREPARE ENVIRONMENT Empresa _cEmpresa filial _cFilial Tables "SA1","SA2","SA3","SA4","SB1","SB2","SC2","SC3","SC4","SC6","SED","SE4","SX5","SBM" Modulo "FAT"
    RpcSetType( 3 )
    RpcSetEnv( _cEmpresa,_cFilial, , , "FAT", , aTables, , , ,  )
        // -> Verifica operação fiscal
        cOpVdaUN:=GetMv("MV_XOPVDUN",,"")
        If AllTrim(cOpVdaUN) == ""
            aadd(aRetCM103[1],{cFilOri,"TODOS","FIS","","Operacao fisval invalida. [MV_XOPVDUN = Vazio]",cFilOri+"TODOS"})
        EndIf
        
        // -> Posiciona no cliente
        SA1->(DbSetOrder(3))
        If !SA1->(DbSeek(xFilial("SA1")+cCNPJCli))
            aadd(aRetCM103[1],{cFilOri,"TODOS","SA1","","Cliente nao encontrado: [A1_CGC = " + cCNPJCli+"]",cFilOri+"TODOS"})
        Else
            // -> Posiciona na natureza
            SED->(DbSetOrder(1))
            If !SED->(DbSeek(xFilial("SED")+SA1->A1_NATUREZ))
                aadd(aRetCM103[1],{cFilOri,"TODOS","SA1",SA1->A1_COD+SA1->A1_LOJA,"Natureza nao encontrada na industria: [A1_NATUREZ = " + SA1->A1_NATUREZ+"]",cFilOri+"TODOS"})
            EndIf

            // -> Posiciona na condicao de pagamento
            SE4->(DbSetOrder(1))
            If !SE4->(DbSeek(xFilial("SE4")+SA1->A1_COND))
                aadd(aRetCM103[1],{cFilOri,"TODOS","SA1",SA1->A1_COD+SA1->A1_LOJA,"Condicao de pagamento nao encontrada na industria: [A1_COND = " + SA1->A1_COND+"]",cFilOri+"TODOS"})
            EndIf

            // -> Posiciona no vendedor
            SA3->(DbSetOrder(1))
            If !SA3->(DbSeek(xFilial("SA3")+SA1->A1_VEND))
                aadd(aRetCM103[1],{cFilOri,"TODOS","SA1",SA1->A1_COD+SA1->A1_LOJA,"Vendedor nao encontrado na industria: [A1_VEND = " + SA1->A1_VEND+"]",cFilOri+"TODOS"})
            EndIf

            // -> Posiciona na transportadora
            SA4->(DbSetOrder(1))
            If !SA4->(DbSeek(xFilial("SA4")+SA1->A1_TRANSP))
                aadd(aRetCM103[1],{cFilOri,"TODOS","SA1",SA1->A1_COD+SA1->A1_LOJA,"Transportadora nao encontrada na industria: [A1_TRANSP = " + SA1->A1_TRANSP+"]",cFilOri+"TODOS"})
            EndIf
        EndIf

        If Len(aRetCM103[1]) <= 0
            aQuery := STRTOKARR(cNumPed, ",")
            cNumPedAux := ""
            If Len(aQuery) <= 500
                For nk:=1 to Len(paramixb)
                    cNumPedAux:=cNumPedAux+"'"+paramixb[nk,6]+"',"
                Next nk 
                cNumPedAux:=IIF(Empty(cNumPedAux),"'ZZZZZZ'",SubStr(cNumPedAux,1,Len(cNumPedAux)-1))
                
                cQuery  := "SELECT C7_NUM, C7_ITEM, C7_PRODUTO, C7_XCODPRF, C7_EMISSAO, C7_DATPRF, C7_XOBS, SUM(C7_QUANT) C7_QUANT, SUM(C7_PRECO)/COUNT(*) C7_PRECO, SUM(C7_XQTDPRF) C7_XQTDPRF " //A5_XTPCUNF, A5_XCVUNF"
                cQuery  += " FROM SC7" + cGrupoEmp + " SC7 "
                cQuery  += " WHERE SC7.C7_FILIAL  = '" + cFilOri + "' "
                cQuery  += "   AND SC7.C7_NUM    IN (" + cNumPedAux + ") "
                cQuery  += "   AND SC7.D_E_L_E_T_ = ' '               "
                cQuery  += " GROUP BY C7_NUM, C7_ITEM, C7_PRODUTO, C7_XCODPRF, C7_EMISSAO, C7_DATPRF, C7_XOBS"
            Else
                nPos        := 1
                cNumPedAux  := ""
                cQuery      := ""
                For nY:=1 to Len(aQuery)
                    If nPos < 500 .And. nY < Len(aQuery)
                        cNumPedAux:=cNumPedAux+aQuery[nY]+","
                        nPos := nPos + 1
                    Else
                        If nY == Len(aQuery)
                            cNumPedAux:=cNumPedAux+aQuery[nY]
                        Else
                            cNumPedAux:=SubStr(cNumPedAux,1,Len(cNumPedAux)-1)
                        EndIf
                        If nY <= 500
                            cQuery  := "SELECT C7_NUM, C7_ITEM, C7_PRODUTO, C7_XCODPRF, C7_EMISSAO, C7_DATPRF, C7_XOBS, SUM(C7_QUANT) C7_QUANT, SUM(C7_PRECO)/COUNT(*) C7_PRECO, SUM(C7_XQTDPRF) C7_XQTDPRF " //A5_XTPCUNF, A5_XCVUNF"
                            cQuery  += " FROM SC7" + cGrupoEmp + " SC7 "
                            cQuery  += " WHERE SC7.C7_FILIAL  = '" + cFilOri + "' "
                            cQuery  += "   AND SC7.C7_NUM    IN (" + cNumPedAux + ") "
                            cQuery  += "   AND SC7.D_E_L_E_T_ = ' '               "
                            cQuery  += " GROUP BY C7_NUM, C7_ITEM, C7_PRODUTO, C7_XCODPRF, C7_EMISSAO, C7_DATPRF, C7_XOBS"
                        Else
                            cQuery  += " UNION ALL "
                            cQuery  += "SELECT C7_NUM, C7_ITEM, C7_PRODUTO, C7_XCODPRF, C7_EMISSAO, C7_DATPRF, C7_XOBS, SUM(C7_QUANT) C7_QUANT, SUM(C7_PRECO)/COUNT(*) C7_PRECO, SUM(C7_XQTDPRF) C7_XQTDPRF " //A5_XTPCUNF, A5_XCVUNF"
                            cQuery  += " FROM SC7" + cGrupoEmp + " SC7 "
                            cQuery  += " WHERE SC7.C7_FILIAL  = '" + cFilOri + "' "
                            cQuery  += "   AND SC7.C7_NUM    IN (" + cNumPedAux + ") "
                            cQuery  += "   AND SC7.D_E_L_E_T_ = ' '               "
                            cQuery  += " GROUP BY C7_NUM, C7_ITEM, C7_PRODUTO, C7_XCODPRF, C7_EMISSAO, C7_DATPRF, C7_XOBS"
                        EndIf
                        cNumPedAux := ""
                        nPos := 1
                    EndIf
                Next nY
            EndIf
            dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliTmp0,.T.,.T.)
            (cAliTmp0)->(dbGoTop())
            
            dDataBase := stod((cAliTmp0)->C7_EMISSAO) 
            aItens := {}
            aCabec := {}
            aAdd(aCabec, {"C5_TIPO"     , "N"                           , Nil})
            aAdd(aCabec, {"C5_CLIENTE"  , SA1->A1_COD                   , Nil})
            aAdd(aCabec, {"C5_LOJACLI"  , SA1->A1_LOJA                  , Nil})
            aAdd(aCabec, {"C5_TRANSP"   , SA4->A4_COD                   , Nil})
            aAdd(aCabec, {"C5_CONDPAG"  , SE4->E4_CODIGO                , Nil})
            aAdd(aCabec, {"C5_EMISSAO"  , dDataBase                     , Nil})
            aAdd(aCabec, {"C5_NATUREZ"  , SED->ED_CODIGO                , Nil})
            aAdd(aCabec, {"C5_TPFRETE"  , 'C'                           , Nil})
            aAdd(aCabec, {"C5_TRANSP"   , SA4->A4_COD                   , Nil})
            aAdd(aCabec, {"C5_TPCARGA"  , "1"                           , Nil})
            aAdd(aCabec, {"C5_XDTINC"   , dDataInc                      , Nil})
            aAdd(aCabec, {"C5_XUSERI"   , cUsrincl                      , Nil})
            cTes    :=""
            lOk     :=.T.
            cItemSC6:="01"
            While !(cAliTmp0)->(eof()) 

                // -> Inicia geração dos logs 
                nAux:=aScan(aRetCM103[1],{|x| Alltrim(x[3]) == "SB1" .and. AllTrim(x[4]) == AllTrim((cAliTmp0)->C7_XCODPRF)})               
                SB1->(dbSetOrder(1))                
                If !SB1->(dbSeek(xFilial("SB1")+(cAliTmp0)->C7_XCODPRF))
                    aadd(aRetCM103[1],{cFilOri,(cAliTmp0)->C7_NUM,"SB1",(cAliTmp0)->C7_XCODPRF,"Produto nao encontrado no cadastro da industria.",cFilOri+(cAliTmp0)->C7_NUM})
                    lOk:=.F.   
                Else
                    // -> Pega a TES da operação
                    cTes:=MaTESInt(2,cOpVdaUN,SA1->A1_COD,SA1->A1_LOJA,"C",SB1->B1_COD)
                    SF4->(dbSetOrder(1))
                    If !SF4->(dbSeek(xFilial("SF4")+cTes))
                        aadd(aRetCM103[1],{cFilOri,(cAliTmp0)->C7_NUM,"SB1",(cAliTmp0)->C7_XCODPRF,"TES nao encontrada para o produto. [F4_CODIGO = "+cTes+"]",cFilOri+(cAliTmp0)->C7_NUM})
                        lOk:=.F.
                    EndIf
                    // -> Verifica a quantidade do pedido de compra
                    If (cAliTmp0)->C7_XQTDPRF <= 0
                        aadd(aRetCM103[1],{cFilOri,(cAliTmp0)->C7_NUM,"SB1",(cAliTmp0)->C7_XCODPRF,"Quantidade do produto para o fornecedor invalida no pedido de compra. [C7_XQTDPRF = 0.0000]",cFilOri+(cAliTmp0)->C7_NUM})
                        lOk:=.F.
                    EndIf
                Endif
                aLinha := {}
                aAdd(aLinha, {"C6_ITEM"      , cItemSC6                     , Nil})
                aAdd(aLinha, {"C6_PRODUTO"   , SB1->B1_COD                  , Nil})
                aAdd(aLinha, {"C6_QTDVEN"    , (cAliTmp0)->C7_XQTDPRF       , Nil})
                aAdd(aLinha, {"C6_PRUNIT"    , (cAliTmp0)->C7_PRECO         , Nil})   
                aAdd(aLinha, {"C6_PRCVEN"    , (cAliTmp0)->C7_PRECO         , Nil})   
                aAdd(aLinha, {"C6_TES"       , cTes                         , Nil})
                aAdd(aLinha, {"C6_ENTREG"    , stod((cAliTmp0)->C7_DATPRF)  , Nil})
                aAdd(aLinha, {"C6_XFILORI"   , cFilOri                      , Nil})
                aAdd(aLinha, {"C6_NUMPCOM"   , (cAliTmp0)->C7_NUM           , Nil})
                aAdd(aLinha, {"C6_ITEMPC"    , (cAliTmp0)->C7_ITEM          , Nil})
                if !empty((cAliTmp0)->C7_XOBS)
                    aAdd(aLinha, {"C6_XOBS"      , (cAliTmp0)->C7_XOBS      , Nil})
                Endif
                cItemSC6:=Soma1(cItemSC6)
                aAdd(aItens, aLinha)
                (cAliTmp0)->(dbSkip())
            EndDo 
            If Len(aRetCM103[1]) <= 0 .and. len(aItens) > 0
                // -> Grava o Pedido de Venda
                MsExecAuto({|x, y, z| mata410(x, y, z)}, aCabec, aItens, 3)
                If lMsErroAuto
                    cFileErr := "pv_"+cFilOri+"_"+(cAliTmp0)->C7_NUM+"_"+strtran(time(),":","")
                    MostraErro(cPathTmp, cFileErr)
                    cFileErr := memoread(cPathTmp+cFileErr)
                    aadd(aRetCM103[1],{cFilOri,"TODOS","SC5","","Erro ao gerar o pedido de venda na industria: "+ Chr(13) + Chr(10) + cFileErr,cFilOri+"TODOS"})
                Endif
            Endif
            (cAliTmp0)->(dbCloseArea())         
        EndIf
    
    //RESET ENVIRONMENT
    RpcClearEnv()

    If Len(aRetCM103[1]) <= 0
        aadd(aRetCM103[1],{cFilOri,"TODOS","SC7","","Nao ha pedidos para liberar.",cFilOri+"TODOS"})
    EndIf

Return aRetCM103
