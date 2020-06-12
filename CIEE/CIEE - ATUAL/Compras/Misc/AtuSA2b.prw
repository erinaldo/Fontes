#INCLUDE "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AtuSA2b   º Autor ³ Felipe Raposo      º Data ³  29/07/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Recebe o arquivo com os dados dos fornecedores ja altera-  º±±
±±º          ³ dos pelo setor de informatica e atualiza os dados do sis-  º±±
±±º          ³ ma.                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AtuSA2b()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _lRet
Private cArqTxt, nHdl, cEOL
Private oLerTxt
Private cString := "SA2"
// Campos pertencentes ao arquivo de retorno.
Private _aCpo := {"A2_COD", "A2_CGC", "A2_CONV", "A2_ESTNUM"}
// Caractere delimitador.
Private _cDelim := "|"
// Extensao padrao do arquivo de retorno.
Private _cExtArq := "ret"
// Diretorio padrao do arquivo de retorno.
Private _cPath := "\AtuForn\"

cArqTxt := _cPath + dtos(dDataBase) + "." + _cExtArq + space(60)
cEOL    := chr(13) + chr(10)  // Final da linha.
_lRet   := .F.

dbSelectArea(cString)
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 200, 001 to 380, 380 dialog oLerTxt Title OemToAnsi("Retorno do arquivo texto")
@ 002, 002 to 073, 188
@ 018, 018 Say "Arquivo"
@ 018, 060 Get cArqTxt Picture "@S70" Valid .T.
@ 040, 018 Say OemToAnsi("Este programa irá ler um arquivo texto, conforme os parâme-")
@ 048, 018 Say OemToAnsi("tros definidos pelo usuário, para atualizar alguns campos  ")
@ 056, 018 Say OemToAnsi("do cadastro de fornecedores.                               ")
@ 075, 128 BmpButton Type 01 Action _lRet := OkLerTxt()
@ 075, 158 BmpButton Type 02 Action Close(oLerTxt)
Activate Dialog oLerTxt Centered
Return (_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³OkLerTxt  º Autor ³ Felipe Raposo      º Data ³  24/07/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao chamada pelo botao OK na tela inicial de processamenº±±
±±º          ³ to. Executa a leitura do arquivo texto.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function OkLerTxt()
Local _lRet
_lRet := .F.
// Adiciona a extensao ao arquivo.
If at(".", cArqTxt) == 0
	cArqTxt := AllTrim(cArqTxt) + "." + _cExtArq
Endif
// Adiciona o diretorio, caso nao tenha sido informado.
If at("\", cArqTxt) == 0
	cArqTxt := _cPath + AllTrim(cArqTxt)
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o arquivo texto                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !file(cArqTxt)
	_cMsg := "O arquivo " + cArqTxt + " não existe!" + cEOL +;
	"Verifique os parâmetros."
	MsgBox(OemToAnsi(_cMsg), OemToAnsi("Atenção!"), "ALERT")
ElseIf (nHdl := fOpen(cArqTxt, 68)) == -1
	_cMsg := "O arquivo " + cArqTxt + " não pode ser aberto!" + cEOL +;
	"Verifique os parâmetros."
	MsgBox(OemToAnsi(_cMsg), OemToAnsi("Atenção!"), "ALERT")
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa a regua de processamento                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Processa({|| _lRet := RunCont() },"Processando...")
	Close(oLerTxt)
Endif
Return (_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ RUNCONT  º Autor ³ Felipe Raposo      º Data ³  24/07/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RunCont()
Local nTamLin, nTamFile, nBtLidos
Local cLin, _nAux1, _nAux2, lCont
Local _cTipo, _aTamX3, _aCpoAux, _lRet
Local _cMsg, _cTit, _nCnt, _nPos, _nPont
Local _nTamInt, _nTamDec
Local _cAlsAnt, _aAreaAnt, _aAreaStr
Local _aConvIrr := {}
Private cBuffer

// Salva o estado dos arquivos abertos.
_cAlsAnt  := Alias()
_aAreaAnt := GetArea()
dbSelectArea(cString)
_aAreaStr := GetArea()

nTamFile := fSeek(nHdl, 0, 2)  // Tamanho do arquivo.

// Conta o tamanho da linha (procura pelo primeiro cEOL).
cBuffer := ""; _nPos := 1; lCont := .T.; nTamLin := 0
fSeek(nHdl, 0)  // Posiciona no inicio do arquivo.
Do While fRead(nHdl, @cBuffer, 1) != 0  // Nao for fim de arquivo.
	If cBuffer == SubStr(cEOL, _nPos, 1)
		If _nPos >= len(cEOL)
			nTamLin := fSeek(nHdl, 0, 1) // Pega a posicao atual do ponteiro no arquivo.
			fSeek(nHdl, 0, 2)  // Vai para o fim do arquivo. Forca o fim do looping.
		Else
			_nPos ++
		Endif
	Else
		_nPos := 1
	Endif
EndDo
cBuffer := Space(nTamLin)

// Cria array com as especificacoes de cada campo.
_aCpoAux := {}
For _nAux1 := 1 to len(_aCpo)
	_cCampo := _aCpo[_nAux1]
	_cTipo  := Type(_cCampo)
	_aTamX3 := TamSX3(_cCampo)
	aAdd(_aCpoAux, {_cCampo, _cTipo, _aTamX3[1], _aTamX3[2], ""})
Next _nAux1

// Processa o arquivo texto.
_nCnt := 0
ProcRegua(nTamFile / nTamLin)  // Numero de registros a processar.
fSeek(nHdl, 0)  // Posiciona no inicio do arquivo.
nBtLidos := fRead(nHdl, @cBuffer, nTamLin)  // Leitura da primeira linha do arquivo texto.
Do While nBtLidos >= nTamLin // !eof()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Incrementa a regua                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncProc()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Le todos os campos do registro corrente do arquivo texto e atualiza ³
	//³ a tabela do sistema.                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_nPont := 1
	For _nPos := 1 to len(_aCpoAux)
		
		// Le o campo.
		_cCampo := ""
		_cChar  := ""
		Do While (_cChar != _cDelim) .and. (_nPont < nTamLin)
			_cCampo += _cChar
			_cChar := SubStr(cBuffer, _nPont, 1)
			_nPont ++
		EndDo
		
		// Compatibiliza o campo antes de gravar.
		Do Case
			Case Type(_aCpoAux[_nPos, 1]) == "C"
				// Nao fazer nada.
				
			Case Type(_aCpoAux[_nPos, 1]) == "N"
				_nTamInt := _aCpoAux[_nPos][3] - _aCpoAux[_nPos][4]
				_nTamDec := _aCpoAux[_nPos][4]
				_cCampo  := val(SubStr(_cCampo, 1, _nTamInt) +;  // parte inteira.
				"." + SubStr(_cCampo, _nTamInt + 1, _nTamDec))  // parte decimal.
				
			Case Type(_aCpoAux[_nPos, 1]) == "D"
				_cCampo := stod(_cCampo)
				
			Case Type(_aCpoAux[_nPos, 1]) == "L"
				_cCampo := (_cCampo == "T")
				
			OtherWise
				_cCampo := _aCpoAux[_nPos, 1]
				_cMsg := "O campo " + _cCampo + " é do tipo " + Type(_cCampo) +;
				" e não pode ser importado. Entre em contato com o administrador " +;
				"do sistema."
				MsgBox(OemToAnsi(_cMsg), OemToAnsi("Atenção!"), "ALERT")
				msUnLock()
				Return
		EndCase
		// Armazena o campo.
		_aCpoAux[_nPos, 5] := _cCampo
	Next _nPos
	
	// Depois que todos os campos foram lidos, gravar no sistema.
	If dbSeek(xFilial("SA2") + _aCpoAux[1, 5], .F.)
		RecLock(cString, .F.)
		// O arquivo so eh atualizado a partir do terceiro campo. Os dois
		// primeiros campos sao Codigo e CNPJ/CPF, portanto nao precisam/
		// e nem podem ser atualizados.
		For _nAux1 := 3 to len(_aCpoAux)
			FieldPut(FieldPos(_aCpoAux[_nAux1, 1]), _aCpoAux[_nAux1, 5])
		Next _nAux1
		msUnLock()
		
		// Verifica se o campo "Convenente" esta com alguma irregularidade.
		If (SA2->A2_CONV == "I")
			aAdd (_aConvIrr, {SA2->A2_COD, SA2->A2_CGC})
		Endif
	Else
		_cMsg := "Fornecedor " + _aCpoAux[1, 5] + " não encontrado."
		MsgBox(OemToAnsi(_cMsg), OemToAnsi("Atenção!"), "ALERT")
	Endif
	
	// Passa para o proximo registro do arquivo texto.
	_nCnt ++
	nBtLidos := fRead(nHdl, @cBuffer, nTamLin) // Leitura da proxima linha do arquivo texto.
EndDo

// Restaura o estado dos arquivos abertos.
RestArea(_aAreaStr)
dbSelectArea(_cAlsAnt)
RestArea(_aAreaAnt)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ³
//³ cao anterior.                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
fClose(nHdl)
If (_lRet := file(cArqTxt))
	_cMsg := "Arquivo lido com sucesso: " + AllTrim(cArqTxt) + cEOL +;
	"Total: " + AllTrim(str(_nCnt)) + " registro(s) atualizados(s) no sistema."
	// Trata os fornecedores que apresentaram irregularidades no cadastro do SOE.
	If !empty(_aConvIrr)
		_cMsg += cEOL + cEOL + cEOL +;
		"Os fornecedores abaixo apresentaram irregularidades no cadastro do SOE." + cEOL + cEOL
		For _nAux1 := 1 to len(_aConvIrr)
			_cMsg += "Cod: " + _aConvIrr[_nAux1][1] +;
			" - CNPJ: " + Transform(_aConvIrr[_nAux1][2], PesqPict("SA2", "A2_CGC")) + cEOL
		Next _nAux1
	Endif
	MsgBox(OemToAnsi(_cMsg), OemToAnsi("Leitura do arquivo"), "INFO")
Endif
Return (_lRet)