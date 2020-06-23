#include 'protheus.ch'
#include 'parmtype.ch'

user function MTA416PV()

//Trecho Padrão. Variaveis disponiveis no Ponto de Entrada
//_aCols     := aColsC6
//_aHeader    := aHeadC6

Local _nI			:= 0
Local nSaldoAtu 	:= 0
Local cProd, cLocal

For _nI := 1 to Len(_aCols)

	cProd	:= 	_acols[_nI,ascan(_aHeader,{|x| alltrim(x[2]) == "C6_PRODUTO" })]
	cLocal	:= 	_acols[_nI,ascan(_aHeader,{|x| alltrim(x[2]) == "C6_LOCAL" })]
	
	SB2->( dbSetOrder(1) )
	If SB2->( dbSeek(xFilial("SB2") + cProd+cLocal ) )
		nSaldoAtu := SaldoSB2()
		If nSaldoAtu > 0			
			_acols[_nI,ascan(_aHeader,{|x| alltrim(x[2]) == "C6_XQTDEST" })] := nSaldoAtu 
//			_acols[_nI,ascan(_aHeader,{|x| alltrim(x[2]) == "C6_XRESSLD" })] := SB2->B2_RESERVA
		EndIf
	EndIf

Next _nI
	
return()