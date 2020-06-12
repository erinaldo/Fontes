#Include "Protheus.ch"
#Include "RwMake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F050TMP1  ºAutor  ³Felipe Alves        º Data ³  27/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function F050TMP1()

Local lAuto  := ParamIXB[8]
Local nOrig  := ParamIXB[9]
Local lCDV   := IsInCallStack("U_FICDVA01")
Local nValor := 0

//If ((lAuto) .And. (lCDV) .And. (nOrig == 2))
If (nOrig == 2)
	If (lAuto) .And. (lCDV)
		aArea := {GetArea(), SZ0->(GetArea()), SZ1->(GetArea())}
		nValor := SZ1->Z1_ADIANTA
	
		DbSelectArea("SZ0")
		SZ0->(DbSetOrder(1))
		
		If (SZ0->(DbSeek(xFilial("SZ0") + SZ1->Z1_NUM)))
			While ((SZ0->(!Eof())) .And. (xFilial("SZ0") == SZ0->Z0_FILIAL) .And. (SZ1->Z1_NUM == SZ0->Z0_NUMSV))
				RecLock("TMP", .T.)
				If mv_par03 == 1 //Informa Contas no Rateio 1=SIM; 2=NAO
					TMP->CTJ_DEBITO := SZ0->Z0_CONTA
				EndIf
				TMP->CTJ_PERCEN := SZ0->Z0_PERC
				TMP->CTJ_VALOR  := nValor * (SZ0->Z0_PERC / 100)
				TMP->CTJ_HIST   := "SOLIC VIAGENS N." + AllTrim(SZ0->Z0_NUMSV)
				TMP->CTJ_CCD    := SZ0->Z0_CCUSTO
				TMP->CTJ_ITEMD  := SZ0->Z0_ITEMCTA
				TMP->CTJ_FLAG   := .F.
				TMP->(MsUnlock())
				
				SZ0->(DbSkip())
			Enddo
		Endif
	Else
		nValor := F050Carr(ParamIxb[1],ParamIxb[2],ParamIxb[3],ParamIxb[4],ParamIxb[5],ParamIxb[6],ParamIxb[7])
	Endif
Endif
Return({nValor, Iif(lAuto, 0, 1)})