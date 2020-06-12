#include "Rwmake.ch"
#include "TOPCONN.CH"
#Include "Protheus.Ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CBDIA08  บ Autor ณ EMERSON NATALI     บ Data ณ  27/09/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Cadastro de Eventos                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico CIEE - SIGAESP (BDI)                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CBDIA08()

Private cCadastro,_VISUAL
Private aRotina , aCores

aRotina   	:=	{}
cCadastro 	:=	"Cadastro de Eventos"
aRotina  	:=	{ 	{"Pesquisar"	,"AxPesqui"    ,0,1},;
{"Visualisar"	,"U_CBDI08V()" ,0,2},;
{"Incluir"		,"U_CBDI08B()" ,0,3},;
{"Alterar"    	,"U_CBDI08C()" ,0,4},;
{"Excluir"		,"U_CBDI08E()" ,0,5},;
{"Parametros"	,"U_CBDI08D()" ,0,4},;
{"Legenda"		,"U_CBDI08G()" ,0,4}}

aCores		:=	{	{' ZO_IMPRES == "N" .OR. ZO_IMPRES == " "'	,'BR_VERDE'	},;     // NAO IMPRESSO
{' ZO_IMPRES == "S"'	,'BR_VERMELHO'	} } // IMPRESSO

// Monta browse atraves da funcao Mbrowse
mBrowse(6,1,22,74,"SZO",,,,,,aCores)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA08   บAutor  ณMicrosiga           บ Data ณ  11/23/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CBDI08V()

aButtons := {}

_VISUAL := .T.

If SZO->ZO_CATEG == "1"
	AADD(aButtons,{"NOTE",&("{||U_fCateg()}"),"Categoria"})
	AADD(aButtons,{"NOTE",&("{||U_fTpSaida()}"),"Tipo Saida"})
EndIf

_opcao := AxVisual("SZO",Recno(),2,,,,,aButtons)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA08   บAutor  ณMicrosiga           บ Data ณ  11/29/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fCateg()

Local oDlg       := Nil

Private oGet     := Nil
Private aHeader  := {}
Private aCOLS    := {}

// Filtra Tabela de Tipos de Saida com relacao ao Codigo de Evento selecionado
cQuery  := "SELECT * "
cQuery  += " FROM "+RetSQLname('SZP') "
cQuery  += " WHERE D_E_L_E_T_ <> '*' "
cQuery  += " AND ZP_CODEVEN = '"+M->ZO_CODEVEN+"' "
cQuery  += " ORDER BY ZP_CODEVEN"
TcQuery cQuery New Alias "TMP"

dbSelectArea("TMP")
dbGotop()
nCont := 0
Do While !Eof()
	nCont++
	TMP->(DbSkip())
EndDo

nCnt := 0
nUsado := 0
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SZP")
While !EOF() .And. X3_ARQUIVO == "SZP"
	IF X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL
		nUsado++
		AADD(aHeader,{ TRIM(X3Titulo()) ,;
		X3_CAMPO         ,;
		X3_PICTURE       ,;
		X3_TAMANHO       ,;
		X3_DECIMAL       ,;
		X3_VALID         ,;
		X3_USADO         ,;
		X3_TIPO          ,;
		X3_F3            ,;
		X3_CONTEXT       ,;
		X3_CBOX			 ,;
		X3_RELACAO       ,;
		X3_WHEN          ,;
		X3_VISUAL        ,;
		X3_VLDUSER       ,;
		X3_PICTVAR       ,;
		X3_OBRIGAT       })
	Endif
	dbSkip()
End

dbSelectArea("TMP")
dbGotop()

While !EOF()
	aAdd( aCOLS,Array(Len(aHeader)+1))
	nCnt++
	nUsado:=0
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("SZP")
	While !EOF() .And. X3_ARQUIVO == "SZP"
		IF X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL
			nUsado++
			cVarTemp := "TMP"+"->"+(X3_CAMPO)
			If X3_CONTEXT # "V"
				aCOLS[nCnt][nUsado] := &cVarTemp
			ElseIF X3_CONTEXT == "V"
				aCOLS[nCnt][nUsado] := CriaVar(AllTrim(X3_CAMPO))
			Endif
		Endif
		dbSkip()
	End
	aCOLS[nCnt][nUsado+1] := .F.
	dbSelectArea("TMP")
	dbSkip()
End

DEFINE MSDIALOG oDlg TITLE "Categorias" From 8,0 To 28,80 OF oMainWnd

oGet := MsNewGetDados():New(16,2,155,300,,,,,,,,,,,oDlg,aheader,acols)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()})

DbSelectArea("TMP")
DbCloseArea()

Return(.T.)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA08   บAutor  ณMicrosiga           บ Data ณ  09/14/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela de Inclusao                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CBDI08B()

aButtons := {}

INCLUI  := .T.

AADD(aButtons,{"NOTE",&("{||U_fTpSaida()}"),"Tipo Saida"})

_opcao := AxInclui("SZO",0,3,,,,"u_BDI08Ok()",,,aButtons,,,,)

/*
If _opcao == 1 // botao <OK> da Tela de Inclusao
MsgBox("Cadastrar Tipos de Saidas!")
EndIf
*/
Return

User Function BDI08Ok()

_lRet := .T.
aArea := GetArea()
DbSelectArea("SZX")
DbSetOrder(1)
If !DbSeek(xFilial("SZX")+M->ZO_CODEVEN)
	MsgBox("Cadastrar Tipos de Saidas!")
	_lRet := .F.
EndIf
RestArea(aArea)

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA08   บAutor  ณMicrosiga           บ Data ณ  11/23/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CBDI08E()

Begin Transaction
If SZO->ZO_IMPRES == "S"
	msgbox("Nao Pode excluir Evento que ja foi Impresso") 
	Return()
Else
	_opcao := AxDeleta( "SZO", Recno(), 5,"u_BDI08EOk()",,/*aButtons*/)
EndIf
End Transaction

Return

