#Include 'Rwmake.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A120F4FI  �Autor  � Sergio Oliveira    � Data �  Abr/2007   ���
�������������������������������������������������������������������������͹��
���          � Ponto de entrada no momento da atualiza��o dos Pedidos de  ���
���          � Compras. Tem como objetivo filtrar as Solicita��es de Com- ���
���Descricao � pras de acordo com o comprador logado. O mecanismo de fil- ���
���          � tro consiste em filtrar os grupos de compras relacionados  ���
���          � ao comprador. *** FILTRO POR ITEM DE SC ***                ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function A120F4FI()

Return( U_A120PIDF() )