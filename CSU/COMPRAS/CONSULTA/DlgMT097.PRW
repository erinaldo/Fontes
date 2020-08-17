#Include "Protheus.ch"
#include "topconn.ch"

User Function DlgMT097()
Local __dDataDe  := dDataBase-30
Local __dDataAte := dDataBase
Local __cTipoApr := 'A-Ambos'
Local __cTexto   := SC7->('PC: '+C7_NUM+'   Emissao: '+DtoC(C7_EMISSAO)+ '   Vlr: R$ '+Transform(C7_TOTAL, "@E 999,999,999.99"))
Local __cTexto2  := SC7->('Comprador: '+Alltrim(UsrFullName(C7_USER)))
Local aQuery     := {}
Local cQuery     := ''
Local nOpcx      := 3 // altera e inclui
Local __cCodLoj  := SC7->(C7_FORNECE+'/'+C7_LOJA)
Local __cNFornec := Posicione("SA2",1,xFilial("SA2")+SC7->(C7_FORNECE+C7_LOJA), "A2_NOME")
Local oFontSay36 := TFont():New("Tahoma",9,,,.T.,,,,,.F.) // Com Negrito 

Local oDlg,oSay1,oGrp2,oSay3,oSay4,oGet5,oGet6,oSBtn8,oGrp9,oGrp10,oCombo12,oSay15,oGet16,oGet17,oSBtn15,oSay16,oSay17,oSay18,oSay19,oGet20,oGet21,oGet22,oGet23,oGrp24,oSay25,oSay26,oSay27,oSay28,oGet29,oGet30,oGet31,oGet32,oBmp33,oGrp35,oSay36,oSBtn37,oSay38
// Alimentando dados para exibiÁ„o no GetDados
// alimentando a GetDados
//+--------------------------------------------------------------+
//¶ Montando aHeader para a Multiline                            ¶
//+--------------------------------------------------------------+
Local aAltGetD    := {}
lDelGetD := .f.
nUsado  := 0
aHeader := {}
aCols   := {}
Private n30uTot := 0 // total em valor dos ultimos 30 dias
Private n30uQPC := 0 // quantidade de pedidos de compras
Private n30uAvg := 0 // medio do total pela quantidade de pc
Private n30uMPC := 0 // maior pedido de compras em valor

Private nParTot := 0 // total em valor pelas datas dos parametros
Private nParQPC := 0 // quantidade de pedidos de compras
Private nParAvg := 0 // medio do total pela quantidade de pc
Private nParMPC := 0 // maior pedido de compras em valor

dbSelectArea("SX3")
dbSetOrder(2)
If dbSeek("C7_NUM")
	nUsado++
	AADD(aHeader,{ TRIM(X3Titulo()), x3_campo, x3_picture,;
	x3_tamanho, x3_decimal,x3_valid,;
	x3_usado, x3_tipo, x3_arquivo, x3_context } )
	aAdd(aAltGetD, AllTrim(SX3->X3_CAMPO))
	aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
