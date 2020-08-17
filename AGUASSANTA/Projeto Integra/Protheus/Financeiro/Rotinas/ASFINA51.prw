#include "RWmake.ch"
#INCLUDE "Protheus.ch"

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA51()

Retorna Valor liquido para montagem do CNAB

Chamado no arquivo de configuração do CNAB Tributos

@param		Nenhum
@return		_cRetorno = Valor do título a receber
@author 	Fabiano Albuquerque
@since 		23/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//------------------------------------------------------------------------

User Function ASFINA51()

Local cValLiq := ""
Local nAbat   := 0
Local nDecres := 0
Local nAcresc := 0 
Local nTaxPer := 0

If FunName() == "FINA150"

		nAbat	:= SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
		nAcresc := SE1->E1_SDACRES
		nDecres := SE1->E1_SDDECRE
		nTaxPer := SE1->E1_VALJUR
		cValLiq:=PADL(Alltrim(str((SE1->E1_SALDO - nAbat + nAcresc - nDecres + nTaxPer ) * 100 )), 15 , "0")
Else	
	If GetMv("MV_BX10925") == "1"
		nAbat	:= SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",SE2->E2_MOEDA,,SE2->E2_FORNECE)
		nAcresc := SE2->E2_SDACRES
		nDecres := SE2->E2_SDDECRE
		nMulta    := SE2->E2_XMULTA
		nJuros    := SE2->E2_XJUROS
		nOutraEnt := SE2->E2_XVLENT
		cValLiq:=PADL(Alltrim(str((SE2->E2_SALDO - nAbat + nAcresc - nDecres - nMulta - nJuros - nOutraEnt) * 100 )), 15 , "0")
	Else
		cValLiq:=PADL(Alltrim(str((SE2->E2_SALDO + nAcresc - nDecres ) * 100 )), 15 , "0")
	Endif
Endif
Return(cValLiq)
