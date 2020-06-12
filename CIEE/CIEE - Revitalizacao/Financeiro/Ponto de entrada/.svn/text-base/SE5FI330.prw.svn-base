#INCLUDE "PROTHEUS.CH" 

/*---------------------------------------------------------------------------------------
{Protheus.doc} SE5FI330
Ponto de Entrada que permite realizar gravações complementares na tabela SE5

@class		Nenhum
@from 		Nenhum
@param    	Nenhum
@attrib    	Nenhum
@protected  Nenhum
@author     AF Custom
@version    P.11
@since      01/10/2014
@return    	Nenhum
@sample   	Nenhum
@obs      	Nenhum
@project    CIEE - Revitalização
@menu    	Nenhum
@history    Nenhum
---------------------------------------------------------------------------------------*/

User Function SE5FI330()

if isincallstack("u_CFINA02")     
    reclock("SZ8",.F.) 
    	SZ8->Z8_CI:= SZ8->Z8_CI + SE5->E5_VALOR 
    msunlock()    
EndIf

return