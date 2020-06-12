#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA32()

At. campo p/informar se o tit. é securitizado e gera fluxo de caixa

Chamado pelo PE FA60TRAN

@param		Nenhum 
@return		Nenhum
@author 	Fabio Cazarini
@since 		12/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA32()
	LOCAL aArea			:= GetArea()
	LOCAL cSITSE1		:= ALLTRIM(GETNEWPAR( "AS_SITSE1", "", cFILANT )) // Situações dos títulos a receber securitizados. Sep. p/ '|'. Exemplo: 0|1
	LOCAL cSITSE9		:= ALLTRIM(GETNEWPAR( "AS_SITSE9", "", cFILANT )) // Situações dos títulos a receber securitizados vencidos. Sep. p/ '|'. Exemplo: 2
	
	//-----------------------------------------------------------------------
	// Se for tit. securitizado, marcar flag e não gerar fluxo de caixa
	//-----------------------------------------------------------------------
	DbSelectArea("SE1")
	RecLock("SE1", .F.)
	IF SE1->E1_SITUACA $ cSITSE1 .AND. SE1->E1_SITUACA <> '0'
		SE1->E1_XSECUR	:= '1'
		SE1->E1_XFLUANT	:= SE1->E1_FLUXO
		SE1->E1_FLUXO	:= "N"
	ELSEIF SE1->E1_SITUACA $ cSITSE9 .AND. SE1->E1_SITUACA <> '0'
		SE1->E1_XSECUR := '9'
		SE1->E1_XFLUANT	:= SE1->E1_FLUXO
		SE1->E1_FLUXO	:= "N"
	ELSE
		SE1->E1_XSECUR := '0'
//		IF !EMPTY(SE1->E1_XFLUANT)
//			SE1->E1_FLUXO	:= SE1->E1_XFLUANT	
//		ELSE
			SE1->E1_FLUXO	:= "S"
//		ENDIF
	ENDIF
	SE1->( MsUnLock() )
	
	RestArea( aArea )
	
RETURN