#INCLUDE "Protheus.ch"
#INCLUDE "RwMake.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³XGPE001     ºAutor  ³ Ronaldo Olvieira º Data ³ 01/08/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Roteiros de Calculo PRODAM                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ V12 ºPRODAM                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fADIANT     ºAutor  ³ Ronaldo Olvieira º Data ³ 01/08/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calculo de Adiantamento                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ V12 ºPRODAM                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fADIANT()
	
	If (Month(dDataBase) == Month(SRA->RA_ADMISSA) .and. Year(dDataBase) == Year(SRA->RA_ADMISSA)) .or. DIASTB < 21
		CALCULE := "N"
	Endif
	
	If CALCULE == "N"
		NoPrcReg()
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fBENEF      ºAutor  ³ Ronaldo Olvieira º Data ³ 01/08/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calculo Vale Transporte                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ V12 ºPRODAM                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fSUSPVT()
	
	If SRA->RA_XSUSPVT == "1"
		CALCULE := "N"
	Endif
	
	If CALCULE == "N"
		NoPrcReg()
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fESTAG      ºAutor  ³ Ronaldo Olvieira º Data ³ 01/08/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calculo para Estagiarios                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ V12 ºPRODAM                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fESTAG()

	Local lRet := .T.
	Local cVbVTEmp := aCodFol[210,1]
	Local cVbVTFunc := aCodFol[051,1]

	If SRA->RA_CATFUNC $ "E/G"
		nVTEmp := fBuscaPd(cVbVTEmp,"V",cSemana)
		nVTFunc := fBuscaPd(cVbVTFunc,"V",cSemana) * -1
	
		nVTEmp := nVTEmp + nVTFunc
	
		If nVTEmp > 0
			FDELPD(cVbVTFunc,,)
			FDELPD(cVbVTEmp,,)
			FGERAVERBA(cVbVTEmp,nVTEmp,100.00,,,"V","G",,,,lRet,)
		EndIf
	EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fASSIST     ºAutor  ³ Ronaldo Olvieira º Data ³ 01/08/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Contribuicao Assistencial                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ V12 ºPRODAM                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fASSIST()

	Local cTab, nLinha
	Local lRet := .T.
	Local nPerc := nValAssit:= 0
	Local cVerba := aCodFol[069,1]
	cTab   := "U001"

	If SRA->RA_MENSIND == "1"
		If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
			nPerc := fTabela(cTab,nLinha,5)
		Endif
		nValAssit := (fBuscaPd(cVerba,"V",cSemana) * (nPerc /100)) * -1
		FDELPD(cVerba,,)
		FGERAVERBA(cVerba,nValAssit,,,,"V","G",,,,lRet,)
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fSEGVIDA    ºAutor  ³ Ronaldo Olvieira º Data ³ 01/08/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Seguro de Vida                                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ V12 ºPRODAM                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fSEGVIDA()

	Local cTabela    	:= "U002"
	Local cVbEmp 		:= cVbFunc := ""
	Local nQtdSal 	:= nFator := nDivisor := nPercEmp := nPercFunc := nValSV := nSVEmp := nSVFunc :=0
	Local nSal		 	:= SRA->RA_SALARIO
	Local nHrs			:= SRA->RA_HRSMES
	Local lRet			:= .T.
	cTab   := "U002"

	If SRA->RA_XSEGURO == "1"
		If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
			nQtdSal := fTabela(cTab,nLinha,6)
			nFator := fTabela(cTab,nLinha,7)
			nDivisor := fTabela(cTab,nLinha,8)
			nPercEmp := fTabela(cTab,nLinha,9)
			nPercFunc := fTabela(cTab,nLinha,10)
			cVbEmp := fTabela(cTab,nLinha,11)
			cVbaFunc := fTabela(cTab,nLinha,12)
		Endif
	Endif
	If SRA->RA_CATFUNC == "H"
		nSal:= (nSal * nHrs)
	Endif
	
	nValSV		:= ((nSal * nQtdSal) * nFator) / nDivisor
	nSVEmp		:= nValSV * (nPercEmp / 100)
	nSVFunc	:= nValSV * (nPercFunc / 100)

	If nSVEmp > 0
		FDELPD(cVbEmp,,)
		FGERAVERBA(cVbEmp,nSVEmp,,,,"V","G",,,,lRet,)
	Endif
	If nSVFunc > 0
		FDELPD(cVbFunc,,)
		FGERAVERBA(cVbFunc,nSVFunc,,,,"V","G",,,,lRet,)
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fAUXCRE     ºAutor  ³ Ronaldo Olvieira º Data ³ 01/08/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Auxilio Creche e Baba                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ V12 ºPRODAM                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fAUXCRE()

	Local nBusca, cTab, nLinha
	Local lRet			:= .T.
	Local dDtRef   	:= StoD( cAnoMes + "01" )
	Local nValBase	:= nValCre := nValCre := nQdeDep := nVlrBsCre := nVlrBsBab := nVlrReemb := 0
	Local cVbReemb	:= cVbBsCre := cVbBsbab :=""
                      
	SRB->(dbSetOrder( 1 ))
	SRB->(dbSeek( SRA->(RA_FILIAL + RA_MAT) ))

	Do While !(SRB->(Eof())) .And. SRB->(RB_FILIAL + RB_MAT) == SRA->(RA_FILIAL + RA_MAT)

		If !(SRB->RB_XAUXCRE == "1")
			SRB->(dbSkip())
			Loop
		EndIf
	
		nBusca :=  DateDiffMonth( dDtRef , SRB->RB_DTNASC )
		cTab   := "U003"
		dDataRef	:= dDataBase
			
		If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4,nBusca,"<=",5) ) > 0
			nValBase := fTabela(cTab,nLinha,6)
			cVbBsCre := fTabela(cTab,nLinha,7)
			cVbReemb := fTabela(cTab,nLinha,8)
			nValCre  += nValBase
			nQdeDep ++
		EndIf
		SRB->(dbSkip())
	EndDo
	
	If SRB->RB_XPERCRE == "2"
		nValCre := (nValCre / 2)
	Endif
	
	nValCre := nValCre * nQdeDep
	nVlrBsCre := fBuscaPd(cVbBsCre,"V",cSemana)
	nVlrReemb := nVlrBsCre
	
	If nVlrReemb > nValCre
		nVlrReemb := nValCre
	Endif			
	If nVlrReemb > 0
		FDELPD(cVbReemb,,)
		FGERAVERBA(cVbReemb,nVlrReemb,,,,"V","G",,,,lRet,)
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fAUXEXCEP   ºAutor  ³ Ronaldo Olvieira º Data ³ 01/08/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Auxilio Excepcional                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ V12 ºPRODAM                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fAUXEXCEP()

	Local cTab, nLinha
	Local lRet			:= .T.
	Local nValBase	:= nValAux := nQdeDep := 0
	Local cVbAux		:= ""
                      
	SRB->(dbSetOrder( 1 ))
	SRB->(dbSeek( SRA->(RA_FILIAL + RA_MAT) ))

	Do While !(SRB->(Eof())) .And. SRB->(RB_FILIAL + RB_MAT) == SRA->(RA_FILIAL + RA_MAT)

		If !(SRB->RB_XEXCEPC == "1")
			SRB->(dbSkip())
			Loop
		EndIf
	
		cTab   := "U004"
			
		If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
			nValBase := fTabela(cTab,nLinha,5)
			cVbAux := fTabela(cTab,nLinha,6)
			nValAux  += nValBase
			nQdeDep ++
		EndIf
		SRB->(dbSkip())
	EndDo
	If nValAux > 0
		FDELPD(cVbAux,,)
		FGERAVERBA(cVbAux,nValAux,nQdeDep,,,"V","G",,,,lRet,)
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fESTUD      ºAutor  ³ Ronaldo Olvieira º Data ³ 01/08/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Bolsa Estudo                                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ V12 ºPRODAM                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fESTUD()

	Local cTab, nLinha
	Local lRet			:= .T.
	Local nValBase	:= nVlrBs := 0
	Local cVbBsAux	:= cVbAux := ""
	cTab   := "U005"
		
	If SRA->RA_XESTUDO == "1"
		If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
			nValBase := fTabela(cTab,nLinha,5)
			cVbBsAux := fTabela(cTab,nLinha,6)
			cVbAux := fTabela(cTab,nLinha,7)
		EndIf
	Endif

	nVlrBs := fBuscaPd(cVbBsAux,"V",cSemana)
	
	If nVlrBs > 0
		FDELPD(cVbAux,,)
		If nVlrBs > nValBase
			nVlrBs := nValBase
		Endif
		FGERAVERBA(cVbAux,nVlrBs,,,,"V","G",,,,lRet,)
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fATLET      ºAutor  ³ Ronaldo Olvieira º Data ³ 01/08/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Bolsa Atleta                                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ V12 ºPRODAM                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fATLET()

	Local cTab, nLinha
	Local lRet			:= .T.
	Local nValBase	:= nVlrBs := 0
	Local cVbBsAux	:= cVbAux := ""
	cTab   := "U006"
		
	If SRA->RA_XATLETA == "1"
		If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
			nValBase := fTabela(cTab,nLinha,5)
			cVbBsAux := fTabela(cTab,nLinha,6)
			cVbAux := fTabela(cTab,nLinha,7)
		EndIf
	Endif

	nVlrBs := fBuscaPd(cVbBsAux,"V",cSemana)
	
	If nVlrBs > 0
		FDELPD(cVbAux,,)
		If nVlrBs > nValBase
			nVlrBs := nValBase
		Endif
		FGERAVERBA(cVbAux,nVlrBs,,,,"V","G",,,,lRet,)
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fFUNERAL    ºAutor  ³ Ronaldo Olvieira º Data ³ 01/08/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Auxilio Funeral                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ V12 ºPRODAM                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fFUNERAL()

	Local cTab, nLinha
	Local lRet			:= .T.
	Local nValBase	:= nVlrBs := 0
	Local cVbBsAux	:= cVbAux := ""
	cTab   := "U007"
		
	If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
		nValBase := fTabela(cTab,nLinha,5)
		cVbBsAux := fTabela(cTab,nLinha,6)
		cVbAux := fTabela(cTab,nLinha,7)
	EndIf

	nVlrBs := fBuscaPd(cVbBsAux,"V",cSemana)
	
	If nVlrBs > 0
		FDELPD(cVbAux,,)
		If nVlrBs > nValBase
			nVlrBs := nValBase
		Endif
		FGERAVERBA(cVbAux,nVlrBs,,,,"V","G",,,,lRet,)
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fINTERMUN   ºAutor  ³ Ronaldo Olvieira º Data ³ 01/08/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Auxilio Transporte Intermunicipal                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ V12 ºPRODAM                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fINTERMUN()

	Local cTab, nLinha
	Local lRet			:= .T.
	Local nPerc		:= nMin:= nVlrBs := nReemb := nLim := 0
	Local cVbBsAux	:= cVbAux := ""
	cTab   := "U008"
	
	If SRA->RA_XTINTER == "1"
		If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
			nPerc := fTabela(cTab,nLinha,5)
			nMin := fTabela(cTab,nLinha,6)
			cVbBsAux := fTabela(cTab,nLinha,7)
			cVbAux := fTabela(cTab,nLinha,8)
		EndIf
	Endif

	nVlrBs := fBuscaPd(cVbBsAux,"V",cSemana)
	
	If nVlrBs > 0
		FDELPD(cVbAux,,)
		nDesc := SALMES * (nPerc / 100)
		nReemb := nVlrBs - nDesc
		nLim := VAL_SALMIN * (nMin / 100)
		If nReemb > nLim
			nReemb := nLim
		Endif
		FGERAVERBA(cVbAux,nReemb,,,,"V","G",,,,lRet,)
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fGREMIO     ºAutor  ³ Ronaldo Olvieira º Data ³ 01/08/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Mensalidade Gremio                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ V12 ºPRODAM                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fGREMIO()

	Local cTab, nLinha
	Local lRet			:= .T.
	Local cPerc		:= ""
	Local cVbAux		:= ""
	Local nSal			:= SRA->RA_SALARIO
	Local nHrs			:= SRA->RA_HRSMES
	cTab   := "U009"
	
	If SRA->RA_XGREMIO == "1"
		If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
			cPerc := fTabela(cTab,nLinha,5)
			cVbAux := fTabela(cTab,nLinha,6)
			If SRA->RA_CATFUNC == "H"
				nSal:= (nSal * nHrs)
			Endif
			FDELPD(cVbAux,,)
			FGERAVERBA(cVbAux,(nSal * (cPerc / 100)),,,,"V","G",,,,lRet,)
		EndIf
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fCooper     ºAutor  ³ Ronaldo Olvieira º Data ³ 01/08/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Aporte Cooperativa                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ V12 ºPRODAM                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fCooper()

	Local cTab, nLinha
	Local lRet			:= .T.
	Local nPerc		:= SRA->RA_XCOOPER
	Local nPerc2		:= SRA->RA_XCOOPE2
	Local cVbAux		:= cVbAux2 := ""
	Local nVlrAux		:= nVlrAux2 := 0
	Local nSal			:= SRA->RA_SALARIO
	Local nHrs			:= SRA->RA_HRSMES
	cTab   := "U010"
	
	If SRA->RA_CATFUNC == "H"
		nSal:= (nSal * nHrs)
	Endif
	
	
	If SRA->RA_XCOOPER > 0 .or. SRA->RA_XCOOPE2 > 0
		If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
			cVbAux := fTabela(cTab,nLinha,5)
			cVbAux2 := fTabela(cTab,nLinha,6)
				
			nVlrAux := nSal * (nPerc / 100)
			nVlrAux2 := nSal * (nPerc2 / 100)
			
			If nVlrAux > 0
				FDELPD(cVbAux,,)
				FGERAVERBA(cVbAux,(nSal * (nPerc / 100)),,,,"V","G",,,,lRet,)
			EndIf
			
			If nVlrAux2 > 0
				FDELPD(cVbAux2,,)
				FGERAVERBA(cVbAux2,(nSal * (nPerc2 / 100)),,,,"V","G",,,,lRet,)
			EndIf
		EndIf
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fConsig     ºAutor  ³ Ronaldo Olvieira º Data ³ 01/08/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Margem Emprestimo Consignado                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ V12 ºPRODAM                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fConsig()

	Local cTab, nLinha
	Local lRet			:= .T.
	Local cVbIR		:= aCodFol[066,1]
	Local cVbINSS	:= aCodFol[064,1]
	Local nSal := SRA->RA_SALARIO
	Local nValIR := nValINSS := nPercMarg := nPercPart := nPercSup := nPercMarg := nCoPart := nVlrPens:= nVlrConsig := nVlrCoPart := nMargem := nDesc := 0
	Local cPensao := cConsig := cCopart := cVbMargem := ""
	cTab   := "U011"

	If SRA->RA_CATFUNC == "H"
		nSal:= (nSal * nHrs)
	Endif
	If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
		nPercMarg := fTabela(cTab,nLinha,5)
		nPercPart := fTabela(cTab,nLinha,6)
		nPercSup := fTabela(cTab,nLinha,7)
		cCoPart := fTabela(cTab,nLinha,8)
		cPensao := fTabela(cTab,nLinha,9)
		cConsig := fTabela(cTab,nLinha,10)
		cVbMargem := fTabela(cTab,nLinha,11)
	EndIf

	nVlrPens := fBuscaPd(cPensao,"V",cSemana)
	nVlrConsig := fBuscaPd(cConsig,"V",cSemana)
	nVlrCoPart := fBuscaPd(cCopart,"V",cSemana)
	nValIR := fBuscaPd(cVbIR,"V",cSemana)
	nValINSS := fBuscaPd(cVbINSS,"V",cSemana)
	Aeval( aPd ,{ |X|  SomaInc(X,2,@nValDesc, , , , , , ,aCodFol) })

	nMargem := (nSal + nValIR + nValINSS + nVlrPens) * (nPercMarg / 100)
	nDesc := (nValDesc + nValIR + nValINSS + nVlrPens + nVlrCoPart) + (nSal * nPercPart / 100)
		
	If nDesc > nSal * (nPercSup / 100)
		nMargem := nMargem - nDesc
	Endif
	If nMargem > 0
		FDELPD(cVbMargem,,)
		FGERAVERBA(cVbMargem,nMargem,,,,"V","G",,,,lRet,)
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fCALCFER    ºAutor  ³ Ronaldo Olvieira º Data ³ 01/08/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calculo de Ferias                                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ V12 ºPRODAM                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fCALCFER()

	Local cTab, nLinha
	Local lRet			:= .T.
	Local cVbIR := aCodFol[067,1]
	Local cVbINSS := aCodFol[065,1]
	Local cVbFER := aCodFol[072,1]
	Local nDias := nDiasFer := nDesc := nDiasCalc := 0
	Local cVerba := ""

	cTab   := "U012"
	
	If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
		nDiasFer := fTabela(cTab,nLinha,5)
		nDias := fTabela(cTab,nLinha,6)
		cVerba := fTabela(cTab,nLinha,7)

		nDiasCalc := fBuscaPd(cVbFER,"H",cSemana)

		If nDiasCalc == nDiasFer

			nValIR := fBuscaPd(cVbIR,"V",cSemana)
			nValINSS := fBuscaPd(cVbINSS,"V",cSemana)
			nValFER := fBuscaPd(cVbFER,"V",cSemana)
	
			nDesc := ((nValFER + nValIR + nValINSS) / 30) * nDias

			If nDesc > 0
				FDELPD(cVerba,,)
				FGERAVERBA(cVerba,nDesc,,,,"V","G",,,,lRet,)
			Endif
		EndIf
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fCALCFER    ºAutor  ³ Ronaldo Olvieira º Data ³ 01/08/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calculo de Ferias  na Folha                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ V12 ºPRODAM                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fFERFOL()

	Local cTab, nLinha
	Local lRet			:= .T.
	Local cVerba := cVerbaFol := ""
	Local nDescFer := nDescFer := 0

	cTab   := "U012"
	
	If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
		cVerba := fTabela(cTab,nLinha,7)
		cVerbaFol := fTabela(cTab,nLinha,8)

		nDescFer := fBuscaPd(cVerba,"V",cSemana) * -1

		If nDescFer > 0
			nDiasFer := fBuscaPd(cVerba,"H",cSemana)
			FDELPD(cVerbaFol,,)
			FGERAVERBA(cVerbaFol,nDescFer,nDiasFer,,,"V","G",,,,lRet,)
		EndIf
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fINDCOMP    ºAutor  ³ Ronaldo Olvieira º Data ³ 01/08/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Indenizacao Compesatoria                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ V12 ºPRODAM                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fINDCOMP()

	Local cTab, nLinha
	Local lRet			:= .T.
	Local cVbIR := aCodFol[067,1]
	Local cVbINSS := aCodFol[065,1]
	Local cVbFER := aCodFol[072,1]
	Local cVbAvis := aCodFol[111,1]
	Local nAnosCasa	:= fAnosCasa( dDataDem , SRA->RA_ADMISSA )
	Local nSal := SRA->RA_SALARIO
	Local nHrs			:= SRA->RA_HRSMES
	Local nDias := nDiasFer := nDesc := nDiasCalc := nVlAvis := 0
	Local cVerba := ""

	If SRA->RA_CATFUNC == "H"
		nSal:= (nSal * nHrs)
	EndIf
	
	cTab   := "U013"
	
	If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
		nFx1Ini := fTabela(cTab,nLinha,5)
		nFx1Fim := fTabela(cTab,nLinha,6)
		nFx1Vlr := fTabela(cTab,nLinha,7)
		nFx2Fim := fTabela(cTab,nLinha,8)
		nFx2Vlr := fTabela(cTab,nLinha,9)
		nFx3Fim := fTabela(cTab,nLinha,10)
		nFx3Vlr := fTabela(cTab,nLinha,11)
		nFx4Fim := fTabela(cTab,nLinha,12)
		nFx4Vlr := fTabela(cTab,nLinha,13)
		cVerba := fTabela(cTab,nLinha,14)

		If NANOSCASA >= nFx1Ini .and. NANOSCASA < nFx1Fim
			nVlr := nSal * nFx1Vlr
		EndIf
		If NANOSCASA >= nFx1Fim .and. NANOSCASA < nFx2Fim
			nVlr := nSal * nFx2Vlr
		EndIf
		If NANOSCASA >= nFx2Fim .and. NANOSCASA < nFx3Fim
			nVlr := nSal * nFx3Vlr
		EndIf
		If NANOSCASA >= nFx3Fim .and. NANOSCASA < nFx4Fim
			nVlr := nSal * nFx4Vlr
		EndIf
		
		nVlAvis := fBuscaPd(cVbAvis,"V",cSemana)
		
		If nVlr > nVlAvis
			FDELPD(cVbAvis,,)
			FDELPD(cVerba,,)
			FGERAVERBA(cVerba,nVlr,NANOSCASA,,,"V","G",,,,lRet,)
		EndIf
	EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fDSRNOT     ºAutor  ³ Ronaldo Olvieira º Data ³ 01/08/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ DSR Adicional Noturno                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ V12 ºPRODAM                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fDSRNOT()

	Local cTab, nLinha
	Local lRet := .T.
	Local cVbADNOT := cVbDSRNOT := ""
	Local nHrDSRNot := nVlrADNot := nDiasNTrab:= nDiasTrab:= nDiasDSR := 0

	cTab   := "U014"

	If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
		cVbADNOT := fTabela(cTab,nLinha,5)
		cVbDSRNot := fTabela(cTab,nLinha,6)
	EndIf
	
	fCarPeriodo( cPeriodo , cRot , @aPeriodo, @lUltSemana, @nPosSem)
		
	nDiasNTrab := aPeriodo[nPosSem,8]
	nDiasTrab := aPeriodo[nPosSem,6]
	nDiasDSR := aPeriodo[nPosSem,7]
		
	nHrDSRNot := fBuscaPd(cVbADNOT,"H",cSemana)
	nVlrADNot := ((nHrDSRNot / nDiasTrab) * (nDiasDSR + nDiasNTrab)) * SALHORA
		
	If nVlrADNot > 0
		FDELPD(cVbDSRNOT,,)
		FGERAVERBA(cVbDSRNOT,nVlrADNot,(nDiasDSR + nDiasNTrab),,,"V","G",,,,lRet,)
	EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fPRORATA    ºAutor  ³ Ronaldo Olvieira º Data ³ 01/08/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Pro-Rata                                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ V12 ºPRODAM                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fPRORATA()

	Local cTab, nLinha
	Local lRet := .T.
	Local nSal		 	:= SRA->RA_SALARIO
	Local nHrs			:= SRA->RA_HRSMES
	Local nSalP1 := nSalP2 := 0
	Local cMesP1 := cMesP2 := cVerbaP1 := cVerbaP2 := ""
	
	If SRA->RA_CATFUNC == "H"
		nSal:= (nSal * nHrs)
	Endif

	cTab   := "U015"

	If SRA->RA_XPRORAT == "1"
		If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
			nSalP1 := fTabela(cTab,nLinha,5)
			cMesP1 := fTabela(cTab,nLinha,6)
			nSalP2 := fTabela(cTab,nLinha,7)
			cMesP2 := fTabela(cTab,nLinha,8)
			cVerbaP1 := fTabela(cTab,nLinha,9)
			cVerbaP2 := fTabela(cTab,nLinha,10)
		EndIf
		
	fCarPeriodo( cPeriodo , cRot , @aPeriodo, @lUltSemana, @nPosSem)
		
		If Substr(cPeriodo,5,2) == cMesP1 .and. nSalP1 > 0
			FDELPD(cVerbaP1,,)
			FGERAVERBA(cVerbaP1,(nSal * (nSalP1 / 100)),(nSalP1 / 100),,,"V","G",,,,lRet,)
		EndIf
		If Substr(cPeriodo,5,2) == cMesP2 .and. nSalP2 > 0
			FDELPD(cVerbaP2,,)
			FGERAVERBA(cVerbaP2,(nSal * (nSalP2 / 100)),(nSalP2 / 100),,,"V","G",,,,lRet,)
		EndIf
	EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fADICTIT    ºAutor  ³ Ronaldo Olvieira º Data ³ 01/08/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Adicional de Titulacao                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ V12 ºPRODAM                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fADICTIT()

	Local cTab, nLinha
	Local lRet := .T.
	Local nPercTit := nVlrBase := nVltTit := 0
	Local cTit := cTabRef := cVerba := ""
	
	cTab   := "U016"

	If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
		If SRA-> RA_CODTIT == fTabela(cTab,nLinha,5)
			cTit := fTabela(cTab,nLinha,5)
			nPercTit := fTabela(cTab,nLinha,6)
		EndIf
		If SRA-> RA_CODTIT == fTabela(cTab,nLinha,7)
			cTit := fTabela(cTab,nLinha,7)
			nPercTit := fTabela(cTab,nLinha,8)
		EndIf
		If SRA-> RA_CODTIT == fTabela(cTab,nLinha,9)
			cTit := fTabela(cTab,nLinha,9)
			nPercTit := fTabela(cTab,nLinha,10)
		EndIf
		If SRA-> RA_CODTIT == fTabela(cTab,nLinha,11)
			cTit := fTabela(cTab,nLinha,11)
			nPercTit := fTabela(cTab,nLinha,12)
		EndIf
		cTabRef := fTabela(cTab,nLinha,13)
		cVerba := fTabela(cTab,nLinha,14)
	EndIf

	dbSelectArea("RBR")
	dbSetOrder(1)
	If dbSeek( xFilial("RBR") + cTabRef)
		While !Eof()
			If RBR->RBR_TABELA == cTabRef
				nVlrBase	:= RBR->RBR_VLREF
			Endif
			dbSkip()
		Enddo
	Endif

	nVltTit := nVlrBase * (nPercTit / 100)

	If nVltTit > 0
		FDELPD(cVerba,,)
		FGERAVERBA(cVerba,nVltTit,nPercTit,,,"V","G",,,,lRet,)
	EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TCFA040     ºAutor  ³ Ronaldo Olvieira º Data ³ 01/08/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Botao de Aprovacao Bolsa Estudo                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ V12 ºPRODAM                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TCFA040()
	Local aParam := PARAMIXB
	oObj := aParam[1]
	cIdPonto := aParam[2]
	cIdModel := aParam[3]
	xRet := .T.

	If RH3->RH3_TIPO == "V" .and. cIdPonto == 'BUTTONBAR'
		xRet := { {'Aprov.Subsidio', 'SALVAR', { || u_fAprovEst() }, 'Aprovado' } }
	EndIf
