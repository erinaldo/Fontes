#INCLUDE "rwmake.ch"
#Include "TopConn.ch"
//#include "_FixSX.ch"
#INCLUDE "DelAlias.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CFINR012 º Autor ³ Andy               º Data ³  16/01/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Impressao de Lotes Contabeis - CNI                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Relatorio Especifico CIEE / Depto Financeiro               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CFINR012()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cDesc1 := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2 := "sobre Lotes Contabeis - CNI"
Private cDesc3 := "de acordo com os parametros informados pelo usuario."

Private titulo := "*** Relatorio Lotes Contabeis ***"
Private nLin   := 90

Private Cabec1 := ""
Private Cabec2 := ""
Private imprime      := .T.
Private aOrd         := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := StrTran(FunName(), "#", "")
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FINR12" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString      := "SZD"
Private cPerg        := "FINR12"
Private mvFicha
Private _aAliases    := {}
Private _aEstrut     := {}
Private _aTitulos    := {}
Private aLanCab     := {}   // Array para o Cabecalho Contabil
Private aLanItens   := {}   // Array para os itens Contabeis

aAdd(_aTitulos,"Bolsa Auxilio")
aAdd(_aTitulos,"Contribuicao Institucional")
aAdd(_aTitulos,"Diferenças")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01 - Ficha de Lancamento                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
_aPerg := {}

AADD(_aPerg,{cPerg,"01","Data de Fechamento ?","","","mv_ch1","D",08,0,0,"G","","mv_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"02","RDR                ?","","","mv_ch2","C",15,0,0,"G","","mv_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"03","Conta Corrente De  ?","","","mv_ch3","C",10,0,0,"G","","mv_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"04","Conta Corrente Ate ?","","","mv_ch4","C",10,0,0,"G","","mv_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"05","Emissao De         ?","","","mv_ch5","D",08,0,0,"G","","mv_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"06","Emissao Ate        ?","","","mv_ch6","D",08,0,0,"G","","mv_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"07","Fechamento         ?","","","mv_ch7","N",01,0,0,"C","","mv_PAR07","Sim","","","","","Nao","","","","","Estornar","","","","","","","","","","","","","","","",""})
AjustaSX1(_aPerg)
*/
If !Pergunte(cPerg, .T.)
	Return
EndIf



IF ALLTRIM(CTPTPSLD(ALLTRIM(MV_PAR02))) == "1" .AND. MV_PAR07 == 3
   MsgInfo("Nao e permitido estonar os lancamentos contabeis ja efetivados!!!","Avise a Contabilidade!!!")
   Return
ENDIF    


