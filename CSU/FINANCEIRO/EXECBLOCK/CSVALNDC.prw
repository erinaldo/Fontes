#INCLUDE "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSVALNDC  � Autor � Renato Carlos      � Data �  20/03/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Valida��o especifica CSU para nao permitir a inclusao      ���
���          � de titulos tipo NDC com naturezas fora do paramentro       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CSVALNDC(_cTipo,_cNatNDC,nTpChama)

Local _cTipoTit := Alltrim(_cTipo)
Local _cNatTit  := Alltrim(_cNatNDC)
Local _nChama   := nTpChama
Local _cNatNdc  := GetMV("CS_NATNDC")
Local _cMsg     := ""
Local _cMsg1    := " A natureza informada n�o pode ser utilizada para titulos NDC, favor selecionar uma natureza v�lida!"
Local _cMsg2    := " O tipo informado n�o pode ser utilizado para naturezas de NDC, favor selecionar o tipo NDC!"
Local _cMsg3    := " O tipo NDC s� pode ser informado para naturezas de NDC, favor selecionar outro tipo!"
Local _cMsg4    := " A natureza informada s� pode ser utilizada para titulos NDC, favor selecionar uma natureza v�lida!"
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

