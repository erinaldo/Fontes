#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#DEFINE          cSep         ";"
#DEFINE          cEol         CHR(13)+CHR(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CSGPEM20 บ Autor ณ Adilson Silva      บ Data ณ 27/02/2014  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Geracao de Planilha em Excel com Informacoes das Ferias    บฑฑ
ฑฑบ          ณ Calculadas.                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CSGPEM20()	// U_CSGPEM20()

 Local bProcesso := {|oSelf| fProcessa( oSelf )}

 Private cCadastro  := "Exportar F้rias Calculadas"
 Private cPerg      := "CSGPEM20"
 Private cStartPath := GetSrvProfString("StartPath","")
 Private cDescricao

 fAsrPerg()
 Pergunte(cPerg,.F.)

 cDescricao := "Esta rotina irแ gerar arquivo em Excel com informa็๕es das F้rias Calculadas."

 tNewProcess():New( "SRA" , cCadastro , bProcesso , cDescricao , cPerg,,,,,.T.,.T. ) 	

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

Local lSetCentury := __SetCentury( "on" )
Local cPath       := AllTrim( GetTempPath() )
Local cArquivo    := ""
Local nTotReg     := 0
Local cPdFerias   := "@@@"
Local cPd13oSal   := "@@@"
Local cLin

Private cFilDe, cFilAte
Private cMatDe, cMatAte
Private cCcDe, cCcAte
Private dFerDe, dFerAte

Private nHdl

Pergunte(cPerg,.F.)
 cFilDe   := mv_par01
 cFilAte  := mv_par02
 cMatDe   := mv_par03
 cMatAte  := mv_par04
 cCcDe    := mv_par05
 cCcAte   := mv_par06
 dFerDe   := mv_par07
 dFerAte  := mv_par08