wnrel := SetPrint(cString,"CFINR012",cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

dbSelectArea("SZD")
DbSetOrder(1)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo  := If(aReturn[4]==1,15,18)
titulo := "Relatorio de Lotes Contabeis"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus({|| ConCni(Cabec1,Cabec2,Titulo,nLin) },Titulo)


SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
EndIf

MS_FLUSH()


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³   ConCni º Autor ³ AP6 IDE            º Data ³  06/05/03   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ConCni(Cabec1,Cabec2,Titulo,nLin)
_aAliases := {}
_aEstrut  := {}
_aEstrut  := {;
{"TM_CCONTA"   ,  "C", 10, 0},;
{"TM_CR"       ,  "C", 03, 0},;
{"TM_DESC"     ,  "C", 25, 0},;
{"TM_LANC"     ,  "N", 09, 0},;
{"TM_VALDEB"   ,  "N", 17, 2},;
{"TM_LC"       ,  "C", 1, 0},;
{"TM_VALCRE"   ,  "N", 17, 2}}

// Cria o arquivo de trabalho.
_cArqTrab := CriaTrab(_aEstrut, .T.)
dbUseArea(.T., "DBFCDX", _cArqTrab, "TMQ", .F., .F.)
// Cria o indice para o arquivo.
IndRegua("TMQ", _cArqTrab, "TM_CCONTA+TM_CR",,, "Criando indice...", .T.)
aAdd (_aAliases, {"TMQ", _cArqTrab + ".DBF", _cArqTrab + OrdBagExt(), .T.})


// Define a estrutura do arquivo de trabalho.
_aEstrut := {}
_aEstrut := {;
{"TM_DC"       ,  "C", 01, 0},;
{"TM_CCONTA"   ,  "C", 10, 0},;
{"TM_EMISSAO"  ,  "D", 08, 0},;
{"TM_CR"       ,  "C", 03, 0},;
{"TM_VALOR"    ,  "N", 17, 2},;
{"TM_REGISTR"    ,"C", 15, 0},;
{"TM_REGPAR"    ,"C", 15, 0},;
{"TM_LC"    ,"C", 1, 0}}


// Cria o arquivo de trabalho.
_cArqTrab := CriaTrab(_aEstrut, .T.)
dbUseArea(.T., "DBFCDX", _cArqTrab, "TM1", .F., .F.)
// Cria o indice para o arquivo.
IndRegua("TM1", _cArqTrab, "TM_DC+TM_CCONTA+TM_CR+DTOS(TM_EMISSAO)+STR(TM_VALOR,17,2)",,, "Criando indice...", .T.)
aAdd (_aAliases, {"TM1", _cArqTrab + ".DBF", _cArqTrab + OrdBagExt(), .T.})


_xFilSZ8:=xFilial("SZ8")

_cOrdem := " Z8_FILIAL+Z8_CONTA"
_cQuery := " SELECT Z8_FILIAL, Z8_BANCO, Z8_AGENCIA, Z8_CONTA, Z8_EMISSAO, Z8_VALOR, Z8_CCONT, Z8_RDR, Z8_REGISTR, SZ8.R_E_C_N_O_ AS REGSZ8, Z8_LC"
_cQuery += " FROM "
_cQuery += RetSqlName("SZ8")+" SZ8"
_cQuery += " WHERE '"+ _xFilSZ8 +"' = Z8_FILIAL"
_cQuery += " AND    Z8_RDR         = '"+     mv_par02 +"'"
_cQuery += " AND    Z8_CCONT      >= '"+     mv_par03 +"'"
_cQuery += " AND    Z8_CCONT      <= '"+     mv_par04 +"'"
_cQuery += " AND    Z8_EMISSAO    >= '"+DTOS(mv_par05)+"'"
_cQuery += " AND    Z8_EMISSAO    <= '"+DTOS(mv_par06)+"'"

U_EndQuery( @_cQuery,_cOrdem, "QUERY", {"SZ8"},,,.T. )


dbSelectArea("QUERY")
dbGoTop()
Do While !Eof()
	dbSelectArea("TM1")
	RecLock("TM1", .T.)
	TM1->TM_DC       := "D"
	TM1->TM_CCONTA   := QUERY->Z8_CCONT
	TM1->TM_EMISSAO  := QUERY->Z8_EMISSAO
	TM1->TM_VALOR    := QUERY->Z8_VALOR
	TM1->TM_REGISTR  := StrZero(QUERY->REGSZ8,15)
	TM1->TM_REGPAR   := StrZero(QUERY->REGSZ8,15)
	TM1->TM_LC       := QUERY->Z8_LC
	msUnLock()
	
	SZF->(dbSetOrder(1))
	SZF->(dbSeek(xFilial("SZF") + QUERY->Z8_BANCO+QUERY->Z8_AGENCIA+QUERY->Z8_CONTA+DTOS(QUERY->Z8_EMISSAO)+QUERY->Z8_REGISTR, .F.))//+StrZero(QUERY->REGSZ8,15), .F.))
	
	Do While SZF->(ZF_FILIAL+ZF_BANCO+ZF_AGENCIA+ZF_CONTA+DTOS(ZF_EMISSAO)+ZF_REGISTR) ==  _xFilSZ8+QUERY->Z8_BANCO+QUERY->Z8_AGENCIA+QUERY->Z8_CONTA+DTOS(QUERY->Z8_EMISSAO)+QUERY->Z8_REGISTR //+StrZero(QUERY->REGSZ8,15)
		
		If SZF->ZF_RDR <> QUERY->Z8_RDR
			dbSelectArea("SZF")
			dbSkip()
			Loop
		EndIf
		RecLock("TM1", .T.)
		TM1->TM_DC       := SZF->ZF_DC
		TM1->TM_CCONTA   := SZF->ZF_CCONTA
		TM1->TM_EMISSAO  := SZF->ZF_EMISSAO
		TM1->TM_CR       := SZF->ZF_CR
		TM1->TM_VALOR    := SZF->ZF_VALOR
		TM1->TM_REGISTR  := StrZero(QUERY->REGSZ8,15)
		TM1->TM_REGPAR   := StrZero(QUERY->REGSZ8,15)
		TM1->TM_LC       := QUERY->Z8_LC
		msUnLock()
		SZF->(dbSkip())
	EndDo
	
	dbSelectArea("QUERY")
	dbSkip()
EndDo
dbSelectArea("TM1")
COPY TO "SZ8TMP.XLS"
U_IMP_TMP()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o   ³ Imp_TMP ³ Autor ³    Andy                 ³ Data ³16/01/04  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³CIEE                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION IMP_TMP()


Private _cString := "CT2"
Private _aCt2Mov :={}
Private _cLoteCie := ALLTRIM(GETMV("CI_LOTERDR"))  // Lote Determinado pelo usuario no parametro
Private _cSubLCie := "001"
Private _cDocCie  := "000001"
Private _cLinCie  := 0
Private _lVer := .T.
Private _cLC
Private _cFlg := .F.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ imprimindo TMP                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Cabec1:="Data Movimento - " + DTOC(mv_par01) + "   -   R.D.R. - "+ mv_par02



//Cabec2:="Data       Cod. Hist.              Valor Debito       Valor Credito"
//        "--------   ----------        ------------------  ------------------"
//                                      999,999,999,999.99  999,999,999,999.99
//        "123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//         01_DATA,          19_760     30_DEBITO           50_CREDITO

nLin:=90

dbSelectArea("TM1")
dbGoTop()
While !EOF()
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 75 // Salto de Página. Neste caso o formulario tem 50 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 08
	Endif
	
	If !Empty(TM1->TM_CCONTA)
		
		CT1->(dbSetOrder(2))
		
		If Left(AllTrim(TM1->TM_CCONTA),1) $ "1;2"
			CT1->(dbSeek(xFilial("CT1")+SUBS(TM1->TM_CCONTA,1,5)))
			@ nLin, 01   PSay "Conta Contabil: "+AllTrim(TM1->TM_CCONTA)+" - "+AllTrim(CT1->CT1_DESC01)
		Else
			CT1->(dbSeek(xFilial("CT1")+SUBS(TM1->TM_CCONTA,1,5)))
			CTT->(dbSeek(xFilial("CTT")+TM1->TM_CR, .F.))
			@ nLin, 01   PSay "Conta Contabil: "+AllTrim(TM1->TM_CCONTA)+" - "+AllTrim(CT1->CT1_DESC01)
			nLin:=nLin+1
			@ nLin, 01   PSay "            CR: "+AllTrim(TM1->TM_CR)+"   - "+AllTrim(CTT->CTT_DESC01)
		EndIf
		
		nLin:=nLin+2
		@ nLin, 01   PSay "Data       Cod. Hist.              Valor Debito       Valor Credito"
		nLin:=nLin+1
		@ nLin, 01   PSay "--------   ----------        ------------------  ------------------"
		nLin:=nLin+2
	Else
		@ nLin, 01   PSay "Conta Contabil: " + Replicate("*", 10) + " - "
		nLin:=nLin+2
		@ nLin, 01   PSay "Data       Cod. Hist.              Valor Debito       Valor Credito"
		nLin:=nLin+1
		@ nLin, 01   PSay "--------   ----------        ------------------  ------------------"
		nLin:=nLin+2
	EndIf
	//	    DBSELECTAREA("CT1")
	CT1->(dbSetOrder(2))
	CT1->(DBGOTOP())
	CT1->(dbSeek(xFilial("CT1")+SUBS(TM1->TM_CCONTA,1,5)))
	_cCConta := TM1->TM_CCONTA
	_cCR     := TM1->TM_CR
	_cDESC   := Left(AllTrim(CT1->CT1_DESC01),25)
	_nTotDeb := 0
	_nTotCre := 0
	_nLanc   := 0
	
	While !EOF() .And. 	_cCConta == TM1->TM_CCONTA .AND.  TM1->TM_CR ==	_cCR     
		If nLin > 75 // Salto de Página. Neste caso o formulario tem 50 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 08
		Endif
		
		@ nLin, 01   PSay TM1->TM_EMISSAO
		@ nLin, 19   PSay "760"
		If TM1->TM_DC == "D"
			@ nLin, 30   PSay TM1->TM_VALOR Picture "@E 999,999,999,999.99"
			@ nLin, 50   PSay 0.00          Picture "@E 999,999,999,999.99"
			_nTotDeb += TM1->TM_VALOR
		Else
			@ nLin, 30   PSay 0.00          Picture "@E 999,999,999,999.99"
			@ nLin, 50   PSay TM1->TM_VALOR Picture "@E 999,999,999,999.99"
			_nTotCre += TM1->TM_VALOR
		EndIf
		
		nLin  :=nLin+1
		_nLanc+=1
		
		If mv_par07 == 1
			If!Empty(TM1->TM_REGISTR)
				dbSelectArea("SZ8")
				dbGoto(Val(TM1->TM_REGISTR))
				RecLock("SZ8", .F.)
				If Empty(SZ8->Z8_FECRAT)
					SZ8->Z8_FECRAT := mv_par01
					SZ8->Z8_LC     := "S"
				EndIf
				msUnLock()
			EndIf
		Endif
		If MV_PAR07 == 3
			If AllTrim(SubStr(cUsuario,7,11)) $ "Siga/Cristiano/Luis Carlos/Adilson"
				dbSelectArea("SZ8")
				dbGoto(Val(TM1->TM_REGPAR))
				RecLock("SZ8", .F.)
				SZ8->Z8_FECRAT := ctod("  /  /  ")
				SZ8->Z8_LC     := " "
				msUnLock()
			   
		        
		  //     	RecLock("TM1", .F.)              
		        //TM1->TM_LC  := ""
		//	    TM1->(MsUnlock())

			EndIf
		EndIf
		
		dbSelectArea("TM1")
		_cLC := TM1->TM_LC
		
		TM1->(dbSkip())
		
	EndDo
	
	If nLin > 75 // Salto de Página. Neste caso o formulario tem 50 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 08
	Endif
	
	@ nLin, 30   PSay Replicate("-", 18)
	@ nLin, 50   PSay Replicate("-", 18)
	
	nLin:=nLin+1
	
	If nLin > 75 // Salto de Página. Neste caso o formulario tem 50 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 08
	Endif
	@ nLin, 30   PSay _nTotDeb Picture "@E 999,999,999,999.99"
	@ nLin, 50   PSay _nTotCre Picture "@E 999,999,999,999.99"
	
	nLin:=nLin+3
	
	If nLin > 75 // Salto de Página. Neste caso o formulario tem 50 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 08
	Endif
	
	dbSelectArea("TMQ")
	if !dbSeek(_cCConta+_cCR)
		RecLock("TMQ", .T.)
		TMQ->TM_CCONTA   := _cCConta
		TMQ->TM_CR       := _cCR
		TMQ->TM_DESC     := _cDesc
		TMQ->TM_LANC     := _nLanc
		TMQ->TM_VALDEB   := _nTotDeb
		TMQ->TM_VALCRE   := _nTotCre
		TMQ->TM_LC       := _cLC
		msUnLock()
	Else
		RecLock("TMQ", .F.)
		TMQ->TM_VALDEB   += _nTotDeb
		TMQ->TM_VALCRE   += _nTotCre
		TMQ->TM_LC       := _cLC
		msUnLock()
	EndIf
	
	dbSelectArea("TM1")
	
	
EndDo


dbSelectArea("TMQ")
dbGoTop()

Cabec1:="Data Movimento - " + DTOC(mv_par01) + "   -   R.D.R. - "+AllTrim(mv_par02)+"  -  Sintetico"

//        "Conta    CR    Descricao Conta           Lcto     Valor Debito    Valor Credito"
//                                                  9999 9,999,999,999.99 9,999,999,999.99
//        "123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//         CCCCCCCCCC CCC DDDDDDDDDDDDDDDDDDDDDDDDD 999999999 999999999999999999 999999999999999999
//        "-------- ---   ------------------------- ---- ---------------- ----------------"
//         01       10    16                        42   47               64

Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)

