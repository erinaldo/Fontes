#Include "Protheus.ch"
#Include "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSUA060   � Autor � TANIA BRONZERI     � Data � 06/01/2009  ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de Pre-Admissao                                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico CSU para Relatorio Head-Count                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function CSUA060()
Local aArea	:= GetArea()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
       
Private cCadastro	:= OemToAnsi("Cadastro de Pr�-Admiss�o")

Private aRotina := { 	{ "Pesquisar"  ,"AxPesqui",		0	,1 } ,;
             			{ "Visualizar" ,"AxVisual",		0	,2 } ,;
            			{ "Incluir"    ,"U_Csux060Inc",	0	,3 } ,;
             			{ "Alterar"    ,"U_Csux060Alt",	0	,4 } ,;
             			{ "Excluir"    ,"U_Csux060Del",	0	,5 } }

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

dbSelectArea("PA6")
mBrowse( 6,1,22,75,"PA6")

RestArea(aArea)

Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Csux060Del�Autor  �Tania Bronzeri      � Data � 06/01/2009  ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para Exclusao                                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especif. CSU - Pre-Admissao                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Csux060Del()
Local aAreaDel	:= GetArea()
Local uRet 
Local cAlias 	:= "PA6"  
Local nReg		:= (cAlias)->( Recno() )

dbSelectArea(cAlias)
dbSetOrder(1)
                      
If (ChkDelRegs(cAlias))
	RecLock(cAlias,.F.)
	uRet := AxDeleta( cAlias , nReg , 5 , NIL , NIL , NIL , NIL , NIL , .T. )
	MSUnlock()
Endif
              
RestArea(aAreaDel)
Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Csux060Alt�Autor  �Tania Bronzeri      � Data � 09/01/2009  ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para Alteracao                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especif. CSU - Pre-Admissao                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Csux060Alt()
Local aAreaAlt	:= GetArea()
Local uRet 
Local cAlias 	:= "PA6"  
Local nReg		:= (cAlias)->( Recno()) 

dbSelectArea(cAlias)
dbSetOrder(1)
                        
If (cAlias)->PA6_INTEGR == "I"
	uRet := AxVisual( cAlias , nReg , 2 )
Else                      
	RecLock(cAlias,.F.)
	uRet := AxAltera( cAlias , nReg , 4 )
	MSUnlock()
EndIf

RestArea(aAreaAlt)
      
Return Nil         


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CsuCPFExt �Autor  �Tania Bronzeri      � Data � 18/02/2009  ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para Consistencia de existencia do CPF no cadastro. ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especif. CSU - Pre-Admissao                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CsuCPFExt()
Local aAreaCpf	:= GetArea()
Local cAlias 	:= "PA6"  

DbSelectArea(cAlias)
DbSetOrder(2)
                      
If (cAlias)->(dbSeek(M->PA6_CPF)) 
	If (cAlias)->PA6_INTEGR == "I"
		Aviso(OemToAnsi("Aten��o!"),OemToAnsi("J� existe este CPF para Funcion�rio j� Integrado no Cadastro Pr�-Admiss�o."),{OemToAnsi("OK")},,OemToAnsi("Verifique CPF!"))	
	ElseIf (cAlias)->PA6_DESIST == "S"
		Aviso(OemToAnsi("Aten��o!"),OemToAnsi("J� existe este CPF para Funcion�rio com Desist�ncia no Cadastro Pr�-Admiss�o."),{OemToAnsi("OK")},,OemToAnsi("Verifique CPF!"))	
	Else
		Aviso(OemToAnsi("Aten��o!"),OemToAnsi("J� existe este CPF para Funcion�rio no Cadastro Pr�-Admiss�o."),{OemToAnsi("OK")},,OemToAnsi("Verifique CPF!"))	
 	EndIf
Else
	DbSelectArea("SRA")
	DbSetOrder(16)
	If SRA->(dbSeek(M->PA6_CPF)) 
		If SRA->RA_SITUA == "D"
			Aviso(OemToAnsi("Aten��o!"),OemToAnsi("J� existe este CPF para Funcion�rio j� Desligado no Cadastro de Funcion�rios."),{OemToAnsi("OK")},,OemToAnsi("Verifique CPF!"))	
		Else		
			Aviso(OemToAnsi("Aten��o!"),OemToAnsi("J� existe este CPF para Funcion�rio no Cadastro de Funcion�rios."),{OemToAnsi("OK")},,OemToAnsi("Verifique CPF!"))	
		EndIf
	EndIf	
EndIf   


RestArea(aAreaCpf)
      
Return .T.


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Csux060Inc�Autor  �Tania Bronzeri      � Data � 02/03/2009  ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para Inclusao                                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especif. CSU - Pre-Admissao                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Csux060Inc(cAlias, nReg, nOpc)
Local aAreaInc	:= GetArea()
Local uRet
Default cAlias	:= "PA6"
Default nReg	:= (cAlias)->( Recno() )
Default nOpc 	:= 3

uRet := AxInclui(cAlias, nReg, nOpc, NIL, NIL, NIL, "U_VldCTBg(M->PA6_ITEMD,M->PA6_CC,M->PA6_CLVLDB)")

RestArea(aAreaInc)

Return (uRet)

