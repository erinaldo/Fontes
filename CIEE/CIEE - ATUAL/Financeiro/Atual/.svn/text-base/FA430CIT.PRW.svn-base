#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFA430CIT  บ Autor ณ Felipe & Andy      บ Data ณ  18/08/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบPonto de  ณ Programa: FINA430 - Recepcao do arquivo cnab de retorno do บฑฑ
ฑฑบEntrada   ณ contas a pagar.                                            บฑฑ
ฑฑบ          ณ Eh executado no inicio do processamento, antes do arquivo  บฑฑ
ฑฑบ          ณ ter sido aberto.                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ Desfaz a criptografia do arquivo do cnab a pagar de retor- บฑฑ
ฑฑบ          ณ no para que possa ser processado pelo sistema.             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nenhum.                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nenhum.                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบObs.      ณ O arquivo descriptografado tem de ser apagado apos o procesบฑฑ
ฑฑบ          ณ samento para que nenhuma pessoa nao autorizada possa ter   บฑฑ
ฑฑบ          ณ acesso a dados restritos da empresa. Para isso deve ser u- บฑฑ
ฑฑบ          ณ tilizado algum ponto de entrada no final do processamento  บฑฑ
ฑฑบ          ณ para tal finalidade.                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE.                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/


User Function F430CIT()       
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _nRet := 0
Private _cArq1, _nArq1
Private _cArq2, _nArq2
Private _cDll1, _nDll1

_cDll1 := "CIEEBrad.dll"    
_cAux  := SubStr(AllTrim(MV_PAR03),1,Len(AllTrim(MV_PAR03))-4)
_cArq1 := AllTrim(MV_PAR03) // "\TEMP\ArqCri.TXT"
_cArq2 := _cAux+".TXT"

// Tenta abrir o arquivo texto puro.
If (_nArq1 := fOpen(_cArq1, 68)) == -1
	_cMsg := "Nใo foi possํvel abrir o arquivo " + _cArq1 + "! Verifique os parโmetros."
	MsgAlert(_cMsg, "Aten็ใo!")
	_nRet -= 1
Endif

// Tenta abrir a DLL que faz o tratamento do arquivo texto.
If (_nDll1 := ExecInDllOpen(_cDll1)) == -1
	_cMsg := "Nใo foi possํvel abrir o arquivo " + _cDll1 + "."
	MsgAlert(_cMsg, "Aten็ใo!")
	_nRet -= 1
Endif

// Tenta criar o arquivo de saida (a ser descriptografado).
If (_nArq2 := fCreate(_cArq2)) == -1
	_cMsg := "Nใo foi possํvel criar o arquivo de saํda " + _cArq2 + "."
	MsgAlert(_cMsg, "Aten็ใo!")
	_nRet -= 1
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicializa a regua de processamento                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If _nRet == 0
	_cMsg := "Aguarde. Descriptografando o arquivo de retorno..."
	Processa({|| _nRet := DeCripta()}, _cMsg)
Endif

// Fecha a DLL.
ExecInDllClose(_nDll1)
                   
// Fecha o arquivo texto e o arquivo de saida.
fClose(_nArq1); fClose(_nArq2)

// Se todos os processos ocorreram bem,
// apaga o arquivo texto original.

fErase(_cArq1)
fRename(_cArq2,_cArq1)

Return(_nRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDECRIPTA  บ Autor ณ Felipe Raposo      บ Data ณ  28/02/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Desfaz a criptografia do arquivo ja aberto.                บฑฑ
ฑฑบ          ณ Funcao auxiliar para a geracao da regua de progressao.     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE.                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function DeCripta()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _nTamLin, _nTamArq, _nBtLidos
Local _cBufNor, _cBuffCrip, _nDLLRun
Private _EOL := chr(13) + chr(10)


_nTamLin   := 502  
_nTamArq   := fSeek(_nArq1, 0, 2)  
_cBuffCrip := Space(_nTamLin)

ProcRegua(_nTamArq / _nTamLin) 

fSeek(_nArq1, 0, 0)  
_nBtLidos := fRead(_nArq1, @_cBuffCrip, _nTamLin) 
_lPrim := .T.
Do While _nBtLidos != 0 
	
	IncProc()
    _cBufNor  := _cBuffCrip
	_cBufNulo := ""
	If _lPrim 
	    _nDLLRun := ExeDllRun3(_nDll1, 0, @_cBufNulo,len(_cBufNulo))  
   	    _cBuffCrip := _cBufNor                                                      
   	    _nDLLRun := ExeDllRun3(_nDll1, 2, @_cBufNor,len(_cBufNor))                  
	    _lPrim := .F.
    Else
	    _nDLLRun := ExeDllRun3(_nDll1, 2, @_cBufNor,len(_cBufNor))                  
	EndIf
	
	Do Case
		Case _nDLLRun == -1
			_cMsg := "O tamanho do texto a ser descriptografado ้ invแlido!" + _EOL +;
			"O sistema irแ abandonar o processamento."
			MsgAlert(_cMsg, "Aten็ใo")
			Return
			
		Case _nDLLRun == -2
			_cMsg := "Erro no processamento da descriptografia do arquivo." + _EOL +;
			"O sistema irแ abandonar o processamento."
			MsgAlert(_cMsg, "Aten็ใo")
			Return
	EndCase
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Grava a string decriptografada no arquivo de saida.                 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//If fWrite(_nArq2, _cBufNor, len(_cBufNor)) != len(_cBufNor)
    //	If fWrite(_nArq2, _cBufNor + _EOL , len(_cBufNor)) != len(_cBufNor)
    //		MsgAlert("Ocorreu um erro na grava็ใo do arquivo.", "Aten็ใo!")
    //		Return -1
    //	Endif
    fWrite(_nArq2, _cBufNor + _EOL , len(_cBufNor))		
	
	// Leitura da proxima linha do arquivo texto.
	_nBtLidos := fRead(_nArq1, @_cBuffCrip, _nTamLin)
EndDo
Return 