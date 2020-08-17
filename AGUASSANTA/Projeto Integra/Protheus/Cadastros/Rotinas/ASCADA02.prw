#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'
#INCLUDE 'FWCOMMAND.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCADA02()

Fun��o para retornar as filiais que o usu�rio (par�metro) tem acesso

@param		cCodUsr = C�digo do usu�rio
@return		aRet = Array contendo os c�digos das filiais que o usu�rio
			tem acesso
@author 	Fabio Cazarini
@since 		19/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASCADA02(cCodUsr)
	LOCAL aRet		:= {}
	LOCAL aRetPsw	:= {}
	LOCAL aRetAce	:= {}
	LOCAL cGrpRule	:= ""
	LOCAL nX		:= 0
	LOCAL cFilUsu	:= ""
	LOCAL lTodasEmp	:= .F.
	LOCAL aGrpUsu	:= {}
	LOCAL cGrpId	:= ""
	LOCAL nZ		:= 0
	LOCAL aSM0		:= {}
	LOCAL nK		:= 0
	LOCAL nY		:= 0
	
	//-----------------------------------------------------------------------
	// Busca as filiais do usuario
	//-----------------------------------------------------------------------
	PswOrder(1) //  ID do usu�rio/grupo
	IF PswSeek( cCodUsr, .T. ) // procura por usu�rio
		aRetAce 	:= FWUsrEmp(cCodUsr)
		cGrpRule 	:= FWUsrGrpRule(cCodUsr) // retorna a regra do grupo
		aRetPsw		:= PswRet() 
	
		IF cGrpRule $ "2|3" // 2 desconsidera regras do grupo | 3 soma regras do grupo
			FOR nX := 1 TO LEN(aRetAce) 
				cFilUsu := aRetAce[nX]
				IF cFilUsu == "@@@@"
					lTodasEmp := .T.
					EXIT
				ELSE
					IF !EMPTY( cFilUsu )
						IF aSCAN( aRet, cFilUsu ) == 0  // se ainda nao adicionou a filial
							AADD( aRet, cFilUsu )
						ENDIF		
					ENDIF
				ENDIF
			NEXT nX
		ENDIF
		
		IF !lTodasEmp
			IF cGrpRule $ "1|3" // 1 prioriza regras do grupo | 3 soma regras do grupo
				//-----------------------------------------------------------------------
				// Busca as filiais dos grupos do usuario
				//-----------------------------------------------------------------------
				aGrpUsu := aRetPsw[1][10]
				FOR nY := 1 TO LEN(aGrpUsu)
					cGrpId 	:= aGrpUsu[nY]
					aRetAce	:= FWGrpEmp(cGrpId)
			
					FOR nZ := 1 TO LEN(aRetAce) 
						cFilUsu := aRetAce[nZ]
						IF cFilUsu == "@@@@"
							lTodasEmp := .T.
							EXIT
						ELSE
							IF !EMPTY( cFilUsu )
								IF aSCAN( aRet, cFilUsu ) == 0  // se ainda nao adicionou a filial
									AADD( aRet, cFilUsu )
								ENDIF		
							ENDIF
						ENDIF
					NEXT nZ
				NEXT nY
			ENDIF
		ENDIF
	ENDIF

	//-----------------------------------------------------------------------
	// Usu�rio tem acesso � todas as filiais
	//-----------------------------------------------------------------------
	IF lTodasEmp
		aRet	:= {}
		aSM0	:= FWLoadSM0() // Retorna as informa��es das filiais dispon�veis no arquivo SIGAMAT.EMP
		
		FOR nK := 1 TO LEN(aSM0)
			AADD( aRet, ALLTRIM(aSM0[nK][SM0_GRPEMP]) + ALLTRIM(aSM0[nK][SM0_CODFIL]) )
		NEXT
	ENDIF
	
RETURN aRet