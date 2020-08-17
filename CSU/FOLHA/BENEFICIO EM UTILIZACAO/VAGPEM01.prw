#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VAGPEM01 บ Autor ณ Adilson Silva      บ Data ณ 04/06/2011  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Calculo do Vale Alimentacao.                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function VAGPEM01()

 Local bProcesso := {|oSelf| fProcessa( oSelf )}

 Private cCadastro  := "Calculo do Vale Alimenta็ใo"
 Private cPerg      := "VAGPEM01"
 Private cStartPath := GetSrvProfString("StartPath","")
 Private cDescricao

 dbSelectArea( "SRA" )
 dbSetOrder(1)

 fAsrPerg()
 Pergunte(cPerg,.F.)

 cDescricao := "Esta rotina irแ calular os valores do Vale Alimenta็ใo"

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
Local aSvTabVa := {}
Local aSvTabVr := {}
Local aTabVale := {}
Local nPos     := 0
Local nPosAcu  := 0
Local nPosTab  := 0
Local nSraRec  := 0
Local nTotVale := 0
Local nDescont := 0
Local nEmpresa := 0
Local aDiasMes := {}
Local aAfast   := {}
Local cTipFeri := ""
Local nFaltas  := 0
Local nFerias  := 0
Local nAfasta  := 0
Local c_FilAnt := ""
Local nTemp    := 0
Local lCalcGer := .F.
Local lCalcOk  := .F.
Local aLancto  := {}
Local cDias    := ""
Local nCalcBnf := 0
Local cTipoPed := ""
Local cProcess := ""
Local lAvisPed := .T.
Local lSkipPed := .T.
Local lDExtras := .F.
Local nTotReg  := 0
Local cTurno   := ""
Local cEscala  := ""
Local nX, nY

Private cFilDe, cFilAte
Private cMatDe, cMatAte
Private cCcDe, cCcAte
Private dPerIni, dPerFim
Private nDiasVale, nDiasTmp
Private cDatarq, cPeriodo
Private dAdmDe, dAdmAte
Private cMesPagto

Private nSubMeses  := GETMV("GP_VAMFALT",,0)					// Meses a Retroceder para Apuracao das Faltas
Private lFaltas    := GETMV("GP_VAFALTA",,"N") == "S"		// Abater Faltas no Calculo do Vale Alimentacao
Private lFerias    := GETMV("GP_VAFERIA",,"N") == "S"		// Abater Ferias e Ferias Programadas no Calculo do Vale Alimentacao
Private lAfastado  := GETMV("GP_VACALAF",,"N") == "S"		// Calcula Vale Alimentacao para Funcionarios Afastados
Private cTipAfast  := GETMV("GP_VAAFAST",,"OPQX")			// Tipos de Afastamentos para Abater no Calculo do Vale Alimentacao
Private cPdFaltas  := GETMV("GP_PDFALTA",,"")				// Verbas Complementares para Desconto das Faltas 
Private cPerFalta  := GETMV("GP_VAPFALT",,"123456789")		// Periodos de Calculo na Competencia que Terao Abatimento das Faltas
Private lValZero   := GETMV("GP_ALIZERO",,"N") == "S"		// Grava Calculo com Valores Zerados para Refeicao/Alimentacao

Private aCodFol    := {}
Private aEventos   := {}
Private lEscalaSpa := U_fExistSx3( "PA_ESCBNF" )

// Variaveis para Controle dos Logs de Ocorrencia
Private aLogTitle  := {}
Private aLogDetais := {}

Aadd(aLogTitle, "LOG DE OCORRสNCIAS NO CมLCULO DO VALE REFEIวรO/ALIMENTAวรO" )
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
 nCalcBnf  := mv_par12
 cProcess  := Str(mv_par13,1)		// 1=Compra ; 2=Folha ; 3=Adiantamento ; 4=Gerar CNAB
 cMesPagto := Right(mv_par14,4) + Left(mv_par14,2)
 
// Periodo de Calculo
cDatarq  := MesAno( dDtRef )
cTipoPed := If(cProcess=="1","Compra",If(cProcess=="2","Folha",If(cProcess=="3","Adiantamento","Gerar CNAB")))
 
// Verifica o Periodo de Calculo
If cDatarq < GETMV( "MV_FOLMES" )
   Aviso("ATENCAO","Perํodo de Cแlculo Jแ Encerrado, Parโmetro MV_FOLMES = " + GETMV( "MV_FOLMES" ),{"Sair"})
   Return
EndIf

If cDatarq < GETMV( "GP_VABNMES" )
   If Aviso("ATENCAO","O perํodo de cแlculo do Vale Alimenta็ใo selecionado jแ foi calculado! Continua?",{"Nใo","Sim"}) == 1
      Return
   EndIf
EndIf

If cDatarq < GETMV( "GP_VRBNMES" )
   If Aviso("ATENCAO","O perํodo de cแlculo do Vale Refei็ใo selecionado jแ foi calculado! Continua?",{"Nใo","Sim"}) == 1
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
ZT6->(dbSetOrder( 1 ))
ZT7->(dbSetOrder( 2 ))
ZT8->(dbSetOrder( 1 ))

If ( nCalcBnf == 1 .Or. nCalcBnf == 3 ) .And. !fCargaTab( @aSvTabVr, "VR" )
   Aviso("ATENCAO","Tabela do Vale Refei็ใo Nao Cadastrada",{"Sair"})
   Return
EndIf
If ( nCalcBnf == 2 .Or. nCalcBnf == 3 ) .And. !fCargaTab( @aSvTabVa, "VA" )
   Aviso("ATENCAO","Tabela do Vale Alimenta็ใo Nao Cadastrada",{"Sair"})
   Return
