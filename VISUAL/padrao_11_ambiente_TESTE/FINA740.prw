#INCLUDE "fina740.ch"
#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ FINA740	³ Autor ³ Claudio D. de Souza   ³ Data ³ 11/11/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Tela unica do contas a receber, que permitira ao usuario   ³±±
±±³          ³ manipular as opcoes distribuidas nos menus de contas a Rec.³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function FinA740
PRIVATE aRotina := MenuDef()
PRIVATE cCadastro := STR0011                             //"Contas a Receber"
PRIVATE lF060LOOP := .T.		// VARIAVEL LOGICA PARA ROTINA FINA060
cPorta740  := CriaVar("E1_PORTADO",.F.)
cBanco740  := CriaVar("E1_PORTADO",.F.)
cAgenc740  := CriaVar("E1_AGEDEP" ,.F.)
cConta740  := CriaVar("E1_CONTA"  ,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada para pre-validar os dados a serem  ³
//³ exibidos.                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF ExistBlock("F740BROW")
	ExecBlock("F740BROW",.f.,.f.)
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Endereca a funcao de BROWSE											  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
mBrowse( 6, 1,22,75,"SE1",,,,,, Fa040Legenda("SE1"))

Return Nil

Static Function MenuDef()
Local aRotina := {}
Local aAreaSe1 
Local aRot040 := {}
Local aRot060 := {}
Local aRot070 := {}
Local aRot280 := {}
Local aRot330 := {}
Local aRot460 := {}
Local aRot175 := {}

//Passado como parametro a posicao da opcao dentro da arotina
aRot040 :=	{	{ STR0013,"Fin740040", 0 , 3},; //"Incluir"
					{ STR0014,"Fin740040", 0 , 4},; //"Alterar"
					{ STR0015,"Fin740040", 0 , 5},; //"Excluir"
					{ STR0016,"Fin740040", 0 , 6}} //"Substituir"

//Passado como parametro a posicao da opcao dentro da arotina
aRot060 :=	{	{ STR0017, "Fin740060", 0 , 4},; //"Transferir"
					{ STR0018, "Fin740060", 0 , 3},; //"Borderô"
					{ STR0019, "Fin740060", 0 , 3}} //"Cancelar"

//Passado como parametro o conteudo da posicao 4 da aRotina Original
aRot070 :=	{	{ STR0020, "Fin740070", 0 , 4},; //"Baixar"
					{ STR0021, "Fin740070", 0 , 4},; //"Lote"
					{ STR0022, "Fin740070", 0 , 5},; //"Canc Baixa"
					{ STR0015, "Fin740070", 0 , 6}} //"Excluir"


//Passado como parametro a posicao da opcao dentro da arotina
aRot280 :=	{	{ STR0023, "Fin740280", 0 , 3},;  //"Selecionar"
					{ STR0019, "Fin740280", 0 , 4} } //"Cancelar"
 
//Passado como parametro a posicao da opcao dentro da arotina
aRot330 :=	{	{ STR0024, "Fin740330", 0 , 4},;  //"Compensar"
					{ STR0015, "Fin740330", 0 , 4},; //"Excluir"
					{ STR0030, "Fin740330", 0 , 4} } //"Estornar"

aRot460 := {	{ STR0025, "Fin740460" , 0 , 3 },;   //"Liquidar"
					{ STR0026, "Fin740460" , 0 , 3 },; //"Reliquidar"
					{ STR0019, "Fin740460" , 0 , 6 }}  //"Cancelar"

aRot175 := {	{STR0027, "Fin740150", 0, 3},; //"Gera arq envio"
					{STR0028, "Fin740150", 0, 3}} //"Lê arq retorno"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo as Rotinas a executar do programa 	  ³
//³ ----------- Elementos contidos por dimensao ------------	  ³
//³ 1. Nome a aparecer no cabecalho 									  ³
//³ 2. Nome da Rotina associada											  ³
//³ 3. Usado pela rotina													  ³
//³ 4. Tipo de Transa‡„o a ser efetuada								  ³
//³	 1 -Pesquisa e Posiciona em um Banco de Dados				  ³
//³	 2 -Simplesmente Mostra os Campos								  ³
//³	 3 -Inclui registros no Bancos de Dados						  ³
//³	 4 -Altera o registro corrente									  ³
//³	 5 -Exclui um registro cadastrado								  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAreaSe1 := {}
aAdd( aRotina,	{ STR0029,aRot040, 0 , 3}) //"Opções CR" //"Ctas a Receber"
aAdd( aRotina,	{ STR0003,aRot060, 0 , 4}) //"Transf/Borderô"
aAdd( aRotina,	{ STR0004,aRot070, 0 , 5})  //"Bai&xas"
aAdd( aRotina,	{ STR0006,aRot280, 0 , 6}) //"Faturas"
aAdd( aRotina,	{ STR0007,aRot330, 0 , 6}) //"Co&mpensação"
aAdd( aRotina,	{ STR0008,aRot460, 0 , 6}) //"Liquidação"
aAdd( aRotina,	{ STR0009,aRot175, 0 , 6}) //"CNA&B"
aAdd( aRotina,	{ STR0001,"AxPesqui", 0 , 1,,.F. }) //"Pesquisar"
aAdd( aRotina,	{ STR0012,"FA280Visua", 0 , 2}) //"Visualizar"
aAdd( aRotina,	{ STR0010,"FA040Legenda", 0 , 6, ,.F.}) //"Le&genda"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ P.E. utilizado para adicionar itens no Menu da mBrowse       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("FA740BRW")
	aRotAdic := ExecBlock("FA740BRW",.F.,.F.,{aRotina})
	If ValType(aRotAdic) == "A"
		AEval(aRotAdic,{|x| AAdd(aRotina,x)})
	EndIf
EndIf


Return(aRotina)    

Function Fin740040(cAlias, nReg, nOpc)
Local nOrd := 	SE1->(IndexOrd())
Local cFilter := SE1->(DbFilter())

	SetRotInteg('FINA040')
	
	Do Case 
	Case nOpc == 1
		FINA040(,3)
	Case nOpc == 2
		FINA040(,4)	
	Case nOpc == 3
		FINA040(,5)
	Case nOpc == 4
		FINA040(,6)
	EndCase	
	
	Set Filter to &cFilter
SE1->(DbSetOrder(nOrd))
Return	      


Function Fin740060(cAlias, nReg, nOpc)
Local nOrd := 	SE1->(IndexOrd())
Local cFilter := SE1->(DbFilter())
Local aAreaSEA	:= SEA->(GetArea())

DbSelectArea("SEA")
DbSetOrder(1)
DbSeek(xFilial("SEA") + SE1->(E1_NUMBOR + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO) )

	Do Case 
	Case nOpc == 1
		FINA060(2)
	Case nOpc == 2
		FINA060(3)
	Case nOpc == 3
		Iif( SEA->(FieldPos("EA_ORIGEM")) > 0 .And. "FINA060" $ SEA->EA_ORIGEM,FINA060(4),FINA061(3))
	EndCase	
	
	Set Filter to &cFilter
SE1->(DbSetOrder(nOrd))
RestArea(aAreaSEA)
Return	      

Function Fin740070(cAlias, nReg, nOpc)
Local nOrd := 	SE1->(IndexOrd())
Local cFilter := SE1->(DbFilter())

	SetRotInteg('FINA070')

	Do Case 
	Case nOpc == 1
		FINA070(,3,.T.)
	Case nOpc == 2
		FINA070(,4,.T.)
	Case nOpc == 3
		FINA070(,5,.T.)
	Case nOpc == 4
		FINA070(,6,.T.)
	EndCase	
	
	Set Filter to &cFilter
SE1->(DbSetOrder(nOrd))
Return	      

Function Fin740280(cAlias, nReg, nOpc)
Local nOrd := 	SE1->(IndexOrd())
Local cFilter := SE1->(DbFilter())

	SetRotInteg('FINA280')

	Do Case 
	Case nOpc == 1
		FINA280(3)
	Case nOpc == 2
		FINA280(4)
	EndCase	
	
	Set Filter to &cFilter
SE1->(DbSetOrder(nOrd))
Return	      

Function Fin740330(cAlias, nReg, nOpc)
Local nOrd := 	SE1->(IndexOrd())
Local cFilter := SE1->(DbFilter())

	Do Case 
	Case nOpc == 1
		FINA330(3)
	Case nOpc == 2
		FINA330(4)
	Case nOpc == 3
	 	FINA330(5)
	EndCase	
	
	Set Filter to &cFilter
SE1->(DbSetOrder(nOrd))
Return	      

Function Fin740460(cAlias, nReg, nOpc)
Local nOrd := 	SE1->(IndexOrd())
Local cFilter := SE1->(DbFilter())

	SetRotInteg('FINA460')

	Do Case 
	Case nOpc == 1
		FINA460(2)
	Case nOpc == 2
		FINA460(3)
	Case nOpc == 3
	 	FINA460(4)
	EndCase	
	
	Set Filter to &cFilter
SE1->(DbSetOrder(nOrd))
Return	      


Function Fin740150(cAlias, nReg, nOpc)
Local nOrd := 	SE1->(IndexOrd())
Local cFilter := SE1->(DbFilter())

	Do Case 
	Case nOpc == 1
		Fina150(3)
	Case nOpc == 2
		Fina200(3)
	EndCase	
	
	Set Filter to &cFilter
SE1->(DbSetOrder(nOrd))
Return	      
