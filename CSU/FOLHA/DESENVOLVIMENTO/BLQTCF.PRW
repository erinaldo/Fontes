User Function BLQTCF

//_cSenha:=Dlg2Senha()

If !Upper(AllTrim(cUserName)) $ Upper(GetMv("MV_X_USRTC"))
	
	Alert("Usuario Incorreto!!!!!!")
	
	Return
EndIf

cMesFech := CtoD( GetMv("MV_TCFDFOL")+'/'+StrZero(Month(dDataBase),2)+'/'+StrZero(Year(dDataBase),4) )
                                       
Dlg1Fin(cMesFech)

Return

Static Function _AltDt(cMesFech)
                               
Local cPutmv := StrZero( Day(cMesFech),2 )

PutMV("MV_TCFDFOL",cPutmv)

Alert("Data alterada com sucesso!!!")

Return

*----------------------------------------------------    
Static Function Dlg1Fin(cMesFech)
*----------------------------------------------------

Local oDlg,oData,oSay2,oSay6,oSay7,oData2,oSBtn11,oSBtn12
oDlg := MSDIALOG():Create()
oDlg:cName := "oDlg"
oDlg:cCaption := "Bloqueio de Emissão do Hollerith pelo RH ON LINE"
oDlg:nLeft := 0
oDlg:nTop := 0
oDlg:nWidth := 315
oDlg:nHeight := 218
oDlg:lShowHint := .F.
oDlg:lCentered := .T.

oData := TGET():Create(oDlg)
oData:cName := "oData"
oData:cCaption := "oData"
oData:nLeft := 184
oData:nTop := 72
oData:nWidth := 78
oData:nHeight := 21
oData:lShowHint := .F.
oData:lReadOnly := .F.
oData:Align := 0
oData:cVariable := "cMesFech"
oData:bSetGet := {|u| If(PCount()>0,cMesFech:=u,cMesFech) }
oData:lVisibleControl := .T.
oData:lPassword := .F.
oData:lHasButton := .F.

oSay2 := TSAY():Create(oDlg)
oSay2:cName := "oSay2"
oSay2:cCaption := "Esta rotina destina-se a realizar o bloqueio de emissão de hollerith."
oSay2:nLeft := 9
oSay2:nTop := 13
oSay2:nWidth := 276
oSay2:nHeight := 49
oSay2:lShowHint := .F.
oSay2:lReadOnly := .F.
oSay2:Align := 0
oSay2:lVisibleControl := .T.
oSay2:lWordWrap := .T.
oSay2:lTransparent := .T.

oSay7 := TSAY():Create(oDlg)
oSay7:cName := "oSay7"
oSay7:cCaption := "Último mes fechado"
oSay7:nLeft := 19
oSay7:nTop := 72
oSay7:nWidth := 133
oSay7:nHeight := 17
oSay7:lShowHint := .F.
oSay7:lReadOnly := .F.
oSay7:Align := 0
oSay7:lVisibleControl := .T.
oSay7:lWordWrap := .F.
oSay7:lTransparent := .T.


oSBtn11 := SBUTTON():Create(oDlg)
oSBtn11:cName := "oSBtn11"
oSBtn11:cCaption := "oSBtn11"
oSBtn11:nLeft := 176
oSBtn11:nTop := 148
oSBtn11:nWidth := 52
oSBtn11:nHeight := 22
oSBtn11:lShowHint := .F.
oSBtn11:lReadOnly := .F.
oSBtn11:Align := 0
oSBtn11:lVisibleControl := .T.
oSBtn11:nType := 1
oSBtn11:bAction := {|| _AltDt(cMesfech) }

oSBtn12 := SBUTTON():Create(oDlg)
oSBtn12:cName := "oSBtn12"
oSBtn12:cCaption := "oSBtn12"
oSBtn12:nLeft := 236
oSBtn12:nTop := 148
oSBtn12:nWidth := 52
oSBtn12:nHeight := 22
oSBtn12:lShowHint := .F.
oSBtn12:lReadOnly := .F.
oSBtn12:Align := 0
oSBtn12:lVisibleControl := .T.
oSBtn12:nType := 2
oSBtn12:bAction := {|| oDlg:end() }

oDlg:Activate()

Return