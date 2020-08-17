#Include 'Protheus.ch'
#include "TopConn.ch"
#include "Ap5Mail.ch"
                                                      
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GJPJOB01  �Autor  �Microsiga           � Data �  10/06/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GJPJOB01(aEmpFil)

Local cCodEmp 		:= aEmpFil[1]
Local cCodFil 		:= aEmpFil[2]
Local cFilialSC1	:= ""
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
	ConOut("### GJPJOB01 --> ERRO : CODIGO DE EMPRESA E FILIAL INVALIDO  ###")
	ConOut("###=========================================================###")
Else
	ConOut("###=========================================================###")
	ConOut("### GJPJOB01 --> EXECUTANDO PARA EMPRESA : " + cCodEmp + " - FILIAL : " + cCodFil + " ###")
	ConOut("###=========================================================###")

	RpcSetType(3)
	lRet := RpcSetEnv(cCodEmp,cCodFil,,,'COM',,,,,.T.) //Inicializa ambiente de acordo com a empresa que ser� feito o processamento.
	If lRet

		_cQuery := "UPDATE "+RetSqlName("SC1")+" SET C1_XWF = '' "
		_cQuery += "FROM " +RetSqlName("SC1") + " "
		_cQuery += "WHERE D_E_L_E_T_ = '' AND C1_FILIAL = '"+xFilial("SC1")+"' AND C1_APROV = 'B' AND C1_XWF = 'S' "
		TcSQLExec(_cQuery)

		cAliasTrb 	:= GetNextAlias()
		cFilialSC1 	:= xFilial("SC1")
			
		cQ := "SELECT C1_FILIAL, C1_USER, C1_NUM "
		cQ += "FROM " +RetSqlName("SC1") + " "
		cQ += "WHERE D_E_L_E_T_ = '' AND C1_FILIAL = '"+cFilialSC1+"' AND C1_APROV = 'L' AND C1_XWF = '' "
		cQ += "GROUP BY C1_FILIAL, C1_USER, C1_NUM "
		
		cQ := ChangeQuery(cQ)
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.T.)

		Do While (cAliasTrb)->(!Eof())
			GJPMail (UsrRetMail((cAliasTrb)->C1_USER), Alltrim(SM0->M0_NOME) + " - Solicita��o de Compras "+alltrim((cAliasTrb)->C1_NUM)+" da Filial "+alltrim((cAliasTrb)->C1_FILIAL)+"- LIBERADA","",  , 0, "",alltrim((cAliasTrb)->C1_NUM),alltrim((cAliasTrb)->C1_FILIAL))
			(cAliasTrb)->(DbSkip())
		Enddo
		
		_cQuery := "UPDATE "+RetSqlName("SC1")+" SET C1_XWF = 'S' "
		_cQuery += "FROM " +RetSqlName("SC1") + " "
		_cQuery += "WHERE D_E_L_E_T_ = '' AND C1_FILIAL = '"+xFilial("SC1")+"' AND C1_APROV = 'L' AND C1_XWF = '' " 
		TcSQLExec(_cQuery)

		(cAliasTrb)->(dbCloseArea())
			
	EndIf

	RpcClearEnv()

Endif

Return()


Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTALCFIM  �Autor  �Microsiga           � Data �  04/29/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GJPMail(cEmailTo , cAssunto, cfile, dVencto, nValor, cCliente, nNumSC, cFilSC1)//(cEmailTo , cAssunto,cfile)

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
cMensagem	+= "A Solicita��o de Compras "+nNumSC+" da Filial "+alltrim(SM0->M0_NOME)+" foi liberada pelo aprovador.
cMensagem	+= ""+ CRLF
cMensagem	+= ""+ CRLF
cMensagem	+= "Acesse a interface de Solicita��o de Compras para dar prosseguimento. " + CRLF
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
	
	//��������������������������������������������������������������Ŀ
	//� Faz a autenticacao no servidor SMTP                          �
	//����������������������������������������������������������������
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