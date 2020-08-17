#Include 'Rwmake.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AF060TOK  �Autor  � Sergio Oliveira    � Data �  Jul/2007   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada no momento da confirmacao da Transferencia���
���          � de Ativos - SIGAATF. Esta sendo utilizado para validar os  ���
���          � 2 prims.  digitos das entidades Unidade de Negocio x Centro���
���          � de Custo x Operacao e tambem a contra regra do CC x Operac.���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ���
�������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                   ���
�������������������������������������������������������������������������Ĵ��
��� Daniel G.Jr. �26/07/07�xxxxxx�Inclusao de interface para que o        ���
���              �        �      �usuario digite dados da pasta Outros    ���
���              �        �      �da tabela SN1                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
User Function AF060TOK()

Local aAreaAnt := GetArea()
Local _xk, lContin := .t.
Local cCCusto, cUnNeg, cOperacao

/*

Estrutura do ParamIxb. Para cada entidade, as opcoes sao de 1 a 5:

CC                   ITEM                 CLVL

ParamIxb[4][2][1]    ParamIxb[4][3][1]    ParamIxb[4][4][1]
ParamIxb[4][2][2]    ParamIxb[4][3][2]    ParamIxb[4][4][2]
ParamIxb[4][2][3]    ParamIxb[4][3][3]    ParamIxb[4][4][3]
ParamIxb[4][2][4]    ParamIxb[4][3][4]    ParamIxb[4][4][4]
ParamIxb[4][2][5]    ParamIxb[4][3][5]    ParamIxb[4][4][5]

*/

For _xk := 1 To Len( ParamIxb[4][2] )
	
	
	cCCusto   := ParamIxb[4][2][_xk]
	cUnNeg    := ParamIxb[4][3][_xk]
	cOperacao := ParamIxb[4][4][_xk]
	
	If !Empty(cCCusto+cUnNeg+cOperacao)
		
		lContin := U_VldCTBg(cUnNeg, cCCusto, cOperacao)
		
		If !lContin
			Exit
		EndIf
	
	EndIf
	
Next

If lContin                                            

	// Altera campos especificos (pasta Outros do SN1)
	lContin := AlterSN1()
	    
EndIf

RestArea( aAreaAnt )

Return( lContin )


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AlterSN1  �Autor  � Daniel G.Jr.TI1239 � Data � 26/07/07    ���
�������������������������������������������������������������������������͹��
���Desc.     � Apresenta enchoice para alteracao de campos especificos    ���
���          � da tabela SN1 (campo Outros), passiveis de alteracao quando���
���          � da tranferencia.                                           ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
Static Function AlterSN1()

//�����������������������������������Ŀ
//� Inicio das variveis da Enchoice   �
//�������������������������������������
Local cAliasE := "SN1"        // Tabela cadastrada no Dicionario de Tabelas (SX2) que sera editada
// Vetor com nome dos campos que serao exibidos. Os campos de usuario sempre serao              
// exibidos se nao existir no parametro um elemento com a expressao "NOUSER"                    
Local aCpoEnch      := {"NOUSER","N1_NURESPO","N1_NOMERES","N1_DEPTO","N1_CODCLI","N1_LOJA1",;
						"N1_DESCCLI","N1_UNIDNEG","N1_CODEPTO","N1_DPARTO","N1_PREDIO","N1_AREARIS"}
// Vetor com nome dos campos que poderao ser editados                                           
Local aAlterEnch   	:= {"N1_NURESPO","N1_CODCLI","N1_LOJA1","N1_UNIDNEG",;
						"N1_CODEPTO","N1_PREDIO","N1_AREARIS"}
