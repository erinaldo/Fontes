#include "rwmake.ch"
#include "protheus.ch"
#include "TOPCONN.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#DEFINE _EOL chr(13) + chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA56   บAutor  ณEmerson             บ Data ณ  04/03/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para Geracao de WorkFlow Cartao Empresa Itau        บฑฑ
ฑฑบ          ณ (Aviso, Bloqueio e Desbloqueio)                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CFINA56(_nPar)

Local cQuery	 := ""
Local _cEmail	 := ""
Local _cTitulo   := ""
Local _cTexto    := ""
Local _cAssunto  := ""
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

If _nPar == "1" //Desbloqueio
	u_CFINA56b()
	Return
EndIf

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
			_cAssunto  	:= "Cartใo Empresa Ita๚ - Fundo Fixo de Caixa"
			_nPercVlr	:= (SZK->ZK_E_SLDPR / SZK->ZK_E_LIMIT) * 100
			_cEmail		:= Alltrim(SZK->ZK_E_EMAIL) + ";" + Alltrim(SZK->ZK_E_SUP)
			_cCC		:= Alltrim(SZK->ZK_E_CC1) + ";" + Alltrim(SZK->ZK_E_CC2) + ";" + Alltrim(SZK->ZK_E_CC3) + ";" + 'cristiano@cieesp.org.br'
		EndIf 
	Else
		DbSelectArea("SZKTMP")
		SZKTMP->(DbSkip())
		Loop
	EndIf
 
	_nCont++	
 
	If !Empty (_cEmail) .and. _lFirst
		_EnvMail(_cEmail,_cCC,_cAssunto, _nPercVlr) //Chama funcao para disparar o e-mail
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
	AAdd( (oHtml:ValByName( "t.5"    )), TRANSFORM(_nPercVlr,'@E 99.99' ))
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

u_CFINA56a()   // Chama funcao para geracao workflow bloqueio cartao empresa itau

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_EnvMail  บAutor  ณEmerson             บ Data ณ  11/03/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao carrega workflow aviso bloqueio cartao empresa itau บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _EnvMail (_cEmail,_cCC,_cAssunto, _nPercVlr) //(_cEmail, _cAssunto, _cTitulo, _cTexto, _cCC)

Private oHtml

oProcess:= TWFProcess():New("000001", "Workflow Aviso Bloqueio Cartao")
oProcess:NewVersion(.T.)
oProcess:NewTask( "Workflow Aviso Bloqueio Cartao", "\Workflow\WFAvisoBloqFFC.htm")
oProcess:bReturn	:= ""
oProcess:cSubject	:= _cAssunto
oProcess:cTo  		:= _cEmail
oProcess:cCC  		:= _cCC

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA56a  บAutor  ณEmerson             บ Data ณ  12/03/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina Geracao WorkFlow Bloqueio Cartao Empresa Itau       บฑฑ
ฑฑบ          ณ BLOQUEIO                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CFINA56a()

_aBlq	:= {}

