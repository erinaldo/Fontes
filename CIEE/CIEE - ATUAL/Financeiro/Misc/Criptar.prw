#INCLUDE "rwmake.ch"
#include "_FixSX.ch"
#DEFINE _EOL CHR(13) + CHR(10)

User Function CRIPTAR()
//���������������������������������������������������������������������Ŀ
//Programa  � Cripta            �  Autor � Andy      � Data �  18/09/03 � 
//�����������������������������������������������������������������������
Local _nRet := 0
Private _cArq1, _nArq1
Private _cArq2, _nArq2
Private _cDll1, _nDll1
Private cPerg        := "CRIPTA    "
_aPerg := {}
aAdd (_aPerg, {cPerg, "01", "Arquivo            ?", "Arquivo            ?", "Arquivo            ?", "mv_ch1", "C", 30, 0, 0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
AjustaSX1(_aPerg)
If !Pergunte(cPerg, .T.)
  Return
EndIf

_cDll1 := "CIEEBrad.dll"    
_cAux  := SubStr(AllTrim(MV_PAR01),1,Len(AllTrim(MV_PAR01))-4)
_cArq1 := AllTrim(MV_PAR01)
_cArq2 := _cAux+".CCC"

// Tenta abrir o arquivo texto puro.
If (_nArq1 := fOpen(_cArq1, 68)) == -1
	_cMsg := "N�o foi poss�vel abrir o arquivo " + _cArq1 +;
	"! Verifique os par�metros."
	MsgAlert(_cMsg, "Aten��o!")
	_nRet -= 1
Endif

// Tenta abrir a DLL que faz o tratamento do arquivo texto.
If (_nDll1 := ExecInDllOpen(_cDll1)) == -1
	_cMsg := "N�o foi poss�vel abrir o arquivo " + _cDll1 + "."
	MsgAlert(_cMsg, "Aten��o!")
	_nRet -= 1     	
Endif

// Tenta criar o arquivo de saida (a ser criptografado).
If (_nArq2 := fCreate(_cArq2)) == -1
	_cMsg := "N�o foi poss�vel criar o arquivo de sa�da " + _cArq2 + "."
	MsgAlert(_cMsg, "Aten��o!")
	_nRet -= 1
Endif

//���������������������������������������������������������������������Ŀ
//� Inicializa a regua de processamento                                 �
//�����������������������������������������������������������������������
If _nRet == 0
	_cMsg := "Aguarde. Criptografando o arquivo de remessa..."
	Processa({|| _nRet := CriCri()}, _cMsg)
Endif

// Fecha a DLL.
ExecInDllClose(_nDll1)

// Fecha o arquivo texto e o arquivo de saida.
fClose(_nArq1); fClose(_nArq2)

// Se todos os processos ocorreram bem,
If _nRet == 0 
	_cMsg := "O arquivo " + _cArq1 + " n�o p�de ser apagado!!!"
	MsgAlert(_cMsg, "Aten��o!!!")
	_nRet -= 1
Endif

Return(_nRet)


Static Function CriCri()

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis.                                            �
//�����������������������������������������������������������������������
Local _nTamLin, _nTamArq, _nBtLidos, _nBtPos
Local _cBufNor, _cBuffCrip, _nDLLRun                                             

_cBuffCrip := space(500)

_nBtPos  := 0
_nTamLin := 502  // 4 Kb - Tamanho da linha.
_nTamArq := fSeek(_nArq1, 0, 2) // Tamanho do arquivo.
_cBufNor := Space(_nTamLin)

//���������������������������������������������������������������������Ŀ
//� Configura a regua de progressao.                                    �
//�����������������������������������������������������������������������
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
			_cMsg := "O tamanho do texto a ser criptografado � inv�lido!" + _EOL +;
			"O sistema ir� abandonar o processamento."
			MsgAlert(_cMsg, "Aten��o")
			Return
			
		Case _nDLLRun == -2
			_cMsg := "Erro no processamento da criptografia do arquivo." + _EOL +;
			"O sistema ir� abandonar o processamento."
			MsgAlert(_cMsg, "Aten��o")
			Return
	EndCase
    fWrite(_nArq2, _cBuffCrip, len(_cBuffCrip)) 	
	_nBtLidos := fRead(_nArq1, @_cBufNor, _nTamLin)
EndDo

Return 