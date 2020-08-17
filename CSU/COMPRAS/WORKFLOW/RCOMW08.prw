#Include 'RWMAKE.CH'
#Include 'TBICONN.CH'
#include 'Ap5Mail.ch'
#Include 'TOPCONN.CH'

#DEFINE ENTER CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRCOMW08   บAutor  ณRenato Lucena Neves บ Data ณ  02/16/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envia e-mail quando a NF de entrada estiver digitada a maisบฑฑ
ฑฑบ          ณ de 2 dias sem conferencia do contabil e/ou custos          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP8-CSU Scheduller                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RCOMW08(_aPar)

Private _aUsuarios	:= {}  


//PREPARE ENVIRONMENT EMPRESA _aPar[1] FILIAL _aPar[2]	//abre a empresa e filial passada por paramtro
RpcSetEnv ( _aPar[1],_aPar[2])

_aUsuario	:= AllUsers()
SM0->(DbGoTop())

WHILE !SM0->(EOF())
	If SM0->M0_CODIGO == _aPar[1]
		DocAtrasado({SM0->M0_CODIGO,SM0->M0_CODFIL})
	endif
	SM0->(DBSkip())
ENDDO

return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDocAtrasadoAutor  ณRenato Lucena Neves บ Data ณ  14/03/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Seleciona os documentos que estใo atrasados e chama a funcaoฑฑ
ฑฑบ          ณ de envio de e-mail                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function DocAtrasado(_aPar)

Local _cQuery		:= ""
Local _cUsuario		:= ""
Local _cEmail		:= ""
Local _cNome		:= ""
Local _cTo			:= ""
Local _nTempo		:= 0

//PREPARE ENVIRONMENT EMPRESA _aPar[1] FILIAL _aPar[2]	//abre a empresa e filial passada por paramtro
RpcSetEnv ( _aPar[1],_aPar[2])

//F1_XCONF01	conferido pelo fiscal
//F1_XCONF02	conferido pelo custo
//F1_XCONF03	conferido pelo pagos

_nTempo:=GetMV("MV_XTPCONF")

_cQuery := " select F1_DTDIGIT,F1_XCONF02, F1_FILIAL, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, F1_EMISSAO, F1_USERLGI "
_cQuery += " from "+RetSQLName('SF1')
_cQuery += " where ( F1_FILIAL='"+xFilial('SF1')+"' and F1_XCONF02='' and F1_XCONF03='' and F1_XCONF01='' and D_E_L_E_T_='' and "
_cQuery += " F1_DUPL<>'' and F1_DTDIGIT<='"+dtos(Date()-_nTempo)+"') "
_cQuery += " or (F1_FILIAL='"+xFilial('SF1')+"' and F1_XCONF02<>'' and F1_XCONF03='' and F1_XCONF01='' and D_E_L_E_T_='' and F1_DUPL<>'' and "
_cQuery += " cast(substring(F1_XCONF02,4,3)+substring(F1_XCONF02,1,3)+substring(F1_XCONF02,7,2) as datetime)<='"+dtos(date()-_nTempo)+"') "

memowrit('RCOMW08.sql',_cQuery)

TcQuery _cQuery New Alias "QRY1"
DbselectArea('QRY1')
DbGoTop()

While QRY1->(!EOF())
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMonta array com os e-mails que receberใo as mensagensณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_cUsuario := Substr(Embaralha(QRY1->F1_USERLGI,1),1,15)
	_cTo := _fEnvia(_cUsuario)  //monta array com lista de e-mails para ser enviado.
	//	qout('PARA: '+_cto)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMensagem a ser enviada no e-mailณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_cFornece := GetAdvFVal('SA2','A2_NREDUZ',xFilial('SA2')+QRY1->(F1_FORNECE+F1_LOJA),1,'')
	_cMensagem := "Aten็ใo:"+ENTER
	_cMensagem += ENTER
	_cMensagem += "At้ o presente momento nใo foi acusado, pela แrea Fiscal e Contas a Pagar o recebimento do documento de entrada "+QRY1->F1_DOC+" s้rie "+QRY1->F1_SERIE
	_cMensagem += "do fornecedor "+QRY1->F1_FORNECE+"/"+QRY1->F1_LOJA+" - "+alltrim(_cFornece)+", digitado em "+dtoc(stod(QRY1->F1_DTDIGIT))+"."+ENTER
	_cMensagem += "Favor enviar o referido documento o mais rแpido possํvel เ แrea Fiscal. Evitando assim, atraso no prazo de pagamento e fechamento contแbil."+ENTER
	_cMensagem += ENTER
	_cMensagem += "CONTABILIDADE/FISCAL "+ENTER
	_cMensagem += ENTER
	_cMensagem += ENTER
	_cMensagem += ENTER
	_cMensagem += "Este E-Mail ้ gerado automaticamente pelo sistema. Nใo responda o mesmo!"
	
	u_EnviaEMail(_cTo,_cMensagem,'Conferencia em atraso!') //envia o e-mail
	
	QRY1->(DbSkip())
enddo

DbCloseArea('QRY1')

DbCloseAll()
//RESET ENVIRONMENT

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_fEnvia   บAutor  ณRenato Lucena Neves บ Data ณ  22/02/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para montar o array com os e-mails que irใo receber บฑฑ
ฑฑบ          ณ o workflow                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP8-CSU                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _fEnvia(_cUsua)

Local _cEMail:= ""
Local _nPos	 := 0
Local _cCodUser:=""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณBusca o codigo do usuแrioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_nPos:=0
_nPos:=aScan(_aUsuario,{|x| alltrim(x[1][2])==alltrim(_cUsua) })
If _nPos>0
	_cCodUser:=_aUsuario[_nPos][1][1]
endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPega o e-mail do usuแrio que incluiu a NF de entradaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_cEmail:=UsrRetMail(_cCodUser)

If !Empty(_cEmail)
	_cEmail := alltrim(_cEmail)+";"+GetMV("MV_XMAILCO")
else
	_cEMail	:= GetMV("MV_XMAILCO")
endif

Return _cEMail

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณENVIAEMAILบAutor  ณRenato Lucena Neves บ Data ณ  22/02/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para envio de e-mail                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP8 - CSU                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function EnviaEMail(cTo,cMensag,cAssunto)
Local cServer   := GetMV("MV_RELSERV")
Local cAccount  := GetMV("MV_RELACNT")
Local cEnvia    := GetMV("MV_RELACNT")
Local cPassword := GetMV("MV_RELPSW")
Local _cError	:= ""
Local _cRecebe   := cTo
Local cMensagem := cMensag

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou

If lConectou
	lAutorizou:=MAILAUTH(cAccount,cPassword)
	
	If lAutorizou
		SEND MAIL FROM alltrim(cEnvia) TO alltrim(_cRecebe) SUBJECT cAssunto BODY cMensagem RESULT lEnviado
		If !lEnviado
			Get Mail Error _cError
			qOut(_cError)
		endif
	else
		qOut('Nใo foi possํvel enviar o e-mail com a conta'+alltrim(cAccount)+'. Verifique o usuแrio e senha configurado no Workflow!')
	endif
	DISCONNECT SMTP SERVER Result lDisConectou
	
	If !lDisconectou
		qOut('Nใo foi possํvel desconectar do servidor de e-mail!')
	endif
else
	qOut('Nใo foi possivel se conectar ao servidor '+alltrim(cServer))
endif

Return
