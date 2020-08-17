#Include 'Protheus.ch'
#INCLUDE "Topconn.ch"

//-----------------------------------------------------------------------------
// Ponto de entrada desenvolvido para validar na classificação da pre-nota a
// existência de análise de amostra informada.
// Sempre que houver análise de amostra solicitada na solicitação de compras e
// o respectivo item da pre-nota não tiver o resultado dessa analise, será 
// impredida a classificação do documento.
//-----------------------------------------------------------------------------

User Function MT100TOK()
Local lRetorno	:= PARAMIXB[1]
Local aAreaAtu 	:= GetArea() 
Local aSA5			:= SA5->(GetArea())
Local nPANARES 	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_XANARES"})
Local nPANARE2 	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_XANARE2"})
Local nPMOTREJ 	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_XMOTREJ"})
Local nPMOTRJ2 	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_XMOTRJ2"})
Local nPCod 		:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_COD"})
Local nPItem	 	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_ITEM"})
Local nPPedido 	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_PEDIDO"})
Local nPItemPC 	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_ITEMPC"})
Local nPWFE01 	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_XWFE01"})
Local nPWFE02 	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_XWFE02"})
Local cSD1_Fil	:= ""
Local cSD1_DOC	:= ""
Local cSD1_SERIE	:= ""
Local cSD1_FORNE	:= ""
Local cSD1_LOJA	:= ""
Local cSD1_Cod	:= ""
Local cSD1_Item 	:= ""
Local cSD1_PED 	:= ""
Local cSD1_IPC 	:= ""
Local cSD1_XARES	:= ""
Local cSD1_XARE2	:= ""
Local cSD1_XMREJ	:= ""
Local cSD1_XMRJ2	:= ""
Local nX			:= 0
Local nLinhas		:= 0
Local lDeleted	:= .T.
Local lAviso		:= .F.
///--------------------------------------------------
/// Campos específicos da Analise de Amostra
///--------------------------------------------------
/// D1_XANAPRZ / D/8 - Prazo Analis 
/// D1_XANARES / C/1 - Analise Rej 
/// D1_XMOTREJ / C/200 - Motivo Rej. 
///--------------------------------------------------

cSD1_Fil 	:= xFilial("SD1")
cSD1_DOC 	:= cNFiscal
cSD1_SERIE	:= cSerie
cSD1_FORNE	:= cA100For
cSD1_LOJA 	:= cLoja

For nX := 1 to Len(aCols)
	///-------------------------------------------------------------------------
	/// Verifica se a linha não está excluída
	///-------------------------------------------------------------------------
	lDeleted	:= .T.
	If ValType(aCols[nX,Len(aCols[nX])]) == "L"
		lDeleted := aCols[nX,Len(aCols[nX])]     
	EndIf
	///-------------------------------------------------------------------------
	If !lDeleted
		///-------------------------------------------------------------------------
		nLinhas ++
		///-------------------------------------------------------------------------
		cSD1_Cod 	:= ""
		cSD1_Item 	:= ""
		If nPCod > 0
			cSD1_Cod 	:= aCols[nX,nPCod]
		EndIf
		If nPItem > 0	
			cSD1_Item 	:= aCols[nX,nPItem]
		EndIf	
		If nPPedido > 0
			cSD1_PED 	:= aCols[nX,nPPedido]
		EndIf
		If nPItemPC > 0	
			cSD1_IPC 	:= aCols[nX,nPItemPC]
		EndIf
		If nPANARES > 0
			cSD1_XARES 	:= aCols[nX,nPANARES]
		EndIf
		If nPANARE2 > 0
			cSD1_XARE2 	:= aCols[nX,nPANARE2]
		EndIf
		If nPMOTREJ > 0
			cSD1_XMREJ 	:= aCols[nX,nPMOTREJ]
		EndIf
		If nPMOTRJ2 > 0
			cSD1_XMRJ2 	:= aCols[nX,nPMOTRJ2]
		EndIf
		If nPWFE01 > 0
			cSD1_XWF01 	:= aCols[nX,nPWFE01]
		EndIf	
		If nPWFE02 > 0
			cSD1_XWF02 	:= aCols[nX,nPWFE02]
		EndIf	
		
		///-------------------------------------------------------------------------
		If nPWFE01 <= 0 .or. nPWFE02 <= 0  .or. nPMOTRJ2 <= 0  .or. nPMOTREJ <= 0  .or. nPANARES <= 0  .or. nPANARE2 <= 0     
			lRetorno := .F.
		Else
			If cSD1_XWF01 $ ("SX") .and. Empty(cSD1_XARES)
				lRetorno := .F. 
			EndIf			
			If cSD1_XWF02 $ ("SX") .and. Empty(cSD1_XARE2)
				lRetorno := .F. 
			EndIf
			If cSD1_XARES == "2" .and. cSD1_XARE2 == "2"
				lAviso := .T.
			EndIf	
		EndIf
		///-------------------------------------------------------------------------

	EndIf
Next nX

If nLinhas > 0 
	If !lRetorno
		Help(" ",1,"MT140TOK",,'Existem itens que possuem controle de amostra e que ainda não tiveram o retorno do workflow de análise !',1,0)
	Else
		If lAviso
			Help(" ",1,"MT140TOK",,'Existem itens que possuem controle de amostra e tiveram a análise rejeitada.'+CRLF+'O documento será classificado, porém deverá ser realizado o processo de devolução de compras para esses itens !',1,0)
		EndIf
	EndIf	
EndIf

RestArea( aAreaAtu )

Return( lRetorno )