EndIf
If dbSeek("C7_TOTAL")
	nUsado++
	AADD(aHeader,{ TRIM(X3Titulo()), x3_campo, x3_picture,;
	x3_tamanho, x3_decimal,".T.",;
	x3_usado, x3_tipo, x3_arquivo, x3_context } )
	aadd(aQuery,{"SUM("+AllTrim(SX3->X3_CAMPO)+")",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
EndIf
If dbSeek("C7_EMISSAO")
	nUsado++
	AADD(aHeader,{ TRIM(X3Titulo()), x3_campo, x3_picture,;
	x3_tamanho, x3_decimal,".T.",;
	x3_usado, x3_tipo, x3_arquivo, x3_context } )
	aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
EndIf
If dbSeek("C7_CONAPRO")
	nUsado++
	AADD(aHeader,{ TRIM(X3Titulo()), x3_campo, x3_picture,;
	10, x3_decimal,".T.",;
	x3_usado, x3_tipo, x3_arquivo, x3_context } )
	aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
EndIf
If dbSeek("C7_USER")
	nUsado++
	AADD(aHeader,{ "Comprador", x3_campo, x3_picture,;
	30, x3_decimal,".T.",;
	x3_usado, x3_tipo, x3_arquivo, x3_context } )
	aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
EndIf
If dbSeek("C7_APROV")
	nUsado++
	AADD(aHeader,{ "Ult Aprovado", x3_campo, x3_picture,;
	30, x3_decimal,".T.",;
	x3_usado, x3_tipo, x3_arquivo, x3_context } )
	aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
EndIf
If dbSeek("CR_DATALIB")
	nUsado++
	AADD(aHeader,{ TRIM(X3Titulo()), x3_campo, x3_picture,;
	x3_tamanho, x3_decimal,".T.",;
	x3_usado, x3_tipo, x3_arquivo, x3_context } )
	//	aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
EndIf

//Funcao para alimentar o acols
fCalcRes(aQuery, @aCols, __dDataDe, __dDataAte, aHeader, __cTipoApr, .t.  )

// Criando a tela de dialogo
oDlg := MSDIALOG():Create()
oDlg:cName := "oDlg"
oDlg:cCaption := "Consulta Resumo de Fornecedor"
oDlg:nLeft := 0
oDlg:nTop := 0
oDlg:nWidth := 616
oDlg:nHeight := 547
oDlg:lShowHint := .F.
oDlg:lCentered := .T.

oSay1 := TSAY():Create(oDlg)
oSay1:cName := "oSay1"
oSay1:cCaption := "Data de"
oSay1:nLeft := 35
oSay1:nTop := 35
oSay1:nWidth := 65
oSay1:nHeight := 17
oSay1:lShowHint := .F.
oSay1:lReadOnly := .F.
oSay1:Align := 0
oSay1:lVisibleControl := .T.
oSay1:lWordWrap := .F.
oSay1:lTransparent := .F.

oGrp2 := TGROUP():Create(oDlg)
oGrp2:cName := "oGrp2"
oGrp2:cCaption := "Parametros"
oGrp2:nLeft := 18
oGrp2:nTop := 15
oGrp2:nWidth := 384
oGrp2:nHeight := 131
oGrp2:lShowHint := .F.
oGrp2:lReadOnly := .F.
oGrp2:Align := 0
oGrp2:lVisibleControl := .T.

oSay3 := TSAY():Create(oDlg)
oSay3:cName := "oSay3"
oSay3:cCaption := "Data ate"
oSay3:nLeft := 208
oSay3:nTop := 34
oSay3:nWidth := 65
oSay3:nHeight := 17
oSay3:lShowHint := .F.
oSay3:lReadOnly := .F.
oSay3:Align := 0
oSay3:lVisibleControl := .T.
oSay3:lWordWrap := .F.
oSay3:lTransparent := .F.

oSay4 := TSAY():Create(oDlg)
oSay4:cName := "oSay4"
oSay4:cCaption := "Tipo"
oSay4:nLeft := 35
oSay4:nTop := 61
oSay4:nWidth := 65
oSay4:nHeight := 17
oSay4:lShowHint := .F.
oSay4:lReadOnly := .F.
oSay4:Align := 0
oSay4:lVisibleControl := .T.
oSay4:lWordWrap := .F.
oSay4:lTransparent := .F.

oGet5 := TGET():Create(oDlg)
oGet5:cName := "oGet5"
oGet5:nLeft := 79
oGet5:nTop := 32
oGet5:nWidth := 121
oGet5:nHeight := 21
oGet5:lShowHint := .F.
oGet5:lReadOnly := .F.
oGet5:Align := 0
oGet5:cVariable := "__dDataDe"
oGet5:bSetGet := {|u| If(PCount()>0,__dDataDe:=u,__dDataDe) }
oGet5:lVisibleControl := .T.
oGet5:lPassword := .F.
oGet5:lHasButton := .F.
oGet5:bValid := {|| !Empty(__dDataDe) }

oGet6 := TGET():Create(oDlg)
oGet6:cName := "oGet6"
oGet6:nLeft := 261
oGet6:nTop := 31
oGet6:nWidth := 121
oGet6:nHeight := 21
oGet6:lShowHint := .F.
oGet6:lReadOnly := .F.
oGet6:Align := 0
oGet6:cVariable := "__dDataAte"
oGet6:bSetGet := {|u| If(PCount()>0,__dDataAte:=u,__dDataAte) }
oGet6:lVisibleControl := .T.
oGet6:lPassword := .F.
oGet6:lHasButton := .F.
oGet6:bValid := {|| !Empty(__dDataAte) }

oSBtn8 := SBUTTON():Create(oDlg)
oSBtn8:cName := "oSBtn8"
oSBtn8:nLeft := 328
oSBtn8:nTop := 56
oSBtn8:nWidth := 52
oSBtn8:nHeight := 22
oSBtn8:lShowHint := .F.
oSBtn8:lReadOnly := .F.
oSBtn8:Align := 0
oSBtn8:lVisibleControl := .T.
oSBtn8:nType := 1
oSBtn8:bLClicked := {|| fCalcRes(aQuery, aCols, __dDataDe, __dDataAte, aHeader, __cTipoApr  ) }

oGrp9 := TGROUP():Create(oDlg)
oGrp9:cName := "oGrp9"
oGrp9:cCaption := "Resumo"
oGrp9:nLeft := 16
oGrp9:nTop := 150
oGrp9:nWidth := 581
oGrp9:nHeight := 155
oGrp9:lShowHint := .F.
oGrp9:lReadOnly := .F.
oGrp9:Align := 0
oGrp9:lVisibleControl := .T.

oGrp10 := TGROUP():Create(oDlg)
oGrp10:cName := "oGrp10"
oGrp10:cCaption := "Total de PCs nos 30 ultimos dias"
oGrp10:nLeft := 16
oGrp10:nTop := 306
oGrp10:nWidth := 273
oGrp10:nHeight := 119
oGrp10:lShowHint := .F.
oGrp10:lReadOnly := .F.
oGrp10:Align := 0
oGrp10:lVisibleControl := .T.

oCombo12 := TCOMBOBOX():Create(oDlg)
oCombo12:cName := "oCombo12"
oCombo12:cCaption := "oCombo12"
oCombo12:nLeft := 79
oCombo12:nTop := 57
oCombo12:nWidth := 144
oCombo12:nHeight := 21
oCombo12:lShowHint := .F.
oCombo12:lReadOnly := .F.
oCombo12:Align := 0
oCombo12:cVariable := "__cTipoApr"
oCombo12:bSetGet := {|u| If(PCount()>0,__cTipoApr:=u,__cTipoApr) }
oCombo12:lVisibleControl := .T.
oCombo12:aItems := { "A-Ambos","L-Liberados","B-Bloqueados"}
oCombo12:nAt := 0

oSay15 := TSAY():Create(oDlg)
oSay15:cName := "oSay15"
oSay15:cCaption := "Fornecedor/Loja"
oSay15:nLeft := 31
oSay15:nTop := 91
oSay15:nWidth := 96
oSay15:nHeight := 17
oSay15:lShowHint := .F.
oSay15:lReadOnly := .F.
oSay15:Align := 0
oSay15:lVisibleControl := .T.
oSay15:lWordWrap := .F.
oSay15:lTransparent := .F.

oGet16 := TGET():Create(oDlg)
oGet16:cName := "oGet16"
oGet16:nLeft := 120
oGet16:nTop := 87
oGet16:nWidth := 116
oGet16:nHeight := 21
oGet16:lShowHint := .F.
oGet16:lReadOnly := .F.
oGet16:Align := 0
oGet16:cVariable := "__cCodLoj"
oGet16:bSetGet := {|u| If(PCount()>0,__cCodLoj:=u,__cCodLoj) }
oGet16:lVisibleControl := .T.
oGet16:lPassword := .F.
oGet16:lHasButton := .F.
oGet16:bWhen := {|| .f. }

oGet17 := TGET():Create(oDlg)
oGet17:cName := "oGet17"
oGet17:cCaption := "oGet17"
oGet17:nLeft := 120
oGet17:nTop := 112
oGet17:nWidth := 263
oGet17:nHeight := 21
oGet17:lShowHint := .F.
oGet17:lReadOnly := .F.
oGet17:Align := 0
oGet17:cVariable := "__cNFornec"
oGet17:bSetGet := {|u| If(PCount()>0,__cNFornec:=u,__cNFornec) }
oGet17:lVisibleControl := .T.
oGet17:lPassword := .F.
oGet17:Picture := "@S30"
oGet17:lHasButton := .F.
oGet17:bWhen := {|| .F. }

oSBtn15 := SBUTTON():Create(oDlg)
oSBtn15:cName := "oSBtn15"
oSBtn15:nLeft := 417
oSBtn15:nTop := 125
oSBtn15:nWidth := 81
oSBtn15:nHeight := 22
oSBtn15:lShowHint := .F.
oSBtn15:lReadOnly := .F.
oSBtn15:Align := 0
oSBtn15:lVisibleControl := .T.
oSBtn15:nType := 2
oSBtn15:bLClicked := {|| oDlg:End() }

oSay16 := TSAY():Create(oDlg)
oSay16:cName := "oSay16"
oSay16:cCaption := "Total Vlr"
oSay16:nLeft := 29
oSay16:nTop := 327
oSay16:nWidth := 65
oSay16:nHeight := 17
oSay16:lShowHint := .F.
oSay16:lReadOnly := .F.
oSay16:Align := 0
oSay16:lVisibleControl := .T.
oSay16:lWordWrap := .F.
oSay16:lTransparent := .F.

oSay17 := TSAY():Create(oDlg)
oSay17:cName := "oSay17"
oSay17:cCaption := "Qtde PCs"
oSay17:nLeft := 31
oSay17:nTop := 347
oSay17:nWidth := 65
oSay17:nHeight := 17
oSay17:lShowHint := .F.
oSay17:lReadOnly := .F.
oSay17:Align := 0
oSay17:lVisibleControl := .T.
oSay17:lWordWrap := .F.
oSay17:lTransparent := .F.

oSay18 := TSAY():Create(oDlg)
oSay18:cName := "oSay18"
oSay18:cCaption := "Total Vlr/Qtde PCs"
oSay18:nLeft := 30
oSay18:nTop := 369
oSay18:nWidth := 110
oSay18:nHeight := 17
oSay18:lShowHint := .F.
oSay18:lReadOnly := .F.
oSay18:Align := 0
oSay18:lVisibleControl := .T.
oSay18:lWordWrap := .F.
oSay18:lTransparent := .F.

oSay19 := TSAY():Create(oDlg)
oSay19:cName := "oSay19"
oSay19:cCaption := "Maior Compra"
oSay19:nLeft := 30
oSay19:nTop := 392
oSay19:nWidth := 69
oSay19:nHeight := 17
oSay19:lShowHint := .F.
oSay19:lReadOnly := .F.
oSay19:Align := 0
oSay19:lVisibleControl := .T.
oSay19:lWordWrap := .F.
oSay19:lTransparent := .F.

oGet20 := TGET():Create(oDlg)
oGet20:cName := "oGet20"
oGet20:cCaption := "oGet20"
oGet20:nLeft := 158
oGet20:nTop := 320
oGet20:nWidth := 121
oGet20:nHeight := 21
oGet20:lShowHint := .F.
oGet20:lReadOnly := .F.
oGet20:Align := 0
oGet20:cVariable := "n30uTot"
oGet20:bSetGet := {|u| If(PCount()>0,n30uTot:=u,n30uTot) }
oGet20:lVisibleControl := .T.
oGet20:lPassword := .F.
oGet20:Picture := "@E 999,999,999.99"
oGet20:lHasButton := .F.
oGet20:bWhen := {|| .f. }

oGet21 := TGET():Create(oDlg)
oGet21:cName := "oGet21"
oGet21:cCaption := "oGet21"
oGet21:nLeft := 158
oGet21:nTop := 345
oGet21:nWidth := 121
oGet21:nHeight := 21
oGet21:lShowHint := .F.
oGet21:lReadOnly := .F.
oGet21:Align := 0
oGet21:cVariable := "n30uQPC"
oGet21:bSetGet := {|u| If(PCount()>0,n30uQPC:=u,n30uQPC) }
oGet21:lVisibleControl := .T.
oGet21:lPassword := .F.
oGet21:Picture := "@E 999,999,999.99"
oGet21:lHasButton := .F.
oGet21:bWhen := {|| .f. }

oGet22 := TGET():Create(oDlg)
oGet22:cName := "oGet22"
oGet22:cCaption := "oGet22"
oGet22:nLeft := 158
oGet22:nTop := 369
oGet22:nWidth := 121
oGet22:nHeight := 21
oGet22:lShowHint := .F.
oGet22:lReadOnly := .F.
oGet22:Align := 0
oGet22:cVariable := "n30uAvg"
oGet22:bSetGet := {|u| If(PCount()>0,n30uAvg:=u,n30uAvg) }
oGet22:lVisibleControl := .T.
oGet22:lPassword := .F.
oGet22:Picture := "@E 999,999,999.99"
oGet22:lHasButton := .F.
oGet22:bWhen := {|| .f. }

oGet23 := TGET():Create(oDlg)
oGet23:cName := "oGet23"
oGet23:cCaption := "oGet23"
oGet23:nLeft := 158
oGet23:nTop := 394
oGet23:nWidth := 121
oGet23:nHeight := 21
oGet23:lShowHint := .F.
oGet23:lReadOnly := .F.
oGet23:Align := 0
oGet23:cVariable := "n30uMPC"
oGet23:bSetGet := {|u| If(PCount()>0,n30uMPC:=u,n30uMPC) }
oGet23:lVisibleControl := .T.
oGet23:lPassword := .F.
oGet23:Picture := "@E 999,999,999.99"
oGet23:lHasButton := .F.
oGet23:bWhen := {|| .f. }

oGrp24 := TGROUP():Create(oDlg)
oGrp24:cName := "oGrp24"
oGrp24:cCaption := "Total de PCs dos dias do parametro"
oGrp24:nLeft := 323
oGrp24:nTop := 307
oGrp24:nWidth := 273
oGrp24:nHeight := 120
oGrp24:lShowHint := .F.
oGrp24:lReadOnly := .F.
oGrp24:Align := 0
oGrp24:lVisibleControl := .T.

oSay25 := TSAY():Create(oDlg)
oSay25:cName := "oSay25"
oSay25:cCaption := "Total Vlr"
oSay25:nLeft := 344
oSay25:nTop := 326
oSay25:nWidth := 65
oSay25:nHeight := 17
oSay25:lShowHint := .F.
oSay25:lReadOnly := .F.
oSay25:Align := 0
oSay25:lVisibleControl := .T.
oSay25:lWordWrap := .F.
oSay25:lTransparent := .F.

oSay26 := TSAY():Create(oDlg)
oSay26:cName := "oSay26"
oSay26:cCaption := "Qtde PCs"
oSay26:nLeft := 344
oSay26:nTop := 347
oSay26:nWidth := 65
oSay26:nHeight := 17
oSay26:lShowHint := .F.
oSay26:lReadOnly := .F.
oSay26:Align := 0
oSay26:lVisibleControl := .T.
oSay26:lWordWrap := .F.
oSay26:lTransparent := .F.

oSay27 := TSAY():Create(oDlg)
oSay27:cName := "oSay27"
oSay27:cCaption := "Total Vlr/Qtde PCs"
oSay27:nLeft := 344
oSay27:nTop := 371
oSay27:nWidth := 112
oSay27:nHeight := 17
oSay27:lShowHint := .F.
oSay27:lReadOnly := .F.
oSay27:Align := 0
oSay27:lVisibleControl := .T.
oSay27:lWordWrap := .F.
oSay27:lTransparent := .F.

oSay28 := TSAY():Create(oDlg)
oSay28:cName := "oSay28"
oSay28:cCaption := "Maior Compra"
oSay28:nLeft := 346
oSay28:nTop := 398
oSay28:nWidth := 71
oSay28:nHeight := 17
oSay28:lShowHint := .F.
oSay28:lReadOnly := .F.
oSay28:Align := 0
oSay28:lVisibleControl := .T.
oSay28:lWordWrap := .F.
oSay28:lTransparent := .F.

oGet29 := TGET():Create(oDlg)
oGet29:cName := "oGet29"
oGet29:cCaption := "oGet29"
oGet29:nLeft := 466
oGet29:nTop := 321
oGet29:nWidth := 121
oGet29:nHeight := 21
oGet29:lShowHint := .F.
oGet29:lReadOnly := .F.
oGet29:Align := 0
oGet29:cVariable := "nParTot"
oGet29:bSetGet := {|u| If(PCount()>0,nParTot:=u,nParTot) }
oGet29:lVisibleControl := .T.
oGet29:lPassword := .F.
oGet29:Picture := "@E 999,999,999.99"
oGet29:lHasButton := .F.
oGet29:bWhen := {|| .f. }

oGet30 := TGET():Create(oDlg)
oGet30:cName := "oGet30"
oGet30:cCaption := "oGet30"
oGet30:nLeft := 466
oGet30:nTop := 348
oGet30:nWidth := 121
oGet30:nHeight := 21
oGet30:lShowHint := .F.
oGet30:lReadOnly := .F.
oGet30:Align := 0
oGet30:cVariable := "nParQPC"
oGet30:bSetGet := {|u| If(PCount()>0,nParQPC:=u,nParQPC) }
oGet30:lVisibleControl := .T.
oGet30:lPassword := .F.
oGet30:Picture := "@E 999,999,999.99"
oGet30:lHasButton := .F.
oGet30:bWhen := {|| .f. }

oGet31 := TGET():Create(oDlg)
oGet31:cName := "oGet31"
oGet31:cCaption := "oGet31"
oGet31:nLeft := 466
oGet31:nTop := 372
oGet31:nWidth := 121
oGet31:nHeight := 21
oGet31:lShowHint := .F.
oGet31:lReadOnly := .F.
oGet31:Align := 0
oGet31:cVariable := "nParAvg"
oGet31:bSetGet := {|u| If(PCount()>0,nParAvg:=u,nParAvg) }
oGet31:lVisibleControl := .T.
oGet31:lPassword := .F.
oGet31:Picture := "@E 999,999,999.99"
oGet31:lHasButton := .F.
oGet31:bWhen := {|| .f. }

oGet32 := TGET():Create(oDlg)
oGet32:cName := "oGet32"
oGet32:cCaption := "oGet32"
oGet32:nLeft := 465
oGet32:nTop := 397
oGet32:nWidth := 121
oGet32:nHeight := 21
oGet32:lShowHint := .F.
oGet32:lReadOnly := .F.
oGet32:Align := 0
oGet32:cVariable := "nParMPC"
oGet32:bSetGet := {|u| If(PCount()>0,nParMPC:=u,nParMPC) }
oGet32:lVisibleControl := .T.
oGet32:lPassword := .F.
oGet32:Picture := "@E 999,999,999.99"
oGet32:lHasButton := .F.
oGet32:bWhen := {|| .f. }

oBmp33 := TBITMAP():Create(oDlg)
oBmp33:cName := "oBmp33"
oBmp33:cCaption := "oBmp33"
oBmp33:nLeft := 420
oBmp33:nTop := 20
oBmp33:nWidth := 173
oBmp33:nHeight := 100
oBmp33:lShowHint := .F.
oBmp33:lReadOnly := .F.
oBmp33:Align := 0
oBmp33:lVisibleControl := .T.
oBmp33:cBmpFile := "CSU.BMP"
oBmp33:lStretch := .F.
oBmp33:lAutoSize := .F.

oGrp35 := TGROUP():Create(oDlg)
oGrp35:cName := "oGrp35"
oGrp35:cCaption := "Pedido de Compra em AprovaÁ„o"
oGrp35:nLeft := 17
oGrp35:nTop := 427
oGrp35:nWidth := 580
oGrp35:nHeight := 78
oGrp35:lShowHint := .F.
oGrp35:lReadOnly := .F.
oGrp35:Align := 0
oGrp35:lVisibleControl := .T.

oSay36 := TSAY():Create(oDlg)
oSay36:cName := "oSay36"
oSay36:cCaption := __cTexto
oSay36:nLeft := 27
oSay36:nTop := 446
oSay36:nWidth := 564
oSay36:nHeight := 17
oSay36:lShowHint := .F.
oSay36:lReadOnly := .F.
oSay36:Align := 0
oSay36:lVisibleControl := .T.
oSay36:lWordWrap := .F.
oSay36:lTransparent := .F.
oSay36:oFont:=oFontSay36

oSBtn37 := SBUTTON():Create(oDlg)
oSBtn37:cName := "oSBtn37"
oSBtn37:cCaption := "oSBtn37"
oSBtn37:nLeft := 328
oSBtn37:nTop := 80
oSBtn37:nWidth := 52
oSBtn37:nHeight := 22
oSBtn37:lShowHint := .F.
oSBtn37:lReadOnly := .F.
oSBtn37:Align := 0
oSBtn37:lVisibleControl := .T.
oSBtn37:nType := 15
oSBtn37:bLClicked := {|| fViewPC() }

oSay38 := TSAY():Create(oDlg)
oSay38:cName := "oSay38"
oSay38:cCaption := __cTexto2
oSay38:nLeft := 25
oSay38:nTop := 468
oSay38:nWidth := 560
oSay38:nHeight := 17
oSay38:lShowHint := .F.
oSay38:lReadOnly := .F.
oSay38:Align := 0
oSay38:lVisibleControl := .T.
oSay38:lWordWrap := .F.
oSay38:lTransparent := .F.
oSay38:oFont:=oFontSay36

// GetDados
aCGD     := {85,13,145,295}
cLinhaOk := ".t."
cTudoOk  := ".T."
aC       := {}
aR       := {}
oGetDados:=MSGetDados():New(aCGD[1],aCGD[2],aCGD[3],aCGD[4],nOpcX,cLinhaOk,cTudoOk,,lDelGetD,aAltGetD, , , ,)

//Mensagem de ropade


oDlg:Activate()

Return(nil)

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Funcao    ≥ QryArr   ∫Autor  ≥ Silvio Cazela      ∫ Data ≥ 21/06/2001  ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ Funcao para rodar uma Query e retornar como Array          ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Parametros≥ cQuery - Query SQL a ser executado                         ∫±±
±±∫Retorno   ≥ aTrb   - Array com o conteudo da Query                     ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP5                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
User Function QryArray(cQuery)

//…ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕª
//∫ Gravacao do Ambiente Atual e Variaveis para Utilizacao                   ∫
//»ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕSilvio CazelaÕº
Private aRet    := {}
Private aRet1   := {}
Private nRegAtu := 0
Private x       := 0

//…ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕª
//∫ Ajustes e Execucao da Query                                              ∫
//»ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕSilvio CazelaÕº
//cQuery := ChangeQuery(cQuery)
TCQUERY cQuery NEW ALIAS "_TRB"

//…ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕª
//∫ Montagem do Array para Retorno                                           ∫
//»ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕSilvio CazelaÕº
DbSelectArea("_TRB")
aRet1   := Array(fcount())
nRegAtu := 1

While !eof()
	For x:=1 to fcount()
		aRet1[x] := FieldGet(x)
	Next
	AADD(aRet,aclone(aRet1))
	DbSkip()
	nRegAtu += 1
Enddo

//…ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕª
//∫ Encerra Query e Retorna Ambiente                                         ∫
//»ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕSilvio CazelaÕº
DbSelectArea("_TRB")
_TRB->(DbCloseArea())

Return(aRet)
/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Final da Funcao : QryArr                                               ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥DLGMT097  ∫Autor  ≥Microsiga           ∫ Data ≥  01/23/07   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
Parametros
aQuery - Array contendo os campos que seram utilizados no select
aCols - Array com o conteudo do aCols ( linhas )
__dDataDe - variavel com a data inicial de pesquisa
__dDataAte - variavel com a data final de pesquisa
aHeader - Array com o conteudo do aHeader
__cTipoApr - tipo de aprovacao L-Liberado, B-Bloqueado, A-Ambos
__lFlagCalc - para saber se calcula ou nao os dados das variaveis dos ultimos 30 dias "n30u"
*/

Static Function fCalcRes(aQuery, aCols, __dDataDe, __dDataAte, aHeader, __cTipoApr, _lFlagCalc  )
Local cQuery := ''
Local __cTPApro :=SubStr(__cTipoApr,1,1)

nParTot := 0 // total em valor pelas datas dos parametros
nParQPC := 0 // quantidade de pedidos de compras
nParAvg := 0 // medio do total pela quantidade de pc
nParMPC := 0 // maior pedido de compras em valor

aCols := {}  // Zerando acols
// alimentando dados
//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Varre os registros e marca o flag                            ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
aEval(aQuery,{|x| cQuery += ","+AllTrim(x[1])})
cQuery := "SELECT "+SubStr(cQuery,2)+", '  ' AS CR_DATALIB, ' ' AS LOGI"+Chr(13)
cQuery += "FROM "+RetSqlName("SC7")+" SC7 "+Chr(13)
cQuery += "WHERE SC7.C7_FILIAL = '"+xFilial("SC7")+"'"+Chr(13)
cQuery += "AND SC7.C7_FORNECE = '"+SC7->C7_FORNECE+"'"+Chr(13)
cQuery += "AND SC7.C7_LOJA = '"+SC7->C7_LOJA+"'"+Chr(13)
cQuery += "AND SC7.C7_EMISSAO BETWEEN '"+DtoS(__dDataDe)+"' AND '"+DtoS(__dDataAte)+"'"+Chr(13)
// Nao trazer na query o pedido que vai ser aprovado
cQuery += "AND SC7.C7_NUM <> '"+SC7->C7_NUM+"'"+Chr(13)
If __cTPApro <> 'A'
	cQuery += "AND SC7.C7_CONAPRO = '"+__cTPApro+"'"+Chr(13)
EndIf
cQuery += "AND SC7.C7_RESIDUO <> 'S'"+Chr(13)
cQuery += "AND SC7.D_E_L_E_T_ <> '*'"+Chr(13)
cQuery += "GROUP BY C7_NUM,C7_EMISSAO,C7_CONAPRO,C7_USER,C7_APROV"+Chr(13)
cQuery += "ORDER BY SC7.C7_NUM"+Chr(13)

MemoWrit( "C:\DLGMT097.sql", cQuery )
aQryRes := U_QryArray( cQuery )

dbSelectArea("SC7")

nLen := Len( aQuery )+2
If Len( aQryRes ) > 0
	aCols := aClone(aQryRes)
	for _Cont := 1 to Len( aQryRes )
		//Gravando o nome do comprador
		nPosCompr := aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "C7_USER"})
		cNomCompr := UsrFullName(aCols[_Cont, nPosCompr])
		aCols[_Cont, nPosCompr] := cNomCompr
		//Gravando o nome do ultimo aprovador
		nPosCompr := aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "C7_APROV"})
		cNomCompr := UsrFullName(aCols[_Cont, nPosCompr])
		aCols[_Cont, nPosCompr] := cNomCompr
		//Gravando o status, trocando de letra pode texto
		nPosCompr := aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "C7_CONAPRO"})
		cNomCompr := If(aCols[_Cont, nPosCompr] == 'L', 'Liberado', 'Bloqueado' )
		aCols[_Cont, nPosCompr] := cNomCompr
		
		//Data de Emissao
		__dEmissao := aCols[_Cont, aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "C7_EMISSAO"})]
		aCols[_Cont, aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "C7_EMISSAO"})] := StoD(__dEmissao)
		//Guardando o nr do pedido de compras
		__cNumPC  := aCols[_Cont, aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "C7_NUM"})]
		__cFilial := xFilial("SC7")
		__dDataUlt:= aCols[_Cont, aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "CR_DATALIB"})]
		__cUltApr := aCols[_Cont, aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "C7_APROV"})]
		
		__nVlrPC := aCols[_Cont, aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "C7_TOTAL"})]
		
		If _lFlagCalc
			n30uTot += __nVlrPC // total em valor dos ultimos 30 dias
			n30uQPC++// quantidade de pedidos de compras
			n30uAvg := n30uTot/n30uQPC // medio do total pela quantidade de pc
			n30uMPC := if(__nVlrPC > n30uMPC, __nVlrPC, n30uMPC) // maior pedido de compras em valor
		EndIf
		nParTot += __nVlrPC // total em valor pelas datas dos parametros
		nParQPC++ // quantidade de pedidos de compras
		nParAvg := nParTot/nParQPC // medio do total pela quantidade de pc
		nParMPC := if(__nVlrPC > nParMPC, __nVlrPC, nParMPC) // maior pedido de compras em valor
		
		// funcao para saber quem È o ultimo aprovador e quando foi a sua aprovacao
		fUltAprov(@__dDataUlt, @__cUltApr, __cFilial, __cNumPC )
		
		//regravando nome e data do ultimo aprovador
		aCols[_Cont, aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "CR_DATALIB"})] := StoD(__dDataUlt)
		aCols[_Cont, aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "C7_APROV"})]   := UsrFullName(__cUltApr)
		
		// Marcando o flag de delecao
		aCols[_Cont,nLen] := .f.
	Next
