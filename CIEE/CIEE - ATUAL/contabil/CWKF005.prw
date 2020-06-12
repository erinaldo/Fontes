#include "rwmake.ch"
#include "Topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCWKF005   บ Autor ณ Emerson Natali     บ Data ณ  26/03/2008 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Geracao do WorkFlow para verificar Aplicacoes Vencidas     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CWKF005()
Local _cQuery	 := ""
Local _cEmail	 := ""
Local _cNumApl   := ""
Local _cAssunto  := ""

Private oProcess
Private oHtml

_lFirst		:= .T.
_nCont		:= 0  
_Cor		:= 0
_Cor1		:= "#B4BAC6"
_Cor2		:= "#9397A0"

wfPrepENV( "01", "01")

ChkFile("SZS") 

_cAssunto  	:= OemToAnsi("Aplica็๕es Vencendo em "+DTOC(dDataBase) )

_cQuery	:= "SELECT * "
_cQuery	+= "FROM " + RetSqlName("SZS")+" "
_cQuery += "WHERE D_E_L_E_T_ <> '*' "
_cQuery += "AND ZS_RESGAT = '"+DTOS(dDataBase)+"' "
_cQuery += "AND ZS_TPAPL = 'PRE' "
TCQUERY _cQuery ALIAS "TMPVCT" NEW

DbSelectArea("TMPVCT")
DbGotop()

Do While !TMPVCT->(EOF())

	_cEmail	 := GETMV("CI_WFAPRA")

	_nCont++
	
	If !Empty(_cEmail) .and. _lFirst
		_EnvMail(_cEmail, _cAssunto, _cNumApl)
		_lFirst		:= .F.
		oHtml  		:= oProcess:oHTML
	EndIf 

	If _Cor % 2 == 0
		_Cor3 := _Cor1
	Else
		_Cor3 := _Cor2
	EndIf
	
	_nVlAtu := Round(((((TMPVCT->ZS_TXPER/100)+1)^((dDataBase - Stod(TMPVCT->ZS_DTAPL))/TMPVCT->ZS_DIAS))*TMPVCT->ZS_VLAPL),2)
	
	Do Case
		Case ALLTRIM(TMPVCT->ZS_TPAPL) == "PRE"
			_cTpApl	:= "CDB PRE"
		Case ALLTRIM(TMPVCT->ZS_TPAPL) == "POS"
			_cTpApl	:= "CDB POS"
		Case ALLTRIM(TMPVCT->ZS_TPAPL) == "BRA"
			_cTpApl	:= "BRAM"
	EndCase

	AAdd( (oHtml:ValByName( "t.1"     )), ALLTRIM(TMPVCT->ZS_NOMBCO))
	AAdd( (oHtml:ValByName( "t.2"     )), _cTpApl)
	AAdd( (oHtml:ValByName( "t.3"     )), TRANSFORM(_nVlAtu,'@E 999,999,999.99'))
	AAdd( (oHtml:ValByName( "t.4"     )), DTOC(STOD(TMPVCT->ZS_RESGAT)))
	AAdd( (oHtml:ValByName( "t.5"     )), _Cor3 )

	_Cor++
	
	DbSelectArea("TMPVCT")
	DbSkip()
EndDo

If _nCont > 0
	oProcess:Start()
EndIf

DbSelectArea("TMPVCT")
DbCloseArea()

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCWKF002   บAutor  ณMicrosiga           บ Data ณ  05/29/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrepara e-mail para Aprovador A                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _EnvMail(_cEmail, _cAssunto, _cNumApl)

Private oHtml

oProcess:= TWFProcess():New("000001", "Workflow Reserva Financeira")
oProcess:NewVersion(.T.)
oProcess:NewTask( "Workflow Reserva Financeira", "\Workflow\WFVencApl.htm")
oProcess:bReturn	:= ""
oProcess:cSubject	:= _cAssunto
oProcess:cTo  		:= _cEmail

Return(.T.)