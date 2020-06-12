#INCLUDE "rwmake.ch"
#include "_FixSX.ch"
User Function DESCRIPTAR()       

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//Programa  ณ Descripta         ณ  Autor ณ Andy      บ Data ณ  18/09/03 ณ 
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

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
_cArq2 := _cAux+".DDD"
                  


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
	Processa({|| _nRet := DCri()}, _cMsg)
Endif

// Fecha o arquivo criptografado e o arquivo de saida.
fClose(_nArq1); fClose(_nArq2)

// Fecha a DLL.
ExecInDllClose(_nDll1)

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
Static Function DCri()
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
    fWrite(_nArq2, _cBufNor + _EOL , len(_cBufNor))		
	_nBtLidos := fRead(_nArq1, @_cBuffCrip, _nTamLin)
EndDo
Return 