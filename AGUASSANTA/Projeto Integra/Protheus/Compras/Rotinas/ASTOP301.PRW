#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

/*{Protheus.doc} F0100301
Grava os campos costumizados no Contas a Pagar
Chamado pelo PE - M103GERT
Chamado nos PE - GQREENTR - No término da gravação do documento de entrada
@author 	Nivia Ferreira
@version 	P11
@since   	15/12/2016
@param
@return
@obs
@project   MAN00000022127_EF_001
@history
*/

User Function ASTOP301()

Local cArea		:= GetArea()
Local aAreaSF1	:= SF1->(GetArea())
Local aAreaSE2	:= SE2->(GetArea())
Local XRETRM	:= IF(TYPE("nVl_Rrm")<>"U",nVl_Rrm,0)
Local XDEDRM	:= IF(TYPE("nVl_Drm")<>"U",nVl_Drm,0)
Local cIntVal	:= ""
Local cQuery	:= ""
Local cCalcPIS	:= ""
Local cCalcCOF	:= ""
Local cCalcCSL	:= ""
Local nCalcPIS	:= 0
Local nCalcCOF	:= 0
Local nCalcCSL	:= 0
Local nVlrRet	:= 0
Local nVlrPCC	:= 0
Local lRetGrv	:= .T.
Local cTabSD1	:= GetNextAlias()
Local cSF1Fil	:= SF1->F1_FILIAL
Local cSF1Doc	:= SF1->F1_DOC
Local cSF1Ser	:= SF1->F1_SERIE
Local cSF1For	:= SF1->F1_FORNECE
LocaL cSF1Loj	:= SF1->F1_LOJA

// Zema 16/11/17 - Somente faz os tratamentos se o titulo possuir retenção ou dedução
IF XRETRM+XDEDRM == 0
	Return()
ENDIF

//Valor da Retenção e Dedução que já foram movimentados
cQuery	:= " SELECT SUM(D1_TOTAL) AS TTLSD1 " + CRLF
cQuery	+= " FROM " + RetSQLName("SD1") + " SD1 " + CRLF
cQuery	+= " WHERE " + CRLF
cQuery	+= " SD1.D1_FILIAL	= '" + cSF1Fil + "' AND" + CRLF
cQuery	+= " SD1.D1_DOC 	= '" + cSF1Doc + "' AND" + CRLF
cQuery	+= " SD1.D1_SERIE 	= '" + cSF1Ser + "' AND" + CRLF
cQuery	+= " SD1.D1_FORNECE = '" + cSF1For + "' AND" + CRLF
cQuery	+= " SD1.D1_LOJA 	= '" + cSF1Loj + "' AND" + CRLF
cQuery	+= " SD1.D_E_L_E_T_ = '' "  				 + CRLF
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTabSD1,.T.,.T.)

DbSelectArea("SE2")
dbSetOrder(6)
SE2->(MsSeek( xFilial("SE2") + SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_SERIE + SF1->F1_DOC))

DbSelectArea("SED")
SED->(DbSetOrder(1))
If SED->(DbSeek(xFilial("SED") + SE2->E2_NATUREZ))
	cCalcPIS	:= SED->ED_CALCPIS
	cCalcCOF	:= SED->ED_CALCCOF
	cCalcCSL	:= SED->ED_CALCCSL
	nCalcPIS	:= SED->ED_PERCPIS
	nCalcCOF	:= SED->ED_PERCCOF
	nCalcCSL	:= SED->ED_PERCPIS
Endif

WHILE !SE2->( EOF() ) .And. SE2->E2_FILIAL == xFilial("SE2") .And. SE2->E2_NUM  == SF1->F1_DOC .And.;
	SE2->E2_LOJA   == SF1->F1_LOJA   .And. SE2->E2_PREFIXO  == SF1->F1_SERIE .And.;
	SE2->E2_FORNECE== SF1->F1_FORNECE
	
	//Obs pode ser mais de 1 parcela
	
	nVlrRet	:= (SE2->E2_VALOR - (XRETRM + XDEDRM))
	
	nVlrPCC	:= ((cTabSD1)->TTLSD1 - XRETRM)
	
	Reclock("SE2",.F.)
	SE2->E2_XRETRM	:= XRETRM
	SE2->E2_XDEDRM	:= XDEDRM
	
	If XRETRM > 0 .And. cCalcPIS == "S" .And. nCalcPIS > 0 .And. SE2->E2_PIS > 0
		SE2->E2_PIS := (nVlrPCC * nCalcPIS) / 100
		SE2->E2_BASEPIS	:= nVlrPCC
	Endif
	
	If XRETRM > 0 .And. cCalcCOF == "S" .And. nCalcCOF > 0 .And. SE2->E2_COFINS > 0
		SE2->E2_COFINS := (nVlrPCC * nCalcCOF) / 100
		SE2->E2_BASECOF	:= nVlrPCC
	Endif
	
	If XRETRM > 0 .And. cCalcCSL == "S" .And. nCalcCSL > 0 .And. SE2->E2_CSLL > 0
		SE2->E2_CSLL := (nVlrPCC * nCalcCSL) / 100
		SE2->E2_BASECSL	:= nVlrPCC
	Endif
	
	If nVlrRet <= 0
		Aviso("Atenção","O valor do titulo (Valor Titulo - Retenção) será igual a zero, os campos de valores não serão regravados.", {"Ok"}, 3)
		lRetGrv := .F.
	Else
		SE2->E2_VALOR	:= nVlrRet
		SE2->E2_VLCRUZ	:= Round(xMoeda(nVlrRet,SE2->E2_MOEDA,1,SE2->E2_EMISSAO,3,SE2->E2_TXMOEDA),2)
		SE2->E2_SALDO	:= nVlrRet
	Endif
	MsUnlock()
	
	If lRetGrv
		If	Alltrim(SE2->E2_TIPO) == 'PR' .And. Empty(SE2->E2_CCD)
			
			DbSelectArea("XXF")
			dbSetOrder(3)
			
			cIntVal	:= cEmpAnt + "|" + cFilAnt + "|" + SD1->D1_PEDIDO + "|" + "1"
			
			If	XXF->(MsSeek(RetSqlname('SC7') + 'SC7' + PADR(SD1->D1_PEDIDO,10) + cIntVal))
				
				DbSelectArea("CV4")
				dbSetOrder(1)
				
				If	CV4->(DbSeek(xFilial('CV4') + DTOS(SE2->E2_EMISSAO) + SE2->E2_ARQRAT))
					Reclock("SE2",.F.)
					SE2->E2_CCD := CV4->CV4_CCD
					MsUnlock()
				EndIf
			EndIf
		EndIf
	Endif
	
	SE2->(DbSkip())
	
EndDo
(cTabSD1)->(DbCloseArea())
RestArea(aAreaSF1)
RestArea(aAreaSE2)
RestArea(cArea)

Return()

