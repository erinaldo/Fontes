#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA39()

Valida a filial informada

@param		cFilPar = Filial a ser validada
@return		lRet = Filial v�lida = .T., n�o v�lida = .F.
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
				Help('',1,'Inconsist�ncia - ' + PROCNAME(),,'Filial pagadora (' + cFilPar + ') n�o cadastrada',4,1)
				lRet := .F.
			ELSE
				IF cFilPar == cFilAnt
					Help('',1,'Inconsist�ncia - ' + PROCNAME(),,'Filial pagadora (' + cFilPar + ') deve ser diferente da filial do t�tulo (' + cFilAnt + ')',4,1)
					lRet := .F.
				ELSE
					//-----------------------------------------------------------------------
					// Se o usu�rio n�o tem acesso � filial
					//-----------------------------------------------------------------------
					aFilAce := U_ASCADA02( RetCodUsr() ) // filiais que o usu�rio corrente tem acesso
					IF aSCAN( aFilAce, cEmpAnt+cFilPar ) == 0
						Help('',1,'Inconsist�ncia - ' + PROCNAME(),,'Usu�rio sem acesso � filial pagadora (' + cFilPar + ')',4,1)
						lRet := .F.
					ENDIF
				ENDIF
			ENDIF
		ENDIF
	ENDIF
	
	RestArea( aArea )
	
RETURN lRet