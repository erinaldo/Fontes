#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ CIEE004  บAutor  ณ Ernani Forastieri  บ Data ณ  13/10/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para manutencao Cad. de Pacotes des Exportacao      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importacao/Exportacao de Tabelas                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CQDOA02() //CIEE002()
Private nUsado     := 0
Private cCadastro  := "Cadastro de Unidades" 
Private aCores     := {}
aCores := {;
{'PA2_STATUS == I'    , "BR_VERMELHO" },;  // INATIVO
{'PA2_STATUS == A'    , "BR_VERDE"  }}	 // ATIVO

Private aRotina    := { ;
{ "Pesquisar"   , 'AxPesqui'       , 0, 1 } , ; //"Pesquisar"
{ "Visualizar"  , 'u_PA2Visual'    , 0, 2 } , ; //"Visualizar"
{ "Incluir"     , 'u_PA2Inclui'    , 0, 3 } , ; //"Incluir"
{ "Alterar"     , 'u_PA2Altera'    , 0, 4 } , ; //"Alterar"
{ "Excluir"     , 'u_PA2Exclui'    , 0, 5 } , ; //"Excluir" 
{ "Legenda"     , 'u_PA2Legend()'  , 0, 6 }  } //"Legenda"   


Private cDelFunc   := "u_CIE02D()"
Private cString    := "PA2"
Private cFilPA4    := ""
Private cFilPA7    := ""

dbSelectArea( "PA7" )
dbSetOrder( 1 )
cFilPA7 := xFilial( "PA7" )

dbSelectArea( "PA2" )
dbSetOrder( 1 )
cFilPA2 := xFilial( "PA2" )

mBrowse( ,,,, "PA2",, 'PA2_STATUS == "I"' )

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ PA2VISIALบAutor  ณ Ernani Forastieri  บ Data ณ  13/10/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para visualizacao do cadastro                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importacao/Exportacao de Tabelas                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PA2Visual( cAlias, nRecNo, nOpc )
Local   nX        := 0
Local   nCols     := 0
Local   nOpcTela  := 0
Local   cChave    := ""
Local   bCampo    := { | nField | Field( nField ) }
Private oGet      := NIL
Private aHeader   := {}
Private aCols     := {}
Private aTela     := {}
Private aGets     := {}
Private EXCLUI    := .F.

//
// Inicia as variaveis para Enchoice
//
dbSelectArea( "PA2" )
dbSetOrder( 1 )
dbGoTo( nRecNo )
cChave := PA2->PA2_COD

For nX := 1 To FCount()
	M->&( Eval( bCampo, nX ) ) := FieldGet( nX )
Next nX

//
// Monta o aHeader
//
CriaHeader()

//
// Monta o aCols
//
dbSelectArea( "PA7" )
dbSetOrder( 1 )
dbSeek( cFilPA7 + cChave )

While !EOF() .AND. ( cFilPA7 + cChave ) == PA7->( PA7_FILIAL + PA7->PA7_COD )
	aAdd( aCols, Array( nUsado + 1 ) )
	nCols++ 
	
	For nX := 1 To nUsado
		If ( aHeader[nX][10] != "V" )
			aCols[nCols][nX] := FieldGet( FieldPos( aHeader[nX][2] ) )
		Else
			aCols[nCols][nX] := CriaVar( aHeader[nX][2], .T. )
		EndIf
	Next nX
	
	aCols[nCols][nUsado + 1] := .F.
	dbSelectArea( "PA7" )
	dbSkip()
End

PA2Tela( cAlias, nRecNo, nOpc, cCadastro, aCols, aHeader )

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ PA2INCLUIบAutor  ณ Ernani Forastieri  บ Data ณ  13/10/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para inclusao     do cadastro                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importacao/Exportacao de Tabelas                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PA2Inclui( cAlias, nRecNo, nOpc )
Local   nX        := 0
Local   nCols     := 0
Local   nOpcTela  := 0
Local   cChave    := ""
Local   bCampo    := { | nField | Field( nField ) }
Private oGet      := NIL
Private aHeader   := {}
Private aCols     := {}
Private aTela     := {}
Private aGets     := {}
Private EXCLUI    := .F.
//
// Cria Variaveis de Memoria da Enchoice
//
dbSelectArea( "PA2" )
For nX := 1 To FCount()
	M->&( Eval( bCampo, nX ) ) := CriaVar( FieldName( nX ), .T. )
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
dbSelectArea( "SX3" )
dbSetOrder( 1 )
dbSeek( "PA7" )
While !EOF() .AND. SX3->X3_ARQUIVO == "PA7"
	If X3USO( SX3->X3_USADO ) .AND. cNivel >= SX3->X3_NIVEL
		nUsado++ 
		aCols[1][nUsado] := CriaVar( Trim( SX3->X3_CAMPO ), .T. )
	EndIf
	dbSkip()
