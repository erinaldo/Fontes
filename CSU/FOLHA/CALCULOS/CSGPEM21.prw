#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CSGPEM21 � Autor � Adilson Silva      � Data � 06/03/2014  ���
�������������������������������������������������������������������������͹��
���Descricao � Calculo do Anuenio.                                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP8 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CSGPEM21()	// U_CSGPEM21()

 Local bProcesso := {|oSelf| fProcessa( oSelf )}

 Private cCadastro  := "Calculo do Anu�nio"
 Private cPerg      := "CSGPEM21"
 Private cStartPath := GetSrvProfString("StartPath","")
 Private cDescricao

 fAsrPerg()
 Pergunte(cPerg,.F.)

 cDescricao := "Esta rotina ir� calcular o anu�nio ano por ano."

 tNewProcess():New( "SRA" , cCadastro , bProcesso , cDescricao , cPerg,,,,,.T.,.T. ) 	

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

Local nTotReg   := 0
Local cTmpIni   := "200204"
Local cTmpFim   := "201003"
Local cPerIni   := ""
Local cPerFim   := ""
Local nAnos     := 0
Local nMeses    := 0
Local cAnoRef   := ""
Local nValor    := 0
Local aMeses    := {}
Local nValAcum  := 0
Local nValMes   := 0
Local nValAnt   := 0

Local nPos, nX

Private cFilProc  := GETMV( "GP_FILANUE" )
Private aSalarios := {}
Private aValAnt   := {{"",0}}
Private nLenAnt   := 1

Private cMatDe, cMatAte
Private cCcDe, cCcAte

// Trata a Variavel das Filiais
cFilProc := StrTran(cFilProc,",","")
cFilProc := StrTran(cFilProc,"-","")
cFilProc := StrTran(cFilProc,"*","")
cFilProc := StrTran(cFilProc,";","")
cFilProc := U_fSqlIN(cFilProc,2)

Pergunte(cPerg,.F.)
 cMatDe   := mv_par01
 cMatAte  := mv_par02
 cCcDe    := mv_par03
 cCcAte   := mv_par04

SRA->(dbSetOrder( 1 ))
ZXC->(dbSetOrder( 1 ))

// Monta Query Principal
MsAguarde( {|| fMtaQuery()}, "Processando...", "Selecionado Registros no Banco de Dados..." )

dbSelectArea( "WSRA" )
Count To nTotReg
If nTotReg <= 0
   Aviso("ATENCAO","Nao Existem Dados para Este Relatorio",{"Sair"})
   WSRA->(dbCloseArea())
   Return
EndIf
dbGoTop()
oSelf:SetRegua1( nTotReg )

Do While !Eof()
   SRA->(dbGoTo( WSRA->RA_RECNO ))
   
   oSelf:IncRegua1( SRA->(RA_FILIAL + " - " + RA_MAT + " - " + RA_NOME) )
   If oSelf:lEnd 
      Exit
   EndIf
   
   // Reinicializa os Periodos
   cPerIni := MesAno(SRA->RA_ADMISSA)
   cPerFim := MesAno(dDataBase)

   // Reinicia as Variaveis
   nAnos     := 0
   nMeses    := 0
   cAnoRef   := ""
   nValor    := 0
   aMeses    := {}
   nValAcum  := 0
   nValMes   := 0
   nValAnt   := 0
   aSalarios := {}
   aValAnt   := {{"",0}}
   nLenAnt   := 1
   
   // Filtra Admitidos Posteriores ao Fim do Periodo
   If cPerIni > cTmpFim
      dbSkip()
      Loop
   EndIf
   
   // Monta o Historico Salarial do Funcionario
   U_fMontaSal( SRA->RA_FILIAL, SRA->RA_MAT, cPerIni, @aSalarios, .F. )
   
   // Determina a Quantidade de Meses Entre os Dois Periodos
   nAnos   := 0   ; nMeses  := 0   
   Do While cPerIni <= cPerFim
      nMeses++
      If ( nMeses % 12 ) == 0
         nAnos++ 
      EndIf
      
      Aadd(aMeses,{cPerIni,		;  // 01 - Mes e Ano
                   nAnos,		;  // 02 - Anos
                   nMeses,		;  // 03 - Meses
                   "",			;  // 04 - Mes Atualizacao do Valor
                   "",			;  // 05 - Tem Direito ao Valor
                   0,			;  // 06 - Valor do Anuenio Atual      
                   0,			;  // 07 - Valor do Salario de Referencia
                   ""}			)  // 08 - Mes do Aumento Salarial

      U_fSmaMesAno( @cPerIni )
   EndDo

   // Determina os Meses de Atualizacao
   For nX := 1 To Len( aMeses )
       If nX <= 24
          aMeses[nX,5] := "NAO"
       Else
          aMeses[nX,5] := "SIM"
          // Determina o Mes do Aniversario
          If StrZero(Month(SRA->RA_ADMISSA),2) == Right(aMeses[nX,1],2)
             aMeses[nX,4] := "ANI"
          EndIf
       EndIf
       // Determina o Mes do Reajustes Salarial
       If ( nPos := Ascan(aSalarios,{|x| x[1]==aMeses[nX,1]}) ) > 0
          aMeses[nX,8] := "SAL"
       EndIf
   Next nX
   
   // Apura os Valores Devidos
   For nX := 25 To Len( aMeses )
       nValAcum := aValAnt[nLenAnt,2]
       If aMeses[nX,1] < "200704"
          nValMes := 6
       Else
          nValMes := fAnuenio( aMeses[nX,1], @aMeses[nX,7] )
       EndIf
       
       If aMeses[nX,4] == "ANI"		// Mes do Aniversario na Empresa - Incrementa o Valor a Pagar em 01 Ano
          Aadd(aValAnt,{aMeses[nX,1],nValAcum+nValAnt})
          nLenAnt  := Len(aValAnt)
          nValAcum := aValAnt[nLenAnt,2]
          aMeses[nX,6] := nValAcum + nValMes
          nValAnt := nValMes
       ElseIf aMeses[nX,5] == "SIM"
          aMeses[nX,6] := nValAcum + nValMes	// 06 - Valor do Anuenio Atual
          nValAnt := nValMes
       EndIf
   Next nX

   dbSelectArea( "ZXC" )
   // Grava os Valores Apurados
   For nX := 1 To Len( aMeses )
       If !dbSeek( SRA->(RA_FILIAL + RA_MAT) + aMeses[nX,1] )
          RecLock("ZXC",.T.)
           ZXC_FILIAL := SRA->RA_FILIAL
           ZXC_MAT    := SRA->RA_MAT
           ZXC_DATARQ := aMeses[nX,1]
           ZXC_VALOR  := aMeses[nX,6]
           ZXC_PERC   := 1
           ZXC_SALBAS := aMeses[nX,7]
          MsUnlock()
       EndIf        
   Next nX
   		
   dbSelectArea( "WSRA" )
   dbSkip()
