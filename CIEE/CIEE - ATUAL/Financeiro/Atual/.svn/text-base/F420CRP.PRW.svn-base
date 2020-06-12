#INCLUDE "rwmake.ch"
#DEFINE _EOL CHR(13) + CHR(10)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF420CRP   บ Autor ณ Felipe Raposo      บ Data ณ  28/02/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบPonto de  ณ Programa: FINA420 - Geracao do arquivo cnab de envio do    บฑฑ
ฑฑบEntrada   ณ contas a pagar.                                            บฑฑ
ฑฑบ          ณ Eh executado no final do processamento, apos a gravacao do บฑฑ
ฑฑบ          ณ arquivo em disco.                                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ Criptografa o arquivo do cnab a pagar apos a sua geracao e บฑฑ
ฑฑบ          ณ apaga o arquivo original para que nenhuma pessoa nao auto- บฑฑ
ฑฑบ          ณ rizada possa ter acesso a dados restritos da empresa.      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nenhum.                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nenhum.                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบObs.      ณ Nenhum.                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE.                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function F420CRP()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _nRet := 0
Private _cArq1, _nArq1
Private _cArq2, _nArq2
Private _cDll1, _nDll1
/*
_cDll1 := "CIEEBrad.dll"
_cArq1 := "\TEMP\ArqEnt.TXT"
_cArq2 := "\TEMP\ArqCri.TXT"
*/
_cDll1 := "CIEEBrad.dll"
_cAux  := AllTrim(MV_PAR04)
_cArq1 := _cAux+".REM"
_cArq2 := _cAux+".CRI"

// Tenta abrir o arquivo texto puro.
If (_nArq1 := fOpe	(_cArq1, 68)) == -1
	_cMsg := "Nใo foi possํvel abrir o arquivo " + _cArq1 +;
	"! Verifique os parโmetros."
	MsgAlert(_cMsg, "Aten็ใo!")
	_nRet -= 1
Endif

// Tenta abrir a DLL que faz o tratamento do arquivo texto.
If (_nDll1 := ExecInDllOpen(_cDll1)) == -1
	_cMsg := "Nใo foi possํvel abrir o arquivo " + _cDll1 + "."
	MsgAlert(_cMsg, "Aten็ใo!")
	_nRet -= 1
Endif

// Tenta criar o arquivo de saida (a ser criptografado).
If (_nArq2 := fCreate(_cArq2)) == -1
	_cMsg := "Nใo foi possํvel criar o arquivo de saํda " + _cArq2 + "."
	MsgAlert(_cMsg, "Aten็ใo!")
	_nRet -= 1
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicializa a regua de processamento                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If _nRet == 0
	_cMsg := "Aguarde. Criptografando o arquivo de remessa..."
	Processa({|| _nRet := Cripta()}, _cMsg)
Endif

// Fecha a DLL.
ExecInDllClose(_nDll1)

// Fecha o arquivo texto e o arquivo de saida.

fClose(_nArq1)

fClose(_nArq2)

// Se todos os processos ocorreram bem,
// apaga o arquivo texto original.

//fRename(_cArq1,_cAux+".TXT")

fErase(_cArq1)

fRename(_cArq2,_cArq1)

Return(_nRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCRIPTA    บ Autor ณ Felipe Raposo      บ Data ณ  28/02/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Faz a criptografia do arquivo texto ja aberto.             บฑฑ
ฑฑบ          ณ Funcao auxiliar para a geracao da regua de progressao.     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE.                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Cripta()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _nTamLin, _nTamArq, _nBtLidos, _nBtPos
Local _cBufNor, _cBuffCrip, _nDLLRun

_cBuffCrip := space(500)

_nBtPos  := 0
_nTamLin := 502  // 4 Kb - Tamanho da linha.
_nTamArq := fSeek(_nArq1, 0, 2) // Tamanho do arquivo.
_cBufNor := Space(_nTamLin)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Configura a regua de progressao.                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ProcRegua(_nTamArq / _nTamLin)  // Numero de linhas a processar.

fSeek(_nArq1, 0, 0)  // Posiciona no primeiro caractere do arquivo.
_nBtLidos := fRead(_nArq1, @_cBufNor, _nTamLin)  // Le a primeira linha.


_lPrim := .T.
Do While _nBtLidos != 0
	
	_nBtPos += _nBtLidos
	IncProc("Processando: " + AllTrim(Transform(_nBtPos/1024, tm(_nBtPos/1024, 14))) +;
	"KB de " + AllTrim(Transform(_nTamArq/1024, tm(_nTamArq/1024, 14))) + "KB")
	
	_cBuffCrip := _cBufNor
	_cBuffNulo := ""
	If _lPrim
		_nDLLRun   := ExeDllRun3(_nDll1, 0, @_cBuffNulo,len(_cBuffNulo))
		_cBuffCrip := _cBufNor
		_nDLLRun   := ExeDllRun3(_nDll1, 1, @_cBuffCrip,len(_cBuffCrip))
		_lPrim     := .F.
	Else
		_nDLLRun   := ExeDllRun3(_nDll1, 1, @_cBuffCrip,len(_cBuffCrip))
	EndIf
	
	Do Case
		Case _nDLLRun == -1
			_cMsg := "O tamanho do texto a ser criptografado ้ invแlido!" + _EOL +;
			"O sistema irแ abandonar o processamento."
			MsgAlert(_cMsg, "Aten็ใo")
			Return
			
		Case _nDLLRun == -2
			_cMsg := "Erro no processamento da criptografia do arquivo." + _EOL +;
			"O sistema irแ abandonar o processamento."
			MsgAlert(_cMsg, "Aten็ใo")
			Return
	EndCase
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Grava a string criptografada no arquivo de saida.                   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//	If fWrite(_nArq2, _cBuffCrip, len(_cBuffCrip)) != len(_cBuffCrip)
	//		MsgAlert("Ocorreu um erro na grava็ใo do arquivo.", "Aten็ใo!")
	//		Return -1
	//	Endif

	fWrite(_nArq2, _cBuffCrip, len(_cBuffCrip))	
	_nBtLidos := fRead(_nArq1, @_cBufNor, _nTamLin)
EndDo

Return 
