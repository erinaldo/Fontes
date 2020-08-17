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

Begin Transaction

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
		    cQ := "SELECT MAX(CTD_ITEM) AS CTD_ITEM FROM "+RetSqlName("CTD")+" WHERE LEFT(CTD_ITEM,9) = '000000000' AND D_E_L_E_T_ = ' '"
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
		nOpAuto := 3
	ELSE
		IF ALLTRIM(CTD->CTD_DESC01)<> ALLTRIM(cDesc)
			nOpAuto := 4
		ELSE
			nOpAuto := 9
		ENDIF
	ENDIF

	IF nOpAuto <> 9 
		Processa({|| AtuItem(cCod,cDesc)},"Atualizando item contábil...")
	ENDIF

ENDIF

End Transaction		

RestArea(aArea)
RETURN

STATIC FUNCTION AtuItem(cCod,cDesc,nOpAuto)
Local aAuto 	:= {}
Local cEmp		:= ""
Local cFilAtu	:= cFilAnt 
Local nX		:= 0
Local cEmpTIN	:= GETNEWPAR("AS_TINEMP","")
Local nRegSM0	:= SM0->(RECNO())         
Local nOpAuto	:= 3

PRIVATE lMsErroAuto := .F.

PROCREGUA(SM0->(RECCOUNT()))

SM0->(DBGOTOP())
WHILE SM0->(!EOF())
	
	IncProc()
	                
    IF SM0->M0_CODIGO == cEmpAnt	
	
	
		cFilAnt := SM0->M0_CODFIL
	 
		CTD->(DBSETORDER(1))        
		IF CTD->(!DBSEEK(XFILIAL("CTD")+cCod))
			nOpAuto := 3
		ELSE
			IF ALLTRIM(CTD->CTD_DESC01)<> ALLTRIM(cDesc)
				nOpAuto := 4
			ELSE
				nOpAuto := 9
			ENDIF
		ENDIF
	
		IF nOpAuto <> 9 
	
	
			aAuto := {{"CTD_ITEM"	, cCod		, NIL},;
					{"CTD_DESC01" 	, cDesc		, NIL},;
					{"CTD_CLASSE"	, "2"		, NIL},;
					{"CTD_BLOQ"		, "2"	, NIL},;
					{"CTD_DTEXIS"	, CTOD("01/01/80"), NIL},;
					{"CTD_CLOBRG"	, "2"		, NIL},;
					{"CTD_ACCLVL"	, "1"		, NIL},;
					{"CTD_ITVM"		, cCod		, NIL}}
			
			MSExecAuto({|x,y| CTBA040(x,y)},aAuto,nOpAuto)
	
	   		IF lMsErroAuto
				MostraErro()
				MsgAlert("Não foi possível atualizar o Item Contábil!","Atenção")
				EXIT
			ENDIF
	   	ENDIF
    ENDIF
	SM0->(DBSKIP())
	
END
cFilAnt := cFilAtu 
SM0->(DBGOTO(nRegSM0))
RETURN