#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO3     � Autor � AP6 IDE            � Data �  19/04/02   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function IMPSA1()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Private cPerg       := "A1_COD"
Private oLeTxt  // Objeto dialog mostrado no inicio do processamento.

// Arquivo origem.
Private cArqTxt := "\\fenix\ap6\ap_data\sigaadv\Import\ARQUIVO.TXT"
// Alias destino.
Private cString := "SA1"

Private _cMsgCpo := '"A1_COD"', _cMsgVa := 'SubStr(cBuffer, 1, 6)'
//�����������������������������������������������������������������ͻ
//� Lay-out do arquivo texto gerado:                                �
//�����������������������������������������������������������������͹
//� Campo origem � Tipo � Tamanho � Decimal � Campo destino         �
//�����������������������������������������������������������������ͼ
Private _aLayOut := {;
{'CODCLI',  'C', 06, 00, 'A1_COD'},;
{'NOMECLI', 'C', 30, 00, 'A1_NOME'}}

//�����������������������������������������������������������������ͻ
//� Lay-out da matriz de campo padrao:                              �
//�����������������������������������������������������������������͹
//� Campo destino � Valor padrao o                                  �
//�����������������������������������������������������������������ͼ
Private _aCmpPad := {;
{'A1_COD', 'xFilial("SA1")'},;
{'A1_PAIS', '"BRA"'}}

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������
@ 200,1 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Leitura de Arquivo Texto")
@ 02,10 TO 080,190
@ 10,018 Say "Este programa ira ler o conteudo de um arquivo texto, conforme"
@ 18,018 Say "os parametros definidos pelo usuario, com os registros do arquivo"
@ 26,018 Say "Arquivo texto - " + cArqTxt
@ 34,018 Say "Alias - " + cString
@ 70,128 BMPBUTTON TYPE 01 ACTION OkLeTxt()
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)
//@ 70,188 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg, .T.)
Activate Dialog oLeTxt Centered
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � OKLETXT  � Autor � AP6 IDE            � Data �  19/04/02   ���
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
nHdl := fOpen(cArqTxt, 68)
If nHdl == -1
	MsgBox("O arquivo de nome " + cArqTxt + " nao pode ser aberto! Verifique os parametros.", "Atencao!", "ALERT")
	Return
Endif

//���������������������������������������������������������������������Ŀ
//� Inicializa a regua de processamento                                 �
//�����������������������������������������������������������������������
Processa({|| RunCont() },"Processando...")
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RUNCONT  � Autor � AP5 IDE            � Data �  19/04/02   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function RunCont

Local nTamFile, nTamLin, cBuffer, nBtLidos, _iAux1

// Calcula o tamanho da linha.
nTamLin := Len(cEOL)
For _iAux1 := 1 to len(_aLayOut)
	nTamLin += (_aLayOut[_iAux1, 3] + _aLayOut[_iAux1, 4])
Next _iAux1

nTamFile := fSeek(nHdl, 0, 2)  // Similar ao RecCount().
ProcRegua(nTamFile) // Numero de registros a processar.

cBuffer  := Space(nTamLin) // Variavel para criacao da linha do registro para leitura.
fSeek (nHdl, 0, 0)  // Move o cursos do registro para o BOF().
nBtLidos := fRead(nHdl, @cBuffer, nTamLin) // Leitura da primeira linha do arquivo texto.
dbSelectArea(cString)

Do While nBtLidos >= nTamLin
	
	//���������������������������������������������������������������������Ŀ
	//� Incrementa a regua                                                  �
	//�����������������������������������������������������������������������
	IncProc()
	ProcRegua("Importando " + &_cMsgCpo + " - " + &_cMsgVal )
	
	//���������������������������������������������������������������������Ŀ
	//� Grava os campos obtendo os valores da linha lida do arquivo texto.  �
	//�����������������������������������������������������������������������
	RecLock(cString, .T.)  // Abre um registro novo em branco no alias.
	
	// Grava os campos, de acordo com o lay-out da matriz _aLayOut.
	_nPos := 01
	For _iAux1 := 1 to len(_aLayOut)
		_nTam := _aLayOut[_iAux1, 3]  // Tamanho do campo.
		_nDec := _aLayOut[_iAux1, 4]  // Tamanho do decimal.
		Do Case
			Case upper(_aLayOut[_iAux1, 2]) $ 'CM'  // Se for caractere ou memo.
				_cCmpDe := SubStr(cBuffer, _nPos, _nTam)
			Case upper(_aLayOut[_iAux1, 2]) == 'N'  // Se for numerico.
				_cCmpDe := SubStr(cBuffer, _nPos, _nTam - (_nDec + 1)) +;  // Parte inteira.
				"," + SubStr(cBuffer, (_nPos + _nTam) - (_nDec + 1), _nDec)  // Parte decimal.
				_cCmpDe := val(_cCmpDe)
			Case upper(_aLayOut[_iAux1, 2]) == 'D'  // Se for data.
				_cCmpDe := ctod(SubStr(cBuffer, _nPos, _nTam))
			Case upper(_aLayOut[_iAux1, 2]) == 'L'  // Se for logico.
				// Campo logico a  definir...
				_cCmpDe := CriaVar(_cCmpAte)  // Cria a variavel vazia.
		EndCase
		_cCmpAte := _aLayOut[_iAux1, 5]
		FieldPut(FieldPos(_cCmpAte), &_cCmpDe)
		_nPos += _nTam  // Posicao do proximo campo.
	Next _iAux1
	
	// Grava os campos padroes, de acordo com os parametros da matriz _aCmpPad.
	For _iAux1 := 1 to len(_aCmpPad)
		_cCmpDe  := _aCmpPad[_iAux1, 2]
		_cCmpAte := _aCmpPad[_iAux1, 1]
		FieldPut(FieldPos(_cCmpAte), &_cCmpDe)
	Next _iAux1
	msUnLock()  // Salva as alteracoes do alias.
	
	//���������������������������������������������������������������������Ŀ
	//� Leitura da proxima linha do arquivo texto.                          �
	//�����������������������������������������������������������������������
	nBtLidos := fRead(nHdl, @cBuffer, nTamLin) // Leitura da proxima linha do arquivo texto.
	_nRecNo ++
EndDo

//���������������������������������������������������������������������Ŀ
//� O arquivo texto deve ser fechado, bem como o dialogo criado na fun- �
//� cao anterior.                                                       �
//�����������������������������������������������������������������������
fClose(nHdl)
Close(oLeTxt)
Return