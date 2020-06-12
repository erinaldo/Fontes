#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} CATUSE2
//TODO Descri��o auto-gerada.
@author emerson.natali
@since 26/04/2018
@version undefined

@type function
/*/
user function CATUSE2()
Local aParam	:= {}
Local aRet		:= {}

Aadd(aParam,{1,'Data De',DATE(),"","","","",70,.T.})
Aadd(aParam,{1,'Data Ate',DATE(),"","","","",70,.T.})


If Parambox(aParam,'Informe a Data De/Ate',@aRet)

dDtaDe			:= dtos(aRet[1])
dDtaAte			:= dtos(aRet[2])

ENDIF

	cTab	 := GetNextAlias()

	BeginSql Alias cTab
		SELECT DISTINCT SE2.R_E_C_N_O_ AS RECSE2, SE2.E2_NUM, SE2.E2_NATUREZ, SE2.E2_XCONTAB, SE2.E2_ITEMD, SE2.E2_CCD, SE2.E2_XCCUSTO, SE2.E2_CLVLDB, SE2.E2_EC05DB, 
		CT2.CT2_DEBITO, CT2.CT2_ITEMD, CT2.CT2_CCD, CT2.CT2_CLVLDB, CT2.CT2_EC05DB,CT1.CT1_XNATUR
		FROM %TABLE:SE2% SE2 
			INNER JOIN %TABLE:CT2% CT2 ON CT2.CT2_DEBITO <> SE2.E2_XCONTAB 
				AND CT2.CT2_KEY LIKE '%'+SE2.E2_PREFIXO+SE2.E2_NUM+SE2.E2_PARCELA+SE2.E2_TIPO+SE2.E2_FORNECE+SE2.E2_LOJA+'%', 
		%TABLE:CT1% CT1
		WHERE SE2.E2_EMISSAO BETWEEN %EXP:dDtaDe% AND %EXP:dDtaAte%
		AND CT2.CT2_DEBITO = CT1.CT1_CONTA
		AND SE2.E2_XCONTAB <> ''
		AND CT2.CT2_ROTINA = 'FINA050'
		AND CT2.CT2_DC = '1'
		AND SE2.E2_RATEIO <> 'S'
		AND SE2.E2_NATUREZ NOT IN ('99999999')
		AND CT1.CT1_XNATUR NOT IN ('99999999')
		AND SE2.D_E_L_E_T_ = ''
		AND CT2.D_E_L_E_T_ = ''
		AND CT1.D_E_L_E_T_ = ''
		ORDER BY SE2.E2_NUM
	EndSql

	//aRet:= GETLastQuery()[2]

	(cTab)->(dbSelectArea((cTab)))                    
	(cTab)->(dbGoTop())
	IF (cTab)->(!Eof())	
		
		While (cTab)->(!Eof())
			DbSelectArea("SE2")
			SE2->(dbgoto((cTab)->RECSE2))	
			RecLock("SE2",.F.)
			SE2->E2_NATUREZ	:= CT1_XNATUR
			SE2->E2_XCONTAB	:= CT2_DEBITO
			SE2->E2_ITEMD	:= CT2_ITEMD
			SE2->E2_CCD		:= CT2_CCD
			SE2->E2_XCCUSTO	:= CT2_CCD
			SE2->E2_CLVLDB	:= CT2_CLVLDB
			SE2->E2_EC05DB	:= CT2_EC05DB
			MsUnlock()		
			(cTab)->(dbSKIP())	
		End
	
		MSGINFO("Processo de ajuste finalizado!" + DTOC(STOD(dDtaDe)) + "-" + DTOC(STOD(dDtaAte)) )
	ELSE
		MSGALERT("N�o h� dados para ajustar!!")
	ENDIF
	
	(cTab)->(dbCloseArea())	
return