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
ฑฑบPrograma  ณCPRJW01   บ Autor ณ Emerson Natali     บ Data ณ  11/01/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Workflow para a importacao do arquivo da Intranet na tabelaบฑฑ
ฑฑบ          ณ SZP                                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function TSTLINK()
Local _cQuery	 := ""
Local _cEmail	 := ""
Local _cNumSSI   := ""
Local _cAssunto  := ""
Local oHtml

Private oProcess
Private oHtml
Private _cNumSSI :=	""
Private _cUseSSI :=	""
Private _cEmail  :=	""
Private _cCR     :=	""
Private _cDesCR  :=	""
Private _cRamal  :=	""
Private _cData   :=	""
Private _cEmail2 :=	""
Private _cPedido :=	""
Private _cAnali  :=	""
Private _cNomeA  :=	""
Private _cSist   :=	""
Private _cDeSis  :=	""
Private _cIdent  :=	""

wfPrepENV( "01", "01")

ChkFile("SZP")

cDirect    := "\arq_txt\sistemas\"
cDirectImp := "\arq_txt\sistemas\Backup\"
aDirect    := Directory(cDirect+"*.TXT")

If !Empty(adirect)
	For _nI := 1 to Len(adirect)
		FT_FUSE(cDirect+adirect[_nI,1])
		FT_FGOTOP()
		cBuffer 	:=	Alltrim(FT_FREADLN())
		Do While !FT_FEOF()
			cBuffer  := Alltrim(FT_FREADLN())
			_cNumSSI :=	Substr(cBuffer,1,(At(";",cBuffer)-1))

			cBuffer	 :=	Substr(cBuffer,(At(";",cBuffer)+1),500)
			_cUseSSI :=	Substr(cBuffer,1,(At(";",cBuffer)-1))

			cBuffer	 :=	Substr(cBuffer,(At(";",cBuffer)+1),500)
			_cEmail  :=	Substr(cBuffer,1,(At(";",cBuffer)-1))

			cBuffer	 :=	Substr(cBuffer,(At(";",cBuffer)+1),500)
			_cCR     :=	Substr(cBuffer,1,(At(";",cBuffer)-1))

			cBuffer	 :=	Substr(cBuffer,(At(";",cBuffer)+1),500)
			_cDesCR  :=	Substr(cBuffer,1,(At(";",cBuffer)-1))

			cBuffer	 :=	Substr(cBuffer,(At(";",cBuffer)+1),500)
			_cRamal  :=	Substr(cBuffer,1,(At(";",cBuffer)-1))

			cBuffer	 :=	Substr(cBuffer,(At(";",cBuffer)+1),500)
			_cData   :=	Substr(cBuffer,1,(At(";",cBuffer)-1))

			cBuffer	 :=	Substr(cBuffer,(At(";",cBuffer)+1),500)
			_cEmail2 :=	Substr(cBuffer,1,(At(";",cBuffer)-1))

			cBuffer	 :=	Substr(cBuffer,(At(";",cBuffer)+1),500)
			_cPedido :=	Substr(cBuffer,1,(At(";",cBuffer)-1))

			cBuffer	:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
			_cAnali :=	Substr(cBuffer,1,(At(";",cBuffer)-1))

			cBuffer	:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
			_cNomeA :=	Substr(cBuffer,1,(At(";",cBuffer)-1))

			cBuffer	:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
			_cSist  :=	Substr(cBuffer,1,(At(";",cBuffer)-1))

			cBuffer	:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
			_cDeSis :=	Substr(cBuffer,1,(At(";",cBuffer)-1))

			cBuffer	 :=	Substr(cBuffer,(At(";",cBuffer)+1),500)
			_cIdent  :=	Alltrim(cBuffer)

			_xArea	:= GetArea()
			DbSelectArea("SZP")
			DbSetOrder(1)
			If !DbSeek(xFilial("SZP")+alltrim(_cNumSSI))
				RecLock("SZP",.T.)
				SZP->ZP_FILIAL  := xFilial("SZP")
				SZP->ZP_NRSSI   := _cNumSSI
				SZP->ZP_EMISSAO := ctod(_cData)
				SZP->ZP_CR      := _cCR
				SZP->ZP_CRDESCR := _cDesCR
				SZP->ZP_SERVICO := _cPedido
				SZP->ZP_CODANAL := _cAnali
				SZP->ZP_ANALIST := _cNomeA
				SZP->ZP_SISTEMA := _cSist
				SZP->ZP_DESCSIS := _cDeSis
				SZP->ZP_TPIDENT := _cIdent
				SZP->ZP_SOLICIT := _cUseSSI
				SZP->ZP_RAMAL   := _cRamal
				SZP->ZP_EMAIL1  := _cEmail
				SZP->ZP_EMAIL2  := _cEmail2
				SZP->ZP_APROV   := "N"
				SZP->ZP_ALOC    := "N"
				SZP->ZP_ARQUIVO	:= "2"
				SZP->ZP_CANCEL	:= "2"
				MsUnLock()
			EndIf
			RestArea(_xArea)

			_fEnvia (_cEmail , _cNumSSI, _cUseSSI, (_cCR+"-"+_cDesCR), ctod(_cData), _cDeSis, _cIdent, _cPedido)

			FT_FSKIP()
		EndDo
		FT_FUSE()
	Next
