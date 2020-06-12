//ESTOQUE CUSTOS
//GATILHO NO CAMPO SD3->D3_COD PARA O CAMPO D3_SLDEST
//SUBSTITUIDO A FUNCAO PADRAO A240CAT83()
User Function CESTM03()

_nQtdDisp	:= 0
_cAnoCont	:= Year(dDataBase)+1
_nSaldo 	:= CalcEst(SB1->B1_COD, SB1->B1_LOCPAD, LastDay(ctod("01/12/"+Str(_cAnoCont,4))))

_nQtdDisp 	:= iif(!Empty(_nSaldo),_nSaldo[1],0)

Return(_nQtdDisp)