User Function BDI08EOk()

_lRet := .F.
nDel  := 0
aArea := GetArea()
DbSelectArea("SZX")
DbSetOrder(1)
If DbSeek(xFilial("SZX")+SZO->ZO_CODEVEN)
	Do While SZX->ZX_CODEVEN == SZO->ZO_CODEVEN
		RecLock("SZX",.F.)
		dbDelete()
		MsUnLock("SZX")
		nDel ++
		DbSelectArea("SZX")
		DbSkip()
	EndDo
	If nDel > 0
		aArea := GetArea()
		dbSelectArea("SX2")
		dbSetOrder(1)
		dbSeek("SZX")
		RecLock("SX2",.F.)
		SX2->X2_DELET += nDel
		MsUnLock("SX2")
		RestArea( aArea )
	Endif
	_lRet := .T.
EndIf
RestArea(aArea)

Return(_lRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA08   บAutor  ณMicrosiga           บ Data ณ  09/27/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAmarracao do Evento com os Tipos de Saida                   บฑฑ
ฑฑบ          ณEx: (E-mail, Carta, SMS, etc)                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fTpSaida()

Local oDlg       := Nil

Private oGet     := Nil
Private aHeader  := {}
Private aCOLS    := {}

// Filtra Tabela de Tipos de Saida com relacao ao Codigo de Evento selecionado
cQuery  := "SELECT * "
cQuery  += " FROM "+RetSQLname('SZX') "
cQuery  += " WHERE D_E_L_E_T_ <> '*' "
cQuery  += " AND ZX_CODEVEN = '"+M->ZO_CODEVEN+"' "
cQuery  += " ORDER BY ZX_CODEVEN"
TcQuery cQuery New Alias "TMP"

dbSelectArea("TMP")
dbGotop()
nCont := 0
Do While !Eof()
	nCont++
	TMP->(DbSkip())
EndDo

nCnt := 0
nUsado := 0
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SZX")
While !EOF() .And. X3_ARQUIVO == "SZX"
	IF X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL
		nUsado++
		AADD(aHeader,{ TRIM(X3Titulo()) ,;
		X3_CAMPO         ,;
		X3_PICTURE       ,;
		X3_TAMANHO       ,;
		X3_DECIMAL       ,;
		X3_VALID         ,;
		X3_USADO         ,;
		X3_TIPO          ,;
		X3_F3            ,;
		X3_CONTEXT       ,;
		X3_CBOX			 ,;
		X3_RELACAO       ,;
		X3_WHEN          ,;
		X3_VISUAL        ,;
		X3_VLDUSER       ,;
		X3_PICTVAR       ,;
		X3_OBRIGAT       })
	Endif
	dbSkip()
End

dbSelectArea("TMP")
dbGotop()

While !EOF()
	aAdd( aCOLS,Array(Len(aHeader)+1))
	nCnt++
	nUsado:=0
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("SZX")
	While !EOF() .And. X3_ARQUIVO == "SZX"
		IF X3USO(X3_USADO) .AND. cNivel >= X3_NIVEL
			nUsado++
			cVarTemp := "TMP"+"->"+(X3_CAMPO)
			If X3_CONTEXT # "V"
				aCOLS[nCnt][nUsado] := &cVarTemp
			ElseIF X3_CONTEXT == "V"
				aCOLS[nCnt][nUsado] := CriaVar(AllTrim(X3_CAMPO))
			Endif
		Endif
		dbSkip()
	End
	aCOLS[nCnt][nUsado+1] := .F.
	dbSelectArea("TMP")
	dbSkip()
End

DEFINE MSDIALOG oDlg TITLE "Tipo Saida" From 8,0 To 28,80 OF oMainWnd

nGetd   := GD_INSERT+GD_UPDATE+GD_DELETE

aCampos := {}
AADD(aCampos,"ZX_TIPSAI")

If _VISUAL
	oGet := MsNewGetDados():New(16,2,155,300,,"u_fLin()","u_fTud()",,aCampos,,,,,,oDlg,aheader,acols)
Else
	oGet := MsNewGetDados():New(16,2,155,300,nGetd,"u_fLin()","u_fTud()",,aCampos,,,,,,oDlg,aheader,acols)
EndIf

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,Iif(u_fTud(),oDlg:End(),nOpcA:=0)},{||oDlg:End()})

DbSelectArea("TMP")
DbCloseArea()

Return(.t.)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA03   บAutor  ณEmerson Natali      บ Data ณ  27/07/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para validacao da Linha no modelo 2                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fLin()

Local nY := 0
Local nI := 0
Local cMsg := ""

Private lRet     := .T.

n        := oGet:obrowse:nAt
aHeader := oget:aHeader
aCols   := oget:acols

nPos := 0
nPos := aScan(aHeader,{|x|AllTrim(Upper(x[2]))=="ZX_TIPSAI"})

If !aCols[n][nUsado+1]
	If Empty(aCols[n,nPos])
		cMsg := "Nao sera permitido linhas sem o Codigo."
		msgbox(cMsg)
		lRet := .F.
	Endif
Endif

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA03   บAutor  ณEmerson Natali      บ Data ณ  27/07/2006 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para validar a confirmacao do Modelo 2              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function u_fTud()

Private lRet     := .T.

lRet := u_fLin()

If lRet
	Begin Transaction
	Grava()
	End Transaction
Endif

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGrava     บAutor  ณMicrosiga           บ Data ณ  08/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Grava()

Local nI 	:= 0
Local nY 	:= 0
Local cVar 	:= ""
Local lOk 	:= .T.
Local nDel 	:= 0
Local cMsg 	:= ""

dbSelectArea("SZX")
dbSetOrder(1)

