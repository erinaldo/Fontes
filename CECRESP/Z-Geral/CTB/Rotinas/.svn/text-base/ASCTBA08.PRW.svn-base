#include 'protheus.ch'
//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTBA08
@Monitor de Processamento de consolidação 
@param		
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------
USER FUNCTION ASCTBA08
Local bOk       := {|| (lOk	:= .T., oDlg:End()) }
Local bCancel   := {|| (lOk	:= .F., oDlg:End()) }
Local aRotina :=  { {"Visualizar","AxVisual",0,2},{"Refresh"   ,"U_ASCTBA8R",0,3}}
Private oDlg      
Private cCadastro := "Monitor de Consolidação"

dbSelectArea("CV8")
dbSetOrder(1)
cIndex := CriaTrab(NIL,.F.)

cFiltro := " CV8_INFO = '6' .and. CV8_PROC = 'ASCTBA07' "      
cFiltro += " .and. CV8->CV8_FILIAL == '" + xFilial("CV8") + "' "
IndRegua("CV8",cIndex,CV8->(IndexKey()),,cFiltro)

MaWndBrowse(030,;
			010,;
			500,;
			780,;
			"Log de Processamento - Consolidação Contábil - Monitor",;
			"CV8",;
			,;
			aRotina,;
			,;
			,;
			,;
			.T.,;
			,;
			1)

RetIndex( "CV8" )
FErase( cIndex+OrdBagExt() )

Return                                            
USER FUNCTION ASCTBA8R  
CV8->(DBGOTOP())
oWind:Refresh()
RETURN
