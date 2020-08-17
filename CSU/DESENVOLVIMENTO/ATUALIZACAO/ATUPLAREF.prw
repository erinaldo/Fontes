#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ATUPLAREF � Autor � Renato Carlos      � Data �  26/04/2010 ���
�������������������������������������������������������������������������͹��
���Descricao � Atualiza o campo CT1_PLAREF com a conta referencial        ���
���          � atrelada, caso exista.                                     ���
�������������������������������������������������������������������������͹��
���Parametros�                                         ���
���          �                                        ���
���          �                                        ���
�������������������������������������������������������������������������͹��
���Uso       � CSU CardSystem S.A                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ATUPLAREF()

Processa( { || ProcAtu() }, 'Efetuando carga CT1.....' )

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ProcAtu   � Autor � Renato Carlos      � Data �  26/04/2010 ���
�������������������������������������������������������������������������͹��
���Descricao � Atualiza o campo CT1_PLAREF com a conta referencial        ���
���          � atrelada, caso exista.                                     ���
�������������������������������������������������������������������������͹��
���Parametros�                                         ���
���          �                                        ���
���          �                                        ���
�������������������������������������������������������������������������͹��
���Uso       � CSU CardSystem S.A                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ProcAtu()

Local nCont := 0

DbSelectArea ("CVN") // Tabela plano de contas referencial
DbSetOrder(2)   

DbSelectArea ("CVD") // Tabela plano de contas referencial x Plano de contas
DbSetOrder(1)        // Filial + conta            

DbSelectArea ("CT1") // Tabela plano de contas 
DbSetOrder(1)        //filial + conta
DbGotop()


ProcRegua(CT1->(RecCount()))

While !CT1->(EOF())

	IncProc("Processando Atualiza��o...")
	
	If CVD->(DbSeek(xFilial("CT1")+CT1->CT1_CONTA))
		RecLock("CT1",.F.)
		CT1->CT1_PLAREF := CVD->CVD_CTAREF
		CT1->(MsUnLock())
		nCont++
		
		If CVN->(DbSeek(xFilial("CT1")+CVD->CVD_CODPLA+CVD->CVD_CTAREF))
			RecLock("CT1",.F.)
			CT1->CT1_DESCPR := CVN->CVN_DSCCTA
			CT1->(MsUnLock())	
		EndIf
    EndIf
    CT1->(DbSkip())
EndDo

MsgAlert("Registros atualizados:"+Str(nCont),"Aten��o")

Return()