EndIf
Return(Nil)

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥DLGMT097  ∫Autor  ≥Microsiga           ∫ Data ≥  01/23/07   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

Static Function fUltAprov(__dDataUlt, __cUltApr, __cFilial, __cNumPC )
Local cQuery := ''
Local aQuery := {}
Local aArea := GetArea()

cQuery := "SELECT TOP 1 CR_DATALIB, CR_USER"+Chr(13)
cQuery += "FROM "+RetSqlName("SCR")+Chr(13)
cQuery += "WHERE CR_FILIAL = '"+__cFilial+"'"+Chr(13)
cQuery += "AND CR_NUM = '"+__cNumPC+"'"+Chr(13)
cQuery += "AND CR_TIPO = 'PC'"+Chr(13)
cQuery += "AND D_E_L_E_T_ <> '*'"+Chr(13)
cQuery += "ORDER BY CR_DATALIB DESC"+Chr(13)

aQuery := U_QryArray(cQuery)
If Len(aQuery) > 0
	__dDataUlt := aQuery[1,1]
	__cUltApr  := aQuery[1,2]
Else
	__dDataUlt := '  /  /  '
	__cUltApr  := ' '
EndIf
RestArea(aArea)
Return(nil)


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥DLGMT097  ∫Autor  ≥Microsiga           ∫ Data ≥  01/24/07   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

Static Function FViewPC()
Local aArea := GetArea() 
Local nOpcx := 2
Local cAlias := "SCR"
Local nReg := SCR->(Recno())

A097Visual(cAlias,nReg,nOpcx) // Chama Consulta do Pedido

RestArea(aArea)

Return(nil)
/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥DLGMT097  ∫Autor  ≥Microsiga           ∫ Data ≥  01/23/07   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/


Static Function NewDlg1()
/*
A tag abaixo define a criaÁ„o e ativaÁ„o do novo di·logo. VocÍ pode colocar esta tag
onde quer que deseje em seu cÛdigo fonte. A linha exata onde esta tag se encontra, definir·
quando o di·logo ser· exibido ao usu·rio.
Nota: Todos os objetos definidos no di·logo ser„o declarados como Local no escopo da
funÁ„o onde a tag se encontra no cÛdigo fonte.
*/

