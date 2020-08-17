#Include 'Rwmake.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  |MT110LOK  �Autor  �Cristian Werneck    � Data �  15/01/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para validar a linha digitada da solicita_���
���          � cao de compras                                             ���
�������������������������������������������������������������������������͹��
���Uso       � Modulo de Compras                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT110LOK()
/*
�������������������������������������������������������������������������������������������������������Ŀ
� Sergio em Abr/2007: Atendimento ao chamado 001214 - Incluir o campo C1_CLVL na validacao              �
���������������������������������������������������������������������������������������������������������*/
Local cTxtBlq
Local cEol      := Chr(13)+Chr(10)
Local lContinua := U_VldCTBg( BuscaCols('C1_ITEMCTA'), BuscaCols('C1_CC'), BuscaCols('C1_CLVL'), Nil )

lContinua := lContinua .And. ParamIxb[1]
/*
��������������������������������������������������������������������������������������������������������Ŀ
� Sergio em Dez/2008: Atendimento a OS 3353/08 - Nao permitir o preenchimento do campo memo inferior aos �
�                     "n" caracteres definidos no parametro. Os testes de desenvolvimento realizados com �
�                     build atual foram suficientes para garantir que nao ha necessidade de combinar es- �
�                     te ponto de entrada com o MT110Tok.prw                                             �
����������������������������������������������������������������������������������������������������������*/
If lContinua .And. Len( AllTrim(BuscAcols('C1_XJUSTIF')) ) < GetNewPar('MV_X_MEMSC',15) .And. !GdDeleted(n)
	cTxtBlq := "O tamanho m�nimo do MEMO dever� ser "+AllTrim(Str(GetNewPar('MV_X_MEMSC',15)))+" caracteres."
	Aviso("MEMO",cTxtBlq,;
	{"&Fechar"},3,"Tamanho M�nimo do MEMO",,;
	"PCOLOCK")
	lContinua := .f.
EndIf
/*
�������������������������������������������������������������������������������������������������������Ŀ
� Sergio em Jun/2010: A OS 0344/10 solicita nao permitir alterar itens pendentes de uma SC ja aprovada  �
�                     se pelo menos um dos itens ja estiver relacionado a algum Pedido de Compra. Para  �
�                     estes itens, permitir apenas "Deletar". Quando o usuario confirmar este tipo de   �
�                     alteracao, o sistema nao devera gerar um novo processo de aprovacao da SC.        �
�                         Para alcancar o objetivo, o ponto de entrada M110Stts.prw teve de ser alterado�
�                     em conjunto com este ponto de entrada.                                            �
���������������������������������������������������������������������������������������������������������*/
If lContinua .And. Altera
/*
�������������������������������������������������������������������������������������������������������Ŀ
� Verificar se existe PC colocado para pelo menos um dos itens da SC.                                   �
���������������������������������������������������������������������������������������������������������*/
	If U_ChkPCSC()
/*
�������������������������������������������������������������������������������������������������������Ŀ
� Em caso afirmativo, verificar se algum campo do item posicionado foi alterado.                        �
���������������������������������������������������������������������������������������������������������*/
		If U_ChkCPAlt()
			cTxtBlq := "N�o � permitido efetuar altera��es em itens j� existentes nas Solicita��es de Compras "
			cTxtBlq += "j� aprovada e com Pedido Colocado."+cEol+cEol
			cTxtBlq += "Dica: � poss�vel apenas DELETAR itens qua ainda n�o foram baixados atrav�s de Pedidos."
			Aviso("SC x PC Colocado",cTxtBlq,{"&Fechar"},3,"Pedido de Compra j� Colocado",,"PCOLOCK")
			lContinua := .f.
		EndIf
	EndIf
EndIf             

/*
�������������������������������������������������������������������������������������������������������Ŀ
� Tatiana A. Barbosa em Jun/2011: Atendimento a OS 1262/11 								                 �
���������������������������������������������������������������������������������������������������������*/
If (!Empty(BuscaCols('C1_X_PRJ')) .And. Empty(BuscaCols('C1_X_ITPRJ')) .Or. Empty(BuscaCols('C1_X_PRJ')) .And. !Empty(BuscaCols('C1_X_ITPRJ')));
   .And. ZA8->( DbSetOrder(1), DbSeek( xFilial('ZA8')+"SC"+cA110Num ) )
	Alert("Quando existir C�digo de Projeto o campo It.Cod.Proj. dever� estar preenchido")
	lContinua := .F.
EndIf                                    

If BuscaCols('C1_X_ITPRJ')=="0000"
	Alert("O campo It.Cod.Proj. deve ser maior que zero.")
	lContinua := .F.