EndIf

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

   // Carrega Valores Ja Calculados no Historico
   aLancto := {}
   dbSelectArea( "ZT7" )
   dbSeek( SRA->(RA_FILIAL + RA_MAT) + cDatarq )
   Do While !Eof() .And. ZT7->(ZT7_FILIAL + ZT7_MAT + ZT7_DATARQ) == SRA->(RA_FILIAL + RA_MAT) + cDatarq
      If ZT7->ZT7_PERIODO <> cPeriodo
         dbSkip()
         Loop
      EndIf
      
      // Filtra o Tipo do Beneficio Selecionado
      If ( nCalcBnf == 1 .And. ZT7->ZT7_TIPO == "2" ) .Or. ;
         ( nCalcBnf == 2 .And. ZT7->ZT7_TIPO == "1" )
         dbSkip()
         Loop
      EndIf
      
      Aadd(aLancto,{ZT7->ZT7_FILIAL, 			; // 01 - Filial
                    ZT7->ZT7_MAT, 				; // 02 - Matricula
                    ZT7->ZT7_COD, 				; // 03 - Codigo do Beneficio
                    ZT7->ZT7_DESC, 				; // 04 - Descricao
                    ZT7->ZT7_DATARQ, 			; // 05 - Periodo
                    ZT7->ZT7_DIAINF, 			; // 06 - Dias Informados
                    ZT7->ZT7_DIASOM, 			; // 07 - Dias para Somar
                    ZT7->ZT7_DIASUB, 			; // 08 - Dias para Subtrair
                    ZT7->ZT7_DIACAL, 			; // 09 - Dias Calculados
                    ZT7->ZT7_VLVALE, 			; // 10 - Valor Unitario
                    ZT7->ZT7_TTVALE, 			; // 11 - Valor Total Calculado
                    ZT7->ZT7_VLFUNC, 			; // 12 - Desconto do Funcionario
                    ZT7->ZT7_VLEMPR, 			; // 13 - Valor da Empresa
                    ZT7->ZT7_CC, 				; // 14 - Centro de Custo
                    ZT7->ZT7_FALTAS, 			; // 15 - Dias de Faltas
                    ZT7->ZT7_FERIAS, 			; // 16 - Dias de Ferias
                    ZT7->ZT7_AFAST, 			; // 17 - Dias de Afastamentos
                    ZT7->ZT7_PEDIDO,			; // 18 - Pedido Efetuado
                    .T.,						; // 19 - Deletar
                    ZT7->ZT7_DIAS,				; // 20 - Dias Calculados
                    ZT7->ZT7_PERIOD,			; // 21 - Periodo do Calculo
                    ZT7->ZT7_TIPO,				; // 22 - Tipo do Beneficio
                    ZT7->ZT7_DTDE,				; // 23 - Periodo Calculo De
                    ZT7->ZT7_DTATE,				; // 24 - Periodo Calculo Ate
                    ZT7->ZT7_STATUS}			) // 25 - Status do Pedido
      dbSkip()
   EndDo

   // Inicia Controle de Transacao
   Begin Sequence
   
   dbSelectArea( "ZT6" )
   dbSeek( SRA->(RA_FILIAL + RA_MAT) )
   Do While !Eof() .And. ZT6->(ZT6_FILIAL + ZT6_MAT) == SRA->(RA_FILIAL + RA_MAT)
      // Filtra o Tipo do Beneficio Selecionado
      If ( nCalcBnf == 1 .And. ZT6->ZT6_TIPO == "2" ) .Or. ;
         ( nCalcBnf == 2 .And. ZT6->ZT6_TIPO == "1" )
         dbSkip()
         Loop
      EndIf

      // Filtra a Data de Validade do Beneficio
      If !Empty( ZT6->ZT6_DTFIM ) .And. dPerIni > ZT6->ZT6_DTFIM
         dbSkip()
         Loop
      EndIf

      // Filtra Itens Gerados no Pedido de Compra
      If ( nPosAcu := Ascan(aLancto,{|x| x[03]==ZT6->ZT6_COD}) ) > 0
         If !lCalcGer .And. aLancto[nPosAcu,18] $ "56"
            aLancto[nPosAcu,19] := .F.
            dbSkip()
            Loop
         EndIf
         // Filtra Itens com Status de Nao Pagamento
         If aLancto[nPosAcu,25] <> "1"
            aLancto[nPosAcu,19] := .F.
            dbSkip()
            Loop
         EndIf
      EndIf
      
      // Filtra Itens Calculados com Finalidades Diferentes
      If nPosAcu > 0
         If !(aLancto[nPosAcu,18] $ " 56") .And. aLancto[nPosAcu,18] <> cProcess
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
      
      // Redefine os Parametros da Rotina Conforme o Tipo do Beneficio
      If ZT6->ZT6_TIPO == "1"	// Refeicao
         nSubMeses := GETMV("GP_VRMFALT",,0)				// Meses a Retroceder para Apuracao das Faltas
         lFaltas   := GETMV("GP_VRFALTA",,"N") == "S"		// Abater Faltas no Calculo do Vale Alimentacao
         lFerias   := GETMV("GP_VRFERIA",,"N") == "S"		// Abater Ferias e Ferias Programadas no Calculo do Vale Alimentacao
         lAfastado := GETMV("GP_VRCALAF",,"N") == "S"		// Calcula Vale Alimentacao para Funcionarios Afastados
         cTipAfast := GETMV("GP_VRAFAST",,"OPQX")			// Tipos de Afastamentos para Abater no Calculo do Vale Alimentacao
         cPerFalta := GETMV("GP_VRPFALT",,"123456789")		// Periodos de Calculo na Competencia que Terao Abatimento das Faltas
      ElseIf ZT6->ZT6_TIPO == "2"	// Alimentacao
         nSubMeses := GETMV("GP_VAMFALT",,0)				// Meses a Retroceder para Apuracao das Faltas
         lFaltas   := GETMV("GP_VAFALTA",,"N") == "S"		// Abater Faltas no Calculo do Vale Alimentacao
         lFerias   := GETMV("GP_VAFERIA",,"N") == "S"		// Abater Ferias e Ferias Programadas no Calculo do Vale Alimentacao
         lAfastado := GETMV("GP_VACALAF",,"N") == "S"		// Calcula Vale Alimentacao para Funcionarios Afastados
         cTipAfast := GETMV("GP_VAAFAST",,"OPQX")			// Tipos de Afastamentos para Abater no Calculo do Vale Alimentacao
         cPerFalta := GETMV("GP_VAPFALT",,"123456789")		// Periodos de Calculo na Competencia que Terao Abatimento das Faltas
      EndIf
      
      nDiasTmp := 0
      aTabVale := {}
      If ZT6->ZT6_TIPO == "1"
         U_fDias( @nDiasTmp, dDtRef, @aDiasMes, "VR", cPeriodo, @dPerIni, @dPerFim, ZT6->ZT6_DTINI, ZT6->ZT6_DTFIM, @cTurno, @cEscala, @aLogDetais )
         aTabVale := Aclone( aSvTabVr )
      ElseIf ZT6->ZT6_TIPO == "2"
         U_fDias( @nDiasTmp, dDtRef, @aDiasMes, "VA", cPeriodo, @dPerIni, @dPerFim, ZT6->ZT6_DTINI, ZT6->ZT6_DTFIM, @cTurno, @cEscala, @aLogDetais )
         aTabVale := Aclone( aSvTabVa )
      EndIf
      If Len( aDiasMes ) == 0
         dbSkip()
         Loop
      EndIf

      If ( nPosTab := Ascan(aTabVale,{|x| x[1]==ZT6->ZT6_COD}) ) > 0
         // Filtra os Periodos Conforme Definicao no Cadastro dos Beneficios
         If !Empty( aTabVale[nPosTab,7] ) .And. !( cPeriodo $ aTabVale[nPosTab,7] )
            Aadd( aLogDetais[1], "O benefํcio " + aTabVale[nPosTab,1] + " nใo estแ liberado para cแlculo neste perํodo (" + cPeriodo + ")!" )
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
               U_fRetFaltas( @nFaltas, nSubMeses, dDtRef, ZT6->ZT6_TIPO )
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
            nDiasVale += aLancto[nPosAcu,07]				// Somar Dias Extras
            nDiasVale -= aLancto[nPosAcu,08]				// Subtrair Dias Extras
         Else
            nDiasVale += ZT6->ZT6_DIASOM					// Somar Dias Extras
            nDiasVale -= ZT6->ZT6_DIASUB					// Subtrair Dias Extras
         EndIf
      
         // Verifica se Deve Calcular com Quantidade Fixa de Dias
         If nDiasTmp > 0
            nDiasVale := nDiasTmp
         EndIf

         // Verifica se Deve Calcular com Quantidade Fixa de Dias da Tabela do VR
         If aTabVale[nPosTab,6] > 0
            nDiasVale := aTabVale[nPosTab,6]
         EndIf
         nDiasVale := If(nDiasVale > 0, nDiasVale, 0)	// Verifica Quantidade Negativa

         // Ponto de Entrada para Calculo dos Dias do Vale Alimentacao
         If ExistBlock( "VAGPM_01" )
            ExecBlock("VAGPM_01",.F.,.F.)
         EndIf

         // Processa os Dias Informados no Lancamento
         If nPosAcu > 0
            If aLancto[nPosAcu,06] > 0
               nDiasVale := aLancto[nPosAcu,06]
            EndIf
         Else
            If ZT6->ZT6_DIAINF > 0
               nDiasVale := ZT6->ZT6_DIAINF
            EndIf
         EndIf
         
         // Verifica se Deve Calcular
         If ( !lValZero .And. nDiasVale == 0 ) .Or. ( SRA->RA_ADMISSA > dPerFim )
            dbSkip()
            Loop
         EndIf
      
         nTotVale := Round( nDiasVale * aTabVale[nPosTab,3],2 )
         // Apura Proporcionalidades
         If nDiasTmp > 0
            nTemp := nAfasta + nFerias + nFaltas
            nTotVale := Round( (nTotVale / 30) * (30-nTemp),2 )
         EndIf

         nDescont := 0
         nEmpresa := nTotVale
         If aTabVale[nPosTab,4] > 0
            nDescont := NoRound( nTotVale * (aTabVale[nPosTab,4]/100),2 )
            nDescont := Min( nDescont,aTabVale[nPosTab,5] )
            nEmpresa  := nTotVale - nDescont
         EndIf
         
         // Grava os Valores Calculados
         If Len(Alltrim( ZT6->ZT6_CC )) == 0
            RecLock("ZT6",.F.)
             ZT6->ZT6_CC  := SRA->RA_CC
            MsUnlock()
         EndIf

         // Variavel para Gravar o Periodo de Calculo
         lCalcOk := .T.

         // Acumula Array do Historico
         lDExtras := nPosAcu == 0
         If nPosAcu == 0
            Aadd(aLancto,Array(25))
            nPosAcu := Len( aLancto )
         EndIf
         aLancto[nPosAcu,01] := ZT6->ZT6_FILIAL 			// 01 - Filial
         aLancto[nPosAcu,02] := ZT6->ZT6_MAT 				// 02 - Matricula
         aLancto[nPosAcu,03] := ZT6->ZT6_COD 				// 03 - Codigo do Beneficio
         aLancto[nPosAcu,04] := ZT6->ZT6_DESC 				// 04 - Descricao
         aLancto[nPosAcu,05] := cDatarq 					// 05 - Periodo
         If lDExtras
            aLancto[nPosAcu,06] := ZT6->ZT6_DIAINF 			// 06 - Dias Informados
            aLancto[nPosAcu,07] := ZT6->ZT6_DIASOM 			// 07 - Dias para Somar
            aLancto[nPosAcu,08] := ZT6->ZT6_DIASUB 			// 08 - Dias para Subtrair
         EndIf
         aLancto[nPosAcu,09] := nDiasVale 					// 09 - Dias Calculados
         aLancto[nPosAcu,10] := aTabVale[nPosTab,3] 		// 10 - Valor Unitario
         aLancto[nPosAcu,11] := nTotVale		 			// 11 - Valor Total Calculado
         aLancto[nPosAcu,12] := nDescont 					// 12 - Desconto do Funcionario
         aLancto[nPosAcu,13] := nEmpresa		 			// 13 - Valor da Empresa
         aLancto[nPosAcu,14] := ZT6->ZT6_CC 				// 14 - Centro de Custo
         aLancto[nPosAcu,15] := nFaltas 					// 15 - Dias de Faltas
         aLancto[nPosAcu,16] := nFerias 					// 16 - Dias de Ferias
         aLancto[nPosAcu,17] := nAfasta 					// 17 - Dias de Afastamentos
         aLancto[nPosAcu,18] := cProcess       				// 18 - Pedido Efetuado
         aLancto[nPosAcu,19] := .F.							// 19 - Deletar
         aLancto[nPosAcu,20] := cDias						// 20 - Dias Calculados
         aLancto[nPosAcu,21] := cPeriodo					// 21 - Periodo
         aLancto[nPosAcu,22] := ZT6->ZT6_TIPO				// 22 - Tipo do Beneficio
         aLancto[nPosAcu,23] := dPerIni						// 23 - Periodo de Apuracao De
         aLancto[nPosAcu,24] := dPerFim						// 24 - Periodo de Apuracao Ate
         aLancto[nPosAcu,25] := "1"							// 25 - Status do Pedido - 1=Pagto Autorizado;2=Abandono;3=Aviso Previo
      Else
         Aadd( aLogDetais[1], "Tabela do benefํcio " + ZT6->ZT6_COD + " nใo cadastrada!" )
      EndIf
      
      RecLock("ZT6",.F.)
       ZT6->ZT6_DIAINF := 0 		// Dias Informados
       ZT6->ZT6_DIASOM := 0			// Dias para Somar
       ZT6->ZT6_DIASUB := 0			// Dias para Subtrair
      MsUnlock()
      
      dbSkip()
   EndDo

   // Atualiza o Calculo na Tabela de Fechamento
   dbSelectArea( "ZT7" )
   For nX := 1 To Len( aLancto )
       If dbSeek( aLancto[nX,01] + aLancto[nX,02] + aLancto[nX,05] + aLancto[nX,03] + aLancto[nX,21] )
          If aLancto[nX,19]
             RecLock("ZT7",.F.)
              dbDelete()
             MsUnlock()
             Loop
          EndIf
          RecLock("ZT7",.F.)
       Else
          RecLock("ZT7",.T.)
       EndIf
        ZT7->ZT7_FILIAL := aLancto[nX,01]		// 01 - Filial
        ZT7->ZT7_MAT    := aLancto[nX,02]		// 02 - Matricula
        ZT7->ZT7_COD    := aLancto[nX,03]		// 03 - Codigo Beneficio
        ZT7->ZT7_DESC   := aLancto[nX,04] 		// 04 - Descricao
        ZT7->ZT7_DATARQ := aLancto[nX,05]		// 05 - Periodo
        ZT7->ZT7_DIAINF := aLancto[nX,06] 		// 06 - Dias Informados
        ZT7->ZT7_DIASOM := aLancto[nX,07] 		// 07 - Dias para Somar
        ZT7->ZT7_DIASUB := aLancto[nX,08] 		// 08 - Dias para Subtrair
        ZT7->ZT7_DIACAL := aLancto[nX,09] 		// 09 - Dias Calculados
        ZT7->ZT7_VLVALE := aLancto[nX,10] 		// 10 - Valor Unitario
        ZT7->ZT7_TTVALE := aLancto[nX,11] 		// 11 - Valor Total Calculado
        ZT7->ZT7_VLFUNC := aLancto[nX,12] 		// 12 - Desconto do Funcionario
        ZT7->ZT7_VLEMPR := aLancto[nX,13] 		// 13 - Valor da Empresa
        ZT7->ZT7_CC     := aLancto[nX,14] 		// 14 - Centro de Custo
        ZT7->ZT7_FALTAS := aLancto[nX,15] 		// 15 - Dias de Faltas
        ZT7->ZT7_FERIAS := aLancto[nX,16] 		// 16 - Dias de Ferias
        ZT7->ZT7_AFAST  := aLancto[nX,17] 		// 17 - Dias de Afastamentos
        ZT7->ZT7_PEDIDO := aLancto[nX,18]		// 18 - Pedido Efetuado
        ZT7->ZT7_DIAS   := aLancto[nX,20]		// 20 - Dias Calculados
        ZT7->ZT7_PERIOD := aLancto[nX,21]		// 21 - Periodo
        ZT7->ZT7_TIPO   := aLancto[nX,22]		// 22 - Tipo do Beneficio
        ZT7->ZT7_DTDE   := aLancto[nX,23]		// 23 - Periodo de Apuracao De
        ZT7->ZT7_DTATE  := aLancto[nX,24]		// 24 - Periodo de Apuracao Ate
        ZT7->ZT7_STATUS := aLancto[nX,25]		// 25 - Status do Pedido
        If aLancto[nX,25] == "1"
           ZT7->ZT7_TURNO  := cTurno			//    - Turno de Trabalho
           ZT7->ZT7_ESCALA := cEscala			//    - Escala
           ZT7->ZT7_PERCAL := cMesPagto			//    - Periodo para Pagamento em Folha/Adiantamento
        EndIf
       MsUnlock()
   Next nX

   // Finaliza Controle de Transacao
   End Sequence

   dbSelectArea( "WSRA" )
   dbSkip()
