/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCCOMA02   บAutor  ณMicrosiga           บ Data ณ  10/18/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Show1Form(_nOpc)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _cAux1

// Objetos do dialogo principal que contera os tres formularios.
Private oMainMenu,oSayJuros,oGetJuros,oLbxPgtoN,oSBtnOk,oSBtnCancel

// Objetos do primeiro formulario.
Private oGrpForn1,oGrpProp1,oGrpPag1,oLbxPgto1,oGrpPrazo1,aCols1
Private oSayForn1,oSayQtde1,oSayPrc1,oSayDesc1,oSayIPI1,oSayISS1,oSayFrete1,oSayDesp1,oSayTotal1,oSayPrazo1
Private oGetForn1,oGetQtde1,oGetPrc1,oGetDesc1,oGetIPI1,oGetISS1,oGetFrete1,oGetDesp1,oGetTotal1,oGetPrazo1

Do Case
	Case _nOpc == 1
		_cAux1 := "Incluir"
	Case _nOpc == 2
		_cAux1 := "Atualizar"
	Case _nOpc == 5
		_cAux1 := "Excluir"
	OtherWise
		_cAux1 := "Erro ShowForm1"
EndCase

oMainMenu := MSDIALOG():Create()
oMainMenu:cName     := "oMainMenu"
oMainMenu:cCaption  := _cAux1
oMainMenu:nLeft     := 0
oMainMenu:nTop      := 0
oMainMenu:nWidth    := 223
oMainMenu:nHeight   := 525 // 505
oMainMenu:lShowHint := .T.
oMainMenu:lCentered := .T.

aCols1  := {}

// Exibe o formulario numero 1.
ShowForm(000,0,1,.T.)
oGetForn1:lReadOnly := (_nOpc != 1)  // .F.

// Exibe barra de opcoes.
ShowButtons(092, 465)  // Exibe botoes.
oMainMenu:Activate()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCCOMA02   บAutor  ณMicrosiga           บ Data ณ  10/18/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Show3Forms(_nOpc)
Local _nIMP
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
// Objetos do dialogo principal que contera os tres formularios.
Private oMainMenu,oSayJuros,oGetJuros
Private oGrpOpc,oGrpObs,oRadioForn,_nFornOpc,oMemo,oSBtnOk,oSBtnCancel,oSBtnIMP
Private oDlgPgto, oLbxPgtoN

// Objetos do primeiro formulario.
Private oGrpForn1,oGrpProp1,oGrpPag1,oLbxPgto1,oGrpPrazo1,aCols1
Private oSayForn1,oSayQtde1,oSayPrc1,oSayDesc1,oSayIPI1,oSayISS1,oSayFrete1,oSayDesp1,oSayTotal1,oSayPrazo1
Private oGetForn1,oGetQtde1,oGetPrc1,oGetDesc1,oGetIPI1,oGetISS1,oGetFrete1,oGetDesp1,oGetTotal1,oGetPrazo1

// Objetos do segundo formulario.
Private oGrpForn2,oGrpProp2,oGrpPag2,oLbxPgto2,oGrpPrazo2,aCols2
Private oSayForn2,oSayQtde2,oSayPrc2,oSayDesc2,oSayIPI2,oSayISS2,oSayFrete2,oSayDesp2,oSayTotal2,oSayPrazo2
Private oGetForn2,oGetQtde2,oGetPrc2,oGetDesc2,oGetIPI2,oGetISS2,oGetFrete2,oGetDesp2,oGetTotal2,oGetPrazo2

// Objetos do terceiro formulario.
Private oGrpForn3,oGrpProp3,oGrpPag3,oLbxPgto3,oGrpPrazo3,aCols3
Private oSayForn3,oSayQtde3,oSayPrc3,oSayDesc3,oSayIPI3,oSayISS3,oSayFrete3,oSayDesp3,oSayTotal3,oSayPrazo3
Private oGetForn3,oGetQtde3,oGetPrc3,oGetDesc3,oGetIPI3,oGetISS3,oGetFrete3,oGetDesp3,oGetTotal3,oGetPrazo3
_nIMP := _nOpc
oMainMenu := MSDIALOG():Create()
oMainMenu:cName     := "oMainMenu"
oMainMenu:cCaption  := "Atualiza็ใo de Compras"
oMainMenu:nLeft     := 0
oMainMenu:nTop      := 0
oMainMenu:nWidth    := 800
oMainMenu:nHeight   := 500 // 480
oMainMenu:lCentered := .T.

aCols1 := aCols2 := aCols3 := {}

// Exibe o formulario numero 1.
ShowForm(000, 0, 1 ,.F.)
// Exibe o formulario numero 2.
ShowForm(210, 0, 2 ,.F.)
// Exibe o formulario numero 3.
ShowForm(420, 0, 3 ,.F.)

// Exibe barra de opcoes.
_nFornOpc := GetEscolha()
ShowControl(630, 0,_nIMP)
oMainMenu:Activate()
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCCOMA02   บAutor  ณMicrosiga           บ Data ณ  10/18/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ShowForm(_nLeft, _nTop, _cForm, _lWrite)

// Auxiliares nas coordedadas dos objetos.
Local a1, a2, a3, a4, _lReadOnly, _lAltPagto

