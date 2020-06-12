#include "rwmake.ch"
#include "Topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CWKF005   � Autor � Emerson Natali     � Data �  26/03/2008 ���
�������������������������������������������������������������������������͹��
���Descricao � Geracao do WorkFlow para verificar Aplicacoes Vencidas     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

_cAssunto  	:= OemToAnsi("Aplica��es Vencendo em "+DTOC(dDataBase) )

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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CWKF002   �Autor  �Microsiga           � Data �  05/29/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Prepara e-mail para Aprovador A                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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