#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCOMA37()

Adiciona botão para alterar o contrato do pedido de compras na AFG

@param		AButtUser(vetor) = Botões de usuário no PC
@return		AButtUser(vetor) = Botões de usuário no PC
@author 	Fabio Cazarini
@since 		01/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASCOMA37(AButtUser)
	LOCAL aRet		:= AButtUser
	LOCAL aArea		:= GetArea()
	LOCAL aAreaAFG	:= AFG->( GetArea() )
	
	IF ALTERA
	
		DbSelectArea("AFG")
		AFG->( DbSetOrder(2) ) // AFG_FILIAL+AFG_NUMSC+AFG_ITEMSC+AFG_PROJET+AFG_REVISA+AFG_TAREFA
		IF AFG->( MsSeek(xFILIAL("AFG") + SC7->C7_NUMSC) )
			AADD(aRet, {'BUDGETY', "U_ASCOMA38()", 'Projeto vs Contrato'	, 'Altera o contrato do projeto' })
		ENDIF
	
		AFG->( aAreaAFG )
		RestArea( aArea )
	ENDIF

RETURN aRet