/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FunTab   � Autor � Sergio Oliveira       � Data � 02/2003  ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao � Permite liberar ao usuario a manutencao de uma determinada  ��
���          � tabela conforme os parametros.                              ��
�������������������������������������������������������������������������͹��
���Sintaxe   � U_FunTab(Codigo da Tabela)                                 ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Generico.                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FunTab(zTabela)

_cArqTrb := CriaTrab(nil, .f.)
_cFiltro := "X5_FILIAL == xFilial('SX5') .And. X5_TABELA == '"+ zTabela +"' "

DbSelectArea("SX5")
If DbSeek(xFilial("SX5")+"00"+zTabela)
	zDescTab := SX5->X5_DESCRI
Else
	zDescTab := 'Sem Descricao'
EndIf

cCadastro := zDescTab
xTabela   := zTabela

If !Eof()
    aRotina := Menudef1()
//	aRotina := {  { "Pesquisar" ,"AxPesqui" , 0 , 1 } , ;
//	{ "Visualizar","U_FunTabaa(2,xTabela, cCadastro)", 0 , 2 } , ;
//	{ "Alterar"   ,"U_FunTabaa(4,xTabela, cCadastro)", 0 , 4 } }
Else                     
    aRotina := Menudef2()
//	aRotina := {  { "Pesquisar" ,"AxPesqui" , 0 , 1 } , ;
//	{ "Visualizar","U_FunTabaa(2,xTabela, cCadastro)", 0 , 2 } , ;
//	{ "Incluir"   ,"U_FunTabaa(3,xTabela, cCadastro)", 0 , 3 } , ;
//	{ "Alterar"   ,"U_FunTabaa(4,xTabela, cCadastro)", 0 , 4 } }
EndIf

Set Filter To &_cFiltro

MBrowse(6,1,22,75,"SX5")

Set Filter To

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FunTaba  � Autor � Sergio Oliveira       � Data � 02/2003  ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao � Funcao chamada pela FunTab() que consta neste mesmo programa��
�������������������������������������������������������������������������Ĵ��
���Uso       � FunTab().                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FunTabaa(nopcx,zTabela,zDescTab)

//+--------------------------------------------------------------+
//� Opcao de acesso para o Modelo 2                              �
//+--------------------------------------------------------------+
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza
//+--------------------------------------------------------------+
//� Montando aHeader                                             �
//+--------------------------------------------------------------+

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SX5")

aHeader := {}
nUsado  := 0

While !Eof() .And. (X3_ARQUIVO == "SX5")
	If X3Uso(X3_USADO) .AND. cNivel >= X3_NIVEL
		If (AllTrim(X3_CAMPO) $ "X5_CHAVE*X5_DESCRI")
			nUsado := nUsado + 1
			AADD(aHeader,{ TRIM(X3_TITULO), X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL,;
			"!Empty(M->" + AllTrim(X3_CAMPO) + ")", X3_USADO  , X3_TIPO,;
			X3_ARQUIVO, X3_CONTEXTO })
		EndIf
	Endif
	dbSkip()
End

dbSelectArea("SX5")
dbSetOrder(1)

//+--------------------------------------------------------------+
//� Variaveis do Cabecalho do Modelo 2                           �
//+--------------------------------------------------------------+

cTabela  := zTabela
cDescri  := zDescTab

//��������������������������������������������������������������Ŀ
//� Posiciona os itens da tabela conforme a filial corrente      �
//����������������������������������������������������������������
DbSelectArea("SX5")
DbGoTop()
//+--------------------------------------------------------------+
//� Montando aCols                                               �
//+--------------------------------------------------------------+

aCols    := {}

While !Eof() .And. SX5->X5_FILIAL == xFilial("SX5") .And. SX5->X5_TABELA == cTabela
	Aadd(aCols, Array(nUsado+1))
	For nQ :=1 To nUsado
		aCols[Len(aCols),nQ] := FieldGet(FieldPos(aHeader[nQ,2]))
	Next
	aCols[Len(aCols),nUsado + 1] := .F.
	dbSkip()
