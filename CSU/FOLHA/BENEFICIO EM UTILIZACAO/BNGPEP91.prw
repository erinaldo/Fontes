#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#DEFINE          cEol         CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEP91 บ Autor ณ Adilson Silva      บ Data ณ 04/11/2013  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Integracao com a Rotina de Valores Futuros para Geracao do บฑฑ
ฑฑบ          ณ Pagamento por CNAB.                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function BNGPEP91()

 Local bProcesso := {|oSelf| fProcessa( oSelf )}

 Private cCadastro  := "Integra CNAB para Folha"
 Private cPerg      := "BNGPEP91"
 Private cStartPath := GetSrvProfString("StartPath","")
 Private cDescricao

 fPerg()
 Pergunte(cPerg,.F.)

 cDescricao := "Esta rotina irแ integrar os benefํcios pagos via CNAB Bancแrio para trโnsito na folha de pagamento."

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

Local nTotReg  := 0
Local cChave   := ""
Local cVerbas  := ""
Local cPdContr := ""
Local aLancto  := {}
Local nValTot  := 0
Local nPos, nX

Private nTotReg  := 0

Private dDtRef, dDtPagto
Private cFilDe, cFilAte
Private cMatDe, cMatAte
Private cCcDe, cCcAte

Pergunte(cPerg,.F.)
 dDtRef   := mv_par01
 cFilDe   := mv_par02
 cFilAte  := mv_par03
 cMatDe   := mv_par04
 cMatAte  := mv_par05
 cCcDe    := mv_par06
 cCcAte   := mv_par07

If !fMtaVerbas( @cVerbas, @cPdContr )
   Return
EndIf

If Aviso( "ATENCAO", OemToAnsi( "Confirma Integra็ใo dos Benefํcios com a Folha de Pagamento?" ),{"Nใo","Sim"}) == 1
   Return
EndIf

RCA->(dbSetOrder( 1 ))
SRA->(dbSetOrder( 1 ))
SRC->(dbSetOrder( 1 ))

// Monta a Query Principal 
MsAguarde( {|| fMtaQuery( dDtRef, cVerbas )}, "Processando...", "Selecionado Registros no Servidor!" )
dbSelectArea( "WSR1" )
Count To nTotReg
If nTotReg = 0
   WSR1->(dbCloseArea())
   Return
EndIf
dbGoTop()
oSelf:SetRegua1( nTotReg )

Do While !Eof()
   oSelf:IncRegua1( "Processando Funcionario: " + WSR1->(R1_FILIAL + " - " + R1_MAT) )
   If oSelf:lEnd 
      Break
   EndIf
   
   SRA->(dbSeek( WSR1->(R1_FILIAL + R1_MAT) ))
   
   // Acumula os Lancamentos
   If ( nPos := Ascan(aLancto,{|x| x[1]==WSR1->R1_PD}) ) > 0
      aLancto[nPos,2] += WSR1->R1_VALOR
   Else
      Aadd(aLancto,{WSR1->R1_PD, WSR1->R1_VALOR})
   EndIf

   cChave := WSR1->(R1_FILIAL + R1_MAT)
   dbSkip()
   If cChave <> WSR1->(R1_FILIAL + R1_MAT)
      // Totaliza os Beneficios para Gerar a Contra-Partida
      If !Empty( cPdContr )
         nValTot := 0
         Aeval(aLancto,{|x| nValTot += x[2]})
         Aadd(aLancto,{cPdContr,nValTot})
      EndIf
      
      // Grava os Lancamentos no SRC
      dbSelectArea( "SRC" )		// RC_FILIAL+RC_MAT+RC_PD+RC_CC+RC_SEMANA+RC_SEQ
      For nX := 1 To Len( aLancto )
          If dbSeek( cChave + aLancto[nX,1] )
             If SRC->RC_TIPO2 == "I"
                Loop
             EndIf
             RecLock("SRC",.F.)
          Else
             RecLock("SRC",.T.)
          EndIf
           SRC->RC_FILIAL  := SRA->RA_FILIAL
           SRC->RC_MAT     := SRA->RA_MAT
           SRC->RC_PD      := aLancto[nX,1]
           SRC->RC_TIPO1   := "V"
           SRC->RC_HORAS   := 0
           SRC->RC_VALOR   := aLancto[nX,2]
           SRC->RC_CC      := SRA->RA_CC
           SRC->RC_TIPO2   := "G"
          MsUnlock()
      Next nX
      aLancto := {}
   EndIf
   
   dbSelectArea( "WSR1" )
