#INCLUDE "TOTVS.CH"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} AF125OKB
PE para validação da inclusão e exclusão da solicitação de baixa
@author  	Carlos henrique
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function AF125OKB()
Local nOpcx	:= PARAMIXB[1]
Local lRetorno:= .T.
Local aParam	:= {}
Local aParRet	:= {}

IF nOpcx == 3

	lRetorno:= U_CATFE02(.t.,1)	

ElseIF nOpcx == 7

	IF !empty(SNM->NM_XCODFOR)
		msgalert("Esta solicitação está vinculada a uma solicitação do Fluig, utilizar rotina Apr.Baixa/Transf.")
		lRetorno:= .f.
	Endif
	
Endif

Return lRetorno

