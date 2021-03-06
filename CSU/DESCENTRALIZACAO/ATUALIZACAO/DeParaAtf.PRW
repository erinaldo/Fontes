#Include "Rwmake.ch"
/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  � DeParaAtf � Autor �Cristiano Figueiroa � Data � 03/07/2006  ���
��������������������������������������������������������������������������͹��
���Descricao � Grava o Item e a Classe de Valor no Ativo Fixo              ���
��������������������������������������������������������������������������͹��
���Uso       � Csu CardSystem                                              ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/

User Function DepItCla()

/*����������������������������������������������������������������������������Ŀ
  �                 Verifica se o Depara podera ser Realizado                  �
  ������������������������������������������������������������������������������*/

If !MsgYesNo("Confirma a realiza��o do processo de Depara do Item e Classe do Ativo Fixo ?")
   Return
Else
   MsgRun("Executando as Fun��es do Depara.." , "Aguarde.... ", {|| CursorWait() , DepItClaII(), CursorWait()}) 
Endif   

DbSelectArea("TMP")
DbCloseArea()

DbSelectArea("ATF")
DbCloseArea()


Return

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  � DeParaAtf � Autor �Cristiano Figueiroa � Data � 03/07/2006  ���
��������������������������������������������������������������������������͹��
���Descricao � Grava o Item e a Classe de Valor no Ativo Fixo              ���
��������������������������������������������������������������������������͹��
���Uso       � Csu CardSystem                                              ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/

Static Function DepItClaII()

Local cCodFil
Local cUnidade
Local cDepto
Local cClasse
Local aCampos := {}
Local cArqTrb
Local lValid := .T.

/*����������������������������������������������������������������������������Ŀ
  �              Abre o Arquivo Dbf de Depara do Ativo Fixo                    �
  ������������������������������������������������������������������������������*/

DbUseArea(.T.,,"\SIGAADVDES\ATFTMP.DBF","TMP",.T.)

DbSelectArea("TMP")
DbGoTop()

/*����������������������������������������������������������������������������Ŀ
  �              Cria o Novo Arquivo Temporario para o Ativo Fixo              �
  ������������������������������������������������������������������������������*/

Aadd ( aCampos , { "ITEM"    , "C" , 02 , 0 } ) 
Aadd ( aCampos , { "CLASSE"  , "C" , 09 , 0 } ) 
Aadd ( aCampos , { "DEPTO"   , "C" , 06 , 0 } ) 

cArqTrb := CriaTrab( aCampos )
DbUseArea( .T. ,, cArqTrb ,"ATF",.T.)
Append From "\SIGAADVDES\ATFTMP.DBF"
IndRegua( "ATF" , cArqTrb , "ITEM + DEPTO" ,,, "Criando Arquivo..." )

DbSelectArea("ATF")

Do While ATF->( !Eof() )

/*�������������������������������������������������������������������������������Ŀ
  �                       Abre o Cadastro de Classe de Valor                      �
  ���������������������������������������������������������������������������������*/

   DbSelectArea("CTH")
   DbSetOrder(1)             
   
/*�������������������������������������������������������������������������������Ŀ
  �                   Posiciona no Cadastro de Classe de Valor                    �
  ���������������������������������������������������������������������������������*/

   If ! DbSeek( xFilial("CTH") + ATF->CLASSE )
      lValid := .F.
      Aviso( "Aten��o !" , "A Classe de Valores : " + ATF->CLASSE + " n�o foi encontrada !" , {"Ok"} , 1 , "Processamento Cancelado" )
   Endif   

/*�������������������������������������������������������������������������������Ŀ
  �                       Abre o Cadastro de Departamentos                        �
  ���������������������������������������������������������������������������������*/

   DbSelectArea("SZE")
   DbSetOrder(1)             
   
