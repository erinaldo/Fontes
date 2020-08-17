#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#DEFINE          cEol         CHR(13)+CHR(10)
#DEFINE          cSep         ";"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VAGPER01 บ Autor ณ Adilson Silva      บ Data ณ 02/02/2011  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Mapa do Vale Alimentacao.                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function VAGPER01()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Mapa Vale Refeicao/Alimentacao"
Local cPict          := ""
Local titulo         := "MAPA DO VALE"
Local nLin           := 80
Local Cabec1         := " FILIAL   C CUSTO    MAT     NOME                            CPF          TURNO  ESCALA  COD    DESCR VALE                 DIAS         VALOR         TOTAL         VALOR         PARTE"
Local Cabec2         := "                                                                                                                           VALE      UNITARIO     DOS VALES      DESCONTO       EMPRESA"
Local imprime        := .T.

Private aOrd         := { "Matricula", "Centro de Custo", "Nome" } 
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "VAGPER01"
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "VAGPER01"
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "VAGPER01"
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
Private nTipBen, cCodFor

Private aTotFunc, aTotCc, aTotFil, aTotEmpr
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
 nTipBen   := mv_par18			// 1=Refeicao - 2=Alimentacao
 cCodFor   := mv_par19

lTotCc   := .T.
lTotFil  := .T.
lTotEmpr := .T.
 
Titulo  := Alltrim( Titulo ) + If(nTipBen==1," REFEICAO"," ALIMENTACAO")
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
cChaveMat := "@@"
cChaveCc  := "@@"
cChaveFil := "@@"
aInfo     := {}
cDescCc   := ""

// Grava Cabecalho do Arquivo Texto
fGrvCab()

dbSelectArea( "WZT7" )
Count To nTotReg
If nTotReg = 0
   Aviso("ATENCAO","Nao Existem Dados para Este Relatorio",{"Sair"})
   WZT7->(dbCloseArea())
   Return
EndIf
dbGoTop()
SetRegua( nTotReg )

If nOrdem == 1
   cChaveMat := WZT7->(ZT7_FILIAL + ZT7_MAT)
   cChaveFil := WZT7->ZT7_FILIAL
ElseIf nOrdem == 2
   cChaveMat := WZT7->(ZT7_FILIAL + ZT7_CC + ZT7_MAT)
   cChaveCc  := WZT7->(ZT7_FILIAL + ZT7_CC)
   cChaveFil := WZT7->ZT7_FILIAL
ElseIf nOrdem == 3
   cChaveMat := WZT7->(ZT7_FILIAL + ZT7_NOME)
   cChaveFil := WZT7->ZT7_FILIAL
