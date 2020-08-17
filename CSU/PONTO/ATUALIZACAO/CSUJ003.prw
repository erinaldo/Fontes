#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ CSUJ003  ºAutor  ³ Ernani Forastieri  º Data ³  13/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Monitor de exportacoes                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CSUJ003() 
Private nUsado     := 0
Private cCadastro  := 'Monitor Interface Ponto Eletronico'
Private aRotina    := {} 
Private aCores     := {} 
Private cPula      := Chr( 13 ) + Chr( 10 ) 
Private oTimer     := NIL
Private cFilPA4    := ''
Private cFilPA5    := ''

aAdd( aRotina , { 'Pesquisar'   , 'AxPesqui'     , 0, 1 } ) //'Pesquisar'
aAdd( aRotina , { 'Visualizar'  , 'u_PA4Visual'  , 0, 2 } ) //'Visualizar'
//aAdd( aRotina , { 'Incluir'     , 'u_PA4Inclui'    , 0, 3 } ) //'Incluir'
//aAdd( aRotina , { 'Alterar'     , 'u_PA4Altera'    , 0, 4 } ) //'Alterar'
//aAdd( aRotina , { 'Excluir'     , 'u_PA4Exclui'    , 0, 5 } ) //'Excluir'
aAdd( aRotina , { 'Legenda'     , 'u_PA4Legend'  , 0, 2 } ) //'Legenda'

dbSelectArea( 'PA5' ) 
dbSetOrder( 1 ) 
cFilPA5 := xFilial( 'PA5' ) 

dbSelectArea( 'PA4' ) 
dbSetOrder( 1 ) 
cFilPA4 := xFilial( 'PA4' ) 

dbSelectArea( 'PA4' ) 
//mBrowse( ,,,, 'PA4',,,, 'PA4_STATUS',, aCores ,,, 4, { | x | u_PA4Timer( @oTimer, x ) } ) 
mBrowse( ,,,, 'PA4',, 'PA4_STATUS=="2"',,,,,,,, { | x | u_PA4Timer( @oTimer, x ) } ) 
Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ PA4VISUALºAutor  ³ Ernani Forastieri  º Data ³  13/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para visualizacao do cadastro                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PA4Visual( cAlias, nRecNo, nOpc ) 
Local   nX        := 0
Local   nCols     := 0
Local   nOpcTela  := 0
Local   cChave    := ''
Local   bCampo    := { | nField | Field( nField ) } 
Private oGet      := NIL
Private aHeader   := {} 
Private aCols     := {} 
Private aTela     := {} 
Private aGets     := {} 

//
// Inicia as variaveis para Enchoice
//
dbSelectArea( 'PA4' ) 
dbSetOrder( 1 ) 
dbGoTo( nRecNo ) 
cChave := PA4->PA4_ID

For nX := 1 To FCount() 
	M->&( EVal( bCampo, nX ) ):= FieldGet( nX ) 
Next nX

//
// Monta o aHeader
//
CriaHeader() 

//
// Monta o aCols
//
dbSelectArea( 'PA5' ) 
dbSetOrder( 1 ) 
dbSeek( cFilPA5 + cChave ) 

While !EOF() .AND. ( cFilPA5 + cChave ) == PA5->( PA5_FILIAL + PA5->PA5_ID ) 
	aAdd( aCols, Array( nUsado + 1 ) ) 
	nCols++ 
	
	For nX := 1 To nUsado
		If ( aHeader[nX][10] != 'V' ) 
			aCols[nCols][nX] := FieldGet( FieldPos( aHeader[nX][2] ) ) 
		Else
			aCols[nCols][nX] := CriaVar( aHeader[nX][2], .T. ) 
		EndIf
	Next nX
	
	aCols[nCols][nUsado + 1] := .F.
	dbSelectArea( 'PA5' ) 
	dbSkip() 
End

PA4Tela( cAlias, nRecNo, nOpc, cCadastro, aCols, aHeader ) 

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ PA4DATA	ºAutor  ³ Rubens Lacerda     º Data ³  21/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para verificacao da data de vencimento              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PA4DATA( _dDtAb, _dDtVct ) 
Local lRet := .T.

