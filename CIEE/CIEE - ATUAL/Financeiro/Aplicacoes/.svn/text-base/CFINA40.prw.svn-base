#include "rwmake.ch"
#include "Topconn.ch"
#include "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA40   บAutor  ณEmerson Natali      บ Data ณ  13/02/2008 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para Cadastrar as Cotacoes de Aplicacoes Financeirasบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CFINA40()

Private cPrgCanc 	:= ""
Private aRotina 	:= {}
Private aCores	 	:= {}
Private cCadastro 	:= OemToAnsi("Cota็ใo de Aplica็๕es Financeiras")

//aAdd(aRotina, {"Visualizar"		, "u_VALCOT('SZO', Recno(), 2)"	, 0, 2})
aAdd(aRotina, {"Pesquisar" 		, "AxPesqui"					, 0, 1})
aAdd(aRotina, {"Visualizar"		, "u_CFINA40a(2)"				, 0, 2})
aAdd(aRotina, {"Incluir"		, "u_VALCOT('SZO', Recno(), 3)"	, 0, 3})
aAdd(aRotina, {"Alterar"		, "u_VALCOT('SZO', Recno(), 4)"	, 0, 4})
aAdd(aRotina, {"Excluir"		, "u_VALCOT('SZO', Recno(), 5)"	, 0, 5})
aAdd(aRotina, {"Cancelar"		, "u_CANCOT('SZO', Recno(), 4)"	, 0, 6})
aAdd(aRotina, {"Processar"		, "u_CFINA40a(6)"				, 0, 7})
aAdd(aRotina, {"Gera Cotacao"	, "u_CFINA40b()"				, 0, 7})
aAdd(aRotina, {"Demonstrativo"	, "u_CFINA41()"					, 0, 6})
aAdd(aRotina, {"Legenda"   		, "u_LEGCOT()"					, 0, 7})

aCores	:= {	{'ZO_FLAG == "1" .AND. Empty(ZO_PROCESS) .AND. Empty(ZO_CANCELA)', 'BR_AMARELO'	},;
				{'ZO_FLAG == "2" .AND. Empty(ZO_PROCESS) .AND. Empty(ZO_CANCELA)', 'BR_AZUL'	},;
				{'ZO_FLAG == "3" .AND. Empty(ZO_PROCESS) .AND. Empty(ZO_CANCELA)', 'BR_VERDE'	},;
				{'ZO_FLAG == "3" .AND. ZO_PROCESS == "S" .AND. Empty(ZO_CANCELA)', 'BR_LARANJA'	},;
				{'ZO_CANCELA == "S"'											 , 'BR_CANCEL'	},;
				{'ZO_FLAG == " "'    											 , 'BR_BRANCO'	}}

dbSelectArea("SZO")
dbSetOrder(1)
dbGoTop()

mBrowse(6,1,22,74,"SZO",,,,,,aCores)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA40   บAutor  ณEmerson Natali      บ Data ณ  21/08/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function VALCOT(cAlias, nReg, nOpc)

Local cChave := ""
Local nCols  := 0
Local i      := 0
//Local lRet   := .F.

Private lRet   := .F.

// Parametros da funcao Modelo2().
Private cTitulo  := cCadastro
Private aC       := {}                     // Campos do Enchoice.
Private aR       := {}                     // Campos do Rodape.
Private aCGD     := {}                     // Coordenadas do objeto GetDados.
Private cLinOK   := ""
Private cAllOK   := "u_TudOKCot("+alltrim(str(nOpc))+")"
Private aGetsGD  := {}
Private bF4      := {|| }                  // Bloco de Codigo para a tecla F4.
Private aHeader  := {}                     // Cabecalho de cada coluna da GetDados.
Private aCols    := {}                     // Colunas da GetDados.
Private nCount   := 0
Private bCampo   := {|nField| FieldName(nField)}
Private dData    := CtoD("  /  /  ")
Private cNumero  := Space(6)
Private aAlt     := {}

