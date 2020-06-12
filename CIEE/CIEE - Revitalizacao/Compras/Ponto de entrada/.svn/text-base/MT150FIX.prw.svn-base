#Include 'Protheus.ch'
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} MT150FIX
Ponto de entrada para alteracao da ordem dos campos do PARAMIXB 
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function MT150FIX()
Local aRet	 	:= {}
Local nCnt		:= 0

for nCnt:= 1 to len(PARAMIXB)
	aadd(aRet,PARAMIXB[nCnt])	
	if trim(PARAMIXB[nCnt][2])== "C8_LOJA"
		aadd(aRet,{RetTitle("C8_XFORNOM"),"C8_XFORNOM"})
	elseif trim(PARAMIXB[nCnt][2])== "C8_PRODUTO"
		aadd(aRet,{RetTitle("C8_DESCRI"),"C8_DESCRI"})
	endif
next

Return aRet

