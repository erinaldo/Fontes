#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} PMSAJ7CPO()
Campos alteráveis

O ponto de entrada PMSAJ7CPO define quais campos da tabela AJ7 - Projetos 
x Pedido de Compras que podem ser alteráveis na tela.

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
USER FUNCTION PMSAJ7CPO()
	LOCAL aAlter	:= PARAMIXB[1]	// parametro 1 - array com campos alteráveis
	LOCAL aHeader	:= PARAMIXB[2]	// parametro 2 - cabeçalho de campos
	LOCAL aCols		:= PARAMIXB[3]	// parametro 3 - Conteúdos de campos

	aAlter := U_ASCOMA19(aAlter, aHeader, aCols)

RETURN aAlter