Private cIniCpos := "+ZO_ITEM"         // String com o nome dos campos que devem inicializados ao pressionar
                                       // a seta para baixo. "+Z4_ITEM+Z4_xxx+Z4_yyy"
Private nMax     := 99                 // Nr. maximo de linhas na GetDados.

Private lMsErroAuto := .F.

// Cria variaveis de memoria: para cada campo da tabela, cria uma variavel de memoria com o mesmo nome.
dbSelectArea(cAlias)

For i := 1 To FCount()
	M->&(Eval(bCampo, i)) := CriaVar(FieldName(i), .T.)
	// Assim tambem funciona: M->&(FieldName(i)) := CriaVar(FieldName(i), .T.)
Next
/////////////////////////////////////////////////////////////////////
// Cria vetor aHeader.                                             //
/////////////////////////////////////////////////////////////////////

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(cAlias)

While !SX3->(EOF()) .And. SX3->X3_Arquivo == cAlias
	If X3Uso(SX3->X3_Usado) .And. cNivel >= SX3->X3_Nivel  // O Campo ้ usado.// Nivel do Usuario ้ maior que o Nivel do Campo.
		If nOpc == 3 .or. nOpc == 4 //INCLUIR ou ALTERAR
			If Alltrim(SX3->X3_Campo) == "ZO_RENOVA"
				SX3->(dbSkip())
			EndIf
		EndIf
		AAdd(aHeader, {	Trim(SX3->X3_Titulo),;
		SX3->X3_Campo       ,;
		SX3->X3_Picture     ,;
		SX3->X3_Tamanho     ,;
		SX3->X3_Decimal     ,;
		SX3->X3_Valid       ,;
		SX3->X3_Usado       ,;
		SX3->X3_Tipo        ,;
		SX3->X3_Arquivo     ,;
		SX3->X3_Context})
	EndIf
	SX3->(dbSkip())
End

/////////////////////////////////////////////////////////////////////
// Cria o vetor aCols: contem os dados dos campos da tabela.       //
// Cada linha de aCols ้ uma linha da GetDados e as colunas sao as //
// colunas da GetDados.                                            //
/////////////////////////////////////////////////////////////////////

dbSelectArea(cAlias)
dbSetOrder(1)

If nOpc == 2 .OR. nOpc == 4 .OR. nOpc == 5 //VISUALIZA - ALTERA - EXCLUI
	cNumero		:= (cAlias)->ZO_NUMERO
Else
	cNumero		:= GetSx8Num("SZO","ZO_NUMERO")
EndIf

dbSeek(xFilial(cAlias) + cNumero)

If nOpc == 4 //ALTERA
	If (cAlias)->ZO_FLAG <> " "
		MsgBox(OemToAnsi("Nใo ้ permitido Alterar a Cota็ใo"), "Aviso", "ALERT")
		Return
	EndIf
ElseIf nOpc == 5 //EXCLUI
	If !Empty((cAlias)->ZO_APRV2)
		MsgBox(OemToAnsi("Nใo ้ permitida a Exclusใo da cota็ใo "+cNumero+". Cota็ใo jแ esta aprovada pelo Superior"), "Aviso", "ALERT")
		Return
	EndIf
EndIf