If _dDtAb > _dDtVct
	MsgInfo( 'Data de vencimento menor que data de cadastro', 'Data Vencimento' ) 
	lRet := .F.
EndIf

Return( lRet ) 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ PA4INCLUIºAutor  ³ Ernani Forastieri  º Data ³  13/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para inclusao     do cadastro                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PA4Inclui( cAlias, nRecNo, nOpc ) 
Local   nX        := 0
Local   nCols     := 0
Local   nOpcTela  := 0
Local   cChave    := ''
Local   bCampo    := { | nField | Field( nField ) } 
Private oGet      := NIL
Private aHeader   := {} 
Private aCols     := {} 
Private aTela     := {} 
Private aGets     := {} 

//
// Cria Variaveis de Memoria da Enchoice
//
dbSelectArea( 'PA4' ) 
For nX := 1 To FCount() 
	M->&( EVal( bCampo, nX ) ):= CriaVar( FieldName( nX ) , .T. ) 
Next nX

//
// Monta o aHeader
//
CriaHeader() 

//
// Monta o aCols
//
aAdd( aCols, Array( nUsado + 1 ) ) 

nUsado := 0
dbSelectArea( 'SX3' ) 
dbSetOrder( 1 ) 
dbSeek( 'PA5' ) 
While !EOF() .AND. SX3->X3_ARQUIVO == 'PA5'
	If X3USO( SX3->X3_USADO ) .AND. cNivel >= SX3->X3_NIVEL
		nUsado++ 
		aCols[1][nUsado] := CriaVar( Trim( SX3->X3_CAMPO ) , .T. ) 
	EndIf
	dbSkip() 
End

aCols[1][nUsado + 1] := .F.

If  PA4Tela( cAlias, nRecNo, nOpc, cCadastro, aCols, aHeader ) 
	Begin Transaction
	If PA4Grava( nOpc,, ) 
		EvalTrigger() 
		If __lSX8
			ConFirmSX8() 
		EndIf
	EndIf
	End Transaction
Else
	If __lSX8
		RollBackSX8() 
	EndIf
EndIf

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ PA4ALTERAºAutor  ³ Ernani Forastieri  º Data ³  13/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para alteracao    do cadastro                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PA4Altera( cAlias, nRecNo, nOpc ) 
Local   nX        := 0
Local   nCols     := 0
Local   nOpcTela  := 0
Local   cChave    := ''
Local   bCampo    := { | nField | Field( nField ) } 
Local   aAltera   := {} 
Private oGet      := NIL
Private aHeader   := {} 
Private aCols     := {} 
Private aTela     := {} 
Private aGets     := {} 

//
// Inicia as variaveis para Enchoice
//
dbSelectArea( 'PA4' ) 
dbSetOrder( 1 ) 
dbGoTo( nRecNo ) 
cChave := PA4->PA4_ID

For nX := 1 To FCount() 
	M->&( EVal( bCampo, nX ) ):= FieldGet( nX ) 
Next nX

//
// Monta o aHeader
//
CriaHeader() 

//
// Monta o aCols
//
dbSelectArea( 'PA5' ) 
dbSetOrder( 1 ) 
dbSeek( cFilPA5 + cChave ) 

While !EOF() .AND. ( cFilPA5 + cChave ) == PA5->( PA5->PA5_FILIAL + PA5->PA5_ID ) 
	aAdd( aCols, Array( nUsado + 1 ) ) 
	nCols++ 
	
	For nX := 1 To nUsado
		If ( aHeader[nX][10] != 'V' ) 
			aCols[nCols][nX] := FieldGet( FieldPos( aHeader[nX][2] ) ) 
		Else
			aCols[nCols][nX] := CriaVar( aHeader[nX][2], .T. ) 
		EndIf
	Next nX
	
	aCols[nCols][nUsado + 1] := .F.
	dbSelectArea( 'PA5' ) 
	aAdd( aAltera, Recno() ) 
	dbSkip() 
End

If  PA4Tela( cAlias, nRecNo, nOpc, cCadastro, aCols, aHeader ) 
	Begin Transaction
	If PA4Grava( nOpc, aAltera,  ) 
		EvalTrigger() 
		If __lSX8
			ConFirmSX8() 
		EndIf
	EndIf
	End Transaction
