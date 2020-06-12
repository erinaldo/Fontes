#INCLUDE "rwmake.ch"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CESTA04
Acerta o campo de estoque de seguranca em quantidade, do cadastro de produtos, de acordo com 
os campos dias de estoque em dias e o consumo medio mensal depois do calculo do lote economico.
@author     Totvs
@since     	01/01/2015
@version  	P.11      
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum
Altera��es Realizadas desde a Estrutura��o Inicial
------------+-----------------+----------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                                                                                 
------------+-----------------+----------------------------------------------------------
			|				  | 
------------+-----------------+----------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
User Function CESTA04()
Private lAbortPrint := .F., lEnd := .F.

	MATA290()  // Calculo do lote economico.
	MsAguarde({|lEnd| U_C4A04PRO(.T.)}, "Calculando o estoque de seguranca...", "Aguarde", .T.) 

Return (.T.)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CESTA04A   �Autor  � Totvs       	   � Data �01/01/2015 ���
�������������������������������������������������������������������������͹��
���Descricao � Acerta o campo de estoque de seguranca em quantidade, do   ���
���          � cadastro de produtos, de acordo com os campos dias de esto-���
���          � em dias e o consumo medio mensal depois do cadastro de con-���
���          � sumo medio.                                                ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/  
User Function CESTA04A()
Private lAbortPrint := .F., lEnd := .F.
	
	MATA210()  // Consumo Medio.
	MsAguarde({|lEnd| U_C4A04PRO(.T.)}, "Recalculando o estoque de seguranca...", "Aguarde", .T.)
	
Return (.T.)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � C4A04PRO   �Autor  � Totvs       	   � Data �01/01/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � Recalcula os campos da aba MRP do cadastro de produtos     ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/  
User Function C4A04PRO(_lTudo)
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
		C4A04PRO()  // Atualiza o registro corrente.
		SB1->(dbSkip())  // Pula para o proximo registro.
	EndDo
Else
	C4A04PRO()  // Atualiza o registro corrente.
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
���Programa  � C4A04PRO   �Autor  � Totvs       	   � Data �01/01/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � Atualiza os campos da aba MRP do cadastro de produtos      ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/  
Static Function C4A04PRO()
/**/
M->B1_COD     := SB1->B1_COD
M->B1_ESTSEG  := SB1->B1_ESTSEG
M->B1_XDIASEG := SB1->B1_XDIASEG
M->B1_PE      := SB1->B1_PE
M->B1_XPEQ     := SB1->B1_XPEQ
M->B1_XEMIND   := SB1->B1_XEMIND
M->B1_EMIN    := SB1->B1_EMIN
M->B1_XLED     := SB1->B1_XLED
M->B1_LE      := SB1->B1_LE
M->B1_XCONMED := SB1->B1_XCONMED //Acrescentado pelo analista Emerson dia 02/03/10
/**/

ExecBlock("CESTE07", .F., .F., "CESTA04()")  // Processa as formulas.

RecLock("SB1", .F.)  // Trava o registro para alteracao.
/**/
SB1->B1_COD     := M->B1_COD
SB1->B1_ESTSEG  := M->B1_ESTSEG
SB1->B1_XDIASEG := M->B1_XDIASEG
SB1->B1_PE      := M->B1_PE
SB1->B1_XPEQ     := M->B1_XPEQ
SB1->B1_XEMIND   := M->B1_XEMIND
SB1->B1_EMIN    := M->B1_EMIN
SB1->B1_XLED     := M->B1_XLED
SB1->B1_LE      := M->B1_LE
SB1->B1_XCONMED	:= M->B1_XCONMED //Acrescentado pelo analista Emerson dia 02/03/10
/**/
SB1->(msUnLock())  // Salva e libera o registro.  

Return (.T.)