_cForm := AllTrim(str(_cForm))
// Verifica se a planilha esta ativa antes ativar os objetos.
_lReadOnly := !(_lWrite .or. (!empty(_cFornCod&(_cForm)) .and. empty(_cNumPed&(_cForm))))

// TGROUP()

oGrpForn&(_cForm) := TGROUP():Create(oMainMenu)
oGrpForn&(_cForm):cName := "oGrpForn" + _cForm
oGrpForn&(_cForm):cCaption := "Fornecedor"
oGrpForn&(_cForm):nLeft   := _nLeft + 008
oGrpForn&(_cForm):nTop    := _nTop  + 003
oGrpForn&(_cForm):nWidth  := 205
oGrpForn&(_cForm):nHeight := 041

oGrpProp&(_cForm):= TGROUP():Create(oMainMenu)
oGrpProp&(_cForm):cName := "oGrpProp" + _cForm
oGrpProp&(_cForm):cCaption := "Proposta"
oGrpProp&(_cForm):nLeft   := _nLeft + 008
oGrpProp&(_cForm):nTop    := _nTop  + 048
oGrpProp&(_cForm):nWidth  := 205
oGrpProp&(_cForm):nHeight := 248  //228

oGrpPag&(_cForm) := TGROUP():Create(oMainMenu)
oGrpPag&(_cForm):cName := "oGrpPag" + _cForm
oGrpPag&(_cForm):cCaption := "Pagamento"
oGrpPag&(_cForm):nLeft   := _nLeft + 008
oGrpPag&(_cForm):nTop    := _nTop  + 300 //280
oGrpPag&(_cForm):nWidth  := 205
oGrpPag&(_cForm):nHeight := 115

oGrpPrazo&(_cForm) := TGROUP():Create(oMainMenu)
oGrpPrazo&(_cForm):cName := "oGrpPrazo" + _cForm
oGrpPrazo&(_cForm):cCaption := "Prazo de entrega"
oGrpPrazo&(_cForm):nLeft   := _nLeft + 008
oGrpPrazo&(_cForm):nTop    := _nTop  + 420 //400
oGrpPrazo&(_cForm):nWidth  := 205
oGrpPrazo&(_cForm):nHeight := 041

// TSay()

oSayForn&(_cForm) := TSAY():Create(oMainMenu)
oSayForn&(_cForm):cName := "oSayForn" + _cForm
oSayForn&(_cForm):cCaption := _cFornNom&(_cForm)
oSayForn&(_cForm):nLeft   := _nLeft + 83
oSayForn&(_cForm):nTop    := _nTop  + 18
oSayForn&(_cForm):nWidth  := 114
oSayForn&(_cForm):nHeight := 17

oSayQtde&(_cForm) := TSAY():Create(oMainMenu)
oSayQtde&(_cForm):cName := "oSayQtde" + _cForm
oSayQtde&(_cForm):cCaption := "Qtde" // + U_GetCpoVal("B1_UM", 1, xFilial("SB1") + SC8->C8_PRODUTO, .F.)
oSayQtde&(_cForm):nLeft   := _nLeft + 14
oSayQtde&(_cForm):nTop    := _nTop  + 68
oSayQtde&(_cForm):nWidth  := 65
oSayQtde&(_cForm):nHeight := 17

oSayPrc&(_cForm) := TSAY():Create(oMainMenu)
oSayPrc&(_cForm):cName := "oSayPrc" + _cForm
oSayPrc&(_cForm):cCaption := "Pre็o $"
oSayPrc&(_cForm):nLeft   := _nLeft + 14
oSayPrc&(_cForm):nTop    := _nTop  + 88
oSayPrc&(_cForm):nWidth  := 65
oSayPrc&(_cForm):nHeight := 17

oSayDesc&(_cForm) := TSAY():Create(oMainMenu)
oSayDesc&(_cForm):cName := "oSayDesc" + _cForm
oSayDesc&(_cForm):cCaption := "Desc  %"
oSayDesc&(_cForm):nLeft   := _nLeft + 14
oSayDesc&(_cForm):nTop    := _nTop  + 108
oSayDesc&(_cForm):nWidth  := 65
oSayDesc&(_cForm):nHeight := 17

oSayVlDesc&(_cForm) := TSAY():Create(oMainMenu)
oSayVlDesc&(_cForm):cName := "oSayDesc" + _cForm
oSayVlDesc&(_cForm):cCaption := "Desc  $"
oSayVlDesc&(_cForm):nLeft   := _nLeft + 14
oSayVlDesc&(_cForm):nTop    := _nTop  + 128
oSayVlDesc&(_cForm):nWidth  := 65
oSayVlDesc&(_cForm):nHeight := 17

oSayIPI&(_cForm) := TSAY():Create(oMainMenu)
oSayIPI&(_cForm):cName := "oSayIPI" + _cForm
oSayIPI&(_cForm):cCaption := "IPI %"
oSayIPI&(_cForm):nLeft   := _nLeft + 14
oSayIPI&(_cForm):nTop    := _nTop  + 148
oSayIPI&(_cForm):nWidth  := 65
oSayIPI&(_cForm):nHeight := 17

