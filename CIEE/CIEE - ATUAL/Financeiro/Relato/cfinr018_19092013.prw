#DEFINE ENTRADA 1
#DEFINE SAIDA   2

#INCLUDE "rwmake.ch"
#Include "TopConn.ch"
#include "_FixSX.ch"
#INCLUDE "DelAlias.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ CFINR018 ³ Autor ³ Andy Pudja   		    ³ Data ³ 29.03.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Aplicacao Financeira                             		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CFINR018()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis 														  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL wnrel
LOCAL cDesc1  := "Este programa emitir a Aplicação Financeira"
LOCAL cDesc2  := ""
LOCAL cDesc3  := ""
LOCAL cString :="SE5"
LOCAL Tamanho :="M"
Private LIMITE   := 132
PRIVATE titulo   :=OemToAnsi("Aplicação Financeira")
PRIVATE cabec1
PRIVATE cabec2
PRIVATE aReturn  := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 2, 2, 1, "",1 }
PRIVATE nomeprog :="CFINR018"
PRIVATE aLinha   := { },nLastKey := 0
PRIVATE cPerg	 :="FINR18    "
Private _aAliases:= {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas 								  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

pergunte("FINR18    ",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01 - Conta de                                    ³
//³ mv_par02 - Conta ate                                   ³
//³ mv_par03 - Emissao de                                  ³
//³ mv_par04 - Emissao ate                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_aPerg := {}

AADD(_aPerg,{cPerg,"01","Conta de           ?","","","mv_ch1","C",10,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","BZC","",""})
AADD(_aPerg,{cPerg,"02","Conta ate          ?","","","mv_ch2","C",10,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","BZC","",""})
AADD(_aPerg,{cPerg,"03","Data de            ?","","","mv_ch3","D",08,0,0,"G","","mv_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"04","Data ate           ?","","","mv_ch4","D",08,0,0,"G","","mv_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"05","Tp.Aplicacao       ?","","","mv_ch5","C",01,0,0,"C","","mv_PAR05","Invest Plus","","","","","FICI DI Federal","","","","","","","","","","","","","","","","","","","","",""})

AjustaSX1(_aPerg)

If !Pergunte(cPerg, .T.)
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a fun‡„o SETPRINT 							  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "CFINR018"            //Nome Default do relatorio em Disco
WnRel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,Tamanho,"")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao REPORTINI substituir as variaveis.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| AplFin(@lEnd,wnRel,cString)},titulo)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ AplFin ³   Autor  ³ Andy Pudja           ³ Data ³ 20.10.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Aplicacao Financeira  									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AplFin(lEnd,wnRel,cString)
LOCAL CbCont,CbTxt
LOCAL tamanho:="M"
LOCAL _cBanco,_cNomeBanco,_cAgencia,_cConta,nRec,cLimCred
LOCAL limite := 132
LOCAL nSaldoAtu:=0,nTipo,nEntradas:=0,nSaidas:=0,nSaldoIni:=0
LOCAL cDOC
LOCAL cFil	  :=""
LOCAL nOrdSE5 :=SE5->(IndexOrd())
LOCAL cChave
LOCAL cIndex
LOCAL aRecon := {}
Local nTxMoeda := 1
Local nValor := 0
Local aStru 	:= SE5->(dbStruct()), ni
Local nMoeda	:= GetMv("MV_CENT")
Local nMoedaBco:=	1
LOCAL nSalIniStr := 0
LOCAL nSalIniCip := 0
LOCAL nSalIniComp := 0
LOCAL nSalStr := 0
LOCAL nSalCip := 0
LOCAL nSalComp := 0
LOCAL lSpbInUse := SpbInUse()
LOCAL aStruct := {}
Local cFilterUser


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis privadas exclusivas deste programa                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cCondWhile, lAllFil :=.F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt 	:= SPACE(10)
cbcont	:= 0
li 		:= 80
m_pag 	:= 1

If !Empty(mv_par01)
	dbSelectArea("SA6")
	dbSetOrder(5)
    	
	If !dbSeek(xFilial("SA6")+mv_par01)
		Help(" ",1,"BCONAOEXIST")
		Return
	EndIf
	
	_cBanco		:= A6_COD
	_cNomeBanco	:= A6_NREDUZ
	_cAgencia	:= A6_AGENCIA
	_cConta		:= A6_NUMCON
	
	dbSelectArea("SZG")
	dbSetOrder(1)
	dbSeek(xFilial("SZG")+_cBanco+_cAgencia+_cConta+DTOS(MV_PAR03), .T.)
	If Eof()
		Set Device To Screen
		If aReturn[5] = 1
			Set Printer To
			dbCommit()
			ourspool(wnrel)
		Endif
		
		MS_FLUSH()
		MsgStop("Não há registros para este intervalo de Datas!")
		
		Return
	Else
		If SZG->ZG_CONTA > mv_par02

			Set Device To Screen
			If aReturn[5] = 1
				Set Printer To
				dbCommit()
				ourspool(wnrel)
			Endif
			
			MS_FLUSH()
			MsgStop("Não há registros para este intervalo de Contas!")

			Return
		EndIf
	EndIf
Else
	dbSelectArea("SZG")
	dbGoTop()
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Defini‡„o dos cabe‡alhos								     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cTipoApl	:= ""
If mv_par05 = 1
	_cTipo      := "1"  // Demonstrativo
	_cTipoApl	:= "Invest Plus"
Else 
	_cTipo      := "2"  // Demonstrativo
	_cTipoApl	:= "FICI DI Federal"
EndIf

titulo := OemToAnsi("Aplicação Financeira de ")+DTOC(mv_par03)+OemToAnsi(" Até ")+DTOC(mv_par04)+" - "+_cTipoApl

//         01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//         BBBBBBBBBBBBBBB CCCCCCCCCCC
//         00        10                  30                  50                  70                  90                  110
//         00        12345678901234      12345678901234      12345678901234      12345678901234      12345678901234            12345678
//cabec1 := OemToAnsi("BANCO ")+ _cBanco +" - " + ALLTRIM(_cNomeBanco) + OemToAnsi("   AGENCIA ")+ _cAgencia + OemToAnsi("   CONTA ")+ _cConta
cabec2 := "Data      Saldo Inicial     Saldo Final         Resgate       Aplicacao     Rend. Bruto         IOF   Rend. Liquido    Remuneracao(%)"
//nTipo  :=IIF(aReturn[4]==1,15,18)
nTipo  :=18

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// Define a estrutura do arquivo de trabalho.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿

	_nTotRES:=0
	_nTotAPL:=0
	_nTotREC:=0
	_nTotRECLQ:=0
	_nTotIOF:=0
	_nTotREM:=0  

_nTotalS:=0
_nTotalL:=0
_nTotalC:=0
_nTotalD:=0
_nTotalE:=0
_nTotalM:=0

_nTotA := 0

SetRegua(SZG->(RecCount()))

dbSelectArea("SZG")
While !Eof() .And. SZG->ZG_CONTA >= MV_PAR01 .AND. SZG->ZG_CONTA <= mv_par02

	If SZG->ZG_XTIPO <> alltrim(str(mv_par05))
		dbSelectArea("SZG")
		dbSkip()
		Loop
	EndIf
	
	dbSelectArea("SA6")
	dbSetOrder(5)
	If !dbSeek(xFilial("SA6")+SZG->ZG_CONTA)
		Help(" ",1,"BCONAOEXIST")
		Return
	Else
		_cBanco		:= SA6->A6_COD
		_cNomeBanco	:= SA6->A6_NREDUZ
		_cAgencia	:= SA6->A6_AGENCIA
		_cNumConta	:= SA6->A6_NUMCON
	EndIf
	
	dbSelectArea("SZG")
	
	cabec1 := OemToAnsi("BANCO ")+ _cBanco +" - " + ALLTRIM(_cNomeBanco) + OemToAnsi("   AGENCIA ")+ _cAgencia + OemToAnsi("   CONTA ")+ _cNumConta
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	
	_cConta	:= SZG->ZG_CONTA
	
	While !Eof() .And. SZG->ZG_CONTA <= mv_par02 .And. _cConta	== SZG->ZG_CONTA
		
		If SZG->ZG_XTIPO <> alltrim(str(mv_par05))
			dbSelectArea("SZG")
			dbSkip()
			Loop
		EndIf


		If SZG->ZG_EMISSAO < mv_par03 .Or. SZG->ZG_EMISSAO > mv_par04
			dbSelectArea("SZG")
			dbSkip()
			Loop
		EndIf
		
		IncRegua()
		
		If li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
			li:=9
		Endif
		_nAplicacao := 0      
//                   1         2         3         4         5         6         7         8         9         0         1         2         3
//         01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//        "Data      Saldo Inicial     Saldo Final         Resgate       Aplicacao     Rend. Bruto         IOF   Rend. Liquido    Remuneracao(%)"
//		   99/99/99 999,999,999.99  999,999,999.99  999,999,999.99  999,999,999.99  999,999,999.99  999,999.99  999,999,999.99          99.99999
		@li,000 PSAY SZG->ZG_EMISSAO
		@li,009 PSAY SZG->ZG_VALINI   Picture "@E 999,999,999.99"
		@li,025 PSAY SZG->ZG_VALFIN   Picture "@E 999,999,999.99"
		@li,041 PSAY SZG->ZG_VALRES   Picture "@E 999,999,999.99"
		@li,057 PSAY SZG->ZG_VALAPL   Picture "@E 999,999,999.99"
		@li,073 PSAY SZG->ZG_VALREC   Picture "@E 999,999,999.99"                    
		@li,089 PSAY SZG->ZG_IOF      Picture "@E 999,999.99"                    
		@li,101 PSAY (SZG->ZG_VALREC-SZG->ZG_IOF)   Picture "@E 999,999,999.99"                    

		_dData 	:= SZG->ZG_EMISSAO // Demonstrativo
		_nTotA 	:= SZG->ZG_VALFIN  // Demonstrativo
		
		_nREMUNE:=(SZG->ZG_VALREC/(SZG->ZG_VALINI-SZG->ZG_VALRES+SZG->ZG_VALAPL))*100
		
		@li,125 PSAY _nREMUNE         Picture "@E 99.99999"

		li:=li+1
		_nTotRES:=_nTotRES+SZG->ZG_VALRES
		_nTotAPL:=_nTotAPL+SZG->ZG_VALAPL
		_nTotREC:=_nTotREC+SZG->ZG_VALREC
		_nTotIOF:=_nTotIOF+SZG->ZG_IOF
		_nTotRECLQ:=_nTotRECLQ+(SZG->ZG_VALREC-SZG->ZG_IOF)
		_nTotREM:=_nTotREM+_nREMUNE		
		
		_nTotalS:=_nTotalS+SZG->ZG_VALRES
		_nTotalL:=_nTotalL+SZG->ZG_VALAPL
		_nTotalC:=_nTotalC+SZG->ZG_VALREC
		_nTotalE:=_nTotalE+SZG->ZG_IOF
		_nTotalD:=_nTotalD+(SZG->ZG_VALREC-SZG->ZG_IOF)
		_nTotalM:=_nTotalM+_nREMUNE
				
		dbSelectArea("SZG")
		dbSkip()
		
	EndDo
	
	If li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		li:=9
	Endif
	
	li:=li+1

	@li,041 PSAY _nTotRES   Picture "@E 999,999,999.99"
	@li,057 PSAY _nTotAPL   Picture "@E 999,999,999.99"
	@li,073 PSAY _nTotREC   Picture "@E 999,999,999.99"    
	@li,089 PSAY _nTotIOF   Picture "@E 999,999.99"    
	@li,101 PSAY _nTotRECLQ Picture "@E 999,999,999.99"    
    @li,125 PSAY _nTotREM   Picture "@E 99.99999"
	
	_nTotRES:=0
	_nTotAPL:=0
	_nTotREC:=0
	_nTotRECLQ:=0
	_nTotIOF:=0
	_nTotREM:=0       
	
	If _nTotA <> 0
		Grava_Fluxo(_cBanco, _cAgencia, _cNumConta, _cTipo, _dData, _nTotA) // Demonstrativo
	EndIf
	
EndDo

If mv_par01 <> mv_par02
	cabec1 := OemToAnsi("Total dos Bancos ")
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	li:=9
	@li,041 PSAY _nTotalS   Picture "@E 999,999,999.99"
	@li,057 PSAY _nTotalL   Picture "@E 999,999,999.99"
	@li,073 PSAY _nTotalC   Picture "@E 999,999,999.99"
	@li,089 PSAY _nTotalE   Picture "@E 999,999.99"
	@li,101 PSAY _nTotalD   Picture "@E 999,999,999.99"
	@li,125 PSAY _nTotalM   Picture "@E 99.99999"
EndIf

If li != 80
	roda(cbcont,cbtxt,Tamanho)
EndIf

Set Device To Screen


If aReturn[5] = 1
	Set Printer To
	dbCommit()
	ourspool(wnrel)
Endif

MS_FLUSH()
Return

                                             

STATIC FUNCTION Grava_Fluxo(_cBanco, _cAgencia, _cNumConta, _cTipo, _dData, _nTotA)   

dbSelectArea("PAH")
dbSetOrder(1)  

_nTam:=40-Len("CFINR018")
_cChave:="CFINR018"+Space(_nTam)+DTOS(_dData)+_cBanco+_cAgencia+_cNumConta+_cTipo                                

If !(dbSeek(xFilial("PAH")+_cChave))
	RecLock("PAH", .T.)
		PAH->PAH_FILIAL := xFilial("PAH")            
		PAH->PAH_ORIGEM := "CFINR018"
        PAH->PAH_DATA   := _dData    
        PAH->PAH_BANCO	:= _cBanco
        PAH->PAH_AGENCI	:= _cAgencia
        PAH->PAH_CONTA	:= _cNumConta
        PAH->PAH_TIPO	:= _cTipo
		PAH->PAH_VALOR  := _nTotA
	msUnLock()
Else
	RecLock("PAH", .F.)
		PAH->PAH_VALOR  := _nTotA
	msUnLock()
EndIf

Return
