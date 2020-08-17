#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCOMA34()

Retorna o código da filial (aRET[1]) e o código da coligada (aRET[2]) no RM

Exemplo: U_ASCOMA34( cEMPANT, cFILANT )

@param		cCODEMPde = Grupo de empresas no Protheus
			cCODFILde = Filial
@return		aRET[1] = Código da filial RM
			aRET[2] = Código da coligada RM
@author 	Fabio Cazarini
@since 		27/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASCOMA34( cCODEMPde, cCODFILde )
	LOCAL aRET	:= {}
	
	AADD( aRET, "")
	AADD( aRET, "")
		
	//-----------------------------------------------------------------------
	// XXD = De/Para de empresas Protheus vs RM
	//-----------------------------------------------------------------------
	DbSelectArea("XXD")
	
	cCODEMPde := PADR( cCODEMPde, LEN(XXD->XXD_EMPPRO) )
	cCODFILde := PADR( cCODFILde, LEN(XXD->XXD_FILPRO) )
	
	XXD->( DbSetOrder(2) ) // XXD_EMPPRO + XXD_FILPRO
	IF XXD->( MsSEEK( cCODEMPde + cCODFILde) )
		aRET[1] := XXD->XXD_BRANCH 	// filial RM
		aRET[2] := XXD->XXD_COMPA	// coligada RM
	ENDIF

	XXD->( DbCloseArea() )
	
RETURN aRET