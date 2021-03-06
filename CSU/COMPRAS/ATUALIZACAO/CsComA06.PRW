#INCLUDE 'RWMAKE.CH'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CSCOMA06.PRW � Autor � Flavio Novaes     � Data � 30/03/07 ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de Liberacoes para Inclusao de Notas Fiscais de   ���
���          � Entrada: Tabela ZU7.                                       ���
�������������������������������������������������������������������������͹��
���Uso       � A CSU decidiu bloquear a Inclusao de Notas Fiscais de En-  ���
���          � trada para as seguintes situacoes: 1) Quando os Impostos   ���
���          � de ISS e/ou INSS estiverem atrasados. 2) Quando o Titulo a ���
���          � Pagar gerado pela Nota Fiscal de Entrada tiver vencimento  ���
���          � Fora do Prazo estabelecido pela CSU (parametro MV_DIAVENC).���
���          � Essa rotina permite cadastrar as excecoes, ou seja, os For-���
���          � necedores que estiverem ativos nessa tabela tem permissao  ���
���          � para entrar com a Nota Fiscal.                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER FUNCTION CSCOMA06()
LOCAL cTitulo   := 'Cadastro de Libera��es.'
LOCAL aCor      := {	{'ZU7->ZU7_ATIVO == .T.','BR_VERDE'},;		// Lib. Ativa
						{'ZU7->ZU7_ATIVO == .F.','BR_VERMELHO'}}	// Lib. Inativa
cCadastro := 'Cadastro de Libera��es.'
aRotina   := menudef()

//{	{'Pesquisar','AXPESQUI',0,1},;
//				{'Visualizar','AXVISUAL',0,2},;
//				{'Liberar','AXINCLUI',0,3},;
//				{'Bloquear','U_CSCOMA6A()',0,4},;
//				{'Legenda','U_CSCOMA6L()',0,9}}
MBROWSE(,,,,'ZU7',,,,,,aCor)
RETURN
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CSCOMA6A     � Autor � Flavio Novaes     � Data � 30/03/07 ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de Liberacoes para Inclusao de Notas Fiscais de   ���
���          � Entrada: Tabela ZU7.                                       ���
�������������������������������������������������������������������������͹��
���Uso       � A CSU decidiu bloquear a Inclusao de Notas Fiscais de En-  ���
���          � trada para as seguintes situacoes: 1) Quando os Impostos   ���
���          � de ISS e/ou INSS estiverem atrasados. 2) Quando o Titulo a ���
���          � Pagar gerado pela Nota Fiscal de Entrada tiver vencimento  ���
���          � Fora do Prazo estabelecido pela CSU (parametro MV_DIAVENC).���
���          � Essa rotina permite cadastrar as excecoes, ou seja, os For-���
���          � necedores que estiverem ativos nessa tabela tem permissao  ���
���          � para entrar com a Nota Fiscal.                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER FUNCTION CSCOMA6A()
IF ZU7->ZU7_ATIVO
	_nOpc := AxAltera('ZU7',ZU7->(RECNO()),4,,,,,,,,)
	IF _nOpc == 1 .AND. !ZU7->ZU7_ATIVO
		IF RECLOCK('ZU7',.F.)
			REPLACE ZU7_DTBLOQ WITH dDataBase,;
					ZU7_HRBLOQ WITH TIME(),;
					ZU7_USBLOQ WITH SUBSTR(cUsuario,7,15)
			MSUNLOCK()
		ENDIF
	ENDIF
