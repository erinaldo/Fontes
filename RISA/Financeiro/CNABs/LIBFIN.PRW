//+------------------------------------------------------------------------------+
//|                               INCLUDE DE SISTEMA                             |
//+------------------------------------------------------------------------------+
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

//+------------------------------------------------------------------------------+
//|                               DEFINES DE SISTEMA                             |
//+------------------------------------------------------------------------------+
#DEFINE CRLF CHR(010)+CHR(013)

//+--------Â---------------+-----Â-------------------------------+----+----------+
//|Programa| LIBFIN        |Autor| Alex Matos                    |Data| 22.04.20 |
//+--------Å---------------+-----Á-------------------------------+----+----------+
//|Descric.| Biblioteca de funcoes financeiras. Uso especifico em contas a Pagar |
//|        | e contas a receber CNAB A PAGAR BANCO DO BRASIL                     |
//+--------Á---------------------------------------------------------------------+
//|Modulo  | Financeiro          |Tipo | [ ]Transacao   		[ ]Relatorio     |
//|        |                     |     | [x]Processamento       [ ]Validacao     |
//|        |                     |     | [ ]Ponto de Entrada    [ ]Gatilho       |
//+--------+---------------------+-----+-----------------------------------------+

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±±ºPrograma  ³NOSSOBB   ºAutor  ³ALEX MATOS          º Data ³  22/04/20   º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDesc.     ³Programa que agrupa os numeros de                           º±±
//±±º          ³ convenio+PREFIXO+NUMERO+PARCELA                            º±±
//±±º          ³"1672527"+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA       º±±
//±±º          ³                                                            º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºUso       ³ AP                                                         º±±
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

User Function NOSSOBB(_cConv)
	_cPref		:=	padl(alltrim(SE1->E1_PREFIXO),3,"0")
	_cNum		:=	RIGHT(STRZERO(VAL(SE1->E1_NUM),9),6)
	_cParcela	:=	iif(empty(SE1->E1_PARCELA),"1",SE1->E1_PARCELA)
	_cNosso		:=	_cConv + _cPref + _cNum + _cParcela

return(_cNosso)

User Function HCRETVAL(nOpc)

	If nOpc == NIL
		nValAb := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
		nValor := (SE1->E1_VALOR - nValAb) * 100
	Else
		nValor := INT (round (SE1->E1_VALOR*0.02/30,2)*100)     //Alteração de SE1->E1_VALOR*0.10 ==> para SE1->E1_VALOR*0.02
	Endif

Return(StrZero(nValor,13))



User Function LINHADG

	_cLinha	:= SUBSTR(SE2->E2_CODBAR,5,5)+SUBSTR(SE2->E2_CODBAR,11,10)+SUBSTR(SE2->E2_CODBAR,22,10)

	return(_cLinha)

	#INCLUDE "Protheus.ch"
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//Funcão para retornar o codigo referente a forma de pagamento ||
//
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//

user function cccod

	Local cRet    := ""
	Local cModelo := ""
	Local cPref   := SE2->E2_PREFIXO
	Local cNum    := SE2->E2_NUM
	Local cParc   := SE2->E2_PARCELA
	Local cBord   := SE2->E2_NUMBOR
	
	cModelo := POSICIONE("SEA",1,XFILIAL("SEA")+cBord+cPref+cNum+cParc,"EA_MODELO")

	IF      ALLTRIM(cModelo)=="01"
		cRet    := "000"
	ElseIF ALLTRIM(cModelo)=="05"
		cRet    := "000"
	ElseIF ALLTRIM(cModelo)=="03"
		cRet    := "700"
	Else
		cRet    := "018"
	EndIf

	return cRet

	#INCLUDE "Protheus.ch"

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//Funcão para liberar a entrada no Seguimento A                ||
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//

User Function SEG_A

	Local lRet    := .F.
	Local cModelo := ""
	Local cPref   := SE2->E2_PREFIXO
	Local cNum    := SE2->E2_NUM
	Local cParc   := SE2->E2_PARCELA
	Local cBord   := SE2->E2_NUMBOR

	cModelo := POSICIONE("SEA",1,XFILIAL("SEA")+cBord+cPref+cNum+cParc,"EA_MODELO")

	IF     ALLTRIM(cModelo)=="01"
		lRet :=  .T.

	ElseIf ALLTRIM(cModelo)=="03"
		lRet :=  .T.

	ElseIf ALLTRIM(cModelo)=="05"
		lRet :=  .T.

	ElseIf ALLTRIM(cModelo)=="41"
		lRet :=  .T.

	ElseIf ALLTRIM(cModelo)=="43"
		lRet :=  .T.
	Else
		lRet :=  .F.
	EndIf

return lRet

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//Funcão para liberar a entrada no Seguimento J                ||
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//

