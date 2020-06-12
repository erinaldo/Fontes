#INCLUDE "PROTHEUS.CH"
#INCLUDE "SHELL.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ CIEE004  บAutor  ณ Ernani Forastieri  บ Data ณ  13/10/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para cadastro de Vigencia X Unidades			      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE							                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CQDOA04() //CIEE004()
Private nUsado     := 0
Private cCadastro  := "Vigencia x Unidades"
Private cFilPA4    := ""
Private cFilPA8    := ""
Private aRotina    := {}
Private aCores     := {}
/*
aCores := {;
{'PA4_ENCE == "S"'									, "BR_PRETO"	},;	// ENCERRADO
{'PA4_INDEFE == "S"'								, "BR_CINZA"	},;	// INDEFERIDO
{'PA4_CTVCTO == "S" .and. PA4_DTVCTO < dDataBase'	, "BR_VERMELHO"	},;	// VENCIDO
{'!Empty(PA4_DTREG)'								, "BR_VERDE"	},;	// VIGENTE
{'Empty(PA4_DTREG)'									, "BR_AMARELO"	},;	// AGUARDANDO
{'u_CIE04L()'										, "BR_AZUL"		}}	// INATIVO
*/
aCores := {;
{'ALLTRIM(PA4_STATUS) == "ENCERRADO"' 	, "BR_PRETO"	},;	// ENCERRADO
{'ALLTRIM(PA4_STATUS) == "INDEFERIDO"' 	, "BR_AZUL"		},;	// INDEFERIDO
{'ALLTRIM(PA4_STATUS) == "VENCIDO"' 	, "BR_VERMELHO"	},;	// VENCIDO
{'ALLTRIM(PA4_STATUS) == "VIGENTE"' 	, "BR_VERDE"	},;	// VIGENTE
{'ALLTRIM(PA4_STATUS) == "AGUARDANDO"' 	, "BR_AMARELO"	}}	// AGUARDANDO

//{'u_CIE04L()'							, "BR_AZUL"		}}	// INATIVO

aAdd( aRotina , { "Pesquisar"   , 'AxPesqui'       , 0, 1 } ) //"Pesquisar"
aAdd( aRotina , { "Visualizar"  , 'u_PA4Visual'    , 0, 2 } ) //"Visualizar"
aAdd( aRotina , { "Incluir"     , 'u_PA4Inclui'    , 0, 3 } ) //"Incluir"
aAdd( aRotina , { "Alterar"     , 'u_PA4Altera'    , 0, 4 } ) //"Alterar"
aAdd( aRotina , { "Excluir"     , 'u_PA4Exclui'    , 0, 5 } ) //"Excluir"
aAdd( aRotina , { "Legenda"     , 'u_PA4Legend()'  , 0, 6 } ) //"Legenda"

Define Font oFontNor  Name "Arial" Size 0, -11
Define Font oFontNorB Name "Arial" Size 0, -11 Bold
Define Font oFontBold Name "Arial" Size 0, -13 Bold

dbSelectArea( "PA8" )
dbSetOrder( 1 )
cFilPA8 := xFilial( "PA8" )

dbSelectArea( "PA4" )
dbSetOrder( 1 )
cFilPA4 := xFilial( "PA4" )


Processa({|| _fStatus() },"Processando...")

//mBrowse( ,,,, "PA4",,,,, 2, aCores)
mBrowse( ,,,, "PA4")

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ PA4VISUALบAutor  ณ Ernani Forastieri  บ Data ณ  13/10/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para visualizacao do cadastro                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE							                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PA4Visual( cAlias, nRecNo, nOpc )
Local   nX        := 0
Local   nCols     := 0
Local   nOpcTela  := 0
Local   cChave    := ""
Local   bCampo    := { |nField| Field( nField ) }
Private oGet      := NIL
Private aHeader   := {}
Private aCols     := {}
Private aTela     := {}
Private aGets     := {}

//
// Inicia as variaveis para Enchoice
//
dbSelectArea( "PA4" )
dbSetOrder( 1 )
dbGoTo( nRecNo )
cChave := PA4->PA4_COD

For nX:= 1 To FCount()
	M->&( Eval( bCampo, nX ) ) := FieldGet( nX )
Next nX

//
// Monta o aHeader
//
CriaHeader()

//
// Monta o aCols
//
dbSelectArea( "PA8" )
dbSetOrder( 1 )
dbSeek( cFilPA8 + cChave )

