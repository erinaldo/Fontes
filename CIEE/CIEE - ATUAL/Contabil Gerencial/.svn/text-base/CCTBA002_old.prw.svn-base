User Function CCTBA002()

#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CCTBA002  º Autor ³ CLAUDIO BARROS     º Data ³  19/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ 	Rotina para Alteração de Flag. da Efetivacao              º±±
±±º          ³  do Contabil Real (Tipo 1) para Pre-Lancamento (Tipo 9).   º±± 
±±º          ³  rotina permitida para os usuarios cadastrados no parame-  º±±
±±º          ³  tro MV_USERAUT.                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGACTB - MISCELANEAS                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Local _cQuery := " "
Local _lRet   := .T.
Local _Cfl    := CHR(13)+CHR(10)
Local _cUserAut := ALLTRIM(GETMV("CI_USERAUT"))
Private cPerg := "CTBEFT"



IF !ALLTRIM(SUBS(cUsuario,7,15))$ _cUserAut
    MsgInfo("Usuário Não Autorizado !!!",ALLTRIM(SUBS(cUsuario,7,15)))
    Return(.F.)
EndIf


CriaSx1()


cRet := Pergunte(cPerg, .T.)

If cRet == .F.
   Return
Endif   



_cQuery := " UPDATE "+RetSqlName("CT2")+" SET CT2_TPSALD = '9' " +_Cfl
_cQuery += " WHERE D_E_L_E_T_ = ' ' " +_Cfl
_cQuery += " AND CT2_DATA = '"+Dtos(MV_PAR01)+"' "+_Cfl
_cQuery += " AND CT2_LOTE = '"+MV_PAR02+"' "+_Cfl
_cQuery += " AND CT2_SBLOTE = '"+MV_PAR03+"' "+_Cfl
_cQuery += " AND CT2_DOC BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"'  "+_Cfl
_cQuery += " AND CT2_TPSALD = '1' "+_Cfl
tCSqlexec(_cQuery)


MsgInfo("Processamento OK!!!")


Return

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