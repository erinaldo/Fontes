#include "rwmake.ch"
#include "protheus.ch"
#include "TOPCONN.ch"
#include "colors.ch"                                                                                                        

#DEFINE _EOL chr(13) + chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICTBA02  บAutor  ณMicrosiga           บ Data ณ  02/02/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cadastro de Usuario X Item Contabil                        บฑฑ
ฑฑบ          ณ Rotina de Projeto                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FICTBA02

//Declaracao de variaveis.
Private _cString := "SZB"
Private aRotina
Private cCadastro
Private aLegenda
Private _cUser
Private _cNome
Private aNaoSZB

&(_cString)->(dbSetOrder(1))

//Monta um aRotina proprio.
aRotina := {	{"Pesquisar"	, "AxPesqui"	,  0, 1},;
				{"Visualizar"	, "u_FICTBR20"	,  0, 2},;
				{"Incluir"		, "u_FICTBR20"	,  0, 3},;
				{"Alterar"		, "u_FICTBR20"	,  0, 4},;
				{"Excluir"		, "u_FICTBR20"	,  0, 5}}

//Exibe a tela de cadastro.
cCadastro := "Usuario X Item Contabil"

mBrowse(06, 01, 22, 75, _cString,,,,,,)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICTBA02  บAutor  ณMicrosiga           บ Data ณ  06/18/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FICTBR20(cAlias,nReg,nOpc)
Local lRet
Local nOpca := 0
Local oDlg
Local cTitulo		:= "Usuario X Item Contabil"
Local cAlias		:= _cString         // Alias da enchoice.
Local cFieldOk		:= "AllwaysTrue()"  // Valida cada campo da GetDados.
Local cLinOk		:= "AllwaysTrue()"  // Valida a linha.
Local cTudoOk		:= "AllwaysTrue()"  // Valida toda a GetDados.
Local nLinhas
Local nLinhas		:= Iif(nLinhas  ==Nil,9999,nLinhas ) // Numero maximo de linhas na GetDados.
Local nFreeze		:= 1

Private aHeader 	:= {}
Private aCols 	:= {}

//Botoes dentro da Tela de Inclusao (Acoes Relacionadas
aButtons	:= {}
/*
//Exemplo:
Aadd( aButtons, { "ALTERA", { || fteste()   },"Aprovacao","Aprovacao"})
Aadd( aButtons, { "ALTERA", { || fteste()   },"Adiantamento","Adiantamento"})
Aadd( aButtons, { "ALTERA", { || fteste()   },"Dados do Voo","Dados do Voo"})
*/

// Montagem da grade da distribuicao
aNaoSZB  := {"ZB_USERID","ZB_NOME"}
IF nOpc == 3
	_cUser := Space(TamSx3("ZB_USERID")[1])
	_cNome := Space(TamSx3("ZB_NOME")[1])

	cSeek  := ""
	cWhile := ""
ELSE
	_cUser := SZB->ZB_USERID
	_cNome := SZB->ZB_NOME

	cSeek  :=  SZB->(ZB_FILIAL+ZB_USERID)
	cWhile := "SZB->(ZB_FILIAL+ZB_USERID)"
ENDIF

FillGetDados(nOpc,cAlias,2,cSeek,{|| &cWhile },{|| .T. },aNaoSZB,/*aSimCpo*/,,,,,aHeader,aCols)
IF Empty(GdFieldGet("ZB_IT",1,,aHeader,aCols))
	GDFieldPut("ZB_IT",StrZero(1,TamSX3("ZB_IT")[1]),1,aHeader,aCols)
ENDIF

aSizeAut := MsAdvSize()

DEFINE FONT oBold NAME "Arial" SIZE 0, -11 BOLD
oDlg := MSDIALOG():New(aSizeAut[7],000, aSizeAut[6],aSizeAut[5], cTitulo,,,,,,,,,.T.)

oPanel  := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,50,50,.T.,.T. )
oPanel:Align := CONTROL_ALIGN_TOP

oPanel1 := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,220,220,.T.,.T. )
oPanel1:Align := CONTROL_ALIGN_TOP

//Cria variaveis M->????? da Enchoice.
RegToMemory(cAlias, If(nOpc==3,.T.,.F.))

@ 05, 003 TO 045,600 LABEL "" OF oPanel PIXEL
@ 15, 015 SAY "Usuario" 	SIZE 045, 07 OF oPanel FONT oBold PIXEL //Color CLR_RED
@ 15, 040 SAY "*" 			SIZE 045, 07 OF oPanel FONT oBold Color CLR_HRED PIXEL
@ 25, 015 MSGET _cUser		SIZE 068, 09 Picture "@!" F3 "SZA" Valid(FIVALUSER(aHeader,aCols,nOpc)) When iif(nOpc == 3,.T.,.F.)	OF oPanel PIXEL

