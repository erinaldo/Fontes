#Include 'Rwmake.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT103Fim  �Autor  � Sergio Oliveira    � Data �  Fev/2010   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada apos a atualizao da NFE e tambem apos a   ���
���          � transacao. Esta sendo utilizado para gravar o numero do    ���
���          � pedido de compra no bem caso algum item desta NOTA seja    ���
���          � referente a compra de Ativo.                               ���
�������������������������������������������������������������������������͹��
���Uso       � CSU - Controle de Ativo Fixo                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT103Fim()

Local cExec, cChave, w7
Local nHistor   := TamSX3('N3_HISTOR')[1], nAux := n
Local lSqlError := .f.
Local cEol      := Chr(13)+Chr(10)
Local cTxtBlq   := "Ocorreu um erro no momento da grava��o do n�mero do Pedido de Compra "
cTxtBlq += "no cadastro do bem. Informe este erro abaixo para a �rea de Sistemas ERP:"+cEol+cEol

/*
���������������������������������������������������������������������������������������������Ŀ
� Somente devera ser feita a gravacao do numero do Pedido de Compra no Ativo caso o SD1 tenha �
� a chave de identificacao do BEM no cadastro de Ativos. Testar se o usuario confirmou a ope- �
� racao e se esta operacao se refere a inclusao da NFE:                                       �
�����������������������������������������������������������������������������������������������*/

SC7->( DbSetOrder(1) ) // C7_FILIAL+C7_NUM
SD1->( DbSetOrder(1) ) // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
SN1->( DbSetOrder(1) ) // N1_FILIAL+N1_CBASE+N1_ITEM
SN3->( DbSetOrder(1) ) // N3_FILIAL+N3_CBASE+N3_ITEM....

If ParamIxb[1] == 3 .And. ParamIxb[2] == 1
	For n := 1 To Len( aCols )
		If !GDdeleted(n)
			cChave := xFilial('SD1')+cNFiscal+cSerie+cA100For+cLoja+aCols[n][GdFieldPos('D1_COD')]+aCols[n][GdFieldPos('D1_ITEM')]
			If SD1->( DbSeek( cChave ) )
				
				If !Empty(SD1->D1_CBASEAF)
					/*
					���������������������������������������������������������������������������������������������Ŀ
					� # OS 0392/10: Gravar o campo de projeto que constar no Pedido de Compra amarrado a Nota Fis-�
					�               cal posicionada:                                                              �
					�����������������������������������������������������������������������������������������������*/
					SC7->( DbSeek( xFilial('SC7')+SD1->D1_PEDIDO ) )
					
					If SN3->( DbSeek( xFilial('SN3')+SD1->D1_CBASEAF ) )
						/*
						������������������������������������������������������������������������������������������������Ŀ
						� # OS 2326/08: Gravar os demais campos: N3_HISTOR, N3_CLVLCON, N3_SUBCCON, N3_CUSTBEM e N1_NOMEFORN.�
						��������������������������������������������������������������������������������������������������*/
						If SN1->( DbSeek( xFilial('SN1')+SD1->D1_CBASEAF ) )
							cExec := " UPDATE " +RetSqlName('SN1')+" SET N1_NOMFORN = '"+Posicione('SA2',1,xFilial('SA2')+SC7->(C7_FORNECE+C7_LOJA),"A2_NOME")+"' "
							If aCols[n][GdFieldPos('D1_QUANT')] > 1
								cExec += " WHERE N1_FILIAL  = '"+xFilial('SN1')+"' "
								cExec += " AND   N1_CBASE   = '"+Left(SD1->D1_CBASEAF, TamSX3('N1_CBASE')[1] )+"' "
								cExec += " AND   D_E_L_E_T_ = ' ' "
							Else
								cExec += " WHERE R_E_C_N_O_ = "+Str( SN1->( Recno() ) )
							EndIf
							If TcSqlExec(cExec) # 0
								lSqlError := .t.
								cTxtBlq += TcSqlError()+cEol+cEol+"=========================================="+cEol+cEol
							EndIf
						EndIf
						/*
						���������������������������������������������������������������������������������������������Ŀ
						� # Pos-Validacao: Deve-se prever a situacao onde ha mais de uma quantidade na nota fiscal. O �
						�                  sistema "quebra" item a item no SN3. Sendo assim, o link entre o SD1 e o   �
						�                  SN3 nao podera ser pelo RECNO do SN3:                                      �
						�����������������������������������������������������������������������������������������������*/
						
						cExec := " UPDATE " +RetSqlName('SN3')+" SET N3_X_NUMPC = '"+SD1->D1_PEDIDO+"', N3_X_PRJ = '"+SC7->C7_X_PRJ+"', N3_X_ITPRJ = '"+SC7->C7_X_ITPRJ+"', "  // Tatiana A. Barbosa - OS 1262/11 - 08/06/11 - Incluida a gravacao do campo N3_X_ITPRJ atraves dO Pedido de Compra.
						cExec += " N3_HISTOR = '"+Left(SN1->N1_DESCRIC,nHistor)+"', N3_CLVLCON = '"+BuscaCols("D1_CLVL")+"', "
						cExec += " N3_SUBCCON = '"+BuscaCols("D1_ITEMCTA")+"', N3_CUSTBEM = '"+BuscaCols("D1_CC")+"' "
						If aCols[n][GdFieldPos('D1_QUANT')] > 1
							cExec += " WHERE N3_FILIAL  = '"+xFilial('SN3')+"' "
							cExec += " AND   N3_CBASE   = '"+Left(SD1->D1_CBASEAF, TamSX3('N3_CBASE')[1] )+"' "
							cExec += " AND   D_E_L_E_T_ = ' ' "
						Else
							cExec += " WHERE R_E_C_N_O_ = "+Str( SN3->( Recno() ) )
						EndIf
						If TcSqlExec(cExec) # 0
							lSqlError := .t.
							cTxtBlq += TcSqlError()+cEol+cEol+"=========================================="+cEol+cEol
						EndIf
					EndIf
					
				EndIf
				
			EndIf
		EndIf
	Next
EndIf

n := nAux

If lSqlError
	Aviso("GRAVA��O DO ATIVO",cTxtBlq,;
	{"&Fechar"},3,"Grava��o do Pedido no Ativo",,;
	"PCOLOCK")
EndIf

Return