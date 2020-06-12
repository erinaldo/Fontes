#INCLUDE "rwmake.ch"
#Include "TopConn.ch"

//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CFINR01
Relatorio de Controle de Creditos Nao Identificados 
@author     Totvs
@since     	06/05/03 
@version  	P.11      
@param 		Nenhum
@return    	Nenhum
@obs        Relatorio Especifico CIEE - Depto Financeiro
Altera็๕es Realizadas desde a Estrutura็ใo Inicial
------------+-----------------+----------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                                                                                 
------------+-----------------+----------------------------------------------------------
			|                 |  
------------+-----------------+----------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
User Function CFINR01()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private cDesc1 := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2 := "sobre Controle de Creditos Nao Identificados"
Private cDesc3 := "de acordo com os parametros informados pelo usuario."

Private titulo := "Controle de Creditos Nao Identificados"
Private nLin   := 80
Private Cabec2:= ""
Private Cabec1:= "Banco Agencia Conta"
****          := "dd/mm/aa | tt-ttttttttttttttt | dddddddddddddddddddddddddddddd | vvvvvvvvvvvvvv | nnnnnnnnnnnnnnn | aaaa | aaa                                                                                                          aaaaaaaaaaaaaaaaaaaaaaaaaaa | ii-iiiiiiiiii | bbbbbbbbbbbbbb | cccccccccccccc | iiiiiiiiiiiiii s | rrrrrrrrrrr  "
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
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := StrTran(FunName(), "#", "")
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "CFINR01" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString      := "SZ8"
Private cPerg        := "CFINR01    "
Private _nFL         := 0


C6R01SX1(cPerg)
IF Pergunte(cPerg, .T.)

	If mv_par19 == 1
		Cabec2:= "Data     | Tipo/Documento         | Depositante                              |          Valor | Documento       | Receita  | Observa็ใo"	
		cDesc1 := "Prezado,"
		cDesc2 := "Segue em anexo relat๓rio de cr้ditos pendentes que estใo aguardando regulariza็ใo."	
	else
		Cabec2:= "Data     | Tipo/Documento         | Depositante                              |          Valor | Documento       | Unid | Convenio            	| Identificacao |           B.A. |           C.I. |  Irregularidade | RDR          "
	endif	
	
	//wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.T.)
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)
	
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
	
	Titulo := Alltrim(Titulo)+" "+ LEFT(SM0->M0_NOME,AT("-",SM0->M0_NOME)-1) +" / "+SM0->M0_ESTENT				
	If mv_par15 == 1
		titulo := titulo + " - Fluxo"
	ElseIf mv_par15 == 2
		titulo := titulo + " - Nใo Fluxo"
	EndIf  
	
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)  
	
ENDIF

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  06/05/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local _nBcoG_V := 0
Local _nBcoG_B := 0
Local _nBcoG_C := 0
Local _nBcoG_I := 0
Local _nContCre := 0 
LOCAL cTab		:= GetNextAlias()

nLin:= 80

_cQuery := " SELECT Z8_BANCO, Z8_AGENCIA, Z8_CONTA, Z8_CONVEN, Z8_EMISSAO, Z8_TIPO, Z8_DEPOS, Z8_VALOR, "
_cQuery += " Z8_NDOC, Z8_NAGE, Z8_IDENT, Z8_BA, Z8_CI, Z8_RDR, Z8_IR, Z8_IRTIP, Z8_IRRDR, Z8_HIST, Z8_IMPFLAG, "
_cQuery += " Z8_UNIDADE, Z8_CONV,Z8_FLGRECE,Z8_OBSNOT "
_cQuery += " FROM "
_cQuery += RetSqlName("SZ8")+" SZ8"
_cQuery += " WHERE '"+ xFilial("SZ8") +"' = Z8_FILIAL"
_cQuery += " AND Z8_CONTA   BETWEEN '"+mv_par01      +"' AND '"+mv_par02+"' "
_cQuery += " AND Z8_EMISSAO BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"'"
_cQuery += " AND Z8_UNIDADE BETWEEN '"+mv_par17+"' AND '"+mv_par18+"' "
If mv_par05 == 1										// chamado 22123 alterado por CG em 23/01/07
	_cQuery += " AND Z8_DEPOS <> '' "
