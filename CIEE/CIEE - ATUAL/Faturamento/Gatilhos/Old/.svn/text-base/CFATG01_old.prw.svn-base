
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFATG01   ºAutor  ³Microsiga           º Data ³  04/23/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CFATG01()

Local _nPsProd,_nPsDesc,_nPsVlr, _nPsQtde,_nPsQtLib,_nPsTotal
Local _cVarAnt	:= __READVAR

DbSelectArea("PAD")
DbSetOrder(1)
If DbSeek(xFilial("PAD")+M->C6_XPATRIM)
	DbSelectArea("PAE")
	DbSetOrder(1)
	If DbSeek(xFilial("PAE")+PAD->PAD_GRUPO)

		_nPsProd   := aScan(aheader, {|x| AllTrim(x[2]) == "C6_PRODUTO"})
		_nPsDesc   := aScan(aheader, {|x| AllTrim(x[2]) == "C6_DESCRI"})
		_nPsVlr    := aScan(aheader, {|x| AllTrim(x[2]) == "C6_PRCVEN"})
		_nPsQtde   := aScan(aheader, {|x| AllTrim(x[2]) == "C6_QTDVEN"})
		_nPsQtLib   := aScan(aheader, {|x| AllTrim(x[2]) == "C6_QTDLIB"})
		_nPsTotal  := aScan(aheader, {|x| AllTrim(x[2]) == "C6_VALOR"})

		aCols[1,_nPsProd]  := PAE->PAE_CODPRO
		
		__READVAR := "M->C6_PRODUTO"
		M->C6_PRODUTO := aCols[1,_nPsProd]
		If u_ValCampo("C6_PRODUTO")
			If ExistTrigger("C6_PRODUTO")
				RunTrigger(2,1,Nil,,"C6_PRODUTO")
			EndIf
		EndIf

		__READVAR := _cVarAnt
		
//		aCols[n,_nPsDesc]  := PAE->PAE_DESGRP
//		aCols[n,_nPsQtde]  := 1
//		aCols[n,_nPsQtLib] := 1
//		aCols[n,_nPsVlr]   := PAD->PAD_VLNF
//		aCols[n,_nPsTotal] := PAD->PAD_VLNF
		
	EndIf
EndIf

GetDRefresh()

Return(aCols[1,_nPsProd])

User Function ValCampo(cCpo)

Local cSavAlias := Alias()
Local nSavOrd, lRet := .T.
If Select("SX3") > 0
	DbSelectArea("SX3")
	nSavOrd := IndexOrd()
	DbSetOrder(2)
	DbSeek(cCpo)
	
	IF !Empty(SX3->X3_VALID)
		If !(&(SX3->X3_VALID))
			lRet := .F.
		EndIf
	EndIf

	IF lRet .and. !Empty(SX3->X3_VLDUSER)
		If !(&(SX3->X3_VLDUSER))
			lRet := .F.
		EndIf
	EndIf
	
	DbSetOrder(nSavOrd)
	DbSelectArea(cSavAlias)
EndIf

Return(lRet)