#include "rwmake.ch"
#include "Topconn.ch"
#include "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA52a  บAutor  ณEmerson Natali      บ Data ณ  13/08/2008 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para Acerto dos registros Importados p/ o Fluxo de  บฑฑ
ฑฑบ          ณ Caixa                                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CFINA52a(nOpc)

Local cChave := ""
Local nCols  := 0
Local i      := 0

Private lRet     := .F.
// Parametros da funcao Modelo2().
Private cAlias    := "SZZ"
//Private nOpc      := 3 //Incluir
Private _lAlterar := .F.

Private cTitulo  := OemToAnsi("Acerto movimento Fluxo de Caixa importado")
Private aC       := {}                     // Campos do Enchoice.
Private aR       := {}                     // Campos do Rodape.
Private aCGD     := {}                     // Coordenadas do objeto GetDados.
Private cLinOK   := "u_LinOKFlx()"
Private cAllOK   := "u_TudOKFlx()"
Private aHeader  := {}                     // Cabecalho de cada coluna da GetDados.
Private aCols    := {}                     // Colunas da GetDados.
Private bCampo   := {|nField| FieldName(nField)}
Private aAlt     := {}
Private cIniCpos := "ZZ_DATA"          // String com o nome dos campos que devem inicializados ao pressionar
                                       // a seta para baixo. "+Z4_ITEM+Z4_xxx+Z4_yyy"
Private nMax     := 99                 // Nr. maximo de linhas na GetDados.
Private cNumero  := Space(6)
Private cNatureza
Private cDesNatur
Private cHist
Private cDocument
Private cCtaCorre
Private dData
Private nValor
Private _aArea := GetArea()

// Cria variaveis de memoria: para cada campo da tabela, cria uma variavel de memoria com o mesmo nome.
dbSelectArea(cAlias)

If nOpc == 3 // Inclusao/Alteracao/Exclusa
	If (cAlias)->ZZ_FLAG <> "IMP"
		msgbox("Somente Registros tipo Importa็ใo podem ser Ajustados!!!","Aten็ใo")
		Return
	EndIf
EndIf

_cDtAju := STOD(GETMV("CI_DTAJUS"))

//If !(_cDtAju <= mv_par01 .and. mv_par02 >= _cDtAju)
If !(_cDtAju <= ZZ_DATA) .and. nOpc == 3
	Msgbox("Foi realizado ajuste no dia "+Dtoc(_cDtAju)+" e por isso nao podemos ajustas os movimentos anteriores!!!", "Aten็ใo")
	Return
EndIf


For i := 1 To FCount()
	M->&(Eval(bCampo, i)) := CriaVar(FieldName(i), .T.)
Next
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

If nOpc == 2 //Visualizar

	If !Empty((cAlias)->ZZ_NUMERO)
		dbSelectArea(cAlias)
		dbSetOrder(3) //FILIAL + NUMERO
		dbSeek(xFilial(cAlias)+(cAlias)->ZZ_NUMERO)
	EndIf
EndIf

cNumero			:= (cAlias)->ZZ_NUMERO
cNatureza		:= (cAlias)->ZZ_NATUREZ
cDesNatur		:= (cAlias)->ZZ_DESCNAT
cHist    		:= (cAlias)->ZZ_HIST
cDocument		:= (cAlias)->ZZ_DOCUMEN
cCtaCorre		:= (cAlias)->ZZ_CONTA
dData    		:= (cAlias)->ZZ_DATA
nValor   		:= (cAlias)->ZZ_VALOR

dbSelectArea(cAlias)
dbSetOrder(3) //FILIAL + NUMERO
If !Empty(cNumero)
	_lAlterar	:= .T.
	If dbSeek(xFilial(cAlias)+cNumero)
		Do While !EOF() .and. (cAlias)->(ZZ_FILIAL+ZZ_NUMERO) == xFilial(cAlias)+cNumero
			If (cAlias)->ZZ_FLAG == "IMP"
				dbSelectArea(cAlias)
				dbSkip()
				Loop
			EndIf
			AAdd(aCols, Array(Len(aHeader)+1))   // Cria uma linha vazia em aCols.
			nCols++

			// Preenche a linha que foi criada com os dados contidos na tabela.
			For i := 1 To Len(aHeader)
				aCols[nCols][i] := FieldGet(FieldPos(aHeader[i][2]))   // Carrega o conteudo do campo.
			Next

			AAdd(aAlt, Recno())
			dbSelectArea(cAlias)
			dbSkip()
		EndDo
	Else
		Return .T.	
	EndIf
Else
	cNumero	:= GetSx8Num("SZZ","ZZ_NUMERO")
	
	AAdd(aCols, Array(Len(aHeader)+1))   // Cria uma linha vazia em aCols.
	nCols++

	// Preenche a linha que foi criada com os dados contidos na tabela.
	For i := 1 To Len(aHeader)
		// A funcao CriaVar() le as definicoes do campo no dic.dados e carrega a variavel de acordo com
		// o Inicializador-Padrao, que, se nao foi definido, assume conteudo vazio.
		aCols[nCols][i] := CriaVar(aHeader[i][2], .T.)
		dbSelectArea(cAlias)
	Next

	// Inicializa a Data igual ao registro original
	aCols[nCols][3]		:= cHist
	aCols[nCols][4]		:= cDocument
	aCols[nCols][5]		:= cCtaCorre
	aCols[nCols][6]		:= dData
	aCols[nCols][7]		:= nValor

EndIf
	
	
For i := 1 to nCols
	// Cria a ultima coluna para o controle da GetDados: deletado ou nao.
	aCols[i][Len(aHeader)+1] := .F.
