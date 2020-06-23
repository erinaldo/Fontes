#Include 'Protheus.ch'
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FA590AROT
Ponto de entrada adiciona Menu - Permite enviar aprovação de Borderô para Procuradores
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function FA590AROT()
Local aRotNew:=Paramixb[1]

If IsInCallStak('FIN590PAG')//Bordero de Pagamentos
	Aadd(aRotNew,{"Envio Procurador", "U_CFINE22" , 0 , 4})
	aadd(aRotNew,{"Consulta aprovação","U_CFINE23",0, len(aRotNew)+1})
EndIf

Return(aRotNew)
