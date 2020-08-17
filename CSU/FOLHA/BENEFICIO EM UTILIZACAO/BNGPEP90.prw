#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#DEFINE          cEol         CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEP90 บ Autor ณ Adilson Silva      บ Data ณ 04/11/2013  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Integracao com a Rotina de Valores Futuros para Geracao do บฑฑ
ฑฑบ          ณ Pagamento por CNAB.                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function BNGPEP90()

 Local bProcesso := {|oSelf| fProcessa( oSelf )}

 Private cCadastro  := "Pagamento por CNAB"
 Private cPerg      := "BNGPEP90"
 Private cStartPath := GetSrvProfString("StartPath","")
 Private cDescricao

 fPerg()
 Pergunte(cPerg,.F.)

 cDescricao := "Esta rotina irแ integrar os benefํcios para pagamento via CNAB Bancแrio."

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
Local nValor   := 0
Local cChave   := ""
Local cPdPgto  := ""
Local cSemana  := Space( 02 )
Local nPos

Private lReproc  := .F.
Private nTotReg  := 0

Private dDtRef, dDtPagto
Private cFilDe, cFilAte
Private cMatDe, cMatAte
Private cCcDe, cCcAte
Private cGerBen, cPerCalc

Pergunte(cPerg,.F.)
 dDtRef   := mv_par01
 cFilDe   := mv_par02
 cFilAte  := mv_par03
 cMatDe   := mv_par04
 cMatAte  := mv_par05
 cCcDe    := mv_par06
 cCcAte   := mv_par07
 cGerBen  := Str(mv_par08,1)		// 1=Vale Refeicao - 2=Vale Alimentacao - 3=Vale Transporte
 cPerCalc := mv_par09
 lReproc  := mv_par10 == 1
 dDtPagto := mv_par11
 //cSemana  := StrZero(Val( cPerCalc ),2)

cPeriodo := MesAno( dDtRef )

If !fMtaVerbas( @cPdPgto, cPerCalc )
   Return
EndIf

// Janela p/ Confirmacao da opcao Regrava
If lReproc
   If Aviso( "ATENCAO", OemToAnsi( "O sistema irแ gerar eventuais benefํcios jแ pagos no intervalo selecionado nos parametros!!!" ),{"Sair","Continuar"}) == 1
      Return
   EndIf
EndIf

RCA->(dbSetOrder( 1 ))
SRA->(dbSetOrder( 1 ))
SR1->(dbSetOrder( 1 ))	// R1_FILIAL+R1_MAT+R1_SEMANA+R1_PD+R1_CC
ZT7->(dbSetOrder( 1 ))

// Monta a Query Principal 
MsAguarde( {|| fMtaQuery( dDtRef )}, "Processando...", "Selecionado Registros do Local de Entrega " + ZTD->ZTD_CODIGO )
dbSelectArea( "WZT7" )
Count To nTotReg
If nTotReg = 0
   WZT7->(dbCloseArea())
   Return
EndIf
dbGoTop()
oSelf:SetRegua1( nTotReg )

Do While !Eof()
   oSelf:IncRegua1( "Processando Funcionario: " + WZT7->(ZT7_FILIAL + " - " + ZT7_MAT) )
   If oSelf:lEnd 
      Break
   EndIf
   
   SRA->(dbSeek( WZT7->(ZT7_FILIAL + ZT7_MAT) ))
   
   If cGerBen $ "12"
      dbSelectArea( "ZT7" )
      dbGoTo( WZT7->ZT7_RECNO )
      If !Eof() .And. !Bof()
         RecLock("ZT7",.F.)
          ZT7->ZT7_PEDIDO := "6"
         MsUnlock()
      EndIf
   ElseIf cGerBen = "3"
      dbSelectArea( "ZTB" )
      dbGoTo( WZT7->ZTB_RECNO )
      If !Eof() .And. !Bof()
         RecLock("ZTB",.F.)
          ZTB->ZTB_PEDIDO := "6"
         MsUnlock()
      EndIf
   EndIf
      
   dbSelectArea( "WZT7" )
   cChave := WZT7->(ZT7_FILIAL + ZT7_MAT)
   nValor += WZT7->ZT7_TTVALE + WZT7->ZT7_VLDIFE
   dbSkip()
   If cChave == WZT7->(ZT7_FILIAL + ZT7_MAT)
      Loop
   EndIf

   dbSelectArea( "SR1" )	// R1_FILIAL+R1_MAT+R1_SEMANA+R1_PD+R1_CC
   If dbSeek( cChave + cSemana + cPdPgto )
      RecLock("SR1",.F.)
   Else
      RecLock("SR1",.T.)
   EndIf
    SR1->R1_FILIAL  := SRA->RA_FILIAL
    SR1->R1_MAT     := SRA->RA_MAT
    SR1->R1_PD      := cPdPgto
    SR1->R1_TIPO1   := "V"
    SR1->R1_HORAS   := 0
    SR1->R1_VALOR   := nValor
    SR1->R1_DATA    := dDtPagto
    SR1->R1_SEMANA  := cSemana
    SR1->R1_CC      := SRA->RA_CC
    SR1->R1_PARCELA := 0
    SR1->R1_TIPO2   := "G"
   MsUnlock()
   dbSelectArea( "WZT7" )
   nValor  := 0
