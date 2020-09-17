#INCLUDE "PROTHEUS.CH"
#INCLUDE "JPEG.CH"  
#INCLUDE "TBICONN.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ TransfArq³ Autor ³ Mauricio de Barros    ³ Data ³25/06/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³ Central de Recur ³Contato ³ mbarros@microsiga.com.br       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Envia Recebe arquivos Servidor / Estação Vice Versa        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Bops ³ Manutencao Efetuada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³      ³                                        ³±±
±±³              ³  /  /  ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function TransfArq()

Local oMemo1         := NIL
Local oRadioGrp1     := NIL
Private cMemo1	     := ""
Private nRadioGrp1	 := 1
Private aArquivos    := {}
Private cDirectory   := IIF(nRadioGrp1 == 1,"c:\","\")
Private cMask        := "*.*                  "
// Variaveis Private da Funcao
Private _oDlg				// Dialog Principal
Private INCLUI := .F.	// (na Enchoice) .T. Traz registro para Inclusao / .F. Traz registro para Alteracao/Visualizacao
Private cDirExclusao := ""
Private oMainWnd := " "

oFont := TFont():New( 'Courier New',7)
lHide := .T.
DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("Transferencia Arquivos") FROM C(178),C(181) TO C(548),C(717) PIXEL
// Cria Componentes Padroes do Sistema
@ C(004),C(003) TO C(042),C(267) LABEL "Operacao" PIXEL OF _oDlg
@ C(015),C(006) Radio oRadioGrp1 Var nRadioGrp1 Items "Enviar","Receber" 3D Size C(142),C(010) PIXEL OF _oDlg
@ C(017),C(169) Say "Mascara" Size C(022),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(017),C(194) MsGet oEdit1 Var cMask Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(043),C(005) Button OemtoAnsi("Selecionar ") Size C(037),C(012) PIXEL OF _oDlg ACTION( Processa({|| RunProc(1)}) )
@ C(043),C(052) Button OemtoAnsi("Transferir") Size C(037),C(012) PIXEL OF _oDlg ACTION( Processa({|| RunProc(2)}) )
@ C(043),C(102) Button OemtoAnsi("Cria Pasta") Size C(037),C(012) PIXEL OF _oDlg ACTION( CriaDir() )
@ C(043),C(152) Button OemtoAnsi("Excluir Arqs") Size C(037),C(012) PIXEL OF _oDlg ACTION( ExclArqs() )
@ C(043),C(202) Button OemtoAnsi("Sair") Size C(037),C(012) PIXEL OF _oDlg ACTION( _oDlg:End() )
//@ C(035),C(215) SAY OemtoAnsi("Developod By  b r o ") OBJECT oMsg1 Size C(100),C(012) COLOR CLR_GREEN FONT oFont PIXEL OF _oDlg 
//@ C(035),C(215) SAY OemtoAnsi("             M a r s") OBJECT oMsg2 Size C(100),C(012) COLOR CLR_BLUE  FONT oFont PIXEL OF _oDlg 
oSay1 := TSay():New(C(035),C(210),{|| OemtoAnsi("Developed By  b r o ") },_oDlg,,oFont,,,,.t.,CLR_GREEN,,100,12)
oSay2 := TSay():New(C(035),C(210),{|| OemtoAnsi("             M a r s") },_oDlg,,oFont,,,,.t.,CLR_RED,,100,12)
oTimer1 := TTimer():New(2000, {|| IIF(lHide,oSay1:Hide(),oSay1:Show()),lHide := !lHide }, _oDlg )
oTimer1:Activate()
//oTimer2 := TTimer():New(10, {|| oSay1:Show() }, _oDlg )
//oTimer2:Activate()

@ C(061),C(003) GET oMemo1 Var cMemo1 MEMO Size C(264),C(118) PIXEL OF _oDlg
ACTIVATE MSDIALOG _oDlg CENTERED 

Return(.T.)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()      ³ Autor ³ Norbert Waage Junior  ³ Data ³10/05/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolução horizontal do Monitor do Usuario.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function C(nTam)

/*
Local oMainWnd := ""                                                        

Local nHRes	:= oMainWnd:nClientWidth	//Resolucao horizontal do monitor      

Do Case                                                                         
	Case nHRes == 640	//Resolucao 640x480                                         
		nTam *= 0.8                                                                
	Case nHRes == 800	//Resolucao 800x600                                         
		nTam *= 1                                                                  
	OtherWise			//Resolucao 1024x768 e acima                                
		nTam *= 1.28                                                               
EndCase                                                                         
*/

nTam *= 1                                                                  
/*
If "MP8" $ oApp:cVersion .OR. "P10" $ oApp:cVersion                                                        
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                                               
  //³Tratamento para tema "Flat"³                                               
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                               
  If (Alltrim(GetTheme()) == "FLAT").Or. SetMdiChild()                          
       	nTam *= 0.90                                                            
  EndIf                                                                         
EndIf
*/
Return Int(nTam)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RunProc  ºAutor  ³Microsiga           º Data ³  06/25/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Executa a Transferencia de Arquivos                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RunProc( nTipo )

Local aFiles     := {} 
Local cTitulo    := ""
Local MvPar      := ""
Local MvParDef   := ""
Local aRetPar    := {}
Local nIxb			:= 0

Private aSit:={}

IF nTipo == 1

	IF nRadioGrp1 == 2  // Receber
	   cDirectory := cGetFile("Arquivos Transferencias", "Selecione o Diretorio Origem",,,,128)
	Else // Enviar 
	   cDirectory := cGetFile(OemtoAnsi("Arquivos Transferencias"),OemToAnsi("Selecione o Diretorio Origem"),0,,.F.,GETF_RETDIRECTORY+GETF_LOCALHARD)
	Endif

    cDirExclusao := cDirectory
    
	aFiles := Directory( cDirectory+Alltrim(cMask))
	
	CursorWait()
	
	IF Len( aFiles ) > 0
		Procregua(Len( aFiles ))
		For nIxb := 1 To Len( aFiles )
		    IncProc()
		    AADD( aRetPar, {.F.,aFiles[ nIxb,1],aFiles[ nIxb,2],aFiles[ nIxb,3],aFiles[ nIxb,4],aFiles[ nIxb,5]} )
		Next
		aArquivos := SelArq( aRetPar )
		cMemo1 := ""
		Procregua(Len( aArquivos ))
		For nIxb := 1 To Len(aArquivos)
		    IncProc()
		    cMemo1 += cDirectory + aArquivos[nIxb]+Chr(13)+Chr(10)
		Next
	Else
	    cMemo1 := "NAO EXISTEM ARQUIVOS NA PASTA SELECIONADA"
	Endif	
	CursorArrow()
Else
   IF Len( aArquivos ) > 0
                
		IF nRadioGrp1 == 1  // Enviar 
		   cDirDestino := cGetFile("Arquivos Transferencias", "Selecione o Diretorio Destino",,,,128)
		Else // Receber 
		   cDirDestino := cGetFile(OemtoAnsi("Arquivos Transferencias"),OemToAnsi("Selecione o Diretorio Destino"),0,,.F.,GETF_RETDIRECTORY+GETF_LOCALHARD)
		Endif
        IF lIsDir( cDirDestino )
	        cMemo1 := ""
			Procregua(Len( aArquivos ))
	        For nIxb := 1 To Len( aArquivos )
			    IncProc()
			    IF nRadioGrp1 == 1  // Enviar 
	               lCopiou :=  CpyT2S(cDirectory+aArquivos[nIxb],cDirDestino,.T.)
	               cMemo1 += cDirectory+aArquivos[nIxb] + IIF(lCopiou,"  TRANSFERIDO PARA "+cDirDestino,"  ERRO TRANSF... ")+Chr(13)+Chr(10)
	            Else  // Receber
	               lCopiou :=  CpyS2T( cDirectory+aArquivos[nIxb], cDirDestino, .T. )
	               cMemo1 += cDirectory+aArquivos[nIxb] + IIF(lCopiou,"  TRANSFERIDO PARA "+cDirDestino,"  ERRO TRANSF... ")+Chr(13)+Chr(10)
	            Endif
	        Next
        Endif
   Else
      cMemo1 := "NENHUM ARQUIVO SELECIONADO/TRANSFERIDO"
   Endif
Endif
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SelArq   ºAutor  ³Mauricio de Barros  º Data ³14/06/2004   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Seleciona os arquivos a serem Enviados                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP10                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function SelArq( aTipos )

LOCAL cCapital  := ""
LOCAL nX        := NIL
LOCAL cCad      := OemToAnsi("Selecione o Arquivos")
LOCAL cAlias    := Alias()
LOCAL oOk       := LoadBitmap( GetResources(), "LBOK" )
LOCAL oNo       := LoadBitmap( GetResources(), "LBNO" )
LOCAL cVar      := "  "
LOCAL nOpca     := NIL
LOCAL aTipoBack :={}
Local lTodos    := .T.
Local lTesPre   := .F.
Local aRetSel   := {}
Local lFlatMode := If(FindFunction("FLATMODE"),FlatMode(),SetMDIChild())

Private nTotSel   := 0
Private lMarcados := .T.
Private oLbx      := NIL
Private oDlg      := NIL
Private oBmp      := NIL
Private oTexto    := NIL
Private oMainWnd

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta array com os arquivos                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTotSel := 0

aTipoBack := aClone(aTipos)
nOpca := 0
lPrimeira := .T.

DEFINE MSDIALOG oDlg TITLE cCad From 9,0 To 38,120/*080*/ OF oMainWnd

@0.5,0.5 TO 12.7, 38.0 LABEL cCad OF oDlg
@2.3,003 Say OemToAnsi("  ")
@1.0,1.5 LISTBOX oLbx VAR cVar Fields HEADER " ","Arquivos                                                                               .", "Tamanho", "Data", "Hora", "Atributo" SIZE 450/*285*/,160 ON DBLCLICK(aTipoBack:=TrocaSel(oLbx:nAt,aTipoBack),oLbx:Refresh()) NOSCROLL
oLbx:SetArray(aTipoBack)
oLbx:bLine := {||{if(aTipoBack[oLbx:nAt,1],oOk,oNo),aTipoBack[oLbx:nAt,2],aTipoBack[oLbx:nAt,3],aTipoBack[oLbx:nAt,4],aTipoBack[oLbx:nAt,5],aTipoBack[oLbx:nAt,6]}}
@ 000,000 Bitmap oBmp Resname "PROJETOAP" Of oDlg Size 425,780 NoBorder When .F. Pixel
cTexto := "Total Selecionado: "+Alltrim(Transform(nTotSel,"@ 999999"))
@ 190,1.5 Say oTexto Var cTexto Of oDlg Pixel Size 65,80
@ 200,1.5 Checkbox oChk Var lTodos Prompt "Marca/Desmarca Todos" Size 70, 10 Of oDlg Pixel On Click (aTipoBack := SeleAll(aTipoBack))
oChk:oFont := oDlg:oFont
oBmp:Refresh(.T.)
nCol := 30
DEFINE SBUTTON oBtn1 FROM 200,170  TYPE 15  ENABLE OF oDlg ACTION FindArq(oLbx,aTipoBack) ONSTOP "Pesquisar" 
DEFINE SBUTTON oBtn2 FROM 200,215  TYPE 1 ACTION (nOpca := 1,oDlg:End()) ENABLE OF oDlg
DEFINE SBUTTON oBtn3 FROM 200,260  TYPE 2 ACTION oDlg:End() ENABLE OF oDlg

IF lFlatMode 
   oBtn1:cCaption := "Pesquisar"
Endif

ACTIVATE MSDIALOG oDlg CENTERED

IF nOpca == 1
	aTipos := Aclone(aTipoBack)
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a string de tipos para filtrar o arquivo               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTipos :=""
For nX := 1 To Len(aTipos)
	If aTipos[nX,1]
		AADD(aRetSel, aTipos[nX,2] )
	End
Next nX

If Len( aRetSel ) == 0
	Aviso("Atencao","Nenhum arquivo foi selecionado para transferencia",{"Ok"},2,"Transferencia")
Endif

DeleteObject(oOk)
DeleteObject(oNo)

//dbSelectArea(cAlias)
Return aRetSel
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³SeleAll   ºAutor  ³Mauricio de Barros  ºData  ³ 31/05/2004  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Funcao de Marcacao                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function SeleAll(aTipoBack)
Local nI := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inverte a marca do ListBox.                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If lMarcados
	
	lMarcados := .F.
	nTotSel   := 0
	
	For nI := 1 to Len(aTipoBack)
		aTipoBack[nI,1] := .F.
	Next
	
Else
	lMarcados := .T.
	nTotSel := 0
	
	For nI := 1 to Len(aTipoBack)
		aTipoBack[nI,1] := .T.
		nTotSel += 1
	Next
EndIf

cTexto := "Total Selecionado: "+Alltrim(Transform(nTotSel,"@ 999999"))
oLbx:Refresh(.T.)
oDlg:Refresh(.T.)
oBmp:Refresh(.T.)
oTexto:Refresh()

Return aTipoBack
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³TrocaSel  ºAutor  ³Mauricio de Barros  ºData  ³ 31/05/2004  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Funcao de Marcacao                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function TrocaSel(nIt,aTipoBack)

IF ! aTipoBack[nIt,1]
	nTotSel += 1
Else
	nTotSel -= 1
Endif

aTipoBack[nIt,1] := !aTipoBack[nIt,1]

cTexto := "Total Selecionado: "+Alltrim(Transform(nTotSel,"@ 999999"))
oLbx:Refresh(.T.)
oDlg:Refresh(.T.)
oBmp:Refresh(.T.)
oTexto:Refresh()

Return aTipoBack
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FindArq   ºAutor  ³Microsiga           º Data ³  06/27/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FindArq(oListArq,aListArq)
Local oDlgSeek
Local cSeek := Space(20)
Local lCase := .F.
Local lWord := .F.
Local nLastSeek := 0
Local cLastSeek := ""
Local nPos := oListArq:nAt
Local aSeek := {}

Aeval(aListArq,{|x,y| Aadd(aSeek,x[2])})

DEFINE MSDIALOG oDlgSeek FROM 00,00 TO 105,370 TITLE OemtoAnsi("Pesquisar") PIXEL   

@07,02 SAY OemToAnsi("Pesquisar")+":" OF oDlgSeek PIXEL 
@05,30 GET cSeek OF oDlgSeek PIXEL SIZE 100,9

@20,02 TO 51,130 LABEL OemtoAnsi("Opções") PIXEL OF oDlgSeek 
@27,05 CHECKBOX lCase PROMPT OemtoAnsi("&Coincidir maiúsc./minúsc.") FONT oDlgSeek:oFont PIXEL SIZE 80,09 
@38,05 CHECKBOX lWord PROMPT OemtoAnsi("Localizar palavra &inteira") FONT oDlgSeek:oFont PIXEL SIZE 80,09 

@05,135 BUTTON OemtoAnsi("&Próximo") PIXEL OF oDlgSeek SIZE 44,11; 
ACTION (nPos := FastSeek(cSeek,nPos,aSeek,lCase,lWord),oListArq:nAt := nPos,oListArq:Refresh())

@18,135 BUTTON OemtoAnsi("&Cancelar") PIXEL ACTION oDlgSeek:End() OF oDlgSeek SIZE 44,11 

ACTIVATE MSDIALOG oDlgSeek CENTERED
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FastSeek ºAutor  ³Microsiga           º Data ³  06/27/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FastSeek(cGet,nLastSeek,aArray,lCase,lWord)

Local nSearch := 0
Local bSearch

cGet := Trim(cGet)

If ( lCase .And. lWord )
	bSearch := {|x| Trim(x) == cGet}
ElseIf ( !lCase .And. !lWord )
	bSearch := {|x| Trim(Upper(SubStr(x,1,Len(cGet)))) == Upper(cGet)}
ElseIf ( lCase .And. !lWord )
	bSearch := {|x| Trim(SubStr(x,1,Len(cGet))) == cGet}
ElseIf ( !lCase .And. lWord )
	bSearch := {|x| Trim(Upper(x)) == Upper(cGet)}
EndIf

nSearch := Ascan(aArray,bSearch,nLastSeek+1)
If ( nSearch == 0 )
	nSearch := Ascan(aArray,bSearch)
	If ( nSearch == 0 )
		nSearch := nLastSeek
	EndIf
EndIf

Return nSearch
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MakeDir   ºAutor  ³Microsiga           º Data ³  06/27/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria Diretorio                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CriaDir()

Local cMakeDir := cGetFile("Criar Diretorio", "Digite a Pasta a ser Criada",,,,128)
// Remover Diretorio  -- DirRemove(cDiretorio)

IF !( lIsDir( cMakeDir ) )
   MakeDir( cMakeDir )
   IF lIsDir( cMakeDir )
      Alert("Diretorio: "+cMakeDir+" criado com sucesso!")
   Else
      Alert("Diretorio: "+cMakeDir+" nao foi criado!")
   Endif   
Else
   Alert( "Diretorio: "+cMakeDir+" já existe!" )
Endif

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TRANSFARQ ºAutor  ³Microsiga           º Data ³  11/07/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Efetua a Exclusão de Arquivos.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ExclArqs()
Local nIxb := 0

IF Len( aArquivos ) > 0 .OR. ! Empty( cDirExclusao )
   IF AVISO("Atencao","DESEJA EXCLUIR OS ARQUIVOS SELECIONADOS? ",{"Não","Sim"},3,"TRANSFARQS") == 2
	
		cMemo1 := ""
		Procregua(Len( aArquivos ))
		For nIxb := 1 To Len( aArquivos )
			IncProc()
			lExcluiu :=  FERASE( cDirExclusao+aArquivos[nIxb] ) == 0
			cMemo1 += cDirExclusao+aArquivos[nIxb] + IIF(lExcluiu,"  EXCLUIDO COM SUCESSO!","  ERRO EXCLUSAO... ")+Chr(13)+Chr(10)
		Next
   ELSE
	    cMemo1 := "NAO FOI EFETUADA A EXCLUSAO DOS ARQUIVOS"
   ENDIF
Else
	cMemo1 := "NENHUM ARQUIVO SELECIONADO PARA EXCLUSAO"
Endif

Return