#INCLUDE "rwmake.ch"
#Include "TopConn.ch"
#INCLUDE "DelAlias.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CFINR012 บ Autor ณ Andy               บ Data ณ  16/01/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Impressao de Lotes Contabeis - CNI                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Relatorio Especifico CIEE / Depto Financeiro               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CFINR012()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

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
Private wnrel        := "FINR12" 
Private cString      := "SZD"
Private cPerg        := "FINR12    "
Private mvFicha
Private _aAliases    := {}
Private _aEstrut     := {}
Private _aTitulos    := {}
Private aLanCab     := {}   // Array para o Cabecalho Contabil
Private aLanItens   := {}   // Array para os itens Contabeis

aAdd(_aTitulos,"Bolsa Auxilio")
aAdd(_aTitulos,"Contribuicao Institucional")
aAdd(_aTitulos,"Diferen็as")

nSX1Order := SX1->(IndexOrd())
SX1->(dbSetOrder(1))
_aPerg := {}
AADD(_aPerg,{cPerg,"01","Data de Fechamento ?","","","mv_ch1","D",08,0,0,"G","","mv_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"02","RDR                ?","","","mv_ch2","C",15,0,0,"G","","mv_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"03","Conta Corrente De  ?","","","mv_ch3","C",10,0,0,"G","","mv_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"04","Conta Corrente Ate ?","","","mv_ch4","C",10,0,0,"G","","mv_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"05","Emissao De         ?","","","mv_ch5","D",08,0,0,"G","","mv_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"06","Emissao Ate        ?","","","mv_ch6","D",08,0,0,"G","","mv_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"07","Fechamento         ?","","","mv_ch7","N",01,0,0,"C","","mv_PAR07","Sim","","","","","Nao","","","","","Estornar","","","","","","","","","","","","","","","",""})

For nX := 1 to Len(_aPerg)
	If !SX1->(dbSeek(cPerg+_aPerg[nX,2]))
		RecLock('SX1',.T.)
		For nY:=1 to FCount()
			If nY <= Len(_aPerg[nX])
				SX1->(FieldPut(nY,_aPerg[nX,nY]))
			Endif
		Next nY
		MsUnlock()
	Endif
Next nX

SX1->(dbSetOrder(nSX1Order))

If !Pergunte(cPerg, .T.)
	Return
EndIf

IF ALLTRIM(CTPTPSLD(ALLTRIM(MV_PAR02))) == "1" .AND. MV_PAR07 == 3
	MsgInfo("Nao e permitido estonar os lancamentos contabeis ja efetivados!!!","Avise a Contabilidade!!!")
	Return
ENDIF

