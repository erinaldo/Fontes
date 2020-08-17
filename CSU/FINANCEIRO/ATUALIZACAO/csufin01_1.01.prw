#INCLUDE "rwmake.ch"
                        
// *** Rotina CSUFIN01 - Disparada através do Inicializador do campo virtual E2_RSOCIAL.
// *** Alimenta o campo virtual E2_RSOCIAL com a Razao Social do Fornecedor, para
// fins de consulta.
// *** Data: 13/03/2002.

User Function CSUFIN01()

cRSocial := ""

If INCLUI = .F.

	cArea:= Alias()
	
	DbSelectArea("SA2")
	DbSetOrder(1)
	DbSeek( xFilial()+SE2->E2_FORNECE+SE2->E2_LOJA )
	
	If Found()
		cRSocial := SA2->A2_NOME
	EndIf    
	
	DbSelectArea(cArea)
	
EndIf

Return(cRSocial)