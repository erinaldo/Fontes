#include 'protheus.ch'
#include 'parmtype.ch'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCTBA18
Utilizado para contabilização da multa contratual de distrato do TIN
LP - 508  509

@param		
@return		nRet - Valor da Multa Contratual distrato empreendimentos
@author 	Fabiano Albuquerque
@since 		10/11/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------

User Function ASCTBA18()

Local aAreaAnt  := GetArea()
Local nRet		:= 0
Local cChaveFRU := ""

IF SE2->E2_ORIGEM = "FINI055 "
	DbSelectArea("FRU")
	FRU->(DBSetOrder(1)) //FRU_FILIAL+FRU_COD+FRU_PREFIX+FRU_NUM+FRU_PARCEL+FRU_TIPO+FRU_FORNEC+FRU_LOJA
	
	cChaveFRU := xFilial("FRU")+ "95       " + SE2->(E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA) // 95 Código da Multa Contratual na tabela FRU
	
	IF FRU->( MsSeek(cChaveFRU) )
		nRet := FRU->FRU_VALOR
	EndIF

ENDIF

RestArea(aAreaAnt)
Return nRet