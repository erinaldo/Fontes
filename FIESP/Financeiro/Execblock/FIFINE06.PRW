#include "rwmake.ch"
#include "protheus.ch"
#include "TOPCONN.ch"
#include "colors.ch"

#DEFINE _EOL chr(13) + chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFIFINE06  บAutor  ณTOTVS               บ Data ณ  09/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cadastro de Moedas (indices das aplicacoes)                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FIFINE06()

//Declaracao de variaveis.
Private _cString := "SZJ"
Private aRotina
Private cCadastro
Private aNaoSZJ

Private oTpApl              
Private _cDescri
Private _lFirst := .t.

&(_cString)->(dbSetOrder(1))

//Monta um aRotina proprio.
aRotina := {	{"Pesquisar"	, "AxPesqui"	,  0, 1},;
				{"Visualizar"	, "u_FIFINE60"	,  0, 2},;
				{"Incluir"		, "u_FIFINE60"	,  0, 3},;
				{"Alterar"		, "u_FIFINE60"	,  0, 4},;
				{"Excluir"		, "u_FIFINE60"	,  0, 5}}

//Exibe a tela de cadastro.
cCadastro := "Manuten็ใo de Cota็๕es Diแrias"

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
User Function FIFINE60(cAlias,nReg,nOpc)
Local lRet
Local nOpca := 0
Local oDlg
Local cTitulo		:= "Cota็๕es Diแrias"
Local cAlias		:= cAlias         // Alias da enchoice.
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

IF nOpc == 3
	cSeek  := ""
	cWhile := ""
ELSE
	cSeek  :=  SZJ->(ZJ_FILIAL+ZJ_NUMERO)
	cWhile := "SZJ->(ZJ_FILIAL+ZJ_NUMERO)"
ENDIF

FillGetDados(nOpc,cAlias,1,cSeek,{|| &cWhile },{|| .T.},aNaoSZJ,/*aSimCpo*/,,,,,aHeader,aCols)
IF Empty(GdFieldGet("ZJ_IT",1,,aHeader,aCols))
	GDFieldPut("ZJ_IT",StrZero(1,TamSX3("ZJ_IT")[1]),1,aHeader,aCols)
ENDIF

aSizeAut := MsAdvSize()

AADD(aButtons,{"NOTE",&("{||u_FIFINE06()}"),"Dias Uteis"})

//Private _cNumero := iif(nOpc == 3,GetSxeNum("SZJ","M->ZJ_NUMERO"),SZJ->ZJ_NUMERO)

Private _cDescri := iif(nOpc == 3,space(40),SZJ->ZJ_DESCR)

DEFINE FONT oBold NAME "Arial" SIZE 0, -11 BOLD
oDlg := MSDIALOG():New(aSizeAut[7],000, aSizeAut[6],aSizeAut[5], cTitulo,,,,,,,,,.T.)

oPanel  := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,50,50,.T.,.T. )
oPanel:Align := CONTROL_ALIGN_TOP

oPanel1 := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,220,220,.T.,.T. )
oPanel1:Align := CONTROL_ALIGN_TOP

//Cria variaveis M->????? da Enchoice.
RegToMemory(cAlias, If(nOpc==3,.T.,.F.))

@ 05, 003 TO 045,600 LABEL "" OF oPanel PIXEL
@ 15, 015 SAY "Numero" 			SIZE 045, 07 OF oPanel PIXEL
@ 25, 015 MSGET M->ZJ_NUMERO 	SIZE 068, 09 Picture "@!" When .F. OF oPanel PIXEL

@ 15, 095 SAY "Descri็ใo" 	SIZE 045, 07 OF oPanel PIXEL
@ 25, 095 MSGET _cDescri 	SIZE 068, 09 Picture "@!" When iif(nOpc == 3,.T.,.F.) OF oPanel PIXEL //ZJ_DESCR  

aCampos1	:= {"ZJ_DATA","ZJ_INDICE","ZJ_CDI"}