While !EOF() .And. (cAlias)->(ZO_FILIAL+ZO_NUMERO) == xFilial(cAlias)+cNumero
	
	AAdd(aCols, Array(Len(aHeader)+1))   // Cria uma linha vazia em aCols.
	nCols++
	
	// Preenche a linha que foi criada com os dados contidos na tabela.
	For i := 1 To Len(aHeader)
		If aHeader[i][10] <> "V"    // Campo nao ้ virtual.
			aCols[nCols][i] := FieldGet(FieldPos(aHeader[i][2]))   // Carrega o conteudo do campo.
		Else
			// A funcao CriaVar() le as definicoes do campo no dic.dados e carrega a variavel de acordo com
			// o Inicializador-Padrao, que, se nao foi definido, assume conteudo vazio.
			aCols[nCols][i] := CriaVar(aHeader[i][2], .T.)
			dbSelectArea(cAlias)
		EndIf
	Next
	
	// Cria a ultima coluna para o controle da GetDados: deletado ou nao.
	aCols[nCols][Len(aHeader)+1] := .F.

   // Atribui 01 para a primeira linha da GetDados.
   aCols[1][AScan(aHeader,{|x| Trim(x[2])=="ZO_ITEM"})] := "01"
	
	// Atribui o numero do registro neste vetor para o controle na gravacao.
	AAdd(aAlt, Recno())
	dbSelectArea(cAlias)
	dbSkip()
End

// aC[n][1] = Nome da variavel. Ex.: "cCliente"
// aC[n][2] = Array com as coordenadas do Get [x,y], em Pixel.
// aC[n][3] = Titulo do campo
// aC[n][4] = Picture
// aC[n][5] = Validacao
// aC[n][6] = F3
// aC[n][7] = Se o campo ้ editavel, .T., senao .F.

AAdd(aC, {"cNumero"		, {15,010}, "N๚mero				", "@!"     	, , , .F.})

// Coordenadas do objeto GetDados.
aCGD 	:= {050,5,128,315}

// Executa a funcao Modelo2().
lRet := Modelo2(cTitulo, aC, aR, aCGD, nOpc,       , cAllOK, , , cIniCpos, nMax)

If lRet  // Confirmou.
	
	If      nOpc == 3  // Inclusao
		If MsgYesNo("Confirma a gravacao dos dados?", cTitulo)
			// Cria um dialogo com uma regua de progressao.
			Processa({||Md2Inclu(cAlias)}, cTitulo, "Gravando os dados, aguarde...")
			U_CWKF004(cNumero) //Executa envio do WorkFlow
		EndIf
	ElseIf nOpc == 4  // Alteracao
		If MsgYesNo("Confirma a alteracao dos dados?", cTitulo)
			// Cria um dialogo com uma regua de progressao.
			Processa({||Md2Alter(cAlias)}, cTitulo, OemToAnsi("Alterando os dados da Cota็ใo, aguarde..."))
//			If cPrgCanc == "U_CANCOT" //Este IF foi retirado pois so sera permitido alteracao de Cotacao que vierem  do processo de Demonstrativo, entao ao alterar manda e-mail
				U_CWKF004(cNumero) //Executa envio do WorkFlow
//			EndIf
		EndIf
	ElseIf nOpc == 5  // Exclusao
		If MsgYesNo("Confirma a exclusao dos dados?", cTitulo)
			// Cria um dialogo com uma regua de progressao.
			Processa({||Md2Exclu(cAlias)}, cTitulo, "Excluindo os dados, aguarde...")
		EndIf
	EndIf
	
Else
	
EndIf

RollBackSX8()

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA40   บAutor  ณMicrosiga           บ Data ณ  02/13/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Md2Inclu(cAlias)

Local i := 0
Local y := 0

ProcRegua(Len(aCols))

dbSelectArea(cAlias)
dbSetOrder(1)

For i := 1 To Len(aCols)
	
	IncProc()
	
	If !aCols[i][Len(aHeader)+1]  // A linha nao esta deletada, logo, deve ser gravada.
		
		RecLock(cAlias, .T.)
		
		For y := 1 To Len(aHeader)
			FieldPut(FieldPos(Trim(aHeader[y][2])), aCols[i][y])
		Next
		
		(cAlias)->ZO_Filial  := xFilial(cAlias)
		(cAlias)->ZO_Numero  := cNumero
		(cAlias)->ZO_RENOVA  := "N"
		(cAlias)->ZO_VLORI   := (cAlias)->ZO_VLAPL
		
		MSUnlock()
		
	EndIf
	
