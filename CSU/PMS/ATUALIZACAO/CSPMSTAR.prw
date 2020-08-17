#Include "Protheus.ch"
#include "TOPCONN.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CSPMSTAR ³ Autor ³ Douglas Coelho         ³ Data ³ 28/04/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³AxCadastro para tabela ZZ1 Tarefa e EDT - PMS OS 0887/17     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico CSU                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CSPMSTAR()

AxCadastro("ZZ1","CADASTRO DE DESCRIÇÃO DE TAREFAS E EDT" , ".T." , "U_CsTarEdt()")

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ CsTarEdt ºAutor  ³Douglas David      º Data ³ Maio/2017    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida se a Descrição ja existe.                  		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CsTarEdt.prw                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CsTarEdt()

Local lRet   := .T.
Local cDesc  := ""
Local cTipo  := ""
Local cQuery := ""

cDesc := Alltrim(M->ZZ1_DESCRI)
cTipo := Alltrim(M->ZZ1_TIPO)

cQuery := "SELECT COUNT(*) AS QUANT "
cQuery += "FROM " + RetSqlName( "ZZ1" ) + " ZZ1 "
cQuery += "WHERE ZZ1.ZZ1_DESCRI = '" + cDesc + "' "
cQuery += "AND 	ZZ1.ZZ1_TIPO = '" + cTipo + "' "
cQuery += "AND ZZ1.D_E_L_E_T_ = '' "

If Select("TM2") > 0
	DbSelectArea("TM2")
	DbCloseArea()
Endif

TcQuery cQuery New Alias "TM2"
_nTotreg := TM2->QUANT

If _nTotreg > 0
	
	Aviso("JA EXISTE","A Descrição ja existe! Favor verificar!",;
	{"&Fechar"},3,"Informação já Existente",,;
	"qmt_no")
	lRet := .F.
EndIf

DbSelectArea("TM2")
DbCloseArea()

Return( lRet )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ CsAfcEDT ºAutor  ³Douglas David      º Data ³ Maio/2017    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida se a Descrição ja existe na EDT              		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CsAfcEDT.prw                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CsAfcEDT()

Local lRet   := .T.
Local Filial := ""
Local cPrj   := ""
Local cRevi  := ""
Local cEDT   := ""
Local cDesc  := ""
Local cQuery := ""

Filial:= AFC->AFC_FILIAL
cPrj  := Alltrim(AFC->AFC_PROJET)
cRevi := Alltrim(AFC->AFC_REVISA)
cDesc := Alltrim(M->AFC_DESCRI)

cQuery := "SELECT COUNT(*) AS QUANT "
cQuery += "FROM " + RetSqlName( "AFC" ) + " AFC "
cQuery += "WHERE AFC.AFC_FILIAL = '" + Filial + "' "
cQuery += "AND 	AFC.AFC_PROJET = '" + cPrj + "' "
cQuery += "AND 	AFC.AFC_REVISA = '" + cRevi + "' "
cQuery += "AND 	AFC.AFC_DESCRI = '" + cDesc + "' "
cQuery += "AND AFC.D_E_L_E_T_ = '' "

If Select("TM3") > 0
	DbSelectArea("TM3")
	DbCloseArea()
Endif

TcQuery cQuery New Alias "TM3"
_nTotreg := TM3->QUANT

If _nTotreg > 0
	
	Aviso("JA EXISTE","A Descrição ja existe, na EDT! Favor verificar!",;
	{"&Fechar"},3,"Informação já Existente",,;
	"qmt_no")
	lRet := .F.
EndIf

DbSelectArea("TM3")
DbCloseArea()

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ CsAfcEDT ºAutor  ³Douglas David      º Data ³ Maio/2017    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida se a Descrição ja existe na EDT              		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CsAfcEDT.prw                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CsAf9Tar()

Local lRet   := .T.
Local Filial := ""
Local cPrj   := ""
Local cRevi  := ""
Local cDesc  := ""
Local cQuery := ""

cPrj  := Alltrim(M->AF9_PROJET)
cRevi := Alltrim(M->AF9_REVISA)
cDesc := Alltrim(M->AF9_DESCRI)

cQuery := "SELECT COUNT(*) AS QUANT "
cQuery += "FROM " + RetSqlName( "AF9" ) + " AF9 "
cQuery += "WHERE AF9.AF9_PROJET = '" + cPrj + "' " 
cQuery += "AND 	AF9.AF9_REVISA = '" + cRevi + "' "
cQuery += "AND 	AF9.AF9_DESCRI = '" + cDesc + "' "
cQuery += "AND AF9.D_E_L_E_T_ = '' "

If Select("TM6") > 0
	DbSelectArea("TM6")
	DbCloseArea()
Endif

TcQuery cQuery New Alias "TM6"
_nTotreg := TM6->QUANT

If _nTotreg > 0
	
	Aviso("JA EXISTE","A Descrição ja existe, em Tarefas! Favor verificar!",;
	{"&Fechar"},3,"Informação já Existente",,;
	"qmt_no")
	lRet := .F.
EndIf

DbSelectArea("TM6")
DbCloseArea()

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ VerDescri ºAutor  ³Douglas David      º Data ³ Maio/2017   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida se a Descrição existe na tabela ZZ1         		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ VerDescri.prw                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VerDescAFC()

Local lRet   := .T.
Local cDesc  := ""
Local cTipo  := ""
Local cQuery := ""

cDesc := Alltrim(M->AFC_DESCRI)
cTipo := "E"

cQuery := "SELECT COUNT(*) AS QUANT "
cQuery += "FROM " + RetSqlName( "ZZ1" ) + " ZZ1 "
cQuery += "WHERE ZZ1.ZZ1_DESCRI = '" + cDesc + "' "
cQuery += "AND 	ZZ1.ZZ1_TIPO = '" + cTipo + "' "
cQuery += "AND ZZ1.D_E_L_E_T_ = '' "

If Select("TM4") > 0
	DbSelectArea("TM4")
	DbCloseArea()
Endif

TcQuery cQuery New Alias "TM4"
_nTotreg := TM4->QUANT

If _nTotreg == 0
	
	MsgAlert("Atenção: Descrição não existe no cadastro!")
	lRet := .F.
EndIf

DbSelectArea("TM4")
DbCloseArea()

Return( lRet )

//Tabela de Tarefas AF9

User Function VerAF9Desc()

Local lRet   := .T.
Local cDesc  := ""
Local cTipo  := ""
Local cQuery := ""

cDesc := Alltrim(M->AF9_DESCRI)
cTipo := "T"

cQuery := "SELECT COUNT(*) AS QUANT "
cQuery += "FROM " + RetSqlName( "ZZ1" ) + " ZZ1 "
cQuery += "WHERE ZZ1.ZZ1_DESCRI = '" + cDesc + "' "
cQuery += "AND 	ZZ1.ZZ1_TIPO = '" + cTipo + "' "
cQuery += "AND ZZ1.D_E_L_E_T_ = '' "

If Select("TM5") > 0
	DbSelectArea("TM5")
	DbCloseArea()
Endif

TcQuery cQuery New Alias "TM5"
_nTotreg := TM5->QUANT

If _nTotreg == 0
	
	MsgAlert("Atenção: Descrição não existe no cadastro!")
	lRet := .F.
EndIf

DbSelectArea("TM5")
DbCloseArea()

Return( lRet )
