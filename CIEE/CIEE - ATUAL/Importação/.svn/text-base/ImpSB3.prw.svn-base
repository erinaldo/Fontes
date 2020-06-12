#INCLUDE "rwmake.ch"
#INCLUDE "DelAlias.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImpSB3    º Autor ³ Felipe Raposo      º Data ³  29/05/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Importa os arquivos de consumo para a tabela SB3.          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE.                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ImpSB3()
// Declaracao das variaveis.
Local _cPath, _cMsg
_cPath := "\TEMP\CONMES\"  // Caminho no servidor onde ficarao os arquivos DBFs.
_cMsg := "Esse programa ira importar os arquivos de consumo no " +;
"diretorio " + _cPath + " no servidor. Confirma?"
If MsgBox(_cMsg, "ATENCAO", "YESNO")
	ProcSB3(_cPath)
Endif
Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Static Function apos a confirmacao do usuario.        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function ProcSB3(_cPath)

// Declaracao das variaveis.
Local _lAbrOK := .T., _cMsg
Private lAbortPrint := .F., lEnd := .F.
Public _aAliases
_aAliases := {}

// Abre os arquivos DBFCDX de consumo.
_lAbrOK := _lAbrOK .and. AbreArqs (_cPath, "CONMES01", "MES01", "MATCOD")
_lAbrOK := _lAbrOK .and. AbreArqs (_cPath, "CONMES02", "MES02", "MATCOD")
_lAbrOK := _lAbrOK .and. AbreArqs (_cPath, "CONMES03", "MES03", "MATCOD")
_lAbrOK := _lAbrOK .and. AbreArqs (_cPath, "CONMES04", "MES04", "MATCOD")
_lAbrOK := _lAbrOK .and. AbreArqs (_cPath, "CONMES05", "MES05", "MATCOD")
_lAbrOK := _lAbrOK .and. AbreArqs (_cPath, "CONMES06", "MES06", "MATCOD")
_lAbrOK := _lAbrOK .and. AbreArqs (_cPath, "CONMES07", "MES07", "MATCOD")
_lAbrOK := _lAbrOK .and. AbreArqs (_cPath, "CONMES08", "MES08", "MATCOD")
_lAbrOK := _lAbrOK .and. AbreArqs (_cPath, "CONMES09", "MES09", "MATCOD")
_lAbrOK := _lAbrOK .and. AbreArqs (_cPath, "CONMES10", "MES10", "MATCOD")
_lAbrOK := _lAbrOK .and. AbreArqs (_cPath, "CONMES11", "MES11", "MATCOD")
_lAbrOK := _lAbrOK .and. AbreArqs (_cPath, "CONMES12", "MES12", "MATCOD")
// Sintaxe dos arquivos.
// MATCOD     - char(09) - Cod. ant. do produto.
// SOMADEREQQ - num(09)  - Consumo no mes.
// AnoBX      - num(09)  - Ano do consumo.
// MesBX      - num(09)  - Mes do consumo.

// Processa os meses.
If _lAbrOK
	msAguarde({|lEnd| !(lAbortPrint) .and. ProcMes("MES01")}, "Importando MES01...", "Aguarde", .T.)
	msAguarde({|lEnd| !(lAbortPrint) .and. ProcMes("MES02")}, "Importando MES02...", "Aguarde", .T.)
	msAguarde({|lEnd| !(lAbortPrint) .and. ProcMes("MES03")}, "Importando MES03...", "Aguarde", .T.)
	msAguarde({|lEnd| !(lAbortPrint) .and. ProcMes("MES04")}, "Importando MES04...", "Aguarde", .T.)
	msAguarde({|lEnd| !(lAbortPrint) .and. ProcMes("MES05")}, "Importando MES05...", "Aguarde", .T.)
	msAguarde({|lEnd| !(lAbortPrint) .and. ProcMes("MES06")}, "Importando MES06...", "Aguarde", .T.)
	msAguarde({|lEnd| !(lAbortPrint) .and. ProcMes("MES07")}, "Importando MES07...", "Aguarde", .T.)
	msAguarde({|lEnd| !(lAbortPrint) .and. ProcMes("MES08")}, "Importando MES08...", "Aguarde", .T.)
	msAguarde({|lEnd| !(lAbortPrint) .and. ProcMes("MES09")}, "Importando MES09...", "Aguarde", .T.)
	msAguarde({|lEnd| !(lAbortPrint) .and. ProcMes("MES10")}, "Importando MES10...", "Aguarde", .T.)
	msAguarde({|lEnd| !(lAbortPrint) .and. ProcMes("MES11")}, "Importando MES11...", "Aguarde", .T.)
	msAguarde({|lEnd| !(lAbortPrint) .and. ProcMes("MES12")}, "Importando MES12...", "Aguarde", .T.)
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
SB3->(dbSetOrder(1))  // B3_FILIAL + B3_COD
dbSelectArea(_cAlias); dbGoTop()
Do While !eof() .and. !(lAbortPrint) // Se o usuario cancelou, nao processar.
	
	// Atualiza as variaveis utilizadas no processamento.
	_cCodProd := AllTrim(MATCOD)
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
		If SB3->(dbSeek(xFilial("SB3") + SB1->B1_COD, .F.))
			RecLock("SB3", .F.)
		Else
			RecLock("SB3", .T.)
			SB3->B3_FILIAL := xFilial("SB3")
			SB3->B3_COD    := SB1->B1_COD
		Endif
		
		// Verifica a existencia do fator de conversao.
		_nConsMes /= IIf (SB1->B1_CONV != 0, SB1->B1_CONV, 1)
		
		_cCpo := "B3_Q" + StrZero(_nMes, 2)
		SB3->(&_cCpo) := _nConsMes
		SB3->(msUnlock())
		
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