Else
	If __lSX8
		RollBackSX8() 
	EndIf
EndIf

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ PA4EXCLUIºAutor  ³ Ernani Forastieri  º Data ³  13/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para exclusao     do cadastro                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PA4Exclui( cAlias, nRecNo, nOpc ) 
Local   nX        := 0
Local   nCols     := 0
Local   nOpcTela  := 0
Local   cChave    := ''
Local   bCampo    := { | nField | Field( nField ) } 
Private oGet      := NIL
Private aHeader   := {} 
Private aCols     := {} 
Private aTela     := {} 
Private aGets     := {} 

//
// Inicia as variaveis para Enchoice
//
dbSelectArea( 'PA4' ) 
dbSetOrder( 1 ) 
dbGoTo( nRecNo ) 
cChave := PA4->PA4_ID

For nX := 1 To FCount() 
	M->&( EVal( bCampo, nX ) ):= FieldGet( nX ) 
Next nX

//
// Monta o aHeader
//
CriaHeader() 

//
// Monta o aCols
//
dbSelectArea( 'PA5' ) 
dbSetOrder( 1 ) 
dbSeek( cFilPA5 + cChave ) 

While !EOF() .AND. ( cFilPA5 + cChave ) == PA5->( PA5_FILIAL + PA5->PA5_ID ) 
	aAdd( aCols, Array( nUsado + 1 ) ) 
	nCols++ 
	
	For nX := 1 To nUsado
		If ( aHeader[nX][10] != 'V' ) 
			aCols[nCols][nX] := FieldGet( FieldPos( aHeader[nX][2] ) ) 
		Else
			aCols[nCols][nX] := CriaVar( aHeader[nX][2], .T. ) 
		EndIf
	Next nX
	
	aCols[nCols][nUsado + 1] := .F.
	dbSelectArea( 'PA5' ) 
	dbSkip() 
End

If  PA4Tela( cAlias, nRecNo, nOpc, cCadastro, aCols, aHeader ) 
	Begin Transaction
	If PA4Grava( nOpc,, ) 
		EvalTrigger() 
		If __lSX8
			ConFirmSX8() 
		EndIf
	EndIf
	End Transaction
Else
	If __lSX8
		RollBackSX8() 
	EndIf
EndIf

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³CRIAHEADERºAutor  ³ Ernani Forastieri  º Data ³  13/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para criacao do aHeader                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CriaHeader() 
nUsado  := 0
aHeader := {} 

dbSelectArea( 'SX3' ) 
dbSetOrder( 1 ) 
dbSeek( 'PA5' ) 
While ( !EOF() .AND. SX3->X3_ARQUIVO == 'PA5' ) 
	If ( X3USO( SX3->X3_USADO ) .AND. cNivel >= SX3->X3_NIVEL ) 
		aAdd( aHeader, { Trim( X3Titulo() ) , ;
		SX3->X3_CAMPO   , ;
		SX3->X3_PICTURE , ;
		SX3->X3_TAMANHO , ;
		SX3->X3_DECIMAL , ;
		SX3->X3_VALID   , ;
		SX3->X3_USADO   , ;
		SX3->X3_TIPO    , ;
		SX3->X3_ARQUIVO , ;
		SX3->X3_CONTEXT } ) 
		nUsado++ 
	EndIf
	dbSkip() 
End

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ PA4LINOK ºAutor  ³ Ernani Forastieri  º Data ³  13/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para validacao da Linha da GetDados                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PA4LinOk() 
Local aArea    := GetArea() 
Local aAreaSX3 := SX3->( GetArea() ) 
//Local cMsg     := ''
Local lRet     := .T.
//Local nI       := 0

RestArea( aAreaSX3 ) 
RestArea( aArea ) 

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ PA4LINOK ºAutor  ³ Ernani Forastieri  º Data ³  13/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para validacao da Linha da GetDados                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PA4CanDel() 
Local aArea    := GetArea() 
Local aAreaSX3 := SX3->( GetArea() ) 
//Local cMsg     := ''
Local lRet     := .T.
//Local nI       := 0
Local nPosOri := aScan( aHeader, { | X | AllTrim( x[2] ) == 'PA5_ORIGEM' } ) 
Static lFirst  := .T.
Static lret2   := .T.