While !Eof() .AND. ( cFilPA8 + cChave ) == PA8->( PA8_FILIAL + PA8->PA8_COD )
	aAdd( aCols, Array( nUsado + 1 ) )
	nCols ++
	
	For nX := 1 To nUsado
		If ( aHeader[nX][10] != "V" )
			aCols[nCols][nX] := FieldGet( FieldPos( aHeader[nX][2] ) )
		Else
			aCols[nCols][nX] := CriaVar( aHeader[nX][2], .T. )
		EndIf
	Next nX
	
	aCols[nCols][nUsado + 1] := .F.
	dbSelectArea( "PA8" )
	dbSkip()
End

PA4Tela( cAlias, nRecNo, nOpc, cCadastro, aCols, aHeader )

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ PA4DATA	บAutor  ณ Rubens Lacerda     บ Data ณ  21/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para validacao da data de vencimento                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE								                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User function PA4DATA(_dDtAb,_dDtVct)
Local lRet := .T.

If _dDtAb>_dDtVct
    MsgInfo("Data de vencimento menor que data de cadastro","Data Vencimento")
	lRet := .F.
Endif                 

Return(lRet)  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ PA4DATA1	บAutor  ณ Rubens Lacerda     บ Data ณ  21/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para validacao da data de encerramento              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE								                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User function PA4DATA1(_dDtAb,_dDtEnc)
Local lRet := .T.

If _dDtAb>_dDtEnc
    MsgInfo("Data de encerramento menor que data de cadastro","Data Encerramento")
	lRet := .F.
Endif                 

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ PA4INCLUIบAutor  ณ Ernani Forastieri  บ Data ณ  13/10/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para inclusao do cadastro                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importacao/Exportacao de Tabelas                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PA4Inclui( cAlias, nRecNo, nOpc )
Local   nX        := 0
Local   nCols     := 0
Local   nOpcTela  := 0
Local   cChave    := ""
Local   bCampo    := { |nField| Field( nField ) }
Private oGet      := NIL
Private aHeader   := {}
Private aCols     := {}
Private aTela     := {}
Private aGets     := {}

//
// Cria Variaveis de Memoria da Enchoice
//
dbSelectArea( "PA4" )
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
dbSeek( "PA8" )
While !Eof() .AND. SX3->X3_ARQUIVO == "PA8"
	If X3USO( SX3->X3_USADO ) .AND. cNivel >= SX3->X3_NIVEL
		nUsado ++
		aCols[1][nUsado] := CriaVar( Trim( SX3->X3_CAMPO ), .T. )
	EndIf
	dbSkip()
End

aCols[1][nUsado + 1] := .F.

If  PA4Tela( cAlias, nRecNo, nOpc, cCadastro, aCols, aHeader )
	Begin Transaction
	If PA4Grava( nOpc,,)
		EvalTrigger()
		If __lSX8
			ConfirmSX8()
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ PA4ALTERAบAutor  ณ Ernani Forastieri  บ Data ณ  13/10/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para alteracao    do cadastro                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE							                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PA4Altera( cAlias, nRecNo, nOpc )
Local   nX        := 0
Local   nCols     := 0
Local   nOpcTela  := 0
Local   cChave    := ""
Local   bCampo    := { |nField| Field( nField ) }
Local   aAltera   := {}
Private oGet      := NIL
Private aHeader   := {}
Private aCols     := {}
Private aTela     := {}
Private aGets     := {}

//
// Inicia as variaveis para Enchoice
//
dbSelectArea( "PA4" )
dbSetOrder( 1 )
dbGoTo( nRecNo )
cChave := PA4->PA4_COD

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
dbSelectArea( "PA8" )
dbSetOrder( 1 )
dbSeek( cFilPA8 + cChave )

While !Eof() .AND. ( cFilPA8 + cChave ) == PA8->( PA8->PA8_FILIAL + PA8->PA8_COD )
	aAdd( aCols, Array( nUsado + 1 ) )
	nCols ++
	
	For nX := 1 To nUsado
		If ( aHeader[nX][10] != "V" )
			aCols[nCols][nX] := FieldGet( FieldPos( aHeader[nX][2] ) )
		Else
			aCols[nCols][nX] := CriaVar( aHeader[nX][2], .T. )
		EndIf
	Next nX
	
	aCols[nCols][nUsado + 1] := .F.
	dbSelectArea( "PA8" )
	aAdd( aAltera, Recno() )
	dbSkip()
End

