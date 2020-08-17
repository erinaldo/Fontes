#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VTGPEM01 บ Autor ณ Adilson Silva      บ Data ณ 04/06/2011  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Calculo do Vale Transporte.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function VTGPEM01()

 Local bProcesso := {|oSelf| fProcessa( oSelf )}

 Private cCadastro  := "Calculo Vale Transporte"
 Private cPerg      := "VTGPEM01"
 Private cStartPath := GetSrvProfString("StartPath","")
 Private cDescricao

 dbSelectArea( "SRA" )
 dbSetOrder(1)

 fAsrPerg()
 Pergunte(cPerg,.F.)

 cDescricao := "Esta rotina irแ calular os valores do Vale Transporte"

 tNewProcess():New( "SRA" , cCadastro , bProcesso , cDescricao , cPerg,,,,,.T.,.t. ) 	

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ RUNCONT  บ Autor ณ AP5 IDE            บ Data ณ  28/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function fProcessa( oSelf )

Local dDtRef   := Ctod( "" )
Local nPos     := 0
Local nPosAcu  := 0
Local nSraRec  := 0
Local nTotVale := 0
Local nQdeVale := 0
Local nDescont := 0
Local nEmpresa := 0
Local aDiasMes := {}
Local aAfast   := {}
Local aCalcVt  := {}
Local nSalario := 0
Local cTipFeri := ""
Local nFaltas  := 0
Local nFerias  := 0
Local nAfasta  := 0
Local c_FilAnt := ""
Local nTemp    := 0
Local nZtaRec  := 0
Local nPercVt  := fPercVt()
Local lCalcGer := .F.
Local lDiferen := .F.
Local lAvisPed := .T.
Local lSkipPed := .T.
Local lDExtras := .F.
Local nTotReg  := 0
Local cTurno   := ""
Local cEscala  := ""
Local lCalcOk  := .F.
Local cTipoPed := ""
Local cProcess := ""
Local aLancto  := {}
Local cDias    := ""
Local cAviso   := ""
Local nX, nY

// Variaveis para Rateio do Vale Transporte
Local nTotalVt := 0
Local nPerFunc := 0
Local nAcuFunc := 0
Local nAcuPerc := 0
Local nAcuEmpr := 0
Local nDiaDif  := 0
Local nValDif  := 0

Private cFilDe, cFilAte
Private cMatDe, cMatAte
Private cCcDe, cCcAte
Private dPerIni, dPerFim
Private nDiasVale, nDiasTmp
Private dDifDe, dDifAte
Private cDatarq, cPeriodo
Private dAdmDe, dAdmAte
Private cMesPagto

Private nSubMeses  := GETMV("GP_VTMFALT",,0)					// Meses a Retroceder para Apuracao das Faltas
Private lFaltas    := GETMV("GP_VTFALTA",,"N") == "S"		// Abater Faltas no Calculo do Vale Transporte
Private lFerias    := GETMV("GP_VTFERIA",,"N") == "S"		// Abater Ferias e Ferias Programadas no Calculo do Vale Transporte
Private lAfastado  := GETMV("GP_VTCALAF",,"N") == "S"		// Calcula Vale Transporte para Funcionarios Afastados
Private cTipAfast  := GETMV("GP_VTAFAST",,"OPQX")			// Tipos de Afastamentos para Abater no Calculo do Vale Transporte
Private cPdFaltas  := GETMV("GP_PDFALTA",,"")				// Verbas Complementares para Desconto das Faltas
Private cPerFalta  := GETMV("GP_VTPFALT",,"123456789")		// Periodos de Calculo na Competencia que Terao Abatimento das Faltas
Private lValZero   := GETMV("GP_TRAZERO",,"N") == "S"		// Grava Calculo com Valores Zerados para o Vale Transporte

Private aCodFol    := {}
Private aEventos   := {}
Private lEscalaSpa := U_fExistSx3( "PA_ESCBNF" )

// Variaveis para Controle dos Logs de Ocorrencia
Private aLogTitle  := {}
Private aLogDetais := {}

Aadd(aLogTitle, "LOG DE OCORRสNCIAS NO CมLCULO DO VALE TRANSPORTE" )
Aadd(aLogDetais,{})