Next

// aC[n][1] = Nome da variavel. Ex.: "cCliente"
// aC[n][2] = Array com as coordenadas do Get [x,y], em Pixel.
// aC[n][3] = Titulo do campo
// aC[n][4] = Picture
// aC[n][5] = Validacao
// aC[n][6] = F3
// aC[n][7] = Se o campo ้ editavel, .T., senao .F.

//AAdd(aC, {"cNumero"		, {15,300}, "Numero Acerto     ", "@!"  			, , , .F.})

AAdd(aC, {"cNatureza"	, {15,010}, "Natureza			", "@!"  				, , , .F.})
AAdd(aC, {"cDesNatur"	, {30,010}, "Desc Natureza		", "@!"   				, , , .F.})
AAdd(aC, {"cHist"		, {45,010}, "Historico			", "@!"  				, , , .F.})
AAdd(aC, {"cDocument"	, {60,010}, "Documento			", "@!"   				, , , .F.})
AAdd(aC, {"dData"		, {75,010}, "Data				", ""  					, , , .F.})
AAdd(aC, {"cCtaCorre"	, {60,160}, "Cta Corrente		", "@!"    				, , , .F.})
AAdd(aC, {"nValor"		, {75,160}, "Valor				", "@E 999,999,999.99"	, , , .F.})

// Coordenadas do objeto GetDados.
aCGD 	:= {150,5,128,3150}

// Executa a funcao Modelo2().
lRet := Modelo2(cTitulo, aC, aR, aCGD, nOpc, cLinOK, cAllOK, , , cIniCpos, nMax)

If lRet  // Confirmou.
	If MsgYesNo("Confirma a gravacao dos dados?", cTitulo)
		_fConfirma()
	Else
		lRet := Modelo2(cTitulo, aC, aR, aCGD, nOpc, cLinOK, cAllOK, , , cIniCpos, nMax)
		If lRet
			If MsgYesNo("Confirma a gravacao dos dados?", cTitulo)
				_fConfirma()
			Else
				RollBackSX8()	
			EndIf
		Else
			RollBackSX8()
		EndIf
	EndIf
Else
	RollBackSX8()	
EndIf

RestArea(_aArea)

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA52A  บAutor  ณMicrosiga           บ Data ณ  08/18/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _fConfirma()

If _lAlterar
	Processa({||Md2Alter(cAlias, cNumero)}, cTitulo, OemToAnsi("Alterando os dados da Cota็ใo, aguarde..."))		
Else
	RecLock("SZZ", .F.)
	(cAlias)->ZZ_NUMERO := cNumero
	(cAlias)->ZZ_DEL    := "DEL"
	MsUnLock()

	Processa({||Md2Inclu(cAlias, cNumero)}, cTitulo, "Gravando os dados, aguarde...")
	ConfirmSX8()

	DbSelectArea("SX6")
	DbSetOrder(1)
	If DbSeek(xFilial("SX6")+"CI_DTAJUS") //Se houve ajuste grava a data para nao permitir mais importacao
		RecLock("SX6",.F.)
		SX6->X6_CONTEUD	:= DtoS((cAlias)->ZZ_DATA)
		MsUnLock()
	EndIf

EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA52A  บAutor  ณMicrosiga           บ Data ณ  02/13/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Md2Inclu(cAlias, cNumero)

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
		
		(cAlias)->ZZ_Filial  := xFilial(cAlias)
		(cAlias)->ZZ_NUMERO  := cNumero
		(cAlias)->ZZ_FLAG    := "AJT"
	
		MSUnlock()
		
	EndIf
	
Next

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA52A  บAutor  ณEmerson Natali      บ Data ณ  21/08/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Md2Alter(cAlias, cNumero)

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
			(cAlias)->ZZ_Filial := xFilial(cAlias)
			(cAlias)->ZZ_Numero := cNumero
			(cAlias)->ZZ_FLAG   := "AJT"
			MSUnlock()
		EndIf
	EndIf
	
Next i

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA52A  บAutor  ณMicrosiga           บ Data ณ  08/22/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TudOKFlx()

Local lRet1  := .T.
Local i      := 0
Local nTotal := 0

For i := 1 To Len(aCols)
	If !aCols[i][Len(aHeader)+1]
		nTotal+= aCols[i,7]
	EndIf
	If aCols[i,6] <> dData
		MsgBox("Data do movimento nใo pode ser diferente do Original!!!", "Aten็ใo")
		lRet1 := .F.
		Return(lRet1)
	EndIf
Next

If nTotal > nvalor
	MsgBox("O Valor lan็ado para os Ajustes estแ maior que o original!!!", "Aten็ใo")
	lRet1 := .F.
ElseIf nTotal < nvalor
	MsgBox("O Valor lan็ado para os Ajustes nใo pode ser menor que o original!!!", "Aten็ใo")
	lRet1 := .F.
EndIf

Return(lRet1)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA52A  บAutor  ณMicrosiga           บ Data ณ  08/13/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function LinOKFlx()

Local lRet1 := .T.
Local i     := 0
Local nTotal := 0

For i := 1 To Len(aCols)
	If !aCols[i][Len(aHeader)+1]
		nTotal+= aCols[i,7]
	EndIf
	If aCols[i,6] <> dData
		MsgBox("Data do movimento nใo pode ser diferente do Original!!!", "Aten็ใo")
		lRet1 := .F.
		Return(lRet1)
	EndIf
Next

If nTotal > nvalor
	MsgBox("O Valor lan็ado para os Ajustes estแ maior que o original!!!", "Aten็ใo")
	lRet1 := .F.
EndIf

Return(lRet1)