ElseIf mv_par05 == 2
	_cQuery += " AND Z8_DEPOS = '' "
EndIf	
_cQuery += " AND    Z8_IDENT   BETWEEN '"+mv_par06+"' AND '"+mv_par07+"' "
_cQuery += " AND    Z8_RDR     BETWEEN '"+mv_par08+"' AND '"+mv_par09+"' "
If mv_par10 == 1 						//aberto
	_cQuery += " AND Z8_RDR     = '' "
ElseIf mv_par10 == 2 					//fechado
	_cQuery += " AND Z8_RDR    <> '' "
ElseIf mv_par10 == 3 					//ambos
	If mv_PAR16 == 1 					//SIM
		_cQuery += " AND (Z8_RDR = '' OR ((Z8_RDR <> '' AND Z8_FECRAT = '') AND (SUBSTRING(Z8_RDR,1,2) <> 'AP'))) " //status (Sempre em aberto)
		//OBS: SUBSTRING(Z8_RDR,1,2) <> 'AP - este comando foi acrescentado para contemplar os registros que nao entram no fechamento de RDR (tipo transf.Bancaria) via cheque
		//alterado dia 25/05/10 pelo analista Emerson
	Elseif mv_PAR16 == 2 				//NAO
		_cQuery += " AND Z8_RDR = '' " //status (Sempre em aberto)
	EndIf
EndIf
If mv_par11 == 1
	_cQuery += " AND Z8_IR     <> 0 "
ElseIf mv_par11 == 2
	_cQuery += " AND Z8_IR      = 0 "
EndIf
If mv_par12 == 1
	_cQuery += " AND Z8_IRRDR   = '' "
ElseIf mv_par12 == 2
	_cQuery += " AND Z8_IRRDR  <> '' "
EndIf
_cQuery += " AND    Z8_IRTIP   BETWEEN '"+mv_par13+"' AND '"+mv_par14+"' "
If mv_par15 == 1
	_cQuery += " AND Z8_FLUXO   = 'S' "
ElseIf mv_par15 == 2
	_cQuery += " AND Z8_FLUXO   = ''  "
EndIf   

_cQuery += "ORDER BY Z8_FILIAL, Z8_CONTA, Z8_BANCO, Z8_AGENCIA, Z8_EMISSAO, Z8_VALOR"


TcQuery _cQuery NEW ALIAS (cTab)
TcSetField(cTab,"Z8_EMISSAO","D")
     
dbSelectArea(cTab)   

SetRegua(RecCount())