wnrel := SetPrint(cString,"CFINR012",cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

If MV_PAR07 == 3 //Estorno
//	If !AllTrim(SubStr(cUsuario,7,11)) $ ALLTRIM(GETMV("CI_USERLOT")) //"Siga/Cristiano/Luis Carlos/Adilson"
	If !AllTrim(cUserName) $ ALLTRIM(GETMV("CI_USERLOT")) //"Siga/Cristiano/Luis Carlos/Adilson"
		MsgInfo("Usuario sem permisao para estonar os lancamentos!!!","Atencao")
		Return
	EndIf
EndIf

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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RptStatus({|| ConCni(Cabec1,Cabec2,Titulo,nLin) },Titulo)

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
EndIf

MS_FLUSH()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ   ConCni บ Autor ณ AP6 IDE            บ Data ณ  06/05/03   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function ConCni(Cabec1,Cabec2,Titulo,nLin)
_aAliases := {}
_aEstrut  := {}
_aEstrut  := {;
{"TM_CCONTA"   ,  "C", 10, 0},;
{"TM_CR"       ,  "C", 05, 0},;
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
{"TM_CR"       ,  "C", 05, 0},;
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
	SZF->(dbSeek(xFilial("SZF") + QUERY->Z8_BANCO+QUERY->Z8_AGENCIA+QUERY->Z8_CONTA+DTOS(QUERY->Z8_EMISSAO)+QUERY->Z8_REGISTR, .F.))
	
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno   ณ Imp_TMP ณ Autor ณ    Andy                 ณ Data ณ16/01/04  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณCIEE                                                        ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ imprimindo TMP                                                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
	
	If nLin > 75 // Salto de Pแgina. Neste caso o formulario tem 50 linhas...
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
		If nLin > 75 // Salto de Pแgina. Neste caso o formulario tem 50 linhas...
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
		
		If STRZERO(MONTH(MV_PAR01),2)<>"01"
			If mv_par07 == 1 //SIM
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
			// Abaixo foi tirado o controle de usuarios e colocado no inicio do prg para nao permitir que o usuario faz Estorno
			// tiramos dia 25/07. Emerson Natali
				dbSelectArea("SZ8")
				dbGoto(Val(TM1->TM_REGPAR))
				RecLock("SZ8", .F.)
				SZ8->Z8_FECRAT := ctod("  /  /  ")
				SZ8->Z8_LC     := " "
				msUnLock()
			EndIf
		EndIf

		dbSelectArea("TM1")
		_cLC := TM1->TM_LC
		
		TM1->(dbSkip())
		
	EndDo
	
	If nLin > 75 // Salto de Pแgina. Neste caso o formulario tem 50 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 08
	Endif
	
	@ nLin, 30   PSay Replicate("-", 18)
	@ nLin, 50   PSay Replicate("-", 18)
	
	nLin:=nLin+1
	
	If nLin > 75 // Salto de Pแgina. Neste caso o formulario tem 50 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 08
	Endif
	@ nLin, 30   PSay _nTotDeb Picture "@E 999,999,999,999.99"
	@ nLin, 50   PSay _nTotCre Picture "@E 999,999,999,999.99"
	
	nLin:=nLin+3
	
	If nLin > 75 // Salto de Pแgina. Neste caso o formulario tem 50 linhas...
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
@ nLin, 01   PSay "Conta     CR      Descricao Conta           Lcto     Valor Debito    Valor Credito"
nLin:=nLin+1
@ nLin, 01   PSay "--------  -----   ------------------------- ---- ---------------- ----------------"

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
	
	If nLin > 75 // Salto de Pแgina. Neste caso o formulario tem 50 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 08
	Endif
	
	
	_cCR := TMQ->TM_CR
	_cCConta := TMQ->TM_CCONTA
	
	While  TMQ->TM_CCONTA == _cCConta .AND.  TMQ->TM_CR == _cCR
		
		@ nLin, 01   PSay If(Empty(TMQ->TM_CCONTA),Replicate("*", 10),TMQ->TM_CCONTA)
		@ nLin, 10   PSay TMQ->TM_CR
		@ nLin, 17   Psay TMQ->TM_DESC
		@ nLin, 43   PSay TMQ->TM_LANC	 Picture "@E 9999"
		@ nLin, 48   PSay TMQ->TM_VALDEB Picture "@E 9,999,999,999.99"
		@ nLin, 65   PSay TMQ->TM_VALCRE Picture "@E 9,999,999,999.99"
		
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
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณGera Pre-Lancamentos contabeis se o parametro MV_PAR07, for para fechamento financeiro. CFB 19/05/05 ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		
		IF TMQ->TM_LC ==  "S" .AND. _lVer == .T. .AND. MV_PAR07 == 1
			MSGINFO("Movimento ja Contabilizado!!!")
			_lVer := .F.
		ENDIF
		
		
		IF MV_PAR07 == 1 .AND. TMQ->TM_LC <> "S" // (1=Sim , 2 = Nao, 3 = Estorno)
			
			_cFlg := .T. // Contabiliza
			//  Cabe็alho da Capa de Lote
			_cLinCie++
			AADD(aLanCab,{ MV_PAR01,_cLoteCie,"001" })     // Data do Movimento Contabil
			DBSELECTAREA("CT1")
			CT1->(DBSETORDER(2))
			CT1->(DBSEEK(xFilial("CT1")+SUBS(TMQ->TM_CCONTA,1,6)))
			// Movimentos do Lan็amento Padrใo
			
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

		// Gera Lan็amento para exclusao
		IF MV_PAR07 == 3  .AND. TMQ->TM_LC == "S" // (1=Sim , 2 = Nao, 3 = Estorno)
			_cFlg := .T.

			//  Cabe็alho da Capa de Lote
			_cLinCie++
			AADD(aLanCab,{ MV_PAR01,_cLoteCie,"001" })     // Data do Movimento Contabil
			DBSELECTAREA("CT1")
			CT1->(DBSETORDER(2))
			CT1->(DBSEEK(xFilial("CT1")+SUBS(TMQ->TM_CCONTA,1,6)))
			// Movimentos do Lan็amento Padrใo
			
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

@ nLin, 01   PSay "                                            ---- ---------------- ----------------"
nLin:=nLin+1

@ nLin, 45   PSay _nLANC   Picture "@E 9999"
@ nLin, 50   PSay _nVALDEB Picture "@E 9,999,999,999.99"
@ nLin, 67   PSay _nVALCRE Picture "@E 9,999,999,999.99"

nLin:=nLin+2
@ nLin, 01   PSay "Somatoria Contas Debitos  = "
@ nLin, 31   PSay _nDevedora Picture "@E 999,999,999,999"

nLin:=nLin+1
@ nLin, 01   PSay "Somatoria Contas Creditos = "
@ nLin, 31   PSay _nCredora  Picture "@E 999,999,999,999"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

dbSelectArea("QUERY")
dbCloseArea()

FechaAlias(_aAliases)

If strzero(MONTH(MV_PAR01),2)== "01"
	AjustCont()
Else
	IF MV_PAR07 == 1 .AND. _cFlg == .T.
		CaFinr012I(aLanCab,aLanItens)
	ENDIF
	IF MV_PAR07 == 3 .AND. _cFlg == .T.
		CaFinr012E(aLanCab,aLanItens)
	ENDIF
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINR012  บAutor  ณMicrosiga           บ Data ณ  07/25/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

// Rotina de Inclusใo dos lancamentos contabeis  (3)
Static Function CaFinr012I(aLanCab,aLanItens)

Local cOldArea 		:= Alias()
Local nDecs			:=	TamSX3('CT2_VALOR')[2]
Local nLote
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

For nX	:= nBase To nContador
	
	AADD(aItem,{{"CT2_FILIAL"	,xFilial("CT2")					               , NIL},;
				{"CT2_LINHA"	,StrZero(nX+1-nBase,3)					       , NIL},;
				{"CT2_DC"		,aLanItens[nX][2]						       , NIL},;
				{"CT2_ITEMD"	,aLanItens[nX][8] 						       , NIL},;
				{"CT2_CCD"	, IIf(aLanItens[nX][2]=='1', aLanItens[nX][7],""), NIL},;
				{"CT2_ITEMC"	,aLanItens[nX][9] 						       , NIL},;
				{"CT2_CCC"	, IIf(aLanItens[nX][2]=='2', aLanItens[nX][7],""), NIL},;
				{"CT2_VALOR"	,Round(aLanItens[nX][5],nDecs)			       , NIL},;
				{"CT2_HP"		,""  			        				       , NIL},;				
				{"CT2_HIST"		,aLanItens[nX][6] 						       , NIL},;
				{"CT2_TPSALD"	,"9"            						       , NIL},;
				{"CT2_ORIGEM"	,aLanItens[nX][10]						       , NIL},;
				{"CT2_MOEDLC"	,"01"              					           , NIL}})

Next

aadd(aTotItem,aItem)

MSExecAuto({|x,y,Z| Ctba102(x,y,Z)},aCab,aItem,3)

aTotItem	:=	{}

If lMsErroAuto
	DisarmTransaction()
	MostraErro()
	Return .F.
Endif
nBase		:=	nX
nContador	:=	Min(Len(aLanItens),(nBase-1)+(nMaxLanc-1))

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINR012  บAutor  ณMicrosiga           บ Data ณ  06/27/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de Exclusใo dos lancamentos contabeis (5)            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CaFinr012E(aLanCab,aLanItens)

Local cOldArea 		:= Alias()
Local nDecs			:=	TamSX3('CT2_VALOR')[2]
Local nLote
Local nX			:=	1
Local nBase			:=	1
Local nMaxLanc		:=	99
Local nContador		:=	Min(Len(aLanItens),nMaxLanc-1)
Local aAreaSI2		:=	CT2->(GetArea())
Local dDataLanc 	:= CTOD("")
Local cLote     	:= space(6)
Local cSubLote  	:= space(3)
Local cCab  		:= {}
Local aItens 		:= {}
Local aCab			:= {}
Local aItem			:= {}
Local aTotItem 		:= {}
Local cSequencia
Local cHp
Local cHist

Private lMsErroAuto := .F.

cDocRdr := CTPESRDR(Subs(aLanItens[1][10],5,6))
/*
aCab := {{"CT2_DATA"	, aLanCab[1][1] 		,NIL},;
		 {"CT2_LOTE"	, Padr(aLanCab[1][2] 	,TamSx3("CT2_LOTE")[1]),NIL},;
		 {"CT2_SBLOTE"	, Padr(aLanCab[1][3] 	,TamSx3("CT2_SBLOTE")[1]),NIL},;
		 {"CT2_DOC"		, cDocRdr 				,NIL}}
*/

/*
Alterado programa dia 15/10/08 pelo analista Emerson
Nao esta funcionando o processo de Estornar o lancamento contabil
A montagem do array ACAB estava utilizando as variaveis acima
alterei a mesma para pegar as variaveis do EXECAUTO abaixo.
em teste realizados funcionou corretamente.
*/


aCab := {{"DDATALANC"	, aLanCab[1][1] 		,NIL},;
		 {"CLOTE"	, Padr(aLanCab[1][2] 	,TamSx3("CT2_LOTE")[1]),NIL},;
		 {"CSUBLOTE"	, Padr(aLanCab[1][3] 	,TamSx3("CT2_SBLOTE")[1]),NIL},;
		 {"CDOC"		, cDocRdr 				,NIL}}


For nX	:= nBase To nContador
	AADD(aItem,{{"CT2_FILIAL"	,xFilial("CT2")					               , NIL},;
				{"CT2_LINHA"	,StrZero(nX+1-nBase,3)					       , NIL},;
				{"CT2_DC"		,aLanItens[nX][2]						       , NIL},;
				{"CT2_ITEMD"	,aLanItens[nX][8] 						       , NIL},;
				{"CT2_CCD"	, IIf(aLanItens[nX][2]=='1', aLanItens[nX][7],""), NIL},;
				{"CT2_ITEMC"	,aLanItens[nX][9] 						       , NIL},;
				{"CT2_CCC"	, IIf(aLanItens[nX][2]=='2', aLanItens[nX][7],""), NIL},;
				{"CT2_VALOR"	,Round(aLanItens[nX][5],nDecs)			       , NIL},;
				{"CT2_HP"		,""  			        				       , NIL},;				
				{"CT2_HIST"		,aLanItens[nX][6] 						       , NIL},;
				{"CT2_TPSALD"	,"9"            						       , NIL},;
				{"CT2_ORIGEM"	,aLanItens[nX][10]						       , NIL},;
				{"CT2_MOEDLC"	,"01"              					           , NIL}})
Next

aadd(aTotItem,aItem)

MSExecAuto({|x,y,Z| Ctba102(x,y,Z)},aCab,aItem,5)

aTotItem	:=	{}

If !lMsErroAuto
	ConOut("Exclusใo com sucesso!")
Else
	ConOut("Erro na exclusใo")
	DisarmTransaction()
	MostraErro()
	Return .F.
EndIf

nBase		:=	nX
nContador	:=	Min(Len(aLanItens),(nBase-1)+(nMaxLanc-1))

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINR012  บAutor  ณMicrosiga           บ Data ณ  06/27/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CTPESRDR(pDocRdr)

Local lRet := " "
Local _cQuery := " "
Local _cFl := CHR(13)+CHR(10)

Local _cLoteCie := ALLTRIM(GETMV("CI_LOTERDR"))

_cQuery := " SELECT CT2_DOC"  
_cQuery += " FROM " + RetSQLName("CT2")
_cQuery += " WHERE D_E_L_E_T_ = ' '  "
_cQuery += " AND CT2_LOTE = '"+_cLoteCie+"' "
_cQuery += " AND SUBSTRING(CT2_ORIGEM,5,6) = '"+pDocRdr+"' "
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'TRS',.T.,.T.)

lRet := TRS->CT2_DOC

If Select("TRS") > 0
	TRS->(DBCLOSEAREA())
EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINR012  บAutor  ณMicrosiga           บ Data ณ  06/27/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CTPTPSLD(pDocRdr)

Local lRet := " "
Local _cQuery := " "
Local _cFl := CHR(13)+CHR(10)

Local _cLoteCie := ALLTRIM(GETMV("CI_LOTERDR"))

_cQuery := " SELECT CT2_TPSALD  FROM " + RetSQLName("CT2") + "  "+_cFl
_cQuery += " WHERE D_E_L_E_T_ = ' '  "+_cFl
_cQuery += " AND SUBSTRING(CT2_ORIGEM,5,6) = '"+pDocRdr+"' "+_cFl
_cQuery += " AND CT2_LOTE = '"+_cLoteCie+"' "+_cFl
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'TRS',.T.,.T.)

