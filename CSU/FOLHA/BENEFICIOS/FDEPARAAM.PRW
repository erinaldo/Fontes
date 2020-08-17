#INCLUDE "Protheus.ch"
#INCLUDE "Rwmake.ch"
#include "TOPCONN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFDEPARAAM บ Autor ณIsamu K.            บ Data ณ  17/02/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณEfetua Depara de tabelas de Assistencia M้dica              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณExclusivo para CSU                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function fDeparaAM


Local lContou := .F.
Local cQr

Private cPerg := "FDEPARAAM "

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria as perguntas na tabela SX1 caso nใo existam.                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
PutSx1(cPerg, "01","Filial De                     ","","","mv_ch1" 	,"C",02,0,0,"G",""											, "SM0","","","mv_par01"," "		," "," ","",""			,"","","","            ","","","","","","","",{"Filial inicial"	   		    },{},{})
PutSx1(cPerg, "02","Filial At้                    ","","","mv_ch2" 	,"C",02,0,0,"G","NaoVazio"									, "SM0","","","mv_par02"," "		," "," ","",""			,"","","","            ","","","","","","","",{"Filial final"				},{},{})
PutSx1(cPerg, "03","Matricula de                  ","","","mv_ch3" 	,"C",06,0,0,"G",""  										, "SRA","","","mv_par03"," "		," "," ","",""			,"","","","            ","","","","","","","",{"Matrํcula inicial"			},{},{})
PutSx1(cPerg, "04","Matricula at้                 ","","","mv_ch4" 	,"C",06,0,0,"G","NaoVazio"									, "SRA","","","mv_par04"," "		," "," ","",""			,"","","","            ","","","","","","","",{"Matrํcula final"			},{},{})
PutSx1(cPerg, "05","Perํodo de (MMAAAA)           ","","","mv_ch5" 	,"C",06,0,0,"G",""  	   									, ""   ,"","","mv_par05"," "		," "," ","",""			,"","","","            ","","","","","","","",{"Data inicial"				},{},{})

If !Pergunte( cPerg, .t. )
	Return
EndIf


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem da tela de processamento.                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
@ 200,1 TO 400,480 DIALOG oLeTxt TITLE OemToAnsi("Efetua Depara das Tabelas de Assist๊ncia M้dica")
@ 02,10 TO 095,230
@ 10,018 Say " Este programa ira efetuar a troca dos codigos de Assistencia  "
@ 18,018 Say " M้dica nas tabelas RHK, RHL, RHR, conforme parametros    "
@ 26,018 Say " definidos pelo usuario.                                       "
@ 70,128 BMPBUTTON TYPE 01 ACTION OkLeTxt()
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)
@ 70,188 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)
Activate Dialog oLeTxt Centered

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ OKLETXT  บ Autor ณ AP6 IDE            บ Data ณ  18/05/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao chamada pelo botao OK na tela inicial de processamenบฑฑ
ฑฑบ          ณ to. Executa a leitura do arquivo texto.                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function OkLeTxt

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicializa a regua de processamento                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Processa({|| RunCont() },"Processando...")


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ RUNCONT  บ Autor ณ Isamu K.           บ Data ณ  04/07/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function RunCont

Local cCodOld := ""
Local lTroca
Local cCodNovo
Local nX, nW, nZ
Local aRHK := {}
Local aRHL := {}
Local aRHS := {}


dbSelectArea("RHK")
dbGotop()

ProcRegua(RHK->(RecCount()))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAlimenta o arquivo que sera gerado para o usuario. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
While !RHK->( Eof() )
	
	IncProc("Efetuando Depara na Tabela 'Plano Ativo Titulares'. Aguarde...... !!!")
	
	If Rhk->Rhk_Filial < mv_par01 .or. Rhk->Rhk_Filial > mv_par02 .or.;
		Rhk->Rhk_Mat < mv_par03 .or. Rhk->Rhk_Mat > mv_par04
		RHK->(dbSkip())
		Loop
	Endif
	
	
	If Rhk->Rhk_TpForn <> "1"
		RHK->(dbSkip())
		Loop
	Endif
	
	If !(Empty(Rhk->Rhk_PerFim))
		RHK->(dbSkip())
		Loop
	Endif
	
	cCodOld := Rhk->Rhk_Plano
	
	fNewCod(@lTroca,@cCodNovo,cCodOld)
	
	If !lTroca
		RHK->(dbSkip())
		Loop
	Endif
	
	//If Rhk_PerIni >= "082014" //mv_par05
	
	cFilAtu    := Rhk->Rhk_Filial
	cMatAtu    := Rhk->Rhk_Mat
	cFornAtu   := Rhk->Rhk_TpForn
	cCodForAtu := fBuscaFor(cCodNovo)
	cTpPlanAtu := Rhk->Rhk_TpPlan
	cPdTitAtu  := Rhk->Rhk_Pd
	cPdDepAtu  := Rhk->Rhk_PddAgr
	
	aaDD(aRHK,{cFilAtu,cMatAtu,cFornAtu,cCodForAtu,cTpPlanAtu,cCodNovo,cPdTitAtu,cPdDepAtu,"082014"})
	
	RecLock("RHK",.F.)
	Rhk_PerFim := "072014"
	RHK->(MsUnlock())
	
	//Endif
	
	Rhk->(dbSkip())
	