If  PA4Tela( cAlias, nRecNo, nOpc, cCadastro, aCols, aHeader )
	Begin Transaction
	If PA4Grava( nOpc, aAltera,  )
		EvalTrigger()
		If __lSX8
			ConfirmSX8()
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ PA4EXCLUIบAutor  ณ Ernani Forastieri  บ Data ณ  13/10/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para exclusao     do cadastro                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE							                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PA4Exclui( cAlias, nRecNo, nOpc )
Local   nX        := 0
Local   nCols     := 0
Local   nOpcTela  := 0
Local   cChave    := ""
Local   bCampo    := { |nField| Field( nField ) }
Private oGet      := NIL
Private aHeader   := {}
Private aCols     := {}
Private aTela     := {}
Private aGets     := {}

//
// Inicia as variaveis para Enchoice
//
dbSelectArea( "PA4" )
dbSetOrder( 1 )
dbGoTo( nRecNo )
cChave := PA4->PA4_COD

For nX:= 1 To FCount()
	M->&( Eval( bCampo, nX ) ) := FieldGet( nX )
Next nX

//
// Monta o aHeader
//
CriaHeader()

//
// Monta o aCols
//
dbSelectArea( "PA8" )
dbSetOrder( 1 )
dbSeek( cFilPA8 + cChave )

While !Eof() .AND. ( cFilPA8 + cChave ) == PA8->( PA8_FILIAL + PA8->PA8_COD )
	aAdd( aCols, Array( nUsado + 1 ) )
	nCols ++
	
	For nX := 1 To nUsado
		If ( aHeader[nX][10] != "V" )
			aCols[nCols][nX] := FieldGet( FieldPos( aHeader[nX][2] ) )
		Else
			aCols[nCols][nX] := CriaVar( aHeader[nX][2], .T. )
		EndIf
	Next nX
	
	aCols[nCols][nUsado + 1] := .F.
	dbSelectArea( "PA8" )
	dbSkip()
End

If  PA4Tela( cAlias, nRecNo, nOpc, cCadastro, aCols, aHeader )
	Begin Transaction
	If PA4Grava( nOpc,,)
		EvalTrigger()
		If __lSX8
			ConfirmSX8()
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณCRIAHEADERบAutor  ณ Ernani Forastieri  บ Data ณ  13/10/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para criacao do aHeader                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE							                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaHeader()
nUsado  := 0
aHeader := {}

dbSelectArea( "SX3" )
dbSetOrder( 1 )
dbSeek( "PA8" )
While ( !Eof() .AND. SX3->X3_ARQUIVO == "PA8" )
	If ( X3USO( SX3->X3_USADO ) .AND. cNivel >= SX3->X3_NIVEL )
		aAdd( aHeader, { Trim( X3Titulo() ), ;
		SX3->X3_CAMPO   , ;
		SX3->X3_PICTURE , ;
		SX3->X3_TAMANHO , ;
		SX3->X3_DECIMAL , ;
		SX3->X3_VALID   , ;
		SX3->X3_USADO   , ;
		SX3->X3_TIPO    , ;
		SX3->X3_ARQUIVO , ;
		SX3->X3_CONTEXT } )
		nUsado ++
	EndIf
	dbSkip()
End

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ PA4LINOK บAutor  ณ Ernani Forastieri  บ Data ณ  13/10/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para validacao da Linha da GetDados                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE							                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PA4LinOk()
Local aArea    := GetArea()
Local aAreaSX3 := SX3->( GetArea() )
Local lRet     := .T.

RestArea( aAreaSX3 )
RestArea( aArea )

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ PA4LINOK บAutor  ณ Ernani Forastieri  บ Data ณ  13/10/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para validacao da Linha da GetDados                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE							                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PA4CanDel()
Local aArea    := GetArea()
Local aAreaSX3 := SX3->( GetArea() )
Local lRet     := .T.
Local nPosOri := aScan( aHeader, { |X| Alltrim( x[2] ) == 'PA8_ORIGEM' } )
Static lFirst  := .T.
Static lret2   := .T.

If !lFirst
	lFirst  := .T.
	Return lRet2
EndIf

If aCols[n][nPosOri] == 'UNI'
	ApMsgStop( 'Responsavel nใo pode ser apagado.', 'ATENวรO' )
	aCols[n][nUsado + 1] := .F.
	lRet     := .f.
	lRet2    := lRet
EndIf

RestArea( aAreaSX3 )
RestArea( aArea )

If lFirst
	lFirst  := .F.
