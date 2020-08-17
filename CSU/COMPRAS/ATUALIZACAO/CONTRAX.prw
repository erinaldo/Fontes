#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

User Function CONTRAX()

Local _aRet 	:= {}
Local _lContra	:= .F.

Private _aItems	:= {"1- Fixo","2- Variavel"}
Private oDlg

Private _oContra
Private _cContra	:= Space(15)

Private _oCombo	
Private _cCombo	:= Space(20)

_lContra		 := MsgYesNo("Existe contrato do SIGAGCT para este pedido de compra?","SIGAGCT")    

If !_lContra
	Return
EndIf

DEFINE MSDIALOG oDlg TITLE "Contratos" FROM 178,181 TO 365,867 PIXEL

	@ 020,055 MsGet _oContra Var _cContra F3 "CN9001" Size 060,009 COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg Valid U_VlContra() When .T.
	@ 021,008 Say "Nro. Contrato"		Size 040,008 COLOR CLR_BLACK PIXEL OF oDlg

	@ 033,055 MsComboBox _oCombo Var _cCombo Items _aItems Size 060,009 OF oDlg PIXEL When .T.
	@ 034,008 Say "Tipo do Contrato"	Size 040,008 COLOR CLR_BLACK PIXEL OF oDlg

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| U_GrvSC7(),oDlg:End()},{|| oDlg:End()},,) CENTERED

Return

User Function VlContra()

Local _lRet		:= .T.
Local aArea    := GetArea()
Local aAreaCN9 := CN9->(GetArea())

CN9->( DbSetOrder(1) )
If CN9->( DbSeek(xFilial("CN9")+_cContra) )
	_cCombo := _aItems[val(CN9->CN9_CTRT)]
	_oCombo :Refresh()
EndIf

CN9->(RestArea(aAreaCN9))
RestArea(aArea)

Return _lRet


User Function GrvSC7()

RecLock("SC7",.F.)
SC7->C7_CONTRA	:= _cContra
MsUnlock()

Return