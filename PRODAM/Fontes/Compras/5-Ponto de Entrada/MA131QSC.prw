#Include 'Protheus.ch'

User Function MA131QSC()
Local bQuebra := paramixb[1] 

bQuebra := {|| C1_FILENT+C1_GRADE+C1_FORNECE+C1_LOJA+C1_PRODUTO+C1_DESCRI+DTOS(C1_DATPRF)+C1_CC+C1_CONTA+C1_ITEMCTA+C1_CLVL+DTOS(C1_XDTDOT)}

Return bQuebra

