#Include 'Rwmake.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Mt110When �Autor  � Sergio Oliveira    � Data �  Out/2008   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para permitir a digitacao da filial de    ���
���          � entrega na Solicitacao de Compras.                         ���
���          � Em Maio/2008 a TOTVS criou este ponto de entrada em funcao ���
���          � de este campo ter sido fechado atraves da build anterior   ���
���          � a Maio/2008. Sendo assim, este ponto de entrada passou a   ���
���          � ser utilizado para permitir a digitacao levando em conta o ���
���          � modo de compartilhamento da tabela SC7.                    ���
���          � O campo C1_FILENT sofreu alteracao no X3_RELACAO para ini- ���
���          � cializar com a filial posicionada.                         ���
�������������������������������������������������������������������������͹��
���Uso       � CSU - Campo Filial de Entrega(SC1).                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT110WHEN()

Return( .t. )