#INCLUDE "rwmake.ch"    
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CESTE15
Valida preenchimento e amarração conta x centro de custo x item conta x classe de valor 
@author     Totvs
@since     	01/01/2014
@version  	P.11      
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum
Alterações Realizadas desde a Estruturação Inicial
------------+-----------------+----------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                                                                                 
------------+-----------------+----------------------------------------------------------
		  	|				  | 
------------+-----------------+----------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
User Function CESTE15()   
local lRet		:= .T.
Local nPsCta	:= aScan(aHeader, {|x| AllTrim(x[2]) == "D1_CONTA"})
Local nPsCC		:= aScan(aHeader, {|x| AllTrim(x[2]) == "D1_CC"})   
Local nPsItem	:= aScan(aHeader, {|x| AllTrim(x[2]) == "D1_ITEMCTA"})
Local nPsClvl	:= aScan(aHeader, {|x| AllTrim(x[2]) == "D1_CLVL"})

// Alterado para função CTBAMARRA
if nPsCta > 0 .and. nPsCC > 0 .and. nPsItem > 0 .and. nPsClvl > 0
	lRet:= CtbAmarra(aCols[n,nPsCta],aCols[n,nPsCC],aCols[n,nPsItem],aCols[n,nPsClvl], .T.)
	if lRet
		lRet:= CtbObrig(aCols[n,nPsCta],aCols[n,nPsCC],aCols[n,nPsItem],aCols[n,nPsClvl],.T.,"1") 	
	endif	
endif

Return (lRet)