EndDo
WSR1->(dbCloseArea())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBNGPEP91  บAutor  ณMicrosiga           บ Data ณ  11/04/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP11                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fMtaVerbas( cVerbas, cPdContr )

 Local aPdPgto := {}
 Local cVrPd   := ""
 Local cVaPd   := ""
 Local cVtPd   := ""
 Local nItem   := 0
 Local nLen    := 0
 Local cTemp   := ""
 Local nAt, nX, nY

 For nItem := 1 To 9
    cVrPd := "M_PDVRCNB" + Str(nItem,1)
    cVaPd := "M_PDVACNB" + Str(nItem,1)
    cVtPd := "M_PDVTCNB" + Str(nItem,1)
    
    Aadd(aPdPgto,{"","",""})	// 1=VR - 2=VA - 3=VT
    nLen := Len(aPdPgto)
    
    // Verba do Vale Refeicao
    If RCA->(dbSeek( RhFilial("RCA",cFilAnt) + cVrPd ))
       aPdPgto[nLen,1] := &( RCA->RCA_CONTEU )
    EndIf
    // Verba do Vale Alimentacao
    If RCA->(dbSeek( RhFilial("RCA",cFilAnt) + cVaPd ))
       aPdPgto[nLen,2] := &( RCA->RCA_CONTEU )
    EndIf
    // Verba do Vale Alimentacao
    If RCA->(dbSeek( RhFilial("RCA",cFilAnt) + cVtPd ))
       aPdPgto[nLen,3] := &( RCA->RCA_CONTEU )
    EndIf
 Next nItem
 
 // Busca a Verba de Desconto dos Beneficios pagos via CNAB
 If RCA->(dbSeek( RhFilial("RCA",cFilAnt) + "M_PDBNCTRA" ))
    cPdContr := &( RCA->RCA_CONTEU )
 EndIf 
 
 // Cria String das Verbas
 cVerbas := ""
 For nX := 1 To Len( aPdPgto )
     For nY := 1 To Len( aPdPgto[nX] )
         cTemp := aPdPgto[nX,nY]
         If !Empty( cTemp )
            If ( nAt := At(cTemp,cVerbas) ) == 0
               cVerbas += cTemp + ","
            EndIf
         EndIf
     Next nY
 Next nX
 
Return( (Len(cVerbas) > 0) )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDSGPER03  บAutor  ณMicrosiga           บ Data ณ  04/26/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fMtaQuery( dDtRef, cVerbas )

 Local cQuery  := ""
 
 cVerbas := StrTran(cVerbas,",","")
 cVerbas := U_fSqlIN(cVerbas,3)

 cQuery += " SELECT SR1.R1_FILIAL,"
 cQuery += "        SR1.R1_MAT,"
 cQuery += "        SR1.R1_PD,"
 cQuery += "        SUM(SR1.R1_VALOR) AS R1_VALOR"
 cQuery += " FROM " + RetSqlName( "SR1" ) + " SR1"
 cQuery += " WHERE SR1.D_E_L_E_T_ <> '*'"
 cQuery += "   AND SR1.R1_FILIAL BETWEEN '" + cFilDe + "' AND '" + cFilAte + "'"
 cQuery += "   AND SR1.R1_MAT BETWEEN '" + cMatDe + "' AND '" + cMatAte + "'"
 cQuery += "   AND SR1.R1_CC BETWEEN '" + cCcDe + "' AND '" + cCcAte + "'"
 cQuery += "   AND SUBSTRING(SR1.R1_DATA,1,6) = '" + MesAno( dDtRef ) + "'"
 cQuery += "   AND SR1.R1_PD IN (" + cVerbas + ")"
 cQuery += " GROUP BY SR1.R1_FILIAL, SR1.R1_MAT, SR1.R1_PD"
 cQuery += " ORDER BY SR1.R1_FILIAL, SR1.R1_MAT, SR1.R1_PD"

 cQuery := ChangeQuery( cQuery )
 TCQuery cQuery New Alias "WSR1"
 TcSetField( "WSR1" , "R1_VALOR" , "N", 12, 2 )
 
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
Static Function fPerg()

Local aRegs := {}
Local Fi    := FWSizeFilial()

 // Verifica a Criacao do Grupo de Consultas F3
 U_fUPath()

 // Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
 aAdd(aRegs,{ cPerg,'01','Data Referencia ?            ','','','mv_ch1','D',08,0,0,'G','NaoVazio    ','mv_par01','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
 aAdd(aRegs,{ cPerg,'02','Filial De ?                  ','','','mv_ch2','C',Fi,0,0,'G','            ','mv_par02','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SM0   ','' })
 aAdd(aRegs,{ cPerg,'03','Filial Ate ?                 ','','','mv_ch3','C',Fi,0,0,'G','NaoVazio    ','mv_par03','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SM0   ','' })
 aAdd(aRegs,{ cPerg,'04','Matricula De ?               ','','','mv_ch4','C',06,0,0,'G','            ','mv_par04','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SRA   ','' })
 aAdd(aRegs,{ cPerg,'05','Matricula Ate ?              ','','','mv_ch5','C',06,0,0,'G','NaoVazio    ','mv_par05','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SRA   ','' })
 aAdd(aRegs,{ cPerg,'06','Centro Custo De ?            ','','','mv_ch6','C',20,0,0,'G','            ','mv_par06','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'CTT   ','' })
 aAdd(aRegs,{ cPerg,'07','Centro Custo Ate ?           ','','','mv_ch7','C',20,0,0,'G','NaoVazio    ','mv_par07','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'CTT   ','' })

ValidPerg(aRegs,cPerg)

Return   
