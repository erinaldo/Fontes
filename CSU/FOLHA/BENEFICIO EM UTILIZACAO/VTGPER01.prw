#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#DEFINE          cEol         CHR(13)+CHR(10)
#DEFINE          cSep         ";"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VTGPER01 บ Autor ณ Adilson Silva      บ Data ณ 02/02/2011  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Mapa do Vale Transporte.                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function VTGPER01()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Mapa Vale Transporte"
Local cPict          := ""
Local titulo         := "MAPA-VALE TRANSPORTE"
Local nLin           := 80
Local Cabec1         := " FILIAL   C CUSTO    MAT     NOME                            CPF          TURNO  ESCALA  COD  DESCR VALE                 DIAS   TOTAL           VALOR         TOTAL         TOTAL        VALOR          PARTE"
Local Cabec2         := "                                                                                                                         VALE  DE VALES      UNITARIO     DOS VALES    DIFERENCAS      DESCONTO       EMPRESA"
Local imprime        := .T.

Private aOrd         := { "Matricula", "Centro de Custo", "Nome" } 
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "VTGPER01"
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "VTGPER01"
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "VTGPER01"
Private cString      := "SRA"

fAsrPerg()
pergunte(cPerg,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.T.)
If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)
If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  11/02/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem   := aReturn[8]
Local cPath    := AllTrim( GetTempPath() )
Local lFirst   := .T.
Local nTotReg  := 0
Local cNomeArq := ""
Local dDtRef   := Ctod( "" )
Local cEscala  := ""

Local lExcel, cLin
Local nPos, nX
Local dPerIni, dPerFim

Local cChaveMat, cChaveCc, cChaveFil
Local cChavQde

Private dAdmDe     := Ctod( "" )
Private dAdmAte    := Ctod( "" )
Private lEscalaSpa := U_fExistSx3( "PA_ESCBNF" )

Private cFilDe, cFilAte, cMatDe, cMatAte, cCcDe, cCcAte
Private cNomeDe, cNomeAte, cSit, cCat
Private lTotFunc, lTotCc, lTotFil, lTotEmpr, lQuebra
Private cProcess, cFilPrint
Private cTipStat, cTipPed

Private aTotFunc, aTotCc, aTotFil, aTotEmpr
Private aResFil, aResEmp, cCodFor
Private cOldFil, cOldCc, aInfo, cDescCc, cPeriodo

Private nHdl

Pergunte(cPerg,.F.)
 dDtRef    := mv_par01
 cFilDe    := mv_par02
 cFilAte   := mv_par03
 cMatDe    := mv_par04
 cMatAte   := mv_par05
 cCcDe     := mv_par06
 cCcAte    := mv_par07
 cNomeDe   := mv_par08
 cNomeAte  := mv_par09
 dAdmDe    := mv_par10
 dAdmAte   := mv_par11
 cSit      := U_fSqlIN( mv_par12, 1 )
 cCat      := U_fSqlIN( mv_par13, 1 )
 cPeriodo  := mv_par14
 lTotFunc  := mv_par15 == 1
 lQuebra   := mv_par16 == 1 
 lExcel    := mv_par17 == 1 
 cCodFor   := mv_par18
 cTipPed   := U_fSqlIN( mv_par19, 1 )
 cTipStat  := Str(mv_par20,1)
 //cProcess  := Str(mv_par18,1)		// 1=Compra ; 2=Folha ; 3=Adiantamento ; 4=Todos

lTotCc    := .T.
lTotFil   := .T.
lTotEmpr  := .T.

//If cProcess == "1"
//   cProcess := "'1','4','5','6'"
//ElseIf cProcess == "4"
//   cProcess := "'1','2','3','4','5','6'"
//Else
//   cProcess := "'" + cProcess + "'"
//EndIf
 
Titulo  := Alltrim( Titulo ) + " TRANSPORTE"
Titulo += " - " + Right(MesAno( dDtRef ),2) + "/" + Left(MesAno( dDtRef ),4) + " - Periodo: " + If(Empty(cPeriodo),"Todos",cPeriodo)

cNomeArq  := CriaTrab(,.F.) + ".CSV"

