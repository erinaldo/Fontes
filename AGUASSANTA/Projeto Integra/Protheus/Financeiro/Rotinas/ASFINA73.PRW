#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA73()
Utilizado no cnab de impostos bradesco para retornar dados da empresa dona do título
 
@param		PARAMIXB[1]
@return		cRet - Dados da empresa dona do título 
@author 	Fabiano Albuquerque
@since 		30/01/2018
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA73()

LOCAL aAreaAnt	:= GetArea()
LOCAL aAreaSM0	:= SM0->(GetArea())
LOCAL cRet 		:= ""
LOCAL cNomeRet	:= PARAMIXB[1]

IF cNomeRet == "M0_NOMECOM"
	IF SE2->E2_XBCOFIL == ""
		cRet := SUBS(SM0->M0_NOMECOM,1,40)
	ELSE
		cRet := SUBS(Posicione("SM0",1,cEmpAnt+SE2->E2_FILORIG,"M0_NOMECOM"),1,40)
	ENDIF
ENDIF

IF cNomeRet == "M0_ENDCOB"
	IF SE2->E2_XBCOFIL == ""
		cRet := SUBS(SM0->M0_ENDCOB,1,40)
	ELSE
		cRet := SUBS(Posicione("SM0",1,cEmpAnt+SE2->E2_FILORIG,"M0_ENDCOB"),1,40)
	ENDIF
ENDIF

IF cNomeRet == "M0_CEPCOB"
	IF SE2->E2_XBCOFIL == ""
		cRet := SUBS(SM0->M0_CEPCOB,1,40)
	ELSE
		cRet := SUBS(Posicione("SM0",1,cEmpAnt+SE2->E2_FILORIG,"M0_CEPCOB"),1,8)
	ENDIF
ENDIF

IF cNomeRet == "M0_ESTCOB"
	IF SE2->E2_XBCOFIL == ""
		cRet := SUBS(SM0->M0_ESTCOB,1,40)
	ELSE
		cRet := SUBS(Posicione("SM0",1,cEmpAnt+SE2->E2_FILORIG,"M0_ESTCOB"),1,2)
	ENDIF
ENDIF

IF cNomeRet == "M0_CIDCOB"
	IF SE2->E2_XBCOFIL == ""
		cRet := SUBS(SM0->M0_CIDCOB,1,40)
	ELSE
		cRet := SUBS(Posicione("SM0",1,cEmpAnt+SE2->E2_FILORIG,"M0_CIDCOB"),1,20)
	ENDIF
ENDIF

IF cNomeRet == "M0_BAIRCOB"
	IF SE2->E2_XBCOFIL == ""
		cRet := SUBS(SM0->M0_BAIRCOB,1,40)
	ELSE
		cRet := SUBS(Posicione("SM0",1,cEmpAnt+SE2->E2_FILORIG,"M0_BAIRCOB"),1,20)
	ENDIF
ENDIF

IF cNomeRet == "M0_CGC"
	IF SE2->E2_XBCOFIL == ""
		cRet := SUBS(SM0->M0_CGC,1,40)
	ELSE
		cRet := SUBS(Posicione("SM0",1,cEmpAnt+SE2->E2_FILORIG,"M0_CGC"),1,15)
	ENDIF
ENDIF

IF cNomeRet == "M0_INSC"
	IF SE2->E2_XBCOFIL == ""
		cRet := SUBS(SM0->M0_INSC,1,12)
	ELSE
		cRet := SUBS(Posicione("SM0",1,cEmpAnt+SE2->E2_FILORIG,"M0_INSC"),1,12)
	ENDIF
ENDIF

IF cNomeRet == "M0_CNAE"
	IF SE2->E2_XBCOFIL == ""
		cRet := SUBS(SM0->M0_CNAE,1,7)
	ELSE
		cRet := SUBS(Posicione("SM0",1,cEmpAnt+SE2->E2_FILORIG,"M0_CNAE"),1,7)
	ENDIF
ENDIF


SM0->(RestArea(aAreaSM0))
RestArea(aAreaAnt)

Return cRet