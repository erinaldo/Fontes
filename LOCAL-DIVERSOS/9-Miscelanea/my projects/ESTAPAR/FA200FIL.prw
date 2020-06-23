#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*/
+-------------+-----------+--------------------------------------+------------------+
| PROGRAMA    | FA200FIL  | AUTOR: Daniel G.Jr.TI1239            | DATA: Jan/2013   |
+-------------+-----------+--------------------------------------+------------------+
| DESCRIÇÃO   | Ponto de entrada do programa FINA200 (Retorno CNAB Receber)         |
|             | Executado apos carregar os dados do arquivo de recepção bancaria.   |
|             | Utilizado para posicionar título a ser baixado.                     |
+-------------+---------------------------------------------------------------------+
| SINTAXE     | FA200FIL()                                                          |
+-------------+---------------------------------------------------------------------+
| PARAMETROS  | Matriz aValores passadas na Paramixb. Esta matriz contem:           |
|             | aValores[01] - Numer do Titulo                                      |
|             | aValores[02] - Data da Baixa                                        |
|             | aValores[03] - Tipo do Titulo                                       |
|             | aValores[04] - Nosso Numero                                         |
|             | aValores[05] - Valor de Despesa                                     |
|             | aValores[06] - Valor do Desconto                                    |
|             | aValores[07] - Valor do Abatimento                                  |
|             | aValores[08] - Valor Recebido                                       |
|             | aValores[09] - Valor dos Juros                                      |
|             | aValores[10] - Valor da Multa                                       |
|             | aValores[11] - Valor de Outros Despesas                             |
|             | aValores[12] - Valor do Credito                                     |
|             | aValores[13] - Data do Credito                                      |
|             | aValores[14] - Ocorrencia                                           |
|             | aValores[15] - Motivo da Baixa                                      |
|             | aValores[16] - Linha Inteira -> retornada pelo banco                |
+-------------+---------------------------------------------------------------------+
| RETORNO     | ExpA1 - expressao logica se achou ou não o título                   |
+-------------+---------------------------------------------------------------------+
| USO         | Genérico                                                            |
+-------------+---------------------------------------------------------------------+
| ARQUIVOS    |                                                                     |
+-------------+---------------------------------------------------------------------+
| OBSERVAÇÕES | Ponto usado pelo retorno de cobrança sem registro                   |
+-------------+---------------------------------------------------------------------+
/*/
User Function FA200FIL()

Local _cNumTit 	:= PARAMIXB[1]
Local _cNossoNum:= PARAMIXB[4]
Local _lRet		:= .F.
Local _cQuery	:= ""
Local cAliasTop	:= ""
Local nRecSE1	:= 0

_aAreaSE1	:= GetArea()

CONOUT("FINA200X - Executando fa200fil")

//_cNumTit := Padl(AllTrim(Str(Val(_cNumTit))),TamSx3("E1_NUMBCO")[1],"0")	//Corrige o tamanho do campo recebido do arquivo
//_cNumTit := Padl(AllTrim(Str(Val(_cNumTit))),If(mv_par06=="341",12,15),"0")	//Corrige o tamanho do campo recebido do arquivo
//esse é o que esstava funcionando 
//_cNumTit := Padl(AllTrim(Str(Val(_cNumTit))),If(mv_par06=="341",12,If(mv_par06=="237","06"+12,15),"0")	//Corrige o tamanho do campo recebido do arquivo
//_cNumTit := if (mv_par06 =="237","06"+ SubStr(_cNumTit,3,12), Padl(AllTrim(Str(Val(_cNumTit))),If(mv_par06 $ "341",12,15),"0"))	//Corrige o tamanho do campo recebido do arquivo
//_cNumTit := if (mv_par06 =="033","000"+ SubStr(_cNumTit,4,11), Padl(AllTrim(Str(Val(_cNumTit))),If(mv_par06 $ "341",12,15),"0"))	//Corrige o tamanho do campo recebido do arquivo
  
//
If mv_par06 == "237"
//	_cNumTit := AllTrim(mv_par06)+ SubStr(_cNumTit,3,12)
	_cNumTit := AllTrim(mv_par09)+ SubStr(_cNossoNum,3,12)
ElseIf mv_par06 == "033"
	_cNumTit := "000"+ SubStr(_cNumTit,4,11)
ElseIf mv_par06 == "341"
	_cNumTit := Repl("0",12-Len(_cNumTit))+_cNumTit
ElseIf mv_par06 == "399"
	_cNumTit := StrZero(Val(_cNossoNum),11)
End

//
_cQuery := "SELECT R_E_C_N_O_ E1REC "
_cQuery += "FROM "+RetSqlName("SE1")+" "
_cQuery += "WHERE D_E_L_E_T_='' "
_cQuery += "AND E1_NUMBCO = '"+_cNumTit+"' "
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery), cAliasTop := GetNextAlias(), .F., .T.)

If !(cAliasTop)->(Eof())
	CONOUT("FINA200X - achou registro com e1_numbco no fa200fil")
	nRecSE1 := (cAliasTop)->E1REC
	//dbSelectArea("SE1")
	SE1->(dbGoTo(nRecSE1))
	If AllTrim(SE1->E1_NUMBCO)==_cNumTit
		CONOUT("FINA200X - confirmado e1_numbco no fa200fil")
		_lRet := .T.
		(cAliasTop)->(dbCloseArea())
		Return(_lRet)
	EndIf
EndIf

(cAliasTop)->(dbCloseArea())
//SE1->(dbSetOrder(1))
//SE1->(dbGoTo(nRecSE1))
RestArea(_aAreaSE1)
CONOUT("FINA200X - saindo do fa200fil")

Return(_lRet)
