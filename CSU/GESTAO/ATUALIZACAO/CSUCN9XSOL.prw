#Include "rwmake.ch"

/*
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Program   � CSUCN9XSOL � Autor � Douglas David          � Data � 16/05/2016 ���
������������������������������������������������������������������������������Ĵ��
���Descri��o � Cadastro de uauriarios x solicitacoes de compras                ���
������������������������������������������������������������������������������Ĵ��
���Sintaxe   � U_CSUCN9XSOL( )                                                 ���
������������������������������������������������������������������������������Ĵ��
���Aplicacao � Gestao de contratos - CSU                                       ���
������������������������������������������������������������������������������Ĵ��
���Uso       � CSU                                                             ���
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
*/

User Function CSUCN9XSOL()
Local _aArea := GetArea()

cCadastro := "Usuarios x Solicitacoes Compras"

AxCadastro("CN9",cCadastro,".F.",".T.")

RestArea( _aArea )

Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSUCN9NOME� Autor � Douglas David      � Data �  16/05/15   ���
�������������������������������������������������������������������������͹��
���Descricao � FUN��O QUE DEVOLVE O NOME DO USUARIO CONFORME O USERID     ���
���          �			                                     			  ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CSUCN9NOME()
Local _aArea     := GetArea()
Local _cRetnome
Local _aRetUser

PswOrder(2)
If PswSeek(M->CN9_X_SOLI,.T.)                     // Efetuo a pesquisa, definindo se pesquiso usu�rio ou grupo
	_aRetUser := PswRet(1)                   	  // Obtenho o resultado conforme vetor
	_cRetnome := Upper(_aRetUser[1][4])       	  // Nome Completo do Usuario
Else
	_cRetnome := M->CN9_X_NSOL
EndIf

RestArea( _aArea )

Return( _cRetnome )             
                     

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSUCN9VL  � Autor � Douglas David      � Data �  16/05/15   ���
�������������������������������������������������������������������������͹��
���Descricao � VALIDA��O PARA CADASTRO USU�RIOS							  ���
���          �                                    			 			  ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CSUCN9VL()
Local _aArea     := GetArea()
Local _cRetnome
Local _aRetUser
Local lRet := .T.

PswOrder(2)
If PswSeek(M->CN9_X_SOLI,.T.)                     // Efetuo a pesquisa, definindo se pesquiso usu�rio ou grupo
	_aRetUser := PswRet(1)                    	 // Obtenho o resultado conforme vetor
Else
	Aviso("Aten��o", "Usu�rio n�o existe, por favor verificar!", {"Voltar"})
	lRet := .F.
EndIf

RestArea( _aArea )

Return(lRet) 
