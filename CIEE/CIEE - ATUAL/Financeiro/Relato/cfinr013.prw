#INCLUDE "rwmake.ch"
#Include "TopConn.ch"
#include "_FixSX.ch"
#INCLUDE "DelAlias.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CFINR013 º Autor ³ AP6 IDE            º Data ³  06/05/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Fluxo de  Creditos Nao Identificados          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Relatorio Especifico CIEE / Depto Financeiro               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CFINR013()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cDesc1 := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2 := "de Fluxo sobre Controle de Creditos Nao Identificados"
Private cDesc3 := "de acordo com os parametros informados pelo usuario."

Private titulo := "Total das Contribuicoes Ja Lancados no Fluxo de Caixa"
Private nLin   := 80

Private Cabec2:= "Data     | Tipo/Documento     | Depositante                    |          Valor | Documento       | No.  | Agencia                        | Identificacao |           B.A. |           C.I. |      Irregularidade | RDR          "
Private Cabec1:= "Banco Agencia Conta"
****          := "dd/mm/aa | tt-ttttttttttttttt | dddddddddddddddddddddddddddddd | vvvvvvvvvvvvvv | nnnnnnnnnnnnnnn | aaaa | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa | ii-iiiiiiiiii | bbbbbbbbbbbbbb | cccccccccccccc | iiiiiiiiiiiiii s | rrrrrrrrrrr  "
****          := "0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789"
****          := "0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21         "
****          := "0          11                   32                               65               82                100    107                              140             156              173              190            205 209
****          := "0        09                   30                               63               80                98     105                              138             154              171              188                207
****          := "00 09 11 30 32 63 65 80 82 98 100 105 107 138 140 154 156 171 173 188 190 205 207

Private imprime      := .T.
Private aOrd         := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132 //220
Private tamanho      := "M" //"G"
Private nomeprog     := StrTran(FunName(), "#", "")
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FINR13" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString      := "SZ5"
Private cPerg        := "FINR13    "
Private _nFL         := 0
Private _lPode       := .F.

Private _aAliases    := {}
Private _aMatriz     := {}

