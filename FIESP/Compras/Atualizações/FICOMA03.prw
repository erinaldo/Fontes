#include "rwmake.ch"
#include "protheus.ch"
#include "TOPCONN.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FICOMA03  �Autor  �L�gia Sarnauskas    � Data �  13/12/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa utilizado na Consulta Padrao FILSB1 (especifico)  ���
���          � utilizado para filtrar os produtos que o usu�rio pode      ���
���          � solicitar comprar, incluir pedidos, requisitar armazem     ���
�������������������������������������������������������������������������͹��
���Uso       � FIESP                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FICOMA03()

Local aArea	     := GetArea()
Local _nCont     := 1
Local cCRLF		 := CRLF
_cCodUser	     :=__CUSERID
_cGrupCom        :=""
// Verifica se o usu�rio faz parte de algum grupo de compras
If Select("TMP") > 0     // Verificando se o alias esta em uso
	dbSelectArea("TMP")
	dbCloseArea()
EndIf

cQuery := "SELECT SAI.AI_GRUPO GRUPO "
cQuery := cQuery + " FROM "
cQuery := cQuery + RetSQLname("SAI")+" SAI    "
cQuery := cQuery + " WHERE "
cQuery := cQuery + " SAI.D_E_L_E_T_ = ' ' "
cQuery := cQuery + " AND SAI.AI_USER = '"+_cCodUser+"'
TCQuery cQuery NEW ALIAS "TMP"

dbSelectArea("TMP")
dbGotop()

If !EOF()
	While !EOF()
		If TMP->GRUPO == "*"
			_cGrupCom:=""
		Else
			If _nCont > 1
				_cGrupCom += "|"
			EndIf
			_cGrupCom+=ALLTRIM(TMP->GRUPO)
			_nCont++
		Endif
		dbSelectArea("TMP")
		Dbskip()
	Enddo
Else
	_cGrupCom:=""
Endif

If !EMPTY(_cGrupCom)
	_cFiltro := '(B1_GRUPO$"'+_cGrupCom+'"'
	_cFiltro += ' .AND. B1_MSBLQL <> "1" )'
Else
	_cFiltro := 'B1_MSBLQL <> "1" '
EndIf

RestArea(aArea)

Return(_cFiltro)