#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "TOPCONN.CH"          
#define ENTER Chr(13)+Chr(10)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�� Funcao: CSCOMA08 	Autor: Tatiana A. Barbosa	Data: 21/10/10	       ��
�����������������������������������������������������������������������������
��	Descricao: Cadastro dos usuarios que dever�o preencher o motivo da     �� 
�� 				exclus�o de documentos de entrada - OS 2313/10			   ��
�����������������������������������������������������������������������������
��				Uso:  CSU CardSystem S.A								   ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CSCOMA08()

/*����������������������������������������������������������������������������Ŀ
  �              Declara as Variaveis Utilizadas na Rotina                     �
  ������������������������������������������������������������������������������*/

Local   cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local   cVldExc := ".T." // Validacao para permitir a exclusao . Pode-se utilizar ExecBlock.
Private cString := "SZQ" // Nome da Tabela a ser utilizada no AxCadastro

/*�����������������������������������������������������������������������������������������������Ŀ
  �            Abre a Tabela de Cadastro do usu�rio que ter� que detalhar a exclusao do documento �
  �������������������������������������������������������������������������������������������������*/

DbSelectArea("SZQ")
DbSetOrder(1)	        // Filial + Usuario

/*����������������������������������������������������������������������������Ŀ
  �          Chama a Funcao AxCadastro para Manipulacao do Arquivo             �
  ������������������������������������������������������������������������������*/

AxCadastro(cString , "Usuario X Excl. Docto Entrada" , cVldExc , cVldAlt )

Return()                                           
