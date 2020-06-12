#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA03()

Filtrar títulos enviados para o Fluig e ainda não aprovados.

Chamado pelo PE F240FIL e rotina ASFINA40

@param		Nenhum
@return		cRet	=	Expressão caracter com o filtro desejado 
@author 	Fabio Cazarini
@since 		06/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA03()
	LOCAL cRet	:= ""

/*  ZEMA 31/10/2016 - SERÁ UTILIZADO A ROTINA PADRÃO DE BORDERÔ DE IMPOSTOS - A ROTINA ASFINA43 SERÁ INUTILIZADA

	IF IsInCallStack("U_ASFINA43")
		//-----------------------------------------------------------------------	
		// N=Não enviado Fluig;E=Enviado Fluig;I=Iniciada Aprov.Fluig;
		// A=Aprovado Fluig;R=Reprovado Fluig
		//-----------------------------------------------------------------------
		cRet := "E2_XSFLUIG IN (' ','N','A') "	
	ELSE
		//-----------------------------------------------------------------------	
		// N=Não enviado Fluig;E=Enviado Fluig;I=Iniciada Aprov.Fluig;
		// A=Aprovado Fluig;R=Reprovado Fluig
		//-----------------------------------------------------------------------
		cRet := "E2_XSFLUIG $ ' |N|A' "	

		//-----------------------------------------------------------------------	
		// Não inclui título de mútuo na rotina padrão (FINA240)
		//-----------------------------------------------------------------------
		cRet += " .AND. E2_XBCOFIL = '" + SPACE(TAMSX3("E2_XBCOFIL")[1]) + "' " 
	ENDIF
   
*/


//cRet := "E2_XSFLUIG $ ' |N|A' .AND. E2_XBCOFIL = '" + xFILIAL("SE2") + "' .OR. (E2_XBCOFIL = '"+Space(TAMSX3("E2_XBCOFIL")[1]) + "' .AND. E2_FILORIG = '" + xFILIAL("SE2") + "') "
cRet := "E2_XSFLUIG $ ' |N|A' .AND. (E2_XBCOFIL = '" + cFilAnt + "' .OR. (E2_XBCOFIL = '"+Space(TAMSX3("E2_XBCOFIL")[1]) + ")) "
		
				
RETURN cRet