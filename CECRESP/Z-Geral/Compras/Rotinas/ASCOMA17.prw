#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCOMA17()
Adiciona campos alteráveis da tabela Projetos x SC
Chamado pelo PE PMSAFGCPO

@param		aAlter		Array com os campos padrões que poderão ser alterados.
  			aHeader		Cabeçalho dos campos da AFG	
  			aCols		Valores da tabela AFG baseados no aHeader.	
@return		aAlteraveis(array_of_record) Array contendo os nomes de campos 
			que poderão ser alterados na tabela de amarração PMS x 
			Solicitaçao de Compra.
@author 	Fabio Cazarini
@since 		24/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASCOMA17(aAlter, aHeader, aCols)

	aadd(aAlter, "AFG_XCONTR")
	
RETURN aAlter