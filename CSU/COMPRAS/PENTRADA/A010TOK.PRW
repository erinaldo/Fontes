#Include "Protheus.ch" 
#Include "Rwmake.ch"

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �A010TudoOk� Autor �  Renato Carlos        � Data � Nov/2010  ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � P.E para validar campos IP NCM do cadastro de produtos      ���
���          � No momento da libera��o, validar se est� preenchido.        ���
��������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                      ���
��������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                    ���
��������������������������������������������������������������������������Ĵ��
���              �        �      �                                         ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/

User Function A010TOK()

Local cMsgTxt  := "Posi��o de IPI/NCM em branco. Obrigat�rio cadastrar no desbloqueio do produto"
Local cMsgTxt2 := "O campo Grupo Trib. na Aba Impostos est� em Branco ou Inv�lido! Favor entrar em contato com o setor Fiscal."
Local l_Ret    := .T.
Local c_Mblq   := Alltrim(M->B1_MSBLQL)
Local c_PosIpi := Alltrim(M->B1_POSIPI)  
Local cCod 	   := Alltrim(M->B1_COD)

If ALTERA
	If c_Mblq <> '1'
		If SB1->B1_MSBLQL == '2' .OR. c_Mblq == '2'
			If Empty(SB1->B1_POSIPI) .AND. Empty(c_PosIpi)
				Aviso("Campo Obrigatorio",cMsgTxt,{"&Voltar"},3,"Posicao IPI/NCM",,"PCOLOCK")
				l_Ret := .F. 
			EndIf
		EndIf
	EndIf			 
EndIf

/*�����������������������������������������������������������������������������������������������Ŀ
  �            Valida��o para o campo B1_GRTRIB. OS 1474/16 - By Douglas Coelho					   �
  �������������������������������������������������������������������������������������������������*/           
           
If Inclui .Or. Altera	
	If  RIGHT(cCod,1) == "G" .Or. RIGHT(cCod,1) == "F"		
		If Empty(M->B1_GRTRIB)			
			Aviso("CAMPO OBRIGATORIO",cMsgTxt2,{"&Fechar"},2,"Grupo Trib. - Aba Impostos",,"qmt_no")  
			l_Ret := .F.
		EndIf
	EndIf
EndIf

Return(l_Ret)    