nLin:= 10
@ nLin, 01   PSay "Conta     CR    Descricao Conta           Lcto     Valor Debito    Valor Credito"
nLin:=nLin+1
@ nLin, 01   PSay "--------  ---   ------------------------- ---- ---------------- ----------------"

nLin:=nLin+1

dbSelectArea("TMQ")
dbGoTop()

_nLANC    := 0
_nVALDEB  := 0
_nVALCRE  := 0
_nDevedora:= 0
_nCredora := 0


While !EOF()
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 75 // Salto de Página. Neste caso o formulario tem 50 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 08
	Endif
	

	_cCR := TMQ->TM_CR 
	_cCConta := TMQ->TM_CCONTA
	
	While  TMQ->TM_CCONTA == _cCConta .AND.  TMQ->TM_CR == _cCR
	
	@ nLin, 01   PSay If(Empty(TMQ->TM_CCONTA),Replicate("*", 10),TMQ->TM_CCONTA)
	@ nLin, 10   PSay TMQ->TM_CR
	@ nLin, 16   Psay TMQ->TM_DESC
	@ nLin, 42   PSay TMQ->TM_LANC	 Picture "@E 9999"
	@ nLin, 47   PSay TMQ->TM_VALDEB Picture "@E 9,999,999,999.99"
	@ nLin, 64   PSay TMQ->TM_VALCRE Picture "@E 9,999,999,999.99"
	
	If !Empty(TMQ->TM_CCONTA) .And. TMQ->TM_VALDEB<>0
		If !Empty(TMQ->TM_CR)
			_nDevedora:=_nDevedora+Val(AllTrim(TMQ->TM_CCONTA)+AllTrim(TMQ->TM_CR))
		Else
			_nDevedora:=_nDevedora+Val(AllTrim(TMQ->TM_CCONTA))
		EndIf
	EndIf
	If !Empty(TMQ->TM_CCONTA) .And. TMQ->TM_VALCRE<>0
		If !Empty(TMQ->TM_CR)
			_nCredora :=_nCredora+Val(AllTrim(TMQ->TM_CCONTA)+AllTrim(TMQ->TM_CR))
		Else
			_nCredora :=_nCredora+Val(AllTrim(TMQ->TM_CCONTA))
		EndIf
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Gera Pre-Lancamentos contabeis se o parametro MV_PAR07, for para fechamento financeiro. CFB 19/05/05 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	
	IF TMQ->TM_LC ==  "S" .AND. _lVer == .T. .AND. MV_PAR07 == 1
		MSGINFO("Movimento ja Contabilizado!!!")
		_lVer := .F.
	ENDIF
	
	
	IF MV_PAR07 == 1 .AND. TMQ->TM_LC <> "S" // (1=Sim , 2 = Nao, 3 = Estorno)

        _cFlg := .T. // Contabiliza
        //  Cabeçalho da Capa de Lote
		_cLinCie++
		AADD(aLanCab,{ MV_PAR01,_cLoteCie,"001" })     // Data do Movimento Contabil
		DBSELECTAREA("CT1")
		CT1->(DBSETORDER(2))
		CT1->(DBSEEK(xFilial("CT1")+SUBS(TMQ->TM_CCONTA,1,6)))
        // Movimentos do Lançamento Padrão

		AADD(aLanItens,{StrZero(_cLinCie,3),;
		                IIF(!Empty(TMQ->TM_VALDEB),"1","2"),;
		                IIF(!Empty(TMQ->TM_VALDEB),CT1->CT1_CONTA,""),;
		                IIF(!Empty(TMQ->TM_VALCRE),CT1->CT1_CONTA,""),;
		                IIF(!Empty(TMQ->TM_VALCRE),TMQ->TM_VALCRE, TMQ->TM_VALDEB),;
		                ALLTRIM(MV_PAR02)+SPACE(2)+Dtoc(MV_PAR01),;
		                TMQ->TM_CR,;            
		                IIF(!Empty(TMQ->TM_VALDEB),ALLTRIM(TMQ->TM_CCONTA),""),;
		                IIF(!Empty(TMQ->TM_VALCRE),ALLTRIM(TMQ->TM_CCONTA),""),;
		                "760 "+ALLTRIM(MV_PAR02)})

	ENDIF
	
	
	// Gera Lançamento para exclusao     
	IF MV_PAR07 == 3  .AND. TMQ->TM_LC == "S" // (1=Sim , 2 = Nao, 3 = Estorno)
       _cFlg := .T.

        //  Cabeçalho da Capa de Lote
		_cLinCie++
		AADD(aLanCab,{ MV_PAR01,_cLoteCie,"001" })     // Data do Movimento Contabil
		DBSELECTAREA("CT1")
		CT1->(DBSETORDER(2))
		CT1->(DBSEEK(xFilial("CT1")+SUBS(TMQ->TM_CCONTA,1,6)))
        // Movimentos do Lançamento Padrão

		AADD(aLanItens,{StrZero(_cLinCie,3),;
		                IIF(!Empty(TMQ->TM_VALDEB),"1","2"),;
		                IIF(!Empty(TMQ->TM_VALDEB),CT1->CT1_CONTA,""),;
		                IIF(!Empty(TMQ->TM_VALCRE),CT1->CT1_CONTA,""),;
		                IIF(!Empty(TMQ->TM_VALCRE),TMQ->TM_VALCRE, TMQ->TM_VALDEB),;
		                ALLTRIM(MV_PAR02)+SPACE(2)+Dtoc(MV_PAR01),;
		                TMQ->TM_CR,;            
		                IIF(!Empty(TMQ->TM_VALDEB),ALLTRIM(TMQ->TM_CCONTA),""),;
		                IIF(!Empty(TMQ->TM_VALCRE),ALLTRIM(TMQ->TM_CCONTA),""),;
		                "760 "+ALLTRIM(MV_PAR02)})

	ENDIF
	
	
	
	_nLANC   += TMQ->TM_LANC
	_nVALDEB += TMQ->TM_VALDEB
	_nVALCRE += TMQ->TM_VALCRE
	
	nLin:=nLin+1
	
	dbSelectArea("TMQ")
	dbSkip()
	
	End
	
	
