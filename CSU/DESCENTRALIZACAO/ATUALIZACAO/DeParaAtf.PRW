#Include "Rwmake.ch"
/*
ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммямммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  Ё DeParaAtf ╨ Autor ЁCristiano Figueiroa ╨ Data Ё 03/07/2006  ╨╠╠
╠╠лммммммммммьмммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Descricao Ё Grava o Item e a Classe de Valor no Ativo Fixo              ╨╠╠
╠╠лммммммммммьммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё Csu CardSystem                                              ╨╠╠
╠╠хммммммммммоммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

User Function DepItCla()

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                 Verifica se o Depara podera ser Realizado                  Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

If !MsgYesNo("Confirma a realizaГЦo do processo de Depara do Item e Classe do Ativo Fixo ?")
   Return
Else
   MsgRun("Executando as FunГУes do Depara.." , "Aguarde.... ", {|| CursorWait() , DepItClaII(), CursorWait()}) 
Endif   

DbSelectArea("TMP")
DbCloseArea()

DbSelectArea("ATF")
DbCloseArea()


Return

/*
ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммямммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  Ё DeParaAtf ╨ Autor ЁCristiano Figueiroa ╨ Data Ё 03/07/2006  ╨╠╠
╠╠лммммммммммьмммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Descricao Ё Grava o Item e a Classe de Valor no Ativo Fixo              ╨╠╠
╠╠лммммммммммьммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё Csu CardSystem                                              ╨╠╠
╠╠хммммммммммоммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

Static Function DepItClaII()

Local cCodFil
Local cUnidade
Local cDepto
Local cClasse
Local aCampos := {}
Local cArqTrb
Local lValid := .T.

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё              Abre o Arquivo Dbf de Depara do Ativo Fixo                    Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

DbUseArea(.T.,,"\SIGAADVDES\ATFTMP.DBF","TMP",.T.)

DbSelectArea("TMP")
DbGoTop()

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё              Cria o Novo Arquivo Temporario para o Ativo Fixo              Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Aadd ( aCampos , { "ITEM"    , "C" , 02 , 0 } ) 
Aadd ( aCampos , { "CLASSE"  , "C" , 09 , 0 } ) 
Aadd ( aCampos , { "DEPTO"   , "C" , 06 , 0 } ) 

cArqTrb := CriaTrab( aCampos )
DbUseArea( .T. ,, cArqTrb ,"ATF",.T.)
Append From "\SIGAADVDES\ATFTMP.DBF"
IndRegua( "ATF" , cArqTrb , "ITEM + DEPTO" ,,, "Criando Arquivo..." )

DbSelectArea("ATF")

Do While ATF->( !Eof() )

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                       Abre o Cadastro de Classe de Valor                      Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

   DbSelectArea("CTH")
   DbSetOrder(1)             
   
/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                   Posiciona no Cadastro de Classe de Valor                    Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

   If ! DbSeek( xFilial("CTH") + ATF->CLASSE )
      lValid := .F.
      Aviso( "AtenГЦo !" , "A Classe de Valores : " + ATF->CLASSE + " nЦo foi encontrada !" , {"Ok"} , 1 , "Processamento Cancelado" )
   Endif   

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                       Abre o Cadastro de Departamentos                        Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

   DbSelectArea("SZE")
   DbSetOrder(1)             
   
/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                   Posiciona no Cadastro de Classe de Valor                    Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

   If ! DbSeek( xFilial("SZE") + ATF->DEPTO ) .And. !( Alltrim(ATF->ITEM) $ "02/07/09" ) 
      lValid := .F.
      Aviso( "AtenГЦo !" , "O Departamento : " + ATF->DEPTO + " nЦo foi encontrado !" , {"Ok"} , 1 , "Processamento Cancelado" )
   Endif   

   DbSelectArea("ATF")
   DbSkip()
   Loop

Enddo   

If lValid

   /*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё                 Verifica se o Depara podera ser Realizado                  Ё
     юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

   If !MsgYesNo("O Arquivo Temporario foi Validado. Executa o Depara do Item e Classe do Ativo Fixo ?")
      Return
   Endif                                                                                               

Else
   Aviso( "AtenГЦo !" , "O Temporario possui informaГУes invАlidas !" , {"Ok"} , 1 , "Processamento Cancelado" )
   Return
Endif   

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                 Abre o Arquivo de Saldos e Valores do Ativo Fixo           Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

DbSelectArea("SN3")
DbSetOrder(1)

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё              Processa o Arquivo Completo de Saldos e Valores               Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Do While SN3->( !Eof() )

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                         Abre o Cadastro de Bens                            Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

   DbSelectArea("SN1")
   DbSetOrder(1)

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                         Posiciona no Cadastro de Bens                      Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
   
   If DbSeek ( SN3->N3_FILIAL + SN3->N3_CBASE + SN3->N3_ITEM  )

      cCodFil  := SN1->N1_FILIAL   // Filial
      cUnidade := SN1->N1_UNIDNEG  // Unidade de Negocio
      cDepto   := SN1->N1_CODEPTO  // Departamento
  
   /*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё                        Posiciona no Arquivo de Depara                      Ё
     юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      DbSelectArea("ATF")
      
      If DbSeek ( cUnidade + cDepto )

   /*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё        Atualiza o Arquivo de Saldos e Valores com o Item e a Classe        Ё
     юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

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
/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё  Processa o Proximo Registro do Arquivo de Saldos e Valores do Ativo Fixo  Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
   
   DbSelectArea("SN3")
   DbSkip()   
   Loop
   
Enddo
      
Alert("Final do Processamento !")
Return