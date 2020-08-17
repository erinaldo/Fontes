#INCLUDE "rwmake.ch"
                        
// *** Rotina CSUFIN02 - Disparada através do Inicializador do campo virtual E1_RSOCIAL.
// *** Alimenta o campo virtual E1_RSOCIAL com a Razao Social do Cliente, para
// fins de consulta.
// *** Data: 13/03/2002.

User Function CSUFIN02()

cRSocial := ""

If INCLUI = .F.

	cArea:= Alias()
	
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek( xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA )
	
	If Found()
		cRSocial := SA1->A1_NOME
	EndIf
	
	DbSelectArea(cArea)
		
EndIf

Return(cRSocial)