User Function SEG_J

	Local lRet    := ""
	Local cModelo := ""
	Local cPref   := SE2->E2_PREFIXO
	Local cNum    := SE2->E2_NUM
	Local cParc   := SE2->E2_PARCELA
	Local cBord   := SE2->E2_NUMBOR

	cModelo := POSICIONE("SEA",1,XFILIAL("SEA")+cBord+cPref+cNum+cParc,"EA_MODELO")

	IF     ALLTRIM(cModelo)=="30"
		lRet :=  .T.

	ElseIf ALLTRIM(cModelo)=="31"
		lRet :=  .T.

	Else
		lRet :=  .F.

	EndIf
return lRet

User Function TotTrailer

	Local lRet    := ""
	Local cNum    := SE2->E2_NUM
	Local cBord   := SE2->E2_NUMBOR

return lret



#Include "Protheus.ch"
#Include "ParmType.ch"
/*
**Retorna a chave da nota fical
**
*/
User Function CHAVENF()

	Local cChave := Posicione("SF2", 1, xFilial("SF2") + SE1->E1_NUM + SE1->E1_PREFIXO, "SF2->F2_CHVNFE")

Return cChave


/*
**Formata titulo removendo zeros a esquerda mantendo a parcela com duas casas numéricas
*/
USER FUNCTION FormatTit(prefixo,numero,parcela)
	local _pref		:= Val(prefixo)
	local _num		:= val(numero)
	local _parcela	:= u_ConvParc(parcela)
	local _tit		:= ALLTRIM(STR(_pref))+ALLTRIM(STR(_num))
	local titulo	:= STRZERO(val(_tit),8)+_parcela	
return(titulo)

USER FUNCTION FormatT2(prefixo,numero,parcela,tamanho)
	local _pref		:= Val(prefixo)
	local _num		:= val(numero)
	local _parcela	:= u_ConvParc(parcela)
	local _tit		:= ALLTRIM(STR(_pref))+ALLTRIM(STR(_num))+_parcela
	local titulo	:= STRZERO(val(_tit),tamanho)	
return(titulo)

/*
** CONVERTE A PARCELA ALFA NUMÉRICA PARA NUMÉRICA TEXTO
*/
user function ConvParc(parcela)
	local tabela:={}
	parcela:=ALLTRIM(parcela)

	
	AADD(TABELA,{"A",	"10"})
	AADD(TABELA,{"B",	"11"})
	AADD(TABELA,{"C",	"12"})
	AADD(TABELA,{"D",	"13"})
	AADD(TABELA,{"E",	"14"})
	AADD(TABELA,{"F",	"15"})
	AADD(TABELA,{"G",	"16"})
	AADD(TABELA,{"H",	"17"})
	AADD(TABELA,{"I",	"18"})
	AADD(TABELA,{"J",	"19"})
	AADD(TABELA,{"K",	"20"})
	AADD(TABELA,{"L",	"21"})
	AADD(TABELA,{"M",	"22"})
	AADD(TABELA,{"N",	"23"})
	AADD(TABELA,{"O",	"24"})
	AADD(TABELA,{"P",	"25"})
	AADD(TABELA,{"Q",	"26"})
	AADD(TABELA,{"R",	"27"})
	AADD(TABELA,{"S",	"28"})
	AADD(TABELA,{"T",	"29"})
	AADD(TABELA,{"U",	"30"})
	AADD(TABELA,{"W",	"31"})
	AADD(TABELA,{"V",	"32"})
	AADD(TABELA,{"X",	"33"})
	AADD(TABELA,{"Y",	"34"})
	AADD(TABELA,{"Z",	"35"})
	AADD(TABELA,{"a",	"36"})
	AADD(TABELA,{"b",	"37"})
	AADD(TABELA,{"c",	"38"})
	AADD(TABELA,{"d",	"39"})
	AADD(TABELA,{"e",	"40"})
	AADD(TABELA,{"f",	"41"})
	AADD(TABELA,{"g",	"42"})
	AADD(TABELA,{"h",	"43"})
	AADD(TABELA,{"i",	"44"})
	AADD(TABELA,{"j",	"45"})
	AADD(TABELA,{"k",	"46"})
	AADD(TABELA,{"l",	"47"})
	AADD(TABELA,{"m",	"48"})
	AADD(TABELA,{"n",	"49"})
	AADD(TABELA,{"o",	"50"})
	AADD(TABELA,{"p",	"51"})
	AADD(TABELA,{"q",	"52"})
	AADD(TABELA,{"r",	"53"})
	AADD(TABELA,{"s",	"54"})
	AADD(TABELA,{"t",	"55"})
	AADD(TABELA,{"u",	"56"})
	AADD(TABELA,{"w",	"57"})
	AADD(TABELA,{"v",	"58"})
	AADD(TABELA,{"x",	"59"})
	AADD(TABELA,{"y",	"60"})
	AADD(TABELA,{"z",	"61"})

	IF VAL(PARCELA)>0
		RETURN(STRZERO(VAL(PARCELA),2))
	ENDIF

	npos:=aScan(TABELA,{|X| X[1]==PARCELA})
	if npos>0
		return(STRZERO(VAL(TABELA[NPOS][2]),2))
	EndIf
return(PARCELA)

