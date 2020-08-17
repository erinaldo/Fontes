#INCLUDE "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCSVALNDC  บ Autor ณ Renato Carlos      บ Data ณ  20/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Valida็ใo especifica CSU para nao permitir a inclusao      บฑฑ
ฑฑบ          ณ de titulos tipo NDC com naturezas fora do paramentro       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CSVALNDC(_cTipo,_cNatNDC,nTpChama)

Local _cTipoTit := Alltrim(_cTipo)
Local _cNatTit  := Alltrim(_cNatNDC)
Local _nChama   := nTpChama
Local _cNatNdc  := GetMV("CS_NATNDC")
Local _cMsg     := ""
Local _cMsg1    := " A natureza informada nใo pode ser utilizada para titulos NDC, favor selecionar uma natureza vแlida!"
Local _cMsg2    := " O tipo informado nใo pode ser utilizado para naturezas de NDC, favor selecionar o tipo NDC!"
Local _cMsg3    := " O tipo NDC s๓ pode ser informado para naturezas de NDC, favor selecionar outro tipo!"
Local _cMsg4    := " A natureza informada s๓ pode ser utilizada para titulos NDC, favor selecionar uma natureza vแlida!"
Local _lRet     := .T.

If _cTipoTit == "NDC"
	If IIF(_nChama == 1,!Empty(_cTipoTit),!Empty(_cNatTit)) 
		If !(_cNatTit $ _cNatNdc)
			_lRet := .F.
		EndIf
	EndIf
Else
	If IIF(_nChama == 1,!Empty(_cTipoTit),!Empty(_cNatTit)) 
		If _cNatTit $ _cNatNdc
			_lRet := .F.
		Endif
	EndIf	 	
EndIf 

If !_lRet
	IIF(_nChama == 1,IIf(_cNatTit $ _cNatNdc,_cMsg := _cMsg4,_cMsg := _cMsg1),IIf(_cNatTit $ _cNatNdc,_cMsg := _cMsg2,_cMsg := _cMsg3))
	Aviso("NDC",_cMsg,;
		{"&Fechar"},3,"Titulos de NDC",,;
		"PCOLOCK")
EndIf		

Return(_lRet)

