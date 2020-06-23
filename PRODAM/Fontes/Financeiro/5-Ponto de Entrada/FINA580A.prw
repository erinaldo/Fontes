#Include 'Protheus.ch'
#Include 'topconn.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FINA580A  � Autor � Felipe Santos        � Data � 12/09/15 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o � O ponto de entrada FINA580A ser� executado no momento     ���
��� da grava��o do SE2 na libera��o manual e autom�tica			   		  ���
�����������������������������������������������������������������������������
���Sintaxe   �							            					  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FINA580A()

Local nRetOrdem := BuscaOrdem(SE2->E2_NUM, SE2->E2_VENCREA)  
Local nNumOrd   := 0
Local lRet      := .T.
Local nRecSe2 	:= SE2->(Recno())
Local cTpOrdCro := ""

FSAtuSX6() //Cria Parametro abaixo

cTpOrdCro := GetMv("ES_ORDCRO")//Tipo de Titulos que devem entrar na Ordem Cronologica da Liberacao de Pagamento

If nRetOrdem >=0 //caso o campo D2_XORDLIB for maior que 0 ent�o conta mais 1
	nNumOrd := nRetOrdem + 1
EndIf

If alltrim(SE2->E2_TIPO) $ cTpOrdCro
	//ALTERA VALOR DO CAMPO E2_XORDLIB 
	RECLOCK("SE2",.F.)
	SE2->E2_XORDLIB := ALLTRIM(STRZERO(nNumOrd,3,0))
	MSUNLOCK()
EndIf
	 	
//Reordena items
ReordenaTitl(SE2->E2_VENCREA)

Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � BuscaUltOrdem � Autor � Felipe Santos    � Data � 12/09/15 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o � Busca �ltima  E2_XORDLIB do dia     ���
�����������������������������������������������������������������������������
���Sintaxe   �							            					  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function BuscaOrdem(cNum, cVencReal)

Local cQuery	:= ""
Local nCount    := 0

cQuery:= " SELECT MAX(E2_XORDLIB) AS  E2_XORDLIB "+CRLF
cQuery+= " FROM "+RetSqlName("SE2")+" SE2 "+CRLF
cQuery+= " WHERE SE2.E2_VENCREA = '"+DTOS(cVencReal)+"' "+CRLF
cQuery+= " AND SE2.E2_XORDLIB <> '' "+CRLF
cQuery+= " AND SE2.E2_BAIXA = '' "+CRLF
cQuery+= " AND SE2.E2_FILIAL = '"+xFilial("SE2")+"'"+CRLF
cQuery+= " AND SE2.D_E_L_E_T_ = '' "+CRLF

cQuery := changequery(cQuery) 

dbUsearea(.T.,"TOPCONN",TCGenQry(,,cQuery), "TMPQRY") 

While !Eof()      
	nCount := VAL(TMPQRY->E2_XORDLIB)	
	dbSkip()
Enddo 

TMPQRY->(DbCloseArea()) 

Return nCount     



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ReordenaTitl   � Autor � Felipe Santos    � Data � 12/09/15 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o � Busca �ltima  E2_XORDLIB do dia     ���
�����������������������������������������������������������������������������
���Sintaxe   �							            					  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ReordenaTitl(cVencReal)
Local cQuery	:= ""
Local nNumOrd   := 0

cQuery:= " SELECT SE2.E2_FILIAL, SE2.E2_PREFIXO, SE2.E2_NUM, SE2.E2_PARCELA, SE2.E2_TIPO "+CRLF
cQuery+= " FROM "+RetSqlName("SE2")+" SE2 "+CRLF
cQuery+= " WHERE SE2.E2_VENCREA = '"+DTOS(cVencReal)+"' "+CRLF
cQuery+= " AND SE2.E2_XORDLIB <> '' "+CRLF
cQuery+= " AND SE2.E2_BAIXA = '' "+CRLF
cQuery+= " AND SE2.D_E_L_E_T_ = '' "+CRLF
cQuery+= " AND SE2.E2_FILIAL = '"+xFilial("SE2")+"'"+CRLF
cQuery+= " ORDER BY E2_VALOR "+CRLF

cQuery := changequery(cQuery) 

dbUsearea(.T.,"TOPCONN",TCGenQry(,,cQuery), "TMPQ") 

