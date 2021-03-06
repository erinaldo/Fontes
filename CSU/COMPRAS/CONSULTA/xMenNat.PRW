#Include 'protheus.ch'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �ConAprov  � Autor � Sergio Oliveira       � Data � Out/2006 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Consulta os aprovadores do Documento.                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Ma110bar.prw                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function xMenNat()
Local _cMens := ""
Local _cNatureza:=GetMV("MV_XNATATF")
Local _lRet:=.T.
If alltrim(M->D1_NATFULL)$alltrim(_cNatureza)
	Aviso('Aten��o','Favor enviar o devido formul�rio de aquisi��o de ativo imobilizado juntamente com a NF, caso contr�rio o pagamento n�o ser� realizado.',{'OK'})
endif
IF aCols <> NIL .AND. n <> NIL .AND. n == LEN(aCols)
	_cMens += "1� PASSO:"+Chr(13)+Chr(10)
	_cMens += "a) Ir para pasta DUPLICATAS;"+Chr(13)+Chr(10)
	_cMens += "b) Selecionar a Natureza (DP-C/IMP;DP-PRODUTOS ou  DP-S/IMP) e confirmar a inclus�o da natureza apertando a tecla ENTER;"+Chr(13)+Chr(10)
	_cMens += "c) Conferir o valor do titulo com o valor total da nota fiscal."+Chr(13)+Chr(10)+""+Chr(13)+Chr(10)
	_cMens += "2� PASSO:"+Chr(13)+Chr(10)
	_cMens += "a) Ir para a pasta impostos (esta deve ser a �ltima pasta a ser acessada e alterada);"+Chr(13)+Chr(10)
	_cMens += "b) Conferir os impostos. Caso algum imposto n�o esteja de acordo com a nota fiscal, clicar no valor do imposto, alterando ou zerando;"+Chr(13)+Chr(10)
	_cMens += "c) Ap�s a confer�ncia, confirmar na tecla OK da barra superior da tela."+Chr(13)+Chr(10)+""+Chr(13)+Chr(10)
	_cMens += "ATEN��O: n�o fazer nenhuma altera��o em outras pastas ap�s a confer�ncia e altera��o dos impostos. Caso seja necess�rio, repetir a partir do 2� passo." 
	xAviso("Aten��o!",_cMens,{'OK'},3,"Pr�ximos Passos:")     
ENDIF           
Return .T.              
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �Aviso        �Rev.  � Edson Maricate      � Data � 04/08/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Janela de aviso com botoes                                  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �nOpc:Aviso(cCaption,cMensagem,aBotoes)                      ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �nOpc       :Retorno numerico de acordo botao escolhido      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�cCaption   :Titulo da Janela                                ���
���          �cMensagem  :Texto da Janela (400 caracteres)                ���
���          �aBotoes    :Array com titulo dos botoes  ( Max.5 )          ���
���          �cCaption2  :Titulo da Descricao (Dentro da Janela)-opcional.���
���          �nRotAutDefault:Retorno DEFAULT assumido em ROT. AUTOMATICA  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
 
//��������������������������������������������������������������Ŀ
//� Quando for rotina automatica, envia o aviso ao Log.          �
//����������������������������������������������������������������
If Type('lMsHelpAuto') == 'U'
 lMsHelpAuto := .F.
EndIf
 
If !lMsHelpAuto
 If nSize == Nil
  //��������������������������������������������������������������Ŀ
  //� Verifica o numero de botoes Max. 5 e o tamanho da Msg.       �
  //����������������������������������������������������������������
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