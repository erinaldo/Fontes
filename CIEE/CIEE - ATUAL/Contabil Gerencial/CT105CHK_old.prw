#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CT105CHK  � Autor � Claudio Barros     � Data �  23/09/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada utilizado para popular o campo CT2_ORIGEM ���
���          � depois que o usu�rio inclui uma nova linha na alteracao    ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CT105CHK()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������


Local cCtbOrig := " "
Local cAlias := GetArea()
Private cString := "TMP"


dbSelectArea("TMP")
dbSetOrder(1)
TMP->(DBGOTOP())
While !TMP->(EOF())
	dbSelectArea("CT2")
	dbSetOrder(1)
	If MsSeek(xFilial()+Dtos(dDataLanc)+cLote+cSubLote+cDoc+TMP->CT2_LINHA)
		cCtbOrig := CT2->CT2_ORIGEM
	ELSE
		RecLock("TMP",.F.)
		TMP->CT2_ORIGEM := cCtbOrig
		TMP->(MsUnlock())
	ENDIF
	TMP->(DBSKIP())
END

RestArea(cAlias)

Return(.T.)
