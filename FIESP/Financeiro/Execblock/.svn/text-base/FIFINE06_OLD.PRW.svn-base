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
/*
//Declaracao de variaveis.
Private _cString := "SZJ"
Private aRotina
Private cCadastro
Private aNaoSZJ

Private oTpApl

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
*/


Local _aMeses
Local _aSemana
Local _cDt
Local _nI 		:= 0
Local mv_par01 	:= dtoc(GetMv("FI_XFECHAP")+1)
//Funcao abaixo retorna o numero do dia da semana
//1-Domingo
//2-Segunda
//3-Terca
//4-Quarta
//5-Quinta
//6-Sexta
//7-Sabado
//dow(ctod("09/08/2008"))

cMes		:= Val(Substr(mv_par01,4,2))
cAno		:= Val(Substr(mv_par01,7,4))

_aMeses	:=	{	{01, "Janeiro"		,FirstDay(ctod("01/01/"+Str(cAno,4))),LastDay(ctod("01/01/"+Str(cAno,4))) },;
				{02, "Fevereiro"	,FirstDay(ctod("01/02/"+Str(cAno,4))),LastDay(ctod("01/02/"+Str(cAno,4))) },;
				{03, "Marco"		,FirstDay(ctod("01/03/"+Str(cAno,4))),LastDay(ctod("01/03/"+Str(cAno,4))) },;
				{04, "Abril"		,FirstDay(ctod("01/04/"+Str(cAno,4))),LastDay(ctod("01/04/"+Str(cAno,4))) },;
				{05, "Maio"			,FirstDay(ctod("01/05/"+Str(cAno,4))),LastDay(ctod("01/05/"+Str(cAno,4))) },;
				{06, "Junho"		,FirstDay(ctod("01/06/"+Str(cAno,4))),LastDay(ctod("01/06/"+Str(cAno,4))) },;
				{07, "Julho"		,FirstDay(ctod("01/07/"+Str(cAno,4))),LastDay(ctod("01/07/"+Str(cAno,4))) },;
				{08, "Agosto"		,FirstDay(ctod("01/08/"+Str(cAno,4))),LastDay(ctod("01/08/"+Str(cAno,4))) },;
				{09, "Setembro"		,FirstDay(ctod("01/09/"+Str(cAno,4))),LastDay(ctod("01/09/"+Str(cAno,4))) },;
				{10, "Outubro"		,FirstDay(ctod("01/10/"+Str(cAno,4))),LastDay(ctod("01/10/"+Str(cAno,4))) },;
				{11, "Novembro"		,FirstDay(ctod("01/11/"+Str(cAno,4))),LastDay(ctod("01/11/"+Str(cAno,4))) },;
				{12, "Dezembro"		,FirstDay(ctod("01/12/"+Str(cAno,4))),LastDay(ctod("01/12/"+Str(cAno,4))) }}

_nPos	:= ascan(_aMeses, {|x| x[1] == cMes })

_aSemana := {{"","",""}}

If _nPos > 0
	_nFor := Val(Substr(DtoC(_aMeses[_nPos,4]),1,2))
	_nCont := 1
	For _nI := 1 to _nFor

		_cDia := dow(ctod(Str(_nI,2)+"/"+Str(cMes,2)+"/"+Str(cAno,4)))
		_cDt  := ctod(Str(_nI,2)+"/"+Str(cMes,2)+"/"+Str(cAno,4))

		If  _cDia == 2 //Segunda
			If _nCont == 1
				_aSemana := {}
			EndIf
			AADD(_aSemana,{_cDt,,_nCont})
		ElseIf  _cDia == 3 //Terca
			If Empty(_aSemana[_nCont,1])
				_aSemana[_nCont,1] := _cDt
			EndIf
		ElseIf  _cDia == 4 //Quarta
			If Empty(_aSemana[_nCont,1])
				_aSemana[_nCont,1] := _cDt
			EndIf
		ElseIf  _cDia == 5 //Quinta
			If Empty(_aSemana[_nCont,1])
				_aSemana[_nCont,1] := _cDt
			EndIf
		ElseIf _cDia == 6 //Sexta
			If Empty(_aSemana[_nCont,1])
				_aSemana[_nCont,1] := _cDt
			EndIf
			_aSemana[_nCont,2] := _cDt
			_aSemana[_nCont,3] :=_nCont
			_nCont++
		EndIf
		If _nI == _nFor
			If !(_cDia == 1 .or. _cDia == 7) // 1-Domingo ---- 7-Sabado
				_aSemana[len(_aSemana),2] := _cDt
			EndIf
		EndIf
	Next
EndIf

