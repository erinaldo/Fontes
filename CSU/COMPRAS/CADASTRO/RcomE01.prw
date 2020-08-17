#Include 'Rwmake.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RcomE01  �Autor  � Sergio Oliveira    � Data �  Abr/2009   ���
�������������������������������������������������������������������������͹��
���Descricao � Validacao do campo AK_APROSUP no cadastro de aprovadores   ���
���          � para que o aprovador superior nao seja igual ao aprovador. ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RcomE01()

Local lPassa  := .t.
Local aAreaAn := GetArea()
Local aAreaSK := SAK->( GetArea() )

	If !Empty( M->AK_APROSUP )
		If SAK->( DbSetOrder(1), DbSeek( xFilial("SAK")+M->AK_APROSUP ) )
			If SAK->AK_USER == M->AK_USER
				Aviso("SUPERIOR INVALIDO","O aprovador superior n�o poder� ser igual ao pr�prio aprovador.",;
				{"&Fechar"},3,"Superior Igual ao Aprovador",,;
				"PCOLOCK")
				lPassa := .f.
			EndIf
		EndIf
	EndIf

SAK->( RestArea( aAreaSK ) )
RestArea( aAreaAn )

Return( lPassa )