oSayISS&(_cForm) := TSAY():Create(oMainMenu)
oSayISS&(_cForm):cName := "oSayISS" + _cForm
oSayISS&(_cForm):cCaption := "ISS %"
oSayISS&(_cForm):nLeft   := _nLeft + 14
oSayISS&(_cForm):nTop    := _nTop  + 168
oSayISS&(_cForm):nWidth  := 65
oSayISS&(_cForm):nHeight := 17

oSayFrete&(_cForm) := TSAY():Create(oMainMenu)
oSayFrete&(_cForm):cName := "oSayFrete" + _cForm
oSayFrete&(_cForm):cCaption := "Frete $"
oSayFrete&(_cForm):nLeft   := _nLeft + 14
oSayFrete&(_cForm):nTop    := _nTop  + 188
oSayFrete&(_cForm):nWidth  := 65
oSayFrete&(_cForm):nHeight := 17

oSayDesp&(_cForm) := TSAY():Create(oMainMenu)
oSayDesp&(_cForm):cName := "oSayDesp" + _cForm
oSayDesp&(_cForm):cCaption := "Desp $"
oSayDesp&(_cForm):nLeft   := _nLeft + 14
oSayDesp&(_cForm):nTop    := _nTop  + 208
oSayDesp&(_cForm):nWidth  := 65
oSayDesp&(_cForm):nHeight := 17

oSayAcert&(_cForm) := TSAY():Create(oMainMenu)
oSayAcert&(_cForm):cName := "oSayAcert" + _cForm
oSayAcert&(_cForm):cCaption := "Acerto  $"
oSayAcert&(_cForm):nLeft   := _nLeft + 14
oSayAcert&(_cForm):nTop    := _nTop  + 228
oSayAcert&(_cForm):nWidth  := 65
oSayAcert&(_cForm):nHeight := 17

oSayTotal&(_cForm) := TSAY():Create(oMainMenu)
oSayTotal&(_cForm):cName := "oSayTotal" + _cForm
oSayTotal&(_cForm):cCaption := "Total $"
oSayTotal&(_cForm):nLeft   := _nLeft + 14
oSayTotal&(_cForm):nTop    := _nTop  + 270  // 250
oSayTotal&(_cForm):nWidth  := 65
oSayTotal&(_cForm):nHeight := 17

// Crystal
oSayPgto&(_cForm) := TSAY():Create(oMainMenu)
oSayPgto&(_cForm):cName := "oSayPgto" + _cForm
oSayPgto&(_cForm):cCaption := "Cond Pgto"
oSayPgto&(_cForm):nLeft   := _nLeft + 14
oSayPgto&(_cForm):nTop    := _nTop  + 320 // 414
oSayPgto&(_cForm):nWidth  := 65
oSayPgto&(_cForm):nHeight := 17
// Crystal

oSayPrazo&(_cForm) := TSAY():Create(oMainMenu)
oSayPrazo&(_cForm):cName := "oSayPrazo" + _cForm
oSayPrazo&(_cForm):cCaption := "Entrega (dias)"
oSayPrazo&(_cForm):nLeft   := _nLeft + 14
oSayPrazo&(_cForm):nTop    := _nTop  + 434 // 414
oSayPrazo&(_cForm):nWidth  := 65
oSayPrazo&(_cForm):nHeight := 17

// TGet()

oGetForn&(_cForm) := TGET():Create(oMainMenu)
oGetForn&(_cForm):cName := "oGetForn" + _cForm
oGetForn&(_cForm):nLeft   := _nLeft + 014
oGetForn&(_cForm):nTop    := _nTop  + 018
oGetForn&(_cForm):nWidth  := 65
oGetForn&(_cForm):nHeight := 21
oGetForn&(_cForm):cVariable := "_cFornCod" + _cForm
oGetForn&(_cForm):bSetGet := {|u| If(PCount()>0,_cFornCod&(_cForm):=u,_cFornCod&(_cForm)) }
oGetForn&(_cForm):cF3 := "SA2"
oGetForn&(_cForm):Picture := PesqPict('SA2', 'A2_COD')
oGetForn&(_cForm):bValid  := {|| AtuCpos(val(_cForm), "FORN") }
oGetForn&(_cForm):lReadOnly := .T.

oGetQtde&(_cForm) := TGET():Create(oMainMenu)
oGetQtde&(_cForm):cName := "oGetQtde" + _cForm
oGetQtde&(_cForm):nLeft   := _nLeft + 072 // 087
oGetQtde&(_cForm):nTop    := _nTop  + 068
oGetQtde&(_cForm):nWidth  := 114
oGetQtde&(_cForm):nHeight := 21
oGetQtde&(_cForm):cVariable := "_nQTDE" + _cForm
oGetQtde&(_cForm):bSetGet := {|u| If(PCount()>0,_nQTDE&(_cForm):=u,_nQTDE&(_cForm)) }
oGetQtde&(_cForm):Picture := PesqPict('SC8', 'C8_QUANT')
oGetQtde&(_cForm):bChange := {|| AtuCpos(val(_cForm), "TOTAL") }
oGetQtde&(_cForm):lReadOnly := _lReadOnly

