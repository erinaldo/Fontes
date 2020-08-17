#Include 'Rwmake.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT120F    �Autor  � Sergio Oliveira    � Data �  Jan/2009   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada apos a gravacao do pedido de compras antes���
���          � do fechamento da transacao. Esta sendo utilizado para gra- ���
���          � var a data do vencimento do pedido de compras quando este  ���
���          � estiver sendo gerado por alguem da area de procurement.    ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT120F()

Local _aArea := GetArea(), _aAreaSY1 := SY1->( Getarea() ), _aAreaSC7 := SC7->( Getarea() )

If SY1->( DbSetOrder(3), DbSeek( xFilial('SY1')+__cUserId ) )

   SC7->( DbSetOrder(1), DbSeek( ParamIxb ) )

   While !SC7->( Eof() ) .And. SC7->( C7_FILIAL+C7_NUM ) == ParamIxb
   
         SC7->( RecLock('SC7',.f.) )
         SC7->C7_X_DVENC := Condicao(10,SC7->C7_COND,,SC7->C7_EMISSAO)[1][1]
         SC7->( MsUnLock() )
   
         SC7->( DbSkip() )
   
   EndDo

EndIf

_dVencto := Nil // Destruir a variavel somente por seguranca.

SY1->( RestArea( _aAreaSY1 ) )
SC7->( RestArea( _aAreaSC7 ) )
RestArea( _aArea )

Return