lRet := TRS->CT2_TPSALD

If Select("TRS") > 0
	TRS->(DBCLOSEAREA())
EndIf

Return(lRet)

/*
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/
Static Function AjustCont()
_aAliases := {}
_aEstrut  := {}
_aEstrut  := {;
{"TM_CCONTA"   ,  "C", 10, 0},;
{"TM_CR"       ,  "C", 05, 0},;
{"TM_DESC"     ,  "C", 25, 0},;
{"TM_LANC"     ,  "N", 09, 0},;
{"TM_VALDEB"   ,  "N", 17, 2},;
{"TM_LC"       ,  "C", 1, 0},;
{"TM_VALCRE"   ,  "N", 17, 2}}

// Cria o arquivo de trabalho.
_cArqTrab := CriaTrab(_aEstrut, .T.)
dbUseArea(.T., "DBFCDX", _cArqTrab, "TMX", .F., .F.)
// Cria o indice para o arquivo.
IndRegua("TMX", _cArqTrab, "TM_CCONTA+TM_CR",,, "Criando indice...", .T.)
aAdd (_aAliases, {"TMX", _cArqTrab + ".DBF", _cArqTrab + OrdBagExt(), .T.})

_aEstrut  := {}
_aEstrut  := {;
{"TM_CCONTA"   ,  "C", 10, 0},;
{"TM_CR"       ,  "C", 05, 0},;
{"TM_DESC"     ,  "C", 25, 0},;
{"TM_LANC"     ,  "N", 09, 0},;
{"TM_VALDEB"   ,  "N", 17, 2},;
{"TM_LC"       ,  "C", 1, 0},;
{"TM_VALCRE"   ,  "N", 17, 2}}

// Cria o arquivo de trabalho.
_cArqTrab := CriaTrab(_aEstrut, .T.)
dbUseArea(.T., "DBFCDX", _cArqTrab, "TMZ", .F., .F.)
// Cria o indice para o arquivo.
IndRegua("TMZ", _cArqTrab, "TM_CCONTA+TM_CR",,, "Criando indice...", .T.)
aAdd (_aAliases, {"TMZ", _cArqTrab + ".DBF", _cArqTrab + OrdBagExt(), .T.})

// Define a estrutura do arquivo de trabalho.
_aEstrut := {}
_aEstrut := {;
{"TM_DC"       ,  "C", 01, 0},;
{"TM_CCONTA"   ,  "C", 10, 0},;
{"TM_EMISSAO"  ,  "D", 08, 0},;
{"TM_CR"       ,  "C", 05, 0},;
{"TM_VALOR"    ,  "N", 17, 2},;
{"TM_REGISTR"    ,"C", 15, 0},;
{"TM_REGPAR"    ,"C", 15, 0},;
{"TM_LC"    ,"C", 1, 0}}

// Cria o arquivo de trabalho.
_cArqTrab := CriaTrab(_aEstrut, .T.)
dbUseArea(.T., "DBFCDX", _cArqTrab, "TM7", .F., .F.)
// Cria o indice para o arquivo.
IndRegua("TM7", _cArqTrab, "TM_DC+TM_CCONTA+TM_CR+DTOS(TM_EMISSAO)+STR(TM_VALOR,17,2)",,, "Criando indice...", .T.)
aAdd (_aAliases, {"TM7", _cArqTrab + ".DBF", _cArqTrab + OrdBagExt(), .T.})

// Define a estrutura do arquivo de trabalho.
_aEstrut := {}
_aEstrut := {;
{"TM_DC"       ,  "C", 01, 0},;
{"TM_CCONTA"   ,  "C", 10, 0},;
{"TM_EMISSAO"  ,  "D", 08, 0},;
{"TM_CR"       ,  "C", 05, 0},;
{"TM_VALOR"    ,  "N", 17, 2},;
{"TM_REGISTR"    ,"C", 15, 0},;
{"TM_REGPAR"    ,"C", 15, 0},;
{"TM_LC"    ,"C", 1, 0}}

// Cria o arquivo de trabalho.
_cArqTrab := CriaTrab(_aEstrut, .T.)
dbUseArea(.T., "DBFCDX", _cArqTrab, "TM8", .F., .F.)
// Cria o indice para o arquivo.
IndRegua("TM8", _cArqTrab, "TM_DC+TM_CCONTA+TM_CR+DTOS(TM_EMISSAO)+STR(TM_VALOR,17,2)",,, "Criando indice...", .T.)
aAdd (_aAliases, {"TM8", _cArqTrab + ".DBF", _cArqTrab + OrdBagExt(), .T.})

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
_cQuery += " AND YEAR(Z8_EMISSAO) = '"+str(YEAR(DDATABASE)-1)+"'	"
U_EndQuery( @_cQuery,_cOrdem, "QRYTMP7", {"SZ8"},,,.T. )

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
_cQuery += " AND YEAR(Z8_EMISSAO) = '"+str(Year(DDATABASE))+"'	"
U_EndQuery( @_cQuery,_cOrdem, "QRYTMP8", {"SZ8"},,,.T. )

dbSelectArea("QRYTMP7")
dbGoTop()
Do While !Eof()
	dbSelectArea("TM7")
	RecLock("TM7", .T.)
	TM7->TM_DC       := "D"
	TM7->TM_CCONTA   := QRYTMP7->Z8_CCONT
	TM7->TM_EMISSAO  := QRYTMP7->Z8_EMISSAO
	TM7->TM_VALOR    := QRYTMP7->Z8_VALOR
	TM7->TM_REGISTR  := StrZero(QRYTMP7->REGSZ8,15)
	TM7->TM_REGPAR   := StrZero(QRYTMP7->REGSZ8,15)
	TM7->TM_LC       := QRYTMP7->Z8_LC
	msUnLock()
	
	SZF->(dbSetOrder(1))
	SZF->(dbSeek(xFilial("SZF") + QRYTMP7->Z8_BANCO+QRYTMP7->Z8_AGENCIA+QRYTMP7->Z8_CONTA+DTOS(QRYTMP7->Z8_EMISSAO)+QRYTMP7->Z8_REGISTR, .F.))
	
	Do While SZF->(ZF_FILIAL+ZF_BANCO+ZF_AGENCIA+ZF_CONTA+DTOS(ZF_EMISSAO)+ZF_REGISTR) ==  _xFilSZ8+QRYTMP7->Z8_BANCO+QRYTMP7->Z8_AGENCIA+QRYTMP7->Z8_CONTA+DTOS(QRYTMP7->Z8_EMISSAO)+QRYTMP7->Z8_REGISTR
		
		If SZF->ZF_RDR <> QRYTMP7->Z8_RDR
			dbSelectArea("SZF")
			dbSkip()
			Loop
		EndIf
		RecLock("TM7", .T.)
		TM7->TM_DC       := SZF->ZF_DC
		TM7->TM_CCONTA   := SZF->ZF_CCONTA
		TM7->TM_EMISSAO  := SZF->ZF_EMISSAO
		TM7->TM_CR       := SZF->ZF_CR
		TM7->TM_VALOR    := SZF->ZF_VALOR
		TM7->TM_REGISTR  := StrZero(QRYTMP7->REGSZ8,15)
		TM7->TM_REGPAR   := StrZero(QRYTMP7->REGSZ8,15)
		TM7->TM_LC       := QRYTMP7->Z8_LC
		msUnLock()
		SZF->(dbSkip())
	EndDo
	
	dbSelectArea("QRYTMP7")
	dbSkip()
EndDo

dbSelectArea("QRYTMP8")
dbGoTop()
Do While !Eof()
	dbSelectArea("TM8")
	RecLock("TM8", .T.)
	TM8->TM_DC       := "D"
	TM8->TM_CCONTA   := QRYTMP8->Z8_CCONT
	TM8->TM_EMISSAO  := QRYTMP8->Z8_EMISSAO
	TM8->TM_VALOR    := QRYTMP8->Z8_VALOR
	TM8->TM_REGISTR  := StrZero(QRYTMP8->REGSZ8,15)
	TM8->TM_REGPAR   := StrZero(QRYTMP8->REGSZ8,15)
	TM8->TM_LC       := QRYTMP8->Z8_LC
	msUnLock()
	
	SZF->(dbSetOrder(1))
	SZF->(dbSeek(xFilial("SZF") + QRYTMP8->Z8_BANCO+QRYTMP8->Z8_AGENCIA+QRYTMP8->Z8_CONTA+DTOS(QRYTMP8->Z8_EMISSAO)+QRYTMP8->Z8_REGISTR, .F.))
	
	Do While SZF->(ZF_FILIAL+ZF_BANCO+ZF_AGENCIA+ZF_CONTA+DTOS(ZF_EMISSAO)+ZF_REGISTR) ==  _xFilSZ8+QRYTMP8->Z8_BANCO+QRYTMP8->Z8_AGENCIA+QRYTMP8->Z8_CONTA+DTOS(QRYTMP8->Z8_EMISSAO)+QRYTMP8->Z8_REGISTR
		
		If SZF->ZF_RDR <> QRYTMP8->Z8_RDR
			dbSelectArea("SZF")
			dbSkip()
			Loop
		EndIf
		RecLock("TM8", .T.)
		TM8->TM_DC       := SZF->ZF_DC
		TM8->TM_CCONTA   := SZF->ZF_CCONTA
		TM8->TM_EMISSAO  := SZF->ZF_EMISSAO
		TM8->TM_CR       := SZF->ZF_CR
		TM8->TM_VALOR    := SZF->ZF_VALOR
		TM8->TM_REGISTR  := StrZero(QRYTMP8->REGSZ8,15)
		TM8->TM_REGPAR   := StrZero(QRYTMP8->REGSZ8,15)
		TM8->TM_LC       := QRYTMP8->Z8_LC
		msUnLock()
		SZF->(dbSkip())
	EndDo
	
	dbSelectArea("QRYTMP8")
	dbSkip()
EndDo


dbSelectArea("TM7")

dbSelectArea("TM8")

U_EXECTMP()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณ Imp_TMP  ณ Autor ณ    Andy               ณ Data ณ16/01/04  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณCIEE                                                        ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

USER FUNCTION EXECTMP()

Private _cLoteCie := ALLTRIM(GETMV("CI_LOTERDR"))  // Lote Determinado pelo usuario no parametro
Private _cSubLCie := "001"
Private _cDocCie  := "000001"
Private _cLinCie  := 0
Private _lVer := .T.
Private _cLC
Private _cFlg := .F.

dbSelectArea("TM7")
dbGoTop()
While !EOF()
	
	CT1->(dbSetOrder(2))
	CT1->(DBGOTOP())
	CT1->(dbSeek(xFilial("CT1")+SUBS(TM7->TM_CCONTA,1,5)))
	_cCConta := TM7->TM_CCONTA
	_cCR     := TM7->TM_CR
	_cDESC   := Left(AllTrim(CT1->CT1_DESC01),25)
	_nTotDeb := 0
	_nTotCre := 0
	_nLanc   := 0
	
	While !EOF() .And. 	_cCConta == TM7->TM_CCONTA .AND.  TM7->TM_CR ==	_cCR
		
		If TM7->TM_DC == "D"
			_nTotDeb += TM7->TM_VALOR
		Else
			_nTotCre += TM7->TM_VALOR
		EndIf
		_nLanc+=1
		
		If mv_par07 == 1
			If!Empty(TM7->TM_REGISTR)
				dbSelectArea("SZ8")
				dbGoto(Val(TM7->TM_REGISTR))
				RecLock("SZ8", .F.)
				If Empty(SZ8->Z8_FECRAT)
					SZ8->Z8_FECRAT := mv_par01
					SZ8->Z8_LC     := "S"
				EndIf
				msUnLock()
			EndIf
		Endif
		If MV_PAR07 == 3
// Abaixo foi tirado o controle de usuarios e colocado no inicio do prg para nao permitir que o usuario faz Estorno
// tiramos dia 25/07. Emerson Natali
			dbSelectArea("SZ8")
			dbGoto(Val(TM7->TM_REGPAR))
			RecLock("SZ8", .F.)
			SZ8->Z8_FECRAT := ctod("  /  /  ")
			SZ8->Z8_LC     := " "
			msUnLock()
		EndIf

		dbSelectArea("TM7")
		_cLC := TM7->TM_LC

		TM7->(dbSkip())
		
	EndDo
	
	dbSelectArea("TMX")
	if !dbSeek(_cCConta+_cCR)
		RecLock("TMX", .T.)
		TMX->TM_CCONTA   := _cCConta
		TMX->TM_CR       := _cCR
		TMX->TM_DESC     := _cDesc
		TMX->TM_LANC     := _nLanc
		TMX->TM_VALDEB   := _nTotDeb
		TMX->TM_VALCRE   := _nTotCre
		TMX->TM_LC       := _cLC
		msUnLock()
	Else
		RecLock("TMX", .F.)
		TMX->TM_VALDEB   += _nTotDeb
		TMX->TM_VALCRE   += _nTotCre
		TMX->TM_LC       := _cLC
		msUnLock()
	EndIf
	
	dbSelectArea("TM7")
	
EndDo

dbSelectArea("TMX")
dbGoTop()

_nLANC    := 0
_nVALDEB  := 0
_nVALCRE  := 0
_nDevedora:= 0
_nCredora := 0
aLanCab		:= {}
aLanItens	:= {}

While !EOF()
	
	_cCR := TMX->TM_CR
	_cCConta := TMX->TM_CCONTA
	
	While  TMX->TM_CCONTA == _cCConta .AND.  TMX->TM_CR == _cCR
		
		If !Empty(TMX->TM_CCONTA) .And. TMX->TM_VALDEB<>0
			If !Empty(TMX->TM_CR)
				_nDevedora:=_nDevedora+Val(AllTrim(TMX->TM_CCONTA)+AllTrim(TMX->TM_CR))
			Else
				_nDevedora:=_nDevedora+Val(AllTrim(TMX->TM_CCONTA))
			EndIf
		EndIf
		If !Empty(TMX->TM_CCONTA) .And. TMX->TM_VALCRE<>0
			If !Empty(TMX->TM_CR)
				_nCredora :=_nCredora+Val(AllTrim(TMX->TM_CCONTA)+AllTrim(TMX->TM_CR))
			Else
				_nCredora :=_nCredora+Val(AllTrim(TMX->TM_CCONTA))
			EndIf
		EndIf
		
		IF MV_PAR07 == 1 .AND. TMX->TM_LC <> "S" // (1=Sim , 2 = Nao, 3 = Estorno)
			
			_cFlg := .T. // Contabiliza
			//  Cabe็alho da Capa de Lote
			_cLinCie++
			_cDtYear	:= "31/12/"+STR(YEAR(DDATABASE)-1,4)
			_cDatLanc  := Ctod(_cDtYear)
			AADD(aLanCab,{ _cDatLanc,_cLoteCie,"001" })     // Data do Movimento Contabil
			DBSELECTAREA("CT1")
			CT1->(DBSETORDER(2))
			CT1->(DBSEEK(xFilial("CT1")+SUBS(TMX->TM_CCONTA,1,6)))
			// Movimentos do Lan็amento Padrใo
			
			AADD(aLanItens,{StrZero(_cLinCie,3),;
			IIF(!Empty(TMX->TM_VALDEB),"1","2"),;
			IIF(!Empty(TMX->TM_VALDEB),CT1->CT1_CONTA,""),;
			IIF(!Empty(TMX->TM_VALCRE),CT1->CT1_CONTA,""),;
			IIF(!Empty(TMX->TM_VALCRE),TMX->TM_VALCRE, TMX->TM_VALDEB),;
			ALLTRIM(MV_PAR02)+SPACE(2)+Dtoc(_cDatLanc),;
			TMX->TM_CR,;
			IIF(!Empty(TMX->TM_VALDEB),ALLTRIM(TMX->TM_CCONTA),""),;
			IIF(!Empty(TMX->TM_VALCRE),ALLTRIM(TMX->TM_CCONTA),""),;
			"760 "+ALLTRIM(MV_PAR02)})
			
		ENDIF

		// Gera Lan็amento para exclusao
		IF MV_PAR07 == 3  .AND. TMX->TM_LC == "S" // (1=Sim , 2 = Nao, 3 = Estorno)
			_cFlg := .T.
			//  Cabe็alho da Capa de Lote
			_cLinCie++
			_cDatLanc  := Ctod("31/12/2007")
			AADD(aLanCab,{ _cDatLanc,_cLoteCie,"001" })     // Data do Movimento Contabil
			DBSELECTAREA("CT1")
			CT1->(DBSETORDER(2))
			CT1->(DBSEEK(xFilial("CT1")+SUBS(TMX->TM_CCONTA,1,6)))
			// Movimentos do Lan็amento Padrใo
			
			AADD(aLanItens,{StrZero(_cLinCie,3),;
							IIF(!Empty(TMX->TM_VALDEB),"1","2"),;
							IIF(!Empty(TMX->TM_VALDEB),CT1->CT1_CONTA,""),;
							IIF(!Empty(TMX->TM_VALCRE),CT1->CT1_CONTA,""),;
							IIF(!Empty(TMX->TM_VALCRE),TMX->TM_VALCRE, TMX->TM_VALDEB),;
							ALLTRIM(MV_PAR02)+SPACE(2)+Dtoc(_cDatLanc),;
							TMX->TM_CR,;
							IIF(!Empty(TMX->TM_VALDEB),ALLTRIM(TMX->TM_CCONTA),""),;
							IIF(!Empty(TMX->TM_VALCRE),ALLTRIM(TMX->TM_CCONTA),""),;
							"760 "+ALLTRIM(MV_PAR02)})
		ENDIF
		
		_nLANC   += TMX->TM_LANC
		_nVALDEB += TMX->TM_VALDEB
		_nVALCRE += TMX->TM_VALCRE
		
		nLin:=nLin+1
		
		dbSelectArea("TMX")
		dbSkip()
		
	End

EndDo

IF MV_PAR07 == 1 .AND. _cFlg == .T.
	CaFinr012I(aLanCab,aLanItens)
ENDIF
IF MV_PAR07 == 3 .AND. _cFlg == .T.
	CaFinr012E(aLanCab,aLanItens)
ENDIF


dbSelectArea("TM8")
dbGoTop()
While !EOF()
	
	CT1->(dbSetOrder(2))
	CT1->(DBGOTOP())
	CT1->(dbSeek(xFilial("CT1")+SUBS(TM8->TM_CCONTA,1,5)))
	_cCConta := TM8->TM_CCONTA
	_cCR     := TM8->TM_CR
	_cDESC   := Left(AllTrim(CT1->CT1_DESC01),25)
	_nTotDeb := 0
	_nTotCre := 0
	_nLanc   := 0
	
	While !EOF() .And. 	_cCConta == TM8->TM_CCONTA .AND.  TM8->TM_CR ==	_cCR
		
		If TM8->TM_DC == "D"
			_nTotDeb += TM8->TM_VALOR
		Else
			_nTotCre += TM8->TM_VALOR
		EndIf
		
		_nLanc+=1
		
		If mv_par07 == 1
			If!Empty(TM8->TM_REGISTR)
				dbSelectArea("SZ8")
				dbGoto(Val(TM8->TM_REGISTR))
				RecLock("SZ8", .F.)
				If Empty(SZ8->Z8_FECRAT)
					SZ8->Z8_FECRAT := mv_par01
					SZ8->Z8_LC     := "S"
				EndIf
				msUnLock()
			EndIf
		Endif
		If MV_PAR07 == 3
// Abaixo foi tirado o controle de usuarios e colocado no inicio do prg para nao permitir que o usuario faz Estorno
// tiramos dia 25/07. Emerson Natali
			dbSelectArea("SZ8")
			dbGoto(Val(TM8->TM_REGPAR))
			RecLock("SZ8", .F.)
			SZ8->Z8_FECRAT := ctod("  /  /  ")
			SZ8->Z8_LC     := " "
			msUnLock()
		EndIf

		dbSelectArea("TM8")
		_cLC := TM8->TM_LC
		
		TM8->(dbSkip())
		
	EndDo
	
	dbSelectArea("TMZ")
	if !dbSeek(_cCConta+_cCR)
		RecLock("TMZ", .T.)
		TMZ->TM_CCONTA   := _cCConta
		TMZ->TM_CR       := _cCR
		TMZ->TM_DESC     := _cDesc
		TMZ->TM_LANC     := _nLanc
		TMZ->TM_VALDEB   := _nTotDeb
		TMZ->TM_VALCRE   := _nTotCre
		TMZ->TM_LC       := _cLC
		msUnLock()
	Else
		RecLock("TMZ", .F.)
		TMZ->TM_VALDEB   += _nTotDeb
		TMZ->TM_VALCRE   += _nTotCre
		TMZ->TM_LC       := _cLC
		msUnLock()
	EndIf
	
	dbSelectArea("TM8")
	
EndDo

dbSelectArea("TMZ")
dbGoTop()

_nLANC    := 0
_nVALDEB  := 0
_nVALCRE  := 0
_nDevedora:= 0
_nCredora := 0
aLanCab		:= {}
aLanItens	:= {}

While !EOF()
	
	_cCR := TMZ->TM_CR
	_cCConta := TMZ->TM_CCONTA
	
	While  TMZ->TM_CCONTA == _cCConta .AND.  TMZ->TM_CR == _cCR
		
		If !Empty(TMZ->TM_CCONTA) .And. TMZ->TM_VALDEB<>0
			If !Empty(TMZ->TM_CR)
				_nDevedora:=_nDevedora+Val(AllTrim(TMZ->TM_CCONTA)+AllTrim(TMZ->TM_CR))
			Else
				_nDevedora:=_nDevedora+Val(AllTrim(TMZ->TM_CCONTA))
			EndIf
		EndIf
		If !Empty(TMZ->TM_CCONTA) .And. TMZ->TM_VALCRE<>0
			If !Empty(TMZ->TM_CR)
				_nCredora :=_nCredora+Val(AllTrim(TMZ->TM_CCONTA)+AllTrim(TMZ->TM_CR))
			Else
				_nCredora :=_nCredora+Val(AllTrim(TMZ->TM_CCONTA))
			EndIf
		EndIf
		
		IF MV_PAR07 == 1 .AND. TMZ->TM_LC <> "S" // (1=Sim , 2 = Nao, 3 = Estorno)
			
			_cFlg := .T. // Contabiliza
			//  Cabe็alho da Capa de Lote
			_cLinCie++
			AADD(aLanCab,{ MV_PAR01 ,_cLoteCie,"001" })     // Data do Movimento Contabil
			DBSELECTAREA("CT1")
			CT1->(DBSETORDER(2))
			CT1->(DBSEEK(xFilial("CT1")+SUBS(TMZ->TM_CCONTA,1,6)))
			// Movimentos do Lan็amento Padrใo
			
			AADD(aLanItens,{StrZero(_cLinCie,3),;
			IIF(!Empty(TMZ->TM_VALDEB),"1","2"),;
			IIF(!Empty(TMZ->TM_VALDEB),CT1->CT1_CONTA,""),;
			IIF(!Empty(TMZ->TM_VALCRE),CT1->CT1_CONTA,""),;
			IIF(!Empty(TMZ->TM_VALCRE),TMZ->TM_VALCRE, TMZ->TM_VALDEB),;
			ALLTRIM(MV_PAR02)+SPACE(2)+Dtoc(MV_PAR01),;
			TMZ->TM_CR,;
			IIF(!Empty(TMZ->TM_VALDEB),ALLTRIM(TMZ->TM_CCONTA),""),;
			IIF(!Empty(TMZ->TM_VALCRE),ALLTRIM(TMZ->TM_CCONTA),""),;
			"760 "+ALLTRIM(MV_PAR02)})
			
		ENDIF

		// Gera Lan็amento para exclusao
		IF MV_PAR07 == 3  .AND. TMZ->TM_LC == "S" // (1=Sim , 2 = Nao, 3 = Estorno)
			_cFlg := .T.
			//  Cabe็alho da Capa de Lote
			_cLinCie++
			AADD(aLanCab,{ MV_PAR01,_cLoteCie,"001" })     // Data do Movimento Contabil
			DBSELECTAREA("CT1")
			CT1->(DBSETORDER(2))
			CT1->(DBSEEK(xFilial("CT1")+SUBS(TMZ->TM_CCONTA,1,6)))
			// Movimentos do Lan็amento Padrใo
			
			AADD(aLanItens,{StrZero(_cLinCie,3),;
							IIF(!Empty(TMZ->TM_VALDEB),"1","2"),;
							IIF(!Empty(TMZ->TM_VALDEB),CT1->CT1_CONTA,""),;
							IIF(!Empty(TMZ->TM_VALCRE),CT1->CT1_CONTA,""),;
							IIF(!Empty(TMZ->TM_VALCRE),TMZ->TM_VALCRE, TMZ->TM_VALDEB),;
							ALLTRIM(MV_PAR02)+SPACE(2)+Dtoc(MV_PAR01),;
							TMZ->TM_CR,;
							IIF(!Empty(TMZ->TM_VALDEB),ALLTRIM(TMZ->TM_CCONTA),""),;
							IIF(!Empty(TMZ->TM_VALCRE),ALLTRIM(TMZ->TM_CCONTA),""),;
							"760 "+ALLTRIM(MV_PAR02)})
		ENDIF
		
		_nLANC   += TMZ->TM_LANC
		_nVALDEB += TMZ->TM_VALDEB
		_nVALCRE += TMZ->TM_VALCRE
		
		nLin:=nLin+1
		
		dbSelectArea("TMZ")
		dbSkip()
		
	End

EndDo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

dbSelectArea("QRYTMP7")
dbCloseArea()

dbSelectArea("QRYTMP8")
dbCloseArea()

IF MV_PAR07 == 1 .AND. _cFlg == .T.
	CaFinr012I(aLanCab,aLanItens)
ENDIF
IF MV_PAR07 == 3 .AND. _cFlg == .T.
	CaFinr012E(aLanCab,aLanItens)
ENDIF

FechaAlias(_aAliases)

Return