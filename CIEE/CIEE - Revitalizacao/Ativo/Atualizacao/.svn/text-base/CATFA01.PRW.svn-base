#INCLUDE "TOTVS.CH"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CATFA01
Controle de confirmação de recebimento de plaqueta
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
USER FUNCTION CATFA01(nOpc)
LOCAL lEnvPlaq	:= .F.    

IF nOpc == 1 
	// Tratamento via classificação do bem
	lEnvPlaq:= MSGYESNO("Deseja realizar o envio da plaqueta ?")  
	
	// Registrar na tabela ZA3 e iniciar processo workflow		
	
ELSEIF nOpc == 2 
	// Tratamento via chamada no cadastro de ativos 
ENDIF 

RETURN