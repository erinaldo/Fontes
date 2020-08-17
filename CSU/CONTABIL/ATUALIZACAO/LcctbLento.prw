#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLCCTB     บ Autor ณ Adilson Silva      บ Data ณ  14/08/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Geracao dos Lancamentos Contabeis da Folha de Pagamento    บฑฑ
ฑฑบ          ณ Nas Tabelas das Demais Empresas do Sistema.                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function LCCTB

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private cPerg    := PADR("LCTCTB",LEN(SX1->X1_GRUPO))
Private oGeraTxt
Private cString  := "CT2"

dbSelectArea( "CT2" )
dbSetOrder(1)

fAsrPerg()
pergunte(cPerg,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem da tela de processamento.                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
@ 200,001 TO 410,480 DIALOG oGeraTxt TITLE OemToAnsi( "Contabilizacao da Folha de Pagamento" )
@ 02,10 TO 095,230
@ 10,018 Say " Este programa ira gerar os lancamentos contabeis da folha de  "
@ 18,018 Say " pagamento nas demais empresas do sistema, conforme cadastro de"
@ 26,018 Say " centro de custo.                                              "

@ 70,128 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 70,188 BMPBUTTON TYPE 01 ACTION OkGeraTxt()

Activate Dialog oGeraTxt Centered

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ OKGERATXTบ Autor ณ AP5 IDE            บ Data ณ  09/07/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao chamada pelo botao OK na tela inicial de processamenบฑฑ
ฑฑบ          ณ to. Executa a geracao do arquivo texto.                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function OkGeraTxt()

 Processa({|| RunCont() },"Processando...")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ RUNCONT  บ Autor ณ AP5 IDE            บ Data ณ  09/07/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function RunCont()

Local dPerDe, dPerAte, lReprocessa, lGrava
Local cLote, nLinhas
Local i, o, nPos, cAux, aAux
Local aInd
Local lPrim02, lPrim03, lPrim04, lPrim09, lSair

Private aCabec, aPrint
Private aEmp02, aEmp03, aEmp04, aEmp09
Private nSbLte02, nDoc02, nLinha02
Private nSbLte03, nDoc03, nLinha03
Private nSbLte04, nDoc04, nLinha04
Private nSbLte09, nDoc09, nLinha09

Private aDeb02, aCred02
Private aDeb03, aCred03
Private aDeb04, aCred04
Private aDeb09, aCred09

pergunte(cPerg,.F.)
 dPerDe      := mv_par01
 dPerAte     := mv_par02
 lReprocessa := If(mv_par03==1,.T.,.F.)
 
If cEmpAnt # "05"
   Aviso("Aviso" ,"Processamento Exclusivo da Empresa 05." ,{"Voltar"})
   Return
EndIf

nLinhas := GETMV("MV_NUMLIN")

If !SX5->(dbSeek( xFilial("SX5")+"09GPE" ))
   Aviso("Lote Invalido","Numero do Lote da Folha de Pagamento Nao Cadatrado." ,{"Voltar"})
   Return
EndIf
cLote := Alltrim(SX5->X5_DESCRI)
cLote := StrZero(Val(cLote),6)
 
aCabec := {}
aEmp02 := {} ; aEmp03 := {} ; aEmp04 := {} ; aEmp09 := {}
dbSelectArea( "CT2" )
For i := 1 To Fcount()
    If Alltrim(FieldName(i)) == "CT2_ITFOL"
       Loop
    EndIf
    Aadd(aCabec,Alltrim(FieldName(i)))
Next

aInd := {}
dbSelectArea("SIX")
dbSeek( "CT2" )
Do While !Eof() .And. INDICE == "CT2"
   Aadd(aInd,ORDEM)
   dbSkip()
EndDo

dbUseArea(.T. ,"TOPCONN"  ,"CT2020" ,"CT2020" ,.t. ,.F.)
If !Used()
   Aviso("Aviso","Erro na Abertura da Tabela CT2020",{"Voltar"})
   Return
EndIf
For i := 1 To Len(aInd)
    dbSetIndex( "CT2020"+aInd[i] )
Next
dbSetOrder(1)

//For i := 1 To Fcount()
//    If (nPos := Ascan(aCabec,{|x| x=Alltrim(FieldName(i))}) ) == 0
//       Aviso("Aviso","Estrutura da Tabela CT2020 Nao Compativel com a Tabela CT2050. Campo "+FieldName(i) ,{"Voltar"})
//       Return
//    EndIf
//Next

dbUseArea(.T. ,"TOPCONN"  ,"CT2030" ,"CT2030" ,.t. ,.F.)
If !Used()
   Aviso("Aviso","Erro na Abertura da Tabela CT2030",{"Voltar"})
   Return
EndIf
For i := 1 To Len(aInd)
    dbSetIndex( "CT2030"+aInd[i] )
Next
dbSetOrder(1)
/*/For i := 1 To Fcount()
    If (nPos := Ascan(aCabec,{|x| x=Alltrim(FieldName(i))}) ) == 0
       Aviso("Aviso","Estrutura da Tabela CT2030 Nao Compativel com a Tabela CT2050. Campo "+FieldName(i) ,{"Voltar"})
       Return
    EndIf
Next/*/

dbUseArea(.T. ,"TOPCONN"  ,"CT2040" ,"CT2040" ,.t. ,.F.)
If !Used()
   Aviso("Aviso","Erro na Abertura da Tabela CT2040",{"Voltar"})
   Return
EndIf
For i := 1 To Len(aInd)
    dbSetIndex( "CT2040"+aInd[i] )
Next
dbSetOrder(1)

/*/For i := 1 To Fcount()
    If (nPos := Ascan(aCabec,{|x| x=Alltrim(FieldName(i))}) ) == 0
       Aviso("Aviso","Estrutura da Tabela CT2040 Nao Compativel com a Tabela CT2050. Campo "+FieldName(i) ,{"Voltar"})
       Return
    EndIf
Next/*/

dbUseArea(.T. ,"TOPCONN"  ,"CT2090" ,"CT2090" ,.t. ,.F.)

If !Used()
   Aviso("Aviso","Erro na Abertura da Tabela CT2090",{"Voltar"})
   Return
EndIf
For i := 1 To Len(aInd)
    dbSetIndex( "CT2090"+aInd[i] )
Next
dbSetOrder(1)

/*/For i := 1 To Fcount()
    If (nPos := Ascan(aCabec,{|x| x=Alltrim(FieldName(i))}) ) == 0
       Aviso("Aviso","Estrutura da Tabela CT2090 Nao Compativel com a Tabela CT2050. Campo "+FieldName(i) ,{"Voltar"})
       Return
    EndIf
Next/*/

dbSelectArea( "CTT" )
dbSetOrder(1)

nSbLte02 := 1 ; nDoc02 := 0 ; nLinha02 := 0
nSbLte03 := 1 ; nDoc03 := 0 ; nLinha03 := 0
nSbLte04 := 1 ; nDoc04 := 0 ; nLinha04 := 0
nSbLte09 := 1 ; nDoc09 := 0 ; nLinha09 := 0

aDeb02 := Array(1)  ; aCred02 := Array(1)
aFill(aDeb02,0)     ; aFill(aCred02,0)
aDeb03 := Array(1)  ; aCred03 := Array(1)
aFill(aDeb03,0)     ; aFill(aCred03,0)
aDeb04 := Array(1)  ; aCred04 := Array(1)
aFill(aDeb04,0)     ; aFill(aCred04,0)
aDeb09 := Array(1)  ; aCred09 := Array(1)
aFill(aDeb09,0)     ; aFill(aCred09,0)

lSair  := .F.
lPrim02 := .T. ; lPrim03 := .T. ; lPrim04 := .T. ; lPrim09 := .T.
aPrint := {}

dbSelectArea( "CT2" )
dbSetOrder(1)

_cFiltro:="DTOS(CT2_DATA)>='"+DTOS(dPerde)+"'.and.dtos(ct2_data)<='"+dtos(dPerAte)+"'"

CT2->(INDREGUA(ALIAS(),CRIATRAB(,.F.),INDEXKEY(),,_cFiltro))

dbGoTop()
ProcRegua( RecCount() )

Do While !Eof()
   IncProc()
   
   If CT2->CT2_DATA < dPerDe  .Or. CT2->CT2_DATA > dPerAte
      dbSkip()
      Loop
   EndIf
   
   IF CT2->CT2_LP <= "999"
      dbSkip()
      Loop            
   EndIf              
   If CT2->CT2_ITFOL == "S" .And. !lReprocessa
      dbSkip()
      Loop
   EndIf
   
   If !CTT->(dbSeek( xFilial("CTT")+CT2->CT2_CCD ))
      Aadd(aPrint,"Centro de Custo Nao Cadastrado "+CT2->CT2_CCD)
      dbSkip()
      Loop
   EndIf
   
 // Verifica se ja foi contabilizado
   If CTT->CTT_EMPRES == "02"
      If lPrim02
         lSair   := fTestaLct(CTT->CTT_EMPRES,cLote)
         lPrim02 := .F.
      EndIf
   ElseIf CTT->CTT_EMPRES == "03"
      If lPrim03
         lSair   := fTestaLct(CTT->CTT_EMPRES,cLote)
         lPrim03 := .F.
      EndIf
   ElseIf CTT->CTT_EMPRES == "04"
      If lPrim04
         lSair   := fTestaLct(CTT->CTT_EMPRES,cLote)
         lPrim04 := .F.
      EndIf
   ElseIf CTT->CTT_EMPRES == "09"
      If lPrim09
         lSair   := fTestaLct(CTT->CTT_EMPRES,cLote)
         lPrim09 := .F.
      EndIf
   EndIf
   If lSair
      Aviso("Aviso","Periodo ja Contabilizado (Empresa "+ctt->ctt_empres+"). Favor Eliminar os Lotes ("+cLote+") para Reprocessar. " ,{"Abandona"})
      Aadd(aPrint,"Periodo ja Contabilizado")
      Exit
   EndIf

   lGrava := .F.
   If CTT->CTT_EMPRES == "02"
      nLinha02++
      fLanca( @aEmp02,nLinha02 )
      lGrava  := .T.
      If !Empty(CT2->CT2_DEBITO)
         aDeb02[1] += CT2->CT2_VALOR
      EndIf
      If !Empty(CT2->CT2_CREDIT)
         aCred02[1] += CT2->CT2_VALOR
      EndIf
   ElseIf CTT->CTT_EMPRES == "03"
      nLinha03++
      fLanca( @aEmp03,nLinha03 )
      lGrava  := .T.
      If !Empty(CT2->CT2_DEBITO)
         aDeb03[1] += CT2->CT2_VALOR
      EndIf
      If !Empty(CT2->CT2_CREDIT)
         aCred03[1] += CT2->CT2_VALOR
      EndIf
   ElseIf CTT->CTT_EMPRES == "04"
      nLinha04++
      fLanca( @aEmp04,nLinha04 )
      lGrava  := .T.
      If !Empty(CT2->CT2_DEBITO)
         aDeb04[1] += CT2->CT2_VALOR
      EndIf
      If !Empty(CT2->CT2_CREDIT)
         aCred04[1] += CT2->CT2_VALOR
      EndIf
   ElseIf CTT->CTT_EMPRES == "09"
      nLinha09++
      fLanca( @aEmp09,nLinha09 )
      lGrava  := .T.
      If !Empty(CT2->CT2_DEBITO)
         aDeb09[1] += CT2->CT2_VALOR
      EndIf
      If !Empty(CT2->CT2_CREDIT)
         aCred09[1] += CT2->CT2_VALOR
      EndIf
   Else
      Aadd(aPrint,"Empresa "+CTT->CTT_EMPRES+" Nao Cadastrada")
   EndIf
	
   dbSelectArea( "CT2" )
   If lGrava
      RecLock("CT2",.F.)
       CT2->CT2_ITFOL := "S"
      MsUnlock()
   EndIf

   dbSkip()
   
   If Eof() .Or. nLinha02 == nLinhas 
      If Len(aEmp02) > 0
         nDoc02++
         fGrava( aEmp02,"02",cLote )
         nLinha02 := 0
         aEmp02 := {}
      EndIf
   EndIf
   If Eof() .Or. nLinha03 == nLinhas
      If Len(aEmp03) > 0
         nDoc03++
         fGrava( aEmp03,"03",cLote )
         nLinha03 := 0
         aEmp03 := {}
      EndIf
   EndIf
   If Eof() .Or. nLinha04 == nLinhas
      If Len(aEmp04) > 0
         nDoc04++
         fGrava( aEmp04,"04",cLote )
         nLinha04 := 0
         aEmp04 := {}                  
      EndIf
   EndIf
   If Eof() .Or. nLinha09 == nLinhas
      If Len(aEmp09) > 0
         nDoc09++
         fGrava( aEmp09,"09",cLote )
         nLinha09 := 0
         aEmp09 := {}         
      EndIf
   EndIf
EndDo
If !lSair
   If aDeb02[1]+aCred02[1]+aDeb03[1]+aCred03[1]+aDeb04[1]+aCred04[1]+aDeb09[1]+aCred09[1] > 0
      fAsrPrint()
   EndIf
EndIf
dbSelectArea( "CT2020" )
dbCloseArea()
dbSelectArea( "CT2030" )
dbCloseArea()
dbSelectArea( "CT2040" )
dbCloseArea()
dbSelectArea( "CT2090" )
dbCloseArea()

Close(oGeraTxt)

CT2->(DBCLEARFIL())
CT2->(RETINDEX())

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLCCTB     บAutor  ณMicrosiga           บ Data ณ  08/18/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fTestaLct(cEmp,cLote)

 Local aOld := GETAREA()
 Local lRet := .F.

 xAlias := If(cEmp=="02","CT2020",If(cEmp=="03","CT2030",If(cEmp=="04","CT2040","CT2090")))
 dbSelectArea( xAlias )
 If dbSeek( "01"+Dtos(CT2->CT2_DATA)+cLote )
    lRet := .T.
 EndIf
 
 RESTAREA( aOld )

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLCCTB     บAutor  ณMicrosiga           บ Data ณ  08/15/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fLanca(aLanca,xLin)
 Local cAux, i

 Aadd(aLanca,{})
 For i := 1 To Len(aCabec)
     If aCabec[i] == "CT2_LINHA"
        Aadd(aLanca[Len(aLanca)],xLin)
     ElseIf aCabec[i] == "CT2_CCC"
        If !Left(CT2->CT2_CREDIT,1) $ "12"
           Aadd(aLanca[Len(aLanca)],CTT->CTT_CCCONT)
        Else
           Aadd(aLanca[Len(aLanca)]," ")
        EndIf
     ElseIf aCabec[i] == "CT2_CCD"
        If !Left(CT2->CT2_DEBITO,1) $ "12"
           Aadd(aLanca[Len(aLanca)],CTT->CTT_CCCONT)
        Else
           Aadd(aLanca[Len(aLanca)]," ")
        EndIf
     Else
        cAux := "CT2->"+aCabec[i]
        Aadd(aLanca[Len(aLanca)],&cAux)
     EndIf
 Next

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLCCTB     บAutor  ณMicrosiga           บ Data ณ  08/15/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fGrava( aLanca,cEmp,cLote )

 Local aOld := GETAREA()
 Local i, o, cAux, nPos, xAlias
 Local xSbLte, xDoc

 xSbLte := "nSbLte"+cEmp
 xDoc   := "nDoc"+cEmp
 
 xAlias := If(cEmp=="02","CT2020",If(cEmp=="03","CT2030",If(cEmp=="04","CT2040","CT2090")))

 dbSelectArea( xAlias )
 _vStruct:=dbstruct()

 For i := 1 To Len(aLanca)
     RecLock( xAlias,.T. )
     
     // Atrasa o processamento
     for _nVez:=1 to 5000
     next
     
     For o := 1 To Len(aCabec)
         cAux := xAlias +"->"+ aCabec[o]
         If aCabec[o] == "CT2_FILIAL"
            &(cAux) := "01"
         ElseIf aCabec[o] == "CT2_SBLOTE"
            &(cAux) := StrZero( &(xSbLte),3 )
         ElseIf aCabec[o] == "CT2_DOC"
            &(cAux) := StrZero( &(xDoc),6 )
         ElseIf aCabec[o] == "CT2_LINHA"
            _nLinha:=aLanca[i,o]
            if _nLinha>999
               _cLinha:="999"
               for _nVez:=999 to _nLinha
                   _cLinha:=soma1(_cLinha)
               next
            else
               _cLinha:=strzero(_nLinha,3)
            endif
            &(cAux) := _cLinha
         ElseIf aCabec[o] == "CT2_LOTE"
            &(cAux) := cLote
         ElseIf aCabec[o] == "CT2_EMPORI"
            &(cAux) := cEmp
         ElseIf aCabec[o] == "CT2_FILORI"
            &(cAux) := "01"
         Elseif ascan(_vStruct,{|_vAux|alltrim(_vAux[1])==alltrim(aCabec[o])})>0
            &(cAux) := aLanca[i,o]
         EndIf
     Next
     MsUnlock()
     for _nVez:=1 to 5000
     next
     ct2020->(dbcommit())
     ct2030->(dbcommit())
     ct2040->(dbcommit())
     ct2090->(dbcommit())

     for _nVez:=1 to 5000
     next
     DbCommitall()
     for _nVez:=1 to 5000
     next
     
 Next

 RESTAREA( aOld )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfAsrPrint บAutor  ณMicrosiga           บ Data ณ  08/16/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Emissao do Log de Ocorrencias.                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fAsrPrint()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Log de Contabilizacao"
Local cPict          := ""
Local titulo         := "LOG DE CONTABILIZACAO"
Local nLin           := 80
Local Cabec1         := " EMPRESA              DEBITO                 CREDITO               DIFERENCA"
Local Cabec2         := ""
Local imprime        := .T.

Private aOrd         := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "LCCTB"
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "LCCTB"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
wnrel := SetPrint(cString,NomeProg,,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.T.)
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
 
 Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
 nLin := 10

 @ nLin,003 PSAY "20"
 @ nLin,012 PSAY Transform(aDeb02[1],'@E 9,999,999,999.99')
 @ nLin,036 PSAY Transform(aCred02[1],'@E 9,999,999,999.99')
 @ nLin,060 PSAY Transform(aDeb02[1]-aCred02[1],'@E 9,999,999,999.99')
 nLin += 3

 @ nLin,003 PSAY "30"
 @ nLin,012 PSAY Transform(aDeb03[1],'@E 9,999,999,999.99')
 @ nLin,036 PSAY Transform(aCred03[1],'@E 9,999,999,999.99')
 @ nLin,060 PSAY Transform(aDeb03[1]-aCred03[1],'@E 9,999,999,999.99')
 nLin += 3
 
 @ nLin,003 PSAY "40"
 @ nLin,012 PSAY Transform(aDeb04[1],'@E 9,999,999,999.99')
 @ nLin,036 PSAY Transform(aCred04[1],'@E 9,999,999,999.99')
 @ nLin,060 PSAY Transform(aDeb04[1]-aCred04[1],'@E 9,999,999,999.99')
 nLin += 3

 @ nLin,003 PSAY "90"
 @ nLin,012 PSAY Transform(aDeb09[1],'@E 9,999,999,999.99')
 @ nLin,036 PSAY Transform(aCred09[1],'@E 9,999,999,999.99')
 @ nLin,060 PSAY Transform(aDeb09[1]-aCred09[1],'@E 9,999,999,999.99')
 nLin += 3

 @ nLin,003 PSAY "TOTAL"
 @ nLin,012 PSAY Transform(aDeb02[1]+aDeb03[1]+aDeb04[1]+aDeb09[1],'@E 9,999,999,999.99')
 @ nLin,036 PSAY Transform(aCred02[1]+aCred03[1]+aCred04[1]+aCred09[1],'@E 9,999,999,999.99')
 @ nLin,060 PSAY Transform((aDeb02[1]+aDeb03[1]+aDeb04[1]+aDeb09[1])-(aCred02[1]+aCred03[1]+aCred04[1]+aCred09[1]),'@E 9,999,999,999.99')

 nLin := 80
 If Len(aPrint) > 0
    For i := 1 To Len(aPrint)
        If nLin >= 80
           Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
           nLin := 08
           @ nLin,005 PSAY "OCORRENCIAS DA INTEGRACAO DA CONTABILIDADE"
        EndIf
    
        @ nLin,005 PSAY aPrint[i]
        nLin++
        
        If nLin >= 55
           nLin := 80
        EndIf
    Next
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

aAdd(aRegs,{cPerg,'01','Data Lancamento De    ?','','','mv_ch1','D',08,0,0,'G','NaoVazio   ','mv_par01','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ',''})
aAdd(aRegs,{cPerg,'02','Data Lancamento Ate   ?','','','mv_ch2','D',08,0,0,'G','NaoVazio   ','mv_par02','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ',''})
aAdd(aRegs,{cPerg,'03','Reprocessa Periodo    ?','','','mv_ch3','N',01,0,0,'C','           ','mv_par03','Sim            ','','','','','Nao          ','','','','','             ','','','','','              ','','','','','               ','','','','   ',''})

ValidPerg(aRegs,cPerg)

Return


//         1         2         3         4         5         6         7         8
//12345678901234567890123456789012345678901234567890123456789012345678901234567890
//EMPRESA              DEBITO                 CREDITO               DIFERENCA
//  01       9,999,999,999.99        9,999,999,999.99        9,999,999,999.99
 
