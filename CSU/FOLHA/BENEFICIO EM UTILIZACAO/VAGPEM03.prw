#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VAGPEM03 บ Autor ณ Adilson Silva      บ Data ณ 25/04/2007  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Calculo da Diferenca do Vale Alimentacao.                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function VAGPEM03

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private cPerg    := "VAGPEM03"
Private cString  := "SRA"
Private oGeraTxt

fAsrPerg()
pergunte(cPerg,.F.)

dbSelectArea( "SRA" )
dbSetOrder(1)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem da tela de processamento.                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DEFINE MSDIALOG oGeraTxt FROM  200,001 TO 410,480 TITLE OemToAnsi( "Calculo Diferen็a Alimenta็ใo" ) PIXEL

 @ 002, 010 TO 095, 230 OF oGeraTxt  PIXEL

 @ 010, 018 SAY " Este programa ira calular os valores da diferen็a do vale     " SIZE 200, 007 OF oGeraTxt PIXEL
 @ 018, 018 SAY " Alimentacao.                                                   " SIZE 200, 007 OF oGeraTxt PIXEL
 @ 026, 018 SAY "                                                               " SIZE 200, 007 OF oGeraTxt PIXEL

 DEFINE SBUTTON FROM 070,128 TYPE 5 ENABLE OF oGeraTxt ACTION (Pergunte(cPerg,.T.))
 DEFINE SBUTTON FROM 070,158 TYPE 1 ENABLE OF oGeraTxt ACTION (OkGeraTxt(),oGeraTxt:End())
 DEFINE SBUTTON FROM 070,188 TYPE 2 ENABLE OF oGeraTxt ACTION (oGeraTxt:End())

ACTIVATE MSDIALOG oGeraTxt Centered

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณOKGERATXT บ Autor ณ AP5 IDE            บ Data ณ  28/12/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao chamada pelo botao OK na tela inicial de processamenบฑฑ
ฑฑบ          ณ to. Executa a geracao do arquivo texto.                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function OkGeraTxt
 Processa({|| RunCont() },"Processando...")
 Close(oGeraTxt)
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

Static Function RunCont

Local dDtRef, nLen, lAfastado, aAfasta
Local aTabVr, nPos, nSraRec
Local nTotVale, nDesconto, nEmpresa
Local nTotAcum
Local aExtras, aDiasMes, aAfast
Local nX, nY, nZ
Local cPerDe, cPerAte

Private cFilDe, cFilAte, cMatDe, cMatAte, cCcDe, cCcAte, nOrdem
Private cCond, dPerIni, dPerFim, cPerPgto
Private nDiasVale

Pergunte(cPerg,.F.)
 dDtDe     := mv_par01
 dDtAte    := mv_par02
 cFilDe    := mv_par03
 cFilAte   := mv_par04
 cMatDe    := mv_par05
 cMatAte   := mv_par06
 cCcDe     := mv_par07
 cCcAte    := mv_par08
 nOrdem    := mv_par09
 cPerPgto  := mv_par10

ZT7->(dbSetOrder( 1 ))
ZT3->(dbSetOrder( 1 ))

nSraRec := SRA->(Recno())
cPerDe  := MesAno( dDtDe )
cPerAte := MesAno( dDtAte )

If !fCargaTab( @aTabVr )
   Aviso("ATENCAO","Tabela do Vale Alimenta็ใo Nao Cadastrada",{"Sair"})
   Return
EndIf

dbSelectArea( "SRA" )
dbSetOrder( nOrdem )

If nOrdem == 2
   dbSeek( cFilDe + cCcDe, .T. )
   cCond := "SRA->(RA_FILIAL+RA_CC) <= cFilAte+cCcAte"
Else
   dbSeek( cFilDe + cMatDe, .T. )
   cCond := "SRA->(RA_FILIAL+RA_MAT) <= cFilAte+cMatAte"
EndIf

ProcRegua( RecCount() )