EndIf
cOldFil  := "@@"
cOldCc   := "@@"
cChavQde := "@@"
Do While !Eof()
   IncRegua()
   
   If nLin > 55
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 9
   Endif

   CTT->(dbSeek( xFilial("CTT") + WZT7->ZT7_CC ))
   SRA->(dbSeek( WZT7->(ZT7_FILIAL + ZT7_MAT) ))
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
      @ nLin,001 PSAY WZT7->ZT7_FILIAL
      @ nLin,010 PSAY Left(WZT7->ZT7_CC,9)
      @ nLin,021 PSAY WZT7->ZT7_MAT
      @ nLin,029 PSAY Left(WZT7->ZT7_NOME,30)
      @ nLin,061 PSAY WZT7->ZT7_CIC
      @ nLin,075 PSAY WZT7->ZT7_TURNO
      @ nLin,083 PSAY WZT7->ZT7_ESCALA
      lFirst := .F.
   EndIf
   @ nLin,089 PSAY WZT7->ZT7_COD + "-" + WZT7->ZT7_PERIOD
   @ nLin,096 PSAY WZT7->ZT7_DESC
   @ nLin,124 PSAY StrZero( WZT7->ZT7_DIACAL,2 )
   @ nLin,129 PSAY Transform(WZT7->ZT7_VLVALE,'@E 9,999,999.99')
   @ nLin,143 PSAY Transform(WZT7->ZT7_TTVALE,'@E 9,999,999.99')
   @ nLin,157 PSAY Transform(WZT7->ZT7_VLFUNC,'@E 9,999,999.99')
   @ nLin,171 PSAY Transform(WZT7->ZT7_VLEMPR,'@E 9,999,999.99')
   nLin++

   If lExcel
      cLin := '="' + WZT7->ZT7_FILIAL + '"' + cSep
      cLin += '="' + Alltrim(WZT7->ZT7_CC) + '"' + cSep
      cLin += '="' + WZT7->ZT7_MAT + '"' + cSep
      cLin += WZT7->ZT7_NOME + cSep
      cLin += '="' + WZT7->ZT7_PERIOD + '"' + cSep
      cLin += '="' + WZT7->ZT7_COD + '"' + cSep
      cLin += WZT7->ZT7_DESC + cSep
      cLin += StrZero( WZT7->ZT7_DIACAL,2 ) + cSep
      cLin += Transform(WZT7->ZT7_VLVALE,'@E 999,999.99') + cSep
      cLin += Transform(WZT7->ZT7_TTVALE,'@E 999,999.99') + cSep
      cLin += Transform(WZT7->ZT7_VLFUNC,'@E 999,999.99') + cSep
      cLin += Transform(WZT7->ZT7_VLEMPR,'@E 999,999.99') + cEol
      fGravaTxt( cLin, nHdl )
   EndIf

   // Atualiza Totalizadores do Relatorio
   fAtuTotais( @aTotFunc, @aTotCc, @aTotFil, @aTotEmpr )
   If cChavQde <> WZT7->(ZT7_FILIAL + ZT7_MAT)
      cChavQde := WZT7->(ZT7_FILIAL + ZT7_MAT)
      aTotCc[6]++
      aTotFil[6]++
      aTotEmpr[6]++
   EndIf
		
   dbSkip()

   If nOrdem == 1
      If WZT7->(ZT7_FILIAL + ZT7_MAT) # cChaveMat
         cChaveMat := WZT7->(ZT7_FILIAL + ZT7_MAT)
         fPrintTotais( "FUNC", @nLin )
         lFirst := .T.
      EndIf
      If WZT7->ZT7_FILIAL # cChaveFil
         cChaveFil := WZT7->ZT7_FILIAL
         fPrintTotais( "FIL", @nLin )
         lFirst := .T.
      EndIf
   ElseIf nOrdem == 2
      If WZT7->(ZT7_FILIAL + ZT7_CC + ZT7_MAT) # cChaveMat
         cChaveMat := WZT7->(ZT7_FILIAL + ZT7_CC + ZT7_MAT)
         fPrintTotais( "FUNC", @nLin )
         lFirst := .T.
      EndIf
      If WZT7->(ZT7_FILIAL + ZT7_CC) # cChaveCc
         cChaveCc := WZT7->(ZT7_FILIAL + ZT7_CC)
         fPrintTotais( "CC", @nLin )
         lFirst := .T.
      EndIf
      If WZT7->ZT7_FILIAL # cChaveFil
         cChaveFil := WZT7->ZT7_FILIAL
         fPrintTotais( "FIL", @nLin )
         lFirst := .T.
      EndIf
   ElseIf nOrdem == 3
      If WZT7->(ZT7_FILIAL + ZT7_NOME) # cChaveMat
         cChaveMat := WZT7->(ZT7_FILIAL + ZT7_NOME)
         fPrintTotais( "FUNC", @nLin )
         lFirst := .T.
      EndIf
      If WZT7->ZT7_FILIAL # cChaveFil
         cChaveFil := WZT7->ZT7_FILIAL
         fPrintTotais( "FIL", @nLin )
         lFirst := .T.
      EndIf
   EndIf     
   
   If Eof()
      fPrintTotais( "EMPR", @nLin )
   EndIf

