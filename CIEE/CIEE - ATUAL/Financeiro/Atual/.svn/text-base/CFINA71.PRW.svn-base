#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#include "_FixSX.ch"
#include "TOPCONN.ch"

User Function CFINA71()

Private aPags 	:= {}
Private nParc	:= SE2->E2_PARC_AM
Private	dEmis	:= SE2->E2_EMIS1
Private _nValor	:= SE2->(E2_VALOR+E2_INSS+E2_IRRF+E2_ISS+E2_PIS)
Private	_aData	:= {}

If SE2->E2_TPAMORT == "S"

	//*************************************************
	//INICIO Contabiliza Amortizacao
	//*************************************************

	cMes		:= Val(Substr(DTOC(dEmis),4,2))
	cAno		:= Val(Substr(DTOC(dEmis),7,4))
	_cMesCont	:= cMes
	_cAnoCont	:= cAno
	// Data Ultimo dia Util
	_DtCont		:= DataValida(LastDay(ctod("01/"+Str(_cMesCont,2)+"/"+Str(_cAnoCont,4))),.F.)
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

	_nVal		:= Round(_nValor/nParc,2)
	_nValDif	:= (_nVal * _nCont) - _nValor

	_nAmorEfet	:= 0		//Ja Amortizado - EFETIVADO
	_nAmorSld	:= _nValor	//Valor Original - Ja Amortizado = Saldo Acumulado

	For _nIx :=1 to Len(_aData)

		/*
		FAZER UM SELECT NO CT2 PARA VERIFICAR SE O LANCAMENTO ESTA EFETIVADO.
		*/

		_cQuery := " SELECT CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_LINHA,CT2_TPSALD, CT2_KEY, CT2_XKEY "
		_cQuery += " FROM "+RetSqlName("CT2")+"  "
		_cQuery += " WHERE D_E_L_E_T_ = ''  "
		_cQuery += " AND CT2_LOTE = '009200'  "
		_cQuery += " AND CT2_DATA = '"+DTOS(_aData[_nIx])+"' "
		_cQuery += " AND CT2_XKEY = '"+xFilial("SE2")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA+"' "
		_cQuery += " ORDER BY CT2_DATA "
		_cQuery := ChangeQuery(_cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRB",.T.,.T.)
		TcSetField("TRB","CT2_DATA","D",8, 0 )

		Dbselectarea("TRB")
		TRB->(Dbgotop())

		If TRB->CT2_TPSALD == "1"
			_nAmorEfet	+= _nVal
			_nAmorSld	-= _nVal
		EndIf

		aAdd(aPags,{ _aData[_nIx], _nVal, _nAmorEfet, _nAmorSld })

		_nCont	:= _nCont - 1
		If _nCont == 1
			_nVal	:= _nVal - _nValDif
		EndIf

		Dbselectarea("TRB")
		TRB->(DbCloseArea())

	Next _nIx

	If Len(aPags) > 0
	
		DEFINE FONT oBold	NAME	"Arial"	SIZE 0, -12 BOLD
		DEFINE MSDIALOG oDlg TITLE "Acompanhamento AMORTIZACAO" FROM  0,0 TO 025,090 of oMainWnd STYLE DS_MODALFRAME
		@ 05,05 LISTBOX oLbx1 FIELDS HEADER "Dt.Amortizacao","Valor Amortizacao","Valor Amortizado","Saldo Amortizar" SIZE 350, 130 OF oDlg PIXEL
	
	
		oLbx1:SetArray(aPags)
		oLbx1:bLine := { || {aPags[oLbx1:nAt,1], Transform(aPags[oLbx1:nAt,2],"@EZ 999,999,999.99"), Transform(aPags[oLbx1:nAt,3],"@E 999,999,999.99"), Transform(aPags[oLbx1:nAt,4],"@E 999,999,999.99") } }

		@ 10.9 , 003 SAY "DOCUMENTO" OF oDlg FONT oBold COLOR CLR_BLUE
		@ 10.9 , 010 SAY "FORNECEDOR" OF oDlg FONT oBold COLOR CLR_BLUE
		@ 10.9 , 021 SAY "VALOR" OF oDlg  FONT oBold COLOR CLR_BLUE

		@ 11.9 , 003 SAY SE2->E2_NUM OF oDlg FONT oBold COLOR CLR_BLUE
		@ 11.9 , 010 SAY SE2->E2_NOMFOR OF oDlg FONT oBold COLOR CLR_BLUE
		@ 11.9 , 020 SAY Transform(_nValor,"@EZ 999,999,999.99") OF oDlg  FONT oBold COLOR CLR_BLUE

//		DEFINE SBUTTON FROM 145, 256 TYPE 6  ENABLE OF oDlg ACTION cFina71_IMP()
		DEFINE SBUTTON FROM 145, 288 TYPE 1  ENABLE OF oDlg ACTION (oDlg:End())
	
		ACTIVATE MSDIALOG oDlg CENTERED
	EndIf
Else
	MsgInfo(OemToAnsi("Não Há registro de Amortização para este Documento!!!"),OemToAnsi("Atenção"))
Endif
Return

Static Function cFina71_IMP()

Local _lRet	:= .T.

	alert("IMPRESSAO")

Return(_lRet)