cQuery := "SELECT * "
cQuery += "FROM "+RetSQLname('SZK')+" "
cQuery += "WHERE D_E_L_E_T_ = '' "
cQuery += "AND ZK_TIPO = '4' "
cQuery += "AND ZK_E_DTENV <> '' "
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
	_dDtAvis	:= SZKTMP->ZK_E_DTENV
	_cDtBloq	:= DDATABASE - _cDias
	
	If SZKTMP->ZK_E_SLDPR >= _nValor
		If SZKTMP->ZK_E_DTENV == _cDtBloq
			DbSelectArea("SZK")
			DbSetOrder(4) //Numero do Cartao
			If DbSeek(xFilial("SZK")+SZKTMP->ZK_NROCRT,.F.)
				RecLock("SZK",.F.)
				SZK->ZK_E_DTBLQ := DDATABASE
				MsUnLock()
				_cAssunto  	:= "Cartใo Empresa Ita๚ - Fundo Fixo de Caixa"
				_nPercVlr	:= (SZK->ZK_E_SLDPR / SZK->ZK_E_LIMIT) * 100
				_cEmail		:= Alltrim(SZK->ZK_E_EMAIL) + ";" + Alltrim(SZK->ZK_E_SUP)
				_cCC		:= Alltrim(SZK->ZK_E_CC1) + ";" + Alltrim(SZK->ZK_E_CC2) + ";" + Alltrim(SZK->ZK_E_CC3) + ";" + 'cristiano@cieesp.org.br'
			EndIf
		Else
			// Se nao atingiu a data limite 10 dias mais
			// o valor a Prestar Contas for Igual ao Limite
			If  SZKTMP->ZK_E_SLDPR >= SZKTMP->ZK_E_LIMIT
				DbSelectArea("SZK")
				DbSetOrder(4) //Numero do Cartao
				If DbSeek(xFilial("SZK")+SZKTMP->ZK_NROCRT,.F.)
					RecLock("SZK",.F.)
					SZK->ZK_E_DTBLQ := DDATABASE
					MsUnLock()
					_cAssunto  	:= "Cartใo Empresa Ita๚ - Fundo Fixo de Caixa"
					_nPercVlr	:= (SZK->ZK_E_SLDPR / SZK->ZK_E_LIMIT) * 100
					_cEmail		:= Alltrim(SZK->ZK_E_EMAIL) + ";" + Alltrim(SZK->ZK_E_SUP)
					_cCC		:= Alltrim(SZK->ZK_E_CC1) + ";" + Alltrim(SZK->ZK_E_CC2) + ";" + Alltrim(SZK->ZK_E_CC3) + ";" + 'cristiano@cieesp.org.br'
				EndIf
			Else
				DbSelectArea("SZKTMP")
				SZKTMP->(DbSkip())
				Loop
			EndIf
		EndIf
	Else
		DbSelectArea("SZKTMP")
		SZKTMP->(DbSkip())
		Loop
	EndIf
 
	_nCont++	
 
	If !Empty (_cEmail) .and. _lFirst
		_EnvMaila(_cEmail,_cCC,_cAssunto, _nPercVlr) //Chama funcao para disparar o e-mail
		_lFirst	:= .F.
		oHtml	:= oProcess:oHTML
		oHtml:ValByName("dtaviso", _dDtAvis)
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
	AAdd( (oHtml:ValByName( "t.5"    )), TRANSFORM(_nPercVlr,'@E 99.99' ))
	AAdd( (oHtml:ValByName( "t.6"    )), _Cor3 )

	_Cor++		
	
	If _nCont > 0
		oProcess:Start()
		AADD(_aBlq,{SZK->ZK_NROCRT,SZK->ZK_E_LIMIT})
	EndIf
	
	DbSelectArea("SZKTMP")
	SZKTMP->(DbSkip())

EndDo                 

DbSelectArea("SZKTMP")
DbCloseArea()

If Len(_aBlq) > 0

	_fGerArq(_aBlq, "1", "1" )

EndIf

u_CFINA56b()

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_EnvMaila บAutor  ณEmerson             บ Data ณ  12/03/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao carrega workflow bloqueio cartao empresa itau       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _EnvMaila (_cEmail,_cCC,_cAssunto, _nPercVlr) //(_cEmail, _cAssunto, _cTitulo, _cTexto, _cCC)

Private oHtml

oProcess:= TWFProcess():New("000001", "Workflow Aviso Bloqueio Cartao")
oProcess:NewVersion(.T.)
oProcess:NewTask( "Workflow Aviso Bloqueio Cartao", "\Workflow\WFBloqFFC.htm")
oProcess:bReturn	:= ""
oProcess:cSubject	:= _cAssunto
oProcess:cTo  		:= _cEmail
oProcess:cCC  		:= _cCC

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA56b  บAutor  ณEmerson             บ Data ณ  12/03/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina Geracao WorkFlow Desbloqueio Cartao Empresa Itau    บฑฑ
ฑฑบ          ณ DESBLOQUEIO                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CFINA56b()

Private _nCtaImp	:= GetMV("CI_CTAFFC")
_aDesBlq	:= {}

cQuery := "SELECT * "
cQuery += "FROM "+RetSQLname('SZK')+" "
cQuery += "WHERE D_E_L_E_T_ = '' "
cQuery += "AND ZK_TIPO = '4' "
cQuery += "AND ZK_E_DTENV <> '' "
cQuery += "AND ZK_E_DTBLQ <> '' "
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
	_cCartao	:= SZKTMP->ZK_NROCRT
	
	If SZKTMP->ZK_E_SLDPR < _nValor
		DbSelectArea("SZK")
		DbSetOrder(4) //Numero do Cartao
		If DbSeek(xFilial("SZK")+SZKTMP->ZK_NROCRT,.F.)