Endif
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ PA4TUDOK บAutor  ณ Ernani Forastieri  บ Data ณ  13/10/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para validacao da Geral da GetDados                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE							                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PA4TudOk()
Local aArea      := GetArea()
Local aAreaPA4   := PA4->( GetArea() )
Local lRet       := .T.
Local nI         := 0
Local nJ         := 0
Local nRecPA4      := PA4->( Recno() )

If lRet
	For nI := 1 To Len( aCols )
		If lRet
			For nJ := 1 to Len( aHeader ) - 1
				If SX3->( X3Obrigat( aHeader[nJ][2] ) ) .and. Empty(aCols[nI][nJ])
					lRet := .F.
					ApMsgStop( 'Campo ' +  AllTrim( aHeader[nJ][1] ) + ' da linha ' + AllTrim( Str( nI ) ) + ' nใo estแ preenchido.', 'ATENวรO' )
					Exit
				EndIf
			Next
		EndIf
	Next
EndIf

If lRet
	PA4->( dbSetOrder( 2 ) )
	If PA4->( dbSeek( xFilial( 'PA4' )  + M->PA4_CODUNI + M->PA4_CODDOC ) )
		
		If    INCLUI
			If PA4->PA4_ENCE <> 'S'
				lRet := .F.
				ApMsgStop( 'Jแ existe este documento e unidade cadastrado.', 'ATENวรO' )
			EndIf
			
		ElseIf ALTERA
			If nRecPA4 <> PA4->( Recno() )
				If PA4->PA4_ENCE <> 'S'
					lRet := .F.
					ApMsgStop( 'Jแ existe este documento e unidade cadastrado.', 'ATENวรO' )
				EndIf
			EndIf
		EndIf
		
	EndIf
EndIf

If lRet
	If M->PA4_ENCE == 'S' .AND. EMPTY( M->PA4_DTENCE )
		lRet := .F.
		ApMsgStop( 'Digite a Data de Encerramento.', 'ATENวรO' )
	EndIf
EndIf

RestArea( aAreaPA4 )
RestArea( aArea   )

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ PA4GRAVA บAutor  ณ Ernani Forastieri  บ Data ณ  13/10/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para gravacao dos dados dos cadastros               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE								                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PA4Grava( nOpc, aAltera )
Local aArea    := GetArea()
Local lGravou  := .F.
Local nUsado   := 0
Local nX       := 0
Local nI       := 0
Private bCampo := { |nField| FieldName( nField ) }

nUsado    := Len( aHeader ) + 1

//
// Se for inclusao
//
If nOpc == 3
	//
	// Grava os itens
	//
	dbSelectArea( "PA8" )
	dbSetOrder( 1 )
	For nX := 1 To Len( aCols )
		lDeletado := aCols[nX][nUsado]
		
		If !lDeletado
			RecLock( "PA8", .T. )
			For nI := 1 To Len( aHeader )
				FieldPut( FieldPos( Trim( aHeader[nI, 2] ) ), aCols[nX, nI] )
			Next nI
			PA8->PA8_FILIAL := cFilPA8
			PA8->PA8_COD    := M->PA4_COD
			MsUnLock()
			lGravou := .T.
		EndIf
	Next
	
	//
	// Grava o Cabecalho
	//
	If lGravou
		dbSelectArea( "PA4" )
		RecLock( "PA4", .T. )
		For nX := 1 To FCount()
			If "FILIAL" $ FieldName( nX )
				FieldPut( nX, cFilPA4 )
			Else
				FieldPut( nX, M->&( Eval( bCampo, nX ) ) )
			EndIf
		Next
		
		If PA4->PA4_ENCE == "S"
			PA4->PA4_STATUS := "ENCERRADO"
		ElseIf PA4->PA4_INDEFE == "S"
			PA4->PA4_STATUS := "INDEFERIDO"
		ElseIf PA4->PA4_CTVCTO == "S" .and. PA4->PA4_DTVCTO < dDataBase
			PA4->PA4_STATUS := "VENCIDO"
		ElseIf !Empty(PA4->PA4_DTREG)
			PA4->PA4_STATUS := "VIGENTE"
		ElseIf Empty(PA4->PA4_DTREG)
			PA4->PA4_STATUS := "AGUARDANDO"
		EndIf
		
		MsUnLock()
	EndIf
	
EndIf

