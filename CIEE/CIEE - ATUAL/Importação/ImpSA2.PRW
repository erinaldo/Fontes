#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ImpSA2    � Autor � Felipe Raposo      � Data �  07/08/02   ���
�������������������������������������������������������������������������͹��
���Descricao � Importa o cadastro de funcionarios para a tabela SA2.      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE.                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function ImpSA2()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Private oLeTxt
Private cString := "SA2"

dbSelectArea("SA2")
dbSetOrder(1)

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������

@ 200,001 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Leitura de Arquivo Texto")
@ 002,010 TO 080,190
@ 010,018 Say "Este programa ira ler o conteudo de um arquivo texto, conforme   "
@ 018,018 Say "os parametros definidos pelo usuario, com os registros do arquivo"
@ 026,018 Say "SA2.                                                             "
@ 070,128 BMPBUTTON TYPE 01 ACTION OkLeTxt()
@ 070,158 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)
Activate Dialog oLeTxt Centered
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � OKLETXT  � Autor � AP6 IDE            � Data �  07/08/02   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao chamada pelo botao OK na tela inicial de processamen���
���          � to. Executa a leitura do arquivo texto.                    ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function OkLeTxt

//���������������������������������������������������������������������Ŀ
//� Abertura do arquivo texto                                           �
//�����������������������������������������������������������������������
Private cArqTxt, nHdl, cEOL
cEOL    := CHR(13)+CHR(10)
SA2->(dbSetOrder(3))
Private _nCod := 1
//���������������������������������������������������������������������Ŀ
//� Inicializa a regua de processamento                                 �
//�����������������������������������������������������������������������
cArqTxt := "\\FENIX\TEMP\ArqFunc1.TXT"
nHdl    := fOpen(cArqTxt,68)
If nHdl == -1
	MsgAlert("O arquivo de nome " + cArqTxt + " nao pode ser aberto! Verifique os parametros.","Atencao!")
	Return
Endif
Processa({|| _nCod := RunCont1(_nCod) },"Processando arquivo " + cArqTxt + "...")

cArqTxt := "\\FENIX\TEMP\ArqFunc2.TXT"
nHdl    := fOpen(cArqTxt,68)
If nHdl == -1
	MsgAlert("O arquivo de nome " + cArqTxt + " nao pode ser aberto! Verifique os parametros.","Atencao!")
	Return
Endif
Processa({|| _nCod := RunCont2(_nCod) },"Processando arquivo " + cArqTxt + "...")
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RUNCONT  � Autor � AP5 IDE            � Data �  07/08/02   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function RunCont1(_nCod)

Local nTamFile, nTamLin, cBuffer, nBtLidos
nTamFile := fSeek(nHdl,0,2)  // Posiciona no final do registro e retorna o tamanho.
fSeek(nHdl,0,0)
nTamLin  := 8 + Len(cEOL)
cBuffer  := Space(nTamLin) // Variavel para criacao da linha do registro para leitura
// nBtLidos := fRead(nHdl, @cBuffer, 1) // Leitura da primeira linha do arquivo texto

_lCont := .T.
_cLin := ""
Do While _lCont
	fRead(nHdl, @cBuffer, 1)
	If cBuffer == chr(10) .or. cBuffer == chr(13)
		fRead(nHdl, @cBuffer, 1)
		_lCont := .F.
	Else
		_cLin += cBuffer
	Endif
EndDo
cBuffer := _cLin

ProcRegua(nTamFile) // Numero de registros a processar
Do While fSeek(nHdl,0,1) < nTamFile // nBtLidos >= nTamLin
	
	If (SubStr(cBuffer, 5, 1) + SubStr(cBuffer, 9, 1) == "..")
		//���������������������������������������������������������������������Ŀ
		//� Grava os campos obtendo os valores da linha lida do arquivo texto.  �
		//�����������������������������������������������������������������������
		// Separa os campos do arquivo texto.
		_cCPF    := SubStr(cBuffer, 002, 14)
		_cNome   := SubStr(cBuffer, 017, 27)
		_cEnder  := SubStr(cBuffer, 045, 31)
		_cBairro := SubStr(cBuffer, 076, 26)
		_cCidade := SubStr(cBuffer, 102, 15)
		
		// Retira a mascara do CPF.
		_cAux := ""
		For _iAux1 := 1 to len(_cCPF)
			If Entre(asc("0"), asc("9"), asc(SubStr(_cCPF, _iAux1, 1)))
				_cAux += SubStr(_cCPF, _iAux1, 1)
			Endif
		Next _iAux1
		_cCPF := _cAux
		
		// Grava na tabela SA2.
		If SA2->(dbSeek(xFilial("SA2") + _cCPF, .F.))  // Se ja existir.
			RecLock("SA2", .F.)  // Abre para gravacao.
		Else
			RecLock("SA2", .T.)  // Cria novo registro.
			SA2->A2_FILIAL := xFilial("SA2")
			SA2->A2_CGC    := _cCPF
			SA2->A2_COD    := "F" + StrZero(_nCod ++, 5)
			SA2->A2_LOJA   := "01"
			SA2->A2_TPFOR  := "2"
		Endif
		SA2->A2_NOME   := _cNome
		SA2->A2_NREDUZ := _cNome
		SA2->A2_END    := _cEnder
		SA2->A2_BAIRRO := _cBairro
		SA2->A2_MUN    := _cCidade
		SA2->(msUnLock())  // Salva alteracoes.
	Endif
	//���������������������������������������������������������������������Ŀ
	//� Leitura da proxima linha do arquivo texto.                          �
	//�����������������������������������������������������������������������
	// nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto.
	_lCont := .T.
	_cLin := ""
	Do While _lCont
		//���������������������������������������������������������������������Ŀ
		//� Incrementa a regua                                                  �
		//�����������������������������������������������������������������������
		IncProc()
		fRead(nHdl, @cBuffer, 1)
		If cBuffer == chr(10) .or. cBuffer == chr(13)
			fRead(nHdl, @cBuffer, 1)
			_lCont := .F.
		Else
			_cLin += cBuffer
		Endif
	EndDo
	cBuffer := _cLin
	
