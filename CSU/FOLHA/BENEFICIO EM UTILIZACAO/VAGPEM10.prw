#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#DEFINE          cEol         CHR(13)+CHR(10)
#DEFINE          cSep         ";"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VAGPEM10 บ Autor ณ Adilson Silva      บ Data ณ 07/11/2013  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relacao de Funcionarios Ativos Com ou Sem Beneficios.      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function VAGPEM10()	// U_VAGPEM10()

 Local bProcesso := {|oSelf| fProcessa( oSelf )}

 Private cCadastro  := "Funcionแrios Ativos"
 Private cPerg      := "VAGPEM10"
 Private cStartPath := GetSrvProfString("StartPath","")
 Private cDescricao

 fAsrPerg()
 Pergunte(cPerg,.F.)

 cDescricao := "Esta rotina irแ gerar arquivo Excel com informa็๕es do cadastro de funcionแrios e benefํcios."

 tNewProcess():New( "SRA" , cCadastro , bProcesso , cDescricao , cPerg,,,,,.T.,.F. ) 	

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
Local nTotReg     := 0
Local cNomeArq    := ""
Local cTipBen     := ""
Local cDtDemissa  := ""

Local cLin

Private cFilDe, cFilAte
Private cMatDe, cMatAte
Private cCcDe, cCcAte
Private cNomeDe, cNomeAte
Private cCateg

Private nHdl

Pergunte(cPerg,.F.)
 cFilDe   := mv_par01
 cFilAte  := mv_par02
 cMatDe   := mv_par03
 cMatAte  := mv_par04
 cCcDe    := mv_par05
 cCcAte   := mv_par06
 cCateg   := U_fSqlIN( mv_par07,1 )

cNomeArq  := CriaTrab(,.F.) + ".CSV"

