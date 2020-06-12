#INCLUDE "RWMAKE.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CIEE001   º Autor ³ Rubens Lacerda     º Data ³  04/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao de cadastro de documentos                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CCIE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CIEE001

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cCadastro := "Cadastro de Documentos"
Private aCores     := {}
aCores := {	{'PA1_STATUS == I'    , "BR_VERMELHO" 	},;	// INATIVO
			{'PA1_STATUS == A'    , "BR_VERDE" 		}}	// ATIVO

Private aRotina := {	{ "Pesquisar"	, "AxPesqui"												, 0, 1 },;
						{ "Visualizar"  , "AxVisual"   												, 0, 2 },;
						{ "Incluir"     , "AxInclui( 'PA1',PA1->(RECNO()),3,,,,'U_CIE01TOK()' )" 	, 0, 3 },;
						{ "Alterar"     , "AxAltera( 'PA1',PA1->(RECNO()),4,,,,,'U_CIE01TOK()')" 	, 0, 4 },;
						{ "Excluir"     , "AxDeleta"   	 											, 0, 5 },;
						{ "Legenda"     , 'u_PA1Legend()' 											, 0, 2 }}

Private cDelFunc := "u_CIE01D()"
Private cString := "PA1"

dbSelectArea( "PA1" )
dbSetOrder( 1 )

dbSelectArea( cString )
mBrowse( ,,,, cString,, 'PA1_STATUS == "I"' )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CIEE004   ºAutor  ³Microsiga           º Data ³  10/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao que testa se pode deletar o documento selecionado            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function CIE01D()

Local aArea  := GetArea()
Local lExist := .T.

dbSelectArea( "PA4" )
dbSetOrder( 4 )

If dbSeek( xFilial( "PA4" ) + PA1->PA1_COD )
	APMsgStop( "Este registro não pode ser excluido.", 'ATENÇÃO' )
	lExist := .F.
EndIf

RestArea( aArea )
Return lExist

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ PA1LEGENDºAutor  ³ Rubens Lacerda     º Data ³  17/11/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para exibicao da legenda                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE 						                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PA1Legend()
Local aCores := {	{"BR_VERDE"     , "Ativo"	},;
					{"BR_VERMELHO"  , "Inativo"	}}

BrwLegenda( cCadastro, "Legenda", aCores )

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ CIE01TOK ºAutor  ³ Rubens Lacerda     º Data ³  17/11/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao Tudo Ok				                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE 						                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CIE01TOK()

Local lRet       := .T.

If lRet
	//TESTA SE O CNPJ FOI PREECHIDA
	If M->PA1_TPDOC == '01'
		If EMPTY( M->PA1_CNPJ )
			lRet := .F.
			ApMsgStop( 'Preencha as informacoes na pasta CNPJ.', 'ATENÇÃO' )
		ElseIf LEN(ALLTRIM(M->PA1_CNPJ)) <> 14
			lRet := .F.
			ApMsgStop( 'CNPJ inválido. Favor Preencher as informacoes na pasta CNPJ.', 'ATENÇÃO' )
		Endif
	EndIf
	//TESTA SE O ALVARA FOI PREECHIDA
	If M->PA1_TPDOC == '02' .AND. EMPTY( M->PA1_ALVA )
		lRet := .F.
		ApMsgStop( 'Preencha as informacoes na pasta ALVARA.', 'ATENÇÃO' )
	EndIf
	//TESTA SE O ISSQN FOI PREECHIDA
	If M->PA1_TPDOC == '03' .AND. EMPTY( M->PA1_ISIND )
		lRet := .F.
		ApMsgStop( 'Preencha as informacoes na pasta ISS QN.', 'ATENÇÃO' )
	EndIf
	//TESTA SE O CMAS/CEAS FOI PREECHIDA
	If M->PA1_TPDOC == '04' .AND. EMPTY( M->PA1_ATEST )
		lRet := .F.
		ApMsgStop( 'Preencha as informacoes na pasta CMAS/CEAS.', 'ATENÇÃO' )
	EndIf
	//TESTA SE A UTIL PUBLI FOI PREECHIDA
	If M->PA1_TPDOC == '05' .AND. EMPTY( M->PA1_UTIL )
		lRet := .F.
		ApMsgStop( 'Preencha as informacoes na pasta Util Publica.', 'ATENÇÃO' )
	EndIf
	//TESTA SE O CMDCA FOI PREENCHIDO
	If M->PA1_TPDOC == '06' .AND. EMPTY( M->PA1_CMDCA )
		lRet := .F.
		ApMsgStop( 'Preencha as informacoes na pasta CMDCA.', 'ATENÇÃO' )
	EndIf
	//TESTA SE O DOCUMENTOS DIVERSOS FOI PREENCHIDO
	If M->PA1_TPDOC == '07' .AND. EMPTY( M->PA1_DOCDIV )
		lRet := .F.
		ApMsgStop( 'Preencha as informacoes na pasta Docto Diversos.', 'ATENÇÃO' )
	EndIf
	//TESTA SE TODOS FORAM PREENCHIDOS
	If M->PA1_TPDOC == '99'
		Do Case
			Case EMPTY( M->PA1_CNPJ )
				lRet := .F.
				ApMsgStop( 'Preencha as informacoes na pasta CNPJ.', 'ATENÇÃO' )
			Case EMPTY( M->PA1_ALVA )
				lRet := .F.
				ApMsgStop( 'Preencha as informacoes na pasta ALVARA.', 'ATENÇÃO' )
			Case EMPTY( M->PA1_ISIND )
				lRet := .F.
				ApMsgStop( 'Preencha as informacoes na pasta ISS QN.', 'ATENÇÃO' )
			Case EMPTY( M->PA1_ATEST )
				lRet := .F.
				ApMsgStop( 'Preencha as informacoes na pasta CMAS/CEAS.', 'ATENÇÃO' )
			Case EMPTY( M->PA1_UTIL )
				lRet := .F.
				ApMsgStop( 'Preencha as informacoes na pasta Util Publica.', 'ATENÇÃO' )
			Case EMPTY( M->PA1_CMDCA )
				lRet := .F.
				ApMsgStop( 'Preencha as informacoes na pasta CMDCA.', 'ATENÇÃO' )
			Case EMPTY( M->PA1_DOCDIV )
				lRet := .F.
				ApMsgStop( 'Preencha as informacoes na pasta Doctos Diversos.', 'ATENÇÃO' )
		EndCase
	EndIf
	
EndIf

Return lRet