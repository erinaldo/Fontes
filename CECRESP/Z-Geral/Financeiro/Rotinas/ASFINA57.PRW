#Include "Protheus.ch"       
#INCLUDE "TOPCONN.CH"
//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA57
Executado via pontos de entrada: F080PCAN - Processa a exclusão dos movimentos de mutuo
@param		pLotMut - Codigo do lote de mutuo
			pReg    - Registro do SE5 atual
@return		Nenhum
@author 	Zema
@since 		17/05/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA57(pLotMut,pReg)
LOCAL aArea		:= GetArea()
LOCAL cLotMut	:= pLotMut  
LOCAL nRegSE5	:= pReg

Processa({|| ExcluiLT(cLotMut, nRegSE5)}, "Cancelando mutuos...")
      
RestArea(aArea)

RETURN
//-----------------------------------------------------------------------
/*/{Protheus.doc} ExcluiLT
Processa a exclusão dos movimentos de mutuo
@param		cLotMut - Codigo do lote de mutuo
@return		Nenhum
@author 	Zema
@since 		17/05/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION ExcluiLT(cLotMut, nRegSE5)
LOCAL cQ		:= ""                     
LOCAL cFilAux	:= cFilAnt                                                               
LOCAL cSinal    := ""

cQ := "SELECT R_E_C_N_O_ REGSE5 FROM "+RetSqlName("SE5")
cQ += " WHERE E5_XLOTMUT = '"+cLotMut+"'" 
cQ += " AND D_E_L_E_T_ = ' '"
TcQuery ChangeQuery(cQ) ALIAS "XSE5LOT" NEW 

DBSELECTAREA("XSE5LOT")
ProcRegua(Reccount())

WHILE XSE5LOT->(!EOF())

	IF XSE5LOT->REGSE5 <> nRegSE5  
	
		SE5->(DBGOTO(XSE5LOT->REGSE5))            
	
		cFilAnt := SE5->E5_FILORIG

        IF SE5->E5_RECPAG == "R" .AND. !EMPTY(SE5->E5_PREFIXO) .AND. SE5->E5_TABORI == "FK1"
        	
			SE1->(DBSETORDER(1))
			IF SE1->(DBSEEK(XFILIAL("SE1")+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO))
				CanBaixa()
			ENDIF
		ELSE           	
		
			RECLOCK("SE5",.F.)
			SE5->E5_SITUACA = "C"
			MsUnlock()  
		
			cSinal := Iif(SE5->E5_RECPAG=="P","+","-")
		
			AtuSalBco(SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA,dDataBase,SE5->E5_VALOR,cSinal)
		ENDIF		
    ENDIF
    
	XSE5LOT->(DBSKIP())
END                    

XSE5LOT->(DBCLOSEAREA())

cFilAnt := cFilAux

RETURN
//-----------------------------------------------------------------------
/*/{Protheus.doc} CanBaixa

Cancela a Baixa o título a receber via ExecAuto

@param		
@return		lRet = Se ocorreu erro
@author 	Zema
@since 		21/05/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION CanBaixa
	LOCAL lRet			:= .T.
	LOCAL nOPC			:= 5
	LOCAL aDadosSE1		:= {}
	
	PRIVATE lMsErroAuto := .F.	// variável que define que o help deve ser gravado no arquivo de log e que as informações estão vindo à partir da rotina automática.
	PRIVATE cSEQSE5		:= SE5->E5_SEQ
    
	//-----------------------------------------------------------------------
	// Array para o ExecAuto
	//-----------------------------------------------------------------------
	aDadosSE1 := {;
		{"E1_PREFIXO"	, SE1->E1_PREFIXO		, NIL		},;
		{"E1_NUM"		, SE1->E1_NUM			, NIL		},;
		{"E1_PARCELA"	, SE1->E1_PARCELA		, NIL		},;
		{"E1_TIPO"		, SE1->E1_TIPO			, NIL		},;
		{"E1_CLIENTE"	, SE1->E1_CLIENTE		, NIL		},;
		{"E1_LOJA"		, SE1->E1_LOJA			, NIL		};
		}

	DbSelectArea("SE1")
	lMsErroAuto := .F.
	BeginTran()
	MSExecAuto({|x,y| Fina070(x,y)}, aDadosSE1, nOPC)//  3=Baixa de Título; 5=Cancelamento de baixa; 6=Exclusão de Baixa
		
	If lMsErroAuto
		DisarmTransaction()
		MostraErro()
			
		lRet := .F.
	Else
		EndTran()
	EndIf
		
	MsUnlockAll()

RETURN lRet                                              



