#INCLUDE "rwmake.ch"
#DEFINE _EOL CHR(13) + CHR(10)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³cfinm01   º Autor ³ Felipe Raposo      º Data ³  15/01/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Faz a importacao dos titulos a receber ja baixados do sis- º±±
±±º          ³ tema SOE para o sistema Protheus atraves de arquivo texto  º±±
±±º          ³ com layout definido em reuniao entre ambas as partes.      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico CIEE.                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function cfinm01()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private oLeTxt, cArqTxt, cArqExt, cArqNom, cArqDir

cArqExt := ".FCB                                       "

If cEmpant == '01' //SP
	cArqDir := "\Arq_txt\Tesouraria\Fiba\  "
ElseIf cEmpant == '03' //RJ
	cArqDir := "\Arq_txtrj\Tesouraria\Fiba\  "
EndIf

//cArqDir := "\Arq_txt\Tesouraria\Fiba\  "
//cArqDir := "\\Fenix\Integra\CReceber\                "
cArqNom := dtos(dDataBase) + cArqExt


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 160, 001 TO 380, 430 DIALOG oLeTxt TITLE OemToAnsi("Leitura de arquivo texto")
@ 002, 002 TO 093, 212
@ 015, 018 Say "Diretorio"
@ 015, 050 Get cArqDir Picture "@S80" Valid .T.
@ 035, 018 Say "Arquivo"
@ 035, 050 Get cArqNom Picture "@S80" Valid .T.
@ 060, 018 Say "Este programa irá ler o conteúdo de um arquivo texto, conforme"
@ 068, 018 Say "os parâmetros definidos pelo usuário, e fará a importação dos "
@ 076, 018 Say "títulos recebidos pelo CIEE, atualizando o saldo bancário.    "
@ 095, 155 BMPBUTTON TYPE 01 ACTION OkFCB()
@ 095, 185 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)
Activate Dialog oLeTxt Centered
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ OKLETXT  º Autor ³ AP6 IDE            º Data ³  15/01/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao chamada pelo botao OK na tela inicial de processamenº±±
±±º          ³ to. Executa a leitura do arquivo texto.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function OkFCB

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _cMsg, _nAux1, _aCpoEsp, _cArqDig
Private nHdl, _cE1Tipo, _cE1Pref, _cCliImp, _cLojImp, _nRegs

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao dos parametros para esse programa.                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Tratamento do nome do arquivo digitado pelo usuario.

cArqTxt := AllTrim(cArqDir) + AllTrim(cArqNom)
cArqTxt += Space(100 - len(cArqTxt))