EndIf                                    
/*
�������������������������������������������������������������������������������������������������������Ŀ
� Tatiana A. Barbosa em Jun/2011: Atendimento a OS 1263/11 								                 �
���������������������������������������������������������������������������������������������������������*/
If Empty(BuscaCols('C1_X_PRJ')) .And. ZA8->( DbSetOrder(1), DbSeek( xFilial('ZA8')+"SC"+cA110Num ) )
	Alert("� obrigat�ria a digita��o do C�digo de Projeto na Solicita��o de Compra")
	lContinua := .F.
EndIf                                    

If BuscaCols('C1_XVLCAPE') <= 0 .And. ZA8->( DbSetOrder(1), DbSeek( xFilial('ZA8')+"SC"+cA110Num ) )
	Alert("Obrigat�rio informar o Valor do Capex.")
	lContinua := .F.
EndIf                                    

Return( lContinua )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    | ChkPCSC  �Autor  � Sergio Oliveira    � Data �  Jun/2010   ���
�������������������������������������������������������������������������͹��
���Descricao � Checar se dentre os itens nao posicionados (diferente do   ���
���          � "n" atual do aCols) se ha Pedido de Compra relacionado.    ���
�������������������������������������������������������������������������͹��
���Uso       � Validacao da OS 0344/10                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ChkPCSC()

Local cChkPC, lTemPC

cChkPC := " SELECT COUNT(*) AS QTDES "
cChkPC += " FROM "+RetSqlName('SC1')
cChkPC += " WHERE C1_FILIAL =  '"+xFilial('SC1')+"' "
cChkPC += " AND   C1_NUM    =  '"+cA110Num+"' "
cChkPC += " AND   C1_PEDIDO <> '      ' "
cChkPC += " AND   D_E_L_E_T_ = ' ' "

U_MontaView( cChkPC, "cChkPC" )

cChkPC->( DbGoTop() )

lTemPC := cChkPC->QTDES > 0

cChkPC->( DbCloseArea() )

Return( lTemPC )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    | ChkCPAlt �Autor  � Sergio Oliveira    � Data �  Jun/2010   ���
�������������������������������������������������������������������������͹��
���          � Verificar algum campo foi alterado, ou seja, se esta funcao���
���Descricao � tiver sido chamada significa que devera ser os campos lis- ���
���          � tados na matriz _aNPdMudar. Caso algum destes campos esti- ���
���          � ver diferente da base de dados, retornar False.            ���
���          � Esta funcao somente podera ser acionada atraves dos pontos ���
���          � de entrada MT110Tok e MT110Lok.                            ���
�������������������������������������������������������������������������͹��
���Uso       � Validacao da OS 0344/10                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ChkCPAlt()

Local _aNPdMudar := {'C1_PRODUTO','C1_X_PRJ','C1_QUANT','C1_CC','C1_ITEMCTA','C1_CLVL','C1_SOLICIT'}
Local cVerifik, cNxtAlias := GetNextAlias()
Local lAlterou   := .f.
Local nTamC1QT   := TamSX3('C1_QUANT')[2]

cVerifik := " SELECT C1_PRODUTO "
For wXP := 2 To Len(_aNPdMudar)
	cVerifik += ", "+_aNPdMudar[wXP]
Next
cVerifik += " FROM "+RetSqlName('SC1')
cVerifik += " WHERE C1_FILIAL  =  '"+xFilial('SC1')+"' "
cVerifik += " AND   C1_NUM     =  '"+cA110Num+"' "
cVerifik += " AND   C1_ITEM    =  '"+GdFieldGet("C1_ITEM")+"' "
cVerifik += " AND   D_E_L_E_T_ = ' ' "

U_MontaView( cVerifik, cNxtAlias )

(cNxtAlias)->( DbGoTop() )

For wXP := 1 To Len(_aNPdMudar)
    If 'C1_QUANT' $ _aNPdMudar[wXP]
		If Round( GdFieldGet(_aNPdMudar[wXP]), nTamC1QT ) # Round( (cNxtAlias)->&(_aNPdMudar[wXP]), nTamC1QT )
		   lAlterou := .t.
		EndIf
    ElseIf 'C1_SOLICIT' $ _aNPdMudar[wXP]
		If (cNxtAlias)->&(_aNPdMudar[wXP]) # cA110Sol
		   lAlterou := .t.
		EndIf
    Else
		If GdFieldGet(_aNPdMudar[wXP]) # (cNxtAlias)->&(_aNPdMudar[wXP])
		   lAlterou := .t.
		EndIf
	EndIf
Next

Return( lAlterou )