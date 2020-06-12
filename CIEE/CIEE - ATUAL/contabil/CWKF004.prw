#include "rwmake.ch"
#include "Topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#include "fileio.ch"
#include "Protheus.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCWKF004   บ Autor ณ Emerson Natali     บ Data ณ  11/09/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Geracao do WorkFlow para Cotacao Aplicacao Financeira      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CWKF004(cNumero)
Local _cQuery	 := ""
Local _cEmail	 := ""
Local _cNumApl   := ""
Local _cAssunto  := ""
Local oHtml
Local nTries := 0
Local nHandle := -1

Private oProcess
Private oHtml
Private _cUser
Private _cTo

wfPrepENV( "01", "01")

// Protege
if !file("CWKF004.LCK")
   nHandle := fcreate("CWKF004.LCK", FC_NORMAL)
   fclose(nHandle)
endif
while(nTries <= 5 .and. ( (nHandle := fopen("CWKF004.LCK", FO_EXCLUSIVE)) == -1 ) )
   fopen(CWKF004)
   sleep(5000)
   nTries++
end
if(nTries == 5)
  conout("Execucao cancelada. Rotina ja esta sendo executada.")
  return
endif  

ChkFile("SZO") 

_cQuery	:= "SELECT * "
_cQuery	+= "FROM " + RetSqlName("SZO")+" "
_cQuery += "WHERE D_E_L_E_T_ <> '*' "
_cQuery += "AND ZO_NUMERO = '"+cNumero+"' "
_cQuery += "AND ZO_FLAG = '' "
_cQuery += "ORDER BY ZO_NUMERO, ZO_NOMBCO "
TCQUERY _cQuery ALIAS "TMPAPL" NEW

DbSelectArea("TMPAPL")
DbGotop()

Do While !EOF()

	_cNumApl := TMPAPL->ZO_NUMERO // Numero da Cotacao da Aplicacao
	
	_cQuery	:= "SELECT * "
	_cQuery	+= "FROM " + RetSqlName("SZO")+" "
	_cQuery += "WHERE D_E_L_E_T_ <> '*' "
	_cQuery += "AND ZO_NUMERO = '"+_cNumApl+"' "
	_cQuery += "AND ZO_FLAG = '' "
	_cQuery += "ORDER BY ZO_NUMERO, ZO_NOMBCO, ZO_VLAPL, ZO_TXBRAM, ZO_TXCDI, ZO_DIAS "
	TCQUERY _cQuery ALIAS "TMP" NEW
	
	_cEmail	 := "000016" //Codigo usuario SIGA
	
	_fEnvia(_cEmail,_cNumApl) //Chama funcao para disparar o e-mail

	_cQuery	:= "UPDATE "+ RetSqlName("SZO")+" SET ZO_FLAG = '1' "
	_cQuery += "WHERE D_E_L_E_T_ <> '*' AND ZO_NUMERO = '"+_cNumApl+"' "
	_cQuery += "AND ZO_FLAG = '' "
	TcSQLExec(_cQuery)

	DbSelectArea("TMPAPL")
	TMPAPL->(dbSkip())
EndDo

DbSelectArea("TMPAPL")
DbCloseArea()

// Protege fim
fclose(nHandle)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCWKF002   บAutor  ณMicrosiga           บ Data ณ  08/14/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEnvia e-mail para o Aprovador A (Supervisor)                บฑฑ
ฑฑบ          ณ(Conferencia)                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _fEnvia(_cEmail,_cNumApl)

DbSelectArea("TMP")
DbGoTop()

_cAssunto  	:= OemToAnsi("Renova็ใo Aplica็ใo Financeira - "+_cNumApl )
_cEOL     	:= CHR(13) + CHR(10)
_lFirst		:= .T.
_nCont		:= 0  
_Cor		:= 0
_Cor1		:= "#B4BAC6"
_Cor2		:= "#9397A0"

Private oHtml

_cUser	:= _cEmail
_cTo	:= _cUser

