#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*{Protheus.doc} MA103BUT
PE para montar a ABA na tela de entrada de notas

@param		Nenhum 
@return		Lógico = Se OK
@author 	Zema
@since 		19/09/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
User Function MA103BUT()
	
	Local xRet
	
	// Monta os campos costumizados na Pre-Nota para digitação da dedução
	U_ASTOP202()
	
Return (xRet)