(cTab)->(dbGoTop())                               	
WHILE (cTab)->(!EOF())
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If !Empty((cTab)->Z8_CONVEN)
		Cabec1:= "Banco: "+ (cTab)->Z8_BANCO + " - Agencia: "+ (cTab)->Z8_AGENCIA + " / Conta: " + Alltrim((cTab)->Z8_CONTA) + " - " + (cTab)->Z8_CONVEN
	Else
		Cabec1:= "Banco: "+ (cTab)->Z8_BANCO + " - Agencia: "+ (cTab)->Z8_AGENCIA + " / Conta: " + Alltrim((cTab)->Z8_CONTA)
	EndIf	
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 9
	
	_cBanco      := (cTab)->Z8_BANCO
	_cAgencia    := (cTab)->Z8_AGENCIA
	_cConta      := (cTab)->Z8_CONTA
	
	_nDia_V := 0
	_nDia_B := 0
	_nDia_C := 0
	_nDia_I := 0
	
	_nBco_V    := 0
	_nBco_B    := 0
	_nBco_C    := 0
	_nBco_I    := 0
	_nContCre  := 0
	While (cTab)->(!EOF()) .And. 	_cConta+_cBanco+_cAgencia == (cTab)->Z8_CONTA+(cTab)->Z8_BANCO+(cTab)->Z8_AGENCIA
		
		If nLin > 65 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
			If !Empty((cTab)->Z8_CONVEN)
				Cabec1:= "Banco: "+ (cTab)->Z8_BANCO + " - Agencia: "+ (cTab)->Z8_AGENCIA + " / Conta: " + Alltrim((cTab)->Z8_CONTA) + " - " + (cTab)->Z8_CONVEN
			Else
				Cabec1:= "Banco: "+ (cTab)->Z8_BANCO + " - Agencia: "+ (cTab)->Z8_AGENCIA + " / Conta: " + Alltrim((cTab)->Z8_CONTA)
			EndIf	
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
		_dEmissao   := DTOS((cTab)->Z8_EMISSAO)
		_dEmis      := (cTab)->Z8_EMISSAO
		
		_nDia_V := 0
		_nDia_B := 0
		_nDia_C := 0
		_nDia_I := 0

/*        1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Data     | Tipo/Documento         | Depositante                              |          Valor | Documento       | No.  | Agencia              | Identificacao |           B.A. |           C.I. | Irregularidade | RDR          
99/99/99 | xxxxxxxxxxxxxxxxxxxxxx | xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx | 999,999,999.99 | 999999999999999 | 9999 | xxxxxxxxxxxxxxxxxxxx | xxxxxxxxxxxxx | 999,999,999.99 | 999,999,999.99 | 999,999,999.99 | 999999
*/                                                                                                                  
		
		While (cTab)->(!EOF()) .And. 	_cConta+_cBanco+_cAgencia+_dEmissao == (cTab)->Z8_CONTA+(cTab)->Z8_BANCO+(cTab)->Z8_AGENCIA+DTOS((cTab)->Z8_EMISSAO)
			
			If nLin > 65 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
				If !Empty((cTab)->Z8_CONVEN)
					Cabec1:= "Banco: "+ (cTab)->Z8_BANCO + " - Agencia: "+ (cTab)->Z8_AGENCIA + " / Conta: " + Alltrim((cTab)->Z8_CONTA) + " - " + (cTab)->Z8_CONVEN
				Else
					Cabec1:= "Banco: "+ (cTab)->Z8_BANCO + " - Agencia: "+ (cTab)->Z8_AGENCIA + " / Conta: " + Alltrim((cTab)->Z8_CONTA)
				EndIf	
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif

			@ nLin, 000 PSay (cTab)->Z8_EMISSAO
			@ nLin, 009 PSay "|"
			
			If	!Empty((cTab)->Z8_HIST) .and. (cTab)->Z8_IMPFLAG == "S"
				_cHist	:=	Substr(Alltrim((cTab)->Z8_HIST),1,25)
			Else
