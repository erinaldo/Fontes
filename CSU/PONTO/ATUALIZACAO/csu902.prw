#INCLUDE "PROTHEUS.CH"
#include "TOPCONN.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � CSU902   � Autor � Adalberto Althoff     � Data � 07/04/06 ���
�������������������������������������������������������������������������͹��
���Descri��o � Filtro do browse para apresentar apenas as Equipes         ���
���			 � referente a cada Gestor			                             ���
�������������������������������������������������������������������������͹��
��� Uso      � Especifico para CSU                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function xsigapon()

If (SM0->M0_CODIGO$"05")		// Checar Empresa, antes de executar (William Campos - 24/08/2006)

	Public _cEq902 := ""

	cQ := "select ZM_COD from "+RetSqlName("SZM")+" where (ZM_USERS = '"+__CUSERID+"' or ZM_USERC = '"+__CUSERID+"' or ZM_USERG = '"+__CUSERID+"') and D_E_L_E_T_ <> '*'"
	
	If Select('AAJ902') > 0
	   AAJ902->( DbCloseArea() )
	EndIf
	
	Tcquery cQ new alias AAJ902

	DBSELECTAREA("AAJ902")
	DBGOTOP()
	While !Eof()
		_cEq902 := _cEq902 + "*" + AAJ902->ZM_COD
		DbSkip()
	Enddo

EndIf

Return