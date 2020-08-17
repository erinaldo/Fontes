#include "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSUA070   � Autor � TANIA BRONZERI     � Data � 07/01/2009  ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de Pre-Demissao                                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico CSU para Relatorio Head-Count                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function CSUA070()
Local aArea	:= GetArea()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
       
Private cCadastro	:= OemToAnsi("Cadastro de Pr�-Demiss�o")

Private aRotina := { 	{ "Pesquisar"  ,"AxPesqui",		0	,1 } ,;
             			{ "Visualizar" ,"AxVisual",		0	,2 } ,;
            			{ "Incluir"    ,"AxInclui",		0	,3 } ,;
             			{ "Excluir"    ,"U_Csux070Del",	0	,5 } }

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

dbSelectArea("PA7")
mBrowse( 6,1,22,75,"PA7")

RestArea(aArea)

Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Csux070Del�Autor  �Tania Bronzeri      � Data � 07/01/2009  ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para Exclusao                                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especif. CSU - Pre-Demissao                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Csux070Del()
Local uRet 
Local cAlias 	:= "PA7"  
Local nReg		:= 0

dbSelectArea("PA7")
dbSetOrder(1)
nReg			:= ( cAlias )->( Recno() )
                      
If (ChkDelRegs("PA7"))
	RecLock("PA7",.F.)
	uRet := AxDeleta( cAlias , nReg , 5 , NIL , NIL , NIL , NIL , NIL , .T. )
	MSUnlock()
Endif

Return Nil


/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������ͻ��
���Programa  � fValidFunc   �Autor  �Tania Bronzeri      � Data � 20/02/2009  ���
�����������������������������������������������������������������������������͹��
���Desc.     � Rotina de Validacao da Situacao do Funcionario.                ���
���          �                                                                ���
�����������������������������������������������������������������������������͹��
���Uso       � Especif. CSU - Pre-Demissao                                    ���
�����������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/
User Function fValidFunc()
Local aAreaFunc	:= GetArea()
Local lRet		:= .T.

dbSelectArea("SRA")
IF SRA->(dbSeek(xFilial("SRA")+M->PA7_MAT))
	If SRA->RA_SITFOLH = "D"
		Aviso(OemToAnsi("Aten��o!"),OemToAnsi("Cadastramento de Demiss�o para Funcion�rio j� Demitido."),;
			 {OemToAnsi("OK")},,OemToAnsi("Matr�cula Inv�lida"))	
		lRet	:=	.F.
	EndIf
    EndIf
                       
RestArea(aAreaFunc)

Return lRet


/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������ͻ��
���Programa  � fValidDemiss �Autor  �Tania Bronzeri      � Data � 20/02/2009  ���
�����������������������������������������������������������������������������͹��
���Desc.     � Rotina de Validacao da Data de Previsao de Demissao.           ���
���          �                                                                ���
�����������������������������������������������������������������������������͹��
���Uso       � Especif. CSU - Pre-Demissao                                    ���
�����������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/
User Function fValidDemiss()
Local aAreaDemis	:= GetArea()
Local lRet			:= .T.

If M->PA7_DEMISS <= dDataBase
	Aviso(OemToAnsi("Aten��o!"),OemToAnsi("Data Prevista para Demiss�o deve ser Futura."),;
		 {OemToAnsi("OK")},,OemToAnsi("Data Inv�lida"))	
	lRet	:=	.F.
Else
	dbSelectArea("SRA")
	IF SRA->(dbSeek(xFilial("SRA")+M->PA7_MAT))
		If M->PA7_DEMISS <= SRA->RA_ADMISSA
			Aviso(OemToAnsi("Aten��o!"),OemToAnsi("Data Prevista para Demiss�o deve ser Posterior � Admiss�o.")	,;
				 {OemToAnsi("OK")},,OemToAnsi("Data Inv�lida"))	
			lRet	:=	.F.
		EndIf
    EndIf
EndIf
                       
RestArea(aAreaDemis)

Return lRet