//				_cHist	:= (cTab)->Z8_TIPO+"-"+LEFT(POSICIONE("SZ9",2,xFilial("SZ9")+(cTab)->Z8_TIPO,"Z9_TIPO_D"),15)
				_cHist	:= LEFT(POSICIONE("SZ9",2,xFilial("SZ9")+(cTab)->Z8_TIPO,"Z9_TIPO_D"),25)
			EndIf
			
			@ nLin, 011 PSay _cHist
			@ nLin, 034 PSay "|"
			@ nLin, 036 PSay substr((cTab)->Z8_DEPOS,1,40) //Alterado dia 04/11/11 pelo analista Emerson. Neste dia foi alterado o campo de 40 para 80 posicoes
			@ nLin, 077 PSay "|"
			@ nLin, 079 PSay (cTab)->Z8_VALOR Picture "@E 999,999,999.99"
			@ nLin, 094 PSay "|"
			@ nLin, 096 PSay (cTab)->Z8_NDOC   
			
			If mv_par19 == 1
				@ nLin, 112 PSay "|"
				@ nLin, 114 PSay IIF ((cTab)->Z8_FLGRECE=="1","Sim","Nใo")
				@ nLin, 120 PSay "|"
				@ nLin, 122 PSay (cTab)->Z8_OBSNOT								 
			ELSE
				@ nLin, 112 PSay "|"
				@ nLin, 114 PSay (cTab)->Z8_UNIDADE		//Alterado dia 21/06 pelo analista Emerson. O campo (cTab)->Z8_NAGE era o conteudo anterior
				@ nLin, 119 PSay "|"
				@ nLin, 121 PSay (cTab)->Z8_CONV			//Alterado dia 21/06 pelo analista Emerson. O campo LEFT(POSICIONE("SZA",1,xFilial("SZA")+(cTab)->Z8_NAGE,"ZA_NAGE_D"),20) era o conteudo anterior
				@ nLin, 142 PSay "|"
				@ nLin, 144 PSay (cTab)->Z8_IDENT+"-"+LEFT(POSICIONE("SZB",1,xFilial("SZB")+(cTab)->Z8_IDENT,"ZB_IDENT_D"),10)
				@ nLin, 158 PSay "|"
				@ nLin, 160 PSay (cTab)->Z8_BA Picture "@E 999,999,999.99"
				@ nLin, 175 PSay "|"
				@ nLin, 177 PSay (cTab)->Z8_CI Picture "@E 999,999,999.99"
				@ nLin, 192 PSay "|"
				@ nLin, 194 PSay (cTab)->Z8_IR Picture "@E 999,999,999.99"
				//			@ nLin, 205 PSay (cTab)->Z8_IRTIP
				@ nLin, 210 PSay "|"
				@ nLin, 212 PSay (cTab)->Z8_RDR
				
				If mv_par11<>2 .And. (cTab)->Z8_IR<>0
					nLin ++
					@ nLin, 192 PSay "|"
					@ nLin, 194 PSay (cTab)->Z8_IR Picture "@E 999,999,999.99"
					If (cTab)->Z8_IRTIP == "B"
						@ nLin, 212 PSay "B.A."
					ElseIf (cTab)->Z8_IRTIP == "C"
						@ nLin, 212 PSay "C.I."
					ElseIf (cTab)->Z8_IRTIP == "D"
						@ nLin, 212 PSay "Dev."
					EndIf
					@ nLin, 214 PSay "|"
					@ nLin, 216 PSay (cTab)->Z8_IRRDR
					
					//		    	@ nLin, 205 PSay (cTab)->Z8_IRTIP
					//     			@ nLin, 207 PSay "|"
					//	    		@ nLin, 209 PSay (cTab)->Z8_IRRDR
					nLin ++
				EndIf
			EndIf
			_nContCre++
			_nDia_V := _nDia_V + (cTab)->Z8_VALOR
			_nDia_B := _nDia_B + (cTab)->Z8_BA
			_nDia_C := _nDia_C + (cTab)->Z8_CI
			_nDia_I := _nDia_I + (cTab)->Z8_IR
			
			_nBco_V := _nBco_V + (cTab)->Z8_VALOR
			_nBco_B := _nBco_B + (cTab)->Z8_BA
			_nBco_C := _nBco_C + (cTab)->Z8_CI
			_nBco_I := _nBco_I + (cTab)->Z8_IR
			
			_nBcoG_V := _nBcoG_V + (cTab)->Z8_VALOR
			_nBcoG_B := _nBcoG_B + (cTab)->Z8_BA
			_nBcoG_C := _nBcoG_C + (cTab)->Z8_CI
			_nBcoG_I := _nBcoG_I + (cTab)->Z8_IR
			
			dbSelectArea(cTab)
			(cTab)->(dbSkip())
			nLin ++
		EndDo
		
		nLin ++
		@ nLin, 000 PSay "T o t a l  D i a ==> "
