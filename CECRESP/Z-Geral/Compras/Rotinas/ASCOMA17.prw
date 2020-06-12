#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCOMA17()
Adiciona campos alter�veis da tabela Projetos x SC
Chamado pelo PE PMSAFGCPO

@param		aAlter		Array com os campos padr�es que poder�o ser alterados.
  			aHeader		Cabe�alho dos campos da AFG	
  			aCols		Valores da tabela AFG baseados no aHeader.	
@return		aAlteraveis(array_of_record) Array contendo os nomes de campos 
			que poder�o ser alterados na tabela de amarra��o PMS x 
			Solicita�ao de Compra.
@author 	Fabio Cazarini
@since 		24/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASCOMA17(aAlter, aHeader, aCols)

	aadd(aAlter, "AFG_XCONTR")
	
RETURN aAlter