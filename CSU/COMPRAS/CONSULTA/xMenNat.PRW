#Include 'protheus.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ConAprov  ³ Autor ³ Sergio Oliveira       ³ Data ³ Out/2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Consulta os aprovadores do Documento.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Ma110bar.prw                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function xMenNat()
Local _cMens := ""
Local _cNatureza:=GetMV("MV_XNATATF")
Local _lRet:=.T.
If alltrim(M->D1_NATFULL)$alltrim(_cNatureza)
	Aviso('Atenção','Favor enviar o devido formulário de aquisição de ativo imobilizado juntamente com a NF, caso contrário o pagamento não será realizado.',{'OK'})
endif
IF aCols <> NIL .AND. n <> NIL .AND. n == LEN(aCols)
	_cMens += "1º PASSO:"+Chr(13)+Chr(10)
	_cMens += "a) Ir para pasta DUPLICATAS;"+Chr(13)+Chr(10)
	_cMens += "b) Selecionar a Natureza (DP-C/IMP;DP-PRODUTOS ou  DP-S/IMP) e confirmar a inclusão da natureza apertando a tecla ENTER;"+Chr(13)+Chr(10)
	_cMens += "c) Conferir o valor do titulo com o valor total da nota fiscal."+Chr(13)+Chr(10)+""+Chr(13)+Chr(10)
	_cMens += "2º PASSO:"+Chr(13)+Chr(10)
	_cMens += "a) Ir para a pasta impostos (esta deve ser a última pasta a ser acessada e alterada);"+Chr(13)+Chr(10)
	_cMens += "b) Conferir os impostos. Caso algum imposto não esteja de acordo com a nota fiscal, clicar no valor do imposto, alterando ou zerando;"+Chr(13)+Chr(10)
	_cMens += "c) Após a conferência, confirmar na tecla OK da barra superior da tela."+Chr(13)+Chr(10)+""+Chr(13)+Chr(10)
	_cMens += "ATENÇÃO: não fazer nenhuma alteração em outras pastas após a conferência e alteração dos impostos. Caso seja necessário, repetir a partir do 2º passo." 
	xAviso("Atenção!",_cMens,{'OK'},3,"Próximos Passos:")     
ENDIF           
Return .T.              
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Aviso        ³Rev.  ³ Edson Maricate      ³ Data ³ 04/08/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Janela de aviso com botoes                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³nOpc:Aviso(cCaption,cMensagem,aBotoes)                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³nOpc       :Retorno numerico de acordo botao escolhido      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cCaption   :Titulo da Janela                                ³±±
±±³          ³cMensagem  :Texto da Janela (400 caracteres)                ³±±
±±³          ³aBotoes    :Array com titulo dos botoes  ( Max.5 )          ³±±
±±³          ³cCaption2  :Titulo da Descricao (Dentro da Janela)-opcional.³±±
±±³          ³nRotAutDefault:Retorno DEFAULT assumido em ROT. AUTOMATICA  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static FUNCTION xAviso(cCaption,cMensagem,aBotoes,nSize,cCaption2, nRotAutDefault,cBitmap)
 
Local ny        := 0
Local nx        := 0
Local aSize  := {  {324,404,35,155,35,113,51},;  // Tamanho 1
 {134,550,35,155,35,185,51},; // Tamanho 2
 {315,650,35,210,150,285,130} } // Tamanho 3
Local nLinha    := 0
Local cMsgButton:= ""
Local oGet
Private oDlgAviso
Private nOpcAviso := 0
 
cCaption2 := Iif(cCaption2 == Nil, cCaption, cCaption2)
 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Quando for rotina automatica, envia o aviso ao Log.          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type('lMsHelpAuto') == 'U'
 lMsHelpAuto := .F.
EndIf
 
If !lMsHelpAuto
 If nSize == Nil
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Verifica o numero de botoes Max. 5 e o tamanho da Msg.       ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  If  Len(aBotoes) > 3
   If Len(cMensagem) > 286
    nSize := 3
   Else
    nSize := 2
   EndIf
  Else
   Do Case
   Case Len(cMensagem) > 170 .And. Len(cMensagem) < 250
    nSize := 2
   Case Len(cMensagem) >= 250
    nSize := 3
   OtherWise
    nSize := 1
   EndCase
  EndIf
 EndIf
 If nSize <= 3
  nLinha := nSize
 Else
  nLinha := 3
 EndIf
 DEFINE MSDIALOG oDlgAviso FROM 0,0 TO aSize[nLinha][1],aSize[nLinha][2] TITLE cCaption Of oMainWnd PIXEL
 DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD
 @ 0, 0 BITMAP RESNAME "LOGIN" oF oDlgAviso SIZE aSize[nSize][3],aSize[nSize][4] NOBORDER WHEN .F. PIXEL
 @ 11 ,35  TO 13 ,400 LABEL '' OF oDlgAviso PIXEL
 If cBitmap <> Nil
  @ 2, 37 BITMAP RESNAME cBitmap oF oDlgAviso SIZE 18,18 NOBORDER WHEN .F. PIXEL
  @ 3  ,50  SAY cCaption2 Of oDlgAviso PIXEL SIZE 130 ,9 FONT oBold 
 Else
  @ 3  ,37  SAY cCaption2 Of oDlgAviso PIXEL SIZE 130 ,9 FONT oBold 
 EndIf
 If nSize <= 3
  @ 16 ,38  SAY cMensagem Of oDlgAviso PIXEL SIZE aSize[nLinha][6],aSize[nLinha][5]
 Else
  @ 16 ,38  GET oGet VAR cMensagem Of oDlgAviso PIXEL SIZE aSize[nLinha][6],aSize[nLinha][5] READONLY MEMO
 EndIf
 TButton():New(1000,1000," ",oDlgAviso,{||Nil},32,10,,oDlgAviso:oFont,.F.,.T.,.F.,,.F.,,,.F.)
 ny := (aSize[nLinha][2]/2)-36
 For nx:=1 to Len(aBotoes)
  cAction:="{||nOpcAviso:="+Str(Len(aBotoes)-nx+1)+",oDlgAviso:End()}"
  bAction:=&(cAction)
  cMsgButton:= OemToAnsi(AllTrim(aBotoes[Len(aBotoes)-nx+1]))
  cMsgButton:= IF( ( "&" $ SubStr( cMsgButton , 1 , 1 ) ) , cMsgButton , ( "&"+cMsgButton ) )
  TButton():New(aSize[nLinha][7],ny,cMsgButton, oDlgAviso,bAction,32,10,,oDlgAviso:oFont,.F.,.T.,.F.,,.F.,,,.F.)
  ny -= 35
 Next nx
 
 ACTIVATE MSDIALOG oDlgAviso CENTERED
Else
 If ValType(nRotAutDefault) == "N" .And. nRotAutDefault <= Len(aBotoes)
  cMensagem += " " + aBotoes[nRotAutDefault]
  nOpcAviso := nRotAutDefault
 Endif 
 ConOut(Repl("*",40))
 ConOut(cCaption)
 ConOut(cMensagem)
 ConOut(Repl("*",40))
 AutoGrLog(cCaption)
 AutoGrLog(cMensagem)
EndIf
 
Return (nOpcAviso)