EndDo
WSRA->(dbCloseArea())
dbSelectArea( "SRA" )

If ( nCalcBnf == 1 .Or. nCalcBnf == 3 ) .And. lCalcOk .And. GETMV( "GP_VRBNMES" ) < cDatarq
   PUTMV( "GP_VRBNMES", cDatarq )
EndIf
If ( nCalcBnf == 2 .Or. nCalcBnf == 3 ) .And. lCalcOk .And. GETMV( "GP_VRBNMES" ) < cDatarq
   PUTMV( "GP_VABNMES", cDatarq )
EndIf

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
ฑฑบPrograma  ณVAGPEM01  บAutor  ณMicrosiga           บ Data ณ  04/25/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fCargaTab( aTabela, cTipo )

 Local aOld := GETAREA()
 Local lRet := .F.
 
 aTabela   := {}
 
 dbSelectArea( "ZT8" )
 dbGoTop()
 Do While !Eof()
    If ( cTipo == "VR" .And. ZT8->ZT8_TIPO <> "1" ) .Or. ;
       ( cTipo == "VA" .And. ZT8->ZT8_TIPO <> "2" )
       dbSkip()
       Loop
    EndIf
    
    Aadd(aTabela,{ZT8->ZT8_COD,				; // 01 Codigo
                  ZT8->ZT8_DESC,			; // 02 Descricao
                  ZT8->ZT8_VALOR,	 		; // 03 Valor Unitario do Vale
                  ZT8->ZT8_PERC,			; // 04 Percentual do Desconto do Funcionario
                  ZT8->ZT8_TETO,			; // 05 Teto do Desconto
                  ZT8->ZT8_DFIXVA,			; // 06 Dias Fixos de VA
                  ZT8->ZT8_PERCAL}			) // 07 Periodos para Calculo
    
    If aTabela[Len(aTabela),5] == 0
       aTabela[Len(aTabela),5] := 999999.99
    EndIf

    dbSkip()
 EndDo
 
 lRet := Len( aTabela ) > 0

 RESTAREA( aOld )
 
Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVRGPEM01  บAutor  ณMicrosiga           บ Data ณ  04/25/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
User Function fDias( nDiasVale, dDtRef, aDias, cTipBen, cPeriodo, dPerIni, dPerFim, dDtIni, dDtFim, cTurno, cEscala, aLogDetais )

 Local aOld     := GETAREA()
 Local cMesAno  := MesAno( dDtRef )
 Local cZt5Fil  := xFilial( "ZT5" )		// Order 1 - ZT5_FILIAL+ZT5_CODIGO+ZT5_ANO+ZT5_MES+DTOS(ZT5_DATA)
 Local cTipDia  := ""
 Local lTipDia  := .F.
 Local cTpBen   := ""
 Local cChave   := ""
 Local lFeriado := .F.
 Local cMesDia
 
 DEFAULT dDtIni := Ctod( "" )
 DEFAULT dDtFim := Ctod( "" )
 
 ZT4->(dbSetOrder( 1 ))
 ZT5->(dbSetOrder( 1 ))

 aDias   := {}
 dDtIni  := If( Empty(dDtIni), dDataBase - 60, dDtIni )
 dDtFim  := If( Empty(dDtFim), dDataBase + 60, dDtFim )
 cTurno  := SRA->RA_TNOTRAB
 cEscala := SRA->RA_ESCBNF
 // Verifica a Escala no Cadastro das Regras de Apontamento
 If lEscalaSpa .And. Empty( cEscala ) .And. !Empty( SRA->RA_REGRA )
    If SPA->(dbSeek( RhFilial("SPA",SRA->RA_FILIAL) + SRA->RA_REGRA ))
       If !Empty( SPA->PA_ESCBNF )
          cEscala := SPA->PA_ESCBNF
       EndIf
    EndIf
 EndIf
 // Considera o Turno de Trabalho
 If Empty( cEscala )
    SR6->(dbSeek( RhFilial("SR6",SRA->RA_FILIAL) + cTurno ))
    cEscala := SR6->R6_ESCBNF
 EndIf
 
 If Empty( cEscala )
    Aadd( aLogDetais[1], "Escala nใo cadastrada para o funcionแrio " + SRA->RA_FILIAL + " - " + SRA->RA_MAT + " - " + SRA->RA_NOME + " - Turno " + cTurno )
 EndIf
 
 If ZT3->(dbSeek( xFilial("ZT3") + cEscala ))
    If cTipBen == "VR"
       nDiasVale := ZT3->ZT3_DFIXVR
       cTpBen    := "2"
    ElseIf cTipBen == "VA"
       nDiasVale := ZT3->ZT3_DFIXVA
       cTpBen    := "3"
    ElseIf cTipBen $ "VT/DVT"
       nDiasVale := ZT3->ZT3_DFIXVT
       cTpBen    := "1"
    EndIf
     
    cChave  := cZt5Fil + cEscala + cPeriodo + cTpBen + cMesAno
 
    dbSelectArea( "ZT4" )
    If dbSeek( cChave )
       dPerIni := ZT4->ZT4_DTINI
       dPerFim := ZT4->ZT4_DTFIM
    Else
       Aadd( aLogDetais[1], "Calendแrio para a escala " + cEscala + " de " + cTipBen + " nใo cadastrado para o perํodo " + cPeriodo + " da compet๊ncia " + StrZero(Month(dDtRef),2) + "/" + StrZero(Year(dDtRef),4) + "!" )
    EndIf
 
    dbSelectArea( "ZT5" )
    dbSeek( cChave )
    Do While !Eof() .And. ZT5->(ZT5_FILIAL + ZT5_CODIGO + ZT5_PERIOD + ZT5_TIPBEN + ZT5_ANO + ZT5_MES) == cChave
       cTipDia  := ""
       lTipDia  := .F.
       If cTipBen == "VT"
          cTipDia  := ZT5->ZT5_VT
          lTipDia  := ZT5->ZT5_VT == "2"
       ElseIf cTipBen == "DVT"
          cTipDia  := ZT5->ZT5_DVT
          lTipDia  := ZT5->ZT5_DVT == "2"
       ElseIf cTipBen == "VR"
          cTipDia  := ZT5->ZT5_VR
          lTipDia  := ZT5->ZT5_VR == "2"
       ElseIf cTipBen == "VA"
          cTipDia  := ZT5->ZT5_VA
          lTipDia  := ZT5->ZT5_VA == "2"
       EndIf

       Aadd(aDias,{ZT5->ZT5_DATA, ZT5->ZT5_TPDIA, cTipDia, lTipDia, ""})
    
       // Desconsidera Dias Anteriores a Admissao
       If SRA->RA_ADMISSA > ZT5->ZT5_DATA
          aDias[Len(aDias),4] := .T.
          aDias[Len(aDias),5] := "ADM"
       EndIf
    
       // Desconsidera Feriados
       lFeriado := .F.
       SP3->(dbSetOrder( 1 ))
       If SP3->(dbSeek( RhFilial("SP3",SRA->RA_FILIAL) + Dtos(ZT5->ZT5_DATA) ))
          lFeriado := .T.
       Else
          SP3->(dbSetOrder( 2 ))
          cMesDia := StrZero(Month(ZT5->ZT5_DATA),2) + StrZero(Day(ZT5->ZT5_DATA),2)
          If SP3->(dbSeek( RhFilial("SP3",SRA->RA_FILIAL) + cMesDia + "S" ))
             lFeriado := .T.
          EndIf
       EndIf
       If lFeriado
          aDias[Len(aDias),4] := .T.
          aDias[Len(aDias),5] := "FRD"
       EndIf
       
       // Desconsidera Dias Fora do Periodo de Validade
       If ZT5->ZT5_DATA < dDtIni .Or. ZT5->ZT5_DATA >= dDtFim
          aDias[Len(aDias),4] := .T.
          aDias[Len(aDias),5] := "VLD"
       EndIf
    
       dbSkip()
    EndDo
 ElseIf !Empty( cEscala )
    Aadd( aLogDetais[1], "Escala " + cEscala + " nใo cadastrada para o funcionแrio " + SRA->RA_FILIAL + " - " + SRA->RA_MAT + " - " + SRA->RA_NOME + " - Turno " + cTurno )
 EndIf
 
 RESTAREA( aOld )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVRGPEM01  บAutor  ณMicrosiga           บ Data ณ  01/23/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