EndDo
WZT7->(dbCloseArea())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBNGPEP90  บAutor  ณMicrosiga           บ Data ณ  11/04/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP11                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fMtaVerbas( cPdPgto, cPerCalc )

 Local cTexto  := ""
 Local cMnemPd := ""
 
 If cGerBen == "1"
    cMnemPd := "M_PDVRCNB" + cPerCalc
 ElseIf cGerBen == "2" 
    cMnemPd := "M_PDVACNB" + cPerCalc
 ElseIf cGerBen == "3" 
    cMnemPd := "M_PDVTCNB" + cPerCalc
 EndIf

 If cGerBen == "1" .And. RCA->(dbSeek( RhFilial("RCA",cFilAnt) + cMnemPd ))  			// Verba do Vale Refeicao
    cPdPgto := &( RCA->RCA_CONTEU )
    cTexto  := "Mnem๔nico com a Verba do CNAB do Vale Refei็ใo (" + cMnemPd + ") Nใo Cadastrado!"
 ElseIf cGerBen == "2" .And. RCA->(dbSeek( RhFilial("RCA",cFilAnt) + cMnemPd ))		// Verba do Vale Alimentacao
    cPdPgto := &( RCA->RCA_CONTEU )
    cTexto  := "Mnem๔nico com a Verba do CNAB do Vale Alimenta็ใo (" + cMnemPd + ") Nใo Cadastrado!"
 ElseIf cGerBen == "3" .And. RCA->(dbSeek( RhFilial("RCA",cFilAnt) + cMnemPd ))		// Verba do Vale Transporte
    cPdPgto := &( RCA->RCA_CONTEU )
    cTexto  := "Mnem๔nico com a Verba do CNAB do Vale Transporte (" + cMnemPd + ") Nใo Cadastrado!"
 EndIf

 If Empty( cPdPgto )
    Aviso("ATENCAO",cTexto,{"Sair"})
 EndIf