//
// Se for alteracao
//
If nOpc == 4
	
	//
	// Grava os itens conforme as alteracoes
	//
	dbSelectArea( "PA8" )
	dbSetOrder( 1 )
	
	For nX := 1 To Len( aCols )
		lDeletado := aCols[nX][nUsado]
		
		If nX <= Len( aAltera )
			dbGoto( aAltera[nX] )
			RecLock( "PA8", .F. )
			
			If lDeletado
				dbDelete()
			EndIf
		Else
			If !lDeletado
				RecLock( "PA8", .T. )
			EndIf
		EndIf
		
		If !lDeletado
			For nI := 1 To Len( aHeader )
				FieldPut( FieldPos( Trim( aHeader[nI, 2] ) ), aCols[nX, nI] )
			Next nI
			PA8->PA8_FILIAL := cFilPA8
			PA8->PA8_COD    := M->PA4_COD
			MsUnLock()
			lGravou := .T.
		EndIf
		
	Next
	
	//
	// Grava o Cabecalho
	//
	If lGravou
		dbSelectArea( "PA4" )
		RecLock( "PA4", .F. )
		For nX := 1 To FCount()
			If "FILIAL" $ FieldName( nX )
				FieldPut( nX, cFilPA4 )
			Else
				FieldPut( nX, M->&( Eval( bCampo, nX ) ) )
			EndIf
		Next

		If PA4->PA4_ENCE == "S"
			PA4->PA4_STATUS := "ENCERRADO"
		ElseIf PA4->PA4_INDEFE == "S"
			PA4->PA4_STATUS := "INDEFERIDO"
		ElseIf PA4->PA4_CTVCTO == "S" .and. PA4->PA4_DTVCTO < dDataBase
			PA4->PA4_STATUS := "VENCIDO"
		ElseIf !Empty(PA4->PA4_DTREG)
			PA4->PA4_STATUS := "VIGENTE"
		ElseIf Empty(PA4->PA4_DTREG)
			PA4->PA4_STATUS := "AGUARDANDO"
		EndIf

		MsUnLock()
	Else
		dbSelectArea( "PA4" )
		RecLock( "PA4", .F. )
		dbDelete()
		MsUnLock()
	EndIf
EndIf

//
// Se for exclucao
//
If nOpc == 5
	
	//
	// Deleta os Itens
	//
	dbSelectArea( "PA8" )
	dbSetOrder( 1 )
	cChave := M->PA4_COD
	dbSeek( cFilPA8, .T. )
	
	While !Eof() .AND. ( cFilPA8 + cChave ) == PA8->( PA8_FILIAL + PA8_COD )
		RecLock( "PA8", .F. )
		dbDelete()
		MsUnLock()
		dbSkip()
	End
	
	//
	// Deleta o Cabecalho
	//
	dbSelectArea( "PA4" )
	RecLock( "PA4" )
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
ฑฑบRotina    ณ PA4LEGENDบAutor  ณ Ernani Forastieri  บ Data ณ  13/10/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para exibicao da legenda                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE							                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PA4Legend()
Local aCores := {;
{"BR_PRETO"     , "Encerrado"   },;
{"BR_AZUL"      , "Indeferido"  },;
{"BR_VERMELHO"  , "Vencido"     },;
{"BR_VERDE"     , "Vigente"     },;
{"BR_AMARELO"   , "Aguardando"  }}

//{"BR_AZUL"	  	, "Inativo"     } }

BrwLegenda( cCadastro, "Legenda", aCores ) //"Legenda"

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ PA4Tela	บAutor  ณ Rubens Lacerda     บ Data ณ  01/12/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para montar a tela do Enchoice, Imagens e Getdados  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE								                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PA4Tela( cAlias, nRecNo, nOpc, cCadastro, aCols, aHeader )
Local lOpcA    := .F.
Local oDlg     := NIL
Local aButtons := {}
Local oLbx, oChkMar, oButInv, oMascEmp, oMascFil
Local oButMarc, oButDMar, oFontBold
Local cVar     := ''
Local oOk      := LoadBitmap( GetResources(), "LBOK" )
Local oNo      := LoadBitmap( GetResources(), "LBNO" )
Local lChk     := .F.
Local cMascEmp := "??"
Local cMascFil := "??"
Local lSoExibe := ( nOpc == 2 .OR. nOpc == 5 )
Local lSoExImg := ( nOpc == 2 .OR. nOpc == 4 .OR. nOpc == 5 )
Local nCI      := 2
Local nLI      := 15
Local nCF      := 320
Local nLF      := 130
Local aSize    := {}
Local aObjects := {}
Local cImg1    
Local cImg2       
Local cCodDoc  := ''
Local cCodUni  := ''
Local cQuery := ''
Private oGet 

