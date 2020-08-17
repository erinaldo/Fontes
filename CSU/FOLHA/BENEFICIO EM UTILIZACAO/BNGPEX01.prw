#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VRGPEX01 ºAutor  ³ Adilson Silva      º Data ³ 18/06/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Roteiros para Calculo da Folha de Pagamento.               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP11                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fDescVr  ºAutor  ³ Adilson Silva      º Data ³ 18/06/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera os Valores do Vale Refeicao no Calculo da Folha de    º±±
±±º          ³ Pagamento.                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function fDescVr()

Local cPdFunc    := aCodFol[050,1]		// Verba p/ Desconto do VR
Local cPdEmpr    := aCodFol[212,1]		// Verba p/ Parte Empresa do VR
Local cPdFolMes  := M_PDVRPFM			// Verba p/ Pagamento do VR na Folha
Local cPdAdiMes  := M_PDVRPGA			// Verba p/ Pagamento do VR no Adiantamento
Local cPdDevol   := M_PDVRDEV			// Verba p/ Devolucao do VR
Local cPdTotal   := M_PDVRTOT			// Verba p/ Total do VR
Local nValFunc   := 0
Local nValEmpr   := 0
Local nQtdeBen   := 0
Local nTotBen    := 0
Local nVlFolMes  := 0 
Local nVlAdiMes  := 0 
Local nFaltas    := 0
Local nFaltBenef := 0
Local lFolha     := c__Roteiro == "FOL"
Local lAdiant    := c__Roteiro == "ADI"
Local lRescisao  := c__Roteiro == "RES"
Local nFaltAnt   := 0
Local cFolMSeg   := U_fSmaMesAno( cFolMes )
Local lValFixo   := .F.
Local cTemp, cTemp1
Local nX, dX

Local nDiasDevoluc := 0
Local nDiasUtiliza := 0
Local aDiasUtiliza := {}

// Variaveis para Rescisao
Local cDias     := ""
Local nDiasBene := 0
Local nDiasExce := 0
Local nFator    := 0
Local nValTotal := 0
Local nValIndiv := 0
Local nValDevol := 0

Private cPdFaltas := GETMV("GP_PDFALTA",,"")				// Verbas Complementares para Desconto das Faltas 

DEFAULT cPdFolMes := Space( 03 )
DEFAULT cPdAdiMes := Space( 03 )
DEFAULT cPdDevol  := Space( 03 )
DEFAULT cPdTotal  := Space( 03 )

ZT7->(dbSetOrder( 2 ))		// ZT7_FILIAL+ZT7_MAT+ZT7_DATARQ+ZT7_COD
ZT8->(dbSetOrder( 1 ))		// ZT8_FILIAL+ZT8_COD

dbSelectArea( "ZT7" )
// Busca os Valores a Pagar em Folha Referentes a Competencia Seguinte
dbSeek( SRA->(RA_FILIAL + RA_MAT) + cFolMSeg )
Do While !Eof() .And. ZT7->(ZT7_FILIAL + ZT7_MAT + ZT7_DATARQ) == SRA->(RA_FILIAL + RA_MAT) + cFolMSeg
   If ZT7->ZT7_TIPO == "1" .And. ZT7->ZT7_STATUS == "1"		// Refeicao
      // Monta o Valor a Pagar na Folha
      If ZT7->ZT7_PEDIDO == "2" .And. ZT7->ZT7_PERCAL == cFolMes .And. !lRescisao
         nVlFolMes += ZT7->ZT7_TTVALE
      EndIf
      // Monta o Valor a Pagar no Adiantamento
      If lAdiant .And. ZT7->ZT7_PEDIDO == "3" .And. ZT7->ZT7_PERCAL == cFolMes .And. !lRescisao
         nVlAdiMes += ZT7->ZT7_TTVALE
      EndIf
   EndIf
   
   dbSkip()
EndDo

