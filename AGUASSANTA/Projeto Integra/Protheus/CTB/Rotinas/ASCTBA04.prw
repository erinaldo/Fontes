#include 'protheus.ch'
#include 'topconn.ch'
//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTBA04
@Exclusão do movimento de equivalência ou conversao de balancos
@param		nOpc,dDataLanc, cLote, cSbLote, cDoc
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------
User Function ASCTBA04(nOpc,dDataLanc, cLote, cSbLote, cDoc)
Local cChave := CT2->CT2_FILIAL+DTOS(CT2->CT2_DATA)+CT2->CT2_LOTE+CT2->CT2_SBLOTE+CT2->CT2_DOC
ConOut("Exclusao: "+cChave)
IF nOpc == 5
	cQ := "SELECT R_E_C_N_O_ AS REG FROM "+RetSqlName("SZ3")
	cQ += " WHERE Z3_CT2 = '"+cChave+"'"
	TcQuery ChangeQuery(cQ) ALIAS "XSZ3" NEW
	WHILE XSZ3->(!EOF())
		SZ3->(DBGOTO(XSZ3->REG))
		RECLOCK("SZ3",.F.)
		SZ3->Z3_STATUS := "EXCLUIDO"
		MsUnlock()
		XSZ3->(DBSKIP())
	END
	XSZ3->(DBCLOSEAREA())
ENDIF

Return                     
