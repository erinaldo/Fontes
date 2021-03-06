#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Ponto de  � xCsuAPro �Autor  � Leonardo Soncin       �Data  �23/11/2006���
���Entrada   �          �       �                       �      �          ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao �Validacao do Codigo do Produto na Solicitacao de Compras.   ���
���          �Para n�o permitir que sejam incluidos produtos nao autoriz. ���
�������������������������������������������������������������������������Ĵ��
���Uso       �Especifico CSU                                              ���
�������������������������������������������������������������������������Ĵ��
���           Atualiza�oes sofridas desde a constru�ao inicial            ���
�������������������������������������������������������������������������Ĵ��
���Programador �Data      �Motivo da Altera�ao                            ���
�������������������������������������������������������������������������Ĵ��
���            |          |                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � xVldSol  � Autor � Leonardo Soncin       � Data �16/11/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Validacao para controle de usuarios x produtos.            ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Codigo do produto.                                 ���
���          � ExpA1 = Array contendo os grupos do usuario.               ���
���          � ExpC1 = Codigo do usuario a ser verificado.                ���
���          � ExpL1 = Variavel que controla a exibicao dos helps.        ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � RetL1 = .T. - usuario/grupo com permissao ao produto.      ���
���          � RetL1 = .F. - usuario/grupo sem permissao ao produto.      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico.                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
	//����������������������������������������������������������Ŀ
	//� Verifica se h� controle de solicitante                   �
	//������������������������������������������������������������
		dbSelectArea("SZJ")
		dbSetOrder(1)
		If !MsSeek(xFilial("SZJ"))
			lContinua := .F.
		Endif
	
		If lContinua
		
			dbSelectArea("SB1")
			dbSetOrder(1)
			MsSeek(xFilial()+cProduto)
			//����������������������������������������������������������Ŀ
			//� Verifica os direitos dos Grupos de usuarios.             �
			//������������������������������������������������������������
		
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
					
						cHelp := "Produto n�o autorizado para inclus�o"+CHR(13)+CHR(10)+"atrav�s de pedido de compras."+CHR(13)+CHR(10)+"Incluir na op��o: Solicita��o de Compras."
						If Alltrim((cAliasSZJ)->ZJ_PRODUTO)=="*" .or. (cAliasSZJ)->ZJ_PRODUTO == SB1->B1_COD
							lRetorno := .T.
						EndIf
					
						If (cAliasSZJ)->ZJ_USER<>'******' .And. AllTrim((cAliasSZJ)->ZJ_PRODUTO)=="*"
							lRetorno := .T.
						EndIf
					
					Elseif cFuncao == "MATA110"
					
						cHelp := "Produto n�o autorizado para inclus�o"+CHR(13)+CHR(10)+"atrav�s de solicita��o de compras."+CHR(13)+CHR(10)+"Incluir na op��o: Pedido de Compras"
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
			cHelp := "Produto n�o autorizado para inclus�o"+CHR(13)+CHR(10)+"atrav�s de pedido de compras."+CHR(13)+CHR(10)+"Incluir na op��o: Solicita��o de Compras."
		ElseIf cFuncao == "MATA110"
			cHelp := "Produto n�o autorizado para inclus�o"+CHR(13)+CHR(10)+"atrav�s de solicita��o de compras."+CHR(13)+CHR(10)+"Incluir na op��o: Pedido de Compras"
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