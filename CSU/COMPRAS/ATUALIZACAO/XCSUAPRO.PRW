#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Ponto de  ³ xCsuAPro ³Autor  ³ Leonardo Soncin       ³Data  ³23/11/2006³±±
±±³Entrada   ³          ³       ³                       ³      ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Validacao do Codigo do Produto na Solicitacao de Compras.   ³±±
±±³          ³Para não permitir que sejam incluidos produtos nao autoriz. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Especifico CSU                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³           Atualiza‡oes sofridas desde a constru‡ao inicial            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³Data      ³Motivo da Altera‡ao                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            |          |                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function xCsuAPro()

Local lRetorno	:= .T.
Local aArea := GetArea()
Local cUser := RetCodUsr()
Local aGrupo := UsrRetGrp()
Local cProduto  := &(ReadVar())

//
lRetorno := U_xVldSol(cProduto,aGrupo,cUser,.T.,Alltrim(Upper(FunName())))


RestArea(aArea)
Return lRetorno

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ xVldSol  ³ Autor ³ Leonardo Soncin       ³ Data ³16/11/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao para controle de usuarios x produtos.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do produto.                                 ³±±
±±³          ³ ExpA1 = Array contendo os grupos do usuario.               ³±±
±±³          ³ ExpC1 = Codigo do usuario a ser verificado.                ³±±
±±³          ³ ExpL1 = Variavel que controla a exibicao dos helps.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ RetL1 = .T. - usuario/grupo com permissao ao produto.      ³±±
±±³          ³ RetL1 = .F. - usuario/grupo sem permissao ao produto.      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico.                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function xVldSol(cProduto,aGrupo,cUser,lHelp,cFuncao)

Local aArea      := GetArea()
Local aAreaSZJ   := SZJ->(GetArea())
Local aUser      := {}
Local lRetorno   := .F.
Local nX         := 1
Local lContinua  := .T.

Local cQuery     := ""
Local lQuery     := .F.
Local cAliasSZJ  := "SZJ"
Local cHelp 	 := ""

Local _cString  := " "
Local _cFiltro  := " "
Local _nCall    := 1

aUser    := {"******",cUser}

