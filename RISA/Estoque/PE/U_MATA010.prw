#include "PROTHEUS.CH"

/*/{Protheus.doc} U_ITEM
    Ponto de entrada da rotina MATA010 para preenchimento do campo customizado B1_XNEGOCI

    @type  Function
    @author Joabe Silva
    @since 15/04/2020
    @version 1.0
    @param
    @return lRet, boolean, retorna o sucesso ou insucesso da operação
    @example
    (examples)
    @see (links_or_references)
    /*/
user function ITEM()

    U_PERGAGRO(PARAMIXB)
return(.T.)