EndDo

//���������������������������������������������������������������������Ŀ
//� O arquivo texto deve ser fechado, bem como o dialogo criado na fun- �
//� cao anterior.                                                       �
//�����������������������������������������������������������������������
fClose(nHdl)
Close(oLeTxt)
Return (_nCod)


/**//**//**/


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RUNCONT  � Autor � AP5 IDE            � Data �  07/08/02   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function RunCont2(_nCod)

Local nTamFile, nTamLin, cBuffer, nBtLidos
nTamFile := fSeek(nHdl,0,2)  // Posiciona no final do registro e retorna o tamanho.
fSeek(nHdl,0,0)
nTamLin  := 8 + Len(cEOL)
cBuffer  := Space(nTamLin) // Variavel para criacao da linha do registro para leitura
//nBtLidos := fRead(nHdl, @cBuffer, nTamLin) // Leitura da primeira linha do arquivo texto
_lCont := .T.
_cLin := ""
Do While _lCont
	fRead(nHdl, @cBuffer, 1)
	If cBuffer == chr(10) .or. cBuffer == chr(13)
		fRead(nHdl, @cBuffer, 1)
		_lCont := .F.
	Else
		_cLin += cBuffer
	Endif
EndDo
cBuffer := _cLin


ProcRegua(nTamFile) // Numero de registros a processar
_nCod := 1
Do While fSeek(nHdl,0,1) < nTamFile // nBtLidos >= nTamLin
	
	//���������������������������������������������������������������������Ŀ
	//� Incrementa a regua                                                  �
	//�����������������������������������������������������������������������
	IncProc()
	
	If (SubStr(cBuffer, 6, 1) + SubStr(cBuffer, 10, 1) == "..")
		//���������������������������������������������������������������������Ŀ
		//� Grava os campos obtendo os valores da linha lida do arquivo texto.  �
		//�����������������������������������������������������������������������
		// Separa os campos do arquivo texto.
		_cCPF     := SubStr(cBuffer, 003, 14)
		_cBanco   := SubStr(cBuffer, 019, 03)
		_cAgencia := SubStr(cBuffer, 025, 09)
		_cConta   := SubStr(cBuffer, 039, 10)
		_cCEP     := SubStr(cBuffer, 057, 09)
		_cUF      := SubStr(cBuffer, 069, 02)
		
		// Retira a mascara do CPF.
		_cAux := ""
		For _iAux1 := 1 to len(_cCPF)
			If Entre(asc("0"), asc("9"), asc(SubStr(_cCPF, _iAux1, 1)))
				_cAux += SubStr(_cCPF, _iAux1, 1)
			Endif
		Next _iAux1
		_cCPF := _cAux
		
		// Retira a mascara do CEP.
		_cAux := ""
		For _iAux1 := 1 to len(_cCEP)
			If Entre(asc("0"), asc("9"), asc(SubStr(_cCEP, _iAux1, 1)))
				_cAux += SubStr(_cCEP, _iAux1, 1)
			Endif
		Next _iAux1
		_cCEP := _cAux
		
		// Trata a agencia
		//_cAgencia
		_cAux := ""
		For _iAux1 := 1 to len(_cAgencia)
			If Entre(asc("0"), asc("9"), asc(SubStr(_cAgencia, _iAux1, 1)))
				_cAux += SubStr(_cAgencia, _iAux1, 1)
			Endif
		Next _iAux1
		_cAgencia := AllTrim(Str(val(_cAux)))
		
		// Grava na tabela SA2.
		If SA2->(dbSeek(xFilial("SA2") + _cCPF, .F.))  // Se ja existir.
			RecLock("SA2", .F.)  // Abre para gravacao.
		//Else
		//	RecLock("SA2", .T.)  // Cria novo registro.
		//	SA2->A2_FILIAL := xFilial("SA2")
		//	SA2->A2_CGC    := _cCPF
		//	SA2->A2_COD    := "F" + StrZero(_nCod ++, 5)
		//	SA2->A2_LOJA   := "01"
		//Endif
			SA2->A2_BANCO   := _cBanco
			SA2->A2_AGENCIA := _cAgencia
			SA2->A2_NUMCON  := _cConta
			SA2->A2_CEP     := _cCEP
			SA2->A2_EST     := _cUF
			SA2->(msUnLock())  // Salva alteracoes.
		Endif
	Endif
	
	//���������������������������������������������������������������������Ŀ
	//� Leitura da proxima linha do arquivo texto.                          �
	//�����������������������������������������������������������������������
	//nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto.
	_lCont := .T.
	_cLin := ""
	Do While _lCont
		//���������������������������������������������������������������������Ŀ
		//� Incrementa a regua                                                  �
		//�����������������������������������������������������������������������
		IncProc()
		fRead(nHdl, @cBuffer, 1)
		If cBuffer == chr(10) .or. cBuffer == chr(13)
			fRead(nHdl, @cBuffer, 1)
			_lCont := .F.
		Else
			_cLin += cBuffer
		Endif
	EndDo
	cBuffer := _cLin

EndDo

//���������������������������������������������������������������������Ŀ
//� O arquivo texto deve ser fechado, bem como o dialogo criado na fun- �
//� cao anterior.                                                       �
//�����������������������������������������������������������������������
fClose(nHdl)
Close(oLeTxt)
Return(_nCod)