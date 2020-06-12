#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA47()

Gera fila na tabela SZB com os títulos integrados

Via schedule, ou demanda, serão gerados os títulos de abatimento AB- com 
o valor do parceiro

@param		cValExt		InternalId valor externo
			cHist		Histórico
			cTitE1E2	Título novo incluído
@return		Nenhum
@author 	Fabio Cazarini
@since 		11/08/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA47(cValExt, cHist, cTitE1E2)
	LOCAL aArea			:= GetArea()
	LOCAL aTitE1E2		:= {}
	LOCAL cOperaca		:= ""
	
	//-----------------------------------------------------------------------
	// cTitE1E2 := "SE1|"+cPrefixo+"|"+cNum+"|"+cParcel+"|"+cTpParcel
	//-----------------------------------------------------------------------
	aTitE1E2	:= STRTOKARR(cTitE1E2, "|") 
	IF LEFT(cTitE1E2,3) <> "SE1"
		RETURN
	ENDIF
	IF LEN(aTitE1E2) < 5
		RETURN
	ENDIF

	IF TYPE("oXmlFin:_TOTVSMessage:_BusinessMessage:_BusinessEvent:_Event:Text") #"U"
		cOperaca := PADR( UPPER(ALLTRIM(oXmlFin:_TOTVSMessage:_BusinessMessage:_BusinessEvent:_Event:Text)), LEN(SZB->ZB_OPERACA) )
	ENDIF	

	DbSelectArea("SZB")
	RecLock("SZB", .T. )

	SZB->ZB_FILIAL	:= xFILIAL("SZB")
	SZB->ZB_FILTIT	:= xFILIAL("SE1")
	SZB->ZB_PREFIXO	:= PADR( aTitE1E2[2], LEN(SE1->E1_PREFIXO) )
	SZB->ZB_NUM		:= PADR( aTitE1E2[3], LEN(SE1->E1_NUM) )
	SZB->ZB_PARCELA	:= PADR( aTitE1E2[4], LEN(SE1->E1_PARCELA) )
	SZB->ZB_TIPO	:= PADR( aTitE1E2[5], LEN(SE1->E1_TIPO) )
	SZB->ZB_OPERACA	:= cOperaca
	SZB->ZB_PROCESS	:= 0
	
	SZB->( MsUnLock() )
	
	RestArea( aArea )
	
RETURN