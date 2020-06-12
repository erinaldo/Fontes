#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} PMSAFGCPO()
Campos alter�veis

O ponto de entrada PMSAFGCPO define quais campos da tabela Afg - Projetos 
x Solicita�ao de Compras que podem ser alter�veis na tela.

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
USER FUNCTION PMSAFGCPO()
	LOCAL aAlter	:= PARAMIXB[1]	// parametro 1 - array com campos alter�veis
	LOCAL aHeader	:= PARAMIXB[2]	// parametro 2 - cabe�alho de campos
	LOCAL aCols		:= PARAMIXB[3]	// parametro 3 - Conte�dos de campos

	aAlter := U_ASCOMA17(aAlter, aHeader, aCols)

RETURN aAlter