Return xRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fAprovEst     ºAutor  ³ Rondo Olvieira º Data ³ 01/08/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Aprovacao da Bolsa Estudo                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ V12 ºPRODAM                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fAprovEst()
	DbSelectArea("SRA")
	DbSetOrder(1)
	If DbSeek(xFilial("SRA")+SRA->RA_MAT)
		RecLock("SRA",.F.)
		SRA->RA_XESTUDO  := "1"
		SRA->(MsUnLock())
	Endif
	SRA->(dbSkip())
	
	DbSelectArea("RH3")
	DbSetOrder(1)
	If DbSeek(xFilial("RH3")+RH3->RH3_CODIGO)
		RecLock("RH3",.F.)
		RH3->RH3_STATUS := "2"
		RH3->RH3_DTATEN := DDATABASE
		RH3->(MsUnLock())
	Endif
	RH3->(dbSkip())
	
	Alert("Solicitacao Aprovada")
 Return
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fDescVRVA   ºAutor  ³ Ronaldo Olvieira º Data ³ 01/08/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Desconto da Base Empresa de VR e VA                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ V12 ºPRODAM                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fDescVRVA()

	Local cTab, nLinha
	Local lRet		:= .T.
	Local cVbVR	:= aCodFol[212,1]
	Local cVbVA	:= P_PDVAEMP
	Local cDescVR := cDescVA := ""
	Local nPercVR := nPercVA := nVlrVR := nVlrVA := nDescVR := nDescVA := 0

	cTab   := "U017"

	If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
		nPercVR := fTabela(cTab,nLinha,5)
		nPercVA := fTabela(cTab,nLinha,6)
		cDescVR := fTabela(cTab,nLinha,7)
		cDescVA := fTabela(cTab,nLinha,8)
	EndIf

	nVlrVR := fBuscaPd(cVbVR,"V",cSemana)
	nVlrVA := fBuscaPd(cVbVA,"V",cSemana)

	nDescVR := 	nVlrVR * (nPercVR/100)
	nDescVA := 	nVlrVA * (nPercVA/100)
		
	If nDescVR > 0
		FDELPD(cDescVR,,)
		FGERAVERBA(cDescVR,nDescVR,,,,"V","G",,,,lRet,)
		FDELPD(cVbVR,,)
		FGERAVERBA(cVbVR,(nVlrVR - nDescVR),,,,"V","G",,,,lRet,)
	Endif
	
	If nDescVR > 0
		FDELPD(cDescVA,,)
		FGERAVERBA(cDescVA,nDescVA,,,,"V","G",,,,lRet,)
		FDELPD(cVbVA,,)
		FGERAVERBA(cVbVA,(nVlrVA - nDescVA),,,,"V","G",,,,lRet,)
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MDGPEA370   ºAutor  ³ Ronaldo Olvieira º Data ³ 01/08/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada na Confirmacao do Cargo                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ V12 ºPRODAM                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MDGPEA370()
	Local aParam := PARAMIXB
	oObj := aParam[1]
	cIdPonto := aParam[2]
	cIdModel := aParam[3]
	xRet := .T.

	If cIdPonto == 'MODELCOMMITTTS'
		u_fGravaSRJ()
	EndIf
