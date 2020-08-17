#INCLUDE "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � BNGPEM99 � Autor � Adilson Silva      � Data � 06/10/2011  ���
�������������������������������������������������������������������������͹��
���Descricao � Carga Inicial dos Movimentos dos Beneficios.               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP8 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function BNGPEM99()	// U_BNGPEM99()

 Local bProcesso := {|oSelf| fProcessa( oSelf )}

 Private cCadastro  := "Benef�cios - Carga Inicial"
 Private cPerg      := "BNGPEM99"
 Private cDescricao

 dbSelectArea( "SRA" )
 dbSetOrder(1)

 fAsrPerg()
 Pergunte(cPerg,.F.)

 cDescricao := "Este programa ir� realizar a carga incial dos benef�cios conforme  " + Chr(13)+Chr(10) + Chr(13)+Chr(10)
 cDescricao += "informa��es do cadastro de funcion�rios.                           " + Chr(13)+Chr(10) + Chr(13)+Chr(10)

 tNewProcess():New( "SRA" , cCadastro , bProcesso , cDescricao , cPerg,,,,,.T.,.t. ) 	

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RUNCONT  � Autor � AP5 IDE            � Data �  28/12/04   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function fProcessa( oSelf )

 Local cFilDe, cFilAte
 Local cMatDe, cMatAte
 Local cCcDe, cCcAte
 Local cSit, cCat
 Local nTipBen
 
 Local cCodBen, cDescBen
 
 SRA->(dbSetOrder( 1 ))
 ZT6->(dbSetOrder( 1 ))
 ZT8->(dbSetOrder( 1 ))

 Pergunte(cPerg,.F.)
  cFilDe  := mv_par01
  cFilAte := mv_par02
  cMatDe  := mv_par03
  cMatAte := mv_par04
  cCcDe   := mv_par05
  cCcAte  := mv_par06
  cSit    := mv_par07
  cCat    := mv_par08
  nTipBen := mv_par09
 
 /*
 If nTipBen == 2		// VALE ALIMENTACAO
    dbSelectArea( "ZT8" )
    dbGoTop()
    If Eof() .Or. Bof()
       Aviso("ATENCAO","Cadastro do Vale Refei��o em Branco!",{"Sair"})
       Return
    EndIf
    cCodBen  := ZT8->ZT8_COD
    cDescBen := ZT8->ZT8_DESC
 ElseIf nTipBen == 3		// VALE REFEICAO
    dbSelectArea( "ZT8" )
    dbGoTop()
    If Eof() .Or. Bof()
       Aviso("ATENCAO","Cadastro do Vale Refei��o em Branco!",{"Sair"})
       Return
    EndIf
    cCodBen  := ZT8->ZT8_COD
    cDescBen := ZT8->ZT8_DESC
 EndIf
 */
 
 dbSelectArea( "SRA" )
 dbSetOrder( 1 )
 dbGoTop()
 oSelf:SetRegua1( RecCount() )
 
 Do While !Eof()
    oSelf:IncRegua1( SRA->(RA_FILIAL + "-" + RA_MAT + "-" + RA_NOME) )
    
    If ( SRA->RA_FILIAL  < cFilDe .Or. SRA->RA_FILIAL    > cFilAte ) .Or. ;
       ( SRA->RA_MAT     < cMatDe .Or. SRA->RA_MAT       > cMatAte ) .Or. ;
       ( SRA->RA_CC      < cCcDe  .Or. SRA->RA_CC        > cCcAte  ) .Or. ;
       !(SRA->RA_SITFOLH $ cSit ) .Or. !(SRA->RA_CATFUNC $ cCat    )
       dbSkip()
       Loop
    EndIf
    
    If nTipBen <> 1	 		// VALE TRANSPORTE
       If nTipBen == 2 .And. SRA->RA_VA <> "S"		// VALE ALIMENTACAO
          dbSkip()
          Loop
       ElseIf nTipBen == 3 .And. SRA->RA_VA == "S"	// VALE REFEICAO
          dbSkip()
          Loop
       EndIf
    
       // DePara do Codigo dos Beneficios
       If SRA->RA_VALEREF == "32" .And. SRA->RA_VA == "S"
          cCodBen := "100"
       ElseIf SRA->RA_VALEREF == "36" .And. SRA->RA_VA == "S"
          cCodBen := "101"
       ElseIf SRA->RA_VALEREF == "27" .And. SRA->RA_VA == "S"
          cCodBen := "102"
       ElseIf SRA->RA_VALEREF == "28" .And. SRA->RA_VA == "S"
          cCodBen := "102"
       ElseIf SRA->RA_VALEREF == "06" .And. SRA->RA_VA == "S"
          cCodBen := "103"
       ElseIf SRA->RA_VALEREF == "19" .And. SRA->RA_VA == "S"
          cCodBen := "104"
       ElseIf SRA->RA_VALEREF == "18" .And. SRA->RA_VA == "S"
          cCodBen := "105"
       ElseIf SRA->RA_VALEREF == "34" .And. SRA->RA_VA == "S"
          cCodBen := "106"
       ElseIf SRA->RA_VALEREF == "02" .And. SRA->RA_VA == "S"
          cCodBen := "107"
   
       ElseIf SRA->RA_VALEREF == "32" .And. SRA->RA_VA <> "S"
          cCodBen := "200"
       ElseIf SRA->RA_VALEREF == "36" .And. SRA->RA_VA <> "S"
          cCodBen := "201"
       ElseIf SRA->RA_VALEREF == "27" .And. SRA->RA_VA <> "S"
          cCodBen := "203"
       ElseIf SRA->RA_VALEREF == "28" .And. SRA->RA_VA <> "S"
          cCodBen := "203"
       ElseIf SRA->RA_VALEREF == "06" .And. SRA->RA_VA <> "S"
          cCodBen := "204"
       ElseIf SRA->RA_VALEREF == "19" .And. SRA->RA_VA <> "S"
          cCodBen := "205"
       ElseIf SRA->RA_VALEREF == "18" .And. SRA->RA_VA <> "S"
          cCodBen := "206"
       ElseIf SRA->RA_VALEREF == "33" .And. SRA->RA_VA <> "S"
          cCodBen := "207"
       ElseIf SRA->RA_VALEREF == "35" .And. SRA->RA_VA <> "S"
          cCodBen := "208"
       ElseIf SRA->RA_VALEREF == "34" .And. SRA->RA_VA <> "S"
          cCodBen := "209"
       ElseIf SRA->RA_VALEREF == "02" .And. SRA->RA_VA <> "S"
          cCodBen := "210"

       ElseIf SRA->RA_VALEREF == "30"
          cCodBen := "301"
       ElseIf SRA->RA_VALEREF == "31"
          cCodBen := "302"
       ElseIf SRA->RA_VALEREF == "29"
          cCodBen := "303"
       Else
          dbSkip()
          Loop
       EndIf   
    EndIf   
 
    If nTipBen == 1	 		// VALE TRANSPORTE
       dbSelectArea( "SR0" )
       dbSeek( SRA->(RA_FILIAL + RA_MAT) )
       Do While !Eof() .And. SR0->(R0_FILIAL + R0_MAT) == SRA->(RA_FILIAL + RA_MAT)
       
          SRN->(dbSeek( xFilial("SRN") + SR0->R0_MEIO ))
          
          dbSelectArea( "ZTA" )
          If !dbSeek( SRA->(RA_FILIAL + RA_MAT) + SR0->R0_MEIO )
             RecLock("ZTA",.T.)
              ZTA->ZTA_FILIAL := SRA->RA_FILIAL
              ZTA->ZTA_MAT    := SRA->RA_MAT
              ZTA->ZTA_COD    := SR0->R0_MEIO
              ZTA->ZTA_QDEDIA := SR0->R0_QDIAINF
              ZTA->ZTA_DESC   := SRN->RN_DESC
              ZTA->ZTA_CC     := SRA->RA_CC
             MsUnlock()
          EndIf

          dbSelectArea( "SR0" )
          dbSkip()
       EndDo
    ElseIf nTipBen == 2		// VALE ALIMENTACAO
       ZT8->(dbSeek( xFilial("ZT8") + cCodBen ))

       dbSelectArea( "ZT6" )
       If !dbSeek( SRA->(RA_FILIAL + RA_MAT) + cCodBen )
          RecLock("ZT6",.T.)
           ZT6->ZT6_FILIAL := SRA->RA_FILIAL
           ZT6->ZT6_MAT    := SRA->RA_MAT
           ZT6->ZT6_COD    := cCodBen
           ZT6->ZT6_DESC   := ZT8->ZT8_DESC
           ZT6->ZT6_DTINI  := SRA->RA_ADMISSA
           ZT6->ZT6_TIPO   := "2"
           ZT6->ZT6_CC     := SRA->RA_CC
          MsUnlock()
       EndIf
    ElseIf nTipBen == 3		// VALE REFEICAO
       ZT8->(dbSeek( xFilial("ZT8") + cCodBen ))

       dbSelectArea( "ZT6" )
       If !dbSeek( SRA->(RA_FILIAL + RA_MAT) + cCodBen )
          RecLock("ZT6",.T.)
           ZT6->ZT6_FILIAL := SRA->RA_FILIAL
           ZT6->ZT6_MAT    := SRA->RA_MAT
           ZT6->ZT6_COD    := cCodBen
           ZT6->ZT6_DESC   := ZT8->ZT8_DESC
           ZT6->ZT6_DTINI  := SRA->RA_ADMISSA
           ZT6->ZT6_TIPO   := "1"
           ZT6->ZT6_CC     := SRA->RA_CC
          MsUnlock()
       EndIf
    EndIf

    dbSelectArea( "SRA" )
    dbSkip()
 EndDo
 
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �VALIDPERG � Autor � AP5 IDE            � Data �  27/10/01   ���
�������������������������������������������������������������������������͹��
���Descri��o � Verifica a existencia das perguntas criando-as caso seja   ���
���          � necessario (caso nao existam).                             ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
Static Function fAsrPerg()