// Processa os Valores do Mes de Competencia do Calculo da Folha
dbSeek( SRA->(RA_FILIAL + RA_MAT) + cFolMes )
Do While !Eof() .And. ZT7->(ZT7_FILIAL + ZT7_MAT + ZT7_DATARQ) == SRA->(RA_FILIAL + RA_MAT) + cFolMes
   ZT8->(dbSeek( RhFilial("ZT8",SRA->RA_FILIAL) + ZT7->ZT7_COD ))
   // Determina a Verba de Desconto Pelo Cadastro do Beneficio
   If !Empty( ZT8->ZT8_PDDESC )
      cPdFunc := ZT8->ZT8_PDDESC
   EndIf
   // Determina a Verba do Custo da Empresa Pelo Cadastro do Beneficio
   If !Empty( ZT8->ZT8_PDEMPR )
      cPdEmpr := ZT8->ZT8_PDEMPR
   EndIf
   If ZT7->ZT7_TIPO == "1" .And. ZT7->ZT7_STATUS == "1"		// Refeicao
      // Soma os Valores a Serem Pagos na Folha de Pagamento
      If lFolha .Or. lRescisao
         nValFunc := nValFunc + ZT7->ZT7_VLFUNC
         nValEmpr := nValEmpr + ZT7->ZT7_VLEMPR
         // Monta o Valor a Pagar na Folha
         If ZT7->ZT7_PEDIDO == "2" .And. ZT7->ZT7_PERCAL == cFolMes 		//.And. !lRescisao
            nVlFolMes += ZT7->ZT7_TTVALE
         EndIf
      EndIf
      // Monta o Valor a Pagar no Adiantamento
      If lAdiant .And. ZT7->ZT7_PEDIDO == "3" .And. ZT7->ZT7_PERCAL == cFolMes 		//.And. !lRescisao
         nVlAdiMes += ZT7->ZT7_TTVALE
      EndIf
      // Apura a Quantidade de Dias do Beneficio
      If !( Alltrim(ZT7->ZT7_DIAS) $ cDias )
         nQtdeBen := nQtdeBen + ZT7->ZT7_DIACAL
         cDias    := cDias    + Alltrim(ZT7->ZT7_DIAS)
         cTemp    := ""
         cTemp1   := Alltrim(ZT7->ZT7_DIAS)
         For nX := 1 To Len( cTemp1 ) Step 2 
             cTemp += SubStr(cTemp1,nX,2) + "-"
         Next nX
         For dX := ZT7->ZT7_DTDE To ZT7->ZT7_DTATE
             If StrZero(Day(dX),2) $ cTemp
                Aadd(aDiasUtiliza,dX)
             EndIf
         Next dX
      EndIf
      nFaltBenef += ZT7->ZT7_FALTAS
      // Determina se o Beneficio eh de Valor Fixo
      lValFixo   := ZT7->ZT7_COD $ "301/302/303"
   EndIf
   
   dbSkip()
EndDo
// Apura o Total Vale Refeicao
nValTotal := nValFunc + nValEmpr
nTotBen   := nValTotal

If lRescisao .And. !Empty( cPdDevol ) .And. !lValFixo
   // Dias para Devolucao do Beneficio
   Aeval(aDiasUtiliza,{|x| nDiasDevoluc += If(x>dDataDem,1,0)})
   // Total de Dias Pagos do Beneficio
   nDiasBene := Len( aDiasUtiliza ) - nFaltBenef
   // Total de Dias Utilizados do Beneficio
   nDiasUtiliza := Len( aDiasUtiliza ) - nDiasDevoluc
   // Verificar se a Verba dos Dias Utilizados foi Lancada
   If fBuscaPd( "960", "H" ) > 0 .Or. fBuscaPd( "960", "V" ) > 0
      nDiasUtiliza := fBuscaPd( "960", "H" )
   EndIf
   // Busca Falta do Mes Anterior
   U_fRetFaltas( @nFaltAnt, 1, dDataBase )
   nFaltas  := nFaltAnt
   nFaltAnt := 0
   For nX := 1 To Len( aPd )
       If aPd[nX,9] <> "D" .And. aPd[nX,1] $ ( aCodFol[054,1]+"*"+aCodFol[242,1]+"*"+cPdFaltas )
          If aPd[nX,6] == "D" 
             nFaltAnt += aPd[nX,4] 
          ElseIf aPd[nX,6] == "H"
             nDia := (aPd[nX,4]/(SRA->RA_HRSMES/30)) - Int(aPd[nX,4]/(SRA->RA_HRSMES/30))
             If nDia < 0.5
                nFaltAnt += Int(aPd[nX,4]/(SRA->RA_HRSMES/30))
             Else
                nFaltAnt += (Int(aPd[nX,4]/(SRA->RA_HRSMES/30)) + 1)
             EndIf
          EndIf
       EndIf
   Next nX
   nFaltas += nFaltAnt
   // Dias para Devolucao
   nDiasExce := nDiasDevoluc + nFaltas

   If nDiasExce > 0
      // Apura o Total Vale Refeicao
      nValTotal := nValFunc + nValEmpr
      // Determina o Total do Vale Refeicao Pago
      nTotBen   := nValTotal
      // Apura o Valor Individual do Beneficio
      nValIndiv := Round( nValTotal / nDiasBene,2 )
      // Apura o Percentual de Desconto
      nFator    := nValFunc / nValTotal
      // Apura o Valor da Devolucao
      nValDevol := Round( nValIndiv * nDiasExce,2 )
      // Apura o Novo Valor para Folha
      //nValTotal := If( nValTotal-nValDevol<0, 0, nValTotal-nValDevol )
      nValTotal := Round( nValIndiv * nDiasUtiliza,2 )
      // Apura o Desconto do Funcionario
      nValFunc  := Round( nValTotal * nFator,2 )
      // Apura a Parte da Empresa
      //nValEmpr  := nValTotal - nValFunc
      nValEmpr  := nTotBen - ( nValFunc + nValDevol )
      nValEmpr  := If(nValEmpr > 0, nValEmpr, 0)
      // Determina os Dias Pagos do Beneficio
      nQtdeBen := nDiasUtiliza		//If( nDiasBene-nDiasExce<0, 0, nDiasBene-nDiasExce )
   EndIf
