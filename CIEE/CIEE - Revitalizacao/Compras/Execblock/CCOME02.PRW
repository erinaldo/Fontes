#INCLUDE "TOTVS.CH"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CCOME02
Comprador responsável - Solicitação de Compras
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
USER FUNCTION CCOME02()
Local oDlg	
Local cComp	
Local oBut1
Local oBut2   
Local cComp 	:= SPACE(TAMSX3("C1_CODCOMP")[1])
LOCAL nOpca		:= 0 
local cKeySC	:= SC1->C1_FILIAL+SC1->C1_NUM 
local aAreaC1	:= SC1->(GetArea())


DEFINE MSDIALOG oDlg TITLE cCadastro FROM 0,0  TO 080,330 OF oMainWnd PIXEL
	@ 008, 005 SAY "Comprador:" SIZE 029, 007 OF oDlg PIXEL
	@ 018, 005 MSGET oComp VAR cComp F3 "SY1" SIZE 072, 010 OF oDlg PIXEL
	DEFINE SBUTTON oBut1 FROM 017, 095 TYPE 01 OF oDlg ENABLE ACTION {|| nopca:= 1 , iif(ExistCpo("SY1",cComp),oDlg:end(),NIL) }
	DEFINE SBUTTON oBut2 FROM 018, 132 TYPE 02 OF oDlg ENABLE ACTION {|| nopca:= 0 , oDlg:end() }
ACTIVATE MSDIALOG oDlg CENTERED 

if nopca > 0 .and. !EMPTY(cComp)
	dbselectarea("SC1")
	dbsetorder(1) // C1_FILIAL+C1_NUM+C1_ITEM  
	dbseek(cKeySC)
	while SC1->(!eof()) .and. SC1->(C1_FILIAL+C1_NUM) == cKeySC
		reclock("SC1",.F.)
			SC1->C1_CODCOMP:= cComp	
		msunlock()
	SC1->(dbskip())
	end
	msginfo("Comprador alterado com sucesso.")
endif

RestArea(aAreaC1)  
RETURN 