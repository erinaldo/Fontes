#INCLUDE "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � BNGPEP01 � Autor � Adilson Silva      � Data � 09/06/2011  ���
�������������������������������������������������������������������������͹��
���Descricao � Locais de Entrega dos Beneficios - Beneficios VT - VR - VA ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP10                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function BNGPEP01

 Private cCadastro := "Locais de Entrega de Benef�cios"
 Private cDelFunc  := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

 Private aRotina := { { "Pesquisar"    , "AxPesqui"      ,0 , 1 } ,;
                      { "Visualizar"   , "AxVisual"      ,0 , 2 } ,;
                      { "Incluir"      , "AxInclui"      ,0 , 3 } ,;
                      { "Alterar"      , "AxAltera"      ,0 , 4 } ,;
                      { "Excluir"      , "AxDeleta"      ,0 , 5 } }

 dbSelectArea( "ZTD" )
 dbSetOrder( 1 )

 mBrowse( 6,1,22,75,"ZTD" )

Return
