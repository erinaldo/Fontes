#include "protheus.ch"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} MTA130C8
Ponto de Entrada executado apos gravacao de cada item no SC8
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function MTA130C8()
local _lRet := .T.

Reclock("SC8",.F.)
SC8->C8_XSOLICI = cUserName
MsUnLock()

Return(_lRet)