oGetPrc&(_cForm) := TGET():Create(oMainMenu)
oGetPrc&(_cForm):cName := "oGetPrc" + _cForm
oGetPrc&(_cForm):nLeft   := _nLeft + 072
oGetPrc&(_cForm):nTop    := _nTop  + 088
oGetPrc&(_cForm):nWidth  := 114
oGetPrc&(_cForm):nHeight := 21
oGetPrc&(_cForm):cVariable := "_nPRECO" + _cForm
oGetPrc&(_cForm):bSetGet := {|u| If(PCount()>0,_nPRECO&(_cForm):=u,_nPRECO&(_cForm)) }
oGetPrc&(_cForm):Picture := PesqPict('SC8', 'C8_PRECO')
oGetPrc&(_cForm):bChange := {|| AtuCpos(val(_cForm), "TOTAL") }
oGetPrc&(_cForm):lReadOnly := _lReadOnly

oGetDesc&(_cForm) := TGET():Create(oMainMenu)
oGetDesc&(_cForm):cName := "oGetDesc" + _cForm
oGetDesc&(_cForm):nLeft   := _nLeft + 072 // 087
oGetDesc&(_cForm):nTop    := _nTop  + 108
oGetDesc&(_cForm):nWidth  := 114
oGetDesc&(_cForm):nHeight := 21
oGetDesc&(_cForm):cVariable := "_nDESC" + _cForm
oGetDesc&(_cForm):bSetGet := {|u| If(PCount()>0,_nDESC&(_cForm):=u,_nDESC&(_cForm)) }
oGetDesc&(_cForm):Picture := PesqPict('SC8', 'C8_DESC')
oGetDesc&(_cForm):bChange := {|| (_nVLDESC&(_cForm) := _nDESC&(_cForm) * (_nQTDE&(_cForm) * _nPRECO&(_cForm)) / 100, AtuCpos(val(_cForm), "TOTAL")) }
oGetDesc&(_cForm):lReadOnly := _lReadOnly

oGetVlDsc&(_cForm) := TGET():Create(oMainMenu)
oGetVlDsc&(_cForm):cName := "oGetVlDsc" + _cForm
oGetVlDsc&(_cForm):nLeft   := _nLeft + 072 // 087
oGetVlDsc&(_cForm):nTop    := _nTop  + 128
oGetVlDsc&(_cForm):nWidth  := 114
oGetVlDsc&(_cForm):nHeight := 21
oGetVlDsc&(_cForm):cVariable := "_nVLDESC" + _cForm
oGetVlDsc&(_cForm):bSetGet := {|u| If(PCount()>0,_nVLDESC&(_cForm):=u,_nVLDESC&(_cForm)) }
oGetVlDsc&(_cForm):Picture := PesqPict('SC8', 'C8_VLDESC')
oGetVlDsc&(_cForm):bChange := {|| (_nDESC&(_cForm) := 0, AtuCpos(val(_cForm), "TOTAL")) }
oGetVlDsc&(_cForm):lReadOnly := _lReadOnly

oGetIPI&(_cForm) := TGET():Create(oMainMenu)
oGetIPI&(_cForm):cName := "oGetIPI" + _cForm
oGetIPI&(_cForm):nLeft   := _nLeft + 072 // 087
oGetIPI&(_cForm):nTop    := _nTop  + 148
oGetIPI&(_cForm):nWidth  := 114
oGetIPI&(_cForm):nHeight := 21
oGetIPI&(_cForm):cVariable := "_nIPI" + _cForm
oGetIPI&(_cForm):bSetGet := {|u| If(PCount()>0,_nIPI&(_cForm):=u,_nIPI&(_cForm)) }
oGetIPI&(_cForm):Picture := PesqPict('SC8', 'C8_ALIIPI')
oGetIPI&(_cForm):bChange := {|| AtuCpos(val(_cForm), "TOTAL") }
oGetIPI&(_cForm):lReadOnly := _lReadOnly

oGetISS&(_cForm) := TGET():Create(oMainMenu)
oGetISS&(_cForm):cName := "oGetISS" + _cForm
oGetISS&(_cForm):nLeft   := _nLeft + 072 // 087
oGetISS&(_cForm):nTop    := _nTop  + 168
oGetISS&(_cForm):nWidth  := 114
oGetISS&(_cForm):nHeight := 21
oGetISS&(_cForm):cVariable := "_nISS" + _cForm
oGetISS&(_cForm):bSetGet := {|u| If(PCount()>0,_nISS&(_cForm):=u,_nISS&(_cForm)) }
oGetISS&(_cForm):Picture := PesqPict('SC8', 'C8_ALIIPI')
oGetISS&(_cForm):bChange := {|| AtuCpos(val(_cForm), "TOTAL") }
oGetISS&(_cForm):lReadOnly := _lReadOnly