//			cQuery := "SELECT SUM(ZY_VALOR) VALOR "
			cQuery := "SELECT ZY_ITEM, ZY_VALOR "
			cQuery += "FROM "+RetSQLname('SZY')+" "
			cQuery += "WHERE D_E_L_E_T_ = '' "
			cQuery += "AND ZY_DTVLD = '"+DTOS(dDatabase)+"'"
			cQuery += "AND ZY_CARTAO = '"+_cCartao+"' "
			cQuery += "AND ZY_CONTA <> '' "
			TcQuery cQuery New Alias "SZYTMP"

			TcSetField("SZYTMP","ZY_DATA","D",8, 0 )

			DbSelectArea("SZYTMP")
/*			
			If !Empty(SZYTMP->VALOR)			
				_nVlrPc	:= SZYTMP->VALOR
			Else
				_nVlrPc	:= 0
			EndIf
*/			

			DbGotop()
			_nVlrPc := 0
			Do While !EOF()
				If ALLTRIM(SZYTMP->ZY_ITEM) $ _nCtaImp                                                                    
					DbSelectArea("SZYTMP")
					SZYTMP->(DbSkip())
					Loop				
				EndIf
				_nVlrPc	+= SZYTMP->ZY_VALOR
				DbSelectArea("SZYTMP")
				SZYTMP->(DbSkip())
			EndDo
			
			RecLock("SZK",.F.)
			SZK->ZK_E_DTENV := CtoD(" / / ")
			SZK->ZK_E_DTBLQ := CtoD(" / / ")
//Alterado dia 18/05/09 - analista Emerson Natali
//A Atualizacao do Saldo passou para o relatorio de Retorno.
//			SZK->ZK_E_SLDAT := SZK->ZK_E_LIMIT
			MsUnLock()
			_cAssunto  	:= "Cartใo Empresa Ita๚ - Fundo Fixo de Caixa"
			_nPercVlr	:= (SZK->ZK_E_SLDPR / SZK->ZK_E_LIMIT) * 100
			_cEmail		:= Alltrim(SZK->ZK_E_EMAIL) + ";" + Alltrim(SZK->ZK_E_SUP)
			_cCC		:= Alltrim(SZK->ZK_E_CC1) + ";" + Alltrim(SZK->ZK_E_CC2) + ";" + Alltrim(SZK->ZK_E_CC3) + ";" + 'cristiano@cieesp.org.br'
		EndIf
		
		DbSelectArea("SZYTMP")
		DbCloseArea()
	Else
		DbSelectArea("SZKTMP")
		SZKTMP->(DbSkip())
		Loop
	EndIf
 
	_nCont++	
 
	If !Empty (_cEmail) .and. _lFirst
		_EnvMailb(_cEmail,_cCC,_cAssunto, _nPercVlr) //Chama funcao para disparar o e-mail
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
	AAdd( (oHtml:ValByName( "t.4"    )), TRANSFORM(_nVlrPc,'@E 99,999.99' ))
	AAdd( (oHtml:ValByName( "t.5"    )), TRANSFORM(_nPercVlr,'@E 99.99' ))
	AAdd( (oHtml:ValByName( "t.6"    )), _Cor3 )

	_Cor++		
	
	If _nCont > 0
		oProcess:Start()
		AADD(_aDesBlq,{SZK->ZK_NROCRT,SZK->ZK_E_LIMIT})
	EndIf
	
	DbSelectArea("SZKTMP")
	SZKTMP->(DbSkip())

EndDo                 

DbSelectArea("SZKTMP")
DbCloseArea()

If Len(_aDesBlq) > 0

	_fGerArq(_aDesBlq, "2", "1" ) 

EndIf

u_CFINA56c()   // Chama funcao para geracao workflow disponibiliza saldo cartao empresa itau

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_EnvMailb บAutor  ณEmerson             บ Data ณ  12/03/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao carrega workflow desbloqueio cartao empresa itau    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _EnvMailb (_cEmail,_cCC,_cAssunto, _nPercVlr) //(_cEmail, _cAssunto, _cTitulo, _cTexto, _cCC)

Private oHtml

oProcess:= TWFProcess():New("000001", "Workflow Aviso Bloqueio Cartao")
oProcess:NewVersion(.T.)
oProcess:NewTask( "Workflow Aviso Bloqueio Cartao", "\Workflow\WFDesbloFFC.htm")
oProcess:bReturn	:= ""
oProcess:cSubject	:= _cAssunto
oProcess:cTo  		:= _cEmail
oProcess:cCC  		:= _cCC

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA56c  บAutor  ณEmerson             บ Data ณ  12/03/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina Geracao WorkFlow Desbloqueio Cartao Empresa Itau    บฑฑ
ฑฑบ          ณ DESBLOQUEIO - Cartaoes que nao atingiram as regras acima   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CFINA56c()

