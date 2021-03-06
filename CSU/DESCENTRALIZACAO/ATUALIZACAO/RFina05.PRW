#Include "Rwmake.ch"   
#Include "Protheus.ch"


/*
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Programa  � RFina05  � Autor � Ricardo Beraldo    � Data � 11/07/2006 ���
������������������������������������������������������������������������͹��
���Descricao � Abre uma tela para alteracao do parametro especifico que  ���
���          � informa quantos dias e permitido para inclusao de titulos ���
���          � com a data de vencimento superior a data base do sistema. ���
������������������������������������������������������������������������͹��
���Uso       � Csu CardSystem                                            ���
������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
*/

User Function RFina05()

/*����������������������������������������������������������������������������Ŀ
  �                    Declara as variaveis utilizadas                         �
  ������������������������������������������������������������������������������*/

Private _nDias := 0
Private _oDlg				
Private _aArea   := GetArea()                    
Private _aAreaSX6:= SX6->(GetArea())

/*����������������������������������������������������������������������������Ŀ
  �    Chama a funcao que cria o parametro ( MV_DAIVENC ) caso nao exista      �
  ������������������������������������������������������������������������������*/

U__TrataSX6(1)

/*����������������������������������������������������������������������������Ŀ
  �                   Cria a janela de dialogo principal                       �
  ������������������������������������������������������������������������������*/
nOpca := 0

Define MsDialog _oDlg Title OemtoAnsi("Configura��o do Parametro MV_DIAVENC") From 278 , 354 TO 400 , 690 Pixel of oMainWnd

@017,018 Say "Informe o n�mero m�nimo de dias permitido entre a Data Base e o Vencimento do T�tulos a Pagar:" Size 130, 054 COLOR CLR_BLACK Pixel Of _oDlg
@045,018 msget _nDias Size 30,10 Of _oDlg Pixel

Activate MsDialog _oDlg on init EnchoiceBar(_oDlg,{||If(U__TrataSX6(2),_oDlg:End(),.F.), nOpca := 1},{|| _oDlg:End()})

/*����������������������������������������������������������������������������Ŀ
  �                 Restaura a posicao inicial dos arquivos                    �
  ������������������������������������������������������������������������������*/

RestArea(_aAreaSX6)
RestArea(_aArea)

Return

/*
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Programa  � TrataSX6 � Autor �Cristiano Figueiroa � Data � 22/11/2005 ���
������������������������������������������������������������������������͹��
���Descricao � Efetua a inclusao ou alteracao do parametro MV_DIAVENC    ���
���          � conforme o parametro recebido                             ���
������������������������������������������������������������������������͹��
���Uso       � Merrill Lynch                                             ���
������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
*/

User Function _TrataSX6(_nOpcao)

/*����������������������������������������������������������������������������Ŀ
  �                Abre a tabela de parametros do sistema                      �
  ������������������������������������������������������������������������������*/

DbSelectArea("SX6")
DbSetOrder(1)

If _nOpcao == 1  // Cria o parametro caso o mesmo nao exista

   /*����������������������������������������������������������������������������Ŀ
     �        Verifica se o parametro existe , caso contrario grava o mesmo       �
     ������������������������������������������������������������������������������*/

   If !DbSeek("  " + "MV_DIAVENC")
      CriarSX6("MV_DIAVENC", "N", "Numero minimo de dias entre a Data Base e o Vencimento", "0")
      _nDias := 0
   Else

   /*����������������������������������������������������������������������������Ŀ
     �              Atribui o conteudo do parametro ao Combobox                   �
     ������������������������������������������������������������������������������*/

      _nDias := GetMv("MV_DIAVENC")

   Endif   

Else          // Altera o conteudo do parametro apos a confirmacao
   /*����������������������������������������������������������������������������Ŀ
     �        Grava a alteracao efetuda no Parametro apos a confirmacao           �
     ������������������������������������������������������������������������������*/

   If DbSeek("  " + "MV_DIAVENC" )
      RecLock("SX6", .F. )
      SX6->X6_CONTEUD := ALLTRIM(STR(_nDias))
      Msunlock()
   Endif   

Endif

Return .T.