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

User Function RFinA02a()

/*����������������������������������������������������������������������������Ŀ
  �              Declara as Variaveis Utilizadas na Rotina                     �
  ������������������������������������������������������������������������������*/

Local   cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local   cVldExc := ".T." // Validacao para permitir a exclusao . Pode-se utilizar ExecBlock.
Private cString := "SZI" // Nome da Tabela a ser utilizada no AxCadastro

/*����������������������������������������������������������������������������Ŀ
  �            Abre a Tabela de Amarracao Fornecedor x Natureza                �
  ������������������������������������������������������������������������������*/

DbSelectArea("SZI")
DbSetOrder(1)	        // Filial + Usuario + Centro de Custo

/*����������������������������������������������������������������������������Ŀ
  �          Chama a Funcao AxCadastro para Manipulacao do Arquivo             �
  ������������������������������������������������������������������������������*/

AxCadastro(cString , "Cadastro de Usuarios x Centro de Custo" , cVldExc , cVldAlt )

Return()