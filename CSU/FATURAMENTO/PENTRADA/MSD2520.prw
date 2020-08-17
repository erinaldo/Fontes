#INCLUDE "Protheus.ch"    
#INCLUDE "TbiConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³  MSD2520   ºAutor  ³  Eduardo Dias    º Data ³  08/09/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Altera Flag do registro Calculo sobre Faturamento para 	  º±±
±±º          ³ Deletado.										          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MSD2520
Local _aArea := GetArea()     

dbSelectArea("ZV2") //ZV2_FILIAL+ZV2_NOTA+ZV2_SERIE
DbSetOrder(1)                                                                                                          

If (dbSeek(xFilial("ZV2")+SF2->F2_DOC+SF2->F2_SERIE) .And. ZV2->ZV2_FLAG != "2" .And. xFilial("SF2") == '03')

	While ZV2->(!Eof()) .And. ZV2->ZV2_NOTA == SF2->F2_DOC .And. ZV2->ZV2_SERIE == SF2->F2_SERIE
	
		RecLock("ZV2",.F.)  
		ZV2->ZV2_FLAG := "2"
		ZV2->(MsUnlock())   
		
	ZV2->(dbSkip()) 
	
	EndDo

EndIf	

//nFlag := Posicione("ZV2",1,xFilial("ZV2")+(cAliasQry)->NOTA+(cAliasQry)->SERIE, "ZV2_FLAG")
    
RestArea(_aArea)

Return(.T.)
