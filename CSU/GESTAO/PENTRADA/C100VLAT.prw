#Include 'Rwmake.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � C100VLAT �Autor  � Sergio Oliveira    � Data �  Ago/2010   ���
�������������������������������������������������������������������������͹��
���          � Ponto de entrada que permitira a alteracao de contratos vi-���
���Descricao � tentes caso o usuario logado tenha controle total sobre o  ���
���          � contrato.                                                  ���
�������������������������������������������������������������������������͹��
���Uso       � CSU - Procurement                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function C100VLAT()

Local lRet     := .t.
Local aAreaAnt := GetArea(), aAreaCNN := CNN->( GetArea() )
Local cMens    := "Alteracao de Contratos Vigentes"
Local cPriLin  := "Se deseja realmente efetuar esta opera��o, "
Local cTxtBlq  := ""

If ParamIxb[1] == '05' .And. CN9->CN9_SITUAC $ "05" .And. CNN->( DbSetOrder(1), DbSeek( xFilial('CNN')+__cUserId+CN9->CN9_NUMERO ) ) .And. ;
                                     CNN->CNN_TRACOD == '001'

	cTxtBlq := "Este contrato esta vigente. Voc� possui controle total sobre o mesmo. "
	cTxtBlq += "Se voc� prosseguir com esta atualiza��o, um LOG ser� gerado automaticamente para posterior auditoria. "
	
	If Aviso("Alteracao do Contrato",cTxtBlq,{"&DESISTIR","Continuar"},3,"Contrato Vigente",,"PCOLOCK") == 2
		lRet := .t.
	Else
		Aviso("Opera��o nao Confirmada","A��o n�o Confirmada!",{"&Fechar"},3,"Nao Confirmado",,"PCOLOCK")
	EndIf
	
	If lRet
		If !U_CodSegur(cMens, cPriLin)
			Aviso(cMens,"Opera��o nao Confirmada",{"&Fechar"},3,"Nao Confirmado",,"PCOLOCK")
			lRet := .f.
		EndIf
	EndIf

EndIf

CNN->( RestArea( aAreaCNN ) )

RestArea( aAreaAnt )

Return( lRet )