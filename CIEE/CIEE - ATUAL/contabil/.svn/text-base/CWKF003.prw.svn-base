#include "rwmake.ch"
#include "Topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCWKF003   บ Autor ณ Emerson Natali     บ Data ณ  11/09/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao para noticacao de Requisicao de Materiais do Estoqueบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CWKF003()
Local _cQuery	 := ""
Local _cEmail	 := ""
Local _cReqNum   := ""
Local _cAssunto  := ""
Local oHtml

Private oProcess
Private oHtml
Private _cCR	 := ""

wfPrepENV( "01", "01")

ChkFile("SZN") 

_cQuery	:= "SELECT ZN_NUMSOC "
_cQuery	+= "FROM " + RetSqlName("SZN")+" "
_cQuery += "WHERE D_E_L_E_T_ <> '*' "
_cQuery += "AND ZN_WFFLAG = '' "
_cQuery += "AND ZN_DTWKF  = '"+dtos(dDataBase)+"' "
_cQuery += "GROUP BY ZN_NUMSOC "
_cQuery += "ORDER BY ZN_NUMSOC "
TCQUERY _cQuery ALIAS "TMPREQ" NEW

DbSelectArea("TMPREQ")
DbGotop()

Do While !EOF()

	_cReqNum := TMPREQ->ZN_NUMSOC // Numero da Requisicao
	
	_cQuery	:= "SELECT * "
	_cQuery	+= "FROM " + RetSqlName("SZN")+" "
	_cQuery += "WHERE D_E_L_E_T_ <> '*' "
	_cQuery += "AND ZN_NUMSOC = '"+_cReqNum+"' "
	_cQuery += "AND ZN_WFFLAG = '' "
	_cQuery += "AND ZN_DTWKF  = '"+dtos(dDataBase)+"' "
	_cQuery += "ORDER BY ZN_COD "
	TCQUERY _cQuery ALIAS "TMP" NEW    
	
	_cEmail	 := ALLTRIM(TMP->ZN_EMAIL)
	_cCC   	 := ALLTRIM(TMP->ZN_EMAIL2)
	_cCR   	 := ALLTRIM(TMP->ZN_CR)
	
	_fEnvia(_cEmail,_cCC,_cReqNum) //Chama funcao para disparar o e-mail

	_cQuery	:= "UPDATE "+ RetSqlName("SZN")+" SET ZN_WFFLAG = '1'"
	_cQuery += "WHERE D_E_L_E_T_ <> '*' AND ZN_NUMSOC = '"+_cReqNum+"' "
	_cQuery += "AND (ZN_STATUS = '1' OR ZN_STATUS = '3') "
	_cQuery += "AND	ZN_WFFLAG = '' "
	TcSQLExec(_cQuery)

	DbSelectArea("TMPREQ")
	TMPREQ->(dbSkip())
EndDo

DbSelectArea("TMPREQ")
DbCloseArea()
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCWKF002   บAutor  ณMicrosiga           บ Data ณ  08/14/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _fEnvia(_cEmail,_cCC,_cReqNum)

DbSelectArea("TMP")
DbGoTop()

_cAssunto  	:= OemToAnsi("Requisi็ใo de Materiais - C๓digo: "+_cReqNum )
_cEOL     	:= CHR(13) + CHR(10)
_lFirst		:= .T.
_nCont		:= 0  
_Cor		:= 0
_Cor1		:= "#B4BAC6"
_Cor2		:= "#9397A0"

