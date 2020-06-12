#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A100TR03    � Autor � CLAUDIO BARROS   � Data �  18/11/05   ���
�������������������������������������������������������������������������͹��
���Descricao � ponto de entrada para gravar no movimento banc�rio campo   ���
���          � E5_TIPCIE, com Flag Espeficio do Cliente CIEE              ���
�������������������������������������������������������������������������͹��
���Uso       � FINA100 - Estorno das transferencias                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function A100TR03


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������



Local _aAreaSE5 := SE5->(GetArea())
Local _lRet   := .T.
Local cDOC    :=SE5->E5_DOCUMEN
Local dDtDoc  := SE5->E5_DATA
Local cQuery  := " "
Local cFl     := CHR(13)+CHR(10)


IF ALLTRIM(SE5->E5_HISTOR) == "Estorno de transferencia."
	SE5->(dbSetOrder(10))
	SE5->(DBGOTOP())
	If SE5->(dbSeek(xFilial("SE5")+cDOC+"TR"+Dtos(dDtDoc)))
    	cQuery := " UPDATE "+RetSqlName("SE5")+" SET E5_TIPODOC = 'CA' "+cFl
    	cQuery += " WHERE D_E_L_E_T_ = ' ' "+cFl
        cQuery += " AND E5_HISTOR = 'Estorno de transferencia.' "+cFl              
        cQuery += " AND (E5_DOCUMEN = '"+cDoc+"' OR  E5_NUMCHEQ = '"+cDoc+"')"+cFl              	
        tCSqlexec(cQuery)     
     EndIf
ENDIF

SE5->(RestArea(_aAreaSE5))
 

Return(_lRet)