// Cria Arquivo Texto
cPath     := cPath + If(Right(cPath,1) <> "\","\","")
cNomeArq  := cPath + cNomeArq
nHdl      := fCreate( cNomeArq )
If nHdl == -1
   MsgAlert("O arquivo de nome "+cNomeArq+" nao pode ser executado! Verifique os parametros.","Atencao!")
   Return
EndIf

CTT->(dbSetOrder( 1 ))
SRA->(dbSetOrder( 1 ))
SR6->(dbSetOrder( 1 ))
ZT4->(dbSetOrder( 1 ))

// Monta Query Principal
MsAguarde( {|| fMtaQuery( dDtRef, nOrdem )}, "Processando...", "Selecionado Registros no Banco de Dados..." )

aTotFunc  := {0,0,0,"",0,0}
aTotCc    := {0,0,0,"",0,0}
aTotFil   := {0,0,0,"",0,0}
aTotEmpr  := {0,0,0,"",0,0}
aResFil   := {}
aResEmp   := {}
cChaveMat := "@@"
cChaveCc  := "@@"
cChaveFil := "@@"
aInfo     := {}
cDescCc   := ""

// Grava Cabecalho do Arquivo Texto
fGrvCab()

dbSelectArea( "WZTB" )
Count To nTotReg
If nTotReg = 0
   Aviso("ATENCAO","Nao Existem Dados para Este Relatorio",{"Sair"})
   WZTB->(dbCloseArea())
   Return
EndIf
dbGoTop()
SetRegua( nTotReg )

If nOrdem == 1
   cChaveMat := WZTB->(ZTB_FILIAL + ZTB_MAT)
   cChaveFil := WZTB->ZTB_FILIAL
ElseIf nOrdem == 2
   cChaveMat := WZTB->(ZTB_FILIAL + ZTB_CC + ZTB_MAT)
   cChaveCc  := WZTB->(ZTB_FILIAL + ZTB_CC)
   cChaveFil := WZTB->ZTB_FILIAL
ElseIf nOrdem == 3
   cChaveMat := WZTB->(ZTB_FILIAL + ZTB_NOME)
   cChaveFil := WZTB->ZTB_FILIAL
EndIf
cOldFil  := "@@"
cOldCc   := "@@"
cChavQde := "@@"
Do While !Eof()
   IncRegua()
   
   If nLin > 58
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 9
   Endif

   CTT->(dbSeek( xFilial("CTT") + WZTB->ZTB_CC ))
   SRA->(dbSeek( WZTB->(ZTB_FILIAL + ZTB_MAT) ))
   SR6->(dbSeek( xFilial("SR6") + SRA->RA_TNOTRAB ))
   
   cEscala := If(!Empty(SRA->RA_ESCBNF), SRA->RA_ESCBNF, SR6->R6_ESCBNF)
   // Verifica a Escala no Cadastro das Regras de Apontamento
   If lEscalaSpa .And. !Empty( SRA->RA_REGRA )
      If SPA->(dbSeek( RhFilial("SPA",SRA->RA_FILIAL) + SRA->RA_REGRA ))
         If !Empty( SPA->PA_ESCBNF )
            cEscala := SPA->PA_ESCBNF
         EndIf
      EndIf
   EndIf

   If lFirst
      @ nLin,001 PSAY WZTB->ZTB_FILIAL
      @ nLin,010 PSAY Left(WZTB->ZTB_CC,9)
      @ nLin,021 PSAY WZTB->ZTB_MAT
      @ nLin,029 PSAY PadR(WZTB->ZTB_NOME,30)
      @ nLin,061 PSAY WZTB->ZTB_CIC
      @ nLin,075 PSAY WZTB->ZTB_TURNO
      @ nLin,083 PSAY WZTB->ZTB_ESCALA
      lFirst := .F.
   EndIf
   @ nLin,089 PSAY WZTB->ZTB_COD + "-" + WZTB->ZTB_PERIOD
   @ nLin,094 PSAY PadR(WZTB->ZTB_DESC,25)
   @ nLin,122 PSAY Str( WZTB->ZTB_DIACAL,2 )
   @ nLin,129 PSAY Str( WZTB->ZTB_QDEVAL,4 )
   @ nLin,137 PSAY Transform(WZTB->ZTB_VLVALE,'@E 9,999,999.99')
   @ nLin,151 PSAY Transform(WZTB->ZTB_TTVALE,'@E 9,999,999.99')
   @ nLin,165 PSAY Transform(WZTB->ZTB_VLDIFE,'@E 9,999,999.99')
   @ nLin,179 PSAY Transform(WZTB->ZTB_VLFUNC,'@E 9,999,999.99')
   @ nLin,193 PSAY Transform(WZTB->ZTB_VLEMPR,'@E 9,999,999.99')
   nLin++

   If lExcel
      cLin := '="' + WZTB->ZTB_FILIAL + '"' + cSep
      cLin += '="' + Alltrim(WZTB->ZTB_CC) + '"' + cSep
      cLin += '="' + WZTB->ZTB_MAT + '"' + cSep
      cLin += WZTB->ZTB_NOME + cSep
      cLin += '="' + WZTB->ZTB_PERIOD + '"' + cSep
      cLin += '="' + WZTB->ZTB_COD + '"' + cSep
      cLin += WZTB->ZTB_DESC + cSep
      cLin += StrZero( WZTB->ZTB_DIACAL,2 ) + cSep
      cLin += StrZero( WZTB->ZTB_QDEVAL,3 ) + cSep
      cLin += Transform(WZTB->ZTB_VLVALE,'@E 999,999.99') + cSep
      cLin += Transform(WZTB->ZTB_TTVALE,'@E 999,999.99') + cSep
      cLin += Transform(WZTB->ZTB_VLFUNC,'@E 999,999.99') + cSep
      cLin += Transform(WZTB->ZTB_VLEMPR,'@E 999,999.99') + cEol
      fGravaTxt( cLin, nHdl )
   EndIf

   // Atualiza Totalizadores por Meio de Transporte - FILIAL
   If ( nPos := Ascan(aResFil,{|x| x[1]==WZTB->ZTB_COD}) ) == 0
      Aadd(aResFil, { WZTB->ZTB_COD, 		; // 01 - Codigo do Meio de Transporte
                      WZTB->ZTB_DESC, 		; // 02 - Meio de Transporte
                      WZTB->ZTB_QDEVAL, 	; // 03 - Quantidade Mensal
                      WZTB->ZTB_VLVALE, 	; // 04 - Valor Unitario
                      WZTB->ZTB_TTVALE, 	; // 05 - Total do Vale Transporte
                      WZTB->ZTB_VLFUNC, 	; // 06 - Total do Funcionario
                      WZTB->ZTB_VLEMPR}		) // 07 - Total da Empresa
   Else
      aResFil[nPos,3] += WZTB->ZTB_QDEVAL
      aResFil[nPos,5] += WZTB->ZTB_TTVALE
      aResFil[nPos,6] += WZTB->ZTB_VLFUNC
      aResFil[nPos,7] += WZTB->ZTB_VLEMPR
   EndIf
   // Atualiza Totalizadores por Meio de Transporte - EMPRESA
   If ( nPos := Ascan(aResEmp,{|x| x[1]==WZTB->ZTB_COD}) ) == 0
      Aadd(aResEmp, { WZTB->ZTB_COD, 		; // 01 - Codigo do Meio de Transporte
                      WZTB->ZTB_DESC, 		; // 02 - Meio de Transporte
                      WZTB->ZTB_QDEVAL, 	; // 03 - Quantidade Mensal
                      WZTB->ZTB_VLVALE, 	; // 04 - Valor Unitario
                      WZTB->ZTB_TTVALE, 	; // 05 - Total do Vale Transporte
                      WZTB->ZTB_VLFUNC, 	; // 06 - Total do Funcionario
                      WZTB->ZTB_VLEMPR}		) // 07 - Total da Empresa
   Else
      aResEmp[nPos,3] += WZTB->ZTB_QDEVAL
      aResEmp[nPos,5] += WZTB->ZTB_TTVALE
      aResEmp[nPos,6] += WZTB->ZTB_VLFUNC
      aResEmp[nPos,7] += WZTB->ZTB_VLEMPR
   EndIf

   // Atualiza Totalizadores do Relatorio
   fAtuTotais( @aTotFunc, @aTotCc, @aTotFil, @aTotEmpr )
   If cChavQde <> WZTB->(ZTB_FILIAL + ZTB_MAT)
      cChavQde := WZTB->(ZTB_FILIAL + ZTB_MAT)
      aTotCc[6]++
      aTotFil[6]++
      aTotEmpr[6]++
   EndIf
   cFilPrint := WZTB->ZTB_FILIAL
		
   dbSkip()
   
   If nOrdem == 1
      If WZTB->(ZTB_FILIAL + ZTB_MAT) # cChaveMat
         cChaveMat := WZTB->(ZTB_FILIAL + ZTB_MAT)
         fPrintTotais( "FUNC", @nLin )
         lFirst := .T.
      EndIf
      If WZTB->ZTB_FILIAL # cChaveFil
         cChaveFil := WZTB->ZTB_FILIAL
         If Eof()
            fPrintTotais( "FIL", @nLin )
            fPrintTotais( "EMPR", @nLin )
            fPrintResumo( "FIL", Titulo, NomeProg, Tamanho, nTipo, @nLin )
            fPrintResumo( "EMPR", Titulo, NomeProg, Tamanho, nTipo, @nLin )
         Else
            fPrintTotais( "FIL", @nLin )
            fPrintResumo( "FIL", Titulo, NomeProg, Tamanho, nTipo, @nLin )
         EndIf
         lFirst  := .T.
      EndIf
   ElseIf nOrdem == 2
      If WZTB->(ZTB_FILIAL + ZTB_CC + ZTB_MAT) # cChaveMat
         cChaveMat := WZTB->(ZTB_FILIAL + ZTB_CC + ZTB_MAT)
         fPrintTotais( "FUNC", @nLin )
         lFirst := .T.
      EndIf
      If WZTB->(ZTB_FILIAL + ZTB_CC) # cChaveCc
         cChaveCc := WZTB->(ZTB_FILIAL + ZTB_CC)
         fPrintTotais( "CC", @nLin )
         lFirst := .T.
      EndIf
      If WZTB->ZTB_FILIAL # cChaveFil
         cChaveFil := WZTB->ZTB_FILIAL
         If Eof()
            fPrintTotais( "FIL", @nLin )
            fPrintTotais( "EMPR", @nLin )
            fPrintResumo( "FIL", Titulo, NomeProg, Tamanho, nTipo, @nLin )
            fPrintResumo( "EMPR", Titulo, NomeProg, Tamanho, nTipo, @nLin )
         Else
            fPrintTotais( "FIL", @nLin )
            fPrintResumo( "FIL", Titulo, NomeProg, Tamanho, nTipo, @nLin )
         EndIf
         lFirst  := .T.
      EndIf
   ElseIf nOrdem == 3
      If WZTB->(ZTB_FILIAL + ZTB_NOME) # cChaveMat
         cChaveMat := WZTB->(ZTB_FILIAL + ZTB_NOME)
         fPrintTotais( "FUNC", @nLin )
         lFirst := .T.
      EndIf
      If WZTB->ZTB_FILIAL # cChaveFil
         cChaveFil := WZTB->ZTB_FILIAL
         If Eof()
            fPrintTotais( "FIL", @nLin )
            fPrintTotais( "EMPR", @nLin )
            fPrintResumo( "FIL", Titulo, NomeProg, Tamanho, nTipo, @nLin )
            fPrintResumo( "EMPR", Titulo, NomeProg, Tamanho, nTipo, @nLin )
         Else
            fPrintTotais( "FIL", @nLin )
            fPrintResumo( "FIL", Titulo, NomeProg, Tamanho, nTipo, @nLin )
         EndIf
         lFirst  := .T.
      EndIf
      
      If lFirst .And. nLin >= 53
         nLin := 80
      EndIf
   EndIf     
EndDo 
WZTB->(dbCloseArea())  
fClose( nHdl )

// Integra Planilha ao Excel
If lExcel
   MsAguarde( {|| fStartExcel( cNomeArq )}, "Aguarde...", "Integrando Planilha ao Excel..." )
EndIf

SET DEVICE TO SCREEN

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVTGPER01  บAutor  ณMicrosiga           บ Data ณ  04/26/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fPrintTotais( cQual, nLin )

 If cQual == "FUNC" .And. lTotFunc
    @ nLin,066 PSAY Left( "-> Total do Funcionario " + Replicate("_",50),50 )
    @ nLin,151 PSAY Transform(aTotFunc[1],'@E 9,999,999.99')
    @ nLin,165 PSAY Transform(aTotFunc[5],'@E 9,999,999.99')
    @ nLin,179 PSAY Transform(aTotFunc[2],'@E 9,999,999.99')
    @ nLin,193 PSAY Transform(aTotFunc[3],'@E 9,999,999.99')
    aTotFunc := {0,0,0,"",0,0}
    nLin++
    @ nLin,014 PSAY Replicate("-",197)
 ElseIf cQual == "CC" .And. lTotCc
    @ nLin,066 PSAY Left( "-> Total C de Custo " + aTotCc[4] + Replicate("_",40),40 )
    @ nLin,108 PSAY Str(aTotCc[6],6) + "(F)"
    @ nLin,151 PSAY Transform(aTotCc[1],'@E 9,999,999.99')
    @ nLin,165 PSAY Transform(aTotCc[5],'@E 9,999,999.99')
    @ nLin,179 PSAY Transform(aTotCc[2],'@E 9,999,999.99')
    @ nLin,193 PSAY Transform(aTotCc[3],'@E 9,999,999.99')
    aTotCc    := {0,0,0,"",0,0}
    nLin++
    @ nLin,001 PSAY Replicate("-",210)
    If lQuebra .And. !(WZTB->(Eof()))
       nLin := 80
    EndIf
 ElseIf cQual == "FIL" .And. lTotFil
    @ nLin,066 PSAY Left( "-> Total da Filial " + aTotFil[4] + Replicate("_",40),40 )
    @ nLin,108 PSAY Str(aTotFil[6],6) + "(F)"
    @ nLin,151 PSAY Transform(aTotFil[1],'@E 9,999,999.99')
    @ nLin,165 PSAY Transform(aTotFil[5],'@E 9,999,999.99')
    @ nLin,179 PSAY Transform(aTotFil[2],'@E 9,999,999.99')
    @ nLin,193 PSAY Transform(aTotFil[3],'@E 9,999,999.99')
    aTotFil   := {0,0,0,"",0,0}
    nLin++
    @ nLin,001 PSAY Replicate("-",210)
    If lQuebra .And. !(WZTB->(Eof()))
       nLin := 80
    EndIf
 ElseIf cQual == "EMPR" .And. lTotEmpr
    @ nLin,066 PSAY Left( "-> Total da Empresa " + aTotEmpr[4] + Replicate("_",40),40 )
    @ nLin,108 PSAY Str(aTotEmpr[6],6) + "(F)"
    @ nLin,151 PSAY Transform(aTotEmpr[1],'@E 9,999,999.99')
    @ nLin,165 PSAY Transform(aTotEmpr[5],'@E 9,999,999.99')
    @ nLin,179 PSAY Transform(aTotEmpr[2],'@E 9,999,999.99')
    @ nLin,193 PSAY Transform(aTotEmpr[3],'@E 9,999,999.99')
    aTotEmpr  := {0,0,0,"",0,0}
    nLin++
    @ nLin,001 PSAY Replicate("-",210)
 EndIf

 If cQual == "FUNC" .And. !lTotFunc .And. !lTotCc .And. !lTotFil .And. !lTotEmpr 
    nLin++
    @ nLin,014 PSAY Replicate("-",116)
 EndIf
 
 nLin++
 
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVTGPER01  บAutor  ณMicrosiga           บ Data ณ  11/01/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fPrintResumo( cTipoRel , Titulo, NomeProg, Tamanho, nTipo, nLin )

 Local aPrint  := {}
 Local cCabec1 := "          LINHAS UTILIZADAS             QUANTIDADE   VALOR UNITARIO      VALOR TOTAL   CUSTO FUNCIONARIO    CUSTO EMPRESA"
 Local cCabec2 := ""
 Local aTotal  := {"","",0,0,0,0,0}
 Local nX
 
 If cTipoRel == "FIL"
    aPrint  := Aclone( aResFil )
    aResFil := {}
 ElseIf cTipoRel == "EMPR"
    aPrint  := Aclone( aResEmp )
    aResEmp := {}
 EndIf
 
 nLin := 80
 For nX := 1 To Len( aPrint )
     If nLin > 58
        Cabec(Titulo,cCabec1,cCabec2,NomeProg,Tamanho,nTipo)
        nLin := 8
     EndIf     

     @ nLin,010 PSAY aPrint[nX,1]
     @ nLin,013 PSAY aPrint[nX,2]
     @ nLin,042 PSAY Str(aPrint[nX,3],6)
     @ nLin,053 PSAY Transform(aPrint[nX,4],'@E 999,999,999.99')
     @ nLin,070 PSAY Transform(aPrint[nX,5],'@E 999,999,999.99')
     @ nLin,090 PSAY Transform(aPrint[nX,6],'@E 999,999,999.99')
     @ nLin,107 PSAY Transform(aPrint[nX,7],'@E 999,999,999.99')
     nLin++
     
     aTotal[3] += aPrint[nX,3]
     aTotal[5] += aPrint[nX,5]
     aTotal[6] += aPrint[nX,6]
     aTotal[7] += aPrint[nX,7]

 Next nX
 @ nLin,042 PSAY Replicate("-",79)
 nLin++
 @ nLin,010 PSAY "TOTAIS DA " + If( cTipoRel == "FIL", "FILIAL.: " + cFilPrint, "EMPRESA.:" )
 @ nLin,042 PSAY Str(aTotal[3],6)
 @ nLin,070 PSAY Transform(aTotal[5],'@E 999,999,999.99')
 @ nLin,090 PSAY Transform(aTotal[6],'@E 999,999,999.99')
 @ nLin,107 PSAY Transform(aTotal[7],'@E 999,999,999.99')
 nLin++
 @ nLin,010 PSAY Replicate("-",111)

 nLin := 80

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVTGPER01  บAutor  ณMicrosiga           บ Data ณ  04/26/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fAtuTotais( aTotFunc, aTotCc, aTotFil, aTotEmpr )

// Monta Array com as Informacoes da Filial
If WZTB->ZTB_FILIAL # cOldFil
   fInfo( @aInfo, WZTB->ZTB_FILIAL )
   cOldFil := WZTB->ZTB_FILIAL   
   aTotFil[4]  := Alltrim( aInfo[1] ) + Space( 01 )
   aTotEmpr[4] := Alltrim( aInfo[2] ) + Space( 01 )
EndIf
// Busca Descricao do Centro de Custo
If WZTB->ZTB_CC # cOldCc
   cDescCc := fDesc("CTT", WZTB->ZTB_CC, "CTT_DESC01",25)
   cOldCc  := WZTB->ZTB_CC
   aTotCc[4] := Alltrim( cDescCc ) + Space( 01 )
EndIf

 // Totais por Funcionario
 aTotFunc[1] += WZTB->ZTB_TTVALE
 aTotFunc[2] += WZTB->ZTB_VLFUNC
 aTotFunc[3] += WZTB->ZTB_VLEMPR
 aTotFunc[5] += WZTB->ZTB_VLDIFE

 // Totais por Centro de Custo
 aTotCc[1]   += WZTB->ZTB_TTVALE
 aTotCc[2]   += WZTB->ZTB_VLFUNC
 aTotCc[3]   += WZTB->ZTB_VLEMPR
 aTotCc[5]   += WZTB->ZTB_VLDIFE

 // Totais por Filial
 aTotFil[1]  += WZTB->ZTB_TTVALE
 aTotFil[2]  += WZTB->ZTB_VLFUNC
 aTotFil[3]  += WZTB->ZTB_VLEMPR
 aTotFil[5]  += WZTB->ZTB_VLDIFE

 // Totais da Empresa
 aTotEmpr[1] += WZTB->ZTB_TTVALE
 aTotEmpr[2] += WZTB->ZTB_VLFUNC
 aTotEmpr[3] += WZTB->ZTB_VLEMPR
 aTotEmpr[5] += WZTB->ZTB_VLDIFE

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRGPEM02   บAutor  ณMicrosiga           บ Data ณ  01/25/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fGravaTxt( cLin, nHandle )

 If fWrite(nHandle,cLin,Len(cLin)) != Len(cLin)
    If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
       Return
    Endif
 Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GPCNF01  บAutor  ณMicrosiga           บ Data ณ  12/26/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fStartExcel( cNomeArq )

 If !ApOleClient( 'MsExcel' )
    MsgAlert( 'MsExcel nao instalado' )
 Else
    oExcelApp := MsExcel():New()
    oExcelApp:WorkBooks:Open( cNomeArq ) // Abre uma planilha
    oExcelApp:SetVisible(.T.)
    oExcelApp:Destroy()
 EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GPCNF01  บAutor  ณMicrosiga           บ Data ณ  12/13/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fGrvCab()

 Local cLin, nX

 SRV->(dbSetOrder( 1 ))
 
 cLin := "Filial" + cSep
 cLin += "Centro Custo" + cSep
 cLin += "Matricula" + cSep
 cLin += "Nome" + cSep
 cLin += "Periodo" + cSep
 cLin += "Codigo do Vale" + cSep
 cLin += "Descricao do Vale" + cSep
 cLin += "Dias Utilizados" + cSep
 cLin += "Total de Vales" + cSep
 cLin += "Valor Unitario" + cSep
 cLin += "Total Vale Transporte" + cSep
 cLin += "Custo do Funcionario" + cSep
 cLin += "Custo da Empresa" + cEol
 fGravaTxt( cLin, nHdl )
 
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVTGPER01  บAutor  ณMicrosiga           บ Data ณ  04/26/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fMtaQuery( dDtRef, nOrdem )

 Local cPerAtu    := MesAno( dDtRef )
 Local aStru      := ZTB->(dbStruct())

 Local cQuery, nX
 
 cQuery := "SELECT ZTB.ZTB_FILIAL,"
 cQuery += "       ZTB.ZTB_MAT,"
 cQuery += "       ZTB.ZTB_CC,"
 cQuery += "       SRA.RA_NOME     AS ZTB_NOME,"
 cQuery += "       SRA.RA_SITFOLH  AS ZTB_SITFOL,"
 cQuery += "       SRA.RA_CATFUNC  AS ZTB_CATFUN,"
 cQuery += "       SRA.RA_CIC      AS ZTB_CIC,"
 cQuery += "       ZTB.ZTB_TURNO,"
 cQuery += "       ZTB.ZTB_ESCALA,"
 cQuery += "       ZTB.ZTB_COD,"
 cQuery += "       ZTB.ZTB_DESC,"
 cQuery += "       ZTB.ZTB_DATARQ,"
 cQuery += "       ZTB.ZTB_DIACAL,"
 cQuery += "       ZTB.ZTB_QDEVAL,"
 cQuery += "       ZTB.ZTB_VLVALE,"
 cQuery += "       ZTB.ZTB_TTVALE,"
 cQuery += "       ZTB.ZTB_VLDIFE,"
 cQuery += "       ZTB.ZTB_VLFUNC,"
 cQuery += "       ZTB.ZTB_VLEMPR,"
 cQuery += "       ZTB.ZTB_PERIOD"
 cQuery += "       FROM " + RetSqlName( "ZTB" ) + " ZTB"
 cQuery += " LEFT OUTER JOIN " + RetSqlName( "SRA" ) + " SRA ON SRA.RA_FILIAL = ZTB.ZTB_FILIAL AND SRA.RA_MAT = ZTB.ZTB_MAT"
 cQuery += " LEFT OUTER JOIN " + RetSqlName( "SRN" ) + " SRN ON ZTB.ZTB_COD = SRN.RN_COD"
 cQuery += " WHERE ZTB.D_E_L_E_T_ <> '*'"
 cQuery += "   AND SRA.D_E_L_E_T_ <> '*'"
 cQuery += "   AND SRN.D_E_L_E_T_ <> '*'"
 cQuery += "   AND ZTB.ZTB_FILIAL BETWEEN '" + cFilDe  + "' AND '" + cFilAte  + "'"
 cQuery += "   AND ZTB.ZTB_MAT    BETWEEN '" + cMatDe  + "' AND '" + cMatAte  + "'"
 cQuery += "   AND ZTB.ZTB_CC     BETWEEN '" + cCcDe   + "' AND '" + cCcAte   + "'"
 cQuery += "   AND SRA.RA_NOME    BETWEEN '" + cNomeDe + "' AND '" + cNomeAte + "'"
 cQuery += "   AND SRA.RA_SITFOLH IN (" + cSit + ")"
 cQuery += "   AND SRA.RA_CATFUNC IN (" + cCat + ")"
 cQuery += "   AND ZTB.ZTB_DATARQ = '" + cPerAtu + "'"
 cQuery += "   AND ZTB.ZTB_PEDIDO IN (" + cTipPed + ")"
 cQuery += "   AND ZTB.ZTB_TTVALE > 0"
 If cTipStat == "1"			// Somente Autorizados
    cQuery += "   AND ZTB.ZTB_STATUS = '1'"
 ElseIf cTipStat == "2" 	// Somente NAO Autorizados
    cQuery += "   AND ZTB.ZTB_STATUS <> '1'"
 EndIf
 If !Empty( cPeriodo )
    cQuery += "   AND ZTB.ZTB_PERIOD = '" + cPeriodo + "'"
 EndIf
 If !Empty( dAdmDe ) .And. !Empty( dAdmAte )
    cQuery += " AND SRA.RA_ADMISSA BETWEEN '" + Dtos( dAdmDe ) + "' AND '" + Dtos( dAdmAte ) + "'"
 EndIf
 If !Empty( cCodFor )
    cQuery += " AND SRN.RN_FORN = '" + cCodFor + "'"
 EndIf
 cQuery += " ORDER BY"
 If nOrdem == 1
    cQuery += " ZTB.ZTB_FILIAL, ZTB.ZTB_MAT, ZTB_PERIOD, ZTB.ZTB_COD"
 ElseIf nOrdem == 2
    cQuery += " ZTB.ZTB_FILIAL, SRA.RA_CC, ZTB.ZTB_MAT, ZTB_PERIOD, ZTB.ZTB_COD"
 ElseIf nOrdem == 3
    cQuery += " ZTB.ZTB_FILIAL, SRA.RA_NOME, ZTB_PERIOD, ZTB.ZTB_COD"  
 EndIf
 
 cQuery := ChangeQuery( cQuery )
 TCQuery cQuery New Alias "WZTB"
 For nX := 1 To Len( aStru )
     If aStru[nX,2] <> "C"
        TcSetField( "WZTB", aStru[nX,1], aStru[nX,2], aStru[nX,3], aStru[nX,4] )
     EndIf
 Next nX
 
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfAsrPerg  บAutor  ณMicrosiga           บ Data ณ  11/21/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Perguntas do Sistema.                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fAsrPerg()

Local aRegs := {}
Local Fi    := FWSizeFilial()

 aAdd(aRegs,{ cPerg,'01','Data Referencia ?          ','','','mv_ch1','D',08,0,0,'G','NaoVazio    ','mv_par01','               ','','','','','               ','','','','','          ','','','','','            ','','','','','           ','','','','      ','' })
 aAdd(aRegs,{ cPerg,'02','Filial De ?                ','','','mv_ch2','C',Fi,0,0,'G','            ','mv_par02','               ','','','','','               ','','','','','          ','','','','','            ','','','','','           ','','','','SM0   ','' })
 aAdd(aRegs,{ cPerg,'03','Filial Ate ?               ','','','mv_ch3','C',Fi,0,0,'G','NaoVazio    ','mv_par03','               ','','','','','               ','','','','','          ','','','','','            ','','','','','           ','','','','SM0   ','' })
 aAdd(aRegs,{ cPerg,'04','Matricula De ?             ','','','mv_ch4','C',06,0,0,'G','            ','mv_par04','               ','','','','','               ','','','','','          ','','','','','            ','','','','','           ','','','','SRA   ','' })
 aAdd(aRegs,{ cPerg,'05','Matricula Ate ?            ','','','mv_ch5','C',06,0,0,'G','NaoVazio    ','mv_par05','               ','','','','','               ','','','','','          ','','','','','            ','','','','','           ','','','','SRA   ','' })
 aAdd(aRegs,{ cPerg,'06','Centro Custo De ?          ','','','mv_ch6','C',20,0,0,'G','            ','mv_par06','               ','','','','','               ','','','','','          ','','','','','            ','','','','','           ','','','','CTT   ','' })
 aAdd(aRegs,{ cPerg,'07','Centro Custo Ate ?         ','','','mv_ch7','C',20,0,0,'G','NaoVazio    ','mv_par07','               ','','','','','               ','','','','','          ','','','','','            ','','','','','           ','','','','CTT   ','' })
 aAdd(aRegs,{ cPerg,'08','Nome De ?                  ','','','mv_ch8','C',30,0,0,'G','            ','mv_par08','               ','','','','','               ','','','','','          ','','','','','            ','','','','','           ','','','','      ','' })
 aAdd(aRegs,{ cPerg,'09','Nome Ate ?                 ','','','mv_ch9','C',30,0,0,'G','NaoVazio    ','mv_par09','               ','','','','','               ','','','','','          ','','','','','            ','','','','','           ','','','','      ','' })
 aAdd(aRegs,{ cPerg,'10','Admissao De ?              ','','','mv_cha','D',08,0,0,'G','            ','mv_par10','               ','','','','','               ','','','','','          ','','','','','            ','','','','','           ','','','','      ','' })
 aAdd(aRegs,{ cPerg,'11','Admissao Ate ?             ','','','mv_chb','D',08,0,0,'G','            ','mv_par11','               ','','','','','               ','','','','','          ','','','','','            ','','','','','           ','','','','      ','' })
 aAdd(aRegs,{ cPerg,'12','Situacoes ?                ','','','mv_chc','C',05,0,0,'G','fSituacao   ','mv_par12','               ','','','','','               ','','','','','          ','','','','','            ','','','','','           ','','','','      ','' })
 aAdd(aRegs,{ cPerg,'13','Categorias ?               ','','','mv_chd','C',12,0,0,'G','fCategoria  ','mv_par13','               ','','','','','               ','','','','','          ','','','','','            ','','','','','           ','','','','      ','' })
 aAdd(aRegs,{ cPerg,'14','Periodo a Imprimir  ?      ','','','mv_che','C',01,0,0,'G','U_fBnfPer(2)','mv_par14','               ','','','','','               ','','','','','          ','','','','','            ','','','','','           ','','','','      ','' })
 aAdd(aRegs,{ cPerg,'15','Total do Funcionario ?     ','','','mv_chf','N',01,0,0,'C','            ','mv_par15','Sim            ','','','','','Nao            ','','','','','          ','','','','','            ','','','','','           ','','','','      ','' })
 aAdd(aRegs,{ cPerg,'16','Quebra p/ C Custo ?        ','','','mv_chg','N',01,0,0,'C','            ','mv_par16','Sim            ','','','','','Nao            ','','','','','          ','','','','','            ','','','','','           ','','','','      ','' })
 aAdd(aRegs,{ cPerg,'17','Gerar Planilha Excel ?     ','','','mv_chh','N',01,0,0,'C','            ','mv_par17','Sim            ','','','','','Nao            ','','','','','          ','','','','','            ','','','','','           ','','','','      ','' })
 aAdd(aRegs,{ cPerg,'18','Gerar para Fornecedor ?    ','','','mv_chi','C',03,0,0,'G','            ','mv_par18','               ','','','','','               ','','','','','          ','','','','','            ','','','','','           ','','','','ZT9001','' })
 aAdd(aRegs,{ cPerg,'19','Gerar Tipo do Pedido  ?    ','','','mv_chj','C',06,0,0,'G','U_fTipPed() ','mv_par19','               ','','','','','               ','','','','','          ','','','','','            ','','','','','           ','','','','      ','' })
 aAdd(aRegs,{ cPerg,'20','Gerar com Status ?         ','','','mv_chk','N',01,0,0,'C','            ','mv_par20','Autorizados    ','','','','','Nao Autorizados','','','','','Todos     ','','','','','            ','','','','','           ','','','','      ','' })
 //aAdd(aRegs,{ cPerg,'18','Tipo do Processamento ?    ','','','mv_chi','N',01,0,0,'C','            ','mv_par18','Compra         ','','','','','Pagto Folha    ','','','','','Pagto Adto','','','','','Todos       ','','','','','           ','','','','      ','' })
 U_fDelSx1( cPerg, "21" )

ValidPerg(aRegs,cPerg)

Return

//         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
//1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//FILIAL   C CUSTO    MAT     NOME                            CPF          TURNO  ESCALA  COD  DESCR VALE                 DIAS   TOTAL           VALOR         TOTAL         TOTAL        VALOR          PARTE
//                                                                                                                        VALE  DE VALES      UNITARIO     DOS VALES    DIFERENCAS      DESCONTO       EMPRESA
//0000000  000000000  000000  123456789012345678901234567890  12345678901   000     00    00   1234567890123456789012345   99     9999    9,999,999.99  9,999,999.99  9,999,999.99  9,999,999.99  9,999,999.99
//


//         1         2         3         4         5         6         7         8         9        10        11        12        13
//1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//         LINHAS UTILIZADAS             QUANTIDADE   VALOR UNITARIO      VALOR TOTAL   CUSTO FUNCIONARIO    CUSTO EMPRESA
//         01 1234567890123456789012345    000000     999,999,999.99   999,999,999.99      999,999,999.99   999,999,999.99