If nOpc == 3 .or. nOpc == 4
	nGetd1		:= GD_INSERT+GD_UPDATE+GD_DELETE
Else
	nGetd1		:= 0
EndIf

oGetDados1	:= MsNewGetDados():New(1,1,1,1,nGetd1,"U_FIFINLOK",cTudoOk,"+ZJ_IT",aCampos1,nFreeze,nLinhas,cFieldOk,/*superdel*/,"U_FIFINDOK",oPanel1,aheader,acols)
oGetDados1:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
oGetDados1:oBrowse:Default()
oGetDados1:oBrowse:Refresh()

oDlg:bInit	:= {|| EnchoiceBar(oDlg,{||iif(FIFINTOK(aHeader,aCols,nOpc),(nOpca:=1,oDlg:End()),nOpca:=0 )},{||nOpca:=0,oDlg:End()},,aButtons)}
oDlg:lCentered := .T.
oDlg:Activate()

lRet:=(nOpca==1)

If lRet
	FIFINGRV(aHeader,aCols,nOpc)
	CONFIRMSX8()
Else
	RollBackSX8()
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
Static Function FIFINGRV(aHeader,aCols,nOpc)

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
		
		SZJ->(dbSetOrder(1))
		IF !SZJ->(dbSeek(xFilial("SZJ")+M->ZJ_NUMERO+(DTOS(oGetDados1:aCols[nX,2]))))
			IF _lDelete
				Loop
			ENDIF
			RecLock("SZJ",.T.)
			SZJ->ZJ_FILIAL 	:= xFilial("SZJ")
			SZJ->ZJ_NUMERO 	:= M->ZJ_NUMERO
			SZJ->ZJ_DESCR 	:= _cDescri
			IF nOpc == 3 .and. _lFirst
				SZJ->ZJ_FILTRO := "S"
				_lFirst := .F.
			EndIf
		ELSE
			If nOpc <> 3 .and. SZJ->(dbSeek(xFilial("SZJ")+SZJ->ZJ_NUMERO+(DTOS(oGetDados1:aCols[nX,2]))))
				RecLock("SZJ",.F.)
				IF _lDelete
					SZJ->(dbDelete())
					SZJ->(msUnlock())
					Loop
				ENDIF
			EndIf
		ENDIF
		
		For nY := 1 to Len(aHeader)
			If aHeader[nY][10] <> "V"
				SZJ->(FieldPut(FieldPos(aHeader[nY][2]),oGetDados1:aCols[nX][nY]))
			EndIf
		Next nY
		
		SZJ->(MsUnLock())
	Next nX
	
Else
	// Exclui linhas
	SZJ->(dbSetOrder(2))
	SZJ->(MsSeek(xFilial("SZJ")+M->(ZJ_IT+ZJ_NUMERO)))
	While SZJ->(!Eof()) .and. SZJ->(ZJ_FILIAL+ZJ_NUMERO) == xFilial("SZJ")+(M->ZJ_NUMERO)
		Eval({|| RecLock("SZJ",.f.), SZJ->(dbDelete()), SZJ->(MsUnLock()) })
		SZJ->(dbSkip())
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

Static Function FIFINTOK(aHeader,aCols,nOpc)

Local lRet := .T.
//Local _nPosITEM := GDFieldPos("ZB_ITEM")
//Local _cITEM    := GDFieldGet("ZB_ITEM",oGetDados1:oBrowse:nAt,,oGetDados1:aHeader,oGetDados1:aCols)
/*
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
*/
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

User Function FIFINLOK()

Local lRet := .T.
//Local _nPosITEM := GDFieldPos("ZB_ITEM")
//Local _cITEM    := GDFieldGet("ZB_ITEM",oGetDados1:oBrowse:nAt,,oGetDados1:aHeader,oGetDados1:aCols)
/*
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
*/
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

User Function FIFINDOK()

Local lRet := .T.
/*
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
*/
Return(lRet)