EndIf

//Copia e Deleta o arquivo da pasta Origem para a pasta Importado. De qualquer Banco
For _nI := 1 to Len(adirect)
	__copyfile(cDirect+adirect[_nI,1],cDirectImp+adirect[_nI,1])
	ferase(cDirect+adirect[_nI,1])
Next

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

Static Function _fEnvia(_cEmail, _cNumSSI, _cUseSSI, _cCR, _cData, _cDeSis, _cIdent, _cPedido)

_cAssunto  	:= OemToAnsi("Solicita็ใo de Aprova็ใo de SSI - "+_cNumSSI )
_cEOL     	:= CHR(13) + CHR(10)
_nCont		:= 0  

Private oHtml


_cUser	:= "000016"
_cTo	:= _cUser


DbSelectArea("SZP")
DbSetOrder(1)
If DbSeek(xFilial("SZP")+_cNumSSI)

	If !Empty(_cEmail)
		oProcess:= TWFProcess():New("000001", "Workflow Controle SSI")
		oProcess:NewTask( "Workflow Controle SSI", "\Workflow\WFSSIAPR.htm")
		oProcess:NewVersion(.T.)
		oProcess:bReturn	:= "u_TSTJW01a(1,'"+_cAssunto+"','"+_cNumSSI+"')"
		oProcess:cSubject	:= _cAssunto