EndDo

For NW := 1 to Len(aRHK)
	If Rhk->(dbSeek(aRHK[nW,1]+aRHK[nW,2]+aRHK[nW,3]+aRHK[nW,4]))
		RecLock("RHK",.F.)
	Else
		RecLock("RHK",.T.)
	Endif
	Rhk_Filial := aRHK[nW,1]
	Rhk_Mat    := aRHK[nW,2]
	Rhk_TpForn := aRHK[nW,3]
	Rhk_CodFor := aRHK[nW,4]
	Rhk_TpPlan := aRHK[nW,5]
	Rhk_Plano  := aRHK[nW,6]
	Rhk_Pd     := aRHK[nW,7]
	Rhk_PddAgr := aRHK[nW,8]
	Rhk_PerIni := aRHK[nW,9]
	RHK->(MsUnlock())
	
Next
//cCodOld := ""
//lTroca  := .F.
//cCodNovo := ""

dbSelectArea("RHL")
dbSetOrder(1)

ProcRegua(RHL->(RecCount()))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAlimenta o arquivo que sera gerado para o usuario. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
While !RHL->( Eof() )
	
	IncProc("Efetuando Depara na Tabela 'Plano Ativo Dependentes'. Aguarde...... !!!")
	
	
	If Rhl->Rhl_Filial < mv_par01 .or. Rhl->Rhl_Filial > mv_par02 .or.;
		Rhl->Rhl_Mat < mv_par03 .or. Rhl->Rhl_Mat > mv_par04
		dbSelectArea("RHL")
		dbSkip()
		Loop
	Endif
	
	If !(Empty(Rhl->Rhl_PerFim))
		dbSelectArea("RHL")
		dbSkip()
		Loop
	Endif
	
	If Rhl->Rhl_TpForn <> "1"
		dbSelectArea("RHL")
		dbSkip()
		Loop
	Endif
	
	cCodOld := Rhl->Rhl_Plano
	
	lTroca  := .F.
	cCodNovo:= ""
	
	fNewCod(@lTroca,@cCodNovo,cCodOld)
	
	If !lTroca
		dbSelectArea("RHL")
		dbSkip()
		Loop
	Endif
	
	cFilx   := Rhl->Rhl_Filial
	cMatx   := Rhl->Rhl_Mat
	cTpFor  := Rhl->Rhl_TpForn
	cSeq    := Rhl->Rhl_Codigo
	cTpPlan := Rhl->Rhl_TpPlan
	cNewPlan:= cCodNovo
	cNewFor := fBuscaFor(cCodNovo)
	
	aaDD(aRHL,{cFilx,cMatx,cSeq,cTpFor,cNewFor,cTpPlan,cNewPlan,"082014"})
	
	RecLock("RHL",.F.)
	Rhl_PerFim := "072014"
	RHL->(MsUnlock())
	
	//Endif
	
	cCodOld := ""
	lTroca  := .F.
	cCodNovo := ""
	
	dbSelectArea("RHL")
	dbSkip()
	
EndDo

For nX := 1 to Len(aRHL)
	
	If Rhl->(dbSeek(aRHL[nX,1]+aRHL[nX,2]+aRHL[nX,4]+aRHL[nX,5]+aRHL[nX,3]))
		RecLock("RHL",.F.)
	Else
		RecLock("RHL",.T.)
	Endif
	Rhl_Filial := aRHL[nX,1]
	Rhl_Mat    := aRHL[nX,2]
	Rhl_Codigo := aRHL[nX,3]  //
	Rhl_TpForn := aRHL[nX,4]  //
	Rhl_CodFor := aRHL[nX,5]
	Rhl_TpPlan := aRHL[nX,6]
	Rhl_Plano  := aRHL[nX,7]
	Rhl_PerIni := aRHL[nX,8]
	RHL->(MsUnlock())
	
Next

//cCodOld := ""
//lTroca  := .F.
//cCodNovo := ""

dbSelectArea("RHS")
dbGotop()

