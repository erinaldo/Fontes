#INCLUDE "TOTVS.CH"

/*/

{Protheus.doc} SF2460I.PRW
                 
Ponto de Entrada utilizado para criar a CD6, nos casos de Transferencia de COMBUSTIVEL

@author  Milton J.dos Santos	
@since   12/08/2020
@version 1.0

/*/

User Function SF2460I
Local aArea     := GetArea()
 
IF SF2->F2_TIPO == 'N' .AND. SB1->B1_GRUPO $ GETMV("MV_COMBUS")
    DbSelectArea("CD6")
    CD6->( DbSetOrder(1) )  // Chave: CD6_FILIAL + CD6_TPMOV + CD6_SERIE + CD6_DOC + CD6_CLIFOR + CD6_LOJA + CD6_ITEM + CD6_COD + CD6_PLACA  + CD6_TANQUE  
    DbSelectArea("SB1")
    SB1->( DbSetOrder(1) )  // Chave: B1_FILIAL + B1_COD
    DbSelectArea("C0G")
    C0G->( DbSetOrder(7) )  // Chave: C0G_FILIAL + C0G_CODIGO
    DbSelectArea("SD2")
    SD2->( DbSetOrder(3) )  // Chave: D2_FILIAL + D2_DOC + D2_SERIE + D2_CLIENTE + D2_LOJA 
 
    If SF2->( DBSEEK( xFilial("SD2") + F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA ) )
        Do While SD2->( D2_FILIAL + D2_DOC + D2_SERIE + D2_CLIENTE + D2_LOJA ) == SF2->( XFILIAL("SD2") + F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA )
            DbSelectArea("SB1")
            IF DbSeek( xFilial("SB1") + SD2->D2_COD )
                DbSelectArea("C0G")
                If DbSeek( xFilial("C0G") + SB1->B1_XCODANP )
                    DbSelectArea("CD6")
                    If DbSeek( SD2->D2_FILIAL + "S" + SD2->D2_SERIE + SD2->D2_DOC + SF2->F2_CLIENTE + SF2->F2_LOJA + SD2->D2_ITEM  )
                        Reclock("CD6",.F.)
                    Else
                        RecLock("CD6",.T.)
                        CD6_FILIAL  := xFilial("CD6")
                        CD6_TPMOV   := "S"
                        CD6_DOC     := SD2->D2_DOC          // NUMERO DA NF
                        CD6_TRANSP  := SF2->F2_TRANSP       // TRANSPORTADORA
                        CD6_SERIE   := SD2->D2_SERIE        // NUMERO DE SERIE DA NF
                        CD6_CLIFOR  := SD2->D2_CLIENTE      // CODIGO DO CLIENTE
                        CD6_LOJA    := SD2->D2_LOJA         // LOJA DO CLIENTE
                        CD6_ITEM    := SD2->D2_ITEM         // SEQUENCIA DO ITEM
                        CD6_COD     := SD2->D2_COD          // CODIGO DO PRODUTO
                        CD6_UFCONS  := SF2->F2_EST          // UNIDADE FEDERATIVA DO CONSUMIDOR
                    Endif
                    CD6_CODANP  :=  C0G->C0G_CODIGO         // CODIGO ANP
                    CD6_DESANP  :=  C0G->C0G_DESCRI         // DESCRICAO ANP
                    CD6->( MsUnLock() )
                Endif
            Endif
            DbSelectArea("SD2")
            SD2->(DbSkip())
        ENDDO
    Endif
    CD6->( DbCloseArea() )
Endif

RestArea(aArea)

RETURN()