User Function fFerProg( dPerIni, dPerFim, aAfast )

 Local aOldAtu := GETAREA()
 Local dDtBase := Ctod( "" )
 Local lProgra := .T.
 Local cRet    := "1"
 Local nX
 
 DEFAULT aAfast := {}
 
 dbSelectArea( "SRF" )
 If dbSeek( SRA->(RA_FILIAL + RA_MAT) )
    dDtBase := SRF->RF_DATABAS
    dbSelectArea( "SRH" )
    For nX := 1 To 2
       If nX == 2
          dDtBase := U_fSubAno(SRF->RF_DATABAS,1)
       EndIf
       If dbSeek( SRA->(RA_FILIAL + RA_MAT) + Dtos(dDtBase) )
          Do While !Eof() .And. SRH->(RH_FILIAL + RH_MAT + Dtos(RH_DATABAS)) == SRA->(RA_FILIAL + RA_MAT) + Dtos(dDtBase)
             If SRH->RH_DATAINI >= dPerIni .Or. SRH->RH_DATAINI <= dPerFim
                Aadd(aAfast,{1,SRH->RH_DFERIAS,SRH->RH_DATAINI,SRH->RH_DATAFIM,"F","","","",SRH->RH_DFERIAS})
                lProgra := .F.
             EndIf
             cRet := "1"
             dbSkip()
          EndDo
       EndIf
    Next nX
    dbSelectArea( "SRF" )
    
    If lProgra     
       // Verifica Ferias Programadas 1o Periodo
       If ( SRF->RF_DATAINI >= dPerIni .And. SRF->RF_DATAINI <= dPerFim ) .Or. ;
          ( SRF->RF_DATAINI + (SRF->RF_DFEPRO1-1) >= dPerIni .And. SRF->RF_DATAINI + (SRF->RF_DFEPRO1-1) <= dPerFim )
          Aadd(aAfast,{1,SRF->RF_DFEPRO1,SRF->RF_DATAINI,( SRF->RF_DATAINI + (SRF->RF_DFEPRO1-1) ),"F","","","",SRF->RF_DFEPRO1})
       EndIf

       // Verifica Ferias Programadas 2o Periodo
       If ( SRF->RF_DATINI2 >= dPerIni .And. SRF->RF_DATINI2 <= dPerFim ) .Or. ;
          ( SRF->RF_DATINI2 + (SRF->RF_DFEPRO2-1) >= dPerIni .And. SRF->RF_DATINI2 + (SRF->RF_DFEPRO2-1) <= dPerFim )
          Aadd(aAfast,{1,SRF->RF_DFEPRO2,SRF->RF_DATINI2,( SRF->RF_DATINI2 + (SRF->RF_DFEPRO2-1) ),"F","","","",SRF->RF_DFEPRO2})
       EndIf

       // Verifica Ferias Programadas 3o Periodo
       If ( SRF->RF_DATINI3 >= dPerIni .And. SRF->RF_DATINI3 <= dPerFim ) .Or. ;
          ( SRF->RF_DATINI3 + (SRF->RF_DFEPRO3-1) >= dPerIni .And. SRF->RF_DATINI3 + (SRF->RF_DFEPRO3-1) <= dPerFim )
          Aadd(aAfast,{1,SRF->RF_DFEPRO3,SRF->RF_DATINI3,( SRF->RF_DATINI3 + (SRF->RF_DFEPRO3-1) ),"F","","","",SRF->RF_DFEPRO3})
       EndIf
       cRet := "2"
    EndIf
 EndIf
 
 RESTAREA( aOldAtu )
 
