#INCLUDE "rwmake.ch"
#include "_FixSX.ch"

#include "Topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#include "fileio.ch"
#include "Protheus.ch"


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CPRJA01   � Autor � Cristiano          � Data �  07/03/08   ���
�������������������������������������������������������������������������͹��
���Descricao � Controle das Solicitacaoes de Servico Informatica - SSI    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus8                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CPRJA01()
              
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cArq,cInd,cPerg
Local aStru

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
Private aPags := {}
Private aRotina   := { 	{"Pesquisar"	,"AxPesqui"    											, 0 , 1},;
					 {"Visualizar"		,"AxVisual"    											, 0 , 2},;
					 {"Incluir"    		,'AxInclui("SZP",Recno(),3,,,,"U_SZPOK()",,)'			, 0 , 3},;	// {"Incluir"    		,'AxInclui("SZP",Recno(),3,,,,"U_SZPOK()",,"u_SZPPOS")'	, 0 , 3},;				
					 {"Alterar"    		,"U_ALTSSI"												, 0 , 4},;
					 {"Cancelar"   		,"U_CANCEL"												, 0 , 4},;
					 {"Baixar"     		,"U_BAIXA_SSI"											, 0 , 6},;
					 {"Alocar"     		,"U_VALSSI"												, 0 , 6},;
					 {"Hist.Aceite"		,"U_HISTSSI"											, 0 , 6},;
					 {"Visualiza SSI"	,"U_OPENSSI" 											, 0 , 6},;				
					 {"Legenda"    		,'BrwLegenda(cCadastro,"Legenda",{{"BR_VERMELHO","Nao Aprovada"},{"BR_LARANJA","Nao Alocada"},{"BR_VERDE","Pendente"},{"BR_AMARELO","Oficializado"},{"BR_AZUL","Aceite"},{"BR_BRANCO","Arquivado"},{"BR_CANCEL","Cancelado"}})',0 , 7 }}


//AxCadastro(cString, "Contas de Consumo", cVldAlt, cVldExc)

cCadastro := "Controle Solicitacao de Servico Informatica - SSI"
aCores    := {}

//{"Excluir"    ,"U_EXCL"    , 0 , 5},;

Aadd( aCores, { "Empty(ZP_CONCLUS) .and. ZP_CANCEL == '2' .and. Empty(ZP_ACEITE) .and. ZP_APROV == 'N' .and. ZP_ALOC == 'N' ", "BR_VERMELHO"	} )
Aadd( aCores, { "Empty(ZP_CONCLUS) .and. ZP_CANCEL == '2' .and. Empty(ZP_ACEITE) .and. ZP_APROV == 'S' .and. ZP_ALOC == 'N' ", "BR_LARANJA" 	} )
Aadd( aCores, { "Empty(ZP_CONCLUS) .and. ZP_CANCEL == '2' .and. Empty(ZP_ACEITE) .and. ZP_APROV == 'S' .and. ZP_ALOC == 'S' ", "BR_VERDE"  		} )
Aadd( aCores, { "!Empty(ZP_CONCLUS) .and. Empty(ZP_ACEITE)"								, "BR_AMARELO" 	} )
Aadd( aCores, { "!Empty(ZP_CONCLUS) .and. !Empty(ZP_ACEITE) .and. ZP_ARQUIVO == '2'"	, "BR_AZUL"		} )
Aadd( aCores, { "!Empty(ZP_CONCLUS) .and. !Empty(ZP_ACEITE) .and. ZP_ARQUIVO == '1'"	, "BR_BRANCO"	} )
Aadd( aCores, { "ZP_CANCEL == '1'"												   		, "BR_CANCEL"	} )

//������������������������������������������������������������������������Ŀ
//�Realiza a Filtragem                                                     �
//��������������������������������������������������������������������������

dbSelectArea("SZP")
dbSetOrder(1)

