#INCLUDE 'Protheus.ch'

User Function MT110CP2

//Local aItens := PARAMIXB[1]
//Local oQual  := PARAMIXB[2]

Local aAreaSC1 := SC1->(GetArea())
Local aItens := PARAMIXB[1]
Local oQual  := PARAMIXB[2]
Local nX  := 0

// Adiciona titulo da coluna que esta sendo incluída
AADD(oQual:AHEADERS,RetTitle("C1_XCMUN"))
AADD(oQual:AHEADERS,RetTitle("C1_XCMTOT"))

// Adiciona campo da coluna que esta sendo incluída
cNumSC := SC1->C1_NUM
DbSelectArea("SC1")
DbSetOrder(1)
For nX := 1 To Len(oQual:AARRAY)
	MsSeek(xFilial("SC1")+cNumSC)
	While !Eof() .And. C1_FILIAL == xFilial("SC1") .And. C1_NUM == cNumSc
		If C1_PRODUTO  == oQual:AARRAY[nX][1] .And. ;
			C1_UM      == oQual:AARRAY[nX][2] .And. ;
			C1_QUANT   == oQual:AARRAY[nX][3] .And. ;
			C1_OBS     == oQual:AARRAY[nX][4] .And. ;
			C1_EMISSAO == oQual:AARRAY[nX][5] .And. ;
			C1_DESCRI  == oQual:AARRAY[nX][6] .And. ;
			C1_FILENT  == oQual:AARRAY[nX][7]
			AADD(oQual:AARRAY[nX],SC1->C1_XCMUN)
			AADD(oQual:AARRAY[nX],SC1->C1_XCMTOT)
			Exit
		EndIf
		DbSkip()
	EndDo
Next nX

// Redefine bLine do objeto oQual inlcuindo a coluna nova
aItens := oQual:AARRAY
oQual:bLine := { || {aItens[oQual:nAT][1],aItens[oQual:nAT][2],aItens[oQual:nAT][3],aItens[oQual:nAT][4],aItens[oQual:nAT][5],aItens[oQual:nAT][6],aItens[oQual:nAT][7],aItens[oQual:nAT][8],aItens[oQual:nAT][9]}}
// 1-Produto; 2-Unid.Medida; 3-Quantidade; 4-Obs.; 5-Dt.Emissao; 6-Descricao; 7-Fil.Entrega; 8-Custo Medio; 9-Custo Medio Total

RestArea(aAreaSC1)

Return