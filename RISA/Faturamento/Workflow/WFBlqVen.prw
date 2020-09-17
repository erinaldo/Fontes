#include "PROTHEUS.CH"
#include "TOTVS.CH"
#include "AP5MAIL.CH"
#include "rwmake.ch"
#DEFINE ENTER CHR(13)+CHR(10)

/*/

{Protheus.doc} WFBlqVen
                 
Workflow

@author  Milton J.dos Santos	
@since   15/07/20
@version 1.0

/*/

User Function WFBlqVen()
Local aArea     := GetArea()
Local cGerente  := ""
Local cVendedor := M->C5_VEND1
Local lEnviado  := .F.
        
DBSelectArea("SA3")
DbSetOrder(1)
If DBSeek( xFilial("SA3") + cVendedor )
   If .not. Empty( SA3->A3_GEREN )
      cGerente := SA3->A3_GEREN
      If DBSeek( xFilial("SA3") + cGerente )
         lEnviado := u_xemail()
      Endif
   Else
      MsgAlert("Gerente nao definido !")
   EndIf
Else
   MsgStop("Vendedor invalido")
Endif
RestArea(aArea)
Return(lEnviado)

User Function XEMail()
Local aArea     := GetArea()
Local sMoeda	 := MV_SIMB1
Local lRet      := .F.
Local cNomCli 	 := ""
Local cDtPed    := ""
Local cCondPG   := ""
Local cNomVen	 := ""
Local x         := 0

Private cTitulo  := "Criar e-mail"
Private cServer  := GetMV("MV_RELSERV") 
Private cEmail   := GetMV("MV_RELACNT") 
Private cPass    := GetMV("MV_RELPSW")    
Private lAuth    := GetMv("MV_RELAUTH")
Private cDe      := Lower( ALLTRIM(cEmail))
Private cPara    := ""
Private cCc      := Space(200)
Private cAssunto := ""
Private cAnexo   := Space(200)
Private cMsg     := ""
Private aDados   := {}
Private aDadosG  := {}
Private nValTot  := 0


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Leds utilizados para as legendas das rotinas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Private oGreen   	:= LoadBitmap( GetResources(), "BR_VERDE")
Private oRed    	:= LoadBitmap( GetResources(), "BR_VERMELHO")
//Private oBlack	:= LoadBitmap( GetResources(), "BR_PRETO")
//Private oYellow	:= LoadBitmap( GetResources(), "BR_AMARELO")
//Private oBrown	:= LoadBitmap( GetResources(), "BR_MARROM")
Private oBlue		:= LoadBitmap( GetResources(), "BR_AZUL")
//Private oOrange	:= LoadBitmap( GetResources(), "BR_LARANJA")
//Private oViolet	:= LoadBitmap( GetResources(), "BR_VIOLETA")
//Private oPink		:= LoadBitmap( GetResources(), "BR_PINK")
//Private oGray		:= LoadBitmap( GetResources(), "BR_CINZA")

DBSelectArea("SA3")
cPara     := Lower( ALLTRIM(SA3->A3_EMAIL )) 
DBSelectArea("SC5")
cAssunto  := "Solicitação de Aprovação de Pedido Nº " + AllTrim(SC5->C5_NUM)
cNomCli 	 := AllTrim(SC5->C5_CLIENTE + " - " + POSICIONE('SA1', 1, xFilial('SA1') + SC5->C5_CLIENTE, 'A1_NOME')) // Código e Nome do Cliente
cDtPed    := DtoC(SC5->C5_EMISSAO) // Data do Pedido
cCondPG   := AllTrim(SC5->C5_CONDPAG + " - " + POSICIONE('SE4', 1, xFilial('SE4') + SC5->C5_CONDPAG, 'E4_DESCRI')) // Código e Descrição da condição de Pagamento 
cNomVen	 := AllTrim(SC5->C5_VEND1 + " - " + POSICIONE('SA3', 1, xFilial('SA3') + SC5->C5_VEND1, 'A3_NOME')) // Código e Nome do Vendedor 

If Empty(cServer) .And. Empty(cEmail) .And. Empty(cPass)
	MsgInfo("Faltou os parâmetros cServer, cEmail e cPass")
   Return(lRet)
Endif

cMsg := '<html>' + ENTER
cMsg += '<head>' + ENTER
cMsg += '<title> S O L I C I T A Ç Ã O  D E  A P R O V A Ç Ã O </title>' + ENTER
/*        '    #pedido{'+;
        '        width: 100%;'+;
        '        height: 100%;'+;
        '        border-width: 2px;'+;
        '        border-color: #C0C0C0;'+;
        '        border-style: solid;'+;
        '        display: inline-block;'+;
        '        border-radius: 20px;'+;
        '    }'+;*/

