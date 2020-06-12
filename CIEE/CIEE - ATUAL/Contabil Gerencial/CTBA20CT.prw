#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTBA20CT  º Autor ³ Claudio Barros     º Data ³  04/11/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada para inclusao do item contabil.           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CTBA20CT()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local aVetor := {}
Private cString := "CTD"


dbSelectArea("CTD")
dbSetOrder(1)

IF INCLUI 
Reclock("CTD",.T.)
CTD->CTD_FILIAL := xFilial("CTD")
CTD->CTD_ITEM   := SUBS(CT1->CT1_RES,1,9)     
CTD->CTD_DESC01 := CT1->CT1_DESC01 
CTD->CTD_CLASSE := CT1->CT1_CLASSE  
CTD->CTD_DTEXIS := CT1->CT1_DTEXIS
CTD->(MsUnlock())
ENDIF
IF ALTERA
CTD->(DBSETORDER(1))
CTD->(DBGOTOP())
CTD->(DbSeek(xFilial("CTD")+CT1->CT1_RES))
Reclock("CTD",.F.)
CTD->CTD_ITEM   := CT1->CT1_RES     
CTD->CTD_DESC01 := CT1->CT1_DESC01 
CTD->CTD_CLASSE := CT1->CT1_CLASSE  
CTD->CTD_DTEXIS := CT1->CT1_DTEXIS
CTD->(MsUnlock())
ENDIF

IF !INCLUI .AND. !ALTERA
	CTD->(DBSETORDER(1))
	CTD->(DBGOTOP())
	IF CTD->(DbSeek(xFilial("CTD")+CT1->CT1_RES)) //Alterado dia 29/07/09 pelo Emerson Natali. acrescentado este IF.
		Reclock("CTD",.F.)
		DbDelete()
		CTD->(MsUnlock())
	EndIF
ENDIF

Return