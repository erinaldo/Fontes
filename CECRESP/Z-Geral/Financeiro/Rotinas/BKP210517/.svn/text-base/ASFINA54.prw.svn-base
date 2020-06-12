#include "PROTHEUS.CH"

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA54()

Geração da código de matricula de autonomo.

@param		Nenhum
@return		.T.
@author 	Fabiano Albuquerque
@since 		22/11/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------

User Function ASFINA54()

Local _cPisFin			:= SA2->A2_CODNIT //SE2->E2_PISFUN
Local _aArea			:= SRA->(GetArea())
Local _cMat_Autonomos	:= '700000'

DbSelectArea("SRA")
SRA->(DbSetOrder(1)) //filial+matricula

IF DbSeek(xFilial("SRA")+_cMat_Autonomos,.T.)
		While xFilial("SRA") == SRA->RA_FILIAL .And. SRA->RA_MAT <= "799999"
			_cMat_Autonomos := soma1(_cMat_Autonomos)
			SRA->(DbSkip())
		EndDo
	SRA->RA_MAT := _cMat_Autonomos  //Insere matricula com +1 na ultima matricula encontrada
Else
	SRA->RA_MAT := _cMat_Autonomos  //Insere matricula com +1 na ultima matricula encontrada
EndIF

RecLock("SRA",.F.)
SRA->RA_MAT := _cMat_Autonomos  //Insere matricula com +1 na ultima matricula encontrada
SRA->RA_PIS := _cPISFin
MsUnLock()

RestArea(_aArea)

Return