//$BEGINDIALOGDEF_oDlg
/*/======================================================
// These information were generated automatically by AP  
// IDE. DO NOT change anything in these information under
// any circumstance. Otherwise, it can mean loss of data 
// or the dialog invalidation by the MP8 IDE.
//-------------------------------------------------------
//$DIALOGINFO=312E30,3131323038,393536393737313639,3237373936,31353734383832303434
//$DIALOGDATA=3337B74D534449414C4F47B76F446C67B73136B743B7634E616D65B76F446C67B743B76343617074696F6EB7436F6E73756C746120526573756D6F20646520466F726E656365646F72B743B7634D7367B7B743B763546F6F6C546970B7B74EB76E4C656674B730B74EB76E546F70B730B74EB76E5769647468B7363136B74EB76E486569676874B7353437B74CB76C53686F7748696E74B730B74CB76C43656E7465726564B731B745B7625768656EB7B745B76256616C6964B7B745B7624C436C69636B6564B7B745B76252436C69636B6564B7B745B7624C44626C436C69636BB7B745B762496E6974B7B754534159B76F446C67B73231B743B7634E616D65B76F53617931B743B76343617074696F6EB744617461206465B743B7634D7367B7B743B763546F6F6C546970B7B74EB76E4C656674B73335B74EB76E546F70B73335B74EB76E5769647468B73635B74EB76E486569676874B73137B74CB76C53686F7748696E74B730B74CB76C526561644F6E6C79B730B74EB7416C69676EB730B743B7635661726961626C65B7B74CB76C56697369626C65436F6E74726F6CB731B74CB76C576F726457726170B730B74CB76C5472616E73706172656E74B730B745B7625768656EB7B745B76256616C6964B7B745B7624C436C69636B6564B7B745B76252436C69636B6564B7B745B7624C44626C436C69636BB7B745B7624368616E6765B7B75447524F5550B76F446C67B73139B743B7634E616D65B76F47727032B743B76343617074696F6EB7506172616D6574726F73B743B7634D7367B7B743B763546F6F6C546970B7B74EB76E4C656674B73138B74EB76E546F70B73135B74EB76E5769647468B7333834B74EB76E486569676874B7313331B74CB76C53686F7748696E74B730B74CB76C526561644F6E6C79B730B74EB7416C69676EB730B743B7635661726961626C65B7B74CB76C56697369626C65436F6E74726F6CB731B745B7625768656EB7B745B76256616C6964B7B745B7624C436C69636B6564B7B745B76252436C69636B6564B7B745B7624C44626C436C69636BB7B745B7624368616E6765B7B754534159B76F446C67B73231B743B7634E616D65B76F53617933B743B76343617074696F6EB74461746120617465B743B7634D7367B7B743B763546F6F6C546970B7B74EB76E4C656674B7323038B74EB76E546F70B73334B74EB76E5769647468B73635B74EB76E486569676874B73137B74CB76C53686F7748696E74B730B74CB76C526561644F6E6C79B730B74EB7416C69676EB730B743B7635661726961626C65B7B74CB76C56697369626C65436F6E74726F6CB731B74CB76C576F726457726170B730B74CB76C5472616E73706172656E74B730B745B7625768656EB7B745B76256616C6964B7B745B7624C436C69636B6564B7B745B76252436C69636B6564B7B745B7624C44626C436C69636BB7B745B7624368616E6765B7B754534159B76F446C67B73231B743B7634E616D65B76F53617934B743B76343617074696F6EB75469706FB743B7634D7367B7B743B763546F6F6C546970B7B74EB76E4C656674B73335B74EB76E546F70B73631B74EB76E5769647468B73635B74EB76E486569676874B73137B74CB76C53686F7748696E74B730B74CB76C526561644F6E6C79B730B74EB7416C69676EB730B743B7635661726961626C65B7B74CB76C56697369626C65436F6E74726F6CB731B74CB76C576F726457726170B730B74CB76C5472616E73706172656E74B730B745B7625768656EB7B745B76256616C6964B7B745B7624C436C69636B6564B7B745B76252436C69636B6564B7B745B7624C44626C436C69636BB7B745B7624368616E6765B7B754474554B76F446C67B73234B743B7634E616D65B76F47657435B743B76343617074696F6EB7B743B7634D7367B7B743B763546F6F6C546970B7B74EB76E4C656674B73739B74EB76E546F70B73332B74EB76E5769647468B7313231B74EB76E486569676874B73231B74CB76C53686F7748696E74B730B74CB76C526561644F6E6C79B730B74EB7416C69676EB730B743B7635661726961626C65B75F5F64446174614465B74CB76C56697369626C65436F6E74726F6CB731B743B7634633B7B74CB76C50617373776F7264B730B743B750696374757265B7B74CB76C486173427574746F6EB730B745B7625768656EB7B745B76256616C6964B721456D707479285F5F6444617461446529B745B7624C436C69636B6564B7B745B76252436C69636B6564B7B745B7624C44626C436C69636BB7B745B7624368616E6765B7B745B7624633B7B754474554B76F446C67B73234B743B7634E616D65B76F47657436B743B76343617074696F6EB7B743B7634D7367B7B743B763546F6F6C546970B7B74EB76E4C656674B7323631B74EB76E546F70B73331B74EB76E5769647468B7313231B74EB76E486569676874B73231B74CB76C53686F7748696E74B730B74CB76C526561644F6E6C79B730B74EB7416C69676EB730B743B7635661726961626C65B75F5F6444617461417465B74CB76C56697369626C65436F6E74726F6CB731B743B7634633B7B74CB76C50617373776F7264B730B743B750696374757265B7B74CB76C486173427574746F6EB730B745B7625768656EB7B745B76256616C6964B721456D707479285F5F644461746141746529B745B7624C436C69636B6564B7B745B76252436C69636B6564B7B745B7624C44626C436C69636BB7B745B7624368616E6765B7B745B7624633B7B753425554544F4EB76F446C67B73231B743B7634E616D65B76F5342746E38B743B76343617074696F6EB7B743B7634D7367B7B743B763546F6F6C546970B7B74EB76E4C656674B7333238B74EB76E546F70B73536B74EB76E5769647468B73532B74EB76E486569676874B73232B74CB76C53686F7748696E74B730B74CB76C526561644F6E6C79B730B74EB7416C69676EB730B743B7635661726961626C65B7B74CB76C56697369626C65436F6E74726F6CB731B74EB76E54797065B731B745B7625768656EB7B745B76256616C6964B7B745B7624C436C69636B6564B76643616C63526573286151756572792C2061436F6C732C205F5F644461746144652C205F5F64446174614174652C20614865616465722C205F5F635469706F417072202029B745B76252436C69636B6564B7B745B7624C44626C436C69636BB7B745B7624368616E6765B7B745B762416374696F6EB7B75447524F5550B76F446C67B73139B743B7634E616D65B76F47727039B743B76343617074696F6EB7526573756D6FB743B7634D7367B7B743B763546F6F6C546970B7B74EB76E4C656674B73136B74EB76E546F70B7313530B74EB76E5769647468B7353831B74EB76E486569676874B7313535B74CB76C53686F7748696E74B730B74CB76C526561644F6E6C79B730B74EB7416C69676EB730B743B7635661726961626C65B7B74CB76C56697369626C65436F6E74726F6CB731B745B7625768656EB7B745B76256616C6964B7B745B7624C436C69636B6564B7B745B76252436C69636B6564B7B745B7624C44626C436C69636BB7B745B7624368616E6765B7B75447524F5550B76F446C67B73139B743B7634E616D65B76F4772703130B743B76343617074696F6EB7546F74616C20646520504373206E6F7320333020756C74696D6F732064696173B743B7634D7367B7B743B763546F6F6C546970B7B74EB76E4C656674B73136B74EB76E546F70B7333036B74EB76E5769647468B7323733B74EB76E486569676874B7313139B74CB76C53686F7748696E74B730B74CB76C526561644F6E6C79B730B74EB7416C69676EB730B743B7635661726961626C65B7B74CB76C56697369626C65436F6E74726F6CB731B745B7625768656EB7B745B76256616C6964B7B745B7624C436C69636B6564B7B745B76252436C69636B6564B7B745B7624C44626C436C69636BB7B745B7624368616E6765B7B754434F4D424F424F58B76F446C67B73231B743B7634E616D65B76F436F6D626F3132B743B76343617074696F6EB76F436F6D626F3132B743B7634D7367B7B743B763546F6F6C546970B7B74EB76E4C656674B73739B74EB76E546F70B73537B74EB76E5769647468B7313434B74EB76E486569676874B73231B74CB76C53686F7748696E74B730B74CB76C526561644F6E6C79B730B74EB7416C69676EB730B743B7635661726961626C65B75F5F635469706F417072B74CB76C56697369626C65436F6E74726F6CB731B74FB7614974656D73B7412D416D626F73A64C2D4C6962657261646F73A6422D426C6F71756561646F73A6B74EB76E4174B730B745B7625768656EB7B745B76256616C6964B7B745B7624C436C69636B6564B7B745B76252436C69636B6564B7B745B7624C44626C436C69636BB7B745B7624368616E6765B7B754534159B76F446C67B73231B743B7634E616D65B76F5361793135B743B76343617074696F6EB7466F726E656365646F722F4C6F6A61B743B7634D7367B7B743B763546F6F6C546970B7B74EB76E4C656674B73331B74EB76E546F70B73931B74EB76E5769647468B73936B74EB76E486569676874B73137B74CB76C53686F7748696E74B730B74CB76C526561644F6E6C79B730B74EB7416C69676EB730B743B7635661726961626C65B7B74CB76C56697369626C65436F6E74726F6CB731B74CB76C576F726457726170B730B74CB76C5472616E73706172656E74B730B745B7625768656EB7B745B76256616C6964B7B745B7624C436C69636B6564B7B745B76252436C69636B6564B7B745B7624C44626C436C69636BB7B745B7624368616E6765B7B754474554B76F446C67B73234B743B7634E616D65B76F4765743136B743B76343617074696F6EB7B743B7634D7367B7B743B763546F6F6C546970B7B74EB76E4C656674B7313230B74EB76E546F70B73837B74EB76E5769647468B7313136B74EB76E486569676874B73231B74CB76C53686F7748696E74B730B74CB76C526561644F6E6C79B730B74EB7416C69676EB730B743B7635661726961626C65B75F5F63436F644C6F6AB74CB76C56697369626C65436F6E74726F6CB731B743B7634633B7B74CB76C50617373776F7264B730B743B750696374757265B7B74CB76C486173427574746F6EB730B745B7625768656EB72E662EB745B76256616C6964B7B745B7624C436C69636B6564B7B745B76252436C69636B6564B7B745B7624C44626C436C69636BB7B745B7624368616E6765B7B745B7624633B7B754474554B76F446C67B73234B743B7634E616D65B76F4765743137B743B76343617074696F6EB76F4765743137B743B7634D7367B7B743B763546F6F6C546970B7B74EB76E4C656674B7313230B74EB76E546F70B7313132B74EB76E5769647468B7323633B74EB76E486569676874B73231B74CB76C53686F7748696E74B730B74CB76C526561644F6E6C79B730B74EB7416C69676EB730B743B7635661726961626C65B75F5F634E466F726E6563B74CB76C56697369626C65436F6E74726F6CB731B743B7634633B7B74CB76C50617373776F7264B730B743B750696374757265B740533330B74CB76C486173427574746F6EB730B745B7625768656EB72E462EB745B76256616C6964B7B745B7624C436C69636B6564B7B745B76252436C69636B6564B7B745B7624C44626C436C69636BB7B745B7624368616E6765B7B745B7624633B7B753425554544F4EB76F446C67B73231B743B7634E616D65B76F5342746E3135B743B76343617074696F6EB7B743B7634D7367B7B743B763546F6F6C546970B7B74EB76E4C656674B7343137B74EB76E546F70B7313235B74EB76E5769647468B73831B74EB76E486569676874B73232B74CB76C53686F7748696E74B730B74CB76C526561644F6E6C79B730B74EB7416C69676EB730B743B7635661726961626C65B7B74CB76C56697369626C65436F6E74726F6CB731B74EB76E54797065B732B745B7625768656EB7B745B76256616C6964B7B745B7624C436C69636B6564B76F446C673A456E642829B745B76252436C69636B6564B7B745B7624C44626C436C69636BB7B745B7624368616E6765B7B745B762416374696F6EB7B754534159B76F446C67B73231B743B7634E616D65B76F5361793136B743B76343617074696F6EB7546F74616C20566C72B743B7634D7367B7B743B763546F6F6C546970B7B74EB76E4C656674B73239B74EB76E546F70B7333237B74EB76E5769647468B73635B74EB76E486569676874B73137B74CB76C53686F7748696E74B730B74CB76C526561644F6E6C79B730B74EB7416C69676EB730B743B7635661726961626C65B7B74CB76C56697369626C65436F6E74726F6CB731B74CB76C576F726457726170B730B74CB76C5472616E73706172656E74B730B745B7625768656EB7B745B76256616C6964B7B745B7624C436C69636B6564B7B745B76252436C69636B6564B7B745B7624C44626C436C69636BB7B745B7624368616E6765B7B754534159B76F446C67B73231B743B7634E616D65B76F5361793137B743B76343617074696F6EB75174646520504373B743B7634D7367B7B743B763546F6F6C546970B7B74EB76E4C656674B73331B74EB76E546F70B7333437B74EB76E5769647468B73635B74EB76E486569676874B73137B74CB76C53686F7748696E74B730B74CB76C526561644F6E6C79B730B74EB7416C69676EB730B743B7635661726961626C65B7B74CB76C56697369626C65436F6E74726F6CB731B74CB76C576F726457726170B730B74CB76C5472616E73706172656E74B730B745B7625768656EB7B745B76256616C6964B7B745B7624C436C69636B6564B7B745B76252436C69636B6564B7B745B7624C44626C436C69636BB7B745B7624368616E6765B7B754534159B76F446C67B73231B743B7634E616D65B76F5361793138B743B76343617074696F6EB7546F74616C20566C722F5174646520504373B743B7634D7367B7B743B763546F6F6C546970B7B74EB76E4C656674B73330B74EB76E546F70B7333639B74EB76E5769647468B7313130B74EB76E486569676874B73137B74CB76C53686F7748696E74B730B74CB76C526561644F6E6C79B730B74EB7416C69676EB730B743B7635661726961626C65B7B74CB76C56697369626C65436F6E74726F6CB731B74CB76C576F726457726170B730B74CB76C5472616E73706172656E74B730B745B7625768656EB7B745B76256616C6964B7B745B7624C436C69636B6564B7B745B76252436C69636B6564B7B745B7624C44626C436C69636BB7B745B7624368616E6765B7B754534159B76F446C67B73231B743B7634E616D65B76F5361793139B743B76343617074696F6EB74D61696F7220436F6D707261B743B7634D7367B7B743B763546F6F6C546970B7B74EB76E4C656674B73330B74EB76E546F70B7333932B74EB76E5769647468B73639B74EB76E486569676874B73137B74CB76C53686F7748696E74B730B74CB76C526561644F6E6C79B730B74EB7416C69676EB730B743B7635661726961626C65B7B74CB76C56697369626C65436F6E74726F6CB731B74CB76C576F726457726170B730B74CB76C5472616E73706172656E74B730B745B7625768656EB7B745B76256616C6964B7B745B7624C436C69636B6564B7B745B76252436C69636B6564B7B745B7624C44626C436C69636BB7B745B7624368616E6765B7B754474554B76F446C67B73234B743B7634E616D65B76F4765743230B743B76343617074696F6EB76F4765743230B743B7634D7367B7B743B763546F6F6C546970B7B74EB76E4C656674B7313538B74EB76E546F70B7333230B74EB76E5769647468B7313231B74EB76E486569676874B73231B74CB76C53686F7748696E74B730B74CB76C526561644F6E6C79B730B74EB7416C69676EB730B743B7635661726961626C65B76E333075546F74B74CB76C56697369626C65436F6E74726F6CB731B743B7634633B7B74CB76C50617373776F7264B730B743B750696374757265B74045203939392C3939392C3939392E3939B74CB76C486173427574746F6EB730B745B7625768656EB72E662EB745B76256616C6964B7B745B7624C436C69636B6564B7B745B76252436C69636B6564B7B745B7624C44626C436C69636BB7B745B7624368616E6765B7B745B7624633B7B754474554B76F446C67B73234B743B7634E616D65B76F4765743231B743B76343617074696F6EB76F4765743231B743B7634D7367B7B743B763546F6F6C546970B7B74EB76E4C656674B7313538B74EB76E546F70B7333435B74EB76E5769647468B7313231B74EB76E486569676874B73231B74CB76C53686F7748696E74B730B74CB76C526561644F6E6C79B730B74EB7416C69676EB730B743B7635661726961626C65B76E333075515043B74CB76C56697369626C65436F6E74726F6CB731B743B7634633B7B74CB76C50617373776F7264B730B743B750696374757265B74045203939392C3939392C3939392E3939B74CB76C486173427574746F6EB730B745B7625768656EB72E662EB745B76256616C6964B7B745B7624C436C69636B6564B7B745B76252436C69636B6564B7B745B7624C44626C436C69636BB7B745B7624368616E6765B7B745B7624633B7B754474554B76F446C67B73234B743B7634E616D65B76F4765743232B743B76343617074696F6EB76F4765743232B743B7634D7367B7B743B763546F6F6C546970B7B74EB76E4C656674B7313538B74EB76E546F70B7333639B74EB76E5769647468B7313231B74EB76E486569676874B73231B74CB76C53686F7748696E74B730B74CB76C526561644F6E6C79B730B74EB7416C69676EB730B743B7635661726961626C65B76E333075417667B74CB76C56697369626C65436F6E74726F6CB731B743B7634633B7B74CB76C50617373776F7264B730B743B750696374757265B74045203939392C3939392C3939392E3939B74CB76C486173427574746F6EB730B745B7625768656EB72E662EB745B76256616C6964B7B745B7624C436C69636B6564B7B745B76252436C69636B6564B7B745B7624C44626C436C69636BB7B745B7624368616E6765B7B745B7624633B7B754474554B76F446C67B73234B743B7634E616D65B76F4765743233B743B76343617074696F6EB76F4765743233B743B7634D7367B7B743B763546F6F6C546970B7B74EB76E4C656674B7313538B74EB76E546F70B7333934B74EB76E5769647468B7313231B74EB76E486569676874B73231B74CB76C53686F7748696E74B730B74CB76C526561644F6E6C79B730B74EB7416C69676EB730B743B7635661726961626C65B76E3330754D5043B74CB76C56697369626C65436F6E74726F6CB731B743B7634633B7B74CB76C50617373776F7264B730B743B750696374757265B74045203939392C3939392C3939392E3939B74CB76C486173427574746F6EB730B745B7625768656EB72E662EB745B76256616C6964B7B745B7624C436C69636B6564B7B745B76252436C69636B6564B7B745B7624C44626C436C69636BB7B745B7624368616E6765B7B745B7624633B7B75447524F5550B76F446C67B73139B743B7634E616D65B76F4772703234B743B76343617074696F6EB7546F74616C2064652050437320646F73206469617320646F20706172616D6574726FB743B7634D7367B7B743B763546F6F6C546970B7B74EB76E4C656674B7333233B74EB76E546F70B7333037B74EB76E5769647468B7323733B74EB76E486569676874B7313230B74CB76C53686F7748696E74B730B74CB76C526561644F6E6C79B730B74EB7416C69676EB730B743B7635661726961626C65B7B74CB76C56697369626C65436F6E74726F6CB731B745B7625768656EB7B745B76256616C6964B7B745B7624C436C69636B6564B7B745B76252436C69636B6564B7B745B7624C44626C436C69636BB7B745B7624368616E6765B7B754534159B76F446C67B73231B743B7634E616D65B76F5361793235B743B76343617074696F6EB7546F74616C20566C72B743B7634D7367B7B743B763546F6F6C546970B7B74EB76E4C656674B7333434B74EB76E546F70B7333236B74EB76E5769647468B73635B74EB76E486569676874B73137B74CB76C53686F7748696E74B730B74CB76C526561644F6E6C79B730B74EB7416C69676EB730B743B7635661726961626C65B7B74CB76C56697369626C65436F6E74726F6CB731B74CB76C576F726457726170B730B74CB76C5472616E73706172656E74B730B745B7625768656EB7B745B76256616C6964B7B745B7624C436C69636B6564B7B745B76252436C69636B6564B7B745B7624C44626C436C69636BB7B745B7624368616E6765B7B754534159B76F446C67B73231B743B7634E616D65B76F5361793236B743B76343617074696F6EB75174646520504373B743B7634D7367B7B743B763546F6F6C546970B7B74EB76E4C656674B7333434B74EB76E546F70B7333437B74EB76E5769647468B73635B74EB76E486569676874B73137B74CB76C53686F7748696E74B730B74CB76C526561644F6E6C79B730B74EB7416C69676EB730B743B7635661726961626C65B7B74CB76C56697369626C65436F6E74726F6CB731B74CB76C576F726457726170B730B74CB76C5472616E73706172656E74B730B745B7625768656EB7B745B76256616C6964B7B745B7624C436C69636B6564B7B745B76252436C69636B6564B7B745B7624C44626C436C69636BB7B745B7624368616E6765B7B754534159B76F446C67B73231B743B7634E616D65B76F5361793237B743B76343617074696F6EB7546F74616C20566C722F5174646520504373B743B7634D7367B7B743B763546F6F6C546970B7B74EB76E4C656674B7333434B74EB76E546F70B7333731B74EB76E5769647468B7313132B74EB76E486569676874B73137B74CB76C53686F7748696E74B730B74CB76C526561644F6E6C79B730B74EB7416C69676EB730B743B7635661726961626C65B7B74CB76C56697369626C65436F6E74726F6CB731B74CB76C576F726457726170B730B74CB76C5472616E73706172656E74B730B745B7625768656EB7B745B76256616C6964B7B745B7624C436C69636B6564B7B745B76252436C69636B6564B7B745B7624C44626C436C69636BB7B745B7624368616E6765B7B754534159B76F446C67B73231B743B7634E616D65B76F5361793238B743B76343617074696F6EB74D61696F7220436F6D707261B743B7634D7367B7B743B763546F6F6C546970B7B74EB76E4C656674B7333436B74EB76E546F70B7333938B74EB76E5769647468B73731B74EB76E486569676874B73137B74CB76C53686F7748696E74B730B74CB76C526561644F6E6C79B730B74EB7416C69676EB730B743B7635661726961626C65B7B74CB76C56697369626C65436F6E74726F6CB731B74CB76C576F726457726170B730B74CB76C5472616E73706172656E74B730B745B7625768656EB7B745B76256616C6964B7B745B7624C436C69636B6564B7B745B76252436C69636B6564B7B745B7624C44626C436C69636BB7B745B7624368616E6765B7B754474554B76F446C67B73234B743B7634E616D65B76F4765743239B743B76343617074696F6EB76F4765743239B743B7634D7367B7B743B763546F6F6C546970B7B74EB76E4C656674B7343636B74EB76E546F70B7333231B74EB76E5769647468B7313231B74EB76E486569676874B73231B74CB76C53686F7748696E74B730B74CB76C526561644F6E6C79B730B74EB7416C69676EB730B743B7635661726961626C65B76E506172546F74B74CB76C56697369626C65436F6E74726F6CB731B743B7634633B7B74CB76C50617373776F7264B730B743B750696374757265B74045203939392C3939392C3939392E3939B74CB76C486173427574746F6EB730B745B7625768656EB72E662EB745B76256616C6964B7B745B7624C436C69636B6564B7B745B76252436C69636B6564B7B745B7624C44626C436C69636BB7B745B7624368616E6765B7B745B7624633B7B754474554B76F446C67B73234B743B7634E616D65B76F4765743330B743B76343617074696F6EB76F4765743330B743B7634D7367B7B743B763546F6F6C546970B7B74EB76E4C656674B7343636B74EB76E546F70B7333438B74EB76E5769647468B7313231B74EB76E486569676874B73231B74CB76C53686F7748696E74B730B74CB76C526561644F6E6C79B730B74EB7416C69676EB730B743B7635661726961626C65B76E506172515043B74CB76C56697369626C65436F6E74726F6CB731B743B7634633B7B74CB76C50617373776F7264B730B743B750696374757265B74045203939392C3939392C3939392E3939B74CB76C486173427574746F6EB730B745B7625768656EB72E662EB745B76256616C6964B7B745B7624C436C69636B6564B7B745B76252436C69636B6564B7B745B7624C44626C436C69636BB7B745B7624368616E6765B7B745B7624633B7B754474554B76F446C67B73234B743B7634E616D65B76F4765743331B743B76343617074696F6EB76F4765743331B743B7634D7367B7B743B763546F6F6C546970B7B74EB76E4C656674B7343636B74EB76E546F70B7333732B74EB76E5769647468B7313231B74EB76E486569676874B73231B74CB76C53686F7748696E74B730B74CB76C526561644F6E6C79B730B74EB7416C69676EB730B743B7635661726961626C65B76E506172417667B74CB76C56697369626C65436F6E74726F6CB731B743B7634633B7B74CB76C50617373776F7264B730B743B750696374757265B74045203939392C3939392C3939392E3939B74CB76C486173427574746F6EB730B745B7625768656EB72E662EB745B76256616C6964B7B745B7624C436C69636B6564B7B745B76252436C69636B6564B7B745B7624C44626C436C69636BB7B745B7624368616E6765B7B745B7624633B7B754474554B76F446C67B73234B743B7634E616D65B76F4765743332B743B76343617074696F6EB76F4765743332B743B7634D7367B7B743B763546F6F6C546970B7B74EB76E4C656674B7343635B74EB76E546F70B7333937B74EB76E5769647468B7313231B74EB76E486569676874B73231B74CB76C53686F7748696E74B730B74CB76C526561644F6E6C79B730B74EB7416C69676EB730B743B7635661726961626C65B76E5061724D5043B74CB76C56697369626C65436F6E74726F6CB731B743B7634633B7B74CB76C50617373776F7264B730B743B750696374757265B74045203939392C3939392C3939392E3939B74CB76C486173427574746F6EB730B745B7625768656EB72E662EB745B76256616C6964B7B745B7624C436C69636B6564B7B745B76252436C69636B6564B7B745B7624C44626C436C69636BB7B745B7624368616E6765B7B745B7624633B7B7544249544D4150B76F446C67B73233B743B7634E616D65B76F426D703333B743B76343617074696F6EB76F426D703333B743B7634D7367B7B743B763546F6F6C546970B7B74EB76E4C656674B7343230B74EB76E546F70B73230B74EB76E5769647468B7313733B74EB76E486569676874B7313030B74CB76C53686F7748696E74B730B74CB76C526561644F6E6C79B730B74EB7416C69676EB730B743B7635661726961626C65B7B74CB76C56697369626C65436F6E74726F6CB731B743B7635265734E616D65B7B743B763426D7046696C65B74353552E424D50B74CB76C53747265746368B730B74CB76C4175746F53697A65B730B745B7625768656EB7B745B76256616C6964B7B745B7624C436C69636B6564B7B745B76252436C69636B6564B7B745B7624C44626C436C69636BB7B745B7624368616E6765B7B75447524F5550B76F446C67B73139B743B7634E616D65B76F4772703335B743B76343617074696F6EB750656469646F20646520436F6D70726120656D204170726F7661E7E36FB743B7634D7367B7B743B763546F6F6C546970B7B74EB76E4C656674B73137B74EB76E546F70B7343237B74EB76E5769647468B7353830B74EB76E486569676874B73738B74CB76C53686F7748696E74B730B74CB76C526561644F6E6C79B730B74EB7416C69676EB730B743B7635661726961626C65B7B74CB76C56697369626C65436F6E74726F6CB731B745B7625768656EB7B745B76256616C6964B7B745B7624C436C69636B6564B7B745B76252436C69636B6564B7B745B7624C44626C436C69636BB7B745B7624368616E6765B7B754534159B76F446C67B73231B743B7634E616D65B76F5361793336B743B76343617074696F6EB75F5F63546578746FB743B7634D7367B7B743B763546F6F6C546970B7B74EB76E4C656674B73237B74EB76E546F70B7343436B74EB76E5769647468B7353634B74EB76E486569676874B73137B74CB76C53686F7748696E74B730B74CB76C526561644F6E6C79B730B74EB7416C69676EB730B743B7635661726961626C65B7B74CB76C56697369626C65436F6E74726F6CB731B74CB76C576F726457726170B730B74CB76C5472616E73706172656E74B730B745B7625768656EB7B745B76256616C6964B7B745B7624C436C69636B6564B7B745B76252436C69636B6564B7B745B7624C44626C436C69636BB7B745B7624368616E6765B7B753425554544F4EB76F446C67B73231B743B7634E616D65B76F5342746E3337B743B76343617074696F6EB76F5342746E3337B743B7634D7367B7B743B763546F6F6C546970B7B74EB76E4C656674B7333238B74EB76E546F70B73830B74EB76E5769647468B73532B74EB76E486569676874B73232B74CB76C53686F7748696E74B730B74CB76C526561644F6E6C79B730B74EB7416C69676EB730B743B7635661726961626C65B7B74CB76C56697369626C65436F6E74726F6CB731B74EB76E54797065B73135B745B7625768656EB7B745B76256616C6964B7B745B7624C436C69636B6564B7665669657750432829B745B76252436C69636B6564B7B745B7624C44626C436C69636BB7B745B7624368616E6765B7B745B762416374696F6EB7B754534159B76F446C67B73231B743B7634E616D65B76F5361793338B743B76343617074696F6EB75F5F63546578746F32B743B7634D7367B7B743B763546F6F6C546970B7B74EB76E4C656674B73235B74EB76E546F70B7343638B74EB76E5769647468B7353630B74EB76E486569676874B73137B74CB76C53686F7748696E74B730B74CB76C526561644F6E6C79B730B74EB7416C69676EB730B743B7635661726961626C65B7B74CB76C56697369626C65436F6E74726F6CB731B74CB76C576F726457726170B730B74CB76C5472616E73706172656E74B730B745B7625768656EB7B745B76256616C6964B7B745B7624C436C69636B6564B7B745B76252436C69636B6564B7B745B7624C44626C436C69636BB7B745B7624368616E6765B7B7
//======================================================/*/
//$DIALOGCODE=
4C6F63616C206F446C672C6F536179312C6F477270322C6F536179332C6F536179342C6F476574352C6F476574362C6F5342746E382C6F477270392C6F47727031302C6F436F6D626F31322C6F53617931352C6F47657431362C6F47657431372C6F5342746E31352C6F53617931362C6F53617931372C6F53617931382C6F53617931392C6F47657432302C6F47657432312C6F47657432322C6F47657432332C6F47727032342C6F53617932352C6F53617932362C6F53617932372C6F53617932382C6F47657432392C6F47657433302C6F47657433312C6F47657433322C6F426D7033332C6F47727033352C6F53617933362C6F5342746E33372C6F5361793338
6F446C67203A3D204D534449414C4F4728293A43726561746528290D0A6F446C673A634E616D65203A3D20226F446C67220D0A6F446C673A6343617074696F6E203A3D2022436F6E73756C746120526573756D6F20646520466F726E656365646F72220D0A6F446C673A6E4C656674203A3D20300D0A6F446C673A6E546F70203A3D20300D0A6F446C673A6E5769647468203A3D203631360D0A6F446C673A6E486569676874203A3D203534370D0A6F446C673A6C53686F7748696E74203A3D202E462E0D0A6F446C673A6C43656E7465726564203A3D202E542E0D0A
6F53617931203A3D205453415928293A437265617465286F446C67290D0A6F536179313A634E616D65203A3D20226F53617931220D0A6F536179313A6343617074696F6E203A3D202244617461206465220D0A6F536179313A6E4C656674203A3D2033350D0A6F536179313A6E546F70203A3D2033350D0A6F536179313A6E5769647468203A3D2036350D0A6F536179313A6E486569676874203A3D2031370D0A6F536179313A6C53686F7748696E74203A3D202E462E0D0A6F536179313A6C526561644F6E6C79203A3D202E462E0D0A6F536179313A416C69676E203A3D20300D0A6F536179313A6C56697369626C65436F6E74726F6C203A3D202E542E0D0A6F536179313A6C576F726457726170203A3D202E462E0D0A6F536179313A6C5472616E73706172656E74203A3D202E462E0D0A
6F47727032203A3D205447524F555028293A437265617465286F446C67290D0A6F477270323A634E616D65203A3D20226F47727032220D0A6F477270323A6343617074696F6E203A3D2022506172616D6574726F73220D0A6F477270323A6E4C656674203A3D2031380D0A6F477270323A6E546F70203A3D2031350D0A6F477270323A6E5769647468203A3D203338340D0A6F477270323A6E486569676874203A3D203133310D0A6F477270323A6C53686F7748696E74203A3D202E462E0D0A6F477270323A6C526561644F6E6C79203A3D202E462E0D0A6F477270323A416C69676E203A3D20300D0A6F477270323A6C56697369626C65436F6E74726F6C203A3D202E542E0D0A
6F53617933203A3D205453415928293A437265617465286F446C67290D0A6F536179333A634E616D65203A3D20226F53617933220D0A6F536179333A6343617074696F6E203A3D20224461746120617465220D0A6F536179333A6E4C656674203A3D203230380D0A6F536179333A6E546F70203A3D2033340D0A6F536179333A6E5769647468203A3D2036350D0A6F536179333A6E486569676874203A3D2031370D0A6F536179333A6C53686F7748696E74203A3D202E462E0D0A6F536179333A6C526561644F6E6C79203A3D202E462E0D0A6F536179333A416C69676E203A3D20300D0A6F536179333A6C56697369626C65436F6E74726F6C203A3D202E542E0D0A6F536179333A6C576F726457726170203A3D202E462E0D0A6F536179333A6C5472616E73706172656E74203A3D202E462E0D0A
6F53617934203A3D205453415928293A437265617465286F446C67290D0A6F536179343A634E616D65203A3D20226F53617934220D0A6F536179343A6343617074696F6E203A3D20225469706F220D0A6F536179343A6E4C656674203A3D2033350D0A6F536179343A6E546F70203A3D2036310D0A6F536179343A6E5769647468203A3D2036350D0A6F536179343A6E486569676874203A3D2031370D0A6F536179343A6C53686F7748696E74203A3D202E462E0D0A6F536179343A6C526561644F6E6C79203A3D202E462E0D0A6F536179343A416C69676E203A3D20300D0A6F536179343A6C56697369626C65436F6E74726F6C203A3D202E542E0D0A6F536179343A6C576F726457726170203A3D202E462E0D0A6F536179343A6C5472616E73706172656E74203A3D202E462E0D0A
6F47657435203A3D205447455428293A437265617465286F446C67290D0A6F476574353A634E616D65203A3D20226F47657435220D0A6F476574353A6E4C656674203A3D2037390D0A6F476574353A6E546F70203A3D2033320D0A6F476574353A6E5769647468203A3D203132310D0A6F476574353A6E486569676874203A3D2032310D0A6F476574353A6C53686F7748696E74203A3D202E462E0D0A6F476574353A6C526561644F6E6C79203A3D202E462E0D0A6F476574353A416C69676E203A3D20300D0A6F476574353A635661726961626C65203A3D20225F5F64446174614465220D0A6F476574353A62536574476574203A3D207B7C757C2049662850436F756E7428293E302C5F5F644461746144653A3D752C5F5F6444617461446529207D0D0A6F476574353A6C56697369626C65436F6E74726F6C203A3D202E542E0D0A6F476574353A6C50617373776F7264203A3D202E462E0D0A6F476574353A6C486173427574746F6E203A3D202E462E0D0A6F476574353A6256616C6964203A3D207B7C7C2021456D707479285F5F6444617461446529207D0D0A
6F47657436203A3D205447455428293A437265617465286F446C67290D0A6F476574363A634E616D65203A3D20226F47657436220D0A6F476574363A6E4C656674203A3D203236310D0A6F476574363A6E546F70203A3D2033310D0A6F476574363A6E5769647468203A3D203132310D0A6F476574363A6E486569676874203A3D2032310D0A6F476574363A6C53686F7748696E74203A3D202E462E0D0A6F476574363A6C526561644F6E6C79203A3D202E462E0D0A6F476574363A416C69676E203A3D20300D0A6F476574363A635661726961626C65203A3D20225F5F6444617461417465220D0A6F476574363A62536574476574203A3D207B7C757C2049662850436F756E7428293E302C5F5F64446174614174653A3D752C5F5F644461746141746529207D0D0A6F476574363A6C56697369626C65436F6E74726F6C203A3D202E542E0D0A6F476574363A6C50617373776F7264203A3D202E462E0D0A6F476574363A6C486173427574746F6E203A3D202E462E0D0A6F476574363A6256616C6964203A3D207B7C7C2021456D707479285F5F644461746141746529207D0D0A
6F5342746E38203A3D2053425554544F4E28293A437265617465286F446C67290D0A6F5342746E383A634E616D65203A3D20226F5342746E38220D0A6F5342746E383A6E4C656674203A3D203332380D0A6F5342746E383A6E546F70203A3D2035360D0A6F5342746E383A6E5769647468203A3D2035320D0A6F5342746E383A6E486569676874203A3D2032320D0A6F5342746E383A6C53686F7748696E74203A3D202E462E0D0A6F5342746E383A6C526561644F6E6C79203A3D202E462E0D0A6F5342746E383A416C69676E203A3D20300D0A6F5342746E383A6C56697369626C65436F6E74726F6C203A3D202E542E0D0A6F5342746E383A6E54797065203A3D20310D0A6F5342746E383A624C436C69636B6564203A3D207B7C7C206643616C63526573286151756572792C2061436F6C732C205F5F644461746144652C205F5F64446174614174652C20614865616465722C205F5F635469706F417072202029207D0D0A
6F47727039203A3D205447524F555028293A437265617465286F446C67290D0A6F477270393A634E616D65203A3D20226F47727039220D0A6F477270393A6343617074696F6E203A3D2022526573756D6F220D0A6F477270393A6E4C656674203A3D2031360D0A6F477270393A6E546F70203A3D203135300D0A6F477270393A6E5769647468203A3D203538310D0A6F477270393A6E486569676874203A3D203135350D0A6F477270393A6C53686F7748696E74203A3D202E462E0D0A6F477270393A6C526561644F6E6C79203A3D202E462E0D0A6F477270393A416C69676E203A3D20300D0A6F477270393A6C56697369626C65436F6E74726F6C203A3D202E542E0D0A
6F4772703130203A3D205447524F555028293A437265617465286F446C67290D0A6F47727031303A634E616D65203A3D20226F4772703130220D0A6F47727031303A6343617074696F6E203A3D2022546F74616C20646520504373206E6F7320333020756C74696D6F732064696173220D0A6F47727031303A6E4C656674203A3D2031360D0A6F47727031303A6E546F70203A3D203330360D0A6F47727031303A6E5769647468203A3D203237330D0A6F47727031303A6E486569676874203A3D203131390D0A6F47727031303A6C53686F7748696E74203A3D202E462E0D0A6F47727031303A6C526561644F6E6C79203A3D202E462E0D0A6F47727031303A416C69676E203A3D20300D0A6F47727031303A6C56697369626C65436F6E74726F6C203A3D202E542E0D0A
6F436F6D626F3132203A3D2054434F4D424F424F5828293A437265617465286F446C67290D0A6F436F6D626F31323A634E616D65203A3D20226F436F6D626F3132220D0A6F436F6D626F31323A6343617074696F6E203A3D20226F436F6D626F3132220D0A6F436F6D626F31323A6E4C656674203A3D2037390D0A6F436F6D626F31323A6E546F70203A3D2035370D0A6F436F6D626F31323A6E5769647468203A3D203134340D0A6F436F6D626F31323A6E486569676874203A3D2032310D0A6F436F6D626F31323A6C53686F7748696E74203A3D202E462E0D0A6F436F6D626F31323A6C526561644F6E6C79203A3D202E462E0D0A6F436F6D626F31323A416C69676E203A3D20300D0A6F436F6D626F31323A635661726961626C65203A3D20225F5F635469706F417072220D0A6F436F6D626F31323A62536574476574203A3D207B7C757C2049662850436F756E7428293E302C5F5F635469706F4170723A3D752C5F5F635469706F41707229207D0D0A6F436F6D626F31323A6C56697369626C65436F6E74726F6C203A3D202E542E0D0A6F436F6D626F31323A614974656D73203A3D207B2022412D416D626F73222C224C2D4C6962657261646F73222C22422D426C6F71756561646F73227D0D0A6F436F6D626F31323A6E4174203A3D20300D0A
6F5361793135203A3D205453415928293A437265617465286F446C67290D0A6F53617931353A634E616D65203A3D20226F5361793135220D0A6F53617931353A6343617074696F6E203A3D2022466F726E656365646F722F4C6F6A61220D0A6F53617931353A6E4C656674203A3D2033310D0A6F53617931353A6E546F70203A3D2039310D0A6F53617931353A6E5769647468203A3D2039360D0A6F53617931353A6E486569676874203A3D2031370D0A6F53617931353A6C53686F7748696E74203A3D202E462E0D0A6F53617931353A6C526561644F6E6C79203A3D202E462E0D0A6F53617931353A416C69676E203A3D20300D0A6F53617931353A6C56697369626C65436F6E74726F6C203A3D202E542E0D0A6F53617931353A6C576F726457726170203A3D202E462E0D0A6F53617931353A6C5472616E73706172656E74203A3D202E462E0D0A
6F4765743136203A3D205447455428293A437265617465286F446C67290D0A6F47657431363A634E616D65203A3D20226F4765743136220D0A6F47657431363A6E4C656674203A3D203132300D0A6F47657431363A6E546F70203A3D2038370D0A6F47657431363A6E5769647468203A3D203131360D0A6F47657431363A6E486569676874203A3D2032310D0A6F47657431363A6C53686F7748696E74203A3D202E462E0D0A6F47657431363A6C526561644F6E6C79203A3D202E462E0D0A6F47657431363A416C69676E203A3D20300D0A6F47657431363A635661726961626C65203A3D20225F5F63436F644C6F6A220D0A6F47657431363A62536574476574203A3D207B7C757C2049662850436F756E7428293E302C5F5F63436F644C6F6A3A3D752C5F5F63436F644C6F6A29207D0D0A6F47657431363A6C56697369626C65436F6E74726F6C203A3D202E542E0D0A6F47657431363A6C50617373776F7264203A3D202E462E0D0A6F47657431363A6C486173427574746F6E203A3D202E462E0D0A6F47657431363A625768656E203A3D207B7C7C202E662E207D0D0A
6F4765743137203A3D205447455428293A437265617465286F446C67290D0A6F47657431373A634E616D65203A3D20226F4765743137220D0A6F47657431373A6343617074696F6E203A3D20226F4765743137220D0A6F47657431373A6E4C656674203A3D203132300D0A6F47657431373A6E546F70203A3D203131320D0A6F47657431373A6E5769647468203A3D203236330D0A6F47657431373A6E486569676874203A3D2032310D0A6F47657431373A6C53686F7748696E74203A3D202E462E0D0A6F47657431373A6C526561644F6E6C79203A3D202E462E0D0A6F47657431373A416C69676E203A3D20300D0A6F47657431373A635661726961626C65203A3D20225F5F634E466F726E6563220D0A6F47657431373A62536574476574203A3D207B7C757C2049662850436F756E7428293E302C5F5F634E466F726E65633A3D752C5F5F634E466F726E656329207D0D0A6F47657431373A6C56697369626C65436F6E74726F6C203A3D202E542E0D0A6F47657431373A6C50617373776F7264203A3D202E462E0D0A6F47657431373A50696374757265203A3D202240533330220D0A6F47657431373A6C486173427574746F6E203A3D202E462E0D0A6F47657431373A625768656E203A3D207B7C7C202E462E207D0D0A
6F5342746E3135203A3D2053425554544F4E28293A437265617465286F446C67290D0A6F5342746E31353A634E616D65203A3D20226F5342746E3135220D0A6F5342746E31353A6E4C656674203A3D203431370D0A6F5342746E31353A6E546F70203A3D203132350D0A6F5342746E31353A6E5769647468203A3D2038310D0A6F5342746E31353A6E486569676874203A3D2032320D0A6F5342746E31353A6C53686F7748696E74203A3D202E462E0D0A6F5342746E31353A6C526561644F6E6C79203A3D202E462E0D0A6F5342746E31353A416C69676E203A3D20300D0A6F5342746E31353A6C56697369626C65436F6E74726F6C203A3D202E542E0D0A6F5342746E31353A6E54797065203A3D20320D0A6F5342746E31353A624C436C69636B6564203A3D207B7C7C206F446C673A456E642829207D0D0A
6F5361793136203A3D205453415928293A437265617465286F446C67290D0A6F53617931363A634E616D65203A3D20226F5361793136220D0A6F53617931363A6343617074696F6E203A3D2022546F74616C20566C72220D0A6F53617931363A6E4C656674203A3D2032390D0A6F53617931363A6E546F70203A3D203332370D0A6F53617931363A6E5769647468203A3D2036350D0A6F53617931363A6E486569676874203A3D2031370D0A6F53617931363A6C53686F7748696E74203A3D202E462E0D0A6F53617931363A6C526561644F6E6C79203A3D202E462E0D0A6F53617931363A416C69676E203A3D20300D0A6F53617931363A6C56697369626C65436F6E74726F6C203A3D202E542E0D0A6F53617931363A6C576F726457726170203A3D202E462E0D0A6F53617931363A6C5472616E73706172656E74203A3D202E462E0D0A
6F5361793137203A3D205453415928293A437265617465286F446C67290D0A6F53617931373A634E616D65203A3D20226F5361793137220D0A6F53617931373A6343617074696F6E203A3D20225174646520504373220D0A6F53617931373A6E4C656674203A3D2033310D0A6F53617931373A6E546F70203A3D203334370D0A6F53617931373A6E5769647468203A3D2036350D0A6F53617931373A6E486569676874203A3D2031370D0A6F53617931373A6C53686F7748696E74203A3D202E462E0D0A6F53617931373A6C526561644F6E6C79203A3D202E462E0D0A6F53617931373A416C69676E203A3D20300D0A6F53617931373A6C56697369626C65436F6E74726F6C203A3D202E542E0D0A6F53617931373A6C576F726457726170203A3D202E462E0D0A6F53617931373A6C5472616E73706172656E74203A3D202E462E0D0A
6F5361793138203A3D205453415928293A437265617465286F446C67290D0A6F53617931383A634E616D65203A3D20226F5361793138220D0A6F53617931383A6343617074696F6E203A3D2022546F74616C20566C722F5174646520504373220D0A6F53617931383A6E4C656674203A3D2033300D0A6F53617931383A6E546F70203A3D203336390D0A6F53617931383A6E5769647468203A3D203131300D0A6F53617931383A6E486569676874203A3D2031370D0A6F53617931383A6C53686F7748696E74203A3D202E462E0D0A6F53617931383A6C526561644F6E6C79203A3D202E462E0D0A6F53617931383A416C69676E203A3D20300D0A6F53617931383A6C56697369626C65436F6E74726F6C203A3D202E542E0D0A6F53617931383A6C576F726457726170203A3D202E462E0D0A6F53617931383A6C5472616E73706172656E74203A3D202E462E0D0A
6F5361793139203A3D205453415928293A437265617465286F446C67290D0A6F53617931393A634E616D65203A3D20226F5361793139220D0A6F53617931393A6343617074696F6E203A3D20224D61696F7220436F6D707261220D0A6F53617931393A6E4C656674203A3D2033300D0A6F53617931393A6E546F70203A3D203339320D0A6F53617931393A6E5769647468203A3D2036390D0A6F53617931393A6E486569676874203A3D2031370D0A6F53617931393A6C53686F7748696E74203A3D202E462E0D0A6F53617931393A6C526561644F6E6C79203A3D202E462E0D0A6F53617931393A416C69676E203A3D20300D0A6F53617931393A6C56697369626C65436F6E74726F6C203A3D202E542E0D0A6F53617931393A6C576F726457726170203A3D202E462E0D0A6F53617931393A6C5472616E73706172656E74203A3D202E462E0D0A
6F4765743230203A3D205447455428293A437265617465286F446C67290D0A6F47657432303A634E616D65203A3D20226F4765743230220D0A6F47657432303A6343617074696F6E203A3D20226F4765743230220D0A6F47657432303A6E4C656674203A3D203135380D0A6F47657432303A6E546F70203A3D203332300D0A6F47657432303A6E5769647468203A3D203132310D0A6F47657432303A6E486569676874203A3D2032310D0A6F47657432303A6C53686F7748696E74203A3D202E462E0D0A6F47657432303A6C526561644F6E6C79203A3D202E462E0D0A6F47657432303A416C69676E203A3D20300D0A6F47657432303A635661726961626C65203A3D20226E333075546F74220D0A6F47657432303A62536574476574203A3D207B7C757C2049662850436F756E7428293E302C6E333075546F743A3D752C6E333075546F7429207D0D0A6F47657432303A6C56697369626C65436F6E74726F6C203A3D202E542E0D0A6F47657432303A6C50617373776F7264203A3D202E462E0D0A6F47657432303A50696374757265203A3D20224045203939392C3939392C3939392E3939220D0A6F47657432303A6C486173427574746F6E203A3D202E462E0D0A6F47657432303A625768656E203A3D207B7C7C202E662E207D0D0A
6F4765743231203A3D205447455428293A437265617465286F446C67290D0A6F47657432313A634E616D65203A3D20226F4765743231220D0A6F47657432313A6343617074696F6E203A3D20226F4765743231220D0A6F47657432313A6E4C656674203A3D203135380D0A6F47657432313A6E546F70203A3D203334350D0A6F47657432313A6E5769647468203A3D203132310D0A6F47657432313A6E486569676874203A3D2032310D0A6F47657432313A6C53686F7748696E74203A3D202E462E0D0A6F47657432313A6C526561644F6E6C79203A3D202E462E0D0A6F47657432313A416C69676E203A3D20300D0A6F47657432313A635661726961626C65203A3D20226E333075515043220D0A6F47657432313A62536574476574203A3D207B7C757C2049662850436F756E7428293E302C6E3330755150433A3D752C6E33307551504329207D0D0A6F47657432313A6C56697369626C65436F6E74726F6C203A3D202E542E0D0A6F47657432313A6C50617373776F7264203A3D202E462E0D0A6F47657432313A50696374757265203A3D20224045203939392C3939392C3939392E3939220D0A6F47657432313A6C486173427574746F6E203A3D202E462E0D0A6F47657432313A625768656E203A3D207B7C7C202E662E207D0D0A
6F4765743232203A3D205447455428293A437265617465286F446C67290D0A6F47657432323A634E616D65203A3D20226F4765743232220D0A6F47657432323A6343617074696F6E203A3D20226F4765743232220D0A6F47657432323A6E4C656674203A3D203135380D0A6F47657432323A6E546F70203A3D203336390D0A6F47657432323A6E5769647468203A3D203132310D0A6F47657432323A6E486569676874203A3D2032310D0A6F47657432323A6C53686F7748696E74203A3D202E462E0D0A6F47657432323A6C526561644F6E6C79203A3D202E462E0D0A6F47657432323A416C69676E203A3D20300D0A6F47657432323A635661726961626C65203A3D20226E333075417667220D0A6F47657432323A62536574476574203A3D207B7C757C2049662850436F756E7428293E302C6E3330754176673A3D752C6E33307541766729207D0D0A6F47657432323A6C56697369626C65436F6E74726F6C203A3D202E542E0D0A6F47657432323A6C50617373776F7264203A3D202E462E0D0A6F47657432323A50696374757265203A3D20224045203939392C3939392C3939392E3939220D0A6F47657432323A6C486173427574746F6E203A3D202E462E0D0A6F47657432323A625768656E203A3D207B7C7C202E662E207D0D0A
6F4765743233203A3D205447455428293A437265617465286F446C67290D0A6F47657432333A634E616D65203A3D20226F4765743233220D0A6F47657432333A6343617074696F6E203A3D20226F4765743233220D0A6F47657432333A6E4C656674203A3D203135380D0A6F47657432333A6E546F70203A3D203339340D0A6F47657432333A6E5769647468203A3D203132310D0A6F47657432333A6E486569676874203A3D2032310D0A6F47657432333A6C53686F7748696E74203A3D202E462E0D0A6F47657432333A6C526561644F6E6C79203A3D202E462E0D0A6F47657432333A416C69676E203A3D20300D0A6F47657432333A635661726961626C65203A3D20226E3330754D5043220D0A6F47657432333A62536574476574203A3D207B7C757C2049662850436F756E7428293E302C6E3330754D50433A3D752C6E3330754D504329207D0D0A6F47657432333A6C56697369626C65436F6E74726F6C203A3D202E542E0D0A6F47657432333A6C50617373776F7264203A3D202E462E0D0A6F47657432333A50696374757265203A3D20224045203939392C3939392C3939392E3939220D0A6F47657432333A6C486173427574746F6E203A3D202E462E0D0A6F47657432333A625768656E203A3D207B7C7C202E662E207D0D0A
6F4772703234203A3D205447524F555028293A437265617465286F446C67290D0A6F47727032343A634E616D65203A3D20226F4772703234220D0A6F47727032343A6343617074696F6E203A3D2022546F74616C2064652050437320646F73206469617320646F20706172616D6574726F220D0A6F47727032343A6E4C656674203A3D203332330D0A6F47727032343A6E546F70203A3D203330370D0A6F47727032343A6E5769647468203A3D203237330D0A6F47727032343A6E486569676874203A3D203132300D0A6F47727032343A6C53686F7748696E74203A3D202E462E0D0A6F47727032343A6C526561644F6E6C79203A3D202E462E0D0A6F47727032343A416C69676E203A3D20300D0A6F47727032343A6C56697369626C65436F6E74726F6C203A3D202E542E0D0A
6F5361793235203A3D205453415928293A437265617465286F446C67290D0A6F53617932353A634E616D65203A3D20226F5361793235220D0A6F53617932353A6343617074696F6E203A3D2022546F74616C20566C72220D0A6F53617932353A6E4C656674203A3D203334340D0A6F53617932353A6E546F70203A3D203332360D0A6F53617932353A6E5769647468203A3D2036350D0A6F53617932353A6E486569676874203A3D2031370D0A6F53617932353A6C53686F7748696E74203A3D202E462E0D0A6F53617932353A6C526561644F6E6C79203A3D202E462E0D0A6F53617932353A416C69676E203A3D20300D0A6F53617932353A6C56697369626C65436F6E74726F6C203A3D202E542E0D0A6F53617932353A6C576F726457726170203A3D202E462E0D0A6F53617932353A6C5472616E73706172656E74203A3D202E462E0D0A
6F5361793236203A3D205453415928293A437265617465286F446C67290D0A6F53617932363A634E616D65203A3D20226F5361793236220D0A6F53617932363A6343617074696F6E203A3D20225174646520504373220D0A6F53617932363A6E4C656674203A3D203334340D0A6F53617932363A6E546F70203A3D203334370D0A6F53617932363A6E5769647468203A3D2036350D0A6F53617932363A6E486569676874203A3D2031370D0A6F53617932363A6C53686F7748696E74203A3D202E462E0D0A6F53617932363A6C526561644F6E6C79203A3D202E462E0D0A6F53617932363A416C69676E203A3D20300D0A6F53617932363A6C56697369626C65436F6E74726F6C203A3D202E542E0D0A6F53617932363A6C576F726457726170203A3D202E462E0D0A6F53617932363A6C5472616E73706172656E74203A3D202E462E0D0A
6F5361793237203A3D205453415928293A437265617465286F446C67290D0A6F53617932373A634E616D65203A3D20226F5361793237220D0A6F53617932373A6343617074696F6E203A3D2022546F74616C20566C722F5174646520504373220D0A6F53617932373A6E4C656674203A3D203334340D0A6F53617932373A6E546F70203A3D203337310D0A6F53617932373A6E5769647468203A3D203131320D0A6F53617932373A6E486569676874203A3D2031370D0A6F53617932373A6C53686F7748696E74203A3D202E462E0D0A6F53617932373A6C526561644F6E6C79203A3D202E462E0D0A6F53617932373A416C69676E203A3D20300D0A6F53617932373A6C56697369626C65436F6E74726F6C203A3D202E542E0D0A6F53617932373A6C576F726457726170203A3D202E462E0D0A6F53617932373A6C5472616E73706172656E74203A3D202E462E0D0A
6F5361793238203A3D205453415928293A437265617465286F446C67290D0A6F53617932383A634E616D65203A3D20226F5361793238220D0A6F53617932383A6343617074696F6E203A3D20224D61696F7220436F6D707261220D0A6F53617932383A6E4C656674203A3D203334360D0A6F53617932383A6E546F70203A3D203339380D0A6F53617932383A6E5769647468203A3D2037310D0A6F53617932383A6E486569676874203A3D2031370D0A6F53617932383A6C53686F7748696E74203A3D202E462E0D0A6F53617932383A6C526561644F6E6C79203A3D202E462E0D0A6F53617932383A416C69676E203A3D20300D0A6F53617932383A6C56697369626C65436F6E74726F6C203A3D202E542E0D0A6F53617932383A6C576F726457726170203A3D202E462E0D0A6F53617932383A6C5472616E73706172656E74203A3D202E462E0D0A
6F4765743239203A3D205447455428293A437265617465286F446C67290D0A6F47657432393A634E616D65203A3D20226F4765743239220D0A6F47657432393A6343617074696F6E203A3D20226F4765743239220D0A6F47657432393A6E4C656674203A3D203436360D0A6F47657432393A6E546F70203A3D203332310D0A6F47657432393A6E5769647468203A3D203132310D0A6F47657432393A6E486569676874203A3D2032310D0A6F47657432393A6C53686F7748696E74203A3D202E462E0D0A6F47657432393A6C526561644F6E6C79203A3D202E462E0D0A6F47657432393A416C69676E203A3D20300D0A6F47657432393A635661726961626C65203A3D20226E506172546F74220D0A6F47657432393A62536574476574203A3D207B7C757C2049662850436F756E7428293E302C6E506172546F743A3D752C6E506172546F7429207D0D0A6F47657432393A6C56697369626C65436F6E74726F6C203A3D202E542E0D0A6F47657432393A6C50617373776F7264203A3D202E462E0D0A6F47657432393A50696374757265203A3D20224045203939392C3939392C3939392E3939220D0A6F47657432393A6C486173427574746F6E203A3D202E462E0D0A6F47657432393A625768656E203A3D207B7C7C202E662E207D0D0A
6F4765743330203A3D205447455428293A437265617465286F446C67290D0A6F47657433303A634E616D65203A3D20226F4765743330220D0A6F47657433303A6343617074696F6E203A3D20226F4765743330220D0A6F47657433303A6E4C656674203A3D203436360D0A6F47657433303A6E546F70203A3D203334380D0A6F47657433303A6E5769647468203A3D203132310D0A6F47657433303A6E486569676874203A3D2032310D0A6F47657433303A6C53686F7748696E74203A3D202E462E0D0A6F47657433303A6C526561644F6E6C79203A3D202E462E0D0A6F47657433303A416C69676E203A3D20300D0A6F47657433303A635661726961626C65203A3D20226E506172515043220D0A6F47657433303A62536574476574203A3D207B7C757C2049662850436F756E7428293E302C6E5061725150433A3D752C6E50617251504329207D0D0A6F47657433303A6C56697369626C65436F6E74726F6C203A3D202E542E0D0A6F47657433303A6C50617373776F7264203A3D202E462E0D0A6F47657433303A50696374757265203A3D20224045203939392C3939392C3939392E3939220D0A6F47657433303A6C486173427574746F6E203A3D202E462E0D0A6F47657433303A625768656E203A3D207B7C7C202E662E207D0D0A
6F4765743331203A3D205447455428293A437265617465286F446C67290D0A6F47657433313A634E616D65203A3D20226F4765743331220D0A6F47657433313A6343617074696F6E203A3D20226F4765743331220D0A6F47657433313A6E4C656674203A3D203436360D0A6F47657433313A6E546F70203A3D203337320D0A6F47657433313A6E5769647468203A3D203132310D0A6F47657433313A6E486569676874203A3D2032310D0A6F47657433313A6C53686F7748696E74203A3D202E462E0D0A6F47657433313A6C526561644F6E6C79203A3D202E462E0D0A6F47657433313A416C69676E203A3D20300D0A6F47657433313A635661726961626C65203A3D20226E506172417667220D0A6F47657433313A62536574476574203A3D207B7C757C2049662850436F756E7428293E302C6E5061724176673A3D752C6E50617241766729207D0D0A6F47657433313A6C56697369626C65436F6E74726F6C203A3D202E542E0D0A6F47657433313A6C50617373776F7264203A3D202E462E0D0A6F47657433313A50696374757265203A3D20224045203939392C3939392C3939392E3939220D0A6F47657433313A6C486173427574746F6E203A3D202E462E0D0A6F47657433313A625768656E203A3D207B7C7C202E662E207D0D0A
6F4765743332203A3D205447455428293A437265617465286F446C67290D0A6F47657433323A634E616D65203A3D20226F4765743332220D0A6F47657433323A6343617074696F6E203A3D20226F4765743332220D0A6F47657433323A6E4C656674203A3D203436350D0A6F47657433323A6E546F70203A3D203339370D0A6F47657433323A6E5769647468203A3D203132310D0A6F47657433323A6E486569676874203A3D2032310D0A6F47657433323A6C53686F7748696E74203A3D202E462E0D0A6F47657433323A6C526561644F6E6C79203A3D202E462E0D0A6F47657433323A416C69676E203A3D20300D0A6F47657433323A635661726961626C65203A3D20226E5061724D5043220D0A6F47657433323A62536574476574203A3D207B7C757C2049662850436F756E7428293E302C6E5061724D50433A3D752C6E5061724D504329207D0D0A6F47657433323A6C56697369626C65436F6E74726F6C203A3D202E542E0D0A6F47657433323A6C50617373776F7264203A3D202E462E0D0A6F47657433323A50696374757265203A3D20224045203939392C3939392C3939392E3939220D0A6F47657433323A6C486173427574746F6E203A3D202E462E0D0A6F47657433323A625768656E203A3D207B7C7C202E662E207D0D0A
6F426D703333203A3D20544249544D415028293A437265617465286F446C67290D0A6F426D7033333A634E616D65203A3D20226F426D703333220D0A6F426D7033333A6343617074696F6E203A3D20226F426D703333220D0A6F426D7033333A6E4C656674203A3D203432300D0A6F426D7033333A6E546F70203A3D2032300D0A6F426D7033333A6E5769647468203A3D203137330D0A6F426D7033333A6E486569676874203A3D203130300D0A6F426D7033333A6C53686F7748696E74203A3D202E462E0D0A6F426D7033333A6C526561644F6E6C79203A3D202E462E0D0A6F426D7033333A416C69676E203A3D20300D0A6F426D7033333A6C56697369626C65436F6E74726F6C203A3D202E542E0D0A6F426D7033333A63426D7046696C65203A3D20224353552E424D50220D0A6F426D7033333A6C53747265746368203A3D202E462E0D0A6F426D7033333A6C4175746F53697A65203A3D202E462E0D0A
6F4772703335203A3D205447524F555028293A437265617465286F446C67290D0A6F47727033353A634E616D65203A3D20226F4772703335220D0A6F47727033353A6343617074696F6E203A3D202250656469646F20646520436F6D70726120656D204170726F7661E7E36F220D0A6F47727033353A6E4C656674203A3D2031370D0A6F47727033353A6E546F70203A3D203432370D0A6F47727033353A6E5769647468203A3D203538300D0A6F47727033353A6E486569676874203A3D2037380D0A6F47727033353A6C53686F7748696E74203A3D202E462E0D0A6F47727033353A6C526561644F6E6C79203A3D202E462E0D0A6F47727033353A416C69676E203A3D20300D0A6F47727033353A6C56697369626C65436F6E74726F6C203A3D202E542E0D0A
6F5361793336203A3D205453415928293A437265617465286F446C67290D0A6F53617933363A634E616D65203A3D20226F5361793336220D0A6F53617933363A6343617074696F6E203A3D20225F5F63546578746F220D0A6F53617933363A6E4C656674203A3D2032370D0A6F53617933363A6E546F70203A3D203434360D0A6F53617933363A6E5769647468203A3D203536340D0A6F53617933363A6E486569676874203A3D2031370D0A6F53617933363A6C53686F7748696E74203A3D202E462E0D0A6F53617933363A6C526561644F6E6C79203A3D202E462E0D0A6F53617933363A416C69676E203A3D20300D0A6F53617933363A6C56697369626C65436F6E74726F6C203A3D202E542E0D0A6F53617933363A6C576F726457726170203A3D202E462E0D0A6F53617933363A6C5472616E73706172656E74203A3D202E462E0D0A
6F5342746E3337203A3D2053425554544F4E28293A437265617465286F446C67290D0A6F5342746E33373A634E616D65203A3D20226F5342746E3337220D0A6F5342746E33373A6343617074696F6E203A3D20226F5342746E3337220D0A6F5342746E33373A6E4C656674203A3D203332380D0A6F5342746E33373A6E546F70203A3D2038300D0A6F5342746E33373A6E5769647468203A3D2035320D0A6F5342746E33373A6E486569676874203A3D2032320D0A6F5342746E33373A6C53686F7748696E74203A3D202E462E0D0A6F5342746E33373A6C526561644F6E6C79203A3D202E462E0D0A6F5342746E33373A416C69676E203A3D20300D0A6F5342746E33373A6C56697369626C65436F6E74726F6C203A3D202E542E0D0A6F5342746E33373A6E54797065203A3D2031350D0A6F5342746E33373A624C436C69636B6564203A3D207B7C7C20665669657750432829207D0D0A
6F5361793338203A3D205453415928293A437265617465286F446C67290D0A6F53617933383A634E616D65203A3D20226F5361793338220D0A6F53617933383A6343617074696F6E203A3D20225F5F63546578746F32220D0A6F53617933383A6E4C656674203A3D2032350D0A6F53617933383A6E546F70203A3D203436380D0A6F53617933383A6E5769647468203A3D203536300D0A6F53617933383A6E486569676874203A3D2031370D0A6F53617933383A6C53686F7748696E74203A3D202E462E0D0A6F53617933383A6C526561644F6E6C79203A3D202E462E0D0A6F53617933383A416C69676E203A3D20300D0A6F53617933383A6C56697369626C65436F6E74726F6C203A3D202E542E0D0A6F53617933383A6C576F726457726170203A3D202E462E0D0A6F53617933383A6C5472616E73706172656E74203A3D202E462E0D0A
6F446C673A41637469766174652829
//$ENDDIALOGDEF_oDlg
Return

