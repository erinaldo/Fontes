#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ GCPA200()  ³Autor³ José Carlos	 ³ Data ³ 03/07/2015      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Seleciona apenas o fornecedor exclusivo na amarração       ³±±
±±³          ³ Produto x Fornecedor 									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Funcao    ³ PE MVC					                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
*/

/*
	ESPECIFICO PROCESSOS COMPRAS PUBLICAS
	EDITAL 
*/

User Function PROCA030()
Local aParam     := PARAMIXB
Local lRet       := .T.
Local oObj       := ''
Local cIdPonto   := ''
Local cIdModel   := ''
Local oGrid
Local nX		 := 0
Local nY		 := 0 
Local nLicitante := 0   
Local lExclusi	 := .F.
Local cCodProduto:= ''
Local cCodFor	 := ''
Local cCodLoja	 := ''
Local cCodExclusi:= ''
Local aLicitante := {}
Local oModProd 	 := Nil
Local oModLic 	 := Nil  

Local aSaveLines:= FWSaveRows()

If aParam <> NIL

	oObj       := aParam[1]
	
	cIdPonto   := aParam[2]
	
	cIdModel   := aParam[3]
	
	If cIdPonto == 'MODELPOS'  
        
		DbSelectArea("SA5") 
		SA5->(Dbgotop())
		SA5->(DbSetOrder(1))	//A5_FILIAL+A5_FORNECE+A5_LOJA+A5_PRODUTO+A5_FABR+A5_FALOJA
	
		oModProd 	:= oObj:GetModel("CO2DETAIL")	//Produtos
		oModLic 	:= oObj:GetModel("CO3DETAIL") 	//Licitantes  
		
		For nY := 1 to oModProd:Length()
			oModProd:GoLine(nY)
			If !(oModProd:IsDeleted()) 	// Linha não deletada
				cCodProduto	:= FwFldGet('CO2_CODPRO')  
				nLicitante 	:= 0   
				lExclusi	:= .F.
				//Alert( 'oCO2Detail Produto: ' + cCodProduto )	
				For nX := 1 To oModLic:Length()
					oModLic:GoLine( nX )
					If !(oModLic:IsDeleted()) 	// Linha não deletada
						cCodFor := FwFldGet('CO3_CODIGO')
						cCodLoja:= FwFldGet('CO3_LOJA') 
						nLicitante ++
						//Alert( 'oCO3Detail Fornecedor: ' + cCodFor + ' Loja: ' + cCodLoja )
						// Verificar se o produto existe amarracao e se eh exclusivo.
						SA5->(DbSetOrder(2))	//A5_FILIAL+A5_PRODUTO+A5_FORNECE+A5_LOJA
						If SA5->(DbSeek(xFilial("SA5")+cCodProduto))    
							//Alert('Exclusivo: ' + SA5->A5_XEXCLUS)
							If SA5->A5_XEXCLUS == 'S'
								lExclusi := .T.
								cCodExclusi := SA5->A5_FORNECE +'/'+ SA5->A5_LOJA
							EndIf	 
						EndIf
						AADD(aLicitante,cCodFor +'/'+ cCodLoja)
					EndIf	
				Next nX
				
				If lExclusi 
					If nLicitante > 1 .Or. Ascan(aLicitante,{|z| z == cCodExclusi }) == 0
						Help(" ",1,"GCPA200_PE",,'Produto exclusivo ['+cCodProduto+'] para o fornecedor ['+cCodExclusi+']' + CRLF + CRLF +'Selecione o fornecedor ['+cCodExclusi+']',1,0)
						lRet := .F.
						Exit
					EndIf
				EndIF
			EndIf
		Next nY
		
	EndIf              

EndIf

FWRestRows( aSaveLines )

Return lRet