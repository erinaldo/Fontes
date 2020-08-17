#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#DEFINE          cEol         CHR(13)+CHR(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEP08 บ Autor ณ Adilson Silva      บ Data ณ 02/01/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Geracao do Arquivo Texto p/ Compra dos Beneficios da Accor บฑฑ
ฑฑบ          ณ Ticket.                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function BNGPEP08()

 Local bProcesso := {|oSelf| fProcessa( oSelf )}

 Private cCadastro  := "Pedidos Ticket"
 Private cPerg      := "BNGPEP08"
 Private cStartPath := GetSrvProfString("StartPath","")
 Private cDescricao

 fAsrPerg()
 Pergunte(cPerg,.F.)

 cDescricao := "Esta rotina irแ gerar o arquivo texto para compra dos benefํcios do fornecedor Accor Ticket."

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

Local cLocArq  := ""
Local cArqTxt  := ""
Local cOrdem   := ""
Local cLin     := ""
Local aCc      := {}
Local aFunc    := {}
Local cMatFunc := ""
Local cChave   := ""
Local cTipBen  := ""
Local nQtdElet := 0
Local nQtdPape := 0
Local nPos, nX

Local lProcTTHD := .T.
Local lProcTRE  := .T.
Local lProcTR0  := .T.

Private cDatarq  := ""
Private cPeriodo := ""
Private cCodForn := "004"
Private cTipoPed := ""
Private aEmpr    := {}
Private lReproc  := .F.
Private nTotReg  := 0
Private cCnpj    := ""
Private cNomeEmp := ""
Private cEntrCtt := "@@"
Private cEntrSra := "@@"

Private nSequenc   := 0
Private nHeader    := 0
Private nTrailler  := 0
Private nRegistros := 0

Private cContrato  := ""
Private nLocEntreg := 0
Private nDepPedido := 0
Private nFunPedido := 0
Private nItePedido := 0
Private nServPedid := 0
Private nValPedido := 0

Private dDtRef
Private cFilDe, cFilAte
Private cMatDe, cMatAte
Private cCcDe, cCcAte
Private dUsoDe, dUsoAte
Private nValKit, nValPon
Private dEntrMin, dEntrMax
Private dDtPed, dDtLib

Private nHdl

Pergunte(cPerg,.F.)
 dDtRef   := mv_par01
 cFilDe   := mv_par02
 cFilAte  := mv_par03
 cMatDe   := mv_par04
 cMatAte  := mv_par05
 cCcDe    := mv_par06
 cCcAte   := mv_par07
 cPeriodo := mv_par08
 cLocArq  := Alltrim( mv_par09 )
 nValKit  := mv_par10
 nValPon  := mv_par11
 dEntrMin := mv_par12
 dEntrMax := mv_par13
 lReproc  := mv_par14 == 1
 cTipoPed := Str(mv_par15,1)	// 1=Vale Transporte - 2=Vale Refeicao - 3=Vale Alimentacao
 dDtPed   := mv_par16
 dDtLib   := mv_par17

cDatarq  := MesAno( dDtRef )
dUsoDe   := Stod( Left(Dtos(dDtRef),6)+"01" )
dUsoAte  := Stod( Left(Dtos(dDtRef),6)+StrZero(f_UltDia(dDtRef),2) )

cTipBen := If(cTipoPed=="1","VT",If(cTipoPed=="2","VR","VA"))

// Janela p/ Confirmacao da opcao Regrava
If lReproc
   If Aviso( "ATENCAO", OemToAnsi( "O sistema irแ gerar eventuais benefํcios jแ pagos no intervalo selecionado nos parametros!!!" ),{"Sair","Continuar"}) == 1
      Return
   EndIf
EndIf

CTT->(dbSetOrder( 1 ))
SRN->(dbSetOrder( 1 ))
SRA->(dbSetOrder( 1 ))
SRJ->(dbSetOrder( 1 ))
ZT9->(dbSetOrder( 1 ))
ZTB->(dbSetOrder( 1 ))

// Valida os Locais de Entrega
If !U_fLocEntrega( @cEntrSra, @cEntrCtt, cTipBen )
   Aviso("ATENCAO","Locais de entrega nใo configurados! Entre em contato com o suporte!",{"Sair"})
   Return
EndIf

// Busca o Fornecedor
If !(ZT9->(dbSeek( xFilial("ZT9") + cCodForn )))
   Aviso("ATENCAO","Fornecedor da VB Servicos nao cadastrado",{"Sair"})
   Return
EndIf
If Empty( ZT9->ZT9_CODFOR )
   Aviso("ATENCAO","Contrato nใo cadastrado para este fornecedor!",{"Sair"})
   Return
EndIf
If cTipBen == "VR"
   cContrato := Alltrim( ZT9->ZT9_CODFOR )
ElseIf cTipBen == "VA"
   cContrato := Alltrim( ZT9->ZT9_CODFVA )
EndIf
fMtaEmpresa( ZT9->ZT9_EMPRES, @cCnpj, @cNomeEmp, @aEmpr )