Private _nCtaImp	:= GetMV("CI_CTAFFC")
Private _nPercDisp 	:= GetMV("CI_PERDISP") /100

_aDesBlq	:= {}

cQuery := "SELECT * "
cQuery += "FROM "+RetSQLname('SZK')+" "
cQuery += "WHERE D_E_L_E_T_ = '' "
cQuery += "AND ZK_TIPO = '4' "
cQuery += "AND (ZK_E_DTENV = '' OR ZK_E_DTENV < '"+DTOS(DDATABASE)+"') "
cQuery += "AND ZK_E_DTBLQ = '' "
cQuery += "AND ZK_STATUS = 'A' "
TcQuery cQuery New Alias "SZKTMP"

TcSetField("SZKTMP","ZK_E_DTENV","D",8, 0 )
TcSetField("SZKTMP","ZK_E_DTBLQ","D",8, 0 )

DbSelectArea("SZKTMP")
Do While !EOF()

	//Calculando o Percentual em funcao do parametro para bloqueio
	//Em caso que nao ocorre os bloqueios acima calculamos o percentual para recomposicao do limite
	_nValor		:= SZKTMP->ZK_E_LIMIT * _nPercDisp
	_nCont		:= 0
	_lFirst		:= .T.
	_Cor		:= 0
	_cCartao	:= SZKTMP->ZK_NROCRT
	
	If SZKTMP->ZK_E_SLDAT < _nValor //Saldo Disponivel Saque
		If SZKTMP->ZK_E_SLDPR < (SZKTMP->ZK_E_LIMIT * _nPerc)
			DbSelectArea("SZK")
			DbSetOrder(4) //Numero do Cartao
			If DbSeek(xFilial("SZK")+SZKTMP->ZK_NROCRT,.F.)
				RecLock("SZK",.F.)
				SZK->ZK_E_DTENV := CtoD(" / / ")
//Alterado dia 18/05/09 - analista Emerson Natali
//A Atualizacao do Saldo passou para o relatorio de Retorno.
//				SZK->ZK_E_SLDAT := SZK->ZK_E_LIMIT
				MsUnLock()
				_cAssunto  	:= "Cartใo Empresa Ita๚ - Fundo Fixo de Caixa"
				_cEmail		:= Alltrim(SZK->ZK_E_EMAIL) + ";" + Alltrim(SZK->ZK_E_SUP)
				_cCC		:= Alltrim(SZK->ZK_E_CC1) + ";" + Alltrim(SZK->ZK_E_CC2) + ";" + Alltrim(SZK->ZK_E_CC3) + ";" + 'cristiano@cieesp.org.br'
			EndIf
		Else
			DbSelectArea("SZKTMP")
			SZKTMP->(DbSkip())
			Loop
		EndIf
	Else
		DbSelectArea("SZKTMP")
		SZKTMP->(DbSkip())
		Loop
	EndIf
 
	_nCont++	
 
	If !Empty (_cEmail) .and. _lFirst
		_EnvMailc(_cEmail,_cCC,_cAssunto) //Chama funcao para disparar o e-mail
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
	AAdd( (oHtml:ValByName( "t.6"    )), _Cor3 )

	_Cor++		
	
	If _nCont > 0
		oProcess:Start()
		AADD(_aDesBlq,{SZK->ZK_NROCRT,SZK->ZK_E_LIMIT})
	EndIf
	
	DbSelectArea("SZKTMP")
	SZKTMP->(DbSkip())

EndDo                 

DbSelectArea("SZKTMP")
DbCloseArea()

If Len(_aDesBlq) > 0

	_fGerArq(_aDesBlq, "2", "2" ) 

EndIf

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_EnvMailc บAutor  ณEmerson             บ Data ณ  12/03/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao carrega workflow desbloqueio cartao empresa itau    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _EnvMailc (_cEmail,_cCC,_cAssunto)

Private oHtml