_cArqDig := cArqTxt := AllTrim(cArqTxt)
cArqTxt += IIf(!file(cArqTxt) .and. at(".", cArqTxt) == 0, cArqExt, "")
// Campos especificos para esse programa.
_aCpoEsp := {"E1_FCB", "E1_BOLETO"}
// Cliente e loja genericos para a importacao.
_cCliImp := "000001"
_cLojImp := "01"
// Tipo e prefixo utilizados para os titulos importados.
_cE1Tipo := "DP"
_cE1Pref := "FCB"



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abertura do arquivo texto.                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nHdl := fOpen(cArqTxt, 68)
If nHdl == -1
	Close(oLeTxt)
	_cMsg := "O arquivo " + _cArqDig + " não pôde ser aberto!"
	MsgAlert(OemToAnsi(_cMsg), OemToAnsi("Atenção!"))
	cArqTxt += Space(100 - len(cArqTxt))
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a existencia do cliente de importacao.                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SA1->(dbSetOrder(1))
If !SA1->(dbSeek(xFilial("SA1") + _cCliImp + _cLojImp, .F.))
	_cMsg := "O cliente 000001/01 - FCB, não cadastrado!"
	MsgAlert(OemToAnsi(_cMsg), OemToAnsi("Atenção!"))
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a existencia do indice 20 no SE1 (especifico).             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SE1->(dbSetOrder(28))   // E1_FILIAL+E1_HIST. (especifico)
If SE1->(IndexOrd()) != 28 .or. AllTrim(SE1->(IndexKey())) != "E1_FILIAL+E1_HIST"
	_cMsg := "Índice 28 (E1_FILIAL+E1_HIST), não cadastrado!"
	MsgAlert(OemToAnsi(_cMsg), OemToAnsi("Atenção!"))
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a existencia do indice 20 no SE1 (especifico).             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SE1->(dbSetOrder(28))   // E1_FILIAL+E1_HIST. (especifico)
If SE1->(dbSeek(xFilial("SE1")+cArqNom, .F.))
	_cMsg := "Arquivo " + AllTrim(cArqNom) + ", já importado!"
	MsgAlert(OemToAnsi(_cMsg), OemToAnsi("Atenção!"))
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a existencia dos campos especificos no sistema.            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SX3->(dbSetOrder(2))   // X3_CAMPO.
For _nAux1 := 1 to len(_aCpoEsp)
	If !SX3->(dbSeek(_aCpoEsp[_nAux1], .F.))
		_cMsg := "Campo Específico " + _aCpoEsp[_nAux1] + ", não cadastrado!"
		MsgAlert(OemToAnsi(_cMsg), OemToAnsi("Atenção!"))
		Return
	Endif
Next _nAux1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a existencia do indice 19 no SE1 (especifico).             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SE1->(dbSetOrder(29))   // E1_FILIAL+E1_FCB. (especifico)
If SE1->(IndexOrd()) != 29 .or. AllTrim(SE1->(IndexKey())) != "E1_FILIAL+E1_FCB"
	_cMsg := "Índice 29 (E1_FILIAL+E1_FCB), não cadastrado!"
	MsgAlert(OemToAnsi(_cMsg), OemToAnsi("Atenção!"))
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a regua de processamento.                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_nRegs:=0
Processa({|| RunFCB(@_nRegs)}, "Processando o arquivo " + cArqTxt + "...")
_cMsg := IIf(_nRegs == 0, "Não Houve Importacao", IIf(_nRegs == 1, "Foi importado 1 registro.", "Foram importados " + AllTrim(str(_nRegs)) + " registros."))
MsgInfo(OemToAnsi(_cMsg), OemToAnsi("Total"))

fClose(nHdl)
Close(oLeTxt)

Return



Static Function RunFCB(_nCnt)

Private nTamFile, nTamLin, cBuffer, nBtLidos, _nLin, _cMsg
Private _cAux1, _lAux1, _nAux1, _nPosCpo, _nCpoTam
Private LOTE, FCB, BOLETO, CLIENTE, CLASSE, NATUREZA, TIPO, EMISSAO, VENCIMENTO
Private LIQUIDACAO, VALORORIG, VALORLIQ, JUROS, MULTA, DESCONTO, TARIFA
Private BANCO, AGENCIA, CONTA, DIGCONTA, HISTORICO
Private _cCpoAux, _cE1Num, _cClasse, _cNatureza, _aCpos

_aCpos := {;
{"LOTE",       "C", 12, 00},;
{"NATUREZA",   "C", 07, 00},;
{"TIPO",       "C", 02, 00},;
{"VALORORIG",  "N", 11, 02},;
{"VALORLIQ",   "N", 11, 02},;
{"JUROS",      "N", 11, 02},;
{"MULTA",      "N", 11, 02},;
{"DESCONTO",   "N", 11, 02},;
{"TARIFA",     "N", 11, 02},;
{"BANCO",      "C", 03, 00},;
{"AGENCIA",    "C", 05, 00},;
{"CONTA",      "C", 10, 00},;
{"DIGCONTA",   "C", 01, 00},;
{"CREDITO",    "D", 08, 00}}