Pergunte(cPerg,.F.)
 dDtRef    := mv_par01
 cFilDe    := mv_par02
 cFilAte   := mv_par03
 cMatDe    := mv_par04
 cMatAte   := mv_par05
 cCcDe     := mv_par06
 cCcAte    := mv_par07
 cPeriodo  := mv_par08
 dAdmDe    := mv_par09
 dAdmAte   := mv_par10
 lCalcGer  := mv_par11 == 2
 lDiferen  := mv_par12 == 2
 dDifDe    := mv_par13
 dDifAte   := mv_par14
 cProcess  := Str(mv_par15,1)		// 1=Compra ; 2=Folha ; 3=Adiantamento ; 4=Gerar CNAB
 cMesPagto := Right(mv_par16,4) + Left(mv_par16,2)

// Periodo de Calculo
cDatarq  := MesAno( dDtRef )
cTipoPed := If(cProcess=="1","Compra",If(cProcess=="2","Folha",If(cProcess=="3","Adiantamento","Gerar CNAB")))

// Verifica o Periodo de Calculo
If cDatarq < GETMV( "MV_FOLMES" )
   Aviso("ATENCAO","Perํodo de Cแlculo Jแ Encerrado, Parโmetro MV_FOLMES = " + GETMV( "MV_FOLMES" ),{"Sair"})
   Return
EndIf

If cDatarq < GETMV( "GP_VTBNMES" )
   If Aviso("ATENCAO","O perํodo selecionado jแ foi calculado! Continua?",{"Nใo","Sim"}) == 1
      Return
   EndIf
EndIf

// Verifica se Calcula Diferenca e os Periodos
If lDiferen
   If Aviso("ATENCAO","Foi selecionada op็ใo para cแlculo da diferen็a do vale transporte! Confirma Processamento?",{"Nใo","Sim"}) == 1
      Return
   EndIf
   If Empty( dDifDe ) .Or. Empty( dDifAte )
      Aviso("ATENCAO","Periodo para cแlculo das diferen็as do vale transporte nใo foi informado!",{"Sair"})
      Return
   EndIf
EndIf

// Valida o Periodo para Pagamento do Beneficio em Folha ou Adiantamento
If cProcess $ "23"	// Folha ou Adiantamento
   If Val(Right(cMesPagto,2)) < 1 .Or. Val(Right(cMesPagto,2)) > 12 .Or. Val(Left(cMesPagto,4)) < 2013
      Aviso("ATENCAO","Periodo para pagamento do benefํcio em folha/adiantamento invalido! Favor verificar as perguntas!",{"Sair"})
      Return
   EndIf

   cAviso := "Confirma cแlculo de "
   cAviso += Right(MesAno( dDtRef ),2) + "/" + Left(MesAno( dDtRef ),4) + " "
   cAviso += "para pagamento " + If(cProcess=="2","na folha","no adiantamento") + " em "
   cAviso += Right(cMesPagto,2) + "/" + Left(cMesPagto,4) + " "
   If Aviso("ATENCAO",cAviso,{"Nใo","Sim"}) == 1
      Return
   EndIf
Else
   cMesPagto := MesAno( dDtRef )
EndIf

// Determina o Periodo de Inicio e Fim
dPerIni := Stod(Left(Dtos( dDtRef ),6) + "01")
dPerFim := Stod(Left(Dtos( dDtRef ),6) + StrZero(f_UltDia(dDtRef),2))

SR6->(dbSetOrder( 1 ))
SRF->(dbSetOrder( 1 ))
SRH->(dbSetOrder( 1 ))
SRD->(dbSetOrder( 1 ))
SRN->(dbSetOrder( 1 ))
RCF->(dbSetOrder( 1 ))
ZTA->(dbSetOrder( 1 ))
ZTB->(dbSetOrder( 2 ))

nSraRec := SRA->(Recno())

// Monta Query Principal
MsAguarde( {|| fMtaQuery( dDtRef, @nTotReg )}, "Processando...", "Selecionado Registros no Banco de Dados..." )

dbSelectArea( "WSRA" )
dbGoTop()
oSelf:SetRegua1( nTotReg )