Private _aMeses      := {"Janeiro","Fevereiro","Marco","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01 - RDR                                         ³
//³ mv_par02 - Tipo         Sintetico/Analitico            ³
//³ mv_par03 - Gera Fluxo   Sim/Nao                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_aPerg := {}
AADD(_aPerg,{cPerg,"01","RDR                ?","","","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"02","Tipo               ?","","","mv_ch2","N",01,0,0,"C","","mv_par02","Analitico","","","","","Sintetico","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"03","Gera Fluxo         ?","","","mv_ch3","N",01,0,0,"C","","mv_par03","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","",""})

AjustaSX1(_aPerg)

Pergunte(cPerg, .F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  06/05/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

_xFilSZ8:= xFilial("SZ8")
_xFilSZF:= xFilial("SZF")

_cOrdem := " Z8_FILIAL, Z8_CONTA, Z8_BANCO, Z8_AGENCIA, Z8_EMISSAO, Z8_VALOR"
_cQuery := " SELECT *, ZF_REGISTR, ZF_FILIAL, ZF_RMU,ZF_CCONTA, SZ8.R_E_C_N_O_ REGSZ8 , ZF_XCOMPET" // Z8_BANCO, Z8_AGENCIA, Z8_CONTA, Z8_EMISSAO, Z8_TIPO, Z8_DEPOS, Z8_VALOR, Z8_NDOC, Z8_NAGE, Z8_IDENT, Z8_BA, Z8_CI, Z8_RDR, Z8_IR, Z8_IRTIP, Z8_IRRDR, SZ8.R_E_C_N_O_ REGSZ8"
_cQuery += " FROM "
_cQuery += RetSqlName("SZ8")+" SZ8, "
_cQuery += RetSqlName("SZF")+" SZF"
_cQuery += " WHERE '"+ _xFilSZ8 +"' = Z8_FILIAL"
_cQuery += " AND   '"+ _xFilSZF +"' = ZF_FILIAL" 
// _cQuery += " AND SZ8.R_E_C_N_O_ = CONVERT(INTEGER,ZF_REGISTR) "
_cQuery += " AND    Z8_REGISTR =  ZF_REGISTR  "
_cQuery += " AND    Z8_RDR     =  '"+mv_par01+"'"
_cQuery += " AND    ZF_RDR     =  '"+mv_par01+"'"
_cQuery += " AND    Z8_FECHA   =  'S'"
_cQuery += " AND    Z8_CI     <> 0  "

U_EndQuery( @_cQuery,_cOrdem, "QUERY", {"SZ8","SZF"},,,.T. )


/*
_cQuery += " AND    Z8_REGISTR =  ZF_REGISTR  "
_cQuery += " AND    Z8_RDR     =  '"+mv_par01+"'"
_cQuery += " AND    ZF_RDR     =  '"+mv_par01+"'"
*/



_aEstrut := {;
{"E5_DTDISPO" , "D", 08, 0},; // Z8_EMISSAO
{"E5_DOCUMEN" , "C", 15, 0},; // Z8_RDR
{"E5_TIPODOC" , "C", 02, 0},; // 'CI'
{"E5_MOEDA"   , "C", 02, 0},; // 'CI'
{"E5_BENEF"   , "C", 30, 0},; // 'Empresa Privada, Mista, Publica, Outras Contribuicoes'
{"E5_VALOR"   , "N", 17, 2},; // Z8_CI, ou ZF_VALOR
{"E5_RECONC"  , "C", 01, 0},; // 'x'
{"E5_NATUREZ" , "C", 10, 0},; // EV_NATUREZ
{"E5_RMUO"    , "C", 01, 0},; // 'A','B','C','D'
{"E5_REF "    , "C", 06, 0},; // ANO+MES
{"E5_DIA "    , "C", 02, 0},; // DIA Z8_FECRAT
{"E5_FECHA"   , "C", 01, 0},; // Z8_FECHA
{"E5_FLUSZ8"  , "C", 01, 0},; // Z8_FLUXO
{"E5_HISTOR"  , "C", 40, 0},;  // 'CNI RDR '+Z8_RDR 
{"E5_REGISTR" , "C", 15, 0},;
{"E5_XCOMPET" , "C", 7, 0}}  

// Cria o arquivo de trabalho.
_cArqTrab := CriaTrab(_aEstrut, .T.)
dbUseArea(.T., "DBFCDX", _cArqTrab, "TMP", .F., .F.)
// Cria o indice para o arquivo.
IndRegua("TMP", _cArqTrab, "E5_REF+E5_RMUO+E5_NATUREZ+STR(E5_VALOR,17,2)",,, "Criando indice...", .T.)
aAdd (_aAliases, {"TMP", _cArqTrab + ".DBF", _cArqTrab + OrdBagExt(), .T.})


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fluxo == "S"
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


dbSelectArea("QUERY")
dbGoTop()

While !Eof()
	
	dbSelectArea("TMP")
	RecLock("TMP", .T.)
//	TMP->E5_DTDISPO  := QUERY->Z8_EMISSAO  // Alterado poR Cris/CFB 08/06/04 - 09h18   
    TMP->E5_DTDISPO  := QUERY->Z8_FECRAT
     IF !EMPTY(QUERY->Z8_FECRAT) 
        QUERY->Z8_FECRAT
     ELSEIF MV_PAR03 == 1   
        MSGALERT("Nao Foi Realizado o Fechamento Contabil!!!")  
        QUERY->(DbClosearea())
        FechaAlias(_aAliases)
        Return
     ENDIF   
	TMP->E5_MOEDA    := "CI"
	TMP->E5_TIPODOC  := "CI"
	If QUERY->Z8_VALOR == QUERY->ZF_VALOR
		TMP->E5_VALOR := QUERY->Z8_CI
	Else
		If !Empty(QUERY->Z8_BA) .AND. ALLTRIM(QUERY->ZF_CCONTA) $ ALLTRIM(GETMV("MV_BACONTA")) 
            TMP->E5_VALOR := (QUERY->ZF_VALOR- QUERY->Z8_BA)
		Else		
			TMP->E5_VALOR := QUERY->ZF_VALOR
	    Endif
	EndIf
	TMP->E5_HISTOR   := "CNI RDR: "+QUERY->Z8_RDR
	TMP->E5_NATUREZ  := QUERY->ZF_NATUREZ
	If QUERY->Z8_FLUXO == "S"
		If Empty(QUERY->ZF_RMU)
			Do Case
				Case QUERY->Z8_RMU == "R"; TMP->E5_BENEF:= "Empresa Privada"; TMP->E5_RMUO := "A"
				Case QUERY->Z8_RMU == "M"; TMP->E5_BENEF:= "Empresa Mista"  ; TMP->E5_RMUO := "B"
				Case QUERY->Z8_RMU == "U"; TMP->E5_BENEF:= "Empresa Publica"; TMP->E5_RMUO := "C"
				Otherwise
					TMP->E5_BENEF := "Outras Contribuicoes"; TMP->E5_RMUO := "D"
			EndCase
		Else
			Do Case
				Case QUERY->ZF_RMU == "R"; TMP->E5_BENEF:= "Empresa Privada"; TMP->E5_RMUO := "A"
				Case QUERY->ZF_RMU == "M"; TMP->E5_BENEF:= "Empresa Mista  "; TMP->E5_RMUO := "B"
				Case QUERY->ZF_RMU == "U"; TMP->E5_BENEF:= "Empresa Publica"; TMP->E5_RMUO := "C"
				Case QUERY->ZF_RMU == "D"; TMP->E5_BENEF:= "Despesa        "; TMP->E5_RMUO := "E"
				Otherwise
					TMP->E5_BENEF := "Outras Contribuicoes"; TMP->E5_RMUO := "D"
			EndCase
		EndIf
	Else
		Do Case
			Case QUERY->ZF_RMU == "R"; TMP->E5_BENEF:= "Empresa Privada"; TMP->E5_RMUO := "A"
  		    Case QUERY->ZF_RMU == "M"; TMP->E5_BENEF:= "Empresa Mista  "; TMP->E5_RMUO := "B"
			Case QUERY->ZF_RMU == "U"; TMP->E5_BENEF:= "Empresa Publica"; TMP->E5_RMUO := "C"
			Case QUERY->ZF_RMU == "D"; TMP->E5_BENEF:= "Despesa        "; TMP->E5_RMUO := "E"
			Otherwise
				TMP->E5_BENEF := "Outras Contribuicoes"; TMP->E5_RMUO := "D"
		EndCase
	EndIf
	
	TMP->E5_DOCUMEN  := QUERY->Z8_RDR
	TMP->E5_FECHA    := QUERY->Z8_FECHA
	TMP->E5_FLUSZ8   := QUERY->Z8_FLUXO
	TMP->E5_REF      := LEFT(DTOS(QUERY->Z8_EMISSAO),6)
	TMP->E5_DIA      := RIGHT(DTOS(QUERY->Z8_FECRAT),2)
	TMP->E5_RECONC   := "x"
	TMP->E5_REGISTR := QUERY->Z8_REGISTR

	TMP->E5_XCOMPET	:= QUERY->ZF_XCOMPET
	
	msUnLock()
	
	dbSelectArea("QUERY")
	dbSkip()
EndDo

nLin      := 80

_nTot_A   := 0
_nTot_B   := 0
_nTot_C   := 0
_nTot_D   := 0
_nTot_E   := 0


dbSelectArea("TMP")
dbGoTop()

If mv_par02==1
	titulo := titulo + " - Analitico - RDR: "+ALlTrim(mv_par01)
Else
	titulo := titulo + " - Sintetico - RDR: "+ALlTrim(mv_par01)
EndIf

While !EOF()
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 65
		Cabec1:= " "
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 6
	Endif
	
	@ nLin, 000 PSay Replicate("-", 37); nLin++
	@ nLin, 000 PSay RIGHT(TMP->E5_REF,2)+"/"+LEFT(TMP->E5_REF,4)+" - "+_aMeses[Val(RIGHT(TMP->E5_REF,2))]; nLin++
	@ nLin, 000 PSay Replicate("-", 37); nLin++ ; nLin++
	
	_cREF  := TMP->E5_REF
	_nTotalZao:=0
	
	While !EOF() .And. _cREF == TMP->E5_REF
		
		If !(TMP->E5_RMUO $ "ABCDE")
			dbSkip()
			Loop
		EndIf
		
		_cRMUO := TMP->E5_RMUO
		_cNat  := TMP->E5_NATUREZ
		
		While !EOF() .And. 	_cREF+_cRMUO == TMP->E5_REF+TMP->E5_RMUO
			
			If TMP->E5_FLUSZ8 <> "S"
				dbSkip()
				Loop
			EndIf
			
			If nLin > 65
				Cabec1:= " "
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 6
			Endif
			
			Do Case
				Case TMP->E5_RMUO =="A"
					_nTot_A += TMP->E5_VALOR
				Case TMP->E5_RMUO =="B"
					_nTot_B += TMP->E5_VALOR
				Case TMP->E5_RMUO =="C"
					_nTot_C += TMP->E5_VALOR
				Case TMP->E5_RMUO =="E"
					_nTot_E += TMP->E5_VALOR
				Otherwise
					_nTot_D += TMP->E5_VALOR
			EndCase
			
			If mv_par02==1
				@ nLin, 000 PSay TMP->E5_NATUREZ
				@ nLin, 023 PSay TMP->E5_VALOR Picture "@E 999,999,999.99"
				nLin ++
			EndIf
			
			dbSelectArea("TMP")
			dbSkip()
			
		EndDo
		
		If nLin > 65
			Cabec1:= " "
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 6
		Endif
		
		Do Case
			Case _cRMUO =="A"
				If mv_par02==1 .And._nTot_A<>0
					@nLin, 023 PSay Replicate("-", 14); nLin++
				EndIf
				
				@ nLin, 000 PSay "Empresa Privada  (R): "
				@ nLin, 023 PSay _nTot_A Picture "@E 999,999,999.99"
				
				_nTotalZao+=_nTot_A
				_nPos := aScan( _aMatriz,{|x| AllTrim(x[1]) == _cREF })
				If _nPos == 0
					aAdd(_aMatriz,{_cREF,_nTot_A,0,0,0,0})
				Else
					_aMatriz[_nPos,2]:=_aMatriz[_nPos,2]+_nTot_A
				EndIf
				_nTot_A := 0
				
			Case _cRMUO =="B"
				If mv_par02==1 .And._nTot_B<>0
					@nLin, 023 PSay Replicate("-", 14); nLin++
				EndIf
				
				@ nLin, 000 PSay "Empresa Mista    (M): "
				@ nLin, 023 PSay _nTot_B Picture "@E 999,999,999.99"
				
				_nTotalZao+=_nTot_B
				_nPos := aScan( _aMatriz,{|x| AllTrim(x[1]) == _cREF })
				If _nPos == 0
					aAdd(_aMatriz,{_cREF,0,_nTot_B,0,0,0})
				Else
					_aMatriz[_nPos,3]:=_aMatriz[_nPos,3]+_nTot_B
				EndIf
				_nTot_B := 0
				
			Case _cRMUO =="C"
				If mv_par02==1 .And._nTot_C<>0
					@nLin, 023 PSay Replicate("-", 14); nLin++
				EndIf
				
				@ nLin, 000 PSay "Empresa Publica  (P): "
				@ nLin, 023 PSay _nTot_C Picture "@E 999,999,999.99"
				
				_nTotalZao+=_nTot_C
				_nPos := aScan( _aMatriz,{|x| AllTrim(x[1]) == _cREF })
				If _nPos == 0
					aAdd(_aMatriz,{_cREF,0,0,_nTot_C,0,0})
				Else
					_aMatriz[_nPos,4]:=_aMatriz[_nPos,4]+_nTot_C
				EndIf
				_nTot_C := 0
				
			Case _cRMUO =="E"
				If mv_par02==1 .And._nTot_E<>0
					@nLin, 023 PSay Replicate("-", 14); nLin++
				EndIf
				
				@ nLin, 000 PSay "Despesas            : "
				@ nLin, 023 PSay _nTot_E Picture "@E 999,999,999.99"
				
				_nTotalZao+=_nTot_E
				_nPos := aScan( _aMatriz,{|x| AllTrim(x[1]) == _cREF })
				If _nPos == 0
					aAdd(_aMatriz,{_cREF,0,0,0,0,_nTot_E})
				Else
					_aMatriz[_nPos,6]:=_aMatriz[_nPos,6]+_nTot_E
				EndIf
				_nTot_E := 0
				
			Otherwise
				If mv_par02==1 .And._nTot_D<>0
					@nLin, 023 PSay Replicate("-", 14); nLin++
				EndIf
				
				@ nLin, 000 PSay "Outras Contribuicoes: "
				@ nLin, 023 PSay _nTot_D Picture "@E 999,999,999.99"
				
				_nTotalZao+=_nTot_D
				_nPos := aScan( _aMatriz,{|x| AllTrim(x[1]) == _cREF })
				If _nPos == 0
					aAdd(_aMatriz,{_cREF,0,0,0,_nTot_D,0})
				Else
					_aMatriz[_nPos,5]:=_aMatriz[_nPos,5]+_nTot_D
				EndIf
				_nTot_D := 0
				
		EndCase
		
		nLin ++
		nLin ++
	EndDo
	
	@ nLin, 000 PSay "Total - "+_aMeses[Val(RIGHT(_cREF,2))]
	@ nLin, 023 PSay _nTotalZao Picture "@E 999,999,999.99"
	nLin ++
	nLin ++
	
EndDo



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fluxo <> "S"
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nLin      := 80

_nTot_A   := 0
_nTot_B   := 0
_nTot_C   := 0
_nTot_D   := 0
_nTot_E   := 0


dbSelectArea("TMP")
dbGoTop()

titulo := "Total das Contribuicoes Para Lancamentos no Fluxo de Caixa"

If mv_par02==1
	titulo := titulo + " - Analitico - RDR: "+ALlTrim(mv_par01)
Else
	titulo := titulo + " - Sintetico - RDR: "+ALlTrim(mv_par01)
EndIf

While !EOF()
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 65
		Cabec1:= " "
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 6
	Endif
	
	@ nLin, 000 PSay Replicate("-", 37); nLin++
	@ nLin, 000 PSay RIGHT(TMP->E5_REF,2)+"/"+LEFT(TMP->E5_REF,4)+" - "+_aMeses[Val(RIGHT(TMP->E5_REF,2))]; nLin++
	@ nLin, 000 PSay Replicate("-", 37); nLin++ ; nLin++
	
	_cREF     := TMP->E5_REF
	_nTotalZao:=0
	_cLanc    := "/"+RIGHT(TMP->E5_REF,2)+"/"+SubsTr(TMP->E5_REF,3,2) // Lançamento Fluxo SE5
	
	While !EOF() .And. _cREF == TMP->E5_REF
		
		_cRMUO := TMP->E5_RMUO
		_cNat  := TMP->E5_NATUREZ
		_cDia  := TMP->E5_DIA
		_cRegistr := TMP->E5_REGISTR
        _cNumero  := TMP->E5_DOCUMEN                     
        _cHistor   := TMP->E5_HISTOR
        _cDTDispo  := TMP->E5_DTDISPO 
		While !EOF() .And. 	_cREF+_cRMUO == TMP->E5_REF+TMP->E5_RMUO
		
			If TMP->E5_FLUSZ8 == "S"
				dbSkip()
				Loop
			EndIf
			If nLin > 65
				Cabec1:= " "
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 6
			Endif
			
			Do Case
				Case TMP->E5_RMUO =="A"
					_nTot_A += TMP->E5_VALOR
				Case TMP->E5_RMUO =="B"
					_nTot_B += TMP->E5_VALOR
				Case TMP->E5_RMUO =="C"
					_nTot_C += TMP->E5_VALOR
				Case TMP->E5_RMUO =="E"
					_nTot_E += TMP->E5_VALOR
				Otherwise
					_nTot_D += TMP->E5_VALOR
			EndCase
			
			If mv_par02==1
				@ nLin, 000 PSay TMP->E5_NATUREZ
				@ nLin, 023 PSay TMP->E5_VALOR Picture "@E 999,999,999.99"
				nLin ++
			EndIf
			
			
			If mv_par03==1 .And. TMP->E5_RMUO == "D" .And. TMP->E5_VALOR <> 0 // Lançamento Fluxo SE5Outras Contribuições
				_dLanc:=CTOD(TMP->E5_DIA+_cLanc)
                SZ8SE5(TMP->E5_VALOR, TMP->E5_NATUREZ, TMP->E5_HISTOR, _dLanc, TMP->E5_DOCUMEN,"Outras Contribuicoes",TMP->E5_DTDISPO,"R",_cRegistr, TMP->E5_XCOMPET )
			EndIf
//        	If mv_par03==1 .And. TMP->E5_RMUO == "E" .And. TMP->E5_VALOR <> 0
//				_dLanc:=CTOD(_cDia+_cLanc)
//				SZ8SE5(_nTot_E, TMP->E5_NATUREZ, TMP->E5_HISTOR, _dLanc, TMP->E5_DOCUMEN, "Despesa",TMP->E5_DTDISPO,"D",_cRegistr)
//			EndIf

			dbSelectArea("TMP")
			dbSkip()
			
		EndDo
		
		If nLin > 65
			Cabec1:= " "
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 6
		Endif
		
		Do Case
			Case _cRMUO =="A"
				If mv_par02==1 .And._nTot_A<>0
					@nLin, 023 PSay Replicate("-", 14); nLin++
				EndIf
				
				@ nLin, 000 PSay "Empresa Privada  (R): "
				@ nLin, 023 PSay _nTot_A Picture "@E 999,999,999.99"
				
				_nTotalZao+=_nTot_A
				If mv_par03==1 .And. _nTot_A <> 0// Lançamento Fluxo SE5
					_dLanc:=CTOD(_cDia+_cLanc)
					SZ8SE5(_nTot_A, _cNat, _cHistor, _dLanc, _cNumero, "Empresa Privada  (R)",_cDTDispo,"R",_cRegistr, TMP->E5_XCOMPET )
					dbSelectArea("TMP")
				EndIf
				_nPos := aScan( _aMatriz,{|x| AllTrim(x[1]) == _cREF })
				If _nPos == 0
					aAdd(_aMatriz,{_cREF,_nTot_A,0,0,0,0})
				Else
					_aMatriz[_nPos,2]:=_aMatriz[_nPos,2]+_nTot_A
				EndIf
				_nTot_A := 0
				
			Case _cRMUO =="B"
				If mv_par02==1 .And._nTot_B<>0
					@nLin, 023 PSay Replicate("-", 14); nLin++
				EndIf
				
				@ nLin, 000 PSay "Empresa Mista    (M): "
				@ nLin, 023 PSay _nTot_B Picture "@E 999,999,999.99"
				
				_nTotalZao+=_nTot_B
				If mv_par03==1 .And. _nTot_B <> 0// Lançamento Fluxo SE5
					_dLanc:=CTOD(_cDia+_cLanc)
					SZ8SE5(_nTot_B, _cNat, _cHistor, _dLanc, _cNumero, "Empresa Mista    (M)",_cDTDispo,"R",_cRegistr, TMP->E5_XCOMPET )
					dbSelectArea("TMP")
				EndIf
				_nPos := aScan( _aMatriz,{|x| AllTrim(x[1]) == _cREF })
				If _nPos == 0
					aAdd(_aMatriz,{_cREF,0,_nTot_B,0,0,0})
				Else
					_aMatriz[_nPos,3]:=_aMatriz[_nPos,3]+_nTot_B
				EndIf
				_nTot_B := 0
				
			Case _cRMUO =="C"
				If mv_par02==1 .And._nTot_C<>0
					@nLin, 023 PSay Replicate("-", 14); nLin++
				EndIf
				
				@ nLin, 000 PSay "Empresa Publica  (U): "
				@ nLin, 023 PSay _nTot_C Picture "@E 999,999,999.99"
				
				_nTotalZao+=_nTot_C
				/*
				IF _nTot_C = 6956.00
				   SET DEVICE TO SCREEN
				   MSGSTOP("Valor  "+str(_nTot_C,6,2) )
				   SET PRINTER TO
				ENDIF
				*/
				If mv_par03==1 .And. _nTot_C <> 0// Lançamento Fluxo SE5
					_dLanc:=CTOD(_cDia+_cLanc)
					SZ8SE5(_nTot_C, _cNat, _cHistor, _dLanc, _cNumero, "Empresa Publica  (U)",_cDTDispo,"R",_cRegistr, TMP->E5_XCOMPET )
					dbSelectArea("TMP")
				EndIf
				_nPos := aScan( _aMatriz,{|x| AllTrim(x[1]) == _cREF })
				If _nPos == 0
					aAdd(_aMatriz,{_cREF,0,0,_nTot_C,0,0})
				Else
					_aMatriz[_nPos,4]:=_aMatriz[_nPos,4]+_nTot_C
				EndIf
				_nTot_C := 0
				
			Case _cRMUO =="E"
				If mv_par02==1 .And._nTot_E<>0
					@nLin, 023 PSay Replicate("-", 14); nLin++
				EndIf
				
				@ nLin, 000 PSay "Despesa             : "
				@ nLin, 023 PSay _nTot_E Picture "@E 999,999,999.99"
				
				_nTotalZao-=_nTot_E
				_nPos := aScan( _aMatriz,{|x| AllTrim(x[1]) == _cREF })

            	If mv_par03==1 .And. _nTot_E <> 0// Lançamento Fluxo SE5 - Alterado por CFB 28/06/04 16H47
					_dLanc:=CTOD(_cDia+_cLanc)
					SZ8SE5(_nTot_E, _cNat, _cHistor, _dLanc, _cNumero, "Despesa",_cDTDispo,"P",_cRegistr, TMP->E5_XCOMPET )
					dbSelectArea("TMP")
				EndIf

				If _nPos == 0
					aAdd(_aMatriz,{_cREF,0,0,0,0,_nTot_E})
				Else
					_aMatriz[_nPos,6]:=_aMatriz[_nPos,6]+_nTot_E
				EndIf
				_nTot_E := 0
				
			Otherwise
				If mv_par02==1 .And._nTot_D<>0
					@nLin, 023 PSay Replicate("-", 14); nLin++
				EndIf
				
				@ nLin, 000 PSay "Outras Contribuicoes: "
				@ nLin, 023 PSay _nTot_D Picture "@E 999,999,999.99"
				
				_nTotalZao+=_nTot_D
				_nPos := aScan( _aMatriz,{|x| AllTrim(x[1]) == _cREF })
				If _nPos == 0
					aAdd(_aMatriz,{_cREF,0,0,0,_nTot_D,0})
				Else
					_aMatriz[_nPos,5]:=_aMatriz[_nPos,5]+_nTot_D
				EndIf
				_nTot_D := 0
				
		EndCase
		
		nLin ++
		nLin ++
		If nLin > 65
			Cabec1:= " "
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 6
		Endif

	EndDo
	
	If nLin > 65
		Cabec1:= " "
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 6
	Endif

	@ nLin, 000 PSay "Total - "+_aMeses[Val(RIGHT(_cREF,2))]
	@ nLin, 023 PSay _nTotalZao Picture "@E 999,999,999.99"
	nLin ++
	nLin ++
	
	
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Total Geral registros em SZ8 com Fluxo == "S" + Fluxo <> "S"
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_nTot_A   := 0
_nTot_B   := 0
_nTot_C   := 0
_nTot_D   := 0
_nTot_E   := 0

titulo := "Total Geral das Contribuicoes"

If mv_par02==1
	titulo := titulo + " - Analitico - RDR: "+ALlTrim(mv_par01)
Else
	titulo := titulo + " - Sintetico - RDR: "+ALlTrim(mv_par01)
EndIf

Cabec1:= " "
Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
nLin := 6

_nTotalGeral:=0
For _nI:=1 to Len(_aMatriz)
	
	@ nLin, 000 PSay Replicate("-", 37); nLin++
	@ nLin, 000 PSay RIGHT(_aMatriz[_nI,1],2)+"/"+LEFT(_aMatriz[_nI,1],4)+" - "+_aMeses[Val(RIGHT(_aMatriz[_nI,1],2))]; nLin++
	@ nLin, 000 PSay Replicate("-", 37); nLin++ ; nLin++
	
	@ nLin, 000 PSay "Empresa Privada  (R): "
	@ nLin, 023 PSay _aMatriz[_nI,2] Picture "@E 999,999,999.99"
	nLin ++
	nLin ++

 	If nLin > 65
		Cabec1:= " "
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 6
	Endif
	
	@ nLin, 000 PSay "Empresa Mista    (M): "
	@ nLin, 023 PSay _aMatriz[_nI,3] Picture "@E 999,999,999.99"
	nLin ++
	nLin ++

	If nLin > 65
		Cabec1:= " "
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 6
	Endif
	
	@ nLin, 000 PSay "Empresa Publica  (P): "
	@ nLin, 023 PSay _aMatriz[_nI,4] Picture "@E 999,999,999.99"
	nLin ++
	nLin ++

	If nLin > 65
		Cabec1:= " "
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 6
	Endif
	
	@ nLin, 000 PSay "Outras Contribuicoes: "
	@ nLin, 023 PSay _aMatriz[_nI,5] Picture "@E 999,999,999.99"
	nLin ++
	nLin ++

	If nLin > 65
		Cabec1:= " "
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 6
	Endif
	
	@ nLin, 000 PSay "Despesas            : "
	@ nLin, 023 PSay _aMatriz[_nI,6] Picture "@E 999,999,999.99"
	nLin ++
	nLin ++
	
	If nLin > 65
		Cabec1:= " "
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 6
	Endif
	
	@ nLin, 000 PSay "Total - "+_aMeses[Val(RIGHT(_aMatriz[_nI,1],2))]
	@ nLin, 023 PSay _aMatriz[_nI,2]+_aMatriz[_nI,3]+_aMatriz[_nI,4]+_aMatriz[_nI,5]-_aMatriz[_nI,6] Picture "@E 999,999,999.99"
	nLin ++
	nLin ++
	
	If nLin > 65
		Cabec1:= " "
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 6
	Endif
	
	_nTotalGeral:=_nTotalGeral+_aMatriz[_nI,2]+_aMatriz[_nI,3]+_aMatriz[_nI,4]+_aMatriz[_nI,5]-_aMatriz[_nI,6]
	
Next _nI

nLin ++

If nLin > 65
	Cabec1:= " "
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 6                                                             	
Endif

@ nLin, 000 PSay Replicate("-", 37); nLin++
@ nLin, 000 PSay "Total Contribuicoes :"
@ nLin, 023 PSay _nTotalGeral Picture "@E 999,999,999.99" ; nLin++
@ nLin, 000 PSay Replicate("-", 37)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("QUERY")
dbCloseArea()

FechaAlias(_aAliases)


SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()


Return


//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±±ºPrograma  ³ SZ8SE5   ºAutor  ³ Andy Pudja         º Data ³  17/01/03   º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±

Static Function SZ8SE5(_nValor, _cNature, _cHistor,_dCREDITO, _cRDR, _cPresta,_dtDispo,_DebCre, _cRegistr, _cXCompet)

// Verifica se as variaveis foram passadas por parametro.
// Se nao foram, assumir o valor zero.
dbSelectArea("SE5")
dbSetOrder(7) // Alterado para Verificar o Indice 4 - Filial+Natureza+Prefixo+Numero   // CFB 24/06/04 12h27
//If !dbSeek(xFilial("SE5")+"CI "+AllTrim(_cRDR)+_cNature+_dtDispo+_cRegistr .F.) .Or. _lPode
 If !dbSeek(xFilial("SE5")+"CI "+AllTrim(_cRDR), .F.) .Or. _lPode  // Alterado CFB 24/06/04 12h27
	_lPode := .T.
	RecLock("SE5", .T.)
	SE5->E5_FILIAL  := xFilial("SE5")
	SE5->E5_MOEDA   := "CI"
	SE5->E5_TIPODOC := "CI"
//	SE5->E5_RECPAG  := "R"
    SE5->E5_RECPAG  := _DebCre
	SE5->E5_DATA    := _dCREDITO
	SE5->E5_VENCTO  := _dCREDITO
	SE5->E5_NUMERO  := _cRDR   // _cE2Num
	SE5->E5_PREFIXO := "CI"   // _cE2Pref
	SE5->E5_TIPO    := ""     // _cE2Tipo
	SE5->E5_VALOR   := _nValor
	SE5->E5_NATUREZ := _cNature // NATUREZA
	SE5->E5_HISTOR  := _cHistor
	SE5->E5_LA      := "N"
	SE5->E5_CLIFOR  :=	"DEBAUT"
	SE5->E5_DTDIGIT := _dCREDITO
	SE5->E5_MOTBX   := "NOR"
	SE5->E5_RECONC  := "x"  // Já reconciliado
	SE5->E5_SEQ     := "01"
	// SE5->E5_DTDISPO := _dCREDITO // Alterado por CFB 08/06/04 10h17
	SE5->E5_DTDISPO := _dtDispo
	SE5->E5_DOCUMEN := _cRDR
	SE5->E5_BENEF   := _cPresta
//  SE5->E5_REGISTR := _cRegistr

    SE5->E5_XCOMPET := _cXCompet
	SE5->(msUnLock())
EndIf
Return

