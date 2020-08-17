#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT103IPC ºAutor  ³ Leonardo S. Soncin º Data ³  14/12/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada na Rotina de Documento de Entrada no      º±±
±±º          ³ momento da importacao do pedido de compra usado para carre-º±±
±±º          ³ gar campos customizados.                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA103 - Documento de Entrada                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT103IPC()

Local _aAreaAn := GetArea()
Local _nCnt    := 0
Local _nItem   := ParamIxb[1]
Local cBuscMed
Local vcNxtAli := GetNextAlias(), vcNxtAl1 := CriaTrab(Nil,.f.)

For _nCnt := 1 To Len(aHeader)
	Do Case
		Case Trim(aHeader[_nCnt,2]) == "D1_DESCPRO"
			aCols[_nItem,_nCnt] := SC7->C7_DESCRI // descricao do produto
		Case Trim(aHeader[_nCnt,2]) == "D1_X_RESG"
			aCols[_nItem,_nCnt] := SC7->C7_X_RESG // Numero de Resgate
		Case Trim(aHeader[_nCnt,2]) == "D1_X_RESGP"
			aCols[_nItem,_nCnt] := SC7->C7_X_RESGP // Numero de Pedido de venda da Marketsystem / OS 3193-14 Eduardo Dias - Totvs
	EndCase
Next _nCnt
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ OS 1656/10: Transportar as informacoes "NATUREZA E COMPETENCIA" provenien- ³
³             tes da medicao dos Contratos.                                  ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
If !Empty( SC7->C7_PLANILH )
	
	cBuscMed := " SELECT CNE_XNATUR "
	cBuscMed += " FROM " +RetSqlName('CNE')
	cBuscMed += " WHERE CNE_FILIAL > '  ' "
	cBuscMed += " AND   CNE_CONTRA = '"+SC7->C7_CONTRA+"' "
	cBuscMed += " AND   CNE_REVISA = '"+SC7->C7_CONTREV+"' "
	cBuscMed += " AND   CNE_NUMERO = '"+SC7->C7_PLANILH+"' "
	cBuscMed += " AND   CNE_NUMMED = '"+SC7->C7_MEDICAO+"' "
	cBuscMed += " AND   CNE_ITEM   = '"+SC7->C7_ITEMED+"' "
	cBuscMed += " AND   D_E_L_E_T_ = ' '
	
	U_MontaView( cBuscMed, vcNxtAli )
	
	( vcNxtAli )->( DbGoTop() )
	
	cBuscMed := " SELECT CND_COMPET "
	cBuscMed += " FROM " +RetSqlName('CND')
	cBuscMed += " WHERE CND_FILIAL > '  ' "
	cBuscMed += " AND   CND_CONTRA = '"+SC7->C7_CONTRA+"' "
	cBuscMed += " AND   CND_REVISA = '"+SC7->C7_CONTREV+"' "
	cBuscMed += " AND   CND_NUMERO = '"+SC7->C7_PLANILH+"' "
	cBuscMed += " AND   CND_NUMMED = '"+SC7->C7_MEDICAO+"' "
	cBuscMed += " AND   D_E_L_E_T_ = ' '
	
	U_MontaView( cBuscMed, vcNxtAl1 )
	
	( vcNxtAl1 )->( DbGoTop() )
	
	aCols[ParamIxb[1]][GdFieldPos("D1_XDTAQUI")] := ( vcNxtAl1 )->CND_COMPET
	aCols[ParamIxb[1]][GdFieldPos("D1_NATFULL")] := ( vcNxtAli  )->CNE_XNATUR

	( vcNxtAli )->( DbCloseArea() )
	( vcNxtAl1 )->( DbCloseArea() )
	
EndIf

RestArea( _aAreaAn )

Return