mBrowse( 6,1,22,75,"SZP",,,,,2, aCores)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Baixa_SSI � Autor � Cristiano          � Data �  07/03/08   ���
�������������������������������������������������������������������������͹��
���Descricao � Baixa SSI Pendente (Concluidas).                           ���
���          � Preenche ZP_CONCLUS no Programa CPRJA01.                   ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus8                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function BAIXA_SSI()

Local aArea := GetArea() //, aPags := {}
Local oOk   := LoadBitmap( GetResources(), "LBOK" )
Local oNo   := LoadBitmap( GetResources(), "LBNO" )

Private cPerg  := "PROJA1    "
Private _lRetp

lRet        := .F.
aPags       := {}

_fCriaSX1() // Verifica as perguntas e cria caso seja necessario

//��������������������������������������������������������Ŀ
//� mv_par01 - Data Emissao de                             �
//� mv_par02 - Data Emissao ate                            �
//� mv_par03 - Numero SSI   de                             �
//� mv_par04 - Numero SSI   ate                            �
//� mv_par05 - CR           de                             �
//� mv_par06 - CR           ate                            �
//����������������������������������������������������������

If !Pergunte(cPerg, .T.)
	Return
EndIf               

_xFilSZP:=xFilial("SZP")

_cOrdem := " ZP_FILIAL, ZP_NRSSI "
_cQuery := " SELECT * "
_cQuery += " FROM "
_cQuery += RetSqlName("SZP")+" SZP"
_cQuery += " WHERE '"+ _xFilSZP +"' = ZP_FILIAL"
_cQuery += " AND    SZP.D_E_L_E_T_ <> '*'"
_cQuery += " AND    ZP_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
_cQuery += " AND    ZP_NRSSI BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
_cQuery += " AND    ZP_CR BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
_cQuery += " AND    (ZP_CONCLUS = '' OR ZP_ACEITE = '' OR ZP_ARQUIVO = '2')"
_cQuery += " AND    ZP_CANCEL = '2'"
_cQuery += " AND    ZP_APROV = 'S' AND ZP_ALOC = 'S' " //so pode baixa quando estiver aprovado e alocado

U_EndQuery( @_cQuery,_cOrdem, "SZPTMP", {"SZP"},,,.T. )

dbSelectArea("SZPTMP")
dbGoTop()

While !Eof()
	("SZP")->(DbSeek(xFilial("SZP")+SZPTMP->ZP_NRSSI))
	aAdd(aPags,{.F.,SZPTMP->ZP_NRSSI,SZPTMP->ZP_EMISSAO,SZPTMP->ZP_CR,SZPTMP->ZP_CRDESCR,Left(SZP->ZP_SERVICO,40),SZPTMP->ZP_ANALIST,SZPTMP->R_E_C_N_O_})
	DbSkip()
Enddo

dbSelectArea("SZPTMP")
DbCloseArea()

If Len(aPags) > 0
	
	DEFINE MSDIALOG oDlg FROM  31,58 TO 300,778 TITLE "Escolha qual Solicitacao quer baixar " PIXEL
	@ 05,05 LISTBOX oLbx1 FIELDS HEADER "","Numero","Emissao","CR","Descricao","Servico","Analista" SIZE 345, 85 OF oDlg PIXEL ;
	ON DBLCLICK (U_MARK_SSI())
	oLbx1:SetArray(aPags)
	oLbx1:bLine := { || {If(aPags[oLbx1:nAt,1],oOk,oNo),aPags[oLbx1:nAt,2],aPags[oLbx1:nAt,3],aPags[oLbx1:nAt,4],aPags[oLbx1:nAt,5],aPags[oLbx1:nAt,6],aPags[oLbx1:nAt,7] } }
	oLbx1:nFreeze  := 1
	
	DEFINE SBUTTON FROM 104, 236 TYPE 17 ENABLE OF oDlg ACTION U_MarcaSZP() // BOTAO FILTRO
	DEFINE SBUTTON FROM 104, 264 TYPE 11 ENABLE OF oDlg ACTION (U_EditaSZP(),oDlg:End()) // BOTAO EDITA
	DEFINE SBUTTON FROM 104, 292 TYPE 2  ENABLE OF oDlg ACTION (lRet :=.F.,oDlg:End()) // BOTAO CANCELAR
	ACTIVATE MSDIALOG oDlg CENTERED
