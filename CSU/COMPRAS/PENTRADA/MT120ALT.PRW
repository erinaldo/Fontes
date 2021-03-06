#Include 'Rwmake.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT120ALT  �Autor  � Sergio Oliveira    � Data �  Out/2006   ���
�������������������������������������������������������������������������͹��
���Desc.     � Informar ao usuario qual a situacao atual do pedido confor-���
���          � me as regras estabelecidas. (ponto de entrada Ped. Compras)���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������͹��
���Alteracoes� 1) Alterado por Flavio Novaes em 02/05/07, para proibir a  ���
���          �    Inclusao caso o usuario tenha alterado a Data Base do   ���
���          �    Sistema, conforme chamado 1458.                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT120ALT()

Local lRet    := .t.
Local cMsg2   := ""
Local _lCopia := IsInCallStack("A120COPIA")
Local cProvpc := Alltrim(GetMv("MV_PROVPC" ))


If "CNTA120"$FunName() // Sergio em Jul/2008: A exclusao via modulo GCT devera ser permitida.
	Return(.t.)
EndIf

If "RPC"$FunName() 
	Return(.t.)
EndIf

// Sergio Oliveira em Jul/2007: Atendimento ao chamado 002111 - Criacao da variavel _cUsrGst
//                              para que a mesma seja controlada no ponto de entrada MT120gok.prw

Public _cUsrGst := SC7->C7_USER

/*
�������������������������������������������������������������������������������������������������������Ŀ
� OS 0915/11 - Os para que na chamada da fun��o Copia de pedido, seja gravado o usu�rio corrente e nao  �
� o usu�rio do pedido original                                   �
���������������������������������������������������������������������������������������������������������*/

If _lCopia
	_cUsrGst := __cUserId
EndIf



/*
����������������������������������������������������������������������������Ŀ
� Sergio em Ago/2007: De acordo com o VFP-Manutencao_de_PC.doc algumas consi-�
� deracoes sao agora necessarias:                                            �
�                                                                            �
� I- Permitir que somente os usuarios que criaram o Pedido ou o usuario mas- �
�    ter realizem a manutencao dos mesmos (Alteracao e Exclusao)             �
������������������������������������������������������������������������������
*/

// Estrutura da ParamIxb: 03-Incluir/04-Alterar/05-Excluir

If lRet
	
	IF StrZero(ParamIxb[1],2) $ '03/04/05' .Or. _lCopia
		IF dDataBase <> DATE()
			lRet  := .F.
			cMsg2 := 'A Data Base do Sistema foi Alterada, favor voltar '
			cMsg2 += 'a Data Base para a Data de Hoje: '+DTOC(DATE())+'!'
			Aviso('Data',cMsg2,{'Voltar'},3,"Manutencao do PC",,"PCOLOCK")
		ENDIF
	ENDIF
	
EndIf

