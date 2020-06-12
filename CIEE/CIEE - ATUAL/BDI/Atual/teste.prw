#include "Rwmake.ch"
#include "TOPCONN.CH"
#Include "Protheus.Ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CBDIA08  � Autor � EMERSON NATALI     � Data �  27/09/2006 ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de Eventos                                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico CIEE - SIGAESP (BDI)                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function teste()
/*
Private cCadastro, aRotina

aRotina   	:=	{}
cCadastro 	:=	"Cadastro de Eventos"
aRotina  	:=	{ 	{"Pesquisar"	,"AxPesqui"		,0,1},;
					{"Visualisar"	,"AxVisual()"	,0,2},;
					{"Incluir"		,"AxInclui()"	,0,3},;
					{"Alterar"    	,"AxAltera()"	,0,4},;
					{"Excluir"		,"AxDeleta()"	,0,5}}

mBrowse(6,1,22,74,"SZ0",,,,,,)
*/

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZ0"

dbSelectArea("SZ0")
dbSetOrder(1)

AxCadastro(cString,"Validacao",cVldExc,cVldAlt)

Return