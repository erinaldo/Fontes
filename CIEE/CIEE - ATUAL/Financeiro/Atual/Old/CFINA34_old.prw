#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFINA34     � Autor � CLAUDIO BARROS   � Data �  05/05/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro especifico CIEE para controle das contas correntes���
���          � dos fornecedores.                                          ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAFIN - CIEE                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CFINA34()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cCadastro := "Cadastro de Contas Correntes Fornecedores"
Private aCores     := {}
aCores := {;
{'ZK_STATUS == I'    , "BR_VERMELHO" },;  // INATIVO
{'ZK_STATUS == A'    , "BR_VERDE"  }}	 // ATIVO

//���������������������������������������������������������������������Ŀ
//� Array (tambem deve ser aRotina sempre) com as definicoes das opcoes �
//� que apareceram disponiveis para o usuario. Segue o padrao:          �
//� aRotina := { {<DESCRICAO>,<ROTINA>,0,<TIPO>},;                      �
//�              {<DESCRICAO>,<ROTINA>,0,<TIPO>},;                      �
//�              . . .                                                  �
//�              {<DESCRICAO>,<ROTINA>,0,<TIPO>} }                      �
//� Onde: <DESCRICAO> - Descricao da opcao do menu                      �
//�       <ROTINA>    - Rotina a ser executada. Deve estar entre aspas  �
//�                     duplas e pode ser uma das funcoes pre-definidas �
//�                     do sistema (AXPESQUI,AXVISUAL,AXINCLUI,AXALTERA �
//�                     e AXDELETA) ou a chamada de um EXECBLOCK.       �
//�                     Obs.: Se utilizar a funcao AXDELETA, deve-se de-�
//�                     clarar uma variavel chamada CDELFUNC contendo   �
//�                     uma expressao logica que define se o usuario po-�
//�                     dera ou nao excluir o registro, por exemplo:    �
//�                     cDelFunc := 'ExecBlock("TESTE")'  ou            �
//�                     cDelFunc := ".T."                               �
//�                     Note que ao se utilizar chamada de EXECBLOCKs,  �
//�                     as aspas simples devem estar SEMPRE por fora da �
//�                     sintaxe.                                        �
//�       <TIPO>      - Identifica o tipo de rotina que sera executada. �
//�                     Por exemplo, 1 identifica que sera uma rotina de�
//�                     pesquisa, portando alteracoes nao podem ser efe-�
//�                     tuadas. 3 indica que a rotina e de inclusao, por�
//�                     tanto, a rotina sera chamada continuamente ao   �
//�                     final do processamento, ate o pressionamento de �
//�                     <ESC>. Geralmente ao se usar uma chamada de     �
//�                     EXECBLOCK, usa-se o tipo 4, de alteracao.       �
//�����������������������������������������������������������������������

//���������������������������������������������������������������������Ŀ
//� aRotina padrao. Utilizando a declaracao a seguir, a execucao da     �
//� MBROWSE sera identica a da AXCADASTRO:                              �
//�                                                                     �
//� cDelFunc  := ".T."                                                  �
//� aRotina   := { { "Pesquisar"    ,"AxPesqui" , 0, 1},;               �
//�                { "Visualizar"   ,"AxVisual" , 0, 2},;               �
//�                { "Incluir"      ,"AxInclui" , 0, 3},;               �
//�                { "Alterar"      ,"AxAltera" , 0, 4},;               �
//�                { "Excluir"      ,"AxDeleta" , 0, 5} }               �
//�                                                                     �
//�����������������������������������������������������������������������


//���������������������������������������������������������������������Ŀ
//� Monta um aRotina proprio                                            �
//�����������������������������������������������������������������������

Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual"       ,0,2} ,;
             {"Incluir","AxInclui"          ,0,3} ,;
             {"Alterar","AxAltera"          ,0,4} ,;
             {"Excluir","AxDeleta"          ,0,5,},;
             {"Legenda",'u_SZKLegend()'     ,0,2,} }

//Private cDelFunc := "DelCfina34()" // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cDelFunc := "u_DelCfina34()" // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "SZK"

dbSelectArea("SZK")
dbSetOrder(1)
SZK->(DbGotop())

//���������������������������������������������������������������������Ŀ
//� Executa a funcao MBROWSE. Sintaxe:                                  �
//�                                                                     �
//� mBrowse(<nLin1,nCol1,nLin2,nCol2,Alias,aCampos,cCampo)              �
//� Onde: nLin1,...nCol2 - Coordenadas dos cantos aonde o browse sera   �
//�                        exibido. Para seguir o padrao da AXCADASTRO  �
//�                        use sempre 6,1,22,75 (o que nao impede de    �
//�                        criar o browse no lugar desejado da tela).   �
//�                        Obs.: Na versao Windows, o browse sera exibi-�
//�                        do sempre na janela ativa. Caso nenhuma este-�
//�                        ja ativa no momento, o browse sera exibido na�
//�                        janela do proprio SIGAADV.                   �
//� Alias                - Alias do arquivo a ser "Browseado".          �
//� aCampos              - Array multidimensional com os campos a serem �
//�                        exibidos no browse. Se nao informado, os cam-�
//�                        pos serao obtidos do dicionario de dados.    �
//�                        E util para o uso com arquivos de trabalho.  �
//�                        Segue o padrao:                              �
//�                        aCampos := { {<CAMPO>,<DESCRICAO>},;         �
//�                                     {<CAMPO>,<DESCRICAO>},;         �
//�                                     . . .                           �
//�                                     {<CAMPO>,<DESCRICAO>} }         �
//�                        Como por exemplo:                            �
//�                        aCampos := { {"TRB_DATA","Data  "},;         �
//�                                     {"TRB_COD" ,"Codigo"} }         �
//� cCampo               - Nome de um campo (entre aspas) que sera usado�
//�                        como "flag". Se o campo estiver vazio, o re- �
//�                        gistro ficara de uma cor no browse, senao fi-�
//�                        cara de outra cor.                           �
//�����������������������������������������������������������������������

mBrowse(6,1,22,75,"SZK",,'ZK_STATUS == "I"')

        
Return
           


//Static Function DelCfina34()
User Function DelCfina34()


Local lRet := .T.
Local cQuery := " "


cQuery := " SELECT E2_FORNECE FROM "+RetSqlName("SE2")+" "
cQuery += " WHERE D_E_L_E_T_ = ' ' AND E2_CTAFOR <> ' ' AND (E2_CTAFOR = '"+SZK->ZK_NUMCON+"' "
cQuery += " OR E2_CTAFOR = '"+SZK->ZK_NROPOP+"' OR E2_CTAFOR = '"+SZK->ZK_NROCRT+"') "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRV",.T.,.T.)

DbSelectArea("TRV")

IF !EMPTY(TRV->E2_FORNECE)
   MsgAlert("Nao � Possivel Excluir,Conta Corrente j� Movimentada!!!")
   lRet := .F.
ENDIF

If Select("TRV") > 0
   TRV->(DbCloseArea())
Endif   

     
Return(lRet)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SZKLEGEND �Autor  �Cristiano Giardini  � Data �  24/04/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para exibicao da Legenda                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/       

User Function SZKLegend()
Local aCores := {;
{"BR_VERDE"     , "Ativo"     },;
{"BR_VERMELHO"  , "Inativo"     } }

BrwLegenda( cCadastro, "Legenda", aCores ) //"Legenda"

Return NIL  
