#Include "Rwmake.ch" 
#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RwFwa06  �Autor  �Cristiano Figueiroa � Data �  13/07/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para cadastrar conta de E-mail que recebera          ���
���          �workflow informativo para atualiza��o dos Fornecedores      ���
�������������������������������������������������������������������������͹��
���Uso       � MP - Card System - CSU                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RwFwa06()

/*����������������������������������������������������������������������������Ŀ
  �                    Declara as variaveis utilizadas                         �
  ������������������������������������������������������������������������������*/

Private cParametro	:= Space(250)
Private oDlg				
Private aArea   := GetArea()
Private aAreaSX6:= SX6->(GetArea())

/*����������������������������������������������������������������������������Ŀ
  �    Chama a funcao que cria o parametro ( MV_WFFORN ) caso nao exista       �
  ������������������������������������������������������������������������������*/

TrataSX6("1")

/*����������������������������������������������������������������������������Ŀ
  �                   Cria a janela de dialogo principal                       �
  ������������������������������������������������������������������������������*/

Define MsDialog oDlg Title OemtoAnsi("Configura��o do Parametro MV_WFFORN") From 278 , 70 TO 423 , 805 Pixel

@ 017 , 018 Say "Informe o(s) e-mail(s) separados por ponto e virgula que receber�o o WorkFlow Informativo de Atualiza��o do Cadastro de Fornecedores e Desbloqueio" Size 100 , 070 COLOR CLR_BLACK Pixel Of oDlg
@ 025 , 135 MsGet cParametro                                                                         Size 230 , 012 Pixel Of oDlg
@ 055 , 110 Button OemtoAnsi("Ok")       Action  TrataSX6()                                         Size 037 , 012 Pixel Of oDlg
@ 055 , 200 Button OemtoAnsi("Fechar")  Action  Close(oDlg)                                         Size 037 , 012 Pixel Of oDlg


Activate MsDialog oDlg Centered 

/*����������������������������������������������������������������������������Ŀ
  �                 Restaura a posicao inicial dos arquivos                    �
  ������������������������������������������������������������������������������*/

RestArea(aAreaSX6)
RestArea(aArea)

Return

/*
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Programa  � TrataSX6 � Autor �Cristiano Figueiroa � Data � 22/11/2005 ���
���          �          � Alt.  �Cesar Moura         � Data � 22/01/2006 ���
������������������������������������������������������������������������͹��
���Descricao � Efetua a inclusao ou alteracao do parametro MV_WFFORN     ���
���          � conforme o parametro recebido                             ���
������������������������������������������������������������������������͹��
���Uso       � CSU   		                                             ���
������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
*/

Static Function TrataSX6(nOpcao)

/*����������������������������������������������������������������������������Ŀ
  �                Abre a tabela de parametros do sistema                      �
  ������������������������������������������������������������������������������*/

DbSelectArea("SX6")
DbSetOrder(1)

   /*����������������������������������������������������������������������������Ŀ
     �        Verifica se o parametro existe , caso contrario grava o mesmo       �
     ������������������������������������������������������������������������������*/
If nOpcao == "1"

   If !DbSeek( "  " + "MV_WFFORN" )
      CriarSX6( "MV_WFFORN" , "C" , "E-mails para WorKFlow informativo sobre atualizacao do Cadastro de Fornecedores.","")
   Else

   /*����������������������������������������������������������������������������Ŀ
     �              Atribui o conteudo do parametro ao Combobox                   �
     ������������������������������������������������������������������������������*/
      cParametro := GetMv("MV_WFFORN")
      cParametro := cParametro + Space( 250 - ( Len ( cParametro) ))

   Endif   

   /*����������������������������������������������������������������������������Ŀ
     �        Grava a alteracao efetuda no Parametro apos a confirmacao           �
     ������������������������������������������������������������������������������*/
Else

   If DbSeek( "  " + "MV_WFFORN" )
      RecLock("SX6", .F. )
      SX6->X6_CONTEUD := ALLTRIM(cParametro)
      Msunlock()
   
   Endif

   MsgInfo("Parametro atualizado com sucesso !!" , "Atualiza�c�o de Parametro")   

Endif   


Return