Else
	MsgInfo("N�o foi localizada a SSI!!!","Aten��o")
Endif

RestArea(aArea)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MARK_SSI  �Autor  �Cristiano           � Data �  25/03/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para Selecionar o MarkBorwse                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus 8                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MARK_SSI()

//������������������������������������������������������������������������Ŀ
//�Inverte a marca do ListBox.                                             �
//��������������������������������������������������������������������������

If  aPags[oLbx1:nAt,1]
	aPags[oLbx1:nAt,1] := .F.
Else
	aPags[oLbx1:nAt,1] := .T.
EndIf

//������������������������������������������������������������������������Ŀ
//�Atualiza os objetos.                                                    �
//��������������������������������������������������������������������������

oLbx1:Refresh(.T.)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SZPTudOK  �Autor  �Cristiano           � Data �  25/03/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para Validacoes no Momento de Acionar o Botao OK    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus 8                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function SZPTudOK()

Local _aArea := GetArea()
Local _cRet  := .T.    

//If ProcName(9) <> "U_VALSSI"
If ProcName(11) <> "U_VALSSI"
	If Empty(M->ZP_CONCLUS) .AND. M->ZP_CANCEL == '2'
		MsgAlert(OemToAnsi("Data de Conclus�o Obrigat�ria!!!"))
		Return(.F.)
	EndIf
Else
	If M->ZP_CODANAL == "99" //Sistemas
		MsgAlert(OemToAnsi("N�o pode alocar para Grupo SISTEMAS!!!"))
		Return(.F.)
	EndIf

	If Empty(M->ZP_PREVINI)
		MsgAlert(OemToAnsi("Data Prevista inicial Obrigatoria!!!"))
		Return(.F.)
	EndIf

	If Empty(M->ZP_DTPREV)
		MsgAlert(OemToAnsi("Data Prevista fim Obrigatoria!!!"))
		Return(.F.)
	EndIf

EndIf

If M->ZP_ARQUIVO == '1'
	If Empty(M->ZP_ACEITE)
		MsgAlert(OemToAnsi("N�o � poss�vel Arquivar sem a Data de Aceite do Usu�rio!!!"))
		Return(.F.)
	EndIf
EndIf     

If M->ZP_CANCEL == '1' .AND. Empty(M->ZP_MOTIVO)
	MsgAlert(OemToAnsi("Motivo do Cancelamento Obrigat�rio!!!"))
	Return(.F.)
EndIf