EndIf

// Grava o Provento para Pagamento do VR na Folha
If ( lFolha .Or. lRescisao ) .And. cPdFolMes <> Space(03) .And. nVlFolMes > 0
	fGeraVerba(cPdFolMes,nVlFolMes,nQtdeBen,,,,,,,,.T.)
EndIf

// Grava o Provento para Pagamento do VR no Adiantamento
If lAdiant .And. cPdAdiMes <> Space(03) .And. nVlAdiMes > 0
	fGeraVerba(cPdAdiMes,nVlAdiMes,nQtdeBen,,,,,,,,.T.)
EndIf

// Grava Desconto do VR
If !Empty( cPdFunc ) .And. nValFunc > 0
	fGeraVerba(cPdFunc,nValFunc,nQtdeBen,,,,,,,,.T.)
EndIf

// Grava Parte Empresa do VR
If !Empty( cPdEmpr ) .And. nValEmpr > 0
	fGeraVerba(cPdEmpr,nValEmpr,nQtdeBen,,,,,,,,.T.)
EndIf

// Grava o Total do VR
If !Empty( cPdTotal ) .And. nTotBen > 0
	fGeraVerba(cPdTotal,nTotBen,nQtdeBen,,,,,,,,.T.)
EndIf

// Grava a Devolucao do VR na Rescisao
If !Empty( cPdDevol ) .And. nValDevol > 0
	fGeraVerba(cPdDevol,nValDevol,nDiasExce,,,,,,,,.T.)
EndIf

ZT7->(dbSetOrder( 1 ))

Return( "" )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fDescVa  ºAutor  ³ Adilson Silva      º Data ³ 18/06/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera os Valores do Vale Alimentacao no Calculo da Folha de º±±
±±º          ³ Pagamento.                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function fDescVa()

Local cPdFunc    := M_PDVADES			// Verba p/ Desconto do VA
Local cPdEmpr    := M_PDVAEMP			// Verba p/ Parte Empresa do VA
Local cPdFolMes  := M_PDVAPFM			// Verba p/ Pagamento do VA na Folha
Local cPdAdiMes  := M_PDVAPGA			// Verba p/ Pagamento do VA no Adiantamento
Local cPdDevol   := M_PDVADEV			// Verba p/ Devolucao do VA
Local cPdTotal   := M_PDVATOT			// Verba p/ Total do VA
Local nValFunc   := 0
Local nValEmpr   := 0
Local nQtdeBen   := 0
Local nTotBen    := 0
Local nVlFolMes  := 0 
Local nVlAdiMes  := 0 
Local nFaltas    := 0
Local nFaltBenef := 0
Local lFolha     := c__Roteiro == "FOL"
Local lAdiant    := c__Roteiro == "ADI"
Local lRescisao  := c__Roteiro == "RES"
Local nFaltAnt   := 0
Local cFolMSeg   := U_fSmaMesAno( cFolMes )
Local cTemp, cTemp1
Local nX, dX

Local nDiasDevoluc := 0
Local nDiasUtiliza := 0
Local aDiasUtiliza := {}

// Variaveis para Rescisao
Local cDias     := ""
Local nDiasBene := 0
Local nDiasExce := 0
Local nFator    := 0
Local nValTotal := 0
Local nValIndiv := 0
Local nValDevol := 0

Private cPdFaltas := GETMV("GP_PDFALTA",,"")				// Verbas Complementares para Desconto das Faltas 

DEFAULT cPdFolMes := Space( 03 )
DEFAULT cPdAdiMes := Space( 03 )
DEFAULT cPdDevol  := Space( 03 )
DEFAULT cPdTotal  := Space( 03 )

ZT7->(dbSetOrder( 2 ))		// ZT7_FILIAL+ZT7_MAT+ZT7_DATARQ+ZT7_COD
ZT8->(dbSetOrder( 1 ))		// ZT8_FILIAL+ZT8_COD