EndDo

@ nLin, 01   PSay "                                          ---- ---------------- ----------------"
nLin:=nLin+1
@ nLin, 43   PSay _nLANC   Picture "@E 9999"
@ nLin, 48   PSay _nVALDEB Picture "@E 9,999,999,999.99"
@ nLin, 65   PSay _nVALCRE Picture "@E 9,999,999,999.99"

nLin:=nLin+2
@ nLin, 01   PSay "Somatoria Contas Debitos  = "
@ nLin, 31   PSay _nDevedora Picture "@E 999,999,999,999"
nLin:=nLin+1
@ nLin, 01   PSay "Somatoria Contas Creditos = "
@ nLin, 31   PSay _nCredora  Picture "@E 999,999,999,999"


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("QUERY")
dbCloseArea()



IF MV_PAR07 == 1 .AND. _cFlg == .T.
    CaFinr012I(aLanCab,aLanItens)
ENDIF
IF MV_PAR07 == 3 .AND. _cFlg == .T.
    CaFinr012E(aLanCab,aLanItens)
ENDIF

  

FechaAlias(_aAliases)  // DelAlias..AND. _cFlg == .T.ch

Return


// Rotina de Inclusão dos lancamentos contabeis  (3)
Static Function CaFinr012I(aLanCab,aLanItens)

