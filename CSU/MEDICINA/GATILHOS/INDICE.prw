#INCLUDE "rwmake.ch"

// *** Rotina INDICE - Utilizada somente para abertura dos indices.
// *** Data: 21/03/2006.

User Function INDICE()

DbSelectArea("SX2")
DbSetOrder(1)
Dbgotop()

do while SX2->(!eof())
	
	_arq	:= X2_CHAVE
	
	IF !(_ARQ $ "SH7/SH9")
		IF  SELECT(_arq) == 0
			DbselectArea(_arq)
			Dbclosearea(_arq)
		ENDIF
	ENDIF
	SX2->(dbskip(1))
Enddo

msgbox(_cMens:="Concluido, todas tabelas executadas")

Return(.t.)

