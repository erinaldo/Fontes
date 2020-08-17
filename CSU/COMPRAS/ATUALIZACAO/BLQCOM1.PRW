#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"

User Function BLQCOM1

_cSenha:=Dlg2Senha()

If ALLTRIM(_cSenha) <> GetMv("MV_SENHALI")
	
	Alert("Senha incorreta !!!!!!")
	
	Return
EndIf

cMesFech := GetMv("MV_XMESNFE")

AtuDci() //Atualiza Dicionario

Dlg1Fin(cMesFech)

Return

Static Function _AltDt(cMesFech)

local _bOk
Local _Usuario
Local _NomeUser := substr(cUsuario,7,15)
Local _Rotina
Local _ParD     := GetMv("MV_XMESNFE")

PutMv("MV_XMESNFE",cMesFech)

_ParP := cMesFech

// Defino a ordem para posicionar no nome do usuario
PswOrder(2) // Ordem de nome
If PswSeek(_NomeUser,.T.)
	
	// Obtenho o resultado conforme vetor
	_aRetUser := PswRet(1)
	
	_Usuario   := upper(alltrim(_aRetUser[1,4]))
	
Else
	
	_Usuario := UPPER(_NomeUser)
	
EndIf


dData	:= Date()
cTime	:= TIME()
_Rotina:= "BLQCOM1"
DbSelectArea("ZV3")
DbSetorder(1)
If !ZV3->(dbSeek(xFilial("ZV3")+Dtoc(dData)+cTime))
	RecLock("ZV3",.T.)
	ZV3_FILIAL	:= "03"
	ZV3_DATA	:= dData
	ZV3_HORA	:= cTime
	ZV3_USER	:= _Usuario
	ZV3_ROTINA  := _Rotina
	ZV3_PARD    := _ParD
	ZV3_PARP    := _ParP
	MsUnlock()
Else
	RecLock("ZV3",.F.)
	ZV3_FILIAL	:= "03"
	ZV3_DATA	:= dData
	ZV3_HORA	:= cTime
	ZV3_USER	:= _Usuario
	ZV3_ROTINA  := _Rotina
	ZV3_PARD    := _ParD
	ZV3_PARP    := _ParP
	MsUnlock()
EndIf

Alert("Data alterada com sucesso!!!")

Return

*----------------------------------------------------
Static Function Dlg1Fin(cMesFech)
*----------------------------------------------------

Local oDlg,oData,oSay2,oSay6,oSay7,oData2,oSBtn11,oSBtn12
oDlg := MSDIALOG():Create()
oDlg:cName := "oDlg"
oDlg:cCaption := "Bloqueio de Documentos de Entrada"
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
oSay2:cCaption := "Esta rotina destina-se a realizar o bloqueio de documentos de entrada."
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
oSBtn11:cCaption := "Ok"
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
oSBtn12:cCaption := "Ok"
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

// DETALHE log
oSBtn13 := SBUTTON():Create(oDlg)
oSBtn13:cName := "oSBtn13"
oSBtn13:cCaption := "Log"
oSBtn13:nLeft := 116
oSBtn13:nTop := 148
oSBtn13:nWidth := 52
oSBtn13:nHeight := 22
oSBtn13:lShowHint := .F.
oSBtn13:lReadOnly := .F.
oSBtn13:Align := 0
oSBtn13:lVisibleControl := .T.
oSBtn13:nType := 1
oSBtn13:bAction := {|| _LogTela() } //{|| AxVisual("ZV3",ZV3->(RECNO()),2,,1) } //{|| oDlg:end() } //{|| _AltDt(dDtFin,dDtFis) }
oDlg:Activate()

Return

*----------------------------------------------------
static function Dlg2Senha
*----------------------------------------------------
Local oDlg_1,Passw,oSBtn5,oSay6
Local cSenha:=Space(20)
oDlg_1 := MSDIALOG():Create()
oDlg_1:cName := "oDlg_1"
oDlg_1:cCaption := "Validação de Acesso"
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
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AtuDci   ºAutor  ³   Eduardo Dias    º Data ³  15/12/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualiza dicionario para gravacao do LOG de processamento   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AtuDci()
Local aEstrut	:= {}
Local aSX3		:= {}
Local aSX2		:= {}
Local aSIX		:= {}
Local j,i

