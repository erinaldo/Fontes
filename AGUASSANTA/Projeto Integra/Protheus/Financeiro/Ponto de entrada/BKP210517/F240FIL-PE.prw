#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} F240FIL()

Montagem de filtro

O ponto de entrada F240FIL sera utilizado para montar o filtro para 
Indregua apos preenchimento da tela de dados do bordero. O filtro 
retornado pelo ponto de entrada ser� anexado ao filtro padr�o do programa

@param		Nenhum
@return		cRet	=	Express�o caracter com o filtro desejado.
@author 	Fabio Cazarini
@since 		05/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION F240FIL()
	LOCAL cRet	:= ""

  	//-----------------------------------------------------------------------
	// Filtrar t�tulos enviados para o Fluig e ainda n�o aprovados
	//-----------------------------------------------------------------------
	cRet := U_ASFINA03()
		
RETURN cRet