If !cFuncao=="CNTA120"  //Verifica se o pedido e proveniente do modulo de gestao de contratos, para nao passar pelas amarracoes abaixo.
	If !Empty(cProduto)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se há controle de solicitante                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SZJ")
		dbSetOrder(1)
		If !MsSeek(xFilial("SZJ"))
			lContinua := .F.
		Endif
	
		If lContinua
		
			dbSelectArea("SB1")
			dbSetOrder(1)
			MsSeek(xFilial()+cProduto)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica os direitos dos Grupos de usuarios.             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
			cAliasSZJ := "MAVLDSOLIC"
			lQuery    := .T.
		
			cQuery    := "SELECT COUNT(ZJ_FILIAL) NREG "
			cQuery    += "FROM "+RetSqlName("SZJ")+" SZJ "
			cQuery    += "WHERE SZJ.ZJ_FILIAL='"+xFilial("SZJ")+"' AND "
			cQuery    += "(SZJ.ZJ_GRUSER = '******'"
		
			If !Empty( aGrupo )
				cQuery += " OR "
				cQuery += " SZJ.ZJ_GRUSER IN("
				For nX := 1 To Len(aGrupo)
					cQuery += "'"+aGrupo[nX]+Iif(nX==Len(aGrupo),"'","',")
				Next nX
				cQuery += ")"
			EndIf
		
			cQuery    += ") AND "
			cQuery    += "(( "
			cQuery    += " SZJ.ZJ_PRODUTO='* ') OR SZJ.ZJ_PRODUTO='"+SB1->B1_COD+"') AND "
			cQuery    += "SZJ.ZJ_USER = '******' AND "
			cQuery    += "SZJ.D_E_L_E_T_=' ' "
		
			cQuery := ChangeQuery(cQuery)
		
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSZJ)
		
			If (cAliasSZJ)->NREG > 0
				lRetorno := .T.
			EndIf
			(cAliasSZJ)->(dbCloseArea())
		
		
		
			cAliasSZJ := "MAVLDSOLIC"
			lQuery    := .T.
			cQuery    := "SELECT ZJ_FILIAL,ZJ_USER,ZJ_GRUSER,ZJ_PRODUTO "
			cQuery    += "FROM "+RetSqlName("SZJ")+" SZJ "
			cQuery    += "WHERE SZJ.ZJ_FILIAL='"+xFilial("SZJ")+"' AND "
			cQuery    += "SZJ.ZJ_USER IN ('******','"+cUser+"') AND "
			If !Empty( aGrupo )
				cQuery    += "SZJ.ZJ_GRUSER IN ('******'"
				For nX := 1 To Len(aGrupo)
					cQuery += ",'"+aGrupo[nX]+"'"
				Next nX
				cQuery += ") AND "
			Else
				cQuery    += "SZJ.ZJ_GRUSER = '******' AND "
			Endif
			cQuery    += "(SZJ.ZJ_PRODUTO='* ' OR SZJ.ZJ_PRODUTO='"+SB1->B1_COD+"') AND "
			cQuery    += "SZJ.D_E_L_E_T_=' ' "
		
			cQuery := ChangeQuery(cQuery)
		
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSZJ)
		
			If Eof() .and. cFuncao == "MATA110"
				lRetorno := .T.
			Endif
		
			While !Eof() .And. (cAliasSZJ)->ZJ_FILIAL == xFilial("SZJ")
				If AllTrim(ZJ_GRUSER) == "******" .Or. AllTrim(ZJ_USER) $ "******|"+cUser
				
					If cFuncao == "MATA121"
					
						cHelp := "Produto não autorizado para inclusão"+CHR(13)+CHR(10)+"através de pedido de compras."+CHR(13)+CHR(10)+"Incluir na opção: Solicitação de Compras."
						If Alltrim((cAliasSZJ)->ZJ_PRODUTO)=="*" .or. (cAliasSZJ)->ZJ_PRODUTO == SB1->B1_COD
							lRetorno := .T.
						EndIf
					
						If (cAliasSZJ)->ZJ_USER<>'******' .And. AllTrim((cAliasSZJ)->ZJ_PRODUTO)=="*"
							lRetorno := .T.
						EndIf
					
					Elseif cFuncao == "MATA110"
					
						cHelp := "Produto não autorizado para inclusão"+CHR(13)+CHR(10)+"através de solicitação de compras."+CHR(13)+CHR(10)+"Incluir na opção: Pedido de Compras"
						If Alltrim((cAliasSZJ)->ZJ_PRODUTO)=="*" .or. (cAliasSZJ)->ZJ_PRODUTO == SB1->B1_COD
							lRetorno := .F.
						Else
							lRetorno := .T.
						EndIf
					Endif
				
				Endif
			
				dbSelectArea(cAliasSZJ)
				dbSkip()
			EndDo
		
			(cAliasSZJ)->(dbCloseArea())
		
			dbSelectArea("SZJ")
		
		Else
			lRetorno := .F.
		EndIf
	Else
		lRetorno := .T.
	EndIf

	// Sergio em Dez/2006: Caso a rotina seja executada via aprovacao de Solicitacao de Compras, nao se faz
	//                     necessario esta validacao.
	// Verifica se a chamada nao tem origem na liberacao da SC. So deve efetuar as validacoes caso esta rotina
	// nao esteja sendo chamada pela liberacao de SC:

	If !IsInCallStack("MT110BLO")
	
		If cFuncao == "MATA121"
			cHelp := "Produto não autorizado para inclusão"+CHR(13)+CHR(10)+"através de pedido de compras."+CHR(13)+CHR(10)+"Incluir na opção: Solicitação de Compras."
		ElseIf cFuncao == "MATA110"
			cHelp := "Produto não autorizado para inclusão"+CHR(13)+CHR(10)+"através de solicitação de compras."+CHR(13)+CHR(10)+"Incluir na opção: Pedido de Compras"
		Endif
	    If !Empty( GdFieldGet('C7_NUMSC') )
	       lRetorno := .t. 
	    EndIf
		If lHelp .And. !lRetorno
			Help("  ",1,"xRESTR",,cHelp,1,0)			
		EndIf
	
	Else
		lRetorno:= .T. //cristian fev/07
	EndIf

	RestArea(aAreaSZJ)
	RestArea(aArea)
Else
	lRetorno:= .T.
EndIf

Return(lRetorno)