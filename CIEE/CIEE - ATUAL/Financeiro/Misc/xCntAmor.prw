#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO8     ºAutor  ³Microsiga           º Data ³  08/18/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de Contabilizacao da Amortizacao                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function xCntAmor(cCntDeb,cCCDeb,nParc,cHist,cCntCred,cCCCred,nValor,cKey)

//*************************************************
//INICIO Contabiliza Amortizacao
//*************************************************

cMes		:= Val(Substr(DTOC(dDatabase),4,2))
cAno		:= Val(Substr(DTOC(dDatabase),7,4))
_cMesCont	:= cMes
_cAnoCont	:= cAno
// Data Ultimo dia Util
_DtCont		:= DataValida(LastDay(ctod("01/"+Str(_cMesCont,2)+"/"+Str(_cAnoCont,4))),.F.)
_aData		:= {}
Aadd(_aData,_DtCont)

For _nY	:= 1 to (nParc-1)
	_cMesCont	:= cMes+1
	_cAnoCont	:= iif( _cMesCont >=13 , _cAnoCont+1 , _cAnoCont)
	_cMesCont	:= iif( _cMesCont >=13 , 01          , _cMesCont)
	cMes		:= _cMesCont
	 // Data Ultimo dia Util
	_DtCont		:= DataValida(LastDay(ctod("01/"+Str(_cMesCont,2)+"/"+Str(_cAnoCont,4))),.F.)
	Aadd(_aData,_DtCont)
Next

_nCont := Len(_aData)

_nVal		:= Round(nValor/nParc,2)
_nValDif	:= (_nVal * _nCont) - nValor

For _nIx :=1 to Len(_aData)

	aCab		:= {}
	aItem		:= {}
	aTotItem	:= {}
	lMsErroAuto := .f.
	_nLin		:= 1

	aCab := {	{"dDataLanc", _aData[_nIx] ,NIL},;
				{"cLote"	, "009200"	,NIL},;
				{"cSubLote"	, "001"		,NIL}}

	AADD(aItem,{	{"CT2_FILIAL"	, xFilial("CT2")				, NIL},;
					{"CT2_LINHA"	, StrZero(_nLin,3)				, NIL},;
					{"CT2_DC"		, "3"	 						, NIL},;	//Debito
					{"CT2_ITEMD"	, ALLTRIM(cCntDeb)				, NIL},;	//DEBITO  Item Contabil
					{"CT2_CCD"		, ALLTRIM(cCCDeb)				, NIL},;	//DEBITO  Centro de Custo
					{"CT2_ITEMC"	, ALLTRIM(cCntCred)				, NIL},;	//CREDITO Item Contabil
					{"CT2_CCC"		, ALLTRIM(cCCCred)				, NIL},;	//CREDITO Centro de Custo
					{"CT2_VALOR"	, _nVal							, NIL},;
					{"CT2_HP"		, ""							, NIL},;
					{"CT2_HIST"		, cHist	        				, NIL},;
					{"CT2_TPSALD"	, "9"							, NIL},;
					{"CT2_ORIGEM"	, "749 "+cHist					, NIL},;
					{"CT2_MOEDLC"	, "01"							, NIL},;
					{"CT2_EMPORI"	, ""							, NIL},;
					{"CT2_ROTINA"	, ""							, NIL},;
					{"CT2_LP"		, ""							, NIL},;
					{"CT2_XKEY"		, cKey 							, NIL},;
					{"CT2_KEY"		, cKey							, NIL}})
					_nLin++

	aadd(aTotItem,aItem)
	MSExecAuto({|a,b,C| Ctba102(a,b,C)},aCab,aItem,3)
	aTotItem	:=	{}

	If lMsErroAuto
		DisarmTransaction()
		MostraErro()
		Return .F.
	Endif

	aCab	:= {}
	aItem	:= {}

	_nCont	:= _nCont - 1
	If _nCont == 1
		_nVal	:= _nVal - _nValDif
	EndIf

Next

//*************************************************
//FIM Contabiliza Amortizacao
//*************************************************

MsgBox (OemToAnsi("Contabilização Amortização Finalizado!!!"), OemToAnsi("Amortização"), "INFO")

Return