#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

/*/ {Protheus.doc} GCPA200()

@Project     MAN00000011501_EF_025
@author      Aline S Damasceno
@since       29/11/2015
@version     P12.6
@Return      Valida��o do Folder
@Obs         Fun��o utilizada no processo de gera��o das planilhas no Assistente do Contrato
/*/#INCLUDE "PROTHEUS.CH"

User Function GCPA200()
Local lRet := .T.

//Fun��o da f�brica
If FindFunction("U_F0102602")
	lRet := u_F0102602()
EndIf	
		
//Seleciona apenas o fornecedor exclusivo na amarra��o
//Produto x Fornecedor
U_PROCA030()

Return lRet