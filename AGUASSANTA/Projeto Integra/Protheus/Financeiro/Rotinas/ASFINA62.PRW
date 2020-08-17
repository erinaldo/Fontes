#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'                  
#INCLUDE 'TOPCONN.CH'
//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA62()

Utilizado na criação de filtros na tela de contas a pagar para exibir os titulos de PA
que possuam titulos a compensar

@param		Nenhum
@return		lRet	=	.T. = Exibe titulo, .F. = Não exibe titulo
@author 	Zema
@since 		20/07/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA62
Local lRet			:= .F.
Local cQ			:= ""
IF SE2->E2_TIPO $ "PA #NDF" .AND. SE2->E2_SALDO > 0
	cQ := "SELECT E2_FORNECE, E2_LOJA FROM "+RetSqlName("SE2")+" E2A "
	cQ += " WHERE (E2_TIPO = 'PA ' OR E2_TIPO = 'NDF') AND E2_SALDO > 0 "
	cQ += " AND EXISTS (SELECT E2_FORNECE, E2_LOJA FROM "+RetSqlName("SE2")+" E2B "
	cQ += " WHERE E2B.E2_FORNECE = E2A.E2_FORNECE AND E2B.E2_LOJA = E2A.E2_LOJA "
	cQ += " AND (E2B.E2_TIPO <> 'PA ' AND E2B.E2_TIPO <> 'NDF') AND E2B.E2_SALDO > 0 AND E2B.D_E_L_E_T_ = ' ')    
	cQ += " AND E2A.E2_FORNECE = '"+SE2->E2_FORNECE+"' "
	cQ += " AND E2A.D_E_L_E_T_ = ' '"
	TcQuery ChangeQuery(cQ) ALIAS "XSE2" NEW 

	IF XSE2->(!EOF())
		lRet := .T.
	ENDIF	

	XSE2->(DBCLOSEAREA())
	DBSELECTAREA("SE2")
ELSE
	lRet := .F.
ENDIF

RETURN(lRet)