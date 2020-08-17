#Include 'Rwmake.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ C100VLAT ºAutor  ³ Sergio Oliveira    º Data ³  Ago/2010   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Ponto de entrada que permitira a alteracao de contratos vi-º±±
±±ºDescricao ³ tentes caso o usuario logado tenha controle total sobre o  º±±
±±º          ³ contrato.                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU - Procurement                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function C100VLAT()

Local lRet     := .t.
Local aAreaAnt := GetArea(), aAreaCNN := CNN->( GetArea() )
Local cMens    := "Alteracao de Contratos Vigentes"
Local cPriLin  := "Se deseja realmente efetuar esta operação, "
Local cTxtBlq  := ""

If ParamIxb[1] == '05' .And. CN9->CN9_SITUAC $ "05" .And. CNN->( DbSetOrder(1), DbSeek( xFilial('CNN')+__cUserId+CN9->CN9_NUMERO ) ) .And. ;
                                     CNN->CNN_TRACOD == '001'

	cTxtBlq := "Este contrato esta vigente. Você possui controle total sobre o mesmo. "
	cTxtBlq += "Se você prosseguir com esta atualização, um LOG será gerado automaticamente para posterior auditoria. "
	
	If Aviso("Alteracao do Contrato",cTxtBlq,{"&DESISTIR","Continuar"},3,"Contrato Vigente",,"PCOLOCK") == 2
		lRet := .t.
	Else
		Aviso("Operação nao Confirmada","Ação não Confirmada!",{"&Fechar"},3,"Nao Confirmado",,"PCOLOCK")
	EndIf
	
	If lRet
		If !U_CodSegur(cMens, cPriLin)
			Aviso(cMens,"Operação nao Confirmada",{"&Fechar"},3,"Nao Confirmado",,"PCOLOCK")
			lRet := .f.
		EndIf
	EndIf

EndIf

CNN->( RestArea( aAreaCNN ) )

RestArea( aAreaAnt )

Return( lRet )