oProcess:= TWFProcess():New("000001", "Workflow Aviso Bloqueio Cartao")
oProcess:NewVersion(.T.)
oProcess:NewTask( "Workflow Aviso Bloqueio Cartao", "\Workflow\WFRecompFFC.htm")
oProcess:bReturn	:= ""
oProcess:cSubject	:= _cAssunto
oProcess:cTo  		:= _cEmail
oProcess:cCC  		:= _cCC

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGerArq   บAutor  ณEmerson             บ Data ณ  23/03/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envio arquivo Bloqueio e Desbloqueio do Cartao             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _fGerArq(_aArq, _nBlqDes, _nRecomp)

	_nQtdReg	:= 0
	If _nBlqDes == "1"
		_cArq := "\arq_txt\tesouraria\Importacao\SP\Itau\remessa\BLQ"+DTOS(DDATABASE)+".REM"
	Else
		If _nRecomp == "1" //Desbloqueio
			_cArq := "\arq_txt\tesouraria\Importacao\SP\Itau\remessa\DESBLQ"+DTOS(DDATABASE)+".REM"
		Else
			_cArq := "\arq_txt\tesouraria\Importacao\SP\Itau\remessa\RECOMP"+DTOS(DDATABASE)+".REM"
		EndIF
	EndIf
	If (_nArq := fCreate(_cArq)) == -1
		_cMsg := "Nใo foi possํvel criar o Arquivo de Remessa " + _cArq + "."
		MsgAlert(_cMsg, "Aten็ใo!")
		Return
	EndIf

	_cBufNor := ""
	//HEADER
	_cBufNor := DTOS(DDATABASE) 											//Data Geracao Arquivo 	001 - 008(08)
	_cBufNor += "0"															//Consistencia Data 	009 - 009(01) (somente arquivo Retorno)
	_cBufNor += SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2)+SUBSTR(TIME(),7,2)	//Hora Geracao Arquivo	010 - 015(06)
	_cBufNor += "0"															//Consistencia Hora 	016 - 016(01) (somente arquivo Retorno)
	_cBufNor += "00"														//Tipo de Registro		017 - 018(02)
	_cBufNor += "0"															//Consistencia Tipo 	019 - 019(01) (somente arquivo Retorno)
	_cBufNor += "1"															//Arquivo/Codigo		020 - 020(01)
	_cBufNor += "0"															//Consistencia Codigo	021 - 021(01) (somente arquivo Retorno)
	_cBufNor += "341"														//Codigo do Banco		022 - 024(03)
	_cBufNor += "0"															//Consistencia Banco 	025 - 025(01) (somente arquivo Retorno)
	_cBufNor += "0350"														//Numero da Agencia		026 - 029(04)
	_cBufNor += "74043"														//Numero da Conta		030 - 034(05)
	_cBufNor += "7"															//DAC					035 - 035(01)
	_cBufNor += "0"															//Consistencia Cliente	036 - 036(01) (somente arquivo Retorno)
	_cBufNor += "61600839000155"											//CNPJ Cliente 			037 - 050(14)
	_cBufNor += "0"															//Consistencia CNPJ 	051 - 051(01) (somente arquivo Retorno)
	_cBufNor += Space(178)													//Brancos				052 - 229(178)
	_cBufNor += "0350740437"												//Controle (AG-CC-DAC)	230 - 239(10)
	_cBufNor += Space(1)													//Brancos				240 - 240(01)
	fWrite(_nArq, _cBufNor + _EOL , 242)

	For _nI := 1 To Len(_aArq)
		_cBufNor := ""
		//DETALHE
		_cBufNor := DTOS(DDATABASE) 											//Data Geracao Arquivo 	001 - 008(08)
		_cBufNor += "0"															//Consistencia Data 	009 - 009(01) (somente arquivo Retorno)
		_cBufNor += SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2)+SUBSTR(TIME(),7,2)	//Hora Geracao Arquivo	010 - 015(06)
		_cBufNor += "0"															//Consistencia Hora 	016 - 016(01) (somente arquivo Retorno)
		_cBufNor += "04"														//Tipo de Registro		017 - 018(02)
		_cBufNor += "0"															//Consistencia Tipo 	019 - 019(01) (somente arquivo Retorno)
		_cBufNor += "1"															//Arquivo/Codigo		020 - 020(01)
		_cBufNor += "0"															//Consistencia Codigo	021 - 021(01) (somente arquivo Retorno)
		_cBufNor += "341"														//Codigo do Banco		022 - 024(03)
		_cBufNor += "0"															//Consistencia Banco 	025 - 025(01) (somente arquivo Retorno)
		_cBufNor += "0350"														//Numero da Agencia		026 - 029(04)
		_cBufNor += "74043"														//Numero da Conta		030 - 034(05)
		_cBufNor += "7"															//DAC					035 - 035(01)
		_cBufNor += "0"															//Consistencia Cliente	036 - 036(01) (somente arquivo Retorno)
		_cBufNor += "61600839000155"											//CNPJ Cliente 			037 - 050(14)
		_cBufNor += "0"															//Consistencia CNPJ 	051 - 051(01) (somente arquivo Retorno)
		_cBufNor += Substr(_aArq[_nI, 1],1,6)									//Nr Portador(Cartao)	052 - 057(06)
		_cBufNor += "0"															//Consistencia Numero	058 - 058(01) (somente arquivo Retorno)
		_cBufNor += iif(_nBlqDes == "1",Strzero(0,10),Strzero(_aArq[_nI, 2]*100,10))	//Limite no Periodo		059 - 068(08,02)
		_cBufNor += "0"															//Consistencia Periodo	069 - 069(01) (somente arquivo Retorno)
		_cBufNor += iif(_nBlqDes == "1",Strzero(0,10),Strzero(_aArq[_nI, 2]*100,10))	//Limite no Periodo		070 - 079(08,02)
		_cBufNor += "0"															//Consistencia Dia		080 - 080(01) (somente arquivo Retorno)
		_cBufNor += iif(_nBlqDes == "1", "X", Space(01))						//Zera Saques			081 - 081(01) //1 - Bloqueio/ 2 - Desblq
		_cBufNor += "0"															//Consistencia Zera Saq	082 - 082(01) (somente arquivo Retorno)
		_cBufNor += "I"															//Period. Indeterminado	083 - 083(01)
		_cBufNor += "0"															//Consistencia Restabel	084 - 084(01) (somente arquivo Retorno)
		_cBufNor += "0"															//Consistencia Registro	085 - 085(01) (somente arquivo Retorno)
		_cBufNor += Space(144)													//Complemento Registro	086 - 229(144)
		_cBufNor += "0350740437"												//Controle (AG-CC-DAC)	230 - 239(10)
		_cBufNor += Space(1)													//Brancos				240 - 240(01)
		fWrite(_nArq, _cBufNor + _EOL , 242)
		_nQtdReg++
	Next

	_cBufNor := ""
	//TRAILER
	_cBufNor := DTOS(DDATABASE) 											//Data Geracao Arquivo 	001 - 008(08)
	_cBufNor += "0"															//Consistencia Data 	009 - 009(01) (somente arquivo Retorno)
	_cBufNor += SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2)+SUBSTR(TIME(),7,2)	//Hora Geracao Arquivo	010 - 015(06)
	_cBufNor += "0"															//Consistencia Hora 	016 - 016(01) (somente arquivo Retorno)
	_cBufNor += "99"														//Tipo de Registro		017 - 018(02)
	_cBufNor += "0"															//Consistencia Tipo 	019 - 019(01) (somente arquivo Retorno)
	_cBufNor += "1"															//Arquivo/Codigo		020 - 020(01)
	_cBufNor += "0"															//Consistencia Codigo	021 - 021(01) (somente arquivo Retorno)
	_cBufNor += "341"														//Codigo do Banco		022 - 024(03)
	_cBufNor += "0"															//Consistencia Banco 	025 - 025(01) (somente arquivo Retorno)
	_cBufNor += "0350"														//Numero da Agencia		026 - 029(04)
	_cBufNor += "74043"														//Numero da Conta		030 - 034(05)
	_cBufNor += "7"															//DAC					035 - 035(01)
	_cBufNor += "0"															//Consistencia Cliente	036 - 036(01) (somente arquivo Retorno)
	_cBufNor += "61600839000155"											//CNPJ Cliente 			037 - 050(14)
	_cBufNor += "0"															//Consistencia CNPJ 	051 - 051(01) (somente arquivo Retorno)
	_cBufNor += Strzero(_nQtdReg+2,6)										//Quantidade			052 - 057(06)
	_cBufNor += "0"															//Consistencia Registro	058 - 058(01) (somente arquivo Retorno)
	_cBufNor += Space(171)													//Complemento Registro	059 - 229(144)
	_cBufNor += "0350740437"												//Controle (AG-CC-DAC)	230 - 239(10)
	_cBufNor += Space(1)													//Brancos				240 - 240(01)
	fWrite(_nArq, _cBufNor + _EOL , 242)

	fClose(_nArq)

Return()