dbSelectArea( "ZT7" )
// Busca os Valores a Pagar em Folha Referentes a Competencia Seguinte
dbSeek( SRA->(RA_FILIAL + RA_MAT) + cFolMSeg )
Do While !Eof() .And. ZT7->(ZT7_FILIAL + ZT7_MAT + ZT7_DATARQ) == SRA->(RA_FILIAL + RA_MAT) + cFolMSeg
   If ZT7->ZT7_TIPO == "2" .And. ZT7->ZT7_STATUS == "1"		// Alimentacao
      // Monta o Valor a Pagar na Folha
      If ZT7->ZT7_PEDIDO == "2" .And. ZT7->ZT7_PERCAL == cFolMes .And. !lRescisao
         nVlFolMes += ZT7->ZT7_TTVALE
      EndIf
      // Monta o Valor a Pagar no Adiantamento
      If lAdiant .And. ZT7->ZT7_PEDIDO == "3" .And. ZT7->ZT7_PERCAL == cFolMes .And. !lRescisao
         nVlAdiMes += ZT7->ZT7_TTVALE
      EndIf
   EndIf
   
   dbSkip()
EndDo

// Processa os Valores do Mes de Competencia do Calculo da Folha
dbSeek( SRA->(RA_FILIAL + RA_MAT) + cFolMes )
Do While !Eof() .And. ZT7->(ZT7_FILIAL + ZT7_MAT + ZT7_DATARQ) == SRA->(RA_FILIAL + RA_MAT) + cFolMes
   ZT8->(dbSeek( RhFilial("ZT8",SRA->RA_FILIAL) + ZT7->ZT7_COD ))
   // Determina a Verba de Desconto Pelo Cadastro do Beneficio
   If !Empty( ZT8->ZT8_PDDESC )
      cPdFunc := ZT8->ZT8_PDDESC
   EndIf
   // Determina a Verba do Custo da Empresa Pelo Cadastro do Beneficio
   If !Empty( ZT8->ZT8_PDEMPR )
      cPdEmpr := ZT8->ZT8_PDEMPR
   EndIf
   If ZT7->ZT7_TIPO == "2" .And. ZT7->ZT7_STATUS == "1"		// Alimentacao
      // Soma os Valores a Serem Pagos na Folha de Pagamento
      If lFolha .Or. lRescisao
         nValFunc := nValFunc + ZT7->ZT7_VLFUNC
         nValEmpr := nValEmpr + ZT7->ZT7_VLEMPR
         // Monta o Valor a Pagar na Folha
         If ZT7->ZT7_PEDIDO == "2" .And. ZT7->ZT7_PERCAL == cFolMes 		//.And. !lRescisao
            nVlFolMes += ZT7->ZT7_TTVALE
         EndIf
      EndIf
      // Monta o Valor a Pagar no Adiantamento
      If lAdiant .And. ZT7->ZT7_PEDIDO == "3" .And. ZT7->ZT7_PERCAL == cFolMes 		//.And. !lRescisao
         nVlAdiMes += ZT7->ZT7_TTVALE
      EndIf
      // Apura a Quantidade de Dias do Beneficio
      If !( Alltrim(ZT7->ZT7_DIAS) $ cDias )
         nQtdeBen := nQtdeBen + ZT7->ZT7_DIACAL
         cDias    := cDias    + Alltrim(ZT7->ZT7_DIAS)
         cTemp    := ""
         cTemp1   := Alltrim(ZT7->ZT7_DIAS)
         For nX := 1 To Len( cTemp1 ) Step 2 
             cTemp += SubStr(cTemp1,nX,2) + "-"
         Next nX
         For dX := ZT7->ZT7_DTDE To ZT7->ZT7_DTATE
             If StrZero(Day(dX),2) $ cTemp
                Aadd(aDiasUtiliza,dX)
             EndIf
         Next dX
	  EndIf
      nFaltBenef += ZT7->ZT7_FALTAS
   EndIf
   
   dbSkip()
EndDo
// Apura o Total Vale Refeicao
nValTotal := nValFunc + nValEmpr
nTotBen   := nValTotal

