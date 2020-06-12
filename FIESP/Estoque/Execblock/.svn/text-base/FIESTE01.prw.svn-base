#Include "Protheus.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FIESTE01  ºAutor  ³Microsiga           º Data ³  08/13/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gravacao e Envio para a Aprovacao a SA                     º±±
±±º          ³ chamado atraves do ponto de entrada MT105FIM               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FIESTE01()
Local cDoc	  := SCP->CP_NUM      
Local nPTot   := aScan(aHeader,{|x| AllTrim(x[2])=="CP_XVLRTOT"})    
Local nPItem  := aScan(aHeader,{|x| AllTrim(x[2])=="CP_ITEM"})     
Local _nTot   := 0
Local nY
Local lEstorna := .T.             
Local _xArea := GetArea()
                                                                    
For nY := 1 to Len(aCols)	
	If !(GdDeleted( nY, aHeader, aCols))

		dbSelectArea("SCP")
		
		If INCLUI .or. ALTERA
			SCP->(dbSeek(xFilial("SCR")+cA105Num+aCols[nY][nPItem]))
			RecLock("SCP",.F.)
			SCP->CP_CC 		:= _c105CCusto
			SCP->CP_STATSA 	:= "E"
			SCP->CP_XAPROV 	:= _c105GrpApr
			SCP->CP_ITEMCTA	:= _c105ItemCt

			DbSelectArea("SZC")
			SZC->(DbSetOrder(1))
			If SZC->(DbSeek(xFilial("SZC")+_c105ItemCt))
				SCP->CP_CONTA	:= SZC->ZC_CONTA
			EndIf
			RestArea(_xArea)

			SCP->(MsUnlock())
		ENDIF                    
						
		_nTot += aCols[nY][nPTot]
	Endif
Next nY
                                                                                    
SCR->(dbSetOrder(1))

// Se gerou SCR, estorna.
If !INCLUI                                           
	IF SCR->(dbSeek(xFilial("SCR")+"SA"+cDoc))
   		If ALTERA
			IF SCR->CR_TOTAL >= _nTot
				lEstorna := .F.
			Endif		   				   
	   	Endif
		If lEstorna
			MaAlcDoc({cDoc,"SA",_nTot,,,,,1,0,},SCP->CP_EMISSAO,3)
		Else
			//Atualiza valor da alcada
			While SCR->(!Eof()) .and. SCR->CR_FILIAL == XFilial("SCR") .and. Alltrim(SCR->CR_NUM) == Alltrim(cDoc) .and. SCR->CR_TIPO == "SA"	       
                RecLock("SCR",.F.)
                SCR->CR_TOTAL := _nTot
                SCR->(msUnlock())
				SCR->(dbSkip())
			Enddo			
		Endif
		_cStatus := _fVerifSA(cDoc) // Verificar se estava aprovado
	    // altera flag 
		For nY := 1 to Len(aCols)	
			If !(GdDeleted( nY, aHeader, aCols))
				IF SCP->(dbSeek(xFilial("SCR")+cA105Num+aCols[nY][nPItem]))
					RecLock("SCP",.F.)
					SCP->CP_STATSA := _cStatus
					SCP->(MsUnlock())			
				EndIf
			Endif
 		Next nY				
	EndIf     
Endif

If INCLUI .or. ALTERA
	// Gravar Alcada SCR                                
	IF !SCR->(dbSeek(xFilial("SCR")+"SA"+cDoc))
		MaAlcDoc({cDoc,"SA",_nTot,,,_c105GrpApr,,1,1,SCP->CP_EMISSAO},,1) 
	Endif				
Endif
                            
Return     
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FIESTE01  ºAutor  ³Microsiga           º Data ³  03/27/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica status da SA                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _fVerifSA(cDoc)
Local _cRet := "E"

SCR->(dbSetOrder(1))
SCR->(dbSeek(xFilial("SCR")+"SA"+cDoc))
While SCR->(!Eof()) .and. SCR->CR_FILIAL == XFilial("SCR") .and. SCR->CR_TIPO == "SA" .and. Alltrim(SCR->CR_NUM) == Alltrim(cDoc)
	If (SCR->CR_STATUS $ ("03|05")) // aprovado
		_cRet := "L"
	ElseIf SCR->CR_STATUS == "04" // reprovado
		_cRet := "B"
	ElseIf SCR->CR_STATUS == "02" // em aprovacao
		_cRet := "E"
	EndIf
	SCR->(dbSkip())
Enddo

Return(_cRet)