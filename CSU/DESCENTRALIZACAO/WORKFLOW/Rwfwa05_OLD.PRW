#Include 'protheus.ch'

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  � Rwfwa05  � Autor � Cristiano Figueiroa � Data � 05/07/2006  ���
��������������������������������������������������������������������������͹��
���Descricao � Dispara um WorkFlow aos aprovadores responsaveis pela       ���
���          � liberacao do Documento de Entrada bloqueado por toleranci   ���
��������������������������������������������������������������������������͹��
���Uso       � CSU - CardSystem S.A                                        ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/

User Function Rwfwa05( nOpcao , oProcess )

/*����������������������������������������������������������������������������Ŀ
  �                 Declara as Variaveis Utilizadas na Rotina                  �
  ������������������������������������������������������������������������������*/

Local aSaveArea	  := GetArea()
Local cHtmlModelo := "Csu_WorkFlow_Documento_de_Entrada.htm"
Local cTitulo     := "Bloqueio do Documento de Entrada " + Alltrim( SF1->F1_SERIE  + " / " + SF1->F1_DOC )
Local cEmpresa    := SM0->M0_CODIGO + " - " + SM0->M0_NOME
Local cCodFil     := SM0->M0_CODFIL + " - " + SM0->M0_FILIAL                          
Local cDocumento  := SF1->F1_SERIE  + " / " + SF1->F1_DOC
Local cFornece    := "( " + SF1->F1_FORNECE + " - " + SF1->F1_LOJA + " ) " + Posicione ( "SA2" , 1 , xFilial( "SA2" ) + SF1->F1_FORNECE + SF1->F1_LOJA , "A2_NOME" )
Local cEmissao    := DtoC( SF1->F1_EMISSAO )
Local cCodProcesso
Local cMailUsers  := ""
Local oProcess
Local cPath
/*����������������������������������������������������������������������������Ŀ
  �                   Cria os Parametros Necessarios a Rotina                  �
  ������������������������������������������������������������������������������*/

CriaSX6()

/*����������������������������������������������������������������������������Ŀ
  �                 Carrega o Local onde os Html estao Gravados                �
  ������������������������������������������������������������������������������*/

cPath := GetMv("MV_HTMLPAT")

/*����������������������������������������������������������������������������Ŀ
  �                   Abre o Cadastro Documentos com Alcada                    �
  ������������������������������������������������������������������������������*/

DbSelectArea("SCR")
DbSetOrder(1)       // Filial + Tipo do Documento + Numero do Documento ( Numero da Nota + Serie + Fornecedor + Loja )

/*����������������������������������������������������������������������������Ŀ
  �             Posiciona no Cadastro de Documentos com Alcada                 �
  ������������������������������������������������������������������������������*/

If DbSeek ( xFilial("SCR") + "NF" + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA )

	
/*���������������������������������������������������������������������������������Ŀ
  � Busca os usuarios aprovadores e seus respectivos e-mail no cadastro de usuarios �
  �����������������������������������������������������������������������������������*/
  
   Do While SCR->( !Eof() ) .And. SCR->CR_TIPO == "NF" ;
                             .And. Alltrim( SCR->CR_NUM ) == SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA

   /*����������������������������������������������������������������������������Ŀ
     �             Abre o Arquivo de Usuarios por Ordem de Codigo                 �
     ������������������������������������������������������������������������������*/
           
      PswOrder(1)

   /*����������������������������������������������������������������������������Ŀ
     �             Pesquisa o Usuario de Grava o E-mail na Variavel               �
     ������������������������������������������������������������������������������*/
      
      If PswSeek(SCR->CR_USER)

         If Empty( PswRet(1)[1][14] )
            Aviso( "Aten��o !" , "N�o existe e-mail cadastrado para o Envio do WorkFlow. Cadastre o e-mail do usu�rio : " + PswRet(1)[1][2] , {"Ok"} , 1 , "E-mail do usu�rio" )
         Else
            cMailUsers += Alltrim( PswRet(1)[1][14] ) + ";" 
         Endif
         
      EndIf         

   /*����������������������������������������������������������������������������Ŀ
     �                        Avanca para o Proximo Registro                      �
     ������������������������������������������������������������������������������*/
      
      DbSelectArea("SCR")
      DbSkip() 
      Loop

   Enddo   

Endif

/*����������������������������������������������������������������������������Ŀ
  �        Verifica se existe usuario com e-mail para enviar o formulario      �
  ������������������������������������������������������������������������������*/

If !Empty(cMailUsers)

/*����������������������������������������������������������������������������Ŀ
  �                 Atualiza as Variaveis utilizadas no Formulario             �
  ������������������������������������������������������������������������������*/

   oProcess:= TWFProcess():New( cCodProcesso , cTitulo )
   oProcess:NewTask( cTitulo , cPath + cHtmlModelo )
   oProcess:oHtml:ValByName( "M0_EMPRESA" , cEmpresa	)
   oProcess:oHtml:ValByName( "M0_FILIAL"   , cLoja )
   oProcess:oHtml:ValByName( "F1_DOC"	    , cDocumento )
   oProcess:oHtml:ValByName( "A2_FORNECE"	, cFornece )
   oProcess:oHtml:ValByName( "F1_EMISSAO"	, cEmissao )
   oProcess:cSubject := cTitulo
   oProcess:cTo :=  cMailUsers
   oProcess:Start()

Endif   

/*����������������������������������������������������������������������������Ŀ
  �       Exibe a mensagem referente ao Documento de Entrada Bloqueado         �
  ������������������������������������������������������������������������������*/

xAviso( "Aten��o !" , "O Documento de Entrada : " +  Alltrim( SF1->F1_SERIE  + " / " + SF1->F1_DOC ) + " est� Bloqueado. Voc� alterou, para maior, valores ou quantidades que vieram do pedido de compras! Favor excluir o Documento de Entrada e incluir novamente." , {"Ok"} , 2 , "Documento Bloqueado - Diverg�ncia da NF X Pedido" )

/*����������������������������������������������������������������������������Ŀ
  �                       Restaura a Area Utilizada                            �
  ������������������������������������������������������������������������������*/

RestArea(aSaveArea)

Return

/*
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Programa  � CriaSX6  � Autor �Cristiano Figueiroa � Data � 06/07/2006 ���
������������������������������������������������������������������������͹��
���Descricao � Inclui um Novo Parametro no SX6                           ���
������������������������������������������������������������������������͹��
���Uso       � CSU CardSystem S.A                                        ���
������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
*/

Static Function CriaSX6()

/*����������������������������������������������������������������������������Ŀ
  �                Abre a tabela de parametros do sistema                      �
  ������������������������������������������������������������������������������*/

DbSelectArea("SX6")
DbSetOrder(1)

/*����������������������������������������������������������������������������Ŀ
  �        Verifica se o parametro existe , caso contrario grava o mesmo       �
  ������������������������������������������������������������������������������*/

If !DbSeek( "  " + "MV_HTMLPAT" )
   CriarSX6( "MV_HTMLPAT" , "C" , "Caminho onde os arquivos Html serao armazenados. Especifico CSU CardSystem" , "" , "" )
Endif

Return


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
 {130,545,35,155,35,195,51},; // Tamanho 2
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
  @ 3  ,50  SAY cCaption2 Of oDlgAviso PIXEL SIZE 175 ,9 FONT oBold 
 Else
  @ 3  ,37  SAY cCaption2 Of oDlgAviso PIXEL SIZE 175 ,9 FONT oBold 
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