If lRescisao .And. !Empty( cPdDevol )
   // Dias para Devolucao do Beneficio
   Aeval(aDiasUtiliza,{|x| nDiasDevoluc += If(x>dDataDem,1,0)})
   // Total de Dias Pagos do Beneficio
   nDiasBene := Len( aDiasUtiliza ) - nFaltBenef
   // Total de Dias Utilizados do Beneficio
   nDiasUtiliza := Len( aDiasUtiliza ) - nDiasDevoluc
   // Verificar se a Verba dos Dias Utilizados foi Lancada
   If fBuscaPd( "960", "H" ) > 0 .Or. fBuscaPd( "960", "V" ) > 0
      nDiasUtiliza := fBuscaPd( "960", "H" )
   EndIf
   // Busca Falta do Mes Anterior
   U_fRetFaltas( @nFaltAnt, 1, dDataBase )
   nFaltas  := nFaltAnt
   nFaltAnt := 0
   For nX := 1 To Len( aPd )
       If aPd[nX,9] <> "D" .And. aPd[nX,1] $ ( aCodFol[054,1]+"*"+aCodFol[242,1]+"*"+cPdFaltas )
          If aPd[nX,6] == "D" 
             nFaltAnt += aPd[nX,4] 
          ElseIf aPd[nX,6] == "H"
             nDia := (aPd[nX,4]/(SRA->RA_HRSMES/30)) - Int(aPd[nX,4]/(SRA->RA_HRSMES/30))
             If nDia < 0.5
                nFaltAnt += Int(aPd[nX,4]/(SRA->RA_HRSMES/30))
             Else
                nFaltAnt += (Int(aPd[nX,4]/(SRA->RA_HRSMES/30)) + 1)
             EndIf
          EndIf
       EndIf
   Next nX
   nFaltas += nFaltAnt
   // Dias para Devolucao
   nDiasExce := nDiasDevoluc + nFaltas

   If nDiasExce > 0
      // Apura o Total Vale Refeicao
      nValTotal := nValFunc + nValEmpr
      // Determina o Total do Vale Refeicao Pago
      nTotBen   := nValTotal
      // Apura o Valor Individual do Beneficio
      nValIndiv := Round( nValTotal / nDiasBene,2 )
      // Apura o Percentual de Desconto
      nFator    := nValFunc / nValTotal
      // Apura o Valor da Devolucao
      nValDevol := Round( nValIndiv * nDiasExce,2 )
      // Apura o Novo Valor para Folha
      //nValTotal := If( nValTotal-nValDevol<0, 0, nValTotal-nValDevol )
      nValTotal := Round( nValIndiv * nDiasUtiliza,2 )
      // Apura o Desconto do Funcionario
      nValFunc  := Round( nValTotal * nFator,2 )
      // Apura a Parte da Empresa
      //nValEmpr  := nValTotal - nValFunc
      nValEmpr  := nTotBen - ( nValFunc + nValDevol )
      nValEmpr  := If(nValEmpr > 0, nValEmpr, 0)
      // Determina os Dias Pagos do Beneficio
      nQtdeBen := nDiasUtiliza		//If( nDiasBene-nDiasExce<0, 0, nDiasBene-nDiasExce )
   EndIf
EndIf

// Grava o Provento para Pagamento do VA na Folha
If ( lFolha .Or. lRescisao ) .And. cPdFolMes <> Space(03) .And. nVlFolMes > 0
	fGeraVerba(cPdFolMes,nVlFolMes,nQtdeBen,,,,,,,,.T.)
EndIf

// Grava o Provento para Pagamento do VA no Adiantamento
If lAdiant .And. cPdAdiMes <> Space(03) .And. nVlAdiMes > 0
	fGeraVerba(cPdAdiMes,nVlAdiMes,nQtdeBen,,,,,,,,.T.)
EndIf

// Grava Desconto do VA
If !Empty( cPdFunc ) .And. nValFunc > 0
	fGeraVerba(cPdFunc,nValFunc,nQtdeBen,,,,,,,,.T.)
EndIf

// Grava Parte Empresa do VA
If !Empty( cPdEmpr ) .And. nValEmpr > 0
	fGeraVerba(cPdEmpr,nValEmpr,nQtdeBen,,,,,,,,.T.)
EndIf

// Grava o Total do VA
If !Empty( cPdTotal ) .And. nTotBen > 0
	fGeraVerba(cPdTotal,nTotBen,nQtdeBen,,,,,,,,.T.)
EndIf

// Grava a Devolucao do VA na Rescisao
If !Empty( cPdDevol ) .And. nValDevol > 0
	fGeraVerba(cPdDevol,nValDevol,nDiasExce,,,,,,,,.T.)
EndIf

ZT7->(dbSetOrder( 1 ))

Return( "" )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fDescVt  ºAutor  ³ Adilson Silva      º Data ³ 20/07/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera os Valores do Vale Transporte no Calculo da Folha de  º±±
±±º          ³ Pagamento.                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function fDescVt()

