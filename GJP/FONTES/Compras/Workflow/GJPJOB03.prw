#Include 'Protheus.ch'
#include "TopConn.ch"
#include "Ap5Mail.ch"
                                                      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGJPJOB03  บAutor  ณMicrosiga           บ Data ณ  10/06/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GJPJOB03(aEmpFil)

Local cCodEmp 		:= aEmpFil[1]
Local cCodFil 		:= aEmpFil[2]
Local cFilialSCP	:= ""
Local _cQuery		:= ""
Local cQ			:= ""
Local lExec			:= .T.
Local cAliasTrb 	:= ""

If cCodEmp = Nil .or. ValType(cCodEmp) <> "C" .or. Empty(cCodEmp)
	lExec := .F.
EndIf
If cCodFil = Nil .or. ValType(cCodFil) <> "C" .or. Empty(cCodFil)
	lExec := .F.
EndIf

If !(lExec)
	ConOut("###=========================================================###")
	ConOut("### GJPJOB03 --> ERRO : CODIGO DE EMPRESA E FILIAL INVALIDO  ###")
	ConOut("###=========================================================###")
Else
	ConOut("###=========================================================###")
	ConOut("### GJPJOB03 --> EXECUTANDO PARA EMPRESA : " + cCodEmp + " - FILIAL : " + cCodFil + " ###")
	ConOut("###=========================================================###")

	RpcSetType(3)
	lRet := RpcSetEnv(cCodEmp,cCodFil,,,'COM',,,,,.T.) //Inicializa ambiente de acordo com a empresa que serแ feito o processamento.
	If lRet

		_cQuery := "UPDATE "+RetSqlName("SCP")+" SET CP_XWF = '' "
		_cQuery += "FROM " +RetSqlName("SCP") + " "
		_cQuery += "WHERE D_E_L_E_T_ = '' AND CP_FILIAL = '"+xFilial("SCP")+"' AND CP_STATSA = 'B' AND CP_XWF = 'S' "
		TcSQLExec(_cQuery)

		cAliasTrb 	:= GetNextAlias()
		cFilialSCP 	:= xFilial("SCP")
			
		cQ := "SELECT CP_FILIAL, CP_CODSOLI, CP_NUM "
		cQ += "FROM " +RetSqlName("SCP") + " "
		cQ += "WHERE D_E_L_E_T_ = '' AND CP_FILIAL = '"+cFilialSCP+"' AND CP_STATSA = 'L' AND CP_XWF = '' "
		cQ += "GROUP BY CP_FILIAL, CP_CODSOLI, CP_NUM "
		
		cQ := ChangeQuery(cQ)
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)

		Do While (cAliasTrb)->(!Eof())
			GJPMail (UsrRetMail((cAliasTrb)->CP_CODSOLI), Alltrim(SM0->M0_NOME) + " - Solicita็ใo ao Armaz้m "+alltrim((cAliasTrb)->CP_NUM)+" da Filial "+alltrim((cAliasTrb)->CP_FILIAL)+"- LIBERADA","",  , 0, "",alltrim((cAliasTrb)->CP_NUM),alltrim((cAliasTrb)->CP_FILIAL))
			(cAliasTrb)->(DbSkip())
		Enddo
		
		_cQuery := "UPDATE "+RetSqlName("SCP")+" SET CP_XWF = 'S' "
		_cQuery += "FROM " +RetSqlName("SCP") + " "
		_cQuery += "WHERE D_E_L_E_T_ = '' AND CP_FILIAL = '"+xFilial("SCP")+"' AND CP_STATSA = 'L' AND CP_XWF = '' " 
		TcSQLExec(_cQuery)

		(cAliasTrb)->(dbCloseArea())
			
	EndIf

	RpcClearEnv()

Endif

Return()


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMTALCFIM  บAutor  ณMicrosiga           บ Data ณ  04/29/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GJPMail(cEmailTo , cAssunto, cfile, dVencto, nValor, cCliente, nNumSA, cFilSCP)//(cEmailTo , cAssunto,cfile)

Local lOk		:= .F.		// Variavel que verifica se foi conectado OK
Local lSendOk	:= .F.		// Variavel que verifica se foi enviado OK
Local cError	:= ""
Local cEmailBcc	:= ""
Local lMailAuth	:= .T. //SuperGetMv("MV_RELAUTH",,.T.)
Local cMailAuth := ""
Local lResult	:= .F.                                                       
local cMensagem	:= Nil
local cCC			:= ""
local lDNSAuth	:= .F.

Private cMailConta	:= Nil
Private cMailServer	:= Nil
Private cMailSenha	:= Nil

cMensagem   := "Prezado solicitante, " + CRLF
cMensagem	+= ""+ CRLF
cMensagem	+= "A Solicita็ใo ao Armaz้m "+nNumSA+" da Filial "+alltrim(SM0->M0_NOME)+" foi liberada pelo aprovador.
cMensagem	+= ""+ CRLF
cMensagem	+= ""+ CRLF
cMensagem	+= "Entre em contato com o almoxarife da unidade para dar prosseguimento na pr้-requisi็ใo. " + CRLF
cMensagem	+= ""+ CRLF
cMensagem	+= ""+ CRLF
cMensagem	+= ""+ CRLF
cMensagem	+= " Atenciosamente, " + CRLF
cMensagem	+= ""+ CRLF
cMensagem	+= ""+ CRLF
cMensagem	+= substr(SM0->M0_NOMECOM,1,50)+ CRLF
  

cMailConta	:= If( cMailConta	== NIL, GetMV( "MV_RELACNT" ), cMailConta  )
cMailServer	:= If( cMailServer	== NIL, GetMV( "MV_RELSERV" ), cMailServer )
cMailSenha	:= If( cMailSenha	== NIL, GetMV( "MV_RELPSW" ), cMailSenha  )


//Verifica se existe o SMTP Server
If 	Empty(cMailServer)
	Help(" ",1,"SEMSMTP")//"O Servidor de SMTP nao foi configurado !!!" ,"Atencao"
	Return .F.
EndIf

//Verifica se existe a CONTA
If 	Empty(cMailConta)
	Help(" ",1,"SEMCONTA")//"A Conta do email nao foi configurado !!!" ,"Atencao"
	Return .F.
EndIf

//Verifica se existe a Senha
If 	Empty(cMailSenha)
	Help(" ",1,"SEMSENHA")	//"A Senha do email nao foi configurado !!!" ,"Atencao"
	Return .F.
EndIf

cEmailBcc:= ""

// Envia e-mail com os dados necessarios
If !Empty(cMailServer) .And. !Empty(cMailConta) .And. !Empty(cMailSenha)
	CONNECT SMTP SERVER cMailServer ACCOUNT cMailConta PASSWORD cMailSenha RESULT lOk
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Faz a autenticacao no servidor SMTP                          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lMailAuth
		lResult := .T. //Envia E-mail
	Endif
	
	If 	lOk .And. lResult
		SEND MAIL 	FROM cMailConta	TO cEmailTo	BCC cEmailBcc SUBJECT cAssunto	BODY cMensagem RESULT lSendOk
		If !lSendOk
			//Erro no Envio do e-mail
			GET MAIL ERROR cError
			MsgInfo( cError, OemToAnsi( "Erro no envio de Email" ) ) //"Erro no envio de Email"
		EndIf
		
		DISCONNECT SMTP SERVER
	Else
		//Erro na conexao com o SMTP Server
		GET MAIL ERROR cError
		MsgInfo( cError, OemToAnsi( "Erro no envio de Email") ) // "Erro no envio de Email"
	EndIf
EndIf

Return lSendOk