While !Eof() 

    nNumOrd := nNumOrd + 1 
    cQueryTcSql := "UPDATE "+RetSqlName("SE2")+ " SET E2_XORDLIB = '"+ALLTRIM(STRZERO(nNumOrd,3,0))+"' WHERE E2_NUM='"+TMPQ->E2_NUM+"' AND E2_FILIAL='"+TMPQ->E2_FILIAL+"' AND E2_PREFIXO='"+TMPQ->E2_PREFIXO+"' AND E2_PARCELA='"+TMPQ->E2_PARCELA+"'"
	If TCSQLEXEC(cQueryTcSql) < 0
		MsgInfo("Erro ao atualizar o campo  E2_XORDLIB, verifique com o administrador do sistema")
	EndIf
	
	dbSkip()
Enddo 

TMPQ->(DbCloseArea()) 

Return                                   	

//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSX6
Fun��o de processamento da grava��o do SX6 - Par�metros

@author TOTVS Protheus
@since  07/01/2016
@obs    Gerado por EXPORDIC - V.4.25.11.9 EFS / Upd. V.4.20.13 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSX6()
Local aEstrut   := {}
Local aSX6      := {}
Local cAlias    := ""
Local cMsg      := ""
Local lContinua := .T.
Local lReclock  := .T.
Local lTodosNao := .F.
Local lTodosSim := .F.
Local nI        := 0
Local nJ        := 0
Local nOpcA     := 0
Local nTamFil   := Len( SX6->X6_FIL )
Local nTamVar   := Len( SX6->X6_VAR )

//AutoGrLog( "�nicio da Atualiza��o" + " SX6" + CRLF )

aEstrut := { "X6_FIL"    , "X6_VAR"    , "X6_TIPO"   , "X6_DESCRIC", "X6_DSCSPA" , "X6_DSCENG" , "X6_DESC1"  , ;
             "X6_DSCSPA1", "X6_DSCENG1", "X6_DESC2"  , "X6_DSCSPA2", "X6_DSCENG2", "X6_CONTEUD", "X6_CONTSPA", ;
             "X6_CONTENG", "X6_PROPRI" , "X6_VALID"  , "X6_INIT"   , "X6_DEFPOR" , "X6_DEFSPA" , "X6_DEFENG" , ;
             "X6_PYME"   }

aAdd( aSX6, { ;
	'  '																	, ; //X6_FIL
	'ES_ORDCRO'															, ; //X6_VAR
	'C'																		, ; //X6_TIPO
	'Tipo de Titulos que devem entrar na Ordem'						, ; //X6_DESCRIC
	''																		, ; //X6_DSCSPA
	''																		, ; //X6_DSCENG
	'Cronologica da Liberacao de Pagamento'   						, ; //X6_DESC1
	''																		, ; //X6_DSCSPA1
	''																		, ; //X6_DSCENG1
	''																		, ; //X6_DESC2
	''																		, ; //X6_DSCSPA2
	''																		, ; //X6_DSCENG2
	"'NF','BOL'"																	, ; //X6_CONTEUD
	''						, ; //X6_CONTSPA
	''						, ; //X6_CONTENG
	'U'																		, ; //X6_PROPRI
	''																		, ; //X6_VALID
	''																		, ; //X6_INIT
	''																		, ; //X6_DEFPOR
	''																		, ; //X6_DEFSPA
	''																		, ; //X6_DEFENG
	''																		} ) //X6_PYME

//
// Atualizando dicion�rio
//
//oProcess:SetRegua2( Len( aSX6 ) )

dbSelectArea( "SX6" )
dbSetOrder( 1 )

For nI := 1 To Len( aSX6 )
	lContinua := .F.
	lReclock  := .F.

	If !SX6->( dbSeek( PadR( aSX6[nI][1], nTamFil ) + PadR( aSX6[nI][2], nTamVar ) ) )
		lContinua := .T.
		lReclock  := .T.
		//AutoGrLog( "Foi inclu�do o par�metro " + aSX6[nI][1] + aSX6[nI][2] + " Conte�do [" + AllTrim( aSX6[nI][13] ) + "]" )
	EndIf

	If lContinua
		If !( aSX6[nI][1] $ cAlias )
			cAlias += aSX6[nI][1] + "/"
		EndIf

		RecLock( "SX6", lReclock )
		For nJ := 1 To Len( aSX6[nI] )
			If FieldPos( aEstrut[nJ] ) > 0
				FieldPut( FieldPos( aEstrut[nJ] ), aSX6[nI][nJ] )
			EndIf
		Next nJ
		dbCommit()
		MsUnLock()
	EndIf

	//oProcess:IncRegua2( "Atualizando Arquivos (SX6)..." )

Next nI

//AutoGrLog( CRLF + "Final da Atualiza��o" + " SX6" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL
