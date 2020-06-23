#Include 'Protheus.ch'
/*/ {Protheus.doc} CN120ITM()
Ponto de Entrada durante o encerramento da medição, antes de gerar os pedidos. Utilizado para incluir conteúdos de campos

@Project     PRODAM
@author      Luciano Lorenzetti
@param		    
@since       20/01/2016
@version     P12
@Return      nil
@Obs         --
/*/
User Function CN120ITM()
	Local ExpA1 := PARAMIXB[1]
	Local ExpA2 := PARAMIXB[2]
	Local ExpC1 := PARAMIXB[3]
	//-----------------------------------------------------------------------------
	Local aAreaCNA
	Local aAreaCNE
	Local aArea 	:= GetArea()
	Local cRevisa	:= CN9->CN9_REVISA
	Local cEspCtr := CN9->CN9_ESPCTR // 1=COMPRAS , 2=VENDAS
	Local cChvCNA	:= ""
	Local cChvCNE	:= ""
	Local cMDITEM	:= ""
	Local nPosIt	:= 0
	Local j		:= 0
	Local x
	//-----------------------------------------------------------------------------	
	
	dbSelectArea("CNE")
	aAreaCNE := CNE->(GetArea())

	dbSelectArea("CNA")
	aAreaCNA := CNA->(GetArea())
	
	/// Somente se for pedido de venda
	If cEspCtr == "2"
		nP_MDCONTR	:= aScan(ExpA1,{|x| x[1] == "C5_MDCONTR"})
		nP_MDPLANI	:= aScan(ExpA1,{|x| x[1] == "C5_MDPLANI"})
		nP_MDNUMED	:= aScan(ExpA1,{|x| x[1] == "C5_MDNUMED"})
		nP_MDNATUR	:= aScan(ExpA1,{|x| x[1] == "C5_NATUREZ"})

		If nP_MDCONTR > 0 .and. nP_MDNUMED > 0 .and. nP_MDPLANI > 0
			cMDCONTR := ExpA1[nP_MDCONTR][2]
			cMDPLANI := ExpA1[nP_MDPLANI][2]
			cMDNUMED := ExpA1[nP_MDNUMED][2]
			If nP_MDNATUR <= 0
				cChvCNA := xFilial("CNA")+cMDCONTR + cRevisa + cMDPLANI //cMDNUMED
				
				dbSelectArea("CNA")
				dbSetOrder(1) /// CNA_FILIAL, CNA_CONTRA, CNA_REVISA, CNA_NUMERO
				If dbSeek(cChvCNA)
					cMDNATUR := CNA->CNA_XNATUR
					AADD(ExpA1,{"C5_NATUREZ"		,cMDNATUR	,Nil})
				EndIf
			EndIf
			
			
			dbSelectArea("CNE")
			dbSetOrder(1) //CNE_FILIAL+CNE_CONTRA+CNE_REVISA+CNE_NUMERO+CNE_NUMMED+CNE_ITEM
			
			For j:=1 to Len(ExpA2)

				nPosIt := aScan(ExpA2[Len(ExpA2)],{|x| x[1] == "C6_ITEMED"})
				
				If nPosIt > 0
				
					cMDITEM := ExpA2[j][nPosIt][2]
					cChvCNE := xFilial("CNE")+cMDCONTR + cRevisa + cMDPLANI + cMDNUMED + cMDITEM
					dbSelectArea("CNE")
					
					If dbSeek(cChvCNE)
                		     
						nPos := aScan(ExpA2[Len(ExpA2)],{|x| x[1] == "C6_XCLVL"})
						If nPos <= 0
							AADD(ExpA2[J] ,{"C6_XCLVL"		,CNE->CNE_CLVL	,Nil}) 
						EndIf

						nPos := aScan(ExpA2[Len(ExpA2)],{|x| x[1] == "C6_XEC08CR"})
						If nPos <= 0
							AADD(ExpA2[J]	 ,{"C6_XEC08CR"	,CNE->CNE_EC08CR	,Nil}) 
						EndIf


					EndIf
				
				EndIf

			Next
			
					
		EndIf

	EndIf
	
	RestArea(aAreaCNA)
	RestArea(aAreaCNE)
	RestArea(aArea)

Return {ExpA1,ExpA2}


