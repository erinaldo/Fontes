#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCOMA01()

Exclui a solicitacao Fluig gerada anteriormente (alteração e exclusão) e 
gera a solicitação no Fluig do pedido de compras (inclusão e alteração)
Chamado pelo PE MT120GOK  e AVALCOPC

@param		cA120Num	= 	Número do PC
			l120Inclui	= 	Inclusão?
			l120Altera	=	Alteração?
			l120Deleta	=	Exclusão? 
@return		Nenhum
@author 	Fabio Cazarini
@since 		03/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASCOMA01(cA120Num, l120Inclui, l120Altera, l120Deleta)
	LOCAL aArea			:= GetArea()
	LOCAL aAreaSC7		:= SC7->( GetArea() )
	LOCAL cNFluig 		:= ""
	LOCAL nX			:= 0
	LOCAL cAprovador	:= ""
	LOCAL cObs			:= ""

	IF l120Inclui // se inclusao ou copia
		//-----------------------------------------------------------------------
		// Gera a solicitação no Fluig
		//-----------------------------------------------------------------------
		cNFluig := U_ASCOMA02(cA120Num)

	ELSEIF l120Altera .OR. l120Deleta // se alteração ou exclusao
		//-----------------------------------------------------------------------
		// Cancela as solicitações Fluig geradas anteriormente
		//-----------------------------------------------------------------------
		FOR nX := 1 TO LEN(aCols)
			cNFluig := GDFieldGet("C7_XNFLUIG", nX) 
			IF !EMPTY(cNFluig)
				cAprovador 	:= GDFieldGet("C7_XAPROVA", nX)
				cObs		:= GDFieldGet("C7_OBS", nX)

				U_ASCOMA03(cNFluig, cAprovador, cObs)
				EXIT 
			ENDIF 
		NEXT

		//-----------------------------------------------------------------------
		// Gera nova solicitação no Fluig
		//-----------------------------------------------------------------------
		IF l120Altera	// se alteracao
			cNFluig := U_ASCOMA02(cA120Num)
		ENDIF
	ENDIF

	RestArea(aArea)   
	RestArea(aAreaSC7)

RETURN