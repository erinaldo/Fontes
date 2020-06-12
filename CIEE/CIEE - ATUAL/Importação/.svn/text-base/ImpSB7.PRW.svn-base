#INCLUDE "rwmake.ch"
#INCLUDE "DelAlias.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImpSB7    º Autor ³ Felipe Raposo      º Data ³  07/10/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Importa o inventario para a tabela SB7.                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE.                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ImpSB7()
// Declaracao das variaveis.
Local _cPath, _cMsg
_cPath := "\TEMP\SLDATU\"  // Caminho no servidor onde ficarao os arquivos DBFs.
_cMsg := "Esse programa ira importar o inventário no " +;
"diretório " + _cPath + " no servidor. Confirma?"
If MsgBox(OemToAnsi(_cMsg), "ATENCAO", "YESNO")
	ProcSB7(_cPath)
Endif
Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Static Function apos a confirmacao do usuario.        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function ProcSB7(_cPath)

// Declaracao das variaveis.
Local _lAbrOK := .T., _cMsg
Private lAbortPrint := .F., lEnd := .F.
Public _aAliases
_aAliases := {}

// Abre os arquivos DBFCDX de consumo.
_lAbrOK := _lAbrOK .and. AbreArqs (_cPath, "SLD01", "Tipo 01", "XX_CODANT")
_lAbrOK := _lAbrOK .and. AbreArqs (_cPath, "SLD02", "Tipo 02", "XX_CODANT")
_lAbrOK := _lAbrOK .and. AbreArqs (_cPath, "SLD03", "Tipo 03", "XX_CODANT")
_lAbrOK := _lAbrOK .and. AbreArqs (_cPath, "SLD04", "Tipo 04", "XX_CODANT")

// Sintaxe dos arquivos.
// XX_CODANT  - num     - Cod. ant. do produto.
// XX_DESCR   - char    - Descricao
// XX_VALOR   - num     - Valor.
// XX_QUANT   - num     - Quantidade.

// Processa os meses.
If _lAbrOK
	msAguarde({|lEnd| !(lAbortPrint) .and. ProcMes("Sld01")}, "Importando Tipo 01...", "Aguarde", .T.)
	msAguarde({|lEnd| !(lAbortPrint) .and. ProcMes("Sld02")}, "Importando Tipo 02...", "Aguarde", .T.)
	msAguarde({|lEnd| !(lAbortPrint) .and. ProcMes("Sld03")}, "Importando Tipo 03...", "Aguarde", .T.)
	msAguarde({|lEnd| !(lAbortPrint) .and. ProcMes("Sld04")}, "Importando Tipo 04...", "Aguarde", .T.)
Else
	_cMsg := "Erro ao abrir os arquivos!!!"
	MsgBox(_cMsg, "ATENCAO", "ALERT")
Endif
// Fecha os alias abertos e apaga os arquivos (DBFs e indices temporarios).
FechaAlias(_aAliases)  // DelAlias.ch
Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre os alias, consistindo os dados.         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function AbreArqs(_cPath, _cArq, _cAlias, _cInd)
// _cPath   - Caminho dos arquivos (DBFs e indices temporarios).
// _cArq    - Arquivo a ser aberto.
// _cAlias  - Alias que ele recebera.
// _cInd    - Indice que sera usado.
// Declaracao das variaveis.
Local _cMsg, _cArqInd, _aAls
// Salva as condicoes atuais.
Local _cAlsAtu := Alias(), _aArea := GetArea()
Local _lRet := .T., _PL

