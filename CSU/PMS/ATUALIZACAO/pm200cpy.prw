#Include "Protheus.ch"
#include "TOPCONN.ch"

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Funcao    � pm200CPY � Autor � Douglas Coelho         � Data � 28/04/17 ���
��������������������������������������������������������������������������Ĵ��
���Descricao �Valida��o c�pia EDT/Tarefa - OS 0887/17                      ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Especifico CSU                                              ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/

User Function pm200CPY()

Local aRet := {.T. ,.T.}

PswOrder(1)
PswSeek(__cUserId)
_vDatuser:= PswRet(1)
If ascan(_vDatUser[1][10],"000162")==0 // Se o usuario nao pertence ao grupo de Administrador de Projetos, n�o permite a copia de EDT/Tarefa
	aRet := {.F. ,.F.}
	MsgAlert("C�pia n�o permitida! Favor entrar em contato com CSC!","Aten��o")
Endif

Return( aRet )
