#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A100DEL   � Autor � Claudio Barros     � Data �  26/08/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada para validar a exclus�o da Nota de entra- ���
���          � da quando o movimento contabil for Real ou efetivado       ���
�������������������������������������������������������������������������͹��
���Uso       � SIGACOM - MATA103 - Excluir o lancamento Contabil          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function A100DEL()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������


Local _cQuery := " "
Local _cFl := CHR(13)+CHR(10)
Local _lRet := .T.
Local _cAlias := GetArea()

Private cString := "CT2"

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

If TRV->CT2_TPSALD == "1"
	MsgAlert("Exclus�o n�o permitida, contabiliza��o efetivada, Informe a contabilidade!!")
    _lRet := .F.
/*
Else
	Dbselectarea("CT2")
	CT2->(DbSetorder(1))
	CT2->(Dbgotop())
	
	CT2->(Dbseek(xFilial("CT2")+Dtos(TRV->CT2_DATA)+TRV->CT2_LOTE+TRV->CT2_SBLOTE+TRV->CT2_DOC+TRV->CT2_LINHA))
	
	While !TRV->(EOF())
		
		CT2->(Dbseek(xFilial("CT2")+Dtos(TRV->CT2_DATA)+;
		TRV->CT2_LOTE+TRV->CT2_SBLOTE+TRV->CT2_DOC+;
		TRV->CT2_LINHA))
		
		RecLock("CT2",.F.)
		CT2->(DbDeLete())
		CT2->(MsUnlock())
		TRV->(DBSKIP())
	End
*/	
EndIf

If Select("TRV") > 0
   TRV->(DbcloseArea())
Endif   
   


RestArea(_cAlias)


Return(_lRet)