If ( SC7->C7_USER # __cUserId .And. StrZero(ParamIxb[1],2) $ '04/05' ) .And.;
	( StrZero(ParamIxb[1],2) $ '04/05' .And. !AllTrim(cUserName) $ GetMV( 'MV_X_MASTR' ) ) .And. !_lCopia
	
	Aviso("Usuario Gestor","Voce n�o � o gestor deste pedido.",;
	{"Voltar"},3,"Gestor do Pedido",,;
	"PCOLOCK")
	
	lRet := .f.
	
EndIf



/*
����������������������������������������������������������������������������Ŀ
� Sergio em Ago/2007: De acordo com o VFP-Manutencao_de_PC.doc               �
� II- Nao permitir a manutencao do PC apos ter sido enviado ao fornecedor.   �
������������������������������������������������������������������������������
*/

If lRet .And. StrZero(ParamIxb[1],2) $ '04/05' .And. !_lCopia
	If !Empty(SC7->C7_X_ENVFR)
		
		If !Empty(SC7->C7_X_DTACT)
			cMsg2 := " e inclusive o fornecedor ja o aceitou em "+Dtoc(SC7->C7_X_DTACT)+". "
		EndIf
		
		cMsg := "Este pedido ja foi enviado ao fornecedor"+cMsg2
		
		If StrZero(ParamIxb[1],2) $ '04'
			cMsg += "Somente a op��o de exclusao ser� permitida."
			Aviso('Fornecedor',cMsg,{'Voltar'},3,"Gestor do Pedido",,"PCOLOCK")
			lRet := .f.
		Else
			_cUsuario := Posicione('SA2',1,xFilial('SA2')+SC7->(C7_FORNECE+C7_LOJA),"A2_EMAIL")
			cMsg += "Caso voce prossiga, uma notifica��o avulsa (sem processo de retorno) de "
			cMsg += "cancelamento do Pedido ser� enviada ao fornecedor para o e-mail: "+Trim(_cUsuario)+" ."
			Aviso('Fornecedor',cMsg,{'Ok'},3,"Gestor do Pedido",,"PCOLOCK")
		EndIf
		
	EndIf
	If lRet
		If VerItens() // Caso ja tenha quantidade entregue, nao permitir a alteracao:
			cMsg := "Ja existe nota fiscal relacionada a este Pedido de Compras. Esta opera��o "
			cMsg += "n�o poder� ser conclu�da.."
			Aviso('Pedido Atendido',cMsg,{'Ok'},3,"Pedido Atendido",,"PCOLOCK")
			
			lRet := .f.
		EndIf
		If VerPA() // Caso ja tenha PA, nao permitir a alteracao. OS 1670/15
			cMsg := "Ja existe Pagamento Antecipado (PA) relacionada a este Pedido de Compra. "
			cMsg += "Esta opera��o n�o poder� ser conclu�da.."
			Aviso('Pedido vinculado a uma PA',cMsg,{'Ok'},3,"Pedido vinculado a uma PA",,"PCOLOCK")
			
			lRet := .f.
		EndIf
		If ExistProv() .and. cProvpc == "Bloqueado" // Caso tenha PROVIS�O, n�o permitir a alteracao e exclus�o. OS 3417/15 e 0602/16
			cMsg := "J� existe Provis�o, vinculada a este pedido de compra."+CHR(10)+CHR(13)
			cMsg += "Esta opera��o n�o poder� ser conclu�da! "
			cMsg += "Favor entrar em contato com a Contabilidade!"
			Aviso("Pedido de compra X Provis�o",cMsg,{'Ok'},3,"Pedido de compra X Provis�o",,"PCOLOCK")
			
			lRet := .f.
		EndIf		
	EndIf
EndIf

Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    � VerItens �Autor  � Sergio Oliveira    � Data �  Ago/2008   ���
�������������������������������������������������������������������������͹��
���Descricao � Verificar se algum item do PC possui nota fiscal relaciona-���
���          � da. Caso tenha, deve retornar verdadeiro.                  ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function VerItens()

Local aAreaAnt := GetArea()
Local cNextAli := GetNextAlias()
Local lRetorna := .t.
Local cQry

cQry := " SELECT COUNT(*) AS QTOS "
cQry += " FROM "+RetSqlName('SC7')
cQry += " WHERE C7_FILIAL = '"+xFilial('SC7')+"' "
cQry += " AND   C7_NUM    = '"+SC7->C7_NUM+"' "
cQry += " AND   C7_TIPO   = 1 "
cQry += " AND   C7_QUJE > 0 "
cQry += " AND   D_E_L_E_T_ = ' ' "

U_MontaView( cQry, cNextAli )

(cNextAli)->( DbGotop() )

lRetorna := (cNextAli)->QTOS > 0

(cNextAli)->( DbCloseArea() )

RestArea( aAreaAnt )

Return( lRetorna )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    � VerItens �Autor  � Douglas David      � Data � Maio/2015   ���
�������������������������������������������������������������������������͹��
���Descricao � Verificar se algum item do PC possui nota fiscal relaciona-���
���          � da. Caso tenha, deve retornar verdadeiro. OS 1670/15       ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function VerPA()

Local aAreaAnt := GetArea()
Local cNextAli := GetNextAlias()
Local lRetorna := .t.
Local cQry

cQry := " SELECT COUNT(*) AS QTOS "
cQry += " FROM "+RetSqlName('SE2')
cQry += " WHERE E2_NUMPC  = '"+SC7->C7_NUM+"' "
cQry += " AND E2_TIPO = 'PA'"
cQry += " AND   D_E_L_E_T_ = ' ' "

U_MontaView( cQry, cNextAli )

(cNextAli)->( DbGotop() )

lRetorna := (cNextAli)->QTOS > 0

(cNextAli)->( DbCloseArea() )

RestArea( aAreaAnt )

Return( lRetorna )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    � ExistProv�Autor  � Douglas David  � Data � Novembro/2015   ���
�������������������������������������������������������������������������͹��
���Descricao � Verificar se o PC  est� vinculado em algum provis�o.       ���
���          � OS 3417/15                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ExistProv()

Local aAreaAnt := GetArea()
Local cNextAli := GetNextAlias()
Local lRetorna := .t.
Local cQry

cQry := " SELECT COUNT(*) AS QTOS "
cQry += " FROM "+RetSqlName('ZB2')
cQry += " WHERE ZB2_PEDCOM  = '"+SC7->C7_NUM+"' "
cQry += " AND   D_E_L_E_T_ = ' ' "

U_MontaView( cQry, cNextAli )

(cNextAli)->( DbGotop() )

lRetorna := (cNextAli)->QTOS > 0

(cNextAli)->( DbCloseArea() )

RestArea( aAreaAnt )

Return( lRetorna )

