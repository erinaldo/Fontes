#include "rwmake.ch"
#include "protheus.ch"
#include "TOPCONN.ch"
#include "colors.ch"                                                                                                        

#DEFINE _EOL chr(13) + chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICTBA03  บAutor  ณMicrosiga           บ Data ณ  02/02/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cadastro de Item Contabil X Conta Contabil                 บฑฑ
ฑฑบ          ณ Rotina de Projeto                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FICTBA03

//Declaracao de variaveis.
Private _cString := "SZC"
Private aRotina
Private cCadastro
Private aLegenda
Private _cItem

&(_cString)->(dbSetOrder(1))

//Monta um aRotina proprio.
aRotina := {	{"Pesquisar"	, "AxPesqui"	,  0, 1},;
				{"Visualizar"	, "u_FICTBR30"	,  0, 2},;
				{"Incluir"		, "u_FICTBR30"	,  0, 3},;
				{"Alterar"		, "u_FICTBR30"	,  0, 4},;
				{"Excluir"		, "u_FICTBR30"	,  0, 5}}

//Exibe a tela de cadastro.
cCadastro := "Item Contabil X Conta Contabil"

mBrowse(06, 01, 22, 75, _cString,,,,,,)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICTBA03  บAutor  ณMicrosiga           บ Data ณ  06/18/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FICTBR30(cAlias,nReg,nOpc)
Local lRet
Local nOpca := 0
Local oDlg
Local cTitulo		:= "Item Contabil X Conta Contabil"
Local cAlias		:= _cString         // Alias da enchoice.
Local cFieldOk		:= "AllwaysTrue()"  // Valida cada campo da GetDados.
Local cLinOk		:= "AllwaysTrue()"  // Valida a linha.
Local cTudoOk		:= "AllwaysTrue()"  // Valida toda a GetDados.
Local nLinhas
Local nLinhas		:= Iif(nLinhas  ==Nil,9999,nLinhas )
Local nFreeze		:= 1

Private aHeader 	:= {}
Private aCols 	:= {}

//Botoes dentro da Tela de Inclusao (Acoes Relacionadas
aButtons	:= {}

SX3->(dbSetOrder(1))
SX3->(dbSeek("SZC"))
nUsado  := 0
While SX3->(!EOF()) .And. SX3->X3_ARQUIVO == "SZC"
	IF ALLTRIM(SX3->X3_CAMPO) $ "ZC_IT/ZC_BANCO/ZC_AGENCIA/ZC_CCORR/ZC_NREDUZ"
		nUsado++
		aAdd(aHeader,	 {	TRIM(X3Titulo())		,;
							SX3->X3_CAMPO			,;
							SX3->X3_PICTURE			,;
							SX3->X3_TAMANHO			,;
							SX3->X3_DECIMAL			,;
							SX3->X3_VALID			,;
							SX3->X3_USADO			,;
							SX3->X3_TIPO			,;
							SX3->X3_F3				,;
							SX3->X3_CONTEXT			,;
							SX3->X3_CBOX			,;
							SX3->X3_RELACAO			,;
							SX3->X3_WHEN			,;
							SX3->X3_VISUAL			,;
							SX3->X3_VLDUSER			,;
							SX3->X3_PICTVAR			,;
							SX3->X3_OBRIGAT			})
	Endif
	SX3->(dbSkip())
End

aAdd( aCOLS,Array(Len(aHeader)+1))

SX3->(dbSetOrder(1))
SX3->(dbSeek("SZC"))
nUsado:=0

While SX3->(!EOF()) .And. SX3->X3_ARQUIVO == "SZC"
	nPos := Ascan(aHeader, { |x| x[2] == SX3->X3_CAMPO })
	IF (nPos := Ascan(aHeader, { |x| x[2] == SX3->X3_CAMPO })) > 0
		nUsado++
		IF SX3->X3_TIPO == "C"
			aCOLS[1][nUsado] := SPACE(SX3->X3_TAMANHO)
		ELSEIF SX3->X3_TIPO == "N"
			aCOLS[1][nUsado] := 0
		ELSEIF SX3->X3_TIPO == "D"
			aCOLS[1][nUsado] := dDataBase
		ELSEIF SX3->X3_TIPO == "M"
			aCOLS[1][nUsado] := CriaVar(AllTrim(SX3->X3_CAMPO))
		ELSE
			aCOLS[1][nUsado] := .F.
		Endif
		If SX3->X3_CONTEXT == "V"
			aCols[1][nUsado] := CriaVar(AllTrim(SX3->X3_CAMPO))
		Endif
	Endif
	SX3->(dbSkip())
End

aCOLS[1][nUsado+1] := .F.

aSizeAut := MsAdvSize()

_lFisrt  := .F. // tratamento da primeira linha do acols.