Local cPdFunc    := aCodFol[051,1]			  			// Verba p/ Desconto do VT
Local cPdEmpr    := aCodFol[210,1]			   			// Verba p/ Parte Empresa do VT
Local cPdFolMes  := M_PDVTPFM				  			// Verba p/ Pagamento do VT do Mes - Folha
Local cPdAdiMes  := M_PDVTPGA				  			// Verba p/ Pagamento do VT do Mes - Adiantamento
Local cPdDevol   := M_PDVTDEV				  			// Verba p/ Devolucao do VT
Local cPdTotal   := M_PDVTTOT				   			// Verba p/ Total do VT
Local cTipSal    := GETMV( "GP_VTBDESC",,"1")			// 1=Salario Base;2=Salario Incorporado
Local lPropDias  := GETMV( "GP_VTDPROP",,"S") == "S"	// Proporcionaliza Desconto Sobre Dias Trabalhados
Local cNoVrCalc  := GETMV( "GP_VTNOCAT",,"")			// Categorias Funcionais que NAO tem Desconto do Vale Transporte
Local nPercVt    := fPercVt()
Local aItens     := {}
Local aPerPagto  := {}
Local nBaseCalc  := 0
Local nValFunc   := 0
Local nValEmpr   := 0
Local nVlFolMes  := 0 
Local nVlAdiMes  := 0 
Local nTotBenef  := 0
Local nFaltas    := 0
Local nFaltBenef := 0
Local nValAdic   := 0
Local lFolha     := c__Roteiro == "FOL"
Local lAdiant    := c__Roteiro == "ADI"
Local lRescisao  := c__Roteiro == "RES"
Local nFaltAnt   := 0
Local lFaltaCalc := .T.
Local cFolMSeg   := U_fSmaMesAno( cFolMes )
Local cTemp, cTemp1
Local nX, dX
Local nLen

Local nDiasDevoluc := 0
Local nDiasUtiliza := 0
Local aDiasUtiliza := {}

// Variaveis para Rescisao
Local cDias     := ""
Local nDiasBene := 0
Local nDiasExce := 0
Local nFator    := 0
Local nValTotal := 0
Local nValIndiv := 0
Local nValDevol := 0

// Variaveis para Rateio
Local nPercRat := 0
Local nValRat  := 0
Local nValSald := 0

Private cPdFaltas := GETMV("GP_PDFALTA",,"")				// Verbas Complementares para Desconto das Faltas 

DEFAULT cPdFolMes  := Space( 03 )
DEFAULT cPdAdiMes  := Space( 03 )
DEFAULT cPdDevol   := Space( 03 )
DEFAULT cPdTotal   := Space( 03 )

SRN->(dbSetOrder( 1 ))		// RN_FILIAL+RN_COD
ZTB->(dbSetOrder( 2 ))		// ZTB_FILIAL+ZTB_MAT+ZTB_DATARQ+ZTB_COD

dbSelectArea( "ZTB" )
// Busca os Valores a Pagar em Folha Referentes a Competencia Seguinte
dbSeek( SRA->(RA_FILIAL + RA_MAT) + cFolMSeg )
Do While !Eof() .And. ZTB->(ZTB_FILIAL + ZTB_MAT + ZTB_DATARQ) == SRA->(RA_FILIAL + RA_MAT) + cFolMSeg
   If ZTB->ZTB_STATUS == "1"			// Transporte
      // Monta o Valor a Pagar na Folha
      If ZTB->ZTB_PEDIDO == "2" .And. ZTB->ZTB_PERCAL == cFolMes .And. !lRescisao
         nVlFolMes += ZTB->ZTB_TTVALE
      EndIf
      // Monta o Valor a Pagar no Adiantamento
      If lAdiant .And. ZTB->ZTB_PEDIDO == "3" .And. ZTB->ZTB_PERCAL == cFolMes .And. !lRescisao
         nVlAdiMes += ZTB->ZTB_TTVALE
      EndIf
   EndIf
   
   dbSkip()
EndDo