Return( !Empty(cPdPgto) )

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
Static Function fMtaQuery( dDtRef )

 Local cQuery  := ""

 If cGerBen $ "12"
    cQuery := " SELECT ZT7.ZT7_FILIAL,"
    cQuery += "        ZT7.ZT7_MAT,"
    cQuery += "        ZT7.ZT7_COD,"
    cQuery += "        ZT7.ZT7_TTVALE,"
    cQuery += "        0 AS ZT7_VLDIFE,"
    cQuery += "        ZT7.R_E_C_N_O_ AS ZT7_RECNO,"
    cQuery += "        0 AS ZTB_RECNO"
    cQuery += " FROM " + RetSqlName( "ZT7" ) + " ZT7"
    cQuery += " WHERE ZT7.D_E_L_E_T_ <> '*'"
    cQuery += "   AND ZT7.ZT7_STATUS = '1'"
    cQuery += "   AND ZT7.ZT7_TTVALE > 0"
    cQuery += "   AND ZT7.ZT7_FILIAL BETWEEN '" + cFilDe + "' AND '" + cFilAte + "'"
    cQuery += "   AND ZT7.ZT7_MAT BETWEEN '" + cMatDe + "' AND '" + cMatAte + "'"
    cQuery += "   AND ZT7.ZT7_CC BETWEEN '" + cCcDe + "' AND '" + cCcAte + "'"
    cQuery += "   AND ZT7.ZT7_DATARQ = '" + cPeriodo + "'"
    cQuery += "   AND ZT7.ZT7_PERIOD = '" + cPerCalc + "'"
    cQuery += "   AND ZT7.ZT7_TIPO = '" + cGerBen + "'"
    If !lReproc
       cQuery += " AND ZT7.ZT7_PEDIDO = '4'"
    Else
       cQuery += " AND ZT7.ZT7_PEDIDO IN ('4','6')"
    EndIf
    cQuery += " ORDER BY ZT7.ZT7_FILIAL, ZT7.ZT7_MAT, ZT7.ZT7_COD"
 ElseIf cGerBen == "3"
    cQuery := " SELECT ZTB.ZTB_FILIAL AS ZT7_FILIAL,"
    cQuery += "        ZTB.ZTB_MAT AS ZT7_MAT,"
    cQuery += "        ZTB.ZTB_COD AS ZT7_COD,"
    cQuery += "        ZTB.ZTB_TTVALE AS ZT7_TTVALE,"
    cQuery += "        ZTB.ZTB_VLDIFE AS ZT7_VLDIFE,"
    cQuery += "        0 AS ZT7_RECNO,"
    cQuery += "        ZTB.R_E_C_N_O_ AS ZTB_RECNO"
    cQuery += " FROM " + RetSqlName( "ZTB" ) + " ZTB"
    cQuery += " WHERE ZTB.D_E_L_E_T_ <> '*'"
    cQuery += "   AND ZTB.ZTB_STATUS = '1'"
    cQuery += "   AND (ZTB.ZTB_TTVALE > 0 OR ZTB.ZTB_VLDIFE > 0)"
    cQuery += "   AND ZTB.ZTB_FILIAL BETWEEN '" + cFilDe + "' AND '" + cFilAte + "'"
    cQuery += "   AND ZTB.ZTB_MAT BETWEEN '" + cMatDe + "' AND '" + cMatAte + "'"
    cQuery += "   AND ZTB.ZTB_CC BETWEEN '" + cCcDe + "' AND '" + cCcAte + "'"
    cQuery += "   AND ZTB.ZTB_DATARQ = '" + cPeriodo + "'"
    cQuery += "   AND ZTB.ZTB_PERIOD = '" + cPerCalc + "'"
    If !lReproc
       cQuery += " AND ZTB.ZTB_PEDIDO = '4'"
    Else
       cQuery += " AND ZTB.ZTB_PEDIDO IN ('4','6')"
    EndIf
    cQuery += " ORDER BY ZTB.ZTB_FILIAL, ZTB.ZTB_MAT, ZTB.ZTB_COD"
 EndIf 

 cQuery := ChangeQuery( cQuery )
 TCQuery cQuery New Alias "WZT7"
 TcSetField( "WZT7" , "ZT7_TTVALE" , "N", 12, 2 )
 TcSetField( "WZT7" , "ZT7_VLDIFE" , "N", 12, 2 )
 TcSetField( "WZT7" , "ZT7_RECNO"  , "N", 12, 0 )
 TcSetField( "WZT7" , "ZTB_RECNO"  , "N", 12, 0 )
 
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
 aAdd(aRegs,{ cPerg,'08','Beneficio a Gerar  ?         ','','','mv_ch8','N',01,0,0,'C','            ','mv_par08','Vale Refeicao    ','','','','','Vale Alimentacao ','','','','','Vale Transporte '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
 aAdd(aRegs,{ cPerg,'09','Periodo a Processar ?        ','','','mv_ch9','C',01,0,0,'G','U_fBnfPer(1)','mv_par09','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
 aAdd(aRegs,{ cPerg,'10','Reprocessa Reg Ja Gerados ?  ','','','mv_cha','N',01,0,0,'C','            ','mv_par10','Sim              ','','','','','Nao              ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
 aAdd(aRegs,{ cPerg,'11','Data do Pagamento ?          ','','','mv_chb','D',08,0,0,'G','NaoVazio    ','mv_par11','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })

ValidPerg(aRegs,cPerg)

Return   
