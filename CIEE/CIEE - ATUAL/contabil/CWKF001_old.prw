#INCLUDE "TbiConn.ch"
#INCLUDE "TbiCode.ch"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCWKF001   บ Autor ณ Kley Goncalves     บ Data ณ  14/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao para noticacao de Documentos via Work-Flow          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CWKF001(_aEmpresa)
Local _cQuery	 := ""
Local _cEmail	 := ""
Local _nQtdDias	 := 0
Local _cStatus   := ""
Local _nQtdDias  := 0
Local _cStrNivel := ""
Local _cTitulo   := ""
Local _cTexto    := ""
Local _cAssunto  := ""
Local _cDtAber   := ""
Local _cDtVcto   := ""
Local oHtml

&&_aEmpresa	:= {"01","01"}
Prepare Environment Empresa _aEmpresa[1] Filial _aEmpresa[2]

ChkFile("PA3")
ChkFile("PA4")
ChkFile("PA6")
ChkFile("PA1")

_cQuery	:= "SELECT PA4_FILIAL, PA4_COD, PA4_CODUNI, PA4_CODDOC, PA4_DTREG, PA4_DTVCTO, PA4_CTVCTO, PA4_DTABER"
_cQuery	+= " FROM " + RETSQLNAME('PA4') + " PA4"
_cQuery	+= " INNER JOIN " + RETSQLNAME('PA2') + " AS PA2"
_cQuery	+= " ON PA2_FILIAL = PA4_FILIAL"
_cQuery += " AND PA2_COD = PA4_CODUNI"
_cQuery	+= " AND PA2_STATUS = 'A'"
_cQuery	+= " AND PA2.D_E_L_E_T_ = ' '"
_cQuery	+= " INNER JOIN " + RETSQLNAME('PA1') + " AS PA1"
_cQuery	+= " ON PA1_FILIAL = PA4_FILIAL"
_cQuery	+= " AND PA1_COD = PA4_CODDOC"
_cQuery	+= " AND PA1_STATUS = 'A'"
_cQuery	+= " WHERE PA4_FILIAL = '" + xFilial("PA4") + "'"
_cQuery	+= " AND PA4_INDEFE = 'N'"
_cQuery	+= " AND PA4_ENCE = 'N'"
_cQuery	+= " AND PA4_CTVCTO = 'S'"
_cQuery	+= " AND PA4.D_E_L_E_T_ <> '*'"
_cQuery	+= " GROUP BY PA4_FILIAL, PA4_COD, PA4_CODUNI, PA4_CODDOC, PA4_DTREG, PA4_DTVCTO, PA4_CTVCTO, PA4_DTABER"
_cQuery	+= " ORDER BY PA4_FILIAL, PA4_COD, PA4_CODUNI, PA4_CODDOC, PA4_DTREG, PA4_DTVCTO, PA4_CTVCTO, PA4_DTABER"

If Select("TPA4") > 0
	DbSelectArea("TPA4")
	DbCloseArea()
Endif

TCQUERY _cQuery ALIAS "TPA4" NEW
DbSelectArea("TPA4")
DbGoTop()

