#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � VAGPEA02 � Autor � Adilson Silva      � Data � 04/06/2011  ���
�������������������������������������������������������������������������͹��
���Descricao � Tabela do Vale Alimentacao.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP8 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function VAGPEA02

 Private cCadastro := "Vale Alimenta��o"
 Private cDelFunc  := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
 Private cString   := "ZT8"

 Private aRotina := { { "Pesquisar"    , "AxPesqui"      ,0 , 1 } ,;
                      { "Visualizar"   , "AxVisual"      ,0 , 2 } ,;
                      { "Incluir"      , "AxInclui"      ,0 , 3 } ,;
                      { "Alterar"      , "AxAltera"      ,0 , 4 } ,;
                      { "Excluir"      , "AxDeleta"      ,0 , 5 } }

 dbSelectArea( "ZT8" )
 dbSetOrder(1)

 mBrowse( 6,1,22,75,cString)

Return