// Processa os Valores do Mes de Competencia do Calculo da Folha
dbSeek( SRA->(RA_FILIAL + RA_MAT) + cFolMes )
Do While !Eof() .And. ZTB->(ZTB_FILIAL + ZTB_MAT + ZTB_DATARQ) == SRA->(RA_FILIAL + RA_MAT) + cFolMes
   If ZTB->ZTB_STATUS == "1"			// Transporte
      SRN->(dbSeek( xFilial("SRN") + ZTB->ZTB_COD ))
	
      // Compoe o Total do Vale Transporte
      Aadd(aItens,{ZTB->(ZTB_TTVALE+ZTB_VLDIFE),0,0,ZTB->(Recno())})
      
      // Soma os Valores a Serem Pagos na Folha de Pagamento
      If lFolha .Or. lRescisao
         If ZTB->ZTB_PEDIDO == "2" .And. ZTB->ZTB_PERCAL == cFolMes		// .And. !lRescisao
            nVlFolMes += ZTB->(ZTB_TTVALE+ZTB_VLDIFE)
            Aadd(aPerPagto,ZTB->(Recno()))
         EndIf
      EndIf
      // Soma os Valores a Serem Pagos na Folha do Adiantamento
      If lAdiant .And. ZTB->ZTB_PEDIDO == "3" .And. ZTB->ZTB_PERCAL == cFolMes 		//.And. !lRescisao
         nVlAdiMes += ZTB->(ZTB_TTVALE+ZTB_VLDIFE)
         Aadd(aPerPagto,ZTB->(Recno()))
      EndIf

      // Apura a Quantidade de Dias do Beneficio
      If !( Alltrim(ZTB->ZTB_DIAS) $ cDias )
         cDias := cDias + Alltrim(ZTB->ZTB_DIAS)
         cTemp    := ""
         cTemp1   := Alltrim(ZTB->ZTB_DIAS)
         For nX := 1 To Len( cTemp1 ) Step 2 
             cTemp += SubStr(cTemp1,nX,2) + "-"
         Next nX
         For dX := ZTB->ZTB_DTDE To ZTB->ZTB_DTATE
             If StrZero(Day(dX),2) $ cTemp
                Aadd(aDiasUtiliza,dX)
             EndIf
         Next dX
      EndIf
      If lFaltaCalc
         nFaltBenef += ZTB->ZTB_FALTAS
         lFaltaCalc := .F.
      EndIf
   EndIf
   
   dbSkip()
EndDo

// Calcula o Desconto e a Parte Empresa
If ( nLen := Len( aItens ) ) > 0
   If lFolha .Or. lRescisao
      // Apura do Total do Vale Transporte
      Aeval(aItens,{|x| nTotBenef += x[1]})
      // Busca Valores Lancados na Verba 013
      nValAdic := fBuscaPd( "013" )
      // Apura a Base para Desconto
      nBaseCalc := If(cTipSal=="1",SALARIO,SALMES)
      // Para a CSU Deve Buscar a Verba do Salario Pago no Mes (101)
      nBaseCalc := fBuscaPd( "101" )
      // Considera Salario do Cadastro Quando Salario do Mes Zerado
      If nBaseCalc <= 0
         nBaseCalc := If(SRA->RA_CATFUNC $ "EG",Round(SRA->RA_SALARIO * SRA->RA_HRSMES,2),SRA->RA_SALARIO)
         If lPropDias
            nBaseCalc := Round( (nBaseCalc / 30) * DiasTrab,2 )
         EndIf                             
      EndIf
      // Apura o Desconto do Funcionario
      If !( SRA->RA_CATFUNC $ cNoVrCalc )
         nValFunc := Round( nBaseCalc * (nPercVt/100),2 )
         nValFunc := Min(nTotBenef,nValFunc)
      EndIf
      // Apura a Parte da Empresa
      nValEmpr := nTotBenef - nValFunc
      // Rateio do Vale Transporte para Gravar nas Tabelas do Calculo
      For nX := 1 To nLen
          If nX == nLen
             nValRat := nValFunc - nValSald
             aItens[nX,2] := nValRat
             aItens[nX,3] := aItens[nX,1] - nValRat
          Else
             nPercRat := aItens[nX,1] / nTotBenef
             nValRat  := Round(nValFunc * nPercRat,2)
             nValSald := nValSald + nValRat
             aItens[nX,2] := nValRat
             aItens[nX,3] := aItens[nX,1] - nValRat
          EndIf
      Next nX
      // Grava o Rateio
      dbSelectArea( "ZTB" )
      For nX := 1 To nLen
          dbGoTo( aItens[nX,4] )
          RecLock("ZTB",.F.)
           ZTB->ZTB_VLFUNC := aItens[nX,2]
           ZTB->ZTB_VLEMPR := aItens[nX,3]
           ZTB->ZTB_SALARI := nBaseCalc
          MsUnlock()
      Next nX
   EndIf
   // Apura o Total Vale Refeicao
   nValTotal := nValFunc + nValEmpr

   // Calculo para Rescisao
   If lRescisao .And. !Empty( cPdDevol )
      // Dias para Devolucao do Beneficio
      Aeval(aDiasUtiliza,{|x| nDiasDevoluc += If(x>dDataDem,1,0)})
      // Total de Dias Pagos do Beneficio
      nDiasBene := Len( aDiasUtiliza ) - nFaltBenef
      // Total de Dias Utilizados do Beneficio
      nDiasUtiliza := Len( aDiasUtiliza ) - nDiasDevoluc
      // Busca Falta do Mes Anterior
      U_fRetFaltas( @nFaltAnt, 1, dDataBase )
      nFaltas  := nFaltAnt
      nFaltAnt := 0
      For nX := 1 To Len( aPd )
          If aPd[nX,9] <> "D" .And. aPd[nX,1] $ ( aCodFol[054,1]+"*"+aCodFol[242,1]+"*"+cPdFaltas )
             If aPd[nX,6] == "D" 
                nFaltAnt += aPd[nX,4] 
             ElseIf aPd[nX,6] == "H"
                nDia := (aPd[nX,4]/(SRA->RA_HRSMES/30)) - Int(aPd[nX,4]/(SRA->RA_HRSMES/30))
                If nDia < 0.5
                   nFaltAnt += Int(aPd[nX,4]/(SRA->RA_HRSMES/30))
                Else
                   nFaltAnt += (Int(aPd[nX,4]/(SRA->RA_HRSMES/30)) + 1)
                EndIf
             EndIf
          EndIf
      Next nX
      nFaltas += nFaltAnt
      // Dias para Devolucao
      nDiasExce := nDiasDevoluc + nFaltas

      If nDiasExce > 0
         // Apura o Total Vale Refeicao
         nValTotal := nValFunc + nValEmpr
         // Determina o Total do Vale Refeicao Pago
         nTotBenef := nValTotal
         // Apura o Valor Individual do Beneficio
         nValIndiv := Round( nValTotal / nDiasBene,2 )
         // Apura o Percentual de Desconto
         nFator    := nValFunc / nValTotal
         // Apura o Valor da Devolucao
         nValDevol := Round( nValIndiv * nDiasExce,2 )
         // Apura o Novo Valor para Folha
         //nValTotal := If( nValTotal-nValDevol<0, 0, nValTotal-nValDevol )
         nValTotal := Round( nValIndiv * nDiasUtiliza,2 )
         // Apura o Desconto do Funcionario
         If !( SRA->RA_CATFUNC $ cNoVrCalc )
            nValFunc := Round( nBaseCalc * (nPercVt/100),2 )
            nValFunc := Min(nValTotal,nValFunc)
         EndIf
         // Apura a Parte da Empresa
         //nValEmpr  := nValTotal - nValFunc
         nValEmpr  := nTotBenef - ( nValFunc + nValDevol )
         nValEmpr  := If(nValEmpr > 0, nValEmpr, 0)
      EndIf
   EndIf