cMsg += '<style type="text/css">'+;
        '    table{'+;
        '        position:absolute;'+;
        '        top: 7.5%;'+;
        '        left: 5%;'+;
        '        text-align: center;'+;
        '        font-family: Arial, Helvetica, sans-serif;'+;
        '        width: 100%;'+;
        '        border-collapse: collapse;'+;
        '    }'+;
        '    tr{'+;
        '        border:1px black solid;'+;
        '    }'+;
        '    #impar{'+;
        '        background: #FFF;'+;
        '    }'+;
        '    #par{'+;
        '        background: #EEE;'+;
        '    }'+;
        '    td{'+;
        '        border:1px black solid;'+;
        '    }'+;
        '    #centro{'+;
        '        border-color: #C0C0C0;'+;
        '        border-style: solid;'+;
        '        background-color: #FFFFFF;'+;
        '    }'+;
        '</style>' + ENTER
cMsg += '</head>' + ENTER
cMsg += '<body>' + ENTER
cMsg += '<p><b><font size="3" face="Arial">Solicitação de aprovação do pedido Nº ' + AllTrim(SC5->C5_NUM) + '</font></b></p><br><br><br><br><br><br>' + ENTER
cMsg += '<p><font size="2" face="Arial">Solicito a avaliação do pedido em destaque para aprovação do mesmo.</font></p><br><br>' + ENTER
//id="pedido"
cMsg += '<div>' + ENTER
cMsg += '<table>' + ENTER
cMsg += '<tbody>'+;
        '   <tr bgcolor="#838B8B">'+;
        '       <td><font color=#FFFFFF>Pedido</font></td>'+;
        '       <td colspan="2"><font color=#FFFFFF>Cliente</font></td>'+;
        '       <td colspan="3"><font color=#FFFFFF>Data do Pedido</font></td>'+;
        '       <td colspan="2"><font color=#FFFFFF>Condição de Pagamento</font></td>'+;
        '       <td colspan="6"><font color=#FFFFFF>Vendedor</font></td>'+;
        '       <td><font color=#FFFFFF>Total</font></td>'+;
        '   </tr>' + ENTER
cMsg += '<tr>'+;
            '<td>' + AllTrim(SC5->C5_NUM) + '</td>'+;
            '<td colspan="2">' + cNomCli + '</td>'+;
            '<td colspan="3">' + cDtPed + '</td>'+;
            '<td colspan="2">' + cCondPG + '</td>'+;
            '<td colspan="6">' + cNomVen + '</td>'+;
            '<td> [nValTot] </td>'+;
        '</tr>' + ENTER
cMsg += '<tr id="centro" >'+;
            '<td colspan="15"><B><font size="4" color=#5555FF><br>Detalhes do Pedido<br><br></font></B></td>'+;
        '</tr>' + ENTER
cMsg += '<tr bgcolor="#838B8B">'+;
            '<td rowspan="2"><font color=#FFFFFF>Status</font></td>'+;
            '<td colspan="2"><font color=#FFFFFF>Produto</font></td>'+;
            '<td rowspan="2"><font color=#FFFFFF>Qtde</font></td>'+;
            '<td rowspan="2"><font color=#FFFFFF>Preço Tabela</font></td>'+;
            '<td rowspan="2"><font color=#FFFFFF>Mínimo Aceitável</font></td>'+;
            '<td colspan="4"><font color=#FFFFFF>Valores Negociados</font></td>'+;
            '<td colspan="2"><font color=#FFFFFF>Margem</font></td>'+;
            '<td colspan="3"><font color=#FFFFFF>Regra de Desconto</font></td>'+;
        '</tr>' + ENTER
cMsg += '<tr bgcolor="#838B8B">'+;
            '<td><font color=#FFFFFF>Código</font></td>'+;
            '<td><font color=#FFFFFF>Descrição</font></td>'+;
            '<td><font color=#FFFFFF>Unitário</font></td>'+;
            '<td><font color=#FFFFFF>Total</font></td>'+;
            '<td><font color=#FFFFFF>Desconto</font></td>'+;
            '<td><font color=#FFFFFF>%</font></td>'+;
            '<td><font color=#FFFFFF>%</font></td>'+;
            '<td><font color=#FFFFFF>R$</font></td>'+;
            '<td><font color=#FFFFFF>Mínimo</font></td>'+;
            '<td><font color=#FFFFFF>Máximo</font></td>'+;
            '<td><font color=#FFFFFF>Grupo Produto</font></td>'+;
        '</tr>' + ENTER
aDadosG := U_DADOSAPRO() // Busca dados do pedido para aprovação
aDados  := aDadosG[1]
nValTot := aDadosG[2]