Next

ConfirmSX8()

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA40   บAutor  ณEmerson Natali      บ Data ณ  21/08/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Md2Alter(cAlias)

Local i := 0
Local y := 0

ProcRegua(Len(aCols))

dbSelectArea(cAlias)
dbSetOrder(1)

For i := 1 To Len(aCols)
	
	If i <= Len(aAlt)
		
		// aAlt contem os Recno() dos registros originais.
		// O usuario pode ter incluido mais registros na GetDados (aCols).
		
		dbGoTo(aAlt[i])                 // Posiciona no registro.
		RecLock(cAlias, .F.)
		If aCols[i][Len(aHeader)+1]     // A linha esta deletada.
			dbDelete()                   // Deleta o registro correspondente.
		Else
			// Regrava os dados.
			For y := 1 To Len(aHeader)
				FieldPut(FieldPos(Trim(aHeader[y][2])), aCols[i][y])
			Next
		EndIf
		MSUnlock()
	Else     // Foram incluidas mais linhas na GetDados (aCols), logo, precisam ser incluidas.
		
		If !aCols[i][Len(aHeader)+1]
			RecLock(cAlias, .T.)
			For y := 1 To Len(aHeader)
				FieldPut(FieldPos(Trim(aHeader[y][2])), aCols[i][y])
			Next
			(cAlias)->ZO_Filial := xFilial(cAlias)
			(cAlias)->ZO_Numero := cNumero
			(cAlias)->ZO_RENOVA := "N"
			(cAlias)->ZO_VLORI  := (cAlias)->ZO_VLAPL
			MSUnlock()
		EndIf
	EndIf
	
Next i

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA40   บAutor  ณMicrosiga           บ Data ณ  02/13/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Md2Exclu(cAlias)

ProcRegua(Len(aCols))

dbSelectArea(cAlias)
dbSetOrder(1)
dbSeek(xFilial(cAlias) + cNumero)

While !EOF() .And. (cAlias)->ZO_Filial == xFilial(cAlias) .And. (cAlias)->ZO_Numero == cNumero
	IncProc()
	If Empty((cAlias)->ZO_APRV2)
		RecLock(cAlias, .F.)
		dbDelete()
		MSUnlock()
	Else
		MsgBox(OemToAnsi("Nใo ้ permitida a Exclusใo da cota็ใo "+cNumero+". Cota็ใo jแ esta aprovada pelo Superior"), "Aviso", "ALERT")
		Exit
	EndIf
	dbSkip()
End

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA40   บAutor  ณMicrosiga           บ Data ณ  08/22/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TudOKCot(nOpc)

Local lRet1 := .T.
Local i     := 0

/*
For i := 1 To Len(aCols)
Next
*/

Return lRet1

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA40   บAutor  ณEmerson Natali      บ Data ณ  21/08/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function LEGCOT()

_aLeg := {	{"BR_BRANCO"   	, OemToAnsi("Cota็ใo em Aberto")	},;
			{"BR_AMARELO"  	, OemToAnsi("Enviado para Anแlise")	},;
			{"BR_AZUL"    	, "Liberado pelo Supervisor"		},;
			{"BR_VERDE"    	, "Liberado pelo Superintendente"	},;
			{"BR_LARANJA" 	, OemToAnsi("Aplica็ใo Processada")	},;
			{"BR_CANCEL"   	, OemToAnsi("Cota็ใo Cancelada")	}}

BrwLegenda(cCadastro, "Legenda", _aLeg)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA40   บAutor  ณEmerson Natali      บ Data ณ  21/08/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cancela Cotacao                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CANCOT(cAlias, nReg, nOpc)

Local nCols  := 0

Private cPrgCanc 	:= Procname()

Private aHeader  := {}                     // Cabecalho de cada coluna da GetDados.
Private aCols    := {}                     // Colunas da GetDados.
Private cNumero  := Space(6)
Private aAlt     := {}

