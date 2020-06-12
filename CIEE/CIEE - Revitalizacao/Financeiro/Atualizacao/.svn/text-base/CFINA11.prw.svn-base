#include "rwmake.ch"
#include "protheus.ch"
#include "TOPCONN.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#DEFINE _EOL chr(13) + chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINA11   ºAutor  ³Emerson             º Data ³  04/03/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para Geracao de WorkFlow Cartao Empresa Itau        º±±
±±º          ³ (Aviso)                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CFINA11()

Local cQuery	 := ""
Local _cEmail	 := ""
Local _cTitulo   := ""
Local _cTexto    := ""
Local oHtml

Private oProcess
Private oHtml

_cTexto 	:= ""
_cEOL     	:= CHR(13) + CHR(10)
_lFirst		:= .T.
_nCont		:= 0
_Cor		:= 0
_Cor1		:= "#B4BAC6"
_Cor2		:= "#9397A0"

wfPrepENV( "01", "01")

ChkFile("SZK")

_nPerc  := GetMV("CI_PERC") /100
_cDias  := GetMV("CI_DIAS")

cQuery := "SELECT * "
cQuery += "FROM "+RetSQLname('SZK')+" "
cQuery += "WHERE D_E_L_E_T_ = '' "
cQuery += "AND ZK_TIPO = '4' "
cQuery += "AND ZK_E_DTENV = '' "
cQuery += "AND ZK_E_DTBLQ = '' "
cQuery += "AND ZK_STATUS = 'A' "
TcQuery cQuery New Alias "SZKTMP"

TcSetField("SZKTMP","ZK_E_DTENV","D",8, 0 )
TcSetField("SZKTMP","ZK_E_DTBLQ","D",8, 0 )

DbSelectArea("SZKTMP")
Do While !EOF()

	_nValor		:= SZKTMP->ZK_E_LIMIT * _nPerc
	_nPercVlr	:= 0
	_nCont		:= 0
	_lFirst		:= .T.
	_Cor		:= 0
	
	If SZKTMP->ZK_E_SLDPR >= _nValor
		DbSelectArea("SZK")
		DbSetOrder(4) //Numero do Cartao
		If DbSeek(xFilial("SZK")+SZKTMP->ZK_NROCRT,.F.)
			RecLock("SZK",.F.)
			SZK->ZK_E_DTENV := DDATABASE
			MsUnLock()
			_nPercVlr	:= (SZK->ZK_E_SLDPR / SZK->ZK_E_LIMIT) * 100
			_cEmail		:= Alltrim(SZK->ZK_E_EMAIL) + ";" + Alltrim(SZK->ZK_E_SUP)
			_cCC		:= Alltrim(SZK->ZK_E_CC2) + ";" + Alltrim(SZK->ZK_E_CC3) + ";" + 'cristiano@cieesp.org.br'
		EndIf 
	Else
		DbSelectArea("SZKTMP")
		SZKTMP->(DbSkip())
		Loop
	EndIf
 
	_nCont++	
 
	If !Empty (_cEmail) .and. _lFirst
		oProcess:= TWFProcess():New("000001", "Workflow Aviso Bloqueio Cartao")
		oProcess:NewVersion(.T.)
		oProcess:NewTask( "Workflow Aviso Bloqueio Cartao", "\Workflow\WFAvisoBloqFFC.htm")
		oProcess:bReturn	:= ""
		oProcess:cSubject	:= "Prestacao de Contas de Fundo Fixo de Caixa"	//Assunto
		oProcess:cTo  		:= _cEmail
		oProcess:cCC  		:= _cCC
		_lFirst	:= .F.
		oHtml	:= oProcess:oHTML
	Else
		DbSelectArea("SZKTMP")
		SZKTMP->(DbSkip())
		Loop
	EndIf
	
	If _Cor % 2 == 0
		_Cor3 := _Cor1
	Else
		_Cor3 := _Cor2
	EndIf
	
	AAdd( (oHtml:ValByName( "t.1"    )), ALLTRIM(SZK->ZK_NOME))
	AAdd( (oHtml:ValByName( "t.2"    )), ALLTRIM(SZK->ZK_NROCRT))
	AAdd( (oHtml:ValByName( "t.3"    )), TRANSFORM(SZK->ZK_E_LIMIT,'@E 99,999.99' ))
	AAdd( (oHtml:ValByName( "t.4"    )), TRANSFORM(SZK->ZK_E_SLDPR,'@E 99,999.99' ))
	AAdd( (oHtml:ValByName( "t.5"    )), TRANSFORM(_nPercVlr,'@E 999.99' ))
	AAdd( (oHtml:ValByName( "t.6"    )), _Cor3 )

	_Cor++		
	
	If _nCont > 0
		oProcess:Start()
	EndIf
	
	DbSelectArea("SZKTMP")
	SZKTMP->(DbSkip())

EndDo                 

DbSelectArea("SZKTMP")
DbCloseArea()

Return()