//		@ nLin, 011 PSay _dEmis
		@ nLin, 077 PSay "|"
		@ nLin, 079 PSay _nDia_V Picture "@E 999,999,999.99" 
		
		If mv_par19 == 2					
			@ nLin, 094 PSay "|"
			@ nLin, 158 PSay "|"
			@ nLin, 160 PSay _nDia_B Picture "@E 999,999,999.99"
			@ nLin, 175 PSay "|"
			@ nLin, 177 PSay _nDia_C Picture "@E 999,999,999.99"
			@ nLin, 192 PSay "|"
			@ nLin, 194 PSay _nDia_I Picture "@E 999,999,999.99"
			@ nLin, 210 PSay "|"
		endif
		
		nLin ++
		nLin ++
//		nLin ++
	EndDo
	
	nLin ++
	@ nLin, 000 PSay "T o t a l  B a n c o  ==> "  //+_cBanco+"-"+_cAgencia+"/"+_cConta
	@ nLin, 077 PSay "|"
	@ nLin, 079 PSay _nBco_V Picture "@E 999,999,999.99"
	If mv_par19 == 2
		@ nLin, 094 PSay "|"
		@ nLin, 158 PSay "|"
		@ nLin, 160 PSay _nBco_B Picture "@E 999,999,999.99"
		@ nLin, 175 PSay "|"
		@ nLin, 177 PSay _nBco_C Picture "@E 999,999,999.99"
		@ nLin, 192 PSay "|"
		@ nLin, 194 PSay _nBco_I Picture "@E 999,999,999.99"
		@ nLin, 210 PSay "|"
	endif
	nLin ++
	nLin ++
	nLin ++
	@ nLin, 000 PSay "T o t a l  d e  C r e d i t o (s)  ==> " 
	@ nLin, 077 PSay "|"
	@ nLin, 079 PSay _nContCre Picture "@E 999,999,999"
	@ nLin, 094 PSay "|"
    nLin ++
	nLin ++
	
EndDo

If nLin > 65 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
	If !Empty((cTab)->Z8_CONVEN)
		Cabec1:= "Banco: "+ (cTab)->Z8_BANCO + " - Agencia: "+ (cTab)->Z8_AGENCIA + " / Conta: " + Alltrim((cTab)->Z8_CONTA) + " - " + (cTab)->Z8_CONVEN
	Else
		Cabec1:= "Banco: "+ (cTab)->Z8_BANCO + " - Agencia: "+ (cTab)->Z8_AGENCIA + " / Conta: " + Alltrim((cTab)->Z8_CONTA)
	EndIf	
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 9
Endif

nLin ++ 
@ nLin, 000 PSay Replicate("-",220)
nLin ++  
@ nLin, 000 PSay "T O T A L   G E R A L   B A N C O (S)  ==> " //+_cBanco+"-"+_cAgencia+"/"+_cConta
@ nLin, 077 PSay "|"
@ nLin, 079 PSay _nBcoG_V Picture "@E 999,999,999.99"

If mv_par19 == 2
	@ nLin, 094 PSay "|"
	@ nLin, 158 PSay "|"
	@ nLin, 160 PSay _nBcoG_B Picture "@E 999,999,999.99"
	@ nLin, 175 PSay "|"
	@ nLin, 177 PSay _nBcoG_C Picture "@E 999,999,999.99"
	@ nLin, 192 PSay "|"
	@ nLin, 194 PSay _nBcoG_I Picture "@E 999,999,999.99"
	@ nLin, 210 PSay "|"
endif

