#INCLUDE "TOTVS.CH"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} MTA140MNU
@Descri��o  Insere novas op��es no array aRotina - Pr� Nota
@author     Totvs
@since     	01/08/2014
@version  	P.11      
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum
Altera��es Realizadas desde a Estrutura��o Inicial
------------+-----------------+----------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                                                                                 
------------+-----------------+----------------------------------------------------------
		  	|				  | 
------------+-----------------+----------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
USER FUNCTION MTA140MNU()
LOCAL aRotAux	:= {} 
LOCAL nCnt		:= 0   

FOR nCnt:=1 TO LEN(aRotina)
	AADD(aRotAux,aRotina[nCnt])
NEXT nCnt

AADD(aRotAux,{"Conhecimento" , "U_CCOME04('SF1')" ,0,6})

aRotina:= ACLONE(aRotAux)
RETURN