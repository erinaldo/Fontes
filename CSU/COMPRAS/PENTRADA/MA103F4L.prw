#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออหออออออัออออออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณMA103F4LบAutor ณ Renato Carlos          บ Data ณ 11/05/2012 บฑฑ
ฑฑฬออออออออออุออออออออสออออออฯออออออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada para manipulacao dos registros da selecao บฑฑ
ฑฑบ		     ณ de pedidos no documento de entrada                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MA103F4L

Local _aPedidos := PARAMIXB[1]
Local _aRecnos  := PARAMIXB[2]
Local _cQuery   := ""
Local _AreaAnt  := GetArea()
Local _lFound   := .F.
Local _aNewPeds := {}
Local _aOldPeds := {}

DbSelectArea("SC7")
DbSetOrder(1)

For nX := 1 To Len(_aRecnos)
   SC7->(DbGoto(_aRecnos[nX]))
   If !Empty(SC7->C7_X_NFGP)
   	  _lFound := .T.
   	  Exit		  	
   EndIf
Next

If _lFound
	
	For nX := 1 To Len(_aPedidos)
   		SC7->(DbSeek(xFilial("SC7")+_aPedidos[nX][3]))
   		If !Empty(SC7->C7_X_NFGP)
   	  	   //	If Substr(SC7->C7_X_NFGP,1,9) == cNfiscal
   	  	   	If Alltrim(SC7->C7_X_NFGP) == Alltrim(cNfiscal)+Alltrim(cSerie)+Alltrim(cEspecie)
   	  			AADD(_aNewPeds,_aPedidos[nX])
   	  			AADD(_aNewPeds[Len(_aNewPeds)],Substr(SC7->C7_X_NFGP,1,9))
   	  			//aDel(_aPedidos,nX)
   	  		EndIf
   	  	Else
   	  		//If Substr(SC7->C7_X_NFGP,1,9) != cNfiscal
   	  		If Alltrim(SC7->C7_X_NFGP) == Alltrim(cNfiscal)+Alltrim(cSerie)+Alltrim(cEspecie)
   	  			AADD(_aOldPeds,_aPedidos[nX])
   	  			AADD(_aOldPeds[Len(_aOldPeds)],"")
   	  			//aDel(_aPedidos,nX)
   	  		EndIf
   	  	EndIf	
	Next
	If Len(_aNewPeds) > 0
		aF4For := aClone(_aNewPeds)
	Else
		aF4For := aClone(_aOldPeds)
	EndIf	

EndIf       

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Chama function para selecao dos Pedidos de Compra      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
MA103F4L()

RestArea(_AreaAnt)

Return()
         
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ MA103F4L ณ Autor ณ     Eduardo Dias      ณ Data ณ 18.09.14 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Opcao para "Marcar Todos PC" quando selecionado <F5> na    ณฑฑ
ฑฑณ          ณ Tela de importacao de Pedidos de Compra do   MATA103       ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ       
ฑฑณSintaxe   ณ MA103F4L()                                                 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ MATA103                                                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿                                        
/*/
Static Function MA103F4L()
                                                    
Local nX		:= 0         
Local lMarca	:= .F.

lMarca := MsgYesNo("Deseja carregar todos os pedidos selecionados?", "Sele็ใo de PC")

If lMarca
	For nX := 1 to Len(aF4For)
		aF4For[nX][1] := .T.	
	Next nX
EndIf

Return    