Local cOldArea 		:= Alias()
Local nDecs			:=	TamSX3('CT2_VALOR')[2]
Local nLote
Local nContraPart	:=	0
Local nX			:=	1
Local nBase			:=	1
Local nMaxLanc		:=	99
Local nContador		:=	Min(Len(aLanItens),nMaxLanc-1)
Local aAreaSI2		:=	CT2->(GetArea())

Local dDataLanc := CTOD("")
Local cLote     := space(6)
Local cSubLote  := space(3)
Local cCab  	:= {}
Local aItens 	:= {}


Local aCab			:= {}
Local aItem			:= {}
Local aTotItem 		:= {}
Local cSequencia
Local cHp	
Local cHist	
Private lMsErroAuto := .F.



aCab := {;
{"dDataLanc",     aLanCab[1][1] ,NIL},;
{"cLote"	, Padr(aLanCab[1][2] ,TamSx3("CT2_LOTE")[1]),NIL},;
{"cSubLote"	, Padr(aLanCab[1][3] ,TamSx3("CT2_SBLOTE")[1]),NIL}}


//{"dDataLanc",      aLanCab[1][1] ,NIL},;


//While nX <= Len(aLanItens)
	nContraPart	:=	0
	For nX	:= nBase To nContador
		/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³Fazer o lancamento de contrapartida ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		
		
