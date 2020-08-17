#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "TOPCONN.CH"          
#define ENTER Chr(13)+Chr(10)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�� Funcao: CSATF01  	Autor: Tatiana A. Barbosa	Data: 24/02/12	       ��
�����������������������������������������������������������������������������
��	Descricao: Cadastro das unidades de negocio para vinculo com o 	       �� 
�� 				ativo fixo - OS 0322/12			   						   ��
�����������������������������������������������������������������������������
��				Uso:  CSU CardSystem S.A								   ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CSATF01()

/*����������������������������������������������������������������������������Ŀ
  �              Declara as Variaveis Utilizadas na Rotina                     �
  ������������������������������������������������������������������������������*/

Local   cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local   cVldExc := ".T." // Validacao para permitir a exclusao . Pode-se utilizar ExecBlock.
Private cString := "ZBB" // Nome da Tabela a ser utilizada no AxCadastro

/*�����������������������������������������������������������������������������������������������Ŀ
  �            Abre a Tabela de Cadastro do usu�rio que ter� que detalhar a exclusao do documento �
  �������������������������������������������������������������������������������������������������*/

DbSelectArea("ZBB")
DbSetOrder(1)	        

/*����������������������������������������������������������������������������Ŀ
  �          Chama a Funcao AxCadastro para Manipulacao do Arquivo             �
  ������������������������������������������������������������������������������*/

AxCadastro(cString , "Unidade de Negocio para Ativo Fixo" , cVldExc , cVldAlt )

Return()                                           