IF nOpc <> 3 // alteracao/excluir/visualizar
	
	_aAreaSZC := SZC->(GetArea())
	_cItem := SZC->ZC_ITEM
	SZC->(dbSetOrder(1))
	SZC->(dbSeek(XFilial("SZC")+_cItem))
	
	While !SZC->(Eof()) .and. SZC->ZC_FILIAL == XFilial("SZC") .and. SZC->ZC_ITEM == _cItem
		
		IF _lFisrt
			aadd(aCols,Array(Len(aHeader)+1))
			NY := 1
			For NY := 1 to Len(aHeader)
				aCols[Len(aCols)][NY] := CriaVar(aHeader[NY][2])
			Next NY
			aCOLS[Len(aCols)][Len(aHeader)+1] := .F. // Deletado
		ENDIF
		
		For i := 1 to Len(aHeader)
			GDFieldPut(aHeader[I,2],&("SZC->"+aHeader[I,2]),Len(aCols))
		Next
		
		_lFisrt := .T.
		
		SZC->(dbSkip())
	Enddo
	SZC->(RestArea(_aAreaSZC))
ENDIF

IF Empty(GDFieldGet("ZC_IT",1))
	GDFieldPut("ZC_IT",StrZero(1,TamSX3("ZC_IT")[1]),1)
ENDIF

DEFINE FONT oBold NAME "Arial" SIZE 0, -11 BOLD
oDlg := MSDIALOG():New(aSizeAut[7],000, aSizeAut[6],aSizeAut[5], cTitulo,,,,,,,,,.T.)

oPanel  := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,100,100,.T.,.T. )
oPanel:Align := CONTROL_ALIGN_TOP

oPanel1 := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,220,220,.T.,.T. )
oPanel1:Align := CONTROL_ALIGN_TOP

IF nOpc == 3 // inclusao
	RegToMemory("SZC",.T.,,,)
ELSE
	RegToMemory("SZC",.F.,.F.,,)
ENDIF

oGetCpos:= MsMGet():New("SZC" ,IIF(nOpc==3,,SZC->(Recno())),nOpc,,,,,{13,1,300,380},,3,,,,oPanel,,,,,,.T.)

oGetCpos:oBox:Align := CONTROL_ALIGN_TOP

aCampos1	:= {"ZC_BANCO"}

If nOpc == 3 .or. nOpc == 4
	nGetd1		:= GD_INSERT+GD_UPDATE+GD_DELETE
Else
	nGetd1		:= 0
EndIf