AADD(aItem,{{"CT2_FILIAL"	,xFilial("CT2")					               , NIL},;
	    	{"CT2_LINHA"	,StrZero(nX+1-nBase,3)					       , NIL},;
	    	{"CT2_DC"		,aLanItens[nX][2]						       , NIL},;
		    {"CT2_MOEDLC"	,"01"              					           , NIL},;
    		{"CT2_DEBITO"	,IIf(aLanItens[nX][2]=='1',aLanItens[nX][3],""), NIL},;
	    	{"CT2_CREDIT"	,IIf(aLanItens[nX][2]=='2',aLanItens[nX][4],""), NIL},;
		 	{"CT2_DCD"		,CtbDigCont(IIf(aLanItens[nX][2]=='1',aLanItens[nX][3],""))		                	   , NIL},;
		 	{"CT2_DCC"		,CtbDigCont(IIf(aLanItens[nX][2]=='2',aLanItens[nX][4],""))				               , NIL},;
		    {"CT2_VALOR"	,Round(aLanItens[nX][5],nDecs)			       , NIL},;
    		{"CT2_ORIGEM"	,aLanItens[nX][10]						       , NIL},;		
			{"CT2_HP"		,""  			        				       , NIL},;
    	    {"CT2_CCD"	, IIf(aLanItens[nX][2]=='1', aLanItens[nX][7],"")  , NIL},;	    
        	{"CT2_CCC"	, IIf(aLanItens[nX][2]=='2', aLanItens[nX][7],"")  , NIL},;              					
			{"CT2_ITEMD"	,aLanItens[nX][8] 						       , NIL},;
			{"CT2_ITEMC"	,aLanItens[nX][9] 						       , NIL},;
			{"CT2_TPSALD"	,"9"            						       , NIL},;
			{"CT2_HIST"		,aLanItens[nX][6] 						       , NIL}})

