#INCLUDE 'PROTHEUS.CH'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � FTMSREL  �Autor  � Ernani Forastieri  � Data �  08/05/06	  ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada para definir relacionamento para a utili  ���
���          � zacao do banco de conhecimento                             ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE - Protheus 8                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FTMSREL()      
Return { { 'PA1', { 'PA1_IMAGEM' }, { || ' ' } } ,;
{ 'PA2', { 'PA2_IMAGEM' }, { || ' ' } } }