If !lFirst
	lFirst  := .T.
	Return lRet2
EndIf

//.....

RestArea( aAreaSX3 ) 
RestArea( aArea ) 

If lFirst
	lFirst  := .F.
EndIf
Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ PA4TUDOK ºAutor  ³ Ernani Forastieri  º Data ³  13/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para validacao da Geral da GetDados                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Importacao/Exportacao de Tabelas                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PA4TudOk() 
Local aArea      := GetArea() 
Local aAreaPA4   := PA4->( GetArea() ) 
Local lRet       := .T.
//Local cMsg       := ''
//Local nCount     := 0
//Local nI         := 0


//...

RestArea( aAreaPA4 ) 
RestArea( aArea   ) 

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ PA4GRAVA ºAutor  ³ Ernani Forastieri  º Data ³  13/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para gravacao dos dados dos cadastros               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PA4Grava( nOpc, aAltera ) 
Local aArea    := GetArea() 
Local lGravou  := .F.
Local nUsado   := 0
Local nX       := 0
Local nI       := 0
Private bCampo := { | nField | FieldName( nField ) } 

nUsado    := Len( aHeader ) + 1

//
// Se For inclusao
//
If nOpc == 3
	//
	// Grava os itens
	//
	dbSelectArea( 'PA5' ) 
	dbSetOrder( 1 ) 
	For nX := 1 To Len( aCols ) 
		lDeletado := aCols[nX][nUsado]
		
		If !lDeletado
			RecLock( 'PA5', .T. ) 
			For nI := 1 To Len( aHeader ) 
				FieldPut( FieldPos( Trim( aHeader[nI, 2] ) ) , aCols[nX, nI] ) 
			Next nI
			PA5->PA5_FILIAL := cFilPA5
			PA5->PA5_ID    := M->PA4_ID
			MsUnLock() 
			lGravou := .T.
		EndIf
	Next
	
	//
	// Grava o Cabecalho
	//
	If lGravou
		dbSelectArea( 'PA4' ) 
		RecLock( 'PA4', .T. ) 
		For nX := 1 To FCount() 
			If 'FILIAL' $ FieldName( nX ) 
				FieldPut( nX, cFilPA4 ) 
			Else
				FieldPut( nX, M->&( EVal( bCampo, nX ) ) ) 
			EndIf
		Next
		MsUnLock() 
	EndIf
	
EndIf

//
// Se For alteracao
//
If nOpc == 4
	
	//
	// Grava os itens conforme as alteracoes
	//
	dbSelectArea( 'PA5' ) 
	dbSetOrder( 1 ) 
	
	For nX := 1 To Len( aCols ) 
		lDeletado := aCols[nX][nUsado]
		
		If nX <= Len( aAltera ) 
			dbGoTo( aAltera[nX] ) 
			RecLock( 'PA5', .F. ) 
			
			If lDeletado
				dbDelete() 
			EndIf
		Else
			If !lDeletado
				RecLock( 'PA5', .T. ) 
			EndIf
		EndIf
		
		If !lDeletado
			For nI := 1 To Len( aHeader ) 
				FieldPut( FieldPos( Trim( aHeader[nI, 2] ) ) , aCols[nX, nI] ) 
			Next nI
			PA5->PA5_FILIAL := cFilPA5
			PA5->PA5_ID    := M->PA4_ID
			MsUnLock() 
			lGravou := .T.
		EndIf
		
	Next
	
	//
	// Grava o Cabecalho
	//
	If lGravou
		dbSelectArea( 'PA4' ) 
		RecLock( 'PA4', .F. ) 
		For nX := 1 To FCount() 
			If 'FILIAL' $ FieldName( nX ) 
				FieldPut( nX, cFilPA4 ) 
			Else
				FieldPut( nX, M->&( EVal( bCampo, nX ) ) ) 
			EndIf
		Next
		MsUnLock() 
	Else
		dbSelectArea( 'PA4' ) 
		RecLock( 'PA4', .F. ) 
		dbDelete() 
		MsUnLock() 
	EndIf
EndIf

