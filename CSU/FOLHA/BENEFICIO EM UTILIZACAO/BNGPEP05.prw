#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#DEFINE          cEol         CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEP05 บ Autor ณ Adilson Silva      บ Data ณ 09/06/2011  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Geracao do Arquivo Texto p/ Compra do Vale Refeicao e Vale บฑฑ
ฑฑบ          ณ Alimentacao do Fornecedor Visa Vale.                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function BNGPEP05()

 Local bProcesso := {|oSelf| fProcessa( oSelf )}

 Private cCadastro  := "Pedido Refei็ใo - Visa Vale"
 Private cPerg      := "BNGPEP05"
 Private cStartPath := GetSrvProfString("StartPath","")
 Private cDescricao

 fPerg()
 Pergunte(cPerg,.F.)

 cDescricao := "Esta rotina irแ gerar o arquivo texto para compra do Vale Refei็ใo e Vale Alimenta็ใo da Visa Vale."

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
Local nSequenc := 0
Local cPeriodo := ""
Local aCcProc  := {}
Local nTotReg  := 0
Local cChave    := ""
Local nValor    := 0
Local nPos

Private lReproc  := .F.
Private nTotReg  := 0
Private cCodForn := "002"
Private cFornec  := ""
Private cCnpj    := ""
Private cNomeEmp := ""
Private cEntrCtt := "@@"
Private cEntrSra := "@@"

Private dDtRef, dDtEntr
Private cFilDe, cFilAte
Private cMatDe, cMatAte
Private cCcDe, cCcAte
Private cGerBen, cPerCalc

Private nHdl

Private aRegTp := {0,0}

Pergunte(cPerg,.F.)
 dDtRef   := mv_par01
 cFilDe   := mv_par02
 cFilAte  := mv_par03
 cMatDe   := mv_par04
 cMatAte  := mv_par05
 cCcDe    := mv_par06
 cCcAte   := mv_par07
 cGerBen  := Str(mv_par08,1)		// 1=Vale Refeicao - 2=Vale Alimentacao
 cPerCalc := mv_par09
 cLocArq  := Alltrim( mv_par10 )
 lReproc  := mv_par11 == 1
 dDtEntr  := mv_par12

cPeriodo := MesAno( dDtRef )

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
ZT7->(dbSetOrder( 1 ))
ZT9->(dbSetOrder( 1 ))

// Valida os Locais de Entrega
If !U_fLocEntrega( @cEntrSra, @cEntrCtt, If(cGerBen=="1","VR","VA") )
   Aviso("ATENCAO","Locais de entrega nใo configurados! Entre em contato com o suporte!",{"Sair"})
   Return
EndIf

// Busca o Fornecedor
If !(ZT9->(dbSeek( xFilial("ZT9") + cCodForn )))
   Aviso("ATENCAO","Fornecedor da Visa Vale nao cadastrado",{"Sair"})
   Return
EndIf
If Empty( ZT9->ZT9_CODFOR ) .Or. Empty( ZT9->ZT9_EMPRES )
   Aviso("ATENCAO","Contrato ou Empresa Responsแvel nใo cadastrados para este fornecedor!",{"Sair"})
   Return
EndIf
If cGerBen=="2"
   cFornec := Alltrim( ZT9->ZT9_CODFVA )
Else
   cFornec := Alltrim( ZT9->ZT9_CODFOR )
EndIf
fMtaEmpresa( ZT9->ZT9_EMPRES, @cCnpj, @cNomeEmp )

