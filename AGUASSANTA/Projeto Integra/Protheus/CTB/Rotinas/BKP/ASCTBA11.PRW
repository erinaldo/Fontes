#Include "Protheus.ch"
#Include "TopConn.ch"
//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCTBA11(pAlias)

Rotina para cadastro do ítem contábil através do CNPJ do fornecedor ou cliente
@param		pAlias - Alias do cadastro (cliente ou fornecedor)
            nOpc   - Opção de acordo com o cadastro
@return		Nenhum
@author 	Zema
@since 		26/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASCTBA11(pAlias,nOpc)
Local aArea := GETAREA()
Local cCod  := SPACE(TAMSX3("A2_CGC")[1])
Local cDesc := SPACE(TAMSX3("A2_NOME")[1])
Local cQ	:= ""

IF pAlias == "SA1" 
		
	cDesc := SA1->A1_NOME     

	IF EMPTY(SA1->A1_ITEMCTA)

		IF SA1->A1_EST == "EX"
		    cQ := "SELECT MAX(CTD_ITEM) AS CTD_ITEM FROM "+RetSqlName("CTD")+" WHERE CTD_ITEM < '00000000100000' AND D_E_L_E_T_ = ' '"
			TcQuery ChangeQuery(cQ) ALIAS "XCTD" NEW
		    cCod := XCTD->CTD_ITEM
		    XCTD->(DBCLOSEAREA())
		
			cCod := STRZERO(VAL(cCod)+1,TAMSX3("A1_CGC")[1])   
		ELSE
			cCod := SA1->A1_CGC
		ENDIF
		
		RECLOCK("SA1",.F.)
		SA1->A1_ITEMCTA := cCod
		MsUnlock()
    
	ELSE
		cCod  := SA1->A1_ITEMCTA
	ENDIF
	
ELSE

	cDesc := M->A2_NOME
                                  
	IF EMPTY(SA2->A2_ITEMCTA)

		IF SA2->A2_EST == "EX"
		    cQ := "SELECT MAX(CTD_ITEM) AS CTD_ITEM FROM "+RetSqlName("CTD")+" WHERE CTD_ITEM < '00000000100000' AND D_E_L_E_T_ = ' '"
			TcQuery ChangeQuery(cQ) ALIAS "XCTD" NEW
		    cCod := XCTD->CTD_ITEM
		    XCTD->(DBCLOSEAREA())
		
			cCod := STRZERO(VAL(cCod)+1,TAMSX3("A2_CGC")[1])   
		ELSE
			cCod := SA2->A2_CGC
		ENDIF

		RECLOCK("SA2",.F.)
		SA2->A2_ITEMCTA := cCod
		MsUnlock()	           
	
	ELSE

		cCod := SA2->A2_ITEMCTA		
	
	ENDIF
	
ENDIF	                    

IF !EMPTY(cCod)

	CTD->(DBSETORDER(1))        
	IF CTD->(!DBSEEK(XFILIAL("CTD")+cCod))
		RecLock("CTD",.T.)
		CTD->CTD_FILIAL		:= XFILIAL("CTD")
		CTD->CTD_ITEM		:= cCod
		CTD->CTD_DESC01		:= cDesc
		CTD->CTD_CLASSE  	:= "2"
		CTD->CTD_BLOQ		:= "2"    
		CTD->CTD_DTEXIS		:= CTOD("01/01/80")
		CTD->CTD_CLOBRG		:= "2"
		CTD->CTD_ACCLVL	    := "1"
		MsUnlock()  
	ELSE         
	
	    IF ALLTRIM(CTD->CTD_DESC01) <> ALLTRIM(cDesc)
	
			RecLock("CTD",.F.)          
			CTD->CTD_DESC01		:= cDesc
			MsUnlock()	
			
		ENDIF
	ENDIF
	
ENDIF
RestArea(aArea)
RETURN