//
// Se For exclucao
//
If nOpc == 5
	
	//
	// Deleta os Itens
	//
	dbSelectArea( 'PA5' ) 
	dbSetOrder( 1 ) 
	cChave := M->PA4_ID
	dbSeek( cFilPA5, .T. ) 
	
	While !EOF() .AND. ( cFilPA5 + cChave ) == PA5->( PA5_FILIAL + PA5_ID ) 
		RecLock( 'PA5', .F. ) 
		dbDelete() 
		MsUnLock() 
		dbSkip() 
	End
	
	//
	// Deleta o Cabecalho
	//
	dbSelectArea( 'PA4' ) 
	RecLock( 'PA4' ) 
	dbDelete() 
	MsUnLock() 
	lGravou := .T.
EndIf

RestArea( aArea ) 

Return lGravou


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ PA4LEGENDºAutor  ³ Ernani Forastieri  º Data ³  13/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para exibicao da legenda                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PA4Legend() 
Local aCores := { ;
 { 'BR_VERDE'     , 'Processo Ok'     } , ;
 { 'BR_VERMELHO'  , 'Processo Não OK' } } 

BrwLegenda( cCadastro, 'Legenda', aCores ) //'Legenda'

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ PA4TELA  ºAutor  ³ Ernani Forastieri  º Data ³  13/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para montagek da tela da Enchoice /Getdados         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PA4Tela( cAlias, nRecNo, nOpc, cCadastro, aCols, aHeader ) 
Local lOpcA    := .F.
Local oDlg     := NIL
Local aButtons := {} 
Local oGetD    := NIL
Local lSoExibe := ( nOpc == 2 .OR. nOpc == 5 ) 
Local aSize    := {} 
Local aObjects := {} 
Private oGet

aSize   := MsAdvSize() 
aAdd( aObjects, { 100, 030, .T., .T. } ) 
aAdd( aObjects, { 100, 070, .T., .T. } ) 
aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 } 
aPosObj := MsObjSize( aInfo, aObjects, .T. ) 

Define Font oFontBold  Name 'Arial' Size 0, -11 Bold
Define MsDialog oDlg Title cCadastro From aSize[7], 0 To aSize[6], aSize[5]  Of oMainWnd Pixel

Enchoice( cAlias, nRecNo, nOpc,,,,, aPosObj[1],, 3 ) 
oGetD := MsGetDados():New( aPosObj[2, 1], aPosObj[2, 2], aPosObj[2, 3], aPosObj[2, 4], nOpc, 'u_PA4LinOk() ', 'u_PA4TudOk() ', '', .T.,,,,,,,, 'u_PA4CanDel() ', ) 

If lSoExibe
	Activate MsDialog oDlg Centered On Init EnchoiceBar( oDlg, { || lOpcA := .T., IIf( oGetD:TudoOk() , oDlg:End() , lOpcA := .F. ) } , { || oDlg:End() } ) 
Else
	Activate MsDialog oDlg Centered On Init EnchoiceBar( oDlg, { || lOpcA := .T., IIf( oGetD:TudoOk() .AND. u_PA4Tudok() .AND. u_PA4Linok() .AND. Obrigatorio( aGets, aTela ) , oDlg:End() , lOpcA := .F. ) } , { || lOpcA := .F., oDlg:End() } ,, aButtons ) 
EndIf

Return lOpcA

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ PA4TIMER ºAutor  ³ Ernani Forastieri  º Data ³  13/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para montagem do Timer do mBrowse                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PA4Timer( oTimer, omBrowse ) 
_nSeg := SuperGetMV( 'ES_RFSMON',, 10000 ) 
Define Timer oTimer Interval _nSeg Action RfBrowse( GetObjBrow() , oTimer ) Of omBrowse
oTimer:Activate() 
Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ RFBrowse ºAutor  ³ Ernani Forastieri  º Data ³  13/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para Refresh de tela chamando do timer              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RfBrowse( oObjBrow, oTimer ) 
PA4->( dbGoBottom() )
oTimer:DeActivate()
oObjBrow:GoBottom()  
oObjBrow:Refresh() 
oTimer:Activate() 
Return NIL

/////////////////////////////////////////////////////////////////////////////