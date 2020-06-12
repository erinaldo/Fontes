
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LP650H    ºAutor  ³Emerson Natali      º Data ³  02/07/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atraves da matriz aDupl e pego o Vencto da tela de Duplic  º±±
±±º          ³ do compras                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION LP650H()
Local _aArea := GetArea()
Local _cHist := ""
Local _cEspecie:=Iif(TRIM(SF1->F1_ESPECIE)=="SPED","NF-e",TRIM(SF1->F1_ESPECIE))

_cHist := _cEspecie+" "+TRIM(SF1->F1_DOC)+" "+SUBSTR(ADUPL[1],19,8)+" "+TRIM(SA2->A2_NREDUZ)

RestArea(_aArea)

RETURN(_cHist)

/*----------------------------------------------------------------
*
* u_LP650Deb()
* Regra de composição da conta Debito no LP 650
*
----------------------------------------------------------------*/
User Function LP650Deb(lGatilho)

Local aArea:=GetArea()
Local _cDebito:=''
Local _cItemD :=''
Local _cProd:=''

If lGatilho
	_cProd:=M->D1_COD
Else
	_cProd:=SD1->D1_COD
EndIf

dbSelectArea('SB1')
dbSetOrder(1)
dbSeek(xFilial('SB1')+_cProd)

If !Empty(SB1->B1_CONTA)
	_cDebito:=SB1->B1_CONTA
Else
	dbSelectArea("SBM")
	dbSetORder(1)
	dbSeek(xFILIAL("SBM")+SB1->B1_GRUPO)
	//If TRIM(SD1->D1_TES)$"004/104"
	If Substr(SB1->B1_COD,4,1)=="0"//Produto controle de estoque
		_cDebito:=BM_CCONTA1
	Else
		_cDebito:=BM_CCONTA2
	EndIF
EndIf

//Pega conta Reduzida
dbSelectArea('CT1')
dbSetOrder(1)
dbSeek(xFilial('CT1')+_cDebito)
_cItemD:=CT1_RES

RestArea(aArea)

Return({_cDebito,_cItemD})

/*----------------------------------------------------------------
*
* u_LP650Vlr()
* Regra de composição do valor do LP
*
----------------------------------------------------------------*/
User Function LP650Vlr(_nOption)

Local nVal:=0
Local _cTES:=""

//IIF(IsInCallStack("U_CFINA55"),0,IIF(!(SF1->F1_ESPECIE=="SPED " .AND. SF1->F1_FORMUL=="S"),IIF(SD1->D1_RATEIO=="2",SD1->(D1_TOTAL-D1_VALDESC+D1_DESPESA+D1_VALFRE),0),0))

IF IsInCallStack("U_CFINA55") .Or. (Alltrim(SF1->F1_ESPECIE)=="SPED" .AND. Alltrim(SF1->F1_FORMUL)=="S")
	nVal:=0
Else
	_cTES:=u_LP650TES()
	//If !(SF1->F1_ESPECIE=="SPED" .AND. SF1->F1_FORMUL=="S") .And. SD1->D1_RATEIO=="2" .And. !(SD1->D1_TES $ _cTES)
	If SD1->D1_RATEIO=="2" .And. !(SD1->D1_TES $ _cTES)
		If _nOption==1//VAlor de lancamento Debito
			nVal:= SD1->(D1_TOTAL-D1_VALDESC+D1_DESPESA+D1_VALFRE)
		Else//Credito
			//IIF(IsInCallStack("U_CFINA55"),0,IIF(!(SF1->F1_ESPECIE=="SPED " .AND. SF1->F1_FORMUL=="S"),SD1->(D1_TOTAL-D1_VALDESC+D1_DESPESA+D1_VALFRE)-SD1->(D1_VALIMP6+D1_VALIRR+D1_VALINS+D1_VALISS),0))
			nVal:= SD1->(D1_TOTAL-D1_VALDESC+D1_DESPESA+D1_VALFRE)-SD1->(D1_VALIMP6+D1_VALIRR+D1_VALINS+D1_VALISS)
		EndIf
	Else
		nVal:=0
	EndIF
EndIf
Return(nVal)

/*----------------------------------------------------------------
*
* u_LP650TES()
* Lista de TES a nao serem consideradas no lançamento.
* Funcion utilizada também em MT100LOK.prw
*
----------------------------------------------------------------*/
User Function LP650TES()
Return("001/002/007/010")