#include "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ATFDEPTO � Autor � Leonardo Soncin    � Data �  15/01/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de Predio                                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico - CSU                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CAD_PREDIO()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local aRotina :=	{ {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Incluir","u_ZFInclui",0,3} ,;
             {"Alterar","u_ZFAltera",0,4} ,;
             {"Excluir","AxDeleta",0,5} }

Private cCadastro := "Cadastro de Pr�dio"

//���������������������������������������������������������������������Ŀ
//� Monta um aRotina proprio                                            �
//�����������������������������������������������������������������������

//Private aRotina := menudef() //

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "SZF"

dbSelectArea("SZF")
dbSetOrder(1)

dbSelectArea(cString)
mBrowse( 6,1,22,75,cString)

Return 

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ZFInclui � Autor � Leonardo S. Soncin � Data �  15/10/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao para Montagem da Tela de Inclusao                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico csu                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function ZFInclui()

_cAlias:= "SZF"
_nReg := Recno()
_nOpc := 3

_nOpca := AxInclui(_cAlias,_nReg,_nOpc, , , ,"U_INCZF()")

Return (_nOpca)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ZFInclui � Autor � Leonardo S. Soncin � Data �  15/10/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao para Montagem da Tela de Inclusao                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico csu                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function IncZF()   

Local _aVariaveis  :={}
Local _aEmpresas   :={"90"}   // Para quais empresas serao copiadas as informacoes
Local _aArea       :=GetArea()
Local _nNumEmp     :=Len(_aEmpresas)
Local _cEmprAutor  :=GetNewPar("MV_EMPRMAE","05")    // Empresa escolhida como empresa mae para cadastramentos

If (Ascan(_aEmpresas,cEmpAnt) = 0) .And. (cEmpAnt # _cEmprAutor) // Verifica se a Empresa atual esta autorizada fazer inclus�es 
	Return .t.
Endif 

DbSelectArea("SZC")
//��������������������������������������������������������������Ŀ
//� Carrega Variaveis de Memoria                                 �
//����������������������������������������������������������������
_nFCount :=FCount()

//For i:=1 to _nFCount
	AADD(_aVariaveis,{"ZC_FILIAL"	,M->ZF_FILIAL})
	AADD(_aVariaveis,{"ZC_CODIGO"	,M->ZF_CODIGO})
	AADD(_aVariaveis,{"ZC_DESCPRE"	,M->ZF_DESCPRE})
//Next

For x:=1 To _nNumEmp
	_cEmpresa :="SZC"+_aEmpresas[x]+"0"
	
	DBUSEAREA(.T.,"TOPCONN",_cEmpresa,_cEmpresa,.T.)
	TcCanOpen(_cEmpresa,_cEmpresa+"1")
	ORDLISTADD(_cEmpresa+"1")
	nPos := Ascan(_aVariaveis, {|aVal|aVal[1] == "ZC_CODIGO"})
	
	If MsSeek(xFilial("SZC")+_aVariaveis[nPos,2])
		MsgAlert("O Pr�dio "+_aVariaveis[nPos,2]+" ja existe no cadastro de pr�dio da empresa "+_aEmpresas[x]+". Contate o administrador.","ATEN��O")
    Else             
		_nItens :=Len(_aVariaveis)
		Reclock(_cEmpresa,.T.)
		FOR i := 1 TO _nItens
			if ascan(_aVariaveis,{|_vAux|_vAux[1]==FieldName(i)}) # 0
				&(_aVariaveis[i,1]) := _aVariaveis[i,2]
			Endif
		NEXT i
		MsUnlock()
	Endif
	DbCloseArea()
Next

RestArea(_aArea)

Return (.T.)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ZFInclui � Autor � Leonardo S. Soncin � Data �  15/10/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao para Montagem da Tela de Inclusao                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico csu                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function ZFAltera()

_cAlias:= "SZF"
_nReg := Recno()
_nOpc := 4

_nOpca := AxAltera(_cAlias,_nReg,_nOpc)

xAlteraZF()

Return (_nOpca)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � M030INC  � Autor � Leonardo Soncin    � Data �  17/10/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Objetivo: Replicar as informacoes do centro de custo       ���
���          � incluidas alteradas ou excluidas nas empresa 02 para as    ���
���          � empresas 03,04,09 e 90                                     ���
�������������������������������������������������������������������������͹��
���Uso       � AP5 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������                                           
/*/

Static Function xAlteraZF()

Local _aVariaveis  :={}
Local _aEmpresas   :={"90"}  // Para quais empresas serao copiadas as informacoes
Local _aArea       :=GetArea()
Local _nNumEmp     :=Len(_aEmpresas)
Local _cEmprAutor  :=GetNewPar("MV_EMPRMAE","05")    // Empresa escolhida como empresa mae para cadastramentos

If (Ascan(_aEmpresas,cEmpAnt) = 0) .And. (cEmpAnt # _cEmprAutor) // Verifica se a Empresa atual esta autorizada fazer inclus�es 
	Return .t.
Endif

DbSelectArea("SZC")
//��������������������������������������������������������������Ŀ
//� Carrega Variaveis de Memoria                                 �
//����������������������������������������������������������������
_nFCount :=FCount()

	AADD(_aVariaveis,{"ZC_FILIAL"	,SZF->ZF_FILIAL})
	AADD(_aVariaveis,{"ZC_CODIGO"	,SZF->ZF_CODIGO})
	AADD(_aVariaveis,{"ZC_DESCPRE"	,SZF->ZF_DESCPRE})

For x:=1 To _nNumEmp
	_cEmpresa :="SZC"+_aEmpresas[x]+"0"
	
	DBUSEAREA(.T.,"TOPCONN",_cEmpresa,_cEmpresa,.T.)   
	TcCanOpen(_cEmpresa,_cEmpresa+"1")
	ORDLISTADD(_cEmpresa+"1")
	nPos := Ascan(_aVariaveis, {|aVal|aVal[1] == "ZC_CODIGO"})
	
	If !MsSeek(xFilial("SZC")+_aVariaveis[nPos,2])
		MsgAlert("O Pr�dio "+_aVariaveis[nPos,2]+" n�o existe no cadastro de pr�dio da empresa "+_aEmpresas[x]+". Contate o administrador.","ATEN��O")
    Else
		_nItens :=Len(_aVariaveis)
		Reclock(_cEmpresa,.F.)
		FOR i := 1 TO _nItens
			if ascan(_aVariaveis,{|_vAux|_vAux[1]==FieldName(i)}) # 0
				&(_aVariaveis[i,1]) := _aVariaveis[i,2]
			Endif
		NEXT i
		MsUnlock()
	Endif
	DbCloseArea()
Next

RestArea(_aArea)

Return .T.

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
Local aRotina :=	{ {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Incluir","u_ZFInclui",0,3} ,;
             {"Alterar","u_ZFAltera",0,4} ,;
             {"Excluir","AxDeleta",0,5} }

Return aRotina