oGetDados1	:= MsNewGetDados():New(1,1,1,1,nGetd1,"U_FICT3LOK",cTudoOk,"+ZC_IT",aCampos1,nFreeze,nLinhas,cFieldOk,/*superdel*/,"U_FICT3DOK",oPanel1,aheader,acols)
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
	
	_nPosIT	 := GDFieldPos("ZC_IT")			//Item

	For nX := 1 To Len(oGetDados1:aCols)
		
		_lDelete := IIF(GDDeleted(nX,aHeader,oGetDados1:aCols),.t.,.f.)
		
		SZC->(dbSetOrder(2))
		IF nOpc == 3 .and. !SZC->(dbSeek(xFilial("SZC")+M->ZC_ITEM + oGetDados1:aCols[nX,_nPosIT]))
			IF _lDelete
				Loop
			ENDIF
			RecLock("SZC",.T.)
			SZC->ZC_FILIAL 	:= xFilial("SZC")
			SZC->ZC_ITEM 	:= M->ZC_ITEM
			SZC->ZC_CONTA 	:= M->ZC_CONTA
			SZC->ZC_CCUSTO	:= M->ZC_CCUSTO
			SZC->ZC_DESCITE := M->ZC_DESCITE
			SZC->ZC_DESCCTA := M->ZC_DESCCTA
			SZC->ZC_DESCCC  := M->ZC_DESCCC

			For nY := 1 to Len(aHeader)
				If aHeader[nY][10] <> "V"
					SZC->(FieldPut(FieldPos(aHeader[nY][2]),oGetDados1:aCols[nX][nY]))
				EndIf
			Next nY

		ELSE
			If nOpc <> 3 .and. SZC->(dbSeek(xFilial("SZC")+_cItem + oGetDados1:aCols[nX,_nPosIT]))
				IF _lDelete
					RecLock("SZC",.F.)
					SZC->(dbDelete())
					SZC->(msUnlock())
					Loop
				Else
					RecLock("SZC",.F.)
					SZC->ZC_ITEM 	:= M->ZC_ITEM
					SZC->ZC_CONTA 	:= M->ZC_CONTA
					SZC->ZC_CCUSTO	:= M->ZC_CCUSTO
					SZC->ZC_DESCITE := M->ZC_DESCITE
					SZC->ZC_DESCCTA := M->ZC_DESCCTA
					SZC->ZC_DESCCC  := M->ZC_DESCCC
					SZC->ZC_IT		:= GDFieldGet("ZC_IT",nx,,oGetDados1:aHeader,oGetDados1:aCols)
					SZC->ZC_BANCO	:= GDFieldGet("ZC_BANCO",nx,,oGetDados1:aHeader,oGetDados1:aCols)
					SZC->ZC_AGENCIA	:= GDFieldGet("ZC_AGENCIA",nx,,oGetDados1:aHeader,oGetDados1:aCols)
					SZC->ZC_CCORR	:= GDFieldGet("ZC_CCORR",nx,,oGetDados1:aHeader,oGetDados1:aCols)
					SZC->ZC_NREDUZ	:= GDFieldGet("ZC_NREDUZ",nx,,oGetDados1:aHeader,oGetDados1:aCols)
				ENDIF
			Else
				RecLock("SZC",.T.)
				SZC->ZC_ITEM 	:= M->ZC_ITEM
				SZC->ZC_CONTA 	:= M->ZC_CONTA
				SZC->ZC_CCUSTO	:= M->ZC_CCUSTO
				SZC->ZC_DESCITE := M->ZC_DESCITE
				SZC->ZC_DESCCTA := M->ZC_DESCCTA
				SZC->ZC_DESCCC  := M->ZC_DESCCC
				SZC->ZC_IT		:= GDFieldGet("ZC_IT",nx,,oGetDados1:aHeader,oGetDados1:aCols)
				SZC->ZC_BANCO	:= GDFieldGet("ZC_BANCO",nx,,oGetDados1:aHeader,oGetDados1:aCols)
				SZC->ZC_AGENCIA	:= GDFieldGet("ZC_AGENCIA",nx,,oGetDados1:aHeader,oGetDados1:aCols)
				SZC->ZC_CCORR	:= GDFieldGet("ZC_CCORR",nx,,oGetDados1:aHeader,oGetDados1:aCols)
				SZC->ZC_NREDUZ	:= GDFieldGet("ZC_NREDUZ",nx,,oGetDados1:aHeader,oGetDados1:aCols)
			EndIf
		ENDIF
		SZC->(MsUnLock())
	Next nX
	
Else
	
	// Exclui linhas
	SZC->(dbSetOrder(2))
	SZC->(MsSeek(xFilial("SZC")+M->(ZC_ITEM+ZC_IT)))
	While SZC->(!Eof()) .and. SZC->(ZC_FILIAL+ZC_ITEM) == XFilial("SZC")+M->ZC_ITEM
		Eval({|| RecLock("SZC",.f.), SZC->(dbDelete()), SZC->(MsUnLock()) })
		SZC->(dbSkip())
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

Static Function FIVALITEM(cAlias,nReg,nOpc)

lRet := .T.
If nOpc == 3 //Inclui
	lRet := ExistCpo("CTD",_cItem) .and. ExistChav("SZC",_cItem)
EndIf

Return(lRet)

Static Function FIVALCTA(cAlias,nReg,nOpc)

lRet := .T.
If nOpc == 3 //Inclui
	lRet := ExistCpo("CT1",_cConta) .and. NaoVazio()
EndIf

Return(lRet)

Static Function FIVALCC(cAlias,nReg,nOpc)

lRet := .T.
If nOpc == 3 //Inclui
	lRet := ExistCpo("CTT",_cCC) .and. NaoVazio() 
EndIf

Return(lRet)

Static Function FIVALCLVL(cAlias,nReg,nOpc)

lRet := .T.
If nOpc == 3 //Inclui
	lRet := ExistCpo("CTH",_cClValor) .and. Vazio()
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

Local _nPosBCO := GDFieldPos("ZC_BANCO")
Local _nPosAG  := GDFieldPos("ZC_AGENCIA")
Local _nPosCCO := GDFieldPos("ZC_CCORR")
Local _cBCO    := GDFieldGet("ZC_BANCO",oGetDados1:oBrowse:nAt,,oGetDados1:aHeader,oGetDados1:aCols)
Local _cAG     := GDFieldGet("ZC_AGENCIA",oGetDados1:oBrowse:nAt,,oGetDados1:aHeader,oGetDados1:aCols)
Local _cCCO    := GDFieldGet("ZC_CCORR",oGetDados1:oBrowse:nAt,,oGetDados1:aHeader,oGetDados1:aCols)