While !TPA4->(Eof()) .And. !Empty(PA4_DTVCTO)
	_cStatus   := ""
	
	If Empty(PA4_DTREG) .And. StoD(PA4_DTVCTO) >= dDatabase
		_cStatus := "1"	//Aguardando
	ElseIf !Empty(PA4_DTREG) .And. StoD(PA4_DTVCTO) >= dDatabase
		_cStatus := "2"	//Vigente
	ElseIf StoD(PA4_DTVCTO) < dDatabase
		_cStatus := "3"	//Vencido
	EndIf
	
	_nQtdDias  := StoD(PA4_DTVCTO) - dDataBase
	_cStrNivel := ""
	_cAssunto  := ""
	
	DbSelectArea("PA6")
	DbSetOrder(2)
	If DbSeek(xFilial("PA6") + _cStatus + STR(Abs(_nQtdDias),3,0))
		_cStrNivel := PA6->PA6_NIV1 + "/" + PA6->PA6_NIV2 + "/" + PA6->PA6_NIV3 + "/" + PA6->PA6_NIV4 + "/" + PA6->PA6_NIV5
		_cAssunto  := PA6->PA6_ASSUN
	EndIf
	
	_cEmail    := ""
	_cTitulo   := ""
	_cTexto    := ""
	
	DbSelectArea("PA3")
	DbSetOrder(1)
	DbGoTop()
	While PA3->(!Eof()) .And. (xFilial("PA3")) == PA6->PA6_FILIAL
		If PA3->PA3_NIVEL $(_cStrNivel) .And. PA3_STATUS = "A"
			DbSelectArea("PA7")
			DbSetOrder(1)
			DbGoTop()
			If DbSeek(xFilial("PA7") + TPA4->PA4_CODUNI + PA3->PA3_MAT)
				_cEmail	+= PA3->PA3_EMAIL
			EndIf
		Endif
		DbSelectArea("PA3")
		DbSkip()
	EndDo
	
	_cDtAber   := ""
	_cDtVcto   := ""
	
	DbSelectArea("PA1")
	DbSetOrder(1)
	If DbSeek(xFilial("PA1") + TPA4->PA4_CODDOC)
		If PA1_STATUS = "A"
			_cDtAber := Substr(TPA4->PA4_DTABER,7,2) + "/" + Substr(TPA4->PA4_DTABER,5,2) + "/" + Substr(TPA4->PA4_DTABER,1,4)
			_cDtVcto := Substr(TPA4->PA4_DTVCTO,7,2) + "/" + Substr(TPA4->PA4_DTVCTO,5,2) + "/" + Substr(TPA4->PA4_DTVCTO,1,4)
			If PA1_TPDOC = "01"
				_cTitulo := PA1_TITUL1
				If     _cStatus == "1"
					_cTexto := StrTran(PA1_MSGAG1,"!data!", _cDtAber)
				ElseIf _cStatus == "2"
					_cTexto := StrTran(PA1_MSGVG1,"!data!", _cDtVcto)
				ElseIf _cStatus == "3"
					_cTexto := StrTran(PA1_MSGVC1,"!data!", _cDtVcto)
				EndIf
			ElseIf PA1_TPDOC = "02"
				_cTitulo := PA1_TITUL2
				If     _cStatus == "1"
					_cTexto := StrTran(PA1_MSGAG2,"!data!", _cDtAber)
				ElseIf _cStatus == "2"
					_cTexto := StrTran(PA1_MSGVG2,"!data!", _cDtVcto)
				ElseIf _cStatus == "3"
					_cTexto := StrTran(PA1_MSGVC2,"!data!", _cDtVcto)
				EndIf
			ElseIf PA1_TPDOC = "03"
				_cTitulo := PA1_TITUL3
				If     _cStatus == "1"
					_cTexto := StrTran(PA1_MSGAG3,"!data!", _cDtAber)
				ElseIf _cStatus == "2"
					_cTexto := StrTran(PA1_MSGVG3,"!data!", _cDtVcto)
				ElseIf _cStatus == "3"
					_cTexto := StrTran(PA1_MSGVC3,"!data!", _cDtVcto)
				EndIf
			ElseIf PA1_TPDOC = "04"
				_cTitulo := PA1_TITUL4
				If     _cStatus == "1"
					_cTexto := StrTran(PA1_MSGAG4,"!data!", _cDtAber)
				ElseIf _cStatus == "2"
					_cTexto := StrTran(PA1_MSGVG4,"!data!", _cDtVcto)
				ElseIf _cStatus == "3"
					_cTexto := StrTran(PA1_MSGVC4,"!data!", _cDtVcto)
				EndIf
			ElseIf PA1_TPDOC = "06"
				_cTitulo := PA1_TITUL6
				If     _cStatus == "1"
					_cTexto := StrTran(PA1_MSGAG6,"!data!", _cDtAber)
				ElseIf _cStatus == "2"
					_cTexto := StrTran(PA1_MSGVG6,"!data!", _cDtVcto)
				ElseIf _cStatus == "3"
					_cTexto := StrTran(PA1_MSGVC6,"!data!", _cDtVcto)
				EndIf
			EndIf
		EndIf
	EndIf
	
	If !Empty(_cEmail)
		_EnvMail(_cEmail, _cAssunto, _cTitulo, _cTexto)
&&		PA4->PA4_DTENVI := 	DtoS(dDatabase)
	EndIf
	
	DbSelectArea("TPA4")
	DbSkip()
End

Static Function _EnvMail(_cEmail, _cAssunto, _cTitulo, _cTexto)

oProcess:= TWFProcess():New("WF0001", "Workflow Documentos")
oProcess:NewVersion(.T.)
oProcess:NewTask( "Workflow Documentos", "\Workflow\CWKF001.Htm")
oProcess:bReturn	:= ""
oProcess:cSubject	:= _cAssunto
oProcess:cTo  		:= _cEmail
oHtml      			:= oProcess:oHTML

oHtml:ValByName("titulo"	, _cTitulo)
oHtml:ValByName("texto"		, _cTexto)

oProcess:Start()

Return(.T.)
