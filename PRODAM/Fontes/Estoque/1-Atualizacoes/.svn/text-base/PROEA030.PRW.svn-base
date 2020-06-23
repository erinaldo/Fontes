#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#include "topconn.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun??o    ³PROEA030  ³ Autor ³ Felipe Santos          ³ Data ³ 26/07/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o ³ Rotina de reenvio do workflow pela SOLICITACAO DE COMPRAS  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAEST                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PROEA030()
Local oDlg
Local oGet1 
Local cNomResp  := BuscaUsr(1, SC1->C1_NUM)
Local cNom3     := BuscaUsr(2, SC1->C1_NUM)
Local cUserResp := "Usuário Responsável : "   + cNomResp
Local cUserR2   := "Usuário Responsável 2 : " + cNom3

If !Empty(cNomResp) .and. !Empty(cNom3)

	DEFINE MSDIALOG oDlg FROM  64,33 TO 235,505 TITLE "Responsável - Análise de Amostra" PIXEL
	@ 00,000 BITMAP oBmp RESNAME "PROJETOAP" oF oDlg SIZE 35,oDlg:nBottom / 2.4 NOBORDER WHEN .F. PIXEL
	
	@ 06,040 SAY "Responsável pela Análise de Amostra ref. ao Pedido de compras :"+ SC1->C1_PEDIDO   SIZE 255, 7 OF oDlg PIXEL
	
	@ 20,040 SAY cUserResp SIZE 245, 7 OF oDlg PIXEL
	
	@ 35,040 SAY cUserR2 SIZE 245, 7 OF oDlg PIXEL 
	
	DEFINE SBUTTON FROM 67, 170 TYPE 2 ENABLE OF oDlg ACTION ( nOpca:=0,oDlg:End() )
	ACTIVATE MSDIALOG oDlg CENTERED

Else
	MsgInfo("Nota não tem responsável pela análise de amostra")
EndIf

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BusaUsr     ºAutor  ³Felipe Santos     º Data ³  11/08/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 							                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function BuscaUsr(nTipo, cNum)
Local cRetEmails := ""//"felipe.csantos@totvs.com.br;neofelipe@gmail.com"
Local _cQry 	 := ""					//Monta a QUERY
Local _aArea	 := GetArea()			//Salva a Area atual
Local _cAlias	 := GetNextAlias()		//Busca o proximo Alias disponivel
Local _aCat		 := {}					//Array contendo os recnos das tabelas DC3, DC2 e DC8

DbSelectArea("SD1")
DbSetOrder(1)

If nTipo = 1 
	_cQry := " SELECT SC1.C1_XUSRAMO FROM " + RetSqlName("SD1") + " SD1"
ElseIF nTipo = 2
	_cQry := " SELECT SC1.C1_XUSRAM2 FROM " + RetSqlName("SD1") + " SD1"
EndIf
_cQry += " INNER JOIN "+ RetSqlName("SC7") + " SC7 ON SD1.D1_PEDIDO=SC7.C7_NUM AND SD1.D1_ITEMPC = SC7.C7_ITEM "
_cQry += " INNER JOIN "+ RetSqlName("SC1") + " SC1 ON SC1.C1_NUM=SC7.C7_NUMSC AND SC1.C1_ITEM = SC7.C7_ITEMSC "
_cQry += " WHERE SD1.D1_FILIAL     = '" + xFilial("SD1") + "'"
_cQry += " AND SC7.C7_FILIAL       = '" + xFilial("SC7") + "'"
_cQry += " AND SC1.C1_FILIAL       = '" + xFilial("SC1") + "'"
_cQry += " AND SC1.C1_NUM          = '" + cNum + "'"
_cQry += " AND SD1.D_E_L_E_T_ = ' '"
_cQry += " AND SC7.D_E_L_E_T_ = ' '"
_cQry += " AND SC1.D_E_L_E_T_ = ' '"
_cQry += " AND SC1.C1_XANAMOS = '1' "


TcQuery _cQry New Alias (_cAlias)    

While !(_cAlias)->( Eof() )
	If nTipo = 1 
		If !Empty(AllTrim((_cAlias)->C1_XUSRAMO)) 		
			cRetEmails := AllTrim((_cAlias)->C1_XUSRAMO) +" - "+  U_UsrRetMail(AllTrim((_cAlias)->C1_XUSRAMO))
		EndIf
	ElseIf nTipo = 2
		If !Empty(AllTrim((_cAlias)->C1_XUSRAM2)) 		
			cRetEmails := AllTrim((_cAlias)->C1_XUSRAM2) +" - "+  U_UsrRetMail(AllTrim((_cAlias)->C1_XUSRAM2))
		EndIf	
	EndIf

	(_cAlias)->( dbSkip() )
EndDo


(_cAlias)->( dbCloseArea() )

RestArea(_aArea)


Return cRetEmails