aEstrut:= { "X3_ARQUIVO","X3_ORDEM"  ,"X3_CAMPO"  ,"X3_TIPO"   ,"X3_TAMANHO","X3_DECIMAL","X3_TITULO" ,"X3_TITSPA" ,"X3_TITENG" ,;
"X3_DESCRIC","X3_DESCSPA","X3_DESCENG","X3_PICTURE","X3_VALID"  ,"X3_USADO"  ,"X3_RELACAO","X3_F3"     ,"X3_NIVEL"  ,;
"X3_RESERV" ,"X3_CHECK"  ,"X3_TRIGGER","X3_PROPRI" ,"X3_BROWSE" ,"X3_VISUAL" ,"X3_CONTEXT","X3_OBRIGAT","X3_VLDUSER",;
"X3_CBOX"   ,"X3_CBOXSPA","X3_CBOXENG","X3_PICTVAR","X3_WHEN"   ,"X3_INIBRW" ,"X3_GRPSXG" ,"X3_FOLDER","X3_PYME"}


Aadd(aSX3,{"ZV3","01","ZV3_FILIAL","C",2,0,"Filial","Filial","Filial","Filial do Sistema","Sucursal del Sistema","System Branch","@!","","€€€€€€€€€€€€€€€","","",1,"‚€","","","","N","","","","","","","","","","","","1"})
Aadd(aSX3,{"ZV3","02","ZV3_DATA"  ,"D",8,0,"Data","Data","Data","Data do Processamento","Data do Processamento","Data do Processamento","","","€€€€€€€€€€€€€€ ","","",1,"‚€","","","","S","","","","","","","","","","","","1"})
Aadd(aSX3,{"ZV3","03","ZV3_HORA"  ,"C",8,0,"Hora","Hora","Hora","Hora","Hora","Hora","99:99","","€€€€€€€€€€€€€€ ","","",1,"‚€","","","","S","","","","","","","","","","","","1"})
Aadd(aSX3,{"ZV3","04","ZV3_PARD"  ,"D",8,0,"Data De","Data De","Data De","Data Anterior","Data Anterior","Data Anterior","","","€€€€€€€€€€€€€€ ","","",1,"‚€","","","","S","","","","","","","","","","","","1"})
Aadd(aSX3,{"ZV3","05","ZV3_PARP"  ,"D",8,0,"Data Para","Data Para","Data Para","Data Alterada","Data Alterada","Data Alterada","","","€€€€€€€€€€€€€€ ","","",1,"‚€","","","","S","","","","","","","","","","","","1"})
Aadd(aSX3,{"ZV3","06","ZV3_USER"  ,"C",30,0,"Usuario","Usuario","Usuario","Usuario","Usuario","Usuario","","","€€€€€€€€€€€€€€ ","","",1,"‚€","","","","S","","","","","","","","","","","","1"})
Aadd(aSX3,{"ZV3","07","ZV3_ROTINA","C",30,0,"Rotina","Rotina","Rotina","Rotina","Rotina","Rotina","","","€€€€€€€€€€€€€€ ","","",1,"‚€","","","","S","","","","","","","","","","","","1"})