Return xRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fGravaSRJ   ºAutor  ³ Ronaldo Olvieira º Data ³ 01/08/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gravacao dos Dados do Cargo na Funcao                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ V12 ºPRODAM                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fGravaSRJ()
	DbSelectArea("RHL")
	DbSetOrder(1)
	If SRJ->(dbSeek(xFilial("SQ3") + SQ3->Q3_CARGO ))
		RecLock("SRJ",.F.)
		SRJ->RJ_FILIAL := ALLTRIM(SQ3->Q3_FILIAL)
		SRJ->RJ_FUNCAO := ALLTRIM(SQ3->Q3_CARGO)
		SRJ->RJ_DESC := SQ3->Q3_DESCSUM
		SRJ->RJ_CODCBO := SQ3->Q3_XCODCBO
		SRJ->RJ_MAOBRA := SQ3->Q3_XMAOBRA
		SRJ->RJ_CARGO := SQ3->Q3_CARGO
		SRJ->RJ_SALARIO := SQ3->Q3_XSALARI
		SRJ->RJ_PPPIMP := SQ3->Q3_XPPPIMP
		SRJ->RJ_LIDER := SQ3->Q3_XLIDER
		SQ3->(MsUnLock())
	Else
		RecLock("SRJ",.T.)
		SRJ->RJ_FILIAL := ALLTRIM(SQ3->Q3_FILIAL)
		SRJ->RJ_FUNCAO := ALLTRIM(SQ3->Q3_CARGO)
		SRJ->RJ_DESC := SQ3->Q3_DESCSUM
		SRJ->RJ_CODCBO := ALLTRIM(SQ3->Q3_XCODCBO)
		SRJ->RJ_MAOBRA := SQ3->Q3_XMAOBRA
		SRJ->RJ_CARGO := SQ3->Q3_CARGO
		SRJ->RJ_SALARIO := SQ3->Q3_XSALARI
		SRJ->RJ_PPPIMP := SQ3->Q3_XPPPIMP
		SRJ->RJ_LIDER := SQ3->Q3_XLIDER
		SQ3->(MsUnLock())
	EndIf
	DbCloseArea()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fRegProp    ºAutor  ³ Ronaldo Olvieira º Data ³ 01/08/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Regime Proprio Previdencia Social                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ V12 ºPRODAM                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fRegProp()

	Local cTab, nLinha
	Local lRet := .T.
	Local cVbFunc  := cVbEmp := cVbBase := ""
	Local nVlrBase := SRA->RA_XVLRCED
	Local nPerFunc := SRA-> RA_XCEDFUN
	Local nPercEmp := SRA-> RA_XCEDEMP
	Local nHrs		 := SRA->RA_HRSMES

	cTab   := "U020"
	
	If SRA->RA_CATFUNC == "H"
		nVlrBase:= (nVlrBase * nHrs)
	Endif

	If SRA->RA_XCEDIDO == "1"
		If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
			cVbFunc := fTabela(cTab,nLinha,5)
			cVbEmp := fTabela(cTab,nLinha,6)
			cVbBase := fTabela(cTab,nLinha,7)
		Endif
		
		nVlrFunc := nVlrBase * (nPerFunc / 100)
		nVlrEmp := nVlrBase * (nPercEmp / 100)
		
		If nVlrBase > 0
			FDELPD(cVbBase,,)
			FGERAVERBA(cVbBase,nVlrBase,100.00,,,"V","G",,,,lRet,)
		EndIf

		If nVlrFunc > 0
			FDELPD(cVbFunc,,)
			FGERAVERBA(cVbFunc,nVlrFunc,nPerFunc,,,"V","G",,,,lRet,)
		EndIf

		If nVlrEmp > 0
			FDELPD(cVbEmp,,)
			FGERAVERBA(cVbEmp,nVlrEmp,nPercEmp,,,"V","G",,,,lRet,)
		EndIf
	
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fDescBH     ºAutor  ³ Ronaldo Olvieira º Data ³ 01/08/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Desconto Limite Banco de Horas                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ V12 ºPRODAM                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fDescBH()

	Local cTab, nLinha
	Local lRet		:= .T.
	Local nSal		:= SRA->RA_SALARIO
	Local nHrs		:= SRA->RA_HRSMES
	Local cVbDesc := cVbBase := cPerProj := ""
	Local nPerc 	:= nLim := nVlrBase := nVlrLim := nVlrParc := nVlrRest := nHrsBase := nSalHora := 0
	Local nParc	:= 1
	Local dDataProj := CtoD("//")

	cTab   := "U018"

	If SRA->RA_CATFUNC == "H"
		nSal:= (nSal * nHrs)
	Endif
	
	nSalHora:= nSal / nHrs
	
	If (nLinha := fPosTab(cTab,SRA->RA_SINDICA,"=",4)) > 0
		nPerc := fTabela(cTab,nLinha,5)
		cVbDesc := fTabela(cTab,nLinha,6)
		cVbBase := fTabela(cTab,nLinha,7)
	EndIf

	nHrsBase := fBuscaPd(cVbBase,"H",cSemana)
	nVlrBase := nHrsBase * nSalHora
	nLim := nSal * (nPerc / 100)

	If nVlrBase > nLim
		nParc := int(nVlrBase/nLim)
		nVlrParc := nLim
		nVlrRest := nVlrBase - (nLim * nParc)
	Else
		nVlrParc := nVlrBase
	EndIf
	
	DbSelectArea("SRK")
	DbSetOrder(4)

	If nVlrParc > 0
		If SRK->(dbSeek(xFilial("SRA") + SRA->RA_MAT + cVbDesc + cPeriodo + cSemana  ))
			RecLock("SRK",.F.)
			SRK->RK_FILIAL := SRA->RA_FILIAL
			SRK->RK_PD := cVbDesc
			SRK->RK_MAT := SRA->RA_MAT
			SRK->RK_VALORTO := nVlrParc * nParc
			SRK->RK_PARCELA := nParc
			SRK->RK_VALORPA := nVlrParc
			SRK->RK_DTVENC := dDataRef
			SRK->RK_QUITAR := '2'
			SRK->RK_EMPCONS := '2'
			SRK->RK_VLSALDO := nVlrParc * nParc
			SRK->RK_CC := SRA->RA_CC
			SRK->RK_DTMOVI := dDataRef
			SRK->RK_PERINI := cPeriodo
			SRK->RK_NUMPAGO := cSemana
			SRK->RK_PROCES := SRA->RA_PROCES
			SRK->RK_STATUS := '2'
			SRK->RK_NUMID := "BH" + cPeriodo
			SRK->RK_REGRADS := '1'
			SRK->RK_POSTO := SRA->RA_POSTO
			SRK->RK_DOCUMEN := "BH" + ALLTRIM(RIGHT(Year2Str(dDataRef),2)) + ALLTRIM(Month2Str(dDataRef))
			SRK->(MsUnLock())
		Else
			RecLock("SRK",.T.)
			SRK->RK_FILIAL := SRA->RA_FILIAL
			SRK->RK_PD := cVbDesc
			SRK->RK_MAT := SRA->RA_MAT
			SRK->RK_VALORTO := nVlrParc * nParc
			SRK->RK_PARCELA := nParc
			SRK->RK_VALORPA := nVlrParc
			SRK->RK_DTVENC := dDataRef
			SRK->RK_QUITAR := '2'
			SRK->RK_EMPCONS := '2'
			SRK->RK_VLSALDO := nVlrParc * nParc
			SRK->RK_CC := SRA->RA_CC
			SRK->RK_DTMOVI := dDataRef
			SRK->RK_PERINI := cPeriodo
			SRK->RK_NUMPAGO := cSemana
			SRK->RK_PROCES := SRA->RA_PROCES
			SRK->RK_STATUS := '2'
			SRK->RK_NUMID := "BH" + cPeriodo
			SRK->RK_REGRADS := '1'
			SRK->RK_POSTO := SRA->RA_POSTO
			SRK->RK_DOCUMEN := "BH" + ALLTRIM(RIGHT(Year2Str(dDataRef),2)) + ALLTRIM(Month2Str(dDataRef))
			SRK->(MsUnLock())
		EndIf
	EndIf
	If nVlrRest > 0
			dDataProj := DaySum(dDataRef,((nParc+1)*30))
			cPerProj:= AllTrim(Str(Year(dDataProj))) + RIGHT("0" + AllTrim(Str(Month(dDataProj))),2)
		If SRK->(dbSeek(xFilial("SRA") + SRA->RA_MAT + cVbDesc + cPerProj + cSemana  ))
			RecLock("SRK",.F.)
			SRK->RK_FILIAL := SRA->RA_FILIAL
			SRK->RK_PD := cVbDesc
			SRK->RK_MAT := SRA->RA_MAT
			SRK->RK_DOCUMEN := cVbDesc+cPerProj
			SRK->RK_VALORTO := nVlrRest
			SRK->RK_PARCELA := 1
			SRK->RK_VALORPA := nVlrRest
			SRK->RK_DTVENC := DaySum(dDataRef,((nParc+1)*30))
			SRK->RK_QUITAR := '2'
			SRK->RK_EMPCONS := '2'
			SRK->RK_VLSALDO := nVlrRest
			SRK->RK_CC := SRA->RA_CC
			SRK->RK_DTMOVI := DaySum(dDataRef,((nParc+1)*30))
			SRK->RK_PERINI := cPerProj
			SRK->RK_NUMPAGO := cSemana
			SRK->RK_PROCES := SRA->RA_PROCES
			SRK->RK_STATUS := '2'
			SRK->RK_NUMID := "BP" + cPeriodo
			SRK->RK_REGRADS := '1'
			SRK->RK_POSTO := SRA->RA_POSTO
			SRK->RK_DOCUMEN := "BP" + ALLTRIM(RIGHT(Year2Str(dDataRef),2)) + ALLTRIM(Month2Str(dDataRef))
			SRK->(MsUnLock())
		Else
			RecLock("SRK",.T.)
			SRK->RK_FILIAL := SRA->RA_FILIAL
			SRK->RK_PD := cVbDesc
			SRK->RK_MAT := SRA->RA_MAT
			SRK->RK_VALORTO := nVlrRest
			SRK->RK_PARCELA := 1
			SRK->RK_VALORPA := nVlrRest
			SRK->RK_DTVENC := DaySum(dDataRef,((nParc+1)*30))
			SRK->RK_QUITAR := '2'
			SRK->RK_EMPCONS := '2'
			SRK->RK_VLSALDO := nVlrRest
			SRK->RK_CC := SRA->RA_CC
			SRK->RK_DTMOVI := DaySum(dDataRef,((nParc+1)*30))
			SRK->RK_PERINI := cPerProj
			SRK->RK_NUMPAGO := cSemana
			SRK->RK_PROCES := SRA->RA_PROCES
			SRK->RK_STATUS := '2'
			SRK->RK_NUMID := "BP" + cPeriodo
			SRK->RK_REGRADS := '1'
			SRK->RK_POSTO := SRA->RA_POSTO
			SRK->RK_DOCUMEN := "BP" + ALLTRIM(RIGHT(Year2Str(dDataRef),2)) + ALLTRIM(Month2Str(dDataRef))
			SRK->(MsUnLock())
		EndIf
	EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fCalc131    ºAutor  ³ Ronaldo Olvieira º Data ³ 01/08/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calculo 1a. Parcela 13o. Salario                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ V12 ºPRODAM                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fCalc131()

	Local nCont	:= 0
	Local cVerba 	:= ""
	
	RCM->(dbSetOrder( 1 ))
	RCM->(dbSeek(xFilial("RCM")))

	Do While !(RCM->(Eof())) .and. RCM->RCM_TIPOAF == "4"
	
		cVerba := RCM->RCM_PD

		SR8->(dbSetOrder( 8 ))
		SR8->(dbSeek( SRA->(RA_FILIAL + RA_MAT)))

		Do While !(SR8->(Eof())) .and. SR8->(R8_FILIAL + R8_MAT) == SRA->(RA_FILIAL + RA_MAT)

			If SR8->R8_DATAINI >= MV_PAR09 .and. SR8->R8_DATAFIM <= MV_PAR10 .and. SR8->R8_PD == cVerba
				nCont := nCont++
			EndIf
	
			SR8->(dbSkip())
		EndDo
	
		RCM->(dbSkip())
	EndDo
                      
	If nCont == 0 .and. !Empty(MV_PAR09) .and. !Empty(MV_PAR10)
		NoPrcReg()
	Endif
Return

