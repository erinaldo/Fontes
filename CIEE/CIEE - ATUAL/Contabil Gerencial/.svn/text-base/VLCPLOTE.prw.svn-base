#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VLCPLOTE  º Autor ³ 	CLAUDIO BARROS   º Data ³  19/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada para validar se o registro nos movimentos º±±
±±º          ³ contabeis poderao ser alterados depois de efetivados,      º±± 
±±º          ³ em lancamento Real - Tipo 1.                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGACTB - Lancamentos Automaticos                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function VLCPLOTE()

Local _cQuery	:= " "
Local _lRet		:= .T.
Local _Cfl		:= CHR(13)+CHR(10)
Local _aArea	:= GetArea()

_cQuery := " SELECT CT2_TPSALD FROM "+RetSqlName("CT2")+" " +_Cfl
_cQuery += " WHERE D_E_L_E_T_ = ' ' " +_Cfl
_cQuery += " AND CT2_DATA = '"+Dtos(dDataLanc)+"' "+_Cfl
_cQuery += " AND CT2_LOTE = '"+cLote+"' "+_Cfl
_cQuery += " AND CT2_SBLOTE = '"+cSubLote+"' "+_Cfl
_cQuery += " AND CT2_DOC = '"+cDoc+"' "+_Cfl
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'TRI',.T.,.T.)

If  TRI->CT2_TPSALD == "1"
	nopc   		:= 2
	cAlias 		:= "CT2"
	nReg 		:=	CT2->(Recno())
	CTF_LOCK	:= 0
	cPadrao 	:= " "
	nTotInf	 	:= 0
	Ctba102Lan(nopc,dDataLanc,cLote,cSubLote,cDoc,cAlias,nReg,CTF_LOCK,cPadrao,nTotInf)

	MSGALERT("Nao é Permitido Alterar o Lancamento Contabil após Efetivação!!!")
	_lRet := .F.
ENDIF
/*
If TRI->CT2_TPSALD == "9"
	DbSelectArea("CT6")
	DbSetOrder(1)	
	If DbSeek(xFilial("CT6")+Dtos(dDataLanc)+cLote+cSubLote+"01"+"9")
		RecLock("CT6",.F.)
		CT6->CT6_CREDIT	:= CT2->CT2_VALOR
		CT6->CT6_DEBITO	:= CT2->CT2_VALOR
		CT6->CT6_DIG	:= CT2->CT2_VALOR
		MsUnLock()
	EndIf
EndIf
*/
If Select("TRI") > 0
   TRI->(DBCLOSEAREA())
EndIf

RestArea(_aArea)

Return(_lRet)