// Conta o tamanho do arquivo.
nTamLin := 0
For _nAux1 := 1 to len(_aCpos)
	nTamLin += _aCpos[_nAux1, 3]
Next _nAux1
nTamLin += len(_EOL)

// Variaveis auxiliares no processamento.
nTamFile := fSeek(nHdl, 0, 2)
cBuffer  := Space(nTamLin)
_nLin := _nCnt := 0

If ValFCB()
	
	// Prepara o ambiente para processamento.
	fSeek(nHdl, 0, 0)             // Vai para o inicio do arquivo.
	ProcRegua(nTamFile / nTamLin) // Numero de registros a processar.
	SA6->(dbSetOrder(1))          // A6_FILIAL+A6_COD+A6_AGENCIA+A6_NUMCON.
	
	// Processa todo o arquivo.
	nBtLidos := fRead(nHdl, @cBuffer, nTamLin) // Leitura da primeira linha do arquivo texto
	Do While nBtLidos >= nTamLin
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Interpreta a linha do arquivo, de acordo com o lay-out.             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_nPosCpo := 0
		For _nAux1 := 1 to len(_aCpos)
			_cCpoAux := _aCpos[_nAux1, 1]
			_nCpoTam := _aCpos[_nAux1, 3]
			_uCpoVal := SubStr(cBuffer, _nPosCpo + 1, _nCpoTam)
			Do Case
				Case _aCpos[_nAux1, 2] == "C"
					&(_cCpoAux) := _uCpoVal
				Case _aCpos[_nAux1, 2] == "N"
					_uCpoVal := SubStr(_uCpoVal, 1, _aCpos[_nAux1, 3]-_aCpos[_nAux1, 4]) + "." +;
					SubStr(_uCpoVal, _aCpos[_nAux1, 3]-_aCpos[_nAux1, 4] + 1, _aCpos[_nAux1, 4])
					&(_cCpoAux) := val(_uCpoVal)
				Case _aCpos[_nAux1, 2] == "D"
					&(_cCpoAux) := stod(_uCpoVal)
			EndCase
			_nPosCpo += _nCpoTam
		Next _nAux1
		_nLin ++  // Linha atual do arquivo.
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Incrementa a regua.                                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IncProc("Processando lote " + LOTE)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Certifica-se de que o titulo ja nao foi importado anteriormente.    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_cE1Num    := GetSX8Num("SE1", "E1_NUM")
		NATUREZA   := ALLTRIM(NATUREZA)
		SE1->(dbSetOrder(29))   // E1_FILIAL+E1_FCB. (especifico)
		//		If !SE1->(dbSeek(xFilial("SE1") + LOTE +"/"+_cE1Num, .F.))//FCB, .F.))
		
		_cHist     := AllTrim(cArqNom)
		
		// Monta a variavel CONTA.
		// Exclui os espacos em branco e os zeros da esquerda.
		
		_cAux1 := ""; _lAux1 := .T.
		For _nAux := 1 to len(CONTA)
			If !_lAux1 .or. !(SubStr(CONTA, _nAux, 1) $ " 0")
				_cAux1 += SubStr(CONTA, _nAux, 1)
				_lAux1 := .F.
			Endif
		Next _nAux
		CONTA := _cAux1
		// Adiciona o digito na variavel.
		If !Empty(DIGCONTA)
			CONTA := AllTrim(CONTA) + "-" + DIGCONTA
			CONTA := SubStr(CONTA, 1, 10)
			CONTA += Replicate(" ", 10 - len(CONTA))
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se a funcao GetSX8Num() funcionou corretamente.            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SE1->(dbSetOrder(1))   // E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO.
		If SE1->(dbSeek(xFilial("SE1") + _cE1Pref + _cE1Num, .F.))
			_cMsg := "Erro Crítico :" + _EOL +;
			"Erro na geração do número sequencial do título a receber! (E1_NUM)" + _EOL +;
			"O sistema irá abortar para evitar duplicidades dos títulos." + _EOL + _EOL +;
			"Favor entrar em contato com um administrador do sistema e" + _EOL +;
			"verificar os arquivos SXE e SXF."
			MsgAlert(OemToAnsi(_cMsg), OemToAnsi("Atenção - Linha " + AllTrim(Str(_nLin)) + " do arquivo texto"))
			Exit  // Terminar o processo de leitura do arquivo e sair.
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Begin Transaction - Faz o controle da transacao. Se algum erro ocor- ³
		//³ rer no meio do processamento, tudo o que foi processado ate o momen- ³
		//³ to eh estornado para a situacao anterior ao inicio do processamento. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Begin Transaction
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inclui o titulo a receber baixado.                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
        SE1FCB(_cE1Tipo,VALORORIG+TARIFA,VALORLIQ,TARIFA,JUROS,MULTA)          // Tarifa vai ocupar lugar do Desconto
		If DESCONTO != 0; SE1FCB("AB-",DESCONTO,DESCONTO,0,0,0) ; Endif // Desconto passa a ser Título AB-
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inclui os registros de movimento bancario.                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SE5FCB("VL", VALORLIQ, DESCONTO, JUROS, MULTA, _cHist, NATUREZA)
//		Alterado pelo analista Emerson dia 21/09 conf. SSI-10/0210
//		retirado linha do "IF TARIFA..."
//		If TARIFA   != 0; SE5FCB("DC", TARIFA,,,, _cHist+" Tarifa   s/Receb.Titulo ","2.15.01"); Endif
//		If MULTA    != 0; SE5FCB("MT", MULTA,,,,  _cHist+" Multa    s/Receb.Titulo ","3.01.03"); Endif
		If JUROS    != 0; SE5FCB("JR", JUROS,,,,  _cHist+" Juros    s/Receb.Titulo ","3.01.03"); Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza o saldo bancario.                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AtuSalBco(BANCO, AGENCIA, CONTA, CREDITO, VALORLIQ, "+")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Fim do controle da transacao. Efetiva o que foi processado.         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		End Transaction                               
		ConfirmSX8()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Leitura da proxima linha do arquivo texto.                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nBtLidos := fRead(nHdl, @cBuffer, nTamLin)
	EndDo