//		oProcess:cTo  		:= _cEmail
		oProcess:cTo     	:= _cTo
		oProcess:UserSiga	:= _cUser

		oProcess:cBody 		:= OemToAnsi("Sr. usuแrio favor clicar no anexo para visualizar a SSI e nela efetuar sua APROVAวรO !!!") +_cEOL
		oProcess:cBody 		+= OemToAnsi("Esta ้ uma mensagem automแtica. Por favor, nใo responda!!!") 

		//oProcess:cCC  		:= GETMV("CI_WFAPRB")//'sistemas@ciee.org.br'
		conout("Inicio do Envio CPRJW01...")

		oHtml  		:= oProcess:oHTML
		oHtml:ValByName("numssi"	, _cNumSSI	)
		oHtml:ValByName("solic"		, _cUseSSI	)
		oHtml:ValByName("cr"		, _cCR		)
		oHtml:ValByName("data"		, _cData	)
		oHtml:ValByName( "OBS"    	, ""		)
	EndIf 
	
	AAdd( (oHtml:ValByName( "t.1"     )), ALLTRIM(_cDeSis))
	AAdd( (oHtml:ValByName( "t.2"     )), ALLTRIM(_cIdent))
	AAdd( (oHtml:ValByName( "t.3"     )), ALLTRIM(_cPedido))

	cProcess := oProcess:Start()
	conout("Fim do Envio...")
	
	IF !"@" $ oProcess:cTO
		_cNome := UsrRetName(_cUser)
		aMsg := {}
		aaDD(aMsg, "Sr.(a) " + _cNome )
		AADD(aMsg, " Enviamos o email com o link abaixo para a sua aprovacao. ")
		AADD(aMsg, " Referente a analise do Pedido de Compra No. " + _cNumSSI )
		AADD(aMsg, " ")
		AADD(aMsg, " ")
		AADD(aMsg, "Atenciosamente ")
		AADD(aMsg, " ")
		AADD(aMsg, "Workflow Protheus")
		AADD(aMsg, " ")
	
		aAdd(aMsg, '<p><a href="' +"http://fenix:8081"+'/messenger/emp' +cEmpAnt  + '/' + _cUser + '/' + alltrim(cProcess) + '.htm">clique aqui</a></p>')
	
		_cTo := UsrRetMail(_cTo)
		U_fEnviaLink( _cTo, oProcess:cSubject , aMsg )
	ENDIF
EndIf

Return

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
USER FUNCTION fEnviaLink(cTo, cTitle, aMsg, aFiles )
Local cBody, nInd

cBody := '<html>'
cBody += '<DIV><SPAN class=610203920-12022004><FONT face=Verdana color=#ff0000 '
cBody += 'size=2><STRONG>Workflow - Servi็o Envio de Mensagens</STRONG></FONT></SPAN></DIV><hr>'
For nInd := 1 TO Len(aMsg)
	cBody += '<DIV><FONT face=Verdana color=#000080 size=3><SPAN class=216593018-10022004>' + aMsg[nInd] + '</SPAN></FONT></DIV><p>'
Next
cBody += '</html>'

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

User Function TSTJW01a(nAprov,_cAssunto, _cNumSSI, oProcess)

_cNotif1 := {}
_cNotif2 := {}

_cOBS := oProcess:oHtml:RetByName("OBS")
_cOpc := oProcess:oHtml:RetByName("OPC")

If Empty(_cOBS)
	_cOBS := "Cancelado sem justificativa do Aprovador"
EndIf

oProcess:Finish()

If _cOpc == "S"
	_cQuery	:= "UPDATE "+ RetSqlName("SZP")+" SET ZP_APROV = 'S' , ZP_DTAPROV = '"+DtoS(dDataBase)+"' "
	_cQuery += "WHERE D_E_L_E_T_ <> '*' AND ZP_NRSSI = '"+_cNumSSI+"' "
	TcSQLExec(_cQuery)
ElseIf _cOpc == "N"

	_cQuery	:= "UPDATE "+ RetSqlName("SZP")+" SET ZP_APROV = 'N', ZP_CANCEL = '1', ZP_MOTIVO = '"+_cOBS+"', ZP_DTAPROV = '"+DtoS(dDataBase)+"' "
	_cQuery += "WHERE D_E_L_E_T_ <> '*' AND ZP_NRSSI = '"+_cNumSSI+"' "
	TcSQLExec(_cQuery)


	oProcess:= TWFProcess():New("000001", "Workflow Reserva Financeira")
	oProcess:NewTask( "Workflow Controle SSI", "\Workflow\WFSSI.htm")
	oProcess:NewVersion(.T.)
	oProcess:cSubject	:= _cAssunto
	oProcess:cTo  		:= 'emerson.natali@totvs.com.br'
	oProcess:bReturn	:= NIL
	oProcess:cBody  	:= OemToAnsi("Solicita็ใo "+_cNumSSI+" cancelado pelo Superior!!!")

	oHtml  		:= oProcess:oHTML

	oProcess:Start()
EndIf

Return
