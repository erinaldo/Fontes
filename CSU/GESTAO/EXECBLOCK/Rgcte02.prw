#Include 'Rwmake.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Rgcte02   �Autor  � Sergio Oliveira    � Data �  Ago/2008   ���
�������������������������������������������������������������������������͹��
���Desc.     �Execblock acionado atraves do campo CN9_X_FORN no campo     ���
���          �X3_INIBRW. Serve para obter o primeiro fornecedor da rela-  ���
���          �cao de fornecedores no folder "Fornecedores".               ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function Rgcte02()

Local aArea   := GetArea()
Local cNomFor := ""
  
If CNC->( DbSetOrder(1), DbSeek( xFilial('CNC')+CN9->CN9_NUMERO ) )

   If SA2->( DbSetOrder(1), DbSeek( xFilial("SA2")+CNC->(CNC_CODIGO+CNC_LOJA) ) )
      cNomFor := SA2->A2_NOME
   EndIf

EndIf

RestArea( aArea )

Return( cNomFor )