RestArea(_aArea)
Return(_cRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SZPOK     �Autor  �Cristiano           � Data �  25/03/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para Validar a Inclusao                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus 8                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function SZPOK()

Local _aArea := GetArea()
Local _cRet  := .T.

RestArea(_aArea)

Return(_cRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SZPPOS    �Autor  �Fabio Zanchim       � Data �  10/2013    ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao pos grava��o do AxInclui                            ���
���          � Envia email de inclusao da SSI.                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus 11                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function SZPPOS()

Local oProcess,oHtml
Local _cTpIdent:=''
Local _cCC:=GetMv('CI_MAILSSI')//Fabio - novo parametro
Local _cAssunto  	:= OemToAnsi("SSI - "+SZP->ZP_NRSSI +" foi inclu�da!")
		
oProcess:= TWFProcess():New("000002", "Workflow Entrada de SSI")
oProcess:NewTask( "Workflow Controle SSI", "\Workflow\WFSSI.htm")
oProcess:NewVersion(.T.)
oProcess:cSubject	:= _cAssunto
oProcess:cTo  		:= SZP->ZP_EMAIL1+';'+SZP->ZP_EMAIL2
oProcess:cCc  		:= Alltrim(_cCC)
oProcess:bReturn	:= NIL
oProcess:cBody  	:= OemToAnsi("Solicita��o "+SZP->ZP_NRSSI+" inclu�da!") +CRLF
oProcess:cBody 		+= OemToAnsi("Esta � uma mensagem autom�tica. Por favor, n�o responda!!!") 

oHtml  		:= oProcess:oHTML
oHtml:ValByName("numssi"	, SZP->ZP_NRSSI			)
oHtml:ValByName("solic"		, SZP->ZP_SOLICIT		)
oHtml:ValByName("cr"		, SZP->ZP_CR			)
oHtml:ValByName("data"		, DTOC(SZP->ZP_EMISSAO)	)

AAdd( (oHtml:ValByName( "t.1"     )), ALLTRIM(SZP->ZP_DESCSIS))
_cTpIdent	:= "Em Branco"
Do Case
	Case SZP->ZP_TPIDENT == "1"
		_cTpIdent	:= "Alteracao"
	Case SZP->ZP_TPIDENT == "2"
		_cTpIdent	:= "Desenvolvimento"
	Case SZP->ZP_TPIDENT == "3"
		_cTpIdent	:= "Emergencial"
EndCase
AAdd( (oHtml:ValByName( "t.2"     )), ALLTRIM(_cTpIdent))
AAdd( (oHtml:ValByName( "t.3"     )), ALLTRIM(SZP->ZP_SERVICO))

oProcess:Start()
oProcess:Free()
	
Return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MarcaSZP  �Autor  �Cristiano           � Data �  25/03/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para Validar o MarkBrowse                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus 8                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MarcaSZP

For _nI:=1 to Len(aPags)
	If aPags[_nI,1]
		aPags[_nI,1] := .F.
	Else
		aPags[_nI,1] := .T.
	EndIf
Next _nI

oLbx1:Refresh(.T.)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CANCEL    �Autor  �Cristiano           � Data �  25/03/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para Validar o Cancelamento da SSI                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus 8                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CANCEL()

Private aAcho  := {}
Private aCpos  := {}

If SZP->ZP_CANCEL == "1" //1-Cancelado SIM
	MsgAlert(OemToAnsi("Solicita��o j� cancelada!"))
	Return()
ElseIf !Empty(SZP->ZP_CONCLUS)
	MsgAlert(OemToAnsi("Solicita��o j� Baixada!"))
	Return()
EndIf

AADD(aCpos,"ZP_MOTIVO")

Reclock("SZP",.F.)
SZP->ZP_CANCEL := "1"
MsUnLock()

//_xAlt := AxAltera("SZP",Recno(),4,,,,,"U_SZPTudOK()")
_xAlt := AxAltera("SZP",Recno(),4,,aCpos,,,"U_SZPTudOK()")	

If _xAlt <> 1
	Reclock("SZP",.F.)
	SZP->ZP_CANCEL := "2"
	MsUnLock()
EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EXCL      �Autor  �Cristiano           � Data �  25/03/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para Validar Exclusao da SSI                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus 8                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function EXCL()

If SZP->ZP_CANCEL == "1" //1-Cancelado SIM
	MsgAlert(OemToAnsi("Solicita��o j� cancelada!"))
	Return()
ElseIf !Empty(SZP->ZP_CONCLUS)
	MsgAlert(OemToAnsi("Solicita��o j� Baixada!"))
	Return()
EndIf

AxDeleta

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EDITASZP  �Autor  �Cristiano           � Data �  25/03/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para Editar a SSI para Baixa                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus 8                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function EDITASZP()

Private aAcho  := {}
Private aCpos  := {}

_cEOL     	:= CHR(13) + CHR(10)

AADD(aCpos,"ZP_CODANAL")
AADD(aCpos,"ZP_CONCLUS")
AADD(aCpos,"ZP_ACEITE")
AADD(aCpos,"ZP_ARQUIVO")

_nTam  := len(aPags)
_nCont := 1            

DbSelectArea("SZP")

While _nCont <= _nTam  // Vai tratar para todos os itens do Acols marcados
	If aPags[_nCont,1]
		DbGoto(aPags[_nCont,08])
		_xAlt	:= AxAltera("SZP",Recno(),4,aAcho,aCpos,,,"U_SZPTudOK()")	
/*
		//e-mail Conclusao
		If 	_xAlt == 1
			If !Empty(SZP->ZP_CONCLUS) .and. Empty(SZP->ZP_ACEITE) .and. SZP->ZP_ARQUIVO == "2"

				_cAssunto  	:= OemToAnsi("SSI - "+SZP->ZP_NRSSI +" Conclu�da !!!")
		
				oProcess:= TWFProcess():New("000002", "Workflow Reserva Financeira")
				oProcess:NewTask( "Workflow Controle SSI", "\Workflow\WFSSIHOM.htm")
				oProcess:NewVersion(.T.)
				oProcess:cSubject	:= "Conclusao SSI"//_cAssunto
				oProcess:cTo  		:= SZP->ZP_EMAIL1+';'+SZP->ZP_EMAIL2
				oProcess:cCc  		:= 'sistemas@cieesp.org.br'
				oProcess:bReturn	:= "u_CPRJW01b(1,'"+_cAssunto+"','"+SZP->ZP_NRSSI+"')"
				oProcess:cBody  	:= OemToAnsi("Solicita��o "+SZP->ZP_NRSSI+" Conclu�da!!!") +_cEOL
				oProcess:cBody 		+= OemToAnsi("Esta � uma mensagem autom�tica. Por favor, n�o responda!!!") 

				oHtml  		:= oProcess:oHTML
				oHtml:ValByName("numssi"	, SZP->ZP_NRSSI			)
				oHtml:ValByName("dtconcl"	, DTOC(SZP->ZP_CONCLUS)	)

				AAdd( (oHtml:ValByName( "t.1"     )), ALLTRIM(SZP->ZP_DESCSIS))
				_cTpIdent := "Em Branco"
				Do Case
					Case SZP->ZP_TPIDENT == "1"
						_cTpIdent	:= "Alteracao"
					Case SZP->ZP_TPIDENT == "2"
						_cTpIdent	:= "Desenvolvimento"
					Case SZP->ZP_TPIDENT == "3"
						_cTpIdent	:= "Emergencial"
				EndCase

				AAdd( (oHtml:ValByName( "t.2"     )), ALLTRIM(_cTpIdent))
				AAdd( (oHtml:ValByName( "t.3"     )), ALLTRIM(SZP->ZP_SERVICO))

				oProcess:Start()
			EndIf
		EndIf
*/	EndIf
	_nCont++
EndDo

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SX1       �Autor  �Microsiga           � Data �  08/03/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Parametros da rotina                                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function _fCriaSX1()

aRegs     := {}
nSX1Order := SX1->(IndexOrd())

SX1->(dbSetOrder(1))

cPerg := Left(cPerg,10)

/*
     grupo ,ordem  ,pergunt                    ,perg spa,perg eng , variav ,tipo,tam,dec ,pres,gsc,valid ,var01 	  ,def01		,defspa01,defeng01,cnt01,var02,def02	,defspa02,defeng02,cnt02,var03,def03		,defspa03,defeng03,cnt03,var04,def04,defspa04,defeng04,cnt04,var05,def05,defspa05,defeng05,cnt05,f3   ,"","","",""
*/
aAdd(aRegs,{cPerg  ,"01" ,"Data Emissao de  ?  ","      ","       ","mv_ch1","D" ,08 ,00 ,0    ,"G",""   ,"mv_par01",""   		,""      ,""      ,""   ,""   ,""  		,""      ,""      ,""   ,""   ,""   		,""      ,""     ,""   ,""   ,""   		,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,"","","",""})
aAdd(aRegs,{cPerg  ,"02" ,"Data Emissao ate ?  ","      ","       ","mv_ch2","D" ,08 ,00 ,0    ,"G",""   ,"mv_par02",""   		,""      ,""      ,""   ,""   ,""  		,""      ,""      ,""   ,""   ,""   		,""      ,""     ,""   ,""   ,""   		,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,"","","",""})
aAdd(aRegs,{cPerg  ,"03" ,"Numero SSI de    ?  ","      ","       ","mv_ch3","C" ,06 ,00 ,0    ,"G",""   ,"mv_par03",""   		,""      ,""      ,""   ,""   ,""  		,""      ,""      ,""   ,""   ,""   		,""      ,""     ,""   ,""   ,""   		,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,"","","",""})
aAdd(aRegs,{cPerg  ,"04" ,"Numero SSI ate   ?  ","      ","       ","mv_ch4","C" ,06 ,00 ,0    ,"G",""   ,"mv_par04",""   		,""      ,""      ,""   ,""   ,""  		,""      ,""      ,""   ,""   ,""   		,""      ,""     ,""   ,""   ,""   		,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,"","","",""})
aAdd(aRegs,{cPerg  ,"05" ,"CR de            ?  ","      ","       ","mv_ch5","C" ,05 ,00 ,0    ,"G",""   ,"mv_par05",""  			,""      ,""      ,""   ,""   ,""  		,""      ,""      ,""   ,""   ,""   		,""      ,""     ,""   ,""   ,""   		,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,"CTT","","","",""})
aAdd(aRegs,{cPerg  ,"06" ,"CR ate           ?  ","      ","       ","mv_ch6","C" ,05 ,00 ,0    ,"G",""   ,"mv_par06",""   		,""      ,""      ,""   ,""   ,""		,""      ,""      ,""   ,""   ,""   		,""      ,""     ,""   ,""   ,""   		,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,"CTT","","","",""})

For nX := 1 to Len(aRegs)
	If !SX1->(dbSeek(cPerg+aRegs[nX,2]))
		RecLock('SX1',.T.)
		For nY:=1 to FCount()
			If nY <= Len(aRegs[nX])
				SX1->(FieldPut(nY,aRegs[nX,nY]))
			Endif
		Next nY
		MsUnlock()
	Endif
Next nX

SX1->(dbSetOrder(nSX1Order))

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CPRJA01   �Autor  �Microsiga           � Data �  08/26/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ALTSSI()

Private aCpos  := {}

If !Empty(SZP->ZP_CONCLUS)
	MsgBox("Nao pode alterar SSI Concluida","Alerta")
ElseIf SZP->ZP_CANCEL == "1"
	MsgBox("Nao pode alterar SSI Cancelada","Alerta")
ElseIf SZP->ZP_APROV == "N"
	MsgBox("Nao pode alterar SSI sem Aprova��o","Alerta")
ElseIf SZP->ZP_ALOC == "N"
	MsgBox("Nao pode alterar SSI sem Aloca��o","Alerta")
Else
	AADD(aCpos,"ZP_CODANAL")
	AADD(aCpos,"ZP_DTPREV" )
	AADD(aCpos,"ZP_PREVINI")
	AxAltera("SZP",Recno(),4,,aCpos,,,)	
EndIf

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CPRJA01   �Autor  �Emerson Natali      � Data �  04/01/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Tela de Validacao. Utilizada pelo supervisor da Informatica���
���          �para validar o registro importados e aprovador              ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function VALSSI()

Private aCpos  := {}
Private oProcess

_cAssunto  	:= ""
_cEOL     	:= CHR(13) + CHR(10)

If !Empty(SZP->ZP_CONCLUS)
	MsgBox("Nao pode alterar SSI Concluida","Alerta")
ElseIf SZP->ZP_CANCEL == "1"
	MsgBox("Nao pode alterar SSI Cancelada","Alerta")
ElseIf SZP->ZP_APROV == "N"
	MsgBox("Nao pode alocar SSI sem Aprova��o","Alerta")
ElseIf SZP->ZP_ALOC == "S"
	MsgBox("SSI ja est� Alocado","Alerta")
Else
	AADD(aCpos,"ZP_CODANAL")
	AADD(aCpos,"ZP_TIPO" )
	AADD(aCpos,"ZP_DTPREV" )
	AADD(aCpos,"ZP_PREVINI")
	AADD(aCpos,"ZP_CANCEL")
	AADD(aCpos,"ZP_MOTIVO")
	AADD(aCpos,"ZP_SISTEMA")
	AADD(aCpos,"ZP_TPIDENT")
	AADD(aCpos,"ZP_GERENCI")
	AADD(aCpos,"ZP_SUPERIN")
	AADD(aCpos,"ZP_EMAIL1")
	AADD(aCpos,"ZP_EMAIL2")
	AADD(aCpos,"ZP_SOLICIT")

	_xAlt := AxAltera("SZP",Recno(),4,,aCpos,,,"U_SZPTudOK()")	

	If _xAlt == 1
		Reclock("SZP",.F.)
		SZP->ZP_ALOC   := "S"
		MsUnLock()

		_cAssunto  	:= OemToAnsi("SSI - "+SZP->ZP_NRSSI +" foi alocada !!!")
		
		oProcess:= TWFProcess():New("000002", "Workflow Reserva Financeira")
		oProcess:NewTask( "Workflow Controle SSI", "\Workflow\WFSSIALOC.htm")
		oProcess:NewVersion(.T.)
		oProcess:cSubject	:= _cAssunto
		oProcess:cTo  		:= SZP->ZP_EMAIL1+';'+SZP->ZP_EMAIL2
		oProcess:cCc  		:= 'sistemas@cieesp.org.br;mauricio@cieesp.org.br'
		oProcess:bReturn	:= NIL
		oProcess:cBody  	:= OemToAnsi("Solicita��o "+SZP->ZP_NRSSI+" ALOCADA!!!") +_cEOL
		oProcess:cBody 		+= OemToAnsi("Esta � uma mensagem autom�tica. Por favor, n�o responda!!!") 

		oHtml  		:= oProcess:oHTML
		oHtml:ValByName("numssi"	, SZP->ZP_NRSSI			)
		oHtml:ValByName("solic"		, SZP->ZP_SOLICIT		)
		oHtml:ValByName("cr"		, SZP->ZP_CR			)
		oHtml:ValByName("data"		, DTOC(SZP->ZP_EMISSAO)	)
		oHtml:ValByName("analist"	, SZP->ZP_ANALIST		)
		oHtml:ValByName("dtprevini"	, DTOC(SZP->ZP_PREVINI)	)
		oHtml:ValByName("dtprevfim"	, DTOC(SZP->ZP_DTPREV)	)

		AAdd( (oHtml:ValByName( "t.1"     )), ALLTRIM(SZP->ZP_DESCSIS))
		_cTpIdent	:= "Em Branco"
		Do Case
			Case SZP->ZP_TPIDENT == "1"
				_cTpIdent	:= "Alteracao"
			Case SZP->ZP_TPIDENT == "2"
				_cTpIdent	:= "Desenvolvimento"
			Case SZP->ZP_TPIDENT == "3"
				_cTpIdent	:= "Emergencial"
		EndCase

		AAdd( (oHtml:ValByName( "t.2"     )), ALLTRIM(_cTpIdent))
		AAdd( (oHtml:ValByName( "t.3"     )), ALLTRIM(SZP->ZP_SERVICO))

		oProcess:Start()
	
	EndIf
EndIf

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CPRJA01   �Autor  �Microsiga           � Data �  02/08/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Tela Historico                                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function HISTSSI()

Local aArea
Local oOk   		:= LoadBitmap( GetResources(), "LBOK" )
Local oNo   		:= LoadBitmap( GetResources(), "LBNO" )
Local aPags	  		:= {}

aArea		:= GetArea()

DbSelectArea("SZW")
DbSetOrder(1)
//If DbSeek(xFilial("SZW")+SZP->ZP_NRSSI)
If DbSeek(SZP->ZP_NRSSI)
	Do While !EOF() .and. SZW->ZW_NRSSI == SZP->ZP_NRSSI
		AADD(aPags,{SZW->ZW_CONCLUS, SZW->ZW_ACEITE, SZW->ZW_HISTOR, SZW->ZW_SEQ, SZW->ZW_NRSSI})
		SZW->(DbSkip())
	EndDo
EndIf

If Empty(aPags)
	Alert("SEM HISTORICO " + SZP->ZP_NRSSI)
	Return
EndIf

//aSort(aPags,,, { |x, y| x[2] < y[2] })


DEFINE MSDIALOG oDlg FROM  31,58 TO 300,778 TITLE "Historico Aceite " PIXEL
@ 05,05 LISTBOX oLbx1 FIELDS HEADER "Conclusao","Aceite","Historico","Seq","Nr SSI" SIZE 345, 85 OF oDlg PIXEL
oLbx1:SetArray(aPags)
oLbx1:bLine := { || {aPags[oLbx1:nAt,1],aPags[oLbx1:nAt,2],aPags[oLbx1:nAt,3],aPags[oLbx1:nAt,4],aPags[oLbx1:nAt,5] } }
	
DEFINE SBUTTON FROM 104, 292 TYPE 2  ENABLE OF oDlg ACTION oDlg:End() // BOTAO CANCELAR

ACTIVATE MSDIALOG oDlg CENTERED


/*
DEFINE MSDIALOG oDlg FROM  200, 001 to 455, 588 TITLE "Historico Aceite" PIXEL
@ 006, 005 LISTBOX oLbx1 FIELDS _aCmps[oLbx1:nAt,1],_aCmps[oLbx1:nAt,2],_aCmps[oLbx1:nAt,3],_aCmps[oLbx1:nAt,4],_aCmps[oLbx1:nAt,5],;
HEADER "Conclusao","Aceite","Historico","Seq","Nr SSI" SIZE 225, 115 OF oDlg PIXEL
	
oLbx1:Refresh()

@ 006,105 BUTTON "Ok" 				SIZE 55,15 ACTION oDlg:End()
ACTIVATE MSDIALOG oDlg CENTERED
*/
RestArea(aArea)
Return ()
                     
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �OPENSSI   �Autor  �Fabio Zanchim       � Data �  10/2013    ���
�������������������������������������������������������������������������͹��
���Desc.     � Abre o PDF da SSI                           				  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus 11                                                ���
��� 																	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function OPENSSI()

Local cLocalPath:=Alltrim(GetTempPath())

If Right(cLocalPAth,1)<>'\'
	cLocalPAth+='\'
EndIf
If File("\ssi_imagens\"+ZP_NRSSI+'.PDF')
	If ApMsgYesNo('Confirma abertura do PDF da SSI ?')
		CpyS2T("\ssi_imagens\"+ZP_NRSSI+'.PDF',cLocalPAth,.T.)
		ShellExecute('open',cLocalPath+ZP_NRSSI+'.PDF','',cLocalPath,1)
	EndIf
Else  
	Aviso( "PDF SSI", "N�o h� arquivo digitalizado para a SSI "+ZP_NRSSI+".", {"Ok"}, 2)
EndIf

Return