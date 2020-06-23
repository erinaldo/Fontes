#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

/*/ {Protheus.doc} GCPA200()

@Project     MAN00000011501_EF_025
@author      Aline S Damasceno
@since       29/11/2015
@version     P12.6
@Return      Validação do Folder
@Obs         Função utilizada no processo de geração das planilhas no Assistente do Contrato
/*/#INCLUDE "PROTHEUS.CH"

User Function GCPA200()
Local lRet := .T.

//lRet := u_F0102602()
		
//Seleciona apenas o fornecedor exclusivo na amarração
//Produto x Fornecedor
U_PROCA030()

Return lRet