#INCLUDE "rwmake.ch"



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA050DEL  º Autor ³ Claudio Barros     º Data ³  08/09/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada para validar a exclusão do titulo         º±±
±±º          ³ quando o movimento contabil for Real ou efetivado          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGACOM - FINA050 - Excluir o lancamento Contabil          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FA050DEL()


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
Private cString := "CT2"

dbSelectArea("SE2")

dbSelectArea("CT2")
dbSetOrder(1)


_cQuery := " SELECT CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_LINHA,CT2_TPSALD "+_cFl
_cQuery += " FROM "+RetSqlName("CT2")+"  "+_cFl
_cQuery += " WHERE D_E_L_E_T_ = ''  "+_cFl
_cQuery += " AND CT2_KEY = '"+xFilial("SE2")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA+"' "+_cFl
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRV",.T.,.T.)


TcSetField("TRV","CT2_DATA","D",8, 0 )

If TRV->CT2_TPSALD == "1"
	MsgAlert("Exclusão não permitida, contabilização efetivada, Informe a contabilidade!!")
    _lRet := .F.
ELSE
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
		CT2->(DbDeLete())
		CT2->(MsUnlock())
		CT2->(DBSKIP())

	End
EndIf

If Select("TRV") > 0
   TRV->(DbcloseArea())
Endif   

If SE2->E2_MULNATU == "1"
	DbSelectArea("SEV")
	DbSetOrder(1)
	If DbSeek(xFilial("SEV")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA)
		Do While SEV->EV_PREFIXO+SEV->EV_NUM+SEV->EV_PARCELA+SEV->EV_TIPO+SEV->EV_CLIFOR+SEV->EV_LOJA == SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA
			RecLock("SEV",.F.)
			DbDelete()
			MsUnLock()
			DbSelectArea("SEV")
			DbSkip()
		EndDo
	EndIf
EndIf
   
RestArea(_cAlias)


Return(_lRet)
