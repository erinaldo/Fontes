#Include "Protheus.ch"

/*
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Programa  � RFina03  � Autor � Ricardo Beraldo    � Data � 11/07/2006 ���
������������������������������������������������������������������������͹��
���Descricao � Abre uma tela para alteracao do parametro especifico que  ���
���          � informa quantos dias e permitido para inclusao de titulos ���
���          � com a data de vencimento superior a data base do sistema. ���
������������������������������������������������������������������������͹��
���Uso       � Csu CardSystem S.A                                        ���
������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
*/

User Function RFina03()

/*����������������������������������������������������������������������������Ŀ
  �                    Declara as variaveis utilizadas                         �
  ������������������������������������������������������������������������������*/

Private nDias := 0
Private oDlg				
Private aArea   := GetArea()                    
Private aAreaSX6:= SX6->(GetArea())

/*����������������������������������������������������������������������������Ŀ
  �    Chama a funcao que cria o parametro ( MV_DIAVENC ) caso nao exista      �
  ������������������������������������������������������������������������������*/

TrataSX6(1)

/*����������������������������������������������������������������������������Ŀ
  �                   Cria a janela de dialogo principal                       �
  ������������������������������������������������������������������������������*/
nOpca := 0

Define MsDialog oDlg Title OemtoAnsi("Configura��o do Parametro MV_DIAVENC") From 278 , 354 TO 400 , 690 Pixel of oMainWnd

@017,018 Say "Informe o n�mero m�nimo de dias permitido entre a Data Base e o Vencimento do T�tulos a Pagar:" Size 130, 054 COLOR CLR_BLACK Pixel Of oDlg
@045,018 msget nDias Size 30,10 Of oDlg Pixel Picture "99"

Activate MsDialog oDlg on init EnchoiceBar(oDlg,{||If(TrataSX6(2),oDlg:End(),.F.), nOpca := 1},{|| oDlg:End()})

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
������������������������������������������������������������������������͹��
���Descricao � Efetua a inclusao ou alteracao do parametro MV_DIAVENC    ���
���          � conforme o parametro recebido                             ���
������������������������������������������������������������������������͹��
���Uso       � Merrill Lynch                                             ���
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

If nOpcao == 1  // Cria o parametro caso o mesmo nao exista

   /*����������������������������������������������������������������������������Ŀ
     �        Verifica se o parametro existe , caso contrario grava o mesmo       �
     ������������������������������������������������������������������������������*/

   If !DbSeek("  " + "MV_DIAVENC")
      CriarSX6("MV_DIAVENC", "N", "Numero minimo de dias entre a Data Base e o Vencimento", "0")
      nDias := 0
   Else

   /*����������������������������������������������������������������������������Ŀ
     �              Atribui o conteudo do parametro ao Combobox                   �
     ������������������������������������������������������������������������������*/

      nDias := GetMv("MV_DIAVENC")

   Endif   

Else          // Altera o conteudo do parametro apos a confirmacao
   /*����������������������������������������������������������������������������Ŀ
     �        Grava a alteracao efetuda no Parametro apos a confirmacao           �
     ������������������������������������������������������������������������������*/

   If DbSeek("  " + "MV_DIAVENC" )
      RecLock("SX6", .F. )
      SX6->X6_CONTEUD := ALLTRIM(STR(nDias))
      Msunlock()
   Endif   

 /*����������������������������������������������������������������������������Ŀ
   �              Atribui o conteudo do parametro ao Combobox                   �
   ������������������������������������������������������������������������������*/

   Aviso( "Atualiza��o do Parametro MV_DIAVENC !" , "O Parametro referente ao numero minimo de dias entre a Data Base e o Vencimento ( MV_DIAVENC ) foi atualizado com sucesso!" , {"Ok"} , 1 , "Parametro Atualizado !" )

Endif

Return .T.

/*
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Programa  � VldDtVen � Autor �Cristiano Figueiroa � Data � 22/11/2005 ���
������������������������������������������������������������������������͹��
���Descricao � Valida se a data de vencimento pode ser menor ou igual    ���
���          � a data do servidor.                                       ���
������������������������������������������������������������������������͹��
���Uso       � Merrill Lynch                                             ���
������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
*/

Static Function VldDtVen(dVencto,cCampo)

/*����������������������������������������������������������������������������Ŀ
  �                    Declara as variaveis utilizadas                         �
  ������������������������������������������������������������������������������*/

Local lValida  := GetMv("MV_DIAVENC")
Local lRetorno := .T.

/*����������������������������������������������������������������������������Ŀ
  �                           Executa a validacao                              �
  ������������������������������������������������������������������������������*/

If !lValida
   If dVencto <= DATE()
      MsgInfo("A data de Vencimento " + cCampo + "( " + DtoC( dVencto ) + " ) " +" n�o pode ser menor ou igual a data do servidor ( " + DtoC( Date() ) + " ) " + " !" , "Aten��o !" )
      lRetorno := .F.
   Endif   
Endif

Return lRetorno