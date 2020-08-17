#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA39()

Valida a filial informada

@param		cFilPar = Filial a ser validada
@return		lRet = Filial válida = .T., não válida = .F.
@author 	Fabio Cazarini
@since 		19/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA39(cFilPar)
	LOCAL lRet 		:= .T.
	LOCAL aArea		:= GetArea()
	LOCAL aFilAce	:= {}

	//-----------------------------------------------------------------------
	// Procura pelo Numero da Empresa e Filial para pagamento
	//-----------------------------------------------------------------------
	IF lRet
		IF !EMPTY(cFilPar)
			dbSelectArea("SM0")
			dbSetOrder(1)
			IF !MsSeek(SUBS(cNumEmp,1,2)+cFilPar)
				Help('',1,'Inconsistência - ' + PROCNAME(),,'Filial pagadora (' + cFilPar + ') não cadastrada',4,1)
				lRet := .F.
			ELSE
				IF cFilPar == cFilAnt
					Help('',1,'Inconsistência - ' + PROCNAME(),,'Filial pagadora (' + cFilPar + ') deve ser diferente da filial do título (' + cFilAnt + ')',4,1)
					lRet := .F.
				ELSE
					//-----------------------------------------------------------------------
					// Se o usuário não tem acesso à filial
					//-----------------------------------------------------------------------
					aFilAce := U_ASCADA02( RetCodUsr() ) // filiais que o usuário corrente tem acesso
					IF aSCAN( aFilAce, cEmpAnt+cFilPar ) == 0
						Help('',1,'Inconsistência - ' + PROCNAME(),,'Usuário sem acesso à filial pagadora (' + cFilPar + ')',4,1)
						lRet := .F.
					ENDIF
				ENDIF
			ENDIF
		ENDIF
	ENDIF
	
	RestArea( aArea )
	
RETURN lRet