Return( cRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVRGPEM01  บAutor  ณMicrosiga           บ Data ณ  06/06/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna as Faltas do Periodo.                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
User Function fRetFaltas( nFaltas, nSubMeses, dDtRef, cTipoBen )

Local aOldAtu   := GETAREA()
Local cPerAnt   := MesAno( dDtRef )
Local cVerbFal  := ""
Local cModFalt  := GETMV( "GP_FALTMOD",,"GPE" )
Local cPdPesq   := ""
Local nDiasFal  := 0
Local dPonIni   := Ctod( "" )
Local dPonFim   := Ctod( "" )
Local aFaltas   := {}
Local cTemp
Local cQuery
Local nPos
Local nDia, nX

DEFAULT cTipoBen := ""

If cModFalt == "GPE"
   // Verbas de Faltas
   cVerbFal  := aCodFol[054,1] + "*" + aCodFol[242,1] + "*" + cPdFaltas

   // Verifica o Mes de Pesquisa das Faltas
   For nX := 1 To nSubMeses
       U_fSbMesAno( @cPerAnt )
   Next nX

   dbSelectArea( "SRD" )  // RD_FILIAL+RD_MAT+RD_DATARQ+RD_PD+RD_SEMANA+RD_SEQ+RD_CC
   For nX := 1 To Len( cVerbFal ) Step 4
       cPdPesq := SubStr(cVerbFal,nX,3)
       dbSeek( SRA->(RA_FILIAL+RA_MAT) + cPerAnt + cPdPesq )
       Do While !Eof() .And. SRD->(RD_FILIAL+RD_MAT+RD_DATARQ+RD_PD) == SRA->(RA_FILIAL+RA_MAT) + cPerAnt + cPdPesq
          If SRD->RD_TIPO1 == "D" 
             nDiasFal += SRD->RD_HORAS 
          ElseIf SRD->RD_TIPO1 == "H"
             nDia := (SRD->RD_HORAS/(SRA->RA_HRSMES/30)) - Int(SRD->RD_HORAS/(SRA->RA_HRSMES/30))
             If nDia < 0.5
                nDiasFal += Int(SRD->RD_HORAS/(SRA->RA_HRSMES/30))
             Else
                nDiasFal += (Int(SRD->RD_HORAS/(SRA->RA_HRSMES/30)) + 1)
             EndIf
          EndIf
          dbSkip()
       EndDo
   Next nX
   nFaltas := nDiasFal
ElseIf cModFalt == "PON"
   // Evento de Faltas Nao Autorizadas
   If ( nPos := Ascan(aEventos,{|x| x[2]=="009N"}) ) > 0
      cVerbFal += aEventos[nPos,1] + "*"
   EndIf
   // Evento de Faltas Autorizadas
   If ( nPos := Ascan(aEventos,{|x| x[2]=="010A"}) ) > 0
      cVerbFal += aEventos[nPos,1] + "*"
   EndIf
   // Evento de Faltas Conforme Parametro GP_PDFALTA
   cVerbFal += cPdFaltas

   // Determina o Periodo em Aberto do Ponto
   U_fRetPerPonto( dDtRef, @dPonIni, @dPonFim )

   // Verifica o Mes de Pesquisa das Faltas
   dPonIni := U_fSubMes( dPonIni, nSubMeses )
   dPonFim := U_fSubMes( dPonFim, nSubMeses )

   cTemp    := Alltrim( cVerbFal )
   cVerbFal := ""
   For nX := 1 To Len( cTemp ) Step 4
       cVerbFal += "'" + SubStr(cTemp,nX,3) + "',"
   Next nX
   cVerbFal := SubStr(cVerbFal,1,Len(cVerbFal)-1)
   
   // Monta a Query para Buscar as Faltas
   cQuery := " SELECT SPC.PC_DATA,"
   cQuery += "        SPC.PC_PD,"
   cQuery += "        SPC.PC_PDI"
   cQuery += " FROM " + RetSqlName( "SPC" ) + " SPC"
   cQuery += " WHERE SPC.D_E_L_E_T_ <> '*'"
   cQuery += "   AND SPC.PC_FILIAL = '" + SRA->RA_FILIAL + "'"
   cQuery += "   AND SPC.PC_MAT = '" + SRA->RA_MAT + "'"
   cQuery += "   AND ((SPC.PC_PD IN (" + cVerbFal + ") AND SPC.PC_PDI = '') OR SPC.PC_PDI IN (" + cVerbFal + "))"
   cQuery += "   AND SPC.PC_DATA BETWEEN '" + Dtos( dPonIni ) + "' AND '" + Dtos( dPonFim ) + "'"

   cQuery += " UNION"

   cQuery += " SELECT SPH.PH_DATA AS PC_DATA,"
   cQuery += "        SPH.PH_PD AS PC_PD,"
   cQuery += "        SPH.PH_PDI AS PC_PDI"
   cQuery += " FROM " + RetSqlName( "SPH" ) + " SPH"
   cQuery += " WHERE SPH.D_E_L_E_T_ <> '*'"
   cQuery += "   AND SPH.PH_FILIAL = '" + SRA->RA_FILIAL + "'"
   cQuery += "   AND SPH.PH_MAT = '" + SRA->RA_MAT + "'"
   cQuery += "   AND ((SPH.PH_PD IN (" + cVerbFal + ") AND SPH.PH_PDI = '') OR SPH.PH_PDI IN (" + cVerbFal + "))"
   cQuery += "   AND SPH.PH_DATA BETWEEN '" + Dtos( dPonIni ) + "' AND '" + Dtos( dPonFim ) + "'"

   TCQuery cQuery New Alias "WTMP"
   TcSetField( "WTMP" , "PC_DATA" , "D" , 08 , 00 )
   dbGoTop()
   Do While !Eof()
      If WTMP->PC_DATA <= dPonFim
         nFaltas += 1
      EndIf
      dbSkip()
   EndDo
   WTMP->(dbCloseArea())
EndIf

// Busca as Faltas dos Periodos Anteriores Ja Calculados
If FunName() <> "GPEM040"
   If nFaltas > 0
      If !Empty( cTipoBen )
         cQuery := " SELECT ZT7_COD,"
         cQuery += "        SUM(ZT7.ZT7_FALTAS) AS ZT7_FALTAS"
         cQuery += " FROM " + RetSqlName( "ZT7" ) + " ZT7"
         cQuery += " WHERE ZT7.D_E_L_E_T_ <> '*'"
         cQuery += "   AND ZT7.ZT7_FILIAL = '" + SRA->RA_FILIAL + "'"
         cQuery += "   AND ZT7.ZT7_MAT = '" + SRA->RA_MAT + "'"
         cQuery += "   AND ZT7.ZT7_DATARQ = '" + cDatarq + "'"
         cQuery += "   AND ZT7.ZT7_PERIOD < '" + cPeriodo + "'"
         cQuery += "   AND ZT7.ZT7_TIPO = '" + cTipoBen + "'"			// 1=Refeicao - 2=Alimentacao
         cQuery += " GROUP BY ZT7_COD"
      Else
         cQuery := " SELECT ZTB.ZTB_COD AS ZT7_COD,"
         cQuery += "        SUM(ZTB.ZTB_FALTAS) AS ZT7_FALTAS"
         cQuery += " FROM " + RetSqlName( "ZTB" ) + " ZTB"
         cQuery += " WHERE ZTB.D_E_L_E_T_ <> '*'"
         cQuery += "   AND ZTB.ZTB_FILIAL = '" + SRA->RA_FILIAL + "'"
         cQuery += "   AND ZTB.ZTB_MAT = '" + SRA->RA_MAT + "'"
         cQuery += "   AND ZTB.ZTB_DATARQ = '" + cDatarq + "'"
         cQuery += "   AND ZTB.ZTB_PERIOD < '" + cPeriodo + "'"
         cQuery += " GROUP BY ZTB_COD"
      EndIf
      TCQuery cQuery New Alias "WTMP"
      TcSetField( "WTMP" , "ZT7_FALTAS" , "N" , 06 , 00 )
      nFaltas -= WTMP->ZT7_FALTAS
      WTMP->(dbCloseArea())
   EndIf
EndIf

nFaltas := If(nFaltas < 0, 0, nFaltas )

RESTAREA( aOldAtu )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNFR010  บAutor  ณMicrosiga           บ Data ณ  10/19/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
User Function fBnfPer( nTipo, l1Elem )

Local aOld     := GETAREA()
Local cTitulo  := ""
Local MvParDef := ""
Local MvPar

Private aElement

DEFAULT l1Elem := .T.

MvPar := &(Alltrim(ReadVar()))		 // Carrega Nome da Variavel do Get em Questao
mvRet := Alltrim(ReadVar())			 // Iguala Nome da Variavel ao Nome variavel de Retorno

cTitulo  := "Selecione os Periodos"

If nTipo == 1	// Individual
   aElement := Array( 09 )
   aElement[1] := "1o Periodo"
   aElement[2] := "2o Periodo"
   aElement[3] := "3o Periodo"
   aElement[4] := "4o Periodo"
   aElement[5] := "5o Periodo"
   aElement[6] := "6o Periodo"
   aElement[7] := "7o Periodo"
   aElement[8] := "8o Periodo"
   aElement[9] := "9o Periodo"
   MvParDef := "123456789"
Else
   aElement := Array( 10 )
   aElement[01] := "   Todos os Periodos"
   aElement[02] := "1o Periodo"
   aElement[03] := "2o Periodo"
   aElement[04] := "3o Periodo"
   aElement[05] := "4o Periodo"
   aElement[06] := "5o Periodo"
   aElement[07] := "6o Periodo"
   aElement[08] := "7o Periodo"
   aElement[09] := "8o Periodo"
   aElement[10] := "9o Periodo"
   MvParDef := " 123456789"
EndIf

If f_Opcoes( @MvPar, cTitulo, aElement, MvParDef, 12, 49, l1Elem )
   &MvRet := mvpar
EndIf	

RESTAREA( aOld )

Return( .T. )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNFR010  บAutor  ณMicrosiga           บ Data ณ  10/19/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
User Function fTipPed()

Local aOld     := GETAREA()
Local cTitulo  := ""
Local MvParDef := ""
Local MvPar

Private aElement
Private l1Elem := .F.

MvPar := &(Alltrim(ReadVar()))		 // Carrega Nome da Variavel do Get em Questao
mvRet := Alltrim(ReadVar())			 // Iguala Nome da Variavel ao Nome variavel de Retorno

cTitulo  := "Selecione os Tipos de Pedido"

If nTipo == 1	// Individual
   aElement := Array( 06 )
   aElement[1] := "1=Gerar Pedido"
   aElement[2] := "2=Pagto Folha"
   aElement[3] := "3=Pagto Adiantamento"
   aElement[4] := "4=Gerar Cnab"
   aElement[5] := "5=Pedido Efetuado"
   aElement[6] := "6=CNAB Gerado"
   MvParDef := "123456"
Else
   aElement := Array( 06 )
   aElement[1] := "1=Gerar Pedido"
   aElement[2] := "2=Pagto Folha"
   aElement[3] := "3=Pagto Adiantamento"
   aElement[4] := "4=Gerar Cnab"
   aElement[5] := "5=Pedido Efetuado"
   aElement[6] := "6=CNAB Gerado"
   MvParDef := "123456"
EndIf

If f_Opcoes( @MvPar, cTitulo, aElement, MvParDef, 12, 49, l1Elem )
   &MvRet := mvpar
EndIf	

RESTAREA( aOld )

Return( .T. )

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
 aAdd(aRegs,{ cPerg,'12','Calcular Beneficio ?          ','','','mv_chc','N',01,0,0,'C','            ','mv_par12','Refeicao'         ,'','','','','Alimentacao'      ,'','','','','Ambos'               ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
 aAdd(aRegs,{ cPerg,'13','Processamento Para  ?         ','','','mv_chd','N',01,0,0,'C','            ','mv_par13','Compra'           ,'','','','','Pagto Folha'      ,'','','','','Pagto Adto'          ,'','','','','Gerar CNAB'       ,'','','','',''      ,'','','' ,'      ','' })
 aAdd(aRegs,{ cPerg,'14','Pagto Folha/Adiant (MMAAAA)?  ','','','mv_che','C',06,0,0,'G','            ','mv_par14',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
 U_fDelSx1( cPerg, "15" )

ValidPerg(aRegs,cPerg)

Return   