nLin ++
@ nLin, 000 PSay Replicate("-",220)
nLin ++  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea(cTab)
(cTab)->(dbCloseArea())

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C6R01SX1   บAutor  ณ Carlos Henrique	   บ Data ณ01/08/2014 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza parametros            				              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
STATIC FUNCTION C6R01SX1(cPerg)
Local aArea    	:= GetArea()
Local aAreaDic 	:= SX1->( GetArea() )
Local aEstrut  	:= {}
Local aStruDic 	:= SX1->( dbStruct() )
Local aDados	:= {}
Local nXa       := 0
Local nXb       := 0
Local nXc		:= 0
Local nTam1    	:= Len( SX1->X1_GRUPO )
Local nTam2    	:= Len( SX1->X1_ORDEM )
Local lAtuHelp 	:= .F.            
Local aHelp		:= {}	

aEstrut := { 'X1_GRUPO'  , 'X1_ORDEM'  , 'X1_PERGUNT', 'X1_PERSPA' , 'X1_PERENG' , 'X1_VARIAVL', 'X1_TIPO'   , ;
             'X1_TAMANHO', 'X1_DECIMAL', 'X1_PRESEL' , 'X1_GSC'    , 'X1_VALID'  , 'X1_VAR01'  , 'X1_DEF01'  , ;
             'X1_DEFSPA1', 'X1_DEFENG1', 'X1_CNT01'  , 'X1_VAR02'  , 'X1_DEF02'  , 'X1_DEFSPA2', 'X1_DEFENG2', ;
             'X1_CNT02'  , 'X1_VAR03'  , 'X1_DEF03'  , 'X1_DEFSPA3', 'X1_DEFENG3', 'X1_CNT03'  , 'X1_VAR04'  , ;
             'X1_DEF04'  , 'X1_DEFSPA4', 'X1_DEFENG4', 'X1_CNT04'  , 'X1_VAR05'  , 'X1_DEF05'  , 'X1_DEFSPA5', ;
             'X1_DEFENG5', 'X1_CNT05'  , 'X1_F3'     , 'X1_PYME'   , 'X1_GRPSXG' , 'X1_HELP'   , 'X1_PICTURE', ;
             'X1_IDFIL'   }

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ mv_par01 - Conta de                                    ณ
//ณ mv_par02 - Conta ate                                   ณ
//ณ mv_par03 - Emissao de                                  ณ
//ณ mv_par04 - Emissao ate                                 ณ
//ณ mv_par05 - Depositante Sim/Nao/Todos                   ณ chamado 22123 alterado por CG em 23/01/07
//ณ mv_par08 - Identificacao de                            ณ
//ณ mv_par09 - Identificacao ate                           ณ
//ณ mv_par08 - RDR de                                      ณ
//ณ mv_par09 - RDR ate                                     ณ
//ณ mv_par10 - Status Aberto/Fechado/Todos                 ณ
//ณ mv_par11 - Irregularidade Com/Sem/Todos                ณ
//ณ mv_par12 - Status Aberto/Fechado/Todos                 ณ
//ณ mv_par13 - Tipo Irregular de                           ณ
//ณ mv_par14 - Tipo Irregular ate                          ณ
//ณ mv_par15 - Fluxo                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