/////////////////////////////////////////////////////////////////////
// Cria vetor aHeader.                                             //
/////////////////////////////////////////////////////////////////////

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(cAlias)

While !SX3->(EOF()) .And. SX3->X3_Arquivo == cAlias
	If X3Uso(SX3->X3_Usado) .And. cNivel >= SX3->X3_Nivel  // O Campo ้ usado.// Nivel do Usuario ้ maior que o Nivel do Campo.
		AAdd(aHeader, {	Trim(SX3->X3_Titulo),;
		SX3->X3_Campo       ,;
		SX3->X3_Picture     ,;
		SX3->X3_Tamanho     ,;
		SX3->X3_Decimal     ,;
		SX3->X3_Valid       ,;
		SX3->X3_Usado       ,;
		SX3->X3_Tipo        ,;
		SX3->X3_Arquivo     ,;
		SX3->X3_Context})
	EndIf
	SX3->(dbSkip())
End

/////////////////////////////////////////////////////////////////////
// Cria o vetor aCols: contem os dados dos campos da tabela.       //
// Cada linha de aCols ้ uma linha da GetDados e as colunas sao as //
// colunas da GetDados.                                            //
/////////////////////////////////////////////////////////////////////

dbSelectArea(cAlias)
dbSetOrder(1)
cNumero := (cAlias)->ZO_NUMERO
dbSeek(xFilial(cAlias) + cNumero)

If !(ZO_FLAG == "3" .and. Empty(ZO_PROCESS) .and. Empty(ZO_CANCELA))
	MsgBox(OemToAnsi("Cota็ใo nใo pode ser cancelada!"), "Aviso", "ALERT")
	Return
EndIf

If !MsgYesNo(OemToAnsi("Deseja realmente Cancelar a Cota็ใo?"), OemToAnsi("Cota็ใo de Aplica็๕es Financeiras"))
	Return
EndIf

While !EOF() .And. (cAlias)->(ZO_FILIAL+ZO_NUMERO) == xFilial(cAlias)+cNumero
	
	AAdd(aCols, Array(Len(aHeader)+1))   // Cria uma linha vazia em aCols.
	nCols++
	
	// Preenche a linha que foi criada com os dados contidos na tabela.
	For i := 1 To Len(aHeader)
		If aHeader[i][10] <> "V"    // Campo nao ้ virtual.
			aCols[nCols][i] := FieldGet(FieldPos(aHeader[i][2]))   // Carrega o conteudo do campo.
		Else
			// A funcao CriaVar() le as definicoes do campo no dic.dados e carrega a variavel de acordo com
			// o Inicializador-Padrao, que, se nao foi definido, assume conteudo vazio.
			aCols[nCols][i] := CriaVar(aHeader[i][2], .T.)
			dbSelectArea(cAlias)
		EndIf
	Next
	
	// Cria a ultima coluna para o controle da GetDados: deletado ou nao.
	aCols[nCols][Len(aHeader)+1] := .F.
	
	// Atribui o numero do registro neste vetor para o controle na gravacao.
	AAdd(aAlt, Recno())

	RecLock(cAlias,.F.)
	(cAlias)->ZO_CANCELA := "S"
	(cAlias)->ZO_RENOVA := "N"
	MsUnLock()

	dbSelectArea(cAlias)
	dbSkip()
End

cNumero		:= GetSx8Num("SZO","ZO_NUMERO")

If MsgYesNo(OemToAnsi("Deseja criar Nova Cota็ใo?"), OemToAnsi("Cota็ใo de Aplica็๕es Financeiras"))
	Processa({||Md2Inclu(cAlias)}, OemToAnsi("Nova Cota็ใo de Aplica็๕es Financeiras"), "Gravando os dados, aguarde...")
	u_VALCOT('SZO', Recno(), 4) //Tela de Alteracao
EndIf

Return