//			{"CT2_ORIGEM"	,aLanItens[nX][10]						       , NIL},;		
//		nContraPart	+=	(Round(aLanItens[nX][5],nDecs) * Iif(aLanItens[nX][2]=='1',-1,1))
	Next
	
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³Asiento a debito    ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	If nContrapart # 0
		Aadd(aTotItem, {;
		{"CT2_LINHA"	,StrZero(nX+1-nBase,3)				 , NIL},;
		{"CT2_DC"		,IIf(nContrapart > 0,'1','2')		 , NIL},;
		{"CT2_DEBITO"	,IIf(nContrapart > 0,aLanItens[nX][3], Nil)	, NIL},;
		{"CT2_CREDIT"	,IIf(nContrapart < 0,aLanItens[nX][4], Nil)	, NIL},;
		{"CT2_VALOR"	,Abs(nContrapart)				     , NIL},;
		{"CT2_ORIGEM"	,aLanItens[nX][10]					 , NIL},;
		{"CT2_HP"		," "								 , NIL},;
		{"CT2_HIST"		,aLanItens[nX][6]					 , NIL}};
		)
	EndIf

    aadd(aTotItem,aItem)

//	IncProc("Gerando Lancamentos ") //"Gerando lancamento "
	MSExecAuto({|x,y,Z| Ctba102(x,y,Z)},aCab,aItem,3)
	aTotItem	:=	{}
	If lMsErroAuto
		DisarmTransaction()
		MostraErro()
		Return .F.
	Endif
	nBase		:=	nX
	nContador	:=	Min(Len(aLanItens),(nBase-1)+(nMaxLanc-1))
//Enddo

Return .T.



// Rotina de Exclusão dos lancamentos contabeis (5)

Static Function CaFinr012E(aLanCab,aLanItens)

Local cOldArea 		:= Alias()
Local nDecs			:=	TamSX3('CT2_VALOR')[2]
Local nLote
Local nContraPart	:=	0
Local nX			:=	1
Local nBase			:=	1
Local nMaxLanc		:=	99
Local nContador		:=	Min(Len(aLanItens),nMaxLanc-1)
Local aAreaSI2		:=	CT2->(GetArea())

Local dDataLanc := CTOD("")
Local cLote     := space(6)
Local cSubLote  := space(3)
Local cCab  	:= {}
Local aItens 	:= {}


Local aCab			:= {}
Local aItem			:= {}
Local aTotItem 		:= {}

Local cSequencia
Local cHp	
Local cHist	
Private lMsErroAuto := .F.



cDocRdr := CTPESRDR(Subs(aLanItens[1][10],5,6))