// Cria Arquivo Texto
cLocArq := cLocArq + If(Right(cLocArq,1) # "\","\","")
If cTipoPed == "1"
   cArqTxt := cLocArq + "TICKET_E" + cEmpant + "_VT_" + cDatarq + ".TXT" 	// 1=Vale Transporte
ElseIf cTipoPed == "2"
   cArqTxt := cLocArq + "TICKET_E" + cEmpant + "_VR_" + cDatarq + ".TXT"	// 2=Vale Refeicao
ElseIf cTipoPed == "3"
   cArqTxt := cLocArq + "TICKET_E" + cEmpant + "_VA_" + cDatarq + ".TXT"	// 3=Vale Alimentacao
EndIf

If File( cArqTxt )
   If Aviso("ATENCAO","O Arquivo " + cArqTxt + " Jแ Existe. Sobrepor?",{"Nใo","Sim"}) == 1
      Return
   EndIf
EndIf

nHdl := fCreate( cArqTxt )
If nHdl == -1
   MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
   Return
Endif

// Cria Arquivo Dbf Temporario
fArqTemp()

// Processa Registro Tipo "LSUP5"
cOrdem   := "000000000000000"
fProcLSUP5( cOrdem, 164 )
nHeader++

dbSelectArea( "ZTD" )
dbSetOrder( 1 )
dbGoTop()
oSelf:SetRegua1( RecCount() )

Do While !Eof()
   oSelf:IncRegua1( ZTD->(ZTD_CODIGO + " - " + ZTD_DESCR) )

   If oSelf:lEnd 
      Exit
   EndIf

   // Monta a Query Principal 
   MsAguarde( {|| fMtaQuery( dDtRef )}, "Processando...", "Selecionado Registros do Local de Entrega " + ZTD->ZTD_CODIGO )
   
   dbSelectArea( "WZTB" )
   If nQtdElet = 0 .And. nQtdPape = 0
      dbEval({|| If(WZTB->ZTB_TKTPRO$" 1",nQtdElet++,nQtdPape++) })
   ElseIf nQtdElet > 0 .And. nQtdPape = 0
      dbEval({|| If(WZTB->ZTB_TKTPRO$" 1",nQtdElet:=nQtdElet,nQtdPape++) })
   ElseIf nQtdElet = 0 .And. nQtdPape > 0
      dbEval({|| If(WZTB->ZTB_TKTPRO$" 1",nQtdElet++,nQtdPape:=nQtdPape) })
   EndIf
   
   dbGoTop()
   Count To nTotReg
   dbGoTop()
   oSelf:SetRegua2( nTotReg )

   // ZTB_TKTPRO  1 =Eletronico - 2=Papel

   If nTotReg > 0
      // Monta Headers do Arquivo
      If lProcTTHD .And. cTipoPed == "1"	// 1=Vale Transporte
         // Processa Registro Tipo Header "TT"
         cOrdem   := "000000000000010"
         fProcTTHD( cOrdem )
         lProcTTHD := .F.
         nHeader++
      ElseIf cTipoPed $ "2*3"				// 2=Vale Refeicao - 3=Vale Alimentacao
         If lProcTRE .And. nQtdElet > 0		// Eletronico
            cOrdem   := "000000000000000"
            fProcTRE( cOrdem )
            lProcTRE := .F.
            nHeader++
         EndIf
         If lProcTR0 .And. nQtdPape > 0		// Papel
            cOrdem   := "100000000000000"
            fProcTR0( cOrdem )
            lProcTR0 := .F.
            nHeader++
         EndIf
      EndIf
   
      // Processa Registro Tipo "TTUN" - Locais de Entrega
      If cTipoPed == "1"	// 1=Vale Transporte
         cOrdem := ZTD->ZTD_CODIGO + "000100000"
         fProcTTUN( cOrdem )
         // Totalizador dos Locais de Entrega
         nLocEntreg++
         nRegistros++
      ElseIf cTipoPed $ "2*3"	// 2=Vale Refeicao - 3=Vale Alimentacao
         If nQtdElet > 0		// Eletronico
            cOrdem := ZTD->ZTD_CODIGO + "000100000"
            fProcUNTRE( cOrdem )
            nRegistros++
         EndIf
         If nQtdPape > 0		// Papel
            cOrdem := "1" + ZTD->ZTD_CODIGO + "00100000"
            fProcTR2( cOrdem )
            nRegistros++
         EndIf
      EndIf
      
      nSequenc := 0
      Do While !Eof()
         SRA->(dbSeek( WZTB->(ZTB_FILIAL + ZTB_MAT) ))
         SRJ->(dbSeek( xFilial("SRJ") + SRA->RA_CODFUNC ))
         CTT->(dbSeek( xFilial("CTT") + SRA->RA_CC ))

         oSelf:IncRegua2( "Processando Local: " + ZTD->ZTD_CODIGO + " Funcionario: " + WZTB->(ZTB_FILIAL + " - " + ZTB_MAT) )
         If oSelf:lEnd 
            Exit
         EndIf

         cMatFunc := StrZero(Val(Alltrim(WZTB->(ZTB_FILIAL + ZTB_MAT))),12)
         If cTipoPed == "1"	// 1=Vale Transporte - 2=Vale Refeicao - 3=Vale Alimentacao
            // Gera o Centro de Custo
            If ( nPos := Ascan(aCc,{|x| x[1]+x[2]==ZTD->ZTD_CODIGO+Left(WZTB->ZTB_CC,6)}) ) == 0
               Aadd(aCc,{ZTD->ZTD_CODIGO, Left(WZTB->ZTB_CC,6)})
               // Processa Registro Tipo "TTDE" - Centros de Custo
               cOrdem := ZTD->ZTD_CODIGO + "000110000"
               fProcTTDE( cOrdem )
               // Totalizador dos Departamentos
               nDepPedido++
               nRegistros++
            EndIf
            
            // Gera o Funcionario
            If ( nPos := Ascan(aFunc,{|x| x[1]+x[2]+x[3]==ZTD->ZTD_CODIGO+Left(WZTB->ZTB_CC,6)+cMatFunc}) ) == 0
               Aadd(aFunc,{ZTD->ZTD_CODIGO, Left(WZTB->ZTB_CC,6),cMatFunc})
               // Processa Registro Tipo "TTFU" - Funcionarios
               cOrdem := ZTD->ZTD_CODIGO + "000111000"
               fProcTTFU( cOrdem, cMatFunc )
               // Totalizador dos Funcionarios
               nFunPedido++
               nRegistros++
            EndIf   

            // Processa Registro Tipo "TTIT" - Itens do Pedido
            nSequenc++
            cOrdem := ZTD->ZTD_CODIGO + "000111100"
            fProcTTIT( cOrdem, cMatFunc )
            // Totalizador dos Itens do Pedido
            nItePedido++
            nValPedido += WZTB->ZTB_TTVALE
            nRegistros++
            
            // Atualiza o Controle do Pedido Efetuado
            dbSelectArea( "ZTB" )
            dbGoTo( WZTB->ZTB_RECNO )
            RecLock("ZTB",.F.)
             ZTB->ZTB_PEDIDO := "5"
            MsUnlock()
            dbSelectArea( "WZTB" )
         ElseIf cTipoPed $ "2*3"	// 2=Vale Refeicao - 3=Vale Alimentacao
            If WZTB->ZTB_TKTPRO $ " 1"		// Eletronico
               cOrdem := ZTD->ZTD_CODIGO + "000110000"
               fProcFUTRE( cOrdem, cMatFunc )
               nRegistros++
               nItePedido++
               nValPedido += WZTB->ZTB_TTVALE
            ElseIf WZTB->ZTB_TKTPRO == "2"		// Papel
               cOrdem := "1" + ZTD->ZTD_CODIGO + "00110000"
               fProcTR3( cOrdem, cMatFunc )
               nRegistros++
               nItePedido++
               nValPedido += WZTB->ZTB_TTVALE
            EndIf

            // Atualiza o Controle do Pedido Efetuado
            dbSelectArea( "ZT7" )
            dbGoTo( WZTB->ZT7_RECNO )
            RecLock("ZT7",.F.)
             ZT7->ZT7_PEDIDO := "5"
            MsUnlock()
            dbSelectArea( "WZTB" )
         EndIf
         
         cChave := WZTB->(ZTB_FILIAL + ZTB_MAT)
         dbSelectArea( "WZTB" )
         dbSkip()
         If cChave <> WZTB->(ZTB_FILIAL + ZTB_MAT)
            nSequenc := 0
         EndIf
      EndDo
      If cTipoPed == "1"	// 1=Vale Transporte - 2=Vale Refeicao - 3=Vale Alimentacao
         // Processa Registro Tipo Trailler "TT"
         cOrdem := ZTD->ZTD_CODIGO + "000000000"
         fProcTTPE( cOrdem )
         nRegistros++
      ElseIf cTipoPed == "2"	// 1=Vale Transporte - 2=Vale Refeicao - 3=Vale Alimentacao
         If !lProcTR0	// Papel
            // Processa Registro Tipo Trailler "TT"
            cOrdem := "1" + ZTD->ZTD_CODIGO + "00000000"
            fProcTR1( cOrdem )
            nRegistros++
         EndIf
      EndIf
   EndIf
   WZTB->(dbCloseArea())
   
   dbSelectArea( "ZTD" )
    
   dbSkip()
EndDo
If cTipoPed == "1"	// 1=Vale Transporte - 2=Vale Refeicao - 3=Vale Alimentacao
   // Processa Registro Tipo Trailler "TT"
   cOrdem   := "099999999999999"
   fProcTTTR( cOrdem )
   nTrailler++

   // Processa Registro Tipo "LSUP5"
   cOrdem   := "999999999999999"
   nTrailler++
   fProcLSUP9( cOrdem, 255 )
ElseIf cTipoPed $ "2*3"	// 2=Vale Refeicao - 3=Vale Alimentacao
   // Processa Registro Tipo Trailler "TT"
   If !lProcTRE
      cOrdem   := "099999999999999"
      fProcTRTRE( cOrdem )
      nTrailler++
   EndIf
   If !lProcTR0
      cOrdem   := "199999999999999"
      fProcTR9( cOrdem )
      nTrailler++
   EndIf
   
   // Processa Registro Tipo "LSUP5"
   cOrdem   := "999999999999999"
   nTrailler++
   fProcLSUP9( cOrdem, 164 )
EndIf

// Gera o Arquivo Texto
MsAguarde( {|| fGeraTxt()} , "Processando" , "Aguarde... Gerando Arquivo Texto..." )

fClose( nHdl )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBNGPEP08  บAutor  ณMicrosiga           บ Data ณ  09/27/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fGeraTxt()

 Local cLin := ""
 Local nSeq := 0

 dbSelectArea( "WTMP" )
 dbGoTop()
 Do While !Eof()
 
    If cTipoPed $ "2*3"	// 1=Vale Transporte - 2=Vale Refeicao - 3=Vale Alimentacao
       If Left(WTMP->ASR_TXT,4) == "LSUP"
          cLin := Left(WTMP->ASR_TXT,WTMP->ASR_TAMANH) + cEol
       Else
          nSeq++
          cLin := Left(WTMP->ASR_TXT,WTMP->ASR_TAMANH) + StrZero(nSeq,6) + cEol
       EndIf
    Else
       cLin := Left(WTMP->ASR_TXT,WTMP->ASR_TAMANH) + cEol
    EndIf

    fGravaTxt( cLin )

    dbSkip()
 EndDo
 WTMP->(dbCloseArea())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEP08 บAutor  ณMicrosiga           บ Data ณ  10/26/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fProcLSUP5( cOrdem, nCol )

 Local cHora := SubStr(Time(),1,2)+"."+SubStr(Time(),4,2)+"."+SubStr(Time(),7,2)
 Local cLin  := ""
 Local cSup  := "LAYOUT-01/08/2013"
 
 If cTipoPed == "1"	// 1=Vale Transporte
    cSup  := "LAYOUT-26/07/2013"
 EndIf
 
 cLin := "LSUP5"													// 001 - 005 -> 005 - Tipo do Registro = LSUP5
 cLin += Upper(Left(cUserName,8))									// 006 - 013 -> 008 - Nome do Usuario que Gerou o Pedido
 cLin += Space( 11 )												// 014 - 024 -> 011 - Brancos
 cLin += Dtos(dDataBase)    										// 025 - 032 -> 008 - Data da Geracao do Pedido - AAAAMMDD
 cLin += cHora 														// 033 - 040 -> 008 - Hora da Geracao do Pedido - HH.MM.SS
 cLin += cSup														// 041 - 057 -> 017 - Texto Fixo "LAYOUT-26/07/2013"
 cLin += Space(108)													// 058 - 165 -> 108 - Brancos
 fGravaDbf( cOrdem, cLin, nCol )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEP08 บAutor  ณMicrosiga           บ Data ณ  10/26/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fProcTTHD( cOrdem )

 Local cLin := ""
 
 cLin := "T   "														// 001 - 004 -> 004 - Tipo do Registro = "T   "
 cLin += "A"														// 005 - 005 -> 001 - Fixo "A"
 cLin += Dtos(dDataBase)    										// 006 - 013 -> 008 - Data da Geracao do Pedido - AAAAMMDD
 cLin += "V4.0"														// 014 - 017 -> 004 - Versao do Lay-Out - Fixo "V4.0"
 cLin += Space(60)													// 018 - 077 -> 060 - Brancos
 fGravaDbf( cOrdem, cLin, 77 )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEP08 บAutor  ณMicrosiga           บ Data ณ  10/26/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fProcTTUN( cOrdem )

 Local cLin := ""
 
 cLin := "TTUN"														// 001 - 004 -> 004 - Tipo do Registro = "TTUN"
 cLin += Transform(cCnpj,'@R 99.999.999/9999-99')					// 005 - 022 -> 018 - CNPJ Principal
 cLin += "K."+Dtoc(dDtRef)											// 023 - 032 -> 010 - Numero do Pedido
 cLin += StrZero(Val(ZTD->ZTD_CODIGO),6)							// 033 - 038 -> 006 - Codigo do Local de Entrega
 cLin += PadR(ZTD->ZTD_DESCR,26)									// 039 - 064 -> 026 - Nome do Local de Entrega
 cLin += PadR(ZTD->ZTD_TPEND,4)										// 065 - 068 -> 004 - Tipo do Logradouro
 cLin += PadR(ZTD->ZTD_ENDERE,30)									// 069 - 098 -> 030 - Logradouro
 cLin += PadR(ZTD->ZTD_NUMERO,6)									// 099 - 104 -> 006 - Numero
 cLin += PadR(ZTD->ZTD_COMPL,10)									// 105 - 114 -> 010 - Complemento
 cLin += PadR(ZTD->ZTD_BAIRRO,15)									// 115 - 129 -> 015 - Bairro
 cLin += PadR(ZTD->ZTD_CIDADE,25)									// 130 - 154 -> 025 - Municipio
 cLin += Transform(ZTD->ZTD_CEP,'@R 99999-999')						// 155 - 163 -> 009 - CEP
 cLin += ZTD->ZTD_ESTADO											// 164 - 165 -> 002 - Estado
 cLin += Dtos(dEntrMin)												// 166 - 173 -> 008 - Data Minima de Entrega - "AAAAMMDD"
 cLin += Dtos(dEntrMax)												// 174 - 181 -> 008 - Data Maxima de Entrega - "AAAAMMDD"
 cLin += PadR(ZTD->ZTD_RESP1,20)									// 182 - 201 -> 020 - Responsavel pelo Recebimento
 cLin += StrZero(Val(ZTD->ZTD_FONE1),11)							// 202 - 212 -> 011 - Telefone com DDD
 cLin += PadR(ZTD->ZTD_RAMAL1,4)									// 213 - 216 -> 004 - Ramal
 cLin += If(ZTD->ZTD_ASSINA=="S","S","N")							// 217 - 217 -> 001 - Lista de Assinatura
 cLin += Space(40)													// 218 - 257 -> 040 - Brancos
 cLin += If(ZTD->ZTD_EMBALA=="S","S","N")							// 258 - 258 -> 001 - Embalagens por Departamento
 fGravaDbf( cOrdem, cLin, 258 )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEP08 บAutor  ณMicrosiga           บ Data ณ  10/26/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fProcTTDE( cOrdem )

 Local cLin := ""
 
 cLin := "TTDE"														// 001 - 004 -> 004 - Tipo do Registro = "TTDE"
 cLin += Transform(cCnpj,'@R 99.999.999/9999-99')					// 005 - 022 -> 018 - CNPJ Principal
 cLin += "K."+Dtoc(dDtRef)											// 023 - 032 -> 010 - Numero do Pedido
 cLin += StrZero(Val(ZTD->ZTD_CODIGO),6)							// 033 - 038 -> 006 - Codigo do Local de Entrega
 cLin += Left(WZTB->ZTB_CC,6)										// 039 - 044 -> 006 - Codigo do Centro de Custo (Departamento)
 cLin += PadR(CTT->CTT_DESC01,26)									// 045 - 070 -> 026 - Descricao do Centro de Custo (Departamento)
 cLin += Space(20)													// 071 - 090 -> 020 - Brancos
 cLin += Transform(cCnpj,'@R 99.999.999/9999-99')					// 091 - 108 -> 018 - CNPJ do Faturamento
 fGravaDbf( cOrdem, cLin, 108 )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEP08 บAutor  ณMicrosiga           บ Data ณ  10/26/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fProcTTFU( cOrdem, cMatFunc )

 Local cLin := ""
 
 cLin := "TTFU"														// 001 - 004 -> 004 - Tipo do Registro = "TTFU"
 cLin += Transform(cCnpj,'@R 99.999.999/9999-99')					// 005 - 022 -> 018 - CNPJ Principal
 cLin += "K."+Dtoc(dDtRef)											// 023 - 032 -> 010 - Numero do Pedido
 cLin += StrZero(Val(ZTD->ZTD_CODIGO),6)							// 033 - 038 -> 006 - Codigo do Local de Entrega
 cLin += Left(WZTB->ZTB_CC,6)										// 039 - 044 -> 006 - Codigo do Centro de Custo (Departamento)
 cLin += cMatFunc													// 045 - 056 -> 012 - Matricula do Funcionario
 cLin += PadR(SRA->RA_NOME,30)										// 057 - 086 -> 030 - Nome do Funcionario
 cLin += PadR(SRA->RA_RG,10)										// 087 - 096 -> 010 - RG
 cLin += SRA->RA_CIC												// 097 - 107 -> 011 - CPF
 cLin += Space(04)													// 108 - 111 -> 004 - Brancos
 cLin += Dtos(SRA->RA_NASC)											// 112 - 119 -> 008 - Data Nascimento
 cLin += SRA->RA_RGUF												// 120 - 121 -> 002 - Estado Emissor do RG
 cLin += SRA->RA_SEXO												// 122 - 122 -> 001 - Sexo
 cLin += PadR(SRA->RA_MAE,30)										// 123 - 152 -> 030 - Nome da Mae
 cLin += Space(05)													// 153 - 157 -> 005 - Tipo de Logradouro
 cLin += PadR(SRA->RA_ENDEREC,40)									// 158 - 197 -> 040 - Logradouro
 cLin += Space(06)													// 198 - 203 -> 006 - Numero de Logradouro
 cLin += PadR(SRA->RA_COMPLEM,15)									// 204 - 218 -> 015 - Complemento
 cLin += PadR(SRA->RA_MUNICIP,40)									// 219 - 258 -> 040 - Municipio
 cLin += PadR(SRA->RA_BAIRRO,30)									// 259 - 288 -> 030 - Bairro
 cLin += SRA->RA_CEP												// 289 - 296 -> 008 - CEP
 cLin += SRA->RA_ESTADO												// 297 - 298 -> 002 - Estado
 cLin += "000201"													// 299 - 304 -> 004 - Fixo "000201"
 fGravaDbf( cOrdem, cLin, 304 )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEP08 บAutor  ณMicrosiga           บ Data ณ  10/26/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fProcTTIT( cOrdem, cMatFunc )

 Local cLin := ""
 
 cLin := "TTIT"														// 001 - 004 -> 004 - Tipo do Registro = "TTIT"
 cLin += Transform(cCnpj,'@R 99.999.999/9999-99')					// 005 - 022 -> 018 - CNPJ Principal
 cLin += "K."+Dtoc(dDtRef)											// 023 - 032 -> 010 - Numero do Pedido
 cLin += StrZero(Val(ZTD->ZTD_CODIGO),6)							// 033 - 038 -> 006 - Codigo do Local de Entrega
 cLin += Left(WZTB->ZTB_CC,6)										// 039 - 044 -> 006 - Codigo do Centro de Custo (Departamento)
 cLin += cMatFunc													// 045 - 056 -> 012 - Matricula do Funcionario
 cLin += StrZero(nSequenc,3)										// 057 - 059 -> 003 - Sequencia dos Itens de Pedido do Funcionario
 //cLin += StrZero(WZTB->ZTB_DIACAL,8)								// 060 - 067 -> 008 - Quantidade de Bilhetes/Viagens
 cLin += StrZero(WZTB->ZTB_QDEVAL,8)								// 060 - 067 -> 008 - Quantidade de Bilhetes/Viagens
 cLin += StrZero(WZTB->ZTB_VUNIATU,9,2)							// 068 - 076 -> 009 - Valor Unitario da Tarifa
 cLin += PadR(WZTB->ZTB_TKCDOP,6)									// 077 - 082 -> 006 - Codigo da Operadora
 cLin += PadR(WZTB->ZTB_TKCDBL,12)									// 083 - 094 -> 012 - Codigo do Bilhete
 cLin += PadR(WZTB->ZTB_TKTPBL,4)									// 095 - 098 -> 004 - Tipo do Bilhete
 cLin += "N"														// 099 - 099 -> 001 - Flag para Uso da Ticket
 fGravaDbf( cOrdem, cLin, 99 )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEP08 บAutor  ณMicrosiga           บ Data ณ  10/26/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fProcTTPE( cOrdem )

 Local cLin := ""
 
 nServPedid := Round( nValPedido * (nValKit/100),2 ) + Round( nLocEntreg * nValPon,2 )
 
 cLin := "TTPE"														// 001 - 004 -> 004 - Tipo do Registro = "TTPE"
 cLin += Transform(cCnpj,'@R 99.999.999/9999-99')					// 005 - 022 -> 018 - CNPJ Principal
 cLin += "K."+Dtoc(dDtRef)											// 023 - 032 -> 010 - Numero do Pedido
 cLin += StrZero(nLocEntreg,4)										// 033 - 036 -> 004 - Quantidade de Locais de Entrega
 cLin += StrZero(nDepPedido,4)										// 037 - 040 -> 004 - Quantidade de Departamentos
 cLin += StrZero(nFunPedido,5)										// 041 - 045 -> 005 - Quantidade de Funcionarios
 cLin += StrZero(nItePedido,6)										// 046 - 051 -> 006 - Quantidade de Itens do Pedido
 cLin += StrZero(nServPedid,16,2)									// 052 - 067 -> 016 - Valor Total das Taxas de Servico
 cLin += StrZero(nValPedido,16,2)									// 068 - 083 -> 016 - Valor Total dos Bilhetes do Pedido
 cLin += Dtos(dDataBase)											// 084 - 091 -> 008 - Data de Geracao do Pedido - AAAAMMDD
 cLin += Space(1)													// 092 - 092 -> 001 - Brancos
 cLin += Dtos(dUsoDe)												// 093 - 100 -> 008 - Periodo de Utilizacao DE - AAAAMMDD
 cLin += Dtos(dUsoAte)												// 101 - 108 -> 008 - Periodo de Utilizacao ATE - AAAAMMDD
 cLin += StrZero(nValKit,12,2)										// 109 - 120 -> 012 - Preco do Kit
 cLin += StrZero(nValPon,12,2)										// 121 - 132 -> 012 - Preco por Ponto de Entrega
 cLin += "N"														// 133 - 133 -> 001 - Tipo de Pedido - Fixo "N"
 cLin += StrZero(nLocEntreg,4)										// 134 - 137 -> 004 - Quantidade de Unidades de Entrega Pagas
 cLin += "A"														// 138 - 138 -> 001 - Ordem dos Funcionarios
 cLin += "P"														// 139 - 139 -> 001 - Fixo "P"
 cLin += "%  "														// 140 - 142 -> 003 - Moeda do Kit - Fixo "%  "
 cLin += "R$ "														// 143 - 145 -> 003 - Moeda de Entrega - Fixo "R$ "
 fGravaDbf( cOrdem, cLin, 145 )

 nLocEntreg := 0  ; nDepPedido := 0  ; nFunPedido := 0
 nItePedido := 0  ; nServPedid := 0  ; nValPedido := 0

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEP08 บAutor  ณMicrosiga           บ Data ณ  10/26/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fProcTTTR( cOrdem )

 Local cLin := ""
 
 cLin := "9999"														// 001 - 004 -> 004 - Tipo do Registro = "TTIT"
 cLin += StrZero(nHeader+nTrailler+nRegistros+2,8)					// 005 - 012 -> 008 - Quantidade Total de Registros do Produto
 cLin += Space(152)													// 013 - 164 -> 152 - Brancos
 fGravaDbf( cOrdem, cLin, 164 )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEP08 บAutor  ณMicrosiga           บ Data ณ  10/26/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fProcLSUP9( cOrdem, nCol )

 Local cLin := ""
 
 cLin := "LSUP9"													// 001 - 005 -> 005 - Tipo do Registro = "LSUP9"
 cLin += StrZero(nHeader,8)											// 006 - 013 -> 008 - Quantidade Total de Registros Header
 cLin += StrZero(nTrailler,8)										// 014 - 021 -> 008 - Quantidade Total de Registros Trailler
 cLin += StrZero(nRegistros,8)										// 022 - 029 -> 008 - Quantidade Total dos Demais Registros
 If cTipoPed == "1"	// 1=Vale Transporte
    cLin += Space(226)												// 030 - 255 -> 226 - Brancos
 Else
    cLin += Space(277)												// 030 - 306 -> 277 - Brancos
 EndIf
 fGravaDbf( cOrdem, cLin, nCol )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEP08 บAutor  ณMicrosiga           บ Data ณ  10/26/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fProcTRE( cOrdem )

 Local cTipProd := "A"		// 3=Vale Alimentacao
 Local cTipCart := "33"		// 33=TAE Magnetico
 Local cLin     := ""

 If cTipoPed == "2"
    cTipProd := "R"		// 2=Vale Refeicao
    cTipCart := "34"	// 34=TRE Magnetico
 EndIf
 
 cLin := "T"														// 001 - 001 -> 001 - Tipo do Produto = "T"
 cLin += cTipProd													// 002 - 002 -> 001 - Produto A=Alimentacao - R=Refeicao
 cLin += "02"      													// 003 - 004 -> 002 - Fixo "02"
 cLin += "0"      													// 005 - 005 -> 001 - Tipo do Registro = "0"
 cLin += cTipProd													// 006 - 006 -> 001 - Produto A=Alimentacao - R=Refeicao
 cLin += StrZero(Val(cContrato),10)									// 007 - 016 -> 010 - Codigo do Contrato
 cLin += PadR(cNomeEmp,24)											// 017 - 040 -> 024 - Nome da Empresa
 cLin += Space(6) 													// 041 - 046 -> 006 - Brancos
 cLin += Dtos(dDtPed) 												// 047 - 054 -> 008 - Data do Pedido
 cLin += Dtos(dDtLib) 												// 055 - 062 -> 008 - Data de Liberacao do Pedido
 cLin += "C"      													// 063 - 063 -> 001 - Tipo do Pedido = "C"
 cLin += Space(16) 													// 064 - 079 -> 016 - Brancos
 cLin += StrZero(Month(dDtRef),2) 									// 080 - 081 -> 002 - Mes de Referencia
 cLin += Space(19) 													// 082 - 100 -> 019 - Brancos
 cLin += "04"      													// 101 - 102 -> 002 - Tipo do Layout = "04"
 cLin += cTipCart													// 103 - 104 -> 002 - Tipo do Cartao 33=TAE - 34=TRE
 cLin += Space(48) 													// 105 - 152 -> 048 - Brancos
 cLin += "SUP   " 													// 153 - 158 -> 006 - Fixo "SUP"
 cLin += Space(6)													// 159 - 164 -> 006 - Sequencial
 fGravaDbf( cOrdem, cLin, 158 )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEP08 บAutor  ณMicrosiga           บ Data ณ  10/26/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fProcTR0( cOrdem )

 Local cLin := ""

 cLin := "TR01"														// 001 - 004 -> 004 - Tipo do Produto = "TR01"
 cLin += "0"      													// 005 - 005 -> 001 - Tipo do Registro = "0"
 cLin += "R"														// 006 - 006 -> 001 - Produto R=Ticket Restaurante
 cLin += StrZero(Val(cContrato),10)									// 007 - 016 -> 010 - Codigo do Contrato
 cLin += PadR(cNomeEmp,30)											// 017 - 046 -> 030 - Nome da Empresa
 cLin += Dtos(dDataBase)											// 047 - 054 -> 008 - Data do Pedido
 cLin += Dtos(dDtLib) 												// 055 - 062 -> 008 - Data de Liberacao do Pedido
 cLin += "A"      													// 063 - 063 -> 001 - Tipo do Pedido = "A"
 cLin += Space(1) 													// 064 - 064 -> 001 - Brancos
 cLin += "N"      													// 065 - 065 -> 001 - Relatorio de Assinaturas S/N
 cLin += "1"      													// 066 - 066 -> 001 - Conteudo Personalizado
 cLin += "6"      													// 067 - 067 -> 001 - Conteudo Personalizado
 cLin += "0"      													// 068 - 068 -> 001 - Conteudo Personalizado
 cLin += "0"      													// 069 - 069 -> 001 - Conteudo Personalizado
 cLin += "N"      													// 070 - 070 -> 001 - Recibo Encarte
 cLin += "N"      													// 071 - 071 -> 001 - Relatorio Gerencial
 cLin += "N"      													// 072 - 072 -> 001 - Resumo de Unidades
 cLin += Space(7) 													// 073 - 079 -> 007 - Brancos
 cLin += StrZero(Month(dDtRef),2) 									// 080 - 081 -> 002 - Mes de Referencia
 cLin += Space(19) 													// 082 - 100 -> 019 - Brancos
 cLin += "04"      													// 101 - 102 -> 002 - Tipo do Layout = "04"
 cLin += Space(48) 													// 103 - 158 -> 056 - Brancos
 cLin += Space(6)													// 159 - 164 -> 006 - Sequencial
 fGravaDbf( cOrdem, cLin, 158 )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEP08 บAutor  ณMicrosiga           บ Data ณ  10/26/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fProcTR1( cOrdem )

 Local cLin := ""
 
 nServPedid := Round( nValPedido * (nValKit/100),2 ) + Round( nLocEntreg * nValPon,2 )
 
 cLin := "TR01"														// 001 - 004 -> 004 - Tipo do Produto = "TR01"
 cLin += "1"      													// 005 - 005 -> 001 - Tipo do Registro = "1"
 cLin += StrZero(0,6)												// 006 - 011 -> 006 - Total de Tickets Solicitados
 cLin += StrZero(0*100,9)											// 012 - 020 -> 009 - Valor Unitario do Ticket ?
 cLin += "R"														// 021 - 021 -> 001 - Produto "R" Ticket Restaurante
 cLin += "C"      													// 022 - 022 -> 001 - Acabamento C=Carne
 cLin += "99"														// 023 - 024 -> 002 - Tickets (Folhas) por Carne ?
 cLin += StrZero(Val(ZTD->ZTD_CODIGO),6)							// 025 - 030 -> 006 - Codigo Unidade de Entrega
 cLin += PadR(ZTD->ZTD_DESCR,20)									// 031 - 050 -> 020 - Descricao do Local de Entrega
 cLin += Space(108) 												// 051 - 158 -> 108 - Brancos
 cLin += Space(6)													// 159 - 164 -> 006 - Sequencial
 fGravaDbf( cOrdem, cLin, 158 )

 nLocEntreg := 0  ; nDepPedido := 0  ; nFunPedido := 0
 nItePedido := 0  ; nServPedid := 0  ; nValPedido := 0

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEP08 บAutor  ณMicrosiga           บ Data ณ  10/26/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fProcTR2( cOrdem )

 Local cLin := ""

 cLin := "TR01"														// 001 - 004 -> 004 - Tipo do Produto = "TR01"
 cLin += "2"      													// 005 - 005 -> 001 - Tipo do Registro = "2"
 cLin += StrZero(Val(ZTD->ZTD_CODIGO),6)							// 006 - 011 -> 006 - Codigo Unidade de Entrega
 cLin += PadR(ZTD->ZTD_DESCR,20)									// 012 - 031 -> 020 - Descricao do Local de Entrega
 cLin += PadR(ZTD->ZTD_TPEND,4)									    // 032 - 035 -> 004 - Tipo do Endereco
 cLin += PadR(ZTD->ZTD_ENDERE,30)									// 036 - 065 -> 030 - Endereco
 cLin += PadR(ZTD->ZTD_NUMERO,6)									// 066 - 071 -> 006 - Numero
 cLin += PadR(ZTD->ZTD_COMPL,10)									// 072 - 081 -> 010 - Complemento
 cLin += PadR(ZTD->ZTD_CIDADE,25)									// 082 - 106 -> 025 - Cidade
 cLin += PadR(ZTD->ZTD_BAIRRO,15)									// 107 - 121 -> 015 - Bairro
 cLin += Left(ZTD->ZTD_CEP,5)								 		// 122 - 126 -> 005 - CEP
 cLin += ZTD->ZTD_ESTADO									 		// 127 - 128 -> 002 - Estado
 cLin += PadR(ZTD->ZTD_RESP1,20)									// 129 - 148 -> 020 - Nome do Recebedor
 cLin += Right(ZTD->ZTD_CEP,3)								 		// 149 - 151 -> 003 - CEP
 cLin += Space(7) 													// 152 - 158 -> 007 - Brancos
 cLin += Space(6)													// 159 - 164 -> 006 - Sequencial
 fGravaDbf( cOrdem, cLin, 158 )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEP08 บAutor  ณMicrosiga           บ Data ณ  10/26/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fProcTR3( cOrdem, cMatFunc )

 Local cLin := ""

 cLin := "TR01"														// 001 - 004 -> 004 - Tipo do Produto = "TR01"
 cLin += "3"      													// 005 - 005 -> 001 - Tipo do Registro = "3"
 cLin += Left(WZTB->ZTB_CC,06)										// 006 - 011 -> 006 - Codigo do Centro de Custo (Departamento)
 cLin += PadR(CTT->CTT_DESC01,20)									// 012 - 031 -> 020 - Descricao do Centro de Custo (Departamento)
 cLin += cMatFunc													// 032 - 043 -> 012 - Codigo do Funcionario
 cLin += Space(26)													// 044 - 069 -> 026 - Conteudo Livre
 cLin += StrZero(Val(ZTD->ZTD_CODIGO),6)							// 070 - 075 -> 006 - Codigo Unidade de Entrega
 cLin += PadR(ZTD->ZTD_DESCR,20)									// 076 - 095 -> 020 - Descricao do Local de Entrega
 cLin += "000"														// 096 - 098 -> 003 - Total de Tickets do Funcionario ?
 cLin += "99"														// 099 - 100 -> 002 - Tickets (Folhas) por Carne ?
 cLin += StrZero(WZTB->ZTB_TTVALE*100,9)							// 101 - 109 -> 009 - Valor Unitario do Ticket ?
 cLin += "R"      													// 110 - 110 -> 001 - Fixo "R" - Ticket Restaurante
 cLin += "C"      													// 111 - 111 -> 001 - Acabamento C=Carne
 cLin += PadR(SRA->RA_NOME,30)										// 112 - 141 -> 030 - Nome do Funcionario
 cLin += Space(17) 													// 142 - 154 -> 017 - Brancos
 cLin += Space(6)													// 159 - 164 -> 006 - Sequencial
 fGravaDbf( cOrdem, cLin, 158 )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEP08 บAutor  ณMicrosiga           บ Data ณ  10/26/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fProcTR9( cOrdem )

 Local cLin := ""
 
 cLin := "TR01"														// 001 - 004 -> 004 - Tipo do Produto = "TR01"
 cLin += "9"      													// 005 - 005 -> 001 - Tipo do Registro = "9"
 cLin += StrZero(0,6)												// 006 - 013 -> 008 - Total de Tickets Solicitados
 cLin += StrZero(0*100,14)											// 014 - 027 -> 014 - Somatoria Total do Valor dos Tickets
 cLin += Space(131) 												// 028 - 158 -> 131 - Brancos
 cLin += Space(6)													// 159 - 164 -> 006 - Sequencial
 fGravaDbf( cOrdem, cLin, 158 )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEP08 บAutor  ณMicrosiga           บ Data ณ  10/26/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fProcUNTRE( cOrdem )

 Local cTipProd := "A"		// 3=Vale Alimentacao
 Local cTipCart := "33"		// 33=TAE Magnetico
 Local cLin     := ""

 If cTipoPed == "2"
    cTipProd := "R"		// 2=Vale Refeicao
    cTipCart := "34"	// 34=TRE Magnetico
 EndIf
 
 cLin := "T"														// 001 - 001 -> 001 - Tipo do Produto = "T"
 cLin += cTipProd													// 002 - 002 -> 001 - Produto A=Alimentacao - R=Refeicao
 cLin += "02"      													// 003 - 004 -> 002 - Fixo "02"
 cLin += "2"      													// 005 - 005 -> 001 - Tipo do Registro = "2"
 cLin += PadR(ZTD->ZTD_DESCR,26)									// 006 - 031 -> 026 - Descricao do Local de Entrega
 cLin += PadR(ZTD->ZTD_TPEND,4)									    // 032 - 035 -> 004 - Tipo do Endereco
 cLin += PadR(ZTD->ZTD_ENDERE,30)									// 036 - 065 -> 030 - Endereco
 cLin += PadR(ZTD->ZTD_NUMERO,6)									// 066 - 071 -> 006 - Numero
 cLin += PadR(ZTD->ZTD_COMPL,10)									// 072 - 081 -> 010 - Complemento
 cLin += PadR(ZTD->ZTD_CIDADE,25)									// 082 - 106 -> 025 - Cidade
 cLin += PadR(ZTD->ZTD_BAIRRO,15)									// 107 - 121 -> 015 - Bairro
 cLin += Left(ZTD->ZTD_CEP,5)								 		// 122 - 126 -> 005 - CEP
 cLin += ZTD->ZTD_ESTADO									 		// 127 - 128 -> 002 - Estado
 cLin += PadR(ZTD->ZTD_RESP1,20)									// 129 - 148 -> 020 - Nome do Recebedor
 cLin += Right(ZTD->ZTD_CEP,3)								 		// 149 - 151 -> 003 - CEP
 cLin += Space(7) 													// 152 - 158 -> 007 - Brancos
 cLin += Space(6)													// 159 - 164 -> 006 - Sequencial
 fGravaDbf( cOrdem, cLin, 158 )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEP08 บAutor  ณMicrosiga           บ Data ณ  10/26/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fProcFUTRE( cOrdem, cMatFunc )

 Local cTipProd := "A"		// 3=Vale Alimentacao
 Local cTipCart := "33"		// 33=TAE Magnetico
 Local cLin     := ""

 If cTipoPed == "2"
    cTipProd := "R"		// 2=Vale Refeicao
    cTipCart := "34"	// 34=TRE Magnetico
 EndIf
 
 cLin := "T"														// 001 - 001 -> 001 - Tipo do Produto = "T"
 cLin += cTipProd													// 002 - 002 -> 001 - Produto A=Alimentacao - R=Refeicao
 cLin += "02"      													// 003 - 004 -> 002 - Fixo "02"
 cLin += "3"      													// 005 - 005 -> 001 - Tipo do Registro = "3"
 cLin += PadR(WZTB->ZTB_CC,26)										// 006 - 031 -> 026 - Codigo do Centro de Custo (Departamento)
 cLin += cMatFunc													// 032 - 043 -> 012 - Codigo do Funcionario
 cLin += U_fConvData( SRA->RA_NASC, "DDMMAAAA" )					// 044 - 051 -> 008 - Data de Nascimento
 cLin += Space(18) 													// 052 - 069 -> 018 - Brancos
 cLin += PadR(ZTD->ZTD_DESCR,26)									// 070 - 095 -> 026 - Descricao do Local de Entrega
 cLin += "00101"													// 096 - 100 -> 005 - Fixo "00101"
 cLin += StrZero(WZTB->ZTB_TTVALE*100,9)							// 101 - 109 -> 009 - Valor do Beneficio
 cLin += cTipProd													// 110 - 110 -> 001 - Produto A=Alimentacao - R=Refeicao
 cLin += "E"      													// 111 - 111 -> 001 - Fixo "E" - Eletronico
 cLin += PadR(SRA->RA_NOME,30)										// 112 - 141 -> 030 - Nome do Funcionario
 cLin += Space(24) 													// 142 - 158 -> 017 - Brancos
 cLin += Space(6)													// 159 - 164 -> 006 - Sequencial
 fGravaDbf( cOrdem, cLin, 158 )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEP08 บAutor  ณMicrosiga           บ Data ณ  10/26/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fProcTRTRE( cOrdem )

 Local cTipProd := "A"		// 3=Vale Alimentacao
 Local cTipCart := "33"		// 33=TAE Magnetico
 Local cLin     := ""

 If cTipoPed == "2"
    cTipProd := "R"		// 2=Vale Refeicao
    cTipCart := "34"	// 34=TRE Magnetico
 EndIf
 
 cLin := "T"														// 001 - 001 -> 001 - Tipo do Produto = "T"
 cLin += cTipProd													// 002 - 002 -> 001 - Produto A=Alimentacao - R=Refeicao
 cLin += "02"      													// 003 - 004 -> 002 - Fixo "02"
 cLin += "9"      													// 005 - 005 -> 001 - Tipo do Registro = "9"
 cLin += StrZero(nItePedido,8)										// 006 - 013 -> 008 - Total de Funcionarios
 cLin += StrZero(nValPedido*100,14)									// 014 - 027 -> 014 - Valor Total dos Beneficios
 cLin += Space(131) 												// 028 - 158 -> 131 - Brancos
 cLin += Space(6)													// 159 - 164 -> 006 - Sequencial
 fGravaDbf( cOrdem, cLin, 158 )

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
ฑฑบPrograma  ณ BNGPEP08 บAutor  ณMicrosiga           บ Data ณ  10/26/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fArqTemp()

 Local aOld    := GETAREA()
 Local aCampos := {}
 Local cArqDbf
 Local cArqNtx

 Aadd(aCampos,{ "ASR_CHAVE"  , "C" , 0015 , 0 })
 Aadd(aCampos,{ "ASR_TXT"    , "C" , 0350 , 0 })
 Aadd(aCampos,{ "ASR_TAMANH" , "N" , 0008 , 0 })

 cArqDbf := CriaTrab( aCampos, .T. )
 dbUseArea( .T.,, cArqDbf, "WTMP", .F. )

 cArqNtx := CriaTrab( Nil, .F. )
 IndRegua( "WTMP", cArqNtx, "ASR_CHAVE", , , "Selecionando registros..." )
 
 RESTAREA( aOld )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEP08 บAutor  ณMicrosiga           บ Data ณ  10/26/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fGravaDbf( cOrdem, cLin, nTamanho )

 Local aOld := GETAREA()
 
 dbSelectArea( "WTMP" )
 RecLock("WTMP",.T.)
  WTMP->ASR_CHAVE  := cOrdem
  WTMP->ASR_TXT    := cLin
  WTMP->ASR_TAMANH := nTamanho
 MsUnlock()

 RESTAREA( aOld )
 
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBNGPEP08  บAutor  ณMicrosiga           บ Data ณ  06/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fEstCivil( cEstCivil )

Local cRet := " "

If cEstCivil == "S"			; cRet := "S"
ElseIf cEstCivil $ "CMV"	; cRet := "C"
ElseIf cEstCivil $ "DQ"		; cRet := "D"
EndIf

Return( cRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBNGPEP08  บAutor  ณMicrosiga           บ Data ณ  09/20/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fSx1Del( __cPerg, __cOrdem )

 Local aOldAtu := GETAREA()
 Local aOldSx1 := SX1->( GETAREA() )

 __cPerg := PadR( __cPerg,Len( SX1->X1_GRUPO ) )

 dbSelectArea( "SX1" )
 dbSetOrder( 1 )
 dbSeek( __cPerg + __cOrdem )
 Do While !Eof() .And. SX1->X1_GRUPO == __cPerg
    RecLock("SX1",.F.)
     dbDelete()
    MsUnlock()
    
    dbSkip()
 EndDo

 RESTAREA( aOldSx1 )
 RESTAREA( aOldAtu )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfX2CompartบAutor  ณ Adilson Silva      บ Data ณ 13/02/2008  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna o Tipo do Acesso das Tabelas do Sistema.           บฑฑ
ฑฑบ          ณ Exclusivo ou Compartilhado.                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fX2Compart( cTab )

 Local lRet    := .T.
 Local aOldAtu := GETAREA()
 Local aOldSx2 := SX2->(GETAREA())
 
 DEFAULT cTab  := "SRA"
 
 SX2->(dbSetOrder( 1 ))
 If SX2->(dbSeek( cTab ))
    If SX2->X2_MODO == "C"
       lRet := .T.
    Else
       lRet := .F.
    EndIf
 EndIf

 RESTAREA( aOldSx2 )
 RESTAREA( aOldAtu )

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBNGPEP04  บAutor  ณMicrosiga           บ Data ณ  06/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fMtaEmpresa( c_Filial, c_Cnpj, c_NomeEmp )

 Local aOldAtu := GETAREA()
 Local aOldSm0 := SM0->(GETAREA())
 
 If SM0->(dbSeek( cEmpAnt + c_Filial ))
    c_Cnpj    := SM0->M0_CGC
    c_NomeEmp := SM0->M0_NOMECOM
 EndIf

 RESTAREA( aOldSm0 )
 RESTAREA( aOldAtu )
 
Return

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

 Local lEntrFil := GETMV("GP_ENTRFIL",,"N") == "S"
 Local lCttFil  := fX2Compart( "CTT" )
 Local cQuery   := ""
 Local cTipAlim := If(cTipoPed=="2","1",If(cTipoPed=="3","2",""))

 If lEntrFil
    If cTipoPed $ "2*3"	// 2=Vale Refeicao - 3=Vale Alimentacao
       cQuery += " SELECT ZT7.ZT7_FILIAL AS ZTB_FILIAL,"
       cQuery += "        ZT7.ZT7_MAT    AS ZTB_MAT,"
       cQuery += "        ZT7.ZT7_COD    AS ZTB_COD,"
       cQuery += "        0              AS ZTB_QDEDIA,"
       cQuery += "        ZT7.ZT7_DIACAL AS ZTB_DIACAL,"
       cQuery += "        0              AS ZTB_QDEVAL,"
       cQuery += "        ZT7.ZT7_VLVALE AS ZTB_VLVALE,"
       cQuery += "        ZT7.ZT7_TTVALE AS ZTB_TTVALE,"
       cQuery += "        0              AS ZTB_VLDIFE,"
       cQuery += "        0              AS ZTB_VUNIAT,"
       cQuery += "        ZT8.ZT8_TKCDOP AS ZTB_TKCDOP,"
       cQuery += "        ZT8.ZT8_TKCDBL AS ZTB_TKCDBL,"
       cQuery += "        ZT8.ZT8_TKTPBL AS ZTB_TKTPBL,"
       cQuery += "        SRA.RA_CC      AS ZTB_CC,"
       cQuery += "        CTT." + cEntrCtt + " AS ZTB_LOCENT,"
       cQuery += "        SRA." + cEntrSra + " AS ZTB_LOCSRA,"
       cQuery += "        ZT7.R_E_C_N_O_ AS ZT7_RECNO,"
       cQuery += "        0              AS ZTB_RECNO,"
       cQuery += "        'AL'           AS ZTB_BENEF,"
       cQuery += "        ZT8.ZT8_TIPO   AS ZTB_TIPO,"
       cQuery += "        ZT8.ZT8_TKTPRO AS ZTB_TKTPRO"
       cQuery += " FROM " + RetSqlName( "ZT7" ) + " ZT7"
       cQuery += " LEFT OUTER JOIN " + RetSqlName( "SRA" ) + " SRA ON SRA.RA_FILIAL = ZT7.ZT7_FILIAL AND SRA.RA_MAT = ZT7.ZT7_MAT"
       cQuery += " LEFT OUTER JOIN " + RetSqlName( "CTT" ) + " CTT ON CTT.CTT_CUSTO = SRA.RA_CC"
       cQuery += " LEFT OUTER JOIN " + RetSqlName( "ZT8" ) + " ZT8 ON ZT7.ZT7_COD = ZT8.ZT8_COD"
       cQuery += " WHERE  ZT7.D_E_L_E_T_ <> '*'"
       cQuery += "    AND SRA.D_E_L_E_T_ <> '*'"
       cQuery += "    AND CTT.D_E_L_E_T_ <> '*'"
       cQuery += "    AND ZT8.D_E_L_E_T_ <> '*'"
       cQuery += "    AND ZT7.ZT7_FILIAL BETWEEN '" + cFilDe + "' AND '" + cFilAte + "'"
       cQuery += "    AND ZT7.ZT7_MAT BETWEEN '" + cMatDe + "' AND '" + cMatAte + "'"
       cQuery += "    AND ZT7.ZT7_CC BETWEEN '" + cCcDe + "' AND '" + cCcAte + "'"
       cQuery += "    AND ZT7.ZT7_TTVALE > 0"
       cQuery += "    AND ZT7.ZT7_DATARQ = '" + cDatarq + "'"
       cQuery += "    AND ZT7.ZT7_STATUS = '1'"
       cQuery += "    AND ZT7.ZT7_PERIOD = '" + cPeriodo + "'"
       cQuery += "    AND SRA.RA_SITFOLH <> 'D'"
       cQuery += "    AND SRA.RA_FILIAL = '" + ZTD->ZTD_FILENT + "'"
       cQuery += "    AND ZT8.ZT8_FORN = '" + cCodForn + "'"
       cQuery += "    AND ZT8.ZT8_TIPO = '" + cTipAlim + "'"
       If lReproc
          cQuery += " AND ZT7.ZT7_PEDIDO IN ('1','5')"		// 1=Pedido Compra - 2=Pagto Folha - 3=Pagto Adto - 4=Gerar CNAB - 5=Pedido Efetuado - 6=CNAB Gerado
       Else
          cQuery += " AND ZT7.ZT7_PEDIDO = '1'"
       EndIf
    ElseIf cTipoPed == "1"	// 1=Vale Transporte
       cQuery += " SELECT ZTB.ZTB_FILIAL,"
       cQuery += "        ZTB.ZTB_MAT,"
       cQuery += "        ZTB.ZTB_COD,"
       cQuery += "        ZTB.ZTB_QDEDIA,"
       cQuery += "        ZTB.ZTB_DIACAL,"
       cQuery += "        ZTB.ZTB_QDEVAL,"
       cQuery += "        ZTB.ZTB_VLVALE,"
       cQuery += "        ZTB.ZTB_TTVALE,"
       cQuery += "        ZTB.ZTB_VLDIFE,"
       cQuery += "        SRN.RN_VUNIATU AS ZTB_VUNIAT,"
       cQuery += "        SRN.RN_TKCDOP  AS ZTB_TKCDOP,"
       cQuery += "        SRN.RN_TKCDBL  AS ZTB_TKCDBL,"
       cQuery += "        SRN.RN_TKTPBL  AS ZTB_TKTPBL,"
       cQuery += "        SRA.RA_CC      AS ZTB_CC,"
       cQuery += "        CTT." + cEntrCtt + " AS ZTB_LOCENT,"
       cQuery += "        SRA." + cEntrSra + " AS ZTB_LOCSRA,"
       cQuery += "        0              AS ZT7_RECNO,"
       cQuery += "        ZTB.R_E_C_N_O_ AS ZTB_RECNO,"
       cQuery += "        'VT'           AS ZTB_BENEF,"
       cQuery += "        ''             AS ZTB_TIPO,"
       cQuery += "        ''             AS ZTB_TKTPRO"
       cQuery += " FROM " + RetSqlName( "ZTB" ) + " ZTB"
       cQuery += " LEFT OUTER JOIN " + RetSqlName( "SRA" ) + " SRA ON SRA.RA_FILIAL = ZTB.ZTB_FILIAL AND SRA.RA_MAT = ZTB.ZTB_MAT"
       cQuery += " LEFT OUTER JOIN " + RetSqlName( "CTT" ) + " CTT ON CTT.CTT_CUSTO = SRA.RA_CC"
       cQuery += " LEFT OUTER JOIN " + RetSqlName( "SRN" ) + " SRN ON ZTB.ZTB_COD = SRN.RN_COD"
       cQuery += " WHERE  ZTB.D_E_L_E_T_ <> '*'"
       cQuery += "    AND SRA.D_E_L_E_T_ <> '*'"
       cQuery += "    AND CTT.D_E_L_E_T_ <> '*'"
       cQuery += "    AND SRN.D_E_L_E_T_ <> '*'"
       cQuery += "    AND ZTB.ZTB_FILIAL BETWEEN '" + cFilDe + "' AND '" + cFilAte + "'"
       cQuery += "    AND ZTB.ZTB_MAT BETWEEN '" + cMatDe + "' AND '" + cMatAte + "'"
       cQuery += "    AND ZTB.ZTB_CC BETWEEN '" + cCcDe + "' AND '" + cCcAte + "'"
       cQuery += "    AND ZTB.ZTB_TTVALE > 0"
       cQuery += "    AND ZTB.ZTB_DATARQ = '" + cDatarq + "'"
       cQuery += "    AND ZTB.ZTB_STATUS = '1'"
       cQuery += "    AND ZTB.ZTB_PERIOD = '" + cPeriodo + "'"
       cQuery += "    AND SRA.RA_SITFOLH <> 'D'"
       cQuery += "    AND SRA.RA_FILIAL = '" + ZTD->ZTD_FILENT + "'"
       cQuery += "    AND SRN.RN_FORN = '" + cCodForn + "'"
       If lReproc
          cQuery += " AND ZTB.ZTB_PEDIDO IN ('1','5')"     // 1=Pedido Compra - 2=Pagto Folha - 3=Pagto Adto - 4=Gerar CNAB - 5=Pedido Efetuado - 6=CNAB Gerado
       Else
          cQuery += " AND ZTB.ZTB_PEDIDO = '1'"
       EndIf
    EndIf
 Else
    If cTipoPed $ "2*3"	// 2=Vale Refeicao - 3=Vale Alimentacao
       cQuery += " SELECT ZT7.ZT7_FILIAL AS ZTB_FILIAL,"
       cQuery += "        ZT7.ZT7_MAT    AS ZTB_MAT,"
       cQuery += "        ZT7.ZT7_COD    AS ZTB_COD,"
       cQuery += "        0              AS ZTB_QDEDIA,"
       cQuery += "        ZT7.ZT7_DIACAL AS ZTB_DIACAL,"
       cQuery += "        0              AS ZTB_QDEVAL,"
       cQuery += "        ZT7.ZT7_VLVALE AS ZTB_VLVALE,"
       cQuery += "        ZT7.ZT7_TTVALE AS ZTB_TTVALE,"
       cQuery += "        0              AS ZTB_VLDIFE,"
       cQuery += "        0              AS ZTB_VUNIAT,"
       cQuery += "        ZT8.ZT8_TKCDOP AS ZTB_TKCDOP,"
       cQuery += "        ZT8.ZT8_TKCDBL AS ZTB_TKCDBL,"
       cQuery += "        ZT8.ZT8_TKTPBL AS ZTB_TKTPBL,"
       cQuery += "        SRA.RA_CC      AS ZTB_CC,"
       cQuery += "        CTT." + cEntrCtt + " AS ZTB_LOCENT,"
       cQuery += "        SRA." + cEntrSra + " AS ZTB_LOCSRA,"
       cQuery += "        ZT7.R_E_C_N_O_ AS ZT7_RECNO,"
       cQuery += "        0              AS ZTB_RECNO,"
       cQuery += "        'AL'           AS ZTB_BENEF,"
       cQuery += "        ZT8.ZT8_TIPO   AS ZTB_TIPO,"
       cQuery += "        ZT8.ZT8_TKTPRO AS ZTB_TKTPRO"
       cQuery += " FROM " + RetSqlName( "ZT7" ) + " ZT7"
       cQuery += " LEFT OUTER JOIN " + RetSqlName( "SRA" ) + " SRA ON SRA.RA_FILIAL = ZT7.ZT7_FILIAL AND SRA.RA_MAT = ZT7.ZT7_MAT"
       cQuery += " LEFT OUTER JOIN " + RetSqlName( "CTT" ) + " CTT ON CTT.CTT_CUSTO = SRA.RA_CC"
       cQuery += " LEFT OUTER JOIN " + RetSqlName( "ZT8" ) + " ZT8 ON ZT7.ZT7_COD = ZT8.ZT8_COD"
       cQuery += " WHERE  ZT7.D_E_L_E_T_ <> '*'"
       cQuery += "    AND SRA.D_E_L_E_T_ <> '*'"
       cQuery += "    AND CTT.D_E_L_E_T_ <> '*'"
       cQuery += "    AND ZT8.D_E_L_E_T_ <> '*'"
       cQuery += "    AND ZT7.ZT7_FILIAL BETWEEN '" + cFilDe + "' AND '" + cFilAte + "'"
       cQuery += "    AND ZT7.ZT7_MAT BETWEEN '" + cMatDe + "' AND '" + cMatAte + "'"
       cQuery += "    AND ZT7.ZT7_CC BETWEEN '" + cCcDe + "' AND '" + cCcAte + "'"
       cQuery += "    AND ZT7.ZT7_TTVALE > 0"
       cQuery += "    AND ZT7.ZT7_DATARQ = '" + cDatarq + "'"
       cQuery += "    AND ZT7.ZT7_STATUS = '1'"
       cQuery += "    AND ZT7.ZT7_PERIOD = '" + cPeriodo + "'"
       cQuery += "    AND SRA.RA_SITFOLH <> 'D'"
       cQuery += "    AND SRA." + cEntrSra + " = '" + ZTD->ZTD_CODIGO + "'"
       cQuery += "    AND ZT8.ZT8_FORN = '" + cCodForn + "'"
       cQuery += "    AND ZT8.ZT8_TIPO = '" + cTipAlim + "'"
       If lReproc
          cQuery += " AND ZT7.ZT7_PEDIDO IN ('1','5')"		// 1=Pedido Compra - 2=Pagto Folha - 3=Pagto Adto - 4=Gerar CNAB - 5=Pedido Efetuado - 6=CNAB Gerado
       Else
          cQuery += " AND ZT7.ZT7_PEDIDO = '1'"
       EndIf
       
       cQuery += " UNION"
       
       cQuery += " SELECT ZT7.ZT7_FILIAL AS ZTB_FILIAL,"
       cQuery += "        ZT7.ZT7_MAT    AS ZTB_MAT,"
       cQuery += "        ZT7.ZT7_COD    AS ZTB_COD,"
       cQuery += "        0              AS ZTB_QDEDIA,"
       cQuery += "        ZT7.ZT7_DIACAL AS ZTB_DIACAL,"
       cQuery += "        0              AS ZTB_QDEVAL,"
       cQuery += "        ZT7.ZT7_VLVALE AS ZTB_VLVALE,"
       cQuery += "        ZT7.ZT7_TTVALE AS ZTB_TTVALE,"
       cQuery += "        0              AS ZTB_VLDIFE,"
       cQuery += "        0              AS ZTB_VUNIAT,"
       cQuery += "        ZT8.ZT8_TKCDOP AS ZTB_TKCDOP,"
       cQuery += "        ZT8.ZT8_TKCDBL AS ZTB_TKCDBL,"
       cQuery += "        ZT8.ZT8_TKTPBL AS ZTB_TKTPBL,"
       cQuery += "        SRA.RA_CC      AS ZTB_CC,"
       cQuery += "        CTT." + cEntrCtt + " AS ZTB_LOCENT,"
       cQuery += "        SRA." + cEntrSra + " AS ZTB_LOCSRA,"
       cQuery += "        ZT7.R_E_C_N_O_ AS ZT7_RECNO,"
       cQuery += "        0              AS ZTB_RECNO,"
       cQuery += "        'AL'           AS ZTB_BENEF,"
       cQuery += "        ZT8.ZT8_TIPO   AS ZTB_TIPO,"
       cQuery += "        ZT8.ZT8_TKTPRO AS ZTB_TKTPRO"
       cQuery += " FROM " + RetSqlName( "ZT7" ) + " ZT7"
       cQuery += " LEFT OUTER JOIN " + RetSqlName( "SRA" ) + " SRA ON SRA.RA_FILIAL = ZT7.ZT7_FILIAL AND SRA.RA_MAT = ZT7.ZT7_MAT"
       cQuery += " LEFT OUTER JOIN " + RetSqlName( "CTT" ) + " CTT ON CTT.CTT_CUSTO = SRA.RA_CC"
       cQuery += " LEFT OUTER JOIN " + RetSqlName( "ZT8" ) + " ZT8 ON ZT7.ZT7_COD = ZT8.ZT8_COD"
       cQuery += " WHERE  ZT7.D_E_L_E_T_ <> '*'"
       cQuery += "    AND SRA.D_E_L_E_T_ <> '*'"
       cQuery += "    AND CTT.D_E_L_E_T_ <> '*'"
       cQuery += "    AND ZT8.D_E_L_E_T_ <> '*'"
       cQuery += "    AND ZT7.ZT7_FILIAL BETWEEN '" + cFilDe + "' AND '" + cFilAte + "'"
       cQuery += "    AND ZT7.ZT7_MAT BETWEEN '" + cMatDe + "' AND '" + cMatAte + "'"
       cQuery += "    AND ZT7.ZT7_CC BETWEEN '" + cCcDe + "' AND '" + cCcAte + "'"
       cQuery += "    AND ZT7.ZT7_TTVALE > 0"
       cQuery += "    AND ZT7.ZT7_DATARQ = '" + cDatarq + "'"
       cQuery += "    AND ZT7.ZT7_STATUS = '1'"
       cQuery += "    AND ZT7.ZT7_PERIOD = '" + cPeriodo + "'"
       cQuery += "    AND SRA.RA_SITFOLH <> 'D'"
       cQuery += "    AND SRA." + cEntrSra + " = '   '"
       cQuery += "    AND CTT." + cEntrCtt + " = '" + ZTD->ZTD_CODIGO + "'"
       cQuery += "    AND ZT8.ZT8_FORN = '" + cCodForn + "'"
       cQuery += "    AND ZT8.ZT8_TIPO = '" + cTipAlim + "'"
       If lReproc
          cQuery += " AND ZT7.ZT7_PEDIDO IN ('1','5')"		// 1=Pedido Compra - 2=Pagto Folha - 3=Pagto Adto - 4=Gerar CNAB - 5=Pedido Efetuado - 6=CNAB Gerado
       Else
          cQuery += " AND ZT7.ZT7_PEDIDO = '1'"
       EndIf
    ElseIf cTipoPed == "1"	// 1=Vale Transporte
       cQuery += " SELECT ZTB.ZTB_FILIAL,"
       cQuery += "        ZTB.ZTB_MAT,"
       cQuery += "        ZTB.ZTB_COD,"
       cQuery += "        ZTB.ZTB_QDEDIA,"
       cQuery += "        ZTB.ZTB_DIACAL,"
       cQuery += "        ZTB.ZTB_QDEVAL,"
       cQuery += "        ZTB.ZTB_VLVALE,"
       cQuery += "        ZTB.ZTB_TTVALE,"
       cQuery += "        ZTB.ZTB_VLDIFE,"
       cQuery += "        SRN.RN_VUNIATU AS ZTB_VUNIAT,"
       cQuery += "        SRN.RN_TKCDOP  AS ZTB_TKCDOP,"
       cQuery += "        SRN.RN_TKCDBL  AS ZTB_TKCDBL,"
       cQuery += "        SRN.RN_TKTPBL  AS ZTB_TKTPBL,"
       cQuery += "        SRA.RA_CC      AS ZTB_CC,"
       cQuery += "        CTT." + cEntrCtt + " AS ZTB_LOCENT,"
       cQuery += "        SRA." + cEntrSra + " AS ZTB_LOCSRA,"
       cQuery += "        0              AS ZT7_RECNO,"
       cQuery += "        ZTB.R_E_C_N_O_ AS ZTB_RECNO,"
       cQuery += "        'VT'           AS ZTB_BENEF,"
       cQuery += "        ''             AS ZTB_TIPO,"
       cQuery += "        ''             AS ZTB_TKTPRO"
       cQuery += " FROM " + RetSqlName( "ZTB" ) + " ZTB"
       cQuery += " LEFT OUTER JOIN " + RetSqlName( "SRA" ) + " SRA ON SRA.RA_FILIAL = ZTB.ZTB_FILIAL AND SRA.RA_MAT = ZTB.ZTB_MAT"
       cQuery += " LEFT OUTER JOIN " + RetSqlName( "CTT" ) + " CTT ON CTT.CTT_CUSTO = SRA.RA_CC"
       cQuery += " LEFT OUTER JOIN " + RetSqlName( "SRN" ) + " SRN ON ZTB.ZTB_COD = SRN.RN_COD"
       cQuery += " WHERE  ZTB.D_E_L_E_T_ <> '*'"
       cQuery += "    AND SRA.D_E_L_E_T_ <> '*'"
       cQuery += "    AND CTT.D_E_L_E_T_ <> '*'"
       cQuery += "    AND SRN.D_E_L_E_T_ <> '*'"
       cQuery += "    AND ZTB.ZTB_FILIAL BETWEEN '" + cFilDe + "' AND '" + cFilAte + "'"
       cQuery += "    AND ZTB.ZTB_MAT BETWEEN '" + cMatDe + "' AND '" + cMatAte + "'"
       cQuery += "    AND ZTB.ZTB_CC BETWEEN '" + cCcDe + "' AND '" + cCcAte + "'"
       cQuery += "    AND ZTB.ZTB_TTVALE > 0"
       cQuery += "    AND ZTB.ZTB_DATARQ = '" + cDatarq + "'"
       cQuery += "    AND ZTB.ZTB_STATUS = '1'"
       cQuery += "    AND ZTB.ZTB_PERIOD = '" + cPeriodo + "'"
       cQuery += "    AND SRA.RA_SITFOLH <> 'D'"
       cQuery += "    AND SRA." + cEntrSra + " = '" + ZTD->ZTD_CODIGO + "'"
       cQuery += "    AND SRN.RN_FORN = '" + cCodForn + "'"
       If lReproc
          cQuery += " AND ZTB.ZTB_PEDIDO IN ('1','5')"     // 1=Pedido Compra - 2=Pagto Folha - 3=Pagto Adto - 4=Gerar CNAB - 5=Pedido Efetuado - 6=CNAB Gerado
       Else
          cQuery += " AND ZTB.ZTB_PEDIDO = '1'"
       EndIf
       cQuery += " UNION"
       cQuery += " SELECT ZTB.ZTB_FILIAL,"
       cQuery += "        ZTB.ZTB_MAT,"
       cQuery += "        ZTB.ZTB_COD,"
       cQuery += "        ZTB.ZTB_QDEDIA,"
       cQuery += "        ZTB.ZTB_DIACAL,"
       cQuery += "        ZTB.ZTB_QDEVAL,"
       cQuery += "        ZTB.ZTB_VLVALE,"
       cQuery += "        ZTB.ZTB_TTVALE,"
       cQuery += "        ZTB.ZTB_VLDIFE,"
       cQuery += "        SRN.RN_VUNIATU AS ZTB_VUNIAT,"
       cQuery += "        SRN.RN_TKCDOP  AS ZTB_TKCDOP,"
       cQuery += "        SRN.RN_TKCDBL  AS ZTB_TKCDBL,"
       cQuery += "        SRN.RN_TKTPBL  AS ZTB_TKTPBL,"
       cQuery += "        SRA.RA_CC      AS ZTB_CC,"
       cQuery += "        CTT." + cEntrCtt + " AS ZTB_LOCENT,"
       cQuery += "        SRA." + cEntrSra + " AS ZTB_LOCSRA,"
       cQuery += "        0              AS ZT7_RECNO,"
       cQuery += "        ZTB.R_E_C_N_O_ AS ZTB_RECNO,"
       cQuery += "        'VT'           AS ZTB_BENEF,"
       cQuery += "        ''             AS ZTB_TIPO,"
       cQuery += "        ''             AS ZTB_TKTPRO"
       cQuery += " FROM " + RetSqlName( "ZTB" ) + " ZTB"
       cQuery += " LEFT OUTER JOIN " + RetSqlName( "SRA" ) + " SRA ON SRA.RA_FILIAL = ZTB.ZTB_FILIAL AND SRA.RA_MAT = ZTB.ZTB_MAT"
       cQuery += " LEFT OUTER JOIN " + RetSqlName( "CTT" ) + " CTT ON CTT.CTT_CUSTO = SRA.RA_CC"
       cQuery += " LEFT OUTER JOIN " + RetSqlName( "SRN" ) + " SRN ON ZTB.ZTB_COD = SRN.RN_COD"
       cQuery += " WHERE  ZTB.D_E_L_E_T_ <> '*'"
       cQuery += "    AND SRA.D_E_L_E_T_ <> '*'"
       cQuery += "    AND CTT.D_E_L_E_T_ <> '*'"
       cQuery += "    AND SRN.D_E_L_E_T_ <> '*'"
       cQuery += "    AND ZTB.ZTB_FILIAL BETWEEN '" + cFilDe + "' AND '" + cFilAte + "'"
       cQuery += "    AND ZTB.ZTB_MAT BETWEEN '" + cMatDe + "' AND '" + cMatAte + "'"
       cQuery += "    AND ZTB.ZTB_CC BETWEEN '" + cCcDe + "' AND '" + cCcAte + "'"
       cQuery += "    AND ZTB.ZTB_TTVALE > 0"
       cQuery += "    AND ZTB.ZTB_DATARQ = '" + cDatarq + "'"
       cQuery += "    AND ZTB.ZTB_STATUS = '1'"
       cQuery += "    AND ZTB.ZTB_PERIOD = '" + cPeriodo + "'"
       cQuery += "    AND SRA.RA_SITFOLH <> 'D'"
       cQuery += "    AND SRA." + cEntrSra + " = '   '"
       cQuery += "    AND CTT." + cEntrCtt + " = '" + ZTD->ZTD_CODIGO + "'"
       cQuery += "    AND SRN.RN_FORN = '" + cCodForn + "'"
       If lReproc
          cQuery += " AND ZTB.ZTB_PEDIDO IN ('1','5')"		// 1=Pedido Compra - 2=Pagto Folha - 3=Pagto Adto - 4=Gerar CNAB - 5=Pedido Efetuado - 6=CNAB Gerado
       Else
          cQuery += " AND ZTB.ZTB_PEDIDO = '1'"
       EndIf
    EndIf
 EndIf
 cQuery += " ORDER BY ZTB_FILIAL, ZTB_MAT, ZTB_COD"
 
 cQuery := ChangeQuery( cQuery )
 TCQuery cQuery New Alias "WZTB"
 TcSetField( "WZTB" , "ZTB_QDEDIA"  , "N", 04, 0 )
 TcSetField( "WZTB" , "ZTB_DIACAL"  , "N", 04, 0 )
 TcSetField( "WZTB" , "ZTB_QDEVAL"  , "N", 04, 0 )
 TcSetField( "WZTB" , "ZTB_VLVALE"  , "N", 12, 2 )
 TcSetField( "WZTB" , "ZTB_TTVALE"  , "N", 12, 2 )
 TcSetField( "WZTB" , "ZTB_VLDIFE"  , "N", 12, 2 )
 TcSetField( "WZTB" , "ZT7_RECNO"   , "N", 12, 0 )
 TcSetField( "WZTB" , "ZTB_RECNO"   , "N", 12, 0 )

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

 // Verifica a Criacao do Grupo de Consultas F3
 U_fUPath()

 // Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
 aAdd(aRegs,{ cPerg,'01','Data Referencia ?            ','','','mv_ch1','D',08,0,0,'G','NaoVazio    ','mv_par01','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
 aAdd(aRegs,{ cPerg,'02','Filial De ?                  ','','','mv_ch2','C',Fi,0,0,'G','            ','mv_par02','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SM0   ','' })
 aAdd(aRegs,{ cPerg,'03','Filial Ate ?                 ','','','mv_ch3','C',Fi,0,0,'G','NaoVazio    ','mv_par03','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SM0   ','' })
 aAdd(aRegs,{ cPerg,'04','Matricula De ?               ','','','mv_ch4','C',06,0,0,'G','            ','mv_par04','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SRA   ','' })
 aAdd(aRegs,{ cPerg,'05','Matricula Ate ?              ','','','mv_ch5','C',06,0,0,'G','NaoVazio    ','mv_par05','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SRA   ','' })
 aAdd(aRegs,{ cPerg,'06','Centro Custo De  ?           ','','','mv_ch6','C',20,0,0,'G','            ','mv_par06','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'CTT   ','' })
 aAdd(aRegs,{ cPerg,'07','Centro Custo Ate  ?          ','','','mv_ch7','C',20,0,0,'G','NaoVazio    ','mv_par07','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'CTT   ','' })
 aAdd(aRegs,{ cPerg,'08','Periodo para Compra ?        ','','','mv_ch8','C',01,0,0,'G','U_fBnfPer(1)','mv_par08','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
 aAdd(aRegs,{ cPerg,'09','Local Geracao do Arquivo  ?  ','','','mv_ch9','C',30,0,0,'G','NaoVazio    ','mv_par09','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'U_PATH','' })
 aAdd(aRegs,{ cPerg,'10','Preco do Kit (%)  ?          ','','','mv_cha','N',12,2,0,'G','            ','mv_par10','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
 aAdd(aRegs,{ cPerg,'11','Valor p/ Ponto de Entrega  ? ','','','mv_chb','N',12,2,0,'G','            ','mv_par11','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
 aAdd(aRegs,{ cPerg,'12','Dt Entrega Minima ?          ','','','mv_chc','D',08,0,0,'G','NaoVazio    ','mv_par12','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
 aAdd(aRegs,{ cPerg,'13','Dt Entrega Maxima ?          ','','','mv_chd','D',08,0,0,'G','NaoVazio    ','mv_par13','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
 aAdd(aRegs,{ cPerg,'14','Reprocessa Reg Ja Gerados ?  ','','','mv_che','N',01,0,0,'C','            ','mv_par14','Sim              ','','','','','Nao              ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
 aAdd(aRegs,{ cPerg,'15','Tipo do Pedido  ?            ','','','mv_chf','N',01,0,0,'C','            ','mv_par15','Vale Transporte  ','','','','','Vale Refeicao    ','','','','','Vale Alimentacao'    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
 aAdd(aRegs,{ cPerg,'16','Data Pedido VR/VA ?          ','','','mv_chg','D',08,0,0,'G','NaoVazio    ','mv_par16','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
 aAdd(aRegs,{ cPerg,'17','Data Liberacao VR/VA ?       ','','','mv_chh','D',08,0,0,'G','NaoVazio    ','mv_par17','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
 fSx1Del( cPerg, "18" )

ValidPerg(aRegs,cPerg)

Return   
