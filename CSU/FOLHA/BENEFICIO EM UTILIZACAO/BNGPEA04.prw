#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � BNGPEA04 � Autor � Adilson Silva      � Data � 09/06/2011  ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de Fornecedores.                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP10                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function BNGPEA04()

 Private cCadastro := "Cadastro de Fornecedores"
 Private cDelFunc  := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

 Private aRotina := { { "Pesquisar"    , "AxPesqui"      ,0 , 1 } ,;
                      { "Visualizar"   , "AxVisual"      ,0 , 2 } ,;
                      { "Incluir"      , "AxInclui"      ,0 , 3 } ,;
                      { "Alterar"      , "AxAltera"      ,0 , 4 } ,;
                      { "Excluir"      , "AxDeleta"      ,0 , 5 } }

 dbSelectArea( "ZT9" )
 dbSetOrder( 1 )

 mBrowse( 6,1,22,75,"ZT9" )

Return