oGetFrete&(_cForm) := TGET():Create(oMainMenu)
oGetFrete&(_cForm):cName := "oGetFrete" + _cForm
oGetFrete&(_cForm):nLeft   := _nLeft + 072 // 087
oGetFrete&(_cForm):nTop    := _nTop  + 188
oGetFrete&(_cForm):nWidth  := 114
oGetFrete&(_cForm):nHeight := 21
oGetFrete&(_cForm):cVariable := "_nFRETE" + _cForm
oGetFrete&(_cForm):bSetGet := {|u| If(PCount()>0,_nFRETE&(_cForm):=u,_nFRETE&(_cForm)) }
oGetFrete&(_cForm):Picture := PesqPict('SC8', 'C8_VALFRE')
oGetFrete&(_cForm):bChange := {|| AtuCpos(val(_cForm), "TOTAL") }
oGetFrete&(_cForm):lReadOnly := _lReadOnly

oGetDesp&(_cForm) := TGET():Create(oMainMenu)
oGetDesp&(_cForm):cName := "oGetDesp" + _cForm
oGetDesp&(_cForm):nLeft   := _nLeft + 072 // 087
oGetDesp&(_cForm):nTop    := _nTop  + 208
oGetDesp&(_cForm):nWidth  := 114
oGetDesp&(_cForm):nHeight := 21
oGetDesp&(_cForm):cVariable := "_nDESP" + _cForm
oGetDesp&(_cForm):bSetGet := {|u| If(PCount()>0,_nDESP&(_cForm):=u,_nDESP&(_cForm)) }
oGetDesp&(_cForm):Picture := PesqPict('SC8', 'C8_VLDESC')
oGetDesp&(_cForm):bChange := {|| AtuCpos(val(_cForm), "TOTAL") }
oGetDesp&(_cForm):lReadOnly := _lReadOnly

oGetAcert&(_cForm) := TGET():Create(oMainMenu)
oGetAcert&(_cForm):cName := "oGetAcert" + _cForm
oGetAcert&(_cForm):nLeft   := _nLeft + 072 // 087
oGetAcert&(_cForm):nTop    := _nTop  + 228
oGetAcert&(_cForm):nWidth  := 114
oGetAcert&(_cForm):nHeight := 21
oGetAcert&(_cForm):cVariable := "_nACERTO" + _cForm
oGetAcert&(_cForm):bSetGet := {|u| If(PCount()>0,_nACERTO&(_cForm):=u,_nACERTO&(_cForm)) }
oGetAcert&(_cForm):Picture := PesqPict('SC8', 'C8_ACERTO')
oGetAcert&(_cForm):bChange := {|| AtuCpos(val(_cForm), "TOTAL") }
oGetAcert&(_cForm):lReadOnly := _lReadOnly

oGetTotal&(_cForm) := TGET():Create(oMainMenu)
oGetTotal&(_cForm):cName := "oGetTotal" + _cForm
oGetTotal&(_cForm):nLeft   := _nLeft + 072 // 087
oGetTotal&(_cForm):nTop    := _nTop  + 270 //250
oGetTotal&(_cForm):nWidth  := 114
oGetTotal&(_cForm):nHeight := 21
oGetTotal&(_cForm):cVariable := "_nTotal" + _cForm
oGetTotal&(_cForm):bSetGet := {|u| If(PCount()>0,_nTotal&(_cForm):=u,_nTotal&(_cForm)) }
oGetTotal&(_cForm):Picture := PesqPict('SC8', 'C8_TOTAL')
oGetTotal&(_cForm):bChange := {|| AtuCpos(val(_cForm), "TOTAL-ATU") }
oGetTotal&(_cForm):lReadOnly := _lReadOnly

/* Cond. pagto */
// Coordenadas.
a1 := 11.15 // 10.45 // 9.75   // Top (a cada 1 unidade dos outros objetos, mover 0,035 desse).
a2 := 0.75 + (13.1 * (val(_cForm) - 1))  // Left
a3 := 97.5  // Width
a4 := 48    // Height

// Permite a alteracao da condicao de pagamento de cotacoes que nao tenham sido fechadas ou as 
// que tenham vencido. Nao permite a alteracao de cotacoes fechadas mas que tenham perdido.
// Index 1 - C8_FILIAL+C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO.
If !_lReadOnly
	_lAltPagto := .T.   // Se a cotacao estiver em aberto.
ElseIf empty(_cFornCod&(_cForm) + _cFornLoj&(_cForm))
	_lAltPagto := .F.   // Se nao existir a cotacao.
Else
	// Consulta se a cotacao foi fechada e o pedido ainda nao foi baixado.
	_aAreaC8 := SC8->(GetArea())
	SC8->(dbSetOrder(1))  // C8_FILIAL+C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO.
	SC8->(dbSeek(xFilial("SC8") + _cCotacao&(_cForm) + _cFornCod&(_cForm) + _cFornLoj&(_cForm) + _cItem&(_cForm), .F.))
	If SC8->C8_NUMPED != Replicate("X", len(SC8->C8_NUMPED)) .and. !empty(SC8->(C8_NUMPED + C8_ITEMPED))
		_aAreaC7 := SC7->(GetArea())
		SC7->(dbSetOrder(1))  // C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN
		SC7->(dbSeek(xFilial("SC7") + SC8->(C8_NUMPED + C8_ITEMPED), .F.))
		If SC7->C7_QUJE != 0
			_lAltPagto := .F.   // Pedido ja entregue (parcial ou total).
		Else
			_lAltPagto := .F.   // Pedido ainda em aberto.
		Endif
		SC7->(RestArea(_aAreaC7))
	Else
		_lAltPagto := .F.   // Cotacao perdida.
	Endif
	SC8->(RestArea(_aAreaC8))