Local aRegs := {}
Local Fi    := FWSizeFilial()

 // Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
 aAdd(aRegs,{ cPerg,'01','Filial De ?                ','','','mv_ch1','C',Fi,0,0,'G','          ' ,'mv_par01',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SM0   ','' })
 aAdd(aRegs,{ cPerg,'02','Filial Ate ?               ','','','mv_ch2','C',Fi,0,0,'G','NaoVazio  ' ,'mv_par02',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SM0   ','' })
 aAdd(aRegs,{ cPerg,'03','Matricula De ?             ','','','mv_ch3','C',06,0,0,'G','          ' ,'mv_par03',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SRA   ','' })
 aAdd(aRegs,{ cPerg,'04','Matricula Ate ?            ','','','mv_ch4','C',06,0,0,'G','NaoVazio  ' ,'mv_par04',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SRA   ','' })
 aAdd(aRegs,{ cPerg,'05','Centro Custo De ?          ','','','mv_ch5','C',20,0,0,'G','          ' ,'mv_par05',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'CTT   ','' })
 aAdd(aRegs,{ cPerg,'06','Centro Custo Ate ?         ','','','mv_ch6','C',20,0,0,'G','NaoVazio  ' ,'mv_par06',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'CTT   ','' })
 aAdd(aRegs,{ cPerg,'07','Situacoes ?                ','','','mv_ch7','C',05,0,0,'G','fSituacao ' ,'mv_par07',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
 aAdd(aRegs,{ cPerg,'08','Categorias ?               ','','','mv_ch8','C',12,0,0,'G','fCategoria' ,'mv_par08',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
 aAdd(aRegs,{ cPerg,'09','Beneficio ?                ','','','mv_ch9','N',01,0,0,'C','          ' ,'mv_par09','Transporte'       ,'','','','','Alimentacao'      ,'','','','','Refeicao'            ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })

ValidPerg(aRegs,cPerg)

Return   