End Do

If Len(aCols) == 0
	AADD(aCols,Array(nUsado+1))
	For nQ := 1 To nUsado
		aCols[Len(aCols),nQ] := CriaVar(FieldName(FieldPos(aHeader[nQ,2])))
	Next
	aCols[Len(aCols),nUsado+1] := .F.
EndIf

//+--------------------------------------------------------------+
//� Variaveis do Rodape do Modelo 2                              �
//+--------------------------------------------------------------+

nLinGetD :=0

//+--------------------------------------------------------------+
//� Titulo da Janela                                             �
//+--------------------------------------------------------------+

cTitulo := cDescri

//+--------------------------------------------------------------+
//� Array com descricao dos campos do Cabecalho do Modelo 2      �
//+--------------------------------------------------------------+

aC := {}

AADD(aC, {"cTabela", {20,05}, "Chave " , "@!", "", "", .f.})
AADD(aC, {"cDescri", {20,80}, "Tabela" , "@!", " ", "", .f.})
//+--------------------------------------------------------------+
//� Array com descricao dos campos do Rodape do Modelo 2         �
//+--------------------------------------------------------------+
aR := {}

//+--------------------------------------------------------------+
//� Array com coordenadas da GetDados no modelo2                 �
//+--------------------------------------------------------------+

aCGD := {44,5,118,315}

//+--------------------------------------------------------------+
//� Validacoes na GetDados da Modelo 2                           �
//+--------------------------------------------------------------+

cLinhaOk := "AllwaysTrue()"
cTudoOk  := "AllwaysTrue()"

//+--------------------------------------------------------------+
//� Chamada da Modelo2                                           �
//+--------------------------------------------------------------+

n:=1
If Modelo2(cTitulo, aC, aR, aCGD, nOpcx, cLinhaOk, cTudoOk)
	
	DbSelectArea("SX5")
	DbSetOrder(1)
	For n := 1 To Len(aCols)
		If aCols[n, Len(aHeader) + 1]
			DbSelectArea("SX5")
			If dbSeek(xFilial("SX5") + cTabela + aCols[n,1])
				RecLock("SX5",.F.)
				dbDelete()
				MsUnLock()
			EndIf
		Else
			DbSelectArea("SX5")
			If dbSeek(xFilial("SX5") + cTabela + aCols[n,1] )
				RecLock("SX5",.f.)
				SX5->X5_CHAVE   := aCols[n,1]
				SX5->X5_DESCRI  := aCols[n,2]
				SX5->X5_DESCSPA := aCols[n,2]
				SX5->X5_DESCENG := aCols[n,2]
				MsUnlock()
			Else
				RecLock("SX5",.t.)
				SX5->X5_FILIAL  := xFilial("SX5")
				SX5->X5_TABELA  := cTabela
				SX5->X5_CHAVE   := aCols[n,1]
				SX5->X5_DESCRI  := aCols[n,2]
				SX5->X5_DESCSPA := aCols[n,2]
				SX5->X5_DESCENG := aCols[n,2]
				Msunlock()
			EndIf
		Endif
	Next
	
Endif

Return

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
Static Function MenuDef1()
Local 	aRotina := {  { "Pesquisar" ,"AxPesqui" , 0 , 1 } , ;
	{ "Visualizar","U_FunTabaa(2,xTabela, cCadastro)", 0 , 2 } , ;
	{ "Alterar"   ,"U_FunTabaa(4,xTabela, cCadastro)", 0 , 4 } }

Return aRotina


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
Static Function MenuDef2()
Local 	aRotina := {  { "Pesquisar" ,"AxPesqui" , 0 , 1 } , ;
	{ "Visualizar","U_FunTabaa(2,xTabela, cCadastro)", 0 , 2 } , ;
	{ "Incluir"   ,"U_FunTabaa(3,xTabela, cCadastro)", 0 , 3 } , ;
	{ "Alterar"   ,"U_FunTabaa(4,xTabela, cCadastro)", 0 , 4 } }

Return aRotina