Endif
//_lAltPagto := !_lReadOnly

/* Crystal
oLbxPgto&(_cForm) := TWBrowse():New(a1, a2, a3, a4,, {"Parcela", "Dia"},, oMainMenu;
,,,,,{|a1, a2| AltCondPag(_nTotal&(_cForm), aVetor&(_cForm), _cForm, _lAltPagto)},,,,,,,,,,,,,,)
oLbxPgto&(_cForm):cVariable := "aVetor" + _cForm
oLbxPgto&(_cForm):SetArray(aVetor&(_cForm))
oLbxPgto&(_cForm):bLine := {|| {aVetor&(_cForm)[oLbxPgto&(_cForm):nAt,1], aVetor&(_cForm)[oLbxPgto&(_cForm):nAt,2]}}
*/        

//Crystal Begin

oGetPgto&(_cForm) := TGET():Create(oMainMenu)
oGetPgto&(_cForm):cName := "oGetPgto" + _cForm
oGetPgto&(_cForm):nLeft   := _nLeft + 087
oGetPgto&(_cForm):nTop    := _nTop  + 320
oGetPgto&(_cForm):nWidth  := 65
oGetPgto&(_cForm):nHeight := 21
oGetPgto&(_cForm):cVariable := "_cPgtoCod" + _cForm
oGetPgto&(_cForm):bSetGet := {|u| If(PCount()>0,_cPgtoCod&(_cForm):=u,_cPgtoCod&(_cForm)) }
oGetPgto&(_cForm):cF3 := "SE4"
oGetPgto&(_cForm):Picture := PesqPict('SE4', 'E4_CODIGO')
oGetPgto&(_cForm):bValid  := {|| AtuCpos(val(_cForm), "COND") }
oGetPgto&(_cForm):lReadOnly := _lReadOnly
//Crystal End



oGetPrazo&(_cForm) := TGET():Create(oMainMenu)
oGetPrazo&(_cForm):cName := "oGetPrazo" + _cForm
oGetPrazo&(_cForm):nLeft   := _nLeft + 087
oGetPrazo&(_cForm):nTop    := _nTop  + 434 // 414
oGetPrazo&(_cForm):nWidth  := 114
oGetPrazo&(_cForm):nHeight := 21
oGetPrazo&(_cForm):cVariable := "_nPrazo" + _cForm
oGetPrazo&(_cForm):bSetGet := {|u| If(PCount()>0,_nPrazo&(_cForm):=u,_nPrazo&(_cForm)) }
oGetPrazo&(_cForm):Picture := "@E 999,999"
oGetPrazo&(_cForm):lReadOnly := _lReadOnly

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCCOMA02   บAutor  ณMicrosiga           บ Data ณ  10/18/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ShowControl(_nLeft, _nTop,_nIMP)

// TGROUP()
oGrpOpc := TGROUP():Create(oMainMenu)
oGrpOpc:cName := "oGrpOpc"
oGrpOpc:cCaption := "Op็๕es"
oGrpOpc:nLeft   := _nLeft + 008
oGrpOpc:nTop    := _nTop  + 003
oGrpOpc:nWidth  := 150
oGrpOpc:nHeight := 87

oGrpObs := TGROUP():Create(oMainMenu)
oGrpObs:cName := "oGrpObs"
oGrpObs:cCaption := "Observa็๕es"
oGrpObs:nLeft   := _nLeft + 008
oGrpObs:nTop    := _nTop  + 094
oGrpObs:nWidth  := 150
oGrpObs:nHeight := 217 //120

// Radio Button
oRadioForn := TRADMENU():Create(oMainMenu)
oRadioForn:cName := "oRadioForn"
oRadioForn:cCaption := "oRadioForn"
oRadioForn:nLeft   := _nLeft + 020
oRadioForn:nTop    := _nTop  + 020
oRadioForn:nWidth  := 122
oRadioForn:nHeight := 50
_aItems := {"Em aberto"}
If !empty(_cFornCod1); aAdd(_aItems, oSayForn1:cCaption); Endif
If !empty(_cFornCod2); aAdd(_aItems, oSayForn2:cCaption); Endif
If !empty(_cFornCod3); aAdd(_aItems, oSayForn3:cCaption); Endif
oRadioForn:aItems  := _aItems
oRadioForn:cVariable := "_nFornOpc"
oRadioForn:bSetGet   := {|u| If(PCount() > 0, _nFornOpc := u, _nFornOpc)}

// Texto memo
@ 053, 323 Get _mObs Size 067, 100 MEMO Object oMemo

//ShowButtons(_nLeft + 040, _nTop  + 418)  // Exibe botoes.
ShowButtons(_nLeft + 040, _nTop  + 438,_nIMP)  // Exibe botoes.

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCCOMA02   บAutor  ณMicrosiga           บ Data ณ  10/18/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ShowButtons(_nLeft, _nTop,_nFLAG)
// Botoes.

