#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCCTBA002  บ Autor ณ CLAUDIO BARROS     บ Data ณ  19/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ 	Rotina para Altera็ใo de Flag. da Efetivacao              บฑฑ
ฑฑบ          ณ  do Contabil Real (Tipo 1) para Pre-Lancamento (Tipo 9).   บฑฑ 
ฑฑบ          ณ  rotina permitida para os usuarios cadastrados no parame-  บฑฑ
ฑฑบ          ณ  tro CI_USERAUT.                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGACTB - MISCELANEAS                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CCTBA002()

Local _cQuery	:= " "
Local _lRet		:= .T.
Local _Cfl		:= CHR(13)+CHR(10)
Local _cUserAut	:= ALLTRIM(GETMV("CI_USERAUT"))

Private cPerg	:= "CTBEFT    "

IF !cUserName $ _cUserAut
    MsgInfo("Usuแrio Nใo Autorizado !!!",ALLTRIM(SUBS(cUsuario,7,15)))
    Return(.F.)
EndIf

CriaSx1()

cRet := Pergunte(cPerg, .T.)

If cRet == .F.
   Return
Endif   

/*
Analisa se dentro da Selecao dos Parametros existe algum documento ja Gerado para o SOE
*/
_cQuery := " SELECT COUNT(CT2_GERARQ) AS REG "
_cQuery += " FROM "+RetSqlName("CT2")+" "
_cQuery += " WHERE D_E_L_E_T_ <> '*' "
_cQuery += " AND CT2_DATA = '"+Dtos(MV_PAR01)+"' "
_cQuery += " AND CT2_LOTE = '"+MV_PAR02+"' "
_cQuery += " AND CT2_SBLOTE = '"+MV_PAR03+"' "
_cQuery += " AND CT2_DOC BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"'  "
_cQuery += " AND CT2_TPSALD = '1' "
_cQuery += " AND CT2_GERARQ <> '' "
_cQuery += " GROUP BY CT2_GERARQ "
TCQUERY _cQuery ALIAS "TMP" NEW

DbSelectArea("TMP")
DbGotop()
If TMP->REG > 0
    MsgInfo("Estorno nใo permitido, documento jแ importado para o SOE!!!")
    Return(.F.)
EndIf

DbSelectArea("TMP")
DbCloseArea()
/*
Fim do Processo para verificar se ja gerou arquivo no SOI
--------------------------------------------------------------------------------------------------------------
O Processo abaixo e para identificar se o registro selecionado pode ser efetivado em funcao do calendario
*/

_cQuery := "SELECT * "
_cQuery += "FROM "+RetSqlName("CTG")+" "
_cQuery += "WHERE D_E_L_E_T_ <> '*' "
_cQuery += "AND MONTH(CTG_DTINI) = MONTH('"+Dtos(MV_PAR01)+"') "
_cQuery += "AND YEAR(CTG_DTINI)  = YEAR('"+Dtos(MV_PAR01)+"') "
_cQuery += "AND CTG_STATUS <> '4' "
TCQUERY _cQuery ALIAS "TMP" NEW

DbSelectArea("TMP")
DbGotop()
If EOF()
    MsgInfo("Calendario esta bloqueado para este periodo!!!")
    Return(.F.)
EndIf

DbSelectArea("TMP")
DbCloseArea()

//Muda o Lancamento Contabil de Real para Pre-Lancamento (CT2)
_cQuery := " UPDATE "+RetSqlName("CT2")+" SET CT2_TPSALD = '9' , CT2_GERARQ = '' " +_Cfl
_cQuery += " WHERE D_E_L_E_T_ = ' ' " +_Cfl
_cQuery += " AND CT2_DATA = '"+Dtos(MV_PAR01)+"' "+_Cfl
_cQuery += " AND CT2_LOTE = '"+MV_PAR02+"' "+_Cfl
_cQuery += " AND CT2_SBLOTE = '"+MV_PAR03+"' "+_Cfl
_cQuery += " AND CT2_DOC BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"'  "+_Cfl
_cQuery += " AND CT2_TPSALD = '1' "+_Cfl
tCSqlexec(_cQuery)