/*�������������������������������������������������������������������������������Ŀ
  �                   Posiciona no Cadastro de Classe de Valor                    �
  ���������������������������������������������������������������������������������*/

   If ! DbSeek( xFilial("SZE") + ATF->DEPTO ) .And. !( Alltrim(ATF->ITEM) $ "02/07/09" ) 
      lValid := .F.
      Aviso( "Aten��o !" , "O Departamento : " + ATF->DEPTO + " n�o foi encontrado !" , {"Ok"} , 1 , "Processamento Cancelado" )
   Endif   

   DbSelectArea("ATF")
   DbSkip()
   Loop

Enddo   

If lValid

   /*����������������������������������������������������������������������������Ŀ
     �                 Verifica se o Depara podera ser Realizado                  �
     ������������������������������������������������������������������������������*/

   If !MsgYesNo("O Arquivo Temporario foi Validado. Executa o Depara do Item e Classe do Ativo Fixo ?")
      Return
   Endif                                                                                               

Else
   Aviso( "Aten��o !" , "O Temporario possui informa��es inv�lidas !" , {"Ok"} , 1 , "Processamento Cancelado" )
   Return
Endif   

/*����������������������������������������������������������������������������Ŀ
  �                 Abre o Arquivo de Saldos e Valores do Ativo Fixo           �
  ������������������������������������������������������������������������������*/

DbSelectArea("SN3")
DbSetOrder(1)

/*����������������������������������������������������������������������������Ŀ
  �              Processa o Arquivo Completo de Saldos e Valores               �
  ������������������������������������������������������������������������������*/

Do While SN3->( !Eof() )

/*����������������������������������������������������������������������������Ŀ
  �                         Abre o Cadastro de Bens                            �
  ������������������������������������������������������������������������������*/

   DbSelectArea("SN1")
   DbSetOrder(1)

/*����������������������������������������������������������������������������Ŀ
  �                         Posiciona no Cadastro de Bens                      �
  ������������������������������������������������������������������������������*/
   
   If DbSeek ( SN3->N3_FILIAL + SN3->N3_CBASE + SN3->N3_ITEM  )

      cCodFil  := SN1->N1_FILIAL   // Filial
      cUnidade := SN1->N1_UNIDNEG  // Unidade de Negocio
      cDepto   := SN1->N1_CODEPTO  // Departamento
  
   /*����������������������������������������������������������������������������Ŀ
     �                        Posiciona no Arquivo de Depara                      �
     ������������������������������������������������������������������������������*/

      DbSelectArea("ATF")
      
      If DbSeek ( cUnidade + cDepto )

   /*����������������������������������������������������������������������������Ŀ
     �        Atualiza o Arquivo de Saldos e Valores com o Item e a Classe        �
     ������������������������������������������������������������������������������*/

         DbSelectArea("SN3")
         RecLock("SN3" , .F. )
         SN3->N3_SUBCTA := SN1->N1_UNIDNEG + SN1->N1_FILIAL
         SN3->N3_CLVL   := ATF->CLASSE
         MsUnlock()                  

      Else
      
         DbSelectArea("SN3")
         RecLock("SN3" , .F. )
         SN3->N3_SUBCTA := SN1->N1_UNIDNEG + SN1->N1_FILIAL
         MsUnlock()                  
      
      Endif 
      
    /*  IF SN1->N1_CBASE == "0000000001" .AND. SN1->N1_FILIAL == "03"
         ALERT ( SN1->N1_CBASE )
         ALERT ( "N1 " + SN1->N1_UNIDNEG +" " + SN1->N1_FILIAL )
         ALERT ( "N3 " + SN3->N3_SUBCTA )
      ENDIF*/
         
      If Alltrim(SN1->N1_UNIDNEG) $ "02/07/09"
         DbSelectArea("SN3")
         RecLock("SN3" , .F. )
         SN3->N3_SUBCTA := SN1->N1_UNIDNEG + SN1->N1_FILIAL
         SN3->N3_CLVL   := "999999999"
         MsUnlock()                  
      Endif

   Endif
/*����������������������������������������������������������������������������Ŀ
  �  Processa o Proximo Registro do Arquivo de Saldos e Valores do Ativo Fixo  �
  ������������������������������������������������������������������������������*/
   
   DbSelectArea("SN3")
   DbSkip()   
   Loop
   
Enddo
      
Alert("Final do Processamento !")
Return