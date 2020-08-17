#Include "rwmake.ch"
#Include "protheus.ch"

/*
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������ͻ��
���Programa       �LIB_DATE  �Autor  � Adilson Silva      � Data � 13/12/2005  ���
������������������������������������������������������������������������������͹��
���Desc.          � Funcoes para Manipulacao de Datas.                         ���
���               �                                                            ���
������������������������������������������������������������������������������͹��
������������������������������������������������������������������������������͹��
��� fSomaDia      � Funcao para Somar Dias a Uma Data.                         ���
������������������������������������������������������������������������������͹��
��� fSubDia       � Funcao para Subtrair Dias de Uma Data.                     ���
������������������������������������������������������������������������������͹��
��� fSomaMes      � Funcao para Somar Meses a Uma Data.                        ���
������������������������������������������������������������������������������͹��
��� fSubMes       � Funcao para Subtrair Meses de Uma Data.                    ���
������������������������������������������������������������������������������͹��
��� fSomaAno      � Funcao para Somar Anos a Uma Data.                         ���
������������������������������������������������������������������������������͹��
��� fSubAno       � Funcao para Subtrair Anos de Uma Data.                     ���
������������������������������������������������������������������������������͹��
��� fDiasData     � Funcao para Retornar a Quantidade de Dias Entre Duas Datas.���
������������������������������������������������������������������������������͹��
��� fSmaMesAno    � Funcao para Somar Mes e Ano de Uma Variavel Tipo Caracter. ���
���               � Obrigatorio Uso no Formato AAAAMM.                         ���
������������������������������������������������������������������������������͹��
��� fSbMesAno     � Funcao para Subtrair Mes e Ano de Uma Variavel Tipo        ���
���               � Caracter. Obrigatorio Uso no Formato AAAAMM.               ���
������������������������������������������������������������������������������͹��
��� fAsrUltDia    � Funcao para Retornar o Ultimo Dia Valido de Uma Data.      ���
������������������������������������������������������������������������������͹��
��� fPosDia       � Funcao para Posicionar um Determinado Dia em Uma Data.     ���
������������������������������������������������������������������������������͹��
��� fConvData     � Funcao para Converter Datas em Caracter.                   ���
������������������������������������������������������������������������������͹��
���Uso            � Lib - Generico                                             ���
������������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
*/

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fSomaDia �Autor  � Adilson Silva      � Data � 13/12/2005  ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para Somar Dias a Uma Data.                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
User Function fSomaDia( dData, nReferencia )

 Local uRet

 DEFAULT nReferencia := 1
 
 uRet  := dData + nReferencia
 dData := uRet

Return( uRet )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fSubDia  �Autor  � Adilson Silva      � Data � 13/12/2005  ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para Subtrair Dias de Uma Data.                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
User Function fSubDia( dData, nReferencia )

 Local uRet

 DEFAULT nReferencia := 1
 
 uRet := dData - nReferencia
 dData := uRet

Return( uRet )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fSomaMes �Autor  � Adilson Silva      � Data � 13/12/2005  ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para Somar Meses a Uma Data.                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
User Function fSomaMes( dData, nReferencia )

 Local nDia  := 0
 Local nMes  := 0
 Local nAno  := 0
 Local nUlt  := 0
 Local dRet  := Ctod( "" )
 Local dTemp := Ctod( "" )
 Local nX

 If !Empty( dData )
    nDia  := Day( dData )
    nMes  := Month( dData )
    nAno  := Year( dData )
 
    nReferencia := If(nReferencia == Nil,0,nReferencia)
 
    For nX := 1 To nReferencia   
        U_fSoma1Mes( @nMes, @nAno )
    Next
    dTemp := Stod(StrZero(nAno,4) + StrZero(nMes,2) + "01" )
    nUlt  := U_fAsrUltDia( dTemp )

    nDia := If(nDia > nUlt,nUlt,nDia )
    dRet := Ctod( StrZero(nDia,2) + "/" + StrZero(nMes,2) + "/" + StrZero(nAno,4) )
 EndIf
 
Return( dRet )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fSubMes  �Autor  � Adilson Silva      � Data � 13/12/2005  ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para Subtrair Meses de Uma Data.                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
User Function fSubMes( dData, nReferencia )

 Local nDia := Day( dData )
 Local nMes := Month( dData )
 Local nAno := Year( dData )
 Local nUlt := U_fAsrUltDia( dData )
 Local i

 Local uRet
 
 DEFAULT nReferencia := 1
 
 For i := 1 To nReferencia   
     U_fSub1Mes( @nMes, @nAno )
 Next
 
 nUlt := U_fAsrUltDia( ,nMes )

 nDia := If(nDia > nUlt,nUlt,nDia )
 uRet := Ctod( StrZero(nDia,2) + "/" + StrZero(nMes,2) + "/" + StrZero(nAno,4) )
 
