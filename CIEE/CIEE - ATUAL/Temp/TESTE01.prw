#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA430CIT  � Autor � Felipe Raposo      � Data �  28/02/03   ���
�������������������������������������������������������������������������͹��
���Ponto de  � Programa: FINA430 - Recepcao do arquivo cnab de retorno do ���
���Entrada   � contas a pagar.                                            ���
���          � Eh executado no inicio do processamento, antes do arquivo  ���
���          � ter sido aberto.                                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Descricao � Desfaz a criptografia do arquivo do cnab a pagar de retor- ���
���          � no para que possa ser processado pelo sistema.             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Parametros� Nenhum.                                                    ���
�������������������������������������������������������������������������͹��
���Retorno   � Nenhum.                                                    ���
�������������������������������������������������������������������������͹��
���Obs.      � O arquivo decriptografado tem de ser apagado apos o proces-���
���          � samento para que nenhuma pessoa nao autorizada possa ter   ���
���          � acesso a dados restritos da empresa. Para isso deve ser u- ���
���          � tilizado algum ponto de entrada no final do processamento  ���
���          � para tal finalidade.                                       ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE.                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function TESTE01()

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis.                                            �
//�����������������������������������������������������������������������
Local _nRet := 0
Private _cArq1, _nArq1
Private _cArq2, _nArq2
Private _cDll1, _nDll1

_cDll1 := "CIEEBrad.dll" // "Bradesco2Microsiga.dll"   
_cArq1 := "\TEMP\Arq.crp"
_cArq2 := "\TEMP\ArqFim.TXT"

// Tenta abrir o arquivo texto puro.
If (_nArq1 := fOpen(_cArq1, 68)) == -1
	_cMsg := "N�o foi poss�vel abrir o arquivo " + _cArq1 + "! Verifique os par�metros."
	MsgAlert(_cMsg, "Aten��o!")
	_nRet -= 1
Endif

// Tenta abrir a DLL que faz o tratamento do arquivo texto.
If (_nDll1 := ExecInDllOpen(_cDll1)) == -1
	_cMsg := "N�o foi poss�vel abrir o arquivo " + _cDll1 + "."
	MsgAlert(_cMsg, "Aten��o!")
	_nRet -= 1
Endif

// Tenta criar o arquivo de saida (a ser decriptografado).
If (_nArq2 := fCreate(_cArq2)) == -1
	_cMsg := "N�o foi poss�vel criar o arquivo de sa�da " + _cArq2 + "."
	MsgAlert(_cMsg, "Aten��o!")
	_nRet -= 1
Endif

//���������������������������������������������������������������������Ŀ
//� Inicializa a regua de processamento                                 �
//�����������������������������������������������������������������������
If _nRet == 0
	_cMsg := "Aguarde. Decriptografando o arquivo de retorno..."
	Processa({|| _nRet := DeCripta()}, _cMsg)
Endif

// Fecha o arquivo criptografado e o arquivo de saida.
fClose(_nArq1); fClose(_nArq2)

// Fecha a DLL.
ExecInDllClose(_nDll1)

Return(_nRet)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DECRIPTA  � Autor � Felipe Raposo      � Data �  28/02/03   ���
�������������������������������������������������������������������������͹��
���Desc.     � Desfaz a criptografia do arquivo ja aberto.                ���
���          � Funcao auxiliar para a geracao da regua de progressao.     ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE.                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function DeCripta()

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis.                                            �
//�����������������������������������������������������������������������
Local _nTamLin, _nTamArq, _nBtLidos
Local _cBufNor, _cBuffCrip, _nDLLRun

_nTamLin   := 4096  // 4 Kb - Tamanho da linha.
_nTamArq   := fSeek(_nArq1, 0, 2)  // Tamanho do arquivo.
_cBuffCrip := Space(_nTamLin)

//���������������������������������������������������������������������Ŀ
//� Configura a regua de progressao.                                    �
//�����������������������������������������������������������������������
ProcRegua(_nTamArq / _nTamLin)  // Numero de registros a processar

fSeek(_nArq1, 0, 0)  // Posiciona no primeiro caractere do arquivo.
_nBtLidos := fRead(_nArq1, @_cBuffCrip, _nTamLin)  // Le a primeira linha.
Do While _nBtLidos != 0  // Enquanto nao for fim de arquivo.
	
	//���������������������������������������������������������������������Ŀ
	//� Incrementa a regua.                                                 �
	//�����������������������������������������������������������������������
	IncProc()
	
	// Utiliza a DLL para desfazer a criptografia.
	_cBufNor := _cBuffCrip
	_nDLLRun := ExeDllRun2(_nDll1, 2, @_cBufNor)
	//_cBufNor := ExecInDllRun(_nDll, 2, _cBuffCrip)
	
	Do Case
		Case _nDLLRun == -1
			_cMsg := "O tamanho do texto a ser decriptografado � inv�lido!" + _EOL +;
			"O sistema ir� abandonar o processamento."
			MsgAlert(_cMsg, "Aten��o")
			Return
			
		Case _nDLLRun == -2
			_cMsg := "Erro no processamento da decriptografia do arquivo." + _EOL +;
			"O sistema ir� abandonar o processamento."
			MsgAlert(_cMsg, "Aten��o")
			Return
	EndCase
	
	//���������������������������������������������������������������������Ŀ
	//� Grava a string decriptografada no arquivo de saida.                 �
	//�����������������������������������������������������������������������
	If fWrite(_nArq2, _cBufNor, len(_cBufNor)) != len(_cBufNor)
		MsgAlert("Ocorreu um erro na grava��o do arquivo.", "Aten��o!")
		Return -1
	Endif
	
	// Leitura da proxima linha do arquivo texto.
	_nBtLidos := fRead(_nArq1, @_cBuffCrip, _nTamLin)
EndDo
Return 0