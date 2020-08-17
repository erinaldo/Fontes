#Include 'Rwmake.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � M110Exit �Autor  � Sergio Oliveira    � Data �  Mai/2008   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada ao clicar no botao "abandonar" na Solici- ���
���          � tacao de Compras. Esta sendo utilizado para deletar a re-  ���
���          � ferencia da aprovacao CAPEX caso o usuario tenha optado em ���
���          � grava-la antes de abandonar a SC.                          ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function M110EXIT()

Local aArea := GetArea(), aAreaSC1 := SC1->( GetArea() )
Local cExec

If SC1->( DbSetOrder(1), !DbSeek( xFilial('SC1')+cA110Num ) ) .And.;
   ZA8->( DbSetOrder(1), DbSeek(xFilial('SC1')+"SC"+cA110Num) )
   
   cExec := " DELETE FROM "+RetSqlName('ZA8')
   cExec += " WHERE ZA8_FILIAL = '"+xFilial('ZA8')+"' "
   cExec += " AND   ZA8_TIPO   = 'SC' "
   cExec += " AND   ZA8_DOC    = '"+cA110Num+"' "
   
   TcSqlExec( cExec )
   
EndIf

If SC1->( DbSetOrder(1), !DbSeek( xFilial('SC1')+cA110Num ) ) .And.;
   ZA8->( DbSetOrder(1), DbSeek(xFilial('SC1')+"PR"+cA110Num) )
   
   cExec := " DELETE FROM "+RetSqlName('ZA8')
   cExec += " WHERE ZA8_FILIAL = '"+xFilial('ZA8')+"' "
   cExec += " AND   ZA8_TIPO   = 'PR' "
   cExec += " AND   ZA8_DOC    = '"+cA110Num+"' "
   
   TcSqlExec( cExec )
   
EndIf

SC1->( RestArea( aAreaSC1 ) )

RestArea( aArea )

Return