Do While !Eof() .And. &cCond
   IncProc( SRA->(RA_FILIAL + " - " + RA_NOME) )
      
   If (SRA->RA_FILIAL  < cFilDe  .Or. SRA->RA_FILIAL  > cFilAte) .Or. ;
      (SRA->RA_MAT     < cMatDe  .Or. SRA->RA_MAT     > cMatAte) .Or. ;
      (SRA->RA_CC      < cCcDe   .Or. SRA->RA_CC      > cCcAte)
      dbSkip()
      Loop
   EndIf

   nTotAcum := 0

   dbSelectArea( "ZT7" )
   dbSeek( SRA->(RA_FILIAL + RA_MAT) )
   Do While !Eof() .And. ZT7->(ZT7_FILIAL + ZT7_MAT) == SRA->(RA_FILIAL + RA_MAT)
      If ZT7->ZT7_DATARQ < cPerDe .Or. ZT7->ZT7_DATARQ > cPerAte .Or. ZT7->ZT7_DIACAL == 0
         dbSkip()
         Loop
      EndIf

      nDiasVale := ZT7->ZT7_DIACAL
      //nDiasVale += ZT7->ZT7_DIAEXT
      
      If ( nPos := Ascan(aTabVr,{|x| x[1]==ZT7->ZT7_COD}) ) > 0
         nTotVale := Round( nDiasVale * aTabVr[nPos,4],2 )
         nTotVale -= ZT7->ZT7_TTVALE
         nTotAcum += nTotVale
      EndIf
      
      dbSkip()
   EndDo
   If nTotAcum > 0
      dbSelectArea( "ZT3" )
      If dbSeek( SRA->(RA_FILIAL + RA_MAT) + cPerPgto )
         RecLock("ZT3",.F.)
      Else
         RecLock("ZT3",.T.)
          ZT3->ZT3_FILIAL := SRA->RA_FILIAL
          ZT3->ZT3_MAT    := SRA->RA_MAT
          ZT3->ZT3_DATARQ := cPerPgto
      EndIf
       ZT3->ZT3_DIFVAL := nTotAcum
      MsUnlock()
   EndIf
   dbSelectArea( "SRA" )

   dbSkip()
EndDo

SRA->(dbGoTo( nSraRec ))

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVAGPEM03  บAutor  ณMicrosiga           บ Data ณ  04/25/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fCargaTab( aTabVr )

 Local aOld := GETAREA()
 Local lRet := .F.
 
 aTabVr   := {}
 
 dbSelectArea( "ZT8" )
 dbGoTop()
 Do While !Eof()
    Aadd(aTabVr,{ZT8->ZT8_COD,				; // 01 Codigo
                  ZT8->ZT8_DESC,			; // 02 Descricao
                  ZT8->ZT8_TIPO,			; // 03 Tipo
                  ZT8->ZT8_VALOR,	 		; // 04 Valor Unitario do Vale
                  ZT8->ZT8_PERC,			; // 05 Percentual do Desconto do Funcionario
                  ZT8->ZT8_TETO}			) // 06 Teto do Desconto
    
    If aTabVr[Len(aTabVr),6] == 0
       aTabVr[Len(aTabVr),6] := 999999.99
    EndIf

    dbSkip()
 EndDo
 
 lRet := Len( aTabVr ) > 0

 RESTAREA( aOld )
 
Return( lRet )

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
 aAdd(aRegs,{ cPerg,'01','Data Referencia De ?          ','','','mv_ch1','D',08,0,0,'G','NaoVazio'   ,'mv_par01',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
 aAdd(aRegs,{ cPerg,'02','Data Referencia Ate ?         ','','','mv_ch2','D',08,0,0,'G','NaoVazio'   ,'mv_par02',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
 aAdd(aRegs,{ cPerg,'03','Filial De ?                   ','','','mv_ch3','C',Fi,0,0,'G','        '   ,'mv_par03',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SM0   ','' })
 aAdd(aRegs,{ cPerg,'04','Filial Ate ?                  ','','','mv_ch4','C',Fi,0,0,'G','NaoVazio'   ,'mv_par04',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SM0   ','' })
 aAdd(aRegs,{ cPerg,'05','Matricula De ?                ','','','mv_ch5','C',06,0,0,'G','        '   ,'mv_par05',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SRA   ','' })
 aAdd(aRegs,{ cPerg,'06','Matricula Ate ?               ','','','mv_ch6','C',06,0,0,'G','NaoVazio'   ,'mv_par06',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SRA   ','' })
 aAdd(aRegs,{ cPerg,'07','Centro Custo De ?             ','','','mv_ch7','C',20,0,0,'G','        '   ,'mv_par07',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'CTT   ','' })
 aAdd(aRegs,{ cPerg,'08','Centro Custo Ate ?            ','','','mv_ch8','C',20,0,0,'G','NaoVazio'   ,'mv_par08',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'CTT   ','' })
 aAdd(aRegs,{ cPerg,'09','Ordem de Calculo ?            ','','','mv_ch9','N',01,0,0,'C','        '   ,'mv_par09','Matricula'        ,'','','','','Centro Custo'     ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
 aAdd(aRegs,{ cPerg,'10','Para Pagamento em AAAAMM ?    ','','','mv_cha','C',06,0,0,'G','NaoVazio'   ,'mv_par10',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
 U_fDelSx1( cPerg, "11" )

ValidPerg(aRegs,cPerg)

Return   
