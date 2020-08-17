#include "rwmake.ch"
#include "PROTHEUS.CH"      
#define ENTER Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ ProvPC บAutor  ณ Douglas David        บ Data ณMar็o/2016   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Bloqueio e desbloqueio para altera็๕es de pedido de comprasบฑฑ
ฑฑบ            Quando existir provisใo vinculada.                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/   

User Function PROVPC

Local _cSenha := ProvBlqSenha()      


If Alltrim(_cSenha) <> GetMv("MV_SENHPRO")
	
	Alert("Senha incorreta !!!!!!")
	
	Return 
	
EndIf         

cTipBloq := Alltrim(GetMv("MV_PROVPC"))

Dlg1Prov(cTipBloq)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ ProvPC บAutor  ณ Douglas David        บ Data ณMar็o/2016   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Bloquear/Desbloquear a movimenta็ใo das provis๕es 		  บฑฑ
ฑฑบ            (inclusใo, altera็ใo e exclusใo)		                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/   

Static Function AltBlqProv(cTipBloq)

local _bOk
local _aSM     
local _cTab       
local _cIndice

_bOk := .F.


DBSELECTAREA("SM0")
DBSetOrder(1)

_aSM := GetArea()

	_cTab := "SX6"+ALLTRIM(SM0->M0_CODIGO)+"0.DBF"
	_cIndice := "SX6"+ALLTRIM(SM0->M0_CODIGO)+"0.CDX"

While !EOF()
	
	If File(_cTab) .AND. File(_cIndice)
		
		DBUseArea( .T., "DBFCDX", _cTab, "X6EMP", .T.)
		
		DBSelectArea("X6EMP")
		dbSetIndex(_cIndice)
		
		If DBseek("  "+"MV_PROVPC",.F.)
			Reclock("X6EMP",.F.)
			X6EMP->X6_CONTEUD := Alltrim(cTipBloq)
			MsUnlock()
			
			_bOk := .T.    
		Else
			_bOk := .F.
		EndIf
		
		DBSelectArea("X6EMP")
		X6EMP->(DBCloseArea()) 
	EndIf
	DBSELECTAREA("SM0")
	DBSkip()
EndDo

RestArea(_aSM)

If _bOk            
	If Alltrim(GetMv("MV_PROVPC")) == "Bloqueado"
   		MsgAlert( "Bloqueio realizado com sucesso!!!")
 	Else 
 		If Alltrim(GetMv("MV_PROVPC")) == "Desbloqueado"
   	   		MsgAlert( "Desbloqueio realizado com sucesso!!!") 	
  		EndIf
  	EndIf
Else
	Alert("Foram identificados problemas de integridade no sistema contate o Administrador!!!!")
EndIf


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ ProvPC บAutor  ณ Douglas David        บ Data ณMar็o/2016   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Tela para confirma็ใo do bloqueio/desbloqueio da 		  บฑฑ
ฑฑบ            movimenta็ใo de provis๕es			                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/   

Static Function Dlg1Prov(cTipBloq)

Local oDlg,oSay2,oSay3,oSay4,oSay6,oCombo1,oSBtn11,oSBtn12

oDlg := MSDIALOG():Create()
oDlg:cName := "oDlg"
oDlg:cCaption := "Bloqueio de Movimentos de PC X Provisใo"
oDlg:nLeft := 0
oDlg:nTop := 0
oDlg:nWidth := 315
oDlg:nHeight := 218
oDlg:lShowHint := .F.
oDlg:lCentered := .T.

oSay2 := TSAY():Create(oDlg)
oSay2:cName := "oSay2"
oSay2:cCaption := "Esta rotina destina-se a realizar o bloqueio/desbloqueio de altera็ใo e exclusใo de pedidos de compra, vinculado a uma Provisใo."
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

oSay3:= TSAY():Create(oDlg)
oSay3:cName := "oSay3"
oSay3:cCaption := "Status Atual: "
oSay3:nLeft := 19
oSay3:nTop := 70
oSay3:nWidth := 93
oSay3:nHeight := 17
oSay3:lShowHint := .F.
oSay3:lReadOnly := .F.
oSay3:Align := 0
oSay3:lVisibleControl := .T.
oSay3:lWordWrap := .F.
oSay3:lTransparent := .T.

oSay4:= TSAY():Create(oDlg)
oSay4:cName := "oSay4"
oSay4:cCaption := GetMv("MV_PROVPC")
oSay4:nLeft := 186
oSay4:nTop := 70
oSay4:nWidth := 93
oSay4:nHeight := 17
oSay4:lShowHint := .F.
oSay4:lReadOnly := .F.
oSay4:Align := 0
oSay4:lVisibleControl := .T.
oSay4:lWordWrap := .F.
oSay4:lTransparent := .T.

