#Include 'Rwmake.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Rcfga00  บAutor  ณ Sergio Oliveira    บ Data ณ  Jun/2008   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cadastro de configuracao do arquivo txt para exportacao dasบฑฑ
ฑฑบ          ณ querys cadastradas.                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico.                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function Rcfga00()

Private cCadastro := "Configurador da Exportacao de Querys"

aRotina := menudef()

//{  { "Pesquisar" ,"AxPesqui" , 0 , 1 } , ;
//{ "Visualizar","U_Rcfga00a(2)", 0 , 2 } , ;
//{ "Incluir"   ,"U_Rcfga00a(3)", 0 , 3 } , ;
//{ "Alterar"   ,"U_Rcfga00a(4)", 0 , 4 } , ;
//{ "Excluir"   ,"U_Rcfga00a(5)", 0 , 5 } , ;
//{ "Exportar"  ,"U_Rcfga99()", 0 , 6 } }

MBrowse(6,1,22,75,"ZAY")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ Rcfga00a บAutor  ณ Sergio Oliveira    บ Data ณ  Jun/2007   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processamento da rotina.                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rcfga00.prw                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function Rcfga00a(pOpcao)

Local aRegs      := {}
Private cCodigo  := IIF( !Inclui, ZAY->ZAY_CODIGO, CriaVar('ZAY_CODIGO') )
Private cDescri  := IIF( !Inclui, ZAY->ZAY_DESCRI, CriaVar('ZAY_DESCRI') )
Private aHeader  := {}
Private aCols    := {}
Private nUsado   := 0
Private nLinGetD := 0
Private cTitulo  := cDescri
Private n := 1

nOpcx := pOpcao

// Opcoes de Acesso

Do Case
	Case nOpcx == 3              // Incluir
		nOpcE := 3; nOpcG := 3
	Case nOpcx == 4              // Alterar
		nOpcE := 3; nOpcG := 3
	Case nOpcx == 2              // Visualizar
		nOpcE := 2; nOpcG := 2
	Case nOpcx == 5              // Excluir
		nOpcE := 2; nOpcG := 2
EndCase

// Criar Variaveis da Enchoice

RegToMemory("ZAY",(nOpcx == 3))

// Montar o GetDados

DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("ZAY")
aCpoEnchoice:={}

While ! Eof() .and. X3_ARQUIVO == "ZAY"
	
	If X3USO(x3_usado) .and. cNivel >= X3_NIVEL
		Aadd(aCpoEnchoice,x3_campo)
	EndIf
	
	DbSkip()
	
EndDo

SX3->( DbSetOrder(1), DbSeek('ZAZ') )

While !SX3->(Eof()) .And. SX3->X3_ARQUIVO == "ZAZ"
	If X3USO(x3_usado) .and. cNivel >= X3_NIVEL
		nUsado := nUsado + 1
		AADD(aHeader,{TRIM(X3_TITULO),X3_CAMPO,;
		X3_PICTURE, X3_TAMANHO, X3_DECIMAL,X3_VALID,;
		X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT})
	EndIf
	SX3->(DbSkip())
EndDo

ZAZ->( DbSetOrder(1), DbSeek( xFilial('ZAZ')+cCodigo ) )

While !ZAZ->(Eof()) .And. ZAZ->(ZAZ_FILIAL+ZAZ_CODIGO) == xFilial("ZAZ")+cCodigo
	Aadd(aCols, Array(nUsado+1))
	For nQ :=1 To nUsado
		aCols[Len(aCols),nQ] := ZAZ->( FieldGet(FieldPos(aHeader[nQ,2])) )
	Next
	aCols[Len(aCols),nUsado + 1] := .F.
	Aadd( aRegs, ZAZ->( Recno() ) )
	ZAZ->(DbSkip())
EndDo

If Len(aCols) == 0
	AADD(aCols,Array(nUsado+1))
	For nQ := 1 To nUsado
		aCols[1,nq] := CriaVar(aHeader[nq,2])
	Next				
	aCols[Len(aCols),nUsado+1] := .F.
EndIf

cTitulo        := "Configuracao das exportacoes"
cAliasEnchoice := "ZAY"
cAliasGetD     := "ZAZ"
cLinOk         := "AllwaysTrue()"
cTudOk         := "AllwaysTrue()"
cFieldOk       := "AllwaysTrue()"
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a entrada de dados do arquivo                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
PRIVATE aTELA[0][0],aGETS[0]
Private aCpos2         := aClone(aCpoEnchoice)
Private aCpos1         := aClone(aCols)
aSize := MsAdvSize()
aObjects := {}
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 015, .t., .f. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )

aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,;
{{003,033,160,200,240,265}} )

oSAY1:=Space(40)
oSAY2:=0
oSAY3:=0
oSAY4:=0

nOpca := 0

DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

EnChoice( "ZAY", ZAY->(Recno()), nOpcx, , , , , aPosObj[1],aCpos2,3,,,"A415VldTOk")
nGetLin := aPosObj[3,1]
	
oGetd:=MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcx,cLinOk,cTudOk,,.T.,,1,,500)

Private oGetDad:=oGetd

ACTIVATE MSDIALOG oDlg ON INIT FMa410Bar(oDlg,{||nOpcA:=1,if(oGetd:TudoOk(),If(!obrigatorio(aGets,aTela),nOpcA := 0,oDlg:End()),nOpcA := 0)},{||oDlg:End()},nOpcx)

If nOpca == 0 // Abandonou
	Return
EndIf

DbSelectArea("ZAY")
If DbSeek( xFilial("ZAY")+cCodigo )
   RecLock('ZAY',.f.)
Else
   RecLock('ZAY',.t.)
EndIf
   ZAY->ZAY_FILIAL := xFilial("ZAY")
For _I:=1 to Len(aCpoEnchoice)
	_xConteud := "M->"+AllTrim(aCpoEnchoice[_i])
	FieldPut( Fieldpos(aCpoEnchoice[_i]), &_xConteud )
Next    
MsUnLock()

DbSelectArea("ZAZ")
DbSetOrder(1)
If pOpcao # 2 // Visualizacao nao pode deletar
	For nRegs := 1 To Len( aRegs ) // Deletar sempre (caso exista)
		cExec := "DELETE FROM "+RetSqlName("ZAZ")+" WHERE R_E_C_N_O_ = "+Str( aRegs[nRegs] )
		TcSqlExec( cExec )
		TcSqlExec( "COMMIT" )
	Next
EndIf
If Altera .Or. Inclui
	For n := 1 To Len(aCols)
		If !aCols[n][Len(aCols[n])]
			RecLock("ZAZ",.t.)
			ZAZ->ZAZ_FILIAL  := xFilial("ZAZ")
			ZAZ->ZAZ_CODIGO  := M->ZAY_CODIGO
			ZAZ->ZAZ_DESCRI  := cDescri
			For nk := 1 To Len( aHeader )
				ZAZ->&(aHeader[nk][2]) := aCols[n][GdFieldPos(aHeader[nk][2])]
			Next
			Msunlock()
		Endif
	Next
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณFMa410Bar ณ Autor ณ Sergio Oliveira       ณ Data ณ Jun/2008 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณ Monta os botoes na tela principal.                         ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Rcfga00.prw                                                ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function FMa410Bar(oDlg,bOk,bCancel,nOpc)

Local aButtons  := {}
Local aButonUsr := {}
Local nI        := 0

Return (EnchoiceBar(oDlg,bOK,bcancel,,aButtons))



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MenuDEF  บ Autor ณEduardo de Souza    บ Data ณ12/Jan/2007  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Implementa menu funcional                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Menus                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define Array contendo as Rotinas a executar do programa      ณ
//ณ ----------- Elementos contidos por dimensao ------------     ณ
//ณ 1. Nome a aparecer no cabecalho                              ณ
//ณ 2. Nome da Rotina associada                                  ณ
//ณ 3. Usado pela rotina                                         ณ
//ณ 4. Tipo de Transao a ser efetuada                          ณ
//ณ    1 - Pesquisa e Posiciona em um Banco de Dados             ณ
//ณ    2 - Simplesmente Mostra os Campos                         ณ
//ณ    3 - Inclui registros no Bancos de Dados                   ณ
//ณ    4 - Altera o registro corrente                            ณ
//ณ    5 - Remove o registro corrente do Banco de Dados          ณ
//ณ    3 - Duplica o registro corrente do Banco de Dados         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Static Function MenuDef()
Local aRotina :=	{  { "Pesquisar" ,"AxPesqui" , 0 , 1 } , ;
						{ "Visualizar","U_Rcfga00a(2)", 0 , 2 } , ;
						{ "Incluir"   ,"U_Rcfga00a(3)", 0 , 3 } , ;
						{ "Alterar"   ,"U_Rcfga00a(4)", 0 , 4 } , ;
						{ "Excluir"   ,"U_Rcfga00a(5)", 0 , 5 } , ;
						{ "Exportar"  ,"U_Rcfga99()", 0 , 6 } }

Return aRotina
