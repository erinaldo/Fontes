#INCLUDE "rwmake.ch"
#include "_FixSX.ch" // "AddSX1.ch"
#INCLUDE "DelAlias.ch"
#Include "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINA18   º Autor ³ Andy               º Data ³  09/09/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cadastro de Configuracao de Fechamento - FIBA              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CFINA18

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cArq,cInd,cPerg
Local cString := "SZD"
Local aStru
Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.


dbSelectArea("SZD")
dbSetOrder(1)
//AxCadastro(cString, "FIBA - Configuracao Fechamento", cVldAlt, cVldExc)
cCadastro := "FIBA - Configuracao Fechamento"
aRotina   := { 	{"Pesquisar"  ,"AxPesqui"    , 0 , 1},;
{"Visualizar"  ,"AxVisual"    , 0 , 2},;
{"Incluir"     ,"AxInclui"    , 0 , 3},;
{"Alterar"     ,"AxAltera"    , 0 , 4},;
{"Excluir"     ,"AxDeleta"    , 0 , 5},;
{"Imprimir"    ,"U_IMPCONFIG" , 0 , 6}}
dbSelectArea("SZD")
dbSetOrder(1)

mBrowse( 6,1,22,75,"SZD",,,,,2)

Return


User Function IMPCONFIG()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cDesc1 := "Este programa tem como objetivo imprimir a configuracao"
Private cDesc2 := "do relatorio FIBA"
Private cDesc3 := "de acordo com os registros lancados na tabela SZD."

Private titulo := "*** F I B A ***"
Private nLin   := 60

Private Cabec1 := ""
Private Cabec2 := ""
Private imprime      := .T.
Private aOrd         := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := StrTran(FunName(), "#", "")
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FINA18" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString      := "SZD"
Private cPerg        := "FINA18    "
Private mvFicha

_fCriaSX1()

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

dbSelectArea("SZD")
DbSetOrder(1)