aSize   := MsAdvSize()
AAdd( aObjects, { 100, 050, .T., .T. } )
AAdd( aObjects, { 100, 050, .T., .T. } )
aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
aPosObj := MsObjSize( aInfo, aObjects,.T.)

Define Font oFontBold  Name "Arial" Size 0, -11 Bold
Define MSDialog oDlg Title cCadastro From aSize[7],0 to aSize[6],aSize[5]  OF oMainWnd Pixel

//
//O tamanho da enchoice e reduzido para incluir os 2 objetos de imagem
//
aPosObj[1][4] := 290

/*INICIO ------------- TAMANHO DA TELA*/
_aSize := MsAdvSize()
aObjects:= {}
aPosObj :={}

aInfo   := {_aSize[1],_aSize[2],_aSize[3],_aSize[4],3,3}

//AADD(aObjects,{100,200,.T.,.F.,.F.})
//AADD(aObjects,{320,100,.T.,.T.,.F.})
AADD(aObjects,{100,150,.T.,.F.,.F.})
AADD(aObjects,{320,100,.T.,.T.,.F.})


aPosObj:=MsObjSize(aInfo, aObjects)
/*FIM ------------- TAMANHO DA TELA*/                                                                                         

oEnch := EnChoice( cAlias, nRecNo, nOpc,,,,, aPosObj[1],, 3 )

//
//verifico se foi escolhido a opcao de alterar, visualizar ou excluir para carregar a imagem
//
If lSoExImg	

	if ( M->PA4_CODDOC != cCodDoc )
		cCodDoc := M->PA4_CODDOC	
	EndIf
	
	if ( M->PA4_CODUNI != cCodUni )
		cCodUni := M->PA4_CODUNI	
	EndIf

EndIf

//
//busco a imagem de cada campo com o nome da imagem que esta cadastrada na tabela
//
	    
cQuery := "SELECT PA1_BITMAP, PA2_BITMAP "
cQuery += "  FROM " + RetSQLName("PA1")+ " PA1, " + RetSQLName("PA2")+ " PA2, " + RetSQLName("PA4")+ " PA4 "
cQuery += "WHERE PA2_COD = '" + cCodUni + "'" 
cQuery += " AND PA1_COD = '" + cCodDoc + "'" 

dbUseArea( .T., 'TOPCONNECT', TcGenQry( ,, cQuery ), 'TRB', .F., .T. )

//
//cria os 2 objetos de imagem
//
//@   200 /*aPosObj[1][2]+198*/, 412 BITMAP oBitMap2 RESNAME "PA4_BIT2" oF oDlg SIZE 105,125 OF oDlg PIXEL
//@   200 /*aPosObj[1][2]+198*/, 518 BITMAP oBitMap1 RESNAME "PA4_BIT1" oF oDlg SIZE 105,125 OF oDlg PIXEL  
@   155 /*aPosObj[1][2]+198*/, 250 BITMAP oBitMap2 RESNAME "PA4_BIT2" oF oDlg SIZE 105,125 OF oDlg PIXEL
@   155 /*aPosObj[1][2]+198*/, 356 BITMAP oBitMap1 RESNAME "PA4_BIT1" oF oDlg SIZE 105,125 OF oDlg PIXEL  

//
//busca o nome da imagem que foi carregado na memoria e adiciona o .jpg para ser exibida no objeto
//
cImg1    := allTrim(TRB->PA1_BITMAP)+".jpg"
cImg2    := allTrim(TRB->PA2_BITMAP)+".jpg"

