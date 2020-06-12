#INCLUDE "PROTHEUS.CH"
#INCLUDE "AP5MAIL.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEMAIL     บAutor  ณCristiano Giardini  บ Data ณ  05/03/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao U_EMail()                                            บฑฑ
ฑฑบ          ณEnvio de E-Mail para gerenciar se o usuario esta utilizando บฑฑ
ฑฑบ          |o Sistema                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus8 - BDI                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function EMail()

Local oDlg     := NIL
Local cMask    := "Todos os arquivos (*.*) |*.*|"
Local oMsg

Private cTitulo  := "Criar e-mail"
Private cServer  := Trim(GetMV("MV_RELSERV")) // smtp.ig.com.br ou 200.181.100.51
Private cEmail   := Trim(GetMV("MV_RELACNT")) // fulano@ig.com.br
Private cPass    := Trim(GetMV("MV_RELPSW"))  // 123abc

Private cDe      := "sistemas@cieesp.org.br"    //Space(200)
Private cPara    := "cristiano@cieesp.org.br"   //Space(200)
//Private cCc      := Space(200)
Private cAssunto := "Acesso ao Sistema BDI"     //Space(200)
//Private cAnexo   := Space(200)
Private cMsg     := "Usuario " + cUserName + " Acessou o Sistema de Gestao de Contatos"

If Empty(cServer) .And. Empty(cEmail) .And. Empty(cPass)
   MsgAlert("Nใo foi definido os parโmetros do server do Protheus para envio de e-mail",cTitulo)
   Return
Endif

/*
DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 350,570 OF oDlg PIXEL

@  3,3 SAY "De"   SIZE 30,7 PIXEL OF oDlg
@ 15,3 SAY "Para" SIZE 30,7 PIXEL OF oDlg
@ 27,3 SAY "Cc"       SIZE 30,7 PIXEL OF oDlg
@ 39,3 SAY "Assunto"  SIZE 30,7 PIXEL OF oDlg
@ 51,3 SAY "Anexo"    SIZE 30,7 PIXEL OF oDlg
@ 63,3 SAY "Mensagem" SIZE 30,7 PIXEL OF oDlg

@  2, 35 MSGET cDe      PICTURE "@" SIZE 248, 7 PIXEL OF oDlg
@ 14, 35 MSGET cPara    PICTURE "@" SIZE 248, 7 PIXEL OF oDlg
@ 26, 35 MSGET cCc      PICTURE "@" SIZE 248, 8 PIXEL OF oDlg
@ 38, 35 MSGET cAssunto PICTURE "@" SIZE 248, 8 PIXEL OF oDlg
@ 50, 35 MSGET cAnexo   PICTURE "@" SIZE 233, 8 PIXEL OF oDlg
@ 49,269 BUTTON "..." SIZE 13,11 PIXEL OF oDlg ACTION cAnexo:=AllTrim(cGetFile(cMask,"Inserir anexo"))
@ 62, 35 GET oMsg VAR cMsg MEMO SIZE 248,93 PIXEL OF oDlg 

@ 160,210 BUTTON "&Enviar"    SIZE 36,13 PIXEL ACTION (lOpc:=Validar(),Iif(lOpc,Eval({||Enviar(),oDlg:End()}),NIL))
@ 160,248 BUTTON "&Abandonar" SIZE 36,13 PIXEL ACTION oDlg:End()

ACTIVATE MSDIALOG oDlg CENTERED
*/

Enviar()

RETURN

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | EMail.prw            | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - Validar()                                              |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Funcao para criticar os campos obrigat๓rios para preenchimento  |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////

/*
STATIC FUNCTION Validar()
Local lRet := .T.
If Empty(cDe)
   MsgInfo("Campo 'De' preenchimento obrigat๓rio",cTitulo)
   lRet:=.F.
Endif
If Empty(cPara) .And. lRet
   MsgInfo("Campo 'Para' preenchimento obrigat๓rio",cTitulo)
   lRet:=.F.
Endif
If Empty(cAssunto) .And. lRet
   MsgInfo("Campo 'Assunto' preenchimento obrigat๓rio",cTitulo)
   lRet:=.F.
Endif

If lRet
   cDe      := AllTrim(cDe)
   cPara    := AllTrim(cPara)
   cCC      := AllTrim(cCC)
   cAssunto := AllTrim(cAssunto)
   cAnexo   := AllTrim(cAnexo)
Endif

RETURN(lRet)
*/

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | EMail.prw            | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - Enviar()                                               |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Funcao que critica e envia o e-mail                             |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////

STATIC FUNCTION Enviar()
Local lResulConn := .T.
Local lResulSend := .T.
Local cError := ""

CONNECT SMTP SERVER cServer ACCOUNT cEmail PASSWORD cPass RESULT lResulConn

If !lResulConn
   GET MAIL ERROR cError
   MsgAlert("Falha na conexใo "+cError)
   Return(.F.)
Endif

// Sintaxe: SEND MAIL FROM cDe TO cPara CC cCc SUBJECT cAssunto BODY cMsg ATTACHMENT cAnexo RESULT lResulSend
// Todos os e-mail terใo: De, Para, Assunto e Mensagem, por้m precisa analisar se tem: Com C๓pia e/ou Anexo

SEND MAIL FROM cDe TO cPara SUBJECT cAssunto BODY cMsg RESULT lResulSend

/*
If Empty(cCc) .And. Empty(cAnexo)
   SEND MAIL FROM cDe TO cPara SUBJECT cAssunto BODY cMsg RESULT lResulSend
Else
   If Empty(cCc) .And. !Empty(cAnexo)
      SEND MAIL FROM cDe TO cPara SUBJECT cAssunto BODY cMsg ATTACHMENT cAnexo RESULT lResulSend   
   Else
      SEND MAIL FROM cDe TO cPara CC cCc SUBJECT cAssunto BODY cMsg RESULT lResulSend   
   Endif
Endif
*/
   
If !lResulSend
   GET MAIL ERROR cError
   MsgAlert("Falha no Envio do e-mail " + cError)
Endif

DISCONNECT SMTP SERVER

RETURN(.T.)