EndDo
WSRA->(dbCloseArea())  

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSGPEM21  �Autor  �Microsiga           � Data �  03/24/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP11                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
Static Function fAnuenio( cPeriodo, nRetSal )

 Local aOldAtu  := GETAREA()
 Local nPerc    := 1.00
 Local nMinimo  := 6.00
 Local nSalario := 0
 Local nValor   := 0
 Local nX
 
 // Determina a Base de Calculo
 For nX := 1 To Len( aSalarios )
     If aSalarios[nX,1] <= cPeriodo
        nSalario := aSalarios[nX,2]
     Else
        Exit
     EndIf
 Next nX

 If nSalario <= 0
    nSalario := If(SRA->RA_CATFUNC $ "EG",Round(SRA->RA_SALARIO * SRA->RA_HRSMES,2),SRA->RA_SALARIO)
 EndIf

 // Apura o Valor do Anuenio
 nValor  := Round(nSalario * (nPerc/100),2 )
 nValor  := If(nValor < 6, 6, nValor )
 nRetSal := nSalario

 RESTAREA( aOldAtu )

Return( nValor )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSGPEM21  �Autor  �Microsiga           � Data �  04/26/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
Static Function fMtaQuery()

 Local cQuery := ""
 
 cQuery += " SELECT SRA.RA_FILIAL,"
 cQuery += "        SRA.RA_MAT,"
 cQuery += "        SRA.R_E_C_N_O_ AS RA_RECNO"
 cQuery += " FROM " + RetSqlName( "SRA" ) + " SRA"
 cQuery += " WHERE SRA.D_E_L_E_T_ <> '*'"
 cQuery += "   AND SRA.RA_FILIAL IN (" + cFilProc  + ")"
 cQuery += "   AND SRA.RA_MAT    BETWEEN '" + cMatDe  + "' AND '" + cMatAte  + "'"
 cQuery += "   AND SRA.RA_CC     BETWEEN '" + cCcDe   + "' AND '" + cCcAte   + "'"
 cQuery += "   AND SRA.RA_SITFOLH <> 'D'"
 cQuery += " ORDER BY SRA.RA_FILIAL, SRA.RA_MAT"

 cQuery := ChangeQuery( cQuery )
 TCQuery cQuery New Alias "WSRA"
 TcSetField( "WSRA" , "RA_RECNO"   , "N", 08, 0 )
 
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fAsrPerg  �Autor  �Microsiga           � Data �  11/21/02   ���
�������������������������������������������������������������������������͹��
���Desc.     � Perguntas do Sistema.                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
Static Function fAsrPerg()

Local aRegs := {}
Local Fi    := FWSizeFilial()
Local Cc    := U_fTamCusto()

 aAdd(aRegs,{ cPerg,'01','Matricula De ?           ','','','mv_ch1','C',06,0,0,'G','           ','mv_par01','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SRA   ','' })
 aAdd(aRegs,{ cPerg,'02','Matricula Ate ?          ','','','mv_ch2','C',06,0,0,'G','NaoVazio   ','mv_par02','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SRA   ','' })
 aAdd(aRegs,{ cPerg,'03','Centro Custo De ?        ','','','mv_ch3','C',Cc,0,0,'G','           ','mv_par03','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','CTT   ','' })
 aAdd(aRegs,{ cPerg,'04','Centro Custo Ate ?       ','','','mv_ch4','C',Cc,0,0,'G','NaoVazio   ','mv_par04','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','CTT   ','' })
 U_fDelSx1( cPerg, "05" )

ValidPerg(aRegs,cPerg)

Return