End

aCols[1][nUsado + 1] := .F.

If  PA2Tela( cAlias, nRecNo, nOpc, cCadastro, aCols, aHeader )
	Begin TransAction
	If PA2Grava( nOpc,, )
		EvalTrigger()
		If __lSX8
			ConfirmSX8()
		EndIf
	EndIf
	End TransAction
Else
	If __lSX8
		RollBackSX8()
	EndIf
EndIf

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ PA2ALTERAบAutor  ณ Ernani Forastieri  บ Data ณ  13/10/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para alteracao    do cadastro                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importacao/Exportacao de Tabelas                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PA2Altera( cAlias, nRecNo, nOpc )
Local   nX        := 0
Local   nCols     := 0
Local   nOpcTela  := 0
Local   cChave    := ""
Local   bCampo    := { | nField | Field( nField ) }
Local   aAltera   := {}
Private oGet      := NIL
Private aHeader   := {}
Private aCols     := {}
Private aTela     := {}
Private aGets     := {}
Private EXCLUI    := .F.

//
// Inicia as variaveis para Enchoice
//
dbSelectArea( "PA2" )
dbSetOrder( 1 )
dbGoTo( nRecNo )
cChave := PA2->PA2_COD

For nX := 1 To FCount()
	M->&( Eval( bCampo, nX ) ) := FieldGet( nX )
Next nX

//
// Monta o aHeader
//
CriaHeader()

//
// Monta o aCols
//
dbSelectArea( "PA7" )
dbSetOrder( 1 )
dbSeek( cFilPA7 + cChave )

While !EOF() .AND. ( cFilPA7 + cChave ) == PA7->( PA7->PA7_FILIAL + PA7->PA7_COD )
	aAdd( aCols, Array( nUsado + 1 ) )
	nCols++ 
	
	For nX := 1 To nUsado
		If ( aHeader[nX][10] != "V" )
			aCols[nCols][nX] := FieldGet( FieldPos( aHeader[nX][2] ) )
		Else
			aCols[nCols][nX] := CriaVar( aHeader[nX][2], .T. )
		EndIf
	Next nX
	
	aCols[nCols][nUsado + 1] := .F.
	dbSelectArea( "PA7" )
	aAdd( aAltera, Recno() )
	dbSkip()
End

If  PA2Tela( cAlias, nRecNo, nOpc, cCadastro, aCols, aHeader )
	Begin TransAction
	If PA2Grava( nOpc, aAltera,  )
		EvalTrigger()
		If __lSX8
			ConfirmSX8()
		EndIf
	EndIf
	End TransAction
Else
	If __lSX8
		RollBackSX8()
	EndIf
EndIf

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ PA2EXCLUIบAutor  ณ Ernani Forastieri  บ Data ณ  13/10/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para exclusao     do cadastro                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importacao/Exportacao de Tabelas                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PA2Exclui( cAlias, nRecNo, nOpc )
Local   nX        := 0
Local   nCols     := 0
Local   nOpcTela  := 0
Local   cChave    := ""
Local   bCampo    := { | nField | Field( nField ) }
Local   a
Private oGet      := NIL
Private aHeader   := {}
Private aCols     := {}
Private aTela     := {}
Private aGets     := {}
Private EXCLUI    := .T.

If !u_CIE02D()
	Return NIL
EndIf

//
// Inicia as variaveis para Enchoice
//
dbSelectArea( "PA2" )
dbSetOrder( 1 )
dbGoTo( nRecNo )
cChave := PA2->PA2_COD

For nX := 1 To FCount()
	M->&( Eval( bCampo, nX ) ) := FieldGet( nX )
Next nX

