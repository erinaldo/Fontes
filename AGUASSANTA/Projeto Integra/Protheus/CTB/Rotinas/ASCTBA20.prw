#include 'protheus.ch'
#include 'parmtype.ch'

User Function ASCTBA20(cLP,cSEQ)

Local nReturn := 0
Local aAreaAnt := GetArea()

IF cLP == "506" 

DbSelectArea("SE1")
SE1->(DbSetOrder(1)) //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
SE1->(MsSeek(xFilial("SE1")+SEZ->(EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO) ) )

	IF SE1->E1_TIPO<>"REC" .AND. SE1->E1_TIPO<>"PR " .AND. SED->ED_XCTB=="1" .AND. SE1->E1_EMISSAO<=dDataBase
	
		IF cSEQ == "001" //INCLUSAO CONTAS A RECEB - RAT. MULT. NAT
			nReturn := SEZ->EZ_VALOR
		EndIF
		
		IF cSEQ == "002" .AND. !EMPTY(SED->ED_PCAPPIS) .AND. SED->ED_XRGTRIB == "1" //INCL CONT A RECEB - RAT. MULT. NAT - PIS
			nReturn := (SED->ED_PCAPPIS*SEZ->EZ_VALOR)/100
		EndIF
		
		IF cSEQ == "003" .AND. !EMPTY(SED->ED_PCAPCOF) .AND. SED->ED_XRGTRIB == "1" // INCL CONT A RECEB - RAT. MULT. NAT - COF
			nReturn := (SED->ED_PCAPCOF*SEZ->EZ_VALOR)/100
		EndIF
	
		IF cSEQ == "004" .AND. SED->ED_CALCIRF="S" //INCL CONT A RECEB - RAT. MULT. NAT - IRF
			nReturn :=  (SED->ED_PERCIRF*SEZ->EZ_VALOR)/100
		EndIF
		
		IF !Empty(SE1->E1_BAIXA)
			DbSelectArea("SE5")
			SE5->(DbSetOrder(7)) //E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ
			IF SE5->(MsSeek(xFilial("SE5") + SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)   ) )
				IF SE5->E5_MOTBX == "TIN"
					nReturn := 0
				EndIF
			EndIF 
		EndIF
	EndIF

EndIF

RestArea(aAreaAnt)
Return nReturn