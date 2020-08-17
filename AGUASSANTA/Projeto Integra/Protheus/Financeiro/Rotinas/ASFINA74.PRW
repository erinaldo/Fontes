#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA74()
Limpar o flag de contabilização dos títulos de alugueis
Chamado pelo PE: F040FCR-PE 
 
@param		Nil
@return		Nil 
@author 	Fabiano Albuquerque
@since 		30/01/2018
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA74()

Local aArea		:= GetArea()
Local aAreaSE1	:= SE1->(GetArea())
Local aAreaSEV	:= SEV->(GetArea())
Local aAreaSEZ	:= SEZ->(GetArea())
Local cChave	:= SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_TIPO + SE1->E1_CLIENTE + SE1->E1_LOJA

//Regra para remoção das Flags de Contabilizacao
If SE1->E1_TIPO = "ALG" .AND. SE1->E1_PREFIXO = "@@@"

	RecLock("SE1", .F.)
	SE1->E1_LA := ""
	MsUnlock()

	DbSelectArea("SEV")
	DbSetOrder(4)		//EV_FILIAL, EV_PREFIXO, EV_NUM, EV_PARCELA, EV_TIPO, EV_CLIFOR, EV_LOJA, EV_RECPAG, EV_IDENT, EV_SEQ, EV_NATUREZ
		
	If SEV->(DbSeek(xFilial("SEV") + cChave + "R"))
		While !SEV->(Eof()) .AND. xFilial("SEV") + cChave + "R" == SEV->EV_FILIAL + SEV->EV_PREFIXO + SEV->EV_NUM + SEV->EV_PARCELA + SEV->EV_TIPO + SEV->EV_CLIFOR + SEV->EV_LOJA + SEV->EV_RECPAG
			RecLock("SEV", .F.)
				SEV->EV_LA := ""
			MsUnlock()
				
			DbSelectArea("SEZ")
			DbSetOrder(5)		//EZ_FILIAL, EZ_PREFIXO, EZ_NUM, EZ_PARCELA, EZ_TIPO, EZ_CLIFOR, EZ_LOJA, EZ_NATUREZ, EZ_RECPAG, EZ_IDENT, EZ_SEQ, EZ_CCUSTO
			
			If SEZ->(DbSeek(xFilial("SEZ") + cChave + SEV->EV_NATUREZ + "R"))
				While !SEZ->(Eof()) .AND. xFilial("SEZ") + cChave + SEV->EV_NATUREZ + "R" == SEZ->EZ_FILIAL + SEZ->EZ_PREFIXO + SEZ->EZ_NUM + SEZ->EZ_PARCELA + SEZ->EZ_TIPO + SEZ->EZ_CLIFOR + SEZ->EZ_LOJA + SEZ->EZ_NATUREZ + SEZ->EZ_RECPAG
					RecLock("SEZ", .F.)
						SEZ->EZ_LA := ""
					MsUnlock()

					SEZ->(DbSkip())
				End
			EndIf
	
			SEV->(DbSkip())
		End
	EndIf
EndIf

RestArea(aAreaSEZ)
RestArea(aAreaSEV)
RestArea(aAreaSE1)
RestArea(aArea)

Return NIL