oSBtnOk := SBUTTON():Create(oMainMenu)
oSBtnOk:cName := "oSBtnOk"
oSBtnOk:cCaption := "Ok"
oSBtnOk:nLeft   := _nLeft
oSBtnOk:nTop    := _nTop
oSBtnOk:nWidth  := 52
oSBtnOk:nHeight := 22
oSBtnOk:nType := 1  // Ok.
oSBtnOk:bAction := {|| ProcCot()}

oSBtnCancel := SBUTTON():Create(oMainMenu)
oSBtnCancel:cName := "oSBtnCancel"
oSBtnCancel:cCaption := "Cancel"
oSBtnCancel:nLeft   := _nLeft + 066
oSBtnCancel:nTop    := _nTop
oSBtnCancel:nWidth  := 52
oSBtnCancel:nHeight := 22
oSBtnCancel:nType := 2  // Cancelar
oSBtnCancel:bAction := {|| oMainMenu:end()}

IF _nFLAG == 3 
oSBtnIMP := SBUTTON():Create(oMainMenu)
oSBtnIMP:cName := "oSBtnIMP"
oSBtnIMP:cCaption := "IMP"
oSBtnIMP:nLeft   := _nLeft
oSBtnIMP:nTop    := _nTop - 40
oSBtnIMP:nWidth  := 52
oSBtnIMP:nHeight := 22
oSBtnIMP:nType := 6  // Ok.
oSBtnIMP:bAction := {|| ProcIMP()}
ENDIF

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCCOMA02   บAutor  ณMicrosiga           บ Data ณ  10/18/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AltCondPag(_nTotPar, _aVetor, _cFormPar, _lActive)
Local _aItens, _nAux1, _lDel
Private _cAlias, _aColsAnt
Private _nTotal, _cForm

_aItens := {"Z3_PARCELA", "Z3_DIAS", "Z3_TIPO", "Z3_DATA", "Z3_PERCENT", "Z3_VALOR"}
_nTotal := _nTotPar
_cForm := _cFormPar

// Monta a aHeader.
aHeader := {}
SX3->(dbSetOrder(2))  // X3_CAMPO.
For _nAux1 := 1 to len(_aItens)
	SX3->(dbSeek(_aItens[_nAux1]))
	aAdd(aHeader, {SX3->X3_TITULO, SX3->X3_CAMPO, SX3->X3_PICTURE, SX3->X3_TAMANHO,;
	SX3->X3_DECIMAL, SX3->X3_VLDUSER, SX3->X3_USADO,;
	SX3->X3_TIPO, SX3->X3_F3, SX3->X3_CONTEXT})
Next _nAux1

// Monta a aCols.
n := 1
If !empty(aCols&(_cFormPar))
	// Restaura aCols ja montada e editada.
	aCols := aCols&(_cFormPar)
ElseIf len(aVetor&(_cFormPar)) == 1 .and. len(aVetor&(_cFormPar)[1]) < 3
	// Monta aCols vazia caso nao exista registro no cadastro de pagamento (SZ3).
	aCols := Array(1, len(aHeader) + 1)
	For _nAux1 := 1 to len(aHeader)
		SX3->(dbSeek(aHeader[_nAux1, 2], .F.))
		aCols[1, _nAux1] := IIf (!empty(SX3->X3_RELACAO), &(SX3->X3_RELACAO),;
		CriaVar(aHeader[_nAux1, 2]))
	Next _nAux1
	aCols[1, len(aHeader) + 1] := .F.  // Campo deletado: marcar como false.
Else
	// Monta aCols caso exista registro no cadastro de pagamento (SZ3).
	_cAlias := Alias()
	dbSelectArea("SZ3")
	aCols := {}
	For _nAux1 := 1 to len(aVetor&(_cFormPar))
		aAdd(aCols, Array(len(aHeader) + 1))
		SZ3->(dbSeek(aVetor&(_cFormPar)[_nAux1, 3]))
		For _nAux2 := 1 to len(aHeader)
			aCols[_nAux1, _nAux2] := FieldGet(FieldPos(aHeader[_nAux2, 2]))
		Next _nAux2
		aCols[_nAux1, len(aHeader) + 1] := .F.
	Next _nAux1
	dbSelectArea(_cAlias)
Endif
// Salva a aCols, caso o usuario cancela a operacao.
_aColsAnt := aCols

@ 000,000 to 200,390 Dialog oDlgPgto title cCadastro
@ 000,003 to 085,194 title "Condi็ใo de pagamento"
// Multiline
//@ 006,006 to 080,190 MultiLine;
//delete Valid VldLinha() Object oLbxPgtoN freeze 1
//oLbxPgtoN:oBrowse:lActive := _lActive
_lDel := .T.
oLbxPgtoN  := IW_MultiLine(006, 006, 080, 190, _lActive, _lDel, {|| VldLinha()}, 1)
oLbxPgtoN:nMax := 99


@ 085,134 BmpButton Type 1 Action CondPagOk() Object oBtnOk //VldTudo()
@ 085,166 BmpButton Type 2 Action (oDlgPgto:end(), aCols := _aColsAnt) Object oBtnCan

