
#INCLUDE "rwmake.ch"
#include "_FixSX.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINA24   º Autor ³ Andy               º Data ³  26/03/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cadastro de Apicacoes                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CFINA24()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cArq,cInd,cPerg
Local cString := "SZG"
Local aStru

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
Private aPags := {}
Private _dPar01, _dPar02
Private _cSZGBan, _cSZGAge, _cSZGCon

_cSZGBan:=Space(03)
_cSZGAge:=Space(05)
_cSZGCon:=Space(10)

dbSelectArea("SZG")
dbSetOrder(1)

//AxCadastro(cString, "Contas de Consumo", cVldAlt, cVldExc)

cCadastro := "Aplicacoes Financeiras"
aCores    := {}

cDelFunc  := "U_VERSZG()"
aRotina   := { 	{"Pesquisar"  ,"AxPesqui"    , 0 , 1},;
{"Visualizar" ,"AxVisual"    , 0 , 2},;
{"Incluir"    ,'AxInclui("SZG",Recno(),3,,"U_SZGIni",,"U_SZGTudOK()")' , 0 , 3},;
{"Alterar"    ,'AxAltera("SZG",Recno(),4,,,,,"U_VERSZG()")', 0 , 4},;
{"Excluir"    ,'U_SZGCTB("SZG",Recno(),5,,,,,)'   , 0 , 5},;
{"Imprimir" 	  ,"U_CFINR018"  , 0 , 6},;
{"Fluxo"      ,"U_SZG_FLUXO" , 0 , 7},;
{"Legenda"    ,'BrwLegenda(cCadastro,"Legenda",{{"BR_VERDE","Sem Fluxo"},{"BR_VERMELHO","Com Fluxo"}})',0 , 8 }}

Aadd( aCores, { " Empty(ZG_FLUXO) " 	, "BR_VERDE" 	 	} )
Aadd( aCores, { "!Empty(ZG_FLUXO) " 	, "BR_VERMELHO"		} )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Realiza a Filtragem                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SZG")
dbSetOrder(1)

mBrowse( 6,1,22,75,"SZG",,,,,2, aCores)

Return


User Function VERSZG()
Local  _aArea := GetArea()
_cRet := If(Empty(SZG->ZG_FLUXO),.T.,.F.)
If !_cRet
	_cMsg := "Fluxo de Caixa gerado sobre o registro, Não podera ser Alterado, ou Excluido!!!"
	MsgAlert(_cMsg, "Atenção")
EndIf
RestArea(_aArea)
Return(_cRet)


User Function SZG_FLUXO()
Local aArea := GetArea()

Private cPerg  := "FIN124"
lRet        := .F.
aPags       := {}

_aPerg := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01 - Conta de                                    ³
//³ mv_par02 - Conta ate                                   ³
//³ mv_par03 - Emissao de                                  ³
//³ mv_par04 - Emissao ate                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