Return( uRet )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fSomaAno �Autor  � Adilson Silva      � Data � 13/12/2005  ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para Somar Anos a Uma Data.                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
User Function fSomaAno( dData, nReferencia )

 Local nDia := Day( dData )
 Local nMes := Month( dData )
 Local nAno := Year( dData )
 Local uRet
 
 DEFAULT nReferencia := 1

 // Testar Dia 29 de Fevereiro
 If nMes == 2 .And. nDia == 29
    nMes := 3
    nDia := 1
 EndIf
 
 uRet := Ctod( StrZero(nDia,2) + "/" + StrZero(nMes,2) + "/" + StrZero(nAno+nReferencia,4) )

Return( uRet )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fSubAno  �Autor  � Adilson Silva      � Data � 13/12/2005  ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para Subtrair Anos de Uma Data.                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
User Function fSubAno( dData, nReferencia )

 Local nDia := Day( dData )
 Local nMes := Month( dData )
 Local nAno := Year( dData )
 Local uRet := Ctod( StrZero(nDia,2) + "/" + StrZero(nMes,2) + "/" + StrZero(nAno-nReferencia,4) )

Return( uRet )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fDiasData �Autor  � Adilson Silva      � Data � 13/12/2005  ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para Retornar a Quantidade de Dias Entre Duas Datas.���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
User Function fDiasData( dData1, dData2, lOpcao )

 Local uRet
 Local dDt1 := Max( dData1, dData2 )
 Local dDt2 := Min( dData1, dData2 )
 
 lOpcao := If( lOpcao == Nil .Or. ValType( lOpcao ) # "L",.F.,lOpcao )
 
 uRet := dDt1 - dDt2 + If(lOpcao,1,0)

Return( uRet )

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  �fSmaMesAno �Autor  � Adilson Silva      � Data � 13/12/2005  ���
��������������������������������������������������������������������������͹��
���Desc.     � Funcao para Somar Mes e Ano de Uma Variavel Tipo Caracter   ���
���          � ou Tipo Data e Retorna no Formato AAAAMM.                   ���
��������������������������������������������������������������������������͹��
���Uso       � MP8                                                         ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������ */
User Function fSmaMesAno( xData )

 Local nMes, nAno, uRet
 Local lData := If( ValType(xData)=="D",.T.,.F. )

 nMes := If( lData,Month( xData ),Val(Right( xData,2 )) )
 nAno := If( lData,Year( xData ),Val(Left( xData,4 )) )

 U_fSoma1Mes( @nMes, @nAno )

 xData := StrZero(nAno,4) + StrZero(nMes,2)
 uRet  := xData
 
Return( uRet )

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  �fSbMesAno  �Autor  � Adilson Silva      � Data � 13/12/2005  ���
��������������������������������������������������������������������������͹��
���Desc.     � Funcao para Subtrair Mes e Ano de Uma Variavel Tipo Caracter���
���          � no Formato AAAAMM                                           ���
��������������������������������������������������������������������������͹��
���Uso       � MP8                                                         ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������ */
User Function fSbMesAno( xData )

 Local nMes, nAno, uRet
 Local lData := If( ValType(xData)=="D",.T.,.F. )

 nMes := If( lData,Month( xData ),Val(Right( xData,2 )) )
 nAno := If( lData,Year( xData ),Val(Left( xData,4 )) )

 U_fSub1Mes( @nMes, @nAno )

 xData := StrZero(nAno,4) + StrZero(nMes,2)
 uRet  := xData
 
Return( uRet )

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  �fPosDia    �Autor  � Adilson Silva      � Data � 13/12/2005  ���
��������������������������������������������������������������������������͹��
���Desc.     � Posiciona o Dia de Uma Data Conforme Parametros.            ���
���          �                                                             ���
��������������������������������������������������������������������������͹��
���Uso       � MP8                                                         ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������ */
User Function fPosDia( xData, nReferencia, lOpcao )

 Local uRet := Ctod( Space(08) )
 Local nDia, nMes, nAno, nUlt
 
 If ValType( xData ) # "D"
    Return( uRet )
 EndIf

 nReferencia := If( nReferencia == Nil,0,nReferencia )
 
 nDia := Day( xData )
 nMes := Month( xData )
 nAno := Year( xData )
 nUlt := U_fAsrUltDia( xData )
 
 If nReferencia > 0
    nUlt := If( nReferencia > nUlt,nUlt,nReferencia )
    uRet := Ctod( StrZero(nReferencia,2) + "/" + StrZero(nMes,2) + "/" + StrZero(nAno,4) )
    Return( uRet )
 EndIf
 
 If lOpcao == Nil
    uRet := xData
    Return( uRet )
 EndIf
 
 If lOpcao		// Retorna o 1o Dia do Mes
    uRet := Ctod( "01" + "/" + StrZero(nMes,2) + "/" + StrZero(nAno,4) )
 Else			// Retorna o Ultimo Dia do Mes
    uRet := Ctod( StrZero(nUlt,2) + "/" + StrZero(nMes,2) + "/" + StrZero(nAno,4) )
 EndIf
 
Return( uRet )



// ASR - FIM DAS FUNCOES DE DATA - INICIO DAS FUNCOES DE APOIO - ASR

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fAsrUltDia�Autor  � Adilson Silva      � Data � 13/12/2005  ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para Retornar o Ultimo Dia Valido do Mes de Uma     ���
���          � Data.                                                      ���
�������������������������������������������������������������������������͹��
���Uso       � MP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
User Function fAsrUltDia( uData, nQMes )

 Local nPos   := 0
 Local uRet   := Nil
 Local aMeses := { { "JAN" , 31 }, ;
                   { "FEV" , 28 }, ;
                   { "MAR" , 31 }, ;
                   { "ABR" , 30 }, ;
                   { "MAI" , 31 }, ;
                   { "JUN" , 30 }, ;
                   { "JUL" , 31 }, ;
                   { "AGO" , 31 }, ;
                   { "SET" , 30 }, ;
                   { "OUT" , 31 }, ;
                   { "NOV" , 30 }, ;
                   { "DEZ" , 31 }  }
                   
 DEFAULT nQMes := 0
                   
 If ValType( uData ) == "D"
    nPos := Month( uData )
    uRet := aMeses[nPos,2]
    If nPos == 2 .And. Type( "uData" ) == "D"
       If !Empty( Ctod( "29/02/" + StrZero(Year(uData),4) ) )
          uRet := 29
       EndIf
    EndIf
 ElseIf ValType( nQMes ) == "N" .And. nQMes > 0 .And. nQMes < 13
    uRet := aMeses[nQMes,2]
 ElseIf ValType( nQMes ) == "C" .And. Val(nQMes) > 0 .And. Val(nQMes) < 13
    uRet := aMeses[nQMes,2]
 EndIf
 
Return( uRet )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fSoma1Mes �Autor  � Adilson Silva      � Data � 13/12/2005  ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para Incrementar em Uma Unidade os Meses e Anos.    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
User Function fSoma1Mes( nMes, nAno )

 nMes++
 If nMes == 13
    nMes := 1
    nAno++
 EndIf
 
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fSub1Mes �Autor  � Adilson Silva      � Data � 13/12/2005  ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para Decrementar em Uma Unidade os Meses e Anos.    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
User Function fSub1Mes( nMes, nAno )

 nMes--
 If nMes == 0
    nMes := 12
    nAno--
 EndIf
 
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fConvData �Autor  � Adilson Silva      � Data � 25/01/2006  ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para Converter Datas em Caracter.                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
User Function fConvData( dData, cTipo )

 Local uRet
 Local i, cTmp
 Local nPosDia, nPosMes, nPosAno
 Local nTamDia, nTamMes, nTamAno
 Local cDia, cMes, cAno
 //Local lBarra, cBarra
 
 cTipo  := Upper(cTipo)
 //lBarra := "/" $ cTipo

 nPosDia := At( "D", cTipo )
 nPosMes := At( "M", cTipo )
 nPosAno := At( "A", cTipo )
 
 nTamDia := 0 ; nTamMes := 0 ; nTamAno := 0

 // Verifica Quantidade de Digitos para os Itens da Data
 For i := 1 To Len(cTipo)
     If SubStr(cTipo,i,1) == "D"
        nTamDia++
     ElseIf SubStr(cTipo,i,1) == "M"
        nTamMes++
     ElseIf SubStr(cTipo,i,1) == "A"
        nTamAno++
     EndIf
 Next

 cDia := StrZero( Day( dData ),nTamDia )
 cMes := StrZero( Month( dData ),nTamMes )
 cAno := StrZero( Year( dData ),4 )
 cAno := Right(cAno,nTamAno )
 
 //cBarra := If(lBarra,"/","")

 //cTmp := Space( nTamDia ) + cBarra + Space( nTamMes ) + cBarra + Space( nTamAno )
 cTmp := cTipo

 If nPosDia > 0
    cTmp := Stuff( cTmp,nPosDia,nTamDia,cDia )
 EndIf
 If nPosMes > 0
    cTmp := Stuff( cTmp,nPosMes,nTamMes,cMes )
 EndIf
 If nPosAno > 0
    cTmp := Stuff( cTmp,nPosAno,nTamAno,cAno )
 EndIf
 
 uRet := cTmp

Return( uRet )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fContaPer �Autor  � Adilson Silva      � Data � 06/06/2006  ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna Quantidade de Dias, Meses e Anos Entre Duas Datas. ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
User Function fContaPer( dDataIni, dDataFim, nDias, nMeses, nAnos, lDiaRef )

 Local uRet := {0,0,0}
 
 Local nDiaFim := If( lDiaRef,f_UltDia( dDataFim ),Day( dDataFim ) )
 Local nMesFim := Month( dDataFim )
 Local nAnoFim := Year( dDataFim )
 
 Local dDtTemp, nSoma
 
 DEFAULT nDias  := 0
 DEFAULT nMeses := 0
 DEFAULT nAnos  := 0
 
 // Remonta a Data Final
 dDataFim := Ctod( StrZero(nDiaFim,2) + "/" + StrZero(nMesFim,2) + "/" + Str(nAnoFim,4) )
 
 If dDataIni >= dDataFim
    Return( uRet )
 EndIf
 
 // Busca Quantidade de Anos
 dDtTemp := dDataIni
 Do While .T.
    nSoma := 365

    If U_fAnoBiss( dDtTemp, 12 )
       nSoma := 366
    EndIf
    
    If ( dDtTemp + nSoma ) <= dDataFim
       nAnos++ 
       dDtTemp += nSoma
    Else 
       Exit
    EndIf
 EndDo
 
 // Busca Quantidade de Meses
 Do While .T.
    nSoma := f_UltDia( dDtTemp )

    If ( (dDtTemp + nSoma) -1 ) <= dDataFim
       nMeses++ 
       dDtTemp += nSoma
    Else 
       Exit
    EndIf
 EndDo
 
 // Busca Quantidade de Dias
 nDias := ( dDataFim - dDtTemp ) +1
 nDias := If(nDias <= 0, 0, nDias)
 
 uRet[1] := nDias
 uRet[2] := nMeses
 uRet[3] := nAnos
 
Return( uRet )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LIB_DATE  �Autor  �Microsiga           � Data �  12/18/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
User Function fAnoBiss( xData, nMeses )

 Local lRet  := .F.
 Local dTemp := Ctod( "01/" + StrZero(Month(xData),2) + "/" + StrZero(Year(xData),4) )
 Local i, nAno
 
 DEFAULT nMeses := 1
 
 For i := 1 To nMeses
     nAno := Year( dTemp )

     If Month( dTemp ) == 2
        If !Empty( Ctod( "29/" + StrZero(Month(dTemp),2) + "/" + StrZero(Year(dTemp),4) ) )
           lRet := .T.
        EndIf
     EndIf

     dTemp := U_fSomaMes( dTemp, 1 )
 Next
 
Return( lRet )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LIB_DATE  �Autor  �Microsiga           � Data �  03/03/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
User Function fDtNoDelim( xData )

 Local cRet := ""
 
 DEFAULT xData := Ctod("")
 
 cRet := StrZero(Day(xData),2) + StrZero(Month(xData),2) + StrZero(Year(xData),4)

Return( cRet )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CALPLANO  �Autor  �Microsiga           � Data �  02/09/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP10                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
User Function fIdade( dNascto, dDtAtual )

 Local nIdade := Year(dDtAtual) - Year(dNascto)

 If Month(dNascto) > Month(dDtAtual)
	nIdade --
	nIdade += (12 - (Month(dNascto) - Month(dDtAtual)))/100
 ElseIf Month(dNascto) == Month(dDtAtual) .and. day(dNascto) > day(dDtAtual)
	nIdade -= 0.01
 ElseIf Month(dNascto) == Month(dDtAtual) .and. day(dNascto) < day(dDtAtual)
	nIdade += 0.01
 ElseIf Month(dNascto) < Month(dDtAtual)
	nIdade += (12 - (Month(dDtAtual) - Month(dNascto)))/100
	If day(dNascto) < day(dDtAtual)
		nIdade -= 0.01
	EndIf
 EndIf

Return( nIdade )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LIB_DATE  �Autor  �Microsiga           � Data �  05/11/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP10                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
User Function fTipoDia( uData, lUpper )

 Local cRet := ""
 
 DEFAULT uData  := dDataBase
 DEFAULT lUpper := .F.
 
 If     Dow( uData ) == 1
    cRet := "Domingo"
 ElseIf Dow( uData ) == 2
    cRet := "Segunda"
 ElseIf Dow( uData ) == 3
    cRet := "Terca"
 ElseIf Dow( uData ) == 4
    cRet := "Quarta"
 ElseIf Dow( uData ) == 5
    cRet := "Quinta"
 ElseIf Dow( uData ) == 6
    cRet := "Sexta"
 ElseIf Dow( uData ) == 7
    cRet := "Sabado"
 EndIf
 
 cRet := If(lUpper,Upper(cRet),cRet)

Return( cRet )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LIB_DATE  �Autor  �Microsiga           � Data �  05/11/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP10                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
User Function fMesExtenso( uData, lAbrev, lUpper )

 Local lData  := ValType( uData ) == "D"
 Local nMes   := If( lData, Month( uData ), Val( uData ) )
 Local aMeses := {}
 Local cRet   := ""
 
 Aadd( aMeses, "Janeiro"   )
 Aadd( aMeses, "Fevereiro" )
 Aadd( aMeses, "Marco"     )
 Aadd( aMeses, "Abril"     )
 Aadd( aMeses, "Maio"      )
 Aadd( aMeses, "Junho"     )
 Aadd( aMeses, "Julho"     )
 Aadd( aMeses, "Agosto"    )
 Aadd( aMeses, "Setembro"  )
 Aadd( aMeses, "Outubro"   )
 Aadd( aMeses, "Novembro"  )
 Aadd( aMeses, "Dezembro"  )
 
 If nMes > 0 .And. nMes < 13
    cRet := aMeses[nMes]
    cRet := If( lUpper, Upper( cRet ), cRet )
    cRet := If( lAbrev, Left( cRet,3 ), cRet )
 EndIf
 
Return( cRet )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LIB_DATE  �Autor  �Microsiga           � Data �  02/03/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP10                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
//User Function fRet()
//Return( uRet )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fContaPer �Autor  � Adilson Silva      � Data � 06/06/2006  ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna Quantidade de Dias, Meses e Anos Entre Duas Datas. ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
/*/ Desabilitado Temporariamente para Testes - 18/12/2006 - Asr
User Function fContaPer( dDataIni, dDataFim, nDias, nMeses, nAnos, lDiaRef )

 Local uRet := {0,0,0}
 
 Local nDiaIni := Day( dDataIni )
 Local nMesIni := Month( dDataIni )
 Local nAnoIni := Year( dDataIni )

 Local nDiaFim := If( lDiaRef,f_UltDia( dDataFim ),Day( dDataFim ) )
 Local nMesFim := Month( dDataFim )
 Local nAnoFim := Year( dDataFim )
 
 Local nDiasTemp  := 0
 Local nMesesTemp := 0
 Local nAnosTemp  := 0
 
 Local lSomaMes   := .F.
 Local lSomaAno   := .F.
 
 DEFAULT nDias  := 0
 DEFAULT nMeses := 0
 DEFAULT nAnos  := 0
 
 // Remonta a Data Final
 dDataFim := Ctod( StrZero(nDiaFim,2) + "/" + StrZero(nMesFim,2) + "/" + Str(nAnoFim,4) )
 
 If dDataIni >= dDataFim
    Return( uRet )
 EndIf
 
 nDiasTemp  := nDiaFim - nDiaIni + 1
 nMesesTemp := nMesFim - nMesIni
 nAnosTemp  := nAnoFim - nAnoIni
 
 // Calcula os Dias
 If nDiasTemp < 0
    nDiasTemp := f_UltDia( dDataIni ) + nDiasTemp + 1
    lSomaMes  := .T.
 EndIf
 // Calcula os Meses
 If nMesesTemp < 0
    nMesesTemp := 12 + nMesesTemp + If(lSomaMes,-1,0)
    lSomaAno   := .T.
 Else
    nMesesTemp += If(lSomaMes,-1,0)
 EndIf
 // Calcula os Anos
 If nAnosTemp < 0
    nAnosTemp := 0
 Else
    nAnosTemp += If(lSomaAno,-1,0)
 EndIf
 
 nDias  := uRet[1] := nDiasTemp
 nMeses := uRet[2] := nMesesTemp
 nAnos  := uRet[3] := nAnosTemp

Return( uRet )
/*/
