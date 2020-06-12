#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} PMSAJ7CPO()
Adiciona campos alteráveis da tabela Projetos x PC
Chamado pelo PE PMSAJ7CPO

@param		aAlter		Array com os campos padrões que poderão ser alterados.
  			aHeader		Cabeçalho dos campos da AJ7	
  			aCols		Valores da tabela AJ7 baseados no aHeader.	
@return		aAlteraveis(array_of_record) Array contendo os nomes de campos 
			que poderão ser alterados na tabela de amarração PMS x Pedido 
			de Compras.
@author 	Fabio Cazarini
@since 		24/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASCOMA19(aAlter, aHeader, aCols)

	aadd(aAlter, "AJ7_XCONTR")

RETURN aAlter