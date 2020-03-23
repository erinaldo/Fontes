#INCLUDE 'PROTHEUS.CH'

User Function FT300PV()
Local aCabec	:= {}
Local aItens	:= {}
Local nVend 	:= 2
Local cVendSA1	:= ""

aAdd(aCabec,{"C5_TPFRETE",Iif(ADY->ADY_XFRETE == "0","F",Iif(ADY->ADY_XFRETE $ "1|2","C","S")),Nil}) 
aAdd(aCabec,{"C5_FRETE",Iif(ADY->ADY_XFRETE == "2",0,ADY->ADY_XVLFRT),Nil})
aAdd(aCabec,{"C5_MENNOTA",ADY->ADY_MENNOTA,Nil})
aAdd(aCabec,{"C5_OBSPV",ADY->ADY_OBSPV,Nil})
aAdd(aCabec,{"C5_XPENINS",ADY->ADY_XPENIN,Nil})
aAdd(aCabec,{"C5_XPROPOS",SCJ->CJ_PROPOST,Nil})
aAdd(aCabec,{"C5_XNROPOR",SCJ->CJ_NROPOR,Nil})
aAdd(aCabec,{"C5_XREVIS",ADY->ADY_XREVIS,Nil})

//-- Troca os vendedores:
//-- De acordo com Miriã, vendedor será sempre o vendedor do cliente e os demais do time de vendas da oportunidade
cVendSA1 := GetAdvFVal("SA1","A1_VEND",xFilial("SA1")+SCJ->(CJ_CLIENTE+CJ_LOJA),1)
If !Empty(cVendSA1) .And. cVendSA1 <> ADY->ADY_VEND
	aAdd(aCabec,{"C5_VEND2",cVendSA1,Nil})
	nVend++
EndIf

AD2->(dbSetOrder(1))
AD2->(MsSeek(xFilial("AD2")+ADY->(ADY_OPORTU+ADY_REVISA)))
While !AD2->(EOF()) .And. AD2->(AD2_FILIAL+AD2_NROPOR+AD2_REVISA) == xFilial("AD2")+ADY->(ADY_OPORTU+ADY_REVISA)
	If AD2->AD2_VEND <> ADY->ADY_VEND	//-- Quem digita a proposta não é o vendedor
		aAdd(aCabec,{"C5_VEND"+Str(nVend,1),AD2->AD2_VEND,Nil})
		nVend++
	EndIf
	
	If nVend > 5
		Exit
	Else	
		AD2->(dbSkip())
	EndIf
End

Return {aCabec,aItens}