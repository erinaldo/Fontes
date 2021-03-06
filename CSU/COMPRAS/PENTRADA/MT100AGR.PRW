#Include "RwMake.ch"
/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  � Mt100Agr � Autor � Cristiano Figueiroa � Data � 05/07/2006  ���
��������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada disparado apos a confirmacao da gravacao do���
���          � Documento de Entrada.                                       ���
��������������������������������������������������������������������������͹��
���Uso       � CSU - CardSystem S.A                                        ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/

User Function Mt100Agr()   

//Local cAviso := "Favor encaminhar este documento imediatamente para o Depto. Fiscal na Faria Lima - At. Jane Bessa."+Chr(13)+Chr(10)+"Ap�s 2 dias da entrada, caso o sistema n�o acuse o recebimento pelo Depto. Fiscal, este documento ser� excluido automaticamente pelo sistema."
Local cAviso := "Caro Colaborador, ap�s a confirma��o e inclus�o do documento fiscal no sistema,"+Chr(13)+Chr(10)+"encaminhar imediatamente o mesmo � �rea de recebimento localizada em seu site."
/*������������������������������������������������������������������������������Ŀ
�             Inclui - Inclusao do Documento de Entrada                        �
�             Altera - Classificacao do Documento de Entrada                   �
��������������������������������������������������������������������������������*/

If Inclui .Or. Altera
	
	/*������������������������������������������������������������������������������Ŀ
	�                 Verifica se o Tipo de Documento eh Normal                    �
	��������������������������������������������������������������������������������*/
	
	If SF1->F1_TIPO == "N"
		
		/*������������������������������������������������������������������������������Ŀ
		�    Chama a Funcao que dispara o WorkFlow informativo indicando que existe    �
		�    bloqueio do Documento de Entrada por problema de Tolerancia.              �
		��������������������������������������������������������������������������������*/
		
		If SF1->F1_STATUS == "B"
			u_Rwfwa05()
		Endif
		
		/*������������������������������������������������������������������������������Ŀ
		�    Caso nao exista bloqueio e a Nota Fiscal Gere Duplicata , Chama a Funcao  �
		�    que monta a tela para a informacao de dados adicionais.                   �
		��������������������������������������������������������������������������������*/
		
		If SF1->F1_STATUS == "A" .And. !Empty( SF1->F1_DUPL )
			u_RComa04()
		Endif
		
		/*����������������������������������������������������������������������������Ŀ
		�    Exibe a mensagem Solicitada pela Contabilidade.                           �
		�                                                                              �
		��������������������������������������������������������������������������������*/      
		If SF1->F1_STATUS <> "B"
			Aviso( 'Aten��o',cAviso, {'Ok'} )       
		Endif
		
		/*����������������������������������������������������������������������������Ŀ
		�    Atualiza campo de vencimento da nota fiscal.                              �
		�                                                                              �
		��������������������������������������������������������������������������������*/      
		If SF1->F1_STATUS == "A" .And. !Empty( SF1->F1_DUPL )
			RecLock("SF1",.F.)
			SF1->F1_XVENCTO := SE2->E2_VENCTO	
			MsUnlock()		                                      
		Endif
				
	Endif
	
Endif

Return
