#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA01()

Recalcula o valor do desconto funanceiro para conceder o desconto da 
parte do parceiro, restando no t�tulo a receber valor referente � 
participa��o da Aguassanta

O rec�lculo � feito somente quando o t�tulo � originado pelo TIN

Chamado pelo PE F070DSCF

@param		nDesconto = Valor do desconto financeiro
@return		nRet = Valor do desconto financeiro recalculado
@author 	Fabio Cazarini
@since 		06/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA29(nDesconto)
	LOCAL nRet	:= nDesconto
	
	IF UPPER(ALLTRIM(SE1->E1_ORIGEM)) == "FINI055"
		nRet := SE1->E1_SALDO * (SE1->E1_DESCFIN / 100 )
	ENDIF	
	
RETURN nRet