/*---------------------------------------------------------------------------------------
{Protheus.doc} F240OK
P.E. para validar cancelamento do Border�.

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
@project    CIEE - Revitaliza��o
@menu    	Nenhum
@history    Nenhum
---------------------------------------------------------------------------------------*/
User Function F240OK()
Local lRet:=.T.
Local aArea:=GetArea()
dbSelectArea('SE2')
dbSetORder(15)
If dbSeek(xFilial('SE2')+SEA->EA_NUMBOR)
	If !Empty(E2_XSTSAPV)    
		MsgAlert('Border� em processo de aprova��o de al�adas.')
		lRet:=.F.            
	EndIf
endIf
RestArea(aArea)
Return