While !TMP->(Eof())

	_nCont++
	
	If !Empty(_cEmail) .and. _lFirst

		oProcess:= TWFProcess():New("000001", "Workflow Reserva Financeira")
		oProcess:NewTask( "Workflow Reserva Financeira", "\Workflow\WFConfApl.htm")
		oProcess:NewVersion(.T.)
		oProcess:bReturn	:= "u_CWKF004a(1,'"+_cAssunto+"','"+_cNumApl+"')"
		oProcess:cSubject	:= _cAssunto
		oProcess:cTo  		:= _cTo

		oProcess:UserSiga	:= _cUser

		conout("Inicio do Envio CWKF004...")
		_lFirst		:= .F.
		oHtml  		:= oProcess:oHTML
		oHtml:ValByName( "OBS"    ,"")
	EndIf 

	If _Cor % 2 == 0
		_Cor3 := _Cor1
	Else
		_Cor3 := _Cor2
	EndIf
	
	AAdd( (oHtml:ValByName( "t.1"     )), ALLTRIM(TMP->ZO_NOMBCO))
	AAdd( (oHtml:ValByName( "t.2"     )), TRANSFORM(TMP->ZO_NREST,'@E 99,999'))
	AAdd( (oHtml:ValByName( "t.3"     )), TRANSFORM(TMP->ZO_VLAPL,'@E 99,999,999.99'))
	AAdd( (oHtml:ValByName( "t.4"     )), TRANSFORM(TMP->ZO_DIAS,'99'))
	AAdd( (oHtml:ValByName( "t.5"     )), TRANSFORM(TMP->ZO_DU,'99'))
	AAdd( (oHtml:ValByName( "t.6"     )), TRANSFORM(TMP->ZO_TXANO,'@E 999.99999'))
	AAdd( (oHtml:ValByName( "t.7"     )), TRANSFORM(TMP->ZO_TXDIA,'@E 999.99999'))
	AAdd( (oHtml:ValByName( "t.8"     )), TRANSFORM(TMP->ZO_30DD ,'@E 999.99999'))
	AAdd( (oHtml:ValByName( "t.9"     )), TRANSFORM(TMP->ZO_TXPER,'@E 999.99999'))
	AAdd( (oHtml:ValByName( "t.10"    )), DTOC(STOD(TMP->ZO_VENCT)))
	AAdd( (oHtml:ValByName( "t.11"    )), TRANSFORM(TMP->ZO_VLNOM,'@E 99,999,999.99'))
	AAdd( (oHtml:ValByName( "t.15"    )), TRANSFORM(TMP->ZO_TXCDI,'@E 999.99999'))
	AAdd( (oHtml:ValByName( "t.16"    )), TRANSFORM(TMP->ZO_ITEM,'@E 99'))
	AAdd( (oHtml:ValByName( "t.17"    )), TRANSFORM(TMP->ZO_TXBRAM,'@E 999.99999'))	
	AAdd( (oHtml:ValByName( "t.13"    )), _Cor3 )

	_Cor++
	
	DbSelectArea("TMP")
	DbSkip()
End

