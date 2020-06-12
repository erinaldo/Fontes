#include "rwmake.ch" 

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA20()

Programa para selecionar a carteira no codigo de barras quando
Tem que ser colocado "00"

Cnab a Pagar Bradesco (Posições 136 - 138)

Chamado no arquivo de configuração do CNAB Pagar

@param		Nenhum
@return		_cBanco = Banco de fornecedor
@author 	Fabiano Albuquerque
@since 		23/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//------------------------------------------------------------------------

User Function ASFINA20()

SetPrvt("_RETCAR,")

IF SUBS(SE2->E2_CODBAR,01,3) != "237"
   _Retcar := "000"
Else
   _Retcar := "0" + SUBS(SE2->E2_CODBAR,24,2)
EndIf

Return(_Retcar)