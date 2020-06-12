#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVLCPLOTE  บ Autor ณ 	CLAUDIO BARROS   บ Data ณ  19/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ponto de entrada para validar se o registro nos movimentos บฑฑ
ฑฑบ          ณ contabeis poderao ser alterados depois de efetivados,      บฑฑ 
ฑฑบ          ณ em lancamento Real - Tipo 1.                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGACTB - Lancamentos Automaticos                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function VLCPLOTE()



Local _cQuery := " "
Local _lRet   := .T.
Local _Cfl    := CHR(13)+CHR(10)


_cQuery := " SELECT CT2_TPSALD FROM "+RetSqlName("CT2")+" " +_Cfl
_cQuery += " WHERE D_E_L_E_T_ = ' ' " +_Cfl
_cQuery += " AND CT2_DATA = '"+Dtos(dDataLanc)+"' "+_Cfl
_cQuery += " AND CT2_LOTE = '"+cLote+"' "+_Cfl
_cQuery += " AND CT2_SBLOTE = '"+cSubLote+"' "+_Cfl
_cQuery += " AND CT2_DOC = '"+cDoc+"' "+_Cfl
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'TRI',.T.,.T.)


IF TRI->CT2_TPSALD == "1"
   MSGINFO("Nao ้ Permitido Alterar o Lancamento Contabil ap๓s Efetiva็ใo!!!")
   _lRet := .F.
ENDIF


If Select("TRI") > 0
   TRI->(DBCLOSEAREA())
EndIf

Return(_lRet)


User Function CCTBA002()

#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCCTBA002  บ Autor ณ CLAUDIO BARROS     บ Data ณ  19/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ 	Rotina para Altera็ใo de Flag. da Efetivacao              บฑฑ
ฑฑบ          ณ  do Contabil Real (Tipo 1) para Pre-Lancamento (Tipo 9).   บฑฑ 
ฑฑบ          ณ  rotina permitida para os usuarios cadastrados no parame-  บฑฑ
ฑฑบ          ณ  tro MV_USERAUT.                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGACTB - AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/


Local _cQuery := " "
Local _lRet   := .T.
Local _Cfl    := CHR(13)+CHR(10)
Local _cUserAut := ALLTRIM(GETMV("MV_USERAUT"))
Local cPerg := "CTBEFT"



IF !ALLTRIM(SUBS(cUsuario,7,15))$ _cUserAut
    MsgInfo("Usuแrio Nใo Autorizado !!!",ALLTRIM(SUBS(cUsuario,7,15)))
    Return(.F.)
EndIf

_aPerg := {}
AADD(_aPerg,{cPerg,"01","Data de     ?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"02","Lote        ?","","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"03","Sublote     ?","","","mv_ch3","C",03,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(_aPerg,{cPerg,"04","Documento   ?","","","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

AjustaSX1(_aPerg)

Pergunte(cPerg, .T.)


_cQuery := " UPDATE "+RetSqlName("CT2")+" SET CT2_TPSALD = '9' " +_Cfl
_cQuery += " WHERE D_E_L_E_T_ = ' ' " +_Cfl
_cQuery += " AND CT2_DATA = '"+Dtos(MV_PAR01)+"' "+_Cfl
_cQuery += " AND CT2_LOTE = '"+MV_PAR02+"' "+_Cfl
_cQuery += " AND CT2_SBLOTE = '"+MV_PAR03+"' "+_Cfl
_cQuery += " AND CT2_DOC = '"+MV)PAR04+"' "+_Cfl
_cQuery += " AND CT2_TPSALD = '1' "+_Cfl
tCSqlexec(_cQuery)


MsgInfo("Processamento OK!!!")


Return