Else
	_cMsg := "Houve Erro na Validação"
	MsgAlert(OemToAnsi(_cMsg), OemToAnsi("Atenção!"))
	
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ValArq   ºAutor  ³ Andy Pudja         º Data ³  28/08/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava titulos em SE1                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico CIEE.                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValFCB()
Local _cRet:=.T.

fSeek(nHdl, 0, 0)             // Vai para o inicio do arquivo.
ProcRegua(nTamFile / nTamLin) // Numero de registros a processar.
SA6->(dbSetOrder(1))          // A6_FILIAL+A6_COD+A6_AGENCIA+A6_NUMCON.

// Processa todo o arquivo.
nBtLidos := fRead(nHdl, @cBuffer, nTamLin) // Leitura da primeira linha do arquivo texto

Do While nBtLidos >= nTamLin
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Interpreta a linha do arquivo, de acordo com o lay-out.             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_nPosCpo := 0
	For _nAux1 := 1 to len(_aCpos)
		_cCpoAux := _aCpos[_nAux1, 1]
		_nCpoTam := _aCpos[_nAux1, 3]
		_uCpoVal := SubStr(cBuffer, _nPosCpo + 1, _nCpoTam)
		Do Case
			Case _aCpos[_nAux1, 2] == "C"
				&(_cCpoAux) := _uCpoVal
			Case _aCpos[_nAux1, 2] == "N"
				_uCpoVal := SubStr(_uCpoVal, 1, _aCpos[_nAux1, 3]-_aCpos[_nAux1, 4]) + "." +;
				SubStr(_uCpoVal, _aCpos[_nAux1, 3]-_aCpos[_nAux1, 4] + 1, _aCpos[_nAux1, 4])
				&(_cCpoAux) := val(_uCpoVal)
			Case _aCpos[_nAux1, 2] == "D"
				&(_cCpoAux) := stod(_uCpoVal)
		EndCase
		_nPosCpo += _nCpoTam
	Next _nAux1
	_nLin ++  // Linha atual do arquivo.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Incrementa a regua.                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncProc("Processando lote " + LOTE)
	
	
	_cAux1 := ""; _lAux1 := .T.
	For _nAux := 1 to len(CONTA)
		If !_lAux1 .or. !(SubStr(CONTA, _nAux, 1) $ " 0")
			_cAux1 += SubStr(CONTA, _nAux, 1)
			_lAux1 := .F.
		Endif
	Next _nAux
	CONTA := _cAux1
	If !empty(DIGCONTA)
		CONTA := AllTrim(CONTA) + "-" + DIGCONTA
		CONTA := SubStr(CONTA, 1, 10)
		CONTA += Replicate(" ", 10 - len(CONTA))
	Endif
	
	//ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
	//º O sistema faz algumas consistencias do registro                     º
	//º antes de realizar a importacao.                                     º
	//ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
	_cMsg := ""
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica a existencia do banco/agencia/conta no sistema.            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If !SA6->(dbSeek(xFilial("SA6") + BANCO + AGENCIA + CONTA, .F.))
		_cMsg := "Banco " + BANCO + " - ag. " + AGENCIA + " - conta " + CONTA + ", não cadastrado!"
		MsgAlert(OemToAnsi(_cMsg), OemToAnsi("Atenção!"))
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verificacao da natureza no sistema.                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !SED->(dbSeek(xFilial("SED") + NATUREZA, .F.))
		_cMsg := "Natureza " + NATUREZA +", não cadastrada!"
		MsgAlert(OemToAnsi(_cMsg), OemToAnsi("Atenção!"))
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o total do titulo esta correto.                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//	DESCONTO += TARIFA
//	If !(VALORORIG + JUROS + MULTA - DESCONTO - TARIFA == VALORLIQ) 
	If !(VALORORIG + JUROS + MULTA - DESCONTO == VALORLIQ)
		_cMsg := "Erro no Valor: " + Transform(VALORORIG, PesqPict("SE1", "E1_VALOR"))
		MsgAlert(OemToAnsi(_cMsg), OemToAnsi("Atenção!"))
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se houve algum erro durante o processamento.               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !empty(_cMsg)
		_cRet:=.F.
	Endif
	
	nBtLidos := fRead(nHdl, @cBuffer, nTamLin)
