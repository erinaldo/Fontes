#INCLUDE "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณccomm01   บ Autor ณ Felipe Raposo      บ Data ณ  30/07/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Programa para a interface do cadastro de fornecedores.     บฑฑ
ฑฑบ          ณ Esse programa atualiza somente dois campos: A2_CONV e      บฑฑ
ฑฑบ          ณ A2_ESTNUM.                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ccomm01()

Local _cTitle, _aEnvRet, oRadio1, oGrp2, oSBtn3, oSBtn4
Private oDlg, _nEnvRet

_cTitle  := "Interface do cadastro de fornecedores"
_aEnvRet := {"Envio", "Retorno"}
_nEnvRet := 0

// Monta a caixa de dialogo principal.
oDlg := MsDialog():Create()
oDlg:cName := "oDlg"
oDlg:cCaption := _cTitle
oDlg:nLeft := 0
oDlg:nTop := 0
oDlg:nWidth := 355
oDlg:nHeight := 145
oDlg:lShowHint := .F.
oDlg:lCentered := .T.

// Monta o contorno da tela.
oGrp2 := TGROUP():Create(oDlg)
oGrp2:cName := "oGrp2"
oGrp2:nLeft := 6
oGrp2:nTop := 4
oGrp2:nWidth := 333
oGrp2:nHeight := 73
oGrp2:lShowHint := .F.
oGrp2:lReadOnly := .F.
oGrp2:Align := 0
oGrp2:lVisibleControl := .T.

// Monta a lista de opcoes (radio buttom)
oRadio1 := TRADMENU():Create(oDlg)
oRadio1:cName := "oRadio1"
oRadio1:cCaption := "oRadio1"
oRadio1:cMsg := "Teste"
oRadio1:nLeft := 19
oRadio1:nTop := 17
oRadio1:nWidth := 98
oRadio1:nHeight := 41
oRadio1:lShowHint := .T.
oRadio1:lReadOnly := .F.
oRadio1:Align := 0
oRadio1:nOption := 1
oRadio1:bSetGet := {|u| IIf(PCount() > 0, _nEnvRet := u, _nEnvRet)}
oRadio1:lVisibleControl := .T.
oRadio1:aItems := _aEnvRet
// Libera o botao OK quando o usuario fizer uma escolha.
oRadio1:bChange := {|| oSBtn3:lReadOnly := .F.}

// Cria o botao OK.
oSBtn3 := SBUTTON():Create(oDlg)
oSBtn3:cName := "oSBtn3"
oSBtn3:cCaption := "oSBtn3"
oSBtn3:nLeft := 215
oSBtn3:nTop := 84
oSBtn3:nWidth := 52
oSBtn3:nHeight := 22
oSBtn3:lShowHint := .F.
oSBtn3:lReadOnly := .T.
oSBtn3:Align := 0
oSBtn3:lVisibleControl := .T.
oSBtn3:nType := 1
oSBtn3:bLClicked := {|| ProcEnvRet(_nEnvRet)}

// Cria o botao cancelar.
oSBtn4 := SBUTTON():Create(oDlg)
oSBtn4:cName := "oSBtn4"
oSBtn4:cCaption := "oSBtn4"
oSBtn4:nLeft := 275
oSBtn4:nTop := 84
oSBtn4:nWidth := 52
oSBtn4:nHeight := 22
oSBtn4:lShowHint := .F.
oSBtn4:lReadOnly := .F.
oSBtn4:Align := 0
oSBtn4:lVisibleControl := .T.
oSBtn4:nType := 2
oSBtn4:bLClicked := {|| oDlg:end()}

// Exibe a tela de dialogo.
oDlg:Activate()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณProcEnvRetบ Autor ณ Felipe Raposo      บ Data ณ  30/07/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Valida a opcao escolhida pelo usuario e executa o progra-  บฑฑ
ฑฑบ          ณ ma correspondente.                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ProcEnvRet(_nOpc)
Local _cMsg, _lOk
_lOk := .F.
// 1 - Envio (geracao do arquivo).
// 2 - Retorno (leitura do arquivo).
If str(_nOpc, 1) $ "12"
	_lOk := IIf (_nOpc == 1, U_AtuSA2a(), U_AtuSA2b())
Else
	_cMsg := "Op็ใo invแlida. Fun็ใo ainda nใo disponํvel!"
	MsgBox(OemToAnsi(_cMsg), OemToAnsi("Aten็ใo"), "ALERT")
Endif
If _lOk; oDlg:end(); Endif
Return (_lOk)