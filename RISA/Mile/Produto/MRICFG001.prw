#include "rwmake.ch"

/*/{Protheus.doc} MRICFG001
    (long_description)
    @type  Function
    @author user
    @since 10/09/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/

User Function MRICFG001(param_name)

Local lRet := param_name
Local lMile := .F.

lMile := isInCallStack("CFG600LMdl") .or. isInCallStack("FWMILEIMPORT") .or. isInCallStack("FWMILEEXPORT")

If lMile
    lRet := .T.
EndIf
    
Return(lRet)