//
// Monta o aHeader
//
CriaHeader()

//
// Monta o aCols
//
dbSelectArea( "PA7" )
dbSetOrder( 1 )
dbSeek( cFilPA7 + cChave )

While !EOF() .AND. ( cFilPA7 + cChave ) == PA7->( PA7_FILIAL + PA7->PA7_COD )
	aAdd( aCols, Array( nUsado + 1 ) )
	nCols++ 
	
	For nX := 1 To nUsado
		If ( aHeader[nX][10] != "V" )
			aCols[nCols][nX] := FieldGet( FieldPos( aHeader[nX][2] ) )
		Else
			aCols[nCols][nX] := CriaVar( aHeader[nX][2], .T. )
		EndIf
	Next nX
	
	aCols[nCols][nUsado + 1] := .F.
	dbSelectArea( "PA7" )
	dbSkip()
End

If  PA2Tela( cAlias, nRecNo, nOpc, cCadastro, aCols, aHeader )
	Begin TransAction
	If PA2Grava( nOpc,, )
		EvalTrigger()
		If __lSX8
			ConfirmSX8()
		EndIf
	EndIf
	End TransAction
Else
	If __lSX8
		RollBackSX8()
	EndIf
EndIf

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณCRIAHEADERบAutor  ณ Ernani Forastieri  บ Data ณ  13/10/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para criacao do aHeader                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importacao/Exportacao de Tabelas                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaHeader()
nUsado  := 0
aHeader := {}

