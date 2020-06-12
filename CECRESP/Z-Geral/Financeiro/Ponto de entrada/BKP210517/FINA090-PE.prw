#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} FINA090()

Grava��o da linha de detalhe na contabiliza��o

 O ponto de entrada FINA090 � executado ap�s a grava��o da linha de 
 detalhe durante a contabiliza��o da baixa autom�tica
 
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
	// M�tuo de pagamentos:
	// - Baixa o t�tulo origem por da��o 
	//-----------------------------------------------------------------------
	U_ASFINA42()
		
RETURN