aCab := {;
{"CT2_DATA",     aLanCab[1][1] ,NIL},;
{"CT2_LOTE"	, Padr(aLanCab[1][2] ,TamSx3("CT2_LOTE")[1]),NIL},;
{"CT2_SBLOTE"	, Padr(aLanCab[1][3] ,TamSx3("CT2_SBLOTE")[1]),NIL},;
{"CT2_DOC"	, cDocRdr ,NIL}}


nContraPart	:=	0
	For nX	:= nBase To nContador
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//	³Fazer o lancamento de contrapartida ³
	//	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		


AADD(aItem,{{"CT2_FILIAL"	,xFilial("CT2")					               , NIL},;
	    	{"CT2_LINHA"	,StrZero(nX+1-nBase,3)					       , NIL},;
	    	{"CT2_DC"		,aLanItens[nX][2]						       , NIL},;
		    {"CT2_MOEDLC"	,"01"              					           , NIL},;
    		{"CT2_DEBITO"	,IIf(aLanItens[nX][2]=='1',aLanItens[nX][3],""), NIL},;
	    	{"CT2_CREDIT"	,IIf(aLanItens[nX][2]=='2',aLanItens[nX][4],""), NIL},;
		 	{"CT2_DCD"		,CtbDigCont(IIf(aLanItens[nX][2]=='1',aLanItens[nX][3],""))		                	   , NIL},;
		 	{"CT2_DCC"		,CtbDigCont(IIf(aLanItens[nX][2]=='2',aLanItens[nX][4],""))				               , NIL},;
		    {"CT2_VALOR"	,Round(aLanItens[nX][5],nDecs)			       , NIL},;
    		{"CT2_ORIGEM"	,aLanItens[nX][10]						       , NIL},;		
			{"CT2_HP"		,""  			        				       , NIL},;
    	    {"CT2_CCD"	, IIf(aLanItens[nX][2]=='1', aLanItens[nX][7],"")  , NIL},;	    
        	{"CT2_CCC"	, IIf(aLanItens[nX][2]=='2', aLanItens[nX][7],"")  , NIL},;              					
			{"CT2_ITEMD"	,aLanItens[nX][8] 						       , NIL},;
			{"CT2_ITEMC"	,aLanItens[nX][9] 						       , NIL},;
			{"CT2_TPSALD"	,"9"            						       , NIL},;
			{"CT2_HIST"		,aLanItens[nX][6] 						       , NIL}})

	Next
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Asiento a debito    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    
    aadd(aTotItem,aItem)
  
	MSExecAuto({|x,y,Z| Ctba102(x,y,Z)},aCab,aItem,5)
	aTotItem	:=	{}

If !lMsErroAuto
	ConOut("Exclusão com sucesso!")
Else
	ConOut("Erro na exclusão")
	DisarmTransaction()
	MostraErro()
	Return .F.
EndIf


nBase		:=	nX
nContador	:=	Min(Len(aLanItens),(nBase-1)+(nMaxLanc-1))


Return .T.


Static Function CTPESRDR(pDocRdr)



Local lRet := " "
Local _cQuery := " "
Local _cFl := CHR(13)+CHR(10)



_cQuery := " SELECT CT2_DOC  FROM " + RetSQLName("CT2") + "  "+_cFl
_cQuery += " WHERE D_E_L_E_T_ = ' '  "+_cFl
_cQuery += " AND SUBSTRING(CT2_ORIGEM,5,6) = '"+pDocRdr+"' "+_cFl
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'TRS',.T.,.T.)


lRet := TRS->CT2_DOC


If Select("TRS") > 0
	TRS->(DBCLOSEAREA())
EndIf


Return(lRet)


Static Function CTPTPSLD(pDocRdr)



Local lRet := " "
Local _cQuery := " "
Local _cFl := CHR(13)+CHR(10)



_cQuery := " SELECT CT2_TPSALD  FROM " + RetSQLName("CT2") + "  "+_cFl
_cQuery += " WHERE D_E_L_E_T_ = ' '  "+_cFl
_cQuery += " AND SUBSTRING(CT2_ORIGEM,5,6) = '"+pDocRdr+"' "+_cFl
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'TRS',.T.,.T.)


lRet := TRS->CT2_TPSALD


If Select("TRS") > 0
	TRS->(DBCLOSEAREA())
EndIf


Return(lRet)






