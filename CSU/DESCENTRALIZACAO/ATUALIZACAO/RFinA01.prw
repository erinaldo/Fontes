#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "TOPCONN.CH"          
#define ENTER Chr(13)+Chr(10)


/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  � RFinA01  � Autor � Cristiano Figueiroa � Data � 06/07/2006  ���
��������������������������������������������������������������������������͹��
���Descricao � Cadastro de Amarracao entre Fornecedores x Naturezas        ���
��������������������������������������������������������������������������͹��
���Uso       � CSU CardSystem S.A                                          ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/

User Function RFinA01()

/*����������������������������������������������������������������������������Ŀ
  �              Declara as Variaveis Utilizadas na Rotina                     �
  ������������������������������������������������������������������������������*/

Local   cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local   cVldExc := ".T." // Validacao para permitir a exclusao . Pode-se utilizar ExecBlock.
Private cString := "SZH" // Nome da Tabela a ser utilizada no AxCadastro

/*����������������������������������������������������������������������������Ŀ
  �            Abre a Tabela de Amarracao Fornecedor x Natureza                �
  ������������������������������������������������������������������������������*/

DbSelectArea("SZH")
DbSetOrder(1)	        // Filial + Natureza + Fornecedor

/*����������������������������������������������������������������������������Ŀ
  �          Chama a Funcao AxCadastro para Manipulacao do Arquivo             �
  ������������������������������������������������������������������������������*/

AxCadastro(cString , "Amarra��o Fornecedores x Naturezas " , cVldExc , cVldAlt )

Return()                                           


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��			                                                               ��
�� Funcao: VALIDNATXFORNEC 	Autor: Tatiana A. Barbosa	Data: 26/05/10	   ��
��																		   ��
�����������������������������������������������������������������������������
��						  												   ��
��	Descricao: Valida��es de campo do cadastro de Natureza X Fornecedor    �� 
�� 				                                        				   ��  
�����������������������������������������������������������������������������
�� 																		   ��
��			Alteracoes: 											 	   ��
��																		   ��
�����������������������������������������������������������������������������
��															  			   ��
��				Uso:  CSU 	                                               ��
��												  						   ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function ValidNatXFornec()

Local lRet		:= .T.


SED->(DbSetOrder(1),DbSeek(xFilial("SED")+M->ZH_NATUREZ))

If SED->ED_MSBLQL=="1" .Or. SED->ED_TPNAT<>"A"		// naturezas sint�ticas ou bloqueadas
		Aviso( "Aten��o !" , "Verifique o cadastro da Natureza " + Alltrim(SED->ED_CODIGO) + " - " + Alltrim(SED->ED_DESCRIC) + "." + ENTER + "S� poder�o ser utilizadas naturezas Anal�ticas e Desbloqueadas", {"Ok"} , 1 , "Amarra��o Bloqueada" )
		lRet := .F. 
Endif 

                        
Return(lRet)
