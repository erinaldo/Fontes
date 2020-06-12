#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} FINA090()

Gravação da linha de detalhe na contabilização

 O ponto de entrada FINA090 é executado após a gravação da linha de 
 detalhe durante a contabilização da baixa automática
 
@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		28/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION FINA090()

	//-----------------------------------------------------------------------
	// Mútuo de pagamentos:
	// - Baixa o título origem por dação 
	//-----------------------------------------------------------------------
	U_ASFINA42()
		
RETURN