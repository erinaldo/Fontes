#INCLUDE "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F200VAR   ºAutor  ³Osmil Squarcine     º Data ³  08/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PONTO DE ENTRADA PARA TRATAR COBRANCA SEM REGISTRO         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ARK FOODS                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FINAJURO()

Local _nTamParc := TAMSX3( "E1_PARCELA" )[1]
Local _nTamBco  := TAMSX3( "E1_NUMBCO"  )[1]
Local aRecno    := SE1->( GetArea() )
Local cTabela 	:= "17"
Local cNTitAnt	:= cNumTit
Local _lAchou	:= .F.
//Private _aValores := ParamIxb[01]

/*cNumTit := Padl(cNumTit,TamSx3("E1_IDCNAB")[1],"0")	//Corrige o tamanho do campo recebido do arquivo  // Incluido em 14/03/13 do mesmo PE que estava duplicado no projeto

SE1->( DbSetOrder( 1 ) )
If SE1->( DbSeek( xFilial("SE1") + _aValores[1] + Space(_nTamParc-1) + _aValores[3] ) )
	_lAchou := .T.
	If SE1->E1_SALDO == 0
		nDespes := nDescont := nAbatim := nValRec := nJuros := nMulta := nOutrDesp := nValCc := 0
	EndIf
Else
	SE1->( dbSetOrder( 22 ) )
	If SE1->( DbSeek( xFilial("SE1") + _aValores[4] + Space(_nTamBco-Len(_aValores[4]) ) ) )
		cNumTit := SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA
		cTipo   := Tabela( cTabela, SE1->E1_TIPO, 1, 2 )
		_lAchou := .T.
	Else
		_lAchou := ProcSE1()
	EndIf
EndIf

If !_lAchou
	RestArea( aRecno )
	cNumTit := cNTitAnt
Else*/
	/* aValores
	* 6 = Desconto
	* 7 = Abatimento
	* 9 = Juros
	-------------*/ 
	// só altera os dados de valores para baixas de títulos não registrados
	IF "COB N REG"$ALLTRIM(SEE->EE_OPER)											// não é cobranca registrada
		nDescont 	:= SE1->(E1_ISS+E1_IRRF+E1_CSLL+E1_COFINS+E1_PIS)				// desconto
		nAbatim		:= SE1->E1_DECRESC												// abatimento
		nJuros 		:= SE1->E1_ACRESC												// juros
//		_aValores[6] := nDescont
//		_aValores[7] := nAbatim
//		_aValores[9] := nJuros
	EndIf
//EndIf

Return

Static Function ProcSE1()

Local _cNossoNum:= _aValores[4]
Local _lRet		:= .F.
Local _cQuery	:= ""
Local cAliasTop	:= ""
Local nRecSE1	:= 0
Local _cNumTit	:= ""

If mv_par06 == "237"
	_cNumTit := AllTrim(mv_par09)+ SubStr(_cNossoNum,3,12)
ElseIf mv_par06 == "033"
	_cNumTit := "000"+ SubStr(_cNumTit,4,11)
ElseIf mv_par06 == "341"
	_cNumTit := Repl("0",12-Len(_cNumTit))+_cNumTit
ElseIf mv_par06 == "399"
	_cNumTit := StrZero(Val(_cNossoNum),11)
End

_cQuery := "SELECT R_E_C_N_O_ E1REC "
_cQuery += "FROM "+RetSqlName("SE1")+" "
_cQuery += "WHERE D_E_L_E_T_='' "
_cQuery += "AND E1_NUMBCO = '"+_cNumTit+"' "
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery), cAliasTop := GetNextAlias(), .F., .T.)

If !(cAliasTop)->(Eof())
	nRecSE1 := (cAliasTop)->E1REC
	dbSelectArea("SE1")
	SE1->(dbGoTo(nRecSE1))
	If AllTrim(SE1->E1_NUMBCO)==_cNumTit
		_lRet := .T.
	EndIf
EndIf

(cAliasTop)->(dbCloseArea())
SE1->(dbSetOrder(1))
SE1->(dbGoTo(nRecSE1))

Return(_lRet)
