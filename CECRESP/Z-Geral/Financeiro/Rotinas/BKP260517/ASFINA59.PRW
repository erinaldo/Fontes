#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA59
Ponto de entrada FA100REC na gravação do movimento bancário receber - gera movimentação do mutuo
@param		pLoteMut - lote do mutuo
@return		Nenhum
@author 	Zema
@since 		19/05/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA59(pLoteMut)      
LOCAL aArea	:= GETAREA()
PRIVATE cLoteMut := pLoteMut

Processa({|| GerMut()}, "Gerando movimentações no banco mutuo...")
                        
RESTAREA(aArea)

RETURN         
//-----------------------------------------------------------------------
/*/{Protheus.doc} GerMut
Gera movimentação do mutuo para o lote
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		195/05/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION GerMut
LOCAL cQuery := ""
                                                          
// Gero o muto para os titulos baixados
cQuery := "SELECT R_E_C_N_O_ REGSE5 FROM "+RetSqlName("SE5")
cQuery += " WHERE E5_XLOTMUT = '"+cLoteMut+"' AND E5_XBCOFIL <> ' ' AND D_E_L_E_T_ = ' ' "
TcQuery ChangeQuery(cQuery) ALIAS "XSE5LOT" NEW 

DBSELECTAREA("XSE5LOT")
ProcRegua(Reccount())
XSE5LOT->(DBGOTOP())

WHILE XSE5LOT->(!EOF())
	IncProc()
	
	SE5->(DBGOTO(XSE5LOT->REGSE5))
	
	U_ASFINA58(SE5->E5_FILORIG,SE5->E5_XBCOFIL,cLoteMut, "P#R" ) 
	
	XSE5LOT->(DBSKIP())	

ENDDO                     

XSE5LOT->(DBCLOSEAREA())

RETURN