ProcRegua(RHS->(RecCount()))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAlimenta o arquivo que sera gerado para o usuario. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
While !RHS->( Eof() )
	
	IncProc("Efetuando Depara na Tabela 'Historico do Cแlculo de Plano de Saude'. Aguarde...... !!!")
	
	cCodOld := Rhs->Rhs_Plano
	
	lTroca   := .F.
	cCodNovo := ""
	
	fNewCod(@lTroca,@cCodNovo,cCodOld)
	
	If Rhs->Rhs_Filial < mv_par01 .or. Rhs->Rhs_Filial > mv_par02 .or.;
		Rhs->Rhs_Mat < mv_par03 .or. Rhs->Rhs_Mat > mv_par04
		RHS->(dbSkip())
		Loop
	Endif
	
	If !lTroca
		Rhs->(dbSkip())
		Loop
	Endif
	
	If Rhs_CompPg >= "201408" //Subs(mv_par05,3,4)+Subs(mv_par05,1,2)
		
		RecLock("RHS",.F.)
		Rhs_Plano := cCodNovo
		Rhs_CodFor:= fBuscaFor(cCodNovo)
		RHS->(MsUnlock())
		
	Endif
	
	Rhs->(dbSkip())
	
EndDo



dbSelectArea("RHR")
dbGotop()

ProcRegua(RHR->(RecCount()))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAlimenta o arquivo que sera gerado para o usuario. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
While !RHR->( Eof() )
	
	IncProc("Efetuando Depara na Tabela 'Cแlculo de Plano de Saude'. Aguarde...... !!!")
	
	cCodOld := Rhr->Rhr_Plano
	
	lTroca   := .F.
	cCodNovo := ""
	
	fNewCod(@lTroca,@cCodNovo,cCodOld)
	
	If Rhr->Rhr_Filial < mv_par01 .or. Rhr->Rhr_Filial > mv_par02 .or.;
		Rhr->Rhr_Mat < mv_par03 .or. Rhr->Rhr_Mat > mv_par04
		RHR->(dbSkip())
		Loop
	Endif
	
	If !lTroca
		Rhr->(dbSkip())
		Loop
	Endif
	
	If Rhr_CompPg >= "201408" //Subs(mv_par05,3,4)+Subs(mv_par05,1,2)
		
		RecLock("RHR",.F.)
		Rhr_Plano := cCodNovo
		Rhr_CodFor:= fBuscaFor(cCodNovo)
		RHR->(MsUnlock())
		
	Endif
	
	Rhr->(dbSkip())
	
EndDo


Alert("Depara Efetuado com Sucesso !!!")

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณfBuscaFor บ Autor ณ Isamu K.           บ Data ณ  04/07/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fBuscaFor(cCodPl)


Local cCodX

dbSelectArea("RCC")
dbSetOrder(1)

If dbSeek(xFilial("RCC")+"S008")
	
	While Rcc->(!Eof())
		If Subs(Rcc->Rcc_Conteu,1,2) == Alltrim(cCodPl)
			cCodX := Subs(Rcc->Rcc_Conteu,92,2)
			Exit
		Endif
		dbSkip()
	EndDo
	
Endif


Return(cCodX)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณfBuscaFor บ Autor ณ Isamu K.           บ Data ณ  04/07/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fNewCod(lTroc,cCodN,cCodV)

Local cVelho := cCodV
Local cNovo
Local lTroc  := .F.

If cVelho == "60"
	cNovo := "A1"
	lTroc := .T.
ElseIf cVelho == "61"
	cNovo := "A2"
	lTroc := .T.
ElseIf cVelho == "62"
	cNovo := "A3"
	lTroc := .T.
ElseIf cVelho == "63"
	cNovo := "A4"
	lTroc := .T.
ElseIf cVelho == "64"
	cNovo := "A5"
	lTroc := .T.
ElseIf cVelho == "65"
	cNovo := "B5"
	lTroc := .T.
ElseIf cVelho == "66"
	cNovo := "A6"
	lTroc := .T.
ElseIf cVelho == "70"
	cNovo := "A7"
	lTroc := .T.
ElseIf cVelho == "71"
	cNovo := "A8"
	lTroc := .T.
ElseIf cVelho == "72"
	cNovo := "A9"
	lTroc := .T.
ElseIf cVelho == "73"
	cNovo := "B3"
	lTroc := .T.
ElseIf cVelho == "74"
	cNovo := "B4"
	lTroc := .T.
ElseIf cVelho == "75"
	cNovo := "B5"
	lTroc := .T.
ElseIf cVelho == "76"
	cNovo := "B6"
	lTroc := .T.
ElseIf cVelho == "77"
	cNovo := "B7"
	lTroc := .T.
ElseIf cVelho == "78"
	cNovo := "B8"
	lTroc := .T.
ElseIf cVelho == "79"
	cNovo := "B9"
	lTroc := .T.
ElseIf cVelho == "80"
	cNovo := "C1"
	lTroc := .T.
ElseIf cVelho == "81"
	cNovo := "C2"
	lTroc := .T.
ElseIf cVelho == "82"
	cNovo := "C3"
	lTroc := .T.
ElseIf cVelho == "83"
	cNovo := "C4"
	lTroc := .T.
Endif

If Empty(cNovo)
	cNovo := cVelho
Endif

cCodN := cNovo

Return