oSay6 := TSAY():Create(oDlg)
oSay6:cName := "oSay6"
oSay6:cCaption := "Bloqueio?"
oSay6:nLeft := 19
oSay6:nTop := 104
oSay6:nWidth := 93
oSay6:nHeight := 17
oSay6:lShowHint := .F.
oSay6:lReadOnly := .F.
oSay6:Align := 0
oSay6:lVisibleControl := .T.
oSay6:lWordWrap := .F.
oSay6:lTransparent := .T.

oCombo12 := TCOMBOBOX():Create(oDlg)
oCombo12:cName := "oCombo1"
oCombo12:cCaption := "Bloqueio"
oCombo12:nLeft := 184
oCombo12:nTop := 104
oCombo12:nWidth := 78
oCombo12:nHeight := 21
oCombo12:lShowHint := .F.
oCombo12:lReadOnly := .F.
oCombo12:Align := 0
oCombo12:cVariable := "cTipBloq"
oCombo12:bSetGet := {|u| If(PCount()>0,cTipBloq:=u,cTipBloq) }
oCombo12:lVisibleControl := .T.  
oCombo12:aItems := { "Bloqueado","Desbloqueado"}
oCombo12:nAt := 0                             

oSBtn11 := SBUTTON():Create(oDlg)
oSBtn11:cName := "oSBtn11"
oSBtn11:cCaption := "Ok"
oSBtn11:nLeft := 176
oSBtn11:nTop := 150
oSBtn11:nWidth := 52
oSBtn11:nHeight := 22
oSBtn11:lShowHint := .F.
oSBtn11:lReadOnly := .F.
oSBtn11:Align := 0
oSBtn11:lVisibleControl := .T.
oSBtn11:nType := 1
oSBtn11:bAction := {|| AltBlqProv(cTipBloq) }

oSBtn12 := SBUTTON():Create(oDlg)
oSBtn12:cName := "oSBtn12"
oSBtn12:cCaption := "Ok"
oSBtn12:nLeft := 236
oSBtn12:nTop := 150
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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ ProvPC บAutor  ณ Douglas David        บ Data ณMar็o/2016   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Tela para digita็ใo de senha de acesso a rotina 			  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/   


Static Function ProvBlqSenha


Local oDlg_1,Passw,oSBtn5,oSay6   
Local cSenha:=Space(20)
oDlg_1 := MSDIALOG():Create()
oDlg_1:cName := "oDlg_1"
oDlg_1:cCaption := "Valida็ใo de Acesso"
oDlg_1:nLeft := 0
oDlg_1:nTop := 0
oDlg_1:nWidth := 284
oDlg_1:nHeight := 110
oDlg_1:lShowHint := .F.
oDlg_1:lCentered := .T.

Passw := TGET():Create(oDlg_1)
Passw:cName := "Passw"
Passw:cCaption := "Passw"
Passw:nLeft := 111
Passw:nTop := 22
Passw:nWidth := 121
Passw:nHeight := 21
Passw:lShowHint := .F.
Passw:lReadOnly := .F.
Passw:Align := 0
Passw:cVariable := "cSenha"
Passw:bSetGet := {|u| If(PCount()>0,cSenha:=u,cSenha) }
Passw:lVisibleControl := .T.
Passw:lPassword := .T.
Passw:lHasButton := .F.

oSBtn5 := SBUTTON():Create(oDlg_1)
oSBtn5:cName := "oSBtn5"
oSBtn5:cCaption := "Ok"
oSBtn5:nLeft := 209
oSBtn5:nTop := 52
oSBtn5:nWidth := 52
oSBtn5:nHeight := 22
oSBtn5:lShowHint := .F.
oSBtn5:lReadOnly := .F.
oSBtn5:Align := 0
oSBtn5:lVisibleControl := .T.
oSBtn5:nType := 1
oSBtn5:bAction := {|| oDlg_1:END()}

oSay6 := TSAY():Create(oDlg_1)
oSay6:cName := "oSay6"
oSay6:cCaption := "Senha:"
oSay6:nLeft := 33
oSay6:nTop := 23
oSay6:nWidth := 65
oSay6:nHeight := 17
oSay6:lShowHint := .F.
oSay6:lReadOnly := .F.
oSay6:Align := 0
oSay6:lVisibleControl := .T.
oSay6:lWordWrap := .F.
oSay6:lTransparent := .T.

oDlg_1:Activate()

Return cSenha
