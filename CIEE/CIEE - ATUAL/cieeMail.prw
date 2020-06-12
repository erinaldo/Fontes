#INCLUDE "PROTHEUS.CH"
#INCLUDE "AP5MAIL.CH"

User Function cieeMail(_cAnx)

Local oDlg     := NIL
Local cMask    := "Todos os arquivos (*.*) |*.*|"
Local oMsg

Private cTitulo  := "Criar e-mail"
Private cServer  := Trim(GetMV("MV_RELSERV")) // smtp
Private cEmail   := "wfmicrosiga@cieesp.org.br"
Private cPass    := "microsiga"

Private cDe      := Space(200)
Private cPara    := Space(200)
Private cCc      := Space(200)
Private cAssunto := Space(200)
Private cAnexo   := _cAnx//Space(200)
Private cMsg     := ""
/*
If Empty(cServer) .And. Empty(cEmail) .And. Empty(cPass)
   MsgAlert("N�o foi definido os par�metros do server do Protheus para envio de e-mail",cTitulo)
   Return
Endif

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
//|           | Funcao para criticar os campos obrigat�rios para preenchimento  |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
STATIC FUNCTION Validar()
Local lRet := .T.
If Empty(cDe)
   MsgInfo("Campo 'De' preenchimento obrigat�rio",cTitulo)
   lRet:=.F.
Endif
If Empty(cPara) .And. lRet
   MsgInfo("Campo 'Para' preenchimento obrigat�rio",cTitulo)
   lRet:=.F.
Endif
If Empty(cAssunto) .And. lRet
   MsgInfo("Campo 'Assunto' preenchimento obrigat�rio",cTitulo)
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

cDe      := cEmail
cPara    := GetMv("CI_ROMNF") //"assuntosfiscais@cieesp.org.br;almoxarifado@cieesp.org.br"
cCc  	 := "sistemas@cieesp.org.br;"
cAssunto := "Erro no processamento dos Romaneios"
cAnexo   := _cAnx//Space(200)
cMsg     := "A Rela��o de Pedidos constante no arquivo LOG dever� ser analisada e Reprocessada via ROMANEIO."

CONNECT SMTP SERVER cServer ACCOUNT cEmail PASSWORD cPass RESULT lResulConn

If !lResulConn
   GET MAIL ERROR cError
   MsgAlert("Falha na conex�o "+cError)
   Return(.F.)
Endif

// Sintaxe: SEND MAIL FROM cDe TO cPara CC cCc SUBJECT cAssunto BODY cMsg ATTACHMENT cAnexo RESULT lResulSend
// Todos os e-mail ter�o: De, Para, Assunto e Mensagem, por�m precisa analisar se tem: Com C�pia e/ou Anexo

If Empty(cCc) .And. Empty(cAnexo)
   SEND MAIL FROM cDe TO cPara SUBJECT cAssunto BODY cMsg RESULT lResulSend
Else
   If Empty(cCc) .And. !Empty(cAnexo)
      SEND MAIL FROM cDe TO cPara SUBJECT cAssunto BODY cMsg ATTACHMENT cAnexo RESULT lResulSend   
   Else
      SEND MAIL FROM cDe TO cPara CC cCc SUBJECT cAssunto BODY cMsg ATTACHMENT cAnexo RESULT lResulSend   
   Endif
Endif
   
If !lResulSend
   GET MAIL ERROR cError
   MsgAlert("Falha no Envio do e-mail " + cError)
Endif

DISCONNECT SMTP SERVER

RETURN(.T.)