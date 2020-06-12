#include "Protheus.ch"

/*---------------------------------------------------------------------------------------
{Protheus.doc} CT20ALTD
P.E na alteração de Conta Contabil - Marca registro para ser enviado via EAI

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
User Function CT20ALTD()

dbSelectArea('CT1')
RecLock('CT1',.F.)
CT1_XENVWS:='1'//Conta enviada = Não
msUnLock()


Return