If _nCont > 0
	cProcess   := oProcess:Start()
	cHtmlFile  := cProcess + ".htm"
	cHtmlTexto := wfloadfile("\workflow\messenger\emp"+cEmpAnt+"\"+_cUser+"\"+cHtmlFile)
	cHtmlTexto := Strtran(cHtmlTexto,"WFHTTPRET.APW","WFHTTPRET.APL")
	wfsavefile("\workflow\messenger\emp"+cEmpAnt+"\"+_cUser+"\"+cHtmlFile+"l",cHtmlTexto)
	conout("Fim do Envio CWKF004...")
EndIf

DbSelectArea("TMP")
DbCloseArea()               	

If _nCont > 0
	IF !"@" $ oProcess:cTO
		_cNome := cUserName
		aMsg := {}
		aaDD(aMsg, "Segue, Consulta da Aplica็ใo Financeira No. "+_cNumApl+"," )
		AADD(aMsg, "para sua confer๊ncia e posterior envio para aprova็ใo da Superintend๊ncia.")
		AADD(aMsg, " ")
		aAdd(aMsg, '<p><a href="'+'http://187.94.62.86:8282/workflow/messenger/emp' +cEmpAnt  + '/' + _cUser + '/' + alltrim(cProcess) + '.html">clique aqui</a> para visualizar a Aplica็ใo.</p>')
		AADD(aMsg, " ")
		AADD(aMsg, " ")
		
		_cTo := UsrRetMail(_cTo)
		U_fEnviaLink( _cTo, oProcess:cSubject , aMsg , 1)
	ENDIF
ENDIF
	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfEnviaLinkบAutor  ณAdriano Luis Brandaoบ Data ณ  05/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao de notificacao.                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP - CORUS                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
USER FUNCTION fEnviaLink(cTo, cTitle, aMsg, _aRot ,aFiles )
Local cBody, nInd

cBody := '<html>'
cBody += '<DIV><SPAN class=610203920-12022004><FONT face=Verdana color=#ff0000 '
If _aRot == 1
	cBody += 'size=2><STRONG>Supervisor - Workflow Protheus - Servi็o Envio de Mensagens Automแtico</STRONG></FONT></SPAN></DIV><hr>'
ElseIf _aRot == 2
	cBody += 'size=2><STRONG>Superintend๊ncia - Workflow Protheus - Servi็o Envio de Mensagens Automแtico</STRONG></FONT></SPAN></DIV><hr>'  
ElseIf _aRot == 3 
	cBody += 'size=2><STRONG>SSI - Workflow Protheus - Servi็o Envio de Mensagens Automแtico</STRONG></FONT></SPAN></DIV><hr>'  
EndIf
For nInd := 1 TO Len(aMsg)
	cBody += '<DIV><FONT face=Verdana color=#000080 size=3><SPAN class=216593018-10022004>' + aMsg[nInd] + '</SPAN></FONT></DIV><p>'
Next
cBody += '<DIV><FONT face=Verdana color=#000080 size=1><SPAN class=216593018-10022004>Esta mensagem foi gerada automaticamente pelo Sistema. Favor nใo responder!</SPAN></FONT></DIV>'
cBody += '</html>'

If _aRot == 1
	cTo	+= ";"+GETMV("CI_WFAPRA")
ElseIf _aRot == 2
	cTo	+= ";"+GETMV("CI_WFAPRB")
EndIf

RETURN WFNotifyAdmin( cTo , cTitle, cBody, aFiles ) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCWKF004a  บAutor  ณMicrosiga           บ Data ณ  02/19/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEnvia e-mail para Aprovador B                               บฑฑ
ฑฑบ          ณ(Analise do movimento)                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CWKF004a(nAprov,_cAssunto, _cNumApl, oProcess)

_cNotif1 := {}
_cNotif2 := {}
_Cor		:= 0
_Cor1		:= "#B4BAC6"
_Cor2		:= "#9397A0"

conout("Inicio do Retorno CWKF004a ...")
conout("nAprov:"+str(nAprov))
conout(Len(oProcess:oHtml:RetByName( "t.1")))

_cOBS := oProcess:oHtml:RetByName("OBS")

For _nI := 1 to Len(oProcess:oHtml:RetByName( "t.1"))

	_cBco		:= oProcess:oHtml:RetByName( "t.1")[_nI]
	_cQtdEst	:= oProcess:oHtml:RetByName( "t.2")[_nI]
	_cVlrApl	:= oProcess:oHtml:RetByName( "t.3")[_nI]
	_cQtDias	:= oProcess:oHtml:RetByName( "t.4")[_nI]
	_cDU		:= oProcess:oHtml:RetByName( "t.5")[_nI]
	_cTxAno		:= oProcess:oHtml:RetByName( "t.6")[_nI]
	_cTxDia		:= oProcess:oHtml:RetByName( "t.7")[_nI]
	_cTx30d		:= oProcess:oHtml:RetByName( "t.8")[_nI]
	_cTxPer		:= oProcess:oHtml:RetByName( "t.9")[_nI]
	_cVencto	:= oProcess:oHtml:RetByName( "t.10")[_nI]
	_cVlrNom	:= oProcess:oHtml:RetByName( "t.11")[_nI]
	_cTxCDI		:= oProcess:oHtml:RetByName( "t.15")[_nI]
	_nRecno		:= oProcess:oHtml:RetByName( "t.16")[_nI]
	_cTxBRAM	:= oProcess:oHtml:RetByName( "t.17")[_nI]

    AAdd(_cNotif1, {_cBco,;
    				_cQtdEst,;
    				_cVlrApl,;
    				_cQtDias,;
    				_cDU,;
    				_cTxAno,;
    				_cTxDia,;
    				_cTx30d,;
    				_cTxPer,;
    				_cVencto,;
    				_cVlrNom,;
    				_cTxCDI,;
    				_nRecno,;
    				_cTxBRAM})
Next _nI

oProcess:Finish()

_cUser	:= "000016" //Siga
_cTo	:= _cUser

oProcess:= TWFProcess():New("000001", "Workflow Reserva Financeira")
oProcess:NewTask( "Workflow Reserva Financeira", "\Workflow\WFAprApl.htm")
oProcess:NewVersion(.T.)
oProcess:bReturn	:= "u_CWKF004b(2,'"+_cAssunto+"','"+_cNumApl+"')"
oProcess:cSubject	:= _cAssunto
oProcess:cTo     	:= _cTo

oProcess:UserSiga	:= _cUser

oHtml  		:= oProcess:oHTML
oHtml:ValByName( "OBS"    ,_cOBS)

For _nY := 1 to Len(_cNotif1)

	If _Cor % 2 == 0
		_Cor3 := _Cor1
	Else
		_Cor3 := _Cor2
	EndIf

	AAdd( (oHtml:ValByName( "t.1"     )), _cNotif1[_nY, 1])
	AAdd( (oHtml:ValByName( "t.2"     )), _cNotif1[_nY, 2])
	AAdd( (oHtml:ValByName( "t.3"     )), _cNotif1[_nY, 3])
	AAdd( (oHtml:ValByName( "t.4"     )), _cNotif1[_nY, 4])
	AAdd( (oHtml:ValByName( "t.5"     )), _cNotif1[_nY, 5])
	AAdd( (oHtml:ValByName( "t.6"     )), _cNotif1[_nY, 6])
	AAdd( (oHtml:ValByName( "t.7"     )), _cNotif1[_nY, 7])
	AAdd( (oHtml:ValByName( "t.8"     )), _cNotif1[_nY, 8])
	AAdd( (oHtml:ValByName( "t.9"     )), _cNotif1[_nY, 9])
	AAdd( (oHtml:ValByName( "t.10"    )), _cNotif1[_nY,10])
	AAdd( (oHtml:ValByName( "t.11"    )), _cNotif1[_nY,11])
	AAdd( (oHtml:ValByName( "t.12"    )), " " )
	AAdd( (oHtml:ValByName( "t.13"   )), _Cor3 )
	AAdd( (oHtml:ValByName( "t.15"   )), _cNotif1[_nY,12] )
	AAdd( (oHtml:ValByName( "t.16"   )), _cNotif1[_nY,13] )
	AAdd( (oHtml:ValByName( "t.17"   )), _cNotif1[_nY,14] )
	
	_Cor++
	
Next _nY

cProcess := oProcess:Start()
cHtmlFile  := cProcess + ".htm"
cHtmlTexto := wfloadfile("\workflow\messenger\emp"+cEmpAnt+"\"+_cUser+"\"+cHtmlFile)
cHtmlTexto := Strtran(cHtmlTexto,"WFHTTPRET.APW","WFHTTPRET.APL")
wfsavefile("\workflow\messenger\emp"+cEmpAnt+"\"+_cUser+"\"+cHtmlFile+"l",cHtmlTexto)

_cQuery	:= "UPDATE "+ RetSqlName("SZO")+" SET ZO_FLAG = '2' , ZO_APRV1 = 'CRISTIANO' "
_cQuery += "WHERE D_E_L_E_T_ <> '*' AND ZO_NUMERO = '"+_cNumApl+"' "
_cQuery += "AND ZO_FLAG = '1' "
TcSQLExec(_cQuery)

IF !"@" $ oProcess:cTO
	_cNome := cUserName
	aMsg := {}
	aaDD(aMsg, "Segue, Consulta da Aplica็ใo Financeira No. "+_cNumApl+"," )
	AADD(aMsg, "para sua aprova็ใo.")
	AADD(aMsg, " ")
	aAdd(aMsg, '<p><a href="'+'http://187.94.62.86:8282/workflow/messenger/emp' +cEmpAnt  + '/' + _cUser + '/' + alltrim(cProcess) + '.html">clique aqui</a> para visualizar a Aplica็ใo.</p>')
	AADD(aMsg, " ")
	AADD(aMsg, " ")
	
	_cTo := UsrRetMail(_cTo)
	U_fEnviaLink( _cTo, oProcess:cSubject , aMsg, 2)
ENDIF


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCWKF004   บAutor  ณMicrosiga           บ Data ณ  02/26/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEnvia e-mail de Notificacao de Aprovacao                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CWKF004b(nAprov,_cAssunto, _cNumApl, oProcess)

_cNotif1 := {}
_cNotif2 := {}
_Cor		:= 0
_Cor1		:= "#B4BAC6"
_Cor2		:= "#9397A0"

_cAssunto  	:= OemToAnsi("Aprova็ใo ")+_cAssunto

conout("Inicio do Retorno CWKF004b ...")
conout("OBS:"+oProcess:oHtml:RetByName("OBS"))
conout("nAprov:"+str(nAprov))
conout(Len(oProcess:oHtml:RetByName( "t.12")))

_cOBS := oProcess:oHtml:RetByName("OBS")
_aAprov := oProcess:oHtml:RetByName( "t.12" )

For _nI := 1 to Len(oProcess:oHtml:RetByName( "t.1"))

	_cBco		:= oProcess:oHtml:RetByName( "t.1")[_nI]
	_cQtdEst	:= oProcess:oHtml:RetByName( "t.2")[_nI]
	_cVlrApl	:= oProcess:oHtml:RetByName( "t.3")[_nI]
	_cQtDias	:= oProcess:oHtml:RetByName( "t.4")[_nI]
	_cDU		:= oProcess:oHtml:RetByName( "t.5")[_nI]
	_cTxAno		:= oProcess:oHtml:RetByName( "t.6")[_nI]
	_cTxDia		:= oProcess:oHtml:RetByName( "t.7")[_nI]
	_cTx30d		:= oProcess:oHtml:RetByName( "t.8")[_nI]
	_cTxPer		:= oProcess:oHtml:RetByName( "t.9")[_nI]
	_cVencto	:= oProcess:oHtml:RetByName( "t.10")[_nI]
	_cVlrNom	:= oProcess:oHtml:RetByName( "t.11")[_nI]
	_cTxCDI 	:= oProcess:oHtml:RetByName( "t.15")[_nI]
	_nRecno 	:= oProcess:oHtml:RetByName( "t.16")[_nI]
	_cTxBRAM 	:= oProcess:oHtml:RetByName( "t.17")[_nI]
	_bAprov 	:= Alltrim(Iif(ValType(oProcess:oHtml:RetByName("t.12")[_nI])=="U"," ",oProcess:oHtml:RetByName("t.12")[_nI]))

    AAdd(_cNotif1, {_cBco,;
    				_cQtdEst,;
    				_cVlrApl,;
    				_cQtDias,;
    				_cDU,;
    				_cTxAno,;
    				_cTxDia,;
    				_cTx30d,;
    				_cTxPer,;
    				_cVencto,;
    				_cVlrNom,;
    				_cTxCDI,;
    				_nRecno,;
    				_bAprov,;
    				_cTxBRAM})
Next _nI

oProcess:Finish()

oProcess:= TWFProcess():New("000001", "Workflow Reserva Financeira")
oProcess:NewTask( "Workflow Reserva Financeira", "\Workflow\WFRenovApl.htm")
oProcess:NewVersion(.T.)
oProcess:bReturn	:= ""
oProcess:cSubject	:= _cAssunto
oProcess:cTo  		:= GETMV("CI_WFAPRA")
//oProcess:cTo  		:= 'sistemas@ciee.org.br'

oHtml  		:= oProcess:oHTML
oHtml:ValByName( "OBS"    ,_cOBS)

_cItem := ""

For _nY := 1 to Len(_cNotif1)

	If _Cor % 2 == 0
		_Cor3 := _Cor1
	Else
		_Cor3 := _Cor2
	EndIf

	AAdd( (oHtml:ValByName( "t.1"     )), _cNotif1[_nY, 1])
	AAdd( (oHtml:ValByName( "t.2"     )), _cNotif1[_nY, 2])
	AAdd( (oHtml:ValByName( "t.3"     )), _cNotif1[_nY, 3])
	AAdd( (oHtml:ValByName( "t.4"     )), _cNotif1[_nY, 4])
	AAdd( (oHtml:ValByName( "t.5"     )), _cNotif1[_nY, 5])
	AAdd( (oHtml:ValByName( "t.6"     )), _cNotif1[_nY, 6])
	AAdd( (oHtml:ValByName( "t.7"     )), _cNotif1[_nY, 7])
	AAdd( (oHtml:ValByName( "t.8"     )), _cNotif1[_nY, 8])
	AAdd( (oHtml:ValByName( "t.9"     )), _cNotif1[_nY, 9])
	AAdd( (oHtml:ValByName( "t.10"    )), _cNotif1[_nY,10])
	AAdd( (oHtml:ValByName( "t.11"    )), _cNotif1[_nY,11])
	AAdd( (oHtml:ValByName( "t.12"    )), iif(_cNotif1[_nY,14]=="S","SIM","NAO"))
	AAdd( (oHtml:ValByName( "t.13"   )), _Cor3 )
	AAdd( (oHtml:ValByName( "t.15"   )), _cNotif1[_nY,12] )
	AAdd( (oHtml:ValByName( "t.16"   )), _cNotif1[_nY,13] )
	AAdd( (oHtml:ValByName( "t.17"   )), _cNotif1[_nY,15] )


	If _cNotif1[_nY,14] == "S"
		_cItem += ","+AllTrim(_cNotif1[_nY,13])
	EndIf

	_Cor++
	
Next _nY

oHtml:ValByName( "estado", "disabled" )

cProcess := oProcess:Start()

_cQuery	:= "UPDATE "+ RetSqlName("SZO")+" SET ZO_RENOVA = 'S' "
_cQuery += "WHERE D_E_L_E_T_ <> '*' AND ZO_NUMERO = '"+_cNumApl+"' "
_cQuery += "AND ZO_ITEM IN ("+SubStr(_cItem,2)+") "
TcSQLExec(_cQuery)

_cQuery	:= "UPDATE "+ RetSqlName("SZO")+" SET ZO_FLAG = '3' , ZO_APRV2 = 'JOAQUIM' "
_cQuery += "WHERE D_E_L_E_T_ <> '*' AND ZO_NUMERO = '"+_cNumApl+"' "
_cQuery += "AND ZO_FLAG = '2' "
TcSQLExec(_cQuery)

_cQuery	:= "SELECT COUNT(ZR_NUMERO) AS RECOBS "
_cQuery	+= "FROM " + RetSqlName("SZR")+" "
_cQuery += "WHERE D_E_L_E_T_ <> '*' AND ZR_NUMERO = '"+_cNumApl+"' "
TCQUERY _cQuery ALIAS "TMPOBS" NEW

If TMPOBS->RECOBS > 0
	_cQuery	:= "UPDATE "+ RetSqlName("SZR")+" SET ZR_OBS = '"+_cOBS+"' "
	_cQuery += "WHERE D_E_L_E_T_ <> '*' AND ZR_NUMERO = '"+_cNumApl+"' "
	TcSQLExec(_cQuery)
Else
	_cQuery	:= "SELECT COUNT(R_E_C_N_O_) AS REC "
	_cQuery += "FROM "+ RetSqlName("SZR")+""
	TCQUERY _cQuery ALIAS "TMPREC" NEW
    
	If TMPREC->REC > 0
		_nRECNO := ALLTRIM(STR((TMPREC->REC+1)))
	Else
		_nRECNO := "1"
	EndIf

	_cOBS := _cOBS+CHR(10)+CHR(13)
	
	_cQuery	:= "INSERT "+ RetSqlName("SZR")+" "
	_cQuery += "(ZR_FILIAL, ZR_NUMERO, ZR_OBS, D_E_L_E_T_, R_E_C_N_O_) VALUES ('  ', '"+_cNumApl+"', '"+_cOBS+"',' ','"+_nRECNO+"')
	TcSQLExec(_cQuery)
	
	TcSQLExec(_cQuery)

EndIf

TMPOBS->(DbCloseArea())
TMPREC->(DbCloseArea())

Return