Pergunte(cPerg, .F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus({|| IMPFiba(Cabec1,Cabec2,Titulo,nLin) },Titulo)


SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
EndIf

MS_FLUSH()


Return

Static Function IMPFIBA()

_aAliases := {}
_aEstrut  := {}

// Define a estrutura do arquivo de trabalho.
_aEstrut := {;
{"ZD_PAGINA"   ,  "C",  02, 0},;
{"ZD_LINHA"    ,  "C",  02, 0},;
{"ZD_COLUNA"   ,  "C",  02, 0},;
{"ZD_DESC"     ,  "C",  50, 0},;
{"ZD_TIPO"     ,  "C",  01, 0},;
{"ZD_NATUREZ"  ,  "C", 200, 0} }

// Cria o arquivo de trabalho.
_cArqTrab := CriaTrab(_aEstrut, .T.)
dbUseArea(.T., "DBFCDX", _cArqTrab, "TMP", .F., .F.)
// Cria o indice para o arquivo.
IndRegua("TMP", _cArqTrab, "ZD_PAGINA+ZD_LINHA+ZD_COLUNA",,, "Criando indice...", .T.)
aAdd (_aAliases, {"TMP", _cArqTrab + ".DBF", _cArqTrab + OrdBagExt(), .T.})

dbSelectArea("SZD")
dbSetOrder(1)
dbGoTop()
Do While xFilial("SZD")==SZD->ZD_FILIAL .And. !Eof()
	If SZD->ZD_MODELO == str(mv_par01,1) 	//Modelo A igual a 1; Modelos B igual a 2; Ambos igual a 3	dbSelectArea("TMP")
		dbSelectArea("TMP")
		RecLock("TMP", .T.)
		TMP->ZD_PAGINA := SZD->ZD_PAGINA
		TMP->ZD_LINHA  := SZD->ZD_LINHA
		TMP->ZD_COLUNA := SZD->ZD_COLUNA
		TMP->ZD_DESC   := SZD->ZD_DESC
		TMP->ZD_TIPO   := SZD->ZD_TIPO
		msUnLock()
	Else
		If SZD->ZD_MODELO == "3" //Ambos
			dbSelectArea("TMP")
			RecLock("TMP", .T.)
			TMP->ZD_PAGINA := SZD->ZD_PAGINA
			TMP->ZD_LINHA  := SZD->ZD_LINHA
			TMP->ZD_COLUNA := SZD->ZD_COLUNA
			TMP->ZD_DESC   := SZD->ZD_DESC
			TMP->ZD_TIPO   := SZD->ZD_TIPO
			msUnLock()
		EndIf
	EndIf
	dbSelectArea("SZD")
	dbSkip()
EndDo

dbSelectArea("TMP")
dbSetOrder(1)
dbGoTop()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprimindo Configuração                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Cabec1:="Configuracao com Coordenadas"

While !EOF()
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	_cPag := TMP->ZD_PAGINA
	
	While !EOF() .And. _cPag == TMP->ZD_PAGINA
		If TMP->ZD_TIPO=="O"
			dbSkip()
			Loop
		EndIf
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		@ Val(TMP->ZD_LINHA), Val(TMP->ZD_COLUNA)    PSay LEFT(TMP->ZD_DESC,35)
		@ Val(TMP->ZD_LINHA), Val(TMP->ZD_COLUNA)+37 PSay TMP->ZD_PAGINA+TMP->ZD_LINHA+TMP->ZD_COLUNA+" - "+TMP->ZD_TIPO
		dbSelectArea("TMP")
		dbSkip()
	EndDo
	
	nLin := 60
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Preparando Naturezas                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SED")
dbSetOrder(1)
dbGoTop()
While !EOF()
	
	If !Empty(SED->ED_FECHA)
		
		dbSelectArea("TMP")
		dbsetOrder(1)
		_nPos:=1
		While .T.
			
			If mv_par01 == 1
				_cChave:=SubStr(SED->ED_FECHA,_nPos,6)
			Else
				_cChave:=SubStr(SED->ED_FECHA_B,_nPos,6)
			EndIf
			If _cChave == space(6) .Or. Val(_cChave)==0
				Exit
			Else
				If dbSeek(_cChave, .F.)
					RecLock("TMP", .F.)
					TMP->ZD_NATUREZ := AllTrim(TMP->ZD_NATUREZ)+AllTrim(SED->ED_CODIGO)+";"
					msUnLock()
				EndIf
			EndIf
			
			_nPos := _nPos+7
			
		EndDo
	EndIf
	
	dbSelectArea("SED")
	dbSkip()
	
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprimindo Naturezas                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("TMP")
dbSetOrder(1)
dbGoTop()

Cabec1:="Configuracao com Natureza"


While !EOF()
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	If !Empty(TMP->ZD_NATUREZ)
		dbSelectArea("SED")
		dbsetOrder(1)
		_nPos := 1
		_lPri := .T.
		While .T.
			_cChave:=SubStr(TMP->ZD_NATUREZ,_nPos,7)
			If _cChave == space(7) .Or. Val(_cChave)==0
				Exit
			Else
				If dbSeek(xFilial("SED")+_cChave, .F.)
					If _lPri
						@ nLin, 01 PSay TMP->ZD_DESC
						@ nLin, 55 PSay TMP->ZD_PAGINA+TMP->ZD_LINHA+TMP->ZD_COLUNA+" - "+TMP->ZD_TIPO
						_lPri := .F.
						nLin  := nLin + 2
					EndIf
					@ nLin, 01 PSay SED->ED_CODIGO +" - "+SED->ED_DESCRIC
					nLin := nLin + 1
				EndIf
			EndIf
			_nPos := _nPos + 8
		EndDo
		
		nLin:=nLin+2
	EndIf
	
	dbSelectArea("TMP")
	dbSkip()
EndDo
FechaAlias(_aAliases)  // DelAlias.ch

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SX1       ºAutor  ³Microsiga           º Data ³  08/03/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Parametros da rotina                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _fCriaSX1()

aRegs     := {}
nSX1Order := SX1->(IndexOrd())

SX1->(dbSetOrder(1))

cPerg := Left(cPerg,10)

/*
             grupo ,ordem ,pergunt             ,perg spa,perg eng , variav ,tipo,tam,dec,pres,gsc,valid,var01     ,def01                 ,defspa01,defeng01,cnt01,var02,def02           ,defspa02,defeng02,cnt02,var03,def03      ,defspa03,defeng03,cnt03,var04,def04           ,defspa04,defeng04,cnt04,var05,def05  ,defspa05,defeng05,cnt05,f3   ,"","","",""
*/

AADD(aRegs,{cPerg  ,"01" ,"Modelo Relatorio ?",""      ,""       ,"mv_ch1","N" ,01 ,00 ,0  ,"C",""   ,"mv_PAR01","A"                   ,""      ,""      ,""   ,""   ,"B"            ,""      ,""      ,""   ,""   ,""         ,""      ,""     ,""   ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,""   ,"","","",""})

For nX := 1 to Len(aRegs)
	If !SX1->(dbSeek(cPerg+aRegs[nX,2]))
		RecLock('SX1',.T.)
		For nY:=1 to FCount()
			If nY <= Len(aRegs[nX])
				SX1->(FieldPut(nY,aRegs[nX,nY]))
			Endif
		Next nY
		MsUnlock()
	Endif
Next nX

SX1->(dbSetOrder(nSX1Order))

Return