// Cria Arquivo Texto
cLocArq := cLocArq + If(Right(cLocArq,1) # "\","\","")
If cGerBen == "1"		// Vale Refeicao
   cArqTxt := cLocArq + "VVALE_VR_" + cPeriodo + "-" + cPerCalc + ".TXT"
ElseIf cGerBen == "2"	// Vale Alimentacao
   cArqTxt := cLocArq + "VVALE_VA_" + cPeriodo + "-" + cPerCalc + ".TXT"
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

// Processa Registro Tipo "0"
cOrdem   := Replicate("0",10)
fProcTp0( cOrdem )

dbSelectArea( "ZTD" )
dbSetOrder( 1 )
dbGoTop()
oSelf:SetRegua1( RecCount() )

Do While !Eof()
   oSelf:IncRegua1( ZTD->(ZTD_CODIGO + " - " + ZTD_ENDERE) )
   If oSelf:lEnd 
      Break
   EndIf

   // Monta a Query Principal 
   MsAguarde( {|| fMtaQuery( dDtRef )}, "Processando...", "Selecionado Registros do Local de Entrega " + ZTD->ZTD_CODIGO )

   dbSelectArea( "WZT7" )
   Count To nTotReg
   If nTotReg = 0
      WZT7->(dbCloseArea())
      dbSelectArea( "ZTD" )
      dbSkip()
      Loop
   EndIf
   
   dbSelectArea( "WZT7" )
   dbGoTop()
   oSelf:SetRegua2( nTotReg )

   // Processa Registro Tipo "1"
   cOrdem := "001" + ZTD->ZTD_CODIGO + "0000"
   fProcTp1( cOrdem )

   Do While !Eof()
      oSelf:IncRegua2( "Processando Local: " + ZTD->ZTD_CODIGO + " Funcionario: " + WZT7->(ZT7_FILIAL + " - " + ZT7_MAT) )

      If oSelf:lEnd 
         Break
      EndIf
   
      SRA->(dbSeek( WZT7->(ZT7_FILIAL + ZT7_MAT) ))      
      SRJ->(dbSeek( xFilial("SRJ") + SRA->RA_CODFUNC ))      
      CTT->(dbSeek( xFilial("CTT") + SRA->RA_CC ))      

      If ( nPos := Ascan(aCcProc,{|x| x=SRA->RA_CC}) ) == 0
         Aadd(aCcProc,SRA->RA_CC)

         // Processa Registro Tipo "2"
         cOrdem := "001" + ZTD->ZTD_CODIGO + "1000"
         fProcTp2( cOrdem )
      EndIf
      
      dbSelectArea( "ZT7" )
      dbGoTo( WZT7->ZT7_RECNO )
      If !Eof() .And. !Bof()
         RecLock("ZT7",.F.)
          ZT7->ZT7_PEDIDO := "5"
         MsUnlock()
      EndIf
      
      dbSelectArea( "WZT7" )
      cChave := WZT7->(ZT7_FILIAL + ZT7_MAT)
      nValor += WZT7->ZT7_TTVALE
      dbSkip()
      If cChave == WZT7->(ZT7_FILIAL + ZT7_MAT)
         Loop
      EndIf

      // Processa Registro Tipo "3"
      cOrdem := "001" + ZTD->ZTD_CODIGO + "1100"
      fProcTp5( cOrdem, nValor, cChave )
      nValor := 0
      
   EndDo
   WZT7->(dbCloseArea())
   
   dbSelectArea( "ZTD" )
    
   dbSkip()
EndDo

// Processa Registro Tipo "9"
cOrdem := "9999999999"
fProcTp9( cOrdem )

dbSelectArea( "WTMP" )
dbGoTop()
oSelf:SetRegua1( RecCount() )
nSequenc := 0
Do While !Eof()
   oSelf:IncRegua1( "Gravando Arquivo Texto..." )

   nSequenc++
   
   cLin := WTMP->TMP_TXT
   cLin += StrZero(nSequenc,6)
   cLin += cEol
   fGravaTxt( cLin )
   
   dbSkip()
EndDo
WTMP->(dbCloseArea())

fClose( nHdl )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEP05 บAutor  ณMicrosiga           บ Data ณ  10/26/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fProcTp0( cOrdem )

 Local cMesAno := StrZero(Month( dDtRef ),2) + StrZero(Year( dDtRef ),4)
 Local cLin
 
 cLin := "0"											// 001 - 001 -> 001 - Tipo do Registro
 cLin += U_fConvData( dDataBase, "DDMMAAAA" )			// 002 - 009 -> 008 - Data do Arquivo
 cLin += "A001"											// 010 - 013 -> 004 - Canal de Entrada
 cLin += Left(cNomeEmp+Space(35),35)					// 014 - 048 -> 035 - Razao Social da Empresa Principal
 cLin += cCnpj											// 049 - 062 -> 014 - CNPJ da Empresa Principal
 cLin += "00000000000"									// 063 - 073 -> 011 - Nao Utilizado (CPF)
 cLin += StrZero(Val(cFornec),11)						// 074 - 084 -> 011 - Numero do Contrato
 cLin += "000000"										// 085 - 090 -> 006 - Numero do Pedido do Cliente
 cLin += U_fConvData( dDtEntr, "DDMMAAAA" )				// 091 - 098 -> 008 - Data da Efetivacao do Beneficio
 cLin += If(cGerBen=="1","2","1")						// 099 - 099 -> 001 - Tipo do Beneficio 1=Alimentacao - 2=Refeicao
 cLin += "1"											// 100 - 100 -> 001 - Tipo do Pedido 1=Normal ; 2=Complementar
 cLin += cMesAno										// 101 - 106 -> 006 - Mes de Competencia (MMAAAA)
 cLin += Space(18)										// 107 - 124 -> 018 - Uso Livre
 cLin += "007"											// 125 - 127 -> 003 - Versao do Lay-Out
 cLin += Space(267)						   				// 128 - 394 -> 267 - Brancos

 fGravaDbf( cOrdem, cLin )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEP05 บAutor  ณMicrosiga           บ Data ณ  10/26/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fProcTp1( cOrdem )

 Local cLin
 
 cLin := "1"											// 001 a 001 -> 001 - Tipo do Registro
 cLin += cCnpj											// 002 a 015 -> 014 - Numero Principal do CNPJ
 cLin += "0000000000"									// 016 a 025 -> 010 - Codigo Junto a Visa Vale
 cLin += Left(cNomeEmp+Space(35),35)					// 026 - 060 -> 035 - Razao Social da Empresa Principal
 cLin += StrZero(Val(ZTD->ZTD_DDD),4)					// 061 a 064 -> 004 - DDD dos Interlocutores de Entrega
 cLin += PadR(ZTD->ZTD_RESP1,35)						// 065 a 099 -> 035 - Nome do 1o Interlocutor de Entrega
 cLin += PadR(ZTD->ZTD_DEPTO1,40)						// 100 a 139 -> 040 - Endereco de Localizacao Interna do 1o Interlocutor de Entrega
 cLin += StrZero(Val(ZTD->ZTD_FONE1),12)				// 140 a 151 -> 012 - Telefone do 1o Interlocutor de Entrega
 cLin += StrZero(Val(ZTD->ZTD_RAMAL1),06)				// 152 a 157 -> 006 - Ramal do 1o Interlocutor de Entrega
 cLin += PadR(ZTD->ZTD_RESP2,35)						// 158 a 192 -> 035 - Nome do 2o Interlocutor de Entrega
 cLin += PadR(ZTD->ZTD_DEPTO2,40)						// 193 a 232 -> 040 - Endereco de Localizacao Interna do 2o Interlocutor de Entrega
 cLin += StrZero(Val(ZTD->ZTD_FONE2),12)				// 233 a 244 -> 012 - Telefone do 2o Interlocutor de Entrega
 cLin += StrZero(Val(ZTD->ZTD_RAMAL2),06)				// 245 a 250 -> 006 - Ramal do 2o Interlocutor de Entrega
 cLin += PadR(ZTD->ZTD_RESP3,35)						// 251 a 285 -> 035 - Nome do 3o Interlocutor de Entrega
 cLin += PadR(ZTD->ZTD_DEPTO3,40)						// 286 a 325 -> 040 - Endereco de Localizacao Interna do 3o Interlocutor de Entrega
 cLin += StrZero(Val(ZTD->ZTD_FONE3),12)				// 326 a 337 -> 012 - Telefone do 3o Interlocutor de Entrega
 cLin += StrZero(Val(ZTD->ZTD_RAMAL3),06)				// 338 a 343 -> 006 - Ramal do 3o Interlocutor de Entrega
 cLin += Space(20)										// 344 a 363 -> 020 - Codigo da Filial Usado pelo Cliente
 cLin += Space(31)										// 364 a 394 -> 031 - Brancos

 fGravaDbf( cOrdem, cLin )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEP05 บAutor  ณMicrosiga           บ Data ณ  10/26/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fProcTp2( cOrdem )

 Local cLin
 
 cLin := "2"											// 001 a 001 -> 001 - Tipo do Registro
 cLin += Space(20)										// 002 a 021 -> 020 - Nome da Diretoria
 cLin += Space(20)										// 022 a 041 -> 020 - Nome do Departamento
 cLin += Left(SRA->RA_CC+Space(20),20)					// 042 a 061 -> 020 - Codigo da Area Funcional
 cLin += Left(CTT->CTT_DESC01+Space(20),20)			// 062 a 081 -> 020 - Nome da Area Funcional
 cLin += Space(40)										// 082 a 121 -> 040 - Localizacao Interna da Area Funcional
 cLin += StrZero(Val(ZTD->ZTD_DDD),4)					// 122 a 125 -> 004 - DDD dos Interlocutores de Entrega
 cLin += PadR(ZTD->ZTD_RESP1,35)						// 126 a 160 -> 035 - Nome do 1o Interlocutor de Entrega
 cLin += StrZero(Val(ZTD->ZTD_FONE1),12)				// 161 a 172 -> 012 - Telefone do 1o Interlocutor de Entrega
 cLin += StrZero(Val(ZTD->ZTD_RAMAL1),06)				// 173 a 178 -> 006 - Ramal do 1o Interlocutor de Entrega
 cLin += PadR(ZTD->ZTD_RESP2,35)						// 179 a 213 -> 035 - Nome do 2o Interlocutor de Entrega
 cLin += StrZero(Val(ZTD->ZTD_FONE2),12)				// 214 a 225 -> 012 - Telefone do 2o Interlocutor de Entrega
 cLin += StrZero(Val(ZTD->ZTD_RAMAL2),06)				// 226 a 231 -> 006 - Ramal do 2o Interlocutor de Entrega
 cLin += Space(163)										// 232 a 395 -> 163 - Brancos

 fGravaDbf( cOrdem, cLin )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEP05 บAutor  ณMicrosiga           บ Data ณ  10/26/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fProcTp5( cOrdem, nValor, cChave )

 Local cMat     := "00000" + cChave
 Local cValTot  := StrZero((nValor*100),11)
 Local cLin

 cLin := "5"											// 001 a 001 -> 001 - Tipo do Registro
 cLin += cValTot										// 002 a 012 -> 011 - Valor do Beneficio
 cLin += Space(01)										// 013 a 013 -> 001 - Reservado
 cLin += cMat											// 014 a 026 -> 013 - Matricula			// VER AQUI - BY ASR 03-12-2012
 cLin += Space(54)										// 027 a 080 -> 054 - Reservado
 cLin += U_fConvData( SRA->RA_NASC, "DDMMAAAA" )		// 081 a 088 -> 008 - Data Nascimento
 cLin += SRA->RA_CIC									// 089 a 099 -> 011 - CPF
 cLin += "1"											// 100 a 100 -> 001 - Tipo do Documento ID
 cLin += Left(SRA->RA_RG+Space(13),13)					// 101 a 113 -> 013 - Numero do Documento ID
 cLin += Left(SRA->RA_RGORG+Space(20),20)				// 114 a 133 -> 020 - Orgao Emissor do Documento ID
 cLin += Left(SRA->RA_RGUF+Space(06),06)				// 134 a 139 -> 006 - Estado Emissor do RG 
 cLin += StrZero(Val(SRA->RA_PIS),15)  				// 140 a 154 -> 015 - PIS
 cLin += Upper(SRA->RA_SEXO)							// 155 a 155 -> 001 - Sexo
 cLin += fEstCivil( SRA->RA_ESTCIVI )					// 156 a 156 -> 001 - Estado Civil
 cLin += Left(Upper(SRA->RA_ENDEREC)+Space(35),35)		// 157 a 191 -> 035 - Endereco
 cLin += Left(Upper(SRA->RA_COMPLEM)+Space(10),10)		// 192 a 201 -> 010 - Complemento do Endereco
 cLin += "00000"										// 202 a 206 -> 005 - Numero do Endereco
 cLin += StrZero(Val(SRA->RA_CEP),8)					// 207 a 214 -> 008 - CEP
 cLin += Left(Upper(SRA->RA_MUNICIP)+Space(28),28)		// 215 a 242 -> 028 - Municipio
 cLin += Left(Upper(SRA->RA_BAIRRO)+Space(30),30)		// 243 a 272 -> 030 - Bairro
 cLin += Upper(SRA->RA_ESTADO)							// 273 a 274 -> 002 - Estado
 cLin += Left(Upper(SRA->RA_MAE)+Space(35),35)			// 275 a 309 -> 035 - Nome da Mae
 cLin += "R"											// 310 a 310 -> 001 - Opcao Correspondencia C=Comercial ; R=Residencial
 cLin += "0000"											// 311 a 314 -> 004 - DDD Comercial
 cLin += "00000000"										// 315 a 322 -> 008 - Telefone Comercial
 cLin += "0000"											// 323 a 326 -> 004 - Ramal Comercial
 cLin += "0000"											// 327 a 330 -> 004 - DDD Residencial
 cLin += "00000000"										// 331 a 338 -> 008 - Telefone Residencial
 cLin += fEscolar( SRA->RA_GRINRAI )					// 339 a 339 -> 001 - Escolaridade
 cLin += U_fConvData( SRA->RA_ADMISSA, "DDMMAAAA" )		// 340 a 347 -> 008 - Data Admissao
 cLin += Space(01)										// 348 a 348 -> 001 - Reservado
 cLin += Left(Upper(SRA->RA_NOME)+Space(40),40)		// 349 a 388 -> 040 - Nome 
 cLin += Space(06)										// 389 a 394 -> 006 - Reservado

 fGravaDbf( cOrdem, cLin )
 aRegTp[1]++
 aRegTp[2] += nValor * 100

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEP05 บAutor  ณMicrosiga           บ Data ณ  10/26/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fProcTp9( cOrdem )

 Local cLin

 cLin := "9"											// 001 a 001 -> 001 - Tipo do Registro
 cLin += StrZero(aRegTp[1],6)							// 002 a 007 -> 006 - Total de Registros Tipo 5
 cLin += StrZero(aRegTp[2],15)							// 008 a 022 -> 015 - Valor Total do Pedido
 cLin += Space(372)										// 023 a 394 -> 203 - Brancos

 fGravaDbf( cOrdem, cLin )

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
ฑฑบPrograma  ณ BNGPEP05 บAutor  ณMicrosiga           บ Data ณ  10/26/07   บฑฑ
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

 Aadd(aCampos,{ "TMP_CHAVE"  , "C" , 0015 , 0 })
 Aadd(aCampos,{ "TMP_TXT"    , "C" , 0394 , 0 })

 cArqDbf := CriaTrab( aCampos, .T. )
 dbUseArea( .T.,, cArqDbf, "WTMP", .F. )

 //cArqNtx := CriaTrab( Nil, .F. )
 //IndRegua( "WTMP", cArqNtx, "TMP_CHAVE", , , "Selecionando registros..." )
 
 RESTAREA( aOld )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEP05 บAutor  ณMicrosiga           บ Data ณ  10/26/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fGravaDbf( cOrdem, cLin )

 Local aOld := GETAREA()
 
 dbSelectArea( "WTMP" )
 RecLock("WTMP",.T.)
  WTMP->TMP_CHAVE := cOrdem
  WTMP->TMP_TXT   := cLin
 MsUnlock()

 RESTAREA( aOld )
 
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBNGPEP05  บAutor  ณMicrosiga           บ Data ณ  06/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fEstCivil( cEstCivil )

Local cRet := "5"	// Outros

If     cEstCivil $ "S"		; cRet := "1"	// Solteiro
ElseIf cEstCivil $ "CM"		; cRet := "2"	// Casado
ElseIf cEstCivil $ "V"		; cRet := "3"	// Viuvo
ElseIf cEstCivil $ "DQ"		; cRet := "4"	// Separado
EndIf

Return( cRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBNGPEP05  บAutor  ณMicrosiga           บ Data ณ  06/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fEscolar( cEscolar )

Local cRet := "1"	// Primeiro Grau

If     cEscolar $ "10/20/25/30/35"	; cRet := "1"		// Primeiro Grau
ElseIf cEscolar $ "40/45"			; cRet := "2"		// Segundo Grau
ElseIf cEscolar $ "50/55"			; cRet := "3"		// Superior
ElseIf cEscolar $ "65/75"			; cRet := "4"		// Pos
EndIf

Return( cRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBNGPEP05  บAutor  ณMicrosiga           บ Data ณ  06/09/11   บฑฑ
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
 Local lCttFil  := U_fX2Compart( "CTT" )
 Local cQuery   := ""

 If lEntrFil
    cQuery := " SELECT ZT7.ZT7_FILIAL,"
    cQuery += "        ZT7.ZT7_MAT,"
    cQuery += "        ZT7.ZT7_COD,"
    cQuery += "        ZT7.ZT7_DIACAL,"
    cQuery += "        ZT7.ZT7_VLVALE,"
    cQuery += "        ZT7.ZT7_TTVALE,"
    cQuery += "        ZT8.ZT8_FORN AS ZT7_FORN,"
    cQuery += "        SRA.RA_CC AS ZT7_CC,"
    cQuery += "        CTT." + cEntrCtt + " AS ZT7_LOCENT,"
    cQuery += "        SRA." + cEntrSra + " AS ZT7_LOCSRA,"
    cQuery += "        ZT7.R_E_C_N_O_ AS ZT7_RECNO"
    cQuery += " FROM " + RetSqlName( "ZT7" ) + " ZT7"
    cQuery += " LEFT OUTER JOIN " + RetSqlName( "SRA" ) + " SRA ON SRA.RA_FILIAL = ZT7.ZT7_FILIAL AND SRA.RA_MAT = ZT7.ZT7_MAT"
    cQuery += " LEFT OUTER JOIN " + RetSqlName( "CTT" ) + " CTT ON CTT.CTT_CUSTO = SRA.RA_CC " + If(!lCttFil, " AND CTT.CTT_FILIAL = SRA.RA_FILIAL", "" )
    cQuery += " LEFT OUTER JOIN " + RetSqlName( "ZT8" ) + " ZT8 ON ZT7.ZT7_COD = ZT8.ZT8_COD"
    cQuery += " WHERE  ZT7.D_E_L_E_T_ <> '*'"
    cQuery += "    AND SRA.D_E_L_E_T_ <> '*'"
    cQuery += "    AND CTT.D_E_L_E_T_ <> '*'"
    cQuery += "    AND ZT8.D_E_L_E_T_ <> '*'"
    cQuery += "    AND ZT7.ZT7_FILIAL BETWEEN '" + cFilDe + "' AND '" + cFilAte + "'"
    cQuery += "    AND ZT7.ZT7_MAT BETWEEN '" + cMatDe + "' AND '" + cMatAte + "'"
    cQuery += "    AND ZT7.ZT7_CC BETWEEN '" + cCcDe + "' AND '" + cCcAte + "'"
    cQuery += "    AND ZT7.ZT7_DATARQ = '" + MesAno(dDtRef) + "'"
    cQuery += "    AND ZT7.ZT7_STATUS = '1'"
    cQuery += "    AND SRA.RA_SITFOLH <> 'D'"
    cQuery += "    AND SRA.RA_FILIAL = '" + ZTD->ZTD_FILENT + "'"
    cQuery += "    AND ZT8.ZT8_FORN = '" + cCodForn + "'"
    cQuery += "    AND ZT7.ZT7_TIPO = '" + cGerBen + "'"  		// 1=Vale Refeicao - 2=Vale Alimentacao
    cQuery += "    AND ZT7.ZT7_PERIOD = '" + cPerCalc + "'" 
    cQuery += "    AND ZT7.ZT7_TTVALE > 0 "   //OS 3055/14
    If lReproc
       cQuery += " AND ZT7.ZT7_PEDIDO IN ('1','5')"		// 1=Pedido Compra - 2=Pagto Folha - 3=Pagto Adto - 4=Gerar CNAB - 5=Pedido Efetuado - 6=CNAB Gerado
    Else
       cQuery += " AND ZT7.ZT7_PEDIDO = '1'"
    EndIf
 Else
    cQuery := " SELECT ZT7.ZT7_FILIAL,"
    cQuery += "        ZT7.ZT7_MAT,"
    cQuery += "        ZT7.ZT7_COD,"
    cQuery += "        ZT7.ZT7_DIACAL,"
    cQuery += "        ZT7.ZT7_VLVALE,"
    cQuery += "        ZT7.ZT7_TTVALE,"
    cQuery += "        ZT8.ZT8_FORN AS ZT7_FORN,"
    cQuery += "        SRA.RA_CC AS ZT7_CC,"
    cQuery += "        CTT." + cEntrCtt + " AS ZT7_LOCENT,"
    cQuery += "        SRA." + cEntrSra + " AS ZT7_LOCSRA,"
    cQuery += "        ZT7.R_E_C_N_O_ AS ZT7_RECNO"
    cQuery += " FROM " + RetSqlName( "ZT7" ) + " ZT7"
    cQuery += " LEFT OUTER JOIN " + RetSqlName( "SRA" ) + " SRA ON SRA.RA_FILIAL = ZT7.ZT7_FILIAL AND SRA.RA_MAT = ZT7.ZT7_MAT"
    cQuery += " LEFT OUTER JOIN " + RetSqlName( "CTT" ) + " CTT ON CTT.CTT_CUSTO = SRA.RA_CC " + If(!lCttFil, " AND CTT.CTT_FILIAL = SRA.RA_FILIAL", "" )
    cQuery += " LEFT OUTER JOIN " + RetSqlName( "ZT8" ) + " ZT8 ON ZT7.ZT7_COD = ZT8.ZT8_COD"
    cQuery += " WHERE  ZT7.D_E_L_E_T_ <> '*'"
    cQuery += "    AND SRA.D_E_L_E_T_ <> '*'"
    cQuery += "    AND CTT.D_E_L_E_T_ <> '*'"
    cQuery += "    AND ZT8.D_E_L_E_T_ <> '*'"
    cQuery += "    AND ZT7.ZT7_FILIAL BETWEEN '" + cFilDe + "' AND '" + cFilAte + "'"
    cQuery += "    AND ZT7.ZT7_MAT BETWEEN '" + cMatDe + "' AND '" + cMatAte + "'"
    cQuery += "    AND ZT7.ZT7_CC BETWEEN '" + cCcDe + "' AND '" + cCcAte + "'"
    cQuery += "    AND ZT7.ZT7_DATARQ = '" + MesAno(dDtRef) + "'"
    cQuery += "    AND ZT7.ZT7_STATUS = '1'"
    cQuery += "    AND SRA.RA_SITFOLH <> 'D'"
    cQuery += "    AND SRA." + cEntrSra + " = '" + ZTD->ZTD_CODIGO + "'"
    cQuery += "    AND ZT8.ZT8_FORN = '" + cCodForn + "'"
    cQuery += "    AND ZT7.ZT7_TIPO = '" + cGerBen + "'"  		// 1=Vale Refeicao - 2=Vale Alimentacao
    cQuery += "    AND ZT7.ZT7_PERIOD = '" + cPerCalc + "'"
    cQuery += "    AND ZT7.ZT7_TTVALE > 0 "   //OS 3055/14
    If lReproc
       cQuery += " AND ZT7.ZT7_PEDIDO IN ('1','5')"		// 1=Pedido Compra - 2=Pagto Folha - 3=Pagto Adto - 4=Gerar CNAB - 5=Pedido Efetuado - 6=CNAB Gerado
    Else
       cQuery += " AND ZT7.ZT7_PEDIDO = '1'"
    EndIf
   
    cQuery += " UNION"
    
    cQuery += " SELECT ZT7.ZT7_FILIAL,"
    cQuery += "        ZT7.ZT7_MAT,"
    cQuery += "        ZT7.ZT7_COD,"
    cQuery += "        ZT7.ZT7_DIACAL,"
    cQuery += "        ZT7.ZT7_VLVALE,"
    cQuery += "        ZT7.ZT7_TTVALE,"
    cQuery += "        ZT8.ZT8_FORN AS ZT7_FORN,"
    cQuery += "        SRA.RA_CC AS ZT7_CC,"
    cQuery += "        CTT." + cEntrCtt + " AS ZT7_LOCENT,"
    cQuery += "        SRA." + cEntrSra + " AS ZT7_LOCSRA,"
    cQuery += "        ZT7.R_E_C_N_O_ AS ZT7_RECNO"
    cQuery += " FROM " + RetSqlName( "ZT7" ) + " ZT7"
    cQuery += " LEFT OUTER JOIN " + RetSqlName( "SRA" ) + " SRA ON SRA.RA_FILIAL = ZT7.ZT7_FILIAL AND SRA.RA_MAT = ZT7.ZT7_MAT"
    cQuery += " LEFT OUTER JOIN " + RetSqlName( "CTT" ) + " CTT ON CTT.CTT_CUSTO = SRA.RA_CC " + If(!lCttFil, " AND CTT.CTT_FILIAL = SRA.RA_FILIAL", "" )
    cQuery += " LEFT OUTER JOIN " + RetSqlName( "ZT8" ) + " ZT8 ON ZT7.ZT7_COD = ZT8.ZT8_COD"
    cQuery += " WHERE  ZT7.D_E_L_E_T_ <> '*'"
    cQuery += "    AND SRA.D_E_L_E_T_ <> '*'"
    cQuery += "    AND CTT.D_E_L_E_T_ <> '*'"
    cQuery += "    AND ZT8.D_E_L_E_T_ <> '*'"
    cQuery += "    AND ZT7.ZT7_FILIAL BETWEEN '" + cFilDe + "' AND '" + cFilAte + "'"
    cQuery += "    AND ZT7.ZT7_MAT BETWEEN '" + cMatDe + "' AND '" + cMatAte + "'"
    cQuery += "    AND ZT7.ZT7_CC BETWEEN '" + cCcDe + "' AND '" + cCcAte + "'"
    cQuery += "    AND ZT7.ZT7_DATARQ = '" + MesAno(dDtRef) + "'"
    cQuery += "    AND ZT7.ZT7_STATUS = '1'"
    cQuery += "    AND SRA.RA_SITFOLH <> 'D'"
    cQuery += "    AND SRA." + cEntrSra + " = '   ' "
    cQuery += "    AND CTT." + cEntrCtt + " = '" + ZTD->ZTD_CODIGO + "'"
    cQuery += "    AND ZT8.ZT8_FORN = '" + cCodForn + "'"
    cQuery += "    AND ZT7.ZT7_TIPO = '" + cGerBen + "'"  		// 1=Vale Refeicao - 2=Vale Alimentacao
    cQuery += "    AND ZT7.ZT7_PERIOD = '" + cPerCalc + "'"
    cQuery += "    AND ZT7.ZT7_TTVALE > 0 "    //OS 3055/14
    If lReproc
       cQuery += " AND ZT7.ZT7_PEDIDO IN ('1','5')"		// 1=Pedido Compra - 2=Pagto Folha - 3=Pagto Adto - 4=Gerar CNAB - 5=Pedido Efetuado - 6=CNAB Gerado
    Else
       cQuery += " AND ZT7.ZT7_PEDIDO = '1'"
    EndIf
 EndIf
 cQuery += " ORDER BY SRA.RA_CC, ZT7.ZT7_FILIAL, ZT7.ZT7_MAT, ZT7.ZT7_COD"

 cQuery := ChangeQuery( cQuery )
 TCQuery cQuery New Alias "WZT7"
 TcSetField( "WZT7" , "ZT7_DIACAL" , "N", 03, 0 )
 TcSetField( "WZT7" , "ZT7_VLVALE" , "N", 12, 2 )
 TcSetField( "WZT7" , "ZT7_TTVALE" , "N", 12, 2 )
 TcSetField( "WZT7" , "ZT7_RECNO"  , "N", 12, 0 )
 
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
 aAdd(aRegs,{ cPerg,'08','Beneficio a Gerar  ?         ','','','mv_ch8','N',01,0,0,'C','            ','mv_par08','Vale Refeicao    ','','','','','Vale Alimentacao ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
 aAdd(aRegs,{ cPerg,'09','Periodo a Processar ?        ','','','mv_ch9','C',01,0,0,'G','U_fBnfPer(1)','mv_par09','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
 aAdd(aRegs,{ cPerg,'10','Local Geracao do Arquivo ?   ','','','mv_cha','C',40,0,0,'G','NaoVazio    ','mv_par10','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'U_PATH','' })
 aAdd(aRegs,{ cPerg,'11','Reprocessa Reg Ja Gerados ?  ','','','mv_chb','N',01,0,0,'C','            ','mv_par11','Sim              ','','','','','Nao              ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
 aAdd(aRegs,{ cPerg,'12','Data Entrega do Pedido ?     ','','','mv_chc','D',08,0,0,'G','NaoVazio    ','mv_par12','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })

ValidPerg(aRegs,cPerg)

Return   
