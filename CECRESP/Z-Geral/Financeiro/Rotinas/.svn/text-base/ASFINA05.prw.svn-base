#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA05()

Adiciona o item Visualiza Aprovadores.
Adiciona o item Altera filial pagadora
Adiciona o item Borderô - Inc. Tit. Mútuo

Chamada pelo PE F050ROT, FA750BRW e F240BROWSE

@param		aRotina	=		Itens de menu do browse
@return		aRotina	=		Itens de menu do browse modificada
@author 	Fabio Cazarini
@since 		06/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA05(aRotina)

// Zema - será utilizado a rotina padrão de borderô de impostos para o mutuou a pagar
	
//	IF isInCallStack("FINA240")
//		aAdd( aRotina, { "Borderô - Inc. Tit. Mútuo"	, "U_ASFINA43", 0, 3 } )
//	ELSE
		aAdd( aRotina, { "Visualiza Aprovadores"		, "U_ASFINA06", 0, 2,, .F. } )
		aAdd( aRotina, { "Altera filial pagadora"		, "U_ASFINA38", 0, 2,, .F. } )
//		IF isInCallStack("FINA750")
//			aAdd( aRotina, { "Borderô - Inc. Tit. Mútuo"	, "U_ASFINA43", 0, 3,, .F. } )
//		ENDIF	
//	ENDIF
	
RETURN aRotina