AADD(_aPerg,{cPerg,"01","Conta de           ?","","","mv_ch1","C",10,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","BZC","",""})
AADD(_aPerg,{cPerg,"02","Conta ate          ?","","","mv_ch2","C",10,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","BZC","",""})
AADD(_aPerg,{cPerg,"03","Data de            ?","","","mv_ch3","D",08,0,0,"G","","mv_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"04","Data ate           ?","","","mv_ch4","D",08,0,0,"G","","mv_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

AjustaSX1(_aPerg)

If !Pergunte(cPerg, .T.)
	Return
EndIf

_xFilSZG:= xFilial("SZG")
_cOrdem := " ZG_FILIAL, ZG_CONTA, ZG_EMISSAO"
_cQuery := " SELECT * , SZG.R_E_C_N_O_ REGSZG"
_cQuery += " FROM "

_cQuery += RetSqlName("SZG")+" SZG"
_cQuery += " WHERE '"+ _xFilSZG +"' = ZG_FILIAL"

_cQuery += " AND    ZG_CONTA   >= '"+mv_par01+"'"
_cQuery += " AND    ZG_CONTA   <= '"+mv_par02+"'"
_cQuery += " AND    ZG_EMISSAO >= '"+DTOS(mv_par03)+"'"
_cQuery += " AND    ZG_EMISSAO <= '"+DTOS(mv_par04)+"'"

U_EndQuery( @_cQuery,_cOrdem, "SZGTMP", {"SZG" },,,.T. )

dbSelectArea("SZGTMP")
dbGoTop()

_cDocumento := "APL"+DTOS(MV_PAR04)
_cNatureza  := SZGTMP->ZG_NATREC
_nTotal     := 0
_cBanco     := SZGTMP->ZG_BANCO
_cAgencia   := SZGTMP->ZG_AGENCIA
_cConta     := SZGTMP->ZG_CONTA

While !Eof()
	dbSelectArea("SE5")
	dbSetOrder(1)
	If !dbSeek(xFilial("SE5")+DTOS(MV_PAR04)+SZGTMP->ZG_BANCO+SZGTMP->ZG_AGENCIA+SZGTMP->ZG_CONTA+_cDocumento, .F.)
		_cConta := SZGTMP->ZG_CONTA
		Begin Transaction
		dbSelectArea("SZGTMP")
		While !Eof() .And. _cConta == SZGTMP->ZG_CONTA
			dbSelectArea("SZG")
			dbGoTo(SZGTMP->REGSZG)
			RecLock("SZG", .F.)
			SZG->ZG_FLUXO := _cDocumento
			msUnLock()
			dbSelectArea("SZGTMP")
			_nTotal:=_nTotal+SZGTMP->ZG_VALREC
			DbSkip()
		EndDo
		dbSelectArea("SE5")
		RecLock("SE5", .T.)
		SE5->E5_FILIAL  := xFilial("SE5")
		SE5->E5_BANCO   := _cBanco
		SE5->E5_AGENCIA := _cAgencia
		SE5->E5_CONTA   := _cConta
		SE5->E5_NUMCHEQ := _cDocumento
		SE5->E5_MOEDA   := "PL"
		SE5->E5_TIPODOC := "PL"
		SE5->E5_RECPAG  := "R"
		SE5->E5_DATA    := MV_PAR04
		SE5->E5_VENCTO  := MV_PAR04
		SE5->E5_NUMERO  := ""
		SE5->E5_PREFIXO := ""
		SE5->E5_TIPO    := ""
		SE5->E5_VALOR   := _nTotal
		SE5->E5_NATUREZ := _cNatureza
		SE5->E5_HISTOR  := _cDocumento
		SE5->E5_LA      := "N"
		SE5->E5_CLIFOR  :=	"DEBAUT"
		SE5->E5_DTDIGIT := MV_PAR04
		SE5->E5_MOTBX   := "NOR"
		SE5->E5_RECONC  := "x"
		SE5->E5_SEQ     := "01"
		SE5->E5_DTDISPO := MV_PAR04
		SE5->E5_DOCUMEN := _cDocumento
		SE5->E5_BENEF   := "CIEE"
		SE5->(msUnLock())
		End Transaction
		dbSelectArea("SZGTMP")
	Else
		msgstop("Já Existe Movimentação Bancária para o Fluxo nesta Data, para esta Conta!")
		_cConta := SZGTMP->ZG_CONTA
		While !Eof() .And. _cConta == SZGTMP->ZG_CONTA
			dbSelectArea("SZGTMP")
			DbSkip()
		EndDo
		dbSelectArea("SZGTMP")
	EndIf
Enddo

dbSelectArea("SZGTMP")
DbCloseArea()

Return


User Function SZGIni()

Local  _aArea := GetArea()

M->ZG_BANCO    := _cSZGBan
M->ZG_AGENCIA  := _cSZGAge
M->ZG_CONTA    := _cSZGCon
RestArea(_aArea)
Return

User Function SZGTudOK()

Local   _aArea := GetArea()
Local   cConta := "114011"

Private _cLoteCie := "009600"
Private _cDocCie  := 0
Private  dEmissao := M->ZG_EMISSAO
Private _cSZGBan  := M->ZG_BANCO
Private _cSZGAge  := M->ZG_AGENCIA
Private _cSZGCon  := M->ZG_CONTA
Private _cSZGIOF  := M->ZG_IOF
Private nValor := 0
Private _cCustoC := ""
Private _cCustoD := ""


DBSELECTAREA("SA6")
SA6->(DBSETORDER(1))
SA6->(DBSEEK(xFilial("SA6")+_cSZGBan+_cSZGAge+_cSZGCon))

_cDocCie  :=  VAL(CTGERDOC(_cLoteCie,dEmissao))
_cDocCie+=1

/*
If !EMPTY(M->ZG_VALAPL)  // Aplicacao
	nValor := M->ZG_VALAPL
	_cCustoC := " "
	_cCustoD := " "
	cDC := "1"
	cConta := "114011"
	cHistEs := ALLTRIM(SA6->A6_NREDUZ)+" APLIC CURTO PRAZO  "
	Cfina24C(nValor,cConta,cHistEs,cDC,dEmissao,_cDocCie,_cLoteCie,_cCustoC,_cCustoD)
	cDC := "2"
	cConta  := SA6->A6_CONTABI
	Cfina24C(nValor,cConta,cHistEs,cDC,dEmissao,_cDocCie,_cLoteCie,_cCustoC,_cCustoD)
ENDIF
*/
IF !EMPTY(M->ZG_VALREC)
	nValor := M->ZG_VALREC
	cDC := "1"
	_cCustoC := " "
	_cCustoD := " "
	cConta := "114011"
	cHistEs := ALLTRIM(SA6->A6_NREDUZ)+" RENDIMENTO CURTO PRAZO "
	Cfina24C(nValor,cConta,cHistEs,cDC,dEmissao,_cDocCie,_cLoteCie,_cCustoC,_cCustoD)
	
	cDC := "2"
	cConta  := "49113"
	_cCustoC := "026"
	_cCustoD := " "
	Cfina24C(nValor,cConta,cHistEs,cDC,dEmissao,_cDocCie,_cLoteCie,_cCustoC,_cCustoD)
ENDIF


/*
IF !EMPTY(M->ZG_VALRES)
	nValor := M->ZG_VALRES
	cDC := "1"
	_cCustoC := " "
	_cCustoD := " "
	cConta  := SA6->A6_CONTABI
	cHistEs := ALLTRIM(SA6->A6_NREDUZ)+" RESGATE CURTO PRAZO "
	Cfina24C(nValor,cConta,cHistEs,cDC,dEmissao,_cDocCie,_cLoteCie,_cCustoC,_cCustoD)
	cDC := "2"
	cConta  := "114011"
	Cfina24C(nValor,cConta,cHistEs,cDC,dEmissao,_cDocCie,_cLoteCie,_cCustoC,_cCustoD)
ENDIF
*/

If !EMPTY(M->ZG_IOF)  // IOF
	nValor := M->ZG_IOF
	
	cDC := "1"
	cConta  := "49113"
	_cCustoD := "026"
	_cCustoC := " "
	cHistEs := ALLTRIM(SA6->A6_NREDUZ)+" IOF APLIC CURTO PRAZO  "
	Cfina24C(nValor,cConta,cHistEs,cDC,dEmissao,_cDocCie,_cLoteCie,_cCustoC,_cCustoD)
	
	cDC := "2"
	cConta := "114011"
	_cCustoD := " "
	Cfina24C(nValor,cConta,cHistEs,cDC,dEmissao,_cDocCie,_cLoteCie,_cCustoC,_cCustoD)
	
ENDIF


RestArea(_aArea)

Return(.T.)

User Function CFINASLD(pBANCO,pAGENCIA,pCONTA,pEMISSAO)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINASLD  ºAutor  ³ Claudio Barros    º Data ³  07/01/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Utilizado para trazer o ultimo saldo do banco, conta e     º±±
±±º          ³ agencia selecionado, para popular o campo ZG_VALINI        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFIN - Rotina CFINA24                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


Local _nCt := 0
Local _lRet := 0
Local _cRecno := SZG->(RECNO())

While .T.
	IF SZG->(DbSeek(xFilial("SZG")+pBANCO+pAGENCIA+pCONTA+DTOS(pEMISSAO-_nCt)))
		_lRet := SZG->ZG_VALFIN
		EXIT
	ELSE
		IF _nCt > 5
			_lRet := 0
			EXIT
		ENDIF
	ENDIF
	_nCt++
END

SZG->(DBGOTO(_cRecno))


Return(_lRet)



Static Function Cfina24C(pValor,pConta,pHist,pDC,pEmissao,pDoc,pLote,pCustoC,pCustoD)



Private _cSubLCie := "001"
Private _cLinCie  := 0
Private nLanSeq   := 0
Private pDtEmis   := pEmissao
Private _cLoteCie :=pLote
Private _cDocCie  := pDoc

dbSelectArea("CT2")
dbSetOrder(1)

_cLinCie  :=  VAL(CTGERLAN(_cLoteCie,_cSubLCie,pDtEmis,STRZERO(_cDocCie,6)))

RecLock("CT2",.T.)
CT2->CT2_FILIAL := xFILIAL("CT2")
CT2->CT2_DATA   := pDtEmis
CT2->CT2_LOTE   := pLote
CT2->CT2_SBLOTE := _cSubLCie
_cLinCie := _cLinCie + 1
CT2->CT2_LINHA  :=StrZero(_cLinCie,3)
CT2->CT2_DOC    := StrZero(_cDocCie,6)
DBSELECTAREA("CT1")
CT1->(DBSETORDER(2))
CT1->(DBSEEK(xFILIAL("CT1")+pConta))
IF pDC == "1"
	CT2->CT2_DC  := "1"
	CT2->CT2_DEBITO := CT1->CT1_CONTA
ELSE
	CT2->CT2_DC  := "2"
	CT2->CT2_CREDIT := CT1->CT1_CONTA
ENDIF
CT2->CT2_DCD:= ""
CT2->CT2_DCC:= ""
CT2->CT2_MOEDLC:="01"
CT2->CT2_VALOR:= pValor
CT2->CT2_MOEDAS:="1"
CT2->CT2_HP:= ""
CT2->CT2_HIST:= pHist
CT2->CT2_CRITER:="1"
CT2->CT2_CCD:= pCustoD
CT2->CT2_CCC:= pCustoC

IF pDC == "1"
	CT2->CT2_ITEMD  := pConta
ELSE
	CT2->CT2_ITEMC  := pConta
ENDIF
CT2->CT2_CLVLDB:= ""
CT2->CT2_CLVLCR:= ""
CT2->CT2_VLR02:= 0
CT2->CT2_VLR03:= 0
CT2->CT2_VLR04:= 0
CT2->CT2_VLR05:= 0
CT2->CT2_ATIVDE:= ""
CT2->CT2_ATIVCR:= ""
CT2->CT2_EMPORI:=Substr(cNumEmp,1,2)
CT2->CT2_FILORI:=xFilial("CT2")
CT2->CT2_INTERC:="2"
CT2->CT2_IDENTC:= ""
CT2->CT2_TPSALD:= "9"
CT2->CT2_SEQUEN:=StrZero(_cLinCie,3)
CT2->CT2_MANUAL:="1"
CT2->CT2_ORIGEM:="210 CFINA24"
CT2->CT2_ROTINA:="CFINA24"
CT2->CT2_AGLUT:= "2"
CT2->CT2_LP:=""
CT2->CT2_KEY := ""
CT2->CT2_SEQHIS:=StrZero(_cLinCie,3)
nLanSeq := (VAL(CTGERLAN(_cLoteCie,_cSubLCie,pDtEmis,STRZERO(_cDocCie,6)))+1)
CT2->CT2_SEQLAN:=  StrZero(nLanSeq,3)
CT2->CT2_DTVENC:= Ctod("//")
CT2->(MSUNLOCK())


Return



Static  Function CTGERLAN(pLote,pSbLote,pData,pDoc)


Local _cQuery := " "
Local _cFl := CHR(13)+CHR(10)
Local _lRet := 0


_cQuery := " SELECT MAX(CT2_SEQLAN) AS SEQMOV FROM " + RetSQLName("CT2") + "  "+_cFl
_cQuery += " WHERE D_E_L_E_T_ = ' '  AND CT2_LOTE = '"+pLote+"'  "+_cFl
_cQuery += " AND CT2_SBLOTE = '"+pSbLote+"' "+_cFl
_cQuery += " AND CT2_DATA = '"+Dtos(pData)+"' AND CT2_DOC = '"+pDoc+"' "+_cFl
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'TRT',.T.,.T.)


_lRet := TRT->SEQMOV


If Select("TRT") > 0
	TRT->(DBCLOSEAREA())
EndIf


Return(_lRet)

Static  Function CTGERDOC(pLote,pData)


Local _cQuery := " "
Local _cFl := CHR(13)+CHR(10)
Local _lRet := 0


_cQuery := " SELECT MAX(CT2_DOC) AS SEQDOC FROM " + RetSQLName("CT2") + "  "+_cFl
_cQuery += " WHERE D_E_L_E_T_ = ' '  AND CT2_LOTE = '"+pLote+"'  "+_cFl
_cQuery += " AND CT2_DATA = '"+Dtos(pData)+"' "+_cFl
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'TRT',.T.,.T.)


_lRet := TRT->SEQDOC


If Select("TRT") > 0
	TRT->(DBCLOSEAREA())
EndIf


Return(_lRet)



User Function SZGCTB(cAlias,nReg,nOpc,cTransact,aCpos,aButtons)


Local   _aArea := GetArea()
Local   cConta := "114011"
Local nOpcA,oDlg, lDel := .t., aPosEnch,lX

Private _cLoteCie := "009600"
Private _cDocCie  := 0
Private  dEmissao
Private _cSZGBan
Private _cSZGAge
Private _cSZGCon
Private nValor := 0
Private _cCustoD := ""
Private _cCustoC := ""
Private aTELA[0][0],aGETS[0]


*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³ Envia para processamento dos Gets			 ³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOpcA:=0

DbSelectArea(cAlias)
SoftLock( cAlias )

DEFINE MSDIALOG oDlg TITLE cCadastro FROM 9,0 TO TranslateBottom(.F.,28),80 OF oMainWnd

aPosEnch := {,,(oDlg:nClientHeight - 4)/2,}  // ocupa todo o  espaço da janela


nOpcA:=EnChoice( cAlias, nReg, nOpc,,,,aCpos,aPosEnch)

nOpca := 1
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpca := 2,oDlg:End()},{|| nOpca := 1,oDlg:End()},,aButtons)

DbSelectArea(cAlias)

dEmissao :=  SZG->ZG_EMISSAO
_cSZGBan  := SZG->ZG_BANCO
_cSZGAge  := SZG->ZG_AGENCIA
_cSZGCon  := SZG->ZG_CONTA
_cSZGIOF  := SZG->ZG_IOF

If nOpcA == 2
	DBSELECTAREA("SA6")
	SA6->(DBSETORDER(1))
	SA6->(DBSEEK(xFilial("SA6")+_cSZGBan+_cSZGAge+_cSZGCon))
	
	_cDocCie  :=  VAL(CTGERDOC(_cLoteCie,dEmissao))
	_cDocCie+=1
	
/*
	If !EMPTY(SZG->ZG_VALAPL)  // Aplicacao
		nValor := SZG->ZG_VALAPL
		cDC := "2"
		_cCustoC := " "
		_cCustoD := " "
		cConta := "114011"
		cHistEs := "ESTORNO "+ALLTRIM(SA6->A6_NREDUZ)+" APLIC CURTO PRAZO  "
		Cfina24C(nValor,cConta,cHistEs,cDC,dEmissao,_cDocCie,_cLoteCie,_cCustoC,_cCustoD)
		
		cDC := "1"
		cConta  := SA6->A6_CONTABI
		Cfina24C(nValor,cConta,cHistEs,cDC,dEmissao,_cDocCie,_cLoteCie,_cCustoC,_cCustoD)
	ENDIF
*/
	
	IF !EMPTY(SZG->ZG_VALREC)
		nValor := SZG->ZG_VALREC
		cDC := "2"
		_cCustoC := " "
		_cCustoD := " "
		cConta := "114011"
		cHistEs := "ESTORNO "+ALLTRIM(SA6->A6_NREDUZ)+" RENDIMENTO CURTO PRAZO "
		Cfina24C(nValor,cConta,cHistEs,cDC,dEmissao,_cDocCie,_cLoteCie,_cCustoC,_cCustoD)
		cDC := "1"
		cConta  := "49113"
		_cCustoC := " "
		_cCustoD := "026"
		Cfina24C(nValor,cConta,cHistEs,cDC,dEmissao,_cDocCie,_cLoteCie,_cCustoC,_cCustoD)
	ENDIF
	
/*	
	IF !EMPTY(SZG->ZG_VALRES)
		nValor := SZG->ZG_VALRES
		cDC := "2"
		_cCustoC := " "
		_cCustoD := " "
		cConta  := SA6->A6_CONTABI
		cHistEs := "ESTORNO "+ALLTRIM(SA6->A6_NREDUZ)+" RESGATE CURTO PRAZO "
		Cfina24C(nValor,cConta,cHistEs,cDC,dEmissao,_cDocCie,_cLoteCie,_cCustoC,_cCustoD)
		
		cDC := "1"
		cConta  := "114011"
		Cfina24C(nValor,cConta,cHistEs,cDC,dEmissao,_cDocCie,_cLoteCie,_cCustoC,_cCustoD)
	ENDIF
*/

	If !EMPTY(SZG->ZG_IOF)  // IOF
		nValor := SZG->ZG_IOF
		
		cDC := "2"
		cConta  := "49113"
		_cCustoC := "026"
		_cCustoD := " "
		cHistEs := "ESTORNO "+ALLTRIM(SA6->A6_NREDUZ)+" IOF APLIC CURTO PRAZO  "
		Cfina24C(nValor,cConta,cHistEs,cDC,dEmissao,_cDocCie,_cLoteCie,_cCustoC,_cCustoD)
		
		cDC := "1"
		cConta := "114011"
		_cCustoC := " "
		Cfina24C(nValor,cConta,cHistEs,cDC,dEmissao,_cDocCie,_cLoteCie,_cCustoC,_cCustoD)
		
	ENDIF
	
	DbSelectArea(cAlias)
	
	
	If Type("cDelFunc") != "U" .and. cDelFunc != nil
		If !&(cDelFunc)
			lDel := .f.
		EndIf
	EndIf
	If lDel
		If Type("aMemos")=="A"
			For i := 1 To Len(aMemos)
				MSMM(&(aMemos[i][1]),,,,2)
			Next i
		EndIf
		Begin Transaction
		DbSelectArea( cAlias )
		If cTransact != Nil .And. ValType(cTransact) == "C"
			If !("("$cTransact)
				cTransact+="()"
			EndIf
			lX := &cTransact
		EndIf
		DbSelectArea( cAlias )
		RecLock(cAlias,.F.,.T.)
		dbDelete( )
		WriteSx2( cAlias )
		End Transaction
	EndIf
	DbSelectArea(cAlias)
	MsUnlock()
Else
	MsUnlock( )
End
DbSelectArea(cAlias)

RestArea(_aArea)

Return(nOpcA)




