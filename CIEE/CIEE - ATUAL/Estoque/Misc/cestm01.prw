#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �cestm01   � Autor � Felipe Raposo      � Data �  17/05/02   ���
�������������������������������������������������������������������������͹��
���Descricao � Acerta o campo de estoque de seguranca em quantidade, do   ���
���          � cadastro de produtos, de acordo com os campos dias de esto-���
���          � em dias e o consumo medio mensal depois do calculo do lote ���
���          � economico.                                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico CIEE.                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function cestm01()
Private lAbortPrint := .F., lEnd := .F.
MATA290()  // Calculo do lote economico.
MsAguarde({|lEnd| U_EstProc(.T.)}, "Calculando o estoque de seguranca...", "Aguarde", .T.)
Return (.T.)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �cestm01a  � Autor � Felipe Raposo      � Data �  04/06/02   ���
�������������������������������������������������������������������������͹��
���Descricao � Acerta o campo de estoque de seguranca em quantidade, do   ���
���          � cadastro de produtos, de acordo com os campos dias de esto-���
���          � em dias e o consumo medio mensal depois do cadastro de con-���
���          � sumo medio.                                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico CIEE.                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function cestm01a()
Private lAbortPrint := .F., lEnd := .F.
MATA210()  // Consumo Medio.
MsAguarde({|lEnd| U_EstProc(.T.)}, "Recalculando o estoque de seguranca...", "Aguarde", .T.)
Return (.T.)


//������������������������������������������������������������Ŀ
//� Recalcula os campos da aba MRP do cadastro de produtos.    �
//��������������������������������������������������������������
User Function EstProc(_lTudo)
//���������������������������������������������������������������������Ŀ
//� Salva as condicoes atuais do SB1 e o alias selecionado.             �
//�����������������������������������������������������������������������
Local _aB1Area := SB1->(GetArea())
// Processa todos os produtos?
If _lTudo
	SB1->(dbGoTop())
	Do While SB1->(!eof())
		MsProcTxt("Processando produtos: " + SB1->B1_COD)
		// Sai do looping Do While caso o usuario clique em cancelar.
		If lAbortPrint; Exit; Endif
		ProcB1Atu()  // Atualiza o registro corrente.
		SB1->(dbSkip())  // Pula para o proximo registro.
	EndDo
Else
	ProcB1Atu()  // Atualiza o registro corrente.
Endif
//���������������������������������������������������������������������Ŀ
//� Restaura as condicoes anteriores do SB1.                            �
//�����������������������������������������������������������������������
SB1->(RestArea(_aB1Area))
Return (.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �ProcB1Atu �Autor  � Felipe Raposo      � Data �  04/06/02   ���
�������������������������������������������������������������������������͹��
���Desc.     � Atualiza os campos da aba MRP do cadastro de produtos.     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE.                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ProcB1Atu()
/**/
M->B1_COD     := SB1->B1_COD
M->B1_ESTSEG  := SB1->B1_ESTSEG
M->B1_ESTSEGD := SB1->B1_ESTSEGD
M->B1_PE      := SB1->B1_PE
M->B1_PEQ     := SB1->B1_PEQ
M->B1_EMIND   := SB1->B1_EMIND
M->B1_EMIN    := SB1->B1_EMIN
M->B1_LED     := SB1->B1_LED
M->B1_LE      := SB1->B1_LE
M->B1_CONSMED := SB1->B1_CONSMED //Acrescentado pelo analista Emerson dia 02/03/10
/**/
ExecBlock("cesta03", .F., .F., "cestm01()")  // Processa as formulas.
RecLock("SB1", .F.)  // Trava o registro para alteracao.
/**/
SB1->B1_COD     := M->B1_COD
SB1->B1_ESTSEG  := M->B1_ESTSEG
SB1->B1_ESTSEGD := M->B1_ESTSEGD
SB1->B1_PE      := M->B1_PE
SB1->B1_PEQ     := M->B1_PEQ
SB1->B1_EMIND   := M->B1_EMIND
SB1->B1_EMIN    := M->B1_EMIN
SB1->B1_LED     := M->B1_LED
SB1->B1_LE      := M->B1_LE
SB1->B1_CONSMED	:= M->B1_CONSMED //Acrescentado pelo analista Emerson dia 02/03/10
/**/
SB1->(msUnLock())  // Salva e libera o registro.
Return (.T.)