//Validacao na Inclusao para nao permitir que o Usuario grave em Branco
If !nOpc == 5 //Diferente de Exclusao
	If Empty(M->ZC_ITEM) .or. Empty(M->ZC_CONTA) .or. Empty(M->ZC_CCUSTO)
		lRet := .F.
		msgbox("Preenchimento dos campos do cabe็alho Obrigatorio!!!", "Alert")
		Return(lRet) 
	EndIf
	//Registro Nao Excluido
	If !(oGetDados1:aCols[oGetDados1:oBrowse:nAt,len(oGetDados1:aHeader)+1])

		//Validacao para nao permitir linha no aCols em Branco
		For _nY := 1 to Len(oGetDados1:aCols)
			If Empty(oGetDados1:aCols[_nY,_nPosBCO])
				lRet := .F.
				Exit
			EndIf
		Next
		If !(lRet)
			msgbox("Codigo do Banco esta Vazio!!!", "Alert")
			Return(lRet) 
		EndIf
	
		//Validacao para nao gravar Duplicidade de registros no aCols
		For _nI := 1 to Len(oGetDados1:aCols)
			If _nI <> oGetDados1:oBrowse:nAt
				If !(oGetDados1:aCols[_nI, len(oGetDados1:aHeader)+1])
					If (oGetDados1:aCols[_nI,_nPosBCO] == _cBCO) .and. (oGetDados1:aCols[_nI,_nPosAG] == _cAG) .and. (oGetDados1:aCols[_nI,_nPosCCO] == _cCCO)
						_cMens := "Banco/Agencia/Conta ja cadastrado>>"   +Chr(9)+Chr(9)+_cBCO + Chr(13)+Chr(10)
						Aviso("Duplicidade Banco: "+_cBCO,_cMens,{"Voltar"})
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

User Function FICT3LOK()

Local lRet := .T.
Local _nPosBCO := GDFieldPos("ZC_BANCO")
Local _nPosAG  := GDFieldPos("ZC_AGENCIA")
Local _nPosCCO := GDFieldPos("ZC_CCORR")
Local _cBCO    := GDFieldGet("ZC_BANCO",oGetDados1:oBrowse:nAt,,oGetDados1:aHeader,oGetDados1:aCols)
Local _cAG     := GDFieldGet("ZC_AGENCIA",oGetDados1:oBrowse:nAt,,oGetDados1:aHeader,oGetDados1:aCols)
Local _cCCO    := GDFieldGet("ZC_CCORR",oGetDados1:oBrowse:nAt,,oGetDados1:aHeader,oGetDados1:aCols)


For _nI := 1 to Len(oGetDados1:aCols)
	If _nI <> oGetDados1:oBrowse:nAt
		If !(oGetDados1:aCols[_nI, len(oGetDados1:aHeader)+1]) .and. (oGetDados1:aCols[_nI,_nPosBCO] == _cBCO) .and. (oGetDados1:aCols[_nI,_nPosAG] == _cAG) .and. (oGetDados1:aCols[_nI,_nPosCCO] == _cCCO)
			_cMens := "Banco/Agencia/Conta ja cadastrado>>"   +Chr(9)+Chr(9)+_cBCO + Chr(13)+Chr(10)
			Aviso("Duplicidade Banco: "+_cBCO,_cMens,{"Voltar"})
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

User Function FICT3DOK()

Local lRet := .T.
Local _nPosBCO := GDFieldPos("ZC_BANCO")
Local _nPosAG  := GDFieldPos("ZC_AGENCIA")
Local _nPosCCO := GDFieldPos("ZC_CCORR")
Local _cBCO    := GDFieldGet("ZC_BANCO",oGetDados1:oBrowse:nAt,,oGetDados1:aHeader,oGetDados1:aCols)
Local _cAG     := GDFieldGet("ZC_AGENCIA",oGetDados1:oBrowse:nAt,,oGetDados1:aHeader,oGetDados1:aCols)
Local _cCCO    := GDFieldGet("ZC_CCORR",oGetDados1:oBrowse:nAt,,oGetDados1:aHeader,oGetDados1:aCols)

If !(oGetDados1:aCols[oGetDados1:oBrowse:nAt,len(oGetDados1:aHeader)+1])
//	alert("Deletado")
	lRet := .T.
Else
//	alert("NAO Deletado")
	lRet := .T.
	For _nI := 1 to Len(oGetDados1:aCols)
		If _nI <> oGetDados1:oBrowse:nAt
			If !(oGetDados1:aCols[_nI, len(oGetDados1:aHeader)+1]) .and. (oGetDados1:aCols[_nI,_nPosBCO] == _cBCO) .and. (oGetDados1:aCols[_nI,_nPosAG] == _cAG) .and. (oGetDados1:aCols[_nI,_nPosCCO] == _cCCO)
				_cMens := "Banco/Agencia/Conta ja cadastrado>>"   +Chr(9)+Chr(9)+_cBCO + Chr(13)+Chr(10)
				Aviso("Duplicidade Banco: "+_cBCO,_cMens,{"Voltar"})
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