Do While !Eof()
   SRA->(dbGoTo( WSRA->RA_RECNO ))
   oSelf:IncRegua1( SRA->(RA_FILIAL + " - " + RA_MAT + " - " + RA_NOME) )
   If oSelf:lEnd 
      Break
   EndIf
   
   // Filtra Funcionarios Afastados
   If !lAfastado .And. SRA->RA_SITFOLH == "A"
      dbSkip()
      Loop
   EndIf

   // Carrega os Identificadores de Calculo
   If c_FilAnt <> SRA->RA_FILIAL
      If !FP_CODFOL(@aCodFol,SRA->RA_FILIAL)
         Exit
      EndIf
      If !fCargaId( @aEventos , SRA->RA_FILIAL , .F. )
         Exit
      EndIf
      c_FilAnt := SRA->RA_FILIAL
   EndIf
   aCalcVt := {}

   // Carrega Valores Ja Calculados no Historico
   aLancto := {}
   dbSelectArea( "ZTB" )
   dbSeek( SRA->(RA_FILIAL + RA_MAT) + cDatarq )
   Do While !Eof() .And. ZTB->(ZTB_FILIAL + ZTB_MAT + ZTB_DATARQ) == SRA->(RA_FILIAL + RA_MAT) + cDatarq
      If ZTB->ZTB_PERIODO <> cPeriodo
         dbSkip()
         Loop
      EndIf
      
      Aadd(aLancto,{ZTB->ZTB_FILIAL, 			; // 01 - Filial
                    ZTB->ZTB_MAT, 				; // 02 - Matricula
                    ZTB->ZTB_COD, 				; // 03 - Codigo do Beneficio
                    ZTB->ZTB_DESC, 				; // 04 - Descricao
                    ZTB->ZTB_DATARQ, 			; // 05 - Periodo
                    ZTB->ZTB_DIAINF, 			; // 06 - Dias Informados
                    ZTB->ZTB_QDEDIA, 			; // 07 - Vales por Dia
                    ZTB->ZTB_DIACAL, 			; // 08 - Dias Calculados
                    ZTB->ZTB_QDEVAL, 			; // 09 - Quantidade de Vales
                    ZTB->ZTB_VLVALE, 			; // 10 - Valor Unitario
                    ZTB->ZTB_TTVALE, 			; // 11 - Valor Total Calculado
                    ZTB->ZTB_DIADIF, 			; // 12 - Dias para Diferenca
                    ZTB->ZTB_VLDIFE, 			; // 13 - Valor da Diferenca
                    ZTB->ZTB_VLFUNC, 			; // 14 - Desconto do Funcionario
                    ZTB->ZTB_VLEMPR, 			; // 15 - Valor da Empresa
                    ZTB->ZTB_SALARI, 			; // 16 - Salario Base
                    ZTB->ZTB_CC, 				; // 17 - Centro de Custo
                    ZTB->ZTB_FALTAS, 			; // 18 - Dias de Faltas
                    ZTB->ZTB_FERIAS, 			; // 19 - Dias de Ferias
                    ZTB->ZTB_AFAST, 			; // 20 - Dias de Afastamentos
                    ZTB->ZTB_PEDIDO,			; // 21 - Pedido Efetuado
                    .T.,						; // 22 - Deletar
                    ZTB->ZTB_DIAS,				; // 23 - Dias Calculados
                    ZTB->ZTB_PERIOD,			; // 24 - Periodo do Calculo
                    ZTB->ZTB_DIASOM,			; // 25 - Dias a Somar
                    ZTB->ZTB_DIASUB,			; // 26 - Dias a Subtrair
                    ZTB->ZTB_STATUS,			; // 27 - Status do Pedido
                    ZTB->ZTB_DTDE,				; // 28 - Periodo Calculo De
                    ZTB->ZTB_DTATE}				) // 29 - Periodo Calculo Ate
      dbSkip()
   EndDo

   // Inicia Controle de Transacao
   Begin Sequence
   
   dbSelectArea( "ZTA" )
   dbSeek( SRA->(RA_FILIAL + RA_MAT) )
   Do While !Eof() .And. ZTA->(ZTA_FILIAL + ZTA_MAT) == SRA->(RA_FILIAL + RA_MAT)
      // Filtra Itens Gerados no Pedido de Compra
      If ( nPosAcu := Ascan(aLancto,{|x| x[03]==ZTA->ZTA_COD}) ) > 0
         If !lCalcGer .And. aLancto[nPosAcu,21] $ "56"
            aLancto[nPosAcu,22] := .F.
            dbSkip()
            Loop
         EndIf
         // Filtra Itens com Status de Nao Pagamento
         If aLancto[nPosAcu,27] <> "1"
            aLancto[nPosAcu,22] := .F.
            dbSkip()
            Loop
         EndIf
      EndIf
      
      // Filtra Itens Calculados com Finalidades Diferentes
      If nPosAcu > 0
         If !(aLancto[nPosAcu,21] $ " 56") .And. aLancto[nPosAcu,21] <> cProcess
            If lAvisPed
               If Aviso("ATENCAO","Existem itens com finalidade diferente da solicitada (" + cTipoPed + ")! Recalcula?",{"Nใo","Sim"}) == 2
                  lSkipPed := .F.
               EndIf
               lAvisPed := .F.
            EndIf
            If lSkipPed
               dbSkip()
               Loop
            EndIf
         EndIf
      EndIf
      
      nDiasTmp := 0
      U_fDias( @nDiasTmp, dDtRef, @aDiasMes, "VT", cPeriodo, @dPerIni, @dPerFim, Nil, Nil, @cTurno, @cEscala, @aLogDetais )
      If Len( aDiasMes ) == 0
         dbSkip()
         Loop
      EndIf
      
      If SRN->(dbSeek( xFilial("SRN") + ZTA->ZTA_COD ))
         // Filtra os Periodos Conforme Definicao no Cadastro dos Beneficios
         If !Empty( SRN->RN_PERCAL ) .And. !( cPeriodo $ SRN->RN_PERCAL )
            Aadd( aLogDetais[1], "O benefํcio " + SRN->RN_COD + " nใo estแ liberado para cแlculo neste perํodo (" + cPeriodo + ")!" )
            dbSkip()
            Loop
         EndIf

         // Abate os Afastamentos
         aAfast  := {}
         If !Empty( cTipAfast )
            fRetAfas( dPerIni, dPerFim, cTipAfast , , , @aAfast, .F., .F., .T. )
            Aeval(aAfast,{|x| If(Empty(x[4]),x[4]:=dDataBase+120,x[4]:=x[4])})
            For nX := 1 To Len( aAfast )
                For nY := aAfast[nX,3] To aAfast[nX,4]
                    If ( nPos := Ascan(aDiasMes,{|x| x[1]==nY}) ) > 0
                       If !aDiasMes[nPos,4]
                          aDiasMes[nPos,4] := .T.
                          aDiasMes[nPos,5] := "AFA"
                       EndIf
                    EndIf
                Next nY
            Next nX
         EndIf

         // Abate as Ferias Calculadas e Ferias Programadas
         aAfast  := {}
         If lFerias
            cTipFeri := U_fFerProg( dPerIni, dPerFim, @aAfast )
            For nX := 1 To Len( aAfast )
                For nY := aAfast[nX,3] To aAfast[nX,4]
                    If ( nPos := Ascan(aDiasMes,{|x| x[1]==nY}) ) > 0
                       If !aDiasMes[nPos,4]
                          aDiasMes[nPos,4] := .T.
                          aDiasMes[nPos,5] := "FER"
                       EndIf
                    EndIf
                Next nY
            Next nX
         EndIf

         // Abate as Faltas
         nFaltas := 0
         If lFaltas      
            If cPeriodo $ cPerFalta
               U_fRetFaltas( @nFaltas, nSubMeses, dDtRef )
            EndIf
         EndIf

         nDiasVale := 0
         nAfasta   := 0
         nFerias   := 0
         Aeval(aDiasMes,{|x| nDiasVale += If(!x[4],1,0)})
         Aeval(aDiasMes,{|x| nAfasta   += If(x[4] .And. x[5]=="AFA",1,0)})
         Aeval(aDiasMes,{|x| nFerias   += If(x[4] .And. x[5]=="FER",1,0)})
      
         // Determina os Dias Utilizados no Calculo
         cDias := ""
         For nX := 1 To Len( aDiasMes )
             If aDiasMes[nX,4]		// Nao Calculado
                cDias += "**"
             Else
                cDias += StrZero(Day(aDiasMes[nX,1]),2)
             EndIf
         Next nX
      
         nFaltas := If(nFaltas > nDiasVale, nDiasVale, nFaltas)
         nDiasVale -= nFaltas		// Abate as Faltas

         If nPosAcu > 0
            nDiasVale += aLancto[nPosAcu,25]				// Somar Dias Extras
            nDiasVale -= aLancto[nPosAcu,26]				// Subtrair Dias Extras
         Else
            nDiasVale += ZTA->ZTA_DIASOM					// Somar Dias Extras
            nDiasVale -= ZTA->ZTA_DIASUB					// Subtrair Dias Extras
         EndIf
            
         // Verifica se Deve Calcular com Quantidade Fixa de Dias
         If nDiasTmp > 0
            nDiasVale := nDiasTmp
         EndIf

         // Verifica se Deve Calcular com Quantidade Fixa de Dias da Tabela do VT
         If ZTA->ZTA_DIAINF > 0
            nDiasVale := ZTA->ZTA_DIAINF
         EndIf
         nDiasVale := If(nDiasVale > 0, nDiasVale, 0)	// Verifica Quantidade Negativa
      
         // Ponto de Entrada para Calculo dos Dias do Vale Transporte
         If ExistBlock( "VTGPM_01" )
            ExecBlock("VTGPM_01",.F.,.F.)
         EndIf

         // Processa os Dias Informados no Lancamento
         If nPosAcu > 0
            If aLancto[nPosAcu,06] > 0
               nDiasVale := aLancto[nPosAcu,06]
            EndIf
         Else
            If ZTA->ZTA_DIAINF > 0
               nDiasVale := ZTB->ZTB_DIAINF
            EndIf
         EndIf

         // Verifica se Deve Calcular
         If ( !lValZero .And. nDiasVale == 0 ) .Or. ( SRA->RA_ADMISSA > dPerFim )
            dbSkip()
            Loop
         EndIf
      
         nQdeVale := ZTA->ZTA_QDEDIA * nDiasVale
         nTotVale := Round( nQdeVale * SRN->RN_VUNIATU,2 )
         // Apura Proporcionalidades
         If nDiasTmp > 0
            nTemp := nAfasta + nFerias + nFaltas
            nTotVale := Round( (nTotVale / 30) * (30-nTemp),2 )
         EndIf
         
         // Calcula a Diferenca do Vale Transporte
         nDiaDif := 0 ; nValDif := 0
         If lDiferen
            fDiferVt( @nDiaDif, @nValDif )
         EndIf
         
         // Acumula Itens para Calculo dos Descontos
         Aadd(aCalcVt,{ZTA->ZTA_COD, ZTA->(Recno()), nTotVale, 0, 0})

         // Grava os Valores Calculados
         If Len(Alltrim( ZTA->ZTA_CC )) == 0
            RecLock("ZTA",.F.)
             ZTA->ZTA_CC  := SRA->RA_CC
            MsUnlock()
         EndIf
         
         // Variavel para Gravar o Periodo de Calculo
         lCalcOk := .T.

         // Acumula Array do Historico
         lDExtras := nPosAcu == 0
         If nPosAcu == 0
            Aadd(aLancto,Array(29))
            nPosAcu := Len( aLancto )
         EndIf
         aLancto[nPosAcu,01] := ZTA->ZTA_FILIAL 			// 01 - Filial
         aLancto[nPosAcu,02] := ZTA->ZTA_MAT 				// 02 - Matricula
         aLancto[nPosAcu,03] := ZTA->ZTA_COD 				// 03 - Codigo do Beneficio
         aLancto[nPosAcu,04] := ZTA->ZTA_DESC 				// 04 - Descricao
         aLancto[nPosAcu,05] := cDatarq 					// 05 - Periodo
         If lDExtras
            aLancto[nPosAcu,06] := ZTA->ZTA_DIAINF 			// 06 - Dias Informados
         EndIf
         aLancto[nPosAcu,07] := ZTA->ZTA_QDEDIA 			// 07 - Vales por Dia
         aLancto[nPosAcu,08] := nDiasVale 					// 08 - Dias Calculados
         aLancto[nPosAcu,09] := nQdeVale					// 09 - Quantidade de Vales
         aLancto[nPosAcu,10] := SRN->RN_VUNIATU 			// 10 - Valor Unitario
         aLancto[nPosAcu,11] := nTotVale 					// 11 - Valor Total Calculado
         aLancto[nPosAcu,12] := nDiaDif 					// 12 - Dias para Diferenca
         aLancto[nPosAcu,13] := nValDif 					// 13 - Valor da Diferenca
         aLancto[nPosAcu,14] := nDescont 					// 14 - Desconto do Funcionario
         aLancto[nPosAcu,15] := nEmpresa 					// 15 - Valor da Empresa
         aLancto[nPosAcu,16] := 0							// 16 - Salario Base
         aLancto[nPosAcu,17] := ZTA->ZTA_CC 				// 17 - Centro de Custo
         aLancto[nPosAcu,18] := nFaltas			 			// 18 - Dias de Faltas
         aLancto[nPosAcu,19] := nFerias 					// 19 - Dias de Ferias
         aLancto[nPosAcu,20] := nAfasta 					// 20 - Dias de Afastamentos
         aLancto[nPosAcu,21] := cProcess      				// 21 - Pedido Efetuado
         aLancto[nPosAcu,22] := .F.							// 22 - Deletar
         aLancto[nPosAcu,23] := cDias						// 23 - Dias Calculados
         aLancto[nPosAcu,24] := cPeriodo					// 24 - Periodo
         If lDExtras
            aLancto[nPosAcu,25] := ZTA->ZTA_DIASOM			// 25 - Dias a Somar
            aLancto[nPosAcu,26] := ZTA->ZTA_DIASUB			// 26 - Dias a Subtrair
         EndIf
         aLancto[nPosAcu,27] := "1"							// 27 - Status do Pedido - 1=Pagto Autorizado;2=Abandono;3=Aviso Previo
         aLancto[nPosAcu,28] := dPerIni						// 28 - Periodo de Apuracao De
         aLancto[nPosAcu,29] := dPerFim						// 29 - Periodo de Apuracao Ate
      Else
         Aadd( aLogDetais[1], "Meio de transporte " + ZTA->ZTA_COD + " nใo cadastrado!" )
      EndIf

      RecLock("ZTA",.F.)
       ZTA->ZTA_DIAINF := 0 		// Dias Informados
       ZTA->ZTA_DIASOM := 0			// Dias para Somar
       ZTA->ZTA_DIASUB := 0			// Dias para Subtrair
      MsUnlock()
      
      dbSkip()
   EndDo
   
   // Atualiza o Calculo na Tabela de Fechamento
   dbSelectArea( "ZTB" )
   For nX := 1 To Len( aLancto )
       If dbSeek( aLancto[nX,01] + aLancto[nX,02] + aLancto[nX,05] + aLancto[nX,03] + aLancto[nX,24] )
          If aLancto[nX,22]
             RecLock("ZTB",.F.)
              dbDelete()
             MsUnlock()
             Loop
          EndIf
          RecLock("ZTB",.F.)
       Else
          RecLock("ZTB",.T.)
       EndIf
        ZTB->ZTB_FILIAL := aLancto[nX,01]		// 01 - Filial
        ZTB->ZTB_MAT    := aLancto[nX,02]		// 02 - Matricula
        ZTB->ZTB_COD    := aLancto[nX,03]		// 03 - Codigo Beneficio
        ZTB->ZTB_DESC   := aLancto[nX,04] 		// 04 - Descricao
        ZTB->ZTB_DATARQ := aLancto[nX,05]		// 05 - Periodo
        ZTB->ZTB_DIAINF := aLancto[nX,06] 		// 06 - Dias Informados
        ZTB->ZTB_QDEDIA := aLancto[nX,07] 		// 07 - Vales por Dia
        ZTB->ZTB_DIACAL := aLancto[nX,08] 		// 08 - Dias Calculados
        ZTB->ZTB_QDEVAL := aLancto[nX,09] 		// 09 - Quantidade de Vales
        ZTB->ZTB_VLVALE := aLancto[nX,10] 		// 10 - Valor Unitario
        ZTB->ZTB_TTVALE := aLancto[nX,11] 		// 11 - Valor Total Calculado
        ZTB->ZTB_DIADIF := aLancto[nX,12] 		// 12 - Dias para Diferenca
        ZTB->ZTB_VLDIFE := aLancto[nX,13] 		// 13 - Valor da Diferenca
        ZTB->ZTB_VLFUNC := aLancto[nX,14] 		// 14 - Desconto do Funcionario
        ZTB->ZTB_VLEMPR := aLancto[nX,15] 		// 15 - Valor da Empresa
        ZTB->ZTB_SALARI := aLancto[nX,16] 		// 16 - Salario Base
        ZTB->ZTB_CC     := aLancto[nX,17] 		// 17 - Centro de Custo
        ZTB->ZTB_FALTAS := aLancto[nX,18] 		// 18 - Dias de Faltas
        ZTB->ZTB_FERIAS := aLancto[nX,19] 		// 19 - Dias de Ferias
        ZTB->ZTB_AFAST  := aLancto[nX,20] 		// 20 - Dias de Afastamentos
        ZTB->ZTB_PEDIDO := aLancto[nX,21]		// 21 - Pedido Efetuado
        ZTB->ZTB_DIAS   := aLancto[nX,23]		// 23 - Dias Calculados
        ZTB->ZTB_PERIOD := aLancto[nX,24]		// 24 - Periodo
        ZTB->ZTB_DIASOM := aLancto[nX,25]		// 25 - Dias a Somar
        ZTB->ZTB_DIASUB := aLancto[nX,26]		// 26 - Dias a Subtrair
        ZTB->ZTB_STATUS := aLancto[nX,27]		// 27 - Status do Pedido
        ZTB->ZTB_DTDE   := aLancto[nX,28]		// 28 - Periodo de Apuracao De
        ZTB->ZTB_DTATE  := aLancto[nX,29]		// 29 - Periodo de Apuracao Ate
        If aLancto[nX,27] == "1"
           ZTB->ZTB_TURNO  := cTurno			//    - Turno de Trabalho
           ZTB->ZTB_ESCALA := cEscala			//    - Escala
           ZTB->ZTB_PERCAL := cMesPagto			//    - Periodo para Pagamento em Folha/Adiantamento
        EndIf
       MsUnlock()
   Next nX

   // Finaliza Controle de Transacao
   End Sequence
   
   dbSelectArea( "WSRA" )
   dbSkip()
