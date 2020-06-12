#Include 'Protheus.ch'
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} UPGAPGER
Função de update de dicionários para compatibilização

@author TOTVS Protheus
@since  12/03/2015
@obs    Gerado por EXPORDIC - V.4.10.6 EFS / Upd. V.4.10.6 EFS
@version 1.0
/*/
//---------------------------------------------------------------------------------------
User Function UPGAPGER()
local aEmps	:= {"01","03","05"}
local nCnt		:= 0

for nCnt:= 1 to len(aEmps)

	// Sequencia de aplicação automatica
	
	// Ativo fixo
	U_UPGATF03(aEmps[nCnt])
	
	// Compras
	U_UPGCOM03(aEmps[nCnt])
	U_UPGCOM04(aEmps[nCnt])
	
	
	// contabiliadade
	U_UpdCtb002(aEmps[nCnt])
	U_UPBCTB01(aEmps[nCnt])
	
	// Contratos
	u_UPDGCT02(aEmps[nCnt])
	
	// Faturamento	
	u_UPDFat001(aEmps[nCnt])
	
	// Financeiro	
	u_UPGSPB01(aEmps[nCnt])
	u_UPGSPB04(aEmps[nCnt])
	u_UPGSPB08(aEmps[nCnt])
	u_UPGSPB09(aEmps[nCnt])
	u_UPDTes06(aEmps[nCnt])
	u_UPDTes06(aEmps[nCnt])	
	
	// Fiscal
	u_UPGFIS03(aEmps[nCnt])	
		
next nCnt 	
	
Return

