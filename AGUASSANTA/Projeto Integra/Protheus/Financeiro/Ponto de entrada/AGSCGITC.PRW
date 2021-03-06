#include "Protheus.ch"                                                                      

//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTBA6S
@Gera integra��o de itens cont�beis com RM - Job
@param                              {Grupo, Empresa, Codigo}
@           Job: U_ASCTBA6S({"01","0110001","001","email"})
@return                              Nenhum
@author             Sotello
@since                                15/03/2018
@version            1.0
@project            MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------
USER FUNCTION AGSCGITC(aParam)         
CONOUT("INICIO DO JOB - CARGA ITEM CONTABIL")
CONOUT("Grupo: "+aParam[1])
CONOUT("Empresa: "+aParam[2])
CONOUT("C�digo: "+aParam[3])

RpcSetType( 3 )
RpcSetEnv( aParam[1], aParam[2],,,'CTB')          

// COLOCAR A CHAMADA DA ROTINA
U_CGITMCTB()

RpcClearEnv()                         
CONOUT("FIM DO JOB DE CARGA ITEM CONTABIL")
RETURN