EndDo 
WZT7->(dbCloseArea())  
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
ฑฑบPrograma  ณVAGPER01  บAutor  ณMicrosiga           บ Data ณ  04/26/07   บฑฑ
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
    @ nLin,143 PSAY Transform(aTotFunc[1],'@E 9,999,999.99')
    @ nLin,157 PSAY Transform(aTotFunc[2],'@E 9,999,999.99')
    @ nLin,171 PSAY Transform(aTotFunc[3],'@E 9,999,999.99')
    aTotFunc := {0,0,0,"",0,0}
    nLin++
    @ nLin,014 PSAY Replicate("-",197)
 ElseIf cQual == "CC" .And. lTotCc
    @ nLin,066 PSAY Left( "-> Total C de Custo " + aTotCc[4] + Replicate("_",40),40 )
    @ nLin,108 PSAY Str(aTotCc[6],6) + "(F)"
    @ nLin,143 PSAY Transform(aTotCc[1],'@E 9,999,999.99')
    @ nLin,157 PSAY Transform(aTotCc[2],'@E 9,999,999.99')
    @ nLin,171 PSAY Transform(aTotCc[3],'@E 9,999,999.99')
    aTotCc    := {0,0,0,"",0,0}
    nLin++
    @ nLin,001 PSAY Replicate("-",210)
    If lQuebra .And. !(WZT7->(Eof()))
       nLin := 80
    EndIf
 ElseIf cQual == "FIL" .And. lTotFil
    @ nLin,066 PSAY Left( "-> Total da Filial " + aTotFil[4] + Replicate("_",40),40 )
    @ nLin,108 PSAY Str(aTotFil[6],6) + "(F)"
    @ nLin,143 PSAY Transform(aTotFil[1],'@E 9,999,999.99')
    @ nLin,157 PSAY Transform(aTotFil[2],'@E 9,999,999.99')
    @ nLin,171 PSAY Transform(aTotFil[3],'@E 9,999,999.99')
    aTotFil   := {0,0,0,"",0,0}
    nLin++
    @ nLin,001 PSAY Replicate("-",210)
    If lQuebra .And. !(WZT7->(Eof()))
       nLin := 80
    EndIf
 ElseIf cQual == "EMPR" .And. lTotEmpr
    @ nLin,066 PSAY Left( "-> Total da Empresa " + aTotEmpr[4] + Replicate("_",40),40 )
    @ nLin,108 PSAY Str(aTotEmpr[6],6) + "(F)"
    @ nLin,143 PSAY Transform(aTotEmpr[1],'@E 9,999,999.99')
    @ nLin,157 PSAY Transform(aTotEmpr[2],'@E 9,999,999.99')
    @ nLin,171 PSAY Transform(aTotEmpr[3],'@E 9,999,999.99')
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
ฑฑบPrograma  ณVAGPER01  บAutor  ณMicrosiga           บ Data ณ  04/26/07   บฑฑ
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
If WZT7->ZT7_FILIAL # cOldFil
   fInfo( @aInfo, WZT7->ZT7_FILIAL )
   cOldFil := WZT7->ZT7_FILIAL   
   aTotFil[4]  := Alltrim( aInfo[1] ) + Space( 01 )
   aTotEmpr[4] := Alltrim( aInfo[2] ) + Space( 01 )
EndIf
// Busca Descricao do Centro de Custo
If WZT7->ZT7_CC # cOldCc
   cDescCc := fDesc("CTT", WZT7->ZT7_CC, "CTT_DESC01",25)
   cOldCc  := WZT7->ZT7_CC
   aTotCc[4] := Alltrim( cDescCc ) + Space( 01 )
