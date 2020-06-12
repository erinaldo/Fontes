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

/*If Altera <> .T.
   Return(_lRet)
EndIf   
*/


_cQuery := " SELECT CT2_TPSALD FROM "+RetSqlName("CT2")+" " +_Cfl
_cQuery += " WHERE D_E_L_E_T_ = ' ' " +_Cfl
_cQuery += " AND CT2_DATA = '"+Dtos(dDataLanc)+"' "+_Cfl
_cQuery += " AND CT2_LOTE = '"+cLote+"' "+_Cfl
_cQuery += " AND CT2_SBLOTE = '"+cSubLote+"' "+_Cfl
_cQuery += " AND CT2_DOC = '"+cDoc+"' "+_Cfl
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'TRI',.T.,.T.)



If  TRI->CT2_TPSALD == "1"

nopc := 2
cAlias := "CT2"
nReg := CT2->(Recno())
CTF_LOCK	:= 0
nTotInf := 0     
cPadrao := " "

Ctba102Lan(nopc,dDataLanc,cLote,cSubLote,cDoc,cAlias,nReg,CTF_LOCK,;
				   cPadrao,nTotInf)


Endif

IF TRI->CT2_TPSALD == "1"
   MSGINFO("Nao ้ Permitido Alterar/Excluir o Lancamento Contabil ap๓s Efetiva็ใo!!!")
   _lRet := .F.
ENDIF


If Select("TRI") > 0
   TRI->(DBCLOSEAREA())
EndIf




Return(_lRet)