//Preenche Tabela
For x := 1 to Len(aDados)

   
   cMsg += iif(Mod(x,2) == 0, '<tr id="par">', '<tr id="impar">')
   //For y:= 1 to 15
   //  cMsg += '<td width="10%"><font size="2" Color="#FFFFFF" face="Arial">' + iif(valtype(aDados[x,y]) == "C",aDados[x,y],str(aDados[x,y])) + '</font></td>'
   //Next
   //bgcolor="'+Iif(aDados[x,01]:CNAME=="BR_AZUL","#0000FF","#FF0000")+'"
   cMsg += '<td width="10%"><font size="2"><b>'+Iif(aDados[x,01]:CNAME=="BR_AZUL","","Bloqueado")+'</b></font></td>'
   cMsg += '<td width="10%"><font size="2">' + aDados[x,02] + '</font></td>'
   cMsg += '<td width="10%"><font size="2">' + aDados[x,03] + '</font></td>'
   cMsg += '<td width="10%"><font size="2">' + STR(aDados[x,04]) + '</font></td>'
   cMsg += '<td width="10%"><font size="2">' + aDados[x,05] + '</font></td>'
   cMsg += '<td width="10%"><font size="2">' + aDados[x,06] + '</font></td>'
   cMsg += '<td width="10%"><font size="2">' + aDados[x,07] + '</font></td>'
   cMsg += '<td width="10%"><font size="2">' + aDados[x,08] + '</font></td>'
   cMsg += '<td width="10%"><font size="2">' + aDados[x,09] + '</font></td>'
   cMsg += '<td width="10%"><font size="2">' + aDados[x,10] + '</font></td>'
   cMsg += '<td width="10%"><font size="2">' + aDados[x,11] + '</font></td>'
   cMsg += '<td width="10%"><font size="2">' + aDados[x,12] + '</font></td>'
   cMsg += '<td width="10%"><font size="2">' + aDados[x,13] + '</font></td>'
   cMsg += '<td width="10%"><font size="2">' + aDados[x,14] + '</font></td>'
   cMsg += '<td width="10%"><font size="2">' + aDados[x,15] + '</font></td>'
   cMsg += '</tr>' + ENTER

Next

//Fecha Tabela
cMsg += '</tbody>'+;
        '    </table>'+;
        ' </div>'+ ENTER

cMsg += '</body>' + ENTER
cMsg += '</html>' + ENTER


cMsg := STRTRAN(cMsg, "[nValTot]", sMoeda+" "+AllTrim(TRANSFORM(nValTot, "@E 999,999.99")))

If Validar()
   //GPEMail(cAssunto,cMsg,cPara,aArquivos) padrão nutella
   lRet := Enviar() // padrão raiz
EndIf
RestArea(aArea)

Return(lRet)

STATIC FUNCTION Validar()
Local aArea     := GetArea()
Local lRet := .T.
If Empty(cDe)
   MsgInfo("Campo 'De' preenchimento obrigatório",cTitulo)
   lRet:=.F.
Endif
If Empty(cPara) .And. lRet
   MsgInfo("Campo 'Para' preenchimento obrigatório",cTitulo)
   lRet:=.F.
Endif
If Empty(cAssunto) .And. lRet
   MsgInfo("Campo 'Assunto' preenchimento obrigatório",cTitulo)
   lRet:=.F.
Endif

If lRet
   cDe      := AllTrim(cDe)
   cPara    := AllTrim(cPara)
   cCC      := AllTrim(cCC)
   cAssunto := AllTrim(cAssunto)
   cAnexo   := AllTrim(cAnexo)
Endif
RestArea(aArea)

RETURN(lRet)

STATIC FUNCTION Enviar()
Local aArea     := GetArea()
Local lResulConn := .T.
Local lResulSend := .T.
Local lRet       := .F.
Local cError     := ""

CONNECT SMTP SERVER cServer ACCOUNT cEmail PASSWORD cPass RESULT lResulConn

If !lResulConn
   GET MAIL ERROR cError
   MsgAlert("Falha na conexão "+cError)
   Return(lRet)
Endif

If lAuth
   lAuth := MailAuth(cEmail,cPass)
   If !lAuth
	   ApMsgInfo("Autenticação FALHOU","Protheus")
      Return(lRet)
   Endif
Endif

If Empty(cCc) .And. Empty(cAnexo)
   SEND MAIL FROM cDe TO cPara SUBJECT cAssunto BODY cMsg FORMAT TEXT RESULT lResulSend
Else
   If Empty(cCc) .And. !Empty(cAnexo)
      SEND MAIL FROM cDe TO cPara SUBJECT cAssunto BODY cMsg FORMAT TEXT ATTACHMENT cAnexo RESULT lResulSend   
   Else
      SEND MAIL FROM cDe TO cPara CC cCc SUBJECT cAssunto BODY cMsg FORMAT TEXT RESULT lResulSend   
   Endif
Endif
   
If !lResulSend
   GET MAIL ERROR cError
   MsgAlert("Falha no Envio do e-mail " + cError)
Else
   lRet := .T.
Endif

DISCONNECT SMTP SERVER
RestArea(aArea)

RETURN(lRet)
