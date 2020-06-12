#include 'protheus.ch'
#include 'topconn.ch'
//-----------------------------------------------------------------------
/*{Protheus.doc} Ponto de Entrada ANCTB102GR
@Excutado antes da gravação de lançamentos contábeis
@param		ExecBlock("ANCTB102GR",.F.,.F.,{ nOpc,dDataLanc,cLote,cSubLote,cDoc }  )
@return		Nil
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------
User Function ANCTB102GR     
Local nOpc 		:= PARAMIXB[1]
Local dDataLanc := PARAMIXB[2]
Local cLote		:= PARAMIXB[3] 
Local cSbLote   := PARAMIXB[4]
Local cDoc		:= PARAMIXB[5]  

// Chamada da rotina de exclusão da equivalência patrimonial
U_ASCTBA04(nOpc,dDataLanc, cLote, cSbLote, cDoc)

Return(Nil)