EndIf

// Grava o Provento para Pagamento do VT do Mes - Folha
If ( lFolha .Or. lRescisao ) .And. !Empty( cPdFolMes ) .And. nVlFolMes > 0
   fGeraVerba(cPdFolMes,nVlFolMes,,,,,,,,,.T.)
EndIf

// Grava o Provento para Pagamento do VT do Mes - Adiantamento
If lAdiant .And. !Empty( cPdAdiMes ) .And. nVlAdiMes > 0
   fGeraVerba(cPdAdiMes,nVlAdiMes,,,,,,,,,.T.)
EndIf

// Grava Desconto do VT
If !Empty( cPdFunc ) .And. nValFunc > 0
   fGeraVerba(cPdFunc,nValFunc,,,,,,,,,.T.)
EndIf

// Grava Parte Empresa do VT
If !Empty( cPdEmpr ) .And. nValEmpr > 0
   fGeraVerba(cPdEmpr,nValEmpr,,,,,,,,,.T.)
EndIf

// Grava o Total do VT
If !Empty( cPdTotal ) .And. (nTotBenef+nValAdic) > 0
   fGeraVerba(cPdTotal,(nTotBenef+nValAdic),nDiasBene,,,,,,,,.T.)
EndIf

// Grava a Devolucao do VT na Rescisao
If !Empty( cPdDevol ) .And. nValDevol > 0
   fGeraVerba(cPdDevol,nValDevol,nDiasExce,,,,,,,,.T.)
EndIf

ZTB->(dbSetOrder( 1 ))

Return( "" )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VTGPEM01  ºAutor  ³Microsiga           º Data ³  06/07/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP10                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */
Static Function fPercVt()

 Local nRet := 6

 SRV->(dbSetOrder( 2 ))
 If SRV->(dbSeek( xFilial("SRV") + "051" ))
    If SRV->RV_PERC > 0 .And. SRV->RV_PERC < 100
       nRet := SRV->RV_PERC
    EndIf
 EndIf
 SRV->(dbSetOrder( 1 ))

Return( nRet )