EndIf

 // Totais por Funcionario
 aTotFunc[1] += WZT7->ZT7_TTVALE
 aTotFunc[2] += WZT7->ZT7_VLFUNC
 aTotFunc[3] += WZT7->ZT7_VLEMPR

 // Totais por Centro de Custo
 aTotCc[1]   += WZT7->ZT7_TTVALE
 aTotCc[2]   += WZT7->ZT7_VLFUNC
 aTotCc[3]   += WZT7->ZT7_VLEMPR

 // Totais por Filial
 aTotFil[1]  += WZT7->ZT7_TTVALE
 aTotFil[2]  += WZT7->ZT7_VLFUNC
 aTotFil[3]  += WZT7->ZT7_VLEMPR

 // Totais da Empresa
 aTotEmpr[1] += WZT7->ZT7_TTVALE
 aTotEmpr[2] += WZT7->ZT7_VLFUNC
 aTotEmpr[3] += WZT7->ZT7_VLEMPR

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
 cLin += "Valor Unitario" + cSep
 cLin += "Valor Total Beneficio" + cSep
 cLin += "Custo do Funcionario" + cSep
 cLin += "Custo da Empresa" + cEol
 fGravaTxt( cLin, nHdl )
 
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
ฑฑบPrograma  ณVAGPER01  บAutor  ณMicrosiga           บ Data ณ  04/26/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fMtaQuery( dDtRef, nOrdem )

 Local cPerAtu := MesAno( dDtRef )
 Local aStru   := ZT7->(dbStruct())

 Local cQuery, nX
 
 cQuery := "SELECT ZT7.ZT7_FILIAL,"
 cQuery += "       ZT7.ZT7_MAT,"
 cQuery += "       ZT7.ZT7_CC,"
 cQuery += "       SRA.RA_NOME     AS ZT7_NOME,"
 cQuery += "       SRA.RA_SITFOLH  AS ZT7_SITFOL,"
 cQuery += "       SRA.RA_CATFUNC  AS ZT7_CATFUN,"
 cQuery += "       SRA.RA_CIC      AS ZT7_CIC,"
 cQuery += "       ZT7.ZT7_TURNO,"
 cQuery += "       ZT7.ZT7_ESCALA,"
 cQuery += "       ZT7.ZT7_COD,"
 cQuery += "       ZT7.ZT7_DESC,"
 cQuery += "       ZT7.ZT7_DATARQ,"
 cQuery += "       ZT7.ZT7_DIACAL,"
 cQuery += "       ZT7.ZT7_VLVALE,"
 cQuery += "       ZT7.ZT7_TTVALE,"
 cQuery += "       ZT7.ZT7_VLFUNC,"
 cQuery += "       ZT7.ZT7_VLEMPR,"
 cQuery += "       ZT7.ZT7_PERIOD"
 cQuery += "       FROM " + RetSqlName( "ZT7" ) + " ZT7"
 cQuery += " LEFT OUTER JOIN " + RetSqlName( "SRA" ) + " SRA ON SRA.RA_FILIAL = ZT7.ZT7_FILIAL AND SRA.RA_MAT = ZT7.ZT7_MAT"
 cQuery += " LEFT OUTER JOIN " + RetSqlName( "ZT8" ) + " ZT8 ON ZT7.ZT7_COD = ZT8.ZT8_COD"
 cQuery += " WHERE ZT7.D_E_L_E_T_ <> '*'"
 cQuery += "   AND SRA.D_E_L_E_T_ <> '*'"
 cQuery += "   AND ZT8.D_E_L_E_T_ <> '*'"
 cQuery += "   AND ZT7.ZT7_FILIAL BETWEEN '" + cFilDe  + "' AND '" + cFilAte  + "'"
 cQuery += "   AND ZT7.ZT7_MAT    BETWEEN '" + cMatDe  + "' AND '" + cMatAte  + "'"
 cQuery += "   AND ZT7.ZT7_CC     BETWEEN '" + cCcDe   + "' AND '" + cCcAte   + "'"
 cQuery += "   AND SRA.RA_NOME    BETWEEN '" + cNomeDe + "' AND '" + cNomeAte + "'"
 cQuery += "   AND SRA.RA_SITFOLH IN (" + cSit + ")"
 cQuery += "   AND SRA.RA_CATFUNC IN (" + cCat + ")"
 cQuery += "   AND ZT7.ZT7_DATARQ = '" + cPerAtu + "'"
 cQuery += "   AND ZT7.ZT7_TTVALE > 0"
 cQuery += "   AND ZT7.ZT7_TIPO = '" + Str(nTipBen,1) + "'"
 If !Empty( cPeriodo )
    cQuery += "   AND ZT7.ZT7_PERIOD = '" + cPeriodo + "'"
 EndIf
 If !Empty( dAdmDe ) .And. !Empty( dAdmAte )
    cQuery += " AND SRA.RA_ADMISSA BETWEEN '" + Dtos( dAdmDe ) + "' AND '" + Dtos( dAdmAte ) + "'"
 EndIf
 If !Empty( cCodFor )
    cQuery += " AND ZT8.ZT8_FORN = '" + cCodFor + "'"
 EndIf
 cQuery += " ORDER BY"
 If nOrdem == 1
    cQuery += " ZT7.ZT7_FILIAL, ZT7.ZT7_MAT, ZT7_PERIOD, ZT7.ZT7_COD"
 ElseIf nOrdem == 2
    cQuery += " ZT7.ZT7_FILIAL, SRA.RA_CC, ZT7.ZT7_MAT, ZT7_PERIOD, ZT7.ZT7_COD"
 ElseIf nOrdem == 3
    cQuery += " ZT7.ZT7_FILIAL, SRA.RA_NOME, ZT7_PERIOD, ZT7.ZT7_COD"  
 EndIf
 
 cQuery := ChangeQuery( cQuery )
 TCQuery cQuery New Alias "WZT7"
 For nX := 1 To Len( aStru )
     If aStru[nX,2] <> "C"
        TcSetField( "WZT7", aStru[nX,1], aStru[nX,2], aStru[nX,3], aStru[nX,4] )
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
Local Fi    := If(cVersao=="10",2,FWSizeFilial())

 aAdd(aRegs,{ cPerg,'01','Data Referencia ?          ','','','mv_ch1','D',08,0,0,'G','NaoVazio    ','mv_par01','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
 aAdd(aRegs,{ cPerg,'02','Filial De ?                ','','','mv_ch2','C',Fi,0,0,'G','            ','mv_par02','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SM0   ','' })
 aAdd(aRegs,{ cPerg,'03','Filial Ate ?               ','','','mv_ch3','C',Fi,0,0,'G','NaoVazio    ','mv_par03','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SM0   ','' })
 aAdd(aRegs,{ cPerg,'04','Matricula De ?             ','','','mv_ch4','C',06,0,0,'G','            ','mv_par04','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SRA   ','' })
 aAdd(aRegs,{ cPerg,'05','Matricula Ate ?            ','','','mv_ch5','C',06,0,0,'G','NaoVazio    ','mv_par05','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SRA   ','' })
 aAdd(aRegs,{ cPerg,'06','Centro Custo De ?          ','','','mv_ch6','C',20,0,0,'G','            ','mv_par06','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','CTT   ','' })
 aAdd(aRegs,{ cPerg,'07','Centro Custo Ate ?         ','','','mv_ch7','C',20,0,0,'G','NaoVazio    ','mv_par07','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','CTT   ','' })
 aAdd(aRegs,{ cPerg,'08','Nome De ?                  ','','','mv_ch8','C',30,0,0,'G','            ','mv_par08','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
 aAdd(aRegs,{ cPerg,'09','Nome Ate ?                 ','','','mv_ch9','C',30,0,0,'G','NaoVazio    ','mv_par09','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
 aAdd(aRegs,{ cPerg,'10','Admissao De ?              ','','','mv_cha','D',08,0,0,'G','            ','mv_par10','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
 aAdd(aRegs,{ cPerg,'11','Admissao Ate ?             ','','','mv_chb','D',08,0,0,'G','            ','mv_par11','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
 aAdd(aRegs,{ cPerg,'12','Situacoes ?                ','','','mv_chc','C',05,0,0,'G','fSituacao   ','mv_par12','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
 aAdd(aRegs,{ cPerg,'13','Categorias ?               ','','','mv_chd','C',12,0,0,'G','fCategoria  ','mv_par13','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
 aAdd(aRegs,{ cPerg,'14','Periodo a Imprimir  ?      ','','','mv_che','C',01,0,0,'G','U_fBnfPer(2)','mv_par14','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
 aAdd(aRegs,{ cPerg,'15','Total do Funcionario ?     ','','','mv_chf','N',01,0,0,'C','            ','mv_par15','Sim            ','','','','','Nao        ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
 aAdd(aRegs,{ cPerg,'16','Quebra p/ C Custo ?        ','','','mv_chg','N',01,0,0,'C','            ','mv_par16','Sim            ','','','','','Nao        ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
 aAdd(aRegs,{ cPerg,'17','Gerar Planilha Excel ?     ','','','mv_chh','N',01,0,0,'C','            ','mv_par17','Sim            ','','','','','Nao        ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
 aAdd(aRegs,{ cPerg,'18','Gerar Beneficio ?          ','','','mv_chi','N',01,0,0,'C','            ','mv_par18','Refeicao       ','','','','','Alimentacao','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
 aAdd(aRegs,{ cPerg,'19','Gerar para Fornecedor ?    ','','','mv_chj','C',03,0,0,'G','            ','mv_par19','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','ZT9001','' })
 U_fDelSx1( cPerg, "20" )

ValidPerg(aRegs,cPerg)

Return

//         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
//1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//FILIAL   C CUSTO    MAT     NOME                            CPF          TURNO  ESCALA  COD    DESCR VALE                 DIAS         VALOR         TOTAL         VALOR         PARTE
//                                                                                                                          VALE      UNITARIO     DOS VALES      DESCONTO       EMPRESA
//0000000  000000000  000000  123456789012345678901234567890  12345678901   000     00    000    1234567890123456789012345   99   9,999,999.99  9,999,999.99  9,999,999.99  9,999,999.99
//