While !TMP->(Eof())

	_nCont++
	
	If !Empty(_cEmail) .and. _lFirst
		_EnvMail(_cEmail, _cAssunto, _cCC)
		_lFirst		:= .F.
		oHtml  		:= oProcess:oHTML
		oHtml:ValByName("reqnum"		, _cReqNum)
		oHtml:ValByName("email"	 		, '<a href=mailto:almoxarifado@cieesp.org.br>almoxarifado@cieesp.org.br</a>')
		oHtml:ValByName("emailreq"		, _cEmail)
		oHtml:ValByName("cr"			, _cCR)
	EndIf 
	
	If _Cor % 2 == 0
		_Cor3 := _Cor1
	Else
		_Cor3 := _Cor2
	EndIf
	
	AAdd( (oHtml:ValByName( "t.1"    )), 'bgcolor="'+_Cor3+'" width="05%" class="TableRowWhiteMini2" align="left" height="14">'+ALLTRIM(TMP->ZN_COD))
	AAdd( (oHtml:ValByName( "t.2"    )), 'bgcolor="'+_Cor3+'" width="35%" class="TableRowWhiteMini2" align="left" height="14">'+ALLTRIM(TMP->ZN_DESCR))
	AAdd( (oHtml:ValByName( "t.3"    )), 'bgcolor="'+_Cor3+'" width="05%" class="TableRowWhiteMini2" align="left" height="14">'+ALLTRIM(TMP->ZN_UM))
	AAdd( (oHtml:ValByName( "t.4"    )), 'bgcolor="'+_Cor3+'" width="05%" class="TableRowWhiteMini2" align="center" height="14">'+TRANSFORM(TMP->ZN_QUANT,'@E 9999'))
	AAdd( (oHtml:ValByName( "t.5"    )), 'bgcolor="'+_Cor3+'" width="05%" class="TableRowWhiteMini2" align="center" height="14">'+TRANSFORM((TMP->ZN_QTENTRE-TMP->ZN_QTWKF),'@E 9999'))
	AAdd( (oHtml:ValByName( "t.6"    )), 'bgcolor="'+_Cor3+'" width="05%" class="TableRowWhiteMini2" align="center" height="14">'+TRANSFORM(TMP->ZN_QTWKF,'@E 9999'))

	SZN->(dBGoto(TMP->R_E_C_N_O_))
	nLinhas := MlCount( ALLTRIM(SZN->ZN_OBS), 40 ) //Conta o numero de linhas dentro do campo MEMO
	_cObs   := ""
    For _nI := 1 to nLinhas
		_cObs += MemoLine( ALLTRIM(SZN->ZN_OBS), 40, _nI) + _cEOL
	Next
	
	AAdd( (oHtml:ValByName( "t.7"    )), 'bgcolor="'+_Cor3+'" width="35%" class="TableRowWhiteMini2" align="left" height="14">'+_cObs )

	_cStatus := ""
	Do Case
		Case ALLTRIM(TMP->ZN_STATUS) == ""
			_cStatus := "Aberto"
		Case ALLTRIM(TMP->ZN_STATUS) == "1"
			_cStatus := "Processado"
		Case ALLTRIM(TMP->ZN_STATUS) == "2"
			_cStatus := "Pendente"
		Case ALLTRIM(TMP->ZN_STATUS) == "3"
			_cStatus := "Cancelado"
	EndCase
	AAdd( (oHtml:ValByName( "t.8"    )), 'bgcolor="'+_Cor3+'" width="10%" class="TableRowWhiteMini2" align="left" height="14">'+_cStatus )     

	_Cor++
	
	DbSelectArea("TMP")
	DbSkip()
End

If _nCont > 0
	oProcess:Start()
EndIf

DbSelectArea("TMP")
DbCloseArea()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCWKF002   บAutor  ณMicrosiga           บ Data ณ  05/29/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _EnvMail(_cEmail, _cAssunto, _cCC)

Private oHtml

oProcess:= TWFProcess():New("000001", "Workflow Requisicao de Material")
oProcess:NewVersion(.T.)
oProcess:NewTask( "Workflow Requisicao de Material", "\Workflow\CWKF003.htm")
oProcess:bReturn	:= ""
oProcess:cSubject	:= _cAssunto
oProcess:cTo  		:= _cEmail
oProcess:cCC  		:= _cCC

Return(.T.)