oBitMap1:Load(,"\imagens\"+cImg1)
oBitMap2:Load(,"\imagens\"+cImg2)  

oBitMap1:Lstretch:=.T.
oBitMap2:Lstretch:=.T.

If lSoExibe //Visualizar
	Aadd( aButtons, { "ALTERA", { || _fAbreObj()   },"Abre objeto","Ver Imagem"})
EndIf
//
//monta a getdados
//
//oGet := MSGetDados():New( aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],300/*aPosObj[2,4]-300*/, nOpc, "u_PA4LinOk()", "u_PA4TudOk()", "", .T.,,,,,,,, "u_PA4CanDel()", )
oGet := MSGetDados():New( aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],250/*aPosObj[2,4]-300*/, nOpc, "u_PA4LinOk()", "u_PA4TudOk()", "", .T.,,,,,,,, "u_PA4CanDel()", )

If lSoExibe
	Activate MSDialog oDlg Centered On Init EnchoiceBar( oDlg, { || lOpcA:=.T., IIf( oGet:TudoOk(), oDlg:End(), lOpcA := .F. ) }, { ||oDlg:End() },, aButtons )
Else
	Activate MSDialog oDlg Centered On Init EnchoiceBar( oDlg, { || lOpcA:=.T., IIf( oGet:TudoOk() .AND. u_PA4Tudok().AND. u_PA4Linok() .AND. Obrigatorio( aGets, aTela ), oDlg:End(), lOpcA:=.F. ) }, { ||lOpcA:=.F., oDlg:End() },, aButtons )
EndIf
      
TRB->( dbCloseArea() )
Return lOpcA


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ          บAutor  ณMicrosiga           บ Data ณ  10/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CIE04A()
Local aCpos := {}
Local nPos  := 0
Local nX    := 0
Local nPosOri := aScan( aHeader, { |X| Alltrim( x[2] ) == 'PA8_ORIGEM' } )
Local nPosMat := aScan( aHeader, { |X| Alltrim( x[2] ) == 'PA8_MAT'    } )
Local nPosNiv := aScan( aHeader, { |X| Alltrim( x[2] ) == 'PA8_NIVEL'  } )
Local nPosDNiv:= aScan( aHeader, { |X| Alltrim( x[2] ) == 'PA8_DESNIV'  } )
Local nCols := 0

aAdd( aCpos, { 'PA8_MAT' , 'PA7_RESP' } )
aAdd( aCpos, { 'PA8_RESP', 'PA7_DESRES' } ) 

dbSelectArea( "PA7" )
dbSetOrder( 1 )
dbSeek( xFilial('PA7') + M->PA4_CODUNI )

aColsClone := aClone( aCols )
aCols := {}

lInc := INCLUI
lAlt := ALTERA

INCLUI := .F.
ALTERA := .T.

While !Eof() .AND. ( xFilial('PA7')  + M->PA4_CODUNI ) == PA7->( PA7_FILIAL + PA7->PA7_COD )
	aAdd( aCols, Array( nUsado + 1 ) )
	nCols ++
	
	For nX := 1 To Len( aCpos )
		If ( nPos := aScan( aHeader, { |X| Alltrim( x[2] ) == Alltrim( aCpos[nX][1] ) } ) ) > 0
			If ( aHeader[nPos][10] != "V" )
				aCols[nCols][nPos] := FieldGet( FieldPos( aCpos[nX][2] ) )
			Else
				aCols[nCols][nPos] := CriaVar( aCpos[nX][2], .T. )
			EndIf
		EndIf
	Next nX
	
	aCols[nCols][nPosNiv]    := GetAdvFval("PA3", "PA3_NIVEL", xFilial( 'PA3' ) + aCols[nCols][nPosMat], 1, CriaVar( 'PA8_NIVEL' ) )
	aCols[nCols][nPosOri]    := 'UNI'
	aCols[nCols][nUsado + 1] := .F.
	aCols[nCols][nPosDNiv]   := X3COMBO( 'PA3_NIVEL', aCols[nCols][nPosNiv] )
	dbSelectArea( "PA7" )
	dbSkip()
End

INCLUI := lInc
ALTERA := lAlt

For nX := 1 to Len( aCols )
	If ( nPos := aScan( aColsClone,{ |x| x[nPosMat] == aCols[nX][nPosMat] } ) ) > 0
		aCols[nX][nPosNiv] := aColsClone[nPos][nPosNiv]
	EndIf
Next

For nX := 1 To Len( aColsClone )
	If	aColsClone[nX][nPosOri] <> 'UNI' .and. !Empty( aColsClone[nX][nPosMat] )
		If ( nPos := aScan( aCols,{ |x| x[nPosMat] == aColsClone[nX][nPosMat] } ) ) == 0
			aAdd( aCols, aColsClone[nX] )
		EndIf
	EndIf
Next

oGet:Refresh()

Return .T.


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
/*
User Function CIE04L()
Local lRet     := .F.
Local aArea    := GetArea()
Local aAreaPA2 := PA2->( GetArea() )


PA2->( dbSetOrder ( 1 ) )
//If PA2->( dbSeek( xFilial( 'PA2' ) + PA4->PA4_CODUNI ) )
If PA2->( dbSeek( xFilial( 'PA2' ) + M->PA4_CODUNI ) )
	lRet     := (PA2->PA2_STATUS == 'I' )                	
EndIf

RestArea( aAreaPA2 )
RestArea( aArea )
Return lRet  
*/
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณLOADIMGUN บAutor  ณ Rubens Lacerda     บ Data ณ  01/12/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para atualizar as imagens nos objetos			      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE								                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function LOADIMGUN(cCampo)  

Local cNameImg := ""
Local cCampoPA := ""   
Local cQuery   := ""

//
//testa o retorno do campo escolhido na tela de cadastro
//
Do case
  
//
//se for unidade, atualiza a imagem refente a unidade
//  
	Case cCampo == "unidade"
	  
		  cCampoPA:= "PA2_BITMAP"

		  cQuery += " SELECT " + cCampoPA + chr(13)  
		  cQuery += "  FROM " + RetSQLName("PA2")+ " PA2, " + RetSQLName("PA4")+ " PA4 "
		  cQuery += "   WHERE PA2_COD = '" + M->PA4_CODUNI + "'" 

		  dbUseArea( .T., 'TOPCONNECT', TcGenQry( ,, cQuery ), 'TRBPA', .F., .T. )		  

		  cNameImg := allTrim(TRBPA->PA2_BITMAP)+".jpg" 
		  oBitMap2:Load(,"\imagens\"+cNameImg)
		  oBitMap2:Refresh()
	      TRBPA->( dbCloseArea() ) 	  

//
//se for documento, atualiza a imagem refente o documento
//  

	Case cCampo == "documento"	  
	      cCampoPA :="PA1_BITMAP"
		  cQuery += " SELECT " + cCampoPA + chr(13)  
		  cQuery += "  FROM " + RetSQLName("PA1")+ " PA1, " + RetSQLName("PA4")+ " PA4 "
		  cQuery += "   WHERE PA1_COD = '" + M->PA4_CODDOC + "'" 		  
		    
		  dbUseArea( .T., 'TOPCONNECT', TcGenQry( ,, cQuery ), 'TRBPA', .F., .T. )

 		  cNameImg := allTrim(TRBPA->PA1_BITMAP)+".jpg" 
		  oBitMap1:Load(,"\imagens\"+cNameImg)
		  oBitMap1:Refresh()
		  TRBPA->( dbCloseArea() ) 
End Case		



return (.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCIEE004   บAutor  ณMicrosiga           บ Data ณ  08/22/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _fAbreObj()

//nRet := ShellExecute ("Open", allTrim(TRB->PA1_BITMAP)+".JPG", "", "\\fenix\P10\Protheus_Data\imagens\", 1)
nRet := ShellExecute ("Open", allTrim(TRB->PA1_BITMAP)+".JPG", "", "\\fenix\imagens\", 1)

If nRet <= 32
	Aviso("Atencao", "Imagem "+allTrim(TRB->PA1_BITMAP)+".JPG nao encontrado!" , { "OK" }, 1.5)
EndIf
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCIEE004   บAutor  ณMicrosiga           บ Data ณ  06/25/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _fStatus()

dbSelectArea( "PA4" )
dbSetOrder( 1 )
dbGotop()
ProcRegua(RecCount())

Do While !EOF()

	IncProc("Processando Status...")
	
	RecLock("PA4",.F.)
		If PA4->PA4_CTVCTO == "S" .and. PA4->PA4_DTVCTO < dDataBase
			PA4->PA4_STATUS := "VENCIDO"
		ElseIf PA4->PA4_ENCE == "S"
			PA4->PA4_STATUS := "ENCERRADO"
		ElseIf PA4->PA4_INDEFE == "S"
			PA4->PA4_STATUS := "INDEFERIDO"
		ElseIf !Empty(PA4->PA4_DTREG)
			PA4->PA4_STATUS := "VIGENTE"
		ElseIf Empty(PA4->PA4_DTREG)
			PA4->PA4_STATUS := "AGUARDANDO"
		EndIf
	MsUnLock()
	dbSelectArea("PA4")
	PA4->(dbSkip())
EndDo
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMAK       บAutor  ณCristiano           บ Data ณ  16/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Mascara Variavel da rotina Vigencia X documento.           บฑฑ
ฑฑบ          ณ Para CNPJ e outros. campo PA4_NUMDOC (SX3)                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MAK(_cDocto)

Local _cMask := ""

_aArea	:= GetArea()

DbSelectArea("PA1")
DbSetOrder(1)
If DbSeek(xFilial("PA1")+_cDocto)
	If PA1->PA1_TPDOC == "01"
		_cMask := "@R 99.999.999/9999-99"
	EndIf
EndIf

RestArea(_aArea)

Return (_cMask+ "%C")