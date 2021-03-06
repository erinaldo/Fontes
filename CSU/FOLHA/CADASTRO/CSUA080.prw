#include "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSUA070   � Autor � TANIA BRONZERI     � Data � 26/01/2009  ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de Categoria de Fun��oes                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico CSU para Relatorio Head-Count - uso na SRJ.     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function CSUA080()
Local aArea	:= GetArea()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
       
Private cCadastro	:= OemToAnsi("Cadastro de Categorias de Fun��o")

Private aRotina := { 	{ "Pesquisar"  ,"AxPesqui",		0	,1 } ,;
             			{ "Visualizar" ,"AxVisual",		0	,2 } ,;
            			{ "Incluir"    ,"AxInclui",		0	,3 } ,;
             			{ "Excluir"    ,"U_Csux080Del",	0	,5 } }

dbSelectArea("PA8")
mBrowse( 6,1,22,75,"PA8")

RestArea(aArea)

Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Csux080Del�Autor  �Tania Bronzeri      � Data � 26/01/2009  ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para Exclusao                                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especif. CSU - Pre-Demissao - Categorias de Funcao.        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Csux080Del()
Local uRet 
Local cAlias 	:= "PA8"  
Local nReg		:= 0

dbSelectArea("PA8")
dbSetOrder(1)
nReg			:= ( cAlias )->( Recno() )
                      
If (ChkDelRegs("PA8"))
	RecLock("PA8",.F.)
	uRet := AxDeleta( cAlias , nReg , 5 , NIL , NIL , NIL , NIL , NIL , .T. )
	MSUnlock()
Endif

Return Nil