ENDIF
RETURN
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CSCOMA6L     � Autor � Flavio Novaes     � Data � 30/03/07 ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de Liberacoes para Inclusao de Notas Fiscais de   ���
���          � Entrada: Tabela ZU7.                                       ���
�������������������������������������������������������������������������͹��
���Uso       � A CSU decidiu bloquear a Inclusao de Notas Fiscais de En-  ���
���          � trada para as seguintes situacoes: 1) Quando os Impostos   ���
���          � de ISS e/ou INSS estiverem atrasados. 2) Quando o Titulo a ���
���          � Pagar gerado pela Nota Fiscal de Entrada tiver vencimento  ���
���          � Fora do Prazo estabelecido pela CSU (parametro MV_DIAVENC).���
���          � Essa rotina permite cadastrar as excecoes, ou seja, os For-���
���          � necedores que estiverem ativos nessa tabela tem permissao  ���
���          � para entrar com a Nota Fiscal.                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER FUNCTION CSCOMA6L()
LOCAL _aLegenda := {}
aAdd(_aLegenda,{'BR_VERDE','Libera��o Ativa' })
aAdd(_aLegenda,{'BR_VERMELHO','Libera��o Inativa'})
BRWLEGENDA('Cadastro de Libera��es.','Legenda',_aLegenda)
RETURN
/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
��� Funcao     � FVALUSER()   � Autor � Flavio Novaes   � Data � 23/04/2007 ���
���������������������������������������������������������������������������Ĵ��
��� Descricao  � Funcao para Validar o Codigo do Usuario no SIGA, utilizada ���
���            � na Validacao do Usuario do Campo ZU7->ZU7_SOLIC.           ���
���������������������������������������������������������������������������Ĵ��
��� Uso        � Exclusivo CSU.                                             ���
���������������������������������������������������������������������������Ĵ��
��� Observacao �                                                            ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
USER FUNCTION FVALUSER(_cNomeUsr)
LOCAL _lRet := .T.
//Alterado por Flavio Novaes em 11/06/07 pois estava muito lento.
//LOCAL _aUsuario := ALLUSERS()
//LOCAL _nPos     := aScan(_aUsuario,{|x|ALLTRIM(x[1][1])==ALLTRIM(_cCodUsr)})
//IF !_nPos > 0
//	_lRet := .F.
//	AVISO('Aten��o !','Usu�rio N�o Cadastrado.',{'Ok'},1,'Cadastro de Usu�rios')
//ENDIF
PSWORDER(2)	// Nome do Usuario (Login do Usuario do Protheus)
IF !PSWSEEK(_cNomeUsr)
	_lRet := .F.
	AVISO('Aten��o !','Matr�cula do Usu�rio ('+ALLTRIM(_cNomeUsr)+') N�O Cadastrada!',{'OK'},1,'Usu�rio N�O Cadastrado!')
ENDIF
RETURN(_lRet)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MenuDEF  � Autor �Eduardo de Souza    � Data �12/Jan/2007  ���
�������������������������������������������������������������������������͹��
���Descricao � Implementa menu funcional                                  ���
�������������������������������������������������������������������������͹��
���Uso       � Menus                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//��������������������������������������������������������������Ŀ
//� Define Array contendo as Rotinas a executar do programa      �
//� ----------- Elementos contidos por dimensao ------------     �
//� 1. Nome a aparecer no cabecalho                              �
//� 2. Nome da Rotina associada                                  �
//� 3. Usado pela rotina                                         �
//� 4. Tipo de Transa��o a ser efetuada                          �
//�    1 - Pesquisa e Posiciona em um Banco de Dados             �
//�    2 - Simplesmente Mostra os Campos                         �
//�    3 - Inclui registros no Bancos de Dados                   �
//�    4 - Altera o registro corrente                            �
//�    5 - Remove o registro corrente do Banco de Dados          �
//�    3 - Duplica o registro corrente do Banco de Dados         �
//����������������������������������������������������������������
Static Function MenuDef()
Local aRotina   := {	{'Pesquisar','AXPESQUI',0,1},;
				{'Visualizar','AXVISUAL',0,2},;
				{'Liberar','AXINCLUI',0,3},;
				{'Bloquear','U_CSCOMA6A()',0,4},;
				{'Legenda','U_CSCOMA6L()',0,9}}
Return aRotina