@ 15, 100 SAY "Nome"		SIZE 045, 07 OF oPanel PIXEL
@ 25, 100 MSGET _cNome		SIZE 180, 09 When .F. OF oPanel PIXEL

aCampos1	:= {"ZB_ITEM","ZB_DESC"}

If nOpc == 3 .or. nOpc == 4
	nGetd1		:= GD_INSERT+GD_UPDATE+GD_DELETE
Else
	nGetd1		:= 0
EndIf
//                                                                  coluna            linha
oGetDados1	:= MsNewGetDados():New(1,1,1,1,nGetd1,"U_FICTBLOK",cTudoOk,"+ZB_IT",aCampos1,nFreeze,nLinhas,cFieldOk,/*superdel*/,"U_FICTBDOK",oPanel1,aheader,acols)
oGetDados1:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
oGetDados1:oBrowse:Default()
oGetDados1:oBrowse:Refresh()

oDlg:bInit	:= {|| EnchoiceBar(oDlg,{||iif(FICTBTOK(aHeader,aCols,nOpc),(nOpca:=1,oDlg:End()),nOpca:=0 )},{||nOpca:=0,oDlg:End()},,aButtons)}
oDlg:lCentered := .T.
oDlg:Activate()

lRet:=(nOpca==1)

If lRet
	FICTBGRV(aHeader,aCols,nOpc)
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICTBA02  บAutor  ณMicrosiga           บ Data ณ  07/16/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FICTBGRV(aHeader,aCols,nOpc)

Local bCampo := {|nCPO| Field(nCPO) }

// Backup do TTS
lSavTTsInUse := __TTSInUse

// Ativa TTS
__TTSInUse := .T.

Begin Transaction

If !nOpc == 5 //Diferente de Exclusao
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณGrava os itens -                                              ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	For nX := 1 To Len(oGetDados1:aCols)
		
		_lDelete := IIF(GDDeleted(nX,aHeader,oGetDados1:aCols),.t.,.f.)
		
		SZB->(dbSetOrder(1))
		IF !SZB->(dbSeek(xFilial("SZB")+(oGetDados1:aCols[nX,1]+_cUser)))
			IF _lDelete
				Loop
			ENDIF
			RecLock("SZB",.T.)
			SZB->ZB_FILIAL 	:= xFilial("SZB")
			SZB->ZB_USERID 	:= _cUser
			SZB->ZB_NOME 	:= _cNome
		ELSE
			If nOpc <> 3 .and. SZB->(dbSeek(xFilial("SZB")+(oGetDados1:aCols[nX,1]+_cUser)))
				RecLock("SZB",.F.)
				IF _lDelete
					SZB->(dbDelete())
					SZB->(msUnlock())
					Loop
				ENDIF
			EndIf
		ENDIF
		
		For nY := 1 to Len(aHeader)
			If aHeader[nY][10] <> "V"
				SZB->(FieldPut(FieldPos(aHeader[nY][2]),oGetDados1:aCols[nX][nY]))
			EndIf
		Next nY
		
		SZB->(MsUnLock())
	Next nX
	
Else
	
	// Exclui linhas
	SZB->(dbSetOrder(1))
	SZB->(MsSeek(xFilial("SZB")+M->(ZB_IT+ZB_USERID+ZB_ITEM)))
	While SZB->(!Eof()) .and. SZB->(ZB_FILIAL+ZB_USERID) == XFilial("SZB")+(_cUser)
		Eval({|| RecLock("SZB",.f.), SZB->(dbDelete()), SZB->(MsUnLock()) })
		SZB->(dbSkip())
	EndDo
	
Endif

End Transaction

// Restaura TTS
__TTSInUse := lSavTTsInUse

Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICTBA02  บAutor  ณMicrosiga           บ Data ณ  07/16/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FIVALUSER(cAlias,nReg,nOpc)

lRet := .T.
If nOpc == 3 //Inclui
	lRet := ExistCpo("SZA",_cUser) .and. ExistChav("SZB",_cUser,2)

	_cNome := UsrRetname(_cUser)
EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณMicrosiga           บ Data ณ  06/19/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FICTBTOK(aHeader,aCols,nOpc)

Local lRet := .T.
Local _nPosITEM := GDFieldPos("ZB_ITEM")
Local _cITEM    := GDFieldGet("ZB_ITEM",oGetDados1:oBrowse:nAt,,oGetDados1:aHeader,oGetDados1:aCols)