// Cria Arquivo Texto
cArquivo := CriaTrab(,.F.) + ".csv"
cPath    := cPath + If(Right(cPath,1) <> "\","\","")
cArquivo := cPath + cArquivo
nHdl  := fCreate( cArquivo )
If nHdl == -1
   MsgAlert("O arquivo de nome "+cArquivo+" nao pode ser executado! Verifique os parametros.","Atencao!")
   Return
EndIf
SRA->(dbSetOrder( 1 ))
SRR->(dbSetOrder( 1 ))
SRV->(dbSetOrder( 2 ))
CTT->(dbSetOrder( 1 ))
CTH->(dbSetOrder( 1 ))

// Deterimina a Verba do Liquido de Ferias
SRV->(dbSeek( RhFilial("SRV",cFilAnt) + "0102" ))
cPdFerias := SRV->RV_COD
// Deterimina a Verba do 13o Salario
SRV->(dbSeek( RhFilial("SRV",cFilAnt) + "0022" ))
cPd13oSal := SRV->RV_COD

SRV->(dbSetOrder( 1 ))

// Monta Query Principal
MsAguarde( {|| fMtaQuery()}, "Processando...", "Selecionado Registros no Banco de Dados..." )

dbSelectArea( "WSRH" )
Count To nTotReg
If nTotReg <= 0
   Aviso("ATENCAO","Nao Existem Dados para Este Relatorio",{"Sair"})
   WSRH->(dbCloseArea())
   Return
EndIf
dbGoTop()
oSelf:SetRegua1( nTotReg )

fCabec()

Do While !Eof()
   SRH->(dbGoTo( WSRH->RH_RECNO ))
   SRA->(dbSeek( SRH->(RH_FILIAL + RH_MAT) ))
   CTT->(dbSeek( RhFilial("CTT",SRA->RA_FILIAL) + SRA->RA_CC ))
   CTH->(dbSeek( RhFilial("CTH",SRA->RA_FILIAL) + SRA->RA_CLVLDB ))
   
   oSelf:IncRegua1( SRA->(RA_FILIAL + " - " + RA_MAT + " - " + RA_NOME) )
   If oSelf:lEnd 
      Exit
   EndIf
   
   cLin := '="' + SRA->RA_FILIAL + '"' + cSep										// 01 - Filial
   cLin += '="' + SRA->RA_MAT + '"' + cSep											// 02 - Matricula
   cLin += Alltrim( SRA->RA_NOME ) + cSep											// 03 - Nome
   cLin += '="' + SRA->RA_CIC + '"' + cSep											// 04 - CPF
   cLin += '="' + Alltrim( SRA->RA_CC ) + '"' + cSep								// 05 - Centro de Custo
   cLin += Alltrim( CTT->CTT_DESC01 ) + cSep										// 06 - Descricao do Centro de Custo
   cLin += '="' + Alltrim( SRA->RA_CLVLDB ) + '"' + cSep							// 07 - Codigo Operacao (Classe de Valor)
   cLin += Alltrim( CTH->CTH_DESC01 ) + cSep										// 08 - Descricao da Operacao
   cLin += '="' + Left(SRA->RA_BCDEPSA,3) + '"' + cSep								// 09 - Codigo Banco Deposito de Salario
   cLin += '="' + Alltrim( Right(SRA->RA_BCDEPSA,5) ) + '"' + cSep					// 10 - Codigo Agencia Deposito de Salario
   cLin += '="' + Alltrim( SRA->RA_CTDEPSA ) + '"' + cSep							// 11 - Codigo da Conta Corrente
   cLin += Str(SRH->RH_DFERIAS,3) + cSep											// 12 - Dias de Ferias
   cLin += Str(SRH->RH_DABONPE,3) + cSep											// 13 - Dias de Abono Pecuniario
   cLin += Transform(SRH->RH_PERC13S,'@E 999.99') + cSep							// 14 - Percentual do Adiantamento 13o Salario
   cLin += Dtoc(SRH->RH_DATAINI) + cSep												// 15 - Data de Inicio das Ferias
   cLin += Dtoc(SRH->RH_DATAFIM) + cSep												// 16 - Data do Termino das Ferias
   cLin += Dtoc(SRH->RH_DTRECIB) + cSep												// 17 - Data do Pagamento das Ferias
   cLin += Transform(fValFerias( cPdFerias ),'@E 999999999.99') + cSep				// 18 - Liquido das Ferias
   cLin += Transform(fValFerias( cPd13oSal ),'@E 999999999.99') + cSep				// 19 - Valor do 13o Salario
   cLin += cEol
   fGravaTxt( cLin )
   		
   dbSelectArea( "WSRH" )
   dbSkip()
EndDo
If !lSetCentury
   __SetCentury( "off" )
EndIf

WSRH->(dbCloseArea())  
fClose( nHdl )

MsAguarde( {|| fStartExcel( cArquivo )}, "Aguarde...", "Integrando Planilha ao Excel..." )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCSGPEM20  บAutor  ณMicrosiga           บ Data ณ  02/28/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP11                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fValFerias( cVerba )

 Local aOldAtu := GETAREA()
 Local nRet    := 0
 
 // Indice - RR_FILIAL+RR_MAT+RR_TIPO3+DTOS(RR_DATA)+RR_PD+RR_CC
 If SRR->(dbSeek( SRA->(RA_FILIAL + RA_MAT) + "F" + Dtos( SRH->RH_DTRECIB ) + cVerba ))
    nRet := SRR->RR_VALOR
 EndIf

 RESTAREA( aOldAtu )
 
Return( nRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCSGPEM20  บAutor  ณMicrosiga           บ Data ณ  02/28/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP11                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fCabec()

 Local cLin

 cLin := "Filial" + cSep
 cLin += "Matricula" + cSep
 cLin += "Nome" + cSep
 cLin += "CPF" + cSep
 cLin += "Centro de Custo" + cSep
 cLin += "Desc Centro de Custo" + cSep
 cLin += "Codigo Operacao" + cSep
 cLin += "Descricao Operacao" + cSep
 cLin += "Banco" + cSep
 cLin += "Agencia" + cSep
 cLin += "Conta Corrente" + cSep
 cLin += "Dias Ferias" + cSep
 cLin += "Dias Abono Pecuniario" + cSep
 cLin += "Perc 13o Salario" + cSep
 cLin += "Inicio das Ferias" + cSep
 cLin += "Termino das Ferias" + cSep
 cLin += "Data do Pagamento" + cSep
 cLin += "Liquido de Ferias" + cSep
 cLin += "Valor 13o Salario" + cSep
 cLin += cEol
 fGravaTxt( cLin )

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
ฑฑบPrograma  ณRGPEM02   บAutor  ณMicrosiga           บ Data ณ  01/25/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fGravaTxt( cLin )

 If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
    If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
       Return
    Endif
 Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCSGPEM20  บAutor  ณMicrosiga           บ Data ณ  04/26/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fMtaQuery()

 Local cQuery := ""
 
 cQuery += " SELECT SRH.RH_FILIAL,"
 cQuery += "        SRH.RH_MAT,"
 cQuery += "        SRH.R_E_C_N_O_ AS RH_RECNO"
 cQuery += " FROM " + RetSqlName( "SRH" ) + " SRH"
 cQuery += " LEFT OUTER JOIN " + RetSqlName( "SRA" ) + " SRA ON SRH.RH_FILIAL = SRA.RA_FILIAL AND SRH.RH_MAT = SRA.RA_MAT"
 cQuery += " WHERE SRH.D_E_L_E_T_ <> '*'"
 cQuery += "   AND SRA.D_E_L_E_T_ <> '*'"
 cQuery += "   AND SRH.RH_FILIAL  BETWEEN '" + cFilDe  + "' AND '" + cFilAte  + "'"
 cQuery += "   AND SRH.RH_MAT     BETWEEN '" + cMatDe  + "' AND '" + cMatAte  + "'"
 cQuery += "   AND SRA.RA_CC      BETWEEN '" + cCcDe   + "' AND '" + cCcAte   + "'"
 cQuery += "   AND SRH.RH_DATAINI BETWEEN '" + Dtos( dFerDe ) + "' AND '" + Dtos( dFerAte ) + "'"
 cQuery += " ORDER BY SRH.RH_FILIAL, SRH.RH_MAT"

 cQuery := ChangeQuery( cQuery )
 TCQuery cQuery New Alias "WSRH"
 TcSetField( "WSRH" , "RH_RECNO"   , "N", 08, 0 )
 
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

 // Verifica a Criacao do Grupo de Consultas F3
 U_fUPath()

 aAdd(aRegs,{ cPerg,'01','Filial De ?              ','','','mv_ch1','C',Fi,0,0,'G','           ','mv_par01','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SM0   ','' })
 aAdd(aRegs,{ cPerg,'02','Filial Ate ?             ','','','mv_ch2','C',Fi,0,0,'G','NaoVazio   ','mv_par02','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SM0   ','' })
 aAdd(aRegs,{ cPerg,'03','Matricula De ?           ','','','mv_ch3','C',06,0,0,'G','           ','mv_par03','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SRA   ','' })
 aAdd(aRegs,{ cPerg,'04','Matricula Ate ?          ','','','mv_ch4','C',06,0,0,'G','NaoVazio   ','mv_par04','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SRA   ','' })
 aAdd(aRegs,{ cPerg,'05','Centro Custo De ?        ','','','mv_ch5','C',20,0,0,'G','           ','mv_par05','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','CTT   ','' })
 aAdd(aRegs,{ cPerg,'06','Centro Custo Ate ?       ','','','mv_ch6','C',20,0,0,'G','NaoVazio   ','mv_par06','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','CTT   ','' })
 aAdd(aRegs,{ cPerg,'07','Periodo Ferias De ?      ','','','mv_ch7','D',08,0,0,'G','NaoVazio   ','mv_par07','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
 aAdd(aRegs,{ cPerg,'08','Periodo Ferias Ate ?     ','','','mv_ch8','D',08,0,0,'G','NaoVazio   ','mv_par08','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
 U_fDelSx1( cPerg, "09" )

ValidPerg(aRegs,cPerg)

Return
