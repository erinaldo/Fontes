#include "rwmake.ch"
#include "TOPCONN.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F240FIL   �Autor  �TOTVS               � Data �  29/11/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada que executa Filtro na Rotina de Bordero   ���
���          � Pagamento                                                  ���
�������������������������������������������������������������������������͹��
���Uso       � FIESP                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function F240FIL()

Private _cFilBD	:= ""
Private _nOpc	:= 0

If ApMsgYesNo("Modelo'?","PE.(F240FIL)-Filtro")
	_cFilBD := " E2_XMODBOR == '"+cModPgto+"' "
	/*
	_cFilBD := " E2_XBCOBOR == '"+cPort240+"' "
	_cFilBD += " .AND. E2_XAGBOR  == '"+cAgen240+"' "
	_cFilBD += " .AND. E2_XCCBOR  == '"+cConta240+"' "
	_cFilBD += " .AND. E2_XMODBOR == '"+cModPgto+"' "
	*/
EndIf
	
Return(_cFilBD)