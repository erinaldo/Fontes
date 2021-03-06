#include 'totvs.ch
#include 'rwmake.ch'
#include 'protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������ͱ�
���Programa  �REL044CPO  �Autor  � Marcelo Joner      � Data � 18/08/2020 ���
��������������������������������������������������������������������������ͱ�
���Desc.     �Ponto de entrada executado na impress�o de Ct. Troca atrav�s���
���          �de integra��o com o Microsoft Word.                         ���
��������������������������������������������������������������������������ͱ�
���Uso       � Especifico RISA SA                                         ���
��������������������������������������������������������������������������ͱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

//������������������������������������������������������
//�Executa impress�o, caso o Ct. Troca esteja efetivado�
//������������������������������������������������������
If !EMPTY(ZEN->ZEN_NUMCC)

    //�����������������������������������������������������������������������������
    //�Posiciona no registro referente aos insumos vinculados ao contrato de troca�
    //�����������������������������������������������������������������������������
    dbSelectArea("ZEO")
    ZEO->(dbSetOrder(1))
    ZEO->(dbGoTop())
    If ZEO->(dbSeek(xFilial("ZEO") + ZEN->ZEN_NUM))
        While ZEO->(!EOF()) .AND. ZEO->ZEO_FILIAL == xFilial("ZEO") .AND. ZEO->ZEO_NUM == ZEN->ZEN_NUM
            
            //�������������������������������������������������������������������������
            //�Posiciona no cadastro do produto vinculado ao item do contrato de troca�
            //�������������������������������������������������������������������������
            dbSelectArea("SB1")
            SB1->(dbSetOrder(1))
            SB1->(dbGoTop())
            SB1->(dbSeek(xFilial("SB1") + ZEO->ZEO_PRODUT))

            //����������������������������
            //�Obt�m descri��o do produto�
            //����������������������������
            cDesPro := ALLTRIM(ZEO->ZEO_PRODUT) + " - " + ALLTRIM(ZEO->ZEO_DESPRO)

            //��������������������������������������������������������������
            //�Realiza composi��o das variaveis com informa��es dos insumos�
            //��������������������������������������������������������������
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

            //�����������������������������������������������������������������������������
            //�Analisa descri��o do produto para identificar o n�mero de quebras por linha�
            //�����������������������������������������������������������������������������
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

            //���������������������������������������
            //�Comp�e variavel de controle de quebra�
            //���������������������������������������
            For nI := 1 To nQbrLin
                cDetQbr  += CRLF

                If nQbrLin == 2
                    cDetQbr2 += CRLF
                Else
                    cDetQbr2 += IIF(nI > 1, CRLF, "")
                EndIf
            Next nI
            
            //��������������������������������
            //�Avan�a para o pr�ximo registro�
            //��������������������������������
            ZEO->(dbSkip())
        End

        //���������������������������
        //�Cria variaveis em mem�ria�
        //���������������������������
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
    //��������������������������������������������������
    //�Alerta o usu�rio e aborta impress�o do Ct. Troca�
    //��������������������������������������������������
    Help(NIL, NIL, "Aten��o", NIL, "O Ct. Troca selecionado para impress�o n�o est� efetivado.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Somente � poss�vel realizar � impress�o de contratos que j� estejam efetivados."})
    lRet := .F.
EndIf

RestArea(aArea)

Return lRet