//Validacao na Inclusao para nao permitir que o Usuario grave em Branco
If !nOpc == 5 //Diferente de Exclusao
	If Empty(_cUser)
		lRet := .F.
		msgbox("Preencher o Usuแrio!!!", "Alert")
		Return(lRet) 
	EndIf
	//Registro Nao Excluido
	If !(oGetDados1:aCols[oGetDados1:oBrowse:nAt,len(oGetDados1:aHeader)+1])
	
		//Validacao para nao permitir linha no aCols em Branco
		For _nY := 1 to Len(oGetDados1:aCols)
			If Empty(oGetDados1:aCols[_nY,_nPosITEM])
				lRet := .F.
				Exit
			EndIf
		Next
		If !(lRet)
			msgbox("Item Contabil em Branco!!!", "Alert")
			Return(lRet) 
		EndIf
	
		//Validacao para nao gravar Duplicidade de registros no aCols
		For _nI := 1 to Len(oGetDados1:aCols)
			If _nI <> oGetDados1:oBrowse:nAt
				If !(oGetDados1:aCols[_nI, len(oGetDados1:aHeader)+1])
					If (oGetDados1:aCols[_nI,_nPosITEM] == _cITEM)
						_cMens := "Item Contแbil ja cadastrado>>"   +Chr(9)+Chr(9)+_cITEM + Chr(13)+Chr(10)
						Aviso("Duplicidade Item: "+_cITEM,_cMens,{"Voltar"})
						lRet := .F.
						Return(lRet)
					EndIf
				EndIf
			EndIf
		Next _nI
	EndIf
EndIf

Return(lRet) 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณMicrosiga           บ Data ณ  06/19/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FICTBLOK()

Local lRet := .T.
Local _nPosITEM := GDFieldPos("ZB_ITEM")
Local _cITEM    := GDFieldGet("ZB_ITEM",oGetDados1:oBrowse:nAt,,oGetDados1:aHeader,oGetDados1:aCols)

For _nI := 1 to Len(oGetDados1:aCols)
	If _nI <> oGetDados1:oBrowse:nAt
		If !(oGetDados1:aCols[_nI, len(oGetDados1:aHeader)+1]) .and. (oGetDados1:aCols[_nI,_nPosITEM] == _cITEM)
			_cMens := "Item Contแbil ja cadastrado>>"   +Chr(9)+Chr(9)+_cITEM + Chr(13)+Chr(10)
			Aviso("Duplicidade Item: "+_cITEM,_cMens,{"Voltar"})
			lRet := .F.
			Return(lRet)
		EndIf
	EndIf
Next _nI
	
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICTBA02  บAutor  ณMicrosiga           บ Data ณ  07/17/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FICTBDOK()

Local lRet := .T.

Local _nPosITEM := GDFieldPos("ZB_ITEM")
Local _cITEM    := GDFieldGet("ZB_ITEM",oGetDados1:oBrowse:nAt,,oGetDados1:aHeader,oGetDados1:aCols)

If !(oGetDados1:aCols[oGetDados1:oBrowse:nAt,len(oGetDados1:aHeader)+1])
//	alert("Deletado")
	lRet := .T.
Else
//	alert("NAO Deletado")
	lRet := .T.
	For _nI := 1 to Len(oGetDados1:aCols)
		If _nI <> oGetDados1:oBrowse:nAt
			If !(oGetDados1:aCols[_nI, len(oGetDados1:aHeader)+1]) .and. (oGetDados1:aCols[_nI,_nPosITEM] == _cITEM)
				_cMens := "Item Contแbil ja cadastrado>>"   +Chr(9)+Chr(9)+_cITEM + Chr(13)+Chr(10)
				Aviso("Duplicidade Item: "+_cITEM,_cMens,{"Voltar"})
				lRet := .F.
				Return(lRet)
			EndIf
		EndIf
	Next _nI
EndIf	
Return(lRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณMicrosiga           บ Data ณ  06/19/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fteste

alert("em desenvolvimento")

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICTBA02  บAutor  ณMicrosiga           บ Data ณ  06/19/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FICTBL20()

_aLeg := {	{"BR_VERDE"		, "Em Elaboracao"  		},;
			{"BR_AMARELO"	, "Em Aprovacao"		},;
			{"BR_AZUL"		, "Em Cotacao/dPedido"	},;
			{"BR_PRETO"		, "Nao Aprovada"		},;
			{"BR_VERMELHO"	, "Encerrada"			}}
/*
BR_LARANJA
BR_CANCEL
BR_BRANCO
*/

BrwLegenda(cCadastro, "Legenda", _aLeg)

Return