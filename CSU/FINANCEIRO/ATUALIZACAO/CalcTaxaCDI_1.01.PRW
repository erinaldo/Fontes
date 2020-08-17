#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'

USER FUNCTION CalcTaxaCDI()

Private nTaxaAc   := 0 

processa({|| _Proc()}, 'Apurando Valores...')   

Return(nTaxaAc)

Static Function _Proc()

Local nTaxaDia  := 0
Local dDataAtu  := SEH->EH_DATA
Local dDataApl  := SEH->EH_DATA
Local nMoeda    := SEH->EH_MOEDA
Local _nTxNeg 	:= SEH->EH_TAXA
Local _nValor   := SEH->EH_VALOR
Local _nSaldo   := SEH->EH_SALDO
Local _cNum     := SEH->EH_NUMERO

ProcRegua(dDataBase - dDataApl)


WHILE dDataAtu <= dDataBase    

	IncProc("Dia: "+DTOC(dDataAtu))
	
	If dDataAtu <> dDataApl
		
		If DataValida(dDataAtu,.F.) == dDataAtu
			
			nTaxaDia := (((_nTxNeg/100)*RECMOEDA(dDataAtu,nMoeda)))
			
			_nValor := _nValor + (_nValor * nTaxaDia) - _ValResg(dDataAtu,_cNum)
			
			//		nTaxaAc *= (((_nTxNeg/100)*RECMOEDA(dDataAtu,nMoeda))+1)
			
		EndIf
		
	EndIf
	dDataAtu++
EndDo

nTaxaAc := _nValor / _nSaldo

Return


//EI_FILIAL+EI_APLEMP+EI_NUMERO

Static Function _ValResg(_data,_cnum)

_cQuery := " SELECT SUM(EI_VALOR) AS VALOR  FROM SEI010 "
_cQuery += " WHERE EI_NUMERO = '"+_cNum+"' AND D_E_L_E_T_ <> '*'  AND "
_cQuery += " EI_FILIAL = '"+xFilial("SEI")+"' AND EI_APLEMP = 'APL'  "
_cQuery += " AND EI_TIPODOC = 'RG' AND EI_DATA = '"+DTOS(_data)+"' "
_cQuery += " GROUP BY EI_DATA "

If Select("_CALC") >0
	DBSelectArea("_CALC")
	DBCloseArea()
EndIf

TCQUERY _cQuery NEW ALIAS "_CALC"

DBSelectArea("_CALC")
DBGotop()

If !EOF()
	_nRet := _CALC->VALOR
Else
	_nRet := 0
EndIf

DBCloseArea()
Return(_nRet)
