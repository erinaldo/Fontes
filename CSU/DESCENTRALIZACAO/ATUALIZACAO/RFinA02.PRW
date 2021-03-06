#Include "RwMake.ch"

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  � RFinA02  � Autor � Ricardo Beraldo     � Data � 06/07/2006  ���
��������������������������������������������������������������������������͹��
���Descricao � Cadastro de Amarracao entre Usuarios x Centro de Custo      ���
��������������������������������������������������������������������������͹��
���Uso       � CSU CardSystem S.A                                          ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/

User Function RFinA02()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cCadastro := "Cadastro de Usuarios x Centro de Custo"
//���������������������������������������������������������������������Ŀ
//� Monta um aRotina proprio                                            �
//�����������������������������������������������������������������������

Private aRotina := menudef()
//{ {"Pesquisar","AxPesqui",0,1} ,;
//             {"Visualizar","AxVisual",0,2} ,;
//             {"Incl/Alter/Excl","U_CsFina01()",0,3} }

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "SZI"

dbSelectArea("SZI")
dbSetOrder(1)

dbSelectArea(cString)
mBrowse( 6,1,22,75,cString)

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MenuDEF  � Autor �Eduardo de Souza    � Data �12/Jan/2007  ���
�������������������������������������������������������������������������͹��
���Descricao � Implementa menu funcional                                  ���
�������������������������������������������������������������������������͹��
���Uso       � Menus                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//��������������������������������������������������������������Ŀ
//� Define Array contendo as Rotinas a executar do programa      �
//� ----------- Elementos contidos por dimensao ------------     �
//� 1. Nome a aparecer no cabecalho                              �
//� 2. Nome da Rotina associada                                  �
//� 3. Usado pela rotina                                         �
//� 4. Tipo de Transa��o a ser efetuada                          �
//�    1 - Pesquisa e Posiciona em um Banco de Dados             �
//�    2 - Simplesmente Mostra os Campos                         �
//�    3 - Inclui registros no Bancos de Dados                   �
//�    4 - Altera o registro corrente                            �
//�    5 - Remove o registro corrente do Banco de Dados          �
//�    3 - Duplica o registro corrente do Banco de Dados         �
//����������������������������������������������������������������
Static Function MenuDef()
Local aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Incl/Alter/Excl","U_CsFina01()",0,3} }
Return aRotina