EndDo

Return(_cRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IncSE1    ºAutor  ³ Andy Pudja         º Data ³  28/08/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava titulos em SE1                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico CIEE.                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function SE1FCB(_cTipo,_nE1Ori,_nE1Liq,_nE1Tar,_nE1Jur,_nE1Mul)

_cDescNat := POSICIONE("SED",1,xFilial("SED")+NATUREZA,"ED_DESCRIC")
_nRegs    :=_nRegs + 1

RecLock("SE1", .T.)
SE1->E1_FILIAL  := xFilial("SE1")
SE1->E1_FILORIG := xFilial("SE1")
SE1->E1_NUM     := _cE1Num
SE1->E1_PREFIXO := _cE1Pref  // IIF(CLASSE=="998","I",TIPO)
SE1->E1_TIPO    := _cTipo
SE1->E1_NATUREZ := NATUREZA  // _cNatureza

// Cliente generico de importacao.
SE1->E1_CLIENTE := "000001" // _cCliImp
SE1->E1_LOJA    := _cLojImp
SE1->E1_NOMCLI  := "FCB" // CLIENTE
//
SE1->E1_EMISSAO := CREDITO // EMISSAO
SE1->E1_EMIS1   := CREDITO // EMISSAO
SE1->E1_VENCTO  := CREDITO // VENCIMENTO
SE1->E1_VENCORI := CREDITO // VENCIMENTO
SE1->E1_VENCREA := DataValida(CREDITO) // DataValida(VENCIMENTO)
SE1->E1_BAIXA   := CREDITO // LIQUIDACAO
SE1->E1_MOVIMEN := CREDITO // LIQUIDACAO
SE1->E1_VALOR   := _nE1Ori
SE1->E1_HIST    := _cHist
SE1->E1_VLCRUZ  := _nE1Ori
SE1->E1_MOEDA   := 1
SE1->E1_SITUACA := "0"
SE1->E1_STATUS  := "B"
SE1->E1_MULTNAT := "2"
SE1->E1_PROJPMS := "2"
SE1->E1_ORIGEM  := "FINA040"  // "CMAST01"
SE1->E1_FLUXO   := SA6->A6_FLUXCAI
SE1->E1_OCORREN := xFilial("SE1")
// Campos especificos CIEE.
SE1->E1_FCB     := LOTE+"/"+_cE1Num //FCB
SE1->E1_BOLETO  := LOTE+"/"+_cE1Num //BOLETO

SE1->E1_VALLIQ  := _nE1Liq
SE1->E1_DESCONT := _nE1Tar // TARIFA PASSA A SER DESCONTO E DESCONTO VAI GERAR E1 COMO AB-
SE1->E1_JUROS   := _nE1Jur
SE1->E1_MULTA   := _nE1Mul

SE1->(msUnLock())
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IncSE5    ºAutor  ³ Felipe Raposo      º Data ³  17/01/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria movimentacao bancaria, de acordo com os valores pas-  º±±
±±º          ³ sados por parametro.                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico CIEE.                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function SE5FCB(_cTipoDoc, _nValLiq, _nDesc, _nJuros, _nMulta, _cHistor, _cNatSE5)

// Verifica se as variaveis foram passadas por parametro.
// Se nao foram, assumir o valor zero.
_nDesc   := IIf(ValType(_nDesc)   == "N", _nDesc,  0)
_nJuros  := IIf(ValType(_nJuros)  == "N", _nJuros, 0)
_nMulta  := IIf(ValType(_nMulta)  == "N", _nMulta, 0)

RecLock("SE5", .T.)
SE5->E5_FILIAL  := xFilial("SE5")
SE5->E5_TIPODOC := _cTipoDoc
SE5->E5_RECPAG  := "R"
SE5->E5_DATA    := CREDITO // LIQUIDACAO
SE5->E5_NUMERO  := _cE1Num
SE5->E5_PREFIXO := _cE1Pref  // IIF(CLASSE=="998","I",TIPO)
SE5->E5_TIPO    := _cE1Tipo
SE5->E5_VALOR   := _nValLiq
SE5->E5_VLDESCO := _nDesc
SE5->E5_VLJUROS := _nJuros
SE5->E5_VLMULTA := _nMulta
SE5->E5_NATUREZ := _cNatSE5 // NATUREZA 
SE5->E5_BANCO   := BANCO
SE5->E5_AGENCIA := AGENCIA
SE5->E5_CONTA   := CONTA
SE5->E5_HISTOR  := _cHistor
SE5->E5_VLMOED2 := xMoeda(_nValLiq, 1, 2, dDataBase, 2)
SE5->E5_LA      := "N"
SE5->E5_CLIFOR  :=	"000001" // _cCliImp
SE5->E5_LOJA    := _cLojImp
SE5->E5_DTDIGIT := CREDITO // dDataBase
SE5->E5_MOTBX   := "NOR"
SE5->E5_RECONC  := ""  // A reconciliar.
SE5->E5_SEQ     := "01"
SE5->E5_DTDISPO := dDataBase
SE5->(msUnLock())
Return
