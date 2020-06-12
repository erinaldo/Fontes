#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F1100E    º Autor ³ Claudio Barros     º Data ³  26/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada para validar a exclusão da Nota de entra- º±±
±±º          ³ da quando o movimento contabil for Real ou efetivado       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGACOM - MATA103 - Excluir o lancamento Contabil          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function SF1100E()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Local _cQuery := " "
Local _cFl := CHR(13)+CHR(10)
Local _lRet := .T.
Local _cAlias := GetArea()
Private cString := "SF1"
Private cString := "CT2"

dbSelectArea("SF1")
dbSetOrder(1)


dbSelectArea("CT2")
dbSetOrder(1)


_cQuery := " SELECT CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_LINHA,CT2_TPSALD "+_cFl
_cQuery += " FROM "+RetSqlName("CT2")+"  "+_cFl
_cQuery += " WHERE D_E_L_E_T_ = ''  "+_cFl
//_cQuery += " AND CT2_KEY = '"+xFilial("SF1")+Dtos(SF1->F1_EMISSAO)+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA+"' "+_cFl
_cQuery += " AND CT2_KEY = '"+xFilial("SF1")+SF1->F1_SERIE+SF1->F1_DOC+SF1->F1_FORNECE+SF1->F1_LOJA+"' "+_cFl

_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRV",.T.,.T.)


TcSetField("TRV","CT2_DATA","D",8, 0 )

If TRV->CT2_TPSALD == "9"
	Dbselectarea("CT2")
	CT2->(DbSetorder(1))
	CT2->(Dbgotop())
	
	CT2->(Dbseek(xFilial("CT2")+Dtos(TRV->CT2_DATA)+TRV->CT2_LOTE+TRV->CT2_SBLOTE+TRV->CT2_DOC))	

    _cData   := TRV->CT2_DATA
    _cLote   := TRV->CT2_LOTE
    _cSblote := TRV->CT2_SBLOTE
    _cDoc    := TRV->CT2_DOC
    _cLinha  := TRV->CT2_LINHA
		

	While CT2->CT2_FILIAL == xFilial("CT2") .AND. CT2->CT2_DATA == _cData .AND. CT2->CT2_LOTE == _cLote .AND.;
	      CT2->CT2_SBLOTE == _cSblote .AND. CT2->CT2_DOC == _cDoc 
	      
		RecLock("CT2",.F.)
		CT2->CT2_XUSER	:= cUserName
		CT2->CT2_XDTEXL	:= dDataBase
		CT2->(DbDeLete())
		CT2->(MsUnlock())
		CT2->(DBSKIP())
	End
EndIf

If Select("TRV") > 0
   TRV->(DbcloseArea())
Endif   
   
RestArea(_cAlias)

Return(_lRet)