For nI := 1 To Len(aCols)
	dbSeek( xFilial("SZX") + M->ZO_CODEVEN +aCols[nI,1])
	
	If !aCols[nI][nUsado+1]
		If Found()
			RecLock("SZX",.F.)
		Else
			RecLock("SZX",.T.)
		Endif
		SZX->ZX_FILIAL  := xFilial("SZX")
		SZX->ZX_CODEVEN := M->ZO_CODEVEN
		For nY := 1 to Len(aHeader)
			If aHeader[nY][10] # "V"
				cVar := Trim(aHeader[nY][2])
				Replace &cVar. With aCols[nI][nY]
			Endif
		Next nY
		MsUnLock("SZX")
	Else
		If !Found()
			Loop
		Endif
		
		If lOk
			RecLock("SZX",.F.)
			dbDelete()
			MsUnLock("SZX")
			nDel ++
		Endif
	Endif
Next nI

If nDel > 0
	aArea := GetArea()
	dbSelectArea("SX2")
	dbSetOrder(1)
	dbSeek("SZX")
	RecLock("SX2",.F.)
	SX2->X2_DELET += nDel
	MsUnLock("SX2")
	RestArea( aArea )
Endif

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA08   บAutor  ณMicrosiga           บ Data ณ  09/14/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela de Alteracao                                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CBDI08C()

aButtons := {}

AADD(aButtons,{"NOTE",&("{||U_fTpSaida()}"),"Tipo Saida"})

_opcao := AxAltera("SZO",Recno(),4,,,,,,,,aButtons,,,)
/*
If _opcao == 1 // botao <OK> da Tela de Alteracao
Alert("Funcionou")
EndIf
*/
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA08   บAutor  ณMicrosiga           บ Data ณ  09/14/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela de Parametros                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CBDI08D()

Local nOpcA  := 0

Private INCLUI := .F.
Private ALTERA := .F.
Private aSize  := MsAdvSize()
Private _cProg
Private _cCodEven := SZO->ZO_CODEVEN

/*
If SZO->ZO_IMPRES == "S"
	MsgBox(OemToAnsi("Etiquetas jแ impressas"))
	Return()
EndIf
*/

aInfo   := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
aObjects:= {}
aCampos := {}

AADD( aObjects,{315,120,.T.,.T.})
AADD( aObjects,{100,400,.T.,.T.})

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SZO")
While !EOF() .And. X3_ARQUIVO == "SZO"
	cCampo := X3_CAMPO
	M->&(cCampo) := SZO->(FieldGet(FieldPos(cCampo)))
	dbSkip()
End

aButtons := {}
AADD(aButtons,{"EDITABLE" ,&("{||U_fValida()}"),"Valida"})
AADD(aButtons,{"IMPRESSAO",&("{||U_CBDIR08()}"),"Imprime"})

DEFINE MSDIALOG oDlg TITLE "Parametros - Eventos" FROM aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

Enchoice("SZO",Recno(),4,,,,,,,3,,,/*TUDOOK*/,,,.T.)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,oDlg:End()},{||oDlg:End()},,aButtons)

If nOpcA == 1
	Begin Transaction
	RecLock("SZO",.F.)
	SZO->ZO_BDIDE   := M->ZO_BDIDE
	SZO->ZO_BDIATE  := M->ZO_BDIATE
//	SZO->ZO_CONTDE  := M->ZO_CONTDE
//	SZO->ZO_CONTATE := M->ZO_CONTATE
	SZO->ZO_ENTDE   := M->ZO_ENTDE
	SZO->ZO_ENTATE  := M->ZO_ENTATE
//	SZO->ZO_GRPDE   := M->ZO_GRPDE
//	SZO->ZO_GRPATE  := M->ZO_GRPATE
	SZO->ZO_CARDE   := M->ZO_CARDE
	SZO->ZO_CARATE  := M->ZO_CARATE
//	SZO->ZO_TRATDE  := M->ZO_TRATDE
//	SZO->ZO_TRATATE := M->ZO_TRATATE
	SZO->ZO_TPSAIDA := M->ZO_TPSAIDA
// 	SZO->ZO_CATDE   := M->ZO_CATDE
// 	SZO->ZO_CATATE  := M->ZO_CATATE
	SZO->ZO_CEPDE   := M->ZO_CEPDE
	SZO->ZO_CEPATE  := M->ZO_CEPATE
	SZO->ZO_CATEG   := M->ZO_CATEG
	SZO->ZO_OBS     := M->ZO_OBS
	SZO->ZO_CONTATO := M->ZO_CONTATO
	SZO->ZO_BDI     := M->ZO_BDI
	SZO->ZO_CARGO   := M->ZO_CARGO
	SZO->ZO_ENTID   := M->ZO_ENTID
	SZO->ZO_ORDEM   := M->ZO_ORDEM
	MsUnLock("SZO")
	End Transaction
Endif