AADD(aDados,{cPerg,"01","Conta de           ?","","","mv_ch1","C",10,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","BZC","",""})
AADD(aDados,{cPerg,"02","Conta ate          ?","","","mv_ch2","C",10,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","BZC","",""})
AADD(aDados,{cPerg,"03","Data de            ?","","","mv_ch3","D",08,0,0,"G","","mv_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aDados,{cPerg,"04","Data ate           ?","","","mv_ch4","D",08,0,0,"G","","mv_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aDados,{cPerg,"05","Depositante        ?","","","mv_ch5","N",01,0,0,"C","","mv_par05","Sim","","","","","Nao","","","","","Todos","","","","","","","","","","","","","","","",""}) 
AADD(aDados,{cPerg,"06","Identificacao de   ?","","","mv_ch6","C",02,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","BZB","",""})
AADD(aDados,{cPerg,"07","Identificacao ate  ?","","","mv_ch7","C",02,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","BZB","",""})
AADD(aDados,{cPerg,"08","RDR de             ?","","","mv_ch8","C",15,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aDados,{cPerg,"09","RDR ate            ?","","","mv_ch9","C",15,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aDados,{cPerg,"10","Status             ?","","","mv_chA","N",01,0,0,"C","","mv_par10","Aberto s/RDR","","","","","Fechado c/RDR","","","","","Todos","","","","","","","","","","","","","","","",""})
AADD(aDados,{cPerg,"11","Irregularidade     ?","","","mv_chB","N",01,0,0,"C","","mv_par11","Sim","","","","","Nao","","","","","Todos","","","","","","","","","","","","","","","",""})
AADD(aDados,{cPerg,"12","Status Irregular.  ?","","","mv_chC","N",01,0,0,"C","","mv_par12","Aberto s/RDR","","","","","Fechado c/RDR","","","","","Todos","","","","","","","","","","","","","","","",""})
AADD(aDados,{cPerg,"13","Tipo Irregular. de ?","","","mv_chD","C",01,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aDados,{cPerg,"14","Tipo Irregular. ate?","","","mv_chE","C",01,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aDados,{cPerg,"15","Fluxo              ?","","","mv_chF","N",01,0,0,"C","","mv_par15","Sim","","","","","Nao","","","","","Todos","","","","","","","","","","","","","","","",""})
AADD(aDados,{cPerg,"16","Pend.c/RDR         ?","","","mv_chG","N",01,0,0,"C","","mv_par16","Sim","","","","","Nao","","","","","Todos","","","","","","","","","","","","","","","",""})
AADD(aDados,{cPerg,"17","Unidade De         ?","","","mv_chH","C",04,0,0,"G","","mv_par17","","","","","","","","","","","","","","","","","","","","","","","","","97","",""})
AADD(aDados,{cPerg,"18","Unidade Ate        ?","","","mv_chI","C",04,0,0,"G","","mv_par18","","","","","","","","","","","","","","","","","","","","","","","","","97","",""})                      
AADD(aDados,{cPerg,"19","Tipo               ?","","","mv_chJ","N",01,0,0,"C","","mv_par19","Notifica็ใo","","","","","Completo","","","","","","","","","","","","","","","","","","","","",""}) 

//
// Atualizando dicionแrio
//
dbSelectArea( 'SX1' )
SX1->( dbSetOrder( 1 ) )

For nXa := 1 To Len( aDados )
	If !SX1->( dbSeek( PadR( aDados[nXa][1], nTam1 ) + PadR( aDados[nXa][2], nTam2 ) ) )
		lAtuHelp:= .T.
		RecLock( 'SX1', .T. )
		For nXb := 1 To Len( aDados[nXa] )
			If aScan( aStruDic, { |aX| PadR( aX[1], 10 ) == PadR( aEstrut[nXb], 10 ) } ) > 0
				SX1->( FieldPut( FieldPos( aEstrut[nXb] ), aDados[nXa][nXb] ) )
			EndIf
		Next nXb
		MsUnLock()
	EndIf
Next nXa

// Atualiza Helps  
lAtuHelp:= .f.
IF lAtuHelp 
	/*
	AADD(aHelp, {'01',{'Conta inicial.'},{''},{''}})
	AADD(aHelp, {'02',{'Conta final.'},{''},{''}})
	AADD(aHelp, {'03',{'Data inicial.'},{''},{''}})
	AADD(aHelp, {'04',{'Data final.'},{''},{''}}) 	
    */
	For nXc:=1 to Len(aHelp)
		PutHelp( 'P.'+cPerg+aHelp[nXc][1]+'.', aHelp[nXc][2], aHelp[nXc][3], aHelp[nXc][4], .T. )
	Next nXc 	

EndIf	

RestArea( aAreaDic )
RestArea( aArea )   
RETURN