EndDo
WSRA->(dbCloseArea())

If lCalcOk .And. GETMV( "GP_VTBNMES" ) < cDatarq
   PUTMV( "GP_VTBNMES", cDatarq )
EndIf

dbSelectArea( "SRA" )
SRA->(dbGoTo( nSraRec ))

If Len(aLogDetais[1]) > 0
   If Aviso("LOG Ocorr๊ncias","Visualizar Log de Ocorr๊ncias? ",{"Sim","Nใo"}) == 1
      fMakeLog( aLogDetais, aLogTitle, "AMGPEM80", .T., Nil, Nil, Nil, Nil, Nil, .F. )
   EndIf
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVTGPEM01  บAutor  ณMicrosiga           บ Data ณ  10/03/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fDiferVt( nDiaDif, nValDif )

 Local aOldAtu  := GETAREA()
 Local aDiasDif := {}
 Local cCusDif  := 0
 Local cDifDe, cDifAte

 cDifDe  := MesAno( dDifDe )
 cDifAte := MesAno( dDifAte )
 
 Do While cDifDe <= cDifAte
    aDiasDif := {}
    U_fDias( @nDiaDif, Stod(cDifDe+"01"), @aDiasDif, "DVT", cPeriodo, @dPerIni, @dPerFim )
 
    Aeval(aDiasDif,{|x| nDiaDif += If(!x[4],1,0)})
 
    U_fSmaMesAno( @cDifDe )
 EndDo
 // Calcula a Diferencao do Vale Transporte
 If nDiaDif > 0 .And. SRN->RN_VUNIANT > 0 .And. SRN->RN_VUNIATU > SRN->RN_VUNIANT
    cCusDif := SRN->RN_VUNIATU - SRN->RN_VUNIANT
    nValDif := Round( nDiaDif * cCusDif,2 )
 Else
    nDiaDif := 0
    nValDif := 0
 EndIf
 
 RESTAREA( aOldAtu )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVTGPEM01  บAutor  ณMicrosiga           บ Data ณ  06/07/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVAGPER01  บAutor  ณMicrosiga           บ Data ณ  04/26/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fMtaQuery( dDtRef, nTotReg )

 Local cQuery
 
 cQuery := "SELECT SRA.R_E_C_N_O_ AS RA_RECNO"
 cQuery += "       FROM " + RetSqlName( "SRA" ) + " SRA"
 cQuery += " WHERE SRA.D_E_L_E_T_ <> '*'"
 cQuery += "   AND SRA.RA_FILIAL BETWEEN '" + cFilDe  + "' AND '" + cFilAte  + "'"
 cQuery += "   AND SRA.RA_MAT    BETWEEN '" + cMatDe  + "' AND '" + cMatAte  + "'"
 cQuery += "   AND SRA.RA_CC     BETWEEN '" + cCcDe   + "' AND '" + cCcAte   + "'"
 cQuery += "   AND SRA.RA_SITFOLH <> 'D'"
 If !Empty( dAdmDe ) .And. !Empty( dAdmAte )
    cQuery += " AND SRA.RA_ADMISSA BETWEEN '" + Dtos( dAdmDe ) + "' AND '" + Dtos( dAdmAte ) + "'"
 EndIf
 
 cQuery := ChangeQuery( cQuery )
 TCQuery cQuery New Alias "WSRA"
 TcSetField( "WSRA" , "RA_RECNO" , "N" , 10 , 0 )
 
 Count To nTotReg
 
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณVALIDPERG บ Autor ณ AP5 IDE            บ Data ณ  27/10/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Verifica a existencia das perguntas criando-as caso seja   บฑฑ
ฑฑบ          ณ necessario (caso nao existam).                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fAsrPerg()