Return(.t.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA08   บAutor  ณMicrosiga           บ Data ณ  09/14/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fValida()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private lInverte := .F.
Private cMarca
Private _nNRREG := 0
Private _nSemEnt := 0
Private _nComEnt := 0
/*
If SZO->ZO_IMPRES == "S"
	MsgBox(OemToAnsi("Etiquetas jแ impressas"))
	Return()
EndIf
*/

_aArea := GetArea()

//Consulta Geral das tabelas de Amarracao do sistema
//MsgRun("Aguarde Selecionando Registros", "Montando Consulta",{|| u_fQuery()()}) // Tela de Consulta
Processa({|| u_fQuery() },"Processando...")

If !AbreExcl("SZ0")
	Return()
EndIf

cQuery  := "SELECT COUNT(*) AS NREG "
cQuery  += "FROM "+RetSQLname('SZ0')+" "
TcQuery cQuery New Alias "NREGTMP"
_nNRREG := NREGTMP->NREG
DbCloseArea("NREGTMP")

DbSelectArea("SZ0") //DbSelectArea("TMP")
DbSetOrder(2) //NOME CONTATO, NOME ENTIDADE, CATEGORIA
DbGotop()

cMarca  := GetMark()
nOpcA	:= 0
aCampos := {}

aAdd(aCampos,{"Z0_OK"      ,"", ""          })
aAdd(aCampos,{"Z0_CONTAT"  ,"", "Contato"   }) //Codigo do Contato
aAdd(aCampos,{"Z0_NOME"    ,"", "Nome"      }) //Nome do Contato
aAdd(aCampos,{"Z0_END"     ,"", "Endereco"  })
aAdd(aCampos,{"Z0_ENTID"   ,"", "Entidade"  }) //Codigo da Entidade
aAdd(aCampos,{"Z0_NOME1"   ,"", "Nome"      }) //Nome da Entidade
aAdd(aCampos,{"Z0_DESCR"   ,"", "Grupo"     }) //Descricao do Grupo
aAdd(aCampos,{"Z0_CARGO"   ,"", "Cargo"     }) //Descricao do Cargo
aAdd(aCampos,{"Z0_TRATAME" ,"", "Tratamento"}) //Descricao do Tratamento
If M->ZO_CATEG == "1"
	aAdd(aCampos,{"Z0_DESCAT"  ,"", "Categoria" }) //Descricao da Categoria
EndIf

aBotao := {}

/*
AADD(aBotao,{"IMPRESSAO",&("{||U_CBDIR04()}"),"Imprime"}) // Word
AADD(aBotao,{"IMPRESSAO",&("{||U_CBDIR05()}"),"Imprime"}) // Impressao Grafica
*/

AADD(aBotao,{"IMPRESSAO",&("{||U_CBDIR06()}"),"Imprime"}) // Crystal

Define MsDialog oDlg1 Title OemToAnsi("Validacao") From 01, 01 to 30, 124 of oMainWnd
oMark := MsSelect():New("SZ0","Z0_OK",,aCampos,@lInverte,@cMarca	,{020, 002, 195, 480})
oMark:oBrowse:lhasMark    := .T.
oMark:oBrowse:lCanAllmark := .T.
oMark:oBrowse:bAllMark    := { || u_fInverte(cMarca) }

@ 200, 030 SAY "Nr Registros:  "+ALLTRIM(STR(_nNRREG))  SIZE 70,7 PIXEL OF oDlg1

Activate MsDialog oDlg1 on init EnchoiceBar(oDlg1,{|| nOpcA := 1,oDlg1:End()},{|| nOpcA := 0, ODlg1:End()},,aBotao) Center

If nOpcA == 1
	/*
	---------------------------------------------------------------------------------------------------
	ESTA ROTINA SERA UTILIZADA PARA GRAVAR EM UMA TABELA SEGUNDARIA OS CONTATOS SELECIONADOS
	---------------------------------------------------------------------------------------------------
	
	DbSelectArea("TMP1")
	dbGoTop()
	Do While !Eof()
	If marked(OK) .or. OK == cMarca .or. !Empty(OK)
		alert("teste")
	EndIf
	TMP1->(dbSKip())
	EndDo
	*/
EndIf

DbSelectArea("SZ0") 
DbCloseArea()
//DbSelectArea("TMP1")
//DbCloseArea()
//fErase("TMP1.DBF")

RestArea(_aArea)

Return

User Function fInverte(cMarca)

//ACRESCENTAR ATUALIZACAO DA MARCA COM UPDATE PARA GANHAR PERFORMANCE.

DbSelectArea("SZ0")
DbSetorder(1)
DbGotop()
Do While !Eof()
	If RecLock("SZ0",.F.)
		If SZ0->Z0_OK == cMarca
			SZ0->Z0_OK := "  "
		Else
			SZ0->Z0_OK := cMarca
		EndIf
		MsUnLock()
	EndIf
	DbSelectArea("SZ0")
	DbSkip()
EndDo
DbGotop()
oMark:oBrowse:Refresh(.t.)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA08   บAutor  ณMicrosiga           บ Data ณ  11/09/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fQuery()

/*
----------------------------------------------------------------
SELECIONA A PARTIR DO CONTATO BDI O CODIGO E O NOME DOS CONTATOS
(E CRIA UM ARQUIVO TEMPORARIO )
----------------------------------------------------------------
*/

cQuery  := "SELECT "//identity(int, 1, 1) as R_E_C_N_O_, "
//cQuery  += "       AC8_COD AS BDI, 
cQuery  += "       AC8_OK AS OK, "
cQuery  += "       U5_CODCONT AS CONTATO, U5_CONTAT AS NOME, U5_FORMALI, U5_AC, "
cQuery  += "       ZM_NOME AS NOME1, "
cQuery  += "       ZQ_CODENT AS ENTIDADE, ZQ_GRUPO AS GRUPO, ZQ_DGRUPO AS DESCR, "
cQuery  += "       ZR_TRAT AS CARTRAT, ZR_CARGO AS CODCARGO, ZR_DESC AS CARGO, ZR_CODTRAT AS CODTRAT, ZR_DESCRI AS TRATAMEN, "
If M->ZO_CATEG == "1"
	cQuery  += "       ZY_COD AS CODCAT, ZY_DESC AS DESCAT, "
EndIf
cQuery  += "       ZS_CODCONT , ZS_CODENT, "//"ZS_END AS ENDERECO, ZS_BAIRRO, ZS_MUN, ZS_EST, ZS_CEP, "
cQuery  += "       ZT_END AS ENDERECO, ZT_BAIRRO AS BAIRRO, ZT_MUN AS MUN, ZT_EST AS EST, ZT_CEP AS CEP, "
cQuery  += "       UM_TRTCARG  INTO TMP1 "
cQuery  += "FROM "+RetSQLname('AC8')+" AC8 "
cQuery  += "LEFT JOIN "+RetSQLname('SU5')+" SU5 ON AC8_CODCON 	= U5_CODCONT "
cQuery  += "LEFT JOIN "+RetSQLname('SZQ')+" SZQ ON ZQ_CODCONT 	= U5_CODCONT "
cQuery  += "LEFT JOIN "+RetSQLname('SZS')+" SZS ON ZS_CODENT	= ZQ_CODENT "
cQuery  += "LEFT JOIN "+RetSQLname('SZY')+" SZY ON ZY_CODCONT 	= ZQ_CODCONT "
cQuery  += "LEFT JOIN "+RetSQLname('SZT')+" SZT ON (ZT_CODCONT    = ZQ_CODCONT "
cQuery  += "                         AND ZT_CODENT = ZQ_CODENT) "
//cQuery  += "                         AND ZT_CODEND = ZS_ITEM) "
cQuery  += "LEFT JOIN "+RetSQLname('SZM')+" SZM ON ZM_CODENT  	= ZQ_CODENT "
cQuery  += "LEFT JOIN "+RetSQLname('SZR')+" SZR ON (ZQ_CODCONT 	= ZR_CODCONT "
cQuery  += "                         AND ZQ_GRUPO  	= ZR_GRUPO "
cQuery  += "                         AND ZQ_CODENT 	= ZR_CODENT) "
cQuery  += "LEFT JOIN "+RetSQLname('SUM')+"     ON UM_CARGO      	= ZR_CARGO "
cQuery  += "WHERE ISNULL(AC8.D_E_L_E_T_,'') <> '*' "
cQuery  += "AND ISNULL(SU5.D_E_L_E_T_,'') <> '*' "
cQuery  += "AND ISNULL(SZQ.D_E_L_E_T_,'') <> '*' "
cQuery  += "AND ISNULL(SZS.D_E_L_E_T_,'') <> '*' "
cQuery  += "AND ISNULL(SZY.D_E_L_E_T_,'') <> '*' "
cQuery  += "AND ISNULL(SZT.D_E_L_E_T_,'') <> '*' "
cQuery  += "AND ISNULL(SZM.D_E_L_E_T_,'') <> '*' "
cQuery  += "AND ISNULL(SZR.D_E_L_E_T_,'') <> '*' "
cQuery  += "AND SZT.ZT_ENDPAD = '1' "
cQuery  += "AND ISNULL(ZM_CODENT, '') <> '' "
If M->ZO_BDI == "1"
	cQuery  += "AND AC8_COD IN (SELECT PAB_CODBDI "
	cQuery  += "					FROM PAB020 "
	cQuery  += "					WHERE PAB_CODEVE = '"+M->ZO_CODEVEN+"') "
Else
	cQuery  += "AND AC8_COD BETWEEN '' AND 'ZZZZZZZZZZ' "
EndIf
If M->ZO_CONTATO == "1"
	cQuery  += "AND U5_CODCONT IN (SELECT PAA_CODCON "
	cQuery  += "					FROM PAA020 "
	cQuery  += "					WHERE PAA_CODEVE = '"+M->ZO_CODEVEN+"') "
Else
	cQuery  += "AND ISNULL(U5_CODCONT, '') BETWEEN '' AND 'ZZZZZZZZZZ' "
EndIf
If M->ZO_ENTID == "1"
	cQuery  += "AND ZQ_CODENT IN (SELECT PAD_CODENT "
	cQuery  += "					FROM PAD020 "
	cQuery  += "					WHERE PAD_CODEVE = '"+M->ZO_CODEVEN+"') "
Else
	cQuery  += "AND ISNULL(ZQ_CODENT, '') BETWEEN '' AND 'ZZZZZZZZZZ' "
EndIf
If M->ZO_CARGO == "1"
	cQuery  += "AND ZR_CARGO IN (SELECT PAC_CODCAR "
	cQuery  += "					FROM PAC020 "
	cQuery  += "					WHERE PAC_CODEVE = '"+M->ZO_CODEVEN+"') "
Else
	cQuery  += "AND ISNULL(ZR_CARGO,'') BETWEEN '' AND 'ZZZZZZZZZZZZZZZ' "
EndIf
cQuery  += "AND ISNULL(ZS_CEP,'')      BETWEEN '"+M->ZO_CEPDE+"'  AND '"+M->ZO_CEPATE+"' "
cQuery  += "AND ((ISNULL(SZS.ZS_CEP,'') <>  '' AND ISNULL(SZT.ZT_CODCONT,'') <> '') OR "
cQuery  += "     (ISNULL(SZS.ZS_CEP,'') =  '' AND ISNULL(SZT.ZT_CODCONT,'') = '')) "
If M->ZO_CATEG == "1"
	cQuery  += "AND ZY_COD IN (SELECT ZP_COD "
	cQuery  += "		FROM SZP020 "
	cQuery  += "		WHERE ZP_CODEVEN = '"+M->ZO_CODEVEN+"') "
EndIf
//cQuery  += "ORDER BY BDI, CONTATO, ENTIDADE, GRUPO "
cQuery  += "ORDER BY CONTATO, ENTIDADE, GRUPO "
//TcQuery cQuery New Alias "TMP"
TcSQLExec(cQuery)

If M->ZO_ENTID == "2" //Pegar todas as Entidades
	cQuery  := "SELECT "//identity(int, 1, 1) as R_E_C_N_O_, "
//	cQuery  += "       AC8_COD AS BDI,
	cQuery  += "       AC8_OK AS OK,  "
	cQuery  += "       U5_CODCONT AS CONTATO, U5_CONTAT AS NOME, U5_FORMALI, U5_AC, "
	cQuery  += "       ZM_NOME AS NOME1, "
	cQuery  += "       ZQ_CODENT AS ENTIDADE, U5_GRUPO AS GRUPO, U5_DGRUPO AS DESCR, "
	cQuery  += "       ZR_TRAT AS CARTRAT, U5_CARGO AS CODCARGO, U5_DESC AS CARGO, U5_NIVEL AS CODTRAT, U5_DNIVEL AS TRATAMEN, "
	If M->ZO_CATEG == "1"
		cQuery  += "       ZY_COD AS CODCAT, ZY_DESC AS DESCAT, "
	EndIf
	cQuery  += "       ZS_CODCONT , ZS_CODENT, ZS_END AS ENDERECO, ZS_BAIRRO AS BAIRRO, ZS_MUN AS MUN, ZS_EST AS EST, ZS_CEP AS CEP, "
	cQuery  += "       UM_TRTCARG  INTO TMP2 "
	cQuery  += "FROM "+RetSQLname('AC8')+" AC8 "
	cQuery  += "LEFT JOIN "+RetSQLname('SU5')+" SU5 ON AC8_CODCON 	= U5_CODCONT "
	cQuery  += "LEFT JOIN "+RetSQLname('SZQ')+" SZQ ON ZQ_CODCONT  	= U5_CODCONT "
	cQuery  += "LEFT JOIN "+RetSQLname('SZS')+" SZS ON ZS_CODCONT	= U5_CODCONT "
	cQuery  += "LEFT JOIN "+RetSQLname('SZY')+" SZY ON U5_CODCONT 	= ZY_CODCONT "
	cQuery  += "LEFT JOIN "+RetSQLname('SZM')+" SZM ON ZM_CODENT  	= ZQ_CODENT "
	cQuery  += "LEFT JOIN "+RetSQLname('SZR')+" SZR ON (ZQ_CODCONT 	= ZR_CODCONT "
	cQuery  += "                         AND ZQ_GRUPO  	= ZR_GRUPO "
	cQuery  += "                         AND ZQ_CODENT 	= ZR_CODENT) "
	cQuery  += "LEFT JOIN "+RetSQLname('SUM')+" ON UM_CARGO      	= ZR_CARGO "
	cQuery  += "LEFT JOIN "+RetSQLname('SQ0')+" SQ0 ON U5_GRUPO    	= Q0_GRUPO "
	cQuery  += "WHERE ISNULL(AC8.D_E_L_E_T_,'') <> '*' "
	cQuery  += "AND ISNULL(SU5.D_E_L_E_T_,'') <> '*' "
	cQuery  += "AND ISNULL(SZQ.D_E_L_E_T_,'') <> '*' "
	cQuery  += "AND ISNULL(SZS.D_E_L_E_T_,'') <> '*' "
	cQuery  += "AND ISNULL(SZY.D_E_L_E_T_,'') <> '*' "
	cQuery  += "AND ISNULL(SZM.D_E_L_E_T_,'') <> '*' "
	cQuery  += "AND ISNULL(SZR.D_E_L_E_T_,'') <> '*' "
	cQuery  += "AND SZS.ZS_ENDPAD = '1' "
	If M->ZO_BDI == "1"
		cQuery  += "AND AC8_COD IN (SELECT PAB_CODBDI "
		cQuery  += "					FROM PAB020 "
		cQuery  += "					WHERE PAB_CODEVE = '"+M->ZO_CODEVEN+"') "
	Else
		cQuery  += "AND AC8_COD BETWEEN '' AND 'ZZZZZZZZZZ' "
	EndIf
	If M->ZO_CONTATO == "1"
		cQuery  += "AND U5_CODCONT IN (SELECT PAA_CODCON "
		cQuery  += "					FROM PAA020 "
		cQuery  += "					WHERE PAA_CODEVE = '"+M->ZO_CODEVEN+"') "
	Else
		cQuery  += "AND ISNULL(U5_CODCONT, '') BETWEEN '' AND 'ZZZZZZZZZZ' "
	EndIf
	If M->ZO_CARGO == "1"
		cQuery  += "AND U5_CARGO IN (SELECT PAC_CODCAR "
		cQuery  += "					FROM PAC020 "
		cQuery  += "					WHERE PAC_CODEVE = '"+M->ZO_CODEVEN+"') "
	Else
		cQuery  += "AND ISNULL(U5_CARGO,'') BETWEEN '' AND 'ZZZZZZZZZZZZZZZ' "
	EndIf
	cQuery  += "AND ISNULL(ZS_CEP,'')      BETWEEN '"+M->ZO_CEPDE+"'  AND '"+M->ZO_CEPATE+"' "
	If M->ZO_CATEG == "1"
		cQuery  += "AND ZY_COD IN (SELECT ZP_COD "
		cQuery  += "		FROM SZP020 "
		cQuery  += "		WHERE ZP_CODEVEN = '"+M->ZO_CODEVEN+"') "
	EndIf
//	cQuery  += "ORDER BY BDI, CONTATO, ENTIDADE, GRUPO "
	cQuery  += "ORDER BY CONTATO, ENTIDADE, GRUPO "
	TcSQLExec(cQuery)
EndIf

If AbreExcl("SZ0")
	cQuery  := "DELETE "+RetSQLname('SZ0')+" "
	TcSQLExec(cQuery)
Else
	Return()
EndIf

If M->ZO_ENTID == "2" //Pegar todas as Entidades
	cQuery  := "UPDATE TMP2 SET NOME1 = '' "
	TcSQLExec(cQuery)
	cQuery  := "UPDATE TMP2 SET ENTIDADE = '' "
	TcSQLExec(cQuery)
EndIf

cQuery  := "SELECT DISTINCT * INTO TMP3 "
cQuery  += "FROM TMP1 "
If M->ZO_ENTID == "2" //Pegar todas as Entidades
	cQuery  += "UNION ALL "
	cQuery  += "SELECT DISTINCT * "
	cQuery  += "FROM TMP2 "
EndIf
TcSQLExec(cQuery)

//cQuery  := "SELECT BDI, OK, CONTATO, NOME, U5_FORMALI, U5_AC, NOME1, ENTIDADE, GRUPO, DESCR,"
cQuery  := "SELECT OK, CONTATO, NOME, U5_FORMALI, U5_AC, NOME1, ENTIDADE, GRUPO, DESCR,"
cQuery  += "CARTRAT, CODCARGO, CARGO, CODTRAT, TRATAMEN, "
If M->ZO_CATEG == "1"
	cQuery  += "CODCAT, DESCAT, "
EndIf
cQuery  += "ZS_CODCONT ,"
cQuery  += "ENDERECO, BAIRRO, MUN, EST, CEP,"
cQuery  += "UM_TRTCARG, "
cQuery  += "identity(int, 1, 1) as R_E_C_N_O_  INTO TMP4 "
cQuery  += "FROM TMP3
TcSQLExec(cQuery)

cQuery  := "INSERT "+RetSQLname('SZ0')+" "
cQuery  += "SELECT "
cQuery  += "'' , "
cQuery  += "ISNULL(OK,'') , "
cQuery  += "ISNULL(CONTATO,''), "
cQuery  += "ISNULL(NOME,''), "
cQuery  += "ISNULL(ENDERECO,''), "
cQuery  += "ISNULL(ENTIDADE,''), "
cQuery  += "ISNULL(NOME1,''), "
cQuery  += "ISNULL(DESCR,''), "
cQuery  += "ISNULL(CARGO,''), "
cQuery  += "ISNULL(TRATAMEN,''), "
If M->ZO_CATEG == "1"
	cQuery  += "ISNULL(DESCAT,''), "
Else
	cQuery  += "'', "
EndIf
cQuery  += "ISNULL(BAIRRO,''), "
cQuery  += "ISNULL(MUN,''), "
cQuery  += "ISNULL(EST,''), "
cQuery  += "ISNULL(Substring(CEP,1,5)+'-'+Substring(CEP,6,3),''), "
cQuery  += "ISNULL(GRUPO,''), "
cQuery  += "ISNULL(CODCARGO,''), "
cQuery  += "ISNULL(CARTRAT,''), "
cQuery  += "ISNULL(CODTRAT,''), "
cQuery  += "ISNULL(U5_FORMALI,''), "
cQuery  += "ISNULL(U5_AC,''), "
cQuery  += "ISNULL(UM_TRTCARG,''), "
If M->ZO_CATEG == "1"
	cQuery  += "ISNULL(CODCAT,''), "
Else
	cQuery  += "'', "
EndIf
cQuery  += "'"+M->ZO_CODEVEN+"', " 
cQuery  += "'', "
cQuery  += "R_E_C_N_O_ "
cQuery  += "FROM TMP4 "
TcSQLExec(cQuery)

cQuery  := "DROP TABLE TMP1 "
TcSQLExec(cQuery)
If M->ZO_ENTID == "2" //Pegar todas as Entidades
	cQuery  := "DROP TABLE TMP2 "
	TcSQLExec(cQuery)
EndIf
cQuery  := "DROP TABLE TMP3 "
TcSQLExec(cQuery)
cQuery  := "DROP TABLE TMP4 "
TcSQLExec(cQuery)

/*
_aTmp1 := {}
aAdd(_aTmp1,{"OK"        ,"C", 02,0})
aAdd(_aTmp1,{"CONTATO"   ,"C", 06,0}) //Codigo do Contato
aAdd(_aTmp1,{"NOME"      ,"C", 60,0}) //Nome do Contato
aAdd(_aTmp1,{"ENDERECO"  ,"C", 60,0})
aAdd(_aTmp1,{"ENTIDADE"  ,"C", 06,0}) //Codigo da Entidade
aAdd(_aTmp1,{"NOME1"     ,"C", 75,0}) //Nome da Entidade
aAdd(_aTmp1,{"DESCR"     ,"C", 30,0}) //Descricao do Grupo
aAdd(_aTmp1,{"CARGO"     ,"C", 55,0}) //Descricao do Cargo
aAdd(_aTmp1,{"TRATAMEN"  ,"C", 20,0}) //Descricao do Tratamento
aAdd(_aTmp1,{"DESCAT"    ,"C", 100,0})//Descricao da Categoria
aAdd(_aTmp1,{"BAIRRO"    ,"C", 30,0})
aAdd(_aTmp1,{"MUN"       ,"C", 30,0})
aAdd(_aTmp1,{"EST"       ,"C", 02,0})
aAdd(_aTmp1,{"CEP"       ,"C", 09,0})
aAdd(_aTmp1,{"GRUPO"     ,"C", 02,0}) //Codigo do Grupo
aAdd(_aTmp1,{"CODCARGO"  ,"C", 04,0}) //Codigo do Cargo
aAdd(_aTmp1,{"CARTRAT"   ,"C", 01,0}) //Descricao do Tratamento do Cargo "do, da, de"
aAdd(_aTmp1,{"CODTRAT"   ,"C", 02,0}) //Codigo do Tratamento
aAdd(_aTmp1,{"FORMALI"   ,"C", 03,0})
aAdd(_aTmp1,{"AC"        ,"C", 150,0})
aAdd(_aTmp1,{"TRTCARG"   ,"C", 35,0}) //Tratamento Dignissimo/
aAdd(_aTmp1,{"CODCAT"    ,"C", 03,0}) //Codigo da Categoria
aAdd(_aTmp1,{"CODEVEN"   ,"C", 06,0}) //Codigo do Evento

dbCreate("TMP1",_aTmp1)
dbUseArea(.T.,,"TMP1","TMP1",.F.)
_cIndTMP1 := CriaTrab(NIL,.F.)
_cChave   := "CONTATO"
IndRegua("TMP1",_cIndTMP1,_cChave,,,"Indice Temporario...")

DbSelectArea("TMP")
DbGotop()
ProcRegua(RecCount())
_lEndPad  := .F.
_cContAnt := TMP->CONTATO
Do While !EOF()
	IncProc()
	If TMP->CONTATO <> _cContAnt
		_lEndPad  := .F.
		_cContAnt := TMP->CONTATO
	EndIf
	
	If TMP->SZM == "*"
		DbSelectArea("TMP")
		DbSkip()
		Loop
	EndIf
	
	If TMP->SZY == "*"
		DbSelectArea("TMP")
		DbSkip()
		Loop
	EndIf
	
	If Empty(TMP->ENTIDADE)
*/
		/*
		DbSelectArea("SZS")
		DbSetOrder(4) //FILIAL + CONTATO
		If DbSeek(xFilial("SZS")+TMP->CONTATO)
		Do While SZS->ZS_CODCONT == TMP->CONTATO .and. !_lEndPad
		If SZS->ZS_ENDPAD == "1" //SIM
		If M->ZO_CATEG == "1" //SIM
		DbSelectArea("SZP")
		DbSetOrder(4)
		If !DbSeek(xFilial("SZP")+_cCodEven+TMP->CODCAT)
		Exit
		EndIf
		EndIf
		RecLock("TMP1",.T.)
		TMP1->OK       := TMP->OK
		TMP1->CODEVEN  := _cCodEven
		TMP1->CONTATO  := TMP->CONTATO
		TMP1->NOME     := TMP->NOME
		TMP1->ENDERECO := SZS->ZS_END
		TMP1->BAIRRO   := SZS->ZS_BAIRRO
		TMP1->MUN      := SZS->ZS_MUN
		TMP1->EST      := SZS->ZS_EST
		TMP1->CEP      := SZS->ZS_CEP
		TMP1->CODCAT   := SZP->ZP_COD
		TMP1->DESCAT   := TMP->DESCAT
		DbSelectArea("SU5")
		DbSetOrder(1)
		If DbSeek(xFilial("SU5")+TMP->CONTATO)
		TMP1->GRUPO		:=	SU5->U5_GRUPO
		TMP1->DESCR		:=	SU5->U5_DGRUPO
		TMP1->CODCARGO	:=	SU5->U5_CARGO
		TMP1->CARGO		:=	SU5->U5_DESC
		TMP1->CODTRAT	:=	SU5->U5_NIVEL
		TMP1->TRATAMEN	:=	SU5->U5_DNIVEL
		TMP1->FORMALI	:=	SU5->U5_FORMALI
		TMP1->AC		:=	SU5->U5_AC
		EndIf
		DbSelectArea("SUM")
		DbSetOrder(2)
		If DbSeek(xFilial("SUM")+SU5->U5_DESC)
		TMP1->TRTCARG	:=	SUM->UM_TRTCARG
		EndIf
		MsUnLock()
		_nNRREG++
		EndIf
		_nSemEnt++
		DbSelectArea("SZS")
		DbSkip()
		EndDo
		_lEndPad := .T.
		EndIf
		*/
/*
	EndIf
	
	If !Empty(TMP->ENTIDADE)
		If TMP->SZQ <>"*" // Contatos X Entidade
			If M->ZO_CATEG == "1" //NAO
				DbSelectArea("SZP")
				DbSetOrder(4)
				If !DbSeek(xFilial("SZP")+_cCodEven+TMP->CODCAT)
					DbSelectArea("TMP")
					DbSkip()
					Loop
				EndIf
			EndIf
			RecLock("TMP1",.T.)
			TMP1->OK       := TMP->OK
			TMP1->CODEVEN  := _cCodEven
			TMP1->CONTATO  := TMP->CONTATO
			TMP1->NOME     := TMP->NOME
			TMP1->ENDERECO := TMP->ZT_END
			TMP1->BAIRRO   := TMP->ZS_BAIRRO
			TMP1->MUN      := TMP->ZS_MUN
			TMP1->EST      := TMP->ZS_EST
			TMP1->CEP      := TMP->ZS_CEP
			TMP1->ENTIDADE  := TMP->ENTIDADE
			TMP1->NOME1     := TMP->NOME1
			TMP1->GRUPO     := TMP->GRUPO
			TMP1->DESCR     := TMP->DESCR
			TMP1->FORMALI	:= TMP->U5_FORMALI
			TMP1->AC		:= TMP->U5_AC
			TMP1->CODCAT    := TMP->CODCAT
			TMP1->DESCAT    := TMP->DESCAT
			If TMP->SZR <>"*" // Perfil
				TMP1->CODCARGO := TMP->CODCARGO
				TMP1->CARGO    := TMP->CARGO
				TMP1->CARTRAT  := TMP->CARTRAT  // Complemento do Cargo - "do, da, de"
				TMP1->CODTRAT  := TMP->CODTRAT
				TMP1->TRATAMEN := TMP->TRATAMENTO
				TMP1->TRTCARG	:=	TMP->UM_TRTCARG
			Else
				TMP1->CODCARGO := ""
				TMP1->CARGO    := ""
				TMP1->CARTRAT  := ""
				TMP1->CODTRAT  := ""
				TMP1->TRATAMEN := ""
				TMP1->TRTCARG  := ""
			EndIf
			MsUnLock()
			_nNRREG++
		EndIf
		_nComEnt++
	EndIf
	
	DbSelectArea("TMP")
	DbSkip()
EndDo

alert("Numero de Registro Sem Entidade"+strzero(_nSemEnt,8))
alert("Numero de Registro Com Entidade"+strzero(_nComEnt,8))
*/

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA08   บAutor  ณMicrosiga           บ Data ณ  09/14/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CBDI08G()

Local aCores, cCadastro

aCores		:= {}
cCadastro	:= "Eventos"
aCores		:={	{'BR_VERMELHO','Impresso'		},;
{'BR_VERDE'   ,'Nao Impresso'	}}

BrwLegenda(cCadastro,"Legenda",aCores)

Return(.t.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIA08   บAutor  ณMicrosiga           บ Data ณ  08/23/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria aHeader com base no SX3                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _fCabec(cCabec)

// Cria aHeader com base no SX3
AADD(&cCabec,{ TRIM(X3Titulo()) ,;
X3_CAMPO         ,;
X3_PICTURE       ,;
X3_TAMANHO       ,;
X3_DECIMAL       ,;
X3_VALID         ,;
X3_USADO         ,;
X3_TIPO          ,;
X3_F3            ,;
X3_CONTEXT       ,;
X3_CBOX			 ,;
X3_RELACAO       ,;
X3_WHEN          ,;
X3_VISUAL        ,;
X3_VLDUSER       ,;
X3_PICTVAR       ,;
X3_OBRIGAT       })
Return