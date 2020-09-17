#include 'totvs.ch
#include 'rwmake.ch'
#include 'protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ±±
±±ºPrograma  ³REL044CPO  ºAutor  ³ Marcelo Joner      º Data ³ 18/08/2020 º±±
±±ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ±±
±±ºDesc.     ³Ponto de entrada executado na impressão de Ct. Troca atravésº±±
±±º          ³de integração com o Microsoft Word.                         º±±
±±ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ±±
±±ºUso       ³ Especifico RISA SA                                         º±±
±±ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
User Function REL044CPO()

Local lRet      := .T.  
Local nI		:= 0
Local aArea     := GetArea()
Local cCodFil   := ""
Local cNomFil   := ""
Local cDetPrd   := ""
Local cDetQtd   := ""
Local cDetUm    := ""
Local cDetAco   := ""
Local cDetVUn   := ""
Local cDetVFr   := ""
Local cDetMoe   := ""
Local cDetVDs   := ""
Local cDetVTo   := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa impressão, caso o Ct. Troca esteja efetivado³
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
If !EMPTY(ZEN->ZEN_NUMCC)

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    //³Posiciona no registro referente aos insumos vinculados ao contrato de troca³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    dbSelectArea("ZEO")
    ZEO->(dbSetOrder(1))
    ZEO->(dbGoTop())
    If ZEO->(dbSeek(xFilial("ZEO") + ZEN->ZEN_NUM))
        While ZEO->(!EOF()) .AND. ZEO->ZEO_FILIAL == xFilial("ZEO") .AND. ZEO->ZEO_NUM == ZEN->ZEN_NUM
            
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
            //³Posiciona no cadastro do produto vinculado ao item do contrato de troca³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
            dbSelectArea("SB1")
            SB1->(dbSetOrder(1))
            SB1->(dbGoTop())
            SB1->(dbSeek(xFilial("SB1") + ZEO->ZEO_PRODUT))

            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
            //³Obtém descrição do produto³
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
            cDesPro := ALLTRIM(ZEO->ZEO_PRODUT) + " - " + ALLTRIM(ZEO->ZEO_DESPRO)

            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
            //³Realiza composição das variaveis com informações dos insumos³
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
            cCodFil += IIF(!EMPTY(cCodFil), cDetQbr, "") + ZEO->ZEO_FILFAT
            cNomFil += IIF(!EMPTY(cNomFil), cDetQbr, "") + POSICIONE("SM0", 1, cEmpAnt + ZEO->ZEO_FILFAT, "M0_FILIAL")
            cDetPrd += IIF(!EMPTY(cDetPrd), cDetQbr2, "") + cDesPro
            cDetQtd += IIF(!EMPTY(cDetQtd), cDetQbr, "") + ALLTRIM(TRANSFORM(ZEO->ZEO_QUANT, PESQPICT("ZEO", "ZEO_QUANT")))
            cDetUm  += IIF(!EMPTY(cDetUm) , cDetQbr, "") + ALLTRIM(ZEO->ZEO_UM)
            cDetAco += IIF(!EMPTY(cDetAco), cDetQbr, "") + ""
            cDetVUn += IIF(!EMPTY(cDetVUn), cDetQbr, "") + ALLTRIM(TRANSFORM(ZEO->ZEO_PRCVEN, PESQPICT("ZEO", "ZEO_PRCVEN")))
            cDetVDs += IIF(!EMPTY(cDetVDs), cDetQbr, "") + ALLTRIM(TRANSFORM(ZEO->ZEO_VALDES, PESQPICT("ZEO", "ZEO_VALDES")))
            cDetVFr += IIF(!EMPTY(cDetVFr), cDetQbr, "") + ALLTRIM(TRANSFORM(0, PESQPICT("ZEO", "ZEO_VALDES")))
            cDetMoe += IIF(!EMPTY(cDetMoe), cDetQbr, "") + "$"
            cDetVTo += IIF(!EMPTY(cDetVTo), cDetQbr, "") + ALLTRIM(TRANSFORM(ZEO->ZEO_TOTAL, PESQPICT("ZEO", "ZEO_TOTAL")))

            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
            //³Analisa descrição do produto para identificar o número de quebras por linha³
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
            nPos := 1
            nQbrLin  := 1
            cDetQbr  := ""
            cDetQbr2 := ""
            While .T.
                If EMPTY(SUBSTR(cDesPro, nPos, 32))
                    exit
                Else
                nQbrLin++ 
                nPos += 33
                EndIf
            End

            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
            //³Compõe variavel de controle de quebra³
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
            For nI := 1 To nQbrLin
                cDetQbr  += CRLF

                If nQbrLin == 2
                    cDetQbr2 += CRLF
                Else
                    cDetQbr2 += IIF(nI > 1, CRLF, "")
                EndIf
            Next nI
            
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
            //³Avança para o próximo registro³
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
            ZEO->(dbSkip())
        End

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        //³Cria variaveis em memória³
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        OLE_SetDocumentVat(oWord,"%cCodFil", cCodFil)
        OLE_SetDocumentVat(oWord,"%cNomFil", cNomFil)
        OLE_SetDocumentVat(oWord,"%cDetPrd", cDetPrd)
        OLE_SetDocumentVat(oWord,"%cDetQtd", cDetQtd)
        OLE_SetDocumentVat(oWord,"%cDetUm" , cDetUm)
        OLE_SetDocumentVat(oWord,"%cDetAco", cDetAco)
        OLE_SetDocumentVat(oWord,"%cDetVUn", cDetVUn)
        OLE_SetDocumentVat(oWord,"%cDetVDs", cDetVDs)
        OLE_SetDocumentVat(oWord,"%cDetVTo", cDetVTo)
        OLE_SetDocumentVat(oWord,"%cDetMoe", cDetMoe)
        OLE_SetDocumentVat(oWord,"%cDetVFr", cDetVFr)
    EndIf
Else
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    //³Alerta o usuário e aborta impressão do Ct. Troca³
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    Help(NIL, NIL, "Atenção", NIL, "O Ct. Troca selecionado para impressão não está efetivado.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Somente é possível realizar à impressão de contratos que já estejam efetivados."})
    lRet := .F.
EndIf

RestArea(aArea)

Return lRet