// Cria Arquivo Texto
cPath    := cPath + If(Right(cPath,1) <> "\","\","")
cNomeArq := cPath + cNomeArq
nHdl     := fCreate( cNomeArq )
If nHdl == -1
   MsgAlert("O arquivo de nome "+cNomeArq+" nao pode ser executado! Verifique os parametros.","Atencao!")
   Return
EndIf
ZT6->(dbSetOrder( 1 ))
ZT8->(dbSetOrder( 1 ))		// 
SRA->(dbSetOrder( 1 ))
CTT->(dbSetOrder( 1 ))
SRJ->(dbSetOrder( 1 ))		// RJ_FILIAL+RJ_FUNCAO

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

// Grava Cabecalho do Arquivo Texto
fGrvCab()

Do While !Eof()
   oSelf:IncRegua1( WSRA->(RA_FILIAL + " - " + RA_MAT + " - " + RA_NOME) )
   If oSelf:lEnd 
      Exit
   EndIf
   
   SRA->(dbGoTo( WSRA->RA_RECNO ))
   CTT->(dbSeek( RhFilial("CTT",SRA->RA_FILIAL) + SRA->RA_CC ))
   SRJ->(dbSeek( RhFilial("SRJ",SRA->RA_FILIAL) + SRA->RA_CODFUNC ))
   ZT6->(dbSeek( WSRA->(RA_FILIAL + RA_MAT) ))
   ZT8->(dbSeek( RhFilial("ZT8",SRA->RA_FILIAL) + ZT6->ZT6_COD ))
   cTipBen := If(ZT6->ZT6_TIPO=="1","VR","VA")   
   cDtDemissa := If(!Empty(WSRA->RA_DEMISSA),Dtoc(WSRA->RA_DEMISSA),"")

   cLin := '="' + WSRA->RA_FILIAL + '"' + cSep										// 01 - Filial
   cLin += '="' + WSRA->RA_MAT + '"' + cSep			   								// 02 - Matricula
   cLin += Alltrim(WSRA->RA_NOME) + cSep			 								// 03 - Nome
   cLin += Alltrim(SRJ->RJ_DESC) + cSep												// 04 - Descricao Funcao
   cLin += Alltrim(CTT->CTT_DESC01) + cSep											// 05 - Descricao Centro de Custo
   cLin += Dtoc(WSRA->RA_ADMISSA) + cSep											// 06 - Data Admissao
   cLin += cDtDemissa + cSep										   				// 07 - Data Demissao
   cLin += Transform(WSRA->RA_HRSMES,'@E 999.99') + cSep							// 08 - Horas Mensais
   cLin += "" + cSep														   		// 09 - Escala
   cLin += ZT6->ZT6_COD + cSep														// 10 - Codigo Beneficio
   cLin += ZT8->ZT8_DESC + cSep														// 11 - Descricao Beneficio
   cLin += Transform(ZT8->ZT8_VALOR,'@E 9,999,999.99') + cSep						// 12 - Valor Unitario do Beneficio
   cLin += cTipBen + cSep                   										// 13 - Tipo do Beneficio
   cLin += Alltrim(WSRA->RA_SITFOLH) + cSep											// 14 - Situacao na Folha
   cLin += '="' + WSRA->RA_CIC + '"' + cSep			   								// 15 - CPF
   cLin += Dtoc(WSRA->RA_NASC) + cSep												// 16 - Data Nascimento
   cLin += Alltrim(WSRA->RA_SEXO) + cEol									 		// 17 - Sexo
   fGravaTxt( cLin )
		
   dbSkip()
EndDo 
If !lSetCentury
   __SetCentury( "off" )
EndIf
WSRA->(dbCloseArea())  
fClose( nHdl )

// Integra Planilha ao Excel
If !oSelf:lEnd
   MsAguarde( {|| fStartExcel( cNomeArq )}, "Aguarde...", "Integrando Planilha ao Excel..." )
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

 Local cLin

 cLin := "Filial" + cSep							// 01 - Filial
 cLin += "Matricula" + cSep                       	// 02 - Matricula
 cLin += "Nome" + cSep                           	// 03 - Nome
 cLin += "Funcao" + cSep                			// 04 - Descricao Funcao
 cLin += "Centro de Custo" + cSep       			// 05 - Descricao Centro de Custo
 cLin += "Admissao" + cSep                        	// 06 - Data Admissao
 cLin += "Demissao" + cSep                        	// 07 - Data Demissao
 cLin += "Horas Mensais" + cSep                 	// 08 - Horas Mensais
 cLin += "Escala" + cSep                         	// 09 - Escala 
 cLin += "Cod Beneficio" + cSep                    	// 10 - Codigo do Beneficio
 cLin += "Descr Beneficio" + cSep                  	// 11 - Descricao Beneficio
 cLin += "Valor Unitario" + cSep                  	// 12 - Valor Unitario do Beneficio
 cLin += "Tipo Beneficio" + cSep                   	// 13 - Tipo do Beneficio
 cLin += "Sit Folha" + cSep                     	// 14 - Situacao na Folha
 cLin += "CPF" + cSep                           	// 15 - CPF
 cLin += "Nascimento" + cSep                       	// 16 - Data Nascimento
 cLin += "Sexo" + cEol                           	// 17 - Sexo

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
ฑฑบPrograma  ณVAGPEM10  บAutor  ณMicrosiga           บ Data ณ  04/26/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fMtaQuery()

 Local dAdmDe := Stod(MesAno( dDataBase ) + "01") - 1
 Local cQuery := ""
 
 cQuery += " SELECT SRA.RA_FILIAL,"
 cQuery += "        SRA.RA_MAT,"
 cQuery += "        SRA.RA_NOME,"
 cQuery += "        SRA.RA_CC,"
 cQuery += "        SRA.RA_CIC,"
 cQuery += "        SRA.RA_ADMISSA,"
 cQuery += "        SRA.RA_DEMISSA,"
 cQuery += "        SRA.RA_NASC,"
 cQuery += "        SRA.RA_HRSMES,"
 cQuery += "        SRA.RA_SITFOLH,"
 cQuery += "        SRA.RA_SEXO,"
 cQuery += "        SRA.R_E_C_N_O_ AS RA_RECNO"
 cQuery += " FROM " + RetSqlName( "SRA" ) + " SRA"
 cQuery += " WHERE SRA.D_E_L_E_T_ <> '*'"
 cQuery += "   AND SRA.RA_FILIAL  BETWEEN '" + cFilDe  + "' AND '" + cFilAte  + "'"
 cQuery += "   AND SRA.RA_MAT     BETWEEN '" + cMatDe  + "' AND '" + cMatAte  + "'"
 cQuery += "   AND SRA.RA_CC      BETWEEN '" + cCcDe   + "' AND '" + cCcAte   + "'"
 cQuery += "   AND SRA.RA_CATFUNC IN (" + cCateg  + ")"
 cQuery += "   AND (SRA.RA_DEMISSA = '' OR SRA.RA_DEMISSA > '" + Dtos( dAdmDe ) + "')"

 cQuery := ChangeQuery( cQuery )
 TCQuery cQuery New Alias "WSRA"
 TcSetField( "WSRA" , "RA_ADMISSA" , "D", 08, 0 )
 TcSetField( "WSRA" , "RA_DEMISSA" , "D", 08, 0 )
 TcSetField( "WSRA" , "RA_NASC"    , "D", 08, 0 )
 TcSetField( "WSRA" , "RA_HRSMES"  , "N", 08, 2 )
 TcSetField( "WSRA" , "RA_RECNO"   , "N", 08, 0 )
 
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

 aAdd(aRegs,{ cPerg,'01','Filial De ?              ','','','mv_ch1','C',Fi,0,0,'G','           ','mv_par01','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SM0   ','' })
 aAdd(aRegs,{ cPerg,'02','Filial Ate ?             ','','','mv_ch2','C',Fi,0,0,'G','NaoVazio   ','mv_par02','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SM0   ','' })
 aAdd(aRegs,{ cPerg,'03','Matricula De ?           ','','','mv_ch3','C',06,0,0,'G','           ','mv_par03','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SRA   ','' })
 aAdd(aRegs,{ cPerg,'04','Matricula Ate ?          ','','','mv_ch4','C',06,0,0,'G','NaoVazio   ','mv_par04','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','SRA   ','' })
 aAdd(aRegs,{ cPerg,'05','Centro Custo De ?        ','','','mv_ch5','C',20,0,0,'G','           ','mv_par05','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','CTT   ','' })
 aAdd(aRegs,{ cPerg,'06','Centro Custo Ate ?       ','','','mv_ch6','C',20,0,0,'G','NaoVazio   ','mv_par06','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','CTT   ','' })
 aAdd(aRegs,{ cPerg,'07','Categorias ?             ','','','mv_ch7','C',12,0,0,'G','fCategoria ','mv_par09','               ','','','','','           ','','','','','         ','','','','','            ','','','','','           ','','','','      ','' })
 U_fDelSx1( cPerg, "08" )

ValidPerg(aRegs,cPerg)

Return
