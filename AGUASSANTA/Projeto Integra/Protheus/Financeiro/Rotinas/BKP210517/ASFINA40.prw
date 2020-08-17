#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA40()

Exclui a alcada de aprova��o

@param		cTipo	= Tipo de documento (PG)
			cNum	= N�mero do documento
			lEXCLUI	= � exclus�o?
@return		Nenhum
@author 	Fabio Cazarini
@since 		03/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA40( cTipo, cNum, lEXCLUI )
	LOCAL aAreaSZ5	:= SZ5->( GetArea() )
	LOCAL cPGAPROV	:= ALLTRIM(SuperGetMv("AS_PGAPROV",.T.,""))

	cTipo	:= PADR(cTipo, TAMSX3("Z5_TIPO")[1] )
	cNum	:= PADR(cNum, TAMSX3("Z5_NUM")[1] )

	//-----------------------------------------------------------------------
	// Exclui a alcada de aprova��o
	//-----------------------------------------------------------------------
	DbSelectArea("SZ5")
	SZ5->( DbSetOrder(1) ) // Z5_FILIAL+Z5_TIPO+Z5_NUM+Z5_NIVEL
	SZ5->( MsSeek( xFILIAL("SZ5") + cTipo + cNum ) ) 
	DO WHILE !SZ5->( EOF() ) .AND. SZ5->( Z5_FILIAL+Z5_TIPO+Z5_NUM ) = (xFILIAL("SZ5") + cTipo + cNum)
		RecLock("SZ5", .F.)
		SZ5->( DbDelete() )
		SZ5->( MsUnLock() )

		SZ5->( DbSkip() )
	ENDDO

	//-----------------------------------------------------------------------
	// Limpa aprova��o anterior
	//-----------------------------------------------------------------------
	IF !lEXCLUI
		RecLock("SE2", .F.)
		//SE2->E2_DATALIB	:= CTOD("//")
		//SE2->E2_USUALIB	:= ""
		//SE2->E2_STATLIB	:= "01"			// 01=Esperando aprova��o do usu�rio, 02=Bloqueado (esperando outros n�veis), 03=Movimento liberado pelo usu�rio, 04=Movimento bloqueado pelo usu�rio
		//SE2->E2_CODAPRO	:= ""
		SE2->E2_XAPRGRU	:= cPGAPROV
		SE2->E2_XAPROVA	:= ""
		SE2->E2_XAPRNOM	:= ""
		SE2->E2_XAPRNIV	:= ""
		SE2->( MsUnLock() )
	ENDIF
	
	SZ5->( RestArea( aAreaSZ5 ) )

RETURN 

