#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GATCATFUNC� Autor � Silvano Franca     � Data �  22/07/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Gatilho para informar o codigo da SEFIP para autonomos e   ���
���          � pro-labore                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GATCATFUNC()

DO CASE
	CASE M->RA_CATFUNC == "A"
	   M->RA_CATEG := "13"
	CASE M->RA_CATFUNC == "P"
	   M->RA_CATEG := "11"
	OTHERWISE
  	   M->RA_CATEG := ""
END CASE

IF Alltrim(M->RA_CODFUNC) $ "0673*1172*1173*1180"
	   M->RA_CATEG := "07"
ENDIF	   

Return(M->RA_CATEG)