dbSelectArea("SX3")
dbSetOrder(2)
If !dbSeek("ZV3")
	
	For i:= 1 To Len(aSX3)
		If !Empty(aSX3[i][1])
			If !dbSeek(aSX3[i,3])
				RecLock("SX3",.T.)
				For j:=1 To Len(aSX3[i])
					If FieldPos(aEstrut[j])>0
						FieldPut(FieldPos(aEstrut[j]),aSX3[i,j])
					EndIf
				Next j
				dbCommit()
				MsUnLock()
			EndIf
		EndIf
	Next i
	
	aEstrut:= {"X2_CHAVE","X2_PATH","X2_ARQUIVO","X2_NOME","X2_NOMESPAC","X2_NOMEENGC","X2_ROTINA","X2_MODO","X2_MODOUN","X2_MODOEMP","X2_DELET","X2_TSS","X2_UNICO","X2_PYME","X2_MODULO"}
	
	aAdd(aSX2,{"ZV3","\DADOSADV\","","Log de Processamentos","Log de Processamentos","Log de Processamentos","","E","E","E",0,"","ZV3_FILIAL+DTOS(ZV3_DATA)+ZV3_HORA","S",6})	 //EDU TESTE
	dbSelectArea("SX2")
	dbSetOrder(1)
	dbSeek("ZV3")
	cPath := "\DADOSADV\" //SX2->X2_PATH
	cNome := "ZV3050" //Substr(SX2->X2_ARQUIVO,4,5)
	cModo	:= "E" //SX2->X2_MODO
	
	For i:= 1 To Len(aSX2)
		If !Empty(aSX2[i][1])
			If !dbSeek(aSX2[i,1])
				RecLock("SX2",.T.)
				For j:=1 To Len(aSX2[i])
					If FieldPos(aEstrut[j]) > 0
						FieldPut(FieldPos(aEstrut[j]),aSX2[i,j])
					EndIf
				Next j
				SX2->X2_PATH    := cPath
				SX2->X2_ARQUIVO := cNome
				SX2->X2_MODO    := cModo
				dbCommit()
				MsUnLock()
			EndIf
		EndIf
	Next i
	
	aEstrut:= {"INDICE","ORDEM","CHAVE","DESCRICAO","DESCSPA","DESCENG","PROPRI","F3","NICKNAME"}
	
	Aadd(aSIX,{"ZV3","1","ZV3_FILIAL+DTOS(ZV3_DATA)+ZV3_HORA","FILIAL+DATA+HORA","FILIAL+DATA+HORA","FILIAL+DATA+HORA","S","",""})
	
	dbSelectArea("SIX")
	dbSetOrder(1)
	For i:= 1 To Len(aSIX)
		If !Empty(aSIX[i,1])
			If !dbSeek(aSIX[i,1]+aSIX[i,2])
				lNew:= .T.
			Else
				lNew:= .F.
			EndIf
			
			If lNew.Or.UPPER(Alltrim(aSIX[i,3]))!=UPPER(AllTrim(CHAVE))
				RecLock("SIX",lNew)
				For j:=1 To Len(aSIX[i])
					If FieldPos(aEstrut[j])>0
						FieldPut(FieldPos(aEstrut[j]),aSIX[i,j])
					EndIf
				Next j
				dbCommit()
				MsUnLock()
			EndIf
		EndIf
	Next i
EndIf

dbSelectArea("ZV3")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ _LogTela ºAutor  ³    Eduardo Dias    º Data ³  15/12/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Apresentar a tela de LOG de processamento anteriores.     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function _LogTela()

Local aItens	:= {}
local nRBachou	:= 0

dbselectarea("ZV3")
ZV3->(dbgotop())

Do While .not. ZV3->(eof())
	nRBachou := aScan(aItens, ZV3->ZV3_DATA)
	if nRBachou = 0
		If Alltrim(ZV3->ZV3_ROTINA) == "BLQCOM1"
			AADD(aItens, {ZV3_DATA, ZV3_HORA, ZV3_PARD, ZV3_PARP, ZV3_USER} )
		endif
	endif
	ZV3->(dbskip())
enddo

ASORT(aItens, , , { | x,y | x[2] > y[2] } )

//DEFINE DIALOG oDlg TITLE "log de Processamento do Fechamento" FROM 200,200 TO (altura),(largura) PIXEL
DEFINE DIALOG oDlg TITLE "log de Processamento do Fechamento" FROM 0,0 TO 480,1120 PIXEL

oBrowse := TWBrowse():New( 02 , 01,560,210,,{'       Data        ','       Hora       ','         De           ',' Para ','       Usuário que processou '},{20,30,30},;
oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
aBrowse := aClone(aItens)

oBrowse:SetArray(aItens)

oBrowse:bLine := {||{aBrowse[oBrowse:nAt,01],aBrowse[oBrowse:nAt,02],aBrowse[oBrowse:nAt,03],aBrowse[oBrowse:nAt,04],aBrowse[oBrowse:nAt,05] } }

//@ 221,010 SAY "ATENÇÃO: Ultimo processamento realizado dia " OF oDlg PIXEL
@ 221,010 SAY "ATENÇÃO: Ultimo processamento realizado dia " + Dtoc(aItens[oBrowse:nAt,01]) + " - Através do Usuário: " + aItens[oBrowse:nAt,05] COLOR CLR_RED OF oDlg PIXEL
SButton():New( 220,510,01,{||oDlg:End()},oDlg,.T.,,)

ACTIVATE DIALOG oDlg CENTERED

Return
