#INCLUDE "TOTVS.CH"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} M020ALT
Ponto de entrada após alterar o registro do Fornecedor
@author  	Carlos Henrique
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
USER FUNCTION M020ALT()
Local cCodFor:= SA2->A2_COD

U_ProcCli()
	
//TODO - Retirar após segunda fase do projeto, apenas para atender a integração com ambiente ORIGINAL	
U_CGXMLFOR(4,cCodFor)	

RETURN 