_PL := chr(10) + chr(13) // Salto de linha.
_cPath := AllTrim(_cPath)
_cPath += If (rat("\", _cPath) < len(_cPath), "\", "")
_cArq := _cPath + _cArq + ".DBF"

If File(_cArq)  // Verifica a existencia do arquivo.
	dbUseArea(.T., "DBFCDX", _cArq, _cAlias, .F., .F.)
	// Parametros da funcao dbUseArea
	// 1 - Logico - Abrir nova area.
	// 2 - Char   - "DBFCDX", "TOPCONN"
	// 3 - Char   - Arquivo
	// 4 - Char   - Alias
	// 5 - Logico - Compartilhado
	// 6 - Logico - Apenas leitura.
	// Cria o indice temporario.
	dbSelectArea(_cAlias)
	_cArqInd := _cPath + CriaTrab(nil, .F.)
	IndRegua(_cAlias,_cArqInd,_cInd,,,"Criando indice...", .T.)
	_aAls := {_cAlias, "", _cArqInd + OrdBagExt(), .T.}
	If Type("_aAliases") == "A"  // Verifica a existencia da variavel.
		aAdd (_aAliases, _aAls)
	Endif
Else
	_lRet := .F.
	_cMsg := "O arquivo " + AllTrim(_cArq) + " nao existe." + _PL +;
	"Favor verificar!"
	MsgBox(_cMsg, "ATENCAO", "ALERT")
Endif
// Restaura as condicoes de antes do processamento.
dbSelectArea(_cAlsAtu); RestArea(_aArea)
Return (_lRet)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Static Function que pocessa o alias passado por parametro.       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function ProcMes(_cAlias)
Local _cAlsAtu, _aAreaAtu, _cCpo, _lRet, _lMsg, _cMsg, _PL
Local _dConIni, _cDia, _cMes, _cAno
Local _cCodProd, _nConsMes, _nMes, _nAno

// Armazena as condicoes atuais.
_cAlsAtu  := Alias(); _aAreaAtu := GetArea()
_PL := chr(10) + chr(13) // Salto de linha.
_lRet := !(lAbortPrint)  // Retorno do processamento.
_lMsg := .F. // .T.  // Exibe uma mensagem caso nao encontre o produto.

SB1->(dbSetOrder(8))  // B1_FILIAL + B1_CODANT + B1_COD  --  Customizado CIEE.
SB7->(dbSetOrder(1))  // B7_FILIAL + B7_COD
dbSelectArea(_cAlias); dbGoTop()
Do While !eof() .and. !(lAbortPrint) // Se o usuario cancelou, nao processar.
	
	// Atualiza as variaveis utilizadas no processamento.
	_cCodProd := Transform(MATC)
	_nMes := MesBX; _nAno := AnoBX
	_nConsMes := SOMADEREQQ
	
	// Verifica se o usuario abortou o processamento.
	msProcTxt("Processando produto: " + _cCodProd)
	If lAbortPrint
		_cMsg := "Deseja abortar o processamento no meio?"
		// Se o usuario clicar em cancelar.
		If _lRet .and. !(_lRet := !MsgBox(_cMsg, "Cancelar", "YESNO"))
			_cMsg := "Processamento abortado pelo usuario."
			MsgBox(_cMsg, "ATENCAO", "")
			Exit   // Sai do looping Do While.
		Else
			lAbortPrint := .F.
		Endif
	Endif
	
	// Verifica a existencia do produto no sistema.
	If SB1->(dbSeek(xFilial("SB1") + _cCodProd, .F.))
		If SB7->(dbSeek(xFilial("SB7") + SB1->B1_COD, .F.))
			RecLock("SB7", .F.)
		Else
			RecLock("SB7", .T.)
			SB7->B3_FILIAL := xFilial("SB7")
			SB7->B3_COD    := SB1->B1_COD
		Endif
		_cCpo := "B3_Q" + StrZero(_nMes, 2)
		SB7->(&_cCpo) := _nConsMes
		SB7->(msUnlock())
		
		// Atualiza o campo Consumo Inicial (SB1->B1_CONINI).
		_cDia := "01"
		_cMes := AllTrim(Str(_nMes))
		_cAno := AllTrim(Str(_nAno))
		_dConIni := ctod(_cDia + "/" + _cMes + "/" + _cAno) // - 1
		If _dConIni < SB1->B1_CONINI .or. empty(SB1->B1_CONINI)
			RecLock("SB1", .F.)
			SB1->B1_CONINI := _dConIni  // Data - Data do primeiro consumo.
			SB1->(msUnlock())
		Endif
	Else
		// Continuar a exibir a mensagem caso o usuario assim deseje.
		If _lMsg
			_cMsg :=;
			"O produto " + _cCodProd + " nao foi encontrado no sistema." + _PL +;
			"Deseja continuar exibindo a mensagem a cada erro?"
			_lMsg := MsgBox(_cMsg, "ATENCAO", "YESNO")
		Endif
	Endif
	dbSelectArea(_cAlias); dbSkip()
EndDo

// Restaura as condicoes anteriores.
dbSelectArea(_cAlsAtu); RestArea(_aAreaAtu)
Return _lRet