dbSelectArea( "SX3" )
dbSetOrder( 1 )
dbSeek( "PA7" )
While ( !EOF() .AND. SX3->X3_ARQUIVO == "PA7" )
	If ( X3USO( SX3->X3_USADO ) .AND. cNivel >= SX3->X3_NIVEL )
		aAdd( aHeader, { Trim( X3Titulo() ), ;
		SX3->X3_CAMPO   , ;
		SX3->X3_Picture , ;
		SX3->X3_TAMANHO , ;
		SX3->X3_DECIMAL , ;
		SX3->X3_Valid   , ;
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ PA7LinOk บAutor  ณ Ernani Forastieri  บ Data ณ  13/10/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para Validacao da Linha da GetDados                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importacao/Exportacao de Tabelas                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PA7LinOk()
Local aArea    := GetArea()
//Local aAreaSX3 := SX3->( GetArea() )
Local cMsg     := ""
Local lRet     := .T.
Local nI       := 0
Local nPosMat  := aScan( aHeader, { | x | Trim( x[2] ) == "PA7_RESP" } )
Local nPosNiv  := aScan( aHeader, { | x | Trim( x[2] ) == "PA7_NIVEL" } )

If aCols[n][nUsado + 1]
	Return lRet
EndIf

For nI := 1 To Len( aCols )
	If !aCols[nI][nUsado + 1]
		If aCols[n][nPosMat] == aCols[nI][nPosMat]
			If n <> nI
				cMsg := "Matricula jแ cadastrada."
				lRet := .F.
				Help( "", 1, "", "PA7LinOk", cMsg, 1, 0 )
				Exit
			EndIf
		 EndIf
	EndIf
Next 

For nI := 1 To Len( aCols )
	If !aCols[nI][nUsado + 1]
		If aCols[n][nPosNiv] == aCols[nI][nPosNiv]
			If n <> nI
				cMsg := "Nivel jแ cadastrado."
				lRet := .F.
				Help( "", 1, "", "PA7LinOk", cMsg, 1, 0 )
				Exit
			EndIf
		EndIf
	EndIf
Next

//RestArea( aAreaSX3 )
RestArea( aArea )

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ PA7Tudok บAutor  ณ Ernani Forastieri  บ Data ณ  13/10/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para Validacao da Geral da GetDados                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importacao/Exportacao de Tabelas                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PA7Tudok()
Local aArea      := GetArea()
Local aAreaPA2   := PA2->( GetArea() )
Local aAreaPA4   := PA4->( GetArea() )
Local lRet       := .T.
Local cMsg       := ""
Local nCount     := 0
Local nI         := 0
Local nJ         := 0

If lRet	
	//
	// Verifica se tem pelo menos 1 item e se ele nao esta vazio
	//
	For nI := 1 To Len( aCols )
		If !aCols[nI][nUsado + 1]
			lVazio := .T.
			For nJ := 1 To nUsado
				lVazio := IIf( !Empty( aCols[nI][nJ] ), .F., lVazio )
			Next nJ
			nCount += IIf( lVazio, 0, 1 )
			
			//
			// Verifica se a ultima linha nao esta vazia
			//
			If nI == Len( aCols ) .AND. lVazio .AND. Len( aCols ) > 1
				aCols[nI][nUsado + 1] := .T.
			EndIf
			
		EndIf
		
	Next nI
	
	If  nCount == 0
		cMsg := "Deve haver pelo menos 1 responsavel cadastrado."
		Help( "", 1, "", "PA2TUDOK", cMsg, 1, 0 )
		lRet := .F.
	EndIf
	
EndIf

RestArea( aAreaPA4 )
RestArea( aAreaPA2 )
RestArea( aArea   )

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ PA2GRAVA บAutor  ณ Ernani Forastieri  บ Data ณ  13/10/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para gravacao dos dados dos cadastros               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importacao/Exportacao de Tabelas                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PA2Grava( nOpc, aAltera )
Local aArea    := GetArea()
Local lGravou  := .F.
Local nUsado   := 0
Local nX       := 0
Local nI       := 0
Local cFilPA4 := xFilial( 'PA4' )
Private bCampo := { | nField | FieldName( nField ) }

nUsado    := Len( aHeader ) + 1

//
// Se For inclusao
//
If nOpc == 3
	//
	// Grava os itens
	//
	dbSelectArea( "PA7" )
	dbSetOrder( 1 )
	For nX := 1 To Len( aCols )
		lDeletado := aCols[nX][nUsado]
		
		If !lDeletado
			RecLock( "PA7", .T. )
			For nI := 1 To Len( aHeader )
				FieldPut( FieldPos( Trim( aHeader[nI, 2] ) ), aCols[nX, nI] )
			Next nI
			PA7->PA7_FILIAL := cFilPA7
			PA7->PA7_COD    := M->PA2_COD
			MsUnLock()
			lGravou := .T.
		EndIf
	Next
	
	//
	// Grava o Cabecalho
	//
	If lGravou
		dbSelectArea( "PA2" )
		RecLock( "PA2", .T. )
		For nX := 1 To FCount()
			If "FILIAL" $ FieldName( nX )
				FieldPut( nX, cFilPA2 )
			Else
				FieldPut( nX, M->&( Eval( bCampo, nX ) ) )
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
	// Altera a Descricao no PA4
	//
	
	If M->PA2_DESC <> PA2->PA2_DESC
		dbSelectArea( "PA4" )
		dbSetOrder( 2 )
		dbSeek( xFilial( 'PA4' ) + M->PA2_COD )
		
		While !PA4->( EOF() ) .AND. ( cFilPA4 + M->PA2_COD ) == PA4->( PA4_FILIAL + PA4_CODUNI )
			RecLock( 'PA4', .F. )
			PA4->PA4_DESCUN := M->PA2_DESC
			PA4->( dbSkip() )
		End
	EndIf


	//
	// Altera Status PA1
	//
	If M->PA2_STATUS <> PA2->PA2_STATUS
		dbSelectArea( "PA1" )
		dbSetOrder( 1 )

		dbSelectArea( "PA4" )
		dbSetOrder( 2 )
		dbSeek( xFilial( 'PA4' ) + M->PA2_COD )
		
		While !PA4->( EOF() ) .AND. ( cFilPA4 + M->PA2_COD ) == PA4->( PA4_FILIAL + PA4_CODUNI )
		             
			If PA4->PA4_ENCE <> 'S' .AND. dbSeek( xFilial( 'PA1' ) + PA4->PA4_CODDOC )	
				dbSelectArea( "PA1" )
				RecLock( 'PA1', .F. )
				PA1->PA1_STATUS := M->PA2_STATUS
			EndIf
				
			PA4->( dbSkip() )				
		End
	EndIf

	
	//
	// Grava os itens conforme as alteracoes
	//
	dbSelectArea( "PA7" )
	dbSetOrder( 1 )
	
	For nX := 1 To Len( aCols )
		lDeletado := aCols[nX][nUsado]
		
		If nX <= Len( aAltera )
			dbGoTo( aAltera[nX] )
			RecLock( "PA7", .F. )
			
			If lDeletado
				dbDelete()
			EndIf
		Else
			If !lDeletado
				RecLock( "PA7", .T. )
			EndIf
		EndIf
		
		If !lDeletado
			For nI := 1 To Len( aHeader )
				FieldPut( FieldPos( Trim( aHeader[nI, 2] ) ), aCols[nX, nI] )
			Next nI
			PA7->PA7_FILIAL := cFilPA7
			PA7->PA7_COD    := M->PA2_COD
			MsUnLock()
			lGravou := .T.
		EndIf
		
	Next

	/*
	Alterado pelo analista Emerson este processo realiza a alteracao dos Documentos
	existentes que nao estao encerrados
	alterado dia 12/02/08
	*/
	_cQuery := "SELECT PA4_COD, PA8_MAT "
	_cQuery += "FROM "+RetSqlName("PA4")+"  PA4, "+RetSqlName("PA8")+"  PA8 "
	_cQuery += "WHERE PA4.D_E_L_E_T_ <> '*' AND PA8.D_E_L_E_T_ <> '*' "
	_cQuery += "AND PA4_COD = PA8_COD "
	_cQuery += "AND PA4_CODUNI = '"+M->PA2_COD+"' "
	_cQuery += "AND PA4_ENCE = 'N' "
	_cQuery += "ORDER BY PA4_COD , PA8_MAT"
	TcQuery _cQuery ALIAS "TPA4" NEW

	dbSelectArea("TPA4")
	dbGotop()

	If TPA4->(!EOF())
		Do While TPA4->(!EOF())
			_cDocAnt := TPA4->PA4_COD
			_lAltPA8 := .F.
			Do While TPA4->PA4_COD == _cDocAnt
				DbSelectArea("PA8")
				DbSetOrder(1) //FILIAL, COD (DOCUMENTO), MAT (MATRICULA)
				If DbSeek(xFilial("PA8")+TPA4->PA4_COD+TPA4->PA8_MAT)
					If RecLock("PA8",.F.)
						dbDelete()
						_lAltPA8 := .T.
					Else
						Alert("Registro "+TPA4->PA4_COD+" esta sendo utilizado por outro usuario e nao pode ser alterado!!!")
						Loop
					EndIf
				EndIf
				dbSelectArea("TPA4")
				TPA4->(dbSkip())
			EndDo
			If _lAltPA8
				For _nX := 1 To Len( aCols )
					lDeletado := aCols[_nX][nUsado]
					If !lDeletado
						DbSelectArea("PA8")
						RecLock("PA8",.T.)
						PA8->PA8_FILIAL	:= xFilial("PA8")
						PA8->PA8_MAT	:= aCols[_nX,1]
						PA8->PA8_NIVEL	:= aCols[_nX,3]
						PA8->PA8_ORIGEM	:= "UNI"
						PA8->PA8_COD	:= _cDocAnt
						MsUnLock()
					EndIf
				Next _nX
			EndIf
		EndDo
	EndIf
	dbSelectArea("TPA4")
	TPA4->(dbCloseArea())

    /*
    Fim da Alteracao realizada pelo analista Emerson dia 12/02/08
    */
    
    
	//
	// Grava o Cabecalho
	//
	If lGravou
		dbSelectArea( "PA2" )
		RecLock( "PA2", .F. )
		For nX := 1 To FCount()
			If "FILIAL" $ FieldName( nX )
				FieldPut( nX, cFilPA2 )
			Else
				FieldPut( nX, M->&( Eval( bCampo, nX ) ) )
			EndIf
		Next
		MsUnLock()
	Else
		dbSelectArea( "PA2" )
		RecLock( "PA2", .F. )
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
	dbSelectArea( "PA7" )
	dbSetOrder( 1 )
	cChave := M->PA2_COD
	dbSeek( cFilPA7, .T. )
	
	While !EOF() .AND. ( cFilPA7 + cChave ) == PA7->( PA7_FILIAL + PA7_COD )
		RecLock( "PA7", .F. )
		dbDelete()
		MsUnLock()
		dbSkip()
	End
	
	//
	// Deleta o Cabecalho
	//
	dbSelectArea( "PA2" )
	RecLock( "PA2" )
	dbDelete()
	MsUnLock()
	lGravou := .T.
EndIf

RestArea( aArea )

Return lGravou



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ PA2TELA  บAutor  ณ Ernani Forastieri  บ Data ณ  13/10/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para montagek da tela da Enchoice /Getdados         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importacao/Exportacao de Tabelas                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PA2Tela( cAlias, nRecNo, nOpc, cCadastro, aCols, aHeader )
Local lOpcA    := .F.
Local oDlg     := NIL
Local aButtons := {}
Local oLbx, oChkMar, oButInv, oMascEmp, oMascFil
Local oButMarc, oButDMar, oFontBold
Local cVar     := ''
Local oOk      := LoadBitMap( GetResources(), "LBOK" )
Local oNo      := LoadBitMap( GetResources(), "LBNO" )
Local lChk     := .F.
Local lSoExibe := ( nOpc == 2 .OR. nOpc == 5 )
Local nCI      := 2
Local nLI      := 15
Local nCF      := 320
Local nLF      := 90    
Local aSize    := {}
Local aObjects := {}
Private oGet

aSize   := MsAdvSize()
AAdd( aObjects, { 100, 040, .T., .T. } )
AAdd( aObjects, { 100, 060, .T., .T. } )
aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
aPosObj := MsObjSize( aInfo, aObjects,.T.)

Define Font oFontBold  Name "Arial" Size 0, -11 Bold
//Define MsDialog oDlg Title cCadastro From 0, 0 TO 25, 82  Of oMainWnd
Define MsDialog oDlg Title cCadastro From aSize[7],0 to aSize[6],aSize[5]  Of oMainWnd PIXEL

//@  15, 01 Say "Vigencia" Size  40, 08 Font oFontBold Of oDlg Pixel //"Dados Gerais"
//EnChoice( cAlias, nRecNo, nOpc,,,,, { 25, 2, 100, 300 },, 3 )
//EnChoice( cAlias, nRecNo, nOpc,,,,, { nLI, nCI, nLF, nCF },, 3 )
EnChoice( cAlias, nRecNo, nOpc,,,,, aPosObj[1],, 3 )

//oGet := MSGetDados():New( 105, 2, 210, 300, nOpc, "u_PA7LinOk()", "u_PA7Tudok()", "", .T. )
//oGet := MSGetDados():New( nLF+5, nCI, nLF+5+90, nCF, nOpc, "u_PA7LinOk()", "u_PA7Tudok()", "", .T. )
oGet := MSGetDados():New( aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4], nOpc, "u_PA7LinOk()", "u_PA7Tudok()", "", .T. )

If lSoExibe
	Activate MsDialog oDlg Centered On Init EnchoiceBar( oDlg, { || lOpcA := .T., IIf( oGet:TudoOk(), oDlg:End(), lOpcA := .F. ) }, { || oDlg:End() } )
Else
	Activate MsDialog oDlg Centered On Init EnchoiceBar( oDlg, { || lOpcA := .T., IIf( oGet:TudoOk() .AND. u_PA7Tudok().AND. u_PA7LinOk() .AND. Obrigatorio( aGets, aTela ), oDlg:End(), lOpcA := .F. ) }, { || lOpcA := .F., oDlg:End() },, aButtons )
EndIf

Return lOpcA


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCIEE004   บAutor  ณMicrosiga           บ Data ณ  10/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Funcao que testa se pode deletar a unidade selecionada              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
User Function CIE02D()
Local aArea  := GetArea()
Local lExist := .T.

dbSelectArea( "PA4" )
dbSetOrder( 2 )

If dbSeek( xFilial( "PA4" ) + PA2->PA2_COD )
	APMsgStop( "Este registro nใo pode ser excluido.", 'ATENวรO' )
	lExist := .F.
EndIf

RestArea( aArea )
Return lExist
               

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ PA2LEGENDบAutor  ณ Rubens Lacerda     บ Data ณ  21/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para exibicao da legenda                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE 						                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PA2Legend()
Local aCores := {;
{"BR_VERDE"     , "Ativo"     },;
{"BR_VERMELHO"  , "Inativo"     } }

BrwLegenda( cCadastro, "Legenda", aCores ) //"Legenda"

//////////////////////////////////////////////////////////////////////////////