//Deleta a Linha Real na tabela de Saldo por Lote (CT6)
_cQuery := " DELETE "+RetSqlName("CT6")+" " 
_cQuery += " WHERE CT6_DATA = '"+Dtos(MV_PAR01)+"' "
_cQuery += " AND CT6_LOTE = '"+MV_PAR02+"' "
_cQuery += " AND CT6_SBLOTE = '"+MV_PAR03+"' "
_cQuery += " AND CT6_TPSALD = '9' "
_cQuery += " AND CT6_CREDIT = 0 "
_cQuery += " AND CT6_DEBITO = 0 "
_cQuery += " AND CT6_DIG = 0 "
tCSqlexec(_cQuery)

//Atuliza a Linha de Pre-Lancamento na tabela de Saldo por Lote (CT6) com os valores do lancamento real
_cQuery := " UPDATE "+RetSqlName("CT6")+" SET CT6_TPSALD = '9'" 
_cQuery += " WHERE D_E_L_E_T_ = ' ' "
_cQuery += " AND CT6_DATA = '"+Dtos(MV_PAR01)+"' "
_cQuery += " AND CT6_LOTE = '"+MV_PAR02+"' "
_cQuery += " AND CT6_SBLOTE = '"+MV_PAR03+"' "
_cQuery += " AND CT6_TPSALD = '1' "
tCSqlexec(_cQuery)

//Deleta a Linha Real na tabela de Saldo por Documento (CTC)
_cQuery := " DELETE "+RetSqlName("CTC")+" " 
_cQuery += " WHERE CTC_DATA = '"+Dtos(MV_PAR01)+"' "
_cQuery += " AND CTC_LOTE = '"+MV_PAR02+"' "
_cQuery += " AND CTC_SBLOTE = '"+MV_PAR03+"' "
_cQuery += " AND CTC_DOC BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"'  "
_cQuery += " AND CTC_TPSALD = '9' "
_cQuery += " AND CTC_CREDIT = 0 "
_cQuery += " AND CTC_DEBITO = 0 "
_cQuery += " AND CTC_DIG = 0 "
tCSqlexec(_cQuery)

//Deleta a Linha Real na tabela de Saldo por Documento (CTC)
_cQuery := " UPDATE "+RetSqlName("CTC")+" SET CTC_TPSALD = '9' " 
_cQuery += " WHERE CTC_DATA = '"+Dtos(MV_PAR01)+"' "
_cQuery += " AND CTC_LOTE = '"+MV_PAR02+"' "
_cQuery += " AND CTC_SBLOTE = '"+MV_PAR03+"' "
_cQuery += " AND CTC_DOC BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"'  "
_cQuery += " AND CTC_TPSALD = '1' "
tCSqlexec(_cQuery)

MsgInfo("Processamento OK!!!")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCCTBA002  บAutor  ณMicrosiga           บ Data ณ  07/17/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CriaSx1()

Local j  := 0
Local nY := 0
Local aAreaAnt := GetArea()
Local aAreaSX1 := SX1->(GetArea())
Local aReg := {}

AADD(aReg,{cPerg,"01","Data          ?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aReg,{cPerg,"02","Lote          ?","","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aReg,{cPerg,"03","Sublote       ?","","","mv_ch3","C",03,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aReg,{cPerg,"04","Documento De  ?","","","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aReg,{cPerg,"05","Documento Ate ?","","","mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

aAdd(aReg,{"X1_GRUPO","X1_ORDEM","X1_PERGUNT","X1_VARIAVL","X1_TIPO","X1_TAMANHO","X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID","X1_VAR01","X1_DEF01","X1_CNT01","X1_VAR02","X1_DEF02","X1_CNT02","X1_VAR03","X1_DEF03","X1_CNT03","X1_VAR04","X1_DEF04","X1_CNT04","X1_VAR05","X1_DEF05","X1_CNT05","X1_F3"})

dbSelectArea("SX1")
dbSetOrder(1)

For ny:=1 to Len(aReg)-1
	If !dbSeek(aReg[ny,1]+aReg[ny,2])
		RecLock("SX1",.T.)
		For j:=1 to Len(aReg[ny])
			FieldPut(FieldPos(aReg[Len(aReg)][j]),aReg[ny,j])
		Next j
		MsUnlock()
	EndIf
Next ny

RestArea(aAreaSX1)
RestArea(aAreaAnt)

Return Nil