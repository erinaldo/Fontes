#INCLUDE 'Rwmake.ch'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCOMA32()

utilizado para efetuar a gravacao do usuario do SC8
Chamado pelo PE MTA130C8

@param		Nenhum
@return		Nenhum	
@author 	Fabiano Albuquerque
@since 		23/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------

USER FUNCTION ASCOMA32()

Local aAreaA := GetArea()

DbSelectArea('SC8')
RecLock('SC8',.f.)
SC8->C8_XUSER := __cUserId
MsUnLock()

RestArea( aAreaA )

Return