Local nOpc          := 4               // Numero da linha do aRotina que definira o tipo de edicao (Inclusao, Alteracao, Exclucao, Visualizacao)
Local nReg          := SN1->(Recno())          // Numero do Registro a ser Editado/Visualizado (Em caso de Alteracao/Visualizacao)
// Vetor com coordenadas para criacao da enchoice no formato {<top>, <left>, <bottom>, <right>} 
Local aPos          := {20,10,125,300}                        
Local nModelo       := 3            // Se for diferente de 1 desabilita execucao de gatilhos estrangeiros                           
Local lF3           := .F.          // Indica se a enchoice esta sendo criada em uma consulta F3 para utilizar variaveis de memoria 
Local lMemoria      := .T.          // Indica se a enchoice utilizara variaveis de memoria ou os campos da tabela na edicao        
Local lColumn       := .F.          // Indica se a apresentacao dos campos sera em forma de coluna                                  
Local caTela        := ""           // Nome da variavel tipo "private" que a enchoice utilizara no lugar da propriedade aTela       
Local lNoFolder     := .T.          // Indica se a enchoice nao ira utilizar as Pastas de Cadastro (SXA)                            
Local lProperty     := .T.          // Indica se a enchoice nao utilizara as variaveis aTela e aGets, somente suas propriedades com os mesmos nomes
Local aButtons		:= {}
//������������������������������������Ŀ
//� Termino das variveis da Enchoice   �
//��������������������������������������

// Variaveis da Funcao de Controle e GertArea/RestArea
Local _aArea        := {}
Local _aAlias       := {}
Local nOpcx			:= 1
Local lRet			:= .T.
// Variaveis Private da Funcao
Private _oDlg                    // Dialog Principal
// Variaveis que definem a Acao do Formulario
Private VISUAL := .F.                        
Private INCLUI := .F.
Private ALTERA := .T.                        
Private DELETA := .F.                        
// Privates das NewGetDados

DEFINE MSDIALOG oDlg FROM 123,037 TO 410,655 TITLE "Altera��o de Campos Espec�ficos do SN1" Of oMainWnd PIXEL

// Chamadas da Enchoice do Sistema
// INCLUI = True --> Traz Enchoice vazia pronta para Inclusao
// INCLUI = False --> Traz Enchoice com o Registro definido pela variavel nReg
RegToMemory(cAliasE, INCLUI, .F.)
Enchoice(cAliasE,nReg,nOpc,/*aCRA*/,/*cLetra*/,/*cTexto*/,aCpoEnch,aPos,;
         aAlterEnch,nModelo,/*nColMens*/,/*cMensagem*/,/*cTudoOk*/,oDlg,lF3,;    
         lMemoria,lColumn,caTela,lNoFolder,lProperty)                             

ACTIVATE MSDIALOG oDlg ON INIT ( EnchoiceBar( oDlg, {|| nOpcx:=1,oDlg:End()}, {|| nOpcx:=0,oDlg:End()},,aButtons)) CENTERED 

If nOpcx == 1 
	RecLock("SN1",.F.)
	SN1->N1_NURESPO	:= M->N1_NURESPO
	SN1->N1_NOMERES	:= M->N1_NOMERES
	SN1->N1_DEPTO	:= M->N1_DEPTO
	SN1->N1_CODCLI 	:= M->N1_CODCLI
	SN1->N1_LOJA1 	:= M->N1_LOJA1
	SN1->N1_DESCCLI	:= M->N1_DESCCLI
	SN1->N1_UNIDNEG	:= M->N1_UNIDNEG
	SN1->N1_CODEPTO	:= M->N1_CODEPTO
	SN1->N1_DPARTO	:= M->N1_DPARTO
	SN1->N1_PREDIO 	:= M->N1_PREDIO
	SN1->N1_AREARIS	:= M->N1_AREARIS
	SN1->(MsUnLock())              
	RecLock("SN3",.F.)
	SN3->N3_SUBCTA := IIF( '*' $ PARAMIXB[4][3][1], SN3->N3_SUBCTA, PARAMIXB[4][3][1] )
	SN3->N3_CLVL   := IIF( '*' $ PARAMIXB[4][4][1], SN3->N3_CLVL, PARAMIXB[4][4][1] )
	SN3->(MsUnLock())                
Else
	MsgAlert("Esta transfer�ncia n�o ser� efetivada!","Aten��o")
	lRet := .F.
EndIf

Return(lRet)