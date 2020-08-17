#INCLUDE 'Rwmake.ch'

//-----------------------------------------------------------------------
/*/{Protheus.doc} MTA130C8()

Ponto de entrada na geracao de cada item da cotacao. 
Neste momento tanto o SC1 quanto o SC8 estao posicionados. 

LOCALIZAÇÃO : Function  A130Grava - Função principal do Programa que 
efetua a Gravação das Cotacões .

EM QUE PONTO : APOS GRAVACAO NO SC8
Executado apos gravacao de cada item no SC8. A Tabela se encontra posicionada.

@param		Nenhum
@return		Nenhum
@author 	Fabiano Albuquerque
@since 		23/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------

User Function MTA130C8()

	//-----------------------------------------------------------------------
	// Grava o usuário no C8_XUSER
	//-----------------------------------------------------------------------
	U_ASCOMA32()
	
Return