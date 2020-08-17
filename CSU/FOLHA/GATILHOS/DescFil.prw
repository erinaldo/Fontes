#include "rwmake.ch"

// GATILHO AINDA NÃO UTILIZADO
User Function DescFil()

_aArea  := GetArea()

IF !EMPTY(M->RE_FILIALD)

	DBSELECTAREA("SM0")  
	DBSETORDER(1)
	IF DBSEEK("05"+M->RE_FILIALD)
		M->RE_NOMFIL:=SM0->M0_FILIAL
	Endif
	
Endif

RestArea(_aArea)

Return