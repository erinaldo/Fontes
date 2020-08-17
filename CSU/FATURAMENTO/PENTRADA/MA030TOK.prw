#Include "Protheus.ch" 
#Include "Rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MA030TOK  �Autor  � Douglas Coelho  � Data � Agosto/2016   ���
�������������������������������������������������������������������������͹��
���Descricao � Validacao do campo A1_GRPTRIB no cadastro de clientes.	  ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MA030TOK()

Local cMsgTxt  := "O campo Grp.Clientes na Aba Fiscais est� em Branco ou Inv�lido! Favor entrar em contato com o setor Fiscal."
Local l_Ret    := .T.
Local cContrib := M->A1_CONTRIB       
          
If Inclui .Or. Altera	
	If cContrib == "2" 
		If Empty(M->A1_GRPTRIB)			
			Aviso("CAMPO OBRIGATORIO",cMsgTxt,{"&Fechar"},2,"Grp.Clientes - Aba Fiscais",,"qmt_no")  
			l_Ret := .F.
		EndIf
	EndIf
EndIf

Return(l_Ret)    