_lFirst := .T.
_nItem	:= "0001"

For _nI := 1 to Len(_aSemana)
	If _lFirst
		oGetDados1:acols[1,2] := _aSemana[1,1]
		_nItem	:= oGetDados1:acols[1,1]
		_lFirst := .F.
	Else
		_nItem	:= Soma1(_nItem)
		AADD(oGetDados1:acols,{_nItem,_aSemana[_nI,1],0,"",0,.F.})
	EndIf
	For _nY := 1 to (_aSemana[_nI,2] - _aSemana[_nI,1])
		_nItem	:= Soma1(_nItem)
		AADD(oGetDados1:acols,{_nItem,_aSemana[_nI,1]+_nY,0,"",0,.F.})
	Next _nY
Next _nI

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

If Empty(M->ZH_TIPO)
	ApMsgInfo('Opera็ใo nใo selecionada!!!', 'ATENวรO' )
	Return()
Else
	_cNumero 	:= M->ZH_NUMERO
	_cTipo 		:= M->ZH_TIPO
	_cNum		:= M->ZH_NUMERO //numero utilizado para cancelar a Aplica็ใo
EndIf

// Montagem da grade da distribuicao
If _cTipo == "C" //CDB
	aNaoSZJ  := {"ZJ_NUMERO","ZJ_INDICE"}
ElseIf _cTipo == "F" //FUNDO DE APLICACAO
	aNaoSZJ  := {"ZJ_NUMERO","ZJ_CDI"}
EndIf

IF nOpc == 3
	cSeek  := ""
	cWhile := ""
ELSE
	cSeek  :=  xFilial("SZJ")+SZH->ZH_NUMERO
	cWhile := "SZJ->(ZJ_FILIAL+ZJ_NUMERO)"
ENDIF

FillGetDados(nOpc,cAlias,1,cSeek,{|| &cWhile },{|| .T. .and. SZJ->ZJ_STATUS <> 'C' },aNaoSZJ,/*aSimCpo*/,,,,,aHeader,aCols)
IF Empty(GdFieldGet("ZJ_IT",1,,aHeader,aCols))
	GDFieldPut("ZJ_IT",StrZero(1,TamSX3("ZJ_IT")[1]),1,aHeader,aCols)
ENDIF

aSizeAut := MsAdvSize()

AADD(aButtons,{"NOTE",&("{||u_FIFINE06()}"),"Dias Uteis"})

DEFINE FONT oBold NAME "Arial" SIZE 0, -11 BOLD
oDlg := MSDIALOG():New(aSizeAut[7],000, 300,400, cTitulo,,,,,,,,,.T.)
//Cria variaveis M->????? da Enchoice.
RegToMemory(cAlias, If(nOpc==3,.T.,.F.))

aCampos1	:= {"ZJ_DATA","ZJ_INDICE","ZJ_CDI"}

If nOpc == 3 .or. nOpc == 4
	nGetd1		:= GD_INSERT+GD_UPDATE+GD_DELETE
Else
	nGetd1		:= 0
EndIf

oGetDados1	:= MsNewGetDados():New(1,1,1,1,nGetd1,"U_FIFINLOK",cTudoOk,"+ZJ_IT",aCampos1,nFreeze,nLinhas,cFieldOk,/*superdel*/,"U_FIFINDOK",,aheader,acols)
oGetDados1:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
oGetDados1:oBrowse:Default()
oGetDados1:oBrowse:Refresh()

oDlg:bInit	:= {|| EnchoiceBar(oDlg,{||iif(FIFINTOK(aHeader,aCols,nOpc),(nOpca:=1,oDlg:End()),nOpca:=0 )},{||nOpca:=0,oDlg:End()},,aButtons)}
oDlg:lCentered := .T.
oDlg:Activate()

lRet:=(nOpca==1)

If lRet
	FIFINGRV(aHeader,aCols,nOpc)
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
		IF !SZJ->(dbSeek(xFilial("SZJ")+(_cNumero+DTOS(oGetDados1:aCols[nX,2]))))
			IF _lDelete
				Loop
			ENDIF
			RecLock("SZJ",.T.)
			SZJ->ZJ_FILIAL 	:= xFilial("SZJ")
			SZJ->ZJ_NUMERO 	:= _cNumero
		ELSE
			If nOpc <> 3 .and. SZJ->(dbSeek(xFilial("SZJ")+(_cNumero+DTOS(oGetDados1:aCols[nX,2]))))
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
	While SZJ->(!Eof()) .and. SZJ->(ZJ_FILIAL+ZJ_NUMERO) == xFilial("SZJ")+(_cNumero)
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