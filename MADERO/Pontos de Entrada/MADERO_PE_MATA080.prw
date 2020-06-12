#include 'protheus.ch'



/*/{Protheus.doc} MA080MNU
PE para adicionar opções no menu do browse

@author Rafael Ricardo Vieceli
@since 15/03/2018
@version 1.0

@type function
/*/
user function MA080MNU()

	Local aCopia := {}

	Aadd(aCopia, { "Simples",  "u_MMat080Simple" , 0 ,0,0, NIL })
	Aadd(aCopia, { "Lote"   ,  "u_MMat080Lot" , 0 ,0,0, NIL })
	aAdd(aRotina, { "Copia",  aCopia , 0 ,0,0, NIL })

return