Local aRegs := {}
Local Fi    := FWSizeFilial()

 // Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
 aAdd(aRegs,{ cPerg,'01','Data Referencia ?             ','','','mv_ch1','D',08,0,0,'G','NaoVazio    ','mv_par01',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
 aAdd(aRegs,{ cPerg,'02','Filial De ?                   ','','','mv_ch2','C',Fi,0,0,'G','            ','mv_par02',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SM0   ','' })
 aAdd(aRegs,{ cPerg,'03','Filial Ate ?                  ','','','mv_ch3','C',Fi,0,0,'G','NaoVazio    ','mv_par03',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SM0   ','' })
 aAdd(aRegs,{ cPerg,'04','Matricula De ?                ','','','mv_ch4','C',06,0,0,'G','            ','mv_par04',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SRA   ','' })
 aAdd(aRegs,{ cPerg,'05','Matricula Ate ?               ','','','mv_ch5','C',06,0,0,'G','NaoVazio    ','mv_par05',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SRA   ','' })
 aAdd(aRegs,{ cPerg,'06','Centro Custo De ?             ','','','mv_ch6','C',20,0,0,'G','            ','mv_par06',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'CTT   ','' })
 aAdd(aRegs,{ cPerg,'07','Centro Custo Ate ?            ','','','mv_ch7','C',20,0,0,'G','NaoVazio    ','mv_par07',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'CTT   ','' })
 aAdd(aRegs,{ cPerg,'08','Periodo a Calcular ?          ','','','mv_ch8','C',01,0,0,'G','U_fBnfPer(1)','mv_par08',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
 aAdd(aRegs,{ cPerg,'09','Admissao De ?                 ','','','mv_ch9','D',08,0,0,'G','            ','mv_par09',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
 aAdd(aRegs,{ cPerg,'10','Admissao Ate ?                ','','','mv_cha','D',08,0,0,'G','            ','mv_par10',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
 aAdd(aRegs,{ cPerg,'11','Recalcula Itens Gerados ?     ','','','mv_chb','N',01,0,0,'C','            ','mv_par11','Nao'              ,'','','','','Sim'              ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
 aAdd(aRegs,{ cPerg,'12','Calcula Diferenca do VT ?     ','','','mv_chc','N',01,0,0,'C','            ','mv_par12','Nao'              ,'','','','','Sim'              ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
 aAdd(aRegs,{ cPerg,'13','Data p/ Diferenca De ?        ','','','mv_chd','D',08,0,0,'G','            ','mv_par13',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
 aAdd(aRegs,{ cPerg,'14','Data p/ Diferenca Ate ?       ','','','mv_che','D',08,0,0,'G','            ','mv_par14',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
 aAdd(aRegs,{ cPerg,'15','Processamento Para  ?         ','','','mv_chf','N',01,0,0,'C','            ','mv_par15','Compra'           ,'','','','','Pagto Folha'      ,'','','','','Pagto Adto'          ,'','','','','Gerar CNAB'       ,'','','','',''      ,'','','' ,'      ','' })
 aAdd(aRegs,{ cPerg,'16','Pagto Folha/Adiant (MMAAAA)?  ','','','mv_chg','C',06,0,0,'G','            ','mv_par16',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
 U_fDelSx1( cPerg, "17" )

ValidPerg(aRegs,cPerg)

Return 