//oBtnOk:SetFocus()
Activate Dialog oDlgPgto Centered
aCols&(_cFormPar) := aCols
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCondPagOk บAutor  ณMicrosiga           บ Data ณ  10/21/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CondPagOk()
Local _nAux1
If VldTudo()
	aVetor&(_cForm)	 := {}
	For _nAux1 := 1 to len(aCols)
		If !(aCols[_nAux1, len(aHeader) + 1])
			aAdd(aVetor&(_cForm),{;
			Trim(Transform(aCols[_nAux1, aScan(aHeader, {|x| AllTrim(x[2]) == "Z3_VALOR"})], PesqPict('SZ3', 'Z3_VALOR'))),;
			aCols[_nAux1, aScan(aHeader, {|x| AllTrim(x[2]) == "Z3_DATA"})]})
		Endif
	Next _nAux1
	oLbxPgto&(_cForm):cVariable := "aVetor" + _cForm
	oLbxPgto&(_cForm):SetArray(aVetor&(_cForm))
	oLbxPgto&(_cForm):bLine := {|| {aVetor&(_cForm)[oLbxPgto&(_cForm):nAt,1], aVetor&(_cForm)[oLbxPgto&(_cForm):nAt,2]}}
	oLbxPgto&(_cForm):Refresh()
	oLbxPgto&(_cForm):bLine := {|| {}}
Endif
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCCOMA02   บAutor  ณMicrosiga           บ Data ณ  10/21/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VldLinha()
Local _lRet, _cMsg, _nAux1
If !(_lRet := aCols[n, len(aHeader) + 1])
	_cMsg := ""
	Do Case
		Case empty(aCols[n, _nAux1 := aScan(aHeader, {|x| AllTrim(x[2]) == "Z3_TIPO"})])
			_cMsg := "Digite um valor vแlido no campo " + AllTrim(aHeader[_nAux1, 1]) + "!"
			
		Case empty(aCols[n, _nAux1 := aScan(aHeader, {|x| AllTrim(x[2]) == "Z3_VALOR"})]) .or.;
			aCols[n, aScan(aHeader, {|x| AllTrim(x[2]) == "Z3_VALOR"})] > _nTotal
			_cMsg := "Digite um valor vแlido no campo " + AllTrim(aHeader[_nAux1, 1]) + "!"
			
		Case empty(aCols[n, _nAux1 := aScan(aHeader, {|x| AllTrim(x[2]) == "Z3_DATA"})]) .and.;
			aCols[n, aScan(aHeader, {|x| AllTrim(x[2]) == "Z3_TIPO"})] != "N"
			_cMsg := "Digite um valor vแlido no campo " + AllTrim(aHeader[_nAux1, 1]) + "!"
			
		Case aCols[n, aScan(aHeader, {|x| AllTrim(x[2]) == "Z3_TIPO"})] == "N"
			aCols[n, aScan(aHeader, {|x| AllTrim(x[2]) == "Z3_DATA"})] := ctod('')
			_lRet := .T.
			
		OtherWise
			_lRet := .T.
	EndCase
	If !empty(_cMsg); MsgAlert(_cMsg, "Aten็ใo"); Endif
Endif
Return(_lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCCOMA02   บAutor  ณMicrosiga           บ Data ณ  10/21/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VldTudo()
Local _lRet, _cMsg, _PL, _nAux1, _nTotPerc, _nTotValor
_PL := CHR(13) + CHR(10)

// Valida o total.
_nTotPerc := _nTotValor := 0
_lTipoVaz := .F.
For _nAux1 := 1 to len(aCols)
	// Soma somente se a linha nao estiver apagada.
	If !aCols[_nAux1, len(aHeader) + 1]
		_nTotPerc  += aCols[_nAux1, aScan(aHeader, {|x| AllTrim(x[2]) == "Z3_PERCENT"})]
		_nTotValor += aCols[_nAux1, aScan(aHeader, {|x| AllTrim(x[2]) == "Z3_VALOR"})]
	Endif
Next _nAux1

_lRet := .F.
Do Case
	Case !(_nTotPerc == 100)
		_cMsg := "O total nใo bate 100%"
		MsgAlert(_cMsg, "Aten็ใo  -  " + Transform(_nTotPerc, PesqPict('SZ3', 'Z3_PERCENT')))
	Case !(_nTotValor == _nTotal)
		_cMsg := "O valor total nใo bate com " + Transform(_nTotal, PesqPict('SZ3', 'Z3_VALOR'))
		MsgAlert(_cMsg, "Aten็ใo  -  " + Transform(_nTotValor, PesqPict('SZ3', 'Z3_VALOR')))
	OtherWise
		_lRet := .T.
EndCase

// Se tudo correto, fecha a janela de pagamentos.
If _lRet; oDlgPgto:end(); Endif
Return(_lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCCOMA02   บAutor  ณMicrosiga           บ Data ณ  10/30/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetEscolha()
Local _nAux1, _cAux1, _nRet := 1
For _nAux1 := 1 to 3
	_cAux1 := AllTrim(str(_nAux1))
	If !empty(_cFornCod&(_cAux1)) .and. _cCotSts&(_cAux1) == "1"
		_nRet += _nAux1
		Exit  // Sai do looping.
	Endif
Next _nAux1
Return(_nRet)