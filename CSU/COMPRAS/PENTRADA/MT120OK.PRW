#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±			                                                               ±±
±± Funcao: MT120OK	 	Autor: Tatiana A. Barbosa	Data: 28/07/10	       ±±
±±																		   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±						  												   ±±
±±	Descricao: Ponto de Entrada para validação do pedido no botão OK	   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± 																		   ±±
±±			Alteracoes:   OS 1979/10								 	   ±±
±±																		   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±															  			   ±±
±±				Uso:  CSU 	                                               ±±
±±												  						   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function MT120OK()

Local lRetorno		:= .T.
Local aArea 		:= GetArea()
Local cUser 		:= RetCodUsr()
Local aGrupo 		:= UsrGrComp(RetCodUsr())            
Local nPosPrd  		:= ASCAN(aHeader,{|x| AllTrim(x[2]) == "C7_PRODUTO"})           
Local nPosxFilEnt  	:= ASCAN(aHeader,{|x| AllTrim(x[2]) == "C7_XFILENT"})           //Tatiana
Local _xFilial		:= SC7->C7_XFILENT

Private CCBloqPedCom  := 0

If IsInCallStack("MATA110")  // Inserido para atender o parecer da OS que pede para não tratar na geração automatica
							 // do Spot@ - Renato Carlos	
   Return .T.
EndIf

If "RPC"$FunName() 
	Return(.t.)
EndIf

If Len(aGrupo) > 0 .Or. AllTrim(Upper(FunName())) == "CNTA120"
	lRetorno	:= .T.
Else

	//******************************************//	
	//		Validação dos itens do pedido		//
	//******************************************//
	
	For nX :=1 To Len( aCols )		
		If ( !aCols[nx][Len(aCols[nX])] .And. !Empty(aCols[nX][nPosPrd]) )		
			lRetorno := u_xVldUsuProd(aCols[nX][nPosPrd],aGrupo,cUser,.T.)						
		Else
			aCols[nX][Len(aHeader)+1] := .T.
		EndIf          
			
	Next nX
		
Endif

If Inclui

	For nY :=1 To Len( aCols )		
	
		aCols[nY][nPosxFilEnt]	:=	cFilialEnt		     //Tatiana - Faz a gravação da filial de entrega do pedido de compra
	                           
	Next nY

EndIf

If Altera                  

	For nY :=1 To Len( aCols )		
	
		aCols[nY][nPosxFilEnt]	:=	_xFilial			     //Tatiana - Faz a gravação da filial de entrega do pedido de compra
	                           
	Next nY

EndIf

If lRetorno .And. AllTrim(Upper(FunName())) <> "CNTA120"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Validacao do Fornecedor junto ao modulo de contratos-----OS 3278/10³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	_cQuery := "SELECT COUNT(*) CONTRA FROM " + RetSqlName("CN9") + " CN9, " + RetSqlName("CNC") + " CNC WHERE "
	_cQuery += "CN9.CN9_FILIAL = '" + xFilial("CN9") + "' AND "
	_cQuery += "CN9.CN9_NUMERO = CNC.CNC_NUMERO AND "
	_cQuery += "CN9.D_E_L_E_T_ = ' ' AND "
	_cQuery += "CN9.CN9_SITUAC = '05' AND "
	_cQuery += "CNC.CNC_FILIAL = '" + xFilial("CNC") + "' AND "
	_cQuery += "CNC.CNC_CODIGO = '" + cA120Forn + "' AND "
	_cQuery += "CNC.CNC_LOJA = '" + cA120Loj + "' AND "
	_cQuery += "CNC.D_E_L_E_T_ = ' '"
	
	U_MontaView(_cQuery,"GCT")
	
	GCT->(dbGoTop())
	If GCT->CONTRA > 0
		If MsgYesNo("Existe(m) contrato(s) vigente(s) para este fornecedor, verifique se o pedido que esta sendo confirmado deve ser gerado pelo módulo de Gestão de Contratos." + Chr(10) + Chr(13) +;
					"Deseja Continuar com a Inclusão do Pedido?","Atenção!!!")
			lRetorno := .T.
		Else
			lRetorno := .F.
		EndIf
	EndIf
	
	GCT->(dbCloseArea())
EndIf

RestArea(aArea)
Return lRetorno


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±			                                                               ±±
±± Funcao: xVldUsuProd 	Autor: Tatiana A. Barbosa	Data: 28/07/10	       ±±
±±																		   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±						  												   ±±
±±	Descricao: Validacao para controle de usuarios x produtos			   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± 																		   ±±
±±			Alteracoes:   OS 1979/10								 	   ±±
±±																		   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±															  			   ±±
±±				Uso:  CSU 	                                               ±±
±±												  						   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function xVldUsuProd(cProduto,aGrupo,cUser,lHelp)

Local aArea      	:= GetArea()
Local aAreaSZJ   	:= SZJ->(GetArea())
Local aUser      	:= {}
Local lRetorno   	:= .F.
Local lRestricao 	:= .F.
Local nX         	:= 1
Local lContinua  	:= .T.

Local cQuery     	:= ""
Local lQuery     	:= .F.
Local cAliasSZJ  	:= "SZJ"    

Local _cProd	 	:= cProduto   

aUser    := {"******",cUser}

If AllTrim(Upper(FunName())) == "RIMPA081"  // Inserido para atender a OS 3172/11
	Return .T.
EndIf


If !Empty(cProduto)

	//******************************************//
	//	Verifica se há controle de solicitante  //
	//******************************************//

	dbSelectArea("SZJ")
	dbSetOrder(1)
	If !MsSeek(xFilial("SZJ"))
		lContinua := .F.
	Endif
	
	If lContinua
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		MsSeek(xFilial()+cProduto)

		//**********************************************//
		// Verifica os direitos dos Grupos de usuarios  //
		//*********************************************//		          
		
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
		//AKI
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
		cQuery    += "SZJ.D_E_L_E_T_=' ' "
		
		cQuery := ChangeQuery(cQuery)
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSZJ)
		
		While !Eof() .And. (cAliasSZJ)->ZJ_FILIAL == xFilial("SZJ")
			If AllTrim(ZJ_GRUSER) == "******" .Or. AllTrim(ZJ_USER) $ "******|"+cUser
				If Alltrim((cAliasSZJ)->ZJ_PRODUTO)=="*" .And. !lRestricao
					lRetorno := .T.
				EndIf
				If (cAliasSZJ)->ZJ_PRODUTO == SB1->B1_COD .And. !lRestricao
					lRetorno := .T.
				EndIf
				If (cAliasSZJ)->ZJ_PRODUTO == SB1->B1_COD
					lRetorno := .F.
					lRestricao := .T.
				EndIf
				If (cAliasSZJ)->ZJ_PRODUTO == SB1->B1_COD
					lRetorno := .T.
					lRestricao := .T.
				EndIf
				If (cAliasSZJ)->ZJ_USER<>'******' .And. AllTrim((cAliasSZJ)->ZJ_PRODUTO)=="*"
					lRetorno := .T.
					lRestricao := .T.
				EndIf
			EndIf
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

If lHelp .And. !lRetorno                              
	MsgAlert("A solicitação do produto ( " +Alltrim(_cProd)+ " ) está restrita"+CHR(13)+CHR(10)+"aos usuários autorizados no cadastro"+CHR(13)+CHR(10)+"de amarração Usuários X Produtos.","xRESTR")     
	CCBloqPedCom ++
EndIf
                        
If CCBloqPedCom > 0
	lRetorno := .F.
Else
	lRetorno := .T.
EndIf

RestArea(aAreaSZJ)
RestArea(aArea)

Return(lRetorno)