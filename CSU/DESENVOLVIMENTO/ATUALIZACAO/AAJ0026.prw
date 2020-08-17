#include "topconn.ch"
#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AAJ0026   � Autor � ADALBERTO ALTHOFF  � Data �  03/03/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado para atender a OS 0649/05 (flag ctb folha)   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function AAJ0026

Processa({|lEnd| AAJ0026Processa(),"(0649/05) Eliminando flag CT2_ITFOL..."})

STATIC FUNCTION AAJ0026Processa()

ct2->(dbsetorder(1))
_cFiltro:="dtos(ct2_data)=='20050228'.and.CT2_LOTE=='008891'.and.ct2_ITFOL=='S'"
ct2->(IndRegua(alias(),criatrab(,.f.),indexkey(),,_cFiltro))
ct2->(dbgotop())



ProcRegua(5376)


DBSELECTAREA("CT2")

do while !eof()
	
	IncProc("(0649/05) Eliminando flag CT2_ITFOL...")

	RecLock( "CT2" , .F. )
	CT2_ITFOL := " "
	MsUnLock()
	
	dbSkip()
	
enddo

Return
